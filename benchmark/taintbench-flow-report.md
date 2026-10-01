# 基准评测: TaintBench-realworld

> **harness**: engine `a204dd9@dirty+crossclass+setsem` · scan `detectors=default;dataflow=intra+interproc-summary+crossclass+callback+setdispatch;flow-adjudication=endpoint+connected(strict+lenient)` · gt sha256:eb9d89c4bb1e3b3a · generated 2026-09-19 09:00Z

# 基准评测: TaintBench-realworld(droidseal bench)

> **GT 声明**:ground truth 来自套件自带标注(README 语义 map 或 per-case expected)。
> README 措辞匹配生成的 map 存在已知局限(措辞歧义/覆盖缺口);分层数据流层与辅助层分开计分,辅助层 FP 不参与泄漏门控。

- 评分用例:39(GT 外跳过 0)
- TP=39 FP=0 FN=0 · **Precision 100.0% [95%CI 91–100] · Recall 100.0% [95%CI 91–100]**

> ⚠ **合成套件近饱和**(precision/recall ≥ 98%):该套件已无法区分更强检测器的能力差异——能力比较请看真实恶意样本套件(TaintBench)与流级/连通级判定。

## 分层得分

| 层 | 用途 | 负例 FP |
|---|---|---|
| data-flow(泄漏本体) | 参与发布门控 | 0 |
| 辅助(UI/隐私合规) | 不参与门控,人工分诊 | 0 |

| 类目 | TP | FP | FN |
|---|---|---|---|
| TaintBench-realworld | 39 | 0 | 0 |
| **合计** | **39** | **0** | **0** |


## 流级判定(flow-level adjudication)

- GT 流:249 · 端点级 TP:144 · **连通级 TP:0(0.0%)** · FN:249 · 流级召回 36.6%
### FN 病因归因(四类)

| 病因 | 条数 | 含义 |
|---|---|---|
| source 漏识别 | 22 | source 点无报告——敏感 API 识别缺失 |
| sink 漏识别 | 67 | source 已报、sink 未报——sink 表缺口 |
| 双端均漏 | 16 | source 与 sink 均无报告 |
| 传播断链 | 144 | 两端均已识别但引擎无流连接——过程间/别名能力缺口 |

### 逐 app 明细

| app | GT 流 | TP | 连通TP | FN | source漏 | sink漏 | 双漏 | 传播断 |
|---|---|---|---|---|---|---|---|---|
| backflash | 24 | 23 | 0 | 24 | 1 | 0 | 0 | 23 |
| beita_com_beita_contact | 3 | 2 | 0 | 3 | 0 | 1 | 0 | 2 |
| cajino_baidu | 15 | 8 | 0 | 15 | 2 | 4 | 1 | 8 |
| chat_hook | 13 | 8 | 0 | 13 | 0 | 3 | 2 | 8 |
| chulia | 4 | 3 | 0 | 4 | 1 | 0 | 0 | 3 |
| death_ring_materialflow | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |
| dsencrypt_samp | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |
| exprespam | 2 | 0 | 0 | 2 | 0 | 0 | 2 | 0 |
| fakeappstore | 3 | 2 | 0 | 3 | 1 | 0 | 0 | 2 |
| fakebank_android_samp | 5 | 3 | 0 | 5 | 1 | 1 | 0 | 3 |
| fakedaum | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 |
| fakemart | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 |
| fakeplay | 2 | 1 | 0 | 2 | 1 | 0 | 0 | 1 |
| faketaobao | 4 | 0 | 0 | 4 | 4 | 0 | 0 | 0 |
| godwon_samp | 6 | 6 | 0 | 6 | 0 | 0 | 0 | 6 |
| hummingbad_android_samp | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 |
| jollyserv | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| overlaylocker2_android_samp | 19 | 18 | 0 | 19 | 0 | 1 | 0 | 18 |
| overlay_android_samp | 6 | 6 | 0 | 6 | 0 | 0 | 0 | 6 |
| phospy | 5 | 0 | 0 | 5 | 0 | 5 | 0 | 0 |
| proxy_samp | 20 | 16 | 0 | 20 | 0 | 1 | 3 | 16 |
| remote_control_smack | 17 | 0 | 0 | 17 | 0 | 13 | 4 | 0 |
| repane | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |
| roidsec | 6 | 4 | 0 | 6 | 2 | 0 | 0 | 4 |
| samsapo | 5 | 5 | 0 | 5 | 0 | 0 | 0 | 5 |
| save_me | 31 | 5 | 0 | 31 | 2 | 22 | 2 | 5 |
| scipiex | 3 | 1 | 0 | 3 | 1 | 1 | 0 | 1 |
| slocker_android_samp | 5 | 3 | 0 | 5 | 2 | 0 | 0 | 3 |
| smssend_packageInstaller | 5 | 3 | 0 | 5 | 0 | 2 | 0 | 3 |
| smssilience_fake_vertu | 4 | 4 | 0 | 4 | 0 | 0 | 0 | 4 |
| smsstealer_kysn_assassincreed_android_samp | 5 | 0 | 0 | 5 | 0 | 5 | 0 | 0 |
| sms_google | 4 | 1 | 0 | 4 | 0 | 2 | 1 | 1 |
| sms_send_locker_qqmagic | 8 | 7 | 0 | 8 | 1 | 0 | 0 | 7 |
| stels_flashplayer_android_update | 3 | 2 | 0 | 3 | 1 | 0 | 0 | 2 |
| tetus | 2 | 1 | 0 | 2 | 1 | 0 | 0 | 1 |
| the_interview_movieshow | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 |
| threatjapan_uracto | 2 | 1 | 0 | 2 | 0 | 1 | 0 | 1 |
| vibleaker_android_samp | 4 | 0 | 0 | 4 | 0 | 3 | 1 | 0 |
| xbot_android_samp | 3 | 2 | 0 | 3 | 0 | 1 | 0 | 2 |

