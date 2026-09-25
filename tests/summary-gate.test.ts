// summary-gate 单测:如实降级原则的机械化执行(无背书即 fail-closed 报 false)
import { describe, test, expect } from "bun:test"
import { gateSummaryClaims, type ProtectedClaim } from "../src/core/summary-gate.ts"

describe("gateSummaryClaims 指标背书一致性门禁", () => {
  test("配置开 + 有证据 → true(正常防护)", () => {
    const r = gateSummaryClaims([{ key: "dexProtected", configEnabled: true, evidenceCount: 3 }])
    expect(r.effective.dexProtected).toBe(true)
    expect(r.violations.length).toBe(0)
  })

  test("配置开 + 零证据 → false + violation(fail-closed,不虚报)", () => {
    const r = gateSummaryClaims([{ key: "soProtected", configEnabled: true, evidenceCount: 0 }])
    expect(r.effective.soProtected).toBe(false)
    expect(r.violations).toEqual([{ key: "soProtected", reason: "no-evidence" }])
  })

  test("配置关 → 一律 false,无论证据多少,且不算 violation", () => {
    const r = gateSummaryClaims([{ key: "vmProtected", configEnabled: false, evidenceCount: 5 }])
    expect(r.effective.vmProtected).toBe(false)
    expect(r.violations.length).toBe(0)
  })

  test("混合批次:逐项独立判定,violation 只记未背书项", () => {
    const claims: ProtectedClaim[] = [
      { key: "dexProtected", configEnabled: true, evidenceCount: 2 },
      { key: "stringProtected", configEnabled: true, evidenceCount: 0 },
      { key: "resourceProtected", configEnabled: false, evidenceCount: 0 },
      { key: "runtimeProtected", configEnabled: true, evidenceCount: 1 },
    ]
    const r = gateSummaryClaims(claims)
    expect(r.effective.dexProtected).toBe(true)
    expect(r.effective.stringProtected).toBe(false)
    expect(r.effective.resourceProtected).toBe(false)
    expect(r.effective.runtimeProtected).toBe(true)
    expect(r.violations.length).toBe(1)
    expect(r.violations[0]!.key).toBe("stringProtected")
  })

  test("负证据数按零处理(防御性,不产生 true)", () => {
    const r = gateSummaryClaims([{ key: "soProtected", configEnabled: true, evidenceCount: -1 }])
    expect(r.effective.soProtected).toBe(false)
    expect(r.violations.length).toBe(1)
  })

  test("空批次 → 空结果", () => {
    const r = gateSummaryClaims([])
    expect(Object.keys(r.effective).length).toBe(0)
    expect(r.violations.length).toBe(0)
  })
})
