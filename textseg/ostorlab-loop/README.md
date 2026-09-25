# Ostorlab 端到端闭环:审计 → 门控 → 修复 → 复测(2026-09-14)

输入:`ostorlab_insecure_app.apk`(Ostorlab 官方不安全测试应用,2.77 MB,真实第三方样本)

## 全链路记录

| 环节 | 产物 | 结果 |
|---|---|---|
| ① 审计 | `audit1/.droidseal/runs/20260914032530-f8cfcb/reports/droidseal-report.json` | 26 项发现(critical 1 / high 3 / medium 8 / low 4 / info 10) |
| ② 门控 | 同上 `releaseDecision` | **block**:CRITICAL_FINDING_CONFIRMED(MANIFEST_DEBUGGABLE, confirmed)+ RELEASE_SIGNATURE_INVALID_OR_MISSING;另有 2 项 review(high) |
| ③ 修复 | `fix/` | apktool 反编译 → `android:debuggable="false"` → 重打包 → zipalign → release-key.jks 正式签名(SHA-256 51a3ebd6… 匹配 P0-A 锚点) |
| ④ 复测 | `retest/.droidseal/runs/20260914042747-c4ea48/reports/droidseal-report.json` | 25 项发现(critical 0 / high 3);**gate: review,blockingReasons=[]** |

## 结论

- 审计发现的 critical 阻断项(MANIFEST_DEBUGGABLE)在修复后消失,门控状态 **block → review**,发布决策由"阻断"降为"人工复核"(剩余 high 项需人审,符合先确认后报告的精度模型)。
- 复测同时执行了加固流水线,产出 `retest/hardened/fixed-signed.hardened.apk`(6.1 MB,密钥来源 certificate),闭环延伸到"修复后发布物可直接进入加固阶段"。
- 未修复项(NSC_CLEARTEXT_PERMITTED、DEX_INSECURE_TLS 等)如实保留为 review/advisory——闭环只验证"修复→门控翻转",不声称清零。

## 环境坑(复现必读)

- 对**加固产物**(加密容器 6.1 MB)再审计会触发 apk-audit 死循环(bun 内存 4 分钟仅涨 4 MB,470 MB 处停摆),复测必须用**未加固**的修复 APK。
- 分离启动:Start-Process 裸 bun / cmd 包装都会随会话消亡;`Invoke-CimMethod Win32_Process Create` 可跨会话存活(本次 CIM 启动的进程跑满 4 分钟)。
- 日志文件被残留进程锁定时换文件名,勿 rm。
