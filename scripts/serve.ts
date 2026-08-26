#!/usr/bin/env bun
// 本地 REST API 服务（差距分析高补强①：平台化；Web UI 已移除，批量/CI 使用 REST）。
// 只绑定 127.0.0.1（本地优先、不对外联网）；设置 DROIDSEAL_SERVER_TOKEN 时要求
// Authorization: Bearer <token>。零运行时依赖（Bun.serve）。
//
// 用法：
//   bun scripts/serve.ts [--port 8787] [--host 127.0.0.1] [--output <目录>]
//   --host 0.0.0.0 时绑定所有接口（外部可访问；默认仅本地 127.0.0.1）
//   POST /run           提交运行配置（JSON），跑完整流水线，返回步骤状态
//   GET  /runs          运行历史（门禁状态 + 发现数）
//   GET  /runs/:id      运行详情
//   GET  /runs/:id/findings  读取运行的发现（?severity= 筛选）
//   GET  /reports/<path> 读取输出目录下的报告文件（json/md）
//   GET  /health         健康检查
import { Pipeline } from "../src/core/pipeline.ts"
import type { PipelineConfig, StepId } from "../src/core/types.ts"
import { readFile, readdir } from "node:fs/promises"
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

interface RunRequest {
  inputKind?: "apk" | "project"
  inputPath?: string
  signingMode?: "skip" | "existing"
  keystorePath?: string
  keyAlias?: string
  storePassword?: string
  keyPassword?: string
  outputDirectory?: string
  enableWebAssetMinification?: boolean
  enableArscObfuscation?: boolean
  keepIntermediates?: boolean
}

function buildConfig(body: RunRequest, defaultOutput: string): PipelineConfig {
  if (!body.inputKind || !body.inputPath || !body.signingMode) {
    throw new Error("缺少 inputKind / inputPath / signingMode")
  }
  if (body.inputKind !== "apk" && body.inputKind !== "project") {
    throw new Error("inputKind 必须为 apk 或 project")
  }
  if (body.signingMode !== "skip" && body.signingMode !== "existing") {
    throw new Error("signingMode 必须为 skip 或 existing")
  }
  return {
    runMode: "one-click",
    inputKind: body.inputKind,
    inputPath: body.inputPath,
    outputDirectory: body.outputDirectory ?? path.join(defaultOutput, `droidseal-server-${Date.now()}`),
    gradleTask: body.inputKind === "project" ? "assembleRelease" : "",
    enableAlignment: true,
    enableWebAssetMinification: body.enableWebAssetMinification ?? false,
    enableArscObfuscation: body.enableArscObfuscation ?? false,
    keepIntermediates: body.keepIntermediates ?? false,
    signing:
      body.signingMode === "skip"
        ? { mode: "skip" }
        : {
            mode: "existing",
            keystorePath: body.keystorePath ?? "",
            keyAlias: body.keyAlias ?? "",
            storePassword: body.storePassword ?? "",
            keyPassword: body.keyPassword ?? "",
          },
    protection: { mode: "local-safe" },
  }
}

// 运行中状态（③——REST 进度/取消）：runId → 步骤进度 + 取消标志
const runningRuns = new Map<string, { steps: string[]; cancelled: boolean; status: string }>()

async function runPipeline(config: PipelineConfig, runId?: string): Promise<Record<string, unknown>> {
  const pipeline = new Pipeline(config)
  for (const stepId of STEP_IDS) {
    if (runId && runningRuns.get(runId)?.cancelled) break // 取消——提前停止后续步骤
    await pipeline.runStep(stepId).catch(() => undefined)
    if (runId) {
      const run = runningRuns.get(runId)
      if (run) run.steps.push(stepId)
    }
  }
  const steps = pipeline.getSteps().map((step) => ({
    id: step.id,
    status: step.status,
    skipKind: step.result?.skipKind ?? null,
  }))
  return { steps, finalArtifact: config.outputDirectory, ...(pipeline.getReleaseGate() ? { gate: pipeline.getReleaseGate() } : {}) }
}

interface RunReport {
  releaseDecision?: { status?: string }
  audit?: { findings?: Array<{ severity?: string }> }
}

// 运行历史:输出目录 runs 下的最近报告摘要(最新在前,最多 10 条)
async function listRuns(outputDir: string): Promise<Array<{ runId: string; status?: string; findingsCount: number }>> {
  const runsRoot = path.join(outputDir, ".droidseal", "runs")
  const ids = await readdir(runsRoot).catch(() => [] as string[])
  ids.sort()
  const runs: Array<{ runId: string; status?: string; findingsCount: number }> = []
  for (const id of ids) {
    const reportPath = path.join(runsRoot, id, "reports", "droidseal-report.json")
    const content = await readFile(reportPath, "utf8").catch(() => null)
    if (!content) continue
    const report = JSON.parse(content) as RunReport
    const status = report.releaseDecision?.status
    runs.push({ runId: id, findingsCount: report.audit?.findings?.length ?? 0, ...(status ? { status } : {}) })
  }
  return runs.slice(-10).reverse()
}

async function readRunReport(outputDir: string, runId: string): Promise<RunReport | null> {
  const reportPath = path.join(outputDir, ".droidseal", "runs", runId, "reports", "droidseal-report.json")
  const content = await readFile(reportPath, "utf8").catch(() => null)
  return content ? (JSON.parse(content) as RunReport) : null
}

