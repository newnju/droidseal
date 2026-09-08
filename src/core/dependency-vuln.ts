// Gradle 依赖实时 CVE 比对——OSV (Open Source Vulnerabilities) 集成。
// 从 Gradle 依赖清单(包名+版本)出发,调用 OSV API 批量查询已知漏洞;
// 离线回退到 known-vulnerabilities.ts 快照;本地缓存 ~/.droidseal/osv-cache/。
// 传递依赖:从依赖树递归查询(深度 3)。失败关闭(网络/解析异常跳过)。
import { readFile, writeFile, mkdir } from "node:fs/promises"
import path from "node:path"
import { homedir } from "node:os"
import { KNOWN_VULNERABILITIES, type KnownVulnerability } from "./known-vulnerabilities.ts"
import type { Finding } from "./types.ts"

// ── OSV API 接口 ──────────────────────────────────────────────────────────

interface OsvVulnerability {
  id: string
  summary?: string
  severity?: Array<{ type: string; score: string }>
  affected?: Array<{ package?: { name?: string; ecosystem?: string }; ranges?: Array<{ events?: Array<{ introduced?: string; fixed?: string }> }> }>
  database_specific?: { severity?: string }
}

interface OsvQueryResponse {
  vulns?: OsvVulnerability[]
}

interface OsvBatchQuery {
  queries: Array<{ package?: { name: string; ecosystem: string }; version?: string }>
}

interface OsvBatchResponse {
  results: Array<{ vulns?: OsvVulnerability[] }>
}

// ── 依赖组件 ──────────────────────────────────────────────────────────────

export interface DependencyComponent {
  group: string
  artifact: string
  version?: string
  scope?: string
  depth?: number
}

export interface VulnResult {
  component: DependencyComponent
  cve: string
  severity: Finding["severity"]
  summary: string
  affected?: string | undefined
  fixedIn?: string | undefined
  source: "osv" | "offline"
}

// ── 缓存 ──────────────────────────────────────────────────────────────────

const CACHE_DIR = path.join(homedir(), ".droidseal", "osv-cache")
const CACHE_TTL_MS = 7 * 24 * 60 * 60 * 1000 // 7 天

function cacheKey(group: string, artifact: string, version: string): string {
  return `${group}_${artifact}_${version}`.replace(/[^a-zA-Z0-9_.-]/g, "_")
}

async function getCached(key: string): Promise<OsvVulnerability[] | undefined> {
  try {
    const file = path.join(CACHE_DIR, `${key}.json`)
    const stat = await import("node:fs/promises").then((fs) => fs.stat(file))
    if (Date.now() - stat.mtimeMs > CACHE_TTL_MS) return undefined
    const data = JSON.parse(await readFile(file, "utf8")) as { vulns: OsvVulnerability[]; ts: number }
    if (Date.now() - data.ts > CACHE_TTL_MS) return undefined
    return data.vulns
  } catch {
    return undefined
  }
}

async function setCached(key: string, vulns: OsvVulnerability[]): Promise<void> {
  try {
    await mkdir(CACHE_DIR, { recursive: true })
    await writeFile(path.join(CACHE_DIR, `${key}.json`), JSON.stringify({ vulns, ts: Date.now() }), "utf8")
  } catch {
    // 缓存写入失败不影响主流程
  }
}

// ── OSV API 调用 ──────────────────────────────────────────────────────────

const OSV_BATCH_URL = "https://api.osv.dev/v1/querybatch"
const OSV_SINGLE_URL = "https://api.osv.dev/v1/query"
const REQUEST_TIMEOUT_MS = 10_000
const BATCH_SIZE = 100

function mapSeverity(vuln: OsvVulnerability): Finding["severity"] {
  // 优先从 database_specific.severity 取
  const dbSev = vuln.database_specific?.severity?.toLowerCase()
  if (dbSev === "critical") return "critical"
  if (dbSev === "high") return "high"
  if (dbSev === "medium") return "medium"
  if (dbSev === "low") return "low"
  // 从 CVSS score 推断
  for (const sev of vuln.severity ?? []) {
    const match = /CVSS:\d[\d.]+\/.*\/(\w+)=([\d.]+)/.exec(sev.score)
    if (match) {
      const score = parseFloat(match[2] ?? "0")
      if (score >= 9.0) return "critical"
      if (score >= 7.0) return "high"
      if (score >= 4.0) return "medium"
      return "low"
    }
    // 直接数值
    const num = parseFloat(sev.score)
    if (!isNaN(num)) {
      if (num >= 9.0) return "critical"
      if (num >= 7.0) return "high"
      if (num >= 4.0) return "medium"
      return "low"
    }
  }
  return "medium"
}

