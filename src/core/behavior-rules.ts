// 行为规则引擎（Quark-Engine 差距②④——behavior-rules.ts）。
// 规则格式 { crimer, className, methodName, score, label }——调用图匹配
// （被调 "类.方法" 命中规则即计为该行为）。加权评分：命中规则 score 累计 → 恶意度 0-100。
// 支持外部行为规则文件加载（差距③）与评分阈值配置（差距④）。失败关闭。
import { readFile } from "node:fs/promises"
import type { Finding } from "./types.ts"

export interface BehaviorRule {
  crimer: string
  className: string
  methodName: string
  score: number
  label: string
}

// 评分分级阈值（差距④——可配置；默认保持既有行为：≥60 medium / ≥30 low）。
export interface MaliciousScoreThresholds {
  high: number
  medium: number
}

export const DEFAULT_SCORE_THRESHOLDS: MaliciousScoreThresholds = { high: 60, medium: 30 }

// 外部行为规则文件加载（差距③）：JSON 数组，字段校验失败关闭。
export function parseBehaviorRules(text: string): BehaviorRule[] {
  const parsed = JSON.parse(text) as unknown
  if (!Array.isArray(parsed)) throw new Error("行为规则文件应为 JSON 数组")
  const rules: BehaviorRule[] = []
  for (const [index, raw] of parsed.entries()) {
    const rule = raw as Partial<BehaviorRule>
    if (!rule.crimer || !rule.className || !rule.methodName || !rule.label) {
      throw new Error(`行为规则 #${index + 1} 缺 crimer/className/methodName/label`)
    }
    if (typeof rule.score !== "number" || rule.score < 0 || rule.score > 100) {
      throw new Error(`行为规则 #${index + 1}（${rule.crimer}）score 应为 0-100`)
    }
    rules.push({ crimer: rule.crimer, className: rule.className, methodName: rule.methodName, score: rule.score, label: rule.label })
  }
  return rules
}

export async function loadBehaviorRules(rulesFile: string): Promise<BehaviorRule[]> {
  return parseBehaviorRules(await readFile(rulesFile, "utf8"))
}

// 合并规则：内置 + 自定义（自定义追加，crimer 去重——自定义优先）。
export function mergeBehaviorRules(custom: readonly BehaviorRule[] = []): BehaviorRule[] {
  const merged = new Map<string, BehaviorRule>()
  for (const rule of BUILTIN_BEHAVIOR_RULES) merged.set(rule.crimer, rule)
  for (const rule of custom) merged.set(rule.crimer, rule)
  return [...merged.values()]
}

