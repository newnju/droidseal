// summary 指标背书一致性门禁(如实降级原则的机械化执行)。
// 原则:summary 里任何"已保护/已接线"指标为 true,必须有对应代码路径证据;
// 证据缺失 → fail-closed 强制改报 false,并产出 not-wired finding,绝不虚报为防护。

export interface ProtectedClaim {
  /** summary 指标名(如 dexProtected) */
  key: string
  /** 代码路径背书:只有真实执行过的产物证据才算数(如加密条目数、写回标志) */
  evidenceCount: number
  /** 用户配置开关值(仅供参考,不作为背书) */
  configEnabled: boolean
}

export interface GateViolation {
  key: string
  reason: "no-evidence"
}

export interface GateResult {
  /** 修正后的指标映射(key → 是否真有背书) */
  effective: Record<string, boolean>
  violations: GateViolation[]
}

/**
 * 对每个声明做一致性校验:
 * - configEnabled=false → 一律 false(用户未启用,与背书无关)
 * - configEnabled=true 且 evidenceCount>0 → true(有代码路径背书)
 * - configEnabled=true 且 evidenceCount=0 → false + violation(开关开着但没实际生效——如实降级)
 */
export function gateSummaryClaims(claims: ProtectedClaim[]): GateResult {
  const effective: Record<string, boolean> = {}
  const violations: GateViolation[] = []
  for (const c of claims) {
    if (!c.configEnabled || c.evidenceCount <= 0) {
      effective[c.key] = false
      if (c.configEnabled && c.evidenceCount <= 0) {
        violations.push({ key: c.key, reason: "no-evidence" })
      }
    } else {
      effective[c.key] = true
    }
  }
  return { effective, violations }
}
