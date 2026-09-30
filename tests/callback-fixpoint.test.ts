// P1-b 单测:回调注册不动点(嵌套匿名回调逐层浮现)
import { describe, test, expect } from "bun:test"
import { analyzeCrossclass } from "../src/core/dataflow.ts"

const DUMMY = { cls: "Dummy", content: `class Dummy { public void noop() { } }` }

describe("回调注册不动点(P1-b)", () => {
  test("单层匿名回调(基线,回归确认)", () => {
    const files = [
      {
        cls: "A",
        content: `class A {
          public void onCreate() {
            String d = t.getDeviceId();
            btn.setOnClickListener(new View.OnClickListener() {
              public void onClick(View v) {
                osw.writeUTF(d);
              }
            });
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

  test("嵌套回调(回调体内再注册回调)——不动点展开后命中", () => {
    const files = [
      {
        cls: "B",
        content: `class B {
          public void onCreate() {
            String d = t.getDeviceId();
            btn.setOnClickListener(new View.OnClickListener() {
              public void onClick(View v) {
                menu.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                  public void onItemSelected(AdapterView p, View view, int pos, long id) {
                    osw.writeUTF(d);
                  }
                });
              }
            });
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

  test("三层嵌套——上限 8 轮内收敛", () => {
    const files = [
      {
        cls: "C",
        content: `class C {
          public void onCreate() {
            String d = t.getDeviceId();
            a.setOnClickListener(new X() {
              public void onClick(View v) {
                b.setOnLongClickListener(new Y() {
                  public void onLongClick(View v) {
                    c.setOnCheckedChangeListener(new Z() {
                      public void onCheckedChanged(Object g, boolean s) {
                        osw.writeUTF(d);
                      }
                    });
                  }
                });
              }
            });
          }
        }`,
      },
      DUMMY,
    ]
    const flows = analyzeCrossclass(files)
    expect(flows.length).toBe(1)
    expect(flows[0]!.sink_api).toBe("writeUTF")
  })
})
