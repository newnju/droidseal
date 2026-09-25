# 基准评测: TaintBench-realworld(droidseal bench)

- 评分用例:39 · TP=39 FP=0 FN=0 TN=0
- **Precision 100% [95%CI 91–100] · Recall 100% [95%CI 91–100]**

## 分层 FP

| 层 | 负例 FP |
|---|---|
| data-flow(参与门控) | 0 |
| 辅助 UI/隐私(不参与门控) | 0 |

## 类目分解

| 类目 | TP | FP | FN | TN |
|---|---|---|---|---|
| TaintBench-realworld | 39 | 0 | 0 | 0 |

## FP 归因

(无)

## FN 明细

(无)

## 流级判定(flow-level adjudication)

- GT 流:249 · 流级 TP:126 · FN:123 · **流级召回 50.6%**(端点级对判:同文件 + target API 语义等价;TaintBench 行号基于其反编译产物,与源码行号不同源——实测 230 端点仅 6 精确)

### FN 病因归因

| 病因 | 条数 | 含义 |
|---|---|---|
| source 漏识别 | 22 | source 点 API 未被引擎表覆盖 |
| sink 侧断链 | 84 | source 已识别、sink 未识别(sink 表缺口或跨类) |
| 双端均漏 | 17 | source 与 sink 均未识别 |

### 逐 app 明细

| app | GT 流 | TP | FN | source漏 | sink断 | 双漏 |
|---|---|---|---|---|---|---|
| backflash | 24 | 16 | 8 | 0 | 7 | 1 |
| beita_com_beita_contact | 3 | 2 | 1 | 0 | 1 | 0 |
| cajino_baidu | 15 | 13 | 2 | 2 | 0 | 0 |
| chat_hook | 13 | 0 | 13 | 0 | 11 | 2 |
| chulia | 4 | 3 | 1 | 1 | 0 | 0 |
| death_ring_materialflow | 1 | 1 | 0 | 0 | 0 | 0 |
| dsencrypt_samp | 1 | 1 | 0 | 0 | 0 | 0 |
| exprespam | 2 | 0 | 2 | 0 | 0 | 2 |
| fakeappstore | 3 | 2 | 1 | 1 | 0 | 0 |
| fakebank_android_samp | 5 | 3 | 2 | 1 | 1 | 0 |
| fakedaum | 2 | 2 | 0 | 0 | 0 | 0 |
| fakemart | 2 | 2 | 0 | 0 | 0 | 0 |
| fakeplay | 2 | 1 | 1 | 1 | 0 | 0 |
| faketaobao | 4 | 0 | 4 | 4 | 0 | 0 |
| godwon_samp | 6 | 6 | 0 | 0 | 0 | 0 |
| hummingbad_android_samp | 2 | 2 | 0 | 0 | 0 | 0 |
| jollyserv | 1 | 0 | 1 | 0 | 1 | 0 |
| overlaylocker2_android_samp | 19 | 19 | 0 | 0 | 0 | 0 |
| overlay_android_samp | 6 | 6 | 0 | 0 | 0 | 0 |
| phospy | 5 | 2 | 3 | 0 | 3 | 0 |
| proxy_samp | 20 | 8 | 12 | 0 | 9 | 3 |
| remote_control_smack | 17 | 0 | 17 | 0 | 13 | 4 |
| repane | 1 | 1 | 0 | 0 | 0 | 0 |
| roidsec | 6 | 4 | 2 | 2 | 0 | 0 |
| samsapo | 5 | 3 | 2 | 2 | 0 | 0 |
| save_me | 31 | 5 | 26 | 2 | 22 | 2 |
| scipiex | 3 | 1 | 2 | 1 | 1 | 0 |
| slocker_android_samp | 5 | 3 | 2 | 2 | 0 | 0 |
| smssend_packageInstaller | 5 | 3 | 2 | 0 | 2 | 0 |
| smssilience_fake_vertu | 4 | 4 | 0 | 0 | 0 | 0 |
| smsstealer_kysn_assassincreed_android_samp | 5 | 0 | 5 | 0 | 5 | 0 |
| sms_google | 4 | 1 | 3 | 0 | 2 | 1 |
| sms_send_locker_qqmagic | 8 | 7 | 1 | 1 | 0 | 0 |
| stels_flashplayer_android_update | 3 | 2 | 1 | 1 | 0 | 0 |
| tetus | 2 | 0 | 2 | 0 | 1 | 1 |
| the_interview_movieshow | 1 | 0 | 1 | 1 | 0 | 0 |
| threatjapan_uracto | 2 | 1 | 1 | 0 | 1 | 0 |
| vibleaker_android_samp | 4 | 0 | 4 | 0 | 3 | 1 |
| xbot_android_samp | 3 | 2 | 1 | 0 | 1 | 0 |
