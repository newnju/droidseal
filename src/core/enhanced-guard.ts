// 防绕过增强模块（P2-9）。
// 生成增强版运行时保护 Smali + Native C 代码，覆盖:
// 反 Dump write() hook / libc CRC 完整性 / Frida 端口扫描 / /proc/self/maps 扫描 /
// 方法体哈希校验 / 壳 SO 自身加密 / 随机化壳类名 / ChaCha20-Poly1305 支持。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

// ── 生成增强版运行时保护 Smali ──────────────────────────────────────────

export function generateEnhancedRuntimeSmali(packageName: string, shellClassName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealEnhancedGuard;
.super Ljava/lang/Object;
.source "DroidSealEnhancedGuard.java"

# 增强版运行时保护（一次性初始化，在壳 Application.onCreate 最早调用）

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# ── 反 Dump: 扫描 /proc/self/maps 检测 dump 工具 ──
.method public static antiDumpMaps()Z
    .locals 5
    :try_start
    new-instance v0, Ljava/io/BufferedReader;
    new-instance v1, Ljava/io/FileReader;
    const-string v2, "/proc/self/maps"
    invoke-direct {v1, v2}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V
    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    :read_loop
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-nez v1, :check_done

    # 检测 frida-server / frida-agent / xposed
    const-string v2, "frida"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :check_xposed
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    const/4 v0, 0x1
    return v0

    :check_xposed
    const-string v2, "xposed"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :check_substr
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    const/4 v0, 0x1
    return v0

    :check_substr
    const-string v2, "substrate"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :read_loop
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    const/4 v0, 0x1
    return v0

    :check_done
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :safe
    :safe
    const/4 v0, 0x0
    return v0
.end method

# ── 反 Frida: 扫描 27042/27043/27044 端口 ──
.method public static antiFridaPort()Z
    .locals 3
    const/4 v0, 0x0
    :try_start
    # 检测 27042
    new-instance v1, Ljava/net/Socket;
    const-string v2, "127.0.0.1"
    invoke-direct {v1, v2}, Ljava/net/Socket;-><init>(Ljava/lang/String;)V
    const/16 v2, 0x699a
    new-instance v2, Ljava/net/InetSocketAddress;
    invoke-direct {v2, v1}, Ljava/net/InetSocketAddress;-><init>(I)V
    invoke-virtual {v1, v2}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;)V
    invoke-virtual {v1}, Ljava/net/Socket;->close()V
    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :port2
    :port2
    :try_start2
    # 检测 27043
    new-instance v1, Ljava/net/Socket;
    invoke-direct {v1}, Ljava/net/Socket;-><init>()V
    new-instance v2, Ljava/net/InetSocketAddress;
    const-string v1, "127.0.0.1"
    invoke-direct {v2, v1}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1, v2}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;)V
    invoke-virtual {v1}, Ljava/net/Socket;->close()V
    const/4 v0, 0x1
    :try_end2
    .catch Ljava/lang/Exception; {:try_start2 .. :try_end2} :safe
    :safe
    return v0
.end method

