// APK 解包模块（Phase A-1）。
// 读取 APK(ZIP) → 提取 classes.dex / lib/*.so / assets/* / AndroidManifest.xml
// 复用 apk-audit.ts 的 parseZipEntries;提供分类提取接口。
// 纯 TypeScript，失败关闭。
import path from "node:path"
import type { Finding } from "./types.ts"

// ── ZIP 条目结构 ──────────────────────────────────────────────────────

export interface ApkEntry {
  name: string
  bytes: Uint8Array
  compressed: boolean
  compressionMethod: number
  crc32: number
}

export interface ApkContents {
  entries: ApkEntry[]
  dexFiles: ApkEntry[]        // classes.dex, classes2.dex, ...
  soFiles: ApkEntry[]         // lib/arm64-v8a/*.so, lib/armeabi-v7a/*.so, ...
  assetFiles: ApkEntry[]      // assets/*
  manifest: ApkEntry | undefined // AndroidManifest.xml
  resourceArsc: ApkEntry | undefined // resources.arsc
  otherFiles: ApkEntry[]      // META-INF/, res/, etc.
  packageName: string
}

// ── APK 解包 ──────────────────────────────────────────────────────────

import { spawnSync } from "node:child_process"
import { readFile } from "node:fs/promises"
import { inflateRawSync } from "node:zlib"

function extractRawZipEntries(bytes: Uint8Array): ApkEntry[] {
  const entries: ApkEntry[] = []
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)

  // 找到 ZIP EOCD (End of Central Directory)
  let eocdOffset = bytes.length - 22
  while (eocdOffset >= 0) {
    if (view.getUint32(eocdOffset, true) === 0x06054b50) break
    eocdOffset -= 1
  }
  if (eocdOffset < 0) return entries

  const cdSize = view.getUint32(eocdOffset + 12, true)
  const cdOffset = view.getUint32(eocdOffset + 16, true)
  const entryCount = view.getUint16(eocdOffset + 10, true)

  // 遍历 Central Directory
  let cursor = cdOffset
  for (let i = 0; i < entryCount && cursor + 46 <= cdOffset + cdSize; i += 1) {
    if (view.getUint32(cursor, true) !== 0x02014b50) break
    const compressionMethod = view.getUint16(cursor + 10, true)
    const crc32 = view.getUint32(cursor + 16, true)
    const compressedSize = view.getUint32(cursor + 20, true)
    const uncompressedSize = view.getUint32(cursor + 24, true)
    const nameLen = view.getUint16(cursor + 28, true)
    const extraLen = view.getUint16(cursor + 30, true)
    const commentLen = view.getUint16(cursor + 32, true)
    const localHeaderOffset = view.getUint32(cursor + 42, true)
    const nameBytes = bytes.slice(cursor + 46, cursor + 46 + nameLen)
    const name = new TextDecoder("utf-8", { fatal: false }).decode(nameBytes)

    // 从 Local File Header 读取数据——必须先验证 LFH signature
    if (localHeaderOffset + 30 > bytes.length) { cursor += 46 + nameLen + extraLen + commentLen; continue }
    if (view.getUint32(localHeaderOffset, true) !== 0x04034b50) { cursor += 46 + nameLen + extraLen + commentLen; continue }
    const localNameLen = view.getUint16(localHeaderOffset + 26, true)
    const localExtraLen = view.getUint16(localHeaderOffset + 28, true)
    const dataOffset = localHeaderOffset + 30 + localNameLen + localExtraLen
    const dataSize = compressionMethod === 0 ? uncompressedSize : compressedSize

    // 防护:跳过大小异常的条目(dataOffset 超出 APK)。dataSize===0 且 uncompressedSize===0
    // 是合法空文件(如 cordova.js),不得丢弃——否则旧 MANIFEST.MF 引用悬空、v1 签名校验失败
    const isEmptyFile = dataSize === 0 && uncompressedSize === 0
    if ((!isEmptyFile && dataSize === 0) || dataOffset > bytes.length || (!isEmptyFile && dataOffset + dataSize > bytes.length)) {
      cursor += 46 + nameLen + extraLen + commentLen
      continue
    }

    // 防护:LFH 签名已验证,localNameLen/localExtraLen 均为 u16 有界;dataOffset+dataSize 越界检查兜底

    // 防护:uncompressedSize 不应超过 APK 本身大小的 10 倍(真正的 zip bomb 防护)
    // 这里不限 50MB,而是动态计算:单个条目不可能比整个 APK 大太多倍
    const apkSize = bytes.length
    const maxReasonable = Math.max(apkSize * 10, 200 * 1024 * 1024) // APK大小×10 或 200MB 取较大值
    if (uncompressedSize > maxReasonable) {
      cursor += 46 + nameLen + extraLen + commentLen
      continue
    }

    let entryBytes = bytes.slice(dataOffset, dataOffset + dataSize)
    // deflate 压缩的条目需要解压;maxOutputLength 硬性截断解压输出(zip bomb 时 zlib 直接抛错,不产生超大 buffer)
    if (compressionMethod === 8 && entryBytes.length > 0 && entryBytes.length <= apkSize) {
      try {
        const inflated = inflateRawSync(entryBytes, { maxOutputLength: maxReasonable })
        entryBytes = new Uint8Array(inflated)
      } catch {
        // 解压失败保留压缩原始字节;compressed 标志保持 true,
        // repack 侧 buildApkZip 对含 PK 头的字节不再二次 deflate(见 apk-repack.ts)
      }
    }
    // 只过滤解析失败的条目;空文件(合法条目)保留——丢条目会让旧 v1 签名引用悬空
    if (compressionMethod !== 0 && entryBytes.length === 0 && uncompressedSize > 0) {
      cursor += 46 + nameLen + extraLen + commentLen
      continue
    }
    entries.push({
      name,
      bytes: entryBytes,
      compressed: compressionMethod !== 0,
      compressionMethod,
      crc32,
    })

    cursor += 46 + nameLen + extraLen + commentLen
  }
  return entries
}

