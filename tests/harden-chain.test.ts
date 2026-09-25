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
  test("三标记 + KS 开关全命中,指纹真实嵌入", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), CERT, true)
    expect(r.patchedPart1).toBe(true)
    expect(r.patchedPart2).toBe(true)
    expect(r.patchedCert).toBe(true)
    expect(r.patchedKsFlag).toBe(true)
    const text = Buffer.from(r.dex).toString("latin1")
    expect(text.includes("KS_BIND_FLAG_1")).toBe(true)
    expect(text.includes("KS_BIND_FLAG_0")).toBe(false)
  })

  test("KS 开关关闭时 flag 保持 0", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), CERT, false)
    expect(r.patchedKsFlag).toBe(false)
    expect(Buffer.from(r.dex).toString("latin1").includes("KS_BIND_FLAG_0")).toBe(true)
  })

  test("证书 hex 非法时跳过指纹补丁(不写垃圾)", () => {
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), "zzzz", true)
    expect(r.patchedCert).toBe(false)
  })

  test("密钥长度不符直接抛错", () => {
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(16), randomBytes(32))).toThrow(/32/)
  })

  test("挑战 URL 全长度补丁:标记完全替换,尾部 # 填充等长", () => {
    const url = "https://challenge.example.com/ds/part3"
    const r = patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), undefined, false, url)
    expect(r.patchedUrl).toBe(true)
    const text = Buffer.from(r.dex).toString("latin1")
    expect(text.includes(url)).toBe(true)
    // 128B 标记(DS_SRV_URL + 118 个 #)必须整体消失——部分命中不算补丁成功
    expect(text.includes("DS_SRV_URL")).toBe(false)
    // 尾部以 # 补齐到 128 字符(URL 42 + 填充 86)
    const i = text.indexOf(url)
    expect(text.slice(i + url.length, i + url.length + 4)).toBe("####")
  })

  test("挑战 URL 非法:含 # / 非 https / 超长直接抛错(不写坏 DEX)", () => {
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), undefined, false, "http://a.example.com")).toThrow(/https/)
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), undefined, false, "https://a#b.com")).toThrow(/#/)
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), undefined, false, `https://${"a".repeat(200)}.com`)).toThrow(/128/)
  })

  test("挑战 URL 非法:非 ASCII(IDN 域名)直接抛错——字节长 ≠ 字符长,padEnd 会写坏 DEX", () => {
    expect(() => patchLoaderDexKeys(loaderDex(), randomBytes(32), randomBytes(32), undefined, false, "https://例え.jp/part3")).toThrow(/ASCII/)
  })

  test("假阳性防护:仅含标记前 32B 子串的 DEX 不得报 patchedUrl", () => {
    // 构造只有 32B 部分标记的合成 DEX——旧 findMarker(硬编码 32B 比对)会误报 true
    const partial = new Uint8Array(64)
    partial.set(Buffer.from("DS_SRV_URL" + "#".repeat(22)), 0) // 恰为 128B 标记的前 32B
    const r = patchLoaderDexKeys(partial, randomBytes(32), randomBytes(32), undefined, false, "https://x.example.com")
    expect(r.patchedUrl).toBe(false)
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
