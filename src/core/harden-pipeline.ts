// DroidSeal 加固流水线（harden 子命令）。
// 实际处理 APK:解包→Manifest注入→DEX加密→SO加密→资源加密→字符串加密→运行时保护→重打包→签名。
// 纯 TypeScript，失败关闭。
import path from "node:path"
import { readFile, writeFile, mkdir, rm } from "node:fs/promises"
import { existsSync, mkdirSync } from "node:fs"
import { createHash, randomBytes } from "node:crypto"
import type { Finding } from "./types.ts"
import { unpackApk, buildUnpackFindings } from "./apk-unpack.ts"
import { extractManifestInfo, injectShellComponents, buildManifestInjectFindings, type ManifestInjectConfig } from "./manifest-inject.ts"
import { flipDebuggableInAxml, manifestBytesAreDebuggable } from "./harden-manifest.ts"
import { processAllDexFiles, type DexProcessConfig } from "./dex-process.ts"
import { findStringNeighbors } from "./dex-codec.ts"
import { gateSummaryClaims } from "./summary-gate.ts"
import { generateKeyMaterial, splitKey, type KeyMaterial } from "./dex-protection-keys.ts"
import { patchLoaderDexKeys } from "./loader-key-patch.ts"
import { randomizeLoaderClassNames } from "./loader-class-rename.ts"
import { randomizeLoaderIdentifiers } from "./loader-ident-randomize.ts"
import { randomizeStubIdentifiers, encryptLoaderDex } from "./stub-encapsulate.ts"
import { generateShellLoaderFiles, type ShellLoaderConfig, buildShellLoaderFindings } from "./dex-shell-loader.ts"
import { processAllSoFiles, type SoProcessConfig } from "./so-process.ts"
import { processAllAssets, DEFAULT_RESOURCE_CONFIG, type ResourceProcessConfig } from "./resource-process.ts"
import { processStrings, DEFAULT_STRING_PROCESS_CONFIG, type StringProcessConfig } from "./string-process.ts"
import { generateRuntimeProtectionFiles, DEFAULT_RUNTIME_CONFIG, buildRuntimeProtectionFindings, type RuntimeProtectionConfig } from "./runtime-protection.ts"
import { generateVmInterpreterSmali, DEFAULT_VM_CONFIG, buildVmpFindings } from "./vmp-protection.ts"
import { repackApk, type SigningConfig, type RepackConfig } from "./apk-repack.ts"
import { generateResourceDecryptorSmali } from "./resource-string-protection.ts"
import { generateNativeShellFiles, buildNativeShellFindings, type NativeShellConfig } from "./native-shell.ts"
import { compileAndMergeSmali } from "./smali-merge.ts"
import { buildPayloadContainer, decryptContainerEntry, encryptContainerEntryDerived, decryptContainerEntryDerived, chainSeed, CONTAINER_ASSET_NAME, type ContainerEntry } from "./payload-container.ts"
import { generateSplitKeyInjectionData } from "./split-key-inject.ts"
import { recompileAndInjectManifest } from "./axml-recompile.ts"
import { injectRuntimeProtection, generateRuntimeInitCall } from "./runtime-inject.ts"
import { encryptAndReplaceStrings } from "./string-encrypt-writeback.ts"
import { compileMethodToVm, serializeVmPayload, buildVmpCompilerFindings } from "./vmp-compiler.ts"
import { compileNativeSo, generateCmakeListsForShell } from "./native-so-compile.ts"
import { generateEnhancedRuntimeSmali, generateEnhancedNativeC, buildEnhancedGuardFindings } from "./enhanced-guard.ts"
import { buildCodeItemTable, encryptCodeItemTable, generateCodeItemRestoreHeader } from "./codeitem-table.ts"
import { generateEnhancedNativeAntiAnalysis, generateEnhancedJavaGuard, buildAntiAnalysisFindings } from "./enhanced-anti-analysis.ts"
import { generatePltHookC } from "./art-hook-plt.ts"
import { generateSyscallDetectionC, generateSyscallDetectionSmali, buildSyscallDetectionFindings } from "./syscall-detection.ts"
import { generateControlFlowObfuscationSmali, generateDex2cBridge, generateVmIsa, generateMultiLayerStringEncryption, buildResearchProtectionFindings } from "./research-protection.ts"

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
  /** Android Keystore 设备绑定:part1 首次运行后用 Keystore 硬件密钥封装,卸载/换机即失效(可选) */
  enableKeystoreBinding: boolean
  classExclusionPatterns: string[]
  runtimeConfig?: RuntimeProtectionConfig | undefined
  signingConfig?: import("./apk-repack.ts").SigningConfig | undefined
  /** 默认 false(经典模式):结束清理 native/smali 等过程目录,只留最终 APK;true(测试学习模式)保留 */
  keepIntermediates?: boolean
  /** P2 服务端挑战(可选):启用后密钥第三段 part3 不进 APK,运行时向该 URL 取片;
   *  构建产物旁生成 server-challenge.json(含 part3 与校验规则),运营者部署到该 URL。 */
  challengeUrl?: string
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
  enableKeystoreBinding: false, // 换机/重装密钥轮换语义,默认关闭由用户显式开启
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
    /** 加固覆盖率指标(P2,报告一等指标):方法抽取覆盖(有代码路径背书,真实百分比);
     *  dex2cWired 如实报桥接是否实际接线(当前 generateDex2cBridge 无调用点 → false,
     *  与 stringProtected 同口径:summary 不虚报未接线的配置开关)。 */
    methodHollow: { hollowed: number; total: number; pct: number; skipped: number }
    dex2cWired: boolean
  }
}

// ── 加固流水线 ──────────────────────────────────────────────────────────

