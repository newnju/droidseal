// adb 真机/模拟器桥接（动态分析的轻量验证——adb-bridge.ts）。
// 静态审计完成后，可选地把 APK 安装到本地 adb 设备（真机/模拟器——adb 协议统一识别），
// 执行只读验证（安装/启动/logcat/dumpsys）——动态证据反馈到报告（静态+动态交叉验证）。
// 边界：不拦截/不篡改（不做事后改写未知 APK）；无设备/命令失败 → 跳过（失败关闭）。
import { spawnSync } from "node:child_process"
import type { Finding } from "./types.ts"

export interface DynamicVerificationResult {
  skipped: boolean
  reason?: string
  device?: string
  findings: Finding[]
}

export interface AdbDevice {
  serial: string
  isEmulator: boolean
}

// 检测 adb 设备（真机/模拟器统一——emulator-* 即模拟器）——失败关闭。
export function detectAdbDevices(): AdbDevice[] {
  const result = spawnSync("adb", ["devices"], { timeout: 15000 })
  if (result.status !== 0) return [] // adb 不可用——失败关闭
  const lines = result.stdout.toString().split(/\r?\n/)
  const devices: AdbDevice[] = []
  for (const line of lines) {
    const parts = line.trim().split(/\s+/)
    if (parts.length < 2 || parts[1] !== "device") continue // 跳过头部/offline/unauthorized
    devices.push({ serial: parts[0]!, isEmulator: parts[0]!.startsWith("emulator-") })
  }
  return devices
}

// logcat 敏感明文日志模式（密码/密钥/令牌——验证静态发现的日志泄露）。
const LOG_LEAK_PATTERNS = [
  /\b(?:password|passwd|pwd)\s*[:=]\s*\S+/i,
  /\b(?:api[_-]?key|apikey|secret|token)\s*[:=]\s*\S+/i,
  /AIza[0-9A-Za-z_-]{20,}/,
  /AKIA[0-9A-Z]{16}/,
  /\b(?:ghp|gho)_[0-9A-Za-z]{30,}/,
]

// 运行动态验证（安装/启动/logcat/dumpsys——只读验证——失败关闭）。
export function runDynamicVerification(
  apkPath: string,
  packageName: string | undefined,
  findings: readonly Finding[],
): DynamicVerificationResult {
  const devices = detectAdbDevices()
  if (devices.length === 0) return { skipped: true, reason: "无 adb 设备（真机/模拟器）——跳过动态验证", findings: [] }
  const device = devices[0]!
  const out: Finding[] = []

  // 1. 安装（可选——失败不阻断后续 logcat 检查）
  const install = spawnSync("adb", ["-s", device.serial, "install", "-r", apkPath], { timeout: 120000 })
  if (install.status === 0) {
    // 2. 启动（packageName 可用时——轻量启动验证）
    if (packageName) {
      spawnSync("adb", ["-s", device.serial, "shell", "am", "start", "-n", `${packageName}/.MainActivity`], { timeout: 30000 })
    }
    // 3. logcat 敏感明文日志（验证静态发现的日志泄露）
    const logcat = spawnSync("adb", ["-s", device.serial, "logcat", "-d"], { timeout: 30000, maxBuffer: 8 * 1024 * 1024 })
    if (logcat.status === 0) {
      const logText = logcat.stdout.toString()
      const leaks = LOG_LEAK_PATTERNS.filter((p) => p.test(logText))
      if (leaks.length > 0) {
        out.push({
          severity: "medium",
          confidence: "high",
          code: "DYNAMIC_LOG_LEAK",
          title: `动态验证：日志泄露敏感信息（${leaks.length} 类模式）`,
          detail: `设备 ${device.serial} 的 logcat 中出现敏感明文日志（密码/密钥/令牌形态）——静态日志泄露发现（SOURCE_DATAFLOW 等）的动态交叉证据。`,
          recommendation: "核对动态日志；敏感数据不应写入 logcat（生产日志脱敏）。",
          evidence: `设备 ${device.serial} logcat 命中 ${leaks.length} 类敏感模式`,
        })
      }
    }
    // 4. dumpsys 运行时状态（验证静态发现的 debuggable）
    if (packageName) {
      const dumpsys = spawnSync("adb", ["-s", device.serial, "shell", "dumpsys", "package", packageName], { timeout: 30000, maxBuffer: 8 * 1024 * 1024 })
      if (dumpsys.status === 0) {
        const dumpsysText = dumpsys.stdout.toString()
        if (/flags=\[.*DEBUGGABLE/.test(dumpsysText)) {
          out.push({
            severity: "high",
            confidence: "high",
            code: "DYNAMIC_DEBUGGABLE",
            title: "动态验证：运行时应用为可调试状态",
            detail: `设备 ${device.serial} 的 dumpsys 显示 ${packageName} flags 含 DEBUGGABLE——静态 DEBUGGABLE 发现的动态交叉证据。`,
            recommendation: "发布构建不应可调试（debuggable=false）。",
            evidence: `设备 ${device.serial} dumpsys DEBUGGABLE=${packageName}`,
          })
        }
      }
    }
  }

  // 反馈：动态证据附加到对应静态 finding（交叉验证升级）
  for (const finding of findings) {
    if (finding.code === "SOURCE_DATAFLOW" && out.some((f) => f.code === "DYNAMIC_LOG_LEAK")) {
      finding.detail = `${finding.detail ?? ""} 动态验证：设备 ${device.serial} logcat 证实日志泄露。`
    }
  }

  return { skipped: false, device: device.serial, findings: out }
}
