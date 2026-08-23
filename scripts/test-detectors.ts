#!/usr/bin/env bun
// 检测器精度冒烟（②——test-detectors.ts）。
// 核心检测器的正/负用例验证：每个检测器用合成样本逐项验证「应命中命中、应不命中不命中」——
// 失败即非零退出（CI 门禁）——保持「确认后才报」的精度。
//
// 用法：
//   bun scripts/test-detectors.ts
import { matchCustomRules, parseCustomRules } from "../src/core/custom-rules.ts"
import { buildPermissionRiskFindings, linkPermissionDataflow } from "../src/core/permission-risk.ts"
import { buildMastgChecklist, mastgComplianceSummary } from "../src/core/mastg-checklist.ts"
import { buildHardeningSuggestions } from "../src/core/report.ts"

interface Case {
  name: string
  run: () => { hit: boolean; detail: string }
}

const cases: Case[] = [
  {
    name: "自定义规则命中(正)",
    run: () => {
      const rules = parseCustomRules(JSON.stringify([{ code: "TEST_KEY", title: "测试", severity: "high", pattern: "api[_-]?key\\s*=\\s*[\"'][^\"']{12,}[\"']", scope: "source" }]))
      const hits = matchCustomRules(rules, ["const api_key = \"AIzaSyA123456789012345678901234567\""], "source")
      return { hit: hits.length > 0, detail: `命中 ${hits.length} 条（应 1）` }
    },
  },
  {
    name: "自定义规则不命中(负)",
    run: () => {
      const rules = parseCustomRules(JSON.stringify([{ code: "TEST_KEY", title: "测试", severity: "high", pattern: "api[_-]?key\\s*=\\s*[\"'][^\"']{12,}[\"']", scope: "source" }]))
      const hits = matchCustomRules(rules, ["const api_key = config.get(\"key\")"], "source")
      return { hit: hits.length === 0, detail: `误报 ${hits.length} 条（应 0）` }
    },
  },
  {
    name: "权限风险评分(正)",
    run: () => {
      const findings = buildPermissionRiskFindings(["android.permission.RECEIVE_SMS"])
      return { hit: findings.length > 0 && findings[0]!.code === "PERMISSION_RISK_HIGH", detail: `风险评分 ${findings.length > 0 ? findings[0]!.title : "无"}（应有）` }
    },
  },
  {
    name: "权限风险评分(负)",
    run: () => {
      const findings = buildPermissionRiskFindings(["android.permission.INTERNET"])
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 条（应 0——INTERNET 非敏感）` }
    },
  },
  {
    name: "权限-数据流关联(正)",
    run: () => {
      const links = linkPermissionDataflow(["android.permission.READ_PHONE_STATE"], [{ code: "SOURCE_DATAFLOW", severity: "medium", title: "t", detail: "d", recommendation: "r", evidence: "getDeviceId() → Log.d" }])
      return { hit: links.length > 0 && links[0]!.code === "PERMISSION_DATAFLOW_LINK", detail: `关联 ${links.length} 条（应 1）` }
    },
  },
  {
    name: "权限-数据流关联(负)",
    run: () => {
      const links = linkPermissionDataflow(["android.permission.READ_PHONE_STATE"], [{ code: "SOURCE_DATAFLOW", severity: "medium", title: "t", detail: "d", recommendation: "r", evidence: "getString() → setText()" }])
      return { hit: links.length === 0, detail: `误报 ${links.length} 条（应 0——无对应源/汇）` }
    },
  },
  {
    name: "MASTG 清单状态推导(正)",
    run: () => {
      const checklist = buildMastgChecklist([{ code: "SOURCE_SSL_BYPASS", severity: "high", title: "t", detail: "d", recommendation: "r" }])
      const item = checklist.find((i) => i.id === "MASTG-NETWORK-2")
      return { hit: item?.status === "需核验", detail: `MASTG-NETWORK-2 状态 ${item?.status}（应 需核验）` }
    },
  },
  {
    name: "MASTG 清单状态推导(负)",
    run: () => {
      const checklist = buildMastgChecklist([{ code: "UNRELATED", severity: "low", title: "t", detail: "d", recommendation: "r" }])
      const item = checklist.find((i) => i.id === "MASTG-NETWORK-2")
      return { hit: item?.status === "未检查", detail: `MASTG-NETWORK-2 状态 ${item?.status}（应 未检查）` }
    },
  },
  {
    name: "加固建议生成(正)",
    run: () => {
      const suggestions = buildHardeningSuggestions([{ code: "SOURCE_HARDCODED_SECRET", severity: "high", title: "t", detail: "d", recommendation: "r" }])
      return { hit: suggestions.length > 0 && suggestions[0]!.type === "源码敏感串", detail: `建议 ${suggestions.length} 条（应 1）` }
    },
  },
  {
    name: "加固建议生成(负)",
    run: () => {
      const suggestions = buildHardeningSuggestions([{ code: "SOURCE_SSL_BYPASS", severity: "high", title: "t", detail: "d", recommendation: "r" }])
      return { hit: suggestions.length === 0, detail: `误报 ${suggestions.length} 条（应 0——非敏感串发现）` }
    },
  },
]

let failed = 0
for (const testCase of cases) {
  const result = testCase.run()
  const ok = result.hit
  if (!ok) failed += 1
  console.log(`${ok ? "✓" : "✗"} ${testCase.name}：${result.detail}`)
}
console.log(`\n检测器冒烟：${cases.length - failed}/${cases.length} 通过`)
if (failed > 0) process.exitCode = 1
