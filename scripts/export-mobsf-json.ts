#!/usr/bin/env bun
// MobSF 生态衔接导出（mobsfscan 差距③——export-mobsf-json.ts）。
// 从 droidseal-report.json 生成 MobSF 风格扫描结果 JSON（应用信息/严重度统计/发现列表）——
// 供 MobSF 平台/生态联动（导入或对照）。失败关闭：报告缺失字段容错。
//
// 用法：
//   bun scripts/export-mobsf-json.ts <droidseal-report.json> [output.json]
import { readFile, writeFile } from "node:fs/promises"

interface FindingJson {
  severity?: string
  code?: string
  title?: string
  detail?: string
  evidence?: string
}

interface ReportJson {
  product?: string
  generatedAt?: string
  releaseDecision?: { status?: string }
  apkMetadata?: { packageName?: string; versionName?: string }
  audit?: { findings?: FindingJson[] }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: export-mobsf-json <droidseal-report.json> [output.json]")
  const output = argv[1] ?? "mobsf-results.json"
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  const findings = report.audit?.findings ?? []
  const bySeverity = (severity: string): number => findings.filter((f) => f.severity === severity).length

  const mobsfJson = {
    app_name: report.apkMetadata?.packageName ?? report.product ?? "DroidSeal",
    package_name: report.apkMetadata?.packageName ?? "",
    version: report.apkMetadata?.versionName ?? "",
    source: "DroidSeal",
    generated_at: report.generatedAt ?? "",
    gate: report.releaseDecision?.status ?? "unknown",
    severity_counts: {
      critical: bySeverity("critical"),
      high: bySeverity("high"),
      medium: bySeverity("medium"),
      low: bySeverity("low"),
      info: bySeverity("info"),
    },
    findings: findings.map((f) => ({
      rule_id: f.code ?? "UNKNOWN",
      title: f.title ?? "",
      severity: f.severity ?? "info",
      description: f.detail ?? "",
      evidence: f.evidence ?? "",
    })),
  }
  await writeFile(output, JSON.stringify(mobsfJson, null, 2), "utf8")
  console.log(`已导出 MobSF 兼容 JSON：${output}（${findings.length} 条发现——供 MobSF 平台联动）`)
}

main().catch((error) => {
  console.error(`MobSF JSON 导出失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
