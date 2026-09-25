// 二进制 AXML Manifest 注入器(修复"文本 regex 损坏 AXML"问题)。
//
// 原实现把二进制 AXML decode 成文本做 regex 替换,产物结构破碎(aapt 报
// "Bad XML block")。本模块按 AXML chunk 结构原地编辑:
//   - <application> 已有 android:name → 等长重指向;缺失 → 增长 START_TAG 追加属性
//   - 在 </application> 前插入 <meta-data> 子元素(chunk 级插入)
//   - 字符串池只追加(索引全部保持有效),resource map 按需扩展
// 任何一步失败抛错(fail-closed),调用方保留原 manifest 并输出 finding。
//
// 能力边界(如实):只注入 application 入口 + meta-data。provider/factory
// 三重入口类仅以 smali 参考产物存在、从未编译进 loader DEX,注入反而会引用
// 不存在的类导致启动崩溃——在 finding 中如实标注。
import { parseAxml, serializeAxml, readApplicationName, internAxmlString, type AxmlModel } from "./axml-writer.ts"

const CHUNK_RESOURCE_MAP = 0x0180
const CHUNK_START_TAG = 0x0102
const CHUNK_END_TAG = 0x0103
const TYPE_STRING = 0x03
const RES_ID_NAME = 0x01010003 // android:name
const RES_ID_VALUE = 0x01010024 // android:value
const NO_COMMENT = 0xffffffff
export const ANDROID_NS = "http://schemas.android.com/apk/res/android"

export interface AxmlInjectConfig {
  shellApplication: string
  metaDatas: Array<{ name: string; value: string }>
}

export interface AxmlInjectResult {
  axml: Uint8Array
  previousApplication: string | null
  injected: string[]
}

// ── tail chunk 遍历(资源表 + XML 节点流) ─────────────────────────────

interface TailChunk {
  type: number
  bytes: Uint8Array
}

function splitTailChunks(tail: Uint8Array): TailChunk[] {
  const view = new DataView(tail.buffer, tail.byteOffset, tail.byteLength)
  const chunks: TailChunk[] = []
  let cursor = 0
  while (cursor + 8 <= tail.length) {
    const type = view.getUint16(cursor, true)
    const size = view.getUint32(cursor + 4, true)
    if (size < 8 || cursor + size > tail.length) break
    chunks.push({ type, bytes: tail.slice(cursor, cursor + size) })
    cursor += size
  }
  return chunks
}

// 在 chunk 字节流中定位 <application> 的 START/END 标签
function findApplication(chunks: TailChunk[], appStrIdx: number): { startIdx: number; endIdx: number } {
  let depth = 0
  let startIdx = -1
  for (let i = 0; i < chunks.length; i += 1) {
    const c = chunks[i]!
    const v = new DataView(c.bytes.buffer, c.bytes.byteOffset, c.bytes.byteLength)
    if (c.type === CHUNK_START_TAG) {
      const nameIdx = v.getUint32(20, true) // attrExt.name = 8头 + 8node + 4ns → @20
      if (nameIdx === appStrIdx) {
        if (depth === 0) startIdx = i
        depth += 1
      }
    } else if (c.type === CHUNK_END_TAG) {
      const nameIdx = v.getUint32(20, true) // endExt: 8+8 后 ns(4)@16 + name(4)@20
      if (nameIdx === appStrIdx && startIdx >= 0) {
        depth -= 1
        if (depth === 0) return { startIdx, endIdx: i }
      }
    }
  }
  throw new Error("AXML_APP_TAG_NOT_FOUND")
}

// <application> START_TAG 内定位 android:name 属性偏移(相对 chunk 起点),无则 -1
function findAppNameAttr(chunk: Uint8Array, nameResMapIdx: number): number {
  const v = new DataView(chunk.buffer, chunk.byteOffset, chunk.byteLength)
  const attrStart = v.getUint16(24, true) // attributeStart 字段在 chunk+24(相对 attrExt 即 16 起的偏移)
  const attrCount = v.getUint16(28, true)
  const attrBase = 16 + attrStart
  for (let a = 0; a < attrCount; a += 1) {
    const attr = attrBase + a * 20
    if (attr + 20 > chunk.length) break
    if (v.getUint32(attr + 4, true) === nameResMapIdx) return attr
  }
  return -1
}

