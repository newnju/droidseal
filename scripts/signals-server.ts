#!/usr/bin/env bun
// 服务端协作上报协议（开发路线「运行时防护扩展」——signals-server.ts）。
// 解析 stub 的 signalsToJson 上报信号（设备侧只报告不阻断——服务端决策）：
// 输入一个 signals JSON（debuggable/tampered/frida/xposed/emulator/vpn/proxy/clock 等），
// 输出服务端风险决策（高/中/低 + 建议动作——仍只报告、不远程阻断）——失败关闭。
//
// 用法：
//   bun scripts/signals-server.ts <signals.json> [--json 输出.json]
import { readFile, writeFile } from "node:fs/promises"

interface Signals {
  debuggable?: boolean
  tampered?: string[] | boolean
  frida?: boolean
  xposed?: boolean
  emulator?: boolean
  vpn?: boolean
  proxy?: boolean
  clockSkew?: boolean
  ptraceTraced?: boolean
  [key: string]: unknown
}

function decide(signals: Signals): { level: "high" | "medium" | "low"; reasons: string[] } {
  const reasons: string[] = []
  let level: "high" | "medium" | "low" = "low"
  if (signals.debuggable) {
    level = "high"
    reasons.push("可调试（debuggable=true）——发布构建不应可调试")
  }
  if (signals.tampered && (Array.isArray(signals.tampered) ? signals.tampered.length > 0 : signals.tampered)) {
    level = "high"
    reasons.push("完整性校验失败——文件被篡改")
  }
  if (signals.frida) {
    level = "high"
    reasons.push("检测到 Frida 注入")
  }
  if (signals.xposed) {
    level = "high"
    reasons.push("检测到 Xposed 框架")
  }
  if (signals.ptraceTraced) {
    level = "high"
    reasons.push("检测到 ptrace 跟踪")
  }
  if (signals.emulator) {
    if (level === "low") level = "medium"
    reasons.push("模拟器特征")
  }
  if (signals.clockSkew) {
    if (level === "low") level = "medium"
    reasons.push("时钟异常（时间篡改）")
  }
  if (signals.vpn) reasons.push("VPN 连接")
  if (signals.proxy) reasons.push("代理连接")
  return { level, reasons }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const signalsPath = argv[0]
  if (!signalsPath) throw new Error("用法: signals-server <signals.json> [--json 输出.json]")
  const signals = JSON.parse(await readFile(signalsPath, "utf8")) as Signals
  const decision = decide(signals)
  console.log(`== 服务端信号决策 ==\n风险级别：${decision.level.toUpperCase()}`)
  if (decision.reasons.length === 0) console.log("  无高风险信号——运行环境正常（只报告、不阻断）")
  for (const r of decision.reasons) console.log(`  - ${r}`)
  const jsonIndex = argv.indexOf("--json")
  if (jsonIndex >= 0) {
    await writeFile(argv[jsonIndex + 1]!, JSON.stringify({ signals, decision }, null, 2), "utf8")
    console.log(`已输出 JSON：${argv[jsonIndex + 1]}`)
  }
}

main().catch((error) => {
  console.error(`信号解析失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
