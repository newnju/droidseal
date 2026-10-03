// P3: 加固对照组产物(dpt-shell --dump-code / DexVMP mapping.txt 同型产物)。
// 1) dump-code:抽取的 CodeItem 落 JSON——类/方法名解析自 string/type/proto/method_ids
//    表(方法抽取只原位改写 code_item,不动这四张表,hollowed dex 上解析与原 dex 等价),
//    用于排查"方法还原失败/抽错方法"。
// 2) mapping.txt:壳类名与固定标识符随机化的 原值→新值 映射——崩溃栈/日志还原用。
// 两者均为旁路产物,不进 APK;丢失不影响运行,只影响排查。

export interface DumpCodeEntry {
  classDescriptor: string
  methodName: string
  proto: string
  codeOff: number
  codeSize: number
  /** CodeItem 原始字节 hex(与 payload 容器 citable 条目内的密文解密后一致) */
  codeHex: string
}

/** uleb128 长度前缀 + MUTF-8(0x00 编码为 C0 80,2-3 字节续位) */
function readDexStringAt(bytes: Uint8Array, off: number): string {
  if (off >= bytes.length) return "?"
  let p = off
  let shift = 0
  let size = 0
  for (;;) {
    const b = bytes[p]
    if (b === undefined) return "?"
    p += 1
    size |= (b & 0x7f) << shift
    if ((b & 0x80) === 0) break
    shift += 7
  }
  const out: number[] = []
  const end = Math.min(bytes.length, p + size)
  while (p < end) {
    const b0 = bytes[p]!
    if (b0 < 0x80) { out.push(b0); p += 1 }
    else if (b0 < 0xe0) { out.push(((b0 & 0x1f) << 6) | (bytes[p + 1]! & 0x3f)); p += 2 }
    else { out.push(((b0 & 0x0f) << 12) | ((bytes[p + 1]! & 0x3f) << 6) | (bytes[p + 2]! & 0x3f)); p += 3 }
  }
  return String.fromCharCode(...out)
}

function toHex(b: Uint8Array): string {
  return [...b].map((x) => x.toString(16).padStart(2, "0")).join("")
}

/**
 * 从(hollowed 或原始)DEX 解析抽取方法的可读信息。
 * @param dexBytes DEX 字节(建议 hollowedDex——与壳内表状态一致)
 * @param stubs hollowResult.stubMethods
 * @param items hollowResult.extractedCodeItems(key = originalCodeOff)
 */
export function dumpExtractedCodeItems(
  dexBytes: Uint8Array,
  stubs: ReadonlyArray<{ classIdx: number; methodIdx: number; originalCodeOff: number; originalCodeSize: number }>,
  items: ReadonlyMap<number, Uint8Array>,
): DumpCodeEntry[] {
  if (dexBytes.length < 0x70) return []
  const v = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const u32 = (o: number): number => v.getUint32(o, true)
  const strIdsSize = u32(56); const strIdsOff = u32(60)
  const typeIdsSize = u32(64); const typeIdsOff = u32(68)
  const protoIdsSize = u32(72); const protoIdsOff = u32(76)
  const methodIdsSize = u32(88); const methodIdsOff = u32(92)
  const strAt = (i: number): string => (i < strIdsSize ? readDexStringAt(dexBytes, u32(strIdsOff + i * 4)) : "?")
  const typeAt = (i: number): string => (i < typeIdsSize ? strAt(u32(typeIdsOff + i * 4)) : "?")
  const protoAt = (i: number): string => {
    if (i >= protoIdsSize) return "?"
    const base = protoIdsOff + i * 12
    const ret = typeAt(u32(base + 4))
    const paramsOff = u32(base + 8)
    const params: string[] = []
    if (paramsOff !== 0) {
      const n = u32(paramsOff)
      // type_list 条目是 u16(此前误用 u32:k=0 时把 entries[0]|entries[1]<<16
      // 拼成越界索引 → 参数全解成 "?",如 (??)[B)
      for (let k = 0; k < n; k += 1) params.push(typeAt(v.getUint16(paramsOff + 4 + k * 2, true)))
    }
    return `(${params.join("")})${ret}`
  }
  const out: DumpCodeEntry[] = []
  for (const s of stubs) {
    if (s.methodIdx >= methodIdsSize) continue
    const base = methodIdsOff + s.methodIdx * 8
    // method_id_item: class_idx(u16) + proto_idx(u16) + name_idx(u32)
    const code = items.get(s.originalCodeOff)
    out.push({
      classDescriptor: typeAt(v.getUint16(base, true)),
      methodName: strAt(u32(base + 4)),
      proto: protoAt(v.getUint16(base + 2, true)),
      codeOff: s.originalCodeOff,
      codeSize: s.originalCodeSize,
      codeHex: code ? toHex(code) : "",
    })
  }
  return out
}

// ── mapping.txt(壳名/标识符随机化映射) ────────────────────────────────

export interface MappingRecord {
  kind: "loader-class" | "identifier"
  from: string
  to: string
}

/** ProGuard 风格映射文本(带 kind 前缀;随构建归档) */
export function serializeMappingTxt(records: readonly MappingRecord[]): string {
  const head = [
    "# DroidSeal mapping",
    "# 壳类名/固定标识符随机化映射——崩溃栈与日志还原用。",
    "# 与该构建一一对应,请随产物归档;丢失不影响运行,只影响排查。",
  ]
  const lines = records.map((r) => `${r.kind}: ${r.from} -> ${r.to}`)
  return [...head, ...lines, ""].join("\n")
}
