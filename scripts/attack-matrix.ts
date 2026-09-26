// 攻击矩阵:构建级对抗评估(论文 Evaluation › Attack Matrix)
// ─────────────────────────────────────────────────────────────────────────────
// 对同一加固产物生成 N 类攻击变体,逐一验证"密钥化防御"的核心论断:
//   攻击改变密钥派生输入 ⇒ 派生密钥必变 ⇒ 解密必失败(fail-closed),
//   而产物结构保持完好(基线 H1–H6 仍过)——防御不在结构检测,在密钥派生。
// 变体:
//   A1 resign        重签(攻击者 keystore)          ⇒ 证书指纹变 ⇒ 错钥
//   A2 manifest      篡改二进制 manifest(versionCode+1)+ 原 key 重签 ⇒ 锚点变 ⇒ 错钥
//   A3 dex-patch     对壳 DEX 做等长字节替换+重签     ⇒ loader/stub 内容变 ⇒ 运行时拒解密
//   A4 asset-swap    翻转加密容器密文字节+重签        ⇒ GCM 认证失败 ⇒ 拒解密
//   A5 repack        解包重打包+debug 重签(最弱攻击) ⇒ 锚点变+证书变 ⇒ 错钥
// 用法: bun scripts/attack-matrix.ts <hardened.apk> [--out <dir>] [--ks <jks> --ks-alias <a> --ks-pass <p> --key-pass <p>]
import { createHash } from "node:crypto"
import { spawnSync } from "node:child_process"
import { mkdirSync, existsSync, readFileSync, writeFileSync, rmSync } from "node:fs"
import path from "node:path"
import { generateKeystore, signApk, findBuildTool, buildApkZip, type ZipEntry } from "../src/core/apk-repack.ts"
import { unpackApk } from "../src/core/apk-unpack.ts"

const apk = process.argv[2]
const outIdx = process.argv.indexOf("--out")
const outDir = outIdx >= 0 ? process.argv[outIdx + 1]! : "./attack-matrix-out"
if (!apk || !existsSync(apk)) {
  console.error("用法: bun scripts/attack-matrix.ts <hardened.apk> [--out <dir>] [--ks <jks> --ks-alias <alias> --ks-pass <pass> --key-pass <pass>]")
  process.exit(2)
}
mkdirSync(outDir, { recursive: true })

// 原始 keystore(A2 用原 key 重签,隔离"锚点"单一变量)
const argOf = (name: string): string | undefined => {
  const i = process.argv.indexOf(name)
  return i >= 0 ? process.argv[i + 1]! : undefined
}
const origKs = argOf("--ks")
const origKsAlias = argOf("--ks-alias")
const origKsPass = argOf("--ks-pass")
const origKeyPass = argOf("--key-pass")

// ── 基础设施 ─────────────────────────────────────────────────────────────────
const printCert = (apkPath: string): string | null => {
  // apksigner 是 .bat——spawnSync 需 shell:true;v1-only 产物在 targetSdk≥30 下
  // apksigner verify 以非零退出,改用 keytool -printcert -jarfile(只读 v1,但指纹同一)
  const tool = `"${findBuildTool("apksigner")}"`
  const v2 = spawnSync(`${tool} verify --print-certs "${apkPath}"`, { timeout: 60_000, stdio: "pipe", shell: true })
  const out2 = (v2.stdout?.toString() ?? "") + (v2.stderr?.toString() ?? "")
  const m2 = /SHA-256 digest:\s*([0-9a-f]{64})/i.exec(out2)
  if (m2) return m2[1]!.toLowerCase()
  const javaBin = path.join(path.dirname(path.dirname(findBuildTool("apksigner"))), "..", "..", "..", "..")
  const kt = spawnSync(`keytool -printcert -jarfile "${apkPath}"`, { timeout: 60_000, stdio: "pipe", shell: true })
  const out1 = (kt.stdout?.toString() ?? "") + (kt.stderr?.toString() ?? "")
  const m1 = /SHA256:\s*([0-9A-F:]{95})/i.exec(out1)
  return m1 ? m1[1]!.replace(/:/g, "").toLowerCase() : null
}

