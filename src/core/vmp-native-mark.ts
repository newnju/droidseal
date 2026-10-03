// P3 里程碑 B(1/3):ACC_NATIVE 写入 + VM 桥表解析(vmp-native-mark.ts)。
// 语义:对壳 DEX 中「VM 编译成功且 JNI 签名恰为 (I)I」的方法做 native 化标记——
//   access_flags |= ACC_NATIVE(0x0100),code_off → 0(native 方法规范要求)。
// 关键不变量:等长原地补丁。壳 DEX 的全部偏移(restoreCode 定位、CodeItem 表
// originalCodeOff、payload 边界)都依赖布局不变;uleb128 变长用「非规范编码补位」
// 平衡:access 变长多少,code_off 的 0 编码就补长多少,方法条目总字节数恒定,
// 后续条目的 method_idx_diff 相对编码不受影响。
// 诚实边界:注册入口是 Java 可调用的 dsvmRegisterAll(JNI_OnLoad 时 app 类未加载,
// RegisterNatives 必败);未过 device-test.sh --vm-mode 真机验收前 vmProtected 恒 false。
// 纯 TypeScript,失败关闭(无法平衡长度即 throw,绝不产出错位 DEX)。
import { writeUleb128, readUleb128 } from "./dex-codec.ts"
import { updateDexChecksum } from "./string-encrypt-writeback.ts"

export const ACC_NATIVE = 0x0100

// DEX header 偏移(与 dex-protection 的私有 parseDexHeader 同布局;本地最小解析,
// 不为此扩公共 API 面——本模块只需要 string/type/proto/method/class_defs 六组)
const OFF_STRING_IDS_SIZE = 0x38
const OFF_STRING_IDS_OFF = 0x3c
const OFF_TYPE_IDS_OFF = 0x44
const OFF_PROTO_IDS_SIZE = 0x48
const OFF_PROTO_IDS_OFF = 0x4c
const OFF_METHOD_IDS_SIZE = 0x58
const OFF_METHOD_IDS_OFF = 0x5c
const OFF_CLASS_DEFS_SIZE = 0x60
const OFF_CLASS_DEFS_OFF = 0x64

interface DexHeaderLite {
  stringIdsSize: number
  stringIdsOff: number
  typeIdsOff: number
  protoIdsSize: number
  protoIdsOff: number
  methodIdsSize: number
  methodIdsOff: number
  classDefsSize: number
  classDefsOff: number
}

function parseDexHeaderLite(dex: Uint8Array): DexHeaderLite {
  const v = new DataView(dex.buffer, dex.byteOffset, dex.byteLength)
  return {
    stringIdsSize: v.getUint32(OFF_STRING_IDS_SIZE, true),
    stringIdsOff: v.getUint32(OFF_STRING_IDS_OFF, true),
    typeIdsOff: v.getUint32(OFF_TYPE_IDS_OFF, true),
    protoIdsSize: v.getUint32(OFF_PROTO_IDS_SIZE, true),
    protoIdsOff: v.getUint32(OFF_PROTO_IDS_OFF, true),
    methodIdsSize: v.getUint32(OFF_METHOD_IDS_SIZE, true),
    methodIdsOff: v.getUint32(OFF_METHOD_IDS_OFF, true),
    classDefsSize: v.getUint32(OFF_CLASS_DEFS_SIZE, true),
    classDefsOff: v.getUint32(OFF_CLASS_DEFS_OFF, true),
  }
}

/** VM 桥表条目:RegisterNatives 需要的 (类, 方法名, JNI 签名, method_idx) */
export interface VmBridgeEntry {
  /** 类描述符 → 点分路径(com/droidseal/.../MainActivity) */
  className: string
  methodName: string
  /** JNI 签名,里程碑 B 仅收 (I)I */
  signature: string
  methodIdx: number
}

