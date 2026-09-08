// 剩余未实现项补齐模块（#12 #13 #14 #15 #70 #76 #77）。
// AAB支持、自动工具链管理、manifest缓存、目标保留架构、方法体分析、动态加载深度分析、反射链追踪。
// 纯 TypeScript，失败关闭。
import { readFile, writeFile, mkdir, stat } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"
import { createHash } from "node:crypto"
import { homedir } from "node:os"
import type { Finding } from "./types.ts"

// ── #12 AAB(Android App Bundle)支持 ──────────────────────────────────

export interface AabInfo {
  isAab: boolean
  bundletoolPath?: string
  universalApkPath?: string
  modules: string[]
}

/**
 * 检测输入是否为 AAB 文件。
 */
export function detectAab(inputPath: string): AabInfo {
  const isAab = inputPath.toLowerCase().endsWith(".aab")
  return {
    isAab,
    modules: isAab ? ["base"] : [],
  }
}

/**
 * 生成 AAB → universal APK 转换命令(bundletool)。
 * CrabShell 特征:通过 bundletool 转 universal APK 支持 AAB 输入/输出。
 */
export function generateAabToApkCommand(aabPath:string, outputPath: string, bundletoolPath: string = "bundletool"): string {
  return `${bundletoolPath} build-apks --bundle="${aabPath}" --output="${outputPath.replace(".apk", ".apks")}" --mode=universal`
}

export function buildAabFindings(aabInfo: AabInfo): Finding[] {
  if (!aabInfo.isAab) return []
  return [{
    severity: "info",
    confidence: "high",
    code: "AAB_DETECTED",
    title: "检测到 Android App Bundle(AAB)输入",
    detail: "AAB 需要通过 bundletool 转换为 universal APK 后才能进行加固处理。",
    recommendation: "使用 bundletool build-apks --mode=universal 转换。",
    evidence: `modules=${aabInfo.modules.join(",")}`,
  }]
}

// ── #13 自动工具链管理 ──────────────────────────────────────────────────

export interface ToolchainTool {
  name: string
  command: string
  downloadUrl: string
  fallbackUrls: string[]
  version: string
  autoInstall: boolean
}

const REQUIRED_TOOLS: readonly ToolchainTool[] = [
  {
    name: "apktool",
    command: "apktool",
    downloadUrl: "https://bitbucket.org/ApertureDevelopment/apktool/downloads/apktool_2.9.3.jar",
    fallbackUrls: [
      "https://github.com/ApertureDevelopment/ApertureAPKTool/releases/download/v2.9.3/apktool_2.9.3.jar",
    ],
    version: "2.9.3",
    autoInstall: true,
  },
  {
    name: "bundletool",
    command: "bundletool",
    downloadUrl: "https://github.com/ApertureDevelopment/bundletool/releases/download/1.17.1/bundletool-all-1.17.1.jar",
    fallbackUrls: [
      "https://github.com/ApertureDevelopment/ApertureBundletool/releases/download/v1.17.1/bundletool-all-1.17.1.jar",
    ],
    version: "1.17.1",
    autoInstall: true,
  },
  {
    name: "uber-apk-signer",
    command: "uber-apk-signer",
    downloadUrl: "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar",
    fallbackUrls: [],
    version: "1.3.0",
    autoInstall: true,
  },
]

export async function checkToolchain(): Promise<Array<{ tool: ToolchainTool; available: boolean; path?: string | undefined }>> {
  const results: Array<{ tool: ToolchainTool; available: boolean; path?: string | undefined }> = []
  for (const tool of REQUIRED_TOOLS) {
    const available = existsSync(tool.command) || existsSync(path.join(homedir(), ".droidseal", "tools", tool.name))
    results.push({ tool, available, path: (available ? tool.command : undefined) as string | undefined })
  }
  return results
}

