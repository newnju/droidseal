// P2 单测:finding 可执行化——allowBackup/debuggable AXML 补丁
import { describe, test, expect } from "bun:test"
import {
  flipAllowBackupInAxml,
  manifestBytesAreDebuggable,
  flipDebuggableInAxml,
} from "../src/core/harden-manifest.ts"
import { buildAxmlFixture, type FixtureElement } from "./axml-fixture.ts"

const BOOL_TRUE = 0xffffffff
const ALLOW_BACKUP_RES_ID = 0x01010280
const DEBUGGABLE_RES_ID = 0x0101000f

// fixture 的属性名走字符串索引,而翻转按 resource-map 的 resId 定位——
// buildAxmlFixture 不生成 resource-map,所以这里直接手工构造带 resource-map 的 AXML。
function buildAxmlWithResMap(attrs: Array<{ resId: number; value: number }>): Uint8Array {
  // 复用 fixture 生成 START_TAG/END_TAG,再前置 resource-map chunk
  const el: FixtureElement = { tag: "application", attributes: attrs.map(() => ({ name: "x", value: "y" })) }
  const base = buildAxmlFixture([el])
  // 简化:直接在字符串池后插入 resource-map 是结构性改动;改为独立小构造器。
  // ——此处改为校验用最小 AXML:XML 头 + string pool(空)+ resource-map + START_TAG
  return buildMinimalAxml(attrs)
}

function u16(v: number): number[] { return [v & 0xff, (v >> 8) & 0xff] }
function u32(v: number): number[] { return [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >>> 24) & 0xff] }

// 最小 AXML:string pool(2 串:"application" / "x")+ resource-map + START_TAG(application, boolean attrs)
function buildMinimalAxml(attrs: Array<{ resId: number; value: number }>): Uint8Array {
  // strings: 0="application", 1="attr-name"(每个属性名不进池——属性名用 resId 索引定位,name 索引须等于 res-map 下标)
  // 关键:flip 按 resource-map 下标 i 匹配 attr.name 索引——所以 attr.name 必须写成 i(res-map 中的位置)。
  const strings = ["application"]
  const poolData: number[] = []
  const offsets: number[] = []
  for (const s of strings) {
    offsets.push(poolData.length)
    poolData.push(s.length, s.length, ...new TextEncoder().encode(s), 0)
  }
  while (poolData.length % 4 !== 0) poolData.push(0)
  const stringCount = strings.length
  const stringsStart = 28 + stringCount * 4
  const poolSize = stringsStart + poolData.length
  const pool: number[] = [
    ...u16(0x0001), ...u16(28), ...u32(poolSize),
    ...u32(stringCount), ...u32(0), ...u32(0x0100), ...u32(stringsStart), ...u32(0),
  ]
  for (let i = 0; i < stringCount; i += 1) pool.push(...u32(offsets[i]!))
  pool.push(...poolData)

  // resource-map:resId 依 attrs 顺序 → 下标即 attr.name 索引
  const mapSize = 8 + attrs.length * 4
  const resMap: number[] = [...u16(0x0180), ...u16(8), ...u32(mapSize)]
  for (const a of attrs) resMap.push(...u32(a.resId))

  // START_TAG <application>:属性 ns=NO_INDEX, name=下标 i, rawValue=NO_INDEX, typedValue boolean
  const NO_INDEX = 0xffffffff
  const attrChunks: number[][] = attrs.map((a, i) => [
    ...u32(NO_INDEX), ...u32(i), ...u32(NO_INDEX),
    ...u16(8), 0, 0x12, ...u32(a.value),
  ])
  const tagSize = 36 + attrs.length * 20
  const startTag: number[] = [
    ...u16(0x0102), ...u16(16), ...u32(tagSize),
    ...u32(1), ...u32(NO_INDEX), ...u32(NO_INDEX), ...u32(0), // name="application"
    ...u16(20), ...u16(20), ...u16(attrs.length),
    ...u16(0), ...u16(0), ...u16(0), // idIndex/styleIndex/classIndex(attrExt 尾部,补齐 36 字节头)
  ]
  for (const a of attrChunks) startTag.push(...a)
  const endTag: number[] = [...u16(0x0103), ...u16(16), ...u32(24), ...u32(1), ...u32(NO_INDEX), ...u32(NO_INDEX), ...u32(0)]

  const tail: number[] = [...resMap, ...startTag, ...endTag]
  const total = 8 + poolSize + tail.length
  const head: number[] = [...u16(0x0003), ...u16(8), ...u32(total)]
  return new Uint8Array([...head, ...pool, ...tail])
}

describe("flipAllowBackupInAxml", () => {
  test("allowBackup=true → false(长度保持,原位翻转)", () => {
    const axml = buildMinimalAxml([{ resId: ALLOW_BACKUP_RES_ID, value: BOOL_TRUE }])
    expect(axml.byteLength).toBeGreaterThan(0)
    expect(flipAllowBackupInAxml(axml)).toBe(true)
    // 翻转后字节长度不变,typedValue.data 变 0:重新解析校验
    const view = new DataView(axml.buffer)
    // START_TAG 位于 resource-map 后;属性区 data 在末尾 4 字节前的 START_TAG 内——直接找 BOOL_FALSE
    let foundFalse = false
    for (let i = 0; i < axml.byteLength - 4; i += 1) {
      if (view.getUint32(i, true) === 0 && view.getUint8(i - 1) === 0x12) foundFalse = true
    }
    expect(foundFalse).toBe(true)
  })

  test("allowBackup 已是 false → changed:false", () => {
    const axml = buildMinimalAxml([{ resId: ALLOW_BACKUP_RES_ID, value: 0 }])
    expect(flipAllowBackupInAxml(axml)).toBe(false)
  })

  test("无 allowBackup 属性 → changed:false 不误翻", () => {
    const axml = buildMinimalAxml([{ resId: 0x01010003, value: BOOL_TRUE }]) // android:name
    expect(flipAllowBackupInAxml(axml)).toBe(false)
  })

  test("非 AXML 输入抛 AXML_INVALID(fail-closed)", () => {
    expect(() => flipAllowBackupInAxml(new Uint8Array([0, 0, 0, 0]))).toThrow(/二进制/)
  })
})

describe("debuggable 补丁(既有能力回归确认)", () => {
  test("flipDebuggableInAxml 同机制可用", () => {
    const axml = buildMinimalAxml([{ resId: DEBUGGABLE_RES_ID, value: BOOL_TRUE }])
    expect(flipDebuggableInAxml(axml)).toBe(true)
  })
})
