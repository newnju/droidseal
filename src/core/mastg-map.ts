// OWASP MASTG 规则映射（下一阶段中期①——MobSF 缺口）。
// 常见 finding code → MASTG 类别/主题参考（清单级，避免具体测试 ID 的核定偏差——
// 只做类别级映射，供审计标准的合规参考）。未映射的 finding 不输出。
import type { Finding } from "./types.ts"

// code 前缀 → MASTG 类别参考
const MASTG_PREFIX_MAP: ReadonlyArray<{ prefix: string; reference: string }> = [
  { prefix: "BACKUP_", reference: "MASTG-STORAGE（备份/allowBackup 数据泄漏）" },
  { prefix: "DEBUG", reference: "MASTG-CODE（调试模式/debuggable）" },
  { prefix: "EXPORTED_", reference: "MASTG-CODE（组件暴露/导出）" },
  { prefix: "NSC_", reference: "MASTG-NETWORK（网络安全配置/明文/证书固定）" },
  { prefix: "HARDCODED_", reference: "MASTG-CRYPTO（硬编码密钥）" },
  { prefix: "EMBEDDED_", reference: "MASTG-CRYPTO（嵌入凭据）" },
  { prefix: "CREDENTIAL_", reference: "MASTG-CRYPTO（凭据格式）" },
  { prefix: "SOURCE_WEAK_CRYPTO", reference: "MASTG-CRYPTO（弱加密算法）" },
  { prefix: "SOURCE_DATAFLOW", reference: "MASTG-CODE（敏感数据流向）" },
  { prefix: "DEX_STRING_", reference: "MASTG-STORAGE（敏感字符串）" },
  { prefix: "SO_", reference: "MASTG-CODE（Native 层）" },
  { prefix: "SUPPLYCHAIN_", reference: "MASTG-CODE（供应链组件）" },
  { prefix: "ARSC_", reference: "MASTG-STORAGE（资源）" },
]

export function mastgReference(code: string): string | undefined {
  for (const entry of MASTG_PREFIX_MAP) {
    if (code.startsWith(entry.prefix)) return entry.reference
  }
  return undefined
}

// 从 findings 提取 MASTG 映射清单（失败关闭：未映射不输出）。
export function mappedMastgFindings(findings: readonly Finding[]): Array<{ code: string; title: string; reference: string }> {
  const out: Array<{ code: string; title: string; reference: string }> = []
  for (const finding of findings) {
    const reference = mastgReference(finding.code)
    if (reference) out.push({ code: finding.code, title: finding.title, reference })
  }
  return out
}

// 反编译核验建议（中期②——MobSF 缺口）：复杂发现提示用 JADX/apktool 反编译人工核验。
const DECOMPILE_PREFIXES = ["SOURCE_", "DEX_STRING_", "PACKER_", "NSC_", "ARSC_", "SO_", "ASSET_", "DEX_"]
export function decompileSuggestions(findings: readonly Finding[]): Array<{ code: string; title: string }> {
  const out: Array<{ code: string; title: string }> = []
  for (const finding of findings) {
    if (DECOMPILE_PREFIXES.some((prefix) => finding.code.startsWith(prefix))) {
      out.push({ code: finding.code, title: finding.title })
    }
  }
  return out
}

