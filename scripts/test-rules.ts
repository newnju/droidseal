#!/usr/bin/env bun
// 规则测试框架（Semgrep 差距⑧——test-rules.ts）。
// 自定义规则的正/负用例验证：每个 positive 用例应被至少一条规则命中；
// 每个 negative 用例不应被任何规则命中。失败关闭：任一项不符 → 退出码 1（CI 友好）。
//
// 用法：
//   bun scripts/test-rules.ts <rules.json> [test-cases.json]
// 规则文件：与 customRulesFile 同格式（JSON 数组）。
// 用例文件：{ "positive": ["应命中的样本"], "negative": ["不应命中的样本"] }
import { readFile } from "node:fs/promises"
import { parseCustomRules, matchCustomRules } from "../src/core/custom-rules.ts"

interface TestCases {
  positive?: string[]
  negative?: string[]
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const rulesFile = argv[0]
  const casesFile = argv[1]
  if (!rulesFile || !casesFile) throw new Error("用法: test-rules <rules.json> <test-cases.json>")
  const rules = parseCustomRules(await readFile(rulesFile, "utf8"))
  const cases = JSON.parse(await readFile(casesFile, "utf8")) as TestCases
  const positives = cases.positive ?? []
  const negatives = cases.negative ?? []

  let failures = 0
  console.log(`规则 ${rules.length} 条、正用例 ${positives.length}、负用例 ${negatives.length}`)
  for (const [index, sample] of positives.entries()) {
    const hits = matchCustomRules(rules, [sample], "source")
    if (hits.length === 0) {
      console.log(`✗ 正用例 #${index + 1} 未命中：${sample.slice(0, 60)}`)
      failures += 1
    }
  }
  for (const [index, sample] of negatives.entries()) {
    const hits = matchCustomRules(rules, [sample], "source")
    if (hits.length > 0) {
      console.log(`✗ 负用例 #${index + 1} 误命中（${hits[0]!.code}）：${sample.slice(0, 60)}`)
      failures += 1
    }
  }
  if (failures === 0) {
    console.log("=== 规则测试全部通过 ===")
  } else {
    console.log(`=== ${failures} 项失败（退出码 1） ===`)
    process.exitCode = 1
  }
}

main().catch((error) => {
  console.error(`规则测试失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