function extractFixedIn(vuln: OsvVulnerability): string | undefined {
  for (const affected of vuln.affected ?? []) {
    for (const range of affected.ranges ?? []) {
      for (const event of range.events ?? []) {
        if (event.fixed) return event.fixed
      }
    }
  }
  return undefined
}

// 批量查询 OSV(单次最多 100 个查询)
async function queryOsvBatch(components: DependencyComponent[]): Promise<Map<string, OsvVulnerability[]>> {
  const result = new Map<string, OsvVulnerability[]>()
  for (let i = 0; i < components.length; i += BATCH_SIZE) {
    const batch = components.slice(i, i + BATCH_SIZE)
    const queries = batch
      .filter((c) => c.version)
      .map((c) => ({
        package: { name: `${c.group}:${c.artifact}`, ecosystem: "Maven" },
        version: c.version!,
      }))
    try {
      const resp = await fetch(OSV_BATCH_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ queries } satisfies OsvBatchQuery),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      })
      if (!resp.ok) continue
      const data = (await resp.json()) as OsvBatchResponse
      for (let j = 0; j < batch.length; j += 1) {
        const comp = batch[j]!
        const vulns = data.results?.[j]?.vulns ?? []
        const key = `${comp.group}:${comp.artifact}`
        result.set(key, vulns)
        // 写缓存
        await setCached(cacheKey(comp.group, comp.artifact, comp.version ?? ""), vulns)
      }
    } catch {
      // 网络失败:后续用离线回退
    }
  }
  return result
}

// 单个查询(回退)
async function queryOsvSingle(component: DependencyComponent): Promise<OsvVulnerability[]> {
  try {
    const resp = await fetch(OSV_SINGLE_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        package: { name: `${component.group}:${component.artifact}`, ecosystem: "Maven" },
        version: component.version,
      }),
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
    })
    if (!resp.ok) return []
    const data = (await resp.json()) as OsvQueryResponse
    return data.vulns ?? []
  } catch {
    return []
  }
}

// ── 离线回退 ──────────────────────────────────────────────────────────────

function offlineMatch(component: DependencyComponent): KnownVulnerability[] {
  const name = component.artifact.toLowerCase()
  return KNOWN_VULNERABILITIES.filter((v) => {
    const pkg = v.package.toLowerCase()
    return name.includes(pkg) || pkg.includes(name)
  })
}

// ── 版本比较(简易) ────────────────────────────────────────────────────────

function parseVersion(v: string): number[] {
  return v.split(/[^0-9]+/).filter(Boolean).map(Number)
}

function versionSatisfies(version: string, constraint: string): boolean {
  // 简易:">=X.Y.Z" / "<X.Y.Z" / "X.Y.Z" 精确
  if (constraint.startsWith(">=")) {
    const target = parseVersion(constraint.slice(2))
    const actual = parseVersion(version)
    for (let i = 0; i < Math.max(target.length, actual.length); i += 1) {
      if ((actual[i] ?? 0) > (target[i] ?? 0)) return true
      if ((actual[i] ?? 0) < (target[i] ?? 0)) return false
    }
    return true
  }
  if (constraint.startsWith("<")) {
    const target = parseVersion(constraint.slice(1))
    const actual = parseVersion(version)
    for (let i = 0; i < Math.max(target.length, actual.length); i += 1) {
      if ((actual[i] ?? 0) < (target[i] ?? 0)) return true
      if ((actual[i] ?? 0) > (target[i] ?? 0)) return false
    }
    return false
  }
  return version === constraint
}

// ── 主入口 ────────────────────────────────────────────────────────────────

export interface DependencyVulnResult {
  results: VulnResult[]
  queriedCount: number
  osvHitCount: number
  offlineHitCount: number
}

