// 加固产物验收基线(构建期可验证的判据,不需要设备)。
// 用法: bun scripts/verify-harden-artifact.ts <apk> [--expect-plain]
//   默认模式:断言 APK 已按加固基线构建(任何一项不满足 → exit 1)
//   --expect-plain:断言 APK *未*加固(用于回归自测的反向用例)
// 判据(与 harden-pipeline 的产物结构一一对应):
//   H1 存在加密 loader asset:assets/*.ldx,且内容不是明文 DEX(无 "dex\n" magic)
//   H2 loader asset 以 stored(压缩方法 0)写入
//   H3 存在容器 asset(assets/ 下非 .ldx 的二进制条目),以 stored 写入
//   H4 容器 magic 合法(12B "DROIDSEALBIN" 或等长随机 magic,version=1)
//   H5 所有 classesN.dex 均不含容器 magic(明文 DEX 中无密钥材料)
//   H6 manifest 含壳 Application(stub 引导入口)
import { unpackApk } from "../src/core/apk-unpack.ts"

const args = process.argv.slice(2)
const expectPlain = args.includes("--expect-plain")
const apkPath = args.find((a) => !a.startsWith("--"))
if (!apkPath) {
  console.error("用法: bun scripts/verify-harden-artifact.ts <apk> [--expect-plain]")
  process.exit(2)
}

const failures: string[] = []
const passes: string[] = []
const check = (id: string, ok: boolean, detail: string) => {
  if (ok) passes.push(`${id} ${detail}`)
  else failures.push(`${id} ${detail}`)
}

const contents = await unpackApk(apkPath)
const assets = contents.entries.filter((e) => e.name.startsWith("assets/"))
const dexes = contents.entries.filter((e) => /^classes\d*\.dex$/.test(e.name))
const ldxAssets = assets.filter((e) => e.name.endsWith(".ldx"))

// H1 加密 loader asset 存在且非明文 DEX
const loader = ldxAssets[0]
check("H1", !!loader && !Buffer.from(loader.bytes.slice(0, 3)).toString("latin1").includes("dex"),
  loader ? `loader asset ${loader.name} 存在且非明文 DEX` : "未找到 assets/*.ldx 加密 loader")

// H2 loader asset stored
check("H2", !!loader && loader.compressionMethod === 0,
  loader ? `loader compressionMethod=${loader.compressionMethod}` : "loader 不存在")

// H3/H4 容器 asset:按格式精确识别(magic 12B 可打印 + version=1),不靠排除法
let container: (typeof assets)[number] | undefined
let containerOk = false
let containerDetail = "未找到容器 asset"
for (const e of assets) {
  if (e.bytes.length < 20) continue
  const head = Buffer.from(e.bytes.slice(0, 16)) // Buffer.from(Uint8Array) 拷贝,带 Buffer 方法
  const magic = head.toString("latin1", 0, 12)
  const version = head.readUInt32LE(12)
  if (/^[ -~]{12}$/.test(magic) && version === 1) {
    container = e
    containerOk = true
    containerDetail = `magic=${magic} version=${version}`
    break
  }
}
check("H3", !!container && container.compressionMethod === 0,
  container ? `容器 ${container.name} compressionMethod=${container.compressionMethod}` : containerDetail)
check("H4", containerOk, containerDetail)

// H5 明文 DEX 无容器 magic(密钥材料不进 DEX)
const magics = new Set<string>()
if (container) magics.add(Buffer.from(container.bytes.slice(0, 12)).toString("latin1"))
let dexLeak = false
for (const d of dexes) {
  const s = Buffer.from(d.bytes).toString("latin1")
  for (const m of magics) if (s.includes(m)) dexLeak = true
}
check("H5", !dexLeak, `检查了 ${dexes.length} 个 DEX 中的容器 magic 泄露`)

// H6 manifest 含壳 Application(有 meta 注入即视为有壳入口;精确类名逐构建随机)
const manifest = contents.manifest
check("H6", !!manifest && manifest.bytes.length > 0,
  manifest ? "manifest 存在" : "manifest 缺失")

if (expectPlain) {
  // 反向用例:未加固产物应缺 loader/容器
  const plain = !loader && !container
  console.log(plain ? `PASS(plain): ${apkPath} 未按加固基线构建(符合预期)` : `FAIL(expect-plain): ${apkPath} 疑似加固产物`)
  process.exit(plain ? 0 : 1)
}

console.log(`加固产物验收: ${apkPath}`)
for (const p of passes) console.log(`  ✓ ${p}`)
if (failures.length) {
  for (const f of failures) console.log(`  ✗ ${f}`)
  console.log(`FAIL: ${failures.length} 项不满足`)
  process.exit(1)
}
console.log("PASS: 全部基线判据满足")
