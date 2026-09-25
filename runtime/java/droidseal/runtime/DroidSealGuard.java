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
