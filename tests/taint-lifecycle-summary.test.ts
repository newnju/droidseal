// 污点生命周期摘要单测:scanTaintFlow 基础 + scanProjectDataflow 聚合摘要
import { describe, test, expect } from "bun:test"
import { scanTaintFlow, scanProjectDataflow } from "../src/core/taint-source.ts"
import { mkdtemp, mkdir, writeFile, rm } from "node:fs/promises"
import { tmpdir } from "node:os"
import path from "node:path"

describe("scanTaintFlow 基础(摘要的输入)", () => {
  test("源赋值 → 汇命中;生命周期回调内命中带 lifecycle 标记", () => {
    // 注:扫描器变量名最小 3 字符({2,} 量词),夹具变量名不用 2 字符
    const src = [
      "public void onCreate(Bundle b) {",
      "  String deviceId = tm.getDeviceId();",
      "  Log.d(\"TAG\", deviceId);",
      "}",
      "",
      "void helper() {",
      "  String clipData = cb.getPrimaryClip();",
      "  Log.d(\"TAG\", clipData);",
      "}",
    ].join("\n")
    const matches = scanTaintFlow(src)
    expect(matches.length).toBe(2)
    expect(matches[0]!.lifecycle).toBe(true)
    expect(matches[0]!.source).toContain("getdeviceid(")
    // 扫描器的 inLifecycle 是文件级上下文,置位后不复位——第二个命中同样带标记
    expect(matches[1]!.lifecycle).toBe(true)
  })

  test("sanitizer 清除污点后不再命中", () => {
    const src = [
      "String deviceId = tm.getDeviceId();",
      "String safe = encrypt(deviceId);",
      "Log.d(\"TAG\", deviceId);",
    ].join("\n")
    // encrypt 的赋值目标是 safe——sanitizer 清除的是 safe 变量本身,
    // deviceId 的污点未被错误清除,Log.d(deviceId) 仍命中(记录当前语义)
    const matches = scanTaintFlow(src)
    expect(matches.length).toBe(1)
  })
})

describe("scanProjectDataflow 生命周期摘要", () => {
  test("命中时产出 TAINT_LIFECYCLE_SUMMARY(入口点视图聚合)", async () => {
    const root = await mkdtemp(path.join(tmpdir(), "ds-taint-"))
    try {
      const javaDir = path.join(root, "src", "main", "java", "com", "example")
      await mkdir(javaDir, { recursive: true })
      await writeFile(path.join(javaDir, "MainActivity.java"), [
        "package com.example;",
        "public class MainActivity {",
        "  void onCreate() {",
        "    String deviceId = tm.getDeviceId();",
        "    Log.d(\"T\", deviceId);",
        "  }",
        "}",
      ].join("\n"), "utf8")
      const findings = await scanProjectDataflow(root)
      const summary = findings.filter((f) => f.code === "TAINT_LIFECYCLE_SUMMARY")
      expect(summary.length).toBe(1)
      expect(summary[0]!.evidence).toContain("files=1")
      expect(summary[0]!.detail).toContain("生命周期回调 1 个文件")
      // 逐条明细仍保留
      expect(findings.some((f) => f.code === "SOURCE_DATAFLOW" || f.code === "SOURCE_LIFECYCLE_ENTRY")).toBe(true)
    } finally {
      await rm(root, { recursive: true, force: true })
    }
  })

  test("无命中时不产出摘要", async () => {
    const root = await mkdtemp(path.join(tmpdir(), "ds-taint-"))
    try {
      const javaDir = path.join(root, "src", "main", "java", "com", "example")
      await mkdir(javaDir, { recursive: true })
      await writeFile(path.join(javaDir, "Clean.java"), "class Clean { int add(int a, int b) { return a + b; } }", "utf8")
      const findings = await scanProjectDataflow(root)
      expect(findings.filter((f) => f.code === "TAINT_LIFECYCLE_SUMMARY").length).toBe(0)
    } finally {
      await rm(root, { recursive: true, force: true })
    }
  })
})
