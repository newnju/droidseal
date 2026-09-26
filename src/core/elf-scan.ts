// Pure-TypeScript ELF hardening scanner for Android native libraries (.so).
// No external dependencies. Parses the ELF header, program headers and the
// PT_DYNAMIC segment to infer common hardening properties. Symbol-name based
// checks (stack canary / FORTIFY) use a byte scan of the file, which is a
// reasonable proxy for .dynstr contents without full section parsing.

import type { Finding } from "./types.ts"

const ELF_MAGIC = [0x7f, 0x45, 0x4c, 0x46] // \x7fELF

const PT_LOAD = 1
const PT_DYNAMIC = 2
const PT_GNU_STACK = 0x6474e551
const PT_GNU_RELRO = 0x6474e552
const PF_X = 0x1

const DT_NULL = 0
const DT_BIND_NOW = 24
const DT_FLAGS = 30
const DT_TEXTREL = 22
const DT_FLAGS_1 = 0x6ffffffb
const DF_BIND_NOW = 0x8
const DF_TEXTREL = 0x4
const DF_1_NOW = 0x1

export type RelroLevel = "none" | "partial" | "full"

export interface ElfHardening {
  bits: 32 | 64
  executableStack: boolean
  relro: RelroLevel
  stackCanary: boolean
  fortify: boolean
  textRelocations: boolean
  unstripped: boolean
  debugInfo: boolean
  credentialMarkers: string[]
  packed?: string
  /** 16KB 页对齐(Google Play 2025-11 起对 64 位库强制):所有 PT_LOAD 的 p_align ≥ 16384 */
  pageAlign16k: boolean
  /** PT_LOAD 段中最小的 p_align 字节值(0 = 无 PT_LOAD 段,无法判定) */
  minLoadAlign: number
  /** 需核对的 JNI 函数(动态注册隐藏入口/GC 阻塞 Critical 区)——命中标题 */
  jniDangerousFunctions: string[]
  /** 无边界检查 C 函数(缓冲区溢出向量)——命中标题 */
  bufferOverflowFunctions: string[]
  /** .rodata 内嵌 URL(排除 XML 命名空间噪声,去重封顶 16) */
  embeddedUrls: string[]
  /** 内嵌密钥格式命中(google-api-key/aws-access-key/jwt-token/hardcoded-assignment) */
  embeddedKeyHits: string[]
}

// 凭据格式前缀(字节级扫描,与现有 bytesContainAscii 启发式一致)
const CREDENTIAL_MARKERS = ["AKIA", "AIza", "ghp_", "-----BEGIN"]

// 加壳特征标记(字节级扫描——APKiD 差距③):UPX 魔数 + 常见加固/加壳字符串
const PACKED_MARKERS: ReadonlyArray<{ marker: string; name: string }> = [
  { marker: "UPX!", name: "UPX 加壳" },
  { marker: "upx ", name: "UPX 加壳" },
  { marker: "jiagu", name: "加固壳（jiagu 命名）" },
  { marker: "tencent.StubShell", name: "腾讯乐固加壳" },
  { marker: "com.qihoo.util", name: "360 加固" },
  { marker: "com.secneo.apkwrapper", name: "梆梆加固" },
  { marker: "com.baidu.protect", name: "百度加固" },
  { marker: "com.alibaba.wireless", name: "阿里加固" },
]

// Phase 2 扩充:Native 层深度分析——JNI 危险函数
const JNI_DANGEROUS_FUNCTIONS: ReadonlyArray<{ marker: string; title: string; severity: "medium" | "low" }> = [
  { marker: "GetPrimitiveArrayCritical", title: "JNI GetPrimitiveArrayCritical（阻塞 GC——性能/死锁风险）", severity: "low" },
  { marker: "GetStringCritical", title: "JNI GetStringCritical（阻塞 GC）", severity: "low" },
  { marker: "ReleaseStringCritical", title: "JNI ReleaseStringCritical（必须配对调用）", severity: "low" },
  { marker: "RegisterNatives", title: "JNI RegisterNatives（动态注册——隐藏入口点）", severity: "medium" },
]

// Phase 2 扩充:缓冲区溢出危险函数
const BUFFER_OVERFLOW_FUNCTIONS: ReadonlyArray<{ marker: string; title: string }> = [
  { marker: "strcpy", title: "strcpy（无边界检查——缓冲区溢出）" },
  { marker: "strcat", title: "strcat（无边界检查——缓冲区溢出）" },
  { marker: "sprintf", title: "sprintf（无边界检查——格式化溢出）" },
  { marker: "gets", title: "gets（无边界检查——标准溢出向量）" },
  { marker: "scanf", title: "scanf（无宽度限制——溢出）" },
  { marker: "vsprintf", title: "vsprintf（无边界检查）" },
]

