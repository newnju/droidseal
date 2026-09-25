.class public Landroid/support/v4/graphics/TypefaceCompatApi26Impl;
.super Landroid/support/v4/graphics/TypefaceCompatApi21Impl;
.source "TypefaceCompatApi26Impl.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x1a
.end annotation

.annotation build Landroid/support/annotation/RestrictTo;
    value = {
        .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
    }
.end annotation


# static fields
.field private static final ABORT_CREATION_METHOD:Ljava/lang/String; = "abortCreation"

.field private static final ADD_FONT_FROM_ASSET_MANAGER_METHOD:Ljava/lang/String; = "addFontFromAssetManager"

.field private static final ADD_FONT_FROM_BUFFER_METHOD:Ljava/lang/String; = "addFontFromBuffer"

.field private static final CREATE_FROM_FAMILIES_WITH_DEFAULT_METHOD:Ljava/lang/String; = "createFromFamiliesWithDefault"

.field private static final FONT_FAMILY_CLASS:Ljava/lang/String; = "android.graphics.FontFamily"

.field private static final FREEZE_METHOD:Ljava/lang/String; = "freeze"

.field private static final RESOLVE_BY_FONT_TABLE:I = -0x1

.field private static final TAG:Ljava/lang/String; = "TypefaceCompatApi26Impl"

.field private static final sAbortCreation:Ljava/lang/reflect/Method;

.field private static final sAddFontFromAssetManager:Ljava/lang/reflect/Method;

.field private static final sAddFontFromBuffer:Ljava/lang/reflect/Method;

.field private static final sCreateFromFamiliesWithDefault:Ljava/lang/reflect/Method;

.field private static final sFontFamily:Ljava/lang/Class;

.field private static final sFontFamilyCtor:Ljava/lang/reflect/Constructor;

.field private static final sFreeze:Ljava/lang/reflect/Method;


