#!/usr/bin/env bun
// Dex2C 生成器（下一层③——generate-dex2c.ts）。
// 把一段简单逻辑（源码文本）转成 C 函数源码（NDK 编译——so 层执行——
// 静态分析只见 C 语义而非 Java/DEX 逻辑——关键逻辑转原生的源码接入形态）。
// 支持：赋值/二元运算（+ - * /）/数字常量/参数/return——方法级转 C。失败关闭。
//
// 用法：
//   bun scripts/generate-dex2c.ts <输出目录> [--func 函数名] [--lib 库名] [--logic "x = a + b * 2; return x"]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; func: string; lib: string; logic: string } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-dex2c <输出目录> [--func 函数名] [--lib 库名] [--logic \"逻辑源码\"]")
  let func = "protected_logic"
  let lib = "dex2c"
  let logic = "x = a + b * 2; return x"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--func") func = argv[++i] ?? "protected_logic"
    if (argv[i] === "--lib") lib = argv[++i] ?? "dex2c"
    if (argv[i] === "--logic") logic = argv[++i] ?? "x = a + b * 2; return x"
  }
  return { outputDir, func, lib, logic }
}

// 简单逻辑 → C 语句（方向①b：支持 if/for/while 块——复杂逻辑转 C——保持语义——方法级转 C）。
function logicToC(logic: string): string[] {
  const lines: string[] = []
  for (const statement of logic.split(";").map((s) => s.trim()).filter(Boolean)) {
    const ret = /^return\s+(.+)$/.exec(statement)
    if (ret) {
      lines.push(`    return (${ret[1]!.trim()});`)
      continue
    }
    const assign = /^([A-Za-z_]\w*)\s*=\s*(.+)$/.exec(statement)
    if (!assign) throw new Error(`无法解析语句：${statement}`)
    lines.push(`    ${assign[1]!} = (${assign[2]!.trim()});`)
  }
  return lines
}

// 方向①b：把含 if/for/while 的复杂逻辑原样转为 C 块（块保留花括号——语句逐行转 C）。
function logicBlockToC(logic: string): string[] {
  const lines: string[] = []
  let depth = 0
  for (const statement of logic.split(";")) {
    const trimmed = statement.trim()
    if (trimmed === "") continue
    // 行以「}」开头：先输出闭括号（缩进——depth 减一），再处理行其余部分（else/return/赋值）
    if (trimmed.startsWith("}")) {
      const rest = trimmed.slice(trimmed.indexOf("}") + 1).trim()
      depth = Math.max(0, depth - 1)
      lines.push(`${"    ".repeat(depth)}}`)
      if (rest === "") continue
      if (/^else\b/.test(rest)) {
        const elseRest = rest.replace(/^else\s*/, "")
        lines.push(`${"    ".repeat(depth)}else {`)
        depth += 1
        if (elseRest) {
          const assign = /^([A-Za-z_]\w*)\s*=\s*(.+)$/.exec(elseRest)
          if (assign) lines.push(`${"    ".repeat(depth)}${assign[1]!} = (${assign[2]!.trim()});`)
        }
        continue
      }
      const ret = /^return\s+(.+)$/.exec(rest)
      if (ret) {
        lines.push(`${"    ".repeat(depth)}return (${ret[1]!.trim()});`)
        continue
      }
      const assign = /^([A-Za-z_]\w*)\s*=\s*(.+)$/.exec(rest)
      if (!assign) throw new Error(`无法解析语句：${trimmed}`)
      lines.push(`${"    ".repeat(depth)}${assign[1]!} = (${assign[2]!.trim()});`)
      continue
    }
    // 处理块开始（花括号计数）
    const opens = (trimmed.match(/\{/g) ?? []).length
    const closes = (trimmed.match(/\}/g) ?? []).length
    if (/^(if|for|while)\b/.test(trimmed) || opens > 0) {
      const indent = "    ".repeat(depth)
      lines.push(`${indent}${trimmed}`)
      depth += opens - closes
      continue
    }
    const ret = /^return\s+(.+)$/.exec(trimmed)
    if (ret) {
      lines.push(`${"    ".repeat(depth)}return (${ret[1]!.trim()});`)
      continue
    }
    const assign = /^([A-Za-z_]\w*)\s*=\s*(.+)$/.exec(trimmed)
    if (!assign) throw new Error(`无法解析语句：${trimmed}`)
    lines.push(`${"    ".repeat(depth)}${assign[1]!} = (${assign[2]!.trim()});`)
  }
  return lines
}

async function generate(outputDir: string, func: string, lib: string, logic: string): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  // 方向①b：用 logicBlockToC（支持 if/for/while 控制流块——复杂逻辑转 C）
  const body = logicBlockToC(logic).join("\n")
  const header = `// 自动生成的 Dex2C（下一层③——简单逻辑转 C——NDK 编译——so 层执行——静态只见 C 语义）。
// 原逻辑：${logic}
// 把本文件放入 NDK 项目（CMake 添加 ${lib}.c + JNI 导出）——Java 层经 JNI 调用该函数。
#include <jni.h>
#include <stdint.h>

JNIEXPORT jint JNICALL
Java_com_example_dex2c_${lib}_${func}(JNIEnv *env, jobject thiz, jint a, jint b) {
    (void) env;
    (void) thiz;
    int32_t x = 0;
    int32_t y = 0;
    int32_t result = 0;
${body}
    return (jint) result;
}
`
  const cmake = `# Dex2C 原生编译（放入 NDK CMakeLists.txt——${lib}.c 编译进 so）
add_library(${lib} SHARED ${lib}.c)
target_compile_options(${lib} PRIVATE -fvisibility=hidden -O2)
`
  const cFile = path.join(outputDir, `${lib}.c`)
  await writeFile(cFile, header, "utf8")
  await writeFile(path.join(outputDir, "CMakeLists.dex2c.cmake"), cmake, "utf8")
  return cFile
}

function main(): void {
  const { outputDir, func, lib, logic } = parseArgs(process.argv.slice(2))
  generate(outputDir, func, lib, logic)
    .then((file) => console.log(`已生成 Dex2C 原生源：${file}（逻辑「${logic}」转 C——放入 NDK 项目编译——so 层执行——静态只见 C 语义）`))
    .catch((error) => {
      console.error(`Dex2C 生成失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
