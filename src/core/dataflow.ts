// DroidSeal TS 数据流引擎(与 Rust 版 dataflow.rs 同口径):
// 过程内 analyze + 跨方法 summary(analyzeInterproc)+ 跨类联合(analyzeCrossclass)。
// 供 bench-flow 流级对判使用;规则表与 Rust SOURCES/SINKS 保持一致。

export interface TaintFlow { source_line: number; sink_line: number; src_api: string; sink_api: string }
export interface CrossClassFlow { source_line: number; sink_line: number; src_api: string; sink_api: string; src_class: string; sink_class: string }

export const SOURCES: Array<[RegExp, string]> = [
  [/getDeviceId\(/, "getDeviceId"],
  [/getSubscriberId\(/, "getSubscriberId"],
  [/getImei\(/, "getImei"],
  [/getSimSerialNumber\(/, "getSimSerialNumber"],
  [/getLine1Number\(/, "getLine1Number"],
  [/getLastKnownLocation\(/, "getLastKnownLocation"],
  [/requestLocationUpdates\(/, "requestLocationUpdates"],
  [/getLatitude\(/, "getLatitude"],
  [/getLongitude\(/, "getLongitude"],
  [/getAccounts\(/, "getAccounts"],
  [/getInstalledPackages\(/, "getInstalledPackages"],
  [/getInstalledApplications\(/, "getInstalledApplications"],
  [/getPackageManager\(\)\.getPackageInfo\(/, "getPackageInfo"],
  [/SMSMessage\.createFromPdu\(/, "createFromPdu"],
  [/getDeviceId\(\)|getImei\(\)/, "getDeviceId"],
  [/getInputStream\(\)/, "getInputStream"],
  [/connection\.getInputStream/, "getInputStream"],
  [/openConnection\(\)/, "openConnection"],
  [/execQuery\(/, "execQuery"],
  [/rawQuery\(/, "rawQuery"],
  [/query\(/, "query"],
  // 2026-09-19 GT 全量差集补齐(39 app / 249 流重提取,与 Rust taint.rs 同步)
  [/openFileInput\(/, "openFileInput"],
  [/getInt\(/, "getInt"],
  [/getLong\(/, "getLong"],
  [/getSystemService\(/, "getSystemService"],
  [/managedQuery\(/, "managedQuery"],
  [/getContent\(/, "getContent"],
  [/getNetworkOperatorName\(/, "getNetworkOperatorName"],
  [/getDisplayOriginatingAddress\(/, "getDisplayOriginatingAddress"],
  [/openStream\(/, "openStream"],
  [/getExternalStorageDirectory\(/, "getExternalStorageDirectory"],
]
export const SINKS: Array<[RegExp, string]> = [
  [/Log\.[deiwv]\(/, "Log.d"],
  [/sendTextMessage\(/, "sendTextMessage"],
  [/sendMultipartTextMessage\(/, "sendMultipartTextMessage"],
  [/openConnection\(\)/, "openConnection"],
  [/getOutputStream\(\)/, "getOutputStream"],
  [/execute\(/, "execute"],
  [/addJavascriptInterface\(/, "addJavascriptInterface"],
  [/insert\(/, "insert"],
  [/update\(/, "update"],
  [/delete\(/, "delete"],
  [/execSQL\(/, "execSQL"],
  [/startActivity\(/, "startActivity"],
  [/setComponentEnabledSetting\(/, "setComponentEnabledSetting"],
  [/SMSMessage/, "SMSMessage"],
  // 2026-09-19 GT 全量差集补齐(与 Rust taint.rs 同步;GT "i" 混淆名不收,如实放弃)
  [/\.append\(/, "append"],
  [/\.invoke\(/, "invoke"], // SINK_REFLECT_INVOKE(与 Rust taint.rs 同步)
  [/writeUTF\(/, "writeUTF"],
  [/\.exchange\(/, "exchange"],
  [/\.connect\(/, "connect"],
  [/sendMessage\(/, "sendMessage"],
  [/writeBytes\(/, "writeBytes"],
  [/\.submit\(/, "submit"],
  [/println\(/, "println"],
  [/RestTemplate/, "RestTemplate"],
  [/\.call\(/, "call"],
]

const SANITIZERS = [/encrypt\(/, /decrypt\(/, /hash\(/, /md5\(/, /sha1\(/, /sha256\(/, /Base64\.encode\(/, /URLEncoder\.encode\(/, /clean\(/, /sanitize\(/, /validate\(/]

function sourceApi(line: string): string | null {
  for (const [re, name] of SOURCES) if (re.test(line)) return name
  return null
}
function sinkApi(line: string): string | null {
  for (const [re, name] of SINKS) if (re.test(line)) return name
  return null
}
function sanitizerHit(line: string): boolean {
  return SANITIZERS.some(re => re.test(line))
}
function stripStrings(line: string): string {
  return line.replace(/"(?:\\.|[^"\\])*"/g, '""')
}
function lhsOf(line: string): string | null {
  // \b 词边界防回退劈词:无类型声明的赋值("data = ..."/"this.data = ...")
  // 此前会被贪婪前缀劈成 dat+a,取错 LHS——字段媒介流因此断链(引擎级 bug)。
  const m = line.match(/^\s*[\w.$[\]]*\s*(?:this\.)?\b([A-Za-z_$][\w$]*)\s*=(?!=)/)
  return m ? (m[1] ?? null) : null
}
function rhsVars(line: string): string[] {
  const eq = line.indexOf("=")
  if (eq < 0) return []
  const rhs = line.slice(eq + 1)
  return [...rhs.matchAll(/[A-Za-z_$][\w$]*/g)].map(m => m[0]).filter(v => !["new", "null", "true", "false", "this"].includes(v))
}

// P1-c: 单层字段访问(对象不敏感保守口径)——x.f 作为独立 env 键传播。
// 动机:局部对象字段媒介(h.data = 污点 → send(h.data))此前被按整词劈开
// (rhsVars 只出 h/data 两个裸名),字段键丢失 → 流断链。单层足矣:GT 语料中
// 嵌套字段(x.f.g)占比极低,如实不做通用 access path。
// 字段写:赋值行左侧以 x.f 结尾(排除裸变量/声明;this.data 归一为 "this.data" 键)。
function fieldAssign(clean: string): [string, string] | null {
  const eq = clean.search(/=(?!=)/)
  if (eq < 0) return null
  const left = clean.slice(0, eq).trim()
  const m = left.match(/([A-Za-z_$][\w$]*)\.([A-Za-z_$][\w$]*)$/)
  return m ? [m[1]!, m[2]!] : null
}
// 字段读:ident.ident 且非方法调用(后随 "(" 视为调用,跳过)。
function fieldReads(clean: string): Array<[string, string]> {
  const out: Array<[string, string]> = []
  for (const m of clean.matchAll(/([A-Za-z_$][\w$]*)\.\s*([A-Za-z_$][\w$]*)/g)) {
    const after = clean.slice((m.index ?? 0) + m[0].length)
    if (/^\s*\(/.test(after)) continue
    out.push([m[1]!, m[2]!])
  }
  return out
}
function varsInCall(line: string): string[] {
  return [...line.matchAll(/[A-Za-z_$][\w$]*/g)].map(m => m[0]).filter(v => !["new", "null", "true", "false", "this", "Log"].includes(v))
}

interface ValInfo { params: Set<number>; srcs: Set<number> }
function emptyVal(): ValInfo { return { params: new Set(), srcs: new Set() } }
function mergeVal(a: ValInfo, b: ValInfo): void { for (const p of b.params) a.params.add(p); for (const s of b.srcs) a.srcs.add(s) }
function isEmptyVal(a: ValInfo): boolean { return a.params.size === 0 && a.srcs.size === 0 }

interface Meth { name: string; cls: string; body: number[]; paramNames: string[] }
interface Sum {
  retParams: Set<number>; retSrcs: Set<number>
  fieldsFrom: Map<string, Set<number>>; fieldsSrcs: Map<string, Set<number>>
  sinks: Array<{ line: number; api: string; info: ValInfo }>
  calls: Array<{ callee: string; args: ValInfo[] }>
  // 框架回调捕获通道:(回调方法名, 回调体内引用的变量名, 来源行集)——与 Rust Sum.captures 同语义
  captures: Array<[string, string, Set<number>]>
  // ICC 常量键登记:putExtra("k", 污点) 的 (键, 来源行集)——与 Rust Sum.intent_keys 同语义
  intentKeys: Array<[string, Set<number>]>
}

// 框架回调分派表:调用形态 → 回调方法名(与 Rust framework_dispatch 同表)
const DISPATCH_TABLE: Array<[string, string]> = [
  [".post(", "run"], [".postDelayed(", "run"], [".postAtTime(", "run"],
  [".runOnUiThread(", "run"], [".execute(", "run"], [".start(", "run"], [".schedule(", "run"],
  // 接口型回调(P2-4,与 Rust framework_dispatch 同表):注册点实参对象 → 对应回调方法
  [".setOnClickListener(", "onClick"], [".setOnLongClickListener(", "onLongClick"],
  [".setOnItemClickListener(", "onItemClick"], [".setOnItemSelectedListener(", "onItemSelected"],
  [".setOnCheckedChangeListener(", "onCheckedChanged"], [".setOnMenuItemClickListener(", "onMenuItemClick"],
  [".setOnEditorActionListener(", "onEditorAction"],
]
function frameworkDispatch(clean: string): string | null {
  for (const [pat, cb] of DISPATCH_TABLE) if (clean.includes(pat)) return cb
  return null
}

// 字符串字面量提取(ICC/反射常量用;须用原始行,clean 已抹字面量)
function stringLiteralAt(s: string, from: number): string | null {
  const rest = s.slice(Math.min(from, s.length))
  const start = rest.indexOf('"')
  if (start < 0) return null
  const after = rest.slice(start + 1)
  const end = after.indexOf('"')
  if (end < 0) return null
  return after.slice(0, end) || null
}

// 反射常量目标:getMethod("x")/getDeclaredMethod("x") → "x"(仅常量实参,变量如实放弃)
function findReflectTarget(l: string): string | null {
  let from = 0
  for (;;) {
    const rel = l.slice(from).indexOf('getMethod("')
    if (rel < 0) return null
    const start = from + rel + 'getMethod("'.length
    const end = l.indexOf('"', start)
    if (end < 0) return null
    const name = l.slice(start, end)
    if (name && /^[\w$]+$/.test(name)) return name
    from = start
  }
}

function extractMethods(lines: string[], cls: string): Meth[] {
  const starts: Array<{ i: number; name: string; params: string[] }> = []
  lines.forEach((l, i) => {
    const t = l.trimStart()
    if (!/^((public|private|protected)\s)/.test(t) || !t.includes("(")) return
    const op = t.indexOf("(")
    const name = t.slice(0, op).split(/\s+/).pop() ?? ""
    if (!name) return
    const close = t.lastIndexOf(")")
    const params = t.slice(op + 1, close < 0 ? t.length : close).split(",")
      .map(p => p.trim().split(/\s+/).pop()?.replace(/^final\s+/, "") ?? "")
      .filter(p => p && p !== ")")
    starts.push({ i, name, params })
  })
  if (starts.length === 0) return [{ name: "__file__", cls, body: lines.map((_, i) => i), paramNames: [] }]
  return starts.map((s, k) => ({
    name: s.name, cls,
    body: Array.from({ length: (starts[k + 1]?.i ?? lines.length) - s.i - 1 }, (_, j) => s.i + 1 + j),
    paramNames: s.params,
  }))
}

/** 回调注册解析(P2-2):匿名内部类(new Xxx() { ... })方法并入宿主类方法表,与 Rust expand_anonymous_methods 同口径。 */
function expandAnonymousMethods(meths: Meth[], lines: string[], cls: string): void {
  let i = 0
  while (i < lines.length) {
    const t = (lines[i] ?? "").trimStart()
    if (t.startsWith("new ") && t.includes("{")) {
      let depth = 0
      let bodyStart = i
      let j = i
      while (j < lines.length) {
        const clean = stripStrings(lines[j] ?? "")
        for (const c of clean) {
          if (c === "{") { depth++; if (depth === 1) bodyStart = j + 1 }
          else if (c === "}") depth--
        }
        if (depth === 0 && j > i) break
        j++
      }
      if (bodyStart < j) {
        const sub = lines.slice(bodyStart, j)
        const inner: Array<{ i: number; name: string; params: string[] }> = []
        sub.forEach((l, k) => {
          const tt = l.trimStart()
          if (!/^((public|private|protected)\s)/.test(tt) || !tt.includes("(")) return
          const op = tt.indexOf("(")
          const name = tt.slice(0, op).split(/\s+/).pop() ?? ""
          if (!name) return
          const close = tt.lastIndexOf(")")
          const params = tt.slice(op + 1, close < 0 ? tt.length : close).split(",")
            .map(p => p.trim().split(/\s+/).pop()?.replace(/^final\s+/, "") ?? "")
            .filter(p => p && p !== ")")
          inner.push({ i: k, name, params })
        })
        inner.forEach((s, k) => {
          const end = inner[k + 1]?.i ?? sub.length
          meths.push({ name: s.name, cls, body: Array.from({ length: end - s.i - 1 }, (_, x) => bodyStart + s.i + 1 + x), paramNames: s.params })
        })
      }
      i = Math.max(j, i + 1)
    } else {
      i++
    }
  }
}

function splitArgs(s: string): string[] {
  const out: string[] = []
  let depth = 0, cur = ""
  for (const c of s) {
    if (c === "(") depth++
    if (c === ")") depth--
    if (c === "," && depth === 0) { out.push(cur); cur = ""; continue }
    cur += c
  }
  if (cur.trim()) out.push(cur)
  return out
}

function resolveCall(clean: string, lineno: number, has: (n: string) => boolean, env: Map<string, ValInfo>): { callee: string; args: ValInfo[] } | null {
  const re = /([A-Za-z_$][\w$]*)\s*\(/g
  let m: RegExpExecArray | null
  while ((m = re.exec(clean))) {
    const id = m[1]
    if (!id || !has(id)) continue
    const argsStr = clean.slice(m.index + m[0].length)
    const args = splitArgs(argsStr).map(a => {
      const info = emptyVal()
      for (const v of varsInCall(a)) { const e = env.get(v); if (e) mergeVal(info, e) }
      if (sourceApi(a)) info.srcs.add(lineno)
      return info
    })
    return { callee: id!, args }
  }
  return null
}

function summarize(m: Meth, lines: string[], has: (n: string) => boolean): Sum {
  const sum: Sum = { retParams: new Set(), retSrcs: new Set(), fieldsFrom: new Map(), fieldsSrcs: new Map(), sinks: [], calls: [], captures: [], intentKeys: [] }
  const env = new Map<string, ValInfo>()
  // 反射常量目标 + ICC 常量键(与 Rust summarize_pred 同款)
  const reflect = new Map<string, string>()
  const intentKeys: Array<[string, Set<number>]> = []
  m.paramNames.forEach((p, i) => { const v = emptyVal(); v.params.add(i); env.set(p, v) })
  for (const li of m.body) {
    const l = (lines[li] ?? "").trim()
    if (!l || l.startsWith("//") || l.startsWith("*") || l.startsWith("/*")) continue
    const clean = stripStrings(l.replace(/(^|\s)final\s+/g, " "))
    if (sanitizerHit(clean)) { const lhs = lhsOf(clean); if (lhs) env.delete(lhs); continue }
    if (clean.includes("getMethod(")) {
      const lhs = lhsOf(clean)
      const target = findReflectTarget(l)
      if (lhs && target) reflect.set(lhs, target)
    }
    // 反射 invoke:m.invoke(obj, args...) → 隐式边指向登记目标(仅常量名且存在)
    if (clean.includes(".invoke(")) {
      let target: string | null = null
      for (const [mv, t] of reflect) { if (clean.includes(`${mv}.invoke(`)) { target = t; break } }
      if (target && has(target)) {
        const ipos = clean.indexOf(".invoke(")
        const argsStr = clean.slice(ipos + 8)
        const args = splitArgs(argsStr).slice(1).map(a => {
          const info = emptyVal()
          for (const v of varsInCall(a)) { const e = env.get(v); if (e) mergeVal(info, e) }
          if (sourceApi(a)) info.srcs.add(li + 1)
          return info
        })
        sum.calls.push({ callee: target, args })
        continue
      }
    }
    // ICC 常量键:putExtra("k", 污点) 登记(字面量/偏移以原始行为准)
    const ppos = l.indexOf("putExtra(")
    if (ppos >= 0) {
      const key = stringLiteralAt(l, ppos + 9)
      if (key) {
        const argsStr = clean.slice(ppos + 9)
        const srcs = new Set<number>()
        for (const a of splitArgs(argsStr).slice(1)) {
          for (const v of varsInCall(a)) { const e = env.get(v); if (e) for (const s of e.srcs) srcs.add(s) }
          if (sourceApi(a)) srcs.add(li + 1)
        }
        if (srcs.size) intentKeys.push([key, srcs])
        continue // putExtra 不是 sink
      }
    }
    // getXxxExtra("k") 消费(getter 名从 clean 取,键从原始行取)
    const eposC = clean.indexOf("Extra(")
    if (eposC >= 0) {
      const getter = clean.slice(0, eposC).split(".").pop() ?? ""
      if (getter.startsWith("get")) {
        const eposL = l.indexOf("Extra(")
        const key = eposL >= 0 ? stringLiteralAt(l, eposL + 6) : null
        if (key) {
          const srcs = new Set<number>()
          for (const [k, s] of intentKeys) { if (k === key) for (const x of s) srcs.add(x) }
          if (srcs.size) { const lhs = lhsOf(clean); if (lhs) { const e = env.get(lhs) ?? emptyVal(); for (const x of srcs) e.srcs.add(x); env.set(lhs, e) } }
          continue // getXxxExtra 不是 source
        }
      }
    }
    // 框架回调分派:resolveCall 未命中时,xxx.post(r)/t.start() → 隐式边指向 run()
    if (!resolveCall(clean, li + 1, has, env)) {
      const cb = frameworkDispatch(clean)
      if (cb && has(cb)) {
        const argsStr = clean.slice(clean.indexOf("(") + 1)
        const args = splitArgs(argsStr).map(a => {
          const info = emptyVal()
          for (const v of varsInCall(a)) { const e = env.get(v); if (e) mergeVal(info, e) }
          if (sourceApi(a)) info.srcs.add(li + 1)
          return info
        })
        // 污点实参归位:仅保留分派位次(与 Rust 同);全空时按名字记录捕获
        const pos = 0
        const chosen = args[pos] ?? emptyVal()
        for (let k = 0; k < args.length; k++) args[k] = emptyVal()
        if (pos < args.length) args[pos] = chosen
        if (args.every(a => isEmptyVal(a))) {
          const capSrcs = new Set<number>()
          const capNames: string[] = []
          for (const [vn, e] of env) { if (!isEmptyVal(e)) { for (const s of e.srcs) capSrcs.add(s); capNames.push(vn) } }
          for (const cn of capNames) sum.captures.push([cb, cn, new Set(capSrcs)])
        }
        sum.calls.push({ callee: cb, args })
        continue
      }
    }
    if (clean.trimStart().startsWith("return ")) {
      const expr = clean.trimStart().slice(6).trim()
      const info = emptyVal()
      for (const v of varsInCall(expr)) { const e = env.get(v); if (e) mergeVal(info, e) }
      if (sourceApi(expr)) info.srcs.add(li + 1)
      for (const p of info.params) sum.retParams.add(p)
      for (const s of info.srcs) sum.retSrcs.add(s)
      continue
    }
    if (sourceApi(clean)) {
      const lhs = lhsOf(clean)
      if (lhs) { const v = env.get(lhs) ?? emptyVal(); v.srcs.add(li + 1); env.set(lhs, v); continue }
    }
    const sapi = sinkApi(clean)
    if (sapi) {
      const refs = rhsVars(clean)
      const used = refs.length ? refs : varsInCall(clean)
      const info = emptyVal()
      for (const v of used) { const e = env.get(v); if (e) mergeVal(info, e) }
      if (!isEmptyVal(info)) sum.sinks.push({ line: li + 1, api: sapi, info })
      continue
    }
    const call = resolveCall(clean, li + 1, has, env)
    if (call) {
      const merged = emptyVal()
      for (const a of call.args) mergeVal(merged, a)
      sum.calls.push(call)
      const lhs = lhsOf(clean)
      if (lhs) { if (!isEmptyVal(merged)) env.set(lhs, merged); else env.delete(lhs) }
      continue
    }
    const lhs = lhsOf(clean)
    if (lhs) {
      const refs = rhsVars(clean)
      const info = emptyVal()
      for (const v of refs) { const e = env.get(v); if (e) mergeVal(info, e) }
      const key = clean.includes(`this.${lhs}`) ? `this.${lhs}` : lhs
      if (isEmptyVal(info) && refs.length) env.delete(key)
      else if (!isEmptyVal(info)) {
        if (key.startsWith("this.")) {
          const fs = sum.fieldsFrom.get(key) ?? new Set<number>(); for (const p of info.params) fs.add(p); sum.fieldsFrom.set(key, fs)
          const ss = sum.fieldsSrcs.get(key) ?? new Set<number>(); for (const s of info.srcs) ss.add(s); sum.fieldsSrcs.set(key, ss)
        }
        env.set(key, info)
      }
    }
  }
  sum.intentKeys = intentKeys
  return sum
}

/** 过程内 + 跨方法(单文件)分析,与 Rust analyze+analyze_interproc 合并语义一致。 */
export function analyzeInterproc(content: string): TaintFlow[] {
  const lines = content.split("\n")
  const methsAll = extractMethods(lines, "__file__")
  // 回调注册解析(P2-2):匿名内部类方法并入宿主类(与 Rust 同口径)
  expandAnonymousMethods(methsAll, lines, "__file__")
  const meths = methsAll.filter(m => m.name !== "__file__")
  if (meths.length === 0) return []
  const names = new Set(meths.map(m => m.name))
  const sums = new Map<string, Sum>()
  for (const m of meths) sums.set(m.name, summarize(m, lines, n => names.has(n)))
  const entry = new Map<string, Map<number, Set<number>>>()
  for (let round = 0; round < 3; round++) {
    const delta = new Map<string, Map<number, Set<number>>>()
    for (const m of meths) {
      const s = sums.get(m.name); if (!s) continue
      const ent = entry.get(m.name)
      for (const { callee, args } of s.calls) {
        for (let j = 0; j < args.length; j++) {
          const arg = args[j]!
          const add = new Set(arg.srcs)
          if (ent) for (const p of arg.params) for (const st of ent.get(p) ?? []) add.add(st)
          if (add.size) {
            const dm = delta.get(callee) ?? new Map(); delta.set(callee, dm)
            const ds = dm.get(j) ?? new Set(); dm.set(j, ds)
            for (const x of add) ds.add(x)
          }
        }
      }
    }
    let changed = false
    for (const [mn, ps] of delta) {
      for (const [i, st] of ps) {
        const em = entry.get(mn) ?? new Map(); entry.set(mn, em)
        const e = em.get(i) ?? new Set(); em.set(i, e)
        const before = e.size
        for (const x of st) e.add(x)
        changed ||= e.size !== before
      }
    }
    if (!changed) break
  }
  const flows: TaintFlow[] = []
  const seen = new Set<string>()
  const push = (src: number, snk: number, sapi: string) => {
    const key = `${src}->${snk}:${sapi}`
    if (seen.has(key)) return
    seen.add(key)
    const line = lines[src - 1] ?? ""
    const hit = [...SOURCES].reverse().find(([re]) => re.test(line))
    flows.push({ source_line: src, sink_line: snk, src_api: hit ? hit[1] : "", sink_api: sapi })
  }
  for (const m of meths) {
    const s = sums.get(m.name); if (!s) continue
    const env = new Map<string, ValInfo>()
    m.paramNames.forEach((p, i) => {
      const info = emptyVal(); info.params.add(i)
      const st = entry.get(m.name)?.get(i)
      if (st) info.srcs = new Set(st)
      if (!isEmptyVal(info)) env.set(p, info)
    })
    // 框架回调捕获播种:本方法被分派为回调时,按名字注入宿主捕获污点(与 Rust 终扫同款)
    for (const cs of sums.values()) {
      for (const [cb, vn, srcs] of cs.captures) {
        if (cb === m.name && srcs.size) {
          const e = env.get(vn) ?? emptyVal()
          for (const x of srcs) e.srcs.add(x)
          env.set(vn, e)
        }
      }
    }
    // ICC 常量键(终扫):消费摘要侧登记 + 行内配对(与 Rust 终扫同款)
    const intentKeysScan: Array<[string, Set<number>]> = s.intentKeys.map(([k, v]) => [k, new Set(v)])
    for (const li of m.body) {
      const l = (lines[li] ?? "").trim()
      if (!l || l.startsWith("//") || l.startsWith("*") || l.startsWith("/*")) continue
      const clean = stripStrings(l)
      const lineno = li + 1
      if (sanitizerHit(clean)) { const lhs = lhsOf(clean); if (lhs) env.delete(lhs); continue }
      const pposL = l.indexOf("putExtra(")
      if (pposL >= 0) {
        const key = stringLiteralAt(l, pposL + 9)
        if (key) {
          const argsStr = clean.slice(pposL + 9)
          const srcs = new Set<number>()
          for (const a of splitArgs(argsStr).slice(1)) {
            for (const v of varsInCall(a)) { const e = env.get(v.replace(/^this\./, "")); if (e) for (const x of e.srcs) srcs.add(x) }
          }
          if (srcs.size) intentKeysScan.push([key, srcs])
          continue // putExtra 行不是 sink
        }
      }
      const eposC = clean.indexOf("Extra(")
      if (eposC >= 0) {
        const getter = clean.slice(0, eposC).split(".").pop() ?? ""
        if (getter.startsWith("get")) {
          const eposL = l.indexOf("Extra(")
          const key = eposL >= 0 ? stringLiteralAt(l, eposL + 6) : null
          if (key) {
            const srcs = new Set<number>()
            for (const [k, sv] of intentKeysScan) { if (k === key) for (const x of sv) srcs.add(x) }
            if (srcs.size) { const lhs = lhsOf(clean); if (lhs) { const e = env.get(lhs) ?? emptyVal(); for (const x of srcs) e.srcs.add(x); env.set(lhs, e) } }
            continue // getXxxExtra 行不是 source
          }
        }
      }
      if (sourceApi(clean)) { const lhs = lhsOf(clean); if (lhs) { const v = env.get(lhs) ?? emptyVal(); v.srcs.add(lineno); env.set(lhs, v); continue } }
      const sapi = sinkApi(clean)
      if (sapi) {
        const refs = rhsVars(clean)
        const used = refs.length ? refs : varsInCall(clean)
        const info = emptyVal()
        for (const v of used) { const e = env.get(v.replace(/^this\./, "")); if (e) mergeVal(info, e) }
        for (const src of info.srcs) push(src, lineno, sapi)
        continue
      }
      const call = resolveCall(clean, lineno, n => names.has(n), env)
      if (call) {
        const cs = sums.get(call.callee)
        if (cs) {
          for (const { line: sl, api: sapi, info: sinfo } of cs.sinks) {
            for (const p of sinfo.params) {
              const a = call.args[p]
              if (a) for (const src of a.srcs) push(src, sl, sapi)
            }
          }
        }
        const lhs = lhsOf(clean)
        if (lhs && cs) {
          const info = emptyVal()
          for (const s2 of cs.retSrcs) info.srcs.add(s2)
          for (const i of cs.retParams) { const a = call.args[i]; if (a) for (const s2 of a.srcs) info.srcs.add(s2) }
          if (!isEmptyVal(info)) env.set(lhs, info); else env.delete(lhs)
        }
        if (cs) {
          for (const [f, pidxs] of cs.fieldsFrom) {
            const info = emptyVal()
            for (const i of pidxs) { const a = call.args[i]; if (a) for (const s2 of a.srcs) info.srcs.add(s2) }
            if (!isEmptyVal(info)) { const bare = f.replace(/^this\./, ""); const e = env.get(bare) ?? emptyVal(); mergeVal(e, info); env.set(bare, e) }
          }
          for (const [f, srcs] of cs.fieldsSrcs) {
            if (srcs.size) { const bare = f.replace(/^this\./, ""); const e = env.get(bare) ?? emptyVal(); for (const s2 of srcs) e.srcs.add(s2); env.set(bare, e) }
          }
        }
        continue
      }
      const lhs = lhsOf(clean)
      if (lhs) {
        const refs = rhsVars(clean)
        const info = emptyVal()
        for (const v of refs) { const e = env.get(v.replace(/^this\./, "")); if (e) mergeVal(info, e) }
        if (isEmptyVal(info) && refs.length) env.delete(lhs)
        else if (!isEmptyVal(info)) env.set(lhs, info)
      }
    }
  }
  return flows
}

/** 端点枚举(与 Rust dataflow::endpoints 同语义):文件中出现 source/sink API 的行号。 */
export function endpoints(content: string): { srcLines: Array<[number, string]>; snkLines: Array<[number, string]> } {
  const srcLines: Array<[number, string]> = []
  const snkLines: Array<[number, string]> = []
  content.split("\n").forEach((raw, i) => {
    const clean = stripStrings(raw)
    const sa = sourceApi(clean); if (sa) srcLines.push([i + 1, sa])
    const ka = sinkApi(clean); if (ka) snkLines.push([i + 1, ka])
  })
  return { srcLines, snkLines }
}

/** 跨类联合分析(与 Rust analyze_crossclass 同口径):类内优先、全局唯一方法名才跨类解析。 */
export function analyzeCrossclass(files: Array<{ cls: string; content: string }>): CrossClassFlow[] {
  if (files.length <= 1) return []
  const units = files.map(f => {
    const lines = f.content.split("\n")
    const meths = extractMethods(lines, f.cls)
    // 回调注册解析(P2-2):匿名内部类方法并入宿主类(与 Rust 同口径)。
    // P1-b 不动点:回调体内可再注册回调(嵌套 new Xxx(){}),单遍展开只浮出第一层;
    // 反复展开直至方法表不再增长(有界:每轮至少浮出一层嵌套,上限防病态构造)。
    // 注意:expandAnonymousMethods 每轮从头重扫,会重复 push 已浮出的匿名方法——
    // 每轮按 (name, body 起点) 去重,保证不动点判定有效。
    for (let round = 0; round < 8; round++) {
      const before = meths.length
      expandAnonymousMethods(meths, lines, f.cls)
      const seenKeys = new Set<string>()
      const deduped = meths.filter(m => {
        const key = `${m.name}:${m.body[0] ?? -1}`
        if (seenKeys.has(key)) return false
        seenKeys.add(key)
        return true
      })
      meths.length = 0
      meths.push(...deduped)
      if (meths.length === before) break
    }
    return { cls: f.cls, lines, meths: meths.filter(m => m.name !== "__file__") }
  })
  const nameIndex = new Map<string, Array<[string, string]>>()
  for (const u of units) for (const m of u.meths) {
    const v = nameIndex.get(m.name) ?? []; v.push([u.cls, m.name]); nameIndex.set(m.name, v)
  }
  const allSums = new Map<string, Sum>() // key: cls + "::" + meth
  for (const u of units) {
    const local = new Set(u.meths.map(m => m.name))
    const uniqueGlobal = new Set([...nameIndex.entries()].filter(([k, v]) => v.length === 1 && v[0]![0] !== u.cls).map(([k]) => k))
    const has = (n: string) => local.has(n) || (uniqueGlobal.has(n) && !local.has(n))
    for (const m of u.meths) allSums.set(`${u.cls}::${m.name}`, summarize(m, u.lines, has))
  }
  // 调用边解析(P2-3 集合语义):类内同名优先;跨类唯一实现解析到该实现,
  // 多实现(接口分派)全部分发,流取并集——FP 风险由对判层 sink 端约束。
  const resolveAll = (owner: string, callee: string): Array<[string, string]> => {
    if (allSums.has(`${owner}::${callee}`)) return [[owner, callee]]
    return nameIndex.get(callee) ?? []
  }
  const lookup = (cls: string, meth: string) => allSums.get(`${cls}::${meth}`)
  const entry = new Map<string, Map<number, Set<number>>>() // key: cls::meth
  for (let round = 0; round < 3; round++) {
    const delta = new Map<string, Map<number, Set<number>>>()
    for (const [key, s] of allSums) {
      const [owner, meth] = key.split("::")
      if (!owner || !meth) continue
      const ent = entry.get(key)
      for (const { callee, args } of s.calls) {
        for (const target of resolveAll(owner, callee)) {
          const tkey = target.join("::")
          for (let j = 0; j < args.length; j++) {
            const arg = args[j]!
            const add = new Set(arg.srcs)
            if (ent) for (const p of arg.params) for (const st of ent.get(p) ?? []) add.add(st)
            if (add.size) {
              const dm = delta.get(tkey) ?? new Map(); delta.set(tkey, dm)
              const ds = dm.get(j) ?? new Set(); dm.set(j, ds)
              for (const x of add) ds.add(x)
            }
          }
        }
        void meth
      }
    }
    let changed = false
    for (const [key, ps] of delta) {
      for (const [i, st] of ps) {
        const em = entry.get(key) ?? new Map(); entry.set(key, em)
        const e = em.get(i) ?? new Set(); em.set(i, e)
        const before = e.size
        for (const x of st) e.add(x)
        changed ||= e.size !== before
      }
    }
    if (!changed) break
  }
  const flows: CrossClassFlow[] = []
  const seen = new Set<string>()
  // P1-b: 执行时捕获通道——外层回调体内再注册内层回调时,捕获污点在执行期才可见
  // (summarize 期 env 为空,看不到链式传入的污点);(回调名, 变量名, 来源行集)
  const rtCaptures: Array<[string, string, Set<number>]> = []
  // P1-a: 方法体解释循环抽出(原内联于流检查,行为不变)——生命周期序执行复用同一函数。
  // 返回 env 终态:字段部分(this. 前缀/裸字段名)是生命周期链的传播媒介。
  const runMethodBody = (u: { cls: string; lines: string[]; meths: Meth[] }, m: Meth, env0: Map<string, ValInfo> | undefined): void => {
    const local = new Set(u.meths.map(x => x.name))
    const s = lookup(u.cls, m.name); if (!s) return
    const env = new Map<string, ValInfo>()
    if (env0) for (const [k, v] of env0) env.set(k, v)
    m.paramNames.forEach((p, i) => {
      const info = emptyVal(); info.params.add(i)
      const st = entry.get(`${u.cls}::${m.name}`)?.get(i)
      if (st) info.srcs = new Set(st)
      if (!isEmptyVal(info)) env.set(p, info)
    })
    // P1-b 修复:框架回调捕获播种(与 analyzeInterproc 终扫同语义)——本方法被
    // 分派为回调时,按名字注入宿主捕获污点。此前跨类路径缺这一步,回调流全部断链。
    // rtCaptures:嵌套回调(回调体内再注册回调)的污点在执行期才可见,一并注入。
    for (const cs of allSums.values()) {
      for (const [cb, vn, srcs] of cs.captures) {
        if (cb === m.name && srcs.size) {
          const e = env.get(vn) ?? emptyVal()
          for (const x of srcs) e.srcs.add(x)
          env.set(vn, e)
        }
      }
    }
    for (const [cb, vn, srcs] of rtCaptures) {
      if (cb === m.name && srcs.size) {
        const e = env.get(vn) ?? emptyVal()
        for (const x of srcs) e.srcs.add(x)
        env.set(vn, e)
      }
    }
      for (const li of m.body) {
        const l = (u.lines[li] ?? "").trim()
        if (!l || l.startsWith("//") || l.startsWith("*") || l.startsWith("/*")) continue
        const clean = stripStrings(l)
        const lineno = li + 1
        if (sanitizerHit(clean)) { const lhs = lhsOf(clean); if (lhs) env.delete(lhs); continue }
        // P1-b 登记端:执行到回调注册行(setOnClickXxx/post/execute 等)时,当前 env
        // 中带污点的变量就是内层回调的捕获污点——登记给对应回调名(执行期捕获)。
        const rtCb = frameworkDispatch(clean)
        if (rtCb) {
          const capSrcs = new Set<number>()
          for (const [, e] of env) for (const s of e.srcs) capSrcs.add(s)
          if (capSrcs.size) for (const [vn, e] of env) if (!isEmptyVal(e)) rtCaptures.push([rtCb, vn, new Set(e.srcs)])
        }
        if (sourceApi(clean)) {
          // P1-c: source 写入字段(h.data = getSource())→ 记字段键,不记裸名
          const faS = fieldAssign(clean)
          if (faS) {
            const key = faS[0] === "this" ? `this.${faS[1]}` : `${faS[0]}.${faS[1]}`
            const v = env.get(key) ?? emptyVal(); v.srcs.add(lineno); env.set(key, v); continue
          }
          const lhs = lhsOf(clean); if (lhs) { const v = env.get(lhs) ?? emptyVal(); v.srcs.add(lineno); env.set(lhs, v); continue }
        }
        const sapi = sinkApi(clean)
        if (sapi) {
          const refs = rhsVars(clean)
          const used = refs.length ? refs : varsInCall(clean)
          const info = emptyVal()
          for (const v of used) { const e = env.get(v.replace(/^this\./, "")); if (e) mergeVal(info, e) }
          // P1-c: sink 实参中的字段读(x.f)按 "x.f" 键查 env(this.f 归一)
          for (const [o, f] of fieldReads(clean)) {
            const key = o === "this" ? `this.${f}` : `${o}.${f}`
            const e = env.get(key); if (e) mergeVal(info, e)
          }
          for (const src of info.srcs) {
            if (!sourceApi(u.lines[src - 1] ?? "")) continue // 入口污点行号属调用方文件,由 caller 侧上报
            const key = `${u.cls}:${src}->${u.cls}:${lineno}`
            if (!seen.has(key)) {
              seen.add(key)
              flows.push({ source_line: src, sink_line: lineno, src_api: sourceApi(u.lines[src - 1] ?? "") ?? "", sink_api: sapi, src_class: u.cls, sink_class: u.cls })
            }
          }
          continue
        }
        const call = resolveCall(clean, lineno, n => local.has(n) || nameIndex.has(n), env)
        if (call) {
          const targets = resolveAll(u.cls, call.callee)
          // 多实现集合语义:sink 流全部分发(并集);ret/fields 取并集注入
          for (const target of targets) {
            const cs = lookup(target[0], target[1]); if (!cs) continue
            for (const { line: sl, api: s2, info: sinfo } of cs.sinks) {
              for (const p of sinfo.params) {
                const a = call.args[p]
                if (a) for (const src of a.srcs) {
                  const key = `${u.cls}:${src}->${target[0]}:${sl}`
                  if (!seen.has(key)) {
                    seen.add(key)
                    flows.push({ source_line: src, sink_line: sl, src_api: sourceApi(u.lines[src - 1] ?? "") ?? "", sink_api: s2, src_class: u.cls, sink_class: target[0] })
                  }
                }
              }
            }
          }
          const lhs = lhsOf(clean)
          if (lhs) {
            const info = emptyVal()
            for (const t of targets) {
              const cs = lookup(t[0], t[1]); if (!cs) continue
              for (const x of cs.retSrcs) info.srcs.add(x)
              for (const i of cs.retParams) { const a = call.args[i]; if (a) for (const x of a.srcs) info.srcs.add(x) }
            }
            if (!isEmptyVal(info)) env.set(lhs, info); else env.delete(lhs)
          }
          for (const t of targets) {
            const cs = lookup(t[0], t[1]); if (!cs) continue
            for (const [f, pidxs] of cs.fieldsFrom) {
              const info = emptyVal()
              for (const i of pidxs) { const a = call.args[i]; if (a) for (const x of a.srcs) info.srcs.add(x) }
              if (!isEmptyVal(info)) { const bare = f.replace(/^this\./, ""); const e = env.get(bare) ?? emptyVal(); mergeVal(e, info); env.set(bare, e) }
            }
            for (const [f, srcs] of cs.fieldsSrcs) {
              if (srcs.size) { const bare = f.replace(/^this\./, ""); const e = env.get(bare) ?? emptyVal(); for (const x of srcs) e.srcs.add(x); env.set(bare, e) }
            }
          }
          continue
        }
        const lhs = lhsOf(clean)
        if (lhs) {
          const refs = rhsVars(clean)
          const info = emptyVal()
          for (const v of refs) { const e = env.get(v.replace(/^this\./, "")); if (e) mergeVal(info, e) }
          // P1-c: RHS 字段读(h.data)按 "x.f" 键并入(this.f 归一为 this.f 键)
          for (const [o, f] of fieldReads(clean.slice(clean.search(/=(?!=)/) + 1))) {
            const key = o === "this" ? `this.${f}` : `${o}.${f}`
            const e = env.get(key); if (e) mergeVal(info, e)
          }
          // P1-c: LHS 是字段写(x.f = / this.f =)→ 写字段键,不覆盖对象键
          const fa = fieldAssign(clean)
          if (fa) {
            const key = fa[0] === "this" ? `this.${fa[1]}` : `${fa[0]}.${fa[1]}`
            if (!isEmptyVal(info)) env.set(key, info); else env.delete(key)
          } else if (isEmptyVal(info) && refs.length) env.delete(lhs)
          else if (!isEmptyVal(info)) env.set(lhs, info)
        }
      }
    // P1-a: 字段终态回写 env0(生命周期链用);非生命周期路径无 env0,无副作用。
    // P1-c 修复:this. 前缀的字段键必须保留——它们正是生命周期链的传播媒介
    // (onCreate 写 this.data,onReceive 读 this.data);此前整类丢弃导致链断。
    if (env0) {
      env0.clear()
      for (const [k, v] of env) {
        if (k.startsWith("$")) continue
        if (k.startsWith("this.")) { env0.set(k, v); continue }
        if (/^this$/.test(k)) continue
        if (!m.paramNames.includes(k)) env0.set(k, v)
      }
    }
  }
  // P1-a: 生命周期序表(dummy-main 保守子集)——同类内按框架调用序串行执行,
  // 字段 env 终态沿链传播;跨组件类不连接(保守,防 FP)。
  const LIFECYCLE_SEQ = [
    "onCreate", "onStart", "onResume", "onPause", "onStop", "onDestroy",
    "onReceive", "onStartCommand", "onBind", "onHandleIntent",
    "doInBackground", "onProgressUpdate", "onPostExecute",
  ]
  const lifecycleRank = (n: string): number => LIFECYCLE_SEQ.indexOf(n)
  for (const u of units) {
    const lc = u.meths
      .filter(m => lifecycleRank(m.name) >= 0)
      .sort((a, b) => lifecycleRank(a.name) - lifecycleRank(b.name))
    if (lc.length >= 2) {
      // 链式执行:前者的字段终态 = 后者的初始 env(dummy-main 语义的同类内子集)
      const chainEnv = new Map<string, ValInfo>()
      for (const m of lc) {
        if (process.env.DS_DEBUG_LIFECYCLE) console.error(`DBG chain ${u.cls}::${m.name} env0=${JSON.stringify([...chainEnv.keys()])}`)
        runMethodBody(u, m, chainEnv)
        if (process.env.DS_DEBUG_LIFECYCLE) console.error(`DBG after ${m.name} env0=${JSON.stringify([...chainEnv.keys()])}`)
      }
      continue // 链上方法已按序执行,不再单独跑
    }
    for (const m of u.meths) {
      runMethodBody(u, m, undefined)
    }
  }
  return flows
}
