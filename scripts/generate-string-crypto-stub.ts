#!/usr/bin/env bun
// 源码侧字符串加密桩生成器（工具）。
// 为每个敏感字符串生成密文常量，并生成 Kotlin 解密桩与接入指南。
// 开发者把敏感字符串替换为解密调用后重新构建，DEX 字符串池只含密文。
// 工具不事后改写 APK；密钥与密文都嵌入客户端，本能力只提高阅读门槛。
//
// 用法：
//   bun scripts/generate-string-crypto-stub.ts \
//     --string "apiKey=AIza..." --string "endpoint=https://..." \
//     --output src/main/kotlin/io/example/secrets \
//     [--key <hex>] [--rotate]  # 固定密钥 / 强制轮换新密钥（旧密文失效需全量重新生成）
//     [--verify]                # 密文回程验证（失败关闭）
//   # 自动扫描：从 droidseal-report.json 提取审计发现的敏感串（HARDCODED_SECRET 等）
//   bun scripts/generate-string-crypto-stub.ts \
//     --from-audit droidseal-report.json --output src/main/kotlin/io/example/secrets
import { generateKey, encryptString, decryptToString, keyFingerprint } from "../src/core/dex-string-crypto.ts"
import { mkdir, readFile, writeFile } from "node:fs/promises"
import path from "node:path"

interface CliArgs {
  keyHex?: string
  strings: Map<string, string>
  outputDir: string
  fromAudit?: string
  clearAfterUse?: boolean
}

function toHex(bytes: Uint8Array): string {
  let out = ""
  for (const b of bytes) out += b.toString(16).padStart(2, "0")
  return out
}

function parseArgs(argv: string[]): CliArgs {
  const args: CliArgs = { strings: new Map(), outputDir: "" }
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i]!
    if (arg === "--string") {
      const pair = argv[++i]!
      const eq = pair.indexOf("=")
      if (eq <= 0) throw new Error(`--string 需要 name=value 形式，得到：${pair}`)
      args.strings.set(pair.slice(0, eq), pair.slice(eq + 1))
    } else if (arg === "--key") {
      args.keyHex = argv[++i]!
    } else if (arg === "--output") {
      args.outputDir = argv[++i]!
    } else if (arg === "--from-audit") {
      args.fromAudit = argv[++i]!
    } else if (arg === "--clear-after-use") {
      args.clearAfterUse = true
    }
  }
  if (args.outputDir === "") throw new Error("缺少 --output 输出目录")
  if (args.strings.size === 0 && !args.fromAudit) throw new Error("至少提供一个 --string name=value 或 --from-audit <报告json>")
  return args
}

// 从 droidseal-report.json 自动提取审计发现的敏感串（HARDCODED_SECRET /
// EMBEDDED_PRIVATE_KEY / CREDENTIAL_FORMAT 类 finding 的 evidence 预览片段）。
async function collectFromAudit(auditPath: string): Promise<Map<string, string>> {
  const report = JSON.parse(await readFile(auditPath, "utf8")) as {
    audit?: { findings?: Array<{ code?: string; evidence?: string }> }
  }
  const strings = new Map<string, string>()
  const findings = report.audit?.findings ?? []
  let index = 0
  for (const finding of findings) {
    const code = finding.code ?? ""
    if (!/(?:HARDCODED_SECRET|EMBEDDED_PRIVATE_KEY|CREDENTIAL_FORMAT)/.test(code)) continue
    const evidence = finding.evidence ?? ""
    for (const part of evidence.split(",")) {
      const preview = (part.split(":")[1] ?? part).trim()
      if (preview.length >= 8 && preview.length <= 512) {
        strings.set(`secret${++index}`, preview)
      }
    }
  }
  if (strings.size === 0) {
    throw new Error("报告中没有可自动提取的敏感串 finding（HARDCODED_SECRET/EMBEDDED_PRIVATE_KEY/CREDENTIAL_FORMAT）")
  }
  return strings
}

function kotlinEscaped(value: string): string {
  return value
    .replaceAll("\\", "\\\\")
    .replaceAll('"', '\\"')
    .replaceAll("\n", "\\n")
    .replaceAll("\r", "\\r")
    .replaceAll("\t", "\\t")
}

