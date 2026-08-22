import path from "node:path"
import { mkdir, readdir, readFile, stat, writeFile } from "node:fs/promises"
import { EDITION } from "../brand.ts"
import { writeRemediationBundle } from "./remediation.ts"
import { writeReleaseEvidence, type ReleaseEvidenceResult } from "./release-evidence.ts"
import {
  buildControlCoverage,
  effectiveFindingConfidence,
  evaluateReleaseDecision,
  type ControlCoverage,
  type ReleaseDecision,
  type ReleaseDecisionReason,
  type ReleaseDecisionStatus,
} from "./release-policy.ts"
import { writeSupplyChainArtifacts, type SupplyChainArtifactsResult } from "./sbom.ts"
import type {
  Finding,
  PipelineConfig,
  RunContext,
  SigningConfig,
  StepResult,
  ToolLocation,
  Toolchain,
} from "./types.ts"

export interface ReportPaths {
  json: string
  markdown: string
  junit: string
  remediationDirectory?: string
  remediationPlan?: string
  releaseEvidenceDirectory: string
  releaseEvidenceManifest: string
  sbom: string
  licenseReview: string
  releaseDecisionStatus: ReleaseDecisionStatus
}

function publicSigningConfig(signing: SigningConfig): Record<string, unknown> {
  if (signing.mode === "skip") return { mode: "skip" }
  if (signing.mode === "existing") {
    return {
      mode: signing.mode,
      keystorePath: signing.keystorePath,
      keyAlias: signing.keyAlias,
      storePassword: "<redacted>",
      keyPassword: "<redacted>",
    }
  }
  return {
    mode: signing.mode,
    keystorePath: signing.keystorePath,
    keyAlias: signing.keyAlias,
    storePassword: "<redacted>",
    keyPassword: "<redacted>",
    validityDays: signing.validityDays,
    keyAlgorithm: signing.keyAlgorithm,
    keySize: signing.keySize,
    distinguishedName: signing.distinguishedName,
  }
}

export function publicConfig(config: PipelineConfig): Record<string, unknown> {
  return {
    runMode: config.runMode,
    inputKind: config.inputKind,
    inputPath: config.inputPath,
    outputDirectory: config.outputDirectory,
    gradleTask: config.gradleTask,
    explicitBuiltApkPath: config.explicitBuiltApkPath,
    enableAlignment: config.enableAlignment,
    enableWebAssetMinification: config.enableWebAssetMinification ?? false,
    enableArscObfuscation: config.enableArscObfuscation ?? false,
    signing: publicSigningConfig(config.signing),
    protection: { mode: config.protection.mode },
  }
}

// 报告历史对比:与上一次运行(输出目录 runs 的倒数第二个)的发现对比
async function buildPreviousRunComparison(context: RunContext): Promise<Record<string, unknown> | null> {
  const runsRoot = path.join(context.config?.outputDirectory ?? "", ".droidseal", "runs")
  const ids = await readdir(runsRoot).catch(() => [] as string[])
  if (ids.length < 2) return null
  ids.sort()
  const previousId = ids[ids.length - 2]!
  const previousReport = path.join(runsRoot, previousId, "reports", "droidseal-report.json")
  const previous = await readFile(previousReport, "utf8").catch(() => null)
  if (!previous) return null
  const prev = JSON.parse(previous) as {
    audit?: { findings?: Array<{ code?: string }> }
    releaseDecision?: { status?: string }
  }
  const prevCodes = new Set((prev.audit?.findings ?? []).map((f) => f.code ?? "").filter(Boolean))
  const currentCodes = new Set(context.audit.findings.map((f) => f.code).filter(Boolean))
  return {
    previousRunId: previousId,
    previousGate: prev.releaseDecision?.status ?? null,
    eliminated: [...prevCodes].filter((c) => !currentCodes.has(c)),
    added: [...currentCodes].filter((c) => !prevCodes.has(c)),
    remaining: [...prevCodes].filter((c) => currentCodes.has(c)),
  }
}

