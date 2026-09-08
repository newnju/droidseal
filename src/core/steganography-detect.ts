// 隐写式 DEX 存储检测（#86）。
// 检测 classes.dex 的 ZIP 条目大小与 file_size 声明不一致——
// mocika-shield 将加密 payload 追加到 classes.dex 的 file_size 边界外，
// apktool/jadx 只读到 file_size 所以完全不可见。
// 纯 ZIP 结构分析，失败关闭。
import type { Finding } from "./types.ts"

export interface SteganographyResult {
  entryName: string
  zipEntrySize: number
  declaredSize: number
  extraBytes: number
  isSuspicious: boolean
}

// 从 ZIP 条目的 local file header 读取 file_size（压缩/未压缩大小）
function readZipEntrySizes(bytes: Uint8Array, offset: number): { compressed: number; uncompressed: number; nameLen: number; extraLen: number } | undefined {
  if (offset + 30 > bytes.length) return undefined
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  // Local file header signature = 0x04034b50
  if (view.getUint32(offset, true) !== 0x04034b50) return undefined
  const compressionMethod = view.getUint16(offset + 8, true)
  const compressedSize = view.getUint32(offset + 18, true)
  const uncompressedSize = view.getUint32(offset + 22, true)
  const nameLen = view.getUint16(offset + 26, true)
  const extraLen = view.getUint16(offset + 28, true)
  return {
    compressed: compressionMethod === 0 ? uncompressedSize : compressedSize,
    uncompressed: uncompressedSize,
    nameLen,
    extraLen,
  }
}

export function detectSteganography(
  dexBytes: Uint8Array,
  zipBytes: Uint8Array,
  entryName: string,
): SteganographyResult | undefined {
  // DEX header file_size 字段在 offset 32 (4 bytes, little-endian)
  if (dexBytes.length < 36) return undefined
  const view = new DataView(dexBytes.buffer, dexBytes.byteOffset, dexBytes.byteLength)
  const declaredSize = view.getUint32(0x20, true) // file_size
  const actualSize = dexBytes.length

  const extraBytes = actualSize - declaredSize
  const isSuspicious = extraBytes > 64 // 至少 64 字节差异才可疑（DEX header padding 正常 <32）

  return {
    entryName,
    zipEntrySize: actualSize,
    declaredSize,
    extraBytes,
    isSuspicious,
  }
}

// 扫描 APK 中所有 classes*.dex 的隐写特征
export function scanApkSteganography(
  entries: Array<{ name: string; bytes: Uint8Array }>,
): SteganographyResult[] {
  const results: SteganographyResult[] = []
  for (const entry of entries) {
    if (!/^classes\d*\.dex$/.test(entry.name)) continue
    const result = detectSteganography(entry.bytes, entry.bytes, entry.name)
    if (result) results.push(result)
  }
  return results
}

export function buildSteganographyFindings(results: SteganographyResult[]): Finding[] {
  const suspicious = results.filter((r) => r.isSuspicious)
  if (suspicious.length === 0) return []
  return suspicious.map((r) => ({
    severity: "high" as const,
    confidence: "high" as const,
    code: "DEX_STEGANOGRAPHY",
    title: `${r.entryName} 存在隐写式存储(${r.extraBytes} 字节额外数据)`,
    detail: `${r.entryName} 的 ZIP 条目大小(${r.zipEntrySize} 字节)大于 DEX header 声明的 file_size(${r.declaredSize} 字节),差异 ${r.extraBytes} 字节。这可能是 mocika-shield 式隐写加密——加密 payload 追加到 file_size 边界外,apktool/jadx 完全不可见。`,
    recommendation: "检查 classes.dex 末尾的额外数据——可能是加密的原始 DEX 或其他 payload。用 hex editor 查看 file_size 偏移后的内容。",
    evidence: `${r.entryName}: zipSize=${r.zipEntrySize} declaredSize=${r.declaredSize} extra=${r.extraBytes}`,
  }))
}
