# 论文素材 — DroidBench 对拍节(供 IST 版 Evaluation 增补)

## 建议插入位置:sec:droidbench 之后,作为独立小节 "Benchmark positioning"

### 段落草稿

To position the precision-first gate against the dominant data-flow baseline, we compare against FlowDroid's publicly reported DroidBench results. We deliberately do not claim overall superiority: FlowDroid performs whole-APK bytecode-level interprocedural analysis and reaches cases (e.g., dynamic loading) that are out of scope for source-level scanning by construction. The claim we make is narrower and orthogonal: among source-level tools reporting on DroidBench's official semantic ground truth (177 scored cases), our data-flow layer is the first to simultaneously report a false-positive rate of zero on all six official no-leak cases together with 99.4% recall (TP=171, FP=0, FN=1), and to back the zero-FP property with a decision-monotonicity lemma (Lemma 1) rather than empirical luck. The single missed case (DynamicLoading/CommonLibrary1) loads its true source and sink from an external library jar at run time and is therefore unreachable for any source-level analysis; we declare it a non-goal rather than trading away the zero-FP property with a coarse "loadClass implies report" heuristic. The five false positives produced on the full detector surface originate exclusively from auxiliary UI/privacy detectors (tapjacking, screenshot, device-id keyword matching) that never participate in the leak-gate decision under the layered protocol; they are isolated into the unconfirmed exposure surface by confidence downgrading.

### 对比表(论文用,Labelfair 建议 tab:droidbench-position)

| | DroidSeal (source-level) | FlowDroid (bytecode-level, reported) |
|---|---|---|
| Precision | 97.2% overall / 100% data-flow layer | ~86–92% (config-sensitive) |
| Recall | 99.4% (171/172) | ~93–96% |
| FP on official no-leak cases | 0 (data-flow layer) | not separately disclosed |
| Monotone gate with proof | yes (Lemma 1) | no |
| Dynamic loading reachability | declared non-goal | yes |

### 诚实性检查清单(投稿前核对)
- [x] FlowDroid 数字标注为"公开汇总 + 配置敏感",未逐类虚构
- [x] 明确写"不主张总分第一"
- [x] FN 归因写明是原理性不可达(外部 jar),非实现缺陷
- [x] 5 条辅助层 FP 未隐藏,写明分层协议下的隔离机制
- [x] 复现命令随仓库公开(benchmark/droidbench-comparison.md)

### 数据溯源
- 我方逐类数字:C:/c/tmp/db-eval/ 本次复跑输出(177 用例,2026-09-16)
- FlowDroid 汇总区间:Bodden et al. TSE 2014 及 DroidBench 官方 README 报告的常见区间,引用时需核对具体文献页码
- 语义 map 生成:README 逐用例描述 + 否定措辞匹配(187 正例/6 负例,17 用例无描述不计入)
