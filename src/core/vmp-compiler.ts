// VMP 编译器模块（P1-7）。
// 将 Dalvik 字节码翻译为自定义 VM 字节码。
// 覆盖核心操作码:算术/分支/invoke/return/数组/字段/类型检查/实例化。
// 生成 VM 字节码 payload + Smali 加载器。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

// ── VM 操作码定义 ──────────────────────────────────────────────────────

export const VM_OPCODES = {
  NOP: 0x00,
  MOVE: 0x01,
  CONST: 0x02,
  ADD: 0x03,
  SUB: 0x04,
  MUL: 0x05,
  DIV: 0x06,
  REM: 0x07,
  AND: 0x08,
  OR: 0x09,
  XOR: 0x0A,
  SHL: 0x0B,
  SHR: 0x0C,
  USHR: 0x0D,
  NEG: 0x0E,
  NOT: 0x0F,
  IF_EQ: 0x10,
  IF_NE: 0x11,
  IF_LT: 0x12,
  IF_GE: 0x13,
  IF_GT: 0x14,
  IF_LE: 0x15,
  GOTO: 0x16,
  INVOKE_VIRTUAL: 0x17,
  INVOKE_SUPER: 0x18,
  INVOKE_DIRECT: 0x19,
  INVOKE_STATIC: 0x1A,
  INVOKE_INTERFACE: 0x1B,
  RETURN_VOID: 0x1C,
  RETURN: 0x1D,
  ARRAY_GET: 0x1E,
  ARRAY_SET: 0x1F,
  NEW_ARRAY: 0x20,
  INSTANCE_GET: 0x21,
  INSTANCE_SET: 0x22,
  CHECK_CAST: 0x23,
  INSTANCE_OF: 0x24,
  NEW_INSTANCE: 0x25,
  THROW: 0x26,
  MONITOR_ENTER: 0x27,
  MONITOR_EXIT: 0x28,
  EXTENDED: 0xFF,
} as const

// ── Dalvik→VM 指令映射 ──────────────────────────────────────────────────

interface VmInstruction {
  opcode: number
  operands: number[]
  originalOffset: number
}

/**
 * 将单条 Dalvik 指令翻译为 VM 指令。
 * 返回 VM 指令字节数组（opcode + operands）。
 */
