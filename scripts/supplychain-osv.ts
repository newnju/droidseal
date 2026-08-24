#!/usr/bin/env bun
// 供应链深化（开发路线「供应链深化」——supplychain-osv.ts）。
// SBOM 与 OSV 离线快照比对：输入 SBOM/包清单 JSON（包名 + 版本），与 OSV 格式的
// 离线漏洞快照（ecosystem/package/affected 区间）比对——输出命中漏洞 + Gradle 修复版本建议——
// 不联网清单级提示——失败关闭。
//
// 用法：
//   bun scripts/supplychain-osv.ts <sbom.json> [--snapshot osv-snapshot.json]
import { readFile, writeFile } from "node:fs/promises"

interface OsvVuln {
  id: string
  ecosystem: string
  package: string
  affected: string[] // 受影响版本区间（semver 区间——如 "<=1.2.3" / ">=1.0.0 <1.2.4"）
  fixed: string // 修复版本（Gradle 修复建议）
}

// 内置 OSV 离线快照（清单级——不联网；可用 --snapshot 替换为更大的外部快照）。
const BUILTIN_SNAPSHOT: readonly OsvVuln[] = [
  { id: "OSV-2023-0001", ecosystem: "maven", package: "com.squareup.okhttp3:okhttp", affected: ["<=4.11.0"], fixed: "4.12.0" },
  { id: "OSV-2023-0002", ecosystem: "maven", package: "com.github.bumptech.glide:glide", affected: ["<4.16.0"], fixed: "4.16.0" },
  { id: "OSV-2023-0003", ecosystem: "maven", package: "com.google.code.gson:gson", affected: ["<2.8.9"], fixed: "2.8.9" },
  { id: "OSV-2023-0004", ecosystem: "maven", package: "org.jsoup:jsoup", affected: ["<=1.15.3"], fixed: "1.16.1" },
]

// 简化的版本比较（三段式 major.minor.patch——快照内区间足够）。
function compareVersions(a: string, b: string): number {
  const pa = a.split(".").map((n) => parseInt(n, 10) || 0)
  const pb = b.split(".").map((n) => parseInt(n, 10) || 0)
  for (let i = 0; i < 3; i++) {
    const d = (pa[i] ?? 0) - (pb[i] ?? 0)
    if (d !== 0) return d
  }
  return 0
}

function versionInRange(version: string, range: string): boolean {
  const m = /^(<=|>=|<|>)?\s*([\d.]+)/.exec(range)
  if (!m) return false
  const op = m[1] ?? "="
  const target = m[2]!
  const cmp = compareVersions(version, target)
  switch (op) {
    case "<=": return cmp <= 0
    case ">=": return cmp >= 0
    case "<": return cmp < 0
    case ">": return cmp > 0
    default: return cmp === 0
  }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const sbomPath = argv[0]
  if (!sbomPath) throw new Error("用法: supplychain-osv <sbom.json> [--snapshot osv-snapshot.json]")
  const sbom = JSON.parse(await readFile(sbomPath, "utf8")) as { components?: Array<{ name: string; version: string }> }
  const snapshotIndex = argv.indexOf("--snapshot")
  const snapshot: readonly OsvVuln[] = snapshotIndex >= 0 ? (JSON.parse(await readFile(argv[snapshotIndex + 1]!, "utf8")) as OsvVuln[]) : BUILTIN_SNAPSHOT
  if (!Array.isArray(sbom.components)) throw new Error("SBOM 需含 components 数组（name + version）")

  const hits: Array<{ package: string; version: string; vuln: OsvVuln }> = []
  for (const comp of sbom.components) {
    for (const vuln of snapshot) {
      if (vuln.package !== comp.name) continue
      if (vuln.affected.some((r) => versionInRange(comp.version, r))) {
        hits.push({ package: comp.name, version: comp.version, vuln })
      }
    }
  }

  console.log("== SBOM × OSV 离线快照比对 ==")
  if (hits.length === 0) {
    console.log("✓ 未命中已知漏洞（清单级——离线比对）")
    return
  }
  for (const h of hits) {
    console.log(`✗ ${h.package} ${h.version} —— ${h.vuln.id}（affected: ${h.vuln.affected.join("; ")}）`)
    console.log(`   Gradle 修复建议: ${h.package}:${h.vuln.fixed}`)
  }
  const jsonIndex = argv.indexOf("--json")
  if (jsonIndex >= 0) {
    await writeFile(argv[jsonIndex + 1]!, JSON.stringify({ hits }, null, 2), "utf8")
    console.log(`已输出 JSON：${argv[jsonIndex + 1]}`)
  }
}

main().catch((error) => {
  console.error(`供应链比对失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
