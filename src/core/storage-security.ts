// 证书固定缺失 + 明文存储审计（MobSF 剩余缺口——源码模式，失败关闭）。
// 检测：网络库使用但未检测到证书固定（pinning）特征；SQLite 使用但未检测到 SQLCipher 加密。
// 均为低置信度清单提示（静态无法证明缺失——提示评估），未命中不输出。
import { readFile, readdir } from "node:fs/promises"
import path from "node:path"
import type { Finding } from "./types.ts"

interface StorageSecurityPattern {
  code: string
  title: string
  trigger: RegExp
  missing: RegExp[]
  recommendation: string
}

const PATTERNS: readonly StorageSecurityPattern[] = [
  {
    code: "SOURCE_NO_CERT_PINNING",
    title: "未检测到证书固定（SSL pinning）配置",
    trigger: /okhttpclient|http(s)?urlconnection|retrofit/i,
    missing: [/certificatepinner/i, /trustmanager/i, /networksecurityconfig/i],
    recommendation: "评估关键端点启用证书固定（OkHttp CertificatePinner / NetworkSecurityConfig），降低中间人风险。",
  },
  {
    code: "SOURCE_UNENCRYPTED_STORAGE",
    title: "SQLite 数据库明文存储（未检测到 SQLCipher）",
    trigger: /sqldatabase|openordatabase/i,
    missing: [/net\.zetetic|sqlcipher/i],
    recommendation: "敏感数据建议 SQLCipher 加密或服务端存储；至少核对库文件是否含敏感明文。",
  },
  // Phase 2 扩充:数据存储深度分析
  {
    code: "SOURCE_SHARED_PREFS_PLAINTEXT",
    title: "SharedPreferences 明文存储（未检测到 EncryptedSharedPreferences）",
    trigger: /getsharedpreferences|getdefaultsharedpreferences/i,
    missing: [/encryptedsharedpreferences|androidx\.security\.crypto/i],
    recommendation: "敏感数据应使用 EncryptedSharedPreferences（AndroidX Security Crypto）替代明文 SharedPreferences。",
  },
  {
    code: "SOURCE_ROOM_NO_ENCRYPTION",
    title: "Room 数据库未检测到加密配置",
    trigger: /@database|roomdatabase|room\.database/i,
    missing: [/supportfactory|sqlcipher|safehelperfactory/i],
    recommendation: "Room 数据库含敏感数据时应使用 SQLCipher SupportFactory 或 EncryptedRoom 加密。",
  },
  {
    code: "SOURCE_REALM_NO_ENCRYPTION",
    title: "Realm 数据库未检测到加密密钥",
    trigger: /realm\.getInstance|realmconfiguration\.builder/i,
    missing: [/encryptionkey|\.encryptionKey\(/i],
    recommendation: "Realm 数据库应设置 encryptionKey（64 字节随机密钥），否则数据明文存储。",
  },
  {
    code: "SOURCE_WORLD_READABLE_DB",
    title: "数据库以 MODE_WORLD_READABLE 打开（跨应用可读）",
    trigger: /openorcreatedatabase\s*\([^)]*mode_world_readable|getSharedPreferences\s*\([^)]*mode_world_readable/i,
    missing: [],
    recommendation: "MODE_WORLD_READABLE 在 API 17+ 已废弃且 Android 7+ 禁止——改用 ContentProvider 或加密存储。",
  },
  {
    code: "SOURCE_BACKUP_INCLUDES_SENSITIVE",
    title: "自动备份可能包含敏感数据",
    trigger: /allowbackup\s*=\s*["']true["']|fullbackupcontent/i,
    missing: [/exclude.*(?:password|token|secret|key|credential)/i, /android:fullBackupContent.*exclude/i],
    recommendation: "android:fullBackupContent 应排除敏感文件/目录（数据库、SharedPreferences 含凭据时）。",
  },
  {
    code: "SOURCE_LOG_FILE_STORAGE",
    title: "日志写入文件（敏感持久化风险）",
    trigger: /(?:FileWriter|FileOutputStream|BufferedWriter)[\s\S]{0,60}(?:\.log|logcat|crash|error)/i,
    missing: [/encrypt|cipher|sqlcipher/i],
    recommendation: "日志文件不应持久化敏感数据；release 构建应禁用文件日志或加密日志。",
  },
  {
    code: "SOURCE_CACHE_SENSITIVE",
    title: "缓存目录存储敏感数据",
    trigger: /getcacheDir|getexternalcacheDir/i,
    missing: [/encrypt|deleteonexit|clean/i],
    recommendation: "缓存目录可被清理或提取——敏感数据应存储在内部存储并加密。",
  },
]

export interface StorageSecurityMatch {
  line: number
  code: string
  title: string
  snippet: string
}

// 逐行检测：trigger 命中且同文件未出现 missing 特征 → 提示（低置信度，失败关闭）。
export function scanStorageSecurity(source: string): StorageSecurityMatch[] {
  const matches: StorageSecurityMatch[] = []
  for (const pattern of PATTERNS) {
    if (!pattern.trigger.test(source)) continue
    if (pattern.missing.some((regex) => regex.test(source))) continue
    const lines = source.split(/\r?\n/)
    for (let i = 0; i < lines.length; i += 1) {
      const line = lines[i]!
      if (pattern.trigger.test(line)) {
        matches.push({ line: i + 1, code: pattern.code, title: pattern.title, snippet: line.trim().slice(0, 100) })
        break
      }
    }
  }
  return matches
}

// 扫描项目源码（失败关闭）。
export async function scanProjectStorageSecurity(projectRoot: string): Promise<Finding[]> {
  const roots = ["src/main/java", "src/main/kotlin", "app/src/main/java", "app/src/main/kotlin"]
  const files: string[] = []
  for (const root of roots) {
    const dir = path.join(projectRoot, root)
    const entries = await readdir(dir, { recursive: true }).catch(() => [] as string[])
    for (const entry of entries) {
      if (/\.(java|kt)$/.test(entry)) files.push(path.join(dir, entry))
    }
  }
  const findings: Finding[] = []
  const seen = new Set<string>()
  for (const file of files.slice(0, 400)) {
    const source = await readFile(file, "utf8").catch(() => "")
    const matches = scanStorageSecurity(source)
    for (const match of matches) {
      const key = `${match.code}:${file}`
      if (seen.has(key)) continue
      seen.add(key)
      const pattern = PATTERNS.find((p) => p.code === match.code)!
      const relative = path.relative(projectRoot, file).replaceAll("\\", "/")
      findings.push({
        severity: "low",
        confidence: "low",
        code: match.code,
        title: match.title,
        detail: `${relative}:${match.line} 触发（静态提示——需人工评估确认）。`,
        recommendation: pattern.recommendation,
        evidence: `${relative}:${match.line} ${match.snippet}`,
      })
    }
  }
  return findings
}