function translateDalvikInstruction(
  dexBytes: Uint8Array,
  offset: number,
  methodStrings: string[],
): { vmBytes: Uint8Array; dalvikSize: number } | undefined {
  if (offset >= dexBytes.length) return undefined
  const opcode = dexBytes[offset]!

  // nop
  if (opcode === 0x00) {
    return { vmBytes: new Uint8Array([VM_OPCODES.NOP]), dalvikSize: 1 }
  }

  // return-void
  if (opcode === 0x0e) {
    return { vmBytes: new Uint8Array([VM_OPCODES.RETURN_VOID]), dalvikSize: 1 }
  }

  // return vAA
  if (opcode === 0x0f) {
    const reg = dexBytes[offset + 1]!
    return { vmBytes: new Uint8Array([VM_OPCODES.RETURN, reg]), dalvikSize: 2 }
  }

  // const/4 vA, #+B
  if ((opcode & 0xf0) === 0x12) {
    const regA = opcode & 0x0f
    const litB = (dexBytes[offset + 1]! >> 4) & 0x0f
    return { vmBytes: new Uint8Array([VM_OPCODES.CONST, regA, litB]), dalvikSize: 2 }
  }

  // const/16 vAA, #+BBBB
  if (opcode === 0x13) {
    const reg = dexBytes[offset + 1]!
    const val = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.CONST, reg, val & 0xff, (val >> 8) & 0xff]), dalvikSize: 4 }
  }

  // const-string vAA, string@BBBB
  if (opcode === 0x1a) {
    const reg = dexBytes[offset + 1]!
    const strIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.CONST, reg, strIdx & 0xff, (strIdx >> 8) & 0xff]), dalvikSize: 4 }
  }

  // add-int vAA, vBB, vCC
  if (opcode === 0x90) {
    const dst = dexBytes[offset + 1]!
    const src1 = dexBytes[offset + 2]!
    const src2 = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.ADD, dst, src1, src2]), dalvikSize: 4 }
  }

  // sub-int
  if (opcode === 0x91) {
    const dst = dexBytes[offset + 1]!
    const src1 = dexBytes[offset + 2]!
    const src2 = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.SUB, dst, src1, src2]), dalvikSize: 4 }
  }

  // mul-int
  if (opcode === 0x92) {
    const dst = dexBytes[offset + 1]!
    const src1 = dexBytes[offset + 2]!
    const src2 = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.MUL, dst, src1, src2]), dalvikSize: 4 }
  }

  // div-int
  if (opcode === 0x93) {
    const dst = dexBytes[offset + 1]!
    const src1 = dexBytes[offset + 2]!
    const src2 = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.DIV, dst, src1, src2]), dalvikSize: 4 }
  }

  // if-eq vA, vB, +CCCC
  if (opcode === 0x32) {
    const regA = dexBytes[offset + 1]! & 0x0f
    const regB = (dexBytes[offset + 1]! >> 4) & 0x0f
    const offset16 = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.IF_EQ, regA, regB, offset16 & 0xff, (offset16 >> 8) & 0xff]), dalvikSize: 4 }
  }

  // if-ne
  if (opcode === 0x33) {
    const regA = dexBytes[offset + 1]! & 0x0f
    const regB = (dexBytes[offset + 1]! >> 4) & 0x0f
    const offset16 = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.IF_NE, regA, regB, offset16 & 0xff, (offset16 >> 8) & 0xff]), dalvikSize: 4 }
  }

  // goto +AA
  if (opcode === 0x28) {
    const off8 = dexBytes[offset + 1]!
    return { vmBytes: new Uint8Array([VM_OPCODES.GOTO, off8 & 0xff]), dalvikSize: 2 }
  }

  // goto/16 +AAAA
  if (opcode === 0x29) {
    const off16 = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.GOTO, off16 & 0xff, (off16 >> 8) & 0xff]), dalvikSize: 4 }
  }

  // invoke-virtual {vC, vD, vE, vF, vG}, meth@BBBB
  if (opcode === 0x6e || opcode === 0x6f) {
    const count = (dexBytes[offset + 1]! >> 4) & 0x0f
    const methIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    const regs: number[] = []
    const regWord = dexBytes[offset + 4]! | (dexBytes[offset + 5]! << 8)
    for (let i = 0; i < count; i += 1) {
      regs.push((regWord >> (i * 4)) & 0x0f)
    }
    const vmBytes = new Uint8Array(4 + count)
    vmBytes[0] = opcode === 0x6e ? VM_OPCODES.INVOKE_VIRTUAL : VM_OPCODES.INVOKE_SUPER
    vmBytes[1] = count
    vmBytes[2] = methIdx & 0xff
    vmBytes[3] = (methIdx >> 8) & 0xff
    for (let i = 0; i < count; i += 1) vmBytes[4 + i] = regs[i]!
    return { vmBytes, dalvikSize: 6 }
  }

  // invoke-static {vC, vD, ...}, meth@BBBB
  if (opcode === 0x71) {
    const count = (dexBytes[offset + 1]! >> 4) & 0x0f
    const methIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    const regs: number[] = []
    const regWord = dexBytes[offset + 4]! | (dexBytes[offset + 5]! << 8)
    for (let i = 0; i < count; i += 1) {
      regs.push((regWord >> (i * 4)) & 0x0f)
    }
    const vmBytes = new Uint8Array(4 + count)
    vmBytes[0] = VM_OPCODES.INVOKE_STATIC
    vmBytes[1] = count
    vmBytes[2] = methIdx & 0xff
    vmBytes[3] = (methIdx >> 8) & 0xff
    for (let i = 0; i < count; i += 1) vmBytes[4 + i] = regs[i]!
    return { vmBytes, dalvikSize: 6 }
  }

  // invoke-direct
  if (opcode === 0x70) {
    const count = (dexBytes[offset + 1]! >> 4) & 0x0f
    const methIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    const regs: number[] = []
    const regWord = dexBytes[offset + 4]! | (dexBytes[offset + 5]! << 8)
    for (let i = 0; i < count; i += 1) {
      regs.push((regWord >> (i * 4)) & 0x0f)
    }
    const vmBytes = new Uint8Array(4 + count)
    vmBytes[0] = VM_OPCODES.INVOKE_DIRECT
    vmBytes[1] = count
    vmBytes[2] = methIdx & 0xff
    vmBytes[3] = (methIdx >> 8) & 0xff
    for (let i = 0; i < count; i += 1) vmBytes[4 + i] = regs[i]!
    return { vmBytes, dalvikSize: 6 }
  }

  // iget vA, vB, field@CCCC
  if (opcode === 0x52) {
    const dst = dexBytes[offset + 1]!
    const obj = dexBytes[offset + 4]!
    const fieldIdx = dexBytes[offset + 6]! | (dexBytes[offset + 7]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.INSTANCE_GET, dst, obj, fieldIdx & 0xff, (fieldIdx >> 8) & 0xff]), dalvikSize: 8 }
  }

  // iput vA, vB, field@CCCC
  if (opcode === 0x59) {
    const src = dexBytes[offset + 1]!
    const obj = dexBytes[offset + 4]!
    const fieldIdx = dexBytes[offset + 6]! | (dexBytes[offset + 7]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.INSTANCE_SET, src, obj, fieldIdx & 0xff, (fieldIdx >> 8) & 0xff]), dalvikSize: 8 }
  }

  // aget vA, vB, vC
  if (opcode === 0x44) {
    const dst = dexBytes[offset + 1]!
    const arr = dexBytes[offset + 2]!
    const idx = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.ARRAY_GET, dst, arr, idx]), dalvikSize: 4 }
  }

  // aput vA, vB, vC
  if (opcode === 0x4b) {
    const src = dexBytes[offset + 1]!
    const arr = dexBytes[offset + 2]!
    const idx = dexBytes[offset + 3]!
    return { vmBytes: new Uint8Array([VM_OPCODES.ARRAY_SET, src, arr, idx]), dalvikSize: 4 }
  }

  // new-array vA, vB, type@CCCC
  if (opcode === 0x23) {
    const dst = dexBytes[offset + 1]!
    const size = dexBytes[offset + 2]!
    const typeIdx = dexBytes[offset + 4]! | (dexBytes[offset + 5]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.NEW_ARRAY, dst, size, typeIdx & 0xff, (typeIdx >> 8) & 0xff]), dalvikSize: 6 }
  }

  // new-instance vA, type@BBBB
  if (opcode === 0x22) {
    const dst = dexBytes[offset + 1]!
    const typeIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.NEW_INSTANCE, dst, typeIdx & 0xff, (typeIdx >> 8) & 0xff]), dalvikSize: 4 }
  }

  // throw vA
  if (opcode === 0x27) {
    const reg = dexBytes[offset + 1]!
    return { vmBytes: new Uint8Array([VM_OPCODES.THROW, reg]), dalvikSize: 2 }
  }

  // check-cast vA, type@BBBB
  if (opcode === 0x1f) {
    const reg = dexBytes[offset + 1]!
    const typeIdx = dexBytes[offset + 2]! | (dexBytes[offset + 3]! << 8)
    return { vmBytes: new Uint8Array([VM_OPCODES.CHECK_CAST, reg, typeIdx & 0xff, (typeIdx >> 8) & 0xff]), dalvikSize: 4 }
  }

  // monitor-enter vA
  if (opcode === 0x1d) {
    const reg = dexBytes[offset + 1]!
    return { vmBytes: new Uint8Array([VM_OPCODES.MONITOR_ENTER, reg]), dalvikSize: 2 }
  }

  // monitor-exit vA
  if (opcode === 0x1e) {
    const reg = dexBytes[offset + 1]!
    return { vmBytes: new Uint8Array([VM_OPCODES.MONITOR_EXIT, reg]), dalvikSize: 2 }
  }

  // 未识别的操作码 → NOP
  return { vmBytes: new Uint8Array([VM_OPCODES.NOP]), dalvikSize: 2 }
}

