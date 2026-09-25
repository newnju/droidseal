.class public Landroid/support/v4/view/ViewPager;
.super Landroid/view/ViewGroup;
.source "ViewPager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v4/view/ViewPager$ViewPositionComparator;,
        Landroid/support/v4/view/ViewPager$LayoutParams;,
        Landroid/support/v4/view/ViewPager$PagerObserver;,
        Landroid/support/v4/view/ViewPager$MyAccessibilityDelegate;,
        Landroid/support/v4/view/ViewPager$SavedState;,
        Landroid/support/v4/view/ViewPager$DecorView;,
        Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;,
        Landroid/support/v4/view/ViewPager$PageTransformer;,
        Landroid/support/v4/view/ViewPager$SimpleOnPageChangeListener;,
        Landroid/support/v4/view/ViewPager$OnPageChangeListener;,
        Landroid/support/v4/view/ViewPager$ItemInfo;
    }
.end annotation


# static fields
.field private static final CLOSE_ENOUGH:I = 0x2

.field private static final COMPARATOR:Ljava/util/Comparator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Comparator<",
            "Landroid/support/v4/view/ViewPager$ItemInfo;",
            ">;"
        }
    .end annotation
.end field

.field private static final DEBUG:Z = false

.field private static final DEFAULT_GUTTER_SIZE:I = 0x10

.field private static final DEFAULT_OFFSCREEN_PAGES:I = 0x1

.field private static final DRAW_ORDER_DEFAULT:I = 0x0

.field private static final DRAW_ORDER_FORWARD:I = 0x1

.field private static final DRAW_ORDER_REVERSE:I = 0x2

.field private static final INVALID_POINTER:I = -0x1

.field static final LAYOUT_ATTRS:[I

.field private static final MAX_SETTLE_DURATION:I = 0x258

.field private static final MIN_DISTANCE_FOR_FLING:I = 0x19

.field private static final MIN_FLING_VELOCITY:I = 0x190

.field public static final SCROLL_STATE_DRAGGING:I = 0x1

.field public static final SCROLL_STATE_IDLE:I = 0x0

.field public static final SCROLL_STATE_SETTLING:I = 0x2

.field private static final TAG:Ljava/lang/String; = "ViewPager"

.field private static final USE_CACHE:Z = false

.field private static final sInterpolator:Landroid/view/animation/Interpolator;

.field private static final sPositionComparator:Landroid/support/v4/view/ViewPager$ViewPositionComparator;


# instance fields
.field private mActivePointerId:I

.field mAdapter:Landroid/support/v4/view/PagerAdapter;

.field private mAdapterChangeListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;",
            ">;"
        }
    .end annotation
.end field

.field private mBottomPageBounds:I

.field private mCalledSuper:Z

.field private mChildHeightMeasureSpec:I

.field private mChildWidthMeasureSpec:I

.field private mCloseEnough:I

.field mCurItem:I

.field private mDecorChildCount:I

.field private mDefaultGutterSize:I

.field private mDrawingOrder:I

.field private mDrawingOrderedChildren:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private final mEndScrollRunnable:Ljava/lang/Runnable;

.field private mExpectedAdapterCount:I

.field private mFakeDragBeginTime:J

.field private mFakeDragging:Z

.field private mFirstLayout:Z

.field private mFirstOffset:F

.field private mFlingDistance:I

.field private mGutterSize:I

.field private mInLayout:Z

.field private mInitialMotionX:F

.field private mInitialMotionY:F

.field private mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

.field private mIsBeingDragged:Z

.field private mIsScrollStarted:Z

.field private mIsUnableToDrag:Z

.field private final mItems:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/v4/view/ViewPager$ItemInfo;",
            ">;"
        }
    .end annotation
.end field

.field private mLastMotionX:F

.field private mLastMotionY:F

.field private mLastOffset:F

.field private mLeftEdge:Landroid/widget/EdgeEffect;

.field private mMarginDrawable:Landroid/graphics/drawable/Drawable;

.field private mMaximumVelocity:I

.field private mMinimumVelocity:I

.field private mNeedCalculatePageOffsets:Z

.field private mObserver:Landroid/support/v4/view/ViewPager$PagerObserver;

.field private mOffscreenPageLimit:I

.field private mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

.field private mOnPageChangeListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/support/v4/view/ViewPager$OnPageChangeListener;",
            ">;"
        }
    .end annotation
.end field

.field private mPageMargin:I

.field private mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

.field private mPageTransformerLayerType:I

.field private mPopulatePending:Z

.field private mRestoredAdapterState:Landroid/os/Parcelable;

.field private mRestoredClassLoader:Ljava/lang/ClassLoader;

.field private mRestoredCurItem:I

.field private mRightEdge:Landroid/widget/EdgeEffect;

.field private mScrollState:I

.field private mScroller:Landroid/widget/Scroller;

.field private mScrollingCacheEnabled:Z

.field private final mTempItem:Landroid/support/v4/view/ViewPager$ItemInfo;

.field private final mTempRect:Landroid/graphics/Rect;

.field private mTopPageBounds:I

.field private mTouchSlop:I

.field private mVelocityTracker:Landroid/view/VelocityTracker;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 116
    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    const v2, 0x10100b3

    aput v2, v0, v1

    sput-object v0, Landroid/support/v4/view/ViewPager;->LAYOUT_ATTRS:[I

    .line 134
    new-instance v0, Landroid/support/v4/view/ViewPager$1;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$1;-><init>()V

    sput-object v0, Landroid/support/v4/view/ViewPager;->COMPARATOR:Ljava/util/Comparator;

    .line 141
    new-instance v0, Landroid/support/v4/view/ViewPager$2;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$2;-><init>()V

    sput-object v0, Landroid/support/v4/view/ViewPager;->sInterpolator:Landroid/view/animation/Interpolator;

    .line 245
    new-instance v0, Landroid/support/v4/view/ViewPager$ViewPositionComparator;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$ViewPositionComparator;-><init>()V

    sput-object v0, Landroid/support/v4/view/ViewPager;->sPositionComparator:Landroid/support/v4/view/ViewPager$ViewPositionComparator;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 385
    invoke-direct {p0, p1}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;)V

    .line 149
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    .line 150
    new-instance v0, Landroid/support/v4/view/ViewPager$ItemInfo;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$ItemInfo;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mTempItem:Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 152
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    .line 156
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    .line 157
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredAdapterState:Landroid/os/Parcelable;

    .line 158
    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredClassLoader:Ljava/lang/ClassLoader;

    .line 173
    const v1, -0x800001

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    .line 174
    const v1, 0x7f7fffff    # Float.MAX_VALUE

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    .line 183
    const/4 v1, 0x1

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    .line 201
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 228
    iput-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 229
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mNeedCalculatePageOffsets:Z

    .line 263
    new-instance v1, Landroid/support/v4/view/ViewPager$3;

    invoke-direct {v1, p0}, Landroid/support/v4/view/ViewPager$3;-><init>(Landroid/support/v4/view/ViewPager;)V

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mEndScrollRunnable:Ljava/lang/Runnable;

    .line 271
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mScrollState:I

    .line 386
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->initViewPager()V

    .line 387
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 390
    invoke-direct {p0, p1, p2}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 149
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    .line 150
    new-instance v0, Landroid/support/v4/view/ViewPager$ItemInfo;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$ItemInfo;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mTempItem:Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 152
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    .line 156
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    .line 157
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredAdapterState:Landroid/os/Parcelable;

    .line 158
    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredClassLoader:Ljava/lang/ClassLoader;

    .line 173
    const v1, -0x800001

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    .line 174
    const v1, 0x7f7fffff    # Float.MAX_VALUE

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    .line 183
    const/4 v1, 0x1

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    .line 201
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 228
    iput-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 229
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mNeedCalculatePageOffsets:Z

    .line 263
    new-instance v1, Landroid/support/v4/view/ViewPager$3;

    invoke-direct {v1, p0}, Landroid/support/v4/view/ViewPager$3;-><init>(Landroid/support/v4/view/ViewPager;)V

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mEndScrollRunnable:Ljava/lang/Runnable;

    .line 271
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mScrollState:I

    .line 391
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->initViewPager()V

    .line 392
    return-void
.end method

.method private calculatePageOffsets(Landroid/support/v4/view/ViewPager$ItemInfo;ILandroid/support/v4/view/ViewPager$ItemInfo;)V
    .locals 11
    .param p1, "curItem"    # Landroid/support/v4/view/ViewPager$ItemInfo;
    .param p2, "curIndex"    # I
    .param p3, "oldCurInfo"    # Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1290
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v0

    .line 1291
    .local v0, "N":I
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v1

    .line 1292
    .local v1, "width":I
    if-lez v1, :cond_0

    iget v2, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v2, v2

    int-to-float v3, v1

    div-float/2addr v2, v3

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    .line 1294
    .local v2, "marginOffset":F
    :goto_0
    if-eqz p3, :cond_7

    .line 1295
    iget v3, p3, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 1297
    .local v3, "oldCurPosition":I
    iget v4, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ge v3, v4, :cond_4

    .line 1298
    const/4 v4, 0x0

    .line 1299
    .local v4, "itemIndex":I
    const/4 v5, 0x0

    .line 1300
    .local v5, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v6, p3, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v7, p3, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v6, v7

    add-float/2addr v6, v2

    .line 1301
    .local v6, "offset":F
    add-int/lit8 v7, v3, 0x1

    .line 1302
    .local v7, "pos":I
    :goto_1
    iget v8, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-gt v7, v8, :cond_3

    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v8

    if-ge v4, v8, :cond_3

    .line 1303
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    move-object v5, v8

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1304
    :goto_2
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-le v7, v8, :cond_1

    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v8

    add-int/lit8 v8, v8, -0x1

    if-ge v4, v8, :cond_1

    .line 1305
    add-int/lit8 v4, v4, 0x1

    .line 1306
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    move-object v5, v8

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_2

    .line 1308
    :cond_1
    :goto_3
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ge v7, v8, :cond_2

    .line 1311
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v8, v7}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v8

    add-float/2addr v8, v2

    add-float/2addr v6, v8

    .line 1312
    add-int/lit8 v7, v7, 0x1

    goto :goto_3

    .line 1314
    :cond_2
    iput v6, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1315
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v8, v2

    add-float/2addr v6, v8

    .line 1302
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 1317
    .end local v4    # "itemIndex":I
    .end local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v6    # "offset":F
    .end local v7    # "pos":I
    :cond_3
    goto :goto_7

    :cond_4
    iget v4, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-le v3, v4, :cond_7

    .line 1318
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    add-int/lit8 v4, v4, -0x1

    .line 1319
    .restart local v4    # "itemIndex":I
    const/4 v5, 0x0

    .line 1320
    .restart local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v6, p3, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1321
    .restart local v6    # "offset":F
    add-int/lit8 v7, v3, -0x1

    .line 1322
    .restart local v7    # "pos":I
    :goto_4
    iget v8, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-lt v7, v8, :cond_7

    if-ltz v4, :cond_7

    .line 1323
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    move-object v5, v8

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1324
    :goto_5
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ge v7, v8, :cond_5

    if-lez v4, :cond_5

    .line 1325
    add-int/lit8 v4, v4, -0x1

    .line 1326
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    move-object v5, v8

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_5

    .line 1328
    :cond_5
    :goto_6
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-le v7, v8, :cond_6

    .line 1331
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v8, v7}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v8

    add-float/2addr v8, v2

    sub-float/2addr v6, v8

    .line 1332
    add-int/lit8 v7, v7, -0x1

    goto :goto_6

    .line 1334
    :cond_6
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v8, v2

    sub-float/2addr v6, v8

    .line 1335
    iput v6, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1322
    add-int/lit8 v7, v7, -0x1

    goto :goto_4

    .line 1341
    .end local v3    # "oldCurPosition":I
    .end local v4    # "itemIndex":I
    .end local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v6    # "offset":F
    .end local v7    # "pos":I
    :cond_7
    :goto_7
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 1342
    .local v3, "itemCount":I
    iget v4, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1343
    .local v4, "offset":F
    iget v5, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    add-int/lit8 v5, v5, -0x1

    .line 1344
    .local v5, "pos":I
    iget v6, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-nez v6, :cond_8

    iget v6, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    goto :goto_8

    :cond_8
    const v6, -0x800001

    :goto_8
    iput v6, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    .line 1345
    iget v6, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    add-int/lit8 v7, v0, -0x1

    const/high16 v8, 0x3f800000    # 1.0f

    if-ne v6, v7, :cond_9

    iget v6, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v7, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v6, v7

    sub-float/2addr v6, v8

    goto :goto_9

    :cond_9
    const v6, 0x7f7fffff    # Float.MAX_VALUE

    :goto_9
    iput v6, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    .line 1348
    add-int/lit8 v6, p2, -0x1

    .line 1348
    .local v6, "i":I
    :goto_a
    if-ltz v6, :cond_c

    .line 1349
    iget-object v7, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1350
    .local v7, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_b
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-le v5, v9, :cond_a

    .line 1351
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    add-int/lit8 v10, v5, -0x1

    .line 1351
    .local v10, "pos":I
    invoke-virtual {v9, v5}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v5

    .line 1351
    .end local v5    # "pos":I
    add-float/2addr v5, v2

    sub-float/2addr v4, v5

    .line 1349
    move v5, v10

    goto :goto_b

    .line 1353
    .end local v10    # "pos":I
    .restart local v5    # "pos":I
    :cond_a
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v9, v2

    sub-float/2addr v4, v9

    .line 1354
    iput v4, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1355
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-nez v9, :cond_b

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    .line 1348
    .end local v7    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_b
    add-int/lit8 v6, v6, -0x1

    add-int/lit8 v5, v5, -0x1

    goto :goto_a

    .line 1357
    .end local v6    # "i":I
    :cond_c
    iget v6, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v7, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v6, v7

    add-float/2addr v6, v2

    .line 1358
    .end local v4    # "offset":F
    .local v6, "offset":F
    iget v4, p1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    add-int/lit8 v4, v4, 0x1

    .line 1360
    .end local v5    # "pos":I
    .local v4, "pos":I
    add-int/lit8 v5, p2, 0x1

    .line 1360
    .local v5, "i":I
    :goto_c
    if-ge v5, v3, :cond_f

    .line 1361
    iget-object v7, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1362
    .restart local v7    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_d
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ge v4, v9, :cond_d

    .line 1363
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    add-int/lit8 v10, v4, 0x1

    .line 1363
    .restart local v10    # "pos":I
    invoke-virtual {v9, v4}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v4

    .line 1363
    .end local v4    # "pos":I
    add-float/2addr v4, v2

    add-float/2addr v6, v4

    .line 1361
    move v4, v10

    goto :goto_d

    .line 1365
    .end local v10    # "pos":I
    .restart local v4    # "pos":I
    :cond_d
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    add-int/lit8 v10, v0, -0x1

    if-ne v9, v10, :cond_e

    .line 1366
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v9, v6

    sub-float/2addr v9, v8

    iput v9, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    .line 1368
    :cond_e
    iput v6, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1369
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v9, v2

    add-float/2addr v6, v9

    .line 1360
    .end local v7    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    add-int/lit8 v5, v5, 0x1

    add-int/lit8 v4, v4, 0x1

    goto :goto_c

    .line 1372
    .end local v5    # "i":I
    :cond_f
    const/4 v5, 0x0

    iput-boolean v5, p0, Landroid/support/v4/view/ViewPager;->mNeedCalculatePageOffsets:Z

    .line 1373
    return-void
.end method

.method private completeScroll(Z)V
    .locals 7
    .param p1, "postEvents"    # Z

    .line 1966
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mScrollState:I

    const/4 v1, 0x1

    const/4 v2, 0x0

    const/4 v3, 0x2

    if-ne v0, v3, :cond_0

    move v0, v1

    goto :goto_0

    :cond_0
    move v0, v2

    .line 1967
    .local v0, "needPopulate":Z
    :goto_0
    if-eqz v0, :cond_2

    .line 1969
    invoke-direct {p0, v2}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 1970
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v3}, Landroid/widget/Scroller;->isFinished()Z

    move-result v3

    xor-int/2addr v1, v3

    .line 1971
    .local v1, "wasScrolling":Z
    if-eqz v1, :cond_2

    .line 1972
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v3}, Landroid/widget/Scroller;->abortAnimation()V

    .line 1973
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v3

    .line 1974
    .local v3, "oldX":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v4

    .line 1975
    .local v4, "oldY":I
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v5}, Landroid/widget/Scroller;->getCurrX()I

    move-result v5

    .line 1976
    .local v5, "x":I
    iget-object v6, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v6}, Landroid/widget/Scroller;->getCurrY()I

    move-result v6

    .line 1977
    .local v6, "y":I
    if-ne v3, v5, :cond_1

    if-eq v4, v6, :cond_2

    .line 1978
    :cond_1
    invoke-virtual {p0, v5, v6}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 1979
    if-eq v5, v3, :cond_2

    .line 1980
    invoke-direct {p0, v5}, Landroid/support/v4/view/ViewPager;->pageScrolled(I)Z

    .line 1985
    .end local v1    # "wasScrolling":Z
    .end local v3    # "oldX":I
    .end local v4    # "oldY":I
    .end local v5    # "x":I
    .end local v6    # "y":I
    :cond_2
    iput-boolean v2, p0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 1986
    move v1, v0

    move v0, v2

    .line 1986
    .local v0, "i":I
    .local v1, "needPopulate":Z
    :goto_1
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v0, v3, :cond_4

    .line 1987
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1988
    .local v3, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-boolean v4, v3, Landroid/support/v4/view/ViewPager$ItemInfo;->scrolling:Z

    if-eqz v4, :cond_3

    .line 1989
    const/4 v1, 0x1

    .line 1990
    iput-boolean v2, v3, Landroid/support/v4/view/ViewPager$ItemInfo;->scrolling:Z

    .line 1986
    .end local v3    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 1993
    .end local v0    # "i":I
    :cond_4
    if-eqz v1, :cond_6

    .line 1994
    if-eqz p1, :cond_5

    .line 1995
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mEndScrollRunnable:Ljava/lang/Runnable;

    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->postOnAnimation(Landroid/view/View;Ljava/lang/Runnable;)V

    goto :goto_2

    .line 1997
    :cond_5
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mEndScrollRunnable:Ljava/lang/Runnable;

    invoke-interface {v0}, Ljava/lang/Runnable;->run()V

    .line 2000
    :cond_6
    :goto_2
    return-void
.end method

.method private determineTargetPage(IFII)I
    .locals 5
    .param p1, "currentPage"    # I
    .param p2, "pageOffset"    # F
    .param p3, "velocity"    # I
    .param p4, "deltaX"    # I

    .line 2398
    invoke-static {p4}, Ljava/lang/Math;->abs(I)I

    move-result v0

    iget v1, p0, Landroid/support/v4/view/ViewPager;->mFlingDistance:I

    if-le v0, v1, :cond_1

    invoke-static {p3}, Ljava/lang/Math;->abs(I)I

    move-result v0

    iget v1, p0, Landroid/support/v4/view/ViewPager;->mMinimumVelocity:I

    if-le v0, v1, :cond_1

    .line 2399
    if-lez p3, :cond_0

    move v0, p1

    goto :goto_0

    :cond_0
    add-int/lit8 v0, p1, 0x1

    .line 2399
    .local v0, "targetPage":I
    :goto_0
    goto :goto_2

    .line 2401
    .end local v0    # "targetPage":I
    :cond_1
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-lt p1, v0, :cond_2

    const v0, 0x3ecccccd    # 0.4f

    goto :goto_1

    :cond_2
    const v0, 0x3f19999a    # 0.6f

    .line 2402
    .local v0, "truncator":F
    :goto_1
    add-float v1, p2, v0

    float-to-int v1, v1

    add-int v0, p1, v1

    .line 2405
    .local v0, "targetPage":I
    :goto_2
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_3

    .line 2406
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2407
    .local v1, "firstItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    add-int/lit8 v3, v3, -0x1

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2410
    .local v2, "lastItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v3, v1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v4, v2, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    invoke-static {v0, v4}, Ljava/lang/Math;->min(II)I

    move-result v4

    invoke-static {v3, v4}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 2413
    .end local v1    # "firstItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v2    # "lastItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_3
    return v0
.end method

.method private dispatchOnPageScrolled(IFI)V
    .locals 3
    .param p1, "position"    # I
    .param p2, "offset"    # F
    .param p3, "offsetPixels"    # I

    .line 1915
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_0

    .line 1916
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1, p2, p3}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrolled(IFI)V

    .line 1918
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_2

    .line 1919
    const/4 v0, 0x0

    .line 1919
    .local v0, "i":I
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    .line 1919
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_2

    .line 1920
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 1921
    .local v2, "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    if-eqz v2, :cond_1

    .line 1922
    invoke-interface {v2, p1, p2, p3}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrolled(IFI)V

    .line 1919
    .end local v2    # "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1926
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_2
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_3

    .line 1927
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1, p2, p3}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrolled(IFI)V

    .line 1929
    :cond_3
    return-void
.end method

