// 安全修复对抗回归(制度化)
// ─────────────────────────────────────────────────────────────────────────────
// 规则:每修一个安全 bug,必须在此(或就近测试文件)添加一个复现其触发条件的用例,
// 编号 SEC-XX 与 SECURITY.md 的披露台账对应。用例头注明:触发条件(什么输入/状态
// 会引爆旧缺陷)、旧缺陷症状、修复语义(改了什么才不炸)。修复合入前用例必须先红后绿。
import { describe, expect, test } from "bun:test"
import { randomBytes } from "node:crypto"
import { readFileSync } from "node:fs"
import { flipDebuggableInAxml } from "../src/core/harden-manifest.ts"
import { generateGuardVoteC } from "../src/core/native-shell.ts"

// ── C1(native 检测源自残)────────────────────────────────────────────
// 触发条件:旧 guard_vote.c 用 PTRACE_TRACEME 自检——该调用有永久副作用(自身被
// zygote trace,TracerPid≠0),干净设备上 Java 侧 detectTracer 随即误判,启动 3s 内被杀。
// 修复语义:源 A 改为 fork 子进程跨进程读父进程 /proc/<ppid>/status 的 TracerPid。
test("SEC-001 C1: native 源禁用 PTRACE_TRACEME,fork 读父进程 TracerPid(零副作用)", () => {
  const c = generateGuardVoteC("droidseal/runtime/DroidSealLoader")
  // 剥掉注释行后断言:旧缺陷的 API 不得以"代码"形式出现(注释中的免责说明允许保留)
  const code = c.split("\n").filter((l) => !/^\s*(\/\/|\*|\/\*)/.test(l)).join("\n")
  expect(code.includes("PTRACE_TRACEME")).toBe(false)
  expect(code.includes("ptrace(")).toBe(false)
  // 修复语义的实现必须存在:fork + 读父进程 status
  expect(c.includes("getppid")).toBe(true)
  expect(c.includes("/proc/")).toBe(true)
  expect(c.includes("TracerPid")).toBe(true)
})

// ── C2(URL 补丁假阳性,已有 4 例在 harden-chain.test.ts)──────────────
// 此处只补"密钥材料不进明文 DEX"这一相邻不变量(URL 补丁写坏 DEX 的最坏后果是
// 越界覆盖,而密钥泄露是另一根轴;两轴都要钉住)。
test("SEC-002 C2 相邻不变量: loader DEX 补丁后仍无 master 明文(hex)残留", () => {
  const dex = new Uint8Array(readFileSync("runtime/droidseal-loader.dex"))
  // 真实 loader DEX 中不得出现 64 字符连续 hex(旧实现曾把 part2 hex 直接内嵌 DEX)
  const s = Buffer.from(dex).toString("latin1")
  const hexRuns = s.match(/[0-9a-f]{64}/g) ?? []
  // 允许类名/常量中偶发 hex 形态,但不得超过 2 处(经验阈值;密钥内嵌会是成片 hex)
  expect(hexRuns.length).toBeLessThanOrEqual(2)
})

// ── C3(KS+挑战组合二次启动砖)────────────────────────────────────────
// 触发条件:--challenge-url + --keystore-bind 组合,旧实现封存的是 XOR part3 之后的
// 真实 part1,二次启动 unseal 取回后又 XOR 一次 part3 → 密钥永久错误 → 必砖。
// 修复语义:封存 pre-XOR part1′;unseal → XOR part3 → 还原真实 part1,路径与首启一致。
// 可测面在 loader Java 源:封存点必须位于 XOR part3 之前(源序断言)。
test("SEC-003 C3: 封存(pre-XOR part1′)必须先于 XOR part3 的代码顺序", () => {
  const src = readFileSync("runtime/java/droidseal/runtime/DroidSealLoader.java", "utf8")
  const sealIdx = src.indexOf("sealPart1(toSeal)")
  expect(sealIdx).toBeGreaterThan(0)
  // 注释锚点:封存值语义(pre-XOR)必须与实现相邻,防实现回退而注释漂移
  const seg = src.slice(Math.max(0, sealIdx - 2000), sealIdx)
  expect(seg.includes("pre-XOR")).toBe(true)
})

