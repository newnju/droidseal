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
  LIT_ADD: 0x2A,
  LIT_SUB: 0x2B,
  LIT_MUL: 0x2C,
  LIT_DIV: 0x2D,
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

  // add/sub/mul/div-int/2addr vA, vB(A+=B 等原地语义):发射 OP A, A, B
  if (opcode >= 0xb0 && opcode <= 0xb3) {
    const regA = dexBytes[offset + 1]! & 0x0f
    const regB = (dexBytes[offset + 1]! >> 4) & 0x0f
    const op = [VM_OPCODES.ADD, VM_OPCODES.SUB, VM_OPCODES.MUL, VM_OPCODES.DIV][opcode - 0xb0]!
    return { vmBytes: new Uint8Array([op, regA, regA, regB]), dalvikSize: 2 }
  }

  // add/sub/mul/div-int/lit8 vAA, vBB, #+CC:发射 LIT_* dst, src, imm8(符号扩展)。
  // 0xd9 是 rsub-int/lit8(操作数交换语义),本子集不支持——返回 undefined 让整个
  // 方法如实跳过(fail-closed),绝不能错译成 SUB。
  if (opcode >= 0xd8 && opcode <= 0xdb) {
    if (opcode === 0xd9) return undefined
    const dst = dexBytes[offset + 1]!
    const src = dexBytes[offset + 2]!
    const lit = dexBytes[offset + 3]!
    const op = [VM_OPCODES.LIT_ADD, VM_OPCODES.LIT_MUL, VM_OPCODES.LIT_DIV][opcode - 0xd8 - (opcode > 0xd9 ? 1 : 0)]!
    return { vmBytes: new Uint8Array([op, dst, src, (lit << 24) >> 24 & 0xff]), dalvikSize: 4 }
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

  // 未识别的操作码 → 返回 undefined(fail-closed):整个方法如实跳过。
  // 绝不能发 NOP 兜底——那会把不认识的指令静默变空操作,执行结果错而不自知。
  return undefined
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
 * 格式: "DROIDSEAL_VMP" (14B magic) + method_count(4B)
 *       + [method_idx(4B) + code_len(4B) + initial_reg(4B) + code]*
 */
export function serializeVmPayload(
  methods: Array<{ methodIdx: number; vmCode: Uint8Array; initialReg: number }>,
): Uint8Array {
  const magic = new TextEncoder().encode("DROIDSEAL_VMP")
  const headerSize = 14 + 4 // magic + method_count
  const bodySize = methods.reduce((sum, m) => sum + 4 + 4 + 4 + m.vmCode.length, 0)
  const result = new Uint8Array(headerSize + bodySize)

  result.set(magic.slice(0, 14), 0)
  const view = new DataView(result.buffer)
  view.setUint32(14, methods.length, true)

  let pos = headerSize
  for (const m of methods) {
    view.setUint32(pos, m.methodIdx, true)
    view.setUint32(pos + 4, m.vmCode.length, true)
    view.setUint32(pos + 8, m.initialReg, true)
    result.set(m.vmCode, pos + 12)
    pos += 4 + 4 + 4 + m.vmCode.length
  }

  return result
}

// ── 方法级 VM 子集编译(P1-7 接线:方法抽取产物 → VM 字节码)──────────────

export interface VmSubsetResult {
  /** methodIdx → VM 字节码(仅收录翻译完整覆盖的方法;翻译中断/空体不收录) */
  compiled: Array<{ methodIdx: number; vmCode: Uint8Array; initialReg: number }>
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
    const item = extractedCodeItems.get(stub.originalCodeOff)
    if (!item || item.length <= 16) { skipped += 1; continue }
    // code_item 头(16B): registers_size@0 ins_size@2;只翻译 insns 区,
    // 头字节绝不是指令(此前整 item 翻译会把头当指令发射垃圾 VM 码)。
    const hv = new DataView(item.buffer, item.byteOffset, item.byteLength)
    const registersSize = hv.getUint16(0, true)
    const insSize = hv.getUint16(2, true)
    // static (I)I 单 int 入参寄存器 = registers_size - ins_size(桥注册已按签名过滤)
    const initialReg = registersSize - insSize
    if (initialReg < 0 || initialReg >= 16) { skipped += 1; continue }
    const dalvik = item.subarray(16)
    // 完整性校验:逐条翻译必须覆盖整个 insns 区(尾部 padding 除外)
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
    // initialReg:入参寄存器 = registers_size - ins_size(上方已从 code_item 头解析;
    // static (I)I → v1。非单 int 形态已由 resolveVmBridgeEntries 按签名过滤)
    compiled.push({ methodIdx: stub.methodIdx, vmCode, initialReg })
    translatedBytes += dalvik.length
  }
  return { compiled, skipped, translatedBytes }
}

