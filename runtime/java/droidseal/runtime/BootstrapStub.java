// Bootstrap stub(明文注入为 classesN.dex;真实壳加载器 DEX 加密存于 assets)。
//
// 双 DEX 方案:manifest android:name 指向本类。stub 明文可见但不含任何密钥:
//   1. 读 meta(loader DEX 加密 asset 的路径,meta 键名构建期随机化)
//   2. 运行时自读签名证书 → HKDF-SHA256 派生解密密钥(无嵌入密钥;
//      重签名/重打包 → 解密必然失败 → fail-closed,原始应用不运行)
//   3. 解密 loader DEX → 加载:API26+ InMemoryDexClassLoader,
//      API<26 DexClassLoader 落盘降级(能力不缩水)
//   4. 反射实例化解密后的壳 Application 并 attachBaseContext,生命周期委托
// jadx 静态打开加固 APK 只能看到本 stub 的通用引导代码,密钥与解密链不可见。
package droidseal.runtime;

public class BootstrapStub extends android.app.Application {

    // 构建期等长替换标记(stub-encapsulate.ts randomizeStubIdentifiers):
    //   SHELL_CLASS → 随机化后的壳 Application 类路径(点分形式,loadClass 用;等长 34)
    //   META_LOADER_ASSET → 随机 meta 键名(等长 19)
    // 注意:stub 自身类路径随机化走 DEX 类型描述符内的斜杠形式,与本字符串常量无关
    private static final String SHELL_CLASS = "droidseal.runtime.ShellApplication";
    private static final String META_LOADER_ASSET = "ds_loader_asset_mk1";

    private android.app.Application real;

    private static String metaString(android.content.Context base, String key) {
        try {
            android.content.pm.ApplicationInfo info = base.getPackageManager()
                    .getApplicationInfo(base.getPackageName(), android.content.pm.PackageManager.GET_META_DATA);
            if (info.metaData != null) {
                String n = info.metaData.getString(key);
                if (n != null && n.length() > 0) return n;
            }
        } catch (Throwable t) {
            // 读取失败 → null
        }
        return null;
    }

    @Override
    protected void attachBaseContext(android.content.Context base) {
        super.attachBaseContext(base);
        try {
            byte[] dex = loadLoaderDex(base);
            if (dex == null) { android.util.Log.e("DS_DIAG", "step1 loadLoaderDex=null(fail-closed)"); failClosed(); }
            android.util.Log.e("DS_DIAG", "step1 loader dex decrypted, " + dex.length + "B");
            ClassLoader cl = loadDexBytes(base, dex);
            if (cl == null) { android.util.Log.e("DS_DIAG", "step2 loadDexBytes=null"); failClosed(); }
            android.util.Log.e("DS_DIAG", "step2 classloader ok");
            Class<?> shellCls = cl.loadClass(SHELL_CLASS);
            android.util.Log.e("DS_DIAG", "step3 shell class loaded: " + shellCls.getName());
            Object app = shellCls.getDeclaredConstructor().newInstance();
            if (!(app instanceof android.app.Application)) { android.util.Log.e("DS_DIAG", "step4 not Application"); failClosed(); }
            real = (android.app.Application) app;
            // ContextWrapper.attachBaseContext 为 protected,反射调用(与壳内 installOriginalApplication 同模式)
            java.lang.reflect.Method attach = android.content.ContextWrapper.class
                    .getDeclaredMethod("attachBaseContext", android.content.Context.class);
            attach.setAccessible(true);
            attach.invoke(real, base);
            android.util.Log.e("DS_DIAG", "step5 shell attached OK");
        } catch (Throwable t) {
            android.util.Log.e("DS_DIAG", "bootstrap failed", t);
            failClosed(); // 失败关闭:解密/加载链任何一环失败,进程终止,原始应用不运行
        }
    }

    // fail-closed 拦截:解密失败(重签名/重打包/离线挑战不可达)→ 进程终止。
    // 此前仅 real=null 空身份返回,原 dex 照常渲染,fail-closed 名存实亡。
    private void failClosed() {
        real = null;
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(1); // killProcess 异步,兜底
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (real != null) {
            try {
                real.onCreate(); // 壳 Application.onCreate → DroidSealLoader.dispatchOnCreate
            } catch (Throwable t) {
                // 委托失败不阻断
            }
        }
    }