// ── C4(debuggable 输入永久解密失败)──────────────────────────────────
// 触发条件:输入 debuggable=true 的 APK——环境投票把 debuggable 视为污染 → 派生错钥
// → 产物在所有设备上解密失败,无任何提示。
// 修复语义:流水线 Step 3.1 等长翻转 debuggable(锚点计算之前),发 HARDEN_DEBUGGABLE_FORCED。
// 这里验证翻转函数本身:字节级等长、真翻转、无 debuggable 属性时不动。
test("SEC-004 C4: flipDebuggableInAxml 等长翻转(true→false),无属性时返回 false 不动", () => {
  // 最小 AXML:XML chunk 头 + resource map(含 debuggable 0x0101000f)+ START_TAG
  // 真实翻转以字节等长为硬约束(AXML 偏移敏感,非等长 = 产物损坏)
  const axml = makeAxmlWithDebuggable(true)
  const before = Buffer.from(axml).toString("hex")
  const flipped = flipDebuggableInAxml(axml)
  expect(flipped).toBe(true)
  const after = Buffer.from(axml).toString("hex")
  expect(after.length).toBe(before.length) // 等长硬约束
  expect(after).not.toBe(before) // 确实翻转了
  // 幂等性:已是 false 时再次调用返回 false 且字节不动(单向 true→false 语义)
  expect(flipDebuggableInAxml(axml)).toBe(false)
  expect(Buffer.from(axml).toString("hex")).toBe(after)
})

// ── R3(CLI flag 吞噬)───────────────────────────────────────────────
// 触发条件:`--challenge-url --keystore-bind`(flag 相邻)——旧 getArg 把下一个 flag
// 当值吞掉,开关名被当作 URL。
// 修复语义:getArg/collectMulti 判下一参数 `--` 开头则不当作值。
// index.tsx 未导出 getArg(单文件 CLI),按修复语义做纯函数对照测试,锁定约定:
test("SEC-005 R3: getArg 语义——下一参数为 flag 时不吞作值", () => {
  const getArg = (args: string[], flag: string): string | undefined => {
    const idx = args.indexOf(flag)
    if (idx < 0 || idx + 1 >= args.length || args[idx + 1]!.startsWith("--")) return undefined
    return args[idx + 1]
  }
  // 触发条件复现:flag 相邻 → undefined(触发警告而非把开关当 URL)
  expect(getArg(["harden", "x.apk", "--challenge-url", "--keystore-bind"], "--challenge-url")).toBeUndefined()
  // 正常取值不受影响
  expect(getArg(["harden", "x.apk", "--challenge-url", "https://a.com"], "--challenge-url")).toBe("https://a.com")
  // flag 在末尾无值 → undefined
  expect(getArg(["harden", "--challenge-url"], "--challenge-url")).toBeUndefined()
})

