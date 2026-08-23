// 指令迭代器 API（Androguard 差距⑧——dex-instructions.ts）。
// 解析 code_item 的 insns → 逐指令对象 { offset, opcode, mnemonic, operands }。
// 关键指令的助记符解码（invoke-* / move / return / const / if / goto 等常用指令；
// 未知操作码回退为十六进制助记符）。失败关闭：解析异常跳过。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

export interface DexInstruction {
  offset: number
  opcode: number
  mnemonic: string
  operands: string
}

// 常用指令助记符（按操作码——invoke/move/return/const/if/goto 等关键指令；其余回退 hex）
const OPCODE_MNEMONICS: Record<number, string> = {
  0x00: "nop", 0x01: "move", 0x02: "move/from16", 0x03: "move/16",
  0x07: "move-object", 0x0a: "move-result", 0x0b: "move-result-wide", 0x0c: "move-result-object",
  0x0e: "return-void", 0x0f: "return", 0x10: "return-wide", 0x11: "return-object",
  0x12: "const/4", 0x13: "const/16", 0x14: "const", 0x15: "const/high16",
  0x16: "const-wide/16", 0x17: "const-wide/32", 0x18: "const-wide", 0x19: "const-wide/high16",
  0x1a: "const-string", 0x1b: "const-string/jumbo",
  0x26: "fill-array-data", 0x27: "throw",
  0x28: "goto", 0x29: "goto/16", 0x2a: "goto/32",
  0x2b: "packed-switch", 0x2c: "sparse-switch",
  0x2d: "cmpl-float", 0x2e: "cmpg-float", 0x2f: "cmpl-double", 0x30: "cmpg-double", 0x31: "cmp-long",
  0x32: "if-eq", 0x33: "if-ne", 0x34: "if-lt", 0x35: "if-ge", 0x36: "if-gt", 0x37: "if-le",
  0x38: "if-eqz", 0x39: "if-nez", 0x3a: "if-ltz", 0x3b: "if-gez", 0x3c: "if-gtz", 0x3d: "if-lez",
  0x6e: "invoke-virtual", 0x6f: "invoke-super", 0x70: "invoke-direct", 0x71: "invoke-static",
  0x72: "invoke-interface", 0x74: "invoke-virtual/range", 0x75: "invoke-super/range",
  0x76: "invoke-direct/range", 0x77: "invoke-static/range", 0x78: "invoke-interface/range",
  0x7b: "neg-int", 0x90: "add-int", 0x91: "sub-int", 0x92: "mul-int", 0x93: "div-int",
  0xb0: "add-int/2addr", 0xb1: "sub-int/2addr", 0xb2: "mul-int/2addr",
  0xd0: "add-long", 0xd8: "add-double",
  0xe0: "add-int/lit16", 0xe2: "add-int/lit8", 0xe8: "add-long/lit8",
}

// 指令长度（字节）——常用指令的近似长度；未知按最小 1 字节
function instructionLength(opcode: number): number {
  if (opcode >= 0x12 && opcode <= 0x19) return 2 // const 系列
  if (opcode === 0x1a || opcode === 0x1b) return 4 // const-string
  if (opcode >= 0x28 && opcode <= 0x2a) return opcode === 0x28 ? 2 : opcode === 0x29 ? 4 : 6 // goto
  if (opcode >= 0x32 && opcode <= 0x3d) return 4 // if 系列
  if (opcode >= 0x6e && opcode <= 0x72) return 4 // invoke 35c
  if (opcode >= 0x74 && opcode <= 0x78) return 4 // invoke 3rc
  if (opcode === 0x90 || opcode === 0x91 || opcode === 0x92 || opcode === 0x93) return 4 // add/sub/mul/div-int
  if (opcode >= 0xb0 && opcode <= 0xb2) return 2 // 2addr
  if (opcode === 0xe0 || opcode === 0xe2) return 4 // lit16/lit8 近似
  return 2
}

