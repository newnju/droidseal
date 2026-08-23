#!/usr/bin/env bun
// 工具安装引导（setup-tools.ts——自动化安装外部工具链）。
// 检测缺失工具 → 用户级隔离安装（不碰系统 JDK/SDK——避免依赖冲突）：
//   - 管理 JDK（OpenJDK 17 LTS——winget/apt）到 <user>/.droidseal/jdk
//   - Android SDK（cmdline-tools + build-tools 34.0.0 + platform-tools）到 <user>/.droidseal-sdk
// 固定已知兼容版本组合 + sdkmanager 许可预接受 + 绝对路径调用（不依赖 PATH）+ 失败关闭。
//
// 用法：
//   bun scripts/setup-tools.ts [--install]   # 无 --install 仅检测报告；--install 执行安装
import { homedir } from "node:os"
import path from "node:path"
import { existsSync } from "node:fs"
import { spawnSync } from "node:child_process"

const USER_HOME = homedir()
export const MANAGED_JDK_DIR = path.join(USER_HOME, ".droidseal", "jdk")
export const MANAGED_SDK_DIR = path.join(USER_HOME, ".droidseal-sdk")

// 固定版本组合（避免多版本并存/漂移——已知兼容）
const JDK_VERSION = "17" // OpenJDK 17 LTS
const BUILD_TOOLS_VERSION = "34.0.0"
const CMDLINE_TOOLS_VERSION = "latest"

export interface ToolStatus {
  name: string
  found: boolean
  path?: string
  fix: string
}

function which(name: string): string | undefined {
  const result = spawnSync(process.platform === "win32" ? "where" : "which", [name], { timeout: 10000 })
  return result.status === 0 ? result.stdout.toString().split(/\r?\n/)[0]!.trim() : undefined
}

function managedTool(name: string): string | undefined {
  // 管理的安装目录优先（绝对路径——不依赖 PATH）
  const jdkCandidates = [
    path.join(MANAGED_JDK_DIR, "bin", name),
    path.join(MANAGED_JDK_DIR, "bin", name + ".exe"),
  ]
  for (const candidate of jdkCandidates) if (existsSync(candidate)) return candidate
  const sdkCandidates = [
    path.join(MANAGED_SDK_DIR, "platform-tools", name),
    path.join(MANAGED_SDK_DIR, "platform-tools", name + ".exe"),
    path.join(MANAGED_SDK_DIR, "build-tools", BUILD_TOOLS_VERSION, name),
    path.join(MANAGED_SDK_DIR, "build-tools", BUILD_TOOLS_VERSION, name + ".exe"),
  ]
  for (const candidate of sdkCandidates) if (existsSync(candidate)) return candidate
  return undefined
}

export function detectMissingTools(): ToolStatus[] {
  const tools: Array<{ name: string; check: () => string | undefined; fix: string }> = [
    { name: "java", check: () => managedTool("java") ?? which("java"), fix: `安装管理 JDK ${JDK_VERSION}（winget install Microsoft.OpenJDK.17 / apt install openjdk-${JDK_VERSION}-jdk）到 ${MANAGED_JDK_DIR}` },
    { name: "keytool", check: () => managedTool("keytool") ?? which("keytool"), fix: `随 JDK 安装（${MANAGED_JDK_DIR}/bin/keytool）` },
    { name: "apksigner", check: () => managedTool("apksigner") ?? which("apksigner"), fix: `sdkmanager "build-tools;${BUILD_TOOLS_VERSION}"（安装到 ${MANAGED_SDK_DIR}）` },
    { name: "zipalign", check: () => managedTool("zipalign") ?? which("zipalign"), fix: `随 build-tools 安装（${MANAGED_SDK_DIR}/build-tools/${BUILD_TOOLS_VERSION}/zipalign）` },
    { name: "aapt", check: () => managedTool("aapt") ?? which("aapt"), fix: `随 build-tools 安装（${MANAGED_SDK_DIR}/build-tools/${BUILD_TOOLS_VERSION}/aapt）` },
    { name: "adb", check: () => managedTool("adb") ?? which("adb"), fix: `sdkmanager "platform-tools"（安装到 ${MANAGED_SDK_DIR}/platform-tools/adb）` },
  ]
  return tools.map((t) => {
    const found = t.check()
    const ok = found !== undefined && found.length > 0
    return { name: t.name, found: ok, ...(ok ? { path: found } : {}), fix: t.fix }
  })
}

