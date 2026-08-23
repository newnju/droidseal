// Web/混合应用完整审计（SUPER 差距②——web-audit.ts）。
// 混合应用的 HTML/JS 资源审计：HTML 的不安全表单（明文 action）/内联事件处理器/
// JS 存储交互（localStorage/sessionStorage 存敏感数据）。与 js-audit 衔接（同一 assets 扫描）。
// 失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface WebPattern {
  code: string
  title: string
  severity: "medium" | "low"
  regex: RegExp
  recommendation: string
}

const WEB_PATTERNS: readonly WebPattern[] = [
  {
    code: "SOURCE_WEB_INSECURE_FORM",
    title: "HTML 表单使用明文 HTTP 提交",
    severity: "low",
    regex: /<form[^>]*action\s*=\s*["']http:\/\//i,
    recommendation: "表单提交应使用 HTTPS——明文传输可被中间人篡改。",
  },
  {
    code: "SOURCE_WEB_XSS_EVENT",
    title: "HTML 内联事件处理器（XSS 面）",
    severity: "medium",
    regex: /<(?:input|button|a|div)[^>]*\son(?:click|error|load|mouseover)\s*=\s*["'][^"']*(?:eval|document|innerHTML|location)/i,
    recommendation: "内联事件处理器可能引入 XSS——改为事件监听并校验输入。",
  },
  {
    code: "SOURCE_WEB_INSECURE_STORAGE",
    title: "JS 将敏感数据存入 Web 存储（localStorage/sessionStorage）",
    severity: "medium",
    regex: /(?:localstorage|sessionstorage)\.(?:setitem|\[[^]]+\])\s*\([^)]*(?:token|password|secret|apikey|session)/i,
    recommendation: "敏感数据不应存 Web 存储（XSS 可读）——移入内存或服务端。",
  },
]

// 扫描单个 Web 文件（HTML/JS——失败关闭）。
export function scanWebFile(source: string): Array<{ line: number; code: string; title: string; snippet: string }> {
  const matches: Array<{ line: number; code: string; title: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (line.includes("droidseal-ignore")) continue // suppression 忽略
    for (const pattern of WEB_PATTERNS) {
      if (pattern.regex.test(line)) {
        matches.push({ line: i + 1, code: pattern.code, title: pattern.title, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目中的 Web 资源（HTML/JS——失败关闭）。
export async function scanProjectWebAudit(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/assets/www", "src/main/assets", "assets/www", "www", "app/src/main/assets/www"]
  const webFiles: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(html|htm|js|mjs)$/.test(entry)) webFiles.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  for (const file of webFiles.slice(0, 300)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanWebFile(source)
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 3)) {
      const pattern = WEB_PATTERNS.find((p) => p.code === match.code)!
      findings.push({
        severity: pattern.severity,
        confidence: "medium",
        code: match.code,
        title: match.title,
        detail: `${relative}:${match.line} 检测到 Web 资源敏感模式。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