function buildAttr(nsIdx: number, nameIdx: number, rawIdx: number, dataIdx: number): Uint8Array {
  const b = new Uint8Array(20)
  const v = new DataView(b.buffer)
  v.setInt32(0, nsIdx, true)
  v.setUint32(4, nameIdx, true)
  v.setUint32(8, rawIdx, true)
  v.setUint16(12, 8, true) // typedValue.size
  b[14] = 0 // res0
  b[15] = TYPE_STRING
  v.setUint32(16, dataIdx, true)
  return b
}

function buildStartTag(elemNameIdx: number, attrs: Uint8Array[], androidNsIdx: number): Uint8Array {
  const size = 36 + attrs.length * 20
  const b = new Uint8Array(size)
  const v = new DataView(b.buffer)
  v.setUint16(0, CHUNK_START_TAG, true)
  v.setUint16(2, 16, true) // headerSize
  v.setUint32(4, size, true)
  v.setUint32(8, 1, true) // lineNumber
  v.setUint32(12, NO_COMMENT, true)
  v.setInt32(16, -1, true) // element ns = none
  v.setUint32(20, elemNameIdx, true)
  v.setUint16(24, 20, true) // attributeStart
  v.setUint16(26, 20, true) // attributeSize
  v.setUint16(28, attrs.length, true)
  v.setUint16(30, 0, true) // idIndex
  v.setUint16(32, 0, true) // classIndex
  v.setUint16(34, 0, true) // styleIndex
  let off = 36
  for (const a of attrs) {
    b.set(a, off)
    off += 20
  }
  return b
}

function buildEndTag(elemNameIdx: number): Uint8Array {
  const b = new Uint8Array(24)
  const v = new DataView(b.buffer)
  v.setUint16(0, CHUNK_END_TAG, true)
  v.setUint16(2, 16, true)
  v.setUint32(4, 24, true)
  v.setUint32(8, 1, true)
  v.setUint32(12, NO_COMMENT, true)
  v.setInt32(16, -1, true)
  v.setUint32(20, elemNameIdx, true)
  return b
}

// 重建 resource map:条目按字符串索引对齐,新属性名补正确 resId,间隙补 0
function rebuildResourceMap(origMap: TailChunk | undefined, newStrings: string[], resIdByIndex: Map<number, number>): Uint8Array {
  const neededCount = Math.max(...resIdByIndex.keys()) + 1
  const origCount = origMap ? (origMap.bytes.length - 8) / 4 : 0
  const count = Math.max(neededCount, origCount)
  const out = new Uint8Array(8 + count * 4)
  const v = new DataView(out.buffer)
  v.setUint16(0, CHUNK_RESOURCE_MAP, true)
  v.setUint16(2, 8, true)
  v.setUint32(4, out.length, true)
  if (origMap) out.set(origMap.bytes.subarray(8), 8)
  for (const [idx, resId] of resIdByIndex) v.setUint32(8 + idx * 4, resId, true)
  return out
}

/**
 * 二进制注入壳入口 + meta-data。
 * 成功返回新 AXML 并经回读验证;任何失败抛错(fail-closed,调用方保留原 manifest)。
 */
