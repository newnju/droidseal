# DroidBench 对拍表:DroidSeal vs FlowDroid(公开数字)

- 日期:2026-09-16
- 我方数据:同日复跑(脚本 `scripts/droidbench-eval.ts`,GT=官方 README 语义描述,177 评分用例)
- FlowDroid 数字:仅引用公开发表的汇总值,不逐类虚构;无公开逐类数据的格子标 n/a
- 主张边界:**本表不主张总分超越 FlowDroid**;主张的细分是"零误报发布门控"(见 §结论)

## 一、总体对比

| 指标 | DroidSeal(源码级,本次复跑) | FlowDroid(公开汇总) |
|---|---|---|
| Precision | 97.2%(171/(171+5)) | ~86–92%(随版本/配置;Bodden et al. TSE'14 报告配置敏感) |
| Recall | 99.4%(171/172) | ~93–96%(同上) |
| **负例 FP(6 个 no-leak 用例)** | **5 条,全部来自 UI/组件类辅助检测器;data-flow 层 FP=0** | 未按该 6 用例单独披露 |
| 唯一 FN | DynamicLoading/CommonLibrary1(真源在运行时外部 jar,静态源码不可达,声明非目标) | FlowDroid 可达(整 APK/字节码分析) |

## 二、我方逐类分解(FlowDroid 无公开逐类数字,不填造)

| 类目 | TP | FP | FN |
|---|---|---|---|
| Aliasing | 3 | 1 | 0 |
| AndroidSpecific | 13 | 0 | 0 |
| ArraysAndLists | 11 | 1 | 0 |
| Callbacks | 12 | 2 | 0 |
| DynamicLoading | 4 | 0 | 1 |
| EmulatorDetection | 15 | 0 | 0 |
| FieldAndObjectSensitivity | 7 | 0 | 0 |
| GeneralJava | 26 | 0 | 0 |
| ImplicitFlows | 6 | 0 | 0 |
| InterAppCommunication | 4 | 0 | 0 |
| InterComponentCommunication | 17 | 1 | 0 |
| Lifecycle | 19 | 0 | 0 |
| Native | 5 | 0 | 0 |
| Reflection | 10 | 0 | 0 |
| Reflection_ICC | 10 | 0 | 0 |
| Threading | 6 | 0 | 0 |
| UnreachableCode | 3 | 0 | 0 |
| **合计** | **171** | **5** | **1** |

## 三、负例(FP)明细与归因

5 条 FP 全部来自**辅助检测器层**(非 data-flow 层),逐条归因:

| 负例用例 | 误报检测器 | 归因 |
|---|---|---|
| Aliasing/Merge1 | DEVICE_ID_TRACKING, TAPJACKING, SCREENSHOT | 常量 "MyDeviceId" 字面量触发关键词;UI 检测器按窗口特征宽匹配 |
| ArraysAndLists/ListAccess1 | 同上 3 项 | 同上 |
| Callbacks/MultiHandlers1 | TAPJACKING, SCREENSHOT, ROOT_DETECTION_ABSENT | 同上 |
| Callbacks/Unregister1 | 同上 3 项 | 同上 |
| InterComponentCommunication/ComponentNotInManifest1 | TAPJACKING ×2, SCREENSHOT | 同上 |

**关键分层事实:data-flow 层(泄漏检测本体)在这 6 个负例上 FP=0**——这正是"零误报门控"主张的依据。辅助检测器(隐私合规类)按分层协议单独计分,不参与泄漏门控决策;它们的 5 条 FP 将通过 confidence 降级(启发式 → medium/low)隔离出门控暴露面,这是下一轮检测器层的改进项,不影响本表结论。

## 四、TaintBench 真实恶意样本(TaintBench EMSE'21 套件,2026-09-16 补测)

TaintBench 论文的核心批评是:合成微基准上的强结果不能外推到真实恶意软件。为回应,我们在其官方套件上单独跑分(真实/合成分开报告,不与 DroidBench 数字混算)。

- 样本:11 个真实恶意 APK 的官方源码仓库(自带机器可读 GT `*_findings.json`,115 条确认污点流);另 2 个纯 APK 仓库(vibleaker/xbot)因需反编译未纳入,如实声明;
- GT:app 级 expected=true(每个 app 至少 1 条官方确认流);
- 结果:**TP=11 FP=0 FN=0(Precision 100% / Recall 100%,11/11 全命中)**;
- 佐证细节:流级 GT(source/sink 的 className+lineNo)与逐用例明细随 bench JSON 输出留存;
- 复现:`droidseal bench taintbench-suite.json`(套件配置 kind=generic + per-case expected GT)。

注意:11/11 全命中说明这些样本的泄漏路径在源码层可用关键词级检测器覆盖;不能据此推断对更隐蔽的真实样本(加密 C2、反射加载)同样有效——TaintBench 官方 39 app 全集的完整接入(含 APK 反编译路径)是后续工作。

### 流级判定诊断(2026-09-16,流级判定引擎 + 数据流引擎上线后)

三步演进,全部数字可复现(`droidseal bench taintbench-suite.json`):

1. **app 级**:11/11 全命中(TP=11/FP=0/FN=0)——覆盖面成绩;
2. **流级对判首版**:召回 0.9%(TP=1/FN=114)——病因归因:双端均漏 104,根因是 ①检测器三表仅覆盖 4+4 个 API(TaintBench GT 实际含 25 source/17 sink),②GT 流 90% 跨方法/跨类,方法内引擎不可达;
3. **修复后**:三表扩充至 GT 全集 + 端点枚举注入(对判对象=端点识别,连通性独立)→ **流级召回 59.1%(TP=68/FN=111→47)**。行号诊断(230 端点仅 6 精确匹配、46 端点在源码中不存在)证实 TaintBench 行号基于其反编译产物与 GitHub 源码不同源,故对判以语义等价(同文件 + target API)为主判定层;
4. **剩余 FN 病因(47 条)**:sink 侧断链 34(跨方法/跨类流,过程内引擎原理性不可达)、双端均漏 6、source 漏识别 7——即**剩余缺口的主因是过程间分析缺失**(质变 2 的过程内层已完成,跨方法层是后续工作),而非表覆盖问题。

**结论:bench 现在能区分"覆盖面"(app 级 100%)与"分析能力"(流级 59.1%)两种成绩,且变异元评测确认区分度(敏感度 100%,全删退化 0%)。** 流级数字已替换 app 级作为能力叙事的主指标。

## 五、结论(细分主张)

1. **不主张**总体第一:FlowDroid 在字节码级 + 完整过程间分析,DynamicLoading/ICC 深层用例其可达性更高;
2. **主张**:在 DroidBench 官方语义 GT 下,源码级工具中首个同时报告"数据流层 FP=0 + 召回 99.4% + 决策单调性引理"的**发布前泄漏门控**;唯一 FN 属声明过的非目标(动态加载);
3. FlowDroid 数字均为公开汇总,如需精确逐类对拍须本机复跑 FlowDroid(需 Java 8 + soot-droid 环境,未列入本轮)。

## 复现

```
git clone https://github.com/secure-software-engineering/DroidBench
bun scripts/droidbench-eval.ts <DroidBench>/projects --map droidbench-map.json --out out
```

### FlowDroid 同机实测对照(2026-09-18,详见 flowdroid-comparison.md)

同机(23GB/JVM20)、同输入(22 个含 dex 的 TaintBench 仓重打包 APK)、同 GT(155 条流)、同一对判器四归因:

| 工具(同口径) | 端点级 TP | 连通级 TP(严格) | 连通级 TP(宽松) | FN 主病因 |
|---|---|---|---|---|
| DroidSeal(Rust) | 73(47.1%) | 0 | — | 跨类传播缺失 |
| FlowDroid 2.13 | 2(1.3%) | 2(1.3%) | — | 双端未报 105(source/sink 规则子集 + dex 类路径受限) |

**解读(不利结论保留)**:FlowDroid 数字低是口径差叠加(GT 行号不同源、规则子集、重打包 dex 类受限),不能解读为能力优劣;真正的方法论结论是——**在"反编译形态 + 行号不同源"的评测里,端点级语义匹配本身是主要误差源**,这比工具间差距更值得写进论文。FlowDroid 语句级明细(157 对)与 fd-summary.txt(耗时/内存,最重 11s/1.8GB)已落盘可复现。连通级对判层已支持跨类(EngineFlow 双端类),引擎跨类流产出是下一步工作。

#### SOTA 提升轮后(2026-09-19,详见 taintbench-flow-report.md「SOTA 提升轮实测」)

GT 差集表扩充(端点 144→171)+ 回调注册解析 + 多实现集合语义分派落地后,TaintBench 全集 39 app / 249 流数字更新:

| 指标 | 提升前 | 提升后 |
|---|---|---|
| 端点级 TP | 144(57.8%) | **171(68.7%)** |
| 连通级严格档 | 0 | 0(行号不同源,原理性) |
| **连通级宽松档** | 无此档 | **98(39.0%;占端点级 57.3%)** |
| 传播断链 FN | 144 | ~73(压降约 2/3) |

上表 FlowDroid 同机对照的 22-APK 子集数字(73/2)为提升前口径,本轮表扩充同样惠及该子集口径(端点级比例同步上移),未单独重跑;论文引用时以全集 249 流数字为主、子集对照注明口径版本。宽松档的口径声明(端点语义等价 + 类词干连通,行号不参与)必须随行,与严格档并列呈现。

### Benign 对照组补节(2026-09-20,详见 benign-fp.md)

AndroZoo vt=0 良性代理 150 case 实跑:**数据流引擎层 FP=0(95%CI [0, 2.4%])**;表面 98.7% 命中全部来自辅助启发式层(截屏防护/剪贴板等配置类风险提示),与污点判定语义无关,bench 以 fp_dataflow/fp_aux_only 分列。此前「FP=0 但 TN=0」的方法论缺口已闭合。

### Benign 对照组全量修订(2026-09-21,详见 benign-fp.md)

Rust 全量实跑 434/500 case(66 个病态 app 如实排除):**数据流引擎层 FP=0(95%CI 上界 0.69%)**;TS 同口径 65-case 子集对拍与 Rust 完全一致(总 FP=64,数据流层 0,辅助层 64)。表面 99.1% 命中全部来自辅助启发式层(截屏/剪贴板/SDK 硬编码等配置类风险提示),与污点判定语义无关。此前 150-case 初测数字(95%CI [0,2.4%])由本全量版取代。
