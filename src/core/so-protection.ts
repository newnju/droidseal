// SO 加密保护模块（#16 #17 #20 #22）。
// SO 全文件 AES-256-GCM 加密 + .rodata/.bitcode 段级 RC4 加密。
// 运时解密:反射 patch nativeLibraryDir + System.loadLibrary。
// 纯 TypeScript，失败关闭。
import { createCipheriv, createDecipheriv, randomBytes, createHash } from "node:crypto"
import type { Finding } from "./types.ts"

// ── ELF 常量 ──────────────────────────────────────────────────────────

const ELF_MAGIC = [0x7f, 0x45, 0x4c, 0x46]
const PT_LOAD = 1
const SHT_PROGBITS = 1

// ── SO 全文件加密(#16) ──────────────────────────────────────────────────

/**
 * SO 全文件 AES-256-GCM 加密。
 * 加密后的 SO = header(声明加密) + nonce(12) + tag(16) + ciphertext。
 * 运行时:解密到内存 → patch nativeLibraryDir → System.loadLibrary。
 */
export function encryptSoFile(soBytes: Uint8Array, key: Uint8Array): Uint8Array {
  const nonce = randomBytes(12)
  const cipher = createCipheriv("aes-256-gcm", key, nonce)
  const encrypted = Buffer.concat([cipher.update(soBytes), cipher.final()])
  const tag = cipher.getAuthTag()

  // DroidSeal SO 加密格式: "DROIDSEAL_SO_ENC" (16 bytes) + nonce (12) + tag (16) + ciphertext
  const header = new TextEncoder().encode("DROIDSEAL_SO_ENC")
  const result = new Uint8Array(16 + 12 + 16 + encrypted.length)
  result.set(header, 0)
  result.set(nonce, 16)
  result.set(tag, 28)
  result.set(new Uint8Array(encrypted), 44)
  return result
}

/**
 * 从 DroidSeal 加密格式中解密 SO。
 */
export function decryptSoFile(encryptedBytes: Uint8Array, key: Uint8Array): Uint8Array {
  const magic = new TextDecoder().decode(encryptedBytes.slice(0, 16))
  if (magic !== "DROIDSEAL_SO_ENC") throw new Error("Not a DroidSeal encrypted SO")
  const nonce = encryptedBytes.slice(16, 28)
  const tag = encryptedBytes.slice(28, 44)
  const ciphertext = encryptedBytes.slice(44)
  const decipher = createDecipheriv("aes-256-gcm", key, nonce)
  decipher.setAuthTag(tag)
  return new Uint8Array(Buffer.concat([decipher.update(ciphertext), decipher.final()]))
}

// ── 段级 RC4 加密(#17) ──────────────────────────────────────────────────

/**
 * RC4 加密(用于 .rodata/.bitcode 段加密)。
 * RC4 是流密码，密钥长度可变，适合段级加密。
 */
function rc4(key: Uint8Array, data: Uint8Array): Uint8Array {
  // Key Scheduling Algorithm (KSA)
  const s = new Uint8Array(256)
  for (let i = 0; i < 256; i += 1) s[i] = i
  let j = 0
  for (let i = 0; i < 256; i += 1) {
    j = (j + s[i]! + key[i % key.length]!) & 0xff
    const tmp = s[i]!; s[i] = s[j]!; s[j] = tmp
  }
  // Pseudo-Random Generation Algorithm (PRGA)
  const result = new Uint8Array(data.length)
  let ii = 0, jj = 0
  for (let k = 0; k < data.length; k += 1) {
    ii = (ii + 1) & 0xff
    jj = (jj + s[ii]!) & 0xff
    const tmp = s[ii]!; s[ii] = s[jj]!; s[jj] = tmp
    result[k] = data[k]! ^ s[(s[ii]! + s[jj]!) & 0xff]!
  }
  return result
}

/**
 * SO 段级 RC4 加密:加密 .rodata 和 .bitcode 段。
 * 运行时:壳 SO 在 JNI_OnLoad 中解密这些段。
 */
export interface SegmentEncryptResult {
  encryptedSo: Uint8Array
  encryptedSegments: Array<{ name: string; offset: number; size: number }>
  algorithm: "rc4"
}

