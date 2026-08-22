// 打包器/保护器指纹识别(差距分析高补强②,APKiD 式精简版)。
// 纯 TypeScript 指纹表(无 YARA 依赖),匹配 DEX 类描述符/字符串中的特征标记,
// 识别常见加固壳/混淆器并提示"降低静态审计可见性,建议配合商业加固核验"。
// 只做清单级提示,不联网、失败关闭;未命中即不输出结论。
import { readFile } from "node:fs/promises"
import type { Finding } from "./types.ts"

export interface PackerFingerprint {
  name: string
  marker?: string
  regex?: string
  note: string
  source?: string
  version?: string
  author?: string
}

// 外部指纹文件加载(APKiD 差距②):JSON 数组 { name, marker?, regex?, note, source? }——校验失败关闭。
export function parsePackerFingerprints(text: string): PackerFingerprint[] {
  const parsed = JSON.parse(text) as unknown
  if (!Array.isArray(parsed)) throw new Error("指纹文件应为 JSON 数组")
  const rules: PackerFingerprint[] = []
  for (const [index, raw] of parsed.entries()) {
    const rule = raw as Partial<PackerFingerprint>
    if (!rule.name) throw new Error(`指纹 #${index + 1} 缺 name`)
    if (!rule.marker && !rule.regex) throw new Error(`指纹 #${index + 1}（${rule.name}）缺 marker 或 regex`)
    if (rule.regex) {
      try {
        new RegExp(rule.regex, "i")
      } catch {
        throw new Error(`指纹 #${index + 1}（${rule.name}）regex 非法`)
      }
    }
    rules.push({
      name: rule.name,
      ...(rule.marker ? { marker: rule.marker } : {}),
      ...(rule.regex ? { regex: rule.regex } : {}),
      note: rule.note ?? "",
      ...(rule.source ? { source: rule.source } : {}),
      ...(rule.version ? { version: rule.version } : {}),
      ...(rule.author ? { author: rule.author } : {}),
    })
  }
  return rules
}

export async function loadPackerFingerprints(file: string): Promise<PackerFingerprint[]> {
  return parsePackerFingerprints(await readFile(file, "utf8"))
}

