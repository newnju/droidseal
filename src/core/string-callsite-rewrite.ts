// 调用点改写(StringFog 式):apktool 解码 → const-string 替换为解密调用 → smali 重编译。
// 这是字符串加密唯一可靠路径:原位字节写回后 const-string 仍引用原 string_ids,
// 运行时拿到乱码;改写调用点后字符串常量只存在于解密器密文数组中。
// 门控纪律:apktool/smali CLI 任一不可用 → 完全不写回(写了=必坏产物),如实降级。
import { readdir, readFile, writeFile, mkdir, rm } from "node:fs/promises"
import { spawnSync } from "node:child_process"
import path from "node:path"
import type { Finding } from "./types.ts"
import { isSensitive, generateStringDecryptorWithRealData, mutf8SafeEncrypt } from "./string-encrypt-writeback.ts"
import { randomBytes } from "node:crypto"

// ── smali 字符串字面量转义 ────────────────────────────────────────────
function escapeSmaliString(s: string): string {
  let out = ""
  for (const ch of s) {
    if (ch === "\\") out += "\\\\"
    else if (ch === "\n") out += "\\n"
    else if (ch === "\r") out += "\\r"
    else if (ch === "\t") out += "\\t"
    else if (ch === '"') out += '\\"'
    else {
      const c = ch.codePointAt(0)!
      out += c < 0x20 || c > 0x7e ? `\\u${c.toString(16).padStart(4, "0")}` : ch
    }
  }
  return out
}

function unescapeSmaliString(s: string): string {
  let out = ""
  let i = 0
  while (i < s.length) {
    const ch = s[i]!
    if (ch === "\\" && i + 1 < s.length) {
      const n = s[i + 1]!
      if (n === "n") { out += "\n"; i += 2; continue }
      if (n === "r") { out += "\r"; i += 2; continue }
      if (n === "t") { out += "\t"; i += 2; continue }
      if (n === '"') { out += '"'; i += 2; continue }
      if (n === "\\") { out += "\\"; i += 2; continue }
      if (n === "u" && i + 6 <= s.length) { out += String.fromCharCode(parseInt(s.slice(i + 2, i + 6), 16)); i += 6; continue }
    }
    out += ch
    i += 1
  }
  return out
}

// ── 工具检测(PATH → 托管目录 → 自动下载;TOFU 指纹防篡改)──────────────
import { ensureJarTool, detectJava } from "./tool-bootstrap.ts"

export interface RewriteToolStatus {
  apktool: boolean
  smali: boolean
  apktoolCmd?: string
  smaliCmd?: string
  /** 引导事件(下载/复用/失败),供如实降级 finding 的 evidence */
  events?: string[]
}

export async function detectRewriteTools(): Promise<RewriteToolStatus> {
  const status: RewriteToolStatus = { apktool: false, smali: false, events: [] }
  if (!detectJava()) {
    status.events!.push("java-missing:托管 jar 需要 JRE,未检测到 java 命令")
    return status
  }
  // apktool 2.9.3 / smali 3.0.5 官方发布源(首位官方,TOFU 建指纹)
  const apktool = await ensureJarTool({
    name: "apktool",
    version: "2.9.3",
    urls: [
      "https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar",
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.3.jar",
    ],
  })
  status.events!.push(...apktool.events.map((e) => `apktool:${e}`))
  if (apktool.available && apktool.command) {
    status.apktool = true
    status.apktoolCmd = apktool.command
  }
  const smali = await ensureJarTool({
    name: "smali",
    version: "3.0.5",
    urls: [
      "https://github.com/google/smali/releases/download/v3.0.5/smali-3.0.5.jar",
    ],
  })
  status.events!.push(...smali.events.map((e) => `smali:${e}`))
  if (smali.available && smali.command) {
    status.smali = true
    status.smaliCmd = smali.command
  }
  return status
}

// ── smali 调用点改写 ──────────────────────────────────────────────────

const CONST_STRING_RE = /const-string(?:\/jumbo)?\s+(v\d+|[pP]\d+),\s*"((?:[^"\\]|\\.)*)"/g

