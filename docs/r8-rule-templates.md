# R8 / ProGuard 规则模板库（中期路线：构建期/发布工程化）

常见场景的 keep 规则模板。原则：**最小化 keep**——只保留反射/序列化/框架回调真正需要的成员，
其余交给 R8 默认优化；能用注解/继承约束就不用显式规则。

> 用法：把对应场景的片段合并到模块的 `proguard-rules.pro`（release 变体生效），
> 改动后重新构建并用 DroidSeal 的 R8 规则质量审计复核（关闭优化/裁剪/混淆、宽 keep、缺失规则引用）。

## Retrofit（接口 + 泛型 + 转换器）

```proguard
# Retrofit 接口与泛型签名按反射使用保留
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
# 注解处理生成的实现（Retrofit.create 动态代理）保留接口方法签名
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
# 转换器（Gson/Moshi）反序列化目标类：保留无参构造与字段
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}
```

## Room（实体 / DAO / 迁移）

```proguard
# 实体类：Room 通过反射构造与读写字段，保留无参构造与全部字段
-keep class **.entity.** { <init>(); <fields>; }
# DAO 接口：Room 生成实现，保留接口方法（含 suspend 泛型）
-keep,allowobfuscation interface **.dao.**
# 迁移与 TypeConverter 按注解保留
-keepclassmembers class ** {
    @androidx.room.* <methods>;
}
```

## Kotlin 协程（Continuation）

```proguard
# suspend 函数编译为 Continuation 参数；按接口保留即可，避免宽 keep
-keep,allowobfuscation,allowshrinking interface kotlin.coroutines.Continuation
-keepclassmembers class * extends kotlin.coroutines.jvm.internal.AbstractCoroutineContextElement { *; }
```

## kotlinx.serialization（序列化）

```proguard
# 序列化生成器按 @Serializable 注解保留；反射序列化场景再补字段 keep
-keepattributes *Annotation*, InnerClasses
-keepclassmembers @kotlinx.serialization.Serializable class ** {
    companion object;
}
-keepclasseswithmembers,allowobfuscation class ** {
    @kotlinx.serialization.* <fields>;
}
```

## 通用最佳实践

```proguard
# 优先注解约束，而非全局 keep
-keep @interface com.example.annotations.Keep { *; }
# 确需按名查找的 API 才保留（反射/WebView JS 桥）
-keepclassmembers class com.example.web.JsBridge { @android.webkit.JavascriptInterface <methods>; }
# 避免整包宽 keep（-keep class com.example.** { *; }）——只保留真正需要的成员
```

## 反模式（R8 审计会提示）

- `-dontobfuscate` / `-dontshrink` / `-dontoptimize`：整包关闭，除非有明确兼容性原因；
- 全局/整包宽 keep（`{ *; }`）：保留面过大，混淆覆盖降低；
- 缺失规则引用：release 变体引用的规则文件必须存在（`proguard-rules.pro` / `src/main/keepRules/`）。
