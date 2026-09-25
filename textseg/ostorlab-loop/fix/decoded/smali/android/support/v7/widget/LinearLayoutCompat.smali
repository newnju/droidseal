.class public Landroid/support/v7/widget/LinearLayoutCompat;
.super Landroid/view/ViewGroup;
.source "LinearLayoutCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;,
        Landroid/support/v7/widget/LinearLayoutCompat$DividerMode;,
        Landroid/support/v7/widget/LinearLayoutCompat$OrientationMode;
    }
.end annotation


# static fields
.field public static final HORIZONTAL:I = 0x0

.field private static final INDEX_BOTTOM:I = 0x2

.field private static final INDEX_CENTER_VERTICAL:I = 0x0

.field private static final INDEX_FILL:I = 0x3

.field private static final INDEX_TOP:I = 0x1

.field public static final SHOW_DIVIDER_BEGINNING:I = 0x1

.field public static final SHOW_DIVIDER_END:I = 0x4

.field public static final SHOW_DIVIDER_MIDDLE:I = 0x2

.field public static final SHOW_DIVIDER_NONE:I = 0x0

.field public static final VERTICAL:I = 0x1

.field private static final VERTICAL_GRAVITY_COUNT:I = 0x4


# instance fields
.field private mBaselineAligned:Z

.field private mBaselineAlignedChildIndex:I

.field private mBaselineChildTop:I

.field private mDivider:Landroid/graphics/drawable/Drawable;

.field private mDividerHeight:I

.field private mDividerPadding:I

.field private mDividerWidth:I

.field private mGravity:I

