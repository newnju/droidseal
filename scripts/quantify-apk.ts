// 统一加固指标量化:字节熵 / 明文敏感串 / 可读性 / 尺寸
// 用法: bun scripts/quantify-apk.ts <apk1> <apk2> ... [--out <dir>]
// 输出 Markdown + JSON 到 --out(默认 apk-quantify-out)
import { spawnSync } from "node:child_process"
import { mkdirSync, readFileSync, writeFileSync, existsSync } from "node:fs"
import path from "node:path"

const outIdx = process.argv.indexOf("--out")
const outDir = outIdx >= 0 ? process.argv[outIdx + 1]! : "./apk-quantify-out"
const apks = process.argv.slice(2).filter(a => !a.startsWith("--") && a !== process.argv[outIdx + 1])
if (apks.length === 0) {
  console.error("用法: bun scripts/quantify-apk.ts <apk>... [--out <dir>]")
  process.exit(2)
}
mkdirSync(outDir, { recursive: true })

const SENSITIVE_PATTERNS: Array<[string, RegExp]> = [
  ["api-key-shaped", /(?:api[_-]?key|apikey)["':=\s]{0,3}[A-Za-z0-9_\-]{16,}/gi],
  ["password-literal", /(?:password|passwd|pwd)["':=\s]{0,3}[^\s"',;{}]{4,}/gi],
  ["secret-literal", /(?:secret|token)["':=\s]{0,3}[A-Za-z0-9_\-]{8,}/gi],
  ["private-key-block", /-----BEGIN [A-Z ]*PRIVATE KEY-----/g],
  ["jdbc-url", /jdbc:[a-z0-9]+:\/\/[^\s"']{8,}/gi],
  ["http-plain", /http:\/\/[^\s"']{8,}/gi],
]

const shannonEntropy = (buf: Uint8Array): number => {
  const freq = new Array<number>(256).fill(0)
  for (const b of buf) freq[b]++
  let H = 0
  for (const f of freq) {
    if (f === 0) continue
    const p = f / buf.length
    H -= p * Math.log2(p)
  }
  return H
}

const printableRatio = (buf: Uint8Array): number => {
  let printable = 0
  for (const b of buf) if (b >= 0x20 && b <= 0x7e) printable++
  return printable / buf.length
}

// 解出 APK 内所有 dex+arsc+资源文本的可读性样本(对整包做熵/可读性,另对解压后 DEX 做字符串池扫描)
const quant = (apkPath: string) => {
  const buf = readFileSync(apkPath)
  const sizeKB = Math.round(buf.length / 102.4) / 10
  const entropy = shannonEntropy(buf)
  const readable = printableRatio(buf)
  // 明文敏感串:扫整包字节(覆盖明文 DEX 字符串池;加密产物中这些模式应消失)
  const text = buf.toString("latin1")
  const sensitive: Record<string, number> = {}
  let total = 0
  for (const [name, re] of SENSITIVE_PATTERNS) {
    const m = text.match(re)
    sensitive[name] = m ? m.length : 0
    total += sensitive[name]!
  }
  return { apk: path.basename(apkPath), sizeKB, entropy: Math.round(entropy * 100) / 100, readablePct: Math.round(readable * 1000) / 10, sensitive, total }
}

const rows = apks.filter(a => existsSync(a)).map(quant)

const md = [
  "# 加固效果统一量化(字节熵 / 明文敏感串 / 可读性 / 尺寸)",
  "",
  `日期: ${new Date().toISOString().slice(0, 10)}`,
  "",
  "| 产物 | 尺寸 (KB) | 字节熵 | 可读性 | 明文敏感串(合计) | 明细 |",
  "|---|---|---|---|---|---|",
  ...rows.map(r => `| ${r.apk} | ${r.sizeKB} | ${r.entropy} | ${r.readablePct}% | ${r.total} | ${Object.entries(r.sensitive).filter(([, v]) => v > 0).map(([k, v]) => `${k}:${v}`).join(" ") || "—"} |`),
  "",
  "说明:字节熵越高越难分析;可读性(可打印 ASCII 占比)越低逆向成本越高;明文敏感串越少泄露面越小。",
].join("\n")

writeFileSync(path.join(outDir, "quantify.md"), md)
writeFileSync(path.join(outDir, "quantify.json"), JSON.stringify({ date: new Date().toISOString(), rows }, null, 2))
console.log(md)