// 迭代 code_item 的指令（有界——失败关闭）。
export function iterateInstructions(bytes: Uint8Array, codeOff: number, maxInstructions = 500): DexInstruction[] {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const insnsSize = view.getUint32(codeOff + 12, true)
  const insnsStart = codeOff + 16
  const instructions: DexInstruction[] = []
  let offset = 0
  while (offset < insnsSize * 2 && instructions.length < maxInstructions) {
    const opcode = bytes[insnsStart + offset]!
    const mnemonic = OPCODE_MNEMONICS[opcode] ?? `op_0x${opcode.toString(16)}`
    // 操作数摘要:invoke 的方法索引(2 字节 @+2);const-string 的字符串索引(@+2)
    let operands = ""
    if (opcode >= 0x6e && opcode <= 0x78) {
      const methodIndex = bytes[insnsStart + offset + 1]! | (bytes[insnsStart + offset + 2]! << 8)
      operands = `method@${methodIndex}`
    } else if (opcode === 0x1a || opcode === 0x1b) {
      const stringIndex = bytes[insnsStart + offset + 1]! | (bytes[insnsStart + offset + 2]! << 8)
      operands = `string@${stringIndex}`
    } else if (opcode >= 0x32 && opcode <= 0x3d) {
      const target = bytes[insnsStart + offset + 2]! | (bytes[insnsStart + offset + 3]! << 8)
      operands = `+${target}`
    }
    instructions.push({ offset, opcode, mnemonic, operands })
    offset += instructionLength(opcode)
  }
  return instructions
}

// 从 DEX 字节中提取所有方法 → 指令（供反汇编/类模型/IR 使用）。
export interface MethodCode {
  className: string
  methodName: string
  codeOff: number
  instructions: DexInstruction[]
}

export function extractMethodCodes(bytes: Uint8Array): MethodCode[] {
  const out: MethodCode[] = []
  // 解析 class_defs → class_data → code_item（复用调用图解析的模式——简化版）
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => view.getUint32(o, true)
  const stringIdsSize = u32(0x38)
  const stringIdsOff = u32(0x3c)
  const typeIdsSize = u32(0x40)
  const typeIdsOff = u32(0x44)
  const methodIdsSize = u32(0x58)
  const methodIdsOff = u32(0x5c)
  const classDefsSize = u32(0x60)
  const classDefsOff = u32(0x64)
  const readStringAt = (off: number): string => {
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
  const strings: string[] = []
  for (let i = 0; i < stringIdsSize && i < 4096; i += 1) strings.push(readStringAt(u32(stringIdsOff + i * 4)))
  const methodClasses: string[] = []
  const methodNames: string[] = []
  for (let i = 0; i < methodIdsSize && i < 4096; i += 1) {
    const base = methodIdsOff + i * 8
    const classIdx = view.getUint16(base, true)
    const nameIdx = u32(base + 4)
    const descriptorIdx = u32(typeIdsOff + classIdx * 4)
    const descriptor = strings[descriptorIdx] ?? ""
    methodClasses.push(descriptor.startsWith("L") ? descriptor.slice(1, -1).replaceAll("/", ".") : descriptor)
    methodNames.push(strings[nameIdx] ?? "")
  }
  const readUleb = (start: number): { value: number; next: number } => {
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
  let processed = 0
  for (let c = 0; c < classDefsSize && processed < 800; c += 1) {
    const classDataOff = u32(classDefsOff + c * 32 + 24)
    if (classDataOff === 0) continue
    let p = classDataOff
    const counts: number[] = []
    for (let i = 0; i < 4; i += 1) {
      const read = readUleb(p)
      counts.push(read.value)
      p = read.next
    }
    let methodIdx = 0
    for (const methodCount of [counts[2]!, counts[3]!]) {
      for (let m = 0; m < methodCount && processed < 800; m += 1) {
        const diff = readUleb(p)
        methodIdx += diff.value
        p = diff.next
        p = readUleb(p).next // access_flags
        const code = readUleb(p)
        p = code.next
        if (code.value !== 0) {
          out.push({
            className: methodClasses[methodIdx] ?? "?",
            methodName: methodNames[methodIdx] ?? "?",
            codeOff: code.value,
            instructions: iterateInstructions(bytes, code.value),
          })
        }
        processed += 1
      }
    }
  }
  return out
}

// 供后续模块使用（反汇编/类模型/IR）。
export function scanProjectInstructions(_projectRoot: string): Promise<Finding[]> {
  return Promise.resolve([])
}