interface MethodEntryPatch {
  methodIdx: number
  /** access_flags uleb128 字节起点 */
  accOff: number
  accLen: number
  accValue: number
  /** code_off uleb128 字节起点 */
  codeOff: number
  codeLen: number
}

/**
 * 解析壳 DEX 的 class_data,收集 methodIdx ∈ vmMethodIdxs 的方法条目字节位置。
 * 与 hollowMethods 的解析逻辑同构(字段列表跳过 + diff 编码方法索引)。
 */
function collectPatchSites(
  dex: Uint8Array,
  vmMethodIdxs: Set<number>,
): MethodEntryPatch[] {
  const v = new DataView(dex.buffer, dex.byteOffset, dex.byteLength)
  const header = parseDexHeaderLite(dex)
  const sites: MethodEntryPatch[] = []
  for (let c = 0; c < header.classDefsSize; c += 1) {
    const cdOff = v.getUint32(header.classDefsOff + c * 32 + 24, true)
    if (!cdOff) continue
    // class_data 头:static_fields/instance_fields/direct_methods/virtual_methods 计数
    const counts: number[] = []
    let p = cdOff
    for (let i = 0; i < 4; i += 1) {
      const r = readUleb128(dex, p)
      p = r.next
      counts.push(r.value)
    }
    for (let fi = 0; fi < counts[0]! + counts[1]!; fi += 1) {
      p = readUleb128(dex, p).next // field_idx_diff
      p = readUleb128(dex, p).next // access_flags
    }
    let mIdx = 0
    for (const methodCount of [counts[2]!, counts[3]!]) {
      for (let m = 0; m < methodCount; m += 1) {
        const diff = readUleb128(dex, p)
        p = diff.next
        mIdx += diff.value
        const acc = readUleb128(dex, p)
        const accStart = p
        p = acc.next
        const code = readUleb128(dex, p)
        const codeStart = p
        p = code.next
        if (vmMethodIdxs.has(mIdx)) {
          sites.push({ methodIdx: mIdx, accOff: accStart, accLen: acc.next - accStart, accValue: acc.value, codeOff: codeStart, codeLen: code.next - codeStart })
        }
      }
    }
  }
  return sites
}

/**
 * 等长回填一个方法条目:access |= ACC_NATIVE,code_off = 0(非规范补位)。
 * 返回 null 表示无法平衡(失败关闭,调用方放弃标记该条目)。
 */
function patchEntry(dex: Uint8Array, site: MethodEntryPatch): boolean {
  const newAcc = site.accValue | ACC_NATIVE
  const accEnc = writeUleb128(newAcc)
  // code_off=0 的编码长度 = 条目总长 - access 编码长;必须 ≥1 且能表达 0
  const totalLen = site.accLen + site.codeLen
  const codePadLen = totalLen - accEnc.length
  if (accEnc.length > totalLen || codePadLen < 1) return false
  // 非规范 uleb128 编码 0:前 n-1 字节 0x80(续位),末字节 0x00——解码值为 0
  const codeEnc = new Array<number>(codePadLen).fill(0x80)
  codeEnc[codePadLen - 1] = 0x00
  // 写入顺序关键:access 变长时与原 code_off 区间重叠——先把 code 补位写到
  // 条目尾部对齐的位置(accOff+accEnc.length),再写 access,避免互踩。
  dex.set(codeEnc, site.accOff + accEnc.length)
  dex.set(accEnc, site.accOff)
  return true
}

/**
 * 对壳 DEX 做等长 native 标记(原地写回新数组,不改输入)。
 * 返回标记数量;任一条目无法平衡时该条目如实跳过(计入 skipped)——
 * 绝不为凑数产出错位 DEX。调用方以返回值决定桥表内容(只注册标记成功的方法)。
 */
