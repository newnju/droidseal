// 类级对象模型（Androguard 差距⑤——dex-class-model.ts）。
// class_defs → 类→方法→指令 的对象树——供第三方编程遍历（与 IR 导出结合）。
// 失败关闭：无指令的方法仍保留（指令为空数组）。
import { extractMethodCodes, type DexInstruction } from "./dex-instructions.ts"

export interface ClassMethod {
  name: string
  instructionCount: number
  instructions: DexInstruction[]
}

export interface ClassModel {
  className: string
  methodCount: number
  methods: ClassMethod[]
}

// 构建类级对象模型（类 → 方法 → 指令 的对象树）。
export function buildClassModel(bytes: Uint8Array): ClassModel[] {
  const methods = extractMethodCodes(bytes)
  const byClass = new Map<string, ClassMethod[]>()
  for (const m of methods) {
    if (!byClass.has(m.className)) byClass.set(m.className, [])
    byClass.get(m.className)!.push({
      name: m.methodName,
      instructionCount: m.instructions.length,
      instructions: m.instructions,
    })
  }
  return [...byClass.entries()].map(([className, methods]) => ({ className, methodCount: methods.length, methods }))
}

// 查询类的方法（失败关闭——未找到返回空）。
export function classMethods(model: ClassModel[], className: string): ClassMethod[] {
  return model.find((c) => c.className === className)?.methods ?? []
}

// 查询方法的指令（失败关闭——未找到返回空）。
export function methodInstructions(model: ClassModel[], className: string, methodName: string): DexInstruction[] {
  return classMethods(model, className).find((m) => m.name === methodName)?.instructions ?? []
}