async function buildHardeningEffectiveness(context: RunContext): Promise<Record<string, unknown>> {
  const sizeOf = async (p?: string): Promise<number | null> =>
    p ? (await stat(p).catch(() => undefined))?.size ?? null : null
  const originalBytes = await sizeOf(context.originalArtifact)
  const finalBytes = await sizeOf(context.finalArtifact)
  const sizeDeltaPercent =
    originalBytes && finalBytes ? Math.round(((finalBytes - originalBytes) / originalBytes) * 1000) / 10 : null
  const findingCount = (prefix: string): number =>
    context.audit.findings.filter((f) => f.code.startsWith(prefix)).length
  const stepOk = (id: string): boolean => context.stepResults.some((s) => s.id === id && s.status === "success")
  const dimensions = [
    { key: "signatureVerification", covered: context.signatureVerified === true },
    { key: "apkAudit", covered: stepOk("apk-audit") },
    { key: "nativeAudit", covered: stepOk("apk-audit") },
    { key: "debuggableNormalization", covered: stepOk("harden") },
    { key: "resourceNameObfuscation", covered: stepOk("arsc-obfuscate") },
    { key: "webAssetProcessing", covered: stepOk("web-assets") },
    { key: "signingIntegrityChecks", covered: findingCount("SIGNING_") > 0 },
  ]
  const covered = dimensions.filter((d) => d.covered).length
  return {
    originalBytes,
    finalBytes,
    sizeDeltaPercent,
    dexFindings: findingCount("DEX_"),
    soFindings: findingCount("SO_"),
    coverage: { total: dimensions.length, covered, dimensions },
  }
}

async function previousRunMarkdown(context: RunContext): Promise<string> {
  const previousRun = await buildPreviousRunComparison(context)
  if (!previousRun) return "- 无历史运行可对比。"
  const join = (values: unknown): string => (values as string[]).join("、") || "无"
  return `- 上次门禁：${(previousRun.previousGate as string | null) ?? "未知"}
- 消除：${join(previousRun.eliminated)}
- 新增：${join(previousRun.added)}
- 剩余：${join(previousRun.remaining)}`
}

async function hardeningEffectivenessMarkdown(context: RunContext): Promise<string> {
  const effect = await buildHardeningEffectiveness(context)
  const original = effect.originalBytes as number | null
  const final = effect.finalBytes as number | null
  const delta = effect.sizeDeltaPercent as number | null
  const coverage = effect.coverage as { total: number; covered: number; dimensions: Array<{ key: string; covered: boolean }> }
  const size = (b: number | null): string => (b === null ? "未知" : `${b} 字节`)
  const dims = coverage.dimensions.map((d) => `\`${d.key}\`${d.covered ? " ✓" : " —"}`).join("、")
  return `- 产物大小：原始 ${size(original)} → 最终 ${size(final)}（${delta === null ? "未知" : `${delta}%`}）
- 敏感项计数：DEX 相关发现 ${effect.dexFindings as number} 条、SO 相关发现 ${effect.soFindings as number} 条
- 加固覆盖：${coverage.covered}/${coverage.total} 项（${dims}）
`
}

function toolchainForReport(toolchain: Toolchain | undefined): Record<string, unknown> | undefined {
  if (!toolchain) return undefined
  const serialize = (tool: ToolLocation) => ({
    name: tool.name,
    path: tool.path,
    source: tool.source,
    requiredFor: tool.requiredFor,
    detail: tool.detail,
  })
  const knownGoodVersions = {
    "JDK": "21（Adoptium Temurin，DroidSeal 管理安装）",
    "Android Build Tools": "30+（aapt / zipalign / apksigner）",
    "apksigner": "30.0.0+（支持 v1–v4 签名方案）",
    "Gradle Wrapper": "由目标项目提供（需匹配 AGP 版本）",
  }
  return {
    java: serialize(toolchain.java),
    keytool: serialize(toolchain.keytool),
    aapt: serialize(toolchain.aapt),
    zipalign: serialize(toolchain.zipalign),
    apksigner: serialize(toolchain.apksigner),
    gradleWrapper: serialize(toolchain.gradleWrapper),
    androidSdkRoot: toolchain.androidSdkRoot,
    buildToolsVersion: toolchain.buildToolsVersion,
    knownGoodVersions,
  }
}

