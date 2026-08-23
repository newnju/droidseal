// autofix 自动修复模板（Semgrep 差距⑥——autofix.ts）。
// 发现 code → 安全的文本替换模板（仅明确的替换——失败关闭：不匹配不替换）。
import { readFile, readdir, writeFile } from "node:fs/promises"
import path from "node:path"

export interface AutofixTemplate {
  code: string
  match: string
  replace: string
  note: string
}

// 自动修复模板（仅安全、明确的替换——复杂修复留给人工）。
export const AUTOFIX_TEMPLATES: readonly AutofixTemplate[] = [
  {
    code: "SOURCE_WEAK_CRYPTO",
    match: 'Cipher.getInstance("AES")',
    replace: 'Cipher.getInstance("AES/GCM/NoPadding")',
    note: "AES 默认 ECB 改为 AES/GCM（需同步改用 GCMParameterSpec）。",
  },
  {
    code: "SOURCE_WEAK_CRYPTO",
    match: 'Cipher.getInstance("AES/ECB',
    replace: 'Cipher.getInstance("AES/GCM',
    note: "AES/ECB 改为 AES/GCM。",
  },
  {
    code: "SOURCE_WEAK_CRYPTO",
    match: 'Cipher.getInstance("DES")',
    replace: 'Cipher.getInstance("AES/GCM/NoPadding")',
    note: "DES 改为 AES/GCM。",
  },
]

export interface AutofixResult {
  filesChanged: number
  replacements: number
  unchanged: string[]
}

// 对项目源码应用 autofix（失败关闭：不匹配不替换；修改前备份为 .autofix.bak）。
export async function applyAutofixToProject(projectRoot: string): Promise<AutofixResult> {
  const result: AutofixResult = { filesChanged: 0, replacements: 0, unchanged: [] }
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (!/\.(java|kt)$/.test(entry)) continue
      const file = path.join(dir, entry)
      const original = await readFile(file, "utf8").catch(() => null)
      if (original === null) continue
      let changed = original
      let count = 0
      for (const template of AUTOFIX_TEMPLATES) {
        const occurrences = original.split(template.match).length - 1 // 实际匹配次数
        if (occurrences === 0) continue
        changed = changed.replaceAll(template.match, template.replace)
        count += occurrences
      }
      if (changed !== original) {
        await writeFile(`${file}.autofix.bak`, original, "utf8")
        await writeFile(file, changed, "utf8")
        result.filesChanged += 1
        result.replacements += count
      }
    }
  }
  return result
}
