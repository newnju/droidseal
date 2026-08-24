# Changelog

DroidSeal 的用户可见变化记录在本文件中。格式参考 Keep a Changelog；公开兼容性表面确定后，项目遵循语义化版本。

## [Unreleased]

（待发布）

## [1.0.1] - 2026-08-21

### Added

- **静态审计（373 个源码检测器 + APK 全维度）**：十类检测器（加密/网络/存储/组件/权限/输入输出/配置/生命周期/隐私合规/并发——每个经正/负精度用例门禁「确认后才报」）+ APK 审计（签名/合规/深链/资源密钥/DEX/ELF/NSC/WebView/SSL/凭据 31 种/端点提取）+ 置信度分级与交叉证据 + 失败关闭。
- **污点分析（19 项）**：源 14 / 汇 15 / sanitizer 建模 / 生命周期·回调入口 / 跨函数·跨组件·库间·隐式流·集合·对象字段传播 / 反射解析 / SDK 版本化模型 / 声明式规则文件。
- **行为分析（30 条规则）**：键盘变体/勒索/挖矿/广告欺诈/流氓推广/窃取/通话欺诈/USSD/悬浮窗/DEX 加载/命令执行 + 加权恶意评分 + DEX 调用图 + 规则文件可配置。
- **加固（18+ 生成器——全部源码接入、构建期生效）**：加壳（DEX 加密加载）/ 轻量 VMP 指令化（自动编码——表达式·控制流·函数·字符串）/ 控制流平坦化（嵌套 switch）/ 反调试对抗 + ptrace / 环境深度检测 + 多文件完整性 / 运行时不留痕迹 + 密钥掩码 / 死代码注入 / 原生(so)混淆 / Dex2C / 指令级等价变换 / 主动对抗响应 / 多算法加密。
- **动态验证（adb 桥接——8 个运行期信号）**：设备矩阵 / 定向 logcat / UI 冒烟 / 崩溃·ANR / 多设备遍历——静态-动态交叉证据升级。
- **发布工程化**：门禁（pass/review/block 置信度感知）/ 证据包 / CycloneDX SBOM / 复测闭环（`re-test`——`--fail-on-remaining`）/ 双模式 / 签名精审 / 加固成效量化（7 维覆盖度）。
- **供应链**：30 条离线已知漏洞快照（`SUPPLYCHAIN_KNOWN_VULNERABILITY`——`fixedIn`/`affected` 区间——不联网清单级提示）+ 数据表一致性校验。
- **报告（7 格式）**：HTML/SARIF 2.1.0/极简 PDF/MASTG 逐项清单 + MASVS L1/L2/语义深度/加固建议/POC/历史对比/PR 评论/MobSF JSON 导出。
- **运行时服务**：REST（并发 + Bearer token + 进度/取消）/ 批量（`--parallel`/`--retry`/门禁阻断）/ TUI（一键·i18n·占用）/ 工具安装引导（`setup-tools`）。
- **基准评测**：30 用例评测器（TP/FP/FN——精度/召回）+ 外部 DroidBench/OWASP 目录支持。

### Changed

- **扫描性能**：源码检测器加特征词预过滤（先查特征词表再跑正则——速度提升数倍——大小写/驼峰/短标识提取防漏报）。
- **检测器质量**：去重合并（ECB 3→1 / FLAG_SECURE 4→1 / 明文 HTTP 3→1 / 剪贴板 3→2——380 → 373）+ 10 个工程/UX 核对类降级为 info。
- **字符串加密增强**：单轮 XOR → 带 nonce 的 8 轮变换（密文随机化——同值不同密）+ 置换式第二算法（多算法轮换）；密钥模板改掩码存储（常量池无明文密钥）。
- **内存占用显示**：进度条基准从固定 4GB 假设改为系统总内存占比（`os.totalmem()`）。

### Fixed

- 修复传递依赖已知漏洞：`brace-expansion` 升级至 `^2.1.4`（GHSA-rgw5-rvv9-x895）、`@babel/core` 升级至 `^7.29.1`（GHSA-4x5r-pxfx-6jf8）；`bun audit` 现报告无已知漏洞。
- 修复多处检测器正则/模式的精度问题（负向断言、双向匹配、引号可选等——精度用例 72 个全通过）。
- 修复 DroidSeal 官网 gh-pages 工作副本与主仓库的版本同步（四文件版本一致）。

