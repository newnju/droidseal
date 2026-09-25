# Security Ledger · 公开安全修复台账

[中文](security-ledger.zh-CN.md) | [English](security-ledger.md)

本台账公开记录 DroidSeal 所有已修复的安全缺陷。每个条目包含:触发条件(什么输入/状态引爆缺陷)、旧症状、修复语义、回归位置。与 [SECURITY.md 的对抗回归政策](../SECURITY.md#adversarial-regression-policy)对应:每个安全修复必须附带复现其触发条件的 `SEC-XX` 用例(修复前红、修复后绿)。

发布这份台账的理由:安全工具的可信度来自"怎么对待自己的 bug",而非"声称没有 bug"。商业厂商不公开修复细节,开源竞品普遍没有修复记录制度——这份台账让使用者可以核查本项目的响应深度与修复质量。

> 报告漏洞:请勿通过公开 Issue 披露,走 [SECURITY.md](../SECURITY.md) 的私密渠道。

## 台账

### SEC-001 · native 检测源自残(critical)

- **来源**:内部安全审查(第二轮,C1)
- **触发条件**:旧 `guard_vote.c` 检测源 A 使用 `PTRACE_TRACEME` 自检。该调用有永久副作用——成功后自身进入被 trace 状态(TracerPid≠0)。
- **旧症状**:干净设备上,Java 侧 `detectTracer` 随即读到 TracerPid≠0 而误判被调试 → 启动 3 秒内被杀。**所有设备、每次启动必现**。
- **修复语义**:源 A 改为 fork 子进程跨进程读父进程 `/proc/<ppid>/status` 的 TracerPid——零副作用,检测力等强(被 attach 必非 0),与 Java 侧读取路径异构的三源投票结构不变。
- **回归**:[`tests/security-regression.test.ts` SEC-001](../tests/security-regression.test.ts)——断言生成的 native 源剥除注释后无 `PTRACE_TRACEME`/`ptrace(` 调用、含 `getppid`+`/proc/`+`TracerPid`;另由 CI NDK job 用真实 NDK 编译验证。

### SEC-002 · 挑战 URL 补丁假阳性 + 越界写坏 DEX(critical)

- **来源**:内部安全审查(第一轮,C2)
- **触发条件**:三个缺陷叠加——①Java 常量 `SERVER_URL` 126B ≠ TS 标记 128B;②`findMarker` 硬编码 `MARKER_LEN=32` 只比对前 32 字节;③运行时 `indexOf('#')` 判定未补丁。
- **旧症状**:32B 部分命中即假阳性报 `patchedUrl=true`,随后 128B 写入 126B 位置越界覆盖 2 字节(DEX 结构损坏);运行时 URL 尾部合法 `#` 填充又被误判未补丁——**挑战模式产物 100% 静默解密失败**,且 E2E 曾被假阳性骗过("通过"实为损坏)。
- **修复语义**:两侧严格 128B 等长;`findMarker` 按真实标记长度全匹配;未补丁判定改用 `startsWith("DS_SRV_URL")`(兼容合法尾部填充)。
- **回归**:[`tests/harden-chain.test.ts`](../tests/harden-chain.test.ts) 4 例(全长度匹配/非法 URL/IDN 拒绝/32B 假阳性防护)+ SEC-002(loader DEX 无 master 明文 hex 残留)。

### SEC-003 · Keystore 绑定 + 挑战模式组合二次启动必砖(high)

- **来源**:内部安全审查(第一轮,C3)
- **触发条件**:`--challenge-url` + `--keystore-bind` 组合,且旧实现封存的是 XOR part3 **之后**的真实 part1。
- **旧症状**:二次启动 unseal 取回 part1 后又执行一次 XOR part3 → 密钥永久错误 → 解密失败。组合开关的产物**第二次启动必砖**。
- **修复语义**:首次启动封存 pre-XOR part1′;二次启动 unseal → XOR part3 → 还原真实 part1,与首次启动路径严格一致。纯本地/KS-only 路径行为不变。
- **回归**:SEC-003——源序断言:封存点(`sealPart1(toSeal)`)附近必须有 `pre-XOR` 语义锚,防止实现回退时注释漂移。

### SEC-004 · debuggable 输入产物永久解密失败且无提示(high)

- **来源**:内部安全审查(第一轮,C4)
- **触发条件**:输入 `debuggable=true` 的 APK。环境投票(P0-B)把 debuggable 视为污染 → 派生错钥。
- **旧症状**:产物在**所有设备**上解密失败,无任何提示(fail-closed 按设计,但对合法输入是构建事故)。
- **修复语义**:加固流水线新增 Step 3.1——字节级**等长**翻转 debuggable(`flipDebuggableInAxml`),置于 Step 4 锚点计算之前(锚点覆盖翻转后值);发 `HARDEN_DEBUGGABLE_FORCED` info finding。
- **回归**:SEC-004——80B 最小 AXML 断言翻转字节等长(AXML 偏移敏感,非等长=产物损坏)+ 单向 true→false 幂等(已 false 时再调用返回 false 且字节不动)。

### SEC-005 · CLI flag 吞噬(high)

- **来源**:内部安全审查(第二轮,R3)
- **触发条件**:`--challenge-url --keystore-bind` 这类 flag 相邻调用;旧 `getArg` 把下一个参数无条件当值。
- **旧症状**:开关名 `--keystore-bind` 被当作 URL 补进 loader DEX(虽有 https:// 校验兜底拒绝,但报错信息误导);`collectMulti` 同款问题。
- **修复语义**:`getArg`/`collectMulti` 判下一参数 `--` 开头则不当作值返回 undefined → 触发"缺值警告"而非吞并。
- **回归**:SEC-005——getArg 语义对照测试(flag 相邻→undefined / 正常取值 / 末尾无值)。

### SEC-006 · 参考挑战服务器全网卡裸奔(high)

- **来源**:内部安全审查(第二轮,R2)
- **触发条件**:旧 `scripts/challenge-server.ts` 用 `.listen(port)` 不绑地址。
- **旧症状**:监听**全网卡**——part3(密钥材料)对局域网裸奔,而启动日志却声称 `http://127.0.0.1`。
- **修复语义**:显式 `.listen(port, "127.0.0.1")` + 日志明示"仅本机回环,公网部署走 HTTPS 反代"。
- **回归**:SEC-006——结构断言:源码含显式回环绑定,且不得存在裸 `.listen(port` 调用。

### SEC-007 · 非 ASCII URL 写坏 DEX(critical)

- **来源**:内部安全审查(第二轮,R1)
- **触发条件**:挑战 URL 含非 ASCII(IDN 域名,如 `https://例え.jp`)。旧填充用 `padEnd`——按 UTF-16 **字符**数计数,而 DEX 字节区按**字节**写。
- **旧症状**:多字节字符使字节长 > 字符长 → `out.set` 越界写坏 DEX(与 SEC-002 同类破坏,不同触发路径)。
- **修复语义**:校验强制纯可打印 ASCII(`^[!-~]*$`)且字节长 ≤128;填充改为定长 `Uint8Array(128)` + `fill(0x23)`——结构上杜绝越界。
- **回归**:SEC-007(128B 标记字节级断言)+ harden-chain 的 IDN 拒绝用例。

### SEC-008 · npm 发布白名单遗漏(medium)

- **来源**:内部安全审查(第一轮,C5)
- **触发条件**:`package.json` 的 `files` 白名单缺 `runtime/droidseal-stub.dex` 与 `scripts/challenge-server.ts`。
- **旧症状**:发布的 npm 包无法构建壳(缺 stub DEX);用户无从部署挑战端点(缺参考服务器)。
- **修复语义**:白名单补齐;npm pack 白名单冒烟进 CI 与发布流程。
- **回归**:SEC-008——断言 CI 与 release 双处冒烟常驻(防止校验步骤被后续"清理"删除)。

### SEC-009 · loader asset 未按 stored 写入(high)

- **来源**:产物验收基线(H2 判据首跑即失败)——**验收基线制度的第一个战果**
- **触发条件**:加固流水线 Step 13 声明 loader asset 为 stored(`compressionMethod: 0`),但 ZIP 组装只对容器条目保留 stored,`.ldx` 被 deflate。上次同类修复只覆盖了容器,loader 漏网。
- **旧症状**:产物实际压缩方式与流水线声明/finding 对外声明不一致;密文高熵数据 deflate 无压缩收益,却使 minSdk<26 落盘降级路径的"按偏移直读"前提失效。
- **修复语义**:ZIP 组装对容器与 loader 均按名称判断保留 stored。
- **回归**:`scripts/verify-harden-artifact.ts` H2 判据(loader compressionMethod=0)——产物基线每次加固构建必跑;`--expect-plain` 反向断言防误报。

### SEC-010 · 补丁后 payload DEX 未通过 ART 校验和验证(严重)

- **来源**:真机验收(模拟器,首次启动尝试)——所有静态检查都测不到的缺陷类型
- **触发条件**:`updateDexChecksum` **先**对 bytes[12..] 算 Adler32,**后**写新 SHA-1 签名——签名一落盘,刚算好的校验和立即失效。两份拷贝(`dex-protection.ts`、`dex-payload-inject.ts`)同病;loader/stub 路径不受影响,因为 `dex-model.recomputeDexChecksums` 顺序正确。
- **旧症状**:zygote 直接拒载(`Failure to verify dex file: Bad checksum`)、`ClassNotFoundException`、静默 fail-closed 崩溃。构建期校验和重算测试通过,是因为它测的是正确实现,不是实际用的那份拷贝。
- **修复语义**:先签名、后校验和(规范顺序);两份拷贝统一为同一顺序,注释引用 SEC-010。
- **回归**:产物基线字节级断言(payload DEX 存储校验和 == Adler32(内容),SHA-1 签名 == hash(内容));可运行模拟器场景可锚定在 device-testing D2。

### SEC-011 · 方法抽取 stub 在节区边界留下非零填充(严重)

- **来源**:与 SEC-010 同一轮模拟器验收——校验和修复后暴露的链式缺陷
- **触发条件**:抽取 stub 把 `insns_size` 从 N 缩到 1 并写 2 字节 `return-void`,原指令区残留字节成为垃圾。ART 要求节区起点前填充为零(`Non-zero padding 20 before section start at 2eb96` → 拒载)。另外 `tries_size > 0` 的方法恢复后会丢异常表。
- **旧症状**:加固流水线全基线通过(字节足迹改动从未按 ART 对齐规则验证);真机静默 fail-closed 崩溃。
- **修复语义**:足迹不变 stub——保留 `insns_size`,指令区写 `return-void` + `nop` 填充(item 字节足迹与原始一致,偏移/对齐全保留,恢复逻辑不变);`tries_size > 0` 方法跳过抽取(恢复语义保真,跳过数经 finding 如实报告)。
- **回归**:字节级断言(抽取 code item 保持原足迹:`insns_size` 不变,残留字节全为 `nop`/`return-void`);抽取 finding 报告跳过的 try 方法数。

### SEC-012 · 标识符随机化破坏 DEX string_ids 字典序(严重)

- **来源**:同一模拟器链路——第三个顺序暴露的缺陷,每个都只有修掉前一个才显形
- **触发条件**:类名/资源名的等长字节替换未保持 `string_ids` 的字典序约束(UTF-16 码点序)。ART 严格校验:`Out-of-order string_ids` → 拒载。三个子缺陷:(a) 槽邻居用裸类路径查询,而表存 `L...;` 形式(二分永远不命中 → 槽被当作无约束);(b) 多个改名项槽区间重叠时,单项各自合法但互相交错;(c) 可打印 ASCII 候选含 JLS/ART 类名非法字符。
- **旧症状**:随机化构建通过全部构建期检查;真机拒载。资源名邻居紧贴时几乎必现(`droidseal.bin` 夹在 `droidseal-entry-` / `droidseal.original_app` 之间),类路径概率性触发。
- **修复语义**:保序槽内构造——用精确表形式查邻居,名字在 `(prev, next)` 区间内逐位置生成(合法字符集 = JLS 集 ∪ 原名字符),多项按表序级联批量生成(批内相对序校验 + 整批重试);槽无解时该项(或整批)保留原名并经 `missed` 如实报告(功能无损,静态签名仍在——已明示)。
- **回归**:`tests/harden-chain.test.ts` stub/loader 随机化测试现在同时断言 4/4 命中**与**输出 DEX 全表有序;落地前组合批跑(改名 + 标识符 + stub × 12)验证全部有序。

## 维护说明

- 新的安全修复按 [对抗回归政策](../SECURITY.md#adversarial-regression-policy) 追加 `SEC-XX` 条目与用例,编号单调递增不复用。
- SEC-001~008 与 `tests/security-regression.test.ts` 一一对应;产物/构建期缺陷(如 SEC-009)的回归可落在产物验收基线或脚本判据中,条目内必须写明回归位置。条目与回归位置不符本身即回归缺陷。
- 无 CVE 编号(项目尚未申请);条目编号即内部追溯 ID。
