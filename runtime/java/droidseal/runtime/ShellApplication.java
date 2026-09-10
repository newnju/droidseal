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

    private static String originalClassName(Context base) {
        try {
            ApplicationInfo info = base.getPackageManager()
                    .getApplicationInfo(base.getPackageName(), android.content.pm.PackageManager.GET_META_DATA);
            if (info.metaData != null) {
                String n = info.metaData.getString(META_ORIGINAL_APP);
                if (n != null && n.length() > 0) return n;
            }
        } catch (Throwable t) {
            // 读取失败 → 返回 null,跳过原始 Application 安装
        }
        return null;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        try {
            DroidSealLoader.init(KEY_PART1, KEY_PART2);
            if (DroidSealLoader.getClassLoader() != null) {
                String cls = originalClassName(base);
                if (cls != null) DroidSealLoader.installOriginalApplication(base, cls);
            }
        } catch (Throwable t) {
            // 失败关闭:壳继续以自身身份运行(可加反分析处置)
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
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
