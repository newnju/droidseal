#!/usr/bin/env bun
// 签名指纹管理脚本（开发路线「构建期/发布工程化」——signing-rotation.ts）。
// 多签名 / 轮换清单生成与校验：记录签名历史（旧指纹 → 新指纹），
// 校验当前 APK 的签名指纹是否在清单中（轮换期间新旧签名都应接受）——失败关闭。
//
// 用法：
//   bun scripts/signing-rotation.ts <清单.json> verify <指纹>          # 校验指纹是否在清单
//   bun scripts/signing-rotation.ts <清单.json> rotate <旧指纹> <新指纹> # 记录一次轮换
//   bun scripts/signing-rotation.ts <清单.json> generate --current <指纹> # 生成初始清单
import { readFile, writeFile } from "node:fs/promises"

interface RotationEntry {
  fingerprint: string
  rotatedAt: string
  note?: string
}

interface RotationManifest {
  schemaVersion: 1
  entries: RotationEntry[]
}

async function loadManifest(path: string): Promise<RotationManifest> {
  try {
    const raw = await readFile(path, "utf8")
    const parsed = JSON.parse(raw) as RotationManifest
    if (!Array.isArray(parsed.entries)) throw new Error("清单格式无效")
    return parsed
  } catch {
    return { schemaVersion: 1, entries: [] }
  }
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const manifestPath = argv[0]
  const action = argv[1]
  if (!manifestPath || !action) throw new Error("用法: signing-rotation <清单.json> <verify|rotate|generate> ...")
  const manifest = await loadManifest(manifestPath)

  if (action === "generate") {
    const current = argv[argv.indexOf("--current") + 1]
    if (!current) throw new Error("generate 需要 --current <指纹>")
    manifest.entries.push({ fingerprint: current, rotatedAt: new Date().toISOString(), note: "初始签名" })
    await writeFile(manifestPath, JSON.stringify(manifest, null, 2), "utf8")
    console.log(`已生成签名清单：${manifestPath}（${manifest.entries.length} 个签名）`)
    return
  }

  if (action === "rotate") {
    const oldFp = argv[2]
    const newFp = argv[3]
    if (!oldFp || !newFp) throw new Error("rotate 需要 <旧指纹> <新指纹>")
    if (!manifest.entries.some((e) => e.fingerprint === oldFp)) {
      throw new Error(`旧指纹不在清单中——轮换前先加入（${oldFp.slice(0, 16)}…）`)
    }
    manifest.entries.push({ fingerprint: newFp, rotatedAt: new Date().toISOString(), note: `由 ${oldFp.slice(0, 16)}… 轮换` })
    await writeFile(manifestPath, JSON.stringify(manifest, null, 2), "utf8")
    console.log(`已记录签名轮换：${manifest.entries.length} 个签名（旧 ${oldFp.slice(0, 16)}… → 新 ${newFp.slice(0, 16)}…）`)
    return
  }

  if (action === "verify") {
    const fp = argv[2]
    if (!fp) throw new Error("verify 需要 <指纹>")
    const found = manifest.entries.some((e) => e.fingerprint.toLowerCase() === fp.toLowerCase())
    if (found) {
      console.log(`✓ 指纹在签名清单中（${manifest.entries.length} 个签名——轮换期兼容）`)
    } else {
      console.error(`✗ 指纹不在签名清单中——可能被篡改或未登记`)
      process.exitCode = 1
    }
    return
  }

  throw new Error(`未知动作：${action}`)
}

main().catch((error) => {
  console.error(`签名指纹管理失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
