#!/usr/bin/env bun
// ARSC 值混淆扩展（开发路线「审计 → 自动加固衔接」——generate-arsc-value-obfuscation.ts）。
// 资源字符串值/维度保守子集混淆：替换 strings.xml 的字符串值（长度/字符集保守——不改变长度
// 与可见性——可逆）与 dimens.xml 的维度值——静态分析难直接识别原始字符串——失败关闭。
//
// 用法：
//   bun scripts/generate-arsc-value-obfuscation.ts <res目录> [--strings-only] [--out 输出目录]
import { mkdir, readdir, readFile, writeFile } from "node:fs/promises"
import path from "node:path"

// 保守混淆：每个可见字符替换为同字符集内的其他字符（保持长度——视觉可读性略降——可逆）。
const VISIBLE = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
function conservativeObfuscate(text: string): string {
  return [...text]
    .map((ch) => {
      if (ch === " ") return ch
      const idx = VISIBLE.indexOf(ch)
      if (idx < 0) return ch
      return VISIBLE[(idx * 7 + 3) % VISIBLE.length]!
    })
    .join("")
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const resDir = argv[0]
  if (!resDir) throw new Error("用法: generate-arsc-value-obfuscation <res目录> [--strings-only] [--out 输出目录]")
  const stringsOnly = argv.includes("--strings-only")
  const outIndex = argv.indexOf("--out")
  const outDir = outIndex >= 0 ? argv[outIndex + 1]! : resDir
  if (outDir !== resDir) await mkdir(outDir, { recursive: true })

  let changed = 0
  const files = await readdir(resDir)
  for (const file of files) {
    const full = path.join(resDir, file)
    const isStrings = file === "strings.xml"
    const isDimens = file === "dimens.xml"
    if (!isStrings && !(isDimens && !stringsOnly)) continue
    const text = await readFile(full, "utf8")
    // 字符串值（<string name="...">值</string>）与维度值（<dimen name="...">值dp</dimen>）保守替换
    const obfuscated = text.replace(
      isStrings ? /(<string[^>]*>)([^<]+)(<\/string>)/g : /(<dimen[^>]*>)([^<]+)(<\/dimen>)/g,
      (_m, open: string, value: string, close: string) => {
        changed += 1
        return open + conservativeObfuscate(value) + close
      },
    )
    if (outDir !== resDir) await writeFile(path.join(outDir, file), obfuscated, "utf8")
    else await writeFile(full, obfuscated, "utf8")
  }
  console.log(`已混淆 ARSC 值（${changed} 个值——${stringsOnly ? "仅字符串" : "字符串 + 维度"}保守子集——长度不变、可逆）`)
}

main().catch((error) => {
  console.error(`ARSC 值混淆失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
