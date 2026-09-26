#!/usr/bin/env bun
import { readFile, writeFile, mkdir } from "node:fs/promises"
import path from "node:path"
import { VERSION } from "./brand.ts"
import { createToolRecoveryPlan } from "./core/tool-installer.ts"
import { discoverToolchain } from "./core/toolchain.ts"
import { Pipeline, STEP_DEFINITIONS } from "./core/pipeline.ts"

const args = process.argv.slice(2)

// ── 通用 CLI 参数解析 ──────────────────────────────────────────────────

function getArg(flag: string): string | undefined {
  const idx = args.indexOf(flag)
  // 下一个参数若仍是 flag(-- 开头)不当作值吞掉:防止 `--challenge-url --keystore-bind`
  // 把开关名当 URL 补进 loader DEX(有 https:// 校验兜底,但提前判定才能触发警告)
  if (idx < 0 || idx + 1 >= args.length || args[idx + 1]!.startsWith("--")) return undefined
  return args[idx + 1]
}
function hasFlag(flag: string): boolean { return args.includes(flag) }
function collectMulti(flag: string): string[] {
  const result: string[] = []
  for (let i = 0; i < args.length; i += 1) {
    if (args[i] === flag && args[i + 1] && !args[i + 1]!.startsWith("--")) result.push(args[i + 1]!)
  }
  return result
}

// ── 判断输入是否为 APK ────────────────────────────────────────────────

function isApkInput(p: string): boolean {
  return p.toLowerCase().endsWith(".apk")
}

// ── 用法 ──────────────────────────────────────────────────────────────

function usage(): string {
  return `droidseal ${VERSION} — Android Release Seal

用法:
  droidseal <input> [选项]          审计+加固全流程(APK),或仅审计(项目)
  droidseal doctor                  环境诊断
  droidseal batch <清单|目录> [选项] 批量审计
  droidseal --help                  显示帮助
  droidseal --version               显示版本

流程控制:
  --continue-on-error      审计失败不中断

审计选项:
  --package <name>         包名(默认:自动提取)
  --app <class>            Application 类名(默认:自动提取)
  --output <dir>           输出目录
  --rules <file>           自定义检测规则(JSON/Semgrep YAML)
  --behavior <file>        自定义行为规则
  --taint <file>           污点规则文件
  --key-formats <file>     密钥格式文件
  --no-alignment           跳过 zipalign
  --no-web-minify          跳过 Web 资源压缩
  --arsc-obfuscate         启用资源名混淆

加固选项:
  --profile <quick|balanced|maximum>  预设档(默认 balanced):quick=最快出包(关抽取/
                           字符串加密/三重入口/随机名,保留 DEX 加密);maximum=全开。
                           显式单 flag 永远优先于预设值
  --algorithm <aes-256-gcm|chacha20-poly1305>  加密算法(默认:aes-256-gcm)
  --cert-sha256 <hash>     签名证书 SHA-256(密钥派生)
  --no-dex                 禁用 DEX 加密
  --no-so                  禁用 SO 加密
  --no-resource            禁用资源加密
  --no-string              禁用字符串加密
  --no-runtime             禁用运行时保护
  --enable-vmp             启用 VMP 虚拟机保护
  --no-split-key           禁用 Split-Key 混淆
  --no-triple-entry        禁用三重入口
  --no-random-names        禁用随机包名/SO 名
  --exclude <pattern>      类排除规则(可多次指定)
  --keystore <path>        签名密钥库路径
  --ks-alias <alias>       密钥别名
  --ks-pass <password>     密钥库密码
  --key-pass <password>    密钥密码
  --keystore-bind          Android Keystore 设备绑定(首次运行后密钥封存进硬件;
                           卸载重装/清除数据/换机即失效且无法恢复——一机一份分发用)
  --keep-intermediates     保留 native/smali 等中间产物(测试学习模式;默认经典模式
                           流水线结束即清理,只留最终 APK)
  --challenge-url <url>    服务端挑战(可选):密钥第三段 part3 不进 APK,构建产物旁生成
                           server-challenge.json 部署到该 HTTPS URL;运行时联网取片,
                           离线/被拒则解密失败。丢失 server-challenge.json 该构建永久无法解密

通用选项:
  --json                   JSON 格式输出(适合 CI/CD)

batch 子命令:
  droidseal batch <目标> [选项]
    目标:目录(扫描*.apk) 或 JSON清单文件
    --base <url>           REST API 地址(默认:http://127.0.0.1:8787)
    --token <token>        Bearer 认证令牌
    --parallel <N>         并发数(默认:1)
    --retry <N>            失败重试次数(默认:0)
    --report <file>        汇总报告输出路径(默认:batch-report.json)

TUI 内置命令:
  /guided    分步处理
  /oneclick  一键处理
  /doctor    环境诊断
  /restart   返回首页
  /quit      退出
`
}

