import path from "node:path"
import type {
  BuildMode,
  CreateSigningConfig,
  InputKind,
  PipelineConfig,
  RunMode,
  SigningMode,
} from "../core/types.ts"
import { inputPathPlaceholder, keystorePathPlaceholder, t } from "./i18n.ts"

export type QuestionKind = "text" | "secret" | "choice"

export interface QuestionChoice {
  value: string
  label: string
  detail: string
  shortcut: string
}

export interface WizardQuestion {
  id: string
  kind: QuestionKind
  title: string
  prompt: string
  detail: string
  defaultValue?: string
  placeholder?: string
  choices?: QuestionChoice[]
}

export interface WizardDraft {
  runMode: RunMode
  inputKind?: InputKind
  inputPath: string
  gradleTask: string
  buildMode?: BuildMode
  explicitBuiltApkPath: string
  outputDirectory: string
  enableAlignment?: boolean
  enableWebAssetMinification?: boolean
  enableArscObfuscation?: boolean
  // 默认 false(经典模式):流水线结束清理中间 APK;true(测试学习模式)保留全部中间产物。
  keepIntermediates?: boolean
  signingMode?: SigningMode
  // Only meaningful when signingMode === "existing": when true, the user wants
  // to generate a fresh replacement keystore (换新密钥) instead of reusing the
  // existing one. buildPipelineConfig then emits a CreateSigningConfig.
  renewKey?: boolean
  keystorePath: string
  keyAlias: string
  storePassword: string
  keyPassword: string
  commonName: string
  organizationalUnit: string
  organization: string
  locality: string
  state: string
  country: string
  validityDays: number
  keyAlgorithm: "RSA" | "EC"
  // 加固选项
  enableHarden?: boolean
  enableDexEncryption?: boolean
  enableSoEncryption?: boolean
  enableResourceEncryption?: boolean
  enableStringEncryption?: boolean
  enableRuntimeProtection?: boolean
  enableVmProtection?: boolean
  enableSplitKey?: boolean
  enableTripleEntry?: boolean
  enableRandomNames?: boolean
  // Android Keystore 设备绑定:首次运行后密钥片段封存进硬件 Keystore,卸载/重装/换机即失效(可选)
  enableKeystoreBinding?: boolean
  hardenAlgorithm?: "aes-256-gcm" | "chacha20-poly1305"
  // 加固额外配置
  packageName?: string | undefined
  applicationClass?: string | undefined
  certSha256?: string | undefined
}

export function createDraft(runMode: RunMode): WizardDraft {
  return {
    runMode,
    inputPath: "",
    gradleTask: "assembleRelease",
    buildMode: "full",
    explicitBuiltApkPath: "",
    outputDirectory: "",
    keystorePath: "",
    keyAlias: "",
    storePassword: "",
    keyPassword: "",
    commonName: "",
    organizationalUnit: "",
    organization: "",
    locality: "",
    state: "",
    country: "CN",
    validityDays: 9_125,
    keyAlgorithm: "RSA",
    // 一键模式默认加固配置
    enableHarden: true,
    enableDexEncryption: true,
    enableSoEncryption: true,
    enableResourceEncryption: true,
    enableStringEncryption: true,
    enableRuntimeProtection: true,
    enableVmProtection: false,
    enableSplitKey: true,
    enableTripleEntry: true,
    enableRandomNames: true,
    enableKeystoreBinding: false,
    hardenAlgorithm: "aes-256-gcm",
  }
}

/**
 * 创建一键模式预填充 draft(跳过所有可选问题,仅需输入路径)。
 */
export function createOneClickDraft(inputPath: string): WizardDraft {
  const isApk = inputPath.toLowerCase().endsWith(".apk")
  return {
    runMode: "one-click",
    inputKind: isApk ? "apk" : "project",
    inputPath,
    gradleTask: "assembleRelease",
    buildMode: "full",
    explicitBuiltApkPath: "",
    outputDirectory: isApk ? "./droidseal-report" : "./build/droidseal-report",
    enableAlignment: true,
    enableWebAssetMinification: true,
    enableArscObfuscation: false,
    keepIntermediates: false,
    signingMode: "skip",
    renewKey: false,
    keystorePath: "",
    keyAlias: "",
    storePassword: "",
    keyPassword: "",
    commonName: "",
    organizationalUnit: "",
    organization: "",
    locality: "",
    state: "",
    country: "CN",
    validityDays: 9_125,
    keyAlgorithm: "RSA",
    // 加固默认配置
    enableHarden: isApk,
    enableDexEncryption: true,
    enableSoEncryption: true,
    enableResourceEncryption: true,
    enableStringEncryption: true,
    enableRuntimeProtection: true,
    enableVmProtection: false,
    enableSplitKey: true,
    enableTripleEntry: true,
    enableRandomNames: true,
    enableKeystoreBinding: false,
    hardenAlgorithm: "aes-256-gcm",
  }
}

