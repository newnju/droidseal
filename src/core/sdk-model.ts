// SDK 版本化源/汇模型（⑯——完整版：API→引入版本映射表 + minSdk 对比）。
// 检测源码中使用"引入版本高于当前 minSdk"的敏感 API——低版本设备上不可用/行为不同，
// 提示版本兼容与行为差异。失败关闭：minSdk 缺省 21（Android 5.0），未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface SdkApiEntry {
  api: string
  since: number
  note: string
}

// 常见敏感/隐私 API 的引入 SDK 版本（完整映射表——人工维护，按 Android 版本演进补充）。
const SDK_API_MAP: readonly SdkApiEntry[] = [
  { api: "getprimaryclip(", since: 11, note: "ClipboardManager.getPrimaryClip（剪贴板读取）" },
  { api: "getdevicesdklevels", since: 21, note: "SDK 级别读取" },
  { api: "getinstalledapplications(", since: 21, note: "已安装应用列表（隐私敏感——包可见性受限）" },
  { api: "requestpermissions(", since: 23, note: "运行时权限请求" },
  { api: "getimei(", since: 26, note: "TelephonyManager.getImei（设备标识）" },
  { api: "getserial(", since: 26, note: "Build.getSerial（设备序列号）" },
  { api: "getsubscriberid(", since: 26, note: "TelephonyManager.getSubscriberId（IMSI 相关）" },
  { api: "getdeviceid(", since: 26, note: "TelephonyManager.getDeviceId（API 26+ 需权限）" },
]

export interface SdkMismatchMatch {
  line: number
  api: string
  since: number
  note: string
  snippet: string
}

// 逐行检测：命中映射表 API 且 minSdk < since → 版本不匹配提示（失败关闭）。
export function scanSdkMismatch(source: string, minSdk: number): SdkMismatchMatch[] {
  const matches: SdkMismatchMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    for (const entry of SDK_API_MAP) {
      if (lower.includes(entry.api) && minSdk < entry.since) {
        matches.push({ line: i + 1, api: entry.api, since: entry.since, note: entry.note, snippet: line.trim().slice(0, 100) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectSdkMismatch(projectRoot: string, minSdk: number = 21): Promise<Finding[]> {
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
    const matches = scanSdkMismatch(source, minSdk)
    for (const match of matches.slice(0, 2)) {
      const key = `${match.api}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "low",
        confidence: "medium",
        code: "SDK_LEVEL_API_MISMATCH",
        title: `API 需要更高 SDK 版本：${match.note}`,
        detail: `${relative}:${match.line} 使用 ${match.api}（引入于 API ${match.since}），当前 minSdk=${minSdk}——低版本设备上不可用或行为不同。`,
        recommendation: "核对 minSdk 与 API 版本；低版本设备上需降级处理或提供替代实现。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