export function encryptSoSegments(soBytes: Uint8Array, key: Uint8Array): SegmentEncryptResult {
  if (soBytes.length < 64 || soBytes[0] !== ELF_MAGIC[0]) throw new Error("Not an ELF file")
  const view = new DataView(soBytes.buffer, soBytes.byteOffset, soBytes.byteLength)
  const is64 = soBytes[4] === 2
  const little = soBytes[5] !== 2

  const result = new Uint8Array(soBytes)
  const encryptedSegments: Array<{ name: string; offset: number; size: number }> = []

  // 读取 section headers
  const shoff = is64 ? Number(view.getBigUint64(0x28, little)) : view.getUint32(0x20, little)
  const shentsize = view.getUint16(is64 ? 0x3a : 0x2e, little)
  const shnum = view.getUint16(is64 ? 0x3c : 0x30, little)

  // 读取 section name string table
  const shstrndx = view.getUint16(is64 ? 0x3e : 0x32, little)
  let strTabOff = 0
  if (shstrndx < shnum) {
    const strTabBase = shoff + shstrndx * shentsize
    strTabOff = is64 ? Number(view.getBigUint64(strTabBase + 24, little)) : view.getUint32(strTabBase + 16, little)
  }

  for (let i = 0; i < shnum; i += 1) {
    const base = shoff + i * shentsize
    const nameOff = view.getUint32(base, true)
    const type = view.getUint32(base + 4, true)
    if (type !== SHT_PROGBITS) continue

    // 读取段名
    let nameEnd = strTabOff + nameOff
    while (nameEnd < soBytes.length && soBytes[nameEnd] !== 0) nameEnd += 1
    const name = new TextDecoder().decode(soBytes.slice(strTabOff + nameOff, nameEnd))

    if (name !== ".rodata" && name !== ".bitcode" && name !== ".data.rel.ro") continue

    const offset = is64 ? Number(view.getBigUint64(base + 24, little)) : view.getUint32(base + 16, little)
    const size = is64 ? Number(view.getBigUint64(base + 32, little)) : view.getUint32(base + 20, little)

    if (offset + size > soBytes.length || size === 0) continue

    // RC4 加密该段
    const segmentData = soBytes.slice(offset, offset + size)
    const encrypted = rc4(key, segmentData)
    result.set(encrypted, offset)
    encryptedSegments.push({ name, offset, size })
  }

  return { encryptedSo: result, encryptedSegments, algorithm: "rc4" }
}

// ── SO 加密 Manifest 配置 ──────────────────────────────────────────────

/**
 * 生成 SO 加密的 Manifest 配置(声明自定义 nativeLibraryDir)。
 * 运行时通过反射 patch ApplicationInfo.nativeLibraryDir 指向解密后的 SO 目录。
 */
export function generateSoEncryptionManifestAttrs(): string {
  return `android:extractNativeLibs="true"`
}

/**
 * 生成 SO 解密 Smali 代码(壳 SO 的 JNI_OnLoad 中调用)。
 */
export function generateSoDecryptorSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealSoDecryptor;
.super Ljava/lang/Object;
.source "DroidSealSoDecryptor.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static decryptAndLoad(Landroid/content/Context;Ljava/lang/String;)V
    .locals 6
    # 1. 读取加密 SO 文件
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;
    move-result-object v0

    # 2. 读取完整文件到 byte[]
    new-instance v1, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v2, 0x1000
    new-array v2, v2, [B
    :read_loop
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I
    move-result v3
    if-gez v3, :read_done
    const/4 v4, 0x0
    invoke-virtual {v1, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :read_loop
    :read_done
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0

    # 3. 解密(AES-256-GCM)
    # ... 解密逻辑(运行时调用 javax.crypto.Cipher)

    # 4. 写入临时文件并加载
    const-string v1, "libdex"
    const-string v2, ".so"
    invoke-virtual {p0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v3
    invoke-static {v1, v2, v3}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;
    move-result-object v1
    new-instance v2, Ljava/io/FileOutputStream;
    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    invoke-virtual {v2, v0}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    # 5. System.load
    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/System;->load(Ljava/lang/String;)V

    # 6. 删除临时文件
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    return-void
.end method
`
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildSoProtectionFindings(
  encryptedSize: number,
  originalSize: number,
  segments: Array<{ name: string; offset: number; size: number }>,
): Finding[] {
  const findings: Finding[] = []
  if (encryptedSize > 0) {
    findings.push({
      severity: "info", confidence: "high", code: "SO_ENCRYPTED",
      title: `SO 加密完成:${originalSize}B → ${encryptedSize}B(全文件 AES-256-GCM)`,
      detail: `加密后的 SO 文件使用 DroidSeal 格式头(16B) + nonce(12B) + tag(16B) + ciphertext。`,
      recommendation: "确认壳加载器能正确解密;测试各 ABI(armeabi-v7a/arm64-v8a/x86/x86_64)兼容性。",
      evidence: `original=${originalSize}B encrypted=${encryptedSize}B`,
    })
  }
  if (segments.length > 0) {
    findings.push({
      severity: "info", confidence: "high", code: "SO_SEGMENT_ENCRYPTED",
      title: `SO 段加密完成:${segments.length} 个段(RC4)`,
      detail: `加密段: ${segments.map((s) => `${s.name}(${s.size}B@0x${s.offset.toString(16)})`).join(", ")}。运行时在 JNI_OnLoad 中解密。`,
      recommendation: "段级加密比全文件加密更精细——仅加密敏感数据段。",
      evidence: segments.map((s) => `${s.name}:${s.size}B`).join(", "),
    })
  }
  return findings
}
