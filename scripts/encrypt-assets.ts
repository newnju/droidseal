#!/usr/bin/env bun
// assets 资源轻量加密工具（开发路线 ②——docs/assets-encryption-plan.md 的工具落地）。
// 构建期调用：对 assets/raw 下文件做轻量变换（XOR+rotl，与 dex-string-crypto 一致，零依赖），
// 输出 .enc 文件与 manifest.json；应用侧按清单解密（源码接入，不事后改写 APK）。
//
// 用法：
//   bun scripts/encrypt-assets.ts --dir assets/raw --output assets/enc [--key <hex>]
import { generateKey, encryptBytes, keyFingerprint } from "../src/core/dex-string-crypto.ts"
import { mkdir, readFile, readdir, writeFile } from "node:fs/promises"
import path from "node:path"

interface CliArgs {
  inputDir: string
  outputDir: string
  keyHex?: string
  genReaderDir?: string
}

function toHex(bytes: Uint8Array): string {
  let out = ""
  for (const b of bytes) out += b.toString(16).padStart(2, "0")
  return out
}

function parseArgs(argv: string[]): CliArgs {
  const args: CliArgs = { inputDir: "", outputDir: "" }
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i]!
    if (arg === "--dir") args.inputDir = argv[++i]!
    else if (arg === "--output") args.outputDir = argv[++i]!
    else if (arg === "--key") args.keyHex = argv[++i]!
    else if (arg === "--gen-reader") args.genReaderDir = argv[++i]!
  }
  if (args.inputDir === "" || args.outputDir === "") throw new Error("用法: encrypt-assets --dir <输入目录> --output <输出目录> [--key <hex>] [--gen-reader <解密器输出目录>]")
  return args
}

// 生成 Kotlin 解密器(AssetsReader.kt):嵌入密钥与清单,运行时按清单解密 .enc。
function assetsReaderKotlin(keyHex: string, fingerprint: string, manifest: Array<{ raw: string; enc: string }>): string {
  const entries = manifest
    .map((entry) => `        AssetEntry("${entry.raw.replaceAll('"', '\\"')}", "${entry.enc.replaceAll('"', '\\"')}")`)
    .join(",\n")
  return `// 由 DroidSeal 生成——assets 资源解密器（源码接入，与 encrypt-assets 的 XOR+rotl 变换对应）。
// 密钥指纹：${fingerprint}
package com.example.secrets

import android.content.Context
import java.io.ByteArrayInputStream
import java.io.InputStream

object AssetsReader {
    private data class AssetEntry(val raw: String, val enc: String)
    private val MANIFEST = listOf(
${entries}
    )
    private val KEY = hexToBytes("${keyHex}")

    fun open(context: Context, rawPath: String): InputStream {
        val entry = MANIFEST.firstOrNull { it.raw == rawPath }
        val stream = if (entry != null) context.assets.open(entry.enc) else context.assets.open(rawPath)
        return if (entry != null) decrypt(stream) else stream
    }

    private fun decrypt(input: InputStream): InputStream {
        val bytes = input.readBytes()
        val out = ByteArray(bytes.size)
        for (i in bytes.indices) {
            val r = (i % 7) + 1
            val v = bytes[i].toInt() and 0xFF
            val rot = ((v ushr r) or (v shl (8 - r))) and 0xFF
            out[i] = (rot xor (KEY[i % KEY.size].toInt() and 0xFF)).toByte()
        }
        return ByteArrayInputStream(out)
    }

    private fun hexToBytes(hex: String): ByteArray {
        val out = ByteArray(hex.length / 2)
        for (i in out.indices) out[i] = hex.substring(i * 2, i * 2 + 2).toInt(16).toByte()
        return out
    }
}
`
}

async function collectFiles(dir: string): Promise<string[]> {
  const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
  return entries.filter((entry) => !entry.includes("." + "DS_Store"))
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2))
  const key = args.keyHex
    ? Uint8Array.from(args.keyHex.match(/.{2}/g)!.map((h) => Number.parseInt(h, 16)))
    : generateKey()
  const fingerprint = keyFingerprint(key)
  await mkdir(args.outputDir, { recursive: true })

  const files = await collectFiles(args.inputDir)
  if (files.length === 0) throw new Error(`输入目录无文件：${args.inputDir}`)
  const manifest: Array<{ raw: string; enc: string; algorithm: string; keyFingerprint: string }> = []
  let encrypted = 0
  for (const file of files) {
    const rawPath = path.join(args.inputDir, file)
    const data = await readFile(rawPath)
    const cipher = encryptBytes(data, key)
    const encName = `${file}.enc`
    const encPath = path.join(args.outputDir, encName)
    await mkdir(path.dirname(encPath), { recursive: true })
    await writeFile(encPath, cipher)
    manifest.push({
      raw: file.replaceAll("\\", "/"),
      enc: encName.replaceAll("\\", "/"),
      algorithm: "xor-rotl",
      keyFingerprint: fingerprint,
    })
    encrypted += 1
  }
  await writeFile(path.join(args.outputDir, "manifest.json"), JSON.stringify(manifest, null, 2) + "\n", "utf8")
  console.log(`已加密 ${encrypted} 个文件 → ${args.outputDir}（含 manifest.json）`)
  console.log(`密钥指纹：${fingerprint}（${key.length} 字节；密钥嵌入客户端，只提高阅读门槛）`)
  if (args.genReaderDir) {
    await mkdir(args.genReaderDir, { recursive: true })
    await writeFile(path.join(args.genReaderDir, "AssetsReader.kt"), assetsReaderKotlin(toHex(key), fingerprint, manifest), "utf8")
    console.log(`已生成解密器：${args.genReaderDir}/AssetsReader.kt（源码接入，运行时按清单解密 .enc）`)
  }
}

main().catch((error) => {
  console.error(`加密失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
