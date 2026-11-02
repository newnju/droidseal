# DroidSeal · 安卓发布封签

[English](README.md) | [中文](README.zh-CN.md)

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-181717.svg?logo=github&logoColor=white)](https://github.com/noontiger/droidseal/blob/main/LICENSE)
[![npm](https://img.shields.io/npm/v/droidseal.svg?logo=npm&logoColor=white&color=cb3837)](https://www.npmjs.com/package/droidseal)
[![PyPI](https://img.shields.io/pypi/v/droidseal.svg?logo=pypi&logoColor=white&color=3775a9)](https://pypi.org/project/droidseal)

**DroidSeal（安卓发布封签）** 是一个本地优先的 Android 发布安全流水线。它把静态审计、证据驱动的修复、可选运行时加固、官方顺序的对齐与签名，以及独立验证收敛到一条可复现的工作流中。目标不是替代商业加固，而是让商业加固前的发布路径可审计、可复现、失败关闭。

> **版本范围。** 本文档描述公开的 **1.0.1** 版本。仓库中可能包含早于或晚于本文档的开发提交，它们不属于 1.0.1。需要匹配源码时请使用 tag `v1.0.1`。版本专属证据与校验和记录在 [`docs/releases/v1.0.1.md`](docs/releases/v1.0.1.md)。

## 能做什么

- **审计**：项目与 APK 静态审计——权限、targetSdk、签名方案、硬编码密钥、DEX/TLS 启发式、Native `.so` 加固、第三方依赖与 CycloneDX SBOM；
- **发布**：按官方顺序执行 `zipalign → apksigner 签名 → 验证`，失败自动回退，每步独立制品；
- **产物**：APK + SHA-256 + JSON/Markdown 报告 + 发布门禁 + SBOM。

## 系统概览

![图 1. DroidSeal 本地优先发布流水线](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig1-pipeline.png)

**图 1. DroidSeal 发布流水线。** 发布契约在本机端到端执行；外部 Android 工具只在官方强制环节调用。该图是结构示意，不是基准测量结果。测量口径见[实测能力](#实测能力基准数字不是宣称)与 [`benchmark/`](benchmark/README.md)。

## 安装

| 渠道 | 方式 |
|---|---|
| npm | `npm install --global droidseal` |
| PyPI | `pip install droidseal` |
| GitHub Releases | 直接下载 Windows zip / Linux tar.gz |

> npm 包内为带完整性校验的单文件 bundle（`dist/droidseal.mjs`）：`droidseal` 启动器每次运行先校验 bundle 的 SHA-256（与构建元数据比对）再加载——需要 Node.js ≥ 18。安装后执行 `droidseal --version` 确认可用。

> **Windows 提示**：双击 exe 被 SmartScreen 拦截时，右键 → 属性 → 解除锁定。TUI 需在终端中运行：PowerShell 执行 `droidseal`，或双击随包附带的 `droidseal-gui.cmd` 启动器。

## 发布完整性与校验

发布制品随 SHA-256 摘要与源码 commit 一同发布。v1.0.1 的归档摘要如下：

| 制品 | SHA-256 |
|---|---|
| `droidseal-1.0.1-windows-x64.zip` | `6c52eefe820c167ddb8c2e7804c292e466c8b318e4b93a1a58108ba523f7814a` |
| `droidseal-1.0.1-linux-x64.tar.gz` | `530262d47177dd0cbcac0ead2cb7128587daf4707808a295e8a25f90a00ac3f8` |

安装前校验归档：

```powershell
Get-FileHash .\droidseal-1.0.1-windows-x64.zip -Algorithm SHA256
```

```bash
sha256sum droidseal-1.0.1-linux-x64.tar.gz
```

对发布流程产出的签名 APK，独立验证签名与证书：

```bash
apksigner verify --print-certs <output.apk>
```

npm 启动器每次运行都会校验 bundle 的 SHA-256 与固定构建元数据是否一致。校验和只把下载物绑定到发布记录，不证明运行时安全。v1.0.1 发布 commit 为 `0ff5fb3206e8d05d19de7e23e5c3985438efe41a`。

## 使用

```powershell
droidseal              # 交互式 TUI 向导（一键 / 分步）
droidseal doctor       # 非交互环境诊断
droidseal --version
```

## 界面

<img width="960" alt="DroidSeal 界面截图" src="https://raw.githubusercontent.com/noontiger/droidseal/main/droidseal-screenshot.png" />

TUI 是同一套非交互流水线的前端，不改变产物契约、发布门禁或证据要求。

### APK 加固模式（可选）

`droidseal <input.apk> --output <dir> --cert-sha256 <sha256> --keystore <jks> --ks-alias <alias> --ks-pass <pass> --key-pass <pass>`

对 release APK 做运行时加固：DEX payload 加密（AES-256-GCM，逐条目 HKDF 派生密钥）、随机化引导壳（双 DEX：明文 stub 运行时解密加载 assets 中的加密 loader）、壳入口类 / 容器 magic / meta 键逐构建随机化、方法 CodeItem 抽取、字符串加密与调用点改写，以及可选的 NDK Split-Key part2 异位进原生库。每次构建都输出如实的 findings 报告——未实现的能力一律如实标注，绝不虚报为防护。

**密钥化加固层**（设计目标：篡改产生错误密钥，而非可被读取再绕过的显式警告）：

- **完整性锚点参与密钥派生**：最终二进制 `AndroidManifest.xml` 的 SHA-256 折入每条目 HKDF info。重打包若改写 manifest，锚点即改变 → 密钥错 → GCM 静默失败（P0-A）。
- **环境门控参与密钥派生**：运行时反分析投票（Java 检测 + native fork 跨进程读父进程 TracerPid / 端口探测 / maps 扫描 + debuggable 标志）折入同一 HKDF info。投票绑定的是*环境配置*——ptrace 调试器（`TracerPid`）、带 root 的 Frida 框架或 `debuggable=true` 会改变投票状态，派生密钥随之错误，且没有可定位的显式信号（P0-B）。**如实口径（已测量）**：`frida-inject` 对单个 libc 函数的 gadget hook 不改变上述环境配置——投票保持诚实，应用按设计在 hook 下存活（25 秒主动插桩窗口、61 次 hooked read、零失败标记）；该投票是环境完整性输入，不是通用插桩检测器。
- **密钥分片化**：master 密钥逐条目临时合成、用后立即清零；任意时刻不保留完整 master 密钥，解密后的 DEX 缓冲在类加载完成后清零（P0-C）。
- **冗余异构检测**：三个独立源（Java / native C / 系统标志）读取路径各异——绕过单一源不影响投票结果（P1）。注意：native 端口探测检查本机 27042/27043（Frida 默认端口）；同设备上其他进程恰好在监听这些端口（例如正在调试**另一个**应用）可能造成误判。
- **VMP-lite（已接线子集）**：选定的 `(I)I` 叶子方法编译为 VM 字节码嵌入壳 SO，运行时经 `RegisterNatives` 注册；非 `(I)I` 方法保持 stub + 惰性还原。API 26 x86_64 模拟器验收记录为 5/5 注册通过，且 `vmLeaf(21)=120` 与原版一致。这不是全指令集 VMP；1.0.1 未跑更宽 API 矩阵。

| 开关 | 作用 |
|---|---|
| `--cert-sha256 <hex>` | 签名证书指纹；密钥由其派生——**换证书重签会导致解密失败（设计使然）** |
| `--no-random-names` | 保留固定壳标识符（仅调试用） |
| `--no-triple-entry` | 跳过额外壳入口 hook |
| `--keystore-bind` | 首次运行后用 Android Keystore 封存密钥片段——重装 / 换机即失效 |
| `--challenge-url <url>` | 可选服务端挑战：split-key part3 从 APK 中剥离，由你的 HTTPS 端点校验调用方 manifest 哈希后发放；构建产物含 `server-challenge.json` 供部署。**该文件丢失则此构建永久无法解密。** manifest 哈希可从 APK 公开算出，因此该校验**不是身份认证**，只能阻止*其他* APK 错拿本构建的 part3；请将 `server-challenge.json` 当密钥材料对待。 |

**密钥化防御与产物契约。** 图 2 把加固声明必须建立的两件事分开：运行时密钥派生模型（a）与构建后检查的最终归档契约（b）。模型是失败关闭的：manifest、环境投票或密钥分片被篡改都会改变派生密钥，于是 GCM 认证失败，而不是输出一条可绕过的警告。

![图 2. 密钥化防御与加固 APK 产物契约](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig2-keyed-artifact.png)

**图 2. 密钥化防御与加固 APK 产物契约。** a 展示构建期派生输入与干净/篡改两条运行时路径；b 把最终归档条目映射到 H1–H6 构建期门禁。H1–H6 是必要条件而非充分条件：设备安装/启动仍是验收门。完整证据阶梯见[测试与验收](#测试与验收)。

**预期管理**：加固提高逆向成本，而非使逆向不可能。root + Frida 环境下内存 DEX dump 无法被任何离线加壳方案完全防住。对 loader 做一次性语义 patch（硬编码构建期 manifest 哈希、诚实投票值与内嵌分片）或 dump-and-patch 攻击并未被密码学排除；设计保留的是逐次篡改成本，不是不可能性声明。`--challenge-url` 与 `--keystore-bind` 将派生输入外置，提高该成本；高保障场景应将其中之一作为基线。`minSdk < 26` 自动降级为落盘 `DexClassLoader`（仍可运行，隔离性略弱）。设备安装/启动是唯一可信验收。

## 平台与状态

- **平台**：Windows x64 / Linux x64；
- **状态**：1.0.1 正式版——CLI、输出目录与报告格式现已稳定；最新公开版本为 1.0.1；
- **软件要求**：支持 ANSI/Unicode 的交互式等宽字体终端（TUI 必需）；源码运行需 Bun 1.3+；JDK/Gradle/Android Build Tools 按流程自动发现或下载（Node 仅 Capacitor Web 构建时）；
- **硬件（实用建议，非硬性下限）**：约 500 MB 磁盘（100 MB 可执行文件 + 工具链 + 产物）、≥2 GB 内存（大 APK 更高——解析内存敏感，带失败安全上限）、x64 双核 CPU。

## 定位与对比

Android 安全工具分两条赛道：**审计**（MobSF、AndroBugs、APKiD——只分析、不改写）与**加固**（商业：DexGuard / DexProtector / 360 加固保；开源：Jiagu、nmmp、dpt-shell、XopProtector——改写 APK）。DroidSeal 有意横跨两条赛道——这种组合在开源项目中并不常见。

| 赛道 | 最接近的对标 | DroidSeal 的增量 |
|---|---|---|
| 审计 | MobSF（分析最深，~19k★）、AndroBugs、APKiD | 审计结论直接驱动**同一工具链内的修复**：审计 → remediation 报告 → R8 → 加固 → 重签 → 复验，附 CycloneDX SBOM 与发布证据链（releaseDecision / remediation）。MobSF 停在报告这一步。无动态沙箱 / iOS——这些请用 MobSF。 |
| 加固（开源） | dpt-shell（方法级）、nmmp（VMP）、XopProtector | **密钥化防御**：完整性锚点与反分析投票折入逐条目密钥派生（P0-A/B/C、P1）——patch 掉检测代码会让环境“恢复干净”从而密钥正确，但改变环境配置（带 root 的 Frida 框架、ptrace 调试器、`debuggable=true`）而不 patch，派生的就是**错钥**。主流壳多为“检测→警告”，绕过检测的成本可能很低。另有：密钥分片、VMP-lite 子集、诚实 findings。 |
| 加固（商业） | DexGuard、DexProtector、360 加固保 | 完全**离线**（代码不出本机——这是团队选择开源加固而非云服务的首要原因）、行为可审计、无按应用计费。代价：无完整 VMP/白盒密码、实战验证较少、无 SLA。 |

**DroidSeal 不参与竞争的场景（如实边界）**：

- 需要“master 密钥被内存 dump 后仍不可读”的全指令集 VMP 级防护？用 nmmp 或 DexGuard——DroidSeal 只交付 `(I)I` 叶子方法的 VMP-lite 子集，明确不投入白盒 AES 与全指令集 VM 保护；root + 持久物理接触下，技术足够强的攻击者最终仍能得手。
- 做恶意 App 鉴别或动态行为分析？用 MobSF + APKiD——DroidSeal 只审计与加固，不做沙箱。
- 高风险产品需要合同化支持/SLA？项目尚早期（真机验收、独立安全审计、社区规模都还在路上）——这类需求选商业厂商更稳妥。

**一句话总结**：本地优先的“审计→加固→签名→验证”流水线；加固强度居中游；密钥化防御是差异化亮点；成熟度是最大短板。

## 评测协议

![图 3. 发布声明的证据阶梯](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig3-evidence-ladder.png)

**图 3. 证据阶梯。** 每层回答不同问题：单元测试证明实现不变量；对抗回归证明某个修复关闭了特定触发条件；产物基线证明最终 APK 仍满足结构契约；设备验收是唯一能支撑运行时声明的层。该图是示意，实测值与口径在下方报告。

## 实测能力（基准数字，不是宣称）

以下数字来自 [`benchmark/`](benchmark/README.md) 下可复现的基准 harness；每项都随附测量口径——与工具对自身 finding 的要求同一纪律。这些是 1.0.1 的测量；开发线后续改动需重新跑基准后才能比较。

**审计（静态分析）**

| 能力 | 实测 | 口径 |
|---|---|---|
| 恶意流检测（TaintBench，39 app / 249 条 GT 流） | 端点级 TP 171/249（68.7%），流级 TP 136 | 端点级 = GT 类中出现 target API；流级 = 两端同时命中 |
| 误报率（434 个良性 app，AndroZoo VT=0 代理） | 数据流引擎层 FP = **0**（95% CI 上界 0.69%） | 只认数据流层；辅助配置类提示单列。这是 1.0.1 基线；比较后续分支前必须重跑 |
| 检测器基座（源码/配置/加固模式） | 379 条检测器，内置 38 用例基准精确率 76.9% / 召回 90.9% | 模式级，MSTG 映射 |
| JNI 动态注册恢复 | 注册表字符串邻近共现 + DEX 交叉验证 | 新 finding 类 `JNI_DYNAMIC_REGISTER`；静态符号扫描不可见的 native 攻击面 |
| native 线性数据流 | JNI 导出函数体 source→sink 共现 | **线性启发式，非指针分析**；设计上 `confidence: low` |

**加固（发布 APK，可选）**

| 层 | 状态 |
|---|---|
| DEX payload 加密（AES-256-GCM + HKDF，密钥化锚点 P0-A/B/C） | 已交付；模拟器验收，SEC-010/011/012 已修复并回归 |
| 方法抽取（code-item hollowing）+ 惰性还原 | 已交付；fail-open 回落全量还原 |
| 字符串加密 + 调用点改写（MUTF-8 安全密文 + 校验和重算） | 已交付；写回 apktool fail-closed |
| VMP-lite | 已接线 `(I)I` 叶子子集；VM 字节码嵌入壳 SO，经 `RegisterNatives` 注册；API 26 x86_64 模拟器验收（5/5 注册，`vmLeaf(21)=120`）；非 `(I)I` 方法保持 stub + 惰性还原；更宽 API 矩阵未跑 |
| 密钥化防御（完整性锚点 / 环境门控 / 密钥分片 / 可选服务端挑战 / Keystore 绑定） | 已交付，如实边界见上方加固章节 |

**数字的如实边界**：TaintBench 行号与 jadx 行号不同源（230 端点仅 6 个精确）——连通级对判因此分严格档（行号 ±2，历史上为 0）与宽松档（类词干对齐，66/249）双档呈现；宽松档不可单独引用。混淆 GT 方法名（`i`，31 处）仅当包装方法体恰含一个已知 source/sink API 时才恢复；歧义情形如实放弃，不猜。1.0.1 的误报测量早于开发线上的 sanitizer 变更，不能假定对后续 commit 仍成立。

## 测试与验收

成熟度在这里的定义是“**声明过的能力 = 实测过的能力**”——四层验证，由廉价到昂贵：

| 层 | 工具 | 运行时机 | 证明什么 |
|---|---|---|---|
| 单元 + 回归 | `bun test` | 每次改动（CI core job） | 密码学布局、URL 补丁、容器格式不变量 |
| 安全对抗回归 | `bun test tests/security-regression.test.ts` | 每个安全修复必附 | 每个被接受的安全修复必须携带 `SEC-XX` 用例复现其*触发条件*（修复前红、修复后绿；政策见 [SECURITY.zh-CN.md](SECURITY.zh-CN.md)，完整修复历史见[公开安全台账](docs/security-ledger.zh-CN.md)）——覆盖 C1（生成 native 源无 PTRACE_TRACEME）、C3（pre-XOR 封存顺序）、C4（等长 debuggable 翻转）、C5（白名单冒烟常驻）、R2/R3 |
| 产物基线 | `bun scripts/verify-harden-artifact.ts <apk>` | 每次加固构建之后 | 加密 loader 存在且 stored（H1/H2）、容器 stored 且 magic 合法（H3/H4）、明文 DEX 无密钥材料（H5）、壳 manifest 存在（H6）；`--expect-plain` 断言*未*加固 APK |
| 设备验收 | `bash scripts/device-test.sh <apk> <包名> [--ks-relaunch]` | 真机/模拟器上 | 安装 → 5 秒存活解密启动闭环、无完整性/BadTag 标记、Keystore 绑定二次启动，以及启用时的 VMP-lite 叶子断言；完整矩阵与手动用例（重签必败、离线挑战 fail-closed、Frida）见 `docs/device-testing.md`；威胁面与残余风险见[威胁模型](docs/threat-model.zh-CN.md)，构建级攻击实证见 `scripts/attack-sample-resign.ts`（重签必败，构建期可证） |

CI（`.github/workflows/ci.yml`）在每次 push/PR 上跑 `tsc --noEmit` + 全量测试 + npm pack 白名单冒烟，另有独立 NDK job 用真实 NDK 编译生成的 native 壳源码（含 `guard_vote.c`）——native 路径不再停留在纸面。发布：`bun scripts/release.ts <version> [--sync]` 只做本地验证与本地 git tag；上传（git push / npm publish）永远是人手动执行的显式步骤。

**如实边界**：构建期全绿 ≠ 运行时正确。上表设备层是唯一可信验收，且需要真机或模拟器。

**模拟器实测记录（2026-09）**：首轮完整模拟器验收（API 26 x86_64）在 264/264 测试与 H1–H6 产物基线全绿的情况下**首启即崩**——修掉第一个缺陷后暴露第二个，再暴露第三个。共挖出并修复三个静态检查完全测不到的构建级缺陷（[SEC-010](docs/security-ledger.zh-CN.md#sec-010--补丁后-payload-dex-未通过-art-校验和验证严重) 校验和/签名顺序颠倒、[SEC-011](docs/security-ledger.zh-CN.md#sec-011--方法抽取-stub-在节区边界留下非零填充严重) 抽取 stub 残留非零节区填充、[SEC-012](docs/security-ledger.zh-CN.md#sec-012--标识符随机化破坏-dex-string_ids-字典序严重) 随机改名破坏 string_ids 字典序）。三修齐备后复测：安装 PASS、首启 PASS、二次启动 PASS、logcat 失败标记 0、卸载干净（D1/D2/D3/D5）。这就是上面那条如实边界的实证：这一类缺陷只有设备层能抓住。

## 研究使用与可复现性

README 中的图是结构示意，不是测量结果。引用任何结论时，请记录准确的 tag 或 commit、宿主 OS、JDK/Android SDK/Build Tools 版本、输入 APK SHA-256 与输出制品 SHA-256。可复现 harness 位于 [`benchmark/`](benchmark/README.md)；安全修复与残余风险记录在[安全台账](docs/security-ledger.zh-CN.md)与[威胁模型](docs/threat-model.zh-CN.md)。引用 DroidSeal 时请引用准确 tag 与 commit，而不是移动的 `main` 分支。

## 安全边界

防御性工具：默认不脱壳、不加壳、不注入 Hook / 反调试代码；完全本地运行，不上传 APK、路径或签名信息。

**例外——APK 加固模式（显式 opt-in）**：当你携带上方加固开关传入 APK 时，DroidSeal *会*加壳（DEX 加密 + 引导壳注入，仅针对**你自己的** release APK）并内嵌反分析检测。该模式只修改你显式提供的输入 APK；默认的审计/发布流程仍保持不加壳边界。

## 架构、创新与自研部分

### 创新亮点

1. **APK 格式处理全自研**：ZIP 中央目录、ARSC 资源表、AXML、DEX、ELF 的解析与改写全部自研（字节级），不依赖庞大解析器传递依赖（供应链收敛、失败语义明确）；
2. **确定性后处理**：未修改的 ZIP 条目复用原始压缩字节，减少重排/重压缩/签名摘要的意外变化；
3. **失败可回退**：每步独立 APK 制品，“跳过并回退”保留步骤前有效产物；
4. **自研反调试桩**（C + Kotlin + CMake，可选源码集成）；
5. **结果可审计**：签名验证 + SHA-256 + JSON/Markdown 报告 + CycloneDX SBOM + 置信度感知发布门禁；
6. **纯本地优先**：不上传 APK、路径或签名信息；默认不脱壳、不加壳、不注入；
7. **单二进制三渠道发布**：Bun 编译单文件 exe，运行时零 npm 依赖，npm/PyPI/GitHub Release 同源发布；
8. **双语 TUI + 三入口**（分步/一键/诊断）。

### 自研部分 vs 第三方调用

- **自研**（业务核心）：`src/core`（139 个模块——ZIP/DEX/ELF/ARSC/AXML 解析与审计、流水线编排、签名策略、发布门禁、污点数据流、VMP-lite 编译器、JNI 动态注册恢复）、`src/ui`（TUI + i18n）、反调试桩、`scripts`（构建/发布/门禁/基准脚本）、双启动器；
- **第三方**（渲染/构建层）：OpenTUI（终端渲染）、Solid.js（响应式 UI）、Terser（构建压缩，仅可选 Web JS 处理）、TypeScript/Bun（工具链）、外部 Android 工具（keytool/Gradle/zipalign/apksigner/aapt——经自研发现与校验编排）。

### 流水线阶段与归属

图 1 是总览。下表记录各阶段的归属边界；外部工具只在 Android 工具链强制要求的环节调用。

| 阶段 | 步骤 | 自研 | 外部工具 |
|---|---|---|---|
| 诊断 | 1–2 | 环境/工具发现、工作区准备、输入验证 | — |
| 签名材料 | 3 | 凭据安全、脱敏 | keytool |
| 审计 | 4、6 | 项目与 APK 审计（ZIP/DEX/ELF/ARSC/AXML）、证据与置信度 | aapt 补充 |
| 构建与变换 | 5、8–10 | Manifest/调试归一化、ARSC 混淆、Web JS 白名单与原子写出 | Gradle Wrapper；Terser（可选） |
| 证据防护 | 7 | 证据与置信度处理 | — |
| 封签 | 11–12 | 密钥处理/脱敏、签名编排 | zipalign、apksigner |
| 验证 | 13 | SHA-256、签名与证书交叉校验 | apksigner verify |
| 报告 | 14 | JSON/Markdown/SARIF/SBOM、发布门禁、修复建议 | — |

所有格式解析、改写、审计与报告均为自研。渲染使用 OpenTUI/Solid；外部工具只在官方强制环节调用，并经自研发现、SHA-256 校验与优雅降级编排。

## 许可与品牌

- 开源许可：[Apache License 2.0](https://github.com/noontiger/droidseal/blob/main/LICENSE)
- 名称与 Logo 使用：[TRADEMARKS.md](https://github.com/noontiger/droidseal/blob/main/TRADEMARKS.md)（评测、教程、分享注明来源即可）
- 第三方声明：[THIRD_PARTY_NOTICES.md](https://github.com/noontiger/droidseal/blob/main/THIRD_PARTY_NOTICES.md)

<img src="https://raw.githubusercontent.com/noontiger/droidseal/main/droidseal-logo.png" width="420" alt="DroidSeal" />
