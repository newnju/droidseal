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

- 无 adb/无设备时如实 SKIP(exit 0)并给指引——skip 不是失败;失败格位即真机缺陷定位;
- **vmProtected 置 true 的前提 = 矩阵全绿**(变体 × API 每格 D1-D5 全过),与 threat-model 的如实降级纪律一致。

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