.method private dispatchOnPageSelected(I)V
    .locals 3
    .param p1, "position"    # I

    .line 1932
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_0

    .line 1933
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageSelected(I)V

    .line 1935
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_2

    .line 1936
    const/4 v0, 0x0

    .line 1936
    .local v0, "i":I
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    .line 1936
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_2

    .line 1937
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 1938
    .local v2, "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    if-eqz v2, :cond_1

    .line 1939
    invoke-interface {v2, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageSelected(I)V

    .line 1936
    .end local v2    # "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1943
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_2
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_3

    .line 1944
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageSelected(I)V

    .line 1946
    :cond_3
    return-void
.end method

.method private dispatchOnScrollStateChanged(I)V
    .locals 3
    .param p1, "state"    # I

    .line 1949
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_0

    .line 1950
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrollStateChanged(I)V

    .line 1952
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_2

    .line 1953
    const/4 v0, 0x0

    .line 1953
    .local v0, "i":I
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    .line 1953
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_2

    .line 1954
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 1955
    .local v2, "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    if-eqz v2, :cond_1

    .line 1956
    invoke-interface {v2, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrollStateChanged(I)V

    .line 1953
    .end local v2    # "listener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1960
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_2
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    if-eqz v0, :cond_3

    .line 1961
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    invoke-interface {v0, p1}, Landroid/support/v4/view/ViewPager$OnPageChangeListener;->onPageScrollStateChanged(I)V

    .line 1963
    :cond_3
    return-void
.end method

.method private enableLayers(Z)V
    .locals 6
    .param p1, "enable"    # Z

    .line 2007
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v0

    .line 2008
    .local v0, "childCount":I
    const/4 v1, 0x0

    move v2, v1

    .line 2008
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 2009
    if-eqz p1, :cond_0

    iget v3, p0, Landroid/support/v4/view/ViewPager;->mPageTransformerLayerType:I

    goto :goto_1

    :cond_0
    move v3, v1

    .line 2011
    .local v3, "layerType":I
    :goto_1
    invoke-virtual {p0, v2}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    const/4 v5, 0x0

    invoke-virtual {v4, v3, v5}, Landroid/view/View;->setLayerType(ILandroid/graphics/Paint;)V

    .line 2008
    .end local v3    # "layerType":I
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2013
    .end local v2    # "i":I
    :cond_1
    return-void
.end method

.method private endDrag()V
    .locals 1

    .line 2651
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    .line 2652
    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mIsUnableToDrag:Z

    .line 2654
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v0, :cond_0

    .line 2655
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->recycle()V

    .line 2656
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 2658
    :cond_0
    return-void
.end method

.method private getChildRectInPagerCoordinates(Landroid/graphics/Rect;Landroid/view/View;)Landroid/graphics/Rect;
    .locals 4
    .param p1, "outRect"    # Landroid/graphics/Rect;
    .param p2, "child"    # Landroid/view/View;

    .line 2851
    if-nez p1, :cond_0

    .line 2852
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    move-object p1, v0

    .line 2854
    :cond_0
    if-nez p2, :cond_1

    .line 2855
    const/4 v0, 0x0

    invoke-virtual {p1, v0, v0, v0, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 2856
    return-object p1

    .line 2858
    :cond_1
    invoke-virtual {p2}, Landroid/view/View;->getLeft()I

    move-result v0

    iput v0, p1, Landroid/graphics/Rect;->left:I

    .line 2859
    invoke-virtual {p2}, Landroid/view/View;->getRight()I

    move-result v0

    iput v0, p1, Landroid/graphics/Rect;->right:I

    .line 2860
    invoke-virtual {p2}, Landroid/view/View;->getTop()I

    move-result v0

    iput v0, p1, Landroid/graphics/Rect;->top:I

    .line 2861
    invoke-virtual {p2}, Landroid/view/View;->getBottom()I

    move-result v0

    iput v0, p1, Landroid/graphics/Rect;->bottom:I

    .line 2863
    invoke-virtual {p2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 2864
    .local v0, "parent":Landroid/view/ViewParent;
    :goto_0
    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :cond_2

    if-eq v0, p0, :cond_2

    .line 2865
    move-object v1, v0

    check-cast v1, Landroid/view/ViewGroup;

    .line 2866
    .local v1, "group":Landroid/view/ViewGroup;
    iget v2, p1, Landroid/graphics/Rect;->left:I

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getLeft()I

    move-result v3

    add-int/2addr v2, v3

    iput v2, p1, Landroid/graphics/Rect;->left:I

    .line 2867
    iget v2, p1, Landroid/graphics/Rect;->right:I

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getRight()I

    move-result v3

    add-int/2addr v2, v3

    iput v2, p1, Landroid/graphics/Rect;->right:I

    .line 2868
    iget v2, p1, Landroid/graphics/Rect;->top:I

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getTop()I

    move-result v3

    add-int/2addr v2, v3

    iput v2, p1, Landroid/graphics/Rect;->top:I

    .line 2869
    iget v2, p1, Landroid/graphics/Rect;->bottom:I

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getBottom()I

    move-result v3

    add-int/2addr v2, v3

    iput v2, p1, Landroid/graphics/Rect;->bottom:I

    .line 2871
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 2872
    .end local v1    # "group":Landroid/view/ViewGroup;
    goto :goto_0

    .line 2873
    :cond_2
    return-object p1
.end method

.method private getClientWidth()I
    .locals 2

    .line 593
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getMeasuredWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v1

    sub-int/2addr v0, v1

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v1

    sub-int/2addr v0, v1

    return v0
.end method

.method private infoForCurrentScrollPosition()Landroid/support/v4/view/ViewPager$ItemInfo;
    .locals 14

    .line 2355
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v0

    .line 2356
    .local v0, "width":I
    const/4 v1, 0x0

    if-lez v0, :cond_0

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v2

    int-to-float v2, v2

    int-to-float v3, v0

    div-float/2addr v2, v3

    goto :goto_0

    :cond_0
    move v2, v1

    .line 2357
    .local v2, "scrollOffset":F
    :goto_0
    if-lez v0, :cond_1

    iget v1, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v1, v1

    int-to-float v3, v0

    div-float/2addr v1, v3

    nop

    .line 2358
    .local v1, "marginOffset":F
    :cond_1
    const/4 v3, -0x1

    .line 2359
    .local v3, "lastPos":I
    const/4 v4, 0x0

    .line 2360
    .local v4, "lastOffset":F
    const/4 v5, 0x0

    .line 2361
    .local v5, "lastWidth":F
    const/4 v6, 0x1

    .line 2363
    .local v6, "first":Z
    const/4 v7, 0x0

    .line 2364
    .local v7, "lastItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    const/4 v8, 0x0

    .line 2364
    .local v8, "i":I
    :goto_1
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    if-ge v8, v9, :cond_7

    .line 2365
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v9, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2367
    .local v9, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-nez v6, :cond_2

    iget v10, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    add-int/lit8 v11, v3, 0x1

    if-eq v10, v11, :cond_2

    .line 2369
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mTempItem:Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2370
    add-float v10, v4, v5

    add-float/2addr v10, v1

    iput v10, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 2371
    add-int/lit8 v10, v3, 0x1

    iput v10, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2372
    iget-object v10, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget v11, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    invoke-virtual {v10, v11}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v10

    iput v10, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    .line 2373
    add-int/lit8 v8, v8, -0x1

    .line 2375
    :cond_2
    iget v10, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 2377
    .local v10, "offset":F
    move v11, v10

    .line 2378
    .local v11, "leftBound":F
    iget v12, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v12, v10

    add-float/2addr v12, v1

    .line 2379
    .local v12, "rightBound":F
    if-nez v6, :cond_4

    cmpl-float v13, v2, v11

    if-ltz v13, :cond_3

    goto :goto_2

    .line 2384
    :cond_3
    return-object v7

    .line 2380
    :cond_4
    :goto_2
    cmpg-float v13, v2, v12

    if-ltz v13, :cond_6

    iget-object v13, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v13}, Ljava/util/ArrayList;->size()I

    move-result v13

    add-int/lit8 v13, v13, -0x1

    if-ne v8, v13, :cond_5

    goto :goto_3

    .line 2386
    :cond_5
    const/4 v6, 0x0

    .line 2387
    iget v3, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2388
    move v4, v10

    .line 2389
    iget v5, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    .line 2390
    move-object v7, v9

    .line 2364
    .end local v9    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v10    # "offset":F
    .end local v11    # "leftBound":F
    .end local v12    # "rightBound":F
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 2381
    .restart local v9    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v10    # "offset":F
    .restart local v11    # "leftBound":F
    .restart local v12    # "rightBound":F
    :cond_6
    :goto_3
    return-object v9

    .line 2393
    .end local v8    # "i":I
    .end local v9    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v10    # "offset":F
    .end local v11    # "leftBound":F
    .end local v12    # "rightBound":F
    :cond_7
    return-object v7
.end method

.method private static isDecorView(Landroid/view/View;)Z
    .locals 2
    .param p0, "view"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 1490
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    .line 1491
    .local v0, "clazz":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    const-class v1, Landroid/support/v4/view/ViewPager$DecorView;

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getAnnotation(Ljava/lang/Class;)Ljava/lang/annotation/Annotation;

    move-result-object v1

    if-eqz v1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method private isGutterDrag(FF)Z
    .locals 3
    .param p1, "x"    # F
    .param p2, "dx"    # F

    .line 2003
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mGutterSize:I

    int-to-float v0, v0

    cmpg-float v0, p1, v0

    const/4 v1, 0x0

    if-gez v0, :cond_0

    cmpl-float v0, p2, v1

    if-gtz v0, :cond_1

    :cond_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v0

    iget v2, p0, Landroid/support/v4/view/ViewPager;->mGutterSize:I

    sub-int/2addr v0, v2

    int-to-float v0, v0

    cmpl-float v0, p1, v0

    if-lez v0, :cond_2

    cmpg-float v0, p2, v1

    if-gez v0, :cond_2

    :cond_1
    const/4 v0, 0x1

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private onSecondaryPointerUp(Landroid/view/MotionEvent;)V
    .locals 4
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 2636
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v0

    .line 2637
    .local v0, "pointerIndex":I
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    .line 2638
    .local v1, "pointerId":I
    iget v2, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    if-ne v1, v2, :cond_1

    .line 2641
    if-nez v0, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    .line 2642
    .local v2, "newPointerIndex":I
    :goto_0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    iput v3, p0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2643
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v3

    iput v3, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2644
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-eqz v3, :cond_1

    .line 2645
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v3}, Landroid/view/VelocityTracker;->clear()V

    .line 2648
    .end local v2    # "newPointerIndex":I
    :cond_1
    return-void
.end method

.method private pageScrolled(I)Z
    .locals 9
    .param p1, "xpos"    # I

    .line 1810
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_2

    .line 1811
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    if-eqz v0, :cond_0

    .line 1814
    return v1

    .line 1816
    :cond_0
    iput-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mCalledSuper:Z

    .line 1817
    const/4 v0, 0x0

    invoke-virtual {p0, v1, v0, v1}, Landroid/support/v4/view/ViewPager;->onPageScrolled(IFI)V

    .line 1818
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mCalledSuper:Z

    if-nez v0, :cond_1

    .line 1819
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "onPageScrolled did not call superclass implementation"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1822
    :cond_1
    return v1

    .line 1824
    :cond_2
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->infoForCurrentScrollPosition()Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v0

    .line 1825
    .local v0, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v2

    .line 1826
    .local v2, "width":I
    iget v3, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    add-int/2addr v3, v2

    .line 1827
    .local v3, "widthWithMargin":I
    iget v4, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v4, v4

    int-to-float v5, v2

    div-float/2addr v4, v5

    .line 1828
    .local v4, "marginOffset":F
    iget v5, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 1829
    .local v5, "currentPage":I
    int-to-float v6, p1

    int-to-float v7, v2

    div-float/2addr v6, v7

    iget v7, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    sub-float/2addr v6, v7

    iget v7, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v7, v4

    div-float/2addr v6, v7

    .line 1831
    .local v6, "pageOffset":F
    int-to-float v7, v3

    mul-float/2addr v7, v6

    float-to-int v7, v7

    .line 1833
    .local v7, "offsetPixels":I
    iput-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mCalledSuper:Z

    .line 1834
    invoke-virtual {p0, v5, v6, v7}, Landroid/support/v4/view/ViewPager;->onPageScrolled(IFI)V

    .line 1835
    iget-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mCalledSuper:Z

    if-nez v1, :cond_3

    .line 1836
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v8, "onPageScrolled did not call superclass implementation"

    invoke-direct {v1, v8}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 1839
    :cond_3
    const/4 v1, 0x1

    return v1
.end method

.method private performDrag(F)Z
    .locals 17
    .param p1, "x"    # F

    move-object/from16 v0, p0

    .line 2302
    move/from16 v1, p1

    const/4 v2, 0x0

    .line 2304
    .local v2, "needsInvalidate":Z
    iget v3, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    sub-float/2addr v3, v1

    .line 2305
    .local v3, "deltaX":F
    iput v1, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2307
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v4

    int-to-float v4, v4

    .line 2308
    .local v4, "oldScrollX":F
    add-float v5, v4, v3

    .line 2309
    .local v5, "scrollX":F
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v6

    .line 2311
    .local v6, "width":I
    int-to-float v7, v6

    iget v8, v0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    mul-float/2addr v7, v8

    .line 2312
    .local v7, "leftBound":F
    int-to-float v8, v6

    iget v9, v0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    mul-float/2addr v8, v9

    .line 2313
    .local v8, "rightBound":F
    const/4 v9, 0x1

    .line 2314
    .local v9, "leftAbsolute":Z
    const/4 v10, 0x1

    .line 2316
    .local v10, "rightAbsolute":Z
    iget-object v11, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    const/4 v12, 0x0

    invoke-virtual {v11, v12}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2317
    .local v11, "firstItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v12, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    iget-object v13, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v13}, Ljava/util/ArrayList;->size()I

    move-result v13

    add-int/lit8 v13, v13, -0x1

    invoke-virtual {v12, v13}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2318
    .local v12, "lastItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v13, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-eqz v13, :cond_0

    .line 2319
    const/4 v9, 0x0

    .line 2320
    iget v13, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    int-to-float v14, v6

    mul-float v7, v13, v14

    .line 2322
    :cond_0
    iget v13, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget-object v14, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v14}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v14

    add-int/lit8 v14, v14, -0x1

    if-eq v13, v14, :cond_1

    .line 2323
    const/4 v10, 0x0

    .line 2324
    iget v13, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    int-to-float v14, v6

    mul-float v8, v13, v14

    .line 2327
    :cond_1
    cmpg-float v13, v5, v7

    if-gez v13, :cond_3

    .line 2328
    if-eqz v9, :cond_2

    .line 2329
    sub-float v13, v7, v5

    .line 2330
    .local v13, "over":F
    iget-object v14, v0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-static {v13}, Ljava/lang/Math;->abs(F)F

    move-result v15

    int-to-float v1, v6

    div-float/2addr v15, v1

    invoke-virtual {v14, v15}, Landroid/widget/EdgeEffect;->onPull(F)V

    .line 2331
    const/4 v1, 0x1

    .line 2333
    .end local v2    # "needsInvalidate":Z
    .end local v13    # "over":F
    .local v1, "needsInvalidate":Z
    move v2, v1

    .line 2333
    .end local v1    # "needsInvalidate":Z
    .restart local v2    # "needsInvalidate":Z
    :cond_2
    move v5, v7

    goto :goto_0

    .line 2334
    :cond_3
    cmpl-float v1, v5, v8

    if-lez v1, :cond_5

    .line 2335
    if-eqz v10, :cond_4

    .line 2336
    sub-float v1, v5, v8

    .line 2337
    .local v1, "over":F
    iget-object v13, v0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v14

    int-to-float v15, v6

    div-float/2addr v14, v15

    invoke-virtual {v13, v14}, Landroid/widget/EdgeEffect;->onPull(F)V

    .line 2338
    const/4 v1, 0x1

    .line 2340
    .end local v2    # "needsInvalidate":Z
    .local v1, "needsInvalidate":Z
    move v2, v1

    .line 2340
    .end local v1    # "needsInvalidate":Z
    .restart local v2    # "needsInvalidate":Z
    :cond_4
    move v5, v8

    .line 2343
    :cond_5
    :goto_0
    iget v1, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    float-to-int v13, v5

    int-to-float v13, v13

    sub-float v13, v5, v13

    add-float/2addr v1, v13

    iput v1, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2344
    float-to-int v1, v5

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v13

    invoke-virtual {v0, v1, v13}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 2345
    float-to-int v1, v5

    invoke-direct {v0, v1}, Landroid/support/v4/view/ViewPager;->pageScrolled(I)Z

    .line 2347
    return v2
.end method

.method private recomputeScrollPosition(IIII)V
    .locals 6
    .param p1, "width"    # I
    .param p2, "oldWidth"    # I
    .param p3, "margin"    # I
    .param p4, "oldMargin"    # I

    .line 1647
    if-lez p2, :cond_1

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 1648
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v0}, Landroid/widget/Scroller;->isFinished()Z

    move-result v0

    if-nez v0, :cond_0

    .line 1649
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getCurrentItem()I

    move-result v1

    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v2

    mul-int/2addr v1, v2

    invoke-virtual {v0, v1}, Landroid/widget/Scroller;->setFinalX(I)V

    goto :goto_1

    .line 1651
    :cond_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v0

    sub-int v0, p1, v0

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v1

    sub-int/2addr v0, v1

    add-int/2addr v0, p3

    .line 1652
    .local v0, "widthWithMargin":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v1

    sub-int v1, p2, v1

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v2

    sub-int/2addr v1, v2

    add-int/2addr v1, p4

    .line 1654
    .local v1, "oldWidthWithMargin":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v2

    .line 1655
    .local v2, "xpos":I
    int-to-float v3, v2

    int-to-float v4, v1

    div-float/2addr v3, v4

    .line 1656
    .local v3, "pageOffset":F
    int-to-float v4, v0

    mul-float/2addr v4, v3

    float-to-int v4, v4

    .line 1658
    .local v4, "newOffsetPixels":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v5

    invoke-virtual {p0, v4, v5}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 1659
    .end local v0    # "widthWithMargin":I
    .end local v1    # "oldWidthWithMargin":I
    .end local v2    # "xpos":I
    .end local v3    # "pageOffset":F
    .end local v4    # "newOffsetPixels":I
    goto :goto_1

    .line 1661
    :cond_1
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->infoForPosition(I)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v0

    .line 1662
    .local v0, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v0, :cond_2

    iget v1, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v2, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    goto :goto_0

    :cond_2
    const/4 v1, 0x0

    .line 1663
    .local v1, "scrollOffset":F
    :goto_0
    nop

    .line 1664
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v2

    sub-int v2, p1, v2

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v3

    sub-int/2addr v2, v3

    int-to-float v2, v2

    mul-float/2addr v2, v1

    float-to-int v2, v2

    .line 1665
    .local v2, "scrollPos":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v3

    if-eq v2, v3, :cond_3

    .line 1666
    const/4 v3, 0x0

    invoke-direct {p0, v3}, Landroid/support/v4/view/ViewPager;->completeScroll(Z)V

    .line 1667
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v3

    invoke-virtual {p0, v2, v3}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 1670
    .end local v0    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v1    # "scrollOffset":F
    .end local v2    # "scrollPos":I
    :cond_3
    :goto_1
    return-void
.end method

.method private removeNonDecorViews()V
    .locals 4

    .line 549
    const/4 v0, 0x0

    .line 549
    .local v0, "i":I
    :goto_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 550
    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 551
    .local v1, "child":Landroid/view/View;
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 552
    .local v2, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v3, v2, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v3, :cond_0

    .line 553
    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->removeViewAt(I)V

    .line 554
    add-int/lit8 v0, v0, -0x1

    .line 549
    .end local v1    # "child":Landroid/view/View;
    .end local v2    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 557
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method private requestParentDisallowInterceptTouchEvent(Z)V
    .locals 1
    .param p1, "disallowIntercept"    # Z

    .line 2295
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 2296
    .local v0, "parent":Landroid/view/ViewParent;
    if-eqz v0, :cond_0

    .line 2297
    invoke-interface {v0, p1}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 2299
    :cond_0
    return-void
.end method

.method private resetTouch()Z
    .locals 1

    .line 2286
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2287
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->endDrag()V

    .line 2288
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v0}, Landroid/widget/EdgeEffect;->onRelease()V

    .line 2289
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v0}, Landroid/widget/EdgeEffect;->onRelease()V

    .line 2290
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v0}, Landroid/widget/EdgeEffect;->isFinished()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v0}, Landroid/widget/EdgeEffect;->isFinished()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    .line 2291
    .local v0, "needsInvalidate":Z
    :goto_1
    return v0
.end method

.method private scrollToItem(IZIZ)V
    .locals 7
    .param p1, "item"    # I
    .param p2, "smoothScroll"    # Z
    .param p3, "velocity"    # I
    .param p4, "dispatchSelected"    # Z

    .line 669
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewPager;->infoForPosition(I)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v0

    .line 670
    .local v0, "curInfo":Landroid/support/v4/view/ViewPager$ItemInfo;
    const/4 v1, 0x0

    .line 671
    .local v1, "destX":I
    if-eqz v0, :cond_0

    .line 672
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v2

    .line 673
    .local v2, "width":I
    int-to-float v3, v2

    iget v4, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    iget v5, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v6, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    .line 674
    invoke-static {v5, v6}, Ljava/lang/Math;->min(FF)F

    move-result v5

    .line 673
    invoke-static {v4, v5}, Ljava/lang/Math;->max(FF)F

    move-result v4

    mul-float/2addr v3, v4

    float-to-int v1, v3

    .line 676
    .end local v2    # "width":I
    :cond_0
    const/4 v2, 0x0

    if-eqz p2, :cond_1

    .line 677
    invoke-virtual {p0, v1, v2, p3}, Landroid/support/v4/view/ViewPager;->smoothScrollTo(III)V

    .line 678
    if-eqz p4, :cond_3

    .line 679
    invoke-direct {p0, p1}, Landroid/support/v4/view/ViewPager;->dispatchOnPageSelected(I)V

    goto :goto_0

    .line 682
    :cond_1
    if-eqz p4, :cond_2

    .line 683
    invoke-direct {p0, p1}, Landroid/support/v4/view/ViewPager;->dispatchOnPageSelected(I)V

    .line 685
    :cond_2
    invoke-direct {p0, v2}, Landroid/support/v4/view/ViewPager;->completeScroll(Z)V

    .line 686
    invoke-virtual {p0, v1, v2}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 687
    invoke-direct {p0, v1}, Landroid/support/v4/view/ViewPager;->pageScrolled(I)Z

    .line 689
    :cond_3
    :goto_0
    return-void
.end method

.method private setScrollingCacheEnabled(Z)V
    .locals 1
    .param p1, "enabled"    # Z

    .line 2661
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mScrollingCacheEnabled:Z

    if-eq v0, p1, :cond_0

    .line 2662
    iput-boolean p1, p0, Landroid/support/v4/view/ViewPager;->mScrollingCacheEnabled:Z

    .line 2673
    :cond_0
    return-void
.end method

.method private sortChildDrawingOrder()V
    .locals 4

    .line 1274
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrder:I

    if-eqz v0, :cond_2

    .line 1275
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    if-nez v0, :cond_0

    .line 1276
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    goto :goto_0

    .line 1278
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 1280
    :goto_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v0

    .line 1281
    .local v0, "childCount":I
    const/4 v1, 0x0

    .line 1281
    .local v1, "i":I
    :goto_1
    if-ge v1, v0, :cond_1

    .line 1282
    invoke-virtual {p0, v1}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1283
    .local v2, "child":Landroid/view/View;
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1281
    .end local v2    # "child":Landroid/view/View;
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 1285
    .end local v1    # "i":I
    :cond_1
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    sget-object v2, Landroid/support/v4/view/ViewPager;->sPositionComparator:Landroid/support/v4/view/ViewPager$ViewPositionComparator;

    invoke-static {v1, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 1287
    .end local v0    # "childCount":I
    :cond_2
    return-void
.end method


# virtual methods
.method public addFocusables(Ljava/util/ArrayList;II)V
    .locals 7
    .param p2, "direction"    # I
    .param p3, "focusableMode"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;II)V"
        }
    .end annotation

    .line 2897
    .local p1, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 2899
    .local v0, "focusableCount":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getDescendantFocusability()I

    move-result v1

    .line 2901
    .local v1, "descendantFocusability":I
    const/high16 v2, 0x60000

    if-eq v1, v2, :cond_1

    .line 2902
    const/4 v2, 0x0

    .line 2902
    .local v2, "i":I
    :goto_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v3

    if-ge v2, v3, :cond_1

    .line 2903
    invoke-virtual {p0, v2}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 2904
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-nez v4, :cond_0

    .line 2905
    invoke-virtual {p0, v3}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v4

    .line 2906
    .local v4, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v4, :cond_0

    iget v5, v4, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v6, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v5, v6, :cond_0

    .line 2907
    invoke-virtual {v3, p1, p2, p3}, Landroid/view/View;->addFocusables(Ljava/util/ArrayList;II)V

    .line 2902
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2917
    .end local v2    # "i":I
    :cond_1
    const/high16 v2, 0x40000

    if-ne v1, v2, :cond_2

    .line 2918
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v2

    if-ne v0, v2, :cond_5

    .line 2921
    :cond_2
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->isFocusable()Z

    move-result v2

    if-nez v2, :cond_3

    .line 2922
    return-void

    .line 2924
    :cond_3
    and-int/lit8 v2, p3, 0x1

    const/4 v3, 0x1

    if-ne v2, v3, :cond_4

    .line 2925
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->isInTouchMode()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->isFocusableInTouchMode()Z

    move-result v2

    if-nez v2, :cond_4

    .line 2926
    return-void

    .line 2928
    :cond_4
    if-eqz p1, :cond_5

    .line 2929
    invoke-virtual {p1, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 2932
    :cond_5
    return-void
.end method

.method addNewItem(II)Landroid/support/v4/view/ViewPager$ItemInfo;
    .locals 2
    .param p1, "position"    # I
    .param p2, "index"    # I

    .line 1000
    new-instance v0, Landroid/support/v4/view/ViewPager$ItemInfo;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$ItemInfo;-><init>()V

    .line 1001
    .local v0, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iput p1, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 1002
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v1, p0, p1}, Landroid/support/v4/view/PagerAdapter;->instantiateItem(Landroid/view/ViewGroup;I)Ljava/lang/Object;

    move-result-object v1

    iput-object v1, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    .line 1003
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v1, p1}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v1

    iput v1, v0, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    .line 1004
    if-ltz p2, :cond_1

    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lt p2, v1, :cond_0

    goto :goto_0

    .line 1007
    :cond_0
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, p2, v0}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    goto :goto_1

    .line 1005
    :cond_1
    :goto_0
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1009
    :goto_1
    return-object v0
