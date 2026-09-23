// DroidSeal — 流级对判(TS 版,与 Rust bench_flow.rs 同口径):
// TaintBench *_findings.json → GT 流(className+lineNo+targetName)
// 对判语义:端点识别(source/sink 语句各自被引擎识别)——行号体系实测不同源
// (230 端点仅 6 精确),故主判定层 = 同文件 + target API 语义等价;
// FN 病因:source 漏识别 / sink 侧断链 / 双端均漏。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { scanSourceDetectors } from "./source-detectors.ts"

export interface GtPoint { class: string; line: number; target: string }
export interface GtFlow { source: GtPoint; sink: GtPoint }
export interface FlowApp { name: string; dir: string; flows: GtFlow[] }

export interface FlowVerdict {
  app: string; gtFlows: number; tp: number; fn: number
  /** 连通级 TP:两端识别且引擎流按行号(±2)连接(严格档) */
  tpConnected: number
  /** 连通级 TP(宽松档):两端类词干对齐即算,行号仅作参考——与 Rust 同口径 */
  tpConnectedLenient: number
  fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number
  /** 传播断链:两端识别但无引擎流连接(独立于端点识别缺口) */
  fnPropagationBreak: number
  unmatchedReports: number
}

/** 解析 *_findings.json → GT 流(轻量:直接 JSON.parse,结构已验证)。 */
export function parseFindings(json: string): GtFlow[] {
  const data = JSON.parse(json) as { findings?: any[] }
  const flows: GtFlow[] = []
  for (const f of data.findings ?? []) {
    const s = f.source, k = f.sink
    if (s?.className && k?.className) {
      flows.push({
        source: { class: String(s.className), line: Number(s.lineNo ?? 0), target: String(s.targetName ?? "") },
        sink: { class: String(k.className), line: Number(k.lineNo ?? 0), target: String(k.targetName ?? "") },
      })
    }
  }
  return flows
}

/** 载入一个 TaintBench app(目录含 *_findings.json)。 */
export async function loadFlowApp(appDir: string): Promise<FlowApp | null> {
  const name = path.basename(appDir)
  const entries = await readdir(appDir).catch(() => [])
  const gtFile = entries.find(f => f.endsWith("_findings.json"))
  if (!gtFile) return null
  const flows = parseFindings(await readFile(path.join(appDir, gtFile), "utf8"))
  return { name, dir: appDir, flows }
}

/** 引擎端点枚举(与 Rust taint.rs 同表口径,含 2026-09-19 GT 差集补齐):source/sink API → 行号。 */
const SOURCES = [
  "getDeviceId", "getLastKnownLocation", "getPrimaryClip", "getAccounts",
  "createFromPdu", "getDisplayMessageBody", "findViewById", "getText",
  "getExtras", "getStringExtra", "getSerializableExtra", "getSimSerialNumber",
  "getSimCountryIso", "getSubscriberId", "getLine1Number", "getMacAddress",
  "getConnectionInfo", "getLac", "query", "FileInputStream", "File", "listFiles",
  "getInputStream", "getDeclaredMethod", "getString", "open",
  // 2026-09-19 GT 全量差集补齐(与 Rust taint.rs 同步)
  "getInstalledPackages", "openFileInput", "getInt", "getLong",
  "getSystemService", "getLongitude", "managedQuery", "getContent",
  "getNetworkOperatorName", "getDisplayOriginatingAddress", "openStream",
  "getExternalStorageDirectory",
]
const SINKS = [
  "sendTextMessage", "Log.d", "HttpURLConnection", "openFileOutput",
  "sendMultipartTextMessage", "execute", "addJavascriptInterface", "insert",
  "update", "delete", "put", "commit", "invoke", "putObject", "write",
  "flush", "startActivity", "startService",
  // 2026-09-19 GT 全量差集补齐(与 Rust taint.rs 同步)
  "append", "getOutputStream", "writeUTF", "exchange", "connect",
  "sendMessage", "writeBytes", "submit", "println", "RestTemplate", "call",
]

