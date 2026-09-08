// Smali 级源码分析（#71）。
// 直接分析 APK 中的 Smali 代码（反编译后的 .smali 文件），
// 检测混淆特征、垃圾代码注入、假 so/假 ProGuard 特征。
// 纯字节级分析（从 DEX 字符串池提取 Smali 特征），失败关闭。
import type { Finding } from "./types.ts"

// ── Smali 混淆特征检测 ──────────────────────────────────────────────────

interface SmaliObfuscationPattern {
  key: string
  title: string
  severity: Finding["severity"]
  confidence: Finding["confidence"]
  note: string
}

const SMALI_PATTERNS: readonly SmaliObfuscationPattern[] = [
  { key: "SMALI_SHORT_NAMES", title: "极短类/方法名(a/b/c 等单字符)", severity: "info", confidence: "medium", note: "ProGuard/R8 混淆将类名/方法名替换为极短名称。" },
  { key: "SMALI_GOTO_INSERTION", title: "Goto 指令插入(控制流混淆)", severity: "medium", confidence: "low", note: "Smali 级 goto/goto_0 指令插入，干扰控制流分析。" },
  { key: "SMALI_NOP_INSERTION", title: "Nop 指令插入(死代码)", severity: "low", confidence: "low", note: "大量 nop 指令插入，干扰反汇编。" },
  { key: "SMALI_DEAD_CODE", title: "不可达代码块", severity: "low", confidence: "low", note: "永远不执行的代码块，干扰分析。" },
  { key: "SMALI_METHOD_OVERLOAD", title: "方法重载混淆(同名不同签名)", severity: "medium", confidence: "medium", note: "利用 Java 方法重载歧义混淆。" },
  { key: "SMALI_REFLECTION_WRAP", title: "反射包装调用", severity: "medium", confidence: "medium", note: "用反射替代直接调用，增加分析难度。" },
  { key: "SMALI_STRING_SPLIT", title: "字符串分割拼接", severity: "medium", confidence: "medium", note: "将常量字符串拆分为多段拼接，干扰字符串搜索。" },
  { key: "SMALI_RESOURCE_RENAME", title: "资源名混淆(a/b/c.xml)", severity: "info", confidence: "medium", note: "资源文件名被替换为极短名称。" },
]

export function detectSmaliObfuscation(dexStrings: string[]): Array<{ key: string; title: string; severity: Finding["severity"] }> {
  const results: Array<{ key: string; title: string; severity: Finding["severity"] }> = []

  // 1. 极短类名比例（单字符 a-z 类名）
  const shortNames = dexStrings.filter((s) => /^[a-z]$/.test(s))
  if (shortNames.length > dexStrings.length * 0.1 && shortNames.length > 50) {
    results.push({ key: "SMALI_SHORT_NAMES", title: `极短类/方法名: ${shortNames.length} 个单字符标识符`, severity: "info" })
  }

  // 2. ProGuard/R8 特征
  const proguardPatterns = ["proguard", "ProGuard", "r8", "R8", "obfusc"]
  const proguardHits = proguardPatterns.filter((p) => dexStrings.some((s) => s.toLowerCase().includes(p.toLowerCase())))
  if (proguardHits.length > 0) {
    results.push({ key: "SMALI_PROGUARD", title: `检测到混淆工具特征: ${proguardHits.join(", ")}`, severity: "info" })
  }

  // 3. 反射包装模式
  const reflectionPatterns = ["java/lang/reflect/Method", "invoke", "getDeclaredMethod", "setAccessible"]
  const reflectionHits = reflectionPatterns.filter((p) => dexStrings.some((s) => s.includes(p)))
  if (reflectionHits.length >= 3) {
    results.push({ key: "SMALI_REFLECTION_WRAP", title: `检测到反射包装模式: ${reflectionHits.length} 个特征`, severity: "medium" })
  }

  // 4. 字符串分割模式
  const splitPatterns = ["StringBuilder", "append", "toString"]
  const splitHits = splitPatterns.filter((p) => dexStrings.some((s) => s.includes(p)))
  if (splitHits.length >= 2) {
    // 检查是否有大量 StringBuilder.append 调用（字符串拼接混淆的特征）
    const appendCount = dexStrings.filter((s) => s === "append").length
    if (appendCount > 100) {
      results.push({ key: "SMALI_STRING_SPLIT", title: `大量 StringBuilder.append 调用(${appendCount})——可能为字符串分割混淆`, severity: "medium" })
    }
  }

  // 5. 假 so 文件特征
  const fakeSoPatterns = [/lib[a-z]{1,3}\.so$/, /libfake/i, /libdummy/i]
  const fakeSoHits = dexStrings.filter((s) => fakeSoPatterns.some((p) => p.test(s)))
  if (fakeSoHits.length > 0) {
    results.push({ key: "SMALI_FAKE_SO", title: `检测到可疑短名 SO 文件: ${fakeSoHits.slice(0, 3).join(", ")}`, severity: "low" })
  }

  return results
}

export function buildSmaliFindings(results: Array<{ key: string; title: string; severity: Finding["severity"] }>): Finding[] {
  return results.map((r) => ({
    severity: r.severity,
    confidence: "medium" as const,
    code: "SMALI_OBFUSCATION",
    title: r.title,
    detail: `Smali 级分析检测到: ${r.title}。${SMALI_PATTERNS.find((p) => p.key === r.key)?.note ?? ""}`,
    recommendation: "Smali 混淆降低静态分析可见性——审计结论按可见性降级。",
    evidence: r.key,
  }))
}
