// 自定义规则文件加载（下一阶段短期④——MobSF 缺口：YARA 式 JSON/正则规则）。
// 规则文件（JSON 数组）：{ code, title, severity, pattern, scope, recommendation? }
//   scope: "source"（源码文件）| "dex"（DEX 字符串池）| "all"
// 失败关闭：规则文件格式错误报错；pattern 非法跳过并记录；未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

export interface CustomRule {
  code: string
  title: string
  severity: "critical" | "high" | "medium" | "low" | "info"
  pattern: string
  scope: "source" | "dex" | "all"
  recommendation?: string
  // 精确模式（Semgrep AST 级匹配的务实替代——词边界包裹——降误报）。
  exact?: boolean
}

const SEVERITIES = ["critical", "high", "medium", "low", "info"]

export function parseCustomRules(text: string): CustomRule[] {
  const parsed = JSON.parse(text) as unknown
  if (!Array.isArray(parsed)) throw new Error("自定义规则文件应为 JSON 数组")
  const rules: CustomRule[] = []
  for (const [index, raw] of parsed.entries()) {
    const rule = raw as Partial<CustomRule>
    if (!rule.code || !rule.title || !rule.pattern) {
      throw new Error(`自定义规则 #${index + 1} 缺 code/title/pattern`)
    }
    if (!SEVERITIES.includes(rule.severity ?? "")) {
      throw new Error(`自定义规则 #${index + 1}（${rule.code}）severity 非法`)
    }
    if (rule.scope !== "source" && rule.scope !== "dex" && rule.scope !== "all") {
      throw new Error(`自定义规则 #${index + 1}（${rule.code}）scope 应为 source/dex/all`)
    }
    new RegExp(rule.pattern) // 验证正则合法性（失败关闭）
    rules.push({
      code: rule.code,
      title: rule.title,
      severity: rule.severity as CustomRule["severity"],
      pattern: rule.pattern,
      scope: rule.scope,
      ...(rule.recommendation ? { recommendation: rule.recommendation } : {}),
      ...(rule.exact === true ? { exact: true } : {}),
    })
  }
  return rules
}

export async function loadCustomRules(rulesFile: string): Promise<CustomRule[]> {
  return parseCustomRules(await readFile(rulesFile, "utf8"))
}

// 对字符串集合匹配规则（失败关闭：非法正则已过滤；命中生成 finding）。
export function matchCustomRules(rules: readonly CustomRule[], strings: Iterable<string>, scope: "source" | "dex"): Finding[] {
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const rule of rules) {
    if (rule.scope !== scope && rule.scope !== "all") continue
    // 精确模式：词边界包裹（exact: true——精确代码匹配——降误报）
    const regex = rule.exact ? new RegExp(`\\b(?:${rule.pattern})\\b`, "i") : new RegExp(rule.pattern)
    for (const s of strings) {
      if (regex.test(s)) {
        const key = `${rule.code}:${s.slice(0, 60)}`
        if (seen.has(key)) continue
        seen.add(key)
        findings.push({
          severity: rule.severity,
          code: rule.code,
          title: rule.title,
          detail: `自定义规则命中（${scope}）：${s.slice(0, 120)}`,
          recommendation: rule.recommendation ?? "核对并修复该自定义规则命中的内容。",
          evidence: s.slice(0, 80),
        })
        break
      }
    }
  }
  return findings
}

// 扫描项目源码应用 source 规则（失败关闭）。
export async function applyCustomRulesToProject(rules: readonly CustomRule[], projectRoot: string): Promise<Finding[]> {
  const sourceRules = rules.filter((r) => r.scope === "source" || r.scope === "all")
  if (sourceRules.length === 0) return []
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const lines: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries.slice(0, 400)) {
      if (/\.(java|kt)$/.test(entry)) {
        const source = await readFile(path.join(dir, entry), "utf8").catch(() => "")
        lines.push(...source.split(/\r?\n/))
      }
    }
  }
  return matchCustomRules(sourceRules, lines, "source")
}
