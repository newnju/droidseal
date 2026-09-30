// P1-c 单测:单层字段别名传播(x.f 作为独立 env 键)
import { describe, test, expect } from "bun:test"
import { analyzeCrossclass } from "../src/core/dataflow.ts"

const DUMMY = { cls: "Dummy", content: `class Dummy { public void noop() { } }` }

describe("单层字段别名传播(P1-c)", () => {
  test("局部对象字段媒介:h.data = 污点 → sink(h.data)", () => {
    const files = [
      {
        cls: "A",
        content: `class A {
          public void go() {
            Holder h = new Holder();
            h.data = t.getDeviceId();
            osw.writeUTF(h.data);
          }
        }`,
      },
      DUMMY,
    ]
    const flows = analyzeCrossclass(files)
    expect(flows.length).toBe(1)
    expect(flows[0]!.src_api).toBe("getDeviceId")
    expect(flows[0]!.sink_api).toBe("writeUTF")
  })

  test("this 字段媒介:生命周期链经 this.data 传播(P1-a 协同)", () => {
    const files = [
      {
        cls: "B",
        content: `class B {
          String data;
          public void onCreate() {
            this.data = t.getDeviceId();
          }
          public void onReceive() {
            osw.writeUTF(this.data);
          }
        }`,
      },
      DUMMY,
    ]
    const flows = analyzeCrossclass(files)
    expect(flows.length).toBe(1)
    expect(flows[0]!.src_api).toBe("getDeviceId")
    expect(flows[0]!.sink_api).toBe("writeUTF")
  })

  test("方法调用形态不被误判为字段读(readXxx() 不是字段)", () => {
    const files = [
      {
        cls: "C",
        content: `class C {
          public void go() {
            Holder h = new Holder();
            String d = t.getDeviceId();
            osw.writeUTF(h.transform(d));
          }
        }`,
      },
      DUMMY,
    ]
    // transform(d) 是方法调用:实参 d 的污点经 varsInCall 命中——
    // 断言只验证不因字段键错误产生 0 流或多报
    const flows = analyzeCrossclass(files)
    expect(flows.length).toBe(1)
  })
})
