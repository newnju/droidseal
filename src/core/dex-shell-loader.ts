// 壳加载器生成:三重入口 + Smali stub 生成（#6 #9 #10）。
// 三重入口:AppComponentFactory > ContentProvider > Application 三级兜底。
// 生成壳 Application + ContentProvider + AppComponentFactory 的 Smali 代码。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { randomBytes } from "node:crypto"

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
    # VMP 里程碑 B:app 类已随 classloader 就绪,此时 RegisterNatives 才能成功
    # (JNI_OnLoad 时 app 类未加载,注册必败)。dsvmRegisterAll 返回注册数,fail-open。
    invoke-static {}, L${pkg}/DroidSealLoader;->dsvmRegisterAll()I
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
  const rand = (len: number) => Array.from(randomBytes(len), (b) => chars[b % chars.length]).join("")
  const seg = () => rand(2 + (randomBytes(1)[0]! % 3))
  return `com.${seg()}.${seg()}.${seg()}`
}

/**
 * 生成随机 SO 名(防特征识别)。
 * 格式:lib[a-z]{3-6}.so
 */
export function generateRandomSoName(): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  const len = 3 + (randomBytes(1)[0]! % 4)
  const name = Array.from(randomBytes(len), (b) => chars[b % chars.length]).join("")
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

