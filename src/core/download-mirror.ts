// 工具链下载镜像源配置层(默认官方源;可选镜像切换)。
// 设计原则:
// 1. 默认官方——全球大多数用户直连官方源即可,零配置;
// 2. 镜像 opt-in——国内等受限网络用户通过环境变量切换,不改变默认行为;
// 3. 哈希为信任锚——镜像只加速不受信任,SHA-256 校验照常执行,镜像返回
//    任何被篡改的字节都会在校验层被拒绝(与官方源同一安全模型);
// 4. 失败自动回退——镜像下载失败/校验失败自动回落官方源重试一次。

export interface MirrorOverride {
  /** 源 host(如 dl.google.com)→ 目标 host 前缀替换 */
  from: string
  to: string
}

/**
 * 国内公共镜像预设(2026-09 实测收录:只收 HTTP 200 且路径布局与官方一致的源,
 * 未通过实测的候选一律不收——写进名单的每一条都必须真实可用)。
 * AndroidSDK(commandline-tools)归档:腾讯;
 * Gradle 发行版:腾讯、华为(双源互备);
 * Adoptium JDK:无可靠国内镜像(API 动态清单无法 host 替换),走官方+可选代理。
 */
export const CN_MIRROR_OVERRIDES: MirrorOverride[] = [
  // Android Command-line Tools / repository 归档(腾讯,路径与官方一致)
  { from: "https://dl.google.com/android/repository/", to: "https://mirrors.cloud.tencent.com/AndroidSDK/" },
  // Gradle 发行版(南大 mirror.nju.edu.cn,2026-09 实测 200;排在最前优先尝试)
  { from: "https://services.gradle.org/distributions/", to: "https://mirror.nju.edu.cn/gradle/" },
  // Gradle 发行版(腾讯)
  { from: "https://services.gradle.org/distributions/", to: "https://mirrors.cloud.tencent.com/gradle/" },
  // Gradle 发行版(华为,腾讯失败后的次选)
  { from: "https://services.gradle.org/distributions/", to: "https://mirrors.huaweicloud.com/gradle/" },
]

export type MirrorMode = "official" | "cn" | "custom"

export interface MirrorConfig {
  mode: MirrorMode
  /** custom 模式:用户提供的 host 替换表 */
  overrides: MirrorOverride[]
}

/**
 * 解析镜像配置(优先级:显式参数 > 环境变量 > 默认官方):
 * - DROIDSEAL_MIRROR=cn   → 内置国内镜像预设
 * - DROIDSEAL_MIRROR=off / official → 强制官方
 * - DROIDSEAL_MIRROR=https://m.example.com/dl/ → 自定义前缀(替换所有已知名单中命中的 URL 前缀)
 * 非法值忽略并回落官方(不阻断流水线)。
 */
export function resolveMirrorConfig(envValue?: string): MirrorConfig {
  const v = envValue?.trim().toLowerCase()
  if (!v || v === "official" || v === "off") return { mode: "official", overrides: [] }
  if (v === "cn") return { mode: "cn", overrides: CN_MIRROR_OVERRIDES }
  if (/^https:\/\//.test(v)) {
    return { mode: "custom", overrides: [{ from: "__KNOWN__", to: envValue!.trim() }] }
  }
  return { mode: "official", overrides: [] }
}

/**
 * 按镜像配置生成下载候选列表(多源容灾):
 * - official:仅官方源;
 * - cn:所有命中的镜像源(按名单顺序,腾讯→华为互备)+ 官方兜底,去重保序;
 * - custom:用户前缀 + 官方兜底。
 * 调用方逐个尝试,任一成功即止;全部失败最后抛官方源的错误(官方语义最标准)。
 */
export function resolveDownloadCandidates(url: string, config: MirrorConfig): string[] {
  if (config.mode === "official") return [url]
  const candidates: string[] = []
  const push = (u: string) => { if (!candidates.includes(u)) candidates.push(u) }
  for (const o of config.overrides) {
    if (o.from === "__KNOWN__") {
      for (const known of CN_MIRROR_OVERRIDES) {
        if (url.startsWith(known.from)) push(o.to + url.slice(known.from.length))
      }
    } else if (url.startsWith(o.from)) {
      push(o.to + url.slice(o.from.length))
    }
  }
  push(url) // 官方源永远兜底
  return candidates
}

/**
 * 按镜像配置重写下载 URL。official 模式原样返回;cn 模式做 host 前缀替换
 * (未命中的 URL 原样返回——镜像名单只覆盖已知稳定路径,不猜未知路径);
 * custom 模式把已知名单中命中的 URL 换成用户前缀 + 官方路径部分。
 */
export function resolveDownloadUrl(url: string, config: MirrorConfig): string {
  if (config.mode === "official") return url
  for (const o of config.overrides) {
    if (o.from === "__KNOWN__") {
      // custom:对任一已知官方前缀命中都换成用户前缀(保留官方路径部分)
      for (const known of CN_MIRROR_OVERRIDES) {
        if (url.startsWith(known.from)) {
          return o.to + url.slice(known.from.length)
        }
      }
      return url
    }
    if (url.startsWith(o.from)) return o.to + url.slice(o.from.length)
  }
  return url
}

/**
 * 是否应提供"切换国内镜像"交互提示:
 * 仅当 stdin 是交互式终端(TTY)时为 true——CI/管道环境(非 TTY)不询问,
 * 维持纯自动回退行为,避免挂死无人值守流水线。
 */
export function isInteractiveStdin(): boolean {
  try {
    return Boolean(process.stdin?.isTTY)
  } catch {
    return false
  }
}

/**
 * 交互式询问是否切换国内镜像继续下载(仅在 TTY 下被调用)。
 * 返回 true = 用户确认切换;false = 拒绝/无法读取(按拒绝处理,不阻塞)。
 * 60s 无输入超时按拒绝处理——终端挂着不回应时流水线不应永久等待。
 */
export async function promptMirrorSwitch(fileName: string): Promise<boolean> {
  if (!isInteractiveStdin()) {
    // 非 TTY 的专门提示(仅一行 stderr,不阻塞):脚本化/CI 用户需要知道
    // 存在切换选项——重跑加 --use-cn-mirror 或设 DROIDSEAL_MIRROR=cn 即可。
    console.error(`提示: ${fileName} 官方源下载受阻。非交互环境不询问——重跑时加 --use-cn-mirror 或设 DROIDSEAL_MIRROR=cn 可切换国内镜像重试。`)
    return false
  }
  try {
    const { createInterface } = await import("node:readline/promises")
    const rl = createInterface({ input: process.stdin, output: process.stderr })
    const timer = setTimeout(() => { try { rl.close() } catch { /* 忽略 */ } }, 60_000)
    try {
      const answer = await rl.question(
        `下载受阻: ${fileName} 无法从官方源获取。是否切换国内镜像继续?(Y/n) `,
      )
      const v = answer.trim().toLowerCase()
      return v === "" || v === "y" || v === "yes"
    } finally {
      clearTimeout(timer)
      rl.close()
    }
  } catch {
    return false
  }
}

/**
 * 解析可选代理配置(DROIDSEAL_PROXY=http://127.0.0.1:7890),
 * 用于 sdkmanager 等 Java 工具(不支持环境变量代理,需显式 --proxy 参数)。
 */
export function resolveProxyArgs(proxyEnv?: string): string[] {
  const v = proxyEnv?.trim()
  if (!v) return []
  const m = /^https?:\/\/([^/:]+):(\d+)\/?$/.exec(v)
  if (!m) return []
  return ["--proxy=http", `--proxy_host=${m[1]}`, `--proxy_port=${m[2]}`]
}
