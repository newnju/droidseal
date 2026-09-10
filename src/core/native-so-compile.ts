// Native SO 自动编译模块（P1-8）。
// 检测 NDK/cmake 可用性，自动编译壳 SO 为 .so 文件。
// 支持 Windows/Linux/macOS；NDK 不可用时提供降级方案（Smali 层替代）。
// 纯 TypeScript，失败关闭。
import { spawnSync } from "node:child_process"
import { writeFile, readFile, mkdir, rm, readdir, stat } from "node:fs/promises"
import { readdirSync, existsSync } from "node:fs"
import path from "node:path"
import type { Finding } from "./types.ts"

// ── NDK 检测 ──────────────────────────────────────────────────────

function findNdk(): { ndkRoot: string; cmakeBin: string; ndkBuild: string } | undefined {
  const candidates = [
    process.env.ANDROID_NDK_HOME,
    process.env.NDK_HOME,
    process.env.ANDROID_HOME ? path.join(process.env.ANDROID_HOME, "ndk") : undefined,
    path.join(process.env.HOME ?? "", "Android", "Sdk", "ndk"),
    path.join(process.env.HOME ?? "", "Library", "Android", "sdk", "ndk"),
    "C:\\Users\\diamond\\AppData\\Local\\Android\\Sdk\\ndk",
  ].filter(Boolean) as string[]

  for (const dir of candidates) {
    try {
      const entries = readdirSync(dir)
      const sorted = entries.sort().reverse()
      for (const entry of sorted) {
        const ndkRoot = path.join(dir, entry)
        const cmakeBin = path.join(ndkRoot, "cmake", "bin", "cmake")
        const ndkBuild = path.join(ndkRoot, "ndk-build")
        const cmakeExe = process.platform === "win32" ? cmakeBin + ".exe" : cmakeBin
        const ndkBuildExe = process.platform === "win32" ? ndkBuild + ".cmd" : ndkBuild
        if (existsSync(cmakeExe) || existsSync(ndkBuildExe)) {
          return { ndkRoot, cmakeBin: cmakeExe, ndkBuild: ndkBuildExe }
        }
      }
    } catch { continue }
  }
  return undefined
}

// ── SO 编译 ──────────────────────────────────────────────────────

export interface CompileSoConfig {
  packageName: string
  soName: string
  sourceDir: string
  outputDir: string
  abi: string[]
  ndkRoot?: string
  minSdk?: number
}

export interface CompileSoResult {
  success: boolean
  soFiles: Array<{ abi: string; path: string; size: number }>
  method: "ndk-build" | "cmake" | "none"
  findings: Finding[]
}

/**
 * 编译 C 源文件为 .so（支持多 ABI）。
 */
