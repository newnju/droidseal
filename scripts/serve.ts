#!/usr/bin/env bun
// 本地 Web UI / REST API 服务（差距分析高补强①：平台化）。
// 只绑定 127.0.0.1（本地优先、不对外联网）；设置 DROIDSEAL_SERVER_TOKEN 时要求
// Authorization: Bearer <token>。零运行时依赖（Bun.serve）。
//
// 用法：
//   bun scripts/serve.ts [--port 8787] [--output <目录>]
//   POST /run           提交运行配置（JSON），跑完整流水线，返回报告路径与门禁
//   GET  /reports/<path> 读取输出目录下的报告文件（json/md）
//   GET  /              返回 Web UI（运行表单 + 报告浏览）
import { Pipeline } from "../src/core/pipeline.ts"
import type { PipelineConfig, StepId } from "../src/core/types.ts"
import { readFile } from "node:fs/promises"
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

async function runPipeline(config: PipelineConfig): Promise<Record<string, unknown>> {
  const pipeline = new Pipeline(config)
  for (const stepId of STEP_IDS) {
    await pipeline.runStep(stepId).catch(() => undefined)
  }
  const steps = pipeline.getSteps().map((step) => ({
    id: step.id,
    status: step.status,
    skipKind: step.result?.skipKind ?? null,
  }))
  return { steps, finalArtifact: config.outputDirectory }
}

const WEB_UI = `<!doctype html>
<html lang="zh"><head><meta charset="utf-8"><title>DroidSeal Web</title>
<style>body{font-family:system-ui;max-width:860px;margin:24px auto;padding:0 16px;color:#222}
pre{background:#f5f5f5;padding:12px;border-radius:6px;overflow:auto}input,select{width:100%;margin:4px 0 10px;padding:6px}
button{padding:8px 18px;cursor:pointer}</style></head><body>
<h2>DroidSeal Web（本地 127.0.0.1）</h2>
<form id="f">
<label>输入类型</label><select id="kind"><option value="apk">APK</option><option value="project">项目目录</option></select>
<label>输入路径</label><input id="inputPath" placeholder="C:/path/app.apk 或 C:/path/android">
<label>签名</label><select id="signing"><option value="skip">不签名</option><option value="existing">使用签名库</option></select>
<label>签名库路径(optional)</label><input id="keystore"><label>别名(optional)</label><input id="alias">
<label>store 密码(optional)</label><input id="store" type="password">
<label><input type="checkbox" id="web"> 开启 Web JS 处理</label>
<label><input type="checkbox" id="arsc"> 开启资源名混淆</label>
<label><input type="checkbox" id="learning"> 测试与学习模式(保留中间产物)</label>
<button type="submit">运行流水线</button></form>
<h3>结果</h3><pre id="out">等待运行…</pre>
<script>
const form = document.getElementById('f');
form.addEventListener('submit', async (e) => {
  e.preventDefault();
  const body = {
    inputKind: document.getElementById('kind').value,
    inputPath: document.getElementById('inputPath').value,
    signingMode: document.getElementById('signing').value,
    keystorePath: document.getElementById('keystore').value || undefined,
    keyAlias: document.getElementById('alias').value || undefined,
    storePassword: document.getElementById('store').value || undefined,
    enableWebAssetMinification: document.getElementById('web').checked,
    enableArscObfuscation: document.getElementById('arsc').checked,
    keepIntermediates: document.getElementById('learning').checked,
  };
  document.getElementById('out').textContent = '运行中…';
  const res = await fetch('/run', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  document.getElementById('out').textContent = JSON.stringify(await res.json(), null, 2);
});
</script></body></html>`

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  let port = 8787
  let outputDir = path.resolve("droidseal-output")
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === "--port") port = Number(argv[++i])
    else if (argv[i] === "--output") outputDir = path.resolve(argv[++i]!)
  }
  const token = process.env.DROIDSEAL_SERVER_TOKEN

  const server = Bun.serve({
    port,
    hostname: "127.0.0.1",
    async fetch(request) {
      const url = new URL(request.url)
      if (token) {
        const auth = request.headers.get("authorization")
        if (auth !== `Bearer ${token}`) {
          return Response.json({ error: "unauthorized" }, { status: 401 })
        }
      }
      if (request.method === "POST" && url.pathname === "/run") {
        try {
          const body = (await request.json()) as RunRequest
          const config = buildConfig(body, outputDir)
          const result = await runPipeline(config)
          return Response.json({ ok: true, ...result })
        } catch (error) {
          return Response.json({ ok: false, error: error instanceof Error ? error.message : String(error) }, { status: 400 })
        }
      }
      if (request.method === "GET" && url.pathname.startsWith("/reports/")) {
        const relative = url.pathname.slice("/reports/".length)
        const target = path.resolve(outputDir, relative)
        if (!target.startsWith(path.resolve(outputDir))) return new Response("forbidden", { status: 403 })
        const content = await readFile(target, "utf8").catch(() => null)
        if (content === null) return new Response("not found", { status: 404 })
        return new Response(content, {
          headers: { "Content-Type": relative.endsWith(".json") ? "application/json" : "text/plain; charset=utf-8" },
        })
      }
      if (request.method === "GET" && url.pathname === "/") {
        return new Response(WEB_UI, { headers: { "Content-Type": "text/html; charset=utf-8" } })
      }
      return Response.json({ error: "not found" }, { status: 404 })
    },
  })
  console.log(`DroidSeal Web 服务：http://127.0.0.1:${server.port}（输出目录 ${outputDir}${token ? "，已启用 token 认证" : ""}）`)
}

main().catch((error) => {
  console.error(`启动失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
