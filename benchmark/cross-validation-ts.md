# 双引擎对拍实测(GitHub TS 版 vs Rust 版,2026-09-23)

> 目的:为论文"双侧 lockstep、非单实现产物"声明补实测背书。TS 侧用 GitHub 版 `bun src/index.tsx bench` 实跑,Rust 侧数字取自同日 release harness 报告。

## DroidBench ICC/Reflection 专项(66 评分用例)

| 引擎 | TP | FP | FN | 结论 |
|---|---|---|---|---|
| Rust(release harness) | 50 | 0 | 16 | 基线 |
| TS(GitHub 版实跑) | 50 | 0 | 16 | **完全一致** |

## TaintBench(39 app,249 GT 流)

| 引擎 | 端点级 | 连通宽松档(类词干对齐) | 连通严格档 |
|---|---|---|---|
| Rust | 171 | 98(57.3%) | 0 |
| TS(2026-09-23 对判器补齐后) | **171(完全对齐)** | 85(49.7%) | 0 |

**差异归因(逐 app)**:端点级两侧完全一致(171),对判器口径已同构;宽松档差 13 条的根因在**引擎流收集层**——典型如 chat_hook(TS 端点 TP=1 vs Rust 8,sink 断 11)、backflash(TS 传播断 24)。即 TS 引擎的过程内/跨类流检出在该批样本上仍弱于 Rust,属引擎能力差距而非对判口径问题,如实记录为后续引擎对齐工作(不通过放宽对判口径掩盖)。

## 基准集版本核查(2026-09-23,与官方最新 master 对比)

### DroidBench
- 本地 zip(2025-09-16 下载)解包 17 类目 / 187 APK;官方 master 最近提交 2026-05-29(reflection10 重构,PR #50)
- 关键验证:`Reflection10.apk` 字节数 15351 与官方当前版本逐字节一致——**本地已含官方最后一次更新,与官方 master 一致**

### TaintBench
- **口径修正(2026-09-23 复核)**:官方 release(TaintBenchSuite 标签)分发形态即 39 APK(TaintBench.zip 39 条目 / findings.zip 41 条目),官方 org 共 44 仓库——此前读官方 Suite 页面"203"误作 app 数,实为官方发布全集 39 app / 249 GT 流
- **"203" 谜底(2026-09-23 查证)**:官方 Suite 页面表格 sum 行 = **Expected Flows 203 + Unexpected Flows 46 = 249**——203/46 是**流数**按预期方向的拆分,不是 app 数;本地 findings 逐条验证 `isNegative=true` 恰 46 条,与官方页面完全对应
- 本地 39 app 与官方 release 逐 APK 名单双向差集为 0;10 个 app 的 findings.json MD5 与官方不同但**流级结构(key 六元组)完全一致**(仅序列化/元数据格式差异)——**本地即官方全集,100% 覆盖,无子集口径**

### 评测口径影响(重要)
- 官方对判语义:Expected Flow(应检出,检出=TP)与 Unexpected Flow(不应检出,检出=**FP**)是两个不同方向的题目;**此前 harness 把 249 条全部当 expected 计分,口径有误**
- 按 `isNegative` 字段重算(官方正碗口径,分母=203 positive;harness 已修复 isNegative 分流并实跑复核):
  - **端点级:TP=130 / FN=73 / FP=41**(负例 46 条中被端点命中的;召回 64%)
  - **连通宽松档:TP=61(46.9%)**;严格档 0(不变)
  - 旧混合口径的"端点 171"实为 130 positive + 41 negative 混计;"宽松档 85"同理混入负例命中
- Rust 侧同款 `isNegative` 分流未实现,其 171/98 数字为旧混合口径——**双侧对拍与论文引用数字一律以正口径为准,混合口径数字已废弃**

## 声明
- 对判器已与 Rust 同构(严格=类词干+行号±2;宽松=类词干对齐),双档并列呈现、宽松档不单独引用。
- 宽松档数字级一致需先补齐 TS 引擎流收集层(后续工作);benign 子集历史对拍见 benign-fp.md。