# direct methods
.method static constructor <clinit>()V
    .locals 16

    .line 81
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "android.graphics.FontFamily"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/ClassNotFoundException; {:try_start_0 .. :try_end_0} :catch_6
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_6

    .line 82
    .local v1, "fontFamilyClass":Ljava/lang/Class;
    const/4 v2, 0x0

    :try_start_1
    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v1, v3}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3
    :try_end_1
    .catch Ljava/lang/ClassNotFoundException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/lang/NoSuchMethodException; {:try_start_1 .. :try_end_1} :catch_5

    .line 83
    .local v3, "fontFamilyCtor":Ljava/lang/reflect/Constructor;
    :try_start_2
    const-string v4, "addFontFromAssetManager"

    const/16 v5, 0x8

    new-array v5, v5, [Ljava/lang/Class;

    const-class v6, Landroid/content/res/AssetManager;

    aput-object v6, v5, v2

    const-class v6, Ljava/lang/String;

    const/4 v7, 0x1

    aput-object v6, v5, v7

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v8, 0x2

    aput-object v6, v5, v8

    sget-object v6, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/4 v9, 0x3

    aput-object v6, v5, v9

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v10, 0x4

    aput-object v6, v5, v10

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v11, 0x5

    aput-object v6, v5, v11

    const/4 v6, 0x6

    sget-object v12, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v12, v5, v6

    const/4 v6, 0x7

    const-class v12, [Landroid/graphics/fonts/FontVariationAxis;

    aput-object v12, v5, v6

    invoke-virtual {v1, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4
    :try_end_2
    .catch Ljava/lang/ClassNotFoundException; {:try_start_2 .. :try_end_2} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_2 .. :try_end_2} :catch_4

    .line 86
    .local v4, "addFontMethod":Ljava/lang/reflect/Method;
    :try_start_3
    const-string v5, "addFontFromBuffer"

    new-array v6, v11, [Ljava/lang/Class;

    const-class v11, Ljava/nio/ByteBuffer;

    aput-object v11, v6, v2

    sget-object v11, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v11, v6, v7

    const-class v11, [Landroid/graphics/fonts/FontVariationAxis;

    aput-object v11, v6, v8

    sget-object v11, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v11, v6, v9

    sget-object v11, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v11, v6, v10

    invoke-virtual {v1, v5, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5
    :try_end_3
    .catch Ljava/lang/ClassNotFoundException; {:try_start_3 .. :try_end_3} :catch_3
    .catch Ljava/lang/NoSuchMethodException; {:try_start_3 .. :try_end_3} :catch_3

    .line 89
    .local v5, "addFromBufferMethod":Ljava/lang/reflect/Method;
    :try_start_4
    const-string v6, "freeze"

    new-array v10, v2, [Ljava/lang/Class;

    invoke-virtual {v1, v6, v10}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v6
    :try_end_4
    .catch Ljava/lang/ClassNotFoundException; {:try_start_4 .. :try_end_4} :catch_2
    .catch Ljava/lang/NoSuchMethodException; {:try_start_4 .. :try_end_4} :catch_2

    .line 90
    .local v6, "freezeMethod":Ljava/lang/reflect/Method;
    :try_start_5
    const-string v10, "abortCreation"

    new-array v11, v2, [Ljava/lang/Class;

    invoke-virtual {v1, v10, v11}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v10
    :try_end_5
    .catch Ljava/lang/ClassNotFoundException; {:try_start_5 .. :try_end_5} :catch_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_5 .. :try_end_5} :catch_1

    .line 91
    .local v10, "abortCreationMethod":Ljava/lang/reflect/Method;
    :try_start_6
    invoke-static {v1, v7}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;I)Ljava/lang/Object;

    move-result-object v11

    .line 92
    .local v11, "familyArray":Ljava/lang/Object;
    const-class v12, Landroid/graphics/Typeface;

    const-string v13, "createFromFamiliesWithDefault"

    new-array v9, v9, [Ljava/lang/Class;

    .line 94
    invoke-virtual {v11}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v14

    aput-object v14, v9, v2

    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v2, v9, v7

    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v2, v9, v8

    .line 93
    invoke-virtual {v12, v13, v9}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    move-object v0, v2

    .line 95
    .local v0, "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    invoke-virtual {v0, v7}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_6
    .catch Ljava/lang/ClassNotFoundException; {:try_start_6 .. :try_end_6} :catch_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_6 .. :try_end_6} :catch_0

    .line 106
    .end local v11    # "familyArray":Ljava/lang/Object;
    nop

    .line 107
    move-object v2, v0

    move-object v0, v5

    goto :goto_5

    .line 96
    .end local v0    # "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    :catch_0
    move-exception v2

    move-object v15, v5

    move-object v5, v0

    move-object v0, v15

    goto :goto_4

    .line 96
    .end local v10    # "abortCreationMethod":Ljava/lang/reflect/Method;
    :catch_1
    move-exception v2

    move-object v10, v0

    goto :goto_0

    .line 96
    .end local v6    # "freezeMethod":Ljava/lang/reflect/Method;
    :catch_2
    move-exception v2

    move-object v6, v0

    move-object v10, v6

    .line 96
    .local v0, "addFromBufferMethod":Ljava/lang/reflect/Method;
    .local v5, "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    .restart local v6    # "freezeMethod":Ljava/lang/reflect/Method;
    .restart local v10    # "abortCreationMethod":Ljava/lang/reflect/Method;
    :goto_0
    move-object v0, v5

    move-object v5, v10

    goto :goto_4

    .line 96
    .end local v0    # "addFromBufferMethod":Ljava/lang/reflect/Method;
    .end local v5    # "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    .end local v6    # "freezeMethod":Ljava/lang/reflect/Method;
    .end local v10    # "abortCreationMethod":Ljava/lang/reflect/Method;
    :catch_3
    move-exception v2

    move-object v5, v0

    goto :goto_3

    .line 96
    .end local v4    # "addFontMethod":Ljava/lang/reflect/Method;
    :catch_4
    move-exception v2

    move-object v4, v0

    goto :goto_2

    .line 96
    .end local v3    # "fontFamilyCtor":Ljava/lang/reflect/Constructor;
    :catch_5
    move-exception v2

    move-object v3, v0

    goto :goto_1

    .line 96
    .end local v1    # "fontFamilyClass":Ljava/lang/Class;
    :catch_6
    move-exception v2

    move-object v1, v0

    move-object v3, v1

    .line 96
    .restart local v0    # "addFromBufferMethod":Ljava/lang/reflect/Method;
    .restart local v1    # "fontFamilyClass":Ljava/lang/Class;
    .restart local v3    # "fontFamilyCtor":Ljava/lang/reflect/Constructor;
    .restart local v4    # "addFontMethod":Ljava/lang/reflect/Method;
    .restart local v5    # "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    .restart local v6    # "freezeMethod":Ljava/lang/reflect/Method;
    .restart local v10    # "abortCreationMethod":Ljava/lang/reflect/Method;
    :goto_1
    move-object v4, v3

    :goto_2
    move-object v5, v4

    :goto_3
    move-object v6, v5

    move-object v10, v6

    .line 97
    .local v2, "e":Ljava/lang/ReflectiveOperationException;
    :goto_4
    const-string v7, "TypefaceCompatApi26Impl"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "Unable to collect necessary methods for class "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v7, v8, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 99
    const/4 v1, 0x0

    .line 100
    const/4 v3, 0x0

    .line 101
    const/4 v4, 0x0

    .line 102
    const/4 v0, 0x0

    .line 103
    const/4 v6, 0x0

    .line 104
    const/4 v10, 0x0

    .line 105
    const/4 v2, 0x0

    .line 107
    .end local v5    # "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    .local v2, "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    :goto_5
    sput-object v3, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFontFamilyCtor:Ljava/lang/reflect/Constructor;

    .line 108
    sput-object v1, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFontFamily:Ljava/lang/Class;

    .line 109
    sput-object v4, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromAssetManager:Ljava/lang/reflect/Method;

    .line 110
    sput-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromBuffer:Ljava/lang/reflect/Method;

    .line 111
    sput-object v6, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFreeze:Ljava/lang/reflect/Method;

    .line 112
    sput-object v10, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAbortCreation:Ljava/lang/reflect/Method;

    .line 113
    sput-object v2, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sCreateFromFamiliesWithDefault:Ljava/lang/reflect/Method;

    .line 114
    .end local v0    # "addFromBufferMethod":Ljava/lang/reflect/Method;
    .end local v1    # "fontFamilyClass":Ljava/lang/Class;
    .end local v2    # "createFromFamiliesWithDefaultMethod":Ljava/lang/reflect/Method;
    .end local v3    # "fontFamilyCtor":Ljava/lang/reflect/Constructor;
    .end local v4    # "addFontMethod":Ljava/lang/reflect/Method;
    .end local v6    # "freezeMethod":Ljava/lang/reflect/Method;
    .end local v10    # "abortCreationMethod":Ljava/lang/reflect/Method;
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Landroid/support/v4/graphics/TypefaceCompatApi21Impl;-><init>()V

    return-void
.end method

.method private static abortCreation(Ljava/lang/Object;)Z
    .locals 2
    .param p0, "family"    # Ljava/lang/Object;

    .line 201
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAbortCreation:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    .line 202
    .local v0, "result":Ljava/lang/Boolean;
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    .line 203
    .end local v0    # "result":Ljava/lang/Boolean;
    :catch_0
    move-exception v0

    .line 204
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static addFontFromAssetManager(Landroid/content/Context;Ljava/lang/Object;Ljava/lang/String;III)Z
    .locals 5
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "family"    # Ljava/lang/Object;
    .param p2, "fileName"    # Ljava/lang/String;
    .param p3, "ttcIndex"    # I
    .param p4, "weight"    # I
    .param p5, "style"    # I

    .line 145
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromAssetManager:Ljava/lang/reflect/Method;

    const/16 v1, 0x8

    new-array v1, v1, [Ljava/lang/Object;

    .line 146
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const/4 v2, 0x1

    aput-object p2, v1, v2

    const/4 v2, 0x2

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v1, v2

    const/4 v2, 0x3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x4

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x5

    .line 147
    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x6

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x7

    const/4 v3, 0x0

    aput-object v3, v1, v2

    .line 145
    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    .line 148
    .local v0, "result":Ljava/lang/Boolean;
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    .line 149
    .end local v0    # "result":Ljava/lang/Boolean;
    :catch_0
    move-exception v0

    .line 150
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static addFontFromBuffer(Ljava/lang/Object;Ljava/nio/ByteBuffer;III)Z
    .locals 4
    .param p0, "family"    # Ljava/lang/Object;
    .param p1, "buffer"    # Ljava/nio/ByteBuffer;
    .param p2, "ttcIndex"    # I
    .param p3, "weight"    # I
    .param p4, "style"    # I

    .line 161
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromBuffer:Ljava/lang/reflect/Method;

    const/4 v1, 0x5

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const/4 v2, 0x1

    .line 162
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x2

    const/4 v3, 0x0

    aput-object v3, v1, v2

    const/4 v2, 0x3

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x4

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    .line 161
    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    .line 163
    .local v0, "result":Ljava/lang/Boolean;
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    .line 164
    .end local v0    # "result":Ljava/lang/Boolean;
    :catch_0
    move-exception v0

    .line 165
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static createFromFamiliesWithDefault(Ljava/lang/Object;)Landroid/graphics/Typeface;
    .locals 7
    .param p0, "family"    # Ljava/lang/Object;

    .line 175
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFontFamily:Ljava/lang/Class;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;I)Ljava/lang/Object;

    move-result-object v0

    .line 176
    .local v0, "familyArray":Ljava/lang/Object;
    const/4 v2, 0x0

    invoke-static {v0, v2, p0}, Ljava/lang/reflect/Array;->set(Ljava/lang/Object;ILjava/lang/Object;)V

    .line 177
    sget-object v3, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sCreateFromFamiliesWithDefault:Ljava/lang/reflect/Method;

    const/4 v4, 0x0

    const/4 v5, 0x3

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v0, v5, v2

    .line 178
    const/4 v2, -0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v5, v1

    const/4 v1, 0x2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v5, v1

    .line 177
    invoke-virtual {v3, v4, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/Typeface;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    .line 179
    .end local v0    # "familyArray":Ljava/lang/Object;
    :catch_0
    move-exception v0

    .line 180
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static freeze(Ljava/lang/Object;)Z
    .locals 2
    .param p0, "family"    # Ljava/lang/Object;

    .line 189
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFreeze:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    .line 190
    .local v0, "result":Ljava/lang/Boolean;
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    .line 191
    .end local v0    # "result":Ljava/lang/Boolean;
    :catch_0
    move-exception v0

    .line 192
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static isFontFamilyPrivateAPIAvailable()Z
    .locals 2

    .line 120
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromAssetManager:Ljava/lang/reflect/Method;

    if-nez v0, :cond_0

    .line 121
    const-string v0, "TypefaceCompatApi26Impl"

    const-string v1, "Unable to collect necessary private methods.Fallback to legacy implementation."

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 124
    :cond_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sAddFontFromAssetManager:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static newFamily()Ljava/lang/Object;
    .locals 2

    .line 132
    :try_start_0
    sget-object v0, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->sFontFamilyCtor:Ljava/lang/reflect/Constructor;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/InstantiationException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 133
    :catch_0
    move-exception v0

    .line 134
    .local v0, "e":Ljava/lang/ReflectiveOperationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method


# virtual methods
.method public createFromFontFamilyFilesResourceEntry(Landroid/content/Context;Landroid/support/v4/content/res/FontResourcesParserCompat$FontFamilyFilesResourceEntry;Landroid/content/res/Resources;I)Landroid/graphics/Typeface;
    .locals 12
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "entry"    # Landroid/support/v4/content/res/FontResourcesParserCompat$FontFamilyFilesResourceEntry;
    .param p3, "resources"    # Landroid/content/res/Resources;
    .param p4, "style"    # I

    .line 212
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->isFontFamilyPrivateAPIAvailable()Z

    move-result v0

    if-nez v0, :cond_0

    .line 213
    invoke-super/range {p0 .. p4}, Landroid/support/v4/graphics/TypefaceCompatApi21Impl;->createFromFontFamilyFilesResourceEntry(Landroid/content/Context;Landroid/support/v4/content/res/FontResourcesParserCompat$FontFamilyFilesResourceEntry;Landroid/content/res/Resources;I)Landroid/graphics/Typeface;

    move-result-object v0

    return-object v0

    .line 215
    :cond_0
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->newFamily()Ljava/lang/Object;

    move-result-object v0

    .line 216
    .local v0, "fontFamily":Ljava/lang/Object;
    invoke-virtual {p2}, Landroid/support/v4/content/res/FontResourcesParserCompat$FontFamilyFilesResourceEntry;->getEntries()[Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;

    move-result-object v7

    array-length v8, v7

    const/4 v1, 0x0

    move v9, v1

    :goto_0
    const/4 v10, 0x0

    if-ge v9, v8, :cond_2

    aget-object v11, v7, v9

    .line 218
    .local v11, "fontFile":Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;
    invoke-virtual {v11}, Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;->getFileName()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    .line 219
    invoke-virtual {v11}, Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;->getWeight()I

    move-result v5

    invoke-virtual {v11}, Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;->isItalic()Z

    move-result v6

    .line 218
    move-object v1, p1

    move-object v2, v0

    invoke-static/range {v1 .. v6}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->addFontFromAssetManager(Landroid/content/Context;Ljava/lang/Object;Ljava/lang/String;III)Z

    move-result v1

    if-nez v1, :cond_1

    .line 220
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->abortCreation(Ljava/lang/Object;)Z

    .line 221
    return-object v10

    .line 216
    .end local v11    # "fontFile":Landroid/support/v4/content/res/FontResourcesParserCompat$FontFileResourceEntry;
    :cond_1
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 224
    :cond_2
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->freeze(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 225
    return-object v10

    .line 227
    :cond_3
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->createFromFamiliesWithDefault(Ljava/lang/Object;)Landroid/graphics/Typeface;

    move-result-object v1

    return-object v1
.end method

.method public createFromFontInfo(Landroid/content/Context;Landroid/os/CancellationSignal;[Landroid/support/v4/provider/FontsContractCompat$FontInfo;I)Landroid/graphics/Typeface;
    .locals 17
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "cancellationSignal"    # Landroid/os/CancellationSignal;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param
    .param p3, "fonts"    # [Landroid/support/v4/provider/FontsContractCompat$FontInfo;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p4, "style"    # I

    move-object/from16 v1, p2

    move-object/from16 v2, p3

    .line 234
    array-length v3, v2

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-ge v3, v4, :cond_0

    .line 235
    return-object v5

    .line 237
    :cond_0
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->isFontFamilyPrivateAPIAvailable()Z

    move-result v3

    if-nez v3, :cond_4

    .line 240
    move-object/from16 v3, p0

    move/from16 v4, p4

    invoke-virtual {v3, v2, v4}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->findBestInfo([Landroid/support/v4/provider/FontsContractCompat$FontInfo;I)Landroid/support/v4/provider/FontsContractCompat$FontInfo;

    move-result-object v6

    .line 241
    .local v6, "bestFont":Landroid/support/v4/provider/FontsContractCompat$FontInfo;
    invoke-virtual/range {p1 .. p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7

    .line 242
    .local v7, "resolver":Landroid/content/ContentResolver;
    nop

    .line 243
    :try_start_0
    invoke-virtual {v6}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->getUri()Landroid/net/Uri;

    move-result-object v8

    const-string v9, "r"

    invoke-virtual {v7, v8, v9, v1}, Landroid/content/ContentResolver;->openFileDescriptor(Landroid/net/Uri;Ljava/lang/String;Landroid/os/CancellationSignal;)Landroid/os/ParcelFileDescriptor;

    move-result-object v8
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2

    .line 242
    .local v8, "pfd":Landroid/os/ParcelFileDescriptor;
    nop

    .line 244
    :try_start_1
    new-instance v9, Landroid/graphics/Typeface$Builder;

    invoke-virtual {v8}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v10

    invoke-direct {v9, v10}, Landroid/graphics/Typeface$Builder;-><init>(Ljava/io/FileDescriptor;)V

    .line 245
    invoke-virtual {v6}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->getWeight()I

    move-result v10

    invoke-virtual {v9, v10}, Landroid/graphics/Typeface$Builder;->setWeight(I)Landroid/graphics/Typeface$Builder;

    move-result-object v9

    .line 246
    invoke-virtual {v6}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->isItalic()Z

    move-result v10

    invoke-virtual {v9, v10}, Landroid/graphics/Typeface$Builder;->setItalic(Z)Landroid/graphics/Typeface$Builder;

    move-result-object v9

    .line 247
    invoke-virtual {v9}, Landroid/graphics/Typeface$Builder;->build()Landroid/graphics/Typeface;

    move-result-object v9
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 248
    if-eqz v8, :cond_1

    :try_start_2
    invoke-virtual {v8}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    :cond_1
    return-object v9

    :catchall_0
    move-exception v0

    move-object v9, v0

    move-object v10, v5

    goto :goto_0

    .line 242
    :catch_0
    move-exception v0

    move-object v9, v0

    :try_start_3
    throw v9
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 248
    :catchall_1
    move-exception v0

    move-object v10, v9

    move-object v9, v0

    :goto_0
    if-eqz v8, :cond_3

    if-eqz v10, :cond_2

    :try_start_4
    invoke-virtual {v8}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_4
    .catch Ljava/lang/Throwable; {:try_start_4 .. :try_end_4} :catch_1
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2

    goto :goto_1

    :catch_1
    move-exception v0

    :try_start_5
    invoke-virtual {v10, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    goto :goto_1

    :cond_2
    invoke-virtual {v8}, Landroid/os/ParcelFileDescriptor;->close()V

    :cond_3
    :goto_1
    throw v9
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_2

    .line 248
    .end local v8    # "pfd":Landroid/os/ParcelFileDescriptor;
    :catch_2
    move-exception v0

    move-object v8, v0

    .line 249
    .local v8, "e":Ljava/io/IOException;
    return-object v5

    .line 252
    .end local v6    # "bestFont":Landroid/support/v4/provider/FontsContractCompat$FontInfo;
    .end local v7    # "resolver":Landroid/content/ContentResolver;
    .end local v8    # "e":Ljava/io/IOException;
    :cond_4
    move-object/from16 v3, p0

    move/from16 v4, p4

    move-object/from16 v6, p1

    invoke-static {v6, v2, v1}, Landroid/support/v4/provider/FontsContractCompat;->prepareFontData(Landroid/content/Context;[Landroid/support/v4/provider/FontsContractCompat$FontInfo;Landroid/os/CancellationSignal;)Ljava/util/Map;

    move-result-object v7

    .line 254
    .local v7, "uriBuffer":Ljava/util/Map;, "Ljava/util/Map<Landroid/net/Uri;Ljava/nio/ByteBuffer;>;"
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->newFamily()Ljava/lang/Object;

    move-result-object v8

    .line 255
    .local v8, "fontFamily":Ljava/lang/Object;
    const/4 v9, 0x0

    .line 256
    .local v9, "atLeastOneFont":Z
    array-length v10, v2

    const/4 v11, 0x0

    :goto_2
    if-ge v11, v10, :cond_7

    aget-object v12, v2, v11

    .line 257
    .local v12, "font":Landroid/support/v4/provider/FontsContractCompat$FontInfo;
    invoke-virtual {v12}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->getUri()Landroid/net/Uri;

    move-result-object v13

    invoke-interface {v7, v13}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/nio/ByteBuffer;

    .line 258
    .local v13, "fontBuffer":Ljava/nio/ByteBuffer;
    if-nez v13, :cond_5

    .line 259
    goto :goto_3

    .line 261
    :cond_5
    nop

    .line 262
    invoke-virtual {v12}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->getTtcIndex()I

    move-result v14

    invoke-virtual {v12}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->getWeight()I

    move-result v15

    invoke-virtual {v12}, Landroid/support/v4/provider/FontsContractCompat$FontInfo;->isItalic()Z

    move-result v5

    .line 261
    invoke-static {v8, v13, v14, v15, v5}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->addFontFromBuffer(Ljava/lang/Object;Ljava/nio/ByteBuffer;III)Z

    move-result v5

    .line 263
    .local v5, "success":Z
    if-nez v5, :cond_6

    .line 264
    invoke-static {v8}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->abortCreation(Ljava/lang/Object;)Z

    .line 265
    const/4 v10, 0x0

    return-object v10

    .line 267
    :cond_6
    const/4 v5, 0x1

    .line 256
    .end local v9    # "atLeastOneFont":Z
    .end local v12    # "font":Landroid/support/v4/provider/FontsContractCompat$FontInfo;
    .end local v13    # "fontBuffer":Ljava/nio/ByteBuffer;
    .local v5, "atLeastOneFont":Z
    move v9, v5

    .line 256
    .end local v5    # "atLeastOneFont":Z
    .restart local v9    # "atLeastOneFont":Z
    :goto_3
    add-int/lit8 v11, v11, 0x1

    const/4 v5, 0x0

    goto :goto_2

    .line 269
    :cond_7
    if-nez v9, :cond_8

    .line 270
    invoke-static {v8}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->abortCreation(Ljava/lang/Object;)Z

    .line 271
    const/4 v5, 0x0

    return-object v5

    .line 273
    :cond_8
    const/4 v5, 0x0

    invoke-static {v8}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->freeze(Ljava/lang/Object;)Z

    move-result v10

    if-nez v10, :cond_9

    .line 274
    return-object v5

    .line 276
    :cond_9
    invoke-static {v8}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->createFromFamiliesWithDefault(Ljava/lang/Object;)Landroid/graphics/Typeface;

    move-result-object v5

    return-object v5
.end method

.method public createFromResourcesFontFile(Landroid/content/Context;Landroid/content/res/Resources;ILjava/lang/String;I)Landroid/graphics/Typeface;
    .locals 7
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "resources"    # Landroid/content/res/Resources;
    .param p3, "id"    # I
    .param p4, "path"    # Ljava/lang/String;
    .param p5, "style"    # I
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 286
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->isFontFamilyPrivateAPIAvailable()Z

    move-result v0

    if-nez v0, :cond_0

    .line 287
    invoke-super/range {p0 .. p5}, Landroid/support/v4/graphics/TypefaceCompatApi21Impl;->createFromResourcesFontFile(Landroid/content/Context;Landroid/content/res/Resources;ILjava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v0

    return-object v0

    .line 289
    :cond_0
    invoke-static {}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->newFamily()Ljava/lang/Object;

    move-result-object v0

    .line 290
    .local v0, "fontFamily":Ljava/lang/Object;
    const/4 v4, 0x0

    const/4 v5, -0x1

    const/4 v6, -0x1

    move-object v1, p1

    move-object v2, v0

    move-object v3, p4

    invoke-static/range {v1 .. v6}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->addFontFromAssetManager(Landroid/content/Context;Ljava/lang/Object;Ljava/lang/String;III)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_1

    .line 293
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->abortCreation(Ljava/lang/Object;)Z

    .line 294
    return-object v2

    .line 296
    :cond_1
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->freeze(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 297
    return-object v2

    .line 299
    :cond_2
    invoke-static {v0}, Landroid/support/v4/graphics/TypefaceCompatApi26Impl;->createFromFamiliesWithDefault(Ljava/lang/Object;)Landroid/graphics/Typeface;

    move-result-object v1

    return-object v1
.end method
