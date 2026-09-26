// P1a 单测:JNI 动态注册扫描(RegisterNatives 签名表恢复)
import { describe, test, expect } from "bun:test"
import {
  scanJniDynamicRegistrations,
  crossValidateWithDex,
} from "../src/core/jni-register-scan.ts"

// 模拟 SO 字符串池:JNINativeMethod 表 {name, sig, fnPtr} + FindClass 类路径
// 真实布局:类路径邻近注册表,name 紧邻签名之前(初始化序)
const TABLE = [
  "com/example/pay/SecurePay", // 类路径
  "nativeEncrypt", // 方法名
  "(Ljava/lang/String;)[B", // 签名
  "\u0000\u0000\u0000", // fnPtr(非字符串,占位)
  "com/example/net/HttpClient",
  "doPost",
  "([B)Ljava/lang/String;",
]

describe("scanJniDynamicRegistrations", () => {
  test("识别注册表:name+sig+classPath 邻近共现", () => {
    const eps = scanJniDynamicRegistrations(TABLE)
    expect(eps.length).toBe(2)
    expect(eps[0]!.classDotted).toBe("com.example.pay.SecurePay")
    expect(eps[0]!.method).toBe("nativeEncrypt")
    expect(eps[0]!.signature).toBe("(Ljava/lang/String;)[B")
    expect(eps[1]!.classDotted).toBe("com.example.net.HttpClient")
    expect(eps[1]!.method).toBe("doPost")
  })

  test("无类路径/无方法名的孤立签名不误报", () => {
    const lonely = ["(Ljava/lang/String;)V", "some random text", "com/only/class"]
    expect(scanJniDynamicRegistrations(lonely).length).toBe(0)
  })

  test("去重:同一注册表多次扫描只出一条", () => {
    const eps = scanJniDynamicRegistrations([...TABLE, ...TABLE])
    expect(eps.length).toBe(2)
  })
})

describe("crossValidateWithDex", () => {
  test("宿主类与方法名双命中才保留;未命中如实丢弃", () => {
    const cands = [
      { classPath: "com/example/pay/SecurePay", classDotted: "com.example.pay.SecurePay", method: "nativeEncrypt", signature: "(Ljava/lang/String;)[B" },
      { classPath: "com/ghost/Ghost", classDotted: "com.ghost.Ghost", method: "hidden", signature: "()V" },
    ]
    const dex = ["Lcom/example/pay/SecurePay;", "nativeEncrypt"]
    const kept = crossValidateWithDex(cands, dex)
    expect(kept.length).toBe(1)
    expect(kept[0]!.classDotted).toBe("com.example.pay.SecurePay")
  })
})

describe("签名形态边界", () => {
  test("数组参数与对象返回值;伪签名(无括号/非法类型)不命中", () => {
    const sigs = ["([BII)Lcom/x/Y;", "(Z[J)V"]
    for (const s of sigs) {
      const eps = scanJniDynamicRegistrations(["com/x/Cls", "m", s])
      expect(eps.length).toBe(1)
    }
    // 非法:没有括号
    expect(scanJniDynamicRegistrations(["com/x/Cls", "m", "Ljava/lang/String;"]).length).toBe(0)
  })
})
