// URL/域名/端点提取（下一阶段短期①——apkleaks 式）。
// 从 DEX 字符串池 / 源码字符串提取 http(s) URL、域名与路径端点——清单级输出，不联网。
// 失败关闭：提取结果去重排序并有界（避免噪音）；未命中即空清单。
import type { Finding } from "./types.ts"

export interface ExtractedEndpoint {
  url?: string
  host: string
  path?: string
}

const URL_RE = /https?:\/\/[a-zA-Z0-9._~:/?#[\]@!$&'()*+,;=%-]+/g
// 域名（含端口）或 域名/路径：排除 IP 与明显非端点形态
const DOMAIN_RE = /(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?::\d{2,5})?(?:\/[a-zA-Z0-9._~/-]*)?/g

const BLOCKED_HOSTS = new Set([
  "schemas.android.com",
  "developer.android.com",
  "www.google.com",
  "android.com",
  "example.com",
  "w3.org",
  "www.w3.org",
  "apache.org",
  "github.com",
])

function normalizeUrl(raw: string): string {
  return raw.replace(/[)\]},;]+$/, "").trim()
}

export function extractEndpoints(strings: Iterable<string>): ExtractedEndpoint[] {
  const seen = new Set<string>()
  const out: ExtractedEndpoint[] = []
  const MAX = 80
  for (const s of strings) {
    for (const match of s.matchAll(URL_RE)) {
      const url = normalizeUrl(match[0])
      if (seen.has(url)) continue
      seen.add(url)
      const parsed = new URL(url)
      if (BLOCKED_HOSTS.has(parsed.hostname)) continue
      const path = parsed.pathname !== "/" ? parsed.pathname : undefined
      out.push({ url, host: parsed.hostname, ...(path ? { path } : {}) })
      if (out.length >= MAX) return out
    }
    for (const match of s.matchAll(DOMAIN_RE)) {
      const raw = match[0]
      if (seen.has(raw)) continue
      seen.add(raw)
      const slash = raw.indexOf("/")
      const host = slash > 0 ? raw.slice(0, slash) : raw
      if (BLOCKED_HOSTS.has(host.split(":")[0]!)) continue
      if (host.startsWith("www.") && !raw.includes("/")) continue // 裸 www 域名噪音
      const path = slash > 0 ? raw.slice(slash) : undefined
      out.push({ host, ...(path ? { path } : {}) })
      if (out.length >= MAX) return out
    }
  }
  return out.sort((a, b) => (a.url ?? a.host).localeCompare(b.url ?? b.host))
}

// 提取结果转 finding（info 级清单提示——供人工核验/端点管理，失败关闭）。
export function buildEndpointFindings(strings: Iterable<string>): Finding[] {
  const endpoints = extractEndpoints(strings)
  if (endpoints.length === 0) return []
  const samples = endpoints.slice(0, 10).map((e) => (e.url ?? e.host) + (e.path ?? "")).join("、")
  return [
    {
      severity: "info",
      code: "ENDPOINT_INVENTORY",
      title: `从 DEX 字符串池提取到 ${endpoints.length} 个端点（URL/域名/路径）`,
      detail: `清单级提取（去重排序，不联网）：${samples}${endpoints.length > 10 ? "…" : ""}。供端点管理与攻击面人工核验。`,
      recommendation: "核对端点清单；内部/测试端点不应出现在发布包，敏感端点建议服务端化或加密。",
      evidence: endpoints.slice(0, 5).map((e) => e.url ?? e.host).join(", "),
    },
  ]
}