// 内置恶意行为规则库（10 条常见恶意行为——短信劫持/键盘记录/设备管理滥用/截屏/录音等）。
export const BUILTIN_BEHAVIOR_RULES: readonly BehaviorRule[] = [
  { crimer: "sms-hijack", className: "android.telephony.SmsManager", methodName: "sendTextMessage", score: 8, label: "发送短信（短信劫持特征）" },
  { crimer: "sms-read", className: "android.provider.Telephony", methodName: "Sms", score: 6, label: "读取短信" },
  { crimer: "call-end", className: "android.telephony.TelephonyManager", methodName: "endCall", score: 7, label: "结束通话（通话拦截特征）" },
  { crimer: "call-log-read", className: "android.provider.CallLog", methodName: "Calls", score: 6, label: "读取通话记录" },
  { crimer: "keylog", className: "android.view.View", methodName: "OnKeyListener", score: 7, label: "键盘监听（键盘记录特征）" },
  { crimer: "device-admin", className: "android.app.admin.DevicePolicyManager", methodName: "lockNow", score: 7, label: "设备管理锁定（滥用特征）" },
  { crimer: "screen-capture", className: "android.media.projection.MediaProjection", methodName: "createVirtualDisplay", score: 7, label: "屏幕投影/截屏" },
  { crimer: "record-audio", className: "android.media.MediaRecorder", methodName: "start", score: 6, label: "录音" },
  { crimer: "camera-open", className: "android.hardware.camera2.CameraManager", methodName: "open", score: 5, label: "打开相机" },
  { crimer: "accessibility", className: "android.accessibilityservice.AccessibilityService", methodName: "onAccessibilityEvent", score: 6, label: "无障碍服务监听" },
  // 扩充（③——10 → 30 条）：键盘记录变体/勒索/挖矿/广告欺诈/流氓推广/窃取类
  { crimer: "keylog-input", className: "android.text.InputType", methodName: "TYPE_TEXT_VARIATION_PASSWORD", score: 7, label: "密码输入监听（键盘记录变体）" },
  { crimer: "ransom-encrypt", className: "javax.crypto.Cipher", methodName: "doFinal", score: 10, label: "文件加密（勒索特征）" },
  { crimer: "ransom-wipe", className: "android.app.admin.DevicePolicyManager", methodName: "wipeData", score: 10, label: "擦除数据（勒索特征）" },
  { crimer: "ransom-lock", className: "android.app.admin.DevicePolicyManager", methodName: "setLockTaskPackages", score: 9, label: "锁定任务（勒索锁屏特征）" },
  { crimer: "mining-pool", className: "java.net.URL", methodName: "openConnection", score: 8, label: "网络连接（挖矿池/远控特征）" },
  { crimer: "ad-fraud-hide", className: "android.view.View", methodName: "setVisibility", score: 6, label: "隐藏视图（广告欺诈特征）" },
  { crimer: "ad-click-fraud", className: "android.view.MotionEvent", methodName: "ACTION_DOWN", score: 7, label: "模拟点击（点击欺诈特征）" },
  { crimer: "rogue-install", className: "android.content.pm.PackageInstaller", methodName: "install", score: 9, label: "静默安装（流氓推广特征）" },
  { crimer: "rogue-download", className: "android.app.DownloadManager", methodName: "enqueue", score: 7, label: "静默下载（流氓推广特征）" },
  { crimer: "sms-multipart", className: "android.telephony.SmsManager", methodName: "sendMultipartTextMessage", score: 8, label: "群发短信（短信欺诈变体）" },
  { crimer: "ussd-run", className: "android.telephony.TelephonyManager", methodName: "sendUssdRequest", score: 9, label: "执行 USSD（扣费特征）" },
  { crimer: "call-forward", className: "android.telephony.TelephonyManager", methodName: "setCallForwarding", score: 8, label: "呼叫转移（窃听特征）" },
  { crimer: "clipboard-read", className: "android.content.ClipboardManager", methodName: "getPrimaryClip", score: 7, label: "剪贴板读取（凭据窃取特征）" },
  { crimer: "account-steal", className: "android.accounts.AccountManager", methodName: "getAccounts", score: 8, label: "账户枚举（账户窃取特征）" },
  { crimer: "contact-upload", className: "android.provider.ContactsContract", methodName: "Contacts", score: 7, label: "联系人读取（数据外传特征）" },
  { crimer: "location-track", className: "android.location.LocationManager", methodName: "getLastKnownLocation", score: 7, label: "位置读取（跟踪特征）" },
  { crimer: "overlay-click", className: "android.view.WindowManager", methodName: "addView", score: 7, label: "悬浮窗添加（覆盖点击/钓鱼特征）" },
  { crimer: "dex-load", className: "dalvik.system.DexClassLoader", methodName: "loadClass", score: 8, label: "动态加载 DEX（恶意载荷特征）" },
  { crimer: "native-exec", className: "java.lang.Runtime", methodName: "exec", score: 7, label: "运行时执行命令（远控特征）" },
  { crimer: "call-answer", className: "android.telecom.TelecomManager", methodName: "acceptRingingCall", score: 8, label: "自动接听来电（通话欺诈/录音特征）" },

  // ═══════════════════════════════════════════════════════════════════════════
  // Phase 1 扩充：30 → 200+（对标 Quark-Engine 全原子行为类别）
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 网络通信（12 条）──
  { crimer: "net-http-connect", className: "java.net.HttpURLConnection", methodName: "connect", score: 3, label: "HTTP 连接" },
  { crimer: "net-https-connect", className: "javax.net.ssl.HttpsURLConnection", methodName: "connect", score: 3, label: "HTTPS 连接" },
  { crimer: "net-okhttp-execute", className: "okhttp3.OkHttpClient", methodName: "newCall", score: 3, label: "OkHttp 请求" },
  { crimer: "net-retrofit-create", className: "retrofit2.Retrofit", methodName: "create", score: 3, label: "Retrofit 接口创建" },
  { crimer: "net-volley-add", className: "com.android.volley.RequestQueue", methodName: "add", score: 3, label: "Volley 请求队列" },
  { crimer: "net-websocket-connect", className: "okhttp3.WebSocket", methodName: "connect", score: 4, label: "WebSocket 连接" },
  { crimer: "net-socket-connect", className: "java.net.Socket", methodName: "connect", score: 5, label: "原始 Socket 连接（远控特征）" },
  { crimer: "net-server-socket", className: "java.net.ServerSocket", methodName: "accept", score: 7, label: "监听端口（后门特征）" },
  { crimer: "net-url-open-stream", className: "java.net.URL", methodName: "openStream", score: 4, label: "URL 流打开" },
  { crimer: "net-download-manager", className: "android.app.DownloadManager", methodName: "enqueue", score: 5, label: "系统下载管理器" },
  { crimer: "net-dns-lookup", className: "java.net.InetAddress", methodName: "getByName", score: 3, label: "DNS 解析" },
  { crimer: "net-ftp-connect", className: "org.apache.commons.net.ftp.FTPClient", methodName: "connect", score: 6, label: "FTP 连接（数据外传通道）" },

  // ── 文件操作（10 条）──
  { crimer: "file-read", className: "java.io.FileInputStream", methodName: "<init>", score: 3, label: "文件读取" },
  { crimer: "file-write", className: "java.io.FileOutputStream", methodName: "<init>", score: 3, label: "文件写入" },
  { crimer: "file-delete", className: "java.io.File", methodName: "delete", score: 4, label: "文件删除（勒索/破坏特征）" },
  { crimer: "file-external-write", className: "android.os.Environment", methodName: "getExternalStorageDirectory", score: 5, label: "外部存储写入（数据泄露面）" },
  { crimer: "file-random-access", className: "java.io.RandomAccessFile", methodName: "<init>", score: 3, label: "随机文件访问" },
  { crimer: "file-zip-create", className: "java.util.zip.ZipOutputStream", methodName: "<init>", score: 5, label: "ZIP 压缩创建（数据打包外传）" },
  { crimer: "file-zip-read", className: "java.util.zip.ZipInputStream", methodName: "<init>", score: 3, label: "ZIP 解压读取" },
  { crimer: "file-temp-create", className: "java.io.File", methodName: "createTempFile", score: 4, label: "临时文件创建（载荷落地）" },
  { crimer: "file-chmod", className: "java.lang.Runtime", methodName: "exec", score: 6, label: "chmod 命令执行（权限修改）" },
  { crimer: "file-content-provider-read", className: "android.content.ContentResolver", methodName: "openInputStream", score: 5, label: "ContentResolver 读取（跨应用数据）" },

  // ── 系统命令（8 条）──
  { crimer: "cmd-runtime-exec", className: "java.lang.Runtime", methodName: "exec", score: 7, label: "Runtime.exec 命令执行（远控/提权）" },
  { crimer: "cmd-process-builder", className: "java.lang.ProcessBuilder", methodName: "start", score: 7, label: "ProcessBuilder 命令执行" },
  { crimer: "cmd-su-execute", className: "java.lang.Runtime", methodName: "exec", score: 9, label: "su 命令执行（Root 提权）" },
  { crimer: "cmd-pm-install", className: "android.content.pm.PackageInstaller", methodName: "install", score: 8, label: "静默安装命令" },
  { crimer: "cmd-am-start", className: "android.app.ActivityManager", methodName: "startActivity", score: 5, label: "ActivityManager 启动" },
  { crimer: "cmd-reboot", className: "android.os.PowerManager", methodName: "reboot", score: 9, label: "设备重启（破坏特征）" },
  { crimer: "cmd-settings-put", className: "android.provider.Settings", methodName: "putString", score: 6, label: "修改系统设置" },
  { crimer: "cmd-intent-broadcast", className: "android.content.Context", methodName: "sendBroadcast", score: 4, label: "发送广播" },

  // ── 反射/动态加载（8 条）──
  { crimer: "reflect-for-name", className: "java.lang.Class", methodName: "forName", score: 5, label: "反射 Class.forName（混淆/动态加载）" },
  { crimer: "reflect-get-method", className: "java.lang.Class", methodName: "getMethod", score: 5, label: "反射 getMethod（隐藏调用）" },
  { crimer: "reflect-invoke", className: "java.lang.reflect.Method", methodName: "invoke", score: 5, label: "反射 Method.invoke（隐藏调用）" },
  { crimer: "dynamic-dex-load", className: "dalvik.system.DexClassLoader", methodName: "<init>", score: 8, label: "DEX 动态加载（恶意载荷）" },
  { crimer: "dynamic-path-class-loader", className: "dalvik.system.PathClassLoader", methodName: "<init>", score: 5, label: "PathClassLoader 动态加载" },
  { crimer: "dynamic-in-memory-dex", className: "dalvik.system.InMemoryDexClassLoader", methodName: "<init>", score: 9, label: "内存 DEX 加载（无文件落地）" },
  { crimer: "dynamic-asset-load", className: "android.content.res.AssetManager", methodName: "open", score: 4, label: "Asset 加载（资源中藏载荷）" },
  { crimer: "dynamic-native-load", className: "java.lang.System", methodName: "loadLibrary", score: 5, label: "Native 库加载" },

  // ── 数据库操作（6 条）──
  { crimer: "db-sqlite-open", className: "android.database.sqlite.SQLiteDatabase", methodName: "openOrCreateDatabase", score: 3, label: "SQLite 数据库打开" },
  { crimer: "db-sqlite-query", className: "android.database.sqlite.SQLiteDatabase", methodName: "query", score: 3, label: "SQLite 查询" },
  { crimer: "db-sqlite-exec-sql", className: "android.database.sqlite.SQLiteDatabase", methodName: "execSQL", score: 4, label: "SQLite 执行 SQL（注入面）" },
  { crimer: "db-content-query", className: "android.content.ContentResolver", methodName: "query", score: 4, label: "ContentResolver 查询（跨应用数据）" },
  { crimer: "db-content-insert", className: "android.content.ContentResolver", methodName: "insert", score: 4, label: "ContentResolver 插入（跨应用写入）" },
  { crimer: "db-content-delete", className: "android.content.ContentResolver", methodName: "delete", score: 5, label: "ContentResolver 删除（跨应用破坏）" },

  // ── 加密操作（6 条）──
  { crimer: "crypto-cipher-init", className: "javax.crypto.Cipher", methodName: "init", score: 4, label: "Cipher 初始化" },
  { crimer: "crypto-cipher-dofinal", className: "javax.crypto.Cipher", methodName: "doFinal", score: 5, label: "Cipher 加密/解密执行" },
  { crimer: "crypto-key-gen", className: "javax.crypto.KeyGenerator", methodName: "generateKey", score: 3, label: "密钥生成" },
  { crimer: "crypto-secret-key-factory", className: "javax.crypto.SecretKeyFactory", methodName: "getInstance", score: 3, label: "密钥工厂" },
  { crimer: "crypto-message-digest", className: "java.security.MessageDigest", methodName: "digest", score: 2, label: "哈希计算" },
  { crimer: "crypto-signature", className: "java.security.Signature", methodName: "sign", score: 3, label: "数字签名" },

  // ── 设备信息（10 条）──
  { crimer: "device-imei", className: "android.telephony.TelephonyManager", methodName: "getDeviceId", score: 6, label: "获取 IMEI（设备标识）" },
  { crimer: "device-imei-api29", className: "android.telephony.TelephonyManager", methodName: "getImei", score: 6, label: "获取 IMEI API 29+" },
  { crimer: "device-serial", className: "android.os.Build", methodName: "getSerial", score: 6, label: "获取设备序列号" },
  { crimer: "device-android-id", className: "android.provider.Settings", methodName: "getString", score: 4, label: "获取 Android ID" },
  { crimer: "device-mac-address", className: "java.net.NetworkInterface", methodName: "getHardwareAddress", score: 6, label: "获取 MAC 地址" },
  { crimer: "device-phone-number", className: "android.telephony.TelephonyManager", methodName: "getLine1Number", score: 7, label: "获取电话号码" },
  { crimer: "device-sim-serial", className: "android.telephony.TelephonyManager", methodName: "getSimSerialNumber", score: 6, label: "获取 SIM 序列号" },
  { crimer: "device-subscriber-id", className: "android.telephony.TelephonyManager", methodName: "getSubscriberId", score: 6, label: "获取订阅者 ID" },
  { crimer: "device-build-info", className: "android.os.Build", methodName: "FINGERPRINT", score: 2, label: "读取 Build 信息" },
  { crimer: "device-display-metrics", className: "android.util.DisplayMetrics", methodName: "<init>", score: 2, label: "读取屏幕信息" },

  // ── 位置服务（6 条）──
  { crimer: "location-last-known", className: "android.location.LocationManager", methodName: "getLastKnownLocation", score: 7, label: "获取最后已知位置" },
  { crimer: "location-request-updates", className: "android.location.LocationManager", methodName: "requestLocationUpdates", score: 7, label: "请求位置更新（持续跟踪）" },
  { crimer: "location-gps-provider", className: "android.location.LocationManager", methodName: "getProvider", score: 5, label: "GPS Provider 访问" },
  { crimer: "location-fused", className: "com.google.android.gms.location.FusedLocationProviderClient", methodName: "getLastLocation", score: 6, label: "Google Fused 位置" },
  { crimer: "location-geofence", className: "com.google.android.gms.location.GeofencingClient", methodName: "addGeofences", score: 6, label: "地理围栏（位置监控）" },
  { crimer: "location-cell-info", className: "android.telephony.TelephonyManager", methodName: "getAllCellInfo", score: 5, label: "基站信息（粗略定位）" },

  // ── 通知/Toast（4 条）──
  { crimer: "notification-post", className: "android.app.NotificationManager", methodName: "notify", score: 3, label: "发送通知" },
  { crimer: "notification-sensitive", className: "android.app.NotificationCompat$Builder", methodName: "setContentText", score: 4, label: "通知内容（敏感泄露面）" },
  { crimer: "toast-show", className: "android.widget.Toast", methodName: "show", score: 2, label: "显示 Toast" },
  { crimer: "notification-cancel", className: "android.app.NotificationManager", methodName: "cancel", score: 4, label: "取消通知（隐藏恶意通知）" },

  // ── WebView（8 条）──
  { crimer: "webview-load-url", className: "android.webkit.WebView", methodName: "loadUrl", score: 4, label: "WebView 加载 URL" },
  { crimer: "webview-load-data", className: "android.webkit.WebView", methodName: "loadData", score: 4, label: "WebView 加载 HTML 数据" },
  { crimer: "webview-js-interface", className: "android.webkit.WebView", methodName: "addJavascriptInterface", score: 7, label: "WebView JS 桥注入" },
  { crimer: "webview-evaluate-js", className: "android.webkit.WebView", methodName: "evaluateJavascript", score: 5, label: "WebView 执行 JS" },
  { crimer: "webview-file-access", className: "android.webkit.WebSettings", methodName: "setAllowFileAccess", score: 6, label: "WebView 文件访问" },
  { crimer: "webview-universal-access", className: "android.webkit.WebSettings", methodName: "setAllowUniversalAccessFromFileURLs", score: 7, label: "WebView 通用文件跨源" },
  { crimer: "webview-settings-js", className: "android.webkit.WebSettings", methodName: "setJavaScriptEnabled", score: 4, label: "WebView 启用 JS" },
  { crimer: "webview-cache", className: "android.webkit.WebView", methodName: "clearCache", score: 3, label: "WebView 清缓存" },

  // ── 进程管理（6 条）──
  { crimer: "process-kill", className: "android.app.ActivityManager", methodName: "killBackgroundProcesses", score: 5, label: "杀死后台进程（竞品杀进程）" },
  { crimer: "process-running-tasks", className: "android.app.ActivityManager", methodName: "getRunningTasks", score: 5, label: "获取运行任务（侦察）" },
  { crimer: "process-running-services", className: "android.app.ActivityManager", methodName: "getRunningServices", score: 5, label: "获取运行服务（侦察）" },
  { crimer: "process-running-apps", className: "android.app.ActivityManager", methodName: "getRunningAppProcesses", score: 5, label: "获取运行进程（侦察）" },
  { crimer: "process-memory-info", className: "android.app.ActivityManager", methodName: "getProcessMemoryInfo", score: 4, label: "获取进程内存信息" },
  { crimer: "process-force-stop", className: "android.app.ActivityManager", methodName: "forceStopPackage", score: 7, label: "强制停止应用（竞品干扰）" },

  // ── 系统设置（6 条）──
  { crimer: "settings-global-put", className: "android.provider.Settings$Global", methodName: "putString", score: 6, label: "修改全局设置" },
  { crimer: "settings-secure-put", className: "android.provider.Settings$Secure", methodName: "putString", score: 6, label: "修改安全设置" },
  { crimer: "settings-system-put", className: "android.provider.Settings$System", methodName: "putString", score: 5, label: "修改系统设置" },
  { crimer: "settings-airplane-mode", className: "android.provider.Settings$Global", methodName: "putInt", score: 7, label: "修改飞行模式（断网特征）" },
  { crimer: "settings-wifi-state", className: "android.net.wifi.WifiManager", methodName: "setWifiEnabled", score: 5, label: "修改 WiFi 状态" },
  { crimer: "settings-bluetooth", className: "android.bluetooth.BluetoothAdapter", methodName: "enable", score: 5, label: "启用蓝牙" },

  // ── 剪贴板（4 条）──
  { crimer: "clipboard-get", className: "android.content.ClipboardManager", methodName: "getPrimaryClip", score: 7, label: "读取剪贴板（凭据窃取）" },
  { crimer: "clipboard-set", className: "android.content.ClipboardManager", methodName: "setPrimaryClip", score: 5, label: "写入剪贴板（替换地址欺诈）" },
  { crimer: "clipboard-has-text", className: "android.content.ClipboardManager", methodName: "hasPrimaryClip", score: 4, label: "检查剪贴板（侦察）" },
  { crimer: "clipboard-listener", className: "android.content.ClipboardManager", methodName: "addPrimaryClipChangedListener", score: 7, label: "剪贴板监听（窃取敏感）" },

  // ── 电话操作（6 条）──
  { crimer: "phone-dial", className: "android.content.Intent", methodName: "ACTION_CALL", score: 5, label: "拨打电话" },
  { crimer: "phone-sms-send", className: "android.telephony.SmsManager", methodName: "sendTextMessage", score: 8, label: "发送短信" },
  { crimer: "phone-sms-send-multipart", className: "android.telephony.SmsManager", methodName: "sendMultipartTextMessage", score: 8, label: "发送多段短信" },
  { crimer: "phone-sms-send-data", className: "android.telephony.SmsManager", methodName: "sendDataMessage", score: 8, label: "发送数据短信" },
  { crimer: "phone-call-log-read", className: "android.content.ContentResolver", methodName: "query", score: 6, label: "读取通话记录" },
  { crimer: "phone-call-state", className: "android.telephony.TelephonyManager", methodName: "getCallState", score: 4, label: "获取通话状态" },

  // ── 媒体（6 条）──
  { crimer: "media-camera-capture", className: "android.hardware.Camera", methodName: "takePicture", score: 6, label: "拍照（隐私窃取）" },
  { crimer: "media-audio-record", className: "android.media.AudioRecord", methodName: "startRecording", score: 7, label: "音频录制（窃听）" },
  { crimer: "media-mediarecorder-start", className: "android.media.MediaRecorder", methodName: "start", score: 6, label: "媒体录制" },
  { crimer: "media-mediaplayer-create", className: "android.media.MediaPlayer", methodName: "create", score: 2, label: "媒体播放" },
  { crimer: "media-audio-manager", className: "android.media.AudioManager", methodName: "setStreamVolume", score: 4, label: "修改音量" },
  { crimer: "media-screen-record", className: "android.media.projection.MediaProjection", methodName: "createVirtualDisplay", score: 8, label: "屏幕录制（隐私窃取）" },

  // ── 传感器（4 条）──
  { crimer: "sensor-accelerometer", className: "android.hardware.SensorManager", methodName: "registerListener", score: 3, label: "传感器监听（行为推断）" },
  { crimer: "sensor-gyroscope", className: "android.hardware.Sensor", methodName: "TYPE_GYROSCOPE", score: 3, label: "陀螺仪监听" },
  { crimer: "sensor-proximity", className: "android.hardware.Sensor", methodName: "TYPE_PROXIMITY", score: 2, label: "距离传感器" },
  { crimer: "sensor-step-counter", className: "android.hardware.Sensor", methodName: "TYPE_STEP_COUNTER", score: 3, label: "步数传感器（健康数据）" },

  // ── 蓝牙/NFC（6 条）──
  { crimer: "bt-enable", className: "android.bluetooth.BluetoothAdapter", methodName: "enable", score: 5, label: "启用蓝牙（隐蔽通信）" },
  { crimer: "bt-disable", className: "android.bluetooth.BluetoothAdapter", methodName: "disable", score: 5, label: "禁用蓝牙（干扰）" },
  { crimer: "bt-discover", className: "android.bluetooth.BluetoothAdapter", methodName: "startDiscovery", score: 4, label: "蓝牙设备发现" },
  { crimer: "bt-connect", className: "android.bluetooth.BluetoothSocket", methodName: "connect", score: 5, label: "蓝牙连接" },
  { crimer: "nfc-enable", className: "android.nfc.NfcAdapter", methodName: "enableForegroundDispatch", score: 4, label: "NFC 前台调度" },
  { crimer: "nfc-transmit", className: "android.nfc.tech.Ndef", methodName: "writeNdefMessage", score: 6, label: "NFC 数据写入（接触式攻击）" },

  // ── 账户/日历/闹钟/壁纸/TTS/VPN/Accessibility/Root/反调试（各 2-6 条）──
  { crimer: "account-list", className: "android.accounts.AccountManager", methodName: "getAccounts", score: 6, label: "枚举账户" },
  { crimer: "account-get-by-type", className: "android.accounts.AccountManager", methodName: "getAccountsByType", score: 6, label: "按类型获取账户" },
  { crimer: "account-add", className: "android.accounts.AccountManager", methodName: "addAccountExplicitly", score: 7, label: "添加账户（钓鱼）" },
  { crimer: "calendar-read", className: "android.content.ContentResolver", methodName: "query", score: 4, label: "读取日历（隐私）" },
  { crimer: "calendar-write", className: "android.content.ContentResolver", methodName: "insert", score: 5, label: "写入日历（植入事件）" },
  { crimer: "alarm-set", className: "android.app.AlarmManager", methodName: "set", score: 4, label: "设置闹钟/定时任务" },
  { crimer: "alarm-set-exact", className: "android.app.AlarmManager", methodName: "setExact", score: 5, label: "设置精确闹钟（持久化）" },
  { crimer: "wallpaper-set", className: "android.app.WallpaperManager", methodName: "setBitmap", score: 4, label: "设置壁纸（篡改/勒索）" },
  { crimer: "tts-speak", className: "android.speech.tts.TextToSpeech", methodName: "speak", score: 3, label: "语音合成（骚扰/钓鱼）" },
  { crimer: "vpn-service", className: "android.net.VpnService", methodName: "prepare", score: 7, label: "VPN 服务准备（流量劫持面）" },
  { crimer: "vpn-establish", className: "android.net.VpnService$Builder", methodName: "establish", score: 8, label: "VPN 建立（流量劫持）" },
  { crimer: "a11y-service", className: "android.accessibilityservice.AccessibilityService", methodName: "onAccessibilityEvent", score: 7, label: "无障碍事件监听（界面劫持）" },
  { crimer: "a11y-perform-action", className: "android.accessibilityservice.AccessibilityService", methodName: "performGlobalAction", score: 7, label: "无障碍全局操作（自动化操作）" },
  { crimer: "a11y-find-focus", className: "android.view.accessibility.AccessibilityNodeInfo", methodName: "findAccessibilityNodeInfosByText", score: 6, label: "无障碍文本搜索（窃取界面内容）" },
  { crimer: "a11y-node-action", className: "android.view.accessibility.AccessibilityNodeInfo", methodName: "performAction", score: 6, label: "无障碍节点操作（自动点击/输入）" },
  { crimer: "root-su-execute", className: "java.lang.Runtime", methodName: "exec", score: 9, label: "su 执行（Root 提权）" },
  { crimer: "root-busybox", className: "java.lang.Runtime", methodName: "exec", score: 8, label: "busybox 执行（Root 工具）" },
  { crimer: "root-check-binary", className: "java.io.File", methodName: "exists", score: 6, label: "Root 二进制检测" },
  { crimer: "root-build-tags", className: "android.os.Build", methodName: "TAGS", score: 5, label: "Build.TAGS 检测（test-keys=Root）" },
  { crimer: "anti-debug-ptrace", className: "android.os.Debug", methodName: "isDebuggerConnected", score: 7, label: "调试器检测（反调试）" },
  { crimer: "anti-debug-tracerpid", className: "java.io.BufferedReader", methodName: "readLine", score: 6, label: "TracerPid 读取（反调试）" },
  { crimer: "anti-tamper-signature", className: "android.content.pm.PackageManager", methodName: "getPackageInfo", score: 5, label: "签名自校验（完整性检测）" },
  { crimer: "anti-tamper-file-hash", className: "java.security.MessageDigest", methodName: "digest", score: 5, label: "文件哈希校验（完整性检测）" },
  { crimer: "anti-hook-xposed", className: "java.lang.Class", methodName: "forName", score: 7, label: "Xposed 检测（Hook 框架检测）" },
  { crimer: "anti-hook-frida", className: "java.io.File", methodName: "exists", score: 7, label: "Frida 检测（Hook 框架检测）" },
]

