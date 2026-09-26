// Pure-TypeScript DEX string-pool scanner. No external dependencies.
//
// Scope: parse only the DEX string pool (string_ids -> string_data_item). Type
// descriptors, class names, method names and string literals are all interned in
// that pool supports useful triage without a full disassembler. Strict rules
// require corroborating API/action/value strings and attach evidence confidence;
// operands that the pool cannot recover are not guessed.

import type { Finding } from "./types.ts"
import { scanStringsForSecrets, strongestSecretConfidence } from "./secret-scan.ts"
import { scanCodeStrings, pendingIntentImmutableFinding } from "./code-heuristics.ts"

const DEX_MAGIC = [0x64, 0x65, 0x78, 0x0a] // "dex\n"
const STRING_IDS_SIZE_OFFSET = 0x38
const STRING_IDS_OFF_OFFSET = 0x3c

export interface DexStrings {
  strings: string[]
  truncated: boolean
}

function readUleb128(bytes: Uint8Array, start: number): { value: number; next: number } {
  let result = 0
  let shift = 0
  let index = start
  while (index < bytes.length) {
    const byte = bytes[index]!
    result |= (byte & 0x7f) << shift
    index += 1
    if ((byte & 0x80) === 0) break
    shift += 7
    if (shift > 28) break
  }
  return { value: result >>> 0, next: index }
}

// Extract the string pool of a DEX buffer. Throws when the buffer is not a DEX
// container (bad magic / too small). Individual malformed entries are skipped and
// flip `truncated` so callers can degrade gracefully.
export function extractDexStrings(bytes: Uint8Array, maxStrings = 200_000): DexStrings {
  if (bytes.length < 0x70) throw new Error("dex too small")
  for (let i = 0; i < DEX_MAGIC.length; i += 1) {
    if (bytes[i] !== DEX_MAGIC[i]) throw new Error("not a dex file")
  }
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const stringIdsSize = view.getUint32(STRING_IDS_SIZE_OFFSET, true)
  const stringIdsOff = view.getUint32(STRING_IDS_OFF_OFFSET, true)
  const decoder = new TextDecoder("utf-8", { fatal: false })
  const strings: string[] = []
  let truncated = false

  const count = Math.min(stringIdsSize, maxStrings)
  if (stringIdsSize > maxStrings) truncated = true

  for (let i = 0; i < count; i += 1) {
    const idOffset = stringIdsOff + i * 4
    if (idOffset + 4 > bytes.length) {
      truncated = true
      break
    }
    const dataOffset = view.getUint32(idOffset, true)
    if (dataOffset >= bytes.length) {
      truncated = true
      continue
    }
    // Skip the ULEB128 utf16 length prefix, then read MUTF-8 bytes until the NUL
    // terminator. A genuine embedded NUL is encoded as 0xC0 0x80, never a bare 0x00.
    const { next } = readUleb128(bytes, dataOffset)
    let end = next
    while (end < bytes.length && bytes[end] !== 0x00) end += 1
    strings.push(decoder.decode(bytes.subarray(next, end)))
  }
  return { strings, truncated }
}

// Known third-party SDK package descriptor prefixes for the SBOM inventory (Tier3-J).
// 指纹库 v2:每条带类别与风险注记(数据采集/已知问题),供 SUPPLYCHAIN_SDK_INVENTORY
// 输出结构化明细——纯前缀表只能报名字,审阅者仍需逐个查背景。
export interface SdkFingerprint {
  prefix: string
  name: string
  category: "统计" | "广告" | "推送" | "支付" | "地图" | "网络" | "UI" | "社交" | "崩溃" | "云服务"
  /** 数据采集/权限注记(空串=无已知显著采集) */
  note?: string
}

