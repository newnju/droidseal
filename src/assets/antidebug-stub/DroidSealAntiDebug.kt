package com.droidseal.antidebug

import android.content.pm.PackageManager
import android.os.Build
import android.os.Debug
import android.os.SystemClock
import android.util.Log
import java.io.FileInputStream
import java.security.MessageDigest
import java.util.concurrent.atomic.AtomicLong
import kotlin.system.exitProcess

/**
 * DroidSeal opt-in anti-debug stub — self-developed, MIT.
 *
 * Detection ONLY. This object never crashes, exits, or changes app behaviour on
 * its own. Call [inspect] to read signals, then decide the response in your app
 * (prefer treating these as risk inputs feeding a server-side decision, not as
 * the sole access control). Build-time linked; it is not injected into a
 * finished APK after the fact.
 */
object DroidSealAntiDebug {
    /** Process-wide minimum interval for resumed-Activity rechecks. */
    const val DEFAULT_RESUME_RECHECK_INTERVAL_MS: Long = 2_000L

    private const val TAG = "DroidSealAntiDebug"

    /** 处置策略：检测到异常信号后的动作（默认 LOG_ONLY，与旧行为一致）。 */
    enum class ResponsePolicy { LOG_ONLY, WARN, EXIT }

    /** 处置选项：由应用决定启用哪个策略；stub 默认不执行任何阻断动作。 */
    data class GuardOptions(
        val policy: ResponsePolicy = ResponsePolicy.LOG_ONLY,
        val exitDelayMs: Long = 0L,
        val exitAction: (() -> Unit)? = null,
        val onDetected: ((Report) -> Unit)? = null,
    )

    private val lastResumeInspectionMs = AtomicLong(-1L)

    @Volatile
    private var nativeAvailable: Boolean = false

    init {
        nativeAvailable = try {
            System.loadLibrary("droidseal_antidebug")
            true
        } catch (t: Throwable) {
            false
        }
    }

    /** Point-in-time snapshot of the available anti-debug signals. */
    data class Report(
        val nativeAvailable: Boolean,
        val tracerPid: Int,
        val injectionArtifacts: Boolean,
        val javaDebuggerConnected: Boolean,
        val waitingForDebugger: Boolean,
    ) {
        /** True if any signal indicates a debugger or instrumentation framework. */
        val suspicious: Boolean
            get() = tracerPid > 0 ||
                injectionArtifacts ||
                javaDebuggerConnected ||
                waitingForDebugger
    }

    /** Collect all signals. Native failures degrade to safe defaults. */
    fun inspect(): Report {
        val tracer = if (nativeAvailable) safeTracerPid() else -1
        val artifacts = if (nativeAvailable) safeArtifacts() else false
        return Report(
            nativeAvailable = nativeAvailable,
            tracerPid = tracer,
            injectionArtifacts = artifacts,
            javaDebuggerConnected = Debug.isDebuggerConnected(),
            waitingForDebugger = Debug.waitingForDebugger(),
        )
    }

    /**
     * Convenience: run [inspect] and invoke [onDetected] only when a signal
     * fires. The callback owns the response (log, degrade, report to server...).
     */
    fun guard(onDetected: (Report) -> Unit) {
        val report = inspect()
        if (report.suspicious) {
            onDetected(report)
        }
    }

    /**
     * 带处置策略的守卫。默认 LOG_ONLY（仅回调/记录，不阻断）；显式启用
     * [ResponsePolicy.WARN] 输出警告日志，[ResponsePolicy.EXIT] 会在延迟后
     * 调用 exitAction（默认 exitProcess）真正阻止应用继续运行。
     */
    fun guard(options: GuardOptions = GuardOptions()) {
        val report = inspect()
        if (report.suspicious) {
            applyPolicy(report, options)
        }
    }

    private fun applyPolicy(report: Report, options: GuardOptions) {
        options.onDetected?.invoke(report)
        when (options.policy) {
            ResponsePolicy.LOG_ONLY -> Unit
            ResponsePolicy.WARN -> Log.w(TAG, "检测到可疑运行环境：$report")
            ResponsePolicy.EXIT -> {
                Log.w(TAG, "检测到可疑运行环境，${options.exitDelayMs}ms 后退出：$report")
                Thread {
                    Thread.sleep(options.exitDelayMs.coerceAtLeast(0L))
                    (options.exitAction ?: { exitProcess(1) }).invoke()
                }.start()
            }
        }
    }

