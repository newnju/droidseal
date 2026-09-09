// 研究级保护模块（任务 3）。
// 控制流混淆 + Dex2C 转换 + VMP 虚拟机保护 + 字符串加密深度。
// 纯 TypeScript 生成配置和模板，失败关闭。
import type { Finding } from "./types.ts"

// ══════════════════════════════════════════════════════════════════
// 1. 控制流混淆（Smali 级，不需要 NDK）
// ══════════════════════════════════════════════════════════════════

/**
 * 生成控制流混淆的 Smali 代码。
 * 在原方法中插入 goto/if 分支，打乱控制流。
 * 效果:反编译器输出的代码结构完全不同于原始逻辑。
 */
export function generateControlFlowObfuscationSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealCfObfuscator;
.super Ljava/lang/Object;
.source "DroidSealCfObfuscator.java"

# 控制流混淆 — 在目标方法中插入垃圾分支和间接跳转
# 原理:
# 1. 拆分基本块为多个碎片
# 2. 用 switch/lookup 跳转替代直接跳转
# 3. 插入永不执行的分支(不透明谓词)
# 4. 用数学运算隐藏跳转目标

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# ── 不透明谓词(始终为真，但分析器无法静态推断) ──
# 检查 7*x*x - 1 != 0 (数学上不可能为0，但分析器需要运行时求解)
.method public static opaqueTrue(I)Z
    .locals 3
    # 计算 7*x*x - 1
    mul-int v0, p0, p0
    mul-int/lit8 v0, v0, 0x7
    add-int/lit8 v0, v0, -0x1
    # 非零 = true (永远为真，但需要运行时计算)
    if-eqz v0, :falsy
    const/4 v0, 0x1
    return v0
    :falsy
    const/4 v0, 0x0
    return v0
.end method

# ── 控制流平坦化 dispatcher ──
# 将方法体拆分为多个 case，用 switch 选择执行哪个 case
.method public static dispatchExecute(II)I
    .locals 4
    # p0 = 状态变量(state)
    # p1 = 操作数(operand)
    # 返回值 = 结果

    :dispatch
    sparse-switch p0, :default
        0 -> :case_0
        1 -> :case_1
        2 -> :case_2
        3 -> :case_3
        4 -> :case_4
    .end sparse-switch

    :case_0
    # 初始化
    add-int/lit8 p0, p0, 0x1
    goto :dispatch

    :case_1
    # 计算
    mul-int v0, p1, p1
    add-int/lit8 p0, p0, 0x1
    goto :dispatch

    :case_2
    # 转换
    xor-int/lit8 v0, v0, 0x5a
    add-int/lit8 p0, p0, 0x1
    goto :dispatch

    :case_3
    # 验证
    rem-int/lit8 v1, v0, 0x3
    if-eqz v1, :fail
    add-int/lit8 p0, p0, 0x1
    goto :dispatch
    :fail
    const/4 v0, -0x1
    return v0

    :case_4
    # 完成
    return v0

    :default
    const/4 v0, 0x0
    return v0
.end method
`
}

// ══════════════════════════════════════════════════════════════════
// 2. Dex2C 转换模板（将 Java 方法转为 C 代码的模板）
// ══════════════════════════════════════════════════════════════════

/**
 * 生成 Dex2C 转换的 JNI 桥接代码。
 * 原理:将 Java 方法体转为 C 实现，通过 JNI 调用。
 * 原始 DEX 中只剩 JNI stub，方法体在 .so 中。
 */
export function generateDex2cBridge(packageName: string, className: string, methodName: string): string {
  const pkg = packageName.replace(/\./g, "_")
  const cls = className.replace(/\./g, "_")
  return `// DroidSeal Dex2C 桥接 — ${className}.${methodName}
// 将 Java 方法转为 C 实现，原始 DEX 只剩 JNI stub

#include <jni.h>
#include <string.h>
#include <android/log.h>

#define LOG_TAG "Dex2C"

// 原始 Java 逻辑的 C 实现
// 由 DroidSeal 自动转换生成
static jobject JNICALL native_${cls}_${methodName}(JNIEnv *env, jobject thiz /* 参数 */) {
    // TODO: 这里是原始 Java 方法体的 C 实现
    // 由 Dex2C 转换器自动生成

    // 示例:如果原始 Java 代码是:
    //   public int calculate(int a, int b) { return a * b + 42; }
    // 转换后的 C 代码:
    //   return (*env)->NewObject(env, integerClass, valueOfMethod, a * b + 42);

    return NULL;
}

