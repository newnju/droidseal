# DroidSeal · 安卓发布封签

[English](README.md) | [中文](README.zh-CN.md)

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-181717.svg?logo=github&logoColor=white)](https://github.com/noontiger/droidseal/blob/main/LICENSE)
[![npm](https://img.shields.io/npm/v/droidseal.svg?logo=npm&logoColor=white&color=cb3837)](https://www.npmjs.com/package/droidseal)
[![PyPI](https://img.shields.io/pypi/v/droidseal.svg?logo=pypi&logoColor=white&color=3775a9)](https://pypi.org/project/droidseal)

**安卓发布封签**帮你完成商业加固前能做的大多数事——环境诊断、源码与 APK 审计、R8 混淆、zipalign 对齐、apksigner 签名与最终验证，商业加固前，一键端到端。

## 能做什么

- **审计**：项目与 APK 静态审计——权限、targetSdk、签名方案、硬编码密钥、DEX/TLS 启发式、Native so 加固、第三方依赖与 CycloneDX SBOM；
- **发布**：按官方顺序执行 `zipalign → apksigner 签名 → 验证`，失败自动回退，每步独立制品；
- **产物**：APK + SHA-256 + JSON/Markdown 报告 + 发布门禁 + SBOM。

<img width="960" alt="DroidSeal 界面截图" src="droidseal-screenshot.png" />

## 安装

| 渠道 | 方式 |
|---|---|
| npm | `npm install --global droidseal` |
| PyPI | `pip install droidseal` |
| GitHub Releases | 直接下载 Windows zip / Linux tar.gz |

> **Windows 提示**：双击 exe 被 SmartScreen 拦截时，右键 → 属性 → 解除锁定。TUI 需在终端中运行：PowerShell 执行 `droidseal`，或双击随包附带的 `droidseal-gui.cmd` 启动器。

## 使用

```powershell
droidseal              # 交互式 TUI 向导（一键 / 分步）
droidseal doctor       # 非交互环境诊断
droidseal --version
```

### APK 加固模式（可选）

`droidseal <input.apk> --output <dir> --cert-sha256 <sha256> --keystore <jks> --ks-alias <alias> --ks-pass <pass> --key-pass <pass>`

对 release APK 做运行时加固：DEX payload 加密（AES-256-GCM，逐条目 HKDF 派生密钥）、随机化引导壳（双 DEX：明文 stub 运行时解密加载 assets 中的加密 loader）、壳入口类 / 容器 magic / meta 键逐构建随机化、方法 CodeItem 抽取、可选 NDK 将 Split-Key part2 异位进原生库。每次构建都输出如实的 findings 报告——未实现的能力一律如实标注，绝不虚报为防护。

**AI 时代的加固层**（设计目标：篡改产生错误密钥而非警告——没有可被工具"读懂再绕过"的显式逻辑）：

- **完整性锚点参与密钥派生**：最终二进制 `AndroidManifest.xml` 的 SHA-256 折入每条目 HKDF info。重打包必改 manifest → 密钥错 → GCM 静默失败（P0-A）。
- **环境门控参与密钥派生**：运行时反分析投票（Java 检测 + native fork 跨进程读父进程 TracerPid / 端口探测 / maps 扫描 + debuggable 标志）折入同一 HKDF info。挂上 Frida 后派生的密钥就是错的——没有可定位的信号（P0-B）。
- **密钥分片化**：master 密钥逐条目临时合成、用后立即清零；任意时刻内存无完整密钥，解密后的 DEX 缓冲在类加载完成后即刻清零（P0-C）。
- **冗余异构检测**：三个独立源（Java / native C / 系统标志）读取路径各异——绕过单一源不影响投票结果（P1）。注意：native 端口探测检查本机 27042/27043（Frida 默认端口）；同设备上其他进程恰好在监听这些端口（例如正在调试**另一个**应用）可能造成误判。

| 开关 | 作用 |
|---|---|
| `--cert-sha256 <hex>` | 签名证书指纹；密钥由其派生——**换证书重签会导致解密失败（设计使然）** |
| `--no-random-names` | 保留固定壳标识符（仅调试用） |
| `--no-triple-entry` | 跳过额外壳入口 hook |
| `--keystore-bind` | 首次运行后用 Android Keystore 封存密钥片段——重装 / 换机即失效 |
| `--challenge-url <url>` | 服务端挑战（可选）：密钥第三段 part3 从 APK 中剥离，由你的 HTTPS 端点校验调用方 manifest 哈希后发放；构建产物含 `server-challenge.json` 供部署——**该文件丢失则此构建永久无法解密**。参考服务器：`scripts/challenge-server.ts`。**如实边界**：manifest 哈希可从 APK 公开算出，该校验**不是身份认证**——只能阻止*其他* APK 错拿本构建的 part3；同时持有 APK 与 `server-challenge.json` 者可离线还原密钥，请将该文件当密钥材料对待（离线保存、严禁提交进仓库）。 |

**预期管理**：加固提高逆向成本，而非使逆向不可能。root + Frida 环境下内存 DEX dump 无法被任何离线加壳方案完全防住——上述各层只是收窄窗口、污染被篡改环境，技术足够且能长期物理接触的攻击者最终仍能得手。`minSdk < 26` 自动降级为落盘 `DexClassLoader`（仍可运行，隔离性略弱）。服务端挑战可做限流，但端点可用性成为运行时依赖（离线设备无法解密）。真机安装是唯一可信验收。

## 平台与状态

- **平台**：Windows x64 / Linux x64；
- **状态**：1.0.1 正式版——CLI、输出目录与报告格式现已稳定；
- **软件要求**：支持 ANSI/Unicode 的交互式等宽字体终端（TUI 必需）；源码运行需 Bun 1.3+；JDK/Gradle/Android Build Tools 按流程自动发现或下载（Node 仅 Capacitor Web 构建时）；
- **硬件（实用建议，非硬性下限）**：约 500 MB 磁盘（100 MB 可执行文件 + 工具链 + 产物）、≥2 GB 内存（大 APK 更高——解析内存敏感，带失败安全上限）、x64 双核 CPU。

## 定位与对比

Android 安全工具分两条赛道：**审计**（MobSF、AndroBugs、APKiD——只分析、不改写）与**加固**（商业：DexGuard / DexProtector / 360 加固保；开源：Jiagu、nmmp、dpt-shell、XopProtector——改写 APK）。DroidSeal 有意横跨两条赛道——在一条全离线流水线里做到这一点，开源阵营没有第二个项目。

| 赛道 | 最接近的对标 | DroidSeal 的增量 |
|---|---|---|
| 审计 | MobSF（分析最深，~19k★）、AndroBugs、APKiD | 审计结论直接驱动**同一工具链内的修复**：审计 → remediation 报告 → R8 → 加固 → 重签 → 复验，附 CycloneDX SBOM 与发布证据链（releaseDecision / remediation）。MobSF 停在报告这一步。无动态分析 / 污点分析 / iOS——这些请用 MobSF。 |
| 加固（开源） | dpt-shell（方法级）、nmmp（VMP）、XopProtector | **密钥化防御**：完整性锚点与反分析投票折入逐条目密钥派生（P0-A/B/C、P1）——patch 掉检测代码会让环境"恢复干净"从而密钥正确，但不 patch 直接挂 Frida 派生的就是**错钥**。主流壳是"检测→警告"，绕过检测零成本。另有：密钥分片（part2 入 SO、part3 可选出 APK）、Keystore 设备绑定、诚实 findings。 |
| 加固（商业） | DexGuard、DexProtector、360 加固保 | 完全**离线**（代码不出本机——这是团队选择开源加固而非云服务的首要原因）、行为可审计、无按应用计费。代价：无 VMP/白盒密码、实战验证较少、无 SLA。 |

**DroidSeal 不参与竞争的场景（如实边界）**：

- 需要"master 密钥被内存 dump 后仍不可读"的 VMP 级防护？用 nmmp 或 DexGuard——DroidSeal 明确不投入白盒 AES 与 VM 保护；root + 持久物理接触下，技术足够强的攻击者最终仍能得手。
- 做恶意 App 鉴别或动态行为分析？用 MobSF + APKiD——DroidSeal 只审计与加固，不做沙箱。
- 高风险产品需要合同化支持/SLA？项目尚早期（真机验收、独立安全审计、社区规模都还在路上）——这类需求选商业厂商更稳妥。

**一句话总结**：作为离线"审计→加固→签名→验证"流水线没有对手；加固强度居中游；密钥化防御是差异化亮点；成熟度是最大短板。

## 测试与验收

成熟度在这里的定义是"**声明过的能力 = 实测过的能力**"——三层验证,由廉价到昂贵:

| 层 | 工具 | 运行时机 | 证明什么 |
|---|---|---|---|
| 单元 + 回归 | `bun test` | 每次改动(CI core job) | 密码学布局、URL 补丁、容器格式不变量 |
| 安全对抗回归 | `bun test tests/security-regression.test.ts` | 每个安全修复必附 | 每个被接受的安全修复必须携带 `SEC-XX` 用例复现其*触发条件*(修复前红、修复后绿;政策见 [SECURITY.zh-CN.md](SECURITY.zh-CN.md),完整修复历史见[公开安全台账](docs/security-ledger.zh-CN.md))——覆盖 C1(生成 native 源无 PTRACE_TRACEME)、C3(pre-XOR 封存顺序)、C4(等长 debuggable 翻转)、C5(白名单冒烟常驻)、R2/R3 |
| 产物基线 | `bun scripts/verify-harden-artifact.ts <apk>` | 每次加固构建之后 | 加密 loader 存在且 stored(H1/H2)、容器 stored 且 magic 合法(H3/H4)、明文 DEX 无密钥材料(H5)、壳 manifest 存在(H6);`--expect-plain` 断言*未*加固 APK |
| 真机验收 | `bash scripts/device-test.sh <apk> <包名> [--ks-relaunch]` | 真机/模拟器上 | 安装 → 5 秒存活解密启动闭环、无完整性/BadTag 标记、Keystore 绑定二次启动;完整矩阵与手动用例(重签必败、离线挑战 fail-closed、Frida)见 `docs/device-testing.md`;威胁面与残余风险见[威胁模型](docs/threat-model.zh-CN.md),构建级攻击实证见 `scripts/attack-sample-resign.ts`(重签必败,构建期可证) |

CI(`.github/workflows/ci.yml`)在每次 push/PR 上跑 `tsc --noEmit` + 全量测试 + npm pack 白名单冒烟,另有独立 NDK job 用真实 NDK 编译生成的 native 壳源码(含 `guard_vote.c`)——native 路径不再停留在纸面。发布:`bun scripts/release.ts <version> [--sync]` 只做本地验证与本地 git tag;上传(git push / npm publish)永远是人手动执行的显式步骤。

**如实边界**:构建期全绿 ≠ 运行时正确。上面第三层(真机)是唯一可信验收,且需要真实设备。

**模拟器实测记录(2026-09)**:首轮完整模拟器验收(API 26 x86_64)在 264/264 测试与 H1–H6 产物基线全绿的情况下**首启即崩**——修掉第一个缺陷后暴露第二个,再暴露第三个。共挖出并修复三个静态检查完全测不到的构建级缺陷([SEC-010](docs/security-ledger.zh-CN.md#sec-010--补丁后-payload-dex-未通过-art-校验和验证严重) 校验和/签名顺序颠倒、[SEC-011](docs/security-ledger.zh-CN.md#sec-011--方法抽取-stub-在节区边界留下非零填充严重) 抽取 stub 残留非零节区填充、[SEC-012](docs/security-ledger.zh-CN.md#sec-012--标识符随机化破坏-dex-string_ids-字典序严重) 随机改名破坏 string_ids 字典序)。三修齐备后复测:安装 PASS、首启 PASS、二次启动 PASS、logcat 失败标记 0、卸载干净(D1/D2/D3/D5)。这就是上面那条如实边界的实证:这一类缺陷只有设备层能抓住。

## 安全边界

防御性工具：默认不脱壳、不加壳、不注入 Hook / 反调试代码；完全本地运行，不上传 APK、路径或签名信息。

**例外——APK 加固模式（显式 opt-in）**：当你携带上方加固开关传入 APK 时，DroidSeal *会*加壳（DEX 加密 + 引导壳注入，仅针对**你自己的** release APK）并内嵌反分析检测。该模式只修改你显式提供的输入 APK；默认的审计/发布流程仍保持不加壳边界。

## 架构、创新与自研部分

### 创新亮点

1. **APK 格式处理全自研**:ZIP 中央目录、ARSC 资源表、AXML、DEX、ELF 的解析与改写全部自研(字节级),不依赖庞大解析器传递依赖(供应链收敛、失败语义明确);
2. **确定性后处理**:未修改的 ZIP 条目复用原始压缩字节,减少重排/重压缩/签名摘要的意外变化;
3. **失败可回退**:每步独立 APK 制品,"跳过并回退"保留步骤前有效产物;
4. **自研反调试桩**(C + Kotlin + CMake,可选源码集成);
5. **结果可审计**:签名验证 + SHA-256 + JSON/Markdown 报告 + CycloneDX SBOM + 置信度感知发布门禁;
6. **纯本地优先**:不上传 APK、路径或签名信息;默认不脱壳、不加壳、不注入;
7. **单二进制三渠道发布**:Bun 编译单文件 exe,运行时零 npm 依赖,npm/PyPI/GitHub Release 同源发布;
8. **双语 TUI + 三入口**(分步/一键/诊断)。

### 自研部分 vs 第三方调用

- **自研**(业务核心):`src/core`(30 个模块——ZIP/DEX/ELF/ARSC/AXML 解析与审计、流水线编排、签名策略、发布门禁)、`src/ui`(TUI + i18n)、反调试桩、`scripts`(构建/发布/门禁脚本)、双启动器;
- **第三方**(渲染/构建层):OpenTUI(终端渲染)、Solid.js(响应式 UI)、Terser(构建压缩,仅可选 Web JS 处理)、TypeScript/Bun(工具链)、外部 Android 工具(keytool/Gradle/zipalign/apksigner/aapt——经自研发现与校验编排)。

### 流水线可视化(每步自研/第三方)

路线从上到下弯折:左列 ①-⑦ 自上而下,底部「流向」折返后右列 ⑧-⑭ 自下而上(蛇形)。每步箱内标注「自研:…」或「第三方:…」。

```text
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ① 环境诊断                   │      │ ⑭ 生成报告                   │
│ 自研:工具发现/校验/恢复      │      │ 自研:报告/门禁/SBOM/修复包   │
└──────────────────────────────┘      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ② 准备工作区                 │      │ ⑬ 最终验证                   │
│ 自研:输入验证/APK 复制       │      │ 第三方:apksigner verify      │
└──────────────────────────────┘      │ 自研:SHA-256 计算/编排       │
                                      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ③ 签名库                     │      │ ⑫ APK 签名                   │
│ 第三方:keytool               │      │ 第三方:apksigner             │
│ 自研:密码安全                │      │ 自研:密钥处理/脱敏           │
└──────────────────────────────┘      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ④ 源码安全审计               │      │ ⑪ ZIP 对齐                   │
│ 自研:project-audit/r8-rules  │      │ 第三方:zipalign              │
└──────────────────────────────┘      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ⑤ 构建 Release APK           │      │ ⑩ 资源名混淆(可选)           │
│ 第三方:Gradle Wrapper        │      │ 自研:arsc-obfuscate          │
└──────────────────────────────┘      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ⑥ APK 安全审计               │      │ ⑨ Web JS 处理(可选)          │
│ 自研:ZIP/DEX/ELF/ARSC/AXML   │      │ 第三方:Terser 压缩           │
│ 第三方:aapt 补充             │      │ 自研:白名单/原子写出         │
└──────────────────────────────┘      └──────────────────────────────┘
                │                      ▲
                ▼                      │
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ ⑦ 本地安全防护               │      │ ⑧ Release 归一化             │
│ 自研:证据核验/置信度         │      │ 自研:Manifest 改写/调试清理  │
└──────────────────────────────┘      └──────────────────────────────┘
               └────────► flow ──►────┘
```

所有格式解析/改写/审计/报告均为自研(离线、低供应链依赖);渲染用 OpenTUI/Solid(第三方);外部工具只在官方强制环节调用,均经自研发现、SHA-256 校验与降级编排。

## 许可与品牌

- 开源许可：[Apache License 2.0](https://github.com/noontiger/droidseal/blob/main/LICENSE)
- 名称与 Logo 使用：[TRADEMARKS.md](https://github.com/noontiger/droidseal/blob/main/TRADEMARKS.md)（评测、教程、分享注明来源即可）
- 第三方声明：[THIRD_PARTY_NOTICES.md](https://github.com/noontiger/droidseal/blob/main/THIRD_PARTY_NOTICES.md)

<img src="https://raw.githubusercontent.com/noontiger/droidseal/main/droidseal-logo.png" width="420" alt="DroidSeal" />