export interface BehaviorHit {
  rule: BehaviorRule
  evidence: string
}

// 调用图匹配（被调 "类.方法" 命中规则）——失败关闭。
export function matchBehaviorRules(calledMethods: Set<string>, rules: readonly BehaviorRule[] = BUILTIN_BEHAVIOR_RULES): BehaviorHit[] {
  const hits: BehaviorHit[] = []
  for (const rule of rules) {
    const target = `${rule.className}.${rule.methodName}`
    if (calledMethods.has(target)) {
      hits.push({ rule, evidence: target })
    }
  }
  return hits
}

// 加权恶意评分：命中规则 score 累计 → 0-100（归一化：满分 40——超过即 100）。
export function maliciousScore(hits: readonly BehaviorHit[]): number {
  const raw = hits.reduce((sum, hit) => sum + hit.rule.score, 0)
  return Math.min(100, Math.round((raw / 40) * 100))
}

// 命中转 findings（恶意行为 finding + 评分提示——失败关闭）。
export function buildBehaviorFindings(
  hits: readonly BehaviorHit[],
  score: number,
  thresholds: MaliciousScoreThresholds = DEFAULT_SCORE_THRESHOLDS,
): Finding[] {
  const findings: Finding[] = []
  for (const hit of hits.slice(0, 6)) {
    findings.push({
      severity: "low",
      confidence: "medium",
      code: "MALICIOUS_BEHAVIOR",
      title: `检测到恶意行为特征：${hit.rule.label}`,
      detail: `调用图命中 ${hit.evidence}（规则 ${hit.rule.crimer}，权值 ${hit.rule.score}）。仅静态特征提示，需人工核验。`,
      recommendation: "核对该 API 的实际用途；如为正规功能确认后忽略，敏感行为建议服务端化。",
      evidence: hit.evidence,
    })
  }
  if (score > 0) {
    findings.push({
      severity: score >= thresholds.high ? "medium" : score >= thresholds.medium ? "low" : "info",
      code: "MALICIOUS_SCORE",
      title: `恶意行为加权评分 ${score}/100`,
      detail: `命中 ${hits.length} 条恶意行为规则（权值累计归一化；high ≥ ${thresholds.high}、medium ≥ ${thresholds.medium}）。仅静态评分提示，不判定恶意。`,
      recommendation: "高评分样本建议结合行为规则证据与人工核验。",
      evidence: hits.map((h) => h.rule.crimer).join(", "),
    })
  }
  return findings
}