export async function compileNativeSo(config: CompileSoConfig): Promise<CompileSoResult> {
  const findings: Finding[] = []
  const ndk = config.ndkRoot ? { ndkRoot: config.ndkRoot, cmakeBin: "cmake", ndkBuild: "ndk-build" } : findNdk()
  const abis = config.abi.length > 0 ? config.abi : ["arm64-v8a", "armeabi-v7a", "x86_64", "x86"]
  const minSdk = config.minSdk ?? 21

  if (!ndk) {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "NDK_NOT_FOUND",
      title: "Android NDK 未找到，无法自动编译 Native SO",
      detail: "检测 ANDROID_NDK_HOME/ANDROID_HOME/常见路径均未找到 NDK。壳 SO 的 C 源文件已生成，需手动编译。",
      recommendation: `安装 NDK: sdkmanager "ndk;latest"。或手动编译:\n  cd ${config.sourceDir}\n  cmake -DCMAKE_TOOLCHAIN_FILE=<ndk>/build/cmake/android.toolchain.cmake -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-${minSdk} -B build && cmake --build build`,
      evidence: "ANDROID_NDK_HOME not set",
    })
    return { success: false, soFiles: [], method: "none", findings }
  }

  const soFiles: Array<{ abi: string; path: string; size: number }> = []

  // 逐 ABI 编译
  for (const abi of abis) {
    const buildDir = path.join(config.outputDir, `build-${abi}`)
    const outputSo = path.join(config.outputDir, "lib", abi, config.soName)

    await mkdir(path.dirname(outputSo), { recursive: true })
    await mkdir(buildDir, { recursive: true })

    // CMake 构建
    const cmakeArgs = [
      `-DCMAKE_TOOLCHAIN_FILE=${path.join(ndk.ndkRoot, "build", "cmake", "android.toolchain.cmake")}`,
      `-DANDROID_ABI=${abi}`,
      `-DANDROID_PLATFORM=android-${minSdk}`,
      `-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${path.dirname(outputSo)}`,
      `-B`, buildDir,
      config.sourceDir,
    ]

    const cmakeResult = spawnSync(ndk.cmakeBin, cmakeArgs, {
      timeout: 120000,
      stdio: "pipe",
      cwd: config.sourceDir,
    })

    if (cmakeResult.status !== 0) {
      findings.push({
        severity: "high",
        confidence: "high",
        code: "SO_COMPILE_CMAKE_FAILED",
        title: `CMake 配置失败(${abi})`,
        detail: cmakeResult.stderr?.toString().slice(0, 500) ?? "未知错误",
        recommendation: "检查 CMakeLists.txt 语法；确认 NDK 版本兼容。",
        evidence: cmakeResult.stderr?.toString().slice(0, 200) ?? "",
      })
      continue
    }

    // cmake --build
    const buildResult = spawnSync(ndk.cmakeBin, ["--build", buildDir, "--config", "Release"], {
      timeout: 120000,
      stdio: "pipe",
    })

    if (buildResult.status !== 0) {
      findings.push({
        severity: "high",
        confidence: "high",
        code: "SO_COMPILE_BUILD_FAILED",
        title: `编译失败(${abi})`,
        detail: buildResult.stderr?.toString().slice(0, 500) ?? "未知错误",
        recommendation: "检查 C 代码语法；确认 NDK 工具链完整。",
        evidence: buildResult.stderr?.toString().slice(0, 200) ?? "",
      })
      continue
    }

    // 检查输出 .so
    try {
      const soStat = await stat(outputSo)
      soFiles.push({ abi, path: outputSo, size: soStat.size })
    } catch {
      findings.push({
        severity: "high",
        confidence: "high",
        code: "SO_COMPILE_OUTPUT_MISSING",
        title: `编译输出 .so 不存在(${abi})`,
        detail: `预期路径: ${outputSo}`,
        recommendation: "检查 CMakeLists.txt 的输出路径配置。",
        evidence: outputSo,
      })
    }
  }

  if (soFiles.length > 0) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "SO_COMPILED",
      title: `Native SO 编译完成:${soFiles.length}/${abis.length} 个 ABI`,
      detail: soFiles.map((s) => `${s.abi}: ${s.path} (${(s.size / 1024).toFixed(1)} KB)`).join("; "),
      recommendation: "确认 .so 可在目标设备上加载；如需符号剥离，编译时加 -DCMAKE_BUILD_TYPE=Release。",
      evidence: soFiles.map((s) => `${s.abi}=${(s.size / 1024).toFixed(0)}KB`).join(","),
    })
  }

  return { success: soFiles.length > 0, soFiles, method: "cmake", findings }
}

/**
 * 生成 CMakeLists.txt（针对壳 SO 优化）。
 */
export function generateCmakeListsForShell(soName: string, packageName: string): string {
  return `cmake_minimum_required(VERSION 3.18)
project(droidseal-shell C)

set(CMAKE_C_STANDARD 11)

# 壳 SO 源文件
add_library(${soName.replace("lib", "").replace(".so", "")} SHARED
    crc32.c
    art_hook.c
)

# Android 日志库
find_library(log-lib log)
target_link_libraries(${soName.replace("lib", "").replace(".so", "")} \${log-lib})

# 安全编译选项（反逆向强化）
target_compile_options(${soName.replace("lib", "").replace(".so", "")} PRIVATE
    -fstack-protector-strong
    -D_FORTIFY_SOURCE=2
    -O2
    -fPIC
    -fvisibility=hidden
    -Wformat-security
    -Werror=format-security
)

# Strip release（去除符号表）
set_target_properties(${soName.replace("lib", "").replace(".so", "")} PROPERTIES
    C_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN ON
)
`
}
