import path from "node:path"
import { fileURLToPath } from "node:url"
import { mkdir, readFile, stat, writeFile } from "node:fs/promises"

// Opt-in, build-time anti-debug stub scaffolder. Copies the self-developed JNI
// detection unit (C + CMake + Kotlin) into a target Android app module. The stub
// is linked at build time by the developer; DroidSeal never injects it into a
// finished APK. Detection only — the app owns the response policy.

export interface StubFile {
  asset: string
  destination: string
}

export const ANTIDEBUG_STUB_FILES: readonly StubFile[] = [
  { asset: "droidseal_antidebug.c", destination: "src/main/cpp/droidseal_antidebug.c" },
  { asset: "CMakeLists.txt", destination: "src/main/cpp/CMakeLists.txt" },
  { asset: "DroidSealAntiDebug.kt", destination: "src/main/java/com/droidseal/antidebug/DroidSealAntiDebug.kt" },
  { asset: "INTEGRATION.md", destination: "droidseal-antidebug/INTEGRATION.md" },
] as const

function assetsRoot(): string {
  // Bun/Node 通用:import.meta.dir 仅 Bun 可用
  const moduleDir = path.dirname(fileURLToPath(import.meta.url))
  return path.join(moduleDir, "..", "assets", "antidebug-stub")
}

export interface InstallStubResult {
  moduleDir: string
  written: string[]
  skipped: string[]
}

// Non-destructive by default: existing files are reported in `skipped` unless
// `force` is set. Throws if the target module directory does not exist.
export async function installAntiDebugStub(
  moduleDir: string,
  options: { force?: boolean } = {},
): Promise<InstallStubResult> {
  const resolved = path.resolve(moduleDir)
  const info = await stat(resolved).catch(() => undefined)
  if (!info?.isDirectory()) {
    throw new Error(`目标模块目录不存在或不是目录：${resolved}`)
  }

  const root = assetsRoot()
  const written: string[] = []
  const skipped: string[] = []

  for (const file of ANTIDEBUG_STUB_FILES) {
    const source = path.join(root, file.asset)
    const target = path.join(resolved, file.destination)
    const exists = await stat(target).then(() => true, () => false)
    if (exists && !options.force) {
      skipped.push(file.destination)
      continue
    }
    await mkdir(path.dirname(target), { recursive: true })
    await writeFile(target, await readFile(source))
    written.push(file.destination)
  }

  return { moduleDir: resolved, written, skipped }
}
