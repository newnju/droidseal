.class public Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;
.super Landroid/support/constraint/solver/widgets/WidgetContainer;
.source "ConstraintWidgetContainer.java"


# static fields
.field static ALLOW_ROOT_GROUP:Z = false

.field private static final CHAIN_FIRST:I = 0x0

.field private static final CHAIN_FIRST_VISIBLE:I = 0x2

.field private static final CHAIN_LAST:I = 0x1

.field private static final CHAIN_LAST_VISIBLE:I = 0x3

.field private static final DEBUG:Z = false

.field private static final DEBUG_LAYOUT:Z = false

.field private static final DEBUG_OPTIMIZE:Z = false

.field private static final FLAG_CHAIN_DANGLING:I = 0x1

.field private static final FLAG_CHAIN_OPTIMIZE:I = 0x0

.field private static final FLAG_RECOMPUTE_BOUNDS:I = 0x2

.field private static final MAX_ITERATIONS:I = 0x8

.field public static final OPTIMIZATION_ALL:I = 0x2

.field public static final OPTIMIZATION_BASIC:I = 0x4

.field public static final OPTIMIZATION_CHAIN:I = 0x8

.field public static final OPTIMIZATION_NONE:I = 0x1

.field private static final USE_SNAPSHOT:Z = true

.field private static final USE_THREAD:Z = false


