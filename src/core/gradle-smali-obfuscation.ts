// Gradle/Smali 黑盒混淆模块（#48-#61）。
// ASM 编译期注入 + RASP Gradle 插件桩 + Smali 级混淆技术。
// 类重命名/Goto 插入/方法重载混淆/基本块乱序/Reflection 包装/资源加密/Junk Code。
// 纯 TypeScript，生成 Smali/Gradle 配置文件，失败关闭。
import type { Finding } from "./types.ts"

// ── ASM 编译期垃圾代码注入(#48) ──────────────────────────────────────────

/**
 * 生成 ASM 垃圾代码注入的 Gradle 插件配置。
 * app-code-obfuscation 特征:在编译期向类/方法/代码段注入无害垃圾代码。
 */
export function generateAsmJunkCodeGradleConfig(): string {
  return `// DroidSeal ASM 垃圾代码注入配置
// 在 build.gradle 中 apply plugin: 'com.droidseal.junkcode'

buildscript {
    dependencies {
        classpath 'com.android.tools.build:gradle:8.0.0+'
    }
}

// 配置选项
droidsealJunkCode {
    enabled = true
    junkFieldCount = 20      // 每个类注入的垃圾字段数
    junkMethodCount = 10     // 每个类注入的垃圾方法数
    junkInstructionCount = 50 // 每个方法注入的垃圾指令数
    excludeClasses = [
        'com.example.R',
        'com.example.BuildConfig',
        'com.example.MainActivity'  // 排除入口 Activity
    ]
}
`
}

/**
 * 生成 ASM 字节码注入器的伪代码(实际需 Kotlin/Java Gradle 插件)。
 */
export function generateAsmInjectorDescription(): string {
  return `// DroidSeal ASM 注入器(Gradle Plugin 核心逻辑)
// 使用 ASM ClassVisitor/MethodVisitor 在编译期注入垃圾代码

class JunkCodeClassVisitor extends ClassVisitor {
    @Override
    void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
        // 注入垃圾字段
        for (int i = 0; i < config.junkFieldCount; i++) {
            cv.visitField(ACC_PRIVATE, "junkField\$" + i, "I", null, random.nextInt())
        }
        super.visit(version, access, name, signature, superName, interfaces)
    }

    @Override
    MethodVisitor visitMethod(int access, String name, String desc, String signature, String[] exceptions) {
        MethodVisitor mv = super.visitMethod(access, name, desc, signature, exceptions)
        return new JunkCodeMethodVisitor(mv, config)
    }
}

class JunkCodeMethodVisitor extends MethodVisitor {
    @Override
    void visitCode() {
        super.visitCode()
        // 注入垃圾指令
        for (int i = 0; i < config.junkInstructionCount; i++) {
            // 生成无害指令:const/push + pop, 或 if + goto 垃圾分支
            mv.visitInsn(ICONST_0 + random.nextInt(5))
            mv.visitInsn(POP)
        }
    }
}
`
}

// ── RASP Gradle 插件桩(#49) ──────────────────────────────────────────────

/**
 * 生成 RASP Gradle 插件配置(hydra 特征)。
 * OLLVM 混淆的 Native 核心，启动时自动检测 Root/钩子/克隆/完整性。
 */
export function generateRaspGradleConfig(): string {
  return `// DroidSeal RASP Gradle 插件配置
// hydra 特征:零代码改动，编译期自动注入 RASP 保护

droidsealRasp {
    enabled = true

    // 检测开关(可分别启用/禁用)
    rootDetection = true          // Root 检测
    hookDetection = true          // Hook 框架检测(Xposed/Frida/Substrate)
    cloneDetection = true         // 应用克隆检测
    integrityCheck = true         // 完整性校验(签名/哈希)
    emulatorDetection = true      // 模拟器检测

    // 检测行为
    onDetected = "crash"          // "crash" | "exception" | "log" | "callback"
    crashMessage = "Security violation detected"

    // 密钥绑定(hydra.secret() 特征)
    bindToCleanState = true       // 密钥绑定设备清洁状态(无 Root/无 Hook)

    // Native 核心
    nativeCore = true             // 使用 OLLVM 混淆的 Native 核心
    nativeLibName = "libdroidseal_rasp" // 自定义 SO 名
}
`
}

// ── Smali 级混淆技术(#51-#61) ──────────────────────────────────────────

