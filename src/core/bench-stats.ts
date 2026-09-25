// DroidSeal — bench 统计层(TS 版,与 Rust bench_stats.rs 同口径):
// ① Wilson 95% 置信区间 ② 配对 bootstrap 差值区间(固定种子可复现)。
// 纯后处理,零引擎改动。

export function wilson95(successes: number, total: number): [number, number] | null {
  if (total === 0) return null
  const n = total
  const p = successes / n
  const z = 1.959964
  const z2 = z * z
  const denom = 1 + z2 / n
  const center = (p + z2 / (2 * n)) / denom
  const half = (z * Math.sqrt((p * (1 - p)) / n + z2 / (4 * n * n))) / denom
  return [
    Math.round(Math.max(0, center - half) * 1000) / 10,
    Math.round(Math.min(1, center + half) * 1000) / 10,
  ]
}

export interface CaseOutcome { expected: boolean; hit: boolean }

/** 配对 bootstrap:recall 差值(a − b)95% 区间(百分点);SplitMix64 固定种子。 */
export function pairedBootstrapRecallDiff(a: CaseOutcome[], b: CaseOutcome[], iters = 10_000): [number, number] | null {
  if (a.length !== b.length || a.length === 0) return null
  const n = a.length
  const recall = (s: CaseOutcome[]): number => {
    let tp = 0, fn = 0
    for (const c of s) {
      if (c.expected && c.hit) tp++
      else if (c.expected) fn++
    }
    return tp + fn > 0 ? (tp / (tp + fn)) * 100 : 0
  }
  // SplitMix64
  let state = 0x9E3779B97F4A7C15n
  const next = (): bigint => {
    state = (state + 0x9E3779B97F4A7C15n) & 0xFFFFFFFFFFFFFFFFn
    let z = state
    z = ((z ^ (z >> 30n)) * 0xBF58476D1CE4E5B9n) & 0xFFFFFFFFFFFFFFFFn
    z = ((z ^ (z >> 27n)) * 0x94D049BB133111EBn) & 0xFFFFFFFFFFFFFFFFn
    return z ^ (z >> 31n)
  }
  const diffs: number[] = []
  for (let it = 0; it < iters; it++) {
    const sa: CaseOutcome[] = [], sb: CaseOutcome[] = []
    for (let i = 0; i < n; i++) {
      const idx = Number(next() % BigInt(n))
      sa.push(a[idx]); sb.push(b[idx])
    }
    diffs.push(recall(sa) - recall(sb))
  }
  diffs.sort((x, y) => x - y)
  const lo = diffs[Math.floor(0.025 * iters)]
  const hi = diffs[Math.floor(0.975 * iters) - 1]
  return [Math.round(lo * 10) / 10, Math.round(hi * 10) / 10]
}

/** `97.2% [95%CI 93.4–98.8]` 中的区间段。 */
export function fmtCi(successes: number, total: number): string {
  const ci = wilson95(successes, total)
  return ci ? `[95%CI ${ci[0]}–${ci[1]}]` : "[95%CI n/a]"
}
