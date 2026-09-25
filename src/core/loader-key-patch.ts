// Loader DEX 密钥补丁(构建期)。
//
// runtime/droidseal-loader.dex 编译自 ShellApplication.java,其中 KEY_PART1/KEY_PART2
// 是 32B 标记数组(0xA5×32 / 0x5A×32)。本模块在流水线注入 loader DEX 前,
// 按标记定位并等长替换为真实密钥两段(part1 XOR part2 = AES-256 密钥),
// 随后重算 DEX 的 SHA-1 signature + Adler32 checksum(否则 ART 拒绝加载)。
import { recomputeDexChecksums } from "./dex-model.ts"

const MARKER_LEN = 32
const MARK_PART1 = new Uint8Array(MARKER_LEN).fill(0xa5)
const MARK_PART2 = new Uint8Array(MARKER_LEN).fill(0x5a)
const MARK_CERT = new Uint8Array(MARKER_LEN).fill(0xc3) // 期望证书 SHA-256 原始摘要标记
// P2 服务端挑战 URL 占位符(128 字符,= Java SERVER_URL 字段常量;URL 短于 128 以 '#' 补齐)
const MARK_URL = `DS_SRV_URL${"#".repeat(118)}`

function findMarker(dex: Uint8Array, marker: Uint8Array): number {
  // 用传入标记的真实长度匹配(不得假设 32B——URL 标记为 128B)
  const mLen = marker.length
  const last = dex.length - mLen
  for (let i = 0; i <= last; i += 1) {
    let j = 0
    while (j < mLen && dex[i + j] === marker[j]) j += 1
    if (j === mLen) return i
  }
  return -1
}

export interface LoaderKeyPatchResult {
  dex: Uint8Array
  patchedPart1: boolean
  patchedPart2: boolean
  /** 证书指纹标记是否补丁(verifyIntegrity 依赖;false = 运行时跳过自校验) */
  patchedCert: boolean
  /** Keystore 绑定开关标记是否补丁(false = 运行时保持关闭) */
  patchedKsFlag: boolean
  /** P2 服务端挑战 URL 是否补丁(challengeUrl 未传时不打,false = 运行时为空 URL、跳过取片) */
  patchedUrl: boolean
}

/**
 * 对 loader DEX 做密钥标记等长替换 + DEX 校验和重算。
 * 任一标记未命中时返回 patched*=false(调用方应输出 finding;未打补丁的 loader
 * 运行时会因密钥错误解密失败并优雅降级,不会崩溃)。
 */
export function patchLoaderDexKeys(loaderDex: Uint8Array, part1: Uint8Array, part2: Uint8Array, certSha256Hex?: string, keystoreBind?: boolean, challengeUrl?: string): LoaderKeyPatchResult {
  if (part1.length !== MARKER_LEN || part2.length !== MARKER_LEN) {
    throw new Error(`密钥两段必须为 ${MARKER_LEN}B,实际 ${part1.length}B/${part2.length}B`)
  }
  // P2 URL 校验:必须为纯 ASCII(非 ASCII/IDN 域名的字节长度 ≠ 字符长度,padEnd 按
  // UTF-16 计数会少补甚至越界写坏 DEX)。字节长度上限 128,不得含 '#'(填充符)。
  if (challengeUrl !== undefined && (challengeUrl.length === 0 || challengeUrl.includes("#") || !/^https:\/\//.test(challengeUrl) || !/^[!-~]*$/.test(challengeUrl) || Buffer.byteLength(challengeUrl, "utf8") > MARK_URL.length)) {
    throw new Error(`服务端挑战 URL 必须为 https:// 的可打印 ASCII(不含 '#'),且不超过 ${MARK_URL.length} 字节`)
  }
  const out = loaderDex.slice()
  let patchedPart1 = false
  let patchedPart2 = false
  let patchedCert = false
  let patchedKsFlag = false
  let patchedUrl = false

  const off1 = findMarker(out, MARK_PART1)
  if (off1 >= 0) {
    out.set(part1, off1)
    patchedPart1 = true
  }
  const off2 = findMarker(out, MARK_PART2)
  if (off2 >= 0) {
    out.set(part2, off2)
    patchedPart2 = true
  }
  // 证书指纹(hex 64 字符 → 原始 32B)嵌入 EXPECTED_CERT_SHA256:运行时签名自校验
  if (certSha256Hex && /^[0-9a-fA-F]{64}$/.test(certSha256Hex)) {
    const offC = findMarker(out, MARK_CERT)
    if (offC >= 0) {
      out.set(new Uint8Array(Buffer.from(certSha256Hex, "hex")), offC)
      patchedCert = true
    }
  }

  // Keystore 绑定开关标记:KS_BIND_FLAG_0 → KS_BIND_FLAG_1(--keystore-bind 启用)
  if (keystoreBind) {
    const enc = new TextEncoder()
    const from = enc.encode("KS_BIND_FLAG_0")
    const to = enc.encode("KS_BIND_FLAG_1")
    for (let i = 0; i + from.length <= out.length;) {
      let j = 0
      while (j < from.length && out[i + j] === from[j]) j += 1
      if (j === from.length) {
        out.set(to, i)
        patchedKsFlag = true
        i += from.length
      } else {
        i += 1
      }
    }
  }

  // P2 服务端挑战 URL:DS_SRV_URL###…(128B)→ https://…(右补 '#' 按字节等长)
  if (challengeUrl) {
    const enc = new TextEncoder()
    const from = enc.encode(MARK_URL)
    // 按字节填充(已校验纯 ASCII,字节长 = 字符长;填充到标记等长,杜绝越界)
    const to = new Uint8Array(MARK_URL.length)
    const urlBytes = enc.encode(challengeUrl)
    to.set(urlBytes)
    to.fill(0x23, urlBytes.length) // 0x23 = '#'
    let off = findMarker(out, from)
    if (off < 0) {
      // 字符串标记用逐字节扫描(与 KS_BIND 同法)
      off = -1
      for (let i = 0; i + from.length <= out.length; i++) {
        let j = 0
        while (j < from.length && out[i + j] === from[j]) j += 1
        if (j === from.length) { off = i; break }
      }
    }
    if (off >= 0) {
      out.set(to, off)
      patchedUrl = true
    }
  }

  if (patchedPart1 || patchedPart2 || patchedCert || patchedKsFlag || patchedUrl) {
    return { dex: recomputeDexChecksums(out), patchedPart1, patchedPart2, patchedCert, patchedKsFlag, patchedUrl }
  }
  return { dex: out, patchedPart1, patchedPart2, patchedCert, patchedKsFlag, patchedUrl }
}
