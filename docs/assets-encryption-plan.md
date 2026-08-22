# assets 资源轻量加密方案（开发路线 ②：资源/资产层）

> 状态：设计就绪。与字符串加密桩同模式——**源码接入**（构建期加密、运行期解密），
> 不事后改写未知 APK。只提高静态提取门槛，不等于密码学级保密。

## 目标

对 `assets/` 下选定的资源（游戏关卡、配置、多媒体等）做轻量加密，避免直接解压 APK
即得明文。与字符串加密桩（`generate-string-crypto-stub.ts`）的“编译期加密、运行期解密”
思路一致。

## 边界与纪律

- **源码接入**：构建期由脚本/插件加密，应用侧在源码中集成解密器；DroidSeal 不在 14 步
  流水线内对成品 APK 的 assets 做事后加密改写。
- **只提高门槛**：密钥嵌入客户端，可被提取；本能力对抗的是“解压即得”，不是对抗专业
  逆向（脱壳/内存 dump 不在对抗范围）。
- **失败关闭**：加密/解密任一步失败即报错，不产出半成品。

## 方案设计

### 1. 构建期加密（脚本/CI 步骤）

```text
assets/raw/level01.dat        →  assets/enc/level01.dat.enc（轻量流式变换）
assets/raw/config.json        →  assets/enc/config.json.enc
assets/enc/manifest.json      ←  清单：{ 原路径, 密文路径, 密钥指纹, 算法 }
```

- 算法建议：轻量流式变换（XOR + 轮转，与 `dex-string-crypto` 的变换一致，零依赖）；
  敏感度高时可换 AES-GCM（需引入加密库，工作量更大）。
- 密钥：构建期生成，嵌入客户端（指纹防混淆）；清单随 APK 分发。
- 只加密选定的 `assets/raw/` 子目录，其余 assets 不动（避免误伤）。

### 2. 运行时解密（应用侧集成）

```kotlin
// AssetsReader：读取时按清单解密（示例接口，源码接入）
object AssetsReader {
    fun open(context: Context, rawPath: String): InputStream {
        // 1. 查 manifest.json：rawPath 是否已加密
        // 2. 已加密 → 读取 .enc + 按密钥/算法解密为流
        // 3. 未加密 → 直接返回 AssetsManager.open(rawPath)
    }
}
```

- 解密失败：返回空/记录信号（失败关闭），不影响未加密资源。
- 性能：流式解密（按需读块），避免整文件加载；大资源需评估开销。

### 3. 密钥与轮换

- 密钥嵌入客户端（与字符串加密桩一致——指纹关联，不泄露密钥内容）；
- 轮换：重新生成密钥 + 重新加密 + 更新清单与客户端（全量发布）。

## 与 DroidSeal 的关系

- 工具形态：`scripts/encrypt-assets.ts`（构建期调用）+ 生成的 `AssetsReader.kt` 与
  `manifest.json`（源码接入）——与 `generate-string-crypto-stub.ts` 同模式；
- 审计衔接：`ASSET_HARDCODED_SECRET` / `ASSET_EMBEDDED_PRIVATE_KEY` 等 finding 可提示
  “如需保护 assets 资源，用本方案源码接入”；
- 不在 14 步流水线内执行（避免对未知 APK 事后改写）。

## 建议

1. 只保护真正敏感的资源（关卡逻辑/配置），不加密公开素材（性能与包体开销）；
2. 解密路径做失败降级（资源缺失时优雅处理，不崩溃）；
3. 上线前真机验证：不同 Android 版本/架构的解密与性能。
