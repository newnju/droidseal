# DroidSeal · Android Release Seal

**One command, end-to-end release security.** — a local-first Android release-security pipeline: static audit → hardening → release gate, for source and APK inputs, with a CLI, REST and TUI.

## What it does

- **Static audit** — 373 source detectors across ten dimensions (crypto, network, storage, components, permissions, I/O, config, lifecycle, privacy, concurrency), APK manifest/signing/DEX/ELF checks, 19 taint-flow analyses, 30 behavior rules, and a 30-entry offline supply-chain snapshot — with **confidence tiers, cross-evidence and precision gates** (confirmed before reported).
- **Hardening** — 18+ source-included generators: packer (DEX encryption), VMP instruction encoding, control-flow flattening, anti-debug + ptrace, integrity and environment checks, runtime no-trace protection, dead-code injection, native (so) obfuscation, Dex2C, and more.
- **Release gate** — pass/review/block decision, evidence package, CycloneDX SBOM, re-test closure, dual-mode and signing verification.
- **Reporting** — 7 formats, MASTG checklist and MASVS levels, semantic depth, hardening suggestions, POC, historical comparison.
- **Dynamic cross-check** — ADB bridge adds 8 runtime signals (device matrix, filtered logcat, UI smoke, crash/ANR, multi-device) attached back to static findings.
- **Benchmark-driven** — a 30-case evaluator reports precision/recall and accepts external DroidBench/OWASP directories.

## Quick start

```bash
npm install -g droidseal        # or: bun x droidseal
droidseal audit <source-or-apk> # one command, end to end
droidseal one-click             # TUI: audit → harden → release gate
```

## Platform

- Run platforms: Windows x64, Linux x64.
- Runtime dependencies: **zero**. Third-party packages are dev-time only; external tools (adb/apksigner/zipalign/aapt/dexdump/keytool/java/unzip) are invoked as user-side CLIs — not embedded, not distributed.

## Security boundary

- **Local-first** — no uploads, no model calls; supply-chain checks are offline snapshots.
- **Source-included hardening** — generators act at build time; unknown APKs are never rewritten post-hoc.
- **Report-only runtime checks** — anti-debug stubs report and never block unless EXIT is explicitly enabled.

## Innovation

Confirmed-before-reported precision semantics, the audit → harden → gate closure, the widest source-included hardening set outside commercial VMP/Dex2C, zero runtime dependencies, local-first privacy, and static–dynamic cross-validation.

## License & brand

MIT license. OWASP MASTG content is attributed (CC BY-SA).
