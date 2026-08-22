# 强制 R8 的按变体细化模板（开发路线 ⑤：构建期与报告闭环）

DroidSeal 在构建期用 Gradle init-script（`droidseal-force-r8.init.gradle`）对本次构建强制开启
R8 代码混淆、资源压缩，并挂载优化版默认 ProGuard 规则（`proguard-android-optimize.txt`）。
该 init-script 不写回源码，下次不经 DroidSeal 的普通构建仍是原状态。

## 按变体细化的模板

默认对 **release 变体**强制开启；如需按变体/风味细化，可把以下片段并入自定义 init-script
（或参考它替换 DroidSeal 的默认脚本——注意保持可复现与可回滚）：

```groovy
// 按变体细化：release 强制开启；debug 保持原状；可按 buildType/flavor 微调
allprojects {
    afterEvaluate { proj ->
        if (proj.plugins.hasPlugin("com.android.application")) {
            proj.android {
                applicationVariants.all { variant ->
                    def isRelease = variant.buildType.name == "release"
                    def isFlavorManaged = variant.flavorName == "managed"
                    if (isRelease) {
                        variant.minifyEnabled = true
                        variant.shrinkResources = true
                        variant.proguardFiles += "proguard-android-optimize.txt"
                        if (variant.proguardFiles.every { !(it as File).name.contains("proguard-rules.pro") }) {
                            variant.proguardFiles += "proguard-rules.pro"
                        }
                    }
                    // 可选：特定 flavor 额外规则（如 managed 风味关闭裁剪以保兼容）
                    if (isFlavorManaged) {
                        variant.shrinkResources = false
                    }
                }
            }
        }
    }
}
```

## 使用说明

- **只改本次构建**：init-script 覆盖不写回 `build.gradle`；下次普通构建保持原状态。
- **变体判断**：按 `variant.buildType.name` / `variant.flavorName` 分支，避免整包关闭优化。
- **规则加载**：优先 `proguard-android-optimize.txt` + 模块 `proguard-rules.pro`；缺失规则引用会让
  R8 审计报告 `R8_RULE_FILE_REFERENCE_MISSING`。
- **复核**：改动后用 release 构建的 `mapping.txt` 复核混淆覆盖，再用 DroidSeal 的 R8 审计确认
  未出现宽 keep / 关闭优化 / 缺失规则引用。

## 与 DroidSeal 的关系

- 默认行为由 `FORCE_R8_INIT_SCRIPT` 提供（见 `src/core/pipeline.ts`）；本模板用于需要
  **按变体/风味细化**的复杂项目，由开发者在构建侧接入（源码侧模式，不事后改写 APK）。
- R8 规则模板库（`docs/r8-rule-templates.md`）提供常见场景的 keep 规则；修复包
  （`templates/proguard-rules.suggestion.md`）带本次审计发现的具体项。