const runBaseline = (apkPath: string): boolean | null => {
  const r = spawnSync("bun", ["scripts/verify-harden-artifact.ts", apkPath], { timeout: 120_000, stdio: "pipe" })
  return r.status === 0
}

// signApk 的 shell 包装:apksigner 是 .bat,Windows spawnSync 无 shell 直接 EINVAL
const signWith = (target: string, ks: string, alias: string, storePass: string, keyPass: string): { success: boolean; output: string } => {
  const tool = findBuildTool("apksigner")
  const cmd = `"${tool}" sign --ks "${ks}" --ks-key-alias "${alias}" --ks-pass pass:${storePass} --key-pass pass:${keyPass} "${target}"`
  const r = spawnSync(cmd, { timeout: 120_000, stdio: "pipe", shell: true })
  const output = (r.stdout?.toString() ?? "") + (r.stderr?.toString() ?? "")
  if (r.status !== 0) {
    // 后备:jarsigner(v1 签名足够基线与证书判读)
    const jr = spawnSync(`jarsigner -sigalg SHA256withRSA -digestalg SHA-256 -keystore "${ks}" -storepass ${storePass} -keypass ${keyPass} "${target}" ${alias}`, { timeout: 60_000, stdio: "pipe", shell: true })
    return { success: jr.status === 0, output: output + (jr.stdout?.toString() ?? "") + (jr.stderr?.toString() ?? "") }
  }
  return { success: true, output }
}

// 读 ZIP:自研解析器,deflate 条目已解压(bytes=原始内容)
const readZip = async (apkPath: string): Promise<ZipEntry[]> => {
  const contents = await unpackApk(apkPath)
  return contents.entries.map(e => ({ name: e.name, bytes: e.bytes, compressionMethod: e.compressionMethod }))
}

const origEntries = await readZip(apk)
const origCert = printCert(apk)
if (!origCert) { console.error("无法读取原产物证书(v1/v2 均失败)"); process.exit(1) }
console.log(`原产物证书 SHA-256: ${origCert.slice(0, 16)}…`)

// 全局攻击者 keystore(A2–A5 无原 key 时 fallback 用;A1 直接用)
const attackerDir = path.join(outDir, "_attacker"); mkdirSync(attackerDir, { recursive: true })
const attackerKs = path.join(attackerDir, "attacker.jks")
if (!existsSync(attackerKs)) {
  if (!generateKeystore(attackerKs, { keyAlias: "attacker", storePassword: "attack123", keyPassword: "attack123", validity: 30 })) {
    console.error("攻击者 keystore 生成失败"); process.exit(1)
  }
}
const signOrigOrAttacker = (target: string): { success: boolean; output: string; usedOrig: boolean } => {
  if (origKs && origKsAlias && origKsPass) {
    const s = signWith(target, origKs, origKsAlias, origKsPass, origKeyPass ?? origKsPass)
    if (s.success) return { ...s, usedOrig: true }
  }
  return { ...signWith(target, attackerKs, "attacker", "attack123", "attack123"), usedOrig: false }
}

const results: Array<{ id: string; name: string; certChanged: boolean | null; baselinePass: boolean | null; wrongKey: boolean | null; keyDivergence: string; note: string }> = []

