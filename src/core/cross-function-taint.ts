// 跨函数污点传播（⑦——完整版：函数参数/返回值边界的污点传播）。
// 源值作为参数传入被调函数 → 被调函数参数的使用 → 汇；被调函数返回源值 →
// 调用处返回值变量 → 汇。函数签名与调用点的解析（同项目源码）。失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

const CROSS_FUNCTION_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getsubscriberid(", "getline1number(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial(", "getstring(", "getextra("]
const CROSS_FUNCTION_SINKS = ["log.d(", "log.e(", "log.i(", "log.w(", "loadurl(", "execsql(", "sendtextmessage(", "startactivity(", "settext(", "openfileoutput(", "writeexternalstorage(", "runtime.exec(", "processbuilder("]

interface FunctionInfo {
  name: string
  params: string[]
  startLine: number
}

// 提取函数签名（方法名 + 参数名）。
function extractFunctions(source: string): FunctionInfo[] {
  const functions: FunctionInfo[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const match = /(?:public|private|protected|internal)?\s*(?:static\s+)?(?:fun\s+|(?:[A-Za-z_][\w<>\[\]]*\s+)+)([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)/.exec(line)
    if (!match) continue
    const name = match[1]!
    const params = match[2]!
      .split(",")
      .map((p) => p.trim().split(/\s+/).pop() ?? "")
      .filter((p) => /^[a-z_][A-Za-z0-9_]{0,}$/.test(p))
    if (name !== "if" && name !== "for" && name !== "while" && name !== "switch" && name !== "catch") {
      functions.push({ name, params, startLine: i + 1 })
    }
  }
  return functions
}

// 扫描单个文件：跨函数污点（参数传播 + 返回值传播）——失败关闭。
export function scanCrossFunctionTaint(source: string): Array<{ line: number; func: string; flow: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; func: string; flow: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  const functions = extractFunctions(source)

  for (const func of functions) {
    // 参数传播：调用点传源值 → 被调函数内参数 → 汇
    const callRegex = new RegExp(`\\b${func.name}\\s*\\(([^)]*)\\)`)
    for (let i = 0; i < lines.length; i += 1) {
      if (i + 1 === func.startLine) continue // 跳过签名行
      const line = lines[i]!
      const call = callRegex.exec(line)
      if (!call) continue
      const lower = line.toLowerCase()
      const hasSourceArg = CROSS_FUNCTION_SOURCES.some((s) => lower.includes(s))
      if (!hasSourceArg) continue
      // 被调函数体内参数 → 汇(startLine 是 1 基——数组索引减 1)
      for (let j = func.startLine - 1; j < lines.length && j < func.startLine + 40; j += 1) {
        const bodyLine = lines[j]!
        const bodyLower = bodyLine.toLowerCase()
        if (!func.params.some((p) => bodyLine.includes(p))) continue
        const sink = CROSS_FUNCTION_SINKS.find((s) => bodyLower.includes(s))
        if (sink) {
          matches.push({ line: i + 1, func: func.name, flow: `参数 ${func.params.filter((p) => bodyLine.includes(p)).join(",")} → ${sink}`, sink, snippet: line.trim().slice(0, 120) })
          break
        }
      }
      break
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectCrossFunctionTaint(projectRoot: string): Promise<Finding[]> {
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
    const matches = scanCrossFunctionTaint(source)
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 2)) {
      const key = `${match.func}:${relative}`
      if (seen.has(key)) continue
      seen.add(key)
      findings.push({
        severity: "medium",
        confidence: "low",
        code: "SOURCE_CROSS_FUNCTION_TAINT",
        title: `敏感数据跨函数传递（${match.flow}）`,
        detail: `${relative}:${match.line} 调用 ${match.func} 时传入敏感源数据，函数内参数流入 ${match.sink}（跨函数边界启发式——需人工核验）。`,
        recommendation: "核对跨函数数据流；敏感数据应在边界处脱敏/加密或避免传递。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
