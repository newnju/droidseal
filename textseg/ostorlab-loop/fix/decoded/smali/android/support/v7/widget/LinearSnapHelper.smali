.class public Landroid/support/v7/widget/LinearSnapHelper;
.super Landroid/support/v7/widget/SnapHelper;
.source "LinearSnapHelper.java"


# static fields
.field private static final INVALID_DISTANCE:F = 1.0f


# instance fields
.field private mHorizontalHelper:Landroid/support/v7/widget/OrientationHelper;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation
.end field

.field private mVerticalHelper:Landroid/support/v7/widget/OrientationHelper;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 32
    invoke-direct {p0}, Landroid/support/v7/widget/SnapHelper;-><init>()V

    return-void
.end method

.method private computeDistancePerChild(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;)F
    .locals 10
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
    .param p2, "helper"    # Landroid/support/v7/widget/OrientationHelper;

    .line 232
    const/4 v0, 0x0

    .line 233
    .local v0, "minPosView":Landroid/view/View;
    const/4 v1, 0x0

    .line 234
    .local v1, "maxPosView":Landroid/view/View;
    const v2, 0x7fffffff

    .line 235
    .local v2, "minPos":I
    const/high16 v3, -0x80000000

    .line 236
    .local v3, "maxPos":I
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getChildCount()I

    move-result v4

    .line 237
    .local v4, "childCount":I
    const/high16 v5, 0x3f800000    # 1.0f

    if-nez v4, :cond_0

    .line 238
    return v5

    .line 241
    :cond_0
    const/4 v6, 0x0

    .line 241
    .local v6, "i":I
    :goto_0
    if-ge v6, v4, :cond_4

    .line 242
    invoke-virtual {p1, v6}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v7

    .line 243
    .local v7, "child":Landroid/view/View;
    invoke-virtual {p1, v7}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getPosition(Landroid/view/View;)I

    move-result v8

    .line 244
    .local v8, "pos":I
    const/4 v9, -0x1

    if-ne v8, v9, :cond_1

    .line 245
    goto :goto_1

    .line 247
    :cond_1
    if-ge v8, v2, :cond_2

    .line 248
    move v2, v8

    .line 249
    move-object v0, v7

    .line 251
    :cond_2
    if-le v8, v3, :cond_3

    .line 252
    move v3, v8

    .line 253
    move-object v1, v7

    .line 241
    .end local v7    # "child":Landroid/view/View;
    .end local v8    # "pos":I
    :cond_3
    :goto_1
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 256
    .end local v6    # "i":I
    :cond_4
    if-eqz v0, :cond_7

    if-nez v1, :cond_5

    goto :goto_2

    .line 259
    :cond_5
    invoke-virtual {p2, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v6

    .line 260
    invoke-virtual {p2, v1}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v7

    .line 259
    invoke-static {v6, v7}, Ljava/lang/Math;->min(II)I

    move-result v6

    .line 261
    .local v6, "start":I
    invoke-virtual {p2, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v7

    .line 262
    invoke-virtual {p2, v1}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v8

    .line 261
    invoke-static {v7, v8}, Ljava/lang/Math;->max(II)I

    move-result v7

    .line 263
    .local v7, "end":I
    sub-int v8, v7, v6

    .line 264
    .local v8, "distance":I
    if-nez v8, :cond_6

    .line 265
    return v5

    .line 267
    :cond_6
    int-to-float v9, v8

    mul-float/2addr v9, v5

    sub-int v5, v3, v2

    add-int/lit8 v5, v5, 0x1

    int-to-float v5, v5

    div-float/2addr v9, v5

    return v9

    .line 257
    .end local v6    # "start":I
    .end local v7    # "end":I
    .end local v8    # "distance":I
    :cond_7
    :goto_2
    return v5
.end method

.method private distanceToCenter(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/view/View;Landroid/support/v7/widget/OrientationHelper;)I
    .locals 3
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "targetView"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p3, "helper"    # Landroid/support/v7/widget/OrientationHelper;

    .line 142
    invoke-virtual {p3, p2}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v0

    .line 143
    invoke-virtual {p3, p2}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v1

    div-int/lit8 v1, v1, 0x2

    add-int/2addr v0, v1

    .line 145
    .local v0, "childCenter":I
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getClipToPadding()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 146
    invoke-virtual {p3}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v1

    invoke-virtual {p3}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v2

    div-int/lit8 v2, v2, 0x2

    add-int/2addr v1, v2

    .line 146
    .local v1, "containerCenter":I
    goto :goto_0

    .line 148
    .end local v1    # "containerCenter":I
    :cond_0
    invoke-virtual {p3}, Landroid/support/v7/widget/OrientationHelper;->getEnd()I

    move-result v1

    div-int/lit8 v1, v1, 0x2

    .line 150
    .restart local v1    # "containerCenter":I
    :goto_0
    sub-int v2, v0, v1

    return v2
.end method

.method private estimateNextPositionDiffForFling(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;II)I
    .locals 6
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
    .param p2, "helper"    # Landroid/support/v7/widget/OrientationHelper;
    .param p3, "velocityX"    # I
    .param p4, "velocityY"    # I

    .line 166
    invoke-virtual {p0, p3, p4}, Landroid/support/v7/widget/LinearSnapHelper;->calculateScrollDistance(II)[I

    move-result-object v0

    .line 167
    .local v0, "distances":[I
    invoke-direct {p0, p1, p2}, Landroid/support/v7/widget/LinearSnapHelper;->computeDistancePerChild(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;)F

    move-result v1

    .line 168
    .local v1, "distancePerChild":F
    const/4 v2, 0x0

    cmpg-float v2, v1, v2

    const/4 v3, 0x0

    if-gtz v2, :cond_0

    .line 169
    return v3

    .line 171
    :cond_0
    aget v2, v0, v3

    .line 172
    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    const/4 v4, 0x1

    aget v5, v0, v4

    invoke-static {v5}, Ljava/lang/Math;->abs(I)I

    move-result v5

    if-le v2, v5, :cond_1

    aget v2, v0, v3

    goto :goto_0

    :cond_1
    aget v2, v0, v4

    .line 173
    .local v2, "distance":I
    :goto_0
    int-to-float v3, v2

    div-float/2addr v3, v1

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    return v3
.end method

.method private findCenterView(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;)Landroid/view/View;
    .locals 8
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
    .param p2, "helper"    # Landroid/support/v7/widget/OrientationHelper;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 188
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getChildCount()I

    move-result v0

    .line 189
    .local v0, "childCount":I
    if-nez v0, :cond_0

    .line 190
    const/4 v1, 0x0

    return-object v1

    .line 193
    :cond_0
    const/4 v1, 0x0

    .line 195
    .local v1, "closestChild":Landroid/view/View;
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getClipToPadding()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 196
    invoke-virtual {p2}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v2

    invoke-virtual {p2}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v3

    div-int/lit8 v3, v3, 0x2

    add-int/2addr v2, v3

    .line 196
    .local v2, "center":I
    goto :goto_0

    .line 198
    .end local v2    # "center":I
    :cond_1
    invoke-virtual {p2}, Landroid/support/v7/widget/OrientationHelper;->getEnd()I

    move-result v2

    div-int/lit8 v2, v2, 0x2

    .line 200
    .restart local v2    # "center":I
    :goto_0
    const v3, 0x7fffffff

    .line 202
    .local v3, "absClosest":I
    const/4 v4, 0x0

    .line 202
    .local v4, "i":I
    :goto_1
    if-ge v4, v0, :cond_3

    .line 203
    invoke-virtual {p1, v4}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 204
    .local v5, "child":Landroid/view/View;
    invoke-virtual {p2, v5}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v6

    .line 205
    invoke-virtual {p2, v5}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v7

    div-int/lit8 v7, v7, 0x2

    add-int/2addr v6, v7

    .line 206
    .local v6, "childCenter":I
    sub-int v7, v6, v2

    invoke-static {v7}, Ljava/lang/Math;->abs(I)I

    move-result v7

    .line 209
    .local v7, "absDistance":I
    if-ge v7, v3, :cond_2

    .line 210
    move v3, v7

    .line 211
    move-object v1, v5

    .line 202
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "childCenter":I
    .end local v7    # "absDistance":I
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 214
    .end local v4    # "i":I
    :cond_3
    return-object v1
.end method

.method private getHorizontalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;
    .locals 1
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .line 281
    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mHorizontalHelper:Landroid/support/v7/widget/OrientationHelper;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mHorizontalHelper:Landroid/support/v7/widget/OrientationHelper;

    iget-object v0, v0, Landroid/support/v7/widget/OrientationHelper;->mLayoutManager:Landroid/support/v7/widget/RecyclerView$LayoutManager;

    if-eq v0, p1, :cond_1

    .line 282
    :cond_0
    invoke-static {p1}, Landroid/support/v7/widget/OrientationHelper;->createHorizontalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mHorizontalHelper:Landroid/support/v7/widget/OrientationHelper;

    .line 284
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mHorizontalHelper:Landroid/support/v7/widget/OrientationHelper;

    return-object v0
.end method

.method private getVerticalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;
    .locals 1
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .line 272
    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mVerticalHelper:Landroid/support/v7/widget/OrientationHelper;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mVerticalHelper:Landroid/support/v7/widget/OrientationHelper;

    iget-object v0, v0, Landroid/support/v7/widget/OrientationHelper;->mLayoutManager:Landroid/support/v7/widget/RecyclerView$LayoutManager;

    if-eq v0, p1, :cond_1

    .line 273
    :cond_0
    invoke-static {p1}, Landroid/support/v7/widget/OrientationHelper;->createVerticalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mVerticalHelper:Landroid/support/v7/widget/OrientationHelper;

    .line 275
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/LinearSnapHelper;->mVerticalHelper:Landroid/support/v7/widget/OrientationHelper;

    return-object v0
.end method


# virtual methods
.method public calculateDistanceToFinalSnap(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/view/View;)[I
    .locals 4
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "targetView"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 45
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 46
    .local v0, "out":[I
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollHorizontally()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 47
    nop

    .line 48
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getHorizontalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v1

    .line 47
    invoke-direct {p0, p1, p2, v1}, Landroid/support/v7/widget/LinearSnapHelper;->distanceToCenter(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/view/View;Landroid/support/v7/widget/OrientationHelper;)I

    move-result v1

    aput v1, v0, v2

    goto :goto_0

    .line 50
    :cond_0
    aput v2, v0, v2

    .line 53
    :goto_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollVertically()Z

    move-result v1

    const/4 v3, 0x1

    if-eqz v1, :cond_1

    .line 54
    nop

    .line 55
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getVerticalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v1

    .line 54
    invoke-direct {p0, p1, p2, v1}, Landroid/support/v7/widget/LinearSnapHelper;->distanceToCenter(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/view/View;Landroid/support/v7/widget/OrientationHelper;)I

    move-result v1

    aput v1, v0, v3

    goto :goto_1

    .line 57
    :cond_1
    aput v2, v0, v3

    .line 59
    :goto_1
    return-object v0
.end method

.method public findSnapView(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/view/View;
    .locals 1
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;

    .line 132
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollVertically()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 133
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getVerticalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/LinearSnapHelper;->findCenterView(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;)Landroid/view/View;

    move-result-object v0

    return-object v0

    .line 134
    :cond_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollHorizontally()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 135
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getHorizontalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/LinearSnapHelper;->findCenterView(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;)Landroid/view/View;

    move-result-object v0

    return-object v0

    .line 137
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method public findTargetSnapPosition(Landroid/support/v7/widget/RecyclerView$LayoutManager;II)I
    .locals 10
    .param p1, "layoutManager"    # Landroid/support/v7/widget/RecyclerView$LayoutManager;
    .param p2, "velocityX"    # I
    .param p3, "velocityY"    # I

    .line 65
    instance-of v0, p1, Landroid/support/v7/widget/RecyclerView$SmoothScroller$ScrollVectorProvider;

    const/4 v1, -0x1

    if-nez v0, :cond_0

    .line 66
    return v1

    .line 69
    :cond_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getItemCount()I

    move-result v0

    .line 70
    .local v0, "itemCount":I
    if-nez v0, :cond_1

    .line 71
    return v1

    .line 74
    :cond_1
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->findSnapView(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/view/View;

    move-result-object v2

    .line 75
    .local v2, "currentView":Landroid/view/View;
    if-nez v2, :cond_2

    .line 76
    return v1

    .line 79
    :cond_2
    invoke-virtual {p1, v2}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getPosition(Landroid/view/View;)I

    move-result v3

    .line 80
    .local v3, "currentPosition":I
    if-ne v3, v1, :cond_3

    .line 81
    return v1

    .line 84
    :cond_3
    move-object v4, p1

    check-cast v4, Landroid/support/v7/widget/RecyclerView$SmoothScroller$ScrollVectorProvider;

    .line 89
    .local v4, "vectorProvider":Landroid/support/v7/widget/RecyclerView$SmoothScroller$ScrollVectorProvider;
    add-int/lit8 v5, v0, -0x1

    invoke-interface {v4, v5}, Landroid/support/v7/widget/RecyclerView$SmoothScroller$ScrollVectorProvider;->computeScrollVectorForPosition(I)Landroid/graphics/PointF;

    move-result-object v5

    .line 90
    .local v5, "vectorForEnd":Landroid/graphics/PointF;
    if-nez v5, :cond_4

    .line 92
    return v1

    .line 96
    :cond_4
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollHorizontally()Z

    move-result v6

    const/4 v7, 0x0

    const/4 v8, 0x0

    if-eqz v6, :cond_5

    .line 97
    nop

    .line 98
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getHorizontalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v6

    .line 97
    invoke-direct {p0, p1, v6, p2, v8}, Landroid/support/v7/widget/LinearSnapHelper;->estimateNextPositionDiffForFling(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;II)I

    move-result v6

    .line 99
    .local v6, "hDeltaJump":I
    iget v9, v5, Landroid/graphics/PointF;->x:F

    cmpg-float v9, v9, v7

    if-gez v9, :cond_6

    .line 100
    neg-int v6, v6

    goto :goto_0

    .line 103
    .end local v6    # "hDeltaJump":I
    :cond_5
    move v6, v8

    .line 105
    .restart local v6    # "hDeltaJump":I
    :cond_6
    :goto_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollVertically()Z

    move-result v9

    if-eqz v9, :cond_7

    .line 106
    nop

    .line 107
    invoke-direct {p0, p1}, Landroid/support/v7/widget/LinearSnapHelper;->getVerticalHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v9

    .line 106
    invoke-direct {p0, p1, v9, v8, p3}, Landroid/support/v7/widget/LinearSnapHelper;->estimateNextPositionDiffForFling(Landroid/support/v7/widget/RecyclerView$LayoutManager;Landroid/support/v7/widget/OrientationHelper;II)I

    move-result v8

    .line 108
    .local v8, "vDeltaJump":I
    iget v9, v5, Landroid/graphics/PointF;->y:F

    cmpg-float v7, v9, v7

    if-gez v7, :cond_8

    .line 109
    neg-int v8, v8

    goto :goto_1

    .line 112
    .end local v8    # "vDeltaJump":I
    :cond_7
    nop

    .line 112
    .restart local v8    # "vDeltaJump":I
    :cond_8
    :goto_1
    move v7, v8

    .line 115
    .end local v8    # "vDeltaJump":I
    .local v7, "vDeltaJump":I
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->canScrollVertically()Z

    move-result v8

    if-eqz v8, :cond_9

    move v8, v7

    goto :goto_2

    :cond_9
    move v8, v6

    .line 116
    .local v8, "deltaJump":I
    :goto_2
    if-nez v8, :cond_a

    .line 117
    return v1

    .line 120
    :cond_a
    add-int v1, v3, v8

    .line 121
    .local v1, "targetPos":I
    if-gez v1, :cond_b

    .line 122
    const/4 v1, 0x0

    .line 124
    :cond_b
    if-lt v1, v0, :cond_c

    .line 125
    add-int/lit8 v1, v0, -0x1

    .line 127
    :cond_c
    return v1
.end method
