.class public Landroid/support/constraint/ConstraintLayout;
.super Landroid/view/ViewGroup;
.source "ConstraintLayout.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/constraint/ConstraintLayout$LayoutParams;
    }
.end annotation


# static fields
.field static final ALLOWS_EMBEDDED:Z = false

.field private static final SIMPLE_LAYOUT:Z = true

.field private static final TAG:Ljava/lang/String; = "ConstraintLayout"

.field public static final VERSION:Ljava/lang/String; = "ConstraintLayout-1.0.0"


# instance fields
.field mChildrenByIds:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private mConstraintSet:Landroid/support/constraint/ConstraintSet;

.field private mDirtyHierarchy:Z

.field mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

.field private mMaxHeight:I

.field private mMaxWidth:I

.field private mMinHeight:I

.field private mMinWidth:I

.field private mOptimizationLevel:I

.field private final mVariableDimensionsWidgets:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/constraint/solver/widgets/ConstraintWidget;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 414
    invoke-direct {p0, p1}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;)V

    .line 395
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    .line 400
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0x64

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    .line 402
    new-instance v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-direct {v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    .line 404
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    .line 405
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    .line 406
    const v0, 0x7fffffff

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    .line 407
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    .line 409
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 410
    const/4 v0, 0x2

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    .line 411
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 415
    invoke-direct {p0, v0}, Landroid/support/constraint/ConstraintLayout;->init(Landroid/util/AttributeSet;)V

    .line 416
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 419
    invoke-direct {p0, p1, p2}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 395
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    .line 400
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0x64

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    .line 402
    new-instance v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-direct {v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    .line 404
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    .line 405
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    .line 406
    const v0, 0x7fffffff

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    .line 407
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    .line 409
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 410
    const/4 v0, 0x2

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    .line 411
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 420
    invoke-direct {p0, p2}, Landroid/support/constraint/ConstraintLayout;->init(Landroid/util/AttributeSet;)V

    .line 421
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .line 424
    invoke-direct {p0, p1, p2, p3}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 395
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    .line 400
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0x64

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    .line 402
    new-instance v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-direct {v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    .line 404
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    .line 405
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    .line 406
    const v0, 0x7fffffff

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    .line 407
    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    .line 409
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 410
    const/4 v0, 0x2

    iput v0, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    .line 411
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 425
    invoke-direct {p0, p2}, Landroid/support/constraint/ConstraintLayout;->init(Landroid/util/AttributeSet;)V

    .line 426
    return-void
.end method

.method private final getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .locals 2
    .param p1, "id"    # I

    .line 862
    if-nez p1, :cond_0

    .line 863
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    return-object v0

    .line 865
    :cond_0
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 866
    .local v0, "view":Landroid/view/View;
    if-ne v0, p0, :cond_1

    .line 867
    iget-object v1, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    return-object v1

    .line 869
    :cond_1
    if-nez v0, :cond_2

    const/4 v1, 0x0

    goto :goto_0

    :cond_2
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    iget-object v1, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    :goto_0
    return-object v1
.end method

.method private final getViewWidget(Landroid/view/View;)Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 874
    if-ne p1, p0, :cond_0

    .line 875
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    return-object v0

    .line 877
    :cond_0
    if-nez p1, :cond_1

    const/4 v0, 0x0

    goto :goto_0

    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    iget-object v0, v0, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    :goto_0
    return-object v0
.end method

.method private init(Landroid/util/AttributeSet;)V
    .locals 8
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 436
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v0, p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setCompanionWidget(Ljava/lang/Object;)V

    .line 437
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getId()I

    move-result v1

    invoke-virtual {v0, v1, p0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 438
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 439
    if-eqz p1, :cond_7

    .line 440
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getContext()Landroid/content/Context;

    move-result-object v0

    sget-object v1, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout:[I

    invoke-virtual {v0, p1, v1}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object v0

    .line 441
    .local v0, "a":Landroid/content/res/TypedArray;
    invoke-virtual {v0}, Landroid/content/res/TypedArray;->getIndexCount()I

    move-result v1

    .line 442
    .local v1, "N":I
    const/4 v2, 0x0

    move v3, v2

    .line 442
    .local v3, "i":I
    :goto_0
    if-ge v3, v1, :cond_6

    .line 443
    invoke-virtual {v0, v3}, Landroid/content/res/TypedArray;->getIndex(I)I

    move-result v4

    .line 444
    .local v4, "attr":I
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_android_minWidth:I

    if-ne v4, v5, :cond_0

    .line 445
    iget v5, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    invoke-virtual {v0, v4, v5}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result v5

    iput v5, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    goto :goto_1

    .line 446
    :cond_0
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_android_minHeight:I

    if-ne v4, v5, :cond_1

    .line 447
    iget v5, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    invoke-virtual {v0, v4, v5}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result v5

    iput v5, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    goto :goto_1

    .line 448
    :cond_1
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_android_maxWidth:I

    if-ne v4, v5, :cond_2

    .line 449
    iget v5, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    invoke-virtual {v0, v4, v5}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result v5

    iput v5, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    goto :goto_1

    .line 450
    :cond_2
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_android_maxHeight:I

    if-ne v4, v5, :cond_3

    .line 451
    iget v5, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    invoke-virtual {v0, v4, v5}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result v5

    iput v5, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    goto :goto_1

    .line 452
    :cond_3
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_layout_optimizationLevel:I

    if-ne v4, v5, :cond_4

    .line 453
    iget v5, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    invoke-virtual {v0, v4, v5}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result v5

    iput v5, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    goto :goto_1

    .line 454
    :cond_4
    sget v5, Landroid/support/constraint/R$styleable;->ConstraintLayout_Layout_constraintSet:I

    if-ne v4, v5, :cond_5

    .line 455
    invoke-virtual {v0, v4, v2}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v5

    .line 456
    .local v5, "id":I
    new-instance v6, Landroid/support/constraint/ConstraintSet;

    invoke-direct {v6}, Landroid/support/constraint/ConstraintSet;-><init>()V

    iput-object v6, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 457
    iget-object v6, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-virtual {v6, v7, v5}, Landroid/support/constraint/ConstraintSet;->load(Landroid/content/Context;I)V

    .line 442
    .end local v4    # "attr":I
    .end local v5    # "id":I
    :cond_5
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 460
    .end local v3    # "i":I
    :cond_6
    invoke-virtual {v0}, Landroid/content/res/TypedArray;->recycle()V

    .line 462
    .end local v0    # "a":Landroid/content/res/TypedArray;
    .end local v1    # "N":I
    :cond_7
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    iget v1, p0, Landroid/support/constraint/ConstraintLayout;->mOptimizationLevel:I

    invoke-virtual {v0, v1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setOptimizationLevel(I)V

    .line 463
    return-void
.end method

.method private internalMeasureChildren(II)V
    .locals 20
    .param p1, "parentWidthSpec"    # I
    .param p2, "parentHeightSpec"    # I

    move/from16 v0, p1

    .line 881
    move/from16 v1, p2

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingTop()I

    move-result v2

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingBottom()I

    move-result v3

    add-int/2addr v2, v3

    .line 882
    .local v2, "heightPadding":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingLeft()I

    move-result v3

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingRight()I

    move-result v4

    add-int/2addr v3, v4

    .line 884
    .local v3, "widthPadding":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getChildCount()I

    move-result v4

    .line 885
    .local v4, "widgetsCount":I
    const/4 v6, 0x0

    .line 885
    .local v6, "i":I
    :goto_0
    if-ge v6, v4, :cond_d

    .line 886
    move-object/from16 v7, p0

    invoke-virtual {v7, v6}, Landroid/support/constraint/ConstraintLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v8

    .line 887
    .local v8, "child":Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getVisibility()I

    move-result v9

    const/16 v10, 0x8

    if-ne v9, v10, :cond_0

    .line 888
    goto/16 :goto_6

    .line 890
    :cond_0
    invoke-virtual {v8}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    check-cast v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 891
    .local v9, "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    iget-object v10, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 892
    .local v10, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-boolean v11, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->isGuideline:Z

    if-eqz v11, :cond_1

    .line 893
    goto/16 :goto_6

    .line 896
    :cond_1
    iget v11, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    .line 897
    .local v11, "width":I
    iget v12, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    .line 901
    .local v12, "height":I
    iget-boolean v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalDimensionFixed:Z

    const/4 v14, 0x1

    const/4 v15, -0x1

    if-nez v13, :cond_4

    iget-boolean v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalDimensionFixed:Z

    if-nez v13, :cond_4

    iget-boolean v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalDimensionFixed:Z

    if-nez v13, :cond_2

    iget v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintDefaultWidth:I

    if-eq v13, v14, :cond_4

    :cond_2
    iget v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    if-eq v13, v15, :cond_4

    iget-boolean v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalDimensionFixed:Z

    if-nez v13, :cond_3

    iget v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintDefaultHeight:I

    if-eq v13, v14, :cond_4

    iget v13, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    if-ne v13, v15, :cond_3

    goto :goto_1

    :cond_3
    const/4 v14, 0x0

    nop

    :cond_4
    :goto_1
    move v13, v14

    .line 911
    .local v13, "doMeasure":Z
    const/4 v14, 0x0

    .line 912
    .local v14, "didWrapMeasureWidth":Z
    const/16 v16, 0x0

    .line 914
    .local v16, "didWrapMeasureHeight":Z
    if-eqz v13, :cond_9

    .line 918
    const/4 v5, -0x2

    if-eqz v11, :cond_6

    if-ne v11, v15, :cond_5

    goto :goto_2

    .line 923
    :cond_5
    invoke-static {v0, v3, v11}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v17

    goto :goto_3

    .line 919
    :cond_6
    :goto_2
    invoke-static {v0, v3, v5}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v17

    .line 921
    .local v17, "childWidthMeasureSpec":I
    const/4 v14, 0x1

    .line 923
    :goto_3
    move/from16 v18, v17

    .line 926
    .end local v17    # "childWidthMeasureSpec":I
    .local v18, "childWidthMeasureSpec":I
    if-eqz v12, :cond_8

    if-ne v12, v15, :cond_7

    goto :goto_4

    .line 931
    :cond_7
    invoke-static {v1, v2, v12}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v5

    goto :goto_5

    .line 927
    :cond_8
    :goto_4
    invoke-static {v1, v2, v5}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v5

    .line 929
    .local v5, "childHeightMeasureSpec":I
    const/16 v16, 0x1

    .line 931
    :goto_5
    nop

    .line 934
    move/from16 v15, v18

    invoke-virtual {v8, v15, v5}, Landroid/view/View;->measure(II)V

    .line 936
    .end local v18    # "childWidthMeasureSpec":I
    .local v15, "childWidthMeasureSpec":I
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredWidth()I

    move-result v11

    .line 937
    invoke-virtual {v8}, Landroid/view/View;->getMeasuredHeight()I

    move-result v12

    .line 940
    .end local v5    # "childHeightMeasureSpec":I
    .end local v15    # "childWidthMeasureSpec":I
    :cond_9
    invoke-virtual {v10, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWidth(I)V

    .line 941
    invoke-virtual {v10, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHeight(I)V

    .line 942
    if-eqz v14, :cond_a

    .line 943
    invoke-virtual {v10, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWrapWidth(I)V

    .line 945
    :cond_a
    if-eqz v16, :cond_b

    .line 946
    invoke-virtual {v10, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWrapHeight(I)V

    .line 949
    :cond_b
    iget-boolean v5, v9, Landroid/support/constraint/ConstraintLayout$LayoutParams;->needsBaseline:Z

    if-eqz v5, :cond_c

    .line 950
    invoke-virtual {v8}, Landroid/view/View;->getBaseline()I

    move-result v5

    .line 951
    .local v5, "baseline":I
    const/4 v15, -0x1

    if-eq v5, v15, :cond_c

    .line 952
    invoke-virtual {v10, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setBaselineDistance(I)V

    .line 885
    .end local v5    # "baseline":I
    .end local v8    # "child":Landroid/view/View;
    .end local v9    # "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .end local v10    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v11    # "width":I
    .end local v12    # "height":I
    .end local v13    # "doMeasure":Z
    .end local v14    # "didWrapMeasureWidth":Z
    .end local v16    # "didWrapMeasureHeight":Z
    :cond_c
    :goto_6
    add-int/lit8 v6, v6, 0x1

    goto/16 :goto_0

    .line 956
    .end local v6    # "i":I
    :cond_d
    move-object/from16 v7, p0

    return-void
.end method

.method private setChildrenConstraints()V
    .locals 29

    .line 636
    move-object/from16 v0, p0

    iget-object v1, v0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    if-eqz v1, :cond_0

    .line 637
    iget-object v1, v0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    invoke-virtual {v1, v0}, Landroid/support/constraint/ConstraintSet;->applyToInternal(Landroid/support/constraint/ConstraintLayout;)V

    .line 639
    :cond_0
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getChildCount()I

    move-result v1

    .line 640
    .local v1, "count":I
    iget-object v2, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->removeAllChildren()V

    .line 641
    const/4 v3, 0x0

    .line 641
    .local v3, "i":I
    :goto_0
    if-ge v3, v1, :cond_25

    .line 642
    invoke-virtual {v0, v3}, Landroid/support/constraint/ConstraintLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 643
    .local v4, "child":Landroid/view/View;
    invoke-direct {v0, v4}, Landroid/support/constraint/ConstraintLayout;->getViewWidget(Landroid/view/View;)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v11

    .line 644
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-nez v11, :cond_2

    .line 645
    nop

    .line 641
    .end local v4    # "child":Landroid/view/View;
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_1
    :goto_1
    const/4 v5, 0x0

    goto/16 :goto_d

    .line 648
    .restart local v4    # "child":Landroid/view/View;
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_2
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    move-object v12, v5

    check-cast v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 649
    .local v12, "layoutParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->reset()V

    .line 650
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVisibility(I)V

    .line 651
    invoke-virtual {v11, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setCompanionWidget(Ljava/lang/Object;)V

    .line 652
    iget-object v5, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v5, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->add(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 654
    iget-boolean v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalDimensionFixed:Z

    if-eqz v5, :cond_3

    iget-boolean v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalDimensionFixed:Z

    if-nez v5, :cond_4

    .line 655
    :cond_3
    iget-object v5, v0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    invoke-virtual {v5, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 658
    :cond_4
    iget-boolean v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->isGuideline:Z

    const/4 v13, -0x1

    if-eqz v5, :cond_8

    .line 659
    move-object v5, v11

    check-cast v5, Landroid/support/constraint/solver/widgets/Guideline;

    .line 660
    .local v5, "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guideBegin:I

    if-eq v6, v13, :cond_5

    .line 661
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guideBegin:I

    invoke-virtual {v5, v6}, Landroid/support/constraint/solver/widgets/Guideline;->setGuideBegin(I)V

    .line 663
    :cond_5
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guideEnd:I

    if-eq v6, v13, :cond_6

    .line 664
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guideEnd:I

    invoke-virtual {v5, v6}, Landroid/support/constraint/solver/widgets/Guideline;->setGuideEnd(I)V

    .line 666
    :cond_6
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guidePercent:F

    const/high16 v7, -0x40800000    # -1.0f

    cmpl-float v6, v6, v7

    if-eqz v6, :cond_7

    .line 667
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->guidePercent:F

    invoke-virtual {v5, v6}, Landroid/support/constraint/solver/widgets/Guideline;->setGuidePercent(F)V

    .line 669
    .end local v5    # "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    :cond_7
    goto :goto_1

    :cond_8
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedLeftToLeft:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedLeftToRight:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedRightToLeft:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedRightToRight:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToTop:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToBottom:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToTop:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToBottom:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->baselineToBaseline:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteX:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteY:I

    if-ne v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    if-eq v5, v13, :cond_9

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    if-ne v5, v13, :cond_1

    .line 684
    :cond_9
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedLeftToLeft:I

    .line 685
    .local v5, "resolvedLeftToLeft":I
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedLeftToRight:I

    .line 686
    .local v6, "resolvedLeftToRight":I
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedRightToLeft:I

    .line 687
    .local v7, "resolvedRightToLeft":I
    iget v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedRightToRight:I

    .line 688
    .local v8, "resolvedRightToRight":I
    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolveGoneLeftMargin:I

    .line 689
    .local v9, "resolveGoneLeftMargin":I
    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolveGoneRightMargin:I

    .line 690
    .local v10, "resolveGoneRightMargin":I
    iget v14, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->resolvedHorizontalBias:F

    .line 692
    .local v14, "resolvedHorizontalBias":F
    sget v15, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x11

    if-ge v15, v2, :cond_e

    .line 695
    iget v2, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->leftToLeft:I

    .line 696
    .end local v5    # "resolvedLeftToLeft":I
    .local v2, "resolvedLeftToLeft":I
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->leftToRight:I

    .line 697
    .end local v6    # "resolvedLeftToRight":I
    .local v5, "resolvedLeftToRight":I
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->rightToLeft:I

    .line 698
    iget v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->rightToRight:I

    .line 699
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneLeftMargin:I

    .line 700
    .end local v9    # "resolveGoneLeftMargin":I
    .local v6, "resolveGoneLeftMargin":I
    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneRightMargin:I

    .line 701
    .end local v10    # "resolveGoneRightMargin":I
    .local v9, "resolveGoneRightMargin":I
    iget v14, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalBias:F

    .line 703
    if-ne v2, v13, :cond_b

    if-ne v5, v13, :cond_b

    .line 704
    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->startToStart:I

    if-eq v10, v13, :cond_a

    .line 705
    iget v2, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->startToStart:I

    goto :goto_2

    .line 706
    :cond_a
    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->startToEnd:I

    if-eq v10, v13, :cond_b

    .line 707
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->startToEnd:I

    .line 710
    .local v2, "resolvedLeftToRight":I
    .local v5, "resolvedLeftToLeft":I
    :cond_b
    :goto_2
    move/from16 v28, v5

    move v5, v2

    move/from16 v2, v28

    if-ne v7, v13, :cond_d

    if-ne v8, v13, :cond_d

    .line 711
    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->endToStart:I

    if-eq v10, v13, :cond_c

    .line 712
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->endToStart:I

    goto :goto_3

    .line 713
    :cond_c
    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->endToEnd:I

    if-eq v10, v13, :cond_d

    .line 714
    iget v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->endToEnd:I

    .line 720
    .end local v5    # "resolvedLeftToLeft":I
    .end local v6    # "resolveGoneLeftMargin":I
    .end local v7    # "resolvedRightToLeft":I
    .local v2, "resolvedLeftToLeft":I
    .local v8, "resolvedHorizontalBias":F
    .local v9, "resolvedRightToRight":I
    .local v10, "resolvedRightToLeft":I
    .local v14, "resolvedLeftToRight":I
    .local v15, "resolveGoneLeftMargin":I
    .local v16, "resolveGoneRightMargin":I
    :cond_d
    :goto_3
    move v15, v6

    move v10, v7

    move/from16 v16, v9

    move v9, v8

    move v8, v14

    move v14, v2

    move v2, v5

    goto :goto_4

    .line 720
    .end local v2    # "resolvedLeftToLeft":I
    .end local v15    # "resolveGoneLeftMargin":I
    .end local v16    # "resolveGoneRightMargin":I
    .restart local v5    # "resolvedLeftToLeft":I
    .local v6, "resolvedLeftToRight":I
    .restart local v7    # "resolvedRightToLeft":I
    .local v8, "resolvedRightToRight":I
    .local v9, "resolveGoneLeftMargin":I
    .local v10, "resolveGoneRightMargin":I
    .local v14, "resolvedHorizontalBias":F
    :cond_e
    move v2, v5

    move v15, v9

    move/from16 v16, v10

    move v10, v7

    move v9, v8

    move v8, v14

    move v14, v6

    .line 720
    .end local v5    # "resolvedLeftToLeft":I
    .end local v6    # "resolvedLeftToRight":I
    .end local v7    # "resolvedRightToLeft":I
    .restart local v2    # "resolvedLeftToLeft":I
    .local v8, "resolvedHorizontalBias":F
    .local v9, "resolvedRightToRight":I
    .local v10, "resolvedRightToLeft":I
    .local v14, "resolvedLeftToRight":I
    .restart local v15    # "resolveGoneLeftMargin":I
    .restart local v16    # "resolveGoneRightMargin":I
    :goto_4
    if-eq v2, v13, :cond_10

    .line 721
    invoke-direct {v0, v2}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 722
    .local v17, "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_f

    .line 723
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v18, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->leftMargin:I

    move-object v5, v11

    move/from16 v19, v7

    move-object/from16 v7, v17

    move/from16 v20, v8

    move-object/from16 v8, v18

    .line 723
    .end local v8    # "resolvedHorizontalBias":F
    .local v20, "resolvedHorizontalBias":F
    move/from16 v21, v9

    move/from16 v9, v19

    .line 723
    .end local v9    # "resolvedRightToRight":I
    .local v21, "resolvedRightToRight":I
    move/from16 v22, v10

    move v10, v15

    .line 723
    .end local v10    # "resolvedRightToLeft":I
    .local v22, "resolvedRightToLeft":I
    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 723
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_5

    .line 727
    .end local v20    # "resolvedHorizontalBias":F
    .end local v21    # "resolvedRightToRight":I
    .end local v22    # "resolvedRightToLeft":I
    .restart local v8    # "resolvedHorizontalBias":F
    .restart local v9    # "resolvedRightToRight":I
    .restart local v10    # "resolvedRightToLeft":I
    :cond_f
    move/from16 v20, v8

    move/from16 v21, v9

    move/from16 v22, v10

    .line 727
    .end local v8    # "resolvedHorizontalBias":F
    .end local v9    # "resolvedRightToRight":I
    .end local v10    # "resolvedRightToLeft":I
    .restart local v20    # "resolvedHorizontalBias":F
    .restart local v21    # "resolvedRightToRight":I
    .restart local v22    # "resolvedRightToLeft":I
    :goto_5
    goto :goto_6

    .line 727
    .end local v20    # "resolvedHorizontalBias":F
    .end local v21    # "resolvedRightToRight":I
    .end local v22    # "resolvedRightToLeft":I
    .restart local v8    # "resolvedHorizontalBias":F
    .restart local v9    # "resolvedRightToRight":I
    .restart local v10    # "resolvedRightToLeft":I
    :cond_10
    move/from16 v20, v8

    move/from16 v21, v9

    move/from16 v22, v10

    .line 727
    .end local v8    # "resolvedHorizontalBias":F
    .end local v9    # "resolvedRightToRight":I
    .end local v10    # "resolvedRightToLeft":I
    .restart local v20    # "resolvedHorizontalBias":F
    .restart local v21    # "resolvedRightToRight":I
    .restart local v22    # "resolvedRightToLeft":I
    if-eq v14, v13, :cond_11

    .line 728
    invoke-direct {v0, v14}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 729
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_11

    .line 730
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->leftMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    move v10, v15

    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 737
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_11
    :goto_6
    move/from16 v10, v22

    if-eq v10, v13, :cond_13

    .line 738
    .end local v22    # "resolvedRightToLeft":I
    .restart local v10    # "resolvedRightToLeft":I
    invoke-direct {v0, v10}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 739
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_12

    .line 740
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->rightMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    move/from16 v18, v10

    move/from16 v10, v16

    .line 740
    .end local v10    # "resolvedRightToLeft":I
    .local v18, "resolvedRightToLeft":I
    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 740
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_7

    .line 744
    .end local v18    # "resolvedRightToLeft":I
    .restart local v10    # "resolvedRightToLeft":I
    :cond_12
    move/from16 v18, v10

    .line 754
    .end local v10    # "resolvedRightToLeft":I
    .restart local v18    # "resolvedRightToLeft":I
    :goto_7
    move/from16 v19, v21

    goto :goto_8

    .line 744
    .end local v18    # "resolvedRightToLeft":I
    .restart local v10    # "resolvedRightToLeft":I
    :cond_13
    move/from16 v18, v10

    .line 744
    .end local v10    # "resolvedRightToLeft":I
    .restart local v18    # "resolvedRightToLeft":I
    move/from16 v10, v21

    if-eq v10, v13, :cond_14

    .line 745
    .end local v21    # "resolvedRightToRight":I
    .local v10, "resolvedRightToRight":I
    invoke-direct {v0, v10}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 746
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_14

    .line 747
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->rightMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    move/from16 v19, v10

    move/from16 v10, v16

    .line 747
    .end local v10    # "resolvedRightToRight":I
    .local v19, "resolvedRightToRight":I
    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 747
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_8

    .line 754
    .end local v19    # "resolvedRightToRight":I
    .restart local v10    # "resolvedRightToRight":I
    :cond_14
    move/from16 v19, v10

    .line 754
    .end local v10    # "resolvedRightToRight":I
    .restart local v19    # "resolvedRightToRight":I
    :goto_8
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToTop:I

    if-eq v5, v13, :cond_16

    .line 755
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToTop:I

    invoke-direct {v0, v5}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 756
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_15

    .line 757
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topMargin:I

    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneTopMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 761
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_15
    goto :goto_9

    :cond_16
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToBottom:I

    if-eq v5, v13, :cond_17

    .line 762
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topToBottom:I

    invoke-direct {v0, v5}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 763
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_17

    .line 764
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topMargin:I

    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneTopMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 771
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_17
    :goto_9
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToTop:I

    if-eq v5, v13, :cond_19

    .line 772
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToTop:I

    invoke-direct {v0, v5}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 773
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_18

    .line 774
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomMargin:I

    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneBottomMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 778
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_18
    goto :goto_a

    :cond_19
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToBottom:I

    if-eq v5, v13, :cond_1a

    .line 779
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomToBottom:I

    invoke-direct {v0, v5}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v17

    .line 780
    .restart local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v17, :cond_1a

    .line 781
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomMargin:I

    iget v10, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->goneBottomMargin:I

    move-object v5, v11

    move-object/from16 v7, v17

    invoke-virtual/range {v5 .. v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->immediateConnect(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;II)V

    .line 788
    .end local v17    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_1a
    :goto_a
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->baselineToBaseline:I

    if-eq v5, v13, :cond_1b

    .line 789
    iget-object v5, v0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->baselineToBaseline:I

    invoke-virtual {v5, v6}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/view/View;

    .line 790
    .local v5, "view":Landroid/view/View;
    iget v6, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->baselineToBaseline:I

    invoke-direct {v0, v6}, Landroid/support/constraint/ConstraintLayout;->getTargetWidget(I)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v6

    .line 791
    .local v6, "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v6, :cond_1b

    if-eqz v5, :cond_1b

    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v7

    instance-of v7, v7, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    if-eqz v7, :cond_1b

    .line 792
    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v7

    check-cast v7, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 793
    .local v7, "targetParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    const/4 v8, 0x1

    iput-boolean v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->needsBaseline:Z

    .line 794
    iput-boolean v8, v7, Landroid/support/constraint/ConstraintLayout$LayoutParams;->needsBaseline:Z

    .line 795
    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BASELINE:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v8}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v8

    .line 796
    .local v8, "baseline":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BASELINE:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    .line 797
    invoke-virtual {v6, v9}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v9

    .line 798
    .local v9, "targetBaseline":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    const/16 v23, 0x0

    const/16 v24, -0x1

    sget-object v25, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Strength;->STRONG:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Strength;

    const/16 v26, 0x0

    const/16 v27, 0x1

    move-object/from16 v21, v8

    move-object/from16 v22, v9

    invoke-virtual/range {v21 .. v27}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->connect(Landroid/support/constraint/solver/widgets/ConstraintAnchor;IILandroid/support/constraint/solver/widgets/ConstraintAnchor$Strength;IZ)Z

    .line 801
    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v10

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->reset()V

    .line 802
    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v10

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->reset()V

    .line 806
    .end local v5    # "view":Landroid/view/View;
    .end local v6    # "target":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "targetParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .end local v8    # "baseline":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v9    # "targetBaseline":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    :cond_1b
    const/4 v5, 0x0

    move/from16 v6, v20

    cmpl-float v7, v6, v5

    .line 806
    .end local v20    # "resolvedHorizontalBias":F
    .local v6, "resolvedHorizontalBias":F
    const/high16 v8, 0x3f000000    # 0.5f

    if-ltz v7, :cond_1c

    cmpl-float v7, v6, v8

    if-eqz v7, :cond_1c

    .line 807
    invoke-virtual {v11, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalBiasPercent(F)V

    .line 809
    :cond_1c
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalBias:F

    cmpl-float v5, v7, v5

    if-ltz v5, :cond_1d

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalBias:F

    cmpl-float v5, v5, v8

    if-eqz v5, :cond_1d

    .line 810
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalBias:F

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalBiasPercent(F)V

    .line 813
    :cond_1d
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->isInEditMode()Z

    move-result v5

    if-eqz v5, :cond_1f

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteX:I

    if-ne v5, v13, :cond_1e

    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteY:I

    if-eq v5, v13, :cond_1f

    .line 815
    :cond_1e
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteX:I

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->editorAbsoluteY:I

    invoke-virtual {v11, v5, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setOrigin(II)V

    .line 819
    :cond_1f
    iget-boolean v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalDimensionFixed:Z

    if-nez v5, :cond_21

    .line 820
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    if-ne v5, v13, :cond_20

    .line 821
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_PARENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 822
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v5

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->leftMargin:I

    iput v7, v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    .line 823
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v5

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->rightMargin:I

    iput v7, v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    goto :goto_b

    .line 825
    :cond_20
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 826
    const/4 v5, 0x0

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWidth(I)V

    goto :goto_b

    .line 829
    :cond_21
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 830
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWidth(I)V

    .line 832
    :goto_b
    iget-boolean v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalDimensionFixed:Z

    if-nez v5, :cond_23

    .line 833
    iget v5, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    if-ne v5, v13, :cond_22

    .line 834
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_PARENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 835
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v5

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->topMargin:I

    iput v7, v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    .line 836
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v5

    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->bottomMargin:I

    iput v7, v5, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    .line 846
    const/4 v5, 0x0

    goto :goto_c

    .line 838
    :cond_22
    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 839
    const/4 v5, 0x0

    invoke-virtual {v11, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHeight(I)V

    goto :goto_c

    .line 842
    :cond_23
    const/4 v5, 0x0

    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 843
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHeight(I)V

    .line 846
    :goto_c
    iget-object v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->dimensionRatio:Ljava/lang/String;

    if-eqz v7, :cond_24

    .line 847
    iget-object v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->dimensionRatio:Ljava/lang/String;

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setDimensionRatio(Ljava/lang/String;)V

    .line 849
    :cond_24
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalWeight:F

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalWeight(F)V

    .line 850
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalWeight:F

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalWeight(F)V

    .line 851
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->horizontalChainStyle:I

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalChainStyle(I)V

    .line 852
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->verticalChainStyle:I

    invoke-virtual {v11, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalChainStyle(I)V

    .line 853
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintDefaultWidth:I

    iget v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintMinWidth:I

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintMaxWidth:I

    invoke-virtual {v11, v7, v8, v9}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalMatchStyle(III)V

    .line 855
    iget v7, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintDefaultHeight:I

    iget v8, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintMinHeight:I

    iget v9, v12, Landroid/support/constraint/ConstraintLayout$LayoutParams;->matchConstraintMaxHeight:I

    invoke-virtual {v11, v7, v8, v9}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalMatchStyle(III)V

    .line 641
    .end local v2    # "resolvedLeftToLeft":I
    .end local v4    # "child":Landroid/view/View;
    .end local v6    # "resolvedHorizontalBias":F
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "layoutParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .end local v14    # "resolvedLeftToRight":I
    .end local v15    # "resolveGoneLeftMargin":I
    .end local v16    # "resolveGoneRightMargin":I
    .end local v18    # "resolvedRightToLeft":I
    .end local v19    # "resolvedRightToRight":I
    :goto_d
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_0

    .line 859
    .end local v3    # "i":I
    :cond_25
    return-void
.end method

.method private setSelfDimensionBehaviour(II)V
    .locals 15
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object v0, p0

    .line 1091
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v1

    .line 1092
    .local v1, "widthMode":I
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v2

    .line 1093
    .local v2, "widthSize":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v3

    .line 1094
    .local v3, "heightMode":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v4

    .line 1096
    .local v4, "heightSize":I
    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingTop()I

    move-result v5

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingBottom()I

    move-result v6

    add-int/2addr v5, v6

    .line 1097
    .local v5, "heightPadding":I
    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingLeft()I

    move-result v6

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingRight()I

    move-result v7

    add-int/2addr v6, v7

    .line 1099
    .local v6, "widthPadding":I
    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1100
    .local v7, "widthBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1101
    .local v8, "heightBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    const/4 v9, 0x0

    .line 1102
    .local v9, "desiredWidth":I
    const/4 v10, 0x0

    .line 1104
    .local v10, "desiredHeight":I
    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v11

    .line 1105
    .local v11, "params":Landroid/view/ViewGroup$LayoutParams;
    const/high16 v12, 0x40000000    # 2.0f

    const/high16 v13, -0x80000000

    if-eq v1, v13, :cond_2

    if-eqz v1, :cond_1

    if-eq v1, v12, :cond_0

    goto :goto_0

    .line 1116
    :cond_0
    iget v14, v0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    invoke-static {v14, v2}, Ljava/lang/Math;->min(II)I

    move-result v14

    sub-int v9, v14, v6

    goto :goto_0

    .line 1112
    :cond_1
    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1114
    goto :goto_0

    .line 1107
    :cond_2
    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1108
    move v9, v2

    .line 1110
    nop

    .line 1119
    :goto_0
    if-eq v3, v13, :cond_5

    if-eqz v3, :cond_4

    if-eq v3, v12, :cond_3

    goto :goto_1

    .line 1130
    :cond_3
    iget v12, v0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    invoke-static {v12, v4}, Ljava/lang/Math;->min(II)I

    move-result v12

    sub-int v10, v12, v5

    goto :goto_1

    .line 1126
    :cond_4
    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1128
    goto :goto_1

    .line 1121
    :cond_5
    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1122
    move v10, v4

    .line 1124
    nop

    .line 1134
    :goto_1
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    const/4 v13, 0x0

    invoke-virtual {v12, v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setMinWidth(I)V

    .line 1135
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12, v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setMinHeight(I)V

    .line 1136
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 1137
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12, v9}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1138
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12, v8}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 1139
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1140
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    iget v13, v0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingLeft()I

    move-result v14

    sub-int/2addr v13, v14

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingRight()I

    move-result v14

    sub-int/2addr v13, v14

    invoke-virtual {v12, v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setMinWidth(I)V

    .line 1141
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    iget v13, v0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingTop()I

    move-result v14

    sub-int/2addr v13, v14

    invoke-virtual {v0}, Landroid/support/constraint/ConstraintLayout;->getPaddingBottom()I

    move-result v14

    sub-int/2addr v13, v14

    invoke-virtual {v12, v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setMinHeight(I)V

    .line 1142
    return-void
.end method

.method private updateHierarchy()V
    .locals 5

    .line 619
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getChildCount()I

    move-result v0

    .line 621
    .local v0, "count":I
    const/4 v1, 0x0

    .line 622
    .local v1, "recompute":Z
    const/4 v2, 0x0

    .line 622
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 623
    invoke-virtual {p0, v2}, Landroid/support/constraint/ConstraintLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 624
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->isLayoutRequested()Z

    move-result v4

    if-eqz v4, :cond_0

    .line 625
    const/4 v1, 0x1

    .line 626
    goto :goto_1

    .line 622
    .end local v3    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 629
    .end local v2    # "i":I
    :cond_1
    :goto_1
    if-eqz v1, :cond_2

    .line 630
    iget-object v2, p0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->clear()V

    .line 631
    invoke-direct {p0}, Landroid/support/constraint/ConstraintLayout;->setChildrenConstraints()V

    .line 633
    :cond_2
    return-void
.end method


# virtual methods
.method public addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "index"    # I
    .param p3, "params"    # Landroid/view/ViewGroup$LayoutParams;

    .line 470
    invoke-super {p0, p1, p2, p3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 471
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-ge v0, v1, :cond_0

    .line 472
    invoke-virtual {p0, p1}, Landroid/support/constraint/ConstraintLayout;->onViewAdded(Landroid/view/View;)V

    .line 474
    :cond_0
    return-void
.end method

.method protected checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1247
    instance-of v0, p1, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    return v0
.end method

.method protected generateDefaultLayoutParams()Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .locals 2

    .line 1231
    new-instance v0, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    const/4 v1, -0x2

    invoke-direct {v0, v1, v1}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method protected bridge synthetic generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    .locals 1

    .line 383
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->generateDefaultLayoutParams()Landroid/support/constraint/ConstraintLayout$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method public generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .locals 2
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 1223
    new-instance v0, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method public bridge synthetic generateLayoutParams(Landroid/util/AttributeSet;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 383
    invoke-virtual {p0, p1}, Landroid/support/constraint/ConstraintLayout;->generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/constraint/ConstraintLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method protected generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1239
    new-instance v0, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    invoke-direct {v0, p1}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public getMaxHeight()I
    .locals 1

    .line 615
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    return v0
.end method

.method public getMaxWidth()I
    .locals 1

    .line 604
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    return v0
.end method

.method public getMinHeight()I
    .locals 1

    .line 567
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    return v0
.end method

.method public getMinWidth()I
    .locals 1

    .line 556
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    return v0
.end method

.method protected onLayout(ZIIII)V
    .locals 10
    .param p1, "changed"    # Z
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "right"    # I
    .param p5, "bottom"    # I

    .line 1163
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getChildCount()I

    move-result v0

    .line 1164
    .local v0, "widgetsCount":I
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->isInEditMode()Z

    move-result v1

    .line 1165
    .local v1, "isInEditMode":Z
    const/4 v2, 0x0

    .line 1165
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 1166
    invoke-virtual {p0, v2}, Landroid/support/constraint/ConstraintLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1167
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 1168
    .local v4, "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v5

    const/16 v6, 0x8

    if-ne v5, v6, :cond_0

    iget-boolean v5, v4, Landroid/support/constraint/ConstraintLayout$LayoutParams;->isGuideline:Z

    if-nez v5, :cond_0

    if-nez v1, :cond_0

    .line 1171
    goto :goto_1

    .line 1174
    :cond_0
    iget-object v5, v4, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1176
    .local v5, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawX()I

    move-result v6

    .line 1177
    .local v6, "l":I
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawY()I

    move-result v7

    .line 1178
    .local v7, "t":I
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v8

    add-int/2addr v8, v6

    .line 1179
    .local v8, "r":I
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v9

    add-int/2addr v9, v7

    .line 1197
    .local v9, "b":I
    invoke-virtual {v3, v6, v7, v8, v9}, Landroid/view/View;->layout(IIII)V

    .line 1165
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .end local v5    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v6    # "l":I
    .end local v7    # "t":I
    .end local v8    # "r":I
    .end local v9    # "b":I
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1199
    .end local v2    # "i":I
    :cond_1
    return-void
.end method

.method protected onMeasure(II)V
    .locals 26
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v0, p0

    move/from16 v1, p1

    .line 963
    move/from16 v2, p2

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingLeft()I

    move-result v3

    .line 964
    .local v3, "paddingLeft":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingTop()I

    move-result v4

    .line 966
    .local v4, "paddingTop":I
    iget-object v5, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v5, v3}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setX(I)V

    .line 967
    iget-object v5, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v5, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setY(I)V

    .line 968
    invoke-direct/range {p0 .. p2}, Landroid/support/constraint/ConstraintLayout;->setSelfDimensionBehaviour(II)V

    .line 969
    iget-boolean v5, v0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    const/4 v6, 0x0

    if-eqz v5, :cond_0

    .line 970
    iput-boolean v6, v0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 971
    invoke-direct/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->updateHierarchy()V

    .line 973
    :cond_0
    invoke-direct/range {p0 .. p2}, Landroid/support/constraint/ConstraintLayout;->internalMeasureChildren(II)V

    .line 982
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getChildCount()I

    move-result v5

    if-lez v5, :cond_1

    .line 983
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->solveLinearSystem()V

    .line 985
    :cond_1
    const/4 v5, 0x0

    .line 988
    .local v5, "childState":I
    iget-object v7, v0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    .line 990
    .local v7, "sizeDependentWidgetsCount":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingBottom()I

    move-result v8

    add-int/2addr v8, v4

    .line 991
    .local v8, "heightPadding":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->getPaddingRight()I

    move-result v9

    add-int/2addr v9, v3

    .line 993
    .local v9, "widthPadding":I
    if-lez v7, :cond_11

    .line 994
    const/4 v11, 0x0

    .line 995
    .local v11, "needSolverPass":Z
    iget-object v12, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHorizontalDimensionBehaviour()Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    move-result-object v12

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    const/4 v14, 0x1

    if-ne v12, v13, :cond_2

    move v12, v14

    goto :goto_0

    :cond_2
    move v12, v6

    .line 997
    .local v12, "containerWrapWidth":Z
    :goto_0
    iget-object v13, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getVerticalDimensionBehaviour()Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    move-result-object v13

    sget-object v15, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v13, v15, :cond_3

    goto :goto_1

    :cond_3
    move v14, v6

    :goto_1
    move v13, v14

    .line 999
    .local v13, "containerWrapHeight":Z
    nop

    .line 999
    .local v6, "i":I
    :goto_2
    if-ge v6, v7, :cond_10

    .line 1000
    iget-object v14, v0, Landroid/support/constraint/ConstraintLayout;->mVariableDimensionsWidgets:Ljava/util/ArrayList;

    invoke-virtual {v14, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1001
    .local v14, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v15, v14, Landroid/support/constraint/solver/widgets/Guideline;

    if-eqz v15, :cond_4

    .line 1002
    nop

    .line 999
    .end local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_3
    move/from16 v16, v3

    goto :goto_4

    .line 1004
    .restart local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_4
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getCompanionWidget()Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Landroid/view/View;

    .line 1005
    .local v15, "child":Landroid/view/View;
    if-nez v15, :cond_5

    .line 1006
    goto :goto_3

    .line 1008
    :cond_5
    invoke-virtual {v15}, Landroid/view/View;->getVisibility()I

    move-result v10

    move/from16 v16, v3

    const/16 v3, 0x8

    .line 1008
    .end local v3    # "paddingLeft":I
    .local v16, "paddingLeft":I
    if-ne v10, v3, :cond_6

    .line 1009
    nop

    .line 999
    .end local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v15    # "child":Landroid/view/View;
    .end local v16    # "paddingLeft":I
    .restart local v3    # "paddingLeft":I
    :goto_4
    move/from16 v19, v4

    move/from16 v20, v7

    move/from16 v25, v12

    .line 999
    .end local v3    # "paddingLeft":I
    .restart local v16    # "paddingLeft":I
    goto/16 :goto_a

    .line 1012
    .restart local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v15    # "child":Landroid/view/View;
    :cond_6
    const/4 v3, 0x0

    .line 1013
    .local v3, "widthSpec":I
    const/4 v10, 0x0

    .line 1015
    .local v10, "heightSpec":I
    invoke-virtual {v15}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v17

    move/from16 v18, v3

    move-object/from16 v3, v17

    check-cast v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 1016
    .local v3, "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .local v18, "widthSpec":I
    move/from16 v19, v4

    iget v4, v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    .line 1016
    .end local v4    # "paddingTop":I
    .local v19, "paddingTop":I
    move/from16 v20, v7

    .line 1016
    .end local v7    # "sizeDependentWidgetsCount":I
    .local v20, "sizeDependentWidgetsCount":I
    const/4 v7, -0x2

    if-ne v4, v7, :cond_7

    .line 1017
    iget v4, v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;->width:I

    invoke-static {v1, v9, v4}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v4

    .line 1021
    .end local v18    # "widthSpec":I
    .local v4, "widthSpec":I
    const/high16 v7, 0x40000000    # 2.0f

    goto :goto_5

    .line 1019
    .end local v4    # "widthSpec":I
    .restart local v18    # "widthSpec":I
    :cond_7
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v4

    const/high16 v7, 0x40000000    # 2.0f

    invoke-static {v4, v7}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v4

    .line 1021
    .end local v18    # "widthSpec":I
    .restart local v4    # "widthSpec":I
    :goto_5
    iget v7, v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    move/from16 v21, v10

    const/4 v10, -0x2

    if-ne v7, v10, :cond_8

    .line 1022
    .end local v10    # "heightSpec":I
    .local v21, "heightSpec":I
    iget v7, v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;->height:I

    invoke-static {v2, v8, v7}, Landroid/support/constraint/ConstraintLayout;->getChildMeasureSpec(III)I

    move-result v7

    .line 1022
    .end local v21    # "heightSpec":I
    .local v7, "heightSpec":I
    :goto_6
    goto :goto_7

    .line 1024
    .end local v7    # "heightSpec":I
    .restart local v21    # "heightSpec":I
    :cond_8
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v7

    const/high16 v10, 0x40000000    # 2.0f

    invoke-static {v7, v10}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v7

    goto :goto_6

    .line 1028
    .end local v21    # "heightSpec":I
    .restart local v7    # "heightSpec":I
    :goto_7
    invoke-virtual {v15, v4, v7}, Landroid/view/View;->measure(II)V

    .line 1030
    invoke-virtual {v15}, Landroid/view/View;->getMeasuredWidth()I

    move-result v10

    .line 1031
    .local v10, "measuredWidth":I
    move/from16 v22, v4

    invoke-virtual {v15}, Landroid/view/View;->getMeasuredHeight()I

    move-result v4

    .line 1032
    .local v4, "measuredHeight":I
    .local v22, "widthSpec":I
    move/from16 v23, v7

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v7

    .line 1032
    .end local v7    # "heightSpec":I
    .local v23, "heightSpec":I
    if-eq v10, v7, :cond_b

    .line 1033
    invoke-virtual {v14, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setWidth(I)V

    .line 1034
    if-eqz v12, :cond_a

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getRight()I

    move-result v7

    move/from16 v24, v10

    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    .line 1034
    .end local v10    # "measuredWidth":I
    .local v24, "measuredWidth":I
    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v10

    if-le v7, v10, :cond_9

    .line 1035
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getRight()I

    move-result v7

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    .line 1036
    invoke-virtual {v14, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v10

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v10

    add-int/2addr v7, v10

    .line 1037
    .local v7, "w":I
    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    move/from16 v25, v12

    iget v12, v0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    .line 1037
    .end local v12    # "containerWrapWidth":Z
    .local v25, "containerWrapWidth":Z
    invoke-static {v12, v7}, Ljava/lang/Math;->max(II)I

    move-result v12

    invoke-virtual {v10, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1037
    .end local v7    # "w":I
    goto :goto_8

    .line 1039
    .end local v25    # "containerWrapWidth":Z
    .restart local v12    # "containerWrapWidth":Z
    :cond_9
    move/from16 v25, v12

    .line 1039
    .end local v12    # "containerWrapWidth":Z
    .restart local v25    # "containerWrapWidth":Z
    goto :goto_8

    .line 1039
    .end local v24    # "measuredWidth":I
    .end local v25    # "containerWrapWidth":Z
    .restart local v10    # "measuredWidth":I
    .restart local v12    # "containerWrapWidth":Z
    :cond_a
    move/from16 v24, v10

    move/from16 v25, v12

    .line 1039
    .end local v10    # "measuredWidth":I
    .end local v12    # "containerWrapWidth":Z
    .restart local v24    # "measuredWidth":I
    .restart local v25    # "containerWrapWidth":Z
    :goto_8
    const/4 v11, 0x1

    goto :goto_9

    .line 1041
    .end local v24    # "measuredWidth":I
    .end local v25    # "containerWrapWidth":Z
    .restart local v10    # "measuredWidth":I
    .restart local v12    # "containerWrapWidth":Z
    :cond_b
    move/from16 v24, v10

    move/from16 v25, v12

    .line 1041
    .end local v10    # "measuredWidth":I
    .end local v12    # "containerWrapWidth":Z
    .restart local v24    # "measuredWidth":I
    .restart local v25    # "containerWrapWidth":Z
    :goto_9
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v7

    if-eq v4, v7, :cond_d

    .line 1042
    invoke-virtual {v14, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHeight(I)V

    .line 1043
    if-eqz v13, :cond_c

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getBottom()I

    move-result v7

    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v10

    if-le v7, v10, :cond_c

    .line 1044
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getBottom()I

    move-result v7

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    .line 1045
    invoke-virtual {v14, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getAnchor(Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;)Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v10

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v10

    add-int/2addr v7, v10

    .line 1046
    .local v7, "h":I
    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    iget v12, v0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    invoke-static {v12, v7}, Ljava/lang/Math;->max(II)I

    move-result v12

    invoke-virtual {v10, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1048
    .end local v7    # "h":I
    :cond_c
    const/4 v11, 0x1

    .line 1050
    :cond_d
    iget-boolean v7, v3, Landroid/support/constraint/ConstraintLayout$LayoutParams;->needsBaseline:Z

    if-eqz v7, :cond_e

    .line 1051
    invoke-virtual {v15}, Landroid/view/View;->getBaseline()I

    move-result v7

    .line 1052
    .local v7, "baseline":I
    const/4 v10, -0x1

    if-eq v7, v10, :cond_e

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getBaselineDistance()I

    move-result v10

    if-eq v7, v10, :cond_e

    .line 1053
    invoke-virtual {v14, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setBaselineDistance(I)V

    .line 1054
    const/4 v11, 0x1

    .line 1058
    .end local v7    # "baseline":I
    :cond_e
    sget v7, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v10, 0xb

    if-lt v7, v10, :cond_f

    .line 1059
    invoke-virtual {v15}, Landroid/view/View;->getMeasuredState()I

    move-result v7

    invoke-static {v5, v7}, Landroid/support/constraint/ConstraintLayout;->combineMeasuredStates(II)I

    move-result v5

    .line 999
    .end local v3    # "params":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    .end local v4    # "measuredHeight":I
    .end local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v15    # "child":Landroid/view/View;
    .end local v22    # "widthSpec":I
    .end local v23    # "heightSpec":I
    .end local v24    # "measuredWidth":I
    :cond_f
    :goto_a
    add-int/lit8 v6, v6, 0x1

    move/from16 v3, v16

    move/from16 v4, v19

    move/from16 v7, v20

    move/from16 v12, v25

    goto/16 :goto_2

    .line 1062
    .end local v6    # "i":I
    .end local v16    # "paddingLeft":I
    .end local v19    # "paddingTop":I
    .end local v20    # "sizeDependentWidgetsCount":I
    .end local v25    # "containerWrapWidth":Z
    .local v3, "paddingLeft":I
    .local v4, "paddingTop":I
    .local v7, "sizeDependentWidgetsCount":I
    .restart local v12    # "containerWrapWidth":Z
    :cond_10
    move/from16 v16, v3

    move/from16 v19, v4

    move/from16 v20, v7

    move/from16 v25, v12

    .line 1062
    .end local v3    # "paddingLeft":I
    .end local v4    # "paddingTop":I
    .end local v7    # "sizeDependentWidgetsCount":I
    .end local v12    # "containerWrapWidth":Z
    .restart local v16    # "paddingLeft":I
    .restart local v19    # "paddingTop":I
    .restart local v20    # "sizeDependentWidgetsCount":I
    .restart local v25    # "containerWrapWidth":Z
    if-eqz v11, :cond_12

    .line 1063
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/ConstraintLayout;->solveLinearSystem()V

    .line 1063
    .end local v11    # "needSolverPass":Z
    .end local v13    # "containerWrapHeight":Z
    .end local v25    # "containerWrapWidth":Z
    goto :goto_b

    .line 1067
    .end local v16    # "paddingLeft":I
    .end local v19    # "paddingTop":I
    .end local v20    # "sizeDependentWidgetsCount":I
    .restart local v3    # "paddingLeft":I
    .restart local v4    # "paddingTop":I
    .restart local v7    # "sizeDependentWidgetsCount":I
    :cond_11
    move/from16 v16, v3

    move/from16 v19, v4

    move/from16 v20, v7

    .line 1067
    .end local v3    # "paddingLeft":I
    .end local v4    # "paddingTop":I
    .end local v7    # "sizeDependentWidgetsCount":I
    .restart local v16    # "paddingLeft":I
    .restart local v19    # "paddingTop":I
    .restart local v20    # "sizeDependentWidgetsCount":I
    :cond_12
    :goto_b
    iget-object v3, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v3

    add-int/2addr v3, v9

    .line 1068
    .local v3, "androidLayoutWidth":I
    iget-object v4, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v4

    add-int/2addr v4, v8

    .line 1070
    .local v4, "androidLayoutHeight":I
    sget v6, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v7, 0xb

    if-lt v6, v7, :cond_15

    .line 1071
    invoke-static {v3, v1, v5}, Landroid/support/constraint/ConstraintLayout;->resolveSizeAndState(III)I

    move-result v6

    .line 1072
    .local v6, "resolvedWidthSize":I
    shl-int/lit8 v7, v5, 0x10

    invoke-static {v4, v2, v7}, Landroid/support/constraint/ConstraintLayout;->resolveSizeAndState(III)I

    move-result v7

    .line 1074
    .local v7, "resolvedHeightSize":I
    iget v10, v0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    invoke-static {v10, v6}, Ljava/lang/Math;->min(II)I

    move-result v6

    .line 1075
    iget v10, v0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    invoke-static {v10, v7}, Ljava/lang/Math;->min(II)I

    move-result v7

    .line 1076
    const v10, 0xffffff

    and-int/2addr v6, v10

    .line 1077
    and-int/2addr v7, v10

    .line 1078
    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->isWidthMeasuredTooSmall()Z

    move-result v10

    const/high16 v11, 0x1000000

    if-eqz v10, :cond_13

    .line 1079
    or-int/2addr v6, v11

    .line 1081
    :cond_13
    iget-object v10, v0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->isHeightMeasuredTooSmall()Z

    move-result v10

    if-eqz v10, :cond_14

    .line 1082
    or-int/2addr v7, v11

    .line 1084
    :cond_14
    invoke-virtual {v0, v6, v7}, Landroid/support/constraint/ConstraintLayout;->setMeasuredDimension(II)V

    .line 1085
    .end local v6    # "resolvedWidthSize":I
    .end local v7    # "resolvedHeightSize":I
    goto :goto_c

    .line 1086
    :cond_15
    invoke-virtual {v0, v3, v4}, Landroid/support/constraint/ConstraintLayout;->setMeasuredDimension(II)V

    .line 1088
    :goto_c
    return-void
.end method

.method public onViewAdded(Landroid/view/View;)V
    .locals 5
    .param p1, "view"    # Landroid/view/View;

    .line 492
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_0

    .line 493
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onViewAdded(Landroid/view/View;)V

    .line 495
    :cond_0
    invoke-direct {p0, p1}, Landroid/support/constraint/ConstraintLayout;->getViewWidget(Landroid/view/View;)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v0

    .line 496
    .local v0, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v1, p1, Landroid/support/constraint/Guideline;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    .line 497
    instance-of v1, v0, Landroid/support/constraint/solver/widgets/Guideline;

    if-nez v1, :cond_1

    .line 498
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;

    .line 499
    .local v1, "layoutParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    new-instance v3, Landroid/support/constraint/solver/widgets/Guideline;

    invoke-direct {v3}, Landroid/support/constraint/solver/widgets/Guideline;-><init>()V

    iput-object v3, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 500
    iput-boolean v2, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->isGuideline:Z

    .line 501
    iget-object v3, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    check-cast v3, Landroid/support/constraint/solver/widgets/Guideline;

    iget v4, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->orientation:I

    invoke-virtual {v3, v4}, Landroid/support/constraint/solver/widgets/Guideline;->setOrientation(I)V

    .line 502
    iget-object v0, v1, Landroid/support/constraint/ConstraintLayout$LayoutParams;->widget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 505
    .end local v1    # "layoutParams":Landroid/support/constraint/ConstraintLayout$LayoutParams;
    :cond_1
    iget-object v1, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v3

    invoke-virtual {v1, v3, p1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 506
    iput-boolean v2, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 507
    return-void
.end method

.method public onViewRemoved(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 514
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_0

    .line 515
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onViewRemoved(Landroid/view/View;)V

    .line 517
    :cond_0
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->remove(I)V

    .line 518
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-direct {p0, p1}, Landroid/support/constraint/ConstraintLayout;->getViewWidget(Landroid/view/View;)Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->remove(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 519
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 520
    return-void
.end method

.method public removeView(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 481
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 482
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-ge v0, v1, :cond_0

    .line 483
    invoke-virtual {p0, p1}, Landroid/support/constraint/ConstraintLayout;->onViewRemoved(Landroid/view/View;)V

    .line 485
    :cond_0
    return-void
.end method

.method public requestLayout()V
    .locals 1

    .line 1959
    invoke-super {p0}, Landroid/view/ViewGroup;->requestLayout()V

    .line 1960
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/constraint/ConstraintLayout;->mDirtyHierarchy:Z

    .line 1961
    return-void
.end method

.method public setConstraintSet(Landroid/support/constraint/ConstraintSet;)V
    .locals 0
    .param p1, "set"    # Landroid/support/constraint/ConstraintSet;

    .line 1255
    iput-object p1, p0, Landroid/support/constraint/ConstraintLayout;->mConstraintSet:Landroid/support/constraint/ConstraintSet;

    .line 1256
    return-void
.end method

.method public setId(I)V
    .locals 2
    .param p1, "id"    # I

    .line 430
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->remove(I)V

    .line 431
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->setId(I)V

    .line 432
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mChildrenByIds:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->getId()I

    move-result v1

    invoke-virtual {v0, v1, p0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 433
    return-void
.end method

.method public setMaxHeight(I)V
    .locals 1
    .param p1, "value"    # I

    .line 589
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    if-ne p1, v0, :cond_0

    .line 590
    return-void

    .line 592
    :cond_0
    iput p1, p0, Landroid/support/constraint/ConstraintLayout;->mMaxHeight:I

    .line 593
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->requestLayout()V

    .line 594
    return-void
.end method

.method public setMaxWidth(I)V
    .locals 1
    .param p1, "value"    # I

    .line 576
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    if-ne p1, v0, :cond_0

    .line 577
    return-void

    .line 579
    :cond_0
    iput p1, p0, Landroid/support/constraint/ConstraintLayout;->mMaxWidth:I

    .line 580
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->requestLayout()V

    .line 581
    return-void
.end method

.method public setMinHeight(I)V
    .locals 1
    .param p1, "value"    # I

    .line 541
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    if-ne p1, v0, :cond_0

    .line 542
    return-void

    .line 544
    :cond_0
    iput p1, p0, Landroid/support/constraint/ConstraintLayout;->mMinHeight:I

    .line 545
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->requestLayout()V

    .line 546
    return-void
.end method

.method public setMinWidth(I)V
    .locals 1
    .param p1, "value"    # I

    .line 528
    iget v0, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    if-ne p1, v0, :cond_0

    .line 529
    return-void

    .line 531
    :cond_0
    iput p1, p0, Landroid/support/constraint/ConstraintLayout;->mMinWidth:I

    .line 532
    invoke-virtual {p0}, Landroid/support/constraint/ConstraintLayout;->requestLayout()V

    .line 533
    return-void
.end method

.method public setOptimizationLevel(I)V
    .locals 1
    .param p1, "level"    # I

    .line 1215
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v0, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setOptimizationLevel(I)V

    .line 1216
    return-void
.end method

.method protected solveLinearSystem()V
    .locals 1

    .line 1151
    iget-object v0, p0, Landroid/support/constraint/ConstraintLayout;->mLayoutWidget:Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    invoke-virtual {v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->layout()V

    .line 1156
    return-void
.end method
