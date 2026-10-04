// DEX 加密保护核心模块（#1 #2 #3 #5 #6 #9 #10 #11）。
// 方法抽取(Method Hollowing):挖空 CodeItem,运行时 ART DefineClass 钩子还原。
// DEX 整体加密: AES-256-GCM / ChaCha20-Poly1305。
// 隐写式存储:加密 payload 追加到 classes.dex file_size 边界外。
// 三重入口:ComponentFactory > ContentProvider > Application。
// 纯 TypeScript,使用 node:crypto。
import { createCipheriv, createDecipheriv, randomBytes, createHash } from "node:crypto"
import type { Finding } from "./types.ts"

const DEX_MAGIC = [0x64, 0x65, 0x78, 0x0a]
const DEX_HEADER_SIZE = 0x70

interface DexHeader {
  fileSize: number
  stringIdsSize: number; stringIdsOff: number
  typeIdsSize: number; typeIdsOff: number
  methodIdsSize: number; methodIdsOff: number
  classDefsSize: number; classDefsOff: number
}

function parseDexHeader(bytes: Uint8Array): DexHeader {
  if (bytes.length < DEX_HEADER_SIZE) throw new Error("DEX too small")
  for (let i = 0; i < 4; i += 1) { if (bytes[i] !== DEX_MAGIC[i]) throw new Error("Not a DEX file") }
  const v = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => v.getUint32(o, true)
  return { fileSize: u32(32), stringIdsSize: u32(56), stringIdsOff: u32(60), typeIdsSize: u32(64), typeIdsOff: u32(68), methodIdsSize: u32(88), methodIdsOff: u32(92), classDefsSize: u32(96), classDefsOff: u32(100) }
}

function updateDexChecksum(bytes: Uint8Array): void {
  // 顺序必须:先写 SHA-1 签名(覆盖 bytes[32..]),再算 adler32(覆盖 bytes[12..],含新签名)。
  // 反过来先算校验和再写签名,签名一落盘校验和即失效,ART 报 Bad checksum 拒载(SEC-010)。
  bytes.set(new Uint8Array(createHash("sha1").update(bytes.slice(32)).digest()), 12)
  let a = 1, b = 0
  for (let i = 12; i < bytes.length; i += 1) { a = (a + bytes[i]!) % 65521; b = (b + a) % 65521 }
  new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength).setUint32(8, ((b << 16) | a) >>> 0, true)
}

export interface EncryptedPayload { ciphertext: Uint8Array; nonce: Uint8Array; tag: Uint8Array }

// 加密分块上限(512MB):避开 Node/Bun crypto 单次 update 的 2GB Buffer 参数上限
const CIPHER_CHUNK = 512 * 1024 * 1024

type AeadCipher = ReturnType<typeof createCipheriv>

function chunkedUpdate(cipher: AeadCipher, data: Uint8Array): Buffer {
  const parts: Buffer[] = []
  for (let off = 0; off < data.length; off += CIPHER_CHUNK) {
    parts.push(cipher.update(data.subarray(off, Math.min(off + CIPHER_CHUNK, data.length))))
  }
  return Buffer.concat(parts)
}

export function encryptAes256Gcm(plaintext: Uint8Array, key: Uint8Array, nonce: Uint8Array): EncryptedPayload {
  const cipher = createCipheriv("aes-256-gcm", key, nonce)
  const enc = Buffer.concat([chunkedUpdate(cipher, plaintext), cipher.final()])
  return { ciphertext: new Uint8Array(enc), nonce, tag: new Uint8Array(cipher.getAuthTag()) }
}

export function decryptAes256Gcm(p: EncryptedPayload, key: Uint8Array): Uint8Array {
  const d = createDecipheriv("aes-256-gcm", key, p.nonce); d.setAuthTag(p.tag)
  return new Uint8Array(Buffer.concat([d.update(p.ciphertext), d.final()]))
}

export function encryptChaCha20Poly1305(plaintext: Uint8Array, key: Uint8Array, nonce: Uint8Array): EncryptedPayload {
  const cipher = createCipheriv("chacha20-poly1305", key, nonce, { authTagLength: 16 })
  const enc = Buffer.concat([chunkedUpdate(cipher, plaintext), cipher.final()])
  return { ciphertext: new Uint8Array(enc), nonce, tag: new Uint8Array(cipher.getAuthTag()) }
}

export function decryptChaCha20Poly1305(p: EncryptedPayload, key: Uint8Array): Uint8Array {
  const d = createDecipheriv("chacha20-poly1305", key, p.nonce, { authTagLength: 16 }); d.setAuthTag(p.tag)
  return new Uint8Array(Buffer.concat([d.update(p.ciphertext), d.final()]))
}

