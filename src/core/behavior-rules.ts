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
