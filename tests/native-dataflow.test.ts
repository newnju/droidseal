// P3 单测:native 线性数据流(JNI 导出函数 source→sink 共现)
// P2 扩展:ARM64 解码调用级(JUMP_SLOT 重定位 → PLT stub → bl 目标解析)
import { describe, test, expect } from "bun:test"
import { scanNativeDataflow, associateDynamicEndpoints } from "../src/core/native-dataflow.ts"

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

// ── P2: ARM64 解码调用级 fixture ──────────────────────────────────────────
// 布局: ehdr(64) | shdr(5×64) | .dynstr | .dynsym(5×24) | .rela.plt(3×24) | .text
// .text 内: BTI 前缀 stub(send) + 裸 stub(GetStringUTFChars/memcpy) + 函数体(bl×3 + ret)
// 指令编码内联计算(adrp/ldr/bl),不引外部汇编器。
function w32(...words: number[]): number[] {
  const out: number[] = []
  for (const w of words) out.push(w & 0xff, (w >>> 8) & 0xff, (w >>> 16) & 0xff, (w >>> 24) & 0xff)
  return out
}
const ADRP_X16 = (pc: number, target: number): number => {
  const imm = (target & ~0xfff) - (pc & ~0xfff)
  const imm21 = (imm / 0x1000) & 0x1fffff
  const immlo = imm21 & 0x3
  const immhi = (imm21 >>> 2) & 0x7ffff
  return 0x90000000 | (immlo << 29) | (immhi << 5) | 16
}
const LDR_X17_X16 = (byteOff: number): number => 0xf9400000 | ((byteOff / 8) << 10) | (16 << 5) | 17
const BR_X17 = 0xd61f0000 | (17 << 5)
const BTI_C = 0xd503245f
const BL = (pc: number, target: number): number => 0x94000000 | (((target - pc) / 4) & 0x3ffffff)
const RET = 0xd65f03c0

function buildArm64Elf(): { bytes: Uint8Array; fnAddr: number; fnSize: number } {
  const enc = new TextEncoder()
  // .dynstr: \0Java_com_x_Nat_leak\0send\0memcpy\0GetStringUTFChars\0
  const dstr = enc.encode("\0Java_com_x_Nat_leak\0send\0memcpy\0GetStringUTFChars\0")
  const offName = 1, offSend = 21, offMemcpy = 26, offGusc = 33

  const ehdrSize = 64, shdrSize = 64, shnum = 5
  const dataStart = ehdrSize + shdrSize * shnum // 384
  const dynstrOff = dataStart
  const dynsymOff = dynstrOff + dstr.length + 4 // 留 4B 对齐垫
  const relaOff = dynsymOff + 5 * 24
  const textOff = relaOff + 3 * 24

  // GOT 槽位(任意不重叠 vaddr)
  const GOT_SEND = 0x1000, GOT_MEMCPY = 0x1008, GOT_GUSC = 0x1010
  // .text 内容: BTI+stub(send) | stub(GUSC) | stub(memcpy) | fn(3×bl + ret)
  const stubSend = [BTI_C, ADRP_X16(textOff + 4, GOT_SEND), LDR_X17_X16(0), BR_X17]
  const stubGusc = [ADRP_X16(textOff + 16, GOT_GUSC), LDR_X17_X16(0x10), BR_X17]
  const stubMemcpy = [ADRP_X16(textOff + 28, GOT_MEMCPY), LDR_X17_X16(8), BR_X17]
  const fnAddr = textOff + 40
  const fn = [BL(fnAddr, textOff), BL(fnAddr + 4, textOff + 16), BL(fnAddr + 8, textOff + 28), RET]
  const textWords = [...stubSend, ...stubGusc, ...stubMemcpy, ...fn]
  const fnSize = fn.length * 4

  const shdr = (type: number, flags: number, offset: number, size: number, link: number, entsize: number): number[] =>
    [...u32(0), ...u32(type), ...u64(flags), ...u64(offset === textOff ? offset : offset), ...u64(offset === textOff ? offset : offset), ...u64(size), ...u32(link), ...u32(0), ...u64(4), ...u64(entsize)]
  // 注:addr 字段对 .text 取 offset(vaddr=offset);其余段 addr 随意取同值(恒等映射)
  const shNull = new Array(64).fill(0)
  const shSym = shdr(11, 0, dynsymOff, 5 * 24, 2, 24) // .dynsym → link .dynstr
  const shStr = shdr(3, 0, dynstrOff, dstr.length, 0, 0) // .dynstr
  const shRela = shdr(4, 0, relaOff, 3 * 24, 1, 24) // .rela.plt → link .dynsym
  const shText = shdr(1, 0x6, textOff, textWords.length * 4, 0, 4) // .text SHF_EXECINSTR
  const ehdr: number[] = [
    0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0, ...new Array(8).fill(0),
    ...u16(2), ...u16(0xb7), ...u32(1),
    ...u64(0), ...u64(0), ...u64(ehdrSize),
    ...u32(0), ...u16(ehdrSize), ...u16(0), ...u16(0),
    ...u16(shdrSize), ...u16(shnum), ...u16(0),
  ]
  // .dynsym: null | fn(name=1,GLOBAL FUNC,value=fnAddr,size=fnSize) | send | memcpy | GetStringUTFChars(UNDEF)
  const sym = (nameOff: number, value: number, size: number): number[] => [...u32(nameOff), 0x12, 0, ...u16(0), ...u64(value), ...u64(size)]
  const dynsym = [...sym(0, 0, 0), ...sym(offName, fnAddr, fnSize), ...sym(offSend, 0, 0), ...sym(offMemcpy, 0, 0), ...sym(offGusc, 0, 0)]
  // .rela.plt: JUMP_SLOT(1026) ×3 → GOT 槽位,符号序号 2/3/4
  // r_info 64 位小端:低 32 位 = r_type(1026),高 32 位 = 符号序号
  const rela = (gotAddr: number, symIdx: number): number[] => [...u64(gotAddr), ...u32(1026), ...u32(symIdx), ...u64(0)]
  const relaBytes = [...rela(GOT_SEND, 2), ...rela(GOT_MEMCPY, 3), ...rela(GOT_GUSC, 4)]

  const total = textOff + textWords.length * 4
  const bytes = new Uint8Array(total)
  const put = (off: number, arr: number[]) => bytes.set(arr, off)
  put(0, ehdr); put(ehdrSize, shNull); put(ehdrSize + 64, shSym); put(ehdrSize + 128, shStr); put(ehdrSize + 192, shRela); put(ehdrSize + 256, shText)
  put(dynstrOff, [...dstr])
  put(dynsymOff, dynsym)
  put(relaOff, relaBytes)
  put(textOff, w32(...textWords))
  return { bytes, fnAddr, fnSize }
}

