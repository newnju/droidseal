#!/usr/bin/env bun
// 加固覆盖度评分（工具）。
// 每资产检查覆盖可量化：对 APK 的各资产类别（APK/DEX/原生 so/资源/字符串池/assets），
// 检查报告发现中是否有对应覆盖（审计发现或加固产物）——输出覆盖度评分（0-100）与明细。
// 输入：APK 路径（或资产目录）+ 报告 JSON（droidseal 报告——含 findings 的 code 列表）——失败关闭。
//
// 用法：
//   bun scripts/hardening-coverage.ts <APK或目录> <报告.json> [--json 输出.json]
import { stat, readdir, readFile, writeFile } from "node:fs/promises"
import path from "node:path"

interface CoverageAsset {
  name: string
  desc: string
  // 该资产的覆盖判定：检查报告 findings 中是否含任一 code（或加固产物存在）
  coveredBy: string[]
}

const COVERAGE_ASSETS: readonly CoverageAsset[] = [
  { name: "APK 整体", desc: "APK 完整性/签名验证", coveredBy: ["SOURCE_ADB_BACKUP_ALLOWED", "MANIFEST_DEBUGGABLE", "DYNAMIC_DEBUGGABLE"] },
  { name: "DEX", desc: "DEX 字符串/方法混淆（字符串加密桩/DEX 重命名）", coveredBy: ["SOURCE_STRING_ENCRYPTION_ABSENT", "DEX_STRING_SECURITY"] },
  { name: "原生 so", desc: "原生符号剥离/混淆", coveredBy: ["SO_UNSTRIPPED_SYMBOLS", "SOURCE_HARDENING_ABSENT"] },
  { name: "资源", desc: "资源名混淆（Mode C/D）", coveredBy: ["ARSC_VALUE_TECHNICAL"] },
  { name: "字符串池", desc: "敏感字符串加密（nonce 多轮/密钥掩码）", coveredBy: ["SOURCE_STRING_ENCRYPTION_ABSENT"] },
  { name: "assets", desc: "assets 加密", coveredBy: ["SOURCE_ASSET_ENCRYPTION_ABSENT"] },
  { name: "运行时", desc: "反调试/完整性自检（stub 接入）", coveredBy: ["DYNAMIC_CRASH_ANR", "SOURCE_HARDENING_ABSENT"] },
]

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const target = argv[0]
  const reportPath = argv[1]
  if (!target || !reportPath) throw new Error("用法: hardening-coverage <APK或目录> <报告.json> [--json 输出.json]")
  const report = JSON.parse(await readFile(reportPath, "utf8")) as { findings?: Array<{ code: string }> }
  const codes = new Set((report.findings ?? []).map((f) => f.code))

  // 资产存在性（APK 文件或目录内含对应类型）
  let st
  try {
    st = await stat(target)
  } catch {
    throw new Error(`目标不存在：${target}`)
  }
  const hasDex = st.isFile() || (await readdir(target)).some((f) => /\.dex$|\.apk$/.test(f))
  const hasSo = st.isFile() || (await readdir(target)).some((f) => /\.so$/.test(f))
  const hasRes = st.isFile() || (await readdir(target)).some((f) => /\.arsc$|res$/.test(f))

  const rows = COVERAGE_ASSETS.map((asset) => {
    const exists = asset.name === "APK 整体" || asset.name === "字符串池" || asset.name === "运行时" || (asset.name === "DEX" ? hasDex : asset.name === "原生 so" ? hasSo : asset.name === "资源" ? hasRes : true)
    const covered = exists && asset.coveredBy.some((c) => codes.has(c))
    return { name: asset.name, desc: asset.desc, exists, covered }
  })

  const coveredCount = rows.filter((r) => r.covered).length
  const score = Math.round((coveredCount / rows.length) * 100)

  console.log("== 加固覆盖度评分 ==")
  for (const r of rows) {
    console.log(`${r.covered ? "✓" : r.exists ? "○" : "—"} ${r.name}：${r.desc}`)
  }
  console.log(`\n覆盖度：${coveredCount}/${rows.length} —— 评分 ${score}/100`)

  const jsonIndex = argv.indexOf("--json")
  if (jsonIndex >= 0) {
    await writeFile(argv[jsonIndex + 1]!, JSON.stringify({ score, covered: coveredCount, total: rows.length, assets: rows }, null, 2), "utf8")
    console.log(`已输出 JSON：${argv[jsonIndex + 1]}`)
  }
}

main().catch((error) => {
  console.error(`覆盖度评分失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
