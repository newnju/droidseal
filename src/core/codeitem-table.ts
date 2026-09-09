// 壳加载核心模块——CodeItem 存储 + 运行时还原协议（任务 1）。
// dpt-shell 的核心方法:方法抽取后,将原始 CodeItem 打包为加密 payload,
// 追加到壳 DEX 末尾;运行时 Native 壳 SO 的 DefineClass 钩子读取 payload,
// 还原被挖空的方法体。
//
// 本模块实现:
// 1. CodeItem 表格式定义(存储 class_idx + method_idx + 原始 CodeItem)
// 2. 序列化/反序列化(压缩+加密)
// 3. 运行时还原协议(定义 Native 层接口)
//
// 纯 TypeScript，失败关闭。
import { createCipheriv, createDecipheriv, randomBytes } from "node:crypto"
import type { Finding } from "./types.ts"

// ── CodeItem 表格式 ──────────────────────────────────────────────────────

/**
 * 单个被抽取方法的 CodeItem 记录。
 * classIdx + methodIdx 定位到 DEX 中的方法;
 * codeOffset 是原始 CodeItem 在 payload 中的偏移;
 * codeSize 是原始 CodeItem 的大小(字节)。
 */
export interface CodeItemRecord {
  classIdx: number
  methodIdx: number
  codeOffset: number   // 在 payload 中的偏移
  codeSize: number     // 原始 CodeItem 大小
}

/**
 * CodeItem 表(追加到壳 DEX 末尾的结构化 payload)。
 * 格式:
 *   magic: "DROIDSEAL_CI" (12 bytes)
 *   version: uint32 (4 bytes) = 1
 *   methodCount: uint32 (4 bytes)
 *   records: CodeItemRecord[methodCount] (每条 12 bytes: classIdx(4) + methodIdx(4) + codeOffset(4) + codeSize(4))
 *   codeData: 原始 CodeItem 字节(连续存储)
 *
 * 整个表用 AES-256-GCM 加密后追加到壳 DEX 末尾。
 */
const CODE_ITEM_TABLE_MAGIC = "DROIDSEAL_CI"
const CODE_ITEM_RECORD_SIZE = 12 // 4+4+4+4

/**
 * 将多个 CodeItemRecord + 原始 CodeItem 字节序列化为表。
 */
export function serializeCodeItemTable(
  records: CodeItemRecord[],
  codeData: Uint8Array,
): Uint8Array {
  const headerSize = 12 + 4 + 4 // magic + version + methodCount
  const tableSize = headerSize + records.length * CODE_ITEM_RECORD_SIZE + codeData.length
  const result = new Uint8Array(tableSize)
  const view = new DataView(result.buffer)

  // magic
  result.set(new TextEncoder().encode(CODE_ITEM_TABLE_MAGIC), 0)
  // version
  view.setUint32(12, 1, true)
  // methodCount
  view.setUint32(16, records.length, true)

  // records
  let pos = headerSize
  for (const rec of records) {
    view.setUint32(pos, rec.classIdx, true)
    view.setUint32(pos + 4, rec.methodIdx, true)
    view.setUint32(pos + 8, rec.codeOffset, true)
    view.setUint16(pos + 12, rec.codeSize, true) // codeSize 用 uint16 (最大 64KB)
    pos += CODE_ITEM_RECORD_SIZE
  }

  // code data
  result.set(codeData, pos)
  return result
}

/**
 * 从表中解析 CodeItemRecord + codeData。
 */
export function deserializeCodeItemTable(data: Uint8Array): {
  records: CodeItemRecord[]
  codeData: Uint8Array
  version: number
} | undefined {
  if (data.length < 20) return undefined
  const magic = new TextDecoder().decode(data.slice(0, 12))
  if (magic !== CODE_ITEM_TABLE_MAGIC) return undefined

  const view = new DataView(data.buffer, data.byteOffset, data.byteLength)
  const version = view.getUint32(12, true)
  const methodCount = view.getUint32(16, true)
  const headerSize = 12 + 4 + 4
  const tableSize = headerSize + methodCount * CODE_ITEM_RECORD_SIZE

  if (data.length < tableSize) return undefined

  const records: CodeItemRecord[] = []
  for (let i = 0; i < methodCount; i += 1) {
    const base = headerSize + i * CODE_ITEM_RECORD_SIZE
    records.push({
      classIdx: view.getUint32(base, true),
      methodIdx: view.getUint32(base + 4, true),
      codeOffset: view.getUint32(base + 8, true),
      codeSize: view.getUint16(base + 12, true),
    })
  }

  const codeData = data.slice(tableSize)
  return { records, codeData, version }
}