// 结构化错误响应:{ ok: false, error: { code, message } }
function errorResponse(code: string, message: string, status: number): Response {
  return Response.json({ ok: false, error: { code, message } }, { status })
}

// 运行并发（SUPER 差距①）：允许并发运行——每个 run 使用独立目录（.droidseal/runs/<id>）

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  let port = 8787
  let host = "127.0.0.1"
  let outputDir = path.resolve("droidseal-output")
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === "--port") port = Number(argv[++i])
    else if (argv[i] === "--host") host = argv[++i] ?? "127.0.0.1"
    else if (argv[i] === "--output") outputDir = path.resolve(argv[++i]!)
  }
  const token = process.env.DROIDSEAL_SERVER_TOKEN

  const server = Bun.serve({
    port,
    hostname: host,
    async fetch(request) {
      const url = new URL(request.url)
      if (token) {
        const auth = request.headers.get("authorization")
        if (auth !== `Bearer ${token}`) {
          return errorResponse("UNAUTHORIZED", "未授权", 401)
        }
      }
      if (request.method === "POST" && url.pathname === "/run") {
        try {
          const body = (await request.json()) as RunRequest
          const config = buildConfig(body, outputDir)
          // 异步模式（③）：?async=true——后台运行——立即返回 runId（GET /runs/:id 查询进度 / POST /runs/:id/cancel 取消）
          if (url.searchParams.get("async") === "true") {
            const runId = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`
            runningRuns.set(runId, { steps: [], cancelled: false, status: "running" })
            void runPipeline(config, runId)
              .then(() => {
                const run = runningRuns.get(runId)
                if (run) run.status = run.cancelled ? "cancelled" : "done"
              })
              .catch(() => {
                const run = runningRuns.get(runId)
                if (run) run.status = "failed"
              })
            return Response.json({ ok: true, runId, async: true })
          }
          const result = await runPipeline(config)
          return Response.json({ ok: true, ...result })
        } catch (error) {
          return errorResponse("RUN_FAILED", error instanceof Error ? error.message : String(error), 400)
        }
      }
      if (request.method === "POST" && url.pathname.startsWith("/runs/") && url.pathname.endsWith("/cancel")) {
        const id = url.pathname.slice("/runs/".length).split("/")[0]
        if (!id) return errorResponse("RUN_NOT_FOUND", "run not found", 404)
        const run = runningRuns.get(id)
        if (!run) return errorResponse("RUN_NOT_FOUND", "run not found", 404)
        run.cancelled = true
        run.status = "cancelled"
        return Response.json({ ok: true, runId: id, status: "cancelled" })
      }
      if (request.method === "GET" && url.pathname === "/health") {
        const usage = process.memoryUsage()
        return Response.json({
          ok: true,
          service: "DroidSeal Web",
          outputDirectory: outputDir,
          memoryUsageMb: { rss: +(usage.rss / 1024 / 1024).toFixed(1), heap: +(usage.heapUsed / 1024 / 1024).toFixed(1) },
        })
      }
      if (request.method === "GET" && url.pathname === "/runs") {
        const runs = await listRuns(outputDir)
        return Response.json({ ok: true, runs })
      }
      if (request.method === "GET" && url.pathname.startsWith("/runs/")) {
        const id = url.pathname.slice("/runs/".length).split("/")[0]
        if (!id) return errorResponse("RUN_NOT_FOUND", "run not found", 404)
        // 运行中——返回进度（③）
        const running = runningRuns.get(id)
        if (running) {
          return Response.json({ ok: true, runId: id, status: running.status, cancelled: running.cancelled, progress: running.steps.length / STEP_IDS.length, steps: running.steps })
        }
        const report = await readRunReport(outputDir, id)
        if (!report) return errorResponse("RUN_NOT_FOUND", "run not found", 404)
        if (url.pathname.includes("/findings")) {
          const severity = url.searchParams.get("severity")
          const findings = (report.audit?.findings ?? []).filter((f) => !severity || f.severity === severity)
          return Response.json({ ok: true, runId: id, findings })
        }
        if (url.pathname.includes("/gate")) {
          const decision = report.releaseDecision ?? null
          return Response.json({
            ok: true,
            runId: id,
            gate: decision,
            blocking: (report.audit?.findings ?? []).filter((f) => f.severity === "high" || f.severity === "critical").length,
          })
        }
        return Response.json({
          ok: true,
          runId: id,
          status: report.releaseDecision?.status ?? "unknown",
          findingsCount: report.audit?.findings?.length ?? 0,
          gate: report.releaseDecision ?? null,
        })
      }
      if (request.method === "GET" && url.pathname.startsWith("/reports/")) {
        const relative = url.pathname.slice("/reports/".length)
        const target = path.resolve(outputDir, relative)
        if (!target.startsWith(path.resolve(outputDir))) return errorResponse("FORBIDDEN", "forbidden", 403)
        const content = await readFile(target, "utf8").catch(() => null)
        if (content === null) return errorResponse("NOT_FOUND", "not found", 404)
        return new Response(content, {
          headers: { "Content-Type": relative.endsWith(".json") ? "application/json" : "text/plain; charset=utf-8" },
        })
      }
      return errorResponse("NOT_FOUND", "not found", 404)
    },
  })
  console.log(`DroidSeal REST 服务：http://${host}:${server.port}（输出目录 ${outputDir}${token ? "，已启用 token 认证" : ""}）`)
}

main().catch((error) => {
  console.error(`启动失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
