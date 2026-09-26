// P3: native 线性数据流(JNI 导出函数 source→sink 线性扫描)。
// 边界如实声明:这是**线性启发式**,不是指针分析——在 JNI 导出函数的函数体
// 字节范围内做 source 类 API 调用 marker 与 sink 类 marker 的共现检测。
// 原理:导出函数(JNI_OnLoad / Java_包名_类名_方法名)的符号表带 st_value/st_size,
// 可圈出函数体机器码范围;函数调用的导入符号名(如 recv/send/socket/fopen)
// 以字符串形式落在 .dynstr,函数体内对 PLT 槽的调用无法静态解析到符号,
// 因此取"符号表已见该导入 + 函数体范围"的保守共现口径,报 suspect 而非确认。
// 如实降级:无符号表(stripped 且无 dynsym 导出)时不报,不猜。

export interface NativeDataflowHit {
  symbol: string
  sources: string[]
  sinks: string[]
}

// source 类:从网络/文件/设备读入(动态注册 native 常见的入渗面)
const NATIVE_SOURCES: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "recv", label: "recv(网络读)" },
  { marker: "fread", label: "fread(文件读)" },
  { marker: "read", label: "read(fd 读)" },
  { marker: "getattr", label: "getattr(属性读)" },
  { marker: "GetStringUTFChars", label: "GetStringUTFChars(JNI 字符串入参)" },
]

// sink 类:外发/执行/内存危险写
const NATIVE_SINKS: ReadonlyArray<{ marker: string; label: string }> = [
  { marker: "send", label: "send(网络发)" },
  { marker: "connect", label: "connect(建连)" },
  { marker: "system", label: "system(命令执行)" },
  { marker: "exec", label: "exec(进程执行)" },
  { marker: "fwrite", label: "fwrite(文件写)" },
  { marker: "memcpy", label: "memcpy(内存写)" },
]

interface ElfSym {
  name: string
  value: number
  size: number
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
  for (const symType of [11, 2]) {
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
        // 读符号名(strOff 基址 + nameOff 偏移)
        let name = ""
        for (let c = strOff + nameOff; c < strSize + strOff && bytes[c] !== 0; c += 1) name += String.fromCharCode(bytes[c]!)
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

/**
 * JNI 导出函数 source→sink 线性扫描。
 * @param bytes SO 原始字节
 * @returns 命中清单(source 与 sink 共现的导出函数);无符号表/无命中返回空数组。
 */
export function scanNativeDataflow(bytes: Uint8Array): NativeDataflowHit[] {
  const symbols = parseJniSymbols(bytes)
  const hits: NativeDataflowHit[] = []
  for (const sym of symbols) {
    if (sym.size === 0) continue // 无尺寸符号无法圈范围,如实跳过
    const start = sym.value // st_value 即文件偏移的近似(对 shared object,ET_DYN 基址 0)
    if (start + sym.size > bytes.length) continue
    const sources = NATIVE_SOURCES.filter((s) => rangeContainsAscii(bytes, start, sym.size, s.marker)).map((s) => s.label)
    const sinks = NATIVE_SINKS.filter((s) => rangeContainsAscii(bytes, start, sym.size, s.marker)).map((s) => s.label)
    if (sources.length > 0 && sinks.length > 0) {
      hits.push({ symbol: sym.name, sources, sinks })
    }
  }
  return hits.slice(0, 16) // 封顶防噪
}
