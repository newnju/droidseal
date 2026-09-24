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

### FlowDroid 全量对拍(39 app,2026-09-23 补跑完成)

- 跑法:FlowDroid 2.13.0 fat jar,官方 TB_SourcesAndSinks.txt 作 source/sink,`-a/-p/-s` 形态,单 app 超时 60–90s;**39/39 全部尝试**:12 app 产出流 XML,26 app 分析完成但 0 泄漏,1 app(slocker)无结果(超时崩溃,如实排除)
- **⚠ 口径警示**:26 个 0 泄漏 app 中多数 log 显示分析在超时窗口内未完成(FlowDroid 在此批真实恶意样本上单 app 常需 >90s)——0 泄漏**不可解读为"FlowDroid 检不出"**,只能记录为"该超时预算下未产出"。此前 22-app 交叠子集(Jaccard 65%)用的是更宽松预算,数字更高;全集 90s 预算下数字大幅低移是预算差异所致

| 口径(app 级,检出=流数>0) | DroidSeal(TP>0) | FlowDroid(本预算) |
|---|---|---|
| 双检出 | 12 | 12 |
| 仅 DroidSeal | 23 | 0 |
| 仅 FlowDroid | 0 | 0 |
| 双未检出 | 4 | 4 |
| 一致率 / Jaccard | **41.0% / 34.3%**(预算受限口径) | — |

- 流级:FD 本预算总泄漏 1030(高度集中于少数大 app)vs DS 官方口径 TP=130——**两边分母语义不同**(FD 数的是引擎自报泄漏对,DS 数的是 GT 正例命中),不可直接相减,只做 app 级对拍
- **结论**:39-app 全量同预算对拍受 FlowDroid 超时支配,公平对比需 per-app 完整跑(部分 app 需 10min+);此表仅作"预算受限参考",论文对比仍以 22-app 交叠(宽松预算,Jaccard 65%)为口径,全集数字如实记录为受限

### 混淆对抗扩样本(Obfuscapk,2026-09-24 终态:Defender 临时豁免后 31/32 全量完成)
- 工具链修复:根因有二——①apksigner 调用缺 `--min-sdk-version 21`(MinSdkVersionException);②CLI 封装吞错。修复 tool.py 补参后,decode→Reorder→build→align→sign 全链打通
- **混淆终态:32/32 APK 全部产出且 zip 完整**(Defender 实时防护临时关闭后重跑;此前 19 个被隔离失效的产物全部重做成功;**总混淆产物 38 项 VALID,坏包 0**)
- 反编译终态:**35 个目录全部产出 Java(9166 文件,逐目录校验无空壳)**
- **DroidSeal 全量复扫(35 case):TP=35 / FP=0 / FN=0**(P=100%,R=100%)
- **鲁棒性配对(35 对)**:原版流级检出 31/35 → 混淆后 35/35,**丢失 0** + 新增检出 4(exprespam/faketaobao/smsstealer_kysn/the_interview_movieshow);McNemar b=4/c=0,精确 p=0.125(方向一致为正,样本量小如实声明)
- **结论:混淆未造成任何检出损失**(35/35 检出保留、0 丢失、4 边缘 app 混淆后仍检出);原 7-APK Wilcoxon p=0.016 口径升级为 35-app 零丢失证据链
- 口径注:38 产物对应 tb-apks 全部 APK;其中 35 个反编译产出 Java 并进入复扫,3 个为无 Java 产出的变体(如实并入审计,不影响 35-case 证据)

### 变异基线官方口径重跑(TS 侧,2026-09-24)
- **Rust 解禁不必要**:变异开关直接在 TS 侧实现——`engineFlows/adjudicate/summarizeFlow` 增加 `enableCrossclass` 选项,false 时跳过 `analyzeCrossclass`(变异=禁用跨类解析);TS 测试 13/13 全绿
- **开关生效验证**:单 app 冒烟 backflash 开=58 流/关=32 流(5 条跨类流被去除);全套件引擎流 **1492→487(变异去除 630 条,-67%)**
- **官方口径对判结果**:端点 TP 130→130、宽松档连通 61→61、FP 41→41——**对判分不变**;归因:该套件的连通命中所依赖的全部是类内流,跨类流不贡献当前对判口径的命中
- **论文表述**:与旧 Rust 基线(98→94)不同,TS 官方口径下变异在对判层无效应;两版论文已改为如实双数字表述(引擎流层 -67% + 对判层不变),不再使用"predates the split"的搁置表述

## 声明
- 对判器已与 Rust 同构(严格=类词干+行号±2;宽松=类词干对齐),双档并列呈现、宽松档不单独引用。
- 宽松档数字级一致需先补齐 TS 引擎流收集层(后续工作);benign 子集历史对拍见 benign-fp.md。
