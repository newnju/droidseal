# Changelog

DroidSeal 的用户可见变化记录在本文件中。格式参考 Keep a Changelog；公开兼容性表面确定后，项目遵循语义化版本。

## [Unreleased]

（待发布）

## [1.0.1] - 2026-08-21

### Added

#### 审计与加固（静态审计扩展 / 加固能力）

- Native 加固检查深化：`.so` 未剥离符号表（`SO_UNSTRIPPED_SYMBOLS`）、含调试信息（`SO_DEBUG_INFO_PRESENT`）、疑似包含凭据格式字符串（`SO_CREDENTIAL_FORMAT`）；已剥离时给 `SO_STRIPPED_OK` 确认信号。
- 资源名混淆：Mode C 值级保守混淆（颜色 `#RRGGBB`→`#AARRGGBB`、维度 `Ndp`→`Ndip`，视觉不变）+ Mode D 目录保留式路径混淆（`res/drawable-hdpi/ic.png`→`res/a/a.png`，`pathMode: "flatten" | "scramble"` 选项）。
- ARSC 值级审计新增 `ARSC_VALUE_TECHNICAL` finding（key_/id_/token_ 等技术形态字符串值识别，仅审计不改写）。
- 新增打包器/保护器指纹识别（`PACKER_DETECTED`）：纯 TypeScript 指纹表（腾讯乐固/梆梆/爱加密/360 加固/DexProtector/DexGuard/阿里聚安全/娜迦/顶象/APKProtect/通付盾），提示静态审计可见性降级与商业加固核验，失败关闭。
- DEX 字符串安全子集接入主线：`DEX_STRING_SECURITY` finding（字符串池级可加密敏感串估计）衔接 `--from-audit` 加密桩生成。
- DEX 头结构只读校验（`DEX_HEADER_MALFORMED`，失败关闭）。
- 源码凭据格式启发式：AWS/Google/GitHub 令牌与 PEM 私钥块检测（`SOURCE_CREDENTIAL_FORMAT_*` / `SOURCE_PRIVATE_KEY_BLOCK`）。
- Web JS 处理支持 webpack 动态 import chunk 发现（白名单内懒加载产物纳入处理，有界单遍、容错解码）。
- DEX 方法/类级混淆受控子集：设计文档（`docs/dex-method-obfuscation-plan.md`，含真机验证矩阵与失败关闭边界）+ 白名单映射生成器（`scripts/generate-method-obfuscation-plan.ts`）。
- 源码侧字符串加密桩生成器（`scripts/generate-string-crypto-stub.ts`）：编译期加密、运行期解密，DEX 池不含明文敏感串；支持 `--from-audit` 自动提取审计发现的敏感串。
- 报告修复包建议动态化：`proguard-rules.suggestion.md` 与 `manifest-permissions.suggestion.md` 现带本次审计发现的具体项，前置于通用指引。

#### 发布工程化（门禁 / 证据 / SBOM / CI / 双模式）

- 新增发布预检脚本（`scripts/preflight.ts`）：一键运行 type-check / test / release-check 并逐项汇总。
- 发布流水线 CI 集成：CI verify 任务改用预检脚本，门禁与本地完全一致。
- 发布门禁新增加固覆盖度提示（`HARDENING_COVERAGE_LOW`）：核心审计/防护/验证步骤未真实执行时给 review 提示（不阻断）。
- 新增修复包复测闭环（`scripts/re-test.ts`）：`--before`/`--auto` 对比消除/新增/剩余 findings，并输出门禁建议。
- 新增经典 / 测试与学习双模式：经典模式清理中间 APK 只留最终 release 与报告；测试与学习模式（TUI 顶部切换按钮或 `--test-learning`）保留全部中间产物。
- 报告新增「加固成效」节：产物前后大小对比、DEX/SO 敏感项计数与加固覆盖度评分。
- AAB 输入显式检测：`AAB_INPUT_NOT_SUPPORTED`（含 bundletool/Gradle 转换指引）。
- 新增非交互流水线测试 runner（`scripts/test-runner.ts`）：apk/project × skip/existing + `--web`/`--arsc`/`--test-learning`，CI 可用。

