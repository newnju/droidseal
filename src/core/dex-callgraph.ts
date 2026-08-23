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

// -- 调用链关联(剩余①):调用方 → 被调 映射 ----------------------------------
// 解析 class_defs → class_data(方法表的 code_off)→ code_item 的 insns 指令区,
// 提取每个方法内的 invoke 指令 → 被调方法,构建 调用方方法 → 被调方法 的映射。
// 有界(限制方法数/调用数),失败关闭(解析异常跳过)。
interface DexHeaderFull extends DexHeader {
  classDefsSize: number
  classDefsOff: number
}

function readUleb128(bytes: Uint8Array, start: number): { value: number; next: number } {
  let p = start
  let result = 0
  let shift = 0
  for (let i = 0; i < 5; i += 1) {
    const b = bytes[p++]!
    result |= (b & 0x7f) << shift
    if ((b & 0x80) === 0) break
    shift += 7
  }
  return { value: result >>> 0, next: p }
}

export function extractCallGraph(bytes: Uint8Array): Map<string, Set<string>> {
  const header = parseHeader(bytes) as DexHeaderFull
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => view.getUint32(o, true)
  header.classDefsSize = u32(0x60)
  header.classDefsOff = u32(0x64)

  const strings: string[] = []
  for (let i = 0; i < header.stringIdsSize && i < 4096; i += 1) {
    const off = u32(header.stringIdsOff + i * 4)
    strings.push(readStringAt(bytes, off))
  }
  const methodClasses: string[] = []
  const methodNames: string[] = []
  for (let i = 0; i < header.methodIdsSize && i < 4096; i += 1) {
    const base = header.methodIdsOff + i * 8
    const classIdx = view.getUint16(base, true)
    const nameIdx = u32(base + 4)
    const descriptorIdx = u32(header.typeIdsOff + classIdx * 4)
    const descriptor = strings[descriptorIdx] ?? ""
    const className = descriptor.startsWith("L") && descriptor.endsWith(";")
      ? descriptor.slice(1, -1).replaceAll("/", ".")
      : descriptor
    methodClasses.push(className)
    methodNames.push(strings[nameIdx] ?? "")
  }
  const methodId = (idx: number): string => `${methodClasses[idx] ?? "?"}.${methodNames[idx] ?? "?"}`

  const graph = new Map<string, Set<string>>()
  const MAX_METHODS = 1500
  let processed = 0
  for (let c = 0; c < header.classDefsSize && processed < MAX_METHODS; c += 1) {
    const classDataOff = u32(header.classDefsOff + c * 32 + 24)
    if (classDataOff === 0) continue
    let p = classDataOff
    const counts: number[] = []
    for (let i = 0; i < 4; i += 1) {
      const read = readUleb128(bytes, p)
      counts.push(read.value)
      p = read.next
    }
    let methodIdx = 0
    for (const methodCount of [counts[2]!, counts[3]!]) {
      for (let m = 0; m < methodCount && processed < MAX_METHODS; m += 1) {
        const diff = readUleb128(bytes, p)
        methodIdx += diff.value
        p = diff.next
        const access = readUleb128(bytes, p)
        p = access.next
        const code = readUleb128(bytes, p)
        p = code.next
        if (code.value === 0) continue
        // code_item:registers(2)/ins(2)/outs(2)/tries(2)/debug(4)/insns_size(4) 后为指令
        const insnsSize = view.getUint32(code.value + 12, true)
        const insnsStart = code.value + 16
        const caller = methodId(methodIdx)
        const called = new Set<string>()
        for (let i = 0; i < insnsSize * 2 - 2 && called.size < 50; i += 1) {
          const opcode = bytes[insnsStart + i]!
          if (opcode >= 0x6e && opcode <= 0x7a) {
            const methodIndex = bytes[insnsStart + i + 1]! | (bytes[insnsStart + i + 2]! << 8)
            if (methodIndex < header.methodIdsSize) called.add(methodId(methodIndex))
          }
        }
        if (called.size > 0) graph.set(caller, called)
        processed += 1
      }
    }
  }
  return graph
}

// 接口分派近似(JAADAS 差距④——调用图完整性):从 class_defs 的 interfaces_off 提取
// 类→接口映射;接口方法被调用时,把实现类的同名方法也加入调用图(失败关闭——解析异常跳过)。
export function expandInterfaceDispatch(graph: Map<string, Set<string>>, bytes: Uint8Array): Map<string, Set<string>> {
  const header = parseHeader(bytes) as DexHeaderFull
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => view.getUint32(o, true)
  header.classDefsSize = u32(0x60)
  header.classDefsOff = u32(0x64)
  const strings: string[] = []
  for (let i = 0; i < header.stringIdsSize && i < 4096; i += 1) {
    const off = u32(header.stringIdsOff + i * 4)
    strings.push(readStringAt(bytes, off))
  }
  // 类描述符 → 实现的接口描述符集合
  const implementsMap = new Map<string, Set<string>>()
  for (let c = 0; c < header.classDefsSize && c < 1500; c += 1) {
    const classIdx = view.getUint32(header.classDefsOff + c * 32, true)
    const interfacesOff = u32(header.classDefsOff + c * 32 + 12)
    const classDescriptor = strings[u32(header.typeIdsOff + classIdx * 4)] ?? ""
    if (interfacesOff === 0) continue
    const interfaceCount = view.getUint32(interfacesOff, true)
    for (let i = 0; i < interfaceCount && i < 20; i += 1) {
      const ifaceIdx = view.getUint16(interfacesOff + 4 + i * 2, true)
      const ifaceDescriptor = strings[u32(header.typeIdsOff + ifaceIdx * 4)] ?? ""
      if (ifaceDescriptor.startsWith("L") && ifaceDescriptor.endsWith(";")) {
        const cls = classDescriptor.startsWith("L") ? classDescriptor.slice(1, -1).replaceAll("/", ".") : classDescriptor
        const iface = ifaceDescriptor.slice(1, -1).replaceAll("/", ".")
        if (!implementsMap.has(cls)) implementsMap.set(cls, new Set())
        implementsMap.get(cls)!.add(iface)
      }
    }
  }
  // 接口方法被调用 → 把实现类的同名方法加入调用图
  const expanded = new Map<string, Set<string>>()
  for (const [caller, called] of graph) {
    const set = new Set(called)
    for (const method of called) {
      const dot = method.lastIndexOf(".")
      if (dot <= 0) continue
      const iface = method.slice(0, dot)
      const methodName = method.slice(dot + 1)
      for (const [cls, interfaces] of implementsMap) {
        if (interfaces.has(iface)) set.add(`${cls}.${methodName}`)
      }
    }
    expanded.set(caller, set)
  }
  return expanded
}

// 命中行为的调用方证据(剩余①):从调用图反向找调用被调方法的方法——返回最多 2 个调用方。
export function callersOf(graph: Map<string, Set<string>>, calledMethod: string): string[] {
  const callers: string[] = []
  for (const [caller, called] of graph) {
    if (called.has(calledMethod)) {
      callers.push(caller)
      if (callers.length >= 2) break
    }
  }
  return callers
}
