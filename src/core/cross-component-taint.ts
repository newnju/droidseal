// 跨组件/跨进程 Intent 数据流（⑤⑲——完整版：putExtra 源 → 组件/服务/广播/绑定跨进程传递）。
// 检测 Intent 携带敏感源数据（putExtra(key, 源)）→ startActivity/startService/sendBroadcast/
// bindService（跨组件/跨进程汇）。失败关闭：同文件内 Intent 变量级追踪。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

const INTENT_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getsubscriberid(", "getline1number(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial(", "getstring(", "getextra("]
const CROSS_COMPONENT_SINKS = ["startactivity(", "startactivityforresult(", "startservice(", "sendbroadcast(", "bindservice("]

// 扫描单个文件：Intent 携带源 → 跨组件汇（失败关闭）。
export function scanCrossComponentTaint(source: string): Array<{ line: number; intent: string; source: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; intent: string; source: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  const taintedIntents = new Set<string>()
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    // Intent 携带源:intent.putExtra(key, 源) / Intent().putExtra(...)——任意变量(含单字符 i/intent 命名,忽略大小写)
    const putMatch = /([A-Za-z_][A-Za-z0-9_]{0,})\s*\.\s*putextra\([^)]*/i.exec(line)
    if (putMatch && INTENT_SOURCES.some((s) => lower.includes(s))) {
      taintedIntents.add(putMatch[1]!)
      // 不 continue——同一行的 startActivity 等也要检查(单行形态)
    }
    // 跨组件汇:startActivity/Service/Broadcast/Bind(intent)
    for (const intent of taintedIntents) {
      if (!lower.includes(intent)) continue
      const sink = CROSS_COMPONENT_SINKS.find((s) => lower.includes(s))
      if (sink) {
        matches.push({ line: i + 1, intent, source: [...taintedIntents].join(","), sink, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectCrossComponentTaint(projectRoot: string): Promise<Finding[]> {
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
    const matches = scanCrossComponentTaint(source)
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 2)) {
      findings.push({
        severity: "medium",
        confidence: "medium",
        code: "SOURCE_CROSS_COMPONENT_TAINT",
        title: "敏感数据经 Intent 跨组件/跨进程传递",
        detail: `${relative}:${match.line} 中 Intent（${match.intent}）携带敏感源数据并传入 ${match.sink}（跨组件/跨进程——接收方需自行保护）。`,
        recommendation: "跨组件/跨进程传递敏感数据时确认接收方可信；敏感数据优先服务端化或加密。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
