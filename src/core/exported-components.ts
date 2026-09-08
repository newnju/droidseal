// Manifest 导出组件全量解析 + Intent Filter + Deep Link 安全审计。
// 从 AXML 二进制 AndroidManifest.xml 解析所有组件声明,
// 提取 exported=true 的 Activity/Service/Receiver/Provider,
// 审计 Intent Filter(action/category/data scheme/host/path),
// 检测 Deep Link URI 劫持风险、无权限保护的导出组件、隐式导出。
// 纯 TypeScript,复用 axml-nsc 的 parseAxmlTree;失败关闭。
import { parseAxml } from "./axml-writer.ts"
import { parseAxmlTree, type AxmlElement } from "./axml-nsc.ts"
import type { Finding } from "./types.ts"

// android 属性名(AXML 中 namespace 已展开为 android:xxx)
const ATTR_EXPORTED = "android:exported"
const ATTR_PERMISSION = "android:permission"
const ATTR_READ_PERMISSION = "android:readPermission"
const ATTR_WRITE_PERMISSION = "android:writePermission"
const ATTR_NAME = "android:name"
const ATTR_AUTHORITIES = "android:authorities"
const ATTR_SCHEME = "android:scheme"
const ATTR_HOST = "android:host"
const ATTR_PATH = "android:path"
const ATTR_PATH_PREFIX = "android:pathPrefix"
const ATTR_PATH_PATTERN = "android:pathPattern"
const ATTR_TARGET_SDK = "android:targetSdkVersion"

type ComponentType = "activity" | "service" | "receiver" | "provider"

export interface IntentFilter {
  actions: string[]
  categories: string[]
  dataSchemes: string[]
  dataHosts: string[]
  dataPaths: string[]
}

export interface ExportedComponent {
  type: ComponentType
  name: string
  exported: boolean
  explicitExport: boolean // 是否显式声明 exported
  permission?: string | undefined
  readPermission?: string | undefined
  writePermission?: string | undefined
  intentFilters: IntentFilter[]
  hasDeepLink: boolean
  deepLinkUris: string[]
}

export interface ManifestAnalysis {
  packageName: string
  targetSdk: number
  components: ExportedComponent[]
  exportedCount: number
  unprotectedCount: number
  deepLinkCount: number
  findings: Finding[]
}

// 从 AxmlElement 提取属性值
function attr(el: AxmlElement, name: string): string | undefined {
  return el.attributes.find((a) => a.name === name)?.value
}

function attrBool(el: AxmlElement, name: string): boolean | undefined {
  const a = el.attributes.find((attr) => attr.name === name)
  if (!a) return undefined
  return a.data !== 0 || a.value === "true"
}

// 解析单个组件的 Intent Filter
function parseIntentFilters(component: AxmlElement): IntentFilter[] {
  const filters: IntentFilter[] = []
  for (const child of component.children) {
    if (child.tag !== "intent-filter") continue
    const filter: IntentFilter = { actions: [], categories: [], dataSchemes: [], dataHosts: [], dataPaths: [] }
    for (const fc of child.children) {
      if (fc.tag === "action") {
        const name = attr(fc, ATTR_NAME)
        if (name) filter.actions.push(name)
      } else if (fc.tag === "category") {
        const name = attr(fc, ATTR_NAME)
        if (name) filter.categories.push(name)
      } else if (fc.tag === "data") {
        const scheme = attr(fc, ATTR_SCHEME)
        const host = attr(fc, ATTR_HOST)
        const path = attr(fc, ATTR_PATH) ?? attr(fc, ATTR_PATH_PREFIX) ?? attr(fc, ATTR_PATH_PATTERN)
        if (scheme) filter.dataSchemes.push(scheme)
        if (host) filter.dataHosts.push(host)
        if (path) filter.dataPaths.push(path)
      }
    }
    filters.push(filter)
  }
  return filters
}

