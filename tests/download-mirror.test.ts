// download-mirror 单测:多镜像容灾(逐源候选列表,任一成功即止,官方永远兜底)
import { describe, test, expect } from "bun:test"
import {
  resolveMirrorConfig,
  resolveDownloadCandidates,
  resolveProxyArgs,
  promptMirrorSwitch,
  isInteractiveStdin,
  CN_MIRROR_OVERRIDES,
} from "../src/core/download-mirror.ts"

describe("resolveMirrorConfig 镜像配置解析", () => {
  test("默认/official/off → 官方源,零覆盖", () => {
    for (const v of [undefined, "", "official", "off"]) {
      const c = resolveMirrorConfig(v)
      expect(c.mode).toBe("official")
      expect(c.overrides.length).toBe(0)
    }
  })

  test("cn → 内置预设;非法值回落官方(不阻断)", () => {
    expect(resolveMirrorConfig("cn").mode).toBe("cn")
    expect(resolveMirrorConfig("garbage").mode).toBe("official")
  })

  test("https 前缀 → custom", () => {
    const c = resolveMirrorConfig("https://m.example.com/dl/")
    expect(c.mode).toBe("custom")
    expect(c.overrides[0]!.to).toBe("https://m.example.com/dl/")
  })
})

describe("resolveDownloadCandidates 多源候选列表", () => {
  const gradleUrl = "https://services.gradle.org/distributions/gradle-8.13-bin.zip"
  const androidUrl = "https://dl.google.com/android/repository/commandlinetools-win-15859902_latest.zip"

  test("official → 仅官方源", () => {
    const c = resolveDownloadCandidates(gradleUrl, resolveMirrorConfig(undefined))
    expect(c).toEqual([gradleUrl])
  })

  test("cn + gradle → 南大、腾讯、华为三镜像在前,官方兜底,去重保序", () => {
    const c = resolveDownloadCandidates(gradleUrl, resolveMirrorConfig("cn"))
    expect(c.length).toBe(4)
    expect(c[0]).toBe("https://mirror.nju.edu.cn/gradle/gradle-8.13-bin.zip")
    expect(c[1]).toBe("https://mirrors.cloud.tencent.com/gradle/gradle-8.13-bin.zip")
    expect(c[2]).toBe("https://mirrors.huaweicloud.com/gradle/gradle-8.13-bin.zip")
    expect(c[3]).toBe(gradleUrl)
  })

  test("cn + android → 只有腾讯命中(华为无该路径),官方兜底", () => {
    const c = resolveDownloadCandidates(androidUrl, resolveMirrorConfig("cn"))
    expect(c.length).toBe(2)
    expect(c[0]).toBe("https://mirrors.cloud.tencent.com/AndroidSDK/commandlinetools-win-15859902_latest.zip")
    expect(c[1]).toBe(androidUrl)
  })

  test("cn + 未知名单的 URL → 官方兜底(不猜未知路径)", () => {
    const c = resolveDownloadCandidates("https://example.com/foo.zip", resolveMirrorConfig("cn"))
    expect(c).toEqual(["https://example.com/foo.zip"])
  })

  test("custom → 用户前缀命中已知官方路径 + 官方兜底", () => {
    const c = resolveDownloadCandidates(gradleUrl, resolveMirrorConfig("https://m.example.com/dl/"))
    expect(c.length).toBe(2)
    expect(c[0]).toBe("https://m.example.com/dl/gradle-8.13-bin.zip")
    expect(c[1]).toBe(gradleUrl)
  })

  test("镜像预设:Gradle 至少两个国内源互备", () => {
    const gradleMirrors = CN_MIRROR_OVERRIDES.filter((o) => o.from === "https://services.gradle.org/distributions/")
    expect(gradleMirrors.length).toBeGreaterThanOrEqual(2)
  })
})

describe("promptMirrorSwitch 交互切换提示", () => {
  test("非 TTY(CI/管道)→ 直接 false,不询问不阻塞", async () => {
    // 显式 stub isTTY=false:不依赖测试运行器环境(控制台/计划任务/管道下
    // stdin 状态不同)——本用例保障的是"非 TTY 分支自动拒绝"这一确定性行为
    const desc = Object.getOwnPropertyDescriptor(process.stdin, "isTTY")
    Object.defineProperty(process.stdin, "isTTY", { value: false, configurable: true })
    try {
      const r = await promptMirrorSwitch("gradle-8.13-bin.zip")
      expect(r).toBe(false)
    } finally {
      if (desc) Object.defineProperty(process.stdin, "isTTY", desc)
      else delete (process.stdin as unknown as { isTTY?: boolean }).isTTY
    }
  })

  test("isInteractiveStdin 与 TTY 状态一致", () => {
    expect(isInteractiveStdin()).toBe(Boolean(process.stdin?.isTTY))
  })
})

describe("resolveProxyArgs sdkmanager 代理参数", () => {
  test("未配置 → 空参数(行为不变)", () => {
    expect(resolveProxyArgs(undefined)).toEqual([])
    expect(resolveProxyArgs("")).toEqual([])
  })

  test("合法代理 → 显式参数三元组", () => {
    expect(resolveProxyArgs("http://127.0.0.1:7890")).toEqual([
      "--proxy=http", "--proxy_host=127.0.0.1", "--proxy_port=7890",
    ])
    expect(resolveProxyArgs("https://proxy.internal:8443")).toEqual([
      "--proxy=http", "--proxy_host=proxy.internal", "--proxy_port=8443",
    ])
  })

  test("非法格式 → 空参数(忽略,不阻断)", () => {
    expect(resolveProxyArgs("not-a-proxy")).toEqual([])
    expect(resolveProxyArgs("http://noport")).toEqual([])
  })
})