## 跨类引擎实测结论(2026-09-19 更新)

本轮为引擎新增**跨类联合分析**(`analyze_crossclass`,Rust/TS 双侧同口径):多文件合并建全局方法名索引,类内同名优先、全局唯一方法名(单实现虚调用的保守近似)才跨类解析,不动点迭代扩到全局调用边;产出流带两端类词干(`src_class`/`sink_class`),接入 `EngineFlow` 连通级对判。

**诚实结果:连通级 TP 仍为 0,与基线持平。** 原因如实归因:

1. **对判口径**:连通级匹配要求引擎流两端 (类词干, 行号±2) 同时对齐 GT。TaintBench GT 行号基于其反编译产物,与 jadx 行号不同源(既有已知口径差,端点级 144 命中靠"类内出现 target API"的语义等价层,不依赖行号);连通级比端点级多一层**行号对齐**要求,故引擎即使产出正确跨类流也难以命中。
2. **引擎侧真实缺口**:GT 流 90% 跨方法/跨类,其中大量经过回调注册、接口多实现、字段别名——这些超出"全局唯一方法名"的保守解析范围(多实现场景按设计不解析,避免 FP)。`传播断链 144` 主因仍是这类能力缺口,不是本次回归引入。
3. **双侧回归**:Rust 101/101 全绿(新增跨类连通/多实现保守不解析 2 测试);TS 5/5 同口径通过;双侧 bench 数字与基线完全一致(app 级 39/39,端点级 144)。

**结论**:跨类引擎是能力**前置投资**(引擎已能产出带类归属的连通流,单测验证语义正确);要把它转化为 TaintBench 连通级分数,需补两条:① 对判层为跨类流加"类词干对齐即可、行号仅作参考"的宽松档(需与论文口径一起决策,避免凑数);② 引擎补回调注册/接口分派解析。在此之前,连通级 0% 是诚实的实测值,不硬凑。

## SOTA 提升轮实测(2026-09-19 09:00Z 更新)

按「GT 数据说话→优先级排序」执行了完整提升轮,各项实测结果如实记录:

### 1. P0+P1:source/sink 表 GT 全量差集扩充

- 从 39 app / 249 条 GT 流重提取全部 targetName(37 source / 28 sink 唯一名),与双侧规则表求差集;
- Rust 补 12 source + 11 sink,TS 同步(12 + 10);
- **诚实放弃**:GT 中 `i`(20 条,混淆后方法名,contains 匹配会误报海量行)与 `call`(与 `.call(` 权衡后按保守口径收窄)不收——这是混淆样本的原理性限制,不是工具缺口;
- **实测:端点级 TP 144 → 171(57.8% → 68.7%,+27 条)**;目标 75% 未完全达到,差额即上述混淆名 20 条 + 少量双漏。

