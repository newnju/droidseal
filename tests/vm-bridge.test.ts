// P0 里程碑 B 单测:RegisterNatives 桥生成器 + stub native 标记
import { describe, test, expect } from "bun:test"
import {
  generateVmRegisterBridgeC,
  markStubNative,
  isStubNative,
  ACC_NATIVE,
  serializeVmPayload,
  type VmBridgeEntry,
} from "../src/core/vmp-compiler.ts"

const ENTRIES: VmBridgeEntry[] = [
  { stubName: "ds_vm_1", signature: "(II)I", methodIdx: 7 },
  { stubName: "ds_vm_2", signature: "(I)I", methodIdx: 13 },
]

describe("generateVmRegisterBridgeC", () => {
  const c = generateVmRegisterBridgeC(ENTRIES)

  test("注册表含 stub 名/签名二元组(fnPtr 构建期为 NULL,运行时 g_thunks 回填)", () => {
    expect(c).toContain('{ "ds_vm_1", "(II)I", NULL }')
    expect(c).toContain('{ "ds_vm_2", "(I)I", NULL }')
  })

  test("含 RegisterNatives 调用与 payload 查表(magic 校验)", () => {
    expect(c).toContain("RegisterNatives")
    expect(c).toContain("DROIDSEAL_VMP")
    expect(c).toContain("dsvm_execute_leaf")
  })

  test("每个条目一个 thunk,methodIdx 预置正确", () => {
    expect(c).toContain("vm_thunk_0")
    expect(c).toContain("vm_dispatch_leaf(env, clazz, arg, 7)")
    expect(c).toContain("vm_dispatch_leaf(env, clazz, arg, 13)")
  })

  test("fail-open/fail-closed 边界如实标注", () => {
    expect(c).toContain("fail-open")
    expect(c).toContain("fail-closed")
  })

  test("空表生成合法空桥(注册 0 方法)", () => {
    const empty = generateVmRegisterBridgeC([])
    expect(empty).toContain("RegisterNatives")
    expect(empty).not.toContain("vm_thunk_0")
  })
})

describe("stub native 标记", () => {
  test("markStubNative 置位 ACC_NATIVE(幂等)", () => {
    expect(markStubNative(0x0002)).toBe(0x0102)
    expect(markStubNative(0x0102)).toBe(0x0102) // 已置位原样
    expect(isStubNative(markStubNative(0))).toBe(true)
    expect(isStubNative(0x0002)).toBe(false)
  })

  test("ACC_NATIVE 值与 Dalvik 规范一致(0x0100)", () => {
    expect(ACC_NATIVE).toBe(0x0100)
  })
})

describe("桥与 payload 布局一致性", () => {
  test("serializeVmPayload 的 magic/查表偏移与桥 C 的假设一致", () => {
    // 桥 C:14B magic + 4B count,条目 12B 头(idx+len+initial_reg)——TS 侧序列化必须同布局
    const payload = serializeVmPayload([{ methodIdx: 7, vmCode: new Uint8Array([0x02, 0x00, 0x05, 0x00, 0x1d, 0x00]), initialReg: 0 }])
    expect(payload.byteLength).toBe(14 + 4 + 4 + 4 + 4 + 6)
    const magic = new TextDecoder().decode(payload.slice(0, 13))
    expect(magic).toBe("DROIDSEAL_VMP")
    const view = new DataView(payload.buffer)
    expect(view.getUint32(14, true)).toBe(1) // method_count
    expect(view.getUint32(18, true)).toBe(7) // 首条 method_idx(桥 C 查表起点 pos=18)
  })
})
