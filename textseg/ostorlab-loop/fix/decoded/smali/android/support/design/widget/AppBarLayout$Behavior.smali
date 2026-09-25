.class public Landroid/support/design/widget/AppBarLayout$Behavior;
.super Landroid/support/design/widget/HeaderBehavior;
.source "AppBarLayout.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/design/widget/AppBarLayout;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Behavior"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;,
        Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/support/design/widget/HeaderBehavior<",
        "Landroid/support/design/widget/AppBarLayout;",
        ">;"
    }
.end annotation


# static fields
.field private static final INVALID_POSITION:I = -0x1

.field private static final MAX_OFFSET_ANIMATION_DURATION:I = 0x258


# instance fields
.field private mLastNestedScrollingChildRef:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private mOffsetAnimator:Landroid/animation/ValueAnimator;

.field private mOffsetDelta:I

.field private mOffsetToChildIndexOnLayout:I

.field private mOffsetToChildIndexOnLayoutIsMinHeight:Z

.field private mOffsetToChildIndexOnLayoutPerc:F

.field private mOnDragCallback:Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 817
    invoke-direct {p0}, Landroid/support/design/widget/HeaderBehavior;-><init>()V

    .line 810
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    .line 817
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 820
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/HeaderBehavior;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 810
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    .line 821
    return-void
.end method

.method static synthetic access$000(Landroid/support/design/widget/AppBarLayout$Behavior;)I
    .locals 1
    .param p0, "x0"    # Landroid/support/design/widget/AppBarLayout$Behavior;

    .line 787
    iget v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetDelta:I

    return v0
.end method

.method private animateOffsetTo(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IF)V
    .locals 4
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "offset"    # I
    .param p4, "velocity"    # F

    .line 898
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopBottomOffsetForScrollingSibling()I

    move-result v0

    sub-int/2addr v0, p3

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    .line 901
    .local v0, "distance":I
    invoke-static {p4}, Ljava/lang/Math;->abs(F)F

    move-result p4

    .line 902
    const/4 v1, 0x0

    cmpl-float v1, p4, v1

    if-lez v1, :cond_0

    .line 903
    const/high16 v1, 0x447a0000    # 1000.0f

    int-to-float v2, v0

    div-float/2addr v2, p4

    mul-float/2addr v2, v1

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v1

    mul-int/lit8 v1, v1, 0x3

    .line 903
    .local v1, "duration":I
    goto :goto_0

    .line 905
    .end local v1    # "duration":I
    :cond_0
    int-to-float v1, v0

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getHeight()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v1, v2

    .line 906
    .local v1, "distanceRatio":F
    const/high16 v2, 0x3f800000    # 1.0f

    add-float/2addr v2, v1

    const/high16 v3, 0x43160000    # 150.0f

    mul-float/2addr v2, v3

    float-to-int v1, v2

    .line 909
    .local v1, "duration":I
    :goto_0
    invoke-direct {p0, p1, p2, p3, v1}, Landroid/support/design/widget/AppBarLayout$Behavior;->animateOffsetWithDuration(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;II)V

    .line 910
    return-void
.end method