function resultForReport(result: StepResult): Record<string, unknown> {
  return {
    ...result,
    command: result.command
      ? {
          ...result.command,
          stdout: result.command.stdout.slice(0, 100_000),
          stderr: result.command.stderr.slice(0, 100_000),
        }
      : undefined,
  }
}

function severityLabel(severity: Finding["severity"]): string {
  const labels: Record<Finding["severity"], string> = {
    critical: "严重",
    high: "高",
    medium: "中",
    low: "低",
    info: "信息",
  }
  return labels[severity]
}
function confidenceLabel(finding: Finding): string {
  const labels = {
    confirmed: "已确认（配置/结构证据）",
    high: "高",
    medium: "中",
    low: "低·待核验",
  } as const
  return labels[effectiveFindingConfidence(finding)]
}

const CONFIDENCE_RANK = {
  confirmed: 0,
  high: 1,
  medium: 2,
  low: 3,
} as const

const SEVERITY_RANK: Record<Finding["severity"], number> = {
  critical: 0,
  high: 1,
  medium: 2,
  low: 3,
  info: 4,
}

// Order findings by descending severity for output. Stable: findings of equal severity
// keep their original (step/insertion) order. Does not mutate the input array.
export function sortFindingsBySeverity(findings: readonly Finding[]): Finding[] {
  return findings
    .map((finding, index) => ({ finding, index }))
    .sort((a, b) =>
      SEVERITY_RANK[a.finding.severity] - SEVERITY_RANK[b.finding.severity] ||
      CONFIDENCE_RANK[effectiveFindingConfidence(a.finding)] - CONFIDENCE_RANK[effectiveFindingConfidence(b.finding)] || a.index - b.index,
    )
    .map((entry) => entry.finding)
}

function stepStatusLabel(result: StepResult): string {
  if (result.status === "success") return "成功"
  if (result.status === "failed") return "失败并回退"
  const skipLabels = {
    "not-applicable": "不适用",
    "user-choice": "用户选择",
    configuration: "按配置",
    safety: "安全保护",
    "missing-input": "缺少前置 APK",
  } as const
  return `跳过：${result.skipKind ? skipLabels[result.skipKind] : "已说明原因"}`
}

function markdownTable(results: StepResult[]): string {
  const lines = [
    "| 步骤 | 状态 | 用时 | 结果 |",
    "| --- | --- | ---: | --- |",
  ]
  for (const result of results) {
    lines.push(
      `| ${result.title.replaceAll("|", "\\|")} | ${stepStatusLabel(result)} | ${(result.durationMs / 1000).toFixed(1)}s | ${result.summary.replaceAll("|", "\\|")} |`,
    )
  }
  return lines.join("\n")
}

function findingsMarkdown(findings: Finding[]): string {
  if (findings.length === 0) return "未发现可报告的安全问题。"
  return findings
    .map(
      (finding, index) =>
        `### ${index + 1}. [${severityLabel(finding.severity)}] ${finding.title}\n\n` +
        `- 编号：\`${finding.code}\`\n` +
        `- 证据置信度：${confidenceLabel(finding)}\n` +
        `- 说明：${finding.detail}\n` +
        `- 建议：${finding.recommendation}\n` +
        (finding.evidence ? `- 证据：\`${finding.evidence.replaceAll("`", "\\`")}\`\n` : ""),
    )
    .join("\n")
}

