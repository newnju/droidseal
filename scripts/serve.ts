#!/usr/bin/env bun
// 本地 REST API 服务（工具）。
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

// Web UI（深色主题、数据看板、门禁结果、审计发现、报告）
const WEB_UI_HTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>DroidSeal — Release Security Console</title>
<style>
  :root { --bg:#0a0e17; --panel:#111827; --line:#1f2937; --txt:#e5e7eb; --dim:#9ca3af;
          --acc:#22d3ee; --ok:#34d399; --warn:#fbbf24; --bad:#f87171; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { background:radial-gradient(1200px 600px at 20% -10%, #0e2233 0%, var(--bg) 55%);
         color:var(--txt); font:14px/1.6 "Segoe UI",system-ui,sans-serif; padding:28px; }
  .wrap { max-width:1080px; margin:0 auto; }
  header { display:flex; align-items:center; gap:14px; margin-bottom:22px; }
  .logo { width:34px; height:34px; border-radius:9px;
          background:linear-gradient(135deg,var(--acc),#6366f1);
          display:grid; place-items:center; font-weight:700; color:#06222a; box-shadow:0 0 18px #22d3ee55; }
  h1 { font-size:20px; letter-spacing:.5px; }
  .sub { color:var(--dim); font-size:12px; }
  .pulse { width:10px; height:10px; border-radius:50%; background:var(--ok);
           box-shadow:0 0 10px var(--ok); animation:pulse 2s infinite; }
  @keyframes pulse { 50% { opacity:.35; } }
  .cards { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:22px; }
  .card { background:var(--panel); border:1px solid var(--line); border-radius:12px; padding:16px; }
  .card .k { color:var(--dim); font-size:12px; }
  .card .v { font-size:26px; font-weight:700; margin-top:4px; }
  .card .v.ok { color:var(--ok); } .card .v.bad { color:var(--bad); } .card .v.acc { color:var(--acc); }
  section { background:var(--panel); border:1px solid var(--line); border-radius:12px; padding:18px; margin-bottom:18px; }
  h2 { font-size:15px; margin-bottom:12px; color:var(--acc); }
  table { width:100%; border-collapse:collapse; }
  th,td { text-align:left; padding:8px 10px; border-bottom:1px solid var(--line); font-size:13px; }
  th { color:var(--dim); font-weight:600; }
  .badge { padding:2px 9px; border-radius:99px; font-size:11px; font-weight:600; }
  .b-pass{background:#065f4633;color:var(--ok)} .b-review{background:#78350f33;color:var(--warn)} .b-block{background:#7f1d1d33;color:var(--bad)}
  .scan { height:6px; border-radius:99px; background:var(--line); overflow:hidden; margin-top:6px; }
  .scan i { display:block; height:100%; width:0; background:linear-gradient(90deg,var(--acc),#6366f1);
            box-shadow:0 0 12px var(--acc); transition:width .4s; }
  a { color:var(--acc); text-decoration:none; }
  .empty { color:var(--dim); text-align:center; padding:22px; }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div class="logo">DS</div>
    <div><h1>DroidSeal</h1><div class="sub">Release Security Console — audit · harden · gate</div></div>
    <span class="pulse" title="服务运行中"></span>
  </header>

  <div class="cards">
    <div class="card"><div class="k">运行总数</div><div class="v acc" id="c-total">—</div></div>
    <div class="card"><div class="k">通过 (pass)</div><div class="v ok" id="c-pass">—</div></div>
    <div class="card"><div class="k">复核 (review)</div><div class="v" id="c-review">—</div></div>
    <div class="card"><div class="k">阻断 (block)</div><div class="v bad" id="c-block">—</div></div>
  </div>

  <section>
    <h2>运行历史</h2>
    <div id="runs"><div class="empty">加载中…</div></div>
  </section>

  <section>
    <h2>审计发现</h2>
    <div id="findings"><div class="empty">选择一次运行以查看发现</div></div>
  </section>
</div>

<script>
const $ = (s) => document.querySelector(s)
let current = null

async function load() {
  const r = await fetch("/runs").then(x => x.json())
  const runs = r.runs ?? []
  let pass=0, review=0, block=0
  for (const run of runs) {
    if (run.releaseDecision?.status === "pass") pass++
    else if (run.releaseDecision?.status === "review") review++
    else if (run.releaseDecision?.status === "block") block++
  }
  $("#c-total").textContent = runs.length
  $("#c-pass").textContent = pass
  $("#c-review").textContent = review
  $("#c-block").textContent = block

  const rows = runs.map(run => {
    const s = run.releaseDecision?.status ?? "unknown"
    const cls = s === "pass" ? "b-pass" : s === "review" ? "b-review" : s === "block" ? "b-block" : ""
    return \`<tr data-id="\${run.id}" style="cursor:pointer">
      <td>\${run.id}</td><td>\${run.inputKind ?? "—"}</td>
      <td>\${run.inputPath ?? "—"}</td>
      <td><span class="badge \${cls}">\${s}</span></td>
      <td>\${run.findingsCount ?? 0}</td>
      <td>\${run.timestamp ?? "—"}</td></tr>\`
  }).join("")
  $("#runs").innerHTML = rows
    ? \`<table><tr><th>ID</th><th>类型</th><th>输入</th><th>门禁</th><th>发现</th><th>时间</th></tr>\${rows}</table>\`
    : '<div class="empty">暂无运行——POST /run 提交一次审计</div>'
  document.querySelectorAll("#runs tr[data-id]").forEach(tr => {
    tr.onclick = () => selectRun(tr.dataset.id)
  })
}

async function selectRun(id) {
  current = id
  const f = await fetch("/runs/" + id + "/findings").then(x => x.json())
  const items = f.findings ?? []
  $("#findings").innerHTML = items.length
    ? \`<table><tr><th>严重度</th><th>检测器</th><th>文件</th></tr>\${
        items.map(x => \`<tr><td>\${x.severity}</td><td>\${x.code}</td><td>\${x.file ?? "—"}</td></tr>\`).join("")
      }</table>\`
    : '<div class="empty">该运行无发现</div>'
}

load()
setInterval(load, 5000)
</script>
</body>
</html>`

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

// 运行并发（工具）：允许并发运行——每个 run 使用独立目录（.droidseal/runs/<id>）

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
      if (request.method === "GET" && url.pathname === "/") {
        return new Response(WEB_UI_HTML, { headers: { "Content-Type": "text/html; charset=utf-8" } })
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
