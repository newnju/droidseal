import { describe, expect, test } from "bun:test"
import { readFile } from "node:fs/promises"
import path from "node:path"
import { minify } from "terser"

const projectRoot = path.resolve(import.meta.dir, "..")

describe("release bundle hardening", () => {
  test("publishes a Windows x64 executable without DroidSeal source files", async () => {
    const packageJson = JSON.parse(
      await readFile(path.join(projectRoot, "package.json"), "utf8"),
    ) as {
      bin?: { droidseal?: string }
      files?: string[]
      dependencies?: Record<string, string>
      devDependencies?: { terser?: string }
      engines?: Record<string, string>
      os?: string[]
      cpu?: string[]
    }
    const buildScript = await readFile(path.join(projectRoot, "scripts/build.ts"), "utf8")
    const launcher = await readFile(path.join(projectRoot, "bin/droidseal.cjs"), "utf8")

    expect(packageJson.bin?.droidseal).toBe("./bin/droidseal.cjs")
    // 精确窄列发布:只发布确定的构建产物,不整目录发布(比含 "dist" 更严格)
    expect(packageJson.files).toContain("dist/droidseal.mjs")
    expect(packageJson.files).toContain("bin/droidseal.cjs")
    // 双 DEX 产物必须随包发布(loader + stub 缺一不可)
    expect(packageJson.files).toContain("runtime/droidseal-loader.dex")
    expect(packageJson.files).toContain("runtime/droidseal-stub.dex")
    expect(packageJson.files).not.toContain("src")
    expect(packageJson.files).not.toContain("scripts")
    expect(packageJson.files).not.toContain("docs")
    expect(packageJson.files).not.toContain("dist")
    expect(packageJson.dependencies).toBeUndefined()
    expect(packageJson.devDependencies?.terser).toBe("5.49.0")
    expect(packageJson.engines?.node).toBe(">=18")
    expect(packageJson.os).toEqual(["win32", "linux"])
    expect(packageJson.cpu).toEqual(["x64"])

    expect(buildScript).toContain('sourcemap: "none"')
    expect(buildScript).toMatch(/mangle:\s*\{\s*toplevel:\s*true/)
    expect(buildScript).toContain("sourceMap: false")
    expect(buildScript).toContain('"--compile"')
    expect(buildScript).toContain('"--no-compile-autoload-dotenv"')
    expect(buildScript).toContain("droidseal.exe")
    expect(buildScript).toContain("sourceIncluded: false")
    // OpenTUI 原生资产根指向可执行文件目录(prelude 注入)
    expect(buildScript).toContain("OTUI_ASSET_ROOT")

    expect(launcher).toContain("metadata.artifact.sha256")
    expect(launcher).toContain("createHash")
    // launcher 不 spawn 子进程:哈希校验通过后以当前进程动态 import bundle
    expect(launcher).toContain("await import(")
    expect(launcher).not.toContain("spawnSync")
  })

  test("keeps license notices while mangling representative top-level names", async () => {
    const result = await minify(
      "/*! @license fixture */ function readableInternalIdentifier(){return 42} console.log(readableInternalIdentifier())",
      {
        ecma: 2022,
        module: true,
        compress: { passes: 2, unsafe: false },
        mangle: { toplevel: true },
        format: { comments: /@license|@preserve|^!/i },
        sourceMap: false,
      },
    )

    expect(result.code).toContain("@license fixture")
    expect(result.code).not.toContain("readableInternalIdentifier")
    expect(result.code).not.toContain("sourceMappingURL")
  })
})