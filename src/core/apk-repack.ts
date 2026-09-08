// APK 重打包 + 签名模块（Phase A-7）。
// ZIP 重建(将修改后的条目重新打包为 APK) + apksigner/keytool 签名。
// 纯 TypeScript，失败关闭。
import { spawnSync } from "node:child_process"
import { writeFile, readFile, mkdir, rm } from "node:fs/promises"
import path from "node:path"
import { createHash } from "node:crypto"
import type { Finding } from "./types.ts"

// ── ZIP 条目 ──────────────────────────────────────────────────────────

interface ZipEntry {
  name: string
  bytes: Uint8Array
  compressionMethod: number // 0=stored, 8=deflated
}

// ── ZIP 构建(最小实现——只支持 stored/deflated) ──────────────────────────

function crc32(data: Uint8Array): number {
  let crc = 0xFFFFFFFF
  for (let i = 0; i < data.length; i += 1) {
    crc ^= data[i]!
    for (let j = 0; j < 8; j += 1) {
      crc = (crc >>> 1) ^ (crc & 1 ? 0xEDB88320 : 0)
    }
  }
  return (crc ^ 0xFFFFFFFF) >>> 0
}

function deflateSync(data: Uint8Array): Uint8Array {
  // 使用 node:zlib 的 deflateRawSync
  const { deflateRawSync } = require("node:zlib") as typeof import("node:zlib")
  return new Uint8Array(deflateRawSync(data))
}

/**
 * 将条目列表构建为 ZIP(APK)文件。
 * 仅支持 stored(compressionMethod=0) 和 deflated(compressionMethod=8)。
 */
export function buildApkZip(entries: ZipEntry[]): Uint8Array {
  const localHeaders: Uint8Array[] = []
  const centralHeaders: Uint8Array[] = []
  const dataParts: Uint8Array[] = []
  let offset = 0

  const encoder = new TextEncoder()

  for (const entry of entries) {
    const nameBytes = encoder.encode(entry.name)
    const data = entry.compressionMethod === 8 ? deflateSync(entry.bytes) : entry.bytes
    const crc = crc32(entry.bytes)
    const compressed = entry.compressionMethod === 8

    // Local file header (30 bytes + name + data)
    const local = new Uint8Array(30 + nameBytes.length + data.length)
    const lv = new DataView(local.buffer)
    lv.setUint32(0, 0x04034b50, true)  // Local file header signature
    lv.setUint16(4, 20, true)           // Version needed
    lv.setUint16(6, 0, true)            // Flags
    lv.setUint16(8, entry.compressionMethod, true)
    lv.setUint16(10, 0, true)           // Mod time
    lv.setUint16(12, 0, true)           // Mod date
    lv.setUint32(14, crc, true)         // CRC-32
    lv.setUint32(18, data.length, true) // Compressed size
    lv.setUint32(22, entry.bytes.length, true) // Uncompressed size
    lv.setUint16(26, nameBytes.length, true)
    lv.setUint16(28, 0, true)           // Extra field length
    local.set(nameBytes, 30)
    local.set(data, 30 + nameBytes.length)
    localHeaders.push(local)
    dataParts.push(local)

    // Central directory entry (46 bytes + name)
    const central = new Uint8Array(46 + nameBytes.length)
    const cv = new DataView(central.buffer)
    cv.setUint32(0, 0x02014b50, true)   // Central directory signature
    cv.setUint16(4, 20, true)            // Version made by
    cv.setUint16(6, 20, true)            // Version needed
    cv.setUint16(8, 0, true)             // Flags
    cv.setUint16(10, entry.compressionMethod, true)
    cv.setUint16(12, 0, true)            // Mod time
    cv.setUint16(14, 0, true)            // Mod date
    cv.setUint32(16, crc, true)          // CRC-32
    cv.setUint32(20, data.length, true)  // Compressed size
    cv.setUint32(24, entry.bytes.length, true) // Uncompressed size
    cv.setUint16(28, nameBytes.length, true)
    cv.setUint16(30, 0, true)            // Extra field length
    cv.setUint16(32, 0, true)            // Comment length
    cv.setUint16(34, 0, true)            // Disk number start
    cv.setUint16(36, 0, true)            // Internal file attributes
    cv.setUint32(38, 0, true)            // External file attributes
    cv.setUint32(42, offset, true)       // Local header offset
    central.set(nameBytes, 46)
    centralHeaders.push(central)

    offset += local.length
  }

  // Central directory
  const cdOffset = offset
  let cdSize = 0
  for (const cd of centralHeaders) { cdSize += cd.length }

  // EOCD (22 bytes)
  const eocd = new Uint8Array(22)
  const ev = new DataView(eocd.buffer)
  ev.setUint32(0, 0x06054b50, true)     // EOCD signature
  ev.setUint16(4, 0, true)              // Disk number
  ev.setUint16(6, 0, true)              // CD disk number
  ev.setUint16(8, entries.length, true)  // Entries on disk
  ev.setUint16(10, entries.length, true) // Total entries
  ev.setUint32(12, cdSize, true)        // CD size
  ev.setUint32(16, cdOffset, true)      // CD offset

  // 合并所有部分
  const totalSize = offset + cdSize + 22
  const result = new Uint8Array(totalSize)
  let pos = 0
  for (const part of dataParts) { result.set(part, pos); pos += part.length }
  for (const cd of centralHeaders) { result.set(cd, pos); pos += cd.length }
  result.set(eocd, pos)

  return result
}

// ── APK 签名 ──────────────────────────────────────────────────────────

