// release-check 对抗审计 verdict 消费单测:不依赖完整发布产物的部分——
// 消费逻辑契约(源码断言)+ 判定方向语义(fail 阻断/skip 可配/缺失默认不阻断)。
// 门禁整链行为归 #3 真机闭环验证(本机跑 release-check 验证 verdict 路径)。
import { describe, test, expect } from "bun:test"
import { readFileSync } from "node:fs"

const SCRIPT = "scripts/release-check.ts"

describe("release-check verdict 消费(发布门禁 × 对抗审计对账)", () => {
  const src = readFileSync(SCRIPT, "utf-8")

  test("消费最新 run 的 verdicts/adversarial-audit.json", () => {
    expect(src).toContain("verdicts")
    expect(src).toContain("adversarial-audit.json")
    expect(src).toContain(".droidseal")
    // 只消费最新一次运行(时间戳排序取尾)
    expect(src).toContain(".sort()")
  })

  test("fail 判定方向:fail>0 → findings(阻断发布)", () => {
    expect(src).toContain("对抗审计 verdict 存在 fail")
    expect(src).toContain("不可发布")
  })

  test("skip 策略可配:DROIDSEAL_AUDIT_SKIP_POLICY=strict 时 skip 计为未通过", () => {
    expect(src).toContain("DROIDSEAL_AUDIT_SKIP_POLICY")
    expect(src).toContain('"strict"')
  })

  test("缺失如实处理:默认提示不阻断,DROIDSEAL_REQUIRE_AUDIT=1 强制", () => {
    expect(src).toContain("DROIDSEAL_REQUIRE_AUDIT")
    expect(src).toContain("默认不阻断")
  })

  test("坏 JSON 如实报错,不静默跳过", () => {
    expect(src).toContain("对抗审计 verdict 无法解析")
  })
})