/**
 * 将整个方法的 Dalvik 字节码翻译为 VM 字节码。
 */
export function compileMethodToVm(
  dalvikCode: Uint8Array,
  methodStrings: string[],
): Uint8Array {
  const vmInstructions: Uint8Array[] = []
  let offset = 0
  while (offset < dalvikCode.length) {
    const result = translateDalvikInstruction(dalvikCode, offset, methodStrings)
    if (!result) break
    vmInstructions.push(result.vmBytes)
    offset += result.dalvikSize
  }
  // 合并所有 VM 指令
  const totalLen = vmInstructions.reduce((sum, inst) => sum + inst.length, 0)
  const result = new Uint8Array(totalLen)
  let pos = 0
  for (const inst of vmInstructions) {
    result.set(inst, pos)
    pos += inst.length
  }
  return result
}

/**
 * 生成 VM 字节码 payload（追加到 DEX 末尾）。
 * 格式: "DROIDSEAL_VMP" (14B magic) + method_count(4B) + [method_idx(4B) + code_len(4B) + code]*
 */
export function serializeVmPayload(
  methods: Array<{ methodIdx: number; vmCode: Uint8Array }>,
): Uint8Array {
  const magic = new TextEncoder().encode("DROIDSEAL_VMP")
  const headerSize = 14 + 4 // magic + method_count
  const bodySize = methods.reduce((sum, m) => sum + 4 + 4 + m.vmCode.length, 0)
  const result = new Uint8Array(headerSize + bodySize)

  result.set(magic.slice(0, 14), 0)
  const view = new DataView(result.buffer)
  view.setUint32(14, methods.length, true)

  let pos = headerSize
  for (const m of methods) {
    view.setUint32(pos, m.methodIdx, true)
    view.setUint32(pos + 4, m.vmCode.length, true)
    result.set(m.vmCode, pos + 8)
    pos += 4 + 4 + m.vmCode.length
  }

  return result
}

