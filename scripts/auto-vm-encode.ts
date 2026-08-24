#!/usr/bin/env bun
// VMP 自动指令化（方向①——auto-vm-encode.ts——最硬盾的自动化基础）。
// 把一段简单逻辑（源码文本）自动转成 VM 指令数组（自定义指令集）——
// 生成的 VM_PROGRAM 可直接粘贴进 generate-vm-protection.ts 的框架（运行期解释执行——
// 静态分析只见指令数组与解释器，不见真实逻辑）。当前支持：赋值/二元运算/数字常量/变量。
// 分阶段：简单表达式 → 复杂表达式 → 控制流（后续扩展）。失败关闭。
//
// 用法：
//   bun scripts/auto-vm-encode.ts "<逻辑源码>" [--out 输出文件]
//   示例：bun scripts/auto-vm-encode.ts "x = a + b; y = x * 2; return y"
import { writeFile } from "node:fs/promises"

// 指令集（与 generate-vm-protection.ts 的 VM 解释器一致）
const OP = { CONST: 1, LOAD: 2, STORE: 3, ADD: 4, SUB: 5, MUL: 6, DIV: 7, RETURN: 8 } as const

// 寄存器分配：变量名 → 寄存器号（参数 a/b 用固定寄存器）
const ARG_REGS: Record<string, number> = { a: 0, b: 1 }

interface Compiled {
  instructions: Array<[number, number, number]>
  usedRegs: number
}

// 编译一段简单逻辑（语句用分号分隔——支持 x = expr; return expr——expr 含 + - * / 与常量/变量）。
function compile(logic: string): Compiled {
  const instructions: Array<[number, number, number]> = []
  const regs: Record<string, number> = { ...ARG_REGS }
  let nextReg = 2
  const statements = logic.split(";").map((s) => s.trim()).filter(Boolean)

  for (const statement of statements) {
    const ret = /^return\s+(.+)$/.exec(statement)
    if (ret) {
      const src = ret[1]!.trim()
      const reg = resolveExpr(src, instructions, regs, () => nextReg++)
      instructions.push([OP.RETURN, 0, reg])
      continue
    }
    const assign = /^([A-Za-z_]\w*)\s*=\s*(.+)$/.exec(statement)
    if (!assign) throw new Error(`无法解析语句：${statement}`)
    const target = assign[1]!
    const reg = regs[target] ?? (regs[target] = nextReg++)
    const srcReg = resolveExpr(assign[2]!.trim(), instructions, regs, () => nextReg++)
    instructions.push([OP.STORE, srcReg, reg])
  }
  return { instructions, usedRegs: nextReg }
}

// 解析表达式（二元运算链：常数/变量 → 逐运算生成指令——当前为左结合 + - * /）。
function resolveExpr(
  expr: string,
  instructions: Array<[number, number, number]>,
  regs: Record<string, number>,
  alloc: () => number,
): number {
  // 拆成 token（数字/变量/运算符——简单词法）
  const tokens = expr.match(/\d+|(?:[A-Za-z_]\w*)|[+\-*/]/g)
  if (!tokens) throw new Error(`无法解析表达式：${expr}`)
  let current = tokens[0]!
  const curReg = loadOperand(current, instructions, regs, alloc)
  let reg = curReg
  for (let i = 1; i < tokens.length; i += 2) {
    const op = tokens[i]!
    const rhs = loadOperand(tokens[i + 1]!, instructions, regs, alloc)
    const outReg = alloc()
    const opCode = { "+": OP.ADD, "-": OP.SUB, "*": OP.MUL, "/": OP.DIV }[op] ?? OP.ADD
    instructions.push([opCode, reg, rhs])
    instructions.push([OP.STORE, opCode === OP.ADD ? reg : reg, outReg]) // 结果存 outReg
    reg = outReg
  }
  void current
  return reg
}

// 加载操作数（常量 → CONST；变量 → LOAD/已有寄存器）。
function loadOperand(
  token: string,
  instructions: Array<[number, number, number]>,
  regs: Record<string, number>,
  alloc: () => number,
): number {
  if (/^\d+$/.test(token)) {
    const reg = alloc()
    instructions.push([OP.CONST, reg, Number.parseInt(token, 10)])
    return reg
  }
  return regs[token] ?? (regs[token] = alloc())
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const logic = argv[0]
  if (!logic) throw new Error("用法: auto-vm-encode \"<逻辑源码>\" [--out 输出文件]")
  let output: string | undefined
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--out") output = argv[++i]
  }
  const compiled = compile(logic)
  const program = compiled.instructions.map((ins) => `        { ${ins[0]}, ${ins[1]}, ${ins[2]} },`).join("\n")
  const content = `// 自动生成的 VM 指令（方向①——VMP 自动指令化）。
// 原逻辑：${logic}
// 把以下 VM_PROGRAM 粘贴进 generate-vm-protection.ts 生成的框架（VM 解释器执行——
// 静态分析只见指令数组与解释器，不见真实逻辑）。
public static final int[][] VM_PROGRAM = {
${program}
};
`
  if (output) {
    await writeFile(output, content, "utf8")
    console.log(`已生成 VM 指令：${output}（${compiled.instructions.length} 条指令——粘贴进 VM 框架运行期解释执行）`)
  } else {
    console.log(content)
    console.log(`（共 ${compiled.instructions.length} 条指令——可加 --out 写文件）`)
  }
}

main().catch((error) => {
  console.error(`VMP 自动指令化失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