// ── 方法抽取(#1) ──────────────────────────────────────────────────────
function readUleb128(b: Uint8Array, s: number): { value: number; next: number } {
  let p = s, r = 0, sh = 0
  for (let i = 0; i < 5; i += 1) { const v = b[p++]!; r |= (v & 0x7f) << sh; if (!(v & 0x80)) break; sh += 7 }
  return { value: r >>> 0, next: p }
}
function readUleb128Arr(b: Uint8Array, s: number, n: number): { values: number[]; next: number } {
  const vals: number[] = []; let p = s
  for (let i = 0; i < n; i += 1) { const r = readUleb128(b, p); vals.push(r.value); p = r.next }
  return { values: vals, next: p }
}
function readDexString(b: Uint8Array, off: number): string {
  let p = off; while (p < b.length && (b[p]! & 0x80)) p += 1; p += 1; let e = p
  while (e < b.length && b[e] !== 0) e += 1
  return new TextDecoder("utf-8", { fatal: false }).decode(b.slice(p, e))
}
// SEC-011:足迹不变的抽取 stub。把原 code_item 的 insns_size 保留,指令区首 2 字节写
// return-void(0x000e),其余写 nop(0x0000)填充。item 字节足迹与原始完全一致:
// 后续 code_item 偏移/对齐不变,不留"节区前非零 padding"(ART 严格校验:
// Non-zero padding before section start → 拒载),恢复逻辑(按 originalCodeSize 整块
// 覆盖)也不需要改动。stubs 里的 originalCodeSize 仍为完整 item 尺寸(含 tries)。
function writeFootprintPreservingStub(out: Uint8Array, codeOff: number, insnsSize: number): void {
  const v = new DataView(out.buffer, out.byteOffset, out.byteLength)
  // registers_size / ins_size / outs_size / tries_size(0x8..0xF)/ debug_info_off 保持原值?
  // —— tries_size 必须清零:insns 区已不含 try/catch,若保留 tries_size,
  // tries/ handler 数据会指向已被 nop 填充覆盖的旧位置,ART 校验 handler_off 失败。
  v.setUint32(codeOff + 8, 0, true)          // tries_size = 0
  v.setUint32(codeOff + 12, insnsSize, true) // insns_size 保持原值(足迹不变)
  v.setUint16(codeOff + 16, 0x000e, true)    // return-void
  for (let i = 1; i < insnsSize; i += 1) v.setUint16(codeOff + 16 + i * 2, 0x0000, true) // nop 填充
  // padding 到 4 字节对齐(若 insnsSize 为奇数,DEX 规范要求补 2 字节 nop——原 item 已对齐,此处保持)
  // padding 空间落在原 item 的 insns 区内(足迹不变),无需额外清零
}

export interface HollowedMethod { classIdx: number; methodIdx: number; originalCodeOff: number; originalCodeSize: number }
export interface MethodHollowResult { hollowedDex: Uint8Array; extractedCodeItems: Map<number, Uint8Array>; stubMethods: HollowedMethod[]; summary: { totalMethods: number; hollowedMethods: number; skippedMethods: number; extractedBytes: number } }

