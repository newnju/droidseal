// 网络环境检测模式分析（#83）。
// 检测应用是否实现了网络环境安全检测：HTTP 代理检测、系统代理检测、VPN 检测、
// TUN 接口检测、SSL Pinning 配置、网络安全策略检测。
// 纯 TypeScript 源码正则匹配，失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import { isIgnoredLine } from "./suppression.ts"
import type { Finding } from "./types.ts"

interface NetworkPattern {
  key: string
  title: string
  category: "proxy" | "vpn" | "tun" | "ssl-pinning" | "network-policy" | "dns" | "certificate"
  regex: RegExp
  severity: Finding["severity"]
  note: string
  bypassHint: string
}

const NETWORK_PATTERNS: readonly NetworkPattern[] = [
  // ── 代理检测 ──
  { key: "NET_PROXY_SYSTEM", title: "系统代理检测", category: "proxy", regex: /(?:Proxy\.getDefault|System\.getProperty\s*\(\s*["']http\.proxy|PROXY_CHANGE|ConnectivityManager)[\s\S]{0,60}(?:proxy|PROXY)/i, severity: "info", note: "检测系统 HTTP 代理设置。", bypassHint: "可被 hook Proxy.getDefault 返回 null 绕过。" },
  { key: "NET_PROXY_ANDROID", title: "Android 代理设置检测", category: "proxy", regex: /(?:Settings\.Global|Settings\.Secure)[\s\S]{0,60}(?:http_proxy|global_http_proxy)/i, severity: "info", note: "读取 Android 全局代理设置。", bypassHint: "可被 hook Settings.Global.getString 绕过。" },
  { key: "NET_PROXY_VPN_SERVICE", title: "VPN 服务检测", category: "vpn", regex: /(?:VpnService|NetworkCallback|ConnectivityManager)[\s\S]{0,60}(?:VPN|vpn|tun0)/i, severity: "info", note: "检测活跃的 VPN 连接。", bypassHint: "可被 hook ConnectivityManager 绕过。" },
  { key: "NET_PROXY_NETWORK_INTERFACE", title: "网络接口检测(tun/tap)", category: "tun", regex: /(?:NetworkInterface|getNetworkInterfaces)[\s\S]{0,60}(?:tun|tap|ppp|wg)/i, severity: "info", note: "枚举网络接口检测 TUN/TAP/PPP/WireGuard。", bypassHint: "可被 hook NetworkInterface.getNetworkInterfaces 绕过。" },
  { key: "NET_DNS_HIJACK_DETECT", title: "DNS 劫持检测", category: "dns", regex: /(?:InetAddress|DnsResolver)[\s\S]{0,100}(?:expected|verify|compare|check)[\s\S]{0,60}(?:dns|resolve|lookup)/i, severity: "info", note: "检测 DNS 解析结果是否被篡改。", bypassHint: "可被 hook DNS 解析函数绕过。" },
  { key: "NET_SSL_PINNING_OKHTTP", title: "OkHttp SSL Pinning 配置", category: "ssl-pinning", regex: /CertificatePinner\.Builder\s*\(\s*\)\s*\.add/i, severity: "info", note: "OkHttp CertificatePinner 证书固定。", bypassHint: "可被 Frida script 绕过 CertificatePinner.check。" },
  { key: "NET_SSL_PINNING_NSC", title: "Network Security Config 证书固定", category: "ssl-pinning", regex: /<pin-set\b/i, severity: "info", note: "NSC pin-set 证书固定。", bypassHint: "可被修改 NSC XML 绕过。" },
  { key: "NET_SSL_PINNING_CUSTOM_TRUST", title: "自定义 TrustManager 证书校验", category: "certificate", regex: /(?:X509TrustManager|checkServerTrusted)[\s\S]{0,100}(?:verify|check|validate)/i, severity: "info", note: "自定义证书校验逻辑。", bypassHint: "可被 hook TrustManager 绕过。" },
  { key: "NET_CERT_TRANSPARENCY", title: "证书透明度检测", category: "certificate", regex: /(?:CertificateTransparency|CTVerifier|checkCT)/i, severity: "info", note: "Certificate Transparency 日志验证。", bypassHint: "可被 hook CT 验证函数绕过。" },
  { key: "NET_EMULATOR_NETWORK", title: "模拟器网络特征检测", category: "proxy", regex: /(?:10\.0\.2\.2|10\.0\.3\.2|emulator|goldfish)[\s\S]{0,60}(?:network|connect|socket)/i, severity: "info", note: "检测模拟器默认网络配置（10.0.2.2 网关）。", bypassHint: "可被修改网络配置绕过。" },
  { key: "NET_WIFI_INFO", title: "WiFi 信息收集", category: "proxy", regex: /(?:WifiInfo|WifiManager|getConnectionInfo|getSSID|getBSSID)/i, severity: "info", note: "收集 WiFi SSID/BSSID 信息——可用于位置推断或环境判断。", bypassHint: "可被 hook WifiManager 绕过。" },
  { key: "NET_CELL_INFO", title: "蜂窝网络信息收集", category: "proxy", regex: /(?:CellInfo|TelephonyManager|getAllCellInfo|getCellLocation)/i, severity: "info", note: "收集基站信息——可用于粗略定位。", bypassHint: "可被 hook TelephonyManager 绕过。" },
]

export interface NetworkEnvMatch {
  line: number
  key: string
  title: string
  category: NetworkPattern["category"]
  snippet: string
  severity: Finding["severity"]
  bypassHint: string
}

export function scanNetworkEnvPatterns(source: string): NetworkEnvMatch[] {
  const matches: NetworkEnvMatch[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    if (isIgnoredLine(line)) continue
    for (const pattern of NETWORK_PATTERNS) {
      const context = lines.slice(Math.max(0, i - 1), i + 3).join("\n")
      if (pattern.regex.test(context) || pattern.regex.test(line)) {
        matches.push({ line: i + 1, key: pattern.key, title: pattern.title, category: pattern.category, snippet: line.trim().slice(0, 120), severity: pattern.severity, bypassHint: pattern.bypassHint })
        break
      }
    }
  }
  return matches
}

export function evaluateNetworkEnvCompleteness(matches: NetworkEnvMatch[]): {
  byCategory: Record<string, number>
  totalDetections: number
  missingCategories: string[]
  completenessScore: number
} {
  const categories: NetworkPattern["category"][] = ["proxy", "vpn", "tun", "ssl-pinning", "network-policy", "dns", "certificate"]
  const byCategory: Record<string, number> = {}
  for (const cat of categories) byCategory[cat] = 0
  for (const match of matches) byCategory[match.category] = (byCategory[match.category] ?? 0) + 1
  const missingCategories = categories.filter((cat) => (byCategory[cat] ?? 0) === 0)
  const coveredCategories = categories.filter((cat) => (byCategory[cat] ?? 0) > 0).length
  const completenessScore = Math.round((coveredCategories / categories.length) * 100)
  return { byCategory, totalDetections: matches.length, missingCategories, completenessScore }
}

export async function scanProjectNetworkEnv(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const allMatches: NetworkEnvMatch[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanNetworkEnvPatterns(source)
    for (const match of matches) {
      const dedupeKey = `${match.key}:${file}`
      if (seen.has(dedupeKey)) continue
      seen.add(dedupeKey)
      allMatches.push(match)
    }
  }
  const completeness = evaluateNetworkEnvCompleteness(allMatches)
  const findings: Finding[] = []
  const categoryLabels: Record<string, string> = {
    proxy: "代理检测", vpn: "VPN 检测", tun: "TUN/TAP 检测",
    "ssl-pinning": "SSL Pinning", "network-policy": "网络安全策略",
    dns: "DNS 检测", certificate: "证书校验",
  }
  if (allMatches.length > 0) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "NETWORK_ENV_DETECTION",
      title: `检测到 ${allMatches.length} 项网络环境安全检测(${Object.keys(completeness.byCategory).filter((k) => (completeness.byCategory[k] ?? 0) > 0).length}/7 类别)`,
      detail: allMatches.slice(0, 8).map((m) => `${m.title}: ${m.bypassHint}`).join("; "),
      recommendation: "网络环境检测应多层组合;覆盖代理/VPN/TUN/SSL Pinning 可显著提高绕过成本。",
      evidence: allMatches.slice(0, 8).map((m) => m.key).join(", "),
    })
  }
  return findings
}
