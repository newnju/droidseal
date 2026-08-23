# 平台支持矩阵（长期②——MobSF 缺口的规划文档）

## 当前支持矩阵（1.0.x）

| 维度 | 支持 | 说明 |
|---|---|---|
| **应用输入** | Android APK / Android 项目 | 14 步流水线（审计 → 归一化 → 混淆 → 签名 → 验证 → 报告） |
| **运行平台** | Windows x64 / Linux x64 | 发布产物（npm/PyPI 双平台） |
| **工具链** | JDK / Android Build Tools / Gradle / apksigner / zipalign / keytool | 自动发现 + 缺失提示 |
| **解析能力** | ZIP / Manifest / DEX / ARSC / ELF(.so) / 源码(Java/Kotlin) | 纯 TypeScript 自研解析 |

## Windows 扩展规划（长期）

### Windows（AppX / MSIX）

| 环节 | 工作量 | 说明 |
|---|---|---|
| AppX 解析（Zip + AppxManifest.xml + 二进制） | 中 | 新增 AppX 解析器 |
| .NET/原生二进制审计 | 高 | .NET 元数据 + PE 解析（当前无） |
| 签名/加固 | 中 | AppX 签名（SignTool） |

**结论**：Windows 应用扩展同样是大工程，且受众与 Android 移动安全定位偏离较大——**优先级低于 Android 深耕**。

## 决策建议

- **保持 Android 深耕**（短期/中期）：当前审计深度（DEX/ARSC/ELF/供应链）在 Android 移动安全领域仍有大量深化空间（如 DEX 数据流、真实设备矩阵）；
- **Windows 最后**：与移动安全定位偏离，仅在企业桌面场景有价值。

## 边界

- 本矩阵是**规划文档**——平台扩展是长期决策项，不影响当前 Android 主线的发布与维护；
- 扩展前需确认：用户需求、环境（macOS 构建）、维护可持续性（避免单点）。
