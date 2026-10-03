// P2: native 半语义数据流(JNI 桥参数追踪,ARM64 解码调用级)。
// 相比 P3 的线性启发式(字符串共现,confidence: low),本版升级:
//   1. 解析 .rela.plt 的 JUMP_SLOT 重定位 → GOT 槽位 → 导入符号名;
//   2. 解析可执行段内 16B 对齐的 PLT stub(adrp x16 + ldr x17 + br x17)→ stub 地址映射导入名;
//   3. 在 JNI 导出函数体内解码 bl 指令(0x94000000|imm26),目标落到 PLT stub → 真实调用到的导入名。
// 语义:source = JNI 桥参数 accessor(GetStringUTFChars/Get*Elements 等,参数进入点)
//       propagator = 拷贝族(memcpy/memmove/strcpy…,参数在函数内传播的中转)
//       sink = 外发/执行(send/write/system/popen…)。
// 命中口径:函数内同时解码到 source 与 sink(直连),或 source + propagator(经拷贝传播)——
// 仍不重建调用顺序与跨函数传播,故报 medium 而非确认;解码不可用(非 arm64/ stripped)
// 时如实降级回字符串共现口径(via: string-cooccurrence,confidence: low)。

export interface NativeDataflowHit {
  symbol: string
  sources: string[]
  sinks: string[]
  propagators: string[]
  /** decoded-calls = bl/PLT 解码级;string-cooccurrence = 旧线性启发式降级口径 */
  via: "decoded-calls" | "string-cooccurrence"
}

// JNI 桥参数 accessor:参数从 Java 层进入 native 的唯一合法入口(半语义 source)
const JNI_PARAM_ACCESSORS: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "GetStringUTFChars", label: "GetStringUTFChars(jstring→char*,桥参数)" },
  { marker: "GetStringCritical", label: "GetStringCritical(jstring 直取,桥参数)" },
  { marker: "GetByteArrayElements", label: "GetByteArrayElements(jbyteArray→指针,桥参数)" },
  { marker: "GetPrimitiveArrayCritical", label: "GetPrimitiveArrayCritical(数组直取,桥参数)" },
  { marker: "GetByteArrayRegion", label: "GetByteArrayRegion(数组拷出,桥参数)" },
  { marker: "GetDirectBufferAddress", label: "GetDirectBufferAddress(直接缓冲地址,桥参数)" },
  { marker: "GetObjectArrayElement", label: "GetObjectArrayElement(对象元素,桥参数)" },
]

// 非 JNI 入渗面 source(网络/文件读,保留 P3 口径)
const READ_SOURCES: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "recv", label: "recv(网络读)" },
  { marker: "fread", label: "fread(文件读)" },
  { marker: "read", label: "read(fd 读)" },
]

// 拷贝传播族:桥参数在函数体内流转的中转(半语义 propagator)
const PROPAGATORS: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "memcpy", label: "memcpy(内存拷贝)" },
  { marker: "memmove", label: "memmove(内存拷贝)" },
  { marker: "strcpy", label: "strcpy(字符串拷贝)" },
  { marker: "strncpy", label: "strncpy(字符串拷贝)" },
  { marker: "strcat", label: "strcat(字符串拼接)" },
]

// sink:外发/执行/危险写
const NATIVE_SINKS: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "send", label: "send(网络发)" },
  { marker: "sendto", label: "sendto(网络发)" },
  { marker: "write", label: "write(fd 写)" },
  { marker: "connect", label: "connect(建连)" },
  { marker: "system", label: "system(命令执行)" },
  { marker: "popen", label: "popen(命令执行)" },
  { marker: "execve", label: "execve(进程执行)" },
  { marker: "execl", label: "execl(进程执行)" },
  { marker: "fwrite", label: "fwrite(文件写)" },
]

// 旧口径列表(via=string-cooccurrence 时沿用,与 P3 完全一致)
const LEGACY_SOURCES = [...READ_SOURCES, { marker: "getattr", label: "getattr(属性读)" }, JNI_PARAM_ACCESSORS[0]!]

interface ElfSym {
  name: string
  value: number
  size: number
}

interface ElfSection {
  type: number
  flags: number
  addr: number
  offset: number
  size: number
  link: number
  entsize: number
}

const SHT_SYMTAB = 2
const SHT_RELA = 4
const SHT_DYNSYM = 11
const R_AARCH64_JUMP_SLOT = 1026

const EM_AARCH64 = 0xb7
const EM_X86_64 = 0x3e

function readCString(bytes: Uint8Array, off: number, limit: number): string {
  let name = ""
  for (let c = off; c < limit && bytes[c] !== 0; c += 1) name += String.fromCharCode(bytes[c]!)
  return name
}