    /**
     * Recheck when a host Activity reaches onResume. Calls across all Activities
     * share a monotonic, process-wide throttle so rapid navigation does not scan
     * /proc/maps repeatedly. Returns null when throttled; otherwise returns the
     * report and invokes [onDetected] only for suspicious signals.
     *
     * This method only detects. It never exits, kills, or changes app behaviour.
     */
    fun guardOnActivityResumed(
        minIntervalMs: Long = DEFAULT_RESUME_RECHECK_INTERVAL_MS,
        onDetected: (Report) -> Unit,
    ): Report? {
        val interval = minIntervalMs.coerceAtLeast(0L)
        while (true) {
            val now = SystemClock.elapsedRealtime()
            val previous = lastResumeInspectionMs.get()
            if (previous >= 0L && now - previous < interval) {
                return null
            }
            if (lastResumeInspectionMs.compareAndSet(previous, now)) {
                val report = inspect()
                if (report.suspicious) {
                    onDetected(report)
                }
                return report
            }
        }
    }

    /** 带处置策略的 resumed 守卫：EXIT 策略下检测到异常会按 exitAction 阻断。 */
    fun guardOnActivityResumed(
        options: GuardOptions,
        minIntervalMs: Long = DEFAULT_RESUME_RECHECK_INTERVAL_MS,
    ): Report? {
        val interval = minIntervalMs.coerceAtLeast(0L)
        while (true) {
            val now = SystemClock.elapsedRealtime()
            val previous = lastResumeInspectionMs.get()
            if (previous >= 0L && now - previous < interval) {
                return null
            }
            if (lastResumeInspectionMs.compareAndSet(previous, now)) {
                val report = inspect()
                if (report.suspicious) {
                    applyPolicy(report, options)
                }
                return report
            }
        }
    }

    private fun safeTracerPid(): Int = try {
        nativeTracerPid()
    } catch (t: Throwable) {
        -1
    }

    private fun safeArtifacts(): Boolean = try {
        nativeHasInjectionArtifacts()
    } catch (t: Throwable) {
        false
    }

    /**
     * APK 完整性自检（防重打包）：对 [apkPath]（通常为 applicationInfo.sourceDir）
     * 计算 SHA-256 并与构建期嵌入的 [expectedSha256] 比对。
     * 未配置预期哈希时返回 true（不阻断）；读取失败或哈希不一致返回 false（保守视为可疑）。
     * 本方法只返回信号，由宿主决定处置。
     */
    fun checkApkIntegrity(apkPath: String, expectedSha256: String?): Boolean {
        if (expectedSha256.isNullOrBlank()) return true
        return try {
            val digest = MessageDigest.getInstance("SHA-256")
            FileInputStream(apkPath).use { input ->
                val buffer = ByteArray(1 shl 16)
                while (true) {
                    val n = input.read(buffer)
                    if (n < 0) break
                    digest.update(buffer, 0, n)
                }
            }
            val hex = digest.digest().joinToString("") { "%02x".format(it) }
            hex.equals(expectedSha256, ignoreCase = true)
        } catch (t: Throwable) {
            false
        }
    }

    /**
     * APK 签名指纹自检（防重打包组合）：读取 [packageManager] 的签名信息，计算各
     * 签名证书的 SHA-256 指纹并与构建期预期的 [expectedSha256Fingerprints] 集合比对
     * （支持多指纹轮换）。未配置预期指纹时返回 true（不阻断）；读取失败返回 false
     * （保守视为可疑）。本方法只返回信号，由宿主决定处置。
     */
    fun checkApkSignature(
        packageManager: PackageManager,
        packageName: String,
        expectedSha256Fingerprints: Set<String>?,
    ): Boolean {
        if (expectedSha256Fingerprints.isNullOrEmpty()) return true
        return try {
            val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val signers = info.signingInfo?.apkContentsSigners
                ?: info.signingInfo?.signingCertificateHistory
                ?: emptyArray()
            val actual = signers.map { signer -> sha256Hex(signer.toByteArray()) }
            actual.any { it in expectedSha256Fingerprints }
        } catch (t: Throwable) {
            false
        }
    }

    private fun sha256Hex(bytes: ByteArray): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(bytes)
        return digest.joinToString("") { "%02x".format(it) }
    }

    /** 模拟器特征标记（保守子集，降低真机误报）。 */
    private val emulatorMarkers = listOf("goldfish", "ranchu", "genymotion", "sdk_gphone", "vbox")

    /**
     * 模拟器检测信号（只报告，不阻断）：拼接 Build.FINGERPRINT / HARDWARE /
     * PRODUCT / MODEL 后匹配常见模拟器内核/厂商标记。读取失败返回 false。
     */
    fun checkEmulator(): Boolean {
        return try {
            val haystack = (Build.FINGERPRINT + " " + Build.HARDWARE + " " + Build.PRODUCT + " " + Build.MODEL)
                .lowercase()
            emulatorMarkers.any { it in haystack }
        } catch (t: Throwable) {
            false
        }
    }

    private external fun nativeTracerPid(): Int

    private external fun nativeHasInjectionArtifacts(): Boolean
}
