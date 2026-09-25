# AndroZoo 现代样本弱 GT 基准(阶段 1b)

> **数据集**:AndroZoo(https://androzoo.uni.lu)— Allix et al., *AndroZoo: Collecting Millions of Android Apps for the Research*, MSR 2016(DOI: 10.1145/2901739.2903508);元数据引用 Allix et al., 2024(DOI: 10.1109/3643991.3644863)。
>
> **harness**(Rust 版报告头注入):engine `a204dd9@dirty` · scan `detectors=default;dataflow=intra+interproc-summary;flow-adjudication=endpoint+connected` · gt sha256:fcc54d5560a41c6a

## 1. 样本构建(2026-09-19)

| 项 | 值 |
|---|---|
| 清单来源 | AndroZoo 官方 `latest.csv.gz`(2026-09-18 夜间版,3.52 GB) |
| 筛选条件 | `vt_detection ∈ [10,30]` 且 `dex_date ≥ 2016-01` 且 `apk_size ∈ (0.5MB, 30MB)` 且非 snaggamea |
| 选中 | **50 个 APK**(年份:2016×7 / 2017×13 / 2018×12 / 2019×12 / 2020×5;VT 检出 10–28,均值 15.7) |
| 下载 | `/api/download` 按清单 `apk_size` 断点续传;50/50 完整(ZIP 中央目录校验 + 字节数核对) |
| 反编译 | apktool 2.9.3 → smali(50/50);jadx 1.5.0 → Java(50/50,供 bench 源码扫描) |
| 工件 | `C:/c/c/tmp/androzoo/`(`apks/` 原 APK、`java50/` jadx 输出、`sel50.csv` 选中清单、`androzoo-map.json` GT、`androzoo-suite.json` 套件) |

> ⚠️ 清单中 1 条记录 sha256 仅 63 字符(AndroZoo 数据瑕疵,case `00258C14FAA8…`),按原值保留并在 Rust 侧计入 `skippedNoGt=1` 的提示;TS 侧按 50 case 全匹配。两侧 case 集与评分口径一致。

## 2. Ground Truth 口径声明(弱 GT)

**本套件 GT 为弱 GT(app 级、VT 投票),非语义流级 GT,与 DroidBench/TaintBench 强 GT 不可混算:**

- 每个 case 的 `expected=true` 仅表示「VirusTotal ≥10 引擎判为恶意」——是**样本级恶意性代理标签**,不指明任何 source→sink 流;
- 弱 GT 只能回答「工具是否在样本中报出任何疑似泄漏」(app 级 TP/FP),**不能度量流级召回**;FP 判定同样受限(良性对照缺失,本套件 TN=0);
- VT 检出 10–30 区间刻意避开 >30 的强家族样本,以容纳真实世界灰色样本;该区间同样意味着个别 case 可能是误报驱动的假阳性样本(如实保留,不做人工清洗)。

## 3. 结果(双侧同口径,2026-09-19 实测)

| 引擎 | cases | TP | FP | FN | Precision | Recall |
|---|---|---|---|---|---|---|
| DroidSeal Rust(`droidseal-rust bench`) | 50 | 50 | 0 | 0 | 100% [95%CI 92.9–100] | 100% [95%CI 92.9–100] |
| DroidSeal TS(`droidseal bench`) | 50 | 50 | 0 | 0 | 100% [95%CI 92.9–100] | 100% [95%CI 92.9–100] |

- 双侧逐 case 命中完全一致(50/50)。
- Rust 版自动标注**合成套件近饱和预警**(P/R ≥98%):该套件已无法区分更强检测器的能力差异——本套件的价值是**现代样本可达性回归防线**,能力比较请看 TaintBench 与 FlowDroid 对照。

## 4. 与其他套件的定位(诚实边界)

| 套件 | GT 强度 | 粒度 | 本套件回答的问题 |
|---|---|---|---|
| DroidBench 177 | 强(语义流) | app+流级 | 检测器规则与传播正确性 |
| TaintBench 39 | 强(官方 flows) | app+流级 | 真实恶意样本流级能力 |
| **AndroZoo 50(本套件)** | **弱(VT 投票)** | **app 级** | **2016–2020 现代真实样本上的可达性与稳定回归** |
| FlowDroid 同机 22 | 强(GT 流) | 流级 | 与学术基线的同口径对照 |

## 5. 复现

```bash
# TS 侧(需 bun)
bun src/index.tsx bench C:/c/c/tmp/androzoo/androzoo-suite.json --format md
# Rust 侧
./target/release/droidseal-rust bench C:/c/c/tmp/androzoo/androzoo-suite.json --format md
```

GT 文件 `androzoo-map.json` 的 sha256 前 16 位:`fcc54d5560a41c6a`(Rust 报告头自动注入比对)。