.end method

.method public addOnAdapterChangeListener(Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 574
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    if-nez v0, :cond_0

    .line 575
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    .line 577
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 578
    return-void
.end method

.method public addOnPageChangeListener(Landroid/support/v4/view/ViewPager$OnPageChangeListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 716
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-nez v0, :cond_0

    .line 717
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    .line 719
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 720
    return-void
.end method

.method public addTouchables(Ljava/util/ArrayList;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 2942
    .local p1, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    const/4 v0, 0x0

    .line 2942
    .local v0, "i":I
    :goto_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 2943
    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 2944
    .local v1, "child":Landroid/view/View;
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-nez v2, :cond_0

    .line 2945
    invoke-virtual {p0, v1}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v2

    .line 2946
    .local v2, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v2, :cond_0

    iget v3, v2, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v4, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v3, v4, :cond_0

    .line 2947
    invoke-virtual {v1, p1}, Landroid/view/View;->addTouchables(Ljava/util/ArrayList;)V

    .line 2942
    .end local v1    # "child":Landroid/view/View;
    .end local v2    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 2951
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method public addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V
    .locals 3
    .param p1, "child"    # Landroid/view/View;
    .param p2, "index"    # I
    .param p3, "params"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1464
    invoke-virtual {p0, p3}, Landroid/support/v4/view/ViewPager;->checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1465
    invoke-virtual {p0, p3}, Landroid/support/v4/view/ViewPager;->generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;

    move-result-object p3

    .line 1467
    :cond_0
    move-object v0, p3

    check-cast v0, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1469
    .local v0, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v1, v0, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    invoke-static {p1}, Landroid/support/v4/view/ViewPager;->isDecorView(Landroid/view/View;)Z

    move-result v2

    or-int/2addr v1, v2

    iput-boolean v1, v0, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    .line 1470
    iget-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mInLayout:Z

    if-eqz v1, :cond_2

    .line 1471
    if-eqz v0, :cond_1

    iget-boolean v1, v0, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-eqz v1, :cond_1

    .line 1472
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "Cannot add pager decor view during layout"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 1474
    :cond_1
    const/4 v1, 0x1

    iput-boolean v1, v0, Landroid/support/v4/view/ViewPager$LayoutParams;->needsMeasure:Z

    .line 1475
    invoke-virtual {p0, p1, p2, p3}, Landroid/support/v4/view/ViewPager;->addViewInLayout(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)Z

    goto :goto_0

    .line 1477
    :cond_2
    invoke-super {p0, p1, p2, p3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 1487
    :goto_0
    return-void
.end method

.method public arrowScroll(I)Z
    .locals 6
    .param p1, "direction"    # I

    .line 2785
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->findFocus()Landroid/view/View;

    move-result-object v0

    .line 2786
    .local v0, "currentFocused":Landroid/view/View;
    if-ne v0, p0, :cond_0

    .line 2787
    const/4 v0, 0x0

    goto :goto_3

    .line 2788
    :cond_0
    if-eqz v0, :cond_4

    .line 2789
    const/4 v1, 0x0

    .line 2790
    .local v1, "isChild":Z
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    .line 2790
    .local v2, "parent":Landroid/view/ViewParent;
    :goto_0
    instance-of v3, v2, Landroid/view/ViewGroup;

    if-eqz v3, :cond_2

    .line 2792
    if-ne v2, p0, :cond_1

    .line 2793
    const/4 v1, 0x1

    .line 2794
    goto :goto_1

    .line 2791
    :cond_1
    invoke-interface {v2}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    goto :goto_0

    .line 2797
    .end local v2    # "parent":Landroid/view/ViewParent;
    :cond_2
    :goto_1
    if-nez v1, :cond_4

    .line 2799
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 2800
    .local v2, "sb":Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2801
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    .line 2801
    .local v3, "parent":Landroid/view/ViewParent;
    :goto_2
    instance-of v4, v3, Landroid/view/ViewGroup;

    if-eqz v4, :cond_3

    .line 2803
    const-string v4, " => "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2802
    invoke-interface {v3}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    goto :goto_2

    .line 2805
    .end local v3    # "parent":Landroid/view/ViewParent;
    :cond_3
    const-string v3, "ViewPager"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "arrowScroll tried to find focus based on non-child current focused view "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2806
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 2805
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 2807
    const/4 v0, 0x0

    .line 2811
    .end local v1    # "isChild":Z
    .end local v2    # "sb":Ljava/lang/StringBuilder;
    :cond_4
    :goto_3
    const/4 v1, 0x0

    .line 2813
    .local v1, "handled":Z
    invoke-static {}, Landroid/view/FocusFinder;->getInstance()Landroid/view/FocusFinder;

    move-result-object v2

    invoke-virtual {v2, p0, v0, p1}, Landroid/view/FocusFinder;->findNextFocus(Landroid/view/ViewGroup;Landroid/view/View;I)Landroid/view/View;

    move-result-object v2

    .line 2815
    .local v2, "nextFocused":Landroid/view/View;
    const/16 v3, 0x42

    const/16 v4, 0x11

    if-eqz v2, :cond_8

    if-eq v2, v0, :cond_8

    .line 2816
    if-ne p1, v4, :cond_6

    .line 2819
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    invoke-direct {p0, v3, v2}, Landroid/support/v4/view/ViewPager;->getChildRectInPagerCoordinates(Landroid/graphics/Rect;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v3

    iget v3, v3, Landroid/graphics/Rect;->left:I

    .line 2820
    .local v3, "nextLeft":I
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    invoke-direct {p0, v4, v0}, Landroid/support/v4/view/ViewPager;->getChildRectInPagerCoordinates(Landroid/graphics/Rect;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v4

    iget v4, v4, Landroid/graphics/Rect;->left:I

    .line 2821
    .local v4, "currLeft":I
    if-eqz v0, :cond_5

    if-lt v3, v4, :cond_5

    .line 2822
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageLeft()Z

    move-result v1

    goto :goto_4

    .line 2824
    :cond_5
    invoke-virtual {v2}, Landroid/view/View;->requestFocus()Z

    move-result v1

    .line 2826
    .end local v3    # "nextLeft":I
    .end local v4    # "currLeft":I
    :goto_4
    goto :goto_7

    :cond_6
    if-ne p1, v3, :cond_c

    .line 2829
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    invoke-direct {p0, v3, v2}, Landroid/support/v4/view/ViewPager;->getChildRectInPagerCoordinates(Landroid/graphics/Rect;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v3

    iget v3, v3, Landroid/graphics/Rect;->left:I

    .line 2830
    .restart local v3    # "nextLeft":I
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mTempRect:Landroid/graphics/Rect;

    invoke-direct {p0, v4, v0}, Landroid/support/v4/view/ViewPager;->getChildRectInPagerCoordinates(Landroid/graphics/Rect;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v4

    iget v4, v4, Landroid/graphics/Rect;->left:I

    .line 2831
    .restart local v4    # "currLeft":I
    if-eqz v0, :cond_7

    if-gt v3, v4, :cond_7

    .line 2832
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageRight()Z

    move-result v1

    goto :goto_5

    .line 2834
    :cond_7
    invoke-virtual {v2}, Landroid/view/View;->requestFocus()Z

    move-result v1

    .line 2836
    .end local v3    # "nextLeft":I
    .end local v4    # "currLeft":I
    :goto_5
    goto :goto_7

    .line 2837
    :cond_8
    if-eq p1, v4, :cond_b

    const/4 v4, 0x1

    if-ne p1, v4, :cond_9

    goto :goto_6

    .line 2840
    :cond_9
    if-eq p1, v3, :cond_a

    const/4 v3, 0x2

    if-ne p1, v3, :cond_c

    .line 2842
    :cond_a
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageRight()Z

    move-result v1

    goto :goto_7

    .line 2839
    :cond_b
    :goto_6
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageLeft()Z

    move-result v1

    .line 2844
    :cond_c
    :goto_7
    if-eqz v1, :cond_d

    .line 2845
    invoke-static {p1}, Landroid/view/SoundEffectConstants;->getContantForFocusDirection(I)I

    move-result v3

    invoke-virtual {p0, v3}, Landroid/support/v4/view/ViewPager;->playSoundEffect(I)V

    .line 2847
    :cond_d
    return v1
.end method

.method public beginFakeDrag()Z
    .locals 12

    .line 2520
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v0, :cond_0

    .line 2521
    const/4 v0, 0x0

    return v0

    .line 2523
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    .line 2524
    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    .line 2525
    const/4 v1, 0x0

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    .line 2526
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v1, :cond_1

    .line 2527
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v1

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    goto :goto_0

    .line 2529
    :cond_1
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v1}, Landroid/view/VelocityTracker;->clear()V

    .line 2531
    :goto_0
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v10

    .line 2532
    .local v10, "time":J
    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    move-wide v2, v10

    move-wide v4, v10

    invoke-static/range {v2 .. v9}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v1

    .line 2533
    .local v1, "ev":Landroid/view/MotionEvent;
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v2, v1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 2534
    invoke-virtual {v1}, Landroid/view/MotionEvent;->recycle()V

    .line 2535
    iput-wide v10, p0, Landroid/support/v4/view/ViewPager;->mFakeDragBeginTime:J

    .line 2536
    return v0
.end method

.method protected canScroll(Landroid/view/View;ZIII)Z
    .locals 14
    .param p1, "v"    # Landroid/view/View;
    .param p2, "checkV"    # Z
    .param p3, "dx"    # I
    .param p4, "x"    # I
    .param p5, "y"    # I

    move-object v0, p1

    .line 2711
    instance-of v1, v0, Landroid/view/ViewGroup;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    .line 2712
    move-object v1, v0

    check-cast v1, Landroid/view/ViewGroup;

    .line 2713
    .local v1, "group":Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/View;->getScrollX()I

    move-result v3

    .line 2714
    .local v3, "scrollX":I
    invoke-virtual {v0}, Landroid/view/View;->getScrollY()I

    move-result v4

    .line 2715
    .local v4, "scrollY":I
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    .line 2717
    .local v5, "count":I
    add-int/lit8 v6, v5, -0x1

    .line 2717
    .local v6, "i":I
    :goto_0
    if-ltz v6, :cond_1

    .line 2720
    invoke-virtual {v1, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    .line 2721
    .local v13, "child":Landroid/view/View;
    add-int v7, p4, v3

    invoke-virtual {v13}, Landroid/view/View;->getLeft()I

    move-result v8

    if-lt v7, v8, :cond_0

    add-int v7, p4, v3

    invoke-virtual {v13}, Landroid/view/View;->getRight()I

    move-result v8

    if-ge v7, v8, :cond_0

    add-int v7, p5, v4

    .line 2722
    invoke-virtual {v13}, Landroid/view/View;->getTop()I

    move-result v8

    if-lt v7, v8, :cond_0

    add-int v7, p5, v4

    invoke-virtual {v13}, Landroid/view/View;->getBottom()I

    move-result v8

    if-ge v7, v8, :cond_0

    const/4 v9, 0x1

    add-int v7, p4, v3

    .line 2723
    invoke-virtual {v13}, Landroid/view/View;->getLeft()I

    move-result v8

    sub-int v11, v7, v8

    add-int v7, p5, v4

    .line 2724
    invoke-virtual {v13}, Landroid/view/View;->getTop()I

    move-result v8

    sub-int v12, v7, v8

    .line 2723
    move-object v7, p0

    move-object v8, v13

    move/from16 v10, p3

    invoke-virtual/range {v7 .. v12}, Landroid/support/v4/view/ViewPager;->canScroll(Landroid/view/View;ZIII)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 2725
    return v2

    .line 2717
    .end local v13    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v6, v6, -0x1

    goto :goto_0

    .line 2730
    .end local v1    # "group":Landroid/view/ViewGroup;
    .end local v3    # "scrollX":I
    .end local v4    # "scrollY":I
    .end local v5    # "count":I
    .end local v6    # "i":I
    :cond_1
    if-eqz p2, :cond_2

    move/from16 v3, p3

    neg-int v4, v3

    invoke-virtual {v0, v4}, Landroid/view/View;->canScrollHorizontally(I)Z

    move-result v4

    if-eqz v4, :cond_3

    goto :goto_1

    :cond_2
    move/from16 v3, p3

    :cond_3
    const/4 v2, 0x0

    :goto_1
    return v2
.end method

.method public canScrollHorizontally(I)Z
    .locals 6
    .param p1, "direction"    # I

    .line 2684
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 2685
    return v1

    .line 2688
    :cond_0
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v0

    .line 2689
    .local v0, "width":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v2

    .line 2690
    .local v2, "scrollX":I
    const/4 v3, 0x1

    if-gez p1, :cond_2

    .line 2691
    int-to-float v4, v0

    iget v5, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    mul-float/2addr v4, v5

    float-to-int v4, v4

    if-le v2, v4, :cond_1

    move v1, v3

    nop

    :cond_1
    return v1

    .line 2692
    :cond_2
    if-lez p1, :cond_4

    .line 2693
    int-to-float v4, v0

    iget v5, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    mul-float/2addr v4, v5

    float-to-int v4, v4

    if-ge v2, v4, :cond_3

    move v1, v3

    nop

    :cond_3
    return v1

    .line 2695
    :cond_4
    return v1
.end method

.method protected checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 3021
    instance-of v0, p1, Landroid/support/v4/view/ViewPager$LayoutParams;

    if-eqz v0, :cond_0

    invoke-super {p0, p1}, Landroid/view/ViewGroup;->checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public clearOnPageChangeListeners()V
    .locals 1

    .line 738
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_0

    .line 739
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 741
    :cond_0
    return-void
.end method

.method public computeScroll()V
    .locals 5

    .line 1785
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mIsScrollStarted:Z

    .line 1786
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v1}, Landroid/widget/Scroller;->isFinished()Z

    move-result v1

    if-nez v1, :cond_2

    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v1}, Landroid/widget/Scroller;->computeScrollOffset()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1787
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v0

    .line 1788
    .local v0, "oldX":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v1

    .line 1789
    .local v1, "oldY":I
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v2}, Landroid/widget/Scroller;->getCurrX()I

    move-result v2

    .line 1790
    .local v2, "x":I
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v3}, Landroid/widget/Scroller;->getCurrY()I

    move-result v3

    .line 1792
    .local v3, "y":I
    if-ne v0, v2, :cond_0

    if-eq v1, v3, :cond_1

    .line 1793
    :cond_0
    invoke-virtual {p0, v2, v3}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 1794
    invoke-direct {p0, v2}, Landroid/support/v4/view/ViewPager;->pageScrolled(I)Z

    move-result v4

    if-nez v4, :cond_1

    .line 1795
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v4}, Landroid/widget/Scroller;->abortAnimation()V

    .line 1796
    const/4 v4, 0x0

    invoke-virtual {p0, v4, v3}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 1801
    :cond_1
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 1802
    return-void

    .line 1806
    .end local v0    # "oldX":I
    .end local v1    # "oldY":I
    .end local v2    # "x":I
    .end local v3    # "y":I
    :cond_2
    invoke-direct {p0, v0}, Landroid/support/v4/view/ViewPager;->completeScroll(Z)V

    .line 1807
    return-void
.end method

.method dataSetChanged()V
    .locals 12

    .line 1015
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v0

    .line 1016
    .local v0, "adapterCount":I
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mExpectedAdapterCount:I

    .line 1017
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    iget v2, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    mul-int/lit8 v2, v2, 0x2

    const/4 v3, 0x1

    add-int/2addr v2, v3

    const/4 v4, 0x0

    if-ge v1, v2, :cond_0

    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    .line 1018
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v1, v0, :cond_0

    move v1, v3

    goto :goto_0

    :cond_0
    move v1, v4

    .line 1019
    .local v1, "needPopulate":Z
    :goto_0
    iget v2, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    .line 1021
    .local v2, "newCurrItem":I
    const/4 v5, 0x0

    .line 1022
    .local v5, "isUpdating":Z
    move v6, v2

    move v2, v1

    move v1, v4

    .line 1022
    .local v1, "i":I
    .local v2, "needPopulate":Z
    .local v6, "newCurrItem":I
    :goto_1
    iget-object v7, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    if-ge v1, v7, :cond_6

    .line 1023
    iget-object v7, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1024
    .local v7, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v8, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget-object v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    invoke-virtual {v8, v9}, Landroid/support/v4/view/PagerAdapter;->getItemPosition(Ljava/lang/Object;)I

    move-result v8

    .line 1026
    .local v8, "newPos":I
    const/4 v9, -0x1

    if-ne v8, v9, :cond_1

    .line 1027
    goto :goto_2

    .line 1030
    :cond_1
    const/4 v9, -0x2

    if-ne v8, v9, :cond_3

    .line 1031
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v9, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 1032
    add-int/lit8 v1, v1, -0x1

    .line 1034
    if-nez v5, :cond_2

    .line 1035
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v9, p0}, Landroid/support/v4/view/PagerAdapter;->startUpdate(Landroid/view/ViewGroup;)V

    .line 1036
    const/4 v5, 0x1

    .line 1039
    :cond_2
    iget-object v9, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget v10, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget-object v11, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    invoke-virtual {v9, p0, v10, v11}, Landroid/support/v4/view/PagerAdapter;->destroyItem(Landroid/view/ViewGroup;ILjava/lang/Object;)V

    .line 1040
    const/4 v2, 0x1

    .line 1042
    iget v9, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    iget v10, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v9, v10, :cond_5

    .line 1044
    iget v9, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/lit8 v10, v0, -0x1

    invoke-static {v9, v10}, Ljava/lang/Math;->min(II)I

    move-result v9

    invoke-static {v4, v9}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 1045
    const/4 v2, 0x1

    goto :goto_2

    .line 1050
    :cond_3
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-eq v9, v8, :cond_5

    .line 1051
    iget v9, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v10, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v9, v10, :cond_4

    .line 1053
    move v6, v8

    .line 1056
    :cond_4
    iput v8, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 1057
    const/4 v2, 0x1

    .line 1022
    .end local v7    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v8    # "newPos":I
    :cond_5
    :goto_2
    add-int/2addr v1, v3

    goto :goto_1

    .line 1061
    .end local v1    # "i":I
    :cond_6
    if-eqz v5, :cond_7

    .line 1062
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v1, p0}, Landroid/support/v4/view/PagerAdapter;->finishUpdate(Landroid/view/ViewGroup;)V

    .line 1065
    :cond_7
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    sget-object v7, Landroid/support/v4/view/ViewPager;->COMPARATOR:Ljava/util/Comparator;

    invoke-static {v1, v7}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 1067
    if-eqz v2, :cond_a

    .line 1069
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v1

    .line 1070
    .local v1, "childCount":I
    move v7, v4

    .line 1070
    .local v7, "i":I
    :goto_3
    if-ge v7, v1, :cond_9

    .line 1071
    invoke-virtual {p0, v7}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 1072
    .local v8, "child":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    check-cast v9, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1073
    .local v9, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v10, v9, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v10, :cond_8

    .line 1074
    const/4 v10, 0x0

    iput v10, v9, Landroid/support/v4/view/ViewPager$LayoutParams;->widthFactor:F

    .line 1070
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    :cond_8
    add-int/lit8 v7, v7, 0x1

    goto :goto_3

    .line 1078
    .end local v7    # "i":I
    :cond_9
    invoke-virtual {p0, v6, v4, v3}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZ)V

    .line 1079
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->requestLayout()V

    .line 1081
    .end local v1    # "childCount":I
    :cond_a
    return-void
.end method

.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 1
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 2736
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewPager;->executeKeyEvent(Landroid/view/KeyEvent;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method public dispatchPopulateAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)Z
    .locals 7
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 2989
    invoke-virtual {p1}, Landroid/view/accessibility/AccessibilityEvent;->getEventType()I

    move-result v0

    const/16 v1, 0x1000

    if-ne v0, v1, :cond_0

    .line 2990
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->dispatchPopulateAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)Z

    move-result v0

    return v0

    .line 2994
    :cond_0
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v0

    .line 2995
    .local v0, "childCount":I
    const/4 v1, 0x0

    move v2, v1

    .line 2995
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_2

    .line 2996
    invoke-virtual {p0, v2}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 2997
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-nez v4, :cond_1

    .line 2998
    invoke-virtual {p0, v3}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v4

    .line 2999
    .local v4, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v4, :cond_1

    iget v5, v4, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v6, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v5, v6, :cond_1

    .line 3000
    invoke-virtual {v3, p1}, Landroid/view/View;->dispatchPopulateAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 3001
    const/4 v1, 0x1

    return v1

    .line 2995
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 3006
    .end local v2    # "i":I
    :cond_2
    return v1
.end method

.method distanceInfluenceForSnapDuration(F)F
    .locals 2
    .param p1, "f"    # F

    .line 919
    const/high16 v0, 0x3f000000    # 0.5f

    sub-float/2addr p1, v0

    .line 920
    const v0, 0x3ef1463b

    mul-float/2addr p1, v0

    .line 921
    float-to-double v0, p1

    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide v0

    double-to-float v0, v0

    return v0
.end method

