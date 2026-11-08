"""Generate the DroidSeal 1.1.0 release architecture figure.

Outputs:
  docs/assets/droidseal-architecture.svg
  docs/assets/droidseal-architecture.png
"""

from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Rectangle

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "assets"
OUT.mkdir(parents=True, exist_ok=True)

plt.rcParams.update(
    {
        "font.family": "serif",
        "font.serif": ["Times New Roman", "DejaVu Serif"],
        "font.size": 8,
        "text.color": "#1f2933",
        "axes.edgecolor": "#1f2933",
        "svg.fonttype": "path",
        "pdf.fonttype": 42,
    }
)

INK = "#1f2933"
MUTED = "#5b6770"
SELF_FILL = "#e7f0f1"
SELF_EDGE = "#2f6f73"
THIRD_FILL = "#f7f1e3"
THIRD_EDGE = "#9a7b3f"
OPT_FILL = "#f2edf7"
OPT_EDGE = "#6b4f8a"
EVID_FILL = "#eef2f7"
EVID_EDGE = "#4a5d73"
PANEL_FILL = "#fcfcfc"
PANEL_EDGE = "#d7dce0"

fig = plt.figure(figsize=(14, 8.0), facecolor="white")
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, 14)
ax.set_ylim(0.70, 8.55)
ax.axis("off")


def rounded(x, y, w, h, fc, ec, lw=0.8, ls="-", rad=0.05, z=2):
    patch = FancyBboxPatch(
        (x, y),
        w,
        h,
        boxstyle=f"round,pad=0.012,rounding_size={rad}",
        facecolor=fc,
        edgecolor=ec,
        linewidth=lw,
        linestyle=ls,
        zorder=z,
    )
    ax.add_patch(patch)
    return patch


def box(x, y, w, h, title, sub=None, style="self", lw=0.8):
    if style == "self":
        fc, ec = SELF_FILL, SELF_EDGE
    elif style == "third":
        fc, ec = THIRD_FILL, THIRD_EDGE
    elif style == "opt":
        fc, ec = OPT_FILL, OPT_EDGE
    else:
        fc, ec = EVID_FILL, EVID_EDGE
    rounded(x, y, w, h, fc, ec, lw=lw)
    if sub:
        ax.text(x + w / 2, y + h * 0.62, title, ha="center", va="center", fontsize=8.3, fontweight="bold", zorder=3)
        ax.text(x + w / 2, y + h * 0.26, sub, ha="center", va="center", fontsize=7.1, color=MUTED, zorder=3)
    else:
        ax.text(x + w / 2, y + h / 2, title, ha="center", va="center", fontsize=8.1, fontweight="bold", zorder=3)


def panel(x, y, w, h, label, number):
    rounded(x, y, w, h, PANEL_FILL, PANEL_EDGE, lw=0.7, rad=0.07, z=1)
    ax.text(x + 0.12, y + h - 0.18, f"{number:02d}", ha="left", va="center", fontsize=8.0, color=MUTED, fontweight="bold", zorder=3)
    ax.text(x + 0.40, y + h - 0.18, label, ha="left", va="center", fontsize=8.4, color=INK, fontweight="bold", zorder=3)


def arrow(x1, y1, x2, y2, ls="-", color=INK, lw=1.0, rad=0.0):
    ax.add_patch(
        FancyArrowPatch(
            (x1, y1),
            (x2, y2),
            arrowstyle="-|>",
            mutation_scale=9,
            linewidth=lw,
            linestyle=ls,
            color=color,
            connectionstyle=f"arc3,rad={rad}",
            shrinkA=0,
            shrinkB=0,
            zorder=4,
        )
    )


# Title
ax.text(0.35, 8.30, "DroidSeal 1.1.0 — Android Release Architecture", ha="left", va="center", fontsize=17, fontweight="bold")
ax.text(
    0.35,
    8.02,
    "Local-first audit  →  optional hardening  →  official signing  →  independent verification. "
    "Every release run emits evidence.",
    ha="left",
    va="center",
    fontsize=9.2,
    color=MUTED,
)

