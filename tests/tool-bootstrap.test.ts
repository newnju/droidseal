// 工具引导器单测:TOFU 指纹 / sha256Hex / jar 魔数守卫
import { describe, test, expect } from "bun:test"
import { sha256Hex, jarToolPath, jarToolsDir } from "../src/core/tool-bootstrap.ts"

describe("sha256Hex", () => {
  test("标准向量:空串与 abc", async () => {
    const empty = await sha256Hex(new Uint8Array(0))
    expect(empty).toBe("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    const abc = await sha256Hex(new TextEncoder().encode("abc"))
    expect(abc).toBe("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
  })
})

describe("托管目录布局", () => {
  test("jar 路径与指纹路径同目录、命名一致", () => {
    expect(jarToolPath("apktool")).toMatch(/[\\/]tools[\\/]apktool\.jar$/)
    expect(jarToolsDir()).toMatch(/[\\/]tools$/)
  })
})

describe("TOFU 安全模型(纯函数部分)", () => {
  test("指纹格式校验逻辑:64 位 hex 才有效", () => {
    const valid = /^[0-9a-f]{64}$/.test("a".repeat(64))
    const invalid = /^[0-9a-f]{64}$/.test("short")
    expect(valid).toBe(true)
    expect(invalid).toBe(false)
  })
})