.method public draw(Landroid/graphics/Canvas;)V
    .locals 8
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .line 2418
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->draw(Landroid/graphics/Canvas;)V

    .line 2419
    const/4 v0, 0x0

    .line 2421
    .local v0, "needsInvalidate":Z
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getOverScrollMode()I

    move-result v1

    .line 2422
    .local v1, "overScrollMode":I
    if-eqz v1, :cond_1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_0

    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v3, :cond_0

    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    .line 2424
    invoke-virtual {v3}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v3

    if-le v3, v2, :cond_0

    goto :goto_0

    .line 2448
    :cond_0
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v2}, Landroid/widget/EdgeEffect;->finish()V

    .line 2449
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v2}, Landroid/widget/EdgeEffect;->finish()V

    goto/16 :goto_1

    .line 2425
    :cond_1
    :goto_0
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v2}, Landroid/widget/EdgeEffect;->isFinished()Z

    move-result v2

    if-nez v2, :cond_2

    .line 2426
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    move-result v2

    .line 2427
    .local v2, "restoreCount":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v4

    sub-int/2addr v3, v4

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    .line 2428
    .local v3, "height":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v4

    .line 2430
    .local v4, "width":I
    const/high16 v5, 0x43870000    # 270.0f

    invoke-virtual {p1, v5}, Landroid/graphics/Canvas;->rotate(F)V

    .line 2431
    neg-int v5, v3

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v6

    add-int/2addr v5, v6

    int-to-float v5, v5

    iget v6, p0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    int-to-float v7, v4

    mul-float/2addr v6, v7

    invoke-virtual {p1, v5, v6}, Landroid/graphics/Canvas;->translate(FF)V

    .line 2432
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v5, v3, v4}, Landroid/widget/EdgeEffect;->setSize(II)V

    .line 2433
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v5, p1}, Landroid/widget/EdgeEffect;->draw(Landroid/graphics/Canvas;)Z

    move-result v5

    or-int/2addr v0, v5

    .line 2434
    invoke-virtual {p1, v2}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 2436
    .end local v2    # "restoreCount":I
    .end local v3    # "height":I
    .end local v4    # "width":I
    :cond_2
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v2}, Landroid/widget/EdgeEffect;->isFinished()Z

    move-result v2

    if-nez v2, :cond_3

    .line 2437
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    move-result v2

    .line 2438
    .restart local v2    # "restoreCount":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v3

    .line 2439
    .local v3, "width":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getHeight()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v5

    sub-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingBottom()I

    move-result v5

    sub-int/2addr v4, v5

    .line 2441
    .local v4, "height":I
    const/high16 v5, 0x42b40000    # 90.0f

    invoke-virtual {p1, v5}, Landroid/graphics/Canvas;->rotate(F)V

    .line 2442
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v5

    neg-int v5, v5

    int-to-float v5, v5

    iget v6, p0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    const/high16 v7, 0x3f800000    # 1.0f

    add-float/2addr v6, v7

    neg-float v6, v6

    int-to-float v7, v3

    mul-float/2addr v6, v7

    invoke-virtual {p1, v5, v6}, Landroid/graphics/Canvas;->translate(FF)V

    .line 2443
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v5, v4, v3}, Landroid/widget/EdgeEffect;->setSize(II)V

    .line 2444
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    invoke-virtual {v5, p1}, Landroid/widget/EdgeEffect;->draw(Landroid/graphics/Canvas;)Z

    move-result v5

    or-int/2addr v0, v5

    .line 2445
    invoke-virtual {p1, v2}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 2446
    .end local v2    # "restoreCount":I
    .end local v3    # "width":I
    .end local v4    # "height":I
    nop

    .line 2452
    :cond_3
    :goto_1
    if-eqz v0, :cond_4

    .line 2454
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 2456
    :cond_4
    return-void
.end method

.method protected drawableStateChanged()V
    .locals 2

    .line 907
    invoke-super {p0}, Landroid/view/ViewGroup;->drawableStateChanged()V

    .line 908
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    .line 909
    .local v0, "d":Landroid/graphics/drawable/Drawable;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 910
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getDrawableState()[I

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    .line 912
    :cond_0
    return-void
.end method

.method public endFakeDrag()V
    .locals 10

    .line 2546
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    if-nez v0, :cond_0

    .line 2547
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "No fake drag in progress. Call beginFakeDrag first."

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 2550
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v0, :cond_1

    .line 2551
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 2552
    .local v0, "velocityTracker":Landroid/view/VelocityTracker;
    const/16 v1, 0x3e8

    iget v2, p0, Landroid/support/v4/view/ViewPager;->mMaximumVelocity:I

    int-to-float v2, v2

    invoke-virtual {v0, v1, v2}, Landroid/view/VelocityTracker;->computeCurrentVelocity(IF)V

    .line 2553
    iget v1, p0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->getXVelocity(I)F

    move-result v1

    float-to-int v1, v1

    .line 2554
    .local v1, "initialVelocity":I
    const/4 v2, 0x1

    iput-boolean v2, p0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 2555
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v3

    .line 2556
    .local v3, "width":I
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v4

    .line 2557
    .local v4, "scrollX":I
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->infoForCurrentScrollPosition()Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v5

    .line 2558
    .local v5, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v6, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2559
    .local v6, "currentPage":I
    int-to-float v7, v4

    int-to-float v8, v3

    div-float/2addr v7, v8

    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    sub-float/2addr v7, v8

    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    div-float/2addr v7, v8

    .line 2560
    .local v7, "pageOffset":F
    iget v8, p0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    iget v9, p0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    sub-float/2addr v8, v9

    float-to-int v8, v8

    .line 2561
    .local v8, "totalDelta":I
    invoke-direct {p0, v6, v7, v1, v8}, Landroid/support/v4/view/ViewPager;->determineTargetPage(IFII)I

    move-result v9

    .line 2563
    .local v9, "nextPage":I
    invoke-virtual {p0, v9, v2, v2, v1}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZI)V

    .line 2565
    .end local v0    # "velocityTracker":Landroid/view/VelocityTracker;
    .end local v1    # "initialVelocity":I
    .end local v3    # "width":I
    .end local v4    # "scrollX":I
    .end local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v6    # "currentPage":I
    .end local v7    # "pageOffset":F
    .end local v8    # "totalDelta":I
    .end local v9    # "nextPage":I
    :cond_1
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->endDrag()V

    .line 2567
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    .line 2568
    return-void
.end method

.method public executeKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 4
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 2748
    const/4 v0, 0x0

    .line 2749
    .local v0, "handled":Z
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result v1

    if-nez v1, :cond_4

    .line 2750
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v1

    const/16 v2, 0x3d

    const/4 v3, 0x2

    if-eq v1, v2, :cond_2

    packed-switch v1, :pswitch_data_0

    goto :goto_0

    .line 2759
    :pswitch_0
    invoke-virtual {p1, v3}, Landroid/view/KeyEvent;->hasModifiers(I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2760
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageRight()Z

    move-result v0

    goto :goto_0

    .line 2762
    :cond_0
    const/16 v1, 0x42

    invoke-virtual {p0, v1}, Landroid/support/v4/view/ViewPager;->arrowScroll(I)Z

    move-result v0

    .line 2764
    goto :goto_0

    .line 2752
    :pswitch_1
    invoke-virtual {p1, v3}, Landroid/view/KeyEvent;->hasModifiers(I)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 2753
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->pageLeft()Z

    move-result v0

    goto :goto_0

    .line 2755
    :cond_1
    const/16 v1, 0x11

    invoke-virtual {p0, v1}, Landroid/support/v4/view/ViewPager;->arrowScroll(I)Z

    move-result v0

    .line 2757
    goto :goto_0

    .line 2766
    :cond_2
    invoke-virtual {p1}, Landroid/view/KeyEvent;->hasNoModifiers()Z

    move-result v1

    if-eqz v1, :cond_3

    .line 2767
    invoke-virtual {p0, v3}, Landroid/support/v4/view/ViewPager;->arrowScroll(I)Z

    move-result v0

    goto :goto_0

    .line 2768
    :cond_3
    const/4 v1, 0x1

    invoke-virtual {p1, v1}, Landroid/view/KeyEvent;->hasModifiers(I)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 2769
    invoke-virtual {p0, v1}, Landroid/support/v4/view/ViewPager;->arrowScroll(I)Z

    move-result v0

    .line 2774
    :cond_4
    :goto_0
    return v0

    nop

    :pswitch_data_0
    .packed-switch 0x15
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public fakeDragBy(F)V
    .locals 19
    .param p1, "xOffset"    # F

    move-object/from16 v0, p0

    .line 2578
    iget-boolean v1, v0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    if-nez v1, :cond_0

    .line 2579
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "No fake drag in progress. Call beginFakeDrag first."

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 2582
    :cond_0
    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-nez v1, :cond_1

    .line 2583
    return-void

    .line 2586
    :cond_1
    iget v1, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    add-float v1, v1, p1

    iput v1, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2588
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v1

    int-to-float v1, v1

    .line 2589
    .local v1, "oldScrollX":F
    sub-float v2, v1, p1

    .line 2590
    .local v2, "scrollX":F
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v3

    .line 2592
    .local v3, "width":I
    int-to-float v4, v3

    iget v5, v0, Landroid/support/v4/view/ViewPager;->mFirstOffset:F

    mul-float/2addr v4, v5

    .line 2593
    .local v4, "leftBound":F
    int-to-float v5, v3

    iget v6, v0, Landroid/support/v4/view/ViewPager;->mLastOffset:F

    mul-float/2addr v5, v6

    .line 2595
    .local v5, "rightBound":F
    iget-object v6, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    const/4 v7, 0x0

    invoke-virtual {v6, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2596
    .local v6, "firstItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v7, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    iget-object v8, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v8

    add-int/lit8 v8, v8, -0x1

    invoke-virtual {v7, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2597
    .local v7, "lastItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v8, v6, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-eqz v8, :cond_2

    .line 2598
    iget v8, v6, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    int-to-float v9, v3

    mul-float v4, v8, v9

    .line 2600
    :cond_2
    iget v8, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget-object v9, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v9}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v9

    add-int/lit8 v9, v9, -0x1

    if-eq v8, v9, :cond_3

    .line 2601
    iget v8, v7, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    int-to-float v9, v3

    mul-float v5, v8, v9

    .line 2604
    :cond_3
    cmpg-float v8, v2, v4

    if-gez v8, :cond_4

    .line 2605
    move v2, v4

    goto :goto_0

    .line 2606
    :cond_4
    cmpl-float v8, v2, v5

    if-lez v8, :cond_5

    .line 2607
    move v2, v5

    .line 2610
    :cond_5
    :goto_0
    iget v8, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    float-to-int v9, v2

    int-to-float v9, v9

    sub-float v9, v2, v9

    add-float/2addr v8, v9

    iput v8, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2611
    float-to-int v8, v2

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v9

    invoke-virtual {v0, v8, v9}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 2612
    float-to-int v8, v2

    invoke-direct {v0, v8}, Landroid/support/v4/view/ViewPager;->pageScrolled(I)Z

    .line 2615
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v17

    .line 2616
    .local v17, "time":J
    iget-wide v9, v0, Landroid/support/v4/view/ViewPager;->mFakeDragBeginTime:J

    const/4 v13, 0x2

    iget v14, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    const/4 v15, 0x0

    const/16 v16, 0x0

    move-wide/from16 v11, v17

    invoke-static/range {v9 .. v16}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v8

    .line 2618
    .local v8, "ev":Landroid/view/MotionEvent;
    iget-object v9, v0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v9, v8}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 2619
    invoke-virtual {v8}, Landroid/view/MotionEvent;->recycle()V

    .line 2620
    return-void
.end method

.method protected generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    .locals 1

    .line 3011
    new-instance v0, Landroid/support/v4/view/ViewPager$LayoutParams;

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager$LayoutParams;-><init>()V

    return-object v0
.end method

.method public generateLayoutParams(Landroid/util/AttributeSet;)Landroid/view/ViewGroup$LayoutParams;
    .locals 2
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 3026
    new-instance v0, Landroid/support/v4/view/ViewPager$LayoutParams;

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/support/v4/view/ViewPager$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method protected generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 3016
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method public getAdapter()Landroid/support/v4/view/PagerAdapter;
    .locals 1

    .line 565
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    return-object v0
.end method

.method protected getChildDrawingOrder(II)I
    .locals 2
    .param p1, "childCount"    # I
    .param p2, "i"    # I

    .line 794
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrder:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    add-int/lit8 v0, p1, -0x1

    sub-int/2addr v0, p2

    goto :goto_0

    :cond_0
    move v0, p2

    .line 795
    .local v0, "index":I
    :goto_0
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrderedChildren:Ljava/util/ArrayList;

    .line 796
    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/v4/view/ViewPager$LayoutParams;

    iget v1, v1, Landroid/support/v4/view/ViewPager$LayoutParams;->childIndex:I

    .line 797
    .local v1, "result":I
    return v1
.end method

.method public getCurrentItem()I
    .locals 1

    .line 620
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    return v0
.end method

.method public getOffscreenPageLimit()I
    .locals 1

    .line 820
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    return v0
.end method

.method public getPageMargin()I
    .locals 1

    .line 876
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    return v0
.end method

.method infoForAnyChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;
    .locals 2
    .param p1, "child"    # Landroid/view/View;

    .line 1515
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    move-object v1, v0

    .line 1515
    .local v1, "parent":Landroid/view/ViewParent;
    if-eq v0, p0, :cond_2

    .line 1516
    if-eqz v1, :cond_1

    instance-of v0, v1, Landroid/view/View;

    if-nez v0, :cond_0

    goto :goto_1

    .line 1519
    :cond_0
    move-object p1, v1

    check-cast p1, Landroid/view/View;

    goto :goto_0

    .line 1517
    :cond_1
    :goto_1
    const/4 v0, 0x0

    return-object v0

    .line 1521
    :cond_2
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v0

    return-object v0
.end method

.method infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;
    .locals 4
    .param p1, "child"    # Landroid/view/View;

    .line 1504
    const/4 v0, 0x0

    .line 1504
    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 1505
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1506
    .local v1, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget-object v3, v1, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    invoke-virtual {v2, p1, v3}, Landroid/support/v4/view/PagerAdapter;->isViewFromObject(Landroid/view/View;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1507
    return-object v1

    .line 1504
    .end local v1    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1510
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method infoForPosition(I)Landroid/support/v4/view/ViewPager$ItemInfo;
    .locals 3
    .param p1, "position"    # I

    .line 1525
    const/4 v0, 0x0

    .line 1525
    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 1526
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1527
    .local v1, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v2, v1, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v2, p1, :cond_0

    .line 1528
    return-object v1

    .line 1525
    .end local v1    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1531
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method initViewPager()V
    .locals 5

    .line 395
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setWillNotDraw(Z)V

    .line 396
    const/high16 v0, 0x40000

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setDescendantFocusability(I)V

    .line 397
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setFocusable(Z)V

    .line 398
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getContext()Landroid/content/Context;

    move-result-object v1

    .line 399
    .local v1, "context":Landroid/content/Context;
    new-instance v2, Landroid/widget/Scroller;

    sget-object v3, Landroid/support/v4/view/ViewPager;->sInterpolator:Landroid/view/animation/Interpolator;

    invoke-direct {v2, v1, v3}, Landroid/widget/Scroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;)V

    iput-object v2, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    .line 400
    invoke-static {v1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v2

    .line 401
    .local v2, "configuration":Landroid/view/ViewConfiguration;
    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v3, v3, Landroid/util/DisplayMetrics;->density:F

    .line 403
    .local v3, "density":F
    invoke-virtual {v2}, Landroid/view/ViewConfiguration;->getScaledPagingTouchSlop()I

    move-result v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    .line 404
    const/high16 v4, 0x43c80000    # 400.0f

    mul-float/2addr v4, v3

    float-to-int v4, v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mMinimumVelocity:I

    .line 405
    invoke-virtual {v2}, Landroid/view/ViewConfiguration;->getScaledMaximumFlingVelocity()I

    move-result v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mMaximumVelocity:I

    .line 406
    new-instance v4, Landroid/widget/EdgeEffect;

    invoke-direct {v4, v1}, Landroid/widget/EdgeEffect;-><init>(Landroid/content/Context;)V

    iput-object v4, p0, Landroid/support/v4/view/ViewPager;->mLeftEdge:Landroid/widget/EdgeEffect;

    .line 407
    new-instance v4, Landroid/widget/EdgeEffect;

    invoke-direct {v4, v1}, Landroid/widget/EdgeEffect;-><init>(Landroid/content/Context;)V

    iput-object v4, p0, Landroid/support/v4/view/ViewPager;->mRightEdge:Landroid/widget/EdgeEffect;

    .line 409
    const/high16 v4, 0x41c80000    # 25.0f

    mul-float/2addr v4, v3

    float-to-int v4, v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mFlingDistance:I

    .line 410
    const/high16 v4, 0x40000000    # 2.0f

    mul-float/2addr v4, v3

    float-to-int v4, v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mCloseEnough:I

    .line 411
    const/high16 v4, 0x41800000    # 16.0f

    mul-float/2addr v4, v3

    float-to-int v4, v4

    iput v4, p0, Landroid/support/v4/view/ViewPager;->mDefaultGutterSize:I

    .line 413
    new-instance v4, Landroid/support/v4/view/ViewPager$MyAccessibilityDelegate;

    invoke-direct {v4, p0}, Landroid/support/v4/view/ViewPager$MyAccessibilityDelegate;-><init>(Landroid/support/v4/view/ViewPager;)V

    invoke-static {p0, v4}, Landroid/support/v4/view/ViewCompat;->setAccessibilityDelegate(Landroid/view/View;Landroid/support/v4/view/AccessibilityDelegateCompat;)V

    .line 415
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getImportantForAccessibility(Landroid/view/View;)I

    move-result v4

    if-nez v4, :cond_0

    .line 417
    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->setImportantForAccessibility(Landroid/view/View;I)V

    .line 421
    :cond_0
    new-instance v0, Landroid/support/v4/view/ViewPager$4;

    invoke-direct {v0, p0}, Landroid/support/v4/view/ViewPager$4;-><init>(Landroid/support/v4/view/ViewPager;)V

    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->setOnApplyWindowInsetsListener(Landroid/view/View;Landroid/support/v4/view/OnApplyWindowInsetsListener;)V

    .line 469
    return-void
.end method

.method public isFakeDragging()Z
    .locals 1

    .line 2632
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    return v0
.end method

.method protected onAttachedToWindow()V
    .locals 1

    .line 1536
    invoke-super {p0}, Landroid/view/ViewGroup;->onAttachedToWindow()V

    .line 1537
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 1538
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 1

    .line 473
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mEndScrollRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 475
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v0}, Landroid/widget/Scroller;->isFinished()Z

    move-result v0

    if-nez v0, :cond_0

    .line 476
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v0}, Landroid/widget/Scroller;->abortAnimation()V

    .line 478
    :cond_0
    invoke-super {p0}, Landroid/view/ViewGroup;->onDetachedFromWindow()V

    .line 479
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 17
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    .line 2460
    invoke-super/range {p0 .. p1}, Landroid/view/ViewGroup;->onDraw(Landroid/graphics/Canvas;)V

    .line 2463
    iget v1, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    if-lez v1, :cond_4

    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v1, :cond_4

    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_4

    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v1, :cond_4

    .line 2464
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v1

    .line 2465
    .local v1, "scrollX":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v2

    .line 2467
    .local v2, "width":I
    iget v3, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v3, v3

    int-to-float v4, v2

    div-float/2addr v3, v4

    .line 2468
    .local v3, "marginOffset":F
    const/4 v4, 0x0

    .line 2469
    .local v4, "itemIndex":I
    iget-object v5, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    const/4 v6, 0x0

    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 2470
    .local v5, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v6, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 2471
    .local v6, "offset":F
    iget-object v7, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    .line 2472
    .local v7, "itemCount":I
    iget v8, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2473
    .local v8, "firstPos":I
    iget-object v9, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    add-int/lit8 v10, v7, -0x1

    invoke-virtual {v9, v10}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/support/v4/view/ViewPager$ItemInfo;

    iget v9, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2474
    .local v9, "lastPos":I
    move v10, v6

    move v6, v4

    move v4, v8

    .line 2474
    .local v4, "pos":I
    .local v6, "itemIndex":I
    .local v10, "offset":F
    :goto_0
    if-ge v4, v9, :cond_4

    .line 2475
    :goto_1
    iget v11, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-le v4, v11, :cond_0

    if-ge v6, v7, :cond_0

    .line 2476
    iget-object v11, v0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    add-int/lit8 v6, v6, 0x1

    invoke-virtual {v11, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    move-object v5, v11

    check-cast v5, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_1

    .line 2480
    :cond_0
    iget v11, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v4, v11, :cond_1

    .line 2481
    iget v11, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v12, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v11, v12

    int-to-float v12, v2

    mul-float/2addr v11, v12

    .line 2482
    .local v11, "drawAt":F
    iget v12, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    iget v13, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v12, v13

    add-float/2addr v12, v3

    .line 2489
    .end local v10    # "offset":F
    .local v12, "offset":F
    move v10, v12

    move v12, v11

    goto :goto_2

    .line 2484
    .end local v11    # "drawAt":F
    .end local v12    # "offset":F
    .restart local v10    # "offset":F
    :cond_1
    iget-object v11, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v11, v4}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v11

    .line 2485
    .local v11, "widthFactor":F
    add-float v12, v10, v11

    int-to-float v13, v2

    mul-float/2addr v12, v13

    .line 2486
    .local v12, "drawAt":F
    add-float v13, v11, v3

    add-float/2addr v10, v13

    .line 2489
    .end local v11    # "widthFactor":F
    :goto_2
    iget v11, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v11, v11

    add-float/2addr v11, v12

    int-to-float v13, v1

    cmpl-float v11, v11, v13

    if-lez v11, :cond_2

    .line 2490
    iget-object v11, v0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v12}, Ljava/lang/Math;->round(F)I

    move-result v13

    iget v14, v0, Landroid/support/v4/view/ViewPager;->mTopPageBounds:I

    iget v15, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v15, v15

    add-float/2addr v15, v12

    .line 2491
    invoke-static {v15}, Ljava/lang/Math;->round(F)I

    move-result v15

    move/from16 v16, v3

    iget v3, v0, Landroid/support/v4/view/ViewPager;->mBottomPageBounds:I

    .line 2490
    .end local v3    # "marginOffset":F
    .local v16, "marginOffset":F
    invoke-virtual {v11, v13, v14, v15, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 2492
    iget-object v3, v0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    move-object/from16 v11, p1

    invoke-virtual {v3, v11}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    goto :goto_3

    .line 2495
    .end local v16    # "marginOffset":F
    .restart local v3    # "marginOffset":F
    :cond_2
    move-object/from16 v11, p1

    move/from16 v16, v3

    .line 2495
    .end local v3    # "marginOffset":F
    .restart local v16    # "marginOffset":F
    :goto_3
    add-int v3, v1, v2

    int-to-float v3, v3

    cmpl-float v3, v12, v3

    if-lez v3, :cond_3

    .line 2496
    goto :goto_4

    .line 2474
    .end local v12    # "drawAt":F
    :cond_3
    add-int/lit8 v4, v4, 0x1

    move/from16 v3, v16

    goto :goto_0

    .line 2500
    .end local v1    # "scrollX":I
    .end local v2    # "width":I
    .end local v4    # "pos":I
    .end local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v6    # "itemIndex":I
    .end local v7    # "itemCount":I
    .end local v8    # "firstPos":I
    .end local v9    # "lastPos":I
    .end local v10    # "offset":F
    .end local v16    # "marginOffset":F
    :cond_4
    move-object/from16 v11, p1

    :goto_4
    return-void
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 20
    .param p1, "ev"    # Landroid/view/MotionEvent;

    move-object/from16 v6, p0

    .line 2023
    move-object/from16 v7, p1

    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    and-int/lit16 v8, v0, 0xff

    .line 2026
    .local v8, "action":I
    const/4 v9, 0x0

    const/4 v0, 0x3

    if-eq v8, v0, :cond_f

    const/4 v10, 0x1

    if-ne v8, v10, :cond_0

    goto/16 :goto_3

    .line 2035
    :cond_0
    if-eqz v8, :cond_2

    .line 2036
    iget-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v0, :cond_1

    .line 2038
    return v10

    .line 2040
    :cond_1
    iget-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mIsUnableToDrag:Z

    if-eqz v0, :cond_2

    .line 2042
    return v9

    .line 2046
    :cond_2
    const/4 v0, 0x2

    if-eqz v8, :cond_b

    if-eq v8, v0, :cond_4

    const/4 v0, 0x6

    if-eq v8, v0, :cond_3

    goto/16 :goto_2

    .line 2140
    :cond_3
    invoke-direct/range {p0 .. p1}, Landroid/support/v4/view/ViewPager;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    goto/16 :goto_2

    .line 2057
    :cond_4
    iget v11, v6, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2058
    .local v11, "activePointerId":I
    const/4 v0, -0x1

    if-ne v11, v0, :cond_5

    .line 2060
    goto/16 :goto_2

    .line 2063
    :cond_5
    invoke-virtual {v7, v11}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v12

    .line 2064
    .local v12, "pointerIndex":I
    invoke-virtual {v7, v12}, Landroid/view/MotionEvent;->getX(I)F

    move-result v13

    .line 2065
    .local v13, "x":F
    iget v0, v6, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    sub-float v14, v13, v0

    .line 2066
    .local v14, "dx":F
    invoke-static {v14}, Ljava/lang/Math;->abs(F)F

    move-result v15

    .line 2067
    .local v15, "xDiff":F
    invoke-virtual {v7, v12}, Landroid/view/MotionEvent;->getY(I)F

    move-result v5

    .line 2068
    .local v5, "y":F
    iget v0, v6, Landroid/support/v4/view/ViewPager;->mInitialMotionY:F

    sub-float v0, v5, v0

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v16

    .line 2071
    .local v16, "yDiff":F
    const/16 v17, 0x0

    cmpl-float v0, v14, v17

    if-eqz v0, :cond_6

    iget v0, v6, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    invoke-direct {v6, v0, v14}, Landroid/support/v4/view/ViewPager;->isGutterDrag(FF)Z

    move-result v0

    if-nez v0, :cond_6

    const/4 v2, 0x0

    float-to-int v3, v14

    float-to-int v4, v13

    float-to-int v1, v5

    .line 2072
    move-object v0, v6

    move/from16 v18, v1

    move-object v1, v6

    move v9, v5

    move/from16 v5, v18

    .line 2072
    .end local v5    # "y":F
    .local v9, "y":F
    invoke-virtual/range {v0 .. v5}, Landroid/support/v4/view/ViewPager;->canScroll(Landroid/view/View;ZIII)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 2074
    iput v13, v6, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2075
    iput v9, v6, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    .line 2076
    iput-boolean v10, v6, Landroid/support/v4/view/ViewPager;->mIsUnableToDrag:Z

    .line 2077
    const/4 v0, 0x0

    return v0

    .line 2079
    .end local v9    # "y":F
    .restart local v5    # "y":F
    :cond_6
    move v9, v5

    .line 2079
    .end local v5    # "y":F
    .restart local v9    # "y":F
    :cond_7
    iget v0, v6, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v0, v0

    cmpl-float v0, v15, v0

    if-lez v0, :cond_9

    const/high16 v0, 0x3f000000    # 0.5f

    mul-float/2addr v0, v15

    cmpl-float v0, v0, v16

    if-lez v0, :cond_9

    .line 2081
    iput-boolean v10, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    .line 2082
    invoke-direct {v6, v10}, Landroid/support/v4/view/ViewPager;->requestParentDisallowInterceptTouchEvent(Z)V

    .line 2083
    invoke-virtual {v6, v10}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    .line 2084
    cmpl-float v0, v14, v17

    if-lez v0, :cond_8

    iget v0, v6, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iget v1, v6, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v1, v1

    add-float/2addr v0, v1

    goto :goto_0

    :cond_8
    iget v0, v6, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iget v1, v6, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v1, v1

    sub-float/2addr v0, v1

    :goto_0
    iput v0, v6, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2086
    iput v9, v6, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    .line 2087
    invoke-direct {v6, v10}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    goto :goto_1

    .line 2088
    :cond_9
    iget v0, v6, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v0, v0

    cmpl-float v0, v16, v0

    if-lez v0, :cond_a

    .line 2094
    iput-boolean v10, v6, Landroid/support/v4/view/ViewPager;->mIsUnableToDrag:Z

    .line 2096
    :cond_a
    :goto_1
    iget-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v0, :cond_d

    .line 2098
    invoke-direct {v6, v13}, Landroid/support/v4/view/ViewPager;->performDrag(F)Z

    move-result v0

    if-eqz v0, :cond_d

    .line 2099
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    goto :goto_2

    .line 2110
    .end local v9    # "y":F
    .end local v11    # "activePointerId":I
    .end local v12    # "pointerIndex":I
    .end local v13    # "x":F
    .end local v14    # "dx":F
    .end local v15    # "xDiff":F
    .end local v16    # "yDiff":F
    :cond_b
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    iput v1, v6, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iput v1, v6, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2111
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getY()F

    move-result v1

    iput v1, v6, Landroid/support/v4/view/ViewPager;->mInitialMotionY:F

    iput v1, v6, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    .line 2112
    const/4 v1, 0x0

    invoke-virtual {v7, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v2

    iput v2, v6, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2113
    iput-boolean v1, v6, Landroid/support/v4/view/ViewPager;->mIsUnableToDrag:Z

    .line 2115
    iput-boolean v10, v6, Landroid/support/v4/view/ViewPager;->mIsScrollStarted:Z

    .line 2116
    iget-object v1, v6, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v1}, Landroid/widget/Scroller;->computeScrollOffset()Z

    .line 2117
    iget v1, v6, Landroid/support/v4/view/ViewPager;->mScrollState:I

    if-ne v1, v0, :cond_c

    iget-object v0, v6, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    .line 2118
    invoke-virtual {v0}, Landroid/widget/Scroller;->getFinalX()I

    move-result v0

    iget-object v1, v6, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v1}, Landroid/widget/Scroller;->getCurrX()I

    move-result v1

    sub-int/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    iget v1, v6, Landroid/support/v4/view/ViewPager;->mCloseEnough:I

    if-le v0, v1, :cond_c

    .line 2120
    iget-object v0, v6, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v0}, Landroid/widget/Scroller;->abortAnimation()V

    .line 2121
    const/4 v0, 0x0

    iput-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 2122
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 2123
    iput-boolean v10, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    .line 2124
    invoke-direct {v6, v10}, Landroid/support/v4/view/ViewPager;->requestParentDisallowInterceptTouchEvent(Z)V

    .line 2125
    invoke-virtual {v6, v10}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    goto :goto_2

    .line 2127
    :cond_c
    const/4 v0, 0x0

    invoke-direct {v6, v0}, Landroid/support/v4/view/ViewPager;->completeScroll(Z)V

    .line 2128
    iput-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    .line 2136
    nop

    .line 2144
    :cond_d
    :goto_2
    iget-object v0, v6, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v0, :cond_e

    .line 2145
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v0

    iput-object v0, v6, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 2147
    :cond_e
    iget-object v0, v6, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, v7}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 2153
    iget-boolean v0, v6, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    return v0

    .line 2029
    :cond_f
    :goto_3
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->resetTouch()Z

    .line 2030
    const/4 v0, 0x0

    return v0