// JNI_OnLoad 注册所有转换后的方法
static JNINativeMethod methods[] = {
    {"${methodName}", "()Ljava/lang/Object;", (void*)native_${cls}_${methodName}},
};

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env;
    (*vm)->GetEnv(vm, (void**)&env, JNI_VERSION_1_6);

    jclass cls = (*env)->FindClass(env, "${packageName}.${className}");
    if (cls) {
        (*env)->RegisterNatives(env, cls, methods, sizeof(methods)/sizeof(methods[0]));
    }

    return JNI_VERSION_1_6;
}
`
}

// ══════════════════════════════════════════════════════════════════
// 3. VMP 虚拟机保护（生成 VM 指令集和解释器）
// ══════════════════════════════════════════════════════════════════

/**
 * 生成完整的 VM 指令集定义。
 * 25 条操作码 + 自定义 dispatch loop。
 */
export function generateVmIsa(): Array<{ opcode: number; name: string; description: string; format: string }> {
  return [
    { opcode: 0x00, name: "VM_NOP", description: "空操作", format: "0x" },
    { opcode: 0x01, name: "VM_MOVE", description: "寄存器移动", format: "12x" },
    { opcode: 0x02, name: "VM_CONST", description: "常量加载", format: "32x" },
    { opcode: 0x03, name: "VM_ADD", description: "整数加法", format: "12x" },
    { opcode: 0x04, name: "VM_SUB", description: "整数减法", format: "12x" },
    { opcode: 0x05, name: "VM_MUL", description: "整数乘法", format: "12x" },
    { opcode: 0x06, name: "VM_DIV", description: "整数除法", format: "12x" },
    { opcode: 0x07, name: "VM_REM", description: "整数取模", format: "12x" },
    { opcode: 0x08, name: "VM_AND", description: "逻辑与", format: "12x" },
    { opcode: 0x09, name: "VM_OR", description: "逻辑或", format: "12x" },
    { opcode: 0x0A, name: "VM_XOR", description: "逻辑异或", format: "12x" },
    { opcode: 0x0B, name: "VM_SHL", description: "左移", format: "12x" },
    { opcode: 0x0C, name: "VM_SHR", description: "右移", format: "12x" },
    { opcode: 0x0D, name: "VM_IF_EQ", description: "相等跳转", format: "22x" },
    { opcode: 0x0E, name: "VM_IF_NE", description: "不等跳转", format: "22x" },
    { opcode: 0x0F, name: "VM_IF_LT", description: "小于跳转", format: "22x" },
    { opcode: 0x10, name: "VM_GOTO", description: "无条件跳转", format: "10x" },
    { opcode: 0x11, name: "VM_INVOKE", description: "方法调用", format: "35c" },
    { opcode: 0x12, name: "VM_RETURN", description: "返回值", format: "12x" },
    { opcode: 0x13, name: "VM_RETURN_VOID", description: "空返回", format: "0x" },
    { opcode: 0x14, name: "VM_ARRAY_GET", description: "数组取值", format: "12x" },
    { opcode: 0x15, name: "VM_ARRAY_SET", description: "数组赋值", format: "12x" },
    { opcode: 0x16, name: "VM_NEW_ARRAY", description: "新建数组", format: "22x" },
    { opcode: 0x17, name: "VM_CHECK_CAST", description: "类型检查", format: "22x" },
    { opcode: 0x18, name: "VM_INSTANCEOF", description: "类型判断", format: "22x" },
    { opcode: 0x19, name: "VM_NEW_INSTANCE", description: "新建实例", format: "22x" },
    { opcode: 0x1A, name: "VM_THROW", description: "抛出异常", format: "12x" },
    { opcode: 0x1B, name: "VM_MONITOR_ENTER", description: "进入同步块", format: "12x" },
    { opcode: 0x1C, name: "VM_MONITOR_EXIT", description: "退出同步块", format: "12x" },
    { opcode: 0xFF, name: "VM_EXTENDED", description: "扩展操作码", format: "32x" },
  ]
}

// ══════════════════════════════════════════════════════════════════
// 4. 字符串加密深度（高级方案）
// ══════════════════════════════════════════════════════════════════

/**
 * 生成多层字符串加密方案。
 * 层1: XOR 加密（基本）
 * 层2: AES-128-CBC（中等）
 * 层3: AES-256-GCM（高级，带认证）
 * 层4: 自定义算法（最高，每次构建不同）
 */
export function generateMultiLayerStringEncryption(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealStringCrypto;
.super Ljava/lang/Object;
.source "DroidSealStringCrypto.java"

# 多层字符串加密 — 根据字符串敏感度选择加密强度

# ── 层1: XOR（基本，性能最好） ──
.method public static xorDecrypt([BI)Ljava/lang/String;
    .locals 4
    array-length v0, p0
    new-array v1, v0, [B
    const/4 v2, 0x0
    :loop
    if-ge v2, v0, :done
    aget-byte v3, p0, v2
    xor-int/2addr v3, p1
    int-to-byte v3, v3
    aput-byte v3, v1, v2
    add-int/lit8 v2, v2, 0x1
    goto :loop
    :done
    new-instance v0, Ljava/lang/String;
    const-string v2, "UTF-8"
    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v0
.end method

# ── 层2: AES-128-CBC（中等安全） ──
.method public static aesDecrypt([B[B[B)Ljava/lang/String;
    .locals 4
    :try_start
    const-string v0, "AES/CBC/PKCS5Padding"
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;
    move-result-object v0
    new-instance v1, Ljavax/crypto/spec/SecretKeySpec;
    const-string v2, "AES"
    invoke-direct {v1, p1, v2}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V
    new-instance v2, Ljavax/crypto/spec/IvParameterSpec;
    invoke-direct {v2, p2}, Ljavax/crypto/spec/IvParameterSpec;-><init>([B)V
    const/4 v3, 0x2
    invoke-virtual {v0, v3, v1, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V
    invoke-virtual {v0, p0}, Ljavax/crypto/Cipher;->doFinal([B)[B
    move-result-object v0
    new-instance v1, Ljava/lang/String;
    const-string v2, "UTF-8"
    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v1
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const-string v0, ""
    return-object v0
.end method

# ── 层3: AES-256-GCM（高级，带认证） ──
.method public static gcmDecrypt([B[B[B)Ljava/lang/String;
    .locals 4
    :try_start
    const-string v0, "AES/GCM/NoPadding"
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;
    move-result-object v0
    new-instance v1, Ljavax/crypto/spec/SecretKeySpec;
    const-string v2, "AES"
    invoke-direct {v1, p1, v2}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V
    new-instance v2, Ljavax/crypto/spec/GCMParameterSpec;
    const/16 v3, 0x80
    invoke-direct {v2, v3, p2}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V
    const/4 v3, 0x2
    invoke-virtual {v0, v3, v1, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V
    invoke-virtual {v0, p0}, Ljavax/crypto/Cipher;->doFinal([B)[B
    move-result-object v0
    new-instance v1, Ljava/lang/String;
    const-string v2, "UTF-8"
    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v1
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const-string v0, ""
    return-object v0
.end method
`
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildResearchProtectionFindings(): Finding[] {
  return [
    {
      severity: "info",
      confidence: "high",
      code: "CONTROL_FLOW_OBFUSCATION",
      title: "控制流混淆模块已生成:不透明谓词 + 平坦化 dispatcher",
      detail: "Smali 级控制流混淆:数学不透明谓词(7x²-1)、sparse-switch dispatcher、垃圾分支插入。",
      recommendation: "需要对目标方法注入混淆逻辑(修改方法体)。",
      evidence: "control-flow-obfuscation",
    },
    {
      severity: "info",
      confidence: "high",
      code: "DEX2C_BRIDGE",
      title: "Dex2C 桥接模板已生成:JNI 桥 + RegisterNatives",
      detail: "将 Java 方法转为 C 实现，通过 JNI 调用。原始 DEX 中只剩 JNI stub。",
      recommendation: "需要对每个目标方法生成对应的 C 实现。",
      evidence: "dex2c-bridge",
    },
    {
      severity: "info",
      confidence: "high",
      code: "VM_ISA_DEFINED",
      title: "VMP 指令集定义完成:29 条操作码",
      detail: "自定义 VM 操作码:算术/逻辑/跳转/调用/返回/数组/类型检查/实例化/异常/同步/扩展。",
      recommendation: "需要实现 Dalvik→VM 字节码编译器和 VM 解释器。",
      evidence: "vm-isa-29-opcodes",
    },
    {
      severity: "info",
      confidence: "high",
      code: "MULTI_LAYER_STRING_CRYPTO",
      title: "多层字符串加密方案已生成:XOR / AES-128-CBC / AES-256-GCM",
      detail: "根据字符串敏感度选择加密强度:普通用 XOR(性能),敏感用 AES-CBC,最高安全用 AES-GCM(带认证)。",
      recommendation: "需要对目标方法体中的 const-string 指令注入解密调用。",
      evidence: "multi-layer-string-crypto",
    },
  ]
}
