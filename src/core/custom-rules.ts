// 自定义规则文件加载（下一阶段短期④——MobSF 缺口：YARA 式 JSON/正则规则）。
// 规则文件（JSON 数组）：{ code, title, severity, pattern, scope, recommendation? }
//   scope: "source"（源码文件）| "dex"（DEX 字符串池）| "all"
// 失败关闭：规则文件格式错误报错；pattern 非法跳过并记录；未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// Semgrep 式规则导入（mobsfscan 差距①——loadSemgrepRules）。
// 支持 Semgrep YAML（rules: - id / patterns: - pattern-regex）与 JSON（数组或 {rules: [...]}）。
// pattern-regex 提取为正则模式——转 CustomRule（scope 默认 source）。失败关闭。

const SEVERITY_MAP: Record<string, CustomRule["severity"]> = {
  ERROR: "high",
  WARNING: "medium",
  INFO: "info",
}

// 极简 YAML 规则解析：提取每个规则块的 id/message/severity/pattern-regex（行级解析——失败关闭）。
function parseSemgrepYaml(yaml: string): Array<{ id: string; message: string; severity?: string; patternRegex?: string; cwe?: string[]; owasp?: string[] }> {
  const blocks: Array<{ id: string; message: string; severity?: string; patternRegex?: string; cwe?: string[]; owasp?: string[] }> = []
  let current: (typeof blocks)[number] | undefined
  let collectingCwe = false
  let collectingOwasp = false
  for (const line of yaml.split(/\r?\n/)) {
    const trimmed = line.trim()
    if (/^-\s+id\s*:/.test(trimmed)) {
      current = { id: trimmed.replace(/^-\s+id\s*:\s*/, "").replace(/["']/g, ""), message: "" }
      blocks.push(current)
      collectingCwe = false
      collectingOwasp = false
      continue
    }
    if (!current) continue
    if (/^id\s*:/.test(trimmed)) current.id = trimmed.replace(/^id\s*:\s*/, "").replace(/["']/g, "")
    if (/^message\s*:/.test(trimmed)) current.message = trimmed.replace(/^message\s*:\s*/, "").replace(/["']/g, "")
    if (/^severity\s*:/.test(trimmed)) current.severity = trimmed.replace(/^severity\s*:\s*/, "").toUpperCase()
    // pattern-regex（含 "- pattern-regex:" 列表形式）
    if (/^(?:-\s*)?pattern-regex\s*:/.test(trimmed)) current.patternRegex = trimmed.replace(/^(?:-\s*)?pattern-regex\s*:\s*/, "").replace(/["']/g, "")
    // cwe/owasp：inline 数组（cwe: [CWE-798]）或列表形式（cwe:\n  - CWE-798）
    const cweInline = /^-\s*cwe\s*:\s*\[(.*)\]/.exec(trimmed)
    if (cweInline) {
      current.cwe = cweInline[1]!.split(",").map((c) => c.trim()).filter(Boolean)
      collectingCwe = false
    } else if (/^cwe\s*:/.test(trimmed)) {
      collectingCwe = true
      collectingOwasp = false
      continue
    } else if (collectingCwe && /^-\s*(CWE-\S+)/.test(trimmed)) {
      current.cwe = [...(current.cwe ?? []), trimmed.replace(/^-\s*/, "")]
      continue
    }
    const owaspInline = /^-\s*owasp\s*:\s*\[(.*)\]/.exec(trimmed)
    if (owaspInline) {
      current.owasp = owaspInline[1]!.split(",").map((o) => o.trim()).filter(Boolean)
      collectingOwasp = false
    } else if (/^owasp\s*:/.test(trimmed)) {
      collectingOwasp = true
      collectingCwe = false
    } else if (collectingOwasp && /^-\s*(A\d+)/.test(trimmed)) {
      current.owasp = [...(current.owasp ?? []), trimmed.replace(/^-\s*/, "")]
    }
  }
  return blocks.filter((b) => b.id && b.patternRegex)
}

// 加载 Semgrep 式规则文件（JSON 或极简 YAML）——返回自定义规则（失败关闭）。
export async function loadSemgrepRules(file: string): Promise<CustomRule[]> {
  const raw = await readFile(file, "utf8")
  const trimmed = raw.trimStart()
  const rules: CustomRule[] = []
  if (trimmed.startsWith("{") || trimmed.startsWith("[")) {
    const parsed = JSON.parse(raw) as Record<string, unknown> | unknown[]
    const list = Array.isArray(parsed) ? (parsed as unknown[]) : ((parsed as Record<string, unknown>).rules as unknown[])
    for (const entry of list as Array<Record<string, unknown>>) {
      const id = String(entry.id ?? "")
      const message = String(entry.message ?? "")
      const patterns = (entry.patterns as Array<Record<string, string>> | undefined) ?? []
      const patternRegex = patterns.map((p) => p["pattern-regex"]).find(Boolean)
      if (!id || !patternRegex) continue
      rules.push({
        code: id,
        title: message || id,
        severity: SEVERITY_MAP[String(entry.severity ?? "").toUpperCase()] ?? "medium",
        pattern: patternRegex,
        scope: "source",
      })
    }
  } else {
    for (const block of parseSemgrepYaml(raw)) {
      rules.push({
        code: block.id,
        title: block.message || block.id,
        severity: SEVERITY_MAP[block.severity ?? ""] ?? "medium",
        pattern: block.patternRegex!,
        scope: "source",
        ...(block.cwe?.length ? { cwe: block.cwe } : {}),
        ...(block.owasp?.length ? { owasp: block.owasp } : {}),
      })
    }
  }
  return rules
}

export interface CustomRule {
  code: string
  title: string
  severity: "critical" | "high" | "medium" | "low" | "info"
  pattern: string
  scope: "source" | "dex" | "all"
  recommendation?: string
  // 精确模式（Semgrep AST 级匹配的务实替代——词边界包裹——降误报）。
  exact?: boolean
  // 标准元数据（mobsfscan 差距②——CWE/OWASP 编号——报告标准对齐）。
  cwe?: string[]
  owasp?: string[]
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
      ...(Array.isArray(rule.cwe) ? { cwe: rule.cwe } : {}),
      ...(Array.isArray(rule.owasp) ? { owasp: rule.owasp } : {}),
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
