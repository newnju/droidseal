// adversarial-audit 探针单测:不依赖设备的部分——verdict JSON 结构契约、
// 判据方向语义(反向判据 fail=正确)、脚本语法完整性。
// 设备端行为归 docs/device-testing.md 对抗审计节 + #5 真机闭环验收(脚本自带
// skip 语义,设备缺失时 exit 0,不算测试失败)。
import { describe, test, expect } from "bun:test"
import { readFileSync } from "node:fs"

const SCRIPT = "scripts/adversarial-audit.sh"

describe("adversarial-audit.sh(对抗审计探针)", () => {
  const src = readFileSync(SCRIPT, "utf-8")

  test("判据集齐备:A1-A5 全部实现", () => {
    for (const id of ["A1", "A2", "A3", "A4", "A5"]) {
      expect(src).toContain(`check ${id}`)
    }
  })

  test("反向判据语义:A1 篡改产物存活且无标记 = fail(锚点被绕过)", () => {
    // A1 的失败分支必须是"重签产物存活且无完整性失败标记"
    expect(src).toContain("重签产物存活且无完整性失败标记")
  })

  test("反向判据语义:A2 泄漏即 fail", () => {
    expect(src).toContain("泄漏零容忍失守")
  })

  test("skip 不产假绿:verdict 含 skip 计数且不算 pass", () => {
    // 脚本 JSON 为转义发射(\"skip\"),按转义形态断言
    expect(src).toContain('\\"skip\\"')
    expect(src).toContain('SKIP=$((SKIP+1))')
  })

  test("verdict 回写:落最新报告目录 verdicts/adversarial-audit.json", () => {
    expect(src).toContain("verdicts/adversarial-audit.json")
    expect(src).toContain(".droidseal/runs")
  })

  test("设备缺失/无 adb 时 skip(exit 0),不误报", () => {
    expect(src).toContain('"SKIP: no device"')
    expect(src).toContain('"SKIP: adb not found"')
  })

  test("攻击 keystore 隔离:使用独立 attack-test.jks,不碰取材 keystore", () => {
    expect(src).toContain("attack-test.jks")
    expect(src).not.toContain("ds-fixture.jks")
  })
})
