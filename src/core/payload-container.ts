// 加固 payload 容器:assets/droidseal.bin(stored 不压缩)。
//
// 背景:壳 DEX 条目在 APK 中是 deflate 压缩存储的,运行时扫 raw APK 字节
// 找不到 payload magic。改为把加密 DEX / CodeItem 表放进独立 asset 条目,
// 运行时经 AssetManager 直接读取——固定位置、无需 magic 碎片搜索、不依赖压缩状态。
//
// 容器格式(小端):
//   magic   12B  "DROIDSEALBIN"
//   version  4B  u32 = 1
//   count    4B  u32 = 条目数
//   条目 × count:
//     kind        4B  u32(1 = dex payload, 2 = citable)
//     targetIndex 4B  u32(对应原始 classesN.dex 的 N 索引,从 0 起)
//     length      4B  u32 = bytes 长度
//     bytes       len B(kind=dex: nonce12+tag16+密文;citable: nonce12+tag16+密文)
import { createHash, randomBytes, createHmac } from "node:crypto"
import { createCipheriv, createDecipheriv } from "node:crypto"

export const CONTAINER_ASSET_NAME = "assets/droidseal.bin"
const CONTAINER_MAGIC_DEFAULT = "DROIDSEALBIN"
const CONTAINER_VERSION = 1
const ENTRY_HEADER = 12 // kind + targetIndex + length

/** 容器格式参数:构建期随机化 magic/asset 名,废掉基于固定签名的自动化定位(缺省兼容旧值)。 */
export interface ContainerOptions {
  /** 12 字节容器 magic(缺省 "DROIDSEALBIN") */
  magic?: string
  /** asset 条目完整路径(缺省 assets/droidseal.bin) */
  assetName?: string
}

export type ContainerEntryKind = "dex" | "citable"

export interface ContainerEntry {
  kind: ContainerEntryKind
  targetIndex: number
  bytes: Uint8Array
}

export function buildPayloadContainer(entries: ContainerEntry[], options?: ContainerOptions): Uint8Array {
  const magic = (options?.magic && options.magic.length === 12 ? options.magic : CONTAINER_MAGIC_DEFAULT)
  const headerSize = 12 + 4 + 4
  let total = headerSize
  for (const e of entries) total += ENTRY_HEADER + e.bytes.length
  const out = new Uint8Array(total)
  const view = new DataView(out.buffer)
  out.set(new TextEncoder().encode(magic), 0)
  view.setUint32(12, CONTAINER_VERSION, true)
  view.setUint32(16, entries.length, true)
  let pos = headerSize
  for (const e of entries) {
    view.setUint32(pos, e.kind === "dex" ? 1 : 2, true)
    view.setUint32(pos + 4, e.targetIndex, true)
    view.setUint32(pos + 8, e.bytes.length, true)
    out.set(e.bytes, pos + ENTRY_HEADER)
    pos += ENTRY_HEADER + e.bytes.length
  }
  return out
}

export function parsePayloadContainer(bytes: Uint8Array, options?: ContainerOptions): ContainerEntry[] | undefined {
  const magic = (options?.magic && options.magic.length === 12 ? options.magic : CONTAINER_MAGIC_DEFAULT)
  if (bytes.length < 20) return undefined
  if (new TextDecoder().decode(bytes.slice(0, 12)) !== magic) return undefined
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength)
  const version = view.getUint32(12, true)
  if (version !== CONTAINER_VERSION) return undefined
  const count = view.getUint32(16, true)
  if (count > 4096) return undefined
  const entries: ContainerEntry[] = []
  let pos = 20
  for (let i = 0; i < count; i += 1) {
    if (pos + ENTRY_HEADER > bytes.length) return undefined
    const kindRaw = view.getUint32(pos, true)
    const targetIndex = view.getUint32(pos + 4, true)
    const length = view.getUint32(pos + 8, true)
    pos += ENTRY_HEADER
    if (length > bytes.length - pos) return undefined
    entries.push({
      kind: kindRaw === 1 ? "dex" : kindRaw === 2 ? "citable" : undefined as never,
      targetIndex,
      bytes: bytes.slice(pos, pos + length),
    })
    pos += length
  }
  return entries
}

