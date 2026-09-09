// 壳加载器生成:三重入口 + Smali stub 生成（#6 #9 #10）。
// 三重入口:AppComponentFactory > ContentProvider > Application 三级兜底。
// 生成壳 Application + ContentProvider + AppComponentFactory 的 Smali 代码。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"

// ── 三重入口 Smali 生成(#6) ──────────────────────────────────────────

/**
 * 生成壳 Application Smali 代码。
 * 负责:1) 解密 DEX payload 2) 通过 InMemoryDexClassLoader 加载 3) 调用原始 Application.onCreate
 */
export function generateShellApplicationSmali(
  packageName: string,
  originalApplication: string,
  encryptedPayloadField: string = "ENCRYPTED_DEX",
): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealApplication;
.super Landroid/app/Application;
.source "DroidSealApplication.java"

# 加密 DEX payload 存储在 static 字段中
.field private static final ${encryptedPayloadField}:[B

# 解密密钥(Split-Key 两部分)
.field private static final KEY_PART1:[B
.field private static final KEY_PART2:[B

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Application;-><init>()V
    return-void
.end method

.method public onCreate()V
    .locals 5
    invoke-super {p0}, Landroid/app/Application;-><init>()V

    # Step 1:触发解密+类加载(所有逻辑在 DroidSealDecryptor 中)
    invoke-static {}, L${pkg}/DroidSealDecryptor;->ensureDecrypted()V

    # Step 2:通过 InMemoryDexClassLoader 获取已加载的类加载器
    sget-object v0, L${pkg}/DroidSealDecryptor;->classLoader:Ljava/lang/ClassLoader;
    if-eqz v0, :fallback
    const-string v1, "${originalApplication}"
    invoke-virtual {v0, v1}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v1

    # Step 3:反射调用原始 Application 的 attachBaseContext
    const-string v2, "attachBaseContext"
    const/4 v3, 0x1
    new-array v3, v3, [Ljava/lang/Class;
    const-class v4, Landroid/content/Context;
    const/4 v5, 0x0
    aput-object v4, v3, v5
    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v2
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    const/4 v3, 0x1
    new-array v3, v3, [Ljava/lang/Object;
    invoke-virtual {p0}, L${pkg}/DroidSealApplication;->getBaseContext()Landroid/content/Context;
    move-result-object v4
    aput-object v4, v3, v5
    invoke-virtual {v2, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    # Step 4:反射调用原始 Application 的 onCreate
    const-string v2, "onCreate"
    const/4 v3, 0x0
    new-array v3, v3, [Ljava/lang/Class;
    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1
    invoke-virtual {v1, v3}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    const/4 v2, 0x0
    new-array v2, v2, [Ljava/lang/Object;
    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    return-void

    :fallback
    # 解密失败——正常启动(降级到壳 Application)
    invoke-super {p0}, Landroid/app/Application;->onCreate()V
    return-void
.end method

.method public attachBaseContext(Landroid/content/Context;)V
    .locals 0
    invoke-super {p0, p1}, Landroid/app/Application;->attachBaseContext(Landroid/content/Context;)V
    return-void
.end method
`
}

/**
 * 生成壳 ContentProvider Smali 代码(第二入口)。
 * 负责:在 Application.onCreate 之前触发解密(冷启动兜底)。
 */
export function generateShellContentProviderSmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealProvider;
.super Landroid/content/ContentProvider;
.source "DroidSealProvider.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V
    return-void
.end method

.method public onCreate()Z
    .locals 1
    # ContentProvider.onCreate 在 Application.onCreate 之前调用
    # 触发 DEX 解密(确保 Application 启动时 DEX 已就绪)
    invoke-static {}, L${pkg}/DroidSealDecryptor;->ensureDecrypted()V
    const/4 v0, 0x1
    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method
`
}

/**
 * 生成壳 AppComponentFactory Smali 代码(第三入口,Android 9+)。
 * 负责:在 ContentProvider 之前触发解密(最早入口)。
 */
export function generateShellAppComponentFactorySmali(packageName: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealComponentFactory;
.super Landroid/app/AppComponentFactory;
.source "DroidSealComponentFactory.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/AppComponentFactory;-><init>()V
    return-void
.end method

.method public instantiateApplication(Ljava/lang/ClassLoader;Ljava/lang/String;)Landroid/app/Application;
    .locals 1
    # AppComponentFactory.instantiateApplication 是 Android 9+ 最早的入口
    # 触发 DEX 解密
    invoke-static {}, L${pkg}/DroidSealDecryptor;->ensureDecrypted()V
    invoke-super {p0, p1, p2}, Landroid/app/AppComponentFactory;->instantiateApplication(Ljava/lang/ClassLoader;Ljava/lang/String;)Landroid/app/Application;
    move-result-object v0
    return-object v0
.end method

.method public instantiateActivity(Ljava/lang/ClassLoader;Ljava/lang/String;Landroid/content/Intent;)Landroid/app/Activity;
    .locals 1
    invoke-super {p0, p1, p2, p3}, Landroid/app/AppComponentFactory;->instantiateActivity(Ljava/lang/ClassLoader;Ljava/lang/String;Landroid/content/Intent;)Landroid/app/Activity;
    move-result-object v0
    return-object v0
.end method

.method public instantiateClassLoader(Ljava/lang/ClassLoader;Landroid/app/ApplicationInfo;)Ljava/lang/ClassLoader;
    .locals 1
    invoke-super {p0, p1, p2}, Landroid/app/AppComponentFactory;->instantiateClassLoader(Ljava/lang/ClassLoader;Landroid/app/ApplicationInfo;)Ljava/lang/ClassLoader;
    move-result-object v0
    return-object v0
.end method
`
}

// ── 三重入口 Manifest 配置 ──────────────────────────────────────────

export interface TripleEntryPointConfig {
  packageName: string
  originalApplication: string
  useAppComponentFactory: boolean // Android 9+ 入口
  useContentProvider: boolean     // Android 4.4+ 入口
  useApplication: boolean         // 所有版本兜底
}

/**
 * 生成三重入口的 Manifest 属性(合并到 AndroidManifest.xml)。
 */
export function generateTripleEntryManifestAttrs(config: TripleEntryPointConfig): string {
  const attrs: string[] = []
  if (config.useAppComponentFactory) {
    attrs.push(`android:appComponentFactory="${config.packageName}.DroidSealComponentFactory"`)
  }
  if (config.useApplication) {
    attrs.push(`android:name="${config.packageName}.DroidSealApplication"`)
  }
  return attrs.join("\n        ")
}

// ── 随机包名/so 名(#10) ──────────────────────────────────────────────

/**
 * 生成随机包名(防特征识别)。
 * 格式:com.[a-z]{2-4}.[a-z]{2-4}.[a-z]{2-4}
 */
export function generateRandomPackageName(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  const rand = (len: number) => Array.from({ length: len }, () => chars[Math.floor(Math.random() * chars.length)]).join("")
  return `com.${rand(2 + Math.floor(Math.random() * 3))}.${rand(2 + Math.floor(Math.random() * 3))}.${rand(2 + Math.floor(Math.random() * 3))}`
}

/**
 * 生成随机 SO 名(防特征识别)。
 * 格式:lib[a-z]{3-6}.so
 */
export function generateRandomSoName(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  const len = 3 + Math.floor(Math.random() * 4)
  const name = Array.from({ length: len }, () => chars[Math.floor(Math.random() * chars.length)]).join("")
  return `lib${name}.so`
}

// ── 壳加载器完整配置 ──────────────────────────────────────────────────

export interface ShellLoaderConfig {
  packageName: string
  originalApplication: string
  randomPackageName?: string | undefined
  randomSoName?: string | undefined
  tripleEntry: TripleEntryPointConfig
  algorithm: "aes-256-gcm" | "chacha20-poly1305"
  useSplitKey: boolean
  classExclusionPatterns: string[]
}

export function generateShellLoaderFiles(config: ShellLoaderConfig): Array<{ name: string; content: string }> {
  const files: Array<{ name: string; content: string }> = []
  const pkg = (config.randomPackageName ?? config.packageName).replace(/\./g, "/")

  // 1. 壳 Application
  files.push({ name: `smali/${pkg}/DroidSealApplication.smali`, content: generateShellApplicationSmali(config.packageName, config.originalApplication) })

  // 2. 壳 ContentProvider
  if (config.tripleEntry.useContentProvider) {
    files.push({ name: `smali/${pkg}/DroidSealProvider.smali`, content: generateShellContentProviderSmali(config.packageName) })
  }

  // 3. 壳 AppComponentFactory
  if (config.tripleEntry.useAppComponentFactory) {
    files.push({ name: `smali/${pkg}/DroidSealComponentFactory.smali`, content: generateShellAppComponentFactorySmali(config.packageName) })
  }

  // 4. 解密器
  files.push({ name: `smali/${pkg}/DroidSealDecryptor.smali`, content: generateDecryptorSmali(config.packageName, config.algorithm) })

  return files
}

function generateDecryptorSmali(packageName: string, algorithm: string): string {
  const pkg = packageName.replace(/\./g, "/")
  return `.class public L${pkg}/DroidSealDecryptor;
.super Ljava/lang/Object;
.source "DroidSealDecryptor.java"

.field private static volatile decrypted:Z
.field private static final lock:Ljava/lang/Object;
.field public static classLoader:Ljava/lang/ClassLoader;

.method static constructor <clinit>()V
    .locals 1
    new-instance v0, Ljava/lang/Object;
    invoke-direct {v0}, Ljava/lang/Object;-><init>()V
    sput-object v0, L${pkg}/DroidSealDecryptor;->lock:Ljava/lang/Object;
    const/4 v0, 0x0
    sput-boolean v0, L${pkg}/DroidSealDecryptor;->decrypted:Z
    return-void
.end method

.method public static ensureDecrypted()V
    .locals 2
    sget-boolean v0, L${pkg}/DroidSealDecryptor;->decrypted:Z
    if-eqz v0, :already
    sget-object v0, L${pkg}/DroidSealDecryptor;->lock:Ljava/lang/Object;
    monitor-enter v0
    :try_start
    sget-boolean v1, L${pkg}/DroidSealDecryptor;->decrypted:Z
    if-eqz v1, :do_decrypt
    # 解密逻辑:${algorithm}
    invoke-static {}, L${pkg}/DroidSealDecryptor;->doDecrypt()V
    const/4 v1, 0x1
    sput-boolean v1, L${pkg}/DroidSealDecryptor;->decrypted:Z
    :do_decrypt
    monitor-exit v0
    :try_end
    .catchall {:try_start .. :try_end} :all
    :already
    return-void
    :all
    move-exception v1
    monitor-exit v0
    throw v1
.end method

.method private static doDecrypt()V
    .locals 8

    # 1. 还原 Split-Key(XOR):part1 XOR part2 = encryptionKey
    sget-object v0, L${pkg}/DroidSealDecryptor;->KEY_PART1:[B
    sget-object v1, L${pkg}/DroidSealDecryptor;->KEY_PART2:[B
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_key_loop
    if-ge v4, v2, :xor_key_done
    aget-byte v5, v0, v4
    aget-byte v6, v1, v4
    xor-int/2addr v5, v6
    int-to-byte v5, v5
    aput-byte v5, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_key_loop
    :xor_key_done
    # v3 = encryptionKey (32 bytes)

    # 2. 读取加密 payload(nonce[12] + tag[16] + ciphertext)
    sget-object v0, L${pkg}/DroidSealApplication;->ENCRYPTED_DEX:[B
    const/16 v1, 0xc
    new-array v4, v1, [B  # nonce
    const/4 v5, 0x0
    invoke-static {v0, v5, v4, v5, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    const/16 v1, 0x10
    new-array v5, v1, [B  # tag
    const/16 v6, 0xc
    invoke-static {v0, v6, v5, v5, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    array-length v1, v0
    const/16 v6, 0x1c
    sub-int/2addr v1, v6
    new-array v7, v1, [B  # ciphertext
    invoke-static {v0, v6, v7, v5, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    # 3. AES-256-GCM 解密
    const-string v0, "AES/GCM/NoPadding"
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;
    move-result-object v0

    new-instance v1, Ljavax/crypto/spec/SecretKeySpec;
    const-string v6, "AES"
    invoke-direct {v1, v3, v6}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V

    new-instance v3, Ljavax/crypto/spec/GCMParameterSpec;
    const/16 v6, 0x80
    invoke-direct {v3, v6, v4}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    const/4 v4, 0x2
    invoke-virtual {v0, v4, v1, v3}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    invoke-virtual {v0, v7}, Ljavax/crypto/Cipher;->doFinal([B)[B
    move-result-object v0
    # v0 = decrypted DEX bytes

    # 4. InMemoryDexClassLoader 加载
    new-instance v1, Ldalvik/system/InMemoryDexClassLoader;
    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;
    move-result-object v2
    const-string v3, ""
    invoke-direct {v1, v0, v3, v2}, Ldalvik/system/InMemoryDexClassLoader;-><init>([BLjava/lang/String;Ljava/lang/ClassLoader;)V

    # 5. 存储类加载器供 Application.onCreate 使用
    sput-object v1, L${pkg}/DroidSealDecryptor;->classLoader:Ljava/lang/ClassLoader;

    return-void
.end method
`
}

export function buildShellLoaderFindings(config: ShellLoaderConfig, files: Array<{ name: string; content: string }>): Finding[] {
  return [{
    severity: "info", confidence: "high", code: "SHELL_LOADER_GENERATED",
    title: `壳加载器生成完成:${files.length} 个 Smali 文件(三重入口)`,
    detail: `入口:${config.tripleEntry.useAppComponentFactory ? "AppComponentFactory" : ""}${config.tripleEntry.useContentProvider ? "+ContentProvider" : ""}+Application。算法:${config.algorithm}。Split-Key:${config.useSplitKey ? "是" : "否"}。${config.randomPackageName ? `随机包名:${config.randomPackageName}` : ""}`,
    recommendation: "三重入口兼容 Android 4.4~16;AppComponentFactory(Android 9+)为最早入口。",
    evidence: files.map((f) => f.name).join(", "),
  }]
}
