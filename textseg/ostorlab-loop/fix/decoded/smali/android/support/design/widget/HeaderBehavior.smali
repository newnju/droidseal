.class abstract Landroid/support/design/widget/HeaderBehavior;
.super Landroid/support/design/widget/ViewOffsetBehavior;
.source "HeaderBehavior.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/design/widget/HeaderBehavior$FlingRunnable;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<V:",
        "Landroid/view/View;",
        ">",
        "Landroid/support/design/widget/ViewOffsetBehavior<",
        "TV;>;"
    }
.end annotation


# static fields
.field private static final INVALID_POINTER:I = -0x1


# instance fields
.field private mActivePointerId:I

.field private mFlingRunnable:Ljava/lang/Runnable;

.field private mIsBeingDragged:Z

.field private mLastMotionY:I

.field mScroller:Landroid/widget/OverScroller;

.field private mTouchSlop:I

.field private mVelocityTracker:Landroid/view/VelocityTracker;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 47
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    invoke-direct {p0}, Landroid/support/design/widget/ViewOffsetBehavior;-><init>()V

    .line 42
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 44
    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    .line 47
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 50
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/ViewOffsetBehavior;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 42
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 44
    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    .line 51
    return-void
.end method

.method private ensureVelocityTracker()V
    .locals 1

    .line 280
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v0, :cond_0

    .line 281
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v0

    iput-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 283
    :cond_0
    return-void
.end method


# virtual methods
.method canDragView(Landroid/view/View;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TV;)Z"
        }
    .end annotation

    .line 265
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p1, "view":Landroid/view/View;, "TV;"
    const/4 v0, 0x0

    return v0
.end method

.method final fling(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;IIF)Z
    .locals 13
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "minOffset"    # I
    .param p4, "maxOffset"    # I
    .param p5, "velocityY"    # F
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;IIF)Z"
        }
    .end annotation

    .line 228
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "layout":Landroid/view/View;, "TV;"
    move-object v0, p0

    move-object v1, p2

    .line 228
    iget-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mFlingRunnable:Ljava/lang/Runnable;

    if-eqz v2, :cond_0

    .line 229
    iget-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mFlingRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 230
    const/4 v2, 0x0

    iput-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mFlingRunnable:Ljava/lang/Runnable;

    .line 233
    :cond_0
    iget-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mScroller:Landroid/widget/OverScroller;

    if-nez v2, :cond_1

    .line 234
    new-instance v2, Landroid/widget/OverScroller;

    invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/widget/OverScroller;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mScroller:Landroid/widget/OverScroller;

    .line 237
    :cond_1
    iget-object v4, v0, Landroid/support/design/widget/HeaderBehavior;->mScroller:Landroid/widget/OverScroller;

    const/4 v5, 0x0

    .line 238
    invoke-virtual {v0}, Landroid/support/design/widget/HeaderBehavior;->getTopAndBottomOffset()I

    move-result v6

    const/4 v7, 0x0

    .line 239
    invoke-static/range {p5 .. p5}, Ljava/lang/Math;->round(F)I

    move-result v8

    const/4 v9, 0x0

    const/4 v10, 0x0

    .line 237
    move/from16 v11, p3

    move/from16 v12, p4

    invoke-virtual/range {v4 .. v12}, Landroid/widget/OverScroller;->fling(IIIIIIII)V

    .line 243
    iget-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mScroller:Landroid/widget/OverScroller;

    invoke-virtual {v2}, Landroid/widget/OverScroller;->computeScrollOffset()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 244
    new-instance v2, Landroid/support/design/widget/HeaderBehavior$FlingRunnable;

    move-object v3, p1

    invoke-direct {v2, v0, v3, v1}, Landroid/support/design/widget/HeaderBehavior$FlingRunnable;-><init>(Landroid/support/design/widget/HeaderBehavior;Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)V

    iput-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mFlingRunnable:Ljava/lang/Runnable;

    .line 245
    iget-object v2, v0, Landroid/support/design/widget/HeaderBehavior;->mFlingRunnable:Ljava/lang/Runnable;

    invoke-static {v1, v2}, Landroid/support/v4/view/ViewCompat;->postOnAnimation(Landroid/view/View;Ljava/lang/Runnable;)V

    .line 246
    const/4 v2, 0x1

    return v2

    .line 248
    :cond_2
    move-object v3, p1

    invoke-virtual {v0, v3, v1}, Landroid/support/design/widget/HeaderBehavior;->onFlingFinished(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)V

    .line 249
    const/4 v2, 0x0

    return v2
