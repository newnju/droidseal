// 离线已知漏洞快照与比对（长期路线：供应链深化）。
// 只做清单级提示：按组件名匹配已知 CVE，不联网核对版本，不做可达性分析。
// 快照为人工维护的精简集（仅收录确定且常见的条目）；发现新披露时手工补充。
import type { Finding } from "./types.ts"

export interface KnownVulnerability {
  package: string
  cve: string
  severity: Finding["severity"]
  note: string
  // 已知修复版本提示（清单级，不联网核对实际版本）。
  fixedIn?: string
}

export const KNOWN_VULNERABILITIES: readonly KnownVulnerability[] = [
  {
    package: "commons-text",
    cve: "CVE-2022-42889",
    severity: "high",
    note: "Text4Shell：commons-text 1.9/1.10 的字符串替换可达 RCE（需可达的不可信输入）。",
    fixedIn: "commons-text >= 1.10.0",
  },
  {
    package: "commons-io",
    cve: "CVE-2021-29425",
    severity: "medium",
    note: "commons-io 2.2–2.6 的文件名路径规范化问题。",
    fixedIn: "commons-io >= 2.7",
  },
  {
    package: "log4j-core",
    cve: "CVE-2021-44228",
    severity: "critical",
    note: "Log4Shell：log4j 2.0–2.14.1 的 JNDI 注入 RCE（Android 客户端通常少见，多与服务端相关）。",
    fixedIn: "log4j-core >= 2.17.1",
  },
  {
    package: "jackson-databind",
    cve: "CVE-2020-36518",
    severity: "medium",
    note: "jackson-databind 2.13.0 之前版本的反序列化 DoS。",
    fixedIn: "jackson-databind >= 2.13.0",
  },
  {
    package: "gson",
    cve: "CVE-2022-25647",
    severity: "high",
    note: "Gson 2.8.9 之前版本对超深层/超大 JSON 的反序列化 DoS（堆栈溢出/资源耗尽）。",
    fixedIn: "gson >= 2.8.9",
  },
  {
    package: "commons-compress",
    cve: "CVE-2021-36090",
    severity: "medium",
    note: "commons-compress 1.21 之前版本对畸形压缩包的拒绝服务（资源耗尽）。",
    fixedIn: "commons-compress >= 1.21",
  },
  {
    package: "okio",
    cve: "CVE-2023-3635",
    severity: "medium",
    note: "okio 3.4.0 之前版本的缓冲区溢出导致的拒绝服务（Android 常见依赖）。",
    fixedIn: "okio >= 3.4.0",
  },
]

// 用离线快照比对检测到的 SDK/组件名，命中返回 finding（仅清单提示，不联网）。
export function compareKnownVulnerabilities(
  components: Iterable<string>,
  snapshot: readonly KnownVulnerability[] = KNOWN_VULNERABILITIES,
): Finding[] {
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const component of components) {
    const key = component.toLowerCase()
    for (const entry of snapshot) {
      const target = entry.package.toLowerCase()
      if (!(key.includes(target) || target.includes(key))) continue
      const dedupe = entry.cve
      if (seen.has(dedupe)) continue
      seen.add(dedupe)
      findings.push({
        severity: entry.severity,
        code: "SUPPLYCHAIN_KNOWN_VULNERABILITY",
        title: `检测到已知漏洞组件：${entry.package}（${entry.cve}）`,
        detail: `${component} 命中离线漏洞快照 ${entry.cve}。${entry.note} 仅清单提示，不联网核对实际版本。`,
        recommendation: `确认实际引入版本；如受影响请升级到修复版本（${entry.fixedIn ?? "见官方公告"}），并核对是否存在利用路径。`,
        evidence: `${component} -> ${entry.cve}`,
      })
    }
  }
  return findings
}