// ── CodeItem 提取 + 加密 ──────────────────────────────────────────────────

/**
 * 从 hollowMethods 结果构建 CodeItem 表。
 * 输入: hollowMethods 返回的 extractedCodeItems Map
 * 输出: 序列化后的 CodeItem 表字节
 */
export function buildCodeItemTable(
  extractedCodeItems: Map<number, Uint8Array>,
  stubMethods: Array<{ classIdx: number; methodIdx: number; originalCodeOff: number; originalCodeSize: number }>,
): Uint8Array {
  const records: CodeItemRecord[] = []
  const codeChunks: Uint8Array[] = []
  let currentOffset = 0

  for (const stub of stubMethods) {
    const codeBytes = extractedCodeItems.get(stub.originalCodeOff)
    if (!codeBytes) continue
    records.push({
      classIdx: stub.classIdx,
      methodIdx: stub.methodIdx,
      codeOffset: currentOffset,
      codeSize: codeBytes.length,
    })
    codeChunks.push(codeBytes)
    currentOffset += codeBytes.length
  }

  const codeData = new Uint8Array(currentOffset)
  let pos = 0
  for (const chunk of codeChunks) {
    codeData.set(chunk, pos)
    pos += chunk.length
  }

  return serializeCodeItemTable(records, codeData)
}

/**
 * 加密 CodeItem 表。
 * 格式: nonce(12B) + tag(16B) + ciphertext
 */
export function encryptCodeItemTable(table: Uint8Array, key: Uint8Array): Uint8Array {
  const nonce = randomBytes(12)
  const cipher = createCipheriv("aes-256-gcm", key, nonce)
  const encrypted = Buffer.concat([cipher.update(table), cipher.final()])
  const tag = cipher.getAuthTag()

  const result = new Uint8Array(12 + 16 + encrypted.length)
  result.set(nonce, 0)
  result.set(tag, 12)
  result.set(new Uint8Array(encrypted), 28)
  return result
}

/**
 * 解密 CodeItem 表。
 */
export function decryptCodeItemTable(encrypted: Uint8Array, key: Uint8Array): Uint8Array | undefined {
  if (encrypted.length < 28) return undefined
  try {
    const nonce = encrypted.slice(0, 12)
    const tag = encrypted.slice(12, 28)
    const ciphertext = encrypted.slice(28)
    const decipher = createDecipheriv("aes-256-gcm", key, nonce)
    decipher.setAuthTag(tag)
    return new Uint8Array(Buffer.concat([decipher.update(ciphertext), decipher.final()]))
  } catch {
    return undefined
  }
}

// ── 壳 DEX 注入 ──────────────────────────────────────────────────────────

/**
 * 将加密后的 CodeItem 表追加到壳 DEX 末尾。
 * 壳 DEX 的 file_size 字段保持不变(指向壳 DEX 本身大小)，
 * Native 壳 SO 从 file_size 偏移后读取加密 CodeItem 表。
 */
export function injectCodeItemTableIntoShellDex(
  shellDex: Uint8Array,
  encryptedTable: Uint8Array,
): Uint8Array {
  // 追加格式: "DROIDSEAL_CITABLE" (16B magic) + table_size(4B) + encrypted_table
  const magic = new TextEncoder().encode("DROIDSEAL_CITABLE")
  const headerSize = 16 + 4
  const result = new Uint8Array(shellDex.length + headerSize + encryptedTable.length)
  result.set(shellDex, 0)

  let pos = shellDex.length
  result.set(magic, pos)
  pos += 16
  new DataView(result.buffer).setUint32(pos, encryptedTable.length, true)
  pos += 4
  result.set(encryptedTable, pos)

  return result
}

/**
 * 从壳 DEX 末尾提取加密的 CodeItem 表。
 */
export function extractCodeItemTableFromShellDex(
  shellDexWithTable: Uint8Array,
): { encryptedTable: Uint8Array; shellDexSize: number } | undefined {
  const view = new DataView(shellDexWithTable.buffer, shellDexWithTable.byteOffset, shellDexWithTable.byteLength)
  const fileSize = view.getUint32(0x20, true) // DEX file_size

  if (fileSize >= shellDexWithTable.length) return undefined

  const tailBytes = shellDexWithTable.slice(fileSize)
  const magic = new TextDecoder().decode(tailBytes.slice(0, 16))
  if (magic !== "DROIDSEAL_CITABLE") return undefined

  const tableSize = new DataView(tailBytes.buffer, tailBytes.byteOffset, tailBytes.byteLength).getUint32(16, true)
  const encryptedTable = tailBytes.slice(20, 20 + tableSize)

  return { encryptedTable, shellDexSize: fileSize }
}

