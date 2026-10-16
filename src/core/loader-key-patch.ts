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

function findMarker(dex: Uint8Array, marker: Uint8Array): number {
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
}

/**
 * 对 loader DEX 做密钥标记等长替换 + DEX 校验和重算。
 * 任一标记未命中时返回 patched*=false(调用方应输出 finding;未打补丁的 loader
 * 运行时会因密钥错误解密失败并优雅降级,不会崩溃)。
 */
export function patchLoaderDexKeys(loaderDex: Uint8Array, part1: Uint8Array, part2: Uint8Array, certSha256Hex?: string): LoaderKeyPatchResult {
  if (part1.length !== MARKER_LEN || part2.length !== MARKER_LEN) {
    throw new Error(`密钥两段必须为 ${MARKER_LEN}B,实际 ${part1.length}B/${part2.length}B`)
  }
  const out = loaderDex.slice()
  let patchedPart1 = false
  let patchedPart2 = false
  let patchedCert = false

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

  if (patchedPart1 || patchedPart2 || patchedCert) {
    return { dex: recomputeDexChecksums(out), patchedPart1, patchedPart2, patchedCert }
  }
  return { dex: out, patchedPart1, patchedPart2, patchedCert }
}
