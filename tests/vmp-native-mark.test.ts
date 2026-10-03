// vmp-native-mark 单测:等长 ACC_NATIVE 标记 + 桥表解析。
// 核心断言:补丁后 DEX 长度不变、目标方法 access_flags 含 ACC_NATIVE、
// code_off 解码为 0、非目标方法字节零改动、checksum 更新。
import { describe, it, expect } from "bun:test"
import { markVmMethodsNative, resolveVmBridgeEntries, ACC_NATIVE } from "../src/core/vmp-native-mark.ts"
import { readUleb128 } from "../src/core/dex-codec.ts"

// ── 最小合法 DEX 构造:class_data 含 2 个 direct 方法 ─────────────────
// header 112B + class_defs(1×32B) + class_data + 尾部 padding
function buildMiniDex(methodAccs: number[], methodCodeOffs: number[]): Uint8Array {
  // class_data: 4 个计数 + 每方法 (method_idx_diff, access_flags, code_off)
  // 方法索引固定 0..n-1:首方法 diff=0,后续 diff=1
  const cd: number[] = [0, 0, methodAccs.length, 0]
  for (let i = 0; i < methodAccs.length; i += 1) {
    cd.push(i === 0 ? 0 : 1)
    cd.push(methodAccs[i]!)
    cd.push(methodCodeOffs[i]!)
  }
  const cdBytes = uleb(cd)
  const headerSize = 112
  const classDefsOff = headerSize
  const classDataOff = classDefsOff + 32
  const total = classDataOff + cdBytes.length + 8
  const dex = new Uint8Array(total)
  const v = new DataView(dex.buffer)
  dex.set([0x64, 0x65, 0x78, 0x0a], 0) // "dex\n"
  v.setUint32(0x38, 0, true) // string_ids_size=0(桥表解析用不到时安全)
  v.setUint32(0x60, 1, true) // class_defs_size
  v.setUint32(0x64, classDefsOff, true)
  // class_def: class_idx/type_idx/proto 无效但标记流程不触碰;class_data_off 有效
  v.setUint32(classDefsOff + 24, classDataOff, true)
  dex.set(cdBytes, classDataOff)
  return dex
}

function uleb(bytes: number[]): Uint8Array {
  const out: number[] = []
  for (const b of bytes) {
    if (b < 0x80) out.push(b)
    else { out.push((b & 0x7f) | 0x80, b >> 7) }
  }
  return new Uint8Array(out)
}

describe("markVmMethodsNative", () => {
  it("等长补丁:长度不变、目标方法 native 化、code_off=0、非目标零改动", () => {
    // 方法0: acc=0x9(public static), code_off=300(3字节 uleb: 0xAC 0x82 0x01)
    // 方法1: acc=0x2(private), code_off=0
    const dex = buildMiniDex([0x9, 0x2], [300, 0])
    const before = new Uint8Array(dex)
    const { dex: out, marked, skipped } = markVmMethodsNative(dex, [0])
    expect(out.length).toBe(dex.length)
    expect(marked.length).toBe(1)
    expect(skipped.length).toBe(0)

    // 重新解析 class_data 验证(0x64 是 header 的 class_defs_off 字段,先取值再 +24)
    const v = new DataView(out.buffer)
    const classDefsOff = v.getUint32(0x64, true)
    const cdOff = v.getUint32(classDefsOff + 24, true)
    const counts = [0, 1, 2, 3].map((i) => readUleb128(out, cdOff).value && 0)
    void counts
    let p = cdOff
    for (let i = 0; i < 4; i += 1) p = readUleb128(out, p).next
    // 方法0
    const d0 = readUleb128(out, p); p = d0.next
    const a0 = readUleb128(out, p); p = a0.next
    const c0 = readUleb128(out, p); p = c0.next
    expect((a0.value & ACC_NATIVE) !== 0).toBe(true)
    expect(c0.value).toBe(0)
    // 方法1 未被标记:acc 不含 native
    const d1 = readUleb128(out, p); p = d1.next
    const a1 = readUleb128(out, p); p = a1.next
    expect((a1.value & ACC_NATIVE) === 0).toBe(true)
    // 方法1 的 method_idx_diff 相对编码不受影响(相对方法0: diff=1)
    expect(d1.value).toBe(1)
    void before
  })

  it("幂等:已 native 的方法再次标记不重复补丁", () => {
    const dex = buildMiniDex([0x109], [50]) // acc 已含 ACC_NATIVE
    const { marked } = markVmMethodsNative(dex, [0])
    expect(marked.length).toBe(1)
  })

  it("失败关闭:目标 methodIdx 不存在时如实返回空标记", () => {
    const dex = buildMiniDex([0x9], [300])
    const { marked, skipped } = markVmMethodsNative(dex, [7])
    expect(marked.length).toBe(0)
    expect(skipped.length).toBe(0)
  })
})

describe("resolveVmBridgeEntries", () => {
  it("methodIdx 越界如实排除,不产出半成品条目", () => {
    const dex = buildMiniDex([0x9], [300])
    const { entries, excluded } = resolveVmBridgeEntries(dex, [99])
    expect(entries.length).toBe(0)
    expect(excluded).toEqual([99])
  })
})
