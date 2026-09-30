// P3 对照组产物测试:dump-code(抽取方法明文 JSON)+ mapping.txt(随机化映射)+ keep-classes 端到端。
// 口径:dump-code 的类/方法名解析自 string/type/proto/method_ids 表,与 stubMethods 一一对应;
// keep-classes 语义 = 排除类的方法不抽取(保留明文),非排除类照常。
import { describe, expect, test } from "bun:test"
import { readFileSync } from "node:fs"
import path from "node:path"
import { hollowMethods, parseClassExclusionRules } from "../src/core/dex-protection.ts"
import { dumpExtractedCodeItems, serializeMappingTxt } from "../src/core/dex-artifacts.ts"

const loaderDex = () => new Uint8Array(readFileSync(path.join(import.meta.dir, "..", "runtime", "droidseal-loader.dex")))

describe("dex-artifacts · dump-code", () => {
  test("抽取方法 dump 出可读类名/方法名/proto/codeHex,与 stub 一一对应", () => {
    const dex = loaderDex()
    const hr = hollowMethods(dex, [])
    expect(hr.summary.hollowedMethods).toBeGreaterThan(0)
    const entries = dumpExtractedCodeItems(hr.hollowedDex, hr.stubMethods, hr.extractedCodeItems)
    expect(entries.length).toBe(hr.stubMethods.length)
    for (let i = 0; i < entries.length; i += 1) {
      const e = entries[i]!
      expect(e.classDescriptor).toMatch(/^L[\w/$-]+;$/)
      expect(e.methodName.length).toBeGreaterThan(0)
      expect(e.proto).toMatch(/^\([\[\w/$;]*\)\[[\w/[$;]+$/)
      expect(e.codeHex.length).toBe(e.codeSize * 2)
      // codeHex 必须与 extractedCodeItems 原始字节一致(key = originalCodeOff)
      expect(hr.extractedCodeItems.has(e.codeOff)).toBe(true)
    }
  })

  test("空 stub / 非法输入如实返回空数组(不抛异常)", () => {
    const dex = loaderDex()
    expect(dumpExtractedCodeItems(dex, [], new Map())).toEqual([])
    expect(dumpExtractedCodeItems(new Uint8Array(16), [], new Map())).toEqual([])
  })

  test("methodIdx 越界的 stub 如实跳过(不越界读表)", () => {
    const dex = loaderDex()
    const bogus = [{ classIdx: 0, methodIdx: 0xffffff, originalCodeOff: 0, originalCodeSize: 0 }]
    expect(dumpExtractedCodeItems(dex, bogus, new Map())).toEqual([])
  })
})

describe("dex-artifacts · keep-classes(排除规则端到端)", () => {
  test("parseClassExclusionRules 通配符 → 排除类方法不抽取,其余照常(数量精确守恒)", () => {
    const dex = loaderDex()
    const all = hollowMethods(dex, [])
    expect(all.summary.hollowedMethods).toBeGreaterThan(0)
    const rules = parseClassExclusionRules(JSON.stringify(["Ldroidseal/**;"]))
    expect(rules.length).toBe(1)
    expect(rules[0]!.test("Ldroidseal/runtime/DroidSealLoader;")).toBe(true)

    // 先用 dump-code 定位全量抽取中属于排除类的精确数量
    const allEntries = dumpExtractedCodeItems(all.hollowedDex, all.stubMethods, all.extractedCodeItems)
    const excludedCount = allEntries.filter((e) => rules[0]!.test(e.classDescriptor)).length
    expect(excludedCount).toBeGreaterThan(0)

    // keep-classes:排除类不抽取,其余照常(数量严格守恒)
    const partial = hollowMethods(dex, rules)
    expect(partial.summary.hollowedMethods).toBe(all.summary.hollowedMethods - excludedCount)

    // 排除全部 → 零抽取
    expect(hollowMethods(dex, [/.*/]).summary.hollowedMethods).toBe(0)
  })

  test("非法规则输入 fail-safe 为空规则(不抛异常)", () => {
    expect(parseClassExclusionRules("not-json")).toEqual([])
    expect(parseClassExclusionRules(JSON.stringify({ a: 1 }))).toEqual([])
    expect(parseClassExclusionRules(JSON.stringify([1, null]))).toEqual([])
  })
})

describe("dex-artifacts · mapping.txt", () => {
  test("序列化含头部说明、kind 前缀行与尾部换行", () => {
    const txt = serializeMappingTxt([
      { kind: "loader-class", from: "droidseal/runtime/ShellApplication", to: "ab12cd34/Wxzyqabc" },
      { kind: "identifier", from: "droidseal.bin", to: "qx7ke2mfy1.bin" },
    ])
    expect(txt).toContain("# DroidSeal mapping")
    expect(txt).toContain("loader-class: droidseal/runtime/ShellApplication -> ab12cd34/Wxzyqabc")
    expect(txt).toContain("identifier: droidseal.bin -> qx7ke2mfy1.bin")
    expect(txt.endsWith("\n")).toBe(true)
  })

  test("空记录只输出头部说明", () => {
    const txt = serializeMappingTxt([])
    expect(txt).toContain("# DroidSeal mapping")
    expect(txt).not.toContain("loader-class:")
  })
})
