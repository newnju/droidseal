// 源码加固检测器扩充（②a——source-detectors.ts）。
// 新增 15 个左右源码侧检测器（加密/网络/存储/组件/权限——正则模式——扫描项目源码——
// 失败关闭）。与 ssl-bypass/weak-crypto 等模块化检测器并列，集成进源码审计。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface SourceDetector {
  code: string
  title: string
  severity: Finding["severity"]
  pattern: RegExp
  recommendation: string
  note: string
}

const SOURCE_DETECTORS: readonly SourceDetector[] = [
  // 加密
  { code: "SOURCE_INSECURE_KEY_DERIVATION", title: "不安全的密钥派生（弱迭代次数）", severity: "medium", pattern: /PBEKeySpec\s*\([^)]*,[^)]*,\s*(?:[1-9]\d{0,3}|0)\s*\)/i, recommendation: "PBKDF2 迭代次数应 ≥ 10000（建议 210000——OWASP 密码存储建议）。", note: "PBEKeySpec 的迭代次数过弱——暴力破解成本过低。" },
  { code: "SOURCE_STATIC_IV", title: "静态初始化向量（CBC 固定 IV）", severity: "medium", pattern: /IvParameterSpec\s*\(\s*"[0-9A-Fa-f]+"/i, recommendation: "IV 每次加密应随机生成（不固定）——否则 CBC 模式泄露明文模式。", note: "固定 IV 违反加密最佳实践（每次加密随机 IV）。" },
  { code: "SOURCE_INSECURE_RANDOM", title: "不安全的随机数（非 SecureRandom）", severity: "medium", pattern: /new\s+Random\s*\(/i, recommendation: "密码学场景应使用 SecureRandom（new Random 可预测）。", note: "java.util.Random 的种子可预测——密钥/令牌/盐不应使用。" },
  // 网络
  { code: "SOURCE_PLAINTEXT_WEBSOCKET", title: "明文 WebSocket（ws://）", severity: "medium", pattern: /ws:\/\//i, recommendation: "WebSocket 应使用 wss://（TLS 加密）——明文可被中间人窃听。", note: "明文 WebSocket 流量未加密。" },
  { code: "SOURCE_INSECURE_TLS_CONFIG", title: "不安全 TLS 配置（SSLv3/TLSv1 启用）", severity: "high", pattern: /(?:SSLv3|TLSv1)(?:\.1)?["']/i, recommendation: "禁用 SSLv3/TLSv1/TLSv1.1——使用 TLSv1.2+（SSL 协议已有已知漏洞）。", note: "旧 TLS 协议已有已知漏洞（POODLE/BEAST）。" },
  // 存储
  { code: "SOURCE_INTERNAL_STORAGE_PLAINTEXT", title: "内部存储明文写入", severity: "medium", pattern: /openFileOutput\s*\([^)]*MODE_PRIVATE/i, recommendation: "敏感数据写入内部存储应加密（或用加密库）——MODE_PRIVATE 只防其他应用读取。", note: "内部存储明文——应用数据备份/提取后可读。" },
  { code: "SOURCE_SDCARD_WRITE", title: "SD 卡写入敏感数据", severity: "high", pattern: /getExternalStorageDirectory\s*\(\s*\)/i, recommendation: "敏感数据不应写入外部存储（可被任何应用/用户读取）——用内部存储加密。", note: "SD 卡可被其他应用与用户访问。" },
  { code: "SOURCE_SHARED_PREFS_SENSITIVE", title: "SharedPreferences 存敏感数据", severity: "medium", pattern: /getSharedPreferences\s*\([^)]*\)\s*[.\n]*\s*\.(?:putString|putInt|putBoolean)\s*\([^)]*(?:password|token|secret|key)[^)]*\)/i, recommendation: "敏感数据（密码/令牌/密钥）不应存 SharedPreferences——用 EncryptedSharedPreferences 或 Keystore。", note: "SharedPreferences 明文 XML——root/备份可读。" },
  // 组件
  { code: "SOURCE_DYNAMIC_RECEIVER", title: "动态注册广播接收器", severity: "medium", pattern: /registerReceiver\s*\(/i, recommendation: "动态注册接收器需校验发送方（setPackage 限制）——否则可被任意应用触发。", note: "动态注册广播无权限/来源限制时可能被滥用。" },
  { code: "SOURCE_IMPLICIT_INTENT", title: "隐式 Intent 启动（未指定包名）", severity: "medium", pattern: /startActivity\s*\(\s*[^)]*new\s+Intent\s*\([^)]*\)\s*\)/i, recommendation: "启动组件应显式指定（setPackage/setComponent）——隐式 Intent 可被劫持。", note: "隐式 Intent 可能被恶意应用劫持。" },
  { code: "SOURCE_CONTENT_PROVIDER_GRANT", title: "ContentProvider URI 权限授予", severity: "high", pattern: /grantUriPermission\s*\(/i, recommendation: "grantUriPermission 授予临时 URI 权限——需校验接收方与有效期（setFlags）。", note: "URI 权限授予不当可导致数据泄露。" },
  // 权限（源码侧）
  { code: "SOURCE_DANGEROUS_PERMISSION_COMBO", title: "危险权限组合（源码侧：位置+录音）", severity: "medium", pattern: /(?:getLastKnownLocation|requestLocationUpdates)[\s\S]{0,200}?(?:MediaRecorder|startRecording)/i, recommendation: "位置+录音同时使用（高敏感组合）——核对用途与隐私合规（GDPR/CCPA）。", note: "位置与麦克风的高敏感权限组合——隐私风险。" },
  { code: "SOURCE_DEVICE_ID_TRACKING", title: "设备标识长期跟踪（IMEI/Android ID）", severity: "medium", pattern: /(?:getImei|getDeviceId|getSubscriberId|ANDROID_ID)/i, recommendation: "设备标识的长期跟踪需隐私合规——Android 10+ 限制不可重置标识。", note: "设备唯一标识的长期使用——跟踪风险。" },
  // 扩充②b（保障精度——加密/网络/存储/组件）
  { code: "SOURCE_INSECURE_RSA", title: "不安全的 RSA 使用（小密钥/无 OAEP）", severity: "high", pattern: /(?:KeyPairGenerator|Cipher)\s*\.?\s*(?:getInstance\s*\(\s*)?["']RSA["'][^;]{0,80}(?:initialize|init)\s*\(\s*[1-9]\d{0,3}\s*\)/i, recommendation: "RSA 密钥应 ≥ 2048 位；加密应用 OAEP（Cipher RSA/ECB/OAEPWithSHA-256AndMGF1Padding）。", note: "RSA 小密钥（<2048）与无 OAEP 已被证明不安全。" },
  { code: "SOURCE_WEAK_HASH_FOR_SECURITY", title: "安全场景使用弱哈希（MD5/SHA1）", severity: "medium", pattern: /(?:MessageDigest\s*\.\s*getInstance\s*\(\s*"(?:MD5|SHA-?1)")/i, recommendation: "密码/签名/完整性场景应使用 SHA-256+；MD5/SHA1 已有碰撞攻击。", note: "MD5/SHA1 的碰撞攻击——安全场景不可用。" },
  { code: "SOURCE_PLAINTEXT_SOCKET", title: "明文 Socket 通信", severity: "medium", pattern: /(?:new\s+)?(?:java\.net\.)?Socket\s*\(\s*["'][^"']+["']\s*,\s*\d+\s*\)/i, recommendation: "网络通信应使用 TLS（SSLSocket/HttpsURLConnection）——明文 Socket 可被窃听。", note: "明文 Socket 流量未加密。" },
  { code: "SOURCE_INSECURE_COOKIE", title: "不安全 Cookie（未设 Secure/HttpOnly）", severity: "medium", pattern: /CookieManager\s*[^;]{0,80}setCookie/i, recommendation: "Cookie 应设 Secure（仅 HTTPS）与 HttpOnly（防 XSS 读取）。", note: "未设 Secure/HttpOnly 的 Cookie 可被窃取。" },
  { code: "SOURCE_CACHE_DIR_SENSITIVE", title: "缓存目录存敏感数据", severity: "medium", pattern: /getCacheDir\s*\(\s*\)\s*[^;]{0,60}(?:write|create|File\(|\.apply|\.commit)/i, recommendation: "缓存目录（可被系统清理/其他应用读取）不应存敏感数据——用加密内部存储。", note: "缓存目录的敏感数据——清理/读取风险。" },
  { code: "SOURCE_LOG_SENSITIVE", title: "日志打印敏感数据", severity: "medium", pattern: /Log\s*\.\s*(?:d|e|i|w)\s*\([^)]*(?:password|token|secret|key|credential)[^)]*\)/i, recommendation: "敏感数据不应写入 logcat（可被 adb/系统日志读取）——生产日志脱敏。", note: "logcat 可被 adb 与系统组件读取——敏感数据泄露。" },
  { code: "SOURCE_WEBVIEW_FILE_ACCESS", title: "WebView 启用文件访问", severity: "high", pattern: /setAllowFileAccess\s*\(\s*true\s*\)/i, recommendation: "WebView 不应允许文件访问（setAllowFileAccess(false)）——否则可读本地文件（文件泄露）。", note: "WebView 文件访问可被利用读取应用文件。" },
  { code: "SOURCE_WEBVIEW_JS_BRIDGE_UNSAFE", title: "WebView JS 桥未校验（addJavascriptInterface）", severity: "high", pattern: /addJavascriptInterface\s*\(/i, recommendation: "addJavascriptInterface 需校验来源（shouldOverrideUrlLoading 白名单）——Android 4.1 前有 RCE 历史。", note: "JS 桥未校验时——恶意页面可调用 Java 方法。" },
  { code: "SOURCE_INTENT_EXTRAS_UNVALIDATED", title: "Intent extra 未验证使用", severity: "medium", pattern: /getIntent\s*\(\s*\)\s*[.\n]*\s*\.get(?:String|Int|Boolean)Extra\s*\(/i, recommendation: "Intent extra 来自外部调用方——使用前需校验/默认值（防注入与异常）。", note: "外部 Intent 的 extra 未验证——异常/注入风险。" },
  { code: "SOURCE_HARDCODED_TEST_CONFIG", title: "硬编码测试配置（测试服务器/后门）", severity: "high", pattern: /(?:test\.|staging\.|http:\/\/[0-9.]+)/i, recommendation: "测试/暂存服务器与内网地址不应留在发布构建——核对配置管理。", note: "测试配置/内网地址泄露——发布风险。" },
]

// 扫描项目源码文件（Java/Kotlin——递归——有界）——返回检测到的 finding（失败关闭）。
export async function scanSourceDetectors(projectDir: string): Promise<Finding[]> {
  const findings: Finding[] = []
  const stack = [projectDir]
  let filesScanned = 0
  while (stack.length > 0 && filesScanned < 2000) {
    const dir = stack.pop()!
    let entries: Array<{ name: string; isDirectory(): boolean }>
    try {
      entries = (await readdir(dir, { withFileTypes: true })) as unknown as Array<{ name: string; isDirectory(): boolean }>
    } catch {
      continue
    }
    for (const entry of entries) {
      const full = path.join(dir, entry.name)
      if (entry.isDirectory()) {
        if (!entry.name.startsWith(".") && entry.name !== "build" && entry.name !== ".gradle") stack.push(full)
        continue
      }
      if (!/\.(java|kt)$/.test(entry.name)) continue
      filesScanned += 1
      let content: string
      try {
        content = await readFile(full, "utf8")
      } catch {
        continue
      }
      const relative = path.relative(projectDir, full).replaceAll("\\", "/")
      for (const detector of SOURCE_DETECTORS) {
        if (!detector.pattern.test(content)) continue
        const line = content.split(/\r?\n/).findIndex((l) => detector.pattern.test(l)) + 1
        findings.push({
          severity: detector.severity,
          confidence: "medium",
          code: detector.code,
          title: detector.title,
          detail: `${relative}:${line} ${detector.note}`,
          recommendation: detector.recommendation,
          evidence: `${relative}:${line} -> ${detector.code}`,
        })
      }
    }
  }
  return findings
}
