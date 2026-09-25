# R6 补充统计:显著性检验 + 同批耗时对比(2026-09-14)

## Wilcoxon signed-rank 精确检验(n=7,Δ熵 配对)

- Δ(DroidSeal): [0.42, 0.36, 2.37, 2.26, 2.43, 2.39, 2.32]
- Δ(Obfuscapk): [0.13, 0.11, 1.20, 0.16, 1.15, 1.28, 1.32]
- 配对差(DS−Obf): [0.29, 0.25, 1.17, 2.10, 1.28, 1.11, 1.00] — **7/7 为正**
- W⁺=28, W⁻=0, W=0,**精确双侧 p = 0.0156**(枚举 2⁷=128 种符号组合)

结论:DroidSeal 的熵增量在 7 个样本上系统性高于 Obfuscapk(p<0.05),差异非偶然。

## 同批耗时对比(同 7 个 APK)

| 工具 | 逐样本耗时 | 中位 | 说明 |
|---|---|---|---|
| MobSF 4.5.2(本机 waitress) | 9–14 s | 10 s | 日志首尾时间戳差 |
| DroidSeal(审计+加固) | ~20 ms(产物写入跨度 0.02 s) | ~0.02 s | 运行目录文件 mtime 跨度 |

量级差:MobSF ≈ 500×(注意口径:MobSF 含 APK 解析+证书+组件枚举;DroidSeal 为静态审计流水线)。论文引用时须注明测量口径不同,不构成严格基准,但量级差足以支撑"轻量、可入 CI"的定位。

## 来源文件

- 量化配对:C:/Users/diamond/textseg/multisample/quantify/quantify.json(21 行,3 方 × 7 样本)
- MobSF 耗时:C:/tmp/mobsf-scan/scan-*.json → logs[].timestamp
- DroidSeal 耗时:textseg/multisample/*/.droidseal/runs/*/ 文件 mtime
