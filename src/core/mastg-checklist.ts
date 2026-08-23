// MASTG 逐项检查清单 + MASVS L1/L2 合规级别（APKHunt 差距①②——mastg-checklist.ts）。
// 静态的 MASTG-* 检查项清单（分类 + MASVS 合规级别），由审计发现推导逐项状态
// （关联发现命中 → 「需核验」；无 → 「未检查」）。失败关闭。
import type { Finding } from "./types.ts"

export interface MastgChecklistItem {
  id: string
  title: string
  category: "存储" | "网络" | "加密" | "代码质量" | "平台交互"
  masvsLevel: "L1" | "L2"
  status: "需核验" | "未检查"
}

// 静态 MASTG 检查项（关联 DroidSeal 的 finding codes——命中即需核验）。
const MASTG_CHECKLIST: ReadonlyArray<Omit<MastgChecklistItem, "status"> & { relatedFindings: string[] }> = [
  { id: "MASTG-STORAGE-1", title: "本地敏感数据存储（明文/未加密）", category: "存储", masvsLevel: "L1", relatedFindings: ["SOURCE_UNENCRYPTED_STORAGE", "SOURCE_WEB_INSECURE_STORAGE"] },
  { id: "MASTG-STORAGE-2", title: "日志泄露敏感数据", category: "存储", masvsLevel: "L1", relatedFindings: ["SOURCE_DATAFLOW", "SOURCE_LIFECYCLE_ENTRY", "SOURCE_CROSS_FUNCTION_TAINT"] },
  { id: "MASTG-STORAGE-3", title: "剪贴板/全局状态敏感数据", category: "存储", masvsLevel: "L1", relatedFindings: ["SOURCE_COLLECTION_TAINT", "SOURCE_STATIC_TAINT"] },
  { id: "MASTG-STORAGE-4", title: "硬编码密钥/凭据", category: "存储", masvsLevel: "L1", relatedFindings: ["HARDCODED_SECRET", "GOOGLE_API_KEY", "AWS_ACCESS_KEY", "SOURCE_CONSTANT_VALUE", "SOURCE_JS_HARDCODED_SECRET"] },
  { id: "MASTG-NETWORK-1", title: "网络流量未加密/允许明文", category: "网络", masvsLevel: "L1", relatedFindings: ["SOURCE_WEB_INSECURE_FORM", "ENDPOINT_INVENTORY"] },
  { id: "MASTG-NETWORK-2", title: "证书校验绕过", category: "网络", masvsLevel: "L2", relatedFindings: ["SOURCE_SSL_BYPASS", "SOURCE_NO_CERT_PINNING"] },
  { id: "MASTG-NETWORK-3", title: "WebView 加载不受信内容/忽略证书错误", category: "网络", masvsLevel: "L1", relatedFindings: ["WEBVIEW_SSL_ERROR_IGNORED", "SOURCE_JS_DANGEROUS_API"] },
  { id: "MASTG-CRYPTO-1", title: "弱加密算法（DES/ECB/MD5/SHA1）", category: "加密", masvsLevel: "L1", relatedFindings: ["SOURCE_WEAK_CRYPTO", "SOURCE_JS_WEAK_CRYPTO"] },
  { id: "MASTG-CRYPTO-2", title: "不安全随机数", category: "加密", masvsLevel: "L1", relatedFindings: [] },
  { id: "MASTG-CODE-1", title: "可调试/可备份的发布构建", category: "代码质量", masvsLevel: "L1", relatedFindings: ["DEBUGGABLE", "ALLOW_BACKUP"] },
  { id: "MASTG-CODE-2", title: "反调试/反篡改缺失", category: "代码质量", masvsLevel: "L2", relatedFindings: ["ANTIDEBUG_ABSENT"] },
  { id: "MASTG-CODE-3", title: "原生库加固不足（未剥离符号等）", category: "代码质量", masvsLevel: "L2", relatedFindings: ["SO_UNSTRIPPED_SYMBOLS", "SO_PACKED"] },
  { id: "MASTG-CODE-4", title: "打包器/加固壳检测", category: "代码质量", masvsLevel: "L2", relatedFindings: ["PACKER_DETECTED"] },
  { id: "MASTG-PLATFORM-1", title: "导出组件/深链暴露", category: "平台交互", masvsLevel: "L1", relatedFindings: ["EXPORTED_ACTIVITY", "EXPORTED_PROVIDER", "EXPORTED_SERVICE"] },
  { id: "MASTG-PLATFORM-2", title: "敏感权限滥用（短信/位置/设备标识）", category: "平台交互", masvsLevel: "L1", relatedFindings: ["MALICIOUS_INDICATOR", "PRIVACY_DATA_COLLECTION"] },
  { id: "MASTG-PLATFORM-3", title: "恶意行为规则命中", category: "平台交互", masvsLevel: "L2", relatedFindings: ["MALICIOUS_BEHAVIOR", "MALICIOUS_SCORE"] },
]

// 由审计发现推导逐项状态（关联 finding code 命中 → 「需核验」；否则「未检查」）。
export function buildMastgChecklist(findings: readonly Finding[]): MastgChecklistItem[] {
  const codes = new Set(findings.map((f) => f.code))
  return MASTG_CHECKLIST.map((item) => ({
    id: item.id,
    title: item.title,
    category: item.category,
    masvsLevel: item.masvsLevel,
    status: item.relatedFindings.some((code) => codes.has(code)) ? ("需核验" as const) : ("未检查" as const),
  }))
}

// 合规摘要（MASVS L1/L2 的检查状态统计）。
export function mastgComplianceSummary(checklist: MastgChecklistItem[]): {
  total: number
  needsReview: number
  unchecked: number
  l1NeedsReview: number
  l2NeedsReview: number
} {
  return {
    total: checklist.length,
    needsReview: checklist.filter((i) => i.status === "需核验").length,
    unchecked: checklist.filter((i) => i.status === "未检查").length,
    l1NeedsReview: checklist.filter((i) => i.masvsLevel === "L1" && i.status === "需核验").length,
    l2NeedsReview: checklist.filter((i) => i.masvsLevel === "L2" && i.status === "需核验").length,
  }
}
