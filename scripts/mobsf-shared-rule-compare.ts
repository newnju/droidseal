// 共享规则集正面对比:MobSF 4.5.2 vs DroidSeal(同一批 7 个 APK)
// 方法:把双方发现归一到共享规则语义 ID,以清单/证书的客观属性为 ground truth,
// 计算共享规则层上每个工具的 TP/FP/FN 与精度/召回,产出对比表。
import { readFileSync, writeFileSync, mkdirSync, existsSync } from "node:fs"

const SAMPLES = [
  "ds-test-input", "FlowSensitivity1", "ArrayAccess1",
  "Reflection1", "DirectLeak1", "Clone1", "Button1",
]
const MOBSF_DIR = "C:/tmp/mobsf-scan"
const DS_GLOB = (s) => {
  // 找该样本最新 run 的报告
  const base = `C:/Users/diamond/textseg/multisample/${s}/.droidseal/runs`
  if (!existsSync(base)) return null
  const runs = require("node:fs").readdirSync(base).sort().reverse()
  for (const r of runs) {
    const p = `${base}/${r}/reports/droidseal-report.json`
    if (existsSync(p)) return p
  }
  return null
}

// 共享规则语义:MobSF 标题片段 <-> DroidSeal 规则码
const SHARED = [
  { id: "DEBUGGABLE", ds: "MANIFEST_DEBUGGABLE", msf: ["Debug Enabled For App"],
    truth: (m) => m.debuggable === true },
  { id: "ALLOW_BACKUP", ds: "MANIFEST_BACKUP_ENABLED", msf: ["Application Data can be Backed up"],
    truth: (m) => m.allowBackup !== false },
  { id: "MIN_SDK_OUTDATED", ds: "COMPLIANCE_MIN_SDK_OUTDATED", msf: ["vulnerable unpatched"],
    truth: (m) => m.min_sdk < 21 },
  { id: "TARGET_SDK_OUTDATED", ds: "COMPLIANCE_TARGET_SDK_OUTDATED", msf: ["vulnerable unpatched"],
    truth: (m) => m.target_sdk < 29 },
]

const rows = []
for (const s of SAMPLES) {
  const mPath = `${MOBSF_DIR}/scan-${s}.json`
  const dPath = DS_GLOB(s)
  if (!existsSync(mPath) || !dPath) { rows.push({ sample: s, error: "missing report" }); continue }
  const msf = JSON.parse(readFileSync(mPath, "utf8"))
  const ds = JSON.parse(readFileSync(dPath, "utf8"))
  const msfTitles = [
    ...(msf.manifest_analysis?.manifest_findings ?? []).map((f) => f.title ?? ""),
    ...(msf.certificate_analysis?.certificate_findings ?? []).map((f) => Array.isArray(f) ? f[1] ?? "" : String(f)),
  ]
  const dsCodes = new Set((ds.audit?.findings ?? []).map((f) => f.code))
  const meta = {
    debuggable: (msf.manifest_analysis?.manifest_findings ?? []).some((f) => (f.title ?? "").includes("debuggable=true")),
    allowBackup: (msf.manifest_analysis?.manifest_findings ?? []).some((f) => (f.title ?? "").includes("allowBackup=true")) || msf.manifest_analysis?.manifest_findings?.some((f) => (f.title ?? "").includes("Backed up")),
    min_sdk: Number(msf.min_sdk ?? 99),
    target_sdk: Number(msf.target_sdk ?? 99),
  }
  const row: Record<string, any> = { sample: s, rules: {} }
  for (const r of SHARED) {
    const msfFire = r.msf.some((frag) => msfTitles.some((t) => t.includes(frag)))
    const dsFire = dsCodes.has(r.ds)
    const gt = r.truth(meta)
    row.rules[r.id] = { msf: msfFire, ds: dsFire, gt }
  }
  // MobSF 特有(共享集之外,记录不评分): StrandHogg、证书细节
  row.msf_only = msfTitles.filter((t) => t.includes("StrandHogg") || t.includes("signed")).length
  // DroidSeal 特有(共享集之外): 数据流/加固/密钥串等
  const sharedDsCodes = new Set(SHARED.map((r) => r.ds))
  row.ds_only = [...dsCodes].filter((c: string) => !sharedDsCodes.has(c)).length
  rows.push(row)
}