# Execution boundary
rounded(0.20, 2.42, 13.60, 5.18, "none", "#8c969e", lw=0.8, ls=(0, (4, 3)), rad=0.08, z=0)
ax.text(
    0.40,
    7.50,
    "LOCAL EXECUTION BOUNDARY  ·  NO APK UPLOAD",
    ha="left",
    va="center",
    fontsize=7.6,
    color="#66727a",
    fontweight="bold",
    bbox=dict(boxstyle="round,pad=0.20", facecolor="white", edgecolor="none"),
    zorder=5,
)

# Panels
panel(0.35, 2.65, 2.20, 4.75, "INPUTS", 1)
panel(2.75, 2.65, 2.00, 4.75, "AUDIT", 2)
panel(4.95, 2.65, 1.95, 4.75, "DECIDE & REMEDIATE", 3)
panel(7.10, 2.65, 2.35, 4.75, "BUILD & HARDEN", 4)
panel(9.65, 2.65, 2.15, 4.75, "SIGN & VERIFY", 5)
panel(12.00, 2.65, 1.70, 4.75, "EVIDENCE", 6)

# Inputs
box(0.50, 6.25, 1.90, 0.68, "Android project", "source + Gradle", "self")
box(0.50, 5.25, 1.90, 0.68, "Release APK", "existing artifact", "self")
box(0.50, 4.25, 1.90, 0.68, "Signing identity", "keystore + cert SHA-256", "self")
box(0.50, 3.25, 1.90, 0.68, "Release policy", "gate + device target", "self")

# Audit
box(2.90, 6.25, 1.70, 0.68, "Environment diagnosis", "JDK · SDK · build tools", "self")
box(2.90, 5.35, 1.70, 0.68, "Source audit", "manifest · secrets · R8", "self")
box(2.90, 4.45, 1.70, 0.68, "APK audit", "ZIP · DEX · ELF · ARSC", "self")
box(2.90, 3.55, 1.70, 0.68, "Dependencies", "third-party + SBOM", "self")
ax.text(3.75, 2.98, "findings", ha="center", va="center", fontsize=7.4, color=SELF_EDGE, style="italic")
ax.text(3.75, 2.80, "confidence-tagged", ha="center", va="center", fontsize=6.7, color=MUTED, style="italic")

# Decide & remediate
box(5.10, 6.25, 1.65, 0.68, "Release gate", "findings · confidence", "self")
box(5.10, 5.25, 1.65, 0.70, "Remediation pack", "fix plan + evidence", "self")
box(5.10, 4.15, 1.65, 0.70, "Safe fixes", "R8 rules · AXML patch", "self")
box(5.10, 3.05, 1.65, 0.66, "Decision", "pass / warn / block", "self")
arrow(5.925, 6.25, 5.925, 5.96)
arrow(5.925, 5.25, 5.925, 4.86)
arrow(5.925, 4.15, 5.925, 3.72)

# Build & harden
box(7.25, 6.25, 2.05, 0.68, "Gradle release build", "official build path", "third")
rounded(7.25, 3.35, 2.05, 2.55, OPT_FILL, OPT_EDGE, lw=1.0, ls=(0, (4, 3)), rad=0.06)
ax.text(8.275, 5.69, "Optional hardening", ha="center", va="center", fontsize=8.5, fontweight="bold", color="#4e3868")
ax.text(8.275, 5.47, "opt-in release APK", ha="center", va="center", fontsize=7.1, color=MUTED)

chips = [
    (7.36, 4.98, "DEX encryption"),
    (8.34, 4.98, "Keyed integrity"),
    (7.36, 4.40, "Key sharding"),
    (8.34, 4.40, "Environment gate"),
]
for x, y, label in chips:
    rounded(x, y, 0.90, 0.38, "white", OPT_EDGE, lw=0.55, rad=0.04, z=3)
    ax.text(x + 0.45, y + 0.19, label, ha="center", va="center", fontsize=6.7, zorder=4)

ax.text(8.275, 3.87, "tamper → wrong keys", ha="center", va="center", fontsize=7.0, color=OPT_EDGE, style="italic")
arrow(8.275, 6.25, 8.275, 5.92, ls=(0, (3, 2)), color=OPT_EDGE)

