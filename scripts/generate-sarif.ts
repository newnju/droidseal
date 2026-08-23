#!/usr/bin/env bun
// SARIF 报告导出（Semgrep 差距①——generate-sarif.ts）。
// 从 droidseal-report.json 生成 SARIF 2.1.0 JSON——CI 生态标准格式（GitHub Code Scanning 等可导入）。
// 失败关闭：报告缺失字段容错。
//
// 用法：
//   bun scripts/generate-sarif.ts <droidseal-report.json> [output.sarif]
import { readFile, writeFile } from "node:fs/promises"

interface Finding {
  severity?: string
  code?: string
  title?: string
  detail?: string
  evidence?: string
}

interface ReportJson {
  product?: string
  generatedAt?: string
  audit?: { findings?: Finding[] }
}

const SEVERITY_LEVEL: Record<string, "error" | "warning" | "note"> = {
  critical: "error",
  high: "error",
  medium: "warning",
  low: "note",
  info: "note",
}

function render(report: ReportJson): string {
  const findings = report.audit?.findings ?? []
  const ruleIds = [...new Set(findings.map((f) => f.code ?? "UNKNOWN").filter(Boolean))]
  const rules = ruleIds.map((id) => {
    const first = findings.find((f) => f.code === id)
    return {
      id,
      shortDescription: { text: first?.title ?? id },
      defaultConfiguration: { level: SEVERITY_LEVEL[first?.severity ?? "info"] ?? "note" },
    }
  })
  const results = findings.map((f) => ({
    ruleId: f.code ?? "UNKNOWN",
    level: SEVERITY_LEVEL[f.severity ?? "info"] ?? "note",
    message: { text: f.title ?? "" },
    ...(f.detail ? { properties: { detail: f.detail } } : {}),
    ...(f.evidence
      ? { locations: [{ physicalLocation: { artifactLocation: { uri: "source" }, region: { snippet: { text: f.evidence.slice(0, 80) } } } }] }
      : {}),
  }))
  return JSON.stringify(
    {
      version: "2.1.0",
      $schema: "https://json.schemastore.org/sarif-2.1.0.json",
      runs: [
        {
          tool: {
            driver: {
              name: report.product ?? "DroidSeal",
              informationUri: "https://github.com/your-org/droidseal",
              version: "1.0.1",
              rules,
            },
          },
          results,
          ...(report.generatedAt ? { invocations: [{ executionSuccessful: true, endTimeUtc: report.generatedAt }] } : {}),
        },
      ],
    },
    null,
    2,
  )
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: generate-sarif <droidseal-report.json> [output.sarif]")
  const output = argv[1] ?? "droidseal.sarif"
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  await writeFile(output, render(report), "utf8")
  console.log(`已生成 SARIF：${output}（${report.audit?.findings?.length ?? 0} 条结果）`)
}

main().catch((error) => {
  console.error(`SARIF 生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
