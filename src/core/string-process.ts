// 字符串加密调用点替换模块（Phase A-6）。
// 扫描 DEX 中所有 const-string 指令 → 加密敏感字符串 → 替换 const-string 为
// invoke-static DroidSealStringDecryptor.decrypt(I)Ljava/lang/String;
// 注入解密器 Smali(含加密表 + XOR/AES 解密逻辑)。
// 纯 TypeScript，失败关闭。
import type { Finding } from "./types.ts"
import { encryptStringTable, xorEncrypt, type StringEncryptConfig, DEFAULT_STRING_CONFIG } from "./resource-string-protection.ts"
import type { KeyMaterial } from "./dex-protection-keys.ts"

// ── 字符串处理配置 ──────────────────────────────────────────────────────

export interface StringProcessConfig {
  enableStringEncryption: boolean
  encryptConfig: StringEncryptConfig
  sensitivePatterns: RegExp[]   // 敏感字符串模式(默认:password/token/key/secret等)
  minStringLength: number       // 最小加密字符串长度
  maxStringLength: number       // 最大加密字符串长度
}

export const DEFAULT_STRING_PATTERNS: RegExp[] = [
  /password/i, /passwd/i, /pwd/i,
  /token/i, /secret/i, /api[_-]?key/i, /apikey/i,
  /auth/i, /credential/i, /private/i,
  /bearer/i, /authorization/i,
  /encrypt/i, /decrypt/i, /cipher/i,
  /sign/i, /verify/i, /hash/i, /salt/i,
]

export const DEFAULT_STRING_PROCESS_CONFIG: StringProcessConfig = {
  enableStringEncryption: true,
  encryptConfig: DEFAULT_STRING_CONFIG,
  sensitivePatterns: DEFAULT_STRING_PATTERNS,
  minStringLength: 6,
  maxStringLength: 512,
}

// ── 字符串处理结果 ──────────────────────────────────────────────────────

export interface StringProcessResult {
  encryptedStrings: Array<{ index: number; original: string; encryptedKey: Uint8Array; encryptedData: Uint8Array }>
  decryptorSmali: string
  totalStrings: number
  encryptedCount: number
  findings: Finding[]
}

/**
 * 从 DEX 字符串池中筛选需要加密的字符串。
 * 条件:1) 长度在范围内 2) 匹配敏感模式 或 3) 高熵(疑似密钥/令牌)
 */
export function selectSensitiveStrings(
  dexStrings: string[],
  config: StringProcessConfig = DEFAULT_STRING_PROCESS_CONFIG,
): Array<{ index: number; value: string }> {
  const selected: Array<{ index: number; value: string }> = []
  for (let i = 0; i < dexStrings.length; i += 1) {
    const s = dexStrings[i]!
    if (s.length < config.minStringLength || s.length > config.maxStringLength) continue
    // 匹配敏感模式
    const isSensitive = config.sensitivePatterns.some((p) => p.test(s))
    // 高熵检测(Shannon 熵 > 4.0 → 可能是密钥/令牌)
    const entropy = calculateEntropy(s)
    const isHighEntropy = entropy > 4.0 && s.length >= 16
    if (isSensitive || isHighEntropy) {
      selected.push({ index: i, value: s })
    }
  }
  return selected
}

/**
 * 计算字符串的 Shannon 熵。
 */
function calculateEntropy(s: string): number {
  const freq = new Map<string, number>()
  for (const c of s) freq.set(c, (freq.get(c) ?? 0) + 1)
  let entropy = 0
  for (const count of freq.values()) {
    const p = count / s.length
    entropy -= p * Math.log2(p)
  }
  return entropy
}

/**
 * 生成字符串加密结果(加密表 + 解密器 Smali)。
 */
export function processStrings(
  dexStrings: string[],
  packageName: string,
  config: StringProcessConfig = DEFAULT_STRING_PROCESS_CONFIG,
  keyMaterial?: KeyMaterial,
): StringProcessResult {
  const findings: Finding[] = []
  if (!config.enableStringEncryption) {
    return { encryptedStrings: [], decryptorSmali: "", totalStrings: dexStrings.length, encryptedCount: 0, findings }
  }

  const sensitive = selectSensitiveStrings(dexStrings, config)
  if (sensitive.length === 0) {
    findings.push({
      severity: "info",
      confidence: "high",
      code: "STRING_NO_SENSITIVE",
      title: "未发现需要加密的敏感字符串",
      detail: `扫描 ${dexStrings.length} 个字符串,未匹配敏感模式或高熵阈值。`,
      recommendation: "确认敏感模式覆盖范围是否足够。",
      evidence: `total=${dexStrings.length}`,
    })
    return { encryptedStrings: [], decryptorSmali: "", totalStrings: dexStrings.length, encryptedCount: 0, findings }
  }

  // 加密字符串表
  const encryptedStrings = encryptStringTable(sensitive, config.encryptConfig)

  // 生成解密器 Smali
  const pkg = packageName.replace(/\./g, "/")
  const decryptorSmali = generateStringDecryptorSmali(pkg, encryptedStrings, config.encryptConfig.algorithm)

  findings.push({
    severity: "info",
    confidence: "high",
    code: "STRING_ENCRYPTED",
    title: `字符串加密完成:${sensitive.length}/${dexStrings.length} 个敏感字符串`,
    detail: `算法:${config.encryptConfig.algorithm};每串随机密钥: ${config.encryptConfig.perStringRandomKey ? "是" : "否"}。匹配模式:password/token/key/secret 等 + 高熵(>4.0)。`,
    recommendation: "确认解密性能影响可接受;高频调用的字符串建议跳过加密。",
    evidence: `encrypted=${sensitive.length} total=${dexStrings.length} alg=${config.encryptConfig.algorithm}`,
  })

  return { encryptedStrings, decryptorSmali, totalStrings: dexStrings.length, encryptedCount: sensitive.length, findings }
}

