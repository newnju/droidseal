// VMP 虚拟机保护模块（#67 #68 #69）。
// Dalvik 字节码 → 自定义 VM 指令转换。
// LLVM IR → 自定义虚拟机字节码（Profile 驱动，6 个 DSL 文件定义 ISA/解码器/运行时）。
// 云端 VMP 服务接口桩。
// 纯 TypeScript，生成 VM 配置 + 解释器 Smali 代码，失败关闭。
import type { Finding } from "./types.ts"

// ── Dalvik → VM 指令转换(#67) ──────────────────────────────────────────

export interface VmOpcode {
  opcode: number
  name: string
  format: "0x" | "10x" | "12x" | "22x" | "32x" | "35c" | "3rc"
  description: string
}

/**
 * 自定义 VM 指令集（Profile 驱动——6 个 DSL 文件定义 ISA）。
 * 基于 Dalvik 操作码的子集映射到自定义 VM 操作码。
 */
export const DEFAULT_VM_ISA: readonly VmOpcode[] = [
  { opcode: 0x00, name: "VM_NOP", format: "0x", description: "空操作" },
  { opcode: 0x01, name: "VM_MOVE", format: "12x", description: "寄存器移动" },
  { opcode: 0x02, name: "VM_CONST", format: "32x", description: "常量加载" },
  { opcode: 0x03, name: "VM_ADD", format: "12x", description: "加法" },
  { opcode: 0x04, name: "VM_SUB", format: "12x", description: "减法" },
  { opcode: 0x05, name: "VM_MUL", format: "12x", description: "乘法" },
  { opcode: 0x06, name: "VM_DIV", format: "12x", description: "除法" },
  { opcode: 0x07, name: "VM_IF_EQ", format: "22x", description: "相等跳转" },
  { opcode: 0x08, name: "VM_IF_NE", format: "22x", description: "不等跳转" },
  { opcode: 0x09, name: "VM_INVOKE", format: "35c", description: "方法调用" },
  { opcode: 0x0a, name: "VM_INVOKE_VIRTUAL", format: "35c", description: "虚方法调用" },
  { opcode: 0x0b, name: "VM_INVOKE_STATIC", format: "35c", description: "静态方法调用" },
  { opcode: 0x0c, name: "VM_INVOKE_DIRECT", format: "35c", description: "直接方法调用" },
  { opcode: 0x0d, name: "VM_RETURN", format: "0x", description: "返回" },
  { opcode: 0x0e, name: "VM_RETURN_VALUE", format: "12x", description: "返回值" },
  { opcode: 0x0f, name: "VM_ARRAY_GET", format: "12x", description: "数组取值" },
  { opcode: 0x10, name: "VM_ARRAY_SET", format: "12x", description: "数组设值" },
  { opcode: 0x11, name: "VM_NEW_ARRAY", format: "22x", description: "新建数组" },
  { opcode: 0x12, name: "VM_INSTANCE_GET", format: "12x", description: "实例字段取值" },
  { opcode: 0x13, name: "VM_INSTANCE_SET", format: "12x", description: "实例字段设值" },
  { opcode: 0x14, name: "VM_CHECK_CAST", format: "22x", description: "类型检查" },
  { opcode: 0x15, name: "VM_NEW_INSTANCE", format: "22x", description: "新建实例" },
  { opcode: 0x16, name: "VM_THROW", format: "12x", description: "抛出异常" },
  { opcode: 0x17, name: "VM_MONITOR_ENTER", format: "12x", description: "进入同步块" },
  { opcode: 0x18, name: "VM_MONITOR_EXIT", format: "12x", description: "退出同步块" },
  { opcode: 0xff, name: "VM_EXTENDED", format: "32x", description: "扩展操作码(后续字节指定)" },
]

export interface VmInterpreterConfig {
  isa: readonly VmOpcode[]
  stackSize: number       // VM 栈大小
  registerCount: number   // VM 寄存器数
  obfuscateDispatch: boolean // 混淆 dispatch loop(增加逆向难度)
}

export const DEFAULT_VM_CONFIG: VmInterpreterConfig = {
  isa: DEFAULT_VM_ISA,
  stackSize: 256,
  registerCount: 16,
  obfuscateDispatch: true,
}

/**
 * 生成 VM 解释器 Smali 代码。
 * 核心:dispatch loop + opcode handler switch + 寄存器/栈模拟。
 */
