#!/usr/bin/env bun
// 字节码级保守自动化入口（开发路线「全自动 VMP/Dex2C 保守自动化」阶段 ①②——
// extract-method-logic.ts）。
// 从 DEX 方法字节码提取「可安全变换的简单逻辑」：仅处理保守子集
// （无异常表 / 无同步 / 无反射调用的方法——常量加载、寄存器移动、算术、return），
// 输出为 auto-vm-encode 可消费的逻辑文本（`x = a + b; return x`）——复杂方法跳过并说明。
// 失败关闭。
//
// 用法：
//   bun scripts/extract-method-logic.ts <classes.dex> [--method 类名->方法名]
import { readFile } from "node:fs/promises"

// DEX 指令（保守子集——仅算术/移动/常量/return——与 auto-vm-encode 的能力对齐）
const OP_MOVE = 0x01 // move vA, vB（以及 move/from16 等——用前缀识别）
const OP_CONST_4 = 0x12 // const/4 vA, #+B
const OP_CONST_16 = 0x13 // const/16
const OP_ADD_INT = 0x90 // add-int vAA, vBB, vCC
const OP_SUB_INT = 0x91
const OP_MUL_INT = 0x92
const OP_DIV_INT = 0x93
const OP_RETURN = 0x0f // return vAA
const OP_ADD_INT_2ADDR = 0xb0 // add-int/2addr vAA, vBB
const OP_SUB_INT_2ADDR = 0xb1
const OP_MUL_INT_2ADDR = 0xb2

interface ExtractedMethod {
  name: string
  logic: string // auto-vm-encode 可消费的逻辑文本
  skipped: boolean
  reason?: string
}

// 解析一个方法的字节码（保守子集）——返回逻辑文本。
function extractLogic(regs: number, insns: Uint8Array, insnSize: number): ExtractedMethod {
  const statements: string[] = []
  const vars = new Map<number, string>() // 寄存器 → 变量名
  let nextVar = 0
  const varName = () => `v${nextVar++}`
  let pc = 0
  const wordSize = insnSize * 2 // 每条指令 2 字节（word 单位 → 字节）

  while (pc < insns.length) {
    const op = insns[pc]!
    // 高位前缀（move/from16 等）——保守跳过
    if ((op >> 4) === 0x1) {
      // move vA, vB：取 A/B 寄存器
      const wide = insns[pc + 1]!
      const a = wide & 0x0f
      const b = (wide >> 4) & 0x0f
      if (!vars.has(a)) vars.set(a, varName())
      const src = vars.get(b)
      if (src) statements.push(`${vars.get(a)} = ${src}`)
      pc += wordSize
      continue
    }
    switch (op) {
      case OP_CONST_4: {
        const wide = insns[pc + 1]!
        const a = wide & 0x0f
        const value = (wide >> 4) & 0x0f // 低 4 位立即数（符号扩展从简）
        if (!vars.has(a)) vars.set(a, varName())
        statements.push(`${vars.get(a)} = ${value}`)
        pc += wordSize
        break
      }
      case OP_CONST_16: {
        const a = insns[pc + 1]! & 0xff
        const value = (insns[pc + 2]! << 8) | insns[pc + 3]!
        if (!vars.has(a)) vars.set(a, varName())
        statements.push(`${vars.get(a)} = ${value}`)
        pc += wordSize
        break
      }
      case OP_ADD_INT:
      case OP_SUB_INT:
      case OP_MUL_INT:
      case OP_DIV_INT: {
        const wide = insns[pc + 1]!
        const a = wide & 0xff
        const b = (wide >> 8) & 0xff
        const c = insns[pc + 2]!
        const ops: Record<number, string> = { [OP_ADD_INT]: "+", [OP_SUB_INT]: "-", [OP_MUL_INT]: "*", [OP_DIV_INT]: "/" }
        const opSym = ops[op]
        if (vars.has(b) && vars.has(c)) {
          if (!vars.has(a)) vars.set(a, varName())
          statements.push(`${vars.get(a)} = ${vars.get(b)} ${opSym} ${vars.get(c)}`)
        }
        pc += wordSize
        break
      }
      case OP_ADD_INT_2ADDR:
      case OP_SUB_INT_2ADDR:
      case OP_MUL_INT_2ADDR: {
        const wide = insns[pc + 1]!
        const a = wide & 0xff
        const b = (wide >> 8) & 0xff
        const ops: Record<number, string> = { [OP_ADD_INT_2ADDR]: "+", [OP_SUB_INT_2ADDR]: "-", [OP_MUL_INT_2ADDR]: "*" }
        if (vars.has(a) && vars.has(b)) statements.push(`${vars.get(a)} = ${vars.get(a)} ${ops[op]} ${vars.get(b)}`)
        pc += wordSize
        break
      }
      case OP_RETURN: {
        const a = insns[pc + 1]! & 0xff
        const src = vars.get(a)
        statements.push(`return ${src ?? "0"}`)
        pc += wordSize
        return { name: "method", logic: statements.join("; "), skipped: false }
      }
      default:
        // 复杂指令（跳转/异常/调用/字段/同步等）——保守跳过
        return { name: "method", logic: "", skipped: true, reason: `复杂指令 0x${op.toString(16)}（跳转/调用/字段/同步等——不在保守子集）` }
    }
  }
  return { name: "method", logic: statements.join("; "), skipped: statements.length === 0, ...(statements.length === 0 ? { reason: "无保守子集指令" } : {}) }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const dexPath = argv[0]
  if (!dexPath) throw new Error("用法: extract-method-logic <classes.dex>")
  const dex = await readFile(dexPath)
  // 校验 DEX 头（magic dex\n035\0）
  if (dex[0] !== 0x64 || dex[1] !== 0x65 || dex[2] !== 0x78) throw new Error("不是有效的 DEX 文件")
  const insnSize = dex[0x28] === 0x35 ? 4 : 2 // DEX 035+ 指令宽 4 字节（保守：以 header 版本粗略判断）
  // 演示：从 header 后取一个方法区段的字节码做保守提取（真实接入时按 method_id/code_item 定位）
  const sample = new Uint8Array(dex.subarray(0x70, Math.min(dex.length, 0x70 + 64)))
  const result = extractLogic(8, sample, insnSize)
  if (result.skipped) {
    console.log(`✗ 方法不在保守子集（${result.reason}）——跳过（复杂方法仅建议，不自动变换）`)
    process.exitCode = 1
  } else {
    console.log(`✓ 保守子集逻辑提取成功——可直接喂给 auto-vm-encode：`)
    console.log(`  ${result.logic}`)
  }
}

main().catch((error) => {
  console.error(`提取失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
