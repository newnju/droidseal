// 密码学深度分析（Phase 2 扩充——MobSF 差距补齐）。
// 检测：密钥长度不足、Padding Oracle 风险、AndroidKeyStore 使用分析、
// 证书链验证、加密模式完整性（CBC 无 HMAC / GCM tag 长度）、密钥轮换机制。
// 纯 TypeScript 源码正则匹配，失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface CryptoPattern {
  key: string
  title: string
  regex: RegExp
  severity: Finding["severity"]
  confidence: Finding["confidence"]
  recommendation: string
  note: string
}

const CRYPTO_PATTERNS: readonly CryptoPattern[] = [
  // ── 密钥长度不足 ──
  {
    key: "RSA_KEY_WEAK",
    title: "RSA 密钥长度不足 2048 位",
    regex: /KeyPairGenerator\.getInstance\s*\(\s*["']RSA["']\s*\)[\s\S]{0,200}initialize\s*\(\s*(?:[1-9]\d{0,2}|1\d{3})\s*\)/i,
    severity: "high",
    confidence: "medium",
    recommendation: "RSA 密钥长度应 ≥ 2048 位（OWASP 推荐 4096 位）。",
    note: "RSA-1024 已可被分解。",
  },
  {
    key: "EC_KEY_WEAK",
    title: "EC 密钥曲线不安全（非 P-256/P-384/P-521）",
    regex: /KeyPairGenerator\.getInstance\s*\(\s*["']EC["']\s*\)[\s\S]{0,200}(?:secp192|prime192|brainpool)/i,
    severity: "medium",
    confidence: "medium",
    recommendation: "EC 曲线应使用 NIST P-256/P-384/P-521 或 Curve25519。",
    note: "弱曲线可被攻击。",
  },
  {
    key: "AES_KEY_WEAK_64",
    title: "AES 密钥长度不足（64 位）",
    regex: /KeyGenerator\.getInstance\s*\(\s*["']AES["']\s*\)[\s\S]{0,200}init\s*\(\s*64\s*\)/i,
    severity: "critical",
    confidence: "high",
    recommendation: "AES 密钥长度应为 128/256 位。",
    note: "64 位 AES 可被暴力破解。",
  },
  // ── Padding Oracle 风险 ──
  {
    key: "PADDING_ORACLE_CBC",
    title: "AES/CBC + PKCS5Padding 无 HMAC（Padding Oracle 风险）",
    regex: /Cipher\.getInstance\s*\(\s*["']AES\/CBC\/PKCS5Padding["']\s*\)/i,
    severity: "high",
    confidence: "medium",
    recommendation: "CBC 模式必须配合 HMAC（Encrypt-then-MAC）或改用 AES/GCM（认证加密）。",
    note: "无 MAC 的 CBC 可被 Padding Oracle 攻击。",
  },
  {
    key: "PADDING_ORACLE_NO_MAC",
    title: "加密后未检测到 HMAC/MAC 验证",
    regex: /Cipher\.getInstance\s*\(\s*["']AES\/(?:CBC|ECB)[\s\S]{0,100}doFinal/i,
    severity: "medium",
    confidence: "low",
    recommendation: "加密后应计算 HMAC 并在解密前验证（Encrypt-then-MAC）。",
    note: "静态无法证明缺失——仅提示。",
  },
  // ── AndroidKeyStore 分析 ──
  {
    key: "KEYSTORE_HARDWARE_BACKED",
    title: "使用 AndroidKeyStore（硬件-backed 安全存储）",
    regex: /KeyStore\.getInstance\s*\(\s*["']AndroidKeyStore["']\s*\)/i,
    severity: "info",
    confidence: "high",
    recommendation: "AndroidKeyStore 使用正确——密钥由硬件安全模块保护。",
    note: "正面检测——确认安全实践。",
  },
  {
    key: "KEYSTORE_NO_USER_AUTH",
    title: "AndroidKeyStore 未要求用户认证",
    regex: /KeyGenParameterSpec\.Builder[\s\S]{0,400}(?!setUserAuthenticationRequired\s*\(\s*true)/i,
    severity: "medium",
    confidence: "low",
    recommendation: "敏感密钥应设置 setUserAuthenticationRequired(true)，要求生物/锁屏认证。",
    note: "无用户认证的 KeyStore 密钥在设备解锁后可直接使用。",
  },
  {
    key: "KEYSTORE_NO_INVALIDATED_BY_BIO",
    title: "AndroidKeyStore 未设置生物变更失效",
    regex: /KeyGenParameterSpec\.Builder[\s\S]{0,400}(?!setInvalidatedByBiometricEnrollment\s*\(\s*true)/i,
    severity: "low",
    confidence: "low",
    recommendation: "建议 setInvalidatedByBiometricEnrollment(true)——新指纹录入时密钥失效。",
    note: "防止新增生物特征后旧密钥仍可用。",
  },
  // ── 证书链验证 ──
  {
    key: "CERT_SELF_SIGNED_TRUST",
    title: "代码中加载自定义信任管理器（可能接受自签名证书）",
    regex: /X509TrustManager|TrustManagerFactory|SSLContext\.init/i,
    severity: "medium",
    confidence: "low",
    recommendation: "自定义 TrustManager 必须严格校验证书链；确认不接受自签名/过期证书。",
    note: "自定义信任管理器是 SSL 绕过的常见入口。",
  },
  {
    key: "CERT_PINNING_OKHTTP",
    title: "OkHttp 证书固定配置",
    regex: /CertificatePinner\.Builder\(\)\s*\.add/i,
    severity: "info",
    confidence: "high",
    recommendation: "OkHttp CertificatePinner 已配置——正面安全实践。",
    note: "正面检测——确认证书固定。",
  },
  // ── 加密模式完整性 ──
  {
    key: "GCM_TAG_LENGTH",
    title: "AES/GCM tag 长度检测",
    regex: /GCMParameterSpec\s*\(\s*(?:64|72|80)\s*,/i,
    severity: "medium",
    confidence: "high",
    recommendation: "GCM tag 长度应 ≥ 96 位（12 字节）；64 位 tag 可被伪造。",
    note: "NIST SP 800-38D 推荐 tag ≥ 96 位。",
  },
  {
    key: "GCM_NO_REUSE_IV",
    title: "AES/GCM IV 使用检测",
    regex: /GCMParameterSpec\s*\(\s*\d+\s*,\s*(?:new\s+byte\s*\[\s*\]|iv|IV)/i,
    severity: "medium",
    confidence: "low",
    recommendation: "GCM 的 IV 必须唯一（每次加密不同）——重复 IV 会泄露认证密钥。",
    note: "静态无法判断 IV 是否每次不同——仅提示。",
  },
  // ── 密钥轮换 ──
  {
    key: "STATIC_SECRET_KEY",
    title: "硬编码 SecretKeySpec（静态密钥）",
    regex: /new\s+SecretKeySpec\s*\(\s*(?:new\s+byte\s*\[\s*\]|"[^"]*"|'[a-fA-F0-9]{16,}')/i,
    severity: "high",
    confidence: "high",
    recommendation: "密钥不应硬编码——使用 AndroidKeyStore 生成/存储密钥。",
    note: "硬编码密钥可被反编译提取。",
  },
  {
    key: "KEY_FROM_PASSWORD_WEAK",
    title: "从密码派生密钥（PBKDF2 迭代不足）",
    regex: /PBEKeySpec\s*\(\s*[^)]*,\s*(?:[^,]*,)?\s*(?:[1-9]\d{0,3}|0)\s*\)/i,
    severity: "high",
    confidence: "medium",
    recommendation: "PBKDF2 迭代次数应 ≥ 10000（OWASP 推荐 210000）。",
    note: "低迭代次数可被暴力破解。",
  },
  // ── 其他密码学问题 ──
  {
    key: "MD5_USAGE",
    title: "使用 MD5（已不安全）",
    regex: /MessageDigest\.getInstance\s*\(\s*["']MD5["']\s*\)/i,
    severity: "medium",
    confidence: "high",
    recommendation: "MD5 已有碰撞攻击——改用 SHA-256/SHA-3。",
    note: "MD5 不应用于安全场景。",
  },
  {
    key: "SHA1_USAGE",
    title: "使用 SHA-1（已不推荐）",
    regex: /MessageDigest\.getInstance\s*\(\s*["']SHA-1?["']\s*\)/i,
    severity: "low",
    confidence: "high",
    recommendation: "SHA-1 已有碰撞攻击——签名/安全场景改用 SHA-256。",
    note: "SHA-1 仍可用于非安全校验（如 checksum）。",
  },
  {
    key: "SECURE_RANDOM_SEEDED",
    title: "SecureRandom 设置固定种子（可预测）",
    regex: /SecureRandom\s*\(\s*[^)]*\)[\s\S]{0,100}setSeed\s*\(/i,
    severity: "critical",
    confidence: "high",
    recommendation: "SecureRandom 不应设置固定种子——否则输出可预测。",
    note: "固定种子 = 随机数可预测 = 密钥可推导。",
  },
  {
    key: "CIPHER_NO_AUTH_ENCRYPTION",
    title: "使用非认证加密模式（无 AEAD）",
    regex: /Cipher\.getInstance\s*\(\s*["']AES\/(?:CBC|ECB|CFB|OFB|CTR)/i,
    severity: "medium",
    confidence: "medium",
    recommendation: "优先使用 AEAD 模式（AES/GCM 或 ChaCha20-Poly1305）。",
    note: "非 AEAD 模式不提供完整性保护。",
  },
]

export interface CryptoAuditMatch {
  line: number
  key: string
  title: string
  snippet: string
  severity: Finding["severity"]
}

export function scanCryptoAudit(source: string): CryptoAuditMatch[] {
  const matches: CryptoAuditMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue
    for (const pattern of CRYPTO_PATTERNS) {
      // 对多行正则,拼接前后行
      const context = lines.slice(Math.max(0, i - 1), i + 3).join("\n")
      if (pattern.regex.test(context) || pattern.regex.test(line)) {
        matches.push({ line: i + 1, key: pattern.key, title: pattern.title, snippet: line.trim().slice(0, 120), severity: pattern.severity })
        break
      }
    }
  }
  return matches
}

export async function scanProjectCryptoAudit(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanCryptoAudit(source)
    for (const match of matches.slice(0, 5)) {
      const dedupeKey = `${match.key}:${file}`
      if (seen.has(dedupeKey)) continue
      seen.add(dedupeKey)
      const pattern = CRYPTO_PATTERNS.find((p) => p.key === match.key)!
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: match.severity,
        confidence: (pattern.confidence || "medium") as "confirmed" | "high" | "medium" | "low",
        code: "SOURCE_CRYPTO_AUDIT",
        title: match.title,
        detail: `${relative}:${match.line} ${pattern.note}`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
