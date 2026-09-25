.class public Landroid/support/v4/widget/ViewDragHelper;
.super Ljava/lang/Object;
.source "ViewDragHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v4/widget/ViewDragHelper$Callback;
    }
.end annotation


# static fields
.field private static final BASE_SETTLE_DURATION:I = 0x100

.field public static final DIRECTION_ALL:I = 0x3

.field public static final DIRECTION_HORIZONTAL:I = 0x1

.field public static final DIRECTION_VERTICAL:I = 0x2

.field public static final EDGE_ALL:I = 0xf

.field public static final EDGE_BOTTOM:I = 0x8

.field public static final EDGE_LEFT:I = 0x1

.field public static final EDGE_RIGHT:I = 0x2

.field private static final EDGE_SIZE:I = 0x14

.field public static final EDGE_TOP:I = 0x4

.field public static final INVALID_POINTER:I = -0x1

.field private static final MAX_SETTLE_DURATION:I = 0x258

.field public static final STATE_DRAGGING:I = 0x1

.field public static final STATE_IDLE:I = 0x0

.field public static final STATE_SETTLING:I = 0x2

.field private static final TAG:Ljava/lang/String; = "ViewDragHelper"

.field private static final sInterpolator:Landroid/view/animation/Interpolator;


# instance fields
.field private mActivePointerId:I

.field private final mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

.field private mCapturedView:Landroid/view/View;

.field private mDragState:I

