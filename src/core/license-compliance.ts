// 许可证合规冲突检测（Phase 3 扩充）。
// 从 SBOM 组件清单提取许可证信息，检测冲突规则（GPL vs Apache、AGPL vs 商业等），
// 标注 copyleft 传染性风险。纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

export interface LicenseComponent {
  name: string
  license?: string | undefined
  source?: string | undefined // "gradle" | "pom" | "sbom" | "declared"
}

// ── 许可证分类 ──────────────────────────────────────────────────────────

type LicenseCategory = "permissive" | "weak-copyleft" | "strong-copyleft" | "unknown" | "commercial"

interface LicenseInfo {
  id: string
  category: LicenseCategory
  fullName: string
  copyleft: boolean
  commercialUse: boolean
  patentGrant: boolean
  noticeRequired: boolean
  sourceRequired: boolean // 分发时需提供源码
}

const LICENSE_DB: readonly LicenseInfo[] = [
  { id: "Apache-2.0", category: "permissive", fullName: "Apache License 2.0", copyleft: false, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: false },
  { id: "MIT", category: "permissive", fullName: "MIT License", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: false },
  { id: "BSD-2-Clause", category: "permissive", fullName: "BSD 2-Clause", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: false },
  { id: "BSD-3-Clause", category: "permissive", fullName: "BSD 3-Clause", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: false },
  { id: "ISC", category: "permissive", fullName: "ISC License", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: false },
  { id: "0BSD", category: "permissive", fullName: "Zero-Clause BSD", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: false, sourceRequired: false },
  { id: "Unlicense", category: "permissive", fullName: "The Unlicense", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: false, sourceRequired: false },
  { id: "CC0-1.0", category: "permissive", fullName: "CC0 1.0 Universal", copyleft: false, commercialUse: true, patentGrant: false, noticeRequired: false, sourceRequired: false },
  { id: "LGPL-2.1", category: "weak-copyleft", fullName: "LGPL 2.1", copyleft: true, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: true },
  { id: "LGPL-3.0", category: "weak-copyleft", fullName: "LGPL 3.0", copyleft: true, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: true },
  { id: "MPL-2.0", category: "weak-copyleft", fullName: "Mozilla Public License 2.0", copyleft: true, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: true },
  { id: "EPL-1.0", category: "weak-copyleft", fullName: "Eclipse Public License 1.0", copyleft: true, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: true },
  { id: "EPL-2.0", category: "weak-copyleft", fullName: "Eclipse Public License 2.0", copyleft: true, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: true },
  { id: "GPL-2.0", category: "strong-copyleft", fullName: "GNU GPL 2.0", copyleft: true, commercialUse: true, patentGrant: false, noticeRequired: true, sourceRequired: true },
  { id: "GPL-3.0", category: "strong-copyleft", fullName: "GNU GPL 3.0", copyleft: true, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: true },
  { id: "AGPL-3.0", category: "strong-copyleft", fullName: "GNU AGPL 3.0", copyleft: true, commercialUse: true, patentGrant: true, noticeRequired: true, sourceRequired: true },
]

// 许可证字符串模糊匹配
export function identifyLicense(raw: string): LicenseInfo | undefined {
  const normalized = raw.trim().toUpperCase().replace(/[\s_-]+/g, "-").replace(/-OR-LATER$/, "").replace(/-ONLY$/, "")
  // 精确匹配
  for (const lic of LICENSE_DB) {
    if (normalized === lic.id.toUpperCase() || normalized.includes(lic.id.toUpperCase())) return lic
  }
  // 模糊匹配
  if (/GPL.*2/.test(normalized) && !/3/.test(normalized)) return LICENSE_DB.find((l) => l.id === "GPL-2.0")
  if (/GPL.*3/.test(normalized)) return LICENSE_DB.find((l) => l.id === "GPL-3.0")
  if (/AGPL/.test(normalized)) return LICENSE_DB.find((l) => l.id === "AGPL-3.0")
  if (/LGPL.*2/.test(normalized)) return LICENSE_DB.find((l) => l.id === "LGPL-2.1")
  if (/LGPL.*3/.test(normalized)) return LICENSE_DB.find((l) => l.id === "LGPL-3.0")
  if (/MIT/.test(normalized)) return LICENSE_DB.find((l) => l.id === "MIT")
  if (/APACHE/.test(normalized)) return LICENSE_DB.find((l) => l.id === "Apache-2.0")
  if (/BSD.*2/.test(normalized)) return LICENSE_DB.find((l) => l.id === "BSD-2-Clause")
  if (/BSD.*3/.test(normalized)) return LICENSE_DB.find((l) => l.id === "BSD-3-Clause")
  if (/MPL/.test(normalized)) return LICENSE_DB.find((l) => l.id === "MPL-2.0")
  return undefined
}