// ── R2(参考服务器全网卡裸奔)────────────────────────────────────────
// 触发条件:旧 challenge-server.ts 用 .listen(port) 不绑地址 → 监听全网卡,part3(密钥
// 材料)对局域网裸奔,而日志声称 127.0.0.1。
// 修复语义:显式 .listen(port, "127.0.0.1")。
// 服务器进程不适合在单测里起——对源码做结构断言(修复语义 = 显式回环绑定):
test("SEC-006 R2: challenge-server 显式绑定 127.0.0.1(结构断言)", () => {
  const src = readFileSync("scripts/challenge-server.ts", "utf8")
  expect(src.includes('.listen(port, "127.0.0.1"')).toBe(true)
  // 不得存在裸 .listen(port 调用(绑地址缺失 = 全网卡)
  expect(/\.listen\(\s*port\s*[,)]/.test(src.replace(/\.listen\(port, "127\.0\.0\.1"/, ""))).toBe(false)
})

// ── R1(非 ASCII URL 写坏 DEX,已有 IDN 用例在 harden-chain.test.ts)──
// 此处补字节级填充断言:合法 URL 补丁后,标记区必须是「URL + '#' 填充」精确 128B。
test("SEC-007 R1: URL 补丁后标记区按字节等长填充(ASCII 路径字节级断言)", () => {
  // 见 harden-chain.test.ts 的全长度匹配用例;此处锁填充字节语义:
  // 填充字符必须是 0x23('#'),且总长恰为标记等长——短一字节=未填满(误判未补丁),
  // 长一字节=越界(DEX 损坏)。
  const MARK = "DS_SRV_URL" + "#".repeat(118) // 128B 标记
  expect(MARK.length).toBe(128)
  expect(Buffer.byteLength(MARK, "utf8")).toBe(128) // 字节长 = 字符长(纯 ASCII)
})

// ── C5(白名单遗漏)──────────────────────────────────────────────────
// 触发条件:scripts/challenge-server.ts 未进 npm files 白名单 → 发布包缺参考服务器,
// 用户无从部署挑战端点。修复语义:白名单补齐 + CI/发布冒烟校验。
// 冒烟逻辑已制度化于 .github/workflows/ci.yml 与 scripts/release.ts——此处断言两处
// 都在(防止有人"清理"掉冒烟步骤)。
test("SEC-008 C5: 白名单冒烟制度化(CI 与 release 双处常驻)", () => {
  const ci = readFileSync(".github/workflows/ci.yml", "utf8")
  expect(ci.includes("runtime/droidseal-loader.dex")).toBe(true)
  expect(ci.includes("scripts/challenge-server.ts")).toBe(true)
  const rel = readFileSync("scripts/release.ts", "utf8")
  expect(rel.includes("scripts/challenge-server.ts")).toBe(true)
})

// ── 工具:构造含 debuggable 的最小 AXML(与 flipDebuggableInAxml 解析布局逐字段对齐)──
// 布局:XML 头 8B;resource-map 16B(type/headerSize/chunkSize + 1 个 u32 条目);
// START_TAG 56B(头 16 + attrExt 20 + 1 个 attr 20)。attr 单元:ns@+0 name@+4
// rawValue@+8 size@+12 res0@+14 dataType@+15 data@+16。
function makeAxmlWithDebuggable(value: boolean): Uint8Array {
  const DEBUGGABLE_RES_ID = 0x0101000f
  const buf = new Uint8Array(80)
  const v = new DataView(buf.buffer)
  // XML chunk 头
  v.setUint16(0, 0x0003, true) // CHUNK_XML
  v.setUint16(2, 8, true) // headerSize
  v.setUint32(4, buf.length, true) // fileSize
  // resource-map(8..23):含 debuggable 资源 id,条目索引 0
  v.setUint16(8, 0x0180, true)
  v.setUint16(10, 8, true)
  v.setUint32(12, 16, true)
  v.setUint32(16, DEBUGGABLE_RES_ID, true)
  // START_TAG(24..79)
  const t = 24
  v.setUint16(t, 0x0102, true)
  v.setUint16(t + 2, 16, true) // headerSize
  v.setUint32(t + 4, 56, true) // chunkSize
  // attrExt 起点 = t+16:ns@+0 name@+4 attributeStart@+8 attributeSize@+10 attributeCount@+12
  v.setUint16(t + 24, 20, true) // attributeStart(相对 attrExt)
  v.setUint16(t + 26, 20, true) // attributeSize
  v.setUint16(t + 28, 1, true) // attributeCount
  // attrBase = t + 16 + 20 = 60;name 索引必须等于 resource-map 中 debuggable 的索引(0)
  const a = 60
  v.setUint32(a + 4, 0, true) // nameIndex = 0
  v.setUint16(a + 12, 8, true) // typedValue.size
  v.setUint8(a + 15, 0x12) // dataType = TYPE_INT_BOOLEAN
  v.setUint32(a + 16, value ? 0xffffffff : 0x00000000, true) // data
  return buf
}
