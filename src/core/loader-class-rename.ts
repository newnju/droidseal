// 壳入口类名随机化(构建期)。
//
// loader DEX 中 "droidseal/runtime/ShellApplication" 与 "droidseal/runtime/DroidSealLoader"
// 以 Ldroidseal/runtime/Xxx; 形式出现在 DEX 字符串表中。本模块在注入前做等长字节替换:
//   - "droidseal/runtime/" 前缀(19B) → 等长随机包路径(如 "p7xk2mqz/runtimexx/")
//   - "ShellApplication" / "DroidSealLoader" 类名 → 等长随机大写开头标识符
// 等长替换不移动任何偏移,只需重算 DEX signature/checksum。
// manifest 的 android:name 与 key_part2.c 的 JNI 导出名由流水线同步使用相同随机名。
import { recomputeDexChecksums } from "./dex-model.ts"
import { randomBytes } from "node:crypto"
import { findStringNeighbors, nameFitsSlot, genNameInSlot, type OrderedNameSlot } from "./dex-codec.ts"

const PKG_PREFIX = "droidseal/runtime/" // 18 字节
const CLASS_SHELL = "ShellApplication" // 17 字节
const CLASS_LOADER = "DroidSealLoader" // 14 字节

const LOWER = "abcdefghijklmnopqrstuvwxyz"
const UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

/** 等长随机包路径:两段小写,以 "/" 分隔,总长恒等于 18。 */
function randomPackagePath(): string {
  // 18B = seg1 + "/" + seg2 + "/",两段共 16 个小写字母
  const pick = (n: number) => Array.from(randomBytes(n), (b) => LOWER[b % 26]).join("")
  return `${pick(8)}/${pick(8)}/`
}

/** 等长随机类名:大写字母开头 + 小写,长度与原名一致(DEX 类名规范)。 */
function randomClassName(len: number): string {
  const head = UPPER[randomBytes(1)[0]! % 26]
  return head + Array.from(randomBytes(len - 1), (b) => LOWER[b % 26]).join("")
}

export interface ClassRenameResult {
  dex: Uint8Array
  oldShellPath: string // droidseal/runtime/ShellApplication
  newShellPath: string
  newLoaderPath: string // droidseal/runtime → 新前缀 的 DroidSealLoader 对应路径
  renamed: boolean
}

/** 用大写字母开头的等长随机类名生成新路径 */
function replaceAll(dex: Uint8Array, from: string, to: string): boolean {
  if (from.length !== to.length) throw new Error(`等长替换要求 from/to 等长:${from.length} != ${to.length}`)
  const enc = new TextEncoder()
  const fb = enc.encode(from)
  const tb = enc.encode(to)
  let replaced = false
  for (let i = 0; i + fb.length <= dex.length;) {
    let j = 0
    while (j < fb.length && dex[i + j] === fb[j]) j += 1
    if (j === fb.length) {
      dex.set(tb, i)
      replaced = true
      i += fb.length
    } else {
      i += 1
    }
  }
  return replaced
}

/**
 * 对 loader DEX 做壳类名等长随机化。
 * 任一名字未命中返回 renamed=false(调用方如实输出 finding;loader 保留原名可用)。
 * stubSlot(可选):stub DEX 中壳名点分形式的槽邻居——loader 槽内生成的壳名,
 * 其点分形式还须同时落进 stub 槽(stub 的 loadClass 引用与 manifest 都用点分名;
 * 两表约束独立,只满足单侧会让 stub 侧替换失败 → 壳引用错位 fail-closed)。
 */
