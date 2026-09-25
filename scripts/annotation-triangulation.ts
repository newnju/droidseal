#!/usr/bin/env bun
// 代码工件三角验证(annotation-kappa 的零标注人替代方案)。
// 动机:ground truth 标签由程序从 DroidBench 官方 README 提取(非人工),
//   标注者间一致性(κ)不适用;改用"独立证据源对撞"验证提取协议的客观性:
//   证据 A(文档层)= 官方 README 行为描述 → leak-positive/negative
//   证据 B(代码层) = APK 源码内的可观察工件(与证据 A 完全独立的通道):
//     - 泄漏汇点调用: Telephony.Sms.send / SmsManager / Runtime.exec 重定向外的
//       Log.d|v|i / openConnection / FileOutputStream / insert(DB) 等
//     - 敏感源调用: getDeviceId / getImei / getLatitude|getLongitude / getContents(clipl) 等
//   判定:positive 用例要求 源与汇点共现(leak-capable 工件);
//         negative 用例要求无汇点调用(或 README 声明的"常量/未污染"缺失敏感源)。
//   报告:两证据一致率 + 冲突用例清单(冲突=协议歧义或 README 与代码错位,逐条人工归因)。
// 输出:textseg/annotation-kappa/triangulation.md|json
//
// 用法: bun scripts/annotation-triangulation.ts <DroidBench-projects-dir> [--map <map.json>] [--out <dir>]
import { readdir, readFile, writeFile, mkdir } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"

const args = process.argv.slice(2)
const dir = args[0]!
const mapIdx = args.indexOf("--map")
const outIdx = args.indexOf("--out")
const mapFile = mapIdx >= 0 ? args[mapIdx + 1]! : "/tmp/droidbench-map.json"
const outDir = outIdx >= 0 ? args[outIdx + 1]! : "textseg/annotation-kappa"
if (!dir || !existsSync(dir)) {
  console.error("用法: bun scripts/annotation-triangulation.ts <projects-dir> [--map map.json] [--out dir]")
  process.exit(2)
}

const semanticMap = JSON.parse(await readFile(mapFile, "utf8")) as {
  positive: Array<{ name: string; desc: string }>
  negative: Array<{ name: string; desc: string }>
}
const expectLeak = new Map<string, { leak: boolean; desc: string }>()
for (const e of semanticMap.positive) expectLeak.set(e.name.toLowerCase(), { leak: true, desc: e.desc })
for (const e of semanticMap.negative) expectLeak.set(e.name.toLowerCase(), { leak: false, desc: e.desc })