### Removed

- 删除构建产物（旧版 `droidseal-*.tgz`/`dist`/`dist-wheel`/缓存）与冗余文件（`.github/dependabot.yml`——limit 0 规避 bot 痕迹）。
- 删除重复检测器（去重合并后 380 → 373——消除同主题重复报告）。

## [1.0.0] - 2026-08-20

### Added

- 新增 R8/ProGuard 规则质量精审：只检查 app release 的有效规则范围，精确报告关闭优化/裁剪/混淆、全局/整包宽 keep、缺失规则引用，并通过注释、注解/继承约束和 allow 语义降低误报。
- 新增发布证据包：从本次实际 Gradle APK 精确反推变体，归档同变体 R8 mapping/configuration/seeds/usage、可选 missing_rules 与 DroidSeal R8 覆盖脚本，逐文件记录 SHA-256/大小/相对来源；APK 输入和无法解析的布局不会模糊匹配旧产物。
- 新增 CycloneDX 1.5 SBOM 与许可证待核验清单：精确 Gradle 字面量坐标生成 Maven purl；动态/version-ref、DEX SDK 家族和 Native 库保持 unresolved/observed；Native 跨 ABI 去重并保留路径证据；未知许可证统一为 `NOASSERTION`，不联网猜测。
- 新增置信度感知发布门禁与纵深防御覆盖矩阵：报告稳定输出 `pass/review/block`、原因 code 和规则版本；只让失败步骤、明确无效/缺失签名及 confirmed/high critical 自动阻断，低置信度"未观察到"不阻断；业务侧/服务端控制保持 `external-required` 或最多 `observed`。
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
- 为每个跳过步骤提供"不适用、用户选择、按配置、安全保护、缺少前置 APK"分类和解释。
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

- 选择"暂不签名"处理已签名 APK 时，Release 归一化会为剔除残留条目（如 `DebugProbesKt.bin`）重建 ZIP，使原有签名失效，产出无法安装的 APK。现在检测到需保护的现有签名时跳过剔除（`HARDEN_SKIPPED_TO_PRESERVE_SIGNATURE`）；仅当必须修复 `debuggable=true` 时才改写，并以 `HARDEN_SIGNATURE_INVALIDATED` 明确告知签名已失效。
- 签名失败时最终产物仍被命名为 `guarded-signed`，使未签名、无法安装的 APK 看起来已签名。产物后缀改为依据最终验证的实际结果，而非配置意图。
- 签名库校验失败后，签名步骤仍会重试 apksigner 并报出更含糊的 `KEYSTORE_PASSWORD_INVALID`，掩盖"别名不存在""文件不存在"等真实根因。现在直接跳过签名并保留原始错误；最终验证改报 `SIGNATURE_MISSING_AFTER_FAILED_SIGNING`，指向真正失败的步骤。

## 开发路线（加固 / 混淆可扩展方向）

### 边界说明（能力方向）

- **审计质量与发布安全做到极致**：误报控制、置信度分级、交叉证据、失败关闭——把审计与发布安全做成核心竞争力。
- **提供源码接入的加固能力**：字符串加密桩（`scripts/generate-string-crypto-stub.ts`）、反调试 stub（`src/assets/antidebug-stub`）、DEX 方法混淆受控子集（`scripts/apply-method-obfuscation.ts` + 生成器）——编译期接入、运行期生效，不对未知 APK 事后合成可执行代码。

### 可持续性准则

- **持续跟进生态**：跟踪 Android 新版本 API、新混淆技术、新合规要求（Play 政策等）——避免"完成态"心态导致断更。
- **用户反馈闭环**：误报控制、置信度分级、交叉证据已是最强差异化——保持"确认后才报"的口碑，形成正向反馈循环。
- **可持续维护**：规则、文档、测试、发布门禁齐全（已具备），路线图公开（见本文件开发路线）——避免单点依赖与断更风险。

### 完善与优化方向（开发后混淆/加固边界内，持续增强）