export function hollowMethods(dexBytes: Uint8Array, excludePatterns: RegExp[] = []): MethodHollowResult {
  const header = parseDexHeader(dexBytes)
  const v = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const extracted = new Map<number, Uint8Array>()
  const stubs: HollowedMethod[] = []
  const strings: string[] = []; for (let i = 0; i < Math.min(header.stringIdsSize, 1 << 20); i += 1) strings.push(readDexString(dexBytes, v.getUint32(header.stringIdsOff + i * 4, true)))
  const types: string[] = []; for (let i = 0; i < Math.min(header.typeIdsSize, 1 << 20); i += 1) types.push(strings[v.getUint32(header.typeIdsOff + i * 4, true)] ?? "")
  const out = new Uint8Array(dexBytes)
  let total = 0, hollowed = 0, skipped = 0, extractedBytes = 0
  // 权威校验:method_ids 按 class_idx 排序,每个类的 methodIdx 区间必然连续。
  // class_data 解析一旦漂移(旧 bug:字段/方法条目交错解析错位),mIdx 会落到
  // 无关类(如 Ljava/net/URL;)——逐条目校验区间,漂移即如实跳过(fail-closed,
  // 不产出错位 stub:错位 stub 会让 dump-code/恢复链/桥表全部指错方法)。
  const methodRuns = new Map<number, { first: number; last: number }>()
  for (let mi = 0; mi < header.methodIdsSize; mi += 1) {
    const cls = v.getUint16(header.methodIdsOff + mi * 8, true)
    const r = methodRuns.get(cls)
    if (r) r.last = mi
    else methodRuns.set(cls, { first: mi, last: mi })
  }
  for (let c = 0; c < header.classDefsSize; c += 1) {
    const cdOff = v.getUint32(header.classDefsOff + c * 32 + 24, true); if (!cdOff) continue
    const clsIdx = v.getUint32(header.classDefsOff + c * 32, true)
    const cls = types[clsIdx] ?? ""
    if (excludePatterns.some((p) => p.test(cls))) continue
    const run = methodRuns.get(clsIdx)
    // class_data_item 布局: static_fields + instance_fields + direct_methods + virtual_methods
    // 必须先跳过两个字段列表(每项 fieldIdx+accessFlags 各一个 uleb128),否则方法解析从字段数据开始 → 全部漂移
    const counts = readUleb128Arr(dexBytes, cdOff, 4); let p = counts.next; let mIdx = 0
    for (let fi = 0; fi < counts.values[0]! + counts.values[1]!; fi += 1) {
      const fIdx = readUleb128(dexBytes, p); p = fIdx.next
      const fAcc = readUleb128(dexBytes, p); p = fAcc.next
    }
    for (const mc of [counts.values[2]!, counts.values[3]!]) {
      for (let m = 0; m < mc; m += 1) {
        const diff = readUleb128(dexBytes, p); mIdx += diff.value; p = diff.next
        const access = readUleb128(dexBytes, p); p = access.next
        const code = readUleb128(dexBytes, p); p = code.next
        total += 1
        // 漂移检测:解析出的 methodIdx 超出本类在 method_ids 的权威区间 →
        // class_data 解析已错位,该类剩余条目全部不可信,如实跳过(fail-closed)
        if (run && (mIdx < run.first || mIdx > run.last)) { skipped += 1; continue }
        if (!code.value || (access.value & 0x100)) { skipped += 1; continue }
        // 构造器永不挖空:stub <init> 是纯 return-void,若 ART 从 base.apk 副本
        // (classloader 置换未覆盖的加载路径)验证该类,必报
        // "Constructor returning without calling superclass constructor" VerifyError。
        // 挖空收益只覆盖普通方法,构造器保持原方法体(如实降级,不计入防护)。
        const nameIdx = v.getUint32(header.methodIdsOff + mIdx * 8 + 4, true)
        const mName = strings[nameIdx] ?? ""
        if (mName === "<init>" || mName === "<clinit>") { skipped += 1; continue }
        const insnsSize = v.getUint32(code.value + 12, true); const sz = 16 + insnsSize * 2
        // 防护:code_item 越界或 insnsSize 为垃圾值(单方法指令区不超过 64K insns=128KB+16B 头)
        if (code.value + 16 > dexBytes.length || insnsSize > 0x10000 || code.value + sz > dexBytes.length) { skipped += 1; continue }
        // SEC-011a:带 try/catch(tries_size>0)的方法跳过抽取——恢复时需完整重建
        // tries/handler 表,当前恢复逻辑只整块覆盖 insns 区,恢复后方法会丢失异常表。
        // tries_size 是 u16(code_item +6;布局: registers_size@0 ins_size@2 outs_size@4
        // tries_size@6 debug_info_off@8 insns_size@12——此前先误用 getUint32(+8)、再误用
        // getUint16(+8),实际 +8 是 debug_info_off 低半段,所有方法被误判带 try 全跳过)
        const triesSize = v.getUint16(code.value + 6, true)
        if (triesSize > 0) { skipped += 1; continue }
        extracted.set(code.value, dexBytes.slice(code.value, code.value + sz)); extractedBytes += sz
        // SEC-011b:足迹不变 stub(保留 insns_size、nop 填充,不留非零 padding)
        writeFootprintPreservingStub(out, code.value, insnsSize)
        stubs.push({ classIdx: v.getUint32(header.classDefsOff + c * 32, true), methodIdx: mIdx, originalCodeOff: code.value, originalCodeSize: sz }); hollowed += 1
      }
    }
  }
  updateDexChecksum(out)
  return { hollowedDex: out, extractedCodeItems: extracted, stubMethods: stubs, summary: { totalMethods: total, hollowedMethods: hollowed, skippedMethods: skipped, extractedBytes } }
}

