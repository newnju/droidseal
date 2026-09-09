#!/usr/bin/env bun
import { createCliRenderer } from "@opentui/core"
import { render } from "@opentui/solid"
import { VERSION } from "./brand.ts"
import { createToolRecoveryPlan } from "./core/tool-installer.ts"
import { discoverToolchain } from "./core/toolchain.ts"
import { theme } from "./ui/theme.ts"
import { App } from "./ui/app.tsx"
import { Pipeline, STEP_DEFINITIONS } from "./core/pipeline.ts"

const args = process.argv.slice(2)

// ── 通用 CLI 参数解析 ──────────────────────────────────────────────────

function getArg(flag: string): string | undefined {
  const idx = args.indexOf(flag)
  return idx >= 0 && idx + 1 < args.length ? args[idx + 1] : undefined
}
function hasFlag(flag: string): boolean { return args.includes(flag) }
function collectMulti(flag: string): string[] {
  const result: string[] = []
  for (let i = 0; i < args.length; i += 1) {
    if (args[i] === flag && args[i + 1]) result.push(args[i + 1]!)
  }
  return result
}

// ── 用法 ──────────────────────────────────────────────────────────────

function usage(): string {
  return `droidseal ${VERSION} — Android Release Seal

用法:
  droidseal                       打开交互式 TUI(默认)
  droidseal scan <input> [选项]   非交互审计(APK/项目源码)
  droidseal harden <input> [选项] 非交互加固(APK→加密+保护+重打包)
  droidseal doctor                环境诊断(JSON 输出)
  droidseal --help                显示帮助
  droidseal --version             显示版本

通用选项:
  --output <dir>           输出目录
  --json                   JSON 格式输出(适合 CI/CD)

scan 子命令(审计):
  droidseal scan <input.apk | project-dir> [选项]
    --package <name>         包名(默认:自动提取)
    --app <class>            Application 类名(默认:自动提取)
    --rules <file>           自定义检测规则文件(JSON/Semgrep YAML)
    --behavior <file>        自定义行为规则文件
    --taint <file>           污点规则文件
    --key-formats <file>     密钥格式文件
    --no-alignment           跳过 zipalign
    --no-web-minify          跳过 Web 资源压缩
    --arsc-obfuscate         启用资源名混淆

harden 子命令(加固):
  droidseal harden <input.apk> [选项]
    --package <name>         包名(默认:自动提取)
    --app <class>            原始 Application 类名
    --algorithm <alg>        加密算法:aes-256-gcm(默认) | chacha20-poly1305
    --cert-sha256 <hash>     签名证书 SHA-256(密钥派生)
    --no-dex                 禁用 DEX 加密
    --no-so                  禁用 SO 加密
    --no-resource            禁用资源加密
    --no-string              禁用字符串加密
    --no-runtime             禁用运行时保护
    --enable-vmp             启用 VMP 虚拟机保护
    --no-split-key           禁用 Split-Key 混淆
    --no-triple-entry        禁用三重入口
    --no-random-names        禁用随机包名/SO名
    --exclude <pattern>      类排除规则(可多次指定)
    --keystore <path>        签名密钥库路径
    --ks-alias <alias>       密钥别名
    --ks-pass <password>     密钥库密码
    --key-pass <password>    密钥密码

batch 子命令(批量审计):
  droidseal batch <清单.json | --dir <APK目录>> [选项]
    --base <url>             REST API 地址(默认:http://127.0.0.1:8787)
    --token <token>          Bearer 认证令牌
    --parallel <N>           并发数(默认:1)
    --retry <N>              失败重试次数(默认:0)

TUI 内置命令:
  /guided    分步处理(每步确认)
  /oneclick  一键处理(全自动)
  /doctor    环境诊断
  /restart   返回首页
  /quit      退出
`
}

// ── 命令分发 ──────────────────────────────────────────────────────────

if (hasFlag("--help") || hasFlag("-h")) { console.log(usage()); process.exit(0) }
if (hasFlag("--version") || hasFlag("-v")) { console.log(VERSION); process.exit(0) }

// ── doctor ──────────────────────────────────────────────────────────────