/** 扫描 app 全部源码,产出端点报告:类词干 → 行 → API 名。 */
export async function endpointReports(appDir: string): Promise<Map<string, Set<string>>> {
  // index: (classStem, line) → codes;另建 classStem → 全部 target API 集合(语义等价层)
  const byStem = new Map<string, Set<string>>()
  const walk = async (dir: string): Promise<void> => {
    for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [])) {
      const p = path.join(dir, e.name)
      if (e.isDirectory()) await walk(p)
      else if (/\.(java|kt)$/.test(e.name)) {
        const stem = path.basename(e.name).replace(/\.(java|kt)$/, "")
        const text = await readFile(p, "utf8").catch(() => "")
        // 剥字符串字面量
        const clean = text.replace(/"(?:\\.|[^"\\])*"/g, '""')
        for (const api of [...SOURCES, ...SINKS]) {
          if (clean.includes(api)) {
            const set = byStem.get(stem) ?? new Set<string>()
            set.add(api)
            byStem.set(stem, set)
          }
        }
      }
    }
  }
  await walk(appDir)
  return byStem
}

/** 引擎流(连通级对判依据,与 Rust EngineFlow 同构):两端类词干 + 行号。 */
export interface EngineFlow { sourceClass: string; sinkClass: string; sourceLine: number; sinkLine: number }

/** 严格档:类词干相等且行号精确或 ±2(与 Rust matches 同口径)。 */
function matchesStrict(ef: EngineFlow, pt: GtPoint): boolean {
  const stem = pt.class.split(".").pop() ?? pt.class
  const near = (a: number, b: number) => a === b || Math.abs(a - b) <= 2
  return (ef.sourceClass === stem && near(ef.sourceLine, pt.line))
    || (ef.sinkClass === stem && near(ef.sinkLine, pt.line))
}

/** 宽松档(与 Rust matches_lenient 同口径):两端类词干对齐即算,行号仅作参考不设门槛。 */
function matchesLenient(ef: EngineFlow, gtSrc: GtPoint, gtSnk: GtPoint): boolean {
  const stemOf = (c: string) => c.split(".").pop() ?? c
  const ss = stemOf(gtSrc.class), ks = stemOf(gtSnk.class)
  return (ef.sourceClass === ss && ef.sinkClass === ks)
    || (ef.sourceClass === ks && ef.sinkClass === ss)
}

/** 收集 app 全部源文件的引擎流(过程内 + 跨方法 + 跨类,与 Rust main.rs 同三表口径)。 */
export async function engineFlows(appDir: string): Promise<EngineFlow[]> {
  const { analyzeInterproc, analyzeCrossclass } = await import("./dataflow.ts")
  const files: Array<{ stem: string; path: string }> = []
  const walk = async (dir: string): Promise<void> => {
    for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [])) {
      const p = path.join(dir, e.name)
      if (e.isDirectory()) await walk(p)
      else if (/\.(java|kt)$/.test(e.name)) files.push({ stem: e.name.replace(/\.(java|kt)$/, ""), path: p })
    }
  }
  await walk(appDir)
  const contents: Array<[string, string]> = []
  for (const f of files) {
    const text = await readFile(f.path, "utf8").catch(() => "")
    if (text) contents.push([f.stem, text])
  }
  const out: EngineFlow[] = []
  for (const [stem, content] of contents) {
    const flows = analyzeInterproc(content)
    for (const fl of flows) {
      out.push({ sourceClass: stem, sinkClass: stem, sourceLine: fl.source_line, sinkLine: fl.sink_line })
    }
  }
  // 跨类联合分析:全量文件一次建图(类词干为 key;签名 Array<{cls, content}>)
  for (const cf of analyzeCrossclass(contents.map(([cls, content]) => ({ cls, content })))) {
    out.push({ sourceClass: cf.src_class, sinkClass: cf.sink_class, sourceLine: cf.source_line, sinkLine: cf.sink_line })
  }
  return out
}

/** 对单 app 做流级(端点级 + 连通级双档)对判。 */
export async function adjudicate(app: FlowApp): Promise<FlowVerdict> {
  const reports = await endpointReports(app.dir)
  const efs = await engineFlows(app.dir)
  const v: FlowVerdict = { app: app.name, gtFlows: app.flows.length, tp: 0, fn: 0, tpConnected: 0, tpConnectedLenient: 0, fnSourceMiss: 0, fnSinkMiss: 0, fnBothMiss: 0, fnPropagationBreak: 0, unmatchedReports: 0 }
  const hit = (pt: GtPoint): boolean => {
    const stem = pt.class.split(".").pop() ?? pt.class
    const apis = reports.get(stem)
    if (!apis || pt.target === "") return false
    // 语义等价:该类文件中出现 target API(同端点);回退:该类含任一同族 source/sink
    return apis.has(pt.target)
  }
  for (const f of app.flows) {
    const s = hit(f.source), k = hit(f.sink)
    if (s && k) {
      v.tp++
      if (efs.some(ef => matchesStrict(ef, f.source) && matchesStrict(ef, f.sink))) v.tpConnected++
      else v.fnPropagationBreak++
      if (efs.some(ef => matchesLenient(ef, f.source, f.sink))) v.tpConnectedLenient++
    } else {
      v.fn++
      if (!s && k) v.fnSourceMiss++
      else if (s && !k) v.fnSinkMiss++
      else v.fnBothMiss++
    }
  }
  return v
}