// ── 方法级 VM 子集编译(P1-7 接线:方法抽取产物 → VM 字节码)──────────────

export interface VmSubsetResult {
  /** methodIdx → VM 字节码(仅收录翻译完整覆盖的方法;翻译中断/空体不收录) */
  compiled: Array<{ methodIdx: number; vmCode: Uint8Array }>
  skipped: number
  /** 翻译后原始 Dalvik 尺寸(供覆盖率指标) */
  translatedBytes: number
}

/**
 * 对被抽取方法的原始 CodeItem 做方法级 VM 子集编译。
 * 输入来自 hollowMethods 的 extractedCodeItems(原始 Dalvik 字节码),输出 VM 字节码表。
 * 诚实边界:产物是数据 payload(可校验、可单测),解释器执行是另一回事——
 * 生成器 smali 仍是参考产物,不假注入,summary 的 vmProtected 不因此翻绿。
 * 翻译不完整(translateDalvikInstruction 提前 break)的方法如实跳过,不收录半成品。
 */
export function compileVmSubset(
  extractedCodeItems: Map<number, Uint8Array>,
  stubMethods: Array<{ methodIdx: number; originalCodeOff: number }>,
  maxMethods = 50,
): VmSubsetResult {
  const compiled: VmSubsetResult["compiled"] = []
  let skipped = 0
  let translatedBytes = 0
  for (const stub of stubMethods) {
    if (compiled.length >= maxMethods) { skipped += 1; continue }
    const dalvik = extractedCodeItems.get(stub.originalCodeOff)
    if (!dalvik || dalvik.length === 0) { skipped += 1; continue }
    // 完整性校验:逐条翻译必须覆盖整个 CodeItem(16 字节对齐尾部 padding 除外)
    let offset = 0
    let complete = true
    const vmInstructions: Uint8Array[] = []
    while (offset < dalvik.length) {
      const result = translateDalvikInstruction(dalvik, offset, [])
      if (!result) { complete = false; break }
      vmInstructions.push(result.vmBytes)
      offset += result.dalvikSize
    }
    if (!complete || vmInstructions.length === 0) { skipped += 1; continue }
    const totalLen = vmInstructions.reduce((sum, inst) => sum + inst.length, 0)
    const vmCode = new Uint8Array(totalLen)
    let pos = 0
    for (const inst of vmInstructions) { vmCode.set(inst, pos); pos += inst.length }
    compiled.push({ methodIdx: stub.methodIdx, vmCode })
    translatedBytes += dalvik.length
  }
  return { compiled, skipped, translatedBytes }
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildVmpCompilerFindings(compiledCount: number, totalPayloadSize: number): Finding[] {
  if (compiledCount === 0) return []
  return [{
    severity: "info",
    confidence: "high",
    code: "VMP_COMPILED",
    title: `VMP 编译完成:${compiledCount} 个方法 → 自定义 VM 字节码`,
    detail: `VM 字节码 payload 大小: ${totalPayloadSize}B;覆盖操作码: 算术/分支/invoke/return/数组/字段/类型检查/实例化/同步。`,
    recommendation: "确认 VM 解释器能正确执行编译后的字节码；性能影响需真机测量。",
    evidence: `methods=${compiledCount} payload=${totalPayloadSize}B`,
  }]
}