// ── 冲突规则 ──────────────────────────────────────────────────────────────

interface ConflictRule {
  id: string
  licenseA: LicenseCategory
  licenseB: LicenseCategory
  severity: Finding["severity"]
  title: string
  detail: string
}

const CONFLICT_RULES: readonly ConflictRule[] = [
  {
    id: "GPL_VS_PERMISSIVE",
    licenseA: "strong-copyleft",
    licenseB: "permissive",
    severity: "high",
    title: "强 Copyleft 与宽松许可证共存（传染性风险）",
    detail: "GPL/AGPL 组件与 Apache/MIT 组件共存时，整个衍生作品必须以 GPL 发布——宽松许可证的代码被「传染」。",
  },
  {
    id: "AGPL_VS_COMMERCIAL",
    licenseA: "strong-copyleft",
    licenseB: "commercial",
    severity: "critical",
    title: "AGPL 与商业使用冲突（网络传染）",
    detail: "AGPL 要求通过网络提供服务时也必须公开源码——SaaS 商业模式可能违反。",
  },
  {
    id: "GPL_VS_LGPL_LINKING",
    licenseA: "strong-copyleft",
    licenseB: "weak-copyleft",
    severity: "medium",
    title: "GPL 与 LGPL 共存（链接方式冲突）",
    detail: "GPL 组件与 LGPL 组件静态链接时，LGPL 部分也被 GPL 传染——需确认链接方式。",
  },
  {
    id: "INCOMPATIBLE_COPYLEFT",
    licenseA: "weak-copyleft",
    licenseB: "weak-copyleft",
    severity: "medium",
    title: "不同弱 Copyleft 许可证可能不兼容",
    detail: "LGPL、MPL、EPL 之间可能存在条款不兼容——需逐一核对。",
  },
  {
    id: "NO_LICENSE",
    licenseA: "unknown",
    licenseB: "unknown",
    severity: "high",
    title: "组件缺少许可证声明",
    detail: "无许可证的组件存在法律风险——默认保留版权，不可使用/分发。",
  },
]

// ── 分析 ──────────────────────────────────────────────────────────────────

export interface LicenseAnalysis {
  components: LicenseComponent[]
  identified: Array<{ component: LicenseComponent; info: LicenseInfo }>
  unidentified: LicenseComponent[]
  conflicts: Array<{ rule: ConflictRule; componentA: LicenseComponent; componentB: LicenseComponent }>
  copyleftComponents: LicenseComponent[]
  noticeRequired: LicenseComponent[]
}

export function analyzeLicenses(components: LicenseComponent[]): LicenseAnalysis {
  const identified: LicenseAnalysis["identified"] = []
  const unidentified: LicenseComponent[] = []

  for (const comp of components) {
    if (!comp.license) {
      unidentified.push(comp)
      continue
    }
    const info = identifyLicense(comp.license)
    if (info) {
      identified.push({ component: comp, info })
    } else {
      unidentified.push(comp)
    }
  }

  // 冲突检测:两两比较
  const conflicts: LicenseAnalysis["conflicts"] = []
  const allWithLicense = identified
  for (let i = 0; i < allWithLicense.length; i += 1) {
    for (let j = i + 1; j < allWithLicense.length; j += 1) {
      const a = allWithLicense[i]!
      const b = allWithLicense[j]!
      for (const rule of CONFLICT_RULES) {
        if ((a.info.category === rule.licenseA && b.info.category === rule.licenseB) ||
            (a.info.category === rule.licenseB && b.info.category === rule.licenseA)) {
          conflicts.push({ rule, componentA: a.component, componentB: b.component })
        }
      }
    }
  }

  // 无许可证组件冲突
  if (unidentified.length > 0) {
    const noLicenseRule = CONFLICT_RULES.find((r) => r.id === "NO_LICENSE")!
    for (const comp of unidentified) {
      // 每个无许可证组件与第一个已识别组件标记冲突
      if (identified.length > 0) {
        conflicts.push({ rule: noLicenseRule, componentA: comp, componentB: identified[0]!.component })
      }
    }
  }

  const copyleftComponents = identified.filter((i) => i.info.copyleft).map((i) => i.component)
  const noticeRequired = identified.filter((i) => i.info.noticeRequired).map((i) => i.component)

  return { components, identified, unidentified, conflicts, copyleftComponents, noticeRequired }
}

