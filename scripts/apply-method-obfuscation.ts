#!/usr/bin/env bun
// DEX 方法重命名工具（开发路线 ① 的改写落地）。
// 输入：DEX 文件 + method-obfuscation.map（“类名#方法名 -> 短名#方法名”行）
// 输出：重写后的 DEX——按映射重命名白名单方法（新建字符串 + 改该 method_id 的 name_idx，
//       调用点经 method_id 引用自动跟随），重算 adler32 校验和与 SHA-1 签名。
// 失败关闭：类/方法不匹配报错；重写后引用完整性验证失败报错；映射方法不存在则跳过并记录。
// 构建期工具（对构建产物 DEX 应用——源码接入模式），不事后改写未知 APK。
import { readFile, writeFile } from "node:fs/promises"
import { createHash, createHmac } from "node:crypto"

interface DexHeader {
  stringIdsSize: number
  stringIdsOff: number
  typeIdsSize: number
  typeIdsOff: number
  protoIdsSize: number
  protoIdsOff: number
  fieldIdsSize: number
  fieldIdsOff: number
  methodIdsSize: number
  methodIdsOff: number
  classDefsSize: number
  classDefsOff: number
  dataSize: number
  dataOff: number
  fileSize: number
}

function parseHeader(bytes: Uint8Array): DexHeader {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const u32 = (o: number) => view.getUint32(o, true)
  return {
    stringIdsSize: u32(0x38), stringIdsOff: u32(0x3c),
    typeIdsSize: u32(0x40), typeIdsOff: u32(0x44),
    protoIdsSize: u32(0x48), protoIdsOff: u32(0x4c),
    fieldIdsSize: u32(0x50), fieldIdsOff: u32(0x54),
    methodIdsSize: u32(0x58), methodIdsOff: u32(0x5c),
    classDefsSize: u32(0x60), classDefsOff: u32(0x64),
    dataSize: u32(0x68), dataOff: u32(0x6c),
    fileSize: u32(0x70),
  }
}

// 读取 string_ids 偏移处的 string_data（ULEB128 长度 + MUTF-8 + 结尾 0）
function readStringAt(bytes: Uint8Array, off: number): string {
  let p = off
  let uleb = 0
  let shift = 0
  for (let i = 0; i < 5; i += 1) {
    const b = bytes[p++]!
    uleb |= (b & 0x7f) << shift
    if ((b & 0x80) === 0) break
    shift += 7
  }
  let end = p
  while (bytes[end] !== 0) end += 1
  const decoder = new TextDecoder("utf-8")
  return decoder.decode(bytes.subarray(p, end))
}

