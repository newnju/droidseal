import path from "node:path"
import { mkdir, writeFile } from "node:fs/promises"
import type { Finding } from "./types.ts"

export interface RemediationArtifact {
  path: string
  purpose: string
  findingCodes: string[]
}

export interface RemediationBundle {
  directory: string
  plan: string
  artifacts: RemediationArtifact[]
}

const NETWORK_CODES = /(?:^NSC_|NETWORK_SECURITY_CONFIG|NETWORK_CONFIG)/
const BACKUP_CODES = /BACKUP/
const COMPONENT_CODES = /(?:EXPORTED_COMPONENT|EXPORTED_ACTIVITY|DEEPLINK|TASK_AFFINITY|PROVIDER_GRANT_URI)/
const SIGNING_MATERIAL_CODES = /^(?:SIGNING_PASSWORD_LITERAL_|SIGNING_KEYSTORE_)/
const R8_RULES_CODES = /(?:^R8_|PROGUARD)/
const MANIFEST_PERMISSION_CODES = /(?:^MANIFEST_|PERMISSION)/
const DEX_STRING_CODES = /(?:^DEX_HARDCODED_SECRET|^DEX_(?:WEAK_CRYPTO|UNSAFE_TLS|DYNAMIC_LOADING|RUNTIME_EXECUTION|WEBVIEW_JS_BRIDGE|WEAK_RANDOM))/
const SIGNING_MATERIAL_GUIDE = `# 发布签名材料处置清单

本文件只提供人工处置步骤，不会删除密钥、改写 Git 历史或覆盖项目配置。

1. 立即限制仓库、共享目录、CI 日志和备份的访问，保全审计证据。
2. 如果私钥文件及其密码可能同时暴露，按应用商店/发布渠道规则启动密钥轮换；已发布应用不要直接换成不兼容签名。
3. 将 keystore 移到仓库外的受控绝对路径或 CI 密钥服务，限制文件 ACL；密码只从 CI secret/环境变量注入。
4. 从当前工作树删除签名材料引用，并在 .gitignore 和 CI release check 中阻止再次提交。
5. 用 git log --all -- <path> 确认历史暴露。清理 Git 历史只能减少后续传播，不能撤销已经发生的泄露；执行前备份并协调所有协作者。
6. 轮换后重新构建，用 apksigner verify --verbose --print-certs 核对最终证书，再更新服务端/客户端允许的证书指纹与轮换集合。
`
const SIGNING_GITIGNORE = `# DroidSeal signing-material baseline
*.jks
*.keystore
*.p12
*.pfx
keystore.properties
key.properties
signing.properties
release-signing.properties
`

const R8_RULES_SUGGESTION = `# R8 / ProGuard 规则最小化建议

本文件只提供建议模板，需人工核对后合并到模块的 proguard-rules.pro 或 release 变体。

1. 优先恢复默认优化：避免 \`-dontobfuscate\`、\`-dontshrink\`、\`-dontoptimize\` 等整包关闭项。
2. 收窄宽 keep：把全局/整包 keep 收敛到具体类、接口或注解约束，只保留真正需要的成员。
3. 保留项用注解/继承约束：优先 \`@Keep\` 或注解类 keep，减少显式规则。
4. 缺失规则引用：为 release 变体补上被引用的规则文件（proguard-rules.pro 或 src/main/keepRules/）。
5. 复核映射：改动后用 release 构建的 mapping.txt 复核，确认混淆覆盖与保留面符合预期。
`

const MANIFEST_PERMISSION_SUGGESTION = `# Manifest 权限与导出组件最小化建议

本文件只提供人工核对清单，不自动改写 Manifest。

1. 权限：删除未使用的高风险权限（悬浮窗、安装未知应用、无障碍、管理全部存储、QUERY_ALL_PACKAGES 等），权限越少攻击面越小。
2. 导出组件：未暴露给其他应用的 activity/service/receiver 应设为 \`android:exported="false"\`。
3. 深链：http/https 深链如非公开用途，移除 \`autoVerify\` 或增加签名校验；BROWSABLE 导出且无权限的入口应加权限或收窄 intent-filter。
4. provider：导出 provider 授予 URI 权限时收紧 grantUriPermissions 与 exported，必要时加 path-permission。
5. 复核：改动后重新构建并用 APK 审计确认导出面与权限清单收敛。
`

