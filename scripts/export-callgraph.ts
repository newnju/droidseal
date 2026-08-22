#!/usr/bin/env bun
// 调用图导出（剩余②）：提取 DEX 调用图并导出 JSON（调用方 → 被调 边集）。
//
// 用法：
//   bun scripts/export-callgraph.ts <input.dex> [output.json]      # 直接 DEX 文件
//   bun scripts/export-callgraph.ts --apk <app.apk> [output.json]  # APK（用 unzip 提取首个 classes.dex）
import { readFile, writeFile } from "node:fs/promises"
import { spawnSync } from "node:child_process"
import { extractCallGraph } from "../src/core/dex-callgraph.ts"

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const apkMode = argv[0] === "--apk"
  const input = apkMode ? argv[1] : argv[0]
  if (!input) throw new Error("用法: export-callgraph <input.dex> [output.json] 或 --apk <app.apk> [output.json]")
  const output = apkMode ? (argv[2] ?? "callgraph.json") : (argv[1] ?? "callgraph.json")

  let bytes: Uint8Array
  if (apkMode) {
    const result = spawnSync("unzip", ["-p", input, "classes.dex"], { maxBuffer: 256 * 1024 * 1024 })
    if (result.status !== 0) throw new Error("提取 classes.dex 失败（需 unzip）；可先手动解压后直接传 DEX 文件")
    bytes = new Uint8Array(result.stdout)
  } else {
    bytes = new Uint8Array(await readFile(input))
  }

  const graph = extractCallGraph(bytes)
  const edges = [...graph.entries()].map(([caller, called]) => ({ caller, called: [...called] }))
  const json = { nodes: graph.size, edges }
  await writeFile(output, JSON.stringify(json, null, 2), "utf8")
  console.log(`已导出调用图：${output}（${json.nodes} 个调用方方法，${edges.length} 条边）`)
}

main().catch((error) => {
  console.error(`调用图导出失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
