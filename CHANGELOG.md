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

- 本地 REST API 服务（`scripts/serve.ts`）：127.0.0.1 + 可选 Bearer token——`POST /run` / `GET /runs` / `GET /runs/:id` / `GET /runs/:id/findings`（severity 筛选）/ `GET /reports/<path>` / `GET /health`，本地优先；Web UI 已移除，批量/CI 集成使用 REST。
- assets 资源轻量加密工具（`scripts/encrypt-assets.ts`）：构建期加密 + `manifest.json` 生成（与字符串加密桩同模式）。
- DEX 方法混淆设备验证清单生成器（`scripts/generate-device-checklist.ts`）：7 项真机矩阵清单。
- 签名指纹管理脚本（`scripts/signing-fingerprints.ts`）：keytool 指纹清单 + `--expect` 多指纹校验，密码仅从环境变量读取。
- `encrypt-assets.ts` 新增 `--gen-reader`：生成 `AssetsReader.kt` 解密器（嵌入密钥与清单，运行时按清单解密 `.enc`，源码接入完整化）。
- `preflight.ts` 新增 `--json`（门禁结果机器可读输出）并集成 `known-vuln-check`（数据表一致性门禁，共 4 项）。
- `generate-string-crypto-stub.ts` 新增 `--verify`：密文回程验证（每个密文解密回原文，失败关闭）。
- `re-test.ts` 新增 `--json`：复测结果机器可读（消除/新增/剩余 + `gateSuggestion` 门禁建议）。
- `encrypt-assets.ts` 新增 `--verify`：密文回程验证（每个文件解密回原文，失败关闭）。
- `generate-method-obfuscation-plan.ts` 新增 `--from-audit`：从报告自动提取疑似反射/注解类 → 白名单 `#*` 整类保留建议。
- 发布门禁新增可配置加固覆盖度阈值（`minimumHardeningCoverage`）。
- 报告新增 `previousRun` 历史对比字段（与上一次运行的发现对比：消除/新增/剩余）。
- TUI 运行完成新增门禁横幅（发现数 + 发布门禁状态 + 原因 code 数）。
- `known-vuln-check.ts` 新增 `--suggest`：新条目格式模板提示。
- 报告 Markdown 新增「与上次运行对比」节（消除/新增/剩余 + 上次门禁状态）。
- TUI 运行完成门禁横幅新增严重度统计（critical/high 计数）；侧栏可选步骤（Web JS/资源名混淆）未开启时行内标注「可选未开启」。
- `re-test.ts` 新增 `--fail-on-remaining`：剩余 finding 未消除时非零退出（CI 门禁）。
- `known-vuln-check.ts` 新增 affected 字段格式校验（非空字符串或省略）。
- i18n 补键：阶段分组头（准备/审计/加固/发布）与可选步骤提示的中英文键（TUI 语言切换即时生效）。
- `preflight.ts` 新增 `--skip-test`：CI 快速门禁（跳过慢测试门禁）。
- 报告门禁原因的 Markdown 新增严重度标注（`[严重度 X]`）。
- `known-vuln-check.ts` 新增 fixedIn 字段格式校验。
- CI 工作流 verify 门禁改用 `preflight.ts --json`（机器可读输出入 CI 日志）。
- `re-test.ts` 新增门禁状态输出（`gateStatus`：剩余 finding 为 block，否则 pass）。
- TUI 门禁横幅消息 i18n 化（`t()` 支持参数化，`gateBannerFindings` 中英文键，语言切换即时生效）。
- `re-test.ts` 门禁状态 `block` 时非零退出（gateStatus 门禁，CI 统一）。
- `generate-string-crypto-stub.ts` 新增 `--rotate`：密钥轮换（强制新密钥，旧密文失效需全量重新生成）。
- 报告 schemaVersion 升版至 8（`previousRun`/`previousGate` 字段的结构版本化）。
- `known-vuln-check.ts` 输出严重度分布统计。
- 报告加固成效新增 `nativeAudit` 覆盖维度（6 → 7 维）。
- TUI 完成消息 i18n 补全：已处理/跳过原因消息中英文键（`gateBannerSummary`/`gateBannerSkipped`）。
- `preflight.ts --json` 输出失败门禁的错误尾部（`tail` 字段，CI 消费）。
- `generate-method-obfuscation-plan.ts` 新增 `--verify`：映射文件格式校验（失败关闭）。
- 报告 remediation 新增 `suggestionCount`（修复包建议数统计）。
- 新增服务端协作上报协议规范（`docs/server-report-protocol.md`：字段表/决策矩阵/抗滥用/接入示例）。
- TUI 底部新增快捷键提示（Enter 重试失败步骤 · Ctrl+C 复制不退出）。

