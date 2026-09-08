# DroidSeal PyPI 封装包(TS 核心经 npm 包调用——Python 命令行入口)。
# 说明:DroidSeal 核心是 TypeScript(经 npm 发布)——本封装提供 Python CLI 入口。
import subprocess
import sys


def main() -> None:
    """调用 npm 包 droidseal 的 CLI(需已 npm install -g droidseal 或 npx)。"""
    args = sys.argv[1:]
    cmd = ["npx", "--yes", "droidseal", *args]
    try:
        subprocess.run(cmd, check=True)
    except FileNotFoundError:
        print("错误:需要 npm/npx(请先安装 Node.js/npm)——或已安装 droidseal npm 包", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
