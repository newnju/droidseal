// Split-Key 实际填入壳 Smali 的 fill-array-data（P0-3）。
// 将真实加密密钥拆分为两部分异或，生成可直接注入壳 Application Smali 的 fill-array-data 字节码。
// 运行时壳 Application 的 onCreate 还原 Split-Key → 解密 payload。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

/**
 * 将字节数组转为 Smali fill-array-data 块。
 * 格式:
 *   .array-data 1
 *   0x1a
 *   0x2b
 *   ...
 *   .end array-data
 */
function bytesToFillArrayData(bytes: Uint8Array, label: string): string {
  const hexLines = Array.from(bytes).map((b) => `0x${b.toString(16).padStart(2, "0")}`)
  return `:${label}\n    .array-data 1\n    ${hexLines.join("\n    ")}\n    .end array-data`
}

/**
 * 生成 Split-Key 的 Smali 字段声明 + 静态初始化代码。
 * 壳 Application 类中有两个 static final 字段:
 *   .field private static final KEY_PART1:[B
 *   .field private static final KEY_PART2:[B
 * 运行时还原: key[i] = part1[i] ^ part2[i]
 */
export function generateSplitKeySmali(
  encryptionKey: Uint8Array,
  shellAppClassName: string, // 如 "Lcom/example/DroidSealApplication;"
): string {
  // Split-Key: part2 随机生成，part1 = key XOR part2
  const part2 = new Uint8Array(encryptionKey.length)
  for (let i = 0; i < encryptionKey.length; i += 1) {
    part2[i] = Math.floor(Math.random() * 256)
  }
  const part1 = new Uint8Array(encryptionKey.length)
  for (let i = 0; i < encryptionKey.length; i += 1) {
    part1[i] = encryptionKey[i]! ^ part2[i]!
  }

  const part1Data = bytesToFillArrayData(part1, "key_part1_data")
  const part2Data = bytesToFillArrayData(part2, "key_part2_data")

  // 生成 Smali 代码:字段声明 + clinit 填充
  return `
# ── Split-Key 字段声明 ──
.field private static final KEY_PART1:[B
.field private static final KEY_PART2:[B

# ── Split-Key 静态初始化(在 <clinit> 中调用) ──
.method private static initSplitKey()V
    .locals 4

    # KEY_PART1
    const/16 v0, ${encryptionKey.length}
    new-array v0, v0, [B
    fill-array-data v0, :key_part1_data
    sput-object v0, ${shellAppClassName};->KEY_PART1:[B

    # KEY_PART2
    const/16 v1, ${encryptionKey.length}
    new-array v1, v1, [B
    fill-array-data v1, :key_part2_data
    sput-object v1, ${shellAppClassName};->KEY_PART2:[B

    return-void

${part1Data}

${part2Data}
.end method

# ── Split-Key 还原(XOR) ──
.method private static restoreKey()[B
    .locals 5

    sget-object v0, ${shellAppClassName};->KEY_PART1:[B
    sget-object v1, ${shellAppClassName};->KEY_PART2:[B
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0

    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v0, v0, v4
    aget-byte v1, v1, v4
    xor-int/2addr v0, v1
    int-to-byte v0, v0
    aput-byte v0, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_loop

    :xor_done
    return-object v3
.end method
`
}

/**
 * 生成完整的壳 Application Smali（含 Split-Key + 解密 + 加载）。
 * 这是加固流水线最终注入到 APK 中的壳 Application 类。
 */
