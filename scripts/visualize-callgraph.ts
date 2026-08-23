#!/usr/bin/env bun
// 调用图可视化（DroidStatx 差距②——visualize-callgraph.ts）。
// 从 APK/DEX 提取调用图（含接口分派）→ 输出 Mermaid flowchart（.mmd）——
// 供 GitHub/Markdown 渲染与人工核验。失败关闭。
//
// 用法：
//   bun scripts/visualize-callgraph.ts <app.apk|classes.dex> [output.mmd]
import { readFileSync } from "node:fs"
import { writeFile } from "node:fs/promises"
import { spawnSync } from "node:child_process"
import { extractCallGraph, expandInterfaceDispatch } from "../src/core/dex-callgraph.ts"

// Mermaid 节点 ID 转义（去特殊字符——保持可渲染）。
function nodeId(name: string): string {
  return `n${[...name].map((c) => (c.match(/[A-Za-z0-9_]/) ? c : "")).join("").slice(0, 40) || "x"}`
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const input = argv[0]
  if (!input) throw new Error("用法: visualize-callgraph <app.apk|classes.dex> [output.mmd]")
  const output = argv[1] ?? "callgraph.mmd"

  let bytes: Uint8Array
  if (input.toLowerCase().endsWith(".apk")) {
    const result = spawnSync("unzip", ["-p", input, "classes.dex"], { maxBuffer: 256 * 1024 * 1024 })
    if (result.status !== 0) throw new Error("提取 classes.dex 失败（需 unzip）")
    bytes = new Uint8Array(result.stdout)
  } else {
    bytes = new Uint8Array(readFileSync(input))
  }
  if (bytes.length === 0 || bytes[0] !== 0x64) throw new Error("不是有效的 DEX 文件")

  const graph = expandInterfaceDispatch(extractCallGraph(bytes), bytes)
  const lines: string[] = ["flowchart TD"]
  let edgeCount = 0
  for (const [caller, callees] of graph) {
    if (edgeCount >= 500) break
    for (const callee of callees) {
      if (edgeCount >= 500) break
      lines.push(`  ${nodeId(caller)}["${caller.replace(/"/g, "&quot;")}"] --> ${nodeId(callee)}["${callee.replace(/"/g, "&quot;")}"]`)
      edgeCount += 1
    }
  }
  await writeFile(output, lines.join("\n") + "\n", "utf8")
  console.log(`已生成调用图 Mermaid：${output}（${edgeCount} 条边——供 GitHub/Markdown 渲染与人工核验）`)
}

main().catch((error) => {
  console.error(`调用图可视化失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
