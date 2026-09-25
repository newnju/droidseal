# DroidSeal Security Ledger

[中文](security-ledger.zh-CN.md) | [English](security-ledger.md)

Every accepted security fix in DroidSeal is recorded here: **trigger condition** (what input/state detonated the defect), **old symptom**, **fix semantics**, and **regression location**. This implements the [adversarial regression policy](../SECURITY.md#adversarial-regression-policy): each security fix must ship a `SEC-XX` test reproducing its trigger condition (red on pre-fix code, green after).

Why publish this: a security tool's credibility comes from *how it treats its own bugs*, not from claiming it has none. Commercial vendors don't publish fix details; open-source hardening projects generally have no fix-record discipline at all. This ledger lets users audit our response depth and fix quality.

> Reporting a vulnerability: do **not** open a public issue — use the private channel in [SECURITY.md](../SECURITY.md).

## Ledger

### SEC-001 · Native detection source self-sabotage (critical)

- **Origin**: internal security review (round 2, C1)
- **Trigger**: the old `guard_vote.c` source A used `PTRACE_TRACEME` self-check. The call has a permanent side effect — after success, the process itself is traced (TracerPid≠0).
- **Old symptom**: on a clean device, the Java-side `detectTracer` immediately read TracerPid≠0 and misjudged "being debugged" → killed within 3s of startup. **Reproduced on every device, every launch**.
- **Fix semantics**: source A now forks a child process that reads the parent's `/proc/<ppid>/status` TracerPid across processes — zero side effects, equivalent detection strength (any attach ⇒ non-zero), heterogeneous third vote preserved.
- **Regression**: [SEC-001 in `tests/security-regression.test.ts`](../tests/security-regression.test.ts) — generated native source (comments stripped) must not contain `PTRACE_TRACEME`/`ptrace(` and must implement `getppid`+`/proc/`+`TracerPid`; additionally compiled by the CI NDK job with a real NDK.

### SEC-002 · Challenge-URL patch false positive + out-of-bounds DEX corruption (critical)

- **Origin**: internal security review (round 1, C2)
- **Trigger**: three defects stacked — ① Java constant `SERVER_URL` was 126B vs the TS marker's 128B; ② `findMarker` hardcoded `MARKER_LEN=32`, comparing only the first 32 bytes; ③ runtime judged "unpatched" via `indexOf('#')`.
- **Old symptom**: a 32-byte partial hit reported `patchedUrl=true`, then the 128B write into a 126B slot overwrote 2 bytes (DEX structure corrupted); the legitimate trailing `#` padding was then misjudged as unpatched — **challenge-mode artifacts failed to decrypt 100% silently**, and E2E had been fooled by the false positive ("passing" while corrupted).
- **Fix semantics**: strict 128B on both sides; `findMarker` full-length matching; unpatched detection via `startsWith("DS_SRV_URL")` (tolerates legitimate trailing padding).
- **Regression**: 4 cases in [`tests/harden-chain.test.ts`](../tests/harden-chain.test.ts) (full-length match / invalid URL / IDN rejection / 32B false-positive guard) + SEC-002 (no master-key plaintext hex residue in loader DEX).

### SEC-003 · Keystore-binding + challenge combo bricked on second launch (high)

- **Origin**: internal security review (round 1, C3)
- **Trigger**: `--challenge-url` + `--keystore-bind` combined, with the old implementation sealing the *post-XOR* real part1.
- **Old symptom**: on second launch, unseal returned part1 which was XORed with part3 *again* → key permanently wrong → decryption failed. Combo-flag artifacts were **bricked on second launch, always**.
- **Fix semantics**: first launch seals the pre-XOR part1′; second launch unseals → XOR part3 → restores the real part1, exactly matching the first-launch path. Pure-local / KS-only paths unchanged.
- **Regression**: SEC-003 — source-order assertion: the seal site (`sealPart1(toSeal)`) must carry the `pre-XOR` semantic anchor nearby, preventing silent drift between implementation and comment.

### SEC-004 · debuggable input → permanently undecryptable, silently (high)

- **Origin**: internal security review (round 1, C4)
- **Trigger**: an input APK with `debuggable=true`. The environment vote (P0-B) treats debuggable as contamination → wrong derived keys.
- **Old symptom**: artifacts failed to decrypt **on every device**, with no indication (fail-closed by design, but a build accident for a legitimate input).
- **Fix semantics**: pipeline Step 3.1 — byte-length-preserving flip of debuggable (`flipDebuggableInAxml`), placed before Step 4 anchor computation (anchor covers the flipped value); emits a `HARDEN_DEBUGGABLE_FORCED` info finding.
- **Regression**: SEC-004 — an 80B minimal AXML asserts the flip is byte-length-preserving (AXML is offset-sensitive; any length change = corrupted artifact) and one-way idempotent (already-false ⇒ returns false, bytes untouched).

### SEC-005 · CLI flag swallowing (high)

- **Origin**: internal security review (round 2, R3)
- **Trigger**: adjacent flags like `--challenge-url --keystore-bind`; the old `getArg` unconditionally treated the next argument as the value.
- **Old symptom**: the flag name `--keystore-bind` was patched into the loader DEX as if it were a URL (the https:// validation rejected it, but the error was misleading); `collectMulti` had the same flaw.
- **Fix semantics**: `getArg`/`collectMulti` return undefined when the next argument starts with `--` → triggers the missing-value warning instead of swallowing.
- **Regression**: SEC-005 — getArg semantics test (adjacent flag ⇒ undefined / normal value / trailing flag).

### SEC-006 · Reference challenge server bound to all interfaces (high)

- **Origin**: internal security review (round 2, R2)
- **Trigger**: the old `scripts/challenge-server.ts` called `.listen(port)` without an address.
- **Old symptom**: listening on **all interfaces** — part3 (key material) exposed to the LAN while the startup log claimed `http://127.0.0.1`.
- **Fix semantics**: explicit `.listen(port, "127.0.0.1")` + log clarifying loopback-only and that public deployment belongs behind an HTTPS reverse proxy.
- **Regression**: SEC-006 — structural assertion: source contains the explicit loopback bind and no bare `.listen(port` call.

### SEC-007 · Non-ASCII URL corrupts the DEX (critical)

- **Origin**: internal security review (round 2, R1)
- **Trigger**: a challenge URL containing non-ASCII (IDN domains, e.g. `https://例え.jp`). The old padding used `padEnd` — counted in UTF-16 **characters**, while the DEX region is written in **bytes**.
- **Old symptom**: multi-byte characters made byte-length > char-length → `out.set` wrote out of bounds, corrupting the DEX (same class of damage as SEC-002, different trigger path).
- **Fix semantics**: validation enforces printable ASCII (`^[!-~]*$`) with a 128-byte cap; padding replaced by a fixed-size `Uint8Array(128)` + `fill(0x23)` — out-of-bounds is structurally impossible.
- **Regression**: SEC-007 (128B marker byte-level assertion) + the harden-chain IDN rejection case.

### SEC-008 · npm publish whitelist omission (medium)

- **Origin**: internal security review (round 1, C5)
- **Trigger**: `package.json` `files` whitelist lacked `runtime/droidseal-stub.dex` and `scripts/challenge-server.ts`.
- **Old symptom**: published npm package couldn't build the shell (missing stub DEX); users couldn't deploy a challenge endpoint (missing reference server).
- **Fix semantics**: whitelist completed; npm-pack whitelist smoke added to CI and the release flow.
- **Regression**: SEC-008 — asserts the smoke exists in **both** CI and release (protecting the check itself from being "cleaned up" later).

### SEC-009 · loader asset not stored in the APK (high)

- **Origin**: artifact acceptance baseline (H2 failed on its first run) — **the first catch of the baseline discipline**
- **Trigger**: harden-pipeline Step 13 declared the loader asset stored (`compressionMethod: 0`), but ZIP assembly only preserved stored for the *container* entry; the `.ldx` was deflated. The earlier same-class fix covered the container only; the loader slipped through.
- **Old symptom**: the artifact contradicted the pipeline's own declaration and findings; deflate buys nothing on high-entropy ciphertext while breaking the offset-direct-read premise of the minSdk<26 disk-fallback path.
- **Fix semantics**: ZIP assembly preserves stored for both container and loader by name.
- **Regression**: `scripts/verify-harden-artifact.ts` H2 (loader compressionMethod=0) — runs on every harden build; `--expect-plain` reverse assertion guards against false passes.

### SEC-010 · patched payload DEX fails ART checksum verification (critical)

- **Origin**: real-device acceptance (emulator, first successful boot attempt) — the class of defect every static check missed
- **Trigger**: `updateDexChecksum` computed Adler32 over bytes[12..] *before* writing the new SHA-1 signature — the freshly written signature invalidated the checksum that had just been computed. Affected both copies (`dex-protection.ts`, `dex-payload-inject.ts`); the loader/stub path was unaffected because `dex-model.recomputeDexChecksums` used the correct order.
- **Old symptom**: zygote refuses the DEX outright (`Failure to verify dex file: Bad checksum`), `ClassNotFoundException`, silent fail-closed crash. Build-time checksum recomputation tests passed because they tested the correct implementation, not the copy actually used.
- **Fix semantics**: signature first, checksum second (spec order); both copies now derive from the same ordering with comments citing SEC-010.
- **Regression**: byte-level assertion in the artifact baseline (payload DEX stored checksum == Adler32(content), SHA-1 sig == hash(content)); a runnable-emulator check would anchor in device-testing D2.

### SEC-011 · method-extraction stub leaves non-zero padding at section boundary (critical)

- **Origin**: same emulator run as SEC-010 — chained failure exposed after the checksum fix
- **Trigger**: the extraction stub shrank `insns_size` from N to 1 and wrote a 2-byte `return-void`, leaving the original instruction bytes after the stub as residual garbage. ART requires zero padding before section starts (`Non-zero padding 20 before section start at 2eb96` → reject). Additionally, methods with `tries_size > 0` would lose their exception tables on restore.
- **Old symptom**: harden pipeline passes all baseline checks (byte footprint changes never validated against ART's alignment rules); device shows silent fail-closed crash.
- **Fix semantics**: footprint-preserving stub — `insns_size` kept, instructions replaced with `return-void` + `nop` fill (byte-identical item size, offsets/alignment untouched, restore logic unchanged); `tries_size > 0` methods skipped from extraction (restore semantics preserved, coverage honestly reported via finding).
- **Regression**: byte-level assertion (extracted code items keep original footprint: `insns_size` unchanged, residual bytes all `nop`/`return-void`); extraction finding reports the skipped-tries count.

### SEC-012 · identifier randomization breaks DEX string_ids ordering (critical)

- **Origin**: same emulator chain — third sequential defect, each revealed only by fixing the previous
- **Trigger**: equal-length byte replacement of class/resource names did not preserve the DEX-mandated lexicographic order of `string_ids` (UTF-16 codepoint order). ART verifies strictly: `Out-of-order string_ids` → reject. Three sub-flaws: (a) slot neighbors queried with the bare class path while the table stores `L...;` form (binary search always missed → slot treated as unconstrained); (b) independent per-item slot constraints are insufficient when multiple renamed items' intervals overlap (each individually legal, mutually interleaved); (c) printable-ASCII candidates include characters JLS/ART reject in class names.
- **Old symptom**: randomized builds passed every build-time check; device rejects the DEX. Reproducible ~always for resource names with tight neighbors (`droidseal.bin` between `droidseal-entry-` / `droidseal.original_app`), probabilistically for class paths.
- **Fix semantics**: order-preserving slot construction — neighbors read via the exact table form, names generated inside `(prev, next)` per position over a legal charset (JLS set ∪ original-name chars), multi-item batches generated under cascade constraints (items sorted by table order, batch-level relative-order validation with whole-batch retry); on unsolvable slots the item (or batch) is left with its original name and honestly reported via `missed` (functionality intact, static signature persists — stated).
- **Regression**: `tests/harden-chain.test.ts` stub/loader randomization tests now assert 4/4 hits *and* full table order on the output DEX; batch combined-run (rename + identifiers + stub × 12) verified order-clean before landing.

- New fixes append a `SEC-XX` entry + test per the [adversarial regression policy](../SECURITY.md#adversarial-regression-policy); numbers increase monotonically and are never reused.
- SEC-001~008 map one-to-one to `tests/security-regression.test.ts`; artifact/build-time defects (e.g. SEC-009) may anchor their regression in the artifact acceptance baseline or script checks instead — the entry must state the regression location. A mismatch between entry and regression location is itself a regression defect.
- No CVE numbers yet (not requested); entry IDs are the internal tracking identifiers.