function parseSections(bytes: Uint8Array): ElfSection[] | null {
  if (bytes.length < 64) return null
  if (bytes[0] !== 0x7f || bytes[1] !== 0x45 || bytes[2] !== 0x4c || bytes[3] !== 0x46) return null
  if (bytes[4] !== 2 || bytes[5] !== 1) return null // 仅 ELF64 LE
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const shoff = Number(view.getBigUint64(0x28, true))
  const shentsize = view.getUint16(0x3a, true)
  const shnum = view.getUint16(0x3c, true)
  if (shoff === 0 || shentsize < 64 || shoff + shnum * shentsize > bytes.length) return null
  const out: ElfSection[] = []
  for (let i = 0; i < shnum; i += 1) {
    const sh = shoff + i * shentsize
    out.push({
      type: view.getUint32(sh + 4, true),
      flags: Number(view.getBigUint64(sh + 8, true)),
      addr: Number(view.getBigUint64(sh + 16, true)),
      offset: Number(view.getBigUint64(sh + 24, true)),
      size: Number(view.getBigUint64(sh + 32, true)),
      link: view.getUint32(sh + 40, true),
      entsize: Number(view.getBigUint64(sh + 56, true)),
    })
  }
  return out
}

/** vaddr → 文件偏移(按 section addr/offset 映射;NOBITS/.bss 无文件映像,如实跳过) */
function vaddrToOffset(sections: ElfSection[], vaddr: number): number | null {
  for (const sec of sections) {
    if (sec.type === 8 || sec.size === 0) continue // SHT_NOBITS
    if (vaddr >= sec.addr && vaddr < sec.addr + sec.size) return sec.offset + (vaddr - sec.addr)
  }
  return null
}

/**
 * JUMP_SLOT 重定位 → GOT 槽位地址 → 导入符号名。
 * 只认 RELA(type 4) + R_AARCH64_JUMP_SLOT(1026);其余架构/重定位类型如实忽略。
 */
function parseJumpSlotImports(bytes: Uint8Array, sections: ElfSection[]): Map<number, string> {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const map = new Map<number, string>()
  for (const sec of sections) {
    if (sec.type !== SHT_RELA) continue
    const symtab = sections[sec.link]
    if (!symtab) continue
    const strtab = sections[symtab.link]
    if (!strtab) continue
    const entsize = sec.entsize === 0 ? 24 : sec.entsize
    const count = Math.min(16384, Math.floor(sec.size / entsize))
    for (let i = 0; i < count; i += 1) {
      const base = sec.offset + i * entsize
      if (base + 24 > bytes.length) break
      const rOffset = Number(view.getBigUint64(base, true))
      const rInfo = view.getBigUint64(base + 8, true)
      const symIdx = Number(rInfo >> 32n)
      const rType = Number(rInfo & 0xffffffffn)
      if (rType !== R_AARCH64_JUMP_SLOT) continue
      const symBase = symtab.offset + symIdx * (symtab.entsize === 0 ? 24 : symtab.entsize)
      if (symBase + 24 > bytes.length) continue
      const nameOff = view.getUint32(symBase, true)
      map.set(rOffset, readCString(bytes, strtab.offset + nameOff, strtab.offset + strtab.size))
    }
  }
  return map
}

/**
 * PLT stub 解码:可执行段内 4B 步进,识别 (adrp x16; ldr x17,[x16,#imm]; br x17) 三元组。
 * adrp 页基址 + ldr 偏移 = GOT 槽位地址,查 JUMP_SLOT 映射得导入名 → stub vaddr。
 * 兼容 BTI 前缀 stub(bti c; adrp; ldr; br)——bl 落在 bti 处,一并注册前缀地址。
 * 严格匹配(Rd=16/Rt=17/br 而非 blr),函数体内的普通 adrp+ldr/blr 不会被误判。
 */
const PLT_BTI_C = 0xd503245f // bti c