// ── Finding 生成 ──────────────────────────────────────────────────────────

export function buildLicenseFindings(analysis: LicenseAnalysis): Finding[] {
  const findings: Finding[] = []

  // 1. 许可证统计
  const byCategory: Record<string, number> = {}
  for (const { info } of analysis.identified) {
    byCategory[info.category] = (byCategory[info.category] ?? 0) + 1
  }
  findings.push({
    severity: "info",
    confidence: "high",
    code: "LICENSE_SUMMARY",
    title: `许可证分布: ${analysis.identified.length} 个已识别, ${analysis.unidentified.length} 个未识别`,
    detail: Object.entries(byCategory).map(([cat, count]) => `${cat}: ${count}`).join("; "),
    recommendation: "所有组件应有明确许可证;未识别的组件需人工确认。",
    evidence: analysis.identified.map((i) => `${i.component.name}=${i.info.id}`).join(", "),
  })

  // 2. 冲突
  const seen = new Set<string>()
  for (const conflict of analysis.conflicts) {
    const dedupeKey = `${conflict.rule.id}:${conflict.componentA.name}:${conflict.componentB.name}`
    if (seen.has(dedupeKey)) continue
    seen.add(dedupeKey)
    findings.push({
      severity: conflict.rule.severity,
      confidence: "medium",
      code: "LICENSE_CONFLICT",
      title: conflict.rule.title,
      detail: `${conflict.rule.detail} 涉及: ${conflict.componentA.name}(${conflict.componentA.license ?? "?"}) 与 ${conflict.componentB.name}(${conflict.componentB.license ?? "?"})。`,
      recommendation: "确认许可证兼容性;必要时替换为兼容组件或获取商业授权。",
      evidence: `${conflict.componentA.name}(${conflict.componentA.license}) vs ${conflict.componentB.name}(${conflict.componentB.license})`,
    })
  }

  // 3. Copyleft 传染性
  if (analysis.copyleftComponents.length > 0) {
    findings.push({
      severity: "medium",
      confidence: "high",
      code: "LICENSE_COPYLEFT",
      title: `${analysis.copyleftComponents.length} 个 Copyleft 组件（传染性风险）`,
      detail: `Copyleft 组件要求衍生作品以相同许可证发布: ${analysis.copyleftComponents.slice(0, 5).map((c) => `${c.name}(${c.license})`).join(", ")}。`,
      recommendation: "确认项目许可证与 Copyleft 组件兼容;商业项目需特别关注 GPL/AGPL 传染性。",
      evidence: analysis.copyleftComponents.map((c) => `${c.name}=${c.license}`).join(", "),
    })
  }

  // 4. Notice 要求
  if (analysis.noticeRequired.length > 0) {
    findings.push({
      severity: "low",
      confidence: "high",
      code: "LICENSE_NOTICE_REQUIRED",
      title: `${analysis.noticeRequired.length} 个组件要求保留版权声明`,
      detail: `分发时需包含这些组件的版权声明和许可证文本: ${analysis.noticeRequired.slice(0, 5).map((c) => c.name).join(", ")}。`,
      recommendation: "在应用的「关于」页面或 THIRD_PARTY_NOTICES 文件中保留所有声明。",
      evidence: analysis.noticeRequired.map((c) => c.name).join(", "),
    })
  }

  return findings
}