.method private animateOffsetWithDuration(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;II)V
    .locals 4
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "offset"    # I
    .param p4, "duration"    # I

    .line 914
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopBottomOffsetForScrollingSibling()I

    move-result v0

    .line 915
    .local v0, "currentOffset":I
    if-ne v0, p3, :cond_1

    .line 916
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    if-eqz v1, :cond_0

    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->isRunning()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 917
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    .line 919
    :cond_0
    return-void

    .line 922
    :cond_1
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    if-nez v1, :cond_2

    .line 923
    new-instance v1, Landroid/animation/ValueAnimator;

    invoke-direct {v1}, Landroid/animation/ValueAnimator;-><init>()V

    iput-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    .line 924
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    sget-object v2, Landroid/support/design/widget/AnimationUtils;->DECELERATE_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v1, v2}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 925
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    new-instance v2, Landroid/support/design/widget/AppBarLayout$Behavior$1;

    invoke-direct {v2, p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior$1;-><init>(Landroid/support/design/widget/AppBarLayout$Behavior;Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V

    invoke-virtual {v1, v2}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    goto :goto_0

    .line 933
    :cond_2
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    .line 936
    :goto_0
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    const/16 v2, 0x258

    invoke-static {p4, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    int-to-long v2, v2

    invoke-virtual {v1, v2, v3}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    .line 937
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    const/4 v2, 0x2

    new-array v2, v2, [I

    const/4 v3, 0x0

    aput v0, v2, v3

    const/4 v3, 0x1

    aput p3, v2, v3

    invoke-virtual {v1, v2}, Landroid/animation/ValueAnimator;->setIntValues([I)V

    .line 938
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->start()V

    .line 939
    return-void
.end method

.method private static checkFlag(II)Z
    .locals 1
    .param p0, "flags"    # I
    .param p1, "check"    # I

    .line 994
    and-int v0, p0, p1

    if-ne v0, p1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static getAppBarChildOnOffset(Landroid/support/design/widget/AppBarLayout;I)Landroid/view/View;
    .locals 5
    .param p0, "layout"    # Landroid/support/design/widget/AppBarLayout;
    .param p1, "offset"    # I

    .line 1260
    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v0

    .line 1261
    .local v0, "absOffset":I
    const/4 v1, 0x0

    .line 1261
    .local v1, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 1261
    .local v2, "z":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 1262
    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1263
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v4

    if-lt v0, v4, :cond_0

    invoke-virtual {v3}, Landroid/view/View;->getBottom()I

    move-result v4

    if-gt v0, v4, :cond_0

    .line 1264
    return-object v3

    .line 1261
    .end local v3    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1267
    .end local v1    # "i":I
    .end local v2    # "z":I
    :cond_1
    const/4 v1, 0x0

    return-object v1
.end method

.method private getChildIndexOnOffset(Landroid/support/design/widget/AppBarLayout;I)I
    .locals 5
    .param p1, "abl"    # Landroid/support/design/widget/AppBarLayout;
    .param p2, "offset"    # I

    .line 942
    const/4 v0, 0x0

    .line 942
    .local v0, "i":I
    invoke-virtual {p1}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v1

    .line 942
    .local v1, "count":I
    :goto_0
    if-ge v0, v1, :cond_1

    .line 943
    invoke-virtual {p1, v0}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 944
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getTop()I

    move-result v3

    neg-int v4, p2

    if-gt v3, v4, :cond_0

    invoke-virtual {v2}, Landroid/view/View;->getBottom()I

    move-result v3

    neg-int v4, p2

    if-lt v3, v4, :cond_0

    .line 945
    return v0

    .line 942
    .end local v2    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 948
    .end local v0    # "i":I
    .end local v1    # "count":I
    :cond_1
    const/4 v0, -0x1

    return v0
.end method

.method private interpolateOffset(Landroid/support/design/widget/AppBarLayout;I)I
    .locals 12
    .param p1, "layout"    # Landroid/support/design/widget/AppBarLayout;
    .param p2, "offset"    # I

    .line 1161
    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result v0

    .line 1163
    .local v0, "absOffset":I
    const/4 v1, 0x0

    .line 1163
    .local v1, "i":I
    invoke-virtual {p1}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 1163
    .local v2, "z":I
    :goto_0
    if-ge v1, v2, :cond_4

    .line 1164
    invoke-virtual {p1, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1165
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 1166
    .local v4, "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v4}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->getScrollInterpolator()Landroid/view/animation/Interpolator;

    move-result-object v5

    .line 1168
    .local v5, "interpolator":Landroid/view/animation/Interpolator;
    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v6

    if-lt v0, v6, :cond_3

    invoke-virtual {v3}, Landroid/view/View;->getBottom()I

    move-result v6

    if-gt v0, v6, :cond_3

    .line 1169
    if-eqz v5, :cond_4

    .line 1170
    const/4 v6, 0x0

    .line 1171
    .local v6, "childScrollableHeight":I
    invoke-virtual {v4}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->getScrollFlags()I

    move-result v7

    .line 1172
    .local v7, "flags":I
    and-int/lit8 v8, v7, 0x1

    if-eqz v8, :cond_0

    .line 1174
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v8

    iget v9, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->topMargin:I

    add-int/2addr v8, v9

    iget v9, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->bottomMargin:I

    add-int/2addr v8, v9

    add-int/2addr v6, v8

    .line 1177
    and-int/lit8 v8, v7, 0x2

    if-eqz v8, :cond_0

    .line 1180
    invoke-static {v3}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v8

    sub-int/2addr v6, v8

    .line 1184
    :cond_0
    invoke-static {v3}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v8

    if-eqz v8, :cond_1

    .line 1185
    invoke-virtual {p1}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v8

    sub-int/2addr v6, v8

    .line 1188
    :cond_1
    if-lez v6, :cond_2

    .line 1189
    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v8

    sub-int v8, v0, v8

    .line 1190
    .local v8, "offsetForView":I
    int-to-float v9, v6

    int-to-float v10, v8

    int-to-float v11, v6

    div-float/2addr v10, v11

    .line 1191
    invoke-interface {v5, v10}, Landroid/view/animation/Interpolator;->getInterpolation(F)F

    move-result v10

    mul-float/2addr v9, v10

    .line 1190
    invoke-static {v9}, Ljava/lang/Math;->round(F)I

    move-result v9

    .line 1194
    .local v9, "interpolatedDiff":I
    invoke-static {p2}, Ljava/lang/Integer;->signum(I)I

    move-result v10

    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v11

    add-int/2addr v11, v9

    mul-int/2addr v10, v11

    return v10

    .line 1196
    .end local v6    # "childScrollableHeight":I
    .end local v7    # "flags":I
    .end local v8    # "offsetForView":I
    .end local v9    # "interpolatedDiff":I
    :cond_2
    goto :goto_1

    .line 1163
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v5    # "interpolator":Landroid/view/animation/Interpolator;
    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1204
    .end local v1    # "i":I
    .end local v2    # "z":I
    :cond_4
    :goto_1
    return p2
.end method

.method private shouldJumpElevationState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)Z
    .locals 8
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "layout"    # Landroid/support/design/widget/AppBarLayout;

    .line 1245
    invoke-virtual {p1, p2}, Landroid/support/design/widget/CoordinatorLayout;->getDependents(Landroid/view/View;)Ljava/util/List;

    move-result-object v0

    .line 1246
    .local v0, "dependencies":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    const/4 v1, 0x0

    .line 1246
    .local v1, "i":I
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    .line 1246
    .local v2, "size":I
    :goto_0
    const/4 v3, 0x0

    if-ge v1, v2, :cond_2

    .line 1247
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/View;

    .line 1248
    .local v4, "dependency":Landroid/view/View;
    nop

    .line 1249
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    check-cast v5, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1250
    .local v5, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v5}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v6

    .line 1252
    .local v6, "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    instance-of v7, v6, Landroid/support/design/widget/AppBarLayout$ScrollingViewBehavior;

    if-eqz v7, :cond_1

    .line 1253
    move-object v7, v6

    check-cast v7, Landroid/support/design/widget/AppBarLayout$ScrollingViewBehavior;

    invoke-virtual {v7}, Landroid/support/design/widget/AppBarLayout$ScrollingViewBehavior;->getOverlayTop()I

    move-result v7

    if-eqz v7, :cond_0

    const/4 v3, 0x1

    nop

    :cond_0
    return v3

    .line 1246
    .end local v4    # "dependency":Landroid/view/View;
    .end local v5    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v6    # "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1256
    .end local v1    # "i":I
    .end local v2    # "size":I
    :cond_2
    return v3
.end method

.method private snapToChildIfNeeded(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V
    .locals 10
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "abl"    # Landroid/support/design/widget/AppBarLayout;

    .line 952
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopBottomOffsetForScrollingSibling()I

    move-result v0

    .line 953
    .local v0, "offset":I
    invoke-direct {p0, p2, v0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getChildIndexOnOffset(Landroid/support/design/widget/AppBarLayout;I)I

    move-result v1

    .line 954
    .local v1, "offsetChildIndex":I
    if-ltz v1, :cond_5

    .line 955
    invoke-virtual {p2, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 956
    .local v2, "offsetChild":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 957
    .local v3, "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->getScrollFlags()I

    move-result v4

    .line 959
    .local v4, "flags":I
    and-int/lit8 v5, v4, 0x11

    const/16 v6, 0x11

    if-ne v5, v6, :cond_5

    .line 961
    invoke-virtual {v2}, Landroid/view/View;->getTop()I

    move-result v5

    neg-int v5, v5

    .line 962
    .local v5, "snapTop":I
    invoke-virtual {v2}, Landroid/view/View;->getBottom()I

    move-result v6

    neg-int v6, v6

    .line 964
    .local v6, "snapBottom":I
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v7

    add-int/lit8 v7, v7, -0x1

    if-ne v1, v7, :cond_0

    .line 966
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v7

    add-int/2addr v6, v7

    .line 969
    :cond_0
    const/4 v7, 0x2

    invoke-static {v4, v7}, Landroid/support/design/widget/AppBarLayout$Behavior;->checkFlag(II)Z

    move-result v8

    if-eqz v8, :cond_1

    .line 971
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v8

    add-int/2addr v6, v8

    goto :goto_0

    .line 972
    :cond_1
    const/4 v8, 0x5

    invoke-static {v4, v8}, Landroid/support/design/widget/AppBarLayout$Behavior;->checkFlag(II)Z

    move-result v8

    if-eqz v8, :cond_3

    .line 976
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v8

    add-int/2addr v8, v6

    .line 977
    .local v8, "seam":I
    if-ge v0, v8, :cond_2

    .line 978
    move v5, v8

    goto :goto_0

    .line 980
    :cond_2
    move v6, v8

    .line 984
    .end local v8    # "seam":I
    :cond_3
    :goto_0
    add-int v8, v6, v5

    div-int/2addr v8, v7

    if-ge v0, v8, :cond_4

    move v7, v6

    goto :goto_1

    :cond_4
    move v7, v5

    .line 987
    .local v7, "newOffset":I
    :goto_1
    nop

    .line 988
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v8

    neg-int v8, v8

    const/4 v9, 0x0

    invoke-static {v7, v8, v9}, Landroid/support/v4/math/MathUtils;->clamp(III)I

    move-result v8

    const/4 v9, 0x0

    .line 987
    invoke-direct {p0, p1, p2, v8, v9}, Landroid/support/design/widget/AppBarLayout$Behavior;->animateOffsetTo(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IF)V

    .line 991
    .end local v2    # "offsetChild":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v4    # "flags":I
    .end local v5    # "snapTop":I
    .end local v6    # "snapBottom":I
    .end local v7    # "newOffset":I
    :cond_5
    return-void
.end method

.method private updateAppBarLayoutDrawableState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IIZ)V
    .locals 10
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "layout"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "offset"    # I
    .param p4, "direction"    # I
    .param p5, "forceJump"    # Z

    .line 1210
    invoke-static {p2, p3}, Landroid/support/design/widget/AppBarLayout$Behavior;->getAppBarChildOnOffset(Landroid/support/design/widget/AppBarLayout;I)Landroid/view/View;

    move-result-object v0

    .line 1211
    .local v0, "child":Landroid/view/View;
    if-eqz v0, :cond_5

    .line 1212
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 1213
    .local v1, "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v1}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->getScrollFlags()I

    move-result v2

    .line 1214
    .local v2, "flags":I
    const/4 v3, 0x0

    .line 1216
    .local v3, "collapsed":Z
    and-int/lit8 v4, v2, 0x1

    if-eqz v4, :cond_3

    .line 1217
    invoke-static {v0}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v4

    .line 1219
    .local v4, "minHeight":I
    const/4 v5, 0x0

    const/4 v6, 0x1

    if-lez p4, :cond_1

    and-int/lit8 v7, v2, 0xc

    if-eqz v7, :cond_1

    .line 1223
    neg-int v7, p3

    invoke-virtual {v0}, Landroid/view/View;->getBottom()I

    move-result v8

    sub-int/2addr v8, v4

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v9

    sub-int/2addr v8, v9

    if-lt v7, v8, :cond_0

    move v5, v6

    nop

    :cond_0
    move v3, v5

    goto :goto_0

    .line 1224
    :cond_1
    and-int/lit8 v7, v2, 0x2

    if-eqz v7, :cond_3

    .line 1227
    neg-int v7, p3

    invoke-virtual {v0}, Landroid/view/View;->getBottom()I

    move-result v8

    sub-int/2addr v8, v4

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v9

    sub-int/2addr v8, v9

    if-lt v7, v8, :cond_2

    move v5, v6

    nop

    :cond_2
    move v3, v5

    .line 1231
    .end local v4    # "minHeight":I
    :cond_3
    :goto_0
    invoke-virtual {p2, v3}, Landroid/support/design/widget/AppBarLayout;->setCollapsedState(Z)Z

    move-result v4

    .line 1233
    .local v4, "changed":Z
    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v6, 0xb

    if-lt v5, v6, :cond_5

    if-nez p5, :cond_4

    if-eqz v4, :cond_5

    .line 1234
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior;->shouldJumpElevationState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)Z

    move-result v5

    if-eqz v5, :cond_5

    .line 1237
    :cond_4
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->jumpDrawablesToCurrentState()V

    .line 1240
    .end local v1    # "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v2    # "flags":I
    .end local v3    # "collapsed":Z
    .end local v4    # "changed":Z
    :cond_5
    return-void
.end method


# virtual methods
.method canDragView(Landroid/support/design/widget/AppBarLayout;)Z
    .locals 3
    .param p1, "view"    # Landroid/support/design/widget/AppBarLayout;

    .line 1077
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOnDragCallback:Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;

    if-eqz v0, :cond_0

    .line 1079
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOnDragCallback:Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;

    invoke-virtual {v0, p1}, Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;->canDrag(Landroid/support/design/widget/AppBarLayout;)Z

    move-result v0

    return v0

    .line 1083
    :cond_0
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mLastNestedScrollingChildRef:Ljava/lang/ref/WeakReference;

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    .line 1085
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mLastNestedScrollingChildRef:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1086
    .local v0, "scrollingView":Landroid/view/View;
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v2

    if-eqz v2, :cond_1

    const/4 v2, -0x1

    .line 1087
    invoke-virtual {v0, v2}, Landroid/view/View;->canScrollVertically(I)Z

    move-result v2

    if-nez v2, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    return v1

    .line 1090
    .end local v0    # "scrollingView":Landroid/view/View;
    :cond_2
    return v1
.end method

.method bridge synthetic canDragView(Landroid/view/View;)Z
    .locals 0

    .line 787
    check-cast p1, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout$Behavior;->canDragView(Landroid/support/design/widget/AppBarLayout;)Z

    move-result p1

    return p1
.end method

.method public bridge synthetic getLeftAndRightOffset()I
    .locals 1

    .line 787
    invoke-super {p0}, Landroid/support/design/widget/HeaderBehavior;->getLeftAndRightOffset()I

    move-result v0

    return v0
.end method

.method getMaxDragOffset(Landroid/support/design/widget/AppBarLayout;)I
    .locals 1
    .param p1, "view"    # Landroid/support/design/widget/AppBarLayout;

    .line 1102
    invoke-virtual {p1}, Landroid/support/design/widget/AppBarLayout;->getDownNestedScrollRange()I

    move-result v0

    neg-int v0, v0

    return v0
.end method

.method bridge synthetic getMaxDragOffset(Landroid/view/View;)I
    .locals 0

    .line 787
    check-cast p1, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout$Behavior;->getMaxDragOffset(Landroid/support/design/widget/AppBarLayout;)I

    move-result p1

    return p1
.end method

.method getScrollRangeForDragFling(Landroid/support/design/widget/AppBarLayout;)I
    .locals 1
    .param p1, "view"    # Landroid/support/design/widget/AppBarLayout;

    .line 1107
    invoke-virtual {p1}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v0

    return v0
.end method

.method bridge synthetic getScrollRangeForDragFling(Landroid/view/View;)I
    .locals 0

    .line 787
    check-cast p1, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout$Behavior;->getScrollRangeForDragFling(Landroid/support/design/widget/AppBarLayout;)I

    move-result p1

    return p1
.end method

.method public bridge synthetic getTopAndBottomOffset()I
    .locals 1

    .line 787
    invoke-super {p0}, Landroid/support/design/widget/HeaderBehavior;->getTopAndBottomOffset()I

    move-result v0

    return v0
.end method

.method getTopBottomOffsetForScrollingSibling()I
    .locals 2

    .line 1272
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v0

    iget v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetDelta:I

    add-int/2addr v0, v1

    return v0
.end method

.method isOffsetAnimatorRunning()Z
    .locals 1
    .annotation build Landroid/support/annotation/VisibleForTesting;
    .end annotation

    .line 1157
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->isRunning()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method onFlingFinished(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V
    .locals 0
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "layout"    # Landroid/support/design/widget/AppBarLayout;

    .line 1097
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior;->snapToChildIfNeeded(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V

    .line 1098
    return-void
.end method

.method bridge synthetic onFlingFinished(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)V
    .locals 0

    .line 787
    check-cast p2, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior;->onFlingFinished(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V

    return-void
.end method

.method public onLayoutChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;I)Z
    .locals 9
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "abl"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "layoutDirection"    # I

    .line 1021
    invoke-super {p0, p1, p2, p3}, Landroid/support/design/widget/HeaderBehavior;->onLayoutChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)Z

    move-result v0

    .line 1027
    .local v0, "handled":Z
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getPendingAction()I

    move-result v1

    .line 1028
    .local v1, "pendingAction":I
    iget v2, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    const/4 v3, 0x0

    if-ltz v2, :cond_1

    and-int/lit8 v2, v1, 0x8

    if-nez v2, :cond_1

    .line 1029
    iget v2, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    invoke-virtual {p2, v2}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1030
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getBottom()I

    move-result v4

    neg-int v4, v4

    .line 1031
    .local v4, "offset":I
    iget-boolean v5, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayoutIsMinHeight:Z

    if-eqz v5, :cond_0

    .line 1032
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v5

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v6

    add-int/2addr v5, v6

    add-int/2addr v4, v5

    goto :goto_0

    .line 1034
    :cond_0
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I

    move-result v5

    int-to-float v5, v5

    iget v6, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayoutPerc:F

    mul-float/2addr v5, v6

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v5

    add-int/2addr v4, v5

    .line 1036
    :goto_0
    invoke-virtual {p0, p1, p2, v4}, Landroid/support/design/widget/AppBarLayout$Behavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)I

    .line 1037
    .end local v2    # "child":Landroid/view/View;
    .end local v4    # "offset":I
    goto :goto_3

    :cond_1
    if-eqz v1, :cond_6

    .line 1038
    and-int/lit8 v2, v1, 0x4

    if-eqz v2, :cond_2

    const/4 v2, 0x1

    goto :goto_1

    :cond_2
    move v2, v3

    .line 1039
    .local v2, "animate":Z
    :goto_1
    and-int/lit8 v4, v1, 0x2

    const/4 v5, 0x0

    if-eqz v4, :cond_4

    .line 1040
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getUpNestedPreScrollRange()I

    move-result v4

    neg-int v4, v4

    .line 1041
    .restart local v4    # "offset":I
    if-eqz v2, :cond_3

    .line 1042
    invoke-direct {p0, p1, p2, v4, v5}, Landroid/support/design/widget/AppBarLayout$Behavior;->animateOffsetTo(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IF)V

    goto :goto_2

    .line 1044
    :cond_3
    invoke-virtual {p0, p1, p2, v4}, Landroid/support/design/widget/AppBarLayout$Behavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)I

    .line 1046
    .end local v4    # "offset":I
    :goto_2
    goto :goto_3

    :cond_4
    and-int/lit8 v4, v1, 0x1

    if-eqz v4, :cond_6

    .line 1047
    if-eqz v2, :cond_5

    .line 1048
    invoke-direct {p0, p1, p2, v3, v5}, Landroid/support/design/widget/AppBarLayout$Behavior;->animateOffsetTo(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IF)V

    goto :goto_3

    .line 1050
    :cond_5
    invoke-virtual {p0, p1, p2, v3}, Landroid/support/design/widget/AppBarLayout$Behavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)I

    .line 1056
    .end local v2    # "animate":Z
    :cond_6
    :goto_3
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->resetPendingAction()V

    .line 1057
    const/4 v2, -0x1

    iput v2, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    .line 1061
    nop

    .line 1062
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v2

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v4

    neg-int v4, v4

    invoke-static {v2, v4, v3}, Landroid/support/v4/math/MathUtils;->clamp(III)I

    move-result v2

    .line 1061
    invoke-virtual {p0, v2}, Landroid/support/design/widget/AppBarLayout$Behavior;->setTopAndBottomOffset(I)Z

    .line 1067
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v6

    const/4 v7, 0x0

    const/4 v8, 0x1

    move-object v3, p0

    move-object v4, p1

    move-object v5, p2

    invoke-direct/range {v3 .. v8}, Landroid/support/design/widget/AppBarLayout$Behavior;->updateAppBarLayoutDrawableState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IIZ)V

    .line 1070
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v2

    invoke-virtual {p2, v2}, Landroid/support/design/widget/AppBarLayout;->dispatchOffsetUpdates(I)V

    .line 1072
    return v0
.end method

.method public bridge synthetic onLayoutChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)Z
    .locals 0

    .line 787
    check-cast p2, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1, p2, p3}, Landroid/support/design/widget/AppBarLayout$Behavior;->onLayoutChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;I)Z

    move-result p1

    return p1