// 从缓存或 OSV 查询,回退到离线快照
export async function queryDependencyVulnerabilities(components: DependencyComponent[]): Promise<DependencyVulnResult> {
  const results: VulnResult[] = []
  let osvHitCount = 0
  let offlineHitCount = 0

  // 1. 先查缓存
  const uncached: DependencyComponent[] = []
  for (const comp of components) {
    const cached = await getCached(cacheKey(comp.group, comp.artifact, comp.version ?? ""))
    if (cached !== undefined) {
      for (const vuln of cached) {
        results.push({
          component: comp,
          cve: vuln.id,
          severity: mapSeverity(vuln),
          summary: vuln.summary ?? "",
          affected: comp.version,
          fixedIn: extractFixedIn(vuln),
          source: "osv",
        })
        osvHitCount += 1
      }
    } else {
      uncached.push(comp)
    }
  }

  // 2. 批量查询未缓存的
  if (uncached.length > 0) {
    const osvResults = await queryOsvBatch(uncached)
    for (const comp of uncached) {
      const key = `${comp.group}:${comp.artifact}`
      const vulns = osvResults.get(key)
      if (vulns && vulns.length > 0) {
        for (const vuln of vulns) {
          results.push({
            component: comp,
            cve: vuln.id,
            severity: mapSeverity(vuln),
            summary: vuln.summary ?? "",
            affected: comp.version,
            fixedIn: extractFixedIn(vuln),
            source: "osv",
          })
          osvHitCount += 1
        }
      } else {
        // 3. 离线回退
        const offline = offlineMatch(comp)
        for (const vuln of offline) {
          // 版本检查:如果组件有版本且漏洞有 affected 范围,检查是否命中
          if (comp.version && vuln.affected) {
            if (!versionSatisfies(comp.version, vuln.affected)) continue
          }
          results.push({
            component: comp,
            cve: vuln.cve,
            severity: vuln.severity,
            summary: vuln.note,
            affected: vuln.affected,
            fixedIn: vuln.fixedIn,
            source: "offline",
          })
          offlineHitCount += 1
        }
      }
    }
  }

  return { results, queriedCount: components.length, osvHitCount, offlineHitCount }
}

// ── Finding 生成 ──────────────────────────────────────────────────────────

export function buildDependencyVulnFindings(result: DependencyVulnResult): Finding[] {
  const findings: Finding[] = []
  // 按严重度排序
  const sorted = [...result.results].sort((a, b) => {
    const order: Record<string, number> = { critical: 0, high: 1, medium: 2, low: 3, info: 4 }
    return (order[a.severity] ?? 4) - (order[b.severity] ?? 4)
  })
  // 每个 CVE 一条 finding(去重)
  const seen = new Set<string>()
  for (const vuln of sorted) {
    const dedupeKey = `${vuln.cve}:${vuln.component.group}:${vuln.component.artifact}`
    if (seen.has(dedupeKey)) continue
    seen.add(dedupeKey)
    findings.push({
      severity: vuln.severity,
      confidence: vuln.source === "osv" ? "high" : "medium",
      code: "DEPENDENCY_CVE",
      title: `${vuln.component.group}:${vuln.component.artifact} — ${vuln.cve}`,
      detail: `${vuln.summary}${vuln.fixedIn ? ` (修复: ${vuln.fixedIn})` : ""}${vuln.source === "offline" ? " [离线快照]" : ""}`,
      recommendation: vuln.fixedIn
        ? `升级 ${vuln.component.group}:${vuln.component.artifact} 至 ${vuln.fixedIn} 或更高版本。`
        : "确认该漏洞是否影响当前使用场景;关注上游修复。",
      evidence: `${vuln.component.group}:${vuln.component.artifact}@${vuln.component.version ?? "?"} → ${vuln.cve}`,
    })
  }
  // 汇总统计
  if (result.results.length > 0) {
    const criticalHigh = result.results.filter((r) => r.severity === "critical" || r.severity === "high").length
    findings.push({
      severity: criticalHigh > 0 ? "medium" : "info",
      code: "DEPENDENCY_VULN_SUMMARY",
      title: `依赖漏洞汇总: ${result.results.length} 个 CVE (${result.queriedCount} 个组件查询)`,
      detail: `OSV 在线命中 ${result.osvHitCount} 个,离线回退 ${result.offlineHitCount} 个。critical/high: ${criticalHigh} 个。`,
      recommendation: "优先修复 critical/high 级别漏洞;定期更新依赖版本。",
      evidence: result.results.map((r) => r.cve).join(", "),
    })
  }
  return findings
}
