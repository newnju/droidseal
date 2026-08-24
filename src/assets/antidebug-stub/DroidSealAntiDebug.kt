package com.droidseal.antidebug

import android.content.ContentResolver
import android.content.pm.PackageManager
import android.os.Build
import android.os.Debug
import android.os.SystemClock
import android.provider.Settings
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.net.NetworkInterface
import java.security.MessageDigest
import java.util.concurrent.atomic.AtomicLong
import java.util.concurrent.atomic.AtomicLongArray
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

    /**
     * VPN/代理检测信号（只报告，不阻断）：系统全局 HTTP 代理非空视为代理信号；
     * 网络接口中出现 tun/ppp/tap 等 VPN 特征接口名视为 VPN 信号。读取失败返回 false。
     */
    fun checkVpnProxy(contentResolver: ContentResolver?): Boolean {
        return try {
            val hasProxy = contentResolver != null &&
                !Settings.Global.getString(contentResolver, Settings.Global.HTTP_PROXY).isNullOrBlank()
            val vpn = try {
                val interfaces = NetworkInterface.getNetworkInterfaces() ?: return hasProxy
                var found = false
                while (interfaces.hasMoreElements()) {
                    val name = interfaces.nextElement().name.lowercase()
                    if (name.contains("tun") || name.contains("ppp") || name.contains("tap")) {
                        found = true
                        break
                    }
                }
                found
            } catch (t: Throwable) {
                false
            }
            hasProxy || vpn
        } catch (t: Throwable) {
            false
        }
    }

    /** 时钟检测基线：[elapsedRealtimeMs, wallClockMs]。 */
    private val clockBaseline = AtomicLongArray(2)

    /**
     * 时间戳异常检测信号（只报告，不阻断）：对比单调时钟（elapsedRealtime）与
     * 墙上时钟（currentTimeMillis）的相对偏移。首次调用记录基线；之后两者偏移
     * 跳变超过 [thresholdMs] 视为时钟被回拨/前拨的信号。读取失败返回 false。
     */
    fun checkClockAnomaly(thresholdMs: Long = 30_000L): Boolean {
        return try {
            val nowElapsed = SystemClock.elapsedRealtime()
            val nowWall = System.currentTimeMillis()
            val baselineElapsed = clockBaseline.get(0)
            if (baselineElapsed == 0L) {
                clockBaseline.set(0, nowElapsed)
                clockBaseline.set(1, nowWall)
                return false
            }
            val baselineWall = clockBaseline.get(1)
            val expectedWall = baselineWall + (nowElapsed - baselineElapsed)
            val drift = if (expectedWall >= nowWall) expectedWall - nowWall else nowWall - expectedWall
            drift > thresholdMs
        } catch (t: Throwable) {
            false
        }
    }

    /**
     * Frida 注入分层检测（`/proc/self/maps` 特征）：扫描映射区中的 frida-agent/gadget/
     * frida-server/libfrida 特征片段。只报告信号，不阻断；读取失败或未命中即 false（失败关闭）。
     */
    fun checkFridaInjection(): Boolean {
        return try {
            val maps = File("/proc/self/maps").readText()
            maps.contains("frida")
        } catch (t: Throwable) {
            false
        }
    }

    // 层面3（对抗性升级）：检测 Xposed 框架痕迹（框架目录/桥接 jar——主动防御）。
    fun checkXposedPresence(): Boolean {
        return try {
            val paths = listOf("/data/data/de.robv.android.xposed", "/system/framework/XposedBridge.jar")
            paths.any { File(it).exists() }
        } catch (t: Throwable) {
            false
        }
    }

    // 层面3（对抗性升级）：检测逆向工具进程痕迹（frida-server/Substrate 等——反制逆向工具）。
    fun checkReverseToolTraces(): Boolean {
        return try {
            val proc = File("/proc").listFiles() ?: emptyArray()
            proc.any { dir ->
                if (!dir.isDirectory) return@any false
                val status = File(dir, "cmdline").takeIf { it.canRead() }?.readText() ?: ""
                status.contains("frida") || status.contains("substrate") || status.contains("objection")
            }
        } catch (t: Throwable) {
            false
        }
    }

    // 层面4（运行时环境深度检测）：系统调试属性（ro.debuggable/ro.secure——不只是调试器）。
    fun checkSystemProperties(): Boolean {
        return try {
            val cls = Class.forName("android.os.SystemProperties")
            val get = cls.getMethod("get", String::class.java)
            val debuggable = get.invoke(null, "ro.debuggable") as? String
            val secure = get.invoke(null, "ro.secure") as? String
            debuggable == "1" || secure == "0"
        } catch (t: Throwable) {
            false
        }
    }

    // 方向④（多文件完整性检测）：比对 APK 内关键文件（classes*.dex / lib/*.so / res 代表文件）的
    // SHA-256 与期望清单——不一致返回被篡改文件列表（篡改定位到文件级——周期调用 onResume 节流）。
    fun checkMultiFileIntegrity(apkPath: String?, expectedHashes: Map<String, String>): String {
        if (apkPath == null || expectedHashes.isEmpty()) return ""
        return try {
            val jar = java.util.jar.JarFile(apkPath)
            val tampered = mutableListOf<String>()
            val hasher = java.security.MessageDigest.getInstance("SHA-256")
            val entries = jar.entries()
            while (entries.hasMoreElements()) {
                val entry = entries.nextElement()
                val name = entry.name
                val expected = expectedHashes[name]
                if (expected == null) continue
                if (entry.isDirectory) continue
                val input = jar.getInputStream(entry)
                val buffer = ByteArray(8192)
                var read: Int
                while (input.read(buffer).also { read = it } != -1) {
                    hasher.update(buffer, 0, read)
                }
                input.close()
                val digest = hasher.digest().joinToString("") { "%02x".format(it) }
                if (digest != expected) tampered.add(name)
            }
            jar.close()
            tampered.joinToString(",")
        } catch (t: Throwable) {
            ""
        }
    }

    // 完整性自检定期化（运行时防护扩展）：onResume 节流——避免每次生命周期回调都重算哈希
    //（性能）；超过节流间隔（默认 60s）才重新检查——满足「周期自检、不拖慢交互」。
    private object IntegrityCheckThrottle {
        private const val INTERVAL_MS = 60_000L
        private var lastCheckMs = 0L
        fun shouldRun(nowMs: Long = System.currentTimeMillis()): Boolean {
            if (nowMs - lastCheckMs < INTERVAL_MS) return false
            lastCheckMs = nowMs
            return true
        }
    }

    /** 宿主在 onResume 调用：节流后执行完整性自检（返回是否本次真正执行了检查）。 */
    fun periodicIntegrityCheck(apkPath: String?, expectedSha256: String?, expectedMultiFileHashes: Map<String, String>): Boolean {
        if (!IntegrityCheckThrottle.shouldRun()) return false
        if (apkPath == null) return false
        checkApkIntegrity(apkPath, expectedSha256)
        checkMultiFileIntegrity(apkPath, expectedMultiFileHashes)
        return true
    }

    /**
     * 服务端协作上报：把当前检测信号汇总为 JSON 字符串（只报告，不阻断）。
     * 字段含 inspect() 快照、完整性、签名、模拟器、VPN/代理、时钟异常；宿主上报后由服务端决策。
     */
    fun signalsToJson(
        contentResolver: ContentResolver?,
        apkPath: String?,
        expectedSha256: String?,
        expectedFingerprints: Set<String>?,
        packageManager: PackageManager?,
        packageName: String?,
        expectedMultiFileHashes: Map<String, String>? = emptyMap(),
    ): String {
        val report = inspect()
        val integrity = apkPath?.let { checkApkIntegrity(it, expectedSha256) } ?: true
        val signature = packageManager?.let { checkApkSignature(it, packageName ?: "", expectedFingerprints) } ?: true
        val multiFileIntegrity = apkPath?.let { checkMultiFileIntegrity(it, expectedMultiFileHashes ?: emptyMap()) } ?: ""
        return buildString {
            append("{")
            append("\"nativeAvailable\":").append(report.nativeAvailable).append(",")
            append("\"tracerPid\":").append(report.tracerPid).append(",")
            append("\"injectionArtifacts\":").append(report.injectionArtifacts).append(",")
            append("\"javaDebuggerConnected\":").append(report.javaDebuggerConnected).append(",")
            append("\"waitingForDebugger\":").append(report.waitingForDebugger).append(",")
            append("\"integrityOk\":").append(integrity).append(",")
            append("\"signatureOk\":").append(signature).append(",")
            append("\"emulator\":").append(checkEmulator()).append(",")
            append("\"vpnOrProxy\":").append(checkVpnProxy(contentResolver)).append(",")
            append("\"clockAnomaly\":").append(checkClockAnomaly()).append(",")
            append("\"fridaInjection\":").append(checkFridaInjection()).append(",")
            append("\"xposedPresence\":").append(checkXposedPresence()).append(",")
            append("\"reverseToolTraces\":").append(checkReverseToolTraces()).append(",")
            append("\"systemPropertiesDebug\":").append(checkSystemProperties()).append(",")
            append("\"multiFileIntegrity\":\"").append(multiFileIntegrity).append("\"").append(",")
            append("\"ptraceTraced\":").append(checkPtraceTraced())
            append("}")
        }
    }

    private external fun nativeTracerPid(): Int

    private external fun nativeHasInjectionArtifacts(): Boolean

    // 方向⑤（原生层反调试）：ptrace 自跟踪检测（native 侧——与 Java 层互补）。
    fun checkPtraceTraced(): Boolean {
        return try {
            nativePtraceTraced()
        } catch (t: Throwable) {
            false
        }
    }

    // 下一层②（主动对抗响应——默认关闭——用户显式启用）：检测到调试器/篡改/逆向工具时——
    // 返回假数据（让逆向工具拿到错误信息——行为拖延的轻量形态）——否则返回真实数据。
    // 用法：在敏感逻辑处用 `respondToThreat(真实值, "decoy-xxx", enabled)` 包裹。
    fun respondToThreat(real: String, decoy: String, enabled: Boolean): String {
        if (!enabled) return real
        val threatened =
            checkFridaInjection() ||
            checkXposedPresence() ||
            checkPtraceTraced() ||
            checkReverseToolTraces()
        return if (threatened) decoy else real
    }

    private external fun nativePtraceTraced(): Boolean
}