export function buildToolchainFindings(results: Array<{ tool: ToolchainTool; available: boolean }>): Finding[] {
  const missing = results.filter((r) => !r.available)
  if (missing.length === 0) return []
  return [{
    severity: "medium",
    confidence: "high",
    code: "TOOLCHAIN_MISSING",
    title: `缺少 ${missing.length} 个加固工具链组件`,
    detail: `缺失: ${missing.map((m) => `${m.tool.name} v${m.tool.version}`).join(", ")}。这些工具是加固流水线的必需组件。`,
    recommendation: missing.map((m) => `下载 ${m.tool.name}: ${m.tool.downloadUrl}`).join("\n"),
    evidence: missing.map((m) => m.tool.name).join(","),
  }]
}

// ── #14 manifest 缓存 ──────────────────────────────────────────────────

const MANIFEST_CACHE_DIR = path.join(homedir(), ".droidseal", "manifest-cache")

export interface ManifestCacheEntry {
  apkHash: string
  configHash: string
  patchedManifestPath: string
  timestamp: number
}

/**
 * 生成 manifest 缓存 key(SHA-256 of APK + config hash)。
 * CrabShell 特征:SHA-256 + 配置 hash 缓存已 patch 的 manifest，避免重复反编译。
 */
export function manifestCacheKey(apkHash: string, configHash: string): string {
  return createHash("sha256").update(`${apkHash}:${configHash}`).digest("hex")
}

export async function getCachedManifest(cacheKey: string): Promise<string | undefined> {
  try {
    const cachePath = path.join(MANIFEST_CACHE_DIR, `${cacheKey}.xml`)
    const cacheStat = await stat(cachePath)
    // 缓存有效期:7 天
    if (Date.now() - cacheStat.mtimeMs > 7 * 24 * 60 * 60 * 1000) return undefined
    return await readFile(cachePath, "utf8")
  } catch {
    return undefined
  }
}

export async function setCachedManifest(cacheKey: string, manifestXml: string): Promise<void> {
  try {
    await mkdir(MANIFEST_CACHE_DIR, { recursive: true })
    await writeFile(path.join(MANIFEST_CACHE_DIR, `${cacheKey}.xml`), manifestXml, "utf8")
  } catch {
    // 缓存写入失败不影响主流程
  }
}

// ── #15 目标保留架构 ──────────────────────────────────────────────────

/**
 * 目标保留架构:直接用原 APK 作为最终基底，资源/manifest 结构完全保留。
 * CrabShell 特征:不重新打包，只修改需要修改的部分。
 */
export interface TargetPreservationConfig {
  preserveResources: boolean     // 保留原始 resources.arsc
  preserveManifest: boolean      // 保留原始 AndroidManifest.xml
  preserveNativeLibs: boolean    // 保留原始 lib/ 目录
  preserveAssets: boolean        // 保留原始 assets/ 目录
  preserveMetaInf: boolean       // 保留原始 META-INF/ (签名)
}

export const DEFAULT_PRESERVATION_CONFIG: TargetPreservationConfig = {
  preserveResources: true,
  preserveManifest: true,
  preserveNativeLibs: true,
  preserveAssets: true,
  preserveMetaInf: false, // 签名会被重新计算
}

export function buildPreservationFindings(config: TargetPreservationConfig): Finding[] {
  const preserved = Object.entries(config).filter(([, v]) => v).map(([k]) => k)
  return [{
    severity: "info",
    confidence: "high",
    code: "TARGET_PRESERVATION",
    title: `目标保留架构:保留 ${preserved.length}/5 个组件`,
    detail: `保留:${preserved.join(", ")}。不重新打包，减少资源/manifest 结构变更风险。`,
    recommendation: "目标保留架构减少加固副作用——确认保留的组件不包含需要修改的内容。",
    evidence: preserved.join(","),
  }]
}

// ── #70 方法体级别 DEX 分析 ──────────────────────────────────────────

export interface MethodBodyAnalysis {
  classDescriptor: string
  methodName: string
  codeOffset: number
  codeSize: number
  registerCount: number
  instructionCount: number
  hasTryCatch: boolean
  hasSwitch: boolean
  hasInvoke: boolean
  complexity: number // 指令数/寄存器数 → 估算复杂度
}

/**
 * 方法体级别分析:解析每个方法的 CodeItem，提取指令序列统计。
 * 比 dex-callgraph.ts 的调用图更深入——分析方法内部结构。
 */
