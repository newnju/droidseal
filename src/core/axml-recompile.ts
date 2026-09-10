// Manifest AXML 重编译模块（P0-4）。
// 修改后的 XML 文本需要通过 aapt2 compile + link 编译为二进制 AXML，
// 才能替换 APK 中的 AndroidManifest.xml。
// 如果 aapt2 不可用，提供纯 TypeScript AXML 写入器作为备选。
// 纯 TypeScript 失败关闭。
import { spawnSync } from "node:child_process"
import { writeFile, readFile, mkdir, rm } from "node:fs/promises"
import { readdirSync, existsSync } from "node:fs"
import path from "node:path"
import type { Finding } from "./types.ts"

// ── aapt2 检测 ──────────────────────────────────────────────────────

function findAapt2(): string | undefined {
  const candidates = ["aapt2"]
  for (const cmd of candidates) {
    const result = spawnSync(cmd, ["version"], { timeout: 5000, stdio: "pipe" })
    if (result.status === 0) return cmd
  }
  // 尝试 Android SDK 路径
  const sdkRoot = process.env.ANDROID_HOME ?? process.env.ANDROID_SDK_ROOT ?? ""
  if (sdkRoot) {
    const buildToolsDirs = [
      path.join(sdkRoot, "build-tools"),
    ]
    for (const dir of buildToolsDirs) {
      try {
        const entries = readdirSync(dir)
        for (const entry of entries) {
          const candidate = path.join(dir, entry, "aapt2")
          const result = spawnSync(candidate, ["version"], { timeout: 5000, stdio: "pipe" })
          if (result.status === 0) return candidate
        }
      } catch { /* continue */ }
    }
  }
  return undefined
}

// ── AXML 重编译 ──────────────────────────────────────────────────────

/**
 * 通过 aapt2 将 XML 文本编译为二进制 AXML。
 * 流程: xml → aapt2 compile → .flat → aapt2 link → AndroidManifest.xml (binary)
 */
export async function recompileManifestXml(
  xmlContent: string,
  packageName: string,
  minSdk: number = 21,
  targetSdk: number = 34,
): Promise<{ axmlBytes: Uint8Array | undefined; findings: Finding[] }> {
  const findings: Finding[] = []
  const aapt2 = findAapt2()

  if (!aapt2) {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "AXML_RECOMPILE_NO_AAPT2",
      title: "aapt2 不可用，无法重编译 Manifest",
      detail: "Manifest XML 修改后需要 aapt2 compile+link 编译为二进制 AXML。当前环境未检测到 aapt2。",
      recommendation: "安装 Android SDK Build Tools（aapt2 在 build-tools/<version>/ 下）。",
      evidence: "aapt2 not found",
    })
    return { axmlBytes: undefined, findings }
  }

  // 创建临时目录
  const tmpDir = path.join(process.cwd(), ".droidseal-axml-tmp")
  await mkdir(tmpDir, { recursive: true })
  const xmlPath = path.join(tmpDir, "AndroidManifest.xml")
  const flatDir = path.join(tmpDir, "flat")
  const outputDir = path.join(tmpDir, "output")

  try {
    // 写入 XML 文件
    await writeFile(xmlPath, xmlContent, "utf8")

    // aapt2 compile -o flat_dir manifest.xml
    await mkdir(flatDir, { recursive: true })
    const compileResult = spawnSync(aapt2, [
      "compile",
      "--dir", tmpDir,
      "-o", flatDir,
    ], { timeout: 30000, stdio: "pipe" })

    if (compileResult.status !== 0) {
      findings.push({
        severity: "high",
        confidence: "high",
        code: "AXML_COMPILE_FAILED",
        title: "aapt2 compile 失败",
        detail: compileResult.stderr?.toString() ?? "未知错误",
        recommendation: "检查 XML 语法是否正确；确认 aapt2 版本兼容。",
        evidence: compileResult.stderr?.toString().slice(0, 200) ?? "",
      })
      return { axmlBytes: undefined, findings }
    }

    // aapt2 link -o output.apk --manifest AndroidManifest.xml
    await mkdir(outputDir, { recursive: true })
    const linkResult = spawnSync(aapt2, [
      "link",
      "-o", path.join(outputDir, "dummy.apk"),
      "--manifest", xmlPath,
      "--min-sdk-version", String(minSdk),
      "--target-sdk-version", String(targetSdk),
      "--version-code", "1",
      "--version-name", "1.0",
      "-I", getAndroidJar() ?? "",
      "--auto-add-overlay",
    ], { timeout: 30000, stdio: "pipe" })

    if (linkResult.status !== 0) {
      findings.push({
        severity: "high",
        confidence: "high",
        code: "AXML_LINK_FAILED",
        title: "aapt2 link 失败",
        detail: linkResult.stderr?.toString() ?? "未知错误",
        recommendation: "检查 --min-sdk-version 和 --target-sdk-version 是否合法。",
        evidence: linkResult.stderr?.toString().slice(0, 200) ?? "",
      })
      return { axmlBytes: undefined, findings }
    }

    // 从生成的 APK 中提取 AndroidManifest.xml
    const dummyApk = path.join(outputDir, "dummy.apk")
    const axmlBytes = await extractManifestFromApk(dummyApk)

    if (axmlBytes) {
      findings.push({
        severity: "info",
        confidence: "high",
        code: "AXML_RECOMPILED",
        title: "Manifest AXML 重编译完成",
        detail: `aapt2 compile + link 成功；生成 ${axmlBytes.length}B 的二进制 AXML。`,
        recommendation: "确认重编译后的 Manifest 与原始 Manifest 结构一致。",
        evidence: `size=${axmlBytes.length}B`,
      })
    }

    return { axmlBytes, findings }
  } finally {
    await rm(tmpDir, { recursive: true, force: true }).catch(() => undefined)
  }
}

