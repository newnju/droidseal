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
  // 基准深化：全维度正/负用例（污点/加密/注入/存储/网络/权限/组件/UI/供应链）
  { name: "taint-query-uri-log", source: 'class A { fun x() { Log.d("uri", uri.toString()); } }', expected: ["SOURCE_URI_LOGGED"] },
  { name: "crypto-md5", source: 'class A { fun x() { val m = MessageDigest.getInstance("MD5"); } }', expected: ["SOURCE_MD5_USE"] },
  { name: "crypto-sha256-ok", source: 'class A { fun x() { val m = MessageDigest.getInstance("SHA-256"); } }', expected: [] },
  { name: "injection-ldap", source: 'class A { fun x() { ctx.search("ou=people", "cn=" + user); } }', expected: ["SOURCE_LDAP_INJECTION"] },
  { name: "injection-command", source: 'class A { fun x() { Runtime.getRuntime().exec("ls " + path); } }', expected: ["SOURCE_RUNTIME_EXEC_DANGEROUS"] },
  { name: "storage-prefs-secret", source: 'class A { fun x() { prefs.putString("secret", "abc"); } }', expected: ["SOURCE_PREFS_KEY_SENSITIVE"] },
  { name: "storage-internal-ok", source: 'class A { fun x() { val f = openFileOutput("data.txt", MODE_PRIVATE); } }', expected: [] },
  { name: "network-ws-plain", source: 'class A { fun x() { val s = "ws://example.com/socket"; } }', expected: ["SOURCE_PLAINTEXT_WEBSOCKET"] },
  { name: "network-wss-ok", source: 'class A { fun x() { val s = "wss://example.com/socket"; } }', expected: [] },
  { name: "permission-unknown-source", source: 'class A { fun x() { val p = "android.permission.REQUEST_INSTALL_PACKAGES"; } }', expected: ["SOURCE_PERMISSION_INSTALL_UNKNOWN"] },
  { name: "permission-basic-ok", source: 'class A { fun x() { val p = "android.permission.INTERNET"; } }', expected: [] },
  { name: "component-exported-auth", source: 'class A { fun x() { val m = "exported=true"; val login = auth(); } }', expected: ["SOURCE_EXPORTED_ACTIVITY_NO_AUTH"] },
  { name: "component-exported-ok", source: 'class A { fun x() { val m = "exported=false"; } }', expected: [] },
  { name: "ui-toast-secret", source: 'class A { fun x() { Toast.makeText(ctx, "secret-1", 1).show(); } }', expected: ["SOURCE_TOAST_SENSITIVE"] },
  { name: "ui-title-ok", source: 'class A { fun x() { setTitle("欢迎"); } }', expected: [] },
  { name: "supplychain-jwt", source: 'class A { fun x() { val j = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U"; } }', expected: ["SOURCE_JWT_HARDCODED"] },
  { name: "serialization-java", source: 'class A { fun x() { val o = ObjectOutputStream(fos); o.writeObject(data); } }', expected: ["SOURCE_SERIALIZATION_JAVA"] },
  { name: "serialization-json-ok", source: 'class A { fun x() { val j = JSONObject(); } }', expected: [] },
  { name: "webview-js-bridge", source: 'class A { fun x() { wv.addJavascriptInterface(bridge, "bridge"); } }', expected: ["SOURCE_WEBVIEW_JS_BRIDGE_UNSAFE"] },
  { name: "webview-file-ok", source: 'class A { fun x() { wv.settings.setAllowFileAccess(false); } }', expected: [] },
  { name: "backup-allowed", source: 'class A { fun x() { val m = "android:allowBackup=true"; } }', expected: ["SOURCE_ADB_BACKUP_ALLOWED"] },
  { name: "backup-ok", source: 'class A { fun x() { val m = "android:allowBackup=false"; } }', expected: [] },
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

// 从外部基准目录加载用例（每个子目录：Main.kt + expected.json——递归查找子目录——深度 3）。
async function loadExternalCases(dir: string): Promise<BenchmarkCase[]> {
  const cases: BenchmarkCase[] = []
  const stack: string[] = [dir]
  let depth = 0
  while (stack.length > 0 && depth < 3) {
    const current = stack.shift()!
    let entries
    try {
      entries = await readdir(current, { withFileTypes: true })
    } catch {
      continue
    }
    for (const entry of entries) {
      const full = path.join(current, entry.name)
      if (entry.isDirectory()) {
        stack.push(full)
        continue
      }
      if (entry.name !== "Main.kt") continue
      try {
        const source = await readFile(full, "utf8")
        const expectedFile = path.join(current, "expected.json")
        let expected: string[] = []
        try {
          expected = JSON.parse(await readFile(expectedFile, "utf8")).expected ?? []
        } catch {
          expected = []
        }
        cases.push({ name: path.relative(dir, current).replaceAll("\\", "/") || current, source, expected })
      } catch {
        continue
      }
    }
    depth += 1
  }
  return cases
}

function main(): void {
  const argv = process.argv.slice(2)
  const dirIndex = argv.indexOf("--dir")
  const externalDir = dirIndex >= 0 ? argv[dirIndex + 1] : undefined
  const jsonIndex = argv.indexOf("--json")
  const jsonOut = jsonIndex >= 0 ? argv[jsonIndex + 1] : undefined
  const mdIndex = argv.indexOf("--md")
  const mdOut = mdIndex >= 0 ? argv[mdIndex + 1] : undefined

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

    // --json 报告（机器可读——文章/CI 可复现数据）
    if (jsonOut) {
      const report = {
        schemaVersion: 1,
        generatedAt: new Date().toISOString(),
        source: externalDir ?? "builtin",
        caseCount: cases.length,
        totals: { tp, fp, fn },
        precision: Number(precision.toFixed(1)),
        recall: Number(recall.toFixed(1)),
        cases: results.map((r) => ({ name: r.name, tp: r.tp, fp: r.fp, fn: r.fn })),
      }
      await writeFile(jsonOut, JSON.stringify(report, null, 2), "utf8")
      console.log(`已输出 JSON 报告：${jsonOut}`)
    }
    // --md 报告（Markdown——文章表格可直接引用）
    if (mdOut) {
      const rows = results
        .map((r) => `| ${r.name} | ${r.tp.join(",") || "—"} | ${r.fp.join(",") || "—"} | ${r.fn.join(",") || "—"} |`)
        .join("\n")
      const md = `# DroidSeal 基准评测报告\n\n- 来源：${externalDir ?? "内置基准"}\n- 用例数：${cases.length}\n- 合计：TP=${tp} FP=${fp} FN=${fn}\n- **精度 ${precision.toFixed(1)}% · 召回 ${recall.toFixed(1)}%**\n\n| 用例 | TP | FP | FN |\n|---|---|---|---|\n${rows}\n`
      await writeFile(mdOut, md, "utf8")
      console.log(`已输出 Markdown 报告：${mdOut}`)
    }
  })().catch((error) => {
    console.error(`基准评测失败：${error instanceof Error ? error.message : String(error)}`)
    process.exitCode = 1
  })
}

if (import.meta.main) main()
