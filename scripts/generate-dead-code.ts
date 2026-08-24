#!/usr/bin/env bun
// 死代码注入（加固深化——generate-dead-code.ts）。
// 生成无害的死代码桩（无效分支/冗余方法/伪逻辑——源码接入——编译进项目后提高逆向噪声，
// 静态分析输出更噪、更耗逆向时间）。死代码不改变应用行为（opaque predicates 恒假、
// 冗余方法无调用者）。失败关闭。
//
// 用法：
//   bun scripts/generate-dead-code.ts <输出目录> [--count N] [--class 类名]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; count: number; className: string } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-dead-code <输出目录> [--count N] [--class 类名]")
  let count = 3
  let className = "ObfuscationDecoy"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--count") {
      const value = Number.parseInt(argv[++i] ?? "3", 10)
      count = Number.isFinite(value) && value > 0 && value <= 20 ? value : 3
    }
    if (argv[i] === "--class") className = argv[++i] ?? "ObfuscationDecoy"
  }
  return { outputDir, count, className }
}

// 生成一个死代码桩方法（无效分支 + 伪逻辑——恒假条件——无行为影响）。
function decoyMethod(index: number): string {
  const checks = [
    `if ((System.nanoTime() & 1) == 2) { throw new IllegalStateException("impossible"); }`,
    `if (new java.util.Random(1).nextBoolean() && 1 == 2) { return null; }`,
    `while (false) { System.out.println("unreachable"); }`,
  ]
  return `
    /** 逆向噪声桩 #${index}（死代码——不影响行为——勿调用） */
    private static String decoy${index}() {
        ${checks[index % checks.length]!}
        final int fake = (int) (Math.random() * 0) + 7;
        return "decoy-" + fake;
    }`
}

// 生成一个死代码类文件（Kotlin/Java 风格——Android 项目可编译——失败关闭）。
async function generate(outputDir: string, count: number, className: string): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  const methods = Array.from({ length: count }, (_, i) => decoyMethod(i)).join("\n")
  const content = `// 自动生成的逆向噪声死代码桩（DroidSeal 死代码注入——源码接入——不改变应用行为）。
// 该类的方法均无调用者、分支恒假——仅提高静态分析噪声。可整体删除（不影响应用）。
package com.example.decoy;

/** 逆向噪声死代码（勿调用——无业务作用） */
public final class ${className} {
${methods}

    /** 伪入口（恒假——仅静态分析可见） */
    public static String entry() {
        if (1 == 2) {
            return decoy0();
        }
        return "";
    }
}
`
  const file = path.join(outputDir, `${className}.java`)
  await writeFile(file, content, "utf8")
  return file
}

function main(): void {
  const { outputDir, count, className } = parseArgs(process.argv.slice(2))
  generate(outputDir, count, className)
    .then((file) => console.log(`已生成死代码桩：${file}（${count} 个冗余方法——放入项目 src 后编译——提高逆向噪声）`))
    .catch((error) => {
      console.error(`死代码注入失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
