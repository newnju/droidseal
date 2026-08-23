// 集合/数组元素污点（⑫——完整版：put/get、add/get 容器元素传播）。
// 检测敏感源数据放入容器（HashMap.put / ArrayList.add）→ 取出（get）→ 汇使用。
// 同文件内变量级追踪（容器变量 + 元素）。失败关闭。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

const COLLECTION_SOURCES = ["getdeviceid(", "getimei(", "getsimserialnumber(", "getsubscriberid(", "getline1number(", "getstringextra(", "getqueryparameter(", "getsharedpreferences", "getlastknownlocation(", "getprimaryclip(", "getaccounts(", "getintent(", "getdata(", "getserial("]
const COLLECTION_SINKS = ["log.d(", "log.e(", "log.i(", "log.w(", "loadurl(", "execsql(", "sendtextmessage(", "startactivity(", "settext(", "openfileoutput(", "writeexternalstorage(", "runtime.exec(", "processbuilder("]

// 扫描单个文件：容器元素污点传播（put/add 敏感源 → get 取出 → 汇）——失败关闭。
export function scanCollectionTaint(source: string): Array<{ line: number; container: string; source: string; sink: string; snippet: string }> {
  const matches: Array<{ line: number; container: string; source: string; sink: string; snippet: string }> = []
  const lines = source.split(/\r?\n/)
  const taintedContainers = new Set<string>()
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!
    const lower = line.toLowerCase()
    // 容器放入敏感源:map.put(key, src) / list.add(src) / map["k"] = src
    const putMatch = /([A-Za-z_][A-Za-z0-9_]{2,})\.(?:put|add|set)\([^)]*/.exec(line)
    if (putMatch && COLLECTION_SOURCES.some((s) => lower.includes(s))) {
      taintedContainers.add(putMatch[1]!)
      continue
    }
    // 容器取出 + 汇:val = map.get(k) / list.get(i) → 后续行含 val + 汇
    const getMatch = /(?:^|\s)([A-Za-z_][A-Za-z0-9_]{2,})\s*=\s*[^;]*\.get\(/.exec(line)
    if (getMatch && taintedContainers.size > 0) {
      const varName = getMatch[1]!
      for (let j = i; j < lines.length && j < i + 10; j += 1) {
        const useLine = lines[j]!
        const useLower = useLine.toLowerCase()
        if (!useLine.includes(varName)) continue
        const sink = COLLECTION_SINKS.find((s) => useLower.includes(s))
        if (sink) {
          matches.push({ line: j + 1, container: getMatch[1]!, source: [...taintedContainers].join(","), sink, snippet: useLine.trim().slice(0, 120) })
          break
        }
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectCollectionTaint(projectRoot: string): Promise<Finding[]> {
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
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanCollectionTaint(source)
    const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
    for (const match of matches.slice(0, 2)) {
      findings.push({
        severity: "low",
        confidence: "low",
        code: "SOURCE_COLLECTION_TAINT",
        title: "敏感数据经容器（put/add → get）流入汇",
        detail: `${relative}:${match.line} 中容器 ${match.container} 的元素可能含敏感数据并流入 ${match.sink}（容器元素级启发式——需人工核验）。`,
        recommendation: "核对容器内数据的流向；敏感数据应避免经集合中转后写入日志/明文网络。",
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