.end method

.method public onMeasureChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IIII)Z
    .locals 8
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "parentWidthMeasureSpec"    # I
    .param p4, "widthUsed"    # I
    .param p5, "parentHeightMeasureSpec"    # I
    .param p6, "heightUsed"    # I

    .line 1001
    nop

    .line 1002
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1003
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->height:I

    const/4 v2, -0x2

    if-ne v1, v2, :cond_0

    .line 1008
    nop

    .line 1009
    const/4 v1, 0x0

    invoke-static {v1, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v6

    .line 1008
    move-object v2, p1

    move-object v3, p2

    move v4, p3

    move v5, p4

    move v7, p6

    invoke-virtual/range {v2 .. v7}, Landroid/support/design/widget/CoordinatorLayout;->onMeasureChild(Landroid/view/View;IIII)V

    .line 1010
    const/4 v1, 0x1

    return v1

    .line 1014
    :cond_0
    invoke-super/range {p0 .. p6}, Landroid/support/design/widget/HeaderBehavior;->onMeasureChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;IIII)Z

    move-result v1

    return v1
.end method

.method public bridge synthetic onMeasureChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;IIII)Z
    .locals 7

    .line 787
    move-object v2, p2

    check-cast v2, Landroid/support/design/widget/AppBarLayout;

    move-object v0, p0

    move-object v1, p1

    move v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/AppBarLayout$Behavior;->onMeasureChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IIII)Z

    move-result p1

    return p1
