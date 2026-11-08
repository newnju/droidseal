# Release process

This document is the maintainer checklist for the DroidSeal 1.1.0 release. It
is deliberately version-specific: the `1.1.0` release is frozen at tag `v1.1.0`;
later release trains must not be merged into it.

## 1. Release boundary

| Item | 1.1.0 |
|---|---|
| Tag | `v1.1.0` |
| Commit | `542b6aaa88efa4723fed52878d1793706f8340d2` |
| Package version | `1.1.0` |
| Source of truth | the tag, not a development branch or `HEAD` |
| Release notes | `docs/releases/v1.1.0.md` and `.zh-CN.md` |

Build every 1.1.0 artifact from an isolated worktree:

```bash
git worktree add ../droidseal-1.1.0 v1.1.0
cd ../droidseal-1.1.0
```

Do not build 1.1.0 from a dirty tree, a development branch, or `HEAD`.
Do not add features, evidence, or known issues from other versions to the 1.1.0
notes.

The `v1.1.0` tag must point at the frozen release commit. If a release gate
fails **before** any GitHub, npm or PyPI artifact is published, fix forward and
recreate the tag once; after publication, never force-move the tag.

### Tag annotation

The exact tag message is versioned in
`docs/releases/v1.1.0.tag-message.txt`. After the documentation commit is final,
recreate the local annotated tag from that file:

```bash
git tag -a v1.1.0 -F docs/releases/v1.1.0.tag-message.txt
```

The tag object records the target commit, so the message does not need a commit
hash. Prefer a signed tag (`git tag -s`) when signing infrastructure is
available. Otherwise publish the annotated tag together with release notes and
checksums. Do not put unverified benchmark numbers or capabilities outside this
release in the tag message.

## 2. Version and metadata alignment

Before building, verify all of these say `1.1.0`:

- [ ] `bun --version` is `1.3.14` (matches `packageManager`; the build rejects other versions)
- [ ] `package.json` `version`
- [ ] `pyproject.toml` `project.version`
- [ ] `droidseal/__init__.py` `__version__`
- [ ] `CHANGELOG.md` `## [1.1.0]`
- [ ] `docs/releases/v1.1.0.md`
- [ ] Git tag `v1.1.0` points at the intended commit
- [ ] release-note `Base commit` matches the 1.1.0 code commit
- [ ] GitHub Release title
- [ ] npm/PyPI package pages after publish

Also verify:

- [ ] canonical repository URLs are `https://github.com/newnju/droidseal`
- [ ] no `noontiger` URLs remain in README/package metadata
- [ ] README and README.zh-CN.md describe the same 1.1.0 scope
- [ ] no capabilities outside 1.1.0 appear in 1.1.0 docs
- [ ] release-facing 1.1.0 docs do not name versions later than 1.1.0
- [ ] `SECURITY.md` support table names `1.1.0`

## 3. Claim audit (blocking)

- [ ] Run the release gate: `bun run check`, `bun test`, `bun run build`,
      `bun run build:node`, `bun run release:check`.
- [ ] Confirm detector/test counts against the tag: `SOURCE_DETECTORS.length`
      = 391 entries (390 unique codes), and `bun test` = 387 passing tests.
      Use 391/387 in the 1.1.0 release notes. Do not rewrite historical
      CHANGELOG round counts that describe an earlier snapshot.
- [ ] Run a keyed smoke test on the exact 1.1.0 artifact.
- [ ] Confirm that flags not implemented in 1.1.0 are not documented as 1.1.0:
      `--keystore-bind`, `--challenge-url`, `--loader-self-hash`,
      `--restore-mode`, VMP-lite.
- [ ] Confirm every benchmark number has version, commit, date, device/emulator
      and measurement criteria.
- [ ] Do not use benchmark numbers or known issues from other versions in 1.1.0.

## 4. Build and package

```bash
bun install --frozen-lockfile
bun run check
bun test
bun run build          # Windows artifact; archive dist/ before the Linux build
# build Linux on a Linux host, then merge both platform trees into dist/
bun run build:node
bun run release:check
npm pack --dry-run
npm pack
```

For PyPI, the wheel must be built from a merged Windows + Linux `dist/` tree.
Do **not** use a bare `python -m build`: it produces a wheel without
`droidseal/_bin` because `_bin` is generated. Use the project script:

```bash
bun run py:wheel
python -m twine check dist-wheel/*.whl
```

`scripts/py-wheel.ts` copies `dist/` into `droidseal/_bin` and builds the
merged payload. `scripts/split-py-wheel.py` then emits two native wheels:
`py3-none-win_amd64` and `py3-none-manylinux_2_17_x86_64`. The Linux wheel
preserves the executable bit on `droidseal/_bin/droidseal`.

Check that the npm tarball contains the launcher, built bundle, runtime DEX
files, README, LICENSE, NOTICE, CHANGELOG and SECURITY. Check that each wheel
contains its platform's `droidseal/_bin` payload (the executable, build metadata
and OpenTUI library) and the notices.

## 5. Release artifacts

Attach to the GitHub Release:

- [ ] Windows x64 zip
- [ ] Linux x64 tar.gz
- [ ] `SHA256SUMS`
- [ ] CycloneDX bundle SBOM (inside each archive at
      `third-party/bundle-sbom.cdx.json`)
- [ ] signatures or provenance attestations, only if the release workflow
      actually produces them

Generate digests from the final artifacts, not from intermediate builds. Do not
hardcode checksums in README or release notes until the final artifacts exist.

## 6. Publish order

1. Create/verify the GitHub Release draft from tag `v1.1.0`.
2. Attach artifacts and checksums.
3. Publish the GitHub Release.
4. Publish npm: `npm publish --access public`. Add `--provenance` only when
   publishing from the GitHub Actions OIDC context.
5. Publish both PyPI wheels with
   `python -m twine upload dist-wheel/*.whl` (or Trusted Publishing).
6. Verify clean installs:

```bash
npm install --global droidseal@1.1.0
droidseal --version

python -m venv /tmp/droidseal-1.1.0
/tmp/droidseal-1.1.0/bin/pip install droidseal==1.1.0
/tmp/droidseal-1.1.0/bin/droidseal --version
```

Expected output: `1.1.0`.

## 7. Post-release

- [ ] Confirm `latest` points to `1.1.0` on npm and PyPI.
- [ ] Confirm README badges resolve.
- [ ] Confirm `docs/releases/v1.1.0.md` links resolve on GitHub and npm/PyPI.
- [ ] Change the 1.1.0 status in `docs/releases/README.md` from `Prepared` to
      `Published` on the docs branch; do not move the published tag.
- [ ] Prepare later release notes separately; do not edit 1.1.0 retrospectively.
- [ ] If a correction is needed, publish an erratum or a patch release; never
      move a published tag.

## 8. Later release boundary

Any later release must be prepared on its own branch with its own version,
notes, evidence and tag. A patch release should contain fixes only; a release
that includes new user-visible capabilities should use a minor version unless
the project explicitly decides otherwise.
