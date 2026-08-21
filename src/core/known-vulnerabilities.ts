// 离线已知漏洞快照与比对（长期路线：供应链深化）。
// 只做清单级提示：按组件名匹配已知 CVE，不联网核对版本，不做可达性分析。
// 快照为人工维护的精简集（仅收录确定且常见的条目）；发现新披露时手工补充。
import type { Finding } from "./types.ts"

export interface KnownVulnerability {
  package: string
  cve: string
  severity: Finding["severity"]
  note: string
}

export const KNOWN_VULNERABILITIES: readonly KnownVulnerability[] = [
  {
    package: "commons-text",
    cve: "CVE-2022-42889",
    severity: "high",
    note: "Text4Shell：commons-text 1.9/1.10 的字符串替换可达 RCE（需可达的不可信输入）。",
  },
  {
    package: "commons-io",
    cve: "CVE-2021-29425",
    severity: "medium",
    note: "commons-io 2.2–2.6 的文件名路径规范化问题。",
  },
  {
    package: "log4j-core",
    cve: "CVE-2021-44228",
    severity: "critical",
    note: "Log4Shell：log4j 2.0–2.14.1 的 JNDI 注入 RCE（Android 客户端通常少见，多与服务端相关）。",
  },
  {
    package: "jackson-databind",
    cve: "CVE-2020-36518",
    severity: "medium",
    note: "jackson-databind 2.13.0 之前版本的反序列化 DoS。",
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
        recommendation: "确认实际引入版本；如受影响请升级到修复版本，并核对是否存在利用路径。",
        evidence: `${component} -> ${entry.cve}`,
      })
    }
  }
  return findings
}
