#!/usr/bin/env python3
"""IST submission figures for DroidSeal (300 dpi, PDF+PNG)."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import numpy as np
import os

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "droidsealpaper", "figures_ist")
os.makedirs(OUT, exist_ok=True)

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 9,
    "axes.titlesize": 10,
    "axes.labelsize": 9,
    "xtick.labelsize": 8.5,
    "ytick.labelsize": 8.5,
    "legend.fontsize": 8.5,
    "figure.dpi": 300,
    "savefig.dpi": 300,
    "axes.spines.top": False,
    "axes.spines.right": False,
})

C_BLUE, C_GREEN, C_ORANGE, C_GRAY, C_RED = "#2C6FBB", "#2E8B57", "#E1802D", "#8A8A8A", "#B03A3A"


def save(fig, name):
    for ext in ("pdf", "png"):
        fig.savefig(os.path.join(OUT, f"{name}.{ext}"), bbox_inches="tight")
    plt.close(fig)
    print("saved", name)


# ---------- Fig 1: architecture ----------
def fig_arch():
    fig, ax = plt.subplots(figsize=(7.2, 3.2))
    ax.set_xlim(0, 10); ax.set_ylim(0, 4.4); ax.axis("off")

    def box(x, y, w, h, text, fc):
        ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.08",
                                    fc=fc, ec="#444444", lw=0.8))
        ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=8.5)

    def arrow(x1, y1, x2, y2):
        ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle="-|>",
                                     mutation_scale=12, color="#444444", lw=1.0))

    box(0.2, 2.6, 2.6, 1.2, "Audit module\n379 detectors + 19 taint\nanalyses, confidence tiers", "#EAF2FB")
    box(3.7, 2.6, 2.6, 1.2, "Release gate\nconfirmed findings only;\nblock / review / pass", "#EAF7EF")
    box(7.2, 2.6, 2.6, 1.2, "Hardening mode\nkeyed per-entry encryption\n(manifest, votes $\\rightarrow$ KDF)", "#FDF1E3")
    box(1.5, 0.5, 3.0, 1.0, "Evidence pack + SBOM\n(CycloneDX, per-case JSON)", "#F5F5F5")
    box(5.6, 0.5, 3.0, 1.0, "Re-test closure\n(fix $\\rightarrow$ re-scan $\\rightarrow$ verify)\n--fail-on-remaining", "#F5F5F5")

    arrow(2.8, 3.2, 3.7, 3.2)
    arrow(6.3, 3.2, 7.2, 3.2)
    arrow(2.0, 2.6, 2.6, 1.5)
    arrow(4.6, 2.6, 4.9, 1.5)
    arrow(6.9, 1.0, 6.6, 1.0)
    ax.text(5.0, 4.15, "fix", ha="center", fontsize=8, color=C_GRAY)
    arrow(8.5, 2.6, 7.6, 1.5)
    save(fig, "fig1_architecture")


# ---------- Fig 2: release pipeline ----------
def fig_pipeline():
    steps = [
        ("Source", "self"), ("Audit scan", "self"), ("Gate", "self"),
        ("Fix", "3rd"), ("Re-test", "self"), ("SBOM", "self"),
        ("OSV check", "self"), ("Harden", "self"), ("Sign", "3rd"),
        ("Device test", "self"), ("Ledger", "self"), ("Release", "3rd"),
    ]
    fig, ax = plt.subplots(figsize=(7.2, 2.4))
    n = len(steps)
    for i, (name, who) in enumerate(steps):
        x = i * 0.82
        color = C_BLUE if who == "self" else C_ORANGE
        ax.add_patch(FancyBboxPatch((x, 0.55), 0.68, 0.7, boxstyle="round,pad=0.04",
                                    fc="#FFFFFF", ec=color, lw=1.2))
        ax.text(x + 0.34, 0.9, name, ha="center", va="center", fontsize=7.2, rotation=0)
        if i < n - 1:
            ax.add_patch(FancyArrowPatch((x + 0.68, 0.9), (x + 0.82, 0.9),
                                         arrowstyle="-|>", mutation_scale=8,
                                         color="#666666", lw=0.8))
    legend_handles = [
        mpatches.Patch(fc="#FFFFFF", ec=C_BLUE, lw=1.2, label="DroidSeal (self)"),
        mpatches.Patch(fc="#FFFFFF", ec=C_ORANGE, lw=1.2, label="3rd party / developer"),
    ]
    ax.legend(handles=legend_handles, loc="lower center",
              ncol=2, frameon=False, bbox_to_anchor=(0.5, -0.12))
    ax.set_xlim(-0.1, n * 0.82 + 0.1); ax.set_ylim(0, 1.5); ax.axis("off")
    save(fig, "fig2_pipeline")


# ---------- Fig 3: precision/recall ----------
def fig_pr():
    settings = ["Built-in\n(38 cases)", "DroidBench\n(177, official GT,\ndata-flow layer)",
                "DroidBench\n(177, all-detector\naggregate)"]
    precision = [76.9, 100.0, 97.2]
    recall = [90.9, 99.4, 99.4]
    x = np.arange(len(settings)); w = 0.34
    fig, ax = plt.subplots(figsize=(5.0, 3.0))
    b1 = ax.bar(x - w / 2, precision, w, label="Precision", color=C_BLUE, ec="#1a1a1a", lw=0.5)
    b2 = ax.bar(x + w / 2, recall, w, label="Recall", color=C_GREEN, ec="#1a1a1a", lw=0.5)
    for bars in (b1, b2):
        for b in bars:
            ax.text(b.get_x() + b.get_width() / 2, b.get_height() + 1.2,
                    f"{b.get_height():.1f}", ha="center", fontsize=8)
    ax.set_xticks(x); ax.set_xticklabels(settings, fontsize=8)
    ax.set_ylabel("Score (%)"); ax.set_ylim(0, 112)
    ax.legend(frameon=False, loc="lower right")
    ax.set_yticks([0, 25, 50, 75, 100])
    save(fig, "fig3_precision_recall")


# ---------- Fig 4: efficiency / footprint ----------
def fig_eff():
    fig, axes = plt.subplots(1, 2, figsize=(6.8, 2.9))

    tools = ["DroidSeal", "MobSF 4.5.2"]
    times = [155 / 25 / 1000 * 1000, 10_000]  # ms per case; DroidSeal ~6.2 ms avg
    times_ms = [6.2, 10_000]
    ax = axes[0]
    bars = ax.barh(tools, times_ms, color=[C_BLUE, C_GRAY], ec="#1a1a1a", lw=0.5,
                   log=True, height=0.5)
    for b, v in zip(bars, times_ms):
        label = f"{v:.1f} ms" if v < 1000 else f"{v/1000:.1f} s"
        ax.text(b.get_width() * 1.25, b.get_y() + b.get_height() / 2, label,
                va="center", fontsize=8.5)
    ax.set_xlabel("Scan time per case (ms, log scale)")
    ax.set_xlim(1, 6e4)
    ax.spines["left"].set_visible(True)

    ax = axes[1]
    rss = [111, 183]  # DroidSeal process peak vs MobSF waitress service footprint (long-paper tab:eff-compare)
    bars = ax.barh(tools, rss, color=[C_BLUE, C_GRAY], ec="#1a1a1a", lw=0.5, height=0.5)
    for b, v in zip(bars, rss):
        ax.text(b.get_width() * 1.02, b.get_y() + b.get_height() / 2, f"{v} MB",
                va="center", fontsize=8.5)
    ax.set_xlabel("Peak RSS (MB)")
    ax.set_xlim(0, 560)
    ax.spines["left"].set_visible(True)

    fig.tight_layout()
    save(fig, "fig4_efficiency")


fig_arch(); fig_pipeline(); fig_pr(); fig_eff()
print("all figures ->", OUT)