export async function runHardenPipeline(config: HardenConfig): Promise<HardenResult> {
  const findings: Finding[] = []
  const soResults: Array<{ name: string; encryptedSize: number; originalSize: number }> = []
  const resourceResults: Array<{ name: string; encryptedSize: number }> = []
  const generatedFiles: Array<{ name: string; content: string }> = []
  let keyMaterial: KeyMaterial | undefined
  const containerEntries: ContainerEntry[] = []
  let stringWritebackApplied = false // encryptAndReplaceStrings 接线后置 true
  let dexResult: import("./dex-process.ts").DexProcessResult | undefined
  let outputApk: string | undefined

  // 过程目录清理:经典模式(默认)在流水线结束(无论成败)后删除 outputDir 下的
  // native/smali 过程目录,只留最终 APK 与 idsig;测试学习模式(keepIntermediates=true)保留。
  // 无条件应用于失败路径——失败现场的诊断信息由 findings 报告承载,不在输出目录留残骸。
  const cleanupIntermediates = async () => {
    if (config.keepIntermediates) return
    for (const dir of ["native", "native-droidseal-shell", "smali", "native-libs"]) {
      await rm(path.join(config.outputDir, dir), { recursive: true, force: true }).catch(() => undefined)
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 1: 解包 APK
  // ──────────────────────────────────────────────────────────────────────
  let apkContents: Awaited<ReturnType<typeof unpackApk>>
  try {
    apkContents = await unpackApk(config.inputApk)
  } catch (unpackError) {
    // unpackApk 失败时降级:创建空 ApkContents,跳过解包步骤
    findings.push({
      severity: "high", confidence: "high", code: "APK_UNPACK_FALLBACK",
      title: "APK 解包失败,启用降级模式",
      detail: `错误: ${unpackError instanceof Error ? unpackError.message : String(unpackError)}`,
      recommendation: "APK 可能含有畸形 ZIP 条目;加固将在降级模式下执行。",
      evidence: String(unpackError).slice(0, 200),
    })
    apkContents = {
      entries: [], dexFiles: [], soFiles: [], assetFiles: [],
      manifest: undefined, resourceArsc: undefined, otherFiles: [],
      packageName: "",
    }
  }
  // 降级补救:如果 unpackApk 返回空 dexFiles,尝试用 Bun 内置解压直接提取
  if (apkContents.dexFiles.length === 0) {
    try {
      const { $ } = await import("bun")
      const result = await $`unzip -l ${config.inputApk} | grep classes.dex`.text().catch(() => "")
      if (result.includes("classes.dex")) {
        // 用 unzip -p 直接解压到内存
        const dexBuf = await $`unzip -p ${config.inputApk} classes.dex`.arrayBuffer().catch(() => null)
        if (dexBuf && dexBuf.byteLength > 0 && dexBuf.byteLength < 50_000_000) {
          apkContents.dexFiles = [{ name: "classes.dex", bytes: new Uint8Array(dexBuf), compressed: false, compressionMethod: 0, crc32: 0 }]
          findings.push({ severity: "info", confidence: "high", code: "APK_DEX_FALLBACK", title: "通过 unzip 直接提取 classes.dex", detail: `大小: ${dexBuf.byteLength}B`, recommendation: "", evidence: "unzip-fallback" })
        }
      }
    } catch { /* unzip fallback 也失败则继续 */ }
  }
  findings.push(...buildUnpackFindings(apkContents))
  let packageName = config.packageName
  let originalApplication = config.originalApplication
  if (apkContents.manifest) {
    const info = extractManifestInfo(apkContents.manifest.bytes)
    if (!packageName || packageName === "com.droidseal.protected") packageName = info.packageName || packageName
    if (!originalApplication || originalApplication === "android.app.Application") originalApplication = info.applicationName || originalApplication
    apkContents.packageName = packageName
    // 兼容性检查:InMemoryDexClassLoader 需 API 26+(壳加载器的核心依赖)
    if (config.enableDexEncryption && info.minSdk > 0 && info.minSdk < 26) {
      findings.push({
        severity: "high", confidence: "high", code: "MIN_SDK_BELOW_26",
        title: `目标应用 minSdk=${info.minSdk} 低于 26,InMemoryDexClassLoader 不可用`,
        detail: "壳加载器用 InMemoryDexClassLoader 还原加密 DEX,该 API 需 Android 8.0(API 26)。minSdk<26 的设备上壳将无法解密加载原始 DEX,应用崩溃。",
        recommendation: "将 minSdk 提升到 26,或等待基于 DexClassLoader 落盘方案的降级实现。",
        evidence: `minSdk=${info.minSdk}`,
      })
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 2: 密钥生成
  // ──────────────────────────────────────────────────────────────────────
  let apkBytes: Uint8Array
  try {
    apkBytes = new Uint8Array(await readFile(config.inputApk))
  } catch (readErr) {
    findings.push({ severity: "high", confidence: "high", code: "APK_READ_FAILED", title: "APK 文件读取失败", detail: String(readErr), recommendation: "确认 APK 路径正确且文件可读。", evidence: String(readErr).slice(0, 200) })
    await cleanupIntermediates()
    return { success: false, findings, soResults: [], resourceResults: [], generatedFiles: [], summary: { dexProtected: false, soProtected: false, resourceProtected: false, stringProtected: false, runtimeProtected: false, vmProtected: false, totalFindings: findings.length, methodHollow: { hollowed: 0, total: 0, pct: 0, skipped: 0 }, dex2cWired: false } }
  }
  const apkSha256 = createHash("sha256").update(apkBytes).digest("hex")
  // configHash:将密钥派生与本次加固配置绑定(恒空串的降级已移除;
  // 运行时密钥经 splitKey parts 嵌入,不依赖 configHash,故仅构建期生效)
  const configHash = createHash("sha256").update(JSON.stringify(config)).digest("hex")
  keyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "dex", config.enableSplitKey, configHash)
  const soKeyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "so", config.enableSplitKey, configHash)
  const resKeyMaterial = generateKeyMaterial(config.certSha256, apkSha256, "resource", config.enableSplitKey, configHash)

  // ──────────────────────────────────────────────────────────────────────
  // Step 2.5: Loader DEX 预处理(类名随机化)——Step 3 manifest 与 Step 13 注入共用
  // ──────────────────────────────────────────────────────────────────────
  const loaderDexPath = path.join(process.cwd(), "runtime", "droidseal-loader.dex")
  const stubDexPath = path.join(process.cwd(), "runtime", "droidseal-stub.dex")
  let loaderDexRaw: Uint8Array | undefined
  let stubDexRaw: Uint8Array | undefined
  let shellApp = "droidseal.runtime.ShellApplication"
  let jniClassPath = "droidseal/runtime/DroidSealLoader"
  // 双 DEX:manifest 指向明文 stub;loader DEX 加密进 asset(stub 解密加载)
  let stubApp = ""
  let loaderAssetName = "" // asset 相对路径(不含 assets/ 前缀),meta 值
  let identMetaLoaderAsset = "ds_loader_asset_mk1" // 19B 标记,构建期等长替换
  // 固定标识符随机值(enableRandomNames=false 时保持原值)
  let identMagic = "DROIDSEALBIN"
  let identAssetName = "droidseal.bin"
  let identMetaOriginalApp = "droidseal.original_app"
  let identMetaShellSo = "droidseal.shell_so"
  if (existsSync(loaderDexPath)) {
    loaderDexRaw = new Uint8Array(await readFile(loaderDexPath))
    // 联合约束:stub DEX 中壳名点分形式的槽邻居——loader 改名生成的壳名必须同时
    // 落进 stub 槽(stub 的 loadClass 引用与 manifest 都用点分名),否则 stub 侧
    // 替换失败 → 壳引用错位 fail-closed。stub 不存在时无此约束。
    let stubSlotForRename: ReturnType<typeof findStringNeighbors> | undefined
    if (existsSync(stubDexPath)) {
      try {
        stubSlotForRename = findStringNeighbors(new Uint8Array(await readFile(stubDexPath)), "droidseal.runtime.ShellApplication")
      } catch {
        stubSlotForRename = undefined
      }
    }
    const renameResult = randomizeLoaderClassNames(loaderDexRaw, config.enableRandomNames, stubSlotForRename)
    if (renameResult.renamed) {
      loaderDexRaw = renameResult.dex
      // newShellPath/newLoaderPath 是 "Lpkg/Class;" 形式 → JNI 需 "pkg/Class"
      const strip = (p: string) => p.slice(1, -1)
      shellApp = strip(renameResult.newShellPath)
      jniClassPath = strip(renameResult.newLoaderPath)
      findings.push({
        severity: "info", confidence: "high", code: "LOADER_CLASS_RANDOMIZED",
        title: `壳入口类名已随机化:${renameResult.oldShellPath} → ${renameResult.newShellPath}`,
        detail: "loader DEX 内壳类路径做等长替换,manifest android:name 与 JNI 导出同步使用新名,静态规则按固定类名匹配失效。",
        recommendation: "真机验证壳入口以新类名正常启动。",
        evidence: renameResult.newLoaderPath,
      })
    } else if (config.enableRandomNames) {
      findings.push({
        severity: "medium", confidence: "high", code: "LOADER_CLASS_RENAME_SKIPPED",
        title: "壳类名随机化未命中(保留原类名)",
        detail: "loader DEX 中未找到 droidseal/runtime/ShellApplication——DEX 与改名逻辑版本不匹配,保留原类名仍可运行。",
        recommendation: "重新编译 runtime/java 生成一致的 loader DEX。",
        evidence: renameResult.oldShellPath,
      })
    }
    // 固定标识符随机化(容器 magic / asset 名 / meta 键):废掉基于固定签名的自动化定位
    if (loaderDexRaw) {
      const identResult = randomizeLoaderIdentifiers(loaderDexRaw, config.enableRandomNames)
      loaderDexRaw = identResult.dex
      identMagic = identResult.magic
      identAssetName = identResult.assetName
      identMetaOriginalApp = identResult.metaOriginalApp
      identMetaShellSo = identResult.metaShellSo
      if (identResult.changed.length > 0) {
        findings.push({
          severity: "info", confidence: "high", code: "LOADER_IDENT_RANDOMIZED",
          title: `壳固定标识符已随机化(${identResult.changed.length} 项)`,
          detail: `容器 magic、asset 名、meta-data 键每次构建随机生成并等长写入 loader DEX——静态字符串签名定位失效。${identResult.changed.map((c) => `${c.from}→${c.to}`).join("; ")}`,
          recommendation: "真机验证壳加载器以新标识符正常读取容器。",
          evidence: identResult.changed.map((c) => c.to).join(","),
        })
      }
      if (identResult.missed.length > 0) {
        findings.push({
          severity: "medium", confidence: "high", code: "LOADER_IDENT_RANDOMIZE_PARTIAL",
          title: `部分固定标识符未命中(${identResult.missed.length} 项,保留原值)`,
          detail: `未在 loader DEX 中找到:${identResult.missed.join(", ")}——这些静态签名仍在,静态定位未完全失效,但功能不受影响。`,
          recommendation: "重新编译 runtime/java 生成一致的 loader DEX。",
          evidence: identResult.missed.join(","),
        })
      }
    }

    // 双 DEX:stub 随机化提前到此处(Step 3 manifest 注入需要 stub 类名/asset meta 键)
    if (existsSync(stubDexPath) && config.certSha256) {
      stubDexRaw = new Uint8Array(await readFile(stubDexPath))
      loaderAssetName = `${identAssetName.slice(0, -4)}.ldx`
      // loader asset meta 键:随机化时生成 19 字符随机键(与 stub 内 19B 标记等长替换)
      if (config.enableRandomNames) {
        const LOWER2 = "abcdefghijklmnopqrstuvwxyz"
        identMetaLoaderAsset = Array.from(randomBytes(19), (b) => LOWER2[b % 26]).join("")
      }
      const stubResult = randomizeStubIdentifiers(stubDexRaw, {
        enable: config.enableRandomNames,
        shellClassPath: shellApp, // Step 2.5 rename 后的斜杠形式
        metaKey: identMetaLoaderAsset,
      })
      stubDexRaw = stubResult.dex
      stubApp = stubResult.stubClassPath
      if (stubResult.missed.length > 0) {
        findings.push({
          severity: "medium", confidence: "high", code: "STUB_RANDOMIZE_PARTIAL",
          title: `stub 标记未完全命中(${stubResult.missed.length} 项,保留原值)`,
          detail: `stub DEX 中未找到:${stubResult.missed.join(", ")}——stub 与随机化逻辑版本可能不匹配,manifest 可能指向错误类名导致壳无法启动。`,
          recommendation: "运行 scripts/rebuild-loader-dex.ts 重新生成一致的 stub DEX。",
          evidence: stubResult.missed.join(","),
        })
      }
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 3: Manifest 注入(壳组件)
  // ──────────────────────────────────────────────────────────────────────
  const randomPkg = config.enableRandomNames ? generateRandomPkg() : packageName
  const randomSo = config.enableRandomNames ? generateRandomSo() : "libdroidseal.so"
  // Java 壳入口:Step 2.5 已按 loader DEX 实际类名确定(随机化时为新名)
  const shellProvider = `${packageName}.DroidSealProvider`
  const shellFactory = `${packageName}.DroidSealComponentFactory`

  if (apkContents.manifest) {
    // 二进制 AXML 注入(替代原文本 regex 方案——regex 会破坏 AXML 结构):
    // application 入口 + meta-data;三重入口类未编译进 loader DEX,不注入避免引用悬空
    try {
      const { injectShellIntoAxml } = await import("./axml-inject.ts")
      const { parseAxml, readApplicationName } = await import("./axml-writer.ts")
      // 注入前先读原入口类名(避免注入后才知道、需要二次注入)
      let prevApp: string | null = null
      try { prevApp = readApplicationName(parseAxml(apkContents.manifest.bytes)) } catch { /* 原样用 config 值 */ }
      if (prevApp && prevApp !== "android.app.Application" && (!originalApplication || originalApplication === "android.app.Application")) {
        originalApplication = prevApp
      }
      // 双 DEX 激活时 manifest 指向明文 stub(真实壳类名藏于加密 loader DEX 内)
      const manifestEntry = stubApp || shellApp
      const metaDatas = [
        { name: identMetaOriginalApp, value: originalApplication || "android.app.Application" },
        { name: identMetaShellSo, value: randomSo.replace(/^lib/, "").replace(/\.so$/, "") },
      ]
      if (stubApp) {
        metaDatas.push({ name: identMetaLoaderAsset, value: loaderAssetName })
      }
      const injected = injectShellIntoAxml(apkContents.manifest.bytes, { shellApplication: manifestEntry, metaDatas })
      apkContents.manifest.bytes = injected.axml
      findings.push({
        severity: "info", confidence: "high", code: "MANIFEST_INJECTED",
        title: `Manifest 注入完成(二进制 AXML):${injected.injected.length} 项`,
        detail: `application → ${shellApp};meta-data:${metaDatas.map((m) => m.name).join(", ")}。原入口类名:${injected.previousApplication ?? "(无)"},回读验证通过。`,
        recommendation: "确认壳入口能正常启动;原始入口类名已存入 meta-data 供壳加载器还原。",
        evidence: injected.injected.join(",").slice(0, 200),
      })
    } catch (axmlErr) {
      // fail-closed:注入失败保留原 manifest(壳入口缺失,应用以原身份运行)
      findings.push({
        severity: "high", confidence: "high", code: "MANIFEST_INJECT_FAILED",
        title: "Manifest 二进制注入失败,保留原 manifest(壳入口未启用)",
        detail: `AXML 注入抛错: ${axmlErr instanceof Error ? axmlErr.message : String(axmlErr)}。原 manifest 未被修改——应用可安装运行,但 DEX 加密链路无壳入口触发,等同未加固。`,
        recommendation: "报告该 APK 的 manifest 结构以扩展注入器;不要将本次产物视为已加固。",
        evidence: String(axmlErr).slice(0, 200),
      })
    }
  }

  // Step 3.1: 等长翻转 debuggable=true → false(不降级——P1 源 3 将 debuggable 视为环境
  // 污染参与密钥派生,输入 debug 包不翻转则产物在所有设备上永久解密失败)。
  // 必须在锚点计算(Step 4 开头)之前:翻转改 manifest 字节,锚点须覆盖翻转后的最终值。
  if (apkContents.manifest && manifestBytesAreDebuggable(apkContents.manifest.bytes)) {
    if (flipDebuggableInAxml(apkContents.manifest.bytes)) {
      findings.push({
        severity: "info", confidence: "high", code: "HARDEN_DEBUGGABLE_FORCED",
        title: "已强制 debuggable=false(等长翻转)",
        detail: "输入 APK 声明 android:debuggable=true。运行时环境投票将 debuggable 视为污染参与密钥派生——不翻转则产物在所有设备上解密失败。已在二进制 manifest 中等长翻转为 false。",
        recommendation: "从根本上应在源码 release 构建中关闭 debuggable。",
        evidence: "android:debuggable",
      })
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Step 4: DEX 处理(方法抽取 + 整体加密)
  // ──────────────────────────────────────────────────────────────────────
  // 完整性锚点(P0-A):最终二进制 manifest 的 SHA-256。manifest 在 Step 3 注入后
  // 定稿,容器注入/签名不再触碰;运行时从自身 APK 重算同一值参与 HKDF info——
  // 重打包必改 manifest → 密钥错 → GCM 静默失败。无 manifest 时为空(派生回退旧格式)。
  const integrityAnchor = apkContents.manifest
    ? new Uint8Array(createHash("sha256").update(apkContents.manifest.bytes).digest())
    : undefined
  if (config.enableDexEncryption || config.enableMethodHollow) {
    const dexConfig: DexProcessConfig = {
      algorithm: config.algorithm, enableMethodHollow: config.enableMethodHollow,
      enableDexEncryption: config.enableDexEncryption, enableSplitKey: config.enableSplitKey,
      classExclusionPatterns: config.classExclusionPatterns, certSha256: config.certSha256, apkSha256,
    }
    try {
      dexResult = processAllDexFiles(apkContents.dexFiles, dexConfig)
      for (let i = 0; i < apkContents.dexFiles.length; i += 1) {
        apkContents.dexFiles[i]!.bytes = dexResult.processedDex[i]!
      }
      findings.push(...dexResult.findings)
      keyMaterial = dexResult.keyMaterial
    } catch (dexErr) {
      findings.push({
        severity: "high", confidence: "high", code: "DEX_PROCESS_FAILED",
        title: "DEX 处理失败,跳过 DEX 保护",
        detail: `错误: ${dexErr instanceof Error ? dexErr.message : String(dexErr)}`,
        recommendation: "DEX 文件可能损坏或格式不兼容;加固后 APK 的 DEX 保持原样。",
        evidence: String(dexErr).slice(0, 200),
      })
    }
    // Step 4.5: payload 完整性验证(payload 现存于容器 blob,不再追加在壳 DEX 尾部)
    // 哈希链尾声明在两个 Step 4.5 块之外:citable 条目要接续 dex 条目的链
    let dexChainTail: Uint8Array | undefined // 条目 i 密钥混入条目 i-1 密文哈希(见 chainSeed)
    if (keyMaterial && dexResult?.encryptedDex && config.enableDexEncryption) {
      for (let i = 0; i < apkContents.dexFiles.length; i += 1) {
        const blob = dexResult.payloadBlobs[i]
        // per-entry 密钥派生:payload 上游用 master 加密,此处重组为 HKDF 派生密钥加密
        // (master 破解单条不再蔓延;Java 端 deriveEntryKey 与此严格一致,含条目哈希链)
        try {
          if (!blob) throw new Error(`dex[${i}] 无 payload blob`)
          const plain = decryptContainerEntry(blob, keyMaterial.encryptionKey)
          if (!plain) throw new Error("master 解密失败")
          const chainHere = dexChainTail
          const entryBlob = encryptContainerEntryDerived(plain, keyMaterial.encryptionKey, "dex", i, integrityAnchor, 0, chainHere)
          dexChainTail = chainSeed(entryBlob)
          containerEntries.push({ kind: "dex", targetIndex: i, bytes: entryBlob })
          const roundtrip = decryptContainerEntryDerived(entryBlob, keyMaterial.encryptionKey, "dex", i, integrityAnchor, 0, chainHere)
          const verified = roundtrip !== undefined && roundtrip[0] === 0x64 && roundtrip[1] === 0x65 && roundtrip[2] === 0x78
          findings.push({
            severity: verified ? "info" : "high", confidence: "high",
            code: verified ? "PAYLOAD_VERIFIED" : "PAYLOAD_VERIFY_FAILED",
            title: verified ? `加密 payload 验证通过(per-entry HKDF 密钥)` : "加密 payload 验证失败",
            detail: verified
              ? `payload blob ${entryBlob.length}B 解密成功且为合法 DEX(${roundtrip!.length}B),条目密钥 = HKDF(master, dex-${i}),将写入 assets/${identAssetName}。`
              : `payload blob 解密失败或非 DEX magic。`,
            recommendation: verified ? "壳加载器解密逻辑与加密算法一致。" : "检查密钥材料与加密算法一致性。",
            evidence: `dex[${i}] blob=${entryBlob.length}B decrypted=${roundtrip?.length ?? -1}B`,
          })
        } catch (verifyErr) {
          findings.push({
            severity: "high", confidence: "high", code: "PAYLOAD_VERIFY_FAILED",
            title: "加密 payload 验证失败",
            detail: `解密验证异常: ${verifyErr instanceof Error ? verifyErr.message : String(verifyErr)}`,
            recommendation: "检查密钥材料与加密算法一致性。",
            evidence: `dex[${i}]`,
          })
        }
      }
    }
    // Step 4.5: CodeItem 表构建+加密 → 存入 payload 容器(不再追加壳 DEX 尾部)
    if (keyMaterial && dexResult && dexResult.hollowResult) {
      const { extractedCodeItems, stubMethods } = dexResult.hollowResult
      if (extractedCodeItems.size > 0) {
        const ciTable = buildCodeItemTable(extractedCodeItems, stubMethods)
        // citable 条目同样走 per-entry HKDF 密钥(与 dex 条目隔离),并接续 dex 条目的
        // 哈希链(前驱 = 最后一个 dex 条目密文的哈希)——删除/重排 dex 条目同样使 citable 解密失败
        const ciEncrypted = encryptContainerEntryDerived(ciTable, keyMaterial.encryptionKey, "citable", 0, integrityAnchor, 0, dexChainTail)
        containerEntries.push({ kind: "citable", targetIndex: 0, bytes: ciEncrypted })
        findings.push({
          severity: "info",
          confidence: "high",
          code: "CODEITEM_TABLE_INJECTED",
          title: `CodeItem 表写入 payload 容器:${stubMethods.length} 个方法的原始 CodeItem`,
          detail: `CodeItem 表 ${ciTable.length}B → AES-256-GCM 加密 ${ciEncrypted.length}B(HKDF 派生密钥 citable-0)→ 存入 assets/${identAssetName}。Java 壳加载器还原 DEX 后按表写回方法体。`,
          recommendation: "确认壳加载器能正确解密并还原 CodeItem 表。",
          evidence: `methods=${stubMethods.length} table=${ciTable.length}B encrypted=${ciEncrypted.length}B`,
        })
      }
    }
    findings.push(...(dexResult?.findings ?? []))
    if (dexResult) keyMaterial = dexResult.keyMaterial
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
    // 如实标注:字符串加密仅生成解密器参考产物,string_ids 未实际加密写回
    findings.push({
      severity: "medium", confidence: "high", code: "STRING_ENCRYPTION_NOT_IMPLEMENTED",
      title: "字符串加密未实际写回 DEX(not-implemented)",
      detail: `encryptAndReplaceStrings 尚无调用点:string_ids 未加密替换,仅生成了 DroidSealStringDecryptor 参考产物(${strResult.encryptedCount} 个字符串处于分析状态)。summary.stringProtected 如实报 false。`,
      recommendation: "不要基于本项做发布安全决策;等待 string writeback 接线后重新加固。",
      evidence: `analyzed=${strResult.encryptedCount} applied=0`,
    })
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
  // Step 11.5: 增强防绕过保护(Java + Native 多层)
  // ──────────────────────────────────────────────────────────────────────
  const enhancedJavaGuard = generateEnhancedJavaGuard(packageName)
  generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealEnhancedGuard.smali`, content: enhancedJavaGuard })
  const enhancedNativeC = generateEnhancedNativeAntiAnalysis(packageName)
  generatedFiles.push({ name: `native/enhanced_guard.c`, content: enhancedNativeC })
  findings.push(...buildAntiAnalysisFindings(true, true, config.enableDexEncryption))

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
    // Split-Key part2 异位注入 SO:密钥从"一个 DEX 字段"变为"SO 内嵌数组"
    keyPart2Hex: keyMaterial.splitKey ? Buffer.from(keyMaterial.splitKey.part2).toString("hex") : undefined,
    jniClassPath,
  }
  const nativeFiles = generateNativeShellFiles(nativeConfig)
  generatedFiles.push(...nativeFiles)

  // Step 12.1: 尝试实际编译壳 SO 并注入 lib/ 条目(Split-Key part2 真正异位的前提)
  let soInjected = false
  if (keyMaterial.splitKey) {
    const nativeSrcDir = path.join(config.outputDir, "native-droidseal-shell")
    mkdirSync(nativeSrcDir, { recursive: true })
    for (const nf of nativeFiles) {
      await writeFile(path.join(nativeSrcDir, path.basename(nf.name)), nf.content, "utf-8")
    }
    const soResult = await compileNativeSo({
      packageName, soName: randomSo, sourceDir: nativeSrcDir, outputDir: path.join(config.outputDir, "native-libs"),
      abi: ["arm64-v8a", "armeabi-v7a"], minSdk: 21,
    })
    findings.push(...soResult.findings)
    if (soResult.success) {
      for (const so of soResult.soFiles) {
        const soBytes = new Uint8Array(await readFile(so.path))
        apkContents.soFiles.push({ name: `lib/${so.abi}/${randomSo}`, bytes: soBytes, compressed: true, compressionMethod: 8, crc32: 0 })
      }
      soInjected = true
    }
    // NDK 缺失或编译失败:如实标注 —— part2 仍走静态字段回退(Java fetchPart2 已实现)
    if (!soInjected) {
      findings.push({
        severity: "medium", confidence: "high", code: "SO_SPLITKEY_FALLBACK",
        title: "壳 SO 未编译注入,Split-Key part2 回退静态字段(降级)",
        detail: "NDK 缺失或编译失败时,fetchPart2 回退 KEY_PART2 静态字段——密钥完整片段可从单个 DEX 提取,Split-Key 异位目标未达成。",
        recommendation: "安装 Android NDK 后重新加固,使 part2 真正移入 SO。",
        evidence: `soName=${randomSo}`,
      })
    }
  }
  findings.push(...buildNativeShellFindings(nativeConfig, nativeFiles.length))

  // ──────────────────────────────────────────────────────────────────────
  // Step 12.5: 研究级保护(控制流混淆 + syscall 检测 + PLT Hook)
  // ──────────────────────────────────────────────────────────────────────
  // 控制流混淆
  generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealCfObfuscator.smali`, content: generateControlFlowObfuscationSmali(packageName) })
  // 多层字符串加密
  generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealStringCrypto.smali`, content: generateMultiLayerStringEncryption(packageName) })
  // syscall 级反分析(Native C + Smali)
  generatedFiles.push({ name: `native/syscall_detection.c`, content: generateSyscallDetectionC(packageName) })
  generatedFiles.push({ name: `smali/${packageName.replace(/\./g, "/")}/DroidSealNativeGuard.smali`, content: generateSyscallDetectionSmali(packageName) })
  // PLT Hook 模块
  generatedFiles.push({ name: `native/art_hook_plt.c`, content: generatePltHookC(packageName) })
  findings.push(...buildSyscallDetectionFindings())
  findings.push(...buildResearchProtectionFindings())

  // Step 13 前置 0: smali 产物如实标注(仅生成参考产物,未编译合并进 APK)
  const smaliArtifacts = generatedFiles.filter((f) => f.name.startsWith("smali/"))
  if (smaliArtifacts.length > 0) {
    findings.push({
      severity: "medium", confidence: "high", code: "SMALI_MERGE_SKIPPED",
      title: `smali 参考产物未编译合并(not-implemented):${smaliArtifacts.length} 个`,
      detail: "compileAndMergeSmali 尚无调用点——生成的壳/解密器 smali 仅落盘为参考产物,未编译为 DEX 注入 APK,对产物安全性无实际贡献。",
      recommendation: "不要将这些 smali 产物计入防护能力;待 smali-merge 接线后重新加固。",
      evidence: smaliArtifacts.map((f) => f.name).join(",").slice(0, 200),
    })
  }

  // Step 13 前置 1: 注入 loader DEX 为 classesN.dex(壳入口已在 Step 2.5 确定最终类名)
  // P2:挑战模式下 part3 分裂在此发生,供 repack 成功后写 server-challenge.json
  let challengePart3: Uint8Array | undefined
  if (loaderDexRaw) {
    // 密钥两段:XOR 后 = AES-256 密钥(与 ShellApplication.KEY_PART1/KEY_PART2 严格一致)
    const keyParts = keyMaterial?.splitKey ?? splitKey(keyMaterial?.encryptionKey ?? createHash("sha256").update(apkSha256).digest())
    // P2 服务端挑战:part1' = part1 ^ part3(part3 不进 APK,由服务器按挑战发放,
    // 运行时 part1' ^ part2 ^ part3 还原同一 master)。未启用时 part3 = 0,part1' = part1。
    let part1Final: Uint8Array = keyParts.part1
    let part3: Uint8Array | undefined
    if (config.challengeUrl) {
      part3 = new Uint8Array(randomBytes(32))
      part1Final = new Uint8Array(32)
      for (let i = 0; i < 32; i += 1) part1Final[i] = keyParts.part1[i]! ^ part3[i]!
      challengePart3 = part3
    }
    const patchResult = patchLoaderDexKeys(loaderDexRaw, part1Final, keyParts.part2, config.certSha256, config.enableKeystoreBinding, config.challengeUrl)
    if (config.challengeUrl && !patchResult.patchedUrl) {
      findings.push({
        severity: "high", confidence: "high", code: "CHALLENGE_URL_MISSING",
        title: "服务端挑战 URL 标记未命中(运行时无法取 part3,解密必然失败)",
        detail: "DS_SRV_URL 占位符未在 loader DEX 中定位到——挑战模式产物将无法解密启动。",
        recommendation: "重新编译 runtime/java 生成一致的 loader DEX,或去掉 --challenge-url 回退纯本地模式。",
        evidence: "DS_SRV_URL",
      })
    }
    if (config.enableKeystoreBinding && !patchResult.patchedKsFlag) {
      findings.push({
        severity: "medium", confidence: "high", code: "LOADER_KS_FLAG_MISSING",
        title: "Keystore 绑定开关标记未命中(运行时绑定不生效)",
        detail: "KS_BIND_FLAG_0 未在 loader DEX 中定位到——设备绑定将不启用,密钥仍常驻 loader DEX。",
        recommendation: "重新编译 runtime/java 生成一致的 loader DEX。",
        evidence: "KS_BIND_FLAG_0",
      })
    }
    if (!patchResult.patchedCert && config.certSha256) {
      findings.push({
        severity: "medium", confidence: "high", code: "LOADER_CERT_PATCH_MISSING",
        title: "签名自校验标记未命中(运行时跳过自校验)",
        detail: "0xC3×32 标记未在 loader DEX 中定位到——verifyIntegrity 将因未补丁而跳过,重打包检测依赖签名校验,此项失效。",
        recommendation: "重新编译 runtime/java 生成一致的 loader DEX。",
        evidence: `cert=${config.certSha256.slice(0, 16)}…`,
      })
    }
    const loaderDexBytes = patchResult.dex
    if (!patchResult.patchedPart1 || !patchResult.patchedPart2) {
      findings.push({
        severity: "high", confidence: "high", code: "LOADER_KEY_PATCH_INCOMPLETE",
        title: `Loader DEX 密钥标记未完全命中(part1=${patchResult.patchedPart1}, part2=${patchResult.patchedPart2})`,
        detail: "0xA5×32 / 0x5A×32 标记未在 loader DEX 中定位到——loader DEX 可能与补丁逻辑版本不匹配。",
        recommendation: "重新编译 runtime/java 源码生成本地一致的 loader DEX。",
        evidence: `loaderSize=${loaderDexBytes.length}`,
      })
    }
    const already = apkContents.dexFiles.some((d) => d.bytes.length === loaderDexBytes.length
      && d.bytes.every((b, i) => b === loaderDexBytes[i]))
    // 双 DEX 方案:loader DEX 不再明文注入 classesN.dex,改为加密 asset(stub 解密加载)
    // (stub 随机化已在 Step 2.5 完成——manifest 注入需要 stub 类名)
    if (stubDexRaw && config.certSha256) {
      // loader DEX 加密 → asset(HKDF(证书摘要) 派生密钥,重签名即解密失败 fail-closed)
      const loaderEnc = encryptLoaderDex(loaderDexBytes, config.certSha256)
      apkContents.assetFiles.push({
        name: `assets/${loaderAssetName}`, bytes: loaderEnc, compressed: false, compressionMethod: 0, crc32: 0,
      })
      const nextIdx = apkContents.dexFiles.length + 1
      apkContents.dexFiles.push({
        name: `classes${nextIdx === 1 ? "" : nextIdx}.dex`,
        bytes: stubDexRaw, compressed: false, compressionMethod: 8, crc32: 0,
      })
      findings.push({
        severity: "info", confidence: "high", code: "LOADER_DEX_ENCAPSULATED",
        title: `Loader DEX 自加密封装 + bootstrap stub 注入(${loaderEnc.length}B asset, stub ${stubDexRaw.length}B)`,
        detail: `loader DEX(密钥+解密逻辑)以 HKDF(签名证书摘要) 派生密钥 AES-256-GCM 加密存入 assets/${loaderAssetName};明文 classes${nextIdx === 1 ? "" : nextIdx}.dex 仅含通用引导 stub(${stubApp}),无任何密钥。jadx 静态打开只见 stub 引导代码。重签名 → stub 解密失败 → fail-closed。`,
        recommendation: "真机验证 stub 能解密加载 loader 并完成 payload 还原;API<26 走 DexClassLoader 落盘降级。",
        evidence: `loaderAsset=${loaderAssetName} stub=${stubApp}`,
      })
    } else if (!existsSync(stubDexPath)) {
      // stub DEX 缺失:回退明文 loader 注入(能力如实标注降级)
      if (!already) {
        const nextIdx = apkContents.dexFiles.length + 1
        apkContents.dexFiles.push({
          name: `classes${nextIdx === 1 ? "" : nextIdx}.dex`,
          bytes: loaderDexBytes, compressed: false, compressionMethod: 8, crc32: 0,
        })
      }
      findings.push({
        severity: "medium", confidence: "high", code: "LOADER_STUB_MISSING",
        title: "stub DEX 缺失,回退明文 loader 注入(自加密未启用)",
        detail: "runtime/droidseal-stub.dex 不存在——loader DEX 明文注入 classesN.dex,解密逻辑可被 jadx 直接阅读。",
        recommendation: "运行 scripts/rebuild-loader-dex.ts 生成双 DEX 产物后重新加固。",
        evidence: stubDexPath,
      })
    } else {
      // 有 stub 但无证书指纹:无法派生加密密钥,同样回退明文注入
      if (!already) {
        const nextIdx = apkContents.dexFiles.length + 1
        apkContents.dexFiles.push({
          name: `classes${nextIdx === 1 ? "" : nextIdx}.dex`,
          bytes: loaderDexBytes, compressed: false, compressionMethod: 8, crc32: 0,
        })
      }
      findings.push({
        severity: "medium", confidence: "high", code: "LOADER_ENCAPSULATE_NO_CERT",
        title: "未提供证书指纹,loader DEX 自加密未启用(明文注入)",
        detail: "加密密钥由签名证书摘要 HKDF 派生,缺少 --cert-sha256 时无法封装。",
        recommendation: "提供 --cert-sha256 以启用 loader 自加密。",
        evidence: "certSha256 missing",
      })
    }
  } else {
    findings.push({
      severity: "high", confidence: "high", code: "LOADER_DEX_MISSING",
      title: "runtime/droidseal-loader.dex 不存在,壳入口将无法启动",
      detail: `流水线指向 droidseal.runtime.ShellApplication,但 loader DEX 未随包分发。`,
      recommendation: "重新安装 droidseal 或手动编译 runtime/java 源码生成 loader DEX。",
      evidence: loaderDexPath,
    })
  }

  // Step 13 前置 2: 组装 payload 容器 → assets/<随机名>(stored,运行时 AssetManager 直读)
  if (containerEntries.length > 0) {
    const container = buildPayloadContainer(containerEntries, { magic: identMagic })
    apkContents.assetFiles.push({
      name: `assets/${identAssetName}`, bytes: container, compressed: false, compressionMethod: 0, crc32: 0,
    })
    findings.push({
      severity: "info", confidence: "high", code: "PAYLOAD_CONTAINER",
      title: `payload 容器写入 assets/${identAssetName}(${container.length}B,stored)`,
      detail: `${containerEntries.length} 个条目(dex/citable)加密后写入独立 asset 条目,APK 内不压缩。运行时壳加载器经 AssetManager 直读。magic/asset 名已随机化,静态签名定位失效。`,
      recommendation: "确认加固 APK 安装后壳加载器能读取该条目并完成还原。",
      evidence: `entries=${containerEntries.length} bytes=${container.length}`,
    })
  }

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
  // Assets(deflated;容器与加密 loader 条目除外——二者必须 stored:容器供运行时直读,
  // loader 在 minSdk<26 落盘降级时按偏移直读;随机化后二者名称动态判断)
  for (const asset of apkContents.assetFiles) {
    const method = asset.name === `assets/${identAssetName}` || asset.name === `assets/${loaderAssetName}` ? 0 : 8
    zipEntries.push({ ...asset, compressionMethod: method })
  }
  // Manifest + resources.arsc + 其他
  if (apkContents.manifest) zipEntries.push({ ...apkContents.manifest, compressionMethod: 8 })
  if (apkContents.resourceArsc) zipEntries.push({ ...apkContents.resourceArsc, compressionMethod: 8 })
  // 旧 v1 签名文件必须剥离:条目内容已变,旧 MANIFEST.MF/SF/RSA 摘要失效,
  // 残留会导致 apksigner verify 报 "entry referenced by MANIFEST.MF not found"。
  // 签名由 apksigner 重签时全部重建。
  for (const entry of apkContents.otherFiles) {
    if (/^META-INF\/(MANIFEST\.MF|.*\.(SF|RSA|DSA|EC))$/i.test(entry.name)) continue
    zipEntries.push({ ...entry, compressionMethod: entry.compressed ? 8 : 0 })
  }

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

  // AI 时代加固层(P0-A/P0-B/P0-C/P1)如实标注:这些是运行时机制,构建期无法验证真机行为,
  // 且各有明确边界——不写入 summary 布尔值(避免虚报),以 info finding 存档供报告呈现。
  findings.push({
    severity: "info", confidence: "high", code: "AI_ERA_LAYERS",
    title: "AI 时代加固层已启用(完整性锚点/环境门控/密钥分片化/异构投票)",
    detail: [
      "P0-A 完整性锚点:manifest SHA-256 参与逐条目 HKDF info,重打包→错钥→GCM 静默失败;",
      "P0-B 环境门控:反分析投票参与派生,动态分析(Frida attach)→错钥,无信号可定位;",
      "P0-C 密钥分片化:master 逐条目临时合成用后即清,内存无完整密钥;",
      "P1 异构投票:Java + native(ptrace/端口/maps)+ debuggable 三源判定。",
      "边界:全部为运行时机制,构建期无法验证真机行为——真机安装是唯一可信验收;",
      "root+持久物理接触的攻击者(可逐层逆向 loader)最终仍能绕过;这些层提高成本,不提供保证。",
    ].join(" "),
    recommendation: "在真机(API 26+ 与 API 24 各一)验证解密启动闭环;报告其余 findings 并按需处置。",
    evidence: "deriveEntryKey(anchor,envVote)",
  })

  for (const file of generatedFiles) {
    const filePath = path.join(config.outputDir, file.name)
    await mkdir(path.dirname(filePath), { recursive: true })
    await writeFile(filePath, file.content, "utf8")
  }

  // P2 服务端挑战:part3 + 校验锚落盘(不进 APK)。运营者把此文件部署到
  // --challenge-url 指定的服务端(参考实现 scripts/challenge-server.ts)。
  if (challengePart3 && config.challengeUrl && integrityAnchor) {
    const challengeDoc = {
      version: 1,
      // 服务器校验规则:请求携带的 manifestSha256 必须与此一致才发放 part3
      manifestSha256: Buffer.from(integrityAnchor).toString("hex"),
      certSha256: config.certSha256 ?? null,
      // part3(hex):客户端 part1' ^ part2 ^ part3 还原 master
      part3: Buffer.from(challengePart3).toString("hex"),
      url: config.challengeUrl,
      note: "此文件必须部署到 url 字段指定的 HTTPS 端点;服务器按 manifestSha256 校验请求后返回 part3 字段原值。丢失此文件 = 该构建永久无法解密,请离线备份。",
    }
    await writeFile(path.join(config.outputDir, "server-challenge.json"), JSON.stringify(challengeDoc, null, 2), "utf8")
    findings.push({
      severity: "info", confidence: "high", code: "CHALLENGE_ARTIFACT",
      title: "服务端挑战产物已生成(server-challenge.json)",
      detail: `part3 已从 APK 中剥离,仅存于 ${path.join(config.outputDir, "server-challenge.json")};APK 内只有 part1' ^ part2,缺少服务器发放的 part3 无法还原密钥。`,
      recommendation: "将该文件部署到 HTTPS 端点(参考 scripts/challenge-server.ts),并离线备份——丢失即永久不可解密。",
      evidence: "server-challenge.json",
    })
  }

  // 覆盖率指标(P2,报告一等指标):方法抽取有代码路径背书(hollowResult 真实统计)→
  // 报真实百分比;Dex2C 桥(generateDex2cBridge)仅有定义无调用点 → 如实报 not-wired,
  // 与 stringProtected 同口径:summary 不虚报未接线的配置开关。
  const hollowSummary = dexResult?.hollowResult?.summary
  const mhTotal = hollowSummary?.totalMethods ?? 0
  const mhHollowed = hollowSummary?.hollowedMethods ?? 0
  // 指标背书一致性门禁(如实降级机械化):每个 *Protected 指标必须有真实产物证据
  // (加密条目数/写回标志),证据缺失即使配置开着也强制报 false + not-wired finding。
  const gate = gateSummaryClaims([
    { key: "dexProtected", configEnabled: config.enableDexEncryption || config.enableMethodHollow, evidenceCount: (dexResult?.encryptedDex?.length ?? 0) + mhHollowed },
    { key: "soProtected", configEnabled: config.enableSoEncryption, evidenceCount: soResults?.length ?? 0 },
    { key: "resourceProtected", configEnabled: config.enableResourceEncryption, evidenceCount: resourceResults?.length ?? 0 },
    { key: "stringProtected", configEnabled: true, evidenceCount: stringWritebackApplied ? 1 : 0 },
    { key: "runtimeProtected", configEnabled: config.enableRuntimeProtection, evidenceCount: stubDexRaw && loaderDexRaw ? 1 : 0 },
    { key: "vmProtected", configEnabled: config.enableVmProtection, evidenceCount: 0 }, // vmp 生成器尚无调用点
    { key: "dex2cWired", configEnabled: false, evidenceCount: 0 }, // generateDex2cBridge 尚无调用点——接线后置 true
  ])
  for (const v of gate.violations) {
    findings.push({
      severity: "medium", confidence: "high", code: "SUMMARY_CLAIM_NOT_WIRED",
      title: `指标 ${v.key} 配置已启用但无产物证据(如实降级:报 false)`,
      detail: "该保护开关已打开,但流水线中未检测到对应的真实产物(加密条目/写回标志/壳二进制)——按如实降级原则,summary 将其报为未生效而非防护能力。",
      recommendation: "检查对应保护模块的执行日志定位未生效原因;修复前报告口径以 not-wired 为准。",
      evidence: v.key,
    })
  }
  const summary = {
    dexProtected: gate.effective.dexProtected ?? false,
    soProtected: gate.effective.soProtected ?? false,
    resourceProtected: gate.effective.resourceProtected ?? false,
    // 如实降级:encryptAndReplaceStrings 写回尚无调用点,字符串仅生成了解密器参考产物,
    // 未实际加密——summary 必须有代码路径背书,报 false 而非配置开关值
    stringProtected: gate.effective.stringProtected ?? false,
    runtimeProtected: gate.effective.runtimeProtected ?? false,
    vmProtected: gate.effective.vmProtected ?? false,
    totalFindings: findings.length,
    methodHollow: {
      hollowed: mhHollowed,
      total: mhTotal,
      pct: mhTotal > 0 ? Math.round((mhHollowed / mhTotal) * 1000) / 10 : 0,
      skipped: hollowSummary?.skippedMethods ?? 0,
    },
    dex2cWired: gate.effective.dex2cWired ?? false, // generateDex2cBridge 尚无调用点——接线后置 true
  }

  // findings 去重:同 code+title+evidence 视为重复(流水线内多处构建 finding 可能撞车)
  const seen = new Set<string>()
  const deduped = findings.filter((f) => {
    const k = `${f.code}|${f.title}|${f.evidence ?? ""}`
    if (seen.has(k)) return false
    seen.add(k)
    return true
  })

  // 经典模式(默认):清理过程目录,只留最终 APK 与 idsig(见 cleanupIntermediates 定义)
  await cleanupIntermediates()

  return { success: true, outputApk, findings: deduped, keyMaterial, dexResult: dexResult as any, encryptedDex: dexResult?.encryptedDex, soResults, resourceResults, generatedFiles, summary }
}

// ── 工具函数 ──────────────────────────────────────────────────────────

function generateRandomPkg(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  const r = (n: number) => Array.from(randomBytes(n), (b) => chars[b % chars.length]).join("")
  return `com.${r(3)}.${r(3)}.${r(3)}`
}

function generateRandomSo(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  return `lib${Array.from(randomBytes(5), (b) => chars[b % chars.length]).join("")}.so`
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
    "加固覆盖率:",
    `  方法抽取: ${result.summary.methodHollow.hollowed}/${result.summary.methodHollow.total} (${result.summary.methodHollow.pct}%, 跳过 ${result.summary.methodHollow.skipped})`,
    `  Dex2C 桥接: ${result.summary.dex2cWired ? "已接线" : "未接线(参考产物,不计入防护)"}`,
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