# Sign & verify
box(9.80, 6.25, 1.85, 0.62, "zipalign", "official alignment", "third")
box(9.80, 5.35, 1.85, 0.62, "apksigner", "official signing", "third")
box(9.80, 4.45, 1.85, 0.64, "Independent verify", "signature · hashes · baseline", "self")
box(9.80, 3.55, 1.85, 0.64, "Device smoke", "API 26 x86_64 (limited)", "self")
arrow(10.725, 6.25, 10.725, 5.99)
arrow(10.725, 5.35, 10.725, 5.10)
arrow(10.725, 4.45, 10.725, 4.20)
ax.text(10.725, 3.20, "rollback on failure", ha="center", va="center", fontsize=6.8, color=MUTED, style="italic")

# Evidence outputs
box(12.15, 6.25, 1.40, 0.60, "Signed APK", None, "evidence")
box(12.15, 5.53, 1.40, 0.60, "SHA-256", None, "evidence")
box(12.15, 4.81, 1.40, 0.60, "Reports", "JSON / Markdown", "evidence")
box(12.15, 4.09, 1.40, 0.60, "CycloneDX", "SBOM", "evidence")
box(12.15, 3.37, 1.40, 0.60, "releaseDecision", None, "evidence")
box(12.15, 2.75, 1.40, 0.50, "Remediation", "evidence", "evidence")

# Horizontal pipeline arrows
arrow(2.55, 6.60, 2.75, 6.60)
arrow(4.75, 6.60, 4.95, 6.60)
arrow(6.90, 6.60, 7.10, 6.60)
arrow(9.45, 6.60, 9.65, 6.60)
arrow(11.80, 6.60, 12.00, 6.60)

# Evidence band
rounded(0.35, 1.55, 13.35, 0.70, EVID_FILL, EVID_EDGE, lw=0.8, rad=0.05)
ax.text(0.55, 1.98, "EVALUATION EVIDENCE", ha="left", va="center", fontsize=8.0, fontweight="bold", color=EVID_EDGE)
ax.text(0.55, 1.72, "claims tied to reproducible measurements", ha="left", va="center", fontsize=6.9, color=MUTED, style="italic")
ax.text(3.30, 1.95, "387 tests", ha="left", va="center", fontsize=7.6, fontweight="bold")
ax.text(4.70, 1.95, "391 detector entries  ·  390 unique codes", ha="left", va="center", fontsize=7.4)
ax.text(8.60, 1.95, "434 benign apps  ·  dataflow FP = 0", ha="left", va="center", fontsize=7.4)
ax.text(11.60, 1.95, "API 26 x86_64 emulator", ha="left", va="center", fontsize=7.2)
ax.text(3.30, 1.70, "release gate + security regressions", ha="left", va="center", fontsize=6.7, color=MUTED)
ax.text(8.60, 1.70, "criteria-bound benchmark", ha="left", va="center", fontsize=6.7, color=MUTED)
ax.text(11.60, 1.70, "hardening path only", ha="left", va="center", fontsize=6.7, color=MUTED)

# Legend
legend_y = 1.04
legend = [
    (0.40, SELF_FILL, SELF_EDGE, "-", "Self-developed core"),
    (3.60, THIRD_FILL, THIRD_EDGE, "-", "Official Android tool"),
    (7.10, OPT_FILL, OPT_EDGE, (0, (4, 3)), "Opt-in hardening"),
    (10.20, EVID_FILL, EVID_EDGE, "-", "Evidence artifact"),
]
for x, fc, ec, ls, label in legend:
    ax.add_patch(Rectangle((x, legend_y - 0.07), 0.28, 0.14, facecolor=fc, edgecolor=ec, linewidth=0.7, linestyle=ls, zorder=3))
    ax.text(x + 0.36, legend_y, label, ha="left", va="center", fontsize=7.2, color=MUTED)

fig.savefig(OUT / "droidseal-architecture.svg", bbox_inches="tight", pad_inches=0.06, facecolor="white")
fig.savefig(OUT / "droidseal-architecture.png", bbox_inches="tight", pad_inches=0.06, facecolor="white", dpi=320)
print(f"wrote {OUT / 'droidseal-architecture.svg'}")
print(f"wrote {OUT / 'droidseal-architecture.png'}")
