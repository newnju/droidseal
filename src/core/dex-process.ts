// DEX 实际处理模块（Phase A-3）。
// 读取真实 classes.dex → 调用 hollowMethods(方法抽取) → 调用 encryptDex(整体加密)。
// 生成壳 DEX(加密 payload 追加到 file_size 边界外)。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { hollowMethods, encryptDex, parseClassExclusionRules, type MethodHollowResult, type EncryptedDex, buildDexProtectionFindings } from "./dex-protection.ts"
import { generateKeyMaterial, type KeyMaterial } from "./dex-protection-keys.ts"

// ── DEX 处理配置 ──────────────────────────────────────────────────────

export interface DexProcessConfig {
  algorithm: "aes-256-gcm" | "chacha20-poly1305"
  enableMethodHollow: boolean
  enableDexEncryption: boolean
  enableSplitKey: boolean
  classExclusionPatterns: string[]
  certSha256?: string | undefined
  apkSha256: string
}

// ── DEX 处理结果 ──────────────────────────────────────────────────────

export interface DexProcessResult {
  processedDex: Uint8Array[]         // 处理后的 DEX 文件列表
  keyMaterial: KeyMaterial
  hollowResult?: MethodHollowResult | undefined
  encryptedDex?: EncryptedDex | undefined
  findings: Finding[]
}

/**
 * 处理单个 classes.dex 文件。
 * 流程:1) 方法抽取(可选) 2) 整体加密(可选) 3) 生成壳 DEX
 */
export function processDexFile(
  dexBytes: Uint8Array,
  config: DexProcessConfig,
  keyMaterial: KeyMaterial,
): { processedDex: Uint8Array; hollowResult?: MethodHollowResult | undefined; encryptedDex?: EncryptedDex | undefined } {
  let processedBytes = dexBytes
  let hollowResult: MethodHollowResult | undefined
  let encryptedDex: EncryptedDex | undefined

  // 1. 方法抽取(Method Hollowing)
  if (config.enableMethodHollow) {
    const excludePatterns = parseClassExclusionRules(JSON.stringify(config.classExclusionPatterns))
    hollowResult = hollowMethods(processedBytes, excludePatterns)
    processedBytes = hollowResult.hollowedDex
  }

  // 2. DEX 整体加密
  if (config.enableDexEncryption) {
    encryptedDex = encryptDex(
      processedBytes,
      keyMaterial.encryptionKey,
      config.algorithm,
      keyMaterial.nonce,
    )
    // 壳 DEX = 加密后的结果(shellDex 包含原始 stub + 加密 payload)
    processedBytes = encryptedDex.shellDex
  }

  return { processedDex: processedBytes, hollowResult, encryptedDex }
}

/**
 * 处理多个 classes.dex 文件(classes.dex, classes2.dex, ...)。
 */
export function processAllDexFiles(
  dexFiles: Array<{ name: string; bytes: Uint8Array }>,
  config: DexProcessConfig,
): DexProcessResult {
  const findings: Finding[] = []
  const processedDex: Uint8Array[] = []

  // 1. 生成密钥材料
  const keyMaterial = generateKeyMaterial(
    config.certSha256,
    config.apkSha256,
    "dex",
    config.enableSplitKey,
  )

  // 2. 处理每个 DEX 文件
  let hollowResult: MethodHollowResult | undefined
  let encryptedDex: EncryptedDex | undefined

  for (const dex of dexFiles) {
    const result = processDexFile(dex.bytes, config, keyMaterial)
    processedDex.push(result.processedDex)
    if (result.hollowResult) hollowResult = result.hollowResult
    if (result.encryptedDex) encryptedDex = result.encryptedDex
  }

  // 3. 生成 Finding
  if (hollowResult) {
    findings.push(...buildDexProtectionFindings(hollowResult, encryptedDex))
  }
  if (encryptedDex) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "DEX_ENCRYPTED",
      title: `DEX 加密完成:${dexFiles.length} 个文件(${config.algorithm})`,
      detail: `原始 ${encryptedDex.originalSize}B → 壳 ${encryptedDex.shellSize}B。密钥来源:${keyMaterial.derivedFrom}。Split-Key: ${config.enableSplitKey ? "是" : "否"}。`,
      recommendation: "确认壳加载器能正确解密;测试 Android 5~16 兼容性。",
      evidence: `files=${dexFiles.length} alg=${config.algorithm} split=${config.enableSplitKey}`,
    })
  }

  return { processedDex, keyMaterial, hollowResult, encryptedDex, findings }
}
