// 源码侧敏感数据流/污点跟踪（工具）。
// 轻量实现：函数内局部变量级传播——源（敏感数据获取）赋值给变量，变量随后流向
// 高风险汇（日志/网络/WebView/SQL/跳转）。不做跨函数/字段/别名分析，失败关闭
// （不确定即不报，避免误报）。纯 TypeScript 自研，零运行时依赖。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

// 敏感数据源（Android 常见敏感获取；小写匹配，避免大小写误报）
const SOURCE_PATTERNS = [
  "getstringextra",
  "getqueryparameter",
  "getsharedpreferences",
  "getstring",
  "getextra",
  "secure.getstring",
  // 扩充源(JAADAS 差距③——设备标识/位置/剪贴板/账户等)
  "getdeviceid(",
  "getimei(",
  "getsubscriberid(",
  "getsimserialnumber(",
  "getlastknownlocation(",
  "getprimaryclip(",
  "getaccounts(",
  "getline1number(",
  // 接收侧源(⑭ Android 数据接收源建模——Intent/广播/ContentProvider 接收数据)
  "getintent(",
  "getdata(",
  "onreceive(",
  "getclipdata(",
  "query(",
  "getcursor(",
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
  "rawquery(",
  "compilestatement(",
  "runtime.exec(",
  "processbuilder(",
  // 扩充汇(敏感数据落盘——文件写入)
  "openfileoutput(",
  "writeexternalstorage(",
]

// 语义漏洞汇（AndroBugs 差距②——语义漏洞模式库）：源数据流入这些汇 → 注入/命令执行风险。
const SEMANTIC_VULN_SINKS = ["execsql(", "rawquery(", "compilestatement(", "runtime.exec(", "processbuilder("]

// 清理函数（JAADAS 差距⑮——sanitizer 建模）：加密/编码/哈希后污点清除（降误报）。
const SANITIZER_PATTERNS = ["encrypt(", "encode(", "digest(", "base64", "obfuscate("]

// 生命周期回调入口（JAADAS 差距①——生命周期入口点建模）。
const LIFECYCLE_METHODS = ["oncreate(", "onresume(", "onstart(", "ondestroy(", "onpaused(", "onstop("]

// 声明式污点规则（Semgrep 差距⑤——自定义 source/sink/sanitizer 规则文件）。
export interface TaintRulesFile {
  sources?: string[]
  sinks?: string[]
  sanitizers?: string[]
}

export async function loadTaintRules(file: string): Promise<TaintRulesFile> {
  const parsed = JSON.parse(await readFile(file, "utf8")) as TaintRulesFile
  for (const key of ["sources", "sinks", "sanitizers"] as const) {
    const value = parsed[key]
    if (value !== undefined && !Array.isArray(value)) {
      throw new Error(`污点规则文件 ${key} 应为字符串数组`)
    }
  }
  return parsed
}

// 合并自定义污点规则与内置（自定义追加——失败关闭）。
export function mergeTaintRules(rules: TaintRulesFile): { sources: string[]; sinks: string[]; sanitizers: string[] } {
  return {
    sources: [...SOURCE_PATTERNS, ...(rules.sources ?? [])],
    sinks: [...SINK_PATTERNS, ...(rules.sinks ?? [])],
    sanitizers: [...SANITIZER_PATTERNS, ...(rules.sanitizers ?? [])],
  }
}

// 动态回调注册（⑱ 动态回调注册建模——ClickListener/KeyListener/Handler/AsyncTask/接口回调）。
const CALLBACK_REGISTRATION_PATTERNS = [
  "setonclicklistener(",
  "setonkeylistener(",
  "setonfocuschangelistener(",
  "setonlongclicklistener(",
  "setontouchlistener(",
  "setonitemclicklistener(",
  "postdelayed(",
  "handler.post(",
  "asynctask(",
]

export interface DataflowMatch {
  line: number
  source: string
  sink: string
  snippet: string
  vuln?: boolean
  lifecycle?: boolean
  callback?: boolean
}