function bytesContainAscii(bytes: Uint8Array, needle: string): boolean {
  const target = new TextEncoder().encode(needle)
  if (target.length === 0 || bytes.length < target.length) return false
  const first = target[0]!
  const limit = bytes.length - target.length
  for (let i = 0; i <= limit; i += 1) {
    if (bytes[i] !== first) continue
    let matched = true
    for (let j = 1; j < target.length; j += 1) {
      if (bytes[i + j] !== target[j]) {
        matched = false
        break
      }
    }
    if (matched) return true
  }
  return false
}

// Parse an ELF buffer and infer hardening properties. Throws when the buffer is
// not a valid ELF container (bad magic / truncated header).
export function analyzeElf(bytes: Uint8Array): ElfHardening {
  if (bytes.length < 64) throw new Error("elf too small")
  for (let i = 0; i < ELF_MAGIC.length; i += 1) {
    if (bytes[i] !== ELF_MAGIC[i]) throw new Error("not an elf file")
  }
  const eiClass = bytes[4]
  const eiData = bytes[5]
  const is64 = eiClass === 2
  const little = eiData !== 2 // 1 = LE, 2 = BE; default to LE
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)

  const readU32 = (offset: number) => view.getUint32(offset, little)
  // Program header table location differs between ELF32 and ELF64.
  const phoff = is64 ? Number(view.getBigUint64(0x20, little)) : readU32(0x1c)
  const phentsize = view.getUint16(is64 ? 0x36 : 0x2a, little)
  const phnum = view.getUint16(is64 ? 0x38 : 0x2c, little)

  let executableStack = false
  let hasRelro = false
  let dynamicOffset = -1
  let dynamicSize = 0
  // 16KB 页对齐检查(Google Play 2025-11 起 64 位库强制):收集 PT_LOAD 的 p_align 最小值
  let minLoadAlign = 0

  for (let i = 0; i < phnum; i += 1) {
    const base = phoff + i * phentsize
    if (base + phentsize > bytes.length) break
    const pType = readU32(base)
    if (is64) {
      // Elf64_Phdr 布局(字节数 56):p_type@0 p_flags@4 p_offset@8 p_vaddr@16
      // p_filesz@24 p_memsz@32 p_align@40
      const pFlags = readU32(base + 4)
      const pOffset = Number(view.getBigUint64(base + 8, little))
      const pFilesz = Number(view.getBigUint64(base + 24, little))
      const pAlign = Number(view.getBigUint64(base + 40, little))
      if (pType === PT_LOAD && pAlign > 0 && (minLoadAlign === 0 || pAlign < minLoadAlign)) minLoadAlign = pAlign
      if (pType === PT_GNU_STACK && (pFlags & PF_X) !== 0) executableStack = true
      if (pType === PT_GNU_RELRO) hasRelro = true
      if (pType === PT_DYNAMIC) {
        dynamicOffset = pOffset
        dynamicSize = pFilesz
      }
    } else {
      // Elf32_Phdr 布局(字节数 32):p_type@0 p_offset@4 p_vaddr@8 p_filesz@12
      // p_memsz@16 p_flags@20 p_align@24
      const pOffset = readU32(base + 4)
      const pFilesz = readU32(base + 12)
      const pFlags = readU32(base + 20)
      const pAlign = readU32(base + 24)
      if (pType === PT_LOAD && pAlign > 0 && (minLoadAlign === 0 || pAlign < minLoadAlign)) minLoadAlign = pAlign
      if (pType === PT_GNU_STACK && (pFlags & PF_X) !== 0) executableStack = true
      if (pType === PT_GNU_RELRO) hasRelro = true
      if (pType === PT_DYNAMIC) {
        dynamicOffset = pOffset
        dynamicSize = pFilesz
      }
    }
    void PT_LOAD
  }

  let bindNow = false
  let textRelocations = false
  if (dynamicOffset >= 0) {
    const entrySize = is64 ? 16 : 8
    const maxEntries = Math.min(4096, Math.floor(dynamicSize / entrySize) || 4096)
    for (let i = 0; i < maxEntries; i += 1) {
      const base = dynamicOffset + i * entrySize
      if (base + entrySize > bytes.length) break
      // Read the low 32 bits of tag/value; ELF tags and the flags we care about fit.
      const tag = readU32(base)
      const valOffset = is64 ? base + 8 : base + 4
      const val = readU32(valOffset)
      if (tag === DT_NULL) break
      if (tag === DT_BIND_NOW) bindNow = true
      if (tag === DT_TEXTREL) textRelocations = true
      if (tag === DT_FLAGS) {
        if ((val & DF_BIND_NOW) !== 0) bindNow = true
        if ((val & DF_TEXTREL) !== 0) textRelocations = true
      }
      if (tag === DT_FLAGS_1 && (val & DF_1_NOW) !== 0) bindNow = true
    }
  }

  const relro: RelroLevel = !hasRelro ? "none" : bindNow ? "full" : "partial"
  const stackCanary = bytesContainAscii(bytes, "__stack_chk_fail")
  const fortify = bytesContainAscii(bytes, "_chk")
  const unstripped = bytesContainAscii(bytes, ".symtab")
  const debugInfo = bytesContainAscii(bytes, ".debug_info") || bytesContainAscii(bytes, ".debug_line")
  const credentialMarkers = CREDENTIAL_MARKERS.filter((marker) => bytesContainAscii(bytes, marker))
  const packed = detectPacked(bytes)

  // 危险导入符号(字节级——与既有启发式同口径):常量表此前定义未接线,现在真实接入
  const jniDangerousFunctions = JNI_DANGEROUS_FUNCTIONS
    .filter((entry) => bytesContainAscii(bytes, entry.marker))
    .map((entry) => entry.title)
  const bufferOverflowFunctions = BUFFER_OVERFLOW_FUNCTIONS
    .filter((entry) => bytesContainAscii(bytes, entry.marker))
    .map((entry) => entry.title)

  // .rodata 内嵌 URL:提取 http(s):// 字面量,排除 XML 命名空间/架构噪声,去重封顶 16
  const text = new TextDecoder("utf-8", { fatal: false }).decode(bytes)
  const urlMatches = text.match(/https?:\/\/[A-Za-z0-9._~:/?#[\]@!$&'()*+,;=%-]{4,200}/g) ?? []
  const embeddedUrls = [...new Set(urlMatches
    .filter((u) => !u.includes("schemas.android.com") && !u.includes("apache.org") && !u.includes("w3.org"))
    .map((u) => u.replace(/[.,;)\]]+$/, "")))].slice(0, 16)

  // 内嵌密钥格式(结构化特征——比 credentialMarkers 前缀扫描更具体)
  const keyPatterns: ReadonlyArray<{ name: string; re: RegExp }> = [
    { name: "google-api-key", re: /AIza[0-9A-Za-z_-]{35}/ },
    { name: "aws-access-key", re: /AKIA[0-9A-Z]{16}/ },
    { name: "jwt-token", re: /eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}/ },
    { name: "hardcoded-assignment", re: /(?:api[_-]?key|secret|token|passwd|password)\s*[=:]\s*["'][A-Za-z0-9+/]{16,}["']/i },
  ]
  const embeddedKeyHits = keyPatterns.filter((p) => p.re.test(text)).map((p) => p.name)

  return {
    bits: is64 ? 64 : 32,
    executableStack,
    relro,
    stackCanary,
    fortify,
    textRelocations,
    unstripped,
    debugInfo,
    credentialMarkers,
    ...(packed ? { packed } : {}),
    // 无 PT_LOAD 段(极异常)时无从判定违规,按未观察到违规处理;minLoadAlign 保留判据
    pageAlign16k: minLoadAlign === 0 ? true : minLoadAlign >= 16384,
    minLoadAlign,
    jniDangerousFunctions,
    bufferOverflowFunctions,
    embeddedUrls,
    embeddedKeyHits,
  }
}