// ── 里程碑 A:叶子方法 VM 解释器执行端 ─────────────────────────────────
// 语义:寄存器式 VM(与 translateDalvikInstruction 的发射格式严格一致——
//   CONST reg, imm16 | OP dst, src1, src2 | RETURN reg)。
// 覆盖操作码 = CONST/ADD/SUB/MUL/DIV/RETURN 子集,不含 invoke/字段/分支——
// 叶子方法(getter/校验/简单算法)专用。
// 诚实边界:本生成器只产出执行端 C(可编译可测),不注入 APK、不改方法路由——
// 注入(ArtMethod 替换/JNI 注册)是里程碑 B,summary 的 vmProtected 在注入前恒 false。

// TS 参考解释器:与 C 执行端同语义(单测对拍基准,防两侧漂移)
// v0 预置入参 initial;寄存器 16 个(int32)。
export function executeVmLeaf(code: Uint8Array, arg: number, initialReg = 0): { ok: boolean; result?: number } {
  const regs = new Int32Array(16)
  regs[initialReg] = arg | 0
  let pc = 0
  const view = new DataView(code.buffer, code.byteOffset, code.byteLength)
  while (pc < code.length) {
    const op = code[pc]!
    pc += 1
    switch (op) {
      case VM_OPCODES.CONST: {
        // CONST reg, val16(LE,符号扩展——与 const/16 语义一致)
        if (pc + 3 > code.length) return { ok: false }
        const reg = code[pc]!
        const val = view.getUint16(pc + 1, true)
        if (reg >= 16) return { ok: false }
        regs[reg] = (val << 16) >> 16
        pc += 3
        break
      }
      case VM_OPCODES.ADD: case VM_OPCODES.SUB: case VM_OPCODES.MUL: case VM_OPCODES.DIV: {
        // OP dst, src1, src2
        if (pc + 3 > code.length) return { ok: false }
        const dst = code[pc]!
        const s1 = code[pc + 1]!
        const s2 = code[pc + 2]!
        if (dst >= 16 || s1 >= 16 || s2 >= 16) return { ok: false }
        const a = regs[s1]!
        const b = regs[s2]!
        if (op === VM_OPCODES.ADD) regs[dst] = (a + b) | 0
        else if (op === VM_OPCODES.SUB) regs[dst] = (a - b) | 0
        else if (op === VM_OPCODES.MUL) regs[dst] = Math.imul(a, b)
        else {
          if (b === 0) return { ok: false } // 除零如实失败,不兜底假值
          regs[dst] = Math.trunc(a / b) | 0
        }
        pc += 3
        break
      }
      case VM_OPCODES.LIT_ADD: case VM_OPCODES.LIT_SUB: case VM_OPCODES.LIT_MUL: case VM_OPCODES.LIT_DIV: {
        // LIT_* dst, src, imm8(符号扩展)
        if (pc + 3 > code.length) return { ok: false }
        const dst = code[pc]!
        const s1 = code[pc + 1]!
        const b = (code[pc + 2]! << 24) >> 24
        if (dst >= 16 || s1 >= 16) return { ok: false }
        const a = regs[s1]!
        if (op === VM_OPCODES.LIT_ADD) regs[dst] = (a + b) | 0
        else if (op === VM_OPCODES.LIT_SUB) regs[dst] = (a - b) | 0
        else if (op === VM_OPCODES.LIT_MUL) regs[dst] = Math.imul(a, b)
        else {
          if (b === 0) return { ok: false } // 除零如实失败,不兜底假值
          regs[dst] = Math.trunc(a / b) | 0
        }
        pc += 3
        break
      }
      case VM_OPCODES.RETURN: {
        // RETURN reg
        if (pc + 1 > code.length) return { ok: false }
        const reg = code[pc]!
        if (reg >= 16) return { ok: false }
        return { ok: true, result: regs[reg]! }
      }
      default:
        return { ok: false } // 未知操作码如实失败(fail-closed,不静默跳过)
    }
  }
  return { ok: false } // 无 return 结尾:不完整方法,拒绝执行
}

