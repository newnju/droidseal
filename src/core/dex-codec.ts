// DEX write/read encoding primitives.
import { randomBytes } from "node:crypto"
//
// The existing dex-scan.ts has a lenient read-only ULEB128 used for heuristic
// string-pool scanning. The write engine needs the full, exact codec: the LEB128
// family in both directions, a precise Modified UTF-8 (MUTF-8) codec, and Adler-32.

export interface LebRead {
  value: number
  next: number
}

// Unsigned LEB128. Up to 5 bytes (32-bit). Result is coerced to an unsigned u32.
export function writeUleb128(value: number): number[] {
  let remaining = value >>> 0
  const out: number[] = []
  do {
    let byte = remaining & 0x7f
    remaining >>>= 7
    if (remaining !== 0) byte |= 0x80
    out.push(byte)
  } while (remaining !== 0)
  return out
}

export function readUleb128(bytes: Uint8Array, at: number): LebRead {
  let result = 0
  let shift = 0
  let index = at
  while (true) {
    const byte = bytes[index]!
    index += 1
    result |= (byte & 0x7f) << shift
    if ((byte & 0x80) === 0) break
    shift += 7
    if (shift > 28) break
  }
  return { value: result >>> 0, next: index }
}

// ULEB128p1: encodes (value + 1) as ULEB128, allowing the sentinel value -1
// (encoded as 0). Used for optionally-absent indices (e.g. debug_info name_idx).
export function writeUleb128p1(value: number): number[] {
  return writeUleb128((value + 1) >>> 0)
}

export function readUleb128p1(bytes: Uint8Array, at: number): LebRead {
  const { value, next } = readUleb128(bytes, at)
  return { value: value - 1, next }
}

// Signed LEB128. Sign-extends the final byte.
export function writeSleb128(value: number): number[] {
  const out: number[] = []
  let remaining = value | 0
  while (true) {
    const byte = remaining & 0x7f
    const signBit = byte & 0x40
    remaining >>= 7 // arithmetic shift preserves sign
    const done = (remaining === 0 && signBit === 0) || (remaining === -1 && signBit !== 0)
    out.push(done ? byte : byte | 0x80)
    if (done) break
  }
  return out
}

export function readSleb128(bytes: Uint8Array, at: number): LebRead {
  let result = 0
  let shift = 0
  let index = at
  let byte = 0
  do {
    byte = bytes[index]!
    index += 1
    result |= (byte & 0x7f) << shift
    shift += 7
  } while ((byte & 0x80) !== 0 && shift < 35)
  // Sign-extend when the final continuation bit is clear and the sign bit is set.
  if (shift < 32 && (byte & 0x40) !== 0) result |= -(1 << shift)
  return { value: result | 0, next: index }
}

// -- Modified UTF-8 (MUTF-8) ------------------------------------------------
//
// Differences from standard UTF-8:
//  * U+0000 is encoded as the two bytes 0xC0 0x80 (never a bare 0x00, which is
//    the string terminator).
//  * Supplementary characters (U+10000+) are NOT 4-byte encoded; each UTF-16
//    surrogate half is encoded independently as 3 bytes (6 bytes total). Because
//    JS strings are already UTF-16, iterating char codes yields this for free.

export function encodeMutf8(text: string): Uint8Array {
  const out: number[] = []
  for (let i = 0; i < text.length; i += 1) {
    const c = text.charCodeAt(i)
    if (c === 0) {
      out.push(0xc0, 0x80)
    } else if (c < 0x80) {
      out.push(c)
    } else if (c < 0x800) {
      out.push(0xc0 | (c >> 6), 0x80 | (c & 0x3f))
    } else {
      out.push(0xe0 | (c >> 12), 0x80 | ((c >> 6) & 0x3f), 0x80 | (c & 0x3f))
    }
  }
  return Uint8Array.from(out)
}