.end method

.method public onNestedPreScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;II[II)V
    .locals 9
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "target"    # Landroid/view/View;
    .param p4, "dx"    # I
    .param p5, "dy"    # I
    .param p6, "consumed"    # [I
    .param p7, "type"    # I

    .line 846
    if-eqz p5, :cond_1

    .line 848
    if-gez p5, :cond_0

    .line 850
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v0

    neg-int v0, v0

    .line 851
    .local v0, "min":I
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getDownNestedPreScrollRange()I

    move-result v1

    add-int/2addr v1, v0

    .line 855
    .end local v0    # "min":I
    .local v1, "max":I
    .local v6, "min":I
    :goto_0
    move v6, v0

    goto :goto_1

    .line 854
    .end local v1    # "max":I
    .end local v6    # "min":I
    :cond_0
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getUpNestedPreScrollRange()I

    move-result v0

    neg-int v0, v0

    .line 855
    .restart local v0    # "min":I
    const/4 v1, 0x0

    goto :goto_0

    .line 855
    .end local v0    # "min":I
    .restart local v1    # "max":I
    .restart local v6    # "min":I
    :goto_1
    move v7, v1

    .line 857
    .end local v1    # "max":I
    .local v7, "max":I
    if-eq v6, v7, :cond_1

    .line 858
    const/4 v8, 0x1

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p5

    move v4, v6

    move v5, v7

    invoke-virtual/range {v0 .. v5}, Landroid/support/design/widget/AppBarLayout$Behavior;->scroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I

    move-result v0

    aput v0, p6, v8

    .line 861
    .end local v6    # "min":I
    .end local v7    # "max":I
    :cond_1
    return-void