/**
 * 一键模式:自动填充所有问题为默认值,返回所有已回答的 ID。
 */
export function autoAnswerAll(draft: WizardDraft): Set<string> {
  const answered = new Set<string>()
  for (const q of questionsFor(draft)) {
    answered.add(q.id)
  }
  return answered
}

function withoutOuterQuotes(value: string): string {
  const trimmed = value.trim()
  if (
    trimmed.length >= 2 &&
    ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
      (trimmed.startsWith("'") && trimmed.endsWith("'")))
  ) {
    return trimmed.slice(1, -1)
  }
  return trimmed
}

function outputDefault(draft: WizardDraft): string {
  if (!draft.inputPath) return path.resolve("droidseal-output")
  const input = path.resolve(draft.inputPath)
  return draft.inputKind === "apk"
    ? path.join(path.dirname(input), "droidseal-output")
    : path.join(input, "droidseal-output")
}

// 最终 APK 文件名以输入项目/APK 名称为基础（与 pipeline 的 artifactName 一致），
// 默认带 -sealed-signed 后缀；签名未通过验证时为 -sealed-unsigned。
function outputFileBase(draft: WizardDraft): string {
  if (!draft.inputPath) return "application"
  return (
    path.basename(draft.inputPath, path.extname(draft.inputPath)).replace(/[^\p{L}\p{N}._-]+/gu, "-") || "application"
  )
}

function keystoreDefault(draft: WizardDraft): string {
  return path.join(draft.outputDirectory || outputDefault(draft), "release-key.p12")
}