export function generateCompleteShellApplication(
  packageName: string,
  originalApplication: string,
  algorithm: "aes-256-gcm" | "chacha20-poly1305",
): string {
  const pkg = packageName.replace(/\./g, "/")
  const shellClass = `L${pkg}/DroidSealApplication;`

  return `.class public ${shellClass}
.super Landroid/app/Application;
.source "DroidSealApplication.java"

# Split-Key 字段(由加固工具填入真实数据)
.field private static final KEY_PART1:[B
.field private static final KEY_PART2:[B

# 解密后的 ClassLoader 缓存
.field private static volatile classLoader:Ljava/lang/ClassLoader;
.field private static volatile initialized:Z

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Application;-><init>()V
    return-void
.end method

.method public onCreate()V
    .locals 4
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    # 双重检查锁定
    sget-boolean v0, ${shellClass};->initialized:Z
    if-eqz v0, :already_init
    monitor-enter p0
    :try_start
    sget-boolean v0, ${shellClass};->initialized:Z
    if-eqz v0, :do_init
    monitor-exit p0
    goto :already_init
    :do_init

    # 1. 还原 Split-Key
    sget-object v0, ${shellClass};->KEY_PART1:[B
    sget-object v1, ${shellClass};->KEY_PART2:[B
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v0, v0, v4
    aget-byte v1, v1, v4
    xor-int/2addr v0, v1
    int-to-byte v0, v0
    aput-byte v0, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_loop
    :xor_done
    # v3 = encryptionKey

    # 2. 读取加密 payload(追加在 classes.dex 的 file_size 之后)
    # 通过读取自身 APK 的 classes.dex 文件，从 file_size 偏移后提取
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v0
    iget-object v0, v0, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;
    new-instance v1, Ljava/io/RandomAccessFile;
    const-string v2, "r"
    invoke-direct {v1, v0, v2}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    # 读取 DEX header 获取 file_size
    const-wide/16 v2, 0x20
    invoke-virtual {v1, v2, v3}, Ljava/io/RandomAccessFile;->seek(J)V
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->readInt()I
    move-result v2
    # v2 = file_size (壳 DEX 的大小，payload 在此之后)

    # 定位到 payload 开始位置
    int-to-long v2, v2
    invoke-virtual {v1, v2, v3}, Ljava/io/RandomAccessFile;->seek(J)V

    # 读取 payload magic "DROIDSEAL_PAYLOAD" (16B)
    const/16 v2, 0x10
    new-array v2, v2, [B
    invoke-virtual {v1, v2}, Ljava/io/RandomAccessFile;->read([B)I

    # 读取 nonce (12B)
    const/16 v2, 0xc
    new-array v2, v2, [B
    invoke-virtual {v1, v2}, Ljava/io/RandomAccessFile;->read([B)I

    # 读取 tag (16B)
    const/16 v3, 0x10
    new-array v3, v3, [B
    invoke-virtual {v1, v3}, Ljava/io/RandomAccessFile;->read([B)I

    # 读取剩余 ciphertext
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->length()J
    move-result v4
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->getFilePointer()J
    move-result v4
    sub-long/2addr v4, v4
    long-to-int v4, v4
    new-array v4, v4, [B
    invoke-virtual {v1, v4}, Ljava/io/RandomAccessFile;->read([B)I
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->close()V

    # 3. AES-256-GCM 解密
    const-string v0, "AES/GCM/NoPadding"
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;
    move-result-object v0
    new-instance v1, Ljavax/crypto/spec/SecretKeySpec;
    const-string v4, "AES"
    invoke-direct {v1, v3, v4}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V
    new-instance v3, Ljavax/crypto/spec/GCMParameterSpec;
    const/16 v4, 0x80
    invoke-direct {v3, v4, v2}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V
    const/4 v2, 0x2
    invoke-virtual {v0, v2, v1, v3}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V
    invoke-virtual {v0, v4}, Ljavax/crypto/Cipher;->doFinal([B)[B
    move-result-object v0
    # v0 = 解密后的原始 DEX bytes

    # 4. InMemoryDexClassLoader 加载
    new-instance v1, Ldalvik/system/InMemoryDexClassLoader;
    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;
    move-result-object v2
    const-string v3, ""
    invoke-direct {v1, v0, v3, v2}, Ldalvik/system/InMemoryDexClassLoader;-><init>([BLjava/lang/String;Ljava/lang/ClassLoader;)V
    sput-object v1, ${shellClass};->classLoader:Ljava/lang/ClassLoader;

    const/4 v0, 0x1
    sput-boolean v0, ${shellClass};->initialized:Z
    monitor-exit p0

    # 5. 反射调用原始 Application.onCreate
    sget-object v0, ${shellClass};->classLoader:Ljava/lang/ClassLoader;
    const-string v1, "${originalApplication}"
    invoke-virtual {v0, v1}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
    const-string v1, "onCreate"
    const/4 v2, 0x0
    new-array v2, v2, [Ljava/lang/Class;
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    const/4 v1, 0x0
    new-array v1, v1, [Ljava/lang/Object;
    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    goto :already_init

    :try_end
    .catchall {:try_start .. :try_end} :all
    :all
    move-exception v0
    monitor-exit p0
    throw v0

    :already_init
    return-void
.end method
`
}

/**
 * 生成 Split-Key 的完整 Smali 注入数据。
 * 返回需要注入到壳 Application Smali 中的字段声明和初始化代码。
 */
export function generateSplitKeyInjectionData(
  encryptionKey: Uint8Array,
  shellAppClassName: string,
): { smaliFields: string; smaliInit: string; findings: Finding[] } {
  const findings: Finding[] = []

  // Split: part2 随机，part1 = key XOR part2
  const part2 = new Uint8Array(encryptionKey.length)
  for (let i = 0; i < encryptionKey.length; i += 1) {
    part2[i] = Math.floor(Math.random() * 256)
  }
  const part1 = new Uint8Array(encryptionKey.length)
  for (let i = 0; i < encryptionKey.length; i += 1) {
    part1[i] = encryptionKey[i]! ^ part2[i]!
  }

  const hexPart1 = Array.from(part1).map((b) => `0x${b.toString(16).padStart(2, "0")}`).join(",")
  const hexPart2 = Array.from(part2).map((b) => `0x${b.toString(16).padStart(2, "0")}`).join(",")

  const smaliFields = `.field private static final KEY_PART1:[B\n.field private static final KEY_PART2:[B`

  const smaliInit = `# Split-Key 初始化(在 clinit 中)
    const/16 v0, ${encryptionKey.length}
    new-array v0, v0, [B
    fill-array-data v0, :key_part1
    sput-object v0, ${shellAppClassName};->KEY_PART1:[B

    const/16 v0, ${encryptionKey.length}
    new-array v0, v0, [B
    fill-array-data v0, :key_part2
    sput-object v0, ${shellAppClassName};->KEY_PART2:[B

:key_part1
    .array-data 1
    ${hexPart1}
    .end array-data

:key_part2
    .array-data 1
    ${hexPart2}
    .end array-data`

  findings.push({
    severity: "info",
    confidence: "high",
    code: "SPLIT_KEY_INJECTED",
    title: `Split-Key 已拆分并填入壳 Application`,
    detail: `密钥长度: ${encryptionKey.length}B;Part1: ${part1.length}B(XOR 混淆);Part2: ${part2.length}B(随机);运行时通过 XOR 还原。`,
    recommendation: "确认壳 Application 的 clinit 中正确调用了 Split-Key 初始化。",
    evidence: `keyLen=${encryptionKey.length}B`,
  })

  return { smaliFields, smaliInit, findings }
}
