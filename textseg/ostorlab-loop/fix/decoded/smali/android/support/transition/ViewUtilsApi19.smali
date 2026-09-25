.class Landroid/support/transition/ViewUtilsApi19;
.super Landroid/support/transition/ViewUtilsApi18;
.source "ViewUtilsApi19.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x13
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ViewUtilsApi19"

.field private static sGetTransitionAlphaMethod:Ljava/lang/reflect/Method;

.field private static sGetTransitionAlphaMethodFetched:Z

.field private static sSetTransitionAlphaMethod:Ljava/lang/reflect/Method;

.field private static sSetTransitionAlphaMethodFetched:Z


# direct methods
.method constructor <init>()V
    .locals 0

    .line 28
    invoke-direct {p0}, Landroid/support/transition/ViewUtilsApi18;-><init>()V

    return-void
.end method

.method private fetchGetTransitionAlphaMethod()V
    .locals 4

    .line 92
    sget-boolean v0, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethodFetched:Z

    if-nez v0, :cond_0

    .line 94
    const/4 v0, 0x1

    :try_start_0
    const-class v1, Landroid/view/View;

    const-string v2, "getTransitionAlpha"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    sput-object v1, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    .line 95
    sget-object v1, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 98
    goto :goto_0

    .line 96
    :catch_0
    move-exception v1

    .line 97
    .local v1, "e":Ljava/lang/NoSuchMethodException;
    const-string v2, "ViewUtilsApi19"

    const-string v3, "Failed to retrieve getTransitionAlpha method"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 99
    .end local v1    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    sput-boolean v0, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethodFetched:Z

    .line 101
    :cond_0
    return-void
.end method

.method private fetchSetTransitionAlphaMethod()V
    .locals 6

    .line 79
    sget-boolean v0, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethodFetched:Z

    if-nez v0, :cond_0

    .line 81
    const/4 v0, 0x1

    :try_start_0
    const-class v1, Landroid/view/View;

    const-string v2, "setTransitionAlpha"

    new-array v3, v0, [Ljava/lang/Class;

    const/4 v4, 0x0

    sget-object v5, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    aput-object v5, v3, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    sput-object v1, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    .line 83
    sget-object v1, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 86
    goto :goto_0

    .line 84
    :catch_0
    move-exception v1

    .line 85
    .local v1, "e":Ljava/lang/NoSuchMethodException;
    const-string v2, "ViewUtilsApi19"

    const-string v3, "Failed to retrieve setTransitionAlpha method"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 87
    .end local v1    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    sput-boolean v0, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethodFetched:Z

    .line 89
    :cond_0
    return-void
.end method


# virtual methods
.method public clearNonTransitionAlpha(Landroid/view/View;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 76
    return-void
.end method

.method public getTransitionAlpha(Landroid/view/View;)F
    .locals 3
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 55
    invoke-direct {p0}, Landroid/support/transition/ViewUtilsApi19;->fetchGetTransitionAlphaMethod()V

    .line 56
    sget-object v0, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_0

    .line 58
    :try_start_0
    sget-object v0, Landroid/support/transition/ViewUtilsApi19;->sGetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Float;

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    .line 61
    :catch_0
    move-exception v0

    .line 62
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getCause()Ljava/lang/Throwable;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 59
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 63
    nop

    .line 65
    :cond_0
    invoke-super {p0, p1}, Landroid/support/transition/ViewUtilsApi18;->getTransitionAlpha(Landroid/view/View;)F

    move-result v0

    return v0
.end method

.method public saveNonTransitionAlpha(Landroid/view/View;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 71
    return-void
.end method

.method public setTransitionAlpha(Landroid/view/View;F)V
    .locals 4
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "alpha"    # F

    .line 39
    invoke-direct {p0}, Landroid/support/transition/ViewUtilsApi19;->fetchSetTransitionAlphaMethod()V

    .line 40
    sget-object v0, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_0

    .line 42
    :try_start_0
    sget-object v0, Landroid/support/transition/ViewUtilsApi19;->sSetTransitionAlphaMethod:Ljava/lang/reflect/Method;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-static {p2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v3

    aput-object v3, v1, v2

    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 45
    :catch_0
    move-exception v0

    .line 46
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getCause()Ljava/lang/Throwable;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 43
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 47
    :goto_0
    goto :goto_1

    .line 49
    :cond_0
    invoke-virtual {p1, p2}, Landroid/view/View;->setAlpha(F)V

    .line 51
    :goto_1
    return-void
.end method