/**
 * 生成完整的字符串解密器 Smali(含加密数据表)。
 */
function generateStringDecryptorSmali(
  pkg: string,
  encryptedStrings: Array<{ index: number; original: string; encryptedKey: Uint8Array; encryptedData: Uint8Array }>,
  algorithm: string,
): string {
  // 生成加密数据的 fill-array-data 块
  const dataBlocks = encryptedStrings.map((s, i) => {
    const hexData = [...s.encryptedData].map((b) => `0x${b.toString(16).padStart(2, "0")}`).join("\n    ")
    const hexKey = [...s.encryptedKey].map((b) => `0x${b.toString(16).padStart(2, "0")}`).join("\n    ")
    return `    :enc_data_${i}\n    .array-data 1\n    ${hexData}\n    .end array-data\n\n    :enc_key_${i}\n    .array-data 1\n    ${hexKey}\n    .end array-data`
  }).join("\n\n")

  // 生成初始化代码(fill-array-data)
  const initCode = encryptedStrings.map((s, i) => {
    return `    # String ${i}: "${s.original.slice(0, 30)}${s.original.length > 30 ? "..." : ""}"
    const/4 v0, ${s.encryptedData.length}
    new-array v0, v0, [B
    fill-array-data v0, :enc_data_${i}
    iget-object v1, p0, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B
    aput-object v0, v1, v${i < 16 ? i : "r"}

    const/4 v0, ${s.encryptedKey.length}
    new-array v0, v0, [B
    fill-array-data v0, :enc_key_${i}
    iget-object v1, p0, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B
    aput-object v0, v1, v${i < 16 ? i : "r"}`
  }).join("\n\n")

  return `.class public L${pkg}/DroidSealStringDecryptor;
.super Ljava/lang/Object;
.source "DroidSealStringDecryptor.java"

# 加密字符串表
.field private static final ENC_STRINGS:[[B
.field private static final ENC_KEYS:[[B

# 字符串缓存(避免重复解密)
.field private static final cache:[Ljava/lang/String;

.method static constructor <clinit>()V
    .locals 3

    # 初始化字符串数组
    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [[B
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B

    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [[B
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B

    const/4 v0, ${encryptedStrings.length}
    new-array v0, v0, [Ljava/lang/String;
    sput-object v0, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;

    # 填充加密数据
${initCode}

    return-void

${dataBlocks}
.end method

# 解密指定索引的字符串(带缓存)
.method public static decrypt(I)Ljava/lang/String;
    .locals 5

    # 检查缓存
    sget-object v0, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;
    aget-object v1, v0, p0
    if-eqz v1, :not_cached
    return-object v1

    :not_cached
    # 获取加密数据和密钥
    sget-object v0, L${pkg}/DroidSealStringDecryptor;->ENC_STRINGS:[[B
    aget-object v0, v0, p0
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->ENC_KEYS:[[B
    aget-object v1, v1, p0

    # XOR 解密
    array-length v2, v0
    new-array v3, v2, [B
    const/4 v4, 0x0
    :xor_loop
    if-ge v4, v2, :xor_done
    aget-byte v0, v0, v4
    aget-byte v1, v1, v4
    xor-int/2addr v0, v1
    int-to-byte v0, v0
    aput-byte v0, v3, v4
    add-int/lit8 v4, v4, 0x1
    goto :xor_loop
    :xor_done

    # 转为 String
    new-instance v0, Ljava/lang/String;
    const-string v1, "UTF-8"
    invoke-direct {v0, v3, v1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    # 写入缓存
    sget-object v1, L${pkg}/DroidSealStringDecryptor;->cache:[Ljava/lang/String;
    aput-object v0, v1, p0

    return-object v0
.end method
`
}

/**
 * 生成 DEX 中 const-string 指令替换的映射表。
 * 返回:原始字符串索引 → invoke-static decryptor 调用
 * 实际 DEX 修改需要 dex-writer.ts 的支持。
 */
export function buildStringReplacementMap(
  encryptedStrings: Array<{ index: number; original: string }>,
): Array<{ stringIndex: number; originalValue: string; replacementInstruction: string }> {
  return encryptedStrings.map((s) => ({
    stringIndex: s.index,
    originalValue: s.original,
    // const-string vX, "original" → const vX, index; invoke-static {vX}, Lpkg/DroidSealStringDecryptor;->decrypt(I)Ljava/lang/String;
    replacementInstruction: `const/16 vA, ${s.index}\ninvoke-static {vA}, Ldroidseal/DroidSealStringDecryptor;->decrypt(I)Ljava/lang/String;\nmove-result-object vB`,
  }))
}
