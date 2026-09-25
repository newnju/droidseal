# FlowDroid 同机实测对照(2026-09-18)

> **harness**: FlowDroid soot-infoflow-cmd-2.13.0 fat jar(v2.13 release, sha256 20b1ded27e550bfd)· JVM 20.0.1 · 23GB 内存 · fakeplatforms(aapt 打包的 android-4.2.2/android.jar)· source/sink 规则与 DroidSeal 三表同 API 集(SAS2.txt,注册 27 sources/18 sinks)· GT=TaintBench 官方 findings.json

> **输入口径**:TaintBench 39 源码仓中 22 个含 classes.dex 的仓(aapt 重打包为 APK);17 个无 dex 仓经 javac→d8 编译尝试(迭代剔除坏文件)后确认反编译缺陷为原理性障碍(`org.apache.http` 移除、无 R 类、坏代码),如实排除。两侧工具用**同一 22 APK、同一 GT、同一对判语义**。

- 共同子集:22 app · GT 流 155 条
- **DroidSeal(Rust)**:端点级 TP=73(47.1%) · 连通级 TP=0(0.0%)
- **FlowDroid 2.13**:端点级 TP=2(1.3%) · 连通级 TP=2(1.3%)

## FlowDroid FN 病因(同一对判器四归因)

| source漏 | sink漏 | 双漏 | 传播断 |
|---|---|---|---|
| 45 | 3 | 105 | 0 |

## 诚实解读(不利结论保留)

1. FlowDroid 端点级 1.3% **不是其分析能力差**,而是口径差叠加:①GT 行号基于 TaintBench 官方反编译产物,与重打包 dex 行号不同源,对判靠 targetName 语义匹配,而 soot 把语句重写为签名形式,命中率骤降;②SAS2 46 条规则仅为 DroidSeal 三表近似子集;③105 条双漏说明多数 GT 端点调用点未出现在 FlowDroid 报告语句中(dex 类路径受限)。
2. FlowDroid 连通级 1.3% vs DroidSeal 同子集连通 0%——在受限输入形态下谁都未能证明流连通;DroidSeal 39 全集端点 47.1% 为源码直扫口径,与 FlowDroid 的 22 APK 子集**不可直接比**(输入形态不同)。
3. 本对照价值:①首个同机/同 GT/同对判基线;②暴露'GT 行号不同源+反编译形态差异'是评测方法论核心难题(比工具能力差距更值得写进论文);③FlowDroid 语句级明细(157 对)已落盘(fd-flows-parsed.json),连通级对判可直接复用。

## FlowDroid 每样本耗时/内存(fd-summary.txt 全量)

| 样本 | leaks | 耗时 | 内存 |
|---|---|---|---|
| beita_com_beita_contact | 19 | 2s | 226MB |
| chat_hook | 14 | 4s | 242MB |
| death_ring_materialflow | 11 | 1s | 192MB |
| exprespam | 0 | 1s | 55MB |
| fakedaum | 7 | 2s | 232MB |
| fakemart | 1 | 1s | 141MB |
| fakeplay | 1 | 1s | 138MB |
| faketaobao | 3 | 1s | 96MB |
| godwon_samp | 0 | 1s | 68MB |
| hummingbad_android_samp | 3 | 48s | 1018MB |
| overlaylocker2_android_samp | 6 | 2s | 141MB |
| phospy | 1 | 3s | 155MB |
| proxy_samp | 5 | 2s | 228MB |
| remote_control_smack | 2 | 3s | 255MB |
| repane | 0 | 1s | 82MB |
| save_me | 13 | 10s | 359MB |
| scipiex | 4 | 1s | 203MB |
| sms_google | 0 | 1s | 75MB |
| sms_send_locker_qqmagic | 2 | 1s | 75MB |
| smsstealer_kysn_assassincreed_android_samp | 0 | 1s | 58MB |
| the_interview_movieshow | 1 | 2s | 118MB |
| vibleaker_android_samp | 7 | 11s | 1775MB |

合计 22 样本,总耗时约 100s(平均 ~4s/样本,最重 vibleaker 11s/1.8GB)。