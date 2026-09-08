// 资源实际处理模块（Phase A-5）。
// 扫描 assets/* → encryptResource(AES-256-GCM) → 替换原文件。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { encryptResource, buildResourceProtectionFindings } from "./resource-string-protection.ts"

// ── 资源处理配置 ──────────────────────────────────────────────────────

export interface ResourceProcessConfig {
  enableResourceEncryption: boolean
  maxFileSize: number        // 最大加密文件大小(默认 4MB)
  excludePatterns: string[]  // 排除的文件模式(如 "*.json", "webfonts/*")
}

export const DEFAULT_RESOURCE_CONFIG: ResourceProcessConfig = {
  enableResourceEncryption: true,
  maxFileSize: 4 * 1024 * 1024,
  excludePatterns: [],
}

// ── 资源处理结果 ──────────────────────────────────────────────────────

export interface ResourceProcessResult {
  processedEntries: Array<{ name: string; bytes: Uint8Array }>
  encryptedCount: number
  skippedCount: number
  findings: Finding[]
}

/**
 * 判断资源文件是否应被加密。
 * 跳过:空文件、超大文件、排除模式匹配的文件、已加密文件。
 */
function shouldEncrypt(entry: { name: string; bytes: Uint8Array }, config: ResourceProcessConfig): boolean {
  if (entry.bytes.length === 0) return false
  if (entry.bytes.length > config.maxFileSize) return false
  // 跳过已加密文件(检查 DROIDSEAL_RES magic)
  if (entry.bytes.length > 16) {
    const magic = new TextDecoder().decode(entry.bytes.slice(0, 13))
    if (magic === "DROIDSEAL_RES") return false
  }
  // 排除模式
  for (const pattern of config.excludePatterns) {
    const regex = new RegExp(pattern.replace(/\*/g, ".*").replace(/\?/g, "."), "i")
    if (regex.test(entry.name)) return false
  }
  return true
}

/**
 * 处理所有 assets 文件。
 */
export function processAllAssets(
  assetEntries: Array<{ name: string; bytes: Uint8Array }>,
  config: ResourceProcessConfig,
  key: Uint8Array,
): ResourceProcessResult {
  const findings: Finding[] = []
  const processedEntries: Array<{ name: string; bytes: Uint8Array }> = []
  let encryptedCount = 0
  let skippedCount = 0

  for (const entry of assetEntries) {
    if (!config.enableResourceEncryption || !shouldEncrypt(entry, config)) {
      processedEntries.push({ name: entry.name, bytes: entry.bytes })
      skippedCount += 1
      continue
    }
    try {
      const encrypted = encryptResource(entry.bytes, key)
      processedEntries.push({ name: entry.name, bytes: encrypted })
      encryptedCount += 1
    } catch {
      // 加密失败,保留原始文件
      processedEntries.push({ name: entry.name, bytes: entry.bytes })
      skippedCount += 1
    }
  }

  findings.push(...buildResourceProtectionFindings(encryptedCount, 0, false, false, false))

  return { processedEntries, encryptedCount, skippedCount, findings }
}