#### 运行时防护（反调试 stub）

- 检测标记扩展（magisk/zygisk/lspd/riru/Sui），并新增五类只报告信号：`checkApkIntegrity`（完整性哈希自检）、`checkApkSignature`（签名指纹自检，多指纹轮换）、`checkEmulator`（模拟器特征）、`checkVpnProxy`（VPN/代理）、`checkClockAnomaly`（时钟异常，30s 阈值）。
- 新增 `signalsToJson`：把全部检测信号汇总为 JSON，供服务端协作上报（只报告不阻断）。
- 接入指南补充「完整性自检定期复查」「服务端协作上报」与 `signalsToJson` 上报示例。

#### 供应链

- 离线已知漏洞比对（`SUPPLYCHAIN_KNOWN_VULNERABILITY`）：检测到的 SDK 与内置精简快照比对，不联网、清单级提示。
- 快照补 `fixedIn`/`affected` 版本区间提示，建议自动带上修复版本。
- 供应链快照扩充至 8 条（gson/commons-compress/okio 等）；打包器指纹扩充至 12 个。
- 新增快照/指纹一致性校验（`scripts/known-vuln-check.ts`）与数据表一致性测试（CVE/包名/marker 唯一性、字段完整性）。

#### 报告与门禁

- 报告「执行步骤」段新增真实处理/跳过计数说明（“已处理”含跳过与失败回退，真实处理成功单独列出）。
- 发布门禁置信度感知（pass/review/block）与修复包 4 模板（network_security_config / backup_rules / manifest 片段 / dex-string-security 计划）。

#### 工具与脚本

- 本地 Web UI / REST API 服务（`scripts/serve.ts`）：127.0.0.1 + 可选 Bearer token——`POST /run` / `GET /reports/<path>` / `GET /`，本地优先。
- assets 资源轻量加密工具（`scripts/encrypt-assets.ts`）：构建期加密 + `manifest.json` 生成（与字符串加密桩同模式）。
- DEX 方法混淆设备验证清单生成器（`scripts/generate-device-checklist.ts`）：7 项真机矩阵清单。
- 签名指纹管理脚本（`scripts/signing-fingerprints.ts`）：keytool 指纹清单 + `--expect` 多指纹校验，密码仅从环境变量读取。

#### 文档

- R8/ProGuard 规则模板库（`docs/r8-rule-templates.md`）：Retrofit/Room/协程/序列化 keep 模板与反模式。
- assets 资源轻量加密方案（`docs/assets-encryption-plan.md`）与强制 R8 按变体细化模板（`docs/force-r8-variant-template.md`）。

### Fixed

- 修复传递依赖已知漏洞：`brace-expansion` 升级至 `^2.1.4`（GHSA-rgw5-rvv9-x895，无界中间数组 DoS）、`@babel/core` 升级至 `^7.29.1`（GHSA-4x5r-pxfx-6jf8，sourceMappingURL 注释任意文件读）；`bun audit` 现报告无已知漏洞，release-check 的依赖覆盖断言同步更新。
- 报告「执行步骤」段新增真实处理/跳过计数说明：明确"已处理"为流程到达（含跳过与失败回退），真实处理成功步数单独列出，跳过不再被误认为真实执行。
- 注：签名/发布路径的安全缺陷（签名保留、产物命名、错误根因掩盖）已在 v1.0.0 的 Fixed 节修复并记录。

## [1.0.0] - 2026-08-20

### Added

