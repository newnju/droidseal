// ProGuard/R8 规则分析 + Gradle 插件检测 + 包名随机化检测（#74 #75 #84）。
// 分析 ProGuard/R8 混淆规则文件，检测混淆配置强度；
// 检测 Gradle 构建脚本中的安全相关插件；
// 检测包名随机化特征。
// 纯 TypeScript，失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// ── ProGuard/R8 规则分析(#75) ──────────────────────────────────────────

export interface ProguardAnalysis {
  hasProguard: boolean
  hasR8: boolean
  obfuscationLevel: "none" | "basic" | "moderate" | "aggressive"
  keepRules: number
  dontobfuscateRules: number
  optimizeRules: number
  findings: Finding[]
}

export async function analyzeProguardRules(projectRoot: string): Promise<ProguardAnalysis> {
  const result: ProguardAnalysis = {
    hasProguard: false, hasR8: false, obfuscationLevel: "none",
    keepRules: 0, dontobfuscateRules: 0, optimizeRules: 0, findings: [],
  }

  // 查找 proguard-rules.pro / proguard.cfg / r8.rules
  const ruleFiles: string[] = []
  const candidates = ["proguard-rules.pro", "proguard.cfg", "r8.rules", "proguard-project.txt", "app/proguard-rules.pro"]
  for (const candidate of candidates) {
    try {
      await readFile(path.join(projectRoot, candidate), "utf8")
      ruleFiles.push(candidate)
    } catch { /* file not found */ }
  }

  if (ruleFiles.length === 0) return result

  for (const file of ruleFiles) {
    const content = await readFile(path.join(projectRoot, file), "utf8").catch(() => "")
    if (!content) continue

    // 统计规则类型
    const lines = content.split(/\r?\n/)
    for (const line of lines) {
      const trimmed = line.trim()
      if (trimmed.startsWith("#") || !trimmed) continue
      if (/^-keep\b/.test(trimmed)) result.keepRules += 1
      if (/^-dontobfuscate/.test(trimmed)) result.dontobfuscateRules += 1
      if (/^-optimiz/.test(trimmed)) result.optimizeRules += 1
      if (/proguard/i.test(file)) result.hasProguard = true
      if (/r8/i.test(file)) result.hasR8 = true
    }

    // 评估混淆级别
    if (result.dontobfuscateRules > 0) {
      result.obfuscationLevel = "none"
    } else if (result.keepRules > 0 && result.keepRules < 20) {
      result.obfuscationLevel = "aggressive" // 少量 keep 规则 = 大部分被混淆
    } else if (result.keepRules >= 20) {
      result.obfuscationLevel = "moderate"
    }

    result.findings.push({
      severity: "info",
      confidence: "high",
      code: "PROGUARD_CONFIG",
      title: `ProGuard/R8 配置: ${file}(${result.keepRules} 条 keep 规则,混淆级别 ${result.obfuscationLevel})`,
      detail: `混淆级别: ${result.obfuscationLevel}; keep 规则: ${result.keepRules}; dontobfuscate: ${result.dontobfuscateRules}; optimize: ${result.optimizeRules}。`,
      recommendation: result.obfuscationLevel === "none" ? "建议启用混淆以增加逆向难度。" : "确认 keep 规则是否过于宽松——暴露过多内部类/方法。",
      evidence: `${file}: keep=${result.keepRules} dontobfuscate=${result.dontobfuscateRules}`,
    })
  }

  return result
}

// ── Gradle 插件检测(#74) ──────────────────────────────────────────────

export interface GradlePlugin {
  name: string
  category: "security" | "obfuscation" | "build" | "signing" | "other"
  description: string
}

const SECURITY_GRADLE_PLUGINS: ReadonlyArray<{ id: string; name: string; category: GradlePlugin["category"]; description: string }> = [
  { id: "com.android.application", name: "Android Application Plugin", category: "build", description: "标准 Android 应用构建插件" },
  { id: "com.android.library", name: "Android Library Plugin", category: "build", description: "标准 Android 库构建插件" },
  { id: "proguard", name: "ProGuard", category: "obfuscation", description: "代码混淆/优化/压缩" },
  { id: "com.guardsquare.proguard", name: "Guardsquare ProGuard", category: "obfuscation", description: "商业 ProGuard 版本" },
  { id: "com.guardsquare.dexguard", name: "DexGuard", category: "obfuscation", description: "商业加固方案(多层保护)" },
  { id: "io.gitlab.nicheguard", name: "NicheGuard", category: "obfuscation", description: "自定义混淆方案" },
  { id: "com.niclas.stealth", name: "Stealth Plugin", category: "obfuscation", description: "字符串/代码混淆" },
  { id: "io.github.iamjosephmj.hydra", name: "Hydra RASP", category: "security", description: "运行时自保护(RASP) Gradle 插件" },
  { id: "com.abc.termuxcompiler", name: "TermuxCompiler", category: "security", description: "设备端 DEX→C 编译" },
  { id: "com.benjaminasher.StringFog", name: "StringFog", category: "obfuscation", description: "字符串加密 Gradle 插件" },
  { id: "com.megatronking.stringfog", name: "MegatronKing StringFog", category: "obfuscation", description: "字符串加密(原版)" },
  { id: "com.github.niclas-niclas", name: "StringFogPro", category: "obfuscation", description: "字符串加密 Pro 版(XOR/AES/自定义)" },
  { id: "com.kevinrocks.appcodeobfuscation", name: "AppCodeObfuscation", category: "obfuscation", description: "ASM 编译期注入垃圾代码" },
  { id: "com.klaxit.hiddensecrets", name: "Hidden Secrets Plugin", category: "security", description: "密钥隐藏到 NDK so" },
  { id: "com.commencis.secretsvault", name: "Secrets Vault Plugin", category: "security", description: "密钥隐藏 + 签名绑定" },
  { id: "com.namanoncode.anchorpq", name: "AnchorPQ", category: "security", description: "后量子 Merkle 树完整性验证" },
]

