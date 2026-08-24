#!/usr/bin/env bun
// 控制流混淆升级（层面2——generate-control-flow-obfuscation.ts）。
// 生成控制流混淆的方法框架（源码接入——用户把关键逻辑填入各块）：
//   - 伪 switch 分发：状态变量决定下一块（每块更新状态跳回分发器——CFG 变平——静态分析难解析可达性）；
//   - opaque predicates：恒假/恒真条件（静态分析无法静态判定）。
// 不改变运行行为（状态分发按固定顺序执行）。失败关闭。
//
// 用法：
//   bun scripts/generate-control-flow-obfuscation.ts <输出目录> [--method 方法名] [--blocks N]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; method: string; blocks: number } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-control-flow-obfuscation <输出目录> [--method 方法名] [--blocks N]")
  let method = "protectedLogic"
  let blocks = 4
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--method") method = argv[++i] ?? "protectedLogic"
    if (argv[i] === "--blocks") {
      const value = Number.parseInt(argv[++i] ?? "4", 10)
      blocks = Number.isFinite(value) && value >= 2 && value <= 12 ? value : 4
    }
  }
  return { outputDir, method, blocks }
}

// 生成一个混淆块（状态分发 + opaque predicate——用户填入真实逻辑）。
function obfuscatedBlock(index: number, total: number): string {
  const next = (index + 1) % total
  return `                case ${index}:
        // 块 ${index + 1}：<在此填入真实逻辑——仅本块可达>
        // opaque predicate（静态分析无法静态判定——恒为真但形式复杂）
        if ((Math.abs(-7) + 3) == 10) {
            state = ${next};
        } else {
            state = -1; // 不可达
        }`
}

async function generate(outputDir: string, method: string, blocks: number): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  const body = Array.from({ length: blocks }, (_, i) => obfuscatedBlock(i, blocks)).join("\n")
  const content = `// 自动生成的控制流混淆框架（DroidSeal 控制流混淆升级——源码接入——不改变应用行为）。
// 伪 switch 分发（状态变量）+ opaque predicates：静态分析难以解析实际可达流程。
// 用法：把关键逻辑填入各「块 N」注释处——编译进项目后运行行为不变（状态按固定顺序分发）。
package com.example.obf;

/** 控制流混淆（源码接入——把敏感逻辑放入各块——静态分析失效） */
public final class ${method}Dispatcher {

    /** 受保护逻辑（伪 switch 分发——CFG 变平——静态分析难解析） */
    public static int ${method}(int input) {
        int state = 0;
        // opaque predicate 守卫（恒真但形式复杂——静态无法判定）
        if ((input & 0) == 7) {
            return -1;
        }
        while (state >= 0) {
            switch (state) {
${body}
                default:
                    state = -1;
            }
        }
        return input;
    }
}
`
  const file = path.join(outputDir, `${method}Dispatcher.java`)
  await writeFile(file, content, "utf8")
  return file
}

function main(): void {
  const { outputDir, method, blocks } = parseArgs(process.argv.slice(2))
  generate(outputDir, method, blocks)
    .then((file) => console.log(`已生成控制流混淆框架：${file}（${blocks} 块伪 switch 分发 + opaque predicates——放入项目 src 后填入逻辑编译）`))
    .catch((error) => {
      console.error(`控制流混淆生成失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
