// JS 源码审计（Semgrep 差距③——js-audit.ts）。
// 混合应用的 JS 资源审计：硬编码密钥 / 危险 API（innerHTML/eval/动态脚本注入）/
// 弱加密（MD5/SHA1）。失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { decodeObfuscated } from "./obfuscation-decode.ts"
import type { Finding } from "./types.ts"

interface JsPattern {
  code: string
  title: string
  severity: "medium" | "low"
  regex: RegExp
  recommendation: string
}

const JS_PATTERNS: readonly JsPattern[] = [
  {
    code: "SOURCE_JS_HARDCODED_SECRET",
    title: "JS 资源中硬编码敏感值",
    severity: "medium",
    regex: /(?:api[_-]?key|apikey|password|passwd|secret|token|access[_-]?key|client[_-]?secret)\s*[:=]\s*["'][^"']{8,}["']/i,
    recommendation: "JS 中的密钥会被提取——移入服务端或运行时获取，避免打包进资源。",
  },
  {
    code: "SOURCE_JS_DANGEROUS_API",
    title: "JS 使用危险 API（innerHTML/eval/动态脚本）",
    severity: "medium",
    regex: /innerhtml\s*=|eval\(|document\.write\(|new\s+Function\(|createelement\(['"]script['"]\)/i,
    recommendation: "危险 API 可能引发 XSS/代码注入——改用安全的 DOM 操作并避免动态脚本加载不可信内容。",
  },
  {
    code: "SOURCE_JS_WEAK_CRYPTO",
    title: "JS 使用弱加密（MD5/SHA1）",
    severity: "low",
    regex: /md5\(|sha1\(|['"]md5['"]|['"]sha-?1['"]/i,
    recommendation: "MD5/SHA1 已不安全——改用 SHA-256 或更安全的哈希/加密。",
  },
]

// 扫描单个 JS 文件（失败关闭）。
export function scanJsFile(source: string): Array<{ line: number; code: string; title: string; snippet: string }> {
  const matches: Array<{ line: number; code: string; title: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (line.includes("droidseal-ignore")) continue // suppression 忽略
    for (const pattern of JS_PATTERNS) {
      if (pattern.regex.test(line)) {
        matches.push({ line: i + 1, code: pattern.code, title: pattern.title, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目中的 JS 资源（assets/www 等——失败关闭）。
export async function scanProjectJsAudit(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/assets/www", "src/main/assets", "assets/www", "www", "app/src/main/assets/www"]
  const jsFiles: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(js|mjs)$/.test(entry)) jsFiles.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  for (const file of jsFiles.slice(0, 300)) {
    const source = await readFile(file, "utf8").catch(() => "")
    // 自动反混淆(（工具）):先解码混淆层(atob/eval——解码后扫描)
    const { decoded, layers } = decodeObfuscated(source)
    const matches = scanJsFile(decoded)
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 3)) {
      const pattern = JS_PATTERNS.find((p) => p.code === match.code)!
      findings.push({
        severity: pattern.severity,
        confidence: "medium",
        code: match.code,
        title: match.title,
        detail: `${relative}:${match.line} 检测到 JS 敏感模式。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
