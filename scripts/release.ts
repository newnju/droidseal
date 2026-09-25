// 发布流程(本地验证 + git tag;不做任何上传/推送——npm publish 与 git push 由人手动执行)
// 用法: bun scripts/release.ts <version>
//   例: bun scripts/release.ts 1.0.2
// 步骤:
//   V1 版本号格式与一致性(必须合法 semver;package.json/pyproject.toml 可 --sync 同步)
//   V2 本地验证:tsc 0 错误 + 全量测试
//   V3 npm pack 冒烟:tarball 可构建且白名单完整(运行时 DEX、challenge-server)
//   V4 工作区干净(无未提交改动——tag 必须指向已提交状态)
//   V5 创建 git tag(仅本地;推送由人执行: git push origin <tag>)
import { execSync } from "node:child_process"
import { readFileSync, writeFileSync, existsSync } from "node:fs"

const version = process.argv[2]
const sync = process.argv.includes("--sync")
if (!version || !/^\d+\.\d+\.\d+(-[\w.]+)?$/.test(version)) {
  console.error("用法: bun scripts/release.ts <version> [--sync]  (version 须为 semver,如 1.0.2)")
  process.exit(2)
}

let ok = true
// 任一步失败即短路——不浪费后续慢步骤,也不留半完成状态
const step = (name: string, fn: () => void) => {
  if (!ok) return false
  try { fn(); console.log(`  ✓ ${name}`); return true }
  catch (e) { console.log(`  ✗ ${name}: ${e instanceof Error ? e.message.split("\n")[0] : String(e)}`); ok = false; return false }
}
console.log(`发布准备: ${version}`)

// V1 一致性
ok = step("V1 package.json 版本", () => {
  const pkg = JSON.parse(readFileSync("package.json", "utf8"))
  if (pkg.version !== version) {
    if (!sync) throw new Error(`package.json 是 ${pkg.version}——加 --sync 同步,或先手动改版本`)
    pkg.version = version
    writeFileSync("package.json", JSON.stringify(pkg, null, 2) + "\n")
    console.log(`    (package.json → ${version})`)
  }
  const pyproject = "python-wrapper/pyproject.toml"
  if (existsSync(pyproject)) {
    const t = readFileSync(pyproject, "utf8")
    if (!t.includes(`version = "${version}"`)) {
      if (!sync) throw new Error(`${pyproject} 版本不一致——加 --sync 或手动改`)
      writeFileSync(pyproject, t.replace(/version = "[^"]+"/, `version = "${version}"`))
      console.log(`    (${pyproject} → ${version})`)
    }
  }
}) && ok

// V2 本地验证
ok = step("V2 tsc --noEmit", () => execSync("bun run check", { stdio: "pipe" })) && ok
ok = step("V2 bun test", () => execSync("bun test", { stdio: "pipe" })) && ok

// V3 npm pack 冒烟(不写入文件)
ok = step("V3 npm pack --dry-run 白名单", () => {
  const out = execSync("npm pack --dry-run 2>&1", { stdio: "pipe", shell: "bash" }).toString()
  for (const f of ["runtime/droidseal-loader.dex", "runtime/droidseal-stub.dex", "scripts/challenge-server.ts", "README.md"]) {
    if (!out.includes(f)) throw new Error(`npm 包白名单缺 ${f}`)
  }
}) && ok

// V4 工作区干净
ok = step("V4 工作区干净", () => {
  const s = execSync("git status --porcelain", { stdio: "pipe" }).toString().trim()
  if (s) throw new Error(`有未提交改动(${s.split("\n").length} 个文件)——先提交再打 tag`)
}) && ok

// V5 本地 tag(不推送)
if (ok) {
  const tag = `v${version}`
  ok = step(`V5 git tag ${tag}(仅本地)`, () => {
    execSync(`git tag -f ${tag} -m "Release ${version}"`, { stdio: "pipe" })
  }) && ok
}

if (!ok) { console.log("发布准备失败——修复后再试;未创建/未推送任何远程内容"); process.exit(1) }
console.log(`\n完成。本地已就绪,后续手动执行(本脚本不做任何上传):\n  git push origin v${version}\n  npm publish`)
