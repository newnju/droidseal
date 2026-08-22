#!/usr/bin/env bun
// HTML 报告生成器（下一阶段中期③——MobSF 缺口：报告可视化）。
// 从 droidseal-report.json 生成自包含 HTML（内联 CSS——TUI/网站视觉：深墨蓝 + 青色），
// 含门禁横幅、指标、发现表格、步骤、加固成效、MASTG 参考、反编译建议、上次运行对比。
//
// 用法：
//   bun scripts/generate-html-report.ts <droidseal-report.json> [output.html]
import { readFile, writeFile } from "node:fs/promises"
import path from "node:path"

interface ReportJson {
  product?: string
  edition?: string
  generatedAt?: string
  releaseDecision?: { status?: string; reasonCodes?: string[] }
  steps?: Array<{ id?: string; status?: string; title?: string }>
  audit?: { findings?: Array<{ severity?: string; code?: string; title?: string; confidence?: string; evidence?: string; detail?: string }> }
  hardeningEffectiveness?: { sizeDeltaPercent?: number; coverage?: { covered?: number; total?: number } }
  previousRun?: { previousGate?: string; eliminated?: string[]; added?: string[]; remaining?: string[] }
  mastg?: Array<{ code?: string; title?: string; reference?: string }>
  decompileSuggestions?: Array<{ code?: string; title?: string }>
  remediation?: { suggestionCount?: number }
}