// 合并指纹:内置 + 外部(marker 或 regex 去重——外部优先)。
export function mergePackerFingerprints(custom: readonly PackerFingerprint[] = []): PackerFingerprint[] {
  const merged = new Map<string, PackerFingerprint>()
  for (const rule of KNOWN_PACKERS) merged.set(rule.marker ?? rule.regex ?? rule.name, rule)
  for (const rule of custom) merged.set(rule.marker ?? rule.regex ?? rule.name, rule)
  return [...merged.values()]
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
  {
    name: "网易易盾(NetEase Shield)",
    marker: "com.netease.nis.shield",
    note: "网易易盾通过 Shield 加载器保护 DEX。",
  },
  {
    name: "百度加固(Baidu Protect)",
    marker: "com.baidu.protect",
    note: "百度加固通过 Protect 加载器保护。",
  },
  {
    name: "腾讯御安全(Tencent Shield)",
    marker: "com.tencent.tshield",
    note: "腾讯御安全提供 DEX 加固。",
  },
  {
    name: "360 加固运行时(com.qihoo.util)",
    marker: "com.qihoo.util",
    note: "360 加固的运行时工具类。",
  },
  {
    name: "梆梆变体(com.secneo)",
    marker: "com.secneo",
    note: "梆梆 Secneo 的通用包前缀。",
  },
  {
    name: "通用加固壳特征(com.shell.)",
    marker: "com.shell.",
    note: "常见加固壳的加载器命名模式(爱加密/其他壳变体)。",
  },
  {
    name: "jiagu 加固(com.jiagu)",
    marker: "com.jiagu",
    note: "常见 jiagu 命名的加固壳。",
  },
  {
    name: "StringFog 字符串加密",
    marker: "com.github.megatronking.stringfog",
    note: "StringFog 是开源的字符串加密库(混淆敏感字符串)。",
  },
  {
    name: "华为应用市场加固",
    marker: "com.huawei.appgallery",
    note: "华为应用市场加固保护。",
  },
  {
    name: "阿里聚安全变体(com.alibaba.security)",
    marker: "com.alibaba.security",
    note: "阿里聚安全的通用包前缀。",
  },
  {
    name: "ProGuard 混淆特征",
    marker: "proguard",
    note: "检测到 ProGuard 混淆标识(类名/字符串含 proguard)。",
  },
  {
    name: "ApkTool 重打包特征",
    marker: "apktool",
    note: "检测到 ApkTool 重打包标识(需人工核验是否重打包)。",
  },
  {
    name: "通用 Stub 壳(com.stub.)",
    marker: "com.stub.",
    note: "通用 com.stub 前缀——常见壳的 Stub 加载器命名模式。",
  },
  {
    name: "通付盾变体(com.tongfudun.security)",
    marker: "com.tongfudun.security",
    note: "通付盾的 security 子包变体。",
  },
  {
    name: "梆梆类变体(com.secneo.a)",
    marker: "com.secneo.a",
    note: "梆梆的加密类子包。",
  },
  {
    name: "腾讯加固变体(com.tencent.jg)",
    marker: "com.tencent.jg",
    note: "腾讯加固(jiagu)的类名变体。",
  },
  {
    name: "AndResGuard 资源混淆",
    marker: "com.tencent.andresguard",
    note: "AndResGuard 是开源资源路径混淆工具(资源名/路径混淆)。",
  },
  {
    name: "BlackObfuscator 方法混淆",
    marker: "blackobfuscator",
    note: "BlackObfuscator 是开源 DEX 方法名混淆工具。",
  },
  {
    name: "Obfuscapk",
    marker: "com.obfuscapk",
    note: "Obfuscapk 是开源全功能 APK 混淆器。",
  },
  {
    name: "Allatori 混淆器",
    marker: "com.allatori",
    note: "Allatori 是商业 Java/Android 混淆器。",
  },
  {
    name: "Zelix KlassMaster(ZKM)",
    marker: "zelix",
    note: "ZKM 是商业 Java 混淆器(字符串加密/流混淆)。",
  },
  {
    name: "DashO(PreEmptive)",
    marker: "preemptive",
    note: "DashO 是商业加固混淆器(字符串/流混淆)。",
  },
]

// 从 DEX 字符串/类描述符集合中匹配已知加固指纹,返回命中的指纹列表。
export function detectPackers(strings: Iterable<string>, fingerprints: readonly PackerFingerprint[] = KNOWN_PACKERS): PackerFingerprint[] {
  const haystack = [...strings].join("\n").toLowerCase()
  return fingerprints.filter((fingerprint) => {
    if (fingerprint.marker) return haystack.includes(fingerprint.marker)
    if (fingerprint.regex) return new RegExp(fingerprint.regex, "i").test(haystack)
    return false
  })
}

// 命中的指纹转 finding(清单级提示,失败关闭)。
export function buildPackerFindings(strings: Iterable<string>, fingerprints: readonly PackerFingerprint[] = KNOWN_PACKERS): Finding[] {
  const packers = detectPackers(strings, fingerprints)
  if (packers.length === 0) return []
  return [
    {
      severity: "info",
      code: "PACKER_DETECTED",
      title: `检测到加固壳/混淆器：${packers.map((p) => p.name).join("、")}`,
      detail:
        `从 DEX 类描述符/字符串识别到以下加固特征：${packers.map((p) => p.marker ?? p.regex ?? p.name).join("、")}。` +
        packers.map((p) => p.note).join(" ") +
        (packers.some((p) => p.version) ? ` 版本：${packers.map((p) => p.version).filter(Boolean).join("、")}。` : "") +
        (packers.some((p) => p.author) ? ` 规则作者：${packers.map((p) => p.author).filter(Boolean).join("、")}。` : "") +
        " 加固壳会降低静态审计可见性（部分代码在运行时才解密），请结合加固商配置核对与商业加固核验。",
      recommendation: "确认加固版本与配置；对加壳应用需结合真机动态验证与加固商文档，静态审计结论按可见性降级。",
      evidence: packers.map((p) => p.marker ?? p.regex ?? p.name).join(", "),
    },
  ]
}