/**
 * 从 APK 中提取 AndroidManifest.xml。
 */
async function extractManifestFromApk(apkPath: string): Promise<Uint8Array | undefined> {
  const result = spawnSync("unzip", ["-p", apkPath, "AndroidManifest.xml"], { timeout: 10000, stdio: "pipe" })
  if (result.status === 0 && result.stdout.length > 0) {
    return new Uint8Array(result.stdout)
  }
  return undefined
}

/**
 * 获取 android.jar 路径（aapt2 link 需要）。
 */
function getAndroidJar(): string | undefined {
  const sdkRoot = process.env.ANDROID_HOME ?? process.env.ANDROID_SDK_ROOT ?? ""
  if (!sdkRoot) return undefined
  // 尝试最高版本
  const platformsDir = path.join(sdkRoot, "platforms")
  try {
    const entries = readdirSync(platformsDir)
    const sorted = entries.filter((e: string) => e.startsWith("android-")).sort().reverse()
    for (const entry of sorted) {
      const jar = path.join(platformsDir, entry, "android.jar")
      if (existsSync(jar)) return jar
    }
  } catch { /* continue */ }
  return undefined
}

/**
 * 从 AXML 二进制中提取包名（纯 TypeScript 解析）。
 */
export function extractPackageNameFromAxml(axmlBytes: Uint8Array): string {
  try {
    // AXML 中 package 属性通常在第一个 START_TAG 的属性中
    // 简化解析:搜索 "package" 字符串后的值
    const text = new TextDecoder("utf-8", { fatal: false }).decode(axmlBytes)
    const match = /package["\s]*["']([^"']+)["']/.exec(text)
    if (match) return match[1]!
  } catch { /* ignore */ }
  return ""
}

/**
 * 完整 Manifest 重编译流程。
 * 1. 解析 AXML → XML 文本
 * 2. 注入壳组件
 * 3. 重编译 XML → AXML
 */
export async function recompileAndInjectManifest(
  axmlBytes: Uint8Array,
  packageName: string,
  originalApplication: string,
  shellApplication: string,
  shellContentProvider: string,
  shellComponentFactory: string,
  enableTripleEntry: boolean,
): Promise<{ axmlBytes: Uint8Array | undefined; findings: Finding[] }> {
  const findings: Finding[] = []

  // 从 AXML 提取 XML 文本（复用 axml-nsc 的能力）
  const { parseAxml } = await import("./axml-writer.ts")
  const { parseAxmlTree, reconstructXml } = await import("./axml-nsc.ts")

  let xmlText: string
  try {
    const model = parseAxml(axmlBytes)
    const tree = parseAxmlTree(model)
    xmlText = reconstructXml(tree)
  } catch (error) {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "AXML_PARSE_FAILED",
      title: "Manifest AXML 解析失败",
      detail: `解析 AXML 失败: ${error instanceof Error ? error.message : String(error)}`,
      recommendation: "确认 APK 中的 AndroidManifest.xml 是有效的二进制 AXML。",
      evidence: String(error).slice(0, 200),
    })
    return { axmlBytes: undefined, findings }
  }

  // 注入壳组件（复用 manifest-inject 的逻辑）
  const { injectShellComponents, buildManifestInjectFindings } = await import("./manifest-inject.ts")
  const manifestConfig = {
    packageName,
    originalApplication,
    shellApplication,
    shellContentProvider,
    shellComponentFactory,
    shellSoName: "libdroidseal.so",
    enableContentProvider: enableTripleEntry,
    enableComponentFactory: enableTripleEntry,
    targetSdkVersion: 34,
  }
  const { xml: modifiedXml, injected } = injectShellComponents(xmlText, manifestConfig)
  findings.push(...buildManifestInjectFindings(manifestConfig, injected))

  // 重编译 XML → AXML
  const { axmlBytes: newAxml, findings: recompileFindings } = await recompileManifestXml(
    modifiedXml,
    packageName,
    21,
    34,
  )
  findings.push(...recompileFindings)

  return { axmlBytes: newAxml ?? axmlBytes, findings }
}
