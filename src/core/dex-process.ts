// DEX 实际处理模块（Phase A-3）。
// 读取真实 classes.dex → 调用 hollowMethods(方法抽取) → 调用 encryptDex(整体加密)。
// 生成壳 DEX(加密 payload 追加到 file_size 边界外)。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { hollowMethods, encryptDex, parseClassExclusionRules, serializePayload, type MethodHollowResult, type EncryptedDex, buildDexProtectionFindings } from "./dex-protection.ts"
import { generateKeyMaterial, type KeyMaterial } from "./dex-protection-keys.ts"
import { compileVmSubset, type VmSubsetResult } from "./vmp-compiler.ts"
import { markVmMethodsNative, resolveVmBridgeEntries, type VmBridgeEntry } from "./vmp-native-mark.ts"

// ── DEX 处理配置 ──────────────────────────────────────────────────────

/** VMP 里程碑 B 接线产物:编译/标记结果 + 桥表(RegisterNatives 元组) */
export interface VmSubsetInfo {
  subset: VmSubsetResult
  entries: VmBridgeEntry[]
  /** 签名非 (I)I 被如实排除的方法 idx */
  excluded: number[]
  marked: number[]
  /** 标记失败(长度无法平衡)的方法 idx */
  skippedMark: number[]
}

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
  processedDex: Uint8Array[]         // 处理后的 DEX 文件列表(不含 payload)
  payloadBlobs: Array<Uint8Array | undefined> // 与 processedDex 对齐的加密 payload(nonce+tag+ct)
  keyMaterial: KeyMaterial
  hollowResult?: MethodHollowResult | undefined
  hollowDexIndex: number // hollowResult 对应的 dexFiles 下标(-1 = 无抽取;多 DEX 时抽取结果合并取最后一个)
  encryptedDex?: EncryptedDex | undefined
  vmSubset?: VmSubsetInfo | undefined
  vmSubsetDexIndex: number // vmSubset 对应的 dexFiles 下标(-1 = 无 VM 子集)
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
): { processedDex: Uint8Array; hollowResult?: MethodHollowResult | undefined; encryptedDex?: EncryptedDex | undefined; payloadBlob?: Uint8Array | undefined; vmSubset?: VmSubsetInfo } {
  let processedBytes = dexBytes
  let hollowResult: MethodHollowResult | undefined
  let encryptedDex: EncryptedDex | undefined
  let payloadBlob: Uint8Array | undefined
  let vmSubset: { subset: VmSubsetResult; entries: VmBridgeEntry[]; excluded: number[]; marked: number[]; skippedMark: number[] } | undefined

  // 1. 方法抽取(Method Hollowing)
  if (config.enableMethodHollow) {
    const excludePatterns = parseClassExclusionRules(JSON.stringify(config.classExclusionPatterns))
    hollowResult = hollowMethods(processedBytes, excludePatterns)
    processedBytes = hollowResult.hollowedDex
    // 1.5 VMP 里程碑 B:VM 子集编译 + ACC_NATIVE 标记(必须在加密前——payload 与
    // 壳 DEX 必须一致;必须等长原地补丁——restoreCode/CodeItem 表依赖偏移不变量)。
    // 只注册 (I)I 叶子方法(thunk 固定 (JNIEnv*,jclass,jint));其余保持 stub+惰性还原。
    if (hollowResult.stubMethods.length > 0) {
      const subset = compileVmSubset(hollowResult.extractedCodeItems, hollowResult.stubMethods)
      if (subset.compiled.length > 0) {
        const { entries, excluded } = resolveVmBridgeEntries(processedBytes, subset.compiled.map((c) => c.methodIdx))
        if (entries.length > 0) {
          const markResult = markVmMethodsNative(processedBytes, entries.map((e) => e.methodIdx))
          processedBytes = markResult.dex
          vmSubset = { subset, entries, excluded, marked: markResult.marked, skippedMark: markResult.skipped }
        } else {
          vmSubset = { subset, entries: [], excluded, marked: [], skippedMark: [] }
        }
      }
    }
  }

  // 2. DEX 整体加密
  if (config.enableDexEncryption) {
    // 每文件独立随机 nonce:GCM 禁止同 key+nonce 重用(多 DEX 共用 keyMaterial.nonce
    // 会泄露明文异或并危及认证)——nonce 已内嵌在 payload blob 头,Java 端按 blob 读取
    encryptedDex = encryptDex(
      processedBytes,
      keyMaterial.encryptionKey,
      config.algorithm,
    )
    // payload 不再追加到壳 DEX(否则明文 DEX 仍留在 APK 中,且 ZIP deflate 压缩后
    // 运行时扫 raw APK 找不到 magic)——由调用方写入 assets/droidseal.bin 容器
    payloadBlob = serializePayload(encryptedDex.encryptedPayload)
  }

  return vmSubset === undefined
    ? { processedDex: processedBytes, hollowResult, encryptedDex, payloadBlob }
    : { processedDex: processedBytes, hollowResult, encryptedDex, payloadBlob, vmSubset }
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
  const payloadBlobs: Array<Uint8Array | undefined> = []

  // 1. 生成密钥材料
  const keyMaterial = generateKeyMaterial(
    config.certSha256,
    config.apkSha256,
    "dex",
    config.enableSplitKey,
  )

  // 2. 处理每个 DEX 文件
  let hollowResult: MethodHollowResult | undefined
  let hollowDexIndex = -1
  let encryptedDex: EncryptedDex | undefined
  let vmSubset: VmSubsetInfo | undefined
  let vmSubsetDexIndex = -1

  for (let di = 0; di < dexFiles.length; di += 1) {
    const result = processDexFile(dexFiles[di]!.bytes, config, keyMaterial)
    processedDex.push(result.processedDex)
    payloadBlobs.push(result.payloadBlob)
    if (result.hollowResult) { hollowResult = result.hollowResult; hollowDexIndex = di }
    if (result.encryptedDex) encryptedDex = result.encryptedDex
    // VM 子集与挖空结果一一对应,跟随 hollowDexIndex 记录
    if (result.vmSubset) { vmSubset = result.vmSubset; vmSubsetDexIndex = di }
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

  return { processedDex, payloadBlobs, keyMaterial, hollowResult, hollowDexIndex, encryptedDex, vmSubset, vmSubsetDexIndex, findings }
}
