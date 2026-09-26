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

/** 国内常用公共镜像(路径布局与官方一致,仅换 host)。 */
export const CN_MIRROR_OVERRIDES: MirrorOverride[] = [
  // Android Command-line Tools / repository 归档(腾讯镜像,路径与官方一致)
  { from: "https://dl.google.com/android/repository/", to: "https://mirrors.cloud.tencent.com/AndroidSDK/" },
  // Gradle 发行版(腾讯镜像,distributions 路径一致)
  { from: "https://services.gradle.org/distributions/", to: "https://mirrors.cloud.tencent.com/gradle/" },
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
