// Node 发行 bundle 构建脚本:产出 dist/droidseal.mjs(Node ≥18 单文件)。
// 与 scripts/build.ts(Bun exe)并存,npm publish 走本脚本产物。
// 流程:Bun.build(target=node) → 顶部注入 Node 兼容 shim → Terser 压缩 → 元数据 JSON。
import { createHash } from "node:crypto"
import { mkdir, readFile, writeFile } from "node:fs/promises"
import path from "node:path"
import { fileURLToPath } from "node:url"
import { minify } from "terser"

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..")
const distDirectory = path.join(projectRoot, "dist")
const shimPath = path.join(projectRoot, "scripts", "node-shim.js")

const result = await Bun.build({
  entrypoints: [path.join(projectRoot, "scripts", "node-entry.ts")],
  target: "node",
  format: "esm",
  outdir: distDirectory,
  naming: { entry: "droidseal.mjs", chunk: "droidseal-chunk-[hash].mjs" },
  // 代码分割:把 TUI(OpenTUI/Solid)代码拆进独立 chunk,只在 TUI 分支动态加载;
  // 否则 JSX 转换的静态 import(jsx-dev-runtime)会在模块加载期执行,CLI 模式直接崩。
  splitting: true,
  sourcemap: "none",
  minify: false,
  // OpenTUI 原生模块与 solid-js 仅 TUI 使用,运行时动态加载,不打进 bundle
  // (TUI 模式需用户另行安装;CLI 模式无需这些依赖)
  external: ["@opentui/core", "@opentui/solid", "@opentui/core-*", "solid-js"],
})

if (!result.success) {
  for (const log of result.logs) console.error(log)
  throw new Error("Bun build (node target) failed")
}

const output = result.outputs.find((o) => o.kind === "entry-point")
if (!output) throw new Error("Bun build did not return an entry-point")

const rawSourceClean = (await output.text()).replace(/^#![^\n]*\n/, "")
// shim 由 scripts/node-entry.ts 在 bundle 内引入(作用域由 bundler 管理)

// 压缩失败可降级(node-target 产物中个别语法 Terser 解析不了),不影响功能
let bundled = rawSourceClean
let minifiedFlag = false
try {
  const minified = await minify(rawSourceClean, {
    ecma: 2022,
    module: true,
    compress: { passes: 2 },
    mangle: { toplevel: true },
    format: { comments: false },
  })
  if (minified.code) {
    bundled = minified.code
    minifiedFlag = true
  }
} catch (minifyError) {
  console.warn(`Terser 压缩失败,降级输出未压缩 bundle: ${minifyError instanceof Error ? minifyError.message.slice(0, 120) : String(minifyError)}`)
}

await mkdir(distDirectory, { recursive: true })
const outputPath = path.join(distDirectory, "droidseal.mjs")
await writeFile(outputPath, bundled, "utf8")

const sha256 = createHash("sha256").update(bundled).digest("hex")
const metadata = {
  schemaVersion: 1,
  runtime: "node",
  engines: ">=18",
  minified: minifiedFlag,
  artifact: {
    path: "droidseal.mjs",
    sha256,
    bytes: Buffer.byteLength(bundled, "utf8"),
  },
  builtAt: new Date().toISOString(),
}
await writeFile(path.join(distDirectory, "droidseal-node-build.json"), JSON.stringify(metadata, null, 2), "utf8")

console.log(`Node bundle: ${outputPath} (${(metadata.artifact.bytes / 1024 / 1024).toFixed(1)} MiB, sha256 ${sha256.slice(0, 16)}…)`)
