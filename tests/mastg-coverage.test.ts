// P4 单测:MASTG 全集对照表(三态口径 + findings 命中判定)
import { describe, test, expect } from "bun:test"
import {
  MASTG_COVERAGE,
  mastgCoverageSummary,
  mastgCoverageWithFindings,
  mastgCoverageStateLabel,
} from "../src/core/mastg-coverage.ts"

describe("MASTG 全集对照", () => {
  test("全集表:域齐全、三态取值合法、static/heuristic 必带关联 code", () => {
    const domains = new Set(MASTG_COVERAGE.map((t) => t.domain))
    // MASTG v1 的核心静态域全覆盖
    for (const d of ["STORAGE", "CRYPTO", "NETWORK", "PLATFORM", "CODE", "RESILIENCE", "PRIVACY"]) {
      expect(domains.has(d)).toBe(true)
    }
    for (const t of MASTG_COVERAGE) {
      expect(["static", "heuristic", "dynamic", "out-of-scope"]).toContain(t.state)
      if (t.state === "static" || t.state === "heuristic") {
        expect(t.relatedCodes.length).toBeGreaterThan(0)
      }
    }
  })

  test("汇总:分域计数与总数一致", () => {
    const s = mastgCoverageSummary()
    expect(s.total).toBe(MASTG_COVERAGE.length)
    const sumByDomain = s.byDomain.reduce((acc, d) => acc + d.total, 0)
    expect(sumByDomain).toBe(s.total)
    const sumByState = Object.values(s.byState).reduce((a, b) => a + b, 0)
    expect(sumByState).toBe(s.total)
  })

  test("findings 命中:关联 code 命中 → hit=true;dynamic/out-of-scope 恒不命中", () => {
    const covered = mastgCoverageWithFindings([{ code: "SOURCE_WEAK_CRYPTO" }])
    const weakCrypto = covered.find((t) => t.topic.includes("弱加密算法"))!
    expect(weakCrypto.hit).toBe(true)
    // 未命中主题如实 false
    const other = covered.find((t) => t.state === "static" && !t.relatedCodes.includes("SOURCE_WEAK_CRYPTO"))!
    expect(other.hit).toBe(false)
    for (const t of covered) {
      if (t.state === "dynamic" || t.state === "out-of-scope") expect(t.hit).toBe(false)
    }
  })

  test("空 findings → 全部未命中,状态标注照常输出", () => {
    const covered = mastgCoverageWithFindings([])
    expect(covered.every((t) => !t.hit)).toBe(true)
    expect(mastgCoverageStateLabel("static")).toBe("静态可查")
    expect(mastgCoverageStateLabel("heuristic")).toBe("静态启发")
    expect(mastgCoverageStateLabel("dynamic")).toBe("需动态")
    expect(mastgCoverageStateLabel("out-of-scope")).toBe("范围外")
  })
})