- 开发路线精简：删除已实现且已记录的条目，保留未实现 3 项（① DEX 方法混淆改写 / ② 字符串值·布局名保守混淆 / ④ Frida·maps 分层检测），并标注「已实现并记录于 [1.0.1]」。
- ARSC 字符串值保守混淆：技术标识符形态字符串值（key_/id_/token_/api_/secret_ 前缀）改写为短标识符（失败关闭，运行时按值消费会失效——仅内部技术标记）。
- 反调试 stub 新增 `checkFridaInjection`：`/proc/self/maps` 的 Frida 特征分层检测（只报告不阻断，失败关闭），`signalsToJson` 新增 `fridaInjection` 字段。
- 新增 DEX 方法重命名工具（`scripts/apply-method-obfuscation.ts`）：按白名单映射（`method-obfuscation.map`）重写 DEX 方法名——新建短名串 + 改该 `method_id` 的 `name_idx`（调用点自动跟随）——重算 adler32 校验和与 SHA-1 签名——引用完整性验证（失败关闭）；构建期工具（源码接入模式，不事后改写未知 APK）。
- 新增 URL/域名/端点提取（`ENDPOINT_INVENTORY`）：从 DEX 字符串池提取 URL/域名/路径端点（apkleaks 式，去重排序有界，失败关闭）。
- 新增弱加密算法检测（`SOURCE_WEAK_CRYPTO`）：AES 默认 ECB / AES-ECB / DES / 3DES / 硬编码 IV 的源码模式匹配（失败关闭）。
- 签名审计新增证书有效期提示（`SIGNING_CERT_EXPIRED`/`SIGNING_CERT_EXPIRING`）：证书过期（medium）与临近 30 天（low）提示。
- 新增自定义规则文件加载（`customRulesFile` 配置）：JSON 正则规则（source/dex/all scope），审计时应用（失败关闭）。
- OWASP MASTG 规则映射（中期）：常见发现映射到 MASTG 类别参考，报告新增 JSON `mastg` 字段与 Markdown「OWASP MASTG 参考」节。
- 反编译核验建议（中期）：复杂发现（SOURCE_/DEX_/PACKER_ 等）提示 JADX/apktool 反编译人工核验，报告新增 JSON 字段与 Markdown 节。
- HTML 报告生成器（中期）：`scripts/generate-html-report.ts` 从报告 JSON 生成自包含 HTML（门禁横幅/发现表格/步骤/加固成效/MASTG/反编译建议/上次对比——TUI 视觉）。
- 多扫描历史趋势（中期）：最近 10 次运行的门禁/发现数序列，报告新增 JSON `historyTrend` 与 Markdown「历史趋势」表。
- 动态分析外部衔接指南（长期）：`docs/dynamic-analysis-bridge.md`——Frida/drozer/模拟器配合静态审计的按发现类型验证建议（保持本地优先，不内置动态）。
- 平台支持矩阵（长期）：`docs/platform-matrix.md`——当前 Android 矩阵 + iOS/Windows 扩展规划与决策建议。
- 恶意指标轻量提示（长期）：`MALICIOUS_INDICATOR`——危险权限组合（短信劫持/屏幕覆盖+无障碍/设备管理+短信）清单级提示（info，失败关闭，不判定恶意）。
- DEX 调用图提取（`dex-callgraph.ts`）：解析 invoke-kind 指令 → 被调 类.方法（有界、失败关闭）。
- 行为规则引擎（`behavior-rules.ts`）：调用图匹配内置 10 条恶意行为规则（短信劫持/键盘记录/设备管理滥用/截屏/录音等）→ `MALICIOUS_BEHAVIOR` finding + 加权恶意评分 `MALICIOUS_SCORE`（0-100，归一化）。
- 反混淆辅助：hex/base64 编码串解码后与行为规则匹配（补充命中，失败关闭）。
- 报告新增「行为分析（恶意行为特征）」节（JSON `behaviorAnalysis` + Markdown）。
- 行为规则文件加载（`behaviorRulesFile` 配置）：外部 JSON 行为规则与内置库合并（自定义优先，失败关闭）。
- 恶意行为评分分级阈值可配置（`maliciousScoreThresholds`：high/medium，默认 60/30）。
- DEX 调用链关联：`extractCallGraph`（解析 class_data 的 code_off → 调用方→被调 映射），行为 finding 证据带调用方（失败关闭）。
- 调用图导出工具（`scripts/export-callgraph.ts`）：直接 DEX 或 `--apk` 模式导出调用图 JSON。
- 反混淆辅助深化：URL 编码（%XX）解码匹配（与 hex/base64 并列为三编码）。
- SSL 证书校验绕过语义检测（`SOURCE_SSL_BYPASS`）：自定义 TrustManager / 空 `checkServerTrusted` / ALLOW_ALL 主机名校验器（失败关闭）。
- 语义漏洞模式库（`SOURCE_SEMANTIC_VULN`）：敏感数据流入 SQL 注入（execSQL/rawQuery/compileStatement）/ 命令执行（Runtime.exec/ProcessBuilder）汇的检测（medium，区别于 `SOURCE_DATAFLOW`）。
- 目录/库级批量（`batch-run --dir`）：扫描目录下 `*.apk` 自动建清单批量运行。
- 加固壳/混淆器指纹库扩充（`packers.ts` 12 → 27 条）：新增网易易盾/百度加固/腾讯御安全/360 运行时/梆梆变体/通用壳/StringFog 字符串加密/ProGuard 混淆特征/ApkTool 重打包等。
- 指纹规则文件加载（`packerFingerprintsFile` 配置）：外部 JSON 指纹与内置库合并（marker 去重，自定义优先，失败关闭）。
- SO 级加壳特征检测（`SO_PACKED`）：UPX / jiagu 等加壳标记的字节级扫描（elf-scan，失败关闭）。
- regex 型指纹支持：指纹可含 `regex`（marker 或 regex 至少一——精确匹配），外部规则文件校验 regex 合法性（失败关闭）。
- 指纹元数据：`version`/`author`/`source` 可选字段（外部规则文件可带，finding 按需展示版本与规则作者）。
- 混淆器覆盖扩充（`packers.ts` 27 → 33 条）：新增 AndResGuard / BlackObfuscator / Obfuscapk / Allatori / Zelix KlassMaster / DashO 等混淆器指纹。
- POC 验证命令建议（`poc-commands.ts` + 报告 `pocCommands`/「POC 验证命令建议」节）：对高风险发现（EXPORTED 组件/备份/可调试/深链）生成可执行 adb/drozer 验证命令，带可验证性标记与教育性说明（失败关闭，衔接 `docs/dynamic-analysis-bridge.md`）。
- 污点分析深化（JAADAS 差距）：污点源/汇库扩充（设备标识/位置/剪贴板/账户源、文件写入汇——源 6→14、汇 13→15）；生命周期回调入口点（`SOURCE_LIFECYCLE_ENTRY`）；sanitizer 清理建模（加密/编码后污点清除——降误报）；调用图接口分派近似（`expandInterfaceDispatch`）；污点路径报告（报告 `taintPaths`/「污点数据流路径」节）。
- 污点分析完整版（JAADAS 差距）：接收侧源（Intent/广播/ContentProvider 的 `getIntent`/`getData`/`query` 等）；动态回调注册入口（`SOURCE_CALLBACK_ENTRY`——ClickListener/Handler/AsyncTask 等 9 类）；SDK 版本化 API 模型（`SDK_LEVEL_API_MISMATCH`——API 引入版本 vs minSdk）；静态字段污点（`SOURCE_STATIC_TAINT`——项目级跨文件追踪）；集合元素污点（`SOURCE_COLLECTION_TAINT`——put/add → get → 汇）。
- 污点分析进阶（JAADAS 差距 9 项）：跨组件/跨进程 Intent 数据流（`SOURCE_CROSS_COMPONENT_TAINT`——putExtra 源 → 组件/服务/广播/绑定）；反射调用静态解析（`SOURCE_REFLECTION_TARGET`——Class.forName/getMethod 目标提取）；跨函数污点传播（`SOURCE_CROSS_FUNCTION_TAINT`——参数边界）；常量值分析 + 对象字段污点（`SOURCE_CONSTANT_VALUE`/`SOURCE_OBJECT_FIELD_TAINT`——敏感字面量间接持有 + 实例字段）；库间污点 + 隐式流（`SOURCE_LIBRARY_TAINT`/`SOURCE_IMPLICIT_FLOW`——库方法返回值 + 控制流污点）；可编程 IR（`scripts/export-ir.ts`——JSON IR 导出供第三方分析）。
- JAADAS 差距 19 项全量实现并实效验证：污点/数据流/语义/建模四大功能面穷尽核对无遗漏；新增检测器逐项冒烟验证（修复正则大小写/单字符变量/单行分支/off-by-one 等 7 处后全部命中合成样本——确认实际发挥作用）。
- Androguard 深度可编程解析（⑤⑥⑦⑧⑨）：指令迭代器 API（`dex-instructions.ts`——逐指令 opcode/mnemonic/operands——关键指令助记符）；内置反汇编器（`dex-disassembler.ts`——smali-like 方法级输出——行为 finding 附反汇编片段——替代外部 jadx 的内置形态）；XREF 交叉引用（`xref.ts`——方法/字段被引用映射——`referencesOf`）；类级对象模型（`dex-class-model.ts`——类→方法→指令对象树——export-ir 的 `classes` 深化（schemaVersion 2））；交互式分析 REPL（`scripts/analyze-repl.ts`——load/classes/method/xref/exit）。
- Androguard 剩余差距（②③）：任意 DEX 修改 API（`dex-patch.ts`——invoke 方法索引 / const-string 字符串索引的指令级补丁——真 DEX 字节修改验证）；资源条目对象模型（`buildArscResourceModel`——resources.arsc 的 type chunk 解析 → 类型/条目树——真 ARSC 解析出 146 类型）。

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