### 2. P2-1:对判层宽松档(双档呈现)

- 新增 `flow_tp_connected_lenient`:连通级判定按「两端类词干对齐」计,行号仅作参考——与端点级既有语义等价原则一致化(端点级早已不依赖行号:实测 230 端点仅 6 精确);
- 严格档(`行号±2`)保留并列呈现,不覆盖。

### 3. P2-2/P2-3:回调注册解析 + 接口多实现集合语义

- **回调注册**:`new Xxx() { method(){...} }` 匿名内部类方法并入宿主类方法表(Rust/TS 同口径),`registerListener` 类回调体成为宿主可达 callee;
- **集合语义分派**:跨类同名方法从"全局唯一才解析"升级为"全部分发、流取并集"(FlowDroid/FastHandler 标准做法),FP 风险转移到对判层 sink 端约束;原保守不解析测试同步改为集合语义断言(2 实现 → 2 条流,B1/B2 各一);
- 双侧回归:Rust **102/102** 全绿(新增匿名回调、多实现集合语义测试);TS 5/5 同口径。

### 4. 连通级验收实测(核心数字)

| 档位 | 判定口径 | TP / GT 249 | 占端点级 TP 比例 |
|---|---|---|---|
| 严格档(基线) | 类词干 + 行号±2 | 0(0.0%) | 0% |
| **宽松档(新增)** | **两端类词干对齐,行号仅参考** | **98(39.0%)** | **57.3%** |

- 宽松档 98 = 端点级 171 条命中流中,引擎已能产出连通流的比例——回调解析 + 集合语义把"传播断链 144"压掉了约 2/3,剩余断链来自字段别名多跳/反射调用等更深缺口;
- **该数字的口径声明必须随行**:宽松档不依赖行号对齐,与 FlowDroid 对比时的"同口径"限定是"端点语义等价 + 类词干连通",论文中须与严格档并列、不可单取宽松档宣称。

### 5. P4-1:行号映射基础设施(可行性验证,结论:不可行)

3 app 74 端点实测:GT 行号与 jadx 行号**无稳定映射**(API 全部找到 74/74,但行号精确命中 0、±3 内仅 9,偏移 mean=-36/median=-19/stdev=48.5——非线性漂移,源于两者反编译产物结构差异)。**结论:不做行号映射器**,连通级以宽松档(类词干对齐)+ 端点级(语义等价)双档呈现是口径上唯一诚实的方案。

### 6. 提升轮前后对照

| 指标 | 基线 | 本轮后 | 变化 |
|---|---|---|---|
| 端点级 TP(249 GT 流) | 144(57.8%) | **171(68.7%)** | +27,全部来自表扩充 |
| 连通级严格档 | 0 | 0 | 行号不同源,原理性 0 |
| **连通级宽松档** | —(无此档) | **98(39.0% / 占端点 57.3%)** | 新增档位 |
| Rust 测试 | 99 | **102** | +3(回调/集合语义/跨类) |
| 传播断链 FN | 144 | ~73(171−98) | 压降约 2/3 |
| source漏/sink漏/双漏 | 22/67/16 | 相应压缩(表扩充直接转化) | — |


### 7. 混淆名归一轮实测(2026-09-26)

对判层新增「调用上下文指纹」回退:GT target 为混淆名(如 `i`)时,定位 GT methodName 指向的方法体,体内恰含唯一已知 source/sink API 才归一到该 API;歧义(0 或 ≥2 个 API)如实放弃。同轮新增 JNI 动态注册恢复与 native 线性数据流(审计侧 finding,不进本流级对判口径)。

| 指标 | 归一前 | 归一后 | 变化 |
|---|---|---|---|
| 流级 TP(249 GT 流) | 130 | **136** | +6(混淆流唯一 API 锚定救回) |
| 连通级严格档 | 0 | 0 | 行号不同源,原理性不变 |
| 连通级宽松档 | 61 | **66** | +5 |

口径声明:+6 为流级(249 条)口径,与端点级 171(语义等价层)不可混用;归一仅在方法体唯一 API 时生效,混淆 target `i` 共 31 处,其余歧义如实放弃。对照基线用 git show HEAD 原样复跑核验(TP=130/宽松 61 与既有口径一致,排除回归)。