# instance fields
.field private flags:[Z

.field protected mBackgroundSystem:Landroid/support/constraint/solver/LinearSystem;

.field private mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

.field private mHeightMeasuredTooSmall:Z

.field private mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

.field private mHorizontalChainsSize:I

.field private mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

.field private mOptimizationLevel:I

.field mPaddingBottom:I

.field mPaddingLeft:I

.field mPaddingRight:I

.field mPaddingTop:I

.field private mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

.field protected mSystem:Landroid/support/constraint/solver/LinearSystem;

.field private mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

.field private mVerticalChainsSize:I

.field private mWidthMeasuredTooSmall:Z

.field mWrapHeight:I

.field mWrapWidth:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 44
    const/4 v0, 0x1

    sput-boolean v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->ALLOW_ROOT_GROUP:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 92
    invoke-direct {p0}, Landroid/support/constraint/solver/widgets/WidgetContainer;-><init>()V

    .line 39
    new-instance v0, Landroid/support/constraint/solver/LinearSystem;

    invoke-direct {v0}, Landroid/support/constraint/solver/LinearSystem;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 40
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mBackgroundSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 54
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    .line 55
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    .line 56
    const/4 v1, 0x4

    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 57
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 58
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 66
    const/4 v2, 0x2

    iput v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    .line 69
    const/4 v2, 0x3

    new-array v2, v2, [Z

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    .line 76
    new-array v1, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 82
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 83
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 93
    return-void
.end method

.method public constructor <init>(II)V
    .locals 3
    .param p1, "width"    # I
    .param p2, "height"    # I

    .line 114
    invoke-direct {p0, p1, p2}, Landroid/support/constraint/solver/widgets/WidgetContainer;-><init>(II)V

    .line 39
    new-instance v0, Landroid/support/constraint/solver/LinearSystem;

    invoke-direct {v0}, Landroid/support/constraint/solver/LinearSystem;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 40
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mBackgroundSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 54
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    .line 55
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    .line 56
    const/4 v1, 0x4

    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 57
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 58
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 66
    const/4 v2, 0x2

    iput v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    .line 69
    const/4 v2, 0x3

    new-array v2, v2, [Z

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    .line 76
    new-array v1, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 82
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 83
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 115
    return-void
.end method

.method public constructor <init>(IIII)V
    .locals 3
    .param p1, "x"    # I
    .param p2, "y"    # I
    .param p3, "width"    # I
    .param p4, "height"    # I

    .line 104
    invoke-direct {p0, p1, p2, p3, p4}, Landroid/support/constraint/solver/widgets/WidgetContainer;-><init>(IIII)V

    .line 39
    new-instance v0, Landroid/support/constraint/solver/LinearSystem;

    invoke-direct {v0}, Landroid/support/constraint/solver/LinearSystem;-><init>()V

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 40
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mBackgroundSystem:Landroid/support/constraint/solver/LinearSystem;

    .line 54
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    .line 55
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    .line 56
    const/4 v1, 0x4

    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 57
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 58
    new-array v2, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 66
    const/4 v2, 0x2

    iput v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    .line 69
    const/4 v2, 0x3

    new-array v2, v2, [Z

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    .line 76
    new-array v1, v1, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 82
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 83
    iput-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 105
    return-void
.end method

.method private addHorizontalChain(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V
    .locals 2
    .param p1, "widget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1849
    const/4 v0, 0x0

    .line 1849
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    if-ge v0, v1, :cond_1

    .line 1850
    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v1, v1, v0

    if-ne v1, p1, :cond_0

    .line 1851
    return-void

    .line 1849
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1854
    .end local v0    # "i":I
    :cond_1
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    add-int/lit8 v0, v0, 0x1

    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v1, v1

    if-lt v0, v1, :cond_2

    .line 1855
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v1, v1

    mul-int/lit8 v1, v1, 0x2

    invoke-static {v0, v1}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1857
    :cond_2
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    aput-object p1, v0, v1

    .line 1858
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    .line 1859
    return-void
.end method

.method private addVerticalChain(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V
    .locals 2
    .param p1, "widget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1868
    const/4 v0, 0x0

    .line 1868
    .local v0, "i":I
    :goto_0
    iget v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    if-ge v0, v1, :cond_1

    .line 1869
    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v1, v1, v0

    if-ne v1, p1, :cond_0

    .line 1870
    return-void

    .line 1868
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1873
    .end local v0    # "i":I
    :cond_1
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    add-int/lit8 v0, v0, 0x1

    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v1, v1

    if-lt v0, v1, :cond_2

    .line 1874
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v1, v1

    mul-int/lit8 v1, v1, 0x2

    invoke-static {v0, v1}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1876
    :cond_2
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    aput-object p1, v0, v1

    .line 1877
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    .line 1878
    return-void
.end method

.method private applyHorizontalChain(Landroid/support/constraint/solver/LinearSystem;)V
    .locals 40
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;

    move-object/from16 v6, p0

    .line 357
    move-object/from16 v15, p1

    const/4 v14, 0x0

    move v0, v14

    .line 357
    .local v0, "i":I
    :goto_0
    move v13, v0

    .line 357
    .end local v0    # "i":I
    .local v13, "i":I
    iget v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    if-ge v13, v0, :cond_38

    .line 358
    iget-object v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v12, v0, v13

    .line 359
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v3, v0, v13

    const/4 v4, 0x0

    iget-object v5, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    move-object v0, v6

    move-object v1, v15

    invoke-direct/range {v0 .. v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->countMatchConstraintsChainedWidgets(Landroid/support/constraint/solver/LinearSystem;[Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintWidget;I[Z)I

    move-result v0

    .line 361
    .local v0, "numMatchConstraints":I
    iget-object v1, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v2, 0x2

    aget-object v1, v1, v2

    .line 362
    .local v1, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-nez v1, :cond_1

    .line 364
    nop

    .line 357
    .end local v0    # "numMatchConstraints":I
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .local v20, "i":I
    :cond_0
    :goto_1
    move/from16 v20, v13

    move/from16 v28, v14

    move-object v0, v15

    goto/16 :goto_19

    .line 366
    .end local v20    # "i":I
    .restart local v0    # "numMatchConstraints":I
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_1
    iget-object v3, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    const/4 v4, 0x1

    aget-boolean v3, v3, v4

    if-eqz v3, :cond_2

    .line 367
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawX()I

    move-result v2

    .line 368
    .local v2, "x":I
    :goto_2
    if-eqz v1, :cond_0

    .line 369
    iget-object v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v3, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v3, v2}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    .line 370
    iget-object v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 371
    .local v3, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v5

    add-int/2addr v4, v5

    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v5

    add-int/2addr v4, v5

    add-int/2addr v2, v4

    .line 372
    move-object v1, v3

    .line 373
    .end local v3    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_2

    .line 376
    .end local v2    # "x":I
    :cond_2
    iget v3, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalChainStyle:I

    if-nez v3, :cond_3

    move v3, v4

    goto :goto_3

    :cond_3
    move v3, v14

    .line 377
    .local v3, "isChainSpread":Z
    :goto_3
    iget v5, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalChainStyle:I

    if-ne v5, v2, :cond_4

    move v5, v4

    goto :goto_4

    :cond_4
    move v5, v14

    .line 378
    .local v5, "isChainPacked":Z
    :goto_4
    move-object v11, v12

    .line 379
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v7, v8, :cond_5

    move v7, v4

    goto :goto_5

    :cond_5
    move v7, v14

    :goto_5
    move/from16 v16, v7

    .line 380
    .local v16, "isWrapContent":Z
    iget v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    if-eq v7, v2, :cond_6

    iget v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    const/16 v8, 0x8

    if-ne v7, v8, :cond_7

    :cond_6
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    aget-boolean v7, v7, v14

    if-eqz v7, :cond_7

    iget-boolean v7, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalChainFixedPosition:Z

    if-eqz v7, :cond_7

    if-nez v5, :cond_7

    if-nez v16, :cond_7

    iget v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalChainStyle:I

    if-nez v7, :cond_7

    .line 384
    invoke-static {v6, v15, v0, v11}, Landroid/support/constraint/solver/widgets/Optimizer;->applyDirectResolutionHorizontalChain(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Landroid/support/constraint/solver/LinearSystem;ILandroid/support/constraint/solver/widgets/ConstraintWidget;)V

    goto :goto_1

    .line 386
    :cond_7
    if-eqz v0, :cond_1f

    if-eqz v5, :cond_8

    .line 387
    move/from16 v35, v0

    move/from16 v33, v3

    move-object/from16 v32, v12

    move/from16 v31, v13

    goto/16 :goto_e

    .line 485
    :cond_8
    const/4 v7, 0x0

    .line 486
    .local v7, "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v8, 0x0

    .line 487
    .local v8, "totalWeights":F
    :goto_6
    if-eqz v1, :cond_f

    .line 488
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v9, v2, :cond_d

    .line 489
    iget-object v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 490
    .local v2, "margin":I
    if-eqz v7, :cond_9

    .line 491
    iget-object v9, v7, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    add-int/2addr v2, v9

    .line 493
    :cond_9
    const/4 v9, 0x3

    .line 494
    .local v9, "strength":I
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v4, v14, :cond_a

    .line 495
    const/4 v9, 0x2

    .line 497
    :cond_a
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v4, v14, v2, v9}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 498
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 499
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v4, :cond_b

    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v4, v1, :cond_b

    .line 500
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    add-int/2addr v2, v4

    .line 502
    :cond_b
    const/4 v4, 0x3

    .line 503
    .end local v9    # "strength":I
    .local v4, "strength":I
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v9, v14, :cond_c

    .line 504
    const/4 v4, 0x2

    .line 506
    :cond_c
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v10, v2

    invoke-virtual {v15, v9, v14, v10, v4}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 507
    .end local v2    # "margin":I
    .end local v4    # "strength":I
    nop

    .line 519
    const/4 v10, 0x1

    goto :goto_7

    .line 508
    :cond_d
    iget v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWeight:F

    add-float/2addr v8, v2

    .line 509
    const/4 v2, 0x0

    .line 510
    .restart local v2    # "margin":I
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v4, :cond_e

    .line 511
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 512
    iget-object v4, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v9, 0x3

    aget-object v4, v4, v9

    if-eq v1, v4, :cond_e

    .line 513
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    add-int/2addr v2, v4

    .line 516
    :cond_e
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v10, 0x1

    const/4 v14, 0x0

    invoke-virtual {v15, v4, v9, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 517
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v2

    invoke-virtual {v15, v4, v9, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 519
    .end local v2    # "margin":I
    :goto_7
    move-object v7, v1

    .line 520
    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 486
    move v4, v10

    const/4 v2, 0x2

    const/4 v14, 0x0

    goto/16 :goto_6

    .line 522
    :cond_f
    move v10, v4

    if-ne v0, v10, :cond_14

    .line 523
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v14, 0x0

    aget-object v2, v2, v14

    .line 524
    .local v2, "w":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    .line 525
    .local v4, "leftMargin":I
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v9, :cond_10

    .line 526
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    add-int/2addr v4, v9

    .line 528
    :cond_10
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 529
    .local v9, "rightMargin":I
    iget-object v10, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_11

    .line 530
    iget-object v10, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v10

    add-int/2addr v9, v10

    .line 532
    :cond_11
    iget-object v10, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 533
    .local v10, "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v2, v14, :cond_12

    .line 534
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-object/from16 v29, v1

    const/4 v1, 0x1

    aget-object v14, v14, v1

    .line 534
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v29, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_8

    .line 537
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_12
    move-object/from16 v29, v1

    const/4 v1, 0x1

    .line 537
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_8
    iget v14, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintDefaultWidth:I

    if-ne v14, v1, :cond_13

    .line 538
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v30, v7

    const/4 v7, 0x1

    invoke-virtual {v15, v14, v1, v4, v7}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 539
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v30, "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v9

    invoke-virtual {v15, v1, v10, v14, v7}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 540
    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v7, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v14

    move/from16 v31, v13

    const/4 v13, 0x2

    invoke-virtual {v15, v1, v7, v14, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 540
    .end local v13    # "i":I
    .local v31, "i":I
    goto :goto_9

    .line 542
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .restart local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_13
    move-object/from16 v30, v7

    move/from16 v31, v13

    .line 542
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    iget-object v1, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v13, 0x1

    invoke-virtual {v15, v1, v7, v4, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 543
    iget-object v1, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v7, v9

    invoke-virtual {v15, v1, v10, v7, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 545
    .end local v2    # "w":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "leftMargin":I
    .end local v9    # "rightMargin":I
    .end local v10    # "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    :goto_9
    goto/16 :goto_d

    .line 546
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_14
    move-object/from16 v29, v1

    move-object/from16 v30, v7

    move/from16 v31, v13

    .line 546
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    const/4 v1, 0x0

    .line 546
    .local v1, "j":I
    :goto_a
    add-int/lit8 v2, v0, -0x1

    if-ge v1, v2, :cond_1e

    .line 547
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v2, v2, v1

    .line 548
    .local v2, "current":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    add-int/lit8 v7, v1, 0x1

    aget-object v4, v4, v7

    .line 549
    .local v4, "nextWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 550
    .local v7, "left":Landroid/support/constraint/solver/SolverVariable;
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 551
    .local v9, "right":Landroid/support/constraint/solver/SolverVariable;
    iget-object v10, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 552
    .local v10, "nextLeft":Landroid/support/constraint/solver/SolverVariable;
    iget-object v13, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 553
    .local v13, "nextRight":Landroid/support/constraint/solver/SolverVariable;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v4, v14, :cond_15

    .line 554
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x1

    aget-object v14, v14, v17

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 556
    :cond_15
    iget-object v14, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    .line 557
    .local v14, "margin":I
    move-object/from16 v32, v12

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 557
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v32, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_16

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_16

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v12, v2, :cond_16

    .line 559
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v12

    add-int/2addr v14, v12

    .line 561
    :cond_16
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v33, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v7, v12, v14, v3}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 562
    .end local v3    # "isChainSpread":Z
    .local v33, "isChainSpread":Z
    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 563
    .end local v14    # "margin":I
    .local v3, "margin":I
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_18

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eqz v12, :cond_18

    .line 564
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_17

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    goto :goto_b

    :cond_17
    const/4 v14, 0x0

    :goto_b
    add-int/2addr v3, v14

    .line 566
    :cond_18
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v3

    move/from16 v34, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v9, v12, v14, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 567
    .end local v3    # "margin":I
    .local v34, "margin":I
    add-int/lit8 v3, v1, 0x1

    add-int/lit8 v12, v0, -0x1

    if-ne v3, v12, :cond_1c

    .line 569
    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 570
    .end local v34    # "margin":I
    .restart local v3    # "margin":I
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_19

    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_19

    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v12, v4, :cond_19

    .line 572
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v12

    add-int/2addr v3, v12

    .line 574
    :cond_19
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v14, 0x2

    invoke-virtual {v15, v10, v12, v3, v14}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 575
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 576
    .local v12, "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v4, v14, :cond_1a

    .line 577
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x1

    aget-object v14, v14, v17

    iget-object v12, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 579
    :cond_1a
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 580
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v14, :cond_1b

    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v14, :cond_1b

    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v14, v4, :cond_1b

    .line 582
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    add-int/2addr v3, v14

    .line 584
    :cond_1b
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v35, v0

    neg-int v0, v3

    .line 584
    .end local v0    # "numMatchConstraints":I
    .local v35, "numMatchConstraints":I
    move/from16 v36, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v13, v14, v0, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 587
    .end local v3    # "margin":I
    .end local v12    # "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v36, "margin":I
    move/from16 v34, v36

    goto :goto_c

    .line 587
    .end local v35    # "numMatchConstraints":I
    .end local v36    # "margin":I
    .restart local v0    # "numMatchConstraints":I
    .restart local v34    # "margin":I
    :cond_1c
    move/from16 v35, v0

    const/4 v3, 0x2

    .line 587
    .end local v0    # "numMatchConstraints":I
    .restart local v35    # "numMatchConstraints":I
    :goto_c
    iget v0, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMaxWidth:I

    if-lez v0, :cond_1d

    .line 588
    iget v0, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMaxWidth:I

    invoke-virtual {v15, v9, v7, v0, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 591
    :cond_1d
    invoke-virtual/range {p1 .. p1}, Landroid/support/constraint/solver/LinearSystem;->createRow()Landroid/support/constraint/solver/ArrayRow;

    move-result-object v0

    .line 592
    .local v0, "row":Landroid/support/constraint/solver/ArrayRow;
    iget v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWeight:F

    iget v14, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWeight:F

    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 594
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v22

    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 595
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v24

    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 596
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v26

    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 597
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v28

    .line 592
    move-object/from16 v17, v0

    move/from16 v18, v12

    move/from16 v19, v8

    move/from16 v20, v14

    move-object/from16 v21, v7

    move-object/from16 v23, v9

    move-object/from16 v25, v10

    move-object/from16 v27, v13

    invoke-virtual/range {v17 .. v28}, Landroid/support/constraint/solver/ArrayRow;->createRowEqualDimension(FFFLandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;I)Landroid/support/constraint/solver/ArrayRow;

    .line 598
    invoke-virtual {v15, v0}, Landroid/support/constraint/solver/LinearSystem;->addConstraint(Landroid/support/constraint/solver/ArrayRow;)V

    .line 546
    .end local v0    # "row":Landroid/support/constraint/solver/ArrayRow;
    .end local v2    # "current":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "nextWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "left":Landroid/support/constraint/solver/SolverVariable;
    .end local v9    # "right":Landroid/support/constraint/solver/SolverVariable;
    .end local v10    # "nextLeft":Landroid/support/constraint/solver/SolverVariable;
    .end local v13    # "nextRight":Landroid/support/constraint/solver/SolverVariable;
    .end local v34    # "margin":I
    add-int/lit8 v1, v1, 0x1

    move-object/from16 v12, v32

    move/from16 v3, v33

    move/from16 v0, v35

    goto/16 :goto_a

    .line 357
    .end local v1    # "j":I
    .end local v5    # "isChainPacked":Z
    .end local v8    # "totalWeights":F
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v16    # "isWrapContent":Z
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v33    # "isChainSpread":Z
    .end local v35    # "numMatchConstraints":I
    .restart local v20    # "i":I
    :cond_1e
    :goto_d
    move-object v0, v15

    move/from16 v20, v31

    const/16 v28, 0x0

    goto/16 :goto_19

    .line 387
    .end local v20    # "i":I
    .local v0, "numMatchConstraints":I
    .local v1, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v3, "isChainSpread":Z
    .restart local v5    # "isChainPacked":Z
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v13, "i":I
    .restart local v16    # "isWrapContent":Z
    :cond_1f
    move/from16 v35, v0

    move/from16 v33, v3

    move-object/from16 v32, v12

    move/from16 v31, v13

    .line 387
    .end local v0    # "numMatchConstraints":I
    .end local v3    # "isChainSpread":Z
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v31    # "i":I
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v33    # "isChainSpread":Z
    .restart local v35    # "numMatchConstraints":I
    :goto_e
    const/4 v0, 0x0

    .line 388
    .local v0, "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v2, 0x0

    .line 389
    .local v2, "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object v3, v1

    .line 392
    .local v3, "firstVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v4, 0x0

    .line 393
    .local v4, "isLast":Z
    const/16 v17, 0x0

    move/from16 v18, v4

    move-object v4, v2

    move-object v2, v0

    move-object/from16 v0, v17

    .line 394
    .local v0, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v2, "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v4, "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v18, "isLast":Z
    :goto_f
    if-eqz v1, :cond_33

    .line 395
    iget-object v0, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 396
    if-nez v0, :cond_20

    .line 397
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v8, 0x1

    aget-object v4, v7, v8

    .line 398
    const/4 v7, 0x1

    .line 400
    .end local v18    # "isLast":Z
    .local v7, "isLast":Z
    move/from16 v18, v7

    .line 400
    .end local v7    # "isLast":Z
    .restart local v18    # "isLast":Z
    :cond_20
    if-eqz v5, :cond_25

    .line 401
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 402
    .local v7, "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v8

    .line 403
    .local v8, "margin":I
    if-eqz v2, :cond_21

    .line 404
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 405
    .local v9, "previousMargin":I
    add-int/2addr v8, v9

    .line 407
    .end local v9    # "previousMargin":I
    :cond_21
    const/4 v9, 0x1

    .line 408
    .local v9, "strength":I
    if-eq v3, v1, :cond_22

    .line 409
    const/4 v9, 0x3

    .line 411
    :cond_22
    iget-object v10, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v12, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v10, v12, v8, v9}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 412
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v10, v12, :cond_24

    .line 413
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 414
    .local v10, "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintDefaultWidth:I

    const/4 v13, 0x1

    if-ne v12, v13, :cond_23

    .line 415
    iget v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMinWidth:I

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v13

    invoke-static {v12, v13}, Ljava/lang/Math;->max(II)I

    move-result v12

    .line 416
    .local v12, "dimension":I
    iget-object v13, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v14, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v6, 0x3

    invoke-virtual {v15, v13, v14, v12, v6}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 418
    .end local v12    # "dimension":I
    goto :goto_10

    .line 419
    :cond_23
    const/4 v6, 0x3

    iget-object v12, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v13, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v14, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    invoke-virtual {v15, v12, v13, v14, v6}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 421
    iget-object v12, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v13, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMinWidth:I

    invoke-virtual {v15, v12, v13, v14, v6}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 421
    .end local v7    # "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v8    # "margin":I
    .end local v9    # "strength":I
    .end local v10    # "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    goto :goto_10

    .line 425
    :cond_24
    const/4 v6, 0x3

    .line 468
    :goto_10
    move-object/from16 v12, v32

    goto :goto_11

    .line 426
    :cond_25
    const/4 v6, 0x3

    const/4 v7, 0x5

    if-nez v33, :cond_27

    if-eqz v18, :cond_27

    if-eqz v2, :cond_27

    .line 427
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v8, :cond_26

    .line 428
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawRight()I

    move-result v8

    invoke-virtual {v15, v7, v8}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    goto :goto_10

    .line 430
    :cond_26
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v8}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v8

    .line 431
    .restart local v8    # "margin":I
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v10, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v12, v8

    invoke-virtual {v15, v9, v10, v12, v7}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 432
    .end local v8    # "margin":I
    goto :goto_10

    .line 433
    :cond_27
    if-nez v33, :cond_29

    if-nez v18, :cond_29

    if-nez v2, :cond_29

    .line 434
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v8, :cond_28

    .line 435
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawX()I

    move-result v8

    invoke-virtual {v15, v7, v8}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    goto :goto_10

    .line 437
    :cond_28
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v8}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v8

    .line 438
    .restart local v8    # "margin":I
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v12, v32

    iget-object v10, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 438
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v9, v10, v8, v7}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 439
    .end local v8    # "margin":I
    nop

    .line 468
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_11
    move-object/from16 v39, v0

    move/from16 v25, v6

    move-object/from16 v26, v11

    move-object/from16 v38, v12

    move-object v0, v15

    move/from16 v20, v31

    const/16 v28, 0x0

    .line 468
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto/16 :goto_16

    .line 442
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_29
    move-object/from16 v12, v32

    .line 442
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 443
    .local v14, "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 444
    .local v13, "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v10

    .line 445
    .local v10, "leftMargin":I
    invoke-virtual {v13}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 446
    .local v9, "rightMargin":I
    iget-object v7, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v6, 0x1

    invoke-virtual {v15, v7, v8, v10, v6}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 447
    iget-object v7, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v37, v10

    neg-int v10, v9

    .line 447
    .end local v10    # "leftMargin":I
    .local v37, "leftMargin":I
    invoke-virtual {v15, v7, v8, v10, v6}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 448
    iget-object v6, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v6, :cond_2a

    iget-object v6, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_12

    :cond_2a
    move-object/from16 v6, v17

    .line 449
    .local v6, "leftTarget":Landroid/support/constraint/solver/SolverVariable;
    :goto_12
    if-nez v2, :cond_2c

    .line 451
    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_2b

    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_13

    :cond_2b
    move-object/from16 v7, v17

    :goto_13
    move-object v6, v7

    .line 453
    :cond_2c
    if-nez v0, :cond_2e

    .line 454
    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_2d

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    goto :goto_14

    :cond_2d
    move-object/from16 v7, v17

    :goto_14
    move-object v0, v7

    .line 456
    :cond_2e
    if-eqz v0, :cond_31

    .line 457
    iget-object v7, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 458
    .local v7, "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    if-eqz v18, :cond_30

    .line 459
    iget-object v8, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v8, :cond_2f

    iget-object v8, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_15

    :cond_2f
    move-object/from16 v8, v17

    :goto_15
    move-object v7, v8

    .line 461
    .end local v7    # "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    .local v19, "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    :cond_30
    move-object/from16 v19, v7

    if-eqz v6, :cond_31

    if-eqz v19, :cond_31

    .line 462
    iget-object v8, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/high16 v20, 0x3f000000    # 0.5f

    iget-object v10, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/16 v21, 0x4

    move-object v7, v15

    move/from16 v22, v9

    move-object v9, v6

    .line 462
    .end local v9    # "rightMargin":I
    .local v22, "rightMargin":I
    move-object/from16 v24, v10

    move/from16 v23, v37

    const/16 v25, 0x3

    move/from16 v10, v23

    .line 462
    .end local v37    # "leftMargin":I
    .local v23, "leftMargin":I
    move-object/from16 v26, v11

    move/from16 v11, v20

    .line 462
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v26, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object/from16 v38, v12

    move-object/from16 v12, v19

    .line 462
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v38, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object/from16 v27, v13

    move/from16 v20, v31

    move-object/from16 v13, v24

    .line 462
    .end local v13    # "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v31    # "i":I
    .restart local v20    # "i":I
    .local v27, "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    move-object/from16 v24, v14

    const/16 v28, 0x0

    move/from16 v14, v22

    .line 462
    .end local v14    # "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v24, "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    move-object/from16 v39, v0

    move-object v0, v15

    move/from16 v15, v21

    .line 462
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v39, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual/range {v7 .. v15}, Landroid/support/constraint/solver/LinearSystem;->addCentering(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;IFLandroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 462
    .end local v6    # "leftTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v19    # "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v22    # "rightMargin":I
    .end local v23    # "leftMargin":I
    .end local v24    # "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v27    # "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    goto :goto_16

    .line 468
    .end local v20    # "i":I
    .end local v26    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v39    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    :cond_31
    move-object/from16 v39, v0

    move-object/from16 v26, v11

    move-object/from16 v38, v12

    move-object v0, v15

    move/from16 v20, v31

    const/16 v25, 0x3

    const/16 v28, 0x0

    .line 468
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .restart local v20    # "i":I
    .restart local v26    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v39    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_16
    move-object v2, v1

    .line 469
    if-eqz v18, :cond_32

    move-object/from16 v6, v17

    goto :goto_17

    :cond_32
    move-object/from16 v6, v39

    :goto_17
    move-object v1, v6

    .line 393
    move-object v15, v0

    move/from16 v31, v20

    move-object/from16 v11, v26

    move-object/from16 v32, v38

    move-object/from16 v0, v39

    move-object/from16 v6, p0

    goto/16 :goto_f

    .line 471
    .end local v20    # "i":I
    .end local v26    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v39    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_33
    move-object v6, v0

    move-object/from16 v26, v11

    move-object v0, v15

    move/from16 v20, v31

    move-object/from16 v38, v32

    const/16 v28, 0x0

    .line 471
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v6, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v20    # "i":I
    .restart local v26    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v5, :cond_37

    .line 472
    iget-object v15, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 473
    .local v15, "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v14, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 474
    .local v14, "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v15}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v19

    .line 475
    .local v19, "leftMargin":I
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v13

    .line 476
    .local v13, "rightMargin":I
    move-object/from16 v12, v38

    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 476
    .end local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_34

    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_18

    :cond_34
    move-object/from16 v7, v17

    :goto_18
    move-object/from16 v21, v7

    .line 477
    .local v21, "leftTarget":Landroid/support/constraint/solver/SolverVariable;
    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_35

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v17, v7

    nop

    :cond_35
    move-object/from16 v11, v17

    .line 478
    .local v11, "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    if-eqz v21, :cond_36

    if-eqz v11, :cond_36

    .line 479
    iget-object v7, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v8, v13

    const/4 v9, 0x1

    invoke-virtual {v0, v7, v11, v8, v9}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 480
    iget-object v8, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v10, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalBiasPercent:F

    iget-object v9, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/16 v17, 0x4

    move-object v7, v0

    move-object/from16 v22, v9

    move-object/from16 v9, v21

    move/from16 v23, v10

    move/from16 v10, v19

    move-object/from16 v24, v11

    move/from16 v11, v23

    .line 480
    .end local v11    # "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    .local v24, "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    move-object/from16 v23, v12

    move-object/from16 v12, v24

    .line 480
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v23, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move/from16 v25, v13

    move-object/from16 v13, v22

    .line 480
    .end local v13    # "rightMargin":I
    .local v25, "rightMargin":I
    move-object/from16 v22, v14

    move/from16 v14, v25

    .line 480
    .end local v14    # "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v22, "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    move-object/from16 v27, v15

    move/from16 v15, v17

    .line 480
    .end local v15    # "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v27, "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual/range {v7 .. v15}, Landroid/support/constraint/solver/LinearSystem;->addCentering(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;IFLandroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 480
    .end local v2    # "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v3    # "firstVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v6    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v18    # "isLast":Z
    .end local v19    # "leftMargin":I
    .end local v21    # "leftTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v22    # "right":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v24    # "rightTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v25    # "rightMargin":I
    .end local v27    # "left":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    goto :goto_19

    .line 484
    .end local v23    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_36
    move-object/from16 v23, v12

    .line 484
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v23    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_19

    .line 484
    .end local v23    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_37
    move-object/from16 v23, v38

    .line 357
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v5    # "isChainPacked":Z
    .end local v16    # "isWrapContent":Z
    .end local v26    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v33    # "isChainSpread":Z
    .end local v35    # "numMatchConstraints":I
    .end local v38    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_19
    add-int/lit8 v1, v20, 0x1

    .line 357
    .end local v20    # "i":I
    .local v1, "i":I
    move-object v15, v0

    move v0, v1

    move/from16 v14, v28

    move-object/from16 v6, p0

    goto/16 :goto_0

    .line 604
    .end local v1    # "i":I
    :cond_38
    move-object v0, v15

    return-void
.end method

.method private applyVerticalChain(Landroid/support/constraint/solver/LinearSystem;)V
    .locals 42
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;

    move-object/from16 v6, p0

    .line 613
    move-object/from16 v15, p1

    const/4 v14, 0x0

    move v0, v14

    .line 613
    .local v0, "i":I
    :goto_0
    move v13, v0

    .line 613
    .end local v0    # "i":I
    .local v13, "i":I
    iget v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    if-ge v13, v0, :cond_3b

    .line 614
    iget-object v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v12, v0, v13

    .line 615
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v0, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsArray:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v3, v0, v13

    const/4 v4, 0x1

    iget-object v5, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    move-object v0, v6

    move-object v1, v15

    invoke-direct/range {v0 .. v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->countMatchConstraintsChainedWidgets(Landroid/support/constraint/solver/LinearSystem;[Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintWidget;I[Z)I

    move-result v0

    .line 617
    .local v0, "numMatchConstraints":I
    iget-object v1, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v2, 0x2

    aget-object v1, v1, v2

    .line 618
    .local v1, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-nez v1, :cond_1

    .line 620
    nop

    .line 613
    .end local v0    # "numMatchConstraints":I
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .local v26, "i":I
    :cond_0
    :goto_1
    move/from16 v26, v13

    move/from16 v28, v14

    move-object v0, v15

    goto/16 :goto_1b

    .line 622
    .end local v26    # "i":I
    .restart local v0    # "numMatchConstraints":I
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_1
    iget-object v3, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    const/4 v4, 0x1

    aget-boolean v3, v3, v4

    if-eqz v3, :cond_2

    .line 623
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawY()I

    move-result v2

    .line 624
    .local v2, "y":I
    :goto_2
    if-eqz v1, :cond_0

    .line 625
    iget-object v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v3, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v3, v2}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    .line 626
    iget-object v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 627
    .local v3, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v5

    add-int/2addr v4, v5

    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v5

    add-int/2addr v4, v5

    add-int/2addr v2, v4

    .line 628
    move-object v1, v3

    .line 629
    .end local v3    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_2

    .line 632
    .end local v2    # "y":I
    :cond_2
    iget v3, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalChainStyle:I

    if-nez v3, :cond_3

    move v3, v4

    goto :goto_3

    :cond_3
    move v3, v14

    .line 633
    .local v3, "isChainSpread":Z
    :goto_3
    iget v5, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalChainStyle:I

    if-ne v5, v2, :cond_4

    move v5, v4

    goto :goto_4

    :cond_4
    move v5, v14

    .line 634
    .local v5, "isChainPacked":Z
    :goto_4
    move-object v11, v12

    .line 635
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v7, v8, :cond_5

    move v7, v4

    goto :goto_5

    :cond_5
    move v7, v14

    :goto_5
    move/from16 v16, v7

    .line 636
    .local v16, "isWrapContent":Z
    iget v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    if-eq v7, v2, :cond_6

    iget v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    const/16 v8, 0x8

    if-ne v7, v8, :cond_7

    :cond_6
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    aget-boolean v7, v7, v14

    if-eqz v7, :cond_7

    iget-boolean v7, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalChainFixedPosition:Z

    if-eqz v7, :cond_7

    if-nez v5, :cond_7

    if-nez v16, :cond_7

    iget v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalChainStyle:I

    if-nez v7, :cond_7

    .line 640
    invoke-static {v6, v15, v0, v11}, Landroid/support/constraint/solver/widgets/Optimizer;->applyDirectResolutionVerticalChain(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Landroid/support/constraint/solver/LinearSystem;ILandroid/support/constraint/solver/widgets/ConstraintWidget;)V

    goto :goto_1

    .line 642
    :cond_7
    if-eqz v0, :cond_1f

    if-eqz v5, :cond_8

    .line 643
    move/from16 v35, v0

    move/from16 v33, v3

    move-object/from16 v32, v12

    move/from16 v31, v13

    goto/16 :goto_e

    .line 753
    :cond_8
    const/4 v7, 0x0

    .line 754
    .local v7, "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v8, 0x0

    .line 755
    .local v8, "totalWeights":F
    :goto_6
    if-eqz v1, :cond_f

    .line 756
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v9, v2, :cond_d

    .line 757
    iget-object v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 758
    .local v2, "margin":I
    if-eqz v7, :cond_9

    .line 759
    iget-object v9, v7, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    add-int/2addr v2, v9

    .line 761
    :cond_9
    const/4 v9, 0x3

    .line 762
    .local v9, "strength":I
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v4, v14, :cond_a

    .line 763
    const/4 v9, 0x2

    .line 765
    :cond_a
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v4, v14, v2, v9}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 766
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 767
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v4, :cond_b

    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v4, v1, :cond_b

    .line 768
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    add-int/2addr v2, v4

    .line 770
    :cond_b
    const/4 v4, 0x3

    .line 771
    .end local v9    # "strength":I
    .local v4, "strength":I
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v9, v14, :cond_c

    .line 772
    const/4 v4, 0x2

    .line 774
    :cond_c
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v10, v2

    invoke-virtual {v15, v9, v14, v10, v4}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 775
    .end local v2    # "margin":I
    .end local v4    # "strength":I
    nop

    .line 787
    const/4 v10, 0x1

    goto :goto_7

    .line 776
    :cond_d
    iget v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWeight:F

    add-float/2addr v8, v2

    .line 777
    const/4 v2, 0x0

    .line 778
    .restart local v2    # "margin":I
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v4, :cond_e

    .line 779
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v2

    .line 780
    iget-object v4, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v9, 0x3

    aget-object v4, v4, v9

    if-eq v1, v4, :cond_e

    .line 781
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    add-int/2addr v2, v4

    .line 784
    :cond_e
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v10, 0x1

    const/4 v14, 0x0

    invoke-virtual {v15, v4, v9, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 785
    iget-object v4, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v2

    invoke-virtual {v15, v4, v9, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 787
    .end local v2    # "margin":I
    :goto_7
    move-object v7, v1

    .line 788
    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 754
    move v4, v10

    const/4 v2, 0x2

    const/4 v14, 0x0

    goto/16 :goto_6

    .line 790
    :cond_f
    move v10, v4

    if-ne v0, v10, :cond_14

    .line 791
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v14, 0x0

    aget-object v2, v2, v14

    .line 792
    .local v2, "w":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v4

    .line 793
    .local v4, "topMargin":I
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v9, :cond_10

    .line 794
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    add-int/2addr v4, v9

    .line 796
    :cond_10
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 797
    .local v9, "bottomMargin":I
    iget-object v10, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_11

    .line 798
    iget-object v10, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v10}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v10

    add-int/2addr v9, v10

    .line 800
    :cond_11
    iget-object v10, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 801
    .local v10, "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v2, v14, :cond_12

    .line 802
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-object/from16 v29, v1

    const/4 v1, 0x1

    aget-object v14, v14, v1

    .line 802
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v29, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_8

    .line 805
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_12
    move-object/from16 v29, v1

    const/4 v1, 0x1

    .line 805
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_8
    iget v14, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintDefaultHeight:I

    if-ne v14, v1, :cond_13

    .line 806
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v30, v7

    const/4 v7, 0x1

    invoke-virtual {v15, v14, v1, v4, v7}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 807
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v30, "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v9

    invoke-virtual {v15, v1, v10, v14, v7}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 808
    iget-object v1, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v7, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v14

    move/from16 v31, v13

    const/4 v13, 0x2

    invoke-virtual {v15, v1, v7, v14, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 808
    .end local v13    # "i":I
    .local v31, "i":I
    goto :goto_9

    .line 810
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .restart local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_13
    move-object/from16 v30, v7

    move/from16 v31, v13

    .line 810
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    iget-object v1, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v13, 0x1

    invoke-virtual {v15, v1, v7, v4, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 811
    iget-object v1, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v7, v9

    invoke-virtual {v15, v1, v10, v7, v13}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 813
    .end local v2    # "w":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "topMargin":I
    .end local v9    # "bottomMargin":I
    .end local v10    # "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    :goto_9
    goto/16 :goto_d

    .line 814
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .restart local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v13    # "i":I
    :cond_14
    move-object/from16 v29, v1

    move-object/from16 v30, v7

    move/from16 v31, v13

    .line 814
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    const/4 v1, 0x0

    .line 814
    .local v1, "j":I
    :goto_a
    add-int/lit8 v2, v0, -0x1

    if-ge v1, v2, :cond_1e

    .line 815
    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    aget-object v2, v2, v1

    .line 816
    .local v2, "current":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    add-int/lit8 v7, v1, 0x1

    aget-object v4, v4, v7

    .line 817
    .local v4, "nextWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 818
    .local v7, "top":Landroid/support/constraint/solver/SolverVariable;
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 819
    .local v9, "bottom":Landroid/support/constraint/solver/SolverVariable;
    iget-object v10, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v10, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 820
    .local v10, "nextTop":Landroid/support/constraint/solver/SolverVariable;
    iget-object v13, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 821
    .local v13, "nextBottom":Landroid/support/constraint/solver/SolverVariable;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v4, v14, :cond_15

    .line 822
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x1

    aget-object v14, v14, v17

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 824
    :cond_15
    iget-object v14, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    .line 825
    .local v14, "margin":I
    move-object/from16 v32, v12

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 825
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v32, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_16

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_16

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v12, v2, :cond_16

    .line 827
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v12

    add-int/2addr v14, v12

    .line 829
    :cond_16
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v33, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v7, v12, v14, v3}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 830
    .end local v3    # "isChainSpread":Z
    .local v33, "isChainSpread":Z
    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 831
    .end local v14    # "margin":I
    .local v3, "margin":I
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_18

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eqz v12, :cond_18

    .line 832
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_17

    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    goto :goto_b

    :cond_17
    const/4 v14, 0x0

    :goto_b
    add-int/2addr v3, v14

    .line 834
    :cond_18
    iget-object v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v14, v3

    move/from16 v34, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v9, v12, v14, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 835
    .end local v3    # "margin":I
    .local v34, "margin":I
    add-int/lit8 v3, v1, 0x1

    add-int/lit8 v12, v0, -0x1

    if-ne v3, v12, :cond_1c

    .line 837
    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 838
    .end local v34    # "margin":I
    .restart local v3    # "margin":I
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_19

    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v12, :cond_19

    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v12, v4, :cond_19

    .line 840
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v12

    add-int/2addr v3, v12

    .line 842
    :cond_19
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v14, 0x2

    invoke-virtual {v15, v10, v12, v3, v14}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 843
    iget-object v12, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 844
    .local v12, "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x3

    aget-object v14, v14, v17

    if-ne v4, v14, :cond_1a

    .line 845
    iget-object v14, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/16 v17, 0x1

    aget-object v14, v14, v17

    iget-object v12, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 847
    :cond_1a
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v3

    .line 848
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v14, :cond_1b

    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v14, :cond_1b

    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v14, v4, :cond_1b

    .line 850
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v14

    add-int/2addr v3, v14

    .line 852
    :cond_1b
    iget-object v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v14, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v35, v0

    neg-int v0, v3

    .line 852
    .end local v0    # "numMatchConstraints":I
    .local v35, "numMatchConstraints":I
    move/from16 v36, v3

    const/4 v3, 0x2

    invoke-virtual {v15, v13, v14, v0, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 855
    .end local v3    # "margin":I
    .end local v12    # "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v36, "margin":I
    move/from16 v34, v36

    goto :goto_c

    .line 855
    .end local v35    # "numMatchConstraints":I
    .end local v36    # "margin":I
    .restart local v0    # "numMatchConstraints":I
    .restart local v34    # "margin":I
    :cond_1c
    move/from16 v35, v0

    const/4 v3, 0x2

    .line 855
    .end local v0    # "numMatchConstraints":I
    .restart local v35    # "numMatchConstraints":I
    :goto_c
    iget v0, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMaxHeight:I

    if-lez v0, :cond_1d

    .line 856
    iget v0, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMaxHeight:I

    invoke-virtual {v15, v9, v7, v0, v3}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 859
    :cond_1d
    invoke-virtual/range {p1 .. p1}, Landroid/support/constraint/solver/LinearSystem;->createRow()Landroid/support/constraint/solver/ArrayRow;

    move-result-object v0

    .line 860
    .local v0, "row":Landroid/support/constraint/solver/ArrayRow;
    iget v12, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWeight:F

    iget v14, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWeight:F

    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 862
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v22

    iget-object v3, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 863
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v24

    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 864
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v26

    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 865
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v28

    .line 860
    move-object/from16 v17, v0

    move/from16 v18, v12

    move/from16 v19, v8

    move/from16 v20, v14

    move-object/from16 v21, v7

    move-object/from16 v23, v9

    move-object/from16 v25, v10

    move-object/from16 v27, v13

    invoke-virtual/range {v17 .. v28}, Landroid/support/constraint/solver/ArrayRow;->createRowEqualDimension(FFFLandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;ILandroid/support/constraint/solver/SolverVariable;I)Landroid/support/constraint/solver/ArrayRow;

    .line 866
    invoke-virtual {v15, v0}, Landroid/support/constraint/solver/LinearSystem;->addConstraint(Landroid/support/constraint/solver/ArrayRow;)V

    .line 814
    .end local v0    # "row":Landroid/support/constraint/solver/ArrayRow;
    .end local v2    # "current":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "nextWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "top":Landroid/support/constraint/solver/SolverVariable;
    .end local v9    # "bottom":Landroid/support/constraint/solver/SolverVariable;
    .end local v10    # "nextTop":Landroid/support/constraint/solver/SolverVariable;
    .end local v13    # "nextBottom":Landroid/support/constraint/solver/SolverVariable;
    .end local v34    # "margin":I
    add-int/lit8 v1, v1, 0x1

    move-object/from16 v12, v32

    move/from16 v3, v33

    move/from16 v0, v35

    goto/16 :goto_a

    .line 613
    .end local v1    # "j":I
    .end local v5    # "isChainPacked":Z
    .end local v8    # "totalWeights":F
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v16    # "isWrapContent":Z
    .end local v29    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v30    # "previous":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v33    # "isChainSpread":Z
    .end local v35    # "numMatchConstraints":I
    .restart local v26    # "i":I
    :cond_1e
    :goto_d
    move-object v0, v15

    move/from16 v26, v31

    const/16 v28, 0x0

    goto/16 :goto_1b

    .line 643
    .end local v26    # "i":I
    .local v0, "numMatchConstraints":I
    .local v1, "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v3, "isChainSpread":Z
    .restart local v5    # "isChainPacked":Z
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v13, "i":I
    .restart local v16    # "isWrapContent":Z
    :cond_1f
    move/from16 v35, v0

    move/from16 v33, v3

    move-object/from16 v32, v12

    move/from16 v31, v13

    .line 643
    .end local v0    # "numMatchConstraints":I
    .end local v3    # "isChainSpread":Z
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "i":I
    .restart local v31    # "i":I
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v33    # "isChainSpread":Z
    .restart local v35    # "numMatchConstraints":I
    :goto_e
    const/4 v0, 0x0

    .line 644
    .local v0, "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v2, 0x0

    .line 645
    .local v2, "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object v3, v1

    .line 648
    .local v3, "firstVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v4, 0x0

    .line 649
    .local v4, "isLast":Z
    const/16 v17, 0x0

    move/from16 v18, v4

    move-object v4, v2

    move-object v2, v0

    move-object/from16 v0, v17

    .line 650
    .local v0, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v2, "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v4, "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v18, "isLast":Z
    :goto_f
    if-eqz v1, :cond_36

    .line 651
    iget-object v0, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 652
    if-nez v0, :cond_20

    .line 653
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChainEnds:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v8, 0x1

    aget-object v4, v7, v8

    .line 654
    const/4 v7, 0x1

    .line 656
    .end local v18    # "isLast":Z
    .local v7, "isLast":Z
    move/from16 v18, v7

    .line 656
    .end local v7    # "isLast":Z
    .restart local v18    # "isLast":Z
    :cond_20
    if-eqz v5, :cond_28

    .line 657
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 658
    .local v7, "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v8

    .line 659
    .local v8, "margin":I
    if-eqz v2, :cond_21

    .line 660
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v9}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 661
    .local v9, "previousMargin":I
    add-int/2addr v8, v9

    .line 663
    .end local v9    # "previousMargin":I
    :cond_21
    const/4 v9, 0x1

    .line 664
    .local v9, "strength":I
    if-eq v3, v1, :cond_22

    .line 665
    const/4 v9, 0x3

    .line 667
    :cond_22
    const/4 v10, 0x0

    .line 668
    .local v10, "source":Landroid/support/constraint/solver/SolverVariable;
    const/4 v12, 0x0

    .line 669
    .local v12, "target":Landroid/support/constraint/solver/SolverVariable;
    iget-object v13, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v13, :cond_23

    .line 670
    iget-object v10, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 671
    iget-object v13, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_10

    .line 672
    :cond_23
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v13, :cond_24

    .line 673
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v10, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 674
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v13, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v12, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 675
    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v13

    sub-int/2addr v8, v13

    .line 677
    :cond_24
    :goto_10
    if-eqz v10, :cond_25

    if-eqz v12, :cond_25

    .line 678
    invoke-virtual {v15, v10, v12, v8, v9}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 680
    :cond_25
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v13, v14, :cond_27

    .line 681
    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 682
    .local v13, "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintDefaultHeight:I

    const/4 v6, 0x1

    if-ne v14, v6, :cond_26

    .line 683
    iget v6, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMinHeight:I

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v14

    invoke-static {v6, v14}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 684
    .local v6, "dimension":I
    iget-object v14, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move/from16 v37, v8

    iget-object v8, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 684
    .end local v8    # "margin":I
    .local v37, "margin":I
    move-object/from16 v38, v10

    const/4 v10, 0x3

    invoke-virtual {v15, v14, v8, v6, v10}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 686
    .end local v6    # "dimension":I
    .end local v10    # "source":Landroid/support/constraint/solver/SolverVariable;
    .local v38, "source":Landroid/support/constraint/solver/SolverVariable;
    goto :goto_11

    .line 687
    .end local v37    # "margin":I
    .end local v38    # "source":Landroid/support/constraint/solver/SolverVariable;
    .restart local v8    # "margin":I
    .restart local v10    # "source":Landroid/support/constraint/solver/SolverVariable;
    :cond_26
    move/from16 v37, v8

    move-object/from16 v38, v10

    const/4 v10, 0x3

    .line 687
    .end local v8    # "margin":I
    .end local v10    # "source":Landroid/support/constraint/solver/SolverVariable;
    .restart local v37    # "margin":I
    .restart local v38    # "source":Landroid/support/constraint/solver/SolverVariable;
    iget-object v6, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v14, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    invoke-virtual {v15, v6, v8, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 689
    iget-object v6, v13, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mMatchConstraintMinHeight:I

    invoke-virtual {v15, v6, v8, v14, v10}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 689
    .end local v7    # "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v9    # "strength":I
    .end local v12    # "target":Landroid/support/constraint/solver/SolverVariable;
    .end local v13    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v37    # "margin":I
    .end local v38    # "source":Landroid/support/constraint/solver/SolverVariable;
    goto :goto_11

    .line 693
    :cond_27
    const/4 v10, 0x3

    :goto_11
    goto :goto_12

    .line 694
    :cond_28
    const/4 v10, 0x3

    const/4 v6, 0x5

    if-nez v33, :cond_2a

    if-eqz v18, :cond_2a

    if-eqz v2, :cond_2a

    .line 695
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_29

    .line 696
    iget-object v6, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawBottom()I

    move-result v7

    invoke-virtual {v15, v6, v7}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    .line 736
    :goto_12
    move-object/from16 v12, v32

    goto :goto_13

    .line 698
    :cond_29
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    .line 699
    .local v7, "margin":I
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v9, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v12, v7

    invoke-virtual {v15, v8, v9, v12, v6}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 700
    .end local v7    # "margin":I
    goto :goto_12

    .line 701
    :cond_2a
    if-nez v33, :cond_2c

    if-nez v18, :cond_2c

    if-nez v2, :cond_2c

    .line 702
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_2b

    .line 703
    iget-object v6, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getDrawY()I

    move-result v7

    invoke-virtual {v15, v6, v7}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;I)V

    goto :goto_12

    .line 705
    :cond_2b
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    .line 706
    .restart local v7    # "margin":I
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v12, v32

    iget-object v9, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 706
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v12, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v15, v8, v9, v7, v6}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 707
    .end local v7    # "margin":I
    nop

    .line 736
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_13
    move-object/from16 v41, v0

    move/from16 v24, v10

    move-object/from16 v25, v11

    move-object/from16 v40, v12

    move-object v0, v15

    move/from16 v26, v31

    const/16 v28, 0x0

    .line 736
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto/16 :goto_18

    .line 710
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_2c
    move-object/from16 v12, v32

    .line 710
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v6, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 711
    .local v6, "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 712
    .local v14, "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v6}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v13

    .line 713
    .local v13, "topMargin":I
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v9

    .line 714
    .local v9, "bottomMargin":I
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/4 v10, 0x1

    invoke-virtual {v15, v7, v8, v13, v10}, Landroid/support/constraint/solver/LinearSystem;->addGreaterThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 715
    iget-object v7, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v8, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v39, v11

    neg-int v11, v9

    .line 715
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v39, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual {v15, v7, v8, v11, v10}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 716
    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_2d

    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_14

    :cond_2d
    move-object/from16 v7, v17

    .line 717
    .local v7, "topTarget":Landroid/support/constraint/solver/SolverVariable;
    :goto_14
    if-nez v2, :cond_2f

    .line 719
    iget-object v8, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v8, :cond_2e

    iget-object v8, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_15

    :cond_2e
    move-object/from16 v8, v17

    :goto_15
    move-object v7, v8

    .line 721
    .end local v7    # "topTarget":Landroid/support/constraint/solver/SolverVariable;
    .local v19, "topTarget":Landroid/support/constraint/solver/SolverVariable;
    :cond_2f
    move-object/from16 v19, v7

    if-nez v0, :cond_31

    .line 722
    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_30

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    goto :goto_16

    :cond_30
    move-object/from16 v7, v17

    :goto_16
    move-object v0, v7

    .line 724
    :cond_31
    if-eqz v0, :cond_34

    .line 725
    iget-object v7, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    .line 726
    .local v7, "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    if-eqz v18, :cond_33

    .line 727
    iget-object v8, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v8, :cond_32

    iget-object v8, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_17

    :cond_32
    move-object/from16 v8, v17

    :goto_17
    move-object v7, v8

    .line 729
    .end local v7    # "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    .local v20, "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    :cond_33
    move-object/from16 v20, v7

    if-eqz v19, :cond_34

    if-eqz v20, :cond_34

    .line 730
    iget-object v8, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/high16 v11, 0x3f000000    # 0.5f

    iget-object v10, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/16 v21, 0x4

    move-object v7, v15

    move/from16 v22, v9

    move-object/from16 v9, v19

    .line 730
    .end local v9    # "bottomMargin":I
    .local v22, "bottomMargin":I
    move-object/from16 v23, v10

    const/16 v24, 0x3

    move v10, v13

    move-object/from16 v25, v39

    .line 730
    .end local v39    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v25, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object/from16 v40, v12

    move-object/from16 v12, v20

    .line 730
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v40, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move/from16 v27, v13

    move/from16 v26, v31

    move-object/from16 v13, v23

    .line 730
    .end local v13    # "topMargin":I
    .end local v31    # "i":I
    .restart local v26    # "i":I
    .local v27, "topMargin":I
    move-object/from16 v23, v14

    const/16 v28, 0x0

    move/from16 v14, v22

    .line 730
    .end local v14    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v23, "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    move-object/from16 v41, v0

    move-object v0, v15

    move/from16 v15, v21

    .line 730
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v41, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual/range {v7 .. v15}, Landroid/support/constraint/solver/LinearSystem;->addCentering(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;IFLandroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 730
    .end local v6    # "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v19    # "topTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v20    # "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v22    # "bottomMargin":I
    .end local v23    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v27    # "topMargin":I
    goto :goto_18

    .line 736
    .end local v25    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v26    # "i":I
    .end local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v41    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    .restart local v39    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_34
    move-object/from16 v41, v0

    move-object/from16 v40, v12

    move-object v0, v15

    move/from16 v26, v31

    move-object/from16 v25, v39

    const/16 v24, 0x3

    const/16 v28, 0x0

    .line 736
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .end local v39    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v25    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v26    # "i":I
    .restart local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v41    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_18
    move-object v2, v1

    .line 737
    if-eqz v18, :cond_35

    move-object/from16 v6, v17

    goto :goto_19

    :cond_35
    move-object/from16 v6, v41

    :goto_19
    move-object v1, v6

    .line 649
    move-object v15, v0

    move-object/from16 v11, v25

    move/from16 v31, v26

    move-object/from16 v32, v40

    move-object/from16 v0, v41

    move-object/from16 v6, p0

    goto/16 :goto_f

    .line 739
    .end local v25    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v26    # "i":I
    .end local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v41    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v31    # "i":I
    .restart local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_36
    move-object v6, v0

    move-object/from16 v25, v11

    move-object v0, v15

    move/from16 v26, v31

    move-object/from16 v40, v32

    const/16 v28, 0x0

    .line 739
    .end local v0    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v31    # "i":I
    .end local v32    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v6, "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v25    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v26    # "i":I
    .restart local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-eqz v5, :cond_3a

    .line 740
    iget-object v15, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 741
    .local v15, "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v14, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 742
    .restart local v14    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual {v15}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v19

    .line 743
    .local v19, "topMargin":I
    invoke-virtual {v14}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v13

    .line 744
    .local v13, "bottomMargin":I
    move-object/from16 v12, v40

    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 744
    .end local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_37

    iget-object v7, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    goto :goto_1a

    :cond_37
    move-object/from16 v7, v17

    :goto_1a
    move-object/from16 v20, v7

    .line 745
    .local v20, "topTarget":Landroid/support/constraint/solver/SolverVariable;
    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_38

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    move-object/from16 v17, v7

    nop

    :cond_38
    move-object/from16 v11, v17

    .line 746
    .local v11, "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    if-eqz v20, :cond_39

    if-eqz v11, :cond_39

    .line 747
    iget-object v7, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    neg-int v8, v13

    const/4 v9, 0x1

    invoke-virtual {v0, v7, v11, v8, v9}, Landroid/support/constraint/solver/LinearSystem;->addLowerThan(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 748
    iget-object v8, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget v10, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalBiasPercent:F

    iget-object v9, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    const/16 v17, 0x4

    move-object v7, v0

    move-object/from16 v21, v9

    move-object/from16 v9, v20

    move/from16 v22, v10

    move/from16 v10, v19

    move-object/from16 v23, v11

    move/from16 v11, v22

    .line 748
    .end local v11    # "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    .local v23, "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    move-object/from16 v22, v12

    move-object/from16 v12, v23

    .line 748
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v22, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move/from16 v24, v13

    move-object/from16 v13, v21

    .line 748
    .end local v13    # "bottomMargin":I
    .local v24, "bottomMargin":I
    move-object/from16 v21, v14

    move/from16 v14, v24

    .line 748
    .end local v14    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v21, "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    move-object/from16 v27, v15

    move/from16 v15, v17

    .line 748
    .end local v15    # "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v27, "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    invoke-virtual/range {v7 .. v15}, Landroid/support/constraint/solver/LinearSystem;->addCentering(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;IFLandroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)V

    .line 748
    .end local v2    # "previousVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v3    # "firstVisibleWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "lastWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v6    # "next":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v18    # "isLast":Z
    .end local v19    # "topMargin":I
    .end local v20    # "topTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v21    # "bottom":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v23    # "bottomTarget":Landroid/support/constraint/solver/SolverVariable;
    .end local v24    # "bottomMargin":I
    .end local v27    # "top":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    goto :goto_1b

    .line 752
    .end local v22    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_39
    move-object/from16 v22, v12

    .line 752
    .end local v12    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v22    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    goto :goto_1b

    .line 752
    .end local v22    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_3a
    move-object/from16 v22, v40

    .line 613
    .end local v1    # "currentWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v5    # "isChainPacked":Z
    .end local v16    # "isWrapContent":Z
    .end local v25    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v33    # "isChainSpread":Z
    .end local v35    # "numMatchConstraints":I
    .end local v40    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_1b
    add-int/lit8 v1, v26, 0x1

    .line 613
    .end local v26    # "i":I
    .local v1, "i":I
    move-object v15, v0

    move v0, v1

    move/from16 v14, v28

    move-object/from16 v6, p0

    goto/16 :goto_0

    .line 872
    .end local v1    # "i":I
    :cond_3b
    move-object v0, v15

    return-void
.end method

.method private countMatchConstraintsChainedWidgets(Landroid/support/constraint/solver/LinearSystem;[Landroid/support/constraint/solver/widgets/ConstraintWidget;Landroid/support/constraint/solver/widgets/ConstraintWidget;I[Z)I
    .locals 17
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;
    .param p2, "chainEnds"    # [Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .param p3, "widget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .param p4, "direction"    # I
    .param p5, "flags"    # [Z

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p3

    .line 1886
    const/4 v3, 0x0

    .line 1887
    .local v3, "count":I
    const/4 v4, 0x1

    const/4 v5, 0x0

    aput-boolean v4, p5, v5

    .line 1888
    aput-boolean v5, p5, v4

    .line 1889
    const/4 v6, 0x0

    aput-object v6, p2, v5

    .line 1890
    const/4 v7, 0x2

    aput-object v6, p2, v7

    .line 1891
    aput-object v6, p2, v4

    .line 1892
    const/4 v8, 0x3

    aput-object v6, p2, v8

    .line 1894
    const/4 v9, 0x0

    const/4 v10, 0x5

    const/16 v11, 0x8

    if-nez p4, :cond_f

    .line 1895
    const/4 v12, 0x1

    .line 1896
    .local v12, "fixedPosition":Z
    move-object v13, v2

    .line 1897
    .local v13, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v14, 0x0

    .line 1898
    .local v14, "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v8, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v8, :cond_0

    iget-object v8, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v8, v0, :cond_0

    .line 1899
    const/4 v12, 0x0

    .line 1901
    :cond_0
    iput-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1902
    const/4 v8, 0x0

    .line 1903
    .local v8, "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual/range {p3 .. p3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v4

    if-eq v4, v11, :cond_1

    .line 1904
    move-object v8, v2

    .line 1906
    :cond_1
    move v4, v3

    move-object v3, v8

    move-object v15, v14

    .line 1907
    .end local v14    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local p3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v2, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v3, "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v4, "count":I
    .local v8, "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v15, "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_0
    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_b

    .line 1908
    iput-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1909
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v7

    if-eq v7, v11, :cond_4

    .line 1910
    if-nez v3, :cond_2

    .line 1911
    move-object v3, v2

    .line 1913
    :cond_2
    if-eqz v8, :cond_3

    if-eq v8, v2, :cond_3

    .line 1914
    iput-object v2, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1916
    :cond_3
    move-object v7, v2

    .line 1921
    .end local v8    # "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v7, "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move-object v8, v7

    goto :goto_1

    .line 1918
    .end local v7    # "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v8    # "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_4
    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1, v7, v6, v5, v10}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 1919
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1, v6, v7, v5, v10}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 1921
    :goto_1
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v6

    if-eq v6, v11, :cond_7

    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v6, v7, :cond_7

    .line 1922
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v7, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v6, v7, :cond_5

    .line 1923
    aput-boolean v5, p5, v5

    .line 1925
    :cond_5
    iget v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDimensionRatio:F

    cmpg-float v6, v6, v9

    if-gtz v6, :cond_7

    .line 1926
    aput-boolean v5, p5, v5

    .line 1927
    add-int/lit8 v6, v4, 0x1

    iget-object v7, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v7, v7

    if-lt v6, v7, :cond_6

    .line 1928
    iget-object v6, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v7, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v7, v7

    const/4 v14, 0x2

    mul-int/2addr v7, v14

    invoke-static {v6, v7}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v6

    check-cast v6, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v6, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1930
    :cond_6
    iget-object v6, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    add-int/lit8 v7, v4, 0x1

    .line 1930
    .local v7, "count":I
    aput-object v2, v6, v4

    .line 1933
    .end local v4    # "count":I
    move v4, v7

    .line 1933
    .end local v7    # "count":I
    .restart local v4    # "count":I
    :cond_7
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v6, :cond_8

    .line 1934
    goto :goto_2

    .line 1936
    :cond_8
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v6, v2, :cond_9

    .line 1937
    goto :goto_2

    .line 1939
    :cond_9
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v6, v2, :cond_a

    .line 1940
    goto :goto_2

    .line 1942
    :cond_a
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1943
    move-object v15, v2

    .line 1906
    const/4 v6, 0x0

    const/4 v7, 0x2

    goto/16 :goto_0

    .line 1945
    :cond_b
    :goto_2
    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v6, :cond_c

    iget-object v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v6, v6, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v6, v0, :cond_c

    .line 1946
    const/4 v12, 0x0

    .line 1948
    :cond_c
    move-object v6, v13

    iget-object v7, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1948
    .end local v13    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v6, "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_e

    move-object v7, v15

    iget-object v9, v7, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1948
    .end local v15    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v7, "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v9, :cond_d

    goto :goto_3

    .line 1953
    :cond_d
    const/4 v9, 0x1

    goto :goto_4

    .line 1949
    .end local v7    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v15    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_e
    move-object v7, v15

    .line 1949
    .end local v15    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v7    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_3
    const/4 v9, 0x1

    aput-boolean v9, p5, v9

    .line 1953
    :goto_4
    iput-boolean v12, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalChainFixedPosition:Z

    .line 1954
    const/4 v10, 0x0

    iput-object v10, v7, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1955
    aput-object v6, p2, v5

    .line 1956
    const/4 v5, 0x2

    aput-object v3, p2, v5

    .line 1957
    aput-object v7, p2, v9

    .line 1958
    const/4 v5, 0x3

    aput-object v8, p2, v5

    .line 1959
    .end local v3    # "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v6    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v7    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v8    # "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "fixedPosition":Z
    nop

    .line 2025
    move v7, v4

    goto/16 :goto_a

    .line 1960
    .end local v2    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "count":I
    .local v3, "count":I
    .restart local p3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_f
    const/4 v4, 0x1

    .line 1961
    .local v4, "fixedPosition":Z
    move-object v6, v2

    .line 1962
    .restart local v6    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v7, 0x0

    .line 1963
    .restart local v7    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v8, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v8, :cond_10

    iget-object v8, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v8, v0, :cond_10

    .line 1964
    const/4 v4, 0x0

    .line 1966
    :cond_10
    const/4 v8, 0x0

    iput-object v8, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1967
    const/4 v8, 0x0

    .line 1968
    .local v8, "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual/range {p3 .. p3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v12

    if-eq v12, v11, :cond_11

    .line 1969
    move-object v8, v2

    .line 1971
    :cond_11
    move-object v12, v7

    move v7, v3

    move-object v3, v8

    .line 1972
    .end local p3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .restart local v2    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v3, "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v7, "count":I
    .local v8, "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .local v12, "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_5
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v9, :cond_1b

    .line 1973
    const/4 v9, 0x0

    iput-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1974
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v9

    if-eq v9, v11, :cond_14

    .line 1975
    if-nez v3, :cond_12

    .line 1976
    move-object v3, v2

    .line 1978
    :cond_12
    if-eqz v8, :cond_13

    if-eq v8, v2, :cond_13

    .line 1979
    iput-object v2, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1981
    :cond_13
    move-object v8, v2

    goto :goto_6

    .line 1983
    :cond_14
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v11, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v11, v11, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v11, v11, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1, v9, v11, v5, v10}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 1984
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    iget-object v11, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v11, v11, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mSolverVariable:Landroid/support/constraint/solver/SolverVariable;

    invoke-virtual {v1, v9, v11, v5, v10}, Landroid/support/constraint/solver/LinearSystem;->addEquality(Landroid/support/constraint/solver/SolverVariable;Landroid/support/constraint/solver/SolverVariable;II)Landroid/support/constraint/solver/ArrayRow;

    .line 1986
    :goto_6
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v9

    const/16 v11, 0x8

    if-eq v9, v11, :cond_17

    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v9, v10, :cond_17

    .line 1987
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v9, v10, :cond_15

    .line 1988
    aput-boolean v5, p5, v5

    .line 1990
    :cond_15
    iget v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDimensionRatio:F

    const/4 v10, 0x0

    cmpg-float v9, v9, v10

    if-gtz v9, :cond_17

    .line 1991
    aput-boolean v5, p5, v5

    .line 1992
    add-int/lit8 v9, v7, 0x1

    iget-object v10, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v10, v10

    if-lt v9, v10, :cond_16

    .line 1993
    iget-object v9, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v10, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    array-length v10, v10

    const/4 v13, 0x2

    mul-int/2addr v10, v13

    invoke-static {v9, v10}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v9

    check-cast v9, [Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iput-object v9, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1995
    :cond_16
    iget-object v9, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMatchConstraintsChainedWidgets:[Landroid/support/constraint/solver/widgets/ConstraintWidget;

    add-int/lit8 v10, v7, 0x1

    .line 1995
    .local v10, "count":I
    aput-object v2, v9, v7

    .line 1998
    .end local v7    # "count":I
    move v7, v10

    .line 1998
    .end local v10    # "count":I
    .restart local v7    # "count":I
    :cond_17
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v9, :cond_18

    .line 1999
    goto :goto_7

    .line 2001
    :cond_18
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v9, v2, :cond_19

    .line 2002
    goto :goto_7

    .line 2004
    :cond_19
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v9, v2, :cond_1a

    .line 2005
    goto :goto_7

    .line 2007
    :cond_1a
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 2008
    move-object v12, v2

    .line 1971
    const/4 v9, 0x0

    const/4 v10, 0x5

    goto/16 :goto_5

    .line 2010
    :cond_1b
    :goto_7
    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v9, :cond_1c

    iget-object v9, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v9, v0, :cond_1c

    .line 2011
    const/4 v4, 0x0

    .line 2013
    :cond_1c
    iget-object v9, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v9, :cond_1e

    iget-object v9, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v9, :cond_1d

    goto :goto_8

    .line 2018
    :cond_1d
    const/4 v9, 0x1

    goto :goto_9

    .line 2014
    :cond_1e
    :goto_8
    const/4 v9, 0x1

    aput-boolean v9, p5, v9

    .line 2018
    :goto_9
    iput-boolean v4, v6, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalChainFixedPosition:Z

    .line 2019
    const/4 v10, 0x0

    iput-object v10, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalNextWidget:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 2020
    aput-object v6, p2, v5

    .line 2021
    const/4 v5, 0x2

    aput-object v3, p2, v5

    .line 2022
    aput-object v12, p2, v9

    .line 2023
    const/4 v5, 0x3

    aput-object v8, p2, v5

    .line 2025
    .end local v3    # "firstVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "fixedPosition":Z
    .end local v6    # "first":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v8    # "lastVisible":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "last":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_a
    return v7
.end method

.method public static createContainer(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Ljava/lang/String;Ljava/util/ArrayList;I)Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;
    .locals 7
    .param p0, "container"    # Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;
    .param p1, "name"    # Ljava/lang/String;
    .param p3, "padding"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;",
            "Ljava/lang/String;",
            "Ljava/util/ArrayList<",
            "Landroid/support/constraint/solver/widgets/ConstraintWidget;",
            ">;I)",
            "Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;"
        }
    .end annotation

    .line 172
    .local p2, "widgets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/constraint/solver/widgets/ConstraintWidget;>;"
    invoke-static {p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getBounds(Ljava/util/ArrayList;)Landroid/support/constraint/solver/widgets/Rectangle;

    move-result-object v0

    .line 173
    .local v0, "bounds":Landroid/support/constraint/solver/widgets/Rectangle;
    iget v1, v0, Landroid/support/constraint/solver/widgets/Rectangle;->width:I

    if-eqz v1, :cond_5

    iget v1, v0, Landroid/support/constraint/solver/widgets/Rectangle;->height:I

    if-nez v1, :cond_0

    goto :goto_2

    .line 176
    :cond_0
    if-lez p3, :cond_2

    .line 177
    iget v1, v0, Landroid/support/constraint/solver/widgets/Rectangle;->x:I

    iget v2, v0, Landroid/support/constraint/solver/widgets/Rectangle;->y:I

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 178
    .local v1, "maxPadding":I
    if-le p3, v1, :cond_1

    .line 179
    move p3, v1

    .line 181
    :cond_1
    invoke-virtual {v0, p3, p3}, Landroid/support/constraint/solver/widgets/Rectangle;->grow(II)V

    .line 183
    .end local v1    # "maxPadding":I
    :cond_2
    iget v1, v0, Landroid/support/constraint/solver/widgets/Rectangle;->x:I

    iget v2, v0, Landroid/support/constraint/solver/widgets/Rectangle;->y:I

    invoke-virtual {p0, v1, v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setOrigin(II)V

    .line 184
    iget v1, v0, Landroid/support/constraint/solver/widgets/Rectangle;->width:I

    iget v2, v0, Landroid/support/constraint/solver/widgets/Rectangle;->height:I

    invoke-virtual {p0, v1, v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setDimension(II)V

    .line 185
    invoke-virtual {p0, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setDebugName(Ljava/lang/String;)V

    .line 187
    const/4 v1, 0x0

    invoke-virtual {p2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getParent()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v1

    .line 188
    .local v1, "parent":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v2, 0x0

    .line 188
    .local v2, "i":I
    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 188
    .local v3, "widgetsSize":I
    :goto_0
    if-ge v2, v3, :cond_4

    .line 189
    invoke-virtual {p2, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 190
    .local v4, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getParent()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v5

    if-eq v5, v1, :cond_3

    .line 191
    goto :goto_1

    .line 193
    :cond_3
    invoke-virtual {p0, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->add(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 194
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getX()I

    move-result v5

    iget v6, v0, Landroid/support/constraint/solver/widgets/Rectangle;->x:I

    sub-int/2addr v5, v6

    invoke-virtual {v4, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setX(I)V

    .line 195
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getY()I

    move-result v5

    iget v6, v0, Landroid/support/constraint/solver/widgets/Rectangle;->y:I

    sub-int/2addr v5, v6

    invoke-virtual {v4, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setY(I)V

    .line 188
    .end local v4    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 197
    .end local v2    # "i":I
    .end local v3    # "widgetsSize":I
    :cond_4
    return-object p0

    .line 174
    .end local v1    # "parent":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_5
    :goto_2
    const/4 v1, 0x0

    return-object v1
.end method

.method private optimize(Landroid/support/constraint/solver/LinearSystem;)Z
    .locals 14
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;

    .line 263
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 264
    .local v0, "count":I
    const/4 v1, 0x0

    .line 265
    .local v1, "done":Z
    const/4 v2, 0x0

    .line 266
    .local v2, "dv":I
    const/4 v3, 0x0

    .line 267
    .local v3, "dh":I
    const/4 v4, 0x0

    .line 268
    .local v4, "n":I
    const/4 v5, 0x0

    move v6, v5

    .line 268
    .local v6, "i":I
    :goto_0
    const/4 v7, -0x1

    const/4 v8, 0x1

    if-ge v6, v0, :cond_2

    .line 269
    iget-object v9, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v9, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 271
    .local v9, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    .line 272
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    .line 273
    iget-object v7, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v7, v10, :cond_0

    iget-object v7, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v7, v10, :cond_1

    .line 275
    :cond_0
    iput v8, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    .line 276
    iput v8, v9, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    .line 268
    .end local v9    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_1
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 279
    .end local v6    # "i":I
    :cond_2
    :goto_1
    if-nez v1, :cond_c

    .line 280
    move v6, v2

    .line 281
    .local v6, "prev":I
    move v9, v3

    .line 282
    .local v9, "preh":I
    const/4 v2, 0x0

    .line 283
    const/4 v3, 0x0

    .line 284
    add-int/lit8 v4, v4, 0x1

    .line 288
    move v10, v3

    move v3, v2

    move v2, v5

    .line 288
    .local v2, "i":I
    .local v3, "dv":I
    .local v10, "dh":I
    :goto_2
    if-ge v2, v0, :cond_9

    .line 289
    iget-object v11, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v11, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 290
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    if-ne v12, v7, :cond_4

    .line 291
    iget-object v12, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v12, v13, :cond_3

    .line 292
    iput v8, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    goto :goto_3

    .line 294
    :cond_3
    invoke-static {p0, p1, v11}, Landroid/support/constraint/solver/widgets/Optimizer;->checkHorizontalSimpleDependency(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Landroid/support/constraint/solver/LinearSystem;Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 297
    :cond_4
    :goto_3
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    if-ne v12, v7, :cond_6

    .line 298
    iget-object v12, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v12, v13, :cond_5

    .line 299
    iput v8, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    goto :goto_4

    .line 301
    :cond_5
    invoke-static {p0, p1, v11}, Landroid/support/constraint/solver/widgets/Optimizer;->checkVerticalSimpleDependency(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Landroid/support/constraint/solver/LinearSystem;Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 309
    :cond_6
    :goto_4
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    if-ne v12, v7, :cond_7

    .line 310
    add-int/lit8 v3, v3, 0x1

    .line 312
    :cond_7
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    if-ne v12, v7, :cond_8

    .line 313
    add-int/lit8 v10, v10, 0x1

    .line 288
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_8
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 319
    .end local v2    # "i":I
    :cond_9
    if-nez v3, :cond_a

    if-nez v10, :cond_a

    .line 320
    const/4 v1, 0x1

    goto :goto_5

    .line 321
    :cond_a
    if-ne v6, v3, :cond_b

    if-ne v9, v10, :cond_b

    .line 322
    const/4 v1, 0x1

    .line 327
    .end local v6    # "prev":I
    .end local v9    # "preh":I
    :cond_b
    :goto_5
    nop

    .line 279
    move v2, v3

    move v3, v10

    goto :goto_1

    .line 329
    .end local v10    # "dh":I
    .local v2, "dv":I
    .local v3, "dh":I
    :cond_c
    const/4 v6, 0x0

    .line 330
    .local v6, "sh":I
    const/4 v9, 0x0

    .line 331
    .local v9, "sv":I
    move v10, v9

    move v9, v6

    move v6, v5

    .line 331
    .local v6, "i":I
    .local v9, "sh":I
    .local v10, "sv":I
    :goto_6
    if-ge v6, v0, :cond_11

    .line 332
    iget-object v11, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v11, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 333
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    if-eq v12, v8, :cond_d

    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalResolution:I

    if-ne v12, v7, :cond_e

    .line 335
    :cond_d
    add-int/lit8 v9, v9, 0x1

    .line 337
    :cond_e
    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    if-eq v12, v8, :cond_f

    iget v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalResolution:I

    if-ne v12, v7, :cond_10

    .line 339
    :cond_f
    add-int/lit8 v10, v10, 0x1

    .line 331
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_10
    add-int/lit8 v6, v6, 0x1

    goto :goto_6

    .line 342
    .end local v6    # "i":I
    :cond_11
    if-nez v9, :cond_12

    if-nez v10, :cond_12

    .line 343
    return v8

    .line 345
    :cond_12
    return v5
.end method

.method private resetChains()V
    .locals 1

    .line 1809
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    .line 1810
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    .line 1811
    return-void
.end method

.method static setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I
    .locals 4
    .param p0, "anchor"    # Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .param p1, "group"    # I

    .line 1157
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1158
    .local v0, "oldGroup":I
    iget-object v1, p0, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    invoke-virtual {v1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getParent()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v1

    if-nez v1, :cond_0

    .line 1159
    return p1

    .line 1161
    :cond_0
    if-gt v0, p1, :cond_1

    .line 1162
    return v0

    .line 1165
    :cond_1
    iput p1, p0, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1166
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getOpposite()Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v1

    .line 1167
    .local v1, "opposite":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1169
    .local v2, "target":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    if-eqz v1, :cond_2

    invoke-static {v1, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v3

    goto :goto_0

    :cond_2
    move v3, p1

    :goto_0
    move p1, v3

    .line 1170
    if-eqz v2, :cond_3

    invoke-static {v2, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v3

    goto :goto_1

    :cond_3
    move v3, p1

    :goto_1
    move p1, v3

    .line 1171
    if-eqz v1, :cond_4

    invoke-static {v1, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v3

    goto :goto_2

    :cond_4
    move v3, p1

    :goto_2
    move p1, v3

    .line 1173
    iput p1, p0, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1175
    return p1
.end method


# virtual methods
.method addChain(Landroid/support/constraint/solver/widgets/ConstraintWidget;I)V
    .locals 3
    .param p1, "constraintWidget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .param p2, "type"    # I

    .line 1820
    move-object v0, p1

    .line 1821
    .local v0, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    if-nez p2, :cond_1

    .line 1823
    :goto_0
    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v1, :cond_0

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v1, :cond_0

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-ne v1, v2, :cond_0

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v1, v0, :cond_0

    .line 1827
    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v0, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    goto :goto_0

    .line 1829
    :cond_0
    invoke-direct {p0, v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->addHorizontalChain(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    goto :goto_2

    .line 1830
    :cond_1
    const/4 v1, 0x1

    if-ne p2, v1, :cond_3

    .line 1832
    :goto_1
    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v1, :cond_2

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v1, :cond_2

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-ne v1, v2, :cond_2

    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v1, v0, :cond_2

    .line 1836
    iget-object v1, v0, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v1, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v0, v1, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    goto :goto_1

    .line 1838
    :cond_2
    invoke-direct {p0, v0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->addVerticalChain(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 1840
    :cond_3
    :goto_2
    return-void
.end method

.method public addChildrenToSolver(Landroid/support/constraint/solver/LinearSystem;I)Z
    .locals 7
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;
    .param p2, "group"    # I

    .line 210
    invoke-virtual {p0, p1, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->addToSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 211
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 212
    .local v0, "count":I
    const/4 v1, 0x0

    .line 213
    .local v1, "setMatchParent":Z
    iget v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    const/4 v3, 0x0

    const/4 v4, 0x2

    if-eq v2, v4, :cond_1

    iget v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    const/4 v4, 0x4

    if-ne v2, v4, :cond_0

    goto :goto_0

    .line 220
    :cond_0
    const/4 v1, 0x1

    goto :goto_1

    .line 215
    :cond_1
    :goto_0
    invoke-direct {p0, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->optimize(Landroid/support/constraint/solver/LinearSystem;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 216
    return v3

    .line 222
    :cond_2
    :goto_1
    nop

    .line 222
    .local v3, "i":I
    :goto_2
    move v2, v3

    .line 222
    .end local v3    # "i":I
    .local v2, "i":I
    if-ge v2, v0, :cond_9

    .line 223
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 224
    .local v3, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    if-eqz v4, :cond_7

    .line 225
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 226
    .local v4, "horizontalBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    iget-object v5, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 227
    .local v5, "verticalBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v4, v6, :cond_3

    .line 228
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v3, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 230
    :cond_3
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v5, v6, :cond_4

    .line 231
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    invoke-virtual {v3, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 233
    :cond_4
    invoke-virtual {v3, p1, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->addToSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 234
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v4, v6, :cond_5

    .line 235
    invoke-virtual {v3, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setHorizontalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 237
    :cond_5
    sget-object v6, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v5, v6, :cond_6

    .line 238
    invoke-virtual {v3, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->setVerticalDimensionBehaviour(Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;)V

    .line 240
    .end local v4    # "horizontalBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    .end local v5    # "verticalBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    :cond_6
    goto :goto_3

    .line 241
    :cond_7
    if-eqz v1, :cond_8

    .line 242
    invoke-static {p0, p1, v3}, Landroid/support/constraint/solver/widgets/Optimizer;->checkMatchParent(Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;Landroid/support/constraint/solver/LinearSystem;Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 244
    :cond_8
    invoke-virtual {v3, p1, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->addToSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 222
    .end local v3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :goto_3
    add-int/lit8 v3, v2, 0x1

    .line 222
    .end local v2    # "i":I
    .local v3, "i":I
    goto :goto_2

    .line 247
    .end local v3    # "i":I
    :cond_9
    iget v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalChainsSize:I

    if-lez v2, :cond_a

    .line 248
    invoke-direct {p0, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->applyHorizontalChain(Landroid/support/constraint/solver/LinearSystem;)V

    .line 250
    :cond_a
    iget v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalChainsSize:I

    if-lez v2, :cond_b

    .line 251
    invoke-direct {p0, p1}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->applyVerticalChain(Landroid/support/constraint/solver/LinearSystem;)V

    .line 253
    :cond_b
    const/4 v2, 0x1

    return v2
.end method

.method public findHorizontalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V
    .locals 9
    .param p1, "widget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .param p2, "flags"    # [Z

    .line 1198
    iget-object v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v1, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    const/4 v2, 0x0

    const/4 v3, 0x0

    if-ne v0, v1, :cond_0

    iget-object v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v1, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v0, v1, :cond_0

    iget v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDimensionRatio:F

    cmpl-float v0, v0, v2

    if-lez v0, :cond_0

    .line 1201
    aput-boolean v3, p2, v3

    .line 1202
    return-void

    .line 1204
    :cond_0
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapWidth()I

    move-result v0

    .line 1206
    .local v0, "w":I
    iget-object v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v4, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v1, v4, :cond_1

    .line 1207
    iget-object v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v4, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v1, v4, :cond_1

    iget v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDimensionRatio:F

    cmpl-float v1, v1, v2

    if-lez v1, :cond_1

    .line 1209
    aput-boolean v3, p2, v3

    .line 1210
    return-void

    .line 1216
    :cond_1
    move v1, v0

    .line 1217
    .local v1, "distToRight":I
    move v2, v0

    .line 1218
    .local v2, "distToLeft":I
    const/4 v4, 0x0

    .line 1219
    .local v4, "leftWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v5, 0x0

    .line 1220
    .local v5, "rightWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v6, 0x1

    iput-boolean v6, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWrapVisited:Z

    .line 1222
    instance-of v7, p1, Landroid/support/constraint/solver/widgets/Guideline;

    if-eqz v7, :cond_4

    .line 1223
    move-object v3, p1

    check-cast v3, Landroid/support/constraint/solver/widgets/Guideline;

    .line 1224
    .local v3, "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/Guideline;->getOrientation()I

    move-result v7

    if-ne v7, v6, :cond_3

    .line 1225
    const/4 v2, 0x0

    .line 1226
    const/4 v1, 0x0

    .line 1227
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeBegin()I

    move-result v6

    const/4 v7, -0x1

    if-eq v6, v7, :cond_2

    .line 1228
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeBegin()I

    move-result v2

    goto :goto_0

    .line 1229
    :cond_2
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeEnd()I

    move-result v6

    if-eq v6, v7, :cond_3

    .line 1230
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeEnd()I

    move-result v1

    .line 1233
    .end local v3    # "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    :cond_3
    :goto_0
    goto/16 :goto_9

    :cond_4
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->isConnected()Z

    move-result v7

    if-nez v7, :cond_5

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->isConnected()Z

    move-result v7

    if-nez v7, :cond_5

    .line 1234
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getX()I

    move-result v3

    add-int/2addr v2, v3

    goto/16 :goto_9

    .line 1236
    :cond_5
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_7

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_7

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eq v7, v8, :cond_6

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v8, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v8, v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v7, v8, :cond_7

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v8, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, v8, :cond_7

    .line 1240
    :cond_6
    aput-boolean v3, p2, v3

    .line 1241
    return-void

    .line 1243
    :cond_7
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_8

    .line 1244
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v5, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1245
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    add-int/2addr v1, v7

    .line 1246
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_8

    iget-boolean v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWrapVisited:Z

    if-nez v7, :cond_8

    .line 1247
    invoke-virtual {p0, v5, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findHorizontalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1250
    :cond_8
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_9

    .line 1251
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v4, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1252
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    add-int/2addr v2, v7

    .line 1253
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_9

    iget-boolean v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWrapVisited:Z

    if-nez v7, :cond_9

    .line 1254
    invoke-virtual {p0, v4, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findHorizontalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1258
    :cond_9
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_f

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_f

    .line 1259
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mType:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v8, :cond_a

    .line 1260
    iget v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapWidth()I

    move-result v8

    sub-int/2addr v7, v8

    add-int/2addr v1, v7

    goto :goto_1

    .line 1261
    :cond_a
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v8, :cond_b

    .line 1262
    iget v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    add-int/2addr v1, v7

    .line 1265
    :cond_b
    :goto_1
    iget-boolean v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRightHasCentered:Z

    if-nez v7, :cond_d

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_c

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_c

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v7, v8, :cond_c

    goto :goto_2

    :cond_c
    move v7, v3

    goto :goto_3

    :cond_d
    :goto_2
    move v7, v6

    :goto_3
    iput-boolean v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRightHasCentered:Z

    .line 1268
    iget-boolean v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRightHasCentered:Z

    if-eqz v7, :cond_f

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_e

    goto :goto_4

    :cond_e
    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_f

    .line 1270
    :goto_4
    iget v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    sub-int v7, v1, v7

    add-int/2addr v1, v7

    .line 1274
    :cond_f
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_15

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_15

    .line 1275
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v8, :cond_10

    .line 1276
    iget v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapWidth()I

    move-result v8

    sub-int/2addr v7, v8

    add-int/2addr v2, v7

    goto :goto_5

    .line 1277
    :cond_10
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v8, :cond_11

    .line 1278
    iget v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    add-int/2addr v2, v7

    .line 1281
    :cond_11
    :goto_5
    iget-boolean v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeftHasCentered:Z

    if-nez v7, :cond_13

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_12

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_12

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v8, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v7, v8, :cond_12

    goto :goto_6

    :cond_12
    goto :goto_7

    :cond_13
    :goto_6
    move v3, v6

    :goto_7
    iput-boolean v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeftHasCentered:Z

    .line 1284
    iget-boolean v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeftHasCentered:Z

    if-eqz v3, :cond_15

    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v3, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v3, :cond_14

    goto :goto_8

    :cond_14
    iget-object v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v3, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v3, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v3, p1, :cond_15

    .line 1286
    :goto_8
    iget v3, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    sub-int v3, v2, v3

    add-int/2addr v2, v3

    .line 1290
    :cond_15
    :goto_9
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v3

    const/16 v6, 0x8

    if-ne v3, v6, :cond_16

    .line 1291
    iget v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mWidth:I

    sub-int/2addr v2, v3

    .line 1292
    iget v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mWidth:I

    sub-int/2addr v1, v3

    .line 1294
    :cond_16
    iput v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    .line 1295
    iput v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    .line 1296
    return-void
.end method

.method public findVerticalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V
    .locals 10
    .param p1, "widget"    # Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .param p2, "flags"    # [Z

    .line 1299
    iget-object v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v1, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    const/4 v2, 0x0

    if-ne v0, v1, :cond_0

    .line 1300
    iget-object v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v1, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v0, v1, :cond_0

    iget v0, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDimensionRatio:F

    const/4 v1, 0x0

    cmpl-float v0, v0, v1

    if-lez v0, :cond_0

    .line 1302
    aput-boolean v2, p2, v2

    .line 1303
    return-void

    .line 1310
    :cond_0
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapHeight()I

    move-result v0

    .line 1312
    .local v0, "h":I
    move v1, v0

    .line 1313
    .local v1, "distToTop":I
    move v3, v0

    .line 1314
    .local v3, "distToBottom":I
    const/4 v4, 0x0

    .line 1315
    .local v4, "topWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v5, 0x0

    .line 1316
    .local v5, "bottomWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v6, 0x1

    iput-boolean v6, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    .line 1318
    instance-of v7, p1, Landroid/support/constraint/solver/widgets/Guideline;

    const/16 v8, 0x8

    if-eqz v7, :cond_3

    .line 1319
    move-object v2, p1

    check-cast v2, Landroid/support/constraint/solver/widgets/Guideline;

    .line 1320
    .local v2, "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/Guideline;->getOrientation()I

    move-result v6

    if-nez v6, :cond_2

    .line 1321
    const/4 v1, 0x0

    .line 1322
    const/4 v3, 0x0

    .line 1323
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeBegin()I

    move-result v6

    const/4 v7, -0x1

    if-eq v6, v7, :cond_1

    .line 1324
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeBegin()I

    move-result v1

    goto :goto_0

    .line 1325
    :cond_1
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeEnd()I

    move-result v6

    if-eq v6, v7, :cond_2

    .line 1326
    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/Guideline;->getRelativeEnd()I

    move-result v3

    .line 1329
    .end local v2    # "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    :cond_2
    :goto_0
    goto/16 :goto_9

    :cond_3
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_4

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_4

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_4

    .line 1330
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getY()I

    move-result v2

    add-int/2addr v1, v2

    goto/16 :goto_9

    .line 1332
    :cond_4
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_6

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_6

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eq v7, v9, :cond_5

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v9, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-ne v7, v9, :cond_6

    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    iget-object v9, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, v9, :cond_6

    .line 1336
    :cond_5
    aput-boolean v2, p2, v2

    .line 1337
    return-void

    .line 1339
    :cond_6
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->isConnected()Z

    move-result v7

    if-eqz v7, :cond_9

    .line 1340
    iget-object v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v2}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getOwner()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v2

    .line 1341
    .local v2, "baseLineWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-boolean v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    if-nez v6, :cond_7

    .line 1342
    invoke-virtual {p0, v2, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findVerticalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1344
    :cond_7
    iget v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    iget v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v6, v7

    add-int/2addr v6, v0

    invoke-static {v6, v0}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1345
    iget v6, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    iget v7, v2, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v6, v7

    add-int/2addr v6, v0

    invoke-static {v6, v0}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1346
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v6

    if-ne v6, v8, :cond_8

    .line 1347
    iget v6, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v1, v6

    .line 1348
    iget v6, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v3, v6

    .line 1350
    :cond_8
    iput v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    .line 1351
    iput v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    .line 1352
    return-void

    .line 1354
    .end local v2    # "baseLineWidget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_9
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->isConnected()Z

    move-result v7

    if-eqz v7, :cond_a

    .line 1355
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getOwner()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v4

    .line 1356
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    add-int/2addr v1, v7

    .line 1357
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_a

    iget-boolean v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    if-nez v7, :cond_a

    .line 1358
    invoke-virtual {p0, v4, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findVerticalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1361
    :cond_a
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->isConnected()Z

    move-result v7

    if-eqz v7, :cond_b

    .line 1362
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getOwner()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v5

    .line 1363
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getMargin()I

    move-result v7

    add-int/2addr v3, v7

    .line 1364
    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_b

    iget-boolean v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    if-nez v7, :cond_b

    .line 1365
    invoke-virtual {p0, v5, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findVerticalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1369
    :cond_b
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_11

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_11

    .line 1370
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v9, :cond_c

    .line 1371
    iget v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapHeight()I

    move-result v9

    sub-int/2addr v7, v9

    add-int/2addr v1, v7

    goto :goto_1

    .line 1372
    :cond_c
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v9, :cond_d

    .line 1373
    iget v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    add-int/2addr v1, v7

    .line 1376
    :cond_d
    :goto_1
    iget-boolean v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTopHasCentered:Z

    if-nez v7, :cond_f

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_e

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_e

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_e

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_e

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v7, v9, :cond_e

    goto :goto_2

    :cond_e
    move v7, v2

    goto :goto_3

    :cond_f
    :goto_2
    move v7, v6

    :goto_3
    iput-boolean v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTopHasCentered:Z

    .line 1381
    iget-boolean v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTopHasCentered:Z

    if-eqz v7, :cond_11

    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v7, :cond_10

    goto :goto_4

    :cond_10
    iget-object v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_11

    .line 1383
    :goto_4
    iget v7, v4, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    sub-int v7, v1, v7

    add-int/2addr v1, v7

    .line 1386
    :cond_11
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_17

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v7

    if-nez v7, :cond_17

    .line 1387
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v9, :cond_12

    .line 1388
    iget v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    invoke-virtual {v5}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getOptimizerWrapHeight()I

    move-result v9

    sub-int/2addr v7, v9

    add-int/2addr v3, v7

    goto :goto_5

    .line 1389
    :cond_12
    iget-object v7, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    invoke-virtual {v7}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getType()Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    move-result-object v7

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    if-ne v7, v9, :cond_13

    .line 1390
    iget v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    add-int/2addr v3, v7

    .line 1393
    :cond_13
    :goto_5
    iget-boolean v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottomHasCentered:Z

    if-nez v7, :cond_15

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_14

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_14

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v7, :cond_14

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v7, v7, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v7, p1, :cond_14

    iget-object v7, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v9, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v7, v9, :cond_14

    goto :goto_6

    :cond_14
    goto :goto_7

    :cond_15
    :goto_6
    move v2, v6

    :goto_7
    iput-boolean v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottomHasCentered:Z

    .line 1398
    iget-boolean v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottomHasCentered:Z

    if-eqz v2, :cond_17

    iget-object v2, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-nez v2, :cond_16

    goto :goto_8

    :cond_16
    iget-object v2, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget-object v2, v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eq v2, p1, :cond_17

    .line 1400
    :goto_8
    iget v2, v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    sub-int v2, v3, v2

    add-int/2addr v3, v2

    .line 1404
    :cond_17
    :goto_9
    invoke-virtual {p1}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v2

    if-ne v2, v8, :cond_18

    .line 1405
    iget v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v1, v2

    .line 1406
    iget v2, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHeight:I

    sub-int/2addr v3, v2

    .line 1409
    :cond_18
    iput v1, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    .line 1410
    iput v3, p1, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    .line 1411
    return-void
.end method

.method public findWrapSize(Ljava/util/ArrayList;[Z)V
    .locals 17
    .param p2, "flags"    # [Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/support/constraint/solver/widgets/ConstraintWidget;",
            ">;[Z)V"
        }
    .end annotation

    .line 1419
    .local p1, "children":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/constraint/solver/widgets/ConstraintWidget;>;"
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 1419
    move-object/from16 v2, p2

    const/4 v3, 0x0

    .line 1420
    .local v3, "maxTopDist":I
    const/4 v4, 0x0

    .line 1421
    .local v4, "maxLeftDist":I
    const/4 v5, 0x0

    .line 1422
    .local v5, "maxRightDist":I
    const/4 v6, 0x0

    .line 1424
    .local v6, "maxBottomDist":I
    const/4 v7, 0x0

    .line 1425
    .local v7, "maxConnectWidth":I
    const/4 v8, 0x0

    .line 1426
    .local v8, "maxConnectHeight":I
    invoke-virtual/range {p1 .. p1}, Ljava/util/ArrayList;->size()I

    move-result v9

    .line 1427
    .local v9, "size":I
    const/4 v10, 0x1

    const/4 v11, 0x0

    aput-boolean v10, v2, v11

    .line 1429
    move v10, v8

    move v8, v6

    move v6, v3

    move v3, v11

    .line 1429
    .local v3, "j":I
    .local v6, "maxTopDist":I
    .local v8, "maxBottomDist":I
    .local v10, "maxConnectHeight":I
    :goto_0
    if-ge v3, v9, :cond_7

    .line 1430
    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1431
    .local v12, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->isRoot()Z

    move-result v13

    if-eqz v13, :cond_0

    .line 1432
    goto/16 :goto_1

    .line 1434
    :cond_0
    iget-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWrapVisited:Z

    if-nez v13, :cond_1

    .line 1435
    invoke-virtual {v0, v12, v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findHorizontalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1437
    :cond_1
    iget-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    if-nez v13, :cond_2

    .line 1438
    invoke-virtual {v0, v12, v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findVerticalWrapRecursive(Landroid/support/constraint/solver/widgets/ConstraintWidget;[Z)V

    .line 1440
    :cond_2
    aget-boolean v13, v2, v11

    if-nez v13, :cond_3

    .line 1441
    return-void

    .line 1443
    :cond_3
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    iget v14, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    add-int/2addr v13, v14

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v14

    sub-int/2addr v13, v14

    .line 1444
    .local v13, "connectWidth":I
    iget v14, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    iget v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    add-int/2addr v14, v15

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v15

    sub-int/2addr v14, v15

    .line 1445
    .local v14, "connectHeight":I
    iget-object v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v11, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_PARENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v15, v11, :cond_4

    .line 1446
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v11

    iget-object v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget v15, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    add-int/2addr v11, v15

    iget-object v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget v15, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    add-int v13, v11, v15

    .line 1448
    :cond_4
    iget-object v11, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v15, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_PARENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v11, v15, :cond_5

    .line 1449
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v11

    iget-object v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget v15, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    add-int/2addr v11, v15

    iget-object v15, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iget v15, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mMargin:I

    add-int v14, v11, v15

    .line 1451
    :cond_5
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getVisibility()I

    move-result v11

    const/16 v15, 0x8

    if-ne v11, v15, :cond_6

    .line 1452
    const/4 v13, 0x0

    .line 1453
    const/4 v14, 0x0

    .line 1455
    :cond_6
    iget v11, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToLeft:I

    invoke-static {v4, v11}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 1456
    iget v11, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToRight:I

    invoke-static {v5, v11}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1457
    iget v11, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToBottom:I

    invoke-static {v8, v11}, Ljava/lang/Math;->max(II)I

    move-result v8

    .line 1458
    iget v11, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mDistToTop:I

    invoke-static {v6, v11}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 1459
    invoke-static {v7, v13}, Ljava/lang/Math;->max(II)I

    move-result v7

    .line 1460
    invoke-static {v10, v14}, Ljava/lang/Math;->max(II)I

    move-result v10

    .line 1429
    .end local v12    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v13    # "connectWidth":I
    .end local v14    # "connectHeight":I
    :goto_1
    add-int/lit8 v3, v3, 0x1

    const/4 v11, 0x0

    goto/16 :goto_0

    .line 1462
    .end local v3    # "j":I
    :cond_7
    invoke-static {v4, v5}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1463
    .local v3, "max":I
    iget v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinWidth:I

    invoke-static {v3, v7}, Ljava/lang/Math;->max(II)I

    move-result v12

    invoke-static {v11, v12}, Ljava/lang/Math;->max(II)I

    move-result v11

    iput v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapWidth:I

    .line 1464
    invoke-static {v6, v8}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1465
    iget v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinHeight:I

    invoke-static {v3, v10}, Ljava/lang/Math;->max(II)I

    move-result v12

    invoke-static {v11, v12}, Ljava/lang/Math;->max(II)I

    move-result v11

    iput v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapHeight:I

    .line 1466
    const/4 v11, 0x0

    .line 1466
    .local v11, "j":I
    :goto_2
    if-ge v11, v9, :cond_8

    .line 1467
    invoke-virtual {v1, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1468
    .local v12, "child":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v13, 0x0

    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalWrapVisited:Z

    .line 1469
    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalWrapVisited:Z

    .line 1470
    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeftHasCentered:Z

    .line 1471
    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRightHasCentered:Z

    .line 1472
    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTopHasCentered:Z

    .line 1473
    iput-boolean v13, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottomHasCentered:Z

    .line 1466
    .end local v12    # "child":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    add-int/lit8 v11, v11, 0x1

    goto :goto_2

    .line 1475
    .end local v11    # "j":I
    :cond_8
    return-void
.end method

.method public getHorizontalGuidelines()Ljava/util/ArrayList;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Landroid/support/constraint/solver/widgets/Guideline;",
            ">;"
        }
    .end annotation

    .line 1788
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1789
    .local v0, "guidelines":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/constraint/solver/widgets/Guideline;>;"
    const/4 v1, 0x0

    .line 1789
    .local v1, "i":I
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 1789
    .local v2, "mChildrenSize":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 1790
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1791
    .local v3, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v4, v3, Landroid/support/constraint/solver/widgets/Guideline;

    if-eqz v4, :cond_0

    .line 1792
    move-object v4, v3

    check-cast v4, Landroid/support/constraint/solver/widgets/Guideline;

    .line 1793
    .local v4, "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/Guideline;->getOrientation()I

    move-result v5

    if-nez v5, :cond_0

    .line 1794
    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1789
    .end local v3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1798
    .end local v1    # "i":I
    .end local v2    # "mChildrenSize":I
    :cond_1
    return-object v0
.end method

.method public getSystem()Landroid/support/constraint/solver/LinearSystem;
    .locals 1

    .line 1802
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    return-object v0
.end method

.method public getType()Ljava/lang/String;
    .locals 1

    .line 133
    const-string v0, "ConstraintLayout"

    return-object v0
.end method

.method public getVerticalGuidelines()Ljava/util/ArrayList;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Landroid/support/constraint/solver/widgets/Guideline;",
            ">;"
        }
    .end annotation

    .line 1769
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1770
    .local v0, "guidelines":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/constraint/solver/widgets/Guideline;>;"
    const/4 v1, 0x0

    .line 1770
    .local v1, "i":I
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 1770
    .local v2, "mChildrenSize":I
    :goto_0
    if-ge v1, v2, :cond_1

    .line 1771
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1772
    .local v3, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v4, v3, Landroid/support/constraint/solver/widgets/Guideline;

    if-eqz v4, :cond_0

    .line 1773
    move-object v4, v3

    check-cast v4, Landroid/support/constraint/solver/widgets/Guideline;

    .line 1774
    .local v4, "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    invoke-virtual {v4}, Landroid/support/constraint/solver/widgets/Guideline;->getOrientation()I

    move-result v5

    const/4 v6, 0x1

    if-ne v5, v6, :cond_0

    .line 1775
    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1770
    .end local v3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v4    # "guideline":Landroid/support/constraint/solver/widgets/Guideline;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1779
    .end local v1    # "i":I
    .end local v2    # "mChildrenSize":I
    :cond_1
    return-object v0
.end method

.method public handlesInternalConstraints()Z
    .locals 1

    .line 1756
    const/4 v0, 0x0

    return v0
.end method

.method public isHeightMeasuredTooSmall()Z
    .locals 1

    .line 157
    iget-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    return v0
.end method

.method public isWidthMeasuredTooSmall()Z
    .locals 1

    .line 152
    iget-boolean v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    return v0
.end method

.method public layout()V
    .locals 18

    .line 917
    move-object/from16 v1, p0

    iget v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 918
    .local v2, "prex":I
    iget v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 919
    .local v3, "prey":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v4

    const/4 v5, 0x0

    invoke-static {v5, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 920
    .local v4, "prew":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v6

    invoke-static {v5, v6}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 921
    .local v6, "preh":I
    iput-boolean v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 922
    iput-boolean v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 924
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eqz v7, :cond_1

    .line 925
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    if-nez v7, :cond_0

    .line 926
    new-instance v7, Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-direct {v7, v1}, Landroid/support/constraint/solver/widgets/Snapshot;-><init>(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    iput-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    .line 928
    :cond_0
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-virtual {v7, v1}, Landroid/support/constraint/solver/widgets/Snapshot;->updateFrom(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 933
    iget v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingLeft:I

    invoke-virtual {v1, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setX(I)V

    .line 934
    iget v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingTop:I

    invoke-virtual {v1, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setY(I)V

    .line 935
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetAnchors()V

    .line 936
    iget-object v7, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v7}, Landroid/support/constraint/solver/LinearSystem;->getCache()Landroid/support/constraint/solver/Cache;

    move-result-object v7

    invoke-virtual {v1, v7}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetSolverVariables(Landroid/support/constraint/solver/Cache;)V

    goto :goto_0

    .line 938
    :cond_1
    iput v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 939
    iput v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 942
    :goto_0
    const/4 v7, 0x0

    .line 943
    .local v7, "wrap_override":Z
    iget-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 944
    .local v8, "originalVerticalDimensionBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    iget-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 949
    .local v9, "originalHorizontalDimensionBehaviour":Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;
    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    const/4 v11, 0x2

    const/4 v12, 0x1

    if-ne v10, v11, :cond_8

    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-eq v10, v13, :cond_2

    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v10, v13, :cond_8

    .line 953
    :cond_2
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    iget-object v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    invoke-virtual {v1, v10, v13}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->findWrapSize(Ljava/util/ArrayList;[Z)V

    .line 954
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    aget-boolean v7, v10, v5

    .line 958
    if-lez v4, :cond_4

    if-lez v6, :cond_4

    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapWidth:I

    if-gt v10, v4, :cond_3

    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapHeight:I

    if-le v10, v6, :cond_4

    .line 961
    :cond_3
    const/4 v7, 0x0

    .line 963
    :cond_4
    if-eqz v7, :cond_8

    .line 964
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v10, v13, :cond_6

    .line 965
    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 966
    if-lez v4, :cond_5

    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapWidth:I

    if-ge v4, v10, :cond_5

    .line 967
    iput-boolean v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 968
    invoke-virtual {v1, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    goto :goto_1

    .line 970
    :cond_5
    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinWidth:I

    iget v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapWidth:I

    invoke-static {v10, v13}, Ljava/lang/Math;->max(II)I

    move-result v10

    invoke-virtual {v1, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 973
    :cond_6
    :goto_1
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v10, v13, :cond_8

    .line 974
    sget-object v10, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 975
    if-lez v6, :cond_7

    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapHeight:I

    if-ge v6, v10, :cond_7

    .line 976
    iput-boolean v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 977
    invoke-virtual {v1, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    goto :goto_2

    .line 979
    :cond_7
    iget v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinHeight:I

    iget v13, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWrapHeight:I

    invoke-static {v10, v13}, Ljava/lang/Math;->max(II)I

    move-result v10

    invoke-virtual {v1, v10}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 986
    :cond_8
    :goto_2
    invoke-direct/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetChains()V

    .line 990
    iget-object v10, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v10}, Ljava/util/ArrayList;->size()I

    move-result v10

    .line 991
    .local v10, "count":I
    move v13, v5

    .line 991
    .local v13, "i":I
    :goto_3
    if-ge v13, v10, :cond_a

    .line 992
    iget-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v14, v13}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 993
    .local v14, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v15, v14, Landroid/support/constraint/solver/widgets/WidgetContainer;

    if-eqz v15, :cond_9

    .line 994
    move-object v15, v14

    check-cast v15, Landroid/support/constraint/solver/widgets/WidgetContainer;

    invoke-virtual {v15}, Landroid/support/constraint/solver/widgets/WidgetContainer;->layout()V

    .line 991
    .end local v14    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_9
    add-int/lit8 v13, v13, 0x1

    goto :goto_3

    .line 999
    .end local v13    # "i":I
    :cond_a
    const/4 v13, 0x1

    .line 1000
    .local v13, "needsSolving":Z
    move v14, v7

    move v7, v5

    .line 1001
    .local v7, "countSolve":I
    .local v14, "wrap_override":Z
    :goto_4
    if-eqz v13, :cond_18

    .line 1002
    add-int/lit8 v7, v7, 0x1

    .line 1004
    const v15, 0x7fffffff

    :try_start_0
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v5}, Landroid/support/constraint/solver/LinearSystem;->reset()V

    .line 1014
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v1, v5, v15}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->addChildrenToSolver(Landroid/support/constraint/solver/LinearSystem;I)Z

    move-result v5

    move v13, v5

    .line 1015
    if-eqz v13, :cond_b

    .line 1016
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v5}, Landroid/support/constraint/solver/LinearSystem;->minimize()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1020
    :cond_b
    goto :goto_5

    .line 1018
    :catch_0
    move-exception v0

    move-object v5, v0

    .line 1019
    .local v5, "e":Ljava/lang/Exception;
    invoke-virtual {v5}, Ljava/lang/Exception;->printStackTrace()V

    .line 1021
    .end local v5    # "e":Ljava/lang/Exception;
    :goto_5
    if-eqz v13, :cond_c

    .line 1022
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    iget-object v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    invoke-virtual {v1, v5, v15, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateChildrenFromSolver(Landroid/support/constraint/solver/LinearSystem;I[Z)V

    goto :goto_7

    .line 1024
    :cond_c
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v1, v5, v15}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateFromSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 1025
    const/4 v5, 0x0

    .line 1025
    .local v5, "i":I
    :goto_6
    if-ge v5, v10, :cond_f

    .line 1026
    iget-object v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v11, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1027
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v15, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v15, v12, :cond_d

    .line 1028
    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v12

    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWrapWidth()I

    move-result v15

    if-ge v12, v15, :cond_d

    .line 1029
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    const/4 v15, 0x1

    const/16 v16, 0x2

    aput-boolean v15, v12, v16

    .line 1030
    goto :goto_7

    .line 1032
    :cond_d
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v15, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v12, v15, :cond_e

    .line 1033
    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v12

    invoke-virtual {v11}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWrapHeight()I

    move-result v15

    if-ge v12, v15, :cond_e

    .line 1034
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    const/4 v15, 0x1

    const/16 v16, 0x2

    aput-boolean v15, v12, v16

    .line 1035
    goto :goto_7

    .line 1025
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_e
    add-int/lit8 v5, v5, 0x1

    const/4 v12, 0x1

    goto :goto_6

    .line 1039
    .end local v5    # "i":I
    :cond_f
    :goto_7
    const/4 v5, 0x0

    .line 1041
    .end local v13    # "needsSolving":Z
    .local v5, "needsSolving":Z
    const/16 v11, 0x8

    if-ge v7, v11, :cond_12

    iget-object v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->flags:[Z

    const/4 v12, 0x2

    aget-boolean v11, v11, v12

    if-eqz v11, :cond_12

    .line 1043
    const/4 v11, 0x0

    .line 1044
    .local v11, "maxX":I
    const/4 v13, 0x0

    .line 1045
    .local v13, "maxY":I
    move v15, v13

    move v13, v11

    const/4 v11, 0x0

    .line 1045
    .local v11, "i":I
    .local v13, "maxX":I
    .local v15, "maxY":I
    :goto_8
    if-ge v11, v10, :cond_10

    .line 1046
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v12, v11}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1047
    .local v12, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move/from16 v17, v5

    iget v5, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mX:I

    .line 1047
    .end local v5    # "needsSolving":Z
    .local v17, "needsSolving":Z
    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v16

    add-int v5, v5, v16

    invoke-static {v13, v5}, Ljava/lang/Math;->max(II)I

    move-result v13

    .line 1048
    iget v5, v12, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mY:I

    invoke-virtual {v12}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v16

    add-int v5, v5, v16

    invoke-static {v15, v5}, Ljava/lang/Math;->max(II)I

    move-result v15

    .line 1045
    .end local v12    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    add-int/lit8 v11, v11, 0x1

    move/from16 v5, v17

    const/4 v12, 0x2

    goto :goto_8

    .line 1050
    .end local v11    # "i":I
    .end local v17    # "needsSolving":Z
    .restart local v5    # "needsSolving":Z
    :cond_10
    move/from16 v17, v5

    .line 1050
    .end local v5    # "needsSolving":Z
    .restart local v17    # "needsSolving":Z
    iget v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinWidth:I

    invoke-static {v5, v13}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1051
    .end local v13    # "maxX":I
    .local v5, "maxX":I
    iget v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinHeight:I

    invoke-static {v11, v15}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 1052
    .end local v15    # "maxY":I
    .local v11, "maxY":I
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v9, v12, :cond_11

    .line 1053
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v12

    if-ge v12, v5, :cond_11

    .line 1057
    invoke-virtual {v1, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1058
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1059
    const/4 v14, 0x1

    .line 1060
    const/4 v12, 0x1

    .line 1063
    .end local v17    # "needsSolving":Z
    .local v12, "needsSolving":Z
    move/from16 v17, v12

    .line 1063
    .end local v12    # "needsSolving":Z
    .restart local v17    # "needsSolving":Z
    :cond_11
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v8, v12, :cond_13

    .line 1064
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v12

    if-ge v12, v11, :cond_13

    .line 1068
    invoke-virtual {v1, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1069
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1070
    const/4 v14, 0x1

    .line 1071
    const/4 v5, 0x1

    .line 1076
    .end local v11    # "maxY":I
    .end local v17    # "needsSolving":Z
    .local v5, "needsSolving":Z
    move/from16 v17, v5

    goto :goto_9

    :cond_12
    move/from16 v17, v5

    .line 1076
    .end local v5    # "needsSolving":Z
    .restart local v17    # "needsSolving":Z
    :cond_13
    :goto_9
    iget v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinWidth:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v11

    invoke-static {v5, v11}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1077
    .local v5, "width":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v11

    if-le v5, v11, :cond_14

    .line 1081
    invoke-virtual {v1, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1082
    sget-object v11, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1083
    const/4 v14, 0x1

    .line 1084
    const/16 v17, 0x1

    .line 1086
    :cond_14
    iget v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinHeight:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v12

    invoke-static {v11, v12}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 1087
    .local v11, "height":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v12

    if-le v11, v12, :cond_15

    .line 1091
    invoke-virtual {v1, v11}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1092
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1093
    const/4 v14, 0x1

    .line 1094
    const/16 v17, 0x1

    .line 1097
    :cond_15
    if-nez v14, :cond_17

    .line 1098
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v12, v13, :cond_16

    if-lez v4, :cond_16

    .line 1099
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v12

    if-le v12, v4, :cond_16

    .line 1103
    const/4 v12, 0x1

    iput-boolean v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mWidthMeasuredTooSmall:Z

    .line 1104
    const/4 v14, 0x1

    .line 1105
    sget-object v12, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1106
    invoke-virtual {v1, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1107
    const/16 v17, 0x1

    .line 1110
    :cond_16
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v13, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->WRAP_CONTENT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v12, v13, :cond_17

    if-lez v6, :cond_17

    .line 1111
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v12

    if-le v12, v6, :cond_17

    .line 1115
    const/4 v12, 0x1

    iput-boolean v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHeightMeasuredTooSmall:Z

    .line 1116
    const/4 v13, 0x1

    .line 1117
    .end local v14    # "wrap_override":Z
    .local v13, "wrap_override":Z
    sget-object v14, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->FIXED:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    iput-object v14, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1118
    invoke-virtual {v1, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1119
    const/4 v5, 0x1

    .line 1123
    .end local v11    # "height":I
    .end local v17    # "needsSolving":Z
    .local v5, "needsSolving":Z
    move v14, v13

    move v13, v5

    goto :goto_a

    .line 1123
    .end local v5    # "needsSolving":Z
    .end local v13    # "wrap_override":Z
    .restart local v14    # "wrap_override":Z
    .restart local v17    # "needsSolving":Z
    :cond_17
    const/4 v12, 0x1

    .line 1123
    .end local v17    # "needsSolving":Z
    .local v13, "needsSolving":Z
    move/from16 v13, v17

    .line 1000
    :goto_a
    const/4 v5, 0x0

    const/4 v11, 0x2

    goto/16 :goto_4

    .line 1127
    :cond_18
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eqz v5, :cond_19

    .line 1128
    iget v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinWidth:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v11

    invoke-static {v5, v11}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 1129
    .local v5, "width":I
    iget v11, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mMinHeight:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v12

    invoke-static {v11, v12}, Ljava/lang/Math;->max(II)I

    move-result v11

    .line 1131
    .restart local v11    # "height":I
    iget-object v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-virtual {v12, v1}, Landroid/support/constraint/solver/widgets/Snapshot;->applyTo(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 1132
    iget v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingLeft:I

    add-int/2addr v12, v5

    iget v15, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingRight:I

    add-int/2addr v12, v15

    invoke-virtual {v1, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1133
    iget v12, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingTop:I

    add-int/2addr v12, v11

    iget v15, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingBottom:I

    add-int/2addr v12, v15

    invoke-virtual {v1, v12}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1134
    .end local v5    # "width":I
    .end local v11    # "height":I
    goto :goto_b

    .line 1135
    :cond_19
    iput v2, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 1136
    iput v3, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 1138
    :goto_b
    if-eqz v14, :cond_1a

    .line 1139
    iput-object v9, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1140
    iput-object v8, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    .line 1142
    :cond_1a
    iget-object v5, v1, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v5}, Landroid/support/constraint/solver/LinearSystem;->getCache()Landroid/support/constraint/solver/Cache;

    move-result-object v5

    invoke-virtual {v1, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetSolverVariables(Landroid/support/constraint/solver/Cache;)V

    .line 1143
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getRootConstraintContainer()Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    move-result-object v5

    if-ne v1, v5, :cond_1b

    .line 1144
    invoke-virtual/range {p0 .. p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateDrawPosition()V

    .line 1146
    :cond_1b
    return-void
.end method

.method public layoutFindGroups()I
    .locals 19

    .line 1481
    move-object/from16 v0, p0

    const/4 v1, 0x5

    new-array v1, v1, [Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->LEFT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    const/4 v3, 0x0

    aput-object v2, v1, v3

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->RIGHT:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    const/4 v4, 0x1

    aput-object v2, v1, v4

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->TOP:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    const/4 v5, 0x2

    aput-object v2, v1, v5

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BASELINE:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    const/4 v5, 0x3

    aput-object v2, v1, v5

    sget-object v2, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->BOTTOM:Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;

    const/4 v5, 0x4

    aput-object v2, v1, v5

    .line 1486
    .local v1, "dir":[Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;
    const/4 v2, 0x1

    .line 1487
    .local v2, "label":I
    iget-object v5, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    .line 1488
    .local v5, "size":I
    move v6, v2

    move v2, v3

    .line 1488
    .local v2, "j":I
    .local v6, "label":I
    :goto_0
    const v7, 0x7fffffff

    if-ge v2, v5, :cond_a

    .line 1489
    iget-object v8, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v8, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1490
    .local v8, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v9, 0x0

    .line 1492
    .local v9, "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v9, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1493
    iget-object v10, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_0

    .line 1494
    invoke-static {v9, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v10

    if-ne v10, v6, :cond_1

    .line 1495
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 1498
    :cond_0
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1501
    :cond_1
    :goto_1
    iget-object v9, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1502
    iget-object v10, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_2

    .line 1503
    invoke-static {v9, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v10

    if-ne v10, v6, :cond_3

    .line 1504
    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    .line 1507
    :cond_2
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1510
    :cond_3
    :goto_2
    iget-object v9, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1511
    iget-object v10, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_4

    .line 1512
    invoke-static {v9, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v10

    if-ne v10, v6, :cond_5

    .line 1513
    add-int/lit8 v6, v6, 0x1

    goto :goto_3

    .line 1516
    :cond_4
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1519
    :cond_5
    :goto_3
    iget-object v9, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1520
    iget-object v10, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_6

    .line 1521
    invoke-static {v9, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v10

    if-ne v10, v6, :cond_7

    .line 1522
    add-int/lit8 v6, v6, 0x1

    goto :goto_4

    .line 1525
    :cond_6
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1528
    :cond_7
    :goto_4
    iget-object v9, v8, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1529
    iget-object v10, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    if-eqz v10, :cond_8

    .line 1530
    invoke-static {v9, v6}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setGroup(Landroid/support/constraint/solver/widgets/ConstraintAnchor;I)I

    move-result v7

    if-ne v7, v6, :cond_9

    .line 1531
    add-int/lit8 v6, v6, 0x1

    goto :goto_5

    .line 1534
    :cond_8
    iput v7, v9, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1488
    .end local v8    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v9    # "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    :cond_9
    :goto_5
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1537
    .end local v2    # "j":I
    :cond_a
    const/4 v2, 0x1

    .line 1538
    .local v2, "notDone":Z
    const/4 v8, 0x0

    .line 1539
    .local v8, "count":I
    move v9, v8

    move v8, v2

    move v2, v3

    .line 1543
    .local v2, "fix":I
    .local v8, "notDone":Z
    .local v9, "count":I
    :goto_6
    if-eqz v8, :cond_12

    .line 1544
    const/4 v8, 0x0

    .line 1545
    add-int/lit8 v9, v9, 0x1

    .line 1546
    move v10, v2

    move v2, v3

    .line 1546
    .local v2, "j":I
    .local v10, "fix":I
    :goto_7
    if-ge v2, v5, :cond_11

    .line 1547
    iget-object v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v11, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1548
    .local v11, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    move v12, v10

    move v10, v8

    move v8, v3

    .line 1548
    .local v8, "i":I
    .local v10, "notDone":Z
    .local v12, "fix":I
    :goto_8
    array-length v13, v1

    if-ge v8, v13, :cond_10

    .line 1549
    aget-object v13, v1, v8

    .line 1550
    .local v13, "type":Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;
    const/4 v14, 0x0

    .line 1551
    .local v14, "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    sget-object v15, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer$2;->$SwitchMap$android$support$constraint$solver$widgets$ConstraintAnchor$Type:[I

    invoke-virtual {v13}, Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;->ordinal()I

    move-result v16

    aget v15, v15, v16

    packed-switch v15, :pswitch_data_0

    goto :goto_9

    .line 1569
    :pswitch_0
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    goto :goto_9

    .line 1565
    :pswitch_1
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1567
    goto :goto_9

    .line 1561
    :pswitch_2
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1563
    goto :goto_9

    .line 1557
    :pswitch_3
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1559
    goto :goto_9

    .line 1553
    :pswitch_4
    iget-object v14, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1555
    nop

    .line 1573
    :goto_9
    iget-object v15, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mTarget:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1574
    .local v15, "target":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    if-nez v15, :cond_b

    .line 1575
    goto :goto_c

    .line 1578
    :cond_b
    iget-object v3, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mOwner:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getParent()Landroid/support/constraint/solver/widgets/ConstraintWidget;

    move-result-object v3

    if-eqz v3, :cond_d

    iget v3, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iget v7, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    if-eq v3, v7, :cond_d

    .line 1579
    iget v3, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iget v7, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    if-le v3, v7, :cond_c

    iget v3, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    goto :goto_a

    :cond_c
    iget v3, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    :goto_a
    iput v3, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iput v3, v15, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1580
    add-int/lit8 v12, v12, 0x1

    .line 1581
    const/4 v10, 0x1

    .line 1584
    :cond_d
    invoke-virtual {v15}, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->getOpposite()Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    move-result-object v3

    .line 1585
    .local v3, "opposite":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    if-eqz v3, :cond_f

    iget v7, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iget v4, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    if-eq v7, v4, :cond_f

    .line 1586
    iget v4, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iget v7, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    if-le v4, v7, :cond_e

    iget v4, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    goto :goto_b

    :cond_e
    iget v4, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    :goto_b
    iput v4, v14, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    iput v4, v3, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1587
    add-int/lit8 v12, v12, 0x1

    .line 1588
    const/4 v3, 0x1

    .line 1548
    .end local v10    # "notDone":Z
    .end local v13    # "type":Landroid/support/constraint/solver/widgets/ConstraintAnchor$Type;
    .end local v14    # "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v15    # "target":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .local v3, "notDone":Z
    move v10, v3

    .line 1548
    .end local v3    # "notDone":Z
    .restart local v10    # "notDone":Z
    :cond_f
    :goto_c
    add-int/lit8 v8, v8, 0x1

    const/4 v3, 0x0

    const/4 v4, 0x1

    const v7, 0x7fffffff

    goto :goto_8

    .line 1546
    .end local v8    # "i":I
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_10
    add-int/lit8 v2, v2, 0x1

    move v8, v10

    move v10, v12

    const/4 v3, 0x0

    const/4 v4, 0x1

    const v7, 0x7fffffff

    goto/16 :goto_7

    .line 1539
    .end local v2    # "j":I
    .end local v12    # "fix":I
    .local v8, "notDone":Z
    .local v10, "fix":I
    :cond_11
    move v2, v10

    goto/16 :goto_6

    .line 1595
    .end local v10    # "fix":I
    .local v2, "fix":I
    :cond_12
    const/4 v3, 0x0

    .line 1596
    .local v3, "index":I
    iget-object v4, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    array-length v7, v1

    mul-int/2addr v4, v7

    const/4 v7, 0x1

    add-int/2addr v4, v7

    new-array v4, v4, [I

    .line 1597
    .local v4, "table":[I
    const/4 v7, -0x1

    invoke-static {v4, v7}, Ljava/util/Arrays;->fill([II)V

    .line 1598
    const/16 v17, 0x0

    .line 1598
    .local v17, "j":I
    :goto_d
    move/from16 v10, v17

    .line 1598
    .end local v17    # "j":I
    .local v10, "j":I
    if-ge v10, v5, :cond_1d

    .line 1599
    iget-object v11, v0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v11, v10}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1600
    .restart local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    const/4 v12, 0x0

    .line 1602
    .local v12, "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1603
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    const v14, 0x7fffffff

    if-eq v13, v14, :cond_14

    .line 1604
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1605
    .local v13, "g":I
    aget v14, v4, v13

    if-ne v14, v7, :cond_13

    .line 1606
    add-int/lit8 v14, v3, 0x1

    .line 1606
    .local v14, "index":I
    aput v3, v4, v13

    .line 1608
    .end local v3    # "index":I
    move v3, v14

    .line 1608
    .end local v14    # "index":I
    .restart local v3    # "index":I
    :cond_13
    aget v14, v4, v13

    iput v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1611
    .end local v13    # "g":I
    :cond_14
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1612
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    const v14, 0x7fffffff

    if-eq v13, v14, :cond_16

    .line 1613
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1614
    .restart local v13    # "g":I
    aget v14, v4, v13

    if-ne v14, v7, :cond_15

    .line 1615
    add-int/lit8 v14, v3, 0x1

    .line 1615
    .restart local v14    # "index":I
    aput v3, v4, v13

    .line 1617
    .end local v3    # "index":I
    move v3, v14

    .line 1617
    .end local v14    # "index":I
    .restart local v3    # "index":I
    :cond_15
    aget v14, v4, v13

    iput v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1620
    .end local v13    # "g":I
    :cond_16
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1621
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    const v14, 0x7fffffff

    if-eq v13, v14, :cond_18

    .line 1622
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1623
    .restart local v13    # "g":I
    aget v14, v4, v13

    if-ne v14, v7, :cond_17

    .line 1624
    add-int/lit8 v14, v3, 0x1

    .line 1624
    .restart local v14    # "index":I
    aput v3, v4, v13

    .line 1626
    .end local v3    # "index":I
    move v3, v14

    .line 1626
    .end local v14    # "index":I
    .restart local v3    # "index":I
    :cond_17
    aget v14, v4, v13

    iput v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1629
    .end local v13    # "g":I
    :cond_18
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1630
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    const v14, 0x7fffffff

    if-eq v13, v14, :cond_1a

    .line 1631
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1632
    .restart local v13    # "g":I
    aget v14, v4, v13

    if-ne v14, v7, :cond_19

    .line 1633
    add-int/lit8 v14, v3, 0x1

    .line 1633
    .restart local v14    # "index":I
    aput v3, v4, v13

    .line 1635
    .end local v3    # "index":I
    move v3, v14

    .line 1635
    .end local v14    # "index":I
    .restart local v3    # "index":I
    :cond_19
    aget v14, v4, v13

    iput v14, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1638
    .end local v13    # "g":I
    :cond_1a
    iget-object v12, v11, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    .line 1639
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    const v14, 0x7fffffff

    if-eq v13, v14, :cond_1c

    .line 1640
    iget v13, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1641
    .restart local v13    # "g":I
    aget v15, v4, v13

    if-ne v15, v7, :cond_1b

    .line 1642
    add-int/lit8 v15, v3, 0x1

    .line 1642
    .local v15, "index":I
    aput v3, v4, v13

    .line 1642
    .end local v3    # "index":I
    goto :goto_e

    .line 1644
    .end local v15    # "index":I
    .restart local v3    # "index":I
    :cond_1b
    move v15, v3

    .line 1644
    .end local v3    # "index":I
    .restart local v15    # "index":I
    :goto_e
    aget v3, v4, v13

    iput v3, v12, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1598
    .end local v11    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    .end local v12    # "anchor":Landroid/support/constraint/solver/widgets/ConstraintAnchor;
    .end local v13    # "g":I
    move v3, v15

    .line 1598
    .end local v15    # "index":I
    .restart local v3    # "index":I
    :cond_1c
    add-int/lit8 v17, v10, 0x1

    .line 1598
    .end local v10    # "j":I
    .restart local v17    # "j":I
    goto/16 :goto_d

    .line 1647
    .end local v17    # "j":I
    :cond_1d
    return v3

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public layoutFindGroupsSimple()I
    .locals 6

    .line 1179
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 1180
    .local v0, "size":I
    const/4 v1, 0x0

    move v2, v1

    .line 1180
    .local v2, "j":I
    :goto_0
    if-ge v2, v0, :cond_0

    .line 1181
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1182
    .local v3, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v1, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1183
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v1, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1184
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    const/4 v5, 0x1

    iput v5, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1185
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v5, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1186
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mBaseline:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v5, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1180
    .end local v3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1188
    .end local v2    # "j":I
    :cond_0
    const/4 v1, 0x2

    return v1
.end method

.method public layoutWithGroup(I)V
    .locals 7
    .param p1, "numOfGroups"    # I

    .line 1654
    iget v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 1655
    .local v0, "prex":I
    iget v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 1656
    .local v1, "prey":I
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    const/4 v3, 0x0

    if-eqz v2, :cond_1

    .line 1657
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    if-nez v2, :cond_0

    .line 1658
    new-instance v2, Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-direct {v2, p0}, Landroid/support/constraint/solver/widgets/Snapshot;-><init>(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    iput-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    .line 1660
    :cond_0
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-virtual {v2, p0}, Landroid/support/constraint/solver/widgets/Snapshot;->updateFrom(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 1665
    iput v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 1666
    iput v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 1667
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetAnchors()V

    .line 1668
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v2}, Landroid/support/constraint/solver/LinearSystem;->getCache()Landroid/support/constraint/solver/Cache;

    move-result-object v2

    invoke-virtual {p0, v2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->resetSolverVariables(Landroid/support/constraint/solver/Cache;)V

    goto :goto_0

    .line 1670
    :cond_1
    iput v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 1671
    iput v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 1675
    :goto_0
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 1676
    .local v2, "count":I
    move v4, v3

    .line 1676
    .local v4, "i":I
    :goto_1
    if-ge v4, v2, :cond_3

    .line 1677
    iget-object v5, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 1678
    .local v5, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    instance-of v6, v5, Landroid/support/constraint/solver/widgets/WidgetContainer;

    if-eqz v6, :cond_2

    .line 1679
    move-object v6, v5

    check-cast v6, Landroid/support/constraint/solver/widgets/WidgetContainer;

    invoke-virtual {v6}, Landroid/support/constraint/solver/widgets/WidgetContainer;->layout()V

    .line 1676
    .end local v5    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 1683
    .end local v4    # "i":I
    :cond_3
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mLeft:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v3, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1684
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mRight:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v3, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1685
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mTop:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    const/4 v5, 0x1

    iput v5, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1686
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mBottom:Landroid/support/constraint/solver/widgets/ConstraintAnchor;

    iput v5, v4, Landroid/support/constraint/solver/widgets/ConstraintAnchor;->mGroup:I

    .line 1687
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v4}, Landroid/support/constraint/solver/LinearSystem;->reset()V

    .line 1721
    nop

    .line 1721
    .local v3, "i":I
    :goto_2
    if-ge v3, p1, :cond_4

    .line 1723
    :try_start_0
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {p0, v4, v3}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->addToSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 1724
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v4}, Landroid/support/constraint/solver/LinearSystem;->minimize()V

    .line 1725
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {p0, v4, v3}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateFromSolver(Landroid/support/constraint/solver/LinearSystem;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1728
    goto :goto_3

    .line 1726
    :catch_0
    move-exception v4

    .line 1727
    .local v4, "e":Ljava/lang/Exception;
    invoke-virtual {v4}, Ljava/lang/Exception;->printStackTrace()V

    .line 1729
    .end local v4    # "e":Ljava/lang/Exception;
    :goto_3
    iget-object v4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    const/4 v5, -0x2

    invoke-virtual {p0, v4, v5}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateFromSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 1721
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 1733
    .end local v3    # "i":I
    :cond_4
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mParent:Landroid/support/constraint/solver/widgets/ConstraintWidget;

    if-eqz v3, :cond_5

    .line 1734
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getWidth()I

    move-result v3

    .line 1735
    .local v3, "width":I
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getHeight()I

    move-result v4

    .line 1737
    .local v4, "height":I
    iget-object v5, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSnapshot:Landroid/support/constraint/solver/widgets/Snapshot;

    invoke-virtual {v5, p0}, Landroid/support/constraint/solver/widgets/Snapshot;->applyTo(Landroid/support/constraint/solver/widgets/ConstraintWidget;)V

    .line 1738
    invoke-virtual {p0, v3}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setWidth(I)V

    .line 1739
    invoke-virtual {p0, v4}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->setHeight(I)V

    .line 1740
    .end local v3    # "width":I
    .end local v4    # "height":I
    goto :goto_4

    .line 1741
    :cond_5
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mX:I

    .line 1742
    iput v1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mY:I

    .line 1745
    :goto_4
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->getRootConstraintContainer()Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;

    move-result-object v3

    if-ne p0, v3, :cond_6

    .line 1746
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateDrawPosition()V

    .line 1748
    :cond_6
    return-void
.end method

.method public reset()V
    .locals 1

    .line 138
    iget-object v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mSystem:Landroid/support/constraint/solver/LinearSystem;

    invoke-virtual {v0}, Landroid/support/constraint/solver/LinearSystem;->reset()V

    .line 142
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingLeft:I

    .line 143
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingRight:I

    .line 144
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingTop:I

    .line 145
    iput v0, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingBottom:I

    .line 146
    invoke-super {p0}, Landroid/support/constraint/solver/widgets/WidgetContainer;->reset()V

    .line 147
    return-void
.end method

.method public setOptimizationLevel(I)V
    .locals 0
    .param p1, "value"    # I

    .line 123
    iput p1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mOptimizationLevel:I

    .line 124
    return-void
.end method

.method public setPadding(IIII)V
    .locals 0
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "right"    # I
    .param p4, "bottom"    # I

    .line 906
    iput p1, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingLeft:I

    .line 907
    iput p2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingTop:I

    .line 908
    iput p3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingRight:I

    .line 909
    iput p4, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mPaddingBottom:I

    .line 910
    return-void
.end method

.method public updateChildrenFromSolver(Landroid/support/constraint/solver/LinearSystem;I[Z)V
    .locals 7
    .param p1, "system"    # Landroid/support/constraint/solver/LinearSystem;
    .param p2, "group"    # I
    .param p3, "flags"    # [Z

    .line 880
    const/4 v0, 0x0

    const/4 v1, 0x2

    aput-boolean v0, p3, v1

    .line 881
    invoke-virtual {p0, p1, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->updateFromSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 882
    iget-object v2, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 883
    .local v2, "count":I
    nop

    .line 883
    .local v0, "i":I
    :goto_0
    if-ge v0, v2, :cond_2

    .line 884
    iget-object v3, p0, Landroid/support/constraint/solver/widgets/ConstraintWidgetContainer;->mChildren:Ljava/util/ArrayList;

    invoke-virtual {v3, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;

    .line 885
    .local v3, "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    invoke-virtual {v3, p1, p2}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->updateFromSolver(Landroid/support/constraint/solver/LinearSystem;I)V

    .line 886
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mHorizontalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    const/4 v6, 0x1

    if-ne v4, v5, :cond_0

    .line 887
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWidth()I

    move-result v4

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWrapWidth()I

    move-result v5

    if-ge v4, v5, :cond_0

    .line 888
    aput-boolean v6, p3, v1

    .line 890
    :cond_0
    iget-object v4, v3, Landroid/support/constraint/solver/widgets/ConstraintWidget;->mVerticalDimensionBehaviour:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    sget-object v5, Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;->MATCH_CONSTRAINT:Landroid/support/constraint/solver/widgets/ConstraintWidget$DimensionBehaviour;

    if-ne v4, v5, :cond_1

    .line 891
    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getHeight()I

    move-result v4

    invoke-virtual {v3}, Landroid/support/constraint/solver/widgets/ConstraintWidget;->getWrapHeight()I

    move-result v5

    if-ge v4, v5, :cond_1

    .line 892
    aput-boolean v6, p3, v1

    .line 883
    .end local v3    # "widget":Landroid/support/constraint/solver/widgets/ConstraintWidget;
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 895
    .end local v0    # "i":I
    :cond_2
    return-void
.end method