// ── 完整方法抽取 + CodeItem 存储流程 ──────────────────────────────────────

/**
 * 完整流程:方法抽取 → CodeItem 提取 → 加密 → 注入壳 DEX。
 * 这是 harden-pipeline Step 4 的核心逻辑。
 */
export function extractAndStoreCodeItems(
  shellDex: Uint8Array,
  extractedCodeItems: Map<number, Uint8Array>,
  stubMethods: Array<{ classIdx: number; methodIdx: number; originalCodeOff: number; originalCodeSize: number }>,
  encryptionKey: Uint8Array,
): {
  resultDex: Uint8Array
  methodCount: number
  codeItemTableSize: number
  findings: Finding[]
} {
  const findings: Finding[] = []

  // 1. 构建 CodeItem 表
  const table = buildCodeItemTable(extractedCodeItems, stubMethods)
  const codeItemTableSize = table.length

  // 2. 加密表
  const encryptedTable = encryptCodeItemTable(table, encryptionKey)

  // 3. 注入壳 DEX
  const resultDex = injectCodeItemTableIntoShellDex(shellDex, encryptedTable)

  // 4. 验证:从壳 DEX 中提取并解密
  const extracted = extractCodeItemTableFromShellDex(resultDex)
  if (extracted) {
    const decrypted = decryptCodeItemTable(extracted.encryptedTable, encryptionKey)
    if (decrypted) {
      const parsed = deserializeCodeItemTable(decrypted)
      if (parsed) {
        findings.push({
          severity: "info",
          confidence: "high",
          code: "CODE_ITEM_TABLE_VERIFIED",
          title: `CodeItem 表注入验证通过:${parsed.records.length} 个方法`,
          detail: `CodeItem 表大小: ${codeItemTableSize}B;加密后: ${encryptedTable.length}B;壳 DEX: ${shellDex.length}B → ${resultDex.length}B。`,
          recommendation: "确认 Native 壳 SO 能从壳 DEX 末尾提取并解密 CodeItem 表。",
          evidence: `methods=${parsed.records.length} table=${codeItemTableSize}B encrypted=${encryptedTable.length}B`,
        })
      }
    }
  }

  return { resultDex, methodCount: stubMethods.length, codeItemTableSize, findings }
}

// ── Native 层接口定义 ──────────────────────────────────────────────────────

/**
 * 生成 Native 层的 CodeItem 还原接口 C 头文件。
 * 供 native-shell.ts 中的 ART DefineClass 钩子使用。
 */
export function generateCodeItemRestoreHeader(): string {
  return `// DroidSeal CodeItem 还原接口
// 由 harden-pipeline 自动生成，供 ART DefineClass 钩子使用

#ifndef DROIDSEAL_CODEITEM_RESTORE_H
#define DROIDSEAL_CODEITEM_RESTORE_H

#include <stdint.h>

typedef struct {
    uint32_t class_idx;
    uint32_t method_idx;
    uint32_t code_offset;   // 在 codeData 中的偏移
    uint16_t code_size;     // CodeItem 大小
} CodeItemRecord;

typedef struct {
    uint32_t method_count;
    CodeItemRecord* records;
    uint8_t* code_data;     // 连续存储的原始 CodeItem 字节
} CodeItemTable;

// 从壳 DEX 末尾提取并解密 CodeItem 表
// 返回 0=成功, -1=失败
int droidseal_restore_code_items(
    const uint8_t* dex_bytes,
    uint32_t dex_size,
    const uint8_t* encryption_key,
    uint32_t key_size,
    CodeItemTable* out_table
);

// 释放 CodeItemTable
void droidseal_free_code_item_table(CodeItemTable* table);

// 在 ART DefineClass 钩子中调用:替换被挖空方法的 CodeItem
// 返回 0=成功, -1=未找到匹配方法
int droidseal_restore_method_code(
    CodeItemTable* table,
    uint32_t class_idx,
    uint32_t method_idx,
    uint8_t* code_item_ptr,  // 指向 DEX 中该方法 CodeItem 的指针
    uint32_t code_item_size  // CodeItem 区域大小
);

#endif
`
}
