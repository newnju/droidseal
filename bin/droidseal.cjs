#!/usr/bin/env node
"use strict"

// DroidSeal npm 入口:校验发行 bundle 完整性后以当前 Node 进程加载执行。
// 发行物 = dist/droidseal.mjs(Node ≥18 单文件 bundle,含 Node 兼容 shim)。

const { createHash } = require("node:crypto")
const { createReadStream, existsSync, readFileSync } = require("node:fs")
const path = require("node:path")
const { pathToFileURL } = require("node:url")

function fail(message) {
  console.error(`[DroidSeal] ${message}`)
  process.exitCode = 1
}

function sha256(file) {
  return new Promise((resolve, reject) => {
    const hash = createHash("sha256")
    const stream = createReadStream(file)
    stream.on("data", (chunk) => hash.update(chunk))
    stream.on("error", reject)
    stream.on("end", () => resolve(hash.digest("hex")))
  })
}

async function main() {
  if (typeof process.versions.node !== "string") {
    fail("未检测到 Node.js 运行时。")
    return
  }
  const nodeMajor = Number.parseInt(process.versions.node.split(".")[0] ?? "0", 10)
  if (!Number.isFinite(nodeMajor) || nodeMajor < 18) {
    fail(`DroidSeal 需要 Node.js ≥ 18,当前 ${process.versions.node}。`)
    return
  }

  const packageRoot = path.resolve(__dirname, "..")
  const distDirectory = path.join(packageRoot, "dist")
  const bundle = path.join(distDirectory, "droidseal.mjs")
  const metadataPath = path.join(distDirectory, "droidseal-node-build.json")

  if (!existsSync(bundle) || !existsSync(metadataPath)) {
    fail(`安装不完整:缺少 ${path.basename(bundle)} 或构建元数据,请重新安装 npm 包。`)
    return
  }

  let metadata
  try {
    metadata = JSON.parse(readFileSync(metadataPath, "utf8"))
  } catch (error) {
    fail(`无法读取构建元数据:${error instanceof Error ? error.message : String(error)}`)
    return
  }

  if (
    metadata?.schemaVersion !== 1 ||
    metadata?.runtime !== "node" ||
    metadata?.artifact?.path !== "droidseal.mjs" ||
    !/^[a-f0-9]{64}$/.test(metadata?.artifact?.sha256 ?? "")
  ) {
    fail("构建元数据格式无效,拒绝执行未经确认的代码。")
    return
  }

  const actualHash = await sha256(bundle)
  if (actualHash !== metadata.artifact.sha256) {
    fail("droidseal.mjs 完整性校验失败;文件可能损坏或被修改,请重新安装。")
    return
  }

  await import(pathToFileURL(bundle).href)
}

main().catch((error) => {
  fail(error instanceof Error ? error.message : String(error))
})