// 判断组件是否导出(显式 exported=true 或隐式:有 intent-filter 且无 exported 声明)
function isExported(component: AxmlElement, targetSdk: number): { exported: boolean; explicit: boolean } {
  const explicitExported = attrBool(component, ATTR_EXPORTED)
  if (explicitExported !== undefined) return { exported: explicitExported, explicit: true }
  // 隐式导出:有 intent-filter + targetSdk < 31(Android 12 默认 exported=false)
  const hasIntentFilter = component.children.some((c) => c.tag === "intent-filter")
  if (hasIntentFilter && targetSdk < 31) return { exported: true, explicit: false }
  return { exported: false, explicit: false }
}

// 构建 Deep Link URI
function buildDeepLinkUris(filter: IntentFilter): string[] {
  const uris: string[] = []
  const schemes = filter.dataSchemes.length > 0 ? filter.dataSchemes : ["content"]
  const hosts = filter.dataHosts
  const paths = filter.dataPaths
  for (const scheme of schemes) {
    if (hosts.length === 0) {
      if (["http", "https"].includes(scheme)) continue
      uris.push(`${scheme}://...`)
      continue
    }
    for (const host of hosts) {
      if (paths.length === 0) {
        uris.push(`${scheme}://${host}`)
      } else {
        for (const path of paths) {
          uris.push(`${scheme}://${host}${path}`)
        }
      }
    }
  }
  return uris
}

// 判断 Intent Filter 是否包含 Deep Link
function hasDeepLinkIntent(filter: IntentFilter): boolean {
  const deepSchemes = filter.dataSchemes.filter((s) => ["http", "https"].includes(s) || !["content", "file", "android.resource"].includes(s))
  return deepSchemes.length > 0 && (filter.dataHosts.length > 0 || filter.dataPaths.length > 0 || deepSchemes.some((s) => !["http", "https"].includes(s)))
}

// 解析 Manifest 的 package 和 targetSdkVersion
function parseManifestMeta(manifest: AxmlElement): { packageName: string; targetSdk: number } {
  const packageName = attr(manifest, "package") ?? ""
  let targetSdk = 0
  // targetSdkVersion 可能在 manifest 根属性或 uses-sdk 子元素
  const directTarget = attr(manifest, ATTR_TARGET_SDK)
  if (directTarget) { targetSdk = parseInt(directTarget, 10) || 0 }
  for (const child of manifest.children) {
    if (child.tag === "uses-sdk") {
      const ts = attr(child, ATTR_TARGET_SDK)
      if (ts) { targetSdk = parseInt(ts, 10) || 0; break }
    }
  }
  return { packageName, targetSdk }
}

// 从 AXML 树提取所有组件
function extractComponents(elements: AxmlElement[], targetSdk: number): ExportedComponent[] {
  const components: ExportedComponent[] = []
  const componentTags: Record<string, ComponentType> = {
    activity: "activity", "service": "service",
    receiver: "receiver", provider: "provider",
  }
  const walk = (els: AxmlElement[]): void => {
    for (const el of els) {
      const type = componentTags[el.tag]
      if (type) {
        const { exported, explicit } = isExported(el, targetSdk)
        const intentFilters = parseIntentFilters(el)
        const hasDl = intentFilters.some(hasDeepLinkIntent)
        const dlUris = intentFilters.filter(hasDeepLinkIntent).flatMap(buildDeepLinkUris)
        components.push({
          type,
          name: attr(el, ATTR_NAME) ?? "",
          exported,
          explicitExport: explicit,
          permission: attr(el, ATTR_PERMISSION),
          readPermission: attr(el, ATTR_READ_PERMISSION),
          writePermission: attr(el, ATTR_WRITE_PERMISSION),
          intentFilters,
          hasDeepLink: hasDl,
          deepLinkUris: dlUris,
        })
      }
      walk(el.children)
    }
  }
  walk(elements)
  return components
}