.field private mEdgeDragsInProgress:[I

.field private mEdgeDragsLocked:[I

.field private mEdgeSize:I

.field private mInitialEdgesTouched:[I

.field private mInitialMotionX:[F

.field private mInitialMotionY:[F

.field private mLastMotionX:[F

.field private mLastMotionY:[F

.field private mMaxVelocity:F

.field private mMinVelocity:F

.field private final mParentView:Landroid/view/ViewGroup;

.field private mPointersDown:I

.field private mReleaseInProgress:Z

.field private mScroller:Landroid/widget/OverScroller;

.field private final mSetIdleRunnable:Ljava/lang/Runnable;

.field private mTouchSlop:I

.field private mTrackingEdges:I

.field private mVelocityTracker:Landroid/view/VelocityTracker;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 326
    new-instance v0, Landroid/support/v4/widget/ViewDragHelper$1;

    invoke-direct {v0}, Landroid/support/v4/widget/ViewDragHelper$1;-><init>()V

    sput-object v0, Landroid/support/v4/widget/ViewDragHelper;->sInterpolator:Landroid/view/animation/Interpolator;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;Landroid/view/ViewGroup;Landroid/support/v4/widget/ViewDragHelper$Callback;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "forParent"    # Landroid/view/ViewGroup;
    .param p3, "cb"    # Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 375
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 115
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 334
    new-instance v0, Landroid/support/v4/widget/ViewDragHelper$2;

    invoke-direct {v0, p0}, Landroid/support/v4/widget/ViewDragHelper$2;-><init>(Landroid/support/v4/widget/ViewDragHelper;)V

    iput-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mSetIdleRunnable:Ljava/lang/Runnable;

    .line 376
    if-nez p2, :cond_0

    .line 377
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Parent view may not be null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 379
    :cond_0
    if-nez p3, :cond_1

    .line 380
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Callback may not be null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 383
    :cond_1
    iput-object p2, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    .line 384
    iput-object p3, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 386
    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v0

    .line 387
    .local v0, "vc":Landroid/view/ViewConfiguration;
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    .line 388
    .local v1, "density":F
    const/high16 v2, 0x41a00000    # 20.0f

    mul-float/2addr v2, v1

    const/high16 v3, 0x3f000000    # 0.5f

    add-float/2addr v2, v3

    float-to-int v2, v2

    iput v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    .line 390
    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v2

    iput v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    .line 391
    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledMaximumFlingVelocity()I

    move-result v2

    int-to-float v2, v2

    iput v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    .line 392
    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledMinimumFlingVelocity()I

    move-result v2

    int-to-float v2, v2

    iput v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    .line 393
    new-instance v2, Landroid/widget/OverScroller;

    sget-object v3, Landroid/support/v4/widget/ViewDragHelper;->sInterpolator:Landroid/view/animation/Interpolator;

    invoke-direct {v2, p1, v3}, Landroid/widget/OverScroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;)V

    iput-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    .line 394
    return-void
.end method

.method private checkNewEdgeDrag(FFII)Z
    .locals 5
    .param p1, "delta"    # F
    .param p2, "odelta"    # F
    .param p3, "pointerId"    # I
    .param p4, "edge"    # I

    .line 1265
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    .line 1266
    .local v0, "absDelta":F
    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result v1

    .line 1268
    .local v1, "absODelta":F
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v2, v2, p3

    and-int/2addr v2, p4

    const/4 v3, 0x0

    if-ne v2, p4, :cond_3

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v2, p4

    if-eqz v2, :cond_3

    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    aget v2, v2, p3

    and-int/2addr v2, p4

    if-eq v2, p4, :cond_3

    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    aget v2, v2, p3

    and-int/2addr v2, p4

    if-eq v2, p4, :cond_3

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v2, v2

    cmpg-float v2, v0, v2

    if-gtz v2, :cond_0

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v2, v2

    cmpg-float v2, v1, v2

    if-gtz v2, :cond_0

    goto :goto_0

    .line 1274
    :cond_0
    const/high16 v2, 0x3f000000    # 0.5f

    mul-float/2addr v2, v1

    cmpg-float v2, v0, v2

    if-gez v2, :cond_1

    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v2, p4}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeLock(I)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1275
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    aget v4, v2, p3

    or-int/2addr v4, p4

    aput v4, v2, p3

    .line 1276
    return v3

    .line 1278
    :cond_1
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    aget v2, v2, p3

    and-int/2addr v2, p4

    if-nez v2, :cond_2

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v2, v2

    cmpl-float v2, v0, v2

    if-lez v2, :cond_2

    const/4 v3, 0x1

    nop

    :cond_2
    return v3

    .line 1272
    :cond_3
    :goto_0
    return v3
.end method

.method private checkTouchSlop(Landroid/view/View;FF)Z
    .locals 7
    .param p1, "child"    # Landroid/view/View;
    .param p2, "dx"    # F
    .param p3, "dy"    # F

    .line 1292
    const/4 v0, 0x0

    if-nez p1, :cond_0

    .line 1293
    return v0

    .line 1295
    :cond_0
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v1, p1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewHorizontalDragRange(Landroid/view/View;)I

    move-result v1

    const/4 v2, 0x1

    if-lez v1, :cond_1

    move v1, v2

    goto :goto_0

    :cond_1
    move v1, v0

    .line 1296
    .local v1, "checkHorizontal":Z
    :goto_0
    iget-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v3, p1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewVerticalDragRange(Landroid/view/View;)I

    move-result v3

    if-lez v3, :cond_2

    move v3, v2

    goto :goto_1

    :cond_2
    move v3, v0

    .line 1298
    .local v3, "checkVertical":Z
    :goto_1
    if-eqz v1, :cond_4

    if-eqz v3, :cond_4

    .line 1299
    mul-float v4, p2, p2

    mul-float v5, p3, p3

    add-float/2addr v4, v5

    iget v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    iget v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    mul-int/2addr v5, v6

    int-to-float v5, v5

    cmpl-float v4, v4, v5

    if-lez v4, :cond_3

    move v0, v2

    nop

    :cond_3
    return v0

    .line 1300
    :cond_4
    if-eqz v1, :cond_6

    .line 1301
    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result v4

    iget v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v5, v5

    cmpl-float v4, v4, v5

    if-lez v4, :cond_5

    move v0, v2

    nop

    :cond_5
    return v0

    .line 1302
    :cond_6
    if-eqz v3, :cond_8

    .line 1303
    invoke-static {p3}, Ljava/lang/Math;->abs(F)F

    move-result v4

    iget v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v5, v5

    cmpl-float v4, v4, v5

    if-lez v4, :cond_7

    move v0, v2

    nop

    :cond_7
    return v0

    .line 1305
    :cond_8
    return v0
.end method

.method private clampMag(FFF)F
    .locals 3
    .param p1, "value"    # F
    .param p2, "absMin"    # F
    .param p3, "absMax"    # F

    .line 676
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    .line 677
    .local v0, "absValue":F
    cmpg-float v1, v0, p2

    const/4 v2, 0x0

    if-gez v1, :cond_0

    return v2

    .line 678
    :cond_0
    cmpl-float v1, v0, p3

    if-lez v1, :cond_2

    cmpl-float v1, p1, v2

    if-lez v1, :cond_1

    move v1, p3

    goto :goto_0

    :cond_1
    neg-float v1, p3

    :goto_0
    return v1

    .line 679
    :cond_2
    return p1
.end method

.method private clampMag(III)I
    .locals 2
    .param p1, "value"    # I
    .param p2, "absMin"    # I
    .param p3, "absMax"    # I

    .line 659
    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v0

    .line 660
    .local v0, "absValue":I
    if-ge v0, p2, :cond_0

    const/4 v1, 0x0

    return v1

    .line 661
    :cond_0
    if-le v0, p3, :cond_2

    if-lez p1, :cond_1

    move v1, p3

    goto :goto_0

    :cond_1
    neg-int v1, p3

    :goto_0
    return v1

    .line 662
    :cond_2
    return p1
.end method

.method private clearMotionHistory()V
    .locals 2

    .line 779
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    if-nez v0, :cond_0

    .line 780
    return-void

    .line 782
    :cond_0
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    const/4 v1, 0x0

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([FF)V

    .line 783
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([FF)V

    .line 784
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([FF)V

    .line 785
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([FF)V

    .line 786
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    const/4 v1, 0x0

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 787
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 788
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 789
    iput v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    .line 790
    return-void
.end method

.method private clearMotionHistory(I)V
    .locals 2
    .param p1, "pointerId"    # I

    .line 793
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    if-eqz v0, :cond_1

    invoke-virtual {p0, p1}, Landroid/support/v4/widget/ViewDragHelper;->isPointerDown(I)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 796
    :cond_0
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    const/4 v1, 0x0

    aput v1, v0, p1

    .line 797
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    aput v1, v0, p1

    .line 798
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    aput v1, v0, p1

    .line 799
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    aput v1, v0, p1

    .line 800
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    const/4 v1, 0x0

    aput v1, v0, p1

    .line 801
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    aput v1, v0, p1

    .line 802
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    aput v1, v0, p1

    .line 803
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    const/4 v1, 0x1

    shl-int/2addr v1, p1

    not-int v1, v1

    and-int/2addr v0, v1

    iput v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    .line 804
    return-void

    .line 794
    :cond_1
    :goto_0
    return-void
.end method

.method private computeAxisDuration(III)I
    .locals 7
    .param p1, "delta"    # I
    .param p2, "velocity"    # I
    .param p3, "motionRange"    # I

    .line 627
    if-nez p1, :cond_0

    .line 628
    const/4 v0, 0x0

    return v0

    .line 631
    :cond_0
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getWidth()I

    move-result v0

    .line 632
    .local v0, "width":I
    div-int/lit8 v1, v0, 0x2

    .line 633
    .local v1, "halfWidth":I
    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v2

    int-to-float v2, v2

    int-to-float v3, v0

    div-float/2addr v2, v3

    const/high16 v3, 0x3f800000    # 1.0f

    invoke-static {v3, v2}, Ljava/lang/Math;->min(FF)F

    move-result v2

    .line 634
    .local v2, "distanceRatio":F
    int-to-float v4, v1

    int-to-float v5, v1

    .line 635
    invoke-direct {p0, v2}, Landroid/support/v4/widget/ViewDragHelper;->distanceInfluenceForSnapDuration(F)F

    move-result v6

    mul-float/2addr v5, v6

    add-float/2addr v4, v5

    .line 638
    .local v4, "distance":F
    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    .line 639
    if-lez p2, :cond_1

    .line 640
    const/high16 v3, 0x447a0000    # 1000.0f

    int-to-float v5, p2

    div-float v5, v4, v5

    invoke-static {v5}, Ljava/lang/Math;->abs(F)F

    move-result v5

    mul-float/2addr v5, v3

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v3

    mul-int/lit8 v3, v3, 0x4

    .line 640
    .local v3, "duration":I
    goto :goto_0

    .line 642
    .end local v3    # "duration":I
    :cond_1
    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v5

    int-to-float v5, v5

    int-to-float v6, p3

    div-float/2addr v5, v6

    .line 643
    .local v5, "range":F
    add-float/2addr v3, v5

    const/high16 v6, 0x43800000    # 256.0f

    mul-float/2addr v3, v6

    float-to-int v3, v3

    .line 645
    .end local v5    # "range":F
    .restart local v3    # "duration":I
    :goto_0
    const/16 v5, 0x258

    invoke-static {v3, v5}, Ljava/lang/Math;->min(II)I

    move-result v5

    return v5
.end method

.method private computeSettleDuration(Landroid/view/View;IIII)I
    .locals 17
    .param p1, "child"    # Landroid/view/View;
    .param p2, "dx"    # I
    .param p3, "dy"    # I
    .param p4, "xvel"    # I
    .param p5, "yvel"    # I

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 606
    iget v2, v0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    float-to-int v2, v2

    iget v3, v0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    float-to-int v3, v3

    move/from16 v4, p4

    invoke-direct {v0, v4, v2, v3}, Landroid/support/v4/widget/ViewDragHelper;->clampMag(III)I

    move-result v2

    .line 607
    .end local p4    # "xvel":I
    .local v2, "xvel":I
    iget v3, v0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    float-to-int v3, v3

    iget v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    float-to-int v4, v4

    move/from16 v5, p5

    invoke-direct {v0, v5, v3, v4}, Landroid/support/v4/widget/ViewDragHelper;->clampMag(III)I

    move-result v3

    .line 608
    .end local p5    # "yvel":I
    .local v3, "yvel":I
    invoke-static/range {p2 .. p2}, Ljava/lang/Math;->abs(I)I

    move-result v4

    .line 609
    .local v4, "absDx":I
    invoke-static/range {p3 .. p3}, Ljava/lang/Math;->abs(I)I

    move-result v5

    .line 610
    .local v5, "absDy":I
    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v6

    .line 611
    .local v6, "absXVel":I
    invoke-static {v3}, Ljava/lang/Math;->abs(I)I

    move-result v7

    .line 612
    .local v7, "absYVel":I
    add-int v8, v6, v7

    .line 613
    .local v8, "addedVel":I
    add-int v9, v4, v5

    .line 615
    .local v9, "addedDistance":I
    if-eqz v2, :cond_0

    int-to-float v10, v6

    int-to-float v11, v8

    :goto_0
    div-float/2addr v10, v11

    goto :goto_1

    :cond_0
    int-to-float v10, v4

    int-to-float v11, v9

    goto :goto_0

    .line 617
    .local v10, "xweight":F
    :goto_1
    if-eqz v3, :cond_1

    int-to-float v11, v7

    int-to-float v12, v8

    :goto_2
    div-float/2addr v11, v12

    goto :goto_3

    :cond_1
    int-to-float v11, v5

    int-to-float v12, v9

    goto :goto_2

    .line 620
    .local v11, "yweight":F
    :goto_3
    iget-object v12, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v12, v1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewHorizontalDragRange(Landroid/view/View;)I

    move-result v12

    move/from16 v13, p2

    invoke-direct {v0, v13, v2, v12}, Landroid/support/v4/widget/ViewDragHelper;->computeAxisDuration(III)I

    move-result v12

    .line 621
    .local v12, "xduration":I
    iget-object v14, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v14, v1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewVerticalDragRange(Landroid/view/View;)I

    move-result v14

    move/from16 v15, p3

    invoke-direct {v0, v15, v3, v14}, Landroid/support/v4/widget/ViewDragHelper;->computeAxisDuration(III)I

    move-result v14

    .line 623
    .local v14, "yduration":I
    int-to-float v0, v12

    mul-float/2addr v0, v10

    int-to-float v1, v14

    mul-float/2addr v1, v11

    add-float/2addr v0, v1

    float-to-int v0, v0

    return v0
.end method

.method public static create(Landroid/view/ViewGroup;FLandroid/support/v4/widget/ViewDragHelper$Callback;)Landroid/support/v4/widget/ViewDragHelper;
    .locals 3
    .param p0, "forParent"    # Landroid/view/ViewGroup;
    .param p1, "sensitivity"    # F
    .param p2, "cb"    # Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 362
    invoke-static {p0, p2}, Landroid/support/v4/widget/ViewDragHelper;->create(Landroid/view/ViewGroup;Landroid/support/v4/widget/ViewDragHelper$Callback;)Landroid/support/v4/widget/ViewDragHelper;

    move-result-object v0

    .line 363
    .local v0, "helper":Landroid/support/v4/widget/ViewDragHelper;
    iget v1, v0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v1, v1

    const/high16 v2, 0x3f800000    # 1.0f

    div-float/2addr v2, p1

    mul-float/2addr v1, v2

    float-to-int v1, v1

    iput v1, v0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    .line 364
    return-object v0
.end method

.method public static create(Landroid/view/ViewGroup;Landroid/support/v4/widget/ViewDragHelper$Callback;)Landroid/support/v4/widget/ViewDragHelper;
    .locals 2
    .param p0, "forParent"    # Landroid/view/ViewGroup;
    .param p1, "cb"    # Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 349
    new-instance v0, Landroid/support/v4/widget/ViewDragHelper;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p0, p1}, Landroid/support/v4/widget/ViewDragHelper;-><init>(Landroid/content/Context;Landroid/view/ViewGroup;Landroid/support/v4/widget/ViewDragHelper$Callback;)V

    return-object v0
.end method

.method private dispatchViewReleased(FF)V
    .locals 3
    .param p1, "xvel"    # F
    .param p2, "yvel"    # F

    .line 768
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mReleaseInProgress:Z

    .line 769
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v1, v2, p1, p2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewReleased(Landroid/view/View;FF)V

    .line 770
    const/4 v1, 0x0

    iput-boolean v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mReleaseInProgress:Z

    .line 772
    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v2, v0, :cond_0

    .line 774
    invoke-virtual {p0, v1}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 776
    :cond_0
    return-void
.end method

.method private distanceInfluenceForSnapDuration(F)F
    .locals 2
    .param p1, "f"    # F

    .line 683
    const/high16 v0, 0x3f000000    # 0.5f

    sub-float/2addr p1, v0

    .line 684
    const v0, 0x3ef1463b

    mul-float/2addr p1, v0

    .line 685
    float-to-double v0, p1

    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide v0

    double-to-float v0, v0

    return v0
.end method

.method private dragTo(IIII)V
    .locals 16
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "dx"    # I
    .param p4, "dy"    # I

    move-object/from16 v0, p0

    move/from16 v1, p3

    .line 1413
    move/from16 v2, p4

    move/from16 v3, p1

    .line 1414
    .local v3, "clampedX":I
    move/from16 v4, p2

    .line 1415
    .local v4, "clampedY":I
    iget-object v5, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v5}, Landroid/view/View;->getLeft()I

    move-result v5

    .line 1416
    .local v5, "oldLeft":I
    iget-object v6, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v6}, Landroid/view/View;->getTop()I

    move-result v6

    .line 1417
    .local v6, "oldTop":I
    if-eqz v1, :cond_0

    .line 1418
    iget-object v7, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    move/from16 v9, p1

    invoke-virtual {v7, v8, v9, v1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->clampViewPositionHorizontal(Landroid/view/View;II)I

    move-result v3

    .line 1419
    iget-object v7, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    sub-int v8, v3, v5

    invoke-static {v7, v8}, Landroid/support/v4/view/ViewCompat;->offsetLeftAndRight(Landroid/view/View;I)V

    goto :goto_0

    .line 1421
    :cond_0
    move/from16 v9, p1

    :goto_0
    if-eqz v2, :cond_1

    .line 1422
    iget-object v7, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    move/from16 v15, p2

    invoke-virtual {v7, v8, v15, v2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->clampViewPositionVertical(Landroid/view/View;II)I

    move-result v4

    .line 1423
    iget-object v7, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    sub-int v8, v4, v6

    invoke-static {v7, v8}, Landroid/support/v4/view/ViewCompat;->offsetTopAndBottom(Landroid/view/View;I)V

    goto :goto_1

    .line 1426
    :cond_1
    move/from16 v15, p2

    :goto_1
    if-nez v1, :cond_2

    if-eqz v2, :cond_3

    .line 1427
    :cond_2
    sub-int v7, v3, v5

    .line 1428
    .local v7, "clampedDx":I
    sub-int v8, v4, v6

    .line 1429
    .local v8, "clampedDy":I
    iget-object v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v11, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    move v12, v3

    move v13, v4

    move v14, v7

    move v15, v8

    invoke-virtual/range {v10 .. v15}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewPositionChanged(Landroid/view/View;IIII)V

    .line 1432
    .end local v7    # "clampedDx":I
    .end local v8    # "clampedDy":I
    :cond_3
    return-void
.end method

.method private ensureMotionHistorySizeForId(I)V
    .locals 10
    .param p1, "pointerId"    # I

    .line 807
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    array-length v0, v0

    if-gt v0, p1, :cond_2

    .line 808
    :cond_0
    add-int/lit8 v0, p1, 0x1

    new-array v0, v0, [F

    .line 809
    .local v0, "imx":[F
    add-int/lit8 v1, p1, 0x1

    new-array v1, v1, [F

    .line 810
    .local v1, "imy":[F
    add-int/lit8 v2, p1, 0x1

    new-array v2, v2, [F

    .line 811
    .local v2, "lmx":[F
    add-int/lit8 v3, p1, 0x1

    new-array v3, v3, [F

    .line 812
    .local v3, "lmy":[F
    add-int/lit8 v4, p1, 0x1

    new-array v4, v4, [I

    .line 813
    .local v4, "iit":[I
    add-int/lit8 v5, p1, 0x1

    new-array v5, v5, [I

    .line 814
    .local v5, "edip":[I
    add-int/lit8 v6, p1, 0x1

    new-array v6, v6, [I

    .line 816
    .local v6, "edl":[I
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    if-eqz v7, :cond_1

    .line 817
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    array-length v8, v8

    const/4 v9, 0x0

    invoke-static {v7, v9, v0, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 818
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    array-length v8, v8

    invoke-static {v7, v9, v1, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 819
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    array-length v8, v8

    invoke-static {v7, v9, v2, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 820
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    array-length v8, v8

    invoke-static {v7, v9, v3, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 821
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    array-length v8, v8

    invoke-static {v7, v9, v4, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 822
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    array-length v8, v8

    invoke-static {v7, v9, v5, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 823
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    array-length v8, v8

    invoke-static {v7, v9, v6, v9, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 826
    :cond_1
    iput-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    .line 827
    iput-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    .line 828
    iput-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    .line 829
    iput-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    .line 830
    iput-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    .line 831
    iput-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    .line 832
    iput-object v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsLocked:[I

    .line 834
    .end local v0    # "imx":[F
    .end local v1    # "imy":[F
    .end local v2    # "lmx":[F
    .end local v3    # "lmy":[F
    .end local v4    # "iit":[I
    .end local v5    # "edip":[I
    .end local v6    # "edl":[I
    :cond_2
    return-void
.end method

.method private forceSettleCapturedViewAt(IIII)Z
    .locals 11
    .param p1, "finalLeft"    # I
    .param p2, "finalTop"    # I
    .param p3, "xvel"    # I
    .param p4, "yvel"    # I

    .line 586
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLeft()I

    move-result v0

    .line 587
    .local v0, "startLeft":I
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getTop()I

    move-result v7

    .line 588
    .local v7, "startTop":I
    sub-int v8, p1, v0

    .line 589
    .local v8, "dx":I
    sub-int v9, p2, v7

    .line 591
    .local v9, "dy":I
    if-nez v8, :cond_0

    if-nez v9, :cond_0

    .line 593
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v1}, Landroid/widget/OverScroller;->abortAnimation()V

    .line 594
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 595
    return v1

    .line 598
    :cond_0
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    move-object v1, p0

    move v3, v8

    move v4, v9

    move v5, p3

    move v6, p4

    invoke-direct/range {v1 .. v6}, Landroid/support/v4/widget/ViewDragHelper;->computeSettleDuration(Landroid/view/View;IIII)I

    move-result v10

    .line 599
    .local v10, "duration":I
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    move v2, v0

    move v3, v7

    move v4, v8

    move v5, v9

    move v6, v10

    invoke-virtual/range {v1 .. v6}, Landroid/widget/OverScroller;->startScroll(IIIII)V

    .line 601
    const/4 v1, 0x2

    invoke-virtual {p0, v1}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 602
    const/4 v1, 0x1

    return v1
.end method

.method private getEdgesTouched(II)I
    .locals 3
    .param p1, "x"    # I
    .param p2, "y"    # I

    .line 1487
    const/4 v0, 0x0

    .line 1489
    .local v0, "result":I
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getLeft()I

    move-result v1

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    add-int/2addr v1, v2

    if-ge p1, v1, :cond_0

    or-int/lit8 v0, v0, 0x1

    .line 1490
    :cond_0
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getTop()I

    move-result v1

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    add-int/2addr v1, v2

    if-ge p2, v1, :cond_1

    or-int/lit8 v0, v0, 0x4

    .line 1491
    :cond_1
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getRight()I

    move-result v1

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    sub-int/2addr v1, v2

    if-le p1, v1, :cond_2

    or-int/lit8 v0, v0, 0x2

    .line 1492
    :cond_2
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getBottom()I

    move-result v1

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    sub-int/2addr v1, v2

    if-le p2, v1, :cond_3

    or-int/lit8 v0, v0, 0x8

    .line 1494
    :cond_3
    return v0
.end method

.method private isValidPointerForActionMove(I)Z
    .locals 3
    .param p1, "pointerId"    # I

    .line 1498
    invoke-virtual {p0, p1}, Landroid/support/v4/widget/ViewDragHelper;->isPointerDown(I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1499
    const-string v0, "ViewDragHelper"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Ignoring pointerId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " because ACTION_DOWN was not received "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "for this pointer before ACTION_MOVE. It likely happened because "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " ViewDragHelper did not receive all the events in the event stream."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1502
    const/4 v0, 0x0

    return v0

    .line 1504
    :cond_0
    const/4 v0, 0x1

    return v0
.end method

.method private releaseViewForPointerUp()V
    .locals 4

    .line 1402
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    const/16 v2, 0x3e8

    invoke-virtual {v0, v2, v1}, Landroid/view/VelocityTracker;->computeCurrentVelocity(IF)V

    .line 1403
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 1404
    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->getXVelocity(I)F

    move-result v0

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    .line 1403
    invoke-direct {p0, v0, v1, v2}, Landroid/support/v4/widget/ViewDragHelper;->clampMag(FFF)F

    move-result v0

    .line 1406
    .local v0, "xvel":F
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 1407
    invoke-virtual {v1, v2}, Landroid/view/VelocityTracker;->getYVelocity(I)F

    move-result v1

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    iget v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mMaxVelocity:F

    .line 1406
    invoke-direct {p0, v1, v2, v3}, Landroid/support/v4/widget/ViewDragHelper;->clampMag(FFF)F

    move-result v1

    .line 1409
    .local v1, "yvel":F
    invoke-direct {p0, v0, v1}, Landroid/support/v4/widget/ViewDragHelper;->dispatchViewReleased(FF)V

    .line 1410
    return-void
.end method

.method private reportNewEdgeDrags(FFI)V
    .locals 3
    .param p1, "dx"    # F
    .param p2, "dy"    # F
    .param p3, "pointerId"    # I

    .line 1244
    const/4 v0, 0x0

    .line 1245
    .local v0, "dragsStarted":I
    const/4 v1, 0x1

    invoke-direct {p0, p1, p2, p3, v1}, Landroid/support/v4/widget/ViewDragHelper;->checkNewEdgeDrag(FFII)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1246
    or-int/lit8 v0, v0, 0x1

    .line 1248
    :cond_0
    const/4 v1, 0x4

    invoke-direct {p0, p2, p1, p3, v1}, Landroid/support/v4/widget/ViewDragHelper;->checkNewEdgeDrag(FFII)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1249
    or-int/lit8 v0, v0, 0x4

    .line 1251
    :cond_1
    const/4 v1, 0x2

    invoke-direct {p0, p1, p2, p3, v1}, Landroid/support/v4/widget/ViewDragHelper;->checkNewEdgeDrag(FFII)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1252
    or-int/lit8 v0, v0, 0x2

    .line 1254
    :cond_2
    const/16 v1, 0x8

    invoke-direct {p0, p2, p1, p3, v1}, Landroid/support/v4/widget/ViewDragHelper;->checkNewEdgeDrag(FFII)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 1255
    or-int/lit8 v0, v0, 0x8

    .line 1258
    :cond_3
    if-eqz v0, :cond_4

    .line 1259
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeDragsInProgress:[I

    aget v2, v1, p3

    or-int/2addr v2, v0

    aput v2, v1, p3

    .line 1260
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v1, v0, p3}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeDragStarted(II)V

    .line 1262
    :cond_4
    return-void
.end method

.method private saveInitialMotion(FFI)V
    .locals 3
    .param p1, "x"    # F
    .param p2, "y"    # F
    .param p3, "pointerId"    # I

    .line 837
    invoke-direct {p0, p3}, Landroid/support/v4/widget/ViewDragHelper;->ensureMotionHistorySizeForId(I)V

    .line 838
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    aput p1, v1, p3

    aput p1, v0, p3

    .line 839
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    aput p2, v1, p3

    aput p2, v0, p3

    .line 840
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    float-to-int v1, p1

    float-to-int v2, p2

    invoke-direct {p0, v1, v2}, Landroid/support/v4/widget/ViewDragHelper;->getEdgesTouched(II)I

    move-result v1

    aput v1, v0, p3

    .line 841
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    const/4 v1, 0x1

    shl-int/2addr v1, p3

    or-int/2addr v0, v1

    iput v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    .line 842
    return-void
.end method

.method private saveLastMotion(Landroid/view/MotionEvent;)V
    .locals 6
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 845
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v0

    .line 846
    .local v0, "pointerCount":I
    const/4 v1, 0x0

    .line 846
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 847
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v2

    .line 849
    .local v2, "pointerId":I
    invoke-direct {p0, v2}, Landroid/support/v4/widget/ViewDragHelper;->isValidPointerForActionMove(I)Z

    move-result v3

    if-nez v3, :cond_0

    .line 850
    goto :goto_1

    .line 852
    :cond_0
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    .line 853
    .local v3, "x":F
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    .line 854
    .local v4, "y":F
    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    aput v3, v5, v2

    .line 855
    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    aput v4, v5, v2

    .line 846
    .end local v2    # "pointerId":I
    .end local v3    # "x":F
    .end local v4    # "y":F
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 857
    .end local v1    # "i":I
    :cond_1
    return-void
.end method


# virtual methods
.method public abort()V
    .locals 10

    .line 514
    invoke-virtual {p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    .line 515
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    .line 516
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v0}, Landroid/widget/OverScroller;->getCurrX()I

    move-result v0

    .line 517
    .local v0, "oldX":I
    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v1}, Landroid/widget/OverScroller;->getCurrY()I

    move-result v1

    .line 518
    .local v1, "oldY":I
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v2}, Landroid/widget/OverScroller;->abortAnimation()V

    .line 519
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v2}, Landroid/widget/OverScroller;->getCurrX()I

    move-result v2

    .line 520
    .local v2, "newX":I
    iget-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v3}, Landroid/widget/OverScroller;->getCurrY()I

    move-result v9

    .line 521
    .local v9, "newY":I
    iget-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    sub-int v7, v2, v0

    sub-int v8, v9, v1

    move v5, v2

    move v6, v9

    invoke-virtual/range {v3 .. v8}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewPositionChanged(Landroid/view/View;IIII)V

    .line 523
    .end local v0    # "oldX":I
    .end local v1    # "oldY":I
    .end local v2    # "newX":I
    .end local v9    # "newY":I
    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 524
    return-void
.end method

.method protected canScroll(Landroid/view/View;ZIIII)Z
    .locals 16
    .param p1, "v"    # Landroid/view/View;
    .param p2, "checkV"    # Z
    .param p3, "dx"    # I
    .param p4, "dy"    # I
    .param p5, "x"    # I
    .param p6, "y"    # I

    move-object/from16 v0, p1

    .line 922
    instance-of v1, v0, Landroid/view/ViewGroup;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    .line 923
    move-object v1, v0

    check-cast v1, Landroid/view/ViewGroup;

    .line 924
    .local v1, "group":Landroid/view/ViewGroup;
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getScrollX()I

    move-result v3

    .line 925
    .local v3, "scrollX":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getScrollY()I

    move-result v4

    .line 926
    .local v4, "scrollY":I
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    .line 928
    .local v5, "count":I
    add-int/lit8 v6, v5, -0x1

    .line 928
    .local v6, "i":I
    :goto_0
    if-ltz v6, :cond_1

    .line 931
    invoke-virtual {v1, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    .line 932
    .local v13, "child":Landroid/view/View;
    add-int v7, p5, v3

    invoke-virtual {v13}, Landroid/view/View;->getLeft()I

    move-result v8

    if-lt v7, v8, :cond_0

    add-int v7, p5, v3

    invoke-virtual {v13}, Landroid/view/View;->getRight()I

    move-result v8

    if-ge v7, v8, :cond_0

    add-int v7, p6, v4

    .line 933
    invoke-virtual {v13}, Landroid/view/View;->getTop()I

    move-result v8

    if-lt v7, v8, :cond_0

    add-int v7, p6, v4

    invoke-virtual {v13}, Landroid/view/View;->getBottom()I

    move-result v8

    if-ge v7, v8, :cond_0

    const/4 v9, 0x1

    add-int v7, p5, v3

    .line 934
    invoke-virtual {v13}, Landroid/view/View;->getLeft()I

    move-result v8

    sub-int v12, v7, v8

    add-int v7, p6, v4

    .line 935
    invoke-virtual {v13}, Landroid/view/View;->getTop()I

    move-result v8

    sub-int v14, v7, v8

    .line 934
    move-object/from16 v7, p0

    move-object v8, v13

    move/from16 v10, p3

    move/from16 v11, p4

    move-object v15, v13

    move v13, v14

    .line 934
    .end local v13    # "child":Landroid/view/View;
    .local v15, "child":Landroid/view/View;
    invoke-virtual/range {v7 .. v13}, Landroid/support/v4/widget/ViewDragHelper;->canScroll(Landroid/view/View;ZIIII)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 936
    return v2

    .line 928
    .end local v15    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v6, v6, -0x1

    goto :goto_0

    .line 941
    .end local v1    # "group":Landroid/view/ViewGroup;
    .end local v3    # "scrollX":I
    .end local v4    # "scrollY":I
    .end local v5    # "count":I
    .end local v6    # "i":I
    :cond_1
    if-eqz p2, :cond_3

    move/from16 v3, p3

    neg-int v4, v3

    invoke-virtual {v0, v4}, Landroid/view/View;->canScrollHorizontally(I)Z

    move-result v4

    if-nez v4, :cond_2

    move/from16 v4, p4

    neg-int v5, v4

    invoke-virtual {v0, v5}, Landroid/view/View;->canScrollVertically(I)Z

    move-result v5

    if-eqz v5, :cond_4

    goto :goto_1

    :cond_2
    move/from16 v4, p4

    :goto_1
    goto :goto_2

    :cond_3
    move/from16 v3, p3

    move/from16 v4, p4

    :cond_4
    const/4 v2, 0x0

    :goto_2
    return v2
.end method

.method public cancel()V
    .locals 1

    .line 500
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 501
    invoke-direct {p0}, Landroid/support/v4/widget/ViewDragHelper;->clearMotionHistory()V

    .line 503
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v0, :cond_0

    .line 504
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->recycle()V

    .line 505
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 507
    :cond_0
    return-void
.end method

.method public captureChildView(Landroid/view/View;I)V
    .locals 3
    .param p1, "childView"    # Landroid/view/View;
    .param p2, "activePointerId"    # I

    .line 462
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    if-eq v0, v1, :cond_0

    .line 463
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "captureChildView: parameter must be a descendant of the ViewDragHelper\'s tracked parent view ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 467
    :cond_0
    iput-object p1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    .line 468
    iput p2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 469
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v0, p1, p2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewCaptured(Landroid/view/View;I)V

    .line 470
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 471
    return-void
.end method

.method public checkTouchSlop(I)Z
    .locals 4
    .param p1, "directions"    # I

    .line 1323
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    array-length v0, v0

    .line 1324
    .local v0, "count":I
    const/4 v1, 0x0

    move v2, v1

    .line 1324
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 1325
    invoke-virtual {p0, p1, v2}, Landroid/support/v4/widget/ViewDragHelper;->checkTouchSlop(II)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 1326
    const/4 v1, 0x1

    return v1

    .line 1324
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1329
    .end local v2    # "i":I
    :cond_1
    return v1
.end method

.method public checkTouchSlop(II)Z
    .locals 9
    .param p1, "directions"    # I
    .param p2, "pointerId"    # I

    .line 1348
    invoke-virtual {p0, p2}, Landroid/support/v4/widget/ViewDragHelper;->isPointerDown(I)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 1349
    return v1

    .line 1352
    :cond_0
    and-int/lit8 v0, p1, 0x1

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    move v0, v2

    goto :goto_0

    :cond_1
    move v0, v1

    .line 1353
    .local v0, "checkHorizontal":Z
    :goto_0
    and-int/lit8 v3, p1, 0x2

    const/4 v4, 0x2

    if-ne v3, v4, :cond_2

    move v3, v2

    goto :goto_1

    :cond_2
    move v3, v1

    .line 1355
    .local v3, "checkVertical":Z
    :goto_1
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    aget v4, v4, p2

    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    aget v5, v5, p2

    sub-float/2addr v4, v5

    .line 1356
    .local v4, "dx":F
    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    aget v5, v5, p2

    iget-object v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    aget v6, v6, p2

    sub-float/2addr v5, v6

    .line 1358
    .local v5, "dy":F
    if-eqz v0, :cond_4

    if-eqz v3, :cond_4

    .line 1359
    mul-float v6, v4, v4

    mul-float v7, v5, v5

    add-float/2addr v6, v7

    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    iget v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    mul-int/2addr v7, v8

    int-to-float v7, v7

    cmpl-float v6, v6, v7

    if-lez v6, :cond_3

    move v1, v2

    nop

    :cond_3
    return v1

    .line 1360
    :cond_4
    if-eqz v0, :cond_6

    .line 1361
    invoke-static {v4}, Ljava/lang/Math;->abs(F)F

    move-result v6

    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v7, v7

    cmpl-float v6, v6, v7

    if-lez v6, :cond_5

    move v1, v2

    nop

    :cond_5
    return v1

    .line 1362
    :cond_6
    if-eqz v3, :cond_8

    .line 1363
    invoke-static {v5}, Ljava/lang/Math;->abs(F)F

    move-result v6

    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    int-to-float v7, v7

    cmpl-float v6, v6, v7

    if-lez v6, :cond_7

    move v1, v2

    nop

    :cond_7
    return v1

    .line 1365
    :cond_8
    return v1
.end method

.method public continueSettling(Z)Z
    .locals 13
    .param p1, "deferCallbacks"    # Z

    .line 724
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    const/4 v1, 0x0

    const/4 v2, 0x2

    if-ne v0, v2, :cond_6

    .line 725
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v0}, Landroid/widget/OverScroller;->computeScrollOffset()Z

    move-result v0

    .line 726
    .local v0, "keepGoing":Z
    iget-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v3}, Landroid/widget/OverScroller;->getCurrX()I

    move-result v3

    .line 727
    .local v3, "x":I
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v4}, Landroid/widget/OverScroller;->getCurrY()I

    move-result v10

    .line 728
    .local v10, "y":I
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v4}, Landroid/view/View;->getLeft()I

    move-result v4

    sub-int v11, v3, v4

    .line 729
    .local v11, "dx":I
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v4}, Landroid/view/View;->getTop()I

    move-result v4

    sub-int v12, v10, v4

    .line 731
    .local v12, "dy":I
    if-eqz v11, :cond_0

    .line 732
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-static {v4, v11}, Landroid/support/v4/view/ViewCompat;->offsetLeftAndRight(Landroid/view/View;I)V

    .line 734
    :cond_0
    if-eqz v12, :cond_1

    .line 735
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-static {v4, v12}, Landroid/support/v4/view/ViewCompat;->offsetTopAndBottom(Landroid/view/View;I)V

    .line 738
    :cond_1
    if-nez v11, :cond_2

    if-eqz v12, :cond_3

    .line 739
    :cond_2
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    move v6, v3

    move v7, v10

    move v8, v11

    move v9, v12

    invoke-virtual/range {v4 .. v9}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewPositionChanged(Landroid/view/View;IIII)V

    .line 742
    :cond_3
    if-eqz v0, :cond_4

    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v4}, Landroid/widget/OverScroller;->getFinalX()I

    move-result v4

    if-ne v3, v4, :cond_4

    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v4}, Landroid/widget/OverScroller;->getFinalY()I

    move-result v4

    if-ne v10, v4, :cond_4

    .line 745
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v4}, Landroid/widget/OverScroller;->abortAnimation()V

    .line 746
    const/4 v0, 0x0

    .line 749
    :cond_4
    if-nez v0, :cond_6

    .line 750
    if-eqz p1, :cond_5

    .line 751
    iget-object v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mSetIdleRunnable:Ljava/lang/Runnable;

    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->post(Ljava/lang/Runnable;)Z

    goto :goto_0

    .line 753
    :cond_5
    invoke-virtual {p0, v1}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 758
    .end local v0    # "keepGoing":Z
    .end local v3    # "x":I
    .end local v10    # "y":I
    .end local v11    # "dx":I
    .end local v12    # "dy":I
    :cond_6
    :goto_0
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v0, v2, :cond_7

    const/4 v1, 0x1

    nop

    :cond_7
    return v1
.end method

.method public findTopChildUnder(II)Landroid/view/View;
    .locals 4
    .param p1, "x"    # I
    .param p2, "y"    # I

    .line 1475
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    .line 1476
    .local v0, "childCount":I
    add-int/lit8 v1, v0, -0x1

    .line 1476
    .local v1, "i":I
    :goto_0
    if-ltz v1, :cond_1

    .line 1477
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    iget-object v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v3, v1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getOrderedChildIndex(I)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1478
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getLeft()I

    move-result v3

    if-lt p1, v3, :cond_0

    invoke-virtual {v2}, Landroid/view/View;->getRight()I

    move-result v3

    if-ge p1, v3, :cond_0

    .line 1479
    invoke-virtual {v2}, Landroid/view/View;->getTop()I

    move-result v3

    if-lt p2, v3, :cond_0

    invoke-virtual {v2}, Landroid/view/View;->getBottom()I

    move-result v3

    if-ge p2, v3, :cond_0

    .line 1480
    return-object v2

    .line 1476
    .end local v2    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 1483
    .end local v1    # "i":I
    :cond_1
    const/4 v1, 0x0

    return-object v1
.end method

.method public flingCapturedView(IIII)V
    .locals 11
    .param p1, "minLeft"    # I
    .param p2, "minTop"    # I
    .param p3, "maxLeft"    # I
    .param p4, "maxTop"    # I

    .line 699
    iget-boolean v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mReleaseInProgress:Z

    if-nez v0, :cond_0

    .line 700
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Cannot flingCapturedView outside of a call to Callback#onViewReleased"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 704
    :cond_0
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mScroller:Landroid/widget/OverScroller;

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLeft()I

    move-result v3

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getTop()I

    move-result v4

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 705
    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->getXVelocity(I)F

    move-result v0

    float-to-int v5, v0

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 706
    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->getYVelocity(I)F

    move-result v0

    float-to-int v6, v0

    .line 704
    move v7, p1

    move v8, p3

    move v9, p2

    move v10, p4

    invoke-virtual/range {v2 .. v10}, Landroid/widget/OverScroller;->fling(IIIIIIII)V

    .line 709
    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Landroid/support/v4/widget/ViewDragHelper;->setDragState(I)V

    .line 710
    return-void
.end method

.method public getActivePointerId()I
    .locals 1

    .line 485
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    return v0
.end method

.method public getCapturedView()Landroid/view/View;
    .locals 1

    .line 477
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    return-object v0
.end method

.method public getEdgeSize()I
    .locals 1

    .line 450
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mEdgeSize:I

    return v0
.end method

.method public getMinVelocity()F
    .locals 1

    .line 414
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    return v0
.end method

.method public getTouchSlop()I
    .locals 1

    .line 492
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mTouchSlop:I

    return v0
.end method

.method public getViewDragState()I
    .locals 1

    .line 423
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    return v0
.end method

.method public isCapturedViewUnder(II)Z
    .locals 1
    .param p1, "x"    # I
    .param p2, "y"    # I

    .line 1444
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {p0, v0, p1, p2}, Landroid/support/v4/widget/ViewDragHelper;->isViewUnder(Landroid/view/View;II)Z

    move-result v0

    return v0
.end method

.method public isEdgeTouched(I)Z
    .locals 4
    .param p1, "edges"    # I

    .line 1378
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    array-length v0, v0

    .line 1379
    .local v0, "count":I
    const/4 v1, 0x0

    move v2, v1

    .line 1379
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 1380
    invoke-virtual {p0, p1, v2}, Landroid/support/v4/widget/ViewDragHelper;->isEdgeTouched(II)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 1381
    const/4 v1, 0x1

    return v1

    .line 1379
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1384
    .end local v2    # "i":I
    :cond_1
    return v1
.end method

.method public isEdgeTouched(II)Z
    .locals 1
    .param p1, "edges"    # I
    .param p2, "pointerId"    # I

    .line 1398
    invoke-virtual {p0, p2}, Landroid/support/v4/widget/ViewDragHelper;->isPointerDown(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v0, v0, p2

    and-int/2addr v0, p1

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isPointerDown(I)Z
    .locals 3
    .param p1, "pointerId"    # I

    .line 873
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mPointersDown:I

    const/4 v1, 0x1

    shl-int v2, v1, p1

    and-int/2addr v0, v2

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public isViewUnder(Landroid/view/View;II)Z
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "x"    # I
    .param p3, "y"    # I

    .line 1457
    const/4 v0, 0x0

    if-nez p1, :cond_0

    .line 1458
    return v0

    .line 1460
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I

    move-result v1

    if-lt p2, v1, :cond_1

    .line 1461
    invoke-virtual {p1}, Landroid/view/View;->getRight()I

    move-result v1

    if-ge p2, v1, :cond_1

    .line 1462
    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    move-result v1

    if-lt p3, v1, :cond_1

    .line 1463
    invoke-virtual {p1}, Landroid/view/View;->getBottom()I

    move-result v1

    if-ge p3, v1, :cond_1

    const/4 v0, 0x1

    nop

    :cond_1
    return v0
.end method

.method public processTouchEvent(Landroid/view/MotionEvent;)V
    .locals 12
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 1086
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 1087
    .local v0, "action":I
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v1

    .line 1089
    .local v1, "actionIndex":I
    if-nez v0, :cond_0

    .line 1092
    invoke-virtual {p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    .line 1095
    :cond_0
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v2, :cond_1

    .line 1096
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v2

    iput-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 1098
    :cond_1
    iget-object v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v2, p1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 1100
    const/4 v2, 0x0

    const/4 v3, 0x1

    packed-switch v0, :pswitch_data_0

    :pswitch_0
    goto/16 :goto_6

    .line 1195
    :pswitch_1
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v4

    .line 1196
    .local v4, "pointerId":I
    iget v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v5, v3, :cond_5

    iget v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    if-ne v4, v3, :cond_5

    .line 1198
    const/4 v3, -0x1

    .line 1199
    .local v3, "newActivePointer":I
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v5

    .line 1200
    .local v5, "pointerCount":I
    nop

    .line 1200
    .local v2, "i":I
    :goto_0
    if-ge v2, v5, :cond_4

    .line 1201
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v6

    .line 1202
    .local v6, "id":I
    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    if-ne v6, v7, :cond_2

    .line 1204
    goto :goto_1

    .line 1207
    :cond_2
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v7

    .line 1208
    .local v7, "x":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v8

    .line 1209
    .local v8, "y":F
    float-to-int v9, v7

    float-to-int v10, v8

    invoke-virtual {p0, v9, v10}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v9

    iget-object v10, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    if-ne v9, v10, :cond_3

    iget-object v9, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    .line 1210
    invoke-virtual {p0, v9, v6}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    move-result v9

    if-eqz v9, :cond_3

    .line 1211
    iget v3, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 1212
    goto :goto_2

    .line 1200
    .end local v6    # "id":I
    .end local v7    # "x":F
    .end local v8    # "y":F
    :cond_3
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1216
    .end local v2    # "i":I
    :cond_4
    :goto_2
    const/4 v2, -0x1

    if-ne v3, v2, :cond_5

    .line 1218
    invoke-direct {p0}, Landroid/support/v4/widget/ViewDragHelper;->releaseViewForPointerUp()V

    .line 1221
    .end local v3    # "newActivePointer":I
    .end local v5    # "pointerCount":I
    :cond_5
    invoke-direct {p0, v4}, Landroid/support/v4/widget/ViewDragHelper;->clearMotionHistory(I)V

    .line 1222
    goto/16 :goto_6

    .line 1122
    .end local v4    # "pointerId":I
    :pswitch_2
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v2

    .line 1123
    .local v2, "pointerId":I
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    .line 1124
    .local v3, "x":F
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    .line 1126
    .local v4, "y":F
    invoke-direct {p0, v3, v4, v2}, Landroid/support/v4/widget/ViewDragHelper;->saveInitialMotion(FFI)V

    .line 1129
    iget v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-nez v5, :cond_7

    .line 1132
    float-to-int v5, v3

    float-to-int v6, v4

    invoke-virtual {p0, v5, v6}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v5

    .line 1133
    .local v5, "toCapture":Landroid/view/View;
    invoke-virtual {p0, v5, v2}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    .line 1135
    iget-object v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v6, v6, v2

    .line 1136
    .local v6, "edgesTouched":I
    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v7, v6

    if-eqz v7, :cond_6

    .line 1137
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v8, v6

    invoke-virtual {v7, v8, v2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeTouched(II)V

    .line 1139
    .end local v5    # "toCapture":Landroid/view/View;
    .end local v6    # "edgesTouched":I
    :cond_6
    goto/16 :goto_6

    :cond_7
    float-to-int v5, v3

    float-to-int v6, v4

    invoke-virtual {p0, v5, v6}, Landroid/support/v4/widget/ViewDragHelper;->isCapturedViewUnder(II)Z

    move-result v5

    if-eqz v5, :cond_10

    .line 1144
    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {p0, v5, v2}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    goto/16 :goto_6

    .line 1234
    .end local v2    # "pointerId":I
    .end local v3    # "x":F
    .end local v4    # "y":F
    :pswitch_3
    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v2, v3, :cond_8

    .line 1235
    const/4 v2, 0x0

    invoke-direct {p0, v2, v2}, Landroid/support/v4/widget/ViewDragHelper;->dispatchViewReleased(FF)V

    .line 1237
    :cond_8
    invoke-virtual {p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    goto/16 :goto_6

    .line 1150
    :pswitch_4
    iget v4, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v4, v3, :cond_a

    .line 1152
    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    invoke-direct {p0, v2}, Landroid/support/v4/widget/ViewDragHelper;->isValidPointerForActionMove(I)Z

    move-result v2

    if-nez v2, :cond_9

    goto/16 :goto_6

    .line 1154
    :cond_9
    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v2

    .line 1155
    .local v2, "index":I
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    .line 1156
    .restart local v3    # "x":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    .line 1157
    .restart local v4    # "y":F
    iget-object v5, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionX:[F

    iget v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    aget v5, v5, v6

    sub-float v5, v3, v5

    float-to-int v5, v5

    .line 1158
    .local v5, "idx":I
    iget-object v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mLastMotionY:[F

    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    aget v6, v6, v7

    sub-float v6, v4, v6

    float-to-int v6, v6

    .line 1160
    .local v6, "idy":I
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v7}, Landroid/view/View;->getLeft()I

    move-result v7

    add-int/2addr v7, v5

    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    invoke-virtual {v8}, Landroid/view/View;->getTop()I

    move-result v8

    add-int/2addr v8, v6

    invoke-direct {p0, v7, v8, v5, v6}, Landroid/support/v4/widget/ViewDragHelper;->dragTo(IIII)V

    .line 1162
    invoke-direct {p0, p1}, Landroid/support/v4/widget/ViewDragHelper;->saveLastMotion(Landroid/view/MotionEvent;)V

    .line 1163
    .end local v2    # "index":I
    .end local v3    # "x":F
    .end local v4    # "y":F
    .end local v5    # "idx":I
    .end local v6    # "idy":I
    goto/16 :goto_6

    .line 1165
    :cond_a
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v4

    .line 1166
    .local v4, "pointerCount":I
    nop

    .line 1166
    .local v2, "i":I
    :goto_3
    if-ge v2, v4, :cond_e

    .line 1167
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v5

    .line 1170
    .local v5, "pointerId":I
    invoke-direct {p0, v5}, Landroid/support/v4/widget/ViewDragHelper;->isValidPointerForActionMove(I)Z

    move-result v6

    if-nez v6, :cond_b

    .line 1170
    .end local v5    # "pointerId":I
    goto :goto_4

    .line 1172
    .restart local v5    # "pointerId":I
    :cond_b
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    .line 1173
    .local v6, "x":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v7

    .line 1174
    .local v7, "y":F
    iget-object v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    aget v8, v8, v5

    sub-float v8, v6, v8

    .line 1175
    .local v8, "dx":F
    iget-object v9, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    aget v9, v9, v5

    sub-float v9, v7, v9

    .line 1177
    .local v9, "dy":F
    invoke-direct {p0, v8, v9, v5}, Landroid/support/v4/widget/ViewDragHelper;->reportNewEdgeDrags(FFI)V

    .line 1178
    iget v10, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v10, v3, :cond_c

    .line 1180
    goto :goto_5

    .line 1183
    :cond_c
    float-to-int v10, v6

    float-to-int v11, v7

    invoke-virtual {p0, v10, v11}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v10

    .line 1184
    .local v10, "toCapture":Landroid/view/View;
    invoke-direct {p0, v10, v8, v9}, Landroid/support/v4/widget/ViewDragHelper;->checkTouchSlop(Landroid/view/View;FF)Z

    move-result v11

    if-eqz v11, :cond_d

    .line 1185
    invoke-virtual {p0, v10, v5}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    move-result v11

    if-eqz v11, :cond_d

    .line 1186
    goto :goto_5

    .line 1166
    .end local v5    # "pointerId":I
    .end local v6    # "x":F
    .end local v7    # "y":F
    .end local v8    # "dx":F
    .end local v9    # "dy":F
    .end local v10    # "toCapture":Landroid/view/View;
    :cond_d
    :goto_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 1189
    .end local v2    # "i":I
    :cond_e
    :goto_5
    invoke-direct {p0, p1}, Landroid/support/v4/widget/ViewDragHelper;->saveLastMotion(Landroid/view/MotionEvent;)V

    .line 1191
    .end local v4    # "pointerCount":I
    goto :goto_6

    .line 1226
    :pswitch_5
    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v2, v3, :cond_f

    .line 1227
    invoke-direct {p0}, Landroid/support/v4/widget/ViewDragHelper;->releaseViewForPointerUp()V

    .line 1229
    :cond_f
    invoke-virtual {p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    .line 1230
    goto :goto_6

    .line 1102
    :pswitch_6
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v3

    .line 1103
    .restart local v3    # "x":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v4

    .line 1104
    .local v4, "y":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v2

    .line 1105
    .local v2, "pointerId":I
    float-to-int v5, v3

    float-to-int v6, v4

    invoke-virtual {p0, v5, v6}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v5

    .line 1107
    .local v5, "toCapture":Landroid/view/View;
    invoke-direct {p0, v3, v4, v2}, Landroid/support/v4/widget/ViewDragHelper;->saveInitialMotion(FFI)V

    .line 1112
    invoke-virtual {p0, v5, v2}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    .line 1114
    iget-object v6, p0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v6, v6, v2

    .line 1115
    .local v6, "edgesTouched":I
    iget v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v7, v6

    if-eqz v7, :cond_10

    .line 1116
    iget-object v7, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget v8, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v8, v6

    invoke-virtual {v7, v8, v2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeTouched(II)V

    .line 1241
    .end local v2    # "pointerId":I
    .end local v3    # "x":F
    .end local v4    # "y":F
    .end local v5    # "toCapture":Landroid/view/View;
    .end local v6    # "edgesTouched":I
    :cond_10
    :goto_6
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_0
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method setDragState(I)V
    .locals 2
    .param p1, "state"    # I

    .line 877
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mParentView:Landroid/view/ViewGroup;

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mSetIdleRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 878
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-eq v0, p1, :cond_0

    .line 879
    iput p1, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    .line 880
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v0, p1}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onViewDragStateChanged(I)V

    .line 881
    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-nez v0, :cond_0

    .line 882
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    .line 885
    :cond_0
    return-void
.end method

.method public setEdgeTrackingEnabled(I)V
    .locals 0
    .param p1, "edgeFlags"    # I

    .line 439
    iput p1, p0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    .line 440
    return-void
.end method

.method public setMinVelocity(F)V
    .locals 0
    .param p1, "minVel"    # F

    .line 403
    iput p1, p0, Landroid/support/v4/widget/ViewDragHelper;->mMinVelocity:F

    .line 404
    return-void
.end method

.method public settleCapturedViewAt(II)Z
    .locals 3
    .param p1, "finalLeft"    # I
    .param p2, "finalTop"    # I

    .line 566
    iget-boolean v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mReleaseInProgress:Z

    if-nez v0, :cond_0

    .line 567
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Cannot settleCapturedViewAt outside of a call to Callback#onViewReleased"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 571
    :cond_0
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 572
    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->getXVelocity(I)F

    move-result v0

    float-to-int v0, v0

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 573
    invoke-virtual {v1, v2}, Landroid/view/VelocityTracker;->getYVelocity(I)F

    move-result v1

    float-to-int v1, v1

    .line 571
    invoke-direct {p0, p1, p2, v0, v1}, Landroid/support/v4/widget/ViewDragHelper;->forceSettleCapturedViewAt(IIII)Z

    move-result v0

    return v0
.end method

.method public shouldInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 21
    .param p1, "ev"    # Landroid/view/MotionEvent;

    move-object/from16 v0, p0

    .line 952
    move-object/from16 v1, p1

    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    .line 953
    .local v2, "action":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v3

    .line 955
    .local v3, "actionIndex":I
    if-nez v2, :cond_0

    .line 958
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    .line 961
    :cond_0
    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v4, :cond_1

    .line 962
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v4

    iput-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 964
    :cond_1
    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v4, v1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 966
    const/4 v4, 0x2

    packed-switch v2, :pswitch_data_0

    .line 1076
    :cond_2
    :pswitch_0
    move/from16 v16, v2

    move/from16 v17, v3

    const/4 v5, 0x0

    .line 1076
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .local v16, "action":I
    .local v17, "actionIndex":I
    goto/16 :goto_6

    .line 1064
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .restart local v2    # "action":I
    .restart local v3    # "actionIndex":I
    :pswitch_1
    invoke-virtual {v1, v3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v4

    .line 1065
    .local v4, "pointerId":I
    invoke-direct {v0, v4}, Landroid/support/v4/widget/ViewDragHelper;->clearMotionHistory(I)V

    .line 1066
    nop

    .line 1076
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .end local v4    # "pointerId":I
    .restart local v16    # "action":I
    .restart local v17    # "actionIndex":I
    :cond_3
    :goto_0
    move/from16 v16, v2

    move/from16 v17, v3

    goto/16 :goto_5

    .line 988
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .restart local v2    # "action":I
    .restart local v3    # "actionIndex":I
    :pswitch_2
    invoke-virtual {v1, v3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v7

    .line 989
    .local v7, "pointerId":I
    invoke-virtual {v1, v3}, Landroid/view/MotionEvent;->getX(I)F

    move-result v8

    .line 990
    .local v8, "x":F
    invoke-virtual {v1, v3}, Landroid/view/MotionEvent;->getY(I)F

    move-result v9

    .line 992
    .local v9, "y":F
    invoke-direct {v0, v8, v9, v7}, Landroid/support/v4/widget/ViewDragHelper;->saveInitialMotion(FFI)V

    .line 995
    iget v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-nez v10, :cond_5

    .line 996
    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v4, v4, v7

    .line 997
    .local v4, "edgesTouched":I
    iget v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v10, v4

    if-eqz v10, :cond_4

    .line 998
    iget-object v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget v11, v0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v11, v4

    invoke-virtual {v10, v11, v7}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeTouched(II)V

    .line 1000
    .end local v4    # "edgesTouched":I
    :cond_4
    goto :goto_0

    :cond_5
    iget v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v10, v4, :cond_3

    .line 1002
    float-to-int v4, v8

    float-to-int v10, v9

    invoke-virtual {v0, v4, v10}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v4

    .line 1003
    .local v4, "toCapture":Landroid/view/View;
    iget-object v10, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    if-ne v4, v10, :cond_6

    .line 1004
    invoke-virtual {v0, v4, v7}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    .line 1006
    .end local v4    # "toCapture":Landroid/view/View;
    :cond_6
    goto :goto_0

    .line 1011
    .end local v7    # "pointerId":I
    .end local v8    # "x":F
    .end local v9    # "y":F
    :pswitch_3
    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    if-eqz v4, :cond_2

    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    if-nez v4, :cond_7

    goto :goto_0

    .line 1014
    :cond_7
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v4

    .line 1015
    .local v4, "pointerCount":I
    const/4 v7, 0x0

    .line 1015
    .local v7, "i":I
    :goto_1
    if-ge v7, v4, :cond_f

    .line 1016
    invoke-virtual {v1, v7}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v8

    .line 1019
    .local v8, "pointerId":I
    invoke-direct {v0, v8}, Landroid/support/v4/widget/ViewDragHelper;->isValidPointerForActionMove(I)Z

    move-result v9

    if-nez v9, :cond_8

    .line 1015
    .end local v8    # "pointerId":I
    move/from16 v16, v2

    move/from16 v17, v3

    move/from16 v18, v4

    goto/16 :goto_3

    .line 1021
    .restart local v8    # "pointerId":I
    :cond_8
    invoke-virtual {v1, v7}, Landroid/view/MotionEvent;->getX(I)F

    move-result v9

    .line 1022
    .local v9, "x":F
    invoke-virtual {v1, v7}, Landroid/view/MotionEvent;->getY(I)F

    move-result v10

    .line 1023
    .local v10, "y":F
    iget-object v11, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionX:[F

    aget v11, v11, v8

    sub-float v11, v9, v11

    .line 1024
    .local v11, "dx":F
    iget-object v12, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialMotionY:[F

    aget v12, v12, v8

    sub-float v12, v10, v12

    .line 1026
    .local v12, "dy":F
    float-to-int v13, v9

    float-to-int v14, v10

    invoke-virtual {v0, v13, v14}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v13

    .line 1027
    .local v13, "toCapture":Landroid/view/View;
    if-eqz v13, :cond_9

    invoke-direct {v0, v13, v11, v12}, Landroid/support/v4/widget/ViewDragHelper;->checkTouchSlop(Landroid/view/View;FF)Z

    move-result v14

    if-eqz v14, :cond_9

    const/4 v14, 0x1

    goto :goto_2

    :cond_9
    const/4 v14, 0x0

    .line 1028
    .local v14, "pastSlop":Z
    :goto_2
    if-eqz v14, :cond_b

    .line 1034
    invoke-virtual {v13}, Landroid/view/View;->getLeft()I

    move-result v15

    .line 1035
    .local v15, "oldLeft":I
    float-to-int v5, v11

    add-int/2addr v5, v15

    .line 1036
    .local v5, "targetLeft":I
    iget-object v6, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    move/from16 v16, v2

    float-to-int v2, v11

    .line 1036
    .end local v2    # "action":I
    .restart local v16    # "action":I
    invoke-virtual {v6, v13, v5, v2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->clampViewPositionHorizontal(Landroid/view/View;II)I

    move-result v2

    .line 1038
    .local v2, "newLeft":I
    invoke-virtual {v13}, Landroid/view/View;->getTop()I

    move-result v6

    .line 1039
    .local v6, "oldTop":I
    move/from16 v17, v3

    float-to-int v3, v12

    .line 1039
    .end local v3    # "actionIndex":I
    .restart local v17    # "actionIndex":I
    add-int/2addr v3, v6

    .line 1040
    .local v3, "targetTop":I
    move/from16 v18, v4

    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 1040
    .end local v4    # "pointerCount":I
    .local v18, "pointerCount":I
    move/from16 v19, v5

    float-to-int v5, v12

    .line 1040
    .end local v5    # "targetLeft":I
    .local v19, "targetLeft":I
    invoke-virtual {v4, v13, v3, v5}, Landroid/support/v4/widget/ViewDragHelper$Callback;->clampViewPositionVertical(Landroid/view/View;II)I

    move-result v4

    .line 1042
    .local v4, "newTop":I
    iget-object v5, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v5, v13}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewHorizontalDragRange(Landroid/view/View;)I

    move-result v5

    .line 1043
    .local v5, "hDragRange":I
    move/from16 v20, v3

    iget-object v3, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    .line 1043
    .end local v3    # "targetTop":I
    .local v20, "targetTop":I
    invoke-virtual {v3, v13}, Landroid/support/v4/widget/ViewDragHelper$Callback;->getViewVerticalDragRange(Landroid/view/View;)I

    move-result v3

    .line 1044
    .local v3, "vDragRange":I
    if-eqz v5, :cond_a

    if-lez v5, :cond_c

    if-ne v2, v15, :cond_c

    :cond_a
    if-eqz v3, :cond_10

    if-lez v3, :cond_c

    if-ne v4, v6, :cond_c

    .line 1046
    goto :goto_4

    .line 1049
    .end local v5    # "hDragRange":I
    .end local v6    # "oldTop":I
    .end local v15    # "oldLeft":I
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .end local v18    # "pointerCount":I
    .end local v19    # "targetLeft":I
    .end local v20    # "targetTop":I
    .local v2, "action":I
    .local v3, "actionIndex":I
    .local v4, "pointerCount":I
    :cond_b
    move/from16 v16, v2

    move/from16 v17, v3

    move/from16 v18, v4

    .line 1049
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .end local v4    # "pointerCount":I
    .restart local v16    # "action":I
    .restart local v17    # "actionIndex":I
    .restart local v18    # "pointerCount":I
    :cond_c
    invoke-direct {v0, v11, v12, v8}, Landroid/support/v4/widget/ViewDragHelper;->reportNewEdgeDrags(FFI)V

    .line 1050
    iget v2, v0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_d

    .line 1052
    goto :goto_4

    .line 1055
    :cond_d
    if-eqz v14, :cond_e

    invoke-virtual {v0, v13, v8}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    move-result v2

    if-eqz v2, :cond_e

    .line 1056
    goto :goto_4

    .line 1015
    .end local v8    # "pointerId":I
    .end local v9    # "x":F
    .end local v10    # "y":F
    .end local v11    # "dx":F
    .end local v12    # "dy":F
    .end local v13    # "toCapture":Landroid/view/View;
    .end local v14    # "pastSlop":Z
    :cond_e
    :goto_3
    add-int/lit8 v7, v7, 0x1

    move/from16 v2, v16

    move/from16 v3, v17

    move/from16 v4, v18

    goto/16 :goto_1

    .line 1059
    .end local v7    # "i":I
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .end local v18    # "pointerCount":I
    .restart local v2    # "action":I
    .restart local v3    # "actionIndex":I
    .restart local v4    # "pointerCount":I
    :cond_f
    move/from16 v16, v2

    move/from16 v17, v3

    move/from16 v18, v4

    .line 1059
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .end local v4    # "pointerCount":I
    .restart local v16    # "action":I
    .restart local v17    # "actionIndex":I
    .restart local v18    # "pointerCount":I
    :cond_10
    :goto_4
    invoke-direct/range {p0 .. p1}, Landroid/support/v4/widget/ViewDragHelper;->saveLastMotion(Landroid/view/MotionEvent;)V

    .line 1060
    goto :goto_5

    .line 1071
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .end local v18    # "pointerCount":I
    .restart local v2    # "action":I
    .restart local v3    # "actionIndex":I
    :pswitch_4
    move/from16 v16, v2

    move/from16 v17, v3

    .line 1071
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .restart local v16    # "action":I
    .restart local v17    # "actionIndex":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/widget/ViewDragHelper;->cancel()V

    .line 1076
    :goto_5
    const/4 v5, 0x0

    goto :goto_6

    .line 968
    .end local v16    # "action":I
    .end local v17    # "actionIndex":I
    .restart local v2    # "action":I
    .restart local v3    # "actionIndex":I
    :pswitch_5
    move/from16 v16, v2

    move/from16 v17, v3

    .line 968
    .end local v2    # "action":I
    .end local v3    # "actionIndex":I
    .restart local v16    # "action":I
    .restart local v17    # "actionIndex":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getX()F

    move-result v2

    .line 969
    .local v2, "x":F
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getY()F

    move-result v3

    .line 970
    .local v3, "y":F
    const/4 v5, 0x0

    invoke-virtual {v1, v5}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v6

    .line 971
    .local v6, "pointerId":I
    invoke-direct {v0, v2, v3, v6}, Landroid/support/v4/widget/ViewDragHelper;->saveInitialMotion(FFI)V

    .line 973
    float-to-int v7, v2

    float-to-int v8, v3

    invoke-virtual {v0, v7, v8}, Landroid/support/v4/widget/ViewDragHelper;->findTopChildUnder(II)Landroid/view/View;

    move-result-object v7

    .line 976
    .local v7, "toCapture":Landroid/view/View;
    iget-object v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    if-ne v7, v8, :cond_11

    iget v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-ne v8, v4, :cond_11

    .line 977
    invoke-virtual {v0, v7, v6}, Landroid/support/v4/widget/ViewDragHelper;->tryCaptureViewForDrag(Landroid/view/View;I)Z

    .line 980
    :cond_11
    iget-object v4, v0, Landroid/support/v4/widget/ViewDragHelper;->mInitialEdgesTouched:[I

    aget v4, v4, v6

    .line 981
    .local v4, "edgesTouched":I
    iget v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v8, v4

    if-eqz v8, :cond_12

    .line 982
    iget-object v8, v0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    iget v9, v0, Landroid/support/v4/widget/ViewDragHelper;->mTrackingEdges:I

    and-int/2addr v9, v4

    invoke-virtual {v8, v9, v6}, Landroid/support/v4/widget/ViewDragHelper$Callback;->onEdgeTouched(II)V

    .line 1076
    .end local v2    # "x":F
    .end local v3    # "y":F
    .end local v4    # "edgesTouched":I
    .end local v6    # "pointerId":I
    .end local v7    # "toCapture":Landroid/view/View;
    :cond_12
    :goto_6
    iget v2, v0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_13

    goto :goto_7

    :cond_13
    move v3, v5

    :goto_7
    return v3

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_4
        :pswitch_0
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public smoothSlideViewTo(Landroid/view/View;II)Z
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "finalLeft"    # I
    .param p3, "finalTop"    # I

    .line 541
    iput-object p1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    .line 542
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 544
    const/4 v0, 0x0

    invoke-direct {p0, p2, p3, v0, v0}, Landroid/support/v4/widget/ViewDragHelper;->forceSettleCapturedViewAt(IIII)Z

    move-result v0

    .line 545
    .local v0, "continueSliding":Z
    if-nez v0, :cond_0

    iget v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mDragState:I

    if-nez v1, :cond_0

    iget-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    if-eqz v1, :cond_0

    .line 548
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    .line 551
    :cond_0
    return v0
.end method

.method tryCaptureViewForDrag(Landroid/view/View;I)Z
    .locals 2
    .param p1, "toCapture"    # Landroid/view/View;
    .param p2, "pointerId"    # I

    .line 897
    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCapturedView:Landroid/view/View;

    const/4 v1, 0x1

    if-ne p1, v0, :cond_0

    iget v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    if-ne v0, p2, :cond_0

    .line 899
    return v1

    .line 901
    :cond_0
    if-eqz p1, :cond_1

    iget-object v0, p0, Landroid/support/v4/widget/ViewDragHelper;->mCallback:Landroid/support/v4/widget/ViewDragHelper$Callback;

    invoke-virtual {v0, p1, p2}, Landroid/support/v4/widget/ViewDragHelper$Callback;->tryCaptureView(Landroid/view/View;I)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 902
    iput p2, p0, Landroid/support/v4/widget/ViewDragHelper;->mActivePointerId:I

    .line 903
    invoke-virtual {p0, p1, p2}, Landroid/support/v4/widget/ViewDragHelper;->captureChildView(Landroid/view/View;I)V

    .line 904
    return v1

    .line 906
    :cond_1
    const/4 v0, 0x0

    return v0
.end method