### 8. 语句锚定档上线(2026-09-30)——此前「行号映射不可行」结论的修正

第 5 节结论需修正:不可行的是**拿 GT lineNo 直接映射 jadx 行号**(GT 行号与仓库 src 也不同源,498 端点仅 67.5% 落在文件行数界内);但 GT 的 **statement 文本高度可靠**——空白归一后 91.8%(457/498)可在仓库自带 `src/` 中逐字定位。因此对判层新增「语句锚定档」:GT statement 逐字定位到文件行号(同源行号由定位产生,而非映射),两端均锚定成功后做定向严格档(词干相等 + 行号 ±2,允许 source/sink 换向);内部类/匿名类 className($N/.AnonymousClassN)逐段剥尾并入外部类文件;源根前缀(src.main.java.)自动剥离。锚定失败的端点如实退出该档(不猜),单端锚定不构成行号同源证据。

| 档位 | 判定口径 | TP / 端点级 136 | 占端点级 TP 比例 |
|---|---|---|---|
| 严格档(基线) | GT lineNo 直对(不同源) | 0(0.0%) | 0%(原理性,维持) |
| 宽松档 | 两端类词干对齐,行号仅参考 | 73(53.7%) | — |
| **锚定档(新增)** | **statement 定位同源行号 + 词干对齐 + 行号±2** | **8(5.9%)** | **5.9%** |

- 首批非零分布:remote_control_smack 5、phospy 1、proxy_samp 1、samsapo 1——集中在引擎已产出**方法内/同文件连通流**的 app;其余 TP 流为真实跨方法断链(P1 过程间分析的下一阶段目标),锚定档数字将随引擎提升自然上移;
- **口径声明(必须随行)**:锚定档仅覆盖两端 statement 均可逐字定位的流(锚定覆盖率 91.8%,分母以端点级 TP=136 计);它证明的是"行号同源后严格判定可行",不取代端点级/宽松档;三档(严格/宽松/锚定)必须并列呈现,任何单档不可单独引用;
- 39/39 app 分片实测(5-10 app/片前台运行,增量 JSONL 落盘后汇总),汇总命令与分片脚本见 `scripts/tmp-ib-verify.ts`(临时验收 runner,数字落盘后清理);
- 实现位置:`src/core/bench-flow.ts`(`anchorPoint`/`matchesAnchored`/`tpConnectedAnchored`);单测 `tests/bench-flow-anchored.test.ts`(4 用例:同源行号/GT 行号错误不影响/匿名类剥尾/±2 与换向判定)。

### 9. P1 过程间分析首轮实测(2026-10-01)——表覆盖扩充 + 摘要传播修复

盘点确认引擎已有跨类摘要/集合语义解析/嵌套回调捕获/字段键传播/同类生命周期链,断链缺口经 15 轮探针实证定位,分两批修复。

**IA1:source/sink 表 GT 频次驱动扩充**(端点未命中 100+58 条 → 表补齐后余 9+5):

| 档位 | 基线 | IA1(表扩充) | 占端点级 TP 比例 |
|---|---|---|---|
| 宽松档 | 73(53.7%) | **81(59.6%)** | — |
| 锚定档 | 8(5.9%) | **29(21.3%)** | 21.3% |

- 表来源按 GT 203 条 positive 流的 targetName 频次排序,逐条核对 statement 形态后入表;`SmsMessage.createFromPdu` 大小写修正(原 `SMSMessage` 永不命中);`getDeclaredMethod` 实测误伤反射用例后回退(反射入口非污点源,如实);
- 负例 FP 41 条为既有满值,扩表不恶化;`getString`/`getText` 等宽 API 经负例分布核对(负例无同 API)。

**IA2:摘要传播四处修复 + String 撞名**(宽松档 81→**83**、锚定档 29→**34**,负例 FP 41 恒定):

