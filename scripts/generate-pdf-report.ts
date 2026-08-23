#!/usr/bin/env bun
// PDF 报告导出（APKHunt 差距③——generate-pdf-report.ts）。
// 从 droidseal-report.json 生成极简 PDF 1.4（门禁/发现统计/发现列表/MASTG 清单摘要）——
// 纯 TS 零依赖（ASCII 文本流——评审/交付场景）。失败关闭：报告缺失字段容错。
//
// 用法：
//   bun scripts/generate-pdf-report.ts <droidseal-report.json> [output.pdf]
import { readFile, writeFile } from "node:fs/promises"

interface FindingJson {
  severity?: string
  code?: string
  title?: string
}

interface ReportJson {
  product?: string
  generatedAt?: string
  releaseDecision?: { status?: string }
  audit?: { findings?: FindingJson[] }
  mastgChecklist?: { items?: Array<{ id: string; status: string; masvsLevel: string }> }
}

// 极简 PDF 1.4 生成（单页文本流——ASCII 内容）。
function buildPdf(lines: string[]): Buffer {
  const content = lines.map((line) => `BT /F1 10 Tf 40 ${720 - lines.indexOf(line) * 14} Td (${escapePdf(line)}) Tj ET`).join("\n")
  const objects = [
    "<< /Type /Catalog /Pages 2 0 R >>",
    "<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
    "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>",
    `<< /Length ${content.length} >>\nstream\n${content}\nendstream`,
    "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
  ]
  let pdf = "%PDF-1.4\n"
  const offsets: number[] = []
  for (let i = 1; i <= objects.length; i += 1) {
    offsets.push(pdf.length)
    pdf += `${i} 0 obj\n${objects[i - 1]}\nendobj\n`
  }
  const xref = pdf.length
  pdf += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`
  for (const offset of offsets) pdf += `${String(offset).padStart(10, "0")} 00000 n \n`
  pdf += `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xref}\n%%EOF`
  return Buffer.from(pdf, "ascii")
}

function escapePdf(text: string): string {
  return text.replace(/[()\\]/g, (c) => `\\${c}`)
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: generate-pdf-report <droidseal-report.json> [output.pdf]")
  const output = argv[1] ?? "droidseal-report.pdf"
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  const findings = report.audit?.findings ?? []
  const bySeverity = (severity: string): number => findings.filter((f) => f.severity === severity).length
  const checklist = report.mastgChecklist?.items ?? []

  const lines: string[] = [
    `${report.product ?? "DroidSeal"} - Release Security Report`,
    `Generated: ${report.generatedAt ?? "unknown"}`,
    `Gate: ${report.releaseDecision?.status ?? "unknown"}`,
    "",
    "Findings:",
    `  critical: ${bySeverity("critical")}  high: ${bySeverity("high")}  medium: ${bySeverity("medium")}  low: ${bySeverity("low")}`,
    ...findings.slice(0, 25).map((f) => `  [${f.severity ?? "info"}] ${f.code ?? "UNKNOWN"} - ${(f.title ?? "").slice(0, 60)}`),
    "",
    "MASTG Checklist (need review):",
    ...checklist.filter((i) => i.status === "需核验").map((i) => `  ${i.id} [${i.masvsLevel}] - ${i.status}`),
  ]
  await writeFile(output, buildPdf(lines))
  console.log(`已生成 PDF 报告：${output}（${findings.length} 条发现、${checklist.length} 项 MASTG 清单）`)
}

main().catch((error) => {
  console.error(`PDF 报告生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