export function questionsFor(draft: WizardDraft): WizardQuestion[] {
  const questions: WizardQuestion[] = [
    {
      id: "inputKind",
      kind: "choice",
      title: t("wInputKindTitle"),
      prompt: t("wInputKindPrompt"),
      detail: t("wInputKindDetail"),
      choices: [
        { value: "apk", label: t("wChoiceApk"), detail: t("wChoiceApkDetail"), shortcut: "1" },
        { value: "project", label: t("wChoiceProject"), detail: t("wChoiceProjectDetail"), shortcut: "2" },
      ],
    },
    {
      id: "inputPath",
      kind: "text",
      title: draft.inputKind === "project" ? t("wInputPathTitleProject") : t("wInputPathTitleApk"),
      prompt:
        draft.inputKind === "project"
          ? t("wInputPathPromptProject")
          : t("wInputPathPromptApk"),
      detail: t("wInputPathDetail"),
      placeholder: inputPathPlaceholder(draft.inputKind ?? "apk"),
    },
  ]

  if (draft.inputKind === "project") {
    questions.push(
      {
        id: "gradleTask",
        kind: "text",
        title: t("wGradleTitle"),
        prompt: t("wGradlePrompt"),
        detail: t("wGradleDetail"),
        defaultValue: "assembleRelease",
      },
      {
        id: "buildMode",
        kind: "choice",
        title: t("wBuildModeTitle"),
        prompt: t("wBuildModePrompt"),
        detail: t("wBuildModeDetail"),
        choices: [
          { value: "full", label: t("wChoiceFull"), detail: t("wChoiceFullDetail"), shortcut: "1" },
          { value: "quick", label: t("wChoiceQuick"), detail: t("wChoiceQuickDetail"), shortcut: "2" },
        ],
      },
      {
        id: "explicitBuiltApkPath",
        kind: "text",
        title: t("wBuiltApkTitle"),
        prompt: t("wBuiltApkPrompt"),
        detail: t("wBuiltApkDetail"),
        defaultValue: "",
        placeholder: t("wBuiltApkPh"),
      },
    )
  }

  questions.push(
    {
      id: "outputDirectory",
      kind: "text",
      title: t("wOutputDirTitle"),
      prompt: t("wOutputDirPrompt"),
      detail: t("wOutputDirDetail").replaceAll("{file}", outputFileBase(draft)),
      defaultValue: outputDefault(draft),
    },
  )

  questions.push(
    {
      id: "enableAlignment",
      kind: "choice",
      title: t("wAlignTitle"),
      prompt: t("wAlignPrompt"),
      detail: t("wAlignDetail"),
      choices: [
        { value: "yes", label: t("wChoiceAlignYes"), detail: t("wChoiceAlignYesDetail"), shortcut: "1" },
        { value: "no", label: t("wChoiceAlignNo"), detail: t("wChoiceAlignNoDetail"), shortcut: "2" },
      ],
    },
    {
      id: "enableWebAssetMinification",
      kind: "choice",
      title: t("wWebTitle"),
      prompt: t("wWebPrompt"),
      detail: t("wWebDetail"),
      choices: [
        { value: "yes", label: t("wChoiceWebYes"), detail: t("wChoiceWebYesDetail"), shortcut: "1" },
        { value: "no", label: t("wChoiceWebNo"), detail: t("wChoiceWebNoDetail"), shortcut: "2" },
      ],
    },
    {
      id: "enableArscObfuscation",
      kind: "choice",
      title: t("wArscTitle"),
      prompt: t("wArscPrompt"),
      detail: t("wArscDetail"),
      choices: [
        { value: "no", label: t("wChoiceArscNo"), detail: t("wChoiceArscNoDetail"), shortcut: "1" },
        { value: "yes", label: t("wChoiceArscYes"), detail: t("wChoiceArscYesDetail"), shortcut: "2" },
      ],
    },
    {
      id: "signingMode",
      kind: "choice",
      title: t("wSigningTitle"),
      prompt: t("wSigningPrompt"),
      detail: t("wSigningDetail"),
      choices: [
        { value: "existing", label: t("wChoiceExisting"), detail: t("wChoiceExistingDetail"), shortcut: "1" },
        { value: "existing-renew", label: t("wChoiceRenew"), detail: t("wChoiceRenewDetail"), shortcut: "2" },
        { value: "create", label: t("wChoiceCreate"), detail: t("wChoiceCreateDetail"), shortcut: "3" },
        { value: "skip", label: t("wChoiceSkip"), detail: t("wChoiceSkipDetail"), shortcut: "4" },
      ],
    },
  )

  const isRenew = draft.signingMode === "existing" && draft.renewKey === true

  if (draft.signingMode && draft.signingMode !== "skip") {
    questions.push(
      {
        id: "keystorePath",
        kind: "text",
        title:
          isRenew
            ? t("wKeyPathTitleRenew")
            : draft.signingMode === "create"
              ? t("wKeyPathTitleCreate")
              : t("wKeyPathTitleExisting"),
        prompt:
          isRenew
            ? t("wKeyPathPromptRenew")
            : draft.signingMode === "create"
              ? t("wKeyPathPromptCreate")
              : t("wKeyPathPromptExisting"),
        detail:
          isRenew
            ? t("wKeyPathDetailRenew")
            : draft.signingMode === "create"
              ? t("wKeyPathDetailCreate")
              : t("wKeyPathDetailExisting"),
        ...((draft.signingMode === "create" || isRenew)
          ? { defaultValue: draft.keystorePath || keystoreDefault(draft) }
          : { placeholder: keystorePathPlaceholder() }),
      },
      {
        id: "keyAlias",
        kind: "text",
        title: isRenew ? t("wAliasTitleRenew") : t("wAliasTitlePlain"),
        prompt: isRenew
          ? t("wAliasPromptRenew")
          : t("wAliasPromptPlain"),
        detail: isRenew
          ? t("wAliasDetailRenew")
          : draft.signingMode === "existing"
            ? t("wAliasDetailExisting")
            : t("wAliasDetailPlain"),
      },
      {
        id: "storePassword",
        kind: "secret",
        title: isRenew ? t("wStorePassTitleRenew") : t("wStorePassTitlePlain"),
        prompt: t("wStorePassPrompt"),
        detail: isRenew
          ? t("wStorePassDetailRenew")
          : draft.signingMode === "create"
            ? t("wStorePassDetailCreate")
            : t("wStorePassDetailExisting"),
        placeholder: "••••••••",
      },
      {
        id: "keyPassword",
        kind: "secret",
        title: isRenew ? t("wKeyPassTitleRenew") : t("wKeyPassTitlePlain"),
        prompt: t("wKeyPassPrompt"),
        detail: isRenew
          ? t("wKeyPassDetailRenew")
          : t("wKeyPassDetailPlain"),
        defaultValue: "",
        placeholder: t("wKeyPassPh"),
      },
    )
  }

  if (draft.signingMode === "create" || isRenew) {
    questions.push(
      {
        id: "commonName",
        kind: "text",
        title: t("wCnTitle"),
        prompt: t("wCnPrompt"),
        detail: t("wCnDetail"),
        placeholder: t("wCnPh"),
      },
      {
        id: "organizationalUnit",
        kind: "text",
        title: t("wOuTitle"),
        prompt: t("wOuPrompt"),
        detail: t("wOuDetail"),
        defaultValue: "",
      },
      {
        id: "organization",
        kind: "text",
        title: t("wOrgTitle"),
        prompt: t("wOrgPrompt"),
        detail: t("wOrgDetail"),
        defaultValue: "",
      },
      {
        id: "locality",
        kind: "text",
        title: t("wLocTitle"),
        prompt: t("wLocPrompt"),
        detail: t("wLocDetail"),
        defaultValue: "",
      },
      {
        id: "state",
        kind: "text",
        title: t("wStateTitle"),
        prompt: t("wStatePrompt"),
        detail: t("wStateDetail"),
        defaultValue: "",
      },
      {
        id: "country",
        kind: "text",
        title: t("wCountryTitle"),
        prompt: t("wCountryPrompt"),
        detail: t("wCountryDetail"),
        defaultValue: "CN",
      },
      {
        id: "validityDays",
        kind: "text",
        title: t("wValidityTitle"),
        prompt: t("wValidityPrompt"),
        detail: t("wValidityDetail"),
        defaultValue: "9125",
      },
      {
        id: "keyAlgorithm",
        kind: "choice",
        title: t("wKeyAlgTitle"),
        prompt: t("wKeyAlgPrompt"),
        detail: t("wKeyAlgDetail"),
        choices: [
          { value: "RSA", label: t("wChoiceRsa"), detail: t("wChoiceRsaDetail"), shortcut: "1" },
          { value: "EC", label: t("wChoiceEc"), detail: t("wChoiceEcDetail"), shortcut: "2" },
        ],
      },
    )
  }

  // ── 加固选项(APK 模式才展示) ──
  if (draft.inputKind === "apk") {
    questions.push(
      {
        id: "enableHarden",
        kind: "choice",
        title: "加固保护",
        prompt: "是否对 APK 进行加固保护?(DEX 加密 + SO 加密 + 运行时保护)",
        detail: "加固会在审计完成后额外执行:方法抽取、DEX/SO/资源/字符串加密、三重入口壳加载器、运行时反调试。",
        choices: [
          { value: "yes", label: "是 — 审计+加固", detail: "先审计发现漏洞,再加固保护整个 APK", shortcut: "1" },
          { value: "no", label: "否 — 仅审计", detail: "只做安全审计,不修改 APK 结构", shortcut: "2" },
        ],
      },
    )
  }

  if (draft.enableHarden === true) {
    questions.push(
      {
        id: "enableDexEncryption",
        kind: "choice",
        title: "DEX 加密",
        prompt: "启用 DEX 加密?(方法抽取 + AES-256-GCM/ChaCha20 整体加密)",
        detail: "方法抽取挖空 CodeItem,整体加密保护 classes.dex。运行时通过壳 Application 解密。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "方法抽取 + 整体加密,抗静态分析最强", shortcut: "1" },
          { value: "no", label: "否", detail: "跳过 DEX 加密", shortcut: "2" },
        ],
      },
      {
        id: "enableSoEncryption",
        kind: "choice",
        title: "SO 加密",
        prompt: "启用 Native SO 加密?(AES-256-GCM 全文件 / RC4 段级)",
        detail: "加密 lib/ 目录下的 .so 文件,运行时通过 JNI 解密。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "全文件 AES-256-GCM + 段级 RC4 双模式", shortcut: "1" },
          { value: "no", label: "否", detail: "跳过 SO 加密", shortcut: "2" },
        ],
      },
      {
        id: "enableResourceEncryption",
        kind: "choice",
        title: "资源加密",
        prompt: "启用 assets/ 资源加密?(AES-256-GCM)",
        detail: "加密 assets/ 目录下的文件,运行时解密到缓存目录。",
        choices: [
          { value: "yes", label: "是", detail: "加密所有 assets 文件(跳过已加密和超大文件)", shortcut: "1" },
          { value: "no", label: "否", detail: "跳过资源加密", shortcut: "2" },
        ],
      },
      {
        id: "enableStringEncryption",
        kind: "choice",
        title: "字符串加密",
        prompt: "启用敏感字符串加密?(XOR/AES + 每串随机密钥)",
        detail: "扫描 DEX 字符串池中的敏感字符串(password/token/key/secret),加密后通过解密器还原。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "敏感模式匹配 + 高熵检测 + XOR 加密", shortcut: "1" },
          { value: "no", label: "否", detail: "跳过字符串加密", shortcut: "2" },
        ],
      },
      {
        id: "enableRuntimeProtection",
        kind: "choice",
        title: "运行时保护",
        prompt: "启用运行时保护?(反 Dump + 反 Frida + Timing-safe 签名 + Crash-on-detect)",
        detail: "注入运行时检测 Smali:反内存 Dump、反 Frida CRC、Timing-safe 签名比对、检测到攻击直接 crash。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "8 项运行时检测,可分别启用/禁用", shortcut: "1" },
          { value: "no", label: "否", detail: "跳过运行时保护", shortcut: "2" },
        ],
      },
      {
        id: "enableVmProtection",
        kind: "choice",
        title: "VMP 参考产物",
        prompt: "生成 VM 解释器参考产物?(仅写入输出目录,不注入 APK,不构成生效防护)",
        detail: "25 条 VM 操作码 + dispatch loop + 寄存器/栈模拟。性能影响较大,默认关闭。",
        choices: [
          { value: "no", label: "否(推荐)", detail: "跳过 VMP(性能影响较大)", shortcut: "1" },
          { value: "yes", label: "是", detail: "启用 VMP 虚拟机保护", shortcut: "2" },
        ],
      },
      {
        id: "enableSplitKey",
        kind: "choice",
        title: "Split-Key 混淆",
        prompt: "启用 Split-Key 密钥混淆?(密钥拆分两部分异或)",
        detail: "将加密密钥拆分为两部分异或存储,静态分析无法直接提取完整密钥。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "密钥拆分 + 编译时内联", shortcut: "1" },
          { value: "no", label: "否", detail: "密钥整体存储", shortcut: "2" },
        ],
      },
      {
        id: "enableTripleEntry",
        kind: "choice",
        title: "三重入口",
        prompt: "启用三重入口壳加载器?(AppComponentFactory > ContentProvider > Application)",
        detail: "三级入口兜底,兼容 Android 4.4~16。AppComponentFactory(Android 9+)为最早入口。",
        choices: [
          { value: "yes", label: "是(推荐)", detail: "三重入口兼容性最好", shortcut: "1" },
          { value: "no", label: "否", detail: "仅 Application 入口", shortcut: "2" },
        ],
      },
      {
        id: "enableRandomNames",
        kind: "choice",
        title: t("wizardRandomNamesTitle"),
        prompt: t("wizardRandomNamesPrompt"),
        detail: t("wizardRandomNamesDetail"),
        choices: [
          { value: "yes", label: t("wizardRandomNamesYes"), detail: t("wizardRandomNamesYesDetail"), shortcut: "1" },
          { value: "no", label: t("wizardRandomNamesNo"), detail: t("wizardRandomNamesNoDetail"), shortcut: "2" },
        ],
      },
      {
        id: "enableKeystoreBinding",
        kind: "choice",
        title: t("wizardKsBindTitle"),
        prompt: t("wizardKsBindPrompt"),
        detail: t("wizardKsBindDetail"),
        choices: [
          { value: "no", label: t("wizardKsBindNo"), detail: t("wizardKsBindNoDetail"), shortcut: "1" },
          { value: "yes", label: t("wizardKsBindYes"), detail: t("wizardKsBindYesDetail"), shortcut: "2" },
        ],
      },
      {
        id: "hardenAlgorithm",
        kind: "choice",
        title: "加密算法",
        prompt: "选择加固加密算法",
        detail: "AES-256-GCM 为标准选择;ChaCha20-Poly1305 在 ARM 设备上有硬件加速。",
        choices: [
          { value: "aes-256-gcm", label: "AES-256-GCM(推荐)", detail: "NIST 标准 AEAD,Android 原生支持", shortcut: "1" },
          { value: "chacha20-poly1305", label: "ChaCha20-Poly1305", detail: "ARM 硬件加速,移动端性能更优", shortcut: "2" },
        ],
      },
    )
  }

  return questions
}

