// DroidSeal 通用壳 Application(编译进 droidseal-loader.dex)。
//
// 生命周期:
//   attachBaseContext → init(KEY_PART1, KEY_PART2) 还原链 → installOriginalApplication
//   onCreate → dispatchOnCreate(原始 Application.onCreate)
//
// 构建期补丁(由 src/core/loader-dex.ts 完成):
//   KEY_PART1 / KEY_PART2:32B 标记数组,按标记定位后等长替换为构建密钥两段
//   ORIGINAL_APP:UTF-16 标记串,替换为原始 Application 类名(不足补 0)

package droidseal.runtime;

import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Bundle;

public final class ShellApplication extends Application {

    // 构建期补丁标记(32 字节,等长替换)。标记值 = 0xA5 重复,易定位。
    private static final byte[] KEY_PART1 = new byte[]{
        (byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,
        (byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,
        (byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,
        (byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5,(byte)0xA5
    };
    private static final byte[] KEY_PART2 = new byte[]{
        (byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,
        (byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,
        (byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,
        (byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A,(byte)0x5A
    };

    // 原始 Application 类名:由构建期写入 AndroidManifest meta-data
    // "droidseal.original_app"(避免对 DEX 字符串表做变长补丁)
    private static final String META_ORIGINAL_APP = "droidseal.original_app";
    // 壳 SO 的 loadLibrary 名(如 "droidseal_x7k"):构建期写入,part2 异位存于该 SO
    private static final String META_SHELL_SO = "droidseal.shell_so";

    private static String metaString(Context base, String key) {
        try {
            ApplicationInfo info = base.getPackageManager()
                    .getApplicationInfo(base.getPackageName(), android.content.pm.PackageManager.GET_META_DATA);
            if (info.metaData != null) {
                String n = info.metaData.getString(key);
                if (n != null && n.length() > 0) return n;
            }
        } catch (Throwable t) {
            // 读取失败 → 返回 null
        }
        return null;
    }

    private static String originalClassName(Context base) {
        return metaString(base, META_ORIGINAL_APP);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        try {
            String soName = metaString(base, META_SHELL_SO);
            DroidSealLoader.setAppContext(base); // 供 API<26 DexClassLoader 落盘降级
            // 签名自校验:重签名/重打包 → 延迟销毁(构建期嵌入期望指纹;未补丁则跳过)
            DroidSealLoader.verifyIntegrity(base);
            DroidSealLoader.init(KEY_PART1, KEY_PART2, soName);
            if (DroidSealLoader.getClassLoader() != null) {
                String cls = originalClassName(base);
                if (cls != null) DroidSealLoader.installOriginalApplication(base, cls);
            }
            // 反分析处置:检测命中且密钥已使用 → 延迟销毁(检测层由壳 SO/smali 提供)
            try {
                Class<?> guard = Class.forName("droidseal.runtime.DroidSealGuard");
                Object hit = guard.getMethod("detect").invoke(null);
                DroidSealLoader.antiAnalysisDispose(Boolean.TRUE.equals(hit));
            } catch (ClassNotFoundException notFound) {
                // 检测层未打包(纯 Java 壳降级),跳过处置
            }
        } catch (Throwable t) {
            // 失败关闭:壳继续以自身身份运行
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        // 校验点 3(生命周期分散):attachBaseContext 的投票可被"hook 后再放行"绕过,
        // onCreate 时刻再投一次——late-hook 在第三检查点命中(keyUsed 已由解密置位)。
        try {
            DroidSealLoader.antiAnalysisDispose(DroidSealGuard.detect());
        } catch (Throwable ignored) {}
        DroidSealLoader.dispatchOnCreate();
    }

    @Override
    public ClassLoader getClassLoader() {
        ClassLoader cl = DroidSealLoader.getClassLoader();
        return cl != null ? cl : super.getClassLoader();
    }

    // 资源/Assets 仍用壳路径(原始 APK 未变)
    @Override
    public android.content.res.AssetManager getAssets() {
        return super.getAssets();
    }
}
