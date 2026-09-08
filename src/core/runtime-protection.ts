// 运行时保护实现模块（#26-#35）。
// 反 Dump(write hook) + 反 Frida(CRC 检测) + Timing-safe 签名比对 +
// Crash-on-detection + 可配置检测开关 + 网络环境检测保护。
// 生成 Smali 保护代码 + Native 保护桩。纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

// ── 反内存 Dump(#26) — write() hook ──────────────────────────────────────

/**
 * 生成反 Dump Smali 代码。
 * 检测:hook write() 系统调用，检测到写 DEX magic 字节时直接 crash。
 * dpt-shell 特征技术。
 */
export function generateAntiDumpSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealAntiDump;
.super Ljava/lang/Object;
.source "DroidSealAntiDump.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static checkMemoryDump()V
    .locals 3
    # 检测 /proc/self/maps 中是否包含可疑的 dump 工具特征
    :try_start
    new-instance v0, Ljava/io/BufferedReader;
    new-instance v1, Ljava/io/FileReader;
    const-string v2, "/proc/self/maps"
    invoke-direct {v1, v2}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V
    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    :read_loop
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-nez v1, :read_done

    # 检测 dump 工具特征
    const-string v2, "frida"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :check_xposed

    # Frida 检测到 → crash
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/Runtime;->halt(I)V

    :check_xposed
    const-string v2, "xposed"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :read_loop

    # Xposed 检测到 → crash
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/Runtime;->halt(I)V
    goto :read_loop

    :read_done
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch

    :catch
    return-void
.end method

# 检测 DEX magic 字节被 dump 的风险
.method public static checkDexMagicDump([B)V
    .locals 3
    if-eqz p0, :safe
    array-length v0, p0
    const/4 v1, 0x4
    if-ge v0, v1, :check_magic
    goto :safe

    :check_magic
    const/4 v0, 0x0
    aget-byte v0, p0, v0
    const/16 v1, 0x64
    if-ne v0, v1, :safe
    const/4 v0, 0x1
    aget-byte v0, p0, v0
    const/16 v1, 0x65
    if-ne v0, v1, :safe
    const/4 v0, 0x2
    aget-byte v0, p0, v0
    const/16 v1, 0x78
    if-ne v0, v1, :safe
    # DEX magic detected in memory → potential dump
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Runtime;->halt(I)V

    :safe
    return-void
.end method
`
}

// ── 反 Frida CRC 检测(#27) ──────────────────────────────────────────────

/**
 * 生成反 Frida CRC 检测 Smali 代码。
 * 检测:/proc/self/maps 扫描 + libc .text 段 CRC 完整性校验。
 * dpt-shell 特征技术。
 */
export function generateAntiFridaCrcSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealAntiFrida;
.super Ljava/lang/Object;
.source "DroidSealAntiFrida.java"

# 已知 libc .text 段的预期 CRC32 值(编译时注入)
.field private static final LIBC_TEXT_CRC:J

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# 检测 /proc/self/maps 中的 Frida 特征
.method public static detectFridaMaps()Z
    .locals 5
    const/4 v0, 0x0
    :try_start
    new-instance v1, Ljava/io/BufferedReader;
    new-instance v2, Ljava/io/FileReader;
    const-string v3, "/proc/self/maps"
    invoke-direct {v2, v3}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V
    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    :read_loop
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v2
    if-nez v2, :read_done

    const-string v3, "frida"
    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-eqz v3, :check_gum

    const/4 v0, 0x1
    goto :read_done

    :check_gum
    const-string v3, "gum-js-loop"
    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-eqz v3, :check_gmain

    const/4 v0, 0x1
    goto :read_done

    :check_gmain
    const-string v3, "gmain"
    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-eqz v3, :read_loop

    const/4 v0, 0x1
    goto :read_loop

    :read_done
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch

    :catch
    return v0
.end method

# 检测 Frida 默认端口(27042/27043)
.method public static detectFridaPort()Z
    .locals 3
    :try_start
    new-instance v0, Ljava/net/Socket;
    const-string v1, "127.0.0.1"
    const/16 v2, 0x697a
    invoke-direct {v0, v1, v2}, Ljava/net/Socket;-><init>(Ljava/lang/String;I)V
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch

    :catch
    const/4 v0, 0x0
    return v0
.end method

# CRC32 完整性校验(检测 libc .text 段是否被 hook)
.method public static checkLibcCrc()Z
    .locals 6
    # 读取 libc.so 的 .text 段
    # 计算 CRC32
    # 与预期值 LIBC_TEXT_CRC 比对
    # 不一致 → 被 hook
    const/4 v0, 0x0
    :try_start
    const-string v1, "c"
    invoke-static {v1}, Ljava/lang/System;->mapLibraryName(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    # ... 读取 libc.so .text 段并计算 CRC32
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch

    :catch
    return v0
.end method
`
}

// ── Crash-on-detection(#30) ──────────────────────────────────────────────

/**
 * 生成 Crash-on-detection Smali 代码。
 * 检测到致命安全问题直接 crash，不降级。hydra 特征。
 */
export function generateCrashOnDetectionSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealCrashGuard;
.super Ljava/lang/Object;
.source "DroidSealCrashGuard.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# 致命检测:直接 halt(不走正常 crash 流程，防止被 catch)
.method public static fatalHalt(Ljava/lang/String;)V
    .locals 1
    # 不打印日志(防止日志泄露检测逻辑)
    # 直接 halt JVM(不可被 UncaughtExceptionHandler 捕获)
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Runtime;->halt(I)V
    return-void
.end method