// 简化数据流：逐行扫描，源调用赋值给变量（记录变量→源），后续行中该变量出现在
// 汇调用即命中。同一变量名跨函数复用可能误报，因此只保留单行内同时出现源赋值与
// 变量定义的形式，且汇命中要求变量名非通用名（长度>=3），失败关闭。
export function scanTaintFlow(
  source: string,
  customRules?: { sources: string[]; sinks: string[]; sanitizers: string[] },
): DataflowMatch[] {
  const sources = customRules?.sources ?? SOURCE_PATTERNS
  const sinks = customRules?.sinks ?? SINK_PATTERNS
  const sanitizers = customRules?.sanitizers ?? SANITIZER_PATTERNS
  const matches: DataflowMatch[] = []
  const lines = source.split(/\r?\n/)
  const tainted = new Map<string, string>()
  let inLifecycle = false
  let inCallback = false
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue // suppression 注释忽略(⑦)
    const lower = line.toLowerCase()
    // 生命周期回调入口:签名行进入生命周期上下文(JAADAS 差距①)
    if (LIFECYCLE_METHODS.some((method) => lower.includes(method)) && /(?:void|protected|public|override)\s+on[A-Z]/.test(line)) {
      inLifecycle = true
    }
    // 动态回调注册:注册行进入回调上下文(⑱——回调体内的源使用)
    if (CALLBACK_REGISTRATION_PATTERNS.some((pattern) => lower.includes(pattern))) {
      inCallback = true
    }
    // 源赋值：`xxx = ...getStringExtra(...)` 或 `val xxx = ...getStringExtra(...)`
    const assign = /(?:^|\s)([A-Za-z_][A-Za-z0-9_]{2,})\s*=\s*[^;]*/.exec(line)
    if (assign) {
      const sourcePattern = sources.find((p) => lower.includes(p))
      if (sourcePattern) {
        tainted.set(assign[1]!, sourcePattern)
        continue
      }
      // sanitizer:变量经清理函数(加密/编码/哈希)赋值——污点清除(JAADAS 差距⑮,降误报)
      if (sanitizers.some((s) => lower.includes(s))) {
        tainted.delete(assign[1]!)
        continue
      }
    }
    // 汇：行内含已追踪变量 + 汇调用
    for (const [varName, src] of tainted) {
      if (!line.includes(varName)) continue
      const sink = sinks.find((s) => lower.includes(s))
      if (sink) {
        matches.push({ line: i + 1, source: src, sink, snippet: line.trim().slice(0, 120), vuln: SEMANTIC_VULN_SINKS.includes(sink), lifecycle: inLifecycle, callback: inCallback })
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
export async function scanProjectDataflow(
  projectRoot: string,
  customRules?: { sources: string[]; sinks: string[]; sanitizers: string[] },
): Promise<Finding[]> {
  const files = await collectSourceFiles(projectRoot)
  const findings: Finding[] = []
  for (const file of files) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanTaintFlow(source, customRules)
    if (matches.length === 0) continue
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 3)) {
      findings.push({
        severity: match.vuln ? "medium" : match.lifecycle || match.callback ? "medium" : "low",
        confidence: "medium",
        code: match.vuln
          ? "SOURCE_SEMANTIC_VULN"
          : match.lifecycle
            ? "SOURCE_LIFECYCLE_ENTRY"
            : match.callback
              ? "SOURCE_CALLBACK_ENTRY"
              : "SOURCE_DATAFLOW",
        title: match.vuln
          ? "敏感数据可能流入漏洞型汇（注入/命令执行）"
          : match.lifecycle
            ? "敏感数据流出现在生命周期回调（污点入口点）"
            : match.callback
              ? "敏感数据流出现在动态回调注册（回调入口点）"
              : "敏感数据可能流向高风险汇",
        detail: `${relative}:${match.line} 中 ${match.source} 获取的数据可能流入 ${match.sink}（同函数内变量传播，启发式${match.vuln ? "；漏洞型汇——建议优先核验注入/命令执行风险" : ""}${match.lifecycle ? "；位于生命周期回调内——生命周期是污点分析的入口点" : ""}${match.callback ? "；位于动态回调（ClickListener/Handler/AsyncTask 等）内——回调是污点入口点" : ""}）。`,
        recommendation: "核对数据流向；敏感数据应避免写入日志/明文网络/WebView，必要时脱敏或移入服务端处理。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