- 新增 R8/ProGuard 规则质量精审：只检查 app release 的有效规则范围，精确报告关闭优化/裁剪/混淆、全局/整包宽 keep、缺失规则引用，并通过注释、注解/继承约束和 allow 语义降低误报。
- 新增发布证据包：从本次实际 Gradle APK 精确反推变体，归档同变体 R8 mapping/configuration/seeds/usage、可选 missing_rules 与 DroidSeal R8 覆盖脚本，逐文件记录 SHA-256/大小/相对来源；APK 输入和无法解析的布局不会模糊匹配旧产物。
- 新增 CycloneDX 1.5 SBOM 与许可证待核验清单：精确 Gradle 字面量坐标生成 Maven purl；动态/version-ref、DEX SDK 家族和 Native 库保持 unresolved/observed；Native 跨 ABI 去重并保留路径证据；未知许可证统一为 `NOASSERTION`，不联网猜测。
- 新增置信度感知发布门禁与纵深防御覆盖矩阵：报告稳定输出 `pass/review/block`、原因 code 和规则版本；只让失败步骤、明确无效/缺失签名及 confirmed/high critical 自动阻断，低置信度“未观察到”不阻断；业务侧/服务端控制保持 `external-required` 或最多 `observed`。
- 新增签名材料与 Git 暴露精审：检查签名属性、项目内 JKS/keystore/P12/PFX 和文档密码，区分 tracked/历史/未跟踪/未知状态；finding 只保留路径、行号和字段名，不回显密码，并生成不覆盖源码的轮换与 `.gitignore` 清单。
- npm 发布改为 Windows x64 二进制：Bun bundle 经 Terser 5.49.0 保守压缩和顶层标识符 mangle 后由 `bun --compile` 生成 `dist/droidseal.exe`；中间 JS 构建后删除，npm 白名单排除源码、脚本、测试、内部文档、锁文件和 source map。启动器先校验 exe 的 SHA-256，再设置资源目录并透传参数；OpenTUI DLL 嵌入 exe，worker/WASM/查询资源逐文件校验。
- 完成二进制第三方许可证据链：按 Bun metafile 精确生成实际 bundle 与显式原生运行时包清单、CycloneDX SBOM、逐包许可证副本和可读通知；固定 Bun 1.3.14 及其 WebKit、TinyCC 提交，附 LGPL-2.0-only/LGPL-2.1 正文、对应源码与重新链接说明。构建和发布门禁会在版本漂移、未知许可证、缺少许可证正文/源码地址或制品哈希不一致时失败。
- 新增显式可选的混合应用 Web JavaScript 发布步骤：严格限定 `assets/public` / `assets/www`，依据 `index.html` 区分普通脚本与 ES module，使用 Terser 保守压缩/混淆并移除 source map；全部脚本转换和 ZIP 复核成功后才原子写出，语法失败整步回退，未配置重新签名时保护现有签名。明确该能力只提高阅读门槛，不等于源码保密。
- 新增 App 自签名校验精确审计与最终证书交叉验证：源码侧要求有效 SHA-256 允许列表、Android 签名 API、SHA-256 摘要、启动调用和失败处置形成完整证据；区分占位值、静态未解析值、缺少启动调用与缺少处置。最终 `apksigner` 验证后比对实际发布证书，支持多指纹轮换，不一致以 confirmed critical 阻断；报告脱敏完整指纹，匹配也不宣称客户端校验不可绕过。
- 新增 WebView 调试 release 四态审计：区分显式 false、仅 BuildConfig.DEBUG/src/debug 开启、release 可达 true 和未观察到明确关闭；注释/字符串不作为证据，扫描不完整时不输出安全结论。confirmed high 的 release true 进入门禁复核，低置信度缺口不阻断。opt-in 反调试 stub 新增进程级两秒节流的 Activity onResume 复查 API，仍只报告信号、不 kill、不自动注入，并要求真机矩阵。
- 静态安全审计能力大幅扩展（纯 TypeScript 自研解析，零新增运行时依赖）：
  - 权限模型：危险权限分组概览、高风险权限（悬浮窗、安装未知应用、无障碍、管理全部存储等）、`QUERY_ALL_PACKAGES` Play 政策提示、自定义权限弱保护级别（`MANIFEST_*` / `SOURCE_*`）。
  - 合规：`targetSdk` 落后政策基线、缺少 `arm64-v8a`、aapt 缺失降级（`COMPLIANCE_*`）。
  - 签名深度：仅 v1 + minSdk<24 的 Janus 面、缺 v2/v3、证书过期/临期、Debug 证书、弱密钥/弱签名算法、导出 SHA-256 指纹（`SIGNING_*`）。
  - 深链与组件：http/https 深链未 autoVerify、BROWSABLE 导出且无权限、自定义 taskAffinity、导出 provider 授予 URI 权限（`MANIFEST_*` / `SOURCE_*`）。
  - meta-data 与资源密钥：Manifest meta-data、`assets`/`res/raw` 文本资源中的硬编码密钥与内嵌私钥（`MANIFEST_METADATA_HARDCODED_SECRET`、`ASSET_HARDCODED_SECRET`、`ASSET_EMBEDDED_PRIVATE_KEY`）。
  - DEX 字符串池启发式扫描：硬编码密钥、弱加密/ECB、不安全 TLS、动态代码加载、运行时执行、WebView JS 桥、弱随机数（`DEX_*`，含 `DEX_SCAN_INCOMPLETE` 降级）。
  - Native .so ELF 加固扫描：可执行栈、RELRO 缺失/部分、栈保护、FORTIFY、文本重定位、.so 内明文密钥（`SO_*`，含 `SO_SCAN_INCOMPLETE` 降级）。
  - 网络安全配置深度解析（源码侧）：明文允许、信任用户 CA、debug-overrides、证书固定缺失/弱固定（`NSC_*`）。
  - 备份规则质量（源码侧）：允许备份但无排除规则、敏感路径未排除（`BACKUP_*`）。
  - 供应链清单：DEX 描述符识别第三方 SDK 与 Gradle 依赖坐标清单，仅清单不做 CVE 比对（`SUPPLYCHAIN_SDK_INVENTORY`）。