if (args[0] === "doctor") {
  const result = await discoverToolchain()
  const recovery = createToolRecoveryPlan(undefined, result)
  const jsonData = {
    ...result,
    recovery: {
      missing: recovery.missing.map((tool) => tool.name),
      canAutoInstallInTui: recovery.canAutoInstall,
      instructions: recovery.manualInstructions,
    },
  }
  if (hasFlag("--json")) {
    console.log(JSON.stringify(jsonData, null, 2))
  } else {
    console.log(`DroidSeal 环境诊断`)
    console.log("")
    const tc = result as any
    const has = (v: any) => v?.path ? `✓ ${v.version ?? ""} (${v.path})` : "✗ 未找到"
    console.log(`  JDK:       ${has(tc.java)}`)
    console.log(`  keytool:   ${has(tc.keytool)}`)
    console.log(`  aapt2:     ${has(tc.aapt)}`)
    console.log(`  apksigner: ${has(tc.apksigner)}`)
    console.log(`  zipalign:  ${has(tc.zipalign)}`)
    if (recovery.missing.length > 0) {
      console.log(`\n缺失 ${recovery.missing.length} 个工具:`)
      for (const tool of recovery.missing) console.log(`  - ${tool.name}`)
      if (recovery.manualInstructions) console.log(`\n${recovery.manualInstructions}`)
    } else {
      console.log("\n✓ 所有工具就绪")
    }
  }
  process.exit(0)
}

// ── scan(非交互审计) ──────────────────────────────────────────────────

if (args[0] === "scan") {
  const inputPath = args[1]
  if (!inputPath) {
    console.error("用法: droidseal scan <input.apk | project-dir> [选项]")
    process.exit(1)
  }
  const { Pipeline } = await import("./core/pipeline.ts")
  const isApk = inputPath.toLowerCase().endsWith(".apk")
  const outputDir = getArg("--output") ?? (isApk ? "./audit-report" : "./build/droidseal-report")
  const config = {
    runMode: "one-click" as const,
    inputKind: isApk ? "apk" as const : "project" as const,
    inputPath,
    outputDirectory: outputDir,
    gradleTask: "assembleRelease",
    buildMode: "full" as const,
    enableAlignment: !hasFlag("--no-alignment"),
    enableWebAssetMinification: !hasFlag("--no-web-minify"),
    enableArscObfuscation: hasFlag("--arsc-obfuscate"),
    customRulesFile: getArg("--rules") ?? undefined,
    behaviorRulesFile: getArg("--behavior") ?? undefined,
    taintRulesFile: getArg("--taint") ?? undefined,
    keyFormatsFile: getArg("--key-formats") ?? undefined,
    packageName: getArg("--package") ?? undefined,
    applicationClass: getArg("--app") ?? undefined,
    signing: { mode: "skip" as const },
    protection: { mode: "local-safe" as const },
  } as import("./core/types.ts").PipelineConfig
  const continueOnError = hasFlag("--continue-on-error")
  console.log(`DroidSeal 审计启动`)
  console.log(`  输入: ${config.inputPath}`)
  console.log(`  类型: ${config.inputKind}`)
  console.log(`  输出: ${config.outputDirectory}`)
  console.log("")
  try {
    const pipeline = new Pipeline(config)
    const results: Record<string, unknown> = {}
    let failedStep = ""
    for (const def of STEP_DEFINITIONS) {
      const result = await pipeline.runStep(def.id)
      results[def.id] = result
      if (result.status === "failed") {
        console.error(`  ✗ ${def.title}: ${result.summary}`)
        failedStep = def.id
        if (!continueOnError) break
      } else {
        console.log(`  ✓ ${def.title}: ${result.summary}`)
      }
    }
    const allFindings = (pipeline as any).context?.audit?.findings ?? []
    const reportDir = (pipeline as any).context?.reportDirectory ?? config.outputDirectory
    if (hasFlag("--json")) {
      console.log(JSON.stringify({ steps: results, findings: allFindings, reportDir }, null, 2))
    } else {
      const successCount = Object.values(results).filter((r: any) => r.status === "success").length
      console.log(`\n审计完成: ${successCount} 步成功${failedStep ? ` (${failedStep} 失败)` : ""}`)
      if (allFindings.length > 0) {
        console.log(`发现 ${allFindings.length} 条:`)
        for (const f of allFindings.slice(0, 30)) {
          console.log(`  [${f.severity}] ${f.title}`)
        }
        if (allFindings.length > 30) console.log(`  ... +${allFindings.length - 30} 条`)
      }
      console.log(`\n报告目录: ${reportDir}`)
    }
    process.exit(0)
  } catch (error) {
    console.error(`审计失败: ${error instanceof Error ? error.message : String(error)}`)
    process.exit(1)
  }
}

// ── harden(非交互加固) ──────────────────────────────────────────────────