const DEX_STRING_PLAN = `# DEX 字符串安全化计划

本文件提供敏感字符串的处置计划模板，需人工在源码侧实施（不事后改写 APK）。

1. 敏感字符串分类：密钥/令牌、API URL、内部路径、加密盐、WebView 桥接口名等。
2. 首选方案：把真实密钥/令牌移入服务端或在构建期注入，客户端不持有。
3. 源码侧加密接入：确需客户端持有的敏感串，用自研解密桩模式（参考 \`src/core/dex-string-crypto.ts\` 的加密/解密原语），在源码编译期加密、运行时解密，避免明文进入 DEX 字符串池。
4. 规避：不要把密钥/令牌以明文硬编码进 DEX 字符串池；弱加密/ECB 与不安全 TLS 配置应改用标准安全实现。
5. 复核：改动后重新构建，再用本工具的 DEX 审计确认字符串池中已无敏感明文。
`

const NETWORK_SECURITY_CONFIG = `<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- 安全默认：仅信任系统 CA，禁止明文流量。按业务域名最小化增加例外。 -->
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
`

const FULL_BACKUP_RULES = `<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <!-- 默认排除常见敏感域；确认业务需要后再按精确 path 放行。 -->
    <exclude domain="root" path="." />
    <exclude domain="file" path="." />
    <exclude domain="database" path="." />
    <exclude domain="sharedpref" path="." />
    <exclude domain="external" path="." />
</full-backup-content>
`

const DATA_EXTRACTION_RULES = `<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
    <cloud-backup disableIfNoEncryptionCapabilities="true">
        <exclude domain="root" path="." />
        <exclude domain="file" path="." />
        <exclude domain="database" path="." />
        <exclude domain="sharedpref" path="." />
        <exclude domain="external" path="." />
    </cloud-backup>
    <device-transfer>
        <exclude domain="root" path="." />
        <exclude domain="file" path="." />
        <exclude domain="database" path="." />
        <exclude domain="sharedpref" path="." />
        <exclude domain="external" path="." />
    </device-transfer>
</data-extraction-rules>
`

function manifestSnippet(includeNetwork: boolean, includeBackup: boolean): string {
  const attrs = [
    includeNetwork ? 'android:usesCleartextTraffic="false"' : undefined,
    includeNetwork ? 'android:networkSecurityConfig="@xml/network_security_config"' : undefined,
    includeBackup ? 'android:allowBackup="false"' : undefined,
  ].filter((value): value is string => value !== undefined)
  return `<?xml version="1.0" encoding="utf-8"?>
<!-- 将以下属性合并到现有 <application>；不要新增第二个 application 节点。 -->
<application xmlns:android="http://schemas.android.com/apk/res/android"
    ${attrs.join("\n    ")} />

<!-- 若业务必须允许备份，可把 allowBackup 改为 true，并同时使用：
     android:fullBackupContent="@xml/backup_rules"
     android:dataExtractionRules="@xml/data_extraction_rules"
     然后按数据分类收窄模板中的 exclude/include。 -->
`
}