// 单测用(运行时 regex 带 g 标志有 lastIndex 状态,测试需独立实例)
export const CONST_STRING_RE_TEST = /const-string(?:\/jumbo)?\s+(v\d+|[pP]\d+),\s*"((?:[^"\\]|\\.)*)"/g
export { escapeSmaliString, unescapeSmaliString }

export interface CallsiteRewriteResult {
  rewrittenFiles: number
  rewrittenCallsites: number
  /** 改写后的解密器 smali(需随本次改写一并编译注入) */
  decryptorSmali?: string
  findings: Finding[]
  /** true=写回真正落地产物;false=工具链不可用,完全未动 DEX(如实降级) */
  applied: boolean
}

/**
 * 对 apktool 解码目录做 const-string → decrypt() 调用点改写。
 * 前置:调用方已确认 apktool+smali 可用(detectRewriteTools),否则此处直接如实降级返回。
 * 只改写 isSensitive 命中的字符串;解密器类由 decryptorSmali 落入 smali 目录参与重编译。
 */
export async function rewriteStringCallsites(
  decodeDir: string,
  packageName: string,
  decryptorSmali: string,
  maxEncrypt = 200,
): Promise<CallsiteRewriteResult> {
  const findings: Finding[] = []
  const tools = await detectRewriteTools()
  if (!tools.apktool || !tools.smali) {
    findings.push({
      severity: "medium", confidence: "high", code: "STRING_WRITEBACK_TOOLS_MISSING",
      title: "字符串加密写回未执行(工具链缺失,如实降级)",
      detail: `apktool=${tools.apktool ? "可用" : "缺失"} smali=${tools.smali ? "可用" : "缺失"}。调用点改写需完整 apktool 解码→smali 重编译链;缺失时绝不原位写回密文(const-string 仍指向原字符串,写回=运行时拿到乱码,产出必坏 App)。引导事件:${(tools.events ?? []).join("; ") || "无"}。`,
      recommendation: "确保已安装 JRE(java 命令可用)且能访问 GitHub releases;工具将自动下载到 ~/.droidseal/tools/。",
      evidence: `apktool=${tools.apktool} smali=${tools.smali} events=${(tools.events ?? []).join("|").slice(0, 200)}`,
    })
    return { rewrittenFiles: 0, rewrittenCallsites: 0, findings, applied: false }
  }

  // 收集 smali 文件
  const smaliRoot = path.join(decodeDir, "smali")
  const files: string[] = []
  const collect = async (dir: string): Promise<void> => {
    for (const e of await readdir(dir, { withFileTypes: true }).catch(() => [] as import("node:fs").Dirent[])) {
      const full = path.join(dir, e.name)
      if (e.isDirectory()) await collect(full)
      else if (e.name.endsWith(".smali")) files.push(full)
    }
  }
  await collect(smaliRoot)

  // 第一遍:找所有待加密字符串(去重,建 密文表)
  const table = new Map<string, number>() // 原文 → 解密器索引
  const decrypted: Array<{ index: number; original: string }> = []
  for (const file of files) {
    const content = await readFile(file, "utf8")
    for (const m of content.matchAll(CONST_STRING_RE)) {
      const value = unescapeSmaliString(m[2]!)
      if (value.length >= 6 && value.length <= 1024 && isSensitive(value) && !table.has(value)) {
        if (table.size >= maxEncrypt) break
        table.set(value, decrypted.length)
        decrypted.push({ index: decrypted.length, original: value })
      }
    }
    if (table.size >= maxEncrypt) break
  }
  if (decrypted.length === 0) {
    findings.push({
      severity: "info", confidence: "high", code: "STRING_WRITEBACK_NOTHING_SENSITIVE",
      title: "无可加密敏感字符串,写回跳过",
      detail: "smali 层扫描未发现 isSensitive 命中的字符串。",
      recommendation: "无需处理。",
      evidence: `files=${files.length}`,
    })
    return { rewrittenFiles: 0, rewrittenCallsites: 0, findings, applied: false }
  }

  // 第二遍:改写 const-string → invoke-static decrypt
  const idx = new Map(decrypted.map((d) => [d.original, d.index]))
  let rewrittenCallsites = 0
  let rewrittenFiles = 0
  for (const file of files) {
    const content = await readFile(file, "utf8")
    let fileTouched = false
    const out = content.replace(CONST_STRING_RE, (whole, reg: string, lit: string) => {
      const value = unescapeSmaliString(lit)
      const i = idx.get(value)
      if (i === undefined) return whole
      rewrittenCallsites += 1
      fileTouched = true
      // decrypt(I) 收索引:先 const/16 装载索引再 invoke,结果存回同寄存器
      // (索引上限 maxEncrypt=200 < 32768,const/16 安全)
      return `const/16 ${reg}, ${i}\n    invoke-static {${reg}}, L${packageName.replace(/\./g, "/")}/DroidSealStringDecryptor;->decrypt(I)Ljava/lang/String;\n    move-result-object ${reg}`
    })
    if (fileTouched) {
      await writeFile(file, out, "utf8")
      rewrittenFiles += 1
    }
  }

  // 现场生成解密器:数据来自本次实际改写的字符串集(与调用点索引严格一致——
  // 不能用外部传入的解密器,其 index 表来自 DEX 扫描,与 smali 层集合不同)
  const encData = decrypted.map((d) => {
    const data = new TextEncoder().encode(d.original)
    const baseKey = randomBytes(16)
    const { encrypted, keystream } = mutf8SafeEncrypt(data, baseKey)
    return { index: d.index, original: d.original, key: keystream, encrypted }
  })
  const localDecryptor = generateStringDecryptorWithRealData(packageName, encData)

  // 解密器 smali 落入解码目录,随重编译注入
  const decryptorPath = path.join(smaliRoot, `${packageName.replace(/\./g, "/")}/DroidSealStringDecryptor.smali`)
  await mkdir(path.dirname(decryptorPath), { recursive: true })
  await writeFile(decryptorPath, localDecryptor, "utf8")

  findings.push({
    severity: "info", confidence: "high", code: "STRING_CALLSITES_REWRITTEN",
    title: `调用点改写完成:${rewrittenCallsites} 处(${rewrittenFiles} 个文件)`,
    detail: "const-string 已替换为 DroidSealStringDecryptor.decrypt(I) 调用;原文字符串仅存于解密器密文数组。需 apktool b 重编译后生效。",
    recommendation: "重编译后真机验证 App 行为(解密路径正确性)。",
    evidence: `callsites=${rewrittenCallsites} files=${rewrittenFiles} strings=${decrypted.length}`,
  })
  void escapeSmaliString // 导出给单测(改写前后的字面量互逆性)
  return { rewrittenFiles, rewrittenCallsites, decryptorSmali, findings, applied: true }
}