export async function detectGradlePlugins(projectRoot: string): Promise<{ plugins: GradlePlugin[]; findings: Finding[] }> {
  const plugins: GradlePlugin[] = []
  const findings: Finding[] = []

  // 读取 build.gradle / build.gradle.kts
  const gradleFiles = ["build.gradle", "build.gradle.kts", "app/build.gradle", "app/build.gradle.kts"]
  for (const file of gradleFiles) {
    const content = await readFile(path.join(projectRoot, file), "utf8").catch(() => "")
    if (!content) continue

    for (const plugin of SECURITY_GRADLE_PLUGINS) {
      if (content.includes(`id("${plugin.id}")`) || content.includes(`id '${plugin.id}'`) || content.includes(`apply plugin: '${plugin.id}'`)) {
        plugins.push({ name: plugin.name, category: plugin.category, description: plugin.description })
      }
    }

    // 检测 R8/ProGuard 配置
    if (/minifyEnabled\s*=\s*true/i.test(content)) {
      findings.push({
        severity: "info", confidence: "high", code: "GRADLE_R8_ENABLED",
        title: "R8 代码缩减已启用", detail: "build.gradle 中 minifyEnabled=true——R8 将执行代码缩减/混淆/优化。",
        recommendation: "确认 shrinkResources 也已启用以移除未使用资源。", evidence: file,
      })
    }
    if (/minifyEnabled\s*=\s*false/i.test(content)) {
      findings.push({
        severity: "medium", confidence: "high", code: "GRADLE_R8_DISABLED",
        title: "R8 代码缩减未启用", detail: "build.gradle 中 minifyEnabled=false——未启用代码缩减/混淆。",
        recommendation: "release 构建应启用 minifyEnabled=true。", evidence: file,
      })
    }
  }

  // 安全相关插件汇总
  const securityPlugins = plugins.filter((p) => p.category === "security")
  const obfuscationPlugins = plugins.filter((p) => p.category === "obfuscation")
  if (securityPlugins.length > 0 || obfuscationPlugins.length > 0) {
    findings.push({
      severity: "info", confidence: "high", code: "GRADLE_SECURITY_PLUGINS",
      title: `检测到 ${securityPlugins.length + obfuscationPlugins.length} 个安全/混淆 Gradle 插件`,
      detail: [...securityPlugins, ...obfuscationPlugins].map((p) => `${p.name}: ${p.description}`).join("; "),
      recommendation: "确认插件配置是否正确——安全插件需适当配置才能生效。",
      evidence: [...securityPlugins, ...obfuscationPlugins].map((p) => p.name).join(", "),
    })
  }

  return { plugins, findings }
}

// ── 包名随机化检测(#84) ──────────────────────────────────────────────

export function detectPackageNameRandomization(
  dexStrings: string[],
  manifestPackageName: string | undefined,
): Finding[] {
  const findings: Finding[] = []

  // 检测壳类名中的随机模式（如 com.a.b.c.d）
  const randomPackagePatterns = dexStrings.filter((s) =>
    /^com\/[a-z]{1,2}\/[a-z]{1,2}\/[a-z]{1,2}$/.test(s) ||
    /^L[a-z]{1,2}\/[a-z]{1,2}\/[a-z]{1,2};$/.test(s)
  )
  if (randomPackagePatterns.length > 10) {
    findings.push({
      severity: "medium",
      confidence: "medium",
      code: "PACKER_RANDOM_PACKAGE",
      title: `检测到 ${randomPackagePatterns.length} 个随机化包名模式`,
      detail: `DEX 中存在大量极短包名模式(如 ${randomPackagePatterns.slice(0, 3).join(", ")})——可能是加固壳的随机包名特征。`,
      recommendation: "随机包名是加固壳的防特征识别技术——确认是否为合法加固。",
      evidence: randomPackagePatterns.slice(0, 5).join(", "),
    })
  }

  // 检测壳 SO 名随机化
  const randomSoPatterns = dexStrings.filter((s) =>
    /^lib\/[a-z]{2,4}\/lib[a-z]{2,6}\.so$/.test(s) ||
    /^lib\/arm64-v8a\/lib[a-z]{2,6}\.so$/.test(s)
  )
  if (randomSoPatterns.length > 0) {
    findings.push({
      severity: "low",
      confidence: "medium",
      code: "PACKER_RANDOM_SO_NAME",
      title: `检测到 ${randomSoPatterns.length} 个随机化 SO 名`,
      detail: `DEX 中存在短名 SO 文件(如 ${randomSoPatterns.slice(0, 3).join(", ")})——可能是加固壳的随机 SO 名特征。`,
      recommendation: "随机 SO 名是加固壳的防特征识别技术。",
      evidence: randomSoPatterns.slice(0, 5).join(", "),
    })
  }

  return findings
}
