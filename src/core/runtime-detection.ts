// 反调试/Root/模拟器/Hook 框架检测分析（Phase 2 扩充）。
// 检测应用中是否实现了运行时安全检测逻辑——评估检测完整性与可绕过性。
// 纯 TypeScript 源码正则匹配，失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface RuntimePattern {
  key: string
  title: string
  category: "anti-debug" | "root-detect" | "emulator-detect" | "hook-detect" | "integrity" | "tamper-detect"
  regex: RegExp
  severity: Finding["severity"]
  note: string
  bypassHint: string
}

const RUNTIME_PATTERNS: readonly RuntimePattern[] = [
  // ── 反调试检测 ──
  {
    key: "ANTI_DEBUG_PTRACE",
    title: "ptrace 反调试（TracerPid 检测）",
    category: "anti-debug",
    regex: /(?:tracerpid|ptrace\s*\(|PTRACE_TRACEME|\/proc\/self\/status)/i,
    severity: "info",
    note: "通过读取 /proc/self/status 的 TracerPid 或 ptrace 自检防止调试器附加。",
    bypassHint: "可被 Frida hook ptrace 或修改 /proc 挂载绕过。",
  },
  {
    key: "ANTI_DEBUG_IS_DEBUGGER",
    title: "Debug.isDebuggerConnected 反调试",
    category: "anti-debug",
    regex: /Debug\.isDebuggerConnected\s*\(\s*\)/i,
    severity: "info",
    note: "检测 JDWP 调试器连接状态。",
    bypassHint: "可被 Frida hook Debug.isDebuggerConnected 返回 false 绕过。",
  },
  {
    key: "ANTI_DEBUG_TIMING",
    title: "时间差反调试（执行时间检测）",
    category: "anti-debug",
    regex: /(?:System\.nanoTime|System\.currentTimeMillis)[\s\S]{0,200}(?:System\.nanoTime|System\.currentTimeMillis)[\s\S]{0,100}(?:>|\bif\b)/i,
    severity: "info",
    note: "通过两次时间戳差值检测断点/单步执行——调试时执行时间显著增长。",
    bypassHint: "可被 hook System.nanoTime 绕过。",
  },
  {
    key: "ANTI_DEBUG_EXCEPTION",
    title: "异常反调试（Signal handler / SEH）",
    category: "anti-debug",
    regex: /(?:SignalHandler|SIGTRAP|SIGSEGV|UncaughtExceptionHandler)[\s\S]{0,100}(?:debugger|debug|trace)/i,
    severity: "info",
    note: "通过信号处理或异常捕获检测调试器。",
    bypassHint: "可被 hook 信号处理函数绕过。",
  },
  {
    key: "ANTI_DEBUG_JDWP",
    title: "JDWP 端口检测（调试器连接端口）",
    category: "anti-debug",
    regex: /(?:jdwp|23946|ro\.debuggable)/i,
    severity: "info",
    note: "检测 JDWP 调试端口或系统属性 ro.debuggable。",
    bypassHint: "可被修改系统属性或 hook 检测函数绕过。",
  },
  {
    key: "ANTI_DEBUG_INotify",
    title: "inotify 文件监控反调试（监控 /proc/self/mem）",
    category: "anti-debug",
    regex: /(?:inotify|IN_ACCESS|IN_OPEN)[\s\S]{0,100}(?:\/proc|mem|maps)/i,
    severity: "info",
    note: "通过 inotify 监控 /proc/self/mem 或 maps 的访问——调试器读取时触发。",
    bypassHint: "可被修改 inotify 事件处理或 /proc 挂载绕过。",
  },

  // ── Root 检测 ──
  {
    key: "ROOT_SU_BINARY",
    title: "su 二进制检测",
    category: "root-detect",
    regex: /(?:\/system\/bin\/su|\/system\/xbin\/su|\/sbin\/su|which\s+su)/i,
    severity: "info",
    note: "检测 su 二进制文件是否存在——Root 设备的标准标志。",
    bypassHint: "可被 Magisk Hide / su 文件重命名绕过。",
  },
  {
    key: "ROOT_BUSYBOX",
    title: "BusyBox 检测",
    category: "root-detect",
    regex: /(?:busybox|\/system\/xbin\/busybox)/i,
    severity: "info",
    note: "检测 BusyBox 工具集——Root 设备常见组件。",
    bypassHint: "可被隐藏 BusyBox 绕过。",
  },
  {
    key: "ROOT_MAGISK",
    title: "Magisk 检测",
    category: "root-detect",
    regex: /(?:magisk|com\.topjohnwu\.magisk|\/sbin\/\.magisk)/i,
    severity: "info",
    note: "检测 Magisk 框架——现代 Root 方案。",
    bypassHint: "可被 Magisk DenyList 绕过。",
  },
  {
    key: "ROOT_TEST_KEYS",
    title: "Build.TAGS test-keys 检测",
    category: "root-detect",
    regex: /Build\.TAGS[\s\S]{0,60}(?:test-keys|release-keys)/i,
    severity: "info",
    note: "test-keys 表示非官方 ROM（可能已 Root）。",
    bypassHint: "可被 hook Build.TAGS 绕过。",
  },
  {
    key: "ROOT_DANGEROUS_PROPS",
    title: "危险系统属性检测（ro.debuggable / ro.secure）",
    category: "root-detect",
    regex: /(?:ro\.debuggable|ro\.secure|ro\.build\.type)[\s\S]{0,60}(?:getprop|SystemProperties)/i,
    severity: "info",
    note: "ro.debuggable=1 或 ro.secure=0 表示调试/不安全 ROM。",
    bypassHint: "可被 hook SystemProperties.get 绕过。",
  },
  {
    key: "ROOT_INSTALLED_APPS",
    title: "Root 管理应用检测（Superuser/SuperSU）",
    category: "root-detect",
    regex: /(?:eu\.chainfire\.supersu|com\.noshufou\.android\.su|com\.koushikdutta\.superuser|me\.phh\.superuser)/i,
    severity: "info",
    note: "检测常见 Root 管理应用包名。",
    bypassHint: "可被隐藏应用包名绕过。",
  },

  // ── 模拟器检测 ──
  {
    key: "EMU_BUILD_FINGERPRINT",
    title: "Build.FINGERPRINT 模拟器特征",
    category: "emulator-detect",
    regex: /Build\.FINGERPRINT[\s\S]{0,60}(?:generic|vbox|sdk|google_sdk|emulator|genymotion|goldfish|ranchu)/i,
    severity: "info",
    note: "generic/vbox/goldfish 等指纹表示模拟器环境。",
    bypassHint: "可被 hook Build.FINGERPRINT 绕过。",
  },
  {
    key: "EMU_BUILD_MODEL",
    title: "Build.MODEL 模拟器特征",
    category: "emulator-detect",
    regex: /Build\.MODEL[\s\S]{0,60}(?:sdk|google_sdk|emulator|android sdk built for x86)/i,
    severity: "info",
    note: "sdk/google_sdk 等型号表示模拟器。",
    bypassHint: "可被 hook Build.MODEL 绕过。",
  },
  {
    key: "EMU_HARDWARE",
    title: "硬件特征模拟器检测（goldfish/ranchu）",
    category: "emulator-detect",
    regex: /(?:goldfish|ranchu|vbox86)[\s\S]{0,60}(?:Hardware|Board|getprop)/i,
    severity: "info",
    note: "goldfish/ranchu 是 Android 模拟器的内核硬件名称。",
    bypassHint: "可被 hook 系统属性读取绕过。",
  },
  {
    key: "EMU_DEVICE_ID",
    title: "设备 ID 模拟器特征（000000000000000）",
    category: "emulator-detect",
    regex: /(?:000000000000000|00000000-0000-0000-0000)/i,
    severity: "info",
    note: "全零 IMEI/设备 ID 是模拟器默认值。",
    bypassHint: "可被设置非零设备 ID 绕过。",
  },
  {
    key: "EMU_PHONE_NUMBER",
    title: "电话号码模拟器特征（1555521xxxx）",
    category: "emulator-detect",
    regex: /1555521\d{4}/i,
    severity: "info",
    note: "1555521xxxx 是 Android 模拟器默认电话号码。",
    bypassHint: "可被设置自定义电话号码绕过。",
  },
  {
    key: "EMU_SENSORS",
    title: "传感器可用性模拟器检测",
    category: "emulator-detect",
    regex: /SensorManager[\s\S]{0,100}(?:getDefaultSensor|getSensorList)[\s\S]{0,100}(?:null|size\s*==\s*0|empty)/i,
    severity: "info",
    note: "模拟器通常缺少物理传感器（加速度/陀螺仪等）。",
    bypassHint: "可被注入虚拟传感器绕过。",
  },

  // ── Hook 框架检测 ──
  {
    key: "HOOK_XPOSED_CLASS",
    title: "Xposed 框架类检测",
    category: "hook-detect",
    regex: /(?:de\.robv\.android\.xposed|XposedBridge|XposedHelpers|XC_MethodHook)/i,
    severity: "info",
    note: "检测 Xposed 框架的类名/包名——方法级 Hook。",
    bypassHint: "可被类名混淆或 EdXposed/LSPosed 隐藏绕过。",
  },
  {
    key: "HOOK_XPOSED_STACK",
    title: "Xposed 堆栈检测（调用栈特征）",
    category: "hook-detect",
    regex: /(?:getStackTrace|Thread\.currentThread)[\s\S]{0,200}(?:xposed|de\.robv)/i,
    severity: "info",
    note: "通过调用栈检测 Xposed 注入——hook 后栈帧含 Xposed 相关类。",
    bypassHint: "可被 hook Thread.getStackTrace 清除栈帧绕过。",
  },
  {
    key: "HOOK_FRIDA_PROCESS",
    title: "Frida 进程检测（frida-server）",
    category: "hook-detect",
    regex: /(?:frida-server|frida-agent|linjector|re\.frida)/i,
    severity: "info",
    note: "检测 Frida server 进程或 agent 注入——动态 Instrumentation。",
    bypassHint: "可被重命名 frida-server 或修改端口绕过。",
  },
  {
    key: "HOOK_FRIDA_PORT",
    title: "Frida 端口检测（默认 27042）",
    category: "hook-detect",
    regex: /(?:27042|27043)[\s\S]{0,60}(?:socket|connect|port)/i,
    severity: "info",
    note: "27042/27043 是 Frida 默认端口——检测开放端口可发现注入。",
    bypassHint: "可被修改 Frida 端口绕过。",
  },
  {
    key: "HOOK_FRIDA_MEMORY",
    title: "Frida 内存特征检测（/proc/self/maps）",
    category: "hook-detect",
    regex: /(?:\/proc\/self\/maps|\/proc\/self\/mem)[\s\S]{0,200}(?:frida|gum-js-loop|gmain)/i,
    severity: "info",
    note: "读取 /proc/self/maps 检测 Frida 注入的内存映射。",
    bypassHint: "可被 hook 文件读取或修改映射名称绕过。",
  },
  {
    key: "HOOK_SUBSTRATE",
    title: "Cydia Substrate 检测",
    category: "hook-detect",
    regex: /(?:CydiaSubstrate|substrate\.h|MSHookFunction|com\.saurik\.substrate)/i,
    severity: "info",
    note: "检测 Cydia Substrate 框架——iOS/Android Hook。",
    bypassHint: "可被隐藏 Substrate 组件绕过。",
  },

  // ── 完整性/篡改检测 ──
  {
    key: "TAMPER_SIGNATURE_CHECK",
    title: "签名自校验（PackageManager.getPackageInfo）",
    category: "tamper-detect",
    regex: /PackageManager[\s\S]{0,200}getPackageInfo[\s\S]{0,100}(?:SIGNATURES|signatures)/i,
    severity: "info",
    note: "通过 PackageManager 获取 APK 签名并与预期值比对——检测重签名。",
    bypassHint: "可被 hook PackageManager.getPackageInfo 返回原始签名绕过。",
  },
  {
    key: "TAMPER_HASH_CHECK",
    title: "APK 文件哈希校验（完整性自检）",
    category: "integrity",
    regex: /(?:MessageDigest|SHA-256|SHA256)[\s\S]{0,200}(?:getPackageCodePath|sourceDir|apk)/i,
    severity: "info",
    note: "计算 APK 文件哈希与预期值比对——检测篡改。",
    bypassHint: "可被 hook 文件读取或 MessageDigest 返回预期哈希绕过。",
  },
  {
    key: "TAMPER_INSTALLER_CHECK",
    title: "安装来源校验（getInstallerPackageName）",
    category: "tamper-detect",
    regex: /getInstallerPackageName[\s\S]{0,100}(?:com\.android\.vending|google|play)/i,
    severity: "info",
    note: "校验安装来源是否为 Google Play——防止侧载篡改版本。",
    bypassHint: "可被 hook getInstallerPackageName 绕过。",
  },
  {
    key: "TAMPER_RESIGN_DETECTION",
    title: "重签名检测（证书指纹比对）",
    category: "tamper-detect",
    regex: /(?:SHA-256|sha256|fingerprint|digest)[\s\S]{0,100}(?:certificate|cert|signature)[\s\S]{0,100}(?:compare|equals|match|expected)/i,
    severity: "info",
    note: "将当前签名证书 SHA-256 与硬编码预期值比对——检测重打包。",
    bypassHint: "可被 hook 比对函数返回 true 绕过。",
  },
  {
    key: "INTEGRITY_SAFETYNET",
    title: "SafetyNet/Play Integrity 检测",
    category: "integrity",
    regex: /(?:SafetyNetClient|SafetyNet\.attest|PlayIntegrity|recaptcha|verifyWithRecaptcha)/i,
    severity: "info",
    note: "Google SafetyNet/Play Integrity API——服务端验证设备完整性。",
    bypassHint: "可被 Magisk + Play Integrity Fix 绕过（需持续更新）。",
  },
  {
    key: "INTEGRITY_RASP",
    title: "RASP（运行时应用自我保护）集成",
    category: "integrity",
    regex: /(?:rasp|RuntimeAppSelfProtection|AppSealing|DexGuard|Arxan)/i,
    severity: "info",
    note: "检测商业 RASP 方案集成——提供多层运行时保护。",
    bypassHint: "商业 RASP 需要针对具体方案逆向——通常比开源方案更难绕过。",
  },
]

export interface RuntimeDetectionMatch {
  line: number
  key: string
  title: string
  category: RuntimePattern["category"]
  snippet: string
  severity: Finding["severity"]
  bypassHint: string
}

export function scanRuntimeDetection(source: string): RuntimeDetectionMatch[] {
  const matches: RuntimeDetectionMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue
    for (const pattern of RUNTIME_PATTERNS) {
      const context = lines.slice(Math.max(0, i - 1), i + 3).join("\n")
      if (pattern.regex.test(context) || pattern.regex.test(line)) {
        matches.push({
          line: i + 1,
          key: pattern.key,
          title: pattern.title,
          category: pattern.category,
          snippet: line.trim().slice(0, 120),
          severity: pattern.severity,
          bypassHint: pattern.bypassHint,
        })
        break
      }
    }
  }
  return matches
}

