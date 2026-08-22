// 源码侧敏感数据流/污点跟踪（差距分析高补强③——把交叉证据升级为数据流证据）。
// 轻量实现：函数内局部变量级传播——源（敏感数据获取）赋值给变量，变量随后流向
// 高风险汇（日志/网络/WebView/SQL/跳转）。不做跨函数/字段/别名分析，失败关闭
// （不确定即不报，避免误报）。纯 TypeScript 自研，零运行时依赖。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// 敏感数据源（Android 常见敏感获取；小写匹配，避免大小写误报）
const SOURCE_PATTERNS = [
  "getstringextra",
  "getqueryparameter",
  "getsharedpreferences",
  "getstring",
  "getextra",
  "secure.getstring",
]

// 高风险汇
const SINK_PATTERNS = [
  "log.d(",
  "log.e(",
  "log.i(",
  "log.w(",
  "loadurl(",
  "execsql(",
  "sendtextmessage(",
  "startactivity(",
  "settext(",
]

export interface DataflowMatch {
  line: number
  source: string
  sink: string
  snippet: string
}

// 简化数据流：逐行扫描，源调用赋值给变量（记录变量→源），后续行中该变量出现在
// 汇调用即命中。同一变量名跨函数复用可能误报，因此只保留单行内同时出现源赋值与
// 变量定义的形式，且汇命中要求变量名非通用名（长度>=3），失败关闭。
export function scanTaintFlow(source: string): DataflowMatch[] {
  const matches: DataflowMatch[] = []
  const lines = source.split(/\r?\n/)
  const tainted = new Map<string, string>()
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    // 源赋值：`xxx = ...getStringExtra(...)` 或 `val xxx = ...getStringExtra(...)`
    const assign = /(?:^|\s)([A-Za-z_][A-Za-z0-9_]{2,})\s*=\s*[^;]*/.exec(line)
    if (assign) {
      const sourcePattern = SOURCE_PATTERNS.find((p) => lower.includes(p))
      if (sourcePattern) {
        tainted.set(assign[1]!, sourcePattern)
        continue
      }
    }
    // 汇：行内含已追踪变量 + 汇调用
    for (const [varName, src] of tainted) {
      if (!line.includes(varName)) continue
      const sink = SINK_PATTERNS.find((s) => lower.includes(s))
      if (sink) {
        matches.push({ line: i + 1, source: src, sink, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 收集项目的 Java/Kotlin 源码文件（有界：仅 src 目录、按数量/大小限制，失败关闭）。
async function collectSourceFiles(projectRoot: string): Promise<string[]> {
  const out: string[] = []
  const MAX_FILES = 400
  const MAX_BYTES = 512 * 1024
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (out.length >= MAX_FILES) return out
      if (!/\.(java|kt)$/.test(entry)) continue
      const file = path.join(dir, entry)
      const stat = await import("node:fs/promises").then((m) => m.stat(file)).catch(() => undefined)
      if (stat && stat.size <= MAX_BYTES) out.push(file)
    }
  }
  return out
}

// 扫描项目源码,返回 SOURCE_DATAFLOW findings(失败关闭)。
export async function scanProjectDataflow(projectRoot: string): Promise<Finding[]> {
  const files = await collectSourceFiles(projectRoot)
  const findings: Finding[] = []
  for (const file of files) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanTaintFlow(source)
    if (matches.length === 0) continue
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 3)) {
      findings.push({
        severity: "low",
        confidence: "medium",
        code: "SOURCE_DATAFLOW",
        title: "敏感数据可能流向高风险汇",
        detail: `${relative}:${match.line} 中 ${match.source} 获取的数据可能流入 ${match.sink}（同函数内变量传播，启发式）。`,
        recommendation: "核对数据流向；敏感数据应避免写入日志/明文网络/WebView，必要时脱敏或移入服务端处理。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
