# Benign 对照组 FP 实测(AndroZoo vt=0 良性代理)— 全量版

日期:2026-09-21 · 引擎:Rust(droidseal-rust release)+ TS(bun,同口径对拍)

## 口径声明(必须随行)

1. **良性代理**:样本为 AndroZoo `vt_detection=0`、Google Play 市场、2015-2025 的 app。VT=0 是良性**代理口径**而非证明(免杀新样本可能漏网),论文引用须注明 "benign proxy"。
2. **双层 FP 口径**:检测输出含两层——**数据流引擎层**(污点 source→sink 流,与 FlowDroid 同语义,`SOURCE_`/启发式码除外)与**辅助启发式层**(配置/风险类检测:截屏防护、剪贴板、SDK 版本硬编码等)。污点分析 FP 对比**只认数据流层**;辅助层命中是"风险提示"不是"泄漏判定"。
3. **排除项如实声明**:500 case 中 434 个完成实跑(Rust),66 个因单 app 分析耗时超过会话窗口(病态大体积 app)如实排除,未参与统计。
4. **TS 侧子集口径**:TS 对拍取前 65 case(m0-m12 子集),与 Rust 同 case 数字一致;全量 434 的 TS 实跑未做,论文引用 Rust 全量 + TS 子集一致性即可。

## 核心数字(Rust,全量实跑)

| 口径 | FP | n | FP 率 | 95%CI 上界 |
|---|---|---|---|---|
| **数据流引擎层(污点分析口径)** | **0** | **434** | **0.0%** | **0.69%** |
| 辅助启发式层命中(非污点 FP) | 430 | 434 | 99.1% | — |
| 总 FP(两层混计,错误口径) | 430 | 434 | 99.1% | — |

## 双侧对拍(TS 65-case 子集 vs Rust 同 case)

| 引擎 | cases | 总 FP | 数据流层 FP | 辅助层 FP |
|---|---|---|---|---|
| Rust | 65 | 64 | **0** | 64 |
| TS(bun) | 65 | 64 | **0** | 64 |

**双侧一致**:同 65 case 下总 FP 与分层数字完全一致;TS 的 JSON 输出无 `fp_dataflow` 字段,分层按与 Rust 相同规则(码前缀)事后重算得出。逐 case 配对因两侧 details 序列化结构差异未建立,如实声明。

## FP 病因归因(430 个辅助层命中的构成)

| 启发式码(示例) | 性质 |
|---|---|
| SOURCE_SCREENSHOT_NOT_BLOCKED / SOURCE_TAPJACKING_UNPROTECTED | 未禁截屏/未防 tapjacking——任何真实 app 普遍存在 |
| SOURCE_PRIVACY_CLIPBOARD / SOURCE_LOG_* | 剪贴板读取、日志输出——配置类风险提示 |
| SOURCE_SDK_LEVEL_HARDCODE / SOURCE_VERSION_CHECK_ABSENT | 工程实践类提示,与污点无关 |

**结论**:数据流引擎(规则表 + 过程间传播 + 流级判定)在 434 个真实良性 app 上 **FP=0**;表面 99.1% 命中全部来自辅助启发式层。bench 以 `fp_dataflow` / `fp_aux_only` 分列,双层混计是对判口径错误而非规则过宽。

## 与恶意侧数字的合并口径(论文引用格式)

- DroidBench(恶意,171/5/1, 97.2%)+ TaintBench(端点 171/249, 68.7%)+ **Benign 代理(434 case, 数据流层 FP=0, 95%CI 上界 0.69%, TS 子集双侧一致)**;
- benign 对照补齐了此前"Precision=100% 但 TN=0 无统计意义"的方法论缺口。

## 复现

```
# 套件:C:/c/c/tmp/androzoo/benign-suite.json(100 个 5-case 分片 f0-f99 + 单 case 套件 u*)
# Rust 全量(单 app ~52s,病态 app 单 case 会话窗口内如实超时排除)
droidseal-rust.exe bench benign-suite-m<i>.json --format json > rust-benign-m<i>.json
# TS 子集(65 case,m0-m12)
bun src/index.tsx bench benign-suite-m<i>.json --format json > ts-benign-m<i>.json
# 聚合:分片 JSON 尾部常缺右括号,需补齐重试解析;提取 fp / fp_dataflow 求和
```

harness 指纹:`engine a204dd9@dirty · detectors=default;dataflow=intra+interproc-summary+crossclass;benign-adjudication=dataflow-layer-only`