export function injectShellIntoAxml(axmlBytes: Uint8Array, config: AxmlInjectConfig): AxmlInjectResult {
  const model: AxmlModel = parseAxml(axmlBytes)
  const previousApplication = readApplicationName(model)
  const chunks = splitTailChunks(model.tail)
  if (chunks.length === 0) throw new Error("AXML_TAIL_EMPTY")

  // 字符串 intern(只追加)
  const androidNsIdx = model.strings.indexOf(ANDROID_NS)
  if (androidNsIdx < 0) throw new Error("AXML_ANDROID_NS_MISSING")
  const nameIdx = internAxmlString(model, "name")
  const valueIdx = internAxmlString(model, "value")
  const metaDataElemIdx = internAxmlString(model, "meta-data")
  const shellAppIdx = internAxmlString(model, config.shellApplication)
  const metaInterned: Array<{ name: string; value: string; nameIdx: number; valueIdx: number }> = config.metaDatas.map((m) => ({
    ...m,
    nameIdx: internAxmlString(model, m.name),
    valueIdx: internAxmlString(model, m.value),
  }))

  // resource map 需要的 resId 映射(属性名字符串索引 → resId)
  const resIdByIndex = new Map<number, number>()
  resIdByIndex.set(nameIdx, RES_ID_NAME)
  resIdByIndex.set(valueIdx, RES_ID_VALUE)

  const { startIdx, endIdx } = findApplication(chunks, model.strings.indexOf("application"))
  const appChunk = chunks[startIdx]!.bytes

  // 1. application android:name:重指向或追加
  const nameAttrMapIdx = model.strings.indexOf("name") // 与上面 intern 同一索引
  let injected = false
  const existing = findAppNameAttr(appChunk, nameAttrMapIdx)
  let newAppChunk: Uint8Array
  if (existing >= 0) {
    newAppChunk = appChunk.slice()
    const v = new DataView(newAppChunk.buffer)
    v.setUint32(existing + 8, shellAppIdx, true) // rawValue
    v.setUint8(existing + 15, TYPE_STRING)
    v.setUint32(existing + 16, shellAppIdx, true) // typedValue.data
    injected = true
  } else {
    // 属性缺失:增长 START_TAG,追加 android:name 属性
    newAppChunk = new Uint8Array(appChunk.length + 20)
    newAppChunk.set(appChunk)
    const v = new DataView(newAppChunk.buffer)
    v.setUint16(28, v.getUint16(28, true) + 1, true) // attributeCount+1
    newAppChunk.set(buildAttr(androidNsIdx, nameIdx, shellAppIdx, shellAppIdx), appChunk.length)
    v.setUint32(4, newAppChunk.length, true) // chunkSize
    injected = true
  }

  // 2. meta-data 子元素,插到 </application> 前
  const metaChunks: TailChunk[] = []
  for (const m of metaInterned) {
    metaChunks.push({
      type: CHUNK_START_TAG,
      bytes: buildStartTag(metaDataElemIdx, [
        buildAttr(androidNsIdx, nameIdx, m.nameIdx, m.nameIdx),
        buildAttr(androidNsIdx, valueIdx, m.valueIdx, m.valueIdx),
      ], androidNsIdx),
    })
    metaChunks.push({ type: CHUNK_END_TAG, bytes: buildEndTag(metaDataElemIdx) })
  }

  // 3. 重组装 tail:资源表 + [..application start(改).. metas .. application end ..]
  const mapIdx = chunks[0]!.type === CHUNK_RESOURCE_MAP ? 0 : -1
  const mapChunk = mapIdx >= 0 ? chunks[0] : undefined
  const newMap = rebuildResourceMap(mapChunk, model.strings, resIdByIndex)

  const outChunks: Uint8Array[] = [newMap]
  for (let i = mapIdx + 1; i < chunks.length; i += 1) {
    if (i === startIdx) {
      outChunks.push(newAppChunk)
      // 本标签的子元素与 END_TAG 之间插入 meta-data:
      // 到 endIdx 前的所有 chunk 保持,meta-data 插在 endIdx 前(即循环里 i===endIdx 时先插)
    }
    if (i === endIdx) outChunks.push(...metaChunks.map((c) => c.bytes))
    if (i !== startIdx) outChunks.push(chunks[i]!.bytes)
  }
  model.tail = concatChunks(outChunks)

  const out = serializeAxml(model)

  // 回读验证(fail-closed):重解析 + 入口必须是壳类
  const verify = parseAxml(out)
  const verifyName = readApplicationName(verify)
  if (verifyName !== config.shellApplication) {
    throw new Error(`AXML_INJECT_VERIFY_FAILED: ${verifyName}`)
  }

  const injectedNames: string[] = []
  if (injected) injectedNames.push(`application → ${config.shellApplication}`)
  for (const m of metaInterned) injectedNames.push(`meta-data ${m.name}`)
  return { axml: out, previousApplication, injected: injectedNames }
}

function concatChunks(parts: Uint8Array[]): Uint8Array {
  let total = 0
  for (const p of parts) total += p.length
  const out = new Uint8Array(total)
  let off = 0
  for (const p of parts) {
    out.set(p, off)
    off += p.length
  }
  return out
}
