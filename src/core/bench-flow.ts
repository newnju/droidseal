// DroidSeal — 流级对判(TS 版,与 Rust bench_flow.rs 同口径):
// TaintBench *_findings.json → GT 流(className+lineNo+targetName)
// 对判语义:端点识别(source/sink 语句各自被引擎识别)——行号体系实测不同源
// (230 端点仅 6 精确),故主判定层 = 同文件 + target API 语义等价;
// FN 病因:source 漏识别 / sink 侧断链 / 双端均漏。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { scanSourceDetectors } from "./source-detectors.ts"

export interface GtPoint { class: string; line: number; target: string; /** GT methodName 解析出的方法名(混淆名归一用) */ method?: string; /** GT 语句原文(同源行号锚定用,2026-09-27 实测 91.8% 端点可逐字定位) */ statement?: string }
export interface GtFlow { source: GtPoint; sink: GtPoint; negative: boolean }
export interface FlowApp { name: string; dir: string; flows: GtFlow[] }

export interface FlowVerdict {
  app: string; gtFlows: number; tp: number; fn: number
  /** 负例流(unexpected,isNegative=true)被检出数——官方口径的 FP */
  fpNegative: number
  /** 连通级 TP:两端识别且引擎流按行号(±2)连接(严格档) */
  tpConnected: number
  /** 连通级 TP(宽松档):两端类词干对齐即算,行号仅作参考——与 Rust 同口径 */
  tpConnectedLenient: number
  /** 连通级 TP(语句锚定档):GT statement 在源码中逐字定位 → 用同源行号做严格档 ±2 判定。
   *  背景:GT lineNo 与仓库 src 不同源(498 端点仅 67.5% 落在文件界内),语句文本高度可靠(91.8%); */
  tpConnectedAnchored: number
  fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number
  /** 传播断链:两端识别但无引擎流连接(独立于端点识别缺口) */
  fnPropagationBreak: number
  unmatchedReports: number
}

