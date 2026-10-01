# DroidSeal 后续规划(2026-09-30 盘点后定稿)

> 纪律:每项须有「改动前数字 → 改动后数字」实测对比;验收数字未出不得标完成;
> 能力宣称必须有产物/真机背书,vmProtected 在 VMP 注入链(里程碑 B)真机验收全绿前恒 false。
> 发布纪律(用户明确要求):**不进行任何上传和发布,产物只留本地;commit 消息与代码不得出现 atomcode 痕迹。**

## 现状基线(2026-09-30)

- 全量测试 392 pass / 0 fail,`tsc` 0(提交 `5850f44`)
- 模拟器矩阵(API 24):standard / keystore / challenge 在线格全 `Displayed`,challenge 离线格 fail-closed 实测杀进程(docs/device-testing.md 实测节)
- 审计引擎(TaintBench 39 app / 249 GT 流):端点级 TP=136(54.6%);连通级宽松档 73(39.0%)、锚定档 8(5.9%)、严格档 0(原理性);良性对照 434 case 数据流层 FP=0
- vmProtected=false(绑定 VMP 注入链,矩阵全绿验证的是壳加载链 runtimeProtected,二者无关)

## P0 · 短板收尾(当前主攻,1-2 轮)

| # | 项 | 内容 | 验收判据 |
|---|---|---|---|
| P0-1 | D4 补跑 | KS 绑定产物(ks11 已在,或重建)跑 device-test.sh `--ks-relaunch`:unseal → XOR part3 → 还原二次启动 | D4 PASS 落档 device-testing.md |
| P0-2 | 矩阵脚本复跑 | `scripts/device-matrix.sh` 用修复后代码全流程重跑(本轮验收是手工分步,脚本未整体走通) | 脚本 exit 0,SKIP/FAIL 如实;脚本临时依赖(build-*.cmd 已删)需内建 |
| P0-3 | challenge 在线端点自动化 | 本轮 TLS 端点/CA 注入是手工步骤,tmp-challenge-tls.ts 已删;把 challenge-server 脚本化进 scripts/(仓库内,无密钥) | 一条命令起端点+注入 CA+跑在线格 |

完成 P0 后按序进入 P1(用户已确认 P0 优先)。

## P1 · 过程间分析 IA(宽松档 73 → 100+)

跨方法断链是当前最大 FN 来源(flow-report 第 8 节定位)。

1. **IA-1 类内调用图**:同文件直调 / 接口单实现;Rust 与 TS 双侧同步
2. **IA-2 跨方法传播**:方法级 source→sink 摘要(summary-based),不做指针分析
3. **IA-3 回调生命周期贯通**:P1-b 不动点扩展到跨类回调链

验收:宽松档 73→100+(≥40%);锚定档 8→30+;双侧对拍全绿;三档口径并列随行。

## P2 · native 半语义 IC

NATIVE_DATAFLOW 线性启发式(confidence: low)→ JNI 桥参数追踪 + 动态注册表符号解析,升 confidence: medium,独立报告节。

## P3 · VMP 里程碑 B(单独轮次,风险最高)

RegisterNatives 桥已生成(构建期)。缺:ACC_NATIVE 标记写入 → SO 注入链 → `--vm-mode` 真机断言。
**唯一能翻 vmProtected 的路**;验收 = vm-mode 矩阵全绿,否则维持 false。

## P4 · 评测科学化(依赖 P1/P2 数字刷新)

混淆变体基准(ProGuard/R8 两档)、变异元评测扩展、MASTG 全集对照表;论文「三档并列」图表。

## 依赖关系

P0(独立,先行)→ P1 ∥ P2(可并行)→ P3(依赖 P0-2 矩阵脚本,单独轮次)→ P4(依赖 P1/P2 数字)。
