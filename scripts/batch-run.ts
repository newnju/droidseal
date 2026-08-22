#!/usr/bin/env bun
// 批量 runner（REST-only 模式的批量操作）：读清单文件（JSON 配置数组）→ 循环 POST /run → 汇总。
// 利用已有 REST API，不改服务端；错误隔离（单项失败不影响后续）。
//
// 用法：
//   bun scripts/batch-run.ts <manifest.json> [--base http://127.0.0.1:8787] [--token <token>]
//
// 清单格式（与 POST /run 的 body 一致，另加 name）：
//   [
//     { "name": "app1", "inputKind": "apk", "inputPath": "C:/apks/app1.apk", "signingMode": "skip" },
//     { "name": "app2", "inputKind": "apk", "inputPath": "C:/apks/app2.apk", "signingMode": "skip", "enableArscObfuscation": true }
//   ]
import { readFile } from "node:fs/promises"

interface BatchItem {
  name: string
  inputKind: "apk" | "project"
  inputPath: string
  signingMode: "skip" | "existing"
  keystorePath?: string
  keyAlias?: string
  storePassword?: string
  keyPassword?: string
  enableWebAssetMinification?: boolean
  enableArscObfuscation?: boolean
  keepIntermediates?: boolean
}

interface RunResponse {
  ok?: boolean
  steps?: Array<{ status: string }>
  finalArtifact?: string
  error?: { message?: string }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const manifestPath = argv[0]
  if (!manifestPath) throw new Error("用法: batch-run <清单.json> [--base http://127.0.0.1:8787] [--token <token>]")
  let base = "http://127.0.0.1:8787"
  let token: string | undefined
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--base") base = argv[++i]!
    else if (argv[i] === "--token") token = argv[++i]!
  }
  const items = JSON.parse(await readFile(manifestPath, "utf8")) as BatchItem[]
  if (items.length === 0) throw new Error("清单为空")
  const headers: Record<string, string> = { "Content-Type": "application/json" }
  if (token) headers["Authorization"] = `Bearer ${token}`

  const results: Array<{ name: string; ok: boolean; seconds?: number; stepsOk?: number; stepsSkipped?: number; error?: string }> = []
  const startedAt = Date.now()
  for (const [index, item] of items.entries()) {
    const itemStarted = Date.now()
    process.stdout.write(`[${index + 1}/${items.length}] ${item.name} ... `)
    const res = await fetch(`${base}/run`, { method: "POST", headers, body: JSON.stringify(item) }).catch(() => null)
    if (!res) {
      console.log("请求失败")
      results.push({ name: item.name, ok: false, error: "请求失败" })
      continue
    }
    const data = (await res.json().catch(() => null)) as RunResponse | null
    const seconds = (Date.now() - itemStarted) / 1000
    if (!data || data.ok !== true) {
      console.log(`失败（${seconds.toFixed(1)}s）`)
      results.push({ name: item.name, ok: false, seconds, error: data?.error?.message ?? `HTTP ${res.status}` })
      continue
    }
    const stepsOk = data.steps?.filter((s) => s.status === "success").length ?? 0
    const stepsSkipped = data.steps?.filter((s) => s.status === "skipped").length ?? 0
    console.log(`完成（${seconds.toFixed(1)}s，成功 ${stepsOk} 步${stepsSkipped > 0 ? `，跳过 ${stepsSkipped} 步` : ""}）`)
    results.push({ name: item.name, ok: true, seconds, stepsOk, stepsSkipped })
  }

  const ok = results.filter((r) => r.ok).length
  console.log(`\n===== 批量汇总 =====`)
  console.log(`成功 ${ok}/${results.length}；总耗时 ${((Date.now() - startedAt) / 1000).toFixed(1)}s`)
  for (const r of results) {
    console.log(`- ${r.ok ? "✓" : "✗"} ${r.name}${r.ok ? `（${r.seconds?.toFixed(1)}s${r.stepsOk !== undefined ? `，成功 ${r.stepsOk} 步` : ""}）` : `：${r.error ?? ""}`}`)
  }
  if (ok < results.length) process.exitCode = 1
}

main().catch((error) => {
  console.error(`批量失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