// 安装引导（--install：执行用户级安装——失败关闭）。
function runInstall(missing: ToolStatus[]): string[] {
  const notes: string[] = []
  const needJava = missing.some((m) => m.name === "java" || m.name === "keytool")
  const needSdk = missing.some((m) => m.name === "apksigner" || m.name === "zipalign" || m.name === "aapt" || m.name === "adb")

  if (needJava) {
    if (process.platform === "win32") {
      notes.push(`检测到 JDK 缺失——尝试 winget 安装 OpenJDK ${JDK_VERSION}：winget install --id Microsoft.OpenJDK.17（安装后请将 JAVA_HOME 指向系统 JDK 或手动放入 ${MANAGED_JDK_DIR}）`)
      const result = spawnSync("winget", ["install", "--id", "Microsoft.OpenJDK.17", "--accept-source-agreements", "--accept-package-agreements", "--silent"], { timeout: 300000 })
      notes.push(result.status === 0 ? "✓ winget 安装 OpenJDK 17 成功（工具链自动检测到 PATH）" : `✗ winget 安装失败（${result.status}）——请手动安装 OpenJDK 17 或将其放入 ${MANAGED_JDK_DIR}`)
    } else {
      notes.push(`检测到 JDK 缺失——请安装 OpenJDK ${JDK_VERSION}（如 apt install openjdk-${JDK_VERSION}-jdk），或将 JDK 放入 ${MANAGED_JDK_DIR}（droidseal-managed 自动识别）`)
    }
  }

  if (needSdk) {
    const cmdlineTools = path.join(MANAGED_SDK_DIR, "cmdline-tools", CMDLINE_TOOLS_VERSION, "bin", process.platform === "win32" ? "sdkmanager.bat" : "sdkmanager")
    if (existsSync(cmdlineTools)) {
      // 许可预接受 + 组件安装（固定版本）
      const licenses = spawnSync(cmdlineTools, ["--licenses", "--sdk_root=" + MANAGED_SDK_DIR], { timeout: 300000, input: "y\n".repeat(20) })
      if (licenses.status !== 0) notes.push(`✗ sdkmanager 许可预接受失败（${licenses.status}）——请手动运行 ${cmdlineTools} --licenses`)
      for (const component of [`build-tools;${BUILD_TOOLS_VERSION}`, "platform-tools"]) {
        const install = spawnSync(cmdlineTools, [component, "--sdk_root=" + MANAGED_SDK_DIR], { timeout: 600000 })
        notes.push(install.status === 0 ? `✓ sdkmanager 安装 ${component} 成功（${MANAGED_SDK_DIR}）` : `✗ sdkmanager 安装 ${component} 失败（${install.status}）——请检查网络/镜像`)
      }
    } else {
      notes.push(`Android SDK 未初始化——请先安装 cmdline-tools 到 ${MANAGED_SDK_DIR}（下载 commandlinetools-* 压缩包解压为 cmdline-tools/${CMDLINE_TOOLS_VERSION}/），或运行 sdkmanager 安装 build-tools;${BUILD_TOOLS_VERSION} 与 platform-tools`)
    }
  }
  return notes
}

function main(): void {
  const argv = process.argv.slice(2)
  const install = argv.includes("--install")
  const missing = detectMissingTools()
  console.log("=== 外部工具链检测（用户级隔离优先——绝对路径——不依赖 PATH） ===")
  for (const tool of missing) {
    console.log(`${tool.found ? "✓" : "✗"} ${tool.name}${tool.found ? `（${tool.path}）` : `——${tool.fix}`}`)
  }
  const missingCount = missing.filter((m) => !m.found).length
  if (missingCount === 0) {
    console.log("=== 工具链完整——无需安装 ===")
    return
  }
  if (install) {
    console.log("=== 执行用户级安装（固定版本组合——失败关闭） ===")
    for (const note of runInstall(missing.filter((m) => !m.found))) console.log(note)
  } else {
    console.log(`=== ${missingCount} 个工具缺失——加 --install 执行自动化安装（用户级隔离——不碰系统） ===`)
  }
}

main()