> 开发路线 ①-⑤ 方向与完善与优化各项已全部实现并记录于 [1.0.1]（2026-08-22）。

### 下一阶段（MobSF 缺口导向）

- **已完成（[1.0.1]）**：
  - 短期：URL/域名/端点提取（`ENDPOINT_INVENTORY`）；弱加密算法检测（`SOURCE_WEAK_CRYPTO`）；证书有效期提示（`SIGNING_CERT_EXPIRED`/`EXPIRING`）；自定义规则文件加载（`customRulesFile`）。
  - 中期：OWASP MASTG 映射；反编译核验建议；HTML 报告生成器；多扫描历史趋势。
  - 长期（边界兼容）：动态分析外部衔接指南；平台支持矩阵；恶意指标轻量提示（`MALICIOUS_INDICATOR`）。
  - 缺口补强：隐私数据收集清单（`PRIVACY_DATA_COLLECTION`/`PRIVACY_API_USAGE`）；证书固定缺失检测（`SOURCE_NO_CERT_PINNING`）；SQLite 明文存储审计（`SOURCE_UNENCRYPTED_STORAGE`）；反编译导出工具（`scripts/export-decompiled.ts`）。
- **仍缺（边界项——明确不实现）**：iOS/Windows 多平台（大工程——见 `docs/platform-matrix.md`）；内置动态分析（本地优先边界——见 `docs/dynamic-analysis-bridge.md`）；恶意软件沙箱/反病毒（偏离发布安全定位）。
- **下一竞争者（Quark-Engine——活跃，恶意行为加权评分）**：~~差距与设计~~ **已全部实现并记录于 [1.0.1]——已追平/超越（11/11 项核对无遗漏）**：DEX 调用图（含调用链）、行为规则引擎、加权评分、内置规则库（10 条）、行为报告节、反混淆辅助（hex/base64/URL）、行为规则文件加载、评分阈值配置、调用图导出——均落地；CLI/API 维度以 REST 语言无关接口超越。
- **下一竞争者（AndroBugs——已归档，字节码语义分析代表）**：~~差距~~ **已全部实现并记录于 [1.0.1]——已追平/超越**：SSL 证书校验绕过语义检测（`SOURCE_SSL_BYPASS`）、语义漏洞模式库（`SOURCE_SEMANTIC_VULN`）、目录/库级批量（`batch-run --dir`）、WebView SSL 错误忽略（`WEBVIEW_SSL_ERROR_IGNORED`）——均落地；效率（3-40s/APK）与活跃维护维度已超越。
- **下一竞争者（APKiD——活跃，打包器/保护器指纹识别）**：~~差距~~ **已全部实现并记录于 [1.0.1]——已追平/超越**：指纹库扩充（`packers.ts` 33 条——商业加固壳/混淆器/打包器）、指纹规则文件加载（`packerFingerprintsFile`——regex 型 + 元数据）、SO 级加壳特征检测（`SO_PACKED`）——均落地。
- **下一竞争者（QARK——已停更 2019，POC 生成代表）**：~~差距~~ **已全部实现并记录于 [1.0.1]——已追平/超越**：POC 验证命令建议（`poc-commands.ts` + 报告节——EXPORTED 组件/深链/备份等生成 adb/drozer 验证命令——与 `docs/dynamic-analysis-bridge.md` 衔接）——均落地；已停更——活跃维护与纯 TS 自研解析已超越。
- **下一竞争者（JAADAS——已停更 2017，Soot/FlowDroid 污点分析代表）**：~~差距（19 项）~~ **已全部实现并记录于 [1.0.1]——已追平/超越（四大功能面穷尽核对无遗漏 + 实效冒烟验证通过）**：生命周期入口/污点路径/源汇扩充、调用图完整性/跨组件/反射/跨函数/常量值/对象字段/库间/隐式流/可编程 IR 等 19 项——均落地；已停更——活跃维护已超越。
- **下一竞争者（Androguard——活跃，通用可编程解析库）**：~~差距~~ **已全部实现并记录于 [1.0.1]——已追平/超越**：深度可编程解析（指令迭代器/内置反汇编/XREF/类级对象模型/交互 REPL/DEX 修改 API/资源条目对象模型）——均落地；单一解析库（非开箱审计）——审计+加固+发布闭环已超越。
- **下一竞争者（Semgrep——活跃，通用规则引擎 SAST）差距**：① SARIF 报告导出（CI 生态标准——GitHub Code Scanning 等——中/易补）；② AST 级模式匹配（语法精确匹配——降误报——中/大）；③ JS 源码审计（混合应用的 JS 资源审计——中）；④ 规则生态（社区规则——跨语言——低/边界）。CI 集成（REST/batch/门禁）与活跃维护已同级。

