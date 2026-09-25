// Bootstrap stub 随机化 + loader DEX 自加密(构建期,双 DEX 方案 TS 侧)。
//
// stub DEX(明文 classesN.dex)内含三个构建期标记,等长替换:
//   - "droidseal/runtime/BootstrapStub"(31B)→ 随机包/类路径(manifest android:name 同步)
//   - "droidseal/runtime/ShellApplication"(34B)→ 随机化后的壳类路径(Step 2.5 结果)
//   - "ds_loader_asset_mk1"(19B)→ 随机 meta 键名(流水线写入 manifest 同名键)
// loader DEX(含密钥与解密逻辑)用 HKDF(签名证书摘要) 派生密钥 AES-256-GCM 加密,
// 存为独立 asset——jadx 打开加固 APK 只能看到 stub 的通用引导代码。
// Java 端 BootstrapStub.hkdf/decryptGcm 与本模块严格一致。
import { createHmac, createCipheriv, randomBytes } from "node:crypto"
import { recomputeDexChecksums } from "./dex-model.ts"
import { findStringNeighbors, genNameInSlot, genNamesInSlots, SLOT_ALPHABET_DEFAULT } from "./dex-codec.ts"

const STUB_CLASS = "droidseal/runtime/BootstrapStub" // 31(DEX 类型描述符内的斜杠形式)
const STUB_SOURCE_FILE = "BootstrapStub.java" // 18(SourceFile 调试属性,泄露类名)
const SHELL_CLASS_MARKER = "droidseal.runtime.ShellApplication" // 34(点分,loadClass 字符串常量)
const META_KEY_MARKER = "ds_loader_asset_mk1" // 19

const LOWER = "abcdefghijklmnopqrstuvwxyz"

function replaceAllEqual(dex: Uint8Array, from: string, to: string): boolean {
  if (from.length !== to.length) throw new Error(`等长替换长度不一致:${from.length} != ${to.length}`)
  const enc = new TextEncoder()
  const fb = enc.encode(from)
  const tb = enc.encode(to)
  let hit = false
  for (let i = 0; i + fb.length <= dex.length;) {
    let j = 0
    while (j < fb.length && dex[i + j] === fb[j]) j += 1
    if (j === fb.length) {
      dex.set(tb, i)
      hit = true
      i += fb.length
    } else {
      i += 1
    }
  }
  return hit
}

export interface StubRandomizeOptions {
  enable: boolean
  /** 随机化后的壳 Application 类路径(斜杠形式,如 "abcdefgh/ijklmnop/Xbcd" —— Step 2.5 rename 结果) */
  shellClassPath: string
  /** loader DEX asset 的 meta 键名(19 字符) */
  metaKey: string
}

export interface StubRandomizeResult {
  dex: Uint8Array
  /** stub 类路径(dots 形式,manifest android:name 用) */
  stubClassPath: string
  changed: string[]
  missed: string[]
}

