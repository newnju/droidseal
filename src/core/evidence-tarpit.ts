// E 项:证据 tarpit(独立 asset 诱饵)
//
// 动机:证据驱动脱壳(REU 型)按容器 magic 扫描 asset 定位候选容器。真容器
// 之外再放置 N 个"形状合法"的诱饵容器:同 magic、同 version=1、条目可解析、
// 密文 GCM 有效(独立 decoy 密钥派生)、与真容器字节级同长(sizeTarget)——
// magic 扫描型自动化必须逐候选完成派生+解密+判定才能断弃,候选数 1 → 1+N,
// 且解出的"证据"是合成命名骨架,真伪判别成本转嫁给攻击者。
//
// 诚实边界(如实,防过度声明):
//  1) 从 stub meta 读出真 asset 名的强 REU 直达真容器——本项不拦截该路径,
//     只提升逐候选验证成本;
//  2) 已知 master 的攻击者可对诱饵条目同样派生解密(诱饵与真条目同族派生);
//     换取的是"解出的证据 = 合成命名骨架副本",证据真伪判别成本转嫁;
//  3) loader 经 AssetManager 按精确名读真容器,诱饵永不进入运行时链(零运行
//     风险,loader 无需变更);真容器解密往返由 harden-chain 单测回归兜底;
//  4) 载荷 = 骨架 dex 的截断副本(尾部含不透明扰动,残差如实披露——截断副本
//     不是合法可加载 dex,但与真条目同为"解密后字节",强先验解析器需逐个
//     判废);缺省无 payloadDex 时退化为黑噪声块。
//  5) 诱饵仅提升成本,不构成新增防护语义;不进暴露度分数口径,不计入能力
//     对拍基准。
import { buildPayloadContainer, deriveEntryKey, encryptContainerEntry, type ContainerEntry } from "./payload-container.ts"

export interface TarpitResult {
  assets: Array<{ name: string; bytes: Uint8Array }>
  /** 诱饵条目总数(写入 finding 用) */
  entryCount: number
}

/** base36 映射(seed 字节 → 定长小写字母数字串) */
function mintSeed(seed: Uint8Array, off: number, len: number): string {
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  let out = ""
  for (let i = 0; i < len; i++) out += chars[(seed[(off + i) % seed.length]! + i * 31) % 36]!
  return out
}

/**
 * 生成 N 个诱饵容器 asset。与真容器共享 magic 与头部布局;条目按
 * deriveEntryKey(master, kind, targetIndex) 同族派生加密(GCM 有效)。
 * 载荷为随机噪声或(提供时)骨架 dex 的截断副本。
 * sizeTarget:给定时诱饵容器总长与真容器**字节级一致**(抗大小排序启发式)。
 */
export function buildEvidenceTarpits(opts: {
  /** 与真容器一致的 12B magic */
  magic: string
  /** 诱饵容器数量(源=运行时不可见,仅发布物字节数与体积可见) */
  count: number
  /** master 密钥(真容器同源;decoy 条目派生同族) */
  masterKey: Uint8Array
  /** 骨架 dex 副本载荷(可缺省);提供时诱饵条目=截断副本 */
  payloadDex?: Uint8Array | undefined
  /** 真 asset 名干支,如 "droidseal.brG" —— 诱饵名共享干支、随机后缀 */
  assetStem: string
  /** 扰动种子(逐构建) */
  seed: Uint8Array
  /** 诱饵容器目标总长(通常=真容器字节数;抗大小排序) */
  sizeTarget?: number
}): TarpitResult {
  const assets: TarpitResult["assets"] = []
  let entryCount = 0
  // 容器总长 = 20(头部) + 2×12(条目头) + (dexLen+28) + (tableLen+28)
  //            = 100 + dexLen + tableLen
  for (let k = 0; k < opts.count; k++) {
    const entries: ContainerEntry[] = []
    const tableLen = 96 + (opts.seed[k % opts.seed.length]! % 64)
    let dexLen: number
    if (opts.sizeTarget !== undefined) {
      dexLen = opts.sizeTarget - 100 - tableLen
    } else {
      dexLen = opts.payloadDex ? opts.payloadDex.length : 160 + (opts.seed[k % opts.seed.length]! % 96)
    }
    // 条目 1:kind=dex,targetIndex 故意越界(3000+,运行时不可命中)
    let dexPlain: Uint8Array
    if (opts.payloadDex) {
      dexPlain = opts.payloadDex.slice(0, dexLen)
      // 全长步进扰动(步长 7;避开头部 64B 的 magic/checksum 结构区间)
      for (let i = 64; i < dexPlain.length; i += 7) {
        dexPlain[i] = opts.seed[(i + k * 13) % opts.seed.length]!
      }
    } else {
      dexPlain = new Uint8Array(dexLen)
      for (let i = 0; i < dexPlain.length; i += 7) {
        dexPlain[i] = opts.seed[(i + k * 13) % opts.seed.length]!
      }
    }
    entries.push({ kind: "dex", targetIndex: 3000 + k, bytes: encryptContainerEntry(dexPlain, deriveEntryKey(opts.masterKey, "dex", 3000 + k)) })
    entryCount += 1
    // 条目 2:citable 形状(随机定长表)
    const table = new Uint8Array(tableLen)
    for (let i = 0; i < tableLen; i++) table.set(Uint8Array.of(opts.seed[(i + k) % opts.seed.length]!), i)
    entries.push({ kind: "citable", targetIndex: 0, bytes: encryptContainerEntry(table, deriveEntryKey(opts.masterKey, "citable", 0)) })
    entryCount += 1
    const bytes = buildPayloadContainer(entries, { magic: opts.magic })
    assets.push({ name: `assets/${opts.assetStem.split(".")[0]}.${mintSeed(opts.seed, 3 + k, 3)}`, bytes })
  }
  return { assets, entryCount }
}