describe("scanNativeDataflow(ARM64 解码调用级)", () => {
  test("bl→PLT stub→JUMP_SLOT 解析:桥参数 accessor + 拷贝传播 + sink → decoded-calls 命中", () => {
    const { bytes } = buildArm64Elf()
    const hits = scanNativeDataflow(bytes)
    expect(hits.length).toBe(1)
    expect(hits[0]!.via).toBe("decoded-calls")
    expect(hits[0]!.symbol).toBe("Java_com_x_Nat_leak")
    expect(hits[0]!.sources.join()).toContain("GetStringUTFChars")
    expect(hits[0]!.propagators.join()).toContain("memcpy")
    expect(hits[0]!.sinks.join()).toContain("send")
  })

  test("BTI 前缀 stub:bl 落在 bti c 处也能解析", () => {
    const { bytes } = buildArm64Elf()
    const hits = scanNativeDataflow(bytes)
    // fixture 里第一条 bl 的目标就是 BTI 前缀 stub(send)——命中即证明 BTI 兼容
    expect(hits[0]!.sinks.join()).toContain("send")
  })

  test("bl 目标非 PLT stub → 解码链不可用,如实降级字符串共现口径", () => {
    // 最小 arm64 ELF 无 RELA → 降级;函数体内无 source/sink 字符串 → 空
    const so = buildElf64("Java_com_x_Nat_plain", "\u0090\u0090\u0090")
    const hits = scanNativeDataflow(so)
    expect(hits.length).toBe(0)
  })

  test("降级口径仍标注 via=string-cooccurrence", () => {
    const so = buildElf64("Java_com_x_Nat_leak", "\u0090recv\u0090fwrite\u0090")
    const hits = scanNativeDataflow(so)
    expect(hits.length).toBe(1)
    expect(hits[0]!.via).toBe("string-cooccurrence")
  })
})

describe("associateDynamicEndpoints", () => {
  test("JNI_OnLoad 解码链 × 动态注册端点 → 关联成立", () => {
    expect(associateDynamicEndpoints([{ symbol: "JNI_OnLoad", sources: [], sinks: [], propagators: [], via: "decoded-calls" }], 2)).toBe(true)
  })
  test("非 JNI_OnLoad / 非解码口径 / 无端点 → 不关联", () => {
    expect(associateDynamicEndpoints([{ symbol: "Java_a_b_c", sources: [], sinks: [], propagators: [], via: "decoded-calls" }], 2)).toBe(false)
    expect(associateDynamicEndpoints([{ symbol: "JNI_OnLoad", sources: [], sinks: [], propagators: [], via: "string-cooccurrence" }], 2)).toBe(false)
    expect(associateDynamicEndpoints([{ symbol: "JNI_OnLoad", sources: [], sinks: [], propagators: [], via: "decoded-calls" }], 0)).toBe(false)
  })
})
