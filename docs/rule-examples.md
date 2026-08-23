# 自定义规则示例集（规则生态——Semgrep 差距④）

> DroidSeal 的自定义规则（`customRulesFile`）以 JSON 正则描述——社区规则风格，
> 可直接复制为 `rules.json` 并在审计中启用（`--custom-rules rules.json`）。
> 规则格式与校验见 `src/core/custom-rules.ts`（失败关闭：字段缺失/正则非法即报错）。

## 规则格式

```json
[
  {
    "code": "RULE_CODE",
    "title": "规则标题",
    "severity": "high | medium | low | info",
    "pattern": "正则模式（小写不敏感——匹配时统一小写）",
    "scope": "source（源码）| dex（DEX 字符串池）| all",
    "recommendation": "修复建议（可选）",
    "exact": true
  }
]
```

- **`exact: true`**：精确模式——模式用词边界包裹（`\b(?:模式)\b`）——只匹配整词——降误报；
- **元数据**（可选）：`source` / `version` / `author`——用于规则追溯；
- **suppression**：源码行尾加 `// droidseal-ignore`（或 `// droidseal-ignore: RULE_CODE`）可忽略该行。

## 示例规则集（可直接使用）

```json
[
  {
    "code": "CUSTOM_HARDCODED_AWS_KEY",
    "title": "AWS Access Key 硬编码",
    "severity": "high",
    "pattern": "AKIA[0-9A-Z]{16}",
    "scope": "source",
    "recommendation": "AWS 密钥移入服务端或运行时获取。"
  },
  {
    "code": "CUSTOM_HARDCODED_GITHUB_TOKEN",
    "title": "GitHub Token 硬编码",
    "severity": "high",
    "pattern": "ghp_[A-Za-z0-9]{36}",
    "scope": "all",
    "recommendation": "Token 移入安全配置/服务端。"
  },
  {
    "code": "CUSTOM_EVAL_USAGE",
    "title": "源码使用 eval 动态执行",
    "severity": "medium",
    "pattern": "eval\\(",
    "scope": "source",
    "exact": true,
    "recommendation": "避免动态执行不可信内容——存在注入风险。"
  },
  {
    "code": "CUSTOM_INSECURE_RANDOM",
    "title": "不安全的随机数（Math.random）",
    "severity": "low",
    "pattern": "math\\.random\\(",
    "scope": "source",
    "recommendation": "安全场景改用 SecureRandom（密码学安全随机）。"
  },
  {
    "code": "CUSTOM_DANGEROUS_PERMISSION",
    "title": "短信权限申请",
    "severity": "medium",
    "pattern": "android\\.permission\\.RECEIVE_SMS",
    "scope": "dex",
    "recommendation": "核对短信权限用途；短信劫持是常见恶意行为。"
  },
  {
    "code": "CUSTOM_INTERNAL_ENDPOINT",
    "title": "内部端点（内网地址）",
    "severity": "medium",
    "pattern": "https?://(?:10\\.|192\\.168\\.|172\\.(?:1[6-9]|2[0-9]|3[01])\\.)",
    "scope": "all",
    "recommendation": "内部/测试端点不应出现在发布包。"
  },
  {
    "code": "CUSTOM_TODO_SECURITY",
    "title": "代码中的安全 TODO 遗留",
    "severity": "low",
    "pattern": "todo\\s*[:：]?\\s*(?:security|security?fix|harden)",
    "scope": "source",
    "exact": true,
    "recommendation": "清理遗留的安全 TODO——避免遗漏修复。"
  }
]
```

## 启用方式

```bash
# 项目审计时启用自定义规则
bun run start --input <项目> --custom-rules rules.json

# 规则测试框架（正/负用例验证——CI 友好退出码）
bun scripts/test-rules.ts rules.json test-cases.json
```

## 说明

- 规则生态以**自建 + 社区风格示例**为主（跨语言社区规则为通用 SAST 边界——DroidSeal 专注移动安全）；
- 新规则建议先用 `test-rules.ts` 验证正/负用例，再启用；
- 规则命中以清单级提示为主（严重度参与门禁——critical/high 可阻断发布）。