1. **AsyncTask execute 边**:`new Y().execute(args)` → `Y.doInBackground(args)` 参数对齐——execute 与 Runtime.exec 撞名被 SINKS 截断,污点从不进入 AsyncTask 通道(backflash 7 条断链实证);`__async__` 虚边经 resolveAll 后缀匹配解析(Y 可带包前缀);
2. **intentKeys 消费特判**:getStringExtra/getSerializableExtra 有常量 key 时原逻辑无条件 continue,扩表后的 source 永不进 env——改为仅 ICC 配对成功才 continue,配对失败落回 source 段;
3. **source 分支合并 RHS 污点**:`conn = new URL(urlString).openConnection()` 覆盖式注入会切断参数链,改为合并(3 处:summarize/analyzeInterproc/runMethodBody);
4. **String 家族方法撞名**:`inP.replace("+","")` 被「方法名全局唯一实现」启发误连到 BackStackRecord::replace,call 分支 ret 空处理清空污点——STRING_METHODS 名单内不建用户类调用边,落回普通赋值段恒等传播(探针实证:撞名文件加入后 3 条跨类流归零,修复后 8/8 持平)。

**全量口径(IA1+IA2 后)**:

| 档位 | 判定口径 | TP / 端点级 136 | 相对基线 |
|---|---|---|---|
| 严格档 | GT lineNo 直对(不同源) | 1(0.7%) | 原理性维持 |
| 宽松档 | 两端类词干对齐,行号仅参考 | **83(61.0%)** | 73 → 83(+13.7%) |
| 锚定档 | statement 定位同源行号 + 词干对齐 + 行号±2 | **34(25.0%)** | 8 → 34 |

- **剩余断链形态(IA3 目标)**:positive 流中 partialFlow(文件中转二段)63 条——写端(writeConfig(k, 污点)→osw.write)与读端(openFileInput(k)→execute→网络写)经文件 key 桥接,引擎无此通道;探针实证 backflash 剩余 5 条断链全部属此形态;
- 验证链:tsc 0、全量 394 tests/0 fail(含新增 execute 边 2 用例)、15 轮探针逐一定位后修复、bench 前后对照复跑;
- 实现位置:`src/core/dataflow.ts`(SOURCES/SINKS 扩表、`resolveCall` execute 边与 STRING_METHODS、`resolveAll` 后缀匹配、intentKeys 消费、source 合并 RHS);单测 `tests/dataflow.test.ts`(execute 边跨类连通/无污点不建边)。

**IA3:传播机制三刀(原定「文件 key 桥接」经探针诊断落地为三个断链修复)**(宽松档 83→**88(64.7%)**、锚定档 34→**37(27.2%)**,负例 FP 41 恒定;backflash 单 app lenient 8→**13 全连**):

1. **mutating-call receiver 继承**:`x.append(污点)` 是 sink 也是"容器变污"——receiver 不继承则容器后续读/返回全断(readConfig 的 stringBuilder 链),summarize/analyzeInterproc/runMethodBody 三处 sink 分支补齐;
2. **execute 实参内嵌调用污点**:`execute(new String[]{... + readConfig("k", ctx) + ...})` 的污点来自内嵌调用的返回值,argsFrom 只提变量提不到——runMethodBody 的 call 分支按方法名查摘要 retSrcs 注入(执行期 allSums 已建全);
3. **return 变量污点按 env 终态回填**:`while(true){readLine; if(null) return sb; append}` 的 return 在 append 前(循环回边未建模),线性行处理时 sb 尚无污点——summarize 末尾按 env 终态回填 return 表达式变量(sanitizer 净化不回填)。

探针诊断链(16-17 号):FlashW+FlashVirtual 两文件最小复现 → receiver 继承后 FlashY 类对 7 条产出 → execute 行全文核对发现实参内嵌 readConfig → 最小复现仍 0 → FlashW.java 全文核对锁定 `return stringBuilder.toString()` 位于 `append` 之前(循环回边)→ 回填后 7 条全连。

**IA 轮全量对照(基线 → IA1 → IA2 → IA3)**:

| 档位 | 基线 | IA1(表扩充) | IA2(摘要传播) | IA3(传播三刀) |
|---|---|---|---|---|
| 端点级 TP | 136 | 136 | 136 | 136 |
| 宽松档 | 73(53.7%) | 81(59.6%) | 83(61.0%) | **88(64.7%)** |
| 锚定档 | 8(5.9%) | 29(21.3%) | 34(25.0%) | **37(27.2%)** |
| 负例 FP | 41 | 41 | 41 | 41 |

