.class public Landroid/support/design/widget/AppBarLayout;
.super Landroid/widget/LinearLayout;
.source "AppBarLayout.java"


# annotations
.annotation runtime Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;
    value = Landroid/support/design/widget/AppBarLayout$Behavior;
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/design/widget/AppBarLayout$ScrollingViewBehavior;,
        Landroid/support/design/widget/AppBarLayout$Behavior;,
        Landroid/support/design/widget/AppBarLayout$LayoutParams;,
        Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;
    }
.end annotation


# static fields
.field private static final INVALID_SCROLL_RANGE:I = -0x1

.field static final PENDING_ACTION_ANIMATE_ENABLED:I = 0x4

.field static final PENDING_ACTION_COLLAPSED:I = 0x2

.field static final PENDING_ACTION_EXPANDED:I = 0x1

.field static final PENDING_ACTION_FORCE:I = 0x8

.field static final PENDING_ACTION_NONE:I


# instance fields
.field private mCollapsed:Z

.field private mCollapsible:Z

.field private mDownPreScrollRange:I

.field private mDownScrollRange:I

.field private mHaveChildWithInterpolator:Z

.field private mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

.field private mListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;",
            ">;"
        }
    .end annotation
.end field

.field private mPendingAction:I

.field private mTmpStatesArray:[I

.field private mTotalScrollRange:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 151
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Landroid/support/design/widget/AppBarLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 152
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 155
    invoke-direct {p0, p1, p2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 133
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mTotalScrollRange:I

    .line 134
    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownPreScrollRange:I

    .line 135
    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownScrollRange:I

    .line 139
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mPendingAction:I

    .line 156
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->setOrientation(I)V

    .line 158
    invoke-static {p1}, Landroid/support/design/widget/ThemeUtils;->checkAppCompatTheme(Landroid/content/Context;)V

    .line 160
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v1, v2, :cond_0

    .line 163
    invoke-static {p0}, Landroid/support/design/widget/ViewUtilsLollipop;->setBoundsViewOutlineProvider(Landroid/view/View;)V

    .line 167
    sget v1, Landroid/support/design/R$style;->Widget_Design_AppBarLayout:I

    invoke-static {p0, p2, v0, v1}, Landroid/support/design/widget/ViewUtilsLollipop;->setStateListAnimatorFromAttrs(Landroid/view/View;Landroid/util/AttributeSet;II)V

    .line 171
    :cond_0
    sget-object v1, Landroid/support/design/R$styleable;->AppBarLayout:[I

    sget v3, Landroid/support/design/R$style;->Widget_Design_AppBarLayout:I

    invoke-virtual {p1, p2, v1, v0, v3}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[III)Landroid/content/res/TypedArray;

    move-result-object v1

    .line 173
    .local v1, "a":Landroid/content/res/TypedArray;
    sget v3, Landroid/support/design/R$styleable;->AppBarLayout_android_background:I

    invoke-virtual {v1, v3}, Landroid/content/res/TypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v3

    invoke-static {p0, v3}, Landroid/support/v4/view/ViewCompat;->setBackground(Landroid/view/View;Landroid/graphics/drawable/Drawable;)V

    .line 174
    sget v3, Landroid/support/design/R$styleable;->AppBarLayout_expanded:I

    invoke-virtual {v1, v3}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 175
    sget v3, Landroid/support/design/R$styleable;->AppBarLayout_expanded:I

    invoke-virtual {v1, v3, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v3

    invoke-direct {p0, v3, v0, v0}, Landroid/support/design/widget/AppBarLayout;->setExpanded(ZZZ)V

    .line 177
    :cond_1
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v3, v2, :cond_2

    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_elevation:I

    invoke-virtual {v1, v2}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 178
    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_elevation:I

    .line 179
    invoke-virtual {v1, v2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v2

    int-to-float v2, v2

    .line 178
    invoke-static {p0, v2}, Landroid/support/design/widget/ViewUtilsLollipop;->setDefaultAppBarLayoutStateListAnimator(Landroid/view/View;F)V

    .line 181
    :cond_2
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1a

    if-lt v2, v3, :cond_4

    .line 184
    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_android_keyboardNavigationCluster:I

    invoke-virtual {v1, v2}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 185
    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_android_keyboardNavigationCluster:I

    invoke-virtual {v1, v2, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v2

    invoke-virtual {p0, v2}, Landroid/support/design/widget/AppBarLayout;->setKeyboardNavigationCluster(Z)V

    .line 188
    :cond_3
    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_android_touchscreenBlocksFocus:I

    invoke-virtual {v1, v2}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 189
    sget v2, Landroid/support/design/R$styleable;->AppBarLayout_android_touchscreenBlocksFocus:I

    invoke-virtual {v1, v2, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    invoke-virtual {p0, v0}, Landroid/support/design/widget/AppBarLayout;->setTouchscreenBlocksFocus(Z)V

    .line 193
    :cond_4
    invoke-virtual {v1}, Landroid/content/res/TypedArray;->recycle()V

    .line 195
    new-instance v0, Landroid/support/design/widget/AppBarLayout$1;

    invoke-direct {v0, p0}, Landroid/support/design/widget/AppBarLayout$1;-><init>(Landroid/support/design/widget/AppBarLayout;)V

    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->setOnApplyWindowInsetsListener(Landroid/view/View;Landroid/support/v4/view/OnApplyWindowInsetsListener;)V

    .line 203
    return-void
.end method

.method private invalidateScrollRanges()V
    .locals 1

    .line 271
    const/4 v0, -0x1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mTotalScrollRange:I

    .line 272
    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownPreScrollRange:I

    .line 273
    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownScrollRange:I

    .line 274
    return-void
.end method

.method private setCollapsibleState(Z)Z
    .locals 1
    .param p1, "collapsible"    # Z

    .line 536
    iget-boolean v0, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsible:Z

    if-eq v0, p1, :cond_0

    .line 537
    iput-boolean p1, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsible:Z

    .line 538
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->refreshDrawableState()V

    .line 539
    const/4 v0, 0x1

    return v0

    .line 541
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method private setExpanded(ZZZ)V
    .locals 3
    .param p1, "expanded"    # Z
    .param p2, "animate"    # Z
    .param p3, "force"    # Z

    .line 318
    if-eqz p1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x2

    :goto_0
    const/4 v1, 0x0

    if-eqz p2, :cond_1

    const/4 v2, 0x4

    goto :goto_1

    :cond_1
    move v2, v1

    :goto_1
    or-int/2addr v0, v2

    if-eqz p3, :cond_2

    const/16 v1, 0x8

    nop

    :cond_2
    or-int/2addr v0, v1

    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mPendingAction:I

    .line 321
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->requestLayout()V

    .line 322
    return-void
.end method

.method private updateCollapsible()V
    .locals 4

    .line 259
    const/4 v0, 0x0

    .line 260
    .local v0, "haveCollapsibleChild":Z
    const/4 v1, 0x0

    .line 260
    .local v1, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 260
    .local v2, "z":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 261
    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    invoke-virtual {v3}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->isCollapsible()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 262
    const/4 v0, 0x1

    .line 263
    goto :goto_1

    .line 260
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 266
    .end local v1    # "i":I
    .end local v2    # "z":I
    :cond_1
    :goto_1
    invoke-direct {p0, v0}, Landroid/support/design/widget/AppBarLayout;->setCollapsibleState(Z)Z

    .line 267
    return-void
.end method


# virtual methods
.method public addOnOffsetChangedListener(Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;

    .line 213
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    if-nez v0, :cond_0

    .line 214
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    .line 216
    :cond_0
    if-eqz p1, :cond_1

    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 217
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 219
    :cond_1
    return-void
.end method

.method protected checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 326
    instance-of v0, p1, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    return v0
.end method

.method dispatchOffsetUpdates(I)V
    .locals 3
    .param p1, "offset"    # I

    .line 481
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    if-eqz v0, :cond_1

    .line 482
    const/4 v0, 0x0

    .line 482
    .local v0, "i":I
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    .line 482
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_1

    .line 483
    iget-object v2, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;

    .line 484
    .local v2, "listener":Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;
    if-eqz v2, :cond_0

    .line 485
    invoke-interface {v2, p0, p1}, Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;->onOffsetChanged(Landroid/support/design/widget/AppBarLayout;I)V

    .line 482
    .end local v2    # "listener":Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 489
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_1
    return-void
.end method

.method protected generateDefaultLayoutParams()Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .locals 3

    .line 331
    new-instance v0, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    const/4 v1, -0x1

    const/4 v2, -0x2

    invoke-direct {v0, v1, v2}, Landroid/support/design/widget/AppBarLayout$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method protected bridge synthetic generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    .locals 1

    .line 106
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->generateDefaultLayoutParams()Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method protected bridge synthetic generateDefaultLayoutParams()Landroid/widget/LinearLayout$LayoutParams;
    .locals 1

    .line 106
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->generateDefaultLayoutParams()Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method public generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .locals 2
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 336
    new-instance v0, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/support/design/widget/AppBarLayout$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method protected generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .locals 2
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 341
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x13

    if-lt v0, v1, :cond_0

    instance-of v0, p1, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v0, :cond_0

    .line 342
    new-instance v0, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-object v1, p1

    check-cast v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v1}, Landroid/support/design/widget/AppBarLayout$LayoutParams;-><init>(Landroid/widget/LinearLayout$LayoutParams;)V

    return-object v0

    .line 343
    :cond_0
    instance-of v0, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v0, :cond_1

    .line 344
    new-instance v0, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-object v1, p1

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    invoke-direct {v0, v1}, Landroid/support/design/widget/AppBarLayout$LayoutParams;-><init>(Landroid/view/ViewGroup$MarginLayoutParams;)V

    return-object v0

    .line 346
    :cond_1
    new-instance v0, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    invoke-direct {v0, p1}, Landroid/support/design/widget/AppBarLayout$LayoutParams;-><init>(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public bridge synthetic generateLayoutParams(Landroid/util/AttributeSet;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 106
    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout;->generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method protected bridge synthetic generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 106
    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout;->generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method public bridge synthetic generateLayoutParams(Landroid/util/AttributeSet;)Landroid/widget/LinearLayout$LayoutParams;
    .locals 0

    .line 106
    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout;->generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method protected bridge synthetic generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/widget/LinearLayout$LayoutParams;
    .locals 0

    .line 106
    invoke-virtual {p0, p1}, Landroid/support/design/widget/AppBarLayout;->generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/design/widget/AppBarLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method getDownNestedPreScrollRange()I
    .locals 8

    .line 405
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownPreScrollRange:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 407
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownPreScrollRange:I

    return v0

    .line 410
    :cond_0
    const/4 v0, 0x0

    .line 411
    .local v0, "range":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    .line 411
    .local v1, "i":I
    :goto_0
    if-ltz v1, :cond_5

    .line 412
    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 413
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 414
    .local v3, "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v2}, Landroid/view/View;->getMeasuredHeight()I

    move-result v4

    .line 415
    .local v4, "childHeight":I
    iget v5, v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;->mScrollFlags:I

    .line 417
    .local v5, "flags":I
    and-int/lit8 v6, v5, 0x5

    const/4 v7, 0x5

    if-ne v6, v7, :cond_3

    .line 419
    iget v6, v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;->topMargin:I

    iget v7, v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;->bottomMargin:I

    add-int/2addr v6, v7

    add-int/2addr v0, v6

    .line 421
    and-int/lit8 v6, v5, 0x8

    if-eqz v6, :cond_1

    .line 423
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v6

    add-int/2addr v0, v6

    goto :goto_1

    .line 424
    :cond_1
    and-int/lit8 v6, v5, 0x2

    if-eqz v6, :cond_2

    .line 426
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v6

    sub-int v6, v4, v6

    add-int/2addr v0, v6

    goto :goto_1

    .line 429
    :cond_2
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v6

    sub-int v6, v4, v6

    add-int/2addr v0, v6

    goto :goto_1

    .line 431
    :cond_3
    if-lez v0, :cond_4

    .line 434
    goto :goto_2

    .line 411
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v4    # "childHeight":I
    .end local v5    # "flags":I
    :cond_4
    :goto_1
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 437
    .end local v1    # "i":I
    :cond_5
    :goto_2
    const/4 v1, 0x0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v1

    iput v1, p0, Landroid/support/design/widget/AppBarLayout;->mDownPreScrollRange:I

    return v1
.end method

.method getDownNestedScrollRange()I
    .locals 9

    .line 444
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownScrollRange:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 446
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mDownScrollRange:I

    return v0

    .line 449
    :cond_0
    const/4 v0, 0x0

    .line 450
    .local v0, "range":I
    const/4 v1, 0x0

    .line 450
    .local v1, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 450
    .local v2, "z":I
    :goto_0
    if-ge v1, v2, :cond_2

    .line 451
    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 452
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 453
    .local v4, "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/view/View;->getMeasuredHeight()I

    move-result v5

    .line 454
    .local v5, "childHeight":I
    iget v6, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->topMargin:I

    iget v7, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->bottomMargin:I

    add-int/2addr v6, v7

    add-int/2addr v5, v6

    .line 456
    iget v6, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->mScrollFlags:I

    .line 458
    .local v6, "flags":I
    and-int/lit8 v7, v6, 0x1

    if-eqz v7, :cond_2

    .line 460
    add-int/2addr v0, v5

    .line 462
    and-int/lit8 v7, v6, 0x2

    if-eqz v7, :cond_1

    .line 466
    invoke-static {v3}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v7

    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v8

    add-int/2addr v7, v8

    sub-int/2addr v0, v7

    .line 467
    goto :goto_1

    .line 450
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v5    # "childHeight":I
    .end local v6    # "flags":I
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 475
    .end local v1    # "i":I
    .end local v2    # "z":I
    :cond_2
    :goto_1
    const/4 v1, 0x0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v1

    iput v1, p0, Landroid/support/design/widget/AppBarLayout;->mDownScrollRange:I

    return v1
.end method

.method final getMinimumHeightForVisibleOverlappingContent()I
    .locals 5

    .line 492
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v0

    .line 493
    .local v0, "topInset":I
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v1

    .line 494
    .local v1, "minHeight":I
    if-eqz v1, :cond_0

    .line 496
    mul-int/lit8 v2, v1, 0x2

    add-int/2addr v2, v0

    return v2

    .line 500
    :cond_0
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 501
    .local v2, "childCount":I
    const/4 v3, 0x1

    if-lt v2, v3, :cond_1

    add-int/lit8 v3, v2, -0x1

    .line 502
    invoke-virtual {p0, v3}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-static {v3}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v3

    goto :goto_0

    :cond_1
    const/4 v3, 0x0

    .line 503
    .local v3, "lastChildMinHeight":I
    :goto_0
    if-eqz v3, :cond_2

    .line 504
    mul-int/lit8 v4, v3, 0x2

    add-int/2addr v4, v0

    return v4

    .line 509
    :cond_2
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getHeight()I

    move-result v4

    div-int/lit8 v4, v4, 0x3

    return v4
.end method

.method getPendingAction()I
    .locals 1

    .line 584
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mPendingAction:I

    return v0
.end method

.method public getTargetElevation()F
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 580
    const/4 v0, 0x0

    return v0
.end method

.method final getTopInset()I
    .locals 1
    .annotation build Landroid/support/annotation/VisibleForTesting;
    .end annotation

    .line 593
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v0}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetTop()I

    move-result v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public final getTotalScrollRange()I
    .locals 9

    .line 359
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mTotalScrollRange:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 360
    iget v0, p0, Landroid/support/design/widget/AppBarLayout;->mTotalScrollRange:I

    return v0

    .line 363
    :cond_0
    const/4 v0, 0x0

    .line 364
    .local v0, "range":I
    const/4 v1, 0x0

    .line 364
    .local v1, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v2

    .line 364
    .local v2, "z":I
    :goto_0
    if-ge v1, v2, :cond_2

    .line 365
    invoke-virtual {p0, v1}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 366
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 367
    .local v4, "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/view/View;->getMeasuredHeight()I

    move-result v5

    .line 368
    .local v5, "childHeight":I
    iget v6, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->mScrollFlags:I

    .line 370
    .local v6, "flags":I
    and-int/lit8 v7, v6, 0x1

    if-eqz v7, :cond_2

    .line 372
    iget v7, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->topMargin:I

    add-int/2addr v7, v5

    iget v8, v4, Landroid/support/design/widget/AppBarLayout$LayoutParams;->bottomMargin:I

    add-int/2addr v7, v8

    add-int/2addr v0, v7

    .line 374
    and-int/lit8 v7, v6, 0x2

    if-eqz v7, :cond_1

    .line 378
    invoke-static {v3}, Landroid/support/v4/view/ViewCompat;->getMinimumHeight(Landroid/view/View;)I

    move-result v7

    sub-int/2addr v0, v7

    .line 379
    goto :goto_1

    .line 364
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "lp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v5    # "childHeight":I
    .end local v6    # "flags":I
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 387
    .end local v1    # "i":I
    .end local v2    # "z":I
    :cond_2
    :goto_1
    const/4 v1, 0x0

    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTopInset()I

    move-result v2

    sub-int v2, v0, v2

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    iput v1, p0, Landroid/support/design/widget/AppBarLayout;->mTotalScrollRange:I

    return v1
.end method

.method getUpNestedPreScrollRange()I
    .locals 1

    .line 398
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v0

    return v0
.end method

.method hasChildWithInterpolator()Z
    .locals 1

    .line 350
    iget-boolean v0, p0, Landroid/support/design/widget/AppBarLayout;->mHaveChildWithInterpolator:Z

    return v0
.end method

.method hasScrollableChildren()Z
    .locals 1

    .line 391
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getTotalScrollRange()I

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method protected onCreateDrawableState(I)[I
    .locals 4
    .param p1, "extraSpace"    # I

    .line 514
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mTmpStatesArray:[I

    if-nez v0, :cond_0

    .line 518
    const/4 v0, 0x2

    new-array v0, v0, [I

    iput-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mTmpStatesArray:[I

    .line 520
    :cond_0
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mTmpStatesArray:[I

    .line 521
    .local v0, "extraStates":[I
    array-length v1, v0

    add-int/2addr v1, p1

    invoke-super {p0, v1}, Landroid/widget/LinearLayout;->onCreateDrawableState(I)[I

    move-result-object v1

    .line 523
    .local v1, "states":[I
    const/4 v2, 0x0

    iget-boolean v3, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsible:Z

    if-eqz v3, :cond_1

    sget v3, Landroid/support/design/R$attr;->state_collapsible:I

    goto :goto_0

    :cond_1
    sget v3, Landroid/support/design/R$attr;->state_collapsible:I

    neg-int v3, v3

    :goto_0
    aput v3, v0, v2

    .line 524
    const/4 v2, 0x1

    iget-boolean v3, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsible:Z

    if-eqz v3, :cond_2

    iget-boolean v3, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsed:Z

    if-eqz v3, :cond_2

    sget v3, Landroid/support/design/R$attr;->state_collapsed:I

    goto :goto_1

    :cond_2
    sget v3, Landroid/support/design/R$attr;->state_collapsed:I

    neg-int v3, v3

    :goto_1
    aput v3, v0, v2

    .line 527
    invoke-static {v1, v0}, Landroid/support/design/widget/AppBarLayout;->mergeDrawableStates([I[I)[I

    move-result-object v2

    return-object v2
.end method

.method protected onLayout(ZIIII)V
    .locals 6
    .param p1, "changed"    # Z
    .param p2, "l"    # I
    .param p3, "t"    # I
    .param p4, "r"    # I
    .param p5, "b"    # I

    .line 240
    invoke-super/range {p0 .. p5}, Landroid/widget/LinearLayout;->onLayout(ZIIII)V

    .line 241
    invoke-direct {p0}, Landroid/support/design/widget/AppBarLayout;->invalidateScrollRanges()V

    .line 243
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/design/widget/AppBarLayout;->mHaveChildWithInterpolator:Z

    .line 244
    const/4 v0, 0x0

    .line 244
    .local v0, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->getChildCount()I

    move-result v1

    .line 244
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_1

    .line 245
    invoke-virtual {p0, v0}, Landroid/support/design/widget/AppBarLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 246
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/AppBarLayout$LayoutParams;

    .line 247
    .local v3, "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/support/design/widget/AppBarLayout$LayoutParams;->getScrollInterpolator()Landroid/view/animation/Interpolator;

    move-result-object v4

    .line 249
    .local v4, "interpolator":Landroid/view/animation/Interpolator;
    if-eqz v4, :cond_0

    .line 250
    const/4 v5, 0x1

    iput-boolean v5, p0, Landroid/support/design/widget/AppBarLayout;->mHaveChildWithInterpolator:Z

    .line 251
    goto :goto_1

    .line 244
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "childLp":Landroid/support/design/widget/AppBarLayout$LayoutParams;
    .end local v4    # "interpolator":Landroid/view/animation/Interpolator;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 255
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_1
    :goto_1
    invoke-direct {p0}, Landroid/support/design/widget/AppBarLayout;->updateCollapsible()V

    .line 256
    return-void
.end method

.method protected onMeasure(II)V
    .locals 0
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 234
    invoke-super {p0, p1, p2}, Landroid/widget/LinearLayout;->onMeasure(II)V

    .line 235
    invoke-direct {p0}, Landroid/support/design/widget/AppBarLayout;->invalidateScrollRanges()V

    .line 236
    return-void
.end method

.method onWindowInsetChanged(Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;
    .locals 2
    .param p1, "insets"    # Landroid/support/v4/view/WindowInsetsCompat;

    .line 597
    const/4 v0, 0x0

    .line 599
    .local v0, "newInsets":Landroid/support/v4/view/WindowInsetsCompat;
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 601
    move-object v0, p1

    .line 605
    :cond_0
    iget-object v1, p0, Landroid/support/design/widget/AppBarLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-static {v1, v0}, Landroid/support/v4/util/ObjectsCompat;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 606
    iput-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    .line 607
    invoke-direct {p0}, Landroid/support/design/widget/AppBarLayout;->invalidateScrollRanges()V

    .line 610
    :cond_1
    return-object p1
.end method

.method public removeOnOffsetChangedListener(Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;)V
    .locals 1
    .param p1, "listener"    # Landroid/support/design/widget/AppBarLayout$OnOffsetChangedListener;

    .line 227
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    if-eqz v0, :cond_0

    if-eqz p1, :cond_0

    .line 228
    iget-object v0, p0, Landroid/support/design/widget/AppBarLayout;->mListeners:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 230
    :cond_0
    return-void
.end method

.method resetPendingAction()V
    .locals 1

    .line 588
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/design/widget/AppBarLayout;->mPendingAction:I

    .line 589
    return-void
.end method

.method setCollapsedState(Z)Z
    .locals 1
    .param p1, "collapsed"    # Z

    .line 550
    iget-boolean v0, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsed:Z

    if-eq v0, p1, :cond_0

    .line 551
    iput-boolean p1, p0, Landroid/support/design/widget/AppBarLayout;->mCollapsed:Z

    .line 552
    invoke-virtual {p0}, Landroid/support/design/widget/AppBarLayout;->refreshDrawableState()V

    .line 553
    const/4 v0, 0x1

    return v0

    .line 555
    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public setExpanded(Z)V
    .locals 1
    .param p1, "expanded"    # Z

    .line 298
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->isLaidOut(Landroid/view/View;)Z

    move-result v0

    invoke-virtual {p0, p1, v0}, Landroid/support/design/widget/AppBarLayout;->setExpanded(ZZ)V

    .line 299
    return-void
.end method

.method public setExpanded(ZZ)V
    .locals 1
    .param p1, "expanded"    # Z
    .param p2, "animate"    # Z

    .line 314
    const/4 v0, 0x1

    invoke-direct {p0, p1, p2, v0}, Landroid/support/design/widget/AppBarLayout;->setExpanded(ZZZ)V

    .line 315
    return-void
.end method

.method public setOrientation(I)V
    .locals 2
    .param p1, "orientation"    # I

    .line 278
    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    .line 279
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "AppBarLayout is always vertical and does not support horizontal orientation"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 282
    :cond_0
    invoke-super {p0, p1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 283
    return-void
.end method

.method public setTargetElevation(F)V
    .locals 2
    .param p1, "elevation"    # F
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 568
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_0

    .line 569
    invoke-static {p0, p1}, Landroid/support/design/widget/ViewUtilsLollipop;->setDefaultAppBarLayoutStateListAnimator(Landroid/view/View;F)V

    .line 571
    :cond_0
    return-void
.end method
