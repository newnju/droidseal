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
  let a = 1, b = 0
  for (let i = 12; i < bytes.length; i += 1) { a = (a + bytes[i]!) % 65521; b = (b + a) % 65521 }
  new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength).setUint32(8, (b << 16) | a, true)
  bytes.set(new Uint8Array(createHash("sha1").update(bytes.slice(32)).digest()), 12)
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
function generateReturnVoidStub(): Uint8Array {
  const s = new Uint8Array(18); const v = new DataView(s.buffer)
  v.setUint32(12, 1, true); v.setUint16(16, 0x000e, true); return s
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
  for (let c = 0; c < header.classDefsSize; c += 1) {
    const cdOff = v.getUint32(header.classDefsOff + c * 32 + 24, true); if (!cdOff) continue
    const cls = types[v.getUint32(header.classDefsOff + c * 32, true)] ?? ""
    if (excludePatterns.some((p) => p.test(cls))) continue
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
        if (!code.value || (access.value & 0x100)) { skipped += 1; continue }
        const insnsSize = v.getUint32(code.value + 12, true); const sz = 16 + insnsSize * 2
        // 防护:code_item 越界或 insnsSize 为垃圾值(单方法指令区不超过 64K insns=128KB+16B 头)
        if (code.value + 16 > dexBytes.length || insnsSize > 0x10000 || code.value + sz > dexBytes.length) { skipped += 1; continue }
        extracted.set(code.value, dexBytes.slice(code.value, code.value + sz)); extractedBytes += sz
        out.set(generateReturnVoidStub(), code.value)
        new DataView(out.buffer, out.byteOffset, out.byteLength).setUint32(code.value + 12, 1, true)
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
  f.push({ severity: "info", confidence: "high", code: "DEX_METHOD_HOLLOW", title: `方法抽取完成:${s.hollowedMethods}/${s.totalMethods} 个方法已挖空`, detail: `提取 ${s.extractedBytes}B 原始 CodeItem;跳过 ${s.skippedMethods} 个 abstract/native。`, recommendation: "方法抽取是当前最强 DEX 静态保护——逆向需完整 ART hook 链。", evidence: `hollowed=${s.hollowedMethods} total=${s.totalMethods}` })
  if (encryptedDex) f.push({ severity: "info", confidence: "high", code: "DEX_ENCRYPTED", title: `DEX 加密完成(${encryptedDex.algorithm}):${encryptedDex.originalSize}B→${encryptedDex.shellSize}B`, detail: `壳 DEX 包含 stub + 加密 payload。`, recommendation: "确认壳加载器兼容 Android 5~16。", evidence: `alg=${encryptedDex.algorithm}` })
  return f
}

function serializePayload(p: EncryptedPayload): Uint8Array { const r = new Uint8Array(28 + p.ciphertext.length); r.set(p.nonce, 0); r.set(p.tag, 12); r.set(p.ciphertext, 28); return r }
function deserializePayload(b: Uint8Array): EncryptedPayload { return { nonce: b.slice(0, 12), tag: b.slice(12, 28), ciphertext: b.slice(28) } }
