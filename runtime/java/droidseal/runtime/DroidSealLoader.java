// DroidSeal 运行时壳加载器(Java 源码,构建期由 javac+d8 编译为 DEX 注入加固 APK)。
//
// 完整还原链路:
//   1. 自读 APK(ActivityThread.currentApplication().getApplicationInfo().sourceDir)
//   2. 全局扫描 DROIDSEAL_PAYLOAD magic → AES-256-GCM 解密原始 DEX
//   3. 扫描 DROIDSEAL_CI magic → 解密 CodeItem 表 → 按 originalCodeOff 写回方法体
//   4. 重算 DEX 校验和(Adler32 + SHA-1)
//   5. InMemoryDexClassLoader 加载还原后的 DEX
//   6. 置换 ClassLoader(LoadedApk.mClassLoader 反射)使后续所有组件走壳 DEX
//
// 密钥来源:构建期注入的 KEY_PART1/KEY_PART2 静态字段(part1 XOR part2 = AES key)。
// 任何一步失败都降级返回原壳 DEX(不崩溃,交由宿主逻辑兜底)。

package droidseal.runtime;

import android.app.Application;
import android.content.Context;
import dalvik.system.InMemoryDexClassLoader;
import java.io.RandomAccessFile;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.security.MessageDigest;
import java.util.zip.Adler32;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public final class DroidSealLoader {

    // ── 格式常量(与 src/core/dex-protection.ts / codeitem-table.ts 严格一致) ──
    private static final byte[] PAYLOAD_MAGIC = {
        'D','R','O','I','D','S','E','A','L','_','P','A','Y','L','O','A','D'
    }; // 17B 序列化时写入,扫描用前 16B
    private static final byte[] CI_MAGIC = {
        'D','R','O','I','D','S','E','A','L','_','C','I'
    }; // 12B
    private static final int CI_HEADER = 20; // magic12 + version4 + count4
    private static final int CI_RECORD = 20; // classIdx4+methodIdx4+origOff4+codeOff4+codeSize4
    private static final int CI_VERSION = 2;

    private static final int PAYLOAD_HEADER = 16 + 12 + 16; // magic + nonce + tag
    private static final int CI_BLOB_HEADER = 12 + 16;      // nonce + tag(外层密文块)

    private static ClassLoader loadedLoader;
    private static Application originalApp;

    private DroidSealLoader() {}

    /** 壳入口调用:执行完整还原链,成功后 getClassLoader() 返回原始 DEX 的类加载器。 */
    public static synchronized void init(byte[] keyPart1, byte[] keyPart2) {
        if (loadedLoader != null) return;
        try {
            byte[] apk = readApkBytes();
            if (apk == null) return;
            byte[] key = xorKey(keyPart1, keyPart2);
            if (key == null) return;

            // Step 1: 定位并解密原始 DEX payload
            int payloadOff = scanMagic(apk, PAYLOAD_MAGIC, 16);
            if (payloadOff < 0) return;
            byte[] originalDex = decryptBlob(apk, payloadOff + PAYLOAD_HEADER,
                    apk.length - payloadOff - PAYLOAD_HEADER, key, PAYLOAD_MAGIC);
            if (originalDex == null || !isDex(originalDex)) return;

            // Step 2: 定位并解密 CodeItem 表(可选——无抽取时跳过)
            int ciOff = scanMagic(apk, CI_MAGIC, 12);
            if (ciOff >= 0) {
                byte[] table = decryptBlob(apk, ciOff + CI_BLOB_HEADER,
                        apk.length - ciOff - CI_BLOB_HEADER, key, CI_MAGIC);
                if (table != null) {
                    int restored = restoreCodeItems(originalDex, table);
                    if (restored > 0) recomputeDexChecksum(originalDex);
                }
            }

            // Step 3: 加载 + 置换 ClassLoader
            loadedLoader = new InMemoryDexClassLoader(
                    ByteBuffer.wrap(originalDex), DroidSealLoader.class.getClassLoader());
            replaceClassLoader(loadedLoader);
        } catch (Throwable t) {
            // 失败关闭:保持 loadedLoader == null,壳 Application 走 fallback
        }
    }

    /** 壳 Application 调用:获取原始 DEX 的 ClassLoader(未成功还原返回 null)。 */
    public static ClassLoader getClassLoader() {
        return loadedLoader;
    }

    /**
     * 壳 Application.attachBaseContext 阶段调用:
     * 实例化原始 Application 并 attach,同时置换 ActivityThread.mInitialApplication
     * 与 LoadedApk.mApplication 引用,使 getApplicationContext() 返回原始实例。
     *
     * @return 是否成功安装(失败时壳 Application 保持自身生命周期)
     */
    public static synchronized boolean installOriginalApplication(Context base, String originalClassName) {
        if (loadedLoader == null || originalApp != null) return originalApp != null;
        try {
            Class<?> cls = loadedLoader.loadClass(originalClassName);
            Object app = cls.getDeclaredConstructor().newInstance();
            if (!(app instanceof Application)) return false;
            originalApp = (Application) app;
            // attachBaseContext 声明在 ContextWrapper(protected),反射调用
            Method attach = android.content.ContextWrapper.class
                    .getDeclaredMethod("attachBaseContext", Context.class);
            attach.setAccessible(true);
            attach.invoke(originalApp, base);
            swapApplicationRefs(base, originalApp);
            return true;
        } catch (Throwable t) {
            originalApp = null;
            return false;
        }
    }

    /** 壳 Application.onCreate 阶段调用:分发原始 Application 的 onCreate。 */
    public static synchronized void dispatchOnCreate() {
        try {
            if (originalApp != null) originalApp.onCreate();
        } catch (Throwable t) {
            // 原始 onCreate 失败不阻断壳生命周期
        }
    }

    /** 置换 ActivityThread.mInitialApplication 与 LoadedApk.mApplication 引用。 */
    private static void swapApplicationRefs(Context base, Application real) {
        try {
            // base(ContextWrapper) → ContextImpl
            Method getBase = Context.class.getDeclaredMethod("getBaseContext");
            getBase.setAccessible(true);
            Object impl = getBase.invoke(base);
            if (impl == null) return;
            // ContextImpl.mPackageInfo (LoadedApk)
            Field pkgInfoField = impl.getClass().getDeclaredField("mPackageInfo");
            pkgInfoField.setAccessible(true);
            Object loadedApk = pkgInfoField.get(impl);
            if (loadedApk == null) return;
            try {
                Field appField = loadedApk.getClass().getDeclaredField("mApplication");
                appField.setAccessible(true);
                appField.set(loadedApk, real);
            } catch (Throwable ignore) { /* 字段名因版本而异 */ }
            // ActivityThread.mInitialApplication
            Class<?> at = Class.forName("android.app.ActivityThread");
            Method cur = at.getDeclaredMethod("currentActivityThread");
            Object thread = cur.invoke(null);
            if (thread != null) {
                try {
                    Field initApp = at.getDeclaredField("mInitialApplication");
                    initApp.setAccessible(true);
                    initApp.set(thread, real);
                } catch (Throwable ignore) { /* 版本差异 */ }
            }
        } catch (Throwable t) {
            // 引用置换失败不阻断——install 已成功,应用本体可用
        }
    }

    // ── Step 1: 自读 APK ────────────────────────────────────────────────

    private static byte[] readApkBytes() {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Method cur = at.getDeclaredMethod("currentApplication");
            Object app = cur.invoke(null);
            if (app == null) return null;
            Method ai = app.getClass().getMethod("getApplicationInfo");
            Object info = ai.invoke(app);
            Field src = info.getClass().getField("sourceDir");
            String path = (String) src.get(info);
            RandomAccessFile raf = new RandomAccessFile(path, "r");
            try {
                long len = raf.length();
                if (len > Integer.MAX_VALUE - 8) return null;
                byte[] buf = new byte[(int) len];
                raf.readFully(buf);
                return buf;
            } finally {
                raf.close();
            }
        } catch (Throwable t) {
            return null;
        }
    }

    // ── 密钥组装 ─────────────────────────────────────────────────────────

    private static byte[] xorKey(byte[] p1, byte[] p2) {
        if (p1 == null || p2 == null || p1.length != 32 || p2.length != 32) return null;
        byte[] key = new byte[32];
        for (int i = 0; i < 32; i++) key[i] = (byte) (p1[i] ^ p2[i]);
        return key;
    }

    // ── magic 扫描 ────────────────────────────────────────────────────────

    private static int scanMagic(byte[] data, byte[] magic, int magicLen) {
        if (data == null || data.length < magicLen + 4) return -1;
        int last = data.length - magicLen;
        for (int i = 0; i <= last; i++) {
            int j = 0;
            while (j < magicLen && data[i + j] == magic[j]) j++;
            if (j == magicLen) return i;
        }
        return -1;
    }

    // ── AES-256-GCM 解密(外层密文块: nonce12 + tag16 + ct) ──────────────────

    private static byte[] decryptBlob(byte[] apk, int off, int maxLen, byte[] key, byte[] magic) {
        try {
            if (off < 0 || off + 28 > apk.length || off + 28 > off + maxLen) return null;
            byte[] nonce = new byte[12];
            System.arraycopy(apk, off, nonce, 0, 12);
            byte[] tag = new byte[16];
            System.arraycopy(apk, off + 12, tag, 0, 16);
            int ctLen = Math.min(maxLen - 28, apk.length - off - 28);
            if (ctLen <= 0) return null;
            byte[] ct = new byte[ctLen];
            System.arraycopy(apk, off + 28, ct, 0, ctLen);

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE,
                    new SecretKeySpec(key, "AES"),
                    new GCMParameterSpec(128, nonce));
            byte[] plain = cipher.doFinal(ct);
            // 内层格式校验:magic 前缀必须匹配(payload 与 citable 共用同一密钥)
            int mLen = (magic == CI_MAGIC) ? 12 : 16;
            for (int i = 0; i < mLen && i < plain.length; i++) {
                if (plain[i] != magic[i]) return null;
            }
            return plain;
        } catch (Throwable t) {
            return null;
        }
    }

    private static boolean isDex(byte[] b) {
        return b != null && b.length > 0x70
                && b[0] == 'd' && b[1] == 'e' && b[2] == 'x' && b[3] == '\n';
    }

    // ── Step 2: CodeItem 表还原 ──────────────────────────────────────────

    private static int restoreCodeItems(byte[] dex, byte[] table) {
        try {
            if (table.length < CI_HEADER) return 0;
            ByteBuffer bb = ByteBuffer.wrap(table).order(ByteOrder.LITTLE_ENDIAN);
            bb.position(12);
            int version = bb.getInt();
            if (version != CI_VERSION) return 0;
            int count = bb.getInt();
            if (count <= 0 || count > 1_000_000) return 0;
            long recordsEnd = (long) CI_HEADER + (long) count * CI_RECORD;
            if (recordsEnd > table.length) return 0;

            int restored = 0;
            int recPos = CI_HEADER;
            for (int i = 0; i < count; i++) {
                int clsIdx = intAt(table, recPos);
                int mtdIdx = intAt(table, recPos + 4);
                int origOff = intAt(table, recPos + 8);
                int codeOff = intAt(table, recPos + 12);
                int codeSize = intAt(table, recPos + 16);
                recPos += CI_RECORD;

                // 边界防护:全部越界即中止,已还原的保留
                if (origOff < 0 || origOff + 16 > dex.length) break;
                if (codeOff < 0 || codeSize < 0 || (long) codeOff + codeSize > table.length) break;
                if ((long) origOff + codeSize > dex.length) break;

                System.arraycopy(table, codeOff, dex, origOff, codeSize);
                restored++;
            }
            return restored;
        } catch (Throwable t) {
            return 0;
        }
    }

    private static int intAt(byte[] b, int off) {
        return (b[off] & 0xFF) | ((b[off + 1] & 0xFF) << 8)
                | ((b[off + 2] & 0xFF) << 16) | ((b[off + 3] & 0xFF) << 24);
    }

    // ── Step 3: DEX 校验和重算(Adler32 + SHA-1) ─────────────────────────────

    private static void recomputeDexChecksum(byte[] dex) {
        try {
            int fileSize = intAt(dex, 0x20);
            if (fileSize <= 0 || fileSize > dex.length) fileSize = dex.length;
            // SHA-1: bytes[32..fileSize) → header 0x0C
            MessageDigest sha1 = MessageDigest.getInstance("SHA-1");
            sha1.update(dex, 32, fileSize - 32);
            byte[] sig = sha1.digest();
            System.arraycopy(sig, 0, dex, 0x0C, 20);
            // Adler32: bytes[12..fileSize) → header 0x08
            Adler32 adler = new Adler32();
            adler.update(dex, 12, fileSize - 12);
            int sum = (int) adler.getValue();
            dex[0x08] = (byte) (sum & 0xFF);
            dex[0x09] = (byte) ((sum >>> 8) & 0xFF);
            dex[0x0A] = (byte) ((sum >>> 16) & 0xFF);
            dex[0x0B] = (byte) ((sum >>> 24) & 0xFF);
        } catch (Throwable t) {
            // 校验和失败不阻断(部分 ART 版本对校验和不敏感)
        }
    }

    // ── Step 4: InMemoryDexClassLoader ───────────────────────────────────

    private static final class InMemoryLoaderHolder {
        ClassLoader load(byte[] dex) throws Exception {
            Class<?> imdc = Class.forName("dalvik.system.InMemoryDexClassLoader");
            ByteBuffer buf = ByteBuffer.wrap(dex);
            Class<?> ctorParams = Class.forName("java.nio.ByteBuffer");
            Object loader = imdc.getConstructor(ctorParams, ClassLoader.class)
                    .newInstance(buf, DroidSealLoader.class.getClassLoader());
            return (ClassLoader) loader;
        }
    }

    // ── Step 5: ClassLoader 置换(LoadedApk.mClassLoader) ─────────────────────

    private static void replaceClassLoader(ClassLoader cl) {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Method cur = at.getDeclaredMethod("currentActivityThread");
            Object thread = cur.invoke(null);
            if (thread == null) return;
            Field packages = at.getDeclaredField("mPackages");
            packages.setAccessible(true);
            Object map = packages.get(thread);
            replaceInMap(map, cl);
            Field resPackages = at.getDeclaredField("mResourcePackages");
            resPackages.setAccessible(true);
            Object rmap = resPackages.get(thread);
            replaceInMap(rmap, cl);
        } catch (Throwable t) {
            // 置换失败时,壳 Application 仍可通过 getClassLoader() 显式加载
        }
    }

    private static void replaceInMap(Object map, ClassLoader cl) {
        if (!(map instanceof android.util.ArrayMap)) return;
        android.util.ArrayMap<?, ?> m = (android.util.ArrayMap<?, ?>) map;
        for (int i = 0; i < m.size(); i++) {
            Object weakRef = m.valueAt(i);
            if (weakRef == null) continue;
            Object ref = weakRef;
            // WeakReference<LoadedApk>
            Object loadedApk;
            try {
                java.lang.ref.WeakReference<?> wr = (java.lang.ref.WeakReference<?>) ref;
                loadedApk = wr.get();
            } catch (ClassCastException e) {
                loadedApk = ref;
            }
            if (loadedApk == null) continue;
            try {
                Field f = loadedApk.getClass().getDeclaredField("mClassLoader");
                f.setAccessible(true);
                f.set(loadedApk, cl);
            } catch (Throwable ignore) {
                // 字段名因版本而异——跳过
            }
        }
    }
}
