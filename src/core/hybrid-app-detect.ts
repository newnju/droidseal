// DroidSeal Unity/Flutter 支持指南（#65）
// 特殊 APK 结构处理:Unity IL2CPP / Flutter libapp.so / Capacitor/Cordova
import type { Finding } from "./types.ts"

export interface HybridAppType {
  type: "unity-il2cpp" | "flutter" | "capacitor" | "cordova" | "react-native" | "xamarin" | "standard"
  indicators: string[]
  specialHandling: string[]
}

const HYBRID_PATTERNS: readonly HybridAppType[] = [
  {
    type: "unity-il2cpp",
    indicators: ["libil2cpp.so", "libunity.so", "libmain.so", "assets/bin/Data/"],
    specialHandling: [
      "libil2cpp.so 包含 IL2CPP 编译后的 C++ 代码——需 Amice LLVM 混淆保护",
      "assets/bin/Data/ 包含 Unity 资源——需资源加密",
      "libunity.so 是 Unity 引擎——SO 加密保护",
    ],
  },
  {
    type: "flutter",
    indicators: ["libapp.so", "libflutter.so", "assets/flutter_assets/"],
    specialHandling: [
      "libapp.so 包含 Dart AOT 编译代码——需 SO 加密保护",
      "assets/flutter_assets/ 包含 Flutter 资源——需资源加密",
      "libflutter.so 是 Flutter 引擎——SO 加密保护",
    ],
  },
  {
    type: "capacitor",
    indicators: ["capacitor.config", "assets/public/", "assets/www/"],
    specialHandling: [
      "assets/public/ 或 assets/www/ 包含 Web 资源——需 JS 压缩+source map 移除",
      "Capacitor Java 版本可能与 JDK 不兼容——需自动 patch",
    ],
  },
  {
    type: "cordova",
    indicators: ["cordova.js", "cordova_plugins.js", "assets/www/"],
    specialHandling: [
      "assets/www/ 包含 Cordova Web 资源——需 JS 压缩+source map 移除",
    ],
  },
  {
    type: "react-native",
    indicators: ["assets/index.android.bundle", "libreactnativejni.so", "libhermes.so"],
    specialHandling: [
      "assets/index.android.bundle 包含 React Native JS bundle——需 JS 压缩",
      "libhermes.so 是 Hermes JS 引擎——SO 加密保护",
    ],
  },
  {
    type: "xamarin",
    indicators: ["assemblies/", "libmonodroid.so", "libmonosgen-2.0.so"],
    specialHandling: [
      "assemblies/ 包含 .NET IL 程序集——需字符串加密",
      "libmonodroid.so 是 Mono 运行时——SO 加密保护",
    ],
  },
]

export function detectHybridAppType(entryNames: string[]): HybridAppType {
  for (const pattern of HYBRID_PATTERNS) {
    const matched = pattern.indicators.filter((ind) => entryNames.some((name) => name.includes(ind)))
    if (matched.length >= Math.ceil(pattern.indicators.length / 2)) {
      return pattern
    }
  }
  return { type: "standard", indicators: [], specialHandling: [] }
}

export function buildHybridAppFindings(appType: HybridAppType): Finding[] {
  if (appType.type === "standard") return []
  return [{
    severity: "info",
    confidence: "high",
    code: "HYBRID_APP_DETECTED",
    title: `检测到混合应用类型:${appType.type}`,
    detail: `特征:${appType.indicators.join(", ")}。特殊处理:${appType.specialHandling.join("; ")}`,
    recommendation: `${appType.type} 应用需要特殊加固策略——参考 specialHandling 建议。`,
    evidence: appType.type,
  }]
}