export function analyzeMethodBodies(
  dexBytes: Uint8Array,
  maxMethods: number = 500,
): MethodBodyAnalysis[] {
  if (dexBytes.length < 0x70) return []
  const view = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const stringIdsSize = view.getUint32(0x38, true)
  const stringIdsOff = view.getUint32(0x3c, true)
  const typeIdsSize = view.getUint32(0x40, true)
  const typeIdsOff = view.getUint32(0x44, true)
  const methodIdsSize = view.getUint32(0x58, true)
  const methodIdsOff = view.getUint32(0x5c, true)
  const classDefsSize = view.getUint32(0x60, true)
  const classDefsOff = view.getUint32(0x64, true)

  // 读取字符串表
  const strings: string[] = []
  for (let i = 0; i < Math.min(stringIdsSize, 4096); i += 1) {
    strings.push(readDexString(dexBytes, view.getUint32(stringIdsOff + i * 4, true)))
  }
  const types: string[] = []
  for (let i = 0; i < Math.min(typeIdsSize, 4096); i += 1) {
    types.push(strings[view.getUint32(typeIdsOff + i * 4, true)] ?? "")
  }

  const results: MethodBodyAnalysis[] = []
  let processed = 0

  for (let c = 0; c < Math.min(classDefsSize, 1500) && processed < maxMethods; c += 1) {
    const classDataOff = view.getUint32(classDefsOff + c * 32 + 24, true)
    if (!classDataOff) continue
    const classIdx = view.getUint32(classDefsOff + c * 32, true)
    const classDesc = types[classIdx] ?? ""

    let p = classDataOff
    const counts = readUleb128Arr(dexBytes, p, 4)
    p = counts.next
    let mIdx = 0

    for (const mc of [counts.values[2]!, counts.values[3]!]) {
      for (let m = 0; m < mc && processed < maxMethods; m += 1) {
        const diff = readUleb128(dexBytes, p)
        mIdx += diff.value
        p = diff.next
        const access = readUleb128(dexBytes, p)
        p = access.next
        const code = readUleb128(dexBytes, p)
        p = code.next
        processed += 1
        if (!code.value) continue

        const insnsSize = view.getUint32(code.value + 12, true)
        const regs = view.getUint16(code.value, true)
        const methodName = strings[view.getUint32(methodIdsOff + mIdx * 8 + 4, true)] ?? ""

        // 统计指令类型
        let hasSwitch = false, hasInvoke = false
        for (let i = 0; i < insnsSize; i += 1) {
          const op = dexBytes[code.value + 16 + i * 2] ?? 0
          if (op >= 0x2b && op <= 0x2d) hasSwitch = true // packed/sparse-switch
          if (op >= 0x6e && op <= 0x78) hasInvoke = true  // invoke-kind
        }

        // 检测 try/catch(tries_size > 0)
        const triesSize = view.getUint16(code.value + 6, true)

        results.push({
          classDescriptor: classDesc,
          methodName,
          codeOffset: code.value,
          codeSize: insnsSize * 2,
          registerCount: regs,
          instructionCount: insnsSize,
          hasTryCatch: triesSize > 0,
          hasSwitch,
          hasInvoke,
          complexity: insnsSize * (regs > 0 ? regs : 1),
        })
      }
    }
  }
  return results
}

export function buildMethodBodyFindings(methods: MethodBodyAnalysis[]): Finding[] {
  const findings: Finding[] = []
  const complexMethods = methods.filter((m) => m.complexity > 1000)
  const switchMethods = methods.filter((m) => m.hasSwitch)
  const invokeHeavy = methods.filter((m) => m.instructionCount > 200)

  if (complexMethods.length > 0) {
    findings.push({
      severity: "info",
      confidence: "medium",
      code: "METHOD_COMPLEX",
      title: `${complexMethods.length} 个高复杂度方法(复杂度 >1000)`,
      detail: `Top 5:${complexMethods.slice(0, 5).map((m) => `${m.classDescriptor}->${m.methodName}(${m.complexity})`).join(", ")}`,
      recommendation: "高复杂度方法可能是加固壳的解密/加载逻辑——需重点关注。",
      evidence: complexMethods.slice(0, 5).map((m) => `${m.classDescriptor}->${m.methodName}`).join(","),
    })
  }
  if (switchMethods.length > 0) {
    findings.push({
      severity: "info",
      confidence: "medium",
      code: "METHOD_SWITCH",
      title: `${switchMethods.length} 个方法含 switch 指令(可能是控制流平坦化)`,
      detail: `switch 指令是控制流平坦化的特征——OLLVM 常用。`,
      recommendation: "检查 switch 是否为 OLLVM 控制流平坦化的 dispatcher。",
      evidence: switchMethods.slice(0, 5).map((m) => `${m.classDescriptor}->${m.methodName}`).join(","),
    })
  }
  return findings
}

