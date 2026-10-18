# 基准评测: DroidBench(droidseal bench)— 权威证据

> **证据溯源(2026-10-18 重跑)**:数据 = `E:/env/datasets/DroidBench`(上游 master 稀疏克隆);
> GT = `benchmark/droidbench-map.json`(由 `scripts/generate-droidbench-map.ts` 从官方 README 再生成,179 正例 / 6 负例);
> 命令 = `bun src/index.tsx bench benchmark/droidbench-suite.json --format md`;引擎 = bun 1.4.2 TS core;
> 本文件取代旧版归因(data-flow 4 / 辅助 1)——旧报告由更旧层白名单生成,与当前引擎(renderMd FLOW 前缀表)不符,已废止。
> 计时证据见 `benchmark/timing-droidbench-20261018.md`(全量 177 计分用例连跑 wall 982 ms / 进程内峰值 RSS 96.5 MB / CPU 984 ms;隔离单用例端到端 mean 1.3 ms / p50 1.1 / max 10.2)。

# 基准评测: DroidBench(droidseal bench)

- 评分用例:177 · TP=171 FP=5 FN=1 TN=0
- **Precision 97.2% [95%CI 93.5–98.8] · Recall 99.4% [95%CI 96.8–99.9]**

## 分层 FP

| 层 | 负例 FP |
|---|---|
| data-flow(参与门控) | 0 |
| 辅助 UI/隐私(不参与门控) | 5 |

## 类目分解

| 类目 | TP | FP | FN | TN |
|---|---|---|---|---|
| Aliasing | 3 | 1 | 0 | 0 |
| AndroidSpecific | 13 | 0 | 0 | 0 |
| ArraysAndLists | 11 | 1 | 0 | 0 |
| Callbacks | 12 | 2 | 0 | 0 |
| DynamicLoading | 4 | 0 | 1 | 0 |
| EmulatorDetection | 15 | 0 | 0 | 0 |
| FieldAndObjectSensitivity | 7 | 0 | 0 | 0 |
| GeneralJava | 26 | 0 | 0 | 0 |
| ImplicitFlows | 6 | 0 | 0 | 0 |
| InterAppCommunication | 4 | 0 | 0 | 0 |
| InterComponentCommunication | 17 | 1 | 0 | 0 |
| Lifecycle | 19 | 0 | 0 | 0 |
| Native | 5 | 0 | 0 | 0 |
| Reflection | 10 | 0 | 0 | 0 |
| Reflection_ICC | 10 | 0 | 0 | 0 |
| Threading | 6 | 0 | 0 | 0 |
| UnreachableCode | 3 | 0 | 0 | 0 |

## FP 归因

- Aliasing/Merge1: SOURCE_DEVICE_ID_TRACKING, SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_ROOT_DETECTION_ABSENT, SOURCE_SMS_SEND_AUTO
- ArraysAndLists/ListAccess1: SOURCE_DEVICE_ID_TRACKING, SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_ROOT_DETECTION_ABSENT, SOURCE_SMS_SEND_AUTO
- Callbacks/MultiHandlers1: SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_ROOT_DETECTION_ABSENT, SOURCE_WIDGET_SENSITIVE, SOURCE_GPS_ONLY_LOCATION
- Callbacks/Unregister1: SOURCE_DEVICE_ID_TRACKING, SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_ROOT_DETECTION_ABSENT, SOURCE_SMS_SEND_AUTO
- InterComponentCommunication/ComponentNotInManifest1: SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_TAPJACKING_UNPROTECTED, SOURCE_SCREENSHOT_NOT_BLOCKED, SOURCE_TAPJACKING_UNPROTECTED

## FN 明细

- DynamicLoading/CommonLibrary1

> **评分粒度声明**:该套件 GT 为 app 级(expected 标注,无官方流级 findings),仅 app 级评分;流级判定适用于自带 findings.json 的套件(如 TaintBench)。