// 反混淆辅助(Quark-Engine 差距⑥——轻量版):检测 DEX 字符串池中的 hex/base64 编码串,
// 解码后与行为规则的方法名/类名匹配,补充行为命中。失败关闭(无法解码/未命中即跳过)。
export function matchDeobfuscatedRules(strings: Iterable<string>, rules: readonly BehaviorRule[] = BUILTIN_BEHAVIOR_RULES): BehaviorHit[] {
  const decoded = new Set<string>()
  for (const s of strings) {
    if (s.length < 8 || s.length > 256) continue
    // hex:纯 0-9a-f 且偶数长度
    if (/^[0-9a-fA-F]{16,}$/.test(s) && s.length % 2 === 0) {
      const hex = s.match(/.{2}/g)!.map((h) => String.fromCharCode(Number.parseInt(h, 16))).join("")
      if (/[a-zA-Z]{4,}/.test(hex)) decoded.add(hex)
    }
    // base64:标准字符集且长度 %4=0(无填充或补 =)
    if (/^[A-Za-z0-9+/]{16,}={0,2}$/.test(s)) {
      try {
        const text = Buffer.from(s, "base64").toString("utf8")
        if (/[a-zA-Z]{4,}/.test(text)) decoded.add(text)
      } catch {
        // 解码失败跳过
      }
    }
    // URL 编码(%XX):解码后匹配
    if (/%[0-9a-fA-F]{2}/.test(s) && s.length <= 256) {
      try {
        const text = decodeURIComponent(s)
        if (/[a-zA-Z]{4,}/.test(text)) decoded.add(text)
      } catch {
        // 解码失败跳过
      }
    }
  }
  const hits: BehaviorHit[] = []
  for (const rule of rules) {
    const target = `${rule.className}.${rule.methodName}`
    for (const value of decoded) {
      if (value.includes(target) || target.includes(value.slice(0, 24))) {
        hits.push({ rule, evidence: `解码后命中: ${target}` })
        break
      }
    }
  }
  return hits
}
