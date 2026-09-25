.class Landroid/support/transition/ImageViewUtilsApi21;
.super Ljava/lang/Object;
.source "ImageViewUtilsApi21.java"

# interfaces
.implements Landroid/support/transition/ImageViewUtilsImpl;


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x15
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ImageViewUtilsApi21"

.field private static sAnimateTransformMethod:Ljava/lang/reflect/Method;

.field private static sAnimateTransformMethodFetched:Z


# direct methods
.method constructor <init>()V
    .locals 0

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private fetchAnimateTransformMethod()V
    .locals 6

    .line 61
    sget-boolean v0, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethodFetched:Z

    if-nez v0, :cond_0

    .line 63
    const/4 v0, 0x1

    :try_start_0
    const-class v1, Landroid/widget/ImageView;

    const-string v2, "animateTransform"

    new-array v3, v0, [Ljava/lang/Class;

    const/4 v4, 0x0

    const-class v5, Landroid/graphics/Matrix;

    aput-object v5, v3, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    sput-object v1, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethod:Ljava/lang/reflect/Method;

    .line 65
    sget-object v1, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethod:Ljava/lang/reflect/Method;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 68
    goto :goto_0

    .line 66
    :catch_0
    move-exception v1

    .line 67
    .local v1, "e":Ljava/lang/NoSuchMethodException;
    const-string v2, "ImageViewUtilsApi21"

    const-string v3, "Failed to retrieve animateTransform method"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 69
    .end local v1    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    sput-boolean v0, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethodFetched:Z

    .line 71
    :cond_0
    return-void
.end method


# virtual methods
.method public animateTransform(Landroid/widget/ImageView;Landroid/graphics/Matrix;)V
    .locals 3
    .param p1, "view"    # Landroid/widget/ImageView;
    .param p2, "matrix"    # Landroid/graphics/Matrix;

    .line 43
    invoke-direct {p0}, Landroid/support/transition/ImageViewUtilsApi21;->fetchAnimateTransformMethod()V

    .line 44
    sget-object v0, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethod:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_0

    .line 46
    :try_start_0
    sget-object v0, Landroid/support/transition/ImageViewUtilsApi21;->sAnimateTransformMethod:Ljava/lang/reflect/Method;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p2, v1, v2

    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 49
    :catch_0
    move-exception v0

    .line 50
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getCause()Ljava/lang/Throwable;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 47
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 51
    :goto_0
    nop

    .line 53
    :cond_0
    return-void
.end method

.method public reserveEndAnimateTransform(Landroid/widget/ImageView;Landroid/animation/Animator;)V
    .locals 0
    .param p1, "view"    # Landroid/widget/ImageView;
    .param p2, "animator"    # Landroid/animation/Animator;

    .line 58
    return-void
.end method

.method public startAnimateTransform(Landroid/widget/ImageView;)V
    .locals 0
    .param p1, "view"    # Landroid/widget/ImageView;

    .line 39
    return-void
.end method
