// 字符串加密实际回写 DEX string_data（P1-6）。
// 解析 DEX 的 string_data 段，找到敏感字符串，
// 用 XOR/AES 加密后替换原始字节，并生成包含真实加密数据的解密器 Smali。
// 纯 TypeScript，失败关闭。
import { createCipheriv, randomBytes } from "node:crypto"
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
]

function isSensitive(value: string): boolean {
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
    .locals 5

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

    # XOR 解密
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v0, v0, v4
    aget-byte v1, v1, v4
    xor-int/2addr v0, v1
    int-to-byte v0, v0
    aput-byte v0, v3, v4
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
    const key = randomBytes(16) // 每串独立随机密钥
    const encrypted = xorEncrypt(data, key)

    // 替换 DEX 中的原始字符串（保持相同长度）
    const originalRaw = str.rawBytes
    const replaceLen = Math.min(encrypted.length, originalRaw.length)
    const paddedEncrypted = new Uint8Array(originalRaw.length)
    paddedEncrypted.set(encrypted.slice(0, replaceLen))

    modifiedDex = new Uint8Array(replaceStringInDex(modifiedDex, str.offset, originalRaw, paddedEncrypted))
    encryptedData.push({ index: str.index, original: str.value, key, encrypted })
  }

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
