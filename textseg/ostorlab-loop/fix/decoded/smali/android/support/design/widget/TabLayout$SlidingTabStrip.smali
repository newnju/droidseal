.class Landroid/support/design/widget/TabLayout$SlidingTabStrip;
.super Landroid/widget/LinearLayout;
.source "TabLayout.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/design/widget/TabLayout;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "SlidingTabStrip"
.end annotation


# instance fields
.field private mIndicatorAnimator:Landroid/animation/ValueAnimator;

.field private mIndicatorLeft:I

.field private mIndicatorRight:I

.field private mLayoutDirection:I

.field private mSelectedIndicatorHeight:I

.field private final mSelectedIndicatorPaint:Landroid/graphics/Paint;

.field mSelectedPosition:I

.field mSelectionOffset:F

.field final synthetic this$0:Landroid/support/design/widget/TabLayout;


# direct methods
.method constructor <init>(Landroid/support/design/widget/TabLayout;Landroid/content/Context;)V
    .locals 0
    .param p2, "context"    # Landroid/content/Context;

    .line 1798
    iput-object p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    .line 1799
    invoke-direct {p0, p2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1788
    const/4 p1, -0x1

    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    .line 1791
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mLayoutDirection:I

    .line 1793
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    .line 1794
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    .line 1800
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->setWillNotDraw(Z)V

    .line 1801
    new-instance p1, Landroid/graphics/Paint;

    invoke-direct {p1}, Landroid/graphics/Paint;-><init>()V

    iput-object p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorPaint:Landroid/graphics/Paint;

    .line 1802
    return-void
.end method

.method private updateIndicatorPosition()V
    .locals 8

    .line 1932
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    invoke-virtual {p0, v0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    .line 1935
    .local v0, "selectedTitle":Landroid/view/View;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v1

    if-lez v1, :cond_0

    .line 1936
    invoke-virtual {v0}, Landroid/view/View;->getLeft()I

    move-result v1

    .line 1937
    .local v1, "left":I
    invoke-virtual {v0}, Landroid/view/View;->getRight()I

    move-result v2

    .line 1939
    .local v2, "right":I
    iget v3, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    const/4 v4, 0x0

    cmpl-float v3, v3, v4

    if-lez v3, :cond_1

    iget v3, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildCount()I

    move-result v4

    add-int/lit8 v4, v4, -0x1

    if-ge v3, v4, :cond_1

    .line 1941
    iget v3, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    add-int/lit8 v3, v3, 0x1

    invoke-virtual {p0, v3}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1942
    .local v3, "nextTitle":Landroid/view/View;
    iget v4, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    invoke-virtual {v3}, Landroid/view/View;->getLeft()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v4, v5

    iget v5, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    const/high16 v6, 0x3f800000    # 1.0f

    sub-float v5, v6, v5

    int-to-float v7, v1

    mul-float/2addr v5, v7

    add-float/2addr v4, v5

    float-to-int v1, v4

    .line 1944
    iget v4, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    invoke-virtual {v3}, Landroid/view/View;->getRight()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v4, v5

    iget v5, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    sub-float/2addr v6, v5

    int-to-float v5, v2

    mul-float/2addr v6, v5

    add-float/2addr v4, v6

    float-to-int v2, v4

    .line 1946
    .end local v3    # "nextTitle":Landroid/view/View;
    goto :goto_0

    .line 1948
    .end local v1    # "left":I
    .end local v2    # "right":I
    :cond_0
    const/4 v1, -0x1

    move v2, v1

    .line 1951
    .restart local v1    # "left":I
    .restart local v2    # "right":I
    :cond_1
    :goto_0
    invoke-virtual {p0, v1, v2}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->setIndicatorPosition(II)V

    .line 1952
    return-void
.end method


# virtual methods
.method animateIndicatorToPosition(II)V
    .locals 17
    .param p1, "position"    # I
    .param p2, "duration"    # I

    move-object/from16 v6, p0

    move/from16 v7, p1

    .line 1964
    iget-object v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_0

    iget-object v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->isRunning()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1965
    iget-object v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    .line 1968
    :cond_0
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    move v0, v1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    move v8, v0

    .line 1971
    .local v8, "isRtl":Z
    invoke-virtual/range {p0 .. p1}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v9

    .line 1972
    .local v9, "targetView":Landroid/view/View;
    if-nez v9, :cond_2

    .line 1974
    invoke-direct/range {p0 .. p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->updateIndicatorPosition()V

    .line 1975
    return-void

    .line 1978
    :cond_2
    invoke-virtual {v9}, Landroid/view/View;->getLeft()I

    move-result v10

    .line 1979
    .local v10, "targetLeft":I
    invoke-virtual {v9}, Landroid/view/View;->getRight()I

    move-result v11

    .line 1983
    .local v11, "targetRight":I
    iget v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    sub-int v0, v7, v0

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    if-gt v0, v1, :cond_3

    .line 1985
    iget v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    .line 1986
    .local v0, "startLeft":I
    iget v1, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    .line 2002
    .local v1, "startRight":I
    move v12, v1

    move v1, v0

    goto :goto_2

    .line 1989
    .end local v0    # "startLeft":I
    .end local v1    # "startRight":I
    :cond_3
    iget-object v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    const/16 v1, 0x18

    invoke-virtual {v0, v1}, Landroid/support/design/widget/TabLayout;->dpToPx(I)I

    move-result v0

    .line 1990
    .local v0, "offset":I
    iget v1, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    if-ge v7, v1, :cond_5

    .line 1992
    if-eqz v8, :cond_4

    .line 1993
    sub-int v1, v10, v0

    move v2, v1

    .line 2002
    .end local v0    # "offset":I
    .local v1, "startLeft":I
    .local v2, "startRight":I
    .local v12, "startRight":I
    :goto_1
    move v12, v2

    goto :goto_2

    .line 1995
    .end local v1    # "startLeft":I
    .end local v2    # "startRight":I
    .end local v12    # "startRight":I
    .restart local v0    # "offset":I
    :cond_4
    add-int v1, v11, v0

    move v2, v1

    goto :goto_1

    .line 1999
    :cond_5
    if-eqz v8, :cond_6

    .line 2000
    add-int v1, v11, v0

    move v2, v1

    goto :goto_1

    .line 2002
    :cond_6
    sub-int v1, v10, v0

    move v0, v1

    .line 2002
    .local v0, "startRight":I
    move v12, v0

    .line 2002
    .end local v0    # "startRight":I
    .restart local v1    # "startLeft":I
    .restart local v12    # "startRight":I
    :goto_2
    move v13, v1

    .line 2007
    .end local v1    # "startLeft":I
    .local v13, "startLeft":I
    if-ne v13, v10, :cond_8

    if-eq v12, v11, :cond_7

    goto :goto_3

    .line 2030
    :cond_7
    move/from16 v15, p2

    move/from16 v16, v8

    goto :goto_4

    .line 2008
    :cond_8
    :goto_3
    new-instance v0, Landroid/animation/ValueAnimator;

    invoke-direct {v0}, Landroid/animation/ValueAnimator;-><init>()V

    iput-object v0, v6, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    move-object v14, v0

    .line 2009
    .local v14, "animator":Landroid/animation/ValueAnimator;
    sget-object v0, Landroid/support/design/widget/AnimationUtils;->FAST_OUT_SLOW_IN_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v14, v0}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 2010
    move/from16 v15, p2

    int-to-long v0, v15

    invoke-virtual {v14, v0, v1}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    .line 2011
    const/4 v0, 0x2

    new-array v0, v0, [F

    fill-array-data v0, :array_0

    invoke-virtual {v14, v0}, Landroid/animation/ValueAnimator;->setFloatValues([F)V

    .line 2012
    new-instance v5, Landroid/support/design/widget/TabLayout$SlidingTabStrip$1;

    move-object v0, v5

    move-object v1, v6

    move v2, v13

    move v3, v10

    move v4, v12

    move/from16 v16, v8

    move-object v8, v5

    move v5, v11

    .line 2012
    .end local v8    # "isRtl":Z
    .local v16, "isRtl":Z
    invoke-direct/range {v0 .. v5}, Landroid/support/design/widget/TabLayout$SlidingTabStrip$1;-><init>(Landroid/support/design/widget/TabLayout$SlidingTabStrip;IIII)V

    invoke-virtual {v14, v8}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    .line 2021
    new-instance v0, Landroid/support/design/widget/TabLayout$SlidingTabStrip$2;

    invoke-direct {v0, v6, v7}, Landroid/support/design/widget/TabLayout$SlidingTabStrip$2;-><init>(Landroid/support/design/widget/TabLayout$SlidingTabStrip;I)V

    invoke-virtual {v14, v0}, Landroid/animation/ValueAnimator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 2028
    invoke-virtual {v14}, Landroid/animation/ValueAnimator;->start()V

    .line 2030
    .end local v14    # "animator":Landroid/animation/ValueAnimator;
    :goto_4
    return-void

    :array_0
    .array-data 4
        0x0
        0x3f800000    # 1.0f
    .end array-data
.end method

.method childrenNeedLayout()Z
    .locals 4

    .line 1819
    const/4 v0, 0x0

    .line 1819
    .local v0, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildCount()I

    move-result v1

    .line 1819
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_1

    .line 1820
    invoke-virtual {p0, v0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1821
    .local v2, "child":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v3

    if-gtz v3, :cond_0

    .line 1822
    const/4 v3, 0x1

    return v3

    .line 1819
    .end local v2    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1825
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method public draw(Landroid/graphics/Canvas;)V
    .locals 7
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .line 2034
    invoke-super {p0, p1}, Landroid/widget/LinearLayout;->draw(Landroid/graphics/Canvas;)V

    .line 2037
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    if-ltz v0, :cond_0

    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    iget v1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    if-le v0, v1, :cond_0

    .line 2038
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    int-to-float v2, v0

    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getHeight()I

    move-result v0

    iget v1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorHeight:I

    sub-int/2addr v0, v1

    int-to-float v3, v0

    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    int-to-float v4, v0

    .line 2039
    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getHeight()I

    move-result v0

    int-to-float v5, v0

    iget-object v6, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorPaint:Landroid/graphics/Paint;

    .line 2038
    move-object v1, p1

    invoke-virtual/range {v1 .. v6}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 2041
    :cond_0
    return-void
.end method

.method getIndicatorPosition()F
    .locals 2

    .line 1839
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    int-to-float v0, v0

    iget v1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    add-float/2addr v0, v1

    return v0
.end method

.method protected onLayout(ZIIII)V
    .locals 5
    .param p1, "changed"    # Z
    .param p2, "l"    # I
    .param p3, "t"    # I
    .param p4, "r"    # I
    .param p5, "b"    # I

    .line 1916
    invoke-super/range {p0 .. p5}, Landroid/widget/LinearLayout;->onLayout(ZIIII)V

    .line 1918
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->isRunning()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1921
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    .line 1922
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->getDuration()J

    move-result-wide v0

    .line 1923
    .local v0, "duration":J
    iget v2, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    const/high16 v3, 0x3f800000    # 1.0f

    iget-object v4, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    .line 1924
    invoke-virtual {v4}, Landroid/animation/ValueAnimator;->getAnimatedFraction()F

    move-result v4

    sub-float/2addr v3, v4

    long-to-float v4, v0

    mul-float/2addr v3, v4

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1923
    invoke-virtual {p0, v2, v3}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->animateIndicatorToPosition(II)V

    .line 1925
    .end local v0    # "duration":J
    goto :goto_0

    .line 1927
    :cond_0
    invoke-direct {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->updateIndicatorPosition()V

    .line 1929
    :goto_0
    return-void
.end method

.method protected onMeasure(II)V
    .locals 8
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 1859
    invoke-super {p0, p1, p2}, Landroid/widget/LinearLayout;->onMeasure(II)V

    .line 1861
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v0

    const/high16 v1, 0x40000000    # 2.0f

    if-eq v0, v1, :cond_0

    .line 1864
    return-void

    .line 1867
    :cond_0
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    iget v0, v0, Landroid/support/design/widget/TabLayout;->mMode:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_8

    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    iget v0, v0, Landroid/support/design/widget/TabLayout;->mTabGravity:I

    if-ne v0, v1, :cond_8

    .line 1868
    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildCount()I

    move-result v0

    .line 1871
    .local v0, "count":I
    const/4 v1, 0x0

    .line 1872
    .local v1, "largestTabWidth":I
    const/4 v2, 0x0

    .line 1872
    .local v2, "i":I
    move v3, v1

    move v1, v0

    .line 1872
    .local v1, "z":I
    .local v3, "largestTabWidth":I
    :goto_0
    if-ge v2, v1, :cond_2

    .line 1873
    invoke-virtual {p0, v2}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 1874
    .local v4, "child":Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-nez v5, :cond_1

    .line 1875
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    invoke-static {v3, v5}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1872
    .end local v4    # "child":Landroid/view/View;
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1879
    .end local v1    # "z":I
    .end local v2    # "i":I
    :cond_2
    if-gtz v3, :cond_3

    .line 1881
    return-void

    .line 1884
    :cond_3
    iget-object v1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    const/16 v2, 0x10

    invoke-virtual {v1, v2}, Landroid/support/design/widget/TabLayout;->dpToPx(I)I

    move-result v1

    .line 1885
    .local v1, "gutter":I
    const/4 v2, 0x0

    .line 1887
    .local v2, "remeasure":Z
    mul-int v4, v3, v0

    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getMeasuredWidth()I

    move-result v5

    mul-int/lit8 v6, v1, 0x2

    sub-int/2addr v5, v6

    const/4 v6, 0x0

    if-gt v4, v5, :cond_6

    .line 1890
    nop

    .line 1890
    .local v6, "i":I
    :goto_1
    move v4, v6

    .line 1890
    .end local v6    # "i":I
    .local v4, "i":I
    if-ge v4, v0, :cond_7

    .line 1891
    nop

    .line 1892
    invoke-virtual {p0, v4}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    check-cast v5, Landroid/widget/LinearLayout$LayoutParams;

    .line 1893
    .local v5, "lp":Landroid/widget/LinearLayout$LayoutParams;
    iget v6, v5, Landroid/widget/LinearLayout$LayoutParams;->width:I

    const/4 v7, 0x0

    if-ne v6, v3, :cond_4

    iget v6, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    cmpl-float v6, v6, v7

    if-eqz v6, :cond_5

    .line 1894
    :cond_4
    iput v3, v5, Landroid/widget/LinearLayout$LayoutParams;->width:I

    .line 1895
    iput v7, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    .line 1896
    const/4 v2, 0x1

    .line 1890
    .end local v5    # "lp":Landroid/widget/LinearLayout$LayoutParams;
    :cond_5
    add-int/lit8 v6, v4, 0x1

    .line 1890
    .end local v4    # "i":I
    .restart local v6    # "i":I
    goto :goto_1

    .line 1902
    .end local v6    # "i":I
    :cond_6
    iget-object v4, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    iput v6, v4, Landroid/support/design/widget/TabLayout;->mTabGravity:I

    .line 1903
    iget-object v4, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->this$0:Landroid/support/design/widget/TabLayout;

    invoke-virtual {v4, v6}, Landroid/support/design/widget/TabLayout;->updateTabViews(Z)V

    .line 1904
    const/4 v2, 0x1

    .line 1907
    :cond_7
    if-eqz v2, :cond_8

    .line 1909
    invoke-super {p0, p1, p2}, Landroid/widget/LinearLayout;->onMeasure(II)V

    .line 1912
    .end local v0    # "count":I
    .end local v1    # "gutter":I
    .end local v2    # "remeasure":Z
    .end local v3    # "largestTabWidth":I
    :cond_8
    return-void
.end method

.method public onRtlPropertiesChanged(I)V
    .locals 2
    .param p1, "layoutDirection"    # I

    .line 1844
    invoke-super {p0, p1}, Landroid/widget/LinearLayout;->onRtlPropertiesChanged(I)V

    .line 1848
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-ge v0, v1, :cond_0

    .line 1850
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mLayoutDirection:I

    if-eq v0, p1, :cond_0

    .line 1851
    invoke-virtual {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->requestLayout()V

    .line 1852
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mLayoutDirection:I

    .line 1855
    :cond_0
    return-void
.end method

.method setIndicatorPosition(II)V
    .locals 1
    .param p1, "left"    # I
    .param p2, "right"    # I

    .line 1955
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    if-ne p1, v0, :cond_0

    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    if-eq p2, v0, :cond_1

    .line 1957
    :cond_0
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorLeft:I

    .line 1958
    iput p2, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorRight:I

    .line 1959
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 1961
    :cond_1
    return-void
.end method

.method setIndicatorPositionFromTabPosition(IF)V
    .locals 1
    .param p1, "position"    # I
    .param p2, "positionOffset"    # F

    .line 1829
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->isRunning()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1830
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mIndicatorAnimator:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    .line 1833
    :cond_0
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedPosition:I

    .line 1834
    iput p2, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectionOffset:F

    .line 1835
    invoke-direct {p0}, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->updateIndicatorPosition()V

    .line 1836
    return-void
.end method

.method setSelectedIndicatorColor(I)V
    .locals 1
    .param p1, "color"    # I

    .line 1805
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorPaint:Landroid/graphics/Paint;

    invoke-virtual {v0}, Landroid/graphics/Paint;->getColor()I

    move-result v0

    if-eq v0, p1, :cond_0

    .line 1806
    iget-object v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorPaint:Landroid/graphics/Paint;

    invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setColor(I)V

    .line 1807
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 1809
    :cond_0
    return-void
.end method

.method setSelectedIndicatorHeight(I)V
    .locals 1
    .param p1, "height"    # I

    .line 1812
    iget v0, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorHeight:I

    if-eq v0, p1, :cond_0

    .line 1813
    iput p1, p0, Landroid/support/design/widget/TabLayout$SlidingTabStrip;->mSelectedIndicatorHeight:I

    .line 1814
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 1816
    :cond_0
    return-void
.end method
