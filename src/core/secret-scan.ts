// Shared secret scanner. Shape-specific tokens are high-confidence; generic
// assignments must also pass value-only entropy and placeholder filters.
import { readFile } from "node:fs/promises"
import type { FindingConfidence } from "./types.ts"

export interface SecretHit {
  code: string
  label: string
  confidence: FindingConfidence
  // Redacted preview of the matched value (never the full secret).
  preview: string
}

export interface SecretPattern {
  code: string
  label: string
  regex: RegExp
  confidence: FindingConfidence
  // When set, entropy is calculated from this capture group, not the key name.
  valueGroup?: number
  minEntropy?: number
  // 厂商/平台元数据（apkleaks 差距④——报告分类与针对性提示）。
  vendor?: string
}

// Well-known credential shapes. Ordered most-specific first so labelling is stable.
export const SECRET_PATTERNS: readonly SecretPattern[] = [
  { code: "PRIVATE_KEY_PEM", label: "PEM 私钥块", regex: /-----BEGIN (?:RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----/, confidence: "confirmed" },
  { code: "AWS_ACCESS_KEY", label: "AWS Access Key", regex: /\b(?:AKIA|ASIA)[0-9A-Z]{16}\b/, confidence: "high" },
  { code: "GOOGLE_API_KEY", label: "Google API Key", regex: /\bAIza[0-9A-Za-z_-]{35}\b/, confidence: "high" },
  { code: "GITHUB_TOKEN", label: "GitHub Token", regex: /\b(?:ghp|gho|ghu|ghs|ghr)_[0-9A-Za-z]{36}\b|\bgithub_pat_[0-9A-Za-z_]{22,}\b/, confidence: "high" },
  { code: "SLACK_TOKEN", label: "Slack Token", regex: /\bxox[baprs]-[0-9A-Za-z-]{10,}\b/, confidence: "high" },
  { code: "STRIPE_KEY", label: "Stripe 密钥", regex: /\b(?:sk|rk)_(?:live|test)_[0-9A-Za-z]{16,}\b/, confidence: "high" },
  { code: "JWT", label: "JWT", regex: /\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b/, confidence: "high" },
  { code: "BEARER_TOKEN", label: "Bearer Token", regex: /\bBearer\s+[0-9A-Za-z._-]{20,}\b/, confidence: "high" },
  // 多平台密钥格式扩充（apkleaks 差距①——几十种常见厂商密钥）
  { code: "TWILIO_API_KEY", label: "Twilio API Key", regex: /\bSK[0-9a-fA-F]{32}\b/, confidence: "high", vendor: "Twilio" },
  { code: "SENDGRID_API_KEY", label: "SendGrid API Key", regex: /\bSG\.[0-9A-Za-z_-]{22}\.[0-9A-Za-z_-]{43}\b/, confidence: "high", vendor: "SendGrid" },
  { code: "DISCORD_TOKEN", label: "Discord Bot Token", regex: /\bM[A-Za-z0-9_-]{23}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27}\b/, confidence: "high", vendor: "Discord" },
  { code: "FACEBOOK_TOKEN", label: "Facebook Token", regex: /\bEAACEdE0[0-9A-Za-z]{60,}\b/, confidence: "high", vendor: "Facebook" },
  { code: "HEROKU_API_KEY", label: "Heroku API Key", regex: /\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b/, confidence: "medium", vendor: "Heroku" },
  { code: "SHOPIFY_TOKEN", label: "Shopify Access Token", regex: /\bshp(?:at|ss|pa|ka|ps)_[0-9a-fA-F]{32}\b/, confidence: "high", vendor: "Shopify" },
  { code: "SQUARE_TOKEN", label: "Square Token", regex: /\bsq0atp-[0-9A-Za-z_-]{22}\b/, confidence: "high", vendor: "Square" },
  { code: "ZENDESK_TOKEN", label: "Zendesk Token", regex: /\bx[0-9A-Za-z_-]{32}\b/, confidence: "medium", vendor: "Zendesk" },
  { code: "POSTMAN_TOKEN", label: "Postman Token", regex: /\bPMAK-[0-9a-fA-F]{24}-[0-9a-fA-F]{34}\b/, confidence: "high", vendor: "Postman" },
  { code: "NPM_TOKEN", label: "npm Token", regex: /\bnpm_[0-9A-Za-z]{36}\b/, confidence: "high", vendor: "npm" },
  { code: "SENTRY_TOKEN", label: "Sentry Token", regex: /\b(?:[0-9a-fA-F]{64})\b/, confidence: "medium", vendor: "Sentry" },
  { code: "TELEGRAM_TOKEN", label: "Telegram Bot Token", regex: /\b[0-9]{8,10}:[A-Za-z0-9_-]{35}\b/, confidence: "high", vendor: "Telegram" },
  { code: "AZURE_SAS", label: "Azure SAS Token", regex: /\bsig=[0-9A-Za-z%]{30,}\b/, confidence: "medium", vendor: "Azure" },
  { code: "OPENAI_API_KEY", label: "OpenAI API Key", regex: /\bsk-[0-9A-Za-z]{20,}\b/, confidence: "high", vendor: "OpenAI" },
  { code: "GEMINI_API_KEY", label: "Gemini API Key", regex: /\bAIza[0-9A-Za-z_-]{35}\b/, confidence: "high", vendor: "Google" },
  { code: "ANTHROPIC_API_KEY", label: "Anthropic API Key", regex: /\bsk-ant-[0-9A-Za-z_-]{20,}\b/, confidence: "high", vendor: "Anthropic" },
  { code: "HUGGINGFACE_TOKEN", label: "Hugging Face Token", regex: /\bhf_[0-9A-Za-z]{34}\b/, confidence: "high", vendor: "Hugging Face" },
  { code: "GITLAB_TOKEN", label: "GitLab Token", regex: /\bglpat-[0-9A-Za-z_-]{20,}\b/, confidence: "high", vendor: "GitLab" },
  { code: "BITBUCKET_TOKEN", label: "Bitbucket Token", regex: /\bATBB[0-9A-Za-z]{20,}\b/, confidence: "high", vendor: "Bitbucket" },
  {
    code: "GENERIC_CREDENTIAL",
    label: "疑似硬编码凭据赋值",
    regex: /(?:password|passwd|pwd|secret|api[_-]?key|apikey|access[_-]?token|auth[_-]?token|client[_-]?secret)\s*[:=]\s*["']?([0-9A-Za-z._\-+/]{12,})["']?/i,
    confidence: "medium",
    valueGroup: 1,
    minEntropy: 3.3,
  },
]

// Shannon entropy in bits/char. Empty string returns 0.
export function shannonEntropy(value: string): number {
  if (value.length === 0) return 0
  const counts = new Map<string, number>()
  for (const char of value) counts.set(char, (counts.get(char) ?? 0) + 1)
  let entropy = 0
  for (const count of counts.values()) {
    const p = count / value.length
    entropy -= p * Math.log2(p)
  }
  return entropy
}

// apkleaks 式密钥规则集导入（差距③——keyFormatsFile：厂商/正则映射文件合并）。
export interface KeyFormatRule {
  code: string
  label: string
  pattern: string
  confidence?: "confirmed" | "high" | "medium" | "low"
  vendor?: string
}

export async function loadKeyFormats(file: string): Promise<SecretPattern[]> {
  const raw = await readFile(file, "utf8")
  const rules = JSON.parse(raw) as KeyFormatRule[]
  if (!Array.isArray(rules)) throw new Error("密钥规则文件应为 JSON 数组")
  const patterns: SecretPattern[] = []
  for (const rule of rules) {
    if (!rule.code || !rule.label || !rule.pattern) {
      throw new Error(`密钥规则缺少 code/label/pattern：${JSON.stringify(rule).slice(0, 80)}`)
    }
    try {
      patterns.push({
        code: rule.code,
        label: rule.label,
        regex: new RegExp(rule.pattern),
        confidence: rule.confidence ?? "high",
        ...(rule.vendor ? { vendor: rule.vendor } : {}),
      })
    } catch {
      throw new Error(`密钥规则正则非法：${rule.code}`)
    }
  }
  return patterns
}

// 合并自定义密钥规则与内置（自定义追加——供扫描使用）。
export async function mergeKeyFormats(file: string | undefined): Promise<readonly SecretPattern[]> {
  if (!file) return SECRET_PATTERNS
  return [...SECRET_PATTERNS, ...(await loadKeyFormats(file))]
}

function redact(match: string): string {
  const trimmed = match.length > 48 ? `${match.slice(0, 24)}…${match.slice(-8)}` : match
  if (trimmed.length <= 8) return `${trimmed.slice(0, 2)}****`
  return `${trimmed.slice(0, 6)}****${trimmed.slice(-2)}`
}

function looksLikePlaceholder(value: string): boolean {
  const normalized = value.toLowerCase().replace(/[^a-z0-9]/g, "")
  if (/^(?:example|sample|dummy|test|testing|changeme|replace(?:me)?|your\w*|todo|undefined|null|password|secret|apikey|token|x+|0+|1+)$/.test(normalized)) {
    return true
  }
  return new Set(normalized).size < 4
}

// De-duplicates by (code, preview). Generic assignments are intentionally held
// to a stronger threshold than provider-specific token formats.
export function scanStringsForSecrets(
  strings: Iterable<string>,
  patterns: readonly SecretPattern[] = SECRET_PATTERNS,
): SecretHit[] {
  const seen = new Set<string>()
  const hits: SecretHit[] = []
  for (const value of strings) {
    if (typeof value !== "string" || value.length < 8) continue
    for (const pattern of patterns) {
      const match = pattern.regex.exec(value)
      if (!match) continue
      const candidate = pattern.valueGroup === undefined ? match[0] : (match[pattern.valueGroup] ?? "")
      if (pattern.valueGroup !== undefined && looksLikePlaceholder(candidate)) continue
      if (pattern.minEntropy !== undefined && shannonEntropy(candidate) < pattern.minEntropy) continue
      const preview = redact(candidate)
      const key = `${pattern.code}:${preview}`
      if (seen.has(key)) continue
      seen.add(key)
      hits.push({ code: pattern.code, label: pattern.label, confidence: pattern.confidence, preview })
    }
  }
  return hits
}
export function strongestSecretConfidence(hits: readonly SecretHit[]): FindingConfidence {
  if (hits.some((hit) => hit.confidence === "confirmed")) return "confirmed"
  if (hits.some((hit) => hit.confidence === "high")) return "high"
  if (hits.some((hit) => hit.confidence === "medium")) return "medium"
  return "low"
}


// True when the string is an unambiguous embedded private key (PEM header).
export function containsPrivateKey(value: string): boolean {
  return SECRET_PATTERNS[0]!.regex.test(value)
}