/**
 * 生成 Smali 类重命名映射表(#51 #59)。
 * 将类名/方法名/字段名替换为极短名称(a/b/c 等)。
 */
export function generateSmaliRenameMapping(classes: string[]): Array<{ original: string; renamed: string }> {
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  const mapping: Array<{ original: string; renamed: string }> = []
  let counter = 0
  for (const cls of classes) {
    const renamed = generateShortName(counter++)
    mapping.push({ original: cls, renamed })
  }
  return mapping
}

function generateShortName(index: number): string {
  const chars = "abcdefghijklmnopqrstuvwxyz"
  let name = ""
  let i = index
  do {
    name = chars[i % 26] + name
    i = Math.floor(i / 26) - 1
  } while (i >= 0)
  return name
}

/**
 * 生成 Goto 插入混淆(#53)。
 * 在方法体中插入 goto 指令跳转到垃圾代码块。
 */
export function generateGotoInsertionSmali(originalCode: string): string {
  return `# DroidSeal Goto 插入混淆
# 在原始代码中插入 goto 跳转到垃圾代码块
# Obfuscapk 特征

.method public example()V
    .locals 1

    # 原始代码
    ${originalCode.split("\n").join("\n    ")}

    # 插入 goto → 垃圾代码块
    goto :junk_block_1

    :junk_block_1
    # 垃圾代码(永远不执行——前面有 return)
    const/4 v0, 0x0
    if-eqz v0, :real_code
    const-string v0, "dead_code"
    invoke-static {v0}, Landroid/util/Log;->d(Ljava/lang/String;)I
    goto :junk_block_2

    :junk_block_2
    const/16 v0, 0xff
    xor-int/lit8 v0, v0, 0x0
    goto :junk_block_1  # 死循环(但永远不会到达)

    :real_code
    return-void
.end method
`
}

/**
 * 生成方法重载混淆(#55)。
 * 利用 Java 方法重载歧义混淆。
 */
export function generateMethodOverloadSmali(): string {
  return `# DroidSeal 方法重载混淆
# 创建同名但不同签名的方法，干扰分析
# Obfuscapk 特征

.method public a()V
    .locals 0
    return-void
.end method

.method public a(I)V
    .locals 0
    return-void
.end method

.method public a(II)V
    .locals 0
    return-void
.end method

.method public a(III)V
    .locals 0
    return-void
.end method

.method public a(Ljava/lang/String;)V
    .locals 0
    return-void
.end method

.method public a(Ljava/lang/String;I)V
    .locals 0
    return-void
.end method
`
}

/**
 * 生成 Reflection 包装调用(#52)。
 * 用反射替代直接调用，增加分析难度。
 */
export function generateReflectionWrapSmali(targetClass: string, targetMethod: string): string {
  const cls = targetClass.replace(/\./g, "/")
  return `# DroidSeal Reflection 包装
# 用反射替代直接调用:${targetClass}.${targetMethod}
# Obfuscapk 特征

.method public static reflectiveCall()V
    .locals 4
    :try_start
    const-string v0, "${targetClass}"
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
    const-string v1, "${targetMethod}"
    const/4 v2, 0x0
    new-array v2, v2, [Ljava/lang/Class;
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    const/4 v1, 0x0
    const/4 v2, 0x0
    new-array v2, v2, [Ljava/lang/Object;
    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch
    :catch
    return-void
.end method
`
}

/**
 * 生成 Nop 插入混淆(#53)。
 * 在方法体中插入大量 nop 指令。
 */
export function generateNopInsertion(count: number = 20): string {
  return Array.from({ length: count }, () => "    nop").join("\n")
}

/**
 * 生成基本块乱序(#54)。
 * 打乱 Smali 方法内基本块的物理顺序。
 */
export function generateBasicBlockReorder(blocks: string[]): string[] {
  // Fisher-Yates shuffle
  const shuffled = [...blocks]
  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j]!, shuffled[i]!]
  }
  return shuffled
}

// ── Gradle Plugin Portal 发布配置(#50) ──────────────────────────────────