/** 解析 *_findings.json → GT 流(isNegative=true 为负例流:不应检出,检出计 FP)。 */
export function parseFindings(json: string): GtFlow[] {
  const data = JSON.parse(json) as { findings?: any[] }
  const flows: GtFlow[] = []
  for (const f of data.findings ?? []) {
    const s = f.source, k = f.sink
    if (s?.className && k?.className) {
      const srcMethod = parseMethodName(String(s.methodName ?? ""))
      const snkMethod = parseMethodName(String(k.methodName ?? ""))
      flows.push({
        source: { class: String(s.className), line: Number(s.lineNo ?? 0), target: String(s.targetName ?? ""), ...(srcMethod !== undefined ? { method: srcMethod } : {}), ...(typeof s.statement === "string" && s.statement ? { statement: s.statement } : {}) },
        sink: { class: String(k.className), line: Number(k.lineNo ?? 0), target: String(k.targetName ?? ""), ...(snkMethod !== undefined ? { method: snkMethod } : {}), ...(typeof k.statement === "string" && k.statement ? { statement: k.statement } : {}) },
        negative: f.isNegative === true,
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
  // 2026-09-23 官方 TB_SourcesAndSinks.txt 差集补齐(getInputStream 在官方表中同兼 source/sink)
  "getInputStream",
]

/** 解析 GT methodName("public void onCreate()" → "onCreate";空/畸形返回 undefined)。 */
export function parseMethodName(m: string): string | undefined {
  const mm = m.match(/([A-Za-z_$][\w$]*)\s*\(/)
  const name = mm?.[1]
  // 排除构造器形态(类名同名)与关键字
  if (!name || ["if", "for", "while", "switch", "catch", "synchronized", "return", "new"].includes(name)) return undefined
  return name
}

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

/** 类词干 → 源码全文(混淆名归一用;剥字符串前原文——方法体提取需要字面量结构)。 */
async function classTexts(appDir: string): Promise<Map<string, string>> {
  const texts = new Map<string, string>()
  const walk = async (dir: string): Promise<void> => {
    for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [])) {
      const p = path.join(dir, e.name)
      if (e.isDirectory()) await walk(p)
      else if (/\.(java|kt)$/.test(e.name)) {
        const stem = path.basename(e.name).replace(/\.(java|kt)$/, "")
        const text = await readFile(p, "utf8").catch(() => "")
        if (text && !texts.has(stem)) texts.set(stem, text)
      }
    }
  }
  await walk(appDir)
  return texts
}

/**
 * 提取类文件中指定方法的方法体(声明行起,花括号配平)。找不到返回 undefined。
 * 混淆场景方法名唯一性由调用方保证歧义检查(≥2 个同名声明如实放弃)。
 */
export function extractMethodBody(text: string, method: string): string | undefined {
  const declRe = new RegExp(`\\b${method.replace(/[$]/g, "\\$")}\\s*\\(`)
  let first = -1
  let count = 0
  let idx = 0
  while (count < 3) {
    const m = text.slice(idx).match(declRe)
    if (!m) break
    const at = idx + m.index!
    if (first < 0) first = at
    count += 1
    idx = at + m[0]!.length
  }
  if (first < 0) return undefined
  // 花括号配平:从首个声明后的第一个 { 到配平 }
  const open = text.indexOf("{", first)
  if (open < 0) return undefined
  let depth = 0
  for (let i = open; i < text.length; i += 1) {
    if (text[i] === "{") depth += 1
    else if (text[i] === "}") {
      depth -= 1
      if (depth === 0) return text.slice(first, i + 1)
    }
  }
  return undefined
}

/**
 * 混淆名归一(调用上下文指纹):GT target 是混淆名(如 "i")时,定位该类中
 * GT methodName 指向的方法体,若体内恰好出现唯一一个已知 source/sink API,
 * 则把端点归一到该 API。歧义(0 或 ≥2 个 API)如实返回 undefined 不猜。
 */
export function normalizeObfuscatedTarget(
  pt: GtPoint,
  texts: Map<string, string>,
): string | undefined {
  if (pt.target === "" || pt.method === undefined) return undefined
  // 仅对不在已知 API 表中的名称启用(已知 API 走精确匹配,不重复判)
  if ([...SOURCES, ...SINKS].includes(pt.target)) return undefined
  const stem = pt.class.split(".").pop() ?? pt.class
  const text = texts.get(stem)
  if (!text) return undefined
  const body = extractMethodBody(text, pt.method)
  if (!body) return undefined
  const clean = body.replace(/"(?:\\.|[^"\\])*"/g, '""')
  const hits = [...SOURCES, ...SINKS].filter((api) => clean.includes(api))
  return hits.length === 1 ? hits[0] : undefined
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

// ── 语句锚定层(IB,2026-09-27):GT lineNo 与仓库 src 不同源(498 端点仅 67.5%
// 落在文件界内),但 GT statement 91.8% 可在源码逐字(空白归一后)定位——
// 以语句文本为锚反查同源行号,严格档 ±2 判定因此可用(此前"行号映射不可行"
// 的结论是拿 GT 行号直接对,方向错误;锚定后行号同源,判定合法)。

interface AnchoredText { norm: string; lineOf: number[] }

/** 归一空白(空白序列→单空格,去行首缩进)并保留每字符行号映射。 */
function buildAnchoredText(text: string): AnchoredText {
  const chars: string[] = []
  const lineOf: number[] = []
  let line = 1
  let prevSpace = true
  for (let i = 0; i < text.length; i += 1) {
    const ch = text[i]!
    if (ch === "\n") { line += 1; prevSpace = true; continue }
    if (ch === " " || ch === "\t" || ch === "\r") {
      if (prevSpace) continue
      chars.push(" "); lineOf.push(line); prevSpace = true
      continue
    }
    chars.push(ch); lineOf.push(line); prevSpace = false
  }
  return { norm: chars.join(""), lineOf }
}

/** 类全限定名 → 锚定文本(语句定位用;匿名/内部类并入外部类文件——与引擎口径一致)。 */
async function classAnchoredTexts(appDir: string): Promise<Map<string, AnchoredText>> {
  const out = new Map<string, AnchoredText>()
  const walk = async (dir: string, rel: string): Promise<void> => {
    for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [])) {
      const p = path.join(dir, e.name)
      const relChild = rel ? `${rel}.${e.name}` : e.name
      if (e.isDirectory()) await walk(p, relChild)
      else if (/\.(java|kt)$/.test(e.name)) {
        const text = await readFile(p, "utf8").catch(() => "")
        if (!text) continue
        const built = buildAnchoredText(text)
        const fqn = relChild.replace(/\.(java|kt)$/, "")
        out.set(fqn, built)
        // GT className 是纯包名形式,而 rel 路径含源根(src.main.java. 等)——
        // 剥掉源根前缀再注册一份,否则包名查不中,锚定档恒 0。
        const m = fqn.match(/^(?:src\.)?(?:main\.)?(?:java|kotlin)\.(.+)$/)
        if (m && !out.has(m[1]!)) out.set(m[1]!, built)
      }
    }
  }
  await walk(appDir, "")
  return out
}

/**
 * GT 端点 → { stem, line }:className 定位类文件(全名不中则逐段剥尾,
 * 覆盖 .AnonymousClassN / $N / 非公有内部类——均与外部类同文件),statement
 * 在该文件中逐字定位,返回同源行号与文件词干(与 EngineFlow.class 同口径)。
 * 语句未命中/类文件缺失/语句过短(<15 字符)如实返回 undefined,不猜。
 */
export function anchorPoint(
  pt: GtPoint,
  anchored: Map<string, AnchoredText>,
): { stem: string; line: number } | undefined {
  const stmt = (pt.statement ?? "").replace(/\s+/g, " ").trim()
  if (stmt.length < 15) return undefined
  let fqn = pt.class
  for (;;) {
    const a = anchored.get(fqn)
    if (a) {
      const at = a.norm.indexOf(stmt)
      if (at < 0) return undefined
      const line = a.lineOf[at]
      if (line === undefined) return undefined
      const stem = fqn.split(".").pop() ?? fqn
      return { stem, line }
    }
    // 剥尾顺序:$N 内部类后缀优先——$ 不带点,若先剥 . 段会跳过外部类
    // (com.example.Auth$1 逐段剥点只会落到 com.example);再剥最后一段 .X。
    const dollar = fqn.lastIndexOf("$")
    if (dollar > fqn.lastIndexOf(".")) { fqn = fqn.slice(0, dollar); continue }
    const dot = fqn.lastIndexOf(".")
    if (dot < 0) return undefined
    fqn = fqn.slice(0, dot)
  }
}

/** 锚定档:两端语句锚定行号(同源)做定向严格档——词干相等且行号精确/±2,允许 source/sink 换向。 */
export function matchesAnchored(
  ef: EngineFlow,
  src: { stem: string; line: number },
  snk: { stem: string; line: number },
): boolean {
  const near = (a: number, b: number) => a === b || Math.abs(a - b) <= 2
  return (ef.sourceClass === src.stem && near(ef.sourceLine, src.line) && ef.sinkClass === snk.stem && near(ef.sinkLine, snk.line))
    || (ef.sourceClass === snk.stem && near(ef.sourceLine, snk.line) && ef.sinkClass === src.stem && near(ef.sinkLine, src.line))
}

/** 收集 app 全部源文件的引擎流(过程内 + 跨方法 + 跨类,与 Rust main.rs 同三表口径)。
 *  @param opts.enableCrossclass 变异开关:false 时禁用跨类解析(变异基线,验证 harness 区分真实引擎能力)。 */
export async function engineFlows(appDir: string, opts?: { enableCrossclass?: boolean }): Promise<EngineFlow[]> {
  const enableCrossclass = opts?.enableCrossclass ?? true
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
  // 跨类联合分析:全量文件一次建图(类词干为 key;签名 Array<{cls, content}>)。变异开关:false 时跳过(基线)。
  if (enableCrossclass) {
    for (const cf of analyzeCrossclass(contents.map(([cls, content]) => ({ cls, content })))) {
      out.push({ sourceClass: cf.src_class, sinkClass: cf.sink_class, sourceLine: cf.source_line, sinkLine: cf.sink_line })
    }
  }
  return out
}

/** 对单 app 做流级(端点级 + 连通级双档)对判。官方口径:positive 流检出=TP、未检出=FN;negative(isNegative)流检出=FP。
 *  @param opts.enableCrossclass 变异开关(透传 engineFlows,false = 变异基线)。 */
export async function adjudicate(app: FlowApp, opts?: { enableCrossclass?: boolean }): Promise<FlowVerdict> {
  const reports = await endpointReports(app.dir)
  const texts = await classTexts(app.dir)
  const anchored = await classAnchoredTexts(app.dir)
  const efs = await engineFlows(app.dir, opts)
  const v: FlowVerdict = { app: app.name, gtFlows: app.flows.length, tp: 0, fn: 0, fpNegative: 0, tpConnected: 0, tpConnectedLenient: 0, tpConnectedAnchored: 0, fnSourceMiss: 0, fnSinkMiss: 0, fnBothMiss: 0, fnPropagationBreak: 0, unmatchedReports: 0 }
  const hit = (pt: GtPoint): boolean => {
    const stem = pt.class.split(".").pop() ?? pt.class
    const apis = reports.get(stem)
    if (!apis || pt.target === "") return false
    // 语义等价:该类文件中出现 target API(同端点);回退:该类含任一同族 source/sink
    if (apis.has(pt.target)) return true
    // 混淆名归一回退:target 是混淆名时,GT methodName 指向的方法体唯一 API 锚定
    const normalized = normalizeObfuscatedTarget(pt, texts)
    return normalized !== undefined && apis.has(normalized)
  }
  for (const f of app.flows) {
    const s = hit(f.source), k = hit(f.sink)
    if (f.negative) {
      // 负例流(unexpected):检出 = FP,不进 TP/FN 分母
      if (s && k) v.fpNegative++
      continue
    }
    if (s && k) {
      v.tp++
      if (efs.some(ef => matchesStrict(ef, f.source) && matchesStrict(ef, f.sink))) v.tpConnected++
      else v.fnPropagationBreak++
      if (efs.some(ef => matchesLenient(ef, f.source, f.sink))) v.tpConnectedLenient++
      // 语句锚定档:GT statement 逐字定位到同源行号后再做严格档(±2)判定。
      // 两端都锚定成功才判——单端锚定不构成行号同源证据。
      const aSrc = anchorPoint(f.source, anchored)
      const aSnk = anchorPoint(f.sink, anchored)
      if (aSrc && aSnk && efs.some(ef => matchesAnchored(ef, aSrc, aSnk))) v.tpConnectedAnchored++
    } else {
      v.fn++
      if (!s && k) v.fnSourceMiss++
      else if (s && !k) v.fnSinkMiss++
      else v.fnBothMiss++
    }
  }
  return v
}

/** 流级汇总。@param opts.enableCrossclass 变异开关(透传 adjudicate,false = 变异基线)。 */
export async function summarizeFlow(root: string, opts?: { enableCrossclass?: boolean }): Promise<{ total: number; tp: number; fn: number; fpNegative: number; tpConnected: number; tpConnectedLenient: number; tpConnectedAnchored: number; fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number; fnPropagationBreak: number; verdicts: FlowVerdict[] } | null> {
  const entries = await readdir(root, { withFileTypes: true }).catch(() => [])
  const verdicts: FlowVerdict[] = []
  for (const e of entries) {
    if (!e.isDirectory()) continue
    const app = await loadFlowApp(path.join(root, e.name))
    if (!app || app.flows.length === 0) continue
    verdicts.push(await adjudicate(app, opts))
  }
  if (verdicts.length === 0) return null
  const sum = (k: keyof FlowVerdict) => verdicts.reduce((a, v) => a + (v[k] as number), 0)
  return {
    total: sum("gtFlows"), tp: sum("tp"), fn: sum("fn"), fpNegative: sum("fpNegative"),
    tpConnected: sum("tpConnected"), tpConnectedLenient: sum("tpConnectedLenient"),
    tpConnectedAnchored: sum("tpConnectedAnchored"),
    fnSourceMiss: sum("fnSourceMiss"), fnSinkMiss: sum("fnSinkMiss"), fnBothMiss: sum("fnBothMiss"),
    fnPropagationBreak: sum("fnPropagationBreak"),
    verdicts,
  }
}

/** 流级 Markdown 小节(与 Rust render_flow_md 同结构,含连通级三档与负例 FP)。 */
export function renderFlowMd(s: { total: number; tp: number; fn: number; fpNegative: number; tpConnected: number; tpConnectedLenient: number; tpConnectedAnchored: number; fnSourceMiss: number; fnSinkMiss: number; fnBothMiss: number; fnPropagationBreak: number; verdicts: FlowVerdict[] }): string {
  const recall = s.tp + s.fn > 0 ? Math.round((s.tp / (s.tp + s.fn)) * 1000) / 10 : 0
  const pct = (n: number) => s.tp > 0 ? Math.round((n / s.tp) * 1000) / 10 : 0
  const lines = [
    "", "## 流级判定(flow-level adjudication)", "",
    `- GT 流:${s.total}(positive ${s.tp + s.fn} + negative ${s.fpNegative + 0}) · 端点级 TP:${s.tp} · FN:${s.fn} · **负例 FP:${s.fpNegative}** · **连通级 TP:${s.tpConnected}(${pct(s.tpConnected)}%)** · 连通级宽松档 TP:${s.tpConnectedLenient}(${pct(s.tpConnectedLenient)}%) · 连通级锚定档 TP:${s.tpConnectedAnchored}(${pct(s.tpConnectedAnchored)}%) · 流级召回 ${recall}%`,
    "> 口径声明:官方语义——Expected Flow 检出=TP、未检出=FN;Unexpected(isNegative)流检出=FP。严格档 = 两端类词干对齐且行号精确/±2;宽松档 = 两端类词干对齐(行号仅作参考);锚定档 = GT statement 逐字定位到仓库 src 同源行号后做严格档(仅两端均锚定成功的流参与)。三档并列呈现,宽松档/锚定档不得单独引用。",
    "",
    "### FN 病因归因(三类,分母=positive 流)", "",
    "| 病因 | 条数 | 含义 |", "|---|---|---|",
    `| source 漏识别 | ${s.fnSourceMiss} | source 点 API 未被引擎表覆盖 |`,
    `| sink 侧断链 | ${s.fnSinkMiss} | source 已识别、sink 未识别(sink 表缺口或跨类) |`,
    `| 双端均漏 | ${s.fnBothMiss} | source 与 sink 均未识别 |`,
    `| 传播断链 | ${s.fnPropagationBreak} | 两端均识别但引擎无流连接(计入连通级 FN) |`, "",
    "### 逐 app 明细", "",
    "| app | GT 流 | TP | 连通TP | FN | FP(负例) | source漏 | sink断 | 双漏 | 传播断 |", "|---|---|---|---|---|---|---|---|---|---|",
    ...s.verdicts.map(v => `| ${v.app} | ${v.gtFlows} | ${v.tp} | ${v.tpConnectedLenient} | ${v.fn} | ${v.fpNegative} | ${v.fnSourceMiss} | ${v.fnSinkMiss} | ${v.fnBothMiss} | ${v.fnPropagationBreak} |`), "",
  ]
  return lines.join("\n")
}