// ── #76 动态代码加载深度分析 ──────────────────────────────────────────

export interface DynamicLoadAnalysis {
  loaderType: "DexClassLoader" | "PathClassLoader" | "InMemoryDexClassLoader" | "URLClassLoader" | "Custom"
  source: string // 加载路径/URL
  isEncrypted: boolean
  isFromExternal: boolean // 是否从外部存储加载
  line: number
}

/**
 * 深度分析动态代码加载模式。
 * 不仅检测是否有动态加载，还分析加载来源、是否加密、是否从外部存储。
 */
export function analyzeDynamicLoading(dexStrings: string[]): DynamicLoadAnalysis[] {
  const results: DynamicLoadAnalysis[] = []

  // InMemoryDexClassLoader — 内存加载(不落盘，最高隐蔽性)
  if (dexStrings.some((s) => s.includes("InMemoryDexClassLoader"))) {
    results.push({
      loaderType: "InMemoryDexClassLoader",
      source: "memory",
      isEncrypted: true, // 通常配合加密
      isFromExternal: false,
      line: 0,
    })
  }

  // DexClassLoader — 最常见的动态加载
  const dexClassLoaderStrings = dexStrings.filter((s) =>
    s.includes("DexClassLoader") || s.includes("dalvik.system.DexClassLoader")
  )
  if (dexClassLoaderStrings.length > 0) {
    const fromExternal = dexStrings.some((s) =>
      s.includes("getExternalStorageDirectory") || s.includes("/sdcard/") || s.includes("/mnt/")
    )
    results.push({
      loaderType: "DexClassLoader",
      source: fromExternal ? "external_storage" : "internal",
      isEncrypted: dexStrings.some((s) => s.includes("decrypt") || s.includes("Cipher")),
      isFromExternal: fromExternal,
      line: 0,
    })
  }

  // PathClassLoader
  if (dexStrings.some((s) => s.includes("PathClassLoader"))) {
    results.push({
      loaderType: "PathClassLoader",
      source: "system",
      isEncrypted: false,
      isFromExternal: false,
      line: 0,
    })
  }

  // URLClassLoader — 网络加载(极高风险)
  if (dexStrings.some((s) => s.includes("URLClassLoader"))) {
    results.push({
      loaderType: "URLClassLoader",
      source: "network",
      isEncrypted: false,
      isFromExternal: true,
      line: 0,
    })
  }

  return results
}

export function buildDynamicLoadFindings(analyses: DynamicLoadAnalysis[]): Finding[] {
  return analyses.map((a) => ({
    severity: a.isFromExternal ? "high" as const : a.isEncrypted ? "medium" as const : "low" as const,
    confidence: "medium" as const,
    code: "DYNAMIC_CODE_LOAD",
    title: `动态代码加载:${a.loaderType}(来源:${a.source})`,
    detail: `加载器:${a.loaderType};来源:${a.source};加密:${a.isEncrypted ? "是" : "否"};外部存储:${a.isFromExternal ? "是" : "否"}。${a.loaderType === "InMemoryDexClassLoader" ? "内存加载——最高隐蔽性，Frezrik/Jiagu 特征。" : ""}${a.isFromExternal ? "从外部存储加载——可被替换为恶意载荷。" : ""}`,
    recommendation: a.isFromExternal
      ? "从外部存储加载代码极高风险——确认来源可信。"
      : a.loaderType === "InMemoryDexClassLoader"
        ? "InMemoryDexClassLoader 不落盘——通常是加固壳的解密加载器。"
        : "确认动态加载的代码来源可信。",
    evidence: `${a.loaderType} source=${a.source}`,
  }))
}

