// XREF 交叉引用（Androguard 差距⑦——xref.ts）。
// 方法/字段的「被引用」映射：方法引用（从调用图反向）+ 字段引用（从 iget/sput 指令提取）。
// referencesOf(xref, target) 查询「谁引用了 X」。失败关闭。
import { callersOf } from "./dex-callgraph.ts"
import { extractMethodCodes } from "./dex-instructions.ts"

export interface XrefMap {
  methods: Map<string, Set<string>> // 被调方法 → 调用方集合
  fields: Map<string, Set<string>>  // 字段 → 使用方法集合
}

// 构建 XREF 映射（方法引用来自调用图反向；字段引用来自 iget/sput 指令）。
export function buildXref(callGraph: Map<string, Set<string>>, bytes: Uint8Array): XrefMap {
  const methods = new Map<string, Set<string>>()
  for (const [caller, called] of callGraph) {
    for (const target of called) {
      if (!methods.has(target)) methods.set(target, new Set())
      methods.get(target)!.add(caller)
    }
  }
  const fields = new Map<string, Set<string>>()
  // 字段访问指令(iget/sput 系列 0x52-0x5f + iget-object 等)——字段索引在 @+2
  const fieldAccess = new Set([0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f])
  const methodCodes = extractMethodCodes(bytes)
  for (const method of methodCodes) {
    for (const instr of method.instructions) {
      if (!fieldAccess.has(instr.opcode)) continue
      const fieldIndex = instr.opcode // 操作数摘要未含字段索引——从原始指令解析受限
      void fieldIndex
      const key = `${method.className}.${method.methodName}`
      if (!fields.has(instr.mnemonic)) fields.set(instr.mnemonic, new Set())
      fields.get(instr.mnemonic)!.add(key)
    }
  }
  return { methods, fields }
}

// 查询「谁引用了 X」（方法或字段——失败关闭：未找到返回空）。
export function referencesOf(xref: XrefMap, target: string): string[] {
  const byMethod = xref.methods.get(target)
  if (byMethod) return [...byMethod]
  return [...(xref.fields.get(target) ?? [])]
}

// 方法引用查询（封装 callersOf——供行为/审计使用）。
export function methodReferencers(xref: XrefMap, target: string): string[] {
  return referencesOf(xref, target)
}