function releaseEvidenceMarkdown(evidence: ReleaseEvidenceResult): string {
  const labels: Record<ReleaseEvidenceResult["status"], string> = {
    complete: "完整",
    partial: "部分归档",
    unresolved: "未解析变体",
    "not-applicable": "不适用（APK 输入）",
  }
  const archived = evidence.archivedFiles.length > 0
    ? evidence.archivedFiles.map((file) => `\`${file}\``).join("、")
    : "无"
  const missing = evidence.missing.length > 0
    ? evidence.missing
        .map((item) => `\`${item.fileName}\`（${item.required ? "必需" : "可选"}：${item.reason}）`)
        .join("；")
    : "无"
  return [
    `- 状态：${labels[evidence.status]}`,
    `- 证据清单：\`${evidence.manifestPath}\``,
    `- Gradle 变体：${evidence.variant ? `\`${evidence.variant}\`` : "未解析/不适用"}`,
    `- 已归档：${archived}`,
    `- 未归档：${missing}`,
  ].join("\n")
}
function supplyChainMarkdown(supplyChain: SupplyChainArtifactsResult): string {
  return [
    `- CycloneDX SBOM：\`${supplyChain.sbomPath}\``,
    `- 许可证待核验清单：\`${supplyChain.licenseReviewPath}\``,
    `- 组件：${supplyChain.componentCount}；未解析版本或仅观察到：${supplyChain.unresolvedCount}`,
    "- 许可证策略：离线不猜测；未知项保持 `NOASSERTION`，需用解析后的依赖锁、随包许可证/NOTICE 与法务审核确认。",
  ].join("\n")
}
function releaseReasonsMarkdown(reasons: readonly ReleaseDecisionReason[]): string {
  if (reasons.length === 0) return "无"
  return reasons
    .map((reason) => {
      const subject = reason.stepId
        ? `步骤 \`${reason.stepId}\``
        : reason.findingCode
          ? `发现 \`${reason.findingCode}\``
          : "全局"
      const severity = reason.severity ? ` [严重度 ${reason.severity}]` : ""
      return `- \`${reason.code}\`${severity}（${subject}）：${reason.message}`
    })
    .join("\n")
}

