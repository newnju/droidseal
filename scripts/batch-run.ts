#!/usr/bin/env bun
// 批量 runner（REST-only 模式的批量操作）：读清单文件（JSON 配置数组）→ 循环 POST /run → 汇总。
// 利用已有 REST API，不改服务端；错误隔离（单项失败不影响后续）。
//
// 用法：
//   bun scripts/batch-run.ts <manifest.json> [--base http://127.0.0.1:8787] [--token <token>]
//   bun scripts/batch-run.ts --dir <APK目录> [--base ...] [--token ...]   # 目录/库级批量：扫描 *.apk 自动建清单
//
// 清单格式（与 POST /run 的 body 一致，另加 name）：
//   [
//     { "name": "app1", "inputKind": "apk", "inputPath": "C:/apks/app1.apk", "signingMode": "skip" },
//     { "name": "app2", "inputKind": "apk", "inputPath": "C:/apks/app2.apk", "signingMode": "skip", "enableArscObfuscation": true }
//   ]
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"

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
  gate?: string
  error?: { message?: string }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const dirMode = argv[0] === "--dir"
  const manifestPath = dirMode ? undefined : argv[0]
  if (!dirMode && !manifestPath) throw new Error("用法: batch-run <清单.json> [--base http://127.0.0.1:8787] [--token <token>] 或 batch-run --dir <APK目录> [...]")
  let base = "http://127.0.0.1:8787"
  let token: string | undefined
  const argStart = dirMode ? 1 : 1
  for (let i = argStart; i < argv.length; i += 1) {
    if (argv[i] === "--base") base = argv[++i]!
    else if (argv[i] === "--token") token = argv[++i]!
  }
  let items: BatchItem[]
  if (dirMode) {
    // 目录/库级批量（AndroBugs 差距③）：扫描目录下所有 *.apk，自动建清单
    const dir = manifestPath ?? argv[1]!
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    const apks = entries.filter((entry) => entry.toLowerCase().endsWith(".apk"))
    if (apks.length === 0) throw new Error(`目录中未找到 APK：${dir}`)
    items = apks.map((entry) => ({
      name: path.basename(entry),
      inputKind: "apk",
      inputPath: path.join(dir, entry),
      signingMode: "skip",
    }))
    console.log(`目录批量模式：发现 ${items.length} 个 APK`)
  } else {
    items = JSON.parse(await readFile(manifestPath!, "utf8")) as BatchItem[]
  }
  if (items.length === 0) throw new Error("清单为空")
  const headers: Record<string, string> = { "Content-Type": "application/json" }
  if (token) headers["Authorization"] = `Bearer ${token}`

  // 并发池（工具）：--parallel N——最多 N 个请求同时进行（默认 1 串行）
  let parallel = 1
  // 失败重试（②）：--retry N——失败条目自动重试 N 次（默认 0）
  let retry = 0
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--parallel") {
      const value = Number.parseInt(argv[++i] ?? "1", 10)
      parallel = Number.isFinite(value) && value > 0 ? value : 1
    }
    if (argv[i] === "--retry") {
      const value = Number.parseInt(argv[++i] ?? "0", 10)
      retry = Number.isFinite(value) && value >= 0 ? value : 0
    }
  }

  const results: Array<{ name: string; ok: boolean; seconds?: number; stepsOk?: number; stepsSkipped?: number; gate?: string; error?: string }> = []
  const startedAt = Date.now()
  // 占用采样（①）：峰值 RSS/堆内存——每条目后采样，汇总输出峰值
  let peakRss = 0
  let peakHeap = 0
  const sampleMemory = (): void => {
    const usage = process.memoryUsage()
    if (usage.rss > peakRss) peakRss = usage.rss
    if (usage.heapUsed > peakHeap) peakHeap = usage.heapUsed
  }

  const runOne = async (index: number): Promise<void> => {
    const item = items[index]!
    const itemStarted = Date.now()
    // 失败重试（②）：最多尝试 1 + retry 次
    let attempts = 0
    let failure: string | undefined
    while (attempts <= retry) {
      attempts += 1
      if (attempts > 1) process.stdout.write(`[${index + 1}/${items.length}] ${item.name} 重试 ${attempts - 1}/${retry} ... `)
      const res = await fetch(`${base}/run`, { method: "POST", headers, body: JSON.stringify(item) }).catch(() => null)
      if (!res) {
        failure = "请求失败"
        continue
      }
      const data = (await res.json().catch(() => null)) as RunResponse | null
      if (!data || data.ok !== true) {
        failure = data?.error?.message ?? `HTTP ${res.status}`
        continue
      }
      const seconds = (Date.now() - itemStarted) / 1000
      const stepsOk = data.steps?.filter((s) => s.status === "success").length ?? 0
      const stepsSkipped = data.steps?.filter((s) => s.status === "skipped").length ?? 0
      sampleMemory()
      process.stdout.write(`\r`)
      console.log(`[${index + 1}/${items.length}] ${item.name} 完成（${seconds.toFixed(1)}s，成功 ${stepsOk} 步${stepsSkipped > 0 ? `，跳过 ${stepsSkipped} 步` : ""}${data.gate ? `，门禁 ${data.gate}` : ""}${attempts > 1 ? `，重试 ${attempts - 1} 次后成功` : ""}）`)
      results[index] = { name: item.name, ok: true, seconds, stepsOk, stepsSkipped, ...(data.gate ? { gate: data.gate } : {}) }
      return
    }
    const seconds = (Date.now() - itemStarted) / 1000
    console.log(`[${index + 1}/${items.length}] ${item.name} 失败（${seconds.toFixed(1)}s${attempts > 1 ? `，${attempts - 1} 次重试后仍失败` : ""}）`)
    results[index] = { name: item.name, ok: false, seconds, ...(failure ? { error: failure } : {}) }
  }

  let next = 0
  const workers = Array.from({ length: Math.min(parallel, items.length) }, async () => {
    while (true) {
      const index = next++
      if (index >= items.length) return
      await runOne(index)
    }
  })
  await Promise.all(workers)

  const ok = results.filter((r) => r.ok).length
  console.log(`\n===== 批量汇总 =====`)
  console.log(`成功 ${ok}/${results.length}；总耗时 ${((Date.now() - startedAt) / 1000).toFixed(1)}s；峰值内存 ${(peakRss / 1024 / 1024).toFixed(1)} MB（RSS）/ ${(peakHeap / 1024 / 1024).toFixed(1)} MB（堆）`)
  for (const r of results) {
    console.log(`- ${r.ok ? "✓" : "✗"} ${r.name}${r.ok ? `（${r.seconds?.toFixed(1)}s${r.stepsOk !== undefined ? `，成功 ${r.stepsOk} 步` : ""}）` : `：${r.error ?? ""}`}`)
  }
  if (ok < results.length) process.exitCode = 1
  // 批量门禁阻断（⑤）：任一条目门禁为 block → 非零退出（CI 用）
  if (results.some((r) => r.gate === "block")) {
    console.log("检测到 block 门禁条目——非零退出（CI 门禁）")
    process.exitCode = 1
  }
  // 构建耗时提示（①）：最慢条目 + 构建/项目类慢的说明
  const slowest = [...results].sort((a, b) => (b.seconds ?? 0) - (a.seconds ?? 0))[0]
  if (slowest && (slowest.seconds ?? 0) > 0) {
    console.log(
      `最慢条目：${slowest.name}（${slowest.seconds?.toFixed(1) ?? "0"}s${slowest.stepsOk !== undefined ? `，成功 ${slowest.stepsOk} 步` : ""}${(slowest.seconds ?? 0) > 60 ? "——构建/项目类条目耗时较长，可启用构建缓存或增量构建" : ""}）`,
    )
  }
}

main().catch((error) => {
  console.error(`批量失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
