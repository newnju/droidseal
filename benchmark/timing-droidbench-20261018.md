# Bench timing evidence — DroidBench-full-177

- suite: `benchmark/droidbench-suite.json`
- wall clock: **982 ms**(进程内评测循环计时,含全部 loadSuite + runSuite)
- peak RSS: **96.5 MB**(进程内 rss 采样,50ms 间隔)
- CPU(user+system): **984 ms**(process.cpuUsage 差值)
- per-case(n=206,隔离端到端含固定开销): mean **1.3 ms**, p50 1.1, p90 0.9, max 10.2, min 0.8
- named case Merge1: **1.6 ms**
- named case ApplicationModeling1: **1.4 ms**
- named case Obfuscation1: **1.2 ms**
- named case PrivateDataLeak1: **1.2 ms**
- named case ArrayAccess4: **1.2 ms**
- named case FlowSensitivity1: **1.1 ms**
- results: suite=DroidBench cases=177 tp=171 fp=5 fn=1 tn=0;
- date: 2026-10-18T14:16:36.257Z

> 口径:同引擎、同 GT 分层;计时与内存由 `scripts/timing-bench.ts` 一个命令复现。