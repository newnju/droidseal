#!/usr/bin/env bun
// 临时综合测试 runner:用 textseg 项目跑多场景(APK/源码 × 无密钥/有密钥)。
// 用法:
//   bun scripts/test-runner.ts <kind> <inputPath> <mode> [keystore] [alias]
//     kind: apk | project
//     mode: skip(无密钥) | existing(有密钥)
//     keystore/alias: existing 模式必需;密码取 DROIDSEAL_STORE_PASSWORD
import { Pipeline } from "../src/core/pipeline.ts"
import type { PipelineConfig, StepId } from "../src/core/types.ts"
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

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const [kind, inputPath, mode, keystorePath, alias] = argv
  const webEnabled = argv.includes("--web")
  const arscEnabled = argv.includes("--arsc")
  const learning = argv.includes("--test-learning")
  if (!kind || !inputPath || !mode) throw new Error("用法: test-runner <apk|project> <输入路径> <skip|existing> [keystore] [alias] [--web] [--arsc] [--test-learning]")

  const config: PipelineConfig = {
    runMode: "one-click",
    inputKind: kind === "project" ? "project" : "apk",
    inputPath,
    outputDirectory: `${kind === "project" ? path.resolve(inputPath) : path.dirname(path.resolve(inputPath))}/droidseal-test-output-${Date.now()}`,
    gradleTask: kind === "project" ? "assembleRelease" : "",
    enableAlignment: true,
    enableWebAssetMinification: webEnabled,
    enableArscObfuscation: arscEnabled,
    keepIntermediates: learning,
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
  pipeline.onEvent((event) => {
    if (event.type === "step-finished") {
      console.log(`[事件] ${event.step.id}: ${event.step.status}`)
    }
  })

  const started = Date.now()
  for (const stepId of STEP_IDS) {
    try {
      await pipeline.runStep(stepId)
    } catch (error) {
      console.log(`[步骤异常] ${stepId}: ${error instanceof Error ? error.message : String(error)}`)
    }
  }
  const seconds = ((Date.now() - started) / 1000).toFixed(1)

  console.log(`\n===== 场景摘要(${kind}/${mode}) 用时 ${seconds}s =====`)
  for (const step of pipeline.getSteps()) {
    const skip = step.status === "skipped" ? ` (跳过: ${step.result?.skipKind ?? "?"})` : ""
    const failed = step.status === "failed" ? ` (${step.result?.summary ?? "失败"})` : ""
    console.log(`  ${step.id}: ${step.status}${skip}${failed}`)
  }
}

main().catch((error) => {
  console.error(`测试失败: ${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
