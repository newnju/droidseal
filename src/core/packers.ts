// 打包器/保护器指纹识别(差距分析高补强②,APKiD 式精简版)。
// 纯 TypeScript 指纹表(无 YARA 依赖),匹配 DEX 类描述符/字符串中的特征标记,
// 识别常见加固壳/混淆器并提示"降低静态审计可见性,建议配合商业加固核验"。
// 只做清单级提示,不联网、失败关闭;未命中即不输出结论。
import type { Finding } from "./types.ts"

export interface PackerFingerprint {
  name: string
  marker: string
  note: string
}

// 常见 Android 加固壳/混淆器的类名/包名特征(小写匹配)。
// 精简人工维护表,新壳出现时手工补充。
export const KNOWN_PACKERS: readonly PackerFingerprint[] = [
  {
    name: "腾讯乐固(Tencent Legu)",
    marker: "com.tencent.stubshell",
    note: "腾讯乐固通过 StubShell 加载器保护 DEX。",
  },
  {
    name: "梆梆安全(Bangcle)",
    marker: "com.secneo.apkwrapper",
    note: "梆梆通过 Secneo 包装器保护。",
  },
  {
    name: "爱加密(ijiami)",
    marker: "com.shell.superapplication",
    note: "爱加密通过 SuperApplication 壳加载。",
  },
  {
    name: "360加固(Qihoo)",
    marker: "com.stub.stubapp",
    note: "360 加固通过 StubApp 加载器保护。",
  },
  {
    name: "DexProtector",
    marker: "com/licel",
    note: "DexProtector 的许可证库特征(com/licel 包)。",
  },
  {
    name: "DexGuard",
    marker: "com/guardsquare",
    note: "GuardSquare 的 DexGuard 特征包。",
  },
  {
    name: "阿里聚安全(Alibaba)",
    marker: "com/aliyun/shell",
    note: "阿里聚安全通过 Shell 包装器保护。",
  },
  {
    name: "娜迦(Naga)",
    marker: "com.naga.",
    note: "娜迦加固的特征包。",
  },
  {
    name: "顶象(DingXiang)",
    marker: "com.dingxiang",
    note: "顶象加固的特征包。",
  },
  {
    name: "APKProtect",
    marker: "apkprotect",
    note: "APKProtect 的特征标识。",
  },
  {
    name: "通付盾(TongFuDun)",
    marker: "com.tongfudun",
    note: "通付盾加固的特征包。",
  },
]

// 从 DEX 字符串/类描述符集合中匹配已知加固指纹,返回命中的指纹列表。
export function detectPackers(strings: Iterable<string>): PackerFingerprint[] {
  const haystack = [...strings].join("\n").toLowerCase()
  return KNOWN_PACKERS.filter((fingerprint) => haystack.includes(fingerprint.marker))
}

// 命中的指纹转 finding(清单级提示,失败关闭)。
export function buildPackerFindings(strings: Iterable<string>): Finding[] {
  const packers = detectPackers(strings)
  if (packers.length === 0) return []
  return [
    {
      severity: "info",
      code: "PACKER_DETECTED",
      title: `检测到加固壳/混淆器：${packers.map((p) => p.name).join("、")}`,
      detail:
        `从 DEX 类描述符/字符串识别到以下加固特征：${packers.map((p) => p.marker).join("、")}。` +
        packers.map((p) => p.note).join(" ") +
        " 加固壳会降低静态审计可见性（部分代码在运行时才解密），请结合加固商配置核对与商业加固核验。",
      recommendation: "确认加固版本与配置；对加壳应用需结合真机动态验证与加固商文档，静态审计结论按可见性降级。",
      evidence: packers.map((p) => p.marker).join(", "),
    },
  ]
}