export function decodeMutf8(bytes: Uint8Array): string {
  let out = ""
  let i = 0
  const n = bytes.byteLength
  while (i < n) {
    const b = bytes[i]!
    if (b < 0x80) {
      out += String.fromCharCode(b)
      i += 1
    } else if ((b & 0xe0) === 0xc0) {
      const c = ((b & 0x1f) << 6) | (bytes[i + 1]! & 0x3f)
      out += String.fromCharCode(c)
      i += 2
    } else if ((b & 0xf0) === 0xe0) {
      const c = ((b & 0x0f) << 12) | ((bytes[i + 1]! & 0x3f) << 6) | (bytes[i + 2]! & 0x3f)
      out += String.fromCharCode(c)
      i += 3
    } else {
      // Defensive: emit the raw byte rather than throwing on malformed input.
      out += String.fromCharCode(b)
      i += 1
    }
  }
  return out
}

// -- Adler-32 ---------------------------------------------------------------
//
// DEX header checksum. Modulo the largest prime < 65536; block the inner loop to
// keep the accumulators within safe-integer range before each modulo.
const ADLER_MOD = 65521
const ADLER_BLOCK = 5552

export function adler32(bytes: Uint8Array): number {
  let a = 1
  let b = 0
  let i = 0
  const n = bytes.byteLength
  while (i < n) {
    const end = Math.min(i + ADLER_BLOCK, n)
    for (; i < end; i += 1) {
      a += bytes[i]!
      b += a
    }
    a %= ADLER_MOD
    b %= ADLER_MOD
  }
  return (((b << 16) | a) >>> 0)
}

// -- DEX 字符串保序随机化(SEC-012) -------------------------------------------
//
// 等长字节替换式随机化会破坏 string_ids 的字典序约束(DEX 规范:string_ids 必须
// 按 UTF-16 码点序升序),ART 校验失败:"Out-of-order string_ids" → 拒载。
// 修复策略:**保序替换**——替换前先读出该串在 string_ids 表中的排序邻居
// (前驱/后继),随机名必须严格落在 (prev, next) 开区间内,否则重试;超过上限
// 则放弃该项(保留原名,调用方 finding 如实标注)。表结构零改动,数据区零移动,
// 替换后照常重算 signature/checksum。

/** 比较 DEX 字符串序:按 UTF-16 码点逐位比较,再比长度(与 ART 的排序一致) */
export function cmpDexString(a: string, b: string): number {
  const n = Math.min(a.length, b.length)
  for (let i = 0; i < n; i += 1) {
    const d = a.charCodeAt(i) - b.charCodeAt(i)
    if (d !== 0) return d
  }
  return a.length - b.length
}

export interface OrderedNameSlot {
  prev: string | undefined // undefined = 无前驱(-∞)
  next: string | undefined // undefined = 无后继(+∞)
}

function nextZero(bytes: Uint8Array, from: number): number {
  let e = from
  while (e < bytes.length && bytes[e] !== 0) e += 1
  return e
}

/** 解码 string_ids 表第 i 项指向的字符串(跳过 uleb128 长度前缀) */
function readStringAt(dex: Uint8Array, dataOff: number): string {
  let p = dataOff
  for (;;) { const b = dex[p]!; p += 1; if ((b & 0x80) === 0) break }
  return decodeMutf8(dex.subarray(p, nextZero(dex, p)))
}

/**
 * 读取 string_ids 表,返回 target 字符串所在槽位的排序邻居。
 * 入参 dex 必须是**随机化替换之前**的表(此时表序仍规范)。
 * target 未在表中时返回空槽(调用方视为"无约束",等长替换安全)。
 */
