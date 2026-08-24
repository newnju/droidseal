#!/usr/bin/env bun
// 第三方基准评测（benchmark-eval.ts）。
// 用 DroidBench/OWASP 风格的基准用例评测 DroidSeal 的检测精度与召回：
//   - 基准目录结构：每个子目录一个用例，含 Main.kt（源码）与 expected.json（预期发现的 code 数组）；
//   - 评测：对每个用例跑 scanSourceDetectors——统计 TP（预期且检出）/ FP（检出但非预期）/ FN（预期但未检出）；
//   - 输出：精度（precision = TP/(TP+FP)）与召回（recall = TP/(TP+FN)）——失败关闭。
// 内置一个小基准集（BENCHMARK_CASES——代表性污点/加密/注入正负用例）作为默认评测；
// 可用 --dir <DroidBench目录> 评测外部基准。
//
// 用法：
//   bun scripts/benchmark-eval.ts [--dir 外部基准目录]
import { mkdtemp, writeFile, mkdir, readFile, readdir } from "node:fs/promises"
import { tmpdir } from "node:os"
import path from "node:path"
import { scanSourceDetectors } from "../src/core/source-detectors.ts"

interface BenchmarkCase {
  name: string
  source: string
  expected: string[] // 预期检出的 code（空 = 预期无发现）
}

// 内置小基准集（代表性正/负用例——可替换为外部 DroidBench/OWASP 目录）
const BENCHMARK_CASES: readonly BenchmarkCase[] = [
  { name: "taint-credential-log", source: 'class A { fun x() { Log.d("token", "secret-abc-123"); } }', expected: ["SOURCE_LOG_SENSITIVE"] },
  { name: "crypto-weak-des", source: 'class A { fun x() { val c = Cipher.getInstance("DES/ECB/PKCS5Padding"); } }', expected: ["SOURCE_DES_USE"] },
  { name: "injection-sql", source: 'class A { fun x() { db.rawQuery("SELECT * FROM t WHERE id = " + id); } }', expected: ["SOURCE_SQL_RAW_STRING"] },
  { name: "ssl-bypass-hostname", source: 'class A { fun x() { conn.setHostnameVerifier(ALLOW_ALL_HOSTNAME_VERIFIER); } }', expected: ["SOURCE_CERTIFICATE_HOSTNAME_OFF"] },
  { name: "storage-sdcard", source: 'class A { fun x() { getExternalStorageDirectory().writeText("data"); } }', expected: [] },
  { name: "network-https-ok", source: 'class A { fun x() { val u = URL("https://ok.example.com/x"); } }', expected: [] },
  { name: "crypto-gcm-ok", source: 'class A { fun x() { val c = Cipher.getInstance("AES/GCM/NoPadding"); } }', expected: [] },
  { name: "random-secure-ok", source: 'class A { fun x() { val r = SecureRandom(); } }', expected: [] },
]

interface EvalResult {
  name: string
  tp: string[]
  fp: string[]
  fn: string[]
}

// 跑一个基准用例（合成源码目录——scanSourceDetectors——统计 TP/FP/FN）。
async function evalCase(testCase: BenchmarkCase): Promise<EvalResult> {
  const dir = await mkdtemp(path.join(tmpdir(), "bench-"))
  await mkdir(path.join(dir, "src"), { recursive: true })
  await writeFile(path.join(dir, "src", "Main.kt"), testCase.source, "utf8")
  const findings = await scanSourceDetectors(dir)
  const detected = new Set(findings.map((f) => f.code))
  const expected = new Set(testCase.expected)
  const tp = [...expected].filter((c) => detected.has(c))
  const fp = [...detected].filter((c) => !expected.has(c))
  const fn = [...expected].filter((c) => !detected.has(c))
  return { name: testCase.name, tp, fp, fn }
}

// 从外部基准目录加载用例（每个子目录：Main.kt + expected.json——可选）。
async function loadExternalCases(dir: string): Promise<BenchmarkCase[]> {
  const entries = await readdir(dir, { withFileTypes: true })
  const cases: BenchmarkCase[] = []
  for (const entry of entries) {
    if (!entry.isDirectory()) continue
    const src = path.join(dir, entry.name, "Main.kt")
    const expectedFile = path.join(dir, entry.name, "expected.json")
    try {
      const source = await readFile(src, "utf8")
      let expected: string[] = []
      try {
        expected = JSON.parse(await readFile(expectedFile, "utf8")).expected ?? []
      } catch {
        expected = []
      }
      cases.push({ name: entry.name, source, expected })
    } catch {
      continue
    }
  }
  return cases
}

function main(): void {
  const argv = process.argv.slice(2)
  const dirIndex = argv.indexOf("--dir")
  const externalDir = dirIndex >= 0 ? argv[dirIndex + 1] : undefined

  ;(async () => {
    const cases = externalDir ? await loadExternalCases(externalDir) : [...BENCHMARK_CASES]
    if (cases.length === 0) throw new Error(`基准目录无有效用例：${externalDir ?? "(内置)"}`)
    const results: EvalResult[] = []
    for (const testCase of cases) results.push(await evalCase(testCase))

    let tp = 0
    let fp = 0
    let fn = 0
    console.log("== 基准评测结果 ==")
    for (const r of results) {
      tp += r.tp.length
      fp += r.fp.length
      fn += r.fn.length
      console.log(`${r.fp.length === 0 && r.fn.length === 0 ? "✓" : "✗"} ${r.name}：TP=${r.tp.join(",") || 0} FP=${r.fp.join(",") || 0} FN=${r.fn.join(",") || 0}`)
    }
    const precision = tp + fp > 0 ? (tp / (tp + fp)) * 100 : 100
    const recall = tp + fn > 0 ? (tp / (tp + fn)) * 100 : 100
    console.log(`\n合计：TP=${tp} FP=${fp} FN=${fn}（${cases.length} 用例）`)
    console.log(`精度（precision）=${precision.toFixed(1)}% 召回（recall）=${recall.toFixed(1)}%`)
  })().catch((error) => {
    console.error(`基准评测失败：${error instanceof Error ? error.message : String(error)}`)
    process.exitCode = 1
  })
}

if (import.meta.main) main()
