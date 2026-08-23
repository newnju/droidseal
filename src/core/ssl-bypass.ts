// SSL 证书校验绕过语义检测（AndroBugs 差距①——字节码语义分析深化的源码级前置）。
// 检测自定义 TrustManager（可能信任所有证书）、checkServerTrusted 空实现、
// ALLOW_ALL 主机名校验器等证书校验绕过模式——失败关闭（未命中不输出）。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface SslBypassPattern {
  key: string
  title: string
  regex: RegExp
  recommendation: string
}

const SSL_BYPASS_PATTERNS: readonly SslBypassPattern[] = [
  {
    key: "CUSTOM_TRUST_MANAGER",
    title: "自定义 TrustManager（可能信任所有证书）",
    regex: /x509trustmanager|trustall/i,
    recommendation: "自定义 TrustManager 必须校验证书链与主机名；如为信任所有，应改为系统默认校验器。",
  },
  {
    key: "EMPTY_CHECK_SERVER_TRUSTED",
    title: "checkServerTrusted 空实现（证书校验被绕过）",
    regex: /checkServerTrusted\s*\([^)]*\)\s*\{\s*\}/i,
    recommendation: "空 checkServerTrusted 表示不校验服务器证书——应实现真实校验或使用系统默认。",
  },
  {
    key: "ALLOW_ALL_HOSTNAME_VERIFIER",
    title: "ALLOW_ALL 主机名校验器（主机名校验被绕过）",
    regex: /allowallhostnameverifier/i,
    recommendation: "ALLOW_ALL 接受任意主机名——应改为严格主机名校验。",
  },
  {
    key: "CUSTOM_HOSTNAME_VERIFIER",
    title: "自定义主机名校验器",
    regex: /setHostnameVerifier\(/i,
    recommendation: "自定义主机名校验器需确认校验逻辑；常见实现直接返回 true（绕过）。",
  },
]

export interface SslBypassMatch {
  line: number
  key: string
  title: string
  snippet: string
}

// 逐行匹配 SSL 绕过模式（失败关闭）。
export function scanSslBypass(source: string): SslBypassMatch[] {
  const matches: SslBypassMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue // suppression 注释忽略(⑦)
    for (const pattern of SSL_BYPASS_PATTERNS) {
      if (pattern.regex.test(line)) {
        matches.push({ line: i + 1, key: pattern.key, title: pattern.title, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectSslBypass(projectRoot: string): Promise<Finding[]> {
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
    const matches = scanSslBypass(source)
    for (const match of matches) {
      const key = `${match.key}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const pattern = SSL_BYPASS_PATTERNS.find((p) => p.key === match.key)!
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "medium",
        confidence: "medium",
        code: "SOURCE_SSL_BYPASS",
        title: match.title,
        detail: `${relative}:${match.line} 检测到 SSL 证书校验绕过特征（${match.key}）。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
