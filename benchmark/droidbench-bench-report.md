# 基准评测: DroidBench(droidseal bench)

- 评分用例:177 · TP=171 FP=5 FN=1 TN=0
- **Precision 97.2% [95%CI 93.5–98.8] · Recall 99.4% [95%CI 96.8–99.9]**

## 分层 FP

| 层 | 负例 FP |
|---|---|
| data-flow(参与门控) | 4 |
| 辅助 UI/隐私(不参与门控) | 1 |

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
