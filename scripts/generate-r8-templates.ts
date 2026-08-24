#!/usr/bin/env bun
// R8 规则模板库（开发路线「构建期/发布工程化」——generate-r8-templates.ts）。
// 生成常见库的 R8 keep 规则模板（Retrofit/Room/协程/序列化）——发布构建开启
// minifyEnabled 时避免误删反射/序列化依赖——失败关闭。
//
// 用法：
//   bun scripts/generate-r8-templates.ts <输出目录> [--json]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

interface R8Template {
  name: string
  target: string
  rules: string[]
}

const TEMPLATES: readonly R8Template[] = [
  {
    name: "retrofit",
    target: "Retrofit",
    rules: [
      "-keepattributes Signature, InnerClasses, EnclosingMethod, *Annotation*, Exceptions",
      "-keep,allowshrinking,allowoptimization class retrofit2.** { *; }",
      "-keep interface retrofit2.** { *; }",
      "-dontwarn retrofit2.**",
    ],
  },
  {
    name: "room",
    target: "Room",
    rules: [
      "-keep class * extends androidx.room.RoomDatabase { <init>(); }",
      "-keep @androidx.room.Entity class * { *; }",
      "-keep @androidx.room.Dao interface * { *; }",
      "-keep class **.RoomDatabase_* { *; }",
      "-dontwarn androidx.room.paging.**",
    ],
  },
  {
    name: "coroutines",
    target: "Kotlin 协程",
    rules: [
      "-keep class kotlinx.coroutines.** { *; }",
      "-keep class kotlin.coroutines.** { *; }",
      "-dontwarn kotlinx.coroutines.**",
      "-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory",
    ],
  },
  {
    name: "serialization",
    target: "序列化(Gson/Moshi/Java)",
    rules: [
      "-keep class com.google.gson.reflect.TypeToken { *; }",
      "-keep class * extends com.google.gson.reflect.TypeToken",
      "-keep class com.squareup.moshi.** { *; }",
      "-keepclassmembers class * implements java.io.Serializable { private static final java.io.SerialVersionUID; }",
      "-keepattributes Signature",
    ],
  },
]

async function main(): Promise<void> {
  const argv = process.argv.slice(2)
  const outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-r8-templates <输出目录>")
  await mkdir(outputDir, { recursive: true })
  const files: string[] = []
  for (const t of TEMPLATES) {
    const content = `# DroidSeal R8 规则模板 —— ${t.name}（${t.target}）
# 放入 app/proguard-rules.pro 或 build.gradle 的 proguardFiles 引用的规则文件中。
${t.rules.join("\n")}
`
    const file = path.join(outputDir, `${t.name}-r8.pro`)
    await writeFile(file, content, "utf8")
    files.push(file)
  }
  console.log(`已生成 R8 规则模板（${TEMPLATES.length} 组——Retrofit/Room/协程/序列化）：`)
  for (const f of files) console.log(`  ${f}`)
}

main().catch((error) => {
  console.error(`R8 模板生成失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