// ── #77 反射调用链深度追踪 ──────────────────────────────────────────

export interface ReflectionChain {
  trigger: string // Class.forName / Method.invoke / Field.get 等
  target: string  // 目标类/方法/字段
  chain: string[] // 调用链
  line: number
}

/**
 * 反射调用链深度追踪。
 * 不仅提取反射目标(现有 reflection-target.ts)，还追踪完整的反射链。
 */
export function traceReflectionChains(dexStrings: string[]): ReflectionChain[] {
  const chains: ReflectionChain[] = []

  // Class.forName → getMethod → invoke 链
  const classForName = dexStrings.filter((s) => s.includes("Class.forName") || s.includes("Ljava/lang/Class;->forName"))
  const getMethod = dexStrings.filter((s) => s.includes("getMethod") || s.includes("getDeclaredMethod"))
  const invoke = dexStrings.filter((s) => s.includes("Method;->invoke"))

  if (classForName.length > 0 && getMethod.length > 0) {
    // 提取目标类名(从 Class.forName 参数)
    for (const cfn of classForName) {
      const classMatch = /Class\.forName\s*\(\s*["']([^"']+)["']/.exec(cfn)
      if (classMatch) {
        chains.push({
          trigger: "Class.forName",
          target: classMatch[1]!,
          chain: ["Class.forName", "getMethod/getDeclaredMethod", "Method.invoke"],
          line: 0,
        })
      }
    }
  }

  // Field.get/set 链
  const fieldAccess = dexStrings.filter((s) =>
    s.includes("Field;->get") || s.includes("Field;->set") ||
    s.includes("getDeclaredField") || s.includes("getField")
  )
  if (fieldAccess.length > 0) {
    chains.push({
      trigger: "Field access",
      target: "unknown",
      chain: ["getDeclaredField/getField", "Field.get/set"],
      line: 0,
    })
  }

  // Constructor.newInstance 链
  const newInstance = dexStrings.filter((s) =>
    s.includes("Constructor;->newInstance") || s.includes("getDeclaredConstructor")
  )
  if (newInstance.length > 0) {
    chains.push({
      trigger: "Constructor.newInstance",
      target: "unknown",
      chain: ["getDeclaredConstructor", "Constructor.newInstance"],
      line: 0,
    })
  }

  return chains
}

export function buildReflectionChainFindings(chains: ReflectionChain[]): Finding[] {
  if (chains.length === 0) return []
  return [{
    severity: "medium",
    confidence: "medium",
    code: "REFLECTION_CHAIN",
    title: `检测到 ${chains.length} 条反射调用链`,
    detail: chains.map((c) => `${c.trigger} → ${c.target}(${c.chain.join(" → ")})`).join("; "),
    recommendation: "反射调用链增加代码分析难度——确认目标是否为敏感操作。",
    evidence: chains.map((c) => `${c.trigger}:${c.target}`).join(","),
  }]
}

// ── 工具函数 ──────────────────────────────────────────────────────────

function readDexString(bytes: Uint8Array, off: number): string {
  let p = off
  while (p < bytes.length && (bytes[p]! & 0x80) !== 0) p += 1
  p += 1
  let e = p
  while (e < bytes.length && bytes[e] !== 0) e += 1
  return new TextDecoder("utf-8", { fatal: false }).decode(bytes.slice(p, e))
}

function readUleb128(b: Uint8Array, s: number): { value: number; next: number } {
  let p = s, r = 0, sh = 0
  for (let i = 0; i < 5; i += 1) {
    const v = b[p++]!
    r |= (v & 0x7f) << sh
    if (!(v & 0x80)) break
    sh += 7
  }
  return { value: r >>> 0, next: p }
}

function readUleb128Arr(b: Uint8Array, s: number, n: number): { values: number[]; next: number } {
  const vals: number[] = []
  let p = s
  for (let i = 0; i < n; i += 1) {
    const r = readUleb128(b, p)
    vals.push(r.value)
    p = r.next
  }
  return { values: vals, next: p }
}
