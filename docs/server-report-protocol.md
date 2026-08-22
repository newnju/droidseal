# 服务端协作上报协议（signalsToJson）

> 状态：协议就绪。`DroidSealAntiDebug.signalsToJson(...)` 把全部检测信号汇总为 JSON 字符串，
> 由宿主上报给服务端风控；**只报告，不阻断**——决策在服务端。

## 协议字段

| 字段 | 类型 | 含义 |
|---|---|---|
| `nativeAvailable` | boolean | Native 反调试模块是否可用（不可用时信号降级） |
| `tracerPid` | int | `/proc/self/status` 的 TracerPid（被调试时非 0） |
| `injectionArtifacts` | int | 检测到的注入框架标记数（magisk/zygisk/lspd/riru/Sui） |
| `javaDebuggerConnected` | boolean | Java 调试器是否已连接（`Debug.isDebuggerConnected`） |
| `waitingForDebugger` | boolean | 是否处于等待调试器状态 |
| `integrityOk` | boolean | APK SHA-256 完整性自检是否通过（未配置预期哈希时为 true） |
| `signatureOk` | boolean | 签名证书指纹自检是否通过（未配置预期指纹时为 true） |
| `emulator` | boolean | 模拟器特征检测（Build.FINGERPRINT/HARDWARE/PRODUCT/MODEL 保守标记） |
| `vpnOrProxy` | boolean | 系统全局 HTTP 代理或 tun/ppp/tap 网络接口特征 |
| `clockAnomaly` | boolean | 单调时钟与墙上时钟偏移超阈值（默认 30s）跳变 |

## 服务端决策建议

只把客户端信号作为**风险信号输入**，与服务端会话/账号/设备画像组合：

| 信号组合 | 建议处置 |
|---|---|
| `integrityOk=false` 或 `signatureOk=false` | 高度疑似重打包/篡改 → 阻断或人工复核 |
| `javaDebuggerConnected` 或 `tracerPid>0` | 调试行为 → 降级或告警 |
| `injectionArtifacts>0` | 注入框架 → 告警 + 风控复核 |
| `emulator=true` | 模拟器 → 按业务策略（风控/灰度） |
| `vpnOrProxy=true` 或 `clockAnomaly=true` | 环境异常 → 记录 + 降级 |
| 全部为正常值 | 正常 → 放行 |

## 抗滥用与边界

- **信号可被绕过**（定制内核/脱壳/内存 patch）——客户端信号**不能**作为唯一访问控制；
- 上报应限频、脱敏（不含业务明文），服务端需做校验与风控组合；
- `signalsToJson` 是纯函数式的信号汇总，不触发任何网络请求（上报由宿主负责）。

## 接入示例

```kotlin
val json = DroidSealAntiDebug.signalsToJson(
    contentResolver,
    applicationInfo.sourceDir,
    BuildConfig.DROIDSEAL_EXPECTED_APK_SHA256,
    BuildConfig.DROIDSEAL_EXPECTED_SIGNER_FINGERPRINTS,
    packageManager,
    packageName,
)
// POST 到服务端风控端点（宿主实现网络与限频）
```
