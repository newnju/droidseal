// LLVM/OLLVM 混淆特征检测 + VMP 字节码特征检测（Phase 1 #73 #81 #82）。
// 检测 SO 文件中的 LLVM 混淆特征：控制流平坦化、虚假控制流、MBA、间接调用/跳转、
// 函数包装、基本块分割/乱序、死代码插入、指令替换。
// 检测 VMP 虚拟机特征：dispatch loop、opcode handler、自定义 VM 寄存器。
// 纯字节级扫描，失败关闭。
import type { Finding } from "./types.ts"

function bytesContainAscii(bytes: Uint8Array, needle: string): boolean {
  const target = new TextEncoder().encode(needle)
  if (target.length === 0 || bytes.length < target.length) return false
  const first = target[0]!
  const limit = bytes.length - target.length
  for (let i = 0; i <= limit; i += 1) {
    if (bytes[i] !== first) continue
    let matched = true
    for (let j = 1; j < target.length; j += 1) {
      if (bytes[i + j] !== target[j]) { matched = false; break }
    }
    if (matched) return true
  }
  return false
}

// ── LLVM 混淆特征 ──────────────────────────────────────────────────────────

interface LlvmFeature {
  key: string
  title: string
  category: "cf-flatten" | "bogus-cf" | "mba" | "indirect-call" | "func-wrap" | "bb-split" | "dead-code" | "inst-sub" | "string-encrypt" | "vmp"
  markers: string[]
  severity: Finding["severity"]
  note: string
}

const LLVM_FEATURES: readonly LlvmFeature[] = [
  // 控制流平坦化
  { key: "OLLVM_CF_FLATTEN_SWITCH", title: "OLLVM 控制流平坦化(switch 变量)", category: "cf-flatten", markers: ["switch_var", "flattened", "obfuscated"], severity: "high", note: "控制流平坦化将所有基本块放入 switch-case 循环，显著增加逆向难度。" },
  { key: "OLLVM_CF_FLATTEN_DISPATCHER", title: "OLLVM 控制流平坦化(dispatcher 块)", category: "cf-flatten", markers: ["dispatcher", "case_default", "bb_selector"], severity: "high", note: "dispatcher 块通过变量分派基本块执行顺序。" },
  { key: "OLLVM_CF_FLATTEN_INDIRECT_BR", title: "OLLVM 控制流平坦化(间接跳转)", category: "cf-flatten", markers: ["indirectbr", "blockaddress"], severity: "high", note: "使用间接跳转替代直接分支。" },
  // 虚假控制流
  { key: "OLLVM_BOGUS_CF_OPACITY", title: "OLLVM 虚假控制流(不透明谓词)", category: "bogus-cf", markers: ["opaque_predicate", "bogus_flow", "fake_branch"], severity: "high", note: "插入永远为真/假的谓词条件，创建不可达分支。" },
  { key: "OLLVM_BOGUS_CF_JUNK_BRANCH", title: "OLLVM 虚假控制流(垃圾分支)", category: "bogus-cf", markers: ["junk_branch", "dead_path", "unreachable_bb"], severity: "high", note: "插入永远不会执行的分支代码。" },
  // MBA（混合布尔算术）
  { key: "OLLVM_MBA_LINEAR", title: "OLLVM MBA 线性变换", category: "mba", markers: ["mba_linear", "xor_and_or", "mixed_boolean"], severity: "high", note: "将简单算术运算替换为等价的布尔/算术混合表达式。" },
  { key: "OLLVM_MBA_NONLINEAR", title: "OLLVM MBA 非线性变换", category: "mba", markers: ["mba_substitute", "arith_obfuscate", "expr_expand"], severity: "high", note: "非线性 MBA 替换，增加表达式复杂度。" },
  // 间接调用/跳转
  { key: "OLLVM_INDIRECT_CALL", title: "OLLVM 间接调用(函数指针替换)", category: "indirect-call", markers: ["indirect_call", "func_ptr_table", "call_site_encrypt"], severity: "high", note: "将直接函数调用替换为通过函数指针表的间接调用。" },
  { key: "OLLVM_INDIRECT_BRANCH", title: "OLLVM 间接跳转(跳转表加密)", category: "indirect-call", markers: ["indirect_branch", "jump_table_encrypt", "br_target_encrypt"], severity: "high", note: "跳转目标通过计算得出，增加 CFG 恢复难度。" },
  // 函数包装
  { key: "OLLVM_FUNC_WRAP", title: "OLLVM 函数包装(调用替换)", category: "func-wrap", markers: ["func_wrapper", "call_wrap", "trampoline"], severity: "medium", note: "将函数调用包装在间接调用函数中。" },
  { key: "OLLVM_FUNC_SPLIT", title: "OLLVM 函数分裂", category: "func-wrap", markers: ["func_split", "split_basic_block"], severity: "medium", note: "将函数分裂为多个子函数，通过调用链重组。" },
  // 基本块分割/乱序
  { key: "OLLVM_BB_SPLIT", title: "OLLVM 基本块分割", category: "bb-split", markers: ["block_split", "bb_partition"], severity: "medium", note: "将大基本块分割为多个小块。" },
  { key: "OLLVM_BB_REORDER", title: "OLLVM 基本块乱序", category: "bb-split", markers: ["block_reorder", "bb_shuffle"], severity: "medium", note: "打乱基本块的物理顺序。" },
  { key: "OLLVM_BB_DUPLICATE", title: "OLLVM 基本块复制", category: "bb-split", markers: ["block_duplicate", "bb_clone"], severity: "medium", note: "复制基本块并随机选择执行路径。" },
  // 死代码插入
  { key: "OLLVM_DEAD_CODE", title: "OLLVM 死代码插入", category: "dead-code", markers: ["dead_code_insert", "junk_code", "nop_sled"], severity: "medium", note: "插入永远不会执行的代码，干扰分析。" },
  // 指令替换
  { key: "OLLVM_INST_SUB", title: "OLLVM 指令替换", category: "inst-sub", markers: ["instruction_substitute", "arith_replace", "logic_expand"], severity: "medium", note: "将简单指令替换为等价的复杂指令序列。" },
  // 字符串加密
  { key: "OLLVM_STRING_ENC", title: "OLLVM 字符串加密", category: "string-encrypt", markers: ["string_encrypt", "str_obfuscate", "global_ctor_decrypt"], severity: "high", note: "全局构造函数中解密字符串常量。" },
  // VMP 虚拟机
  { key: "VMP_DISPATCH_LOOP", title: "VMP 虚拟机 dispatch loop", category: "vmp", markers: ["vm_dispatch", "opcode_handler", "vm_interpreter"], severity: "critical", note: "自定义虚拟机的指令分派循环——方法体被转为 VM 字节码。" },
  { key: "VMP_OPCODE_TABLE", title: "VMP 虚拟机 opcode 表", category: "vmp", markers: ["opcode_table", "vm_bytecode", "handler_table"], severity: "critical", note: "VM opcode 处理函数表。" },
  { key: "VMP_VM_REGISTERS", title: "VMP 虚拟机自定义寄存器", category: "vmp", markers: ["vm_register", "virtual_reg", "vm_stack"], severity: "critical", note: "自定义 VM 的寄存器/栈模拟。" },
]

