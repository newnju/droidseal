// DroidSeal Java 层反分析检测(编进 loader DEX,与 ShellApplication 同包)。
// 仅做轻量检测(Frida maps 特征 / TracerPid);native 层检测在壳 SO 中,
// 检测命中后由 DroidSealLoader.antiAnalysisDispose 延迟销毁。

package droidseal.runtime;

import java.io.BufferedReader;
import java.io.FileReader;

public final class DroidSealGuard {

    private DroidSealGuard() {}

    /** 综合检测:Frida 特征或调试器附加返回 true。任何异常返回 false(不误报)。 */
    public static boolean detect() {
        try {
            if (detectFridaMaps()) return true;
        } catch (Throwable ignored) {}
        try {
            if (detectTracer()) return true;
        } catch (Throwable ignored) {}
        try {
            if (detectTracerPerThread()) return true;
        } catch (Throwable ignored) {}
        return false;
    }

    /** B 项 opt-in:root/引诱信号探测(su 二进制族 / Magisk 落盘 / test-keys 构建)。
     *  仅在环境投票 opt-in 开启(FLAGS[0]==0x01)时被调用——默认关闭,root 常态
     *  用户设备不误伤。受限挂载的不可读路径 File.exists 可能假阴性——如实边界:
     *  本源为概率性证据,与 native/其它源独立,命中即进入投票聚合。 */
    public static boolean detectRoot() {
        final String[] probes = {
            "/system/bin/su", "/system/xbin/su", "/sbin/su", "/su/bin/su",
            "/system/bin/.ext/.su", "/system/usr/we-need-root/su-backup",
            "/data/local/xbin/su", "/data/local/bin/su", "/data/local/su",
            "/system/app/Superuser.apk", "/sbin/magisk", "/cache/.disable_magfc",
            "/cache/magisk.log", "/data/adb/magisk",
        };
        for (int i = 0; i < probes.length; i++) {
            try {
                if (new java.io.File(probes[i]).exists()) return true;
            } catch (Throwable ignored) {}
        }
        try {
            if (android.os.Build.TAGS != null && android.os.Build.TAGS.indexOf("test-keys") >= 0) return true;
        } catch (Throwable ignored) {}
        return false;
    }

    /** /proc/self/maps 扫描 Frida 注入特征。 */
    private static boolean detectFridaMaps() throws Exception {
        BufferedReader br = new BufferedReader(new FileReader("/proc/self/maps"), 8192);
        try {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.contains("frida") || line.contains("gum-js-loop")
                        || line.contains("gmain") || line.contains("linjector")) {
                    return true;
                }
            }
        } finally {
            br.close();
        }
        return false;
    }

    /** /proc/self/status 的 TracerPid 非 0 即有调试器附加。 */
    private static boolean detectTracer() throws Exception {
        BufferedReader br = new BufferedReader(new FileReader("/proc/self/status"), 4096);
        try {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("TracerPid:")) {
                    int pid = Integer.parseInt(line.substring(10).trim());
                    return pid > 0;
                }
            }
        } finally {
            br.close();
        }
        return false;
    }

    /** TracerPid 第二读取路径(异构):逐线程扫 /proc/self/task/<tid>/status。
     *  主线程 status 未被 attach 而**单线程被 ptrace**(针对性 hook 一个工作线程)时,
     *  路径 1 漏报、本路径命中。目录枚举失败按未命中处理(不误报)。 */
    private static boolean detectTracerPerThread() throws Exception {
        java.io.File taskDir = new java.io.File("/proc/self/task");
        String[] tids = taskDir.list();
        if (tids == null) return false;
        for (String tid : tids) {
            BufferedReader br = null;
            try {
                br = new BufferedReader(new FileReader("/proc/self/task/" + tid + "/status"), 4096);
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.startsWith("TracerPid:")) {
                        if (Integer.parseInt(line.substring(10).trim()) > 0) return true;
                        break;
                    }
                }
            } catch (Throwable ignored) {
                // 单线程 status 读取失败不算命中(竞争下线程可能已退出)
            } finally {
                if (br != null) try { br.close(); } catch (Throwable ignored) {}
            }
        }
        return false;
    }
}
