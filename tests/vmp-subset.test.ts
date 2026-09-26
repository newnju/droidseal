// 方法级 VM 子集编译单测:compileVmSubset + serializeVmPayload 往返
import { describe, test, expect } from "bun:test"
import { compileVmSubset, serializeVmPayload } from "../src/core/vmp-compiler.ts"

// 构造 Dalvik CodeItem:return-void(0x0e)+ 15 字节 nop padding(dex code_item 4 字节对齐惯例)
function returnVoidCode(): Uint8Array {
  const code = new Uint8Array(16)
  code[0] = 0x0e
  for (let i = 1; i < 16; i += 1) code[i] = 0x00 // nop
  return code
}

// 不可翻译:非法操作码(0xfd 未覆盖)
function unsupportedCode(): Uint8Array {
  const code = new Uint8Array(16)
  code[0] = 0xfd
  return code
}

// 注:未知操作码会走 VM_OPCODES.EXTENDED(0xFF) 兜底路径被"翻译"收录——
// 真正产生 skip 的是无 CodeItem 的方法。此处验证收录与 skip 计数路径。
describe("compileVmSubset 方法级 VM 子集", () => {
  test("可翻译方法编译收录;无 CodeItem 的方法如实跳过", () => {
    const items = new Map<number, Uint8Array>([
      [0x100, returnVoidCode()],
      [0x200, unsupportedCode()],
    ])
    const stubs = [
      { methodIdx: 7, originalCodeOff: 0x100 },
      { methodIdx: 8, originalCodeOff: 0x200 },
      { methodIdx: 9, originalCodeOff: 0x300 }, // 无 CodeItem
    ]
    const res = compileVmSubset(items, stubs)
    expect(res.compiled.length).toBe(2) // 0xfd 走 EXTENDED 兜底,同样收录
    expect(res.compiled[0]!.methodIdx).toBe(7)
    expect(res.compiled[0]!.vmCode.length).toBeGreaterThan(0)
    expect(res.skipped).toBe(1)
    expect(res.translatedBytes).toBe(32)
  })

  test("maxMethods 上限生效,超限计入 skipped", () => {
    const items = new Map<number, Uint8Array>([[0x100, returnVoidCode()]])
    const stubs = Array.from({ length: 5 }, (_, i) => ({ methodIdx: i, originalCodeOff: 0x100 }))
    const res = compileVmSubset(items, stubs, 2)
    expect(res.compiled.length).toBe(2)
    expect(res.skipped).toBe(3)
  })
})

describe("serializeVmPayload 格式", () => {
  test("magic + count + 逐条 (methodIdx + len + code) 往返一致", () => {
    const code = new Uint8Array([0x01, 0x02, 0x03])
    const payload = serializeVmPayload([{ methodIdx: 42, vmCode: code }])
    const magic = new TextDecoder().decode(payload.slice(0, 13))
    expect(magic).toBe("DROIDSEAL_VMP")
    const view = new DataView(payload.buffer)
    expect(view.getUint32(14, true)).toBe(1)
    expect(view.getUint32(18, true)).toBe(42)
    expect(view.getUint32(22, true)).toBe(3)
    expect(Array.from(payload.slice(26, 29))).toEqual([1, 2, 3])
    expect(payload.length).toBe(18 + 8 + 3)
  })
})
