#!/usr/bin/env bun
// DEX 方法/类级混淆受控子集——白名单映射生成器（长期路线 ①）。
// 为白名单内允许重命名的方法生成确定性短名映射与接入指南。
// 映射的落地（改写 DEX）必须先通过 docs/dex-method-obfuscation-plan.md 的
// 真机设备矩阵验证；本工具只生成计划，不改写任何文件之外的产物。
//
// 用法：
//   bun scripts/generate-method-obfuscation-plan.ts \
//     --method "com.example.auth.TokenManager#computeToken" \
//     --method "com.example.auth.TokenManager#refresh" \
//     --output plans/method-obfuscation
import { mkdir, readFile, writeFile } from "node:fs/promises"
import path from "node:path"

// 必须排除的类别：override/生命周期/原生/JNI/反射查找/注解处理相关命名。
// 命中任一标记的方法不会进入映射（保持原名，失败关闭）。
const FORBIDDEN_MARKERS = [
  "oncreate",
  "onstart",
  "onresume",
  "onpause",
  "onstop",
  "ondestroy",
  "onclick",
  "native",
  "registernatives",
  "getdeclared",
  "tostring",
  "equals",
  "hashcode",
  "init",
]

function shortName(index: number): string {
  let n = index
  let out = ""
  do {
    out = String.fromCharCode(97 + (n % 26)) + out
    n = Math.floor(n / 26) - 1
  } while (n >= 0)
  return out
}

interface CliArgs {
  methods: string[]
  outputDir: string
  fromAudit?: string
}

function parseArgs(argv: string[]): CliArgs {
  const args: CliArgs = { methods: [], outputDir: "" }
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i]!
    if (arg === "--method") {
      const method = argv[++i]!
      if (!method.includes("#")) throw new Error(`--method 需要 类名#方法名 形式，得到：${method}`)
      args.methods.push(method)
    } else if (arg === "--output") {
      args.outputDir = argv[++i]!
    } else if (arg === "--from-audit") {
      args.fromAudit = argv[++i]!
    }
  }
  if (args.outputDir === "") throw new Error("缺少 --output 输出目录")
  if (args.methods.length === 0 && !args.fromAudit) throw new Error("至少提供一个 --method 类名#方法名 或 --from-audit <报告json>")
  return args
}

// 从 droidseal-report.json 提取疑似使用反射/注解的类 → 建议整类保留(#*)。
// 仅清单级建议,命中 DEX 描述符(L...;)或类路径特征,排除 android.* 系统类。
async function collectFromAudit(auditPath: string): Promise<string[]> {
  const report = JSON.parse(await readFile(auditPath, "utf8")) as {
    audit?: { findings?: Array<{ code?: string; evidence?: string }> }
  }
  const classes = new Set<string>()
  for (const finding of report.audit?.findings ?? []) {
    const evidence = finding.evidence ?? ""
    for (const match of evidence.matchAll(/L([a-zA-Z0-9_/$]+);/g)) {
      classes.add(match[1]!.replaceAll("/", ".").replaceAll("$", "."))
    }
    for (const match of evidence.matchAll(/([a-z][a-z0-9_]*\.[a-zA-Z0-9_.]+)/g)) {
      const candidate = match[1]!
      if (candidate.includes(".") && !candidate.startsWith("com.android") && !candidate.startsWith("android.")) {
        const base = candidate.split(/[.#]/).slice(0, -1).join(".")
        if (base.includes(".")) classes.add(base)
      }
    }
  }
  return [...classes].sort().map((c) => `${c}#*`)
}

function buildMapping(methods: string[]): { mapping: Map<string, string>; excluded: string[] } {
  const eligible = methods.filter(
    (m) => !FORBIDDEN_MARKERS.some((marker) => m.toLowerCase().includes(marker)),
  )
  const excluded = methods.filter((m) => !eligible.includes(m))
  const mapping = new Map<string, string>()
  const used = new Set<string>()
  let counter = 0
  for (const method of eligible) {
    let candidate: string
    do {
      candidate = shortName(counter)
      counter += 1
    } while (used.has(candidate))
    used.add(candidate)
    mapping.set(method, candidate)
  }
  return { mapping, excluded }
}

function mappingText(mapping: Map<string, string>): string {
  return [...mapping.entries()]
    .map(([method, short]) => `${method} -> ${short}`)
    .join("\n")
}

function guideText(excluded: string[]): string {
  const excludedNote =
    excluded.length > 0
      ? `\n已排除（命中禁区标记，保持原名）：\n${excluded.map((m) => `- ${m}`).join("\n")}`
      : "\n本次白名单方法均可重命名（未命中禁区标记）。"
  return `# DEX 方法混淆映射接入指南

本计划由 DroidSeal 生成（长期路线 ①，受控子集）。映射落地（改写 DEX）前必须：
1. 按 docs/dex-method-obfuscation-plan.md 的验证矩阵在真机执行（启动链路、
   反射/注解、动态加载、JNI 注册、R8 叠加）；
2. 白名单之外的类/方法保持原名（失败关闭）；
3. 本能力只提高静态阅读门槛，不等于源码保密。
${excludedNote}
`
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2))
  if (args.fromAudit) {
    const suggested = await collectFromAudit(args.fromAudit)
    for (const suggestion of suggested) {
      if (!args.methods.includes(suggestion)) args.methods.push(suggestion)
    }
    if (suggested.length > 0) console.log(`从报告自动提取 ${suggested.length} 个疑似反射/注解类建议（#* 整类保留）`)
  }
  const { mapping, excluded } = buildMapping(args.methods)
  await mkdir(args.outputDir, { recursive: true })
  const mapText = mappingText(mapping)
  await writeFile(path.join(args.outputDir, "method-obfuscation.map"), mapText + "\n", "utf8")
  if (process.argv.includes("--verify")) {
    // 映射文件格式校验:每行 "原方法 -> 短名" 两段且非空(失败关闭)
    const lines = mapText.split(/\r?\n/).filter((line) => line.trim() !== "")
    for (const line of lines) {
      const parts = line.split(/\s*->\s*/)
      if (parts.length !== 2 || parts[0]!.trim() === "" || parts[1]!.trim() === "") {
        throw new Error(`映射格式异常：${line}`)
      }
    }
    console.log(`映射校验通过：${lines.length} 条（类名#方法名 -> 短名#方法名）`)
  }
  if (mapping.size === 0) throw new Error("白名单方法全部命中禁区标记；没有可重命名的方法，已失败关闭。")

  await mkdir(args.outputDir, { recursive: true })
  await writeFile(path.join(args.outputDir, "method-obfuscation.map"), mappingText(mapping) + "\n", "utf8")
  await writeFile(path.join(args.outputDir, "INTEGRATION.md"), guideText(excluded), "utf8")

  console.log(`已生成：${args.outputDir}/method-obfuscation.map、${args.outputDir}/INTEGRATION.md`)
  console.log(`映射 ${mapping.size} 个方法；排除 ${excluded.length} 个（禁区标记）`)
  for (const [method, short] of mapping) console.log(`  ${method} -> ${short}`)
}

main().catch((error) => {
  console.error(`生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
