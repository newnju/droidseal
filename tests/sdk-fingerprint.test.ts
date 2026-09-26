// SDK 指纹库单测:detectSdkFingerprints / detectSdkPackages
import { describe, test, expect } from "bun:test"
import { detectSdkFingerprints, detectSdkPackages, SDK_FINGERPRINTS } from "../src/core/dex-scan.ts"

describe("SDK 指纹库", () => {
  test("指纹库条目完备:每条有 name/category,prefix 以 L 开头 / 结尾", () => {
    expect(SDK_FINGERPRINTS.length).toBeGreaterThanOrEqual(30)
    for (const f of SDK_FINGERPRINTS) {
      expect(f.name.length).toBeGreaterThan(0)
      expect(f.category.length).toBeGreaterThan(0)
      expect(f.prefix.startsWith("L")).toBe(true)
      expect(f.prefix.endsWith("/")).toBe(true)
    }
  })

  test("命中返回完整指纹(带类别/注记);同 SDK 多描述符去重", () => {
    const strs = ["Lcom/umeng/analytics/UMengHelper;", "Lcom/umeng/common/Util;", "Lcom/squareup/okhttp/OkHttpClient;"]
    const fps = detectSdkFingerprints(strs)
    expect(fps.length).toBe(2)
    const umeng = fps.find((f) => f.name.includes("Umeng"))
    expect(umeng?.category).toBe("统计")
    expect(umeng?.note).toBeTruthy()
    const okhttp = fps.find((f) => f.name === "OkHttp")
    expect(okhttp?.category).toBe("网络")
  })

  test("非 L 开头/未命中返回空", () => {
    expect(detectSdkFingerprints(["com/umeng/x", "Ljava/lang/String;", ""]).length).toBe(0)
  })

  test("detectSdkPackages 兼容旧口径:返回 name 列表", () => {
    const names = detectSdkPackages(["Lcn/jpush/android/api/JPushInterface;"])
    expect(names).toEqual(["极光推送 JPush"])
  })
})
