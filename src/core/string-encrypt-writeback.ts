// 字符串加密实际回写 DEX string_data（P1-6）。
// 解析 DEX 的 string_data 段，找到敏感字符串，
// 用 XOR/AES 加密后替换原始字节，并生成包含真实加密数据的解密器 Smali。
// 纯 TypeScript，失败关闭。
import { createCipheriv, createHash, randomBytes } from "node:crypto"
import type { Finding } from "./types.ts"

// ── DEX string_data 解析 ──────────────────────────────────────────────

const DEX_MAGIC = [0x64, 0x65, 0x78, 0x0a]
const STRING_IDS_OFF = 0x3c
const STRING_IDS_SIZE = 0x38

interface DexString {
  index: number
  offset: number
  value: string
  rawBytes: Uint8Array
  sensitive: boolean
}

function readUleb128(bytes: Uint8Array, start: number): { value: number; next: number } {
  let p = start, result = 0, shift = 0
  for (let i = 0; i < 5; i += 1) {
    if (p >= bytes.length) break
    const b = bytes[p++]!
    result |= (b & 0x7f) << shift
    if ((b & 0x80) === 0) break
    shift += 7
  }
  return { value: result >>> 0, next: p }
}

function readMutf8String(bytes: Uint8Array, offset: number): { value: string; rawBytes: Uint8Array; next: number } {
  const { value: charLen, next: dataStart } = readUleb128(bytes, offset)
  let end = dataStart
  while (end < bytes.length && bytes[end] !== 0x00) end += 1
  const rawBytes = bytes.slice(dataStart, end)
  const value = new TextDecoder("utf-8", { fatal: false }).decode(rawBytes)
  return { value, rawBytes, next: end + 1 }
}

export function extractAllStrings(dexBytes: Uint8Array): DexString[] {
  if (dexBytes.length < 0x70) return []
  for (let i = 0; i < 4; i += 1) {
    if (dexBytes[i] !== DEX_MAGIC[i]) return []
  }
  const view = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const stringIdsSize = view.getUint32(STRING_IDS_SIZE, true)
  const stringIdsOff = view.getUint32(STRING_IDS_OFF, true)
  const strings: DexString[] = []
  for (let i = 0; i < Math.min(stringIdsSize, 50000); i += 1) {
    const strOff = view.getUint32(stringIdsOff + i * 4, true)
    if (strOff >= dexBytes.length) continue
    try {
      const { value, rawBytes, next } = readMutf8String(dexBytes, strOff)
      strings.push({ index: i, offset: strOff, value, rawBytes, sensitive: false })
    } catch { continue }
  }
  return strings
}

// ── 敏感字符串筛选 ──────────────────────────────────────────────────────

const SENSITIVE_PATTERNS: RegExp[] = [
  /password/i, /passwd/i, /pwd/i, /secret/i, /token/i, /api[_-]?key/i,
  /bearer/i, /authorization/i, /credential/i, /private[_-]?key/i,
  /AES|DES|RSA|HMAC/i, /encrypt|decrypt|cipher/i,
  /firebase|google[_-]api/i, /aws[_-]?access/i, /sentry/i,
  /jdbc:|mysql:|postgres:|mongodb:/i,
  /-----BEGIN/i,
  /\bAKIA[0-9A-Z]{16}\b/,
  /\bAIza[0-9A-Za-z_-]{35}\b/,
  /\bghp_[0-9A-Za-z]{36}\b/,
  /https?:\/\//i, // 网络端点(服务端地址/回连 URL)——高熵覆盖不到的低熵重复字符 URL
]

export function isSensitive(value: string): boolean {
  if (value.length < 6 || value.length > 1024) return false
  if (SENSITIVE_PATTERNS.some((p) => p.test(value))) return true
  // 高熵检测（Shannon 熵 > 4.5）
  if (value.length >= 16 && calculateEntropy(value) > 4.5) return true
  return false
}