export function nextQuestion(draft: WizardDraft, answered: ReadonlySet<string>): WizardQuestion | undefined {
  return questionsFor(draft).find((question) => !answered.has(question.id))
}

export function applyAnswer(
  draft: WizardDraft,
  question: WizardQuestion,
  rawValue: string,
): { draft: WizardDraft; displayValue: string } {
  const next = { ...draft }
  const defaulted = rawValue.trim() === "" && question.defaultValue !== undefined
    ? question.defaultValue
    : rawValue
  const value = question.kind === "secret" ? defaulted : withoutOuterQuotes(defaulted)

  switch (question.id) {
    case "inputKind":
      if (value !== "apk" && value !== "project") throw new Error(t("errInputKind"))
      next.inputKind = value
      break
    case "inputPath":
      if (!value) throw new Error(t("errInputPathEmpty"))
      next.inputPath = value
      break
    case "gradleTask":
      if (!/^[A-Za-z0-9_:.-]+$/.test(value)) throw new Error(t("errGradleChars"))
      if (
        draft.inputPath &&
        value.toLowerCase() === `${path.basename(path.resolve(draft.inputPath)).toLowerCase()}-release`
      ) {
        throw new Error(t("errGradleLooksName").replace("{value}", value))
      }
      next.gradleTask = value
      break
    case "buildMode":
      if (value !== "full" && value !== "quick") throw new Error(t("errBuildMode"))
      next.buildMode = value
      break
    case "explicitBuiltApkPath":
      if (value && path.extname(value).toLowerCase() !== ".apk") {
        throw new Error(t("errBuiltApkPath"))
      }
      next.explicitBuiltApkPath = value
      break
    case "outputDirectory":
      if (!value) throw new Error(t("errOutputDirEmpty"))
      next.outputDirectory = value
      break
    case "enableAlignment":
      if (value !== "yes" && value !== "no") throw new Error(t("errAlign"))
      next.enableAlignment = value === "yes"
      break
    case "enableWebAssetMinification":
      if (value !== "yes" && value !== "no") throw new Error(t("errWeb"))
      next.enableWebAssetMinification = value === "yes"
      break
    case "enableArscObfuscation":
      if (value !== "yes" && value !== "no") throw new Error(t("errArsc"))
      next.enableArscObfuscation = value === "yes"
      break
    case "signingMode":
      if (value !== "existing" && value !== "existing-renew" && value !== "create" && value !== "skip") {
        throw new Error(t("errSigningMode"))
      }
      // “换新密钥”作为“使用现有密钥”选项下的子选项：existing-renew 同时设置 renewKey。
      next.signingMode = value === "existing-renew" ? "existing" : value
      next.renewKey = value === "existing-renew"
      break
    case "keystorePath":
      if (!value) throw new Error(t("errKeyPathEmpty"))
      next.keystorePath = value
      break
    case "keyAlias":
      if (!value) throw new Error(t("errAliasEmpty"))
      next.keyAlias = value
      break
    case "storePassword":
      if (!value) throw new Error(t("errStorePassEmpty"))
      if (draft.signingMode === "create" && value.length < 6) throw new Error(t("errStorePassLen"))
      next.storePassword = value
      break
    case "keyPassword":
      next.keyPassword = value || draft.storePassword
      if (draft.signingMode === "create" && next.keyPassword.length < 6) {
        throw new Error(t("errKeyPassLen"))
      }
      break
    case "commonName":
      if (!value) throw new Error(t("errCnEmpty"))
      next.commonName = value
      break
    case "organizationalUnit":
      next.organizationalUnit = value
      break
    case "organization":
      next.organization = value
      break
    case "locality":
      next.locality = value
      break
    case "state":
      next.state = value
      break
    case "country":
      if (value && !/^[A-Za-z]{2}$/.test(value)) throw new Error(t("errCountry"))
      next.country = value.toUpperCase()
      break
    case "validityDays": {
      const days = Number(value)
      if (!Number.isInteger(days) || days < 365 || days > 36_500) {
        throw new Error(t("errValidity"))
      }
      next.validityDays = days
      break
    }
    case "keyAlgorithm":
      if (value !== "RSA" && value !== "EC") throw new Error(t("errKeyAlg"))
      next.keyAlgorithm = value
      break
    // ── 加固选项 ──
    case "enableHarden":
      next.enableHarden = value === "yes"
      break
    case "enableDexEncryption":
      next.enableDexEncryption = value === "yes"
      break
    case "enableSoEncryption":
      next.enableSoEncryption = value === "yes"
      break
    case "enableResourceEncryption":
      next.enableResourceEncryption = value === "yes"
      break
    case "enableStringEncryption":
      next.enableStringEncryption = value === "yes"
      break
    case "enableRuntimeProtection":
      next.enableRuntimeProtection = value === "yes"
      break
    case "enableVmProtection":
      next.enableVmProtection = value === "yes"
      break
    case "enableSplitKey":
      next.enableSplitKey = value === "yes"
      break
    case "enableTripleEntry":
      next.enableTripleEntry = value === "yes"
      break
    case "enableKeystoreBinding":
      next.enableKeystoreBinding = value === "yes"
      break
    case "enableRandomNames":
      next.enableRandomNames = value === "yes"
      break
    case "hardenAlgorithm":
      if (value !== "aes-256-gcm" && value !== "chacha20-poly1305") throw new Error("无效算法")
      next.hardenAlgorithm = value
      break
    default:
      throw new Error(t("errUnknownField").replace("{id}", question.id))
  }
  return {
    draft: next,
    displayValue: question.kind === "secret" ? t("displaySecret") : value || t("displayEmpty"),
  }
}