export function findStringNeighbors(dex: Uint8Array, target: string): OrderedNameSlot {
  const view = new DataView(dex.buffer, dex.byteOffset, dex.byteLength)
  const size = view.getUint32(56, true)
  const off = view.getUint32(60, true)
  let lo = 0; let hi = size - 1; let hit = -1
  while (lo <= hi) {
    const mid = (lo + hi) >> 1
    const s = readStringAt(dex, view.getUint32(off + mid * 4, true))
    const c = cmpDexString(s, target)
    if (c === 0) { hit = mid; break }
    if (c < 0) lo = mid + 1; else hi = mid - 1
  }
  if (hit < 0) return { prev: undefined, next: undefined }
  const prev = hit > 0 ? readStringAt(dex, view.getUint32(off + (hit - 1) * 4, true)) : undefined
  const next = hit < size - 1 ? readStringAt(dex, view.getUint32(off + (hit + 1) * 4, true)) : undefined
  return { prev, next }
}

/** 随机名是否严格落在 (prev, next) 开区间内 */
export function nameFitsSlot(name: string, slot: OrderedNameSlot): boolean {
  if (slot.prev !== undefined && cmpDexString(name, slot.prev) <= 0) return false
  if (slot.next !== undefined && cmpDexString(name, slot.next) >= 0) return false
  return true
}

// -- SEC-012:槽内随机名构造(保序随机名的通用解) ------------------------------
//
// 逐位置构造:与 prev/next 并列时窗口收到 [prev[i], next[i]],取大/取小即解除
// 并列(此后自由);并列延续到对方耗尽时按"更长 ⇒ 大于 prev / 大于 next"判定
// 可行性。取小(next 侧)或取大(prev 侧)后必须解除并列,否则窗口被对方后续
// 字符错误收紧成死窗。字符候选 = 窗口 ∩ 类名合法字符集;整串收尾 nameFitsSlot 终验。

// 类路径合法字符集:JLS 标识符字符(字母/数字/_/$)+ 路径分隔 '/'。
// '.'、';'、'=' 只能出现在结构位置(L 前缀、; 后缀),不能出现在随机段里,
// 否则 ART 类名校验(JLS)拒载。
const SLOT_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_$/"
/** 供调用方组合资源名字母表的 JLS 基集(导出别名) */
export const SLOT_ALPHABET_DEFAULT = SLOT_ALPHABET
// 注意:字母表不是按码点排序的(数字 0-9 在 'A' 之前,'_'(0x5f) 与 '/'(0x2f)、
// ';'(0x3b)、'.'(0x2e)、'='(0x3d) 散布其间)——默认窗口边界必须取**真实码点**
// 最小/最大,不能用首尾元素(否则 [A, =] 是反窗,两侧并列解除后必死)。
const SLOT_FIRST = 0x2f // '/'——字母表最小码点
const SLOT_LAST = 0x7a // 'z'——字母表最大码点

export function genNameInSlot(len: number, slot: OrderedNameSlot, alphabet?: string, attempts = 32): string | undefined {
  const chars = alphabet ?? SLOT_ALPHABET
  for (let a = 0; a < attempts; a += 1) {
    let tiedPrev = slot.prev !== undefined
    let tiedNext = slot.next !== undefined
    let out = ""
    let ok = true
    for (let i = 0; i < len; i += 1) {
      let lo = SLOT_FIRST
      let hi = SLOT_LAST
      if (tiedPrev) {
        const p = slot.prev!
        if (i < p.length) {
          lo = p.charCodeAt(i)
          if (i === len - 1) lo += 1 // 末位仍与 prev 相等 ⇒ 名=prev,违反开区间
        } else {
          tiedPrev = false // 名比 prev 长且前缀相等 ⇒ 名 > prev,此后自由
        }
      }
      if (tiedNext) {
        const nx = slot.next!
        if (i < nx.length) {
          hi = nx.charCodeAt(i)
          if (i === len - 1) hi -= 1
        } else {
          ok = false // 名比 next 长且前缀相等 ⇒ 名 > next,不可行
          break
        }
      }
      if (lo > hi) { ok = false; break }
      const cands: string[] = []
      for (const ch of chars) {
        const c = ch.charCodeAt(0)
        if (c >= lo && c <= hi) cands.push(ch)
      }
      if (cands.length === 0) { ok = false; break }
      const c = cands[randomBytes(4).readUInt32LE(0) % cands.length]!.charCodeAt(0)
      // 状态转移:取大(prev)/取小(next)即解除并列;取等才延续
      if (tiedPrev) tiedPrev = i < slot.prev!.length && c === slot.prev!.charCodeAt(i)
      if (tiedNext) tiedNext = i < slot.next!.length && c === slot.next!.charCodeAt(i)
      out += String.fromCharCode(c)
    }
    if (!ok) continue
    if (!nameFitsSlot(out, slot)) continue
    return out
  }
  return undefined
}

