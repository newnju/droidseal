# Modern-sample external validation (2026-09-15)

## Protocol
Real APKs downloaded from official GitHub release assets (F-Droid main site unreachable from this network; 13 APKs downloaded, 6 completed full audit+hardening within the time budget, 7 large APKs (19–97 MB) timed out at the hardening stage and were excluded). Full pipeline (audit + keyed hardening), Bun runtime, default detectors.

## Results (n=6)

| App | Findings | high | medium | low | info | Gate |
|---|---|---|---|---|---|---|
| Aegis 2.x | 35 | 1 | 8 | 7 | 19 | review |
| BinaryEye | 35 | 2 | 10 | 7 | 16 | review |
| Calculator | 28 | 1 | 6 | 4 | 17 | review |
| Notes | 32 | 1 | 8 | 4 | 19 | review |
| Simple-Calculator | 28 | 1 | 6 | 4 | 17 | review |
| k-9 / Thunderbird | 44 | 4 | 13 | 5 | 22 | review |

Mean findings: 33.7 (range 28–44). All six gates = review (no confirmed critical findings; hardening ran to completion on all six).

Per-app time (batch chunk 1): 3.1–6.7 s per APK including keyed hardening (hardened APK + keystore + SBOM + evidence pack produced for every sample).

## Caveats
- n=6 completed (7 timeouts on large APKs, excluded — a tool scalability limit, reported as such).
- No ground truth for these apps; this validates pipeline applicability, performance, and gate behavior on modern artifacts, NOT precision (stated explicitly in the paper).
- Sources: official GitHub release assets (NewPipe, Aegis, BinaryEye, Fossify Notes/Calculator, k-9). Raw reports under C:/tmp/fdroid-sample/out1, outk9.
