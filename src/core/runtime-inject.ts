// 运行时保护 Smali 注入 classes.dex（P0-5）。
// 将生成的运行时保护 Smali（AntiDump/AntiFrida/SignatureCheck/CrashGuard）
// 编译为 DEX 并合并到 APK 的 classes.dex 中，
// 同时在 Application.onCreate 中调用运行时保护初始化。
// 纯 TypeScript，失败关闭。
import { compileAndMergeSmali } from "./smali-merge.ts"
import type { Finding } from "./types.ts"

// ── 运行时保护初始化 Smali ──────────────────────────────────────────────

/**
 * 生成运行时保护初始化器 Smali（在壳 Application.onCreate 中调用）。
 * 初始化顺序：AntiDump → AntiFrida → SignatureCheck → CrashGuard
 */
export function generateRuntimeInitializerSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealRuntimeGuard;
.super Ljava/lang/Object;
.source "DroidSealRuntimeGuard.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# 初始化所有运行时保护（在壳 Application.onCreate 中调用）
.method public static init()V
    .locals 2
    :try_start
    # 1. 反 Dump 检测
    invoke-static {}, L${pkg}/DroidSealAntiDump;->checkMemoryDump()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :skip_1
    :skip_1

    :try_start_2
    # 2. 反 Frida 检测
    invoke-static {}, L${pkg}/DroidSealAntiFrida;->detectFridaMaps()Z
    move-result v0
    if-eqz v0, :skip_frida
    invoke-static {}, L${pkg}/DroidSealCrashGuard;->hookDetected()V
    :skip_frida
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :skip_2
    :skip_2

    :try_start_3
    # 3. 签名自校验（如果启用了）
    # 签名校验需要传入 Context，这里留空壳
    # 实际在壳 Application.onCreate 中调用
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :skip_3
    :skip_3

    return-void
.end method

# 带签名校验的初始化（需要 Context）
.method public static initWithSignature(Landroid/content/Context;)V
    .locals 2
    :try_start
    invoke-static {}, L${pkg}/DroidSealRuntimeGuard;->init()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :skip

    :try_start_sig
    invoke-static {p0}, L${pkg}/DroidSealSignatureCheck;->verifySignature(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :skip
    invoke-static {}, L${pkg}/DroidSealCrashGuard;->integrityFailed()V
    :skip
    :try_end_sig
    .catch Ljava/lang/Exception; {:try_start_sig .. :try_end_sig} :done
    :done
    return-void
.end method
`
}

/**
 * 生成在壳 Application.onCreate 中插入的运行时保护调用代码。
 */
export function generateRuntimeInitCall(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `
    # 运行时保护初始化
    invoke-static {p0}, L${pkg}/DroidSealRuntimeGuard;->initWithSignature(Landroid/content/Context;)V
`
}

/**
 * 完整的运行时保护注入流程。
 * 1. 读取已有的运行时保护 Smali 文件
 * 2. 添加运行时保护初始化器
 * 3. 编译所有运行时保护 Smali 为 DEX
 * 4. 合并到 APK 的 classes.dex
 */
export async function injectRuntimeProtection(
  smaliFiles: Array<{ name: string; content: string }>,
  apkEntries: Array<{ name: string; bytes: Uint8Array }>,
  packageName: string,
): Promise<{
  entries: Array<{ name: string; bytes: Uint8Array }>
  runtimeInitCall: string
  findings: Finding[]
}> {
  const findings: Finding[] = []

  // 添加运行时保护初始化器
  const initializerSmali = generateRuntimeInitializerSmali(packageName)
  const allSmali = [
    ...smaliFiles,
    { name: `smali/${packageName.replace(/\./g, "/")}/DroidSealRuntimeGuard.smali`, content: initializerSmali },
  ]

  // 编译并合并
  const { entries, findings: mergeFindings, method } = await compileAndMergeSmali(
    allSmali,
    apkEntries,
    packageName,
  )
  findings.push(...mergeFindings)

  // 生成运行时保护调用代码（插入到壳 Application.onCreate）
  const runtimeInitCall = generateRuntimeInitCall(packageName)

  if (mergeFindings.some((f) => f.code === "SMALI_COMPILED")) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "RUNTIME_PROTECTION_INJECTED",
      title: "运行时保护 Smali 已注入 classes.dex",
      detail: `编译方法: ${method};注入文件: ${allSmali.length} 个 Smali;初始化器: DroidSealRuntimeGuard.smali。`,
      recommendation: "确认壳 Application.onCreate 中调用了 DroidSealRuntimeGuard.init()。",
      evidence: `files=${allSmali.length} method=${method}`,
    })
  }

  return { entries, runtimeInitCall, findings }
}