### 边界说明（能力方向）

- **审计质量与发布安全做到极致**：误报控制、置信度分级、交叉证据、失败关闭——把审计与发布安全做成核心竞争力。
- **提供源码接入的加固能力**：字符串加密桩（`scripts/generate-string-crypto-stub.ts`）、反调试 stub（`src/assets/antidebug-stub`）、DEX 方法混淆受控子集（`docs/dex-method-obfuscation-plan.md`）——编译期接入、运行期生效，不对未知 APK 事后合成可执行代码。

### 竞争定位与差异化

- **审计质量是稀缺能力**：误报控制、置信度分级、交叉证据、失败关闭——多数免费工具“扫到即报”，DroidSeal 做“确认后才报”，这是稀缺的工程能力。
- **差异化清晰**：本地优先 + 审计加固一体化（审计 → 归一化 → 混淆 → 签名 → 验证 → 报告闭环），而非孤立的静态分析。
- **免费开源审计竞争者（APKHunt / SUPER / JAADAS 等——MobSF / AndroBugs / Quark-Engine / JAADAS / Androguard / APKiD / QARK 已追平/超越并移出竞争名单）**：它们以静态分析扫描与报告为主；DroidSeal 的差异在于失败关闭语义、置信度分级、交叉证据与发布安全闭环（门禁 / 证据 / SBOM / 修复包），并坚持本地优先、不联网、不事后改写未知 APK。