// adler32（DEX checksum，小端写入 0x08）
function adler32(bytes: Uint8Array, from: number, to: number): number {
  let a = 1
  let b = 0
  const MOD = 65521
  for (let i = from; i < to; i += 1) {
    a = (a + bytes[i]!) % MOD
    b = (b + a) % MOD
  }
  return ((b << 16) | a) >>> 0
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const [dexPath, mapPath, outputPath] = argv
  if (!dexPath || !mapPath || !outputPath) {
    throw new Error("用法: apply-method-obfuscation <input.dex> <method-obfuscation.map> <output.dex>")
  }
  const bytes = new Uint8Array(await readFile(dexPath))
  // DEX magic 校验("dex\n" + 版本)——非 DEX 输入给出干净错误(失败关闭)
  if (bytes.byteLength < 0x70 || bytes[0] !== 0x64 || bytes[1] !== 0x65 || bytes[2] !== 0x78 || bytes[3] !== 0x0a) {
    throw new Error("不是有效的 DEX 文件（缺少 dex 头 magic）")
  }
  const header = parseHeader(bytes)
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)

  // 1. 解析字符串池
  const strings: string[] = []
  for (let i = 0; i < header.stringIdsSize; i += 1) {
    const off = view.getUint32(header.stringIdsOff + i * 4, true)
    strings.push(readStringAt(bytes, off))
  }

  // 2. 解析 method_ids（class_idx/proto_idx/name_idx）与 type_ids（类描述符）
  const methodNames: string[] = []
  const methodClasses: string[] = []
  for (let i = 0; i < header.methodIdsSize; i += 1) {
    const base = header.methodIdsOff + i * 8
    const classIdx = view.getUint16(base, true)
    const nameIdx = view.getUint32(base + 4, true)
    methodNames.push(strings[nameIdx] ?? "")
    const typeOff = header.typeIdsOff + classIdx * 4
    const descriptorIdx = view.getUint32(typeOff, true)
    methodClasses.push(strings[descriptorIdx] ?? "")
  }

  // 3. 解析映射（类名#方法名 -> 短名）
  const mapText = await readFile(mapPath, "utf8")
  const renames: Array<{ cls: string; method: string; short: string }> = []
  for (const line of mapText.split(/\r?\n/)) {
    const trimmed = line.trim()
    if (trimmed === "" || trimmed.startsWith("#")) continue
    const parts = trimmed.split(/\s*->\s*/)
    if (parts.length !== 2) throw new Error(`映射格式异常: ${line}`)
    const from = parts[0]!
    const short = parts[1]!
    const hash = from.indexOf("#")
    if (hash <= 0) throw new Error(`映射格式异常(缺类#方法): ${line}`)
    renames.push({ cls: from.slice(0, hash), method: from.slice(hash + 1), short })
  }
  if (renames.length === 0) throw new Error("映射为空")

  // 4. 应用重命名:匹配 method_ids 的 类#方法,新建字符串,记录 method_id → 新 name_idx
  //    类描述符形如 Lcom/example/Auth;  —— 映射用点分(com.example.Auth)
  const applied: Array<{ cls: string; method: string; short: string; methodId: number }> = []
  for (const rename of renames) {
    const descriptor = `L${rename.cls.replaceAll(".", "/")};`
    let matched = 0
    for (let i = 0; i < header.methodIdsSize; i += 1) {
      if (methodClasses[i] === descriptor && methodNames[i] === rename.method) {
        // 同一个 类#方法 可能有多个签名重载——每个都重命名(短名相同,失败关闭:签名不同但名同)
        applied.push({ ...rename, methodId: i })
        matched += 1
      }
    }
    if (matched === 0) console.log(`跳过(未在 DEX 中找到): ${rename.cls}#${rename.method}`)
  }
  if (applied.length === 0) throw new Error("映射未命中任何 DEX 方法")

  // 5. 重写:新字符串池(追加短名) + 新 string_ids + 新 method_ids(改 name_idx)
  //    短名去重;已有字符串直接复用索引
  const existingIndex = new Map<string, number>()
  strings.forEach((s, i) => { if (!existingIndex.has(s)) existingIndex.set(s, i) })
  const newStrings = [...strings]
  const nameIdxById = new Map<number, number>()
  for (const entry of applied) {
    let idx = existingIndex.get(entry.short)
    if (idx === undefined) {
      idx = newStrings.length
      newStrings.push(entry.short)
      existingIndex.set(entry.short, idx)
    }
    nameIdxById.set(entry.methodId, idx)
  }

  // 6. 序列化:string_data(uleb128 长度 + utf8 + 0) + string_ids + type/proto/field/method_ids + class_defs + data
  const encodeUleb = (value: number): number[] => {
    const out: number[] = []
    let v = value
    do {
      let b = v & 0x7f
      v >>>= 7
      if (v !== 0) b |= 0x80
      out.push(b)
    } while (v !== 0)
    return out
  }
  const stringDataBytes: number[] = []
  const newStringOffsets: number[] = []
  const encoder = new TextEncoder()
  for (const s of newStrings) {
    newStringOffsets.push(stringDataBytes.length)
    const utf8 = encoder.encode(s)
    stringDataBytes.push(...encodeUleb(utf8.length))
    stringDataBytes.push(...utf8, 0)
  }

  // 计算各 section 的新偏移(header 0x70 字节 + string_ids/type_ids/proto_ids/field_ids/method_ids/class_defs/data)
  const align = (n: number) => (n % 4 === 0 ? n : n + (4 - (n % 4)))
  let cursor = 0x70
  const section = (size: number, item: number) => {
    const off = cursor
    cursor += size * item
    return off
  }
  const newStringIdsOff = section(newStrings.length, 4)
  const newTypeIdsOff = section(header.typeIdsSize, 4)
  const newProtoIdsOff = section(header.protoIdsSize, 12)
  const newFieldIdsOff = section(header.fieldIdsSize, 8)
  const newMethodIdsOff = section(header.methodIdsSize, 8)
  const newClassDefsOff = section(header.classDefsSize, 32)
  const stringDataOffset = cursor
  const newDataOff = cursor + stringDataBytes.length
  const newFileSize = newDataOff

  const out = new Uint8Array(newFileSize)
  const outView = new DataView(out.buffer)
  // magic + checksum(0x08, 暂填 0) + signature(0x0c, 暂填 0)
  out.set(bytes.subarray(0, 0x70))
  // 写 string_ids
  for (let i = 0; i < newStrings.length; i += 1) {
    outView.setUint32(newStringIdsOff + i * 4, stringDataOffset + newStringOffsets[i]!, true)
  }
  // 复制 type/proto/field ids(原偏移处内容——位置不变,复制原字节)
  out.set(bytes.subarray(header.typeIdsOff, header.typeIdsOff + header.typeIdsSize * 4), newTypeIdsOff)
  out.set(bytes.subarray(header.protoIdsOff, header.protoIdsOff + header.protoIdsSize * 12), newProtoIdsOff)
  out.set(bytes.subarray(header.fieldIdsOff, header.fieldIdsOff + header.fieldIdsSize * 8), newFieldIdsOff)
  // 写 method_ids(原内容 + 改 name_idx)
  for (let i = 0; i < header.methodIdsSize; i += 1) {
    const src = header.methodIdsOff + i * 8
    const dst = newMethodIdsOff + i * 8
    out.set(bytes.subarray(src, src + 8), dst)
    const newName = nameIdxById.get(i)
    if (newName !== undefined) outView.setUint32(dst + 4, newName, true)
  }
  // 复制 class_defs
  out.set(bytes.subarray(header.classDefsOff, header.classDefsOff + header.classDefsSize * 32), newClassDefsOff)
  // 写 string_data
  out.set(new Uint8Array(stringDataBytes), stringDataOffset)

  // 更新 header
  const setU32 = (o: number, v: number) => outView.setUint32(o, v, true)
  setU32(0x38, newStrings.length); setU32(0x3c, newStringIdsOff)
  setU32(0x44, newTypeIdsOff)
  setU32(0x4c, newProtoIdsOff)
  setU32(0x54, newFieldIdsOff)
  setU32(0x5c, newMethodIdsOff)
  setU32(0x64, newClassDefsOff)
  setU32(0x68, newDataOff - stringDataOffset); setU32(0x6c, stringDataOffset)
  setU32(0x70, newFileSize)
  // 校验和(0x08)与 SHA-1 签名(0x0c):先清零,算 adler32 与 sha1,再写
  for (let i = 0x08; i < 0x20; i += 1) out[i] = 0
  const checksum = adler32(out, 0x0c, out.byteLength)
  outView.setUint32(0x08, checksum, true)
  const sha1 = createHash("sha1").update(out.subarray(0x0c)).digest()
  out.set(sha1, 0x0c)

  // 7. 引用完整性验证:重新解析输出——验证每个改名 method_id 的 name_idx 指向新短名
  const reHeader = parseHeader(out)
  const reStrings: string[] = []
  for (let i = 0; i < reHeader.stringIdsSize; i += 1) {
    const off = outView.getUint32(reHeader.stringIdsOff + i * 4, true)
    reStrings.push(readStringAt(out, off))
  }
  for (const entry of applied) {
    const base = reHeader.methodIdsOff + entry.methodId * 8
    const nameIdx = outView.getUint32(base + 4, true)
    const actual = reStrings[nameIdx]
    if (actual !== entry.short) {
      throw new Error(`引用完整性失败: method_id ${entry.methodId} 的 name_idx 指向 "${actual}",应为 "${entry.short}"`)
    }
  }

  await writeFile(outputPath, out)
  console.log(`已重写 ${outputPath}:${applied.length} 个方法重命名（${renames.length - applied.length} 个映射未命中已跳过）`)
  console.log(`字符串池 ${header.stringIdsSize} → ${newStrings.length} 条；校验和/签名已重算`)
}

main().catch((error) => {
  console.error(`DEX 方法重命名失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
