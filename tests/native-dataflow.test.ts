// P3 单测:native 线性数据流(JNI 导出函数 source→sink 共现)
import { describe, test, expect } from "bun:test"
import { scanNativeDataflow } from "../src/core/native-dataflow.ts"

function u16(v: number): number[] { return [v & 0xff, (v >> 8) & 0xff] }
function u32(v: number): number[] { return [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >>> 24) & 0xff] }
function u64(v: number): number[] { return [...u32(v >>> 0), ...u32(Math.floor(v / 0x100000000))] }

// 最小 ELF64 LE:ELF 头 + 3 个 section(.dynsym / .dynstr / .text 伪数据)
// .text 内放一个"函数体"字节区,内嵌 recv/fwrite 字符串(共现 → 命中)
function buildElf64(jniName: string, bodyAscii: string): Uint8Array {
  const enc = new TextEncoder()
  const nameBytes = enc.encode(jniName + "\0")
  const bodyBytes = enc.encode(bodyAscii)

  // 布局:ehdr(64) | shdr 表(3×64) | dynstr | dynsym(2×24) | body
  const ehdrSize = 64
  const shdrSize = 64
  const shnum = 3
  const shoff = ehdrSize
  const dynstrOff = shoff + shdrSize * shnum
  const dynsymOff = dynstrOff + nameBytes.length
  const bodyOff = dynsymOff + 2 * 24

  const ehdr: number[] = [
    0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0,
    ...new Array(8).fill(0), // pad(e_ident 补满 16 字节)
    ...u16(2), ...u16(0xb7), ...u32(1), // ET_DYN, EM_AARCH64, EV_CURRENT(至 offset 24)
    ...u64(0), ...u64(0), // entry@24, phoff@32
    ...u64(shoff), // shoff@0x28=40
    ...u32(0), ...u16(ehdrSize), ...u16(0), ...u16(0), // flags@48, ehsize, phentsize, phnum
    ...u16(shdrSize), ...u16(shnum), ...u16(2), // shentsize@58, shnum@60, shstrndx@62
  ]
  // Elf64_Shdr 标准布局(64B): name(4) type(4) flags(8) addr(8) offset(8) size(8) link(4) info(4) addralign(8) entsize(8)
  // .dynsym: type=11, link=1(.dynstr), entsize=24
  const shDynsym: number[] = [
    ...u32(0), ...u32(11), ...u64(0), ...u64(0), ...u64(dynsymOff), ...u64(2 * 24),
    ...u32(1), ...u32(0), ...u64(8), ...u64(24),
  ]
  // .dynstr: type=3, link=0
  const shDynstr: number[] = [
    ...u32(0), ...u32(3), ...u64(0), ...u64(0), ...u64(dynstrOff), ...u64(nameBytes.length),
    ...u32(0), ...u32(0), ...u64(1), ...u64(0),
  ]
  // .text: type=1(progbits,仅占位,扫描不依赖)
  const shText: number[] = [
    ...u32(0), ...u32(1), ...u64(0x6), ...u64(0), ...u64(bodyOff), ...u64(bodyBytes.length),
    ...u32(0), ...u32(0), ...u64(4), ...u64(0),
  ]

  // dynsym 两个条目:0=null, 1=JNI 函数(name=1, info=0x12 GLOBAL FUNC, value=bodyOff, size=bodyBytes.length)
  const symNull = new Array(24).fill(0)
  const symFn: number[] = [...u32(0), 0x12, 0, ...u16(0), ...u64(bodyOff), ...u64(bodyBytes.length)]

  const bytes = new Uint8Array([
    ...ehdr, ...shDynsym, ...shDynstr, ...shText,
    ...nameBytes,
    ...symNull, ...symFn,
    ...bodyBytes,
  ])
  return bytes
}

describe("scanNativeDataflow", () => {
  test("JNI 导出函数体内 source(recv)与 sink(fwrite)共现 → 命中", () => {
    const so = buildElf64("Java_com_x_Nat_leak", "\u0090recv\u0090fwrite\u0090")
    const hits = scanNativeDataflow(so)
    expect(hits.length).toBe(1)
    expect(hits[0]!.symbol).toBe("Java_com_x_Nat_leak")
    expect(hits[0]!.sources.join()).toContain("recv")
    expect(hits[0]!.sinks.join()).toContain("fwrite")
  })

  test("JNI_OnLoad 也纳入扫描", () => {
    const so = buildElf64("JNI_OnLoad", "recv\u0090connect\u0090system")
    const hits = scanNativeDataflow(so)
    expect(hits.length).toBe(1)
    expect(hits[0]!.symbol).toBe("JNI_OnLoad")
  })

  test("只有 source 无 sink → 不报(口径:两端共现)", () => {
    const so = buildElf64("Java_com_x_Nat_ok", "recv only no sink here")
    expect(scanNativeDataflow(so).length).toBe(0)
  })

  test("无 ELF 头/非 64 位 LE → 如实返回空", () => {
    expect(scanNativeDataflow(new Uint8Array([0, 1, 2, 3]))).toEqual([])
    expect(scanNativeDataflow(new Uint8Array(128))).toEqual([])
  })
})
