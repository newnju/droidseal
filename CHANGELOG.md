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
- **R8 规则模板库**：`generate-r8-templates.ts`——Retrofit/Room/协程/序列化 4 组 keep 规则模板（发布构建开启 minifyEnabled 时避免误删反射/序列化依赖）。
- **签名指纹管理脚本**：`signing-rotation.ts`——多签名/轮换清单（generate/rotate/verify 三动作——轮换期新旧签名兼容校验）。
- **加固覆盖度评分**：`hardening-coverage.ts`——7 类资产（APK/DEX/so/资源/字符串池/assets/运行时）检查覆盖量化——评分 0-100。
- **完整性自检定期化**：stub 加 `IntegrityCheckThrottle`（60s 节流）+ `periodicIntegrityCheck`（onResume 周期自检——不拖慢交互）。
- **ARSC 值混淆扩展**：`generate-arsc-value-obfuscation.ts`——资源字符串值/维度保守子集（长度不变、可逆——静态难直接识别原始字符串）。
- **服务端协作上报协议**：`signals-server.ts`——解析 stub 的 signalsToJson 信号——服务端风险决策（高/中/低 + 原因——仍只报告、不远程阻断）。
- **供应链深化（SBOM × OSV 离线快照）**：`supplychain-osv.ts`——SBOM 与 OSV 离线漏洞快照比对（affected 区间命中 + Gradle 修复版本建议——不联网清单级）。
- **字节码级保守自动化入口**：`extract-method-logic.ts`——从 DEX 方法字节码提取「可安全变换的简单逻辑」（保守子集：无异常/同步/反射——常量/算术/return——供 `auto-vm-encode` 自动编码）——复杂方法跳过并说明（全自动 VMP/Dex2C 阶段①②）。
- **服务端决策阈值深化**：`signals-server.ts` 加 `--min-high`——高风险信号数达到阈值才报 high——降低偶发误报（频率/阈值控制）。
- **供应链快照扩充**：OSV 内置快照 4 → 8 条（新增 volley/picasso/eventbus/zxing——常见 Android 库覆盖）。

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
