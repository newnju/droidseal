// 自动反混淆（（工具）——obfuscation-decode.ts）。
// 混淆代码的自动解码：检测 eval(atob(...))/atob(...) 编码层——解码后供审计匹配
// （js-audit 扫描前预处理）。失败关闭：无可解码的混淆形态即原样返回。
export interface DeobfuscationResult {
  decoded: string
  layers: number
}

// 解码混淆层（atob 的 base64 解码 + eval 包裹提取——最多 5 层——失败关闭）。
export function decodeObfuscated(source: string): DeobfuscationResult {
  let current = source
  let layers = 0
  for (let i = 0; i < 5; i += 1) {
    // 形态 1: eval(atob("...")) 或 atob("...") ——提取 base64 内容并解码
    const atobMatch = /(?:eval\s*\(\s*)?atob\(\s*["']([A-Za-z0-9+/=]+)["']\s*\)/.exec(current)
    if (atobMatch) {
      try {
        const decoded = Buffer.from(atobMatch[1]!, "base64").toString("utf8")
        if (!/[a-zA-Z]{4,}/.test(decoded)) break
        current = current.replace(atobMatch[0], `"${decoded.slice(0, 500)}"`)
        layers += 1
        continue
      } catch {
        break
      }
    }
    // 形态 2: 多层 atob(atob(...))——内层解码后重试
    const nestedAtob = /atob\(\s*["']([A-Za-z0-9+/=]{20,})["']\s*\)/.exec(current)
    if (nestedAtob) {
      try {
        const decoded = Buffer.from(nestedAtob[1]!, "base64").toString("utf8")
        current = current.replace(nestedAtob[0], `"${decoded.slice(0, 500)}"`)
        layers += 1
        continue
      } catch {
        break
      }
    }
    break
  }
  return { decoded: current, layers }
}