export function generateGradlePluginPortalConfig(): string {
  return `// DroidSeal Gradle Plugin 发布配置
// 发布到 Gradle Plugin Portal

plugins {
    id 'java-gradle-plugin'
    id 'maven-publish'
    id 'com.gradle.plugin-publish' version '1.2.0'
}

gradlePlugin {
    plugins {
        droidsealObfuscation {
            id = 'com.droidseal.obfuscation'
            displayName = 'DroidSeal Obfuscation Plugin'
            description = 'Android APK obfuscation and protection Gradle plugin'
            implementationClass = 'com.droidseal.gradle.DroidSealObfuscationPlugin'
            tags.set(['android', 'obfuscation', 'security', 'protection'])
        }
        droidsealRasp {
            id = 'com.droidseal.rasp'
            displayName = 'DroidSeal RASP Plugin'
            description = 'Android Runtime Application Self-Protection Gradle plugin'
            implementationClass = 'com.droidseal.gradle.DroidSealRaspPlugin'
            tags.set(['android', 'rasp', 'security', 'runtime'])
        }
    }
}
`
}

// ── ARouter 路由表预注册(#61) ──────────────────────────────────────────

/**
 * 生成 ARouter 路由表预注册 Smali 代码。
 * mocika-shield 特征:保护前自动扫描 ARouter 路由表并预注册。
 */
export function generateArouterPreRegistration(packageName: string, routes: Array<{ path: string; className: string }>): string {
  const pkg = packageName.replace(/\./g, "/")
  const routeEntries = routes.map((r) =>
    `    const-string v0, "${r.path}"\n    const-string v1, "${r.className}"\n    invoke-virtual {v2, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;`
  ).join("\n\n")

  return `.class public L${pkg}/DroidSealArouterPreRegister;
.super Ljava/lang/Object;
.source "DroidSealArouterPreRegister.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# 预注册 ARouter 路由表(加固前扫描并注入)
.method public static preRegisterRoutes()Ljava/util/HashMap;
    .locals 3
    new-instance v2, Ljava/util/HashMap;
    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

${routeEntries}

    return-object v2
.end method
`
}

// ── 假 SO/假 ProGuard 注入(#60) ──────────────────────────────────────────

/**
 * 生成假 SO 文件名列表(APK-SHIELD-X 特征)。
 * 在 lib/ 目录下放置空的/假的 .so 文件，干扰分析。
 */
export function generateFakeSoFiles(count: number = 3): Array<{ name: string; content: Uint8Array }> {
  const files: Array<{ name: string; content: Uint8Array }> = []
  for (let i = 0; i < count; i += 1) {
    const name = `lib/arm64-v8a/lib${generateShortName(i + 100)}.so`
    // 生成最小 ELF 文件(仅 header)
    const elf = new Uint8Array(64)
    elf.set([0x7f, 0x45, 0x4c, 0x46]) // ELF magic
    elf[4] = 2 // 64-bit
    elf[5] = 1 // little-endian
    elf[6] = 1 // ELF version
    elf[7] = 0 // OS/ABI
    files.push({ name, content: elf })
  }
  return files
}

// ── Finding 生成 ──────────────────────────────────────────────────────

export function buildGradleSmaliFindings(
  hasAsmJunk: boolean,
  hasRasp: boolean,
  hasSmaliObfuscation: boolean,
  hasReflectionWrap: boolean,
  hasGotoInsertion: boolean,
  hasMethodOverload: boolean,
  hasArouterPreReg: boolean,
  hasFakeSo: boolean,
): Finding[] {
  const techniques: string[] = []
  if (hasAsmJunk) techniques.push("ASM 垃圾代码注入")
  if (hasRasp) techniques.push("RASP 插件")
  if (hasSmaliObfuscation) techniques.push("Smali 重命名")
  if (hasReflectionWrap) techniques.push("Reflection 包装")
  if (hasGotoInsertion) techniques.push("Goto/Nop 插入")
  if (hasMethodOverload) techniques.push("方法重载混淆")
  if (hasArouterPreReg) techniques.push("ARouter 预注册")
  if (hasFakeSo) techniques.push("假 SO 注入")

  if (techniques.length === 0) return []
  return [{
    severity: "info", confidence: "high", code: "GRADLE_SMALI_OBFUSCATION",
    title: `Gradle/Smali 混淆:${techniques.length} 项技术`,
    detail: `已启用:${techniques.join("; ")}。`,
    recommendation: "混淆技术越多，自动化逆向难度越高。确认不会影响正常功能。",
    evidence: techniques.join(", "),
  }]
}
