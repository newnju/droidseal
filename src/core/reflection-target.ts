// 反射调用静态解析（⑥——完整版：Class.forName/getMethod/getField 的字符串目标提取）。
// 提取反射调用的静态目标（类名/方法名/字段名的字符串字面量）→ 清单级 finding，
// 提示反射降低静态可见性并供人工核验反射目标的调用安全性。失败关闭：未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface ReflectionTarget {
  line: number
  kind: "class" | "method" | "field"
  target: string
  snippet: string
}

// 反射目标提取：Class.forName("...") / getMethod("...") / getField("...") 的字符串字面量。
export function scanReflectionTargets(source: string): ReflectionTarget[] {
  const targets: ReflectionTarget[] = []
  const lines = source.split(/\r?\n/)
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    // 类目标:Class.forName("com.x.Y")
    const classMatch = /class\.forname\(\s*["']([A-Za-z0-9_.$]+)["']/i.exec(line)
    if (classMatch) {
      targets.push({ line: i + 1, kind: "class", target: classMatch[1]!, snippet: line.trim().slice(0, 100) })
      // 不 continue——同一行的 getMethod/getField 也要检查(单行形态)
    }
    // 方法目标:getMethod("m") / getDeclaredMethod("m")
    const methodMatch = /get(?:declared)?method\(\s*["']([A-Za-z0-9_$]+)["']/i.exec(line)
    if (methodMatch) {
      targets.push({ line: i + 1, kind: "method", target: methodMatch[1]!, snippet: line.trim().slice(0, 100) })
    }
    // 字段目标:getField("f") / getDeclaredField("f")
    const fieldMatch = /get(?:declared)?field\(\s*["']([A-Za-z0-9_$]+)["']/i.exec(line)
    if (fieldMatch) {
      targets.push({ line: i + 1, kind: "field", target: fieldMatch[1]!, snippet: line.trim().slice(0, 100) })
    }
  }
  return targets
}

// 扫描项目源码（失败关闭）。
export async function scanProjectReflectionTargets(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const targets = scanReflectionTargets(source)
    for (const target of targets.slice(0, 3)) {
      const key = `${target.kind}:${target.target}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "low",
        confidence: "high",
        code: "SOURCE_REFLECTION_TARGET",
        title: `反射调用的静态目标：${target.kind} ${target.target}`,
        detail: `${relative}:${target.line} 通过反射访问 ${target.kind}「${target.target}」——反射降低静态可见性，且目标可能被动态替换。`,
        recommendation: "核验反射目标的调用安全性；反射调用建议白名单限制并避免用户可控的类/方法名。",
        evidence: `${relative}:${target.line} ${target.snippet}`,
      })
    }
  }
  return findings
}
