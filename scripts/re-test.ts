#!/usr/bin/env bun
// 修复包复测闭环(开发路线——加固效果闭环):修复后重跑流水线,对比 findings 是否消除。
// 与 test-runner 共用运行方式;提供 --before <修复前报告.json> 时输出 消除/新增/剩余 对比。
//
// 用法:
//   bun scripts/re-test.ts <apk|project> <输入路径> <skip|existing> [keystore] [alias] \
//     [--before droidseal-report.json] [--web] [--arsc]
import { Pipeline } from "../src/core/pipeline.ts"
import type { PipelineConfig, StepId } from "../src/core/types.ts"
import { readFile, stat } from "node:fs/promises"
import path from "node:path"

const STEP_IDS: StepId[] = [
  "doctor",
  "prepare",
  "keystore",
  "source-audit",
  "build",
  "apk-audit",
  "protect",
  "harden",
  "web-assets",
  "arsc-obfuscate",
  "align",
  "sign",
  "verify",
  "report",
]

async function findLatestReport(outputDir: string): Promise<string | undefined> {
  const runs = await stat(outputDir).then(() => undefined).catch(() => undefined)
  void runs
  const base = path.join(outputDir, ".droidseal", "runs")
  const entries = await readFile(base, "utf8").then(() => undefined).catch(() => undefined)
  void entries
  // 用 glob 式读取:runs/<id>/reports/droidseal-report.json(取最新)
  const { readdir } = await import("node:fs/promises")
  const ids = await readdir(base).catch(() => [] as string[])
  const reports: Array<{ id: string; path: string }> = []
  for (const id of ids) {
    const candidate = path.join(base, id, "reports", "droidseal-report.json")
    const info = await stat(candidate).catch(() => undefined)
    if (info) reports.push({ id, path: candidate })
  }
  if (reports.length === 0) return undefined
  reports.sort((a, b) => a.id.localeCompare(b.id))
  return reports[reports.length - 1]!.path
}

async function findingCodes(reportPath: string): Promise<Set<string>> {
  const report = JSON.parse(await readFile(reportPath, "utf8")) as { audit?: { findings?: Array<{ code?: string }> } }
  return new Set((report.audit?.findings ?? []).map((f) => f.code ?? "").filter(Boolean))
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const [kind, inputPath, mode, keystorePath, alias] = argv
  const beforeIndex = argv.indexOf("--before")
  const beforeReport = beforeIndex >= 0 ? argv[beforeIndex + 1] : undefined
  const auto = argv.includes("--auto")
  const webEnabled = argv.includes("--web")
  const arscEnabled = argv.includes("--arsc")
  if (!kind || !inputPath || !mode) throw new Error("用法: re-test <apk|project> <输入路径> <skip|existing> [keystore] [alias] [--before <报告json> | --auto] [--web] [--arsc]")

  const outputDirectory = `${kind === "project" ? path.resolve(inputPath) : path.dirname(path.resolve(inputPath))}/droidseal-retest-${Date.now()}`
  const config: PipelineConfig = {
    runMode: "one-click",
    inputKind: kind === "project" ? "project" : "apk",
    inputPath,
    outputDirectory,
    gradleTask: kind === "project" ? "assembleRelease" : "",
    enableAlignment: true,
    enableWebAssetMinification: webEnabled,
    enableArscObfuscation: arscEnabled,
    keepIntermediates: false,
    signing:
      mode === "skip"
        ? { mode: "skip" }
        : {
            mode: "existing",
            keystorePath: keystorePath ?? "",
            keyAlias: alias ?? "",
            storePassword: process.env.DROIDSEAL_STORE_PASSWORD ?? "",
            keyPassword: process.env.DROIDSEAL_KEY_PASSWORD ?? "",
          },
    protection: { mode: "local-safe" },
  }

  const pipeline = new Pipeline(config)
  for (const stepId of STEP_IDS) {
    await pipeline.runStep(stepId).catch(() => undefined)
  }
  const reportPath = await findLatestReport(outputDirectory)
  if (!reportPath) throw new Error("未找到复测报告")
  const after = await findingCodes(reportPath)

  let effectiveBefore = beforeReport
  if (!effectiveBefore && auto) {
    // --auto:自动定位输入目录下最近一次 droidseal-* 运行的报告
    const parent = kind === "project" ? path.resolve(inputPath) : path.dirname(path.resolve(inputPath))
    const { readdir } = await import("node:fs/promises")
    const dirs = (await readdir(parent)).filter((d) => d.startsWith("droidseal-"))
    for (const dir of dirs) {
      const found = await findLatestReport(path.join(parent, dir))
      if (found && (!effectiveBefore || found > effectiveBefore)) effectiveBefore = found
    }
  }

  console.log(`复测完成：${reportPath}`)
  console.log(`当前 findings：${after.size} 个 code`)

  if (effectiveBefore) {
    const before = await findingCodes(effectiveBefore)
    const eliminated = [...before].filter((c) => !after.has(c))
    const added = [...after].filter((c) => !before.has(c))
    const remaining = [...before].filter((c) => after.has(c))
    console.log(`\n===== 复测对比（${effectiveBefore}） =====`)
    console.log(`消除 ${eliminated.length} 个：${eliminated.join("、") || "无"}`)
    console.log(`新增 ${added.length} 个：${added.join("、") || "无"}`)
    console.log(`剩余 ${remaining.length} 个：${remaining.join("、") || "无"}`)
  } else if (auto) {
    console.log("--auto：未找到上一次运行报告，跳过对比。")
  }
}

main().catch((error) => {
  console.error(`复测失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
