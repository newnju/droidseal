#!/usr/bin/env bun
// 加固建议 → 自动应用（②——apply-hardening-suggestions.ts）。
// 从 droidseal-report.json 的 hardeningSuggestions 生成可执行的加固执行命令清单——
// 一键应用指引（字符串加密/assets 加密/DEX 混淆/商业加固核验——源码接入形态）。失败关闭。
//
// 用法：
//   bun scripts/apply-hardening-suggestions.ts <droidseal-report.json> [output.md]
import { readFile, writeFile } from "node:fs/promises"

interface Suggestion {
  type: string
  action: string
  command: string
}

interface ReportJson {
  hardeningSuggestions?: Suggestion[]
  generatedAt?: string
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const reportPath = argv[0]
  if (!reportPath) throw new Error("用法: apply-hardening-suggestions <droidseal-report.json> [output.md]")
  const output = argv[1] ?? "hardening-plan.md"
  const report = JSON.parse(await readFile(reportPath, "utf8")) as ReportJson
  const suggestions = report.hardeningSuggestions ?? []
  if (suggestions.length === 0) {
    await writeFile(output, "# 加固执行计划\n\n未检测到敏感串类发现——无需加固建议。\n", "utf8")
    console.log(`已生成加固执行计划：${output}（无建议）`)
    return
  }

  const lines = [
    "# 加固执行计划（审计 → 加固自动衔接）",
    "",
    `基于审计发现的敏感串，以下加固动作按顺序执行（全部为源码接入形态——编译期生效——不事后改写未知 APK）：`,
    "",
    ...suggestions.map((s, index) => `## ${index + 1}. ${s.type}\n\n- 动作：${s.action}\n- 命令：\`${s.command}\`\n`),
    "## 验证",
    "",
    "应用加固后重新运行 DroidSeal 流水线，并用 `bun scripts/re-test.ts --before <上次报告> --auto` 复测闭环确认消除/新增/剩余。",
    "",
  ]
  await writeFile(output, lines.join("\n"), "utf8")
  console.log(`已生成加固执行计划：${output}（${suggestions.length} 项建议——含命令与验证指引）`)
}

main().catch((error) => {
  console.error(`加固执行计划生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