function calculateEntropy(s: string): number {
  const freq = new Map<string, number>()
  for (const c of s) freq.set(c, (freq.get(c) ?? 0) + 1)
  let entropy = 0
  for (const count of freq.values()) {
    const p = count / s.length
    entropy -= p * Math.log2(p)
  }
  return entropy
}

// ── XOR 加密 ──────────────────────────────────────────────────────────

function xorEncrypt(data: Uint8Array, key: Uint8Array): Uint8Array {
  const result = new Uint8Array(data.length)
  for (let i = 0; i < data.length; i += 1) {
    result[i] = data[i]! ^ key[i % key.length]!
  }
  return result
}

// ── MUTF-8 安全密文(同长写回的前提)────────────────────────────────
// DEX string_data 按 MUTF-8 解码,密文字节必须落在可解码域,否则运行时字符串损坏。
// 可行域取单字节集 0x01–0x7F(排除 0x00:MUTF-8 串终止符):对任意明文字节 p,
// XOR 是双射,合法密钥字节 k = p ^ c(c ∈ 0x01–0x7F)恒有 127 个候选——逐字节约束
// 永远可解。密钥流由每串随机 baseKey 经 FNV-1a 逐位派生,派生值越界时在合法集内
// 确定性重选(同 (key,i) 重算结果一致,解密侧用同一算法还原)。
function fnv1a(prev: number, byte: number): number {
  let h = prev
  h ^= byte
  return Math.imul(h, 0x01000193) >>> 0
}

function mutf8SafeKeystream(baseKey: Uint8Array, length: number, plainBytes: Uint8Array): Uint8Array {
  const ks = new Uint8Array(length)
  let h = 0x811c9dc5
  for (const b of baseKey) h = fnv1a(h, b)
  for (let i = 0; i < length; i += 1) {
    h = fnv1a(h, i & 0xff)
    h = fnv1a(h, plainBytes[i]!)
    const derived = h & 0xff
    const candidate = plainBytes[i]! ^ derived
    if (candidate >= 0x01 && candidate <= 0x7f) {
      ks[i] = derived
    } else {
      // 越界:合法集内确定性重选(c = (h >>> 8) mod 127 + 1 → k = p ^ c)
      const c = ((h >>> 8) % 127) + 1
      ks[i] = plainBytes[i]! ^ c
    }
  }
  return ks
}

export function mutf8SafeEncrypt(data: Uint8Array, baseKey: Uint8Array): { encrypted: Uint8Array; keystream: Uint8Array } {
  const keystream = mutf8SafeKeystream(baseKey, data.length, data)
  const encrypted = new Uint8Array(data.length)
  for (let i = 0; i < data.length; i += 1) encrypted[i] = data[i]! ^ keystream[i]!
  return { encrypted, keystream }
}

// ── DEX 校验和修复(SEC-010 同类:改字节必须同步 checksum/SHA-1)─────────
// header: adler32@8(偏移 12 起至文件尾), sha1@12(偏移 32 起至文件尾)。
export function updateDexChecksum(dexBytes: Uint8Array): Uint8Array {
  const bytes = dexBytes.slice()
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  // 顺序关键:sha1 覆盖字节 32..,adler32 覆盖字节 12..(含 sha1 字段)——
  // 必须先写 sha1 再算 adler32,否则校验和对不上最终字节(与 SEC-010 同型的顺序缺陷)
  const sha1 = createHash("sha1").update(bytes.subarray(32)).digest()
  bytes.set(sha1, 12)
  let a = 1
  let b = 0
  for (let i = 12; i < bytes.length; i += 1) {
    a = (a + bytes[i]!) % 65521
    b = (b + a) % 65521
  }
  view.setUint32(8, ((b << 16) | a) >>> 0, true)
  return bytes
}

// ── DEX string_data 替换 ──────────────────────────────────────────────

