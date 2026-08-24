# DroidSeal · Android Release Seal

[中文](README.zh-CN.md) | [English](README.md)

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-181717.svg?logo=github&logoColor=white)](https://github.com/noontiger/droidseal/blob/main/LICENSE)
[![npm](https://img.shields.io/npm/v/droidseal.svg?logo=npm&logoColor=white&color=cb3837)](https://www.npmjs.com/package/droidseal)
[![PyPI](https://img.shields.io/pypi/v/droidseal.svg?logo=pypi&logoColor=white&color=3775a9)](https://pypi.org/project/droidseal)

**DroidSeal** handles most of what you can do before commercial hardening — environment diagnosis, source & APK audit, R8 obfuscation, zipalign alignment, apksigner signing and final verification. One command, end to end, before commercial hardening.

## What it does

- **Audit**: static audit of projects and APKs — permissions, targetSdk, signing schemes, hardcoded secrets, DEX/TLS heuristics, native `.so` hardening, third-party dependencies and a CycloneDX SBOM;
- **Release**: runs `zipalign → apksigner sign → verify` in the official order, with automatic rollback on failure and an independent artifact per step;
- **Artifacts**: APK + SHA-256 + JSON/Markdown reports + a release gate + SBOM.

<img width="960" alt="DroidSeal UI screenshot" src="droidseal-screenshot.png" />

## Install

| Channel | How |
|---|---|
| npm | `npm install --global droidseal` |
| PyPI | `pip install droidseal` |
| GitHub Releases | Download the Windows zip / Linux tar.gz directly |

> **Windows note**: if SmartScreen blocks the exe on double-click, right-click → Properties → Unblock. The TUI must run in a terminal: run `droidseal` in PowerShell, or double-click the bundled `droidseal-gui.cmd` launcher.

## Usage

```powershell
droidseal              # interactive TUI wizard (one-click / step-by-step)
droidseal doctor       # non-interactive environment diagnosis
droidseal --version
```

## Platform & status

- **Platform**: Windows x64 / Linux x64;
- **Status**: 1.0.0 stable — the CLI, output layout and report formats are now stable;
- **Software**: an ANSI/Unicode-capable monospace terminal is required for the TUI; Bun 1.3+ to run from source; JDK/Gradle/Android Build Tools are auto-discovered or downloaded per flow (Node only for Capacitor web builds);
- **Hardware (practical advice, not a hard floor)**: ~500 MB disk (100 MB executable + toolchain + artifacts), ≥2 GB RAM (more for large APKs — parsing is memory-sensitive with a fail-safe cap), x64 dual-core CPU.

## Security boundary

A defensive tool: by default it does not unpack, pack, or inject hooks / anti-debug code; it runs fully locally and never uploads APKs, paths or signing information.

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

- **Self-developed** (business core): `src/core` (30 modules — ZIP/DEX/ELF/ARSC/AXML parsing and audit, pipeline orchestration, signing strategy, release gate), `src/ui` (TUI + i18n), the anti-debug stub, `scripts` (build/release/gate scripts), and the dual launchers;
- **Third-party** (rendering/build layer): OpenTUI (terminal rendering), Solid.js (reactive UI), Terser (build minification, optional web JS only), TypeScript/Bun (toolchain), and external Android tools (keytool/Gradle/zipalign/apksigner/aapt — orchestrated through self-developed discovery and verification).

### Pipeline visualization (self/third-party per step)

The route bends top-to-bottom: the left column ①-⑦ runs downward, then folds at the bottom "flow" and the right column ⑧-⑭ runs upward (snake shape). Each step box is annotated "Self: …" or "Third-party: …".

```text
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ① Environment diagnosis        │      │ ⑭ Generate reports             │
│ Self: tool discovery/verify    │      │ Self: report/gate/SBOM/fix pack│
└────────────────────────────────┘      └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ② Prepare workspace            │      │ ⑬ Final verification           │
│ Self: input validation/copy    │      │ Third-party: apksigner verify  │
└────────────────────────────────┘      │ Self: SHA-256 calculation      │
                                        └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ③ Signing keystore             │      │ ⑫ Sign APK                    │
│ Third-party: keytool            │      │ Third-party: apksigner        │
│ Self: credential safety         │      │ Self: key handling/redaction  │
└────────────────────────────────┘      └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ④ Source security audit        │      │ ⑪ ZIP alignment               │
│ Self: project-audit/r8-rules   │      │ Third-party: zipalign          │
└────────────────────────────────┘      └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ⑤ Build release APK            │      │ ⑩ Resource obfuscation (opt.)  │
│ Third-party: Gradle Wrapper    │      │ Self: arsc-obfuscate           │
└────────────────────────────────┘      └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ⑥ APK security audit           │      │ ⑨ Web JS handling (opt.)       │
│ Self: ZIP/DEX/ELF/ARSC/AXML    │      │ Third-party: Terser minify     │
│ Third-party: aapt supplement   │      │ Self: allowlist/atomic write   │
└────────────────────────────────┘      └────────────────────────────────┘
                │                      ▲
                ▼                      │
┌────────────────────────────────┐      ┌────────────────────────────────┐
│ ⑦ Local security shield        │      │ ⑧ Release normalization       │
│ Self: evidence/confidence      │      │ Self: manifest rewrite/debug   │
└────────────────────────────────┘      └────────────────────────────────┘
               └────────► flow ──►────┘
```

All format parsing / rewriting / auditing / reporting is self-developed (offline, low supply-chain footprint); rendering uses OpenTUI/Solid (third-party); external tools are called only in officially mandated steps, always orchestrated through self-developed discovery, SHA-256 verification and graceful degradation.

## License & brand

- Open-source license: [Apache License 2.0](https://github.com/noontiger/droidseal/blob/main/LICENSE)
- Name and logo usage: [TRADEMARKS.md](https://github.com/noontiger/droidseal/blob/main/TRADEMARKS.md) (attribute the source in reviews, tutorials and sharing)
