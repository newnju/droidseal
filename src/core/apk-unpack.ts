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

    // 从 Local File Header 读取数据
    const dataOffset = localHeaderOffset + 30
      + view.getUint16(localHeaderOffset + 26, true)
      + view.getUint16(localHeaderOffset + 28, true)
    const dataSize = compressionMethod === 0 ? uncompressedSize : compressedSize

    if (dataOffset + dataSize <= bytes.length) {
      entries.push({
        name,
        bytes: bytes.slice(dataOffset, dataOffset + dataSize),
        compressed: compressionMethod !== 0,
        compressionMethod,
        crc32,
      })
    }

    cursor += 46 + nameLen + extraLen + commentLen
  }
  return entries
}

/**
 * 解包 APK(ZIP)文件，分类提取所有条目。
 */
export async function unpackApk(apkPath: string): Promise<ApkContents> {
  const bytes = new Uint8Array(await readFile(apkPath))
  const entries = extractRawZipEntries(bytes)

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
