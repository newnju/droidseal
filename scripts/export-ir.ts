#!/usr/bin/env bun
// 可编程 IR 导出（⑨——完整版：解析结果的中间表示导出——供第三方编程分析）。
// 从 APK 提取结构化 IR：元数据 + DEX 字符串池 + 调用图（含接口分派）+ 审计发现——JSON 导出。
// 第三方可基于 IR 编写自定义分析（无需重新解析 APK——DroidSeal 的"可编程分析接口"）。
//
// 用法：
//   bun scripts/export-ir.ts <app.apk> [output.json]
import { writeFile } from "node:fs/promises"
import { spawnSync } from "node:child_process"
import { auditApk } from "../src/core/apk-audit.ts"
import { extractCalledMethods, extractCallGraph, expandInterfaceDispatch } from "../src/core/dex-callgraph.ts"
import { buildClassModel } from "../src/core/dex-class-model.ts"

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const apk = argv[0]
  if (!apk) throw new Error("用法: export-ir <app.apk> [output.json]")
  const output = argv[1] ?? "ir.json"

  // 1. 审计发现（失败关闭——工具链缺失时降级为无发现，IR 核心仍导出）
  let findings: Array<{ severity: string; code: string; title: string; confidence?: string; evidence?: string }> = []
  let metadata: { packageName?: string; targetSdk?: string; minSdk?: string } = {}
  try {
    const audit = await auditApk(apk, undefined as never)
    findings = audit.findings.map((f) => ({
      severity: f.severity,
      code: f.code,
      title: f.title,
      ...(f.confidence ? { confidence: f.confidence } : {}),
      ...(f.evidence ? { evidence: f.evidence } : {}),
    }))
    metadata = {
      ...(audit.apkMetadata?.packageName ? { packageName: audit.apkMetadata.packageName } : {}),
      ...(audit.apkMetadata?.targetSdk ? { targetSdk: audit.apkMetadata.targetSdk } : {}),
      ...(audit.apkMetadata?.minSdk ? { minSdk: audit.apkMetadata.minSdk } : {}),
    }
  } catch {
    // 工具链缺失/审计失败——IR 核心（字符串池/调用图）仍导出
  }

  // 2. DEX 字符串池 + 调用图（含接口分派）——用 unzip 提取 classes.dex 字节
  const result = spawnSync("unzip", ["-p", apk, "classes.dex"], { maxBuffer: 256 * 1024 * 1024 })
  const bytes = result.status === 0 ? new Uint8Array(result.stdout) : undefined
  const strings: string[] = []
  const called: string[] = []
  const callGraphEdges: Array<{ caller: string; called: string[] }> = []
  const classes: Array<{ className: string; methodCount: number; methods: Array<{ name: string; instructionCount: number }> }> = []
  if (bytes && bytes.length > 0 && bytes[0] === 0x64) {
    const graph = expandInterfaceDispatch(extractCallGraph(bytes), bytes)
    called.push(...extractCalledMethods(bytes))
    for (const [caller, callees] of graph) {
      callGraphEdges.push({ caller, called: [...callees] })
    }
    // 类级对象模型（⑤——类 → 方法 → 指令数 的 IR 深化）
    for (const c of buildClassModel(bytes)) {
      classes.push({
        className: c.className,
        methodCount: c.methodCount,
        methods: c.methods.map((m) => ({ name: m.name, instructionCount: m.instructionCount })),
      })
    }
  }

  const ir = {
    schemaVersion: 2,
    generatedAt: new Date().toISOString(),
    apk,
    metadata,
    strings: strings.slice(0, 200),
    calledMethods: [...called].sort().slice(0, 500),
    callGraph: callGraphEdges.slice(0, 500),
    classes: classes.slice(0, 200),
    findings,
  }
  await writeFile(output, JSON.stringify(ir, null, 2), "utf8")
  console.log(`已导出 IR：${output}（发现 ${findings.length} 条、调用图 ${callGraphEdges.length} 条边、类模型 ${classes.length} 个类——供第三方编程分析）`)
}

main().catch((error) => {
  console.error(`IR 导出失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
