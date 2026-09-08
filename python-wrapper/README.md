# DroidSeal PyPI 封装包

DroidSeal 核心为 TypeScript(经 npm 包 `droidseal` 发布)——本 PyPI 包提供 Python 命令行封装入口,调用 `npx droidseal` 运行全部功能(audit/harden/sign/verify 等)。

## 安装

```bash
pip install droidseal
# 需 Node.js/npm(npx 可用)——核心经 npm 包调用
```

## 使用

```bash
droidseal --help
droidseal audit <apk>
```
