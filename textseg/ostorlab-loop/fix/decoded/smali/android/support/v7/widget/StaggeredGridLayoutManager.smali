.class public Landroid/support/v7/widget/StaggeredGridLayoutManager;
.super Landroid/support/v7/widget/RecyclerView$LayoutManager;
.source "StaggeredGridLayoutManager.java"

# interfaces
.implements Landroid/support/v7/widget/RecyclerView$SmoothScroller$ScrollVectorProvider;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;,
        Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;,
        Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;,
        Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;,
        Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    }
.end annotation


# static fields
.field static final DEBUG:Z = false

.field public static final GAP_HANDLING_LAZY:I = 0x1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final GAP_HANDLING_MOVE_ITEMS_BETWEEN_SPANS:I = 0x2

.field public static final GAP_HANDLING_NONE:I = 0x0

.field public static final HORIZONTAL:I = 0x0

.field static final INVALID_OFFSET:I = -0x80000000

.field private static final MAX_SCROLL_FACTOR:F = 0.33333334f

.field private static final TAG:Ljava/lang/String; = "StaggeredGridLManager"

.field public static final VERTICAL:I = 0x1


# instance fields
.field private final mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

.field private final mCheckForGapsRunnable:Ljava/lang/Runnable;

.field private mFullSizeSpec:I

.field private mGapStrategy:I

.field private mLaidOutInvalidFullSpan:Z

.field private mLastLayoutFromEnd:Z

.field private mLastLayoutRTL:Z

.field private final mLayoutState:Landroid/support/v7/widget/LayoutState;
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation
.end field

.field mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

.field private mOrientation:I

.field private mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

.field mPendingScrollPosition:I

.field mPendingScrollPositionOffset:I