.end method

.method getMaxDragOffset(Landroid/view/View;)I
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TV;)I"
        }
    .end annotation

    .line 272
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p1, "view":Landroid/view/View;, "TV;"
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v0

    neg-int v0, v0

    return v0
.end method

.method getScrollRangeForDragFling(Landroid/view/View;)I
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TV;)I"
        }
    .end annotation

    .line 276
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p1, "view":Landroid/view/View;, "TV;"
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v0

    return v0
.end method

.method getTopBottomOffsetForScrollingSibling()I
    .locals 1

    .line 217
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    invoke-virtual {p0}, Landroid/support/design/widget/HeaderBehavior;->getTopAndBottomOffset()I

    move-result v0

    return v0
.end method

.method onFlingFinished(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)V
    .locals 0
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;)V"
        }
    .end annotation

    .line 259
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "layout":Landroid/view/View;, "TV;"
    return-void
.end method

.method public onInterceptTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 7
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "ev"    # Landroid/view/MotionEvent;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;",
            "Landroid/view/MotionEvent;",
            ")Z"
        }
    .end annotation

    .line 55
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "child":Landroid/view/View;, "TV;"
    iget v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    if-gez v0, :cond_0

    .line 56
    invoke-virtual {p1}, Landroid/support/design/widget/CoordinatorLayout;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v0

    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    .line 59
    :cond_0
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    .line 62
    .local v0, "action":I
    const/4 v1, 0x2

    const/4 v2, 0x1

    if-ne v0, v1, :cond_1

    iget-boolean v1, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    if-eqz v1, :cond_1

    .line 63
    return v2

    .line 66
    :cond_1
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    const/4 v3, 0x0

    const/4 v4, -0x1

    packed-switch v1, :pswitch_data_0

    goto :goto_0

    .line 80
    :pswitch_0
    iget v1, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 81
    .local v1, "activePointerId":I
    if-ne v1, v4, :cond_2

    .line 83
    goto :goto_0

    .line 85
    :cond_2
    invoke-virtual {p3, v1}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v3

    .line 86
    .local v3, "pointerIndex":I
    if-ne v3, v4, :cond_3

    .line 87
    goto :goto_0

    .line 90
    :cond_3
    invoke-virtual {p3, v3}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    float-to-int v4, v4

    .line 91
    .local v4, "y":I
    iget v5, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    sub-int v5, v4, v5

    invoke-static {v5}, Ljava/lang/Math;->abs(I)I

    move-result v5

    .line 92
    .local v5, "yDiff":I
    iget v6, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    if-le v5, v6, :cond_4

    .line 93
    iput-boolean v2, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    .line 94
    iput v4, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    goto :goto_0

    .line 101
    .end local v1    # "activePointerId":I
    .end local v3    # "pointerIndex":I
    .end local v4    # "y":I
    .end local v5    # "yDiff":I
    :pswitch_1
    iput-boolean v3, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    .line 102
    iput v4, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 103
    iget-object v1, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v1, :cond_4

    .line 104
    iget-object v1, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v1}, Landroid/view/VelocityTracker;->recycle()V

    .line 105
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    goto :goto_0

    .line 68
    :pswitch_2
    iput-boolean v3, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    .line 69
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    float-to-int v1, v1

    .line 70
    .local v1, "x":I
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getY()F

    move-result v2

    float-to-int v2, v2

    .line 71
    .local v2, "y":I
    invoke-virtual {p0, p2}, Landroid/support/design/widget/HeaderBehavior;->canDragView(Landroid/view/View;)Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-virtual {p1, p2, v1, v2}, Landroid/support/design/widget/CoordinatorLayout;->isPointInChildBounds(Landroid/view/View;II)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 72
    iput v2, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    .line 73
    invoke-virtual {p3, v3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 74
    invoke-direct {p0}, Landroid/support/design/widget/HeaderBehavior;->ensureVelocityTracker()V

    .line 111
    .end local v1    # "x":I
    .end local v2    # "y":I
    :cond_4
    :goto_0
    iget-object v1, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v1, :cond_5

    .line 112
    iget-object v1, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v1, p3}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 115
    :cond_5
    iget-boolean v1, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    return v1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public onTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 11
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "ev"    # Landroid/view/MotionEvent;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;",
            "Landroid/view/MotionEvent;",
            ")Z"
        }
    .end annotation

    .line 120
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "child":Landroid/view/View;, "TV;"
    iget v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    if-gez v0, :cond_0

    .line 121
    invoke-virtual {p1}, Landroid/support/design/widget/CoordinatorLayout;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v0

    iput v0, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    .line 124
    :cond_0
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, -0x1

    const/4 v3, 0x0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_1

    .line 140
    :pswitch_0
    iget v0, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    invoke-virtual {p3, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    .line 141
    .local v0, "activePointerIndex":I
    if-ne v0, v2, :cond_1

    .line 142
    return v3

    .line 145
    :cond_1
    invoke-virtual {p3, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result v2

    float-to-int v2, v2

    .line 146
    .local v2, "y":I
    iget v3, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    sub-int/2addr v3, v2

    .line 148
    .local v3, "dy":I
    iget-boolean v4, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    if-nez v4, :cond_3

    invoke-static {v3}, Ljava/lang/Math;->abs(I)I

    move-result v4

    iget v5, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    if-le v4, v5, :cond_3

    .line 149
    iput-boolean v1, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    .line 150
    if-lez v3, :cond_2

    .line 151
    iget v4, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    sub-int/2addr v3, v4

    goto :goto_0

    .line 153
    :cond_2
    iget v4, p0, Landroid/support/design/widget/HeaderBehavior;->mTouchSlop:I

    add-int/2addr v3, v4

    .line 157
    :cond_3
    :goto_0
    iget-boolean v4, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    if-eqz v4, :cond_6

    .line 158
    iput v2, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    .line 160
    invoke-virtual {p0, p2}, Landroid/support/design/widget/HeaderBehavior;->getMaxDragOffset(Landroid/view/View;)I

    move-result v8

    const/4 v9, 0x0

    move-object v4, p0

    move-object v5, p1

    move-object v6, p2

    move v7, v3

    invoke-virtual/range {v4 .. v9}, Landroid/support/design/widget/HeaderBehavior;->scroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I

    goto :goto_1

    .line 166
    .end local v0    # "activePointerIndex":I
    .end local v2    # "y":I
    .end local v3    # "dy":I
    :pswitch_1
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v0, :cond_4

    .line 167
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p3}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 168
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    const/16 v4, 0x3e8

    invoke-virtual {v0, v4}, Landroid/view/VelocityTracker;->computeCurrentVelocity(I)V

    .line 169
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    iget v4, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    invoke-virtual {v0, v4}, Landroid/view/VelocityTracker;->getYVelocity(I)F

    move-result v0

    .line 170
    .local v0, "yvel":F
    invoke-virtual {p0, p2}, Landroid/support/design/widget/HeaderBehavior;->getScrollRangeForDragFling(Landroid/view/View;)I

    move-result v4

    neg-int v8, v4

    const/4 v9, 0x0

    move-object v5, p0

    move-object v6, p1

    move-object v7, p2

    move v10, v0

    invoke-virtual/range {v5 .. v10}, Landroid/support/design/widget/HeaderBehavior;->fling(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;IIF)Z

    .line 174
    .end local v0    # "yvel":F
    :cond_4
    :pswitch_2
    iput-boolean v3, p0, Landroid/support/design/widget/HeaderBehavior;->mIsBeingDragged:Z

    .line 175
    iput v2, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 176
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v0, :cond_6

    .line 177
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->recycle()V

    .line 178
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    goto :goto_1

    .line 126
    :pswitch_3
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    float-to-int v0, v0

    .line 127
    .local v0, "x":I
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getY()F

    move-result v2

    float-to-int v2, v2

    .line 129
    .restart local v2    # "y":I
    invoke-virtual {p1, p2, v0, v2}, Landroid/support/design/widget/CoordinatorLayout;->isPointInChildBounds(Landroid/view/View;II)Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-virtual {p0, p2}, Landroid/support/design/widget/HeaderBehavior;->canDragView(Landroid/view/View;)Z

    move-result v4

    if-eqz v4, :cond_5

    .line 130
    iput v2, p0, Landroid/support/design/widget/HeaderBehavior;->mLastMotionY:I

    .line 131
    invoke-virtual {p3, v3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/widget/HeaderBehavior;->mActivePointerId:I

    .line 132
    invoke-direct {p0}, Landroid/support/design/widget/HeaderBehavior;->ensureVelocityTracker()V

    goto :goto_1

    .line 134
    :cond_5
    return v3

    .line 184
    .end local v0    # "x":I
    .end local v2    # "y":I
    :cond_6
    :goto_1
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v0, :cond_7

    .line 185
    iget-object v0, p0, Landroid/support/design/widget/HeaderBehavior;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p3}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 188
    :cond_7
    return v1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_1
        :pswitch_0
        :pswitch_2
    .end packed-switch
.end method

.method final scroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I
    .locals 7
    .param p1, "coordinatorLayout"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "dy"    # I
    .param p4, "minOffset"    # I
    .param p5, "maxOffset"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;III)I"
        }
    .end annotation

    .line 222
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "header":Landroid/view/View;, "TV;"
    nop

    .line 223
    invoke-virtual {p0}, Landroid/support/design/widget/HeaderBehavior;->getTopBottomOffsetForScrollingSibling()I

    move-result v0

    sub-int v4, v0, p3

    .line 222
    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    move v5, p4

    move v6, p5

    invoke-virtual/range {v1 .. v6}, Landroid/support/design/widget/HeaderBehavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I

    move-result v0

    return v0
