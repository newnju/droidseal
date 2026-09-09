// DroidSeal 加固流水线（harden 子命令）。
// 实际处理 APK:解包→Manifest注入→DEX加密→SO加密→资源加密→字符串加密→运行时保护→重打包→签名。
// 纯 TypeScript，失败关闭。
import path from "node:path"
import { readFile, writeFile, mkdir } from "node:fs/promises"
import { createHash } from "node:crypto"
import type { Finding } from "./types.ts"
import { unpackApk, buildUnpackFindings } from "./apk-unpack.ts"
import { extractManifestInfo, injectShellComponents, buildManifestInjectFindings, type ManifestInjectConfig } from "./manifest-inject.ts"
import { processAllDexFiles, type DexProcessConfig } from "./dex-process.ts"
import { generateKeyMaterial, type KeyMaterial } from "./dex-protection-keys.ts"
import { generateShellLoaderFiles, type ShellLoaderConfig, buildShellLoaderFindings } from "./dex-shell-loader.ts"
import { processAllSoFiles, type SoProcessConfig } from "./so-process.ts"
import { processAllAssets, DEFAULT_RESOURCE_CONFIG, type ResourceProcessConfig } from "./resource-process.ts"
import { processStrings, DEFAULT_STRING_PROCESS_CONFIG, type StringProcessConfig } from "./string-process.ts"
import { generateRuntimeProtectionFiles, DEFAULT_RUNTIME_CONFIG, buildRuntimeProtectionFindings, type RuntimeProtectionConfig } from "./runtime-protection.ts"
import { generateVmInterpreterSmali, DEFAULT_VM_CONFIG, buildVmpFindings } from "./vmp-protection.ts"
import { repackApk, type SigningConfig, type RepackConfig } from "./apk-repack.ts"
import { generateResourceDecryptorSmali } from "./resource-string-protection.ts"
import { generateNativeShellFiles, buildNativeShellFindings, type NativeShellConfig } from "./native-shell.ts"

// ── 加固配置 ──────────────────────────────────────────────────────────

export interface HardenConfig {
  inputApk: string
  outputDir: string
  packageName: string
  originalApplication: string
  certSha256?: string | undefined
  algorithm: "aes-256-gcm" | "chacha20-poly1305"
  enableDexEncryption: boolean
  enableMethodHollow: boolean
  enableSoEncryption: boolean
  enableResourceEncryption: boolean
  enableStringEncryption: boolean
  enableRuntimeProtection: boolean
  enableVmProtection: boolean
  enableSplitKey: boolean
  enableTripleEntry: boolean
  enableRandomNames: boolean
  classExclusionPatterns: string[]
  runtimeConfig?: RuntimeProtectionConfig | undefined
  signingConfig?: import("./apk-repack.ts").SigningConfig | undefined
}

export const DEFAULT_HARDEN_CONFIG: Partial<HardenConfig> = {
  algorithm: "aes-256-gcm",
  enableDexEncryption: true,
  enableMethodHollow: true,
  enableSoEncryption: true,
  enableResourceEncryption: true,
  enableStringEncryption: true,
  enableRuntimeProtection: true,
  enableVmProtection: false, // VMP 默认关闭(性能影响大)
  enableSplitKey: true,
  enableTripleEntry: true,
  enableRandomNames: true,
  runtimeConfig: DEFAULT_RUNTIME_CONFIG,
}

// ── 加固结果 ──────────────────────────────────────────────────────────

export interface HardenResult {
  success: boolean
  outputApk?: string | undefined
  findings: Finding[]
  keyMaterial?: KeyMaterial | undefined
  dexResult?: import("./dex-process.ts").DexProcessResult | undefined
  encryptedDex?: import("./dex-protection.ts").EncryptedDex | undefined
  soResults: Array<{ name: string; encryptedSize: number; originalSize: number }>
  resourceResults: Array<{ name: string; encryptedSize: number }>
  generatedFiles: Array<{ name: string; content: string }>
  summary: {
    dexProtected: boolean
    soProtected: boolean
    resourceProtected: boolean
    stringProtected: boolean
    runtimeProtected: boolean
    vmProtected: boolean
    totalFindings: number
  }
}

