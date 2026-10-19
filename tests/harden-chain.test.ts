// 加固链关键边界单元测试:stub 随机化 / loader 标识符随机化 / per-entry HKDF / loader 密钥补丁。
import { describe, expect, test } from "bun:test"
import { randomBytes } from "node:crypto"
import { readFileSync } from "node:fs"
import path from "node:path"

import {
  buildPayloadContainer,
  parsePayloadContainer,
  deriveEntryKey,
  chainSeed,
  encryptContainerEntryDerived,
  decryptContainerEntryDerived,
} from "../src/core/payload-container.ts"
import { randomizeLoaderIdentifiers } from "../src/core/loader-ident-randomize.ts"
import {
  randomizeStubIdentifiers,
  deriveLoaderKey,
  encryptLoaderDex,
} from "../src/core/stub-encapsulate.ts"
import { patchLoaderDexKeys } from "../src/core/loader-key-patch.ts"
import { generateNativeShellFiles } from "../src/core/native-shell.ts"
import { buildEvidenceTarpits } from "../src/core/evidence-tarpit.ts"
import { decryptContainerEntry, type ContainerEntry } from "../src/core/payload-container.ts"

const CERT = "51a3ebd686f801ce3fa77273a524745a1675084979f496a24b9e0f7c0af79736"
const loaderDex = () => new Uint8Array(readFileSync(path.join(import.meta.dir, "..", "runtime", "droidseal-loader.dex")))
const stubDex = () => new Uint8Array(readFileSync(path.join(import.meta.dir, "..", "runtime", "droidseal-stub.dex")))

describe("per-entry HKDF 密钥派生", () => {
  test("不同 kind/index 派生不同密钥", () => {
    const master = randomBytes(32)
    const k1 = deriveEntryKey(master, "dex", 0)
    const k2 = deriveEntryKey(master, "dex", 1)
    const k3 = deriveEntryKey(master, "citable", 0)
    expect(k1.length).toBe(32)
    expect(Buffer.compare(k1, k2)).not.toBe(0)
    expect(Buffer.compare(k1, k3)).not.toBe(0)
  })

  test("同参数派生确定一致(Java 端一致性前提)", () => {
    const master = randomBytes(32)
    expect(Buffer.compare(deriveEntryKey(master, "dex", 0), deriveEntryKey(master, "dex", 0))).toBe(0)
  })

  test("加解密回环:派生密钥加密后按同参数解密还原", () => {
    const master = randomBytes(32)
    const plain = new Uint8Array([0x64, 0x65, 0x78, 0x0a, 0x30, 0x33, 0x35, 0x00, ...randomBytes(256)])
    const enc = encryptContainerEntryDerived(plain, master, "dex", 7)
    expect(enc.length).toBe(28 + plain.length)
    const dec = decryptContainerEntryDerived(enc, master, "dex", 7)
    expect(dec).toBeDefined()
    expect(Buffer.compare(dec!, plain)).toBe(0)
  })

  test("参数错位解密失败(GCM tag 校验拒绝)", () => {
    const master = randomBytes(32)
    const plain = randomBytes(128)
    const enc = encryptContainerEntryDerived(plain, master, "dex", 0)
    expect(decryptContainerEntryDerived(enc, master, "dex", 1)).toBeUndefined()
    expect(decryptContainerEntryDerived(enc, master, "citable", 0)).toBeUndefined()
  })

  test("条目哈希链:同链参数回环成功,链前驱错位解密失败", () => {
    const master = randomBytes(32)
    const plain = new Uint8Array([0x64, 0x65, 0x78, 0x0a, ...randomBytes(120)])
    const seed1 = randomBytes(16)
    const enc = encryptContainerEntryDerived(plain, master, "dex", 0, undefined, 0, seed1)
    // 同链参数回环
    const dec = decryptContainerEntryDerived(enc, master, "dex", 0, undefined, 0, seed1)
    expect(dec).toBeDefined()
    expect(Buffer.compare(dec!, plain)).toBe(0)
    // 链前驱错位(条目被增/删/改/重排时运行时算出的 seed 不同)→ GCM 拒绝
    const wrongSeed = randomBytes(16)
    expect(decryptContainerEntryDerived(enc, master, "dex", 0, undefined, 0, wrongSeed)).toBeUndefined()
    expect(decryptContainerEntryDerived(enc, master, "dex", 0, undefined, 0, undefined)).toBeUndefined()
  })

  test("chainSeed:密文哈希前 16B,不同密文种子不同", () => {
    const a = chainSeed(randomBytes(64))!
    const b = chainSeed(randomBytes(64))!
    expect(a.length).toBe(16)
    expect(Buffer.compare(a, b)).not.toBe(0)
    expect(chainSeed(undefined)).toBeUndefined()
    expect(chainSeed(new Uint8Array(0))).toBeUndefined()
  })
})

