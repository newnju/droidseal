# 真机测试指南

构建期可验证的判据由 `scripts/verify-harden-artifact.ts` 覆盖;运行时行为(解密启动闭环、二次启动、环境投票)只有真机能验收。本文件给出最小设备矩阵、判据含义与手动用例。

## 最小设备矩阵

| # | 设备 | 目的 | 必测组合 |
|---|---|---|---|
| 1 | API 26+ 真机或模拟器 | 主路径:`InMemoryDexClassLoader` 动态加载 | 标准加固、+`--keystore-bind`、+`--challenge-url` |
| 2 | API 24 真机或模拟器 | 降级路径:loader 落盘 + 偏移直读 | 标准加固(确认落盘解密仍闭环) |

### 矩阵化一键执行(推荐)

`scripts/device-matrix.sh` 把「变体 × API 级」参数化:每个 API 级自动构建 standard / keystore(`--ks-relaunch` 二次启动判据)/ challenge(在线 + `--challenge-offline` fail-closed 反转)三类产物并逐格跑 device-test.sh:

```bash
bash scripts/device-matrix.sh app-release.apk --api 26,24 [--cert-sha256 <hex>] [--output out-matrix]
```

环境变量注入(密钥材料一律留仓库外,不进命令行历史/仓库):

| 变量 | 作用 | 缺省 |
|---|---|---|
| `DS_KS_FLAGS` | 签名参数(`--keystore <jks> --ks-alias <a> --ks-pass <p> --key-pass <p>`)——三变体产物都必须签名,否则安装判据必然 `INSTALL_PARSE_FAILED_NO_CERTIFICATES` | 空=产物不签名(仅构建期基线可用) |
| `DS_TLS_CERT` / `DS_TLS_KEY` | challenge 在线格的 TLS 证书链/私钥(构建期 https 门强制 challenge URL 为 https://,不允许降级 http);模拟器经 `https://10.0.2.2:8443` 直达本机回环 | `~/ds-fixtures/tls/srv-fullchain.pem` / `srv.key` |
| `ADB` / `BUN` | adb 与 bun 可执行文件绝对路径(CI/WMI 等继承环境 PATH 不可靠的场景) | `adb` / `bun` |

- 无 adb/无设备/无 TLS 材料时如实 SKIP(exit 0)并给指引——skip 不是失败;失败格位即真机缺陷定位;
- 判据纪律:启动用 `monkey`(不依赖 `resolve-activity`——adbd 抖动时该子命令挂空会导致 D2 假失败);离线格前断言端点端口已释放;
- **vmProtected 与本矩阵无关**——矩阵验收的是壳加载链(runtimeProtected);vmProtected 绑定 VMP 注入链(里程碑 B),在其真机验收全绿前恒 false,与 threat-model 的如实降级纪律一致。

## 标准流程

```bash
# 1. 构建(纯本地模式)
bun run src/index.tsx harden app-release.apk --output out --cert-sha256 <release-cert-sha256> --keystore release-key.jks --ks-pass <pass>

# 2. 构建期基线(不需设备,应先过)
bun scripts/verify-harden-artifact.ts out/hardened/app-release.hardened.apk

# 3. 真机验收(需 adb + 设备)
bash scripts/device-test.sh out/hardened/app-release.hardened.apk com.example.app

# 4. Keystore 绑定产物追加二次启动判据
bash scripts/device-test.sh out/hardened/app-release.hardened.apk com.example.app --ks-relaunch
```

## 判据含义

| 判据 | 含义 | 失败时先查 |
|---|---|---|
| D1 安装 | `adb install -r` 成功 | minSdk、签名冲突(先卸载旧包) |
| D2 5 秒存活 | stub 引导 → loader 解密 → 壳启动闭环完成 | D3 的 logcat 标记;挑战模式产物是否可达端点 |
| D3 无失败标记 | logcat 无 `integrityFailed`(证书/manifest 校验失败)与 `BadTag`(密钥错误) | 安装包是否被重签;设备是否离线(挑战模式 fail-closed 是预期) |
| D4 二次启动 | KS 绑定产物 unseal → XOR part3 → 还原路径正确 | 仅 `--keystore-bind` 产物需测;首启后清数据会使其失效(设计如此) |
| D5 卸载 | 为下一用例让路 | — |
| V1 VM 桥注册(仅 `--vm-mode`) | logcat 出现 `vm bridge: N methods registered total` 且 N≥1,且无 UnsatisfiedLinkError/NoSuchMethodError | 挖空是否命中方法;`vm bridge: class not found` 说明 loadClass 失败;通过前 vmProtected 恒 false |

## 实测记录(2026-09,API 26 x86_64 模拟器)

首轮完整验收在构建期 264/264 测试与 H1–H6 产物基线全绿的情况下 **D2 失败(首启即崩,无失败标记)**——逐层挖出三个构建级缺陷并修复(SEC-010 校验和/签名顺序、SEC-011 抽取 stub 非零填充、SEC-012 string_ids 字典序,见[安全台账](security-ledger.zh-CN.md));三修齐备后复测:

| 判据 | 结果 | 备注 |
|---|---|---|
| D1 安装 | PASS | 标准签名产物 |
| D2 5 秒存活 | PASS | 解密加载成功,WebView/View 正常构造;二次启动复核亦 PASS(非偶然) |
| D3 无失败标记 | 0 | 无 `integrityFailed`/`BadTag`/校验和错误 |
| D4 二次启动 | 未测 | KS 绑定路径本轮未构建 |
| D5 卸载 | PASS | — |

**经验教训**:① D3=0 不能单独排除失败——loader `integrityFailed` 是内部标志不写 logcat,失败时唯一现象是 D2 静默崩溃,需临时打点诊断(诊断完还原);② Capacitor 应用 launcher activity 自带 `android:process=":isolated"`,验存活要用 `ps -A | grep <包名>` 而非 `pidof`(进程名带后缀);③ 首启崩溃时三个缺陷是链式暴露的——修掉校验和才显形 padding,修掉 padding 才显形字典序,必须修一个复测一轮。

## 实测记录(2026-09-30,API 24 x86_64 模拟器,壳类名随机化 + fail-closed 轮)

fixture APK(ds-hello,8589B,minSdk 24)三变体逐格功能级验收(判据升级:**功能级 `Displayed` 为准,pid 存活≠解密成功**;DS_DIAG step1-5 全链打点):

| 变体 | 判据 | 结果 | 备注 |
|---|---|---|---|
| standard(无证书) | Displayed | PASS | `+1s391ms`,无证书走明文 loader 直注路径 |
| keystore(--keystore-bind + cert-sha256) | Displayed + 全链 | PASS | step1 解密 22080B → step5 attached → `+1s438ms` |
| challenge 在线(TLS 端点可达) | Displayed + 全链 | PASS | 同上,系统 CA 已注入 |
| challenge 离线(杀端点+全新安装首发) | fail-closed | PASS | **无 Displayed** + step1 fail-closed 打点 + 进程被杀(pid 空),crash-loop 重启亦被杀,原始 Activity 不渲染 |

本轮验收挖出并修复的缺陷(提交 `9c5e4f9`):

1. **壳类名随机化三处错位**——①二次剥壳(已剥壳名再 `slice(1,-1)`,34→32 字符);②槽内随机名无 `L...;` 结构字符与 `/` 分隔符,manifest 无点裸名被 Android 加包前缀 → ClassNotFoundException(间歇性:约 58% 构建产出无 `/` 名);③manifest 点分命名空间要求斜杠名转点分。
2. **fail-closed 名存实亡**——stub 解密失败仅 `real=null` 空身份返回,原 dex 照常渲染 `Displayed`;改为任何失败路径 `killProcess + System.exit`,离线格实测不再渲染。
3. **meta 键两侧不一致**——manifest 写流水线自造随机键,stub 内批量收敛失败时保留原标记 → 运行时取不到 asset 路径误杀;修复为 manifest 跟随 `stubResult.metaKey` 回传值,候选不 fit 槽时槽内生成,两侧恒一致。

**判据纪律**:D2/D6 存活判定用 `pidof`+dumpsys(API 24 镜像 `ps -A` 不可靠);功能级一律以 logcat `Displayed` 为准;challenge 离线格预期 displayed=0 + 进程终止,fail-closed 生效的证明是"原始 Activity 不渲染"而非崩溃信息。

## 实测记录(2026-10-01,API 24 x86_64 模拟器,device-matrix.sh 一键化全绿轮)

`device-matrix.sh` 首次全流程跑通(此前仅验证过 SKIP 路径),4 格全绿(`MATRIX PASS: 4 用例全绿,MATRIX_EXIT=0`):

| 格位 | 判据 | 结果 |
|---|---|---|
| standard | D1a/D1/D2/D3/D6 | 5/5 PASS(D2 pid 存活,解密+壳启动闭环) |
| keystore(`--ks-relaunch`) | D1a/D1/D2/D3/D5/D6 | 6/6 PASS(**D5 二次启动存活,unseal→XOR part3 还原路径首次实测通过**) |
| challenge 在线 | D1a/D1/D2/D3/D6 | 5/5 PASS(TLS 端点可达,part3 在线获取) |
| challenge 离线 | D1a/D1/D2/D3/D6 | 5/5 PASS(端点杀掉后进程 5s 内不存活,fail-closed 语义正确) |

本轮一键化过程中修掉的脚本级缺陷(产物与壳链本身无回归):

1. **产物路径过期**:脚本按旧扁平结构取产物,当前 CLI 输出在 `$OUT/<label>/hardened/` 子目录——ls 路径补层;
2. **签名参数缺失**:三变体均未传 keystore 参数 → 产物未签名 → 安装判据必然 `INSTALL_PARSE_FAILED_NO_CERTIFICATES`;签名参数改经 `DS_KS_FLAGS` 环境变量注入(密钥材料留仓库外);
3. **包名解析经 cmd shell**:bun `execSync` 在 w64devkit 环境下 PATH 跨层转换不可靠 → 改 bash 直调 aapt 绝对路径 + sed 提取;
4. **启动依赖 resolve-activity**:adbd 抖动时该子命令挂空 → `am start` 拿空 activity 名 → D2 假失败(第九轮 standard/keystore/challenge-online 三格的 D2 失败与 challenge-offline 的假 PASS 均源于此)→ 启动改 `monkey`,D2 无 pid 时重试一次;
5. **离线格端点未真杀**:challenge 在线/离线两格共用构建,原脚本在两格跑完后才杀 server → 离线格端点可达、解密成功、判据方向反转失败;改为在线格验收后立即杀端点(netstat 拿监听 PID → `Stop-Process` 兜底,MSYS kill 对 Windows 侧进程无效、`cmd //c` 在 w64devkit 下挂死均已实证)并断言端口释放;
6. **环境探测**:adb 预检改直接试跑 `"$ADB" version`(支持 `ADB` 环境变量覆盖——WSL bash 劫持 `bash` 命令名时不继承 Windows 环境变量,须用 w64devkit bash 全路径调脚本)。

## 实测记录(2026-10-02,API 26 + API 24 x86_64 双模拟器,多设备 8 格全绿轮)

双模拟器并存(`emulator-5556`=API 26,`emulator-5558`=API 24)首次跑完整 `--api 26,24` 矩阵,**8 格全绿**:

| 格位(API 26) | 判据 | 结果 |
|---|---|---|
| standard | D1a/D1/D2/D3/D6 | 5/5 PASS |
| keystore(`--ks-relaunch`) | D1a/D1/D2/D3/D5/D6 | 6/6 PASS(D5 二次启动存活) |
| challenge 在线 | D1a/D1/D2/D3/D6 | 5/5 PASS(TLS 端点可达) |
| challenge 离线 | D1a/D1/D2/D3/D6 | 5/5 PASS(原始 Activity 未渲染,fail-closed 正确) |

| 格位(API 24) | 判据 | 结果 |
|---|---|---|
| standard | D1a/D1/D2/D3/D6 | 5/5 PASS(落盘降级路径解密闭环) |
| keystore(`--ks-relaunch`) | D1a/D1/D2/D3/D5/D6 | 6/6 PASS(D5 二次启动存活) |
| challenge 在线 | D1a/D1/D2/D3/D6 | 5/5 PASS |
| challenge 离线 | D1a/D1/D2/D3/D6 | 5/5 PASS(原始 Activity 未渲染,fail-closed 正确) |

本轮修掉的缺陷(两个流水线级 + 三个脚本级):

1. **加固产物静默不签名(流水线级,最严重)**:`signApk`/`zipalignApk` 经 `spawnSync` 直接调 `.bat`,在 bun/Node≥20 下静默失败(status null)→ 产物缺 META-INF → 安装判据必然 `INSTALL_PARSE_FAILED_NO_CERTIFICATES`。修复:Windows `.bat` 工具调用加 `shell: true`(src/core/apk-repack.ts);
2. **重复加固同目录时 keystore 生成失败(流水线级)**:输出目录残留上次的自签名 keystore,`keytool -genkeypair` 因 alias 已存在而失败 → `signingConfig` 变 undefined → 产物再次不签名。修复:同一输出目录复用已存在 keystore(保证多次产物签名一致)(src/core/harden-pipeline.ts);
3. **多设备并存误判"无设备"(脚本级)**:两台模拟器在线时 `adb get-state`(无 `-s`)报 "more than one device" 而失败,被误判为无设备 → 全部格位假失败。修复:device-test.sh 新增 `--serial` 定向(全部 adb 调用经 ADBWRAP 包装),device-matrix.sh 新增 `DEV_SERIAL()` 按 API 级自动选格;
4. **选格函数管道吞 stdin(脚本级)**:`DEV_SERIAL` 初版用管道 `while read` 循环,循环体内 `adb shell` 吞掉管道剩余 stdin,检查完第一台设备后循环提前结束,第二台永远匹配不到(API 24 四格全报"无已连接设备")。修复:改 `for` 循环 + `</dev/null`;
5. **离线格 fail-closed 判据失真(脚本级)**:无头模拟器上崩溃后 "Application Error" 对话框挂住进程(binder_thread_read),`pidof` 恒非空,旧"进程 5s 内不存活"判据永远误报。修复:改焦点窗口断言——`Application Error: <pkg>` 或非本包焦点均判"原始 Activity 未渲染 = fail-closed 生效",与本文档"fail-closed 生效的证明是原始 Activity 不渲染"纪律一致(scripts/device-test.sh D2 离线分支)。

另:CI/计划任务等无 stdin 会话里 `adb shell` 会挂在 stdin 转发上永久阻塞(61 个 adb.exe 孤儿进程实证),ADBWRAP 现恒以 `</dev/null` 调用。

## 实测记录(2026-10-04,API 26 x86_64 模拟器,VMP 里程碑 B --vm-mode 首次真机验收)

**5/5 全绿**(`device-test.sh --vm-mode --serial emulator-5554`):

| 判据 | 结果 |
|---|---|
| D1 install -r | ✓(三 ABI 产物) |
| D2 进程存活 | ✓ pid=3518(解密+壳启动闭环完成) |
| D3 无完整性/GCM 失败标记 | ✓ |
| V1 VM 桥注册 | ✓ logcat `vm bridge: 1 methods registered total`(vmLeaf (I)I) |
| D6 卸载干净 | ✓ |

本轮修掉的缺陷(两个存量对拍 bug + 两个接线缺口):

1. **CodeItem 表 codeOffset 语义错位(流水线级,最严重)**:TS 侧 `buildCodeItemTable` 写的 `codeOffset` 是相对 codeData 区的偏移(从 0 起),Java 侧 `restoreCodeItems` 按**表内绝对偏移** `arraycopy(table, codeOff, dex, origOff, ...)` 消费——第一条记录把表头+记录字段当方法体拷进 DEX,ART 校验拒载(`outs_size(520) > registers_size(4)`,520/4 恰是 record0 的 origOff/methodIdx)。此前 tries_size 误判使挖空恒 0,还原链从未真机激活,故一直未暴露。修复:codeOffset 改为表内绝对偏移(codeBase = header+records)(src/core/codeitem-table.ts);
2. **hollowMethods tries_size 读取错误(流水线级)**:误用 `getUint32(code_item+8)` 读 tries_size——实际布局是 u16@+6(registers@0 ins@2 outs@4 tries@6 debug_info@8),+8 起是 debug_info_off,所有方法被误判带 try/catch 全跳过(0/3)。修复为 `getUint16(+6)`(src/core/dex-protection.ts);
3. **注册入口时序(接线缺口)**:初版 `dsvmRegisterAll()` 挂在 AppComponentFactory.instantiateApplication——该入口 API 28+ 才存在,API 26 设备根本不执行;且 JNI FindClass 用壳 loader 的加载器,定位不到 InMemoryDexClassLoader 里的 app 类。修复:签名改 `dsvmRegisterAll(ClassLoader appLoader)`(C 侧经 loadClass 定位 VM 类),调用点移到 init() 的 replaceClassLoader 之后(SO 已在 fetchPart2 时加载,顺序在前),fail-open(src/core/vmp-compiler.ts、runtime/java/.../DroidSealLoader.java);
4. **加固产物缺 x86_64 ABI(流水线级)**:Step 12.1 只编 arm64-v8a/armeabi-v7a,模拟器为 x86_64 → `INSTALL_FAILED_NO_MATCHING_ABIS`(壳 SO 首次真机编出才暴露,此前 NDK 缺失时 APK 无 lib/ 条目反而不受影响)。修复:ABI 列表补 x86_64(src/core/harden-pipeline.ts)。

环境注:本会话内 PowerShell Start-Process 分离启动的模拟器四次均在 boot 前消亡(默认/无快照/软渲染/无窗口组合一致),改 schtasks 计划任务方式启动后稳定(API 26 boot 成功)——与会话回收相关的启动路径问题,计划任务是当前可靠方式。

## 手动用例(脚本不覆盖)

### 重签必败(P0-A 锚点)

一键复现(构建级部分——证书指纹变化 ⇒ 密钥必变 + 结构基线仍过):

```bash
bun scripts/attack-sample-resign.ts out/hardened/app-release.hardened.apk --out attack-sample
```

运行时部分(攻击的"实际失败现象"):

```bash
# 用另一把 key 重签加固产物 → 安装启动 → 应解密失败(进程可退出或白屏,不崩溃循环)
apksigner sign --ks other-key.jks --out resigned.apk out/hardened/app-release.hardened.apk
bash scripts/device-test.sh resigned.apk com.example.app   # 预期:D2 失败且 D3 出现 integrityFailed/BadTag
```

### 挑战模式 fail-closed(离线)

设备断网 → 启动挑战模式产物 → 预期解密静默失败(D2 失败、无崩溃),恢复网络后正常。这验证 fail-closed 而非降级。

### Frida 环境投票(P0-B/P1,可选)

设备装 frida-server → `frida -U -f com.example.app` attach → 预期:不 patch 检测时派生错钥,解密失败。注意:端口探测在 27042/27043,同设备多实例可能误报(已知取舍,见 README)。

## 已知边界(如实)

- 内存 dump(root + 持久物理接触)不可完全防;延迟销毁可被 hook `System.exit` 绕过。
- API 24 落盘降级路径的 loader 文件可被 root 提取(加密态)。
- 真机数据是唯一可信验收——构建期全绿不等于运行时正确。
