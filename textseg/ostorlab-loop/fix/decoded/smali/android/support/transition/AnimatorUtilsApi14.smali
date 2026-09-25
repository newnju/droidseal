.class Landroid/support/transition/AnimatorUtilsApi14;
.super Ljava/lang/Object;
.source "AnimatorUtilsApi14.java"

# interfaces
.implements Landroid/support/transition/AnimatorUtilsImpl;


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0xe
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 66
    return-void
.end method


# virtual methods
.method public addPauseListener(Landroid/animation/Animator;Landroid/animation/AnimatorListenerAdapter;)V
    .locals 0
    .param p1, "animator"    # Landroid/animation/Animator;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "listener"    # Landroid/animation/AnimatorListenerAdapter;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 33
    return-void
.end method

.method public pause(Landroid/animation/Animator;)V
    .locals 5
    .param p1, "animator"    # Landroid/animation/Animator;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 37
    invoke-virtual {p1}, Landroid/animation/Animator;->getListeners()Ljava/util/ArrayList;

    move-result-object v0

    .line 38
    .local v0, "listeners":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/animation/Animator$AnimatorListener;>;"
    if-eqz v0, :cond_1

    .line 39
    const/4 v1, 0x0

    .line 39
    .local v1, "i":I
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 39
    .local v2, "size":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 40
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/animation/Animator$AnimatorListener;

    .line 41
    .local v3, "listener":Landroid/animation/Animator$AnimatorListener;
    instance-of v4, v3, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;

    if-eqz v4, :cond_0

    .line 42
    move-object v4, v3

    check-cast v4, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;

    invoke-interface {v4, p1}, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;->onAnimationPause(Landroid/animation/Animator;)V

    .line 39
    .end local v3    # "listener":Landroid/animation/Animator$AnimatorListener;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 46
    .end local v1    # "i":I
    .end local v2    # "size":I
    :cond_1
    return-void
.end method

.method public resume(Landroid/animation/Animator;)V
    .locals 5
    .param p1, "animator"    # Landroid/animation/Animator;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 50
    invoke-virtual {p1}, Landroid/animation/Animator;->getListeners()Ljava/util/ArrayList;

    move-result-object v0

    .line 51
    .local v0, "listeners":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/animation/Animator$AnimatorListener;>;"
    if-eqz v0, :cond_1

    .line 52
    const/4 v1, 0x0

    .line 52
    .local v1, "i":I
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 52
    .local v2, "size":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 53
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/animation/Animator$AnimatorListener;

    .line 54
    .local v3, "listener":Landroid/animation/Animator$AnimatorListener;
    instance-of v4, v3, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;

    if-eqz v4, :cond_0

    .line 55
    move-object v4, v3

    check-cast v4, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;

    invoke-interface {v4, p1}, Landroid/support/transition/AnimatorUtilsApi14$AnimatorPauseListenerCompat;->onAnimationResume(Landroid/animation/Animator;)V

    .line 52
    .end local v3    # "listener":Landroid/animation/Animator$AnimatorListener;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 59
    .end local v1    # "i":I
    .end local v2    # "size":I
    :cond_1
    return-void
.end method