// -- SEC-012:多改名项级联约束 --------------------------------------------------
//
// 同一 DEX 内多个改名项的槽区间可能重叠:每项各自落在自己的 (prev,next) 内,
// 但两项的产出可能交错(表序破坏)。解法:按原 string_ids 索引升序处理,第 k 项的
// next 上界改用"下一个改名项的原名"(下一项的产出 ≤ 其原名 ⇒ 级联后整体有序;
// prev 界:第一项用原 prev,后续项产出 ≤ 前项原名?不——前项产出可大于原前项名。
// 简化且正确的充分条件:第 k 项约束 (原 prev_k, min(原 next_k, 下一改名项原名))。
// 下一项产出 < 原名_{k+1}(开区间),且 ≥ 名_k(因为名_k < 原名_{k+1} 且各槽
// prev 界保证…不成立——名_k 与名_{k+1} 之间无直接约束)。
// ⇒ 完全正确的做法:一次生成全部名字后**整体校验**改名项之间的相对序(用
//   cmpDexString),不满足则重试整批。改名项 ≤ 5 个、每项槽自由度大,整批重试
//   若干次内必收敛;全败则放弃随机化(保留原名,功能无损)。

export interface CascadeSlot {
  /** 被替换的原名(表内必存在) */
  original: string
  /** 可选的自定义生成值(如壳点分名由外部给出) */
  candidate?: (slot: OrderedNameSlot) => string | undefined
  /** 候选字母表扩展(资源名场景) */
  alphabet?: string
}

/**
 * 级联式批量槽内随机名:整批生成 + 整批相对序校验,失败整批重试。
 * 任一项失败或批内乱序无法收敛时返回 undefined(调用方放弃随机化,保留原名)。
 */
export function genNamesInSlots(items: CascadeSlot[], slots: OrderedNameSlot[], batchAttempts = 64): string[] | undefined {
  // 批量收敛是概率性的(槽区间与字母表约束下随机碰撞):8 次重试在 4 项批上仍有
  // ~1% 量级的偶发全批失败(表现为随机化静默降级为保留原名)。提高重试次数把
  // 失败概率压到可忽略,单次尝试仅字符串生成 + 相对序比较,纳秒级成本;
  // 仍不收敛时返回 undefined,调用方如实保留原名(missed 标注),语义不变。
  if (items.length !== slots.length) return undefined
  for (let b = 0; b < batchAttempts; b += 1) {
    const out: (string | undefined)[] = new Array(items.length)
    let ok = true
    for (let i = 0; i < items.length; i += 1) {
      const it = items[i]!, sl = slots[i]!
      const v = it.candidate ? it.candidate(sl) : genNameInSlot(it.original.length, sl, it.alphabet)
      if (v === undefined || !nameFitsSlot(v, sl)) { ok = false; break }
      out[i] = v
    }
    if (!ok) continue
    // 批内相对序校验(改名项之间不能交错;以原名在表中的相对序为准)
    const names = out as string[]
    for (let i = 0; i + 1 < names.length; i += 1) {
      // 原名 i < 原名 i+1(表序),产出也必须保持 <
      if (cmpDexString(names[i]!, names[i + 1]!) >= 0) { ok = false; break }
    }
    if (ok) return names
  }
  return undefined
}