.end method

.method public bridge synthetic onNestedPreScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;II[II)V
    .locals 8

    .line 787
    move-object v2, p2

    check-cast v2, Landroid/support/design/widget/AppBarLayout;

    move-object v0, p0

    move-object v1, p1

    move-object v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    move v7, p7

    invoke-virtual/range {v0 .. v7}, Landroid/support/design/widget/AppBarLayout$Behavior;->onNestedPreScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;II[II)V

    return-void
.end method

.method public onNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;IIIII)V
    .locals 7
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "target"    # Landroid/view/View;
    .param p4, "dxConsumed"    # I
    .param p5, "dyConsumed"    # I
    .param p6, "dxUnconsumed"    # I
    .param p7, "dyUnconsumed"    # I
    .param p8, "type"    # I

    .line 867
    if-gez p7, :cond_0

    .line 870
    nop

    .line 871
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getDownNestedScrollRange()I

    move-result v0

    neg-int v5, v0

    const/4 v6, 0x0

    .line 870
    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    move v4, p7

    invoke-virtual/range {v1 .. v6}, Landroid/support/design/widget/AppBarLayout$Behavior;->scroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I

    .line 873
    :cond_0
    return-void
.end method

.method public bridge synthetic onNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;IIIII)V
    .locals 9

    .line 787
    move-object v2, p2

    check-cast v2, Landroid/support/design/widget/AppBarLayout;

    move-object v0, p0

    move-object v1, p1

    move-object v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    move/from16 v7, p7

    move/from16 v8, p8

    invoke-virtual/range {v0 .. v8}, Landroid/support/design/widget/AppBarLayout$Behavior;->onNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;IIIII)V

    return-void
