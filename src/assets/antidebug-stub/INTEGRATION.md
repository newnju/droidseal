# DroidSeal 反调试 Stub（opt-in，构建期链接）

自研、Apache-2.0 许可。**内置可配置处置策略，默认仅上报不阻断**：检测到异常时按你选择的策略处理（LOG_ONLY 仅回调/记录、WARN 输出警告、EXIT 延迟后退出），默认 LOG_ONLY 与旧行为一致，阻断需显式启用。它在**构建期通过 NDK/CMake 链接进你的应用**，不是事后注入成品 APK——与 DroidSeal“绝不向未知产物合成可执行代码”的边界一致。

## 文件

安装脚本会写入以下文件（相对 app 模块目录）：

- `src/main/cpp/droidseal_antidebug.c` — JNI 检测实现（TracerPid + 注入框架 maps 扫描）。
- `src/main/cpp/CMakeLists.txt` — 构建该 native 库。
- `src/main/java/com/droidseal/antidebug/DroidSealAntiDebug.kt` — Kotlin API。
- `droidseal-antidebug/INTEGRATION.md` — 本说明。

> 若你的模块已有 `CMakeLists.txt`，请勿用本文件覆盖，而是把 `droidseal_antidebug.c` 加入你现有的 `add_library`，或用 `add_subdirectory` 引入。

## 接线

在 app 模块的 `build.gradle(.kts)` 的 `android { }` 中启用 externalNativeBuild：

```groovy
android {
    defaultConfig {
        ndk {
            abiFilters "arm64-v8a", "armeabi-v7a", "x86_64"
        }
    }
    externalNativeBuild {
        cmake {
            path "src/main/cpp/CMakeLists.txt"
        }
    }
}
```

## 使用

尽早采样（例如 `Application.onCreate` 或关键业务入口前），并**自行决定处置策略**：

```kotlin
import com.droidseal.antidebug.DroidSealAntiDebug

class App : android.app.Application() {
    override fun onCreate() {
        super.onCreate()
        DroidSealAntiDebug.guard { report ->
            // 处置由你决定：这里只做示例。建议把信号作为服务端风控输入，
            // 而不是唯一访问控制。避免直接崩溃带来的兼容性与体验风险。
            android.util.Log.w("DroidSeal", "anti-debug signal: " + report)
        }
    }
}
```

仅在 `Application.onCreate` 采样会留下“应用启动后再附加调试器”的空窗。需要覆盖恢复态时，由 Activity 在 `onResume` 主动调用节流复查 API：

```kotlin
class MainActivity : android.app.Activity() {
    override fun onResume() {
        super.onResume()
        DroidSealAntiDebug.guardOnActivityResumed { report ->
            // 仍由应用决定：建议上报为服务端风控信号，不要把 kill 当作默认策略。
            android.util.Log.w("DroidSeal", "resumed anti-debug signal: " + report)
        }
    }
}
```

`guardOnActivityResumed` 使用 `SystemClock.elapsedRealtime()` 和进程级 `AtomicLong` 节流，默认两秒内最多执行一次完整采样；多个 Activity 快速切换不会反复扫描 `/proc/maps`。执行采样时返回 `Report`，因节流跳过时返回 `null`。可传入 `minIntervalMs` 调整间隔，但应先做性能与误报测试。

需要“检测到即阻断”时，显式启用 EXIT 策略（默认仍为 LOG_ONLY）：

```kotlin
DroidSealAntiDebug.guard(
    DroidSealAntiDebug.GuardOptions(
        policy = DroidSealAntiDebug.ResponsePolicy.EXIT,
        exitDelayMs = 0L, // 可加延迟，先让应用上报/清理
        onDetected = { report ->
            // 可选业务钩子：上报风控、埋点（之后仍会执行退出）
        },
    ),
)
```

`ResponsePolicy.WARN` 仅输出警告日志；`exitAction` 可覆写默认的 `exitProcess(1)`（例如先展示提示页再退出）。**建议仍把信号作为服务端风控输入，EXIT 策略经真机矩阵回归后再上线。**

或读取原始快照：

```kotlin
val report = DroidSealAntiDebug.inspect()
if (report.suspicious) {
    // report.tracerPid / report.injectionArtifacts /
    // report.javaDebuggerConnected / report.waitingForDebugger
}
```

## 完整性自检（防重打包）

`checkApkIntegrity` 与 `checkApkSignature` 提供防重打包信号：把构建期得到的 APK SHA-256 与签名证书指纹作为预期值传入，运行时不匹配即返回 false（未配置预期时返回 true，读取失败保守返回 false）。建议在 `Application.onCreate` 与 `guardOnActivityResumed` 节流周期内**定期复查**（复用两秒节流，避免频繁读文件）：

```kotlin
val integrityOk = DroidSealAntiDebug.checkApkIntegrity(
    applicationInfo.sourceDir,
    BuildConfig.DROIDSEAL_EXPECTED_APK_SHA256, // 构建期由发布流程注入
)
val signatureOk = DroidSealAntiDebug.checkApkSignature(
    packageManager,
    packageName,
    BuildConfig.DROIDSEAL_EXPECTED_SIGNER_FINGERPRINTS,
)
```

## 服务端协作上报

stub 只产生信号，决策在服务端。建议把以下字段组合上报（格式自定，例如 JSON）：

- `tracerPid`、`injectionArtifacts`、`javaDebuggerConnected`、`waitingForDebugger`（`inspect()` 快照）
- `integrityOk`、`signatureOk`（防重打包）
- `emulator`（`checkEmulator()`）、`vpnOrProxy`（`checkVpnProxy(resolver)`）

服务端按风险等级决策（降级、限流、人工复核），不要只依赖客户端信号做唯一访问控制；信号可被绕过，需与授权/风控组合使用。

信号汇总上报示例（`signalsToJson`——只报告，决策在服务端）：

```kotlin
val json = DroidSealAntiDebug.signalsToJson(
    contentResolver,
    applicationInfo.sourceDir,
    BuildConfig.DROIDSEAL_EXPECTED_APK_SHA256,
    BuildConfig.DROIDSEAL_EXPECTED_SIGNER_FINGERPRINTS,
    packageManager,
    packageName,
)
// 把 json 上报给服务端风控（JSON 含 inspect 快照 + 完整性/签名/模拟器/VPN·代理/时钟异常）
```

## 边界与限制

- **可被绕过**：反调试是提高成本的纵深防御，不是不可逾越的屏障。定制内核、硬件取证、patch native 库都可能绕过。请把它与服务端授权、完整性/风控信号组合使用。
- **误伤风险**：某些机型/ROM、企业 MDM、无障碍服务可能触发误报；上线前请在真机矩阵回归。
- **默认不阻断，处置可选**：默认 LOG_ONLY 不会 kill 进程；显式启用 EXIT 策略才会退出。直接崩溃容易误伤合法用户并暴露检测点，仍建议以静默降级或服务端联动为主。
- **完整性校验**：本 stub 不覆盖“重签名/资源篡改”检测。签名校验请结合 DroidSeal 报告建议在应用层 + 服务端实现。