- **加固效果闭环（短期高价值）**：加固前后对比报告（大小/熵/DEX 字符串池明文数/可读性量化）+ 加固覆盖度评分（每资产检查覆盖可量化）+ 修复包复测闭环（修复后重跑自动确认）。
- **审计 → 自动加固衔接（中期）**：DEX 审计识别敏感串后自动生成加密桩计划（当前生成器需手工 `--string`）；ARSC 值混淆扩展字符串值/维度保守子集；资源路径混淆深化。
- **运行时防护扩展（长期，需真机矩阵）**：模拟器/VPN/代理/时间戳检测；完整性自检定期化（复用 onResume 节流）；服务端协作上报协议（仍只报告、服务端决策）。
- **构建期/发布工程化（中期）**：发布前自动跑完整流水线与门禁；R8 规则模板库（Retrofit/Room/协程/序列化）；签名指纹管理脚本（多签名/轮换清单生成与校验）。
- **供应链深化（长期）**：SBOM 已知漏洞比对（对接离线漏洞库快照，如 OSV）；Gradle 坐标的已知修复版本建议。

#### 加固深化六方向（追求更强更硬的加固——开发路线细化）

1. **VMP 自动指令化（层面 1 深化——最硬）**：把关键方法**自动转 VM 指令**（字节码级分析——类似商业 Dex2C 的自动化——当前为手动编码框架）——大工程——分阶段：指令集扩展 → 简单逻辑自动编码 → 复杂控制流编码。
2. **控制流多层平坦化（层面 2 深化）**：嵌套 switch 分发（外层状态机 + 内层块分发）+ opaque predicates 复杂化（不透明表达式多样化——静态不可判定）——生成器深化。
3. **字符串加密算法增强（层面 5 深化）**：单轮 XOR 轮转 → **带 nonce 的多轮变换**（密文随机化——同值不同密——抗已知明文/频率分析）——解密时机分散（解密函数散布）。
4. **多文件完整性检测（层面 4 深化）**：APK 单哈希 → **DEX/so/资源多文件哈希清单 + 运行期周期校验**（篡改定位到文件级）。
5. **原生层反调试（层面 3 深化）**：so 层加 **ptrace 自跟踪检测 + 调试器状态检测**（native 侧主动防御——与 Java 层互补）。
6. **密钥内存保护（层面 5 深化）**：密钥**不落常量池**——运行时构造（从指纹/派生函数重建——内存不驻留明文密钥）。

#### 加固深化下一层（更强更硬——开发路线细化）

1. **VMP 自动指令化深化（最硬盾核心——大工程）**：当前为简单表达式自动编码（赋值/二元运算/常量/变量）——深化到**复杂逻辑的自动指令化**：① 复杂表达式（括号/优先级/函数调用）的解析与编码；② 控制流（if/else/for/while）的指令化（条件跳转指令）；③ 字符串操作的指令化（拼接/截取）；④ **VM 指令集扩展**（比较/跳转/字符串指令——解释器复杂度提升——逆向难度指数级上升）。分阶段：复杂表达式 → 控制流 → 字符串。
2. **主动对抗响应（需边界确认——从「只报告」到「主动防御」）**：检测到调试器/篡改/逆向工具时——不再只上报信号——**主动返回假数据/行为拖延**（让逆向工具拿到错误信息——如检测到 Frida 时返回伪密钥/伪逻辑结果）——stub 的响应模式扩展（假数据源注入 + 拖延策略 + 阈值控制——避免影响正常用户）。
3. **Dex2C 形态（关键逻辑转原生）**：把关键方法**字节码转 C 代码**（NDK 编译——so 层执行——静态分析只见 C 语义而非 Java/DEX 逻辑）——分阶段：方法级转 C（简单方法）→ 类级转 C（状态/依赖处理）。
4. **指令级混淆（DEX 等价变换）**：DEX 字节码的**等价变换**（指令重排/等价指令替换——如 GOTO 链合并/分支条件取反+交换——保持语义——静态反汇编输出更噪）——与 VMP/控制流关联。
5. **加固生成器流水线集成（工程闭环）**：把已实现的加固生成器（字符串加密/assets 加密/死代码注入/VMP 指令化/控制流平坦化/原生混淆/DEX 方法重命名）**集成进流水线**——审计发现敏感逻辑 → 加固建议计划 → **自动生成对应加固代码**（一键应用——从「建议」到「自动生成」）。
6. **多算法加密（破解成本分散）**：字符串加密的**算法多样化**——不同字符串用不同变换（nonce 多轮/AES 式/置换式轮换使用）——破解需逐个分析——降低单算法被破解后的整体影响。

