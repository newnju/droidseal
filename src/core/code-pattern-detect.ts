// 代码模式检测:Split-Key混淆/Timing-safe比对/ARouter兼容/后量子密码（#87 #88 #89 #90）。
// 纯 TypeScript 源码正则匹配，失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface CodePattern {
  key: string
  title: string
  category: "split-key" | "timing-safe" | "arouter" | "post-quantum" | "dex2c-stub" | "native-lib-dep"
  regex: RegExp
  severity: Finding["severity"]
  note: string
}

const CODE_PATTERNS: readonly CodePattern[] = [
  // ── Split-Key 混淆(#87) ──
  { key: "SPLIT_KEY_XOR", title: "密钥拆分异或(Split-Key 混淆)", category: "split-key", regex: /(?:key\s*\^\s*part|partA\s*\^\s*partB|splitKey|xorKey|keyPart)[\s\S]{0,100}(?:inline|@JvmStatic)/i, severity: "medium", note: "密钥拆分为两部分异或，编译时内联——静态分析无法直接提取完整密钥。CrabShell 特征。" },
  { key: "SPLIT_KEY_ARRAY", title: "密钥数组拆分", category: "split-key", regex: /(?:byte\s*\[\s*\]\s*(?:key|part|fragment)\s*=\s*new\s*byte\s*\[\s*\])[\s\S]{0,200}(?:\^|xor|XOR)[\s\S]{0,100}(?:key|part|fragment)/i, severity: "medium", note: "密钥存储为多个字节数组，运行时异或组合。" },
  { key: "SPLIT_KEY_CONSTANT_POOL", title: "常量池拆分密钥", category: "split-key", regex: /(?:0x[0-9a-fA-F]{2}\s*\^\s*0x[0-9a-fA-F]{2})[\s\S]{0,100}(?:key|secret|encrypt)/i, severity: "medium", note: "密钥拆分为硬编码常量异或组合。" },

  // ── Timing-safe 比对(#88) ──
  { key: "TIMING_SAFE_EQUALS", title: "常数时间比对(MessageDigest.isEqual)", category: "timing-safe", regex: /MessageDigest\.isEqual\s*\(/i, severity: "info", note: "使用 MessageDigest.isEqual 做常数时间比对——防时序攻击。正面安全实践。" },
  { key: "TIMING_SAFE_CONSTANT_TIME", title: "自实现常数时间比对", category: "timing-safe", regex: /(?:constantTimeEq|timingSafe|timing_attack|const_time)[\s\S]{0,100}(?:compare|equals|verify)/i, severity: "info", note: "自实现的常数时间比对函数。正面安全实践。" },
  { key: "TIMING_UNSAFE_EQUALS", title: "非安全比对(== 或 equals——时序攻击风险)", category: "timing-safe", regex: /(?:signature|hash|digest|token)\s*(?:==|\.equals\s*\()[\s\S]{0,60}(?:expected|valid|correct)/i, severity: "medium", note: "签名/哈希比对使用 == 或 equals——存在时序攻击风险。应使用 MessageDigest.isEqual。" },

  // ── ARouter 兼容(#89) ──
  { key: "AROUTER_USAGE", title: "ARouter 路由框架使用", category: "arouter", regex: /(?:com\/alibaba\/android\/arouter|ARouter|@Route|ARouter\.getInstance)/i, severity: "info", note: "使用 ARouter 路由框架——加固前需预注册路由表。mocika-shield 自动处理此兼容性。" },
  { key: "AROUTER_ROUTE_TABLE", title: "ARouter 路由表(apt 生成)", category: "arouter", regex: /(?:ARouter\$\$Group|ARouter\$\$Root|ARouter\$\$Provider)/i, severity: "info", note: "ARouter APT 生成的路由表——加固时需保留这些类。" },
  { key: "DEEP_LINK_CUSTOM_SCHEME", title: "自定义 Deep Link scheme", category: "arouter", regex: /(?:android:scheme\s*=\s*["'](?!https?["'])[\w.+-]+["'])/i, severity: "low", note: "自定义 scheme Deep Link——加固时需确保 Intent Filter 不被破坏。" },

  // ── 后量子密码(#90) ──
  { key: "POST_QUANTUM_KYBER", title: "CRYSTALS-Kyber / ML-KEM 后量子密钥封装", category: "post-quantum", regex: /(?:Kyber|ML-KEM|crystals.kyber|kyber\d{3})/i, severity: "info", note: "使用 CRYSTALS-Kyber(ML-KEM)后量子密钥封装算法。前沿技术。" },
  { key: "POST_QUANTUM_DILITHIUM", title: "CRYSTALS-Dilithium / ML-DSA 后量子签名", category: "post-quantum", regex: /(?:Dilithium|ML-DSA|crystals.dilithium)/i, severity: "info", note: "使用 CRYSTALS-Dilithium(ML-DSA)后量子签名算法。" },
  { key: "POST_QUANTUM_SPHINCS", title: "SPHINCS+ 后量子签名", category: "post-quantum", regex: /(?:SPHINCS|sphincs.plus|SPHINCS_SHA)/i, severity: "info", note: "使用 SPHINCS+ 后量子签名算法。" },
  { key: "POST_QUANTUM_FALCON", title: "Falcon 后量子签名", category: "post-quantum", regex: /(?:Falcon|falcon\d{3})/i, severity: "info", note: "使用 Falcon 后量子签名算法。" },
  { key: "POST_QUANTUM_MERKLE", title: "Merkle 树完整性验证", category: "post-quantum", regex: /(?:merkle[_-]?tree|merkle[_-]?verify|merkle[_-]?root|merkle[_-]?proof)/i, severity: "info", note: "使用 Merkle 树进行完整性验证——AnchorPQ 特征。" },

  // ── Dex2C JNI stub 特征(#85 补充) ──
  { key: "DEX2C_NATIVE_METHOD", title: "大量 native 方法声明(Dex2C 特征)", category: "dex2c-stub", regex: /(?:private|public|protected|static)\s+(?:native)\s+\w+\s*\(/i, severity: "medium", note: "大量 native 方法声明——Dex2C 将 Java/Kotlin 方法转为 native 后的 stub。" },
  { key: "DEX2C_JNI_LOAD", title: "JNI_OnLoad 动态注册", category: "dex2c-stub", regex: /(?:JNI_OnLoad|RegisterNatives|env->RegisterNatives)/i, severity: "medium", note: "JNI_OnLoad 中动态注册 native 方法——Dex2C 和商业加固常用。" },
  { key: "DEX2C_INMEMORY_LOAD", title: "InMemoryDexClassLoader 不落盘加载", category: "dex2c-stub", regex: /(?:InMemoryDexClassLoader|InMemoryDex|OpenMemory)/i, severity: "medium", note: "内存中加载 DEX 不落盘——Frezrik/Jiagu 特征。" },

  // ── Native 库依赖(#80) ──
  { key: "NATIVE_LIB_CRYPTO", title: "Native 库依赖加密库(libcrypto/libssl)", category: "native-lib-dep", regex: /(?:libcrypto|libssl|libmbedtls|libsodium|libtweetnacl)/i, severity: "info", note: "Native 层使用加密库——确认加密实现是否安全。" },
  { key: "NATIVE_LIB_SQLITE", title: "Native 库依赖 SQLite", category: "native-lib-dep", regex: /(?:libsqlite|sqlite3\.h)/i, severity: "info", note: "Native 层使用 SQLite——确认是否使用 SQLCipher 加密。" },
  { key: "NATIVE_LIB_SSL", title: "Native 库依赖 SSL/TLS", category: "native-lib-dep", regex: /(?:libcurl|libgnutls|libwolfssl|libboringssl)/i, severity: "info", note: "Native 层使用 SSL/TLS 库——确认证书校验配置。" },
  { key: "NATIVE_LIB_CUSTOM", title: "自定义 Native 库", category: "native-lib-dep", regex: /System\.loadLibrary\s*\(\s*["'](?!c\+\+_|c_|javacrash|native_crash|crashlytics)/i, severity: "info", note: "加载自定义 Native 库——需审计 SO 文件安全性。" },
]

export interface CodePatternMatch {
  line: number
  key: string
  title: string
  category: CodePattern["category"]
  snippet: string
  severity: Finding["severity"]
  note: string
}

export function scanCodePatterns(source: string): CodePatternMatch[] {
  const matches: CodePatternMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue
    for (const pattern of CODE_PATTERNS) {
      const context = lines.slice(Math.max(0, i - 1), i + 3).join("\n")
      if (pattern.regex.test(context) || pattern.regex.test(line)) {
        matches.push({ line: i + 1, key: pattern.key, title: pattern.title, category: pattern.category, snippet: line.trim().slice(0, 120), severity: pattern.severity, note: pattern.note })
        break
      }
    }
  }
  return matches
}

export async function scanProjectCodePatterns(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const allMatches: CodePatternMatch[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanCodePatterns(source)
    for (const match of matches) {
      const dedupeKey = `${match.key}:${file}`
      if (seen.has(dedupeKey)) continue
      seen.add(dedupeKey)
      allMatches.push(match)
    }
  }

  const findings: Finding[] = []
  const categoryLabels: Record<string, string> = {
    "split-key": "Split-Key 密钥混淆", "timing-safe": "Timing-safe 比对",
    arouter: "ARouter 路由", "post-quantum": "后量子密码",
    "dex2c-stub": "Dex2C JNI stub", "native-lib-dep": "Native 库依赖",
  }

  // 按类别聚合
  const byCategory = new Map<string, CodePatternMatch[]>()
  for (const match of allMatches) {
    const list = byCategory.get(match.category) ?? []
    list.push(match)
    byCategory.set(match.category, list)
  }

  for (const [cat, matches] of byCategory) {
    findings.push({
      severity: matches.some((m) => m.severity !== "info") ? "medium" : "info",
      confidence: "medium",
      code: "CODE_PATTERN_DETECTED",
      title: `${categoryLabels[cat] ?? cat}: ${matches.length} 项检测`,
      detail: matches.slice(0, 5).map((m) => `${m.title}(${m.note})`).join("; "),
      recommendation: cat === "timing-safe" && matches.some((m) => m.key === "TIMING_UNSAFE_EQUALS")
        ? "签名/哈希比对应使用 MessageDigest.isEqual（常数时间）防时序攻击。"
        : cat === "post-quantum"
          ? "后量子密码是前沿技术——确认实现是否成熟。"
          : "确认相关配置与实现是否正确。",
      evidence: matches.slice(0, 5).map((m) => m.key).join(", "),
    })
  }

  return findings
}
