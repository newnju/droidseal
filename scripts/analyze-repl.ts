#!/usr/bin/env bun
// 交互式分析 REPL（Androguard 差距⑨——analyze-repl.ts）。
// 交互式查询 DEX 的类/方法/指令/XREF——基于类级对象模型、指令迭代器与 XREF 模块。
//
// 命令：
//   load <apk|dex>   加载 APK（自动提取 classes.dex）或直接 DEX
//   classes          列出类（前 50 个）
//   method <类.方法>  方法详情（指令数/前 8 条指令）
//   xref <目标>       查询「谁引用了 X」（方法）
//   help / exit
import { spawnSync } from "node:child_process"
import { readFileSync } from "node:fs"
import { createInterface } from "node:readline"
import { extractMethodCodes } from "../src/core/dex-instructions.ts"
import { buildClassModel, classMethods, methodInstructions } from "../src/core/dex-class-model.ts"
import { extractCallGraph, expandInterfaceDispatch } from "../src/core/dex-callgraph.ts"
import { buildXref, referencesOf } from "../src/core/xref.ts"

let bytes: Uint8Array | undefined
let model: ReturnType<typeof buildClassModel> = []
let xref: ReturnType<typeof buildXref> | undefined

function load(path: string): string {
  let dex: Uint8Array
  if (path.toLowerCase().endsWith(".apk")) {
    const result = spawnSync("unzip", ["-p", path, "classes.dex"], { maxBuffer: 256 * 1024 * 1024 })
    if (result.status !== 0) return "提取 classes.dex 失败（需 unzip）"
    dex = new Uint8Array(result.stdout)
  } else {
    dex = new Uint8Array(readFileSync(path))
  }
  if (dex.length === 0 || dex[0] !== 0x64) return "不是有效的 DEX 文件"
  bytes = dex
  const graph = expandInterfaceDispatch(extractCallGraph(dex), dex)
  xref = buildXref(graph, dex)
  model = buildClassModel(dex)
  const methodCount = extractMethodCodes(dex).length
  return `已加载：${model.length} 个类、${methodCount} 个方法、${xref.methods.size} 个方法被引用`
}

function handle(line: string): string {
  const parts = line.trim().split(/\s+/)
  const cmd = parts[0]?.toLowerCase()
  const arg = parts.slice(1).join(" ")
  switch (cmd) {
    case "load":
      if (!arg) return "用法: load <apk|dex>"
      return load(arg)
    case "classes":
      if (!model.length) return "未加载 DEX（先 load）"
      return model
        .slice(0, 50)
        .map((c) => `${c.className}（${c.methodCount} 方法）`)
        .join("\n")
    case "method": {
      if (!model.length) return "未加载 DEX（先 load）"
      const dot = arg.lastIndexOf(".")
      if (dot <= 0) return "用法: method <类.方法>"
      const methods = classMethods(model, arg.slice(0, dot))
      const method = methods.find((m) => m.name === arg.slice(dot + 1))
      if (!method) return "未找到该方法"
      const lines = method.instructions.slice(0, 8).map((i) => `  ${i.mnemonic}${i.operands ? " " + i.operands : ""}`)
      return `${arg}（${method.instructionCount} 条指令）\n${lines.join("\n")}`
    }
    case "xref": {
      if (!xref) return "未加载 DEX（先 load）"
      const refs = referencesOf(xref, arg)
      return refs.length > 0 ? `${arg} 被 ${refs.length} 处引用：${refs.slice(0, 5).join("、")}` : `${arg} 未被引用`
    }
    case "help":
      return "load <apk|dex> / classes / method <类.方法> / xref <目标> / exit"
    case "exit":
    case "quit":
      process.exit(0)
    default:
      return "未知命令（help 查看）"
  }
}

const rl = createInterface({ input: process.stdin, output: process.stdout })
console.log("DroidSeal 交互式分析 REPL（help 查看命令）")
const prompt = (): void => {
  rl.question("> ", (line) => {
    try {
      console.log(handle(line))
    } catch (error) {
      console.log(`错误：${error instanceof Error ? error.message : String(error)}`)
    }
    prompt()
  })
}
prompt()
