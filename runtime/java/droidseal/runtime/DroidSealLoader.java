// DroidSeal 运行时壳加载器(Java 源码,构建期由 javac+d8 编译为 DEX 注入加固 APK)。
//
// 完整还原链路:
//   1. 读取 payload 容器 assets/droidseal.bin(APK 内 stored 不压缩,AssetManager 直读)
//   2. 解析容器条目 → AES-256-GCM 解密原始 DEX(nonce+tag+ct,GCM tag 自认证)
//   3. 解密 CodeItem 表(可选)→ 按 originalCodeOff 写回方法体
//   4. 重算 DEX 校验和(Adler32 + SHA-1)
//   5. InMemoryDexClassLoader 加载还原后的 DEX(支持多 DEX 条目)
//   6. 置换 ClassLoader(LoadedApk.mClassLoader 反射)使后续所有组件走壳 DEX
//
// 密钥来源:构建期注入的 KEY_PART1/KEY_PART2 静态字段(part1 XOR part2 = AES key)。
// 任何一步失败都降级返回原壳 DEX(不崩溃,交由宿主逻辑兜底)。

package droidseal.runtime;

import android.app.Application;
import android.content.Context;
import dalvik.system.InMemoryDexClassLoader;
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

    // ── 格式常量(与 src/core/payload-container.ts / codeitem-table.ts 严格一致) ──
    private static final String CONTAINER_ASSET = "droidseal.bin";
    private static final int CONTAINER_VERSION = 1;
    private static final int CI_HEADER = 20; // magic12 + version4 + count4
    private static final int CI_RECORD = 20; // classIdx4+methodIdx4+origOff4+codeOff4+codeSize4
    private static final int CI_VERSION = 2;

    private static ClassLoader loadedLoader;
    private static Application originalApp;

    // 落盘降级用上下文(壳 Application attachBaseContext 注入)
    private static android.content.Context appContext;

    /** 壳 Application 注入基础上下文,供 API<26 DexClassLoader 落盘降级使用。 */
    public static void setAppContext(android.content.Context ctx) {
        appContext = ctx;
    }

    // ── 运行时自校验(构建期补丁;标记数组等长替换,见 loader-key-patch.ts)──
    // EXPECTED_CERT_SHA256:期望签名证书 SHA-256 原始摘要(32B)。
    // Java 源里是 0xC3×32 标记;构建期替换为真实指纹。全零/未补丁 → 跳过校验。
    // 说明:不做"APK 文件整体 hash"校验——loader DEX 在 APK 内,嵌入最终 APK
    // hash 存在循环依赖(改 DEX 即改 APK);v2 签名由系统安装时强制验证,
    // 运行时比对证书指纹足以击杀"解壳后重签名重打包"攻击。
    private static final byte[] EXPECTED_CERT_SHA256 = {
        (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3,
        (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3,
        (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3,
        (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3, (byte) 0xC3,
    };
    // 标记 0:自校验已通过(避免重复校验)
    private static volatile boolean integrityVerified = false;
    // 标记 1:自校验失配(确定性重打包证据)——置位后 init 中止,密钥永不进入内存
    private static volatile boolean integrityFailed = false;

    /**
     * 运行时签名自校验:当前 APK 签名证书指纹与构建期嵌入值比对。
     * 不匹配 = 原始 APK 被解壳后重签名 → antiAnalysisDispose(true)(延迟销毁)。
     * 构建期未补丁(全零)或读取失败时跳过(失败关闭,不误伤)。
     * 节流随机化(P1):启动后由两个守护调度器以随机间隔重复校验——固定周期的
     * 校验可被攻击者摸清时序后在窗口内操作,随机间隔 + 调度器数量不固定消除该模式。
     */
    public static void verifyIntegrity(Context base) {
        if (integrityVerified) return;
        integrityVerified = true;
        if (doVerifyIntegrity(base)) {
            scheduleIntegrityRechecks(base);
        }
    }

    /** 校验本体(供首检与调度器复用):返回 true=通过或跳过,false=确定性失配。 */
    private static boolean doVerifyIntegrity(Context base) {
        try {
            // 未补丁判定:32B 全为 0xC3 标记(真实 SHA-256 摘要不可能 32 字节全同)
            boolean unpatched = true;
            for (byte b : EXPECTED_CERT_SHA256) { if (b != (byte) 0xC3) { unpatched = false; break; } }
            if (unpatched) return true;
            android.content.pm.Signature[] sigs = base.getPackageManager()
                    .getPackageInfo(base.getPackageName(), android.content.pm.PackageManager.GET_SIGNATURES).signatures;
            if (sigs == null || sigs.length == 0) return true;
            byte[] digest = java.security.MessageDigest.getInstance("SHA-256").digest(sigs[0].toByteArray());
            if (!java.util.Arrays.equals(digest, EXPECTED_CERT_SHA256)) {
                // 签名不匹配 = 被重打包(确定性证据,不受 keyUsed 门控):
                // 置失配标记(init 入口拦截,中止解密链路)+ 延迟销毁退出
                integrityFailed = true;
                startDispose();
                return false;
            }
            return true;
        } catch (Throwable t) {
            return true; // 读取失败不误伤
        }
    }

    /** P1 节流随机化:两个守护调度器,随机初检延迟(45–180s)与随机复检间隔(20–90s),
     *  各自独立计时——攻击者摸清一个调度器的周期,另一个仍在随机窗口内。
     *  调度器数量/间隔不写入任何可观测常量;失败静默(不影响主流程)。 */
    private static void scheduleIntegrityRechecks(final Context base) {
        final Context app = base.getApplicationContext();
        if (app == null) return;
        for (int s = 0; s < 2; s++) {
            Thread t = new Thread(new Runnable() {
                @Override public void run() {
                    try {
                        java.security.SecureRandom rnd = new java.security.SecureRandom();
                        Thread.sleep(45_000 + rnd.nextInt(135_000)); // 初检 45–180s
                        while (!disposed && !integrityFailed) {
                            doVerifyIntegrity(app);
                            Thread.sleep(20_000 + rnd.nextInt(70_000)); // 复检 20–90s
                        }
                    } catch (Throwable ignored) {
                        // 调度失败保持静默
                    }
                }
            });
            t.setDaemon(true);
            t.setName("ds-igchk-" + s);
            t.start();
        }
    }

    // ── 反分析处置(延迟销毁)──────────────────────────────────────────
    /** 密钥是否已被真实使用(解密成功过)。处置仅在此之后触发,避免误伤正常失败。 */
    private static volatile boolean keyUsed = false;
    /** 处置已触发(幂等)。 */
    private static volatile boolean disposed = false;
    /** P1:壳 SO 是否加载成功(NDK 缺失回退时为 false,native 投票源自动缺席)。 */
    private static volatile boolean soLoaded = false;

    /** P1 冗余异构投票:Java 源(DroidSealGuard)+ native 源(C 独立实现)+ debuggable 标志,
     *  三源独立、读取路径异构——绕过单一源不影响判定,攻击者需同时攻破全部。
     *  异常按"未命中"处理(不误伤);SO 未加载(NDK 缺失回退)时 native 源自动缺席。 */
    private static boolean voteEnvironment() {
        boolean vote = false;
        // 源 1:Java 检测(Frida maps / TracerPid)
        try {
            if (DroidSealGuard.detect()) vote = true;
        } catch (Throwable ignored) {}
        // 源 2:native 检测(SO 已加载时;实现读取路径与 Java 异构)
        try {
            if (soLoaded && nativeGuardVote() != 0) vote = true;
        } catch (Throwable ignored) {}
        // 源 3:debuggable 标志(release 包不应可调试;重打包开调试 = 篡改证据)
        try {
            if (appContext != null
                    && (appContext.getApplicationInfo().flags & android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE) != 0) {
                vote = true;
            }
        } catch (Throwable ignored) {}
        return vote;
    }

    /** 标记密钥已真实使用;此后 antiAnalysis 命中才执行处置。
     *  校验点 2(解密后重投票):解密前的投票可被"attach 前注入、投票后 hook"绕过;
     *  密钥已使用的时刻再投一次——late-hook 场景在第二检查点命中。 */
    public static void markKeyUsed() {
        keyUsed = true;
        try {
            if (voteEnvironment()) startDispose();
        } catch (Throwable ignored) {}
    }

    /**
     * 延迟销毁处置:检测命中且密钥已使用后,随机延迟 0.5~3s 后静默退出进程。
     * 不立即 kill——增加攻击者定位触发源的成本;随机延迟干扰时序归因。
     * 任何异常吞掉,不影响主流程。
     */
    public static void antiAnalysisDispose(final boolean detected) {
        if (!detected || !keyUsed || disposed) return;
        startDispose();
    }

    /** 直接启动延迟销毁(跳过 keyUsed 门控):仅用于签名失配等确定性攻击证据。 */
    private static void startDispose() {
        if (disposed) return;
        disposed = true;
        Thread t = new Thread(new Runnable() {
            @Override public void run() {
                try {
                    long delay = 500 + (java.security.SecureRandom.getInstanceStrong().nextInt(2500));
                    Thread.sleep(delay);
                    android.os.Process.killProcess(android.os.Process.myPid());
                } catch (Throwable ignored) {
                    // 处置失败保持静默
                }
            }
        });
        t.setDaemon(true);
        t.start();
    }

    private DroidSealLoader() {}

    /** 壳入口调用:执行完整还原链,成功后 getClassLoader() 返回原始 DEX 的类加载器。
     *  soName 非 null 时优先经 JNI 从壳 SO 获取 part2(Split-Key 异位存放,纯 Java 层脚本失效);
     *  SO 不可用(NDK 缺失降级)时回退 KEY_PART2 静态字段。 */
    // ── Android Keystore 设备绑定(可选,--keystore-bind)──────────────────
    // 首次成功解密后:part1 用 Keystore 硬件密钥(AES-GCM,不可导出)加密封存到
    // 私有目录,并抹掉内存/字段中的明文;后续启动优先从 Keystore 解包。
    // 卸载重装/换机 → 封存数据随私有目录消失或解包失败 → init 失败 fail-closed。
    // 如实边界:首次启动前密钥仍在 loader DEX 内(离线单机无法避免),
    // 收益是"二次启动后 loader DEX 内不再持有有效密钥"——拷贝 loader DEX 到
    // 其他设备/重打包后无法解密容器(Keystore 密钥不可迁移)。
    private static final String KS_ALIAS = "ds_bind_key";
    private static final String KS_SEAL_FILE = "ds_seal.bin";
    private static boolean keystoreBindingEnabled = false;

    // 构建期开关标记:末字符 '0'=关闭,'1'=启用(--keystore-bind 时由流水线等长替换)
    public static final String KS_BIND_FLAG = "KS_BIND_FLAG_0";
    // P2 服务端挑战 URL 占位符(128 字符 = TS MARK_URL 严格一致:DS_SRV_URL + 118 个 '#'):
    // 构建期 patchLoaderDexKeys 等长替换为真实 https:// URL(右补 '#')。
    // 未打补丁 = 纯本地模式,fetchPart3 直接跳过。
    public static final String SERVER_URL = "DS_SRV_URL######################################################################################################################";

    /** ShellApplication 启动时读取构建期开关标记。 */
    public static void applyKeystoreBindingFlag() {
        keystoreBindingEnabled = KS_BIND_FLAG.endsWith("1");
    }

    private static javax.crypto.SecretKey keystoreKey() throws Exception {
        android.security.keystore.KeyGenParameterSpec spec = new android.security.keystore.KeyGenParameterSpec.Builder(
                KS_ALIAS, android.security.keystore.KeyProperties.PURPOSE_ENCRYPT
                | android.security.keystore.KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(android.security.keystore.KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(android.security.keystore.KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build();
        javax.crypto.KeyGenerator kg = javax.crypto.KeyGenerator.getInstance(
                android.security.keystore.KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
        kg.init(spec);
        return kg.generateKey();
    }

    private static javax.crypto.SecretKey keystoreGet() throws Exception {
        // android.security.KeyStore 是 @hide API,公开 SDK 编译不可见;用 java.security 门面
        java.security.KeyStore ks = java.security.KeyStore.getInstance("AndroidKeyStore");
        ks.load(null);
        if (!ks.containsAlias(KS_ALIAS)) return null;
        return (javax.crypto.SecretKey) ks.getKey(KS_ALIAS, null);
    }

    /** 首次成功解密后调用:part1 用 Keystore 密钥封装写入私有目录,返回是否成功。 */
    private static boolean sealPart1(byte[] part1) {
        try {
            // appContext 未注入(极端时序:setAppContext 未被调用)时不落盘、直接失败——
            // 封存失败只是回退到嵌入值路径,不能因 NPE 崩溃暴露壳的存在
            if (appContext == null) return false;
            javax.crypto.SecretKey key = keystoreGet();
            if (key == null) key = keystoreKey();
            javax.crypto.Cipher c = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding");
            c.init(javax.crypto.Cipher.ENCRYPT_MODE, key);
            byte[] sealed = c.doFinal(part1); // Java GCM: ct||tag
            byte[] iv = c.getIV();
            java.io.File f = new java.io.File(appContext.getFilesDir(), KS_SEAL_FILE);
            java.io.FileOutputStream fo = new java.io.FileOutputStream(f);
            fo.write(iv.length); // 1B IV 长度(恒 12)
            fo.write(iv);
            fo.write(sealed);
            fo.close();
            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    /** 从私有目录 + Keystore 解包 part1;失败(换机/篡改/未封存)返回 null。 */
    private static byte[] unsealPart1() {
        try {
            javax.crypto.SecretKey key = keystoreGet();
            if (key == null || appContext == null) return null;
            java.io.File f = new java.io.File(appContext.getFilesDir(), KS_SEAL_FILE);
            if (!f.exists()) return null;
            byte[] data = new byte[(int) f.length()];
            java.io.FileInputStream fi = new java.io.FileInputStream(f);
            int total = fi.read(data);
            fi.close();
            if (total < 14) return null;
            int ivLen = data[0] & 0xff;
            byte[] iv = java.util.Arrays.copyOfRange(data, 1, 1 + ivLen);
            javax.crypto.Cipher c = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding");
            c.init(javax.crypto.Cipher.DECRYPT_MODE, key, new javax.crypto.spec.GCMParameterSpec(128, iv));
            return c.doFinal(data, 1 + ivLen, total - 1 - ivLen);
        } catch (Throwable t) {
            // 换机后封存数据存在但 Keystore 密钥不存在 → 解包失败(设备绑定生效)
            return null;
        }
    }

    public static synchronized void init(byte[] keyPart1, byte[] keyPart2, String soName) {
        if (loadedLoader != null) return;
        // 签名自校验已失配:中止初始化,密钥与明文 DEX 永不进入内存。
        // 进程由 startDispose 的延迟退出收尾;此处静默返回,表现等同普通启动失败。
        if (integrityFailed) return;
        try {
            byte[] container = readContainerAsset();
            if (container == null) return;
            byte[] part2 = fetchPart2(soName, keyPart2);
            // Keystore 绑定开启时:优先从封存解包 part1(二次启动明文不再来自 DEX);
            // 解包失败回退嵌入值(首次启动/未封存),成功解密后立即封存并抹掉嵌入值。
            byte[] effPart1 = keyPart1;
            boolean fromSeal = false;
            if (keystoreBindingEnabled && appContext != null) {
                byte[] unsealed = unsealPart1();
                if (unsealed != null && unsealed.length == 32) {
                    effPart1 = unsealed;
                    fromSeal = true;
                }
            }
            int envVote = voteEnvironment() ? 1 : 0;
            // 容器格式(小端):magic12(构建期随机化,与 asset meta 同步写入) + version4 + count4,
            // 条目 = kind4(1=dex, 2=citable) + targetIndex4 + length4 + bytes
            if (container.length < 20) return;
            // magic 校验(字面量会被标识符随机化等长替换为随机 magic,与 asset meta 同步)
            if (!"DROIDSEALBIN".equals(new String(container, 0, 12, "UTF-8"))) return;
            ByteBuffer bb = ByteBuffer.wrap(container).order(ByteOrder.LITTLE_ENDIAN);
            bb.position(12);
            int version = bb.getInt();
            if (version != CONTAINER_VERSION) return;
            int count = bb.getInt();
            if (count <= 0 || count > 4096) return;

            java.util.List<byte[]> dexList = new java.util.ArrayList<byte[]>();
            byte[] ciTable = null;
            int ciTarget = 0;
            // P0-A:重算完整性锚点(自身 APK 的 manifest SHA-256),参与逐条目密钥派生。
            // 构建期有锚而运行时重算失败 → 锚不匹配 → 密钥错 → GCM 静默失败(fail-closed)。
            byte[] anchor = computeIntegrityAnchor();
            // P2 服务端挑战:URL 已嵌入(仍以 DS_SRV_URL 开头 = 未补丁,跳过)时向服务器取
            // part3 合入 part1。part3 不在 APK 内——拿到完整 APK 也缺一段密钥;
            // 离线/被拒 → 解密静默失败。纯本地构建时 fetchPart3 返回 null,零影响。
            // KS+挑战组合:封存的必须是 pre-XOR 值(part1′)——否则二次启动 unseal 出
            // 真实 part1 再 XOR 一次 part3 → 密钥错,永久解密失败。
            byte[] sealValue = null;
            if (keystoreBindingEnabled && appContext != null && !fromSeal && anchor != null) {
                // 嵌入值即将被 XOR 原地修改,先拷贝 part1′ 供解密成功后封存
                sealValue = java.util.Arrays.copyOf(keyPart1, 32);
            }
            if (anchor != null) {
                byte[] p3 = fetchPart3(anchor);
                if (p3 != null) {
                    for (int i = 0; i < 32; i++) effPart1[i] ^= p3[i];
                    java.util.Arrays.fill(p3, (byte) 0);
                }
            }
            // P0-C 密钥分片化:master = part1 ^ part2 不再常驻内存——每条目解密时
            // 临时合成、派生完立即清零。任意时刻内存无完整 master,hook/dump 单点
            // 快照拿不到可复用的密钥材料(effPart1/part2 各自只有一半,单独无意义)。
            int pos = 20;
            byte[] chainPrev = null; // 条目哈希链:条目 i 密钥混入条目 i-1 密文哈希(与 TS 侧 chainSeed 一致)
            for (int i = 0; i < count; i++) {
                if (pos + 12 > container.length) return;
                int kind = intAt(container, pos);
                int targetIndex = intAt(container, pos + 4);
                int length = intAt(container, pos + 8);
                pos += 12;
                if (length < 0 || length > container.length - pos) return;
                byte[] blob = java.util.Arrays.copyOfRange(container, pos, pos + length);
                pos += length;
                // 临时合成 master(32B XOR,纳秒级)→ 派生条目密钥 → 立即清零
                byte[] key = xorKey(effPart1, part2);
                if (key == null) return;
                // per-entry 密钥:HKDF(master, info=kind+targetIndex+anchor+chain+envVote)——单条破解不蔓延,
                // manifest 被篡改(重打包必经)、容器条目被增删改排(哈希链断裂)或环境被劫持均派生错钥
                byte[] entryKey = deriveEntryKey(key, kind, targetIndex, anchor, envVote, chainPrev);
                java.util.Arrays.fill(key, (byte) 0); // master 用后即清(分片化核心)
                if (entryKey == null) return;
                byte[] plain = decryptBlob(blob, entryKey);
                java.util.Arrays.fill(entryKey, (byte) 0); // 条目密钥用后即清
                if (plain == null) return;
                // 链前驱推进:SHA-256(本条目密文)前 16B(下一条目的派生输入;用后随 blob 生命周期)
                try {
                    java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
                    byte[] full = md.digest(blob);
                    byte[] seed = new byte[16];
                    System.arraycopy(full, 0, seed, 0, 16);
                    if (chainPrev != null) java.util.Arrays.fill(chainPrev, (byte) 0);
                    chainPrev = seed;
                } catch (Throwable t) { return; }
                markKeyUsed(); // 密钥已真实使用:此后反分析命中可执行处置
                if (kind == 1) dexList.add(plain);
                else if (kind == 2) { ciTable = plain; ciTarget = targetIndex; }
            }
            // splitKey part2 用后清零(master 已在循环内逐条目合成后即清,无需在此处理)
            java.util.Arrays.fill(part2, (byte) 0);
            // Keystore 绑定:首次解密成功 → 封存 pre-XOR part1′(挑战模式取片成功时嵌入值
            // 已被原地 XOR 成真实 part1,必须封存拷贝出来的 part1′)并抹掉嵌入值(嵌入字段
            // 填 0 后 xorKey(全零, part2) 必然失败,后续启动只能走 unsealPart1——设备绑定生效)。
            // 二次启动:unseal → part1′ → XOR part3 → 真实 part1,与首次启动路径一致。
            if (keystoreBindingEnabled && appContext != null && !fromSeal) {
                byte[] toSeal = sealValue != null ? sealValue : effPart1;
                if (sealPart1(toSeal)) {
                    java.util.Arrays.fill(keyPart1, (byte) 0);
                }
                if (sealValue != null) java.util.Arrays.fill(sealValue, (byte) 0);
            }
            if (effPart1 != keyPart1) java.util.Arrays.fill(effPart1, (byte) 0);

            if (dexList.isEmpty()) return;
            byte[] primaryDex = dexList.get(0);
            if (!isDex(primaryDex)) return;

            // Step 2: CodeItem 表还原(可选——无抽取时跳过)
            if (ciTable != null && ciTarget >= 0 && ciTarget < dexList.size()) {
                int restored = restoreCodeItems(dexList.get(ciTarget), ciTable);
                if (restored > 0) recomputeDexChecksum(dexList.get(ciTarget));
            }

            // Step 3: 加载 + 置换 ClassLoader(多 DEX 走 ByteBuffer[] 构造)
            loadedLoader = loadDex(dexList);
            // P0-C 明文窗口最小化:类加载器已持有 DEX 的运行时映像,明文字节数组
            // 尽快清零(InMemoryDexClassLoader 已拷贝/映射完毕;API<26 落盘路径由
            // DexClassLoader 持有文件,此处数组同样不再需要)。
            for (byte[] d : dexList) java.util.Arrays.fill(d, (byte) 0);
            dexList.clear();
            ciTable = null;
            if (loadedLoader == null) return;
            replaceClassLoader(loadedLoader);
            // VMP 里程碑 B:app ClassLoader 就绪后注册 VM 桥(RegisterNatives 必须
            // 在 app 类可经 loadClass 定位后;JNI_OnLoad 时必败)。fail-open:注册
            // 失败不影响启动,方法保持 stub+惰性还原路径。
            try { dsvmRegisterAll(loadedLoader); } catch (Throwable ignore) { }
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

    // ── Step 1: 读取 payload 容器(assets/droidseal.bin,APK 内 stored 不压缩) ──

    private static byte[] readContainerAsset() {
        try {
            // 上下文来源优先级:壳注入的 appContext(attachBaseContext 即可用)→
            // ActivityThread.currentApplication(晚于 attach)。前者保证 init 在
            // Application 完全 attach 前也能拿到资源。
            android.content.Context ctx = appContext;
            if (ctx == null) {
                Class<?> at = Class.forName("android.app.ActivityThread");
                Method cur = at.getDeclaredMethod("currentApplication");
                Object app = cur.invoke(null);
                if (app instanceof android.content.Context) ctx = (android.content.Context) app;
            }
            if (ctx == null) return null;
            android.content.res.AssetManager am = ctx.getAssets();
            if (am == null) return null;
            java.io.InputStream is = am.open(CONTAINER_ASSET);
            try {
                java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
                byte[] buf = new byte[8192];
                int n;
                while ((n = is.read(buf)) > 0) bos.write(buf, 0, n);
                return bos.toByteArray();
            } finally {
                is.close();
            }
        } catch (Throwable t) {
            return null;
        }
    }

    // ── 密钥组装 ─────────────────────────────────────────────────────────

    /** part2 获取:优先 JNI 从壳 SO 读内嵌数组(异位存放);失败回退静态字段(NDK 缺失降级)。 */
    private static byte[] fetchPart2(String soName, byte[] fallback) {
        if (soName != null) {
            try {
                System.loadLibrary(soName);
                soLoaded = true;
                byte[] fromSo = nativeKeyPart2();
                if (fromSo != null && fromSo.length == 32) return fromSo;
            } catch (Throwable t) {
                // SO 缺失/ABI 不符 → 回退
            }
        }
        return fallback;
    }

    /** 壳 SO 实现(key_part2.c):返回 Split-Key part2。 */
    private static native byte[] nativeKeyPart2();

    /** P1 异构检测 native 源:C 层独立读取 TracerPid/Frida 端口/maps(与 Java 源读取路径不同)。
     *  返回 1=命中,0=干净。仅在 SO 成功加载后调用(NDK 缺失回退路径无 SO,该源自动缺席)。 */
    private static native int nativeGuardVote();

    /** VMP 里程碑 B:RegisterNatives 注册入口(壳 SO vm_bridge.c 实现,导出符号随本类
     *  随机化名参数化)。入参 app ClassLoader——JNI FindClass 用壳 loader 的加载器,
     *  找不到 InMemoryDexClassLoader 里的 app 类,必须经 loadClass 定位。返回成功注册数;
     *  SO 未加载/无 VM 方法时调用方 fail-open(异常吞掉,不阻断启动)。 */
    static native int dsvmRegisterAll(ClassLoader appLoader);

    /** P2 服务端挑战:向 SERVER_URL(构建期嵌入)POST manifestSha256,取回 part3(hex 64 字符 → 32B)。
     *  服务器按 manifest 摘要校验后发放——其他 APK / 被篡改的包拿不到本构建的 part3。
     *  子线程执行(init 在 attachBaseContext 主线程,直接联网抛 NetworkOnMainThread);
     *  超时/失败返回 null → master 还原失败 → 解密静默失败(fail-closed,不崩溃不降级)。
     *  响应只解析 "part3":"<64 hex>" 字段,不引入 JSON 依赖。 */
    private static byte[] fetchPart3(final byte[] manifestSha256) {
        final String url = SERVER_URL;
        // 占位符未替换(仍以 DS_SRV_URL 开头)= 纯本地模式。
        // 不能用 indexOf('#') 判定:合法补丁后的 URL 右侧以 '#' 补齐到 128 字符,必含 '#'。
        if (url.startsWith("DS_SRV_URL") || !url.startsWith("https://")) return null;
        final java.util.concurrent.atomic.AtomicReference<byte[]> out = new java.util.concurrent.atomic.AtomicReference<byte[]>(null);
        Thread t = new Thread(new Runnable() {
            @Override public void run() {
                try {
                    final char[] HEX = "0123456789abcdef".toCharArray();
                    StringBuilder mh = new StringBuilder();
                    for (byte b : manifestSha256) { mh.append(HEX[(b >> 4) & 0xf]).append(HEX[b & 0xf]); }
                    String body = "manifestSha256=" + mh;
                    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) new java.net.URL(url).openConnection();
                    conn.setRequestMethod("POST");
                    conn.setDoOutput(true);
                    conn.setConnectTimeout(3000);
                    conn.setReadTimeout(3000);
                    conn.setFixedLengthStreamingMode(body.getBytes("UTF-8").length);
                    conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                    java.io.OutputStream os = conn.getOutputStream();
                    os.write(body.getBytes("UTF-8"));
                    os.close();
                    if (conn.getResponseCode() != 200) return;
                    java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"));
                    StringBuilder sb = new StringBuilder();
                    char[] buf = new char[2048];
                    int n;
                    while ((n = br.read(buf)) > 0) sb.append(buf, 0, n);
                    br.close();
                    // 提取 "part3":"<hex>"
                    String resp = sb.toString();
                    int k = resp.indexOf("\"part3\"");
                    if (k < 0) return;
                    int q1 = resp.indexOf('"', resp.indexOf(':', k) + 1);
                    int q2 = resp.indexOf('"', q1 + 1);
                    if (q1 < 0 || q2 < 0 || q2 - q1 - 1 != 64) return;
                    String hex = resp.substring(q1 + 1, q2);
                    byte[] p3 = new byte[32];
                    for (int i = 0; i < 32; i++) {
                        p3[i] = (byte) ((Character.digit(hex.charAt(i * 2), 16) << 4) | Character.digit(hex.charAt(i * 2 + 1), 16));
                    }
                    out.set(p3);
                } catch (Throwable ignored) {}
            }
        });
        t.start();
        try { t.join(3500); } catch (InterruptedException ignored) {}
        return out.get();
    }

    // ── per-entry 密钥派生(HKDF-SHA256,与 TS 侧 deriveEntryKey 严格一致)──

    /** HKDF-Extract: PRK = HMAC-SHA256(salt=0^32, IKM=master) */
    private static byte[] hkdfExtract(byte[] ikm) throws Exception {
        javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
        mac.init(new javax.crypto.spec.SecretKeySpec(new byte[32], "HmacSHA256"));
        return mac.doFinal(ikm);
    }

    /** HKDF-Expand 单块: OKM = HMAC(PRK, info || 0x01) */
    private static byte[] hkdfExpand(byte[] prk, byte[] info) throws Exception {
        javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
        mac.init(new javax.crypto.spec.SecretKeySpec(prk, "HmacSHA256"));
        mac.update(info);
        mac.update((byte) 1);
        return mac.doFinal();
    }

    /** 条目密钥 = HKDF(master, info="droidseal-entry-<kind>-<targetIndex>[-a<manifest-sha256-hex>][-c<chain-hex>]-e<envVote>"),kind: 1=dex, 2=citable。
     *  anchor(P0-A):构建期嵌入最终 manifest 的 SHA-256,运行时从自身 APK 重算——
     *  重打包必改 manifest → 重算值不同 → 密钥错 → GCM 静默失败。anchor 为 null 时构建期也未用锚。
     *  chainPrev(P0-A 扩展,条目哈希链):前一加密条目密文的 SHA-256 前 16B(首条目 null)。
     *  条目 i 的密钥依赖条目 i-1 密文——增/删/改/重排任何中间条目使后续全部条目派生错钥,
     *  "只改资源不碰 manifest"的局部篡改面被覆盖。与 TS 侧 chainSeed 严格一致。
     *  envVote(P0-B):运行时反分析投票(0=干净,1=检测命中)。构建期恒 0;运行时命中则
     *  派生错钥——动态分析(attach 即跑)拿到的全是解不开的密文,静默失败无从归因。 */
    private static byte[] deriveEntryKey(byte[] master, int kind, int targetIndex, byte[] anchor, int envVote, byte[] chainPrev) {
        try {
            byte[] prk = hkdfExtract(master);
            StringBuilder info = new StringBuilder("droidseal-entry-")
                    .append(kind == 1 ? "dex" : "citable").append("-").append(targetIndex);
            final char[] HEX = "0123456789abcdef".toCharArray();
            if (anchor != null && anchor.length > 0) {
                info.append("-a");
                for (byte b : anchor) { info.append(HEX[(b >> 4) & 0xf]).append(HEX[b & 0xf]); }
            }
            if (chainPrev != null && chainPrev.length > 0) {
                info.append("-c");
                for (byte b : chainPrev) { info.append(HEX[(b >> 4) & 0xf]).append(HEX[b & 0xf]); }
            }
            info.append("-e").append(envVote != 0 ? 1 : 0);
            return hkdfExpand(prk, info.toString().getBytes("UTF-8"));
        } catch (Throwable t) {
            return null;
        }
    }

    /** P0-A:重算完整性锚点——自身 APK 内 AndroidManifest.xml(解压后二进制)的 SHA-256。
     *  与构建期锚点同源:manifest 注入定稿后,容器注入/签名(v1 meta / v2 块)不修改该条目内容。
     *  读取失败返回 null → 派生回退旧格式 → 与构建期(有锚)不一致 → 解密 fail-closed。 */
    private static byte[] computeIntegrityAnchor() {
        try {
            if (appContext == null) return null;
            String apkPath = appContext.getApplicationInfo().sourceDir;
            if (apkPath == null) return null;
            java.util.zip.ZipFile zf = new java.util.zip.ZipFile(apkPath);
            try {
                java.util.zip.ZipEntry e = zf.getEntry("AndroidManifest.xml");
                if (e == null) return null;
                java.io.InputStream is = zf.getInputStream(e);
                java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
                byte[] buf = new byte[8192];
                int n;
                while ((n = is.read(buf)) > 0) md.update(buf, 0, n);
                is.close();
                return md.digest();
            } finally {
                zf.close();
            }
        } catch (Throwable t) {
            return null;
        }
    }

    private static byte[] xorKey(byte[] p1, byte[] p2) {
        if (p1 == null || p2 == null || p1.length != 32 || p2.length != 32) return null;
        byte[] key = new byte[32];
        for (int i = 0; i < 32; i++) key[i] = (byte) (p1[i] ^ p2[i]);
        return key;
    }

    // ── AES-256-GCM 解密(容器条目: nonce12 + tag16 + ct,GCM tag 自认证) ──

    private static byte[] decryptBlob(byte[] blob, byte[] key) {
        try {
            if (blob == null || blob.length <= 28) return null;
            byte[] nonce = new byte[12];
            System.arraycopy(blob, 0, nonce, 0, 12);
            byte[] tag = new byte[16];
            System.arraycopy(blob, 12, tag, 0, 16);
            int ctLen = blob.length - 28;
            byte[] ct = new byte[ctLen];
            System.arraycopy(blob, 28, ct, 0, ctLen);

            // node:crypto 布局是 nonce|tag|ct 且 tag 不在密文尾部;
            // Java GCM 约定 tag 追加在密文尾部,因此重组为 ct||tag
            byte[] combined = new byte[ctLen + 16];
            System.arraycopy(blob, 28, combined, 0, ctLen);
            System.arraycopy(blob, 12, combined, ctLen, 16);
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE,
                    new SecretKeySpec(key, "AES"),
                    new GCMParameterSpec(128, nonce));
            return cipher.doFinal(combined);
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

    // ── Step 4: InMemoryDexClassLoader(支持多 DEX 条目) ─────────────────

    private static ClassLoader loadDex(java.util.List<byte[]> dexList) {
        // API26+ 内存加载(InMemoryHolder 隔离引用,API<26 不触发其验证)
        if (android.os.Build.VERSION.SDK_INT >= 26) {
            try {
                return InMemoryHolder.load(dexList);
            } catch (Throwable t) {
                // 落盘降级
            }
        }
        // API<26 降级:落盘 DexClassLoader(能力不缩水,低版本仍可运行)
        try {
            android.content.Context ctx = appContext;
            if (ctx == null) return null;
            java.io.File dir = ctx.getDir("dsodex", android.content.Context.MODE_PRIVATE);
            java.io.File odex = new java.io.File(dir, "o");
            odex.mkdirs();
            StringBuilder paths = new StringBuilder();
            for (int i = 0; i < dexList.size(); i++) {
                java.io.File f = new java.io.File(dir, "p" + i + ".dex");
                java.io.FileOutputStream fo = new java.io.FileOutputStream(f);
                fo.write(dexList.get(i));
                fo.close();
                if (paths.length() > 0) paths.append(java.io.File.pathSeparator);
                paths.append(f.getAbsolutePath());
            }
            return new dalvik.system.DexClassLoader(paths.toString(), odex.getAbsolutePath(), null,
                    DroidSealLoader.class.getClassLoader());
        } catch (Throwable t) {
            return null;
        }
    }

    // 独立类隔离 InMemoryDexClassLoader 引用:API<26 不加载本类即不触发其验证
    private static final class InMemoryHolder {
        static ClassLoader load(java.util.List<byte[]> dexList) {
            try {
                ByteBuffer[] buffers = new ByteBuffer[dexList.size()];
                for (int i = 0; i < dexList.size(); i++) buffers[i] = ByteBuffer.wrap(dexList.get(i));
                return new InMemoryDexClassLoader(buffers, DroidSealLoader.class.getClassLoader());
            } catch (Throwable t) {
                // 部分版本无 ByteBuffer[] 构造——回退单 DEX
                try {
                    if (dexList.size() == 1) {
                        return new InMemoryDexClassLoader(
                                ByteBuffer.wrap(dexList.get(0)), DroidSealLoader.class.getClassLoader());
                    }
                } catch (Throwable ignore) { /* 失败关闭 */ }
                return null;
            }
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
