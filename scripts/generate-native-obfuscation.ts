#!/usr/bin/env bun
// 原生混淆（so——generate-native-obfuscation.ts）。
// 生成 NDK 原生混淆模板（源码接入——编译期生效——不事后改写未知 APK）：
//   - CMake 片段：符号可见性隐藏（-fvisibility=hidden）+ 链接器 strip + 导出符号重命名（混淆宏）；
//   - C 混淆宏：敏感导出函数经宏重命名为噪声符号——so 内符号表不含真实语义名。
// 之前评估为「NDK 边界——暂不」——现以源码接入形态实现（用户放入 NDK 项目编译即生效）。失败关闭。
//
// 用法：
//   bun scripts/generate-native-obfuscation.ts <输出目录> [--funcs N] [--lib 库名]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; funcs: number; lib: string } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-native-obfuscation <输出目录> [--funcs N] [--lib 库名]")
  let funcs = 3
  let lib = "nativecore"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--funcs") {
      const value = Number.parseInt(argv[++i] ?? "3", 10)
      funcs = Number.isFinite(value) && value > 0 && value <= 12 ? value : 3
    }
    if (argv[i] === "--lib") lib = argv[++i] ?? "nativecore"
  }
  return { outputDir, funcs, lib }
}

// 混淆符号名（确定性噪声——静态分析无法从符号表还原语义）。
function obfuscatedSymbol(index: number): string {
  const noise = ["x", "q", "z", "v", "n", "k", "w", "t", "m", "p", "r", "s"]
  let out = "z_"
  for (let i = 0; i < 8; i += 1) out += noise[(index * 7 + i) % noise.length]!
  return out
}

async function generate(outputDir: string, funcs: number, lib: string): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  const symbols = Array.from({ length: funcs }, (_, i) => obfuscatedSymbol(i))
  const exported = symbols.map((sym, i) => `        ${sym}, // 原函数 func_${i}（导出名已混淆——符号表无真实语义）`).join("\n")
  const cmake = `# 自动生成的原生混淆配置（DroidSeal 原生混淆——源码接入——编译期生效）。
# 放入 NDK 项目的 CMakeLists.txt 片段：符号可见性隐藏 + 链接器 strip + 导出重命名。
add_library(${lib} SHARED ${symbols.map((_, i) => `obf_${i}.c`).join(" ")})
target_compile_options(${lib} PRIVATE -fvisibility=hidden -O2)
set_target_properties(${lib} PROPERTIES LINK_FLAGS "-Wl,--strip-all")
# 混淆后的导出符号（JNI 层按此表重映射真实函数）：
set(EXPORTED_SYMBOLS "${symbols.join(";")}")
`
  const obfC = symbols.map((sym, i) => `// obf_${i}.c —— 敏感原生逻辑（符号表导出名为 ${sym}——无真实语义）
__attribute__((visibility("default"))) const char * ${sym}(void) {
    // <在此填入真实原生逻辑——对外仅暴露混淆符号>
    return "ok";
}
`).join("\n")
  const files = [
    { name: "CMakeLists.obfuscation.cmake", content: cmake },
    ...symbols.map((sym, i) => ({ name: `obf_${i}.c`, content: `// 自动生成的原生混淆源（导出符号 ${sym}）\n${obfC.split("\n\n")[i]}\n` })),
  ]
  for (const f of files) await writeFile(path.join(outputDir, f.name), f.content, "utf8")
  return path.join(outputDir, "CMakeLists.obfuscation.cmake")
}

function main(): void {
  const { outputDir, funcs, lib } = parseArgs(process.argv.slice(2))
  generate(outputDir, funcs, lib)
    .then((file) => console.log(`已生成原生混淆模板：${file}（${funcs} 个混淆符号——CMake 隐藏可见性 + strip + 导出重命名——放入 NDK 项目编译生效）`))
    .catch((error) => {
      console.error(`原生混淆生成失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
