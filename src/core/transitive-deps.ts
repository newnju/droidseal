// 传递依赖分析（Phase 3 扩充）。
// 从 Gradle dependencies task 输出解析传递依赖树，标注直接/传递/动态版本，
// 与 OSV 查询联动，标记间接漏洞风险。纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import type { DependencyComponent } from "./dependency-vuln.ts"

export interface TransitiveDep {
  group: string
  artifact: string
  version: string
  scope: "implementation" | "api" | "compileOnly" | "runtimeOnly" | "testOnly" | "unknown"
  depth: number
  isDirect: boolean
  isDynamic: boolean // 版本含 + 或 LATEST 或 latest.release 等动态约束
  parent?: string | undefined // 被哪个组件引入
}

// ── Gradle dependencies 文本解析 ──────────────────────────────────────────

// Gradle dependencies 输出格式:
//   +--- com.example:lib:1.0.0
//   |    \--- com.example:dep:2.0.0 -> 2.1.0
//   \--- com.example:other:3.0.0 (n)
const DEP_LINE_RE = /^[\s|\\+]*[+\\]---\s+([^:]+):([^:]+):([^\s(]+)(?:\s*->\s*([^\s(]+))?(?:\s*\((\w+)\))?.*$/

export function parseGradleDependencies(text: string): TransitiveDep[] {
  const deps: TransitiveDep[] = []
  const seen = new Set<string>()
  let currentDepth = 0
  let lastDirect: string | undefined

  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.replace(/\s+$/, "")
    if (!line.trim()) continue

    // 计算深度(| 和空格的数量)
    const prefix = line.match(/^([\s|]*)/)?.[1] ?? ""
    const pipeCount = (prefix.match(/\|/g) ?? []).length
    const depth = pipeCount

    const match = DEP_LINE_RE.exec(line)
    if (!match) continue

    const group = match[1]!.trim()
    const artifact = match[2]!.trim()
    const rawVersion = match[3]!.trim()
    const resolvedVersion = match[4]?.trim()
    const scopeHint = match[5]?.trim()

    const version = resolvedVersion ?? rawVersion
    const key = `${group}:${artifact}:${version}`
    if (seen.has(key)) continue
    seen.add(key)

    const isDynamic = /\+$|LATEST$|latest\.release$/i.test(rawVersion) || rawVersion.includes("[") || rawVersion.includes("(")
    const scope = mapScope(scopeHint)

    if (depth === 0) lastDirect = `${group}:${artifact}`

    if (!group || !artifact) continue
    deps.push({
      group,
      artifact,
      version: version ?? "",
      scope,
      depth,
      isDirect: depth === 0,
      isDynamic,
      parent: depth > 0 ? lastDirect : undefined,
    })
  }
  return deps
}

function mapScope(hint: string | undefined): TransitiveDep["scope"] {
  if (!hint) return "unknown"
  const lower = hint.toLowerCase()
  if (lower.includes("compile") || lower.includes("implementation")) return "implementation"
  if (lower.includes("api")) return "api"
  if (lower.includes("runtime")) return "runtimeOnly"
  if (lower.includes("compileonly")) return "compileOnly"
  if (lower.includes("test")) return "testOnly"
  return "unknown"
}

// ── POM 依赖提取(从 AAR/JAR 内 pom.xml) ──────────────────────────────────

export function parsePomDependencies(pomXml: string): Array<{ group: string; artifact: string; version?: string; scope?: string }> {
  const deps: Array<{ group: string; artifact: string; version?: string; scope?: string }> = []
  // 简易 XML 解析:提取 <dependency> 块
  const depBlocks = pomXml.split(/<\/dependency>/i)
  for (const block of depBlocks) {
    const groupId = /<groupId>([^<]+)<\/groupId>/i.exec(block)?.[1]?.trim()
    const artifactId = /<artifactId>([^<]+)<\/artifactId>/i.exec(block)?.[1]?.trim()
    const version = /<version>([^<]+)<\/version>/i.exec(block)?.[1]?.trim()
    const scope = /<scope>([^<]+)<\/scope>/i.exec(block)?.[1]?.trim()
    if (groupId && artifactId) {
      deps.push({ group: groupId, artifact: artifactId, version: version ?? "", scope: scope ?? "" })
    }
  }
  return deps
}

// ── 动态版本约束检测 ──────────────────────────────────────────────────────

export function detectDynamicVersions(deps: TransitiveDep[]): TransitiveDep[] {
  return deps.filter((d) => d.isDynamic)
}

// ── 风险评估 ──────────────────────────────────────────────────────────────

export interface TransitiveRisk {
  dep: TransitiveDep
  risk: "dynamic-version" | "deep-transitive" | "scope-escalation" | "unknown-parent"
  detail: string
}

export function assessTransitiveRisks(deps: TransitiveDep[]): TransitiveRisk[] {
  const risks: TransitiveRisk[] = []
  for (const dep of deps) {
    if (dep.isDynamic) {
      risks.push({
        dep,
        risk: "dynamic-version",
        detail: `${dep.group}:${dep.artifact}@${dep.version} 使用动态版本约束——构建不可复现，可能引入未知漏洞版本。`,
      })
    }
    if (dep.depth >= 3) {
      risks.push({
        dep,
        risk: "deep-transitive",
        detail: `${dep.group}:${dep.artifact}@${dep.version} 传递深度 ${dep.depth}——深层传递依赖难以审计，可能引入意外许可证/漏洞。`,
      })
    }
    if (dep.scope === "runtimeOnly" && dep.isDirect) {
      risks.push({
        dep,
        risk: "scope-escalation",
        detail: `${dep.group}:${dep.artifact}@${dep.version} 标记为 runtimeOnly——编译期不可见但运行时存在，审计时易遗漏。`,
      })
    }
  }
  return risks
}

// ── 转换为 DependencyComponent(供 OSV 查询) ──────────────────────────────

export function toDependencyComponents(deps: TransitiveDep[]): DependencyComponent[] {
  return deps.map((d) => ({
    group: d.group,
    artifact: d.artifact,
    version: d.version,
    scope: d.scope,
    depth: d.depth,
  }))
}

// ── Finding 生成 ──────────────────────────────────────────────────────────

export function buildTransitiveDepFindings(deps: TransitiveDep[], risks: TransitiveRisk[]): Finding[] {
  const findings: Finding[] = []

  // 1. 传递依赖统计
  const directCount = deps.filter((d) => d.isDirect).length
  const transitiveCount = deps.filter((d) => !d.isDirect).length
  if (transitiveCount > 0) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "TRANSITIVE_DEP_SUMMARY",
      title: `依赖树: ${directCount} 个直接依赖 + ${transitiveCount} 个传递依赖`,
      detail: `共 ${deps.length} 个组件;最大传递深度 ${Math.max(...deps.map((d) => d.depth), 0)} 层。`,
      recommendation: "传递依赖应纳入 SBOM 和漏洞扫描;深层依赖需关注许可证兼容性。",
      evidence: deps.filter((d) => !d.isDirect).slice(0, 10).map((d) => `${d.group}:${d.artifact}@${d.version}`).join(", "),
    })
  }

  // 2. 动态版本风险
  const dynamicDeps = deps.filter((d) => d.isDynamic)
  if (dynamicDeps.length > 0) {
    findings.push({
      severity: "medium",
      confidence: "high",
      code: "TRANSITIVE_DYNAMIC_VERSION",
      title: `${dynamicDeps.length} 个依赖使用动态版本约束`,
      detail: `动态版本(如 1.+、LATEST)使构建不可复现: ${dynamicDeps.slice(0, 5).map((d) => `${d.group}:${d.artifact}@${d.version}`).join(", ")}。`,
      recommendation: "锁定精确版本(如 1.2.3);动态版本在 CI/CD 中应禁止。",
      evidence: dynamicDeps.map((d) => `${d.group}:${d.artifact}@${d.version}`).join(", "),
    })
  }

  // 3. 深层传递依赖风险
  for (const risk of risks.filter((r) => r.risk === "deep-transitive")) {
    findings.push({
      severity: "low",
      confidence: "medium",
      code: "TRANSITIVE_DEEP",
      title: `深层传递依赖: ${risk.dep.group}:${risk.dep.artifact}`,
      detail: risk.detail,
      recommendation: "审计深层传递依赖的许可证与漏洞;考虑直接声明为顶层依赖以锁定版本。",
      evidence: `${risk.dep.group}:${risk.dep.artifact}@${risk.dep.version} depth=${risk.dep.depth} parent=${risk.dep.parent ?? "?"}`,
    })
  }

  return findings
}