.end method

.method public onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/os/Parcelable;)V
    .locals 2
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "appBarLayout"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "state"    # Landroid/os/Parcelable;

    .line 1302
    instance-of v0, p3, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;

    if-eqz v0, :cond_0

    .line 1303
    move-object v0, p3

    check-cast v0, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;

    .line 1304
    .local v0, "ss":Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;
    invoke-virtual {v0}, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->getSuperState()Landroid/os/Parcelable;

    move-result-object v1

    invoke-super {p0, p1, p2, v1}, Landroid/support/design/widget/HeaderBehavior;->onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/os/Parcelable;)V

    .line 1305
    iget v1, v0, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildIndex:I

    iput v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    .line 1306
    iget v1, v0, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildPercentageShown:F

    iput v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayoutPerc:F

    .line 1307
    iget-boolean v1, v0, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildAtMinimumHeight:Z

    iput-boolean v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayoutIsMinHeight:Z

    .line 1308
    .end local v0    # "ss":Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;
    goto :goto_0

    .line 1309
    :cond_0
    invoke-super {p0, p1, p2, p3}, Landroid/support/design/widget/HeaderBehavior;->onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/os/Parcelable;)V

    .line 1310
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetToChildIndexOnLayout:I

    .line 1312
    :goto_0
    return-void
