# DroidSeal Security Policy

[中文](SECURITY.zh-CN.md) | [English](SECURITY.md)

DroidSeal processes Android application artifacts, invokes external tools, and handles signing credentials, so security reports are handled with high priority.

## Supported versions

| Version | Support status |
| --- | --- |
| Latest release | Supported |
| Previous release | Best effort |
| Older versions | Not supported |
| Development snapshots | No compatibility commitment |

The project is now at `1.0.1` stable — the CLI, output layout and report formats are stable. Security fixes are applied to the latest release first; the support scope will adjust as the project matures.

## Reporting vulnerabilities privately

Do not report security vulnerabilities through public Issues, Discussions, Pull Requests, or social media.

Once the official repository enables Private Vulnerability Reporting, please use:

<https://github.com/noontiger/droidseal/security/advisories/new>

Until that private channel is enabled, first request a private contact through a verified GitHub account of a maintainer; do not send vulnerability details, attachments, or credentials until a secure channel is confirmed. The project currently publishes no security email address, so do not guess or use unconfirmed addresses.

Reports should include where possible:

- the affected DroidSeal version or commit;
- OS, architecture, terminal, and shell;
- Bun, JDK, Android SDK, and Build Tools versions;
- minimal reproduction steps, expected and actual behavior;
- the security impact and whether real exploitation was observed;
- proof-of-concept files with secrets and private data removed.

Do not send production signing keys, real keystore passwords, private customer APKs, access tokens, proprietary source code you are not authorized to disclose, or unrelated personal data.

## Security issue scope

Including but not limited to:

- shell, argument, command, or environment variable injection;
- path traversal, unsafe path normalization, or arbitrary file overwrite;
- ZIP path, duplicate entry, archive confusion, or extraction issues;
- signature verification bypasses or wrong artifact selection;
- leakage of credentials, passwords, certificate subjects, or local paths;
- report and log redaction failures;
- unexpected network communication;
- insecure tool downloads or checksum verification;
- temporary file disclosure, race conditions, or privilege escalation;
- unauthorized code execution from malicious project or APK input;
- supply chain risks of official releases.

## Handling goals

Maintainers plan to:

1. acknowledge receipt of a valid report within 7 days;
2. confirm affected versions and complete an impact assessment;
3. prepare fixes and regression tests;
4. coordinate release and disclosure timing;
5. publish a security advisory and recommend credential rotation when necessary;
6. thank reporters after release unless they request anonymity.

These are project goals and do not constitute a service level agreement.

## Adversarial regression policy

Every accepted security fix **must** come with a regression test that reproduces the fix's *trigger condition* — the specific input or state that set off the defect — not merely a test of the corrected behavior. The test lands in `tests/security-regression.test.ts` (or the nearest existing suite), is headed `SEC-XX`, and documents three things:

1. **Trigger condition** — what input/state detonated the old defect;
2. **Old symptom** — what went wrong before the fix;
3. **Fix semantics** — what changed so it no longer does.

The test must be red against the pre-fix code (verify locally by reverting the fix, not the test) and green after. This is the same discipline as the URL false-positive regression (C2): a patch-class bug passed E2E by returning `patchedUrl=true` while corrupting the DEX — only a byte-level test of the trigger caught it. Structural assertions against generated sources (e.g. no `PTRACE_TRACEME` call in `guard_vote.c`) are acceptable where runtime behavior needs a device; each such assertion must still encode the trigger, not just the desired shape.

All accepted security fixes are tracked publicly in the [Security Ledger](docs/security-ledger.md) (SEC-001 onwards) — trigger condition, old symptom, fix semantics, and regression location for each. Artifact/build-time defects (e.g. SEC-009) may anchor their regression in the artifact acceptance baseline or a script check instead — the ledger entry must state the regression location, and a mismatch between entry and location is itself a regression defect.

## Coordinated disclosure and security research

Please give maintainers reasonable time to investigate and fix. Good-faith research should target only applications and systems the researcher is authorized to test, avoid accessing others' data, damaging files or devices, disrupting services, and using stolen or unauthorized signing credentials.

Good-faith research that complies with this policy, avoids privacy violations, and avoids destructive activity will be handled constructively. This statement does not create contractual obligations and does not supersede applicable law.

## User security reminders

- Only process APKs or projects you own or are authorized to handle.
- Back up release keys offline; do not keep them in project or output directories.
- Review local input and output paths in reports before sharing them.
- Read and accept the license terms of Android/JDK tools before auto-downloading them.