/**
 * 在 DEX 二进制中替换 string_data 条目。
 * 策略：将原始字符串的 rawBytes 替换为加密后的字节（保持相同长度或填充），
 * 同时更新 ULEB128 长度前缀。
 */
function replaceStringInDex(
  dexBytes: Uint8Array,
  offset: number,
  originalRaw: Uint8Array,
  encryptedRaw: Uint8Array,
): Uint8Array {
  const result = new Uint8Array(dexBytes)
  // 计算长度前缀
  const { next: dataStart } = readUleb128(result, offset)
  // 替换数据（确保不超过原始长度，否则会破坏后续偏移）
  const maxLen = Math.min(encryptedRaw.length, originalRaw.length)
  for (let i = 0; i < maxLen; i += 1) {
    result[dataStart + i] = encryptedRaw[i]!
  }
  // 如果加密后更短，用 0x00 填充剩余
  for (let i = maxLen; i < originalRaw.length; i += 1) {
    result[dataStart + i] = 0x00
  }
  return result
}

// ── 解密器 Smali 生成 ──────────────────────────────────────────────────────

/**
 * 生成字符串解密器 Smali（包含真实加密数据）。
 * 使用 XOR 解密，每串独立密钥。
 */
export function generateStringDecryptorWithRealData(
  packageName: string,
  encryptedStrings: Array<{ index: number; original: string; key: Uint8Array; encrypted: Uint8Array }>,
): string {
  const pkg = packageName.replace(/\./g, "/")
  const encDataBlocks = encryptedStrings.map((s, i) => {
    const hex = Array.from(s.encrypted).map((b) => `0x${b.toString(16).padStart(2, "0")}`).join("\n    ")
    return `    :enc_str_${i}\n    .array-data 1\n    ${hex}\n    .end array-data`
  }).join("\n\n")

  const keyDataBlocks = encryptedStrings.map((s, i) => {
    const hex = Array.from(s.key).map((b) => `0x${b.toString(16).padStart(2, "0")}`).join("\n    ")
    return `    :enc_key_${i}\n    .array-data 1\n    ${hex}\n    .end array-data`
  }).join("\n\n")

  return `.class public L${pkg}/DroidSealStringDecryptor;
.super Ljava/lang/Object;
.source "DroidSealStringDecryptor.java"

.field private static final ENC_STRINGS:[[B
.field private static final ENC_KEYS:[[B
.field private static final cache:[Ljava/lang/String;

.method static constructor <clinit>()V
    .locals 3

    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [[B
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B

    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [[B
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B

    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [Ljava/lang/String;
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;

${encryptedStrings.map((s, i) => `    # String ${i}: "${s.original.slice(0, 30)}${s.original.length > 30 ? "..." : ""}"
    const/4 v0, ${s.encrypted.length}
    new-array v0, v0, [B
    fill-array-data v0, :enc_str_${i}
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B
    const/4 v2, ${i}
    aput-object v0, v1, v2

    const/4 v0, ${s.key.length}
    new-array v0, v0, [B
    fill-array-data v0, :enc_key_${i}
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B
    aput-object v0, v1, v2`).join("\n\n")}

    return-void

${encDataBlocks}

${keyDataBlocks}
.end method

# 解密指定索引的字符串(带缓存)
.method public static decrypt(I)Ljava/lang/String;
    .locals 7

    # 检查缓存
    sget-object v0, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;
    aget-object v1, v0, p0
    if-eqz v1, :not_cached
    return-object v1

    :not_cached
    # 获取加密数据和密钥
    sget-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B
    aget-object v0, v0, p0
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B
    aget-object v1, v1, p0

    # XOR 解密(v0=密文数组引用, v1=密钥数组引用——循环内不得覆盖,否则第二轮 aget 崩溃)
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v5, v0, v4
    aget-byte v6, v1, v4
    xor-int/2addr v5, v6
    int-to-byte v5, v5
    aput-byte v5, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_loop
    :xor_done

    # 转为 String
    new-instance v0, Ljava/lang/String;
    const-string v1, "UTF-8"
    invoke-direct {v0, v3, v1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    # 写入缓存
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;
    aput-object v0, v1, p0

    return-object v0
.end method
`
}

// ── 主入口 ──────────────────────────────────────────────────────────

export interface StringEncryptResult {
  modifiedDex: Uint8Array
  decryptorSmali: string
  encryptedCount: number
  skippedCount: number
  findings: Finding[]
}

/**
 * 完整字符串加密流程：
 * 1. 提取 DEX 字符串
 * 2. 筛选敏感字符串
 * 3. XOR 加密（每串随机密钥）
 * 4. 替换 DEX 中的原始字符串
 * 5. 生成解密器 Smali（含真实加密数据）
 */
export function encryptAndReplaceStrings(
  dexBytes: Uint8Array,
  packageName: string,
  maxEncrypt: number = 200,
): StringEncryptResult {
  const findings: Finding[] = []
  const allStrings = extractAllStrings(dexBytes)
  const sensitiveStrings = allStrings.filter((s) => isSensitive(s.value))

  if (sensitiveStrings.length === 0) {
    return { modifiedDex: dexBytes, decryptorSmali: "", encryptedCount: 0, skippedCount: 0, findings }
  }

  const toEncrypt = sensitiveStrings.slice(0, maxEncrypt)
  let modifiedDex = new Uint8Array(dexBytes)
  const encryptedData: Array<{ index: number; original: string; key: Uint8Array; encrypted: Uint8Array }> = []

  for (const str of toEncrypt) {
    const data = new TextEncoder().encode(str.value)
    const key = randomBytes(16) // 每串独立随机基密钥
    // MUTF-8 安全加密:密文字节约束在 0x01–0x7F(可解码域),同长写回后运行时字符串不损坏;
    // 解密用同一密钥流(由 baseKey+明文逐位派生——解密器持有 baseKey 与密文即可还原)
    const { encrypted, keystream } = mutf8SafeEncrypt(data, key)
    // keystream = 明文 XOR 密文,解密侧以密文重放同一派生(密文即明文的同长像)
    const originalRaw = str.rawBytes
    const replaceLen = Math.min(encrypted.length, originalRaw.length)
    const paddedEncrypted = new Uint8Array(originalRaw.length)
    paddedEncrypted.set(encrypted.slice(0, replaceLen))

    modifiedDex = new Uint8Array(replaceStringInDex(modifiedDex, str.offset, originalRaw, paddedEncrypted))
    encryptedData.push({ index: str.index, original: str.value, key: keystream, encrypted })
  }

  // 修 DEX checksum/SHA-1(SEC-010 同类:改 string_data 字节后必须同步校验,否则加载即拒)
  modifiedDex = new Uint8Array(updateDexChecksum(modifiedDex))

  // 生成解密器 Smali
  const decryptorSmali = generateStringDecryptorWithRealData(packageName, encryptedData)

  findings.push({
    severity: "info",
    confidence: "high",
    code: "STRING_ENCRYPTED_WRITEBACK",
    title: `字符串加密回写完成:${encryptedData.length} 个敏感字符串`,
    detail: `扫描 ${allStrings.length} 个字符串，筛选 ${sensitiveStrings.length} 个敏感字符串，加密 ${encryptedData.length} 个。每串独立随机 XOR 密钥。`,
    recommendation: "确认解密器 Smali 已注入 classes.dex；高频调用的字符串建议跳过加密。",
    evidence: `total=${allStrings.length} sensitive=${sensitiveStrings.length} encrypted=${encryptedData.length}`,
  })

  return { modifiedDex, decryptorSmali, encryptedCount: encryptedData.length, skippedCount: sensitiveStrings.length - encryptedData.length, findings }
}