// 生成安全发现
function buildFindings(components: ExportedComponent[], targetSdk: number): Finding[] {
  const findings: Finding[] = []

  // 1. 无权限保护的导出组件
  const unprotected = components.filter((c) => c.exported && !c.permission && !c.readPermission && !c.writePermission)
  if (unprotected.length > 0) {
    const byType = (t: ComponentType) => unprotected.filter((c) => c.type === t)
    const details: string[] = []
    for (const t of ["activity", "service", "receiver", "provider"] as const) {
      const list = byType(t)
      if (list.length > 0) details.push(`${t}(${list.length}): ${list.slice(0, 5).map((c) => c.name.split(".").pop()).join(", ")}${list.length > 5 ? ` +${list.length - 5}` : ""}`)
    }
    findings.push({
      severity: "high",
      confidence: "high",
      code: "MANIFEST_EXPORTED_UNPROTECTED",
      title: `${unprotected.length} 个导出组件无权限保护`,
      detail: `导出组件可被任意应用调用/启动——${details.join("; ")}。`,
      recommendation: "非必要导出的组件应设置 android:exported=\"false\";需外部调用的组件应设置 android:permission 保护。",
      evidence: unprotected.slice(0, 10).map((c) => `${c.type}:${c.name}`).join(", "),
    })
  }

  // 2. 隐式导出(targetSdk<31 未显式声明 exported)
  const implicitExport = components.filter((c) => c.exported && !c.explicitExport)
  if (implicitExport.length > 0) {
    findings.push({
      severity: "medium",
      confidence: "high",
      code: "MANIFEST_IMPLICIT_EXPORT",
      title: `${implicitExport.length} 个组件隐式导出(targetSdk=${targetSdk}<31)`,
      detail: `Android 12+(targetSdk≥31)要求显式声明 exported;当前 targetSdk=${targetSdk},有 intent-filter 的组件默认导出——${implicitExport.slice(0, 5).map((c) => c.name.split(".").pop()).join(", ")}。`,
      recommendation: "升级 targetSdk≥31 并为每个组件显式声明 android:exported。",
      evidence: implicitExport.slice(0, 10).map((c) => `${c.type}:${c.name}`).join(", "),
    })
  }

  // 3. Deep Link URI 安全
  const deepLinkComponents = components.filter((c) => c.hasDeepLink && c.exported)
  for (const comp of deepLinkComponents) {
    const customScheme = comp.deepLinkUris.filter((u) => !u.startsWith("http://") && !u.startsWith("https://"))
    if (customScheme.length > 0) {
      findings.push({
        severity: "medium",
        confidence: "medium",
        code: "MANIFEST_DEEP_LINK_CUSTOM_SCHEME",
        title: `自定义 scheme Deep Link 可被劫持: ${comp.name.split(".").pop()}`,
        detail: `组件 ${comp.name} 注册了自定义 scheme Deep Link: ${customScheme.slice(0, 3).join(", ")}。自定义 scheme 无唯一性约束,恶意应用可注册相同 scheme 劫持 Intent。`,
        recommendation: "优先使用 HTTPS App Links(autoVerify);自定义 scheme 需校验来源(签名/包名)。",
        evidence: customScheme.join(", "),
      })
    }
  }

  // 4. 无权限保护的 ContentProvider(跨应用数据读取)
  const unprotectedProviders = components.filter((c) => c.type === "provider" && c.exported && !c.readPermission && !c.writePermission && !c.permission)
  if (unprotectedProviders.length > 0) {
    findings.push({
      severity: "high",
      confidence: "high",
      code: "MANIFEST_PROVIDER_UNPROTECTED",
      title: `${unprotectedProviders.length} 个 ContentProvider 无权限保护`,
      detail: `导出的 ContentProvider 可被任意应用查询/修改数据: ${unprotectedProviders.map((c) => c.name.split(".").pop()).join(", ")}。`,
      recommendation: "ContentProvider 应设置 readPermission/writePermission;或使用 signature 级权限。",
      evidence: unprotectedProviders.map((c) => `${c.name} authorities=${c.intentFilters.length}`).join("; "),
    })
  }

  // 5. 无权限保护的 BroadcastReceiver(可被任意应用发送广播)
  const unprotectedReceivers = components.filter((c) => c.type === "receiver" && c.exported && !c.permission)
  if (unprotectedReceivers.length > 0) {
    const hasPrivilegedActions = unprotectedReceivers.filter((r) =>
      r.intentFilters.some((f) => f.actions.some((a) =>
        /BOOT_COMPLETED|SMS_RECEIVED|PACKAGE_ADDED|CONNECTIVITY_CHANGE|LOCALE_CHANGED/.test(a)
      ))
    )
    if (hasPrivilegedActions.length > 0) {
      findings.push({
        severity: "medium",
        confidence: "medium",
        code: "MANIFEST_RECEIVER_SENSITIVE_ACTIONS",
        title: `${hasPrivilegedActions.length} 个 Receiver 监听敏感系统广播无权限保护`,
        detail: `Receiver 监听敏感广播(BOOT_COMPLETED/SMS_RECEIVED 等)且无权限保护,可被伪造广播触发: ${hasPrivilegedActions.map((r) => r.name.split(".").pop()).join(", ")}。`,
        recommendation: "敏感 Receiver 应设置 android:permission 或使用 LocalBroadcastManager。",
        evidence: hasPrivilegedActions.map((r) => `${r.name} actions=${r.intentFilters.flatMap((f) => f.actions).join(",")}`).join("; "),
      })
    }
  }

  return findings
}