export function randomizeStubIdentifiers(stubDex: Uint8Array, opts: StubRandomizeOptions): StubRandomizeResult {
  if (!opts.enable) {
    return { dex: stubDex, stubClassPath: STUB_CLASS.replace(/\//g, "."), changed: [], missed: [] }
  }
  const out = stubDex.slice()
  const changed: string[] = []
  const missed: string[] = []

  // stub 类路径随机化:18B 包路径 + 13B 类名(与 STUB_CLASS 等长 31)
  const pick = (n: number) => Array.from(randomBytes(n), (b) => LOWER[b % 26]).join("")
  // SEC-012 级联批量:四个改名项按表序批量生成 + 批内相对序校验(槽区间可能重叠,
  // 单项各自合法但互相交错 → 必须整批约束)。
  // 注意:类型描述符在 string 表中存 'L...;' 形式,槽查询与替换分别用对应形式。
  // items 必须按原 string_ids 表序排列(genNamesInSlots 用批内相对序校验,
  // 顺序错了校验本身就会全败)。
  const items: import("./dex-codec.ts").CascadeSlot[] = [
    { original: STUB_SOURCE_FILE },
    { original: `L${STUB_CLASS};`, alphabet: SLOT_ALPHABET_DEFAULT },
    { original: SHELL_CLASS_MARKER, alphabet: `${SLOT_ALPHABET_DEFAULT}.` },
    { original: META_KEY_MARKER, alphabet: `${SLOT_ALPHABET_DEFAULT}-_` },
  ]
  const slots = items.map((it) => findStringNeighbors(stubDex, it.original))
  const batch = genNamesInSlots(items, slots)
  if (batch === undefined) {
    // 槽空间不足或批内无法收敛 → 全部保留原名(功能无损,如实标注)
    return {
      dex: recomputeDexChecksums(out),
      stubClassPath: STUB_CLASS.replace(/\//g, "."),
      changed: [],
      missed: [STUB_CLASS, STUB_SOURCE_FILE, SHELL_CLASS_MARKER, META_KEY_MARKER],
    }
  }
  const newStubPath = batch[1]!.slice(1, -1) // 去 L;(items[1] = L 形式类路径)
  const newSourceFile = batch[0]!
  const newShellDots = batch[2]!
  const newMetaKey = batch[3]!
  // 壳类路径:入参为斜杠形式(Step 2.5 rename 结果),DEX 字符串常量是点分形式(等长 34)
  const shellDots = opts.shellClassPath.replace(/\//g, ".")
  if (shellDots.length !== SHELL_CLASS_MARKER.length) {
    missed.push(SHELL_CLASS_MARKER)
  }
  if (replaceAllEqual(out, STUB_CLASS, newStubPath)) changed.push(STUB_CLASS)
  else missed.push(STUB_CLASS)
  if (replaceAllEqual(out, STUB_SOURCE_FILE, newSourceFile)) changed.push(STUB_SOURCE_FILE)
  else missed.push(STUB_SOURCE_FILE)
  if (replaceAllEqual(out, SHELL_CLASS_MARKER, newShellDots)) {
    changed.push(SHELL_CLASS_MARKER)
  } else if (shellDots.length === SHELL_CLASS_MARKER.length) {
    missed.push(SHELL_CLASS_MARKER)
  }
  if (replaceAllEqual(out, META_KEY_MARKER, newMetaKey)) changed.push(META_KEY_MARKER)
  else missed.push(META_KEY_MARKER)

  return {
    dex: recomputeDexChecksums(out),
    stubClassPath: (newStubPath ?? STUB_CLASS).replace(/\//g, "."),
    changed,
    missed,
  }
}

/** loader DEX 解密密钥:HKDF-SHA256(ikm=证书摘要原始 32B, salt=0^32, info="droidseal-loader-v1") */
export function deriveLoaderKey(certSha256Hex: string): Uint8Array {
  const ikm = Buffer.from(certSha256Hex, "hex")
  const prk = createHmac("sha256", new Uint8Array(32)).update(ikm).digest()
  return new Uint8Array(createHmac("sha256", prk).update("droidseal-loader-v1").update(Buffer.from([1])).digest())
}

/** loader DEX 加密:nonce(12)+tag(16)+ct,Java BootstrapStub.decryptGcm 对应格式 */
export function encryptLoaderDex(dex: Uint8Array, certSha256Hex: string): Uint8Array {
  const nonce = randomBytes(12)
  const enc = createCipheriv("aes-256-gcm", deriveLoaderKey(certSha256Hex), nonce)
  const ct = Buffer.concat([enc.update(dex), enc.final()])
  const tag = enc.getAuthTag()
  const out = new Uint8Array(28 + ct.length)
  out.set(nonce, 0)
  out.set(tag, 12)
  out.set(new Uint8Array(ct), 28)
  return out
}