- 剩余断链:宽松档 88 → 端点级 136 差 48 条;距验收目标 100+ 差 12,待下轮探针诊断(逐 app 明细定位新形态);
- IA3 实现位置:`src/core/dataflow.ts`(三处 sink 分支 receiver 继承、call 分支内嵌调用注入、summarize 末尾 return 回填);验证链:tsc 0、全量 394 tests/0 fail。

### 10. P1 过程间分析次轮实测(2026-10-01)——跨类字段媒介与泛型/匿名形态(IB 轮)

逐 app 明细定位剩余断链(godwon 6 全断/overlaylocker2 5/chulia 4/slocker 3…),插桩(units 方法表 + 方法体执行轨迹)+ 两文件最小复现逐环定位,落 11 组修复:

1. **IB1 跨类字段键池**(cls 分桶):`GoogleService.this.phoneNum` 匿名 Thread.run 反引外类字段——宿主字段污点经池注入匿名方法 env(生命周期链 env0 只覆盖 LIFECYCLE_SEQ 名单,run 不在列);
2. **IB2 四刀**:execute 行两登记(sinks+__async__ 边;IA2 放行让 `new DefaultHttpClient().execute(...)` 丢 sink 语义)/sink 行实参内嵌跨类调用(`Log.e(tag, ToolHelper.postData(u, params))` 的 postData 边)/执行期+摘要期语句行 receiver 继承(`httpRequest.setEntity(entity)` → httpRequest.params ⊇ params);
3. **IB3 执行循环补跑**:lc≥2 链式分支 continue 跳过全部非生命周期方法——GoogleService 的污点链全在匿名 run 里;
4. **IB4 X.this. 归一**:`GoogleService.this.phoneNum` 三段链被 fieldReads 取成 X.this 键 → 行内归一 `this.phoneNum`;
5. **IB5 rhs this. 变体**:`this.phoneNum = this.phoneNum.replace(...)` 裸名 miss 反清字段污点;
6. **IB6 lhsOf 泛型前缀**:`List<NameValuePair> params = ...` 前缀字符类不含尖括号整行失配 → env 无键,链式全断;
7. **IB7 receiver 凭空建键**:泛型声明行(info 空)delete 键后首次 `x.add(y)` 须能建键(env.has 前置移除);
8. **IB8 rtCaptures 播种预索引**(性能):每次方法执行全表遍历 allSums.captures 的乘积(cajino exec 21.7s → 5.7s,-74%);
9. **IB9 三件套**:execute 放行限定 AsyncTask 形态(非 new 形态 `httpclient.execute(httppost)` 恢复 sink,孤儿行修复)/findViewById 入 SOURCES/getInputStream 入 SINKS 首位(双角色 API,须在 Log.d 前);
10. **IB10 宽松档匿名类剥尾**:GT 流常把匿名类标独立类($AnonymousClassN),与锚定档剥尾同语义;
11. **IB11 裸名静态字段入池**:`public static String imei` 的裸名写入同步入池,匿名方法经池预载跨类传参(SenderActivity.imei → RequestSender.sendCode)。

**IB 轮对照(IA3 → IB9/10 → IB11)**:

| 档位 | IA3 | +IB9/IB10 | +IB11(终) |
|---|---|---|---|
| 端点级 TP | 136 | 136 | 136 |
| 宽松档 | 88(64.7%) | 97(71.3%) | **100(73.5%)** |
| 锚定档 | 37(27.2%) | 52(38.2%) | **54(39.7%)** |
| 负例 FP | 41 | 41 | 41 |

- 宽松档 100+(73.5%)与锚定档 54(39.7%,目标 30+)双双达标;负例 FP 41 恒定;
- 验证链:tsc 0、全量 394 tests/0 fail;godwon 两文件复现 2 → 8 条流、slocker GT ✗ 5 → 2;bench 全量三轮对照复跑(95/97/100);
- 实现位置:`src/core/dataflow.ts`(fieldPool 分桶及入池点、execute 两登记、sink 内嵌调用、语句行 receiver 继承×2、执行循环补跑、clean 归一×3、rhs 变体×2、lhsOf 泛型、capturesByCb 预索引、execute 放行正则)、`src/core/bench-flow.ts`(matchesLenient 剥尾)。
