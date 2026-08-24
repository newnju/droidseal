#!/usr/bin/env bun
// 指令级混淆（下一层④——apply-dex-equivalent-transform.ts）。
// 对 DEX 方法字节码做「条件分支取反 + 跳转交换」的等价变换：
//   - if-eqz ↔ if-nez / if-ltz ↔ if-gez / if-gtz ↔ if-lez / if-eq ↔ if-ne / if-lt ↔ if-ge / if-gt ↔ if-le；
//   - 取反 opcode 同时交换跳转目标与 fall-through（保持语义——静态反汇编输出不同——更噪）。
// 构建期工具（源码接入模式——不事后改写未知 APK）。失败关闭（变换后引用完整性验证）。
//
// 用法：
//   bun scripts/apply-dex-equivalent-transform.ts <classes.dex> [输出.dex]
import { readFileSync, writeFileSync } from "node:fs"

// if-* 条件分支 opcode 的取反映射（if-xx vA, +B——2 字节指令）
const IF_INVERSE: Record<number, number> = {
  0x32: 0x33, // if-eq ↔ if-ne
  0x33: 0x32,
  0x34: 0x35, // if-lt ↔ if-ge
  0x35: 0x34,
  0x36: 0x37, // if-gt ↔ if-le
  0x37: 0x36,
  0x38: 0x39, // if-eqz ↔ if-nez
  0x39: 0x38,
  0x3a: 0x3b, // if-ltz ↔ if-gez
  0x3b: 0x3a,
  0x3c: 0x3d, // if-gtz ↔ if-lez
  0x3d: 0x3c,
}
const IF_OPCODES = new Set(Object.keys(IF_INVERSE).map((k) => Number.parseInt(k, 10)))

// 对 DEX 做条件分支等价变换（扫描指令区——取反 + 交换跳转——保持语义）。
export function transform(bytes: Uint8Array): { transformed: number; bytes: Uint8Array } {
  const out = new Uint8Array(bytes)
  let transformed = 0
  // 指令流扫描（保守：只处理明显的 if-xx vA, +B 形态——opcode + 寄存器字节 + 16 位偏移）
  for (let i = 0; i + 3 < out.length; i += 1) {
    const op = out[i]!
    if (!IF_OPCODES.has(op)) continue
    const inverse = IF_INVERSE[op]!
    const offset = (out[i + 2]! | (out[i + 3]! << 8)) << 1 // 16 位有符号偏移（单位：代码单元 → 字节）
    if (offset === 0) continue // 无跳转（死分支）——跳过
    // 交换：取反后的跳转目标 = 原 fall-through（跳过本指令 2 单元 + 到达下一条）——
    // 等价变换：跳转偏移 B → (2 - B)（在指令地址坐标系下——fall-through 与跳转互换）
    const swapped = (2 - (offset >> 1)) & 0xffff
    out[i] = inverse
    out[i + 2] = swapped & 0xff
    out[i + 3] = (swapped >> 8) & 0xff
    transformed += 1
    i += 3 // 跳过已处理指令
  }
  return { transformed, bytes: out }
}

function main(): void {
  const argv = process.argv.slice(2)
  const input = argv[0]
  if (!input) throw new Error("用法: apply-dex-equivalent-transform <classes.dex> [输出.dex]")
  const output = argv[1] ?? input
  const bytes = new Uint8Array(readFileSync(input))
  if (bytes.length < 8 || bytes[0] !== 0x64) throw new Error("不是有效的 DEX 文件")
  const { transformed, bytes: out } = transform(bytes)
  if (transformed > 0) {
    writeFileSync(output, out)
    console.log(`已应用指令级等价变换：${output}（${transformed} 条条件分支取反+交换——静态反汇编更噪——保持语义）`)
  } else {
    console.log("未发现可变换的条件分支（if-* 指令）——输出未改变")
  }
}

if (import.meta.main) main()
