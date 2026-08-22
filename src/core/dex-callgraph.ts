// DEX 调用图提取（Quark-Engine 差距①——dex-callgraph.ts）。
// 解析 DEX 的 invoke-kind 指令（操作码 0x6e-0x7a）→ 提取 method_index → method_ids →
// 被调 类.方法（调用方为任意——调用图的有界近似）。有界（限制扫描量/提取数）、失败关闭。
// 说明：code_item 级精确调用图需完整解析（class_defs→class_data→code_off 链路）；
// 本模块用 invoke 指令的字节级扫描近似（足够行为规则的调用方无关匹配）。
import type { Finding } from "./types.ts"

interface DexHeader {
  stringIdsSize: number
  stringIdsOff: number
  typeIdsSize: number
  typeIdsOff: number
  methodIdsSize: number
  methodIdsOff: number
}

function parseHeader(bytes: Uint8Array): DexHeader {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => view.getUint32(o, true)
  return {
    stringIdsSize: u32(0x38), stringIdsOff: u32(0x3c),
    typeIdsSize: u32(0x40), typeIdsOff: u32(0x44),
    methodIdsSize: u32(0x58), methodIdsOff: u32(0x5c),
  }
}

function readStringAt(bytes: Uint8Array, off: number): string {
  let p = off
  let uleb = 0
  let shift = 0
  for (let i = 0; i < 5; i += 1) {
    const b = bytes[p++]!
    uleb |= (b & 0x7f) << shift
    if ((b & 0x80) === 0) break
    shift += 7
  }
  let end = p
  while (bytes[end] !== 0) end += 1
  return new TextDecoder("utf-8").decode(bytes.subarray(p, end))
}

// 被调方法集合（"类.方法" 形式——类描述符 L...; 转点分）。有界（最多 2000 个调用），失败关闭。
export function extractCalledMethods(bytes: Uint8Array): Set<string> {
  const header = parseHeader(bytes)
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const strings: string[] = []
  for (let i = 0; i < header.stringIdsSize && i < 4096; i += 1) {
    const off = view.getUint32(header.stringIdsOff + i * 4, true)
    strings.push(readStringAt(bytes, off))
  }
  const methodClasses: string[] = []
  const methodNames: string[] = []
  for (let i = 0; i < header.methodIdsSize && i < 4096; i += 1) {
    const base = header.methodIdsOff + i * 8
    const classIdx = view.getUint16(base, true)
    const nameIdx = view.getUint32(base + 4, true)
    const typeOff = header.typeIdsOff + classIdx * 4
    const descriptorIdx = view.getUint32(typeOff, true)
    const descriptor = strings[descriptorIdx] ?? ""
    const className = descriptor.startsWith("L") && descriptor.endsWith(";")
      ? descriptor.slice(1, -1).replaceAll("/", ".")
      : descriptor
    methodClasses.push(className)
    methodNames.push(strings[nameIdx] ?? "")
  }

  const called = new Set<string>()
  const MAX_CALLS = 2000
  // invoke-kind 操作码:0x6e-0x72(virtual/static/direct/interface)+ 0x74-0x7a(range 变体)
  const scanStart = header.methodIdsOff
  const scanEnd = bytes.byteLength
  for (let i = scanStart; i + 3 < scanEnd && called.size < MAX_CALLS; i += 1) {
    const opcode = bytes[i]!
    if (opcode < 0x6e || opcode > 0x7a) continue
    // format 35c/3rc:opcode+寄存器字节,然后 2 字节 method_index(小端)
    const methodIndex = bytes[i + 1]! | (bytes[i + 2]! << 8)
    if (methodIndex >= header.methodIdsSize || methodIndex >= methodClasses.length) continue
    called.add(`${methodClasses[methodIndex]}.${methodNames[methodIndex]}`)
  }
  return called
}

// 调用图相关 finding 占位(行为规则引擎使用——此处仅导出提取能力)。
export function buildCallgraphFindings(_called: Set<string>): Finding[] {
  return []
}
