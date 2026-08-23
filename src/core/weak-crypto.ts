// 弱加密算法检测（下一阶段短期②——MobSF 缺口）。
// 源码模式匹配：AES 无模式（默认 ECB）/AES-ECB/DES/3DES/硬编码 IV——失败关闭
// （命中即清单级提示，不阻断；未命中不输出）。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface WeakCryptoPattern {
  key: string
  title: string
  regex: RegExp
  recommendation: string
}

const WEAK_PATTERNS: readonly WeakCryptoPattern[] = [
  {
    key: "AES_DEFAULT_ECB",
    title: "AES 未指定模式（默认 ECB）",
    regex: /cipher\.getinstance\(\s*["']aes["']\s*\)/i,
    recommendation: "使用 AES/GCM（带随机 IV），避免 ECB 模式。",
  },
  {
    key: "AES_ECB",
    title: "AES/ECB 模式",
    regex: /cipher\.getinstance\(\s*["']aes\/ecb/i,
    recommendation: "改用 AES/GCM 或 AES/CBC + 随机 IV（ECB 泄露明文模式）。",
  },
  {
    key: "DES_SINGLE",
    title: "DES（单重）",
    regex: /cipher\.getinstance\(\s*["']des["']\s*\)/i,
    recommendation: "DES 已不安全——改用 AES/GCM。",
  },
  {
    key: "DESEDE_3DES",
    title: "3DES（DESede）",
    regex: /cipher\.getinstance\(\s*["']dese?de/i,
    recommendation: "3DES 已弱化——改用 AES/GCM。",
  },
  {
    key: "HARDCODED_IV",
    title: "硬编码 IV",
    regex: /ivparameterspec\(\s*new byte\[\]\s*\{/i,
    recommendation: "IV 必须随机生成（每次加密新 IV），硬编码 IV 会破坏语义安全。",
  },
]

export interface WeakCryptoMatch {
  line: number
  key: string
  title: string
  snippet: string
}

// 源码弱加密检测：逐行匹配模式（失败关闭）。
export function scanWeakCrypto(source: string): WeakCryptoMatch[] {
  const matches: WeakCryptoMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue // suppression 注释忽略(⑦)
    for (const pattern of WEAK_PATTERNS) {
      if (pattern.regex.test(line)) {
        matches.push({ line: i + 1, key: pattern.key, title: pattern.title, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码，返回 SOURCE_WEAK_CRYPTO findings（失败关闭）。
export async function scanProjectWeakCrypto(projectRoot: string): Promise<Finding[]> {
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
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanWeakCrypto(source)
    if (matches.length === 0) continue
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 2)) {
      const pattern = WEAK_PATTERNS.find((p) => p.key === match.key)!
      findings.push({
        severity: "low",
        confidence: "medium",
        code: "SOURCE_WEAK_CRYPTO",
        title: match.title,
        detail: `${relative}:${match.line} 使用弱加密（${match.key}）。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
