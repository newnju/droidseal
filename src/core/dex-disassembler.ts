// 内置反汇编器（Androguard 差距⑥——dex-disassembler.ts）。
// 基于指令迭代器输出 smali-like 方法级反汇编文本——替代外部 jadx 的内置形态。
// 失败关闭：方法无指令/解析异常跳过。
import { extractMethodCodes, type MethodCode } from "./dex-instructions.ts"

// 单方法反汇编（smali-like 文本）。
export function disassembleMethod(method: MethodCode): string {
  const lines = method.instructions.map(
    (instr) => `  ${instr.mnemonic}${instr.operands ? " " + instr.operands : ""}`,
  )
  return `.method ${method.className}.${method.methodName}\n${lines.join("\n")}\n.end method`
}

export interface DisassembledMethod {
  method: string
  code: string
}

// 批量反汇编（有界——最多 limit 个方法——失败关闭）。
export function disassembleAll(bytes: Uint8Array, limit = 20): DisassembledMethod[] {
  const methods = extractMethodCodes(bytes)
  return methods
    .filter((m) => m.instructions.length > 0)
    .slice(0, limit)
    .map((m) => ({ method: `${m.className}.${m.methodName}`, code: disassembleMethod(m) }))
}

// 指定方法名的反汇编（供报告——行为命中的被调方法等）。
export function disassembleNamed(bytes: Uint8Array, className: string, methodName: string): string | undefined {
  const methods = extractMethodCodes(bytes)
  const method = methods.find((m) => m.className === className && m.methodName === methodName && m.instructions.length > 0)
  return method ? disassembleMethod(method) : undefined
}
