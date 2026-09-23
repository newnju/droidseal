// 数据流引擎跨类测试(与 Rust dataflow.rs tests 同口径)
import { describe, test, expect } from "bun:test"
import { analyzeInterproc, analyzeCrossclass, endpoints } from "../src/core/dataflow.ts"

describe("dataflow 跨方法", () => {
  test("参数传播跨方法流", () => {
    const src = `
public void a() {
    String id = tm.getDeviceId();
    store(id);
}

public void store(String s) {
    Log.d(TAG, s);
}
`
    const flows = analyzeInterproc(src)
    expect(flows.length).toBe(1)
    expect(flows[0].src_api).toBe("getDeviceId")
  })

  test("sanitizer 阻断跨方法流", () => {
    const src = `
public void a() {
    String id = tm.getDeviceId();
    store(encrypt(id));
}

public void store(String s) {
    Log.d(TAG, s);
}
`
    expect(analyzeInterproc(src).length).toBe(0)
  })
})

describe("引擎三项新增(与 Rust 同口径)", () => {
  test("框架回调分派:Handler.post 连通 run() 内 sink", () => {
    const src = `
public void onCreate(Bundle b) {
    final String dev = manager.getDeviceId();
    handler.post(new Runnable() {
        public void run() {
            Log.d(TAG, dev);
        }
    });
}
`
    const flows = analyzeInterproc(src)
    expect(flows.length).toBe(1)
    expect(flows[0].source_line).toBe(3)
    expect(flows[0].sink_line).toBe(6)
  })

  test("框架回调:无回调方法存在时不建边", () => {
    const src = `
public void onCreate(Bundle b) {
    final String dev = manager.getDeviceId();
    scheduler.execute(dev.trim());
    Log.d(TAG, dev);
}
`
    const flows = analyzeInterproc(src)
    expect(flows.every(f => !(f.source_line === 3 && f.sink_line === 5))).toBe(true)
  })

  test("接口型回调分派:setOnClickListener 连通 onClick 内 sink(P2-4,与 Rust 同口径)", () => {
    const src = `
public void onCreate(Bundle b) {
    final String dev = tm.getDeviceId();
    btn.setOnClickListener(new View.OnClickListener() {
        public void onClick(View v) {
            Log.d(TAG, dev);
        }
    });
}
`
    const flows = analyzeInterproc(src)
    expect(flows.length).toBe(1)
    expect(flows[0].source_line).toBe(3)
    expect(flows[0].sink_line).toBe(6)
  })

  test("接口型回调:回调方法不存在时不建边(存在性兜底)", () => {
    const src = `
public void onCreate(Bundle b) {
    final String dev = tm.getDeviceId();
    btn.setOnItemSelectedListener(new Adapter() {
        public void nothing() {
            Log.d(TAG, dev);
        }
    });
}
`
    const flows = analyzeInterproc(src)
    expect(flows.every(f => f.sink_line !== 6)).toBe(true)
  })

  test("反射常量方法名:invoke 连通目标方法 sink", () => {
    const src = `
public void go() {
    String dev = manager.getDeviceId();
    Method m = cls.getDeclaredMethod("leak");
    m.invoke(null, dev);
}
public void leak(String s) {
    Log.d(TAG, s);
}
`
    const flows = analyzeInterproc(src)
    expect(flows.length).toBe(1)
    expect(flows[0].source_line).toBe(3)
    expect(flows[0].sink_line).toBe(5)
  })

  test("反射变量方法名:不猜不建边", () => {
    const src = `
public void go(String nm) {
    String dev = manager.getDeviceId();
    Method m = cls.getDeclaredMethod(nm);
    m.invoke(null, dev);
}
public void leak(String s) {
    Log.d(TAG, s);
}
`
    const flows = analyzeInterproc(src)
    expect(flows.every(f => f.sink_line !== 7)).toBe(true)
  })

  test("ICC 常量键:putExtra/getExtra 连通", () => {
    const src = `
public void send() {
    String dev = manager.getDeviceId();
    intent.putExtra("key", dev);
    String out = intent.getStringExtra("key");
    Log.d(TAG, out);
}
public void other() {
}
`
    const flows = analyzeInterproc(src)
    expect(flows.length).toBe(1)
    expect(flows[0].source_line).toBe(3)
    expect(flows[0].sink_line).toBe(6)
  })

  test("ICC 键不匹配:不建流", () => {
    const src = `
public void send() {
    String dev = manager.getDeviceId();
    intent.putExtra("a", dev);
    String out = intent.getStringExtra("b");
    Log.d(TAG, out);
}
public void other() {
}
`
    expect(analyzeInterproc(src).length).toBe(0)
  })
})

describe("dataflow 跨类", () => {
  test("全局唯一方法名跨类连通流", () => {
    const a = `
public void onCreate(Bundle b) {
    Helper.send(tm.getDeviceId());
}
`
    const b = `
public void send(String s) {
    Log.d(TAG, s);
}
`
    const flows = analyzeCrossclass([
      { cls: "A", content: a },
      { cls: "Helper", content: b },
    ])
    expect(flows.length).toBe(1)
    expect(flows[0].src_class).toBe("A")
    expect(flows[0].sink_class).toBe("Helper")
    expect(flows[0].src_class).not.toBe(flows[0].sink_class)
  })

  test("多实现同名方法集合语义分发", () => {
    const a = `
public void go() {
    send(tm.getDeviceId());
}
`
    const b = `
public void send(String s) {
    Log.d(TAG, s);
}
`
    const c = `
public void send(String s) {
    Log.d(TAG, s);
}
`
    const flows = analyzeCrossclass([
      { cls: "A", content: a },
      { cls: "B1", content: b },
      { cls: "B2", content: c },
    ])
    // P2-3 集合语义:两个实现各产一条流(sink_class 分别为 B1/B2)
    expect(flows.length).toBe(2)
    const sinkClasses = new Set(flows.map(f => f.sink_class))
    expect(sinkClasses.has("B1")).toBe(true)
    expect(sinkClasses.has("B2")).toBe(true)
  })
})

describe("endpoints", () => {
  test("枚举 source/sink 行", () => {
    const { srcLines, snkLines } = endpoints(`
public void go() {
    String id = tm.getDeviceId();
    Log.d(TAG, id);
}
`)
    expect(srcLines.length).toBe(1)
    expect(snkLines.length).toBe(1)
  })
})
