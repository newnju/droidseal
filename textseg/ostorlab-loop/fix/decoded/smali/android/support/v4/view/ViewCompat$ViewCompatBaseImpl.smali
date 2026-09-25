.class Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;
.super Ljava/lang/Object;
.source "ViewCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/view/ViewCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ViewCompatBaseImpl"
.end annotation


# static fields
.field static sAccessibilityDelegateCheckFailed:Z

.field static sAccessibilityDelegateField:Ljava/lang/reflect/Field;

.field private static sChildrenDrawingOrderMethod:Ljava/lang/reflect/Method;

.field private static sMinHeightField:Ljava/lang/reflect/Field;

.field private static sMinHeightFieldFetched:Z

.field private static sMinWidthField:Ljava/lang/reflect/Field;

.field private static sMinWidthFieldFetched:Z

.field private static sTransitionNameMap:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Landroid/view/View;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mDispatchFinishTemporaryDetach:Ljava/lang/reflect/Method;

.field private mDispatchStartTemporaryDetach:Ljava/lang/reflect/Method;

.field private mTempDetachBound:Z

.field mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Landroid/view/View;",
            "Landroid/support/v4/view/ViewPropertyAnimatorCompat;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 440
    const/4 v0, 0x0

    sput-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateCheckFailed:Z

    return-void
.end method

.method constructor <init>()V
    .locals 1

    .line 428
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 437
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;

    return-void
.end method

.method private bindTempDetach()V
    .locals 4

    .line 620
    :try_start_0
    const-class v0, Landroid/view/View;

    const-string v1, "dispatchStartTemporaryDetach"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchStartTemporaryDetach:Ljava/lang/reflect/Method;

    .line 622
    const-class v0, Landroid/view/View;

    const-string v1, "dispatchFinishTemporaryDetach"

    new-array v2, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchFinishTemporaryDetach:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 626
    goto :goto_0

    .line 624
    :catch_0
    move-exception v0

    .line 625
    .local v0, "e":Ljava/lang/NoSuchMethodException;
    const-string v1, "ViewCompat"

    const-string v2, "Couldn\'t find method"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 627
    .end local v0    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mTempDetachBound:Z

    .line 628
    return-void
.end method

.method private static tickleInvalidationFlag(Landroid/view/View;)V
    .locals 2
    .param p0, "view"    # Landroid/view/View;

    .line 932
    invoke-virtual {p0}, Landroid/view/View;->getTranslationY()F

    move-result v0

    .line 933
    .local v0, "y":F
    const/high16 v1, 0x3f800000    # 1.0f

    add-float/2addr v1, v0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 934
    invoke-virtual {p0, v0}, Landroid/view/View;->setTranslationY(F)V

    .line 935
    return-void
.end method


# virtual methods
.method public addKeyboardNavigationClusters(Landroid/view/View;Ljava/util/Collection;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2    # Ljava/util/Collection;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p3, "direction"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            "Ljava/util/Collection<",
            "Landroid/view/View;",
            ">;I)V"
        }
    .end annotation

    .line 985
    .local p2, "views":Ljava/util/Collection;, "Ljava/util/Collection<Landroid/view/View;>;"
    return-void
.end method

.method public animate(Landroid/view/View;)Landroid/support/v4/view/ViewPropertyAnimatorCompat;
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 677
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;

    if-nez v0, :cond_0

    .line 678
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;

    .line 680
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;

    invoke-virtual {v0, p1}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/v4/view/ViewPropertyAnimatorCompat;

    .line 681
    .local v0, "vpa":Landroid/support/v4/view/ViewPropertyAnimatorCompat;
    if-nez v0, :cond_1

    .line 682
    new-instance v1, Landroid/support/v4/view/ViewPropertyAnimatorCompat;

    invoke-direct {v1, p1}, Landroid/support/v4/view/ViewPropertyAnimatorCompat;-><init>(Landroid/view/View;)V

    move-object v0, v1

    .line 683
    iget-object v1, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mViewPropertyAnimatorCompatMap:Ljava/util/WeakHashMap;

    invoke-virtual {v1, p1, v0}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 685
    :cond_1
    return-object v0
