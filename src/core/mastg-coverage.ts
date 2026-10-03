// P4: MASTG 全集对照表(评测科学化)。
// 口径纪律(与 mastg-map.ts 一致):对照粒度为 MASVS 域 × 测试主题,**不做逐 MASTG-xxx-ID
// 的核定映射**——具体测试 ID 存在版本漂移与核定偏差风险,主题级三态对照供合规差距参考。
// 三态(如实):
//   static        静态可查——审计引擎存在关联 finding code,清单(mastg-checklist)已联动
//   heuristic     静态启发——存在部分检测面(存在性/模式匹配),无法给出确定性判定
//   dynamic       需动态验证——静态不可判定,必须真机/运行时观测(与 device-testing 衔接)
//   out-of-scope  超出静态工具范围——服务端侧/物理接触攻击者,如实声明不覆盖

export type MastgCoverageState = "static" | "heuristic" | "dynamic" | "out-of-scope"

export interface MastgCoverageTopic {
  domain: string // MASVS 域: STORAGE / CRYPTO / AUTH / NETWORK / PLATFORM / CODE / RESILIENCE / PRIVACY
  topic: string // 测试主题(中英对照)
  state: MastgCoverageState
  relatedCodes: string[] // state=static/heuristic 时的关联 finding code(空数组仅限 dynamic/out-of-scope)
  note?: string // 边界说明
}

const T = (
  domain: string,
  topic: string,
  state: MastgCoverageState,
  relatedCodes: string[] = [],
  note?: string,
): MastgCoverageTopic => {
  const item: MastgCoverageTopic = { domain, topic, state, relatedCodes }
  if (note !== undefined) item.note = note
  return item
}

// 全集主题表:按 MASTG v1 的八个 MASVS 域组织,主题粒度对齐官方测试组。
export const MASTG_COVERAGE: ReadonlyArray<MastgCoverageTopic> = [
  // ── STORAGE ──
  T("STORAGE", "敏感数据明文落盘(SharedPreferences/文件)", "static", ["SOURCE_UNENCRYPTED_STORAGE", "SOURCE_WEB_INSECURE_STORAGE"]),
  T("STORAGE", "日志泄露敏感数据", "static", ["SOURCE_DATAFLOW", "SOURCE_LIFECYCLE_ENTRY", "SOURCE_CROSS_FUNCTION_TAINT"]),
  T("STORAGE", "剪贴板/进程间全局状态敏感数据", "static", ["SOURCE_COLLECTION_TAINT", "SOURCE_STATIC_TAINT"]),
  T("STORAGE", "硬编码密钥/凭据落盘", "static", ["HARDCODED_SECRET", "GOOGLE_API_KEY", "AWS_ACCESS_KEY", "SOURCE_CONSTANT_VALUE", "SOURCE_JS_HARDCODED_SECRET"]),
  T("STORAGE", "备份泄漏(allowBackup/云备份)", "static", ["BACKUP_", "ALLOW_BACKUP"]),
  T("STORAGE", "IPC 泄漏(导出组件承载敏感数据)", "heuristic", ["EXPORTED_ACTIVITY", "EXPORTED_PROVIDER", "EXPORTED_SERVICE"], "组件暴露为静态判定,数据内容需动态"),
  T("STORAGE", "键盘缓存(自定义 IME 拦截)", "dynamic", [], "运行时输入通道,静态不可判定"),
  T("STORAGE", "进程内存敏感数据残留", "dynamic", [], "内存 dump 需 root+物理接触,超出静态范围"),
  // ── CRYPTO ──
  T("CRYPTO", "弱加密算法(DES/ECB/MD5/SHA1)", "static", ["SOURCE_WEAK_CRYPTO", "SOURCE_JS_WEAK_CRYPTO"]),
  T("CRYPTO", "硬编码加密密钥", "static", ["HARDCODED_SECRET", "EMBEDDED_", "CREDENTIAL_"]),
  T("CRYPTO", "不安全随机数(Random 替代 SecureRandom)", "heuristic", ["SOURCE_INSECURE_RANDOM"], "模式匹配启发"),
  T("CRYPTO", "自研/定制密码实现", "heuristic", ["SOURCE_WEAK_CRYPTO"], "存在性启发,正确性需人工"),
  T("CRYPTO", "密钥存放于 Android Keystore 并校验完整性", "dynamic", [], "运行时行为,静态只见调用面"),
  // ── AUTH ──
  T("AUTH", "本地认证(biometric)绕过面", "heuristic", ["SOURCE_SEMANTIC_VULN"], "调用面静态可见,绕过可行性需动态"),
  T("AUTH", "会话超时/失效", "dynamic", [], "需运行时观测"),
  T("AUTH", "服务端认证策略执行", "out-of-scope", [], "服务端侧,客户端静态工具范围外"),
  // ── NETWORK ──
  T("NETWORK", "明文流量(NSC cleartextPermitted)", "static", ["NSC_", "SOURCE_WEB_INSECURE_FORM", "ENDPOINT_INVENTORY"]),
  T("NETWORK", "证书校验关闭(WebView/onReceivedSslError)", "static", ["WEBVIEW_SSL_ERROR_IGNORED", "SOURCE_JS_DANGEROUS_API"]),
  T("NETWORK", "证书校验绕过(TrustManager/HostnameVerifier)", "static", ["SOURCE_SSL_BYPASS"]),
  T("NETWORK", "证书固定缺失", "heuristic", ["SOURCE_NO_CERT_PINNING"], "缺失判定为启发(不可证伪)"),
  T("NETWORK", "TLS 版本/套件降级", "dynamic", [], "握手观测,静态不可判定"),
  T("NETWORK", "自定义信任库/用户 CA 接受", "heuristic", ["NSC_"], "NSC 声明可见,实际信任行为需动态"),
  // ── PLATFORM ──
  T("PLATFORM", "权限最小化(敏感权限滥用)", "static", ["MALICIOUS_INDICATOR", "PRIVACY_DATA_COLLECTION"]),
  T("PLATFORM", "导出组件/深链暴露", "static", ["EXPORTED_ACTIVITY", "EXPORTED_PROVIDER", "EXPORTED_SERVICE"]),
  T("PLATFORM", "WebView 安全配置(JS bridge/file 访问)", "static", ["SOURCE_JS_DANGEROUS_API"]),
  T("PLATFORM", "Intent 重定向/隐式 Intent 劫持", "heuristic", ["SOURCE_SEMANTIC_VULN"], "模式启发"),
  T("PLATFORM", "应用签名/包完整性", "static", ["SIGNING_", "APK_SIGNED"]),
  // ── CODE ──
  T("CODE", "debuggable/可备份发布构建", "static", ["DEBUGGABLE", "ALLOW_BACKUP"]),
  T("CODE", "发布构建日志/断言残留", "static", ["SOURCE_DATAFLOW"]),
  T("CODE", "第三方 SDK 风险面", "static", ["SDK_", "SUPPLYCHAIN_"]),
  T("CODE", "已知漏洞依赖(CVE)", "static", ["SUPPLYCHAIN_"], "osv 对照(scripts/supplychain-osv.ts)"),
  T("CODE", "注入类输入校验(SQL/命令/路径)", "heuristic", ["SOURCE_SEMANTIC_VULN"], "污点启发,非污点全路径"),
  // ── RESILIENCE ──
  T("RESILIENCE", "反调试检测存在性", "heuristic", ["ANTIDEBUG_ABSENT"], "存在性判定,强度需动态"),
  T("RESILIENCE", "Root/hook(Frida)检测存在性", "heuristic", ["RUNTIME_", "NATIVE_"], "存在性判定"),
  T("RESILIENCE", "完整性校验存在性(重签必败)", "static", ["SIGNATURE_", "INTEGRITY_"], "运行时闭环由 device-matrix 验收"),
  T("RESILIENCE", "加壳/混淆壳特征", "static", ["PACKER_DETECTED", "SO_UNSTRIPPED_SYMBOLS", "SO_PACKED"]),
  T("RESILIENCE", "反模拟器/反克隆", "heuristic", ["RUNTIME_"], "存在性启发"),
  T("RESILIENCE", "运行时内存访问防护(anti-dump)", "dynamic", [], "需运行时观测"),
  T("RESILIENCE", "多进程/服务端协同校验", "out-of-scope", [], "服务端侧范围外"),
  // ── PRIVACY ──
  T("PRIVACY", "设备标识/位置收集", "static", ["PRIVACY_DATA_COLLECTION", "SOURCE_COLLECTION_TAINT"]),
  T("PRIVACY", "用户行为遥测面", "heuristic", ["PRIVACY_DATA_COLLECTION"], "收集意图启发"),
  T("PRIVACY", "数据第三方共享流", "heuristic", ["ENDPOINT_INVENTORY"], "端点清单可见,数据内容需动态"),
]