.end method

.method protected onLayout(ZIIII)V
    .locals 28
    .param p1, "changed"    # Z
    .param p2, "l"    # I
    .param p3, "t"    # I
    .param p4, "r"    # I
    .param p5, "b"    # I

    move-object/from16 v0, p0

    .line 1674
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v1

    .line 1675
    .local v1, "count":I
    sub-int v4, p4, p2

    .line 1676
    .local v4, "width":I
    sub-int v7, p5, p3

    .line 1677
    .local v7, "height":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v8

    .line 1678
    .local v8, "paddingLeft":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v9

    .line 1679
    .local v9, "paddingTop":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v10

    .line 1680
    .local v10, "paddingRight":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingBottom()I

    move-result v11

    .line 1681
    .local v11, "paddingBottom":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v12

    .line 1683
    .local v12, "scrollX":I
    const/4 v13, 0x0

    .line 1687
    .local v13, "decorCount":I
    move v15, v13

    move v13, v11

    move v11, v9

    move v9, v8

    const/4 v8, 0x0

    .line 1687
    .local v8, "i":I
    .local v9, "paddingLeft":I
    .local v11, "paddingTop":I
    .local v13, "paddingBottom":I
    .local v15, "decorCount":I
    :goto_0
    if-ge v8, v1, :cond_7

    .line 1688
    invoke-virtual {v0, v8}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v14

    .line 1689
    .local v14, "child":Landroid/view/View;
    invoke-virtual {v14}, Landroid/view/View;->getVisibility()I

    move-result v2

    const/16 v3, 0x8

    if-eq v2, v3, :cond_6

    .line 1690
    invoke-virtual {v14}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    check-cast v2, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1691
    .local v2, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    const/4 v3, 0x0

    .line 1692
    .local v3, "childLeft":I
    const/16 v16, 0x0

    .line 1693
    .local v16, "childTop":I
    move/from16 v17, v3

    iget-boolean v3, v2, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    .line 1693
    .end local v3    # "childLeft":I
    .local v17, "childLeft":I
    if-eqz v3, :cond_6

    .line 1694
    iget v3, v2, Landroid/support/v4/view/ViewPager$LayoutParams;->gravity:I

    and-int/lit8 v3, v3, 0x7

    .line 1695
    .local v3, "hgrav":I
    iget v5, v2, Landroid/support/v4/view/ViewPager$LayoutParams;->gravity:I

    and-int/lit8 v5, v5, 0x70

    .line 1696
    .local v5, "vgrav":I
    move-object/from16 v18, v2

    const/4 v2, 0x1

    .line 1696
    .end local v2    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .local v18, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    if-eq v3, v2, :cond_2

    const/4 v2, 0x3

    if-eq v3, v2, :cond_1

    const/4 v2, 0x5

    if-eq v3, v2, :cond_0

    .line 1698
    move v2, v9

    .line 1699
    .end local v17    # "childLeft":I
    .local v2, "childLeft":I
    goto :goto_1

    .line 1709
    .end local v2    # "childLeft":I
    .restart local v17    # "childLeft":I
    :cond_0
    sub-int v2, v4, v10

    invoke-virtual {v14}, Landroid/view/View;->getMeasuredWidth()I

    move-result v19

    sub-int v2, v2, v19

    .line 1710
    .end local v17    # "childLeft":I
    .restart local v2    # "childLeft":I
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredWidth()I

    move-result v17

    add-int v10, v10, v17

    goto :goto_1

    .line 1701
    .end local v2    # "childLeft":I
    .restart local v17    # "childLeft":I
    :cond_1
    move v2, v9

    .line 1702
    .end local v17    # "childLeft":I
    .restart local v2    # "childLeft":I
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredWidth()I

    move-result v17

    add-int v9, v9, v17

    .line 1703
    goto :goto_1

    .line 1705
    .end local v2    # "childLeft":I
    .restart local v17    # "childLeft":I
    :cond_2
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    sub-int v2, v4, v2

    div-int/lit8 v2, v2, 0x2

    invoke-static {v2, v9}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 1707
    .end local v17    # "childLeft":I
    .restart local v2    # "childLeft":I
    nop

    .line 1713
    :goto_1
    move/from16 v20, v3

    .line 1713
    .end local v3    # "hgrav":I
    .local v20, "hgrav":I
    const/16 v3, 0x10

    if-eq v5, v3, :cond_5

    const/16 v3, 0x30

    if-eq v5, v3, :cond_4

    const/16 v3, 0x50

    if-eq v5, v3, :cond_3

    .line 1715
    move v3, v11

    .line 1716
    .end local v16    # "childTop":I
    .local v3, "childTop":I
    goto :goto_2

    .line 1726
    .end local v3    # "childTop":I
    .restart local v16    # "childTop":I
    :cond_3
    sub-int v3, v7, v13

    invoke-virtual {v14}, Landroid/view/View;->getMeasuredHeight()I

    move-result v17

    sub-int v3, v3, v17

    .line 1727
    .end local v16    # "childTop":I
    .restart local v3    # "childTop":I
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredHeight()I

    move-result v16

    add-int v13, v13, v16

    goto :goto_2

    .line 1718
    .end local v3    # "childTop":I
    .restart local v16    # "childTop":I
    :cond_4
    move v3, v11

    .line 1719
    .end local v16    # "childTop":I
    .restart local v3    # "childTop":I
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredHeight()I

    move-result v16

    add-int v11, v11, v16

    .line 1720
    goto :goto_2

    .line 1722
    .end local v3    # "childTop":I
    .restart local v16    # "childTop":I
    :cond_5
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredHeight()I

    move-result v3

    sub-int v3, v7, v3

    div-int/lit8 v3, v3, 0x2

    invoke-static {v3, v11}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1724
    .end local v16    # "childTop":I
    .restart local v3    # "childTop":I
    nop

    .line 1730
    :goto_2
    add-int/2addr v2, v12

    .line 1731
    nop

    .line 1732
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredWidth()I

    move-result v16

    move/from16 v21, v5

    add-int v5, v2, v16

    .line 1733
    .end local v5    # "vgrav":I
    .local v21, "vgrav":I
    invoke-virtual {v14}, Landroid/view/View;->getMeasuredHeight()I

    move-result v16

    add-int v6, v3, v16

    .line 1731
    invoke-virtual {v14, v2, v3, v5, v6}, Landroid/view/View;->layout(IIII)V

    .line 1734
    add-int/lit8 v15, v15, 0x1

    .line 1687
    .end local v2    # "childLeft":I
    .end local v3    # "childTop":I
    .end local v14    # "child":Landroid/view/View;
    .end local v18    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v20    # "hgrav":I
    .end local v21    # "vgrav":I
    :cond_6
    add-int/lit8 v8, v8, 0x1

    goto/16 :goto_0

    .line 1739
    .end local v8    # "i":I
    :cond_7
    sub-int v2, v4, v9

    sub-int/2addr v2, v10

    .line 1741
    .local v2, "childWidth":I
    const/4 v3, 0x0

    .line 1741
    .local v3, "i":I
    :goto_3
    if-ge v3, v1, :cond_a

    .line 1742
    invoke-virtual {v0, v3}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 1743
    .local v5, "child":Landroid/view/View;
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v6

    const/16 v8, 0x8

    if-eq v6, v8, :cond_9

    .line 1744
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1746
    .local v6, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v14, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v14, :cond_9

    invoke-virtual {v0, v5}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v14

    move-object/from16 v22, v14

    .line 1746
    .local v22, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v14, :cond_9

    .line 1747
    int-to-float v14, v2

    move/from16 v23, v1

    move-object/from16 v8, v22

    iget v1, v8, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    .line 1747
    .end local v1    # "count":I
    .end local v22    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v8, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v23, "count":I
    mul-float/2addr v14, v1

    float-to-int v1, v14

    .line 1748
    .local v1, "loff":I
    add-int v14, v9, v1

    .line 1749
    .local v14, "childLeft":I
    move/from16 v24, v11

    .line 1750
    .local v24, "childTop":I
    move/from16 v25, v1

    iget-boolean v1, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->needsMeasure:Z

    .line 1750
    .end local v1    # "loff":I
    .local v25, "loff":I
    if-eqz v1, :cond_8

    .line 1753
    const/4 v1, 0x0

    iput-boolean v1, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->needsMeasure:Z

    .line 1754
    int-to-float v1, v2

    move/from16 v26, v2

    iget v2, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->widthFactor:F

    .line 1754
    .end local v2    # "childWidth":I
    .local v26, "childWidth":I
    mul-float/2addr v1, v2

    float-to-int v1, v1

    const/high16 v2, 0x40000000    # 2.0f

    invoke-static {v1, v2}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v1

    .line 1757
    .local v1, "widthSpec":I
    sub-int v16, v7, v11

    move/from16 v27, v4

    sub-int v4, v16, v13

    .line 1757
    .end local v4    # "width":I
    .local v27, "width":I
    invoke-static {v4, v2}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v2

    .line 1760
    .local v2, "heightSpec":I
    invoke-virtual {v5, v1, v2}, Landroid/view/View;->measure(II)V

    .line 1760
    .end local v1    # "widthSpec":I
    .end local v2    # "heightSpec":I
    goto :goto_4

    .line 1767
    .end local v26    # "childWidth":I
    .end local v27    # "width":I
    .local v2, "childWidth":I
    .restart local v4    # "width":I
    :cond_8
    move/from16 v26, v2

    move/from16 v27, v4

    .line 1768
    .end local v2    # "childWidth":I
    .end local v4    # "width":I
    .restart local v26    # "childWidth":I
    .restart local v27    # "width":I
    :goto_4
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredWidth()I

    move-result v1

    add-int/2addr v1, v14

    .line 1769
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    move/from16 v4, v24

    add-int/2addr v2, v4

    .line 1767
    .end local v24    # "childTop":I
    .local v4, "childTop":I
    invoke-virtual {v5, v14, v4, v1, v2}, Landroid/view/View;->layout(IIII)V

    .line 1767
    .end local v4    # "childTop":I
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v8    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v14    # "childLeft":I
    .end local v25    # "loff":I
    goto :goto_5

    .line 1741
    .end local v23    # "count":I
    .end local v26    # "childWidth":I
    .end local v27    # "width":I
    .local v1, "count":I
    .restart local v2    # "childWidth":I
    .local v4, "width":I
    :cond_9
    move/from16 v23, v1

    move/from16 v26, v2

    move/from16 v27, v4

    .line 1741
    .end local v1    # "count":I
    .end local v2    # "childWidth":I
    .end local v4    # "width":I
    .restart local v23    # "count":I
    .restart local v26    # "childWidth":I
    .restart local v27    # "width":I
    :goto_5
    add-int/lit8 v3, v3, 0x1

    move/from16 v1, v23

    move/from16 v2, v26

    move/from16 v4, v27

    goto :goto_3

    .line 1773
    .end local v3    # "i":I
    .end local v23    # "count":I
    .end local v26    # "childWidth":I
    .end local v27    # "width":I
    .restart local v1    # "count":I
    .restart local v2    # "childWidth":I
    .restart local v4    # "width":I
    :cond_a
    move/from16 v23, v1

    move/from16 v26, v2

    move/from16 v27, v4

    .line 1773
    .end local v1    # "count":I
    .end local v2    # "childWidth":I
    .end local v4    # "width":I
    .restart local v23    # "count":I
    .restart local v26    # "childWidth":I
    .restart local v27    # "width":I
    iput v11, v0, Landroid/support/v4/view/ViewPager;->mTopPageBounds:I

    .line 1774
    sub-int v1, v7, v13

    iput v1, v0, Landroid/support/v4/view/ViewPager;->mBottomPageBounds:I

    .line 1775
    iput v15, v0, Landroid/support/v4/view/ViewPager;->mDecorChildCount:I

    .line 1777
    iget-boolean v1, v0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    if-eqz v1, :cond_b

    .line 1778
    iget v1, v0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2, v2}, Landroid/support/v4/view/ViewPager;->scrollToItem(IZIZ)V

    goto :goto_6

    .line 1780
    :cond_b
    const/4 v2, 0x0

    :goto_6
    iput-boolean v2, v0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 1781
    return-void
.end method

