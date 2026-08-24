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
import { matchBehaviorRules } from "../src/core/behavior-rules.ts"
import { compareKnownVulnerabilities } from "../src/core/known-vulnerabilities.ts"
import { scanCollectionTaint } from "../src/core/collection-taint.ts"
import { scanSourceDetectors } from "../src/core/source-detectors.ts"
import { extractEndpoints } from "../src/core/endpoint-extract.ts"
import { mkdtemp, writeFile, mkdir } from "node:fs/promises"
import { tmpdir } from "node:os"
import path from "node:path"

// 构造合成源码目录（供 scanSourceDetectors 的正/负用例）。
async function makeSourceDir(source: string): Promise<string> {
  const dir = await mkdtemp(path.join(tmpdir(), "det-"))
  await mkdir(path.join(dir, "src"), { recursive: true })
  await writeFile(path.join(dir, "src", "Main.kt"), source, "utf8")
  return dir
}

interface Case {
  name: string
  run: () => { hit: boolean; detail: string } | Promise<{ hit: boolean; detail: string }>
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
  {
    name: "行为规则命中(正——短信劫持)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.telephony.SmsManager.sendTextMessage"]))
      return { hit: hits.some((h) => h.rule.crimer === "sms-hijack"), detail: `命中 ${hits.length} 条（应含 sms-hijack）` }
    },
  },
  {
    name: "行为规则命中(正——勒索加密)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["javax.crypto.Cipher.doFinal"]))
      return { hit: hits.some((h) => h.rule.crimer === "ransom-encrypt"), detail: `命中 ${hits.length} 条（应含 ransom-encrypt）` }
    },
  },
  {
    name: "行为规则不命中(负——正常调用)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.widget.TextView.setText"]))
      return { hit: hits.length === 0, detail: `误报 ${hits.length} 条（应 0——正常 UI 调用）` }
    },
  },
  {
    name: "供应链快照比对(正——okhttp)",
    run: () => {
      const findings = compareKnownVulnerabilities(["com.squareup.okhttp3:okhttp"])
      return { hit: findings.some((f) => f.code === "SUPPLYCHAIN_KNOWN_VULNERABILITY"), detail: `命中 ${findings.length} 条（应含 okhttp CVE-2021-0341）` }
    },
  },
  {
    name: "供应链快照比对(负——未知组件)",
    run: () => {
      const findings = compareKnownVulnerabilities(["com.example:custom-sdk"])
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 条（应 0——未知组件）` }
    },
  },
  {
    name: "集合污点命中(正——put→get→汇)",
    run: () => {
      const flows = scanCollectionTaint("String d = getDeviceId(); list.put(\"k\", d);\nString v = list.get(\"k\"); Log.d(\"t\", v);")
      return { hit: flows.length > 0, detail: `流 ${flows.length} 条（应有——put 敏感 → get → 汇）` }
    },
  },
  {
    name: "集合污点不命中(负——put 但无汇)",
    run: () => {
      const flows = scanCollectionTaint("String d = getDeviceId(); list.put(\"k\", d);")
      return { hit: flows.length === 0, detail: `误报 ${flows.length} 条（应 0——put 但无 get→汇）` }
    },
  },
  {
    name: "源码检测器命中(正——日志/WebView/RSA)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { Log.d(\"token\", \"secret-1\"); w.settings.setAllowFileAccess(true); KeyPairGenerator.getInstance(\"RSA\").initialize(1024) } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_LOG_SENSITIVE") && codes.includes("SOURCE_WEBVIEW_FILE_ACCESS") && codes.includes("SOURCE_INSECURE_RSA"), detail: `命中 ${findings.length} 类（应含 日志/WebView/RSA）` }
    },
  },
  {
    name: "源码检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val kp = KeyPairGenerator.getInstance(\"RSA\"); kp.initialize(2048); val r = SecureRandom() } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——2048 位 RSA + SecureRandom——安全）` }
    },
  },
  {
    name: "②c 检测器命中(正——ECB/反序列化/剪贴板)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val c = Cipher.getInstance(\"AES/ECB/PKCS5Padding\"); val ois = ObjectInputStream(null); val cm = ClipboardManager(); cm.setPrimaryClip(ClipData.newPlainText(\"k\", \"password-1\")) } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_ECB_CIPHER_USAGE") && codes.includes("SOURCE_DESERIALIZATION_UNSAFE") && codes.includes("SOURCE_CLIPBOARD_SENSITIVE"), detail: `命中 ${findings.length} 类（应含 ECB/反序列化/剪贴板）` }
    },
  },
  {
    name: "②c 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val c = Cipher.getInstance(\"AES/GCM/NoPadding\"); val j = JSONObject() } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——GCM + JSON——安全）` }
    },
  },
  {
    name: "②d 检测器命中(正——反射/有序广播/账户认证)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { Class.forName(\"com.x.Y\").getMethod(\"run\"); sendOrderedBroadcast(intent, null, null, null, 0, \"token-abc\", null); AccountManager.am.addAccountExplicitly(acct, \"password-1\", null) } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_REFLECTION_UNRESTRICTED") && codes.includes("SOURCE_BROADCAST_ORDERED_SENSITIVE") && codes.includes("SOURCE_ACCOUNT_AUTH_SENSITIVE"), detail: `命中 ${findings.length} 类（应含 反射/有序广播/账户认证）` }
    },
  },
  {
    name: "②d 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val r = SecureRandom(); val j = JSONObject(); val c = Cipher.getInstance(\"AES/GCM/NoPadding\") } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——普通前台服务+版本检查——安全）` }
    },
  },
  {
    name: "端点提取命中(正——URL 提取)",
    run: () => {
      const endpoints = extractEndpoints(["https://api.example.com/v1/users?id=1", "https://cdn.example.net/static/app.js"])
      return { hit: endpoints.length >= 2, detail: `提取 ${endpoints.length} 个端点（应 ≥2——api.example.com + cdn.example.net）` }
    },
  },
  {
    name: "端点提取不命中(负——无 URL)",
    run: () => {
      const endpoints = extractEndpoints(["plain text without urls", "another line"])
      return { hit: endpoints.length === 0, detail: `误报 ${endpoints.length} 个（应 0——无 URL）` }
    },
  },
  {
    name: "②e 检测器命中(正——DB 密码/XXE/IV 复用)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { SQLiteDatabase.openDatabase(\"db\", \"pass123\", null, 0); val f = DocumentBuilderFactory.newInstance(); f.setFeature(\"http://xml.org/sax/features/external-general-entities\", true); val iv = \"0123456789ABCDEF\" } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_DB_PASSWORD_PLAINTEXT") && codes.includes("SOURCE_XML_XXE_RISK") && codes.includes("SOURCE_IV_REUSE"), detail: `命中 ${findings.length} 类（应含 DB 密码/XXE/IV 复用）` }
    },
  },
  {
    name: "②e 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val c = Cipher.getInstance(\"AES/GCM/NoPadding\"); val r = SecureRandom(); val bytes = r.nextBytes(16) } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——GCM + SecureRandom——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——行为勒索规则)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["javax.crypto.Cipher.doFinal", "android.app.admin.DevicePolicyManager.wipeData"]))
      return { hit: hits.some((h) => h.rule.crimer === "ransom-encrypt") && hits.some((h) => h.rule.crimer === "ransom-wipe"), detail: `命中 ${hits.length} 条（应含 勒索加密+擦除）` }
    },
  },
]

let failed = 0
for (const testCase of cases) {
  const result = await testCase.run()
  const ok = result.hit
  if (!ok) failed += 1
  console.log(`${ok ? "✓" : "✗"} ${testCase.name}：${result.detail}`)
}
console.log(`\n检测器冒烟：${cases.length - failed}/${cases.length} 通过`)
if (failed > 0) process.exitCode = 1
