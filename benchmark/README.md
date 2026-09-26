# DroidSeal Bench — 环节定位与使用说明

> bench 是**评测基础设施**,不是发布流水线的一部分:它回答"这个版本的分析能力是什么水平",在三个环节被使用,但绝不跑在用户的发布链路上(加固能力与 bench 完全解耦——bench 只读,不触碰 harden/keyed)。

## 一、bench 用在哪个环节

### 1. 开发环节(回归防线)——最日常的使用
**谁/何时**:改检测器、改污点表、改门控逻辑之后,提交前跑一次。
**做什么**:检测器是否把某个正例改漏了(召回跌)、是否在负例上引入新误报(FP 涨)——`--max-fp`/`--min-recall` 不达标即 exit 1,可直接挂 CI。
**价值**:没有 bench 时,改一条规则只能靠跑单个样本"手感"验证;有 bench 后,177 合成用例 + 11 真实恶意样本 + 115 条官方流是每次改动的回归网。

### 2. 发布环节(校准,非拦截)
**谁/何时**:版本发布前,评估者/维护者跑一轮,把数字写进 CHANGELOG 与对拍表。
**做什么**:确认本版本的 precision/recall/流级召回画像;与上一版本对比,能力变化可解释。
**边界(重要)**:用户侧的发布门控(audit → gate → fix → re-test)用的是**应用自身发现**做决策,不调 bench——bench 校准的是"工具能力可信度",不是单次发布决策。

### 3. 论文环节(证据链)
**谁/何时**:论文评估节写作与投稿前数据核对。
**做什么**:①全部表格数字一条命令复现(`benchmark/droidbench-comparison.md` 的复现段);②流级对判提供 FN 病因归因(能力缺口定位到 source 漏/sink 断/双漏);③变异元评测提供 bench 自身区分度证明(敏感度 100%,审稿人问"分数差异是真是噪声"时有量化回答)。

## 二、命令(两侧同口径)

```bash
# GitHub 版(TS,本目录)
bun src/index.tsx bench benchmark/droidbench-suite.json            # 合成基准,app 级
bun src/index.tsx bench benchmark/taintbench-suite-ts.json         # 真实恶意样本,app 级 + 流级对判
bun src/index.tsx bench benchmark/droidbench-suite.json --max-fp 5 --min-recall 99   # CI 门控
bun src/index.tsx bench benchmark/droidbench-suite.json --format json               # 机器可读

# Rust 版(DroidSeal-Rust,能力等价+变异元评测额外)
cargo run --release -- bench <suite.json> [--mutate]
```

## 三、当前基线数字(2026-09-16,双侧对齐)

| 套件 | 粒度 | DroidSeal(TS) | DroidSeal(Rust) |
|---|---|---|---|
| DroidBench(177 用例,合成) | app 级 | TP=171 FP=5 FN=1 · 97.2%/99.4% | 同左(完全一致) |
| TaintBench(11 app,真实恶意) | app 级 | TP=11 FP=0 FN=0 | 同左 |
| TaintBench(115 条官方流) | 流级(端点对判) | 召回 57.4%(TP=66/FN=49) | 召回 59.1%(TP=68/FN=47) |

TS/Rust 流级差 2 条:端点判定的实现细节差异(行内多 API 匹配顺序),如实记录不做粉饰。

## 四、套件配置(GT 双格式)

- **README 语义 map**(`positive/negative` 数组):DroidBench 用,由官方 README 逐用例描述生成;
- **per-case expected**(`cases[].expected`):TaintBench 用,由官方 `*_findings.json` 转换(app 级 expected=true);
- 配置文件:`droidbench-suite.json`、`taintbench-suite-ts.json`(TS 侧)、`taintbench-suite.json`(Rust 侧),字段 `{name, projects_dir, gt_file, kind}`,`kind=droidbench`(两级目录)/`generic`(扁平)。

## 五、诚实边界
- DroidBench 5 条 FP 全部来自辅助 UI/隐私检测器,data-flow 层 FP=0(分层计分,见 comparison.md);
- TaintBench 行号与 GitHub 源码不同源(230 端点仅 6 精确),流级对判以"同文件 + target API 语义等价"为主判定层;
- 流级剩余 FN 主因是跨方法/跨类流(过程间分析未实现,后续工作);
- vibleaker/xbot 两个纯 APK 仓库未纳入(需反编译)。

> **2026-09-26 更新**:对判层新增混淆名归一(方法体唯一 API 锚定,歧义如实放弃)后,249 条 GT 流口径的流级 TP 130 → 136、连通级宽松档 61 → 66(实测与口径详见 taintbench-flow-report.md「混淆名归一轮实测」)。上表 115 条官方流为独立套件口径,数字不变。
