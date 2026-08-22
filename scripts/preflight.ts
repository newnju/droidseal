#!/usr/bin/env bun
// 发布预检（中期路线：构建期/发布工程化）——一键跑三项发布门禁：
//   type-check（tsc --noEmit）、test（全量测试）、release-check（发布产物与依赖策略）。
// 全部通过才适合继续发布流程（版本号同步、打 tag、npm publish、twine 等）。
//
// 用法：
//   bun scripts/preflight.ts
import { spawnSync } from "node:child_process"

const GATES: Array<{ name: string; command: string; args: string[] }> = [
  { name: "type-check", command: "bun", args: ["run", "check"] },
  { name: "test", command: "bun", args: ["test", "--timeout", "30000"] },
  { name: "release-check", command: "bun", args: ["run", "release:check"] },
  { name: "data-tables", command: "bun", args: ["scripts/known-vuln-check.ts"] },
]

function main(): void {
  const jsonOutput = process.argv.includes("--json")
  const results: Array<{ name: string; passed: boolean }> = []
  let failed = 0
  for (const gate of GATES) {
    if (!jsonOutput) process.stdout.write(`▶ ${gate.name} ... `)
    const result = spawnSync(gate.command, gate.args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] })
    const passed = result.status === 0
    results.push({ name: gate.name, passed })
    if (!passed) failed += 1
    if (jsonOutput) continue
    console.log(passed ? "通过" : "失败")
    if (!passed) {
      const tail = ((result.stderr ?? result.stdout) ?? "").split(/\r?\n/).slice(-6).join("\n")
      if (tail.trim()) console.log(tail)
    }
  }
  if (jsonOutput) {
    console.log(JSON.stringify({ gates: results, passed: failed === 0, failedCount: failed }, null, 2))
  } else if (failed > 0) {
    console.error(`\n发布预检未通过：${failed}/${GATES.length} 项失败。请先修复再继续发布流程。`)
    process.exitCode = 1
  } else {
    console.log(`\n发布预检全部通过（${GATES.length}/${GATES.length}）。可以继续发布流程。`)
  }
}

try {
  main()
} catch (error) {
  console.error(`预检失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
}