function generateDecryptorSmali(packageName: string, algorithm: string, part1?: Uint8Array, part2?: Uint8Array): string {
  const pkg = packageName.replace(/\./g, "/")
  const toArr = (label: string, buf?: Uint8Array) => {
    if (!buf) return `    # (no part injected — weak mode)\n    :${label}_empty\n    .array-data 1\n        0x0t\n    .end array-data`
    return `    :${label}\n    .array-data 1\n${[...buf].map((b) => `        0x${b.toString(16).padStart(2, "0")}`).join("\n")}\n    .end array-data`
  }
  return `.class public L${pkg}/DroidSealDecryptor;
.super Ljava/lang/Object;
.source "DroidSealDecryptor.java"

.field private static volatile decrypted:Z
.field private static final lock:Ljava/lang/Object;
.field public static classLoader:Ljava/lang/ClassLoader;
.field private static final KEY_PART1:[B
.field private static final KEY_PART2:[B

.method static constructor <clinit>()V
    .locals 1
    new-instance v0, Ljava/lang/Object;
    invoke-direct {v0}, Ljava/lang/Object;-><init>()V
    sput-object v0, L${pkg}/DroidSealDecryptor;->lock:Ljava/lang/Object;
    const/4 v0, 0x0
    sput-boolean v0, L${pkg}/DroidSealDecryptor;->decrypted:Z
    const/16 v0, 0x20
    new-array v0, v0, [B
    fill-array-data v0, :array_part1
    sput-object v0, L${pkg}/DroidSealDecryptor;->KEY_PART1:[B
    const/16 v0, 0x20
    new-array v0, v0, [B
    fill-array-data v0, :array_part2
    sput-object v0, L${pkg}/DroidSealDecryptor;->KEY_PART2:[B
    return-void

    :array_part1
    .array-data 1
${part1 ? [...part1].map((b) => `        0x${b.toString(16).padStart(2, "0")}`).join("\n") : "        0x0t"}
    .end array-data

    :array_part2
    .array-data 1
${part2 ? [...part2].map((b) => `        0x${b.toString(16).padStart(2, "0")}`).join("\n") : "        0x0t"}
    .end array-data
.end method

# ── 读 APK 全文件 ──────────────────────────────────────────────────────
.method private static getAppBytes()[B
    .locals 6
    :try_start
    const-string v0, "android.app.ActivityThread"
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
    const-string v1, "currentApplication"
    const/4 v2, 0x0
    new-array v2, v2, [Ljava/lang/Class;
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    const/4 v1, 0x0
    new-array v1, v1, [Ljava/lang/Object;
    invoke-virtual {v0, v1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/Application;
    invoke-virtual {v0}, Landroid/app/Application;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v0
    iget-object v1, v0, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;
    new-instance v0, Ljava/io/RandomAccessFile;
    const-string v2, "r"
    invoke-direct {v0, v1, v2}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->length()J
    move-result-wide v2
    long-to-int v2, v2
    new-array v3, v2, [B
    invoke-virtual {v0, v3}, Ljava/io/RandomAccessFile;->readFully([B)V
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V
    return-object v3
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method

# ── 在 APK 字节中扫描 16B magic,返回数据起始偏移(-1=未找到) ─────────────
.method private static scanMagic([B Ljava/lang/String;)I
    .locals 8
    const/4 v0, -1
    array-length v1, p0
    const/16 v2, 0x14
    if-lt v1, v2, :ret
    invoke-virtual {p1}, Ljava/lang/String;->length()I
    move-result v2
    const/4 v3, 0x0
    const/4 v4, 0x0
    :loop
    if-ge v4, v2, :store
    invoke-virtual {p1, v4}, Ljava/lang/String;->charAt(I)C
    move-result v5
    int-to-byte v5, v5
    aget-byte v6, p0, v4
    if-eq v5, v6, :next
    const/4 v3, 0x0
    goto :inc
    :next
    if-eqz v3, :first_hit
    add-int/lit8 v3, v3, 0x1
    goto :inc
    :first_hit
    const/4 v3, 0x1
    add-int/lit8 v7, v3, v2
    :inc
    add-int/lit8 v4, v4, 0x1
    goto :loop
    :store
    if-eqz v3, :ret
    sub-int v0, v4, v2
    :ret
    return v0
.end method

# ── 组合 Split-Key 并 AES-GCM 解密 payload(nonce/tag/ciphertext) ────────
.method private static decryptPayload([B I Ljava/lang/String;)[B
    .locals 9
    :try_start
    # 组合 key: part1 XOR part2
    sget-object v0, L${pkg}/DroidSealDecryptor;->KEY_PART1:[B
    sget-object v1, L${pkg}/DroidSealDecryptor;->KEY_PART2:[B
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v5, v0, v4
    aget-byte v6, v1, v4
    xor-int/2addr v5, v6
    int-to-byte v5, v5
    aput-byte v5, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_loop
    :xor_done
    # p0=apk p1=offset payload: magic16 | origLen4 | nonce12 | tag16 | ct
    const/16 v0, 0x20
    add-int v0, v0, p1
    new-array v0, v0, [B
    const/16 v1, 0x0
    const/16 v2, 0x10
    invoke-static {p0, p1, v0, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    const/16 v1, 0x10
    const/16 v2, 0x10
    invoke-static {p0, p1, v0, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    add-int/lit8 p1, p1, 0x20
    add-int/lit8 v2, p2, -0x20
    new-array v2, v2, [B
    const/16 v1, 0x0
    invoke-static {p0, p1, v2, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    # AES-GCM
    const-string v0, "AES/GCM/NoPadding"
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;
    move-result-object v4
    new-instance v5, Ljavax/crypto/spec/SecretKeySpec;
    const-string v6, "AES"
    invoke-direct {v5, v3, v6}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V
    const/16 v6, 0x10
    new-array v6, v6, [B
    const/16 v7, 0x0
    invoke-static {p0, p1, v6, v7, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    new-instance v7, Ljavax/crypto/spec/GCMParameterSpec;
    const/16 v8, 0x80
    invoke-direct {v7, v8, v6}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V
    const/4 v6, 0x2
    invoke-virtual {v4, v6, v5, v7}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V
    invoke-virtual {v4, v2}, Ljavax/crypto/Cipher;->doFinal([B)[B
    move-result-object v0
    return-object v0
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method

# ── CodeItem 表还原 + 校验和重算 ──────────────────────────────────────────
.method private static restoreCode([B Ljava/lang/String;)[B
    .locals 10
    :try_start
    invoke-virtual {p1}, Ljava/lang/String;->length()I
    move-result v0
    invoke-static {p0, p1, v0}, L${pkg}/DroidSealDecryptor;->scanMagic([B Ljava/lang/String;)I
    move-result v1
    const/4 v0, -1
    if-eq v1, v0, :ret_orig
    # citable: magic16 | encLen4 | nonce12 | tag16 | ct
    add-int/lit8 v2, v1, 0x10
    add-int/lit8 v3, v2, 0x4
    invoke-static {p0, v3, p1, v0}, L${pkg}/DroidSealDecryptor;->decryptPayload([B I Ljava/lang/String;)[B
    move-result-object v0
    if-eqz v0, :ret_orig
    # 解密失败(签名变化) → 返回原 DEX(壳 fallback)
    invoke-static {v0, p1, v0}, L${pkg}/DroidSealDecryptor;->decryptPayload([B I Ljava/lang/String;)[B
    move-result-object v0
    if-eqz v0, :ret_orig
    # v0 = CodeItem 表: magic12 | ver4 | count4 | records20*n | codeData
    const/16 v1, 0x14
    invoke-virtual {v0, v1}, Ljava/lang/Object;->notify()V  # placeholder removed below
    :ret_orig
    return-object p0
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :fail
    :fail
    return-object p0
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
