# 代码工件三角验证(文档层 ↔ 代码层,零标注人)

- 证据 A(文档层):DroidBench 官方 README 行为描述 → 172 正例 / 5 负例(程序化提取,无人工标注)
- 证据 B(代码层):源码内 API 工件(6 类汇点 / 5 类敏感源),与文档描述零共享词汇
- 评测用例:177 | 日期:2026-09-14

| 指标 | 值 |
|---|---|
| 可评分用例(有代码工件) | 171 / 177 |
| 两证据一致率 | 97.1%(166/171) |
| 正例汇点工件覆盖 | 96.5% |
| 负例无汇点工件 | 0% |
| 冲突(文档说负例但代码具能力) | 5 |
| 工件不可观察(纯反射/库间流等) | 6 |

## 冲突用例清单(逐条归因对象)

- Aliasing/Merge1: sinks=[sms] sources=[deviceId] | README: Sensitive data is assigned to a heap object which is then shuffled around. Only 
- ArraysAndLists/ListAccess1: sinks=[sms] sources=[deviceId] | README: Both a tainted and an untainted value are stored in a list. Only the untainted v
- Callbacks/MultiHandlers1: sinks=[intent,log] sources=[location] | README: Contains two activities and two handlers that do not leak any data if the correc
- Callbacks/Unregister1: sinks=[sms] sources=[deviceId] | README: Registers and directly unregisters a callback before it can be invoked. The code
- InterComponentCommunication/ComponentNotInManifest1: sinks=[log,intent] sources=[deviceId] | README: IMEI is obtained in one Activity and is stored in the Intent's to start a leakin

## 工件不可观察清单

- AndroidSpecific/Library1: no-artifact(工件层不可观察,如纯反射/库间流)
- GeneralJava/StartProcessWithSecret1: no-artifact(工件层不可观察,如纯反射/库间流)
- InterComponentCommunication/IntentSink1: no-artifact(工件层不可观察,如纯反射/库间流)
- Native/JavaIDFunction: no-artifact(工件层不可观察,如纯反射/库间流)
- Native/SinkInNativeCode: no-artifact(工件层不可观察,如纯反射/库间流)
- Native/SinkInNativeLibCode: no-artifact(工件层不可观察,如纯反射/库间流)

## sink-only 正例(工件不完整但方向一致)

- AndroidSpecific/Library2: sinks=[sms]
- AndroidSpecific/LogNoLeak: sinks=[log]
- AndroidSpecific/PrivateDataLeak1: sinks=[sms,log]
- AndroidSpecific/PrivateDataLeak2: sinks=[log]
- DynamicLoading/CommonLibrary1: sinks=[log]
- DynamicLoading/DynamicBoth1: sinks=[file]
- DynamicLoading/DynamicSource1: sinks=[file,log]
- ImplicitFlows/ImplicitFlow2: sinks=[log]
- ImplicitFlows/ImplicitFlow3: sinks=[log]
- ImplicitFlows/ImplicitFlow4: sinks=[log]
- InterAppCommunication/Collector: sinks=[file]
- InterAppCommunication/Echoer: sinks=[log]
- InterComponentCommunication/IntentSource1: sinks=[log,intent]
- Native/SourceInNativeCode: sinks=[sms]
- Reflection/Reflection10: sinks=[log]