.end method

.method setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)I
    .locals 6
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "newOffset"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;I)I"
        }
    .end annotation

    .line 192
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "header":Landroid/view/View;, "TV;"
    const/high16 v4, -0x80000000

    const v5, 0x7fffffff

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    invoke-virtual/range {v0 .. v5}, Landroid/support/design/widget/HeaderBehavior;->setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I

    move-result v0

    return v0
.end method

.method setHeaderTopBottomOffset(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;III)I
    .locals 2
    .param p1, "parent"    # Landroid/support/design/widget/CoordinatorLayout;
    .param p3, "newOffset"    # I
    .param p4, "minOffset"    # I
    .param p5, "maxOffset"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/design/widget/CoordinatorLayout;",
            "TV;III)I"
        }
    .end annotation

    .line 198
    .local p0, "this":Landroid/support/design/widget/HeaderBehavior;, "Landroid/support/design/widget/HeaderBehavior<TV;>;"
    .local p2, "header":Landroid/view/View;, "TV;"
    invoke-virtual {p0}, Landroid/support/design/widget/HeaderBehavior;->getTopAndBottomOffset()I

    move-result v0

    .line 199
    .local v0, "curOffset":I
    const/4 v1, 0x0

    .line 201
    .local v1, "consumed":I
    if-eqz p4, :cond_0

    if-lt v0, p4, :cond_0

    if-gt v0, p5, :cond_0

    .line 204
    invoke-static {p3, p4, p5}, Landroid/support/v4/math/MathUtils;->clamp(III)I

    move-result p3

    .line 206
    if-eq v0, p3, :cond_0

    .line 207
    invoke-virtual {p0, p3}, Landroid/support/design/widget/HeaderBehavior;->setTopAndBottomOffset(I)Z

    .line 209
    sub-int v1, v0, p3

    .line 213
    :cond_0
    return v1
.end method