- 报告输出（JSON 与 Markdown）按严重度（critical→info）排序，同级保持稳定顺序。
- 新增自研、opt-in 的构建期反调试 stub（`src/assets/antidebug-stub`，通过 `bun scripts/install-antidebug-stub.ts` 安装）：JNI + Kotlin，在编译期经 NDK/CMake 链接，检测 TracerPid 与注入框架特征，仅检测不改写 APK。
- 为每个跳过步骤提供“不适用、用户选择、按配置、安全保护、缺少前置 APK”分类和解释。
- 在 TUI、JSON 和 Markdown 报告中解释跳过原因。
- 添加商标政策、治理机制、DCO 检查、CODEOWNERS 和完整开源社区文件。
- 添加 npm 包元数据、项目仓库链接、支持范围和安全报告说明。

### Changed

- README 现以源码和锁文件为准说明 14 步架构、自研/研究模块边界、实际 npm/外部工具依赖、真实输出树与项目文档导航；已完成的 DSR 队列从通用加固路线图移除，DEX/ARSC 设计文档改为反映当前接线状态，并把所链接的项目文档纳入 npm 发布白名单。

- 项目由早期内部名称 `apkguard` 统一更名为 `DroidSeal`。
- 命令、包名和仓库名统一为 `droidseal`；配置/运行目录改为 `.droidseal`；环境变量前缀改为 `DROIDSEAL_`。
- 构建文件和处理报告分别改名为 `droidseal.js` 与 `droidseal-report.*`。
- 更新字符 Logo，并根据 Logo 实际宽度调整顶部状态摘要显示条件。
- 优化向导和每一步说明，保留 R8、DEX、VMP、zipalign、apksigner、JKS/PKCS12、SHA-256 等专业术语。
- 进度面板分别显示已处理、成功、跳过和失败，并自动跟随当前步骤。