// ── per-entry 密钥派生(HKDF-SHA256)───────────────────────────────────
// master 密钥破解一条不再蔓延:每个容器条目用 HKDF(master, info=kind+targetIndex)
// 派生的独立密钥加密。攻击者恢复单条 entryKey 无法推导 master 或其他条目密钥。
// Java 端用 HmacSHA256 实现同一 HKDF(extract+expand),见 DroidSealLoader.deriveEntryKey。

export function deriveEntryKey(
  masterKey: Uint8Array,
  kind: ContainerEntryKind,
  targetIndex: number,
  anchor?: Uint8Array,
  envByte = 0,
): Uint8Array {
  // extract: PRK = HMAC-SHA256(salt="", IKM=master)
  const prk = createHmac("sha256", new Uint8Array(32)).update(masterKey).digest()
  // expand: OKM = HMAC(PRK, info || 0x01)
  // 完整性锚点(P0-A):构建期嵌入最终二进制 manifest 的 SHA-256,运行时从自身 APK
  // 重算同一值参与 info——任何对 manifest 的篡改(重打包必经)都会派生出错误密钥,
  // GCM 校验静默失败,攻击者无从区分防御与 bug。anchor 缺省时兼容旧格式。
  // 环境门控(P0-B):envByte=运行时反分析投票(0=干净,1=篡改)。构建期恒 0(干净构建);
  // 运行时检测命中则派生错钥——动态分析(attach 即跑)拿到的全是解不开的密文。
  const anchorSuffix = anchor && anchor.length > 0 ? `-a${Buffer.from(anchor).toString("hex")}` : ""
  const info = Buffer.from(`droidseal-entry-${kind}-${targetIndex}${anchorSuffix}-e${envByte === 1 ? 1 : 0}`, "utf-8")
  const okm = createHmac("sha256", prk).update(info).update(Buffer.from([1])).digest()
  return new Uint8Array(okm)
}

// ── 容器条目加密/解密(与 dex-protection 的 payload 格式一致: nonce12+tag16+ct) ──

export function encryptContainerEntry(plain: Uint8Array, key: Uint8Array): Uint8Array {
  const nonce = randomBytes(12)
  const cipher = createCipheriv("aes-256-gcm", key, nonce)
  const encrypted = Buffer.concat([cipher.update(plain), cipher.final()])
  const tag = cipher.getAuthTag()
  const out = new Uint8Array(28 + encrypted.length)
  out.set(nonce, 0)
  out.set(tag, 12)
  out.set(new Uint8Array(encrypted), 28)
  return out
}

/** 一步完成:派生条目密钥 → AES-256-GCM 加密(anchor=完整性锚点,见 deriveEntryKey)。 */
export function encryptContainerEntryDerived(plain: Uint8Array, masterKey: Uint8Array, kind: ContainerEntryKind, targetIndex: number, anchor?: Uint8Array): Uint8Array {
  return encryptContainerEntry(plain, deriveEntryKey(masterKey, kind, targetIndex, anchor))
}

/** 一步完成:派生条目密钥 → AES-256-GCM 解密(roundtrip 验证用)。 */
export function decryptContainerEntryDerived(entry: Uint8Array, masterKey: Uint8Array, kind: ContainerEntryKind, targetIndex: number, anchor?: Uint8Array): Uint8Array | undefined {
  return decryptContainerEntry(entry, deriveEntryKey(masterKey, kind, targetIndex, anchor))
}

export function decryptContainerEntry(entry: Uint8Array, key: Uint8Array): Uint8Array | undefined {
  if (entry.length < 29) return undefined
  try {
    const decipher = createDecipheriv("aes-256-gcm", key, entry.slice(0, 12))
    decipher.setAuthTag(entry.slice(12, 28))
    return new Uint8Array(Buffer.concat([decipher.update(entry.slice(28)), decipher.final()]))
  } catch {
    return undefined
  }
}

/** 容器完整性指纹(写入 findings evidence,便于真机排查)。 */
export function containerFingerprint(bytes: Uint8Array): string {
  return createHash("sha256").update(bytes).digest("hex").slice(0, 16)
}
