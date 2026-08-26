#!/usr/bin/env bun
// 加固效果闭环（工具）。
// 加固前后对比报告：大小 / 字节熵（香农熵）/ DEX 字符串池明文敏感串计数 / 可读性量化——
// 量化加固成效（熵越高、明文敏感串越少、可读性越低 = 加固越有效）。失败关闭。
//
// 用法：
//   bun scripts/generate-hardening-compare.ts <加固前APK> <加固后APK> [--json 报告.json] [--md 报告.md]
import { stat, readFile, writeFile } from "node:fs/promises"

// 香农熵（字节级——随机性/混淆度量化——越高越难分析）。
function byteEntropy(bytes: Uint8Array): number {
  const freq = new Array<number>(256).fill(0)
  for (const b of bytes) freq[b]! += 1
  let entropy = 0
  const len = bytes.length
  for (const count of freq) {
    if (count === 0) continue
    const p = count / len
    entropy -= p * Math.log2(p)
  }
  return entropy
}

// DEX 字符串池明文敏感串计数（简单文本扫描——敏感形态的明文出现次数——加固后应下降）。
function sensitiveStringCount(bytes: Uint8Array): number {
  const text = Buffer.from(bytes).toString("latin1")
  const patterns = [/password\s*=/gi, /secret[_-]?key\s*=/gi, /api[_-]?key\s*=/gi, /Bearer\s+[A-Za-z0-9._-]{12,}/g, /[A-Za-z0-9+/=]{24,}={0,2}/g]
  let count = 0
  for (const p of patterns) count += (text.match(p) ?? []).length
  return count
}

// 可读性量化（ASCII 可见字符占比——混淆后应下降）。
function readabilityScore(bytes: Uint8Array): number {
  let visible = 0
  for (const b of bytes) {
    if (b >= 0x20 && b <= 0x7e) visible += 1
  }
  return (visible / Math.max(1, bytes.length)) * 100
}

async function analyze(path: string): Promise<{ size: number; entropy: number; sensitive: number; readability: number }> {
  const st = await stat(path)
  const bytes = new Uint8Array(await readFile(path))
  return {
    size: st.size,
    entropy: Number(byteEntropy(bytes).toFixed(2)),
    sensitive: sensitiveStringCount(bytes),
    readability: Number(readabilityScore(bytes).toFixed(1)),
  }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const before = argv[0]
  const after = argv[1]
  if (!before || !after) throw new Error("用法: generate-hardening-compare <加固前APK> <加固后APK> [--json 报告.json] [--md 报告.md]")
  const jsonIndex = argv.indexOf("--json")
  const mdIndex = argv.indexOf("--md")

  const beforeStat = await analyze(before)
  const afterStat = await analyze(after)
  const sizeDelta = ((afterStat.size - beforeStat.size) / beforeStat.size) * 100
  const entropyDelta = afterStat.entropy - beforeStat.entropy
  const sensitiveDelta = afterStat.sensitive - beforeStat.sensitive
  const readableDelta = afterStat.readability - beforeStat.readability

  console.log("== 加固前后对比 ==")
  console.log(`大小: ${beforeStat.size} → ${afterStat.size} 字节（${sizeDelta >= 0 ? "+" : ""}${sizeDelta.toFixed(1)}%）`)
  console.log(`字节熵: ${beforeStat.entropy} → ${afterStat.entropy}（${entropyDelta >= 0 ? "+" : ""}${entropyDelta.toFixed(2)}——熵越高越难分析）`)
  console.log(`明文敏感串: ${beforeStat.sensitive} → ${afterStat.sensitive}（${sensitiveDelta >= 0 ? "+" : ""}${sensitiveDelta}——越少越安全）`)
  console.log(`可读性: ${beforeStat.readability}% → ${afterStat.readability}%（${readableDelta >= 0 ? "+" : ""}${readableDelta.toFixed(1)}——越低越难读）`)

  const report = {
    before: { file: before, ...beforeStat },
    after: { file: after, ...afterStat },
    deltas: { sizePercent: Number(sizeDelta.toFixed(1)), entropy: entropyDelta, sensitive: sensitiveDelta, readability: Number(readableDelta.toFixed(1)) },
  }
  if (jsonIndex >= 0) {
    await writeFile(argv[jsonIndex + 1]!, JSON.stringify(report, null, 2), "utf8")
    console.log(`已输出 JSON 对比报告：${argv[jsonIndex + 1]}`)
  }
  if (mdIndex >= 0) {
    const md = `# 加固前后对比报告\n\n| 指标 | 加固前 | 加固后 | 变化 |\n|---|---|---|---|\n| 大小 | ${beforeStat.size} | ${afterStat.size} | ${sizeDelta >= 0 ? "+" : ""}${sizeDelta.toFixed(1)}% |\n| 字节熵 | ${beforeStat.entropy} | ${afterStat.entropy} | ${entropyDelta >= 0 ? "+" : ""}${entropyDelta.toFixed(2)} |\n| 明文敏感串 | ${beforeStat.sensitive} | ${afterStat.sensitive} | ${sensitiveDelta >= 0 ? "+" : ""}${sensitiveDelta} |\n| 可读性 | ${beforeStat.readability}% | ${afterStat.readability}% | ${readableDelta >= 0 ? "+" : ""}${readableDelta.toFixed(1)}% |\n`
    await writeFile(argv[mdIndex + 1]!, md, "utf8")
    console.log(`已输出 Markdown 对比报告：${argv[mdIndex + 1]}`)
  }
}

main().catch((error) => {
  console.error(`加固对比失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
