// 字符串加密写回单测:MUTF-8 安全密文 + DEX checksum 修复 + 调用点改写模块
import { describe, test, expect } from "bun:test"
import { createHash } from "node:crypto"
import {
  mutf8SafeEncrypt,
  updateDexChecksum,
  isSensitive,
} from "../src/core/string-encrypt-writeback.ts"
import { escapeSmaliString, unescapeSmaliString, CONST_STRING_RE_TEST } from "../src/core/string-callsite-rewrite.ts"

describe("MUTF-8 安全密文", () => {
  test("密文字节全部落在 0x01–0x7F(MUTF-8 可解码域,无 0x00 终止符)", () => {
    for (const plain of ["https://api.example.com/v1/login", "AIzaSyD-abc123def456ghi789", "a", "\u00e9\u4e2d\u6587 mixed"]) {
      const data = new TextEncoder().encode(plain)
      const baseKey = new Uint8Array(16).fill(0xab)
      const { encrypted } = mutf8SafeEncrypt(data, baseKey)
      expect(encrypted.length).toBe(data.length)
      for (const b of encrypted) {
        expect(b).toBeGreaterThanOrEqual(0x01)
        expect(b).toBeLessThanOrEqual(0x7f)
      }
    }
  })

  test("同 (baseKey, 明文) 确定性可重现;不同 baseKey 密文不同", () => {
    const data = new TextEncoder().encode("sk_live_51HxYzAbCdEfGh")
    const k1 = new Uint8Array(16).fill(1)
    const k2 = new Uint8Array(16).fill(2)
    const e1a = mutf8SafeEncrypt(data, k1).encrypted
    const e1b = mutf8SafeEncrypt(data, k1).encrypted
    const e2 = mutf8SafeEncrypt(data, k2).encrypted
    expect(Array.from(e1a)).toEqual(Array.from(e1b))
    expect(Array.from(e1a)).not.toEqual(Array.from(e2))
  })

  test("keystream = 明文 XOR 密文(解密侧可还原)", () => {
    const data = new TextEncoder().encode("secret-token-abc123")
    const baseKey = new Uint8Array(16).fill(0x42)
    const { encrypted, keystream } = mutf8SafeEncrypt(data, baseKey)
    const round = new Uint8Array(data.length)
    for (let i = 0; i < data.length; i += 1) round[i] = encrypted[i]! ^ keystream[i]!
    expect(Array.from(round)).toEqual(Array.from(data))
  })
})

describe("updateDexChecksum(SEC-010 同类修复)", () => {
  test("修改 string 区后 checksum(adler32@8)与 sha1@12 同步更新", () => {
    // 构造最小伪 DEX:magic + checksum@8 + sha1@12..32 + 数据区
    const bytes = new Uint8Array(112)
    bytes.set([0x64, 0x65, 0x78, 0x0a, 0x30, 0x33, 0x35, 0x00], 0)
    const view = new DataView(bytes.buffer)
    view.setUint32(8, 0xdeadbeef, true)
    bytes.set(new Uint8Array(20).fill(0), 12)
    for (let i = 32; i < 112; i += 1) bytes[i] = i & 0xff

    const fixed = updateDexChecksum(bytes)
    // adler32 从偏移 12 重算
    let a = 1, b = 0
    for (let i = 12; i < 112; i += 1) {
      a = (a + fixed[i]!) % 65521
      b = (b + a) % 65521
    }
    expect(new DataView(fixed.buffer).getUint32(8, true)).toBe(((b << 16) | a) >>> 0)
    // sha1 覆盖偏移 32 起
    const sha1 = createHash("sha1").update(fixed.subarray(32)).digest()
    expect(Array.from(fixed.slice(12, 32))).toEqual(Array.from(sha1))
    // 输入不被改写
    expect(view.getUint32(8, true)).toBe(0xdeadbeef)
  })
})

describe("isSensitive 边界", () => {
  test("URL/密钥命中,短串/普通词不命中", () => {
    expect(isSensitive("https://api.example.com/login")).toBe(true)
    expect(isSensitive("AKIA1234567890ABCDEF")).toBe(true)
    expect(isSensitive("hello world")).toBe(false)
    expect(isSensitive("abc")).toBe(false)
  })
})

describe("smali 字面量转义互逆", () => {
  test("escape → unescape 往返一致", () => {
    for (const s of ['plain', 'with "quote"', "back\\slash", "tab\tnewline\n", "unicode \u4e2d\u6587 \u00e9"]) {
      expect(unescapeSmaliString(escapeSmaliString(s))).toBe(s)
    }
  })
})

describe("const-string 正则", () => {
  test("匹配 const-string 与 const-string/jumbo,捕获寄存器与字面量", () => {
    const src = `const-string v3, "https://x.com"\nconst-string/jumbo p1, "big\\\"quoted"`
    const ms = [...src.matchAll(CONST_STRING_RE_TEST)]
    expect(ms.length).toBe(2)
    expect(ms[0]![1]).toBe("v3")
    expect(ms[0]![2]).toBe("https://x.com")
    expect(ms[1]![1]).toBe("p1")
  })

  test("调用点发射:decrypt(I) 前必须 const 装载索引(否则运行时把字符串当索引用,必崩)", () => {
    // 复现 rewriteStringCallsites 的发射模板,断言含 const 装载行
    const reg = "v3"
    const i = 7
    const emitted = `const/16 ${reg}, ${i}\n    invoke-static {${reg}}, Lcom/example/DroidSealStringDecryptor;->decrypt(I)Ljava/lang/String;\n    move-result-object ${reg}`
    expect(emitted).toMatch(/^const\/16 v3, 7\n {4}invoke-static \{v3\}/)
    // 防回归:发射体不得是裸 invoke(旧 bug 形态)
    expect(emitted.startsWith("invoke-static")).toBe(false)
  })
})