export function buildPipelineConfig(draft: WizardDraft): PipelineConfig {
  if (!draft.inputKind || draft.enableAlignment === undefined || draft.enableWebAssetMinification === undefined || draft.enableArscObfuscation === undefined || !draft.signingMode) {
    throw new Error(t("errWizardIncomplete"))
  }
  const protection: PipelineConfig["protection"] = { mode: "local-safe" }

  let signing: PipelineConfig["signing"]

  const createSigning = (overwrite: boolean): CreateSigningConfig => ({
    mode: "create",
    keystorePath: draft.keystorePath,
    keyAlias: draft.keyAlias,
    storePassword: draft.storePassword,
    keyPassword: draft.keyPassword || draft.storePassword,
    validityDays: draft.validityDays,
    keyAlgorithm: draft.keyAlgorithm,
    keySize: draft.keyAlgorithm === "RSA" ? 4_096 : 256,
    distinguishedName: {
      commonName: draft.commonName,
      organizationalUnit: draft.organizationalUnit,
      organization: draft.organization,
      locality: draft.locality,
      state: draft.state,
      country: draft.country,
    },
    overwrite,
  })

  const renewing = draft.signingMode === "existing" && draft.renewKey === true
  if (draft.signingMode === "skip") {
    signing = { mode: "skip" }
  } else if (draft.signingMode === "existing" && !renewing) {
    signing = {
      mode: "existing",
      keystorePath: draft.keystorePath,
      keyAlias: draft.keyAlias,
      storePassword: draft.storePassword,
      keyPassword: draft.keyPassword || draft.storePassword,
    }
  } else {
    // 生成新密钥，或在“使用现有密钥”下选择“换新密钥”（覆盖原文件）。
    signing = createSigning(renewing)
  }

  const config: PipelineConfig = {
    runMode: draft.runMode,
    inputKind: draft.inputKind,
    inputPath: path.resolve(draft.inputPath),
    outputDirectory: path.resolve(draft.outputDirectory),
    gradleTask: draft.gradleTask,
    buildMode: draft.buildMode ?? "full",
    enableAlignment: draft.enableAlignment,
    enableWebAssetMinification: draft.enableWebAssetMinification,
    enableArscObfuscation: draft.enableArscObfuscation,
    keepIntermediates: draft.keepIntermediates ?? false,
    signing,
    protection,
    // 加固选项(从 wizard draft 传入)
    ...(draft.enableHarden ? {
      enableHarden: true,
      enableDexEncryption: draft.enableDexEncryption ?? true,
      enableSoEncryption: draft.enableSoEncryption ?? true,
      enableResourceEncryption: draft.enableResourceEncryption ?? true,
      enableStringEncryption: draft.enableStringEncryption ?? true,
      enableRuntimeProtection: draft.enableRuntimeProtection ?? true,
      enableVmProtection: draft.enableVmProtection ?? false,
      enableSplitKey: draft.enableSplitKey ?? true,
      enableTripleEntry: draft.enableTripleEntry ?? true,
      enableRandomNames: draft.enableRandomNames ?? true,
      enableKeystoreBinding: draft.enableKeystoreBinding ?? false,
      hardenAlgorithm: draft.hardenAlgorithm ?? "aes-256-gcm",
    } : {}),
  }
  if (draft.explicitBuiltApkPath) config.explicitBuiltApkPath = draft.explicitBuiltApkPath
  return config
}

