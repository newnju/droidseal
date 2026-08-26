#!/usr/bin/env bun
// DEX 方法混淆设备验证清单生成器（工具）。
// 生成可勾选的真机验证清单，供方法混淆受控子集接入主线前的设备矩阵回归使用。
//
// 用法：
//   bun scripts/generate-device-checklist.ts --output device-checklist.md
import { writeFile } from "node:fs/promises"
import path from "node:path"

const CHECKLIST: Array<{ item: string; pass: string }> = [
  { item: "冷启动 + 主 Activity 生命周期（含旋转/多窗口）", pass: "" },
  { item: "Service / BroadcastReceiver / AIDL 绑定", pass: "" },
  { item: "反射/注解处理（如 Room / Retrofit / 协程）全链路", pass: "" },
  { item: "动态加载（DexClassLoader）与插件化", pass: "" },
  { item: "JNI RegisterNatives 注册的方法不重命名（白名单排除）", pass: "" },
  { item: "与 R8/ProGuard 混淆叠加后的稳定性", pass: "" },
  { item: "adb shell 下无崩溃 / ANR / ClassNotFoundException", pass: "" },
]

function render(): string {
  const lines = [
    "# DEX 方法混淆设备验证清单",
    "",
    "来源：DEX 方法混淆受控子集的验证矩阵。方法混淆接入主线前，请在真机设备矩阵逐项回归。",
    "",
    "| # | 验证项 | 机型/Android 版本 | 结果（通过/失败/备注） |",
    "|---|--------|------------------|------------------------|",
  ]
  CHECKLIST.forEach((entry, index) => {
    lines.push(`| ${index + 1} | ${entry.item} | | |`)
  })
  lines.push("", "## 记录", "", "- 设备：", "- Android 版本：", "- 测试日期：", "- 结论：", "")
  return lines.join("\n")
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  let output = "device-checklist.md"
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === "--output") output = argv[++i]!
  }
  await writeFile(path.resolve(output), render(), "utf8")
  console.log(`已生成设备验证清单：${output}`)
}

main().catch((error) => {
  console.error(`生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