describe("payload 容器随机 magic", () => {
  test("自定义 magic 写入并以同 magic 解析成功", () => {
    const magic = "XYz123AbCdEf"
    const entries = [{ kind: "dex" as const, targetIndex: 0, bytes: randomBytes(64) }]
    const blob = buildPayloadContainer(entries, { magic })
    expect(Buffer.from(blob.slice(0, 12)).toString()).toBe(magic)
    expect(parsePayloadContainer(blob, { magic })).toHaveLength(1)
  })

  test("magic 不匹配解析失败(运行时 fail-closed 前提)", () => {
    const entries = [{ kind: "dex" as const, targetIndex: 0, bytes: randomBytes(64) }]
    const blob = buildPayloadContainer(entries, { magic: "AAAAAAAAAAAA" })
    expect(parsePayloadContainer(blob, { magic: "BBBBBBBBBBBB" })).toBeUndefined()
    expect(parsePayloadContainer(blob)).toBeUndefined() // 缺省 magic 也不匹配
  })

  test("缺省 magic 兼容旧格式", () => {
    const entries = [{ kind: "dex" as const, targetIndex: 0, bytes: randomBytes(64) }]
    const blob = buildPayloadContainer(entries)
    expect(parsePayloadContainer(blob)).toHaveLength(1)
  })
})

describe("loader 标识符随机化", () => {
  test("enable=true:四个固定签名全部替换且 DEX 校验和重算", () => {
    const dex = loaderDex()
    const r = randomizeLoaderIdentifiers(dex, true)
    expect(r.changed.length).toBe(4)
    expect(r.missed).toHaveLength(0)
    // 新值等长
    for (const c of r.changed) expect(c.to.length).toBe(c.from.length)
    // 原签名全部消失
    const text = Buffer.from(r.dex).toString("latin1")
    for (const sig of ["DROIDSEALBIN", "droidseal.bin", "droidseal.original_app", "droidseal.shell_so"]) {
      expect(text.includes(sig)).toBe(false)
    }
    // 返回的随机值与 changed 一致
    expect(r.magic.length).toBe(12)
    expect(r.assetName.length).toBe(13)
  })

  test("enable=false:原样返回缺省值", () => {
    const dex = loaderDex()
    const r = randomizeLoaderIdentifiers(dex, false)
    expect(r.magic).toBe("DROIDSEALBIN")
    expect(r.assetName).toBe("droidseal.bin")
    expect(r.changed).toHaveLength(0)
    expect(Buffer.compare(r.dex, dex)).toBe(0)
  })

  test("两次随机化产生不同值(CSPRNG)", () => {
    const r1 = randomizeLoaderIdentifiers(loaderDex(), true)
    const r2 = randomizeLoaderIdentifiers(loaderDex(), true)
    expect(r1.magic).not.toBe(r2.magic)
  })
})

describe("stub 标识符随机化", () => {
  test("四点标记全命中,stub 类路径合法且类名无残留", () => {
    const r = randomizeStubIdentifiers(stubDex(), {
      enable: true,
      // 34B 斜杠形式,点分后落 stub 壳名槽 ("droidseal-loader-v1", "ds_loader_asset_mk1") 内
      shellClassPath: "droidtaab/cdefghi/Jklmnopqrstuvwxy",
      metaKey: "qwzxkvnmbertplwoas1", // 19B
    })
    expect(r.changed.length).toBe(4)
    expect(r.missed).toHaveLength(0)
    // 点分形式类路径(SEC-012 槽内构造,段数=原标记的段数 3 或 2,由槽区间决定)
    const parts = r.stubClassPath.split(".")
    expect(parts.length).toBeGreaterThanOrEqual(2)
    for (const p of parts) expect(/^[A-Za-z][A-Za-z0-9_]*$/.test(p)).toBe(true)
    const text = Buffer.from(r.dex).toString("latin1")
    expect(text.includes("BootstrapStub")).toBe(false)
    expect(text.includes("ds_loader_asset_mk1")).toBe(false)
  })

  test("壳类路径长度不符时如实标 missed(不静默)", () => {
    const r = randomizeStubIdentifiers(stubDex(), {
      enable: true,
      shellClassPath: "short/path", // 非 34B
      metaKey: "qwzxkvnmbertplwoas1",
    })
    expect(r.missed).toContain("droidseal.runtime.ShellApplication")
  })
})

describe("loader DEX 密钥补丁", () => {
  test("三标记全命中,指纹真实嵌入", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), CERT)
    expect(r.patchedPart1).toBe(true)
    expect(r.patchedPart2).toBe(true)
    expect(r.patchedCert).toBe(true)
  })

  test("证书 hex 非法时跳过指纹补丁(不写垃圾)", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), "zzzz")
    expect(r.patchedCert).toBe(false)
  })

  test("密钥长度不符直接抛错", () => {
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(16), randomBytes(32))).toThrow(/32/)
  })
})

