// P1b 单测:混淆名归一(调用上下文指纹——方法体唯一 API 锚定)
import { describe, test, expect } from "bun:test"
import {
  parseMethodName,
  extractMethodBody,
  normalizeObfuscatedTarget,
  type GtPoint,
} from "../src/core/bench-flow.ts"

describe("parseMethodName", () => {
  test("解析 GT methodName;关键字与空串排除", () => {
    expect(parseMethodName("public void onCreate()")).toBe("onCreate")
    expect(parseMethodName("private String readConfig(String config)")).toBe("readConfig")
    expect(parseMethodName("")).toBeUndefined()
    expect(parseMethodName("if (x) {")).toBeUndefined()
  })
})

describe("extractMethodBody", () => {
  const SRC = `class A {
    void onCreate() {
      String x = t.i();
      send(x);
    }
    void other() { z.write(d); }
  }`
  test("按花括号配平提取方法体(不含后续方法)", () => {
    const body = extractMethodBody(SRC, "onCreate")!
    expect(body).toContain("t.i()")
    expect(body).not.toContain("z.write")
  })
  test("方法不存在返回 undefined", () => {
    expect(extractMethodBody(SRC, "missing")).toBeUndefined()
  })
})

describe("normalizeObfuscatedTarget", () => {
  const TEXTS = new Map([
    ["AdobeFlashCore", `class AdobeFlashCore {
      public void i() {
        String c = telephonyManager.getSimCountryIso();
      }
      public void k() {
        String d = t.getDeviceId();
        osw.write(d);
      }
    }`],
  ])
  test("混淆方法体内唯一 API → 归一到该 API", () => {
    const pt: GtPoint = { class: "com.x.AdobeFlashCore", line: 10, target: "i", method: "i" }
    expect(normalizeObfuscatedTarget(pt, TEXTS)).toBe("getSimCountryIso")
  })
  test("方法体内 ≥2 个已知 API → 歧义如实放弃", () => {
    const pt: GtPoint = { class: "com.x.AdobeFlashCore", line: 15, target: "k", method: "k" }
    expect(normalizeObfuscatedTarget(pt, TEXTS)).toBeUndefined()
  })
  test("已知 API 名不进入归一路径(走精确匹配)", () => {
    const pt: GtPoint = { class: "com.x.AdobeFlashCore", line: 10, target: "write", method: "k" }
    expect(normalizeObfuscatedTarget(pt, TEXTS)).toBeUndefined()
  })
  test("类不在语料 → undefined", () => {
    const pt: GtPoint = { class: "com.y.Other", line: 1, target: "i", method: "i" }
    expect(normalizeObfuscatedTarget(pt, TEXTS)).toBeUndefined()
  })
})