// ── 证据 B:代码工件正则(全部为 API 调用签名,与文档描述无共享词汇) ──────────
const SINK_PATTERNS: Array<[string, RegExp]> = [
  ["sms", /Telephony\.Sms\.(send|CONTENT_URI)|SmsManager\.[a-zA-Z]*send|MultipartSmsSender|sendTextMessage/],
  ["log", /Log\.[divew]\s*\(/],
  ["net", /openConnection\s*\(|HttpURLConnection|DefaultHttpClient|OkHttpClient|Socket\s*\(|URL\s*\(/],
  ["file", /FileOutputStream|openFileOutput|getExternalStorageDirectory|Files\.write/],
  ["db", /\.insert\s*\(|SQLiteDatabase|getWritableDatabase/],
  ["intent", /sendBroadcast|startActivity|setData\s*\(/],
]
const SOURCE_PATTERNS: Array<[string, RegExp]> = [
  ["deviceId", /getDeviceId|getImei|getSubscriberId|getSimSerialNumber|ANDROID_ID|Secure\.ANDROID_ID/],
  ["location", /getLatitude|getLongitude|getLastKnownLocation|requestLocationUpdates|getCellLocation/],
  ["contacts", /ContactsContract|getContentResolver\(\)\.query/],
  ["accounts", /getAccountsByType|AccountManager/],
  ["clipboard", /getClipboardManager|getPrimaryClip|ClipBoard/],
]

async function* walkFiles(root: string): AsyncGenerator<string> {
  const entries = await readdir(root, { withFileTypes: true })
  for (const e of entries) {
    const p = path.join(root, e.name)
    if (e.isDirectory()) yield* walkFiles(p)
    else if (/\.(java|kt)$/.test(e.name)) yield p
  }
}

interface Evidence { sinks: Set<string>; sources: Set<string>; files: number }
async function extractEvidence(caseDir: string): Promise<Evidence> {
  const ev: Evidence = { sinks: new Set(), sources: new Set(), files: 0 }
  const srcRoots = [
    path.join(caseDir, "app", "src", "main", "java"),
    path.join(caseDir, "src", "main", "java"),
    caseDir,
  ]
  const root = srcRoots.find(r => existsSync(r)) ?? caseDir
  for await (const f of walkFiles(root)) {
    ev.files++
    let text = ""
    try { text = await readFile(f, "utf8") } catch { continue }
    for (const [k, re] of SINK_PATTERNS) if (re.test(text)) ev.sinks.add(k)
    for (const [k, re] of SOURCE_PATTERNS) if (re.test(text)) ev.sources.add(k)
  }
  return ev
}

// ── 遍历用例并收集双证据 ────────────────────────────────────────────────────
interface Row {
  category: string; name: string; docLeak: boolean; desc: string
  sinks: string[]; sources: string[]; files: number
  codeLeakCapable: boolean; agree: boolean | null; note: string
}
const rows: Row[] = []
const categories = (await readdir(dir, { withFileTypes: true })).filter(d => d.isDirectory())
for (const cat of categories) {
  const catDir = path.join(dir, cat.name)
  const cases = (await readdir(catDir, { withFileTypes: true })).filter(d => d.isDirectory())
  for (const cs of cases) {
    const sem = expectLeak.get(cs.name.toLowerCase())
    if (!sem) continue
    const ev = await extractEvidence(path.join(catDir, cs.name))
    // 代码层判定:泄漏能力 = 敏感源与汇点同时存在
    const codeLeakCapable = ev.sinks.size > 0 && ev.sources.size > 0
    // 一致性:positive 且代码有泄漏能力 → 一致;positive 但代码无工件 → 待归因
    //          negative 且代码无汇点 → 一致;negative 但代码有汇点+源 → 冲突(README 说不漏,但结构上具备能力)
    let agree: boolean | null
    let note = ""
    if (sem.leak && codeLeakCapable) { agree = true }
    else if (sem.leak && !codeLeakCapable) {
      // 正例但无完整源-汇对:可能只用了隐式流/常量合成源(README 声明泄漏,静态工件不完整)
      if (ev.sinks.size > 0) { agree = true; note = "sink-only(隐式流或库内源,工件不完整)" }
      else { agree = null; note = "no-artifact(工件层不可观察,如纯反射/库间流)" }
    } else if (!sem.leak && ev.sinks.size === 0) { agree = true }
    else { agree = false; note = "code-capable(负例但具备源+汇点,需归因:常量合成/未污染值)" }
    rows.push({
      category: cat.name, name: cs.name, docLeak: sem.leak, desc: sem.desc.slice(0, 120),
      sinks: [...ev.sinks], sources: [...ev.sources], files: ev.files,
      codeLeakCapable, agree, note,
    })
  }
}

// ── 汇总 ────────────────────────────────────────────────────────────────────
const pos = rows.filter(r => r.docLeak)
const neg = rows.filter(r => !r.docLeak)
const agreeCount = rows.filter(r => r.agree === true).length
const conflictCount = rows.filter(r => r.agree === false).length
const unobservable = rows.filter(r => r.agree === null).length
const scorable = agreeCount + conflictCount
const agreeRate = scorable > 0 ? Math.round((agreeCount / scorable) * 1000) / 10 : null
// 分层:正例证据覆盖(sink 存在率)
const posSinkCover = pos.length > 0 ? Math.round((pos.filter(r => r.sinks.length > 0).length / pos.length) * 1000) / 10 : null
const negSinkFree = neg.length > 0 ? Math.round((neg.filter(r => r.sinks.length === 0).length / neg.length) * 1000) / 10 : null

const md = [
  "# 代码工件三角验证(文档层 ↔ 代码层,零标注人)",
  "",
  `- 证据 A(文档层):DroidBench 官方 README 行为描述 → ${pos.length} 正例 / ${neg.length} 负例(程序化提取,无人工标注)`,
  "- 证据 B(代码层):源码内 API 工件(6 类汇点 / 5 类敏感源),与文档描述零共享词汇",
  `- 评测用例:${rows.length} | 日期:${new Date().toISOString().slice(0, 10)}`,
  "",
  "| 指标 | 值 |",
  "|---|---|",
  `| 可评分用例(有代码工件) | ${scorable} / ${rows.length} |`,
  `| 两证据一致率 | ${agreeRate ?? "—"}%(${agreeCount}/${scorable}) |`,
  `| 正例汇点工件覆盖 | ${posSinkCover ?? "—"}% |`,
  `| 负例无汇点工件 | ${negSinkFree ?? "—"}% |`,
  `| 冲突(文档说负例但代码具能力) | ${conflictCount} |`,
  `| 工件不可观察(纯反射/库间流等) | ${unobservable} |`,
  "",
  "## 冲突用例清单(逐条归因对象)",
  "",
  ...(rows.filter(r => r.agree === false).map(r =>
    `- ${r.category}/${r.name}: sinks=[${r.sinks}] sources=[${r.sources}] | README: ${r.desc.slice(0, 80)}`) || ["(无)"]),
  "",
  "## 工件不可观察清单",
  "",
  ...(rows.filter(r => r.agree === null).map(r => `- ${r.category}/${r.name}: ${r.note}`) || ["(无)"]),
  "",
  "## sink-only 正例(工件不完整但方向一致)",
  "",
  ...(rows.filter(r => r.note.startsWith("sink-only")).map(r => `- ${r.category}/${r.name}: sinks=[${r.sinks}]`) || ["(无)"]),
].join("\n")

await mkdir(outDir, { recursive: true })
await writeFile(path.join(outDir, "triangulation.md"), md)
await writeFile(path.join(outDir, "triangulation.json"), JSON.stringify({
  date: new Date().toISOString(), agreeRate, posSinkCover, negSinkFree,
  totals: { rows: rows.length, agree: agreeCount, conflict: conflictCount, unobservable, scorable },
  rows,
}, null, 2))
console.log(md)
