// 任意 DEX 分析/修改 API（Androguard 差距②——dex-patch.ts）。
// 指令级修改：替换 invoke 指令的目标方法索引、const-string 的目标字符串索引——
// 供第三方 DEX 补丁（与 apply-method-obfuscation 的泛化形态）。失败关闭。
import { extractMethodCodes } from "./dex-instructions.ts"

export interface MethodOperandPatch {
  className: string
  methodName: string
  instructionOffset: number // 方法内指令偏移（字节）
  newMethodIndex: number    // invoke 目标方法索引（0x6e-0x78 指令 @+2 处）
}

export interface StringOperandPatch {
  className: string
  methodName: string
  instructionOffset: number
  newStringIndex: number // const-string 目标字符串索引（0x1a/0x1b @+2 处）
}

export type DexPatch = MethodOperandPatch | StringOperandPatch

export interface PatchResult {
  applied: number
  failed: number
  failures: string[]
}

// 应用补丁到 DEX 字节（方法定位 → 指令偏移 → 覆盖操作数字节）——失败关闭。
export function applyPatches(bytes: Uint8Array, patches: readonly DexPatch[]): PatchResult {
  const result: PatchResult = { applied: 0, failed: 0, failures: [] }
  const methods = extractMethodCodes(bytes)
  for (const patch of patches) {
    const method = methods.find(
      (m) => m.className === patch.className && m.methodName === patch.methodName && m.codeOff > 0,
    )
    if (!method) {
      result.failed += 1
      result.failures.push(`未找到方法 ${patch.className}.${patch.methodName}`)
      continue
    }
    const targetOffset = method.codeOff + 16 + patch.instructionOffset
    if (targetOffset + 2 >= bytes.length) {
      result.failed += 1
      result.failures.push(`偏移越界 ${patch.className}.${patch.methodName}@${patch.instructionOffset}`)
      continue
    }
    const opcode = bytes[targetOffset]!
    if ("newMethodIndex" in patch) {
      if (opcode < 0x6e || opcode > 0x78) {
        result.failed += 1
        result.failures.push(`非 invoke 指令 @${patch.instructionOffset}（opcode 0x${opcode.toString(16)}）`)
        continue
      }
      bytes[targetOffset + 1] = patch.newMethodIndex & 0xff
      bytes[targetOffset + 2] = (patch.newMethodIndex >> 8) & 0xff
    } else {
      if (opcode !== 0x1a && opcode !== 0x1b) {
        result.failed += 1
        result.failures.push(`非 const-string 指令 @${patch.instructionOffset}（opcode 0x${opcode.toString(16)}）`)
        continue
      }
      bytes[targetOffset + 1] = patch.newStringIndex & 0xff
      bytes[targetOffset + 2] = (patch.newStringIndex >> 8) & 0xff
    }
    result.applied += 1
  }
  return result
}