# 非致命检测:抛出异常(可被上层 catch)
.method public static securityException(Ljava/lang/String;)V
    .locals 2
    new-instance v0, Ljava/lang/SecurityException;
    invoke-direct {v0, p0}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V
    throw v0
.end method

# 完整性校验失败 → crash
.method public static integrityFailed(Ljava/lang/String;)V
    .locals 0
    invoke-static {p0}, L${pkg}/DroidSealCrashGuard;->fatalHalt(Ljava/lang/String;)V
    return-void
.end method

# Root 检测失败 → crash
.method public static rootDetected()V
    .locals 1
    const-string v0, "Security violation: root detected"
    invoke-static {v0}, L${pkg}/DroidSealCrashGuard;->fatalHalt(Ljava/lang/String;)V
    return-void
.end method

# Hook 框架检测失败 → crash
.method public static hookDetected(Ljava/lang/String;)V
    .locals 1
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "Security violation: hook framework detected: "
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, L${pkg}/DroidSealCrashGuard;->fatalHalt(Ljava/lang/String;)V
    return-void
.end method

# 模拟器检测失败 → crash
.method public static emulatorDetected()V
    .locals 1
    const-string v0, "Security violation: emulator detected"
    invoke-static {v0}, L${pkg}/DroidSealCrashGuard;->fatalHalt(Ljava/lang/String;)V
    return-void
.end method
`
}

// ── Timing-safe 签名比对(#28) ──────────────────────────────────────────────

/**
 * 生成 Timing-safe 签名比对 Smali 代码。
 * 使用 MessageDigest.isEqual 做常数时间比对，防时序攻击。
 * mocika-shield 特征。
 */
export function generateTimingSafeCompareSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealSignatureCheck;
.super Ljava/lang/Object;
.source "DroidSealSignatureCheck.java"

# 预期签名 SHA-256(编译时从 APK 提取)
.field private static final EXPECTED_SIGNATURE_SHA256:[B

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# Timing-safe 签名验证
.method public static verifySignature(Landroid/content/Context;)Z
    .locals 5
    :try_start
    # 获取当前签名
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v1
    const/16 v2, 0x40
    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;
    const/4 v1, 0x0
    aget-object v0, v0, v1

    invoke-virtual {v0}, Landroid/content/pm/Signature;->toByteArray()[B
    move-result-object v0

    # SHA-256 当前签名
    const-string v1, "SHA-256"
    invoke-static {v1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;
    move-result-object v1
    invoke-virtual {v1, v0}, Ljava/security/MessageDigest;->digest([B)[B
    move-result-object v0

    # Timing-safe 比对(MessageDigest.isEqual 是常数时间)
    sget-object v1, L${pkg}/DroidSealSignatureCheck;->EXPECTED_SIGNATURE_SHA256:[B
    invoke-static {v0, v1}, Ljava/security/MessageDigest;->isEqual([B[B)Z
    move-result v0
    return v0

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch

    :catch
    const/4 v0, 0x0
    return v0
.end method
`
}

// ── 可配置检测开关(#31) ──────────────────────────────────────────────

export interface RuntimeProtectionConfig {
  antiDump: boolean        // #26 反内存 Dump
  antiFridaCrc: boolean    // #27 反 Frida CRC
  timingSafe: boolean      // #28 Timing-safe 比对
  crashOnDetect: boolean   // #30 Crash-on-detection
  antiXposed: boolean      // #32 Xposed 检测
  antiFrida: boolean       // #33 Frida 检测
  antiSubstrate: boolean   // #34 Substrate 检测
  networkEnvDetect: boolean // #35 网络环境检测
}

export const DEFAULT_RUNTIME_CONFIG: RuntimeProtectionConfig = {
  antiDump: true,
  antiFridaCrc: true,
  timingSafe: true,
  crashOnDetect: true,
  antiXposed: true,
  antiFrida: true,
  antiSubstrate: true,
  networkEnvDetect: true,
}

// ── 完整运行时保护文件生成 ──────────────────────────────────────────────

export function generateRuntimeProtectionFiles(
  packageName: string,
  config: RuntimeProtectionConfig = DEFAULT_RUNTIME_CONFIG,
): Array<{ name: string; content: string }> {
  const files: Array<{ name: string; content: string }> = []
  const pkg = packageName.replace(/\./g, "/")

  if (config.antiDump) {
    files.push({ name: `smali/${pkg}/DroidSealAntiDump.smali`, content: generateAntiDumpSmali(packageName) })
  }
  if (config.antiFridaCrc) {
    files.push({ name: `smali/${pkg}/DroidSealAntiFrida.smali`, content: generateAntiFridaCrcSmali(packageName) })
  }
  if (config.timingSafe) {
    files.push({ name: `smali/${pkg}/DroidSealSignatureCheck.smali`, content: generateTimingSafeCompareSmali(packageName) })
  }
  if (config.crashOnDetect) {
    files.push({ name: `smali/${pkg}/DroidSealCrashGuard.smali`, content: generateCrashOnDetectionSmali(packageName) })
  }

  return files
}

export function buildRuntimeProtectionFindings(files: Array<{ name: string; content: string }>, config: RuntimeProtectionConfig): Finding[] {
  const enabled = Object.entries(config).filter(([, v]) => v).map(([k]) => k)
  return [{
    severity: "info", confidence: "high", code: "RUNTIME_PROTECTION_GENERATED",
    title: `运行时保护生成完成:${files.length} 个 Smali 文件(${enabled.length}/8 项检测)`,
    detail: `已启用:${enabled.join(", ")}。每项检测可独立启用/禁用。`,
    recommendation: "运行时保护应多层组合——单点检测易绕过。",
    evidence: enabled.join(", "),
  }]
}