export interface LlvmDetectResult {
  key: string
  title: string
  category: LlvmFeature["category"]
  severity: Finding["severity"]
  matchedMarkers: string[]
}

export function detectLlvmOllvmFeatures(bytes: Uint8Array): LlvmDetectResult[] {
  const results: LlvmDetectResult[] = []
  for (const feature of LLVM_FEATURES) {
    const matched = feature.markers.filter((m) => bytesContainAscii(bytes, m))
    if (matched.length >= Math.ceil(feature.markers.length / 2)) {
      results.push({
        key: feature.key,
        title: feature.title,
        category: feature.category,
        severity: feature.severity,
        matchedMarkers: matched,
      })
    }
  }
  return results
}

export function buildLlvmFindings(library: string, results: LlvmDetectResult[]): Finding[] {
  return results.map((r) => ({
    severity: r.severity,
    confidence: "medium" as const,
    code: "SO_LLVM_OBFUSCATION",
    title: `${library}: ${r.title}`,
    detail: `在 ${library} 中检测到 LLVM/OLLVM 混淆特征: ${r.matchedMarkers.join(", ")}。${LLVM_FEATURES.find((f) => f.key === r.key)?.note ?? ""}`,
    recommendation: r.category === "vmp"
      ? "VMP 保护的代码静态分析极困难——需动态调试/污点追踪。确认是否为商业加固方案。"
      : "OLLVM 混淆降低静态分析可见性——审计结论按可见性降级。确认是否为合法加固。",
    evidence: `${library} markers=${r.matchedMarkers.join(",")}`,
  }))
}

// ── 保护层枚举(#78) ──────────────────────────────────────────────────────

export interface ProtectionLayer {
  layer: string
  detected: boolean
  details: string
  source: string
}