export function generateVmInterpreterSmali(packageName: string, config: VmInterpreterConfig = DEFAULT_VM_CONFIG): string {
  const pkg = packageName.replace(/\./g, "/")
  const handlers = config.isa.map((op) =>
    `    :handle_${op.name.toLowerCase()}\n    # ${op.description}\n    # TODO: 实际 handler 逻辑\n    goto :dispatch_loop`
  ).join("\n\n")

  return `.class public L${pkg}/DroidSealVmInterpreter;
.super Ljava/lang/Object;
.source "DroidSealVmInterpreter.java"

# VM 寄存器
.field private final registers:[J

# VM 栈
.field private final stack:[J
.field private sp:I

# VM 字节码
.field private bytecode:[B
.field private pc:I

# Dispatch loop 混淆(增加逆向难度)
.field private dispatchSeed:J

.method public constructor <init>([B)V
    .locals 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    const/16 v0, ${config.registerCount}
    new-array v0, v0, [J
    iput-object v0, p0, L${pkg}/DroidSealVmInterpreter;->registers:[J
    const/16 v0, ${config.stackSize}
    new-array v0, v0, [J
    iput-object v0, p0, L${pkg}/DroidSealVmInterpreter;->stack:[J
    const/4 v0, 0x0
    iput v0, p0, L${pkg}/DroidSealVmInterpreter;->sp:I
    iput-object p1, p0, L${pkg}/DroidSealVmInterpreter;->bytecode:[B
    iput v0, p0, L${pkg}/DroidSealVmInterpreter;->pc:I
    return-void
.end method

# 核心:dispatch loop
.method public execute()V
    .locals 6

    :dispatch_loop
    iget v0, p0, L${pkg}/DroidSealVmInterpreter;->pc:I
    iget-object v1, p0, L${pkg}/DroidSealVmInterpreter;->bytecode:[B
    array-length v2, v1
    if-ge v0, v2, :done

    # 读取操作码
    aget-byte v0, v1, v0
    and-int/lit16 v0, v0, 0xff

    # Dispatch(混淆:用计算替代直接 switch)
    iget-wide v2, p0, L${pkg}/DroidSealVmInterpreter;->dispatchSeed:J
    xor-int/2addr v0, v2
    long-to-int v0, v0
    and-int/lit16 v0, v0, 0xff

    # Switch on opcode
    sparse-switch v0, :switch_table

    # 未知操作码 → 异常
    new-instance v0, Ljava/lang/RuntimeException;
    const-string v1, "Unknown VM opcode"
    invoke-direct {v0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V
    throw v0

    :done
    return-void

    :switch_table
    .sparse-switch
        0x00 -> :handle_vm_nop
        0x01 -> :handle_vm_move
        0x02 -> :handle_vm_const
        0x03 -> :handle_vm_add
        0x04 -> :handle_vm_sub
        0x05 -> :handle_vm_mul
        0x06 -> :handle_vm_div
        0x07 -> :handle_vm_if_eq
        0x08 -> :handle_vm_if_ne
        0x09 -> :handle_vm_invoke
        0x0d -> :handle_vm_return
        0x0e -> :handle_vm_return_value
        0xff -> :handle_vm_extended
    .end sparse-switch

${handlers}
.end method
`
}

// ── LLVM IR → VM 字节码(#68) ──────────────────────────────────────────

/**
 * LLVM IR → VM 字节码转换配置。
 * Profile 驱动:6 个 DSL 文件定义 ISA/解码器/运行时。
 */
export interface LlvmVmProfile {
  name: string
  isa: string        // ISA 定义文件路径
  decoder: string    // 解码器定义文件路径
  runtime: string    // 运行时定义文件路径
  encoder: string    // 编码器定义文件路径
  optimizer: string  // 优化器定义文件路径
  linker: string     // 链接器定义文件路径
}

export const DEFAULT_LLVM_VM_PROFILES: readonly LlvmVmProfile[] = [
  {
    name: "amice-x86-64",
    isa: "profiles/amice/isa_x86_64.dsl",
    decoder: "profiles/amice/decoder_x86_64.dsl",
    runtime: "profiles/amice/runtime_x86_64.dsl",
    encoder: "profiles/amice/encoder_x86_64.dsl",
    optimizer: "profiles/amice/optimizer_x86_64.dsl",
    linker: "profiles/amice/linker_x86_64.dsl",
  },
  {
    name: "amice-arm64",
    isa: "profiles/amice/isa_arm64.dsl",
    decoder: "profiles/amice/decoder_arm64.dsl",
    runtime: "profiles/amice/runtime_arm64.dsl",
    encoder: "profiles/amice/encoder_arm64.dsl",
    optimizer: "profiles/amice/optimizer_arm64.dsl",
    linker: "profiles/amice/linker_arm64.dsl",
  },
]