.end method

.method public bridge synthetic onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/os/Parcelable;)V
    .locals 0

    .line 787
    check-cast p2, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1, p2, p3}, Landroid/support/design/widget/AppBarLayout$Behavior;->onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/os/Parcelable;)V

    return-void
.end method

.method public onSaveInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)Landroid/os/Parcelable;
    .locals 9
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "abl"    # Landroid/support/design/widget/AppBarLayout;

    .line 1277
    invoke-super {p0, p1, p2}, Landroid/support/design/widget/HeaderBehavior;->onSaveInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)Landroid/os/Parcelable;

    move-result-object v0

    .line 1278
    .local v0, "superState":Landroid/os/Parcelable;
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v1

    .line 1281
    .local v1, "offset":I
    const/4 v2, 0x0

    .line 1281
    .local v2, "i":I
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v3

    .line 1281
    .local v3, "count":I
    :goto_0
    if-ge v2, v3, :cond_2

    .line 1282
    invoke-virtual {p2, v2}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 1283
    .local v4, "child":Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getBottom()I

    move-result v5

    add-int/2addr v5, v1

    .line 1285
    .local v5, "visBottom":I
    invoke-virtual {v4}, Landroid/view/View;->getTop()I

    move-result v6

    add-int/2addr v6, v1

    if-gtz v6, :cond_1

    if-ltz v5, :cond_1

    .line 1286
    new-instance v6, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;

    invoke-direct {v6, v0}, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;-><init>(Landroid/os/Parcelable;)V

    .line 1287
    .local v6, "ss":Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;
    iput v2, v6, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildIndex:I

    .line 1288
    nop

    .line 1289
    invoke-static {v4}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v7

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v8

    add-int/2addr v7, v8

    if-ne v5, v7, :cond_0

    const/4 v7, 0x1

    goto :goto_1

    :cond_0
    const/4 v7, 0x0

    :goto_1
    iput-boolean v7, v6, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildAtMinimumHeight:Z

    .line 1290
    int-to-float v7, v5

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v8

    int-to-float v8, v8

    div-float/2addr v7, v8

    iput v7, v6, Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;->firstVisibleChildPercentageShown:F

    .line 1291
    return-object v6

    .line 1281
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "visBottom":I
    .end local v6    # "ss":Landroid/support/design/widget/AppBarLayout$Behavior$SavedState;
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1296
    .end local v2    # "i":I
    .end local v3    # "count":I
    :cond_2
    return-object v0
.end method

.method public bridge synthetic onSaveInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)Landroid/os/Parcelable;
    .locals 0

    .line 787
    check-cast p2, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior;->onSaveInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)Landroid/os/Parcelable;

    move-result-object p1

    return-object p1
.end method

.method public onStartNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;Landroid/view/View;II)Z
    .locals 2
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "child"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "directTargetChild"    # Landroid/view/View;
    .param p4, "target"    # Landroid/view/View;
    .param p5, "nestedScrollAxes"    # I
    .param p6, "type"    # I

    .line 828
    and-int/lit8 v0, p5, 0x2

    if-eqz v0, :cond_0

    .line 829
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->hasScrollableChildren()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 830
    invoke-virtual {p1}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v0

    invoke-virtual {p3}, Landroid/view/View;->getHeight()I

    move-result v1

    sub-int/2addr v0, v1

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->getHeight()I

    move-result v1

    if-gt v0, v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 832
    .local v0, "started":Z
    :goto_0
    if-eqz v0, :cond_1

    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    if-eqz v1, :cond_1

    .line 834
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    .line 838
    :cond_1
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mLastNestedScrollingChildRef:Ljava/lang/ref/WeakReference;

    .line 840
    return v0
.end method

.method public bridge synthetic onStartNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;Landroid/view/View;II)Z
    .locals 7

    .line 787
    move-object v2, p2

    check-cast v2, Landroid/support/design/widget/AppBarLayout;

    move-object v0, p0

    move-object v1, p1

    move-object v3, p3

    move-object v4, p4

    move v5, p5

    move v6, p6

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/AppBarLayout$Behavior;->onStartNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;Landroid/view/View;II)Z

    move-result p1

    return p1
