.class public Landroid/support/design/internal/BottomNavigationMenuView;
.super Landroid/view/ViewGroup;
.source "BottomNavigationMenuView.java"

# interfaces
.implements Landroid/support/v7/view/menu/MenuView;


# annotations
.annotation build Landroid/support/annotation/RestrictTo;
    value = {
        .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
    }
.end annotation


# static fields
.field private static final ACTIVE_ANIMATION_DURATION_MS:J = 0x73L


# instance fields
.field private final mActiveItemMaxWidth:I

.field private mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

.field private final mInactiveItemMaxWidth:I

.field private final mInactiveItemMinWidth:I

.field private mItemBackgroundRes:I

.field private final mItemHeight:I

.field private mItemIconTint:Landroid/content/res/ColorStateList;

.field private final mItemPool:Landroid/support/v4/util/Pools$Pool;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/support/v4/util/Pools$Pool<",
            "Landroid/support/design/internal/BottomNavigationItemView;",
            ">;"
        }
    .end annotation
.end field

.field private mItemTextColor:Landroid/content/res/ColorStateList;

.field private mMenu:Landroid/support/v7/view/menu/MenuBuilder;

.field private final mOnClickListener:Landroid/view/View$OnClickListener;

.field private mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

.field private mSelectedItemId:I

.field private mSelectedItemPosition:I

.field private final mSet:Landroid/support/transition/TransitionSet;

.field private mShiftingMode:Z

