// VMP-lite 里程碑 A 单测:TS 参考解释器语义(寄存器式,与 translateDalvikInstruction
// 发射格式一致)+ C 执行端对拍基准
import { describe, test, expect } from "bun:test"
import { executeVmLeaf, VM_OPCODES, generateVmInterpreterC } from "../src/core/vmp-compiler.ts"

// 手工汇编(寄存器式,与翻译器发射格式严格一致):
//   CONST  reg, imm16(1B op + 1B reg + 2B LE)
//   OP     dst, src1, src2(1B op + 3B reg)
//   RETURN reg(1B op + 1B reg)
function asm(...parts: Array<{ op: number; regs?: number[]; imm?: number }>): Uint8Array {
  const out: number[] = []
  for (const p of parts) {
    out.push(p.op)
    if (p.imm !== undefined) {
      out.push(p.regs![0]!)
      out.push(p.imm & 0xff, (p.imm >> 8) & 0xff)
    } else {
      out.push(...(p.regs ?? []))
    }
  }
  return new Uint8Array(out)
}

describe("executeVmLeaf(TS 参考解释器,C 侧同语义)", () => {
  test("寄存器语义:(v0+7)*3,v0 为入参 10", () => {
    const code = asm(
      { op: VM_OPCODES.CONST, regs: [1], imm: 7 },
      { op: VM_OPCODES.ADD, regs: [1, 0, 1] },
      { op: VM_OPCODES.CONST, regs: [2], imm: 3 },
      { op: VM_OPCODES.MUL, regs: [1, 1, 2] },
      { op: VM_OPCODES.RETURN, regs: [1] },
    )
    const r = executeVmLeaf(code, 10)
    expect(r.ok).toBe(true)
    expect(r.result).toBe(51)
  })

  test("SUB/DIV 操作数顺序:dst = src1 op src2,(v0-5)/3,v0=20", () => {
    const code = asm(
      { op: VM_OPCODES.CONST, regs: [1], imm: 5 },
      { op: VM_OPCODES.SUB, regs: [1, 0, 1] },
      { op: VM_OPCODES.CONST, regs: [2], imm: 3 },
      { op: VM_OPCODES.DIV, regs: [1, 1, 2] },
      { op: VM_OPCODES.RETURN, regs: [1] },
    )
    const r = executeVmLeaf(code, 20)
    expect(r.ok).toBe(true)
    expect(r.result).toBe(5)
  })

  test("除零如实失败(不兜底假值)", () => {
    const code = asm(
      { op: VM_OPCODES.CONST, regs: [1], imm: 0 },
      { op: VM_OPCODES.DIV, regs: [2, 0, 1] },
      { op: VM_OPCODES.RETURN, regs: [2] },
    )
    expect(executeVmLeaf(code, 42).ok).toBe(false)
  })

  test("fail-closed:未知操作码/无 return/寄存器越界/截断指令", () => {
    expect(executeVmLeaf(new Uint8Array([0x99, 0]), 1).ok).toBe(false) // 未知 op
    expect(executeVmLeaf(asm({ op: VM_OPCODES.CONST, regs: [1], imm: 1 }), 1).ok).toBe(false) // 无 return
    expect(executeVmLeaf(asm({ op: VM_OPCODES.CONST, regs: [16], imm: 1 }), 1).ok).toBe(false) // reg 越界
    expect(executeVmLeaf(new Uint8Array([VM_OPCODES.CONST, 1, 0]), 1).ok).toBe(false) // 截断
  })

  test("int32 回绕与 C 侧 int32_t 一致(Math.imul/截断加法)", () => {
    // v0=0x7FFFFFFF → ADD v0,v0,v1(v1=1)→ 回绕为负
    const code = asm(
      { op: VM_OPCODES.CONST, regs: [1], imm: 1 },
      { op: VM_OPCODES.ADD, regs: [2, 0, 1] },
      { op: VM_OPCODES.RETURN, regs: [2] },
    )
    const r = executeVmLeaf(code, 0x7fffffff)
    expect(r.ok).toBe(true)
    expect(r.result).toBe(-2147483648)
  })

  test("const/16 符号扩展:-1 装载后全 1", () => {
    const code = asm(
      { op: VM_OPCODES.CONST, regs: [1], imm: 0xffff }, // 符号扩展 → -1
      { op: VM_OPCODES.RETURN, regs: [1] },
    )
    const r = executeVmLeaf(code, 0)
    expect(r.ok).toBe(true)
    expect(r.result).toBe(-1)
  })
})

describe("C 执行端生成器(里程碑 A,寄存器式)", () => {
  test("操作码常量与 VM_OPCODES 严格一致(防两侧漂移)", () => {
    const c = generateVmInterpreterC()
    expect(c).toContain("#define DSVM_OP_CONST   0x02")
    expect(c).toContain("#define DSVM_OP_ADD     0x03")
    expect(c).toContain("#define DSVM_OP_SUB     0x04")
    expect(c).toContain("#define DSVM_OP_MUL     0x05")
    expect(c).toContain("#define DSVM_OP_DIV     0x06")
    expect(c).toContain("#define DSVM_OP_RETURN  0x1D")
    // fail-closed 语义齐备:未知操作码/除零/无 return/寄存器越界
    expect(c).toContain("DSVM_ERR_UNKNOWN_OP")
    expect(c).toContain("DSVM_ERR_DIVZERO")
    expect(c).toContain("DSVM_ERR_NO_RETURN")
  })

  test("寄存器机形态:16 寄存器 + v0 入参(与 TS 参考一致)", () => {
    const c = generateVmInterpreterC()
    expect(c).toContain("#define DSVM_REGS 16")
    expect(c).toContain("regs[0] = initial")
  })

  test("诚实边界声明:不含方法路由,注释明示 vmProtected=false", () => {
    const c = generateVmInterpreterC()
    expect(c).toContain("里程碑 B")
    expect(c).toContain("vmProtected=false")
  })
})
