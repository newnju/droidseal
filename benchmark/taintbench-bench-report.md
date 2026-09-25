# 基准评测: TaintBench-realworld(droidseal bench)

> **GT 声明**:ground truth 来自套件自带标注(README 语义 map 或 per-case expected)。
> README 措辞匹配生成的 map 存在已知局限(措辞歧义/覆盖缺口);分层数据流层与辅助层分开计分,辅助层 FP 不参与泄漏门控。

- 评分用例:11(GT 外跳过 2)
- TP=11 FP=0 FN=0 · **Precision 100.0% · Recall 100.0%**

## 分层得分

| 层 | 用途 | 负例 FP |
|---|---|---|
| data-flow(泄漏本体) | 参与发布门控 | 0 |
| 辅助(UI/隐私合规) | 不参与门控,人工分诊 | 0 |

| 类目 | TP | FP | FN |
|---|---|---|---|
| TaintBench-realworld | 11 | 0 | 0 |
| **合计** | **11** | **0** | **0** |