// ── 完整闭环:apktool d → 改写 → apktool b → 提取 classes.dex ─────────

export interface StringWritebackCycleResult {
  applied: boolean
  /** 重编译产物中全部 classes*.dex(applied=true 时) */
  dexFiles?: Array<{ name: string; bytes: Uint8Array }>
  findings: Finding[]
  stats?: { callsites: number; files: number; strings: number }
}

/**
 * 对输入 APK 做完整字符串加密闭环:
 * apktool d --no-res(只需代码,不碰资源)→ smali 层 const-string 改写 → apktool b → 提取 dex。
 * 工具链不可用 / 解码失败 / 重编译失败 → applied=false,完全不写回(fail-closed:写一半=必坏产物)。
 */
export async function runStringWritebackCycle(
  inputApk: string,
  packageName: string,
  decryptorSmali: string,
  workDir: string,
  maxEncrypt = 200,
): Promise<StringWritebackCycleResult> {
  const findings: Finding[] = []
  const tools = await detectRewriteTools()
  if (!tools.apktool || !tools.smali) {
    findings.push({
      severity: "medium", confidence: "high", code: "STRING_WRITEBACK_TOOLS_MISSING",
      title: "字符串加密写回未执行(工具链缺失,如实降级)",
      detail: `apktool=${tools.apktool ? "可用" : "缺失"} smali=${tools.smali ? "可用" : "缺失"}。调用点改写需完整 apktool 解码→smali 重编译链;缺失时绝不原位写回密文(const-string 仍指向原字符串,写回=运行时拿到乱码,产出必坏 App)。引导事件:${(tools.events ?? []).join("; ") || "无"}。`,
      recommendation: "确保已安装 JRE(java 命令可用)且能访问 GitHub releases;工具将自动下载到 ~/.droidseal/tools/。",
      evidence: `apktool=${tools.apktool} smali=${tools.smali} events=${(tools.events ?? []).join("|").slice(0, 200)}`,
    })
    return { applied: false, findings }
  }
  const decodeDir = path.join(workDir, "string-rewrite-decode")
  const buildApk = path.join(workDir, "string-rewrite-build.apk")
  const run = (cmd: string, args: string[]): { ok: boolean; err?: string } => {
    const base = cmd.startsWith("java -jar ")
      ? { cmd: "java", pre: ["-jar", cmd.slice(10)] }
      : { cmd, pre: [] as string[] }
    const r = spawnSync(base.cmd, [...base.pre, ...args], { timeout: 300_000, stdio: "pipe" })
    return r.status === 0 ? { ok: true } : { ok: false, err: r.stderr?.toString().slice(0, 400) ?? `exit ${r.status}` }
  }
  try {
    const d = run(tools.apktoolCmd!, ["d", "--no-res", "-f", "-o", decodeDir, inputApk])
    if (!d.ok) {
      findings.push({
        severity: "medium", confidence: "high", code: "STRING_WRITEBACK_DECODE_FAILED",
        title: "apktool 解码失败,字符串加密写回未执行(如实降级)",
        detail: `apktool d --no-res 失败: ${d.err ?? "未知"}`,
        recommendation: "核对 APK 完整性;apktool 无法解码的 APK 走原产物路径。",
        evidence: (d.err ?? "").slice(0, 120),
      })
      return { applied: false, findings }
    }
    const rw = await rewriteStringCallsites(decodeDir, packageName, decryptorSmali, maxEncrypt)
    findings.push(...rw.findings)
    if (!rw.applied) return { applied: false, findings }
    const b = run(tools.apktoolCmd!, ["b", decodeDir, "-o", buildApk])
    if (!b.ok) {
      findings.push({
        severity: "medium", confidence: "high", code: "STRING_WRITEBACK_BUILD_FAILED",
        title: "apktool 重编译失败,字符串加密写回未执行(如实降级)",
        detail: `改写了 ${rw.rewrittenCallsites} 处调用点但 apktool b 失败,产物不可用已丢弃——绝不提交半成品: ${b.err ?? "未知"}`,
        recommendation: "核对 smali 语法兼容性(反编译产物可能含 smali 2.x 不支持的语法);失败时走原产物路径。",
        evidence: (b.err ?? "").slice(0, 120),
      })
      return { applied: false, findings }
    }
    // 从重编译 APK 提取 classes*.dex
    const { unpackApk } = await import("./apk-unpack.ts")
    const contents = await unpackApk(buildApk)
    const dexFiles = contents.dexFiles.map((d) => ({ name: d.name, bytes: d.bytes }))
    if (dexFiles.length === 0) {
      findings.push({
        severity: "medium", confidence: "high", code: "STRING_WRITEBACK_EXTRACT_FAILED",
        title: "重编译产物中未提取到 classes*.dex,写回未生效(如实降级)",
        detail: "apktool b 成功但产物无 dex 条目。",
        recommendation: "核对 apktool 版本。",
        evidence: buildApk,
      })
      return { applied: false, findings }
    }
    return {
      applied: true,
      dexFiles,
      findings,
      stats: { callsites: rw.rewrittenCallsites, files: rw.rewrittenFiles, strings: rw.rewrittenCallsites },
    }
  } finally {
    await rm(decodeDir, { recursive: true, force: true }).catch(() => undefined)
    await rm(buildApk, { force: true }).catch(() => undefined)
  }
}


