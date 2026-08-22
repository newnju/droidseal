// 隐私数据收集清单（MobSF 剩余缺口——App 隐私标签/数据收集检测的本地版）。
// 从 Manifest 权限与源码 API 推断隐私数据收集面——清单级 finding，失败关闭（未命中不输出）。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

// 权限 → 隐私数据类别
const PRIVACY_PERMISSIONS: ReadonlyArray<{ permission: string; category: string }> = [
  { permission: "android.permission.ACCESS_FINE_LOCATION", category: "位置（精确定位）" },
  { permission: "android.permission.ACCESS_COARSE_LOCATION", category: "位置（粗略）" },
  { permission: "android.permission.READ_CONTACTS", category: "通讯录" },
  { permission: "android.permission.CAMERA", category: "相机" },
  { permission: "android.permission.RECORD_AUDIO", category: "麦克风/录音" },
  { permission: "android.permission.READ_SMS", category: "短信" },
  { permission: "android.permission.READ_CALL_LOG", category: "通话记录" },
  { permission: "android.permission.READ_PHONE_STATE", category: "设备标识（IMEI/电话号码）" },
  { permission: "android.permission.READ_EXTERNAL_STORAGE", category: "外部存储文件" },
  { permission: "android.permission.READ_MEDIA_IMAGES", category: "媒体（图片）" },
  { permission: "android.permission.READ_MEDIA_VIDEO", category: "媒体（视频）" },
  { permission: "android.permission.BODY_SENSORS", category: "健康传感器" },
  { permission: "android.permission.READ_CALENDAR", category: "日历" },
  { permission: "android.permission.READ_PHONE_NUMBERS", category: "电话号码" },
]

// 从 Manifest 权限清单提取隐私数据收集面（失败关闭）。
export function detectPrivacyCollection(permissions: readonly string[]): Array<{ category: string; permission: string }> {
  const granted = new Set(permissions)
  return PRIVACY_PERMISSIONS.filter((entry) => granted.has(entry.permission)).map((entry) => ({
    category: entry.category,
    permission: entry.permission,
  }))
}

export function buildPrivacyFindings(permissions: readonly string[]): Finding[] {
  const collected = detectPrivacyCollection(permissions)
  if (collected.length === 0) return []
  return [
    {
      severity: "info",
      code: "PRIVACY_DATA_COLLECTION",
      title: `申请了 ${collected.length} 类隐私数据权限`,
      detail: `清单级提示（不判定违规）：${collected.map((c) => c.category).join("、")}。请核对数据收集用途与隐私政策一致性。`,
      recommendation: "逐项确认收集用途；对照 Play 政策与隐私标签声明；最小化权限（仅申请必要权限）。",
      evidence: collected.map((c) => c.permission).join(", "),
    },
  ]
}

// 源码侧隐私 API 检测（补充：getDeviceId/位置监听等 API 调用）。
const PRIVACY_API_PATTERNS: ReadonlyArray<{ pattern: RegExp; category: string }> = [
  { pattern: /getdeviceid\(/i, category: "设备标识（IMEI）" },
  { pattern: /getsimserialnumber\(/i, category: "SIM 序列号" },
  { pattern: /requestlocationupdates\(/i, category: "位置监听" },
  { pattern: /getaccounts\(/i, category: "账户列表" },
  { pattern: /querycontacts|contactscontract/i, category: "通讯录访问" },
  { pattern: /cameramanager\.open\(/i, category: "相机访问" },
  { pattern: /audiomanager.*startrecording|mediarecorder/i, category: "录音" },
]

export function scanPrivacyApis(source: string): Array<{ line: number; category: string; snippet: string }> {
  const matches: Array<{ line: number; category: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    for (const entry of PRIVACY_API_PATTERNS) {
      if (entry.pattern.test(line)) {
        matches.push({ line: i + 1, category: entry.category, snippet: line.trim().slice(0, 100) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码的隐私 API 调用（失败关闭）。
export async function scanProjectPrivacyApis(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanPrivacyApis(source)
    for (const match of matches.slice(0, 3)) {
      const key = `${match.category}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "info",
        code: "PRIVACY_API_USAGE",
        title: `源码调用隐私相关 API：${match.category}`,
        detail: `${relative}:${match.line} 调用 ${match.category} 相关 API。`,
        recommendation: "核对数据收集用途与隐私政策一致性；必要时服务端化或脱敏。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
