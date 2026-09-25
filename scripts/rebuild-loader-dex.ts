// 重编 runtime Java 源为 droidseal-loader.dex(javac 1.8 目标 + d8)
import { execSync } from "node:child_process"
import { mkdtempSync, cpSync, readdirSync, statSync, rmSync, existsSync, mkdirSync } from "node:fs"
import { join } from "node:path"
import { tmpdir } from "node:os"

const root = process.cwd()
const javaDir = join(root, "runtime", "java")
const outDex = join(root, "runtime", "droidseal-loader.dex")

const sdk = process.env.LOCALAPPDATA ? join(process.env.LOCALAPPDATA, "Android", "Sdk") : null
if (!sdk || !existsSync(sdk)) { console.error("Android SDK not found"); process.exit(1) }
const btDir = join(sdk, "build-tools")
const bt = readdirSync(btDir).sort().pop()
const platform = join(sdk, "platforms", readdirSync(join(sdk, "platforms")).sort().pop()!, "android.jar")

const tmp = mkdtempSync(join(tmpdir(), "dsloader-"))
const classes = join(tmp, "classes")
const javaSrc = join(tmp, "src")
cpSync(javaDir, javaSrc, { recursive: true })

// 收集所有 .java
const javaFiles: string[] = []
const walk = (d: string) => {
  for (const f of readdirSync(d)) {
    const p = join(d, f)
    if (statSync(p).isDirectory()) walk(p)
    else if (f.endsWith(".java")) javaFiles.push(p)
  }
}
walk(javaSrc)

execSync(`javac -source 8 -target 8 -bootclasspath "${platform}" -d "${classes}" ${javaFiles.map((f) => `"${f}"`).join(" ")}`, { stdio: "inherit" })

// d8 不接受通配符,逐个收集 .class
const classFiles: string[] = []
const walkCls = (d: string) => {
  for (const f of readdirSync(d)) {
    const p = join(d, f)
    if (statSync(p).isDirectory()) walkCls(p)
    else if (f.endsWith(".class")) classFiles.push(p)
  }
}
walkCls(classes)

const d8 = join(btDir, bt!, "d8.bat")

// 双 DEX 拆分:BootstrapStub* 独立成明文 stub DEX,其余(含内部类)为 loader DEX
const loaderClasses = classFiles.filter((f) => !/[\\/]BootstrapStub(\$[\w$]+)?\.class$/.test(f))
const stubClasses = classFiles.filter((f) => /[\\/]BootstrapStub(\$[\w$]+)?\.class$/.test(f))
if (stubClasses.length === 0) { console.error("BootstrapStub not compiled — check runtime/java"); process.exit(1) }

const outLoader = join(tmp, "loader")
const outStub = join(tmp, "stub")
mkdirSync(outLoader, { recursive: true })
mkdirSync(outStub, { recursive: true })
execSync(`"${d8}" --release --min-api 21 --lib "${platform}" --output "${outLoader}" ${loaderClasses.map((f) => `"${f}"`).join(" ")}`, { stdio: "inherit" })
execSync(`"${d8}" --release --min-api 21 --lib "${platform}" --output "${outStub}" ${stubClasses.map((f) => `"${f}"`).join(" ")}`, { stdio: "inherit" })

const { copyFileSync } = await import("node:fs")
copyFileSync(join(outLoader, "classes.dex"), outDex)
copyFileSync(join(outStub, "classes.dex"), join(root, "runtime", "droidseal-stub.dex"))
rmSync(tmp, { recursive: true, force: true })
console.log("loader DEX rebuilt:", outDex)
console.log("stub DEX rebuilt:", join(root, "runtime", "droidseal-stub.dex"))