.field private mMaxAscent:[I

.field private mMaxDescent:[I

.field private mOrientation:I

.field private mShowDividers:I

.field private mTotalLength:I

.field private mUseLargestChild:Z

.field private mWeightSum:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 145
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/LinearLayoutCompat;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 146
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 149
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Landroid/support/v7/widget/LinearLayoutCompat;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 150
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 7
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .line 153
    invoke-direct {p0, p1, p2, p3}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 100
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAligned:Z

    .line 109
    const/4 v1, -0x1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    .line 116
    const/4 v2, 0x0

    iput v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineChildTop:I

    .line 120
    const v3, 0x800033

    iput v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    .line 155
    sget-object v3, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat:[I

    invoke-static {p1, p2, v3, p3, v2}, Landroid/support/v7/widget/TintTypedArray;->obtainStyledAttributes(Landroid/content/Context;Landroid/util/AttributeSet;[III)Landroid/support/v7/widget/TintTypedArray;

    move-result-object v3

    .line 158
    .local v3, "a":Landroid/support/v7/widget/TintTypedArray;
    sget v4, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_android_orientation:I

    invoke-virtual {v3, v4, v1}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v4

    .line 159
    .local v4, "index":I
    if-ltz v4, :cond_0

    .line 160
    invoke-virtual {p0, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->setOrientation(I)V

    .line 163
    :cond_0
    sget v5, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_android_gravity:I

    invoke-virtual {v3, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v4

    .line 164
    if-ltz v4, :cond_1

    .line 165
    invoke-virtual {p0, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->setGravity(I)V

    .line 168
    :cond_1
    sget v5, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_android_baselineAligned:I

    invoke-virtual {v3, v5, v0}, Landroid/support/v7/widget/TintTypedArray;->getBoolean(IZ)Z

    move-result v0

    .line 169
    .local v0, "baselineAligned":Z
    if-nez v0, :cond_2

    .line 170
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->setBaselineAligned(Z)V

    .line 173
    :cond_2
    sget v5, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_android_weightSum:I

    const/high16 v6, -0x40800000    # -1.0f

    invoke-virtual {v3, v5, v6}, Landroid/support/v7/widget/TintTypedArray;->getFloat(IF)F

    move-result v5

    iput v5, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    .line 175
    sget v5, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_android_baselineAlignedChildIndex:I

    .line 176
    invoke-virtual {v3, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    .line 178
    sget v1, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_measureWithLargestChild:I

    invoke-virtual {v3, v1, v2}, Landroid/support/v7/widget/TintTypedArray;->getBoolean(IZ)Z

    move-result v1

    iput-boolean v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mUseLargestChild:Z

    .line 180
    sget v1, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_divider:I

    invoke-virtual {v3, v1}, Landroid/support/v7/widget/TintTypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->setDividerDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 181
    sget v1, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_showDividers:I

    invoke-virtual {v3, v1, v2}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    .line 182
    sget v1, Landroid/support/v7/appcompat/R$styleable;->LinearLayoutCompat_dividerPadding:I

    invoke-virtual {v3, v1, v2}, Landroid/support/v7/widget/TintTypedArray;->getDimensionPixelSize(II)I

    move-result v1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    .line 184
    invoke-virtual {v3}, Landroid/support/v7/widget/TintTypedArray;->recycle()V

    .line 185
    return-void
.end method

.method private forceUniformHeight(II)V
    .locals 11
    .param p1, "count"    # I
    .param p2, "widthMeasureSpec"    # I

    .line 1316
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getMeasuredHeight()I

    move-result v0

    const/high16 v1, 0x40000000    # 2.0f

    invoke-static {v0, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v0

    .line 1318
    .local v0, "uniformMeasureSpec":I
    const/4 v1, 0x0

    .line 1318
    .local v1, "i":I
    :goto_0
    if-ge v1, p1, :cond_1

    .line 1319
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 1320
    .local v8, "child":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getVisibility()I

    move-result v2

    const/16 v3, 0x8

    if-eq v2, v3, :cond_0

    .line 1321
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    move-object v9, v2

    check-cast v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1323
    .local v9, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v2, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    const/4 v3, -0x1

    if-ne v2, v3, :cond_0

    .line 1326
    iget v10, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    .line 1327
    .local v10, "oldWidth":I
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    iput v2, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    .line 1330
    const/4 v5, 0x0

    const/4 v7, 0x0

    move-object v2, p0

    move-object v3, v8

    move v4, p2

    move v6, v0

    invoke-virtual/range {v2 .. v7}, Landroid/support/v7/widget/LinearLayoutCompat;->measureChildWithMargins(Landroid/view/View;IIII)V

    .line 1331
    iput v10, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    .line 1318
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v10    # "oldWidth":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1335
    .end local v1    # "i":I
    :cond_1
    return-void
.end method

.method private forceUniformWidth(II)V
    .locals 11
    .param p1, "count"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 894
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getMeasuredWidth()I

    move-result v0

    const/high16 v1, 0x40000000    # 2.0f

    invoke-static {v0, v1}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v0

    .line 896
    .local v0, "uniformMeasureSpec":I
    const/4 v1, 0x0

    .line 896
    .local v1, "i":I
    :goto_0
    if-ge v1, p1, :cond_1

    .line 897
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 898
    .local v8, "child":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getVisibility()I

    move-result v2

    const/16 v3, 0x8

    if-eq v2, v3, :cond_0

    .line 899
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    move-object v9, v2

    check-cast v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 901
    .local v9, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v2, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    const/4 v3, -0x1

    if-ne v2, v3, :cond_0

    .line 904
    iget v10, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 905
    .local v10, "oldHeight":I
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    iput v2, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 908
    const/4 v5, 0x0

    const/4 v7, 0x0

    move-object v2, p0

    move-object v3, v8

    move v4, v0

    move v6, p2

    invoke-virtual/range {v2 .. v7}, Landroid/support/v7/widget/LinearLayoutCompat;->measureChildWithMargins(Landroid/view/View;IIII)V

    .line 909
    iput v10, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 896
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v10    # "oldHeight":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 913
    .end local v1    # "i":I
    :cond_1
    return-void
.end method

.method private setChildFrame(Landroid/view/View;IIII)V
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "width"    # I
    .param p5, "height"    # I

    .line 1644
    add-int v0, p2, p4

    add-int v1, p3, p5

    invoke-virtual {p1, p2, p3, v0, v1}, Landroid/view/View;->layout(IIII)V

    .line 1645
    return-void
.end method


# virtual methods
.method protected checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1750
    instance-of v0, p1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    return v0
.end method

.method drawDividersHorizontal(Landroid/graphics/Canvas;)V
    .locals 7
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .line 322
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v0

    .line 323
    .local v0, "count":I
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v1

    .line 324
    .local v1, "isLayoutRtl":Z
    const/4 v2, 0x0

    .line 324
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_2

    .line 325
    invoke-virtual {p0, v2}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 327
    .local v3, "child":Landroid/view/View;
    if-eqz v3, :cond_1

    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    const/16 v5, 0x8

    if-eq v4, v5, :cond_1

    .line 328
    invoke-virtual {p0, v2}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 329
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 331
    .local v4, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    if-eqz v1, :cond_0

    .line 332
    invoke-virtual {v3}, Landroid/view/View;->getRight()I

    move-result v5

    iget v6, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v5, v6

    .line 332
    .local v5, "position":I
    goto :goto_1

    .line 334
    .end local v5    # "position":I
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getLeft()I

    move-result v5

    iget v6, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    sub-int/2addr v5, v6

    iget v6, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    sub-int/2addr v5, v6

    .line 336
    .restart local v5    # "position":I
    :goto_1
    invoke-virtual {p0, p1, v5}, Landroid/support/v7/widget/LinearLayoutCompat;->drawVerticalDivider(Landroid/graphics/Canvas;I)V

    .line 324
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v5    # "position":I
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 341
    .end local v2    # "i":I
    :cond_2
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v2

    if-eqz v2, :cond_6

    .line 342
    add-int/lit8 v2, v0, -0x1

    invoke-virtual {p0, v2}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 344
    .local v2, "child":Landroid/view/View;
    if-nez v2, :cond_4

    .line 345
    if-eqz v1, :cond_3

    .line 346
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v3

    .line 346
    .local v3, "position":I
    :goto_2
    goto :goto_3

    .line 348
    .end local v3    # "position":I
    :cond_3
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getWidth()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v4

    sub-int/2addr v3, v4

    iget v4, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    sub-int/2addr v3, v4

    goto :goto_2

    .line 351
    :cond_4
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 352
    .local v3, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    if-eqz v1, :cond_5

    .line 353
    invoke-virtual {v2}, Landroid/view/View;->getLeft()I

    move-result v4

    iget v5, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    sub-int/2addr v4, v5

    iget v5, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    sub-int/2addr v4, v5

    .line 355
    .local v4, "position":I
    move v3, v4

    goto :goto_3

    .line 355
    .end local v4    # "position":I
    :cond_5
    invoke-virtual {v2}, Landroid/view/View;->getRight()I

    move-result v4

    iget v5, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int v3, v4, v5

    .line 358
    .local v3, "position":I
    :goto_3
    invoke-virtual {p0, p1, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->drawVerticalDivider(Landroid/graphics/Canvas;I)V

    .line 360
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "position":I
    :cond_6
    return-void
.end method

.method drawDividersVertical(Landroid/graphics/Canvas;)V
    .locals 6
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .line 295
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v0

    .line 296
    .local v0, "count":I
    const/4 v1, 0x0

    .line 296
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 297
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 299
    .local v2, "child":Landroid/view/View;
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-eq v3, v4, :cond_0

    .line 300
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 301
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 302
    .local v3, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    invoke-virtual {v2}, Landroid/view/View;->getTop()I

    move-result v4

    iget v5, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    sub-int/2addr v4, v5

    iget v5, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    sub-int/2addr v4, v5

    .line 303
    .local v4, "top":I
    invoke-virtual {p0, p1, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->drawHorizontalDivider(Landroid/graphics/Canvas;I)V

    .line 296
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v4    # "top":I
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 308
    .end local v1    # "i":I
    :cond_1
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 309
    add-int/lit8 v1, v0, -0x1

    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 310
    .local v1, "child":Landroid/view/View;
    const/4 v2, 0x0

    .line 311
    .local v2, "bottom":I
    if-nez v1, :cond_2

    .line 312
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    iget v4, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    sub-int/2addr v3, v4

    .line 312
    .end local v2    # "bottom":I
    .local v3, "bottom":I
    goto :goto_1

    .line 314
    .end local v3    # "bottom":I
    .restart local v2    # "bottom":I
    :cond_2
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 315
    .local v3, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    invoke-virtual {v1}, Landroid/view/View;->getBottom()I

    move-result v4

    iget v5, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int v3, v4, v5

    .line 317
    .end local v2    # "bottom":I
    .local v3, "bottom":I
    :goto_1
    invoke-virtual {p0, p1, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->drawHorizontalDivider(Landroid/graphics/Canvas;I)V

    .line 319
    .end local v1    # "child":Landroid/view/View;
    .end local v3    # "bottom":I
    :cond_3
    return-void
.end method

.method drawHorizontalDivider(Landroid/graphics/Canvas;I)V
    .locals 4
    .param p1, "canvas"    # Landroid/graphics/Canvas;
    .param p2, "top"    # I

    .line 363
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v1

    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    add-int/2addr v1, v2

    .line 364
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getWidth()I

    move-result v2

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v3

    sub-int/2addr v2, v3

    iget v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    sub-int/2addr v2, v3

    iget v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    add-int/2addr v3, p2

    .line 363
    invoke-virtual {v0, v1, p2, v2, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 365
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 366
    return-void
.end method

.method drawVerticalDivider(Landroid/graphics/Canvas;I)V
    .locals 5
    .param p1, "canvas"    # Landroid/graphics/Canvas;
    .param p2, "left"    # I

    .line 369
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v1

    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    add-int/2addr v1, v2

    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    add-int/2addr v2, p2

    .line 370
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    iget v4, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    sub-int/2addr v3, v4

    .line 369
    invoke-virtual {v0, p2, v1, v2, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 371
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 372
    return-void
.end method

.method protected generateDefaultLayoutParams()Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .locals 3

    .line 1733
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v1, -0x2

    if-nez v0, :cond_0

    .line 1734
    new-instance v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    invoke-direct {v0, v1, v1}, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;-><init>(II)V

    return-object v0

    .line 1735
    :cond_0
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    .line 1736
    new-instance v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v0, v2, v1}, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;-><init>(II)V

    return-object v0

    .line 1738
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method protected bridge synthetic generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    .locals 1

    .line 57
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->generateDefaultLayoutParams()Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method public generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .locals 2
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 1720
    new-instance v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method protected generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1743
    new-instance v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    invoke-direct {v0, p1}, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;-><init>(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public bridge synthetic generateLayoutParams(Landroid/util/AttributeSet;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 57
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearLayoutCompat;->generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method protected bridge synthetic generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 57
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearLayoutCompat;->generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method public getBaseline()I
    .locals 6

    .line 423
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    if-gez v0, :cond_0

    .line 424
    invoke-super {p0}, Landroid/view/ViewGroup;->getBaseline()I

    move-result v0

    return v0

    .line 427
    :cond_0
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildCount()I

    move-result v0

    iget v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    if-gt v0, v1, :cond_1

    .line 428
    new-instance v0, Ljava/lang/RuntimeException;

    const-string v1, "mBaselineAlignedChildIndex of LinearLayout set to an index that is out of bounds."

    invoke-direct {v0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 432
    :cond_1
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    .line 433
    .local v0, "child":Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->getBaseline()I

    move-result v1

    .line 435
    .local v1, "childBaseline":I
    const/4 v2, -0x1

    if-ne v1, v2, :cond_3

    .line 436
    iget v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    if-nez v3, :cond_2

    .line 438
    return v2

    .line 442
    :cond_2
    new-instance v2, Ljava/lang/RuntimeException;

    const-string v3, "mBaselineAlignedChildIndex of LinearLayout points to a View that doesn\'t know how to get its baseline."

    invoke-direct {v2, v3}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 452
    :cond_3
    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineChildTop:I

    .line 454
    .local v2, "childTop":I
    iget v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v4, 0x1

    if-ne v3, v4, :cond_6

    .line 455
    iget v3, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/lit8 v3, v3, 0x70

    .line 456
    .local v3, "majorGravity":I
    const/16 v4, 0x30

    if-eq v3, v4, :cond_6

    .line 457
    const/16 v4, 0x10

    if-eq v3, v4, :cond_5

    const/16 v4, 0x50

    if-eq v3, v4, :cond_4

    .line 457
    .end local v3    # "majorGravity":I
    goto :goto_0

    .line 459
    .restart local v3    # "majorGravity":I
    :cond_4
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getBottom()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getTop()I

    move-result v5

    sub-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v5

    sub-int/2addr v4, v5

    iget v5, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int v2, v4, v5

    .line 460
    goto :goto_0

    .line 463
    :cond_5
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getBottom()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getTop()I

    move-result v5

    sub-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v5

    sub-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v5

    sub-int/2addr v4, v5

    iget v5, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int/2addr v4, v5

    div-int/lit8 v4, v4, 0x2

    add-int/2addr v2, v4

    .line 470
    .end local v3    # "majorGravity":I
    :cond_6
    :goto_0
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 471
    .local v3, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v4, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int/2addr v4, v2

    add-int/2addr v4, v1

    return v4
.end method

.method public getBaselineAlignedChildIndex()I
    .locals 1

    .line 480
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    return v0
.end method

.method getChildrenSkipCount(Landroid/view/View;I)I
    .locals 1
    .param p1, "child"    # Landroid/view/View;
    .param p2, "index"    # I

    .line 1346
    const/4 v0, 0x0

    return v0
.end method

.method public getDividerDrawable()Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 221
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    return-object v0
.end method

.method public getDividerPadding()I
    .locals 1

    .line 268
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    return v0
.end method

.method public getDividerWidth()I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 278
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    return v0
.end method

.method public getGravity()I
    .locals 1

    .line 1699
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    return v0
.end method

.method getLocationOffset(Landroid/view/View;)I
    .locals 1
    .param p1, "child"    # Landroid/view/View;

    .line 1388
    const/4 v0, 0x0

    return v0
.end method

.method getNextLocationOffset(Landroid/view/View;)I
    .locals 1
    .param p1, "child"    # Landroid/view/View;

    .line 1400
    const/4 v0, 0x0

    return v0
.end method

.method public getOrientation()I
    .locals 1

    .line 1666
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    return v0
.end method

.method public getShowDividers()I
    .locals 1

    .line 212
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    return v0
.end method

.method getVirtualChildAt(I)Landroid/view/View;
    .locals 1
    .param p1, "index"    # I

    .line 505
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method getVirtualChildCount()I
    .locals 1

    .line 518
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildCount()I

    move-result v0

    return v0
.end method

.method public getWeightSum()F
    .locals 1

    .line 529
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    return v0
.end method

.method protected hasDividerBeforeChildAt(I)Z
    .locals 4
    .param p1, "childIndex"    # I

    .line 565
    const/4 v0, 0x0

    const/4 v1, 0x1

    if-nez p1, :cond_1

    .line 566
    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    and-int/2addr v2, v1

    if-eqz v2, :cond_0

    move v0, v1

    nop

    :cond_0
    return v0

    .line 567
    :cond_1
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildCount()I

    move-result v2

    if-ne p1, v2, :cond_3

    .line 568
    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    and-int/lit8 v2, v2, 0x4

    if-eqz v2, :cond_2

    move v0, v1

    nop

    :cond_2
    return v0

    .line 569
    :cond_3
    iget v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    and-int/lit8 v1, v1, 0x2

    if-eqz v1, :cond_6

    .line 570
    const/4 v0, 0x0

    .line 571
    .local v0, "hasVisibleViewBefore":Z
    add-int/lit8 v1, p1, -0x1

    .line 571
    .local v1, "i":I
    :goto_0
    if-ltz v1, :cond_5

    .line 572
    invoke-virtual {p0, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v2

    const/16 v3, 0x8

    if-eq v2, v3, :cond_4

    .line 573
    const/4 v0, 0x1

    .line 574
    goto :goto_1

    .line 571
    :cond_4
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 577
    .end local v1    # "i":I
    :cond_5
    :goto_1
    return v0

    .line 579
    .end local v0    # "hasVisibleViewBefore":Z
    :cond_6
    return v0
.end method

.method public isBaselineAligned()Z
    .locals 1

    .line 381
    iget-boolean v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAligned:Z

    return v0
.end method

.method public isMeasureWithLargestChildEnabled()Z
    .locals 1

    .line 404
    iget-boolean v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mUseLargestChild:Z

    return v0
.end method

.method layoutHorizontal(IIII)V
    .locals 31
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "right"    # I
    .param p4, "bottom"    # I

    move-object/from16 v6, p0

    .line 1520
    invoke-static/range {p0 .. p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v9

    .line 1521
    .local v9, "isLayoutRtl":Z
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v10

    .line 1527
    .local v10, "paddingTop":I
    sub-int v13, p4, p2

    .line 1528
    .local v13, "height":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v0

    sub-int v14, v13, v0

    .line 1531
    .local v14, "childBottom":I
    sub-int v0, v13, v10

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v1

    sub-int v15, v0, v1

    .line 1533
    .local v15, "childSpace":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v5

    .line 1535
    .local v5, "count":I
    iget v0, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    const v1, 0x800007

    and-int v4, v0, v1

    .line 1536
    .local v4, "majorGravity":I
    iget v0, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/lit8 v16, v0, 0x70

    .line 1538
    .local v16, "minorGravity":I
    iget-boolean v2, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAligned:Z

    .line 1540
    .local v2, "baselineAligned":Z
    iget-object v1, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxAscent:[I

    .line 1541
    .local v1, "maxAscent":[I
    iget-object v0, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxDescent:[I

    .line 1543
    .local v0, "maxDescent":[I
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v3

    .line 1544
    .local v3, "layoutDirection":I
    invoke-static {v4, v3}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v11

    const/16 v17, 0x2

    const/4 v12, 0x1

    if-eq v11, v12, :cond_1

    const/4 v12, 0x5

    if-eq v11, v12, :cond_0

    .line 1557
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v11

    .line 1557
    .end local v3    # "layoutDirection":I
    .local v11, "childLeft":I
    .local v18, "layoutDirection":I
    :goto_0
    move/from16 v18, v3

    goto :goto_1

    .line 1547
    .end local v11    # "childLeft":I
    .end local v18    # "layoutDirection":I
    .restart local v3    # "layoutDirection":I
    :cond_0
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v11

    add-int v11, v11, p3

    sub-int v11, v11, p1

    iget v12, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int/2addr v11, v12

    .line 1548
    .restart local v11    # "childLeft":I
    goto :goto_0

    .line 1552
    .end local v11    # "childLeft":I
    :cond_1
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v11

    sub-int v12, p3, p1

    move/from16 v18, v3

    iget v3, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1552
    .end local v3    # "layoutDirection":I
    .restart local v18    # "layoutDirection":I
    sub-int/2addr v12, v3

    div-int/lit8 v12, v12, 0x2

    add-int/2addr v11, v12

    .line 1553
    .restart local v11    # "childLeft":I
    nop

    .line 1557
    :goto_1
    move v3, v11

    .line 1561
    .end local v11    # "childLeft":I
    .local v3, "childLeft":I
    const/4 v11, 0x0

    .line 1562
    .local v11, "start":I
    const/4 v12, 0x1

    .line 1564
    .local v12, "dir":I
    if-eqz v9, :cond_2

    .line 1565
    add-int/lit8 v11, v5, -0x1

    .line 1566
    const/4 v12, -0x1

    .line 1569
    :cond_2
    const/16 v19, 0x0

    move/from16 v20, v3

    .line 1569
    .end local v3    # "childLeft":I
    .local v19, "i":I
    .local v20, "childLeft":I
    :goto_2
    move/from16 v3, v19

    .line 1569
    .end local v19    # "i":I
    .local v3, "i":I
    if-ge v3, v5, :cond_d

    .line 1570
    mul-int v19, v12, v3

    add-int v7, v11, v19

    .line 1571
    .local v7, "childIndex":I
    invoke-virtual {v6, v7}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 1573
    .local v8, "child":Landroid/view/View;
    if-nez v8, :cond_3

    .line 1574
    invoke-virtual {v6, v7}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v19

    add-int v20, v20, v19

    .line 1569
    move-object/from16 v26, v0

    move-object/from16 v28, v1

    move/from16 v25, v2

    move/from16 v22, v4

    move/from16 v27, v5

    move/from16 v30, v9

    goto/16 :goto_5

    .line 1575
    :cond_3
    move/from16 v21, v3

    invoke-virtual {v8}, Landroid/view/View;->getVisibility()I

    move-result v3

    .line 1575
    .end local v3    # "i":I
    .local v21, "i":I
    move/from16 v22, v4

    const/16 v4, 0x8

    .line 1575
    .end local v4    # "majorGravity":I
    .local v22, "majorGravity":I
    if-eq v3, v4, :cond_c

    .line 1576
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v19

    .line 1577
    .local v19, "childWidth":I
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredHeight()I

    move-result v23

    .line 1578
    .local v23, "childHeight":I
    const/4 v3, -0x1

    .line 1580
    .local v3, "childBaseline":I
    nop

    .line 1581
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1583
    .local v4, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    move/from16 v24, v3

    const/4 v3, -0x1

    .line 1583
    .end local v3    # "childBaseline":I
    .local v24, "childBaseline":I
    if-eqz v2, :cond_4

    move/from16 v25, v2

    iget v2, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 1583
    .end local v2    # "baselineAligned":Z
    .local v25, "baselineAligned":Z
    if-eq v2, v3, :cond_5

    .line 1584
    invoke-virtual {v8}, Landroid/view/View;->getBaseline()I

    move-result v2

    .line 1584
    .end local v24    # "childBaseline":I
    .local v2, "childBaseline":I
    goto :goto_3

    .line 1587
    .end local v25    # "baselineAligned":Z
    .local v2, "baselineAligned":Z
    .restart local v24    # "childBaseline":I
    :cond_4
    move/from16 v25, v2

    .line 1587
    .end local v2    # "baselineAligned":Z
    .restart local v25    # "baselineAligned":Z
    :cond_5
    move/from16 v2, v24

    .line 1587
    .end local v24    # "childBaseline":I
    .local v2, "childBaseline":I
    :goto_3
    iget v3, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    .line 1588
    .local v3, "gravity":I
    if-gez v3, :cond_6

    .line 1589
    move/from16 v3, v16

    .line 1592
    .end local v3    # "gravity":I
    .local v24, "gravity":I
    :cond_6
    move/from16 v24, v3

    and-int/lit8 v3, v24, 0x70

    move/from16 v27, v5

    .line 1592
    .end local v5    # "count":I
    .local v27, "count":I
    const/16 v5, 0x10

    if-eq v3, v5, :cond_9

    const/16 v5, 0x30

    if-eq v3, v5, :cond_8

    const/16 v5, 0x50

    if-eq v3, v5, :cond_7

    .line 1624
    move v3, v10

    goto :goto_4

    .line 1617
    :cond_7
    sub-int v3, v14, v23

    iget v5, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    sub-int/2addr v3, v5

    .line 1618
    .local v3, "childTop":I
    const/4 v5, -0x1

    if-eq v2, v5, :cond_a

    .line 1619
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredHeight()I

    move-result v5

    sub-int/2addr v5, v2

    .line 1620
    .local v5, "descent":I
    aget v26, v0, v17

    sub-int v26, v26, v5

    sub-int v3, v3, v26

    .line 1621
    .end local v5    # "descent":I
    goto :goto_4

    .line 1594
    .end local v3    # "childTop":I
    :cond_8
    iget v3, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int/2addr v3, v10

    .line 1595
    .restart local v3    # "childTop":I
    const/4 v5, -0x1

    if-eq v2, v5, :cond_a

    .line 1596
    const/4 v5, 0x1

    aget v26, v1, v5

    sub-int v26, v26, v2

    add-int v3, v3, v26

    goto :goto_4

    .line 1612
    .end local v3    # "childTop":I
    :cond_9
    sub-int v3, v15, v23

    div-int/lit8 v3, v3, 0x2

    add-int/2addr v3, v10

    iget v5, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int/2addr v3, v5

    iget v5, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    sub-int/2addr v3, v5

    .line 1614
    .restart local v3    # "childTop":I
    nop

    .line 1624
    :cond_a
    :goto_4
    nop

    .line 1628
    invoke-virtual {v6, v7}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v5

    if-eqz v5, :cond_b

    .line 1629
    iget v5, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    add-int v20, v20, v5

    .line 1632
    :cond_b
    iget v5, v4, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int v20, v20, v5

    .line 1633
    invoke-virtual {v6, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->getLocationOffset(Landroid/view/View;)I

    move-result v5

    add-int v5, v20, v5

    move-object/from16 v26, v0

    move-object v0, v6

    .line 1633
    .end local v0    # "maxDescent":[I
    .local v26, "maxDescent":[I
    move-object/from16 v28, v1

    move-object v1, v8

    .line 1633
    .end local v1    # "maxAscent":[I
    .local v28, "maxAscent":[I
    move/from16 v29, v2

    move v2, v5

    .line 1633
    .end local v2    # "childBaseline":I
    .local v29, "childBaseline":I
    move-object v5, v4

    move/from16 v4, v19

    .line 1633
    .end local v4    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v5, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    move/from16 v30, v9

    move-object v9, v5

    move/from16 v5, v23

    .line 1633
    .end local v5    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v9, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v30, "isLayoutRtl":Z
    invoke-direct/range {v0 .. v5}, Landroid/support/v7/widget/LinearLayoutCompat;->setChildFrame(Landroid/view/View;IIII)V

    .line 1635
    iget v0, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int v0, v19, v0

    .line 1636
    invoke-virtual {v6, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v1

    add-int/2addr v0, v1

    add-int v20, v20, v0

    .line 1638
    invoke-virtual {v6, v8, v7}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v0

    add-int v3, v21, v0

    .line 1638
    .end local v7    # "childIndex":I
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v19    # "childWidth":I
    .end local v21    # "i":I
    .end local v23    # "childHeight":I
    .end local v24    # "gravity":I
    .end local v29    # "childBaseline":I
    .local v3, "i":I
    goto :goto_5

    .line 1569
    .end local v3    # "i":I
    .end local v25    # "baselineAligned":Z
    .end local v26    # "maxDescent":[I
    .end local v27    # "count":I
    .end local v28    # "maxAscent":[I
    .end local v30    # "isLayoutRtl":Z
    .restart local v0    # "maxDescent":[I
    .restart local v1    # "maxAscent":[I
    .local v2, "baselineAligned":Z
    .local v5, "count":I
    .local v9, "isLayoutRtl":Z
    .restart local v21    # "i":I
    :cond_c
    move-object/from16 v26, v0

    move-object/from16 v28, v1

    move/from16 v25, v2

    move/from16 v27, v5

    move/from16 v30, v9

    move/from16 v3, v21

    .line 1569
    .end local v0    # "maxDescent":[I
    .end local v1    # "maxAscent":[I
    .end local v2    # "baselineAligned":Z
    .end local v5    # "count":I
    .end local v9    # "isLayoutRtl":Z
    .end local v21    # "i":I
    .restart local v3    # "i":I
    .restart local v25    # "baselineAligned":Z
    .restart local v26    # "maxDescent":[I
    .restart local v27    # "count":I
    .restart local v28    # "maxAscent":[I
    .restart local v30    # "isLayoutRtl":Z
    :goto_5
    const/4 v0, 0x1

    add-int/lit8 v19, v3, 0x1

    .line 1569
    .end local v3    # "i":I
    .local v19, "i":I
    move/from16 v4, v22

    move/from16 v2, v25

    move-object/from16 v0, v26

    move/from16 v5, v27

    move-object/from16 v1, v28

    move/from16 v9, v30

    goto/16 :goto_2

    .line 1641
    .end local v19    # "i":I
    .end local v22    # "majorGravity":I
    .end local v25    # "baselineAligned":Z
    .end local v26    # "maxDescent":[I
    .end local v27    # "count":I
    .end local v28    # "maxAscent":[I
    .end local v30    # "isLayoutRtl":Z
    .restart local v0    # "maxDescent":[I
    .restart local v1    # "maxAscent":[I
    .restart local v2    # "baselineAligned":Z
    .local v4, "majorGravity":I
    .restart local v5    # "count":I
    .restart local v9    # "isLayoutRtl":Z
    :cond_d
    move-object/from16 v26, v0

    move-object/from16 v28, v1

    move/from16 v25, v2

    move/from16 v22, v4

    move/from16 v27, v5

    move/from16 v30, v9

    .line 1641
    .end local v0    # "maxDescent":[I
    .end local v1    # "maxAscent":[I
    .end local v2    # "baselineAligned":Z
    .end local v4    # "majorGravity":I
    .end local v5    # "count":I
    .end local v9    # "isLayoutRtl":Z
    .restart local v22    # "majorGravity":I
    .restart local v25    # "baselineAligned":Z
    .restart local v26    # "maxDescent":[I
    .restart local v27    # "count":I
    .restart local v28    # "maxAscent":[I
    .restart local v30    # "isLayoutRtl":Z
    return-void
.end method

.method layoutVertical(IIII)V
    .locals 24
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "right"    # I
    .param p4, "bottom"    # I

    move-object/from16 v6, p0

    .line 1425
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v9

    .line 1431
    .local v9, "paddingLeft":I
    sub-int v10, p3, p1

    .line 1432
    .local v10, "width":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v0

    sub-int v11, v10, v0

    .line 1435
    .local v11, "childRight":I
    sub-int v0, v10, v9

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v1

    sub-int v12, v0, v1

    .line 1437
    .local v12, "childSpace":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v13

    .line 1439
    .local v13, "count":I
    iget v0, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/lit8 v5, v0, 0x70

    .line 1440
    .local v5, "majorGravity":I
    iget v0, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    const v1, 0x800007

    and-int v14, v0, v1

    .line 1442
    .local v14, "minorGravity":I
    const/16 v0, 0x10

    if-eq v5, v0, :cond_1

    const/16 v0, 0x50

    if-eq v5, v0, :cond_0

    .line 1455
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v0

    goto :goto_0

    .line 1445
    :cond_0
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v0

    add-int v0, v0, p4

    sub-int v0, v0, p2

    iget v1, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int/2addr v0, v1

    .line 1446
    .local v0, "childTop":I
    goto :goto_0

    .line 1450
    .end local v0    # "childTop":I
    :cond_1
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v0

    sub-int v1, p4, p2

    iget v2, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int/2addr v1, v2

    div-int/lit8 v1, v1, 0x2

    add-int/2addr v0, v1

    .line 1451
    .restart local v0    # "childTop":I
    nop

    .line 1455
    :goto_0
    nop

    .line 1459
    const/4 v1, 0x0

    .line 1459
    .local v1, "i":I
    :goto_1
    move v4, v1

    .line 1459
    .end local v1    # "i":I
    .local v4, "i":I
    if-ge v4, v13, :cond_8

    .line 1460
    invoke-virtual {v6, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1461
    .local v3, "child":Landroid/view/View;
    if-nez v3, :cond_2

    .line 1462
    invoke-virtual {v6, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v2

    add-int/2addr v0, v2

    .line 1459
    move/from16 v20, v5

    move/from16 v23, v9

    const/16 v21, 0x1

    goto/16 :goto_3

    .line 1463
    :cond_2
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v2

    const/16 v1, 0x8

    if-eq v2, v1, :cond_7

    .line 1464
    invoke-virtual {v3}, Landroid/view/View;->getMeasuredWidth()I

    move-result v16

    .line 1465
    .local v16, "childWidth":I
    invoke-virtual {v3}, Landroid/view/View;->getMeasuredHeight()I

    move-result v17

    .line 1467
    .local v17, "childHeight":I
    nop

    .line 1468
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1470
    .local v1, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v2, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    .line 1471
    .local v2, "gravity":I
    if-gez v2, :cond_3

    .line 1472
    move v2, v14

    .line 1474
    :cond_3
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v7

    .line 1475
    .local v7, "layoutDirection":I
    invoke-static {v2, v7}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v18

    .line 1477
    .local v18, "absoluteGravity":I
    move/from16 v19, v2

    and-int/lit8 v2, v18, 0x7

    .line 1477
    .end local v2    # "gravity":I
    .local v19, "gravity":I
    move/from16 v20, v5

    const/4 v5, 0x1

    .line 1477
    .end local v5    # "majorGravity":I
    .local v20, "majorGravity":I
    if-eq v2, v5, :cond_5

    const/4 v5, 0x5

    if-eq v2, v5, :cond_4

    .line 1489
    iget v2, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v2, v9

    goto :goto_2

    .line 1484
    :cond_4
    sub-int v2, v11, v16

    iget v5, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    sub-int/2addr v2, v5

    .line 1485
    .local v2, "childLeft":I
    goto :goto_2

    .line 1479
    .end local v2    # "childLeft":I
    :cond_5
    sub-int v2, v12, v16

    div-int/lit8 v2, v2, 0x2

    add-int/2addr v2, v9

    iget v5, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v2, v5

    iget v5, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    sub-int/2addr v2, v5

    .line 1481
    .restart local v2    # "childLeft":I
    nop

    .line 1489
    :goto_2
    move/from16 v15, v19

    .line 1493
    .end local v19    # "gravity":I
    .local v15, "gravity":I
    invoke-virtual {v6, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v5

    if-eqz v5, :cond_6

    .line 1494
    iget v5, v6, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    add-int/2addr v0, v5

    .line 1497
    :cond_6
    iget v5, v1, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int v19, v0, v5

    .line 1498
    .end local v0    # "childTop":I
    .local v19, "childTop":I
    invoke-virtual {v6, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->getLocationOffset(Landroid/view/View;)I

    move-result v0

    add-int v5, v19, v0

    move-object v0, v6

    move/from16 v22, v7

    const/16 v21, 0x1

    move-object v7, v1

    move-object v1, v3

    .line 1498
    .end local v1    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v7, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v22, "layoutDirection":I
    move-object v8, v3

    move v3, v5

    .line 1498
    .end local v3    # "child":Landroid/view/View;
    .local v8, "child":Landroid/view/View;
    move v5, v4

    move/from16 v4, v16

    .line 1498
    .end local v4    # "i":I
    .local v5, "i":I
    move/from16 v23, v9

    move v9, v5

    move/from16 v5, v17

    .line 1498
    .end local v5    # "i":I
    .local v9, "i":I
    .local v23, "paddingLeft":I
    invoke-direct/range {v0 .. v5}, Landroid/support/v7/widget/LinearLayoutCompat;->setChildFrame(Landroid/view/View;IIII)V

    .line 1500
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int v0, v17, v0

    invoke-virtual {v6, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v1

    add-int/2addr v0, v1

    add-int v19, v19, v0

    .line 1502
    invoke-virtual {v6, v8, v9}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v0

    add-int v4, v9, v0

    .line 1459
    .end local v2    # "childLeft":I
    .end local v7    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "i":I
    .end local v15    # "gravity":I
    .end local v16    # "childWidth":I
    .end local v17    # "childHeight":I
    .end local v18    # "absoluteGravity":I
    .end local v22    # "layoutDirection":I
    .restart local v4    # "i":I
    move/from16 v0, v19

    goto :goto_3

    .line 1459
    .end local v19    # "childTop":I
    .end local v20    # "majorGravity":I
    .end local v23    # "paddingLeft":I
    .restart local v0    # "childTop":I
    .local v5, "majorGravity":I
    .local v9, "paddingLeft":I
    :cond_7
    move/from16 v20, v5

    move/from16 v23, v9

    const/16 v21, 0x1

    move v9, v4

    .line 1459
    .end local v5    # "majorGravity":I
    .end local v9    # "paddingLeft":I
    .restart local v20    # "majorGravity":I
    .restart local v23    # "paddingLeft":I
    :goto_3
    add-int/lit8 v1, v4, 0x1

    .line 1459
    .end local v4    # "i":I
    .local v1, "i":I
    move/from16 v5, v20

    move/from16 v9, v23

    goto/16 :goto_1

    .line 1505
    .end local v1    # "i":I
    .end local v20    # "majorGravity":I
    .end local v23    # "paddingLeft":I
    .restart local v5    # "majorGravity":I
    .restart local v9    # "paddingLeft":I
    :cond_8
    move/from16 v20, v5

    move/from16 v23, v9

    .line 1505
    .end local v5    # "majorGravity":I
    .end local v9    # "paddingLeft":I
    .restart local v20    # "majorGravity":I
    .restart local v23    # "paddingLeft":I
    return-void
.end method

.method measureChildBeforeLayout(Landroid/view/View;IIIII)V
    .locals 6
    .param p1, "child"    # Landroid/view/View;
    .param p2, "childIndex"    # I
    .param p3, "widthMeasureSpec"    # I
    .param p4, "totalWidth"    # I
    .param p5, "heightMeasureSpec"    # I
    .param p6, "totalHeight"    # I

    .line 1376
    move-object v0, p0

    move-object v1, p1

    move v2, p3

    move v3, p4

    move v4, p5

    move v5, p6

    invoke-virtual/range {v0 .. v5}, Landroid/support/v7/widget/LinearLayoutCompat;->measureChildWithMargins(Landroid/view/View;IIII)V

    .line 1378
    return-void
.end method

.method measureHorizontal(II)V
    .locals 63
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v7, p0

    move/from16 v8, p1

    .line 927
    move/from16 v9, p2

    const/4 v10, 0x0

    iput v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 928
    const/4 v0, 0x0

    .line 929
    .local v0, "maxHeight":I
    const/4 v1, 0x0

    .line 930
    .local v1, "childState":I
    const/4 v2, 0x0

    .line 931
    .local v2, "alternativeMaxHeight":I
    const/4 v3, 0x0

    .line 932
    .local v3, "weightedMaxHeight":I
    const/4 v4, 0x1

    .line 933
    .local v4, "allFillParent":Z
    const/4 v5, 0x0

    .line 935
    .local v5, "totalWeight":F
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v11

    .line 937
    .local v11, "count":I
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v12

    .line 938
    .local v12, "widthMode":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v13

    .line 940
    .local v13, "heightMode":I
    const/4 v6, 0x0

    .line 941
    .local v6, "matchHeight":Z
    const/4 v14, 0x0

    .line 943
    .local v14, "skippedMeasure":Z
    iget-object v15, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxAscent:[I

    if-eqz v15, :cond_0

    iget-object v15, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxDescent:[I

    if-nez v15, :cond_1

    .line 944
    :cond_0
    const/4 v15, 0x4

    new-array v10, v15, [I

    iput-object v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxAscent:[I

    .line 945
    new-array v10, v15, [I

    iput-object v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxDescent:[I

    .line 948
    :cond_1
    iget-object v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxAscent:[I

    .line 949
    .local v10, "maxAscent":[I
    iget-object v15, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mMaxDescent:[I

    .line 951
    .local v15, "maxDescent":[I
    const/16 v17, 0x3

    move/from16 v18, v6

    const/4 v6, -0x1

    .line 951
    .end local v6    # "matchHeight":Z
    .local v18, "matchHeight":Z
    aput v6, v10, v17

    const/16 v19, 0x2

    aput v6, v10, v19

    const/16 v20, 0x1

    aput v6, v10, v20

    const/16 v16, 0x0

    aput v6, v10, v16

    .line 952
    aput v6, v15, v17

    aput v6, v15, v19

    aput v6, v15, v20

    aput v6, v15, v16

    .line 954
    iget-boolean v6, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAligned:Z

    .line 955
    .local v6, "baselineAligned":Z
    move/from16 v22, v14

    iget-boolean v14, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mUseLargestChild:Z

    .line 957
    .local v14, "useLargestChild":Z
    .local v22, "skippedMeasure":Z
    move-object/from16 v23, v15

    const/high16 v15, 0x40000000    # 2.0f

    .line 957
    .end local v15    # "maxDescent":[I
    .local v23, "maxDescent":[I
    if-ne v12, v15, :cond_2

    move/from16 v24, v20

    goto :goto_0

    :cond_2
    const/16 v24, 0x0

    .line 959
    .local v24, "isExactly":Z
    :goto_0
    const/high16 v25, -0x80000000

    .line 962
    .local v25, "largestChildWidth":I
    move/from16 v26, v1

    move/from16 v1, v25

    move/from16 v25, v18

    move/from16 v18, v4

    move v4, v0

    const/4 v0, 0x0

    move/from16 v62, v3

    move v3, v2

    move/from16 v2, v62

    .line 962
    .local v0, "i":I
    .local v1, "largestChildWidth":I
    .local v2, "weightedMaxHeight":I
    .local v3, "alternativeMaxHeight":I
    .local v4, "maxHeight":I
    .local v18, "allFillParent":Z
    .local v25, "matchHeight":Z
    .local v26, "childState":I
    :goto_1
    const/16 v28, 0x0

    if-ge v0, v11, :cond_15

    .line 963
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v15

    .line 965
    .local v15, "child":Landroid/view/View;
    if-nez v15, :cond_3

    .line 966
    move/from16 v30, v1

    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 966
    .end local v1    # "largestChildWidth":I
    .local v30, "largestChildWidth":I
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v27

    add-int v1, v1, v27

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 967
    nop

    .line 962
    move/from16 v21, v6

    move/from16 v1, v30

    goto/16 :goto_e

    .line 970
    .end local v30    # "largestChildWidth":I
    .restart local v1    # "largestChildWidth":I
    :cond_3
    move/from16 v30, v1

    .line 970
    .end local v1    # "largestChildWidth":I
    .restart local v30    # "largestChildWidth":I
    invoke-virtual {v15}, Landroid/view/View;->getVisibility()I

    move-result v1

    move/from16 v31, v2

    const/16 v2, 0x8

    if-ne v1, v2, :cond_4

    .line 971
    .end local v2    # "weightedMaxHeight":I
    .local v31, "weightedMaxHeight":I
    invoke-virtual {v7, v15, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v1

    add-int/2addr v0, v1

    .line 972
    nop

    .line 962
    move/from16 v21, v6

    move/from16 v1, v30

    move/from16 v2, v31

    goto/16 :goto_e

    .line 975
    :cond_4
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 976
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    add-int/2addr v1, v2

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 979
    :cond_5
    nop

    .line 980
    invoke-virtual {v15}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 982
    .local v2, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    add-float v29, v5, v1

    .line 984
    .end local v5    # "totalWeight":F
    .local v29, "totalWeight":F
    const/high16 v1, 0x40000000    # 2.0f

    if-ne v12, v1, :cond_8

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    if-nez v1, :cond_8

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v1, v1, v28

    if-lez v1, :cond_8

    .line 988
    if-eqz v24, :cond_6

    .line 989
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v5, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    move/from16 v32, v0

    iget v0, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    .line 989
    .end local v0    # "i":I
    .local v32, "i":I
    add-int/2addr v5, v0

    add-int/2addr v1, v5

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    goto :goto_2

    .line 991
    .end local v32    # "i":I
    .restart local v0    # "i":I
    :cond_6
    move/from16 v32, v0

    .line 991
    .end local v0    # "i":I
    .restart local v32    # "i":I
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 992
    .local v0, "totalLength":I
    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v1, v0

    iget v5, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v1, v5

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1001
    .end local v0    # "totalLength":I
    :goto_2
    if-eqz v6, :cond_7

    .line 1002
    const/4 v0, 0x0

    invoke-static {v0, v0}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v1

    .line 1003
    .local v1, "freeSpec":I
    invoke-virtual {v15, v1, v1}, Landroid/view/View;->measure(II)V

    .line 1004
    .end local v1    # "freeSpec":I
    nop

    .line 1046
    move-object v0, v2

    move/from16 v39, v3

    move/from16 v40, v4

    move/from16 v21, v6

    move/from16 v2, v30

    move/from16 v38, v31

    move/from16 v35, v32

    const/4 v9, -0x1

    goto/16 :goto_6

    .line 1005
    :cond_7
    const/16 v22, 0x1

    .line 1046
    move-object v0, v2

    move/from16 v39, v3

    move/from16 v40, v4

    move/from16 v21, v6

    move/from16 v38, v31

    move/from16 v35, v32

    const/4 v9, -0x1

    goto/16 :goto_7

    .line 1008
    .end local v32    # "i":I
    .local v0, "i":I
    :cond_8
    move/from16 v32, v0

    .line 1008
    .end local v0    # "i":I
    .restart local v32    # "i":I
    const/high16 v0, -0x80000000

    .line 1010
    .local v0, "oldWidth":I
    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    if-nez v1, :cond_9

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v1, v1, v28

    if-lez v1, :cond_9

    .line 1015
    const/4 v0, 0x0

    .line 1016
    const/4 v1, -0x2

    iput v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    .line 1023
    .end local v0    # "oldWidth":I
    .local v5, "oldWidth":I
    :cond_9
    move v5, v0

    cmpl-float v0, v29, v28

    if-nez v0, :cond_a

    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    move/from16 v33, v0

    goto :goto_3

    :cond_a
    const/16 v33, 0x0

    :goto_3
    const/16 v34, 0x0

    move/from16 v1, v32

    move-object v0, v7

    .line 1023
    .end local v32    # "i":I
    .local v1, "i":I
    move/from16 v35, v1

    move/from16 v36, v30

    move-object v1, v15

    .line 1023
    .end local v1    # "i":I
    .end local v30    # "largestChildWidth":I
    .local v35, "i":I
    .local v36, "largestChildWidth":I
    move-object/from16 v37, v2

    move/from16 v38, v31

    move/from16 v2, v35

    .line 1023
    .end local v2    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v31    # "weightedMaxHeight":I
    .local v37, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v38, "weightedMaxHeight":I
    move/from16 v39, v3

    move v3, v8

    .line 1023
    .end local v3    # "alternativeMaxHeight":I
    .local v39, "alternativeMaxHeight":I
    move/from16 v40, v4

    move/from16 v4, v33

    .line 1023
    .end local v4    # "maxHeight":I
    .local v40, "maxHeight":I
    move v8, v5

    move v5, v9

    .line 1023
    .end local v5    # "oldWidth":I
    .local v8, "oldWidth":I
    move/from16 v21, v6

    const/4 v9, -0x1

    move/from16 v6, v34

    .line 1023
    .end local v6    # "baselineAligned":Z
    .local v21, "baselineAligned":Z
    invoke-virtual/range {v0 .. v6}, Landroid/support/v7/widget/LinearLayoutCompat;->measureChildBeforeLayout(Landroid/view/View;IIIII)V

    .line 1027
    const/high16 v0, -0x80000000

    if-eq v8, v0, :cond_b

    .line 1028
    move-object/from16 v0, v37

    iput v8, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    goto :goto_4

    .line 1031
    :cond_b
    move-object/from16 v0, v37

    .line 1031
    .end local v37    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v0, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    :goto_4
    invoke-virtual {v15}, Landroid/view/View;->getMeasuredWidth()I

    move-result v1

    .line 1032
    .local v1, "childWidth":I
    if-eqz v24, :cond_c

    .line 1033
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v3, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v3, v1

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v3, v4

    .line 1034
    invoke-virtual {v7, v15}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v4

    add-int/2addr v3, v4

    add-int/2addr v2, v3

    iput v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    goto :goto_5

    .line 1036
    :cond_c
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1037
    .local v2, "totalLength":I
    add-int v3, v2, v1

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v3, v4

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v3, v4

    .line 1038
    invoke-virtual {v7, v15}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v4

    add-int/2addr v3, v4

    .line 1037
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    iput v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1041
    .end local v2    # "totalLength":I
    :goto_5
    if-eqz v14, :cond_d

    .line 1042
    move/from16 v2, v36

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1046
    .end local v8    # "oldWidth":I
    .end local v36    # "largestChildWidth":I
    .local v1, "largestChildWidth":I
    move/from16 v30, v1

    goto :goto_7

    .line 1046
    .end local v1    # "largestChildWidth":I
    .restart local v36    # "largestChildWidth":I
    :cond_d
    move/from16 v2, v36

    .line 1046
    .end local v0    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v21    # "baselineAligned":Z
    .end local v35    # "i":I
    .end local v36    # "largestChildWidth":I
    .end local v38    # "weightedMaxHeight":I
    .end local v39    # "alternativeMaxHeight":I
    .end local v40    # "maxHeight":I
    .local v2, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .restart local v3    # "alternativeMaxHeight":I
    .restart local v4    # "maxHeight":I
    .restart local v6    # "baselineAligned":Z
    .restart local v30    # "largestChildWidth":I
    .restart local v31    # "weightedMaxHeight":I
    .restart local v32    # "i":I
    :goto_6
    move/from16 v30, v2

    .line 1046
    .end local v2    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v3    # "alternativeMaxHeight":I
    .end local v4    # "maxHeight":I
    .end local v6    # "baselineAligned":Z
    .end local v31    # "weightedMaxHeight":I
    .end local v32    # "i":I
    .restart local v0    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .restart local v21    # "baselineAligned":Z
    .restart local v35    # "i":I
    .restart local v38    # "weightedMaxHeight":I
    .restart local v39    # "alternativeMaxHeight":I
    .restart local v40    # "maxHeight":I
    :goto_7
    const/4 v1, 0x0

    .line 1047
    .local v1, "matchHeightLocally":Z
    const/high16 v2, 0x40000000    # 2.0f

    if-eq v13, v2, :cond_e

    iget v2, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    if-ne v2, v9, :cond_e

    .line 1051
    const/16 v25, 0x1

    .line 1052
    const/4 v1, 0x1

    .line 1055
    :cond_e
    iget v2, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    iget v3, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int/2addr v2, v3

    .line 1056
    .local v2, "margin":I
    invoke-virtual {v15}, Landroid/view/View;->getMeasuredHeight()I

    move-result v3

    add-int/2addr v3, v2

    .line 1057
    .local v3, "childHeight":I
    invoke-virtual {v15}, Landroid/view/View;->getMeasuredState()I

    move-result v4

    move/from16 v6, v26

    invoke-static {v6, v4}, Landroid/view/View;->combineMeasuredStates(II)I

    move-result v4

    .line 1059
    .end local v26    # "childState":I
    .local v4, "childState":I
    if-eqz v21, :cond_10

    .line 1060
    invoke-virtual {v15}, Landroid/view/View;->getBaseline()I

    move-result v5

    .line 1061
    .local v5, "childBaseline":I
    if-eq v5, v9, :cond_10

    .line 1064
    iget v6, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    if-gez v6, :cond_f

    iget v6, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    goto :goto_8

    :cond_f
    iget v6, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    :goto_8
    and-int/lit8 v6, v6, 0x70

    .line 1066
    .local v6, "gravity":I
    shr-int/lit8 v8, v6, 0x4

    const/16 v26, -0x2

    and-int/lit8 v8, v8, -0x2

    shr-int/lit8 v8, v8, 0x1

    .line 1069
    .local v8, "index":I
    aget v9, v10, v8

    invoke-static {v9, v5}, Ljava/lang/Math;->max(II)I

    move-result v9

    aput v9, v10, v8

    .line 1070
    aget v9, v23, v8

    move/from16 v41, v2

    sub-int v2, v3, v5

    .line 1070
    .end local v2    # "margin":I
    .local v41, "margin":I
    invoke-static {v9, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    aput v2, v23, v8

    .line 1070
    .end local v5    # "childBaseline":I
    .end local v6    # "gravity":I
    .end local v8    # "index":I
    goto :goto_9

    .line 1074
    .end local v41    # "margin":I
    .restart local v2    # "margin":I
    :cond_10
    move/from16 v41, v2

    .line 1074
    .end local v2    # "margin":I
    .restart local v41    # "margin":I
    :goto_9
    move/from16 v8, v40

    invoke-static {v8, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 1076
    .end local v40    # "maxHeight":I
    .local v2, "maxHeight":I
    if-eqz v18, :cond_11

    iget v5, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    const/4 v6, -0x1

    if-ne v5, v6, :cond_11

    move/from16 v5, v20

    goto :goto_a

    :cond_11
    const/4 v5, 0x0

    .line 1077
    .end local v18    # "allFillParent":Z
    .local v5, "allFillParent":Z
    :goto_a
    iget v6, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v6, v6, v28

    if-lez v6, :cond_13

    .line 1082
    if-eqz v1, :cond_12

    move/from16 v6, v41

    goto :goto_b

    :cond_12
    move v6, v3

    :goto_b
    move/from16 v9, v38

    invoke-static {v9, v6}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 1089
    .end local v38    # "weightedMaxHeight":I
    .local v6, "weightedMaxHeight":I
    move v9, v6

    move/from16 v6, v39

    goto :goto_d

    .line 1085
    .end local v6    # "weightedMaxHeight":I
    .restart local v38    # "weightedMaxHeight":I
    :cond_13
    move/from16 v9, v38

    .line 1085
    .end local v38    # "weightedMaxHeight":I
    .local v9, "weightedMaxHeight":I
    if-eqz v1, :cond_14

    move/from16 v6, v41

    goto :goto_c

    :cond_14
    move v6, v3

    :goto_c
    move/from16 v8, v39

    invoke-static {v8, v6}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 1089
    .end local v39    # "alternativeMaxHeight":I
    .local v6, "alternativeMaxHeight":I
    :goto_d
    move/from16 v8, v35

    invoke-virtual {v7, v15, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v18

    .line 1089
    .end local v35    # "i":I
    .local v8, "i":I
    add-int v0, v8, v18

    .line 962
    .end local v1    # "matchHeightLocally":Z
    .end local v3    # "childHeight":I
    .end local v8    # "i":I
    .end local v15    # "child":Landroid/view/View;
    .end local v41    # "margin":I
    .local v0, "i":I
    move/from16 v26, v4

    move/from16 v18, v5

    move v3, v6

    move/from16 v5, v29

    move/from16 v1, v30

    move v4, v2

    move v2, v9

    .line 962
    .end local v6    # "alternativeMaxHeight":I
    .end local v9    # "weightedMaxHeight":I
    .end local v29    # "totalWeight":F
    .end local v30    # "largestChildWidth":I
    .local v1, "largestChildWidth":I
    .local v2, "weightedMaxHeight":I
    .local v3, "alternativeMaxHeight":I
    .local v4, "maxHeight":I
    .local v5, "totalWeight":F
    .restart local v18    # "allFillParent":Z
    .restart local v26    # "childState":I
    :goto_e
    add-int/lit8 v0, v0, 0x1

    move/from16 v6, v21

    move/from16 v8, p1

    move/from16 v9, p2

    const/high16 v15, 0x40000000    # 2.0f

    goto/16 :goto_1

    .line 1092
    .end local v0    # "i":I
    .end local v21    # "baselineAligned":Z
    .local v6, "baselineAligned":Z
    :cond_15
    move v9, v2

    move v8, v4

    move/from16 v21, v6

    move/from16 v6, v26

    move v2, v1

    .line 1092
    .end local v1    # "largestChildWidth":I
    .end local v4    # "maxHeight":I
    .end local v26    # "childState":I
    .local v2, "largestChildWidth":I
    .local v6, "childState":I
    .local v8, "maxHeight":I
    .restart local v9    # "weightedMaxHeight":I
    .restart local v21    # "baselineAligned":Z
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    if-lez v0, :cond_16

    invoke-virtual {v7, v11}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v0

    if-eqz v0, :cond_16

    .line 1093
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    add-int/2addr v0, v1

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1098
    :cond_16
    aget v0, v10, v20

    const/4 v1, -0x1

    if-ne v0, v1, :cond_18

    const/4 v0, 0x0

    aget v4, v10, v0

    if-ne v4, v1, :cond_18

    aget v0, v10, v19

    if-ne v0, v1, :cond_18

    aget v0, v10, v17

    if-eq v0, v1, :cond_17

    goto :goto_f

    .line 1111
    :cond_17
    move/from16 v42, v6

    move v4, v8

    goto :goto_10

    .line 1102
    :cond_18
    :goto_f
    aget v0, v10, v17

    const/4 v1, 0x0

    aget v4, v10, v1

    aget v15, v10, v20

    aget v1, v10, v19

    .line 1104
    invoke-static {v15, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1103
    invoke-static {v4, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1102
    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1105
    .local v0, "ascent":I
    aget v1, v23, v17

    const/4 v4, 0x0

    aget v15, v23, v4

    aget v4, v23, v20

    move/from16 v42, v6

    aget v6, v23, v19

    .line 1107
    .end local v6    # "childState":I
    .local v42, "childState":I
    invoke-static {v4, v6}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 1106
    invoke-static {v15, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 1105
    invoke-static {v1, v4}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1108
    .local v1, "descent":I
    add-int v4, v0, v1

    invoke-static {v8, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 1111
    .end local v0    # "ascent":I
    .end local v1    # "descent":I
    .end local v8    # "maxHeight":I
    .restart local v4    # "maxHeight":I
    :goto_10
    if-eqz v14, :cond_1d

    const/high16 v0, -0x80000000

    if-eq v12, v0, :cond_19

    if-nez v12, :cond_1d

    .line 1113
    :cond_19
    const/4 v0, 0x0

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1115
    const/4 v0, 0x0

    .line 1115
    .local v0, "i":I
    :goto_11
    if-ge v0, v11, :cond_1d

    .line 1116
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 1118
    .local v1, "child":Landroid/view/View;
    if-nez v1, :cond_1a

    .line 1119
    iget v6, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v8

    add-int/2addr v6, v8

    iput v6, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1120
    nop

    .line 1115
    move/from16 v43, v0

    goto :goto_12

    .line 1123
    :cond_1a
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v6

    const/16 v8, 0x8

    if-ne v6, v8, :cond_1b

    .line 1124
    invoke-virtual {v7, v1, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v6

    add-int/2addr v0, v6

    .line 1125
    goto :goto_13

    .line 1128
    :cond_1b
    nop

    .line 1129
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1130
    .local v6, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    if-eqz v24, :cond_1c

    .line 1131
    iget v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v15, v6, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v15, v2

    move/from16 v43, v0

    iget v0, v6, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    .line 1131
    .end local v0    # "i":I
    .local v43, "i":I
    add-int/2addr v15, v0

    .line 1132
    invoke-virtual {v7, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v0

    add-int/2addr v15, v0

    add-int/2addr v8, v15

    iput v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    goto :goto_12

    .line 1134
    .end local v43    # "i":I
    .restart local v0    # "i":I
    :cond_1c
    move/from16 v43, v0

    .line 1134
    .end local v0    # "i":I
    .restart local v43    # "i":I
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1135
    .local v0, "totalLength":I
    add-int v8, v0, v2

    iget v15, v6, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v8, v15

    iget v15, v6, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v8, v15

    .line 1136
    invoke-virtual {v7, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v15

    add-int/2addr v8, v15

    .line 1135
    invoke-static {v0, v8}, Ljava/lang/Math;->max(II)I

    move-result v8

    iput v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1115
    .end local v1    # "child":Landroid/view/View;
    .end local v6    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v43    # "i":I
    .local v0, "i":I
    :goto_12
    move/from16 v0, v43

    :goto_13
    add-int/lit8 v0, v0, 0x1

    goto :goto_11

    .line 1142
    .end local v0    # "i":I
    :cond_1d
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v1

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v6

    add-int/2addr v1, v6

    add-int/2addr v0, v1

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1144
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1147
    .local v0, "widthSize":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getSuggestedMinimumWidth()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1150
    move/from16 v1, p1

    const/4 v6, 0x0

    invoke-static {v0, v1, v6}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v8

    .line 1151
    .local v8, "widthSizeAndState":I
    const v6, 0xffffff

    and-int v0, v8, v6

    .line 1156
    iget v6, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int v6, v0, v6

    .line 1157
    .local v6, "delta":I
    if-nez v22, :cond_23

    if-eqz v6, :cond_1e

    cmpl-float v26, v5, v28

    if-lez v26, :cond_1e

    .line 1158
    move/from16 v44, v0

    move/from16 v49, v2

    move/from16 v46, v4

    goto/16 :goto_16

    .line 1268
    :cond_1e
    invoke-static {v3, v9}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1272
    if-eqz v14, :cond_22

    const/high16 v15, 0x40000000    # 2.0f

    if-eq v12, v15, :cond_22

    .line 1273
    const/16 v16, 0x0

    .line 1273
    .local v16, "i":I
    :goto_14
    move/from16 v15, v16

    .line 1273
    .end local v16    # "i":I
    .local v15, "i":I
    if-ge v15, v11, :cond_22

    .line 1274
    move/from16 v44, v0

    invoke-virtual {v7, v15}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v0

    .line 1276
    .local v0, "child":Landroid/view/View;
    .local v44, "widthSize":I
    if-eqz v0, :cond_21

    move/from16 v45, v3

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v3

    .line 1276
    .end local v3    # "alternativeMaxHeight":I
    .local v45, "alternativeMaxHeight":I
    move/from16 v46, v4

    const/16 v4, 0x8

    if-ne v3, v4, :cond_1f

    .line 1277
    .end local v4    # "maxHeight":I
    .local v46, "maxHeight":I
    nop

    .line 1273
    move/from16 v49, v2

    goto :goto_15

    .line 1280
    :cond_1f
    nop

    .line 1281
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1283
    .local v3, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v4, v3, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    .line 1284
    .local v4, "childExtra":F
    cmpl-float v16, v4, v28

    if-lez v16, :cond_20

    .line 1285
    nop

    .line 1286
    move-object/from16 v47, v3

    move/from16 v48, v4

    const/high16 v3, 0x40000000    # 2.0f

    invoke-static {v2, v3}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v4

    .line 1287
    .end local v3    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v4    # "childExtra":F
    .local v47, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v48, "childExtra":F
    move/from16 v49, v2

    invoke-virtual {v0}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    .line 1287
    .end local v2    # "largestChildWidth":I
    .local v49, "largestChildWidth":I
    invoke-static {v2, v3}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v2

    .line 1285
    invoke-virtual {v0, v4, v2}, Landroid/view/View;->measure(II)V

    .line 1285
    .end local v0    # "child":Landroid/view/View;
    .end local v47    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v48    # "childExtra":F
    goto :goto_15

    .line 1273
    .end local v49    # "largestChildWidth":I
    .restart local v2    # "largestChildWidth":I
    :cond_20
    move/from16 v49, v2

    .line 1273
    .end local v2    # "largestChildWidth":I
    .restart local v49    # "largestChildWidth":I
    goto :goto_15

    .line 1273
    .end local v45    # "alternativeMaxHeight":I
    .end local v46    # "maxHeight":I
    .end local v49    # "largestChildWidth":I
    .restart local v2    # "largestChildWidth":I
    .local v3, "alternativeMaxHeight":I
    .local v4, "maxHeight":I
    :cond_21
    move/from16 v49, v2

    move/from16 v45, v3

    move/from16 v46, v4

    .line 1273
    .end local v2    # "largestChildWidth":I
    .end local v3    # "alternativeMaxHeight":I
    .end local v4    # "maxHeight":I
    .restart local v45    # "alternativeMaxHeight":I
    .restart local v46    # "maxHeight":I
    .restart local v49    # "largestChildWidth":I
    :goto_15
    add-int/lit8 v16, v15, 0x1

    .line 1273
    .end local v15    # "i":I
    .restart local v16    # "i":I
    move/from16 v0, v44

    move/from16 v3, v45

    move/from16 v4, v46

    move/from16 v2, v49

    goto :goto_14

    .line 1294
    .end local v16    # "i":I
    .end local v44    # "widthSize":I
    .end local v45    # "alternativeMaxHeight":I
    .end local v46    # "maxHeight":I
    .end local v49    # "largestChildWidth":I
    .local v0, "widthSize":I
    .restart local v2    # "largestChildWidth":I
    .restart local v3    # "alternativeMaxHeight":I
    .restart local v4    # "maxHeight":I
    :cond_22
    move/from16 v44, v0

    move/from16 v49, v2

    move/from16 v45, v3

    move/from16 v46, v4

    .line 1294
    .end local v0    # "widthSize":I
    .end local v2    # "largestChildWidth":I
    .end local v3    # "alternativeMaxHeight":I
    .end local v4    # "maxHeight":I
    .restart local v44    # "widthSize":I
    .restart local v45    # "alternativeMaxHeight":I
    .restart local v46    # "maxHeight":I
    .restart local v49    # "largestChildWidth":I
    move/from16 v50, v5

    move/from16 v51, v9

    move/from16 v56, v11

    move/from16 v52, v14

    move/from16 v2, v45

    move/from16 v15, v46

    move/from16 v14, p2

    goto/16 :goto_24

    .line 1158
    .end local v44    # "widthSize":I
    .end local v45    # "alternativeMaxHeight":I
    .end local v46    # "maxHeight":I
    .end local v49    # "largestChildWidth":I
    .restart local v0    # "widthSize":I
    .restart local v2    # "largestChildWidth":I
    .restart local v3    # "alternativeMaxHeight":I
    .restart local v4    # "maxHeight":I
    :cond_23
    move/from16 v44, v0

    move/from16 v49, v2

    move/from16 v46, v4

    .line 1158
    .end local v0    # "widthSize":I
    .end local v2    # "largestChildWidth":I
    .end local v4    # "maxHeight":I
    .restart local v44    # "widthSize":I
    .restart local v46    # "maxHeight":I
    .restart local v49    # "largestChildWidth":I
    :goto_16
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    cmpl-float v0, v0, v28

    if-lez v0, :cond_24

    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    goto :goto_17

    :cond_24
    move v0, v5

    .line 1160
    .local v0, "weightSum":F
    :goto_17
    const/4 v2, -0x1

    aput v2, v10, v17

    aput v2, v10, v19

    aput v2, v10, v20

    const/4 v4, 0x0

    aput v2, v10, v4

    .line 1161
    aput v2, v23, v17

    aput v2, v23, v19

    aput v2, v23, v20

    aput v2, v23, v4

    .line 1162
    const/4 v15, -0x1

    .line 1164
    .end local v46    # "maxHeight":I
    .local v15, "maxHeight":I
    iput v4, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1166
    move v2, v3

    move/from16 v4, v42

    move v3, v0

    const/4 v0, 0x0

    .line 1166
    .end local v42    # "childState":I
    .local v0, "i":I
    .local v2, "alternativeMaxHeight":I
    .local v3, "weightSum":F
    .local v4, "childState":I
    :goto_18
    if-ge v0, v11, :cond_34

    .line 1167
    move/from16 v50, v5

    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 1169
    .local v5, "child":Landroid/view/View;
    .local v50, "totalWeight":F
    if-eqz v5, :cond_33

    move/from16 v51, v9

    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v9

    .line 1169
    .end local v9    # "weightedMaxHeight":I
    .local v51, "weightedMaxHeight":I
    move/from16 v52, v14

    const/16 v14, 0x8

    if-ne v9, v14, :cond_25

    .line 1170
    .end local v14    # "useLargestChild":Z
    .local v52, "useLargestChild":Z
    nop

    .line 1166
    move/from16 v56, v11

    move/from16 v14, p2

    const/16 v26, -0x2

    goto/16 :goto_23

    .line 1173
    :cond_25
    nop

    .line 1174
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    check-cast v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 1176
    .local v9, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v14, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    .line 1177
    .local v14, "childExtra":F
    cmpl-float v26, v14, v28

    if-lez v26, :cond_2a

    .line 1179
    int-to-float v1, v6

    mul-float/2addr v1, v14

    div-float/2addr v1, v3

    float-to-int v1, v1

    .line 1180
    .local v1, "share":I
    sub-float/2addr v3, v14

    .line 1181
    sub-int/2addr v6, v1

    .line 1183
    nop

    .line 1185
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v26

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v27

    add-int v26, v26, v27

    move/from16 v53, v3

    iget v3, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    .line 1185
    .end local v3    # "weightSum":F
    .local v53, "weightSum":F
    add-int v26, v26, v3

    iget v3, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int v3, v26, v3

    move/from16 v54, v6

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 1183
    .end local v6    # "delta":I
    .local v54, "delta":I
    move/from16 v56, v11

    move/from16 v55, v14

    const/4 v11, -0x1

    move/from16 v14, p2

    invoke-static {v14, v3, v6}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildMeasureSpec(III)I

    move-result v3

    .line 1190
    .end local v11    # "count":I
    .end local v14    # "childExtra":F
    .local v3, "childHeightMeasureSpec":I
    .local v55, "childExtra":F
    .local v56, "count":I
    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    if-nez v6, :cond_28

    const/high16 v6, 0x40000000    # 2.0f

    if-eq v12, v6, :cond_26

    goto :goto_1a

    .line 1203
    :cond_26
    if-lez v1, :cond_27

    move v11, v1

    goto :goto_19

    :cond_27
    const/4 v11, 0x0

    :goto_19
    invoke-static {v11, v6}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v11

    invoke-virtual {v5, v11, v3}, Landroid/view/View;->measure(II)V

    .line 1209
    move/from16 v57, v1

    goto :goto_1b

    .line 1193
    :cond_28
    :goto_1a
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredWidth()I

    move-result v6

    add-int/2addr v6, v1

    .line 1194
    .local v6, "childWidth":I
    if-gez v6, :cond_29

    .line 1195
    const/4 v6, 0x0

    .line 1198
    :cond_29
    nop

    .line 1199
    move/from16 v57, v1

    const/high16 v11, 0x40000000    # 2.0f

    invoke-static {v6, v11}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v1

    .line 1198
    .end local v1    # "share":I
    .local v57, "share":I
    invoke-virtual {v5, v1, v3}, Landroid/view/View;->measure(II)V

    .line 1201
    .end local v6    # "childWidth":I
    nop

    .line 1209
    :goto_1b
    nop

    .line 1210
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredState()I

    move-result v1

    const/high16 v6, -0x1000000

    and-int/2addr v1, v6

    .line 1209
    invoke-static {v4, v1}, Landroid/view/View;->combineMeasuredStates(II)I

    move-result v4

    .line 1209
    .end local v3    # "childHeightMeasureSpec":I
    .end local v57    # "share":I
    goto :goto_1c

    .line 1213
    .end local v53    # "weightSum":F
    .end local v54    # "delta":I
    .end local v55    # "childExtra":F
    .end local v56    # "count":I
    .local v3, "weightSum":F
    .local v6, "delta":I
    .restart local v11    # "count":I
    .restart local v14    # "childExtra":F
    :cond_2a
    move/from16 v56, v11

    move/from16 v55, v14

    move/from16 v14, p2

    move/from16 v53, v3

    move/from16 v54, v6

    .line 1213
    .end local v3    # "weightSum":F
    .end local v6    # "delta":I
    .end local v11    # "count":I
    .end local v14    # "childExtra":F
    .restart local v53    # "weightSum":F
    .restart local v54    # "delta":I
    .restart local v55    # "childExtra":F
    .restart local v56    # "count":I
    :goto_1c
    if-eqz v24, :cond_2b

    .line 1214
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual {v5}, Landroid/view/View;->getMeasuredWidth()I

    move-result v3

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v3, v6

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v3, v6

    .line 1215
    invoke-virtual {v7, v5}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v6

    add-int/2addr v3, v6

    add-int/2addr v1, v3

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    goto :goto_1d

    .line 1217
    :cond_2b
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1218
    .local v1, "totalLength":I
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredWidth()I

    move-result v3

    add-int/2addr v3, v1

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    add-int/2addr v3, v6

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v3, v6

    .line 1219
    invoke-virtual {v7, v5}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v6

    add-int/2addr v3, v6

    .line 1218
    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    iput v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1222
    .end local v1    # "totalLength":I
    :goto_1d
    const/high16 v1, 0x40000000    # 2.0f

    if-eq v13, v1, :cond_2c

    iget v1, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    const/4 v3, -0x1

    if-ne v1, v3, :cond_2c

    move/from16 v1, v20

    goto :goto_1e

    :cond_2c
    const/4 v1, 0x0

    .line 1225
    .local v1, "matchHeightLocally":Z
    :goto_1e
    iget v3, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    iget v6, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int/2addr v3, v6

    .line 1226
    .local v3, "margin":I
    invoke-virtual {v5}, Landroid/view/View;->getMeasuredHeight()I

    move-result v6

    add-int/2addr v6, v3

    .line 1227
    .local v6, "childHeight":I
    invoke-static {v15, v6}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 1228
    .end local v15    # "maxHeight":I
    .local v11, "maxHeight":I
    if-eqz v1, :cond_2d

    move v15, v3

    goto :goto_1f

    :cond_2d
    move v15, v6

    :goto_1f
    invoke-static {v2, v15}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 1231
    if-eqz v18, :cond_2e

    iget v15, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    move/from16 v58, v1

    const/4 v1, -0x1

    if-ne v15, v1, :cond_2f

    .line 1231
    .end local v1    # "matchHeightLocally":Z
    .local v58, "matchHeightLocally":Z
    move/from16 v1, v20

    goto :goto_20

    .line 1231
    .end local v58    # "matchHeightLocally":Z
    .restart local v1    # "matchHeightLocally":Z
    :cond_2e
    move/from16 v58, v1

    .line 1231
    .end local v1    # "matchHeightLocally":Z
    .restart local v58    # "matchHeightLocally":Z
    :cond_2f
    const/4 v1, 0x0

    .line 1233
    .end local v18    # "allFillParent":Z
    .local v1, "allFillParent":Z
    :goto_20
    if-eqz v21, :cond_32

    .line 1234
    invoke-virtual {v5}, Landroid/view/View;->getBaseline()I

    move-result v15

    .line 1235
    .local v15, "childBaseline":I
    move/from16 v59, v1

    const/4 v1, -0x1

    if-eq v15, v1, :cond_31

    .line 1237
    .end local v1    # "allFillParent":Z
    .local v59, "allFillParent":Z
    iget v1, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    if-gez v1, :cond_30

    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    goto :goto_21

    :cond_30
    iget v1, v9, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->gravity:I

    :goto_21
    and-int/lit8 v1, v1, 0x70

    .line 1239
    .local v1, "gravity":I
    shr-int/lit8 v18, v1, 0x4

    const/16 v26, -0x2

    and-int/lit8 v18, v18, -0x2

    shr-int/lit8 v18, v18, 0x1

    .line 1242
    .local v18, "index":I
    move/from16 v60, v1

    aget v1, v10, v18

    .line 1242
    .end local v1    # "gravity":I
    .local v60, "gravity":I
    invoke-static {v1, v15}, Ljava/lang/Math;->max(II)I

    move-result v1

    aput v1, v10, v18

    .line 1243
    aget v1, v23, v18

    move/from16 v61, v2

    sub-int v2, v6, v15

    .line 1243
    .end local v2    # "alternativeMaxHeight":I
    .local v61, "alternativeMaxHeight":I
    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    aput v1, v23, v18

    .line 1243
    .end local v3    # "margin":I
    .end local v5    # "child":Landroid/view/View;
    .end local v6    # "childHeight":I
    .end local v9    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v15    # "childBaseline":I
    .end local v18    # "index":I
    .end local v55    # "childExtra":F
    .end local v58    # "matchHeightLocally":Z
    .end local v60    # "gravity":I
    goto :goto_22

    .line 1166
    .end local v61    # "alternativeMaxHeight":I
    .restart local v2    # "alternativeMaxHeight":I
    :cond_31
    move/from16 v61, v2

    const/16 v26, -0x2

    .line 1166
    .end local v2    # "alternativeMaxHeight":I
    .restart local v61    # "alternativeMaxHeight":I
    goto :goto_22

    .line 1166
    .end local v59    # "allFillParent":Z
    .end local v61    # "alternativeMaxHeight":I
    .local v1, "allFillParent":Z
    .restart local v2    # "alternativeMaxHeight":I
    :cond_32
    move/from16 v59, v1

    move/from16 v61, v2

    const/16 v26, -0x2

    .line 1166
    .end local v1    # "allFillParent":Z
    .end local v2    # "alternativeMaxHeight":I
    .restart local v59    # "allFillParent":Z
    .restart local v61    # "alternativeMaxHeight":I
    :goto_22
    move v15, v11

    move/from16 v3, v53

    move/from16 v6, v54

    move/from16 v18, v59

    move/from16 v2, v61

    goto :goto_23

    .line 1166
    .end local v51    # "weightedMaxHeight":I
    .end local v52    # "useLargestChild":Z
    .end local v53    # "weightSum":F
    .end local v54    # "delta":I
    .end local v56    # "count":I
    .end local v59    # "allFillParent":Z
    .end local v61    # "alternativeMaxHeight":I
    .restart local v2    # "alternativeMaxHeight":I
    .local v3, "weightSum":F
    .local v6, "delta":I
    .local v9, "weightedMaxHeight":I
    .local v11, "count":I
    .local v14, "useLargestChild":Z
    .local v15, "maxHeight":I
    .local v18, "allFillParent":Z
    :cond_33
    move/from16 v51, v9

    move/from16 v56, v11

    move/from16 v52, v14

    move/from16 v14, p2

    const/16 v26, -0x2

    .line 1166
    .end local v9    # "weightedMaxHeight":I
    .end local v11    # "count":I
    .end local v14    # "useLargestChild":Z
    .restart local v51    # "weightedMaxHeight":I
    .restart local v52    # "useLargestChild":Z
    .restart local v56    # "count":I
    :goto_23
    add-int/lit8 v0, v0, 0x1

    move/from16 v5, v50

    move/from16 v9, v51

    move/from16 v14, v52

    move/from16 v11, v56

    move/from16 v1, p1

    goto/16 :goto_18

    .line 1250
    .end local v0    # "i":I
    .end local v50    # "totalWeight":F
    .end local v51    # "weightedMaxHeight":I
    .end local v52    # "useLargestChild":Z
    .end local v56    # "count":I
    .local v5, "totalWeight":F
    .restart local v9    # "weightedMaxHeight":I
    .restart local v11    # "count":I
    .restart local v14    # "useLargestChild":Z
    :cond_34
    move/from16 v50, v5

    move/from16 v51, v9

    move/from16 v56, v11

    move/from16 v52, v14

    move/from16 v14, p2

    .line 1250
    .end local v5    # "totalWeight":F
    .end local v9    # "weightedMaxHeight":I
    .end local v11    # "count":I
    .end local v14    # "useLargestChild":Z
    .restart local v50    # "totalWeight":F
    .restart local v51    # "weightedMaxHeight":I
    .restart local v52    # "useLargestChild":Z
    .restart local v56    # "count":I
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v1

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v5

    add-int/2addr v1, v5

    add-int/2addr v0, v1

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 1255
    aget v0, v10, v20

    const/4 v1, -0x1

    if-ne v0, v1, :cond_35

    const/4 v0, 0x0

    aget v5, v10, v0

    if-ne v5, v1, :cond_35

    aget v0, v10, v19

    if-ne v0, v1, :cond_35

    aget v0, v10, v17

    if-eq v0, v1, :cond_36

    .line 1259
    :cond_35
    aget v0, v10, v17

    const/4 v1, 0x0

    aget v5, v10, v1

    aget v9, v10, v20

    aget v11, v10, v19

    .line 1261
    invoke-static {v9, v11}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 1260
    invoke-static {v5, v9}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1259
    invoke-static {v0, v5}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1262
    .local v0, "ascent":I
    aget v5, v23, v17

    aget v1, v23, v1

    aget v9, v23, v20

    aget v11, v23, v19

    .line 1264
    invoke-static {v9, v11}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 1263
    invoke-static {v1, v9}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1262
    invoke-static {v5, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1265
    .local v1, "descent":I
    add-int v5, v0, v1

    invoke-static {v15, v5}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1267
    .end local v1    # "descent":I
    .end local v3    # "weightSum":F
    .end local v15    # "maxHeight":I
    .local v0, "maxHeight":I
    move v15, v0

    .line 1294
    .end local v0    # "maxHeight":I
    .restart local v15    # "maxHeight":I
    :cond_36
    move/from16 v42, v4

    .line 1294
    .end local v4    # "childState":I
    .restart local v42    # "childState":I
    :goto_24
    if-nez v18, :cond_37

    const/high16 v0, 0x40000000    # 2.0f

    if-eq v13, v0, :cond_37

    .line 1295
    move v15, v2

    .line 1298
    :cond_37
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v0

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v1

    add-int/2addr v0, v1

    add-int/2addr v15, v0

    .line 1301
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getSuggestedMinimumHeight()I

    move-result v0

    invoke-static {v15, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1303
    .end local v15    # "maxHeight":I
    .restart local v0    # "maxHeight":I
    const/high16 v1, -0x1000000

    and-int v1, v42, v1

    or-int/2addr v1, v8

    shl-int/lit8 v3, v42, 0x10

    .line 1304
    invoke-static {v0, v14, v3}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v3

    .line 1303
    invoke-virtual {v7, v1, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->setMeasuredDimension(II)V

    .line 1307
    if-eqz v25, :cond_38

    .line 1308
    move/from16 v3, v56

    move/from16 v1, p1

    invoke-direct {v7, v3, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->forceUniformHeight(II)V

    goto :goto_25

    .line 1310
    :cond_38
    move/from16 v3, v56

    move/from16 v1, p1

    .line 1310
    .end local v56    # "count":I
    .local v3, "count":I
    :goto_25
    return-void
.end method

.method measureNullChild(I)I
    .locals 1
    .param p1, "childIndex"    # I

    .line 1357
    const/4 v0, 0x0

    return v0
.end method

.method measureVertical(II)V
    .locals 57
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v7, p0

    move/from16 v8, p1

    .line 594
    move/from16 v9, p2

    const/4 v10, 0x0

    iput v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 595
    const/4 v0, 0x0

    .line 596
    .local v0, "maxWidth":I
    const/4 v1, 0x0

    .line 597
    .local v1, "childState":I
    const/4 v2, 0x0

    .line 598
    .local v2, "alternativeMaxWidth":I
    const/4 v3, 0x0

    .line 599
    .local v3, "weightedMaxWidth":I
    const/4 v4, 0x1

    .line 600
    .local v4, "allFillParent":Z
    const/4 v5, 0x0

    .line 602
    .local v5, "totalWeight":F
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildCount()I

    move-result v11

    .line 604
    .local v11, "count":I
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v12

    .line 605
    .local v12, "widthMode":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v13

    .line 607
    .local v13, "heightMode":I
    const/4 v6, 0x0

    .line 608
    .local v6, "matchWidth":Z
    const/4 v14, 0x0

    .line 610
    .local v14, "skippedMeasure":Z
    iget v15, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    .line 611
    .local v15, "baselineChildIndex":I
    iget-boolean v10, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mUseLargestChild:Z

    .line 613
    .local v10, "useLargestChild":Z
    const/high16 v17, -0x80000000

    .line 616
    .local v17, "largestChildHeight":I
    move/from16 v18, v6

    move v6, v2

    move v2, v0

    const/4 v0, 0x0

    move/from16 v56, v4

    move v4, v3

    move/from16 v3, v17

    move/from16 v17, v56

    .line 616
    .local v0, "i":I
    .local v2, "maxWidth":I
    .local v3, "largestChildHeight":I
    .local v4, "weightedMaxWidth":I
    .local v6, "alternativeMaxWidth":I
    .local v17, "allFillParent":Z
    .local v18, "matchWidth":Z
    :goto_0
    move/from16 v19, v4

    .line 616
    .end local v4    # "weightedMaxWidth":I
    .local v19, "weightedMaxWidth":I
    const/16 v21, 0x1

    const/16 v22, 0x0

    if-ge v0, v11, :cond_11

    .line 617
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 619
    .local v4, "child":Landroid/view/View;
    if-nez v4, :cond_0

    .line 620
    move/from16 v25, v1

    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 620
    .end local v1    # "childState":I
    .local v25, "childState":I
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v20

    add-int v1, v1, v20

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 621
    nop

    .line 616
    move/from16 v34, v11

    move/from16 v33, v13

    move/from16 v4, v19

    move/from16 v1, v25

    goto/16 :goto_a

    .line 624
    .end local v25    # "childState":I
    .restart local v1    # "childState":I
    :cond_0
    move/from16 v25, v1

    .line 624
    .end local v1    # "childState":I
    .restart local v25    # "childState":I
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v1

    move/from16 v26, v2

    const/16 v2, 0x8

    if-ne v1, v2, :cond_1

    .line 625
    .end local v2    # "maxWidth":I
    .local v26, "maxWidth":I
    invoke-virtual {v7, v4, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v1

    add-int/2addr v0, v1

    .line 626
    nop

    .line 616
    move/from16 v34, v11

    move/from16 v33, v13

    move/from16 v4, v19

    move/from16 v1, v25

    move/from16 v2, v26

    goto/16 :goto_a

    .line 629
    :cond_1
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 630
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    add-int/2addr v1, v2

    iput v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 633
    :cond_2
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 635
    .local v2, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    add-float v23, v5, v1

    .line 637
    .end local v5    # "totalWeight":F
    .local v23, "totalWeight":F
    const/high16 v5, 0x40000000    # 2.0f

    if-ne v13, v5, :cond_3

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    if-nez v1, :cond_3

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v1, v1, v22

    if-lez v1, :cond_3

    .line 641
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 642
    .local v1, "totalLength":I
    iget v5, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int/2addr v5, v1

    move/from16 v27, v0

    iget v0, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    .line 642
    .end local v0    # "i":I
    .local v27, "i":I
    add-int/2addr v5, v0

    invoke-static {v1, v5}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 643
    const/4 v14, 0x1

    .line 644
    .end local v1    # "totalLength":I
    nop

    .line 682
    move-object v0, v2

    move-object v8, v4

    move v9, v6

    move/from16 v34, v11

    move/from16 v33, v13

    move/from16 v30, v14

    move/from16 v35, v19

    move/from16 v14, v25

    move/from16 v32, v26

    move/from16 v29, v27

    goto/16 :goto_3

    .line 645
    .end local v27    # "i":I
    .restart local v0    # "i":I
    :cond_3
    move/from16 v27, v0

    .line 645
    .end local v0    # "i":I
    .restart local v27    # "i":I
    const/high16 v0, -0x80000000

    .line 647
    .local v0, "oldHeight":I
    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    if-nez v1, :cond_4

    iget v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v1, v1, v22

    if-lez v1, :cond_4

    .line 652
    const/4 v0, 0x0

    .line 653
    const/4 v1, -0x2

    iput v1, v2, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    .line 660
    .end local v0    # "oldHeight":I
    .local v5, "oldHeight":I
    :cond_4
    move v5, v0

    const/16 v24, 0x0

    cmpl-float v0, v23, v22

    if-nez v0, :cond_5

    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    move/from16 v28, v0

    goto :goto_1

    :cond_5
    const/16 v28, 0x0

    :goto_1
    move/from16 v1, v27

    move-object v0, v7

    .line 660
    .end local v27    # "i":I
    .local v1, "i":I
    move/from16 v29, v1

    move/from16 v30, v14

    move/from16 v14, v25

    move-object v1, v4

    .line 660
    .end local v1    # "i":I
    .end local v25    # "childState":I
    .local v14, "childState":I
    .local v29, "i":I
    .local v30, "skippedMeasure":Z
    move-object/from16 v31, v2

    move/from16 v32, v26

    move/from16 v2, v29

    .line 660
    .end local v2    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v26    # "maxWidth":I
    .local v31, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v32, "maxWidth":I
    move/from16 v33, v13

    move v13, v3

    move v3, v8

    .line 660
    .end local v3    # "largestChildHeight":I
    .local v13, "largestChildHeight":I
    .local v33, "heightMode":I
    move-object v8, v4

    move/from16 v34, v11

    move/from16 v35, v19

    const/high16 v11, -0x80000000

    move/from16 v4, v24

    .line 660
    .end local v4    # "child":Landroid/view/View;
    .end local v11    # "count":I
    .end local v19    # "weightedMaxWidth":I
    .local v8, "child":Landroid/view/View;
    .local v34, "count":I
    .local v35, "weightedMaxWidth":I
    move v11, v5

    move v5, v9

    .line 660
    .end local v5    # "oldHeight":I
    .local v11, "oldHeight":I
    move v9, v6

    move/from16 v6, v28

    .line 660
    .end local v6    # "alternativeMaxWidth":I
    .local v9, "alternativeMaxWidth":I
    invoke-virtual/range {v0 .. v6}, Landroid/support/v7/widget/LinearLayoutCompat;->measureChildBeforeLayout(Landroid/view/View;IIIII)V

    .line 664
    const/high16 v0, -0x80000000

    if-eq v11, v0, :cond_6

    .line 665
    move-object/from16 v0, v31

    iput v11, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    goto :goto_2

    .line 668
    :cond_6
    move-object/from16 v0, v31

    .line 668
    .end local v31    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v0, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    :goto_2
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredHeight()I

    move-result v1

    .line 669
    .local v1, "childHeight":I
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 670
    .local v2, "totalLength":I
    add-int v3, v2, v1

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    add-int/2addr v3, v4

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int/2addr v3, v4

    .line 671
    invoke-virtual {v7, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v4

    add-int/2addr v3, v4

    .line 670
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    iput v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 673
    if-eqz v10, :cond_7

    .line 674
    invoke-static {v1, v13}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 674
    .end local v1    # "childHeight":I
    .end local v2    # "totalLength":I
    .end local v11    # "oldHeight":I
    .end local v13    # "largestChildHeight":I
    .restart local v3    # "largestChildHeight":I
    goto :goto_3

    .line 682
    .end local v3    # "largestChildHeight":I
    .restart local v13    # "largestChildHeight":I
    :cond_7
    move v3, v13

    .line 682
    .end local v13    # "largestChildHeight":I
    .restart local v3    # "largestChildHeight":I
    :goto_3
    if-ltz v15, :cond_8

    move/from16 v1, v29

    add-int/lit8 v2, v1, 0x1

    .line 682
    .end local v29    # "i":I
    .local v1, "i":I
    if-ne v15, v2, :cond_9

    .line 683
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iput v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineChildTop:I

    goto :goto_4

    .line 689
    .end local v1    # "i":I
    .restart local v29    # "i":I
    :cond_8
    move/from16 v1, v29

    .line 689
    .end local v29    # "i":I
    .restart local v1    # "i":I
    :cond_9
    :goto_4
    if-ge v1, v15, :cond_a

    iget v2, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v2, v2, v22

    if-lez v2, :cond_a

    .line 690
    new-instance v2, Ljava/lang/RuntimeException;

    const-string v4, "A child of LinearLayout with index less than mBaselineAlignedChildIndex has weight > 0, which won\'t work.  Either remove the weight, or don\'t set mBaselineAlignedChildIndex."

    invoke-direct {v2, v4}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 696
    :cond_a
    const/4 v2, 0x0

    .line 697
    .local v2, "matchWidthLocally":Z
    const/high16 v4, 0x40000000    # 2.0f

    if-eq v12, v4, :cond_b

    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    const/4 v6, -0x1

    if-ne v4, v6, :cond_c

    .line 702
    const/16 v18, 0x1

    .line 703
    const/4 v2, 0x1

    goto :goto_5

    .line 706
    :cond_b
    const/4 v6, -0x1

    :cond_c
    :goto_5
    iget v4, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    iget v5, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v4, v5

    .line 707
    .local v4, "margin":I
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    add-int/2addr v5, v4

    .line 708
    .local v5, "measuredWidth":I
    move/from16 v11, v32

    invoke-static {v11, v5}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 709
    .end local v32    # "maxWidth":I
    .local v11, "maxWidth":I
    nop

    .line 710
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredState()I

    move-result v13

    .line 709
    invoke-static {v14, v13}, Landroid/view/View;->combineMeasuredStates(II)I

    move-result v13

    .line 712
    .end local v14    # "childState":I
    .local v13, "childState":I
    if-eqz v17, :cond_d

    iget v14, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    if-ne v14, v6, :cond_d

    move/from16 v6, v21

    goto :goto_6

    :cond_d
    const/4 v6, 0x0

    .line 713
    .end local v17    # "allFillParent":Z
    .local v6, "allFillParent":Z
    :goto_6
    iget v14, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    cmpl-float v14, v14, v22

    if-lez v14, :cond_f

    .line 718
    if-eqz v2, :cond_e

    move v14, v4

    goto :goto_7

    :cond_e
    move v14, v5

    :goto_7
    move/from16 v36, v6

    move/from16 v6, v35

    invoke-static {v6, v14}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 718
    .end local v35    # "weightedMaxWidth":I
    .local v6, "weightedMaxWidth":I
    .local v36, "allFillParent":Z
    goto :goto_9

    .line 721
    .end local v36    # "allFillParent":Z
    .local v6, "allFillParent":Z
    .restart local v35    # "weightedMaxWidth":I
    :cond_f
    move/from16 v36, v6

    move/from16 v6, v35

    .line 721
    .end local v35    # "weightedMaxWidth":I
    .local v6, "weightedMaxWidth":I
    .restart local v36    # "allFillParent":Z
    if-eqz v2, :cond_10

    move v14, v4

    goto :goto_8

    :cond_10
    move v14, v5

    :goto_8
    invoke-static {v9, v14}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 725
    :goto_9
    invoke-virtual {v7, v8, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v14

    add-int v0, v1, v14

    .line 616
    .end local v1    # "i":I
    .end local v2    # "matchWidthLocally":Z
    .end local v4    # "margin":I
    .end local v5    # "measuredWidth":I
    .end local v8    # "child":Landroid/view/View;
    .local v0, "i":I
    move v4, v6

    move v6, v9

    move v2, v11

    move v1, v13

    move/from16 v5, v23

    move/from16 v14, v30

    move/from16 v17, v36

    .line 616
    .end local v9    # "alternativeMaxWidth":I
    .end local v11    # "maxWidth":I
    .end local v13    # "childState":I
    .end local v23    # "totalWeight":F
    .end local v30    # "skippedMeasure":Z
    .end local v36    # "allFillParent":Z
    .local v1, "childState":I
    .local v2, "maxWidth":I
    .local v4, "weightedMaxWidth":I
    .local v5, "totalWeight":F
    .local v6, "alternativeMaxWidth":I
    .local v14, "skippedMeasure":Z
    .restart local v17    # "allFillParent":Z
    :goto_a
    add-int/lit8 v0, v0, 0x1

    move/from16 v13, v33

    move/from16 v11, v34

    move/from16 v8, p1

    move/from16 v9, p2

    goto/16 :goto_0

    .line 728
    .end local v0    # "i":I
    .end local v4    # "weightedMaxWidth":I
    .end local v33    # "heightMode":I
    .end local v34    # "count":I
    .local v11, "count":I
    .local v13, "heightMode":I
    .restart local v19    # "weightedMaxWidth":I
    :cond_11
    move v9, v6

    move/from16 v34, v11

    move/from16 v33, v13

    move/from16 v30, v14

    move/from16 v6, v19

    const/4 v0, -0x1

    move v14, v1

    move v11, v2

    move v13, v3

    .line 728
    .end local v1    # "childState":I
    .end local v2    # "maxWidth":I
    .end local v3    # "largestChildHeight":I
    .end local v19    # "weightedMaxWidth":I
    .local v6, "weightedMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    .local v11, "maxWidth":I
    .local v13, "largestChildHeight":I
    .local v14, "childState":I
    .restart local v30    # "skippedMeasure":Z
    .restart local v33    # "heightMode":I
    .restart local v34    # "count":I
    iget v1, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    if-lez v1, :cond_12

    move/from16 v1, v34

    invoke-virtual {v7, v1}, Landroid/support/v7/widget/LinearLayoutCompat;->hasDividerBeforeChildAt(I)Z

    move-result v2

    .line 728
    .end local v34    # "count":I
    .local v1, "count":I
    if-eqz v2, :cond_13

    .line 729
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    iget v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    add-int/2addr v2, v3

    iput v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    goto :goto_b

    .line 732
    .end local v1    # "count":I
    .restart local v34    # "count":I
    :cond_12
    move/from16 v1, v34

    .line 732
    .end local v34    # "count":I
    .restart local v1    # "count":I
    :cond_13
    :goto_b
    if-eqz v10, :cond_17

    move/from16 v2, v33

    const/high16 v3, -0x80000000

    if-eq v2, v3, :cond_14

    .line 732
    .end local v33    # "heightMode":I
    .local v2, "heightMode":I
    if-nez v2, :cond_18

    .line 734
    :cond_14
    const/4 v3, 0x0

    iput v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 736
    const/4 v3, 0x0

    .line 736
    .local v3, "i":I
    :goto_c
    if-ge v3, v1, :cond_18

    .line 737
    invoke-virtual {v7, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 739
    .local v4, "child":Landroid/view/View;
    if-nez v4, :cond_15

    .line 740
    iget v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual {v7, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->measureNullChild(I)I

    move-result v19

    add-int v8, v8, v19

    iput v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 741
    goto :goto_d

    .line 744
    :cond_15
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v8

    const/16 v0, 0x8

    if-ne v8, v0, :cond_16

    .line 745
    invoke-virtual {v7, v4, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildrenSkipCount(Landroid/view/View;I)I

    move-result v0

    add-int/2addr v3, v0

    .line 746
    nop

    .line 736
    .end local v3    # "i":I
    .end local v4    # "child":Landroid/view/View;
    .local v37, "i":I
    :goto_d
    move/from16 v37, v3

    goto :goto_e

    .line 749
    .end local v37    # "i":I
    .restart local v3    # "i":I
    .restart local v4    # "child":Landroid/view/View;
    :cond_16
    nop

    .line 750
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 752
    .local v0, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v8, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 753
    .local v8, "totalLength":I
    add-int v19, v8, v13

    move/from16 v37, v3

    iget v3, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    .line 753
    .end local v3    # "i":I
    .restart local v37    # "i":I
    add-int v19, v19, v3

    iget v3, v0, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int v19, v19, v3

    .line 754
    invoke-virtual {v7, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v3

    add-int v3, v19, v3

    .line 753
    invoke-static {v8, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    iput v3, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 736
    .end local v0    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v4    # "child":Landroid/view/View;
    .end local v8    # "totalLength":I
    :goto_e
    add-int/lit8 v3, v37, 0x1

    .line 736
    .end local v37    # "i":I
    .restart local v3    # "i":I
    const/4 v0, -0x1

    goto :goto_c

    .line 759
    .end local v2    # "heightMode":I
    .end local v3    # "i":I
    .restart local v33    # "heightMode":I
    :cond_17
    move/from16 v2, v33

    .line 759
    .end local v33    # "heightMode":I
    .restart local v2    # "heightMode":I
    :cond_18
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v3

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v4

    add-int/2addr v3, v4

    add-int/2addr v0, v3

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 761
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 764
    .local v0, "heightSize":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getSuggestedMinimumHeight()I

    move-result v3

    invoke-static {v0, v3}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 767
    move/from16 v3, p2

    const/4 v4, 0x0

    invoke-static {v0, v3, v4}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v8

    .line 768
    .local v8, "heightSizeAndState":I
    const v4, 0xffffff

    and-int v0, v8, v4

    .line 773
    iget v4, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    sub-int v4, v0, v4

    .line 774
    .local v4, "delta":I
    if-nez v30, :cond_1f

    if-eqz v4, :cond_19

    cmpl-float v19, v5, v22

    if-lez v19, :cond_19

    .line 775
    move/from16 v38, v0

    move/from16 v39, v4

    move/from16 v40, v5

    move/from16 v41, v6

    goto/16 :goto_12

    .line 846
    :cond_19
    invoke-static {v9, v6}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 852
    if-eqz v10, :cond_1e

    move/from16 v38, v0

    const/high16 v0, 0x40000000    # 2.0f

    if-eq v2, v0, :cond_1d

    .line 853
    .end local v0    # "heightSize":I
    .local v38, "heightSize":I
    const/16 v16, 0x0

    .line 853
    .local v16, "i":I
    :goto_f
    move/from16 v0, v16

    .line 853
    .end local v16    # "i":I
    .local v0, "i":I
    if-ge v0, v1, :cond_1d

    .line 854
    move/from16 v39, v4

    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 856
    .local v4, "child":Landroid/view/View;
    .local v39, "delta":I
    if-eqz v4, :cond_1c

    move/from16 v40, v5

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    .line 856
    .end local v5    # "totalWeight":F
    .local v40, "totalWeight":F
    move/from16 v41, v6

    const/16 v6, 0x8

    if-ne v5, v6, :cond_1a

    .line 857
    .end local v6    # "weightedMaxWidth":I
    .local v41, "weightedMaxWidth":I
    nop

    .line 853
    move/from16 v44, v9

    goto :goto_10

    .line 860
    :cond_1a
    nop

    .line 861
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    check-cast v5, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 863
    .local v5, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v6, v5, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    .line 864
    .local v6, "childExtra":F
    cmpl-float v16, v6, v22

    if-lez v16, :cond_1b

    .line 865
    nop

    .line 866
    move-object/from16 v42, v5

    invoke-virtual {v4}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    .line 866
    .end local v5    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .local v42, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    move/from16 v43, v6

    const/high16 v6, 0x40000000    # 2.0f

    invoke-static {v5, v6}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v5

    .line 868
    .end local v6    # "childExtra":F
    .local v43, "childExtra":F
    move/from16 v44, v9

    invoke-static {v13, v6}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v9

    .line 865
    .end local v9    # "alternativeMaxWidth":I
    .local v44, "alternativeMaxWidth":I
    invoke-virtual {v4, v5, v9}, Landroid/view/View;->measure(II)V

    .line 865
    .end local v4    # "child":Landroid/view/View;
    .end local v42    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v43    # "childExtra":F
    goto :goto_10

    .line 853
    .end local v44    # "alternativeMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    :cond_1b
    move/from16 v44, v9

    .line 853
    .end local v9    # "alternativeMaxWidth":I
    .restart local v44    # "alternativeMaxWidth":I
    goto :goto_10

    .line 853
    .end local v40    # "totalWeight":F
    .end local v41    # "weightedMaxWidth":I
    .end local v44    # "alternativeMaxWidth":I
    .local v5, "totalWeight":F
    .local v6, "weightedMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    :cond_1c
    move/from16 v40, v5

    move/from16 v41, v6

    move/from16 v44, v9

    .line 853
    .end local v5    # "totalWeight":F
    .end local v6    # "weightedMaxWidth":I
    .end local v9    # "alternativeMaxWidth":I
    .restart local v40    # "totalWeight":F
    .restart local v41    # "weightedMaxWidth":I
    .restart local v44    # "alternativeMaxWidth":I
    :goto_10
    add-int/lit8 v16, v0, 0x1

    .line 853
    .end local v0    # "i":I
    .restart local v16    # "i":I
    move/from16 v4, v39

    move/from16 v5, v40

    move/from16 v6, v41

    move/from16 v9, v44

    goto :goto_f

    .line 875
    .end local v16    # "i":I
    .end local v39    # "delta":I
    .end local v40    # "totalWeight":F
    .end local v41    # "weightedMaxWidth":I
    .end local v44    # "alternativeMaxWidth":I
    .local v4, "delta":I
    .restart local v5    # "totalWeight":F
    .restart local v6    # "weightedMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    :cond_1d
    move/from16 v39, v4

    move/from16 v40, v5

    move/from16 v41, v6

    move/from16 v44, v9

    .line 875
    .end local v4    # "delta":I
    .end local v5    # "totalWeight":F
    .end local v6    # "weightedMaxWidth":I
    .end local v9    # "alternativeMaxWidth":I
    .restart local v39    # "delta":I
    .restart local v40    # "totalWeight":F
    .restart local v41    # "weightedMaxWidth":I
    .restart local v44    # "alternativeMaxWidth":I
    goto :goto_11

    .line 875
    .end local v38    # "heightSize":I
    .end local v39    # "delta":I
    .end local v40    # "totalWeight":F
    .end local v41    # "weightedMaxWidth":I
    .end local v44    # "alternativeMaxWidth":I
    .local v0, "heightSize":I
    .restart local v4    # "delta":I
    .restart local v5    # "totalWeight":F
    .restart local v6    # "weightedMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    :cond_1e
    move/from16 v38, v0

    move/from16 v39, v4

    move/from16 v40, v5

    move/from16 v41, v6

    move/from16 v44, v9

    .line 875
    .end local v0    # "heightSize":I
    .end local v4    # "delta":I
    .end local v5    # "totalWeight":F
    .end local v6    # "weightedMaxWidth":I
    .end local v9    # "alternativeMaxWidth":I
    .restart local v38    # "heightSize":I
    .restart local v39    # "delta":I
    .restart local v40    # "totalWeight":F
    .restart local v41    # "weightedMaxWidth":I
    .restart local v44    # "alternativeMaxWidth":I
    :goto_11
    move/from16 v51, v2

    move/from16 v45, v10

    move/from16 v46, v13

    move/from16 v47, v15

    move/from16 v13, p1

    goto/16 :goto_1d

    .line 775
    .end local v38    # "heightSize":I
    .end local v39    # "delta":I
    .end local v40    # "totalWeight":F
    .end local v41    # "weightedMaxWidth":I
    .end local v44    # "alternativeMaxWidth":I
    .restart local v0    # "heightSize":I
    .restart local v4    # "delta":I
    .restart local v5    # "totalWeight":F
    .restart local v6    # "weightedMaxWidth":I
    .restart local v9    # "alternativeMaxWidth":I
    :cond_1f
    move/from16 v38, v0

    move/from16 v39, v4

    move/from16 v40, v5

    move/from16 v41, v6

    .line 775
    .end local v0    # "heightSize":I
    .end local v4    # "delta":I
    .end local v5    # "totalWeight":F
    .end local v6    # "weightedMaxWidth":I
    .restart local v38    # "heightSize":I
    .restart local v39    # "delta":I
    .restart local v40    # "totalWeight":F
    .restart local v41    # "weightedMaxWidth":I
    :goto_12
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    cmpl-float v0, v0, v22

    if-lez v0, :cond_20

    iget v5, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    goto :goto_13

    :cond_20
    move/from16 v5, v40

    :goto_13
    move v0, v5

    .line 777
    .local v0, "weightSum":F
    const/4 v4, 0x0

    iput v4, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 779
    move v0, v4

    move/from16 v6, v39

    .line 779
    .end local v39    # "delta":I
    .local v0, "i":I
    .local v5, "weightSum":F
    .local v6, "delta":I
    :goto_14
    if-ge v0, v1, :cond_2c

    .line 780
    invoke-virtual {v7, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->getVirtualChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 782
    .local v4, "child":Landroid/view/View;
    move/from16 v45, v10

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v10

    .line 782
    .end local v10    # "useLargestChild":Z
    .local v45, "useLargestChild":Z
    move/from16 v46, v13

    const/16 v13, 0x8

    if-ne v10, v13, :cond_21

    .line 783
    .end local v13    # "largestChildHeight":I
    .local v46, "largestChildHeight":I
    nop

    .line 779
    move/from16 v51, v2

    move/from16 v47, v15

    move/from16 v13, p1

    goto/16 :goto_1c

    .line 786
    :cond_21
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v10

    check-cast v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;

    .line 788
    .local v10, "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    iget v13, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->weight:F

    .line 789
    .local v13, "childExtra":F
    cmpl-float v16, v13, v22

    if-lez v16, :cond_26

    .line 791
    move/from16 v47, v15

    int-to-float v15, v6

    .line 791
    .end local v15    # "baselineChildIndex":I
    .local v47, "baselineChildIndex":I
    mul-float/2addr v15, v13

    div-float/2addr v15, v5

    float-to-int v15, v15

    .line 792
    .local v15, "share":I
    sub-float/2addr v5, v13

    .line 793
    sub-int/2addr v6, v15

    .line 795
    nop

    .line 796
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v16

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v19

    add-int v16, v16, v19

    move/from16 v48, v5

    iget v5, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    .line 796
    .end local v5    # "weightSum":F
    .local v48, "weightSum":F
    add-int v16, v16, v5

    iget v5, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int v5, v16, v5

    move/from16 v49, v6

    iget v6, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    .line 795
    .end local v6    # "delta":I
    .local v49, "delta":I
    move/from16 v50, v13

    move/from16 v13, p1

    invoke-static {v13, v5, v6}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildMeasureSpec(III)I

    move-result v5

    .line 801
    .end local v13    # "childExtra":F
    .local v5, "childWidthMeasureSpec":I
    .local v50, "childExtra":F
    iget v6, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->height:I

    if-nez v6, :cond_24

    const/high16 v6, 0x40000000    # 2.0f

    if-eq v2, v6, :cond_22

    .line 804
    move/from16 v51, v2

    goto :goto_16

    .line 814
    :cond_22
    if-lez v15, :cond_23

    move v6, v15

    goto :goto_15

    :cond_23
    const/4 v6, 0x0

    .line 815
    :goto_15
    move/from16 v51, v2

    const/high16 v2, 0x40000000    # 2.0f

    invoke-static {v6, v2}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v6

    .line 814
    .end local v2    # "heightMode":I
    .local v51, "heightMode":I
    invoke-virtual {v4, v5, v6}, Landroid/view/View;->measure(II)V

    .line 820
    move/from16 v52, v15

    goto :goto_17

    .line 804
    .end local v51    # "heightMode":I
    .restart local v2    # "heightMode":I
    :cond_24
    move/from16 v51, v2

    .line 804
    .end local v2    # "heightMode":I
    .restart local v51    # "heightMode":I
    :goto_16
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    add-int/2addr v2, v15

    .line 805
    .local v2, "childHeight":I
    if-gez v2, :cond_25

    .line 806
    const/4 v2, 0x0

    .line 809
    :cond_25
    nop

    .line 810
    move/from16 v52, v15

    const/high16 v6, 0x40000000    # 2.0f

    invoke-static {v2, v6}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v15

    .line 809
    .end local v15    # "share":I
    .local v52, "share":I
    invoke-virtual {v4, v5, v15}, Landroid/view/View;->measure(II)V

    .line 811
    .end local v2    # "childHeight":I
    nop

    .line 820
    :goto_17
    nop

    .line 821
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredState()I

    move-result v2

    and-int/lit16 v2, v2, -0x100

    .line 820
    invoke-static {v14, v2}, Landroid/view/View;->combineMeasuredStates(II)I

    move-result v14

    .line 825
    .end local v5    # "childWidthMeasureSpec":I
    .end local v52    # "share":I
    move/from16 v5, v48

    goto :goto_18

    .line 825
    .end local v47    # "baselineChildIndex":I
    .end local v48    # "weightSum":F
    .end local v49    # "delta":I
    .end local v50    # "childExtra":F
    .end local v51    # "heightMode":I
    .local v2, "heightMode":I
    .local v5, "weightSum":F
    .restart local v6    # "delta":I
    .restart local v13    # "childExtra":F
    .local v15, "baselineChildIndex":I
    :cond_26
    move/from16 v51, v2

    move/from16 v50, v13

    move/from16 v47, v15

    move/from16 v13, p1

    move/from16 v49, v6

    .line 825
    .end local v2    # "heightMode":I
    .end local v6    # "delta":I
    .end local v13    # "childExtra":F
    .end local v15    # "baselineChildIndex":I
    .restart local v47    # "baselineChildIndex":I
    .restart local v49    # "delta":I
    .restart local v50    # "childExtra":F
    .restart local v51    # "heightMode":I
    :goto_18
    iget v2, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->leftMargin:I

    iget v6, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->rightMargin:I

    add-int/2addr v2, v6

    .line 826
    .local v2, "margin":I
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredWidth()I

    move-result v6

    add-int/2addr v6, v2

    .line 827
    .local v6, "measuredWidth":I
    invoke-static {v11, v6}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 829
    const/high16 v15, 0x40000000    # 2.0f

    if-eq v12, v15, :cond_27

    iget v15, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    move/from16 v53, v2

    const/4 v2, -0x1

    if-ne v15, v2, :cond_28

    .line 829
    .end local v2    # "margin":I
    .local v53, "margin":I
    move/from16 v2, v21

    goto :goto_19

    .line 829
    .end local v53    # "margin":I
    .restart local v2    # "margin":I
    :cond_27
    move/from16 v53, v2

    .line 829
    .end local v2    # "margin":I
    .restart local v53    # "margin":I
    :cond_28
    const/4 v2, 0x0

    .line 832
    .local v2, "matchWidthLocally":Z
    :goto_19
    if-eqz v2, :cond_29

    move/from16 v15, v53

    goto :goto_1a

    :cond_29
    move v15, v6

    :goto_1a
    invoke-static {v9, v15}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 835
    if-eqz v17, :cond_2a

    iget v15, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->width:I

    move/from16 v54, v2

    const/4 v2, -0x1

    if-ne v15, v2, :cond_2b

    .line 835
    .end local v2    # "matchWidthLocally":Z
    .local v54, "matchWidthLocally":Z
    move/from16 v15, v21

    goto :goto_1b

    .line 835
    .end local v54    # "matchWidthLocally":Z
    .restart local v2    # "matchWidthLocally":Z
    :cond_2a
    move/from16 v54, v2

    const/4 v2, -0x1

    .line 835
    .end local v2    # "matchWidthLocally":Z
    .restart local v54    # "matchWidthLocally":Z
    :cond_2b
    const/4 v15, 0x0

    .line 837
    .end local v17    # "allFillParent":Z
    .local v15, "allFillParent":Z
    :goto_1b
    iget v2, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 838
    .local v2, "totalLength":I
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredHeight()I

    move-result v16

    add-int v16, v2, v16

    move/from16 v55, v5

    iget v5, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->topMargin:I

    .line 838
    .end local v5    # "weightSum":F
    .local v55, "weightSum":F
    add-int v16, v16, v5

    iget v5, v10, Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;->bottomMargin:I

    add-int v16, v16, v5

    .line 839
    invoke-virtual {v7, v4}, Landroid/support/v7/widget/LinearLayoutCompat;->getNextLocationOffset(Landroid/view/View;)I

    move-result v5

    add-int v5, v16, v5

    .line 838
    invoke-static {v2, v5}, Ljava/lang/Math;->max(II)I

    move-result v5

    iput v5, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 779
    .end local v2    # "totalLength":I
    .end local v4    # "child":Landroid/view/View;
    .end local v6    # "measuredWidth":I
    .end local v10    # "lp":Landroid/support/v7/widget/LinearLayoutCompat$LayoutParams;
    .end local v50    # "childExtra":F
    .end local v53    # "margin":I
    .end local v54    # "matchWidthLocally":Z
    move/from16 v17, v15

    move/from16 v6, v49

    move/from16 v5, v55

    .line 779
    .end local v15    # "allFillParent":Z
    .end local v49    # "delta":I
    .end local v55    # "weightSum":F
    .restart local v5    # "weightSum":F
    .local v6, "delta":I
    .restart local v17    # "allFillParent":Z
    :goto_1c
    add-int/lit8 v0, v0, 0x1

    move/from16 v10, v45

    move/from16 v13, v46

    move/from16 v15, v47

    move/from16 v2, v51

    const/4 v4, 0x0

    goto/16 :goto_14

    .line 843
    .end local v0    # "i":I
    .end local v45    # "useLargestChild":Z
    .end local v46    # "largestChildHeight":I
    .end local v47    # "baselineChildIndex":I
    .end local v51    # "heightMode":I
    .local v2, "heightMode":I
    .local v10, "useLargestChild":Z
    .local v13, "largestChildHeight":I
    .local v15, "baselineChildIndex":I
    :cond_2c
    move/from16 v51, v2

    move/from16 v45, v10

    move/from16 v46, v13

    move/from16 v47, v15

    move/from16 v13, p1

    .line 843
    .end local v2    # "heightMode":I
    .end local v10    # "useLargestChild":Z
    .end local v13    # "largestChildHeight":I
    .end local v15    # "baselineChildIndex":I
    .restart local v45    # "useLargestChild":Z
    .restart local v46    # "largestChildHeight":I
    .restart local v47    # "baselineChildIndex":I
    .restart local v51    # "heightMode":I
    iget v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingTop()I

    move-result v2

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingBottom()I

    move-result v4

    add-int/2addr v2, v4

    add-int/2addr v0, v2

    iput v0, v7, Landroid/support/v7/widget/LinearLayoutCompat;->mTotalLength:I

    .line 845
    .end local v5    # "weightSum":F
    nop

    .line 875
    move/from16 v39, v6

    move/from16 v44, v9

    .line 875
    .end local v6    # "delta":I
    .end local v9    # "alternativeMaxWidth":I
    .restart local v39    # "delta":I
    .restart local v44    # "alternativeMaxWidth":I
    :goto_1d
    if-nez v17, :cond_2d

    const/high16 v0, 0x40000000    # 2.0f

    if-eq v12, v0, :cond_2d

    .line 876
    move/from16 v11, v44

    .line 879
    :cond_2d
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingLeft()I

    move-result v0

    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getPaddingRight()I

    move-result v2

    add-int/2addr v0, v2

    add-int/2addr v11, v0

    .line 882
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getSuggestedMinimumWidth()I

    move-result v0

    invoke-static {v11, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 884
    .end local v11    # "maxWidth":I
    .local v0, "maxWidth":I
    invoke-static {v0, v13, v14}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v2

    invoke-virtual {v7, v2, v8}, Landroid/support/v7/widget/LinearLayoutCompat;->setMeasuredDimension(II)V

    .line 887
    if-eqz v18, :cond_2e

    .line 888
    invoke-direct {v7, v1, v3}, Landroid/support/v7/widget/LinearLayoutCompat;->forceUniformWidth(II)V

    .line 890
    :cond_2e
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 2
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .line 283
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    if-nez v0, :cond_0

    .line 284
    return-void

    .line 287
    :cond_0
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    .line 288
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearLayoutCompat;->drawDividersVertical(Landroid/graphics/Canvas;)V

    goto :goto_0

    .line 290
    :cond_1
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/LinearLayoutCompat;->drawDividersHorizontal(Landroid/graphics/Canvas;)V

    .line 292
    :goto_0
    return-void
.end method

.method public onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 2
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 1755
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_0

    .line 1756
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V

    .line 1757
    const-class v0, Landroid/support/v7/widget/LinearLayoutCompat;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/view/accessibility/AccessibilityEvent;->setClassName(Ljava/lang/CharSequence;)V

    .line 1759
    :cond_0
    return-void
.end method

.method public onInitializeAccessibilityNodeInfo(Landroid/view/accessibility/AccessibilityNodeInfo;)V
    .locals 2
    .param p1, "info"    # Landroid/view/accessibility/AccessibilityNodeInfo;

    .line 1763
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_0

    .line 1764
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onInitializeAccessibilityNodeInfo(Landroid/view/accessibility/AccessibilityNodeInfo;)V

    .line 1765
    const-class v0, Landroid/support/v7/widget/LinearLayoutCompat;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/view/accessibility/AccessibilityNodeInfo;->setClassName(Ljava/lang/CharSequence;)V

    .line 1767
    :cond_0
    return-void
.end method

.method protected onLayout(ZIIII)V
    .locals 2
    .param p1, "changed"    # Z
    .param p2, "l"    # I
    .param p3, "t"    # I
    .param p4, "r"    # I
    .param p5, "b"    # I

    .line 1405
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1406
    invoke-virtual {p0, p2, p3, p4, p5}, Landroid/support/v7/widget/LinearLayoutCompat;->layoutVertical(IIII)V

    goto :goto_0

    .line 1408
    :cond_0
    invoke-virtual {p0, p2, p3, p4, p5}, Landroid/support/v7/widget/LinearLayoutCompat;->layoutHorizontal(IIII)V

    .line 1410
    :goto_0
    return-void
.end method

.method protected onMeasure(II)V
    .locals 2
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 550
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 551
    invoke-virtual {p0, p1, p2}, Landroid/support/v7/widget/LinearLayoutCompat;->measureVertical(II)V

    goto :goto_0

    .line 553
    :cond_0
    invoke-virtual {p0, p1, p2}, Landroid/support/v7/widget/LinearLayoutCompat;->measureHorizontal(II)V

    .line 555
    :goto_0
    return-void
.end method

.method public setBaselineAligned(Z)V
    .locals 0
    .param p1, "baselineAligned"    # Z

    .line 392
    iput-boolean p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAligned:Z

    .line 393
    return-void
.end method

.method public setBaselineAlignedChildIndex(I)V
    .locals 3
    .param p1, "i"    # I

    .line 488
    if-ltz p1, :cond_1

    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildCount()I

    move-result v0

    if-lt p1, v0, :cond_0

    goto :goto_0

    .line 492
    :cond_0
    iput p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mBaselineAlignedChildIndex:I

    .line 493
    return-void

    .line 489
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "base aligned child index out of range (0, "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 490
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->getChildCount()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public setDividerDrawable(Landroid/graphics/drawable/Drawable;)V
    .locals 2
    .param p1, "divider"    # Landroid/graphics/drawable/Drawable;

    .line 232
    iget-object v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    if-ne p1, v0, :cond_0

    .line 233
    return-void

    .line 235
    :cond_0
    iput-object p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDivider:Landroid/graphics/drawable/Drawable;

    .line 236
    const/4 v0, 0x0

    if-eqz p1, :cond_1

    .line 237
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    .line 238
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v1

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    goto :goto_0

    .line 240
    :cond_1
    iput v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerWidth:I

    .line 241
    iput v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerHeight:I

    .line 243
    :goto_0
    if-nez p1, :cond_2

    const/4 v0, 0x1

    nop

    :cond_2
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/LinearLayoutCompat;->setWillNotDraw(Z)V

    .line 244
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 245
    return-void
.end method

.method public setDividerPadding(I)V
    .locals 0
    .param p1, "padding"    # I

    .line 257
    iput p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mDividerPadding:I

    .line 258
    return-void
.end method

.method public setGravity(I)V
    .locals 1
    .param p1, "gravity"    # I

    .line 1678
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    if-eq v0, p1, :cond_2

    .line 1679
    const v0, 0x800007

    and-int/2addr v0, p1

    if-nez v0, :cond_0

    .line 1680
    const v0, 0x800003

    or-int/2addr p1, v0

    .line 1683
    :cond_0
    and-int/lit8 v0, p1, 0x70

    if-nez v0, :cond_1

    .line 1684
    or-int/lit8 p1, p1, 0x30

    .line 1687
    :cond_1
    iput p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    .line 1688
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 1690
    :cond_2
    return-void
.end method

.method public setHorizontalGravity(I)V
    .locals 3
    .param p1, "horizontalGravity"    # I

    .line 1703
    const v0, 0x800007

    and-int v1, p1, v0

    .line 1704
    .local v1, "gravity":I
    iget v2, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/2addr v0, v2

    if-eq v0, v1, :cond_0

    .line 1705
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    const v2, -0x800008

    and-int/2addr v0, v2

    or-int/2addr v0, v1

    iput v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    .line 1706
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 1708
    :cond_0
    return-void
.end method

.method public setMeasureWithLargestChildEnabled(Z)V
    .locals 0
    .param p1, "enabled"    # Z

    .line 418
    iput-boolean p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mUseLargestChild:Z

    .line 419
    return-void
.end method

.method public setOrientation(I)V
    .locals 1
    .param p1, "orientation"    # I

    .line 1653
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    if-eq v0, p1, :cond_0

    .line 1654
    iput p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mOrientation:I

    .line 1655
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 1657
    :cond_0
    return-void
.end method

.method public setShowDividers(I)V
    .locals 1
    .param p1, "showDividers"    # I

    .line 195
    iget v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    if-eq p1, v0, :cond_0

    .line 196
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 198
    :cond_0
    iput p1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mShowDividers:I

    .line 199
    return-void
.end method

.method public setVerticalGravity(I)V
    .locals 2
    .param p1, "verticalGravity"    # I

    .line 1711
    and-int/lit8 v0, p1, 0x70

    .line 1712
    .local v0, "gravity":I
    iget v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/lit8 v1, v1, 0x70

    if-eq v1, v0, :cond_0

    .line 1713
    iget v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    and-int/lit8 v1, v1, -0x71

    or-int/2addr v1, v0

    iput v1, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mGravity:I

    .line 1714
    invoke-virtual {p0}, Landroid/support/v7/widget/LinearLayoutCompat;->requestLayout()V

    .line 1716
    :cond_0
    return-void
.end method

.method public setWeightSum(F)V
    .locals 1
    .param p1, "weightSum"    # F

    .line 545
    const/4 v0, 0x0

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result v0

    iput v0, p0, Landroid/support/v7/widget/LinearLayoutCompat;->mWeightSum:F

    .line 546
    return-void
.end method

.method public shouldDelayChildPressedState()Z
    .locals 1

    .line 203
    const/4 v0, 0x0

    return v0
.end method