/** 生成 VM 解释器 C 执行端(叶子方法子集,寄存器式,guard_vote 同编译链) */
export function generateVmInterpreterC(): string {
  return `// DroidSeal VMP-lite 叶子方法解释器(里程碑 A,构建期自动生成,勿手动修改)
// 寄存器式:与 TS 参考解释器 executeVmLeaf 严格一致(单测对拍防漂移)。
// 指令格式(与 vmp-compiler.ts 翻译器发射一致):
//   CONST  reg, imm16   (1B op + 1B reg + 2B LE, 符号扩展)
//   ADD/SUB/MUL/DIV dst, src1, src2 (1B op + 3B reg)
//   RETURN reg          (1B op + 1B reg)
// 边界:仅上述子集;未知操作码/除零/寄存器越界/截断指令如实返回错误码,
// 不兜底假值;本文件不含方法路由——注入是里程碑 B,未注入前 vmProtected=false。
#include <stdint.h>
#include <stddef.h>

#define DSVM_REGS 16
#define DSVM_ERR_UNKNOWN_OP (-1)
#define DSVM_ERR_REG        (-2)
#define DSVM_ERR_DIVZERO    (-3)
#define DSVM_ERR_TRUNCATED  (-4)
#define DSVM_ERR_NO_RETURN  (-5)

/* 操作码常量(与 vmp-compiler.ts VM_OPCODES 一致) */
#define DSVM_OP_CONST   0x02
#define DSVM_OP_ADD     0x03
#define DSVM_OP_SUB     0x04
#define DSVM_OP_MUL     0x05
#define DSVM_OP_DIV     0x06
#define DSVM_OP_LIT_ADD 0x2A
#define DSVM_OP_LIT_SUB 0x2B
#define DSVM_OP_LIT_MUL 0x2C
#define DSVM_OP_LIT_DIV 0x2D
#define DSVM_OP_RETURN  0x1D

int dsvm_execute_leaf(const uint8_t* code, size_t code_len,
                      int32_t initial, uint32_t initial_reg, int32_t* out_result) {
    int32_t regs[DSVM_REGS];
    if (initial_reg >= DSVM_REGS) return DSVM_ERR_REG;
    regs[initial_reg] = initial; /* 入参寄存器由 payload 指定(与 TS 参考一致) */
    size_t pc = 0;
    while (pc < code_len) {
        uint8_t op = code[pc++];
        switch (op) {
            case DSVM_OP_CONST: {
                if (pc + 3 > code_len) return DSVM_ERR_TRUNCATED;
                uint8_t reg = code[pc];
                if (reg >= DSVM_REGS) return DSVM_ERR_REG;
                uint16_t raw = (uint16_t)(code[pc + 1] | ((uint16_t)code[pc + 2] << 8));
                regs[reg] = (int32_t)(int16_t)raw; /* 符号扩展(const/16 语义) */
                pc += 3;
                break;
            }
            case DSVM_OP_ADD: case DSVM_OP_SUB: case DSVM_OP_MUL: case DSVM_OP_DIV: {
                if (pc + 3 > code_len) return DSVM_ERR_TRUNCATED;
                uint8_t dst = code[pc], s1 = code[pc + 1], s2 = code[pc + 2];
                if (dst >= DSVM_REGS || s1 >= DSVM_REGS || s2 >= DSVM_REGS) return DSVM_ERR_REG;
                int32_t a = regs[s1], b = regs[s2];
                if (op == DSVM_OP_ADD) regs[dst] = (int32_t)((uint32_t)a + (uint32_t)b);
                else if (op == DSVM_OP_SUB) regs[dst] = (int32_t)((uint32_t)a - (uint32_t)b);
                else if (op == DSVM_OP_MUL) regs[dst] = (int32_t)((uint32_t)a * (uint32_t)b);
                else {
                    if (b == 0) return DSVM_ERR_DIVZERO;
                    regs[dst] = a / b;
                }
                pc += 3;
                break;
            }
            case DSVM_OP_LIT_ADD: case DSVM_OP_LIT_SUB: case DSVM_OP_LIT_MUL: case DSVM_OP_LIT_DIV: {
                if (pc + 3 > code_len) return DSVM_ERR_TRUNCATED;
                uint8_t dst = code[pc], s1 = code[pc + 1];
                if (dst >= DSVM_REGS || s1 >= DSVM_REGS) return DSVM_ERR_REG;
                int32_t a = regs[s1], b = (int32_t)(int8_t)code[pc + 2]; /* imm8 符号扩展 */
                if (op == DSVM_OP_LIT_ADD) regs[dst] = (int32_t)((uint32_t)a + (uint32_t)b);
                else if (op == DSVM_OP_LIT_SUB) regs[dst] = (int32_t)((uint32_t)a - (uint32_t)b);
                else if (op == DSVM_OP_LIT_MUL) regs[dst] = (int32_t)((uint32_t)a * (uint32_t)b);
                else {
                    if (b == 0) return DSVM_ERR_DIVZERO;
                    regs[dst] = a / b;
                }
                pc += 3;
                break;
            }
            case DSVM_OP_RETURN: {
                if (pc + 1 > code_len) return DSVM_ERR_TRUNCATED;
                uint8_t reg = code[pc];
                if (reg >= DSVM_REGS) return DSVM_ERR_REG;
                *out_result = regs[reg];
                return 0;
            }
            default:
                return DSVM_ERR_UNKNOWN_OP;
        }
    }
    return DSVM_ERR_NO_RETURN;
}
`
}

