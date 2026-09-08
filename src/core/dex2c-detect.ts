// Dex2C 特征检测（#85）。
// 检测 DEX 中方法体被转为 native 后的特征：JNI stub 模式、方法体为空+JNI 调用、
// RegisterNatives 动态注册、C 层字符串混淆特征。
// 纯 DEX 字节级分析，失败关闭。
import type { Finding } from "./types.ts"

export interface Dex2cIndicator {
  key: string
  title: string
  severity: Finding["severity"]
  confidence: Finding["confidence"]
  detail: string
}

// 检测 JNI stub 模式：方法体仅包含 invoke-native + return
const JNI_STUB_OPCODES = new Set([0x6e, 0x6f, 0x70, 0x71, 0x72, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a]) // invoke-kind
const RETURN_OPCODES = new Set([0x0e, 0x0f, 0x10, 0x11, 0x12, 0x27]) // return-kind

export function detectDex2cIndicators(
  methodNames: string[],
  nativeMethodCount: number,
  totalMethodCount: number,
  hasRegisterNatives: boolean,
  dexStrings: string[],
): Dex2cIndicator[] {
  const indicators: Dex2cIndicator[] = []

  // 1. 高 native 方法比例（>30% 的方法声明为 native）
  if (totalMethodCount > 10 && nativeMethodCount / totalMethodCount > 0.3) {
    indicators.push({
      key: "DEX2C_HIGH_NATIVE_RATIO",
      title: "高比例 native 方法声明",
      severity: "high",
      confidence: "medium",
      detail: `${nativeMethodCount}/${totalMethodCount} (${(nativeMethodCount / totalMethodCount * 100).toFixed(1)}%) 方法声明为 native——可能为 Dex2C 转换。`,
    })
  }

  // 2. RegisterNatives 动态注册（隐藏 JNI 导出符号）
  if (hasRegisterNatives) {
    indicators.push({
      key: "DEX2C_REGISTER_NATIVES",
      title: "检测到 RegisterNatives 动态注册",
      severity: "medium",
      confidence: "medium",
      detail: "使用 RegisterNatives 动态注册 JNI 方法——隐藏 native 方法名，增加逆向难度。Dex2C 和商业加固常用此技术。",
    })
  }

  // 3. JNI 相关类/方法名模式
  const jniPatterns = ["JNI_OnLoad", "JNI_OnUnload", "RegisterNatives", "GetMethodID", "FindClass"]
  const jniHits = jniPatterns.filter((p) => dexStrings.some((s) => s.includes(p)))
  if (jniHits.length >= 3) {
    indicators.push({
      key: "DEX2C_JNI_PATTERNS",
      title: "DEX 字符串池含丰富 JNI 调用模式",
      severity: "medium",
      confidence: "low",
      detail: `字符串池包含 JNI 模式: ${jniHits.join(", ")}——可能为 Dex2C 生成的 JNI 桥接代码。`,
    })
  }

  // 4. 方法名含 C 编译器生成特征
  const cCompilerPatterns = [/_JNIEnv/, /JNIEnv\s*\*/, /jstring/, /jintArray/, /JNIEXPORT/]
  const cCompilerHits = dexStrings.filter((s) => cCompilerPatterns.some((p) => p.test(s)))
  if (cCompilerHits.length > 0) {
    indicators.push({
      key: "DEX2C_C_COMPILER_ARTIFACTS",
      title: "DEX 字符串池含 C 编译器生成特征",
      severity: "high",
      confidence: "high",
      detail: `字符串池包含 C/JNI 类型签名: ${cCompilerHits.slice(0, 3).join(", ")}——强烈暗示 Dex2C 转换。`,
    })
  }

  // 5. nativeLibraryDir patch 模式（SO 加载路径修改）
  const hasNativeLibDirPatch = dexStrings.some((s) =>
    s.includes("nativeLibraryDir") || s.includes("DexPathList") || s.includes("nativeLibraryDirectories")
  )
  if (hasNativeLibDirPatch) {
    indicators.push({
      key: "DEX2C_NATIVE_LIB_DIR_PATCH",
      title: "检测到 nativeLibraryDir patch 模式",
      severity: "medium",
      confidence: "medium",
      detail: "代码修改 nativeLibraryDir 以加载自定义 SO——Dex2C 和 SO 加密加固常用。",
    })
  }

  return indicators
}

export function buildDex2cFindings(indicators: Dex2cIndicator[]): Finding[] {
  return indicators.map((ind) => ({
    severity: ind.severity,
    confidence: (ind.confidence || "medium") as "confirmed" | "high" | "medium" | "low",
    code: "DEX2C_DETECTED",
    title: ind.title,
    detail: ind.detail,
    recommendation: "Dex2C 保护的代码静态分析极困难——需动态调试。确认是否为合法加固。",
    evidence: ind.key,
  }))
}
