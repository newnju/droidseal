// Manifest 修改模块（Phase A-2）。
// 解析 AXML 二进制 AndroidManifest.xml → 注入壳 Application/ContentProvider/AppComponentFactory。
// 复用 axml-writer.ts 的 parseAxml + string pool 操作。
// 纯 TypeScript，失败关闭。
import { parseAxml, type AxmlModel } from "./axml-writer.ts"
import { parseAxmlTree, type AxmlElement, reconstructXml } from "./axml-nsc.ts"
import type { Finding } from "./types.ts"

// ── Manifest 组件注入 ──────────────────────────────────────────────────

export interface ManifestInjectConfig {
  packageName: string
  originalApplication: string       // 原始 Application 类名
  shellApplication: string          // 壳 Application 类名
  shellContentProvider: string      // 壳 ContentProvider 类名
  shellComponentFactory: string     // 壳 AppComponentFactory 类名
  shellSoName: string              // 壳 SO 名(如 libdroidseal.so)
  enableContentProvider: boolean    // 是否注入 ContentProvider(三重入口第二级)
  enableComponentFactory: boolean   // 是否注入 AppComponentFactory(三重入口第一级,Android 9+)
  targetSdkVersion: number          // 目标 SDK 版本
}

export interface ManifestInjectResult {
  modifiedManifest: Uint8Array
  originalApplication: string
  injectedComponents: string[]
  findings: Finding[]
}

/**
 * 从 AXML 二进制 Manifest 中提取包名和 Application 类名。
 */
export function extractManifestInfo(manifestBytes: Uint8Array): { packageName: string; applicationName: string; targetSdk: number; minSdk: number } {
  try {
    const model = parseAxml(manifestBytes)
    const tree = parseAxmlTree(model)
    const manifest = tree.find((el) => el.tag === "manifest") ?? tree[0]
    const packageName = manifest?.attributes.find((a) => a.name === "package")?.value ?? ""

    // 找到 <application> 元素
    let applicationName = ""
    const findApplication = (elements: AxmlElement[]): void => {
      for (const el of elements) {
        if (el.tag === "application") {
          applicationName = el.attributes.find((a) => a.name === "android:name")?.value ?? ""
          return
        }
        findApplication(el.children)
      }
    }
    findApplication(tree)

    // 提取 targetSdkVersion / minSdkVersion
    let targetSdk = 0
    let minSdk = 0
    const findSdk = (elements: AxmlElement[]): void => {
      for (const el of elements) {
        if (el.tag === "uses-sdk") {
          const ts = el.attributes.find((a) => a.name === "android:targetSdkVersion")?.value
          if (ts) targetSdk = parseInt(ts, 10) || 0
          const ms = el.attributes.find((a) => a.name === "android:minSdkVersion")?.value
          if (ms) minSdk = parseInt(ms, 10) || 0
          return
        }
        findSdk(el.children)
      }
    }
    findSdk(tree)

    return { packageName, applicationName, targetSdk, minSdk }
  } catch {
    return { packageName: "", applicationName: "", targetSdk: 0, minSdk: 0 }
  }
}

/**
 * 修改 Manifest XML 文本，注入壳组件。
 * 注意:此函数操作的是重建后的 XML 文本(非二进制 AXML)。
 * 实际 APK 中的 Manifest 是二进制 AXML 格式——修改后需通过 aapt2 重新编译。
 */
export function injectShellComponents(xml: string, config: ManifestInjectConfig): { xml: string; injected: string[] } {
  const injected: string[] = []
  let modified = xml

  // 1. 替换 Application 类名
  const appRegex = /android:name\s*=\s*["']([^"']+)["']/
  if (appRegex.test(modified)) {
    modified = modified.replace(appRegex, `android:name="${config.shellApplication}"`)
    injected.push(`Application: ${config.originalApplication} → ${config.shellApplication}`)
  } else {
    // 没有 android:name 属性,在 <application> 标签中添加
    modified = modified.replace(
      /<application(\s)/,
      `<application android:name="${config.shellApplication}"$1`,
    )
    injected.push(`Application: (新增) ${config.shellApplication}`)
  }

  // 2. 注入 ContentProvider(三重入口第二级)
  if (config.enableContentProvider) {
    const providerXml = `    <provider
        android:name="${config.shellContentProvider}"
        android:authorities="${config.packageName}.droidseal.provider"
        android:exported="false"
        android:enabled="true" />`
    // 在 </application> 前插入
    modified = modified.replace(/<\/application>/, `${providerXml}\n</application>`)
    injected.push(`ContentProvider: ${config.shellContentProvider}`)
  }

  // 3. 注入 AppComponentFactory(三重入口第一级,Android 9+)
  if (config.enableComponentFactory && config.targetSdkVersion >= 28) {
    // 检查是否已有 appComponentFactory
    if (!/appComponentFactory/.test(modified)) {
      modified = modified.replace(
        /<application(\s)/,
        `<application android:appComponentFactory="${config.shellComponentFactory}"$1`,
      )
      injected.push(`AppComponentFactory: ${config.shellComponentFactory}`)
    }
  }

  // 4. 注入原始 Application 类名 meta-data(壳 ShellApplication.attachBaseContext 读取)
  if (config.originalApplication && config.originalApplication !== "android.app.Application") {
    if (!/droidseal\.original_app/.test(modified)) {
      modified = modified.replace(
        /<\/application>/,
        `    <meta-data android:name="droidseal.original_app" android:value="${config.originalApplication}" />\n` +
        `    <meta-data android:name="droidseal.shell_so" android:value="${config.shellSoName.replace(/^lib/, "").replace(/\.so$/, "")}" />\n</application>`,
      )
      injected.push(`Meta-data: droidseal.original_app = ${config.originalApplication}`)
    }
  }

  // 5. 添加 extractNativeLibs="true"(SO 解密需要)
  if (!/extractNativeLibs/.test(modified)) {
    modified = modified.replace(
      /<application(\s)/,
      `<application android:extractNativeLibs="true"$1`,
    )
  }

  return { xml: modified, injected }
}

/**
 * 生成 Manifest 修改的 Finding。
 */
export function buildManifestInjectFindings(config: ManifestInjectConfig, injected: string[]): Finding[] {
  if (injected.length === 0) return []
  return [{
    severity: "info",
    confidence: "high",
    code: "MANIFEST_INJECTED",
    title: `Manifest 注入完成:${injected.length} 个壳组件`,
    detail: `注入:${injected.join("; ")}。原始 Application: ${config.originalApplication}。`,
    recommendation: "确认壳组件类名不与应用已有类名冲突;三重入口兼容 Android 4.4~16。",
    evidence: injected.join(", "),
  }]
}