export async function writeRemediationBundle(
  reportDirectory: string,
  findings: readonly Finding[],
): Promise<RemediationBundle | undefined> {
  if (findings.length === 0) return undefined
  const directory = path.join(reportDirectory, "remediation")
  await mkdir(directory, { recursive: true })

  const codes = [...new Set(findings.map((finding) => finding.code))]
  const networkCodes = codes.filter((code) => NETWORK_CODES.test(code))
  const backupCodes = codes.filter((code) => BACKUP_CODES.test(code))
  const componentCodes = codes.filter((code) => COMPONENT_CODES.test(code))
  const signingMaterialCodes = codes.filter((code) => SIGNING_MATERIAL_CODES.test(code))
  const r8Codes = codes.filter((code) => R8_RULES_CODES.test(code))
  const manifestCodes = codes.filter((code) => MANIFEST_PERMISSION_CODES.test(code))
  const dexStringCodes = codes.filter((code) => DEX_STRING_CODES.test(code))
  const artifacts: RemediationArtifact[] = []

  const writeArtifact = async (
    relativePath: string,
    content: string,
    purpose: string,
    findingCodes: string[],
  ): Promise<void> => {
    const target = path.join(directory, relativePath)
    await mkdir(path.dirname(target), { recursive: true })
    await writeFile(target, content, "utf8")
    artifacts.push({ path: relativePath.replaceAll("\\", "/"), purpose, findingCodes })
  }

  if (networkCodes.length > 0) {
    await writeArtifact(
      "templates/res/xml/network_security_config.xml",
      NETWORK_SECURITY_CONFIG,
      "禁止明文流量并仅信任系统 CA 的 Network Security Config 安全基线",
      networkCodes,
    )
  }
  if (backupCodes.length > 0) {
    await writeArtifact(
      "templates/res/xml/backup_rules.xml",
      FULL_BACKUP_RULES,
      "Android 11 及以下的默认拒绝备份规则模板",
      backupCodes,
    )
    await writeArtifact(
      "templates/res/xml/data_extraction_rules.xml",
      DATA_EXTRACTION_RULES,
      "Android 12+ 的默认拒绝云备份/设备迁移规则模板",
      backupCodes,
    )
  }
  if (signingMaterialCodes.length > 0) {
    await writeArtifact(
      "signing/signing-material-response.md",
      SIGNING_MATERIAL_GUIDE,
      "发布密钥隔离、事件响应、Git 历史清理与密钥轮换人工清单",
      signingMaterialCodes,
    )
    await writeArtifact(
      "signing/.gitignore.droidseal.example",
      SIGNING_GITIGNORE,
      "阻止常见签名密钥库和密码属性文件再次进入版本库的示例规则",
      signingMaterialCodes,
    )
  }
  if (r8Codes.length > 0) {
    const r8Findings = findings.filter((f) => r8Codes.includes(f.code))
    const specifics = r8Findings.map((f) => `- **${f.title}**：${f.detail}`).join("\n")
    await writeArtifact(
      "templates/proguard-rules.suggestion.md",
      `# R8 / ProGuard 规则优化建议（DroidSeal 审计发现）

## 本次审计发现

${specifics || "- 无具体项（审计不完整，见 R8_RULE_FILE_AUDIT_INCOMPLETE）"}

## 通用最小化指引

${R8_RULES_SUGGESTION}`,
      "R8/ProGuard 规则最小化建议（基于本次审计发现 + 通用最小化指引）",
      r8Codes,
    )
  }
  if (manifestCodes.length > 0) {
    await writeArtifact(
      "templates/manifest-permissions.suggestion.md",
      MANIFEST_PERMISSION_SUGGESTION,
      "Manifest 权限与导出组件最小化人工核对清单",
      manifestCodes,
    )
  }
  if (dexStringCodes.length > 0) {
    await writeArtifact(
      "templates/dex-string-security.plan.md",
      DEX_STRING_PLAN,
      "DEX 字符串安全化计划（敏感字符串分类、服务端化与源码侧解密桩接入）",
      dexStringCodes,
    )
  }
  if (networkCodes.length > 0 || backupCodes.length > 0) {
    await writeArtifact(
      "templates/AndroidManifest.application-snippet.xml",
      manifestSnippet(networkCodes.length > 0, backupCodes.length > 0),
      "需要人工合并到现有 application 节点的 Manifest 属性片段",
      [...networkCodes, ...backupCodes],
    )
  }

  const actions = findings.map((finding) => ({
    findingCode: finding.code,
    severity: finding.severity,
    confidence: finding.confidence ?? "confirmed",
    title: finding.title,
    recommendation: finding.recommendation,
    evidence: finding.evidence,
    automation:
      NETWORK_CODES.test(finding.code) || BACKUP_CODES.test(finding.code) || SIGNING_MATERIAL_CODES.test(finding.code)
        ? "template-generated"
        : "manual-review",
  }))
  const planPath = path.join(directory, "droidseal-remediation.json")
  await writeFile(planPath, `${JSON.stringify({
    schemaVersion: 1,
    generatedBy: "DroidSeal",
    mode: "reviewable-templates",
    safety: "Generated files never overwrite source files or patch an APK.",
    artifacts,
    actions,
  }, null, 2)}\n`, "utf8")

  const manualNotes = componentCodes.length > 0
    ? "\n## 组件修复\n\n组件导出、深链和 taskAffinity 依赖业务语义，未自动改写。机器可读计划已保留组件名/证据；请逐项收敛 exported、signature 权限和 Intent 参数白名单。\n"
    : ""
  await writeFile(path.join(directory, "README.md"), `# DroidSeal 修复包

本目录由报告步骤自动生成，**不会覆盖项目源码，也不会直接修改 APK**。把需要的模板复制到 Android app 模块，审核后再重新构建、审计和签名。

1. 将 \`templates/res/xml/\` 下的模板复制到 \`app/src/main/res/xml/\`。
2. 把 Manifest 片段中的属性合并到现有 \`<application>\`，不要创建第二个节点。
3. 按真实数据分类、域名和证书轮换策略收窄模板；默认模板有意采用“拒绝优先”。
4. 重新运行 DroidSeal，确认对应 finding code 消失。
${manualNotes}
完整动作与原始建议见 \`droidseal-remediation.json\`。
`, "utf8")

  return { directory, plan: planPath, artifacts }
}
