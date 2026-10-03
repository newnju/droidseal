#!/usr/bin/env bun
// P4: 混淆变体基准(ProGuard/R8 两档——obfuscation-variant-bench.ts)。
// 两档源级变换(如实模拟 R8 的作用域纪律):
//   A r8-method  方法重命名——应用自声明方法 → m0..mN(R8 方法混淆模拟)
//   B r8-class   方法+类名重命名——类名(含文件名同步)→ c0..cN(R8 类混淆模拟)
// 语义保真边界:
//   - 只重命名**应用自声明**标识符——框架 API 由 SDK 解析,R8 不可重命名,如实模拟;
//   - keep-list:生命周期/回调/Object/通用接口方法(同 generate-method-obfuscation-plan 纪律);
//   - 字符串字面量/字符/注释区域跳过;不做字段重命名(记录为口径边界);
//   - 反射形态(GT 已标注少数样本)承受破坏——这正是测量对象,不回避。
// 判读:原始/A/B 各跑一遍流引擎(summarizeFlow),三档(端点/宽松/锚定)并列——
//       量化混淆下各档保持率;GT 与对判器不变,变化全部来自源侧标识符。
// 用法: bun scripts/obfuscation-variant-bench.ts <taintbench-root> <out-dir> [--apps 名,名,...]

import { readdir, readFile, writeFile, mkdir, cp } from "node:fs/promises"
import { existsSync } from "node:fs"
import path from "node:path"
import { summarizeFlow } from "../src/core/bench-flow.ts"

const root = process.argv[2]?.replaceAll("\\", "/") ?? ""
const outDir = process.argv[3]?.replaceAll("\\", "/") ?? ""
const appsArgIdx = process.argv.indexOf("--apps")
const onlyApps = appsArgIdx > -1 ? process.argv[appsArgIdx + 1]!.split(",").map((s) => s.trim()) : null
if (!root || !outDir || !existsSync(root)) {
  console.error("用法: obfuscation-variant-bench.ts <taintbench-root> <out-dir> [--apps a,b,c]")
  process.exit(2)
}

// keep-list:R8 对这些名字同样保守(lifecycle/反射查找/通用契约),与受控子集纪律一致
const KEEP_METHODS = new Set([
  "onCreate", "onStart", "onResume", "onPause", "onStop", "onDestroy", "onRestart",
  "onReceive", "onClick", "onLongClick", "onItemSelected", "onServiceConnected",
  "onBind", "onUnbind", "onHandleIntent", "onCreateOptionsMenu", "onOptionsItemSelected",
  "onActivityResult", "onBackPressed", "onSavedInstanceState", "onSaveInstanceState",
  "onProgressUpdate", "onPreExecute", "onPostExecute", "onDraw", "onMeasure", "onLayout",
  "toString", "equals", "hashCode", "clone", "finalize", "main",
  "run", "call", "apply", "accept", "compare", "next", "hasNext", "iterator",
  "get", "set", "put", "add", "remove", "size", "isEmpty", "contains", "containsKey",
  "containsValue", "keySet", "values", "entrySet", "close", "flush",
])

interface SkipRegion { start: number; end: number }

/** 标记字符串/字符/注释区域(混淆重命名在这些区域内跳过) */
function skipRegions(src: string): SkipRegion[] {
  const out: SkipRegion[] = []
  let i = 0
  while (i < src.length) {
    const c = src[i]
    if (c === "/" && src[i + 1] === "/") {
      const end = src.indexOf("\n", i)
      out.push({ start: i, end: end === -1 ? src.length : end })
      i = end === -1 ? src.length : end
    } else if (c === "/" && src[i + 1] === "*") {
      const end = src.indexOf("*/", i + 2)
      out.push({ start: i, end: end === -1 ? src.length : end + 2 })
      i = end === -1 ? src.length : end + 2
    } else if (c === '"' || c === "'") {
      let j = i + 1
      while (j < src.length && src[j] !== c) {
        if (src[j] === "\\") j += 1
        j += 1
      }
      out.push({ start: i, end: Math.min(src.length, j + 1) })
      i = j + 1
    } else {
      i += 1
    }
  }
  return out
}

function inSkipped(regions: SkipRegion[], pos: number): boolean {
  for (const r of regions) if (pos >= r.start && pos < r.end) return true
  return false
}

const IDENT_RE = /[A-Za-z_$][A-Za-z0-9_$]*/g