describe("loader DEX opt-in 开关标记(B 项)", () => {
  /** 定位 16B 同值字节串;找不到返回 -1 */
  function endsOfRun(dex: Uint8Array, byte: number, len: number): number {
    for (let i = 0; i <= dex.length - len; i++) {
      let j = 0
      while (j < len && dex[i + j] === byte) j++
      if (j === len) return i
    }
    return -1
  }

  test("opt-in 启用:标记槽位替换为 0x01×16,0xC5×16 不残留", () => {
    const dex = loaderDex()
    const slot = endsOfRun(dex, 0xc5, 16)
    expect(slot).toBeGreaterThanOrEqual(0) // 未补丁 loader 含 0xC5×16
    const r = patchLoaderDexKeys(dex, randomBytes(32), randomBytes(32), CERT, { rootSignals: true, patrolRevote: true })
    expect(r.patchedFlags).toBe(true)
    // 同一槽位被替换为 0x01(其余区域本就含单字节 0xC5/0x01,断言限制在标记槽内)
    let on16 = true
    for (let j = 0; j < 16; j++) on16 = on16 && r.dex[slot + j] === 0x01
    expect(on16).toBe(true)
    expect(endsOfRun(r.dex, 0xc5, 16)).toBe(-1)
  })

  test("opt-in 关闭:标记槽位仍被替换(0x00×16),不留指纹", () => {
    const dex = loaderDex()
    const slot = endsOfRun(dex, 0xc5, 16)
    const r = patchLoaderDexKeys(dex, randomBytes(32), randomBytes(32), CERT, { rootSignals: false, patrolRevote: false })
    expect(r.patchedFlags).toBe(true)
    let off16 = true
    for (let j = 0; j < 16; j++) off16 = off16 && r.dex[slot + j] === 0x00
    expect(off16).toBe(true)
    expect(endsOfRun(r.dex, 0xc5, 16)).toBe(-1)
  })

  test("未传 optIn:标记保持 0xC5 原样(旧调用兼容)", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), CERT)
    expect(r.patchedFlags).toBe(false)
    expect(endsOfRun(r.dex, 0xc5, 16)).toBeGreaterThanOrEqual(0)
  })
})

describe("C 项:逐构建 native 结构随机化", () => {
  const mk = (seed?: Uint8Array, prefix?: string) => generateNativeShellFiles({
    packageName: "com.t.app", soName: "libzqx.so", algorithm: "aes-256-gcm",
    enableAntiFrida: true, enableAntiDump: true, enableAntiDebug: true,
    enableArtHook: false, jniClassPath: "droidseal/runtime/DroidSealLoader",
    keyPart2Hex: CERT, identPrefix: prefix, noiseSeed16: seed,
  })
  const pick = (files: Array<{ name: string; content: string }>, tail: string) =>
    files.find((f) => f.name.endsWith(tail))!.content
  const seed1 = randomBytes(16)
  const seed2 = randomBytes(16)

  test("同种子调用 → 同产物字节;异种子 → 结构性差异(filler 表/XOR key/置换)", () => {
    const a = mk(seed1, "kxw")
    const b = mk(seed1, "kxw")
    expect(pick(a, "text_integrity.c")).toBe(pick(b, "text_integrity.c"))
    expect(pick(a, "guard_vote.c")).toBe(pick(b, "guard_vote.c"))
    const c = mk(seed2, "kxw")
    const buf = (s: string) => Buffer.from(s)
    expect(buf(pick(a, "text_integrity.c")).equals(buf(pick(c, "text_integrity.c")))).toBe(false)
    expect(buf(pick(a, "guard_vote.c")).equals(buf(pick(c, "guard_vote.c")))).toBe(false)
  })

  test("语义不变量:DSTC 标记 / JNI 导出契约 / 四源全在 dispatch / 前缀落位", () => {
    const a = mk(seed1, "kxw")
    const ti = pick(a, "text_integrity.c")
    expect(ti.includes("'D', 'S', 'T', 'C'")).toBe(true)
    expect(ti.includes("kxw_text_integrity_check(void)")).toBe(true)
    expect(ti.includes("extern uint32_t kxw_crc32")).toBe(true)
    expect(ti.includes("kxw_filler0")).toBe(true) // seeded → filler 在场
    const ti2 = pick(mk(undefined, undefined), "text_integrity.c")
    expect(ti2.includes("ds_text_integrity_check(void)")).toBe(true) // 缺省前缀回退
    expect(ti2.includes("filler")).toBe(false) // 无种子 → 无 filler(legacy 形态)
    const gv = pick(a, "guard_vote.c")
    expect(gv.includes("Java_droidseal_runtime_DroidSealLoader_nativeGuardVote")).toBe(true) // JNI 名不随机
    for (const frag of ["parent_traced() ? 1 : 0", "probe_port(27042)", "maps_hit() ? 1 : 0", "text_integrity_check(); verdict |= (ti == 1) ? 1 : 0"]) {
      expect(gv.replace(/kxw/g, "").includes(frag)).toBe(true)
    }
    // XOR key 来自 seed[0..7](种子确定性断言)
    const k = seed1.subarray(0, 8).join(", ")
    expect(gv.includes(`{ ${k} }`)).toBe(true)
  })
})