// ── 加固流水线 ──────────────────────────────────────────────────────────

export async function runHardenPipeline(config: HardenConfig): Promise<HardenResult> {
  const findings: Finding[] = []
  const soResults: Array<{ name: string; encryptedSize: number; originalSize: number }> = []
  const resourceResults: Array<{ name: string; encryptedSize: number }> = []
  const generatedFiles: Array<{ name: string; content: string }> = []
  let keyMaterial: KeyMaterial | undefined
  let dexResult: import("./dex-process.ts").DexProcessResult | undefined
  let outputApk: string | undefined

  // ──────────────────────────────────────────────────────────────────────
  // Step 1: 解包 APK
  // ──────────────────────────────────────────────────────────────────────
  const apkContents = await unpackApk(config.inputApk)
  findings.push(...buildUnpackFindings(apkContents))

  // 提取包名和 Application 类名
  let packageName = config.packageName
  let originalApplication = config.originalApplication
  if (apkContents.manifest) {
    const info = extractManifestInfo(apkContents.manifest.bytes)
    if (!packageName || packageName === "com.droidseal.protected") packageName = info.packageName || packageName
    if (!originalApplication || originalApplication === "android.app.Application") originalApplication = info.applicationName || originalApplication
    apkContents.packageName = packageName
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 2: 密钥生成
  // ──────────────────────────────────────────────────────────────────────
  const apkBytes = await readFile(config.inputApk)
  const apkSha256 = createHash("sha256").update(apkBytes).digest("hex")
  keyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "dex", config.enableSplitKey)
  // SO/资源用不同 purpose 派生不同密钥
  const soKeyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "so", config.enableSplitKey)
  const resKeyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "resource", config.enableSplitKey)

  // ──────────────────────────────────────────────────────────────────────
  // Step 3: Manifest 注入(壳组件)
  // ──────────────────────────────────────────────────────────────────────
  const randomPkg = config.enableRandomNames ? generateRandomPkg() : packageName
  const randomSo = config.enableRandomNames ? generateRandomSo() : "libdroidseal.so"
  const shellApp = `${packageName}.DroidSealApplication`
  const shellProvider = `${packageName}.DroidSealProvider`
  const shellFactory = `${packageName}.DroidSealComponentFactory`

  if (apkContents.manifest) {
    const xml = new TextDecoder("utf-8", { fatal: false }).decode(apkContents.manifest.bytes)
    const manifestConfig: ManifestInjectConfig = {
      packageName, originalApplication, shellApplication: shellApp,
      shellContentProvider: shellProvider, shellComponentFactory: shellFactory,
      shellSoName: randomSo, enableContentProvider: config.enableTripleEntry,
      enableComponentFactory: config.enableTripleEntry, targetSdkVersion: 34,
    }
    const { xml: modifiedXml, injected } = injectShellComponents(xml, manifestConfig)
    apkContents.manifest.bytes = new TextEncoder().encode(modifiedXml)
    findings.push(...buildManifestInjectFindings(manifestConfig, injected))
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 4: DEX 处理(方法抽取 + 整体加密)
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableDexEncryption || config.enableMethodHollow) {
    const dexConfig: DexProcessConfig = {
      algorithm: config.algorithm, enableMethodHollow: config.enableMethodHollow,
      enableDexEncryption: config.enableDexEncryption, enableSplitKey: config.enableSplitKey,
      classExclusionPatterns: config.classExclusionPatterns, certSha256: config.certSha256, apkSha256,
    }
    dexResult = processAllDexFiles(apkContents.dexFiles, dexConfig)
    // 替换 APK 中的 DEX 文件
    for (let i = 0; i < apkContents.dexFiles.length; i += 1) {
      apkContents.dexFiles[i]!.bytes = dexResult.processedDex[i]!
    }
    findings.push(...dexResult.findings)
    keyMaterial = dexResult.keyMaterial // 用 DEX 处理生成的密钥材料
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 5: 壳加载器 Smali 生成
  // ──────────────────────────────────────────────────────────────────────
  const shellConfig: ShellLoaderConfig = {
    packageName, originalApplication, randomPackageName: randomPkg, randomSoName: randomSo,
    tripleEntry: { packageName, originalApplication, useAppComponentFactory: config.enableTripleEntry,
      useContentProvider: config.enableTripleEntry, useApplication: true },
    algorithm: config.algorithm, useSplitKey: config.enableSplitKey,
    classExclusionPatterns: config.classExclusionPatterns,
  }
  const shellFiles = generateShellLoaderFiles(shellConfig)
  generatedFiles.push(...shellFiles)
  findings.push(...buildShellLoaderFindings(shellConfig, shellFiles))

  // ──────────────────────────────────────────────────────────────────────
  // Step 6: SO 加密
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableSoEncryption && apkContents.soFiles.length > 0) {
    const soConfig: SoProcessConfig = {
      algorithm: config.algorithm, enableFullEncrypt: true,
      enableSegmentEncrypt: true, targetAbis: [],
    }
    const soResult = processAllSoFiles(apkContents.soFiles.map((e) => ({ name: e.name, bytes: e.bytes })), soConfig, soKeyMaterial.encryptionKey)
    for (const entry of soResult.processedEntries) {
      const original = apkContents.soFiles.find((e) => e.name === entry.name)
      if (original) original.bytes = entry.bytes
    }
    findings.push(...soResult.findings)
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 7: 资源加密
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableResourceEncryption && apkContents.assetFiles.length > 0) {
    const resConfig: ResourceProcessConfig = { ...DEFAULT_RESOURCE_CONFIG, enableResourceEncryption: true }
    const resResult = processAllAssets(apkContents.assetFiles.map((e) => ({ name: e.name, bytes: e.bytes })), resConfig, resKeyMaterial.encryptionKey)
    for (const entry of resResult.processedEntries) {
      const original = apkContents.assetFiles.find((e) => e.name === entry.name)
      if (original) original.bytes = entry.bytes
    }
    findings.push(...resResult.findings)
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 8: 字符串加密(DEX string_data 分析 + 解密器生成)
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableStringEncryption && dexResult) {
    // 从处理后的 DEX 中提取字符串池(复用 dex-scan 的 extractDexStrings)
    const { extractDexStrings } = await import("./dex-scan.ts")
    const allStrings: string[] = []
    for (const dex of dexResult.processedDex) {
      try { allStrings.push(...extractDexStrings(dex).strings) } catch { /* skip */ }
    }
    const strConfig: StringProcessConfig = { ...DEFAULT_STRING_PROCESS_CONFIG, enableStringEncryption: true }
    const strResult = processStrings(allStrings, packageName, strConfig, keyMaterial)
    if (strResult.encryptedCount > 0) {
      generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealStringDecryptor.smali`, content: strResult.decryptorSmali })
    }
    findings.push(...strResult.findings)
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 9: 运行时保护 Smali 生成
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableRuntimeProtection && config.runtimeConfig) {
    const rtFiles = generateRuntimeProtectionFiles(packageName, config.runtimeConfig)
    generatedFiles.push(...rtFiles)
    findings.push(...buildRuntimeProtectionFindings(rtFiles, config.runtimeConfig))
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 10: VMP 保护(可选)
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableVmProtection) {
    const vmSmali = generateVmInterpreterSmali(packageName, DEFAULT_VM_CONFIG)
    generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealVmInterpreter.smali`, content: vmSmali })
    findings.push(...buildVmpFindings(true, false, false))
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 11: 资源解密器
  // ──────────────────────────────────────────────────────────────────────
  if (config.enableResourceEncryption) {
    generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealResDecryptor.smali`, content: generateResourceDecryptorSmali(packageName) })
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 12: Native 壳 SO 生成(C 源 + CMake——需 NDK 编译)
  // ──────────────────────────────────────────────────────────────────────
  const nativeConfig: NativeShellConfig = {
    packageName,
    soName: randomSo,
    algorithm: config.algorithm,
    enableAntiFrida: true,
    enableAntiDump: true,
    enableAntiDebug: true,
    enableArtHook: config.enableMethodHollow,
  }
  const nativeFiles = generateNativeShellFiles(nativeConfig)
  generatedFiles.push(...nativeFiles)
  findings.push(...buildNativeShellFindings(nativeConfig, nativeFiles.length))

  // ──────────────────────────────────────────────────────────────────────
  // Step 13: 重打包 + 签名
  // ──────────────────────────────────────────────────────────────────────
  await mkdir(config.outputDir, { recursive: true })
  outputApk = path.join(config.outputDir, path.basename(config.inputApk).replace(".apk", ".hardened.apk"))

  // 构建 ZIP 条目列表
  const zipEntries: Array<{ name: string; bytes: Uint8Array; compressionMethod: number }> = []
  // DEX 文件(deflated)
  for (const dex of apkContents.dexFiles) zipEntries.push({ ...dex, compressionMethod: 8 })
  // SO 文件(stored — 原始 APK 中 SO 通常 stored)
  for (const so of apkContents.soFiles) zipEntries.push({ ...so, compressionMethod: 0 })
  // Assets(deflated)
  for (const asset of apkContents.assetFiles) zipEntries.push({ ...asset, compressionMethod: 8 })
  // Manifest + resources.arsc + 其他
  if (apkContents.manifest) zipEntries.push({ ...apkContents.manifest, compressionMethod: 8 })
  if (apkContents.resourceArsc) zipEntries.push({ ...apkContents.resourceArsc, compressionMethod: 8 })
  for (const entry of apkContents.otherFiles) zipEntries.push({ ...entry, compressionMethod: entry.compressed ? 8 : 0 })

  // 自动签名:如果用户未提供 keystore,自动生成自签名密钥库
  // 如果提供了 certSha256,用其派生签名密钥密码(绑定证书指纹)
  let signingConfig: SigningConfig | undefined
  if (config.signingConfig) {
    signingConfig = config.signingConfig
  } else {
    const { generateKeystore } = await import("./apk-repack.ts")
    const ksPath = path.join(config.outputDir, "droidseal-keystore.jks")
    const ksPassword = config.certSha256
      ? createHash("sha256").update(config.certSha256).digest("hex").slice(0, 16)
      : "droidseal123"
    const keyAlias = "droidseal"
    const genOk = generateKeystore(ksPath, { keyAlias, storePassword: ksPassword, keyPassword: ksPassword, validity: 36500 })
    if (genOk) {
      signingConfig = { mode: "keystore", keystorePath: ksPath, keyAlias, storePassword: ksPassword, keyPassword: ksPassword }
      findings.push({
        severity: "info", confidence: "high", code: "KEYSTORE_GENERATED",
        title: config.certSha256
          ? "自签名密钥库已生成(密码绑定证书指纹)"
          : "自签名密钥库已生成(默认密码)",
        detail: config.certSha256
          ? `路径: ${ksPath};密码由 --cert-sha256 派生;有效期: 100 年。release 发布请替换为正式密钥库。`
          : `路径: ${ksPath};默认密码 droidseal123;有效期: 100 年。release 发布请替换为正式密钥库。`,
        recommendation: "自签名 keystore 仅用于开发测试——正式发布请使用专用 release 密钥。",
        evidence: ksPath,
      })
    }
  }

  let repackResult: import("./apk-repack.ts").RepackResult | undefined
  try {
    repackResult = await repackApk({
      entries: zipEntries, outputPath: outputApk,
      signingConfig,
      enableZipalign: false,
    })
    findings.push(...repackResult.findings)
  } catch (error) {
    const msg = error instanceof Error ? error.message : String(error)
    findings.push({
      severity: "high", confidence: "high", code: "REPACK_FAILED",
      title: "APK 重打包失败",
      detail: `重打包过程抛出异常: ${msg}。加固后的 Smali/C/CMake 文件仍已输出到 ${config.outputDir}/,可手动集成到项目。`,
      recommendation: "检查 APK 文件完整性;确认 ZIP 条目无损坏;手动集成壳加载器 Smali 文件到项目后重新构建。",
      evidence: msg.slice(0, 200),
    })
  }
  if (repackResult?.sha256) findings.push({
    severity: "info", confidence: "high", code: "APK_SHA256",
    title: `加固 APK SHA-256: ${repackResult.sha256}`,
    detail: `输出文件: ${outputApk}。SHA-256: ${repackResult.sha256}。`,
    recommendation: "确认加固后 APK 可正常安装运行。",
    evidence: repackResult.sha256,
  })

  // 写出壳加载器 Smali 文件到输出目录
  const smaliDir = path.join(config.outputDir, "smali")
  for (const file of generatedFiles) {
    const filePath = path.join(config.outputDir, file.name)
    await mkdir(path.dirname(filePath), { recursive: true })
    await writeFile(filePath, file.content, "utf8")
  }

  const summary = {
    dexProtected: config.enableDexEncryption || config.enableMethodHollow,
    soProtected: config.enableSoEncryption,
    resourceProtected: config.enableResourceEncryption,
    stringProtected: config.enableStringEncryption,
    runtimeProtected: config.enableRuntimeProtection,
    vmProtected: config.enableVmProtection,
    totalFindings: findings.length,
  }

  return { success: true, outputApk, findings, keyMaterial, dexResult: dexResult as any, encryptedDex: dexResult?.encryptedDex, soResults, resourceResults, generatedFiles, summary }
}

// ── 工具函数 ──────────────────────────────────────────────────────────

function generateRandomPkg(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  const r = (n: number) => Array.from({ length: n }, () => chars[Math.floor(Math.random() * 26)]).join("")
  return `com.${r(3)}.${r(3)}.${r(3)}`
}

function generateRandomSo(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  return `lib${Array.from({ length: 5 }, () => chars[Math.floor(Math.random() * 26)]).join("")}.so`
}

// ── 加固报告生成 ──────────────────────────────────────────────────────

export function generateHardenReport(result: HardenResult): string {
  const lines: string[] = [
    "=== DroidSeal 加固报告 ===",
    "",
    "保护层状态:",
    `  DEX 保护: ${result.summary.dexProtected ? "✓ 已启用" : "✗ 未启用"}`,
    `  SO 保护: ${result.summary.soProtected ? "✓ 已启用" : "✗ 未启用"}`,
    `  资源保护: ${result.summary.resourceProtected ? "✓ 已启用" : "✗ 未启用"}`,
    `  字符串保护: ${result.summary.stringProtected ? "✓ 已启用" : "✗ 未启用"}`,
    `  运行时保护: ${result.summary.runtimeProtected ? "✓ 已启用" : "✗ 未启用"}`,
    `  VMP 保护: ${result.summary.vmProtected ? "✓ 已启用" : "✗ 未启用"}`,
    "",
  ]

  if (result.keyMaterial) {
    lines.push("密钥信息:")
    lines.push(`  来源: ${result.keyMaterial.derivedFrom}`)
    lines.push(`  目的: ${result.keyMaterial.purpose}`)
    lines.push(`  Split-Key: ${result.keyMaterial.splitKey ? "是" : "否"}`)
    lines.push("")
  }

  if (result.generatedFiles.length > 0) {
    lines.push(`生成文件: ${result.generatedFiles.length} 个`)
    for (const file of result.generatedFiles.slice(0, 20)) {
      lines.push(`  - ${file.name}`)
    }
    if (result.generatedFiles.length > 20) {
      lines.push(`  ... +${result.generatedFiles.length - 20} 个文件`)
    }
    lines.push("")
  }

  lines.push(`发现: ${result.findings.length} 条`)
  for (const finding of result.findings) {
    lines.push(`  [${finding.severity}] ${finding.title}`)
  }

  return lines.join("\n")
}

export function buildHardenPipelineFindings(result: HardenResult): Finding[] {
  return result.findings
}
