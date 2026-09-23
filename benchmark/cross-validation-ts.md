# 双引擎对拍实测(GitHub TS 版 vs Rust 版,2026-09-23)

> 目的:为论文"双侧 lockstep、非单实现产物"声明补实测背书。TS 侧用 GitHub 版 `bun src/index.tsx bench` 实跑,Rust 侧数字取自同日 release harness 报告。

## DroidBench ICC/Reflection 专项(66 评分用例)

| 引擎 | TP | FP | FN | 结论 |
|---|---|---|---|---|
| Rust(release harness) | 50 | 0 | 16 | 基线 |
| TS(GitHub 版实跑) | 50 | 0 | 16 | **完全一致** |

## TaintBench(39 app,249 GT 流)

| 引擎 | 流级口径 | 数字 |
|---|---|---|
| Rust | 端点级 171;连通宽松档(类词干对齐)98(57.3%) | 主报告口径 |
| TS | 流级 TP=126(50.6%)(同文件 + target API 语义等价) | **与 Rust 不同源,不可直接比对** |

**差异归因**:两侧流级对判器(adjudicator)语义不同——TS 主判定层为"同文件 + target API 语义等价"(bench-flow.ts:4,行号体系实测 230 端点仅 6 精确),Rust 宽松档为"两端类词干对齐 + 行号参考"。这是 harness 对判层口径差异,非引擎能力差异;app 级评分(39/39 全 TP)两侧一致。

## 声明
- 本对拍仅覆盖 DroidBench 专项(app 级)与 TaintBench(流级,口径差异已声明);benign 子集历史对拍见 benign-fp.md。
- TS 侧未实现 Rust 的连通宽松档对判器,如需数字级一致需先对齐对判层口径(后续工作)。
