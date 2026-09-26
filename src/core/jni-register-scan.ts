// P1a: JNI 动态注册解析(RegisterNatives 端点恢复)。
// 背景:动态注册的 native 方法在 DEX 侧只有 `native` 修饰声明,没有
// Java_包名_类名_方法名 静态导出符号——静态符号扫描扫不到,端点召回缺口 ~25%。
// 原理:JNINativeMethod 三元组 {name, signature, fnPtr} 的前两项是 C 字符串,
// 注册时(通常 JNI_OnLoad)必然以明文落在 SO 的 .rodata:
//   - 类路径形态:com/foo/Bar(含 '/',无 ';',非 URL)
//   - 签名形态:(...)... 括号开头
// 同一 .rodata 邻近区域出现 "类路径 + 签名" 对,且类路径能在 DEX 字符串池
// (Lcom/foo/Bar;)交叉验证命中 → 判定为动态注册端点。
// 如实边界:fnPtr 是二进制偏移无法从字符串池恢复,本模块只恢复
// "类.方法(签名)" 清单,不给行号/实现地址;交叉验证不命中(宿主类不在 DEX)
// 的候选如实丢弃(可能是宿主 SO 自身的辅助类,不报避免噪音)。

export interface JniDynamicEndpoint {
  /** 内部类路径形式:com/foo/Bar */
  classPath: string
  /** 点分形式:com.foo.Bar */
  classDotted: string
  method: string
  signature: string
}

const CLASS_PATH_RE = /^[a-zA-Z_$][a-zA-Z0-9_$]*(?:\/[a-zA-Z_$][a-zA-Z0-9_$]*){1,8}$/
const JNI_SIG_RE = /^\((?:\[?[ZBCSIJFDL][\w$/;[\]]*)*\)[A-Z\[\[]?[\w/$;[\]]*$/
const METHOD_NAME_RE = /^[a-zA-Z_$][a-zA-Z0-9_$]{0,63}$/

/** 从 SO 字符串池扫描动态注册候选(方法名+签名对 + 邻近类路径) */
export function scanJniDynamicRegistrations(soStrings: Iterable<string>): JniDynamicEndpoint[] {
  const arr = [...soStrings]
  const out: JniDynamicEndpoint[] = []
  const seen = new Set<string>()
  const isMethodName = (s: string): boolean => METHOD_NAME_RE.test(s) && !s.startsWith("(")
  for (let si = 0; si < arr.length; si += 1) {
    const sig = arr[si]!
    if (!sig.startsWith("(") || !JNI_SIG_RE.test(sig)) continue
    // 方法名:签名紧邻前(JNINativeMethod {name, sig, fnPtr} 初始化序,name 在前),回退紧邻后
    const before = si >= 1 ? arr[si - 1]! : ""
    const after = si + 1 < arr.length ? arr[si + 1]! : ""
    const name = isMethodName(before) ? before : isMethodName(after) ? after : undefined
    if (!name) continue
    // 宿主类:方法名锚点向前 4 格内最近的类路径形态(FindClass 字符串邻近注册表落盘)
    const anchor = isMethodName(before) ? si - 1 : si + 1
    let classPath: string | undefined
    for (let back = anchor - 1; back >= Math.max(0, anchor - 4); back -= 1) {
      if (CLASS_PATH_RE.test(arr[back]!)) { classPath = arr[back]!; break }
    }
    if (!classPath) continue
    const key = `${classPath}->${name}${sig}`
    if (seen.has(key)) continue
    seen.add(key)
    out.push({ classPath, classDotted: classPath.replaceAll("/", "."), method: name, signature: sig })
  }
  return out
}

/**
 * 交叉验证:仅保留宿主类与方法名都在 DEX 字符串池存在的候选
 * (native 方法在 DEX 有声明,类名 L<class>; 与方法名必在池中;双命中才可信)。
 * 未命中者如实丢弃(可能是壳/宿主 SO 自身辅助类,报了是噪音)。
 */
export function crossValidateWithDex(
  candidates: JniDynamicEndpoint[],
  dexStrings: Iterable<string>,
): JniDynamicEndpoint[] {
  const dexSet = new Set(dexStrings)
  return candidates.filter((c) => dexSet.has(`L${c.classPath};`) && dexSet.has(c.method))
}
