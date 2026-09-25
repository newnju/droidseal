#!/usr/bin/env bun
// DroidBench 官方语义基准评测(droidbench-eval.ts)。
// Ground truth 来源:DroidBench 官方仓库 README 的逐 case 行为描述
//   (secure-software-engineering/DroidBench — 每条描述明确说明泄漏或不泄漏),
//   这是项目文档自带的公认语义标注,替代此前"自标注近似"。
//   负例判定:描述含 "no data / not leak / only the untainted / only constant /
//   never leak / no leak"(README 原文措辞)。
// 评测方式:对每个用例的源码目录跑 scanSourceDetectors,
//   正例:命中任意 SOURCE_* 记 TP,零命中记 FN;
//   负例:零命中记 TN,命中任意记 FP。
// 输出:precision / recall / 分类明细(accuracy / 类目分层)。
//
// 用法: bun scripts/droidbench-eval.ts <DroidBench-projects-dir> [--map <droidbench-map.json>] [--out <dir>]
import { readdir, readFile, writeFile, mkdir } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"
import { scanSourceDetectors } from "../src/core/source-detectors.ts"

const args = process.argv.slice(2)
const dir = args[0]!
const mapIdx = args.indexOf("--map")
const outIdx = args.indexOf("--out")
const mapFile = mapIdx >= 0 ? args[mapIdx + 1]! : "/tmp/droidbench-map.json"
const outDir = outIdx >= 0 ? args[outIdx + 1]! : "./droidbench-eval-out"
if (!dir || !existsSync(dir)) {
  console.error("用法: bun scripts/droidbench-eval.ts <DroidBench-projects-dir> [--map map.json] [--out dir]")
  process.exit(2)
}

// ── 载入官方语义 map ─────────────────────────────────────────────────────────
const semanticMap = JSON.parse(await readFile(mapFile, "utf8")) as {
  positive: Array<{ name: string; desc: string }>
  negative: Array<{ name: string; desc: string }>
}
const expectLeak = new Map<string, { leak: boolean; desc: string }>()
for (const e of semanticMap.positive) expectLeak.set(e.name.toLowerCase(), { leak: true, desc: e.desc })
for (const e of semanticMap.negative) expectLeak.set(e.name.toLowerCase(), { leak: false, desc: e.desc })
console.log(`语义 map: ${semanticMap.positive.length} 正例 / ${semanticMap.negative.length} 负例`)

// ── 遍历用例目录(两级:类目/用例)────────────────────────────────────────────
interface Row { category: string; name: string; expectLeak: boolean; hits: string[]; hitCount: number }
const rows: Row[] = []
const categories = (await readdir(dir, { withFileTypes: true })).filter(d => d.isDirectory())
for (const cat of categories) {
  const catDir = path.join(dir, cat.name)
  const cases = (await readdir(catDir, { withFileTypes: true })).filter(d => d.isDirectory())
  for (const cs of cases) {
    const name = cs.name
    const sem = expectLeak.get(name.toLowerCase())
    if (!sem) continue // 无官方描述的 case 跳过(不计入)
    const caseDir = path.join(catDir, name)
    // 源码定位:app/src/main/java(标准 gradle 布局)或直接递归 .java/.kt
    let hits: string[] = []
    try {
      const srcRoots = [
        path.join(caseDir, "app", "src", "main", "java"),
        path.join(caseDir, "src", "main", "java"),
        caseDir,
      ]
      const root = srcRoots.find(r => existsSync(r)) ?? caseDir
      // scanSourceDetectors 的目录模式(位置参数 projectDir)
      const findings = await scanSourceDetectors(root)
      hits = findings.map((f: { code: string }) => f.code)
    } catch (e) {
      hits = [`__ERROR__:${String(e).slice(0, 80)}`]
    }
    rows.push({ category: cat.name, name, expectLeak: sem.leak, hits, hitCount: hits.filter(h => !h.startsWith("__ERROR__")).length })
  }
}

// ── 统计 ────────────────────────────────────────────────────────────────────
let tp = 0, fp = 0, fn = 0, tn = 0
const byCategory = new Map<string, { tp: number; fp: number; fn: number; tn: number }>()
for (const r of rows) {
  const detected = r.hitCount > 0
  const c = byCategory.get(r.category) ?? { tp: 0, fp: 0, fn: 0, tn: 0 }
  if (r.expectLeak && detected) { tp++; c.tp++ }
  else if (r.expectLeak && !detected) { fn++; c.fn++ }
  else if (!r.expectLeak && detected) { fp++; c.fp++ }
  else { tn++; c.tn++ }
  byCategory.set(r.category, c)
}
const precision = tp + fp > 0 ? Math.round((tp / (tp + fp)) * 1000) / 10 : null
const recall = tp + fn > 0 ? Math.round((tp / (tp + fn)) * 1000) / 10 : null
const accuracy = rows.length > 0 ? Math.round(((tp + tn) / rows.length) * 1000) / 10 : null

// ── 输出 ────────────────────────────────────────────────────────────────────
const md = [
  "# DroidBench 官方语义基准评测",
  "",
  `- Ground truth:DroidBench 官方 README 逐 case 行为描述(${semanticMap.positive.length} 正例 / ${semanticMap.negative.length} 负例)`,
  `- 评测用例数:${rows.length}(有官方描述且本地有源码目录)`,
  `- 日期:${new Date().toISOString().slice(0, 10)}`,
  "",
  "| 指标 | 值 |",
  "|---|---|",
  `| Precision(TP/(TP+FP)) | ${precision ?? "—"}% |`,
  `| Recall(TP/(TP+FN)) | ${recall ?? "—"}% |`,
  `| Accuracy | ${accuracy ?? "—"}% |`,
  `| TP=${tp} FP=${fp} FN=${fn} TN=${tn} | |`,
  "",
  "## 类目分层",
  "",
  "| 类目 | TP | FP | FN | TN |",
  "|---|---|---|---|---|",
  ...[...byCategory.entries()].sort().map(([k, v]) => `| ${k} | ${v.tp} | ${v.fp} | ${v.fn} | ${v.tn} |`),
  "",
  "## 负例误报明细(FP)",
  "",
  ...(rows.filter(r => !r.expectLeak && r.hitCount > 0).map(r => `- ${r.category}/${r.name}: ${r.hits.slice(0, 3).join(", ")}`) || ["(无)"]),
  "",
  "## 正例漏报明细(FN)",
  "",
  ...(rows.filter(r => r.expectLeak && r.hitCount === 0).slice(0, 40).map(r => `- ${r.category}/${r.name}`) || ["(无)"]),
].join("\n")

await mkdir(outDir, { recursive: true })
await writeFile(path.join(outDir, "droidbench-eval.md"), md)
await writeFile(path.join(outDir, "droidbench-eval.json"), JSON.stringify({ date: new Date().toISOString(), precision, recall, accuracy, totals: { tp, fp, fn, tn }, rows }, null, 2))
console.log(md)
