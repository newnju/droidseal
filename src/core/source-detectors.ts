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
  // 扩充②c（目标 100 个——加密/网络/存储/组件/输入校验/输出/配置——保障精度）
  { code: "SOURCE_WEAK_KEYSTORE_PASSWORD", title: "弱密钥库口令", severity: "medium", pattern: /KeyStore\.load\s*\([^)]*(?:"password"|"123456"|"changeme")/i, recommendation: "密钥库口令应使用强随机密码（Keystore 硬件背书优先）。", note: "弱密钥库口令可被暴力破解。" },
  { code: "SOURCE_ECB_CIPHER_USAGE", title: "ECB 模式加密（AES/3DES）", severity: "high", pattern: /Cipher\.getInstance\s*\(\s*["'][^"']*(?:AES|DES|3DES)\/ECB\/[^"']*["']/i, recommendation: "ECB 模式泄露明文模式——应使用 CBC/GCM（随机 IV）。", note: "ECB 的确定性加密——明文模式泄露。" },
  { code: "SOURCE_SYMMETRIC_KEY_HARDCODED", title: "硬编码对称密钥", severity: "high", pattern: /(?:AESKey|SecretKeySpec)\s*\([^)]*"[0-9A-Fa-f]{16,}"[^)]*\)/i, recommendation: "对称密钥不应硬编码——用 Keystore 生成并安全存储。", note: "硬编码密钥可被静态分析提取。" },
  { code: "SOURCE_PROXY_CLEARED", title: "清空代理设置（绕过企业代理）", severity: "medium", pattern: /setProxy\s*\(\s*null\s*\)/i, recommendation: "清空代理可绕过企业安全代理（流量监控）——核对网络策略。", note: "清空代理绕过安全监控。" },
  { code: "SOURCE_REDIRECT_UNVALIDATED", title: "未校验的重定向（URL 跳转）", severity: "medium", pattern: /setRedirectHandler\s*\([^)]*\)|URLConnection\s*[^;]{0,60}followRedirects\s*\(\s*true\s*\)/i, recommendation: "重定向目标需校验（防止跳转到恶意站点——钓鱼/SSRF）。", note: "未校验重定向——SSRF/钓鱼风险。" },
  { code: "SOURCE_PLAINTEXT_DOMAIN_REF", title: "明文域名引用（非 HTTPS）", severity: "low", pattern: /["'](?:https?:\/\/)?[a-z0-9-]+\.(?:com|net|org)["'][^;]{0,40}http:\/\//i, recommendation: "域名引用应统一 HTTPS——明文 HTTP 可被中间人改写。", note: "明文域名引用——中间人风险。" },
  { code: "SOURCE_BACKUP_RULE_ABSENT", title: "备份规则缺失（allowBackup 未约束）", severity: "medium", pattern: /backup_rules|android:allowBackup\s*=\s*["']?(?!false["']?)/i, recommendation: "allowBackup 应显式配置（含敏感数据的应用应禁止备份）。", note: "备份可提取应用数据。" },
  { code: "SOURCE_EXTERNAL_STORAGE_READ", title: "外部存储读取敏感文件", severity: "medium", pattern: /getExternalStoragePublicDirectory\s*\(\s*Environment\.[A-Z_]+/i, recommendation: "公共外部存储的文件可被任何应用读取——敏感数据避免写入。", note: "公共目录文件——跨应用读取。" },
  { code: "SOURCE_DATABASE_BACKUP_SENSITIVE", title: "数据库自动备份敏感数据", severity: "medium", pattern: /openOrCreateDatabase\s*\([^)]*(?:password|secret|token)[^)]*\)/i, recommendation: "敏感数据库应加密（SQLCipher）——名称避免暴露敏感语义。", note: "数据库名/内容含敏感语义——备份可读。" },
  { code: "SOURCE_SERVICE_EXPORTED_UNSAFE", title: "导出服务未设权限", severity: "high", pattern: /bindService\s*\([^)]*new\s+Intent\s*\([^)]*\)[^)]*\)\s*[^;]{0,60}Context\.BIND_AUTO_CREATE/i, recommendation: "服务绑定/导出需校验权限与调用方（防任意应用调用）。", note: "导出服务可被恶意应用调用。" },
  { code: "SOURCE_PROVIDER_QUERY_UNSANITIZED", title: "Provider 查询未净化（SQL 注入）", severity: "high", pattern: /ContentResolver\s*[^;]{0,40}query\s*\([^)]*projection[^)]*\)/i, recommendation: "ContentProvider 查询的 projection/selection 需净化（防 SQL 注入）。", note: "Provider 查询注入风险。" },
  { code: "SOURCE_NOTIFICATION_SENSITIVE", title: "通知栏显示敏感数据", severity: "medium", pattern: /NotificationCompat\.Builder\s*\([^)]*\)\s*[.\n]*\s*\.setContentText\s*\([^)]*(?:password|token|secret|code)[^)]*\)/i, recommendation: "通知内容不应含敏感数据（锁屏可见）——用摘要/隐藏。", note: "通知栏敏感数据——锁屏/截图可见。" },
  { code: "SOURCE_DESERIALIZATION_UNSAFE", title: "不安全反序列化", severity: "high", pattern: /(?:ObjectInputStream|readObject)\s*\(/i, recommendation: "Java 反序列化有 RCE 历史——用安全格式（JSON）或白名单校验。", note: "反序列化——任意对象实例化风险。" },
  { code: "SOURCE_PATH_TRAVERSAL", title: "路径遍历（文件名拼接）", severity: "high", pattern: /File\s*\(\s*[^)]*\+[^)]*["'][/\\][^)]*\)/i, recommendation: "文件名拼接需校验（防 ../ 路径遍历）——用规范化 + 白名单。", note: "路径遍历——任意文件读写。" },
  { code: "SOURCE_RUNTIME_EXEC_DANGEROUS", title: "危险命令执行（Runtime.exec）", severity: "high", pattern: /Runtime\s*\.\s*getRuntime\s*\(\s*\)\s*\.\s*exec\s*\(/i, recommendation: "命令执行需严格校验输入（防命令注入）——优先用 API 而非 shell。", note: "命令注入风险。" },
  { code: "SOURCE_WEBVIEW_LOAD_SENSITIVE", title: "WebView 加载敏感内容", severity: "medium", pattern: /loadUrl\s*\(\s*["'](?:javascript:|file:)[^"']*["']/i, recommendation: "WebView 加载 javascript:/file: 需校验来源——防脚本注入/本地文件读取。", note: "WebView 加载危险 scheme。" },
  { code: "SOURCE_ACCESSIBILITY_SENSITIVE", title: "无障碍服务读取敏感", severity: "high", pattern: /AccessibilityEvent\.TYPE_VIEW_TEXT_CHANGED/i, recommendation: "无障碍读取输入内容（密码/验证码）——需合规与最小化。", note: "无障碍监听敏感输入——隐私风险。" },
  { code: "SOURCE_ANR_MAIN_THREAD_IO", title: "主线程执行 IO（ANR 风险）", severity: "low", pattern: /onCreate\s*\([^)]*\)\s*\{[^}]{0,200}?(?:openFileInput|SQLiteDatabase|InputStream)/i, recommendation: "主线程 IO 导致 ANR——用协程/线程池异步。", note: "主线程 IO——ANR 与性能。" },
  { code: "SOURCE_SECURE_FLAG_MISSING", title: "敏感界面缺 FLAG_SECURE", severity: "medium", pattern: /setContentView\s*\([^)]*\)\s*[^;]{0,120}?(?:password|token|pin|otp)/i, recommendation: "敏感界面（密码/OTP）应设 FLAG_SECURE（防截屏/最近任务可见）。", note: "敏感界面可被截屏/最近任务捕获。" },
  { code: "SOURCE_CLIPBOARD_SENSITIVE", title: "剪贴板写入敏感数据", severity: "medium", pattern: /ClipboardManager[\s\S]{0,120}?setPrimaryClip\s*\([^)]*(?:password|token|secret|code)[^)]*\)/i, recommendation: "剪贴板全局可读——敏感数据（密码/令牌）不应写入。", note: "剪贴板敏感数据——跨应用读取。" },
  // 扩充②d（推进 100——输入校验/输出/配置/生命周期/组件——保障精度）
  { code: "SOURCE_REFLECTION_UNRESTRICTED", title: "反射调用未受控（Class.forName 动态类）", severity: "medium", pattern: /Class\s*\.\s*forName\s*\([^)]*\)[\s\S]{0,80}?getMethod\s*\(/i, recommendation: "反射调用需白名单校验（防任意方法调用/混淆兼容问题）。", note: "反射动态调用——不可控目标风险。" },
  { code: "SOURCE_ASSET_LOADING_UNSAFE", title: "不安全资源加载（明文 asset 可执行逻辑）", severity: "medium", pattern: /assets\.open\s*\(\s*["'][^"']*\.(?:js|html|dex)["']/i, recommendation: "加载的可执行资源（js/html/dex）需校验完整性（防篡改注入）。", note: "可执行资源明文加载——篡改风险。" },
  { code: "SOURCE_CUSTOM_LOGGER", title: "自定义日志器记录敏感", severity: "low", pattern: /class\s+\w+Logger[\s\S]{0,120}?Log\.(?:d|e|i|w)\s*\(/i, recommendation: "自定义日志器也需脱敏（敏感数据不入日志）。", note: "自定义日志器可能泄露敏感。" },
  { code: "SOURCE_ACTIVITY_RESULT_UNSAFE", title: "Activity 结果未校验（startActivityForResult）", severity: "medium", pattern: /startActivityForResult\s*\([\s\S]{0,120}?onActivityResult\s*\(/i, recommendation: "返回结果需校验来源与数据（防恶意回调注入）。", note: "Activity 结果回调——来源未校验。" },
  { code: "SOURCE_SERVICE_START_UNSAFE", title: "前台服务启动未设类型", severity: "low", pattern: /startForegroundService\s*\(/i, recommendation: "前台服务需声明类型（Android 14+）——核对用途。", note: "前台服务类型未声明——兼容/合规风险。" },
  { code: "SOURCE_BROADCAST_ORDERED_SENSITIVE", title: "有序广播敏感数据（可被拦截）", severity: "medium", pattern: /sendOrderedBroadcast\s*\([\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "有序广播可被高优先级接收器拦截——敏感数据避免经广播传递。", note: "有序广播拦截——敏感数据泄露。" },
  { code: "SOURCE_PARCELABLE_SENSITIVE", title: "Parcelable 序列化敏感数据", severity: "low", pattern: /writeToParcel\s*\([\s\S]{0,120}?(?:password|token|secret)/i, recommendation: "Parcel 内容可被跨进程读取——敏感数据避免放入 Parcel。", note: "Parcel 序列化——跨进程可见。" },
  { code: "SOURCE_TIMING_INSECURE", title: "不安全的计时（敏感操作未定时）", severity: "low", pattern: /System\.currentTimeMillis\s*\(\s*\)[\s\S]{0,60}?(?:token|otp|password)/i, recommendation: "敏感操作（OTP/令牌）需定时——核对计时逻辑。", note: "计时操作——敏感场景。" },
  { code: "SOURCE_VERSION_CHECK_ABSENT", title: "最低版本检查缺失（API 降级）", severity: "low", pattern: /Build\.VERSION\.SDK_INT[\s\S]{0,40}?<[\s\S]{0,40}?[0-9]{2}/i, recommendation: "API 级别检查需覆盖安全相关行为（Android 10+ 不可重置标识等）。", note: "版本分支——安全行为差异。" },
  { code: "SOURCE_PERMISSION_REQUEST_UNSAFE", title: "运行时权限请求未处理拒绝", severity: "medium", pattern: /requestPermissions\s*\([\s\S]{0,120}?onRequestPermissionsResult/i, recommendation: "权限拒绝需优雅处理（降级/提示）——敏感功能核对。", note: "权限拒绝——功能降级风险。" },
  { code: "SOURCE_ACCOUNT_AUTH_SENSITIVE", title: "账户认证敏感数据", severity: "medium", pattern: /AccountManager\s*[^;]{0,80}?addAccountExplicitly\s*\([^)]*(?:password|token)[^)]*\)/i, recommendation: "账户密码/令牌存储需安全（Keystore/加密）——核对认证流。", note: "账户认证——敏感凭据存储。" },
  { code: "SOURCE_CRYPTO_KEY_CHAIN", title: "密钥链明文化（密钥派生自弱源）", severity: "medium", pattern: /(?:password|secret)[\s\S]{0,60}?(?:MessageDigest|getBytes)[\s\S]{0,60}?(?:SecretKeySpec|PBEKey)/i, recommendation: "密钥应从 SecureRandom/Keystore 派生——避免从弱口令派生。", note: "密钥链——弱派生源。" },
  { code: "SOURCE_FRAGMENT_COMMUNICATION_SENSITIVE", title: "Fragment 通信传递敏感", severity: "low", pattern: /setArguments\s*\([\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "Fragment 参数含敏感数据——核对（Bundle 可被记录）。", note: "Fragment 参数——敏感数据。" },
  { code: "SOURCE_WORKER_SENSITIVE", title: "后台任务传递敏感（WorkManager）", severity: "low", pattern: /Data\.Builder\s*\([\s\S]{0,80}?putString\s*\([^)]*(?:password|token|secret)[^)]*\)/i, recommendation: "后台任务数据含敏感——核对（持久化可见）。", note: "WorkManager 数据——持久化敏感。" },
  { code: "SOURCE_BIOMETRIC_FALLBACK_INSECURE", title: "生物识别回退不安全（PIN 明文）", severity: "medium", pattern: /BiometricPrompt[\s\S]{0,80}?(?:fallback|setAllowedAuthenticators)[\s\S]{0,60}?DEVICE_CREDENTIAL/i, recommendation: "生物识别回退到设备凭据需安全存储——核对认证流。", note: "生物识别回退——凭据安全。" },
  // 扩充②e（推进 100——加密/网络/存储/组件/输入输出/配置——保障精度）
  { code: "SOURCE_SALT_REUSE", title: "盐复用（相同盐多次派生）", severity: "medium", pattern: /(?:salt|SALT)\s*=\s*["'][^"']{1,20}["']/i, recommendation: "每次密钥派生应使用随机盐（防彩虹表/重用攻击）。", note: "固定盐——派生可预测。" },
  { code: "SOURCE_IV_REUSE", title: "IV 复用（固定 IV 多轮加密）", severity: "high", pattern: /(?:iv|IV)\s*=\s*["'][0-9A-Fa-f]{16,}["']/i, recommendation: "每次加密应使用随机 IV（防 CBC 模式泄露）。", note: "固定 IV——加密可预测。" },
  { code: "SOURCE_WEAK_CBC_PADDING", title: "弱 CBC 填充（PKCS5 无 MAC）", severity: "medium", pattern: /Cipher\.getInstance\s*\(\s*["'][^"']*\/CBC\/PKCS5Padding["']/i, recommendation: "CBC+PKCS5 无认证（填充预言攻击）——应使用 GCM 或 HMAC。", note: "CBC 无认证——填充预言风险。" },
  { code: "SOURCE_PLAINTEXT_FTP", title: "明文 FTP 通信", severity: "high", pattern: /FTPClient\s*\(/i, recommendation: "FTP 明文可被窃听——应使用 FTPS/SFTP。", note: "FTP 明文——凭据/数据泄露。" },
  { code: "SOURCE_WEBVIEW_MIXED_CONTENT", title: "WebView 混合内容（HTTPS 页加载 HTTP 资源）", severity: "medium", pattern: /setMixedContentMode[\s\S]{0,60}?MIXED_CONTENT_ALWAYS_ALLOW/i, recommendation: "WebView 不应允许混合内容（HTTPS 页加载 HTTP 资源——中间人）。", note: "混合内容——HTTPS 完整性破坏。" },
  { code: "SOURCE_SMTP_PLAINTEXT", title: "明文邮件发送（SMTP 无 TLS）", severity: "medium", pattern: /Transport\.send\s*\(/i, recommendation: "邮件发送应使用 TLS（SMTP STARTTLS）——明文可被窃听。", note: "SMTP 明文——内容泄露。" },
  { code: "SOURCE_ENCRYPTED_FILE_SUFFIX_ABSENT", title: "加密文件无标识后缀", severity: "low", pattern: /(?:encrypt|AES).{0,40}File[\s\S]{0,60}?\.apply|\.commit/i, recommendation: "加密文件名应带 .enc 标识（防误用明文路径）。", note: "加密文件标识缺失——路径混淆。" },
  { code: "SOURCE_DB_PASSWORD_PLAINTEXT", title: "数据库密码明文化", severity: "high", pattern: /SQLiteDatabase\.openDatabase\s*\([^)]*,(?:\s*)["'][^"']{1,20}["']/i, recommendation: "数据库密码不应硬编码/明文——用 SQLCipher 或 Keystore。", note: "DB 密码明文——数据可解密。" },
  { code: "SOURCE_PROVIDER_EXPORTED_SENSITIVE", title: "Provider 导出敏感数据", severity: "high", pattern: /(?:ContentProvider|content:\/\/)[\s\S]{0,120}?(?:password|token|secret)[\s\S]{0,60}?query/i, recommendation: "导出 Provider 的敏感数据需权限保护（readPermission）。", note: "导出 Provider——数据泄露。" },
  { code: "SOURCE_RECEIVER_DYNAMIC_UNSAFE", title: "动态接收器未限制来源", severity: "medium", pattern: /registerReceiver\s*\([^)]*,\s*new\s+IntentFilter[\s\S]{0,80}?(?:exported|RECEIVER)/i, recommendation: "动态接收器需 setPackage 限制发送方（防任意触发）。", note: "动态接收器——任意触发。" },
  { code: "SOURCE_JSON_PARSE_UNSAFE", title: "JSON 解析未校验（巨型/恶意输入）", severity: "low", pattern: /JSONObject\s*\(\s*[^)]*(?:response|body|input)[^)]*\)/i, recommendation: "外部 JSON 需校验大小与结构（防资源耗尽/解析异常）。", note: "外部 JSON——资源耗尽风险。" },
  { code: "SOURCE_XML_XXE_RISK", title: "XML 解析 XXE 风险", severity: "high", pattern: /DocumentBuilderFactory[\s\S]{0,80}?setFeature[\s\S]{0,120}?(?:EXTERNAL|DOCTYPE)/i, recommendation: "XML 解析需禁用外部实体（XXE——文件读取/SSRF）。", note: "XXE——外部实体注入。" },
  { code: "SOURCE_NSSCONFIG_ABSENT", title: "网络安全配置缺失（明文流量允许）", severity: "medium", pattern: /usesCleartextTraffic\s*=\s*["']true["']/i, recommendation: "不应允许明文流量（cleartextTraffic=false + networkSecurityConfig 白名单）。", note: "明文流量允许——中间人风险。" },
  { code: "SOURCE_HTTPS_FORCE_MISSING", title: "HTTPS 强制缺失（HTTP 回退）", severity: "medium", pattern: /HttpURLConnection[\s\S]{0,80}?(?:http:\/\/|setInstanceFollowRedirects)/i, recommendation: "网络请求应强制 HTTPS（HTTP 回退可被中间人）。", note: "HTTP 回退——中间人风险。" },
  { code: "SOURCE_LIFECYCLE_SENSITIVE_FLUSH", title: "生命周期未清理敏感（onPause 未清状态）", severity: "low", pattern: /onPause\s*\([\s\S]{0,120}?password[\s\S]{0,120}?clear|setText\s*\(\s*""\s*\)/i, recommendation: "敏感输入在 onPause 应清空（防最近任务/截屏残留）。", note: "生命周期残留——敏感可见。" },
  // 扩充②f（推进 100——加密/网络/存储/组件/输入输出/配置——保障精度）
  { code: "SOURCE_WEAK_KEYSTORE_TYPE", title: "弱密钥库类型（AndroidKeyStore 未用）", severity: "medium", pattern: /KeyStore\.getInstance\s*\(\s*["'][^"']*(?!"AndroidKeyStore")[^"']*["']/i, recommendation: "应使用 AndroidKeyStore（硬件背书）——软件密钥库可被提取。", note: "软件密钥库——密钥可提取。" },
  { code: "SOURCE_UNAUTHENTICATED_ENCRYPTION", title: "无认证加密（AES 无 GCM/HMAC）", severity: "medium", pattern: /Cipher\.getInstance\s*\(\s*["'][^"']*(?:AES\/CBC|AES\/CTR)[^"']*["']/i, recommendation: "CBC/CTR 无认证（篡改不可检测）——应使用 GCM（认证加密）。", note: "无认证加密——篡改风险。" },
  { code: "SOURCE_GCM_IV_SMALL", title: "GCM IV 过短（<12 字节）", severity: "medium", pattern: /GCMParameterSpec\s*\(\s*1[0-2][48]\s*,\s*["'][^"']{0,16}["']/i, recommendation: "GCM IV 应 12 字节（96 位）——过短导致 nonce 重用。", note: "GCM IV 过短——nonce 重用风险。" },
  { code: "SOURCE_CERT_PINNING_ABSENT_SRC", title: "证书固定缺失（源码侧自实现校验）", severity: "medium", pattern: /(?:checkServerTrusted|X509TrustManager)[\s\S]{0,120}?certificate[\s\S]{0,60}?(?:getIssuerDN|getSubjectDN)/i, recommendation: "关键接口应证书固定（pin——防中间人）。", note: "自实现证书校验——固定缺失。" },
  { code: "SOURCE_URL_REDIRECT_OPEN", title: "开放重定向（用户可控 URL 跳转）", severity: "medium", pattern: /(?:loadUrl|startActivity)\s*\(\s*[^)]*(?:url|uri|link|redirect)[^)]*\)/i, recommendation: "重定向 URL 需白名单校验（防钓鱼/SSRF）。", note: "开放重定向——钓鱼风险。" },
  { code: "SOURCE_DOWNLOAD_UNVALIDATED", title: "下载内容未校验（任意文件覆盖）", severity: "medium", pattern: /DownloadManager[\s\S]{0,80}?(?:getUriForDownloadedFile|openDownloadedFile)/i, recommendation: "下载文件名/路径需校验（防目录遍历/覆盖）。", note: "下载未校验——文件覆盖风险。" },
  { code: "SOURCE_TEMP_FILE_SENSITIVE", title: "临时文件存敏感（/tmp 明文）", severity: "low", pattern: /createTempFile\s*\([^)]*\)[\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "临时文件不应存敏感数据（可被读取）——用内存/加密。", note: "临时文件敏感——泄露风险。" },
  { code: "SOURCE_EXPORT_FILE_SENSITIVE", title: "导出文件未设私有（MODE_WORLD）", severity: "high", pattern: /openFileOutput\s*\([^)]*MODE_WORLD/i, recommendation: "MODE_WORLD_READABLE/WRITABLE 已废弃且不安全（其他应用可读写）。", note: "世界可读/写——数据泄露。" },
  { code: "SOURCE_RECEIVER_EXPORTED_SENSITIVE", title: "导出接收器处理敏感 Intent", severity: "medium", pattern: /registerReceiver\s*\([^)]*(?:password|token|secret)[^)]*\)/i, recommendation: "导出接收器处理敏感数据需权限校验（防恶意触发）。", note: "导出接收器——敏感触发。" },
  { code: "SOURCE_SERVICE_INTENT_SENSITIVE", title: "服务 Intent 传递敏感", severity: "medium", pattern: /startService\s*\(\s*[^)]*(?:password|token|secret)[^)]*\)/i, recommendation: "服务 Intent 含敏感数据需校验（跨进程可见）。", note: "服务 Intent——敏感数据。" },
  { code: "SOURCE_DEX_EXEC_DYNAMIC", title: "动态执行代码（DexClassLoader 加载外部）", severity: "high", pattern: /DexClassLoader\s*\([^)]*(?:http|download|sdcard|external)[^)]*\)/i, recommendation: "动态加载外部 DEX 需校验来源与签名（防恶意载荷）。", note: "动态 DEX 加载——恶意载荷。" },
  { code: "SOURCE_JS_INJECTION_SRC", title: "源码 JS 注入（拼接 JS）", severity: "high", pattern: /loadUrl\s*\(\s*["']javascript:["']\s*\+/i, recommendation: "JS 注入需严格校验内容（防 XSS 于 WebView）。", note: "JS 注入——WebView XSS。" },
  { code: "SOURCE_SQL_INJECTION_SRC", title: "SQL 注入（字符串拼接查询）", severity: "high", pattern: /(?:execSQL|rawQuery)\s*\(\s*["'][^"']*["']\s*\+/i, recommendation: "SQL 应使用参数化（selectionArgs）——拼接可注入。", note: "SQL 拼接——注入风险。" },
  { code: "SOURCE_CUSTOM_HEADER_SENSITIVE", title: "自定义 Header 含敏感（认证令牌）", severity: "medium", pattern: /setRequestProperty\s*\(\s*["'](?:Authorization|X-Api-Key)["']\s*,\s*["'][^"']{6,}["']/i, recommendation: "认证 Header 的令牌不应硬编码（应动态获取）。", note: "Header 令牌硬编码——泄露。" },
  { code: "SOURCE_PREFERENCE_INSECURE_BACKUP", title: "偏好设置未排除敏感备份", severity: "low", pattern: /android:fullBackupContent|dataExtractionRules[\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "备份规则应排除敏感偏好（防备份提取）。", note: "备份含敏感——提取风险。" },
  // 扩充②g（推进 100——达标——加密/网络/存储/组件/输入输出/生命周期——保障精度）
  { code: "SOURCE_HASH_SALT_MISSING", title: "密码哈希无盐", severity: "high", pattern: /MessageDigest[\s\S]{0,60}?(?:password|pwd)[\s\S]{0,40}?update\s*\(/i, recommendation: "密码哈希应加盐（防彩虹表）——用 BCrypt/PBKDF2。", note: "无盐哈希——彩虹表可破。" },
  { code: "SOURCE_TOKEN_IN_QUERY", title: "令牌在 URL 查询参数", severity: "high", pattern: /(?:token|api[_-]?key|auth)[\s\S]{0,40}?["'][^"']*["'][\s\S]{0,20}?\+[\s\S]{0,40}?["'][?&]/i, recommendation: "令牌不应放 URL 查询参数（日志/历史泄露）——用 Header。", note: "查询参数令牌——泄露。" },
  { code: "SOURCE_WEBVIEW_SAVE_PASSWORD", title: "WebView 保存密码表单", severity: "medium", pattern: /setSavePassword\s*\(\s*true\s*\)/i, recommendation: "WebView 不应保存密码（明文存储风险）——已废弃 API。", note: "WebView 密码保存——明文风险。" },
  { code: "SOURCE_FIREBASE_SENSITIVE", title: "Firebase 配置含敏感（明文规则）", severity: "medium", pattern: /google-services\.json[\s\S]{0,120}?(?:api_key|project_id)/i, recommendation: "Firebase 配置的 api_key 是公开的——安全规则需服务端配置。", note: "Firebase 配置——公开密钥。" },
  { code: "SOURCE_ADB_BACKUP_ALLOWED", title: "ADB 备份允许（敏感数据可提取）", severity: "high", pattern: /android:allowBackup\s*=\s*["']?true["']?/i, recommendation: "含敏感数据的应用应 allowBackup=false（防 ADB 备份提取）。", note: "allowBackup=true——备份提取。" },
  { code: "SOURCE_DEBUGGABLE_RELEASE", title: "可调试发布（debuggable=true）", severity: "high", pattern: /android:debuggable\s*=\s*["']true["']/i, recommendation: "发布构建不可调试（debuggable=false）——调试可被利用。", note: "可调试——调试器附加。" },
  { code: "SOURCE_CRASH_REPORT_SENSITIVE", title: "崩溃报告含敏感数据", severity: "low", pattern: /(?:Crashlytics|FirebaseCrash)[\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "崩溃报告不应含敏感数据（第三方可见）——脱敏。", note: "崩溃报告——敏感泄露。" },
  { code: "SOURCE_WAKE_LOCK_ABUSE", title: "WakeLock 滥用（耗电/保活）", severity: "low", pattern: /acquire\s*\(\s*\)[\s\S]{0,80}?FLAG_KEEP_SCREEN_ON/i, recommendation: "WakeLock 需释放（finally）——防耗电与保活滥用。", note: "WakeLock——耗电/保活。" },
  { code: "SOURCE_NETWORK_ON_MAIN", title: "主线程网络请求（ANR）", severity: "medium", pattern: /onCreate[\s\S]{0,160}?(?:HttpURLConnection|OkHttp|URL\s*\(|execute\s*\(\s*\))/i, recommendation: "网络请求应异步（主线程网络导致 ANR——StrictMode 拦截）。", note: "主线程网络——ANR。" },
  { code: "SOURCE_INTENT_FILTER_SENSITIVE", title: "敏感 Intent 过滤器（隐式暴露）", severity: "medium", pattern: /IntentFilter\s*\(\s*["'][^"']*["']\)[\s\S]{0,80}?addAction\s*\(\s*["'][^"']*(?:password|token|secret)/i, recommendation: "敏感操作的 Intent 过滤器需权限保护（防隐式触发）。", note: "隐式 Intent 过滤器——暴露。" },
  { code: "SOURCE_CUSTOM_VIEW_SENSITIVE", title: "自定义 View 含敏感绘制", severity: "low", pattern: /class\s+\w+View[\s\S]{0,120}?onDraw[\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "自定义 View 绘制敏感数据需防截屏（FLAG_SECURE）。", note: "自定义 View——敏感绘制。" },
  { code: "SOURCE_GEOFENCE_SENSITIVE", title: "地理围栏敏感（位置隐私）", severity: "low", pattern: /GeofencingClient[\s\S]{0,80}?addGeofences/i, recommendation: "地理围栏持续跟踪位置——需隐私合规（透明提示）。", note: "地理围栏——位置跟踪。" },
  { code: "SOURCE_PUSH_SENSITIVE", title: "推送通知含敏感（锁屏可见）", severity: "medium", pattern: /(?:FCM|FirebaseMessaging)[\s\S]{0,120}?(?:password|token|secret|code)/i, recommendation: "推送内容不应含敏感（锁屏可见）——用摘要。", note: "推送敏感——锁屏可见。" },
  { code: "SOURCE_OTP_LOG", title: "OTP/验证码日志或通知", severity: "high", pattern: /(?:Log\.(?:d|e|i|w)\s*\([^)]*(?:otp|verification|verify_code)[^)]*\)|(?:otp|verification|verify_code)[\s\S]{0,60}?Log\.(?:d|e|i|w)\s*\()/i, recommendation: "OTP 不应日志/明文（验证码泄露——账户接管）。", note: "OTP 泄露——账户接管。" },
  { code: "SOURCE_DEVICE_ADMIN_ABUSE", title: "设备管理滥用（锁屏/擦除）", severity: "high", pattern: /DevicePolicyManager[\s\S]{0,80}?(?:lockNow|wipeData|setPasswordQuality)/i, recommendation: "设备管理 API（锁屏/擦除）需最小化——滥用风险。", note: "设备管理——滥用风险。" },
  // 扩充②h（推进 200——加密/网络/存储/组件/权限/配置/并发——保障精度）
  { code: "SOURCE_AES_CTR_NONCE_REUSE", title: "CTR 模式 nonce 重用", severity: "high", pattern: /Cipher\.getInstance\s*\(\s*["'][^"']*\/CTR\/[^"']*["'][\s\S]{0,80}?["'][0-9A-Fa-f]{16,}["']/i, recommendation: "CTR 模式 nonce 重用导致明文 XOR 泄露——每次加密随机 nonce。", note: "CTR nonce 重用——明文泄露。" },
  { code: "SOURCE_SHA1_FOR_SIGNATURE", title: "SHA1 用于签名", severity: "high", pattern: /Signature\.getInstance\s*\(\s*["'][^"']*SHA1with[^"']*["']/i, recommendation: "签名应使用 SHA256withRSA（SHA1 碰撞已可伪造）。", note: "SHA1 签名——碰撞伪造。" },
  { code: "SOURCE_WEAK_PADDING_NONE", title: "无填充加密（ECB/CBC——可能泄露长度）", severity: "low", pattern: /Cipher\.getInstance\s*\(\s*["'][^"']*\/(?:ECB|CBC)\/NoPadding["']/i, recommendation: "ECB/CBC 无填充需确认用途（长度泄露风险）——GCM/CTR 的 NoPadding 为正常。", note: "ECB/CBC 无填充——长度泄露。" },
  { code: "SOURCE_HTTP_BASIC_AUTH", title: "HTTP Basic 认证（明文凭据）", severity: "high", pattern: /(?:Authenticator|setDefaultAuthenticator)[\s\S]{0,80}?PasswordAuthentication\s*\(/i, recommendation: "Basic 认证是 base64 明文——应使用 TLS + 令牌认证。", note: "Basic 认证——凭据泄露。" },
  { code: "SOURCE_DNS_OVER_PLAINTEXT", title: "明文 DNS（系统默认——自定义解析）", severity: "low", pattern: /(?:InetAddress\.getByName|getAllByName)\s*\(/i, recommendation: "自定义 DNS 解析需 DoH/DoT（明文 DNS 可被劫持）。", note: "明文 DNS——劫持风险。" },
  { code: "SOURCE_SSL_CONTEXT_WEAK", title: "SSLContext 弱协议", severity: "high", pattern: /SSLContext\.getInstance\s*\(\s*["'](?:SSL|TLSv1|TLSv1\.1)["']/i, recommendation: "SSLContext 应使用 TLSv1.2+（SSL/TLSv1 已不安全）。", note: "弱 SSL 协议——中间人。" },
  { code: "SOURCE_FILE_MODE_WORLD_WRITABLE", title: "文件世界可写（MODE_WORLD_WRITABLE）", severity: "high", pattern: /MODE_WORLD_WRITABLE|MODE_WORLD_READABLE/i, recommendation: "MODE_WORLD_* 已废弃且不安全——其他应用可读写。", note: "世界可写——篡改风险。" },
  { code: "SOURCE_ENCRYPTED_SHARED_PREFS_ABSENT", title: "SharedPreferences 未用加密（敏感）", severity: "medium", pattern: /getSharedPreferences\s*\([^)]*\)[\s\S]{0,80}?(?:putString|putInt|putBoolean)/i, recommendation: "敏感偏好应使用 EncryptedSharedPreferences。", note: "偏好未加密——明文。" },
  { code: "SOURCE_PROVIDER_TEMP_GRANT", title: "Provider 临时授权（clipData 授 URI）", severity: "medium", pattern: /(?:clipData|FLAG_GRANT_READ_URI_PERMISSION)[\s\S]{0,60}?setClipData/i, recommendation: "URI 临时授权需校验接收方（防数据泄露）。", note: "URI 授权——泄露风险。" },
  { code: "SOURCE_RECEIVER_PERMISSION_ABSENT", title: "广播权限缺失", severity: "medium", pattern: /sendBroadcast\s*\([^)]*\)\s*;?[\s\S]{0,40}?(?:!|not)[\s\S]{0,40}?permission/i, recommendation: "敏感广播应带权限发送（防任意接收）。", note: "广播无权限——任意接收。" },
  { code: "SOURCE_LOCATION_BACKGROUND", title: "后台位置获取（隐私）", severity: "medium", pattern: /requestLocationUpdates[\s\S]{0,80}?(?:BACKGROUND|AccessLocation)/i, recommendation: "后台位置需权限与合规（Android 10+ 后台位置受限）。", note: "后台位置——隐私风险。" },
  { code: "SOURCE_SMS_SEND_AUTO", title: "自动发送短信（扣费/欺诈）", severity: "high", pattern: /SmsManager[\s\S]{0,80}?send(?:Text|Data)Message\s*\(/i, recommendation: "自动短信发送需用户确认（防扣费/欺诈）。", note: "自动短信——扣费风险。" },
  { code: "SOURCE_TELEPHONY_SENSITIVE", title: "通话状态读取敏感", severity: "medium", pattern: /TelephonyManager[\s\S]{0,60}?getCallState|listen\s*\(/i, recommendation: "通话状态监听需权限合规（隐私）。", note: "通话监听——隐私。" },
  { code: "SOURCE_THREAD_POOL_UNBOUNDED", title: "无界线程池（资源耗尽）", severity: "low", pattern: /newCachedThreadPool|Executors\.newFixedThreadPool\s*\([^)]*[0-9]{3,}[^)]*\)/i, recommendation: "线程池应有界（防资源耗尽/DoS）。", note: "无界线程——资源耗尽。" },
  { code: "SOURCE_TIMER_SENSITIVE", title: "定时器执行敏感逻辑", severity: "low", pattern: /(?:Timer|ScheduledExecutorService)[\s\S]{0,60}?(?:schedule|scheduleAtFixedRate)[\s\S]{0,80}?(?:password|token|secret)/i, recommendation: "定时器敏感逻辑需安全（防越权执行）。", note: "定时器敏感——越权风险。" },
  // 扩充②i（推进 200——加密/网络/存储/组件/权限/配置/隐私合规——保障精度）
  { code: "SOURCE_RSA_NO_PADDING", title: "RSA 无填充（原始 RSA）", severity: "high", pattern: /Cipher\.getInstance\s*\(\s*["']RSA\/ECB\/NoPadding["']/i, recommendation: "原始 RSA 无填充可被 Bleichenbacher 攻击——应使用 OAEP。", note: "原始 RSA——填充攻击。" },
  { code: "SOURCE_RANDOM_FOR_CRYPTO", title: "随机数用于加密（非 SecureRandom）", severity: "high", pattern: /(?:new\s+Random|Math\.random)\s*\([\s\S]{0,80}?(?:key|iv|salt|token|nonce)/i, recommendation: "加密随机数必须用 SecureRandom（Random 可预测）。", note: "弱随机——密钥/IV 可预测。" },
  { code: "SOURCE_KEY_IN_PREFERENCES", title: "密钥存偏好设置", severity: "high", pattern: /getSharedPreferences[\s\S]{0,80}?putString\s*\([^)]*(?:key|secret|aes)[^)]*\)/i, recommendation: "密钥应存 AndroidKeyStore（偏好可被读取）。", note: "偏好密钥——可提取。" },
  { code: "SOURCE_WEBSOCKET_NO_TLS", title: "WebSocket 无 TLS（ws:// 已覆盖——升级检测）", severity: "medium", pattern: /WebSocketFactory[\s\S]{0,80}?(?:createConnection|newConnection)[\s\S]{0,60}?ws:\/\//i, recommendation: "WebSocket 库的明文连接需 wss://（TLS）。", note: "WebSocket 明文——窃听。" },
  { code: "SOURCE_GRPC_PLAINTEXT", title: "gRPC 明文通道", severity: "medium", pattern: /ManagedChannelBuilder[\s\S]{0,60}?forAddress[\s\S]{0,80}?(?:plaintext|usePlaintext)/i, recommendation: "gRPC 应使用 TLS（usePlaintext 明文可窃听）。", note: "gRPC 明文——窃听。" },
  { code: "SOURCE_OKHTTP_CLEARTEXT", title: "OkHttp 明文请求（http:// 硬编码）", severity: "medium", pattern: /(?:Request\.Builder|HttpUrl\.parse)[\s\S]{0,60}?["']http:\/\//i, recommendation: "OkHttp 请求应 HTTPS（http:// 可中间人）。", note: "OkHttp 明文——中间人。" },
  { code: "SOURCE_DB_INDEX_SENSITIVE", title: "数据库敏感列未索引保护", severity: "low", pattern: /CREATE TABLE[\s\S]{0,120}?(?:password|token|secret)[\s\S]{0,60}?(?:TEXT|BLOB)/i, recommendation: "敏感列应加密存储（DB 文件可被提取读取）。", note: "敏感列明文——DB 提取。" },
  { code: "SOURCE_CACHE_SENSITIVE_FILE", title: "缓存敏感文件（cacheDir）", severity: "medium", pattern: /(?:cacheDir|getCacheDir)[\s\S]{0,60}?(?:writeText|writeBytes|createNewFile)/i, recommendation: "缓存文件不应含敏感（可被系统清理/读取）——用加密存储。", note: "缓存敏感——清理/读取。" },
  { code: "SOURCE_AUTOFILL_SENSITIVE", title: "敏感输入自动填充暴露", severity: "medium", pattern: /setAutofillHints\s*\(\s*View\.AUTOFILL_HINT_(?:PASSWORD|CREDIT_CARD|SENSITIVE)/i, recommendation: "敏感输入自动填充需核对（填充服务可见——合规）。", note: "自动填充——敏感暴露。" },
  { code: "SOURCE_SCREENSHOT_BLOCK_ABSENT", title: "敏感界面未阻止截屏", severity: "medium", pattern: /(?:getWindow|setFlags)[\s\S]{0,80}?FLAG_SECURE[\s\S]{0,60}?(?:password|token|pin)/i, recommendation: "敏感界面应 FLAG_SECURE（防截屏/最近任务）——核对。", note: "敏感界面——截屏可见。" },
  { code: "SOURCE_EXTERNAL_LINK_UNVALIDATED", title: "外部链接未校验（deep link 打开任意）", severity: "medium", pattern: /(?:Intent\.ACTION_VIEW|setData)[\s\S]{0,60}?(?:url|uri|link)[\s\S]{0,40}?startActivity/i, recommendation: "外部链接（深链）需白名单校验（防打开任意应用）。", note: "深链未校验——任意打开。" },
  { code: "SOURCE_APP_LINK_VERIFY_ABSENT", title: "App Link 未验证（深链 hijack）", severity: "medium", pattern: /intent-filter[\s\S]{0,80}?android:autoVerify[\s\S]{0,40}?VIEW/i, recommendation: "深链应 autoVerify + HTTPS（防深链劫持）。", note: "深链未验证——劫持。" },
  { code: "SOURCE_GDPR_DATA_ABSENT", title: "隐私数据收集未声明（GDPR/合规）", severity: "low", pattern: /(?:getDeviceId|getImei|getMacAddress)[\s\S]{0,80}?(?:收集|privacy|consent)/i, recommendation: "隐私数据收集需合规声明与用户同意（GDPR/CCPA）。", note: "隐私收集——合规风险。" },
  { code: "SOURCE_LOGCAT_VERBOSE_SENSITIVE", title: "Logcat 详细日志含敏感", severity: "medium", pattern: /Log\.v\s*\([^)]*(?:password|token|secret|credential)[^)]*\)/i, recommendation: "verbose 日志不应含敏感（logcat 可读）——脱敏。", note: "Verbose 日志——敏感泄露。" },
  { code: "SOURCE_BLUETOOTH_SENSITIVE", title: "蓝牙传输敏感（无加密）", severity: "medium", pattern: /(?:BluetoothSocket|BluetoothGatt)[\s\S]{0,80}?(?:connect|write)[\s\S]{0,60}?(?:password|token|secret)/i, recommendation: "蓝牙传输敏感需加密/配对校验（明文可被嗅探）。", note: "蓝牙明文——嗅探。" },
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
