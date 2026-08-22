#!/usr/bin/env bun
// 供应链快照 / 打包器指纹一致性校验（开发路线——数据质量门禁）。
// 校验 known-vulnerabilities 与 packers 表的字段完整性、唯一性（CVE/包名/marker），
// 重复或字段缺失即报错并返回非零。可挂入 preflight 或 CI。
import { KNOWN_VULNERABILITIES } from "../src/core/known-vulnerabilities.ts"
import { KNOWN_PACKERS } from "../src/core/packers.ts"

const SEVERITIES = ["critical", "high", "medium", "low", "info"]

function main(): void {
  const errors: string[] = []
  const cves = new Set<string>()
  const packages = new Set<string>()
  for (const entry of KNOWN_VULNERABILITIES) {
    if (!entry.package || !entry.cve || !entry.severity || !entry.note) {
      errors.push(`快照条目缺字段: ${JSON.stringify(entry)}`)
      continue
    }
    if (!/^CVE-\d{4}-\d+$/.test(entry.cve)) errors.push(`CVE 格式异常: ${entry.cve}`)
    if (!SEVERITIES.includes(entry.severity)) errors.push(`严重度异常: ${entry.severity}`)
    if (cves.has(entry.cve)) errors.push(`重复 CVE: ${entry.cve}`)
    cves.add(entry.cve)
    if (packages.has(entry.package)) errors.push(`重复包名: ${entry.package}`)
    packages.add(entry.package)
  }
  const markers = new Set<string>()
  const names = new Set<string>()
  for (const packer of KNOWN_PACKERS) {
    if (!packer.name || !packer.marker || !packer.note) {
      errors.push(`指纹条目缺字段: ${JSON.stringify(packer)}`)
      continue
    }
    if (markers.has(packer.marker)) errors.push(`重复 marker: ${packer.marker}`)
    markers.add(packer.marker)
    if (names.has(packer.name)) errors.push(`重复名称: ${packer.name}`)
    names.add(packer.name)
  }
  if (errors.length > 0) {
    console.error(`一致性校验失败（${errors.length}）:\n${errors.join("\n")}`)
    process.exitCode = 1
  } else {
    console.log(`一致性校验通过：快照 ${KNOWN_VULNERABILITIES.length} 条、指纹 ${KNOWN_PACKERS.length} 个`)
  }
  if (process.argv.includes("--suggest")) {
    console.log(`\n新条目格式模板：

新增快照条目：
{
  package: "组件名",
  cve: "CVE-YYYY-NNNNN",
  severity: "critical | high | medium | low | info",
  note: "漏洞说明",
  affected: "受影响版本区间（可选）",
  fixedIn: "修复版本（可选）",
}

新增指纹条目：
{
  name: "厂商名（英文名）",
  marker: "类名/包名特征（小写）",
  note: "说明",
}
补充后运行本脚本校验（CVE/包名/marker 唯一性、字段完整性）。`)
  }
}

try {
  main()
} catch (error) {
  console.error(`校验失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
}