### Removed

- 未使用的 `zod` 依赖。

### Fixed

- 选择“暂不签名”处理已签名 APK 时，Release 归一化会为剔除残留条目（如 `DebugProbesKt.bin`）重建 ZIP，使原有签名失效，产出无法安装的 APK。现在检测到需保护的现有签名时跳过剔除（`HARDEN_SKIPPED_TO_PRESERVE_SIGNATURE`）；仅当必须修复 `debuggable=true` 时才改写，并以 `HARDEN_SIGNATURE_INVALIDATED` 明确告知签名已失效。
- 签名失败时最终产物仍被命名为 `guarded-signed`，使未签名、无法安装的 APK 看起来已签名。产物后缀改为依据最终验证的实际结果，而非配置意图。
- 签名库校验失败后，签名步骤仍会重试 apksigner 并报出更含糊的 `KEYSTORE_PASSWORD_INVALID`，掩盖“别名不存在”“文件不存在”等真实根因。现在直接跳过签名并保留原始错误；最终验证改报 `SIGNATURE_MISSING_AFTER_FAILED_SIGNING`，指向真正失败的步骤。

## 开发路线（加固 / 混淆可扩展方向）

### 功能完备性（现状）

- **14 步流水线**：环境诊断 → 准备工作区 → 签名库 → 源码安全审计 → 构建 Release APK → APK 安全审计 → 本地安全防护 → Release 归一化 → Web JS 处理（可选）→ 资源名混淆（可选）→ ZIP 对齐 → APK 签名 → 最终验证 → 生成报告。
- **静态审计 10+ 类**：权限模型、合规（targetSdk/ABI）、签名深度、深链与组件、meta-data 与资源密钥、DEX 字符串池、Native .so ELF、网络安全配置（NSC）、备份规则、供应链清单——附置信度分级与交叉证据。
- **加固能力**：ARSC 资源混淆（名称/路径/颜色/维度）、Web JS 处理（Terser 白名单）、反调试 stub（检测信号 + 完整性/签名自检）、字符串加密桩（源码接入）、DEX 方法混淆受控子集（设计+工具）。
- **发布工程化**：preflight 一键门禁、CI 集成、发布门禁（pass/review/block）、发布证据包、CycloneDX SBOM、修复包、加固成效量化——功能面完整。

### ① DEX 层（自研研究模块，可逐步接入主线）

- DEX 字符串安全子集（`dex-string-crypto` 研究模块）接入主线：敏感字符串常量的安全化计划沉淀到报告修复包；
- DEX 字符串加密（选择性）：设计“源码接入”模式，生成解密桩与接入指南，由应用在源码侧集成后构建；
- DEX 方法/类级混淆：受控子集接入（仅对白名单方法做名称混淆，需真机设备矩阵）；
- DEX 反调试注入（实验 `lossy-inject`）：保持研究级，不对未知 APK 事后合成。

### ② 资源/资产层

- ARSC 深度混淆：在 `getIdentifier`/引用保护基础上，扩展字符串值、颜色、布局名的保守混淆；
- assets 资源轻量加密：为游戏/多媒体资产生成“源码接入”式加密方案与解密接入指南。

### ③ Native 层

- .so 加固检查深化：增加 strip 符号表 / 移除调试信息的自动化检查与建议；
- Native 字符串与硬编码密钥审计深化（扩大 `.so` 内明文密钥的检测范围）。

### ④ 运行时防护（自研反调试 stub 扩展）

- 完整性自检：APK 哈希/签名自检的“源码接入”桩；
- Frida/Xposed 特征深化与分层检测（当前 TracerPid + `/proc/self/maps`）；
- 防重打包组合（签名校验 + 资源哈希自检）的集成建议。

### ⑤ 构建期与报告闭环