### 竞争者分析（免费开源审计工具全景）

- **综合框架**：~~MobSF~~（**已追平/超越——移出竞争名单**，功能面已全覆盖，见开发路线「下一阶段」）；~~QARK~~（**已追平/超越——移出竞争名单**——POC 验证命令建议已实现）；APKHunt（2023 停更——MASTG 正则模式）；SUPER（停更——并行扫描快）。
- **字节码/语义分析**：~~AndroBugs~~（**已追平/超越——移出竞争名单**，见开发路线「下一阶段」）；JAADAS（2017 停更——Soot 污点分析）；DroidStatx / Marvin / AUSERA / Trueseeing / SPECK（学术型，多已停更）。
- **基础设施**：~~Androguard~~（**已追平/超越——移出竞争名单**——深度可编程解析已实现）；~~APKiD~~（**已追平/超越——移出竞争名单**——指纹库 33 条/规则加载/SO 加壳已实现）；~~Quark-Engine~~（**已追平/超越——移出竞争名单**，见开发路线「下一阶段」）；apkleaks（URI/端点/密钥提取）；mobsfscan / Semgrep（规则引擎，CI 可用）。
- **实证（arxiv 2410.20740，11 个 SAST 工具基准）**：分为源码/AST 模式匹配与字节码语义分析两类；召回差异大（MobSF 硬编码敏感数据 93.9%、AndroBugs 无效服务器校验 96.9%）；**共性痛点：误报率高、需人工验证**。
- **DroidSeal 差异**：误报控制/置信度分级/交叉证据/失败关闭（正是免费工具的共同短板）；活跃维护（AndroBugs 已归档、QARK/APKHunt/JAADAS 停更）；本地优先 + 纯 TypeScript 自研解析；审计加固一体化 + 发布安全闭环。

