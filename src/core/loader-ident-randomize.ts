// Loader DEX 固定标识符随机化(构建期)。
//
// 背景:容器 magic("DROIDSEALBIN")、容器 asset 名("droidseal.bin")、
// meta-data 键("droidseal.original_app"/"droidseal.shell_so")是跨构建不变的
// 明文字符串——自动化脱壳工具搜这些签名即可定位壳资产。本模块在构建期对
// loader DEX 做等长字节替换,每次构建生成新值,流水线同步使用:
//   - 容器以随机 magic 写入,asset 条目用随机名
//   - manifest meta-data 用随机键名
// 静态签名(字符串搜索)全部失效。
//
// 等长替换不移动任何偏移,替换后重算 DEX signature/checksum。
// 与 loader-class-rename 同模式:任一未命中返回 changed=false 并如实标注。
import { randomBytes } from "node:crypto"
import { recomputeDexChecksums } from "./dex-model.ts"
import { findStringNeighbors, genNamesInSlots, cmpDexString, SLOT_ALPHABET_DEFAULT } from "./dex-codec.ts"

const LOWER = "abcdefghijklmnopqrstuvwxyz"

interface FixedIdent {
  from: string
  gen: (len: number) => string
}

/** 生成等长随机小写串(允许数字,首字符限字母,保证合法 asset/字符串形态)。 */
function randomToken(len: number): string {
  let head = LOWER[randomBytes(1)[0]! % 26]
  const rest = Array.from(randomBytes(len - 1), (b) => {
    const alphabet = b % 3 === 0 ? "0123456789" : LOWER
    return alphabet[b % alphabet.length]!
  }).join("")
  return head + rest
}

const FIXED_IDENTS: FixedIdent[] = [
  // 容器 magic(12B):Java 端字符串常量 "DROIDSEALBIN"
  { from: "DROIDSEALBIN", gen: () => randomToken(6).toUpperCase() + randomToken(6).toUpperCase() },
  // 容器 asset 名(13B):AssetManager.open("droidseal.bin")
  { from: "droidseal.bin", gen: (len) => randomToken(len) },
  // meta-data 键(22B / 18B)
  { from: "droidseal.original_app", gen: (len) => randomToken(len) },
  { from: "droidseal.shell_so", gen: (len) => randomToken(len) },
]

export interface IdentRandomizeResult {
  dex: Uint8Array
  /** 随机化后的实际值(流水线同步使用) */
  magic: string // 12B 容器 magic
  assetName: string // AssetManager 相对名(原 droidseal.bin)
  metaOriginalApp: string // manifest meta 键:原始 Application 类名
  metaShellSo: string // manifest meta 键:壳 SO 名
  changed: Array<{ from: string; to: string }>
  missed: string[]
}

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

/**
 * 对 loader DEX 做固定标识符等长随机化。在类名随机化之后调用(共用 checksum 重算)。
 * changed 记录命中项;missed 记录未命中项(调用方如实输出 finding——未命中的
 * 标识符保持原值,静态签名仍在,但功能不受影响)。
 */
export function randomizeLoaderIdentifiers(loaderDex: Uint8Array, enable: boolean): IdentRandomizeResult {
  const metaOriginalApp = FIXED_IDENTS[2]!.from
  const metaShellSo = FIXED_IDENTS[3]!.from
  if (!enable) {
    return {
      dex: loaderDex,
      magic: "DROIDSEALBIN",
      assetName: "droidseal.bin",
      metaOriginalApp,
      metaShellSo,
      changed: [],
      missed: [],
    }
  }
  const out = loaderDex.slice()
  const changed: IdentRandomizeResult["changed"] = []
  const missed: string[] = []
  let magic = "DROIDSEALBIN"
  let assetName = "droidseal.bin"

  // SEC-012 级联批量:四个标识符按**原 string_ids 表序**排列(genNamesInSlots 用
  // 批内相对序校验,顺序错会全败)后整批生成。表序: DROIDSEALBIN(25) <
  // droidseal.bin(214) < droidseal.original_app(215) < droidseal.shell_so(217)。
  const items: import("./dex-codec.ts").CascadeSlot[] = FIXED_IDENTS
    .map((ident) => ({
      original: ident.from,
      alphabet: `${SLOT_ALPHABET_DEFAULT}${[...new Set(ident.from)].join("")}`,
    }))
    .sort((a, b) => cmpDexString(a.original, b.original))
  const slots = items.map((it) => findStringNeighbors(loaderDex, it.original))
  const batch = genNamesInSlots(items, slots)
  if (batch === undefined) {
    // 槽空间不足或批内无法收敛 → 全部保留原值(功能无损,missed 如实标注)
    return {
      dex: recomputeDexChecksums(out),
      magic,
      assetName,
      metaOriginalApp,
      metaShellSo,
      changed: [],
      missed: FIXED_IDENTS.map((i) => i.from),
    }
  }
  const byName = new Map(items.map((it, i) => [it.original, batch[i]!]))
  for (const ident of FIXED_IDENTS) {
    const to = byName.get(ident.from)!
    if (replaceAllEqual(out, ident.from, to)) {
      changed.push({ from: ident.from, to })
      if (ident.from === "DROIDSEALBIN") magic = to
      else if (ident.from === "droidseal.bin") assetName = to
    } else {
      missed.push(ident.from)
    }
  }

  // 从 changed 里取回 meta 键随机值(未命中则保持原值)
  const metaOriginal = changed.find((c) => c.from === "droidseal.original_app")?.to ?? metaOriginalApp
  const metaShell = changed.find((c) => c.from === "droidseal.shell_so")?.to ?? metaShellSo

  return {
    dex: recomputeDexChecksums(out),
    magic,
    assetName,
    metaOriginalApp: metaOriginal,
    metaShellSo: metaShell,
    changed,
    missed,
  }
}
