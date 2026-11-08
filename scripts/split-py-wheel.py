#!/usr/bin/env python3
"""Split the merged DroidSeal wheel into Windows and Linux platform wheels.

`bun run py:wheel` builds one wheel from a merged `dist/` directory that
contains both platform binaries.  A wheel built on Windows is tagged
`win_amd64`, so Linux users would never receive it.  This script repacks the
same payload into two native platform wheels, preserving the Linux executable
bit and refreshing the wheel RECORD.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import re
import shutil
import tempfile
import zipfile
from pathlib import Path

WINDOWS_TAG = "win_amd64"
LINUX_TAG = "manylinux_2_17_x86_64"


def _record_hash(data: bytes) -> str:
    return base64.urlsafe_b64encode(hashlib.sha256(data).digest()).decode("ascii").rstrip("=")


def _should_drop(filename: str, platform: str) -> bool:
    if platform == "windows":
        # Keep the Linux-only files out of the Windows wheel, including the
        # Linux executable and its native library.
        return filename == "droidseal/_bin/droidseal" or filename.startswith(
            (
                "droidseal/_bin/droidseal-build.linux.json",
                "droidseal/_bin/@opentui/core-linux-x64/",
            )
        )
    return filename == "droidseal/_bin/droidseal.exe" or filename.startswith(
        (
            "droidseal/_bin/droidseal-build.json",
            "droidseal/_bin/@opentui/core-win32-x64/",
        )
    )


def _wheel_name(base: Path, tag: str) -> str:
    match = re.match(r"^(?P<prefix>.+)-py3-none-[^.]+\.whl$", base.name)
    if not match:
        raise SystemExit(f"unexpected wheel name: {base.name}")
    return f"{match.group('prefix')}-py3-none-{tag}.whl"


def _build_variant(base: Path, out: Path, platform: str, tag: str) -> Path:
    target = out / _wheel_name(base, tag)
    temporary = target.with_suffix(".whl.tmp")
    if temporary.exists():
        temporary.unlink()

    with zipfile.ZipFile(base) as zin:
        entries = [(info, zin.read(info.filename)) for info in zin.infolist()]

    kept: list[tuple[zipfile.ZipInfo, bytes]] = []
    for info, data in entries:
        if _should_drop(info.filename, platform):
            continue
        if info.filename.endswith("/WHEEL"):
            text = data.decode("utf-8")
            text = re.sub(r"(?m)^Tag: .*$", f"Tag: py3-none-{tag}", text)
            data = text.encode("utf-8")
        kept.append((info, data))

    record_name = next(
        (info.filename for info, _ in kept if info.filename.endswith(".dist-info/RECORD")),
        None,
    )
    if record_name is None:
        raise SystemExit("base wheel has no RECORD")

    record_lines: list[str] = []
    for info, data in kept:
        if info.filename == record_name or info.filename.endswith("/"):
            continue
        record_lines.append(
            f"{info.filename},sha256={_record_hash(data)},{len(data)}"
        )
    record_lines.append(f"{record_name},,")
    record_data = ("\n".join(record_lines) + "\n").encode("utf-8")

    with zipfile.ZipFile(temporary, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zout:
        for info, data in kept:
            if info.filename == record_name:
                data = record_data
            out_info = zipfile.ZipInfo(info.filename, date_time=info.date_time)
            out_info.compress_type = zipfile.ZIP_DEFLATED
            out_info.create_system = 3
            out_info.external_attr = info.external_attr
            out_info.comment = info.comment
            out_info.extra = info.extra
            if info.filename == "droidseal/_bin/droidseal":
                out_info.external_attr = (0o100755 << 16)
            elif info.filename == "droidseal/_bin/droidseal.exe":
                out_info.external_attr = (0o100644 << 16)
            zout.writestr(out_info, data)

    if target.exists():
        target.unlink()
    temporary.replace(target)
    return target


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("wheel_dir", type=Path)
    args = parser.parse_args()
    out = args.wheel_dir.resolve()
    wheels = sorted(out.glob("droidseal-*.whl"))
    if len(wheels) == 2 and any(WINDOWS_TAG in path.name for path in wheels) and any(
        LINUX_TAG in path.name for path in wheels
    ):
        print("[ok] platform wheels already split")
        return 0
    if len(wheels) != 1:
        raise SystemExit(f"expected exactly one merged wheel in {out}, found {len(wheels)}")

    base = wheels[0]
    with tempfile.TemporaryDirectory(dir=out) as temporary_directory:
        merged = Path(temporary_directory) / base.name
        shutil.copy2(base, merged)
        windows = _build_variant(merged, out, "windows", WINDOWS_TAG)
        linux = _build_variant(merged, out, "linux", LINUX_TAG)
    if base not in (windows, linux):
        base.unlink()
    print(f"[ok] wheel: {windows}")
    print(f"[ok] wheel: {linux}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