.method protected onMeasure(II)V
    .locals 22
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v0, p0

    .line 1547
    const/4 v1, 0x0

    move/from16 v2, p1

    invoke-static {v1, v2}, Landroid/support/v4/view/ViewPager;->getDefaultSize(II)I

    move-result v3

    .line 1548
    move/from16 v4, p2

    invoke-static {v1, v4}, Landroid/support/v4/view/ViewPager;->getDefaultSize(II)I

    move-result v5

    .line 1547
    invoke-virtual {v0, v3, v5}, Landroid/support/v4/view/ViewPager;->setMeasuredDimension(II)V

    .line 1550
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getMeasuredWidth()I

    move-result v3

    .line 1551
    .local v3, "measuredWidth":I
    div-int/lit8 v5, v3, 0xa

    .line 1552
    .local v5, "maxGutterSize":I
    iget v6, v0, Landroid/support/v4/view/ViewPager;->mDefaultGutterSize:I

    invoke-static {v5, v6}, Ljava/lang/Math;->min(II)I

    move-result v6

    iput v6, v0, Landroid/support/v4/view/ViewPager;->mGutterSize:I

    .line 1555
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v6

    sub-int v6, v3, v6

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v7

    sub-int/2addr v6, v7

    .line 1556
    .local v6, "childWidthSize":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getMeasuredHeight()I

    move-result v7

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingTop()I

    move-result v8

    sub-int/2addr v7, v8

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingBottom()I

    move-result v8

    sub-int/2addr v7, v8

    .line 1563
    .local v7, "childHeightSize":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v8

    .line 1564
    .local v8, "size":I
    move v9, v7

    move v7, v6

    move v6, v1

    .line 1564
    .local v6, "i":I
    .local v7, "childWidthSize":I
    .local v9, "childHeightSize":I
    :goto_0
    const/16 v10, 0x8

    if-ge v6, v8, :cond_b

    .line 1565
    invoke-virtual {v0, v6}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v12

    .line 1566
    .local v12, "child":Landroid/view/View;
    invoke-virtual {v12}, Landroid/view/View;->getVisibility()I

    move-result v13

    if-eq v13, v10, :cond_9

    .line 1567
    invoke-virtual {v12}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v10

    check-cast v10, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1568
    .local v10, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    if-eqz v10, :cond_9

    iget-boolean v13, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-eqz v13, :cond_9

    .line 1569
    iget v13, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->gravity:I

    and-int/lit8 v13, v13, 0x7

    .line 1570
    .local v13, "hgrav":I
    iget v14, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->gravity:I

    and-int/lit8 v14, v14, 0x70

    .line 1571
    .local v14, "vgrav":I
    const/high16 v15, -0x80000000

    .line 1572
    .local v15, "widthMode":I
    const/high16 v16, -0x80000000

    .line 1573
    .local v16, "heightMode":I
    const/16 v1, 0x30

    if-eq v14, v1, :cond_1

    const/16 v1, 0x50

    if-ne v14, v1, :cond_0

    goto :goto_1

    :cond_0
    const/4 v1, 0x0

    goto :goto_2

    :cond_1
    :goto_1
    const/4 v1, 0x1

    .line 1574
    .local v1, "consumeVertical":Z
    :goto_2
    const/4 v11, 0x3

    if-eq v13, v11, :cond_3

    const/4 v11, 0x5

    if-ne v13, v11, :cond_2

    goto :goto_3

    :cond_2
    const/16 v17, 0x0

    goto :goto_4

    :cond_3
    :goto_3
    const/16 v17, 0x1

    :goto_4
    move/from16 v11, v17

    .line 1576
    .local v11, "consumeHorizontal":Z
    if-eqz v1, :cond_4

    .line 1577
    const/high16 v15, 0x40000000    # 2.0f

    goto :goto_5

    .line 1578
    :cond_4
    if-eqz v11, :cond_5

    .line 1579
    const/high16 v16, 0x40000000    # 2.0f

    .line 1582
    :cond_5
    :goto_5
    move/from16 v17, v7

    .line 1583
    .local v17, "widthSize":I
    move/from16 v18, v9

    .line 1584
    .local v18, "heightSize":I
    iget v2, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->width:I

    move/from16 v19, v3

    .line 1584
    .end local v3    # "measuredWidth":I
    .local v19, "measuredWidth":I
    const/4 v3, -0x2

    if-eq v2, v3, :cond_6

    .line 1585
    const/high16 v15, 0x40000000    # 2.0f

    .line 1586
    iget v2, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->width:I

    const/4 v3, -0x1

    if-eq v2, v3, :cond_6

    .line 1587
    iget v2, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->width:I

    .line 1587
    .end local v17    # "widthSize":I
    .local v2, "widthSize":I
    goto :goto_6

    .line 1590
    .end local v2    # "widthSize":I
    .restart local v17    # "widthSize":I
    :cond_6
    move/from16 v2, v17

    .line 1590
    .end local v17    # "widthSize":I
    .restart local v2    # "widthSize":I
    :goto_6
    iget v3, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->height:I

    const/4 v4, -0x2

    if-eq v3, v4, :cond_7

    .line 1591
    const/high16 v16, 0x40000000    # 2.0f

    .line 1592
    iget v3, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->height:I

    const/4 v4, -0x1

    if-eq v3, v4, :cond_7

    .line 1593
    iget v3, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->height:I

    .line 1596
    .end local v18    # "heightSize":I
    .local v3, "heightSize":I
    move/from16 v4, v16

    goto :goto_7

    .line 1596
    .end local v3    # "heightSize":I
    .restart local v18    # "heightSize":I
    :cond_7
    move/from16 v4, v16

    move/from16 v3, v18

    .line 1596
    .end local v16    # "heightMode":I
    .end local v18    # "heightSize":I
    .restart local v3    # "heightSize":I
    .local v4, "heightMode":I
    :goto_7
    move/from16 v20, v5

    invoke-static {v2, v15}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v5

    .line 1597
    .local v5, "widthSpec":I
    .local v20, "maxGutterSize":I
    move/from16 v21, v2

    invoke-static {v3, v4}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v2

    .line 1598
    .local v2, "heightSpec":I
    .local v21, "widthSize":I
    invoke-virtual {v12, v5, v2}, Landroid/view/View;->measure(II)V

    .line 1600
    if-eqz v1, :cond_8

    .line 1601
    invoke-virtual {v12}, Landroid/view/View;->getMeasuredHeight()I

    move-result v16

    sub-int v9, v9, v16

    goto :goto_8

    .line 1602
    :cond_8
    if-eqz v11, :cond_a

    .line 1603
    invoke-virtual {v12}, Landroid/view/View;->getMeasuredWidth()I

    move-result v16

    sub-int v7, v7, v16

    .line 1603
    .end local v1    # "consumeVertical":Z
    .end local v2    # "heightSpec":I
    .end local v3    # "heightSize":I
    .end local v4    # "heightMode":I
    .end local v5    # "widthSpec":I
    .end local v10    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v11    # "consumeHorizontal":Z
    .end local v12    # "child":Landroid/view/View;
    .end local v13    # "hgrav":I
    .end local v14    # "vgrav":I
    .end local v15    # "widthMode":I
    .end local v21    # "widthSize":I
    goto :goto_8

    .line 1564
    .end local v19    # "measuredWidth":I
    .end local v20    # "maxGutterSize":I
    .local v3, "measuredWidth":I
    .local v5, "maxGutterSize":I
    :cond_9
    move/from16 v19, v3

    move/from16 v20, v5

    .line 1564
    .end local v3    # "measuredWidth":I
    .end local v5    # "maxGutterSize":I
    .restart local v19    # "measuredWidth":I
    .restart local v20    # "maxGutterSize":I
    :cond_a
    :goto_8
    add-int/lit8 v6, v6, 0x1

    move/from16 v3, v19

    move/from16 v5, v20

    const/4 v1, 0x0

    move/from16 v2, p1

    move/from16 v4, p2

    goto/16 :goto_0

    .line 1609
    .end local v6    # "i":I
    .end local v19    # "measuredWidth":I
    .end local v20    # "maxGutterSize":I
    .restart local v3    # "measuredWidth":I
    .restart local v5    # "maxGutterSize":I
    :cond_b
    move/from16 v19, v3

    move/from16 v20, v5

    .line 1609
    .end local v3    # "measuredWidth":I
    .end local v5    # "maxGutterSize":I
    .restart local v19    # "measuredWidth":I
    .restart local v20    # "maxGutterSize":I
    const/high16 v1, 0x40000000    # 2.0f

    invoke-static {v7, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v2

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mChildWidthMeasureSpec:I

    .line 1610
    invoke-static {v9, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v2

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mChildHeightMeasureSpec:I

    .line 1613
    const/4 v2, 0x1

    iput-boolean v2, v0, Landroid/support/v4/view/ViewPager;->mInLayout:Z

    .line 1614
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 1615
    const/4 v2, 0x0

    iput-boolean v2, v0, Landroid/support/v4/view/ViewPager;->mInLayout:Z

    .line 1618
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v3

    .line 1619
    .end local v8    # "size":I
    .local v3, "size":I
    nop

    .line 1619
    .local v2, "i":I
    :goto_9
    if-ge v2, v3, :cond_e

    .line 1620
    invoke-virtual {v0, v2}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 1621
    .local v4, "child":Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-eq v5, v10, :cond_d

    .line 1626
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    check-cast v5, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1627
    .local v5, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    if-eqz v5, :cond_c

    iget-boolean v6, v5, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v6, :cond_d

    .line 1628
    :cond_c
    int-to-float v6, v7

    iget v8, v5, Landroid/support/v4/view/ViewPager$LayoutParams;->widthFactor:F

    mul-float/2addr v6, v8

    float-to-int v6, v6

    invoke-static {v6, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v6

    .line 1630
    .local v6, "widthSpec":I
    iget v8, v0, Landroid/support/v4/view/ViewPager;->mChildHeightMeasureSpec:I

    invoke-virtual {v4, v6, v8}, Landroid/view/View;->measure(II)V

    .line 1619
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v6    # "widthSpec":I
    :cond_d
    add-int/lit8 v2, v2, 0x1

    goto :goto_9

    .line 1634
    .end local v2    # "i":I
    :cond_e
    return-void
.end method

.method protected onPageScrolled(IFI)V
    .locals 15
    .param p1, "position"    # I
    .param p2, "offset"    # F
    .param p3, "offsetPixels"    # I
    .annotation build Landroid/support/annotation/CallSuper;
    .end annotation

    move-object v0, p0

    .line 1857
    iget v1, v0, Landroid/support/v4/view/ViewPager;->mDecorChildCount:I

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-lez v1, :cond_5

    .line 1858
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v1

    .line 1859
    .local v1, "scrollX":I
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v4

    .line 1860
    .local v4, "paddingLeft":I
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v5

    .line 1861
    .local v5, "paddingRight":I
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v6

    .line 1862
    .local v6, "width":I
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v7

    .line 1863
    .local v7, "childCount":I
    move v8, v5

    move v5, v4

    move v4, v2

    .line 1863
    .local v4, "i":I
    .local v5, "paddingLeft":I
    .local v8, "paddingRight":I
    :goto_0
    if-ge v4, v7, :cond_5

    .line 1864
    invoke-virtual {v0, v4}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v9

    .line 1865
    .local v9, "child":Landroid/view/View;
    invoke-virtual {v9}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v10

    check-cast v10, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1866
    .local v10, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v11, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v11, :cond_0

    .line 1866
    .end local v9    # "child":Landroid/view/View;
    .end local v10    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    goto :goto_2

    .line 1868
    .restart local v9    # "child":Landroid/view/View;
    .restart local v10    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    :cond_0
    iget v11, v10, Landroid/support/v4/view/ViewPager$LayoutParams;->gravity:I

    and-int/lit8 v11, v11, 0x7

    .line 1869
    .local v11, "hgrav":I
    const/4 v12, 0x0

    .line 1870
    .local v12, "childLeft":I
    if-eq v11, v3, :cond_3

    const/4 v13, 0x3

    if-eq v11, v13, :cond_2

    const/4 v13, 0x5

    if-eq v11, v13, :cond_1

    .line 1872
    move v12, v5

    .line 1873
    goto :goto_1

    .line 1883
    :cond_1
    sub-int v13, v6, v8

    invoke-virtual {v9}, Landroid/view/View;->getMeasuredWidth()I

    move-result v14

    sub-int v12, v13, v14

    .line 1884
    invoke-virtual {v9}, Landroid/view/View;->getMeasuredWidth()I

    move-result v13

    add-int/2addr v8, v13

    goto :goto_1

    .line 1875
    :cond_2
    move v12, v5

    .line 1876
    invoke-virtual {v9}, Landroid/view/View;->getWidth()I

    move-result v13

    add-int/2addr v5, v13

    .line 1877
    goto :goto_1

    .line 1879
    :cond_3
    invoke-virtual {v9}, Landroid/view/View;->getMeasuredWidth()I

    move-result v13

    sub-int v13, v6, v13

    div-int/lit8 v13, v13, 0x2

    invoke-static {v13, v5}, Ljava/lang/Math;->max(II)I

    move-result v12

    .line 1881
    nop

    .line 1887
    :goto_1
    add-int/2addr v12, v1

    .line 1889
    invoke-virtual {v9}, Landroid/view/View;->getLeft()I

    move-result v13

    sub-int v13, v12, v13

    .line 1890
    .local v13, "childOffset":I
    if-eqz v13, :cond_4

    .line 1891
    invoke-virtual {v9, v13}, Landroid/view/View;->offsetLeftAndRight(I)V

    .line 1863
    .end local v9    # "child":Landroid/view/View;
    .end local v10    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v11    # "hgrav":I
    .end local v12    # "childLeft":I
    .end local v13    # "childOffset":I
    :cond_4
    :goto_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 1896
    .end local v1    # "scrollX":I
    .end local v4    # "i":I
    .end local v5    # "paddingLeft":I
    .end local v6    # "width":I
    .end local v7    # "childCount":I
    .end local v8    # "paddingRight":I
    :cond_5
    invoke-direct/range {p0 .. p3}, Landroid/support/v4/view/ViewPager;->dispatchOnPageScrolled(IFI)V

    .line 1898
    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

    if-eqz v1, :cond_7

    .line 1899
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v1

    .line 1900
    .restart local v1    # "scrollX":I
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v4

    .line 1901
    .local v4, "childCount":I
    nop

    .line 1901
    .local v2, "i":I
    :goto_3
    if-ge v2, v4, :cond_7

    .line 1902
    invoke-virtual {v0, v2}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 1903
    .local v5, "child":Landroid/view/View;
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1905
    .local v6, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iget-boolean v7, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-eqz v7, :cond_6

    .line 1905
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    goto :goto_4

    .line 1906
    .restart local v5    # "child":Landroid/view/View;
    .restart local v6    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    :cond_6
    invoke-virtual {v5}, Landroid/view/View;->getLeft()I

    move-result v7

    sub-int/2addr v7, v1

    int-to-float v7, v7

    invoke-direct {v0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v8

    int-to-float v8, v8

    div-float/2addr v7, v8

    .line 1907
    .local v7, "transformPos":F
    iget-object v8, v0, Landroid/support/v4/view/ViewPager;->mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

    invoke-interface {v8, v5, v7}, Landroid/support/v4/view/ViewPager$PageTransformer;->transformPage(Landroid/view/View;F)V

    .line 1901
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v7    # "transformPos":F
    :goto_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 1911
    .end local v1    # "scrollX":I
    .end local v2    # "i":I
    .end local v4    # "childCount":I
    :cond_7
    iput-boolean v3, v0, Landroid/support/v4/view/ViewPager;->mCalledSuper:Z

    .line 1912
    return-void
.end method

.method protected onRequestFocusInDescendants(ILandroid/graphics/Rect;)Z
    .locals 9
    .param p1, "direction"    # I
    .param p2, "previouslyFocusedRect"    # Landroid/graphics/Rect;

    .line 2962
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v0

    .line 2963
    .local v0, "count":I
    and-int/lit8 v1, p1, 0x2

    if-eqz v1, :cond_0

    .line 2964
    const/4 v1, 0x0

    .line 2965
    .local v1, "index":I
    const/4 v2, 0x1

    .line 2966
    .local v2, "increment":I
    move v3, v0

    .line 2966
    .local v3, "end":I
    goto :goto_0

    .line 2968
    .end local v1    # "index":I
    .end local v2    # "increment":I
    .end local v3    # "end":I
    :cond_0
    add-int/lit8 v1, v0, -0x1

    .line 2969
    .restart local v1    # "index":I
    const/4 v2, -0x1

    .line 2970
    .restart local v2    # "increment":I
    const/4 v3, -0x1

    .line 2972
    .restart local v3    # "end":I
    :goto_0
    move v4, v1

    .line 2972
    .local v4, "i":I
    :goto_1
    if-eq v4, v3, :cond_2

    .line 2973
    invoke-virtual {p0, v4}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 2974
    .local v5, "child":Landroid/view/View;
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v6

    if-nez v6, :cond_1

    .line 2975
    invoke-virtual {p0, v5}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v6

    .line 2976
    .local v6, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v6, :cond_1

    iget v7, v6, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v8, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v7, v8, :cond_1

    .line 2977
    invoke-virtual {v5, p1, p2}, Landroid/view/View;->requestFocus(ILandroid/graphics/Rect;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 2978
    const/4 v7, 0x1

    return v7

    .line 2972
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_1
    add-int/2addr v4, v2

    goto :goto_1

    .line 2983
    .end local v4    # "i":I
    :cond_2
    const/4 v4, 0x0

    return v4
.end method

.method public onRestoreInstanceState(Landroid/os/Parcelable;)V
    .locals 4
    .param p1, "state"    # Landroid/os/Parcelable;

    .line 1444
    instance-of v0, p1, Landroid/support/v4/view/ViewPager$SavedState;

    if-nez v0, :cond_0

    .line 1445
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    .line 1446
    return-void

    .line 1449
    :cond_0
    move-object v0, p1

    check-cast v0, Landroid/support/v4/view/ViewPager$SavedState;

    .line 1450
    .local v0, "ss":Landroid/support/v4/view/ViewPager$SavedState;
    invoke-virtual {v0}, Landroid/support/v4/view/ViewPager$SavedState;->getSuperState()Landroid/os/Parcelable;

    move-result-object v1

    invoke-super {p0, v1}, Landroid/view/ViewGroup;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    .line 1452
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v1, :cond_1

    .line 1453
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget-object v2, v0, Landroid/support/v4/view/ViewPager$SavedState;->adapterState:Landroid/os/Parcelable;

    iget-object v3, v0, Landroid/support/v4/view/ViewPager$SavedState;->loader:Ljava/lang/ClassLoader;

    invoke-virtual {v1, v2, v3}, Landroid/support/v4/view/PagerAdapter;->restoreState(Landroid/os/Parcelable;Ljava/lang/ClassLoader;)V

    .line 1454
    iget v1, v0, Landroid/support/v4/view/ViewPager$SavedState;->position:I

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-virtual {p0, v1, v2, v3}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZ)V

    goto :goto_0

    .line 1456
    :cond_1
    iget v1, v0, Landroid/support/v4/view/ViewPager$SavedState;->position:I

    iput v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    .line 1457
    iget-object v1, v0, Landroid/support/v4/view/ViewPager$SavedState;->adapterState:Landroid/os/Parcelable;

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredAdapterState:Landroid/os/Parcelable;

    .line 1458
    iget-object v1, v0, Landroid/support/v4/view/ViewPager$SavedState;->loader:Ljava/lang/ClassLoader;

    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredClassLoader:Ljava/lang/ClassLoader;

    .line 1460
    :goto_0
    return-void
.end method

.method public onSaveInstanceState()Landroid/os/Parcelable;
    .locals 3

    .line 1433
    invoke-super {p0}, Landroid/view/ViewGroup;->onSaveInstanceState()Landroid/os/Parcelable;

    move-result-object v0

    .line 1434
    .local v0, "superState":Landroid/os/Parcelable;
    new-instance v1, Landroid/support/v4/view/ViewPager$SavedState;

    invoke-direct {v1, v0}, Landroid/support/v4/view/ViewPager$SavedState;-><init>(Landroid/os/Parcelable;)V

    .line 1435
    .local v1, "ss":Landroid/support/v4/view/ViewPager$SavedState;
    iget v2, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    iput v2, v1, Landroid/support/v4/view/ViewPager$SavedState;->position:I

    .line 1436
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v2, :cond_0

    .line 1437
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v2}, Landroid/support/v4/view/PagerAdapter;->saveState()Landroid/os/Parcelable;

    move-result-object v2

    iput-object v2, v1, Landroid/support/v4/view/ViewPager$SavedState;->adapterState:Landroid/os/Parcelable;

    .line 1439
    :cond_0
    return-object v1
.end method

.method protected onSizeChanged(IIII)V
    .locals 2
    .param p1, "w"    # I
    .param p2, "h"    # I
    .param p3, "oldw"    # I
    .param p4, "oldh"    # I

    .line 1638
    invoke-super {p0, p1, p2, p3, p4}, Landroid/view/ViewGroup;->onSizeChanged(IIII)V

    .line 1641
    if-eq p1, p3, :cond_0

    .line 1642
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    iget v1, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    invoke-direct {p0, p1, p3, v0, v1}, Landroid/support/v4/view/ViewPager;->recomputeScrollPosition(IIII)V

    .line 1644
    :cond_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 17
    .param p1, "ev"    # Landroid/view/MotionEvent;

    move-object/from16 v0, p0

    .line 2158
    move-object/from16 v1, p1

    iget-boolean v2, v0, Landroid/support/v4/view/ViewPager;->mFakeDragging:Z

    const/4 v3, 0x1

    if-eqz v2, :cond_0

    .line 2162
    return v3

    .line 2165
    :cond_0
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v2

    const/4 v4, 0x0

    if-nez v2, :cond_1

    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getEdgeFlags()I

    move-result v2

    if-eqz v2, :cond_1

    .line 2168
    return v4

    .line 2171
    :cond_1
    iget-object v2, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v2, :cond_a

    iget-object v2, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v2}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v2

    if-nez v2, :cond_2

    goto/16 :goto_3

    .line 2176
    :cond_2
    iget-object v2, v0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v2, :cond_3

    .line 2177
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v2

    iput-object v2, v0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 2179
    :cond_3
    iget-object v2, v0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v2, v1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 2181
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v2

    .line 2182
    .local v2, "action":I
    const/4 v5, 0x0

    .line 2184
    .local v5, "needsInvalidate":Z
    and-int/lit16 v6, v2, 0xff

    packed-switch v6, :pswitch_data_0

    .line 2278
    :cond_4
    :pswitch_0
    move/from16 v16, v2

    .line 2278
    .end local v2    # "action":I
    .local v16, "action":I
    goto/16 :goto_2

    .line 2274
    .end local v16    # "action":I
    .restart local v2    # "action":I
    :pswitch_1
    invoke-direct/range {p0 .. p1}, Landroid/support/v4/view/ViewPager;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    .line 2275
    iget v4, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v4

    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v4

    iput v4, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    goto :goto_0

    .line 2267
    :pswitch_2
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v4

    .line 2268
    .local v4, "index":I
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    .line 2269
    .local v6, "x":F
    iput v6, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2270
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v7

    iput v7, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2271
    goto :goto_0

    .line 2261
    .end local v4    # "index":I
    .end local v6    # "x":F
    :pswitch_3
    iget-boolean v6, v0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v6, :cond_5

    .line 2262
    iget v6, v0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-direct {v0, v6, v3, v4, v4}, Landroid/support/v4/view/ViewPager;->scrollToItem(IZIZ)V

    .line 2263
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->resetTouch()Z

    move-result v5

    .line 2278
    .end local v2    # "action":I
    .restart local v16    # "action":I
    :cond_5
    :goto_0
    move/from16 v16, v2

    goto/16 :goto_2

    .line 2197
    .end local v16    # "action":I
    .restart local v2    # "action":I
    :pswitch_4
    iget-boolean v4, v0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-nez v4, :cond_8

    .line 2198
    iget v4, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v4

    .line 2199
    .local v4, "pointerIndex":I
    const/4 v6, -0x1

    if-ne v4, v6, :cond_6

    .line 2202
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->resetTouch()Z

    move-result v5

    .line 2203
    goto :goto_0

    .line 2205
    :cond_6
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    .line 2206
    .restart local v6    # "x":F
    iget v7, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    sub-float v7, v6, v7

    invoke-static {v7}, Ljava/lang/Math;->abs(F)F

    move-result v7

    .line 2207
    .local v7, "xDiff":F
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getY(I)F

    move-result v8

    .line 2208
    .local v8, "y":F
    iget v9, v0, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    sub-float v9, v8, v9

    invoke-static {v9}, Ljava/lang/Math;->abs(F)F

    move-result v9

    .line 2212
    .local v9, "yDiff":F
    iget v10, v0, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v10, v10

    cmpl-float v10, v7, v10

    if-lez v10, :cond_8

    cmpl-float v10, v7, v9

    if-lez v10, :cond_8

    .line 2214
    iput-boolean v3, v0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    .line 2215
    invoke-direct {v0, v3}, Landroid/support/v4/view/ViewPager;->requestParentDisallowInterceptTouchEvent(Z)V

    .line 2216
    iget v10, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    sub-float v10, v6, v10

    const/4 v11, 0x0

    cmpl-float v10, v10, v11

    if-lez v10, :cond_7

    iget v10, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iget v11, v0, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v11, v11

    add-float/2addr v10, v11

    goto :goto_1

    :cond_7
    iget v10, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iget v11, v0, Landroid/support/v4/view/ViewPager;->mTouchSlop:I

    int-to-float v11, v11

    sub-float/2addr v10, v11

    :goto_1
    iput v10, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2218
    iput v8, v0, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    .line 2219
    invoke-virtual {v0, v3}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    .line 2220
    invoke-direct {v0, v3}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 2223
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getParent()Landroid/view/ViewParent;

    move-result-object v10

    .line 2224
    .local v10, "parent":Landroid/view/ViewParent;
    if-eqz v10, :cond_8

    .line 2225
    invoke-interface {v10, v3}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 2230
    .end local v4    # "pointerIndex":I
    .end local v6    # "x":F
    .end local v7    # "xDiff":F
    .end local v8    # "y":F
    .end local v9    # "yDiff":F
    .end local v10    # "parent":Landroid/view/ViewParent;
    :cond_8
    iget-boolean v4, v0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v4, :cond_5

    .line 2232
    iget v4, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v4

    .line 2233
    .local v4, "activePointerIndex":I
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    .line 2234
    .restart local v6    # "x":F
    invoke-direct {v0, v6}, Landroid/support/v4/view/ViewPager;->performDrag(F)Z

    move-result v7

    or-int/2addr v5, v7

    .line 2235
    .end local v4    # "activePointerIndex":I
    .end local v6    # "x":F
    goto :goto_0

    .line 2238
    :pswitch_5
    iget-boolean v4, v0, Landroid/support/v4/view/ViewPager;->mIsBeingDragged:Z

    if-eqz v4, :cond_4

    .line 2239
    iget-object v4, v0, Landroid/support/v4/view/ViewPager;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 2240
    .local v4, "velocityTracker":Landroid/view/VelocityTracker;
    const/16 v6, 0x3e8

    iget v7, v0, Landroid/support/v4/view/ViewPager;->mMaximumVelocity:I

    int-to-float v7, v7

    invoke-virtual {v4, v6, v7}, Landroid/view/VelocityTracker;->computeCurrentVelocity(IF)V

    .line 2241
    iget v6, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v4, v6}, Landroid/view/VelocityTracker;->getXVelocity(I)F

    move-result v6

    float-to-int v6, v6

    .line 2242
    .local v6, "initialVelocity":I
    iput-boolean v3, v0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 2243
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v7

    .line 2244
    .local v7, "width":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v8

    .line 2245
    .local v8, "scrollX":I
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->infoForCurrentScrollPosition()Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v9

    .line 2246
    .local v9, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v10, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v10, v10

    int-to-float v11, v7

    div-float/2addr v10, v11

    .line 2247
    .local v10, "marginOffset":F
    iget v11, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 2248
    .local v11, "currentPage":I
    int-to-float v12, v8

    int-to-float v13, v7

    div-float/2addr v12, v13

    iget v13, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->offset:F

    sub-float/2addr v12, v13

    iget v13, v9, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v13, v10

    div-float/2addr v12, v13

    .line 2250
    .local v12, "pageOffset":F
    iget v13, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    invoke-virtual {v1, v13}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v13

    .line 2251
    .local v13, "activePointerIndex":I
    invoke-virtual {v1, v13}, Landroid/view/MotionEvent;->getX(I)F

    move-result v14

    .line 2252
    .local v14, "x":F
    iget v15, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    sub-float v15, v14, v15

    float-to-int v15, v15

    .line 2253
    .local v15, "totalDelta":I
    move/from16 v16, v2

    invoke-direct {v0, v11, v12, v6, v15}, Landroid/support/v4/view/ViewPager;->determineTargetPage(IFII)I

    move-result v2

    .line 2255
    .local v2, "nextPage":I
    .restart local v16    # "action":I
    invoke-virtual {v0, v2, v3, v3, v6}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZI)V

    .line 2257
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->resetTouch()Z

    move-result v5

    .line 2258
    .end local v2    # "nextPage":I
    .end local v4    # "velocityTracker":Landroid/view/VelocityTracker;
    .end local v6    # "initialVelocity":I
    .end local v7    # "width":I
    .end local v8    # "scrollX":I
    .end local v9    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v10    # "marginOffset":F
    .end local v11    # "currentPage":I
    .end local v12    # "pageOffset":F
    .end local v13    # "activePointerIndex":I
    .end local v14    # "x":F
    .end local v15    # "totalDelta":I
    goto :goto_2

    .line 2186
    .end local v16    # "action":I
    .local v2, "action":I
    :pswitch_6
    move/from16 v16, v2

    .line 2186
    .end local v2    # "action":I
    .restart local v16    # "action":I
    iget-object v2, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v2}, Landroid/widget/Scroller;->abortAnimation()V

    .line 2187
    iput-boolean v4, v0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 2188
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 2191
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getX()F

    move-result v2

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionX:F

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mLastMotionX:F

    .line 2192
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getY()F

    move-result v2

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mInitialMotionY:F

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mLastMotionY:F

    .line 2193
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v2

    iput v2, v0, Landroid/support/v4/view/ViewPager;->mActivePointerId:I

    .line 2194
    nop

    .line 2278
    :goto_2
    if-eqz v5, :cond_9

    .line 2279
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 2281
    :cond_9
    return v3

    .line 2173
    .end local v5    # "needsInvalidate":Z
    .end local v16    # "action":I
    :cond_a
    :goto_3
    return v4

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