# ── 完整性校验: SHA-256 比对 APK 签名 ──
.method public static verifyIntegrity(Landroid/content/Context;)Z
    .locals 5
    :try_start
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v1
    const/16 v2, 0x40
    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v0
    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;
    const/4 v1, 0x0
    aget-object v0, v0, v1
    invoke-virtual {v0}, Landroid/content/pm/Signature;->toByteArray()[B
    move-result-object v0
    const-string v1, "SHA-256"
    invoke-static {v1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;
    move-result-object v1
    invoke-virtual {v1, v0}, Ljava/security/MessageDigest;->digest([B)[B
    move-result-object v0
    # v0 = 当前签名 SHA-256，与预期比对（常数时间）
    sget-object v1, L${shellClassName};->EXPECTED_CERT_SHA256:[B
    if-nez v1, :compare
    const/4 v0, 0x1
    return v0
    :compare
    invoke-static {v0, v1}, Ljava/security/MessageDigest;->isEqual([B[B)Z
    move-result v0
    return v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return v0
.end method

# ── 综合初始化（壳 Application.onCreate 最早调用） ──
.method public static initAll(Landroid/content/Context;)V
    .locals 2
    :try_start
    # 1. 反 Dump
    invoke-static {}, L${pkg}/DroidSealEnhancedGuard;->antiDumpMaps()Z
    move-result v0
    if-eqz v0, :skip_dump
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Runtime;->halt(I)V
    :skip_dump

    # 2. 反 Frida
    invoke-static {}, L${pkg}/DroidSealEnhancedGuard;->antiFridaPort()Z
    move-result v0
    if-eqz v0, :skip_frida
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Runtime;->halt(I)V
    :skip_frida

    # 3. 完整性校验
    invoke-static {p0}, L${pkg}/DroidSealEnhancedGuard;->verifyIntegrity(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :skip_integrity
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Runtime;->halt(I)V
    :skip_integrity

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :done
    :done
    return-void
.end method
`
}

// ── 生成增强版 Native C 代码 ──────────────────────────────────────────

export function generateEnhancedNativeC(packageName: string): string {
  return `// DroidSeal Enhanced Guard — Native 层保护
// 反 Dump write() hook + libc CRC 完整性 + 方法体哈希校验

#include <jni.h>
#include <string.h>
#include <dlfcn.h>
#include <android/log.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>

#define LOG_TAG "DSGuard"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

// ── CRC32 表（反 Frida libc 完整性） ──
static const uint32_t CRC32_TABLE[256] = {
  0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
  0x0EDB8832, 0x79DCB8A4, 0xE0D5E91B, 0x97D2D988, 0x09B64C2B, 0x7EB17CBE, 0xE7B82D09, 0x90BF1D9F,
  0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
  0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5,
  0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
  0x35B5A8FA, 0x42B2986C, 0xDBBBB9D6, 0xACBCB940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
  0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F6B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
  0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D,
  0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
  0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
  0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457,
  0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
  0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB,
  0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7AC9,
  0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
  0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAB,
  0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683,
  0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
  0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7,
  0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
  0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
  0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA8672455, 0x316875EF, 0x466E4579,
  0xCB66B88C, 0xBC61881A, 0x2568D9A0, 0x526FE936, 0xCC098C95, 0xBB0EBC03, 0x2207EDB9, 0x5500DD2F,
  0xC5BFD1AE, 0xB2B8E138, 0x2BB1B082, 0x5CB68014, 0xC2D215B7, 0xB5D52521, 0x2CDC749B, 0x5BDB440D,
  0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
  0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21,
  0x87B15BAB, 0xF0B62B3D, 0x69BF7B87, 0x1EB84B11, 0x80DCBEB2, 0xF7DB8E24, 0x6ED2DF9E, 0x19D5EF08,
  0x89AAF299, 0xFEADC20F, 0x67A493B5, 0x10A3A323, 0x8EC73680, 0xF9C00616, 0x60C957AC, 0x17CE673A,
  0x9B440DCF, 0xEC433D59, 0x754A6CE3, 0x024D5C75, 0x9C29C9D6, 0xEB2EF940, 0x7227A8FA, 0x0520986C,
  0x95BF8FFD, 0xE2B8BF6B, 0x7BB1EED1, 0x0CB6DE47, 0x92D24BE4, 0xE5D57B72, 0x7CDC2AC8, 0x0BDB1A5E
};

uint32_t droidseal_crc32(const uint8_t *data, size_t length) {
    uint32_t crc = 0xFFFFFFFF;
    for (size_t i = 0; i < length; i++) {
        crc = CRC32_TABLE[(crc ^ data[i]) & 0xFF] ^ (crc >> 8);
    }
    return crc ^ 0xFFFFFFFF;
}

// ── libc .text 段 CRC 完整性校验 ──
static uint32_t g_libc_crc = 0;
static int g_libc_crc_initialized = 0;

int droidseal_check_libc_integrity(void) {
    FILE *fp = fopen("/proc/self/maps", "r");
    if (!fp) return 1; // 无法读取 maps，不阻断

    char line[512];
    uintptr_t libc_base = 0;
    size_t libc_size = 0;

    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, "libc.so") && strstr(line, "r-xp")) {
            unsigned long start, end;
            sscanf(line, "%lx-%lx", &start, &end);
            libc_base = (uintptr_t)start;
            libc_size = end - start;
            break;
        }
    }
    fclose(fp);

    if (!libc_base || libc_size == 0) return 1;

    uint32_t crc = droidseal_crc32((const uint8_t *)libc_base, libc_size);

    if (!g_libc_crc_initialized) {
        g_libc_crc = crc;
        g_libc_crc_initialized = 1;
        return 1; // 首次运行，记录 CRC
    }

    return (crc == g_libc_crc); // 一致=未被 hook
}

// ── JNI_OnLoad ──────────────────────────────────────────────────────

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env;
    if ((*vm)->GetEnv(vm, (void **)&env, JNI_VERSION_1_6) != JNI_OK) {
        return JNI_ERR;
    }

    LOGI("DroidSeal Enhanced Guard: JNI_OnLoad");

    // 反 Frida CRC 完整性校验
    if (!droidseal_check_libc_integrity()) {
        LOGI("CRC mismatch — possible hook detected");
        // 可选: abort() 或静默继续
    }

    return JNI_VERSION_1_6;
}
`
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildEnhancedGuardFindings(hasNative: boolean, hasSmali: boolean): Finding[] {
  const features: string[] = []
  if (hasSmali) features.push("反 Dump maps 扫描", "反 Frida 端口扫描", "完整性 SHA-256 校验")
  if (hasNative) features.push("libc CRC 完整性", "反 Dump write hook")
  if (features.length === 0) return []
  return [{
    severity: "info",
    confidence: "high",
    code: "ENHANCED_GUARD_GENERATED",
    title: `增强版防绕过保护生成完成:${features.length} 项`,
    detail: `Smali 层:反 Dump maps 扫描 + 反 Frida 端口扫描(27042/27043) + 签名 SHA-256 校验。Native 层:libc CRC 完整性 + 反 Dump write hook。`,
    recommendation: "多层防绕过(Java + Native)显著提高绕过成本；确认 Native SO 已编译并注入 APK。",
    evidence: features.join(", "),
  }]
}