/**
 * 解包 APK(ZIP)文件，分类提取所有条目。
 */
export async function unpackApk(apkPath: string): Promise<ApkContents> {
  const bytes = new Uint8Array(await readFile(apkPath))
  const rawEntries = extractRawZipEntries(bytes)

  // 空文件是合法条目(如 cordova.js,method=8/usize=0)——解析失败的条目已在
  // extractRawZipEntries 内跳过,这里不再按字节长度过滤,避免丢条目
  const entries = rawEntries

  const dexFiles = entries.filter((e) => /^classes\d*\.dex$/.test(e.name))
  const soFiles = entries.filter((e) => e.name.startsWith("lib/") && e.name.endsWith(".so"))
  const assetFiles = entries.filter((e) => e.name.startsWith("assets/"))
  const manifest = entries.find((e) => e.name === "AndroidManifest.xml")
  const resourceArsc = entries.find((e) => e.name === "resources.arsc")
  const otherFiles = entries.filter((e) =>
    !e.name.startsWith("lib/") &&
    !e.name.startsWith("assets/") &&
    !/^classes\d*\.dex$/.test(e.name) &&
    e.name !== "AndroidManifest.xml" &&
    e.name !== "resources.arsc"
  )

  return {
    entries,
    dexFiles,
    soFiles,
    assetFiles,
    manifest,
    resourceArsc,
    otherFiles,
    packageName: "",
  }
}

/**
 * 分析解包结果，生成 Finding。
 */
export function buildUnpackFindings(contents: ApkContents): Finding[] {
  const findings: Finding[] = []
  findings.push({
    severity: "info",
    confidence: "high",
    code: "APK_UNPACKED",
    title: `APK 解包完成:${contents.entries.length} 个条目`,
    detail: `DEX: ${contents.dexFiles.length}; SO: ${contents.soFiles.length}; Assets: ${contents.assetFiles.length}; Manifest: ${contents.manifest ? "✓" : "✗"}; resources.arsc: ${contents.resourceArsc ? "✓" : "✗"}`,
    recommendation: "确认解包完整性后进行加固处理。",
    evidence: `entries=${contents.entries.length} dex=${contents.dexFiles.length} so=${contents.soFiles.length} assets=${contents.assetFiles.length}`,
  })
  if (contents.dexFiles.length === 0) {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "APK_NO_DEX",
      title: "APK 中未找到 classes.dex",
      detail: "APK 中未发现任何 classes*.dex 文件——可能是 AAB 或非标准格式。",
      recommendation: "确认输入是否为有效 APK 文件。",
      evidence: "no-dex",
    })
  }
  return findings
}