if (args[0] === "harden") {
  const { runHardenPipeline, generateHardenReport, DEFAULT_HARDEN_CONFIG } = await import("./core/harden-pipeline.ts")
  const inputApk = args[1]
  if (!inputApk) {
    console.error("用法: droidseal harden <input.apk> [选项]")
    process.exit(1)
  }
  const excludePatterns = collectMulti("--exclude")
  const config = {
    ...DEFAULT_HARDEN_CONFIG,
    inputApk,
    outputDir: getArg("--output") ?? "./hardened",
    packageName: getArg("--package") ?? "com.droidseal.protected",
    originalApplication: getArg("--app") ?? "android.app.Application",
    algorithm: (getArg("--algorithm") as "aes-256-gcm" | "chacha20-poly1305") ?? "aes-256-gcm",
    certSha256: getArg("--cert-sha256") ?? undefined,
    enableDexEncryption: !hasFlag("--no-dex"),
    enableMethodHollow: !hasFlag("--no-dex"),
    enableSoEncryption: !hasFlag("--no-so"),
    enableResourceEncryption: !hasFlag("--no-resource"),
    enableStringEncryption: !hasFlag("--no-string"),
    enableRuntimeProtection: !hasFlag("--no-runtime"),
    enableVmProtection: hasFlag("--enable-vmp"),
    enableSplitKey: !hasFlag("--no-split-key"),
    enableTripleEntry: !hasFlag("--no-triple-entry"),
    enableRandomNames: !hasFlag("--no-random-names"),
    classExclusionPatterns: excludePatterns,
    signingConfig: getArg("--keystore") ? {
      mode: "keystore" as const,
      keystorePath: getArg("--keystore")!,
      keyAlias: getArg("--ks-alias") ?? "droidseal",
      storePassword: getArg("--ks-pass") ?? "droidseal123",
      keyPassword: getArg("--key-pass") ?? getArg("--ks-pass") ?? "droidseal123",
    } : undefined,
  }
  console.log(`DroidSeal 加固流水线启动`)
  console.log(`  输入: ${config.inputApk}`)
  console.log(`  输出: ${config.outputDir}`)
  console.log(`  算法: ${config.algorithm}`)
  console.log(`  Split-Key: ${config.enableSplitKey ? "是" : "否"}`)
  console.log(`  三重入口: ${config.enableTripleEntry ? "是" : "否"}`)
  console.log("")
  try {
    const result = await runHardenPipeline(config)
    if (hasFlag("--json")) {
      console.log(JSON.stringify(result, null, 2))
    } else {
      console.log(generateHardenReport(result))
      if (result.generatedFiles.length > 0) {
        const { mkdir: mkd, writeFile: wf } = await import("node:fs/promises")
        await mkd(config.outputDir, { recursive: true })
        for (const file of result.generatedFiles) {
          const outPath = `${config.outputDir}/${file.name}`
          await mkd(outPath.replace(/\/[^/]+$/, ""), { recursive: true })
          await wf(outPath, file.content, "utf8")
        }
        console.log(`\n已输出 ${result.generatedFiles.length} 个文件到 ${config.outputDir}/`)
      }
      if (result.outputApk) {
        const { stat } = await import("node:fs/promises")
        const info = await stat(result.outputApk).catch(() => null)
        console.log(`\n加固 APK: ${result.outputApk}`)
        if (info) console.log(`  大小: ${(info.size / 1024 / 1024).toFixed(1)} MiB`)
        if (result.keyMaterial) console.log(`  密钥来源: ${result.keyMaterial.derivedFrom}`)
      }
    }
    process.exit(result.success ? 0 : 1)
  } catch (error) {
    console.error(`加固失败: ${error instanceof Error ? error.message : String(error)}`)
    process.exit(1)
  }
}

// ── batch(批量审计) ──────────────────────────────────────────────────────