// 评估检测完整性:按类别统计已实现的检测数量
export function evaluateDetectionCompleteness(matches: RuntimeDetectionMatch[]): {
  byCategory: Record<string, number>
  totalDetections: number
  missingCategories: string[]
  completenessScore: number
} {
  const categories: RuntimePattern["category"][] = ["anti-debug", "root-detect", "emulator-detect", "hook-detect", "tamper-detect", "integrity"]
  const byCategory: Record<string, number> = {}
  for (const cat of categories) byCategory[cat] = 0
  for (const match of matches) byCategory[match.category] = (byCategory[match.category] ?? 0) + 1
  const missingCategories = categories.filter((cat) => (byCategory[cat] ?? 0) === 0)
  const totalDetections = matches.length
  // 完整性评分:覆盖类别数/总类别数 * 100
  const coveredCategories = categories.filter((cat) => (byCategory[cat] ?? 0) > 0).length
  const completenessScore = Math.round((coveredCategories / categories.length) * 100)
  return { byCategory, totalDetections, missingCategories, completenessScore }
}

export async function scanProjectRuntimeDetection(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const allMatches: RuntimeDetectionMatch[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanRuntimeDetection(source)
    for (const match of matches) {
      const dedupeKey = `${match.key}:${file}`
      if (seen.has(dedupeKey)) continue
      seen.add(dedupeKey)
      allMatches.push(match)
    }
  }

  const findings: Finding[] = []
  const completeness = evaluateDetectionCompleteness(allMatches)

  // 每个检测类别一条 finding
  const categoryLabels: Record<string, string> = {
    "anti-debug": "反调试", "root-detect": "Root 检测", "emulator-detect": "模拟器检测",
    "hook-detect": "Hook 框架检测", "tamper-detect": "篡改检测", "integrity": "完整性校验",
  }
  for (const [cat, count] of Object.entries(completeness.byCategory)) {
    if (count === 0) continue
    const catMatches = allMatches.filter((m) => m.category === cat)
    const relative = (f: string) => path.relative(projectRoot, f).replaceAll("\\", "/")
    findings.push({
      severity: "info",
      confidence: "high",
      code: "RUNTIME_DETECTION",
      title: `${categoryLabels[cat] ?? cat} 已实现 ${count} 项检测`,
      detail: catMatches.slice(0, 5).map((m) => `${m.title}: ${m.bypassHint}`).join("; "),
      recommendation: "运行时检测应多层组合（单点检测易绕过）;建议至少覆盖 4/6 个类别。",
      evidence: catMatches.slice(0, 5).map((m) => m.key).join(", "),
    })
  }

  // 缺失类别提示
  if (completeness.missingCategories.length > 0) {
    findings.push({
      severity: "medium",
      confidence: "high",
      code: "RUNTIME_DETECTION_GAPS",
      title: `运行时安全检测缺失 ${completeness.missingCategories.length} 个类别`,
      detail: `未检测到以下类别的实现: ${completeness.missingCategories.map((c) => categoryLabels[c] ?? c).join("、")}。完整性评分: ${completeness.completenessScore}%。`,
      recommendation: "补充缺失类别的运行时检测;多层组合可显著提高绕过成本。",
      evidence: completeness.missingCategories.join(","),
    })
  }

  return findings
}
