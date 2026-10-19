# 证据溯源(provenance)

> 数据集:TaintBench 全部 39 个 app 源码仓库,自上游 taintbench org 逐 app 克隆恢复至 `E:/env/datasets/TaintBench/apps/<app>`(2026-10-19,shallow depth=1;上游主仓仅含 configs,应用以一仓一 app 形式分发);
> GT:`benchmark/taintbench-map.json`(39 用例,expected=true——真实恶意样本);套件:`benchmark/taintbench-suite-ts.json`(projects_dir 已从旧 C: 死路径迁移至上述 E: 目录,kind=generic);
> 引擎:bun 1.4.2 · TS 核心(与 CLI 同引擎);复现:`bun src/index.tsx bench benchmark/taintbench-suite-ts.json`(md) / `--format json`(机器可读);
> 本文件 = 溯源头 + 2026-10-19 复跑输出原文(机械转写,无手写数字);历史正本与流级账目见 `taintbench-bench-report-20261018.md` 与 `taintbench-flow-report-ts.md`。

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

- GT 流:249(positive 203 + negative 41) · 端点级 TP:136 · FN:67 · **负例 FP:41**(锚定口径:9) · **连通级 TP:1(0.7%)** · 连通级宽松档 TP:101(74.3%) · 连通级锚定档 TP:56(41.2%) · 流级召回 67%
> 口径声明:官方语义——Expected Flow 检出=TP、未检出=FN;Unexpected(isNegative)流检出=FP。严格档 = 两端类词干对齐且行号精确/±2;宽松档 = 两端类词干对齐(行号仅作参考);锚定档 = GT statement 逐字定位到仓库 src 同源行号后做严格档(仅两端均锚定成功的流参与)。三档并列呈现,宽松档/锚定档不得单独引用。锚定口径 FP:负例两端锚定成功且引擎流行号(±2)双端命中——端点语义等价但行号不齐的宽松检出不计(数据集行号不同源的固有模糊剔除)。

### FN 病因归因(三类,分母=positive 流)

| 病因 | 条数 | 含义 |
|---|---|---|
| source 漏识别 | 14 | source 点 API 未被引擎表覆盖 |
| sink 侧断链 | 44 | source 已识别、sink 未识别(sink 表缺口或跨类) |
| 双端均漏 | 9 | source 与 sink 均未识别 |
| 传播断链 | 135 | 两端均识别但引擎无流连接(计入连通级 FN) |

### 逐 app 明细

| app | GT 流 | TP | 连通TP | FN | FP(负例) | source漏 | sink断 | 双漏 | 传播断 |
|---|---|---|---|---|---|---|---|---|---|
| backflash | 24 | 13 | 13 | 0 | 11 | 0 | 0 | 0 | 13 |
| beita_com_beita_contact | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 3 |
| cajino_baidu | 15 | 10 | 10 | 2 | 3 | 2 | 0 | 0 | 9 |
| chat_hook | 13 | 1 | 1 | 11 | 0 | 0 | 10 | 1 | 1 |
| chulia | 4 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| death_ring_materialflow | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| dsencrypt_samp | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| exprespam | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 2 | 0 |
| fakeappstore | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 3 |
| fakebank_android_samp | 5 | 3 | 1 | 2 | 0 | 1 | 1 | 0 | 3 |
| fakedaum | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| fakemart | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| fakeplay | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| faketaobao | 4 | 0 | 0 | 4 | 0 | 4 | 0 | 0 | 0 |
| godwon_samp | 6 | 6 | 6 | 0 | 0 | 0 | 0 | 0 | 6 |
| hummingbad_android_samp | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| jollyserv | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| overlaylocker2_android_samp | 19 | 7 | 2 | 0 | 12 | 0 | 0 | 0 | 7 |
| overlay_android_samp | 6 | 4 | 4 | 0 | 2 | 0 | 0 | 0 | 4 |
| phospy | 5 | 2 | 2 | 0 | 3 | 0 | 0 | 0 | 2 |
| proxy_samp | 20 | 13 | 11 | 4 | 1 | 0 | 1 | 3 | 13 |
| remote_control_smack | 17 | 15 | 15 | 2 | 0 | 0 | 2 | 0 | 15 |
| repane | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| roidsec | 6 | 6 | 6 | 0 | 0 | 0 | 0 | 0 | 6 |
| samsapo | 5 | 4 | 2 | 0 | 1 | 0 | 0 | 0 | 4 |
| save_me | 31 | 1 | 0 | 24 | 4 | 2 | 20 | 2 | 1 |
| scipiex | 3 | 1 | 0 | 2 | 0 | 1 | 1 | 0 | 1 |
| slocker_android_samp | 5 | 3 | 3 | 2 | 0 | 2 | 0 | 0 | 3 |
| smssend_packageInstaller | 5 | 5 | 4 | 0 | 0 | 0 | 0 | 0 | 5 |
| smssilience_fake_vertu | 4 | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 |
| smsstealer_kysn_assassincreed_android_samp | 5 | 0 | 0 | 5 | 0 | 0 | 5 | 0 | 0 |
| sms_google | 4 | 1 | 1 | 3 | 0 | 0 | 2 | 1 | 1 |
| sms_send_locker_qqmagic | 8 | 6 | 6 | 0 | 2 | 0 | 0 | 0 | 6 |
| stels_flashplayer_android_update | 3 | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| tetus | 2 | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 1 |
| the_interview_movieshow | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 0 |
| threatjapan_uracto | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| vibleaker_android_samp | 4 | 2 | 2 | 2 | 0 | 0 | 2 | 0 | 2 |
| xbot_android_samp | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