### 逐功能对比（竞争对手强于 DroidSeal 的功能）

- ~~**MobSF**~~（**已追平/超越——移出竞争名单**）：其静态分析面（权限/组件/WebView/网络/存储/加密/证书/URL 提取/隐私收集/MASTG 映射/HTML 报告/历史趋势等）已由 DroidSeal 全覆盖（见开发路线「下一阶段」）；动态分析/多平台/恶意沙箱为边界项（已文档化）。
- ~~**AndroBugs**~~（**已追平/超越——移出竞争名单**）：字节码数据/控制流语义分析（SSL 语义检测已由 `SOURCE_SSL_BYPASS` 覆盖）、海量批量分析（已由 `batch-run --dir` 覆盖）。
- **JAADAS / Marvin / AUSERA / Trueseeing**：污点/数据流分析（Soot/FlowDroid 追踪敏感数据源→汇）、可达性/调用链分析。
- ~~**QARK**~~（**已追平/超越——移出竞争名单**）：POC/exploit 验证命令已由 `poc-commands.ts` + 报告节实现。
- ~~**APKiD**~~（**已追平/超越——移出竞争名单**）：打包器/保护器指纹已由 `packers.ts`（33 条 + regex/元数据 + 规则文件加载）+ SO 加壳检测实现。
- ~~**Androguard**~~（**已追平/超越——移出竞争名单**——深度可编程解析已实现）/ apkleaks / mobsfscan / Semgrep / APKHunt：专项密钥提取工具、规则引擎生态、规则与 OWASP MASTG 对齐。
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
