// 库间污点 + 隐式流分析（⑬⑰——完整版）。
// ⑬ 库间污点：应用调用第三方库类的敏感方法（返回用户/设备/会话数据的静态方法）→
//    库方法返回值流入汇（SOURCE_LIBRARY_TAINT）。
// ⑰ 隐式流：控制流条件含敏感源（if/while 条件）→ 分支内的汇调用（SOURCE_IMPLICIT_FLOW）。
// 失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// 库类敏感方法（常见 SDK 的静态/实例方法——返回用户/设备/会话数据）
const LIBRARY_SENSITIVE_METHODS: ReadonlyArray<{ className: string; method: string; note: string }> = [
  { className: "firebase", method: "getcurrentuser(", note: "Firebase Auth 当前用户" },
  { className: "firebase", method: "getuserproperties(", note: "Firebase Analytics 用户属性" },
  { className: "firebase", method: "getinstallationid(", note: "Firebase Installations 安装标识" },
  { className: "firebase", method: "getinstance(", note: "Firebase 实例" },
  { className: "analytics", method: "getinstance(", note: "分析 SDK 实例" },
  { className: "bugsnag", method: "getuser(", note: "Bugsnag 用户信息" },
  { className: "appsflyer", method: "getinstalled(", note: "AppsFlyer 安装数据" },
]

const LIBRARY_SINKS = ["log.d(", "log.e(", "log.i(", "log.w(", "loadurl(", "execsql(", "sendtextmessage(", "startactivity(", "settext(", "openfileoutput(", "writeexternalstorage(", "runtime.exec(", "processbuilder("]

// 隐式流源（控制流条件中的敏感数据）
const IMPLICIT_FLOW_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial(", "getstring(", "getextra("]

// ⑬ 库间污点：库类敏感方法调用 → 返回值流入汇（失败关闭）。
export function scanLibraryTaint(source: string): Array<{ line: number; method: string; note: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; method: string; note: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  const taintedVars = new Map<string, string>()
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    // 库方法调用赋值:val = sdk.method(...)
    const libMatch = LIBRARY_SENSITIVE_METHODS.find((m) => lower.includes(m.method))
    if (libMatch) {
      const assign = /(?:^|\s)([A-Za-z_][A-Za-z0-9_]{2,})\s*=\s*[^;]*/.exec(line)
      if (assign) taintedVars.set(assign[1]!, libMatch.note || libMatch.method)
      continue
    }
    // 返回值 → 汇
    for (const [varName, sourceNote] of taintedVars) {
      if (!line.includes(varName)) continue
      const sink = LIBRARY_SINKS.find((s) => lower.includes(s))
      if (sink) {
        matches.push({ line: i + 1, method: sourceNote, note: sourceNote, sink, snippet: line.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// ⑰ 隐式流：控制流条件含源 → 分支内汇（失败关闭）。
export function scanImplicitFlow(source: string): Array<{ line: number; condition: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; condition: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    if (!/^\s*(if|while|for|switch)\s*\(/.test(lower)) continue
    const sourcePattern = IMPLICIT_FLOW_SOURCES.find((s) => lower.includes(s))
    if (!sourcePattern) continue
    // 分支内（后续行）的汇调用
    for (let j = i + 1; j < lines.length && j < i + 15; j += 1) {
      const branchLine = lines[j]!
      if (/^\s*}/.test(branchLine)) break
      const sink = LIBRARY_SINKS.find((s) => branchLine.toLowerCase().includes(s))
      if (sink) {
        matches.push({ line: j + 1, condition: sourcePattern, sink, snippet: branchLine.trim().slice(0, 120) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（⑬⑰——失败关闭）。
export async function scanProjectLibraryAndImplicitTaint(projectRoot: string): Promise<Finding[]> {
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
    for (const match of scanLibraryTaint(source).slice(0, 2)) {
      findings.push({
        severity: "low",
        confidence: "low",
        code: "SOURCE_LIBRARY_TAINT",
        title: `库方法返回值可能含敏感数据：${match.note || match.method}`,
        detail: `${relative}:${match.line} 中库方法返回值流入 ${match.sink}（库间数据流启发式——需人工核验）。`,
        recommendation: "核对库返回值的敏感度与流向；库间数据流建议结合 SDK 文档核验。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
    for (const match of scanImplicitFlow(source).slice(0, 2)) {
      findings.push({
        severity: "low",
        confidence: "low",
        code: "SOURCE_IMPLICIT_FLOW",
        title: "敏感数据经控制流（条件）影响行为（隐式流）",
        detail: `${relative}:${match.line} 条件含敏感数据（${match.condition}），分支内流入 ${match.sink}（隐式流启发式——需人工核验）。`,
        recommendation: "核对控制流分支内的数据处理；敏感条件建议脱敏后使用。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