// 汇总共享规则层
const agg: Record<string, any> = {}
for (const r of SHARED) agg[r.id] = { ds: { tp: 0, fp: 0, fn: 0 }, msf: { tp: 0, fp: 0, fn: 0 }, both: 0, n: 0 }
for (const row of rows) {
  if (row.error) continue
  for (const r of SHARED) {
    const v = row.rules[r.id]
    const a = agg[r.id]
    a.n++
    if (v.msf && v.ds) a.both++
    for (const [tool, fired] of [["msf", v.msf], ["ds", v.ds]]) {
      if (fired && v.gt) a[tool].tp++
      else if (fired && !v.gt) a[tool].fp++
      else if (!fired && v.gt) a[tool].fn++
    }
  }
}
const prec = (t: any) => t.tp + t.fp === 0 ? null : t.tp / (t.tp + t.fp)
const rec = (t: any) => t.tp + t.fn === 0 ? null : t.tp / (t.tp + t.fn)

let md = ["# MobSF 4.5.2 vs DroidSeal —— 共享规则集正面对比", "",
  `样本: ${SAMPLES.join(", ")}(n=7)`, "",
  "方法: 双方发现归一到共享规则语义(调试/备份/SDK过旧),以清单属性为客观 ground truth。",
  "MobSF APK 模式无源码级规则(code_analysis=0),故共享层 = 清单配置规则;数据流维度为 DroidSeal 特有,不入共享集。", "",
  "| 共享规则 | 双方一致 | MobSF TP/FP/FN | DroidSeal TP/FP/FN | MobSF 精度/召回 | DroidSeal 精度/召回 |",
  "|---|---|---|---|---|---|"]
for (const r of SHARED) {
  const a = agg[r.id]
  const fmt = (t: any) => t.tp === 0 && t.fp === 0 && t.fn === 0 ? "—" : `${t.tp}/${t.fp}/${t.fn}`
  const pr = (t: any) => { const p = prec(t), q = rec(t); return p === null ? "—" : `${(p * 100).toFixed(0)}%/${(q * 100).toFixed(0)}%` }
  md.push(`| ${r.id} | ${a.both}/${a.n} | ${fmt(a.msf)} | ${fmt(a.ds)} | ${pr(a.msf)} | ${pr(a.ds)} |`)
}
md.push("", "## 逐样本一致/分歧明细", "", "| 样本 | 一致规则 | MobSF 特有(未评分) | DroidSeal 特有(未评分) |", "|---|---|---|---|")
for (const row of rows) {
  if (row.error) { md.push(`| ${row.sample} | ${row.error} | | |`); continue }
  const agree = Object.entries(row.rules).filter(([, v]) => (v as any).msf === (v as any).ds).length
  const dis = Object.entries(row.rules).filter(([, v]) => (v as any).msf !== (v as any).ds).map(([k, v]) => `${k}(M:${(v as any).msf?1:0}/D:${(v as any).ds?1:0}/T:${(v as any).gt?1:0})`)
  md.push(`| ${row.sample} | ${agree}/4 | ${row.msf_only} 条 | ${row.ds_only} 条 ${dis.length ? "⚠ " + dis.join(", ") : ""} |`)
}
writeFileSync("C:/Users/diamond/DroidSeal-GitHub/textseg/mobsf-shared-rules/comparison.md", md.join("\n"))
writeFileSync("C:/Users/diamond/DroidSeal-GitHub/textseg/mobsf-shared-rules/comparison.json", JSON.stringify({ rows, agg }, null, 2))
console.log(md.join("\n"))