export function markVmMethodsNative(
  dexBytes: Uint8Array,
  vmMethodIdxs: number[],
): { dex: Uint8Array; marked: number[]; skipped: number[] } {
  const out = new Uint8Array(dexBytes)
  const sites = collectPatchSites(out, new Set(vmMethodIdxs))
  const marked: number[] = []
  const skipped: number[] = []
  for (const site of sites) {
    // 已是 native 的条目跳过(幂等)
    if (site.accValue & ACC_NATIVE) { marked.push(site.methodIdx); continue }
    if (patchEntry(out, site)) marked.push(site.methodIdx)
    else skipped.push(site.methodIdx)
  }
  // updateDexChecksum 返回修复后的副本(sha1+adler32 顺序敏感),必须采用返回值
  return { dex: updateDexChecksum(out), marked, skipped }
}

// ── VM 桥表解析:methodIdx → (类, 方法名, JNI 签名) ─────────────────────

/**
 * 从 DEX 解析 VM 编译方法的注册元组。
 * 只收 JNI 签名恰为 "(I)I" 的方法(里程碑 B 的 thunk 固定 (JNIEnv*, jclass, jint),
 * 其他签名注册即参数错位——如实排除,保持 stub+惰性还原路径)。
 */
export function resolveVmBridgeEntries(
  dexBytes: Uint8Array,
  compiledMethodIdxs: number[],
): { entries: VmBridgeEntry[]; excluded: number[] } {
  const v = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const header = parseDexHeaderLite(dexBytes)
  const readStr = (idx: number): string => {
    if (idx >= header.stringIdsSize) return ""
    const strOff = v.getUint32(header.stringIdsOff + idx * 4, true)
    // MUTF-8:uleb128 长度前缀 + 数据(此处方法名/短签名为 ASCII,按字节直读)
    const len = readUleb128(dexBytes, strOff).value
    let s = ""
    for (let i = 0; i < len; i += 1) {
      const b = dexBytes[strOff + 1 + i] ?? 0
      if (b === 0) break
      s += String.fromCharCode(b)
    }
    return s
  }
  const entries: VmBridgeEntry[] = []
  const excluded: number[] = []
  for (const methodIdx of compiledMethodIdxs) {
    if (methodIdx >= header.methodIdsSize) { excluded.push(methodIdx); continue }
    const base = header.methodIdsOff + methodIdx * 8
    const classTypeIdx = v.getUint16(base, true)
    const protoIdx = v.getUint16(base + 2, true)
    const nameIdx = v.getUint32(base + 4, true)
    // proto_ids: shortyIdx(u32) returnTypeIdx(u32) parametersOff(u32)
    if (protoIdx >= header.protoIdsSize) { excluded.push(methodIdx); continue }
    const protoBase = header.protoIdsOff + protoIdx * 12
    const returnTypeIdx = v.getUint32(protoBase + 4, true)
    const paramsOff = v.getUint32(protoBase + 8, true)
    const retType = typeDesc(dexBytes, v, header.typeIdsOff, header.stringIdsSize, readStr, returnTypeIdx)
    const params: string[] = []
    if (paramsOff !== 0) {
      const size = v.getUint32(paramsOff, true)
      for (let i = 0; i < size; i += 1) {
        params.push(typeDesc(dexBytes, v, header.typeIdsOff, header.stringIdsSize, readStr, v.getUint16(paramsOff + 4 + i * 2, true)))
      }
    }
    const signature = `(${params.join("")})${retType}`
    if (signature !== "(I)I") { excluded.push(methodIdx); continue }
    const classDesc = typeDesc(dexBytes, v, header.typeIdsOff, header.stringIdsSize, readStr, classTypeIdx)
    entries.push({
      className: classDesc.replace(/^L/, "").replace(/;$/, ""),
      methodName: readStr(nameIdx),
      signature,
      methodIdx,
    })
  }
  return { entries, excluded }
}

function typeDesc(
  dex: Uint8Array,
  v: DataView,
  typeIdsOff: number,
  _stringIdsSize: number,
  readStr: (idx: number) => string,
  typeIdx: number,
): string {
  const descIdx = v.getUint32(typeIdsOff + typeIdx * 4, true)
  return readStr(descIdx)
}