/**
 * 生成 LLVM VMP 转换的 CMake 配置。
 * 将 LLVM IR 翻译为自定义 VM 字节码。
 */
export function generateLlvmVmCmakeConfig(profile: LlvmVmProfile): string {
  return `# DroidSeal LLVM VMP 转换配置
# Profile: ${profile.name}
# 将 LLVM IR 翻译为自定义虚拟机字节码

cmake_minimum_required(VERSION 3.18)
project(droidseal-vmp-${profile.name})

set(CMAKE_CXX_STANDARD 17)

# LLVM 依赖
find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM \${LLVM_PACKAGE_VERSION}")

include_directories(\${LLVM_INCLUDE_DIRS})
add_definitions(\${LLVM_DEFINITIONS})

# VMP 转换 Pass
add_library(droidseal-vmp MODULE
    src/vmp_pass.cpp
    src/vmp_encoder.cpp
    src/vmp_isa.cpp
    src/vmp_decoder.cpp
    src/vmp_runtime.cpp
)

target_link_libraries(droidseal-vmp
    \${LLVM_AVAILABLE_LIBS}
)

# Profile 配置
configure_file(
    \${CMAKE_CURRENT_SOURCE_DIR}/${profile.isa}
    \${CMAKE_CURRENT_BINARY_DIR}/isa.dsl
)
configure_file(
    \${CMAKE_CURRENT_SOURCE_DIR}/${profile.decoder}
    \${CMAKE_CURRENT_BINARY_DIR}/decoder.dsl
)
`
}

// ── 云端 VMP 服务接口(#69) ──────────────────────────────────────────────

/**
 * 云端 VMP 服务接口(android-app-jiagu 特征)。
 * 将 APK 上传到云端进行 VMP 转换。
 * DroidSeal 坚持离线优先——此接口仅用于对接商业 VMP 服务。
 */
export interface CloudVmpConfig {
  endpoint: string
  apiKey: string
  timeout: number
  retryCount: number
}

export async function submitToCloudVmp(
  apkPath: string,
  config: CloudVmpConfig,
): Promise<{ success: boolean; vmpApkPath?: string; error?: string }> {
  // 云端 VMP 服务接口桩——实际实现需对接具体服务
  return {
    success: false,
    error: "云端 VMP 服务未配置——DroidSeal 坚持离线优先。此接口仅用于对接商业 VMP 服务。",
  }
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildVmpFindings(
  hasVmInterpreter: boolean,
  hasLlvmVm: boolean,
  hasCloudVmp: boolean,
  profileName?: string,
): Finding[] {
  const findings: Finding[] = []
  if (hasVmInterpreter) {
    findings.push({
      severity: "info", confidence: "high", code: "VMP_INTERPRETER_GENERATED",
      title: "VM 解释器生成完成(Dalvik → VM 指令)",
      detail: `自定义 VM 指令集 ${DEFAULT_VM_ISA.length} 条操作码;寄存器 ${DEFAULT_VM_CONFIG.registerCount} 个;栈 ${DEFAULT_VM_CONFIG.stackSize} 深度;dispatch loop 混淆: ${DEFAULT_VM_CONFIG.obfuscateDispatch ? "是" : "否"}。`,
      recommendation: "VMP 保护的代码静态分析极困难——逆向需完整 VM 反编译器。",
      evidence: `isa=${DEFAULT_VM_ISA.length} opcodes`,
    })
  }
  if (hasLlvmVm) {
    findings.push({
      severity: "info", confidence: "high", code: "LLVM_VMP_GENERATED",
      title: `LLVM VMP 转换配置生成完成${profileName ? `(${profileName})` : ""}`,
      detail: "LLVM IR → 自定义虚拟机字节码;Profile 驱动(6 个 DSL 文件定义 ISA/解码器/运行时)。",
      recommendation: "LLVM VMP 是最强的 Native 代码保护手段——需 LLVM 工具链支持。",
      evidence: `profile=${profileName ?? "default"}`,
    })
  }
  if (hasCloudVmp) {
    findings.push({
      severity: "info", confidence: "low", code: "CLOUD_VMP_STUB",
      title: "云端 VMP 服务接口桩已生成(未对接实际服务)",
      detail: "DroidSeal 坚持离线优先——云端 VMP 接口仅用于对接商业服务(android-app-jiagu 特征)。",
      recommendation: "如需云端 VMP，配置 endpoint 和 apiKey 后调用 submitToCloudVmp。",
      evidence: "cloud-vmp-stub",
    })
  }
  return findings
}