// ── DEX 整体加密(#2) ──────────────────────────────────────────────────
export interface EncryptedDex { shellDex: Uint8Array; encryptedPayload: EncryptedPayload; algorithm: string; originalSize: number; shellSize: number }

export function encryptDex(dexBytes: Uint8Array, key: Uint8Array, algorithm: "aes-256-gcm" | "chacha20-poly1305" = "aes-256-gcm", nonce?: Uint8Array): EncryptedDex {
  const n = nonce ?? randomBytes(12)
  const payload = algorithm === "aes-256-gcm" ? encryptAes256Gcm(dexBytes, key, n) : encryptChaCha20Poly1305(dexBytes, key, n)
  const pb = serializePayload(payload)
  const result = new Uint8Array(dexBytes.length + pb.length + 4)
  result.set(dexBytes, 0)
  new DataView(result.buffer).setUint32(dexBytes.length, pb.length, true)
  result.set(pb, dexBytes.length + 4)
  return { shellDex: result, encryptedPayload: payload, algorithm, originalSize: dexBytes.length, shellSize: result.length }
}

export function decryptDex(shellDex: Uint8Array, key: Uint8Array, algorithm: "aes-256-gcm" | "chacha20-poly1305" = "aes-256-gcm"): Uint8Array {
  const v = new DataView(shellDex.buffer, shellDex.byteOffset, shellDex.byteLength)
  const origSize = v.getUint32(32, true); const pLen = v.getUint32(origSize, true)
  const pb = shellDex.slice(origSize + 4, origSize + 4 + pLen)
  const payload = deserializePayload(pb)
  return algorithm === "aes-256-gcm" ? decryptAes256Gcm(payload, key) : decryptChaCha20Poly1305(payload, key)
}

// ── 隐写式存储(#5) ──────────────────────────────────────────────────
export function hidePayloadInDex(dexBytes: Uint8Array, payload: Uint8Array): Uint8Array {
  const r = new Uint8Array(dexBytes.length + payload.length); r.set(dexBytes, 0); r.set(payload, dexBytes.length); return r
}
export function extractHiddenPayload(dexBytes: Uint8Array): Uint8Array | undefined {
  const fs = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength).getUint32(32, true)
  return fs < dexBytes.length ? dexBytes.slice(fs) : undefined
}

// ── 类排除规则(#11) ──────────────────────────────────────────────────
export function parseClassExclusionRules(text: string): RegExp[] {
  try { const p = JSON.parse(text); if (!Array.isArray(p)) return []; return (p as string[]).filter((s) => typeof s === "string").map((s) => new RegExp(s.replace(/\*/g, ".*").replace(/\?/g, "."), "i")) } catch { return [] }
}

// ── Finding 生成 ──────────────────────────────────────────────────────
export function buildDexProtectionFindings(result: MethodHollowResult, encryptedDex?: EncryptedDex): Finding[] {
  const f: Finding[] = []; const s = result.summary
  const coverage = s.totalMethods > 0 ? ((s.hollowedMethods / s.totalMethods) * 100).toFixed(1) : "0.0"
  f.push({ severity: "info", confidence: "high", code: "DEX_METHOD_HOLLOW", title: `方法抽取完成:${s.hollowedMethods}/${s.totalMethods} 个方法已挖空(覆盖率 ${coverage}%)`, detail: `提取 ${s.extractedBytes}B 原始 CodeItem;跳过 ${s.skippedMethods} 个 abstract/native。覆盖率如实量化:未抽取的方法(排除 abstract/native 之外的跳过项)仍为明文,静态可读。`, recommendation: "方法抽取是当前最强 DEX 静态保护——逆向需完整 ART hook 链。", evidence: `hollowed=${s.hollowedMethods} total=${s.totalMethods} coverage=${coverage}%` })
  if (encryptedDex) f.push({ severity: "info", confidence: "high", code: "DEX_ENCRYPTED", title: `DEX 加密完成(${encryptedDex.algorithm}):${encryptedDex.originalSize}B→${encryptedDex.shellSize}B`, detail: `壳 DEX 包含 stub + 加密 payload。`, recommendation: "确认壳加载器兼容 Android 5~16。", evidence: `alg=${encryptedDex.algorithm}` })
  return f
}

export function serializePayload(p: EncryptedPayload): Uint8Array { const r = new Uint8Array(28 + p.ciphertext.length); r.set(p.nonce, 0); r.set(p.tag, 12); r.set(p.ciphertext, 28); return r }
function deserializePayload(b: Uint8Array): EncryptedPayload { return { nonce: b.slice(0, 12), tag: b.slice(12, 28), ciphertext: b.slice(28) } }
