# DroidSeal Threat Model · Hardening Layer

[中文](threat-model.zh-CN.md) | [English](threat-model.md)

This document describes the attack surface, defenses, and **honestly stated residual risks** of the DroidSeal hardening layer (P0-A/B/C, P1, P2). The principle matches the whole project: capabilities that are not implemented are not claimed; runtime behavior that cannot be verified at build time is labeled as such.

**Scope**: hardened artifacts only (explicit opt-in release-APK hardening via the `harden` pipeline). The audit / signing / verification flows involve no runtime defenses and are out of scope.

**Adversary model** (weakest to strongest):

| Level | Adversary | Capabilities |
|---|---|---|
| A | Script kiddie | Public repack / re-sign / resource-tamper tools |
| B | Dynamic analyst | Frida/Objection attach, hooks, memory read/write; no root or temporary root |
| C | Reverse engineer | IDA/Ghidra static analysis, custom Frida scripts, persistent root |
| D | Nation-state / well-resourced | Custom ROMs, kernel-level tooling, hardware debug, unlimited time |

**Defense goal**: A always fails; B's routine paths produce *wrong results* rather than bypassable warnings; C's cost rises significantly. **D is explicitly out of scope.**

---

## Attack surface → Defense

### AT-1 · Repack / re-sign (adversary A)

**Attack**: modify APK contents (inject code, tamper resources, strip checks), re-sign with an own key, redistribute.

**Defense (P0-A integrity anchor)**: the SHA-256 of the final binary `AndroidManifest.xml` is computed at pipeline Step 4 and folded into the HKDF info of **every entry** (`dex-N` / `citable` / `so` alike). At runtime `computeIntegrityAnchor` recomputes and compares. Any repack changes the manifest → derived keys differ from encryption-time keys → AES-256-GCM authentication fails → silent decryption failure (fail-closed).

**Nature**: keyed — patching the comparison logic cannot "pass the check", because the check result *is* part of the key material; there is no "verification failed but decrypt anyway" path.

### AT-2 · Debugger / Frida attach (adversary B)

**Attack**: attach Frida or a debugger without modifying the APK; read keys or plaintext DEX from memory at runtime.