function escapeXml(value: string): string {
  return value.replace(/[<>&'"]/g, (c) => ({ "<": "&lt;", ">": "&gt;", "&": "&amp;", "'": "&apos;", '"': "&quot;" })[c] ?? c)
}

/** CI 集成的 JUnit XML:block/review 级 finding 映射为失败用例,其余为通过用例。 */
function findingsJunitXml(findings: readonly Finding[], decision: ReleaseDecision): string {
  const failureCodes = new Set(
    [...(decision.blockingReasons ?? []), ...(decision.reviewReasons ?? [])]
      .map((reason) => reason.findingCode)
      .filter((code): code is string => Boolean(code)),
  )
  const cases = findings.map((finding) => {
    if (failureCodes.has(finding.code)) {
      return `    <testcase name="${escapeXml(finding.code)}" classname="droidseal"><failure message="${escapeXml(finding.title)}">${escapeXml(finding.detail)}</failure></testcase>`
    }
    return `    <testcase name="${escapeXml(finding.code)}" classname="droidseal"/>`
  })
  const failures = findings.filter((finding) => failureCodes.has(finding.code)).length
  return `<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="droidseal" tests="${findings.length}" failures="${failures}">
  <testsuite name="droidseal-release-gate" tests="${findings.length}" failures="${failures}">
${cases.join("\n")}
  </testsuite>
</testsuites>
`
}

function releaseDecisionMarkdown(decision: ReleaseDecision): string {
  const labels: Record<ReleaseDecisionStatus, string> = {
    pass: "通过",
    review: "需人工复核",
    block: "阻断发布",
  }
  return [
    `- 结论：**${labels[decision.status]}**（\`${decision.status}\`）`,
    `- 规则版本：\`${decision.ruleVersion}\``,
    `- 原因代码：${decision.reasonCodes.length > 0 ? decision.reasonCodes.map((code) => `\`${code}\``).join("、") : "无"}`,
    "",
    "### 阻断原因",
    "",
    releaseReasonsMarkdown(decision.blockingReasons),
    "",
    "### 人工复核原因",
    "",
    releaseReasonsMarkdown(decision.reviewReasons),
    "",
    "### 提示（不阻断）",
    "",
    releaseReasonsMarkdown(decision.advisoryReasons),
  ].join("\n")
}

function controlCoverageMarkdown(coverage: ControlCoverage): string {
  const statusLabels = {
    verified: "已验证",
    observed: "仅观察到信号",
    "not-verified": "未形成验证闭环",
    "external-required": "需外部验证",
    "not-applicable": "不适用",
  } as const
  const lines = [
    `- 规则版本：\`${coverage.ruleVersion}\``,
    "- `observed` 仅表示制品中存在静态信号，不代表服务端闭环或真机验证完成。",
    "",
    "| 控制 | 责任方 | 状态 | 外部验证 | 证据 code | 说明 |",
    "| --- | --- | --- | --- | --- | --- |",
  ]
  for (const control of coverage.controls) {
    lines.push(
      `| ${control.title.replaceAll("|", "\\|")} | ${control.owner} | ${statusLabels[control.status]} (\`${control.status}\`) | ${control.requiresExternalValidation ? "是" : "否"} | ${control.evidenceCodes.length > 0 ? control.evidenceCodes.map((code) => `\`${code}\``).join("、") : "无"} | ${control.detail.replaceAll("|", "\\|")} |`,
    )
  }
  return lines.join("\n")
}

function defensiveGuide(): string {
  return `## 防护范围与后续建议

DroidSeal 的内置处理覆盖可验证、通用且不会改变应用语义的环节：release 构建检查、APK 结构审计、Manifest 安全审计、zipalign、签名、签名验证和哈希留档。

- 代码与资源保护：在源码构建中启用 R8/资源优化，审阅 keep 规则并保存 mapping 文件。字符串、业务密钥和服务端凭据不应依赖混淆保密。
- 网络安全：默认使用 TLS，按数据风险配置 Network Security Config。若采用证书固定，必须准备备份公钥与轮换/失效方案。
- 关键状态：授权、支付、积分和高价值状态应由服务端校验；本地反调试、反 Hook 和自校验只能作为纵深防御。
- 防二次打包：保持发布密钥安全，验证最终签名证书，结合服务端应用完整性/设备完整性信号。单纯在 Java 层读取自身签名容易被修改或 Hook。
- DEX 加密、VMP、类抽取和自定义加载器：这些机制需要运行时加载器、启动链路和设备兼容性测试，不能安全地作为通用 ZIP 后处理。DroidSeal 不内置也不调用此类工具；如确需主动加固，请在源码接入有授权的方案后再构建，其产物仍可在 DroidSeal 中重新对齐、签名和验证。
- 原生保护：将真正需要保护的少量逻辑放入受审计的原生模块；避免把 OLLVM、反调试或进程扫描当作主要访问控制。

本工具不提供脱壳、绕过证书校验、规避安全检测、内存篡改或未授权逆向的自动化能力。`
}

export async function writeReports(
  config: PipelineConfig,
  context: RunContext,
): Promise<ReportPaths> {
  await mkdir(context.reportDirectory, { recursive: true })
  const jsonPath = path.join(context.reportDirectory, "droidseal-report.json")
  const markdownPath = path.join(context.reportDirectory, "droidseal-report.md")
  const junitPath = path.join(context.reportDirectory, "droidseal-junit.xml")
  const generatedAt = new Date().toISOString()
  const releaseEvidence = await writeReleaseEvidence(config, context, generatedAt)
  const supplyChain = await writeSupplyChainArtifacts(config, context, generatedAt)
  const releaseDecision = evaluateReleaseDecision(context)
  const controlCoverage = buildControlCoverage(config, context)
  const sortedFindings = sortFindingsBySeverity(context.audit.findings)
    .map((finding) => ({ ...finding, confidence: effectiveFindingConfidence(finding) }))
  const remediation = await writeRemediationBundle(context.reportDirectory, sortedFindings)

  const json = {
    schemaVersion: 8,
    product: "DroidSeal",
    edition: EDITION,
    generatedAt,
    runId: context.runId,
    config: publicConfig(config),
    toolchain: toolchainForReport(context.toolchain),
    artifacts: {
      original: context.originalArtifact,
      current: context.currentArtifact,
      final: context.finalArtifact,
      signatureVerified: context.signatureVerified ?? null,
    },
    releaseEvidence: {
      status: releaseEvidence.status,
      directory: releaseEvidence.directory,
      manifest: releaseEvidence.manifestPath,
      variant: releaseEvidence.variant ?? null,
      archivedFiles: releaseEvidence.archivedFiles,
      missing: releaseEvidence.missing,
    },
    supplyChain: {
      directory: supplyChain.directory,
      sbom: supplyChain.sbomPath,
      licenseReview: supplyChain.licenseReviewPath,
      componentCount: supplyChain.componentCount,
      unresolvedCount: supplyChain.unresolvedCount,
    },
    releaseDecision,
    controlCoverage,
    hardeningEffectiveness: await buildHardeningEffectiveness(context),
    previousRun: await buildPreviousRunComparison(context),
    audit: {
      findings: sortedFindings,
      signatureSelfChecks: (context.audit.signatureSelfChecks ?? []).map((check) => ({
        modulePath: check.modulePath,
        expectedStatus: check.expectedStatus,
        expectedFingerprintCount: check.expectedFingerprints.length,
        checkMethodNames: check.checkMethodNames,
        hasSigningApi: check.hasSigningApi,
        hasSha256Digest: check.hasSha256Digest,
        startupInvoked: check.startupInvoked,
        forcedDisposition: check.forcedDisposition,
        locations: check.locations,
      })),
      softwareComponents: context.audit.softwareComponents ?? [],
      apkEntries: context.audit.apkEntries,
      apkMetadata: context.audit.apkMetadata,
    },
    remediation: remediation ? {
      directory: remediation.directory,
      plan: remediation.plan,
      artifacts: remediation.artifacts,
      suggestionCount: remediation.artifacts.length,
    } : null,
    steps: context.stepResults.map(resultForReport),
  }

  const metadata = context.audit.apkMetadata
  const markdown = `# DroidSeal 处理报告

- 运行编号：\`${context.runId}\`
- 生成时间：${generatedAt}
- 输入：\`${config.inputPath}\`
- 最终产物：${context.finalArtifact ? `\`${context.finalArtifact}\`` : "未生成"}
- SHA-256：${metadata?.sha256 ? `\`${metadata.sha256}\`` : "未计算"}
- 签名状态：${context.signatureVerified === true ? "已通过 apksigner 验证" : context.signatureVerified === false ? "未签名或签名无效" : "未验证"}
- 包名：${metadata?.packageName ?? "未读取"}
- 版本：${metadata?.versionName ?? "未读取"} (${metadata?.versionCode ?? "?"})

