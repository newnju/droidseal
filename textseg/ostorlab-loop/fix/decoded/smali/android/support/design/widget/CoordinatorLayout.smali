.class public Landroid/support/design/widget/CoordinatorLayout;
.super Landroid/view/ViewGroup;
.source "CoordinatorLayout.java"

# interfaces
.implements Landroid/support/v4/view/NestedScrollingParent2;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/design/widget/CoordinatorLayout$SavedState;,
        Landroid/support/design/widget/CoordinatorLayout$HierarchyChangeListener;,
        Landroid/support/design/widget/CoordinatorLayout$LayoutParams;,
        Landroid/support/design/widget/CoordinatorLayout$Behavior;,
        Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;,
        Landroid/support/design/widget/CoordinatorLayout$ViewElevationComparator;,
        Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;,
        Landroid/support/design/widget/CoordinatorLayout$DispatchChangeEvent;
    }
.end annotation


# static fields
.field static final CONSTRUCTOR_PARAMS:[Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "[",
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field static final EVENT_NESTED_SCROLL:I = 0x1

.field static final EVENT_PRE_DRAW:I = 0x0

.field static final EVENT_VIEW_REMOVED:I = 0x2

.field static final TAG:Ljava/lang/String; = "CoordinatorLayout"

.field static final TOP_SORTED_CHILDREN_COMPARATOR:Ljava/util/Comparator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Comparator<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private static final TYPE_ON_INTERCEPT:I = 0x0

.field private static final TYPE_ON_TOUCH:I = 0x1

.field static final WIDGET_PACKAGE_NAME:Ljava/lang/String;

.field static final sConstructors:Ljava/lang/ThreadLocal;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ThreadLocal<",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/reflect/Constructor<",
            "Landroid/support/design/widget/CoordinatorLayout$Behavior;",
            ">;>;>;"
        }
    .end annotation
.end field

.field private static final sRectPool:Landroid/support/v4/util/Pools$Pool;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/support/v4/util/Pools$Pool<",
            "Landroid/graphics/Rect;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mApplyWindowInsetsListener:Landroid/support/v4/view/OnApplyWindowInsetsListener;

.field private mBehaviorTouchView:Landroid/view/View;

.field private final mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/support/design/widget/DirectedAcyclicGraph<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private final mDependencySortedChildren:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private mDisallowInterceptReset:Z

.field private mDrawStatusBarBackground:Z

.field private mIsAttachedToWindow:Z