function decodePltStubs(bytes: Uint8Array, sections: ElfSection[], gotMap: Map<number, string>): Map<number, string> {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const stubMap = new Map<number, string>()
  const execSections = sections.filter((s) => s.type === 1 && (s.flags & 0x4) !== 0) // SHF_EXECINSTR
  for (const sec of execSections) {
    for (let off = 0; off + 12 <= sec.size; off += 4) {
      const pc = sec.addr + off
      const fileOff = sec.offset + off
      const w0 = view.getUint32(fileOff, true)
      const w1 = view.getUint32(fileOff + 4, true)
      const w2 = view.getUint32(fileOff + 8, true)
      // adrp x16: op=1,10000,immlo,immhi,Rd
      // 位运算结果是有符号 int32,期望值须同为 |0 归一,否则 bit31=1 的指令(负立即数 adrp 等)永远不匹配
      if ((w0 & 0x9f000000) !== (0x90000000 | 0)) continue
      if ((w0 & 0x1f) !== 16) continue
      const immlo = (w0 >>> 29) & 0x3
      const immhi = (w0 >>> 5) & 0x7ffff
      const imm21 = (immhi << 2) | immlo
      const signed = imm21 & 0x100000 ? imm21 - 0x200000 : imm21
      const page = (pc & ~0xfff) + signed * 0x1000
      // ldr x17,[x16,#imm12](64bit 无符号偏移变体 F9400000,imm12 按 8 缩放)
      if ((w1 & 0xffc00000) !== (0xf9400000 | 0)) continue
      if (((w1 >>> 5) & 0x1f) !== 16 || (w1 & 0x1f) !== 17) continue
      const ldrOff = ((w1 >>> 10) & 0xfff) * 8
      // br x17(D61F0000|Rn<<5,非 link 位)
      if ((w2 & 0xfffffc1f) !== (0xd61f0000 | 0)) continue
      if (((w2 >>> 5) & 0x1f) !== 17) continue
      const gotAddr = page + ldrOff
      const name = gotMap.get(gotAddr)
      if (name) {
        stubMap.set(pc, name)
        // BTI 前缀:bti c 紧邻 adrp 之前 → stub 真实入口在 bti 处
        if (off >= 4 && view.getUint32(fileOff - 4, true) === PLT_BTI_C) stubMap.set(pc - 4, name)
      }
    }
  }
  return stubMap
}

/** 函数体内 bl(0x94000000|imm26) 目标 vaddr 清单 */
function decodeBlTargets(bytes: Uint8Array, sections: ElfSection[], fnVaddr: number, fnSize: number, fileOff: number): number[] {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const targets: number[] = []
  for (let o = 0; o + 4 <= fnSize; o += 4) {
    const w = view.getUint32(fileOff + o, true)
    // 同 decodePltStubs:期望值 |0 归一,避免有符号 int32 比较失配
    if ((w & 0xfc000000) !== (0x94000000 | 0)) continue
    let imm26 = w & 0x3ffffff
    if (imm26 & 0x2000000) imm26 -= 0x4000000
    targets.push(fnVaddr + o + imm26 * 4)
  }
  return targets
}

// 解析 ELF64 .dynsym/.symtab 中 JNI 相关函数符号(JNI_OnLoad、Java_ 前缀导出)。
// 仅 64 位小端(Android 主流);32 位或不支持结构时如实返回空。
function parseJniSymbols(bytes: Uint8Array): ElfSym[] {
  if (bytes.length < 64) return []
  if (bytes[0] !== 0x7f || bytes[1] !== 0x45 || bytes[2] !== 0x4c || bytes[3] !== 0x46) return []
  if (bytes[4] !== 2 || bytes[5] !== 1) return [] // 仅 ELF64 LE
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const shoff = Number(view.getBigUint64(0x28, true))
  const shentsize = view.getUint16(0x3a, true)
  const shnum = view.getUint16(0x3c, true)
  if (shoff === 0 || shentsize < 64) return []
  // 找 .dynsym(类型 11)与关联 .dynstr;备选 .symtab(类型 2)/.strtab(类型 3)
  const out: ElfSym[] = []
  for (const symType of [SHT_DYNSYM, SHT_SYMTAB]) {
    for (let i = 0; i < shnum; i += 1) {
      const sh = shoff + i * shentsize
      if (sh + 64 > bytes.length) break
      if (view.getUint32(sh + 4, true) !== symType) continue
      const symOff = Number(view.getBigUint64(sh + 24, true))
      const symSize = Number(view.getBigUint64(sh + 32, true))
      const link = view.getUint32(sh + 40, true) // 关联 strtab section index
      if (link >= shnum) continue
      const strSh = shoff + link * shentsize
      const strOff = Number(view.getBigUint64(strSh + 24, true))
      const strSize = Number(view.getBigUint64(strSh + 32, true))
      const entsizeRaw = view.getBigUint64(sh + 56, true)
      const entsize = entsizeRaw === 0n ? 24 : Number(entsizeRaw)
      const count = Math.min(8192, Math.floor(symSize / entsize))
      for (let s = 0; s < count; s += 1) {
        const base = symOff + s * entsize
        if (base + 24 > bytes.length) break
        const nameOff = view.getUint32(base, true)
        const info = bytes[base + 4]!
        const value = Number(view.getBigUint64(base + 8, true))
        const size = Number(view.getBigUint64(base + 16, true))
        if ((info & 0xf) !== 2) continue // 仅 FUNC
        const name = readCString(bytes, strOff + nameOff, strSize + strOff)
        if (name === "JNI_OnLoad" || name.startsWith("Java_")) {
          out.push({ name, value, size })
        }
      }
    }
    if (out.length > 0) break // dynsym 有 JNI 符号即用之
  }
  return out
}