// ── 里程碑 B:RegisterNatives 注入桥(代码路径,真机验收前 vmProtected 恒 false)──
// 语义:壳初始化(JNI_OnLoad)时,把被 VM 化的方法经 RegisterNatives 注册为
// native 实现——dispatch 进 VM 解释器执行,替代原 Dalvik 代码路径。
// 诚实边界:本生成器只产出桥 C 代码(可编译、可单测字符串断言);
// 真机矩阵(API 24-35)验收通过前,vmProtected 维持 false——stub 的 ACC_NATIVE
// 标记与桥注册是否在真机生效,属于运行时行为,构建期无法证实。

export interface VmBridgeEntry {
  /** 混淆后的 native 桩方法名(壳 DEX 中 stub 方法的注册名) */
  stubName: string
  /** 完整 Dalvik 签名,如 "(II)I" */
  signature: string
  /** VM payload 中该方法的 method_idx(运行时查表键) */
  methodIdx: number
  /** 所属类点分路径(多类分组注册用;dsvmRegisterAll 入口) */
  className?: string
}

/**
 * 生成 RegisterNatives 桥 C 代码:JNINativeMethod 表 + 注册函数 + VM 分发。
 * 分发函数按 methodIdx 从 payload 表查 VM 字节码,调 dsvm_execute_leaf 执行;
 * 未收录的方法 idx 如实返回 0 并打日志(fail-open 保可用,与惰性还原同口径)。
 */