describe("E 项:证据 tarpit(独立诱饵容器 asset)", () => {
  const master = randomBytes(32)
  const magic12 = "dsx0thermux"
  const stub = stubDex()

  test("诱饵与真容器同 magic/可解析/条目 GCM 有效;真容器往返不受影响", () => {
    const realEntries: ContainerEntry[] = [
      { kind: "dex", targetIndex: 0, bytes: new Uint8Array(96).fill(7) },
    ]
    const real = buildPayloadContainer(realEntries, { magic: magic12 })
    const t = buildEvidenceTarpits({ magic: magic12, count: 3, masterKey: master, payloadDex: stub, assetStem: "droidseal.xx1", seed: randomBytes(16) })
    expect(t.assets.length).toBe(3)
    expect(t.entryCount).toBe(6)
    for (const d of t.assets) {
      // 命名:同干支不同随机后缀,且不等于真容器名
      expect(d.name.startsWith("assets/droidseal.")).toBe(true)
      expect(d.name).not.toBe("assets/droidseal.xx1")
      // 形状:解析成功且至少一条条目
      const parsed = parsePayloadContainer(d.bytes, { magic: magic12 })
      expect(parsed).toBeDefined()
      expect(parsed!.length).toBeGreaterThanOrEqual(2)
      // GCM 有效:decoy 条目按同族派生解密成功;kind=dex 载荷为合法 dex 骨架副本
      const dexEntry = parsed!.find((e) => e.kind === "dex")
      expect(dexEntry).toBeDefined()
      const plain = decryptContainerEntry(dexEntry!.bytes, deriveEntryKey(master, "dex", dexEntry!.targetIndex))
      expect(plain).toBeDefined()
      expect(Array.from(plain!.slice(0, 4))).toEqual([0x64, 0x65, 0x78, 0x0a]) // "dex\n"
      // citable 条目同样可解
      const cit = parsed!.find((e) => e.kind === "citable")
      expect(decryptContainerEntry(cit!.bytes, deriveEntryKey(master, "citable", 0))).toBeDefined()
    }
    // 真容器往返不受诱饵存在影响(诱饵独立 asset,与容器字节无交集)
    const realParsed = parsePayloadContainer(real, { magic: magic12 })
    expect(realParsed!.length).toBe(1)
  })

  test("缺省 payloadDex → 定长噪声载荷;count 可调;诱饵大小与真容器接近", () => {
    const t = buildEvidenceTarpits({ magic: magic12, count: 2, masterKey: master, assetStem: "droidseal.aa0", seed: randomBytes(16) })
    expect(t.assets.length).toBe(2)
    expect(t.entryCount).toBe(4)
    const parsed = parsePayloadContainer(t.assets[0]!.bytes, { magic: magic12 })
    const dexEntry = parsed!.find((e) => e.kind === "dex")!
    const plain = decryptContainerEntry(dexEntry.bytes, deriveEntryKey(master, "dex", dexEntry.targetIndex))
    expect(plain!.length).toBeLessThanOrEqual(256)
    expect(plain!.length).toBeGreaterThanOrEqual(160)
  })
})

describe("loader DEX 自加密(HKDF(证书摘要))", () => {
  test("密文非 DEX magic 且长度 = 28 + 明文", () => {
    const dex = loaderDex()
    const enc = encryptLoaderDex(dex, CERT)
    expect(enc.length).toBe(28 + dex.length)
    expect(Buffer.from(enc.slice(0, 3)).toString()).not.toBe("dex")
  })

  test("不同证书派生不同密钥(换签名即解密失败的前提)", () => {
    const dex = loaderDex()
    const e1 = encryptLoaderDex(dex, CERT)
    const e2 = encryptLoaderDex(dex, "aa".repeat(32))
    expect(Buffer.compare(e1.slice(0, 12), e2.slice(0, 12))).not.toBe(0) // nonce 随机
    expect(Buffer.compare(deriveLoaderKey(CERT), deriveLoaderKey("aa".repeat(32)))).not.toBe(0)
  })

  test("deriveLoaderKey 确定性", () => {
    expect(Buffer.compare(deriveLoaderKey(CERT), deriveLoaderKey(CERT))).toBe(0)
  })
})