.field private mPrefetchDistances:[I

.field mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation
.end field

.field private mRemainingSpans:Ljava/util/BitSet;

.field mReverseLayout:Z

.field mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation
.end field

.field mShouldReverseLayout:Z

.field private mSizePerSpan:I

.field private mSmoothScrollbarEnabled:Z

.field private mSpanCount:I

.field mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

.field private final mTmpRect:Landroid/graphics/Rect;


# direct methods
.method public constructor <init>(II)V
    .locals 3
    .param p1, "spanCount"    # I
    .param p2, "orientation"    # I

    .line 249
    invoke-direct {p0}, Landroid/support/v7/widget/RecyclerView$LayoutManager;-><init>()V

    .line 110
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    .line 133
    const/4 v1, 0x0

    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    .line 138
    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    .line 149
    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 155
    const/high16 v0, -0x80000000

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 161
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-direct {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    .line 166
    const/4 v0, 0x2

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    .line 192
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    .line 197
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    invoke-direct {v0, p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager;)V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 205
    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    .line 211
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 219
    new-instance v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$1;

    invoke-direct {v2, p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$1;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager;)V

    iput-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mCheckForGapsRunnable:Ljava/lang/Runnable;

    .line 250
    iput p2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    .line 251
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setSpanCount(I)V

    .line 252
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-eqz v2, :cond_0

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setAutoMeasureEnabled(Z)V

    .line 253
    new-instance v0, Landroid/support/v7/widget/LayoutState;

    invoke-direct {v0}, Landroid/support/v7/widget/LayoutState;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    .line 254
    invoke-direct {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->createOrientationHelpers()V

    .line 255
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;II)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I
    .param p4, "defStyleRes"    # I

    .line 232
    invoke-direct {p0}, Landroid/support/v7/widget/RecyclerView$LayoutManager;-><init>()V

    .line 110
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    .line 133
    const/4 v1, 0x0

    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    .line 138
    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    .line 149
    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 155
    const/high16 v0, -0x80000000

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 161
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-direct {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    .line 166
    const/4 v0, 0x2

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    .line 192
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    .line 197
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    invoke-direct {v0, p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager;)V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 205
    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    .line 211
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 219
    new-instance v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$1;

    invoke-direct {v2, p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$1;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager;)V

    iput-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mCheckForGapsRunnable:Ljava/lang/Runnable;

    .line 233
    invoke-static {p1, p2, p3, p4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getProperties(Landroid/content/Context;Landroid/util/AttributeSet;II)Landroid/support/v7/widget/RecyclerView$LayoutManager$Properties;

    move-result-object v2

    .line 234
    .local v2, "properties":Landroid/support/v7/widget/RecyclerView$LayoutManager$Properties;
    iget v3, v2, Landroid/support/v7/widget/RecyclerView$LayoutManager$Properties;->orientation:I

    invoke-virtual {p0, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setOrientation(I)V

    .line 235
    iget v3, v2, Landroid/support/v7/widget/RecyclerView$LayoutManager$Properties;->spanCount:I

    invoke-virtual {p0, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setSpanCount(I)V

    .line 236
    iget-boolean v3, v2, Landroid/support/v7/widget/RecyclerView$LayoutManager$Properties;->reverseLayout:Z

    invoke-virtual {p0, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setReverseLayout(Z)V

    .line 237
    iget v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-eqz v3, :cond_0

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setAutoMeasureEnabled(Z)V

    .line 238
    new-instance v0, Landroid/support/v7/widget/LayoutState;

    invoke-direct {v0}, Landroid/support/v7/widget/LayoutState;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    .line 239
    invoke-direct {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->createOrientationHelpers()V

    .line 240
    return-void
.end method

.method private appendViewToAllSpans(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 1769
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    add-int/lit8 v0, v0, -0x1

    .line 1769
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_0

    .line 1770
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->appendToSpan(Landroid/view/View;)V

    .line 1769
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 1772
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method private applyPendingSavedState(Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)V
    .locals 3
    .param p1, "anchorInfo"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 785
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    if-lez v0, :cond_3

    .line 786
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ne v0, v1, :cond_2

    .line 787
    const/4 v0, 0x0

    .line 787
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_3

    .line 788
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->clear()V

    .line 789
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsets:[I

    aget v1, v1, v0

    .line 790
    .local v1, "line":I
    const/high16 v2, -0x80000000

    if-eq v1, v2, :cond_1

    .line 791
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-boolean v2, v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorLayoutFromEnd:Z

    if-eqz v2, :cond_0

    .line 792
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v2

    add-int/2addr v1, v2

    goto :goto_1

    .line 794
    :cond_0
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v2

    add-int/2addr v1, v2

    .line 797
    :cond_1
    :goto_1
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v0

    invoke-virtual {v2, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->setLine(I)V

    .line 787
    .end local v1    # "line":I
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 800
    .end local v0    # "i":I
    :cond_2
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->invalidateSpanInfo()V

    .line 801
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mVisibleAnchorPosition:I

    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    .line 804
    :cond_3
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-boolean v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mLastLayoutRTL:Z

    iput-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutRTL:Z

    .line 805
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-boolean v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mReverseLayout:Z

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setReverseLayout(Z)V

    .line 806
    invoke-direct {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->resolveShouldLayoutReverse()V

    .line 808
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_4

    .line 809
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 810
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-boolean v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorLayoutFromEnd:Z

    iput-boolean v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    goto :goto_2

    .line 812
    :cond_4
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    iput-boolean v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    .line 814
    :goto_2
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookupSize:I

    const/4 v1, 0x1

    if-le v0, v1, :cond_5

    .line 815
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookup:[I

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    .line 816
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mFullSpanItems:Ljava/util/List;

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    .line 818
    :cond_5
    return-void
.end method

.method private attachViewToSpans(Landroid/view/View;Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;Landroid/support/v7/widget/LayoutState;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .param p2, "lp"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .param p3, "layoutState"    # Landroid/support/v7/widget/LayoutState;

    .line 1713
    iget v0, p3, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    .line 1714
    iget-boolean v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_0

    .line 1715
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->appendViewToAllSpans(Landroid/view/View;)V

    goto :goto_0

    .line 1717
    :cond_0
    iget-object v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->appendToSpan(Landroid/view/View;)V

    goto :goto_0

    .line 1720
    :cond_1
    iget-boolean v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_2

    .line 1721
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->prependViewToAllSpans(Landroid/view/View;)V

    goto :goto_0

    .line 1723
    :cond_2
    iget-object v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->prependToSpan(Landroid/view/View;)V

    .line 1726
    :goto_0
    return-void
.end method

.method private calculateScrollDirectionForPosition(I)I
    .locals 5
    .param p1, "position"    # I

    .line 2006
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    const/4 v1, -0x1

    const/4 v2, 0x1

    if-nez v0, :cond_1

    .line 2007
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v0, :cond_0

    move v1, v2

    nop

    :cond_0
    return v1

    .line 2009
    :cond_1
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v0

    .line 2010
    .local v0, "firstChildPos":I
    if-ge p1, v0, :cond_2

    move v3, v2

    goto :goto_0

    :cond_2
    const/4 v3, 0x0

    :goto_0
    iget-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eq v3, v4, :cond_3

    goto :goto_1

    :cond_3
    move v1, v2

    :goto_1
    return v1
.end method

.method private checkSpanForGap(Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;)Z
    .locals 3
    .param p1, "span"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    .line 401
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 402
    invoke-virtual {p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine()I

    move-result v0

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v2

    if-ge v0, v2, :cond_1

    .line 404
    iget-object v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    iget-object v1, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 405
    .local v0, "endView":Landroid/view/View;
    invoke-virtual {p1, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getLayoutParams(Landroid/view/View;)Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    move-result-object v1

    .line 406
    .local v1, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v2, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    xor-int/lit8 v2, v2, 0x1

    return v2

    .line 408
    .end local v0    # "endView":Landroid/view/View;
    .end local v1    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    :cond_0
    invoke-virtual {p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine()I

    move-result v0

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v2

    if-le v0, v2, :cond_1

    .line 410
    iget-object v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 411
    .local v0, "startView":Landroid/view/View;
    invoke-virtual {p1, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getLayoutParams(Landroid/view/View;)Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    move-result-object v1

    .line 412
    .restart local v1    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v2, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    xor-int/lit8 v2, v2, 0x1

    return v2

    .line 414
    .end local v0    # "startView":Landroid/view/View;
    .end local v1    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    :cond_1
    return v1
.end method

.method private computeScrollExtent(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 7
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1091
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    if-nez v0, :cond_0

    .line 1092
    const/4 v0, 0x0

    return v0

    .line 1094
    :cond_0
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1095
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToStart(Z)Landroid/view/View;

    move-result-object v3

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1096
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;

    move-result-object v4

    iget-boolean v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1094
    move-object v1, p1

    move-object v5, p0

    invoke-static/range {v1 .. v6}, Landroid/support/v7/widget/ScrollbarHelper;->computeScrollExtent(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/OrientationHelper;Landroid/view/View;Landroid/view/View;Landroid/support/v7/widget/RecyclerView$LayoutManager;Z)I

    move-result v0

    return v0
.end method

.method private computeScrollOffset(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 8
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1071
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    if-nez v0, :cond_0

    .line 1072
    const/4 v0, 0x0

    return v0

    .line 1074
    :cond_0
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1075
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToStart(Z)Landroid/view/View;

    move-result-object v3

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1076
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;

    move-result-object v4

    iget-boolean v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    iget-boolean v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    .line 1074
    move-object v1, p1

    move-object v5, p0

    invoke-static/range {v1 .. v7}, Landroid/support/v7/widget/ScrollbarHelper;->computeScrollOffset(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/OrientationHelper;Landroid/view/View;Landroid/view/View;Landroid/support/v7/widget/RecyclerView$LayoutManager;ZZ)I

    move-result v0

    return v0
.end method

.method private computeScrollRange(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 7
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1111
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    if-nez v0, :cond_0

    .line 1112
    const/4 v0, 0x0

    return v0

    .line 1114
    :cond_0
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1115
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToStart(Z)Landroid/view/View;

    move-result-object v3

    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1116
    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;

    move-result-object v4

    iget-boolean v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSmoothScrollbarEnabled:Z

    .line 1114
    move-object v1, p1

    move-object v5, p0

    invoke-static/range {v1 .. v6}, Landroid/support/v7/widget/ScrollbarHelper;->computeScrollRange(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/OrientationHelper;Landroid/view/View;Landroid/view/View;Landroid/support/v7/widget/RecyclerView$LayoutManager;Z)I

    move-result v0

    return v0
.end method

.method private convertFocusDirectionToLayoutDirection(I)I
    .locals 4
    .param p1, "focusDirection"    # I

    .line 2354
    const/16 v0, 0x11

    const/4 v1, -0x1

    const/high16 v2, -0x80000000

    if-eq p1, v0, :cond_a

    const/16 v0, 0x21

    const/4 v3, 0x1

    if-eq p1, v0, :cond_8

    const/16 v0, 0x42

    if-eq p1, v0, :cond_6

    const/16 v0, 0x82

    if-eq p1, v0, :cond_4

    packed-switch p1, :pswitch_data_0

    .line 2387
    return v2

    .line 2364
    :pswitch_0
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v3, :cond_0

    .line 2365
    return v3

    .line 2366
    :cond_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2367
    return v1

    .line 2369
    :cond_1
    return v3

    .line 2356
    :pswitch_1
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v3, :cond_2

    .line 2357
    return v1

    .line 2358
    :cond_2
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 2359
    return v3

    .line 2361
    :cond_3
    return v1

    .line 2375
    :cond_4
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v3, :cond_5

    move v2, v3

    nop

    :cond_5
    return v2

    .line 2381
    :cond_6
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-nez v0, :cond_7

    move v2, v3

    nop

    :cond_7
    return v2

    .line 2372
    :cond_8
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v3, :cond_9

    goto :goto_0

    :cond_9
    move v1, v2

    :goto_0
    return v1

    .line 2378
    :cond_a
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-nez v0, :cond_b

    goto :goto_1

    :cond_b
    move v1, v2

    :goto_1
    return v1

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private createFullSpanItemFromEnd(I)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    .locals 4
    .param p1, "newItemTop"    # I

    .line 1695
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    invoke-direct {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;-><init>()V

    .line 1696
    .local v0, "fsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array v1, v1, [I

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapPerSpan:[I

    .line 1697
    const/4 v1, 0x0

    .line 1697
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_0

    .line 1698
    iget-object v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapPerSpan:[I

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v3, v3, v1

    invoke-virtual {v3, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v3

    sub-int v3, p1, v3

    aput v3, v2, v1

    .line 1697
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1700
    .end local v1    # "i":I
    :cond_0
    return-object v0
.end method

.method private createFullSpanItemFromStart(I)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    .locals 4
    .param p1, "newItemBottom"    # I

    .line 1704
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    invoke-direct {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;-><init>()V

    .line 1705
    .local v0, "fsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array v1, v1, [I

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapPerSpan:[I

    .line 1706
    const/4 v1, 0x0

    .line 1706
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_0

    .line 1707
    iget-object v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapPerSpan:[I

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v3, v3, v1

    invoke-virtual {v3, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v3

    sub-int/2addr v3, p1

    aput v3, v2, v1

    .line 1706
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1709
    .end local v1    # "i":I
    :cond_0
    return-object v0
.end method

.method private createOrientationHelpers()V
    .locals 1

    .line 258
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    invoke-static {p0, v0}, Landroid/support/v7/widget/OrientationHelper;->createOrientationHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;I)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 259
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    rsub-int/lit8 v0, v0, 0x1

    .line 260
    invoke-static {p0, v0}, Landroid/support/v7/widget/OrientationHelper;->createOrientationHelper(Landroid/support/v7/widget/RecyclerView$LayoutManager;I)Landroid/support/v7/widget/OrientationHelper;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 261
    return-void
.end method

.method private fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 22
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "layoutState"    # Landroid/support/v7/widget/LayoutState;
    .param p3, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    move-object/from16 v11, p0

    move-object/from16 v12, p1

    move-object/from16 v13, p2

    .line 1538
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    iget v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    const/4 v14, 0x0

    const/4 v15, 0x1

    invoke-virtual {v0, v14, v1, v15}, Ljava/util/BitSet;->set(IIZ)V

    .line 1543
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-boolean v0, v0, Landroid/support/v7/widget/LayoutState;->mInfinite:Z

    if-eqz v0, :cond_1

    .line 1544
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v15, :cond_0

    .line 1545
    const v0, 0x7fffffff

    .line 1545
    .local v0, "targetLine":I
    :goto_0
    goto :goto_1

    .line 1547
    .end local v0    # "targetLine":I
    :cond_0
    const/high16 v0, -0x80000000

    goto :goto_0

    .line 1550
    :cond_1
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v15, :cond_2

    .line 1551
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    iget v1, v13, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    add-int/2addr v0, v1

    goto :goto_0

    .line 1553
    :cond_2
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    iget v1, v13, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    sub-int/2addr v0, v1

    .line 1553
    .restart local v0    # "targetLine":I
    :goto_1
    move v10, v0

    .line 1557
    .end local v0    # "targetLine":I
    .local v10, "targetLine":I
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    invoke-direct {v11, v0, v10}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateAllRemainingSpans(II)V

    .line 1564
    iget-boolean v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v0, :cond_3

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1565
    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v0

    goto :goto_2

    :cond_3
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1566
    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v0

    :goto_2
    move v9, v0

    .line 1567
    .local v9, "defaultNewViewLine":I
    move v0, v14

    .line 1567
    .local v0, "added":Z
    :goto_3
    move/from16 v16, v0

    .line 1568
    .end local v0    # "added":Z
    .local v16, "added":Z
    invoke-virtual/range {p2 .. p3}, Landroid/support/v7/widget/LayoutState;->hasMore(Landroid/support/v7/widget/RecyclerView$State;)Z

    move-result v0

    const/4 v1, -0x1

    if-eqz v0, :cond_1a

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-boolean v0, v0, Landroid/support/v7/widget/LayoutState;->mInfinite:Z

    if-nez v0, :cond_5

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    .line 1569
    invoke-virtual {v0}, Ljava/util/BitSet;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4

    goto :goto_4

    .line 1680
    :cond_4
    move v3, v9

    move v0, v10

    move v7, v14

    goto/16 :goto_15

    .line 1570
    :cond_5
    :goto_4
    invoke-virtual {v13, v12}, Landroid/support/v7/widget/LayoutState;->next(Landroid/support/v7/widget/RecyclerView$Recycler;)Landroid/view/View;

    move-result-object v8

    .line 1571
    .local v8, "view":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v7, v0

    check-cast v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 1572
    .local v7, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    invoke-virtual {v7}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->getViewLayoutPosition()I

    move-result v6

    .line 1573
    .local v6, "position":I
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v0, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->getSpan(I)I

    move-result v5

    .line 1575
    .local v5, "spanIndex":I
    if-ne v5, v1, :cond_6

    move v0, v15

    goto :goto_5

    :cond_6
    move v0, v14

    :goto_5
    move/from16 v17, v0

    .line 1576
    .local v17, "assignSpan":Z
    if-eqz v17, :cond_8

    .line 1577
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_7

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v0, v0, v14

    goto :goto_6

    :cond_7
    invoke-direct {v11, v13}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getNextSpan(Landroid/support/v7/widget/LayoutState;)Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    move-result-object v0

    .line 1578
    .local v0, "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :goto_6
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v2, v6, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->setSpan(ILandroid/support/v7/widget/StaggeredGridLayoutManager$Span;)V

    goto :goto_7

    .line 1586
    .end local v0    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :cond_8
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v0, v0, v5

    .line 1586
    .restart local v0    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :goto_7
    move-object v3, v0

    .line 1589
    .end local v0    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .local v3, "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    iput-object v3, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    .line 1590
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v15, :cond_9

    .line 1591
    invoke-virtual {v11, v8}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->addView(Landroid/view/View;)V

    goto :goto_8

    .line 1593
    :cond_9
    invoke-virtual {v11, v8, v14}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->addView(Landroid/view/View;I)V

    .line 1595
    :goto_8
    invoke-direct {v11, v8, v7, v14}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->measureChildWithDecorationsAndMargin(Landroid/view/View;Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;Z)V

    .line 1599
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v15, :cond_c

    .line 1600
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_a

    invoke-direct {v11, v9}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMaxEnd(I)I

    move-result v0

    goto :goto_9

    .line 1601
    :cond_a
    invoke-virtual {v3, v9}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v0

    .line 1602
    .local v0, "start":I
    :goto_9
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v8}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v2

    add-int/2addr v2, v0

    .line 1603
    .local v2, "end":I
    if-eqz v17, :cond_b

    iget-boolean v4, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v4, :cond_b

    .line 1605
    invoke-direct {v11, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->createFullSpanItemFromEnd(I)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v4

    .line 1606
    .local v4, "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iput v1, v4, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapDir:I

    .line 1607
    iput v6, v4, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    .line 1608
    iget-object v14, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v14, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->addFullSpanItem(Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;)V

    .line 1609
    .end local v4    # "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    nop

    .line 1624
    :cond_b
    move v14, v0

    move/from16 v18, v2

    goto :goto_b

    .line 1611
    .end local v0    # "start":I
    .end local v2    # "end":I
    :cond_c
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_d

    invoke-direct {v11, v9}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinStart(I)I

    move-result v0

    goto :goto_a

    .line 1612
    :cond_d
    invoke-virtual {v3, v9}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v0

    .line 1613
    .local v0, "end":I
    :goto_a
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v8}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v2

    sub-int v2, v0, v2

    .line 1614
    .local v2, "start":I
    if-eqz v17, :cond_e

    iget-boolean v4, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v4, :cond_e

    .line 1616
    invoke-direct {v11, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->createFullSpanItemFromStart(I)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v4

    .line 1617
    .restart local v4    # "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iput v15, v4, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapDir:I

    .line 1618
    iput v6, v4, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    .line 1619
    iget-object v14, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v14, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->addFullSpanItem(Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;)V

    .line 1624
    .end local v4    # "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_e
    move/from16 v18, v0

    move v14, v2

    .line 1624
    .end local v0    # "end":I
    .end local v2    # "start":I
    .local v14, "start":I
    .local v18, "end":I
    :goto_b
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_12

    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    if-ne v0, v1, :cond_12

    .line 1625
    if-eqz v17, :cond_f

    .line 1626
    iput-boolean v15, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    goto :goto_d

    .line 1629
    :cond_f
    iget v0, v13, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v15, :cond_10

    .line 1630
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->areAllEndsEqual()Z

    move-result v0

    xor-int/2addr v0, v15

    .line 1630
    .local v0, "hasInvalidGap":Z
    goto :goto_c

    .line 1632
    .end local v0    # "hasInvalidGap":Z
    :cond_10
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->areAllStartsEqual()Z

    move-result v0

    xor-int/2addr v0, v15

    .line 1634
    .restart local v0    # "hasInvalidGap":Z
    :goto_c
    if-eqz v0, :cond_12

    .line 1635
    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    .line 1636
    invoke-virtual {v1, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->getFullSpanItem(I)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v1

    .line 1637
    .local v1, "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    if-eqz v1, :cond_11

    .line 1638
    iput-boolean v15, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mHasUnwantedGapAfter:Z

    .line 1640
    :cond_11
    iput-boolean v15, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    .line 1644
    .end local v0    # "hasInvalidGap":Z
    .end local v1    # "fullSpanItem":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_12
    :goto_d
    invoke-direct {v11, v8, v7, v13}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->attachViewToSpans(Landroid/view/View;Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;Landroid/support/v7/widget/LayoutState;)V

    .line 1647
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v0

    if-eqz v0, :cond_14

    iget v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v15, :cond_14

    .line 1648
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_13

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v0

    goto :goto_e

    :cond_13
    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1649
    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v0

    iget v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v1, v15

    iget v2, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    sub-int/2addr v1, v2

    iget v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    mul-int/2addr v1, v2

    sub-int/2addr v0, v1

    .line 1651
    .local v0, "otherEnd":I
    :goto_e
    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1, v8}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v1

    sub-int v1, v0, v1

    .line 1656
    .local v1, "otherStart":I
    move v4, v0

    move/from16 v19, v1

    goto :goto_10

    .line 1653
    .end local v0    # "otherEnd":I
    .end local v1    # "otherStart":I
    :cond_14
    iget-boolean v0, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v0, :cond_15

    iget-object v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v0

    goto :goto_f

    :cond_15
    iget v0, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    iget v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    mul-int/2addr v0, v1

    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1655
    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v1

    add-int/2addr v0, v1

    .line 1656
    .local v0, "otherStart":I
    :goto_f
    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1, v8}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v1

    add-int/2addr v1, v0

    move/from16 v19, v0

    move v4, v1

    .line 1659
    .end local v0    # "otherStart":I
    .local v4, "otherEnd":I
    .local v19, "otherStart":I
    :goto_10
    iget v0, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v15, :cond_16

    .line 1660
    move-object v0, v11

    move-object v1, v8

    move/from16 v2, v19

    move-object v15, v3

    move v3, v14

    .line 1660
    .end local v3    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .local v15, "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    move/from16 v20, v5

    move/from16 v5, v18

    .line 1660
    .end local v5    # "spanIndex":I
    .local v20, "spanIndex":I
    invoke-virtual/range {v0 .. v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->layoutDecoratedWithMargins(Landroid/view/View;IIII)V

    .line 1665
    move/from16 v21, v6

    move-object v1, v7

    move-object v2, v8

    move v3, v9

    move v0, v10

    goto :goto_11

    .line 1662
    .end local v15    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .end local v20    # "spanIndex":I
    .restart local v3    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .restart local v5    # "spanIndex":I
    :cond_16
    move-object v15, v3

    move/from16 v20, v5

    .line 1662
    .end local v3    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .end local v5    # "spanIndex":I
    .restart local v15    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .restart local v20    # "spanIndex":I
    move-object v5, v11

    move v0, v6

    move-object v6, v8

    .line 1662
    .end local v6    # "position":I
    .local v0, "position":I
    move-object v1, v7

    move v7, v14

    .line 1662
    .end local v7    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .local v1, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    move-object v2, v8

    move/from16 v8, v19

    .line 1662
    .end local v8    # "view":Landroid/view/View;
    .local v2, "view":Landroid/view/View;
    move v3, v9

    move/from16 v9, v18

    .line 1662
    .end local v9    # "defaultNewViewLine":I
    .local v3, "defaultNewViewLine":I
    move/from16 v21, v0

    move v0, v10

    move v10, v4

    .line 1662
    .end local v10    # "targetLine":I
    .local v0, "targetLine":I
    .local v21, "position":I
    invoke-virtual/range {v5 .. v10}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->layoutDecoratedWithMargins(Landroid/view/View;IIII)V

    .line 1665
    :goto_11
    iget-boolean v5, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v5, :cond_17

    .line 1666
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v5, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    invoke-direct {v11, v5, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateAllRemainingSpans(II)V

    goto :goto_12

    .line 1668
    :cond_17
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v5, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    invoke-direct {v11, v15, v5, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateRemainingSpans(Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;II)V

    .line 1670
    :goto_12
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {v11, v12, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycle(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;)V

    .line 1671
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-boolean v5, v5, Landroid/support/v7/widget/LayoutState;->mStopInFocusable:Z

    if-eqz v5, :cond_19

    invoke-virtual {v2}, Landroid/view/View;->hasFocusable()Z

    move-result v5

    if-eqz v5, :cond_19

    .line 1672
    iget-boolean v5, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v5, :cond_18

    .line 1673
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    invoke-virtual {v5}, Ljava/util/BitSet;->clear()V

    goto :goto_13

    .line 1675
    :cond_18
    iget-object v5, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    iget v6, v15, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Ljava/util/BitSet;->set(IZ)V

    goto :goto_14

    .line 1678
    :cond_19
    :goto_13
    const/4 v7, 0x0

    :goto_14
    const/4 v1, 0x1

    .line 1679
    .end local v2    # "view":Landroid/view/View;
    .end local v4    # "otherEnd":I
    .end local v14    # "start":I
    .end local v15    # "currentSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .end local v16    # "added":Z
    .end local v17    # "assignSpan":Z
    .end local v18    # "end":I
    .end local v19    # "otherStart":I
    .end local v20    # "spanIndex":I
    .end local v21    # "position":I
    .local v1, "added":Z
    nop

    .line 1567
    move v10, v0

    move v0, v1

    move v9, v3

    move v14, v7

    const/4 v15, 0x1

    goto/16 :goto_3

    .line 1680
    .end local v0    # "targetLine":I
    .end local v1    # "added":Z
    .end local v3    # "defaultNewViewLine":I
    .restart local v9    # "defaultNewViewLine":I
    .restart local v10    # "targetLine":I
    .restart local v16    # "added":Z
    :cond_1a
    move v3, v9

    move v0, v10

    move v7, v14

    .line 1680
    .end local v9    # "defaultNewViewLine":I
    .end local v10    # "targetLine":I
    .restart local v0    # "targetLine":I
    .restart local v3    # "defaultNewViewLine":I
    :goto_15
    if-nez v16, :cond_1b

    .line 1681
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {v11, v12, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycle(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;)V

    .line 1684
    :cond_1b
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v2, v2, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v2, v1, :cond_1c

    .line 1685
    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v1

    invoke-direct {v11, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinStart(I)I

    move-result v1

    .line 1686
    .local v1, "minStart":I
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v2

    sub-int/2addr v2, v1

    .line 1687
    .end local v1    # "minStart":I
    .local v2, "diff":I
    goto :goto_16

    .line 1688
    .end local v2    # "diff":I
    :cond_1c
    iget-object v1, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v1

    invoke-direct {v11, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMaxEnd(I)I

    move-result v1

    .line 1689
    .local v1, "maxEnd":I
    iget-object v2, v11, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v2

    sub-int v2, v1, v2

    .line 1689
    .end local v1    # "maxEnd":I
    .restart local v2    # "diff":I
    :goto_16
    move v1, v2

    .line 1691
    .end local v2    # "diff":I
    .local v1, "diff":I
    if-lez v1, :cond_1d

    iget v2, v13, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    invoke-static {v2, v1}, Ljava/lang/Math;->min(II)I

    move-result v14

    goto :goto_17

    :cond_1d
    move v14, v7

    :goto_17
    return v14
.end method

.method private findFirstReferenceChildPosition(I)I
    .locals 5
    .param p1, "itemCount"    # I

    .line 2180
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    .line 2181
    .local v0, "limit":I
    const/4 v1, 0x0

    move v2, v1

    .line 2181
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 2182
    invoke-virtual {p0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 2183
    .local v3, "view":Landroid/view/View;
    invoke-virtual {p0, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v4

    .line 2184
    .local v4, "position":I
    if-ltz v4, :cond_0

    if-ge v4, p1, :cond_0

    .line 2185
    return v4

    .line 2181
    .end local v3    # "view":Landroid/view/View;
    .end local v4    # "position":I
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2188
    .end local v2    # "i":I
    :cond_1
    return v1
.end method

.method private findLastReferenceChildPosition(I)I
    .locals 3
    .param p1, "itemCount"    # I

    .line 2197
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .line 2197
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_1

    .line 2198
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 2199
    .local v1, "view":Landroid/view/View;
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v2

    .line 2200
    .local v2, "position":I
    if-ltz v2, :cond_0

    if-ge v2, p1, :cond_0

    .line 2201
    return v2

    .line 2197
    .end local v1    # "view":Landroid/view/View;
    .end local v2    # "position":I
    :cond_0
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2204
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method private fixEndGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V
    .locals 4
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p3, "canOffsetChildren"    # Z

    .line 1374
    const/high16 v0, -0x80000000

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMaxEnd(I)I

    move-result v1

    .line 1375
    .local v1, "maxEndLine":I
    if-ne v1, v0, :cond_0

    .line 1376
    return-void

    .line 1378
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v0

    sub-int/2addr v0, v1

    .line 1380
    .local v0, "gap":I
    if-lez v0, :cond_2

    .line 1381
    neg-int v2, v0

    invoke-virtual {p0, v2, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->scrollBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v2

    neg-int v2, v2

    .line 1383
    .local v2, "fixOffset":I
    nop

    .line 1385
    sub-int/2addr v0, v2

    .line 1386
    if-eqz p3, :cond_1

    if-lez v0, :cond_1

    .line 1387
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3, v0}, Landroid/support/v7/widget/OrientationHelper;->offsetChildren(I)V

    .line 1389
    :cond_1
    return-void

    .line 1383
    .end local v2    # "fixOffset":I
    :cond_2
    return-void
.end method

.method private fixStartGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V
    .locals 5
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p3, "canOffsetChildren"    # Z

    .line 1393
    const v0, 0x7fffffff

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinStart(I)I

    move-result v1

    .line 1394
    .local v1, "minStartLine":I
    if-ne v1, v0, :cond_0

    .line 1395
    return-void

    .line 1397
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v0

    sub-int v0, v1, v0

    .line 1399
    .local v0, "gap":I
    if-lez v0, :cond_2

    .line 1400
    invoke-virtual {p0, v0, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->scrollBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v2

    .line 1402
    .local v2, "fixOffset":I
    nop

    .line 1404
    sub-int/2addr v0, v2

    .line 1405
    if-eqz p3, :cond_1

    if-lez v0, :cond_1

    .line 1406
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    neg-int v4, v0

    invoke-virtual {v3, v4}, Landroid/support/v7/widget/OrientationHelper;->offsetChildren(I)V

    .line 1408
    :cond_1
    return-void

    .line 1402
    .end local v2    # "fixOffset":I
    :cond_2
    return-void
.end method

.method private getMaxEnd(I)I
    .locals 3
    .param p1, "def"    # I

    .line 1848
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v0

    .line 1849
    .local v0, "maxEnd":I
    const/4 v1, 0x1

    .line 1849
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_1

    .line 1850
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v2

    .line 1851
    .local v2, "spanEnd":I
    if-le v2, v0, :cond_0

    .line 1852
    move v0, v2

    .line 1849
    .end local v2    # "spanEnd":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1855
    .end local v1    # "i":I
    :cond_1
    return v0
.end method

.method private getMaxStart(I)I
    .locals 3
    .param p1, "def"    # I

    .line 1806
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v0

    .line 1807
    .local v0, "maxStart":I
    const/4 v1, 0x1

    .line 1807
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_1

    .line 1808
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v2

    .line 1809
    .local v2, "spanStart":I
    if-le v2, v0, :cond_0

    .line 1810
    move v0, v2

    .line 1807
    .end local v2    # "spanStart":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1813
    .end local v1    # "i":I
    :cond_1
    return v0
.end method

.method private getMinEnd(I)I
    .locals 3
    .param p1, "def"    # I

    .line 1859
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v0

    .line 1860
    .local v0, "minEnd":I
    const/4 v1, 0x1

    .line 1860
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_1

    .line 1861
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v2

    .line 1862
    .local v2, "spanEnd":I
    if-ge v2, v0, :cond_0

    .line 1863
    move v0, v2

    .line 1860
    .end local v2    # "spanEnd":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1866
    .end local v1    # "i":I
    :cond_1
    return v0
.end method

.method private getMinStart(I)I
    .locals 3
    .param p1, "def"    # I

    .line 1817
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-virtual {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v0

    .line 1818
    .local v0, "minStart":I
    const/4 v1, 0x1

    .line 1818
    .local v1, "i":I
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_1

    .line 1819
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v2

    .line 1820
    .local v2, "spanStart":I
    if-ge v2, v0, :cond_0

    .line 1821
    move v0, v2

    .line 1818
    .end local v2    # "spanStart":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1824
    .end local v1    # "i":I
    :cond_1
    return v0
.end method

.method private getNextSpan(Landroid/support/v7/widget/LayoutState;)Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .locals 10
    .param p1, "layoutState"    # Landroid/support/v7/widget/LayoutState;

    .line 1943
    iget v0, p1, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->preferLastSpan(I)Z

    move-result v0

    .line 1945
    .local v0, "preferLastSpan":Z
    const/4 v1, 0x1

    if-eqz v0, :cond_0

    .line 1946
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v2, v1

    .line 1947
    .local v2, "startIndex":I
    const/4 v3, -0x1

    .line 1948
    .local v3, "endIndex":I
    const/4 v4, -0x1

    .line 1948
    .local v4, "diff":I
    goto :goto_0

    .line 1950
    .end local v2    # "startIndex":I
    .end local v3    # "endIndex":I
    .end local v4    # "diff":I
    :cond_0
    const/4 v2, 0x0

    .line 1951
    .restart local v2    # "startIndex":I
    iget v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    .line 1952
    .restart local v3    # "endIndex":I
    move v4, v1

    .line 1954
    .restart local v4    # "diff":I
    :goto_0
    iget v5, p1, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v5, v1, :cond_3

    .line 1955
    const/4 v1, 0x0

    .line 1956
    .local v1, "min":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    const v5, 0x7fffffff

    .line 1957
    .local v5, "minLine":I
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v6

    .line 1958
    .local v6, "defaultLine":I
    move-object v7, v1

    move v1, v2

    .line 1958
    .local v1, "i":I
    .local v7, "min":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :goto_1
    if-eq v1, v3, :cond_2

    .line 1959
    iget-object v8, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v8, v8, v1

    .line 1960
    .local v8, "other":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    invoke-virtual {v8, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v9

    .line 1961
    .local v9, "otherLine":I
    if-ge v9, v5, :cond_1

    .line 1962
    move-object v7, v8

    .line 1963
    move v5, v9

    .line 1958
    .end local v8    # "other":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .end local v9    # "otherLine":I
    :cond_1
    add-int/2addr v1, v4

    goto :goto_1

    .line 1966
    .end local v1    # "i":I
    :cond_2
    return-object v7

    .line 1968
    .end local v5    # "minLine":I
    .end local v6    # "defaultLine":I
    .end local v7    # "min":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :cond_3
    const/4 v1, 0x0

    .line 1969
    .local v1, "max":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    const/high16 v5, -0x80000000

    .line 1970
    .local v5, "maxLine":I
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v6

    .line 1971
    .restart local v6    # "defaultLine":I
    move-object v7, v1

    move v1, v2

    .line 1971
    .local v1, "i":I
    .local v7, "max":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    :goto_2
    if-eq v1, v3, :cond_5

    .line 1972
    iget-object v8, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v8, v8, v1

    .line 1973
    .restart local v8    # "other":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    invoke-virtual {v8, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v9

    .line 1974
    .restart local v9    # "otherLine":I
    if-le v9, v5, :cond_4

    .line 1975
    move-object v7, v8

    .line 1976
    move v5, v9

    .line 1971
    .end local v8    # "other":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .end local v9    # "otherLine":I
    :cond_4
    add-int/2addr v1, v4

    goto :goto_2

    .line 1979
    .end local v1    # "i":I
    :cond_5
    return-object v7
.end method

.method private handleUpdate(III)V
    .locals 5
    .param p1, "positionStart"    # I
    .param p2, "itemCountOrToPosition"    # I
    .param p3, "cmd"    # I

    .line 1494
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v0

    .line 1498
    .local v0, "minPosition":I
    :goto_0
    const/16 v1, 0x8

    if-ne p3, v1, :cond_2

    .line 1499
    if-ge p1, p2, :cond_1

    .line 1500
    add-int/lit8 v2, p2, 0x1

    .line 1501
    .local v2, "affectedRangeEnd":I
    move v3, p1

    .line 1501
    .local v3, "affectedRangeStart":I
    :goto_1
    goto :goto_2

    .line 1503
    .end local v2    # "affectedRangeEnd":I
    .end local v3    # "affectedRangeStart":I
    :cond_1
    add-int/lit8 v2, p1, 0x1

    .line 1504
    .restart local v2    # "affectedRangeEnd":I
    move v3, p2

    goto :goto_1

    .line 1507
    .end local v2    # "affectedRangeEnd":I
    :cond_2
    move v3, p1

    .line 1508
    .restart local v3    # "affectedRangeStart":I
    add-int v2, p1, p2

    .line 1511
    .restart local v2    # "affectedRangeEnd":I
    :goto_2
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v4, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->invalidateAfter(I)I

    .line 1512
    if-eq p3, v1, :cond_3

    packed-switch p3, :pswitch_data_0

    goto :goto_3

    .line 1517
    :pswitch_0
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v1, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetForRemoval(II)V

    .line 1518
    goto :goto_3

    .line 1514
    :pswitch_1
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v1, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetForAddition(II)V

    .line 1515
    goto :goto_3

    .line 1521
    :cond_3
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    const/4 v4, 0x1

    invoke-virtual {v1, p1, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetForRemoval(II)V

    .line 1522
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v1, p2, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetForAddition(II)V

    .line 1526
    :goto_3
    if-gt v2, v0, :cond_4

    .line 1527
    return-void

    .line 1530
    :cond_4
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v1, :cond_5

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v1

    goto :goto_4

    :cond_5
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v1

    .line 1531
    .local v1, "maxPosition":I
    :goto_4
    if-gt v3, v1, :cond_6

    .line 1532
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 1534
    :cond_6
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private measureChildWithDecorationsAndMargin(Landroid/view/View;IIZ)V
    .locals 4
    .param p1, "child"    # Landroid/view/View;
    .param p2, "widthSpec"    # I
    .param p3, "heightSpec"    # I
    .param p4, "alreadyMeasured"    # Z

    .line 1154
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    invoke-virtual {p0, p1, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->calculateItemDecorationsForChild(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1155
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 1156
    .local v0, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->leftMargin:I

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->left:I

    add-int/2addr v1, v2

    iget v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->rightMargin:I

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->right:I

    add-int/2addr v2, v3

    invoke-direct {p0, p2, v1, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateSpecWithExtra(III)I

    move-result p2

    .line 1158
    iget v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->topMargin:I

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->top:I

    add-int/2addr v1, v2

    iget v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->bottomMargin:I

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mTmpRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->bottom:I

    add-int/2addr v2, v3

    invoke-direct {p0, p3, v1, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateSpecWithExtra(III)I

    move-result p3

    .line 1160
    if-eqz p4, :cond_0

    .line 1161
    invoke-virtual {p0, p1, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->shouldReMeasureChild(Landroid/view/View;IILandroid/support/v7/widget/RecyclerView$LayoutParams;)Z

    move-result v1

    goto :goto_0

    .line 1162
    :cond_0
    invoke-virtual {p0, p1, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->shouldMeasureChild(Landroid/view/View;IILandroid/support/v7/widget/RecyclerView$LayoutParams;)Z

    move-result v1

    .line 1163
    .local v1, "measure":Z
    :goto_0
    if-eqz v1, :cond_1

    .line 1164
    invoke-virtual {p1, p2, p3}, Landroid/view/View;->measure(II)V

    .line 1167
    :cond_1
    return-void
.end method

.method private measureChildWithDecorationsAndMargin(Landroid/view/View;Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;Z)V
    .locals 6
    .param p1, "child"    # Landroid/view/View;
    .param p2, "lp"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .param p3, "alreadyMeasured"    # Z

    .line 1127
    iget-boolean v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_1

    .line 1128
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v1, :cond_0

    .line 1129
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mFullSizeSpec:I

    .line 1130
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getHeightMode()I

    move-result v4

    iget v5, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->height:I

    invoke-static {v3, v4, v2, v5, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v1

    .line 1129
    invoke-direct {p0, p1, v0, v1, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->measureChildWithDecorationsAndMargin(Landroid/view/View;IIZ)V

    goto :goto_0

    .line 1133
    :cond_0
    nop

    .line 1134
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getWidthMode()I

    move-result v3

    iget v4, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->width:I

    invoke-static {v0, v3, v2, v4, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v0

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mFullSizeSpec:I

    .line 1133
    invoke-direct {p0, p1, v0, v1, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->measureChildWithDecorationsAndMargin(Landroid/view/View;IIZ)V

    goto :goto_0

    .line 1138
    :cond_1
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v0, v1, :cond_2

    .line 1139
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    .line 1140
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getWidthMode()I

    move-result v3

    iget v4, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->width:I

    invoke-static {v0, v3, v2, v4, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v0

    .line 1141
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getHeightMode()I

    move-result v4

    iget v5, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->height:I

    invoke-static {v3, v4, v2, v5, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v1

    .line 1139
    invoke-direct {p0, p1, v0, v1, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->measureChildWithDecorationsAndMargin(Landroid/view/View;IIZ)V

    goto :goto_0

    .line 1144
    :cond_2
    nop

    .line 1145
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getWidthMode()I

    move-result v3

    iget v4, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->width:I

    invoke-static {v0, v3, v2, v4, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v0

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    .line 1146
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getHeightMode()I

    move-result v3

    iget v4, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->height:I

    invoke-static {v1, v3, v2, v4, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildMeasureSpec(IIIIZ)I

    move-result v1

    .line 1144
    invoke-direct {p0, p1, v0, v1, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->measureChildWithDecorationsAndMargin(Landroid/view/View;IIZ)V

    .line 1150
    :goto_0
    return-void
.end method

.method private onLayoutChildren(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V
    .locals 9
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p3, "shouldCheckForGaps"    # Z

    .line 610
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 611
    .local v0, "anchorInfo":Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    const/4 v2, -0x1

    if-nez v1, :cond_0

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    if-eq v1, v2, :cond_1

    .line 612
    :cond_0
    invoke-virtual {p2}, Landroid/support/v7/widget/RecyclerView$State;->getItemCount()I

    move-result v1

    if-nez v1, :cond_1

    .line 613
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->removeAndRecycleAllViews(Landroid/support/v7/widget/RecyclerView$Recycler;)V

    .line 614
    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->reset()V

    .line 615
    return-void

    .line 619
    :cond_1
    iget-boolean v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mValid:Z

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-eqz v1, :cond_3

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    if-ne v1, v2, :cond_3

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v1, :cond_2

    goto :goto_0

    :cond_2
    move v1, v3

    goto :goto_1

    :cond_3
    :goto_0
    move v1, v4

    .line 621
    .local v1, "recalculateAnchor":Z
    :goto_1
    if-eqz v1, :cond_5

    .line 622
    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->reset()V

    .line 623
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v5, :cond_4

    .line 624
    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->applyPendingSavedState(Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)V

    goto :goto_2

    .line 626
    :cond_4
    invoke-direct {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->resolveShouldLayoutReverse()V

    .line 627
    iget-boolean v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    iput-boolean v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    .line 629
    :goto_2
    invoke-virtual {p0, p2, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateAnchorInfoForLayout(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)V

    .line 630
    iput-boolean v4, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mValid:Z

    .line 632
    :cond_5
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-nez v5, :cond_7

    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    if-ne v5, v2, :cond_7

    .line 633
    iget-boolean v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    iget-boolean v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    if-ne v5, v6, :cond_6

    .line 634
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v5

    iget-boolean v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutRTL:Z

    if-eq v5, v6, :cond_7

    .line 635
    :cond_6
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->clear()V

    .line 636
    iput-boolean v4, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mInvalidateOffsets:Z

    .line 640
    :cond_7
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v5

    if-lez v5, :cond_e

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v5, :cond_8

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v5, v5, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    if-ge v5, v4, :cond_e

    .line 642
    :cond_8
    iget-boolean v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mInvalidateOffsets:Z

    if-eqz v5, :cond_a

    .line 643
    move v5, v3

    .line 643
    .local v5, "i":I
    :goto_3
    iget v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v5, v6, :cond_e

    .line 645
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v6, v6, v5

    invoke-virtual {v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->clear()V

    .line 646
    iget v6, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    const/high16 v7, -0x80000000

    if-eq v6, v7, :cond_9

    .line 647
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v6, v6, v5

    iget v7, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    invoke-virtual {v6, v7}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->setLine(I)V

    .line 643
    :cond_9
    add-int/lit8 v5, v5, 0x1

    goto :goto_3

    .line 651
    .end local v5    # "i":I
    :cond_a
    if-nez v1, :cond_c

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    iget-object v5, v5, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mSpanReferenceLines:[I

    if-nez v5, :cond_b

    goto :goto_5

    .line 658
    :cond_b
    move v5, v3

    .line 658
    .restart local v5    # "i":I
    :goto_4
    iget v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v5, v6, :cond_e

    .line 659
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v6, v6, v5

    .line 660
    .local v6, "span":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    invoke-virtual {v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->clear()V

    .line 661
    iget-object v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    iget-object v7, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mSpanReferenceLines:[I

    aget v7, v7, v5

    invoke-virtual {v6, v7}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->setLine(I)V

    .line 658
    .end local v6    # "span":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    add-int/lit8 v5, v5, 0x1

    goto :goto_4

    .line 652
    .end local v5    # "i":I
    :cond_c
    :goto_5
    move v5, v3

    .line 652
    .restart local v5    # "i":I
    :goto_6
    iget v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v5, v6, :cond_d

    .line 653
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v6, v6, v5

    iget-boolean v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    iget v8, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    invoke-virtual {v6, v7, v8}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->cacheReferenceLineAndClear(ZI)V

    .line 652
    add-int/lit8 v5, v5, 0x1

    goto :goto_6

    .line 656
    .end local v5    # "i":I
    :cond_d
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-virtual {v5, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->saveSpanReferenceLines([Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;)V

    .line 666
    :cond_e
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->detachAndScrapAttachedViews(Landroid/support/v7/widget/RecyclerView$Recycler;)V

    .line 667
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput-boolean v3, v5, Landroid/support/v7/widget/LayoutState;->mRecycle:Z

    .line 668
    iput-boolean v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    .line 669
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v5

    invoke-virtual {p0, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateMeasureSpecs(I)V

    .line 670
    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    invoke-direct {p0, v5, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateLayoutState(ILandroid/support/v7/widget/RecyclerView$State;)V

    .line 671
    iget-boolean v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    if-eqz v5, :cond_f

    .line 673
    invoke-direct {p0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 674
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p1, v2, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    .line 676
    invoke-direct {p0, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 677
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v6, v6, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    add-int/2addr v5, v6

    iput v5, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 678
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p1, v2, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    goto :goto_7

    .line 681
    :cond_f
    invoke-direct {p0, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 682
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p1, v5, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    .line 684
    invoke-direct {p0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 685
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v6, v6, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    add-int/2addr v5, v6

    iput v5, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 686
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p1, v2, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    .line 689
    :goto_7
    invoke-direct {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->repositionToWrapContentIfNecessary()V

    .line 691
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v2

    if-lez v2, :cond_11

    .line 692
    iget-boolean v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v2, :cond_10

    .line 693
    invoke-direct {p0, p1, p2, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fixEndGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    .line 694
    invoke-direct {p0, p1, p2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fixStartGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    goto :goto_8

    .line 696
    :cond_10
    invoke-direct {p0, p1, p2, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fixStartGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    .line 697
    invoke-direct {p0, p1, p2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fixEndGap(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    .line 700
    :cond_11
    :goto_8
    const/4 v2, 0x0

    .line 701
    .local v2, "hasGaps":Z
    if-eqz p3, :cond_14

    invoke-virtual {p2}, Landroid/support/v7/widget/RecyclerView$State;->isPreLayout()Z

    move-result v5

    if-nez v5, :cond_14

    .line 702
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-eqz v5, :cond_13

    .line 703
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v5

    if-lez v5, :cond_13

    iget-boolean v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    if-nez v5, :cond_12

    .line 704
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->hasGapsToFix()Landroid/view/View;

    move-result-object v5

    if-eqz v5, :cond_13

    :cond_12
    goto :goto_9

    :cond_13
    move v4, v3

    .line 705
    .local v4, "needToCheckForGaps":Z
    :goto_9
    if-eqz v4, :cond_14

    .line 706
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mCheckForGapsRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 707
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->checkForGaps()Z

    move-result v5

    if-eqz v5, :cond_14

    .line 708
    const/4 v2, 0x1

    .line 712
    .end local v4    # "needToCheckForGaps":Z
    :cond_14
    invoke-virtual {p2}, Landroid/support/v7/widget/RecyclerView$State;->isPreLayout()Z

    move-result v4

    if-eqz v4, :cond_15

    .line 713
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    invoke-virtual {v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->reset()V

    .line 715
    :cond_15
    iget-boolean v4, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    iput-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    .line 716
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v4

    iput-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutRTL:Z

    .line 717
    if-eqz v2, :cond_16

    .line 718
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    invoke-virtual {v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->reset()V

    .line 719
    invoke-direct {p0, p1, p2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->onLayoutChildren(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    .line 721
    :cond_16
    return-void
.end method

.method private preferLastSpan(I)Z
    .locals 4
    .param p1, "layoutDir"    # I

    .line 1933
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v1, -0x1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v0, :cond_2

    .line 1934
    if-ne p1, v1, :cond_0

    move v0, v3

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eq v0, v1, :cond_1

    move v2, v3

    nop

    :cond_1
    return v2

    .line 1936
    :cond_2
    if-ne p1, v1, :cond_3

    move v0, v3

    goto :goto_1

    :cond_3
    move v0, v2

    :goto_1
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-ne v0, v1, :cond_4

    move v0, v3

    goto :goto_2

    :cond_4
    move v0, v2

    :goto_2
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v1

    if-ne v0, v1, :cond_5

    move v2, v3

    nop

    :cond_5
    return v2
.end method

.method private prependViewToAllSpans(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 1776
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    add-int/lit8 v0, v0, -0x1

    .line 1776
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_0

    .line 1777
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->prependToSpan(Landroid/view/View;)V

    .line 1776
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 1779
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method private recycle(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;)V
    .locals 3
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "layoutState"    # Landroid/support/v7/widget/LayoutState;

    .line 1729
    iget-boolean v0, p2, Landroid/support/v7/widget/LayoutState;->mRecycle:Z

    if-eqz v0, :cond_6

    iget-boolean v0, p2, Landroid/support/v7/widget/LayoutState;->mInfinite:Z

    if-eqz v0, :cond_0

    goto :goto_3

    .line 1732
    :cond_0
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    const/4 v1, -0x1

    if-nez v0, :cond_2

    .line 1734
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v1, :cond_1

    .line 1735
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycleFromEnd(Landroid/support/v7/widget/RecyclerView$Recycler;I)V

    goto :goto_2

    .line 1737
    :cond_1
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycleFromStart(Landroid/support/v7/widget/RecyclerView$Recycler;I)V

    goto :goto_2

    .line 1742
    :cond_2
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    if-ne v0, v1, :cond_4

    .line 1744
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    invoke-direct {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMaxStart(I)I

    move-result v1

    sub-int/2addr v0, v1

    .line 1746
    .local v0, "scrolled":I
    if-gez v0, :cond_3

    .line 1747
    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    .line 1747
    .local v1, "line":I
    goto :goto_0

    .line 1749
    .end local v1    # "line":I
    :cond_3
    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    iget v2, p2, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    sub-int/2addr v1, v2

    .line 1751
    .restart local v1    # "line":I
    :goto_0
    invoke-direct {p0, p1, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycleFromEnd(Landroid/support/v7/widget/RecyclerView$Recycler;I)V

    .line 1752
    .end local v0    # "scrolled":I
    .end local v1    # "line":I
    goto :goto_2

    .line 1754
    :cond_4
    iget v0, p2, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinEnd(I)I

    move-result v0

    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    sub-int/2addr v0, v1

    .line 1756
    .restart local v0    # "scrolled":I
    if-gez v0, :cond_5

    .line 1757
    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    .line 1757
    .restart local v1    # "line":I
    goto :goto_1

    .line 1759
    .end local v1    # "line":I
    :cond_5
    iget v1, p2, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    iget v2, p2, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    add-int/2addr v1, v2

    .line 1761
    .restart local v1    # "line":I
    :goto_1
    invoke-direct {p0, p1, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycleFromStart(Landroid/support/v7/widget/RecyclerView$Recycler;I)V

    .line 1765
    .end local v0    # "scrolled":I
    .end local v1    # "line":I
    :goto_2
    return-void

    .line 1730
    :cond_6
    :goto_3
    return-void
.end method

.method private recycleFromEnd(Landroid/support/v7/widget/RecyclerView$Recycler;I)V
    .locals 8
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "line"    # I

    .line 1899
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    .line 1901
    .local v0, "childCount":I
    add-int/lit8 v1, v0, -0x1

    .line 1901
    .local v1, "i":I
    :goto_0
    if-ltz v1, :cond_6

    .line 1902
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1903
    .local v2, "child":Landroid/view/View;
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3, v2}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v3

    if-lt v3, p2, :cond_5

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1904
    invoke-virtual {v3, v2}, Landroid/support/v7/widget/OrientationHelper;->getTransformedStartWithDecoration(Landroid/view/View;)I

    move-result v3

    if-lt v3, p2, :cond_5

    .line 1905
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 1907
    .local v3, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v4, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    const/4 v5, 0x1

    if-eqz v4, :cond_2

    .line 1908
    const/4 v4, 0x0

    move v6, v4

    .line 1908
    .local v6, "j":I
    :goto_1
    iget v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v6, v7, :cond_1

    .line 1909
    iget-object v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v7, v7, v6

    iget-object v7, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    if-ne v7, v5, :cond_0

    .line 1910
    return-void

    .line 1908
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 1913
    .end local v6    # "j":I
    :cond_1
    nop

    .line 1913
    .local v4, "j":I
    :goto_2
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v4, v5, :cond_4

    .line 1914
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v5, v5, v4

    invoke-virtual {v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->popEnd()V

    .line 1913
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 1917
    .end local v4    # "j":I
    :cond_2
    iget-object v4, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget-object v4, v4, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ne v4, v5, :cond_3

    .line 1918
    return-void

    .line 1920
    :cond_3
    iget-object v4, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-virtual {v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->popEnd()V

    .line 1922
    :cond_4
    invoke-virtual {p0, v2, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->removeAndRecycleView(Landroid/view/View;Landroid/support/v7/widget/RecyclerView$Recycler;)V

    .line 1923
    .end local v3    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    nop

    .line 1901
    .end local v2    # "child":Landroid/view/View;
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 1924
    .restart local v2    # "child":Landroid/view/View;
    :cond_5
    return-void

    .line 1927
    .end local v2    # "child":Landroid/view/View;
    :cond_6
    return-void
.end method

.method private recycleFromStart(Landroid/support/v7/widget/RecyclerView$Recycler;I)V
    .locals 6
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "line"    # I

    .line 1870
    :goto_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    if-lez v0, :cond_6

    .line 1871
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 1872
    .local v1, "child":Landroid/view/View;
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v1}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v2

    if-gt v2, p2, :cond_5

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1873
    invoke-virtual {v2, v1}, Landroid/support/v7/widget/OrientationHelper;->getTransformedEndWithDecoration(Landroid/view/View;)I

    move-result v2

    if-gt v2, p2, :cond_5

    .line 1874
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    check-cast v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 1876
    .local v2, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v3, v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    const/4 v4, 0x1

    if-eqz v3, :cond_2

    .line 1877
    move v3, v0

    .line 1877
    .local v3, "j":I
    :goto_1
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v3, v5, :cond_1

    .line 1878
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v5, v5, v3

    iget-object v5, v5, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    if-ne v5, v4, :cond_0

    .line 1879
    return-void

    .line 1877
    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 1882
    .end local v3    # "j":I
    :cond_1
    nop

    .line 1882
    .local v0, "j":I
    :goto_2
    iget v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v3, :cond_4

    .line 1883
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v3, v3, v0

    invoke-virtual {v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->popStart()V

    .line 1882
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 1886
    .end local v0    # "j":I
    :cond_2
    iget-object v0, v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget-object v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-ne v0, v4, :cond_3

    .line 1887
    return-void

    .line 1889
    :cond_3
    iget-object v0, v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->popStart()V

    .line 1891
    :cond_4
    invoke-virtual {p0, v1, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->removeAndRecycleView(Landroid/view/View;Landroid/support/v7/widget/RecyclerView$Recycler;)V

    .line 1892
    .end local v2    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    nop

    .line 1895
    .end local v1    # "child":Landroid/view/View;
    goto :goto_0

    .line 1893
    .restart local v1    # "child":Landroid/view/View;
    :cond_5
    return-void

    .line 1896
    .end local v1    # "child":Landroid/view/View;
    :cond_6
    return-void
.end method

.method private repositionToWrapContentIfNecessary()V
    .locals 11

    .line 733
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getMode()I

    move-result v0

    const/high16 v1, 0x40000000    # 2.0f

    if-ne v0, v1, :cond_0

    .line 734
    return-void

    .line 736
    :cond_0
    const/4 v0, 0x0

    .line 737
    .local v0, "maxSize":F
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v1

    .line 738
    .local v1, "childCount":I
    const/4 v2, 0x0

    move v3, v0

    move v0, v2

    .line 738
    .local v0, "i":I
    .local v3, "maxSize":F
    :goto_0
    if-ge v0, v1, :cond_3

    .line 739
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 740
    .local v4, "child":Landroid/view/View;
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5, v4}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v5

    int-to-float v5, v5

    .line 741
    .local v5, "size":F
    cmpg-float v6, v5, v3

    if-gez v6, :cond_1

    .line 742
    goto :goto_1

    .line 744
    :cond_1
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 745
    .local v6, "layoutParams":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    invoke-virtual {v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->isFullSpan()Z

    move-result v7

    if-eqz v7, :cond_2

    .line 746
    const/high16 v7, 0x3f800000    # 1.0f

    mul-float/2addr v7, v5

    iget v8, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    int-to-float v8, v8

    div-float v5, v7, v8

    .line 748
    :cond_2
    invoke-static {v3, v5}, Ljava/lang/Math;->max(FF)F

    move-result v3

    .line 738
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "size":F
    .end local v6    # "layoutParams":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 750
    .end local v0    # "i":I
    :cond_3
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    .line 751
    .local v0, "before":I
    iget v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    int-to-float v4, v4

    mul-float/2addr v4, v3

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 752
    .local v4, "desired":I
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getMode()I

    move-result v5

    const/high16 v6, -0x80000000

    if-ne v5, v6, :cond_4

    .line 753
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v5

    invoke-static {v4, v5}, Ljava/lang/Math;->min(II)I

    move-result v4

    .line 755
    :cond_4
    invoke-virtual {p0, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateMeasureSpecs(I)V

    .line 756
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    if-ne v5, v0, :cond_5

    .line 757
    return-void

    .line 759
    :cond_5
    nop

    .line 759
    .local v2, "i":I
    :goto_2
    if-ge v2, v1, :cond_9

    .line 760
    invoke-virtual {p0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 761
    .local v5, "child":Landroid/view/View;
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 762
    .local v6, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v7, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v7, :cond_6

    .line 763
    goto :goto_3

    .line 765
    :cond_6
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v7

    const/4 v8, 0x1

    if-eqz v7, :cond_7

    iget v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v7, v8, :cond_7

    .line 766
    iget v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v7, v8

    iget-object v9, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v9, v9, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    sub-int/2addr v7, v9

    neg-int v7, v7

    iget v9, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    mul-int/2addr v7, v9

    .line 767
    .local v7, "newOffset":I
    iget v9, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v9, v8

    iget-object v8, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v8, v8, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    sub-int/2addr v9, v8

    neg-int v8, v9

    mul-int/2addr v8, v0

    .line 768
    .local v8, "prevOffset":I
    sub-int v9, v7, v8

    invoke-virtual {v5, v9}, Landroid/view/View;->offsetLeftAndRight(I)V

    .line 769
    .end local v7    # "newOffset":I
    .end local v8    # "prevOffset":I
    goto :goto_3

    .line 770
    :cond_7
    iget-object v7, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v7, v7, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    iget v9, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    mul-int/2addr v7, v9

    .line 771
    .restart local v7    # "newOffset":I
    iget-object v9, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v9, v9, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    mul-int/2addr v9, v0

    .line 772
    .local v9, "prevOffset":I
    iget v10, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne v10, v8, :cond_8

    .line 773
    sub-int v8, v7, v9

    invoke-virtual {v5, v8}, Landroid/view/View;->offsetLeftAndRight(I)V

    goto :goto_3

    .line 775
    :cond_8
    sub-int v8, v7, v9

    invoke-virtual {v5, v8}, Landroid/view/View;->offsetTopAndBottom(I)V

    .line 759
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .end local v7    # "newOffset":I
    .end local v9    # "prevOffset":I
    :goto_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 779
    .end local v2    # "i":I
    :cond_9
    return-void
.end method

.method private resolveShouldLayoutReverse()V
    .locals 2

    .line 559
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 562
    :cond_0
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    xor-int/2addr v0, v1

    iput-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    goto :goto_1

    .line 560
    :cond_1
    :goto_0
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    iput-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    .line 564
    :goto_1
    return-void
.end method

.method private setLayoutStateDirection(I)V
    .locals 5
    .param p1, "direction"    # I

    .line 1442
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput p1, v0, Landroid/support/v7/widget/LayoutState;->mLayoutDirection:I

    .line 1443
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    const/4 v2, 0x1

    const/4 v3, -0x1

    if-ne p1, v3, :cond_0

    move v4, v2

    goto :goto_0

    :cond_0
    const/4 v4, 0x0

    :goto_0
    if-ne v1, v4, :cond_1

    goto :goto_1

    :cond_1
    move v2, v3

    :goto_1
    iput v2, v0, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    .line 1445
    return-void
.end method

.method private updateAllRemainingSpans(II)V
    .locals 2
    .param p1, "layoutDir"    # I
    .param p2, "targetLine"    # I

    .line 1782
    const/4 v0, 0x0

    .line 1782
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_1

    .line 1783
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mViews:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1784
    goto :goto_1

    .line 1786
    :cond_0
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-direct {p0, v1, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateRemainingSpans(Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;II)V

    .line 1782
    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1788
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method private updateAnchorFromChildren(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)Z
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p2, "anchorInfo"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 839
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    if-eqz v0, :cond_0

    .line 840
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$State;->getItemCount()I

    move-result v0

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findLastReferenceChildPosition(I)I

    move-result v0

    goto :goto_0

    .line 841
    :cond_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$State;->getItemCount()I

    move-result v0

    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstReferenceChildPosition(I)I

    move-result v0

    :goto_0
    iput v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    .line 842
    const/high16 v0, -0x80000000

    iput v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 843
    const/4 v0, 0x1

    return v0
.end method

.method private updateLayoutState(ILandroid/support/v7/widget/RecyclerView$State;)V
    .locals 7
    .param p1, "anchorPosition"    # I
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1411
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    const/4 v1, 0x0

    iput v1, v0, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    .line 1412
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput p1, v0, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 1413
    const/4 v0, 0x0

    .line 1414
    .local v0, "startExtra":I
    const/4 v2, 0x0

    .line 1415
    .local v2, "endExtra":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isSmoothScrolling()Z

    move-result v3

    const/4 v4, 0x1

    if-eqz v3, :cond_2

    .line 1416
    invoke-virtual {p2}, Landroid/support/v7/widget/RecyclerView$State;->getTargetScrollPosition()I

    move-result v3

    .line 1417
    .local v3, "targetPos":I
    const/4 v5, -0x1

    if-eq v3, v5, :cond_2

    .line 1418
    iget-boolean v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-ge v3, p1, :cond_0

    move v6, v4

    goto :goto_0

    :cond_0
    move v6, v1

    :goto_0
    if-ne v5, v6, :cond_1

    .line 1419
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v2

    goto :goto_1

    .line 1421
    :cond_1
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v0

    .line 1427
    .end local v3    # "targetPos":I
    :cond_2
    :goto_1
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getClipToPadding()Z

    move-result v3

    .line 1428
    .local v3, "clipToPadding":Z
    if-eqz v3, :cond_3

    .line 1429
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v6

    sub-int/2addr v6, v0

    iput v6, v5, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    .line 1430
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v6

    add-int/2addr v6, v2

    iput v6, v5, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    goto :goto_2

    .line 1432
    :cond_3
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getEnd()I

    move-result v6

    add-int/2addr v6, v2

    iput v6, v5, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    .line 1433
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    neg-int v6, v0

    iput v6, v5, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    .line 1435
    :goto_2
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput-boolean v1, v5, Landroid/support/v7/widget/LayoutState;->mStopInFocusable:Z

    .line 1436
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput-boolean v4, v5, Landroid/support/v7/widget/LayoutState;->mRecycle:Z

    .line 1437
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getMode()I

    move-result v6

    if-nez v6, :cond_4

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 1438
    invoke-virtual {v6}, Landroid/support/v7/widget/OrientationHelper;->getEnd()I

    move-result v6

    if-nez v6, :cond_4

    move v1, v4

    nop

    :cond_4
    iput-boolean v1, v5, Landroid/support/v7/widget/LayoutState;->mInfinite:Z

    .line 1439
    return-void
.end method

.method private updateRemainingSpans(Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;II)V
    .locals 5
    .param p1, "span"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    .param p2, "layoutDir"    # I
    .param p3, "targetLine"    # I

    .line 1791
    invoke-virtual {p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getDeletedSize()I

    move-result v0

    .line 1792
    .local v0, "deletedSize":I
    const/4 v1, 0x0

    const/4 v2, -0x1

    if-ne p2, v2, :cond_1

    .line 1793
    invoke-virtual {p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine()I

    move-result v2

    .line 1794
    .local v2, "line":I
    add-int v3, v2, v0

    if-gt v3, p3, :cond_0

    .line 1795
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    iget v4, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    invoke-virtual {v3, v4, v1}, Ljava/util/BitSet;->set(IZ)V

    .line 1797
    .end local v2    # "line":I
    :cond_0
    goto :goto_0

    .line 1798
    :cond_1
    invoke-virtual {p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine()I

    move-result v2

    .line 1799
    .restart local v2    # "line":I
    sub-int v3, v2, v0

    if-lt v3, p3, :cond_2

    .line 1800
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    iget v4, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    invoke-virtual {v3, v4, v1}, Ljava/util/BitSet;->set(IZ)V

    .line 1803
    .end local v2    # "line":I
    :cond_2
    :goto_0
    return-void
.end method

.method private updateSpecWithExtra(III)I
    .locals 3
    .param p1, "spec"    # I
    .param p2, "startInset"    # I
    .param p3, "endInset"    # I

    .line 1170
    if-nez p2, :cond_0

    if-nez p3, :cond_0

    .line 1171
    return p1

    .line 1173
    :cond_0
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v0

    .line 1174
    .local v0, "mode":I
    const/high16 v1, -0x80000000

    if-eq v0, v1, :cond_2

    const/high16 v1, 0x40000000    # 2.0f

    if-ne v0, v1, :cond_1

    goto :goto_0

    .line 1178
    :cond_1
    return p1

    .line 1175
    :cond_2
    :goto_0
    const/4 v1, 0x0

    .line 1176
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v2

    sub-int/2addr v2, p2

    sub-int/2addr v2, p3

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1175
    invoke-static {v1, v0}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v1

    return v1
.end method


# virtual methods
.method areAllEndsEqual()Z
    .locals 6

    .line 1828
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    const/high16 v2, -0x80000000

    invoke-virtual {v0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v0

    .line 1829
    .local v0, "end":I
    const/4 v3, 0x1

    move v4, v3

    .line 1829
    .local v4, "i":I
    :goto_0
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v4, v5, :cond_1

    .line 1830
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v5, v5, v4

    invoke-virtual {v5, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v5

    if-eq v5, v0, :cond_0

    .line 1831
    return v1

    .line 1829
    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 1834
    .end local v4    # "i":I
    :cond_1
    return v3
.end method

.method areAllStartsEqual()Z
    .locals 6

    .line 1838
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    const/high16 v2, -0x80000000

    invoke-virtual {v0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v0

    .line 1839
    .local v0, "start":I
    const/4 v3, 0x1

    move v4, v3

    .line 1839
    .local v4, "i":I
    :goto_0
    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v4, v5, :cond_1

    .line 1840
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v5, v5, v4

    invoke-virtual {v5, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v5

    if-eq v5, v0, :cond_0

    .line 1841
    return v1

    .line 1839
    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 1844
    .end local v4    # "i":I
    :cond_1
    return v3
.end method

.method public assertNotInLayoutOrScroll(Ljava/lang/String;)V
    .locals 1
    .param p1, "message"    # Ljava/lang/String;

    .line 527
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-nez v0, :cond_0

    .line 528
    invoke-super {p0, p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->assertNotInLayoutOrScroll(Ljava/lang/String;)V

    .line 530
    :cond_0
    return-void
.end method

.method public canScrollHorizontally()Z
    .locals 1

    .line 1990
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public canScrollVertically()Z
    .locals 2

    .line 1985
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method checkForGaps()Z
    .locals 8

    .line 270
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_7

    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-eqz v0, :cond_7

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isAttachedToWindow()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_3

    .line 274
    :cond_0
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v0, :cond_1

    .line 275
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v0

    .line 276
    .local v0, "minPos":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v2

    .line 276
    .local v2, "maxPos":I
    goto :goto_0

    .line 278
    .end local v0    # "minPos":I
    .end local v2    # "maxPos":I
    :cond_1
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v0

    .line 279
    .restart local v0    # "minPos":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v2

    .line 281
    .restart local v2    # "maxPos":I
    :goto_0
    const/4 v3, 0x1

    if-nez v0, :cond_2

    .line 282
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->hasGapsToFix()Landroid/view/View;

    move-result-object v4

    .line 283
    .local v4, "gapView":Landroid/view/View;
    if-eqz v4, :cond_2

    .line 284
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->clear()V

    .line 285
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestSimpleAnimationsInNextLayout()V

    .line 286
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 287
    return v3

    .line 290
    .end local v4    # "gapView":Landroid/view/View;
    :cond_2
    iget-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    if-nez v4, :cond_3

    .line 291
    return v1

    .line 293
    :cond_3
    iget-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v4, :cond_4

    const/4 v4, -0x1

    goto :goto_1

    :cond_4
    move v4, v3

    .line 294
    .local v4, "invalidGapDir":I
    :goto_1
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    add-int/lit8 v6, v2, 0x1

    .line 295
    invoke-virtual {v5, v0, v6, v4, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->getFirstFullSpanItemInRange(IIIZ)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v5

    .line 296
    .local v5, "invalidFsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    if-nez v5, :cond_5

    .line 297
    iput-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLaidOutInvalidFullSpan:Z

    .line 298
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    add-int/lit8 v6, v2, 0x1

    invoke-virtual {v3, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->forceInvalidateAfter(I)I

    .line 299
    return v1

    .line 301
    :cond_5
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget v6, v5, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    mul-int/lit8 v7, v4, -0x1

    .line 302
    invoke-virtual {v1, v0, v6, v7, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->getFirstFullSpanItemInRange(IIIZ)Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v1

    .line 304
    .local v1, "validFsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    if-nez v1, :cond_6

    .line 305
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget v7, v5, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    invoke-virtual {v6, v7}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->forceInvalidateAfter(I)I

    goto :goto_2

    .line 307
    :cond_6
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget v7, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    add-int/2addr v7, v3

    invoke-virtual {v6, v7}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->forceInvalidateAfter(I)I

    .line 309
    :goto_2
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestSimpleAnimationsInNextLayout()V

    .line 310
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 311
    return v3

    .line 271
    .end local v0    # "minPos":I
    .end local v1    # "validFsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    .end local v2    # "maxPos":I
    .end local v4    # "invalidGapDir":I
    .end local v5    # "invalidFsi":Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_7
    :goto_3
    return v1
.end method

.method public checkLayoutParams(Landroid/support/v7/widget/RecyclerView$LayoutParams;)Z
    .locals 1
    .param p1, "lp"    # Landroid/support/v7/widget/RecyclerView$LayoutParams;

    .line 2235
    instance-of v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    return v0
.end method

.method public collectAdjacentPrefetchPositions(IILandroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/RecyclerView$LayoutManager$LayoutPrefetchRegistry;)V
    .locals 7
    .param p1, "dx"    # I
    .param p2, "dy"    # I
    .param p3, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p4, "layoutPrefetchRegistry"    # Landroid/support/v7/widget/RecyclerView$LayoutManager$LayoutPrefetchRegistry;

    .line 2085
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-nez v0, :cond_0

    move v0, p1

    goto :goto_0

    :cond_0
    move v0, p2

    .line 2086
    .local v0, "delta":I
    :goto_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v1

    if-eqz v1, :cond_8

    if-nez v0, :cond_1

    goto/16 :goto_4

    .line 2090
    :cond_1
    invoke-virtual {p0, v0, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->prepareLayoutStateForDelta(ILandroid/support/v7/widget/RecyclerView$State;)V

    .line 2093
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    if-eqz v1, :cond_2

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    array-length v1, v1

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_3

    .line 2094
    :cond_2
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array v1, v1, [I

    iput-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    .line 2097
    :cond_3
    const/4 v1, 0x0

    .line 2098
    .local v1, "itemPrefetchCount":I
    const/4 v2, 0x0

    move v3, v1

    move v1, v2

    .line 2098
    .local v1, "i":I
    .local v3, "itemPrefetchCount":I
    :goto_1
    iget v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v4, :cond_6

    .line 2100
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v4, v4, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    const/4 v5, -0x1

    if-ne v4, v5, :cond_4

    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v4, v4, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v5, v5, v1

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v6, v6, Landroid/support/v7/widget/LayoutState;->mStartLine:I

    .line 2101
    invoke-virtual {v5, v6}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v5

    sub-int/2addr v4, v5

    goto :goto_2

    :cond_4
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v4, v4, v1

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v5, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    .line 2102
    invoke-virtual {v4, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v4

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v5, Landroid/support/v7/widget/LayoutState;->mEndLine:I

    sub-int/2addr v4, v5

    .line 2103
    .local v4, "distance":I
    :goto_2
    if-ltz v4, :cond_5

    .line 2105
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    aput v4, v5, v3

    .line 2106
    add-int/lit8 v3, v3, 0x1

    .line 2098
    .end local v4    # "distance":I
    :cond_5
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 2109
    .end local v1    # "i":I
    :cond_6
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    invoke-static {v1, v2, v3}, Ljava/util/Arrays;->sort([III)V

    .line 2112
    nop

    .line 2112
    .local v2, "i":I
    :goto_3
    move v1, v2

    .line 2112
    .end local v2    # "i":I
    .restart local v1    # "i":I
    if-ge v1, v3, :cond_7

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-virtual {v2, p3}, Landroid/support/v7/widget/LayoutState;->hasMore(Landroid/support/v7/widget/RecyclerView$State;)Z

    move-result v2

    if-eqz v2, :cond_7

    .line 2113
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v2, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrefetchDistances:[I

    aget v4, v4, v1

    invoke-interface {p4, v2, v4}, Landroid/support/v7/widget/RecyclerView$LayoutManager$LayoutPrefetchRegistry;->addPosition(II)V

    .line 2115
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v4, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v5, v5, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    add-int/2addr v4, v5

    iput v4, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 2112
    add-int/lit8 v2, v1, 0x1

    .line 2112
    .end local v1    # "i":I
    .restart local v2    # "i":I
    goto :goto_3

    .line 2117
    .end local v2    # "i":I
    :cond_7
    return-void

    .line 2088
    .end local v3    # "itemPrefetchCount":I
    :cond_8
    :goto_4
    return-void
.end method

.method public computeHorizontalScrollExtent(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1087
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollExtent(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public computeHorizontalScrollOffset(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1067
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollOffset(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public computeHorizontalScrollRange(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1107
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollRange(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public computeScrollVectorForPosition(I)Landroid/graphics/PointF;
    .locals 4
    .param p1, "targetPosition"    # I

    .line 2015
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->calculateScrollDirectionForPosition(I)I

    move-result v0

    .line 2016
    .local v0, "direction":I
    new-instance v1, Landroid/graphics/PointF;

    invoke-direct {v1}, Landroid/graphics/PointF;-><init>()V

    .line 2017
    .local v1, "outVector":Landroid/graphics/PointF;
    if-nez v0, :cond_0

    .line 2018
    const/4 v2, 0x0

    return-object v2

    .line 2020
    :cond_0
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v3, 0x0

    if-nez v2, :cond_1

    .line 2021
    int-to-float v2, v0

    iput v2, v1, Landroid/graphics/PointF;->x:F

    .line 2022
    iput v3, v1, Landroid/graphics/PointF;->y:F

    goto :goto_0

    .line 2024
    :cond_1
    iput v3, v1, Landroid/graphics/PointF;->x:F

    .line 2025
    int-to-float v2, v0

    iput v2, v1, Landroid/graphics/PointF;->y:F

    .line 2027
    :goto_0
    return-object v1
.end method

.method public computeVerticalScrollExtent(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1102
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollExtent(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public computeVerticalScrollOffset(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1082
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollOffset(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public computeVerticalScrollRange(Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1122
    invoke-direct {p0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->computeScrollRange(Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public findFirstCompletelyVisibleItemPositions([I)[I
    .locals 3
    .param p1, "into"    # [I

    .line 989
    if-nez p1, :cond_0

    .line 990
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array p1, v0, [I

    goto :goto_0

    .line 991
    :cond_0
    array-length v0, p1

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_1

    .line 992
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Provided int[]\'s size must be more than or equal to span count. Expected:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", array size:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v2, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 995
    :cond_1
    :goto_0
    const/4 v0, 0x0

    .line 995
    .local v0, "i":I
    :goto_1
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_2

    .line 996
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findFirstCompletelyVisibleItemPosition()I

    move-result v1

    aput v1, p1, v0

    .line 995
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 998
    .end local v0    # "i":I
    :cond_2
    return-object p1
.end method

.method findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;
    .locals 7
    .param p1, "fullyVisible"    # Z

    .line 1350
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v0

    .line 1351
    .local v0, "boundsStart":I
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v1

    .line 1352
    .local v1, "boundsEnd":I
    const/4 v2, 0x0

    .line 1353
    .local v2, "partiallyVisible":Landroid/view/View;
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v3

    add-int/lit8 v3, v3, -0x1

    .line 1353
    .local v3, "i":I
    :goto_0
    if-ltz v3, :cond_4

    .line 1354
    invoke-virtual {p0, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 1355
    .local v4, "child":Landroid/view/View;
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5, v4}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v5

    .line 1356
    .local v5, "childStart":I
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6, v4}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v6

    .line 1357
    .local v6, "childEnd":I
    if-le v6, v0, :cond_3

    if-lt v5, v1, :cond_0

    .line 1358
    goto :goto_2

    .line 1360
    :cond_0
    if-le v6, v1, :cond_2

    if-nez p1, :cond_1

    goto :goto_1

    .line 1365
    :cond_1
    if-nez v2, :cond_3

    .line 1366
    move-object v2, v4

    .line 1366
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "childStart":I
    .end local v6    # "childEnd":I
    goto :goto_2

    .line 1363
    .restart local v4    # "child":Landroid/view/View;
    .restart local v5    # "childStart":I
    .restart local v6    # "childEnd":I
    :cond_2
    :goto_1
    return-object v4

    .line 1353
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "childStart":I
    .end local v6    # "childEnd":I
    :cond_3
    :goto_2
    add-int/lit8 v3, v3, -0x1

    goto :goto_0

    .line 1369
    .end local v3    # "i":I
    :cond_4
    return-object v2
.end method

.method findFirstVisibleItemClosestToStart(Z)Landroid/view/View;
    .locals 8
    .param p1, "fullyVisible"    # Z

    .line 1320
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v0

    .line 1321
    .local v0, "boundsStart":I
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v1

    .line 1322
    .local v1, "boundsEnd":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v2

    .line 1323
    .local v2, "limit":I
    const/4 v3, 0x0

    .line 1324
    .local v3, "partiallyVisible":Landroid/view/View;
    const/4 v4, 0x0

    .line 1324
    .local v4, "i":I
    :goto_0
    if-ge v4, v2, :cond_4

    .line 1325
    invoke-virtual {p0, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 1326
    .local v5, "child":Landroid/view/View;
    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v6, v5}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v6

    .line 1327
    .local v6, "childStart":I
    iget-object v7, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v7, v5}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v7

    .line 1328
    .local v7, "childEnd":I
    if-le v7, v0, :cond_3

    if-lt v6, v1, :cond_0

    .line 1329
    goto :goto_2

    .line 1331
    :cond_0
    if-ge v6, v0, :cond_2

    if-nez p1, :cond_1

    goto :goto_1

    .line 1336
    :cond_1
    if-nez v3, :cond_3

    .line 1337
    move-object v3, v5

    .line 1337
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "childStart":I
    .end local v7    # "childEnd":I
    goto :goto_2

    .line 1334
    .restart local v5    # "child":Landroid/view/View;
    .restart local v6    # "childStart":I
    .restart local v7    # "childEnd":I
    :cond_2
    :goto_1
    return-object v5

    .line 1324
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "childStart":I
    .end local v7    # "childEnd":I
    :cond_3
    :goto_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 1340
    .end local v4    # "i":I
    :cond_4
    return-object v3
.end method

.method findFirstVisibleItemPositionInt()I
    .locals 2

    .line 1290
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;

    move-result-object v0

    goto :goto_0

    .line 1291
    :cond_0
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToStart(Z)Landroid/view/View;

    move-result-object v0

    .line 1292
    .local v0, "first":Landroid/view/View;
    :goto_0
    if-nez v0, :cond_1

    const/4 v1, -0x1

    goto :goto_1

    :cond_1
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v1

    :goto_1
    return v1
.end method

.method public findFirstVisibleItemPositions([I)[I
    .locals 3
    .param p1, "into"    # [I

    .line 957
    if-nez p1, :cond_0

    .line 958
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array p1, v0, [I

    goto :goto_0

    .line 959
    :cond_0
    array-length v0, p1

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_1

    .line 960
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Provided int[]\'s size must be more than or equal to span count. Expected:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", array size:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v2, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 963
    :cond_1
    :goto_0
    const/4 v0, 0x0

    .line 963
    .local v0, "i":I
    :goto_1
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_2

    .line 964
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findFirstVisibleItemPosition()I

    move-result v1

    aput v1, p1, v0

    .line 963
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 966
    .end local v0    # "i":I
    :cond_2
    return-object p1
.end method

.method public findLastCompletelyVisibleItemPositions([I)[I
    .locals 3
    .param p1, "into"    # [I

    .line 1053
    if-nez p1, :cond_0

    .line 1054
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array p1, v0, [I

    goto :goto_0

    .line 1055
    :cond_0
    array-length v0, p1

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_1

    .line 1056
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Provided int[]\'s size must be more than or equal to span count. Expected:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", array size:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v2, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1059
    :cond_1
    :goto_0
    const/4 v0, 0x0

    .line 1059
    .local v0, "i":I
    :goto_1
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_2

    .line 1060
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findLastCompletelyVisibleItemPosition()I

    move-result v1

    aput v1, p1, v0

    .line 1059
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 1062
    .end local v0    # "i":I
    :cond_2
    return-object p1
.end method

.method public findLastVisibleItemPositions([I)[I
    .locals 3
    .param p1, "into"    # [I

    .line 1021
    if-nez p1, :cond_0

    .line 1022
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array p1, v0, [I

    goto :goto_0

    .line 1023
    :cond_0
    array-length v0, p1

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_1

    .line 1024
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Provided int[]\'s size must be more than or equal to span count. Expected:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", array size:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v2, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1027
    :cond_1
    :goto_0
    const/4 v0, 0x0

    .line 1027
    .local v0, "i":I
    :goto_1
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_2

    .line 1028
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findLastVisibleItemPosition()I

    move-result v1

    aput v1, p1, v0

    .line 1027
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 1030
    .end local v0    # "i":I
    :cond_2
    return-object p1
.end method

.method public generateDefaultLayoutParams()Landroid/support/v7/widget/RecyclerView$LayoutParams;
    .locals 3

    .line 2210
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v1, -0x1

    const/4 v2, -0x2

    if-nez v0, :cond_0

    .line 2211
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    invoke-direct {v0, v2, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;-><init>(II)V

    return-object v0

    .line 2214
    :cond_0
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    invoke-direct {v0, v1, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method public generateLayoutParams(Landroid/content/Context;Landroid/util/AttributeSet;)Landroid/support/v7/widget/RecyclerView$LayoutParams;
    .locals 1
    .param p1, "c"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 2221
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    invoke-direct {v0, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method public generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/v7/widget/RecyclerView$LayoutParams;
    .locals 2
    .param p1, "lp"    # Landroid/view/ViewGroup$LayoutParams;

    .line 2226
    instance-of v0, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v0, :cond_0

    .line 2227
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    move-object v1, p1

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    invoke-direct {v0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;-><init>(Landroid/view/ViewGroup$MarginLayoutParams;)V

    return-object v0

    .line 2229
    :cond_0
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    invoke-direct {v0, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;-><init>(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public getColumnCountForAccessibility(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 2
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1307
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1308
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    return v0

    .line 1310
    :cond_0
    invoke-super {p0, p1, p2}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getColumnCountForAccessibility(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method getFirstChildPosition()I
    .locals 2

    .line 2170
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    .line 2171
    .local v0, "childCount":I
    const/4 v1, 0x0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v1

    :goto_0
    return v1
.end method

.method public getGapStrategy()I
    .locals 1

    .line 498
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    return v0
.end method

.method getLastChildPosition()I
    .locals 2

    .line 2165
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    .line 2166
    .local v0, "childCount":I
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    add-int/lit8 v1, v0, -0x1

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v1

    :goto_0
    return v1
.end method

.method public getOrientation()I
    .locals 1

    .line 2239
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    return v0
.end method

.method public getReverseLayout()Z
    .locals 1

    .line 579
    iget-boolean v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    return v0
.end method

.method public getRowCountForAccessibility(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1298
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-nez v0, :cond_0

    .line 1299
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    return v0

    .line 1301
    :cond_0
    invoke-super {p0, p1, p2}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->getRowCountForAccessibility(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public getSpanCount()I
    .locals 1

    .line 538
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    return v0
.end method

.method hasGapsToFix()Landroid/view/View;
    .locals 17

    .line 337
    move-object/from16 v0, p0

    const/4 v1, 0x0

    .line 338
    .local v1, "startChildIndex":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v2

    const/4 v3, 0x1

    sub-int/2addr v2, v3

    .line 339
    .local v2, "endChildIndex":I
    new-instance v4, Ljava/util/BitSet;

    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-direct {v4, v5}, Ljava/util/BitSet;-><init>(I)V

    .line 340
    .local v4, "mSpansToCheck":Ljava/util/BitSet;
    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    const/4 v6, 0x0

    invoke-virtual {v4, v6, v5, v3}, Ljava/util/BitSet;->set(IIZ)V

    .line 343
    iget v5, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v7, -0x1

    if-ne v5, v3, :cond_0

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->isLayoutRTL()Z

    move-result v5

    if-eqz v5, :cond_0

    move v5, v3

    goto :goto_0

    :cond_0
    move v5, v7

    .line 345
    .local v5, "preferredSpanDir":I
    :goto_0
    iget-boolean v8, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v8, :cond_1

    .line 346
    move v8, v2

    .line 347
    .local v8, "firstChildIndex":I
    add-int/lit8 v9, v1, -0x1

    .line 347
    .local v9, "childLimit":I
    goto :goto_1

    .line 349
    .end local v8    # "firstChildIndex":I
    .end local v9    # "childLimit":I
    :cond_1
    move v8, v1

    .line 350
    .restart local v8    # "firstChildIndex":I
    add-int/lit8 v9, v2, 0x1

    .line 352
    .restart local v9    # "childLimit":I
    :goto_1
    if-ge v8, v9, :cond_2

    move v7, v3

    nop

    .line 353
    .local v7, "nextChildDiff":I
    :cond_2
    move v10, v8

    .line 353
    .local v10, "i":I
    :goto_2
    if-eq v10, v9, :cond_e

    .line 354
    invoke-virtual {v0, v10}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v11

    .line 355
    .local v11, "child":Landroid/view/View;
    invoke-virtual {v11}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v12

    check-cast v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 356
    .local v12, "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-object v13, v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v13, v13, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    invoke-virtual {v4, v13}, Ljava/util/BitSet;->get(I)Z

    move-result v13

    if-eqz v13, :cond_4

    .line 357
    iget-object v13, v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-direct {v0, v13}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->checkSpanForGap(Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;)Z

    move-result v13

    if-eqz v13, :cond_3

    .line 358
    return-object v11

    .line 360
    :cond_3
    iget-object v13, v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v13, v13, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    invoke-virtual {v4, v13}, Ljava/util/BitSet;->clear(I)V

    .line 362
    :cond_4
    iget-boolean v13, v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v13, :cond_5

    .line 363
    goto :goto_6

    .line 366
    :cond_5
    add-int v13, v10, v7

    if-eq v13, v9, :cond_d

    .line 367
    add-int v13, v10, v7

    invoke-virtual {v0, v13}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    .line 368
    .local v13, "nextChild":Landroid/view/View;
    const/4 v14, 0x0

    .line 369
    .local v14, "compareSpans":Z
    iget-boolean v15, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v15, :cond_8

    .line 371
    iget-object v15, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v15, v11}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v15

    .line 372
    .local v15, "myEnd":I
    iget-object v3, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3, v13}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v3

    .line 373
    .local v3, "nextEnd":I
    if-ge v15, v3, :cond_6

    .line 374
    return-object v11

    .line 375
    :cond_6
    if-ne v15, v3, :cond_7

    .line 376
    const/4 v3, 0x1

    .line 378
    .end local v14    # "compareSpans":Z
    .end local v15    # "myEnd":I
    .local v3, "compareSpans":Z
    move v14, v3

    .line 378
    .end local v3    # "compareSpans":Z
    .restart local v14    # "compareSpans":Z
    :cond_7
    goto :goto_3

    .line 379
    :cond_8
    iget-object v3, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3, v11}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v3

    .line 380
    .local v3, "myStart":I
    iget-object v15, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v15, v13}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v15

    .line 381
    .local v15, "nextStart":I
    if-le v3, v15, :cond_9

    .line 382
    return-object v11

    .line 383
    :cond_9
    if-ne v3, v15, :cond_a

    .line 384
    const/4 v14, 0x1

    .line 387
    .end local v3    # "myStart":I
    .end local v15    # "nextStart":I
    :cond_a
    :goto_3
    if-eqz v14, :cond_d

    .line 389
    invoke-virtual {v13}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 390
    .local v3, "nextLp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-object v15, v12, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v15, v15, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    iget-object v6, v3, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iget v6, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    sub-int/2addr v15, v6

    if-gez v15, :cond_b

    const/4 v6, 0x1

    goto :goto_4

    :cond_b
    const/4 v6, 0x0

    :goto_4
    if-gez v5, :cond_c

    const/4 v15, 0x1

    goto :goto_5

    :cond_c
    const/4 v15, 0x0

    :goto_5
    if-eq v6, v15, :cond_d

    .line 391
    return-object v11

    .line 353
    .end local v3    # "nextLp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .end local v11    # "child":Landroid/view/View;
    .end local v12    # "lp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    .end local v13    # "nextChild":Landroid/view/View;
    .end local v14    # "compareSpans":Z
    :cond_d
    :goto_6
    add-int/2addr v10, v7

    const/4 v3, 0x1

    const/4 v6, 0x0

    goto/16 :goto_2

    .line 397
    .end local v10    # "i":I
    :cond_e
    const/4 v3, 0x0

    return-object v3
.end method

.method public invalidateSpanAssignments()V
    .locals 1

    .line 548
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->clear()V

    .line 549
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 550
    return-void
.end method

.method isLayoutRTL()Z
    .locals 2

    .line 567
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLayoutDirection()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public offsetChildrenHorizontal(I)V
    .locals 2
    .param p1, "dx"    # I

    .line 1449
    invoke-super {p0, p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->offsetChildrenHorizontal(I)V

    .line 1450
    const/4 v0, 0x0

    .line 1450
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_0

    .line 1451
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->onOffset(I)V

    .line 1450
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1453
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method public offsetChildrenVertical(I)V
    .locals 2
    .param p1, "dy"    # I

    .line 1457
    invoke-super {p0, p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->offsetChildrenVertical(I)V

    .line 1458
    const/4 v0, 0x0

    .line 1458
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_0

    .line 1459
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1, p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->onOffset(I)V

    .line 1458
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1461
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method public onDetachedFromWindow(Landroid/support/v7/widget/RecyclerView;Landroid/support/v7/widget/RecyclerView$Recycler;)V
    .locals 2
    .param p1, "view"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;

    .line 323
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mCheckForGapsRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 324
    const/4 v0, 0x0

    .line 324
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_0

    .line 325
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v1, v1, v0

    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->clear()V

    .line 324
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 328
    .end local v0    # "i":I
    :cond_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->requestLayout()V

    .line 329
    return-void
.end method

.method public onFocusSearchFailed(Landroid/view/View;ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)Landroid/view/View;
    .locals 16
    .param p1, "focused"    # Landroid/view/View;
    .param p2, "direction"    # I
    .param p3, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p4, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    move-object/from16 v0, p0

    .line 2246
    move-object/from16 v1, p4

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_0

    .line 2247
    return-object v3

    .line 2250
    :cond_0
    invoke-virtual/range {p0 .. p1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findContainingItemView(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 2251
    .local v2, "directChild":Landroid/view/View;
    if-nez v2, :cond_1

    .line 2252
    return-object v3

    .line 2255
    :cond_1
    invoke-direct/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->resolveShouldLayoutReverse()V

    .line 2256
    move/from16 v4, p2

    invoke-direct {v0, v4}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->convertFocusDirectionToLayoutDirection(I)I

    move-result v5

    .line 2257
    .local v5, "layoutDir":I
    const/high16 v6, -0x80000000

    if-ne v5, v6, :cond_2

    .line 2258
    return-object v3

    .line 2260
    :cond_2
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 2261
    .local v6, "prevFocusLayoutParams":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget-boolean v7, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    .line 2262
    .local v7, "prevFocusFullSpan":Z
    iget-object v8, v6, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mSpan:Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    .line 2264
    .local v8, "prevFocusSpan":Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;
    const/4 v9, 0x1

    if-ne v5, v9, :cond_3

    .line 2265
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v10

    .line 2265
    .local v10, "referenceChildPosition":I
    goto :goto_0

    .line 2267
    .end local v10    # "referenceChildPosition":I
    :cond_3
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v10

    .line 2269
    .restart local v10    # "referenceChildPosition":I
    :goto_0
    invoke-direct {v0, v10, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateLayoutState(ILandroid/support/v7/widget/RecyclerView$State;)V

    .line 2270
    invoke-direct {v0, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 2272
    iget-object v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v12, v12, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    add-int/2addr v12, v10

    iput v12, v11, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 2273
    iget-object v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    const v12, 0x3eaaaaab

    iget-object v13, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v13}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v13

    int-to-float v13, v13

    mul-float/2addr v13, v12

    float-to-int v12, v13

    iput v12, v11, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    .line 2274
    iget-object v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput-boolean v9, v11, Landroid/support/v7/widget/LayoutState;->mStopInFocusable:Z

    .line 2275
    iget-object v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    const/4 v12, 0x0

    iput-boolean v12, v11, Landroid/support/v7/widget/LayoutState;->mRecycle:Z

    .line 2276
    iget-object v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    move-object/from16 v13, p3

    invoke-direct {v0, v13, v11, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    .line 2277
    iget-boolean v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    iput-boolean v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    .line 2278
    if-nez v7, :cond_4

    .line 2279
    invoke-virtual {v8, v10, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getFocusableViewAfter(II)Landroid/view/View;

    move-result-object v11

    .line 2280
    .local v11, "view":Landroid/view/View;
    if-eqz v11, :cond_4

    if-eq v11, v2, :cond_4

    .line 2281
    return-object v11

    .line 2287
    .end local v11    # "view":Landroid/view/View;
    :cond_4
    invoke-direct {v0, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->preferLastSpan(I)Z

    move-result v11

    if-eqz v11, :cond_6

    .line 2288
    iget v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v11, v9

    .line 2288
    .local v11, "i":I
    :goto_1
    if-ltz v11, :cond_8

    .line 2289
    iget-object v14, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v14, v14, v11

    invoke-virtual {v14, v10, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getFocusableViewAfter(II)Landroid/view/View;

    move-result-object v14

    .line 2290
    .local v14, "view":Landroid/view/View;
    if-eqz v14, :cond_5

    if-eq v14, v2, :cond_5

    .line 2291
    return-object v14

    .line 2288
    .end local v14    # "view":Landroid/view/View;
    :cond_5
    add-int/lit8 v11, v11, -0x1

    goto :goto_1

    .line 2295
    .end local v11    # "i":I
    :cond_6
    move v11, v12

    .line 2295
    .restart local v11    # "i":I
    :goto_2
    iget v14, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v11, v14, :cond_8

    .line 2296
    iget-object v14, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v14, v14, v11

    invoke-virtual {v14, v10, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getFocusableViewAfter(II)Landroid/view/View;

    move-result-object v14

    .line 2297
    .restart local v14    # "view":Landroid/view/View;
    if-eqz v14, :cond_7

    if-eq v14, v2, :cond_7

    .line 2298
    return-object v14

    .line 2295
    .end local v14    # "view":Landroid/view/View;
    :cond_7
    add-int/lit8 v11, v11, 0x1

    goto :goto_2

    .line 2307
    .end local v11    # "i":I
    :cond_8
    iget-boolean v11, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    xor-int/2addr v11, v9

    const/4 v14, -0x1

    if-ne v5, v14, :cond_9

    move v14, v9

    goto :goto_3

    :cond_9
    move v14, v12

    :goto_3
    if-ne v11, v14, :cond_a

    move v11, v9

    goto :goto_4

    :cond_a
    move v11, v12

    .line 2308
    .local v11, "shouldSearchFromStart":Z
    :goto_4
    const/4 v14, 0x0

    .line 2309
    .local v14, "unfocusableCandidate":Landroid/view/View;
    if-nez v7, :cond_c

    .line 2310
    if-eqz v11, :cond_b

    .line 2311
    invoke-virtual {v8}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findFirstPartiallyVisibleItemPosition()I

    move-result v15

    goto :goto_5

    .line 2312
    :cond_b
    invoke-virtual {v8}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findLastPartiallyVisibleItemPosition()I

    move-result v15

    .line 2310
    :goto_5
    invoke-virtual {v0, v15}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findViewByPosition(I)Landroid/view/View;

    move-result-object v14

    .line 2313
    if-eqz v14, :cond_c

    if-eq v14, v2, :cond_c

    .line 2314
    return-object v14

    .line 2318
    :cond_c
    invoke-direct {v0, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->preferLastSpan(I)Z

    move-result v15

    if-eqz v15, :cond_10

    .line 2319
    iget v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    sub-int/2addr v12, v9

    .line 2319
    .local v12, "i":I
    :goto_6
    move v9, v12

    .line 2319
    .end local v12    # "i":I
    .local v9, "i":I
    if-ltz v9, :cond_13

    .line 2320
    iget v12, v8, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    if-ne v9, v12, :cond_d

    .line 2321
    goto :goto_8

    .line 2323
    :cond_d
    if-eqz v11, :cond_e

    iget-object v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v12, v12, v9

    .line 2324
    invoke-virtual {v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findFirstPartiallyVisibleItemPosition()I

    move-result v12

    goto :goto_7

    :cond_e
    iget-object v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v12, v12, v9

    .line 2325
    invoke-virtual {v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findLastPartiallyVisibleItemPosition()I

    move-result v12

    .line 2323
    :goto_7
    invoke-virtual {v0, v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findViewByPosition(I)Landroid/view/View;

    move-result-object v12

    .line 2326
    .end local v14    # "unfocusableCandidate":Landroid/view/View;
    .local v12, "unfocusableCandidate":Landroid/view/View;
    if-eqz v12, :cond_f

    if-eq v12, v2, :cond_f

    .line 2327
    return-object v12

    .line 2319
    :cond_f
    move-object v14, v12

    .line 2319
    .end local v12    # "unfocusableCandidate":Landroid/view/View;
    .restart local v14    # "unfocusableCandidate":Landroid/view/View;
    :goto_8
    add-int/lit8 v12, v9, -0x1

    .line 2319
    .end local v9    # "i":I
    .local v12, "i":I
    goto :goto_6

    .line 2331
    .end local v12    # "i":I
    :cond_10
    nop

    .line 2331
    .restart local v12    # "i":I
    :goto_9
    move v9, v12

    .line 2331
    .end local v12    # "i":I
    .restart local v9    # "i":I
    iget v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v9, v12, :cond_13

    .line 2332
    if-eqz v11, :cond_11

    iget-object v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v12, v12, v9

    .line 2333
    invoke-virtual {v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findFirstPartiallyVisibleItemPosition()I

    move-result v12

    goto :goto_a

    :cond_11
    iget-object v12, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v12, v12, v9

    .line 2334
    invoke-virtual {v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->findLastPartiallyVisibleItemPosition()I

    move-result v12

    .line 2332
    :goto_a
    invoke-virtual {v0, v12}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findViewByPosition(I)Landroid/view/View;

    move-result-object v14

    .line 2335
    if-eqz v14, :cond_12

    if-eq v14, v2, :cond_12

    .line 2336
    return-object v14

    .line 2331
    :cond_12
    add-int/lit8 v12, v9, 0x1

    .line 2331
    .end local v9    # "i":I
    .restart local v12    # "i":I
    goto :goto_9

    .line 2340
    .end local v12    # "i":I
    :cond_13
    return-object v3
.end method

.method public onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 4
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 1265
    invoke-super {p0, p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V

    .line 1266
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    if-lez v0, :cond_3

    .line 1267
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToStart(Z)Landroid/view/View;

    move-result-object v1

    .line 1268
    .local v1, "start":Landroid/view/View;
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemClosestToEnd(Z)Landroid/view/View;

    move-result-object v0

    .line 1269
    .local v0, "end":Landroid/view/View;
    if-eqz v1, :cond_2

    if-nez v0, :cond_0

    goto :goto_0

    .line 1272
    :cond_0
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v2

    .line 1273
    .local v2, "startPos":I
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPosition(Landroid/view/View;)I

    move-result v3

    .line 1274
    .local v3, "endPos":I
    if-ge v2, v3, :cond_1

    .line 1275
    invoke-virtual {p1, v2}, Landroid/view/accessibility/AccessibilityEvent;->setFromIndex(I)V

    .line 1276
    invoke-virtual {p1, v3}, Landroid/view/accessibility/AccessibilityEvent;->setToIndex(I)V

    goto :goto_1

    .line 1278
    :cond_1
    invoke-virtual {p1, v3}, Landroid/view/accessibility/AccessibilityEvent;->setFromIndex(I)V

    .line 1279
    invoke-virtual {p1, v2}, Landroid/view/accessibility/AccessibilityEvent;->setToIndex(I)V

    .line 1279
    .end local v0    # "end":Landroid/view/View;
    .end local v1    # "start":Landroid/view/View;
    .end local v2    # "startPos":I
    .end local v3    # "endPos":I
    goto :goto_1

    .line 1270
    .restart local v0    # "end":Landroid/view/View;
    .restart local v1    # "start":Landroid/view/View;
    :cond_2
    :goto_0
    return-void

    .line 1282
    .end local v0    # "end":Landroid/view/View;
    .end local v1    # "start":Landroid/view/View;
    :cond_3
    :goto_1
    return-void
.end method

.method public onInitializeAccessibilityNodeInfoForItem(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Landroid/view/View;Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;)V
    .locals 10
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p3, "host"    # Landroid/view/View;
    .param p4, "info"    # Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;

    .line 1244
    invoke-virtual {p3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 1245
    .local v0, "lp":Landroid/view/ViewGroup$LayoutParams;
    instance-of v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    if-nez v1, :cond_0

    .line 1246
    invoke-super {p0, p3, p4}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->onInitializeAccessibilityNodeInfoForItem(Landroid/view/View;Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;)V

    .line 1247
    return-void

    .line 1249
    :cond_0
    move-object v1, v0

    check-cast v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;

    .line 1250
    .local v1, "sglp":Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v3, 0x1

    if-nez v2, :cond_2

    .line 1251
    nop

    .line 1252
    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->getSpanIndex()I

    move-result v4

    iget-boolean v2, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v2, :cond_1

    iget v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    :goto_0
    move v5, v3

    goto :goto_1

    :cond_1
    goto :goto_0

    :goto_1
    const/4 v6, -0x1

    const/4 v7, -0x1

    iget-boolean v8, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    const/4 v9, 0x0

    .line 1251
    invoke-static/range {v4 .. v9}, Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat$CollectionItemInfoCompat;->obtain(IIIIZZ)Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat$CollectionItemInfoCompat;

    move-result-object v2

    invoke-virtual {p4, v2}, Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;->setCollectionItemInfo(Ljava/lang/Object;)V

    goto :goto_4

    .line 1256
    :cond_2
    const/4 v2, -0x1

    const/4 v4, -0x1

    .line 1258
    invoke-virtual {v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->getSpanIndex()I

    move-result v5

    iget-boolean v6, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    if-eqz v6, :cond_3

    iget v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    :goto_2
    move v6, v3

    goto :goto_3

    :cond_3
    goto :goto_2

    :goto_3
    iget-boolean v7, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LayoutParams;->mFullSpan:Z

    const/4 v8, 0x0

    .line 1256
    move v3, v2

    invoke-static/range {v3 .. v8}, Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat$CollectionItemInfoCompat;->obtain(IIIIZZ)Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat$CollectionItemInfoCompat;

    move-result-object v2

    invoke-virtual {p4, v2}, Landroid/support/v4/view/accessibility/AccessibilityNodeInfoCompat;->setCollectionItemInfo(Ljava/lang/Object;)V

    .line 1261
    :goto_4
    return-void
.end method

.method public onItemsAdded(Landroid/support/v7/widget/RecyclerView;II)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "positionStart"    # I
    .param p3, "itemCount"    # I

    .line 1470
    const/4 v0, 0x1

    invoke-direct {p0, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->handleUpdate(III)V

    .line 1471
    return-void
.end method

.method public onItemsChanged(Landroid/support/v7/widget/RecyclerView;)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;

    .line 1475
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->clear()V

    .line 1476
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 1477
    return-void
.end method

.method public onItemsMoved(Landroid/support/v7/widget/RecyclerView;III)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "from"    # I
    .param p3, "to"    # I
    .param p4, "itemCount"    # I

    .line 1481
    const/16 v0, 0x8

    invoke-direct {p0, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->handleUpdate(III)V

    .line 1482
    return-void
.end method

.method public onItemsRemoved(Landroid/support/v7/widget/RecyclerView;II)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "positionStart"    # I
    .param p3, "itemCount"    # I

    .line 1465
    const/4 v0, 0x2

    invoke-direct {p0, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->handleUpdate(III)V

    .line 1466
    return-void
.end method

.method public onItemsUpdated(Landroid/support/v7/widget/RecyclerView;IILjava/lang/Object;)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "positionStart"    # I
    .param p3, "itemCount"    # I
    .param p4, "payload"    # Ljava/lang/Object;

    .line 1487
    const/4 v0, 0x4

    invoke-direct {p0, p2, p3, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->handleUpdate(III)V

    .line 1488
    return-void
.end method

.method public onLayoutChildren(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)V
    .locals 1
    .param p1, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 604
    const/4 v0, 0x1

    invoke-direct {p0, p1, p2, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->onLayoutChildren(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;Z)V

    .line 605
    return-void
.end method

.method public onLayoutCompleted(Landroid/support/v7/widget/RecyclerView$State;)V
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 725
    invoke-super {p0, p1}, Landroid/support/v7/widget/RecyclerView$LayoutManager;->onLayoutCompleted(Landroid/support/v7/widget/RecyclerView$State;)V

    .line 726
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 727
    const/high16 v0, -0x80000000

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 728
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    .line 729
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mAnchorInfo:Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->reset()V

    .line 730
    return-void
.end method

.method public onRestoreInstanceState(Landroid/os/Parcelable;)V
    .locals 1
    .param p1, "state"    # Landroid/os/Parcelable;

    .line 1183
    instance-of v0, p1, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v0, :cond_0

    .line 1184
    move-object v0, p1

    check-cast v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    .line 1185
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 1189
    :cond_0
    return-void
.end method

.method public onSaveInstanceState()Landroid/os/Parcelable;
    .locals 4

    .line 1193
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v0, :cond_0

    .line 1194
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    invoke-direct {v0, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;)V

    return-object v0

    .line 1196
    :cond_0
    new-instance v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    invoke-direct {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;-><init>()V

    .line 1197
    .local v0, "state":Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    iput-boolean v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mReverseLayout:Z

    .line 1198
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    iput-boolean v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorLayoutFromEnd:Z

    .line 1199
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutRTL:Z

    iput-boolean v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mLastLayoutRTL:Z

    .line 1201
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    if-eqz v1, :cond_1

    .line 1202
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookup:[I

    .line 1203
    iget-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookup:[I

    array-length v1, v1

    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookupSize:I

    .line 1204
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLazySpanLookup:Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;

    iget-object v1, v1, Landroid/support/v7/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mFullSpanItems:Ljava/util/List;

    goto :goto_0

    .line 1206
    :cond_1
    iput v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanLookupSize:I

    .line 1209
    :goto_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v1

    if-lez v1, :cond_5

    .line 1210
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    if-eqz v1, :cond_2

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v1

    goto :goto_1

    .line 1211
    :cond_2
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v1

    :goto_1
    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    .line 1212
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findFirstVisibleItemPositionInt()I

    move-result v1

    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mVisibleAnchorPosition:I

    .line 1213
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    .line 1214
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array v1, v1, [I

    iput-object v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsets:[I

    .line 1215
    nop

    .line 1215
    .local v2, "i":I
    :goto_2
    move v1, v2

    .line 1215
    .end local v2    # "i":I
    .local v1, "i":I
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v1, v2, :cond_6

    .line 1217
    iget-boolean v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    const/high16 v3, -0x80000000

    if-eqz v2, :cond_3

    .line 1218
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getEndLine(I)I

    move-result v2

    .line 1219
    .local v2, "line":I
    if-eq v2, v3, :cond_4

    .line 1220
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v3

    sub-int/2addr v2, v3

    goto :goto_3

    .line 1223
    .end local v2    # "line":I
    :cond_3
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    aget-object v2, v2, v1

    invoke-virtual {v2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;->getStartLine(I)I

    move-result v2

    .line 1224
    .restart local v2    # "line":I
    if-eq v2, v3, :cond_4

    .line 1225
    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v3}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v3

    sub-int/2addr v2, v3

    .line 1228
    :cond_4
    :goto_3
    iget-object v3, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsets:[I

    aput v2, v3, v1

    .line 1215
    .end local v2    # "line":I
    add-int/lit8 v2, v1, 0x1

    .line 1215
    .end local v1    # "i":I
    .local v2, "i":I
    goto :goto_2

    .line 1231
    .end local v2    # "i":I
    :cond_5
    const/4 v1, -0x1

    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    .line 1232
    iput v1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mVisibleAnchorPosition:I

    .line 1233
    iput v2, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    .line 1238
    :cond_6
    return-object v0
.end method

.method public onScrollStateChanged(I)V
    .locals 0
    .param p1, "state"    # I

    .line 316
    if-nez p1, :cond_0

    .line 317
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->checkForGaps()Z

    .line 319
    :cond_0
    return-void
.end method

.method prepareLayoutStateForDelta(ILandroid/support/v7/widget/RecyclerView$State;)V
    .locals 4
    .param p1, "delta"    # I
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 2122
    if-lez p1, :cond_0

    .line 2123
    const/4 v0, 0x1

    .line 2124
    .local v0, "layoutDir":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v1

    .line 2124
    .local v1, "referenceChildPosition":I
    goto :goto_0

    .line 2126
    .end local v0    # "layoutDir":I
    .end local v1    # "referenceChildPosition":I
    :cond_0
    const/4 v0, -0x1

    .line 2127
    .restart local v0    # "layoutDir":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v1

    .line 2129
    .restart local v1    # "referenceChildPosition":I
    :goto_0
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    const/4 v3, 0x1

    iput-boolean v3, v2, Landroid/support/v7/widget/LayoutState;->mRecycle:Z

    .line 2130
    invoke-direct {p0, v1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateLayoutState(ILandroid/support/v7/widget/RecyclerView$State;)V

    .line 2131
    invoke-direct {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setLayoutStateDirection(I)V

    .line 2132
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget-object v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v3, v3, Landroid/support/v7/widget/LayoutState;->mItemDirection:I

    add-int/2addr v3, v1

    iput v3, v2, Landroid/support/v7/widget/LayoutState;->mCurrentPosition:I

    .line 2133
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v3

    iput v3, v2, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    .line 2134
    return-void
.end method

.method scrollBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 6
    .param p1, "dt"    # I
    .param p2, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p3, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 2137
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_2

    .line 2141
    :cond_0
    invoke-virtual {p0, p1, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->prepareLayoutStateForDelta(ILandroid/support/v7/widget/RecyclerView$State;)V

    .line 2142
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p2, v0, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->fill(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    .line 2143
    .local v0, "consumed":I
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iget v2, v2, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    .line 2145
    .local v2, "available":I
    if-ge v2, v0, :cond_1

    .line 2146
    move v3, p1

    .line 2146
    .local v3, "totalScroll":I
    :goto_0
    goto :goto_1

    .line 2147
    .end local v3    # "totalScroll":I
    :cond_1
    if-gez p1, :cond_2

    .line 2148
    neg-int v3, v0

    goto :goto_0

    .line 2150
    :cond_2
    move v3, v0

    .line 2156
    .restart local v3    # "totalScroll":I
    :goto_1
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    neg-int v5, v3

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/OrientationHelper;->offsetChildren(I)V

    .line 2158
    iget-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    iput-boolean v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLastLayoutFromEnd:Z

    .line 2159
    iget-object v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    iput v1, v4, Landroid/support/v7/widget/LayoutState;->mAvailable:I

    .line 2160
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mLayoutState:Landroid/support/v7/widget/LayoutState;

    invoke-direct {p0, p2, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->recycle(Landroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/LayoutState;)V

    .line 2161
    return v3

    .line 2138
    .end local v0    # "consumed":I
    .end local v2    # "available":I
    .end local v3    # "totalScroll":I
    :cond_3
    :goto_2
    return v1
.end method

.method public scrollHorizontallyBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "dx"    # I
    .param p2, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p3, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 1996
    invoke-virtual {p0, p1, p2, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->scrollBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public scrollToPosition(I)V
    .locals 1
    .param p1, "position"    # I

    .line 2040
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    if-eq v0, p1, :cond_0

    .line 2041
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->invalidateAnchorPositionInfo()V

    .line 2043
    :cond_0
    iput p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 2044
    const/high16 v0, -0x80000000

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 2045
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 2046
    return-void
.end method

.method public scrollToPositionWithOffset(II)V
    .locals 1
    .param p1, "position"    # I
    .param p2, "offset"    # I

    .line 2062
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v0, :cond_0

    .line 2063
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    invoke-virtual {v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->invalidateAnchorPositionInfo()V

    .line 2065
    :cond_0
    iput p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 2066
    iput p2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 2067
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 2068
    return-void
.end method

.method public scrollVerticallyBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I
    .locals 1
    .param p1, "dy"    # I
    .param p2, "recycler"    # Landroid/support/v7/widget/RecyclerView$Recycler;
    .param p3, "state"    # Landroid/support/v7/widget/RecyclerView$State;

    .line 2002
    invoke-virtual {p0, p1, p2, p3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->scrollBy(ILandroid/support/v7/widget/RecyclerView$Recycler;Landroid/support/v7/widget/RecyclerView$State;)I

    move-result v0

    return v0
.end method

.method public setGapStrategy(I)V
    .locals 2
    .param p1, "gapStrategy"    # I

    .line 511
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->assertNotInLayoutOrScroll(Ljava/lang/String;)V

    .line 512
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-ne p1, v0, :cond_0

    .line 513
    return-void

    .line 515
    :cond_0
    if-eqz p1, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1

    .line 517
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "invalid gap strategy. Must be GAP_HANDLING_NONE or GAP_HANDLING_MOVE_ITEMS_BETWEEN_SPANS"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 520
    :cond_1
    iput p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    .line 521
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mGapStrategy:I

    if-eqz v0, :cond_2

    const/4 v0, 0x1

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setAutoMeasureEnabled(Z)V

    .line 522
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 523
    return-void
.end method

.method public setMeasuredDimension(Landroid/graphics/Rect;II)V
    .locals 7
    .param p1, "childrenBounds"    # Landroid/graphics/Rect;
    .param p2, "wSpec"    # I
    .param p3, "hSpec"    # I

    .line 586
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPaddingLeft()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPaddingRight()I

    move-result v1

    add-int/2addr v0, v1

    .line 587
    .local v0, "horizontalPadding":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPaddingTop()I

    move-result v1

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getPaddingBottom()I

    move-result v2

    add-int/2addr v1, v2

    .line 588
    .local v1, "verticalPadding":I
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_0

    .line 589
    invoke-virtual {p1}, Landroid/graphics/Rect;->height()I

    move-result v2

    add-int/2addr v2, v1

    .line 590
    .local v2, "usedHeight":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinimumHeight()I

    move-result v3

    invoke-static {p3, v2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->chooseSize(III)I

    move-result v3

    .line 591
    .local v3, "height":I
    iget v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    mul-int/2addr v4, v5

    add-int/2addr v4, v0

    .line 592
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinimumWidth()I

    move-result v5

    .line 591
    invoke-static {p2, v4, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->chooseSize(III)I

    move-result v2

    .line 593
    .local v2, "width":I
    nop

    .line 596
    move v6, v3

    move v3, v2

    move v2, v6

    goto :goto_0

    .line 594
    .end local v2    # "width":I
    .end local v3    # "height":I
    :cond_0
    invoke-virtual {p1}, Landroid/graphics/Rect;->width()I

    move-result v2

    add-int/2addr v2, v0

    .line 595
    .local v2, "usedWidth":I
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinimumWidth()I

    move-result v3

    invoke-static {p2, v2, v3}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->chooseSize(III)I

    move-result v3

    .line 596
    .local v3, "width":I
    iget v4, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    iget v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    mul-int/2addr v4, v5

    add-int/2addr v4, v1

    .line 597
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getMinimumHeight()I

    move-result v5

    .line 596
    invoke-static {p3, v4, v5}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->chooseSize(III)I

    move-result v2

    .line 599
    .local v2, "height":I
    :goto_0
    invoke-virtual {p0, v3, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->setMeasuredDimension(II)V

    .line 600
    return-void
.end method

.method public setOrientation(I)V
    .locals 2
    .param p1, "orientation"    # I

    .line 447
    if-eqz p1, :cond_0

    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    .line 448
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "invalid orientation."

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 450
    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->assertNotInLayoutOrScroll(Ljava/lang/String;)V

    .line 451
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    if-ne p1, v0, :cond_1

    .line 452
    return-void

    .line 454
    :cond_1
    iput p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mOrientation:I

    .line 455
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 456
    .local v0, "tmp":Landroid/support/v7/widget/OrientationHelper;
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    iput-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 457
    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 458
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 459
    return-void
.end method

.method public setReverseLayout(Z)V
    .locals 1
    .param p1, "reverseLayout"    # Z

    .line 475
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->assertNotInLayoutOrScroll(Ljava/lang/String;)V

    .line 476
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget-boolean v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mReverseLayout:Z

    if-eq v0, p1, :cond_0

    .line 477
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iput-boolean p1, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mReverseLayout:Z

    .line 479
    :cond_0
    iput-boolean p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mReverseLayout:Z

    .line 480
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 481
    return-void
.end method

.method public setSpanCount(I)V
    .locals 3
    .param p1, "spanCount"    # I

    .line 427
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->assertNotInLayoutOrScroll(Ljava/lang/String;)V

    .line 428
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-eq p1, v0, :cond_1

    .line 429
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->invalidateSpanAssignments()V

    .line 430
    iput p1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    .line 431
    new-instance v0, Ljava/util/BitSet;

    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    invoke-direct {v0, v1}, Ljava/util/BitSet;-><init>(I)V

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mRemainingSpans:Ljava/util/BitSet;

    .line 432
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    new-array v0, v0, [Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    iput-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    .line 433
    const/4 v0, 0x0

    .line 433
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    if-ge v0, v1, :cond_0

    .line 434
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpans:[Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    new-instance v2, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;

    invoke-direct {v2, p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager$Span;-><init>(Landroid/support/v7/widget/StaggeredGridLayoutManager;I)V

    aput-object v2, v1, v0

    .line 433
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 436
    .end local v0    # "i":I
    :cond_0
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->requestLayout()V

    .line 438
    :cond_1
    return-void
.end method

.method public smoothScrollToPosition(Landroid/support/v7/widget/RecyclerView;Landroid/support/v7/widget/RecyclerView$State;I)V
    .locals 2
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p3, "position"    # I

    .line 2033
    new-instance v0, Landroid/support/v7/widget/LinearSmoothScroller;

    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/support/v7/widget/LinearSmoothScroller;-><init>(Landroid/content/Context;)V

    .line 2034
    .local v0, "scroller":Landroid/support/v7/widget/LinearSmoothScroller;
    invoke-virtual {v0, p3}, Landroid/support/v7/widget/LinearSmoothScroller;->setTargetPosition(I)V

    .line 2035
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->startSmoothScroll(Landroid/support/v7/widget/RecyclerView$SmoothScroller;)V

    .line 2036
    return-void
.end method

.method public supportsPredictiveItemAnimations()Z
    .locals 1

    .line 934
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method updateAnchorFromPendingData(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)Z
    .locals 7
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p2, "anchorInfo"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 848
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$State;->isPreLayout()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_f

    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    const/4 v2, -0x1

    if-ne v0, v2, :cond_0

    goto/16 :goto_8

    .line 852
    :cond_0
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    const/high16 v3, -0x80000000

    if-ltz v0, :cond_e

    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView$State;->getItemCount()I

    move-result v4

    if-lt v0, v4, :cond_1

    goto/16 :goto_7

    .line 858
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    const/4 v4, 0x1

    if-eqz v0, :cond_3

    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mAnchorPosition:I

    if-eq v0, v2, :cond_3

    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingSavedState:Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;

    iget v0, v0, Landroid/support/v7/widget/StaggeredGridLayoutManager$SavedState;->mSpanOffsetsSize:I

    if-ge v0, v4, :cond_2

    goto :goto_0

    .line 919
    :cond_2
    iput v3, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 920
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    iput v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    goto/16 :goto_6

    .line 861
    :cond_3
    :goto_0
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->findViewByPosition(I)Landroid/view/View;

    move-result-object v0

    .line 862
    .local v0, "child":Landroid/view/View;
    if-eqz v0, :cond_b

    .line 865
    iget-boolean v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mShouldReverseLayout:Z

    if-eqz v1, :cond_4

    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getLastChildPosition()I

    move-result v1

    goto :goto_1

    .line 866
    :cond_4
    invoke-virtual {p0}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->getFirstChildPosition()I

    move-result v1

    :goto_1
    iput v1, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    .line 867
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    if-eq v1, v3, :cond_6

    .line 868
    iget-boolean v1, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    if-eqz v1, :cond_5

    .line 869
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v1

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    sub-int/2addr v1, v2

    .line 871
    .local v1, "target":I
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v2

    sub-int v2, v1, v2

    iput v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 872
    .end local v1    # "target":I
    goto :goto_2

    .line 873
    :cond_5
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v1

    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    add-int/2addr v1, v2

    .line 875
    .restart local v1    # "target":I
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v2

    sub-int v2, v1, v2

    iput v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 877
    .end local v1    # "target":I
    :goto_2
    return v4

    .line 881
    :cond_6
    iget-object v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v1, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedMeasurement(Landroid/view/View;)I

    move-result v1

    .line 882
    .local v1, "childSize":I
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getTotalSpace()I

    move-result v2

    if-le v1, v2, :cond_8

    .line 884
    iget-boolean v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    if-eqz v2, :cond_7

    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 885
    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v2

    goto :goto_3

    :cond_7
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 886
    invoke-virtual {v2}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v2

    :goto_3
    iput v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 887
    return v4

    .line 890
    :cond_8
    iget-object v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v2, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedStart(Landroid/view/View;)I

    move-result v2

    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 891
    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getStartAfterPadding()I

    move-result v5

    sub-int/2addr v2, v5

    .line 892
    .local v2, "startGap":I
    if-gez v2, :cond_9

    .line 893
    neg-int v3, v2

    iput v3, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 894
    return v4

    .line 896
    :cond_9
    iget-object v5, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    invoke-virtual {v5}, Landroid/support/v7/widget/OrientationHelper;->getEndAfterPadding()I

    move-result v5

    iget-object v6, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPrimaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 897
    invoke-virtual {v6, v0}, Landroid/support/v7/widget/OrientationHelper;->getDecoratedEnd(Landroid/view/View;)I

    move-result v6

    sub-int/2addr v5, v6

    .line 898
    .local v5, "endGap":I
    if-gez v5, :cond_a

    .line 899
    iput v5, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 900
    return v4

    .line 903
    :cond_a
    iput v3, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mOffset:I

    .line 904
    .end local v1    # "childSize":I
    .end local v2    # "startGap":I
    .end local v5    # "endGap":I
    goto :goto_5

    .line 907
    :cond_b
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    iput v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    .line 908
    iget v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    if-ne v2, v3, :cond_d

    .line 909
    iget v2, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    invoke-direct {p0, v2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->calculateScrollDirectionForPosition(I)I

    move-result v2

    .line 911
    .local v2, "position":I
    if-ne v2, v4, :cond_c

    move v1, v4

    nop

    :cond_c
    iput-boolean v1, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mLayoutFromEnd:Z

    .line 912
    invoke-virtual {p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->assignCoordinateFromPadding()V

    .line 913
    .end local v2    # "position":I
    goto :goto_4

    .line 914
    :cond_d
    iget v1, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    invoke-virtual {p2, v1}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->assignCoordinateFromPadding(I)V

    .line 916
    :goto_4
    iput-boolean v4, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mInvalidateOffsets:Z

    .line 918
    .end local v0    # "child":Landroid/view/View;
    :goto_5
    nop

    .line 922
    :goto_6
    return v4

    .line 853
    :cond_e
    :goto_7
    iput v2, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPosition:I

    .line 854
    iput v3, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mPendingScrollPositionOffset:I

    .line 855
    return v1

    .line 849
    :cond_f
    :goto_8
    return v1
.end method

.method updateAnchorInfoForLayout(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)V
    .locals 1
    .param p1, "state"    # Landroid/support/v7/widget/RecyclerView$State;
    .param p2, "anchorInfo"    # Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;

    .line 821
    invoke-virtual {p0, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateAnchorFromPendingData(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 822
    return-void

    .line 824
    :cond_0
    invoke-direct {p0, p1, p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager;->updateAnchorFromChildren(Landroid/support/v7/widget/RecyclerView$State;Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 825
    return-void

    .line 830
    :cond_1
    invoke-virtual {p2}, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->assignCoordinateFromPadding()V

    .line 831
    const/4 v0, 0x0

    iput v0, p2, Landroid/support/v7/widget/StaggeredGridLayoutManager$AnchorInfo;->mPosition:I

    .line 832
    return-void
.end method

.method updateMeasureSpecs(I)V
    .locals 1
    .param p1, "totalSpace"    # I

    .line 926
    iget v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSpanCount:I

    div-int v0, p1, v0

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSizePerSpan:I

    .line 928
    iget-object v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mSecondaryOrientation:Landroid/support/v7/widget/OrientationHelper;

    .line 929
    invoke-virtual {v0}, Landroid/support/v7/widget/OrientationHelper;->getMode()I

    move-result v0

    .line 928
    invoke-static {p1, v0}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v0

    iput v0, p0, Landroid/support/v7/widget/StaggeredGridLayoutManager;->mFullSizeSpec:I

    .line 930
    return-void
.end method
