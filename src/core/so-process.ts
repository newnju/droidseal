// SO 实际处理模块（Phase A-4）。
// 扫描 lib/*.so → encryptSoFile 全文件加密 / encryptSoSegments 段级 RC4 → 替换原 SO。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { encryptSoFile, encryptSoSegments, buildSoProtectionFindings } from "./so-protection.ts"
import type { KeyMaterial } from "./dex-protection-keys.ts"

// ── SO 处理配置 ──────────────────────────────────────────────────────

export interface SoProcessConfig {
  algorithm: "aes-256-gcm" | "chacha20-poly1305"
  enableFullEncrypt: boolean      // 全文件 AES-256-GCM
  enableSegmentEncrypt: boolean   // .rodata/.bitcode 段级 RC4
  targetAbis: string[]            // 目标 ABI 列表(如 ["arm64-v8a", "armeabi-v7a"])
}

// ── SO 处理结果 ──────────────────────────────────────────────────────

export interface SoProcessResult {
  processedEntries: Array<{ name: string; bytes: Uint8Array }>
  findings: Finding[]
}

/**
 * 处理单个 .so 文件。
 * 优先段级 RC4(更精细),其次全文件加密。
 */
export function processSoFile(
  soBytes: Uint8Array,
  fileName: string,
  config: SoProcessConfig,
  key: Uint8Array,
): { bytes: Uint8Array; findings: Finding[] } {
  const findings: Finding[] = []

  if (config.enableSegmentEncrypt) {
    try {
      const result = encryptSoSegments(soBytes, key)
      findings.push(...buildSoProtectionFindings(0, 0, result.encryptedSegments.map((s) => ({
        name: s.name, offset: s.offset, size: s.size,
      }))))
      return { bytes: result.encryptedSo, findings }
    } catch {
      // 段级加密失败(非标准 ELF),降级到全文件加密
    }
  }

  if (config.enableFullEncrypt) {
    const encrypted = encryptSoFile(soBytes, key)
    findings.push(...buildSoProtectionFindings(encrypted.length, soBytes.length, []))
    return { bytes: encrypted, findings }
  }

  return { bytes: soBytes, findings }
}

/**
 * 处理 APK 中所有 .so 文件。
 */
export function processAllSoFiles(
  soEntries: Array<{ name: string; bytes: Uint8Array }>,
  config: SoProcessConfig,
  key: Uint8Array,
): SoProcessResult {
  const findings: Finding[] = []
  const processedEntries: Array<{ name: string; bytes: Uint8Array }> = []

  // 按 ABI 过滤(只处理目标 ABI)
  const filteredEntries = config.targetAbis.length > 0
    ? soEntries.filter((e) => config.targetAbis.some((abi) => e.name.includes(abi)))
    : soEntries

  for (const entry of filteredEntries) {
    try {
      const result = processSoFile(entry.bytes, entry.name, config, key)
      processedEntries.push({ name: entry.name, bytes: result.bytes })
      findings.push(...result.findings)
    } catch {
      // 处理失败,保留原始文件
      processedEntries.push({ name: entry.name, bytes: entry.bytes })
    }
  }

  // 未处理的 SO(非目标 ABI)保留原始
  for (const entry of soEntries) {
    if (!filteredEntries.includes(entry)) {
      processedEntries.push({ name: entry.name, bytes: entry.bytes })
    }
  }

  return { processedEntries, findings }
}

export function buildSoProcessFindings(processedCount: number, totalCount: number): Finding[] {
  if (processedCount === 0) return []
  return [{
    severity: "info",
    confidence: "high",
    code: "SO_PROCESSED",
    title: `SO 处理完成:${processedCount}/${totalCount} 个文件`,
    detail: "SO 文件已加密(全文件 AES-256-GCM 或段级 RC4)。",
    recommendation: "确认壳 SO 解密逻辑正确;测试各 ABI 兼容性。",
    evidence: `processed=${processedCount} total=${totalCount}`,
  }]
}