export function enumerateProtectionLayers(
  packerName: string | undefined,
  llvmResults: LlvmDetectResult[],
  hasDexEncryption: boolean,
  hasSoEncryption: boolean,
  hasResourceEncryption: boolean,
  hasStringObfuscation: boolean,
  hasAntiDebug: boolean,
  hasAntiHook: boolean,
  hasAntiDump: boolean,
  hasAntiTamper: boolean,
  hasRootDetect: boolean,
  hasEmulatorDetect: boolean,
): ProtectionLayer[] {
  return [
    { layer: "DEX 加壳/加密", detected: hasDexEncryption, details: packerName ?? "未识别具体壳", source: "packer-fingerprint" },
    { layer: "SO 加密", detected: hasSoEncryption, details: hasSoEncryption ? "检测到 SO 文件加密" : "", source: "elf-scan" },
    { layer: "资源加密", detected: hasResourceEncryption, details: hasResourceEncryption ? "检测到资源文件加密" : "", source: "apk-audit" },
    { layer: "字符串混淆", detected: hasStringObfuscation, details: hasStringObfuscation ? "检测到字符串加密/混淆" : "", source: "dex-scan" },
    { layer: "LLVM 控制流平坦化", detected: llvmResults.some((r) => r.category === "cf-flatten"), details: llvmResults.filter((r) => r.category === "cf-flatten").map((r) => r.title).join("; "), source: "llvm-detect" },
    { layer: "LLVM 虚假控制流", detected: llvmResults.some((r) => r.category === "bogus-cf"), details: llvmResults.filter((r) => r.category === "bogus-cf").map((r) => r.title).join("; "), source: "llvm-detect" },
    { layer: "LLVM MBA 混淆", detected: llvmResults.some((r) => r.category === "mba"), details: llvmResults.filter((r) => r.category === "mba").map((r) => r.title).join("; "), source: "llvm-detect" },
    { layer: "LLVM 间接调用", detected: llvmResults.some((r) => r.category === "indirect-call"), details: llvmResults.filter((r) => r.category === "indirect-call").map((r) => r.title).join("; "), source: "llvm-detect" },
    { layer: "VMP 虚拟机保护", detected: llvmResults.some((r) => r.category === "vmp"), details: llvmResults.filter((r) => r.category === "vmp").map((r) => r.title).join("; "), source: "llvm-detect" },
    { layer: "反调试", detected: hasAntiDebug, details: hasAntiDebug ? "检测到反调试逻辑" : "", source: "runtime-detection" },
    { layer: "反 Hook", detected: hasAntiHook, details: hasAntiHook ? "检测到 Hook 框架检测" : "", source: "runtime-detection" },
    { layer: "反 Dump", detected: hasAntiDump, details: hasAntiDump ? "检测到反内存 Dump" : "", source: "runtime-detection" },
    { layer: "反篡改/签名校验", detected: hasAntiTamper, details: hasAntiTamper ? "检测到签名/完整性校验" : "", source: "runtime-detection" },
    { layer: "Root 检测", detected: hasRootDetect, details: hasRootDetect ? "检测到 Root 检测逻辑" : "", source: "runtime-detection" },
    { layer: "模拟器检测", detected: hasEmulatorDetect, details: hasEmulatorDetect ? "检测到模拟器检测逻辑" : "", source: "runtime-detection" },
  ]
}

export function buildProtectionLayerFindings(layers: ProtectionLayer[]): Finding[] {
  const detected = layers.filter((l) => l.detected)
  const missing = layers.filter((l) => !l.detected)
  const findings: Finding[] = []
  if (detected.length > 0) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "PROTECTION_LAYERS",
      title: `检测到 ${detected.length}/${layers.length} 层保护措施`,
      detail: detected.map((l) => `${l.layer}: ${l.details}`).join("; "),
      recommendation: "保护层越多，绕过成本越高。缺失的保护层可考虑补充。",
      evidence: detected.map((l) => l.layer).join(", "),
    })
  }
  if (missing.length > 0 && missing.length < layers.length) {
    findings.push({
      severity: "low",
      confidence: "high",
      code: "PROTECTION_GAPS",
      title: `缺失 ${missing.length} 层保护: ${missing.map((l) => l.layer).join("、")}`,
      detail: `已实现 ${detected.length} 层,缺失: ${missing.map((l) => l.layer).join("、")}。`,
      recommendation: "考虑补充缺失的保护层以提高整体安全强度。",
      evidence: missing.map((l) => l.layer).join(", "),
    })
  }
  return findings
}
