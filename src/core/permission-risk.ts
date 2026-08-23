// 权限风险评分 + 权限-数据流关联（DroidStatx 差距①——permission-risk.ts）。
// ① 权限风险评分：敏感权限的风险分（高/中）——汇总高风险权限清单（PERMISSION_RISK_HIGH）。
// ② 权限-数据流关联：拿到敏感权限的应用若在数据流中使用对应源/汇——升级交叉证据
//    （PERMISSION_DATAFLOW_LINK——权限审计与污点分析的关联）。失败关闭。
import type { Finding } from "./types.ts"

// 权限风险分（基于敏感性——设备标识/短信/位置/账户等高敏感）
const PERMISSION_RISKS: ReadonlyArray<{ permission: string; score: number; level: "high" | "medium"; note: string }> = [
  { permission: "android.permission.RECEIVE_SMS", score: 9, level: "high", note: "接收短信——短信劫持/验证码拦截" },
  { permission: "android.permission.SEND_SMS", score: 8, level: "high", note: "发送短信——扣费/恶意传播" },
  { permission: "android.permission.READ_SMS", score: 8, level: "high", note: "读取短信——敏感内容泄露" },
  { permission: "android.permission.READ_PHONE_STATE", score: 7, level: "high", note: "读取设备标识——跟踪/唯一标识" },
  { permission: "android.permission.ACCESS_FINE_LOCATION", score: 6, level: "high", note: "精确定位——位置跟踪" },
  { permission: "android.permission.READ_CONTACTS", score: 6, level: "high", note: "读取联系人——隐私泄露" },
  { permission: "android.permission.READ_CALL_LOG", score: 7, level: "high", note: "读取通话记录——隐私泄露" },
  { permission: "android.permission.RECORD_AUDIO", score: 7, level: "high", note: "录音——隐私泄露" },
  { permission: "android.permission.CAMERA", score: 5, level: "medium", note: "摄像头——隐私面" },
  { permission: "android.permission.GET_ACCOUNTS", score: 5, level: "medium", note: "账户信息——隐私面" },
  { permission: "android.permission.READ_EXTERNAL_STORAGE", score: 4, level: "medium", note: "读取存储——敏感文件面" },
  { permission: "android.permission.BIND_DEVICE_ADMIN", score: 9, level: "high", note: "设备管理——恶意行为面" },
]

// 权限-数据流关联映射（权限 → 对应的敏感源/汇——数据流 finding 命中即关联）
const PERMISSION_DATAFLOW_MAP: ReadonlyArray<{ permission: string; markers: string[]; note: string }> = [
  { permission: "android.permission.READ_PHONE_STATE", markers: ["getdeviceid(", "getimei(", "getsubscriberid(", "getsimserialnumber("], note: "设备标识读取" },
  { permission: "android.permission.ACCESS_FINE_LOCATION", markers: ["getlastknownlocation(", "getlatitude(", "getlongitude("], note: "位置读取" },
  { permission: "android.permission.RECEIVE_SMS", markers: ["sendtextmessage(", "getmessagebody("], note: "短信收发" },
  { permission: "android.permission.READ_SMS", markers: ["getmessagebody(", "sendtextmessage("], note: "短信内容" },
  { permission: "android.permission.READ_CONTACTS", markers: ["getcursor(", "content://contacts"], note: "联系人读取" },
  { permission: "android.permission.READ_CALL_LOG", markers: ["content://call_log", "getcursor("], note: "通话记录读取" },
]

// 权限风险评分（汇总高风险权限——失败关闭）。
export function buildPermissionRiskFindings(permissions: readonly string[]): Finding[] {
  const granted = permissions.map((p) => p.toLowerCase())
  const hits = PERMISSION_RISKS.filter((r) => granted.includes(r.permission.toLowerCase()))
  if (hits.length === 0) return []
  const total = hits.reduce((sum, h) => sum + h.score, 0)
  return [
    {
      severity: hits.some((h) => h.level === "high") ? "medium" : "low",
      confidence: "high",
      code: "PERMISSION_RISK_HIGH",
      title: `敏感权限风险评分 ${total} 分（${hits.length} 项）`,
      detail: hits.map((h) => `${h.permission}（${h.score} 分——${h.note}）`).join("；"),
      recommendation: "核对高风险权限的必要性；用不到的敏感权限应从 Manifest 移除（最小权限原则）。",
      evidence: hits.map((h) => `${h.permission}(${h.score})`).join(", "),
    },
  ]
}

// 权限-数据流关联：拿到敏感权限 + 数据流中使用对应源/汇——升级交叉证据（失败关闭）。
export function linkPermissionDataflow(permissions: readonly string[], findings: readonly Finding[]): Finding[] {
  const granted = new Set(permissions.map((p) => p.toLowerCase()))
  const evidenceText = findings.map((f) => `${f.code} ${f.evidence ?? ""}`.toLowerCase()).join("\n")
  const out: Finding[] = []
  for (const link of PERMISSION_DATAFLOW_MAP) {
    if (!granted.has(link.permission.toLowerCase())) continue
    const used = link.markers.filter((m) => evidenceText.includes(m))
    if (used.length === 0) continue
    out.push({
      severity: "medium",
      confidence: "medium",
      code: "PERMISSION_DATAFLOW_LINK",
      title: `权限-数据流关联：${link.permission} 与 ${link.note}`,
      detail: `应用声明 ${link.permission}，且数据流证据中出现 ${used.join("、")}——权限与敏感数据使用相关联（交叉证据升级）。`,
      recommendation: "核对权限与数据流的使用是否匹配；权限授予应最小化且与功能对应。",
      evidence: `${link.permission} → ${used.join("、")}`,
    })
  }
  return out
}