// ── 命令分发 ──────────────────────────────────────────────────────────

if (hasFlag("--help") || hasFlag("-h")) { console.log(usage()); process.exit(0) }
if (hasFlag("--version") || hasFlag("-v")) { console.log(VERSION); process.exit(0) }

// ── bench(一键基准评测,与 Rust 版同口径)────────────────────────────

if (args[0] === "bench") {
  const { loadSuite, runSuite, renderMd, renderJson } = await import("./core/bench.ts")
  const spec = args[1]
  if (!spec || spec.startsWith("--")) {
    console.error("用法: droidseal bench <suite.json | 数据集目录> [--format md|json] [--max-fp N] [--min-recall X] [--out <file>]")
    console.error("  语义 GT:数据集目录旁 droidbench-map.json(README 语义 map)或套件配置 gt_file(per-case expected)")
    process.exit(1)
  }
  const flagVal = (name: string): string | undefined => {
    const i = args.indexOf(name)
    return i >= 0 ? args[i + 1] : undefined
  }
  const format = (flagVal("--format") ?? "md").toLowerCase()
  const maxFp = flagVal("--max-fp") ? Number(flagVal("--max-fp")) : undefined
  const minRecall = flagVal("--min-recall") ? Number(flagVal("--min-recall")) : undefined
  const out = flagVal("--out")
  try {
    const suites = await loadSuite(spec)
    let body = ""
    const gateFails: string[] = []
    for (const s of suites) {
      const r = await runSuite(s)
      if (maxFp !== undefined && r.fp > maxFp) gateFails.push(`套件 ${r.suite}: FP=${r.fp} 超上限 ${maxFp}`)
      if (minRecall !== undefined && r.recall !== null && r.recall < minRecall) gateFails.push(`套件 ${r.suite}: Recall ${r.recall}% 低于下限 ${minRecall}%`)
      body += format === "json" ? renderJson(r) : renderMd(r)
      // 流级对判:generic 套件(带 *_findings.json 的真实样本)自动执行——与 Rust 版同口径
      if (s.kind === "generic") {
        const { summarizeFlow, renderFlowMd } = await import("./core/bench-flow.ts")
        const fs_ = await summarizeFlow(s.projects_dir).catch(() => null)
        if (fs_ && format !== "json") body += renderFlowMd(fs_)
      } else if (format !== "json") {
        body += "\n> **评分粒度声明**:该套件 GT 为 app 级(expected 标注,无官方流级 findings),仅 app 级评分;流级判定适用于自带 findings.json 的套件(如 TaintBench)。\n"
      }
    }
    if (out) {
      await mkdir(path.dirname(path.resolve(out)), { recursive: true }).catch(() => {})
      await writeFile(out, body, "utf8")
      console.log(`报告已写入 ${out}`)
    } else {
      console.log(body)
    }
    if (gateFails.length > 0) {
      for (const g of gateFails) console.error(`✗ 门控不达标: ${g}`)
      process.exit(1)
    }
  } catch (e) {
    console.error(`✗ bench 失败: ${e instanceof Error ? e.message : e}`)
    process.exit(1)
  }
  process.exit(0)
}

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
  if (!hasFlag("--text") && !hasFlag("--human")) {
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

// ── unified / scan / harden(统一命令 + 向后兼容别名) ────────────────────

function resolveInputAndMode(): { inputPath: string; mode: "full" } | undefined {
  // 统一命令: droidseal <input> (排除已知子命令)
  if (args[0] && !args[0].startsWith("-") && args[0] !== "doctor" && args[0] !== "batch") {
    return { inputPath: args[0], mode: "full" }
  }
  return undefined
}

const resolved = resolveInputAndMode()

if (resolved && resolved.inputPath) {
  const { inputPath } = resolved
  const isApk = isApkInput(inputPath)
  const outputDir = getArg("--output") ?? (isApk ? "./droidseal-output" : "./build/droidseal-report")
  const continueOnError = hasFlag("--continue-on-error")
  const jsonOutput = hasFlag("--json")

  // ── Phase 1: 审计 ──────────────────────────────────────────────────

  let allFindings: any[] = []
  let auditSuccess = true

  // ── 审计 ──────────────────────────────────────────────────

  const auditConfig = {
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

  console.log(`DroidSeal 启动`)
  console.log(`  输入: ${inputPath}`)
  console.log(`  类型: ${isApk ? "APK" : "项目"}`)
  console.log(`  模式: 审计${isApk ? "+加固" : ""}`)
  console.log(`  输出: ${outputDir}`)
  console.log("")

  try {
    const pipeline = new Pipeline(auditConfig)
    const results: Record<string, unknown> = {}
    let failedStep = ""
    for (const def of STEP_DEFINITIONS) {
      const result = await pipeline.runStep(def.id)
      results[def.id] = result
      if (result.status === "failed") {
        console.error(`  ✗ ${def.title}: ${result.summary}`)
        failedStep = def.id
        if (!continueOnError) { auditSuccess = false; break }
      } else {
        console.log(`  ✓ ${def.title}: ${result.summary}`)
      }
    }
    allFindings = (pipeline as any).context?.audit?.findings ?? []
    const reportDir = (pipeline as any).context?.reportDirectory ?? outputDir
    const successCount = Object.values(results).filter((r: any) => r.status === "success").length
    if (!jsonOutput) {
      console.log(`\n审计完成: ${successCount} 步成功${failedStep ? ` (${failedStep} 失败)` : ""}`)
      if (allFindings.length > 0) {
        console.log(`发现 ${allFindings.length} 条:`)
        for (const f of allFindings.slice(0, 30)) {
          console.log(`  [${f.severity}] ${f.title}`)
        }
        if (allFindings.length > 30) console.log(`  ... +${allFindings.length - 30} 条`)
      }
      console.log(`报告目录: ${reportDir}`)
    }
  } catch (error) {
    console.error(`审计失败: ${error instanceof Error ? error.message : String(error)}`)
    auditSuccess = false
  }

  // ── 加固(仅 APK 且审计成功时) ─────────────────────────────

  let hardenResult: any = undefined

  if (isApk && auditSuccess) {
    console.log(`\n${"─".repeat(40)}`)
    console.log(`加固流水线启动`)
    console.log("")

    const { runHardenPipeline, generateHardenReport, DEFAULT_HARDEN_CONFIG } = await import("./core/harden-pipeline.ts")
    const excludePatterns = collectMulti("--exclude")
    // P2 服务端挑战 URL(可选,--challenge-url)
    const challengeUrl = getArg("--challenge-url")
    if (hasFlag("--challenge-url") && !challengeUrl) {
      console.warn("警告: --challenge-url 后未提供 URL——本次构建按纯本地模式执行(密钥完整进 APK)。")
    }
    // profile 预设(参数组合糖,不新增流水线能力):
    //   quick    — 最快出包:关抽取/字符串加密/三重入口/随机名,保留 DEX 加密
    //   balanced — 默认档(与省略 --profile 完全一致)
    //   maximum  — 全开(含 --enable-vmp 传参;VMP 未接线时报告如实 not-wired)
    // 显式 flag 永远优先于预设(先算预设布尔,再被单 flag 覆盖)。
    const profileArg = (getArg("--profile") ?? "balanced").toLowerCase()
    const profiles: Record<string, { hollow: boolean; stringEnc: boolean; triple: boolean; randomNames: boolean; vmp: boolean }> = {
      quick: { hollow: false, stringEnc: false, triple: false, randomNames: false, vmp: false },
      balanced: { hollow: true, stringEnc: true, triple: true, randomNames: true, vmp: false },
      maximum: { hollow: true, stringEnc: true, triple: true, randomNames: true, vmp: true },
    }
    const profile = profiles[profileArg]
    if (!profile) {
      console.error(`错误: 未知 --profile "${profileArg}"(可选: quick / balanced / maximum)`)
      process.exit(2)
    }
    if (profileArg !== "balanced") console.log(`Profile: ${profileArg}`)
    const hardenConfig = {
      ...DEFAULT_HARDEN_CONFIG,
      inputApk: inputPath,
      outputDir: outputDir + "/hardened",
      packageName: getArg("--package") ?? "com.droidseal.protected",
      originalApplication: getArg("--app") ?? "android.app.Application",
      algorithm: (getArg("--algorithm") as "aes-256-gcm" | "chacha20-poly1305") ?? "aes-256-gcm",
      certSha256: getArg("--cert-sha256") ?? undefined,
      enableDexEncryption: !hasFlag("--no-dex"),
      enableMethodHollow: hasFlag("--no-dex") ? false : (profileArg === "balanced" ? !hasFlag("--no-dex") : profile.hollow),
      enableSoEncryption: !hasFlag("--no-so"),
      enableResourceEncryption: !hasFlag("--no-resource"),
      enableStringEncryption: profileArg === "balanced" ? !hasFlag("--no-string") : profile.stringEnc,
      enableRuntimeProtection: !hasFlag("--no-runtime"),
      enableVmProtection: hasFlag("--enable-vmp") || profile.vmp,
      enableSplitKey: !hasFlag("--no-split-key"),
      enableTripleEntry: profileArg === "balanced" ? !hasFlag("--no-triple-entry") : profile.triple,
      enableRandomNames: profileArg === "balanced" ? !hasFlag("--no-random-names") : profile.randomNames,
      enableKeystoreBinding: hasFlag("--keystore-bind"),
      classExclusionPatterns: excludePatterns,
      signingConfig: getArg("--keystore") ? {
        mode: "keystore" as const,
        keystorePath: getArg("--keystore")!,
        keyAlias: getArg("--ks-alias") ?? "droidseal",
        storePassword: getArg("--ks-pass") ?? "droidseal123",
        keyPassword: getArg("--key-pass") ?? getArg("--ks-pass") ?? "droidseal123",
      } : undefined,
      // 测试学习模式:保留 native/smali 等中间产物;经典模式(默认)流水线收尾会清理
      keepIntermediates: hasFlag("--keep-intermediates"),
      ...(challengeUrl ? { challengeUrl } : {}),
    }

    try {
      hardenResult = await runHardenPipeline(hardenConfig)
      if (!jsonOutput) {
        console.log(generateHardenReport(hardenResult))
        if (hardenResult.generatedFiles.length > 0 && hasFlag("--keep-intermediates")) {
          const { mkdir: mkd, writeFile: wf } = await import("node:fs/promises")
          await mkd(hardenConfig.outputDir, { recursive: true })
          for (const file of hardenResult.generatedFiles) {
            const outPath = `${hardenConfig.outputDir}/${file.name}`
            await mkd(outPath.replace(/\/[^/]+$/, ""), { recursive: true })
            await wf(outPath, file.content, "utf8")
          }
          console.log(`\n已输出 ${hardenResult.generatedFiles.length} 个文件到 ${hardenConfig.outputDir}/`)
        }
        if (hardenResult.outputApk) {
          const { stat } = await import("node:fs/promises")
          const info = await stat(hardenResult.outputApk).catch(() => null)
          console.log(`\n加固 APK: ${hardenResult.outputApk}`)
          if (info) console.log(`  大小: ${(info.size / 1024 / 1024).toFixed(1)} MiB`)
          if (hardenResult.keyMaterial) console.log(`  密钥来源: ${hardenResult.keyMaterial.derivedFrom}`)
        }
      }
    } catch (error) {
      console.error(`加固失败: ${error instanceof Error ? error.message : String(error)}`)
      if (error instanceof Error && error.stack) console.error(error.stack)
    }
  }

  // ── JSON 输出 ──────────────────────────────────────────────────────

  if (jsonOutput) {
    const output: any = { inputPath, mode: "full", findings: allFindings }
    if (hardenResult) {
      output.harden = {
        success: hardenResult.success,
        outputApk: hardenResult.outputApk,
        summary: hardenResult.summary,
        generatedFiles: hardenResult.generatedFiles.length,
      }
    }
    console.log(JSON.stringify(output, null, 2))
  }

  process.exit(auditSuccess ? 0 : 1)
}

// ── batch(批量审计) ──────────────────────────────────────────────────────

if (args[0] === "batch") {
  const { readdir, writeFile: wf, stat: fstat } = await import("node:fs/promises")
  const p = await import("node:path")

  const target = args[1]
  if (!target || target.startsWith("-")) {
    console.error("用法: droidseal batch <目录或清单.json> [--output <dir>] [--report <file>]")
    process.exit(1)
  }

  const targetStat = await fstat(target).catch(() => null)
  const isDir = targetStat?.isDirectory() ?? false
  const isFile = targetStat?.isFile() ?? false

  const parallel = parseInt(getArg("--parallel") ?? "1", 10) || 1
  const reportPath = getArg("--report") ?? "batch-report.json"

  interface BatchItem { name: string; inputPath: string }
  let items: BatchItem[]

  if (isDir) {
    const entries = await readdir(target, { recursive: true }).catch(() => [] as string[])
    const apks = entries.filter((e: string) => e.toLowerCase().endsWith(".apk"))
    if (apks.length === 0) { console.error(`目录中未找到 APK: ${target}`); process.exit(1) }
    items = apks.map((entry: string) => ({
      name: p.basename(entry),
      inputPath: p.resolve(p.join(target, entry)),
    }))
  } else if (isFile) {
    const raw = JSON.parse(await readFile(target, "utf8")) as Array<{ name?: string; inputPath: string }>
    items = raw.map((r) => ({ name: r.name ?? p.basename(r.inputPath), inputPath: r.inputPath }))
  } else {
    console.error(`目标不存在: ${target}`)
    process.exit(1)
  }
  if (items.length === 0) { console.error("清单为空"); process.exit(1) }

  const batchOutputDir = getArg("--output") ?? p.join(p.dirname(items[0]!.inputPath), "droidseal-batch-output")

  console.log(`DroidSeal 批量审计(本地执行)`)
  console.log(`  目标: ${target} (${isDir ? "目录" : "清单"})`)
  console.log(`  数量: ${items.length} 个`)
  console.log(`  并发: ${parallel}`)
  console.log(`  输出: ${batchOutputDir}`)
  console.log("")

  interface RunResult { name: string; inputPath: string; ok: boolean; seconds: number; stepsOk: number; stepsFailed: number; findings: number; error?: string }
  const results: RunResult[] = []
  const startedAt = Date.now()

  let completed = 0
  const progressBar = () => {
    const pct = Math.round((completed / items.length) * 100)
    const filled = Math.round((completed / items.length) * 30)
    const bar = "█".repeat(filled) + "░".repeat(30 - filled)
    process.stderr.write(`\r  [${bar}] ${pct}% ${completed}/${items.length}`)
  }
  progressBar()

  const runOne = async (index: number): Promise<void> => {
    const item = items[index]!
    const t0 = Date.now()
    const isApk = item.inputPath.toLowerCase().endsWith(".apk")
    const itemOutputDir = p.join(batchOutputDir, item.name.replace(/\.apk$/i, ""))

    try {
      const auditConfig = {
        runMode: "one-click" as const,
        inputKind: isApk ? "apk" as const : "project" as const,
        inputPath: item.inputPath,
        outputDirectory: itemOutputDir,
        gradleTask: "assembleRelease",
        buildMode: "full" as const,
        enableAlignment: true,
        enableWebAssetMinification: true,
        enableArscObfuscation: false,
        signing: { mode: "skip" as const },
        protection: { mode: "local-safe" as const },
      } as import("./core/types.ts").PipelineConfig

      const pipeline = new Pipeline(auditConfig)
      const stepResults: Record<string, unknown> = {}
      for (const def of STEP_DEFINITIONS) {
        const result = await pipeline.runStep(def.id)
        stepResults[def.id] = result
      }
      const allFindings = (pipeline as any).context?.audit?.findings ?? []
      const seconds = (Date.now() - t0) / 1000
      const stepsOk = Object.values(stepResults).filter((r: any) => r.status === "success").length
      const stepsFailed = Object.values(stepResults).filter((r: any) => r.status === "failed").length

      results[index] = { name: item.name, inputPath: item.inputPath, ok: true, seconds, stepsOk, stepsFailed, findings: allFindings.length }
      completed++
      progressBar()
    } catch (error) {
      const seconds = (Date.now() - t0) / 1000
      results[index] = { name: item.name, inputPath: item.inputPath, ok: false, seconds, stepsOk: 0, stepsFailed: 0, findings: 0, error: error instanceof Error ? error.message : String(error) }
      completed++
      progressBar()
    }
  }

  // 并发池
  let next = 0
  const workers = Array.from({ length: Math.min(parallel, items.length) }, async () => {
    while (true) { const idx = next++; if (idx >= items.length) return; await runOne(idx) }
  })
  await Promise.all(workers)
  process.stderr.write("\r" + " ".repeat(80) + "\r")

  // 汇总
  const ok = results.filter((r) => r.ok).length
  const failed = results.filter((r) => !r.ok).length
  const totalSeconds = ((Date.now() - startedAt) / 1000).toFixed(1)
  const totalFindings = results.reduce((s, r) => s + r.findings, 0)

  console.log(`\n===== 批量汇总 =====`)
  console.log(`成功 ${ok}/${results.length}  失败 ${failed}  总耗时 ${totalSeconds}s  总发现 ${totalFindings} 条`)
  console.log("")
  for (const r of results) {
    if (r.ok) {
      console.log(`  ✓ ${r.name}  ${r.seconds.toFixed(1)}s  ${r.stepsOk}步  ${r.findings}条发现`)
    } else {
      console.log(`  ✗ ${r.name}  ${r.error ?? "未知错误"}`)
    }
  }

  // 汇总报告 JSON
  const report = {
    timestamp: new Date().toISOString(),
    target,
    total: results.length,
    success: ok,
    failed,
    totalSeconds: parseFloat(totalSeconds),
    totalFindings,
    outputDir: batchOutputDir,
    results,
  }
  await wf(reportPath, JSON.stringify(report, null, 2), "utf8").catch(() => undefined)
  console.log(`\n报告已保存: ${reportPath}`)
  console.log(`输出目录: ${batchOutputDir}`)

  if (failed > 0) process.exitCode = 1
  process.exit()
}

// ── 未知子命令 ──────────────────────────────────────────────────────────

if (args[0] && !args[0].startsWith("-")) {
  console.error(`未知命令: ${args[0]}`)
  console.error("运行 droidseal --help 查看可用命令")
  process.exit(1)
}

// ── TUI 启动(默认,动态加载——JSX/OpenTUI 依赖仅 TUI 分支需要) ──────────

if (!process.stdin.isTTY || !process.stdout.isTTY) {
  console.error("DroidSeal TUI 需要交互式终端。使用 `droidseal <apk>` 或 `droidseal scan` 进行非交互操作。")
  process.stdin.resume()
  await new Promise<void>((resolve) => {
    const done = () => resolve()
    process.stdin.once("data", done)
    process.stdin.once("end", done)
    setTimeout(done, 5_000)
  })
  process.exit(2)
}

await import("./ui/tui-main.tsx")