.method pageLeft()Z
    .locals 2

    .line 2877
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-lez v0, :cond_0

    .line 2878
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    invoke-virtual {p0, v0, v1}, Landroid/support/v4/view/ViewPager;->setCurrentItem(IZ)V

    .line 2879
    return v1

    .line 2881
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method pageRight()Z
    .locals 3

    .line 2885
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v0, :cond_0

    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v1}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v1

    const/4 v2, 0x1

    sub-int/2addr v1, v2

    if-ge v0, v1, :cond_0

    .line 2886
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/2addr v0, v2

    invoke-virtual {p0, v0, v2}, Landroid/support/v4/view/ViewPager;->setCurrentItem(IZ)V

    .line 2887
    return v2

    .line 2889
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method populate()V
    .locals 1

    .line 1084
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->populate(I)V

    .line 1085
    return-void
.end method

.method populate(I)V
    .locals 21
    .param p1, "newCurrentItem"    # I

    move-object/from16 v1, p0

    .line 1088
    move/from16 v2, p1

    const/4 v3, 0x0

    .line 1089
    .local v3, "oldCurInfo":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v4, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-eq v4, v2, :cond_0

    .line 1090
    iget v4, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-virtual {v1, v4}, Landroid/support/v4/view/ViewPager;->infoForPosition(I)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v3

    .line 1091
    iput v2, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    .line 1094
    :cond_0
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-nez v4, :cond_1

    .line 1095
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->sortChildDrawingOrder()V

    .line 1096
    return-void

    .line 1103
    :cond_1
    iget-boolean v4, v1, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    if-eqz v4, :cond_2

    .line 1105
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->sortChildDrawingOrder()V

    .line 1106
    return-void

    .line 1112
    :cond_2
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getWindowToken()Landroid/os/IBinder;

    move-result-object v4

    if-nez v4, :cond_3

    .line 1113
    return-void

    .line 1116
    :cond_3
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v4, v1}, Landroid/support/v4/view/PagerAdapter;->startUpdate(Landroid/view/ViewGroup;)V

    .line 1118
    iget v4, v1, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    .line 1119
    .local v4, "pageLimit":I
    iget v5, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    sub-int/2addr v5, v4

    const/4 v6, 0x0

    invoke-static {v6, v5}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1120
    .local v5, "startPos":I
    iget-object v7, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v7}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v7

    .line 1121
    .local v7, "N":I
    add-int/lit8 v8, v7, -0x1

    iget v9, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/2addr v9, v4

    invoke-static {v8, v9}, Ljava/lang/Math;->min(II)I

    move-result v8

    .line 1123
    .local v8, "endPos":I
    iget v9, v1, Landroid/support/v4/view/ViewPager;->mExpectedAdapterCount:I

    if-eq v7, v9, :cond_4

    .line 1126
    :try_start_0
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getResources()Landroid/content/res/Resources;

    move-result-object v6

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getId()I

    move-result v9

    invoke-virtual {v6, v9}, Landroid/content/res/Resources;->getResourceName(I)Ljava/lang/String;

    move-result-object v6
    :try_end_0
    .catch Landroid/content/res/Resources$NotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1129
    .local v6, "resName":Ljava/lang/String;
    goto :goto_0

    .line 1127
    .end local v6    # "resName":Ljava/lang/String;
    :catch_0
    move-exception v0

    move-object v6, v0

    .line 1128
    .local v6, "e":Landroid/content/res/Resources$NotFoundException;
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getId()I

    move-result v9

    invoke-static {v9}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v6

    .line 1130
    .local v6, "resName":Ljava/lang/String;
    :goto_0
    new-instance v9, Ljava/lang/IllegalStateException;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "The application\'s PagerAdapter changed the adapter\'s contents without calling PagerAdapter#notifyDataSetChanged! Expected adapter item count: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v11, v1, Landroid/support/v4/view/ViewPager;->mExpectedAdapterCount:I

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ", found: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " Pager id: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, " Pager class: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1134
    invoke-virtual/range {p0 .. p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v11, " Problematic adapter: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v11, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    .line 1135
    invoke-virtual {v11}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-direct {v9, v10}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v9

    .line 1139
    .end local v6    # "resName":Ljava/lang/String;
    :cond_4
    const/4 v9, -0x1

    .line 1140
    .local v9, "curIndex":I
    const/4 v10, 0x0

    .line 1141
    .local v10, "curItem":Landroid/support/v4/view/ViewPager$ItemInfo;
    const/4 v9, 0x0

    :goto_1
    iget-object v11, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v11}, Ljava/util/ArrayList;->size()I

    move-result v11

    if-ge v9, v11, :cond_6

    .line 1142
    iget-object v11, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v11, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 1143
    .local v11, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v12, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v13, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-lt v12, v13, :cond_5

    .line 1144
    iget v12, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v13, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v12, v13, :cond_6

    move-object v10, v11

    goto :goto_2

    .line 1141
    .end local v11    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_5
    add-int/lit8 v9, v9, 0x1

    goto :goto_1

    .line 1149
    :cond_6
    :goto_2
    if-nez v10, :cond_7

    if-lez v7, :cond_7

    .line 1150
    iget v11, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-virtual {v1, v11, v9}, Landroid/support/v4/view/ViewPager;->addNewItem(II)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v10

    .line 1156
    :cond_7
    if-eqz v10, :cond_1d

    .line 1157
    const/4 v13, 0x0

    .line 1158
    .local v13, "extraWidthLeft":F
    add-int/lit8 v14, v9, -0x1

    .line 1159
    .local v14, "itemIndex":I
    if-ltz v14, :cond_8

    iget-object v15, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v15, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_3

    :cond_8
    const/4 v15, 0x0

    .line 1160
    .local v15, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_3
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v6

    .line 1161
    .local v6, "clientWidth":I
    const/high16 v17, 0x40000000    # 2.0f

    if-gtz v6, :cond_9

    .line 1162
    const/4 v11, 0x0

    goto :goto_4

    .line 1161
    :cond_9
    iget v12, v10, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    sub-float v12, v17, v12

    .line 1162
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingLeft()I

    move-result v11

    int-to-float v11, v11

    int-to-float v2, v6

    div-float/2addr v11, v2

    add-float/2addr v11, v12

    :goto_4
    move v2, v11

    .line 1163
    .local v2, "leftWidthNeeded":F
    iget v11, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/lit8 v11, v11, -0x1

    .line 1163
    .local v11, "pos":I
    :goto_5
    if-ltz v11, :cond_11

    .line 1164
    cmpl-float v12, v13, v2

    if-ltz v12, :cond_d

    if-ge v11, v5, :cond_d

    .line 1165
    if-nez v15, :cond_a

    .line 1166
    nop

    .line 1191
    move/from16 v18, v2

    goto/16 :goto_c

    .line 1168
    :cond_a
    iget v12, v15, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v11, v12, :cond_c

    iget-boolean v12, v15, Landroid/support/v4/view/ViewPager$ItemInfo;->scrolling:Z

    if-nez v12, :cond_c

    .line 1169
    iget-object v12, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v12, v14}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 1170
    iget-object v12, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    move/from16 v18, v2

    iget-object v2, v15, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    .line 1170
    .end local v2    # "leftWidthNeeded":F
    .local v18, "leftWidthNeeded":F
    invoke-virtual {v12, v1, v11, v2}, Landroid/support/v4/view/PagerAdapter;->destroyItem(Landroid/view/ViewGroup;ILjava/lang/Object;)V

    .line 1175
    add-int/lit8 v14, v14, -0x1

    .line 1176
    add-int/lit8 v9, v9, -0x1

    .line 1177
    if-ltz v14, :cond_b

    iget-object v2, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v2, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    move-object v12, v2

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_6

    :cond_b
    const/4 v12, 0x0

    :goto_6
    move-object v2, v12

    goto :goto_8

    .line 1163
    .end local v18    # "leftWidthNeeded":F
    .restart local v2    # "leftWidthNeeded":F
    :cond_c
    move/from16 v18, v2

    .line 1163
    .end local v2    # "leftWidthNeeded":F
    .restart local v18    # "leftWidthNeeded":F
    goto :goto_b

    .line 1179
    .end local v18    # "leftWidthNeeded":F
    .restart local v2    # "leftWidthNeeded":F
    :cond_d
    move/from16 v18, v2

    .line 1179
    .end local v2    # "leftWidthNeeded":F
    .restart local v18    # "leftWidthNeeded":F
    if-eqz v15, :cond_f

    iget v2, v15, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v11, v2, :cond_f

    .line 1180
    iget v2, v15, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v13, v2

    .line 1181
    add-int/lit8 v14, v14, -0x1

    .line 1182
    if-ltz v14, :cond_e

    iget-object v2, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v2, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    move-object v12, v2

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_7

    :cond_e
    const/4 v12, 0x0

    :goto_7
    move-object v2, v12

    .line 1182
    .end local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v2, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_8
    goto :goto_a

    .line 1184
    .end local v2    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_f
    add-int/lit8 v2, v14, 0x1

    invoke-virtual {v1, v11, v2}, Landroid/support/v4/view/ViewPager;->addNewItem(II)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v2

    .line 1185
    .end local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v2    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget v12, v2, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v13, v12

    .line 1186
    add-int/lit8 v9, v9, 0x1

    .line 1187
    if-ltz v14, :cond_10

    iget-object v12, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v12, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_9

    :cond_10
    const/4 v12, 0x0

    :goto_9
    move-object v2, v12

    .line 1163
    .end local v2    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_a
    move-object v15, v2

    :goto_b
    add-int/lit8 v11, v11, -0x1

    move/from16 v2, v18

    goto :goto_5

    .line 1191
    .end local v11    # "pos":I
    .end local v18    # "leftWidthNeeded":F
    .local v2, "leftWidthNeeded":F
    :cond_11
    move/from16 v18, v2

    .line 1191
    .end local v2    # "leftWidthNeeded":F
    .restart local v18    # "leftWidthNeeded":F
    :goto_c
    iget v2, v10, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    .line 1192
    .local v2, "extraWidthRight":F
    add-int/lit8 v11, v9, 0x1

    .line 1193
    .end local v14    # "itemIndex":I
    .local v11, "itemIndex":I
    cmpg-float v12, v2, v17

    if-gez v12, :cond_1c

    .line 1194
    iget-object v12, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v12}, Ljava/util/ArrayList;->size()I

    move-result v12

    if-ge v11, v12, :cond_12

    iget-object v12, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v12, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_d

    :cond_12
    const/4 v12, 0x0

    .line 1195
    .end local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v12, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_d
    if-gtz v6, :cond_13

    .line 1196
    const/4 v14, 0x0

    goto :goto_e

    :cond_13
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getPaddingRight()I

    move-result v14

    int-to-float v14, v14

    int-to-float v15, v6

    div-float/2addr v14, v15

    add-float v14, v14, v17

    .line 1197
    .local v14, "rightWidthNeeded":F
    :goto_e
    iget v15, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/lit8 v15, v15, 0x1

    .line 1197
    .local v15, "pos":I
    :goto_f
    if-ge v15, v7, :cond_1b

    .line 1198
    cmpl-float v17, v2, v14

    if-ltz v17, :cond_17

    if-le v15, v8, :cond_17

    .line 1199
    if-nez v12, :cond_14

    .line 1200
    nop

    .line 1224
    move/from16 v19, v4

    move/from16 v20, v5

    goto/16 :goto_13

    .line 1202
    :cond_14
    move/from16 v19, v4

    iget v4, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    .line 1202
    .end local v4    # "pageLimit":I
    .local v19, "pageLimit":I
    if-ne v15, v4, :cond_16

    iget-boolean v4, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->scrolling:Z

    if-nez v4, :cond_16

    .line 1203
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v11}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 1204
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    move/from16 v20, v5

    iget-object v5, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    .line 1204
    .end local v5    # "startPos":I
    .local v20, "startPos":I
    invoke-virtual {v4, v1, v15, v5}, Landroid/support/v4/view/PagerAdapter;->destroyItem(Landroid/view/ViewGroup;ILjava/lang/Object;)V

    .line 1209
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v11, v4, :cond_15

    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_10

    :cond_15
    const/4 v4, 0x0

    :goto_10
    move-object v12, v4

    goto :goto_12

    .line 1197
    .end local v20    # "startPos":I
    .restart local v5    # "startPos":I
    :cond_16
    move/from16 v20, v5

    .line 1197
    .end local v5    # "startPos":I
    .restart local v20    # "startPos":I
    goto :goto_12

    .line 1211
    .end local v19    # "pageLimit":I
    .end local v20    # "startPos":I
    .restart local v4    # "pageLimit":I
    .restart local v5    # "startPos":I
    :cond_17
    move/from16 v19, v4

    move/from16 v20, v5

    .line 1211
    .end local v4    # "pageLimit":I
    .end local v5    # "startPos":I
    .restart local v19    # "pageLimit":I
    .restart local v20    # "startPos":I
    if-eqz v12, :cond_19

    iget v4, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    if-ne v15, v4, :cond_19

    .line 1212
    iget v4, v12, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v2, v4

    .line 1213
    add-int/lit8 v11, v11, 0x1

    .line 1214
    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v11, v4, :cond_18

    iget-object v4, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_11

    :cond_18
    const/4 v4, 0x0

    :goto_11
    move-object v12, v4

    goto :goto_12

    .line 1216
    :cond_19
    invoke-virtual {v1, v15, v11}, Landroid/support/v4/view/ViewPager;->addNewItem(II)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v4

    .line 1217
    .end local v12    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v4, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    add-int/lit8 v11, v11, 0x1

    .line 1218
    iget v5, v4, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    add-float/2addr v2, v5

    .line 1219
    iget-object v5, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    if-ge v11, v5, :cond_1a

    iget-object v5, v1, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v5, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    move-object v12, v5

    check-cast v12, Landroid/support/v4/view/ViewPager$ItemInfo;

    goto :goto_12

    :cond_1a
    const/4 v12, 0x0

    .line 1197
    .end local v4    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v12    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :goto_12
    add-int/lit8 v15, v15, 0x1

    move/from16 v4, v19

    move/from16 v5, v20

    goto/16 :goto_f

    .line 1224
    .end local v14    # "rightWidthNeeded":F
    .end local v15    # "pos":I
    .end local v19    # "pageLimit":I
    .end local v20    # "startPos":I
    .local v4, "pageLimit":I
    .restart local v5    # "startPos":I
    :cond_1b
    move/from16 v19, v4

    move/from16 v20, v5

    goto :goto_13

    .line 1224
    .end local v12    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .local v15, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    :cond_1c
    move/from16 v19, v4

    move/from16 v20, v5

    move-object v12, v15

    .line 1224
    .end local v4    # "pageLimit":I
    .end local v5    # "startPos":I
    .end local v15    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v12    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .restart local v19    # "pageLimit":I
    .restart local v20    # "startPos":I
    :goto_13
    invoke-direct {v1, v10, v9, v3}, Landroid/support/v4/view/ViewPager;->calculatePageOffsets(Landroid/support/v4/view/ViewPager$ItemInfo;ILandroid/support/v4/view/ViewPager$ItemInfo;)V

    .line 1224
    .end local v2    # "extraWidthRight":F
    .end local v6    # "clientWidth":I
    .end local v11    # "itemIndex":I
    .end local v12    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v13    # "extraWidthLeft":F
    .end local v18    # "leftWidthNeeded":F
    goto :goto_14

    .line 1234
    .end local v19    # "pageLimit":I
    .end local v20    # "startPos":I
    .restart local v4    # "pageLimit":I
    .restart local v5    # "startPos":I
    :cond_1d
    move/from16 v19, v4

    move/from16 v20, v5

    .line 1234
    .end local v4    # "pageLimit":I
    .end local v5    # "startPos":I
    .restart local v19    # "pageLimit":I
    .restart local v20    # "startPos":I
    :goto_14
    iget-object v2, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget v4, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-eqz v10, :cond_1e

    iget-object v12, v10, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    goto :goto_15

    :cond_1e
    const/4 v12, 0x0

    :goto_15
    invoke-virtual {v2, v1, v4, v12}, Landroid/support/v4/view/PagerAdapter;->setPrimaryItem(Landroid/view/ViewGroup;ILjava/lang/Object;)V

    .line 1236
    iget-object v2, v1, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v2, v1}, Landroid/support/v4/view/PagerAdapter;->finishUpdate(Landroid/view/ViewGroup;)V

    .line 1240
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v2

    .line 1241
    .local v2, "childCount":I
    const/4 v4, 0x0

    .line 1241
    .local v4, "i":I
    :goto_16
    if-ge v4, v2, :cond_21

    .line 1242
    invoke-virtual {v1, v4}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 1243
    .local v5, "child":Landroid/view/View;
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v4/view/ViewPager$LayoutParams;

    .line 1244
    .local v6, "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    iput v4, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->childIndex:I

    .line 1245
    iget-boolean v11, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->isDecor:Z

    if-nez v11, :cond_1f

    iget v11, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->widthFactor:F

    const/4 v12, 0x0

    cmpl-float v11, v11, v12

    if-nez v11, :cond_20

    .line 1247
    invoke-virtual {v1, v5}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v11

    .line 1248
    .local v11, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v11, :cond_20

    .line 1249
    iget v13, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->widthFactor:F

    iput v13, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->widthFactor:F

    .line 1250
    iget v13, v11, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iput v13, v6, Landroid/support/v4/view/ViewPager$LayoutParams;->position:I

    .line 1250
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v4/view/ViewPager$LayoutParams;
    .end local v11    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    goto :goto_17

    .line 1241
    :cond_1f
    const/4 v12, 0x0

    :cond_20
    :goto_17
    add-int/lit8 v4, v4, 0x1

    goto :goto_16

    .line 1254
    .end local v4    # "i":I
    :cond_21
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->sortChildDrawingOrder()V

    .line 1256
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->hasFocus()Z

    move-result v4

    if-eqz v4, :cond_25

    .line 1257
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->findFocus()Landroid/view/View;

    move-result-object v4

    .line 1258
    .local v4, "currentFocused":Landroid/view/View;
    if-eqz v4, :cond_22

    invoke-virtual {v1, v4}, Landroid/support/v4/view/ViewPager;->infoForAnyChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v12

    goto :goto_18

    :cond_22
    const/4 v12, 0x0

    :goto_18
    move-object v5, v12

    .line 1259
    .local v5, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    if-eqz v5, :cond_23

    iget v6, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v11, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-eq v6, v11, :cond_25

    .line 1260
    :cond_23
    const/16 v16, 0x0

    .line 1260
    .local v16, "i":I
    :goto_19
    move/from16 v6, v16

    .line 1260
    .end local v16    # "i":I
    .local v6, "i":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v11

    if-ge v6, v11, :cond_25

    .line 1261
    invoke-virtual {v1, v6}, Landroid/support/v4/view/ViewPager;->getChildAt(I)Landroid/view/View;

    move-result-object v11

    .line 1262
    .local v11, "child":Landroid/view/View;
    invoke-virtual {v1, v11}, Landroid/support/v4/view/ViewPager;->infoForChild(Landroid/view/View;)Landroid/support/v4/view/ViewPager$ItemInfo;

    move-result-object v5

    .line 1263
    if-eqz v5, :cond_24

    iget v12, v5, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget v13, v1, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v12, v13, :cond_24

    .line 1264
    const/4 v12, 0x2

    invoke-virtual {v11, v12}, Landroid/view/View;->requestFocus(I)Z

    move-result v12

    if-eqz v12, :cond_24

    .line 1265
    goto :goto_1a

    .line 1260
    .end local v11    # "child":Landroid/view/View;
    :cond_24
    add-int/lit8 v16, v6, 0x1

    .line 1260
    .end local v6    # "i":I
    .restart local v16    # "i":I
    goto :goto_19

    .line 1271
    .end local v4    # "currentFocused":Landroid/view/View;
    .end local v5    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    .end local v16    # "i":I
    :cond_25
    :goto_1a
    return-void
