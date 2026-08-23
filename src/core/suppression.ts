// suppression 注释忽略（Semgrep 差距⑦——suppression.ts）。
// 行级 `droidseal-ignore` 注释：忽略该行的源码发现（`droidseal-ignore` 全忽略或
// `droidseal-ignore: <CODE>` 指定代码忽略）。失败关闭：无注释不忽略。
export const IGNORE_MARKER = "droidseal-ignore"

// 行是否被忽略（任意代码）。
export function isIgnoredLine(line: string): boolean {
  return line.includes(IGNORE_MARKER)
}

// 行是否被忽略（指定代码——`droidseal-ignore: CODE` 精确匹配；无代码后缀则全忽略）。
export function isIgnoredFor(line: string, code: string): boolean {
  if (!line.includes(IGNORE_MARKER)) return false
  const match = new RegExp(`${IGNORE_MARKER}\\s*:\\s*([A-Z_]+)`).exec(line)
  if (!match) return true // 无代码后缀——全忽略
  return match[1] === code
}