// 主入口:从 AXML 二进制解析 AndroidManifest.xml
export function analyzeManifest(axmlBytes: Uint8Array): ManifestAnalysis {
  try {
    const model = parseAxml(axmlBytes)
    const tree = parseAxmlTree(model)
    if (tree.length === 0) return { packageName: "", targetSdk: 0, components: [], exportedCount: 0, unprotectedCount: 0, deepLinkCount: 0, findings: [] }

    // 找到 <manifest> 根元素
    const manifest = tree.find((el) => el.tag === "manifest") ?? tree[0]!
    const { packageName, targetSdk } = parseManifestMeta(manifest)
    const components = extractComponents(tree, targetSdk)
    const exportedCount = components.filter((c) => c.exported).length
    const unprotectedCount = components.filter((c) => c.exported && !c.permission && !c.readPermission && !c.writePermission).length
    const deepLinkCount = components.filter((c) => c.hasDeepLink).length
    const findings = buildFindings(components, targetSdk)

    return { packageName, targetSdk, components, exportedCount, unprotectedCount, deepLinkCount, findings }
  } catch {
    return { packageName: "", targetSdk: 0, components: [], exportedCount: 0, unprotectedCount: 0, deepLinkCount: 0, findings: [] }
  }
}

// 从组件清单提取 SBOM 级信息(第三方 SDK 组件)
export function extractSdkComponents(components: ExportedComponent[]): Array<{ name: string; type: ComponentType; package: string }> {
  const knownSdkPatterns = [
    { prefix: "com.google.android.gms.", name: "Google Play Services" },
    { prefix: "com.google.firebase.", name: "Google Firebase" },
    { prefix: "com.facebook.", name: "Facebook SDK" },
    { prefix: "com.facebook.login.", name: "Facebook Login" },
    { prefix: "com.twitter.sdk.", name: "Twitter SDK" },
    { prefix: "com.linecorp.linesdk.", name: "LINE SDK" },
    { prefix: "com.paypal.", name: "PayPal SDK" },
    { prefix: "com.stripe.", name: "Stripe SDK" },
    { prefix: "com.appsflyer.", name: "AppsFlyer" },
    { prefix: "com.adjust.sdk.", name: "Adjust SDK" },
    { prefix: "com.onesignal.", name: "OneSignal" },
    { prefix: "io.sentry.", name: "Sentry" },
    { prefix: "com.bugsnag.", name: "Bugsnag" },
    { prefix: "com.crashlytics.", name: "Crashlytics" },
    { prefix: "com.amplitude.", name: "Amplitude" },
    { prefix: "com.mixpanel.", name: "Mixpanel" },
    { prefix: "com.airbnb.lottie.", name: "Lottie" },
    { prefix: "com.bumptech.glide.", name: "Glide" },
  ]
  const results: Array<{ name: string; type: ComponentType; package: string }> = []
  for (const comp of components) {
    for (const sdk of knownSdkPatterns) {
      if (comp.name.startsWith(sdk.prefix)) {
        results.push({ name: sdk.name, type: comp.type, package: comp.name })
        break
      }
    }
  }
  return results
}
