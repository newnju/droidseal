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
      // 动态分析深化：崩溃/ANR 检测（logcat 的 FATAL EXCEPTION / ANR in——运行期稳定性证据）
      const crashMatch = /FATAL EXCEPTION[\s\S]{0,200}/.exec(logText)
      const anrMatch = /ANR in [\s\S]{0,200}/.exec(logText)
      if (crashMatch || anrMatch) {
        out.push({
          severity: "medium",
          confidence: "high",
          code: "DYNAMIC_CRASH_ANR",
          title: `动态验证：运行期崩溃/ANR${crashMatch ? "（崩溃）" : "（ANR）"}`,
          detail: `设备 ${device.serial} 的 logcat 出现${crashMatch ? " FATAL EXCEPTION" : " ANR"}——运行期稳定性问题（可与主线程 IO/ANR 类静态发现交叉验证）。`,
          recommendation: "核对崩溃/ANR 堆栈；主线程不应执行 IO/网络等耗时操作。",
          evidence: `设备 ${device.serial} logcat ${crashMatch ? "崩溃" : "ANR"} 片段 ${(crashMatch ?? anrMatch)![0].slice(0, 120)}`,
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
      // 动态分析深化：更多 dumpsys 服务采集（activity/netstats/device——运行期状态证据——失败关闭）
      const activity = spawnSync("adb", ["-s", device.serial, "shell", "dumpsys", "activity", "top"], { timeout: 30000, maxBuffer: 4 * 1024 * 1024 })
      if (activity.status === 0 && activity.stdout.toString().includes(packageName)) {
        out.push({
          severity: "info",
          confidence: "medium",
          code: "DYNAMIC_ACTIVITY_STATE",
          title: "动态验证：前台 Activity 状态确认",
          detail: `设备 ${device.serial} 的前台 Activity 属于 ${packageName}——应用运行期界面状态（可与 UI 敏感类静态发现交叉验证）。`,
          recommendation: "核对前台界面；敏感界面应 FLAG_SECURE（防截屏）。",
          evidence: `设备 ${device.serial} dumpsys activity top 显示 ${packageName}`,
        })
      }
      const netstats = spawnSync("adb", ["-s", device.serial, "shell", "dumpsys", "netstats"], { timeout: 30000, maxBuffer: 4 * 1024 * 1024 })
      if (netstats.status === 0) {
        const netText = netstats.stdout.toString()
        const uidMatch = /uid=(\d+)[\s\S]{0,120}?rxBytes=(\d+)[\s\S]{0,40}?txBytes=(\d+)/.exec(netText)
        if (uidMatch) {
          out.push({
            severity: "info",
            confidence: "medium",
            code: "DYNAMIC_NETWORK_ACTIVITY",
            title: "动态验证：应用网络流量活跃",
            detail: `设备 ${device.serial} 的 netstats 显示 uid=${uidMatch[1]} 流量 rx=${uidMatch[2]}B/tx=${uidMatch[3]}B——应用运行期联网行为（可与网络类静态发现交叉验证）。`,
            recommendation: "核对联网行为与端点清单；确认无未授权的网络通信。",
            evidence: `设备 ${device.serial} netstats uid=${uidMatch[1]} rx=${uidMatch[2]}B`,
          })
        }
      }
      const devicePolicy = spawnSync("adb", ["-s", device.serial, "shell", "dumpsys", "device_policy"], { timeout: 30000, maxBuffer: 4 * 1024 * 1024 })
      if (devicePolicy.status === 0 && /active admin/i.test(devicePolicy.stdout.toString())) {
        out.push({
          severity: "medium",
          confidence: "high",
          code: "DYNAMIC_DEVICE_ADMIN_ACTIVE",
          title: "动态验证：设备管理管理员处于激活状态",
          detail: `设备 ${device.serial} 的 dumpsys device_policy 显示存在激活的设备管理管理员——设备管理 API（锁屏/擦除）的动态交叉证据。`,
          recommendation: "核对设备管理用途（企业 MDM 或滥用风险）；最小化设备管理能力。",
          evidence: `设备 ${device.serial} dumpsys device_policy 存在 active admin`,
        })
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