- R8/ProGuard 规则自动优化建议（基于审计发现生成最小化 keep 建议）；
- Manifest/权限裁剪建议的修复包扩展（现有 remediation 已覆盖 NSC/备份规则）；
- 强制 R8 的按变体细化模板。

### 优先级

- **短期**：③ Native 检查深化 + ⑤ 报告修复包扩展（无设备矩阵风险）；
- **中期**：② ARSC 深度混淆 + ① 字符串安全计划接入（失败关闭）；
- **长期/需决策**：① DEX 加密/混淆、④ 运行时完整性——按“源码接入 + 设备矩阵”模式设计，不对未知 APK 事后合成（项目既定边界）。

### 边界说明（能力方向）

- **审计质量与发布安全做到极致**：误报控制、置信度分级、交叉证据、失败关闭——把审计与发布安全做成核心竞争力。
- **提供源码接入的加固能力**：字符串加密桩（`scripts/generate-string-crypto-stub.ts`）、反调试 stub（`src/assets/antidebug-stub`）、DEX 方法混淆受控子集（`docs/dex-method-obfuscation-plan.md`）——编译期接入、运行期生效，不对未知 APK 事后合成可执行代码。

### 竞争定位与差异化

- **审计质量是稀缺能力**：误报控制、置信度分级、交叉证据、失败关闭——多数免费工具“扫到即报”，DroidSeal 做“确认后才报”，这是稀缺的工程能力。
- **差异化清晰**：本地优先 + 审计加固一体化（审计 → 归一化 → 混淆 → 签名 → 验证 → 报告闭环），而非孤立的静态分析。
- **免费开源审计竞争者（MobSF / AndroBugs 等）**：它们以静态分析扫描与报告为主；DroidSeal 的差异在于失败关闭语义、置信度分级、交叉证据与发布安全闭环（门禁 / 证据 / SBOM / 修复包），并坚持本地优先、不联网、不事后改写未知 APK。

### 竞争者分析（免费开源审计工具全景）

- **综合框架**：MobSF（~20.7k★，活跃——静态/动态/恶意分析 + Web UI/REST/CI，局限：误报高、动态需模拟器、混淆应用分析受限）；QARK（LinkedIn，2019 停更——POC 生成，反编译不完整漏报）；APKHunt（2023 停更——MASTG 正则模式）；SUPER（停更——并行扫描快）。
- **字节码/语义分析**：AndroBugs（**已归档**——修改版 Androguard 的字节码语义分析，效率与准确率高）；JAADAS（2017 停更——Soot 污点分析）；DroidStatx / Marvin / AUSERA / Trueseeing / SPECK（学术型，多已停更）。
- **基础设施**：Androguard（解析库——多数工具的基础，非开箱审计）；APKiD（打包器/保护器识别）；Quark-Engine（恶意行为加权评分）；apkleaks（URI/端点/密钥提取）；mobsfscan / Semgrep（规则引擎，CI 可用）。
- **实证（arxiv 2410.20740，11 个 SAST 工具基准）**：分为源码/AST 模式匹配与字节码语义分析两类；召回差异大（MobSF 硬编码敏感数据 93.9%、AndroBugs 无效服务器校验 96.9%）；**共性痛点：误报率高、需人工验证**。
- **DroidSeal 差异**：误报控制/置信度分级/交叉证据/失败关闭（正是免费工具的共同短板）；活跃维护（AndroBugs 已归档、QARK/APKHunt/JAADAS 停更）；本地优先 + 纯 TypeScript 自研解析；审计加固一体化 + 发布安全闭环。

### 逐功能对比（竞争对手强于 DroidSeal 的功能）

