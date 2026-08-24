#!/usr/bin/env bun
// 加壳（轻量 DEX 加密/动态加载——generate-dex-loader.ts）。
// 生成 Loader 类 + 集成说明（源码接入——不事后改写未知 APK）：
//   - 把敏感类的 DEX 字节码加密为 assets 资源（构建期用本工具的加密函数或脚本）；
//   - 运行期 Loader 解密 → 写临时 DEX → DexClassLoader 加载 → 反射调用被保护类；
//   - 静态分析只见 Loader 与加密资源——不见真实类字节码（packer 形态的源码接入版）。失败关闭。
//
// 用法：
//   bun scripts/generate-dex-loader.ts <输出目录> [--class Loader 类名] [--asset 资源名] [--target 被保护类名]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; className: string; asset: string; target: string } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-dex-loader <输出目录> [--class 类名] [--asset 资源名] [--target 被保护类名]")
  let className = "DexLoader"
  let asset = "protected.dex.enc"
  let target = "com.example.ProtectedLogic"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--class") className = argv[++i] ?? "DexLoader"
    if (argv[i] === "--asset") asset = argv[++i] ?? "protected.dex.enc"
    if (argv[i] === "--target") target = argv[++i] ?? "com.example.ProtectedLogic"
  }
  return { outputDir, className, asset, target }
}

async function generate(outputDir: string, className: string, asset: string, target: string): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  const content = `// 自动生成的轻量 DEX 加密 Loader（DroidSeal 加壳——源码接入——不事后改写未知 APK）。
// 使用：把敏感类的 DEX 字节码用构建期脚本加密为 assets/${asset}——运行期本 Loader 解密并
// DexClassLoader 加载——反射调用 ${target}——静态分析只见 Loader 与加密资源。
package com.example.loader;

import android.content.Context;
import dalvik.system.DexClassLoader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

/** 轻量 DEX 加密 Loader（解密 assets 加密 DEX → 动态加载 → 反射调用） */
public final class ${className} {

    private static final String ASSET = "${asset}";
    private static final String TARGET = "${target}";

    /** 解密 assets 中的加密 DEX 并加载（XOR 轮转——与构建期加密函数对应——可换更强算法） */
    public static Object loadAndInvoke(Context ctx, byte[] key, String method, Object... args) throws Exception {
        InputStream is = ctx.getAssets().open(ASSET);
        byte[] enc = new byte[is.available()];
        int read = is.read(enc);
        if (read != enc.length) throw new IllegalStateException("读取加密 DEX 不完整");
        byte[] dex = new byte[enc.length];
        for (int i = 0; i < enc.length; i += 1) {
            dex[i] = (byte) (enc[i] ^ key[i % key.length]);
        }
        File dir = ctx.getDir("loader", Context.MODE_PRIVATE);
        File dexFile = new File(dir, "protected.dex");
        FileOutputStream fos = new FileOutputStream(dexFile);
        fos.write(dex);
        fos.close();

        DexClassLoader loader = new DexClassLoader(dexFile.getAbsolutePath(), dir.getAbsolutePath(), null, ctx.getClassLoader());
        Class<?> cls = Class.forName(TARGET, true, loader);
        java.lang.reflect.Method m = cls.getMethod(method, argTypes(args));
        return m.invoke(null, args);
    }

    private static Class<?>[] argTypes(Object[] args) {
        Class<?>[] types = new Class<?>[args.length];
        for (int i = 0; i < args.length; i += 1) {
            types[i] = args[i] == null ? Object.class : args[i].getClass();
        }
        return types;
    }
}
`
  const file = path.join(outputDir, `${className}.java`)
  await writeFile(file, content, "utf8")
  return file
}

function main(): void {
  const { outputDir, className, asset, target } = parseArgs(process.argv.slice(2))
  generate(outputDir, className, asset, target)
    .then((file) => console.log(`已生成 DEX 加密 Loader：${file}（assets/${asset} 加密 DEX → 运行期解密加载 ${target}——静态分析只见 Loader）`))
    .catch((error) => {
      console.error(`DEX 加密 Loader 生成失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