function escapeHtml(value: string): string {
  return value.replace(/[<>&'"]/g, (c) => ({ "<": "&lt;", ">": "&gt;", "&": "&amp;", "'": "&#39;", '"': "&quot;" })[c] ?? c)
}

function render(report: ReportJson): string {
  const gate = report.releaseDecision?.status ?? "unknown"
  const findings = report.audit?.findings ?? []
  const chips = (severity: string): string =>
    `<span class="chip ${severity}">${escapeHtml(severity)}</span>`
  const findingsRows = findings
    .slice(0, 100)
    .map(
      (f) =>
        `<tr><td>${chips(f.severity ?? "info")}</td><td class="code">${escapeHtml(f.code ?? "")}</td><td>${escapeHtml(f.title ?? "")}</td><td>${escapeHtml(f.confidence ?? "")}</td><td class="ev">${escapeHtml((f.evidence ?? "").slice(0, 80))}</td></tr>`,
    )
    .join("")
  const stepsPills = (report.steps ?? [])
    .map((s) => `<span class="step-pill ${s.status ?? ""}">${escapeHtml(s.id ?? "")} · ${escapeHtml(s.status ?? "")}</span>`)
    .join("")
  const mastgRows = (report.mastg ?? [])
    .map((m) => `<li><code>${escapeHtml(m.code ?? "")}</code> ${escapeHtml(m.title ?? "")} → ${escapeHtml(m.reference ?? "")}</li>`)
    .join("")
  const decompile = (report.decompileSuggestions ?? [])
    .slice(0, 10)
    .map((d) => `<li><code>${escapeHtml(d.code ?? "")}</code> ${escapeHtml(d.title ?? "")}</li>`)
    .join("")
  const prev = report.previousRun
  const prevLines = prev
    ? `<li>上次门禁：${escapeHtml(prev.previousGate ?? "未知")}；消除 ${(prev.eliminated ?? []).length}、新增 ${(prev.added ?? []).length}、剩余 ${(prev.remaining ?? []).length}</li>`
    : "<li>无历史运行可对比。</li>"

  return `<!doctype html>
<html lang="zh"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>DroidSeal 报告</title>
<style>
:root{--bg:#061521;--card:#0a2132;--solid:#102d42;--border:#1d4258;--cyan:#79c9e7;--text:#e6f4fa;--muted:#87a9ba;--success:#63d6aa;--warning:#f0bd68;--danger:#ed8796;--info:#00a8cc}
*{box-sizing:border-box;margin:0;padding:0}
body{background:radial-gradient(40% 35% at 22% 18%,rgba(0,168,204,.16),transparent 60%),var(--bg);color:var(--text);font-family:'Inter',-apple-system,'Segoe UI',sans-serif;min-height:100vh}
.wrap{max-width:980px;margin:0 auto;padding:28px 22px 60px}
h1{font-size:20px;margin-bottom:4px}h2{font-size:14px;margin:22px 0 10px;color:var(--muted);font-weight:600}
.meta{color:var(--muted);font-size:12px;margin-bottom:18px}
.banner{padding:14px 16px;border-radius:10px;font-size:13px;margin-bottom:16px;border:1px solid}
.banner.pass{background:rgba(99,214,170,.1);border-color:rgba(99,214,170,.4);color:var(--success)}
.banner.review{background:rgba(240,189,104,.1);border-color:rgba(240,189,104,.4);color:var(--warning)}
.banner.block{background:rgba(237,135,150,.1);border-color:rgba(237,135,150,.4);color:var(--danger)}
.card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:16px;margin-bottom:16px}
table{width:100%;border-collapse:collapse;font-size:12.5px}
th{text-align:left;color:var(--muted);font-weight:500;padding:8px 10px;border-bottom:1px solid var(--border);white-space:nowrap}
td{padding:8px 10px;border-bottom:1px solid rgba(29,66,88,.5);vertical-align:top}
.chip{display:inline-block;padding:2px 8px;border-radius:20px;font-size:11px;font-weight:600}
.chip.critical{background:rgba(237,135,150,.15);color:var(--danger)}.chip.high{background:rgba(245,169,127,.15);color:#f5a97f}
.chip.medium{background:rgba(240,189,104,.15);color:var(--warning)}.chip.low{background:rgba(0,168,204,.15);color:var(--info)}
.chip.info{background:rgba(135,169,186,.15);color:var(--muted)}
.code{font-family:'JetBrains Mono',monospace;font-size:11.5px;color:var(--cyan)}
.ev{max-width:260px;word-break:break-all;color:var(--muted);font-size:11.5px}
.steps{display:flex;flex-wrap:wrap;gap:6px}.step-pill{font-size:11px;padding:3px 9px;border-radius:20px;border:1px solid var(--border);color:var(--muted)}
.step-pill.success{color:var(--success);border-color:rgba(99,214,170,.35)}.step-pill.skipped{color:var(--warning);border-color:rgba(240,189,104,.3)}
.step-pill.failed{color:var(--danger);border-color:rgba(237,135,150,.35)}
ul{font-size:12.5px;line-height:1.8;padding-left:20px;color:var(--text)}
</style></head><body><div class="wrap">
<h1>DroidSeal 安全审计报告</h1>
<div class="meta">${escapeHtml(report.product ?? "DroidSeal")} · ${escapeHtml(report.edition ?? "")} · ${escapeHtml(report.generatedAt ?? "")}</div>
<div class="banner ${gate}">发布门禁：<b>${escapeHtml(gate)}</b>（${(report.releaseDecision?.reasonCodes ?? []).length} 个原因 code）</div>
<div class="card"><h2>发现（${findings.length}）</h2>
<table><thead><tr><th>严重度</th><th>代码</th><th>标题</th><th>置信度</th><th>证据</th></tr></thead><tbody>${findingsRows || '<tr><td colspan="5">无发现</td></tr>'}</tbody></table></div>
<div class="card"><h2>步骤状态</h2><div class="steps">${stepsPills || "无步骤信息"}</div></div>
<div class="card"><h2>加固成效</h2><ul><li>产物体积变化：${report.hardeningEffectiveness?.sizeDeltaPercent?.toFixed(1) ?? "-"}%</li><li>加固覆盖度：${report.hardeningEffectiveness?.coverage?.covered ?? 0}/${report.hardeningEffectiveness?.coverage?.total ?? 0}</li><li>修复包建议数：${report.remediation?.suggestionCount ?? 0}</li></ul></div>
<div class="card"><h2>OWASP MASTG 参考</h2><ul>${mastgRows || "<li>无映射发现。</li>"}</ul></div>
<div class="card"><h2>反编译核验建议</h2><ul>${decompile || "<li>无需反编译核验。</li>"}<li class="meta">命令：jadx -d out app.apk（或 apktool d app.apk）</li></ul></div>
<div class="card"><h2>上次运行对比</h2><ul>${prevLines}</ul></div>
</div></body></html>`
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: generate-html-report <droidseal-report.json> [output.html]")
  const output = argv[1] ?? path.join(path.dirname(reportPath), "droidseal-report.html")
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  await writeFile(output, render(report), "utf8")
  console.log(`已生成 HTML 报告：${output}`)
}

main().catch((error) => {
  console.error(`HTML 报告生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
