# MobSF 4.5.2 vs DroidSeal —— 共享规则集正面对比

样本: ds-test-input, FlowSensitivity1, ArrayAccess1, Reflection1, DirectLeak1, Clone1, Button1(n=7)

方法: 双方发现归一到共享规则语义(调试/备份/SDK过旧),以清单属性为客观 ground truth。
MobSF APK 模式无源码级规则(code_analysis=0),故共享层 = 清单配置规则;数据流维度为 DroidSeal 特有,不入共享集。

| 共享规则 | 双方一致 | MobSF TP/FP/FN | DroidSeal TP/FP/FN | MobSF 精度/召回 | DroidSeal 精度/召回 |
|---|---|---|---|---|---|
| DEBUGGABLE | 6/7 | 6/0/0 | 6/0/0 | 100%/100% | 100%/100% |
| ALLOW_BACKUP | 6/7 | 6/0/0 | 6/0/0 | 100%/100% | 100%/100% |
| MIN_SDK_OUTDATED | 6/7 | 6/1/0 | 6/0/0 | 86%/100% | 100%/100% |
| TARGET_SDK_OUTDATED | 6/7 | 7/0/0 | 6/0/1 | 100%/100% | 100%/86% |

## 逐样本一致/分歧明细

| 样本 | 一致规则 | MobSF 特有(未评分) | DroidSeal 特有(未评分) |
|---|---|---|---|
| ds-test-input | 2/4 | 3 条 | 20 条 ⚠ MIN_SDK_OUTDATED(M:1/D:0/T:0), TARGET_SDK_OUTDATED(M:1/D:0/T:1) |
| FlowSensitivity1 | 4/4 | 3 条 | 13 条  |
| ArrayAccess1 | 4/4 | 5 条 | 12 条  |
| Reflection1 | 4/4 | 5 条 | 12 条  |
| DirectLeak1 | 4/4 | 5 条 | 12 条  |
| Clone1 | 4/4 | 5 条 | 12 条  |
| Button1 | 4/4 | 5 条 | 12 条  |