.end method

.method public cancelDragAndDrop(Landroid/view/View;)V
    .locals 0
    .param p1, "v"    # Landroid/view/View;

    .line 481
    return-void
.end method

.method public dispatchApplyWindowInsets(Landroid/view/View;Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;
    .locals 0
    .param p1, "v"    # Landroid/view/View;
    .param p2, "insets"    # Landroid/support/v4/view/WindowInsetsCompat;

    .line 765
    return-object p2
.end method

.method public dispatchFinishTemporaryDetach(Landroid/view/View;)V
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 599
    iget-boolean v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mTempDetachBound:Z

    if-nez v0, :cond_0

    .line 600
    invoke-direct {p0}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->bindTempDetach()V

    .line 602
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchFinishTemporaryDetach:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_1

    .line 604
    :try_start_0
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchFinishTemporaryDetach:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 605
    :catch_0
    move-exception v0

    .line 606
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "ViewCompat"

    const-string v2, "Error calling dispatchFinishTemporaryDetach"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 607
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    goto :goto_1

    .line 610
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->onFinishTemporaryDetach()V

    .line 612
    :goto_1
    return-void
.end method

.method public dispatchNestedFling(Landroid/view/View;FFZ)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "velocityX"    # F
    .param p3, "velocityY"    # F
    .param p4, "consumed"    # Z

    .line 853
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 854
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0, p2, p3, p4}, Landroid/support/v4/view/NestedScrollingChild;->dispatchNestedFling(FFZ)Z

    move-result v0

    return v0

    .line 857
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public dispatchNestedPreFling(Landroid/view/View;FF)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "velocityX"    # F
    .param p3, "velocityY"    # F

    .line 861
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 862
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0, p2, p3}, Landroid/support/v4/view/NestedScrollingChild;->dispatchNestedPreFling(FF)Z

    move-result v0

    return v0

    .line 864
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public dispatchNestedPreScroll(Landroid/view/View;II[I[I)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "dx"    # I
    .param p3, "dy"    # I
    .param p4, "consumed"    # [I
    .param p5, "offsetInWindow"    # [I

    .line 844
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 845
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0, p2, p3, p4, p5}, Landroid/support/v4/view/NestedScrollingChild;->dispatchNestedPreScroll(II[I[I)Z

    move-result v0

    return v0

    .line 848
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public dispatchNestedScroll(Landroid/view/View;IIII[I)Z
    .locals 7
    .param p1, "view"    # Landroid/view/View;
    .param p2, "dxConsumed"    # I
    .param p3, "dyConsumed"    # I
    .param p4, "dxUnconsumed"    # I
    .param p5, "dyUnconsumed"    # I
    .param p6, "offsetInWindow"    # [I

    .line 835
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 836
    move-object v1, p1

    check-cast v1, Landroid/support/v4/view/NestedScrollingChild;

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    invoke-interface/range {v1 .. v6}, Landroid/support/v4/view/NestedScrollingChild;->dispatchNestedScroll(IIII[I)Z

    move-result v0

    return v0

    .line 839
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public dispatchStartTemporaryDetach(Landroid/view/View;)V
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 583
    iget-boolean v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mTempDetachBound:Z

    if-nez v0, :cond_0

    .line 584
    invoke-direct {p0}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->bindTempDetach()V

    .line 586
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchStartTemporaryDetach:Ljava/lang/reflect/Method;

    if-eqz v0, :cond_1

    .line 588
    :try_start_0
    iget-object v0, p0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->mDispatchStartTemporaryDetach:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 589
    :catch_0
    move-exception v0

    .line 590
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "ViewCompat"

    const-string v2, "Error calling dispatchStartTemporaryDetach"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 591
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    goto :goto_1

    .line 594
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->onStartTemporaryDetach()V

    .line 596
    :goto_1
    return-void
.end method

.method public getAccessibilityLiveRegion(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 563
    const/4 v0, 0x0

    return v0
.end method

.method public getAccessibilityNodeProvider(Landroid/view/View;)Landroid/support/v4/view/accessibility/AccessibilityNodeProviderCompat;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 532
    const/4 v0, 0x0

    return-object v0
.end method

.method public getBackgroundTintList(Landroid/view/View;)Landroid/content/res/ColorStateList;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 790
    instance-of v0, p1, Landroid/support/v4/view/TintableBackgroundView;

    if-eqz v0, :cond_0

    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/TintableBackgroundView;

    .line 791
    invoke-interface {v0}, Landroid/support/v4/view/TintableBackgroundView;->getSupportBackgroundTintList()Landroid/content/res/ColorStateList;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return-object v0
.end method

.method public getBackgroundTintMode(Landroid/view/View;)Landroid/graphics/PorterDuff$Mode;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 808
    instance-of v0, p1, Landroid/support/v4/view/TintableBackgroundView;

    if-eqz v0, :cond_0

    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/TintableBackgroundView;

    .line 809
    invoke-interface {v0}, Landroid/support/v4/view/TintableBackgroundView;->getSupportBackgroundTintMode()Landroid/graphics/PorterDuff$Mode;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return-object v0
.end method

.method public getClipBounds(Landroid/view/View;)Landroid/graphics/Rect;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 727
    const/4 v0, 0x0

    return-object v0
.end method

.method public getDisplay(Landroid/view/View;)Landroid/view/Display;
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 942
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->isAttachedToWindow(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 943
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "window"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    .line 945
    .local v0, "wm":Landroid/view/WindowManager;
    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    return-object v1

    .line 947
    .end local v0    # "wm":Landroid/view/WindowManager;
    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method

.method public getElevation(Landroid/view/View;)F
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 713
    const/4 v0, 0x0

    return v0
.end method

.method public getFitsSystemWindows(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 752
    const/4 v0, 0x0

    return v0
.end method

.method getFrameTime()J
    .locals 2

    .line 513
    invoke-static {}, Landroid/animation/ValueAnimator;->getFrameDelay()J

    move-result-wide v0

    return-wide v0
.end method

.method public getImportantForAccessibility(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 517
    const/4 v0, 0x0

    return v0
.end method

.method public getLabelFor(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 536
    const/4 v0, 0x0

    return v0
.end method

.method public getLayoutDirection(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 551
    const/4 v0, 0x0

    return v0
.end method

.method public getMinimumHeight(Landroid/view/View;)I
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 654
    sget-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightFieldFetched:Z

    if-nez v0, :cond_0

    .line 656
    const/4 v0, 0x1

    :try_start_0
    const-class v1, Landroid/view/View;

    const-string v2, "mMinHeight"

    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    sput-object v1, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightField:Ljava/lang/reflect/Field;

    .line 657
    sget-object v1, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightField:Ljava/lang/reflect/Field;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_0

    .line 660
    goto :goto_0

    .line 658
    :catch_0
    move-exception v1

    .line 661
    :goto_0
    sput-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightFieldFetched:Z

    .line 664
    :cond_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightField:Ljava/lang/reflect/Field;

    if-eqz v0, :cond_1

    .line 666
    :try_start_1
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinHeightField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v0

    .line 667
    :catch_1
    move-exception v0

    .line 673
    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method public getMinimumWidth(Landroid/view/View;)I
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 631
    sget-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthFieldFetched:Z

    if-nez v0, :cond_0

    .line 633
    const/4 v0, 0x1

    :try_start_0
    const-class v1, Landroid/view/View;

    const-string v2, "mMinWidth"

    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    sput-object v1, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthField:Ljava/lang/reflect/Field;

    .line 634
    sget-object v1, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthField:Ljava/lang/reflect/Field;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_0

    .line 637
    goto :goto_0

    .line 635
    :catch_0
    move-exception v1

    .line 638
    :goto_0
    sput-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthFieldFetched:Z

    .line 641
    :cond_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthField:Ljava/lang/reflect/Field;

    if-eqz v0, :cond_1

    .line 643
    :try_start_1
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sMinWidthField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v0

    .line 644
    :catch_1
    move-exception v0

    .line 650
    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method public getNextClusterForwardId(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 954
    const/4 v0, -0x1

    return v0
.end method

.method public getPaddingEnd(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 575
    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v0

    return v0
.end method

.method public getPaddingStart(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 571
    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v0

    return v0
.end method

.method public getParentForAccessibility(Landroid/view/View;)Landroid/view/ViewParent;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 559
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    return-object v0
.end method

.method public getScrollIndicators(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 896
    const/4 v0, 0x0

    return v0
.end method

.method public getTransitionName(Landroid/view/View;)Ljava/lang/String;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 696
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sTransitionNameMap:Ljava/util/WeakHashMap;

    if-nez v0, :cond_0

    .line 697
    const/4 v0, 0x0

    return-object v0

    .line 699
    :cond_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sTransitionNameMap:Ljava/util/WeakHashMap;

    invoke-virtual {v0, p1}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    return-object v0
.end method

.method public getTranslationZ(Landroid/view/View;)F
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 720
    const/4 v0, 0x0

    return v0
.end method

.method public getWindowSystemUiVisibility(Landroid/view/View;)I
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 703
    const/4 v0, 0x0

    return v0
.end method

.method public getZ(Landroid/view/View;)F
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 880
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->getTranslationZ(Landroid/view/View;)F

    move-result v0

    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->getElevation(Landroid/view/View;)F

    move-result v1

    add-float/2addr v0, v1

    return v0
.end method

.method public hasAccessibilityDelegate(Landroid/view/View;)Z
    .locals 4
    .param p1, "v"    # Landroid/view/View;

    .line 448
    sget-boolean v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateCheckFailed:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 449
    return v1

    .line 451
    :cond_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateField:Ljava/lang/reflect/Field;

    const/4 v2, 0x1

    if-nez v0, :cond_1

    .line 453
    :try_start_0
    const-class v0, Landroid/view/View;

    const-string v3, "mAccessibilityDelegate"

    .line 454
    invoke-virtual {v0, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    sput-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateField:Ljava/lang/reflect/Field;

    .line 455
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    .line 459
    goto :goto_0

    .line 456
    :catch_0
    move-exception v0

    .line 457
    .local v0, "t":Ljava/lang/Throwable;
    sput-boolean v2, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateCheckFailed:Z

    .line 458
    return v1

    .line 462
    .end local v0    # "t":Ljava/lang/Throwable;
    :cond_1
    :goto_0
    :try_start_1
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_1

    if-eqz v0, :cond_2

    move v1, v2

    nop

    :cond_2
    return v1

    .line 463
    :catch_1
    move-exception v0

    .line 464
    .restart local v0    # "t":Ljava/lang/Throwable;
    sput-boolean v2, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sAccessibilityDelegateCheckFailed:Z

    .line 465
    return v1
.end method

.method public hasExplicitFocusable(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 992
    invoke-virtual {p1}, Landroid/view/View;->hasFocusable()Z

    move-result v0

    return v0
.end method

.method public hasNestedScrollingParent(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 827
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 828
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0}, Landroid/support/v4/view/NestedScrollingChild;->hasNestedScrollingParent()Z

    move-result v0

    return v0

    .line 830
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public hasOnClickListeners(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 892
    const/4 v0, 0x0

    return v0
.end method

.method public hasOverlappingRendering(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 615
    const/4 v0, 0x1

    return v0
.end method

.method public hasTransientState(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 489
    const/4 v0, 0x0

    return v0
.end method

.method public isAttachedToWindow(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 888
    invoke-virtual {p1}, Landroid/view/View;->getWindowToken()Landroid/os/IBinder;

    move-result-object v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isFocusedByDefault(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 970
    const/4 v0, 0x0

    return v0
.end method

.method public isImportantForAccessibility(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 524
    const/4 v0, 0x1

    return v0
.end method

.method public isInLayout(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 868
    const/4 v0, 0x0

    return v0
.end method

.method public isKeyboardNavigationCluster(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 962
    const/4 v0, 0x0

    return v0
.end method

.method public isLaidOut(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 872
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_0

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v0

    if-lez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isLayoutDirectionResolved(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 876
    const/4 v0, 0x0

    return v0
.end method

.method public isNestedScrollingEnabled(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 779
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 780
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0}, Landroid/support/v4/view/NestedScrollingChild;->isNestedScrollingEnabled()Z

    move-result v0

    return v0

    .line 782
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public isPaddingRelative(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 769
    const/4 v0, 0x0

    return v0
.end method

.method public keyboardNavigationClusterSearch(Landroid/view/View;Landroid/view/View;I)Landroid/view/View;
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "currentCluster"    # Landroid/view/View;
    .param p3, "direction"    # I

    .line 979
    const/4 v0, 0x0

    return-object v0
.end method

.method public offsetLeftAndRight(Landroid/view/View;I)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "offset"    # I

    .line 908
    invoke-virtual {p1, p2}, Landroid/view/View;->offsetLeftAndRight(I)V

    .line 909
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_0

    .line 910
    invoke-static {p1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->tickleInvalidationFlag(Landroid/view/View;)V

    .line 912
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 913
    .local v0, "parent":Landroid/view/ViewParent;
    instance-of v1, v0, Landroid/view/View;

    if-eqz v1, :cond_0

    .line 914
    move-object v1, v0

    check-cast v1, Landroid/view/View;

    invoke-static {v1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->tickleInvalidationFlag(Landroid/view/View;)V

    .line 917
    .end local v0    # "parent":Landroid/view/ViewParent;
    :cond_0
    return-void
.end method

.method public offsetTopAndBottom(Landroid/view/View;I)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "offset"    # I

    .line 920
    invoke-virtual {p1, p2}, Landroid/view/View;->offsetTopAndBottom(I)V

    .line 921
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_0

    .line 922
    invoke-static {p1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->tickleInvalidationFlag(Landroid/view/View;)V

    .line 924
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 925
    .local v0, "parent":Landroid/view/ViewParent;
    instance-of v1, v0, Landroid/view/View;

    if-eqz v1, :cond_0

    .line 926
    move-object v1, v0

    check-cast v1, Landroid/view/View;

    invoke-static {v1}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->tickleInvalidationFlag(Landroid/view/View;)V

    .line 929
    .end local v0    # "parent":Landroid/view/ViewParent;
    :cond_0
    return-void
.end method

.method public onApplyWindowInsets(Landroid/view/View;Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;
    .locals 0
    .param p1, "v"    # Landroid/view/View;
    .param p2, "insets"    # Landroid/support/v4/view/WindowInsetsCompat;

    .line 761
    return-object p2
.end method

.method public onInitializeAccessibilityNodeInfo(Landroid/view/View;Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;)V
    .locals 1
    .param p1, "v"    # Landroid/view/View;
    .param p2, "info"    # Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;

    .line 470
    invoke-virtual {p2}, Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;->unwrap()Landroid/view/accessibility/AccessibilityNodeInfo;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/view/View;->onInitializeAccessibilityNodeInfo(Landroid/view/accessibility/AccessibilityNodeInfo;)V

    .line 471
    return-void
.end method

.method public performAccessibilityAction(Landroid/view/View;ILandroid/os/Bundle;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "action"    # I
    .param p3, "arguments"    # Landroid/os/Bundle;

    .line 528
    const/4 v0, 0x0

    return v0
.end method

.method public postInvalidateOnAnimation(Landroid/view/View;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;

    .line 497
    invoke-virtual {p1}, Landroid/view/View;->postInvalidate()V

    .line 498
    return-void
.end method

.method public postInvalidateOnAnimation(Landroid/view/View;IIII)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "right"    # I
    .param p5, "bottom"    # I

    .line 501
    invoke-virtual {p1, p2, p3, p4, p5}, Landroid/view/View;->postInvalidate(IIII)V

    .line 502
    return-void
.end method

.method public postOnAnimation(Landroid/view/View;Ljava/lang/Runnable;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "action"    # Ljava/lang/Runnable;

    .line 505
    invoke-virtual {p0}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->getFrameTime()J

    move-result-wide v0

    invoke-virtual {p1, p2, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 506
    return-void
.end method

.method public postOnAnimationDelayed(Landroid/view/View;Ljava/lang/Runnable;J)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "action"    # Ljava/lang/Runnable;
    .param p3, "delayMillis"    # J

    .line 509
    invoke-virtual {p0}, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->getFrameTime()J

    move-result-wide v0

    add-long/2addr v0, p3

    invoke-virtual {p1, p2, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 510
    return-void
.end method

.method public requestApplyInsets(Landroid/view/View;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;

    .line 707
    return-void
.end method

.method public restoreDefaultFocus(Landroid/view/View;)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 988
    invoke-virtual {p1}, Landroid/view/View;->requestFocus()Z

    move-result v0

    return v0
.end method

.method public setAccessibilityDelegate(Landroid/view/View;Landroid/support/v4/view/AccessibilityDelegateCompat;)V
    .locals 1
    .param p1, "v"    # Landroid/view/View;
    .param p2, "delegate"    # Landroid/support/v4/view/AccessibilityDelegateCompat;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 444
    if-nez p2, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p2}, Landroid/support/v4/view/AccessibilityDelegateCompat;->getBridge()Landroid/view/View$AccessibilityDelegate;

    move-result-object v0

    :goto_0
    invoke-virtual {p1, v0}, Landroid/view/View;->setAccessibilityDelegate(Landroid/view/View$AccessibilityDelegate;)V

    .line 445
    return-void
.end method

.method public setAccessibilityLiveRegion(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "mode"    # I

    .line 568
    return-void
.end method

.method public setBackground(Landroid/view/View;Landroid/graphics/drawable/Drawable;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "background"    # Landroid/graphics/drawable/Drawable;

    .line 786
    invoke-virtual {p1, p2}, Landroid/view/View;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 787
    return-void
.end method

.method public setBackgroundTintList(Landroid/view/View;Landroid/content/res/ColorStateList;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "tintList"    # Landroid/content/res/ColorStateList;

    .line 796
    instance-of v0, p1, Landroid/support/v4/view/TintableBackgroundView;

    if-eqz v0, :cond_0

    .line 797
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/TintableBackgroundView;

    invoke-interface {v0, p2}, Landroid/support/v4/view/TintableBackgroundView;->setSupportBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 799
    :cond_0
    return-void
.end method

.method public setBackgroundTintMode(Landroid/view/View;Landroid/graphics/PorterDuff$Mode;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "mode"    # Landroid/graphics/PorterDuff$Mode;

    .line 802
    instance-of v0, p1, Landroid/support/v4/view/TintableBackgroundView;

    if-eqz v0, :cond_0

    .line 803
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/TintableBackgroundView;

    invoke-interface {v0, p2}, Landroid/support/v4/view/TintableBackgroundView;->setSupportBackgroundTintMode(Landroid/graphics/PorterDuff$Mode;)V

    .line 805
    :cond_0
    return-void
.end method

.method public setChildrenDrawingOrderEnabled(Landroid/view/ViewGroup;Z)V
    .locals 6
    .param p1, "viewGroup"    # Landroid/view/ViewGroup;
    .param p2, "enabled"    # Z

    .line 731
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sChildrenDrawingOrderMethod:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    .line 733
    :try_start_0
    const-class v0, Landroid/view/ViewGroup;

    const-string v3, "setChildrenDrawingOrderEnabled"

    new-array v4, v2, [Ljava/lang/Class;

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v4, v1

    .line 734
    invoke-virtual {v0, v3, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    sput-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sChildrenDrawingOrderMethod:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 737
    goto :goto_0

    .line 735
    :catch_0
    move-exception v0

    .line 736
    .local v0, "e":Ljava/lang/NoSuchMethodException;
    const-string v3, "ViewCompat"

    const-string v4, "Unable to find childrenDrawingOrderEnabled"

    invoke-static {v3, v4, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 738
    .end local v0    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sChildrenDrawingOrderMethod:Ljava/lang/reflect/Method;

    invoke-virtual {v0, v2}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 741
    :cond_0
    :try_start_1
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sChildrenDrawingOrderMethod:Ljava/lang/reflect/Method;

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    aput-object v3, v2, v1

    invoke-virtual {v0, p1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_1 .. :try_end_1} :catch_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 746
    :catch_1
    move-exception v0

    .line 747
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    const-string v1, "ViewCompat"

    const-string v2, "Unable to invoke childrenDrawingOrderEnabled"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 747
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    goto :goto_2

    .line 744
    :catch_2
    move-exception v0

    .line 745
    .local v0, "e":Ljava/lang/IllegalArgumentException;
    const-string v1, "ViewCompat"

    const-string v2, "Unable to invoke childrenDrawingOrderEnabled"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 745
    .end local v0    # "e":Ljava/lang/IllegalArgumentException;
    goto :goto_1

    .line 742
    :catch_3
    move-exception v0

    .line 743
    .local v0, "e":Ljava/lang/IllegalAccessException;
    const-string v1, "ViewCompat"

    const-string v2, "Unable to invoke childrenDrawingOrderEnabled"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 748
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :goto_1
    nop

    .line 749
    :goto_2
    return-void
.end method

.method public setClipBounds(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "clipBounds"    # Landroid/graphics/Rect;

    .line 724
    return-void
.end method

.method public setElevation(Landroid/view/View;F)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "elevation"    # F

    .line 710
    return-void
.end method

.method public setFocusedByDefault(Landroid/view/View;Z)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "isFocusedByDefault"    # Z

    .line 975
    return-void
.end method

.method public setHasTransientState(Landroid/view/View;Z)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "hasTransientState"    # Z

    .line 494
    return-void
.end method

.method public setImportantForAccessibility(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "mode"    # I

    .line 521
    return-void
.end method

.method public setKeyboardNavigationCluster(Landroid/view/View;Z)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "isCluster"    # Z

    .line 967
    return-void
.end method

.method public setLabelFor(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "id"    # I

    .line 540
    return-void
.end method

.method public setLayerPaint(Landroid/view/View;Landroid/graphics/Paint;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "paint"    # Landroid/graphics/Paint;

    .line 545
    invoke-virtual {p1}, Landroid/view/View;->getLayerType()I

    move-result v0

    invoke-virtual {p1, v0, p2}, Landroid/view/View;->setLayerType(ILandroid/graphics/Paint;)V

    .line 547
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 548
    return-void
.end method

.method public setLayoutDirection(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I

    .line 556
    return-void
.end method

.method public setNestedScrollingEnabled(Landroid/view/View;Z)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "enabled"    # Z

    .line 773
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 774
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0, p2}, Landroid/support/v4/view/NestedScrollingChild;->setNestedScrollingEnabled(Z)V

    .line 776
    :cond_0
    return-void
.end method

.method public setNextClusterForwardId(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "nextClusterForwardId"    # I

    .line 959
    return-void
.end method

.method public setOnApplyWindowInsetsListener(Landroid/view/View;Landroid/support/v4/view/OnApplyWindowInsetsListener;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "listener"    # Landroid/support/v4/view/OnApplyWindowInsetsListener;

    .line 758
    return-void
.end method

.method public setPaddingRelative(Landroid/view/View;IIII)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "start"    # I
    .param p3, "top"    # I
    .param p4, "end"    # I
    .param p5, "bottom"    # I

    .line 579
    invoke-virtual {p1, p2, p3, p4, p5}, Landroid/view/View;->setPadding(IIII)V

    .line 580
    return-void
.end method

.method public setPointerIcon(Landroid/view/View;Landroid/support/v4/view/PointerIconCompat;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "pointerIcon"    # Landroid/support/v4/view/PointerIconCompat;

    .line 939
    return-void
.end method

.method public setScrollIndicators(Landroid/view/View;I)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "indicators"    # I

    .line 901
    return-void
.end method

.method public setScrollIndicators(Landroid/view/View;II)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "indicators"    # I
    .param p3, "mask"    # I

    .line 905
    return-void
.end method

.method public setTooltipText(Landroid/view/View;Ljava/lang/CharSequence;)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "tooltipText"    # Ljava/lang/CharSequence;

    .line 951
    return-void
.end method

.method public setTransitionName(Landroid/view/View;Ljava/lang/String;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "transitionName"    # Ljava/lang/String;

    .line 689
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sTransitionNameMap:Ljava/util/WeakHashMap;

    if-nez v0, :cond_0

    .line 690
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sTransitionNameMap:Ljava/util/WeakHashMap;

    .line 692
    :cond_0
    sget-object v0, Landroid/support/v4/view/ViewCompat$ViewCompatBaseImpl;->sTransitionNameMap:Ljava/util/WeakHashMap;

    invoke-virtual {v0, p1, p2}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 693
    return-void
.end method

.method public setTranslationZ(Landroid/view/View;F)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "translationZ"    # F

    .line 717
    return-void
.end method

.method public setZ(Landroid/view/View;F)V
    .locals 0
    .param p1, "view"    # Landroid/view/View;
    .param p2, "z"    # F

    .line 885
    return-void
.end method

.method public startDragAndDrop(Landroid/view/View;Landroid/content/ClipData;Landroid/view/View$DragShadowBuilder;Ljava/lang/Object;I)Z
    .locals 1
    .param p1, "v"    # Landroid/view/View;
    .param p2, "data"    # Landroid/content/ClipData;
    .param p3, "shadowBuilder"    # Landroid/view/View$DragShadowBuilder;
    .param p4, "localState"    # Ljava/lang/Object;
    .param p5, "flags"    # I

    .line 476
    invoke-virtual {p1, p2, p3, p4, p5}, Landroid/view/View;->startDrag(Landroid/content/ClipData;Landroid/view/View$DragShadowBuilder;Ljava/lang/Object;I)Z

    move-result v0

    return v0
.end method

.method public startNestedScroll(Landroid/view/View;I)Z
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "axes"    # I

    .line 814
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 815
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0, p2}, Landroid/support/v4/view/NestedScrollingChild;->startNestedScroll(I)Z

    move-result v0

    return v0

    .line 817
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public stopNestedScroll(Landroid/view/View;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 821
    instance-of v0, p1, Landroid/support/v4/view/NestedScrollingChild;

    if-eqz v0, :cond_0

    .line 822
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/NestedScrollingChild;

    invoke-interface {v0}, Landroid/support/v4/view/NestedScrollingChild;->stopNestedScroll()V

    .line 824
    :cond_0
    return-void
.end method

.method public updateDragShadow(Landroid/view/View;Landroid/view/View$DragShadowBuilder;)V
    .locals 0
    .param p1, "v"    # Landroid/view/View;
    .param p2, "shadowBuilder"    # Landroid/view/View$DragShadowBuilder;

    .line 485
    return-void
.end method
