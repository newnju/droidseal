.class Landroid/support/transition/GhostViewApi14$Creator;
.super Ljava/lang/Object;
.source "GhostViewApi14.java"

# interfaces
.implements Landroid/support/transition/GhostViewImpl$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/transition/GhostViewApi14;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "Creator"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 46
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static findFrameLayout(Landroid/view/ViewGroup;)Landroid/widget/FrameLayout;
    .locals 2
    .param p0, "viewGroup"    # Landroid/view/ViewGroup;

    .line 84
    :goto_0
    instance-of v0, p0, Landroid/widget/FrameLayout;

    if-nez v0, :cond_1

    .line 85
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 86
    .local v0, "parent":Landroid/view/ViewParent;
    instance-of v1, v0, Landroid/view/ViewGroup;

    if-nez v1, :cond_0

    .line 87
    const/4 v1, 0x0

    return-object v1

    .line 89
    :cond_0
    move-object p0, v0

    check-cast p0, Landroid/view/ViewGroup;

    .line 90
    .end local v0    # "parent":Landroid/view/ViewParent;
    goto :goto_0

    .line 91
    :cond_1
    move-object v0, p0

    check-cast v0, Landroid/widget/FrameLayout;

    return-object v0
.end method


# virtual methods
.method public addGhost(Landroid/view/View;Landroid/view/ViewGroup;Landroid/graphics/Matrix;)Landroid/support/transition/GhostViewImpl;
    .locals 3
    .param p1, "view"    # Landroid/view/View;
    .param p2, "viewGroup"    # Landroid/view/ViewGroup;
    .param p3, "matrix"    # Landroid/graphics/Matrix;

    .line 50
    invoke-static {p1}, Landroid/support/transition/GhostViewApi14;->getGhostView(Landroid/view/View;)Landroid/support/transition/GhostViewApi14;

    move-result-object v0

    .line 51
    .local v0, "ghostView":Landroid/support/transition/GhostViewApi14;
    if-nez v0, :cond_1

    .line 52
    invoke-static {p2}, Landroid/support/transition/GhostViewApi14$Creator;->findFrameLayout(Landroid/view/ViewGroup;)Landroid/widget/FrameLayout;

    move-result-object v1

    .line 53
    .local v1, "frameLayout":Landroid/widget/FrameLayout;
    if-nez v1, :cond_0

    .line 54
    const/4 v2, 0x0

    return-object v2

    .line 56
    :cond_0
    new-instance v2, Landroid/support/transition/GhostViewApi14;

    invoke-direct {v2, p1}, Landroid/support/transition/GhostViewApi14;-><init>(Landroid/view/View;)V

    move-object v0, v2

    .line 57
    invoke-virtual {v1, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 59
    .end local v1    # "frameLayout":Landroid/widget/FrameLayout;
    :cond_1
    iget v1, v0, Landroid/support/transition/GhostViewApi14;->mReferences:I

    add-int/lit8 v1, v1, 0x1

    iput v1, v0, Landroid/support/transition/GhostViewApi14;->mReferences:I

    .line 60
    return-object v0
.end method

.method public removeGhost(Landroid/view/View;)V
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 65
    invoke-static {p1}, Landroid/support/transition/GhostViewApi14;->getGhostView(Landroid/view/View;)Landroid/support/transition/GhostViewApi14;

    move-result-object v0

    .line 66
    .local v0, "ghostView":Landroid/support/transition/GhostViewApi14;
    if-eqz v0, :cond_0

    .line 67
    iget v1, v0, Landroid/support/transition/GhostViewApi14;->mReferences:I

    add-int/lit8 v1, v1, -0x1

    iput v1, v0, Landroid/support/transition/GhostViewApi14;->mReferences:I

    .line 68
    iget v1, v0, Landroid/support/transition/GhostViewApi14;->mReferences:I

    if-gtz v1, :cond_0

    .line 69
    invoke-virtual {v0}, Landroid/support/transition/GhostViewApi14;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    .line 70
    .local v1, "parent":Landroid/view/ViewParent;
    instance-of v2, v1, Landroid/view/ViewGroup;

    if-eqz v2, :cond_0

    .line 71
    move-object v2, v1

    check-cast v2, Landroid/view/ViewGroup;

    .line 72
    .local v2, "group":Landroid/view/ViewGroup;
    invoke-virtual {v2, v0}, Landroid/view/ViewGroup;->endViewTransition(Landroid/view/View;)V

    .line 73
    invoke-virtual {v2, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 77
    .end local v1    # "parent":Landroid/view/ViewParent;
    .end local v2    # "group":Landroid/view/ViewGroup;
    :cond_0
    return-void
.end method