## 发布门禁

${releaseDecisionMarkdown(releaseDecision)}

## 纵深防御控制覆盖

${controlCoverageMarkdown(controlCoverage)}

## 加固成效

${await hardeningEffectivenessMarkdown(context)}

## 与上次运行对比

${await previousRunMarkdown(context)}

## 执行步骤

> 已处理 ${context.stepResults.length} 步（流程到达）；其中**真实处理成功 ${context.stepResults.filter((r) => r.status === "success").length} 步**、跳过 ${context.stepResults.filter((r) => r.status === "skipped").length} 步、失败并回退 ${context.stepResults.filter((r) => r.status === "failed").length} 步。"已处理"包含跳过与失败回退，不表示全部真实执行；跳过类型见下表情形。

${markdownTable(context.stepResults)}

## 发布证据

${releaseEvidenceMarkdown(releaseEvidence)}

## 供应链制品

${supplyChainMarkdown(supplyChain)}

## 安全发现

${findingsMarkdown(sortedFindings)}

## 修复包

${remediation ? `已自动生成可审阅模板与机器可读计划：\`${remediation.directory}\`` : "没有需要生成修复模板的发现。"}

${defensiveGuide()}
`

  await Promise.all([
    writeFile(jsonPath, `${JSON.stringify(json, null, 2)}\n`, "utf8"),
    writeFile(markdownPath, markdown, "utf8"),
    writeFile(junitPath, findingsJunitXml(sortedFindings, releaseDecision), "utf8"),
  ])
  return {
    json: jsonPath,
    markdown: markdownPath,
    junit: junitPath,
    releaseEvidenceDirectory: releaseEvidence.directory,
    releaseEvidenceManifest: releaseEvidence.manifestPath,
    sbom: supplyChain.sbomPath,
    licenseReview: supplyChain.licenseReviewPath,
    releaseDecisionStatus: releaseDecision.status,
    ...(remediation ? { remediationDirectory: remediation.directory, remediationPlan: remediation.plan } : {}),
  }
}
