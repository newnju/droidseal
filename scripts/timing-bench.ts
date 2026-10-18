#!/usr/bin/env bun
// 计时与资源证据(进程内版):直接以同引擎跑 bench(等价于 CLI 的评测循环),
// 采样墙钟 / 进程内峰值 RSS / CPU,并对每个用例做隔离端到端计时(临时 junction 目录)。
// 论文中的运行时长/内存数字必须能由本脚本 + 提交的输出复现。
// 用法: bun scripts/timing-bench.ts <suite.json | dataset-dir> [--out <dir>] [--label <name>]
// 口径:
//   - wall/peakRss/CPU:全量连跑一次的同进程读数;
//   - per-case:每用例在临时目录(仅含该用例的 junction)单独起 runSuite,
//     含套件装配固定开销,属"单用例端到端"读数,与连跑 wall 不可加和分析。
import { writeFile, mkdir, rm, symlink, readdir } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"
import os from "node:os"
import { loadSuite, runSuite } from "../src/core/bench.ts"

const args = process.argv.slice(2)
const spec = args[0]
const outIdx = args.indexOf("--out")
const labelIdx = args.indexOf("--label")
const outDir = outIdx >= 0 ? args[outIdx + 1]! : "./timing-out"
const label = labelIdx >= 0 ? args[labelIdx + 1]! : path.basename(spec)
if (!spec) {
  console.error("用法: bun scripts/timing-bench.ts <suite.json | dataset-dir> [--out versioned-eval-out] [--label name]")
  process.exit(2)
}

// 50ms 间隔采样进程内 RSS(同进程内 heap + external),记录峰值
let peakRss = 0
const timer = setInterval(() => {
  const rss = process.memoryUsage.rss()
  if (rss > peakRss) peakRss = rss
}, 50)

const cpu0 = process.cpuUsage()
const t0 = performance.now()
const suites = await loadSuite(spec)
const results = []
for (const s of suites) {
  const r = await runSuite(s)
  results.push(r)
}
const wallMs = Math.round(performance.now() - t0)
clearInterval(timer)

const cpuDelta = process.cpuUsage(cpu0)
const cpuMs = Math.round((cpuDelta.user + cpuDelta.system) / 1000)

let verdict = ""
for (const r of results) {
  verdict += `suite=${r.suite} cases=${r.cases} tp=${r.tp} fp=${r.fp} fn=${r.fn} tn=${r.tn}; `
}

// ---- 逐用例隔离计时(kind=droidbench 且按 <cat>/<case> 两级布局时启用)----
const namedCases = ["PrivateDataLeak1", "FlowSensitivity1", "ApplicationModeling1", "Merge1", "Obfuscation1", "ArrayAccess4"]
const perCase: Array<{ name: string; category: string; ms: number }> = []
let perCaseWall = 0
for (const r of results) {
  const suite = suites.find(s => s.name === r.suite)
  if (!suite || suite.kind !== "droidbench") continue
  const roots = await readdir(suite.projects_dir, { withFileTypes: true })
  for (const cat of roots) {
    if (!cat.isDirectory()) continue
    const caseDir = path.join(suite.projects_dir, cat.name)
    const cases = (await readdir(caseDir, { withFileTypes: true })).filter(d => d.isDirectory())
    for (const c of cases) {
      const tmpRoot = path.join(os.tmpdir(), `droidseal-timing-${Date.now()}-${c.name.replace(/[^\w.-]/g, "_")}`)
      await mkdir(path.join(tmpRoot, cat.name), { recursive: true })
      try {
        await symlink(caseDir, path.join(tmpRoot, cat.name, c.name), "junction")
        const iso: typeof suite = { ...suite, name: `iso:${c.name}`, projects_dir: tmpRoot }
        const t = performance.now()
        await runSuite(iso)
        const ms = Math.round((performance.now() - t) * 10) / 10
        perCase.push({ name: c.name, category: cat.name, ms })
        if (namedCases.includes(c.name) && !perCaseWall) perCaseWall = ms
      } finally {
        await rm(tmpRoot, { recursive: true, force: true }).catch(() => {})
      }
    }
  }
}
perCaseWall = Math.round((perCase.reduce((acc, p) => acc + p.ms, 0) / Math.max(1, perCase.length)) * 10) / 10
perCase.sort((a, b) => b.ms - a.ms)
const pct = (q: number) => perCase[Math.min(perCase.length - 1, Math.floor(q * perCase.length))]?.ms ?? null
const perCaseStats = {
  count: perCase.length,
  meanMs: perCaseWall,
  p50Ms: pct(0.5) ?? null,
  p90Ms: pct(0.9) ?? null,
  maxMs: perCase[0]?.ms ?? null,
  minMs: perCase[perCase.length - 1]?.ms ?? null,
}
const named = perCase.filter(p => namedCases.includes(p.name)).map(p => ({ name: p.name, ms: p.ms }))

const record = {
  label,
  suite: spec.replace(/\\/g, "/"),
  wallMs,
  peakRssMB: Math.round((peakRss / 1024 / 1024) * 10) / 10,
  cpuTotalMs: cpuMs,
  perCase: perCaseStats,
  perCaseNamed: named,
  verdict: verdict.trim(),
  timestamp: new Date().toISOString(),
  engine: "bun 1.4.2 · TS core (same engine as audit, scanSourceDetectors)",
}
const md = [
  `# Bench timing evidence — ${label}`,
  "",
  `- suite: \`${record.suite}\``,
  `- wall clock: **${wallMs} ms**(进程内评测循环计时,含全部 loadSuite + runSuite)`,
  `- peak RSS: **${record.peakRssMB} MB**(进程内 rss 采样,50ms 间隔)`,
  `- CPU(user+system): **${record.cpuTotalMs} ms**(process.cpuUsage 差值)`,
  `- per-case(n=${perCaseStats.count},隔离端到端含固定开销): mean **${perCaseStats.meanMs} ms**, p50 ${perCaseStats.p50Ms}, p90 ${perCaseStats.p90Ms}, max ${perCaseStats.maxMs}, min ${perCaseStats.minMs}`,
  ...named.map(n => `- named case ${n.name}: **${n.ms} ms**`),
  `- results: ${record.verdict}`,
  `- date: ${record.timestamp}`,
  "",
  `> 口径:同引擎、同 GT 分层;计时与内存由 \`scripts/timing-bench.ts\` 一个命令复现。`,
].join("\n")

await mkdir(outDir, { recursive: true })
await writeFile(path.join(outDir, "timing-report.json"), JSON.stringify(record, null, 2))
await writeFile(path.join(outDir, "timing-report.md"), md)
console.log(md)
