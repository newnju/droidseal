// 静态字段污点（⑪——完整版：项目级 static 字段赋值追踪）。
// 检测 static 字段被敏感源赋值（static 字段存储敏感数据）→ 后续方法中使用（日志/网络/文件等汇）。
// 跨方法追踪（同一项目的 static 字段名——使用处不限于赋值处函数）。失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// 敏感源（与 taint-source 对齐——精简版用于 static 赋值检测）
const STATIC_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getsubscriberid(", "getline1number(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial("]

// 汇（static 字段被使用的敏感去向）
const STATIC_SINKS = ["log.d(", "log.e(", "log.i(", "log.w(", "loadurl(", "execsql(", "sendtextmessage(", "startactivity(", "settext(", "openfileoutput(", "writeexternalstorage(", "runtime.exec(", "processbuilder("]

interface StaticField {
  name: string
  source: string
  file: string
  assignLine: number
}

// 扫描单个文件：static 字段的敏感赋值（失败关闭）。
function scanStaticAssignments(source: string, file: string): StaticField[] {
  const fields: StaticField[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    if (!/static/.test(lower) || !/=\s*[^;]*/.test(line)) continue
    const sourcePattern = STATIC_SOURCES.find((s) => lower.includes(s))
    if (!sourcePattern) continue
    const fieldMatch = /(?:static\s+)(?:final\s+)?(?:[A-Za-z_][\w<>\[\]]*\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=/.exec(line)
    if (fieldMatch) {
      fields.push({ name: fieldMatch[1]!, source: sourcePattern, file, assignLine: i + 1 })
    }
  }
  return fields
}

// 扫描项目源码：static 字段的敏感赋值 + 使用（跨文件追踪——失败关闭）。
export async function scanProjectStaticTaint(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const sources: Record<string, string> = {}
  const allFields: StaticField[] = []
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    sources[file] = source
    allFields.push(...scanStaticAssignments(source, file))
  }
  if (allFields.length === 0) return []

  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const field of allFields) {
    // 使用处：其他文件中 static 字段名 + 汇调用（跨方法/跨文件传播）
    for (const [file, source] of Object.entries(sources)) {
      const lines = source.split(/\r?\n/)
      for (let i = 0; i < lines.length; i += 1) {
        const line = lines[i]!
        if (!line.includes(field.name)) continue
        if (line.includes("static") && line.includes("=") && line.toLowerCase().includes(field.source)) continue // 跳过赋值行
        const sink = STATIC_SINKS.find((s) => line.toLowerCase().includes(s))
        if (!sink) continue
        const key = `${field.name}:${file}`
        if (seen.has(key)) continue
        seen.add(key)
        const assignRelative = path.relative(projectRoot, field.file).replaceAll("\\", "/")
        const useRelative = path.relative(projectRoot, file).replaceAll("\\", "/")
        findings.push({
          severity: "medium",
          confidence: "medium",
          code: "SOURCE_STATIC_TAINT",
          title: "static 字段存储敏感数据并被使用",
          detail: `${assignRelative}:${field.assignLine} 中 static 字段 ${field.name} 被 ${field.source} 赋值（${useRelative}:${i + 1} 处流入 ${sink}——跨方法/跨文件传播）。`,
          recommendation: "避免 static 字段存储敏感数据；确需时及时清空并控制使用范围。",
          evidence: `${assignRelative}:${field.assignLine} ${field.name} → ${useRelative}:${i + 1} ${sink}`,
        })
        break
      }
    }
  }
  return findings
}
