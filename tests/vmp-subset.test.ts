// 方法级 VM 子集编译单测:compileVmSubset + serializeVmPayload 往返
import { describe, test, expect } from "bun:test"
import { compileVmSubset, serializeVmPayload } from "../src/core/vmp-compiler.ts"

// 构造带 16B 头的 code_item:registers_size=2, ins_size=1(static (I)I),
// insns 区 = return-void(0x0e) + nop 填充(8B,4 字节对齐)
function codeItemWithHeader(insns: number[]): Uint8Array {
  const code = new Uint8Array(16 + insns.length)
  const v = new DataView(code.buffer)
  v.setUint16(0, 2, true) // registers_size
  v.setUint16(2, 1, true) // ins_size
  code.set(insns, 16)
  return code
}
function returnVoidCode(): Uint8Array {
  return codeItemWithHeader([0x0e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
}

// 不可翻译:非法操作码(0xfd 未覆盖)
function unsupportedCode(): Uint8Array {
  return codeItemWithHeader([0xfd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
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
    expect(res.compiled.length).toBe(1) // 0xfd 未覆盖 → fail-closed 如实跳过,不收录半成品
    expect(res.compiled[0]!.methodIdx).toBe(7)
    expect(res.compiled[0]!.vmCode.length).toBeGreaterThan(0)
    expect(res.skipped).toBe(2)
    expect(res.translatedBytes).toBe(8) // 仅收录方法的 insns 区(不含 16B 头)
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
    const payload = serializeVmPayload([{ methodIdx: 42, vmCode: code, initialReg: 0 }])
    const magic = new TextDecoder().decode(payload.slice(0, 13))
    expect(magic).toBe("DROIDSEAL_VMP")
    const view = new DataView(payload.buffer)
    expect(view.getUint32(14, true)).toBe(1)
    expect(view.getUint32(18, true)).toBe(42)
    expect(view.getUint32(22, true)).toBe(3)
    expect(view.getUint32(26, true)).toBe(0) // initial_reg
    expect(Array.from(payload.slice(30, 33))).toEqual([1, 2, 3])
    expect(payload.length).toBe(18 + 12 + 3)
  })
})