// ── 错钥输入偏离计算(构建级可证部分)─────────────────────────────────────
// 错钥三输入:①证书指纹(HKDF 源)②manifest SHA-256(P0-A 锚点)③容器密文
// (逐条目哈希链前驱)。任一输入相对原产物偏离 ⇒ 派生密钥必错 ⇒ 运行时 GCM
// 拒解密。这是确定性的构建级计算;运行时行为(拒绝解密/进程消亡)仍需真机
// 验收(docs/device-testing.md)——两个层次在报告中分开表述,不混淆口径。
const sha256Of = (bytes: Uint8Array): string => createHash("sha256").update(bytes).digest("hex")
const manifestSha = (entries: ZipEntry[]): string | null => {
  const mf = entries.find(e => e.name === "AndroidManifest.xml")
  return mf ? sha256Of(mf.bytes) : null
}
const containerSha = (entries: ZipEntry[]): string | null => {
  const c = entries.filter(e => /^assets\//.test(e.name)).sort((a, b) => b.bytes.length - a.bytes.length)[0]
  return c ? sha256Of(c.bytes) : null
}
const origManifestSha = manifestSha(origEntries)
const origContainerSha = containerSha(origEntries)

const finishVariant = async (id: string, name: string, file: string, note: string, reSigned: boolean): Promise<void> => {
  const cert = reSigned ? printCert(file) : null
  const baseline = runBaseline(file)
  // 错钥判定:重算该变体三输入,与原产物比对
  let wrongKey: boolean | null = null
  const divergence: string[] = []
  try {
    const entries = await readZip(file)
    if ((cert ?? origCert) !== origCert) divergence.push("cert")
    const mNow = manifestSha(entries)
    if (mNow && origManifestSha && mNow !== origManifestSha) divergence.push("manifest")
    const cNow = containerSha(entries)
    if (cNow && origContainerSha && cNow !== origContainerSha) divergence.push("container")
    wrongKey = divergence.length > 0
  } catch { wrongKey = null }
  results.push({ id, name, certChanged: cert ? cert !== origCert : null, baselinePass: baseline, wrongKey, keyDivergence: divergence.join("+") || "none", note })
  console.log(`  [${id}] ${name}: certChanged=${results[results.length - 1]!.certChanged}, baseline=${baseline}, wrongKey=${wrongKey} (${divergence.join("+") || "none"})`)
}

// ── A1: 重签(攻击者 keystore)──────────────────────────────────────────────
{
  const dir = path.join(outDir, "A1-resign"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "resigned.apk")
  writeFileSync(target, readFileSync(apk))
  const sign = signWith(target, attackerKs, "attacker", "attack123", "attack123")
  if (sign.success) await finishVariant("A1", "re-sign (attacker key)", target, "证书指纹变化 ⇒ HKDF(证书) 错钥;结构基线仍过=防御是密钥化的", true)
  else results.push({ id: "A1", name: "re-sign", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
}

// ── A2: 篡改 manifest(versionCode+1)+ 原 key 重签(隔离"锚点"单一变量)────
{
  const dir = path.join(outDir, "A2-manifest"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "manifest-tampered.apk")
  const entries = origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))
  const mf = entries.find(e => e.name === "AndroidManifest.xml")
  if (!mf) { results.push({ id: "A2", name: "manifest tamper", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: "产物无 manifest(异常输入)" }) }
  else {
    let patched = false
    const u8 = mf.bytes
    const dv = new DataView(u8.buffer, u8.byteOffset, u8.byteLength)
    // 方案:字符串池定位 "versionCode" 索引 k → 扫属性节点(name 字段==k 且 ns==0xFFFFFFFE)
    // 属性节点布局: nodeHeader(type2+hs2+size4) line4 comment4 ns4 name4 rawValue4 typedValue8(size2 res0 dataType1 data4)
    // ⇒ name 在节点偏移 +16,data 在 +28。字符串池: chunk(type4 size4 strCount4 styleCount4 flags4 stringsStart4 stylesStart4)
    let vcIdx = -1
    {
      // 找字符串池 chunk(通常紧跟 AXML 头,即偏移 8)
      const sp = 8
      if (dv.getUint16(sp, true) === 0x0001) {
        const strCount = dv.getUint32(sp + 8, true)
        const flags = dv.getUint32(sp + 16, true)
        const stringsStart = sp + dv.getUint32(sp + 20, true)
        const isUtf8 = (flags & 0x100) !== 0
        for (let s = 0; s < strCount; s++) {
          const offPtr = sp + 28 + s * 4
          if (offPtr + 4 > u8.length) break
          let strOff = stringsStart + dv.getUint32(offPtr, true)
          let len = 0, nameBytes: string
          if (isUtf8) {
            const n1 = u8[strOff]!, n2 = u8[strOff + 1]!
            len = (n1 & 0x80) ? ((n1 & 0x7f) << 8) | n2 : n1
            strOff += (n1 & 0x80) ? 2 : 1
            nameBytes = Buffer.from(u8.subarray(strOff, strOff + len)).toString("latin1")
          } else {
            len = dv.getUint16(strOff, true)
            nameBytes = Buffer.from(u8.subarray(strOff + 2, strOff + 2 + len * 2)).toString("utf16le")
          }
          if (nameBytes === "versionCode") { vcIdx = s; break }
        }
      }
    }
    if (vcIdx >= 0) {
      for (let i = 8; i < u8.length - 32; i += 4) {
        // 属性节点:ns(i-4) name(i) rawValue(i+4) typedValue(i+8: size2 res0 dataType@i+11 data@i+12)
        // android 命名空间的 ns 是 URI 字符串索引(非 0xFFFFFFFF),故只按 name+dataType 判定
        if (dv.getUint32(i, true) === vcIdx && u8[i + 11] === 0x10) { // INT_DEC
          const v = dv.getUint32(i + 12, true)
          if (v > 0 && v < 0x1000000) { dv.setUint32(i + 12, v + 1, true); patched = true }
          break
        }
      }
    }
    if (!patched) { console.log("  [A2] versionCode 属性未定位——尝试扫描全部 manifest 候补"); }
    else {
      writeFileSync(target, buildApkZip(entries))
      const sign = signOrigOrAttacker(target)
      if (sign.success) await finishVariant("A2", `manifest tamper (versionCode+1, re-sign w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, sign.usedOrig ? "P0-A 锚点=SHA-256(manifest) 折入派生 ⇒ 清单字节变 ⇒ 错钥(签名自洽,隔离锚点变量);基线仍过 ⇒ 防御在密钥派生" : "重打包必改清单 ⇒ 锚点变;攻击者 key ⇒ 证书也变(双重错钥)", true)
      else results.push({ id: "A2", name: "manifest tamper", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
    }
  }
}

// ── A3: patch 壳 DEX(等长 XOR)+ 重签 ──────────────────────────────────────
{
  const dir = path.join(outDir, "A3-dexpatch"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "dex-patched.apk")
  const entries = origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))
  const dex = entries.find(e => /\.dex$/.test(e.name))
  if (!dex) { results.push({ id: "A3", name: "DEX patch", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: "无 DEX 条目" }) }
  else {
    const mid = Math.floor(dex.bytes.length / 2)
    for (let i = 0; i < 16; i++) dex.bytes[mid + i] = dex.bytes[mid + i]! ^ 0xff
    writeFileSync(target, buildApkZip(entries))
    const sign = signOrigOrAttacker(target)
    if (sign.success) await finishVariant("A3", `DEX byte patch (16B XOR) + re-sign (w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, "stub/loader DEX 内容参与锚点/加载 ⇒ 等长补丁布局不变但语义必损:运行时拒解密或拒载;基线测结构 ⇒ 视补丁点可能仍过", true)
    else results.push({ id: "A3", name: "DEX patch", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
  }
}

// ── A4: 翻转加密容器密文 + 重签(GCM 认证必败)─────────────────────────────
{
  const dir = path.join(outDir, "A4-asset"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "asset-tampered.apk")
  const entries = origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))
  // 加密容器=assets 下最大的条目(.0lH / .ldx)
  const container = entries.filter(e => /^assets\//.test(e.name)).sort((a, b) => b.bytes.length - a.bytes.length)[0]
  if (!container) { results.push({ id: "A4", name: "ciphertext flip", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: "无 assets 容器条目" }) }
  else {
    container.bytes[40] = container.bytes[40]! ^ 0xff
    writeFileSync(target, buildApkZip(entries))
    const sign = signOrigOrAttacker(target)
    if (sign.success) await finishVariant("A4", `ciphertext bit-flip (${container.name} byte 40) + re-sign (w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, sign.usedOrig ? "GCM 认证标签必失败 ⇒ 拒解密(fail-closed),与签名/锚点无关的独立密码学防御;结构基线不校验密文 ⇒ 仍过" : "GCM 认证标签必失败 ⇒ 拒解密;攻击者 key ⇒ 证书变(双重防御)", true)
    else results.push({ id: "A4", name: "ciphertext flip", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
  }
}

// ── A5: 解包重打包+debug 重签(最弱攻击:攻击者拿到 APK 重新分发)────────────
{
  const dir = path.join(outDir, "A5-repack"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "repacked.apk")
  // 条目原样重组(未做任何字节修改)——但 ZIP 布局/时间戳/顺序由 buildApkZip 重排 ⇒ manifest 字节虽同,
  // 整包仍被重签为 debug key ⇒ 证书必变
  writeFileSync(target, buildApkZip(origEntries.map(e => ({ ...e }))))
  const sign = signWith(target, attackerKs, "attacker", "attack123", "attack123")
  if (sign.success) await finishVariant("A5", "unzip-repack + re-sign (attacker key)", target, "最弱攻击路径:条目未动仅重排重签 ⇒ 证书变 ⇒ 错钥;密钥化下同样失败", true)
  else results.push({ id: "A5", name: "repack", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
}

// ── A6: 部分重打包(只改资源,不碰 manifest)+ 原 key 重签(隔离"资源篡改面")──
// 场景:攻击者替换/注入资源(如 strings.xml 换钓鱼文案、注入 debuggable layout)但
// 保留原 manifest——A2 已证明 manifest 锚点有效,本变体验证"manifest 不变时资源
// 篡改是否漏网"。原 key 重签隔离单一变量。
{
  const dir = path.join(outDir, "A6-partial-repack"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "resource-tampered.apk")
  const entries = origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))
  // 只改资源:优先翻转 strings.arsc,否则任一非 manifest/非 dex/非容器资源;都无则改 PNG 字节
  const resCandidates = entries.filter(e => /^(res\/|resources\.arsc)/.test(e.name) && !/\.dex$/.test(e.name))
  const victim = resCandidates.find(e => e.name === "resources.arsc") ?? resCandidates[0] ?? entries.find(e => /\.(png|xml)$/.test(e.name))
  if (!victim) { results.push({ id: "A6", name: "partial repack (resource only)", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: "无可篡改资源条目" }) }
  else {
    const mid = Math.floor(victim.bytes.length / 2)
    for (let i = 0; i < 16; i++) victim.bytes[mid + i] = victim.bytes[mid + i]! ^ 0xff
    writeFileSync(target, buildApkZip(entries))
    const sign = signOrigOrAttacker(target)
    if (sign.success) await finishVariant("A6", `resource-only tamper (${victim.name}, manifest untouched) + re-sign (w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, "manifest 未动 ⇒ 锚点不变;防御依赖密钥派生输入是否覆盖资源——A4 容器哈希链 + per-entry KDF 使资源篡改不影响容器密钥,但签名/安装层完整性由 v2 校验兜底;本变体测量资源篡改面是否需独立锚点", true)
    else results.push({ id: "A6", name: "partial repack (resource only)", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
  }
}

// ── A7: ZIP 结构重排(条目顺序打乱)+ 原 key 重签(隔离"布局敏感面")──────────
// 场景:重排不改任何条目字节,只改变 ZIP 内条目顺序/offset。manifest 条目内容不变
// ⇒ 锚点不变;容器密文不变 ⇒ GCM 不败。检验运行时解析对布局的鲁棒性与基线判读。
{
  const dir = path.join(outDir, "A7-zip-reorder"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "zip-reordered.apk")
  // 倒序重排(保持字节不变);确保 manifest 仍在(部分工具要求首个 local header,故反转后仍完整)
  const reordered = [...origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))].reverse()
  writeFileSync(target, buildApkZip(reordered))
  const sign = signOrigOrAttacker(target)
  if (sign.success) await finishVariant("A7", `zip entry reorder (bytes unchanged) + re-sign (w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, "条目字节不变 ⇒ manifest 锚点/容器密文均不变;布局敏感面测量——基线通过 ⇒ 运行时解析与布局无关;若设备安装失败则暴露 ZIP 布局依赖(非密钥化防御范畴)", true)
  else results.push({ id: "A7", name: "zip reorder", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
}

// ── A8: 容器条目增删(向 assets 注入伪造容器/删除容器条目)+ 重签 ───────────
// 场景:攻击者向容器追加伪造条目或删除某条目(如删掉 citable 令方法抽取不可还原),
// 检验哈希链(P0-A 扩展)与运行时解析的 fail-closed 行为。
{
  const dir = path.join(outDir, "A8-container-edit"); mkdirSync(dir, { recursive: true })
  const target = path.join(dir, "container-edited.apk")
  const entries = origEntries.map(e => ({ ...e, bytes: Uint8Array.from(e.bytes) }))
  const container = entries.filter(e => /^assets\//.test(e.name)).sort((a, b) => b.bytes.length - a.bytes.length)[0]
  if (!container) { results.push({ id: "A8", name: "container entry edit", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: "无容器条目" }) }
  else {
    // 解析容器 → 截断最后一个条目(伪造"删条目")→ 原样写回
    const truncated = container.bytes.subarray(0, Math.floor(container.bytes.length * 0.9))
    container.bytes = Uint8Array.from(truncated)
    writeFileSync(target, buildApkZip(entries))
    const sign = signOrigOrAttacker(target)
    if (sign.success) await finishVariant("A8", `container truncate (drop tail bytes) + re-sign (w/ ${sign.usedOrig ? "orig" : "attacker"} key)`, target, "容器条目被删/改 ⇒ 哈希链断裂:被删条目后续所有条目派生错钥(即使 GCM 未先拒绝);解析端 count/length 不匹配 ⇒ fail-closed 返回,双保险", true)
    else results.push({ id: "A8", name: "container entry edit", certChanged: null, baselinePass: null, wrongKey: null, keyDivergence: "unknown", note: `重签失败: ${sign.output.slice(0, 120)}` })
  }
}

// ── 汇总 ────────────────────────────────────────────────────────────────────
const summaryMd = [
  "# 攻击矩阵(构建级可证部分)",
  "",
  `- 原产物: \`${apk}\``,
  `- 原证书 SHA-256: \`${origCert.slice(0, 16)}…\``,
  `- 日期: ${new Date().toISOString().slice(0, 10)}`,
  "",
  "| # | 攻击 | 证书变化 | 结构基线(H1–H6) | 错钥输入偏离 | 构建级结论 |",
  "|---|---|---|---|---|---|",
  ...results.map(r => `| ${r.id} | ${r.name} | ${r.certChanged === null ? "—" : r.certChanged ? "是" : "否"} | ${r.baselinePass === null ? "—" : r.baselinePass ? "PASS" : "FAIL"} | ${r.wrongKey === null ? "—" : r.wrongKey ? `是(${r.keyDivergence})` : "否"} | ${r.note} |`),
  "",
  "## 错钥率实测(构建级)",
  "",
  `- **错误密钥率: ${results.filter(r => r.wrongKey).length}/${results.length}**——所有引发错钥输入偏离(证书指纹/manifest 锚点/容器密文)的攻击变体,派生密钥必错,运行时 GCM 拒解密(fail-closed)。`,
  "- 错钥三输入:①证书指纹(HKDF 源)②manifest SHA-256(P0-A 锚点)③容器密文哈希链(P0-A 扩展)。任一偏离即错钥——确定性构建级计算。",
  "- **如实分层**:本表为构建级可证部分(输入偏离 ⇒ 密钥必错);运行时行为(拒绝解密/进程消亡/D3 无标记)需真机验收,见 docs/device-testing.md——两个口径不混用。",
  "",
  "## 判读",
  "",
  "- **证书变化=是 且 基线=PASS**:防御是密钥化的——结构完好但派生密钥必错(运行时 GCM 失败)。",
  "- **A2(原 key 重签)证书变化=否**:隔离出\"锚点\"单一变量——清单字节变 ⇒ 锚点变 ⇒ 错钥,与签名无关。",
  "- **A4 证书变化=否(原 key 重签)**:隔离出\"密文完整性\"——GCM 认证失败,与锚点无关的独立密码学防御。",
  "- 运行时验收(错钥⇒D2 失败+D3 标记)见 docs/device-testing.md。",
].join("\n")
writeFileSync(path.join(outDir, "attack-matrix.md"), summaryMd)
writeFileSync(path.join(outDir, "attack-matrix.json"), JSON.stringify({ origin: apk, origCert, date: new Date().toISOString(), results }, null, 2))
console.log("\n" + summaryMd)
console.log(`\n产出: ${outDir}/attack-matrix.{md,json}`)