.end method

.method public removeOnAdapterChangeListener(Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 587
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_0

    .line 588
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 590
    :cond_0
    return-void
.end method

.method public removeOnPageChangeListener(Landroid/support/v4/view/ViewPager$OnPageChangeListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 729
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    if-eqz v0, :cond_0

    .line 730
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 732
    :cond_0
    return-void
.end method

.method public removeView(Landroid/view/View;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 1496
    iget-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mInLayout:Z

    if-eqz v0, :cond_0

    .line 1497
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewPager;->removeViewInLayout(Landroid/view/View;)V

    goto :goto_0

    .line 1499
    :cond_0
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1501
    :goto_0
    return-void
.end method

.method public setAdapter(Landroid/support/v4/view/PagerAdapter;)V
    .locals 8
    .param p1, "adapter"    # Landroid/support/v4/view/PagerAdapter;

    .line 500
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-eqz v0, :cond_1

    .line 501
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0, v1}, Landroid/support/v4/view/PagerAdapter;->setViewPagerObserver(Landroid/database/DataSetObserver;)V

    .line 502
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0, p0}, Landroid/support/v4/view/PagerAdapter;->startUpdate(Landroid/view/ViewGroup;)V

    .line 503
    move v0, v2

    .line 503
    .local v0, "i":I
    :goto_0
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v0, v3, :cond_0

    .line 504
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/v4/view/ViewPager$ItemInfo;

    .line 505
    .local v3, "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget v5, v3, Landroid/support/v4/view/ViewPager$ItemInfo;->position:I

    iget-object v6, v3, Landroid/support/v4/view/ViewPager$ItemInfo;->object:Ljava/lang/Object;

    invoke-virtual {v4, p0, v5, v6}, Landroid/support/v4/view/PagerAdapter;->destroyItem(Landroid/view/ViewGroup;ILjava/lang/Object;)V

    .line 503
    .end local v3    # "ii":Landroid/support/v4/view/ViewPager$ItemInfo;
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 507
    .end local v0    # "i":I
    :cond_0
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0, p0}, Landroid/support/v4/view/PagerAdapter;->finishUpdate(Landroid/view/ViewGroup;)V

    .line 508
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 509
    invoke-direct {p0}, Landroid/support/v4/view/ViewPager;->removeNonDecorViews()V

    .line 510
    iput v2, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    .line 511
    invoke-virtual {p0, v2, v2}, Landroid/support/v4/view/ViewPager;->scrollTo(II)V

    .line 514
    :cond_1
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    .line 515
    .local v0, "oldAdapter":Landroid/support/v4/view/PagerAdapter;
    iput-object p1, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    .line 516
    iput v2, p0, Landroid/support/v4/view/ViewPager;->mExpectedAdapterCount:I

    .line 518
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    if-eqz v3, :cond_5

    .line 519
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mObserver:Landroid/support/v4/view/ViewPager$PagerObserver;

    if-nez v3, :cond_2

    .line 520
    new-instance v3, Landroid/support/v4/view/ViewPager$PagerObserver;

    invoke-direct {v3, p0}, Landroid/support/v4/view/ViewPager$PagerObserver;-><init>(Landroid/support/v4/view/ViewPager;)V

    iput-object v3, p0, Landroid/support/v4/view/ViewPager;->mObserver:Landroid/support/v4/view/ViewPager$PagerObserver;

    .line 522
    :cond_2
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mObserver:Landroid/support/v4/view/ViewPager$PagerObserver;

    invoke-virtual {v3, v4}, Landroid/support/v4/view/PagerAdapter;->setViewPagerObserver(Landroid/database/DataSetObserver;)V

    .line 523
    iput-boolean v2, p0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 524
    iget-boolean v3, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 525
    .local v3, "wasFirstLayout":Z
    const/4 v4, 0x1

    iput-boolean v4, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    .line 526
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v5}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v5

    iput v5, p0, Landroid/support/v4/view/ViewPager;->mExpectedAdapterCount:I

    .line 527
    iget v5, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    if-ltz v5, :cond_3

    .line 528
    iget-object v5, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget-object v6, p0, Landroid/support/v4/view/ViewPager;->mRestoredAdapterState:Landroid/os/Parcelable;

    iget-object v7, p0, Landroid/support/v4/view/ViewPager;->mRestoredClassLoader:Ljava/lang/ClassLoader;

    invoke-virtual {v5, v6, v7}, Landroid/support/v4/view/PagerAdapter;->restoreState(Landroid/os/Parcelable;Ljava/lang/ClassLoader;)V

    .line 529
    iget v5, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    invoke-virtual {p0, v5, v2, v4}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZ)V

    .line 530
    const/4 v2, -0x1

    iput v2, p0, Landroid/support/v4/view/ViewPager;->mRestoredCurItem:I

    .line 531
    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredAdapterState:Landroid/os/Parcelable;

    .line 532
    iput-object v1, p0, Landroid/support/v4/view/ViewPager;->mRestoredClassLoader:Ljava/lang/ClassLoader;

    goto :goto_1

    .line 533
    :cond_3
    if-nez v3, :cond_4

    .line 534
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->populate()V

    goto :goto_1

    .line 536
    :cond_4
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->requestLayout()V

    .line 541
    .end local v3    # "wasFirstLayout":Z
    :cond_5
    :goto_1
    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    if-eqz v1, :cond_6

    iget-object v1, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_6

    .line 542
    const/4 v1, 0x0

    .line 542
    .local v1, "i":I
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    .line 542
    .local v2, "count":I
    :goto_2
    if-ge v1, v2, :cond_6

    .line 543
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mAdapterChangeListeners:Ljava/util/List;

    invoke-interface {v3, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;

    invoke-interface {v3, p0, v0, p1}, Landroid/support/v4/view/ViewPager$OnAdapterChangeListener;->onAdapterChanged(Landroid/support/v4/view/ViewPager;Landroid/support/v4/view/PagerAdapter;Landroid/support/v4/view/PagerAdapter;)V

    .line 542
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 546
    .end local v1    # "i":I
    .end local v2    # "count":I
    :cond_6
    return-void
.end method

.method public setCurrentItem(I)V
    .locals 2
    .param p1, "item"    # I

    .line 604
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 605
    iget-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    xor-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, p1, v1, v0}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZ)V

    .line 606
    return-void
.end method

.method public setCurrentItem(IZ)V
    .locals 1
    .param p1, "item"    # I
    .param p2, "smoothScroll"    # Z

    .line 615
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/view/ViewPager;->mPopulatePending:Z

    .line 616
    invoke-virtual {p0, p1, p2, v0}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZ)V

    .line 617
    return-void
.end method

.method setCurrentItemInternal(IZZ)V
    .locals 1
    .param p1, "item"    # I
    .param p2, "smoothScroll"    # Z
    .param p3, "always"    # Z

    .line 624
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, p3, v0}, Landroid/support/v4/view/ViewPager;->setCurrentItemInternal(IZZI)V

    .line 625
    return-void
.end method

.method setCurrentItemInternal(IZZI)V
    .locals 5
    .param p1, "item"    # I
    .param p2, "smoothScroll"    # Z
    .param p3, "always"    # Z
    .param p4, "velocity"    # I

    .line 628
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    const/4 v1, 0x0

    if-eqz v0, :cond_9

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v0}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_4

    .line 632
    :cond_0
    if-nez p3, :cond_1

    iget v0, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-ne v0, p1, :cond_1

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-eqz v0, :cond_1

    .line 633
    invoke-direct {p0, v1}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 634
    return-void

    .line 637
    :cond_1
    const/4 v0, 0x1

    if-gez p1, :cond_2

    .line 638
    const/4 p1, 0x0

    goto :goto_0

    .line 639
    :cond_2
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v2}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v2

    if-lt p1, v2, :cond_3

    .line 640
    iget-object v2, p0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    invoke-virtual {v2}, Landroid/support/v4/view/PagerAdapter;->getCount()I

    move-result v2

    add-int/lit8 p1, v2, -0x1

    .line 642
    :cond_3
    :goto_0
    iget v2, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    .line 643
    .local v2, "pageLimit":I
    iget v3, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    add-int/2addr v3, v2

    if-gt p1, v3, :cond_4

    iget v3, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    sub-int/2addr v3, v2

    if-ge p1, v3, :cond_5

    .line 647
    :cond_4
    move v3, v1

    .line 647
    .local v3, "i":I
    :goto_1
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_5

    .line 648
    iget-object v4, p0, Landroid/support/v4/view/ViewPager;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v4/view/ViewPager$ItemInfo;

    iput-boolean v0, v4, Landroid/support/v4/view/ViewPager$ItemInfo;->scrolling:Z

    .line 647
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 651
    .end local v3    # "i":I
    :cond_5
    iget v3, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    if-eq v3, p1, :cond_6

    goto :goto_2

    :cond_6
    move v0, v1

    .line 653
    .local v0, "dispatchSelected":Z
    :goto_2
    iget-boolean v1, p0, Landroid/support/v4/view/ViewPager;->mFirstLayout:Z

    if-eqz v1, :cond_8

    .line 656
    iput p1, p0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    .line 657
    if-eqz v0, :cond_7

    .line 658
    invoke-direct {p0, p1}, Landroid/support/v4/view/ViewPager;->dispatchOnPageSelected(I)V

    .line 660
    :cond_7
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->requestLayout()V

    goto :goto_3

    .line 662
    :cond_8
    invoke-virtual {p0, p1}, Landroid/support/v4/view/ViewPager;->populate(I)V

    .line 663
    invoke-direct {p0, p1, p2, p4, v0}, Landroid/support/v4/view/ViewPager;->scrollToItem(IZIZ)V

    .line 665
    :goto_3
    return-void

    .line 629
    .end local v0    # "dispatchSelected":Z
    .end local v2    # "pageLimit":I
    :cond_9
    :goto_4
    invoke-direct {p0, v1}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 630
    return-void
.end method

.method setInternalPageChangeListener(Landroid/support/v4/view/ViewPager$OnPageChangeListener;)Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    .locals 1
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 807
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 808
    .local v0, "oldListener":Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    iput-object p1, p0, Landroid/support/v4/view/ViewPager;->mInternalPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 809
    return-object v0
.end method

.method public setOffscreenPageLimit(I)V
    .locals 4
    .param p1, "limit"    # I

    .line 841
    const/4 v0, 0x1

    if-ge p1, v0, :cond_0

    .line 842
    const-string v1, "ViewPager"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Requested offscreen page limit "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " too small; defaulting to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 844
    const/4 p1, 0x1

    .line 846
    :cond_0
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    if-eq p1, v0, :cond_1

    .line 847
    iput p1, p0, Landroid/support/v4/view/ViewPager;->mOffscreenPageLimit:I

    .line 848
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 850
    :cond_1
    return-void
.end method

.method public setOnPageChangeListener(Landroid/support/v4/view/ViewPager$OnPageChangeListener;)V
    .locals 0
    .param p1, "listener"    # Landroid/support/v4/view/ViewPager$OnPageChangeListener;
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 702
    iput-object p1, p0, Landroid/support/v4/view/ViewPager;->mOnPageChangeListener:Landroid/support/v4/view/ViewPager$OnPageChangeListener;

    .line 703
    return-void
.end method

.method public setPageMargin(I)V
    .locals 2
    .param p1, "marginPixels"    # I

    .line 861
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    .line 862
    .local v0, "oldMargin":I
    iput p1, p0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    .line 864
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getWidth()I

    move-result v1

    .line 865
    .local v1, "width":I
    invoke-direct {p0, v1, v1, p1, v0}, Landroid/support/v4/view/ViewPager;->recomputeScrollPosition(IIII)V

    .line 867
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->requestLayout()V

    .line 868
    return-void
.end method

.method public setPageMarginDrawable(I)V
    .locals 1
    .param p1, "resId"    # I
        .annotation build Landroid/support/annotation/DrawableRes;
        .end annotation
    .end param

    .line 897
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Landroid/support/v4/content/ContextCompat;->getDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setPageMarginDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 898
    return-void
.end method

.method public setPageMarginDrawable(Landroid/graphics/drawable/Drawable;)V
    .locals 1
    .param p1, "d"    # Landroid/graphics/drawable/Drawable;

    .line 885
    iput-object p1, p0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    .line 886
    if-eqz p1, :cond_0

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->refreshDrawableState()V

    .line 887
    :cond_0
    if-nez p1, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/v4/view/ViewPager;->setWillNotDraw(Z)V

    .line 888
    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->invalidate()V

    .line 889
    return-void
.end method

.method public setPageTransformer(ZLandroid/support/v4/view/ViewPager$PageTransformer;)V
    .locals 1
    .param p1, "reverseDrawingOrder"    # Z
    .param p2, "transformer"    # Landroid/support/v4/view/ViewPager$PageTransformer;

    .line 761
    const/4 v0, 0x2

    invoke-virtual {p0, p1, p2, v0}, Landroid/support/v4/view/ViewPager;->setPageTransformer(ZLandroid/support/v4/view/ViewPager$PageTransformer;I)V

    .line 762
    return-void
.end method

.method public setPageTransformer(ZLandroid/support/v4/view/ViewPager$PageTransformer;I)V
    .locals 4
    .param p1, "reverseDrawingOrder"    # Z
    .param p2, "transformer"    # Landroid/support/v4/view/ViewPager$PageTransformer;
    .param p3, "pageLayerType"    # I

    .line 779
    const/4 v0, 0x0

    const/4 v1, 0x1

    if-eqz p2, :cond_0

    move v2, v1

    goto :goto_0

    :cond_0
    move v2, v0

    .line 780
    .local v2, "hasTransformer":Z
    :goto_0
    iget-object v3, p0, Landroid/support/v4/view/ViewPager;->mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

    if-eqz v3, :cond_1

    move v3, v1

    goto :goto_1

    :cond_1
    move v3, v0

    :goto_1
    if-eq v2, v3, :cond_2

    move v3, v1

    goto :goto_2

    :cond_2
    move v3, v0

    .line 781
    .local v3, "needsPopulate":Z
    :goto_2
    iput-object p2, p0, Landroid/support/v4/view/ViewPager;->mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

    .line 782
    invoke-virtual {p0, v2}, Landroid/support/v4/view/ViewPager;->setChildrenDrawingOrderEnabled(Z)V

    .line 783
    if-eqz v2, :cond_4

    .line 784
    if-eqz p1, :cond_3

    const/4 v1, 0x2

    nop

    :cond_3
    iput v1, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrder:I

    .line 785
    iput p3, p0, Landroid/support/v4/view/ViewPager;->mPageTransformerLayerType:I

    goto :goto_3

    .line 787
    :cond_4
    iput v0, p0, Landroid/support/v4/view/ViewPager;->mDrawingOrder:I

    .line 789
    :goto_3
    if-eqz v3, :cond_5

    invoke-virtual {p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 790
    :cond_5
    return-void
.end method

.method setScrollState(I)V
    .locals 1
    .param p1, "newState"    # I

    .line 482
    iget v0, p0, Landroid/support/v4/view/ViewPager;->mScrollState:I

    if-ne v0, p1, :cond_0

    .line 483
    return-void

    .line 486
    :cond_0
    iput p1, p0, Landroid/support/v4/view/ViewPager;->mScrollState:I

    .line 487
    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mPageTransformer:Landroid/support/v4/view/ViewPager$PageTransformer;

    if-eqz v0, :cond_2

    .line 489
    if-eqz p1, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    invoke-direct {p0, v0}, Landroid/support/v4/view/ViewPager;->enableLayers(Z)V

    .line 491
    :cond_2
    invoke-direct {p0, p1}, Landroid/support/v4/view/ViewPager;->dispatchOnScrollStateChanged(I)V

    .line 492
    return-void
.end method

.method smoothScrollTo(II)V
    .locals 1
    .param p1, "x"    # I
    .param p2, "y"    # I

    .line 931
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0}, Landroid/support/v4/view/ViewPager;->smoothScrollTo(III)V

    .line 932
    return-void
.end method

.method smoothScrollTo(III)V
    .locals 18
    .param p1, "x"    # I
    .param p2, "y"    # I
    .param p3, "velocity"    # I

    move-object/from16 v0, p0

    .line 942
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    .line 944
    invoke-direct {v0, v2}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 945
    return-void

    .line 949
    :cond_0
    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    const/4 v3, 0x1

    if-eqz v1, :cond_1

    iget-object v1, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v1}, Landroid/widget/Scroller;->isFinished()Z

    move-result v1

    if-nez v1, :cond_1

    move v1, v3

    goto :goto_0

    :cond_1
    move v1, v2

    .line 950
    .local v1, "wasScrolling":Z
    :goto_0
    if-eqz v1, :cond_3

    .line 955
    iget-boolean v4, v0, Landroid/support/v4/view/ViewPager;->mIsScrollStarted:Z

    if-eqz v4, :cond_2

    iget-object v4, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v4}, Landroid/widget/Scroller;->getCurrX()I

    move-result v4

    goto :goto_1

    :cond_2
    iget-object v4, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v4}, Landroid/widget/Scroller;->getStartX()I

    move-result v4

    .line 957
    .local v4, "sx":I
    :goto_1
    iget-object v5, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    invoke-virtual {v5}, Landroid/widget/Scroller;->abortAnimation()V

    .line 958
    invoke-direct {v0, v2}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    goto :goto_2

    .line 960
    .end local v4    # "sx":I
    :cond_3
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollX()I

    move-result v4

    .line 962
    .restart local v4    # "sx":I
    :goto_2
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getScrollY()I

    move-result v11

    .line 963
    .local v11, "sy":I
    sub-int v12, p1, v4

    .line 964
    .local v12, "dx":I
    sub-int v13, p2, v11

    .line 965
    .local v13, "dy":I
    if-nez v12, :cond_4

    if-nez v13, :cond_4

    .line 966
    invoke-direct {v0, v2}, Landroid/support/v4/view/ViewPager;->completeScroll(Z)V

    .line 967
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->populate()V

    .line 968
    invoke-virtual {v0, v2}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    .line 969
    return-void

    .line 972
    :cond_4
    invoke-direct {v0, v3}, Landroid/support/v4/view/ViewPager;->setScrollingCacheEnabled(Z)V

    .line 973
    const/4 v3, 0x2

    invoke-virtual {v0, v3}, Landroid/support/v4/view/ViewPager;->setScrollState(I)V

    .line 975
    invoke-direct/range {p0 .. p0}, Landroid/support/v4/view/ViewPager;->getClientWidth()I

    move-result v3

    .line 976
    .local v3, "width":I
    div-int/lit8 v10, v3, 0x2

    .line 977
    .local v10, "halfWidth":I
    invoke-static {v12}, Ljava/lang/Math;->abs(I)I

    move-result v5

    int-to-float v5, v5

    const/high16 v6, 0x3f800000    # 1.0f

    mul-float/2addr v5, v6

    int-to-float v7, v3

    div-float/2addr v5, v7

    invoke-static {v6, v5}, Ljava/lang/Math;->min(FF)F

    move-result v9

    .line 978
    .local v9, "distanceRatio":F
    int-to-float v5, v10

    int-to-float v7, v10

    .line 979
    invoke-virtual {v0, v9}, Landroid/support/v4/view/ViewPager;->distanceInfluenceForSnapDuration(F)F

    move-result v8

    mul-float/2addr v7, v8

    add-float v14, v5, v7

    .line 982
    .local v14, "distance":F
    invoke-static/range {p3 .. p3}, Ljava/lang/Math;->abs(I)I

    move-result v8

    .line 983
    .end local p3    # "velocity":I
    .local v8, "velocity":I
    if-lez v8, :cond_5

    .line 984
    const/high16 v5, 0x447a0000    # 1000.0f

    int-to-float v6, v8

    div-float v6, v14, v6

    invoke-static {v6}, Ljava/lang/Math;->abs(F)F

    move-result v6

    mul-float/2addr v6, v5

    invoke-static {v6}, Ljava/lang/Math;->round(F)I

    move-result v5

    mul-int/lit8 v5, v5, 0x4

    .line 984
    .local v5, "duration":I
    goto :goto_3

    .line 986
    .end local v5    # "duration":I
    :cond_5
    int-to-float v5, v3

    iget-object v7, v0, Landroid/support/v4/view/ViewPager;->mAdapter:Landroid/support/v4/view/PagerAdapter;

    iget v2, v0, Landroid/support/v4/view/ViewPager;->mCurItem:I

    invoke-virtual {v7, v2}, Landroid/support/v4/view/PagerAdapter;->getPageWidth(I)F

    move-result v2

    mul-float/2addr v5, v2

    .line 987
    .local v5, "pageWidth":F
    invoke-static {v12}, Ljava/lang/Math;->abs(I)I

    move-result v2

    int-to-float v2, v2

    iget v7, v0, Landroid/support/v4/view/ViewPager;->mPageMargin:I

    int-to-float v7, v7

    add-float/2addr v7, v5

    div-float/2addr v2, v7

    .line 988
    .local v2, "pageDelta":F
    add-float/2addr v6, v2

    const/high16 v7, 0x42c80000    # 100.0f

    mul-float/2addr v6, v7

    float-to-int v5, v6

    .line 988
    .end local v2    # "pageDelta":F
    .local v5, "duration":I
    :goto_3
    move v2, v5

    .line 990
    .end local v5    # "duration":I
    .local v2, "duration":I
    const/16 v5, 0x258

    invoke-static {v2, v5}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 994
    const/4 v5, 0x0

    iput-boolean v5, v0, Landroid/support/v4/view/ViewPager;->mIsScrollStarted:Z

    .line 995
    iget-object v5, v0, Landroid/support/v4/view/ViewPager;->mScroller:Landroid/widget/Scroller;

    move v6, v4

    move v7, v11

    move v15, v8

    move v8, v12

    .line 995
    .end local v8    # "velocity":I
    .local v15, "velocity":I
    move/from16 v16, v9

    move v9, v13

    .line 995
    .end local v9    # "distanceRatio":F
    .local v16, "distanceRatio":F
    move/from16 v17, v10

    move v10, v2

    .line 995
    .end local v10    # "halfWidth":I
    .local v17, "halfWidth":I
    invoke-virtual/range {v5 .. v10}, Landroid/widget/Scroller;->startScroll(IIIII)V

    .line 996
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 997
    return-void
.end method

.method protected verifyDrawable(Landroid/graphics/drawable/Drawable;)Z
    .locals 1
    .param p1, "who"    # Landroid/graphics/drawable/Drawable;

    .line 902
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->verifyDrawable(Landroid/graphics/drawable/Drawable;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Landroid/support/v4/view/ViewPager;->mMarginDrawable:Landroid/graphics/drawable/Drawable;

    if-ne p1, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method
