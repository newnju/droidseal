#!/usr/bin/env bun
// 反编译导出工具（MobSF 剩余缺口——源码浏览/反编译的人工核验支撑）。
// 检测 jadx/apktool 可用性并导出反编译产物；工具不可用时给出安装建议（失败关闭——不静默）。
//
// 用法：
//   bun scripts/export-decompiled.ts <app.apk> [--output <目录>] [--tool jadx|apktool]
import { spawnSync } from "node:child_process"
import path from "node:path"
import { mkdir } from "node:fs/promises"

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const apk = argv[0]
  if (!apk) throw new Error("用法: export-decompiled <app.apk> [--output <目录>] [--tool jadx|apktool]")
  let output = "decompiled"
  let tool = "jadx"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--output") output = argv[++i]!
    else if (argv[i] === "--tool") tool = argv[++i]!
  }

  const check = spawnSync(tool, ["--version"], { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] })
  if (check.status !== 0) {
    const install = tool === "jadx" ? "brew install jadx（macOS）或从 https://github.com/skylot/jadx 下载" : "apt install apktool 或从 https://github.com/iBotPeaches/Apktool 下载"
    console.error(`未检测到 ${tool}。安装后重试：${install}`)
    console.error(`或手动执行：${tool} -d <输出目录> ${apk}`)
    process.exitCode = 1
    return
  }

  await mkdir(output, { recursive: true })
  const args = tool === "jadx" ? ["-d", output, apk] : ["d", apk, "-o", output]
  console.log(`使用 ${tool} 反编译 ${apk} → ${output} ...`)
  const result = spawnSync(tool, args, { encoding: "utf8", stdio: ["inherit", "pipe", "pipe"] })
  if (result.status !== 0) {
    console.error(`反编译失败（退出码 ${result.status}）：${((result.stderr ?? result.stdout) ?? "").slice(0, 400)}`)
    process.exitCode = 1
    return
  }
  console.log(`反编译完成：${output}（建议配合报告「反编译核验建议」节逐项核验复杂发现）`)
}

main().catch((error) => {
  console.error(`反编译导出失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