// 函数体字节范围内查找 ASCII marker(与 elf-scan bytesContainAscii 同口径)。
function rangeContainsAscii(bytes: Uint8Array, start: number, size: number, ascii: string): boolean {
  const target = new TextEncoder().encode(ascii)
  const end = Math.min(bytes.length, start + size)
  outer: for (let i = start; i + target.length <= end; i += 1) {
    for (let j = 0; j < target.length; j += 1) {
      if (bytes[i + j] !== target[j]) continue outer
    }
    return true
  }
  return false
}

/** 旧线性启发式口径(降级路径):函数体范围 source/sink 字符串共现 */
function legacyScan(bytes: Uint8Array, symbols: ElfSym[]): NativeDataflowHit[] {
  const hits: NativeDataflowHit[] = []
  for (const sym of symbols) {
    if (sym.size === 0) continue // 无尺寸符号无法圈范围,如实跳过
    const start = sym.value // st_value 即文件偏移的近似(对 shared object,ET_DYN 基址 0)
    if (start + sym.size > bytes.length) continue
    const sources = LEGACY_SOURCES.filter((s) => rangeContainsAscii(bytes, start, sym.size, s.marker)).map((s) => s.label)
    const sinks = NATIVE_SINKS.filter((s) => rangeContainsAscii(bytes, start, sym.size, s.marker)).map((s) => s.label)
    if (sources.length > 0 && sinks.length > 0) {
      hits.push({ symbol: sym.name, sources, sinks, propagators: [], via: "string-cooccurrence" })
    }
  }
  return hits
}

/**
 * JNI 导出函数 source→sink 半语义扫描(ARM64 解码调用级,降级线性启发式)。
 * @param bytes SO 原始字节
 * @returns 命中清单(source 与 sink 共现的导出函数);无符号表/无命中返回空数组。
 */
export function scanNativeDataflow(bytes: Uint8Array): NativeDataflowHit[] {
  const symbols = parseJniSymbols(bytes)
  if (symbols.length === 0) return []
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const machine = view.getUint16(0x12, true)

  if (machine === EM_AARCH64) {
    const sections = parseSections(bytes)
    if (sections) {
      const imports = parseJumpSlotImports(bytes, sections)
      if (imports.size > 0) {
        const pltMap = decodePltStubs(bytes, sections, imports)
        if (pltMap.size > 0) {
          const hits: NativeDataflowHit[] = []
          for (const sym of symbols) {
            if (sym.size === 0) continue
            const fnOff = vaddrToOffset(sections, sym.value)
            if (fnOff === null || fnOff + sym.size > bytes.length) continue
            const callNames = new Set<string>()
            for (const t of decodeBlTargets(bytes, sections, sym.value, sym.size, fnOff)) {
              const name = pltMap.get(t)
              if (name) callNames.add(name)
            }
            if (callNames.size === 0) continue
            const sources = [...JNI_PARAM_ACCESSORS, ...READ_SOURCES]
              .filter((s) => callNames.has(s.marker)).map((s) => s.label)
            const propagators = PROPAGATORS.filter((s) => callNames.has(s.marker)).map((s) => s.label)
            const sinks = NATIVE_SINKS.filter((s) => callNames.has(s.marker)).map((s) => s.label)
            // 半语义口径:参数进入点 + 到达 sink(直连或经拷贝传播)才成链
            if (sources.length > 0 && sinks.length > 0) {
              hits.push({ symbol: sym.name, sources, sinks, propagators, via: "decoded-calls" })
            }
          }
          if (hits.length > 0) return hits.slice(0, 16) // 封顶防噪
        }
      }
    }
    // 解码链路任一环不可用 → 如实降级(不猜)
    return legacyScan(bytes, symbols).slice(0, 16)
  }

  if (machine === EM_X86_64) return legacyScan(bytes, symbols).slice(0, 16)
  return legacyScan(bytes, symbols).slice(0, 16)
}

/**
 * 动态注册关联(JNI_OnLoad 域内链 × RegisterNatives 端点):
 * 解码级命中落在 JNI_OnLoad 时,该函数同时承担注册职责——同 SO 的动态注册端点
 * 与此链关联提示(注册实现函数无 fnPtr 可静态定位,不给逐端点映射,如实)。
 */
export function associateDynamicEndpoints(
  hits: NativeDataflowHit[],
  dynamicEndpointCount: number,
): boolean {
  return dynamicEndpointCount > 0 && hits.some((h) => h.via === "decoded-calls" && h.symbol === "JNI_OnLoad")
}
