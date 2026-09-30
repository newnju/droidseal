// IB 语句锚定层单测:锚定语义(语句逐字定位→同源行号→锚定档判定)不依赖真库即可验证。
import { describe, expect, test } from "bun:test"
import { anchorPoint, matchesAnchored, parseFindings } from "../src/core/bench-flow.ts"

// 合成 app:两个类,GT 语句文本与引擎行号"同源"(语句在文件中的真实行号即锚定行号)
const CLS_A = `package com.example;

public class Auth {
    public String readSms() {
        String body = getSmsBody();      // line 5: source
        return body;
    }

    public void leak(String data) {
        sendTextMessage("133", null, data, null, null);   // line 10: sink
    }
}
`
const CLS_B = `package com.example;

public class Worker {
    public void run() {
        String d = new Auth().readSms();             // line 5
        System.out.println(d);                        // line 6
    }
}
`

// GT findings:语句取自文件真实内容(含 GT 常见的多空格变体,锚定层应空白归一后命中)
const gtJson = JSON.stringify({
  findings: [{
    source: {
      statement: 'String body = getSmsBody();      // line 5: source',
      methodName: "public String readSms()",
      className: "com.example.Auth",
      lineNo: 999, // 故意错:GT lineNo 不同源——锚定层应靠语句而非行号
      targetName: "getSmsBody",
    },
    sink: {
      statement: 'sendTextMessage("133", null, data, null, null);   // line 10: sink',
      methodName: "public void leak(String data)",
      className: "com.example.Auth",
      lineNo: 12345,
      targetName: "sendTextMessage",
    },
  }],
})

// 锚定文本索引(与 classAnchoredTexts 同构;单测直接构造,绕过文件系统)
function buildAnchored(text: string) {
  const chars: string[] = []
  const lineOf: number[] = []
  let line = 1
  let prevSpace = true
  for (const ch of text) {
    if (ch === "\n") { line += 1; prevSpace = true; continue }
    if (ch === " " || ch === "\t" || ch === "\r") {
      if (prevSpace) continue
      chars.push(" "); lineOf.push(line); prevSpace = true
      continue
    }
    chars.push(ch); lineOf.push(line); prevSpace = false
  }
  return { norm: chars.join(""), lineOf }
}

describe("IB 语句锚定层", () => {
  const anchored = new Map<string, ReturnType<typeof buildAnchored>>([
    ["com.example.Auth", buildAnchored(CLS_A)],
    ["com.example.Worker", buildAnchored(CLS_B)],
  ])

  test("GT 语句逐字定位→同源行号(GT lineNo 错误不影响)", () => {
    const flows = parseFindings(gtJson)
    expect(flows.length).toBe(1)
    const src = anchorPoint(flows[0]!.source, anchored)
    const snk = anchorPoint(flows[0]!.sink, anchored)
    expect(src).toEqual({ stem: "Auth", line: 5 })
    expect(snk).toEqual({ stem: "Auth", line: 10 })
  })

  test("语句未命中/类缺失/过短语句如实返回 undefined(不猜)", () => {
    const flows = parseFindings(gtJson)
    expect(anchorPoint({ ...flows[0]!.source, statement: "definitely not in the file at all" }, anchored)).toBeUndefined()
    expect(anchorPoint({ ...flows[0]!.source, class: "com.example.Missing" }, anchored)).toBeUndefined()
    expect(anchorPoint({ ...flows[0]!.source, statement: "short" }, anchored)).toBeUndefined()
  })

  test("匿名/内部类 className 逐段剥尾并入外部类文件", () => {
    const flows = parseFindings(gtJson)
    const inner = { ...flows[0]!.source, class: "com.example.Auth$1" }
    expect(anchorPoint(inner, anchored)).toEqual({ stem: "Auth", line: 5 })
    const anon = { ...flows[0]!.source, class: "com.example.Auth.AnonymousClass3" }
    expect(anchorPoint(anon, anchored)).toEqual({ stem: "Auth", line: 5 })
  })

  test("matchesAnchored:同源行号 ±2 命中、换向命中、行号漂移>2/类不齐不命中", () => {
    const ef = { sourceClass: "Auth", sinkClass: "Auth", sourceLine: 5, sinkLine: 10 }
    expect(matchesAnchored(ef, { stem: "Auth", line: 5 }, { stem: "Auth", line: 10 })).toBe(true)   // 精确
    expect(matchesAnchored(ef, { stem: "Auth", line: 7 }, { stem: "Auth", line: 8 })).toBe(true)    // 双端 ±2 内
    expect(matchesAnchored(ef, { stem: "Auth", line: 10 }, { stem: "Auth", line: 5 })).toBe(true)   // source/sink 换向
    expect(matchesAnchored(ef, { stem: "Auth", line: 9 }, { stem: "Auth", line: 30 })).toBe(false)  // sink 漂移>2
    expect(matchesAnchored({ ...ef, sinkClass: "Other" }, { stem: "Auth", line: 5 }, { stem: "Auth", line: 10 })).toBe(false) // 类词干不齐
  })
})