const STATE_LABEL: Record<MastgCoverageState, string> = {
  static: "静态可查",
  heuristic: "静态启发",
  dynamic: "需动态",
  "out-of-scope": "范围外",
}

/** 全集对照三态汇总(按域分组计数)。 */
export function mastgCoverageSummary(table: ReadonlyArray<MastgCoverageTopic> = MASTG_COVERAGE): {
  total: number
  byState: Record<MastgCoverageState, number>
  byDomain: Array<{ domain: string; total: number; static: number; heuristic: number; dynamic: number; outOfScope: number }>
} {
  const byState: Record<MastgCoverageState, number> = { static: 0, heuristic: 0, dynamic: 0, "out-of-scope": 0 }
  for (const t of table) byState[t.state] += 1
  const domains = [...new Set(table.map((t) => t.domain))]
  const byDomain = domains.map((domain) => {
    const items = table.filter((t) => t.domain === domain)
    return {
      domain,
      total: items.length,
      static: items.filter((t) => t.state === "static").length,
      heuristic: items.filter((t) => t.state === "heuristic").length,
      dynamic: items.filter((t) => t.state === "dynamic").length,
      outOfScope: items.filter((t) => t.state === "out-of-scope").length,
    }
  })
  return { total: table.length, byState, byDomain }
}

/** 由审计 findings 判定各主题实际命中状态(命中 → 该主题「已检出」,否则按固有三态)。 */
export function mastgCoverageWithFindings(
  findings: ReadonlyArray<{ code: string }>,
  table: ReadonlyArray<MastgCoverageTopic> = MASTG_COVERAGE,
): Array<MastgCoverageTopic & { hit: boolean }> {
  const codes = new Set(findings.map((f) => f.code))
  return table.map((t) => ({
    ...t,
    hit: t.relatedCodes.length > 0 && t.relatedCodes.some((code) => codes.has(code)),
  }))
}

export function mastgCoverageStateLabel(state: MastgCoverageState): string {
  return STATE_LABEL[state]
}