.field private mKeylines:[I

.field private mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

.field private mNeedsPreDrawListener:Z

.field private final mNestedScrollingParentHelper:Landroid/support/v4/view/NestedScrollingParentHelper;

.field private mNestedScrollingTarget:Landroid/view/View;

.field mOnHierarchyChangeListener:Landroid/view/ViewGroup$OnHierarchyChangeListener;

.field private mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

.field private mScrimPaint:Landroid/graphics/Paint;

.field private mStatusBarBackground:Landroid/graphics/drawable/Drawable;

.field private final mTempDependenciesList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private final mTempIntPair:[I

.field private final mTempList1:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 115
    const-class v0, Landroid/support/design/widget/CoordinatorLayout;

    invoke-virtual {v0}, Ljava/lang/Class;->getPackage()Ljava/lang/Package;

    move-result-object v0

    .line 116
    .local v0, "pkg":Ljava/lang/Package;
    const/4 v1, 0x0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Package;->getName()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    :cond_0
    move-object v2, v1

    :goto_0
    sput-object v2, Landroid/support/design/widget/CoordinatorLayout;->WIDGET_PACKAGE_NAME:Ljava/lang/String;

    .line 123
    .end local v0    # "pkg":Ljava/lang/Package;
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v0, v2, :cond_1

    .line 124
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$ViewElevationComparator;

    invoke-direct {v0}, Landroid/support/design/widget/CoordinatorLayout$ViewElevationComparator;-><init>()V

    sput-object v0, Landroid/support/design/widget/CoordinatorLayout;->TOP_SORTED_CHILDREN_COMPARATOR:Ljava/util/Comparator;

    goto :goto_1

    .line 126
    :cond_1
    sput-object v1, Landroid/support/design/widget/CoordinatorLayout;->TOP_SORTED_CHILDREN_COMPARATOR:Ljava/util/Comparator;

    .line 130
    :goto_1
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Class;

    const/4 v1, 0x0

    const-class v2, Landroid/content/Context;

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-class v2, Landroid/util/AttributeSet;

    aput-object v2, v0, v1

    sput-object v0, Landroid/support/design/widget/CoordinatorLayout;->CONSTRUCTOR_PARAMS:[Ljava/lang/Class;

    .line 135
    new-instance v0, Ljava/lang/ThreadLocal;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    sput-object v0, Landroid/support/design/widget/CoordinatorLayout;->sConstructors:Ljava/lang/ThreadLocal;

    .line 149
    new-instance v0, Landroid/support/v4/util/Pools$SynchronizedPool;

    const/16 v1, 0xc

    invoke-direct {v0, v1}, Landroid/support/v4/util/Pools$SynchronizedPool;-><init>(I)V

    sput-object v0, Landroid/support/design/widget/CoordinatorLayout;->sRectPool:Landroid/support/v4/util/Pools$Pool;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 196
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Landroid/support/design/widget/CoordinatorLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 197
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 200
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Landroid/support/design/widget/CoordinatorLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 201
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 8
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .line 204
    invoke-direct {p0, p1, p2, p3}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 165
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    .line 166
    new-instance v0, Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-direct {v0}, Landroid/support/design/widget/DirectedAcyclicGraph;-><init>()V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    .line 168
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempList1:Ljava/util/List;

    .line 169
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    .line 170
    const/4 v0, 0x2

    new-array v0, v0, [I

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    .line 192
    new-instance v0, Landroid/support/v4/view/NestedScrollingParentHelper;

    invoke-direct {v0, p0}, Landroid/support/v4/view/NestedScrollingParentHelper;-><init>(Landroid/view/ViewGroup;)V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingParentHelper:Landroid/support/v4/view/NestedScrollingParentHelper;

    .line 206
    invoke-static {p1}, Landroid/support/design/widget/ThemeUtils;->checkAppCompatTheme(Landroid/content/Context;)V

    .line 208
    sget-object v0, Landroid/support/design/R$styleable;->CoordinatorLayout:[I

    sget v1, Landroid/support/design/R$style;->Widget_Design_CoordinatorLayout:I

    invoke-virtual {p1, p2, v0, p3, v1}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[III)Landroid/content/res/TypedArray;

    move-result-object v0

    .line 210
    .local v0, "a":Landroid/content/res/TypedArray;
    sget v1, Landroid/support/design/R$styleable;->CoordinatorLayout_keylines:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v1

    .line 211
    .local v1, "keylineArrayRes":I
    if-eqz v1, :cond_0

    .line 212
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    .line 213
    .local v3, "res":Landroid/content/res/Resources;
    invoke-virtual {v3, v1}, Landroid/content/res/Resources;->getIntArray(I)[I

    move-result-object v4

    iput-object v4, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    .line 214
    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    iget v4, v4, Landroid/util/DisplayMetrics;->density:F

    .line 215
    .local v4, "density":F
    iget-object v5, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    array-length v5, v5

    .line 216
    .local v5, "count":I
    nop

    .line 216
    .local v2, "i":I
    :goto_0
    if-ge v2, v5, :cond_0

    .line 217
    iget-object v6, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    iget-object v7, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    aget v7, v7, v2

    int-to-float v7, v7

    mul-float/2addr v7, v4

    float-to-int v7, v7

    aput v7, v6, v2

    .line 216
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 220
    .end local v2    # "i":I
    .end local v3    # "res":Landroid/content/res/Resources;
    .end local v4    # "density":F
    .end local v5    # "count":I
    :cond_0
    sget v2, Landroid/support/design/R$styleable;->CoordinatorLayout_statusBarBackground:I

    invoke-virtual {v0, v2}, Landroid/content/res/TypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    iput-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    .line 221
    invoke-virtual {v0}, Landroid/content/res/TypedArray;->recycle()V

    .line 223
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->setupForInsets()V

    .line 224
    new-instance v2, Landroid/support/design/widget/CoordinatorLayout$HierarchyChangeListener;

    invoke-direct {v2, p0}, Landroid/support/design/widget/CoordinatorLayout$HierarchyChangeListener;-><init>(Landroid/support/design/widget/CoordinatorLayout;)V

    invoke-super {p0, v2}, Landroid/view/ViewGroup;->setOnHierarchyChangeListener(Landroid/view/ViewGroup$OnHierarchyChangeListener;)V

    .line 225
    return-void
.end method

.method private static acquireTempRect()Landroid/graphics/Rect;
    .locals 2
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .line 153
    sget-object v0, Landroid/support/design/widget/CoordinatorLayout;->sRectPool:Landroid/support/v4/util/Pools$Pool;

    invoke-interface {v0}, Landroid/support/v4/util/Pools$Pool;->acquire()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/graphics/Rect;

    .line 154
    .local v0, "rect":Landroid/graphics/Rect;
    if-nez v0, :cond_0

    .line 155
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    move-object v0, v1

    .line 157
    :cond_0
    return-object v0
.end method

.method private constrainChildRect(Landroid/support/design/widget/CoordinatorLayout$LayoutParams;Landroid/graphics/Rect;II)V
    .locals 7
    .param p1, "lp"    # Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .param p2, "out"    # Landroid/graphics/Rect;
    .param p3, "childWidth"    # I
    .param p4, "childHeight"    # I

    .line 1017
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v0

    .line 1018
    .local v0, "width":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v1

    .line 1021
    .local v1, "height":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v2

    iget v3, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->leftMargin:I

    add-int/2addr v2, v3

    iget v3, p2, Landroid/graphics/Rect;->left:I

    .line 1023
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v4

    sub-int v4, v0, v4

    sub-int/2addr v4, p3

    iget v5, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->rightMargin:I

    sub-int/2addr v4, v5

    .line 1022
    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    .line 1021
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 1024
    .local v2, "left":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v3

    iget v4, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->topMargin:I

    add-int/2addr v3, v4

    iget v4, p2, Landroid/graphics/Rect;->top:I

    .line 1026
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v5

    sub-int v5, v1, v5

    sub-int/2addr v5, p4

    iget v6, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->bottomMargin:I

    sub-int/2addr v5, v6

    .line 1025
    invoke-static {v4, v5}, Ljava/lang/Math;->min(II)I

    move-result v4

    .line 1024
    invoke-static {v3, v4}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1028
    .local v3, "top":I
    add-int v4, v2, p3

    add-int v5, v3, p4

    invoke-virtual {p2, v2, v3, v4, v5}, Landroid/graphics/Rect;->set(IIII)V

    .line 1029
    return-void
.end method

.method private dispatchApplyWindowInsetsToBehaviors(Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;
    .locals 6
    .param p1, "insets"    # Landroid/support/v4/view/WindowInsetsCompat;

    .line 806
    invoke-virtual {p1}, Landroid/support/v4/view/WindowInsetsCompat;->isConsumed()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 807
    return-object p1

    .line 810
    :cond_0
    const/4 v0, 0x0

    .line 810
    .local v0, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v1

    .line 810
    .local v1, "z":I
    :goto_0
    if-ge v0, v1, :cond_2

    .line 811
    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 812
    .local v2, "child":Landroid/view/View;
    invoke-static {v2}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 813
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 814
    .local v3, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v4

    .line 816
    .local v4, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v4, :cond_1

    .line 818
    invoke-virtual {v4, p0, v2, p1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onApplyWindowInsets(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;

    move-result-object p1

    .line 819
    invoke-virtual {p1}, Landroid/support/v4/view/WindowInsetsCompat;->isConsumed()Z

    move-result v5

    if-eqz v5, :cond_1

    .line 821
    goto :goto_1

    .line 810
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v4    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 827
    .end local v0    # "i":I
    .end local v1    # "z":I
    :cond_2
    :goto_1
    return-object p1
.end method

.method private getDesiredAnchoredChildRectWithoutConstraints(Landroid/view/View;ILandroid/graphics/Rect;Landroid/graphics/Rect;Landroid/support/design/widget/CoordinatorLayout$LayoutParams;II)V
    .locals 15
    .param p1, "child"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I
    .param p3, "anchorRect"    # Landroid/graphics/Rect;
    .param p4, "out"    # Landroid/graphics/Rect;
    .param p5, "lp"    # Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .param p6, "childWidth"    # I
    .param p7, "childHeight"    # I

    move/from16 v0, p2

    move-object/from16 v1, p3

    move-object/from16 v2, p5

    .line 943
    iget v3, v2, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->gravity:I

    .line 944
    invoke-static {v3}, Landroid/support/design/widget/CoordinatorLayout;->resolveAnchoredChildGravity(I)I

    move-result v3

    .line 943
    invoke-static {v3, v0}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v3

    .line 945
    .local v3, "absGravity":I
    iget v4, v2, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->anchorGravity:I

    .line 946
    invoke-static {v4}, Landroid/support/design/widget/CoordinatorLayout;->resolveGravity(I)I

    move-result v4

    .line 945
    invoke-static {v4, v0}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v4

    .line 949
    .local v4, "absAnchorGravity":I
    and-int/lit8 v5, v3, 0x7

    .line 950
    .local v5, "hgrav":I
    and-int/lit8 v6, v3, 0x70

    .line 951
    .local v6, "vgrav":I
    and-int/lit8 v7, v4, 0x7

    .line 952
    .local v7, "anchorHgrav":I
    and-int/lit8 v8, v4, 0x70

    .line 960
    .local v8, "anchorVgrav":I
    const/4 v9, 0x5

    const/4 v10, 0x1

    if-eq v7, v10, :cond_1

    if-eq v7, v9, :cond_0

    .line 963
    iget v11, v1, Landroid/graphics/Rect;->left:I

    .line 964
    .local v11, "left":I
    goto :goto_0

    .line 966
    .end local v11    # "left":I
    :cond_0
    iget v11, v1, Landroid/graphics/Rect;->right:I

    .line 967
    .restart local v11    # "left":I
    goto :goto_0

    .line 969
    .end local v11    # "left":I
    :cond_1
    iget v11, v1, Landroid/graphics/Rect;->left:I

    invoke-virtual/range {p3 .. p3}, Landroid/graphics/Rect;->width()I

    move-result v12

    div-int/lit8 v12, v12, 0x2

    add-int/2addr v11, v12

    .line 973
    .restart local v11    # "left":I
    :goto_0
    const/16 v12, 0x50

    const/16 v13, 0x10

    if-eq v8, v13, :cond_3

    if-eq v8, v12, :cond_2

    .line 976
    iget v12, v1, Landroid/graphics/Rect;->top:I

    .line 977
    .local v12, "top":I
    goto :goto_1

    .line 979
    .end local v12    # "top":I
    :cond_2
    iget v12, v1, Landroid/graphics/Rect;->bottom:I

    .line 980
    .restart local v12    # "top":I
    goto :goto_1

    .line 982
    .end local v12    # "top":I
    :cond_3
    iget v12, v1, Landroid/graphics/Rect;->top:I

    invoke-virtual/range {p3 .. p3}, Landroid/graphics/Rect;->height()I

    move-result v14

    div-int/lit8 v14, v14, 0x2

    add-int/2addr v12, v14

    .line 987
    .restart local v12    # "top":I
    :goto_1
    if-eq v5, v10, :cond_5

    if-eq v5, v9, :cond_4

    .line 990
    sub-int v11, v11, p6

    .line 991
    goto :goto_2

    .line 994
    :cond_4
    goto :goto_2

    .line 996
    :cond_5
    div-int/lit8 v9, p6, 0x2

    sub-int/2addr v11, v9

    .line 1000
    :goto_2
    if-eq v6, v13, :cond_7

    const/16 v9, 0x50

    if-eq v6, v9, :cond_6

    .line 1003
    sub-int v12, v12, p7

    .line 1004
    goto :goto_3

    .line 1007
    :cond_6
    goto :goto_3

    .line 1009
    :cond_7
    div-int/lit8 v9, p7, 0x2

    sub-int/2addr v12, v9

    .line 1013
    :goto_3
    add-int v9, v11, p6

    add-int v10, v12, p7

    move-object/from16 v13, p4

    invoke-virtual {v13, v11, v12, v9, v10}, Landroid/graphics/Rect;->set(IIII)V

    .line 1014
    return-void
.end method

.method private getKeyline(I)I
    .locals 4
    .param p1, "index"    # I

    .line 567
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 568
    const-string v0, "CoordinatorLayout"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "No keylines defined for "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " - attempted index lookup "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 569
    return v1

    .line 572
    :cond_0
    if-ltz p1, :cond_2

    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    array-length v0, v0

    if-lt p1, v0, :cond_1

    goto :goto_0

    .line 577
    :cond_1
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mKeylines:[I

    aget v0, v0, p1

    return v0

    .line 573
    :cond_2
    :goto_0
    const-string v0, "CoordinatorLayout"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Keyline index "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " out of range for "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 574
    return v1
.end method

.method private getTopSortedChildren(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 403
    .local p1, "out":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 405
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->isChildrenDrawingOrderEnabled()Z

    move-result v0

    .line 406
    .local v0, "useCustomOrder":Z
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v1

    .line 407
    .local v1, "childCount":I
    add-int/lit8 v2, v1, -0x1

    .line 407
    .local v2, "i":I
    :goto_0
    if-ltz v2, :cond_1

    .line 408
    if-eqz v0, :cond_0

    invoke-virtual {p0, v1, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildDrawingOrder(II)I

    move-result v3

    goto :goto_1

    :cond_0
    move v3, v2

    .line 409
    .local v3, "childIndex":I
    :goto_1
    invoke-virtual {p0, v3}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 410
    .local v4, "child":Landroid/view/View;
    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 407
    .end local v3    # "childIndex":I
    .end local v4    # "child":Landroid/view/View;
    add-int/lit8 v2, v2, -0x1

    goto :goto_0

    .line 413
    .end local v2    # "i":I
    :cond_1
    sget-object v2, Landroid/support/design/widget/CoordinatorLayout;->TOP_SORTED_CHILDREN_COMPARATOR:Ljava/util/Comparator;

    if-eqz v2, :cond_2

    .line 414
    sget-object v2, Landroid/support/design/widget/CoordinatorLayout;->TOP_SORTED_CHILDREN_COMPARATOR:Ljava/util/Comparator;

    invoke-static {p1, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 416
    :cond_2
    return-void
.end method

.method private hasDependencies(Landroid/view/View;)Z
    .locals 1
    .param p1, "child"    # Landroid/view/View;

    .line 1546
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v0, p1}, Landroid/support/design/widget/DirectedAcyclicGraph;->hasOutgoingEdges(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method private layoutChild(Landroid/view/View;I)V
    .locals 9
    .param p1, "child"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I

    .line 1146
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1147
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v7

    .line 1148
    .local v7, "parent":Landroid/graphics/Rect;
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v1

    iget v2, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->leftMargin:I

    add-int/2addr v1, v2

    .line 1149
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v2

    iget v3, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->topMargin:I

    add-int/2addr v2, v3

    .line 1150
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v4

    sub-int/2addr v3, v4

    iget v4, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->rightMargin:I

    sub-int/2addr v3, v4

    .line 1151
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v5

    sub-int/2addr v4, v5

    iget v5, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->bottomMargin:I

    sub-int/2addr v4, v5

    .line 1148
    invoke-virtual {v7, v1, v2, v3, v4}, Landroid/graphics/Rect;->set(IIII)V

    .line 1153
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    if-eqz v1, :cond_0

    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1154
    invoke-static {p1}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 1157
    iget v1, v7, Landroid/graphics/Rect;->left:I

    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v2}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetLeft()I

    move-result v2

    add-int/2addr v1, v2

    iput v1, v7, Landroid/graphics/Rect;->left:I

    .line 1158
    iget v1, v7, Landroid/graphics/Rect;->top:I

    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v2}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetTop()I

    move-result v2

    add-int/2addr v1, v2

    iput v1, v7, Landroid/graphics/Rect;->top:I

    .line 1159
    iget v1, v7, Landroid/graphics/Rect;->right:I

    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v2}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetRight()I

    move-result v2

    sub-int/2addr v1, v2

    iput v1, v7, Landroid/graphics/Rect;->right:I

    .line 1160
    iget v1, v7, Landroid/graphics/Rect;->bottom:I

    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v2}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetBottom()I

    move-result v2

    sub-int/2addr v1, v2

    iput v1, v7, Landroid/graphics/Rect;->bottom:I

    .line 1163
    :cond_0
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v8

    .line 1164
    .local v8, "out":Landroid/graphics/Rect;
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->gravity:I

    invoke-static {v1}, Landroid/support/design/widget/CoordinatorLayout;->resolveGravity(I)I

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    .line 1165
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v3

    .line 1164
    move-object v4, v7

    move-object v5, v8

    move v6, p2

    invoke-static/range {v1 .. v6}, Landroid/support/v4/view/GravityCompat;->apply(IIILandroid/graphics/Rect;Landroid/graphics/Rect;I)V

    .line 1166
    iget v1, v8, Landroid/graphics/Rect;->left:I

    iget v2, v8, Landroid/graphics/Rect;->top:I

    iget v3, v8, Landroid/graphics/Rect;->right:I

    iget v4, v8, Landroid/graphics/Rect;->bottom:I

    invoke-virtual {p1, v1, v2, v3, v4}, Landroid/view/View;->layout(IIII)V

    .line 1168
    invoke-static {v7}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1169
    invoke-static {v8}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1170
    return-void
.end method

.method private layoutChildWithAnchor(Landroid/view/View;Landroid/view/View;I)V
    .locals 7
    .param p1, "child"    # Landroid/view/View;
    .param p2, "anchor"    # Landroid/view/View;
    .param p3, "layoutDirection"    # I

    .line 1057
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1059
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v1

    .line 1060
    .local v1, "anchorRect":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v2

    .line 1062
    .local v2, "childRect":Landroid/graphics/Rect;
    :try_start_0
    invoke-virtual {p0, p2, v1}, Landroid/support/design/widget/CoordinatorLayout;->getDescendantRect(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1063
    invoke-virtual {p0, p1, p3, v1, v2}, Landroid/support/design/widget/CoordinatorLayout;->getDesiredAnchoredChildRect(Landroid/view/View;ILandroid/graphics/Rect;Landroid/graphics/Rect;)V

    .line 1064
    iget v3, v2, Landroid/graphics/Rect;->left:I

    iget v4, v2, Landroid/graphics/Rect;->top:I

    iget v5, v2, Landroid/graphics/Rect;->right:I

    iget v6, v2, Landroid/graphics/Rect;->bottom:I

    invoke-virtual {p1, v3, v4, v5, v6}, Landroid/view/View;->layout(IIII)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1066
    invoke-static {v1}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1067
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1068
    nop

    .line 1069
    return-void

    .line 1066
    :catchall_0
    move-exception v3

    invoke-static {v1}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1067
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    throw v3
.end method

.method private layoutChildWithKeyline(Landroid/view/View;II)V
    .locals 16
    .param p1, "child"    # Landroid/view/View;
    .param p2, "keyline"    # I
    .param p3, "layoutDirection"    # I

    .line 1083
    move/from16 v0, p3

    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1084
    .local v1, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget v2, v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->gravity:I

    .line 1085
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->resolveKeylineGravity(I)I

    move-result v2

    .line 1084
    invoke-static {v2, v0}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v2

    .line 1087
    .local v2, "absGravity":I
    and-int/lit8 v3, v2, 0x7

    .line 1088
    .local v3, "hgrav":I
    and-int/lit8 v4, v2, 0x70

    .line 1089
    .local v4, "vgrav":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v5

    .line 1090
    .local v5, "width":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v6

    .line 1091
    .local v6, "height":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v7

    .line 1092
    .local v7, "childWidth":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v8

    .line 1094
    .local v8, "childHeight":I
    const/4 v9, 0x1

    if-ne v0, v9, :cond_0

    .line 1095
    sub-int v10, v5, p2

    .line 1095
    .end local p2    # "keyline":I
    .local v10, "keyline":I
    goto :goto_0

    .line 1098
    .end local v10    # "keyline":I
    .restart local p2    # "keyline":I
    :cond_0
    move/from16 v10, p2

    .line 1098
    .end local p2    # "keyline":I
    .restart local v10    # "keyline":I
    :goto_0
    move-object/from16 v11, p0

    invoke-direct {v11, v10}, Landroid/support/design/widget/CoordinatorLayout;->getKeyline(I)I

    move-result v12

    sub-int/2addr v12, v7

    .line 1099
    .local v12, "left":I
    const/4 v13, 0x0

    .line 1101
    .local v13, "top":I
    if-eq v3, v9, :cond_2

    const/4 v9, 0x5

    if-eq v3, v9, :cond_1

    .line 1105
    goto :goto_1

    .line 1107
    :cond_1
    add-int/2addr v12, v7

    .line 1108
    goto :goto_1

    .line 1110
    :cond_2
    div-int/lit8 v9, v7, 0x2

    add-int/2addr v12, v9

    .line 1114
    :goto_1
    const/16 v9, 0x10

    if-eq v4, v9, :cond_4

    const/16 v9, 0x50

    if-eq v4, v9, :cond_3

    .line 1118
    goto :goto_2

    .line 1120
    :cond_3
    add-int/2addr v13, v8

    .line 1121
    goto :goto_2

    .line 1123
    :cond_4
    div-int/lit8 v9, v8, 0x2

    add-int/2addr v13, v9

    .line 1128
    :goto_2
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v9

    iget v14, v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->leftMargin:I

    add-int/2addr v9, v14

    .line 1130
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v14

    sub-int v14, v5, v14

    sub-int/2addr v14, v7

    iget v15, v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->rightMargin:I

    sub-int/2addr v14, v15

    .line 1129
    invoke-static {v12, v14}, Ljava/lang/Math;->min(II)I

    move-result v14

    .line 1128
    invoke-static {v9, v14}, Ljava/lang/Math;->max(II)I

    move-result v9

    .line 1131
    .end local v12    # "left":I
    .local v9, "left":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v12

    iget v14, v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->topMargin:I

    add-int/2addr v12, v14

    .line 1133
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v14

    sub-int v14, v6, v14

    sub-int/2addr v14, v8

    iget v15, v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->bottomMargin:I

    sub-int/2addr v14, v15

    .line 1132
    invoke-static {v13, v14}, Ljava/lang/Math;->min(II)I

    move-result v14

    .line 1131
    invoke-static {v12, v14}, Ljava/lang/Math;->max(II)I

    move-result v12

    .line 1135
    .end local v13    # "top":I
    .local v12, "top":I
    add-int v13, v9, v7

    add-int v14, v12, v8

    move-object/from16 v15, p1

    invoke-virtual {v15, v9, v12, v13, v14}, Landroid/view/View;->layout(IIII)V

    .line 1136
    return-void
.end method

.method private offsetChildByInset(Landroid/view/View;Landroid/graphics/Rect;I)V
    .locals 10
    .param p1, "child"    # Landroid/view/View;
    .param p2, "inset"    # Landroid/graphics/Rect;
    .param p3, "layoutDirection"    # I

    .line 1354
    invoke-static {p1}, Landroid/support/v4/view/ViewCompat;->isLaidOut(Landroid/view/View;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1356
    return-void

    .line 1359
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_b

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_1

    goto/16 :goto_0

    .line 1364
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1365
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v1

    .line 1366
    .local v1, "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v2

    .line 1367
    .local v2, "dodgeRect":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v3

    .line 1368
    .local v3, "bounds":Landroid/graphics/Rect;
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I

    move-result v4

    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    move-result v5

    invoke-virtual {p1}, Landroid/view/View;->getRight()I

    move-result v6

    invoke-virtual {p1}, Landroid/view/View;->getBottom()I

    move-result v7

    invoke-virtual {v3, v4, v5, v6, v7}, Landroid/graphics/Rect;->set(IIII)V

    .line 1370
    if-eqz v1, :cond_2

    invoke-virtual {v1, p0, p1, v2}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->getInsetDodgeRect(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/graphics/Rect;)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 1372
    invoke-virtual {v3, v2}, Landroid/graphics/Rect;->contains(Landroid/graphics/Rect;)Z

    move-result v4

    if-nez v4, :cond_3

    .line 1373
    new-instance v4, Ljava/lang/IllegalArgumentException;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Rect should be within the child\'s bounds. Rect:"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1374
    invoke-virtual {v2}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " | Bounds:"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1375
    invoke-virtual {v3}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 1378
    :cond_2
    invoke-virtual {v2, v3}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 1382
    :cond_3
    invoke-static {v3}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1384
    invoke-virtual {v2}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_4

    .line 1386
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1387
    return-void

    .line 1390
    :cond_4
    iget v4, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->dodgeInsetEdges:I

    invoke-static {v4, p3}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v4

    .line 1393
    .local v4, "absDodgeInsetEdges":I
    const/4 v5, 0x0

    .line 1394
    .local v5, "offsetY":Z
    and-int/lit8 v6, v4, 0x30

    const/16 v7, 0x30

    if-ne v6, v7, :cond_5

    .line 1395
    iget v6, v2, Landroid/graphics/Rect;->top:I

    iget v7, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->topMargin:I

    sub-int/2addr v6, v7

    iget v7, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetY:I

    sub-int/2addr v6, v7

    .line 1396
    .local v6, "distance":I
    iget v7, p2, Landroid/graphics/Rect;->top:I

    if-ge v6, v7, :cond_5

    .line 1397
    iget v7, p2, Landroid/graphics/Rect;->top:I

    sub-int/2addr v7, v6

    invoke-direct {p0, p1, v7}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetY(Landroid/view/View;I)V

    .line 1398
    const/4 v5, 0x1

    .line 1401
    .end local v6    # "distance":I
    :cond_5
    and-int/lit8 v6, v4, 0x50

    const/16 v7, 0x50

    if-ne v6, v7, :cond_6

    .line 1402
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v6

    iget v7, v2, Landroid/graphics/Rect;->bottom:I

    sub-int/2addr v6, v7

    iget v7, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->bottomMargin:I

    sub-int/2addr v6, v7

    iget v7, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetY:I

    add-int/2addr v6, v7

    .line 1403
    .restart local v6    # "distance":I
    iget v7, p2, Landroid/graphics/Rect;->bottom:I

    if-ge v6, v7, :cond_6

    .line 1404
    iget v7, p2, Landroid/graphics/Rect;->bottom:I

    sub-int v7, v6, v7

    invoke-direct {p0, p1, v7}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetY(Landroid/view/View;I)V

    .line 1405
    const/4 v5, 0x1

    .line 1408
    .end local v6    # "distance":I
    :cond_6
    const/4 v6, 0x0

    if-nez v5, :cond_7

    .line 1409
    invoke-direct {p0, p1, v6}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetY(Landroid/view/View;I)V

    .line 1412
    :cond_7
    const/4 v7, 0x0

    .line 1413
    .local v7, "offsetX":Z
    and-int/lit8 v8, v4, 0x3

    const/4 v9, 0x3

    if-ne v8, v9, :cond_8

    .line 1414
    iget v8, v2, Landroid/graphics/Rect;->left:I

    iget v9, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->leftMargin:I

    sub-int/2addr v8, v9

    iget v9, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetX:I

    sub-int/2addr v8, v9

    .line 1415
    .local v8, "distance":I
    iget v9, p2, Landroid/graphics/Rect;->left:I

    if-ge v8, v9, :cond_8

    .line 1416
    iget v9, p2, Landroid/graphics/Rect;->left:I

    sub-int/2addr v9, v8

    invoke-direct {p0, p1, v9}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetX(Landroid/view/View;I)V

    .line 1417
    const/4 v7, 0x1

    .line 1420
    .end local v8    # "distance":I
    :cond_8
    and-int/lit8 v8, v4, 0x5

    const/4 v9, 0x5

    if-ne v8, v9, :cond_9

    .line 1421
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v8

    iget v9, v2, Landroid/graphics/Rect;->right:I

    sub-int/2addr v8, v9

    iget v9, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->rightMargin:I

    sub-int/2addr v8, v9

    iget v9, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetX:I

    add-int/2addr v8, v9

    .line 1422
    .restart local v8    # "distance":I
    iget v9, p2, Landroid/graphics/Rect;->right:I

    if-ge v8, v9, :cond_9

    .line 1423
    iget v9, p2, Landroid/graphics/Rect;->right:I

    sub-int v9, v8, v9

    invoke-direct {p0, p1, v9}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetX(Landroid/view/View;I)V

    .line 1424
    const/4 v7, 0x1

    .line 1427
    .end local v8    # "distance":I
    :cond_9
    if-nez v7, :cond_a

    .line 1428
    invoke-direct {p0, p1, v6}, Landroid/support/design/widget/CoordinatorLayout;->setInsetOffsetX(Landroid/view/View;I)V

    .line 1431
    :cond_a
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1432
    return-void

    .line 1361
    .end local v0    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v1    # "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v2    # "dodgeRect":Landroid/graphics/Rect;
    .end local v3    # "bounds":Landroid/graphics/Rect;
    .end local v4    # "absDodgeInsetEdges":I
    .end local v5    # "offsetY":Z
    .end local v7    # "offsetX":Z
    :cond_b
    :goto_0
    return-void
.end method

.method static parseBehavior(Landroid/content/Context;Landroid/util/AttributeSet;Ljava/lang/String;)Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .locals 6
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "attrs"    # Landroid/util/AttributeSet;
    .param p2, "name"    # Ljava/lang/String;

    .line 581
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 582
    const/4 v0, 0x0

    return-object v0

    .line 586
    :cond_0
    const-string v0, "."

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 588
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 588
    .local v0, "fullName":Ljava/lang/String;
    :goto_0
    goto :goto_1

    .line 589
    .end local v0    # "fullName":Ljava/lang/String;
    :cond_1
    const/16 v0, 0x2e

    invoke-virtual {p2, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    if-ltz v1, :cond_2

    .line 591
    move-object v0, p2

    goto :goto_0

    .line 594
    :cond_2
    sget-object v1, Landroid/support/design/widget/CoordinatorLayout;->WIDGET_PACKAGE_NAME:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v2, Landroid/support/design/widget/CoordinatorLayout;->WIDGET_PACKAGE_NAME:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_3
    move-object v0, p2

    .line 600
    .restart local v0    # "fullName":Ljava/lang/String;
    :goto_1
    :try_start_0
    sget-object v1, Landroid/support/design/widget/CoordinatorLayout;->sConstructors:Ljava/lang/ThreadLocal;

    invoke-virtual {v1}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    .line 601
    .local v1, "constructors":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/reflect/Constructor<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;>;"
    if-nez v1, :cond_4

    .line 602
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    move-object v1, v2

    .line 603
    sget-object v2, Landroid/support/design/widget/CoordinatorLayout;->sConstructors:Ljava/lang/ThreadLocal;

    invoke-virtual {v2, v1}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    .line 605
    :cond_4
    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/reflect/Constructor;

    .line 606
    .local v2, "c":Ljava/lang/reflect/Constructor;, "Ljava/lang/reflect/Constructor<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;"
    const/4 v3, 0x1

    if-nez v2, :cond_5

    .line 607
    nop

    .line 608
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    .line 607
    invoke-static {v0, v3, v4}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v4

    .line 609
    .local v4, "clazz":Ljava/lang/Class;, "Ljava/lang/Class<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;"
    sget-object v5, Landroid/support/design/widget/CoordinatorLayout;->CONSTRUCTOR_PARAMS:[Ljava/lang/Class;

    invoke-virtual {v4, v5}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v5

    move-object v2, v5

    .line 610
    invoke-virtual {v2, v3}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 611
    invoke-interface {v1, v0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 613
    .end local v4    # "clazz":Ljava/lang/Class;, "Ljava/lang/Class<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;"
    :cond_5
    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object p0, v4, v5

    aput-object p1, v4, v3

    invoke-virtual {v2, v4}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v3

    .line 614
    .end local v1    # "constructors":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/reflect/Constructor<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;>;"
    .end local v2    # "c":Ljava/lang/reflect/Constructor;, "Ljava/lang/reflect/Constructor<Landroid/support/design/widget/CoordinatorLayout$Behavior;>;"
    :catch_0
    move-exception v1

    .line 615
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/RuntimeException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Could not inflate Behavior subclass "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v2
.end method

.method private performIntercept(Landroid/view/MotionEvent;I)Z
    .locals 23
    .param p1, "ev"    # Landroid/view/MotionEvent;
    .param p2, "type"    # I

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 419
    const/4 v2, 0x0

    .line 420
    .local v2, "intercepted":Z
    const/4 v3, 0x0

    .line 422
    .local v3, "newBlock":Z
    const/4 v4, 0x0

    .line 424
    .local v4, "cancelEvent":Landroid/view/MotionEvent;
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v5

    .line 426
    .local v5, "action":I
    iget-object v6, v0, Landroid/support/design/widget/CoordinatorLayout;->mTempList1:Ljava/util/List;

    .line 427
    .local v6, "topmostChildList":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    invoke-direct {v0, v6}, Landroid/support/design/widget/CoordinatorLayout;->getTopSortedChildren(Ljava/util/List;)V

    .line 430
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v7

    .line 431
    .local v7, "childCount":I
    const/4 v8, 0x0

    move-object v9, v4

    move v4, v3

    move v3, v2

    move v2, v8

    .line 431
    .local v2, "i":I
    .local v3, "intercepted":Z
    .local v4, "newBlock":Z
    .local v9, "cancelEvent":Landroid/view/MotionEvent;
    :goto_0
    if-ge v2, v7, :cond_6

    .line 432
    invoke-interface {v6, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Landroid/view/View;

    .line 433
    .local v10, "child":Landroid/view/View;
    invoke-virtual {v10}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v11

    check-cast v11, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 434
    .local v11, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v11}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v12

    .line 436
    .local v12, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-nez v3, :cond_0

    if-eqz v4, :cond_2

    :cond_0
    if-eqz v5, :cond_2

    .line 439
    if-eqz v12, :cond_5

    .line 440
    if-nez v9, :cond_1

    .line 441
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v21

    .line 442
    .local v21, "now":J
    const/16 v17, 0x3

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v20, 0x0

    move-wide/from16 v13, v21

    move-wide/from16 v15, v21

    invoke-static/range {v13 .. v20}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v9

    .line 445
    .end local v21    # "now":J
    :cond_1
    packed-switch p2, :pswitch_data_0

    goto :goto_1

    .line 450
    :pswitch_0
    invoke-virtual {v12, v0, v10, v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    goto :goto_1

    .line 447
    :pswitch_1
    invoke-virtual {v12, v0, v10, v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onInterceptTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 448
    nop

    .line 451
    :goto_1
    goto :goto_4

    .line 457
    :cond_2
    if-nez v3, :cond_3

    if-eqz v12, :cond_3

    .line 458
    packed-switch p2, :pswitch_data_1

    goto :goto_2

    .line 463
    :pswitch_2
    invoke-virtual {v12, v0, v10, v1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v3

    goto :goto_2

    .line 460
    :pswitch_3
    invoke-virtual {v12, v0, v10, v1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onInterceptTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v3

    .line 461
    nop

    .line 466
    :goto_2
    if-eqz v3, :cond_3

    .line 467
    iput-object v10, v0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    .line 473
    :cond_3
    invoke-virtual {v11}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->didBlockInteraction()Z

    move-result v13

    .line 474
    .local v13, "wasBlocking":Z
    invoke-virtual {v11, v0, v10}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isBlockingInteractionBelow(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)Z

    move-result v14

    .line 475
    .local v14, "isBlocking":Z
    if-eqz v14, :cond_4

    if-nez v13, :cond_4

    const/4 v15, 0x1

    goto :goto_3

    :cond_4
    move v15, v8

    :goto_3
    move v4, v15

    .line 476
    if-eqz v14, :cond_5

    if-nez v4, :cond_5

    .line 479
    goto :goto_5

    .line 431
    .end local v10    # "child":Landroid/view/View;
    .end local v11    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v12    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v13    # "wasBlocking":Z
    .end local v14    # "isBlocking":Z
    :cond_5
    :goto_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 483
    .end local v2    # "i":I
    :cond_6
    :goto_5
    invoke-interface {v6}, Ljava/util/List;->clear()V

    .line 485
    return v3

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
    .end packed-switch
.end method

.method private prepareChildren()V
    .locals 7

    .line 643
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 644
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v0}, Landroid/support/design/widget/DirectedAcyclicGraph;->clear()V

    .line 646
    const/4 v0, 0x0

    .line 646
    .local v0, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v1

    .line 646
    .local v1, "count":I
    :goto_0
    if-ge v0, v1, :cond_4

    .line 647
    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 649
    .local v2, "view":Landroid/view/View;
    invoke-virtual {p0, v2}, Landroid/support/design/widget/CoordinatorLayout;->getResolvedLayoutParams(Landroid/view/View;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-result-object v3

    .line 650
    .local v3, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v3, p0, v2}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->findAnchorView(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)Landroid/view/View;

    .line 652
    iget-object v4, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v4, v2}, Landroid/support/design/widget/DirectedAcyclicGraph;->addNode(Ljava/lang/Object;)V

    .line 655
    const/4 v4, 0x0

    .line 655
    .local v4, "j":I
    :goto_1
    if-ge v4, v1, :cond_3

    .line 656
    if-ne v4, v0, :cond_0

    .line 657
    goto :goto_2

    .line 659
    :cond_0
    invoke-virtual {p0, v4}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 660
    .local v5, "other":Landroid/view/View;
    invoke-virtual {v3, p0, v2, v5}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->dependsOn(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z

    move-result v6

    if-eqz v6, :cond_2

    .line 661
    iget-object v6, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v6, v5}, Landroid/support/design/widget/DirectedAcyclicGraph;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_1

    .line 663
    iget-object v6, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v6, v5}, Landroid/support/design/widget/DirectedAcyclicGraph;->addNode(Ljava/lang/Object;)V

    .line 666
    :cond_1
    iget-object v6, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v6, v5, v2}, Landroid/support/design/widget/DirectedAcyclicGraph;->addEdge(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 655
    .end local v5    # "other":Landroid/view/View;
    :cond_2
    :goto_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 646
    .end local v2    # "view":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v4    # "j":I
    :cond_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 672
    .end local v0    # "i":I
    .end local v1    # "count":I
    :cond_4
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v1}, Landroid/support/design/widget/DirectedAcyclicGraph;->getSortedList()Ljava/util/ArrayList;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 675
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-static {v0}, Ljava/util/Collections;->reverse(Ljava/util/List;)V

    .line 676
    return-void
.end method

.method private static releaseTempRect(Landroid/graphics/Rect;)V
    .locals 1
    .param p0, "rect"    # Landroid/graphics/Rect;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 161
    invoke-virtual {p0}, Landroid/graphics/Rect;->setEmpty()V

    .line 162
    sget-object v0, Landroid/support/design/widget/CoordinatorLayout;->sRectPool:Landroid/support/v4/util/Pools$Pool;

    invoke-interface {v0, p0}, Landroid/support/v4/util/Pools$Pool;->release(Ljava/lang/Object;)Z

    .line 163
    return-void
.end method

.method private resetTouchBehaviors()V
    .locals 11

    .line 377
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    if-eqz v0, :cond_1

    .line 378
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v0

    .line 379
    .local v0, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v0, :cond_0

    .line 380
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v9

    .line 381
    .local v9, "now":J
    const/4 v5, 0x3

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    move-wide v1, v9

    move-wide v3, v9

    invoke-static/range {v1 .. v8}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v1

    .line 383
    .local v1, "cancelEvent":Landroid/view/MotionEvent;
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    invoke-virtual {v0, p0, v2, v1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 384
    invoke-virtual {v1}, Landroid/view/MotionEvent;->recycle()V

    .line 386
    .end local v1    # "cancelEvent":Landroid/view/MotionEvent;
    .end local v9    # "now":J
    :cond_0
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    .line 389
    .end local v0    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_1
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v0

    .line 390
    .local v0, "childCount":I
    const/4 v1, 0x0

    move v2, v1

    .line 390
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_2

    .line 391
    invoke-virtual {p0, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 392
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 393
    .local v4, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v4}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->resetTouchBehaviorTracking()V

    .line 390
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 395
    .end local v2    # "i":I
    :cond_2
    iput-boolean v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mDisallowInterceptReset:Z

    .line 396
    return-void
.end method

.method private static resolveAnchoredChildGravity(I)I
    .locals 1
    .param p0, "gravity"    # I

    .line 1200
    if-nez p0, :cond_0

    const/16 v0, 0x11

    goto :goto_0

    :cond_0
    move v0, p0

    :goto_0
    return v0
.end method

.method private static resolveGravity(I)I
    .locals 1
    .param p0, "gravity"    # I

    .line 1178
    and-int/lit8 v0, p0, 0x7

    if-nez v0, :cond_0

    .line 1179
    const v0, 0x800003

    or-int/2addr p0, v0

    .line 1181
    :cond_0
    and-int/lit8 v0, p0, 0x70

    if-nez v0, :cond_1

    .line 1182
    or-int/lit8 p0, p0, 0x30

    .line 1184
    :cond_1
    return p0
.end method

.method private static resolveKeylineGravity(I)I
    .locals 1
    .param p0, "gravity"    # I

    .line 1192
    if-nez p0, :cond_0

    const v0, 0x800035

    goto :goto_0

    :cond_0
    move v0, p0

    :goto_0
    return v0
.end method

.method private setInsetOffsetX(Landroid/view/View;I)V
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "offsetX"    # I

    .line 1435
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1436
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetX:I

    if-eq v1, p2, :cond_0

    .line 1437
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetX:I

    sub-int v1, p2, v1

    .line 1438
    .local v1, "dx":I
    invoke-static {p1, v1}, Landroid/support/v4/view/ViewCompat;->offsetLeftAndRight(Landroid/view/View;I)V

    .line 1439
    iput p2, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetX:I

    .line 1441
    .end local v1    # "dx":I
    :cond_0
    return-void
.end method

.method private setInsetOffsetY(Landroid/view/View;I)V
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "offsetY"    # I

    .line 1444
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1445
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetY:I

    if-eq v1, p2, :cond_0

    .line 1446
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetY:I

    sub-int v1, p2, v1

    .line 1447
    .local v1, "dy":I
    invoke-static {p1, v1}, Landroid/support/v4/view/ViewCompat;->offsetTopAndBottom(Landroid/view/View;I)V

    .line 1448
    iput p2, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mInsetOffsetY:I

    .line 1450
    .end local v1    # "dy":I
    :cond_0
    return-void
.end method

.method private setupForInsets()V
    .locals 2

    .line 3155
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-ge v0, v1, :cond_0

    .line 3156
    return-void

    .line 3159
    :cond_0
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 3160
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mApplyWindowInsetsListener:Landroid/support/v4/view/OnApplyWindowInsetsListener;

    if-nez v0, :cond_1

    .line 3161
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$1;

    invoke-direct {v0, p0}, Landroid/support/design/widget/CoordinatorLayout$1;-><init>(Landroid/support/design/widget/CoordinatorLayout;)V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mApplyWindowInsetsListener:Landroid/support/v4/view/OnApplyWindowInsetsListener;

    .line 3171
    :cond_1
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mApplyWindowInsetsListener:Landroid/support/v4/view/OnApplyWindowInsetsListener;

    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->setOnApplyWindowInsetsListener(Landroid/view/View;Landroid/support/v4/view/OnApplyWindowInsetsListener;)V

    .line 3174
    const/16 v0, 0x500

    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->setSystemUiVisibility(I)V

    goto :goto_0

    .line 3177
    :cond_2
    const/4 v0, 0x0

    invoke-static {p0, v0}, Landroid/support/v4/view/ViewCompat;->setOnApplyWindowInsetsListener(Landroid/view/View;Landroid/support/v4/view/OnApplyWindowInsetsListener;)V

    .line 3179
    :goto_0
    return-void
.end method


# virtual methods
.method addPreDrawListener()V
    .locals 2

    .line 1554
    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mIsAttachedToWindow:Z

    if-eqz v0, :cond_1

    .line 1556
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    if-nez v0, :cond_0

    .line 1557
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-direct {v0, p0}, Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;-><init>(Landroid/support/design/widget/CoordinatorLayout;)V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    .line 1559
    :cond_0
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 1560
    .local v0, "vto":Landroid/view/ViewTreeObserver;
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 1565
    .end local v0    # "vto":Landroid/view/ViewTreeObserver;
    :cond_1
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNeedsPreDrawListener:Z

    .line 1566
    return-void
.end method

.method protected checkLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Z
    .locals 1
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1698
    instance-of v0, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

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

.method public dispatchDependentViewsChanged(Landroid/view/View;)V
    .locals 5
    .param p1, "view"    # Landroid/view/View;

    .line 1463
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v0, p1}, Landroid/support/design/widget/DirectedAcyclicGraph;->getIncomingEdges(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    .line 1464
    .local v0, "dependents":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1

    .line 1465
    const/4 v1, 0x0

    .line 1465
    .local v1, "i":I
    :goto_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 1466
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 1467
    .local v2, "child":Landroid/view/View;
    nop

    .line 1468
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1469
    .local v3, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v3}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v4

    .line 1470
    .local v4, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v4, :cond_0

    .line 1471
    invoke-virtual {v4, p0, v2, p1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onDependentViewChanged(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z

    .line 1465
    .end local v2    # "child":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v4    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1475
    .end local v1    # "i":I
    :cond_1
    return-void
.end method

.method public doViewsOverlap(Landroid/view/View;Landroid/view/View;)Z
    .locals 6
    .param p1, "first"    # Landroid/view/View;
    .param p2, "second"    # Landroid/view/View;

    .line 1660
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_3

    invoke-virtual {p2}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_3

    .line 1661
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v0

    .line 1662
    .local v0, "firstRect":Landroid/graphics/Rect;
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    const/4 v3, 0x1

    if-eq v2, p0, :cond_0

    move v2, v3

    goto :goto_0

    :cond_0
    move v2, v1

    :goto_0
    invoke-virtual {p0, p1, v2, v0}, Landroid/support/design/widget/CoordinatorLayout;->getChildRect(Landroid/view/View;ZLandroid/graphics/Rect;)V

    .line 1663
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v2

    .line 1664
    .local v2, "secondRect":Landroid/graphics/Rect;
    invoke-virtual {p2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    if-eq v4, p0, :cond_1

    move v4, v3

    goto :goto_1

    :cond_1
    move v4, v1

    :goto_1
    invoke-virtual {p0, p2, v4, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildRect(Landroid/view/View;ZLandroid/graphics/Rect;)V

    .line 1666
    :try_start_0
    iget v4, v0, Landroid/graphics/Rect;->left:I

    iget v5, v2, Landroid/graphics/Rect;->right:I

    if-gt v4, v5, :cond_2

    iget v4, v0, Landroid/graphics/Rect;->top:I

    iget v5, v2, Landroid/graphics/Rect;->bottom:I

    if-gt v4, v5, :cond_2

    iget v4, v0, Landroid/graphics/Rect;->right:I

    iget v5, v2, Landroid/graphics/Rect;->left:I

    if-lt v4, v5, :cond_2

    iget v4, v0, Landroid/graphics/Rect;->bottom:I

    iget v5, v2, Landroid/graphics/Rect;->top:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-lt v4, v5, :cond_2

    .line 1669
    move v1, v3

    goto :goto_2

    .line 1666
    :cond_2
    nop

    .line 1669
    :goto_2
    invoke-static {v0}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1670
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    return v1

    .line 1669
    :catchall_0
    move-exception v1

    invoke-static {v0}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1670
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    throw v1

    .line 1673
    .end local v0    # "firstRect":Landroid/graphics/Rect;
    .end local v2    # "secondRect":Landroid/graphics/Rect;
    :cond_3
    return v1
.end method

.method protected drawChild(Landroid/graphics/Canvas;Landroid/view/View;J)Z
    .locals 10
    .param p1, "canvas"    # Landroid/graphics/Canvas;
    .param p2, "child"    # Landroid/view/View;
    .param p3, "drawingTime"    # J

    .line 1205
    invoke-virtual {p2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1206
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mBehavior:Landroid/support/design/widget/CoordinatorLayout$Behavior;

    if-eqz v1, :cond_2

    .line 1207
    iget-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mBehavior:Landroid/support/design/widget/CoordinatorLayout$Behavior;

    invoke-virtual {v1, p0, p2}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->getScrimOpacity(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)F

    move-result v1

    .line 1208
    .local v1, "scrimAlpha":F
    const/4 v2, 0x0

    cmpl-float v2, v1, v2

    if-lez v2, :cond_2

    .line 1209
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mScrimPaint:Landroid/graphics/Paint;

    if-nez v2, :cond_0

    .line 1210
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2}, Landroid/graphics/Paint;-><init>()V

    iput-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mScrimPaint:Landroid/graphics/Paint;

    .line 1212
    :cond_0
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mScrimPaint:Landroid/graphics/Paint;

    iget-object v3, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mBehavior:Landroid/support/design/widget/CoordinatorLayout$Behavior;

    invoke-virtual {v3, p0, p2}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->getScrimColor(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 1213
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mScrimPaint:Landroid/graphics/Paint;

    const/high16 v3, 0x437f0000    # 255.0f

    mul-float/2addr v3, v1

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    const/4 v4, 0x0

    const/16 v5, 0xff

    invoke-static {v3, v4, v5}, Landroid/support/v4/math/MathUtils;->clamp(III)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 1215
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    move-result v2

    .line 1216
    .local v2, "saved":I
    invoke-virtual {p2}, Landroid/view/View;->isOpaque()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 1219
    invoke-virtual {p2}, Landroid/view/View;->getLeft()I

    move-result v3

    int-to-float v5, v3

    invoke-virtual {p2}, Landroid/view/View;->getTop()I

    move-result v3

    int-to-float v6, v3

    invoke-virtual {p2}, Landroid/view/View;->getRight()I

    move-result v3

    int-to-float v7, v3

    .line 1220
    invoke-virtual {p2}, Landroid/view/View;->getBottom()I

    move-result v3

    int-to-float v8, v3

    sget-object v9, Landroid/graphics/Region$Op;->DIFFERENCE:Landroid/graphics/Region$Op;

    .line 1219
    move-object v4, p1

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->clipRect(FFFFLandroid/graphics/Region$Op;)Z

    .line 1223
    :cond_1
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v3

    int-to-float v5, v3

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v3

    int-to-float v6, v3

    .line 1224
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v4

    sub-int/2addr v3, v4

    int-to-float v7, v3

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    int-to-float v8, v3

    iget-object v9, p0, Landroid/support/design/widget/CoordinatorLayout;->mScrimPaint:Landroid/graphics/Paint;

    .line 1223
    move-object v4, p1

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 1226
    invoke-virtual {p1, v2}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 1229
    .end local v1    # "scrimAlpha":F
    .end local v2    # "saved":I
    :cond_2
    invoke-super {p0, p1, p2, p3, p4}, Landroid/view/ViewGroup;->drawChild(Landroid/graphics/Canvas;Landroid/view/View;J)Z

    move-result v1

    return v1
.end method

.method protected drawableStateChanged()V
    .locals 4

    .line 302
    invoke-super {p0}, Landroid/view/ViewGroup;->drawableStateChanged()V

    .line 304
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getDrawableState()[I

    move-result-object v0

    .line 305
    .local v0, "state":[I
    const/4 v1, 0x0

    .line 307
    .local v1, "changed":Z
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    .line 308
    .local v2, "d":Landroid/graphics/drawable/Drawable;
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 309
    invoke-virtual {v2, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    move-result v3

    or-int/2addr v1, v3

    .line 312
    :cond_0
    if-eqz v1, :cond_1

    .line 313
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->invalidate()V

    .line 315
    :cond_1
    return-void
.end method

.method ensurePreDrawListener()V
    .locals 5

    .line 1523
    const/4 v0, 0x0

    .line 1524
    .local v0, "hasDependencies":Z
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v1

    .line 1525
    .local v1, "childCount":I
    const/4 v2, 0x0

    .line 1525
    .local v2, "i":I
    :goto_0
    if-ge v2, v1, :cond_1

    .line 1526
    invoke-virtual {p0, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 1527
    .local v3, "child":Landroid/view/View;
    invoke-direct {p0, v3}, Landroid/support/design/widget/CoordinatorLayout;->hasDependencies(Landroid/view/View;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 1528
    const/4 v0, 0x1

    .line 1529
    goto :goto_1

    .line 1525
    .end local v3    # "child":Landroid/view/View;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1533
    .end local v2    # "i":I
    :cond_1
    :goto_1
    iget-boolean v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mNeedsPreDrawListener:Z

    if-eq v0, v2, :cond_3

    .line 1534
    if-eqz v0, :cond_2

    .line 1535
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->addPreDrawListener()V

    goto :goto_2

    .line 1537
    :cond_2
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->removePreDrawListener()V

    .line 1540
    :cond_3
    :goto_2
    return-void
.end method

.method protected generateDefaultLayoutParams()Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .locals 2

    .line 1693
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    const/4 v1, -0x2

    invoke-direct {v0, v1, v1}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method protected bridge synthetic generateDefaultLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    .locals 1

    .line 110
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->generateDefaultLayoutParams()Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-result-object v0

    return-object v0
.end method

.method public generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .locals 2
    .param p1, "attrs"    # Landroid/util/AttributeSet;

    .line 1678
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-object v0
.end method

.method protected generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .locals 2
    .param p1, "p"    # Landroid/view/ViewGroup$LayoutParams;

    .line 1683
    instance-of v0, p1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    if-eqz v0, :cond_0

    .line 1684
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-object v1, p1

    check-cast v1, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    invoke-direct {v0, v1}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;-><init>(Landroid/support/design/widget/CoordinatorLayout$LayoutParams;)V

    return-object v0

    .line 1685
    :cond_0
    instance-of v0, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v0, :cond_1

    .line 1686
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-object v1, p1

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    invoke-direct {v0, v1}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;-><init>(Landroid/view/ViewGroup$MarginLayoutParams;)V

    return-object v0

    .line 1688
    :cond_1
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    invoke-direct {v0, p1}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;-><init>(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public bridge synthetic generateLayoutParams(Landroid/util/AttributeSet;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 110
    invoke-virtual {p0, p1}, Landroid/support/design/widget/CoordinatorLayout;->generateLayoutParams(Landroid/util/AttributeSet;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method protected bridge synthetic generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/view/ViewGroup$LayoutParams;
    .locals 0

    .line 110
    invoke-virtual {p0, p1}, Landroid/support/design/widget/CoordinatorLayout;->generateLayoutParams(Landroid/view/ViewGroup$LayoutParams;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-result-object p1

    return-object p1
.end method

.method getChildRect(Landroid/view/View;ZLandroid/graphics/Rect;)V
    .locals 4
    .param p1, "child"    # Landroid/view/View;
    .param p2, "transform"    # Z
    .param p3, "out"    # Landroid/graphics/Rect;

    .line 930
    invoke-virtual {p1}, Landroid/view/View;->isLayoutRequested()Z

    move-result v0

    if-nez v0, :cond_2

    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-ne v0, v1, :cond_0

    goto :goto_1

    .line 934
    :cond_0
    if-eqz p2, :cond_1

    .line 935
    invoke-virtual {p0, p1, p3}, Landroid/support/design/widget/CoordinatorLayout;->getDescendantRect(Landroid/view/View;Landroid/graphics/Rect;)V

    goto :goto_0

    .line 937
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I

    move-result v0

    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getRight()I

    move-result v2

    invoke-virtual {p1}, Landroid/view/View;->getBottom()I

    move-result v3

    invoke-virtual {p3, v0, v1, v2, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 939
    :goto_0
    return-void

    .line 931
    :cond_2
    :goto_1
    invoke-virtual {p3}, Landroid/graphics/Rect;->setEmpty()V

    .line 932
    return-void
.end method

.method public getDependencies(Landroid/view/View;)Ljava/util/List;
    .locals 2
    .param p1, "child"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            ")",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 1487
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v0, p1}, Landroid/support/design/widget/DirectedAcyclicGraph;->getOutgoingEdges(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    .line 1488
    .local v0, "dependencies":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 1489
    if-eqz v0, :cond_0

    .line 1490
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1492
    :cond_0
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    return-object v1
.end method

.method final getDependencySortedChildren()Ljava/util/List;
    .locals 1
    .annotation build Landroid/support/annotation/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 1515
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->prepareChildren()V

    .line 1516
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object v0

    return-object v0
.end method

.method public getDependents(Landroid/view/View;)Ljava/util/List;
    .locals 2
    .param p1, "child"    # Landroid/view/View;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            ")",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 1505
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mChildDag:Landroid/support/design/widget/DirectedAcyclicGraph;

    invoke-virtual {v0, p1}, Landroid/support/design/widget/DirectedAcyclicGraph;->getIncomingEdges(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    .line 1506
    .local v0, "edges":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 1507
    if-eqz v0, :cond_0

    .line 1508
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1510
    :cond_0
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mTempDependenciesList:Ljava/util/List;

    return-object v1
.end method

.method getDescendantRect(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 0
    .param p1, "descendant"    # Landroid/view/View;
    .param p2, "out"    # Landroid/graphics/Rect;

    .line 686
    invoke-static {p0, p1, p2}, Landroid/support/design/widget/ViewGroupUtils;->getDescendantRect(Landroid/view/ViewGroup;Landroid/view/View;Landroid/graphics/Rect;)V

    .line 687
    return-void
.end method

.method getDesiredAnchoredChildRect(Landroid/view/View;ILandroid/graphics/Rect;Landroid/graphics/Rect;)V
    .locals 11
    .param p1, "child"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I
    .param p3, "anchorRect"    # Landroid/graphics/Rect;
    .param p4, "out"    # Landroid/graphics/Rect;

    .line 1041
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1042
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v9

    .line 1043
    .local v9, "childWidth":I
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v10

    .line 1044
    .local v10, "childHeight":I
    move-object v1, p0

    move-object v2, p1

    move v3, p2

    move-object v4, p3

    move-object v5, p4

    move-object v6, v0

    move v7, v9

    move v8, v10

    invoke-direct/range {v1 .. v8}, Landroid/support/design/widget/CoordinatorLayout;->getDesiredAnchoredChildRectWithoutConstraints(Landroid/view/View;ILandroid/graphics/Rect;Landroid/graphics/Rect;Landroid/support/design/widget/CoordinatorLayout$LayoutParams;II)V

    .line 1046
    invoke-direct {p0, v0, p4, v9, v10}, Landroid/support/design/widget/CoordinatorLayout;->constrainChildRect(Landroid/support/design/widget/CoordinatorLayout$LayoutParams;Landroid/graphics/Rect;II)V

    .line 1047
    return-void
.end method

.method getLastChildRect(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "out"    # Landroid/graphics/Rect;

    .line 916
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 917
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getLastChildRect()Landroid/graphics/Rect;

    move-result-object v1

    invoke-virtual {p2, v1}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 918
    return-void
.end method

.method final getLastWindowInsets()Landroid/support/v4/view/WindowInsetsCompat;
    .locals 1

    .line 367
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    return-object v0
.end method

.method public getNestedScrollAxes()I
    .locals 1

    .line 1924
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingParentHelper:Landroid/support/v4/view/NestedScrollingParentHelper;

    invoke-virtual {v0}, Landroid/support/v4/view/NestedScrollingParentHelper;->getNestedScrollAxes()I

    move-result v0

    return v0
.end method

.method getResolvedLayoutParams(Landroid/view/View;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .locals 7
    .param p1, "child"    # Landroid/view/View;

    .line 620
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 621
    .local v0, "result":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget-boolean v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mBehaviorResolved:Z

    if-nez v1, :cond_2

    .line 622
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    .line 623
    .local v1, "childClass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    const/4 v2, 0x0

    .line 624
    .local v2, "defaultBehavior":Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;
    :goto_0
    if-eqz v1, :cond_0

    const-class v3, Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;

    .line 625
    invoke-virtual {v1, v3}, Ljava/lang/Class;->getAnnotation(Ljava/lang/Class;)Ljava/lang/annotation/Annotation;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;

    move-object v2, v3

    if-nez v3, :cond_0

    .line 626
    invoke-virtual {v1}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v1

    goto :goto_0

    .line 628
    :cond_0
    if-eqz v2, :cond_1

    .line 630
    nop

    .line 631
    :try_start_0
    invoke-interface {v2}, Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;->value()Ljava/lang/Class;

    move-result-object v3

    const/4 v4, 0x0

    new-array v5, v4, [Ljava/lang/Class;

    invoke-virtual {v3, v5}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    new-array v4, v4, [Ljava/lang/Object;

    invoke-virtual {v3, v4}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$Behavior;

    .line 630
    invoke-virtual {v0, v3}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->setBehavior(Landroid/support/design/widget/CoordinatorLayout$Behavior;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 635
    goto :goto_1

    .line 632
    :catch_0
    move-exception v3

    .line 633
    .local v3, "e":Ljava/lang/Exception;
    const-string v4, "CoordinatorLayout"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Default behavior class "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v2}, Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;->value()Ljava/lang/Class;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " could not be instantiated. Did you forget a default constructor?"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 637
    .end local v3    # "e":Ljava/lang/Exception;
    :cond_1
    :goto_1
    const/4 v3, 0x1

    iput-boolean v3, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mBehaviorResolved:Z

    .line 639
    .end local v1    # "childClass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    .end local v2    # "defaultBehavior":Landroid/support/design/widget/CoordinatorLayout$DefaultBehavior;
    :cond_2
    return-object v0
.end method

.method public getStatusBarBackground()Landroid/graphics/drawable/Drawable;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 297
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    return-object v0
.end method

.method protected getSuggestedMinimumHeight()I
    .locals 3

    .line 696
    invoke-super {p0}, Landroid/view/ViewGroup;->getSuggestedMinimumHeight()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v1

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v2

    add-int/2addr v1, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    return v0
.end method

.method protected getSuggestedMinimumWidth()I
    .locals 3

    .line 691
    invoke-super {p0}, Landroid/view/ViewGroup;->getSuggestedMinimumWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v1

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v2

    add-int/2addr v1, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    return v0
.end method

.method public isPointInChildBounds(Landroid/view/View;II)Z
    .locals 2
    .param p1, "child"    # Landroid/view/View;
    .param p2, "x"    # I
    .param p3, "y"    # I

    .line 1642
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v0

    .line 1643
    .local v0, "r":Landroid/graphics/Rect;
    invoke-virtual {p0, p1, v0}, Landroid/support/design/widget/CoordinatorLayout;->getDescendantRect(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1645
    :try_start_0
    invoke-virtual {v0, p2, p3}, Landroid/graphics/Rect;->contains(II)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1647
    invoke-static {v0}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    return v1

    :catchall_0
    move-exception v1

    invoke-static {v0}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    throw v1
.end method

.method offsetChildToAnchor(Landroid/view/View;I)V
    .locals 17
    .param p1, "child"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I

    move-object/from16 v8, p0

    move-object/from16 v9, p1

    .line 1591
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v10, v0

    check-cast v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1592
    .local v10, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    iget-object v0, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorView:Landroid/view/View;

    if-eqz v0, :cond_5

    .line 1593
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v11

    .line 1594
    .local v11, "anchorRect":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v12

    .line 1595
    .local v12, "childRect":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v13

    .line 1597
    .local v13, "desiredChildRect":Landroid/graphics/Rect;
    iget-object v0, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorView:Landroid/view/View;

    invoke-virtual {v8, v0, v11}, Landroid/support/design/widget/CoordinatorLayout;->getDescendantRect(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1598
    const/4 v14, 0x0

    invoke-virtual {v8, v9, v14, v12}, Landroid/support/design/widget/CoordinatorLayout;->getChildRect(Landroid/view/View;ZLandroid/graphics/Rect;)V

    .line 1600
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v15

    .line 1601
    .local v15, "childWidth":I
    invoke-virtual/range {p1 .. p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v7

    .line 1602
    .local v7, "childHeight":I
    move-object v0, v8

    move-object v1, v9

    move/from16 v2, p2

    move-object v3, v11

    move-object v4, v13

    move-object v5, v10

    move v6, v15

    move/from16 v16, v7

    .line 1602
    .end local v7    # "childHeight":I
    .local v16, "childHeight":I
    invoke-direct/range {v0 .. v7}, Landroid/support/design/widget/CoordinatorLayout;->getDesiredAnchoredChildRectWithoutConstraints(Landroid/view/View;ILandroid/graphics/Rect;Landroid/graphics/Rect;Landroid/support/design/widget/CoordinatorLayout$LayoutParams;II)V

    .line 1604
    iget v0, v13, Landroid/graphics/Rect;->left:I

    iget v1, v12, Landroid/graphics/Rect;->left:I

    if-ne v0, v1, :cond_1

    iget v0, v13, Landroid/graphics/Rect;->top:I

    iget v1, v12, Landroid/graphics/Rect;->top:I

    if-eq v0, v1, :cond_0

    goto :goto_0

    :cond_0
    goto :goto_1

    :cond_1
    :goto_0
    const/4 v14, 0x1

    :goto_1
    move v0, v14

    .line 1606
    .local v0, "changed":Z
    move/from16 v1, v16

    invoke-direct {v8, v10, v13, v15, v1}, Landroid/support/design/widget/CoordinatorLayout;->constrainChildRect(Landroid/support/design/widget/CoordinatorLayout$LayoutParams;Landroid/graphics/Rect;II)V

    .line 1608
    .end local v16    # "childHeight":I
    .local v1, "childHeight":I
    iget v2, v13, Landroid/graphics/Rect;->left:I

    iget v3, v12, Landroid/graphics/Rect;->left:I

    sub-int/2addr v2, v3

    .line 1609
    .local v2, "dx":I
    iget v3, v13, Landroid/graphics/Rect;->top:I

    iget v4, v12, Landroid/graphics/Rect;->top:I

    sub-int/2addr v3, v4

    .line 1611
    .local v3, "dy":I
    if-eqz v2, :cond_2

    .line 1612
    invoke-static {v9, v2}, Landroid/support/v4/view/ViewCompat;->offsetLeftAndRight(Landroid/view/View;I)V

    .line 1614
    :cond_2
    if-eqz v3, :cond_3

    .line 1615
    invoke-static {v9, v3}, Landroid/support/v4/view/ViewCompat;->offsetTopAndBottom(Landroid/view/View;I)V

    .line 1618
    :cond_3
    if-eqz v0, :cond_4

    .line 1620
    invoke-virtual {v10}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v4

    .line 1621
    .local v4, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v4, :cond_4

    .line 1622
    iget-object v5, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorView:Landroid/view/View;

    invoke-virtual {v4, v8, v9, v5}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onDependentViewChanged(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z

    .line 1626
    .end local v4    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_4
    invoke-static {v11}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1627
    invoke-static {v12}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1628
    invoke-static {v13}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1630
    .end local v0    # "changed":Z
    .end local v1    # "childHeight":I
    .end local v2    # "dx":I
    .end local v3    # "dy":I
    .end local v11    # "anchorRect":Landroid/graphics/Rect;
    .end local v12    # "childRect":Landroid/graphics/Rect;
    .end local v13    # "desiredChildRect":Landroid/graphics/Rect;
    .end local v15    # "childWidth":I
    :cond_5
    return-void
.end method

.method public onAttachedToWindow()V
    .locals 2

    .line 234
    invoke-super {p0}, Landroid/view/ViewGroup;->onAttachedToWindow()V

    .line 235
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 236
    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNeedsPreDrawListener:Z

    if-eqz v0, :cond_1

    .line 237
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    if-nez v0, :cond_0

    .line 238
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-direct {v0, p0}, Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;-><init>(Landroid/support/design/widget/CoordinatorLayout;)V

    iput-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    .line 240
    :cond_0
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 241
    .local v0, "vto":Landroid/view/ViewTreeObserver;
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 243
    .end local v0    # "vto":Landroid/view/ViewTreeObserver;
    :cond_1
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    if-nez v0, :cond_2

    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 246
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->requestApplyInsets(Landroid/view/View;)V

    .line 248
    :cond_2
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mIsAttachedToWindow:Z

    .line 249
    return-void
.end method

.method final onChildViewsChanged(I)V
    .locals 19
    .param p1, "type"    # I

    move-object/from16 v0, p0

    .line 1249
    move/from16 v1, p1

    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v2

    .line 1250
    .local v2, "layoutDirection":I
    iget-object v3, v0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    .line 1251
    .local v3, "childCount":I
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v4

    .line 1252
    .local v4, "inset":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v5

    .line 1253
    .local v5, "drawRect":Landroid/graphics/Rect;
    invoke-static {}, Landroid/support/design/widget/CoordinatorLayout;->acquireTempRect()Landroid/graphics/Rect;

    move-result-object v6

    .line 1255
    .local v6, "lastDrawRect":Landroid/graphics/Rect;
    const/4 v8, 0x0

    .line 1255
    .local v8, "i":I
    :goto_0
    if-ge v8, v3, :cond_f

    .line 1256
    iget-object v9, v0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v9, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/view/View;

    .line 1257
    .local v9, "child":Landroid/view/View;
    invoke-virtual {v9}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v10

    check-cast v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1258
    .local v10, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    if-nez v1, :cond_0

    invoke-virtual {v9}, Landroid/view/View;->getVisibility()I

    move-result v11

    const/16 v12, 0x8

    if-ne v11, v12, :cond_0

    .line 1260
    goto/16 :goto_7

    .line 1264
    :cond_0
    const/4 v11, 0x0

    .line 1264
    .local v11, "j":I
    :goto_1
    if-ge v11, v8, :cond_2

    .line 1265
    iget-object v12, v0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v12, v11}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/view/View;

    .line 1267
    .local v12, "checkChild":Landroid/view/View;
    iget-object v13, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorDirectChild:Landroid/view/View;

    if-ne v13, v12, :cond_1

    .line 1268
    invoke-virtual {v0, v9, v2}, Landroid/support/design/widget/CoordinatorLayout;->offsetChildToAnchor(Landroid/view/View;I)V

    .line 1264
    .end local v12    # "checkChild":Landroid/view/View;
    :cond_1
    add-int/lit8 v11, v11, 0x1

    goto :goto_1

    .line 1273
    .end local v11    # "j":I
    :cond_2
    const/4 v11, 0x1

    invoke-virtual {v0, v9, v11, v5}, Landroid/support/design/widget/CoordinatorLayout;->getChildRect(Landroid/view/View;ZLandroid/graphics/Rect;)V

    .line 1276
    iget v12, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->insetEdge:I

    if-eqz v12, :cond_7

    invoke-virtual {v5}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v12

    if-nez v12, :cond_7

    .line 1277
    iget v12, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->insetEdge:I

    invoke-static {v12, v2}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v12

    .line 1279
    .local v12, "absInsetEdge":I
    and-int/lit8 v13, v12, 0x70

    const/16 v14, 0x30

    if-eq v13, v14, :cond_4

    const/16 v14, 0x50

    if-eq v13, v14, :cond_3

    goto :goto_2

    .line 1284
    :cond_3
    iget v13, v4, Landroid/graphics/Rect;->bottom:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getHeight()I

    move-result v14

    iget v15, v5, Landroid/graphics/Rect;->top:I

    sub-int/2addr v14, v15

    invoke-static {v13, v14}, Ljava/lang/Math;->max(II)I

    move-result v13

    iput v13, v4, Landroid/graphics/Rect;->bottom:I

    goto :goto_2

    .line 1281
    :cond_4
    iget v13, v4, Landroid/graphics/Rect;->top:I

    iget v14, v5, Landroid/graphics/Rect;->bottom:I

    invoke-static {v13, v14}, Ljava/lang/Math;->max(II)I

    move-result v13

    iput v13, v4, Landroid/graphics/Rect;->top:I

    .line 1282
    nop

    .line 1287
    :goto_2
    and-int/lit8 v13, v12, 0x7

    const/4 v14, 0x3

    if-eq v13, v14, :cond_6

    const/4 v14, 0x5

    if-eq v13, v14, :cond_5

    .line 1287
    .end local v12    # "absInsetEdge":I
    goto :goto_3

    .line 1292
    .restart local v12    # "absInsetEdge":I
    :cond_5
    iget v13, v4, Landroid/graphics/Rect;->right:I

    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v14

    iget v15, v5, Landroid/graphics/Rect;->left:I

    sub-int/2addr v14, v15

    invoke-static {v13, v14}, Ljava/lang/Math;->max(II)I

    move-result v13

    iput v13, v4, Landroid/graphics/Rect;->right:I

    .line 1292
    .end local v12    # "absInsetEdge":I
    goto :goto_3

    .line 1289
    .restart local v12    # "absInsetEdge":I
    :cond_6
    iget v13, v4, Landroid/graphics/Rect;->left:I

    iget v14, v5, Landroid/graphics/Rect;->right:I

    invoke-static {v13, v14}, Ljava/lang/Math;->max(II)I

    move-result v13

    iput v13, v4, Landroid/graphics/Rect;->left:I

    .line 1290
    nop

    .line 1298
    .end local v12    # "absInsetEdge":I
    :cond_7
    :goto_3
    iget v12, v10, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->dodgeInsetEdges:I

    if-eqz v12, :cond_8

    invoke-virtual {v9}, Landroid/view/View;->getVisibility()I

    move-result v12

    if-nez v12, :cond_8

    .line 1299
    invoke-direct {v0, v9, v4, v2}, Landroid/support/design/widget/CoordinatorLayout;->offsetChildByInset(Landroid/view/View;Landroid/graphics/Rect;I)V

    .line 1302
    :cond_8
    const/4 v12, 0x2

    if-eq v1, v12, :cond_a

    .line 1304
    invoke-virtual {v0, v9, v6}, Landroid/support/design/widget/CoordinatorLayout;->getLastChildRect(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1305
    invoke-virtual {v6, v5}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_9

    .line 1306
    goto :goto_7

    .line 1308
    :cond_9
    invoke-virtual {v0, v9, v5}, Landroid/support/design/widget/CoordinatorLayout;->recordLastChildRect(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 1312
    :cond_a
    add-int/lit8 v13, v8, 0x1

    .line 1312
    .local v13, "j":I
    :goto_4
    if-ge v13, v3, :cond_e

    .line 1313
    iget-object v14, v0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v14, v13}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Landroid/view/View;

    .line 1314
    .local v14, "checkChild":Landroid/view/View;
    invoke-virtual {v14}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v15

    check-cast v15, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1315
    .local v15, "checkLp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v15}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v7

    .line 1317
    .local v7, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v7, :cond_d

    invoke-virtual {v7, v0, v14, v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->layoutDependsOn(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z

    move-result v16

    if-eqz v16, :cond_d

    .line 1318
    if-nez v1, :cond_b

    invoke-virtual {v15}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getChangedAfterNestedScroll()Z

    move-result v16

    if-eqz v16, :cond_b

    .line 1321
    invoke-virtual {v15}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->resetChangedAfterNestedScroll()V

    .line 1322
    goto :goto_6

    .line 1326
    :cond_b
    if-eq v1, v12, :cond_c

    .line 1335
    invoke-virtual {v7, v0, v14, v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onDependentViewChanged(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z

    move-result v16

    goto :goto_5

    .line 1330
    :cond_c
    invoke-virtual {v7, v0, v14, v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onDependentViewRemoved(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V

    .line 1331
    const/16 v16, 0x1

    .line 1332
    .local v16, "handled":Z
    nop

    .line 1335
    :goto_5
    move/from16 v17, v16

    .line 1339
    .end local v16    # "handled":Z
    .local v17, "handled":Z
    if-ne v1, v11, :cond_d

    .line 1342
    move/from16 v11, v17

    invoke-virtual {v15, v11}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->setChangedAfterNestedScroll(Z)V

    .line 1312
    .end local v7    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v14    # "checkChild":Landroid/view/View;
    .end local v15    # "checkLp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v17    # "handled":Z
    :cond_d
    :goto_6
    add-int/lit8 v13, v13, 0x1

    const/4 v11, 0x1

    goto :goto_4

    .line 1255
    .end local v9    # "child":Landroid/view/View;
    .end local v10    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v13    # "j":I
    :cond_e
    :goto_7
    add-int/lit8 v8, v8, 0x1

    goto/16 :goto_0

    .line 1348
    .end local v8    # "i":I
    :cond_f
    invoke-static {v4}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1349
    invoke-static {v5}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1350
    invoke-static {v6}, Landroid/support/design/widget/CoordinatorLayout;->releaseTempRect(Landroid/graphics/Rect;)V

    .line 1351
    return-void
.end method

.method public onDetachedFromWindow()V
    .locals 2

    .line 253
    invoke-super {p0}, Landroid/view/ViewGroup;->onDetachedFromWindow()V

    .line 254
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 255
    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNeedsPreDrawListener:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    if-eqz v0, :cond_0

    .line 256
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 257
    .local v0, "vto":Landroid/view/ViewTreeObserver;
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 259
    .end local v0    # "vto":Landroid/view/ViewTreeObserver;
    :cond_0
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingTarget:Landroid/view/View;

    if-eqz v0, :cond_1

    .line 260
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingTarget:Landroid/view/View;

    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->onStopNestedScroll(Landroid/view/View;)V

    .line 262
    :cond_1
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mIsAttachedToWindow:Z

    .line 263
    return-void
.end method

.method public onDraw(Landroid/graphics/Canvas;)V
    .locals 4
    .param p1, "c"    # Landroid/graphics/Canvas;

    .line 877
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onDraw(Landroid/graphics/Canvas;)V

    .line 878
    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDrawStatusBarBackground:Z

    if-eqz v0, :cond_1

    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_1

    .line 879
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v0}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetTop()I

    move-result v0

    goto :goto_0

    :cond_0
    move v0, v1

    .line 880
    .local v0, "inset":I
    :goto_0
    if-lez v0, :cond_1

    .line 881
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getWidth()I

    move-result v3

    invoke-virtual {v2, v1, v1, v3, v0}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 882
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 885
    .end local v0    # "inset":I
    :cond_1
    return-void
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 490
    const/4 v0, 0x0

    .line 492
    .local v0, "cancelEvent":Landroid/view/MotionEvent;
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    .line 495
    .local v1, "action":I
    if-nez v1, :cond_0

    .line 496
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 499
    :cond_0
    const/4 v2, 0x0

    invoke-direct {p0, p1, v2}, Landroid/support/design/widget/CoordinatorLayout;->performIntercept(Landroid/view/MotionEvent;I)Z

    move-result v2

    .line 501
    .local v2, "intercepted":Z
    if-eqz v0, :cond_1

    .line 502
    invoke-virtual {v0}, Landroid/view/MotionEvent;->recycle()V

    .line 505
    :cond_1
    const/4 v3, 0x1

    if-eq v1, v3, :cond_2

    const/4 v3, 0x3

    if-ne v1, v3, :cond_3

    .line 506
    :cond_2
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 509
    :cond_3
    return v2
.end method

.method protected onLayout(ZIIII)V
    .locals 7
    .param p1, "changed"    # Z
    .param p2, "l"    # I
    .param p3, "t"    # I
    .param p4, "r"    # I
    .param p5, "b"    # I

    .line 857
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v0

    .line 858
    .local v0, "layoutDirection":I
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    .line 859
    .local v1, "childCount":I
    const/4 v2, 0x0

    .line 859
    .local v2, "i":I
    :goto_0
    if-ge v2, v1, :cond_3

    .line 860
    iget-object v3, p0, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    .line 861
    .local v3, "child":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    const/16 v5, 0x8

    if-ne v4, v5, :cond_0

    .line 863
    goto :goto_1

    .line 866
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 867
    .local v4, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v4}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v5

    .line 869
    .local v5, "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v5, :cond_1

    invoke-virtual {v5, p0, v3, v0}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onLayoutChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;I)Z

    move-result v6

    if-nez v6, :cond_2

    .line 870
    :cond_1
    invoke-virtual {p0, v3, v0}, Landroid/support/design/widget/CoordinatorLayout;->onLayoutChild(Landroid/view/View;I)V

    .line 859
    .end local v3    # "child":Landroid/view/View;
    .end local v4    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v5    # "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_2
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 873
    .end local v2    # "i":I
    :cond_3
    return-void
.end method

.method public onLayoutChild(Landroid/view/View;I)V
    .locals 3
    .param p1, "child"    # Landroid/view/View;
    .param p2, "layoutDirection"    # I

    .line 841
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 842
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->checkAnchorChanged()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 843
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "An anchor may not be changed after CoordinatorLayout measurement begins before layout is complete."

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 846
    :cond_0
    iget-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorView:Landroid/view/View;

    if-eqz v1, :cond_1

    .line 847
    iget-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->mAnchorView:Landroid/view/View;

    invoke-direct {p0, p1, v1, p2}, Landroid/support/design/widget/CoordinatorLayout;->layoutChildWithAnchor(Landroid/view/View;Landroid/view/View;I)V

    goto :goto_0

    .line 848
    :cond_1
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->keyline:I

    if-ltz v1, :cond_2

    .line 849
    iget v1, v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->keyline:I

    invoke-direct {p0, p1, v1, p2}, Landroid/support/design/widget/CoordinatorLayout;->layoutChildWithKeyline(Landroid/view/View;II)V

    goto :goto_0

    .line 851
    :cond_2
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/CoordinatorLayout;->layoutChild(Landroid/view/View;I)V

    .line 853
    :goto_0
    return-void
.end method

.method protected onMeasure(II)V
    .locals 36
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    move-object/from16 v7, p0

    .line 720
    invoke-direct/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->prepareChildren()V

    .line 721
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->ensurePreDrawListener()V

    .line 723
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingLeft()I

    move-result v8

    .line 724
    .local v8, "paddingLeft":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingTop()I

    move-result v9

    .line 725
    .local v9, "paddingTop":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingRight()I

    move-result v10

    .line 726
    .local v10, "paddingRight":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getPaddingBottom()I

    move-result v11

    .line 727
    .local v11, "paddingBottom":I
    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v12

    .line 728
    .local v12, "layoutDirection":I
    const/4 v0, 0x1

    if-ne v12, v0, :cond_0

    move v1, v0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    move v14, v1

    .line 729
    .local v14, "isRtl":Z
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v15

    .line 730
    .local v15, "widthMode":I
    invoke-static/range {p1 .. p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v16

    .line 731
    .local v16, "widthSize":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v6

    .line 732
    .local v6, "heightMode":I
    invoke-static/range {p2 .. p2}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v17

    .line 734
    .local v17, "heightSize":I
    add-int v18, v8, v10

    .line 735
    .local v18, "widthPadding":I
    add-int v19, v9, v11

    .line 736
    .local v19, "heightPadding":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getSuggestedMinimumWidth()I

    move-result v1

    .line 737
    .local v1, "widthUsed":I
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getSuggestedMinimumHeight()I

    move-result v2

    .line 738
    .local v2, "heightUsed":I
    const/4 v3, 0x0

    .line 740
    .local v3, "childState":I
    iget-object v4, v7, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    if-eqz v4, :cond_1

    invoke-static/range {p0 .. p0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v4

    if-eqz v4, :cond_1

    goto :goto_1

    :cond_1
    const/4 v0, 0x0

    :goto_1
    move/from16 v20, v0

    .line 742
    .local v20, "applyInsets":Z
    iget-object v0, v7, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v5

    .line 743
    .local v5, "childCount":I
    move v4, v1

    const/4 v0, 0x0

    .line 743
    .end local v1    # "widthUsed":I
    .local v0, "i":I
    .local v4, "widthUsed":I
    :goto_2
    move v1, v0

    .line 743
    .end local v0    # "i":I
    .local v1, "i":I
    if-ge v1, v5, :cond_d

    .line 744
    iget-object v0, v7, Landroid/support/design/widget/CoordinatorLayout;->mDependencySortedChildren:Ljava/util/List;

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 745
    .local v0, "child":Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v13

    move/from16 v22, v1

    const/16 v1, 0x8

    .line 745
    .end local v1    # "i":I
    .local v22, "i":I
    if-ne v13, v1, :cond_2

    .line 747
    nop

    .line 743
    move/from16 v25, v5

    move/from16 v27, v6

    const/16 v24, 0x0

    goto/16 :goto_6

    .line 750
    :cond_2
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    move-object v13, v1

    check-cast v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 752
    .local v13, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    const/4 v1, 0x0

    .line 753
    .local v1, "keylineWidthUsed":I
    move/from16 v23, v1

    iget v1, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->keyline:I

    .line 753
    .end local v1    # "keylineWidthUsed":I
    .local v23, "keylineWidthUsed":I
    if-ltz v1, :cond_9

    if-eqz v15, :cond_9

    .line 754
    iget v1, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->keyline:I

    invoke-direct {v7, v1}, Landroid/support/design/widget/CoordinatorLayout;->getKeyline(I)I

    move-result v1

    .line 755
    .local v1, "keylinePos":I
    move/from16 v24, v2

    iget v2, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->gravity:I

    .line 756
    .end local v2    # "heightUsed":I
    .local v24, "heightUsed":I
    invoke-static {v2}, Landroid/support/design/widget/CoordinatorLayout;->resolveKeylineGravity(I)I

    move-result v2

    .line 755
    invoke-static {v2, v12}, Landroid/support/v4/view/GravityCompat;->getAbsoluteGravity(II)I

    move-result v2

    and-int/lit8 v2, v2, 0x7

    .line 758
    .local v2, "keylineGravity":I
    move/from16 v25, v3

    const/4 v3, 0x3

    .line 758
    .end local v3    # "childState":I
    .local v25, "childState":I
    if-ne v2, v3, :cond_3

    if-eqz v14, :cond_4

    :cond_3
    const/4 v3, 0x5

    if-ne v2, v3, :cond_5

    if-eqz v14, :cond_5

    .line 760
    :cond_4
    sub-int v3, v16, v10

    sub-int/2addr v3, v1

    move/from16 v27, v4

    const/4 v4, 0x0

    invoke-static {v4, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 767
    .end local v4    # "widthUsed":I
    .end local v23    # "keylineWidthUsed":I
    .local v3, "keylineWidthUsed":I
    .local v27, "widthUsed":I
    move/from16 v23, v3

    goto :goto_3

    .line 761
    .end local v3    # "keylineWidthUsed":I
    .end local v27    # "widthUsed":I
    .restart local v4    # "widthUsed":I
    .restart local v23    # "keylineWidthUsed":I
    :cond_5
    move/from16 v27, v4

    .line 761
    .end local v4    # "widthUsed":I
    .restart local v27    # "widthUsed":I
    if-ne v2, v3, :cond_6

    if-eqz v14, :cond_7

    :cond_6
    const/4 v3, 0x3

    if-ne v2, v3, :cond_8

    if-eqz v14, :cond_8

    .line 763
    :cond_7
    sub-int v3, v1, v8

    const/4 v4, 0x0

    invoke-static {v4, v3}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 767
    .end local v2    # "keylineGravity":I
    .end local v23    # "keylineWidthUsed":I
    .local v1, "keylineWidthUsed":I
    move/from16 v23, v1

    goto :goto_3

    .line 767
    .end local v1    # "keylineWidthUsed":I
    .restart local v23    # "keylineWidthUsed":I
    :cond_8
    const/4 v4, 0x0

    goto :goto_3

    .line 767
    .end local v24    # "heightUsed":I
    .end local v25    # "childState":I
    .end local v27    # "widthUsed":I
    .local v2, "heightUsed":I
    .local v3, "childState":I
    .restart local v4    # "widthUsed":I
    :cond_9
    move/from16 v24, v2

    move/from16 v25, v3

    move/from16 v27, v4

    const/4 v4, 0x0

    .line 767
    .end local v2    # "heightUsed":I
    .end local v3    # "childState":I
    .end local v4    # "widthUsed":I
    .restart local v24    # "heightUsed":I
    .restart local v25    # "childState":I
    .restart local v27    # "widthUsed":I
    :goto_3
    move/from16 v1, p1

    .line 768
    .local v1, "childWidthMeasureSpec":I
    move/from16 v2, p2

    .line 769
    .local v2, "childHeightMeasureSpec":I
    if-eqz v20, :cond_a

    invoke-static {v0}, Landroid/support/v4/view/ViewCompat;->getFitsSystemWindows(Landroid/view/View;)Z

    move-result v3

    if-nez v3, :cond_a

    .line 772
    iget-object v3, v7, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v3}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetLeft()I

    move-result v3

    iget-object v4, v7, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    .line 773
    invoke-virtual {v4}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetRight()I

    move-result v4

    add-int/2addr v3, v4

    .line 774
    .local v3, "horizInsets":I
    iget-object v4, v7, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-virtual {v4}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetTop()I

    move-result v4

    move-object/from16 v28, v0

    iget-object v0, v7, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    .line 775
    .end local v0    # "child":Landroid/view/View;
    .local v28, "child":Landroid/view/View;
    invoke-virtual {v0}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetBottom()I

    move-result v0

    add-int/2addr v4, v0

    .line 777
    .local v4, "vertInsets":I
    sub-int v0, v16, v3

    invoke-static {v0, v15}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v0

    .line 779
    .end local v1    # "childWidthMeasureSpec":I
    .local v0, "childWidthMeasureSpec":I
    sub-int v1, v17, v4

    invoke-static {v1, v6}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result v1

    .line 783
    .end local v2    # "childHeightMeasureSpec":I
    .end local v3    # "horizInsets":I
    .end local v4    # "vertInsets":I
    .local v1, "childHeightMeasureSpec":I
    move/from16 v21, v0

    move/from16 v26, v1

    goto :goto_4

    .line 783
    .end local v28    # "child":Landroid/view/View;
    .local v0, "child":Landroid/view/View;
    .local v1, "childWidthMeasureSpec":I
    .restart local v2    # "childHeightMeasureSpec":I
    :cond_a
    move-object/from16 v28, v0

    .line 783
    .end local v0    # "child":Landroid/view/View;
    .restart local v28    # "child":Landroid/view/View;
    move/from16 v21, v1

    move/from16 v26, v2

    .line 783
    .end local v1    # "childWidthMeasureSpec":I
    .end local v2    # "childHeightMeasureSpec":I
    .local v21, "childWidthMeasureSpec":I
    .local v26, "childHeightMeasureSpec":I
    :goto_4
    invoke-virtual {v13}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v29

    .line 784
    .local v29, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v29, :cond_b

    const/16 v30, 0x0

    move-object/from16 v4, v28

    move-object/from16 v0, v29

    .line 784
    .end local v28    # "child":Landroid/view/View;
    .local v4, "child":Landroid/view/View;
    move-object v1, v7

    move/from16 v3, v24

    move-object v2, v4

    .line 784
    .end local v24    # "heightUsed":I
    .local v3, "heightUsed":I
    move/from16 v32, v3

    move/from16 v31, v25

    move/from16 v3, v21

    .line 784
    .end local v3    # "heightUsed":I
    .end local v25    # "childState":I
    .local v31, "childState":I
    .local v32, "heightUsed":I
    move-object/from16 v33, v4

    move/from16 v34, v27

    const/16 v24, 0x0

    move/from16 v4, v23

    .line 784
    .end local v4    # "child":Landroid/view/View;
    .end local v27    # "widthUsed":I
    .local v33, "child":Landroid/view/View;
    .local v34, "widthUsed":I
    move/from16 v25, v5

    move/from16 v5, v26

    .line 784
    .end local v5    # "childCount":I
    .local v25, "childCount":I
    move/from16 v27, v6

    move/from16 v6, v30

    .line 784
    .end local v6    # "heightMode":I
    .local v27, "heightMode":I
    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onMeasureChild(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;IIII)Z

    move-result v0

    if-nez v0, :cond_c

    goto :goto_5

    .line 786
    .end local v31    # "childState":I
    .end local v32    # "heightUsed":I
    .end local v33    # "child":Landroid/view/View;
    .end local v34    # "widthUsed":I
    .restart local v5    # "childCount":I
    .restart local v6    # "heightMode":I
    .restart local v24    # "heightUsed":I
    .local v25, "childState":I
    .local v27, "widthUsed":I
    .restart local v28    # "child":Landroid/view/View;
    :cond_b
    move/from16 v32, v24

    move/from16 v31, v25

    move/from16 v34, v27

    move-object/from16 v33, v28

    const/16 v24, 0x0

    move/from16 v25, v5

    move/from16 v27, v6

    .line 786
    .end local v5    # "childCount":I
    .end local v6    # "heightMode":I
    .end local v24    # "heightUsed":I
    .end local v28    # "child":Landroid/view/View;
    .local v25, "childCount":I
    .local v27, "heightMode":I
    .restart local v31    # "childState":I
    .restart local v32    # "heightUsed":I
    .restart local v33    # "child":Landroid/view/View;
    .restart local v34    # "widthUsed":I
    :goto_5
    const/4 v5, 0x0

    move-object v0, v7

    move-object/from16 v1, v33

    move/from16 v2, v21

    move/from16 v3, v23

    move/from16 v4, v26

    invoke-virtual/range {v0 .. v5}, Landroid/support/design/widget/CoordinatorLayout;->onMeasureChild(Landroid/view/View;IIII)V

    .line 790
    :cond_c
    move-object/from16 v0, v33

    invoke-virtual {v0}, Landroid/view/View;->getMeasuredWidth()I

    move-result v1

    .line 790
    .end local v33    # "child":Landroid/view/View;
    .restart local v0    # "child":Landroid/view/View;
    add-int v1, v18, v1

    iget v2, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->leftMargin:I

    add-int/2addr v1, v2

    iget v2, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->rightMargin:I

    add-int/2addr v1, v2

    move/from16 v2, v34

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 793
    .end local v34    # "widthUsed":I
    .local v1, "widthUsed":I
    invoke-virtual {v0}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    add-int v2, v19, v2

    iget v3, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->topMargin:I

    add-int/2addr v2, v3

    iget v3, v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->bottomMargin:I

    add-int/2addr v2, v3

    move/from16 v3, v32

    invoke-static {v3, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 795
    .end local v32    # "heightUsed":I
    .local v2, "heightUsed":I
    invoke-virtual {v0}, Landroid/view/View;->getMeasuredState()I

    move-result v3

    move/from16 v4, v31

    invoke-static {v4, v3}, Landroid/view/View;->combineMeasuredStates(II)I

    move-result v0

    .line 743
    .end local v13    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v21    # "childWidthMeasureSpec":I
    .end local v23    # "keylineWidthUsed":I
    .end local v26    # "childHeightMeasureSpec":I
    .end local v29    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v31    # "childState":I
    .local v0, "childState":I
    move v3, v0

    move v4, v1

    .line 743
    .end local v0    # "childState":I
    .end local v1    # "widthUsed":I
    .local v3, "childState":I
    .local v4, "widthUsed":I
    :goto_6
    add-int/lit8 v0, v22, 0x1

    .line 743
    .end local v22    # "i":I
    .local v0, "i":I
    move/from16 v5, v25

    move/from16 v6, v27

    goto/16 :goto_2

    .line 798
    .end local v0    # "i":I
    .end local v25    # "childCount":I
    .end local v27    # "heightMode":I
    .restart local v5    # "childCount":I
    .restart local v6    # "heightMode":I
    :cond_d
    move/from16 v25, v5

    move/from16 v27, v6

    move/from16 v35, v3

    move v3, v2

    move v2, v4

    move/from16 v4, v35

    .line 798
    .end local v5    # "childCount":I
    .end local v6    # "heightMode":I
    .local v2, "widthUsed":I
    .local v3, "heightUsed":I
    .local v4, "childState":I
    .restart local v25    # "childCount":I
    .restart local v27    # "heightMode":I
    const/high16 v0, -0x1000000

    and-int/2addr v0, v4

    move/from16 v1, p1

    invoke-static {v2, v1, v0}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v0

    .line 800
    .local v0, "width":I
    shl-int/lit8 v5, v4, 0x10

    move/from16 v6, p2

    invoke-static {v3, v6, v5}, Landroid/view/View;->resolveSizeAndState(III)I

    move-result v5

    .line 802
    .local v5, "height":I
    invoke-virtual {v7, v0, v5}, Landroid/support/design/widget/CoordinatorLayout;->setMeasuredDimension(II)V

    .line 803
    return-void
.end method

.method public onMeasureChild(Landroid/view/View;IIII)V
    .locals 0
    .param p1, "child"    # Landroid/view/View;
    .param p2, "parentWidthMeasureSpec"    # I
    .param p3, "widthUsed"    # I
    .param p4, "parentHeightMeasureSpec"    # I
    .param p5, "heightUsed"    # I

    .line 714
    invoke-virtual/range {p0 .. p5}, Landroid/support/design/widget/CoordinatorLayout;->measureChildWithMargins(Landroid/view/View;IIII)V

    .line 716
    return-void
.end method

.method public onNestedFling(Landroid/view/View;FFZ)Z
    .locals 15
    .param p1, "target"    # Landroid/view/View;
    .param p2, "velocityX"    # F
    .param p3, "velocityY"    # F
    .param p4, "consumed"    # Z

    move-object v7, p0

    .line 1870
    const/4 v0, 0x0

    .line 1872
    .local v0, "handled":Z
    invoke-virtual {v7}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v8

    .line 1873
    .local v8, "childCount":I
    const/4 v9, 0x0

    move v10, v0

    move v0, v9

    .line 1873
    .local v0, "i":I
    .local v10, "handled":Z
    :goto_0
    move v11, v0

    .line 1873
    .end local v0    # "i":I
    .local v11, "i":I
    if-ge v11, v8, :cond_3

    .line 1874
    invoke-virtual {v7, v11}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v12

    .line 1875
    .local v12, "view":Landroid/view/View;
    invoke-virtual {v12}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-ne v0, v1, :cond_0

    .line 1877
    goto :goto_1

    .line 1880
    :cond_0
    invoke-virtual {v12}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v13, v0

    check-cast v13, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1881
    .local v13, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v13, v9}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1882
    goto :goto_1

    .line 1885
    :cond_1
    invoke-virtual {v13}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v14

    .line 1886
    .local v14, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v14, :cond_2

    .line 1887
    move-object v0, v14

    move-object v1, v7

    move-object v2, v12

    move-object/from16 v3, p1

    move/from16 v4, p2

    move/from16 v5, p3

    move/from16 v6, p4

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onNestedFling(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;FFZ)Z

    move-result v0

    or-int/2addr v0, v10

    .line 1873
    .end local v10    # "handled":Z
    .end local v12    # "view":Landroid/view/View;
    .end local v13    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v14    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .local v0, "handled":Z
    move v10, v0

    .line 1873
    .end local v0    # "handled":Z
    .restart local v10    # "handled":Z
    :cond_2
    :goto_1
    add-int/lit8 v0, v11, 0x1

    .line 1873
    .end local v11    # "i":I
    .local v0, "i":I
    goto :goto_0

    .line 1891
    .end local v0    # "i":I
    :cond_3
    if-eqz v10, :cond_4

    .line 1892
    const/4 v0, 0x1

    invoke-virtual {v7, v0}, Landroid/support/design/widget/CoordinatorLayout;->onChildViewsChanged(I)V

    .line 1894
    :cond_4
    return v10
.end method

.method public onNestedPreFling(Landroid/view/View;FF)Z
    .locals 14
    .param p1, "target"    # Landroid/view/View;
    .param p2, "velocityX"    # F
    .param p3, "velocityY"    # F

    .line 1899
    const/4 v0, 0x0

    .line 1901
    .local v0, "handled":Z
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v1

    .line 1902
    .local v1, "childCount":I
    const/4 v2, 0x0

    move v3, v0

    move v0, v2

    .line 1902
    .local v0, "i":I
    .local v3, "handled":Z
    :goto_0
    if-ge v0, v1, :cond_3

    .line 1903
    move-object v10, p0

    invoke-virtual {v10, v0}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v11

    .line 1904
    .local v11, "view":Landroid/view/View;
    invoke-virtual {v11}, Landroid/view/View;->getVisibility()I

    move-result v4

    const/16 v5, 0x8

    if-ne v4, v5, :cond_0

    .line 1906
    goto :goto_1

    .line 1909
    :cond_0
    invoke-virtual {v11}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    move-object v12, v4

    check-cast v12, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1910
    .local v12, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v12, v2}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v4

    if-nez v4, :cond_1

    .line 1911
    goto :goto_1

    .line 1914
    :cond_1
    invoke-virtual {v12}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v13

    .line 1915
    .local v13, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v13, :cond_2

    .line 1916
    move-object v4, v13

    move-object v5, v10

    move-object v6, v11

    move-object v7, p1

    move/from16 v8, p2

    move/from16 v9, p3

    invoke-virtual/range {v4 .. v9}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onNestedPreFling(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;FF)Z

    move-result v4

    or-int/2addr v3, v4

    .line 1902
    .end local v11    # "view":Landroid/view/View;
    .end local v12    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v13    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_2
    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1919
    .end local v0    # "i":I
    :cond_3
    move-object v10, p0

    return v3
.end method

.method public onNestedPreScroll(Landroid/view/View;II[I)V
    .locals 6
    .param p1, "target"    # Landroid/view/View;
    .param p2, "dx"    # I
    .param p3, "dy"    # I
    .param p4, "consumed"    # [I

    .line 1824
    const/4 v5, 0x0

    move-object v0, p0

    move-object v1, p1

    move v2, p2

    move v3, p3

    move-object v4, p4

    invoke-virtual/range {v0 .. v5}, Landroid/support/design/widget/CoordinatorLayout;->onNestedPreScroll(Landroid/view/View;II[II)V

    .line 1825
    return-void
.end method

.method public onNestedPreScroll(Landroid/view/View;II[II)V
    .locals 20
    .param p1, "target"    # Landroid/view/View;
    .param p2, "dx"    # I
    .param p3, "dy"    # I
    .param p4, "consumed"    # [I
    .param p5, "type"    # I

    move-object/from16 v8, p0

    .line 1829
    const/4 v0, 0x0

    .line 1830
    .local v0, "xConsumed":I
    const/4 v1, 0x0

    .line 1831
    .local v1, "yConsumed":I
    const/4 v2, 0x0

    .line 1833
    .local v2, "accepted":Z
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v9

    .line 1834
    .local v9, "childCount":I
    const/4 v10, 0x0

    move v11, v0

    move v12, v1

    move v13, v2

    move v0, v10

    .line 1834
    .end local v1    # "yConsumed":I
    .end local v2    # "accepted":Z
    .local v0, "i":I
    .local v11, "xConsumed":I
    .local v12, "yConsumed":I
    .local v13, "accepted":Z
    :goto_0
    move v14, v0

    .line 1834
    .end local v0    # "i":I
    .local v14, "i":I
    const/4 v7, 0x1

    if-ge v14, v9, :cond_5

    .line 1835
    invoke-virtual {v8, v14}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v6

    .line 1836
    .local v6, "view":Landroid/view/View;
    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-ne v0, v1, :cond_0

    .line 1838
    goto/16 :goto_3

    .line 1841
    :cond_0
    invoke-virtual {v6}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v5, v0

    check-cast v5, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1842
    .local v5, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    move/from16 v4, p5

    invoke-virtual {v5, v4}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1843
    goto :goto_3

    .line 1846
    :cond_1
    invoke-virtual {v5}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v15

    .line 1847
    .local v15, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v15, :cond_4

    .line 1848
    iget-object v0, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    iget-object v1, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    aput v10, v1, v7

    aput v10, v0, v10

    .line 1849
    iget-object v3, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    move-object v0, v15

    move-object v1, v8

    move-object v2, v6

    move-object/from16 v16, v3

    move-object/from16 v3, p1

    move/from16 v4, p2

    move-object/from16 v17, v5

    move/from16 v5, p3

    .line 1849
    .end local v5    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .local v17, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    move-object/from16 v18, v6

    move-object/from16 v6, v16

    .line 1849
    .end local v6    # "view":Landroid/view/View;
    .local v18, "view":Landroid/view/View;
    move/from16 v7, p5

    invoke-virtual/range {v0 .. v7}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onNestedPreScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;II[II)V

    .line 1851
    if-lez p2, :cond_2

    iget-object v1, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    aget v1, v1, v10

    invoke-static {v11, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    goto :goto_1

    :cond_2
    iget-object v1, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    aget v1, v1, v10

    .line 1852
    invoke-static {v11, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 1853
    .end local v11    # "xConsumed":I
    .local v1, "xConsumed":I
    :goto_1
    if-lez p3, :cond_3

    iget-object v3, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    const/4 v4, 0x1

    aget v3, v3, v4

    invoke-static {v12, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    goto :goto_2

    :cond_3
    const/4 v4, 0x1

    iget-object v3, v8, Landroid/support/design/widget/CoordinatorLayout;->mTempIntPair:[I

    aget v3, v3, v4

    .line 1854
    invoke-static {v12, v3}, Ljava/lang/Math;->min(II)I

    move-result v3

    .line 1856
    .end local v12    # "yConsumed":I
    .local v3, "yConsumed":I
    :goto_2
    const/4 v4, 0x1

    .line 1834
    .end local v13    # "accepted":Z
    .end local v15    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v17    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v18    # "view":Landroid/view/View;
    .local v4, "accepted":Z
    move v11, v1

    move v12, v3

    move v13, v4

    .line 1834
    .end local v1    # "xConsumed":I
    .end local v3    # "yConsumed":I
    .end local v4    # "accepted":Z
    .restart local v11    # "xConsumed":I
    .restart local v12    # "yConsumed":I
    .restart local v13    # "accepted":Z
    :cond_4
    :goto_3
    add-int/lit8 v1, v14, 0x1

    .line 1834
    .end local v14    # "i":I
    .local v1, "i":I
    move v0, v1

    goto :goto_0

    .line 1860
    .end local v1    # "i":I
    :cond_5
    move v4, v7

    aput v11, p4, v10

    .line 1861
    aput v12, p4, v4

    .line 1863
    if-eqz v13, :cond_6

    .line 1864
    invoke-virtual {v8, v4}, Landroid/support/design/widget/CoordinatorLayout;->onChildViewsChanged(I)V

    .line 1866
    :cond_6
    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIII)V
    .locals 7
    .param p1, "target"    # Landroid/view/View;
    .param p2, "dxConsumed"    # I
    .param p3, "dyConsumed"    # I
    .param p4, "dxUnconsumed"    # I
    .param p5, "dyUnconsumed"    # I

    .line 1787
    const/4 v6, 0x0

    move-object v0, p0

    move-object v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/CoordinatorLayout;->onNestedScroll(Landroid/view/View;IIIII)V

    .line 1789
    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIIII)V
    .locals 17
    .param p1, "target"    # Landroid/view/View;
    .param p2, "dxConsumed"    # I
    .param p3, "dyConsumed"    # I
    .param p4, "dxUnconsumed"    # I
    .param p5, "dyUnconsumed"    # I
    .param p6, "type"    # I

    move-object/from16 v9, p0

    .line 1794
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v10

    .line 1795
    .local v10, "childCount":I
    const/4 v0, 0x0

    .line 1797
    .local v0, "accepted":Z
    const/4 v1, 0x0

    move v11, v0

    .line 1797
    .end local v0    # "accepted":Z
    .local v1, "i":I
    .local v11, "accepted":Z
    :goto_0
    move v12, v1

    .line 1797
    .end local v1    # "i":I
    .local v12, "i":I
    if-ge v12, v10, :cond_3

    .line 1798
    invoke-virtual {v9, v12}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    .line 1799
    .local v13, "view":Landroid/view/View;
    invoke-virtual {v13}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-ne v0, v1, :cond_0

    .line 1801
    nop

    .line 1797
    move/from16 v15, p6

    goto :goto_1

    .line 1804
    :cond_0
    invoke-virtual {v13}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v14, v0

    check-cast v14, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1805
    .local v14, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    move/from16 v15, p6

    invoke-virtual {v14, v15}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1806
    goto :goto_1

    .line 1809
    :cond_1
    invoke-virtual {v14}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v16

    .line 1810
    .local v16, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v16, :cond_2

    .line 1811
    move-object/from16 v0, v16

    move-object v1, v9

    move-object v2, v13

    move-object/from16 v3, p1

    move/from16 v4, p2

    move/from16 v5, p3

    move/from16 v6, p4

    move/from16 v7, p5

    move v8, v15

    invoke-virtual/range {v0 .. v8}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;IIIII)V

    .line 1813
    const/4 v0, 0x1

    .line 1797
    .end local v11    # "accepted":Z
    .end local v13    # "view":Landroid/view/View;
    .end local v14    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v16    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .restart local v0    # "accepted":Z
    move v11, v0

    .line 1797
    .end local v0    # "accepted":Z
    .restart local v11    # "accepted":Z
    :cond_2
    :goto_1
    add-int/lit8 v1, v12, 0x1

    .line 1797
    .end local v12    # "i":I
    .restart local v1    # "i":I
    goto :goto_0

    .line 1817
    .end local v1    # "i":I
    :cond_3
    move/from16 v15, p6

    if-eqz v11, :cond_4

    .line 1818
    const/4 v0, 0x1

    invoke-virtual {v9, v0}, Landroid/support/design/widget/CoordinatorLayout;->onChildViewsChanged(I)V

    .line 1820
    :cond_4
    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V
    .locals 1
    .param p1, "child"    # Landroid/view/View;
    .param p2, "target"    # Landroid/view/View;
    .param p3, "nestedScrollAxes"    # I

    .line 1733
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, p3, v0}, Landroid/support/design/widget/CoordinatorLayout;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;II)V

    .line 1734
    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;II)V
    .locals 17
    .param p1, "child"    # Landroid/view/View;
    .param p2, "target"    # Landroid/view/View;
    .param p3, "nestedScrollAxes"    # I
    .param p4, "type"    # I

    move-object/from16 v7, p0

    move-object/from16 v8, p2

    .line 1738
    move/from16 v9, p4

    iget-object v0, v7, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingParentHelper:Landroid/support/v4/view/NestedScrollingParentHelper;

    move-object/from16 v10, p1

    move/from16 v11, p3

    invoke-virtual {v0, v10, v8, v11, v9}, Landroid/support/v4/view/NestedScrollingParentHelper;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;II)V

    .line 1739
    iput-object v8, v7, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingTarget:Landroid/view/View;

    .line 1741
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v12

    .line 1742
    .local v12, "childCount":I
    const/4 v0, 0x0

    .line 1742
    .local v0, "i":I
    :goto_0
    move v13, v0

    .line 1742
    .end local v0    # "i":I
    .local v13, "i":I
    if-ge v13, v12, :cond_2

    .line 1743
    invoke-virtual {v7, v13}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v14

    .line 1744
    .local v14, "view":Landroid/view/View;
    invoke-virtual {v14}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v15, v0

    check-cast v15, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1745
    .local v15, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v15, v9}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1746
    goto :goto_1

    .line 1749
    :cond_0
    invoke-virtual {v15}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v16

    .line 1750
    .local v16, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v16, :cond_1

    .line 1751
    move-object/from16 v0, v16

    move-object v1, v7

    move-object v2, v14

    move-object v3, v10

    move-object v4, v8

    move v5, v11

    move v6, v9

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onNestedScrollAccepted(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;Landroid/view/View;II)V

    .line 1742
    .end local v14    # "view":Landroid/view/View;
    .end local v15    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v16    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_1
    :goto_1
    add-int/lit8 v0, v13, 0x1

    .line 1742
    .end local v13    # "i":I
    .restart local v0    # "i":I
    goto :goto_0

    .line 1755
    .end local v0    # "i":I
    :cond_2
    return-void
.end method

.method protected onRestoreInstanceState(Landroid/os/Parcelable;)V
    .locals 9
    .param p1, "state"    # Landroid/os/Parcelable;

    .line 3093
    instance-of v0, p1, Landroid/support/design/widget/CoordinatorLayout$SavedState;

    if-nez v0, :cond_0

    .line 3094
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    .line 3095
    return-void

    .line 3098
    :cond_0
    move-object v0, p1

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$SavedState;

    .line 3099
    .local v0, "ss":Landroid/support/design/widget/CoordinatorLayout$SavedState;
    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$SavedState;->getSuperState()Landroid/os/Parcelable;

    move-result-object v1

    invoke-super {p0, v1}, Landroid/view/ViewGroup;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    .line 3101
    iget-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$SavedState;->behaviorStates:Landroid/util/SparseArray;

    .line 3103
    .local v1, "behaviorStates":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/os/Parcelable;>;"
    const/4 v2, 0x0

    .line 3103
    .local v2, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v3

    .line 3103
    .local v3, "count":I
    :goto_0
    if-ge v2, v3, :cond_2

    .line 3104
    invoke-virtual {p0, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 3105
    .local v4, "child":Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getId()I

    move-result v5

    .line 3106
    .local v5, "childId":I
    invoke-virtual {p0, v4}, Landroid/support/design/widget/CoordinatorLayout;->getResolvedLayoutParams(Landroid/view/View;)Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    move-result-object v6

    .line 3107
    .local v6, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v6}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v7

    .line 3109
    .local v7, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    const/4 v8, -0x1

    if-eq v5, v8, :cond_1

    if-eqz v7, :cond_1

    .line 3110
    invoke-virtual {v1, v5}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/os/Parcelable;

    .line 3111
    .local v8, "savedState":Landroid/os/Parcelable;
    if-eqz v8, :cond_1

    .line 3112
    invoke-virtual {v7, p0, v4, v8}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onRestoreInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/os/Parcelable;)V

    .line 3103
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "childId":I
    .end local v6    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v7    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v8    # "savedState":Landroid/os/Parcelable;
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 3116
    .end local v2    # "i":I
    .end local v3    # "count":I
    :cond_2
    return-void
.end method

.method protected onSaveInstanceState()Landroid/os/Parcelable;
    .locals 9

    .line 3120
    new-instance v0, Landroid/support/design/widget/CoordinatorLayout$SavedState;

    invoke-super {p0}, Landroid/view/ViewGroup;->onSaveInstanceState()Landroid/os/Parcelable;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/support/design/widget/CoordinatorLayout$SavedState;-><init>(Landroid/os/Parcelable;)V

    .line 3122
    .local v0, "ss":Landroid/support/design/widget/CoordinatorLayout$SavedState;
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    .line 3123
    .local v1, "behaviorStates":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/os/Parcelable;>;"
    const/4 v2, 0x0

    .line 3123
    .local v2, "i":I
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v3

    .line 3123
    .local v3, "count":I
    :goto_0
    if-ge v2, v3, :cond_1

    .line 3124
    invoke-virtual {p0, v2}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 3125
    .local v4, "child":Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getId()I

    move-result v5

    .line 3126
    .local v5, "childId":I
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 3127
    .local v6, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v6}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v7

    .line 3129
    .local v7, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    const/4 v8, -0x1

    if-eq v5, v8, :cond_0

    if-eqz v7, :cond_0

    .line 3131
    invoke-virtual {v7, p0, v4}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onSaveInstanceState(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;)Landroid/os/Parcelable;

    move-result-object v8

    .line 3132
    .local v8, "state":Landroid/os/Parcelable;
    if-eqz v8, :cond_0

    .line 3133
    invoke-virtual {v1, v5, v8}, Landroid/util/SparseArray;->append(ILjava/lang/Object;)V

    .line 3123
    .end local v4    # "child":Landroid/view/View;
    .end local v5    # "childId":I
    .end local v6    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v7    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    .end local v8    # "state":Landroid/os/Parcelable;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 3137
    .end local v2    # "i":I
    .end local v3    # "count":I
    :cond_1
    iput-object v1, v0, Landroid/support/design/widget/CoordinatorLayout$SavedState;->behaviorStates:Landroid/util/SparseArray;

    .line 3138
    return-object v0
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;I)Z
    .locals 1
    .param p1, "child"    # Landroid/view/View;
    .param p2, "target"    # Landroid/view/View;
    .param p3, "nestedScrollAxes"    # I

    .line 1703
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, p3, v0}, Landroid/support/design/widget/CoordinatorLayout;->onStartNestedScroll(Landroid/view/View;Landroid/view/View;II)Z

    move-result v0

    return v0
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;II)Z
    .locals 16
    .param p1, "child"    # Landroid/view/View;
    .param p2, "target"    # Landroid/view/View;
    .param p3, "axes"    # I
    .param p4, "type"    # I

    .line 1708
    move/from16 v7, p4

    const/4 v0, 0x0

    .line 1710
    .local v0, "handled":Z
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v8

    .line 1711
    .local v8, "childCount":I
    const/4 v9, 0x0

    move v10, v0

    move v0, v9

    .line 1711
    .local v0, "i":I
    .local v10, "handled":Z
    :goto_0
    move v11, v0

    .line 1711
    .end local v0    # "i":I
    .local v11, "i":I
    if-ge v11, v8, :cond_2

    .line 1712
    move-object/from16 v12, p0

    invoke-virtual {v12, v11}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    .line 1713
    .local v13, "view":Landroid/view/View;
    invoke-virtual {v13}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-ne v0, v1, :cond_0

    .line 1715
    goto :goto_1

    .line 1717
    :cond_0
    invoke-virtual {v13}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    move-object v14, v0

    check-cast v14, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1718
    .local v14, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v14}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v15

    .line 1719
    .local v15, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v15, :cond_1

    .line 1720
    move-object v0, v15

    move-object v1, v12

    move-object v2, v13

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move/from16 v5, p3

    move v6, v7

    invoke-virtual/range {v0 .. v6}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onStartNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;Landroid/view/View;II)Z

    move-result v0

    .line 1722
    .local v0, "accepted":Z
    or-int v1, v10, v0

    .line 1723
    .end local v10    # "handled":Z
    .local v1, "handled":Z
    invoke-virtual {v14, v7, v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->setNestedScrollAccepted(IZ)V

    .line 1724
    .end local v0    # "accepted":Z
    nop

    .line 1711
    move v10, v1

    goto :goto_1

    .line 1725
    .end local v1    # "handled":Z
    .restart local v10    # "handled":Z
    :cond_1
    invoke-virtual {v14, v7, v9}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->setNestedScrollAccepted(IZ)V

    .line 1711
    .end local v13    # "view":Landroid/view/View;
    .end local v14    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v15    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :goto_1
    add-int/lit8 v0, v11, 0x1

    .line 1711
    .end local v11    # "i":I
    .local v0, "i":I
    goto :goto_0

    .line 1728
    .end local v0    # "i":I
    :cond_2
    move-object/from16 v12, p0

    return v10
.end method

.method public onStopNestedScroll(Landroid/view/View;)V
    .locals 1
    .param p1, "target"    # Landroid/view/View;

    .line 1759
    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/support/design/widget/CoordinatorLayout;->onStopNestedScroll(Landroid/view/View;I)V

    .line 1760
    return-void
.end method

.method public onStopNestedScroll(Landroid/view/View;I)V
    .locals 5
    .param p1, "target"    # Landroid/view/View;
    .param p2, "type"    # I

    .line 1764
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingParentHelper:Landroid/support/v4/view/NestedScrollingParentHelper;

    invoke-virtual {v0, p1, p2}, Landroid/support/v4/view/NestedScrollingParentHelper;->onStopNestedScroll(Landroid/view/View;I)V

    .line 1766
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getChildCount()I

    move-result v0

    .line 1767
    .local v0, "childCount":I
    const/4 v1, 0x0

    .line 1767
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_2

    .line 1768
    invoke-virtual {p0, v1}, Landroid/support/design/widget/CoordinatorLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 1769
    .local v2, "view":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 1770
    .local v3, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v3, p2}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->isNestedScrollAccepted(I)Z

    move-result v4

    if-nez v4, :cond_0

    .line 1771
    goto :goto_1

    .line 1774
    :cond_0
    invoke-virtual {v3}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v4

    .line 1775
    .local v4, "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v4, :cond_1

    .line 1776
    invoke-virtual {v4, p0, v2, p1, p2}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onStopNestedScroll(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;I)V

    .line 1778
    :cond_1
    invoke-virtual {v3, p2}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->resetNestedScroll(I)V

    .line 1779
    invoke-virtual {v3}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->resetChangedAfterNestedScroll()V

    .line 1767
    .end local v2    # "view":Landroid/view/View;
    .end local v3    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v4    # "viewBehavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1781
    .end local v1    # "i":I
    :cond_2
    const/4 v1, 0x0

    iput-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mNestedScrollingTarget:Landroid/view/View;

    .line 1782
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 18
    .param p1, "ev"    # Landroid/view/MotionEvent;

    move-object/from16 v0, p0

    .line 514
    move-object/from16 v1, p1

    const/4 v2, 0x0

    .line 515
    .local v2, "handled":Z
    const/4 v3, 0x0

    .line 516
    .local v3, "cancelSuper":Z
    const/4 v4, 0x0

    .line 518
    .local v4, "cancelEvent":Landroid/view/MotionEvent;
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v5

    .line 520
    .local v5, "action":I
    iget-object v6, v0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    const/4 v7, 0x1

    if-nez v6, :cond_0

    invoke-direct {v0, v1, v7}, Landroid/support/design/widget/CoordinatorLayout;->performIntercept(Landroid/view/MotionEvent;I)Z

    move-result v6

    move v3, v6

    if-eqz v6, :cond_1

    .line 523
    :cond_0
    iget-object v6, v0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    invoke-virtual {v6}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    check-cast v6, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 524
    .local v6, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v6}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v8

    .line 525
    .local v8, "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v8, :cond_1

    .line 526
    iget-object v9, v0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    invoke-virtual {v8, v0, v9, v1}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onTouchEvent(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v2

    .line 531
    .end local v6    # "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    .end local v8    # "b":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    :cond_1
    iget-object v6, v0, Landroid/support/design/widget/CoordinatorLayout;->mBehaviorTouchView:Landroid/view/View;

    if-nez v6, :cond_2

    .line 532
    invoke-super/range {p0 .. p1}, Landroid/view/ViewGroup;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v6

    or-int/2addr v2, v6

    goto :goto_0

    .line 533
    :cond_2
    if-eqz v3, :cond_4

    .line 534
    if-nez v4, :cond_3

    .line 535
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v16

    .line 536
    .local v16, "now":J
    const/4 v12, 0x3

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    move-wide/from16 v8, v16

    move-wide/from16 v10, v16

    invoke-static/range {v8 .. v15}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v4

    .line 539
    .end local v16    # "now":J
    :cond_3
    invoke-super {v0, v4}, Landroid/view/ViewGroup;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 542
    :cond_4
    :goto_0
    nop

    .line 546
    if-eqz v4, :cond_5

    .line 547
    invoke-virtual {v4}, Landroid/view/MotionEvent;->recycle()V

    .line 550
    :cond_5
    if-eq v5, v7, :cond_6

    const/4 v6, 0x3

    if-ne v5, v6, :cond_7

    .line 551
    :cond_6
    invoke-direct/range {p0 .. p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 554
    :cond_7
    return v2
.end method

.method recordLastChildRect(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 1
    .param p1, "child"    # Landroid/view/View;
    .param p2, "r"    # Landroid/graphics/Rect;

    .line 904
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 905
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v0, p2}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->setLastChildRect(Landroid/graphics/Rect;)V

    .line 906
    return-void
.end method

.method removePreDrawListener()V
    .locals 2

    .line 1573
    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mIsAttachedToWindow:Z

    if-eqz v0, :cond_0

    .line 1574
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    if-eqz v0, :cond_0

    .line 1575
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 1576
    .local v0, "vto":Landroid/view/ViewTreeObserver;
    iget-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnPreDrawListener:Landroid/support/design/widget/CoordinatorLayout$OnPreDrawListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 1579
    .end local v0    # "vto":Landroid/view/ViewTreeObserver;
    :cond_0
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mNeedsPreDrawListener:Z

    .line 1580
    return-void
.end method

.method public requestChildRectangleOnScreen(Landroid/view/View;Landroid/graphics/Rect;Z)Z
    .locals 3
    .param p1, "child"    # Landroid/view/View;
    .param p2, "rectangle"    # Landroid/graphics/Rect;
    .param p3, "immediate"    # Z

    .line 3143
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;

    .line 3144
    .local v0, "lp":Landroid/support/design/widget/CoordinatorLayout$LayoutParams;
    invoke-virtual {v0}, Landroid/support/design/widget/CoordinatorLayout$LayoutParams;->getBehavior()Landroid/support/design/widget/CoordinatorLayout$Behavior;

    move-result-object v1

    .line 3146
    .local v1, "behavior":Landroid/support/design/widget/CoordinatorLayout$Behavior;
    if-eqz v1, :cond_0

    .line 3147
    invoke-virtual {v1, p0, p1, p2, p3}, Landroid/support/design/widget/CoordinatorLayout$Behavior;->onRequestChildRectangleOnScreen(Landroid/support/design/widget/CoordinatorLayout;Landroid/view/View;Landroid/graphics/Rect;Z)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 3148
    const/4 v2, 0x1

    return v2

    .line 3151
    :cond_0
    invoke-super {p0, p1, p2, p3}, Landroid/view/ViewGroup;->requestChildRectangleOnScreen(Landroid/view/View;Landroid/graphics/Rect;Z)Z

    move-result v2

    return v2
.end method

.method public requestDisallowInterceptTouchEvent(Z)V
    .locals 1
    .param p1, "disallowIntercept"    # Z

    .line 559
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    .line 560
    if-eqz p1, :cond_0

    iget-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDisallowInterceptReset:Z

    if-nez v0, :cond_0

    .line 561
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->resetTouchBehaviors()V

    .line 562
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mDisallowInterceptReset:Z

    .line 564
    :cond_0
    return-void
.end method

.method public setFitsSystemWindows(Z)V
    .locals 0
    .param p1, "fitSystemWindows"    # Z

    .line 889
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->setFitsSystemWindows(Z)V

    .line 890
    invoke-direct {p0}, Landroid/support/design/widget/CoordinatorLayout;->setupForInsets()V

    .line 891
    return-void
.end method

.method public setOnHierarchyChangeListener(Landroid/view/ViewGroup$OnHierarchyChangeListener;)V
    .locals 0
    .param p1, "onHierarchyChangeListener"    # Landroid/view/ViewGroup$OnHierarchyChangeListener;

    .line 229
    iput-object p1, p0, Landroid/support/design/widget/CoordinatorLayout;->mOnHierarchyChangeListener:Landroid/view/ViewGroup$OnHierarchyChangeListener;

    .line 230
    return-void
.end method

.method public setStatusBarBackground(Landroid/graphics/drawable/Drawable;)V
    .locals 3
    .param p1, "bg"    # Landroid/graphics/drawable/Drawable;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 272
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    if-eq v0, p1, :cond_5

    .line 273
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 274
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 276
    :cond_0
    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    nop

    :cond_1
    iput-object v1, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    .line 277
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_4

    .line 278
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 279
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getDrawableState()[I

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    .line 281
    :cond_2
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    .line 282
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->getLayoutDirection(Landroid/view/View;)I

    move-result v1

    .line 281
    invoke-static {v0, v1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setLayoutDirection(Landroid/graphics/drawable/Drawable;I)Z

    .line 283
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getVisibility()I

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_3

    const/4 v1, 0x1

    goto :goto_0

    :cond_3
    move v1, v2

    :goto_0
    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/Drawable;->setVisible(ZZ)Z

    .line 284
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 286
    :cond_4
    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->postInvalidateOnAnimation(Landroid/view/View;)V

    .line 288
    :cond_5
    return-void
.end method

.method public setStatusBarBackgroundColor(I)V
    .locals 1
    .param p1, "color"    # I
        .annotation build Landroid/support/annotation/ColorInt;
        .end annotation
    .end param

    .line 350
    new-instance v0, Landroid/graphics/drawable/ColorDrawable;

    invoke-direct {v0, p1}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->setStatusBarBackground(Landroid/graphics/drawable/Drawable;)V

    .line 351
    return-void
.end method

.method public setStatusBarBackgroundResource(I)V
    .locals 1
    .param p1, "resId"    # I
        .annotation build Landroid/support/annotation/DrawableRes;
        .end annotation
    .end param

    .line 339
    if-eqz p1, :cond_0

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Landroid/support/v4/content/ContextCompat;->getDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->setStatusBarBackground(Landroid/graphics/drawable/Drawable;)V

    .line 340
    return-void
.end method

.method public setVisibility(I)V
    .locals 3
    .param p1, "visibility"    # I

    .line 324
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 326
    const/4 v0, 0x0

    if-nez p1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    move v1, v0

    .line 327
    .local v1, "visible":Z
    :goto_0
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    if-eqz v2, :cond_1

    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->isVisible()Z

    move-result v2

    if-eq v2, v1, :cond_1

    .line 328
    iget-object v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v2, v1, v0}, Landroid/graphics/drawable/Drawable;->setVisible(ZZ)Z

    .line 330
    :cond_1
    return-void
.end method

.method final setWindowInsets(Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;
    .locals 3
    .param p1, "insets"    # Landroid/support/v4/view/WindowInsetsCompat;

    .line 354
    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    invoke-static {v0, p1}, Landroid/support/v4/util/ObjectsCompat;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 355
    iput-object p1, p0, Landroid/support/design/widget/CoordinatorLayout;->mLastInsets:Landroid/support/v4/view/WindowInsetsCompat;

    .line 356
    const/4 v0, 0x0

    const/4 v1, 0x1

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/support/v4/view/WindowInsetsCompat;->getSystemWindowInsetTop()I

    move-result v2

    if-lez v2, :cond_0

    move v2, v1

    goto :goto_0

    :cond_0
    move v2, v0

    :goto_0
    iput-boolean v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mDrawStatusBarBackground:Z

    .line 357
    iget-boolean v2, p0, Landroid/support/design/widget/CoordinatorLayout;->mDrawStatusBarBackground:Z

    if-nez v2, :cond_1

    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    if-nez v2, :cond_1

    move v0, v1

    nop

    :cond_1
    invoke-virtual {p0, v0}, Landroid/support/design/widget/CoordinatorLayout;->setWillNotDraw(Z)V

    .line 360
    invoke-direct {p0, p1}, Landroid/support/design/widget/CoordinatorLayout;->dispatchApplyWindowInsetsToBehaviors(Landroid/support/v4/view/WindowInsetsCompat;)Landroid/support/v4/view/WindowInsetsCompat;

    move-result-object p1

    .line 361
    invoke-virtual {p0}, Landroid/support/design/widget/CoordinatorLayout;->requestLayout()V

    .line 363
    :cond_2
    return-object p1
.end method

.method protected verifyDrawable(Landroid/graphics/drawable/Drawable;)Z
    .locals 1
    .param p1, "who"    # Landroid/graphics/drawable/Drawable;

    .line 319
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->verifyDrawable(Landroid/graphics/drawable/Drawable;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Landroid/support/design/widget/CoordinatorLayout;->mStatusBarBackground:Landroid/graphics/drawable/Drawable;

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
