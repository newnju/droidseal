#!/usr/bin/env bun
// 生成 DroidBench 官方语义 map(droidbench-map.json)。
// Ground truth 来源:DroidBench 官方 README 的逐 case 行为描述
//   (secure-software-engineering/DroidBench)。数据溯源见 benchmark/paper-notes-droidbench.md。
// 判定规则(droidbench-eval.ts 头注同源):
//   负例:描述含 "no data" / "not leak" / "only the untainted" / "only constant" /
//         "never leak" / "no leak"(README 原文措辞,大小写不敏感)。
//   正例:其余有描述的用例(套件为 leak 导向,默认视为泄漏用例)。
// 用法: bun scripts/generate-droidbench-map.ts <DroidBench-README.md> [--out <map.json>]
// 输出: { positive: [{name, desc}], negative: [{name, desc}], unsupported: [...] }
import { readFile, writeFile } from "node:fs/promises"

const args = process.argv.slice(2)
const readme = args[0]
const outIdx = args.indexOf("--out")
const outFile = outIdx >= 0 ? args[outIdx + 1]! : "benchmark/droidbench-map.json"
if (!readme) {
  console.error("用法: bun scripts/generate-droidbench-map.ts <DroidBench-README.md> [--out benchmark/droidbench-map.json]")
  process.exit(2)
}

const raw = await readFile(readme, "utf8")

// ── 解析 README:每个用例一条,名字 + 处理动作用的句子 ──────────────────────────
// README 中用例行形态不一致,统一按 "名称: 描述" 处理;名称限定为
// [A-Za-z0-9_]+ 但至少包含一个字母且总长 >= 4,过滤掉普通句子片段。
const NEGATION_PHRASES = [
  "no data",
  "not leak",
  "only the untainted",
  "only constant",
  "never leak",
  "no leak",
]

interface Entry { name: string; desc: string }
const positive: Entry[] = []
const negative: Entry[] = []
const unsupported: string[] = []

// 逐行扫描,匹配 "**Name**: desc" 与 "Name: desc" 两种写法
const lines = raw.split(/\r?\n/)
const seen = new Set<string>()
for (const line of lines) {
  const m = line.match(/^\s*(?:[-*]\s*)?\*{0,2}([A-Za-z][A-Za-z0-9_]{2,})\*{0,2}\s*[:：]\s*(.+)$/)
  if (!m) continue
  const name = m[1]!
  const desc = m[2]!.trim()
  if (seen.has(name)) continue
  if (seen.has(name.toLowerCase())) continue
  seen.add(name.toLowerCase())
  const lower = desc.toLowerCase()
  if (NEGATION_PHRASES.some(p => lower.includes(p))) negative.push({ name, desc })
  else positive.push({ name, desc })
}

// 说明:不做名字前缀过滤——README 的 "Name: desc" 结构可信,前缀白名单曾误杀
//   File1/SinkInNativeCode 等正规用例(2026-10-18 实测),故直接保留全部解析结果。
const positiveFinal = positive
const negativeFinal = negative

const map = {
  generatedFrom: readme.replace(/\\/g, "/"),
  generatedAt: new Date().toISOString(),
  algorithm: "README case descriptions; negative iff description contains documented negation phrases",
  positive: positiveFinal,
  negative: negativeFinal,
  unsupported,
}
console.log(`解析结果: ${positiveFinal.length} 正例 / ${negativeFinal.length} 负例`)
if (positiveFinal.length < 20) {
  console.error("正例过少 —— README 结构与解析规则不匹配,中止写入,请人工核对规则")
  console.error("前 10 个样本:", positive.slice(0, 10).map(e => e.name))
  process.exit(1)
}
await writeFile(outFile, JSON.stringify(map, null, 2))
console.log(`written: ${outFile}`)
