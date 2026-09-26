// patchSoTextCrc 单测:构建期 text 段 CRC 补丁(inline hook 检测的嵌入侧)
// 附带交叉验证:tsCrc32 走标准 CRC-32(IEEE,多项式 0xEDB88320,初值/final XOR
// 与 crc32.c 的 droidseal_crc32 同表同算法)——用 "123456789"→0xCBF43926 规范向量绑定。
import { describe, test, expect } from "bun:test"
import { patchSoTextCrc } from "../src/core/native-shell.ts"

// 构造最小 ELF64:
//   phdr 表 @64;随后 N 个 PT_LOAD(R+X)各 9 字节 "123456789"(标准 CRC32 测试向量);
//   可选 PT_LOAD(R,.rodata 代表)内嵌 "DSTC" 标记块(魔数 + 8 字节占位)。
function buildSo(opts: { marker: boolean; xSegs: number }): { bytes: Uint8Array; markerOff: number; xOff: number } {
  const phoff = 64
  const phentsize = 56
  const phnum = opts.xSegs + (opts.marker ? 1 : 0)
  const phEnd = phoff + phnum * phentsize
  const segContent = new TextEncoder().encode("123456789")
  const segs: Array<{ off: number; flags: number }> = []
  let cursor = phEnd
  for (let i = 0; i < opts.xSegs; i += 1) {
    segs.push({ off: cursor, flags: 5 }) // PF_R | PF_X
    cursor += segContent.length
  }
  let markerOff = -1
  if (opts.marker) {
    markerOff = cursor
    cursor += 12
  }
  const bytes = new Uint8Array(cursor)
  bytes.set([0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0], 0) // ELF64-LE
  const view = new DataView(bytes.buffer)
  view.setUint16(16, 3, true) // ET_DYN
  view.setBigUint64(0x20, BigInt(phoff), true) // e_phoff
  view.setUint16(0x36, phentsize, true)
  view.setUint16(0x38, phnum, true)
  let pi = 0
  for (const s of segs) {
    const b = phoff + pi * phentsize
    view.setUint32(b, 1, true) // PT_LOAD
    view.setUint32(b + 4, s.flags, true)
    view.setBigUint64(b + 8, BigInt(s.off), true) // p_offset
    view.setBigUint64(b + 16, BigInt(s.off), true) // p_vaddr
    view.setBigUint64(b + 24, BigInt(segContent.length), true) // p_filesz
    view.setBigUint64(b + 32, BigInt(segContent.length), true) // p_memsz
    view.setBigUint64(b + 40, 4096n, true) // p_align
    bytes.set(segContent, s.off)
    pi += 1
  }
  if (opts.marker && markerOff >= 0) {
    const b = phoff + pi * phentsize
    view.setUint32(b, 1, true) // PT_LOAD
    view.setUint32(b + 4, 4, true) // PF_R(只读,非可执行)
    view.setBigUint64(b + 8, BigInt(markerOff), true)
    view.setBigUint64(b + 16, BigInt(markerOff), true)
    view.setBigUint64(b + 24, 12n, true)
    view.setBigUint64(b + 32, 12n, true)
    bytes.set([0x44, 0x53, 0x54, 0x43, 0, 0, 0, 0, 0, 0, 0, 0], markerOff) // "DSTC" + 占位
  }
  return { bytes, markerOff, xOff: segs[0]?.off ?? -1 }
}

describe("patchSoTextCrc 构建期 text 段 CRC 补丁", () => {
  test("单可执行段:补丁写入规范 CRC32(CRC-32(\"123456789\")=0xCBF43926),X 段字节不变,输入不被改写", () => {
    const { bytes, markerOff, xOff } = buildSo({ marker: true, xSegs: 1 })
    const before = bytes.slice()
    const res = patchSoTextCrc(bytes)
    expect(res.patched).toBe(true)
    expect(res.segmentSize).toBe(9)
    expect(res.segmentCrc).toBe(0xcbf43926)
    // 标记块 4..7 = CRC32 小端
    const view = new DataView(res.bytes.buffer)
    expect(view.getUint32(markerOff + 4, true)).toBe(0xcbf43926)
    // 被校验段字节原样(补丁只写 .rodata 标记块)
    expect(Array.from(res.bytes.slice(xOff, xOff + 9))).toEqual(Array.from(before.slice(xOff, xOff + 9)))
    // 输入数组未被改写(副本上补丁)
    expect(Array.from(bytes)).toEqual(Array.from(before))
  })

  test("无 DSTC 标记 → 如实不补丁(reason=no-marker)", () => {
    const { bytes } = buildSo({ marker: false, xSegs: 1 })
    const res = patchSoTextCrc(bytes)
    expect(res.patched).toBe(false)
    expect(res.reason).toBe("no-marker")
  })

  test("无可执行段 → 如实不补丁(reason=no-x-seg)", () => {
    const { bytes } = buildSo({ marker: true, xSegs: 0 })
    const res = patchSoTextCrc(bytes)
    expect(res.patched).toBe(false)
    expect(res.reason).toBe("no-x-seg")
  })

  test("多可执行段 → 如实不补丁(reason=multi-x-seg,运行时对应无法核验)", () => {
    const { bytes } = buildSo({ marker: true, xSegs: 2 })
    const res = patchSoTextCrc(bytes)
    expect(res.patched).toBe(false)
    expect(res.reason).toBe("multi-x-seg")
  })

  test("非 ELF → 拒绝(bad-elf)", () => {
    const res = patchSoTextCrc(new Uint8Array(128))
    expect(res.patched).toBe(false)
    expect(res.reason).toBe("bad-elf")
  })
})