/** 流级汇总。 */
export async function summarizeFlow(root: string): Promise<{ total: number; tp: number; fn: number; tpConnected: number; tpConnectedLenient: number; fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number; fnPropagationBreak: number; verdicts: FlowVerdict[] } | null> {
  const entries = await readdir(root, { withFileTypes: true }).catch(() => [])
  const verdicts: FlowVerdict[] = []
  for (const e of entries) {
    if (!e.isDirectory()) continue
    const app = await loadFlowApp(path.join(root, e.name))
    if (!app || app.flows.length === 0) continue
    verdicts.push(await adjudicate(app))
  }
  if (verdicts.length === 0) return null
  const sum = (k: keyof FlowVerdict) => verdicts.reduce((a, v) => a + (v[k] as number), 0)
  return {
    total: sum("gtFlows"), tp: sum("tp"), fn: sum("fn"),
    tpConnected: sum("tpConnected"), tpConnectedLenient: sum("tpConnectedLenient"),
    fnSourceMiss: sum("fnSourceMiss"), fnSinkMiss: sum("fnSinkMiss"), fnBothMiss: sum("fnBothMiss"),
    fnPropagationBreak: sum("fnPropagationBreak"),
    verdicts,
  }
}

/** 流级 Markdown 小节(与 Rust render_flow_md 同结构,含连通级双档)。 */
export function renderFlowMd(s: { total: number; tp: number; fn: number; tpConnected: number; tpConnectedLenient: number; fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number; fnPropagationBreak: number; verdicts: FlowVerdict[] }): string {
  const recall = s.tp + s.fn > 0 ? Math.round((s.tp / (s.tp + s.fn)) * 1000) / 10 : 0
  const pct = (n: number) => s.tp > 0 ? Math.round((n / s.tp) * 1000) / 10 : 0
  const lines = [
    "", "## 流级判定(flow-level adjudication)", "",
    `- GT 流:${s.total} · 端点级 TP:${s.tp} · **连通级 TP:${s.tpConnected}(${pct(s.tpConnected)}%)** · 连通级宽松档 TP:${s.tpConnectedLenient}(${pct(s.tpConnectedLenient)}%) · FN:${s.fn} · 流级召回 ${recall}%`,
    "> 口径声明:严格档 = 两端类词干对齐且行号精确/±2;宽松档 = 两端类词干对齐(行号仅作参考,与端点级语义等价原则一致化)。双档并列呈现,宽松档不得单独引用。",
    "",
    "### FN 病因归因(四类)", "",
    "| 病因 | 条数 | 含义 |", "|---|---|---|",
    `| source 漏识别 | ${s.fnSourceMiss} | source 点 API 未被引擎表覆盖 |`,
    `| sink 侧断链 | ${s.fnSinkMiss} | source 已识别、sink 未识别(sink 表缺口或跨类) |`,
    `| 双端均漏 | ${s.fnBothMiss} | source 与 sink 均未识别 |`,
    `| 传播断链 | ${s.fnPropagationBreak} | 两端均识别但引擎无流连接(过程间/跨类缺口) |`, "",
    "### 逐 app 明细", "",
    "| app | GT 流 | TP | 连通TP | FN | source漏 | sink断 | 双漏 | 传播断 |", "|---|---|---|---|---|---|---|---|---|",
    ...s.verdicts.map(v => `| ${v.app} | ${v.gtFlows} | ${v.tp} | ${v.tpConnectedLenient} | ${v.fn} | ${v.fnSourceMiss} | ${v.fnSinkMiss} | ${v.fnBothMiss} | ${v.fnPropagationBreak} |`), "",
  ]
  return lines.join("\n")
}
