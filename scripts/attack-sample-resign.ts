// 攻击样本 #1:重签名必败(构建级可证部分)
// ─────────────────────────────────────────────────────────────────────────────
// 场景(AT-1,threat-model):攻击者用自己生成的 keystore 重签加固产物,分发"破解版"。
// 本脚本复现该攻击并证明:重签后产物结构完好(基线 H1–H6 仍过),但签名证书已变。
// 由于 loader 密钥 = HKDF(签名证书 SHA-256),证书指纹变化 ⇒ 派生密钥必然变化 ⇒
// 运行时解密必然失败。这一环是纯数学前提(构建期可证);运行时的实际失败现象
// (D2 存活失败 + D3 logcat integrityFailed/BadTag)需真机,见 docs/device-testing.md §重签必败。
// 用法: bun scripts/attack-sample-resign.ts <hardened.apk> [--out <dir>]
import { spawnSync } from "node:child_process"
import { cpSync, mkdirSync, rmSync, existsSync } from "node:fs"
import path from "node:path"
import { generateKeystore, signApk, findBuildTool } from "../src/core/apk-repack.ts"

const apk = process.argv[2]
const outIdx = process.argv.indexOf("--out")
const outDir = outIdx >= 0 ? process.argv[outIdx + 1]! : "./attack-sample-out"
if (!apk || !existsSync(apk)) {
  console.error("用法: bun scripts/attack-sample-resign.ts <hardened.apk> [--out <dir>]")
  process.exit(2)
}
mkdirSync(outDir, { recursive: true })

// ── Step 1: 原产物签名证书指纹(apksigner 读 v1/v2/v3 全方案;keytool -jarfile 只认 v1)──
const printCert = (apkPath: string): string => {
  const r = spawnSync(findBuildTool("apksigner"), ["verify", "--print-certs", apkPath], { timeout: 60_000, stdio: "pipe" })
  const out = (r.stdout?.toString() ?? "") + (r.stderr?.toString() ?? "")
  if (r.status !== 0) {
    // 未签名产物无证书可读——加固流水线默认自动签名,出现此输入说明喂错了文件
    if (/Missing META-INF|DOES NOT VERIFY/.test(out)) {
      throw new Error(`${apkPath} 无有效签名(需先经加固流水线输出或 apksigner 签名的产物)——本脚本要求输入已签名产物以读取原证书指纹`)
    }
    throw new Error(`apksigner verify --print-certs 失败: ${out.slice(0, 200)}`)
  }
  const m = /SHA-256 digest:\s*([0-9a-f]{64})/i.exec(out)
  if (!m) throw new Error("未能从 apksigner 输出解析 SHA-256 指纹")
  return m[1]!.toLowerCase()
}
const origCert = printCert(apk)
console.log(`原产物证书 SHA-256: ${origCert.slice(0, 16)}…`)

// ── Step 2: 生成攻击者 keystore(与原签名完全无关)──────────────────────
const attackerKs = path.join(outDir, "attacker.jks")
// keytool 对已存在的同 alias keystore 非零退出——重跑样本前先清掉上次的
if (existsSync(attackerKs)) rmSync(attackerKs)
const ksResult = generateKeystore(attackerKs, {
  keyAlias: "attacker",
  storePassword: "attack123",
  keyPassword: "attack123",
  validity: 30,
})
if (!ksResult) {
  console.error("攻击者 keystore 生成失败(keytool 非零退出)")
  process.exit(1)
}
console.log(`攻击者 keystore: ${attackerKs}`)

// ── Step 3: 重签名副本(攻击动作本身)──────────────────────────────────
const resignedApk = path.join(outDir, path.basename(apk).replace(/\.apk$/i, ".resigned.apk"))
cpSync(apk, resignedApk)
const signResult = signApk(resignedApk, {
  mode: "keystore",
  keystorePath: attackerKs,
  keyAlias: "attacker",
  storePassword: "attack123",
  keyPassword: "attack123",
})
if (!signResult.success) {
  console.error("重签名失败(攻击样本本身失败):", signResult.output.slice(0, 300))
  process.exit(1)
}
console.log(`重签名产物: ${resignedApk}`)

// ── Step 4: 证明证书指纹已变 ⇒ 派生密钥必变 ─────────────────────────────
const newCert = printCert(resignedApk)
console.log(`重签产物证书 SHA-256: ${newCert.slice(0, 16)}…`)
if (newCert === origCert) {
  console.error("异常:重签后指纹未变——样本无效(检查 keystore 是否真的不同)")
  process.exit(1)
}
console.log("\n✓ 构建级前提已证:证书指纹变化 ⇒ loader 密钥 = HKDF(证书摘要) 必然变化 ⇒ 运行时解密必失败")

// ── Step 5: 结构基线仍过(证明防御不在结构检测,而在密钥派生)───────────
const { spawnSync: bun } = await import("node:child_process") // 复用主 spawnSync
const baseline = bun("bun", ["scripts/verify-harden-artifact.ts", resignedApk], { timeout: 120_000, stdio: "pipe" })
const baselineOut = (baseline.stdout?.toString() ?? "") + (baseline.stderr?.toString() ?? "")
const baselinePass = baseline.status === 0
console.log(`重签产物结构基线(H1–H6): ${baselinePass ? "PASS(产物结构完好——防御是密钥化的,不是结构校验)" : "FAIL"}`)

console.log(`
─── 预期运行时结果(需真机,判据见 docs/device-testing.md §重签必败)───
  adb install 重签产物 → 安装成功(签名自洽)
  启动 → D2 失败(5 秒内进程退出/白屏:解密静默失败,fail-closed)
  logcat → D3 出现 integrityFailed 或 GCM BadTag(锚点/密钥双重失败)
  这一步在任何设备上复现即完成 AT-1 实证;竞品无此类公开一手数据。`)
