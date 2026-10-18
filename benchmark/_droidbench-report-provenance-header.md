# 基准评测: DroidBench(droidseal bench)— 权威证据

> **证据溯源(2026-10-18 重跑)**:数据 = `E:/env/datasets/DroidBench`(上游 master 稀疏克隆);
> GT = `benchmark/droidbench-map.json`(由 `scripts/generate-droidbench-map.ts` 从官方 README 再生成,179 正例 / 6 负例);
> 命令 = `bun src/index.tsx bench benchmark/droidbench-suite.json --format md`;引擎 = bun 1.4.2 TS core;
> 本文件取代旧版归因(data-flow 4 / 辅助 1)——旧报告由更旧层白名单生成,与当前引擎(renderMd FLOW 前缀表)不符,已废止。
> 计时证据见 `benchmark/timing-droidbench-20261018.md`(全量 177 计分用例连跑 wall 982 ms / 进程内峰值 RSS 96.5 MB / CPU 984 ms;隔离单用例端到端 mean 1.3 ms / p50 1.1 / max 10.2)。