.field private mTempChildWidths:[I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 70
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Landroid/support/design/internal/BottomNavigationMenuView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 71
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 5
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 74
    invoke-direct {p0, p1, p2}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 54
    new-instance v0, Landroid/support/v4/util/Pools$SynchronizedPool;

    const/4 v1, 0x5

    invoke-direct {v0, v1}, Landroid/support/v4/util/Pools$SynchronizedPool;-><init>(I)V

    iput-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemPool:Landroid/support/v4/util/Pools$Pool;

    .line 56
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mShiftingMode:Z

    .line 59
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    .line 60
    iput v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    .line 75
    invoke-virtual {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    .line 76
    .local v2, "res":Landroid/content/res/Resources;
    sget v3, Landroid/support/design/R$dimen;->design_bottom_navigation_item_max_width:I

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mInactiveItemMaxWidth:I

    .line 78
    sget v3, Landroid/support/design/R$dimen;->design_bottom_navigation_item_min_width:I

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mInactiveItemMinWidth:I

    .line 80
    sget v3, Landroid/support/design/R$dimen;->design_bottom_navigation_active_item_max_width:I

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mActiveItemMaxWidth:I

    .line 82
    sget v3, Landroid/support/design/R$dimen;->design_bottom_navigation_height:I

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    iput v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemHeight:I

    .line 84
    new-instance v3, Landroid/support/transition/AutoTransition;

    invoke-direct {v3}, Landroid/support/transition/AutoTransition;-><init>()V

    iput-object v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    .line 85
    iget-object v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    invoke-virtual {v3, v0}, Landroid/support/transition/TransitionSet;->setOrdering(I)Landroid/support/transition/TransitionSet;

    .line 86
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    const-wide/16 v3, 0x73

    invoke-virtual {v0, v3, v4}, Landroid/support/transition/TransitionSet;->setDuration(J)Landroid/support/transition/TransitionSet;

    .line 87
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    new-instance v3, Landroid/support/v4/view/animation/FastOutSlowInInterpolator;

    invoke-direct {v3}, Landroid/support/v4/view/animation/FastOutSlowInInterpolator;-><init>()V

    invoke-virtual {v0, v3}, Landroid/support/transition/TransitionSet;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/support/transition/TransitionSet;

    .line 88
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    new-instance v3, Landroid/support/design/internal/TextScale;

    invoke-direct {v3}, Landroid/support/design/internal/TextScale;-><init>()V

    invoke-virtual {v0, v3}, Landroid/support/transition/TransitionSet;->addTransition(Landroid/support/transition/Transition;)Landroid/support/transition/TransitionSet;

    .line 90
    new-instance v0, Landroid/support/design/internal/BottomNavigationMenuView$1;

    invoke-direct {v0, p0}, Landroid/support/design/internal/BottomNavigationMenuView$1;-><init>(Landroid/support/design/internal/BottomNavigationMenuView;)V

    iput-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mOnClickListener:Landroid/view/View$OnClickListener;

    .line 100
    new-array v0, v1, [I

    iput-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    .line 101
    return-void
.end method

.method static synthetic access$000(Landroid/support/design/internal/BottomNavigationMenuView;)Landroid/support/design/internal/BottomNavigationPresenter;
    .locals 1
    .param p0, "x0"    # Landroid/support/design/internal/BottomNavigationMenuView;

    .line 45
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    return-object v0
.end method

.method static synthetic access$100(Landroid/support/design/internal/BottomNavigationMenuView;)Landroid/support/v7/view/menu/MenuBuilder;
    .locals 1
    .param p0, "x0"    # Landroid/support/design/internal/BottomNavigationMenuView;

    .line 45
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    return-object v0
.end method

.method private getNewItem()Landroid/support/design/internal/BottomNavigationItemView;
    .locals 3

    .line 320
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemPool:Landroid/support/v4/util/Pools$Pool;

    invoke-interface {v0}, Landroid/support/v4/util/Pools$Pool;->acquire()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/design/internal/BottomNavigationItemView;

    .line 321
    .local v0, "item":Landroid/support/design/internal/BottomNavigationItemView;
    if-nez v0, :cond_0

    .line 322
    new-instance v1, Landroid/support/design/internal/BottomNavigationItemView;

    invoke-virtual {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/support/design/internal/BottomNavigationItemView;-><init>(Landroid/content/Context;)V

    move-object v0, v1

    .line 324
    :cond_0
    return-object v0
.end method


# virtual methods
.method public buildMenuView()V
    .locals 6

    .line 257
    invoke-virtual {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->removeAllViews()V

    .line 258
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 259
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v0, v3

    .line 260
    .local v4, "item":Landroid/support/design/internal/BottomNavigationItemView;
    iget-object v5, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemPool:Landroid/support/v4/util/Pools$Pool;

    invoke-interface {v5, v4}, Landroid/support/v4/util/Pools$Pool;->release(Ljava/lang/Object;)Z

    .line 259
    .end local v4    # "item":Landroid/support/design/internal/BottomNavigationItemView;
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 263
    :cond_0
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    if-nez v0, :cond_1

    .line 264
    iput v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    .line 265
    iput v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    .line 266
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    .line 267
    return-void

    .line 269
    :cond_1
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    new-array v0, v0, [Landroid/support/design/internal/BottomNavigationItemView;

    iput-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    .line 270
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    const/4 v2, 0x3

    const/4 v3, 0x1

    if-le v0, v2, :cond_2

    move v0, v3

    goto :goto_1

    :cond_2
    move v0, v1

    :goto_1
    iput-boolean v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mShiftingMode:Z

    .line 271
    move v0, v1

    .line 271
    .local v0, "i":I
    :goto_2
    iget-object v2, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v2}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v2

    if-ge v0, v2, :cond_3

    .line 272
    iget-object v2, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    invoke-virtual {v2, v3}, Landroid/support/design/internal/BottomNavigationPresenter;->setUpdateSuspended(Z)V

    .line 273
    iget-object v2, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v2, v0}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v2

    invoke-interface {v2, v3}, Landroid/view/MenuItem;->setCheckable(Z)Landroid/view/MenuItem;

    .line 274
    iget-object v2, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    invoke-virtual {v2, v1}, Landroid/support/design/internal/BottomNavigationPresenter;->setUpdateSuspended(Z)V

    .line 275
    invoke-direct {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->getNewItem()Landroid/support/design/internal/BottomNavigationItemView;

    move-result-object v2

    .line 276
    .local v2, "child":Landroid/support/design/internal/BottomNavigationItemView;
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    aput-object v2, v4, v0

    .line 277
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemIconTint:Landroid/content/res/ColorStateList;

    invoke-virtual {v2, v4}, Landroid/support/design/internal/BottomNavigationItemView;->setIconTintList(Landroid/content/res/ColorStateList;)V

    .line 278
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemTextColor:Landroid/content/res/ColorStateList;

    invoke-virtual {v2, v4}, Landroid/support/design/internal/BottomNavigationItemView;->setTextColor(Landroid/content/res/ColorStateList;)V

    .line 279
    iget v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemBackgroundRes:I

    invoke-virtual {v2, v4}, Landroid/support/design/internal/BottomNavigationItemView;->setItemBackground(I)V

    .line 280
    iget-boolean v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mShiftingMode:Z

    invoke-virtual {v2, v4}, Landroid/support/design/internal/BottomNavigationItemView;->setShiftingMode(Z)V

    .line 281
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v4, v0}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v4

    check-cast v4, Landroid/support/v7/view/menu/MenuItemImpl;

    invoke-virtual {v2, v4, v1}, Landroid/support/design/internal/BottomNavigationItemView;->initialize(Landroid/support/v7/view/menu/MenuItemImpl;I)V

    .line 282
    invoke-virtual {v2, v0}, Landroid/support/design/internal/BottomNavigationItemView;->setItemPosition(I)V

    .line 283
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mOnClickListener:Landroid/view/View$OnClickListener;

    invoke-virtual {v2, v4}, Landroid/support/design/internal/BottomNavigationItemView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 284
    invoke-virtual {p0, v2}, Landroid/support/design/internal/BottomNavigationMenuView;->addView(Landroid/view/View;)V

    .line 271
    .end local v2    # "child":Landroid/support/design/internal/BottomNavigationItemView;
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 286
    .end local v0    # "i":I
    :cond_3
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    sub-int/2addr v0, v3

    iget v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v0

    iput v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    .line 287
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    iget v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    invoke-virtual {v0, v1}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v0

    invoke-interface {v0, v3}, Landroid/view/MenuItem;->setChecked(Z)Landroid/view/MenuItem;

    .line 288
    return-void
.end method

.method public getIconTintList()Landroid/content/res/ColorStateList;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 205
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemIconTint:Landroid/content/res/ColorStateList;

    return-object v0
.end method

.method public getItemBackgroundRes()I
    .locals 1

    .line 249
    iget v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemBackgroundRes:I

    return v0
.end method

.method public getItemTextColor()Landroid/content/res/ColorStateList;
    .locals 1

    .line 227
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemTextColor:Landroid/content/res/ColorStateList;

    return-object v0
.end method

.method public getSelectedItemId()I
    .locals 1

    .line 328
    iget v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    return v0
.end method

.method public getWindowAnimations()I
    .locals 1

    .line 182
    const/4 v0, 0x0

    return v0
.end method

.method public initialize(Landroid/support/v7/view/menu/MenuBuilder;)V
    .locals 0
    .param p1, "menu"    # Landroid/support/v7/view/menu/MenuBuilder;

    .line 105
    iput-object p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    .line 106
    return-void
.end method

.method protected onLayout(ZIIII)V
    .locals 9
    .param p1, "changed"    # Z
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "right"    # I
    .param p5, "bottom"    # I

    .line 162
    invoke-virtual {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->getChildCount()I

    move-result v0

    .line 163
    .local v0, "count":I
    sub-int v1, p4, p2

    .line 164
    .local v1, "width":I
    sub-int v2, p5, p3

    .line 165
    .local v2, "height":I
    const/4 v3, 0x0

    .line 166
    .local v3, "used":I
    const/4 v4, 0x0

    move v5, v3

    move v3, v4

    .line 166
    .local v3, "i":I
    .local v5, "used":I
    :goto_0
    if-ge v3, v0, :cond_2

    .line 167
    invoke-virtual {p0, v3}, Landroid/support/design/internal/BottomNavigationMenuView;->getChildAt(I)Landroid/view/View;

    move-result-object v6

    .line 168
    .local v6, "child":Landroid/view/View;
    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I

    move-result v7

    const/16 v8, 0x8

    if-ne v7, v8, :cond_0

    .line 169
    goto :goto_2

    .line 171
    :cond_0
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v7

    const/4 v8, 0x1

    if-ne v7, v8, :cond_1

    .line 172
    sub-int v7, v1, v5

    invoke-virtual {v6}, Landroid/view/View;->getMeasuredWidth()I

    move-result v8

    sub-int/2addr v7, v8

    sub-int v8, v1, v5

    invoke-virtual {v6, v7, v4, v8, v2}, Landroid/view/View;->layout(IIII)V

    goto :goto_1

    .line 174
    :cond_1
    invoke-virtual {v6}, Landroid/view/View;->getMeasuredWidth()I

    move-result v7

    add-int/2addr v7, v5

    invoke-virtual {v6, v5, v4, v7, v2}, Landroid/view/View;->layout(IIII)V

    .line 176
    :goto_1
    invoke-virtual {v6}, Landroid/view/View;->getMeasuredWidth()I

    move-result v7

    add-int/2addr v5, v7

    .line 166
    .end local v6    # "child":Landroid/view/View;
    :goto_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 178
    .end local v3    # "i":I
    :cond_2
    return-void
.end method

.method protected onMeasure(II)V
    .locals 16
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v0, p0

    .line 110
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v1

    .line 111
    .local v1, "width":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/internal/BottomNavigationMenuView;->getChildCount()I

    move-result v2

    .line 113
    .local v2, "count":I
    iget v3, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemHeight:I

    const/high16 v4, 0x40000000    # 2.0f

    invoke-static {v3, v4}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v3

    .line 115
    .local v3, "heightSpec":I
    iget-boolean v5, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mShiftingMode:Z

    const/4 v6, 0x0

    const/4 v7, 0x1

    if-eqz v5, :cond_3

    .line 116
    add-int/lit8 v5, v2, -0x1

    .line 117
    .local v5, "inactiveCount":I
    iget v8, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mInactiveItemMinWidth:I

    mul-int/2addr v8, v5

    sub-int v8, v1, v8

    .line 118
    .local v8, "activeMaxAvailable":I
    iget v9, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mActiveItemMaxWidth:I

    invoke-static {v8, v9}, Ljava/lang/Math;->min(II)I

    move-result v9

    .line 119
    .local v9, "activeWidth":I
    sub-int v10, v1, v9

    div-int/2addr v10, v5

    .line 120
    .local v10, "inactiveMaxAvailable":I
    iget v11, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mInactiveItemMaxWidth:I

    invoke-static {v10, v11}, Ljava/lang/Math;->min(II)I

    move-result v11

    .line 121
    .local v11, "inactiveWidth":I
    sub-int v12, v1, v9

    mul-int v13, v11, v5

    sub-int/2addr v12, v13

    .line 122
    .local v12, "extra":I
    move v13, v12

    move v12, v6

    .line 122
    .local v12, "i":I
    .local v13, "extra":I
    :goto_0
    if-ge v12, v2, :cond_2

    .line 123
    iget-object v14, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    iget v15, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    if-ne v12, v15, :cond_0

    move v15, v9

    goto :goto_1

    :cond_0
    move v15, v11

    :goto_1
    aput v15, v14, v12

    .line 124
    if-lez v13, :cond_1

    .line 125
    iget-object v14, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    aget v15, v14, v12

    add-int/2addr v15, v7

    aput v15, v14, v12

    .line 126
    add-int/lit8 v13, v13, -0x1

    .line 122
    :cond_1
    add-int/lit8 v12, v12, 0x1

    goto :goto_0

    .line 129
    .end local v5    # "inactiveCount":I
    .end local v8    # "activeMaxAvailable":I
    .end local v9    # "activeWidth":I
    .end local v10    # "inactiveMaxAvailable":I
    .end local v11    # "inactiveWidth":I
    .end local v12    # "i":I
    .end local v13    # "extra":I
    :cond_2
    goto :goto_4

    .line 130
    :cond_3
    if-nez v2, :cond_4

    move v5, v7

    goto :goto_2

    :cond_4
    move v5, v2

    :goto_2
    div-int v5, v1, v5

    .line 131
    .local v5, "maxAvailable":I
    iget v8, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mActiveItemMaxWidth:I

    invoke-static {v5, v8}, Ljava/lang/Math;->min(II)I

    move-result v8

    .line 132
    .local v8, "childWidth":I
    mul-int v9, v8, v2

    sub-int v9, v1, v9

    .line 133
    .local v9, "extra":I
    move v10, v9

    move v9, v6

    .line 133
    .local v9, "i":I
    .local v10, "extra":I
    :goto_3
    if-ge v9, v2, :cond_6

    .line 134
    iget-object v11, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    aput v8, v11, v9

    .line 135
    if-lez v10, :cond_5

    .line 136
    iget-object v11, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    aget v12, v11, v9

    add-int/2addr v12, v7

    aput v12, v11, v9

    .line 137
    add-int/lit8 v10, v10, -0x1

    .line 133
    :cond_5
    add-int/lit8 v9, v9, 0x1

    goto :goto_3

    .line 142
    .end local v5    # "maxAvailable":I
    .end local v8    # "childWidth":I
    .end local v9    # "i":I
    .end local v10    # "extra":I
    :cond_6
    :goto_4
    const/4 v5, 0x0

    .line 143
    .local v5, "totalWidth":I
    move v7, v5

    move v5, v6

    .line 143
    .local v5, "i":I
    .local v7, "totalWidth":I
    :goto_5
    if-ge v5, v2, :cond_8

    .line 144
    invoke-virtual {v0, v5}, Landroid/support/design/internal/BottomNavigationMenuView;->getChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 145
    .local v8, "child":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getVisibility()I

    move-result v9

    const/16 v10, 0x8

    if-ne v9, v10, :cond_7

    .line 146
    goto :goto_6

    .line 148
    :cond_7
    iget-object v9, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mTempChildWidths:[I

    aget v9, v9, v5

    invoke-static {v9, v4}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v9

    invoke-virtual {v8, v9, v3}, Landroid/view/View;->measure(II)V

    .line 150
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    .line 151
    .local v9, "params":Landroid/view/ViewGroup$LayoutParams;
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v10

    iput v10, v9, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 152
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v10

    add-int/2addr v7, v10

    .line 143
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "params":Landroid/view/ViewGroup$LayoutParams;
    :goto_6
    add-int/lit8 v5, v5, 0x1

    goto :goto_5

    .line 154
    .end local v5    # "i":I
    :cond_8
    nop

    .line 156
    invoke-static {v7, v4}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v4

    .line 155
    invoke-static {v7, v4, v6}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v4

    iget v5, v0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemHeight:I

    .line 157
    invoke-static {v5, v3, v6}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v5

    .line 154
    invoke-virtual {v0, v4, v5}, Landroid/support/design/internal/BottomNavigationMenuView;->setMeasuredDimension(II)V

    .line 158
    return-void
.end method

.method public setIconTintList(Landroid/content/res/ColorStateList;)V
    .locals 4
    .param p1, "tint"    # Landroid/content/res/ColorStateList;

    .line 191
    iput-object p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemIconTint:Landroid/content/res/ColorStateList;

    .line 192
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    if-nez v0, :cond_0

    return-void

    .line 193
    :cond_0
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 194
    .local v3, "item":Landroid/support/design/internal/BottomNavigationItemView;
    invoke-virtual {v3, p1}, Landroid/support/design/internal/BottomNavigationItemView;->setIconTintList(Landroid/content/res/ColorStateList;)V

    .line 193
    .end local v3    # "item":Landroid/support/design/internal/BottomNavigationItemView;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 196
    :cond_1
    return-void
.end method

.method public setItemBackgroundRes(I)V
    .locals 4
    .param p1, "background"    # I

    .line 236
    iput p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemBackgroundRes:I

    .line 237
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    if-nez v0, :cond_0

    return-void

    .line 238
    :cond_0
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 239
    .local v3, "item":Landroid/support/design/internal/BottomNavigationItemView;
    invoke-virtual {v3, p1}, Landroid/support/design/internal/BottomNavigationItemView;->setItemBackground(I)V

    .line 238
    .end local v3    # "item":Landroid/support/design/internal/BottomNavigationItemView;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 241
    :cond_1
    return-void
.end method

.method public setItemTextColor(Landroid/content/res/ColorStateList;)V
    .locals 4
    .param p1, "color"    # Landroid/content/res/ColorStateList;

    .line 214
    iput-object p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mItemTextColor:Landroid/content/res/ColorStateList;

    .line 215
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    if-nez v0, :cond_0

    return-void

    .line 216
    :cond_0
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 217
    .local v3, "item":Landroid/support/design/internal/BottomNavigationItemView;
    invoke-virtual {v3, p1}, Landroid/support/design/internal/BottomNavigationItemView;->setTextColor(Landroid/content/res/ColorStateList;)V

    .line 216
    .end local v3    # "item":Landroid/support/design/internal/BottomNavigationItemView;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 219
    :cond_1
    return-void
.end method

.method public setPresenter(Landroid/support/design/internal/BottomNavigationPresenter;)V
    .locals 0
    .param p1, "presenter"    # Landroid/support/design/internal/BottomNavigationPresenter;

    .line 253
    iput-object p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    .line 254
    return-void
.end method

.method tryRestoreSelectedItemId(I)V
    .locals 4
    .param p1, "itemId"    # I

    .line 332
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    .line 333
    .local v0, "size":I
    const/4 v1, 0x0

    .line 333
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 334
    iget-object v2, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v2, v1}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v2

    .line 335
    .local v2, "item":Landroid/view/MenuItem;
    invoke-interface {v2}, Landroid/view/MenuItem;->getItemId()I

    move-result v3

    if-ne p1, v3, :cond_0

    .line 336
    iput p1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    .line 337
    iput v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    .line 338
    const/4 v3, 0x1

    invoke-interface {v2, v3}, Landroid/view/MenuItem;->setChecked(Z)Landroid/view/MenuItem;

    .line 339
    goto :goto_1

    .line 333
    .end local v2    # "item":Landroid/view/MenuItem;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 342
    .end local v1    # "i":I
    :cond_1
    :goto_1
    return-void
.end method

.method public updateMenuView()V
    .locals 6

    .line 291
    iget-object v0, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v0}, Landroid/support/v7/view/menu/MenuBuilder;->size()I

    move-result v0

    .line 292
    .local v0, "menuSize":I
    iget-object v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    array-length v1, v1

    if-eq v0, v1, :cond_0

    .line 294
    invoke-virtual {p0}, Landroid/support/design/internal/BottomNavigationMenuView;->buildMenuView()V

    .line 295
    return-void

    .line 297
    :cond_0
    iget v1, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    .line 299
    .local v1, "previousSelectedId":I
    const/4 v2, 0x0

    move v3, v2

    .line 299
    .local v3, "i":I
    :goto_0
    if-ge v3, v0, :cond_2

    .line 300
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v4, v3}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v4

    .line 301
    .local v4, "item":Landroid/view/MenuItem;
    invoke-interface {v4}, Landroid/view/MenuItem;->isChecked()Z

    move-result v5

    if-eqz v5, :cond_1

    .line 302
    invoke-interface {v4}, Landroid/view/MenuItem;->getItemId()I

    move-result v5

    iput v5, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    .line 303
    iput v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemPosition:I

    .line 299
    .end local v4    # "item":Landroid/view/MenuItem;
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 306
    .end local v3    # "i":I
    :cond_2
    iget v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSelectedItemId:I

    if-eq v1, v3, :cond_3

    .line 308
    iget-object v3, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mSet:Landroid/support/transition/TransitionSet;

    invoke-static {p0, v3}, Landroid/support/transition/TransitionManager;->beginDelayedTransition(Landroid/view/ViewGroup;Landroid/support/transition/Transition;)V

    .line 311
    :cond_3
    move v3, v2

    .line 311
    .restart local v3    # "i":I
    :goto_1
    if-ge v3, v0, :cond_4

    .line 312
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/support/design/internal/BottomNavigationPresenter;->setUpdateSuspended(Z)V

    .line 313
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mButtons:[Landroid/support/design/internal/BottomNavigationItemView;

    aget-object v4, v4, v3

    iget-object v5, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v5, v3}, Landroid/support/v7/view/menu/MenuBuilder;->getItem(I)Landroid/view/MenuItem;

    move-result-object v5

    check-cast v5, Landroid/support/v7/view/menu/MenuItemImpl;

    invoke-virtual {v4, v5, v2}, Landroid/support/design/internal/BottomNavigationItemView;->initialize(Landroid/support/v7/view/menu/MenuItemImpl;I)V

    .line 314
    iget-object v4, p0, Landroid/support/design/internal/BottomNavigationMenuView;->mPresenter:Landroid/support/design/internal/BottomNavigationPresenter;

    invoke-virtual {v4, v2}, Landroid/support/design/internal/BottomNavigationPresenter;->setUpdateSuspended(Z)V

    .line 311
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 317
    .end local v3    # "i":I
    :cond_4
    return-void
.end method