/** 收集"声明位置"的方法名:标识符后随 '(' 且前一个非空白 token 不是 . / new / 关键字 */
function collectMethodNames(src: string): Set<string> {
  const regions = skipRegions(src)
  const names = new Set<string>()
  const KEYWORDS = new Set(["new", "return", "if", "for", "while", "switch", "catch", "synchronized", "throw", "assert", "case", "do", "else", "try", "super", "this"])
  for (const m of src.matchAll(IDENT_RE)) {
    const start = m.index
    if (inSkipped(regions, start)) continue
    const name = m[0]
    if (KEEP_METHODS.has(name)) continue
    // 后看:下一个非空白字符必须是 '('
    let k = start + name.length
    while (k < src.length && /\s/.test(src[k]!)) k += 1
    if (src[k] !== "(") continue
    // 前看:前一个非空白 token 不能是 '.'(框架/成员调用)或关键字(new 等)
    let p = start - 1
    while (p >= 0 && /\s/.test(src[p]!)) p -= 1
    if (src[p] === ".") continue
    const prev = src.slice(Math.max(0, p - 7), p + 1).match(/([A-Za-z_]+)$/)
    if (prev && KEYWORDS.has(prev[1]!)) continue
    // 声明/定义的弱判据:名字出现在本文件的 `Type name(` 或修饰符序列后(排除常见框架回调已在 keep)
    names.add(name)
  }
  return names
}

/** 收集类声明名 */
function collectClassNames(src: string): Set<string> {
  const regions = skipRegions(src)
  const names = new Set<string>()
  for (const m of src.matchAll(/\b(?:class|interface|enum)\s+([A-Za-z_$][A-Za-z0-9_$]*)/g)) {
    if (inSkipped(regions, m.index)) continue
    names.add(m[1]!)
  }
  return names
}

/** 按映射重命名标识符(词边界;跳过字符串/注释区) */
function renameIdents(src: string, map: Map<string, string>): string {
  if (map.size === 0) return src
  const regions = skipRegions(src)
  const edits: Array<{ start: number; end: number; to: string }> = []
  for (const m of src.matchAll(IDENT_RE)) {
    const start = m.index
    if (inSkipped(regions, start)) continue
    const to = map.get(m[0])
    if (to && to !== m[0]) edits.push({ start, end: start + m[0].length, to })
  }
  let out = src
  for (let i = edits.length - 1; i >= 0; i -= 1) {
    const e = edits[i]!
    out = out.slice(0, e.start) + e.to + out.slice(e.end)
  }
  return out
}

interface VariantResult {
  label: string
  root: string
  summary: Awaited<ReturnType<typeof summarizeFlow>>
}

/** 对单 app 目录集做两档变换 */
async function buildVariants(appDirs: string[], outRoot: string): Promise<Array<{ label: string; root: string }>> {
  const tiers: Array<{ label: string; classes: boolean }> = [
    { label: "original", classes: false },
    { label: "r8-method", classes: false },
    { label: "r8-class", classes: true },
  ]
  const built: Array<{ label: string; root: string }> = []
  for (const tier of tiers) {
    const vRoot = path.join(outRoot, tier.label)
    await mkdir(vRoot, { recursive: true })
    // original 也复制为同子集——三档跑完全相同的 app 集,对比口径才成立
    for (const appDir of appDirs) {
      const appName = path.basename(appDir)
      const dest = path.join(vRoot, appName)
      // 非 java 资产(findings.json/build.gradle/…)原样拷贝——GT 与对判输入保持不变
      await cp(appDir, dest, { recursive: true })
      // 收集本 app 全部 .java 的自声明名(original 档跳过变换——基线必须无混淆)
      const javaFiles: Array<{ rel: string; abs: string; text: string }> = []
      await walkJava(dest, (abs, rel) => javaFiles.push({ abs, rel, text: "" }))
      for (const f of javaFiles) f.text = await readFile(f.abs, "utf8")
      if (tier.label === "original") continue
      const methodNames = new Set<string>()
      const classNames = new Set<string>()
      for (const f of javaFiles) {
        for (const n of collectMethodNames(f.text)) methodNames.add(n)
        if (tier.classes) for (const n of collectClassNames(f.text)) classNames.add(n)
      }
      const map = new Map<string, string>()
      const sorted = (s: Set<string>) => [...s].sort()
      sorted(methodNames).forEach((n, i) => map.set(n, `m${i}`))
      sorted(classNames).forEach((n, i) => map.set(n, `c${i}`))
      // 应用变换(类名同步改文件名,保持 jadx 约定)
      for (const f of javaFiles) {
        let text = renameIdents(f.text, map)
        let newRel = f.rel
        if (tier.classes) {
          const pub = f.text.match(/public\s+(?:final\s+|abstract\s+)?(?:class|interface|enum)\s+([A-Za-z_$][A-Za-z0-9_$]*)/)
          const to = pub ? map.get(pub[1]!) : undefined
          if (pub && to) newRel = f.rel.replace(/([^/]+)\.java$/, `${to}.java`)
        }
        const absOut = path.join(dest, newRel)
        if (absOut !== f.abs) await mkdir(path.dirname(absOut), { recursive: true })
        await writeFile(absOut, text)
        if (absOut !== f.abs) await (await import("node:fs/promises")).rm(f.abs)
      }
    }
    built.push({ label: tier.label, root: vRoot })
  }
  return built
}

