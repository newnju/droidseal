import { describe, expect, test } from "bun:test"
import { mkdtemp, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import path from "node:path"
import { extractDexStrings, scanDex, detectSdkPackages } from "../src/core/dex-scan.ts"
import { analyzeElf, buildSoFindings } from "../src/core/elf-scan.ts"
import { auditApk } from "../src/core/apk-audit.ts"
import { buildZip, crc32Of, type OutEntry } from "../src/core/harden-manifest.ts"
import type { Toolchain, ToolLocation } from "../src/core/types.ts"

function uleb128(value: number): number[] {
  const out: number[] = []
  let remaining = value
  do {
    let byte = remaining & 0x7f
    remaining >>>= 7
    if (remaining !== 0) byte |= 0x80
    out.push(byte)
  } while (remaining !== 0)
  return out
}

// Build a minimal but valid DEX buffer carrying the given string pool.
function buildDex(strings: string[]): Uint8Array {
  const encoder = new TextEncoder()
  const headerSize = 0x70
  const idsOffset = headerSize
  const idsSize = strings.length
  const dataStart = idsOffset + idsSize * 4
  const dataChunks: number[] = []
  const offsets: number[] = []
  let cursor = dataStart
  for (const value of strings) {
    offsets.push(cursor)
    const utf8 = [...encoder.encode(value)]
    const prefix = uleb128(value.length)
    const item = [...prefix, ...utf8, 0x00]
    dataChunks.push(...item)
    cursor += item.length
  }
  const total = dataStart + dataChunks.length
  const bytes = new Uint8Array(total)
  bytes.set([0x64, 0x65, 0x78, 0x0a, 0x30, 0x33, 0x35, 0x00], 0) // "dex\n035\0"
  const view = new DataView(bytes.buffer)
  view.setUint32(0x38, idsSize, true)
  view.setUint32(0x3c, idsOffset, true)
  for (let i = 0; i < offsets.length; i += 1) view.setUint32(idsOffset + i * 4, offsets[i]!, true)
  bytes.set(dataChunks, dataStart)
  return bytes
}

// Build a minimal 64-bit ELF: executable stack, no RELRO, DT_TEXTREL, no canary/fortify.
function buildElf(): Uint8Array {
  const phoff = 64
  const phentsize = 56
  const phnum = 2
  const dynOffset = phoff + phentsize * phnum
  const dyn: Array<[number, number]> = [
    [22, 0], // DT_TEXTREL
    [0, 0], // DT_NULL
  ]
  const dynSize = dyn.length * 16
  const total = dynOffset + dynSize
  const bytes = new Uint8Array(total)
  bytes.set([0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0], 0) // magic, class=64, data=LE, version
  const view = new DataView(bytes.buffer)
  view.setUint16(16, 3, true) // e_type = ET_DYN
  view.setUint16(18, 0xb7, true) // e_machine = AArch64
  view.setBigUint64(0x20, BigInt(phoff), true) // e_phoff
  view.setUint16(0x36, phentsize, true)
  view.setUint16(0x38, phnum, true)
  // Phdr 0: PT_GNU_STACK with PF_X
  view.setUint32(phoff, 0x6474e551, true)
  view.setUint32(phoff + 4, 0x1, true) // p_flags = PF_X
  // Phdr 1: PT_DYNAMIC
  const p1 = phoff + phentsize
  view.setUint32(p1, 2, true) // PT_DYNAMIC
  view.setBigUint64(p1 + 8, BigInt(dynOffset), true) // p_offset
  view.setBigUint64(p1 + 32, BigInt(dynSize), true) // p_filesz
  for (let i = 0; i < dyn.length; i += 1) {
    const base = dynOffset + i * 16
    view.setBigUint64(base, BigInt(dyn[i]![0]), true)
    view.setBigUint64(base + 8, BigInt(dyn[i]![1]), true)
  }
  return bytes
}

function storedEntry(name: string, data: Uint8Array): OutEntry {
  return {
    name,
    method: 0,
    crc32: crc32Of(data),
    compressedSize: data.byteLength,
    uncompressedSize: data.byteLength,
    flags: 0,
    data,
  }
}

async function writeApk(entries: OutEntry[]): Promise<string> {
  const dir = await mkdtemp(path.join(tmpdir(), "droidseal-tier2-"))
  const apkPath = path.join(dir, "sample.apk")
  await writeFile(apkPath, buildZip(entries))
  return apkPath
}

function missingTool(name: string): ToolLocation {
  return { name, source: "missing", requiredFor: [], detail: "not found in test" }
}

function emptyToolchain(): Toolchain {
  return {
    java: missingTool("java"),
    keytool: missingTool("keytool"),
    aapt: missingTool("aapt"),
    zipalign: missingTool("zipalign"),
    apksigner: missingTool("apksigner"),
    gradleWrapper: missingTool("gradlew"),
  }
}

describe("extractDexStrings", () => {
  test("round-trips the string pool", () => {
    const dex = buildDex(["hello", "Ldalvik/system/DexClassLoader;", "addJavascriptInterface"])
    const result = extractDexStrings(dex)
    expect(result.truncated).toBe(false)
    expect(result.strings).toContain("hello")
    expect(result.strings).toContain("Ldalvik/system/DexClassLoader;")
    expect(result.strings).toContain("addJavascriptInterface")
  })

  test("throws on non-dex buffers", () => {
    expect(() => extractDexStrings(new Uint8Array(200))).toThrow()
  })
})

describe("scanDex", () => {
  test("flags weak crypto, insecure TLS, dynamic loading, webview bridge", () => {
    const codes = scanDex([
      "AES/ECB/PKCS5Padding",
      "Ljavax/crypto/Cipher;",
      "ALLOW_ALL_HOSTNAME_VERIFIER",
      "Ldalvik/system/DexClassLoader;",
      "https://example.invalid/payload.dex",
      "Ljava/lang/Runtime;",
      "exec",
      "addJavascriptInterface",
    ]).map((f) => f.code)
    expect(codes).toContain("DEX_WEAK_CRYPTO")
    expect(codes).toContain("DEX_INSECURE_TLS")
    expect(codes).toContain("DEX_DYNAMIC_CODE_LOADING")
    expect(codes).toContain("DEX_RUNTIME_EXEC")
    expect(codes).toContain("DEX_WEBVIEW_JS_BRIDGE")
  })

  test("flags weak random only when SecureRandom absent", () => {
    expect(scanDex(["Ljava/util/Random;"]).map((f) => f.code)).toContain("DEX_WEAK_RANDOM")
    expect(
      scanDex(["Ljava/util/Random;", "Ljava/security/SecureRandom;"]).map((f) => f.code),
    ).not.toContain("DEX_WEAK_RANDOM")
  })

  test("detects a hardcoded Google API key", () => {
    const key = `AIza${"abcdefghijklmnopqrstuvwxyz012345678"}`
    const findings = scanDex([`apiKey=${key}`])
    expect(findings.map((f) => f.code)).toContain("DEX_HARDCODED_SECRET")
  })
})

describe("detectSdkPackages", () => {
  test("identifies known SDK descriptor prefixes", () => {
    const names = detectSdkPackages([
      "Lcom/google/firebase/messaging/FirebaseMessaging;",
      "Lretrofit2/Retrofit;",
      "Lcom/example/app/Main;",
    ])
    expect(names).toContain("Google Firebase")
    expect(names).toContain("Retrofit")
  })
})

describe("analyzeElf", () => {
  test("infers executable stack, no relro, text relocations", () => {
    const hardening = analyzeElf(buildElf())
    expect(hardening.bits).toBe(64)
    expect(hardening.executableStack).toBe(true)
    expect(hardening.relro).toBe("none")
    expect(hardening.textRelocations).toBe(true)
    expect(hardening.stackCanary).toBe(false)
  })

  test("buildSoFindings maps the gaps to codes", () => {
    const codes = buildSoFindings("libnative.so", analyzeElf(buildElf())).map((f) => f.code)
    expect(codes).toContain("SO_EXECUTABLE_STACK")
    expect(codes).toContain("SO_NO_RELRO")
    expect(codes).toContain("SO_TEXT_RELOCATIONS")
    expect(codes).toContain("SO_NO_STACK_CANARY")
  })

  test("throws on non-elf buffers", () => {
    expect(() => analyzeElf(new Uint8Array(128))).toThrow()
  })

  test("flags PT_LOAD below 16KB page alignment (Google Play 2025-11)", () => {
    // 64-bit ELF:PT_LOAD(p_align=4096, < 16384)+ PT_DYNAMIC
    const phoff = 64
    const phentsize = 56
    const phnum = 2
    const total = phoff + phentsize * phnum
    const bytes = new Uint8Array(total)
    bytes.set([0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0], 0)
    const view = new DataView(bytes.buffer)
    view.setUint16(16, 3, true) // ET_DYN
    view.setBigUint64(0x20, BigInt(phoff), true)
    view.setUint16(0x36, phentsize, true)
    view.setUint16(0x38, phnum, true)
    view.setUint32(phoff, 1, true) // PT_LOAD
    view.setBigUint64(phoff + 40, 4096n, true) // p_align = 4KB(违规;Elf64 p_align@+40)
    view.setUint32(phoff + phentsize, 2, true) // PT_DYNAMIC
    const hardening = analyzeElf(bytes)
    expect(hardening.minLoadAlign).toBe(4096)
    expect(hardening.pageAlign16k).toBe(false)
    const codes = buildSoFindings("libtest.so", hardening).map((f) => f.code)
    expect(codes).toContain("SO_PAGE_ALIGN_16K")
  })

  test("passes PT_LOAD at exactly 16KB alignment", () => {
    const phoff = 64
    const phentsize = 56
    const total = phoff + phentsize
    const bytes = new Uint8Array(total)
    bytes.set([0x7f, 0x45, 0x4c, 0x46, 2, 1, 1, 0], 0)
    const view = new DataView(bytes.buffer)
    view.setUint16(16, 3, true)
    view.setBigUint64(0x20, BigInt(phoff), true)
    view.setUint16(0x36, phentsize, true)
    view.setUint16(0x38, 1, true)
    view.setUint32(phoff, 1, true) // PT_LOAD
    view.setBigUint64(phoff + 40, 16384n, true) // p_align = 16KB(达标;Elf64 p_align@+40)
    const hardening = analyzeElf(bytes)
    expect(hardening.pageAlign16k).toBe(true)
    const codes = buildSoFindings("libtest.so", hardening).map((f) => f.code)
    expect(codes).not.toContain("SO_PAGE_ALIGN_16K")
  })

  test("detects dangerous imports, embedded keys and URLs in .rodata", () => {
    // 构造含标记的 ELF:strcpy(溢出向量)+ RegisterNatives + Google API key + URL
    // (含应被过滤的 XML 命名空间 URL 噪声)
    const markers = [
      "strcpy",
      "RegisterNatives",
      "AIzaSyA1234567890123456789012345678901ab",
      "https://telemetry.evil-cdn.net/collect?v=1",
      "https://schemas.android.com/apk/res/android",
    ].join("\0") + "\0"
    const blob = new TextEncoder().encode(markers)
    const base = buildElf()
    const bytes = new Uint8Array(base.length + blob.length)
    bytes.set(base, 0)
    bytes.set(blob, base.length)
    const hardening = analyzeElf(bytes)
    expect(hardening.bufferOverflowFunctions.length).toBe(1)
    expect(hardening.jniDangerousFunctions.some((t) => t.includes("RegisterNatives"))).toBe(true)
    expect(hardening.embeddedKeyHits).toContain("google-api-key")
    expect(hardening.embeddedUrls).toContain("https://telemetry.evil-cdn.net/collect?v=1")
    // XML 命名空间噪声被过滤
    expect(hardening.embeddedUrls.some((u) => u.includes("schemas.android.com"))).toBe(false)
    const codes = buildSoFindings("libmarker.so", hardening).map((f) => f.code)
    expect(codes).toContain("SO_BUFFER_OVERFLOW_RISK")
    expect(codes).toContain("SO_JNI_DANGEROUS")
    expect(codes).toContain("SO_EMBEDDED_KEY_FORMAT")
    expect(codes).toContain("SO_EMBEDDED_URL")
  })

  test("clean ELF produces no import/key findings", () => {
    const hardening = analyzeElf(buildElf())
    expect(hardening.bufferOverflowFunctions.length).toBe(0)
    expect(hardening.jniDangerousFunctions.length).toBe(0)
    expect(hardening.embeddedKeyHits.length).toBe(0)
    expect(hardening.embeddedUrls.length).toBe(0)
    const codes = buildSoFindings("libclean.so", hardening).map((f) => f.code)
    expect(codes).not.toContain("SO_BUFFER_OVERFLOW_RISK")
    expect(codes).not.toContain("SO_EMBEDDED_KEY_FORMAT")
    expect(codes).not.toContain("SO_EMBEDDED_URL")
  })
})

describe("auditApk integration (no aapt)", () => {
  test("reports DEX, native, and asset findings", async () => {
    const pem = `-----BEGIN ${"RSA"} PRIVATE KEY-----\nMIIEabc\n-----END ${"RSA"} PRIVATE KEY-----`
    const dex = buildDex(["AES/ECB/NoPadding", "Ljavax/crypto/Cipher;", "Ldalvik/system/DexClassLoader;", "payload.dex"])
    const apkPath = await writeApk([
      storedEntry("AndroidManifest.xml", new TextEncoder().encode("manifest")),
      storedEntry("classes.dex", dex),
      storedEntry("lib/arm64-v8a/libnative.so", buildElf()),
      storedEntry("assets/config.txt", new TextEncoder().encode(pem)),
    ])
    const audit = await auditApk(apkPath, emptyToolchain())
    const codes = audit.findings.map((f) => f.code)
    expect(codes).toContain("DEX_WEAK_CRYPTO")
    expect(codes).toContain("DEX_DYNAMIC_CODE_LOADING")
    expect(codes).toContain("SO_EXECUTABLE_STACK")
    expect(codes).toContain("ASSET_EMBEDDED_PRIVATE_KEY")
    expect(codes).toContain("AAPT_NOT_AVAILABLE")
  })
})