export function summaryLines(draft: WizardDraft): string[] {
  const signingSummary =
    draft.signingMode === "skip"
      ? t("sumSigningSkip")
      : draft.signingMode === "existing" && draft.renewKey
        ? t("sumSigningRenew")
        : draft.signingMode === "existing"
          ? t("sumSigningExisting")
          : t("sumSigningCreate")
  return [
    t("sumMode").replace("{mode}", draft.runMode === "one-click" ? t("sumOneClick") : t("sumGuided")),
    t("sumInput")
      .replace("{kind}", draft.inputKind === "project" ? t("sumInputKindProject") : t("sumInputKindApk"))
      .replace("{path}", draft.inputPath),
    ...(draft.inputKind === "project"
      ? [
          t("sumBuild")
            .replace("{task}", draft.gradleTask)
            .replace("{mode}", draft.buildMode === "quick" ? t("sumBuildQuick") : t("sumBuildFull")),
        ]
      : []),
    t("sumOutput").replace("{dir}", draft.outputDirectory),
    t("sumProtection"),
    t("sumAlign").replace("{value}", draft.enableAlignment ? t("sumAlignYes") : t("sumAlignNo")),
    t("sumWeb").replace("{value}", draft.enableWebAssetMinification ? t("sumWebYes") : t("sumWebNo")),
    t("sumArsc").replace("{value}", draft.enableArscObfuscation ? t("sumArscYes") : t("sumArscNo")),
    t("sumSigning").replace("{value}", signingSummary),
    ...(draft.signingMode && draft.signingMode !== "skip"
      ? [
          t("sumKeystore")
            .replace("{path}", draft.keystorePath)
            .replace("{note}", draft.signingMode === "existing" && draft.renewKey ? t("sumOverwriteNote") : ""),
          t("sumAlias").replace("{alias}", draft.keyAlias),
          t("sumPassword"),
        ]
      : []),
    // 加固摘要
    ...(draft.enableHarden ? [
      `加固: 启用 (${draft.hardenAlgorithm ?? "aes-256-gcm"})`,
      `  DEX: ${draft.enableDexEncryption !== false ? "✓" : "✗"}  SO: ${draft.enableSoEncryption !== false ? "✓" : "✗"}  资源: ${draft.enableResourceEncryption !== false ? "✓" : "✗"}  字符串: ${draft.enableStringEncryption !== false ? "✓" : "✗"}`,
      `  运行时: ${draft.enableRuntimeProtection !== false ? "✓" : "✗"}  VMP: ${draft.enableVmProtection ? "✓" : "✗"}  Split-Key: ${draft.enableSplitKey !== false ? "✓" : "✗"}  三重入口: ${draft.enableTripleEntry !== false ? "✓" : "✗"}`,
    ] : ["加固: 未启用(仅审计)"]),
  ]
}