if (args[0] === "batch") {
  const { readFile: rf, readdir } = await import("node:fs/promises")
  const p = await import("node:path")

  const dirMode = args[1] === "--dir"
  const manifestPath = dirMode ? args[2] : args[1]
  if (!manifestPath) {
    console.error("用法: droidseal batch <清单.json> [选项]  或  droidseal batch --dir <APK目录> [选项]")
    process.exit(1)
  }

  const base = getArg("--base") ?? "http://127.0.0.1:8787"
  const token = getArg("--token")
  const parallel = parseInt(getArg("--parallel") ?? "1", 10) || 1
  const retry = parseInt(getArg("--retry") ?? "0", 10) || 0

  interface BatchItem { name: string; inputKind: "apk" | "project"; inputPath: string; signingMode: string }
  let items: BatchItem[]

  if (dirMode) {
    const entries = await readdir(manifestPath, { recursive: true }).catch(() => [] as string[])
    const apks = entries.filter((e: string) => e.toLowerCase().endsWith(".apk"))
    if (apks.length === 0) { console.error(`目录中未找到 APK: ${manifestPath}`); process.exit(1) }
    items = apks.map((entry: string) => ({
      name: p.basename(entry),
      inputKind: "apk" as const,
      inputPath: p.join(manifestPath, entry),
      signingMode: "skip",
    }))
    console.log(`目录批量模式:发现 ${items.length} 个 APK`)
  } else {
    items = JSON.parse(await rf(manifestPath, "utf8")) as BatchItem[]
  }
  if (items.length === 0) { console.error("清单为空"); process.exit(1) }

  const headers: Record<string, string> = { "Content-Type": "application/json" }
  if (token) headers["Authorization"] = `Bearer ${token}`

  interface RunResult { name: string; ok: boolean; seconds: number; stepsOk: number; gate?: string | undefined; error?: string | undefined }
  const results: RunResult[] = []
  const startedAt = Date.now()

  const runOne = async (index: number): Promise<void> => {
    const item = items[index]!
    const t0 = Date.now()
    let failure: string | undefined
    let attempts = 0
    while (attempts <= retry) {
      attempts += 1
      try {
        const res = await fetch(`${base}/run`, { method: "POST", headers, body: JSON.stringify(item) })
        const data: any = await res.json().catch(() => null)
        if (!data || data.ok !== true) { failure = data?.error?.message ?? `HTTP ${res.status}`; continue }
        const seconds = (Date.now() - t0) / 1000
        const stepsOk = data.steps?.filter((s: any) => s.status === "success").length ?? 0
        console.log(`[${index + 1}/${items.length}] ${item.name} ✓ ${seconds.toFixed(1)}s ${stepsOk}步${data.gate ? ` 门禁:${data.gate}` : ""}${attempts > 1 ? ` 重试${attempts - 1}次` : ""}`)
        results[index] = { name: item.name, ok: true, seconds, stepsOk, gate: data.gate }
        return
      } catch { failure = "请求失败" }
    }
    const seconds = (Date.now() - t0) / 1000
    console.log(`[${index + 1}/${items.length}] ${item.name} ✗ ${seconds.toFixed(1)}s ${failure ?? ""}`)
    results[index] = { name: item.name, ok: false, seconds, stepsOk: 0, error: failure }
  }

  // 并发池
  let next = 0
  const workers = Array.from({ length: Math.min(parallel, items.length) }, async () => {
    while (true) { const idx = next++; if (idx >= items.length) return; await runOne(idx) }
  })
  await Promise.all(workers)

  const ok = results.filter((r) => r.ok).length
  const totalSeconds = ((Date.now() - startedAt) / 1000).toFixed(1)
  console.log(`\n===== 批量汇总 =====`)
  console.log(`成功 ${ok}/${results.length}  总耗时 ${totalSeconds}s`)
  for (const r of results) {
    console.log(`  ${r.ok ? "✓" : "✗"} ${r.name}${r.ok ? ` (${r.seconds.toFixed(1)}s, ${r.stepsOk}步)` : ` ${r.error ?? ""}`}`)
  }
  if (results.some((r) => r.gate === "block")) {
    console.log("\n检测到 block 门禁条目——非零退出(CI 门禁)")
    process.exitCode = 1
  }
  process.exit(ok < results.length ? 1 : 0)
}

// ── 未知子命令 ──────────────────────────────────────────────────────────

if (args[0] && !args[0].startsWith("-")) {
  console.error(`未知命令: ${args[0]}`)
  console.error("运行 droidseal --help 查看可用命令")
  process.exit(1)
}

// ── TUI 启动(默认) ──────────────────────────────────────────────────────

if (!process.stdin.isTTY || !process.stdout.isTTY) {
  console.error("DroidSeal TUI 需要交互式终端。使用 `droidseal scan` 或 `droidseal harden` 进行非交互操作。")
  process.stdin.resume()
  await new Promise<void>((resolve) => {
    const done = () => resolve()
    process.stdin.once("data", done)
    process.stdin.once("end", done)
    setTimeout(done, 5_000)
  })
  process.exit(2)
}

const renderer = await createCliRenderer({
  exitOnCtrlC: true,
  useMouse: true,
  enableMouseMovement: true,
  targetFps: 60,
  maxFps: 60,
  gatherStats: false,
  autoFocus: false,
  screenMode: "alternate-screen",
  backgroundColor: theme.background,
  openConsoleOnError: false,
  useKittyKeyboard: {
    disambiguate: true,
    alternateKeys: true,
  },
})

await render(() => <App />, renderer)