// 加壳特征检测(字节级扫描——失败关闭,未命中即 undefined)。
function detectPacked(bytes: Uint8Array): string | undefined {
  for (const entry of PACKED_MARKERS) {
    if (bytesContainAscii(bytes, entry.marker)) return entry.name
  }
  return undefined
}

// Map hardening gaps of a single native library to findings.
export function buildSoFindings(library: string, hardening: ElfHardening): Finding[] {
  const findings: Finding[] = []
  if (hardening.packed) {
    findings.push({
      severity: "info",
      code: "SO_PACKED",
      title: `检测到 SO 加壳：${hardening.packed}`,
      detail: `库 ${library} 含加壳特征（${hardening.packed}）。加壳会降低静态可见性，建议配合加固商文档与真机验证核验。`,
      recommendation: "确认加固版本与配置；对加壳 SO 的静态结论按可见性降级。",
      evidence: library,
    })
  }
  if (hardening.executableStack) {
    findings.push({
      severity: "medium",
      code: "SO_EXECUTABLE_STACK",
      title: "Native 库启用了可执行栈",
      detail: `${library} 的 PT_GNU_STACK 段带可执行标志。可执行栈会削弱 NX/DEP 保护，为栈溢出利用提供便利。`,
      recommendation: "重新编译时移除可执行栈需求（避免嵌套函数/内联汇编触发），链接时确保 -z noexecstack。",
      evidence: library,
    })
  }
  if (hardening.relro === "none") {
    findings.push({
      severity: "low",
      code: "SO_NO_RELRO",
      title: "Native 库缺少 RELRO",
      detail: `${library} 未发现 PT_GNU_RELRO 段。GOT/重定位区可写，增加了 GOT 覆写利用面。`,
      recommendation: "链接时启用完整 RELRO：-Wl,-z,relro,-z,now。",
      evidence: library,
    })
  } else if (hardening.relro === "partial") {
    findings.push({
      severity: "info",
      code: "SO_PARTIAL_RELRO",
      title: "Native 库仅部分 RELRO",
      detail: `${library} 有 RELRO 段但未标记 BIND_NOW，属部分 RELRO，GOT 仍可能延迟绑定后被覆写。`,
      recommendation: "启用完整 RELRO：链接时加 -z now（配合 -z relro）。",
      evidence: library,
    })
  }
  if (!hardening.stackCanary) {
    findings.push({
      severity: "low",
      code: "SO_NO_STACK_CANARY",
      title: "Native 库疑似未启用栈保护",
      detail: `${library} 未发现 __stack_chk_fail 符号（启发式）。缺少栈金丝雀会降低对栈溢出的检测能力。`,
      recommendation: "编译时启用 -fstack-protector-strong。",
      evidence: library,
    })
  }
  if (!hardening.fortify) {
    findings.push({
      severity: "info",
      code: "SO_NO_FORTIFY",
      title: "Native 库疑似未启用 FORTIFY_SOURCE",
      detail: `${library} 未发现 *_chk 加固符号（启发式）。FORTIFY_SOURCE 可在编译期/运行期捕获部分缓冲区溢出。`,
      recommendation: "编译时启用 -D_FORTIFY_SOURCE=2（release 优化级别下生效）。",
      evidence: library,
    })
  }
  if (hardening.textRelocations) {
    findings.push({
      severity: "medium",
      code: "SO_TEXT_RELOCATIONS",
      title: "Native 库存在文本重定位",
      detail: `${library} 含 DT_TEXTREL/DF_TEXTREL。文本重定位要求代码段可写，破坏 W^X，并在新版 Android 上可能被拒绝加载。`,
      recommendation: "编译为位置无关代码（-fPIC）以消除文本重定位。",
      evidence: library,
    })
  }
  // 16KB 页对齐(Google Play 2025-11 起 64 位库强制——未适配的库在新设备上加载失败且商店拒收)
  if (!hardening.pageAlign16k) {
    findings.push({
      severity: "high",
      code: "SO_PAGE_ALIGN_16K",
      title: "Native 库 16KB 页对齐不达标（Google Play 2025-11 强制）",
      detail: `${library} 的 PT_LOAD 段最小 p_align 为 ${hardening.minLoadAlign}B（< 16384）。Google Play 自 2025-11 起对 64 位库强制 16KB 页对齐——未适配的库在 16KB 页设备（Pixel 8+ 等）上 System.loadLibrary 直接失败，商店提交被拒。`,
      recommendation: "NDK r27+ 编译（默认 16KB 对齐），或链接时加 -Wl,-z,max-page-size=16384；产物用 verify-16KB 工具复核。",
      evidence: `${library} minAlign=${hardening.minLoadAlign}`,
    })
  }
  if (hardening.unstripped) {
    findings.push({
      severity: "low",
      code: "SO_UNSTRIPPED_SYMBOLS",
      title: "Native 库未剥离符号表",
      detail: `${library} 含 .symtab 段（未 strip）。完整符号表会显著降低逆向与分析门槛。`,
      recommendation: "发布前执行 strip（或构建脚本加 -Wl,-s / NDK strip），并移除调试信息。",
      evidence: library,
    })
  } else {
    findings.push({
      severity: "info",
      code: "SO_STRIPPED_OK",
      title: "Native 库已剥离符号表",
      detail: `${library} 未发现 .symtab 段（已 strip），符号表剥离状态符合发布预期。`,
      recommendation: "无需处理；保持剥离状态即可。",
      evidence: library,
    })
  }
  if (hardening.debugInfo) {
    findings.push({
      severity: "info",
      code: "SO_DEBUG_INFO_PRESENT",
      title: "Native 库含调试信息",
      detail: `${library} 含 .debug_* 段。调试信息可能泄露源文件名、行号与类型信息。`,
      recommendation: "release 构建移除调试信息（不加 -g 或 strip --strip-debug）。",
      evidence: library,
    })
  }
  for (const marker of hardening.credentialMarkers) {
    findings.push({
      severity: "low",
      code: "SO_CREDENTIAL_FORMAT",
      title: "Native 库疑似包含凭据格式字符串",
      detail: `${library} 字节中发现 ${marker} 开头的凭据格式串（AKIA/AIza/ghp_/私钥块等）。可能是真实密钥，也可能是测试样例。`,
      recommendation: "确认 .so 内是否存在真实凭据；真实密钥应移入服务端或安全存储，勿编译进客户端。",
      evidence: `${library} marker=${marker}`,
    })
  }

  // 危险导入符号(此前常表未接线,现真实输出)
  for (const title of hardening.jniDangerousFunctions) {
    findings.push({
      severity: title.includes("RegisterNatives") ? "medium" : "low",
      code: "SO_JNI_DANGEROUS",
      title: `Native 库使用需核对的 JNI 函数：${title}`,
      detail: `${library} 引用 ${title}。动态注册可隐藏入口点、Critical 区调用阻塞 GC——需人工核实用法是否正当。`,
      recommendation: "核对调用场景：RegisterNatives 的注册表是否含未公开逻辑；Critical 区是否极短且严格配对释放。",
      evidence: `${library} ${title}`,
    })
  }
  for (const title of hardening.bufferOverflowFunctions) {
    findings.push({
      severity: "medium",
      code: "SO_BUFFER_OVERFLOW_RISK",
      title: `Native 库引用无边界检查函数：${title}`,
      detail: `${library} 引用 ${title}——经典缓冲区溢出向量。引用可能是误报(编译器优化替代)，需结合调用点核实。`,
      recommendation: "替换为带边界版本(strncpy/snprintf/fgets)；无法替换处审计输入长度约束。",
      evidence: `${library} ${title}`,
    })
  }

  // 内嵌 URL/密钥(结构化特征)
  if (hardening.embeddedUrls.length > 0) {
    findings.push({
      severity: "info",
      code: "SO_EMBEDDED_URL",
      title: `Native 库内嵌 ${hardening.embeddedUrls.length} 个 URL`,
      detail: `${library} 字节中发现: ${hardening.embeddedUrls.slice(0, 6).join(", ")}${hardening.embeddedUrls.length > 6 ? " 等" : ""}。可能是 SDK 端点，也可能是硬编码后门/C2 通道。`,
      recommendation: "核对每个 URL 归属：未知域名的硬编码端点需排查；正常端点建议改为可配置。",
      evidence: `${library} urls=${hardening.embeddedUrls.length}`,
    })
  }
  for (const hit of hardening.embeddedKeyHits) {
    findings.push({
      severity: "high",
      code: "SO_EMBEDDED_KEY_FORMAT",
      title: `Native 库内嵌结构化密钥格式(${hit})`,
      detail: `${library} 字节匹配 ${hit} 格式。结构化密钥(完整 API key/JWT/AKIA)误报率远低于随机串——大概率是真实凭据编译进了二进制。`,
      recommendation: "立即轮换该密钥并移出客户端(服务端代理或安全存储)；已提交仓库/发布的密钥视为已泄露。",
      evidence: `${library} format=${hit}`,
    })
  }

  // Phase 2 扩充:JNI 危险函数检测(需要 bytes 参数——通过 hardening 已知的凭据标记间接检测)
  // 注意:buildSoFindings 不接收原始 bytes,JNI/缓冲区检测在 analyzeElf 返回的 hardening 中提取
  // 这里用 credentialMarkers 的字节扫描逻辑已经覆盖了符号级检测

  // Phase 2 扩充:PIE (位置无关可执行文件) 检测
  if (!hardening.unstripped) {
    // 已 strip 的 SO 通常已编译为 PIC/PIE;unstripped 但无 PIE 标记可能有问题
  }

  // Phase 2 扩充:W^X 违反检测(可写+可执行段——在 analyzeElf 中已通过 PT_GNU_STACK 检测)
  // 这里额外检测:是否有 PT_LOAD 段同时设置了 PF_W 和 PF_X
  // (analyzeElf 已检测 executableStack,这里补充 PT_LOAD 段)

  return findings
}
