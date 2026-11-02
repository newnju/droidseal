# DroidSeal · Android Release Seal

[中文](README.zh-CN.md) | [English](README.md)

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-181717.svg?logo=github&logoColor=white)](https://github.com/noontiger/droidseal/blob/main/LICENSE)
[![npm](https://img.shields.io/npm/v/droidseal.svg?logo=npm&logoColor=white&color=cb3837)](https://www.npmjs.com/package/droidseal)
[![PyPI](https://img.shields.io/pypi/v/droidseal.svg?logo=pypi&logoColor=white&color=3775a9)](https://pypi.org/project/droidseal)

**DroidSeal** is a local-first Android release security pipeline. It combines static audit, evidence-driven remediation, optional runtime hardening, official alignment and signing, and independent verification in one reproducible workflow. The design goal is not to replace commercial hardening; it is to make the pre-hardening release path auditable, reproducible and fail-closed.

> **Version scope.** This document describes the public **1.0.1** release. The repository may contain older or newer development commits; they are not part of 1.0.1. Use tag `v1.0.1` for the matching source. Release-specific evidence and checksums are recorded in [`docs/releases/v1.0.1.md`](docs/releases/v1.0.1.md).

## What it does

- **Audit**: static audit of projects and APKs — permissions, targetSdk, signing schemes, hardcoded secrets, DEX/TLS heuristics, native `.so` hardening, third-party dependencies and a CycloneDX SBOM;
- **Release**: runs `zipalign → apksigner sign → verify` in the official order, with automatic rollback on failure and an independent artifact per step;
- **Artifacts**: APK + SHA-256 + JSON/Markdown reports + a release gate + SBOM.

## System overview

![Figure 1. DroidSeal local-first release pipeline](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig1-pipeline.png)

**Figure 1. DroidSeal release pipeline.** The release contract is executed end to end on the local machine; external Android tools are invoked only at mandated steps. The figure is a schematic, not a benchmark result. The measured criteria are listed under [Measured capabilities](#measured-capabilities-benchmarked-not-claimed) and in [`benchmark/`](benchmark/README.md).

## Install

| Channel | How |
|---|---|
| npm | `npm install --global droidseal` |
| PyPI | `pip install droidseal` |
| GitHub Releases | Download the Windows zip / Linux tar.gz directly |

> The npm package ships a verified single-file bundle (`dist/droidseal.mjs`): the `droidseal` launcher checks the bundle's SHA-256 against the pinned build metadata on every run, then loads it — requires Node.js ≥ 18. After install, run `droidseal --version` to confirm.

> **Windows note**: if SmartScreen blocks the exe on double-click, right-click → Properties → Unblock. The TUI must run in a terminal: run `droidseal` in PowerShell, or double-click the bundled `droidseal-gui.cmd` launcher.

## Release integrity

Release artifacts are published with SHA-256 digests and a source commit. The v1.0.1 archive digests are:

| Artifact | SHA-256 |
|---|---|
| `droidseal-1.0.1-windows-x64.zip` | `6c52eefe820c167ddb8c2e7804c292e466c8b318e4b93a1a58108ba523f7814a` |
| `droidseal-1.0.1-linux-x64.tar.gz` | `530262d47177dd0cbcac0ead2cb7128587daf4707808a295e8a25f90a00ac3f8` |

Verify the archive before installing it:

```powershell
Get-FileHash .\droidseal-1.0.1-windows-x64.zip -Algorithm SHA256
```

```bash
sha256sum droidseal-1.0.1-linux-x64.tar.gz
```

For a signed APK produced by the release flow, verify the signature and certificate independently:

```bash
apksigner verify --print-certs <output.apk>
```

The npm launcher verifies the bundle SHA-256 against pinned build metadata on every run. Checksums alone do not establish runtime safety; they bind a downloaded artifact to the published release record. The v1.0.1 release commit is `0ff5fb3206e8d05d19de7e23e5c3985438efe41a`.

## Usage

```powershell
droidseal              # interactive TUI wizard (one-click / step-by-step)
droidseal doctor       # non-interactive environment diagnosis
droidseal --version
```

## Interface

<img width="960" alt="DroidSeal TUI screenshot" src="https://raw.githubusercontent.com/noontiger/droidseal/main/droidseal-screenshot.png" />

The TUI is a front end to the same non-interactive pipeline. It does not change the artifact contract, the release gate or the evidence requirements.

### APK hardening mode (opt-in)

`droidseal <input.apk> --output <dir> --cert-sha256 <sha256> --keystore <jks> --ks-alias <alias> --ks-pass <pass> --key-pass <pass>`

Runtime-hardens a release APK: DEX payload encryption (AES-256-GCM, per-entry HKDF-derived keys), a randomized bootstrap shell (dual-DEX: a plaintext stub loads an encrypted loader from assets), shell entry-class / container-magic / meta-key randomization per build, method code-item extraction, string encryption with call-site rewrite, and optional NDK placement of the split-key part2 in a native library. Every build emits an honest findings report — anything not implemented is reported as a finding, never claimed as protection.

**Keyed hardening layers** (designed so tampering derives wrong keys rather than emitting a bypassable warning):

- **Integrity anchor in key derivation**: the final binary `AndroidManifest.xml` SHA-256 is folded into every per-entry HKDF info. Repackaging that rewrites the manifest changes the anchor → wrong keys → GCM silently fails (P0-A).
- **Environment gate in key derivation**: runtime anti-analysis votes (Java detection + a native fork-based parent-TracerPid check / port probe / maps scan + the debuggable flag) are folded into the same HKDF info. The vote binds to *environment configuration* — a ptrace-based debugger (`TracerPid`), a rooted-Frida framework, or `debuggable=true` changes vote state and the derived keys are simply wrong, with no signal to locate (P0-B). **Honest scope (measured)**: `frida-inject` gadget hooking of individual libc functions changes none of that configuration — the votes stay honest, the app survives hooking by design (25 s active-instrumentation window, 61 hooked reads, zero failure markers); the vote is an environment-integrity input, not a universal instrumentation detector.
- **Key sharding**: the master key is recombined per entry and wiped immediately; no complete master key is retained, and decrypted DEX buffers are zeroed after class loading (P0-C).
- **Redundant heterogeneous detection**: three independent sources (Java / native C / system flags) with different read paths — bypassing one does not flip the vote (P1). Note: the native port probe tests localhost 27042/27043 (Frida defaults); another process legitimately listening on those ports on the same device (e.g. while instrumenting a *different* app) can produce a false positive.
- **VMP-lite (wired subset)**: selected `(I)I` leaf methods are compiled to VM bytecode embedded in the shell SO and registered at runtime through `RegisterNatives`; non-`(I)I` methods remain stub + lazy restore. API 26 x86_64 emulator acceptance recorded 5/5 registrations and `vmLeaf(21)=120` matching the original. This is not a full-instruction-set VMP, and the wider API matrix was not run in 1.0.1.

| Flag | Effect |
|---|---|
| `--cert-sha256 <hex>` | signing-cert fingerprint; keys derive from it — **re-signing with a different key breaks decryption by design** |
| `--no-random-names` | keep fixed shell identifiers (debugging only) |
| `--no-triple-entry` | skip extra shell entry hooks |
| `--keystore-bind` | seal a key fragment in Android Keystore after first run — reinstall or device change invalidates it |
| `--challenge-url <url>` | optional server challenge: split-key part3 is removed from the APK and released by your HTTPS endpoint after checking the caller's manifest hash; the build emits `server-challenge.json` for deployment. **If that file is lost, the build is permanently undecryptable.** The manifest hash is publicly derivable from the APK, so this check is **not authentication**; it only prevents a different APK from collecting this build's part3. Treat `server-challenge.json` as key material. |

**Keyed defense and artifact contract.** Figure 2 separates the two things a hardening claim must establish: the runtime key-derivation model (panel a) and the final archive-level contract that is checked after the build (panel b). The model is deliberately fail-closed: tampering with the manifest, the environment vote or the key shards changes the derived key, so GCM authentication fails rather than emitting a bypassable warning.

![Figure 2. Keyed defense and hardened-APK artifact contract](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig2-keyed-artifact.png)

**Figure 2. Keyed defense and hardened-APK artifact contract.** Panel a shows the build-time derivation inputs and the clean/tampered runtime paths. Panel b maps the final archive entries to the H1–H6 build-time gates. H1–H6 are necessary but not sufficient: device install/launch remains the acceptance gate. See [Testing and acceptance](#testing-and-acceptance) for the full evidence ladder.

**Expectation management**: hardening raises reverse-engineering cost; it does not make reversing impossible. On rooted devices with Frida, in-memory DEX dumps cannot be fully prevented by any offline packer. A one-time semantic patch of the loader (hard-coding the build-time manifest hash, an honest vote value and the embedded shards) or a dump-and-patch attack is not cryptographically excluded; the design preserves a per-tamper cost, not an impossibility claim. `--challenge-url` and `--keystore-bind` externalize derivation inputs and raise that cost; treat one of them as the baseline for high-assurance use. `minSdk < 26` falls back to a file-backed `DexClassLoader` (still works, slightly weaker isolation). Device install/launch is the only authoritative acceptance test.

## Platform & status

- **Platform**: Windows x64 / Linux x64;
- **Status**: 1.0.1 stable — the CLI, output layout and report formats are stable; the latest public release is 1.0.1;
- **Software**: an ANSI/Unicode-capable monospace terminal is required for the TUI; Bun 1.3+ to run from source; JDK/Gradle/Android Build Tools are auto-discovered or downloaded per flow (Node only for Capacitor web builds);
- **Hardware (practical advice, not a hard floor)**: ~500 MB disk (100 MB executable + toolchain + artifacts), ≥2 GB RAM (more for large APKs — parsing is memory-sensitive with a fail-safe cap), x64 dual-core CPU.

## Positioning

Android security tooling splits into two tracks: **audit** (MobSF, AndroBugs, APKiD — analyze, never rewrite) and **hardening** (commercial: DexGuard / DexProtector / 360 Jiagu; open source: Jiagu, nmmp, dpt-shell, XopProtector — rewrite the APK). DroidSeal deliberately spans both — a combination that is uncommon among open-source projects.

| Track | Closest peers | What DroidSeal adds |
|---|---|---|
| Audit | MobSF (deepest analysis, ~19k★), AndroBugs, APKiD | Audit findings drive **fixes in the same toolchain**: audit → remediation report → R8 → hardening → re-sign → re-verify, with a CycloneDX SBOM and release-evidence chain (releaseDecision / remediation). MobSF stops at the report. No dynamic sandbox / iOS — use MobSF for those. |
| Hardening (open source) | dpt-shell (method-level), nmmp (VMP), XopProtector | **Keyed defenses**: integrity anchors and anti-analysis votes fold into per-entry key derivation (P0-A/B/C, P1) — patching detection code restores the *correct* key, but changing the environment configuration (rooted-Frida framework, ptrace debugger, `debuggable=true`) without patching derives *wrong* keys. Many mainstream shells detect-and-warn; bypassing the check can cost little. Also: key sharding, VMP-lite subset, honest findings. |
| Hardening (commercial) | DexGuard, DexProtector, 360 加固保 | Fully **offline** (code never leaves your machine — the main reason teams pick open-source hardening over cloud services), auditable behavior, no per-app pricing. Trade-off: no full VMP/white-box crypto, less battle-tested, no SLA. |

**Where DroidSeal does NOT compete (honest boundaries)**:

- Need full-instruction-set VMP protection that survives a memory dump of the master key? Use nmmp or DexGuard — DroidSeal ships only a wired VMP-lite subset for `(I)I` leaves and explicitly does not invest in white-box AES or full-instruction-set VM protection; on rooted devices with sustained physical access, a sufficiently skilled attacker eventually wins.
- Doing malware triage or dynamic behavior analysis? Use MobSF + APKiD — DroidSeal only audits and hardens, it never sandboxes.
- Need contractual support/SLA for a high-stakes product? The project is early (real-device acceptance, independent security review, and community size are all still ahead of it) — commercial vendors are the safer bet there.

**One-line summary**: a local-first audit→harden→sign→verify pipeline; hardening strength is mid-pack; keyed defenses are the differentiator; maturity is the biggest gap.

## Evaluation protocol

![Figure 3. Evidence ladder for release claims](https://raw.githubusercontent.com/noontiger/droidseal/main/docs/figures/fig3-evidence-ladder.png)

**Figure 3. Evidence ladder.** Each layer answers a different question: unit tests prove implementation invariants; adversarial regressions prove that a fix closes a specific trigger condition; the artifact baseline proves the final APK still satisfies the structural contract; and device acceptance is the only layer that can support a runtime claim. The figure is a schematic; measured values and their criteria are reported below.

## Measured capabilities (benchmarked, not claimed)

Numbers below come from reproducible harnesses in [`benchmark/`](benchmark/README.md); each is stated with its measurement criteria — the same discipline the tool applies to its own findings. These are the 1.0.1 measurements; later development-line changes require a fresh benchmark run before comparison.

**Audit (static analysis)**

| Capability | Measured | Criteria |
|---|---|---|
| Malicious-flow detection (TaintBench, 39 apps / 249 GT flows) | endpoint TP 171 / 249 (68.7%), flow TP 136 | endpoint = target API present in the GT class; flow = both ends hit |
| False positives (434 benign apps, AndroZoo VT=0 proxy) | dataflow engine FP = **0** (95% CI upper 0.69%) | only the dataflow layer counts; auxiliary config hints reported separately. This is the 1.0.1 baseline; re-run before comparing later branches |
| Detector base (source/config/hardening patterns) | 379 detectors, precision 76.9% / recall 90.9% on the 38-case built-in bench | pattern-level, MSTG-mapped |
| JNI dynamic-register recovery | registry-string co-occurrence + DEX cross-validation | new finding class `JNI_DYNAMIC_REGISTER`; native attack surface invisible to static symbol scans |
| Native linear dataflow | JNI exported-function source→sink co-occurrence | **linear heuristic, not pointer analysis**; `confidence: low` by design |

**Hardening (release APK, opt-in)**

| Layer | Status |
|---|---|
| DEX payload encryption (AES-256-GCM, HKDF, keyed anchors P0-A/B/C) | shipped; emulator acceptance, with SEC-010/011/012 fixed and regression-tested |
| Method extraction (code-item hollowing) + lazy restoration | shipped; fail-open fallback to full restore |
| String encryption with call-site rewrite (MUTF-8 safe ciphertext + checksum recompute) | shipped; apktool fail-closed on write-back |
| VMP-lite | wired `(I)I` leaf subset; VM bytecode in the shell SO, `RegisterNatives` registration; API 26 x86_64 emulator acceptance (5/5 registration, `vmLeaf(21)=120`); non-`(I)I` methods stay stub + lazy restore; wider API matrix not run |
| Keyed defenses (integrity anchor / environment gate / key sharding / optional server challenge / Keystore binding) | shipped, with honest caveats in the hardening section above |

**Honest boundaries of the numbers**: TaintBench line numbers and jadx line numbers are different sources (230 endpoints, only 6 exact) — connected-level matching therefore offers a strict tier (line ±2, historically 0) and a lenient tier (class-stem alignment, 66/249); the lenient tier must never be quoted alone. Obfuscated GT method names (`i`, 31 occurrences) are recovered only when the wrapping method body contains exactly one known source/sink API; ambiguous cases are dropped, not guessed. The 1.0.1 false-positive measurement predates later sanitizer changes on the development line and must not be assumed valid for those commits.

## Testing and acceptance

Maturity here means *claimed capabilities are tested capabilities* — four layers, from cheapest to most expensive:

| Layer | Tool | When it runs | What it proves |
|---|---|---|---|
| Unit + regression | `bun test` | every change (CI core job) | crypto layout, URL patching, container format invariants |
| Security regression | `bun test tests/security-regression.test.ts` | mandatory per security fix | each accepted security fix ships a `SEC-XX` test reproducing its *trigger condition* (red on pre-fix code, green after; policy in [SECURITY.md](SECURITY.md#adversarial-regression-policy), full fix history in the [Security Ledger](docs/security-ledger.md)) — covers C1 (no PTRACE_TRACEME in generated native source), C3 (pre-XOR seal ordering), C4 (byte-length-preserving debuggable flip), C5 (whitelist smoke permanence), R2/R3 |
| Artifact baseline | `bun scripts/verify-harden-artifact.ts <apk>` | after every harden build | encrypted loader present & stored (H1/H2), container stored with valid magic (H3/H4), no key material in plaintext DEX (H5), shell manifest present (H6); `--expect-plain` asserts a *non*-hardened APK |
| Device acceptance | `bash scripts/device-test.sh <apk> <package> [--ks-relaunch]` | on real devices/emulators | install → 5 s-alive decrypt-and-launch loop, no integrity/BadTag markers, Keystore-binding relaunch, and the VMP-lite leaf assertion where enabled; full matrix and manual cases (re-sign must fail, offline challenge fail-closed, Frida) in `docs/device-testing.md`; threat surface and residual risks in the [threat model](docs/threat-model.md), build-level proof-of-attack in `scripts/attack-sample-resign.ts` (re-sign must fail, by construction) |

CI (`.github/workflows/ci.yml`) runs `tsc --noEmit` + full tests + an npm-pack whitelist smoke on every push/PR, plus a separate NDK job that compiles the generated native shell sources (including `guard_vote.c`) with a real NDK — the native path is no longer paper-only. Releases: `bun scripts/release.ts <version> [--sync]` runs local verification and creates a local git tag only; uploading (git push / npm publish) is always a deliberate human step.

**Honest boundary**: build-time green ≠ runtime correct. The device layer above is the only trustworthy acceptance, and it needs a device or emulator.

**Emulator acceptance record (2026-09)**: the first full emulator run (API 26 x86_64) *crashed on launch* despite 264/264 tests and the H1–H6 artifact baseline all being green — and fixing the first defect exposed the second, then the third. Three build-level defects that no static check could catch were found and fixed ([SEC-010](docs/security-ledger.md#sec-010--patched-payload-dex-fails-art-checksum-verification-critical) checksum/signature ordering, [SEC-011](docs/security-ledger.md#sec-011--method-extraction-stub-leaves-non-zero-padding-at-section-boundary-critical) non-zero section padding from extraction stubs, [SEC-012](docs/security-ledger.md#sec-012--identifier-randomization-breaks-dex-string_ids-ordering-critical) out-of-order string_ids from identifier randomization). Re-test after all three fixes: install PASS, first launch PASS, second launch PASS, zero logcat failure markers, clean uninstall (D1/D2/D3/D5). This is the concrete proof behind the honest boundary above: the device layer is the only one that catches this defect class.

## Research use and reproducibility

The figures in this README are schematics, not measured results. For any claim, record the exact tag or commit, host OS, JDK/Android SDK/Build Tools versions, input APK SHA-256 and output artifact SHA-256. Reproducible harnesses live under [`benchmark/`](benchmark/README.md); security fixes and residual risks are tracked in the [Security Ledger](docs/security-ledger.md) and the [threat model](docs/threat-model.md). When citing DroidSeal, cite the exact tag and commit rather than a moving `main` branch.

## Security boundary

A defensive tool: by default it does not unpack, pack, or inject hooks / anti-debug code; it runs fully locally and never uploads APKs, paths or signing information.

**Exception — APK hardening mode (explicit opt-in)**: when you pass an APK with the hardening flags above, DroidSeal *does* pack (DEX encryption + bootstrap shell injection into **your own release APK**) and embeds anti-analysis detection. This mode only ever modifies the APK you explicitly supply as input; the default audit/release flows keep the no-packing boundary.

## Architecture, innovation & self-developed parts

### Innovation highlights

1. **Fully self-developed APK format handling**: parsing and rewriting of the ZIP central directory, ARSC resource table, AXML, DEX and ELF are all self-implemented at the byte level — no heavy parser dependencies (supply-chain convergence, clear failure semantics);
2. **Deterministic post-processing**: unchanged ZIP entries reuse the original compressed bytes, reducing unexpected churn in repacking / recompression / signing digests;
3. **Failure rollback**: each step keeps an independent APK artifact; "skip and roll back" preserves the last valid artifact before the step;
4. **Self-developed anti-debug stub** (C + Kotlin + CMake, optional source integration);
5. **Auditable results**: signature verification + SHA-256 + JSON/Markdown reports + CycloneDX SBOM + confidence-aware release gate;
6. **Pure local-first**: never uploads APKs, paths or signing information; by default no unpacking, packing or injection;
7. **Single binary, three channels**: Bun-compiled single-file executable with zero runtime npm dependencies; same-source release on npm / PyPI / GitHub Releases;
8. **Bilingual TUI + three entry points** (step-by-step / one-click / diagnosis).

### Self-developed vs third-party calls

- **Self-developed** (business core): `src/core` (139 modules — ZIP/DEX/ELF/ARSC/AXML parsing and audit, pipeline orchestration, signing strategy, release gate, taint dataflow, VMP-lite compiler, JNI dynamic-register recovery), `src/ui` (TUI + i18n), the anti-debug stub, `scripts` (build/release/gate/bench scripts), and the dual launchers;
- **Third-party** (rendering/build layer): OpenTUI (terminal rendering), Solid.js (reactive UI), Terser (build minification, optional web JS only), TypeScript/Bun (toolchain), and external Android tools (keytool/Gradle/zipalign/apksigner/aapt — orchestrated through self-developed discovery and verification).

### Pipeline stages and ownership

Figure 1 is the canonical overview. The table records the ownership boundary for each phase; external tools are invoked only where the Android toolchain mandates them.

| Phase | Steps | Self-developed | External tool |
|---|---|---|---|
| Diagnose | 1–2 | environment/tool discovery, workspace preparation, input validation | — |
| Signing material | 3 | credential safety, redaction | keytool |
| Audit | 4, 6 | project and APK audit (ZIP/DEX/ELF/ARSC/AXML), evidence and confidence | aapt supplement |
| Build and transform | 5, 8–10 | manifest/debug normalization, ARSC obfuscation, Web JS allowlist and atomic write | Gradle Wrapper; Terser (optional) |
| Evidence shield | 7 | evidence and confidence handling | — |
| Seal | 11–12 | key handling/redaction, signing orchestration | zipalign, apksigner |
| Verify | 13 | SHA-256, signature and certificate cross-check | apksigner verify |
| Report | 14 | JSON/Markdown/SARIF/SBOM, release gate, remediation | — |

All format parsing, rewriting, auditing and reporting are self-developed. Rendering uses OpenTUI/Solid; external tools are called only in officially mandated steps and are orchestrated through self-developed discovery, SHA-256 verification and graceful degradation.

## License & brand

- Open-source license: [Apache License 2.0](https://github.com/noontiger/droidseal/blob/main/LICENSE)
- Name and logo usage: [TRADEMARKS.md](https://github.com/noontiger/droidseal/blob/main/TRADEMARKS.md) (attribute the source in reviews, tutorials and sharing)
- Third-party notices: [THIRD_PARTY_NOTICES.md](https://github.com/noontiger/droidseal/blob/main/THIRD_PARTY_NOTICES.md)

<img src="https://raw.githubusercontent.com/noontiger/droidseal/main/droidseal-logo.png" width="420" alt="DroidSeal" />
