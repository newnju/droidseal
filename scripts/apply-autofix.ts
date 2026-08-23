#!/usr/bin/env bun
// autofix 自动修复应用（Semgrep 差距⑥——apply-autofix.ts）。
// 对项目源码应用安全的文本替换修复（修改前备份为 .autofix.bak）——失败关闭：不匹配不替换。
//
// 用法：
//   bun scripts/apply-autofix.ts <项目目录>
import { applyAutofixToProject } from "../src/core/autofix.ts"

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const project = argv[0]
  if (!project) throw new Error("用法: apply-autofix <项目目录>")
  const result = await applyAutofixToProject(project)
  console.log(`autofix 完成：${result.filesChanged} 个文件变更、${result.replacements} 处替换（备份为 .autofix.bak）`)
  for (const file of result.unchanged) console.log(`- 未变更：${file}`)
}

main().catch((error) => {
  console.error(`autofix 失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
