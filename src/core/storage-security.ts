// 证书固定缺失 + 明文存储审计（MobSF 剩余缺口——源码模式，失败关闭）。
// 检测：网络库使用但未检测到证书固定（pinning）特征；SQLite 使用但未检测到 SQLCipher 加密。
// 均为低置信度清单提示（静态无法证明缺失——提示评估），未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface StorageSecurityPattern {
  code: string
  title: string
  trigger: RegExp
  missing: RegExp[]
  recommendation: string
}

const PATTERNS: readonly StorageSecurityPattern[] = [
  {
    code: "SOURCE_NO_CERT_PINNING",
    title: "未检测到证书固定（SSL pinning）配置",
    trigger: /okhttpclient|http(s)?urlconnection|retrofit/i,
    missing: [/certificatepinner/i, /trustmanager/i, /networksecurityconfig/i],
    recommendation: "评估关键端点启用证书固定（OkHttp CertificatePinner / NetworkSecurityConfig），降低中间人风险。",
  },
  {
    code: "SOURCE_UNENCRYPTED_STORAGE",
    title: "SQLite 数据库明文存储（未检测到 SQLCipher）",
    trigger: /sqldatabase|openordatabase/i,
    missing: [/net\.zetetic|sqlcipher/i],
    recommendation: "敏感数据建议 SQLCipher 加密或服务端存储；至少核对库文件是否含敏感明文。",
  },
]

export interface StorageSecurityMatch {
  line: number
  code: string
  title: string
  snippet: string
}

// 逐行检测：trigger 命中且同文件未出现 missing 特征 → 提示（低置信度，失败关闭）。
export function scanStorageSecurity(source: string): StorageSecurityMatch[] {
  const matches: StorageSecurityMatch[] = []
  for (const pattern of PATTERNS) {
    if (!pattern.trigger.test(source)) continue
    if (pattern.missing.some((regex) => regex.test(source))) continue
    const lines = source.split(/\r?\n/)
    for (let i = 0; i < lines.length; i += 1) {
      const line = lines[i]!
      if (pattern.trigger.test(line)) {
        matches.push({ line: i + 1, code: pattern.code, title: pattern.title, snippet: line.trim().slice(0, 100) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectStorageSecurity(projectRoot: string): Promise<Finding[]> {
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
    const matches = scanStorageSecurity(source)
    for (const match of matches) {
      const key = `${match.code}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const pattern = PATTERNS.find((p) => p.code === match.code)!
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "low",
        confidence: "low",
        code: match.code,
        title: match.title,
        detail: `${relative}:${match.line} 触发（静态提示——需人工评估确认）。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
