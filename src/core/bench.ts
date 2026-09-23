// DroidSeal — bench 命令核心(与 Rust 版 bench 同口径):
// ① 语义 GT(README map 或 per-case expected)② md/json 输出 ③ CI 门控(--max-fp/--min-recall)。
// 评测对象:scanSourceDetectors(TS 版检测器,与 audit 同一引擎——不重复实现)。
import { readdir, readFile, writeFile, mkdir } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"
import { scanSourceDetectors } from "./source-detectors.ts"
import { fmtCi } from "./bench-stats.ts"

export interface SuiteConfig {
  name: string
  projects_dir: string
  gt_file: string
  kind: string // "droidbench"(两级目录)| "generic"(扁平,每子目录即用例)
}

export interface CaseRow { category: string; name: string; expected: boolean; hit: boolean; codes: string[] }

export interface BenchResult {
  suite: string
  cases: number
  tp: number; fp: number; fn: number; tn: number
  precision: number | null
  recall: number | null
  categories: Array<{ name: string; tp: number; fp: number; fn: number; tn: number }>
  rows: CaseRow[]
}

/** 载入套件配置:目录直跑(droidbench 兼容,默认旁侧 droidbench-map.json)或 JSON(单对象/数组)。 */
export async function loadSuite(spec: string): Promise<SuiteConfig[]> {
  const stat = await (await import("node:fs/promises")).stat(spec).catch(() => null)
  if (stat?.isDirectory()) {
    const parent = path.dirname(spec)
    const gt = existsSync(path.join(parent, "droidbench-map.json"))
      ? path.join(parent, "droidbench-map.json")
      : "droidbench-map.json"
    return [{ name: path.basename(spec), projects_dir: spec, gt_file: gt, kind: "droidbench" }]
  }
  const text = await readFile(spec, "utf8")
  const parseOne = (o: any): SuiteConfig => ({
    name: String(o.name ?? "suite"),
    projects_dir: String(o.projects_dir),
    gt_file: String(o.gt_file ?? "droidbench-map.json"),
    kind: String(o.kind ?? "droidbench"),
  })
  const parsed = JSON.parse(text)
  const suites = Array.isArray(parsed) ? parsed.map(parseOne) : [parseOne(parsed)]
  if (suites.length === 0) throw new Error("套件配置为空")
  return suites
}

/** 载入 GT:双格式(positive/negative 语义 map | cases[].expected)。 */
export async function loadGroundTruth(gtFile: string): Promise<Map<string, boolean>> {
  const raw = JSON.parse(await readFile(gtFile, "utf8"))
  const gt = new Map<string, boolean>()
  if (raw.positive) {
    for (const e of raw.positive) gt.set(String(e.name).toLowerCase(), true)
    for (const e of raw.negative ?? []) gt.set(String(e.name).toLowerCase(), false)
  } else if (raw.cases) {
    for (const c of raw.cases) gt.set(String(c.name).toLowerCase(), Boolean(c.expected))
  } else {
    throw new Error(`GT 格式无法识别: ${gtFile}(需 positive/negative 或 cases[].expected)`)
  }
  if (gt.size === 0) throw new Error(`GT 为空: ${gtFile}`)
  return gt
}

/** 递归收集 .java/.kt 源文件。 */
async function collectSources(dir: string, out: string[]): Promise<void> {
  const entries = await readdir(dir, { withFileTypes: true }).catch(() => [])
  for (const e of entries) {
    const p = path.join(dir, e.name)
    if (e.isDirectory()) await collectSources(p, out)
    else if (/\.(java|kt)$/.test(e.name)) out.push(p)
  }
}

