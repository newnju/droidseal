// 密钥管理模块:HKDF-SHA256 派生 + Split-Key 混淆 + 随机 nonce（#4 #7 #8）。
// 密钥绑定签名证书指纹——换签后解密必失败（mocika-shield 设计）。
// 纯 TypeScript，使用 node:crypto。
import { createHash, createHmac, randomBytes } from "node:crypto"

// ── HKDF-SHA256 密钥派生(#4) ──────────────────────────────────────────

/**
 * HKDF-SHA256 密钥派生（RFC 5869）。
 * @param ikm 输入密钥材料（原始密钥或证书指纹）
 * @param salt 盐值（可选，默认全零）
 * @param info 上下文信息（如 "droidseal-dex-encryption"）
 * @param length 输出密钥长度（字节）
 */
export function hkdfSha256(ikm: Buffer, info: string, length: number, salt?: Buffer): Buffer {
  // Extract: PRK = HMAC-Hash(salt, IKM)
  const saltBuf = salt && salt.length > 0 ? salt : Buffer.alloc(32, 0)
  const prk = createHmac("sha256", saltBuf).update(ikm).digest()

  // Expand: OKM = T(1) || T(2) || ... || T(N)
  const okm: Buffer[] = []
  let tPrev = Buffer.alloc(0)
  const infoBuf = Buffer.from(info, "utf8")
  let remaining = length
  for (let i = 1; remaining > 0; i += 1) {
    const hmac = createHmac("sha256", prk)
    hmac.update(tPrev)
    hmac.update(infoBuf)
    hmac.update(Buffer.from([i]))
    tPrev = hmac.digest()
    okm.push(tPrev.subarray(0, Math.min(remaining, 32)))
    remaining -= 32
  }
  return Buffer.concat(okm).subarray(0, length)
}

/**
 * 从签名证书 SHA-256 指纹派生加固密钥。
 * 换签后指纹变化 → 派生密钥不同 → 解密失败。
 */
export function deriveKeyFromCertificate(
  certSha256: string,
  purpose: "dex" | "so" | "resource" | "string",
  length: number = 32,
): Buffer {
  const ikm = Buffer.from(certSha256, "hex")
  return hkdfSha256(ikm, `droidseal-${purpose}-encryption`, length)
}

/**
 * 从 APK SHA-256 + 配置哈希派生加固密钥（无签名场景的降级方案）。
 */
export function deriveKeyFromApkHash(
  apkSha256: string,
  configHash: string,
  purpose: "dex" | "so" | "resource" | "string",
  length: number = 32,
): Buffer {
  const combined = createHash("sha256").update(apkSha256).update(configHash).digest()
  return hkdfSha256(combined, `droidseal-${purpose}-encryption`, length)
}

// ── 随机 nonce 生成(#8) ──────────────────────────────────────────────

/**
 * 生成加密 nonce（每次加固不同）。
 * AES-GCM:12 字节;ChaCha20-Poly1305:12 字节。
 */
export function generateNonce(length: number = 12): Buffer {
  return randomBytes(length)
}

/**
 * 生成随机密钥（AES-256:32 字节;ChaCha20:32 字节）。
 */
export function generateRandomKey(length: number = 32): Buffer {
  return randomBytes(length)
}

// ── Split-Key 混淆(#7) ──────────────────────────────────────────────

/**
 * Split-Key 密钥拆分:将密钥拆分为两部分异或。
 * 运行时 part1 XOR part2 = 原始密钥。
 * 静态分析无法直接提取完整密钥。
 */
export interface SplitKey {
  part1: Buffer
  part2: Buffer
}

export function splitKey(key: Buffer): SplitKey {
  const part2 = randomBytes(key.length)
  const part1 = Buffer.alloc(key.length)
  for (let i = 0; i < key.length; i += 1) {
    part1[i] = key[i]! ^ part2[i]!
  }
  return { part1, part2 }
}

/**
 * Split-Key 还原:part1 XOR part2 = 原始密钥。
 */
export function combineSplitKey(split: SplitKey): Buffer {
  const key = Buffer.alloc(split.part1.length)
  for (let i = 0; i < key.length; i += 1) {
    key[i] = split.part1[i]! ^ split.part2[i]!
  }
  return key
}

/**
 * 将 SplitKey 转为 Smali 字节数组声明（编译时内联）。
 */
export function splitKeyToSmali(split: SplitKey, varName1: string, varName2: string): string {
  const toHexArray = (buf: Buffer) =>
    `{${[...buf].map((b) => `0x${b.toString(16).padStart(2, "0")}t`).join(", ")}}`
  return [
    `# Split-Key Part 1（编译时内联）`,
    `const/16 v0, ${split.part1.length}`,
    `new-array v0, v0, [B`,
    `fill-array-data v0, :array_part1`,
    `sput-object v0, Ldroidseal_key;->${varName1}[B`,
    `# Split-Key Part 2（编译时内联）`,
    `const/16 v0, ${split.part2.length}`,
    `new-array v0, v0, [B`,
    `fill-array-data v0, :array_part2`,
    `sput-object v0, Ldroidseal_key;->${varName2}[B`,
    ``,
    `:array_part1`,
    `.array-data 1`,
    ...[...split.part1].map((b) => `0x${b.toString(16).padStart(2, "0")}`),
    `.end array-data`,
    ``,
    `:array_part2`,
    `.array-data 1`,
    ...[...split.part2].map((b) => `0x${b.toString(16).padStart(2, "0")}`),
    `.end array-data`,
  ].join("\n")
}

// ── 密钥生命周期管理 ──────────────────────────────────────────────────

export interface KeyMaterial {
  encryptionKey: Buffer
  nonce: Buffer
  splitKey?: SplitKey | undefined
  derivedFrom: string
  purpose: "dex" | "so" | "resource" | "string"
}

/**
 * 完整密钥生成流程:派生 + 拆分 + nonce。
 */
export function generateKeyMaterial(
  certSha256: string | undefined,
  apkSha256: string,
  purpose: "dex" | "so" | "resource" | "string",
  useSplitKey: boolean = true,
): KeyMaterial {
  const encryptionKey = certSha256
    ? deriveKeyFromCertificate(certSha256, purpose)
    : deriveKeyFromApkHash(apkSha256, "", purpose)
  const nonce = generateNonce()
  const splitKeyResult = useSplitKey ? splitKey(encryptionKey) : undefined
  return {
    encryptionKey,
    nonce,
    splitKey: splitKeyResult,
    derivedFrom: certSha256 ? "certificate" : "apk-hash",
    purpose,
  }
}