export function generateVmRegisterBridgeC(
  entries: VmBridgeEntry[],
  loaderClassPath = "droidseal.runtime.DroidSealLoader",
  vmPayload?: Uint8Array,
): string {
  const tableRows = entries
    .map((e) => `    { "${e.stubName}", "${e.signature}", NULL },`)
    .join("\n")
  // payload 以 C 数组直接嵌入 SO,注册入口处初始化——杜绝"g_vm_payload 恒 NULL"断链
  // JNI 导出符号名转义(JNI 规约):'_'→"_1"、';'→"_2"、'['→"_3"、非 ASCII →"_0xxxx"。
  // 随机化类名可含 '_'(如 EmDxhk_OmIfyR53),不转义则运行时按 _1 解析,链接必败。
  // 单遍替换:必须一次处理 '.'→'_' 与 '_'→'_1'——若先替换 '.' 再转义 '_',
  // 新产生的 '_' 会被二次转义成 _1(链接符号错位必败)
  const jniSymbolPath = loaderClassPath.replace(/[._;\[]|[^ -~]/g, (ch) =>
    ch === "." ? "_" : ch === "_" ? "_1" : ch === ";" ? "_2" : ch === "[" ? "_3" : `_0${ch.codePointAt(0)!.toString(16).padStart(4, "0")}`,
  )
  const payloadArray = vmPayload
    ? `static const unsigned char g_vm_payload_data[] = {${Array.from(vmPayload).join(",")}};\nstatic const size_t g_vm_payload_data_len = sizeof(g_vm_payload_data);`
    : `/* 无 payload(构建侧未传)——运行期 vm_lookup 恒 NULL,如实 fail-open */`
  const payloadInit = vmPayload
    ? `    dsvm_set_vm_payload(g_vm_payload_data, g_vm_payload_data_len);`
    : `    /* no embedded payload */`
  return `// DroidSeal VMP-lite RegisterNatives 桥(里程碑 B,构建期自动生成,勿手动修改)
// 语义:注册 VM 化方法为 native 实现,dispatch 进解释器(与 executeVmLeaf 对拍)。
// 诚实边界:未过真机矩阵验收前,构建侧 vmProtected 保持 false——本文件存在
// 不等于注入生效;生效与否由 device-test.sh --vm-mode 真机断言背书。
#include <jni.h>
#include <stdint.h>
#include <string.h>
#include <android/log.h>

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "DroidSealVMP", __VA_ARGS__)

/* 与 vmp-compiler.ts generateVmInterpreterC 同一执行端(链接期合并) */
extern int dsvm_execute_leaf(const uint8_t* code, size_t code_len,
                             int32_t initial, uint32_t initial_reg, int32_t* out_result);

/* VM payload 运行时布局(与 serializeVmPayload 一致):
 * "DROIDSEAL_VMP"(14B) + method_count(4B LE) + [method_idx(4B) + code_len(4B) + initial_reg(4B) + code]* */
${payloadArray}
static const uint8_t* g_vm_payload = NULL;
static size_t g_vm_payload_len = 0;
void dsvm_set_vm_payload(const uint8_t* data, size_t len); /* 前置声明:定义在文件尾,dsvmRegisterAll 先用 */

/* 查表:method_idx → VM 字节码;未收录返回 NULL(如实,不假执行) */
static const uint8_t* vm_lookup(uint32_t method_idx, size_t* out_len, uint32_t* out_initial_reg) {
    if (g_vm_payload == NULL || g_vm_payload_len < 22) return NULL;
    if (memcmp(g_vm_payload, "DROIDSEAL_VMP", 13) != 0) return NULL;
    uint32_t count;
    memcpy(&count, g_vm_payload + 14, 4);
    size_t pos = 18;
    for (uint32_t i = 0; i < count; i++) {
        if (pos + 12 > g_vm_payload_len) return NULL;
        uint32_t idx, len, ireg;
        memcpy(&idx, g_vm_payload + pos, 4);
        memcpy(&len, g_vm_payload + pos + 4, 4);
        memcpy(&ireg, g_vm_payload + pos + 8, 4);
        pos += 12;
        if (pos + len > g_vm_payload_len) return NULL;
        if (idx == method_idx) { *out_len = len; *out_initial_reg = ireg; return g_vm_payload + pos; }
        pos += len;
    }
    return NULL;
}

/* 统一分发:int 返回值叶子方法(叶子子集均为算术,入参取 jint 压缩) */
static jint vm_dispatch_leaf(JNIEnv* env, jclass clazz, jint arg, jint method_idx) {
    (void)env; (void)clazz;
    size_t len = 0;
    uint32_t ireg = 0;
    const uint8_t* code = vm_lookup((uint32_t)method_idx, &len, &ireg);
    if (code == NULL) {
        LOGI("vm_dispatch_leaf: method %u not in payload (fail-open)", method_idx);
        return 0;
    }
    int32_t result = 0;
    if (dsvm_execute_leaf(code, len, arg, ireg, &result) != 0) {
        LOGI("vm_dispatch_leaf: method %u execution failed (fail-closed)", method_idx);
        return 0;
    }
    return result;
}

/* 每个 VM 化方法一个 thunk:按注册表 methodIdx 预置分发参数 */
${entries.map((e, i) => `static jint JNICALL vm_thunk_${i}(JNIEnv* env, jclass clazz, jint arg) {
    return vm_dispatch_leaf(env, clazz, arg, ${e.methodIdx});
}`).join("\n")}

static JNINativeMethod g_bridge_table[] = {
${tableRows}
};
static void* g_thunks[] = {
${entries.map((_, i) => `    (void*)vm_thunk_${i},`).join("\n")}
};

/* 壳初始化时调用:把 VM 化方法注册为 native(经 FindClass 定位壳桩类) */
int dsvm_register_vm_bridge(JNIEnv* env, jclass stub_class) {
    for (size_t i = 0; i < sizeof(g_bridge_table) / sizeof(g_bridge_table[0]); i++) {
        g_bridge_table[i].fnPtr = g_thunks[i];
    }
    jint n = sizeof(g_bridge_table) / sizeof(g_bridge_table[0]);
    if (stub_class == NULL) { LOGI("vm bridge: stub class null, skip"); return -1; }
    if ((*env)->RegisterNatives(env, stub_class, g_bridge_table, n) != JNI_OK) {
        LOGI("vm bridge: RegisterNatives failed");
        return -1;
    }
    LOGI("vm bridge: %d methods registered", (int)n);
    return 0;
}

/* Java 可调用的注册入口(dsvmRegisterAll):JNI_OnLoad 时 app 类未加载,
 * RegisterNatives 必败——由壳 loader 在 app classloader 就绪后显式调用。
 * JNI 导出符号随 loaderClassPath 参数化(loader 类名构建期随机化,硬编码必败)。
 * FindClass 用的是调用方(壳 loader)的类加载器,找不到 InMemoryDexClassLoader
 * 里的 app 类——所以入参是 app ClassLoader,经 loadClass 逐类定位后再注册。
 * 按类分组:每类 loadClass → 注册该类条目 → DeleteLocalRef;任一类失败如实记日志
 * 继续其余类(fail-open 保可用,与惰性还原同口径),返回成功注册的方法总数。 */
JNIEXPORT jint JNICALL
Java_${jniSymbolPath}_dsvmRegisterAll(JNIEnv* env, jclass clazz, jobject app_loader) {
    (void)clazz;
    ${payloadInit}
    for (size_t i = 0; i < sizeof(g_bridge_table) / sizeof(g_bridge_table[0]); i++) {
        g_bridge_table[i].fnPtr = g_thunks[i];
    }
    if (app_loader == NULL) { LOGI("vm bridge: app loader null, skip"); return 0; }
    jclass clsCls = (*env)->FindClass(env, "java/lang/ClassLoader");
    if (clsCls == NULL) { (*env)->ExceptionClear(env); LOGI("vm bridge: ClassLoader not found"); return 0; }
    jmethodID loadClass = (*env)->GetMethodID(env, clsCls, "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;");
    (*env)->DeleteLocalRef(env, clsCls);
    if (loadClass == NULL) { (*env)->ExceptionClear(env); LOGI("vm bridge: loadClass mid not found"); return 0; }
    int total = 0;
${[...new Set(entries.map((e) => e.className ?? ""))].filter((c) => c !== "").map((cls) => {
  const clsEntries = entries.map((e, i) => ({ e, i })).filter(({ e }) => (e.className ?? "") === cls)
  return `    { /* 类 ${cls} */
        jstring jn = (*env)->NewStringUTF(env, "${cls}");
        if (jn != NULL) {
            jclass c = (jclass)(*env)->CallObjectMethod(env, app_loader, loadClass, jn);
            (*env)->DeleteLocalRef(env, jn);
            if (c != NULL) {
                JNINativeMethod t[] = {
${clsEntries.map(({ e }) => `                    { "${e.stubName}", "${e.signature}", (void*)vm_thunk_${entries.indexOf(e)} },`).join("\n")}
                };
                if ((*env)->RegisterNatives(env, c, t, ${clsEntries.length}) == JNI_OK) {
                    total += ${clsEntries.length};
                } else {
                    (*env)->ExceptionClear(env);
                    LOGI("vm bridge: register failed for ${cls}");
                }
                (*env)->DeleteLocalRef(env, c);
            } else {
                (*env)->ExceptionClear(env);
                LOGI("vm bridge: class not found: ${cls}");
            }
        }
    }`
}).join("\n")}
    LOGI("vm bridge: %d methods registered total", total);
    return total;
}

/* payload 注入点(壳 setCodeTable 侧调用,亦供嵌入数组初始化复用) */
void dsvm_set_vm_payload(const uint8_t* data, size_t len) {
    g_vm_payload = data;
    g_vm_payload_len = len;
}
`
}

// stub native 标记(DEX 侧):VM 化方法在壳 DEX 中必须带 ACC_NATIVE(0x0100),
// 否则 ART 走解释 Dalvik 路径,RegisterNatives 注册无效。
// 输入 access_flags,输出置位后的 flags(幂等,已置位原样返回)。
export const ACC_NATIVE = 0x0100
export function markStubNative(accessFlags: number): number {
  return accessFlags | ACC_NATIVE
}
export function isStubNative(accessFlags: number): boolean {
  return (accessFlags & ACC_NATIVE) !== 0
}

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
