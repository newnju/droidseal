#!/usr/bin/env bun
// 签名证书 SHA-256 指纹清单生成与校验（中期路线：构建期/发布工程化）。
// 用 keytool -list -v 读取签名库证书，输出证书的 SHA-256 指纹清单（供
// DroidSeal 报告/checkApkSignature 预期值/密钥轮换清单使用）。
// 密码只从 DROIDSEAL_STORE_PASSWORD 环境变量读取，不回显、不落命令参数日志。
//
// 用法：
//   bun scripts/signing-fingerprints.ts --keystore release.jks --alias myalias
//   bun scripts/signing-fingerprints.ts --keystore release.jks --alias myalias \
//       --expect sha256:AAAA:BBBB:...   # 校验是否匹配（多指纹以逗号分隔）
import { spawnSync } from "node:child_process"

interface CliArgs {
  keystore: string
  alias: string
  expect?: string
}

function parseArgs(argv: string[]): CliArgs {
  const args: CliArgs = { keystore: "", alias: "" }
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i]!
    if (arg === "--keystore") args.keystore = argv[++i]!
    else if (arg === "--alias") args.alias = argv[++i]!
    else if (arg === "--expect") args.expect = argv[++i]!
  }
  if (args.keystore === "") throw new Error("缺少 --keystore 签名库路径")
  if (args.alias === "") throw new Error("缺少 --alias 密钥别名")
  return args
}

function normalizeFingerprint(value: string): string {
  return value.toLowerCase().replaceAll(":", "").replaceAll(" ", "")
}

function main(): void {
  const args = parseArgs(process.argv.slice(2))
  const password = process.env.DROIDSEAL_STORE_PASSWORD
  if (!password) throw new Error("缺少环境变量 DROIDSEAL_STORE_PASSWORD（密码不回显、不落参数日志）")

  const result = spawnSync(
    "keytool",
    ["-list", "-v", "-keystore", args.keystore, "-alias", args.alias, "-storepass", password],
    { encoding: "utf8" },
  )
  if (result.status !== 0) {
    throw new Error(`keytool 读取失败（status ${result.status}）：${result.stderr?.trim() || "未知错误"}`)
  }
  const output = result.stdout ?? ""
  const fingerprints: string[] = []
  for (const line of output.split(/\r?\n/)) {
    const match = /^\s*SHA256:\s*([0-9A-Fa-f:]+)\s*$/.exec(line)
    if (match) fingerprints.push(normalizeFingerprint(match[1]!))
  }
  if (fingerprints.length === 0) throw new Error("未从 keytool 输出解析到证书 SHA-256 指纹")

  console.log(`签名库：${args.keystore}`)
  console.log(`别名：${args.alias}`)
  console.log(`证书 SHA-256 指纹（${fingerprints.length} 个）：`)
  for (const fp of fingerprints) console.log(`  ${fp}`)

  if (args.expect) {
    const expected = args.expect.split(",").map(normalizeFingerprint)
    const matched = fingerprints.some((fp) => expected.includes(fp))
    if (!matched) {
      console.error("❌ 校验失败：实际指纹与预期清单不匹配（可能密钥轮换或别名指向其他证书）")
      process.exitCode = 1
    } else {
      console.log("✅ 校验通过：指纹与预期清单匹配（支持多签名轮换）")
    }
  }
}

try {
  main()
} catch (error) {
  console.error(`失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
}