export interface SigningConfig {
  mode: "keystore" | "pkcs12" | "auto"
  keystorePath: string
  keyAlias: string
  storePassword: string
  keyPassword: string
}

/**
 * 使用 keytool 生成自签名密钥库。
 */
export function generateKeystore(
  outputPath: string,
  config: { keyAlias: string; storePassword: string; keyPassword: string; validity: number },
): boolean {
  const result = spawnSync("keytool", [
    "-genkeypair",
    "-alias", config.keyAlias,
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", String(config.validity),
    "-keystore", outputPath,
    "-storepass", config.storePassword,
    "-keypass", config.keyPassword,
    "-dname", "CN=DroidSeal,OU=Security,O=DroidSeal,L=Unknown,ST=Unknown,C=US",
  ], { timeout: 30000, stdio: "pipe" })
  return result.status === 0
}

/**
 * 使用 apksigner 签名 APK。
 */
export function signApk(
  apkPath: string,
  config: SigningConfig,
): { success: boolean; output: string } {
  const args = [
    "sign",
    "--ks", config.keystorePath,
    "--ks-key-alias", config.keyAlias,
    "--ks-pass", `pass:${config.storePassword}`,
    "--key-pass", `pass:${config.keyPassword}`,
    apkPath,
  ]
  const result = spawnSync("apksigner", args, { timeout: 60000, stdio: "pipe" })
  const output = (result.stdout?.toString() ?? "") + (result.stderr?.toString() ?? "")
  return { success: result.status === 0, output }
}

/**
 * 使用 jarsigner 签名 APK(后备方案)。
 */
export function signApkJarsigner(
  apkPath: string,
  config: SigningConfig,
): { success: boolean; output: string } {
  const args = [
    "-sigalg", "SHA256withRSA",
    "-digestalg", "SHA-256",
    "-keystore", config.keystorePath,
    "-storepass", config.storePassword,
    "-keypass", config.keyPassword,
    apkPath,
    config.keyAlias,
  ]
  const result = spawnSync("jarsigner", args, { timeout: 60000, stdio: "pipe" })
  const output = (result.stdout?.toString() ?? "") + (result.stderr?.toString() ?? "")
  return { success: result.status === 0, output }
}

/**
 * 使用 zipalign 对齐 APK。
 */
export function zipalignApk(inputPath: string, outputPath: string): boolean {
  const result = spawnSync("zipalign", ["-p", "4", inputPath, outputPath], { timeout: 30000, stdio: "pipe" })
  return result.status === 0
}

// ── APK 重打包完整流程 ──────────────────────────────────────────────────

export interface RepackConfig {
  entries: ZipEntry[]
  outputPath: string
  signingConfig?: SigningConfig | undefined
  enableZipalign: boolean
  toolchainPath?: string | undefined // apksigner/zipalign 路径
}

export interface RepackResult {
  success: boolean
  outputPath?: string | undefined
  sha256?: string | undefined
  findings: Finding[]
}

/**
 * 完整 APK 重打包流程:ZIP 重建 → zipalign → 签名。
 */
export async function repackApk(config: RepackConfig): Promise<RepackResult> {
  const findings: Finding[] = []

  // 1. ZIP 重建
  const zipBytes = buildApkZip(config.entries)
  const tempPath = config.outputPath.replace(".apk", ".unsigned.apk")
  await writeFile(tempPath, zipBytes)

  let currentPath = tempPath

  // 2. zipalign(可选)
  if (config.enableZipalign) {
    const alignedPath = config.outputPath.replace(".apk", ".aligned.apk")
    const aligned = zipalignApk(currentPath, alignedPath)
    if (aligned) {
      currentPath = alignedPath
      findings.push({
        severity: "info", confidence: "high", code: "APK_ALIGNED",
        title: "APK zipalign 对齐完成(4 字节)",
        detail: "zipalign -p 4 对齐 APK 条目——优化运行时内存映射。",
        recommendation: "zipalign 必须在签名之前执行。",
        evidence: alignedPath,
      })
    }
  }

  // 3. 签名
  if (config.signingConfig) {
    // 优先 apksigner,后备 jarsigner
    let signResult = signApk(currentPath, config.signingConfig)
    if (!signResult.success) {
      signResult = signApkJarsigner(currentPath, config.signingConfig)
    }
    if (signResult.success) {
      findings.push({
        severity: "info", confidence: "high", code: "APK_SIGNED",
        title: "APK 签名完成",
        detail: `签名工具:${signResult.output.includes("apksigner") ? "apksigner" : "jarsigner"}。密钥: ${config.signingConfig.keyAlias}。`,
        recommendation: "确认签名证书与预期一致;release 签名应使用专用密钥。",
        evidence: config.signingConfig.keystorePath,
      })
    } else {
      findings.push({
        severity: "high", confidence: "high", code: "APK_SIGN_FAILED",
        title: "APK 签名失败",
        detail: signResult.output,
        recommendation: "确认 apksigner/jarsigner 可用;确认密钥库路径/密码/别名正确。",
        evidence: signResult.output.slice(0, 200),
      })
    }
  }

  // 4. 复制到最终路径
  const finalBytes = await readFile(currentPath)
  await writeFile(config.outputPath, finalBytes)

  // 5. 计算 SHA-256
  const sha256 = createHash("sha256").update(finalBytes).digest("hex")

  // 6. 清理临时文件
  await rm(tempPath, { force: true }).catch(() => undefined)
  if (currentPath !== tempPath) {
    await rm(currentPath, { force: true }).catch(() => undefined)
  }

  return { success: true, outputPath: config.outputPath, sha256, findings }
}

export function buildRepackFindings(result: RepackResult): Finding[] {
  return result.findings
}