export const SDK_FINGERPRINTS: ReadonlyArray<SdkFingerprint> = [
  { prefix: "Lcom/google/firebase/", name: "Google Firebase", category: "云服务", note: "采集设备标识/使用统计" },
  { prefix: "Lcom/google/android/gms/", name: "Google Play Services", category: "云服务" },
  { prefix: "Lcom/facebook/", name: "Facebook SDK", category: "社交", note: "采集设备标识/社交图谱" },
  { prefix: "Lcom/umeng/", name: "友盟 Umeng", category: "统计", note: "采集设备标识/位置;国内合规审查重点" },
  { prefix: "Lcom/bytedance/", name: "字节跳动 ByteDance", category: "广告", note: "广告追踪;采集设备标识/使用行为" },
  { prefix: "Lcom/tencent/", name: "腾讯 Tencent", category: "社交" },
  { prefix: "Lcom/alipay/", name: "支付宝 Alipay", category: "支付" },
  { prefix: "Lcom/amap/api/", name: "高德地图 AMap", category: "地图", note: "采集位置" },
  { prefix: "Lcom/baidu/", name: "百度 Baidu", category: "地图", note: "采集位置/设备标识" },
  { prefix: "Lcom/squareup/okhttp/", name: "OkHttp", category: "网络" },
  { prefix: "Lretrofit2/", name: "Retrofit", category: "网络" },
  { prefix: "Lcom/bumptech/glide/", name: "Glide", category: "UI" },
  { prefix: "Lio/reactivex/", name: "RxJava", category: "UI" },
  { prefix: "Lcom/appsflyer/", name: "AppsFlyer", category: "统计", note: "归因追踪;采集广告标识/设备信息" },
  { prefix: "Lcom/adjust/sdk/", name: "Adjust", category: "统计", note: "归因追踪;采集广告标识" },
  // 指纹库 v2 扩充(国内常用 + 隐私敏感大户)
  { prefix: "Lcn/jpush/", name: "极光推送 JPush", category: "推送", note: "采集设备标识;后台常驻" },
  { prefix: "Lcn/umeng/", name: "友盟 Umeng(cn)", category: "统计", note: "同 com/umeng" },
  { prefix: "Lcom/getui/", name: "个推 Getui", category: "推送", note: "采集设备标识" },
  { prefix: "Lcn/leancloud/", name: "LeanCloud", category: "云服务" },
  { prefix: "Lcom/bugly/", name: "Bugly", category: "崩溃", note: "采集设备标识/崩溃日志" },
  { prefix: "Lcom/crashlytics/", name: "Crashlytics", category: "崩溃", note: "采集设备标识/崩溃日志" },
  { prefix: "Lio/sentry/", name: "Sentry", category: "崩溃", note: "崩溃日志可能含敏感参数" },
  { prefix: "Lcom/unity3d/", name: "Unity Ads", category: "广告", note: "广告追踪" },
  { prefix: "Lcom/ironsource/", name: "ironSource", category: "广告", note: "广告追踪" },
  { prefix: "Lcom/mopub/", name: "MoPub", category: "广告", note: "广告追踪(已停止维护——供应链风险)" },
  { prefix: "Lcom/flurry/", name: "Flurry", category: "统计", note: "采集设备标识/使用统计" },
  { prefix: "Lcom/amazon/identity/", name: "Amazon Auth", category: "云服务" },
  { prefix: "Lcom/huawei/", name: "华为 HMS", category: "云服务" },
  { prefix: "Lcom/xiaomi/", name: "小米 SDK", category: "推送" },
  { prefix: "Lcom/meituan/", name: "美团 SDK", category: "地图", note: "采集位置" },
  { prefix: "Lcom/ss/android/", name: "穿山甲 CSJ", category: "广告", note: "广告追踪;采集设备标识(国内合规审查重点)" },
  { prefix: "Lcom/qq/e/", name: "广点通 GDT", category: "广告", note: "广告追踪" },
]

// Best-effort third-party SDK detection from type descriptors. Returns display names.
export function detectSdkPackages(strings: Iterable<string>): string[] {
  return [...detectSdkFingerprints(strings)].map((f) => f.name).sort()
}

// 指纹库 v2:返回命中的完整指纹(带类别/注记),供结构化 SBOM 输出。
export function detectSdkFingerprints(strings: Iterable<string>): SdkFingerprint[] {
  const found = new Map<string, SdkFingerprint>()
  for (const value of strings) {
    if (value.length === 0 || value.charCodeAt(0) !== 0x4c /* 'L' */) continue
    for (const sdk of SDK_FINGERPRINTS) {
      if (value.startsWith(sdk.prefix)) found.set(sdk.name, sdk)
    }
  }
  return [...found.values()].sort((a, b) => a.name.localeCompare(b.name))
}

// Scan the combined string pool of one or more DEX files for heuristic risks.
export function scanDex(strings: string[]): Finding[] {
  const findings: Finding[] = []

  const secretHits = scanStringsForSecrets(strings)
  if (secretHits.length > 0) {
    findings.push({
      severity: secretHits.some((hit) => hit.confidence === "confirmed" || hit.confidence === "high") ? "high" : "medium",
      confidence: strongestSecretConfidence(secretHits),
      code: "DEX_HARDCODED_SECRET",
      title: "DEX 中疑似硬编码密钥/凭据",
      detail:
        "为什么：在 DEX 字符串池中发现通过格式、长度、值域与熵阈值校验的密钥/令牌候选；通用赋值仅按中等置信度报告。所以：任何解包 APK 的人都能提取真实凭据。请先按脱敏证据定位，确认后立即轮换：" +
        secretHits.map((hit) => `${hit.label}(${hit.preview})`).join("、") + "。",
      recommendation: "将密钥移出客户端，改由服务端保管或使用短期令牌；已泄露的凭据立即轮换。",
      evidence: secretHits.map((hit) => `${hit.code}:${hit.preview}`).join(", "),
    })
  }

  // Shared heuristic catalog (Web crypto/TLS/WebView/data-storage/component/runtime).
  findings.push(...scanCodeStrings(strings, "DEX"))

  // Cross-correlation checks that need two signals at once.
  findings.push(...pendingIntentImmutableFinding("DEX", strings))

  let hasSecureRandom = false
  let hasInsecureRandom = false
  for (const value of strings) {
    if (value === "Ljava/security/SecureRandom;") hasSecureRandom = true
    if (value === "Ljava/util/Random;") hasInsecureRandom = true
  }
  if (hasInsecureRandom && !hasSecureRandom) {
    findings.push({
      severity: "info",
      confidence: "low",
      code: "DEX_WEAK_RANDOM",
      title: "DEX 引用了 java.util.Random，用途无法从字符串池确认",
      detail:
        "为什么：字符串池含 Ljava/util/Random; 但 DEX 字符串池不能还原它的具体调用点和用途；这不是已确认漏洞。只有用于密钥、令牌、验证码或盐值时才构成可预测风险。",
      recommendation: "所有安全敏感的随机数改用 java.security.SecureRandom。",
      evidence: "Ljava/util/Random;",
    })
  }

  return findings
}