/** 跑单个套件(评测循环,与 Rust 版 run_suite 同构)。 */
export async function runSuite(suite: SuiteConfig): Promise<BenchResult> {
  if (!existsSync(suite.projects_dir)) throw new Error(`数据集目录不存在: ${suite.projects_dir}`)
  const gt = await loadGroundTruth(suite.gt_file)
  const rows: CaseRow[] = []
  const topDirs = (await readdir(suite.projects_dir, { withFileTypes: true })).filter(d => d.isDirectory())
  const cases: Array<{ category: string; dir: string; name: string }> = []
  if (suite.kind === "generic") {
    for (const d of topDirs) cases.push({ category: suite.name, dir: path.join(suite.projects_dir, d.name), name: d.name })
  } else {
    for (const cat of topDirs) {
      for (const cs of await readdir(path.join(suite.projects_dir, cat.name), { withFileTypes: true }).catch(() => [])) {
        if (cs.isDirectory()) cases.push({ category: cat.name, dir: path.join(suite.projects_dir, cat.name, cs.name), name: cs.name })
      }
    }
  }
  for (const cs of cases) {
    const expected = gt.get(cs.name.toLowerCase())
    if (expected === undefined) continue
    const roots = [path.join(cs.dir, "app", "src", "main", "java"), path.join(cs.dir, "src", "main", "java"), cs.dir]
    const root = roots.find(r => existsSync(r)) ?? cs.dir
    let codes: string[] = []
    try {
      codes = (await scanSourceDetectors(root)).map((f: { code: string }) => f.code)
    } catch (e) {
      codes = [] // 评测循环不因单用例异常中断;计数靠 rows 体现
    }
    rows.push({ category: cs.category, name: cs.name, expected, hit: codes.length > 0, codes })
  }
  const categories = new Map<string, { tp: number; fp: number; fn: number; tn: number }>()
  let tp = 0, fp = 0, fn = 0, tn = 0
  for (const r of rows) {
    const c = categories.get(r.category) ?? { tp: 0, fp: 0, fn: 0, tn: 0 }
    if (r.expected && r.hit) { tp++; c.tp++ }
    else if (r.expected && !r.hit) { fn++; c.fn++ }
    else if (!r.expected && r.hit) { fp++; c.fp++ }
    else { tn++; c.tn++ }
    categories.set(r.category, c)
  }
  return {
    suite: suite.name, cases: rows.length, tp, fp, fn, tn,
    precision: tp + fp > 0 ? Math.round((tp / (tp + fp)) * 1000) / 10 : null,
    recall: tp + fn > 0 ? Math.round((tp / (tp + fn)) * 1000) / 10 : null,
    categories: [...categories.entries()].sort().map(([name, v]) => ({ name, ...v })),
    rows,
  }
}

/** Markdown 报告(含分层 FP 归因——辅助层 vs data-flow 层,与 Rust 版同规则)。 */
export function renderMd(r: BenchResult): string {
  // 正向白名单(与 Rust detector_layer 同口径):引擎污点流码 = dataflow;启发式检测器码 = aux
  const FLOW = ["TAINT_SRC_", "TAINT_SINK_", "EP_SRC_", "EP_SINK_", "CC_SRC_", "CC_SINK_"]
  const isAux = (code: string) => !FLOW.some(p => code.startsWith(p))
  const fpDf = r.rows.filter(x => !x.expected && x.hit && x.codes.some(c => !isAux(c))).length
  const fpAux = r.rows.filter(x => !x.expected && x.hit && x.codes.every(c => isAux(c))).length
  const lines = [
    `# 基准评测: ${r.suite}(droidseal bench)`, "",
    `- 评分用例:${r.cases} · TP=${r.tp} FP=${r.fp} FN=${r.fn} TN=${r.tn}`,
    `- **Precision ${r.precision ?? "—"}% ${fmtCi(r.tp, r.tp + r.fp)} · Recall ${r.recall ?? "—"}% ${fmtCi(r.tp, r.tp + r.fn)}**`, "",
    "## 分层 FP", "",
    "| 层 | 负例 FP |", "|---|---|",
    `| data-flow(参与门控) | ${fpDf} |`,
    `| 辅助 UI/隐私(不参与门控) | ${fpAux} |`, "",
    "## 类目分解", "",
    "| 类目 | TP | FP | FN | TN |", "|---|---|---|---|---|",
    ...r.categories.map(c => `| ${c.name} | ${c.tp} | ${c.fp} | ${c.fn} | ${c.tn} |`), "",
    "## FP 归因", "",
    ...(r.fp > 0 ? r.rows.filter(x => !x.expected && x.hit).map(x => `- ${x.category}/${x.name}: ${x.codes.slice(0, 5).join(", ")}`) : ["(无)"]), "",
    "## FN 明细", "",
    ...(r.fn > 0 ? r.rows.filter(x => x.expected && !x.hit).map(x => `- ${x.category}/${x.name}`) : ["(无)"]), "",
  ]
  return lines.join("\n")
}

/** JSON 报告(逐用例明细,供 CI/论文管线)。 */
export function renderJson(r: BenchResult): string {
  return JSON.stringify({
    suite: r.suite, cases: r.cases, tp: r.tp, fp: r.fp, fn: r.fn, tn: r.tn,
    precision: r.precision, recall: r.recall,
    categories: r.categories,
    details: r.rows,
  }, null, 2)
}
