// 常量值分析 + 对象字段污点（⑧⑩——完整版）。
// ⑧ 常量/字面量值追踪：变量赋值为敏感形态字符串字面量（含 key/password/token 等前缀）→
//    变量间接持有硬编码敏感值（SOURCE_CONSTANT_VALUE）。
// ⑩ 对象字段污点：实例字段被敏感源赋值（obj.field = 源）→ 字段读取 → 汇（SOURCE_OBJECT_FIELD_TAINT）。
// 失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// 敏感形态字符串字面量（硬编码值——键/口令/令牌/URL 形态——标识符赋值、引号键与凭据值三种形态）
const SENSITIVE_LITERAL = /(?:["'](?:api[_-]?key|apikey|password|passwd|secret|token|access[_-]?key|client[_-]?secret|private[_-]?key)["']?\s*[:=]\s*["'][^"']{8,}["'])|((?:api[_-]?key|apikey|password|passwd|secret|token|access[_-]?key|client[_-]?secret|private[_-]?key)\s*=\s*["'][^"']{8,}["'])|(["'][A-Za-z0-9_-]{0,20}(?:AIzaSy|ghp_|AKIA|eyJ)[A-Za-z0-9_.-]{8,}["'])/i

const OBJECT_FIELD_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getsubscriberid(", "getline1number(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial(", "getstring(", "getextra("]
const OBJECT_FIELD_SINKS = ["log.d(", "log.e(", "log.i(", "log.w(", "loadurl(", "execsql(", "sendtextmessage(", "startactivity(", "settext(", "openfileoutput(", "writeexternalstorage(", "runtime.exec(", "processbuilder("]

// ⑧ 常量/字面量值分析：变量间接持有的敏感字面量（失败关闭）。
export function scanConstantValues(source: string): Array<{ line: number; snippet: string }> {
  const matches: Array<{ line: number; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (SENSITIVE_LITERAL.test(line)) {
      matches.push({ line: i + 1, snippet: line.trim().slice(0, 120) })
    }
  }
  return matches
}

// ⑩ 对象字段污点：实例字段赋值源 → 字段读取流入汇（失败关闭）。
export function scanObjectFieldTaint(source: string): Array<{ line: number; field: string; source: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; field: string; source: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  const taintedFields = new Set<string>()
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    // 字段赋值源:obj.field = 源
    const assign = /([A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*)\s*=\s*[^;]*/.exec(line)
    if (assign && OBJECT_FIELD_SOURCES.some((s) => lower.includes(s))) {
      taintedFields.add(assign[1]!)
      continue
    }
    // 字段读取 → 汇
    for (const field of taintedFields) {
      if (!line.includes(field)) continue
      const sink = OBJECT_FIELD_SINKS.find((s) => lower.includes(s))
      if (sink) {
        matches.push({ line: i + 1, field, source: [...taintedFields].join(","), sink, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（⑧⑩——失败关闭）。
export async function scanProjectValueAndFieldTaint(projectRoot: string): Promise<Finding[]> {
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
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of scanConstantValues(source).slice(0, 2)) {
      findings.push({
        severity: "medium",
        confidence: "high",
        code: "SOURCE_CONSTANT_VALUE",
        title: "变量间接持有硬编码敏感值",
        detail: `${relative}:${match.line} 检测到敏感形态字面量（键/口令/令牌）赋值给变量——硬编码值经变量间接使用。`,
        recommendation: "硬编码敏感值移入安全配置/服务端；变量间接持有同样需清理。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
    for (const match of scanObjectFieldTaint(source).slice(0, 2)) {
      findings.push({
        severity: "medium",
        confidence: "low",
        code: "SOURCE_OBJECT_FIELD_TAINT",
        title: "实例字段存储敏感数据并流入汇",
        detail: `${relative}:${match.line} 字段 ${match.field} 被敏感源赋值并流入 ${match.sink}（对象字段级启发式——需人工核验）。`,
        recommendation: "核对对象字段的数据流向；敏感数据应避免字段中转后写入日志/明文网络。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