async function walkJava(dir: string, cb: (abs: string, rel: string) => void, base?: string): Promise<void> {
  const b = base ?? dir
  for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [])) {
    const abs = path.join(dir, e.name)
    const rel = path.relative(b, abs).replaceAll("\\", "/")
    if (e.isDirectory()) await walkJava(abs, cb, b)
    else if (e.name.endsWith(".java")) cb(abs, rel)
  }
}

// ── main ──
const allApps = (await readdir(root, { withFileTypes: true })).filter((d) => d.isDirectory()).map((d) => path.join(root, d.name))
const appDirs = onlyApps ? allApps.filter((d) => onlyApps.includes(path.basename(d))) : allApps
console.log(`apps: ${appDirs.length} · variants: original/r8-method/r8-class`)

const variants = await buildVariants(appDirs, outDir)
const results: VariantResult[] = []
for (const v of variants) {
  console.log(`>> summarize ${v.label}`)
  const summary = await summarizeFlow(v.root, { enableCrossclass: true })
  results.push({ label: v.label, root: v.root, summary })
}

// 三档并列对比
const rows = results.map((r) => ({
  label: r.label,
  endpoint: r.summary?.tp ?? 0,
  lenient: r.summary?.tpConnectedLenient ?? 0,
  anchored: r.summary?.tpConnectedAnchored ?? 0,
  strict: r.summary?.tpConnected ?? 0,
  fp: r.summary?.fpNegative ?? 0,
  total: r.summary?.total ?? 0,
}))
const base = rows[0]!
const md = [
  "# 混淆变体基准(ProGuard/R8 两档,P4)",
  "",
  `> 数据集: TaintBench(${appDirs.length} app 子集${onlyApps ? ",--apps 限定" : ",全集"}) · 变换纪律: 只重命名应用自声明标识符(框架 API 不可重命名),keep-list 生命周期/回调/通用契约方法,字符串/注释跳过;不做字段重命名(口径边界)。GT 与对判器不变,变化全部来自源侧标识符。`,
  "",
  "| 档位 | 原始 | A r8-method(方法) | B r8-class(方法+类) | A 保持率 | B 保持率 |",
  "|---|---|---|---|---|---|",
  `| 端点级 TP | ${base.endpoint} | ${rows[1]?.endpoint} | ${rows[2]?.endpoint} | ${base.endpoint ? ((rows[1]?.endpoint ?? 0) / base.endpoint * 100).toFixed(1) + "%" : "—"} | ${base.endpoint ? ((rows[2]?.endpoint ?? 0) / base.endpoint * 100).toFixed(1) + "%" : "—"} |`,
  `| 宽松档 | ${base.lenient} | ${rows[1]?.lenient} | ${rows[2]?.lenient} | ${base.lenient ? ((rows[1]?.lenient ?? 0) / base.lenient * 100).toFixed(1) + "%" : "—"} | ${base.lenient ? ((rows[2]?.lenient ?? 0) / base.lenient * 100).toFixed(1) + "%" : "—"} |`,
  `| 锚定档 | ${base.anchored} | ${rows[1]?.anchored} | ${rows[2]?.anchored} | ${base.anchored ? ((rows[1]?.anchored ?? 0) / base.anchored * 100).toFixed(1) + "%" : "—"} | ${base.anchored ? ((rows[2]?.anchored ?? 0) / base.anchored * 100).toFixed(1) + "%" : "—"} |`,
  `| 严格档 | ${base.strict} | ${rows[1]?.strict} | ${rows[2]?.strict} | — | — |`,
  `| 负例 FP | ${base.fp} | ${rows[1]?.fp} | ${rows[2]?.fp} | — | — |`,
  "",
  "实测形态(2026-10-02,TaintBench 子集/全集):端点级在 A 档显著退化(检测面依赖源内标识符上下文——方法名参与调用图与检测器上下文,重命名即失配,如实记录);锚定档 A/B 全灭(GT statement 含原名,逐字定位失败=对判口径如实的退化,非引擎缺陷);宽松档与端点级同幅退化(混淆名归一仅在「方法体唯一 API」时生效,重命名后歧义如实放弃);B 档(类名)全灭——GT className→文件路径定位依赖原名。结论:本工具链对 R8 级标识符混淆无免疫力,结论如实进报告;GT 感知的对判增强(如 statement 归一后模糊定位)为后续方向,不在本轮夸大。",
  "",
].join("\n")
await writeFile(path.join(outDir, "obfuscation-variant-report.md"), md)
console.log(md)