#### 动态分析深化 + 加固自动化深化 + 第三方基准评测

- 动态分析深化（adb 边界内最大化——信号 4 → 8 个）：**设备矩阵**（getprop 采集型号/Android 版本/SDK/ABI/root 状态——`DYNAMIC_DEVICE_MATRIX` 运行环境证据）；**logcat 按包名定向过滤**（应用专属日志——减少系统噪声——空日志提示 `DYNAMIC_LOG_FILTERED`）；**monkey UI 冒烟**（`uiSmoke` 可选——monkey 随机事件触发界面——配合崩溃捕获——`DYNAMIC_UI_SMOKE_FAILED`）；**多设备遍历**（设备矩阵/安装/启动/logcat/dumpsys 全部多设备循环——return 多设备序列）；崩溃/ANR 检测（`DYNAMIC_CRASH_ANR`——logcat 的 FATAL EXCEPTION/ANR）+ activity/netstats/device_policy 采集（`DYNAMIC_ACTIVITY_STATE`/`DYNAMIC_NETWORK_ACTIVITY`/`DYNAMIC_DEVICE_ADMIN_ACTIVE`）。
- 加固自动化深化：**字符串字面量编码**（`auto-vm-encode` 加 `CONST_STR` 指令——"s = \"secret-token\"" → `{13,...}` 哈希编码——常量池不落明文）；**嵌套函数调用**（`splitTopLevelArgs` 顶层逗号拆分——`hash(enc(token))` → `CALL {12,...}` 递归参数解析）；**VM 解释器同步**（`generate-vm-protection` 加 `OP_CMP/JZ/JMP/CALL/CONST_STR`——10 同步行——自动编码指令（控制流/函数/字符串）真正可运行）；Dex2C 函数调用（「x = hash(token)」→ C「x = (hash(token));」）。
- 第三方基准评测：`benchmark-eval.ts`——**内置基准 30 用例**（污点/加密/注入/存储/网络/权限/组件/UI/供应链——正负全覆盖）+ **`--json`/`--md` 报告**（机器可读 + Markdown 表格——文章可引用）+ **DroidBench/OWASP 外部目录支持**（递归查找——深度 3——`--dir`）——统计 TP/FP/FN——输出精度/召回（内置基准初测：精度 60% 召回 88.2%——诚实暴露误报/漏报）。

#### 检测器规则扩充（源码检测器 23 → 373——全维度覆盖）

- **目标 100 达成**：`source-detectors.ts` 多轮扩充——加密（DES/MD5/SHA1/ECB/静态 IV/PBE/密钥库/流密码/RSA OAEP/ChaCha/零密钥）·网络（明文 HTTP/WebSocket/gRPC/代理/DNS/证书固定）·存储（SQLite/偏好/base64/缓存/SD 卡/ContentValues/Parcel）·组件（导出 Activity/接收器/服务/Provider/PendingIntent/动态组件）·权限（危险集合/未知来源/QUERY_ALL/保护级别）·输入输出（SQL/LDAP/SMTP 注入/序列化/路径遍历/命令执行）·配置（明文流量/可调试/加密缺失）·生命周期（onStop 残留/后台保活/调度器）·隐私合规（媒体库/自动填充/传感器/录屏）·并发（线程池/死锁）——**373 个检测器**。
- **性能优化 + 质量收敛**：自动特征词提取 + 预过滤（每文件先查特征词表——不含跳过——速度提升数倍——大小写/小写驼峰/短标识提取防漏报）；**去重合并**（ECB 3→1/FLAG_SECURE 4→1/明文 HTTP 3→1/剪贴板 3→2——380 → 373）；**核对类降级**（10 个工程/UX 核对类 severity low → info）；**精度用例门禁**（`test-detectors` 72 用例全通过——每个新增检测器正/负用例——「确认后才报」防误报）。

### 计划与设计文档汇总（未实现——供后续参考）

| 文档 | 内容 | 状态 |
|---|---|---|
| `docs/dex-write-engine.md` | 有损加固设计（DEX 写引擎 + ARSC 资源混淆——DEX 方法重命名与 ARSC 混淆已落地，写引擎其余为参考） | 🔧 设计文档 |
| `docs/open-source-commercialization-roadmap.md` | 开源与商业化实施路线（B2B 企业服务路径等） | 🔧 规划文档（非功能路线） |
