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
}
