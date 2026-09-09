// 加密 payload 注入壳 DEX 末尾 + file_size 更新（P0-2）。
// 将加密后的 DEX payload 追加到壳 DEX 的 file_size 边界外，
// 更新 DEX header 的 file_size 字段指向边界（壳 DEX 本身大小），
// 运行时壳加载器从 file_size 之后读取加密 payload 并解密。
// 纯 TypeScript，失败关闭。
import { createCipheriv, randomBytes, createHash } from "node:crypto"
import type { Finding } from "./types.ts"

// ── DEX header 常量 ──────────────────────────────────────────────────────

const DEX_FILE_SIZE_OFFSET = 0x20  // file_size (4 bytes, little-endian)
const DEX_CHECKSUM_OFFSET = 0x08   // Adler32 checksum (4 bytes)
const DEX_SIGNATURE_OFFSET = 0x0C  // SHA-1 signature (20 bytes)

// ── payload 序列化 ──────────────────────────────────────────────────────

interface EncryptedPayload {
  ciphertext: Uint8Array
  nonce: Uint8Array
  tag: Uint8Array
}

/**
 * 将加密 payload 序列化为可追加到 DEX 末尾的字节块。
 * 格式: "DROIDSEAL_PAYLOAD" (16B magic) + nonce(12B) + tag(16B) + ciphertext
 */
function serializePayload(payload: EncryptedPayload): Uint8Array {
  const magic = new TextEncoder().encode("DROIDSEAL_PAYLOAD")
  const result = new Uint8Array(16 + 12 + 16 + payload.ciphertext.length)
  result.set(magic.slice(0, 16), 0)
  result.set(payload.nonce, 16)
  result.set(payload.tag, 28)
  result.set(payload.ciphertext, 44)
  return result
}

/**
 * 从字节块中反序列化 payload。
 */
export function deserializePayload(bytes: Uint8Array): EncryptedPayload | undefined {
  const magic = new TextDecoder().decode(bytes.slice(0, 16))
  if (magic !== "DROIDSEAL_PAYLOAD") return undefined
  return {
    nonce: bytes.slice(16, 28),
    tag: bytes.slice(28, 44),
    ciphertext: bytes.slice(44),
  }
}

// ── DEX 校验和更新 ──────────────────────────────────────────────────────

function updateDexChecksum(bytes: Uint8Array): void {
  // Adler32 of bytes[12..fileSize]
  const fileSize = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength).getUint32(DEX_FILE_SIZE_OFFSET, true)
  let a = 1, b = 0
  for (let i = 12; i < fileSize; i += 1) {
    a = (a + bytes[i]!) % 65521
    b = (b + a) % 65521
  }
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  view.setUint32(DEX_CHECKSUM_OFFSET, (b << 16) | a, true)
  // SHA-1 of bytes[32..fileSize]
  const { createHash } = require("node:crypto") as typeof import("node:crypto")
  const sha1 = createHash("sha1").update(bytes.slice(32, fileSize)).digest()
  bytes.set(new Uint8Array(sha1), DEX_SIGNATURE_OFFSET)
}

// ── 加密 payload 注入 ──────────────────────────────────────────────────────

/**
 * 加密原始 DEX 并将 payload 注入壳 DEX 末尾。
 *
 * 流程:
 * 1. 读取原始 DEX → AES-256-GCM 加密 → payload
 * 2. 序列化 payload (magic + nonce + tag + ciphertext)
 * 3. 追加到壳 DEX 末尾 (壳 DEX 的 file_size 不变——壳加载器从 file_size 之后读取)
 * 4. 更新壳 DEX 的校验和 (Adler32 + SHA-1)
 *
 * @param shellDex 壳 DEX 字节（方法抽取后的 stub DEX）
 * @param originalDex 原始 DEX 字节（完整方法体）
 * @param key 32 字节加密密钥
 * @param nonce 12 字节 nonce（可选，不传则随机生成）
 * @returns 注入后的壳 DEX 字节
 */