- **MobSF**：动态分析（模拟器运行时行为/网络流量/API 调用）、多平台（iOS/Windows）、恶意软件检测、Web UI + REST API + CI 集成、反编译源码/资源浏览（人工核验）、丰富配置项。
- **AndroBugs**：字节码数据/控制流语义分析（SSL 校验召回 96.9%）、海量批量分析（MassiveAnalysis）。
- **JAADAS / Marvin / AUSERA / Trueseeing**：污点/数据流分析（Soot/FlowDroid 追踪敏感数据源→汇）、可达性/调用链分析。
- **QARK**：POC/exploit 生成（ADB 命令/APK）、教育性漏洞详解。
- **APKiD**：打包器/保护器指纹识别（YARA 规则——检测壳/混淆器）。
- **Androguard / Quark-Engine / apkleaks / mobsfscan / Semgrep / APKHunt**：通用可编程解析库、行为加权评分、专项密钥提取工具、规则引擎生态、规则与 OWASP MASTG 对齐。
- **汇总（12 项）**：动态分析、多平台、恶意检测、Web/REST 平台化、反编译浏览、数据流/污点分析、POC 生成、打包器指纹、规则生态、标准对齐、海量批量、教育性说明。
- **平衡补充**：误报控制/置信度/交叉证据/失败关闭、审计加固一体化、发布安全闭环（门禁/证据/SBOM/修复包）、本地优先/纯 TS/活跃维护——竞争对手不具备；**最值得补的差距：① 数据流/污点跟踪 ② 打包器指纹识别 ③ Web/REST 平台化**。

### 差距分析（竞争对手有而 DroidSeal 不具备）

- **高补强价值**：① Web UI / REST API（企业/DevSecOps 平台化，与现有报告/门禁契合）；② 打包器/保护器指纹识别（APKiD 式——检测壳/混淆器并提示“建议配合商业加固核验”）；③ 敏感数据流/污点跟踪（数据流分析深度——把交叉证据升级为数据流证据，纯 TS 自研、失败关闭）。
- **中价值**：多平台（iOS/Windows——工作量巨大）；反编译可读源码/资源浏览（供人工核验）；规则生态/自定义规则文件加载；POC 生成（仅生成 ADB 验证命令、不生成 APK）。
- **边界内不做（故意）**：动态分析（需模拟器/联网，与本地优先冲突）；恶意软件检测（偏离发布安全定位）；在线/共享分析平台（本地优先冲突）。

### 可持续性准则（从停更项目汲取的教训）

- **持续跟进生态**：跟踪 Android 新版本 API、新混淆技术、新合规要求（Play 政策等）——避免“完成态”心态导致断更。
- **用户反馈闭环**：误报控制、置信度分级、交叉证据已是最强差异化——保持“确认后才报”的口碑，形成正向反馈循环。
- **可持续维护**：规则、文档、测试、发布门禁齐全（已具备），路线图公开（见本文件开发路线）——避免单点依赖与断更风险。

### 完善与优化方向（开发后混淆/加固边界内，持续增强）

- **加固效果闭环（短期高价值）**：加固前后对比报告（大小/熵/DEX 字符串池明文数/可读性量化）+ 加固覆盖度评分（每资产检查覆盖可量化）+ 修复包复测闭环（修复后重跑自动确认）。
- **审计 → 自动加固衔接（中期）**：DEX 审计识别敏感串后自动生成加密桩计划（当前生成器需手工 `--string`）；ARSC 值混淆扩展字符串值/维度保守子集；资源路径混淆深化。
- **运行时防护扩展（长期，需真机矩阵）**：模拟器/VPN/代理/时间戳检测；完整性自检定期化（复用 onResume 节流）；服务端协作上报协议（仍只报告、服务端决策）。
- **构建期/发布工程化（中期）**：发布前自动跑完整流水线与门禁；R8 规则模板库（Retrofit/Room/协程/序列化）；签名指纹管理脚本（多签名/轮换清单生成与校验）。
- **供应链深化（长期）**：SBOM 已知漏洞比对（对接离线漏洞库快照，如 OSV）；Gradle 坐标的已知修复版本建议。