    @Override
    public ClassLoader getClassLoader() {
        if (real != null) {
            try {
                ClassLoader cl = real.getClassLoader(); // 壳覆写 → 还原链 ClassLoader
                if (cl != null) return cl;
            } catch (Throwable t) {
                // 回退 super
            }
        }
        return super.getClassLoader();
    }

    // ── loader DEX 解密:HKDF(签名证书指纹) 派生密钥,nonce12+tag16+ct ──

    private byte[] loadLoaderDex(android.content.Context base) {
        try {
            String assetPath = metaString(base, META_LOADER_ASSET);
            if (assetPath == null) return null;
            java.io.InputStream in = base.getAssets().open(assetPath);
            java.io.ByteArrayOutputStream bo = new java.io.ByteArrayOutputStream();
            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) > 0) bo.write(buf, 0, n);
            in.close();
            byte[] blob = bo.toByteArray();
            if (blob.length < 29) return null;
            byte[] cert = certDigest(base);
            if (cert == null) return null;
            return decryptGcm(blob, hkdf(cert, "droidseal-loader-v1".getBytes("UTF-8")));
        } catch (Throwable t) {
            return null;
        }
    }

    private byte[] certDigest(android.content.Context base) {
        try {
            android.content.pm.Signature[] sigs = base.getPackageManager()
                    .getPackageInfo(base.getPackageName(), android.content.pm.PackageManager.GET_SIGNATURES).signatures;
            if (sigs == null || sigs.length == 0) return null;
            return java.security.MessageDigest.getInstance("SHA-256").digest(sigs[0].toByteArray());
        } catch (Throwable t) {
            return null;
        }
    }

    // HKDF-SHA256 单块(salt=0^32),与构建期 deriveLoaderKey 严格一致
    private static byte[] hkdf(byte[] ikm, byte[] info) throws Exception {
        javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
        mac.init(new javax.crypto.spec.SecretKeySpec(new byte[32], "HmacSHA256"));
        byte[] prk = mac.doFinal(ikm);
        mac = javax.crypto.Mac.getInstance("HmacSHA256");
        mac.init(new javax.crypto.spec.SecretKeySpec(prk, "HmacSHA256"));
        mac.update(info);
        mac.update((byte) 1);
        return mac.doFinal();
    }

    // AES-256-GCM:输入 nonce(12)+tag(16)+ct(node:crypto 布局,tag 不在密文尾部;
    // Java GCM 约定 tag 追加在尾部,因此重组为 ct||tag,与 DroidSealLoader.decryptBlob 同模式)
    private static byte[] decryptGcm(byte[] blob, byte[] key) throws Exception {
        int ctLen = blob.length - 28;
        byte[] combined = new byte[ctLen + 16];
        System.arraycopy(blob, 28, combined, 0, ctLen);
        System.arraycopy(blob, 12, combined, ctLen, 16);
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, new javax.crypto.spec.SecretKeySpec(key, "AES"),
                new javax.crypto.spec.GCMParameterSpec(128, blob, 0, 12));
        return cipher.doFinal(combined);
    }

    // ── DEX 加载:API26+ InMemory;API<26 落盘 DexClassLoader(能力不缩水)──

    private ClassLoader loadDexBytes(android.content.Context base, byte[] dex) {
        if (android.os.Build.VERSION.SDK_INT >= 26) {
            try {
                return InMemoryHolder.load(dex);
            } catch (Throwable t) {
                // 落盘降级
            }
        }
        try {
            java.io.File dir = base.getDir("dsodex", android.content.Context.MODE_PRIVATE);
            java.io.File odex = new java.io.File(dir, "o");
            odex.mkdirs();
            java.io.File f = new java.io.File(dir, "loader.dex");
            java.io.FileOutputStream fo = new java.io.FileOutputStream(f);
            fo.write(dex);
            fo.close();
            return new dalvik.system.DexClassLoader(f.getAbsolutePath(), odex.getAbsolutePath(), null,
                    BootstrapStub.class.getClassLoader());
        } catch (Throwable t) {
            return null;
        }
    }

    // 独立类隔离 InMemoryDexClassLoader 引用:API<26 不加载本类即不触发其验证
    private static final class InMemoryHolder {
        static ClassLoader load(byte[] dex) {
            return new dalvik.system.InMemoryDexClassLoader(java.nio.ByteBuffer.wrap(dex),
                    BootstrapStub.class.getClassLoader());
        }
    }
}