export function randomizeLoaderClassNames(loaderDex: Uint8Array, enable: boolean, stubSlot?: OrderedNameSlot): ClassRenameResult {
  const oldShellPath = `L${PKG_PREFIX}${CLASS_SHELL};`
  const oldLoaderPath = `L${PKG_PREFIX}${CLASS_LOADER};`
  if (!enable) {
    return { dex: loaderDex, oldShellPath, newShellPath: oldShellPath, newLoaderPath: oldLoaderPath, renamed: false }
  }
  const out = loaderDex.slice()
  // SEC-012:保序替换——随机名必须落在 string_ids 排序邻居之间(ART 严格校验字典序)。
  // 语义:整条类路径(Lpkg/Class; 全串,等长)做一次槽内构造;包段/类段不再分开拼
  // (分开拼会破坏槽长度语义)。产物形如 Lxy12ab_cd/Wqrs…;,流水线按斜杠拆包/类。
  const slotShell = findStringNeighbors(loaderDex, oldShellPath)
  const slotLoader = findStringNeighbors(loaderDex, oldLoaderPath)
  const fitsBoth = (p: string): boolean => {
    if (!nameFitsSlot(p, slotShell)) return false
    if (stubSlot) {
      const dots = p.slice(1, -1).replace(/\//g, ".")
      if (!nameFitsSlot(dots, stubSlot)) return false
    }
    return true
  }
  // 联合命中是概率性的(loader 槽自由度 × stub 槽窗口),重试后仍不收敛 → 放弃改名
  // 槽内生成是"整串等长随机",L/; 结构字符可能被随机成字母/斜杠 → DEX 真名与
  // 调用方 slice(1,-1) 剥壳后的 manifest 名错一位(CNFE)。生成后强制重塑为
  // L...; 形态(仅首尾替换,长度不变),再验槽;失败重试。
  const reshapeDescriptor = (s: string): string => `L${s.slice(1, -1)};`
  let newShellPath: string | undefined
  if (slotShell.prev !== undefined || slotShell.next !== undefined) {
    for (let i = 0; i < 256 && newShellPath === undefined; i += 1) {
      const c = genNameInSlot(oldShellPath.length, slotShell)
      if (c === undefined || !c.includes("/")) continue
      const r = reshapeDescriptor(c)
      if (fitsBoth(r)) newShellPath = r
    }
  } else {
    const fallback = `L${randomPackagePath()}${randomClassName(CLASS_SHELL.length)};`
    if (fitsBoth(fallback)) newShellPath = fallback
  }
  const newLoaderPath = slotLoader.prev !== undefined || slotLoader.next !== undefined
    ? (() => {
        for (let i = 0; i < 256; i += 1) {
          const c = genNameInSlot(oldLoaderPath.length, slotLoader)
          if (c === undefined) return undefined
          const r = reshapeDescriptor(c)
          if (nameFitsSlot(r, slotLoader)) return r
        }
        return undefined
      })()
    : `L${randomPackagePath()}${randomClassName(CLASS_LOADER.length)};`
  if (newShellPath === undefined || newLoaderPath === undefined) {
    // 槽内空间不足(邻居过近)→ 放弃改名,保留原名(功能不受影响,调用方无需 finding)
    return { dex: loaderDex, oldShellPath: PKG_PREFIX + CLASS_SHELL, newShellPath: PKG_PREFIX + CLASS_SHELL, newLoaderPath: PKG_PREFIX + CLASS_LOADER, renamed: false }
  }

  // 先替换完整路径(含 L...;),命中失败再试无分号形式(smali/JNI 字符串可能不带 L...;)
  let renamed = replaceAll(out, oldShellPath, newShellPath)
  renamed = replaceAll(out, oldLoaderPath, newLoaderPath) || renamed

  // manifest android:name 用不带 L; 的形式(newShellPath 形如 Lpkg/Class; → 去壳)
  const bareShell = `${PKG_PREFIX}${CLASS_SHELL}`
  const bareNewShell = newShellPath.slice(1, -1)
  const bareNewLoader = newLoaderPath.slice(1, -1)

  if (renamed) {
    return {
      dex: recomputeDexChecksums(out),
      oldShellPath: bareShell,
      newShellPath: bareNewShell,
      newLoaderPath: bareNewLoader,
      renamed: true,
    }
  }
  return { dex: loaderDex, oldShellPath: bareShell, newShellPath: bareShell, newLoaderPath: `${PKG_PREFIX}${CLASS_LOADER}`, renamed: false }
}