**Defense (P0-B environment gate + P1 three-source vote)**: at startup, three heterogeneous sources vote — Java side (`DroidSealGuard`), native side (a forked child reads the parent's `/proc/<ppid>/status` TracerPid + Frida port probe 27042/27043 + maps scan), and the debuggable flag. The vote is folded into the HKDF info as the `-e<vote>` suffix: a hit ⇒ wrong keys ⇒ silent GCM failure.

**Nature**: hooking one source leaves the other two polluting the vote; hooking all sources restores a "clean" derivation (see AT-4). Without attach, everything runs normally — false-positive control is covered in residual risk R-1.

### AT-3 · Static analysis (adversary B/C)

**Attack**: open the APK in jadx/Ghidra and read DEX bytecode directly.

**Defense (three stacked layers)**:
1. **Method hollowing**: CodeItems are emptied; method bodies live in an encrypted CodeItem table (`citable` entry, its own per-entry derived key) inside the container, restored at runtime via an ART DefineClass hook. Hollowing coverage is quantified per build (`DEX_METHOD_HOLLOW` finding: `hollowed/total`) — never claimed as "full protection".
2. **Whole-DEX encryption**: the loader DEX (keys + decryption logic) is AES-256-GCM encrypted with an HKDF(certificate-digest)-derived key and stored as a `.ldx` asset (stored); the plaintext `classes.dex` contains only a bootstrap stub with randomized class names.
3. **Identifier randomization**: stub/loader identifiers are randomized per build, killing static signature-based location.

**Nature**: static analysis never sees complete plaintext — the CodeItem table and the DEX live under different per-entry keys.

### AT-4 · Patching out the detection (adversary C)

**Attack**: locate the detection code and patch it (smali/binary) so the environment "looks clean".

**Defense**: this is the core of P0-B — patching the detection *restores the correct key derivation*, so the attacker ends up with an artifact identical to the original: no gain. But the patch itself modifies the DEX/manifest → triggers the AT-1 anchor → wrong keys. The two paths cross: patching detection requires also bypassing the anchor (i.e. repacking), and the anchor cannot be patched (keys were fixed at encryption time). The attacker must either re-encrypt the whole package (equivalent to reimplementing the shell) or give up.

**Honest boundary**: see R-3 — a level-C adversary can eventually dump the plaintext from memory.

### AT-5 · Key extraction (adversary C)

**Attack**: memory scanning for the complete master key.

**Defense (P0-C sharding)**: the master never resides in memory — three-part `part1 ⊕ part2 ⊕ part3`; part2 can live inside the native SO (CI compiles it with a real NDK), part3 can be stripped from the APK entirely (P2); at runtime it is synthesized per entry → derived → immediately zeroed; decrypted DEX buffers are zeroed right after class loading.

**Nature**: no complete master at any instant; but see R-3 on the dump window.

### AT-6 · Device redistribution (adversary A/B)

**Attack**: extract the artifact on a legitimately licensed device and run it elsewhere.

**Defense (optional `--keystore-bind`)**: after the first successful decryption, the pre-XOR part1′ is sealed with the Android Keystore and the embedded value is wiped; reinstall / data-clear / device change invalidates it → decryption fails. Compatible with the P2 challenge mode (the sealed value and XOR order are strictly consistent — fixed by SEC-003).

**Nature**: one-device-one-copy is a product semantic, not a bug — it must be disclosed to end users at release (already stated in the README/CLI warning).

---

## Residual risks (honest, not eliminable)

| # | Risk | Level | Notes |
|---|---|---|---|
| R-1 | Environment false positives | Low | The Frida port probe (27042/27043) may misfire when multiple instances run on one device — technically unavoidable, honestly stated in the README; the failure mode is "decryption fails", not a crash, and can be verified by removing Frida |
| R-2 | Port probe cannot attribute target | Low | Cannot distinguish "Frida against this app" from "Frida against another app on the same device" — conservatively designed (prefer false kills over misses) |
| R-3 | Memory dump | **Not fully preventable** | With root + sustained physical access, a level-C adversary can dump the decrypted DEX (the plaintext window is minimized by "zero right after class loading", but the window exists); the key must briefly exist complete in memory at derivation time. **This is the shared ceiling of every non-VMP / non-white-box scheme**; this project deliberately does not invest in white-box AES / VMP (high cost, poor compatibility, and still breakable by level-D) |
| R-4 | Delayed self-destruct can be bypassed | Low | Hooking `System.exit` skips the delayed kill — but the bypassed session is already flagged, keys are still wrong, no information leaks |
| R-5 | minSdk<26 disk-fallback path | Low | API<26 falls back to a on-disk DexClassLoader; the encrypted loader file can be extracted on root (what is extracted is ciphertext, and the stored direct-read premise is enforced by artifact baseline H2) |
| R-6 | Deeply customized ROMs | Low | The ActivityThread reflection may return null on exotic ROMs — mitigated by appContext-first injection + fail-closed (no crash, decryption fails) |
| R-7 | Challenge endpoint availability | Mode-specific | With `--challenge-url`, the endpoint is a runtime dependency: offline / endpoint lost ⇒ decryption fails (fail-closed, no downgrade); losing `server-challenge.json` makes that build permanently undecryptable — keep an offline backup |
| R-8 | Device matrix not yet executed | Verification | Everything verifiable at build time is green (264 tests + H1–H6 baseline + CI NDK compile). **Emulator acceptance (API 26 x86_64, 2026-09) completed**: first run crashed on launch despite all build-time green — three chained build defects found & fixed ([SEC-010/011/012](security-ledger.md)); after fixes D1/D2/D3/D5 PASS incl. second-launch recheck. Not yet covered: real-device matrix, KS-binding relaunch (D4), API 24 disk-fallback path — see `docs/device-testing.md` (test record included) |

## Honest comparison of defense strength vs. peers

| Capability | This project | Typical OSS shell | Commercial |
|---|---|---|---|
| Anchor / environment folded into derivation (keyed) | ✓ | ✗ (detect → warn) | partial |
| Three-source heterogeneous vote | ✓ | mostly single-source | ✓ |
| Key sharding + part3 out of the APK | ✓ | ✗ | partial (cloud) |
| Method-hollowing coverage quantified | ✓ (per build) | vague | not published |
| VMP / white-box | ✗ (deliberately not done) | partial | ✓ |
| Public device matrix | suite + first emulator record (2026-09, D1/D2/D3/D5 PASS after SEC-010~012 fixes) | none | not published |

## Change management

- Discipline: security fixes go through the [public security ledger](security-ledger.md) (SEC-XX); new defense layers update this document in the same change.