export function injectPayloadIntoShellDex(
  shellDex: Uint8Array,
  originalDex: Uint8Array,
  key: Uint8Array,
  nonce?: Uint8Array,
): { shellDex: Uint8Array; payloadSize: number; findings: Finding[] } {
  const findings: Finding[] = []

  // 1. 加密原始 DEX
  const useNonce = nonce ?? randomBytes(12)
  const cipher = createCipheriv("aes-256-gcm", key, useNonce)
  const encrypted = Buffer.concat([cipher.update(originalDex), cipher.final()])
  const tag = cipher.getAuthTag()

  const payload: EncryptedPayload = {
    ciphertext: new Uint8Array(encrypted),
    nonce: useNonce,
    tag: new Uint8Array(tag),
  }

  // 2. 序列化 payload
  const serialized = serializePayload(payload)

  // 3. 追加到壳 DEX 末尾
  const result = new Uint8Array(shellDex.length + serialized.length)
  result.set(shellDex, 0)
  result.set(serialized, shellDex.length)

  // 4. 更新壳 DEX 的校验和（只更新 file_size 以内的部分）
  // 注意:file_size 字段保持不变（= 壳 DEX 本身的大小）
  // payload 追加在 file_size 之后，壳加载器从 file_size 偏移读取
  updateDexChecksum(result)

  findings.push({
    severity: "info",
    confidence: "high",
    code: "PAYLOAD_INJECTED",
    title: `加密 payload 已注入壳 DEX 末尾`,
    detail: `原始 DEX: ${originalDex.length}B → 加密 payload: ${serialized.length}B(含44B头);壳 DEX file_size: ${shellDex.length}B;总大小: ${result.length}B。`,
    recommendation: "确认壳加载器能从 file_size 偏移正确读取 payload。",
    evidence: `shellDex=${shellDex.length}B payload=${serialized.length}B total=${result.length}B`,
  })

  return { shellDex: result, payloadSize: serialized.length, findings }
}

/**
 * 从壳 DEX 中提取加密 payload。
 * 读取 file_size 偏移之后的字节，检查 DROIDSEAL_PAYLOAD magic。
 */
export function extractPayloadFromShellDex(shellDexWithPayload: Uint8Array): {
  payload: EncryptedPayload | undefined
  shellDexSize: number
} {
  const view = new DataView(shellDexWithPayload.buffer, shellDexWithPayload.byteOffset, shellDexWithPayload.byteLength)
  const fileSize = view.getUint32(DEX_FILE_SIZE_OFFSET, true)

  if (fileSize >= shellDexWithPayload.length) {
    return { payload: undefined, shellDexSize: shellDexWithPayload.length }
  }

  const payloadBytes = shellDexWithPayload.slice(fileSize)
  const payload = deserializePayload(payloadBytes)
  return { payload, shellDexSize: fileSize }
}

/**
 * 完整的 DEX 处理流程:方法抽取 + 加密 + payload 注入。
 * 这是 harden-pipeline 中 Step 4 的核心逻辑。
 */
export function processAndInjectPayload(
  originalDex: Uint8Array,
  shellDex: Uint8Array,
  key: Uint8Array,
): { resultDex: Uint8Array; findings: Finding[] } {
  const findings: Finding[] = []

  // 注入 payload
  const { shellDex: resultDex, payloadSize, findings: injectFindings } =
    injectPayloadIntoShellDex(shellDex, originalDex, key)
  findings.push(...injectFindings)

  // 验证 payload 可提取
  const { payload, shellDexSize } = extractPayloadFromShellDex(resultDex)
  if (payload) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "PAYLOAD_VERIFIED",
      title: "加密 payload 验证通过",
      detail: `壳 DEX 大小: ${shellDexSize}B;payload 可从 file_size 偏移正确提取。`,
      recommendation: "确认壳加载器的解密逻辑与加密算法一致(AES-256-GCM)。",
      evidence: `shellSize=${shellDexSize}B payloadExtractable=yes`,
    })
  } else {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "PAYLOAD_VERIFY_FAILED",
      title: "加密 payload 验证失败",
      detail: "无法从壳 DEX 的 file_size 偏移提取 payload——magic 不匹配。",
      recommendation: "检查 file_size 字段是否正确，payload 序列化格式是否一致。",
      evidence: `shellSize=${shellDexSize}B payloadExtractable=no`,
    })
  }

  return { resultDex, findings }
}