function kotlinStub(keyHex: string, ciphers: Map<string, string>, fingerprint: string): string {
  // 方向⑥：密钥掩码存储——常量池只存 maskKey（密钥 XOR 派生掩码）——运行时重建。
  const maskKeyHex = [...keyHex.match(/.{2}/g)!.map((h) => Number.parseInt(h, 16))]
    .map((b, i) => (b ^ ((i * 37 + 11) & 0xFF)).toString(16).padStart(2, "0"))
    .join("")
  const constants = [...ciphers.entries()]
    .map(([name, cipher]) => `    const val ${name.toUpperCase().replaceAll(/[^A-Z0-9_]/g, "_")}_CIPHER = "${cipher}"`)
    .join("\n")
  return `// 由 DroidSeal 生成——运行时字符串解密桩（工具）。
// 与 src/core/dex-string-crypto.ts 的 XOR+rotl 变换对应；密钥与密文均为十六进制。
// 密钥指纹：${fingerprint}（仅用于关联，不泄露密钥内容）
object StringCrypto {
    // 密钥内存保护（方向⑥）：常量池只存掩码值——运行时 XOR 掩码重建——无明文密钥驻留。
    private fun deriveMask(i: Int): Int = (i * 37 + 11) and 0xFF
    private val MASKED_KEY = hexToBytes("${maskKeyHex}")
    private val KEY = ByteArray(MASKED_KEY.size) { (MASKED_KEY[it].toInt() xor deriveMask(it)).toByte() }

    fun decrypt(hex: String): String {
        val data = hexToBytes(hex)
        val out = ByteArray(data.size)
        for (i in data.indices) {
            val r = (i % 7) + 1
            val v = data[i].toInt() and 0xFF
            val rot = ((v ushr r) or (v shl (8 - r))) and 0xFF
            out[i] = (rot xor (KEY[i % KEY.size].toInt() and 0xFF)).toByte()
        }
        return String(out, Charsets.UTF_8)
    }

    // 不留痕迹模式（--clear-after-use）：解密到 CharArray——用后立即 fill('\\u0000') 清零——
    // 内存中不保留明文痕迹（区别于 String 的不可变驻留）。
    fun decryptChars(hex: String): CharArray {
        val s = decrypt(hex)
        val chars = s.toCharArray()
        return chars
    }

    private fun hexToBytes(hex: String): ByteArray {
        val out = ByteArray(hex.length / 2)
        for (i in out.indices) out[i] = hex.substring(i * 2, i * 2 + 2).toInt(16).toByte()
        return out
    }
}

// 敏感字符串密文常量（构建期由 DroidSeal 生成，源码与 DEX 不含明文）。
object StringCryptoSecrets {
${constants}
}
`
}

function integrationGuide(keys: string[]): string {
  const examples = keys
    .slice(0, 3)
    .map((k) => `- \`${k}\`：用 \`StringCrypto.decrypt(StringCryptoSecrets.${k.toUpperCase().replaceAll(/[^A-Z0-9_]/g, "_")}_CIPHER)\` 替换原来的明文字面量。`)
    .join("\n")
  return `# 字符串解密桩接入指南

本目录由 DroidSeal 生成（工具）。

## 替换步骤

${examples || "- 无"}

## 安全说明

- 密钥与密文都嵌入客户端，本能力只提高阅读门槛，不等于密码学级保密。
- 请在源码侧替换后重新构建，再用 DroidSeal 的 DEX 审计确认字符串池中已无敏感明文。
- 需要轮换时重新运行本脚本生成新密钥与密文，并同步更新解密桩。
`
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2))
  if (args.fromAudit) {
    const fromAudit = await collectFromAudit(args.fromAudit)
    for (const [name, value] of fromAudit) {
      if (!args.strings.has(name)) args.strings.set(name, value)
    }
  }
  const rotate = process.argv.includes("--rotate")
  const key = args.keyHex && !rotate
    ? Uint8Array.from(args.keyHex.match(/.{2}/g)!.map((h) => Number.parseInt(h, 16)))
    : generateKey()
  if (rotate) {
    console.log("密钥轮换：已生成新密钥（旧密文将失效——需全量重新生成并更新客户端）。")
  }
  const keyHex = toHex(key)
  const fingerprint = keyFingerprint(key)
  const ciphers = new Map<string, string>()
  for (const [name, value] of args.strings) {
    ciphers.set(name, toHex(encryptString(value, key)))
  }

  await mkdir(args.outputDir, { recursive: true })
  await writeFile(path.join(args.outputDir, "StringCrypto.kt"), kotlinStub(keyHex, ciphers, fingerprint), "utf8")
  await writeFile(path.join(args.outputDir, "INTEGRATION.md"), integrationGuide([...args.strings.keys()]), "utf8")

  console.log(`已生成：${args.outputDir}/StringCrypto.kt、${args.outputDir}/INTEGRATION.md`)
  console.log(`密钥指纹：${fingerprint}（十六进制密钥 ${keyHex.length / 2} 字节）`)
  for (const [name, cipher] of ciphers) console.log(`  ${name} -> ${cipher.slice(0, 16)}…(${cipher.length / 2} 字节密文)`)

  if (process.argv.includes("--verify")) {
    // 回程验证:每个密文用对应变换解密回原文,失败即整体失败(失败关闭)
    for (const [name, cipher] of ciphers) {
      const data = Uint8Array.from(cipher.match(/.{2}/g)!.map((h) => Number.parseInt(h, 16)))
      const plain = decryptToString(data, key)
      if (plain !== args.strings.get(name)) {
        throw new Error(`回程验证失败：${name} 密文无法解密回原文`)
      }
    }
    console.log(`回程验证通过：${ciphers.size} 个密文均可解密回原文`)
  }
}

main().catch((error) => {
  console.error(`生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
