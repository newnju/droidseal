#!/usr/bin/env bun
// PR 注释生成（Semgrep 差距⑨——generate-pr-comment.ts）。
// 从 droidseal-report.json 生成 PR 评论 Markdown（门禁状态 + 发现摘要 + 报告路径）——
// 供 CI 平台（GitHub Actions 等）发布为 PR 评论。失败关闭：报告缺失字段容错。
//
// 用法：
//   bun scripts/generate-pr-comment.ts <droidseal-report.json> [output.md]
import { readFile, writeFile } from "node:fs/promises"

interface ReportJson {
  releaseDecision?: { status?: string }
  audit?: { findings?: Array<{ severity?: string; code?: string; title?: string }> }
  generatedAt?: string
}

const GATE_EMOJI: Record<string, string> = { pass: "✅", review: "⚠️", block: "🚫" }

function render(report: ReportJson): string {
  const gate = report.releaseDecision?.status ?? "unknown"
  const findings = report.audit?.findings ?? []
  const bySeverity = (severity: string): number => findings.filter((f) => f.severity === severity).length
  const top = findings
    .filter((f) => f.severity === "critical" || f.severity === "high")
    .slice(0, 10)
    .map((f) => `- **[${f.severity}]** \`${f.code}\` ${f.title}`)
    .join("\n")
  return [
    `## DroidSeal 安全审计 ${GATE_EMOJI[gate] ?? "ℹ️"}`,
    "",
    `**发布门禁：\`${gate}\`**`,
    "",
    `| 严重度 | 数量 |`,
    `|---|---|`,
    `| critical | ${bySeverity("critical")} |`,
    `| high | ${bySeverity("high")} |`,
    `| medium | ${bySeverity("medium")} |`,
    `| low | ${bySeverity("low")} |`,
    `| info | ${bySeverity("info")} |`,
    "",
    top ? `### 高风险发现（前 10）\n\n${top}` : "### 无 critical/high 发现 ✅",
    "",
    `生成时间：${report.generatedAt ?? "未知"}`,
  ].join("\n")
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: generate-pr-comment <droidseal-report.json> [output.md]")
  const output = argv[1] ?? "pr-comment.md"
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  await writeFile(output, render(report), "utf8")
  console.log(`已生成 PR 评论：${output}`)
}

main().catch((error) => {
  console.error(`PR 评论生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