.end method

.method public onStopNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;I)V
    .locals 1
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "abl"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "target"    # Landroid/view/View;
    .param p4, "type"    # I

    .line 878
    if-nez p4, :cond_0

    .line 880
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/AppBarLayout$Behavior;->snapToChildIfNeeded(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;)V

    .line 884
    :cond_0
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p3}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mLastNestedScrollingChildRef:Ljava/lang/ref/WeakReference;

    .line 885
    return-void
.end method

.method public bridge synthetic onStopNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;I)V
    .locals 0

    .line 787
    check-cast p2, Landroid/support/design/widget/AppBarLayout;

    invoke-virtual {p0, p1, p2, p3, p4}, Landroid/support/design/widget/AppBarLayout$Behavior;->onStopNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;Landroid/view/View;I)V

    return-void
.end method

.method public setDragCallback(Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;)V
    .locals 0
    .param p1, "callback"    # Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 893
    iput-object p1, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOnDragCallback:Landroid/support/design/widget/AppBarLayout$Behavior$DragCallback;

    .line 894
    return-void
.end method

.method setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;III)I
    .locals 10
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p2, "appBarLayout"    # Landroid/support/design/widget/AppBarLayout;
    .param p3, "newOffset"    # I
    .param p4, "minOffset"    # I
    .param p5, "maxOffset"    # I

    .line 1113
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopBottomOffsetForScrollingSibling()I

    move-result v0

    .line 1114
    .local v0, "curOffset":I
    const/4 v1, 0x0

    .line 1116
    .local v1, "consumed":I
    if-eqz p4, :cond_3

    if-lt v0, p4, :cond_3

    if-gt v0, p5, :cond_3

    .line 1119
    invoke-static {p3, p4, p5}, Landroid/support/v4/math/MathUtils;->clamp(III)I

    move-result p3

    .line 1120
    if-eq v0, p3, :cond_4

    .line 1121
    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->hasChildWithInterpolator()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1122
    invoke-direct {p0, p2, p3}, Landroid/support/design/widget/AppBarLayout$Behavior;->interpolateOffset(Landroid/support/design/widget/AppBarLayout;I)I

    move-result v2

    goto :goto_0

    :cond_0
    move v2, p3

    :goto_0
    move v8, v2

    .line 1125
    .local v8, "interpolatedOffset":I
    invoke-virtual {p0, v8}, Landroid/support/design/widget/AppBarLayout$Behavior;->setTopAndBottomOffset(I)Z

    move-result v9

    .line 1128
    .local v9, "offsetChanged":Z
    sub-int v1, v0, p3

    .line 1130
    sub-int v2, p3, v8

    iput v2, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetDelta:I

    .line 1132
    if-nez v9, :cond_1

    invoke-virtual {p2}, Landroid/support/design/widget/AppBarLayout;->hasChildWithInterpolator()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1137
    invoke-virtual {p1, p2}, Landroid/support/design/widget/CoordinatorLayout;->dispatchDependentViewsChanged(Landroid/view/View;)V

    .line 1141
    :cond_1
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout$Behavior;->getTopAndBottomOffset()I

    move-result v2

    invoke-virtual {p2, v2}, Landroid/support/design/widget/AppBarLayout;->dispatchOffsetUpdates(I)V

    .line 1144
    if-ge p3, v0, :cond_2

    const/4 v2, -0x1

    :goto_1
    move v6, v2

    goto :goto_2

    :cond_2
    const/4 v2, 0x1

    goto :goto_1

    :goto_2
    const/4 v7, 0x0

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move v5, p3

    invoke-direct/range {v2 .. v7}, Landroid/support/design/widget/AppBarLayout$Behavior;->updateAppBarLayoutDrawableState(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;IIZ)V

    .line 1146
    .end local v8    # "interpolatedOffset":I
    .end local v9    # "offsetChanged":Z
    goto :goto_3

    .line 1149
    :cond_3
    const/4 v2, 0x0

    iput v2, p0, Landroid/support/design/widget/AppBarLayout$Behavior;->mOffsetDelta:I

    .line 1152
    :cond_4
    :goto_3
    return v1
.end method

.method bridge synthetic setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I
    .locals 6

    .line 787
    move-object v2, p2

    check-cast v2, Landroid/support/design/widget/AppBarLayout;

    move-object v0, p0

    move-object v1, p1

    move v3, p3

    move v4, p4

    move v5, p5

    invoke-virtual/range {v0 .. v5}, Landroid/support/design/widget/AppBarLayout$Behavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/support/design/widget/AppBarLayout;III)I

    move-result p1

    return p1
.end method

.method public bridge synthetic setLeftAndRightOffset(I)Z
    .locals 0

    .line 787
    invoke-super {p0, p1}, Landroid/support/design/widget/HeaderBehavior;->setLeftAndRightOffset(I)Z

    move-result p1

    return p1
.end method

.method public bridge synthetic setTopAndBottomOffset(I)Z
    .locals 0

    .line 787
    invoke-super {p0, p1}, Landroid/support/design/widget/HeaderBehavior;->setTopAndBottomOffset(I)Z

    move-result p1

    return p1
.end method
