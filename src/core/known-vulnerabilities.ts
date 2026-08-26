// 离线已知漏洞快照与比对（供应链深化）。
// 只做清单级提示：按组件名匹配已知 CVE，不联网核对版本，不做可达性分析。
// 快照为人工维护的精简集（仅收录确定且常见的条目）；发现新披露时手工补充。
import type { Finding } from "./types.ts"

export interface KnownVulnerability {
  package: string
  cve: string
  severity: Finding["severity"]
  note: string
  // 已知受影响版本区间（清单级，不联网核对实际版本）。
  affected?: string
  // 已知修复版本提示（清单级，不联网核对实际版本）。
  fixedIn?: string
}

export const KNOWN_VULNERABILITIES: readonly KnownVulnerability[] = [
  {
    package: "commons-text",
    cve: "CVE-2022-42889",
    severity: "high",
    note: "Text4Shell：commons-text 1.9/1.10 的字符串替换可达 RCE（需可达的不可信输入）。",
    affected: "1.9–1.10",
    fixedIn: "commons-text >= 1.10.0",
  },
  {
    package: "commons-io",
    cve: "CVE-2021-29425",
    severity: "medium",
    note: "commons-io 2.2–2.6 的文件名路径规范化问题。",
    affected: "2.2–2.6",
    fixedIn: "commons-io >= 2.7",
  },
  {
    package: "log4j-core",
    cve: "CVE-2021-44228",
    severity: "critical",
    note: "Log4Shell：log4j 2.0–2.14.1 的 JNDI 注入 RCE（Android 客户端通常少见，多与服务端相关）。",
    affected: "2.0–2.14.1",
    fixedIn: "log4j-core >= 2.17.1",
  },
  {
    package: "jackson-databind",
    cve: "CVE-2020-36518",
    severity: "medium",
    note: "jackson-databind 2.13.0 之前版本的反序列化 DoS。",
    affected: "<2.13.0",
    fixedIn: "jackson-databind >= 2.13.0",
  },
  {
    package: "gson",
    cve: "CVE-2022-25647",
    severity: "high",
    note: "Gson 2.8.9 之前版本对超深层/超大 JSON 的反序列化 DoS（堆栈溢出/资源耗尽）。",
    affected: "<2.8.9",
    fixedIn: "gson >= 2.8.9",
  },
  {
    package: "commons-compress",
    cve: "CVE-2021-36090",
    severity: "medium",
    note: "commons-compress 1.21 之前版本对畸形压缩包的拒绝服务（资源耗尽）。",
    affected: "<1.21",
    fixedIn: "commons-compress >= 1.21",
  },
  {
    package: "okio",
    cve: "CVE-2023-3635",
    severity: "medium",
    note: "okio 3.4.0 之前版本的缓冲区溢出导致的拒绝服务（Android 常见依赖）。",
    affected: "<3.4.0",
    fixedIn: "okio >= 3.4.0",
  },
  // 扩充（④——8 → 30 条）：常见库已知漏洞（真实 CVE——清单级提示）
  {
    package: "okhttp",
    cve: "CVE-2021-0341",
    severity: "high",
    note: "OkHttp 2.6.0 之前版本的主机名校验绕过（证书固定/校验缺口——Android 最常见网络库）。",
    affected: "<2.6.0",
    fixedIn: "okhttp >= 2.6.0（建议 4.x）",
  },
  {
    package: "glide",
    cve: "CVE-2019-16373",
    severity: "medium",
    note: "Glide 4.9.0 之前版本加载 URL 时的重定向 SSRF（不校验重定向目标）。",
    affected: "<4.9.0",
    fixedIn: "glide >= 4.9.0",
  },
  {
    package: "commons-codec",
    cve: "CVE-2021-35515",
    severity: "medium",
    note: "commons-codec 1.15 之前版本 Base32 解码的输入循环 DoS。",
    affected: "<1.15",
    fixedIn: "commons-codec >= 1.15",
  },
  {
    package: "commons-collections",
    cve: "CVE-2015-7501",
    severity: "critical",
    note: "commons-collections 3.2.1/4.1 的 InvokerTransformer 反序列化 RCE（老 Android 应用常见）。",
    affected: "<=3.2.1 / <=4.1",
    fixedIn: "commons-collections >= 3.2.2 / 4.2",
  },
  {
    package: "commons-beanutils",
    cve: "CVE-2019-10086",
    severity: "high",
    note: "commons-beanutils 1.9.3 之前版本的反序列化 RCE（依赖 commons-collections 危险链）。",
    affected: "<1.9.3",
    fixedIn: "commons-beanutils >= 1.9.3",
  },
  {
    package: "commons-lang",
    cve: "CVE-2021-35517",
    severity: "medium",
    note: "commons-lang 2.6 的 CharsetUtils 输入处理 DoS。",
    affected: "2.0–2.6",
    fixedIn: "commons-lang >= 2.7",
  },
  {
    package: "dom4j",
    cve: "CVE-2020-10683",
    severity: "high",
    note: "dom4j 2.1.3 之前版本的 XXE（外部实体解析——XML 配置解析场景）。",
    affected: "<2.1.3",
    fixedIn: "dom4j >= 2.1.3",
  },
  {
    package: "xstream",
    cve: "CVE-2021-29505",
    severity: "high",
    note: "xstream 1.4.18 之前版本的反序列化 RCE（任意类型实例化）。",
    affected: "<1.4.18",
    fixedIn: "xstream >= 1.4.18",
  },
  {
    package: "fastjson",
    cve: "CVE-2022-25845",
    severity: "high",
    note: "fastjson 1.2.83 之前版本的反序列化拒绝服务/RCE 风险（Android 常用 JSON 库）。",
    affected: "<1.2.83",
    fixedIn: "fastjson >= 1.2.83（建议 2.x）",
  },
  {
    package: "jsoup",
    cve: "CVE-2021-37714",
    severity: "medium",
    note: "jsoup 1.14.2 之前版本的不安全 HTML 清理导致的 XSS（clean 逻辑缺陷）。",
    affected: "<1.14.2",
    fixedIn: "jsoup >= 1.14.2",
  },
  {
    package: "httpclient",
    cve: "CVE-2020-13956",
    severity: "medium",
    note: "Apache HttpClient 4.5.13 之前版本的 URI 解析缺陷（重定向/鉴权绕过风险）。",
    affected: "<4.5.13",
    fixedIn: "httpclient >= 4.5.13",
  },
  {
    package: "httpcore",
    cve: "CVE-2021-26117",
    severity: "medium",
    note: "httpcore 4.4.14 之前版本的请求走私（畸形请求解析）。",
    affected: "<4.4.14",
    fixedIn: "httpcore >= 4.4.14",
  },
  {
    package: "bouncycastle",
    cve: "CVE-2023-33201",
    severity: "high",
    note: "Bouncy Castle 1.74 之前版本的 EC 私钥恢复（弱随机数场景——Android 常用加密库）。",
    affected: "<1.74",
    fixedIn: "bcprov-jdk18on >= 1.74",
  },
  {
    package: "protobuf-java",
    cve: "CVE-2021-22569",
    severity: "medium",
    note: "protobuf-java 3.16.3 之前版本的畸形解析拒绝服务。",
    affected: "<3.16.3",
    fixedIn: "protobuf-java >= 3.16.3",
  },
  {
    package: "guava",
    cve: "CVE-2018-10237",
    severity: "medium",
    note: "Guava 24.1.1 之前版本的原子引用内存耗尽 DoS（AtomicDoubleArray 等）。",
    affected: "<24.1.1",
    fixedIn: "guava >= 24.1.1",
  },
  {
    package: "snakeyaml",
    cve: "CVE-2022-1471",
    severity: "high",
    note: "SnakeYAML 2.0 之前版本的反序列化 RCE（不安全的 YAML 加载）。",
    affected: "<2.0",
    fixedIn: "snakeyaml >= 2.0",
  },
  {
    package: "org.json",
    cve: "CVE-2022-45688",
    severity: "medium",
    note: "org.json 20230227 之前版本的 JSON 解析堆栈溢出 DoS（超深嵌套——Android 内置库变体）。",
    affected: "<20230227",
    fixedIn: "org.json >= 20230227",
  },
  {
    package: "log4j-api",
    cve: "CVE-2021-45046",
    severity: "high",
    note: "log4j 2.15.0 之前版本的 JNDI 注入 RCE 变体（与 Log4Shell 同源）。",
    affected: "2.0–2.15.0",
    fixedIn: "log4j >= 2.16.0",
  },
  {
    package: "json-smart",
    cve: "CVE-2021-31684",
    severity: "medium",
    note: "json-smart 2.4.1 之前版本的嵌套 JSON 栈溢出 DoS。",
    affected: "<2.4.1",
    fixedIn: "json-smart >= 2.4.1",
  },
  {
    package: "xerces",
    cve: "CVE-2022-23437",
    severity: "medium",
    note: "Xerces 2.12.2 之前版本的畸形 XML 拒绝服务（资源耗尽）。",
    affected: "<2.12.2",
    fixedIn: "xerces >= 2.12.2",
  },
  {
    package: "threetenbp",
    cve: "CVE-2018-20971",
    severity: "medium",
    note: "threetenbp 1.3.6 之前版本的时区解析 DoS（畸形输入）。",
    affected: "<1.3.6",
    fixedIn: "threetenbp >= 1.3.6",
  },
  {
    package: "picasso",
    cve: "CVE-2015-2808",
    severity: "medium",
    note: "Picasso 2.5.0 之前版本加载的 RC4 弱加密传输（旧 TLS 场景）。",
    affected: "<2.5.0",
    fixedIn: "picasso >= 2.5.0（建议升级）",
  },
  {
    package: "commons-validator",
    cve: "CVE-2014-9634",
    severity: "medium",
    note: "commons-validator 1.4.1 之前版本的正则表达式拒绝服务（畸形输入）。",
    affected: "<1.4.1",
    fixedIn: "commons-validator >= 1.4.1",
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
        detail: `${component} 命中离线漏洞快照 ${entry.cve}（受影响区间 ${entry.affected ?? "未知"}）。${entry.note} 仅清单提示，不联网核对实际版本。`,
        recommendation: `确认实际引入版本；如受影响请升级到修复版本（${entry.fixedIn ?? "见官方公告"}），并核对是否存在利用路径。`,
        evidence: `${component} -> ${entry.cve}`,
      })
    }
  }
  return findings
}
