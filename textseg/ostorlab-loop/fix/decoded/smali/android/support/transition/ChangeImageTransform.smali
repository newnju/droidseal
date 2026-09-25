.class public Landroid/support/transition/ChangeImageTransform;
.super Landroid/support/transition/Transition;
.source "ChangeImageTransform.java"


# static fields
.field private static final ANIMATED_TRANSFORM_PROPERTY:Landroid/util/Property;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Property<",
            "Landroid/widget/ImageView;",
            "Landroid/graphics/Matrix;",
            ">;"
        }
    .end annotation
.end field

.field private static final NULL_MATRIX_EVALUATOR:Landroid/animation/TypeEvaluator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/animation/TypeEvaluator<",
            "Landroid/graphics/Matrix;",
            ">;"
        }
    .end annotation
.end field

.field private static final PROPNAME_BOUNDS:Ljava/lang/String; = "android:changeImageTransform:bounds"

.field private static final PROPNAME_MATRIX:Ljava/lang/String; = "android:changeImageTransform:matrix"

.field private static final sTransitionProperties:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 48
    const-string v0, "android:changeImageTransform:matrix"

    const-string v1, "android:changeImageTransform:bounds"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Landroid/support/transition/ChangeImageTransform;->sTransitionProperties:[Ljava/lang/String;

    .line 53
    new-instance v0, Landroid/support/transition/ChangeImageTransform$1;

    invoke-direct {v0}, Landroid/support/transition/ChangeImageTransform$1;-><init>()V

    sput-object v0, Landroid/support/transition/ChangeImageTransform;->NULL_MATRIX_EVALUATOR:Landroid/animation/TypeEvaluator;

    .line 60
    new-instance v0, Landroid/support/transition/ChangeImageTransform$2;

    const-class v1, Landroid/graphics/Matrix;

    const-string v2, "animatedTransform"

    invoke-direct {v0, v1, v2}, Landroid/support/transition/ChangeImageTransform$2;-><init>(Ljava/lang/Class;Ljava/lang/String;)V

    sput-object v0, Landroid/support/transition/ChangeImageTransform;->ANIMATED_TRANSFORM_PROPERTY:Landroid/util/Property;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 73
    invoke-direct {p0}, Landroid/support/transition/Transition;-><init>()V

    .line 74
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 77
    invoke-direct {p0, p1, p2}, Landroid/support/transition/Transition;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 78
    return-void
.end method

.method private captureValues(Landroid/support/transition/TransitionValues;)V
    .locals 11
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;

    .line 81
    iget-object v0, p1, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    .line 82
    .local v0, "view":Landroid/view/View;
    instance-of v1, v0, Landroid/widget/ImageView;

    if-eqz v1, :cond_2

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 85
    :cond_0
    move-object v1, v0

    check-cast v1, Landroid/widget/ImageView;

    .line 86
    .local v1, "imageView":Landroid/widget/ImageView;
    invoke-virtual {v1}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    .line 87
    .local v2, "drawable":Landroid/graphics/drawable/Drawable;
    if-nez v2, :cond_1

    .line 88
    return-void

    .line 90
    :cond_1
    iget-object v3, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    .line 92
    .local v3, "values":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/Object;>;"
    invoke-virtual {v0}, Landroid/view/View;->getLeft()I

    move-result v4

    .line 93
    .local v4, "left":I
    invoke-virtual {v0}, Landroid/view/View;->getTop()I

    move-result v5

    .line 94
    .local v5, "top":I
    invoke-virtual {v0}, Landroid/view/View;->getRight()I

    move-result v6

    .line 95
    .local v6, "right":I
    invoke-virtual {v0}, Landroid/view/View;->getBottom()I

    move-result v7

    .line 97
    .local v7, "bottom":I
    new-instance v8, Landroid/graphics/Rect;

    invoke-direct {v8, v4, v5, v6, v7}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 98
    .local v8, "bounds":Landroid/graphics/Rect;
    const-string v9, "android:changeImageTransform:bounds"

    invoke-interface {v3, v9, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 99
    const-string v9, "android:changeImageTransform:matrix"

    invoke-static {v1}, Landroid/support/transition/ChangeImageTransform;->copyImageMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object v10

    invoke-interface {v3, v9, v10}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 100
    return-void

    .line 83
    .end local v1    # "imageView":Landroid/widget/ImageView;
    .end local v2    # "drawable":Landroid/graphics/drawable/Drawable;
    .end local v3    # "values":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/Object;>;"
    .end local v4    # "left":I
    .end local v5    # "top":I
    .end local v6    # "right":I
    .end local v7    # "bottom":I
    .end local v8    # "bounds":Landroid/graphics/Rect;
    :cond_2
    :goto_0
    return-void
.end method

.method private static centerCropMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;
    .locals 15
    .param p0, "view"    # Landroid/widget/ImageView;

    .line 215
    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    .line 216
    .local v0, "image":Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v1

    .line 217
    .local v1, "imageWidth":I
    invoke-virtual {p0}, Landroid/widget/ImageView;->getWidth()I

    move-result v2

    .line 218
    .local v2, "imageViewWidth":I
    int-to-float v3, v2

    int-to-float v4, v1

    div-float/2addr v3, v4

    .line 220
    .local v3, "scaleX":F
    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v4

    .line 221
    .local v4, "imageHeight":I
    invoke-virtual {p0}, Landroid/widget/ImageView;->getHeight()I

    move-result v5

    .line 222
    .local v5, "imageViewHeight":I
    int-to-float v6, v5

    int-to-float v7, v4

    div-float/2addr v6, v7

    .line 224
    .local v6, "scaleY":F
    invoke-static {v3, v6}, Ljava/lang/Math;->max(FF)F

    move-result v7

    .line 226
    .local v7, "maxScale":F
    int-to-float v8, v1

    mul-float/2addr v8, v7

    .line 227
    .local v8, "width":F
    int-to-float v9, v4

    mul-float/2addr v9, v7

    .line 228
    .local v9, "height":F
    int-to-float v10, v2

    sub-float/2addr v10, v8

    const/high16 v11, 0x40000000    # 2.0f

    div-float/2addr v10, v11

    invoke-static {v10}, Ljava/lang/Math;->round(F)I

    move-result v10

    .line 229
    .local v10, "tx":I
    int-to-float v12, v5

    sub-float/2addr v12, v9

    div-float/2addr v12, v11

    invoke-static {v12}, Ljava/lang/Math;->round(F)I

    move-result v11

    .line 231
    .local v11, "ty":I
    new-instance v12, Landroid/graphics/Matrix;

    invoke-direct {v12}, Landroid/graphics/Matrix;-><init>()V

    .line 232
    .local v12, "matrix":Landroid/graphics/Matrix;
    invoke-virtual {v12, v7, v7}, Landroid/graphics/Matrix;->postScale(FF)Z

    .line 233
    int-to-float v13, v10

    int-to-float v14, v11

    invoke-virtual {v12, v13, v14}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    .line 234
    return-object v12
.end method

.method private static copyImageMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;
    .locals 2
    .param p0, "view"    # Landroid/widget/ImageView;

    .line 187
    sget-object v0, Landroid/support/transition/ChangeImageTransform$3;->$SwitchMap$android$widget$ImageView$ScaleType:[I

    invoke-virtual {p0}, Landroid/widget/ImageView;->getScaleType()Landroid/widget/ImageView$ScaleType;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/ImageView$ScaleType;->ordinal()I

    move-result v1

    aget v0, v0, v1

    packed-switch v0, :pswitch_data_0

    .line 193
    new-instance v0, Landroid/graphics/Matrix;

    invoke-virtual {p0}, Landroid/widget/ImageView;->getImageMatrix()Landroid/graphics/Matrix;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/graphics/Matrix;-><init>(Landroid/graphics/Matrix;)V

    return-object v0

    .line 191
    :pswitch_0
    invoke-static {p0}, Landroid/support/transition/ChangeImageTransform;->centerCropMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object v0

    return-object v0

    .line 189
    :pswitch_1
    invoke-static {p0}, Landroid/support/transition/ChangeImageTransform;->fitXYMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object v0

    return-object v0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private createMatrixAnimator(Landroid/widget/ImageView;Landroid/graphics/Matrix;Landroid/graphics/Matrix;)Landroid/animation/ObjectAnimator;
    .locals 4
    .param p1, "imageView"    # Landroid/widget/ImageView;
    .param p2, "startMatrix"    # Landroid/graphics/Matrix;
    .param p3, "endMatrix"    # Landroid/graphics/Matrix;

    .line 182
    sget-object v0, Landroid/support/transition/ChangeImageTransform;->ANIMATED_TRANSFORM_PROPERTY:Landroid/util/Property;

    new-instance v1, Landroid/support/transition/TransitionUtils$MatrixEvaluator;

    invoke-direct {v1}, Landroid/support/transition/TransitionUtils$MatrixEvaluator;-><init>()V

    const/4 v2, 0x2

    new-array v2, v2, [Landroid/graphics/Matrix;

    const/4 v3, 0x0

    aput-object p2, v2, v3

    const/4 v3, 0x1

    aput-object p3, v2, v3

    invoke-static {p1, v0, v1, v2}, Landroid/animation/ObjectAnimator;->ofObject(Ljava/lang/Object;Landroid/util/Property;Landroid/animation/TypeEvaluator;[Ljava/lang/Object;)Landroid/animation/ObjectAnimator;

    move-result-object v0

    return-object v0
.end method

.method private createNullAnimator(Landroid/widget/ImageView;)Landroid/animation/ObjectAnimator;
    .locals 5
    .param p1, "imageView"    # Landroid/widget/ImageView;

    .line 176
    sget-object v0, Landroid/support/transition/ChangeImageTransform;->ANIMATED_TRANSFORM_PROPERTY:Landroid/util/Property;

    sget-object v1, Landroid/support/transition/ChangeImageTransform;->NULL_MATRIX_EVALUATOR:Landroid/animation/TypeEvaluator;

    const/4 v2, 0x2

    new-array v2, v2, [Landroid/graphics/Matrix;

    const/4 v3, 0x0

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const/4 v4, 0x1

    aput-object v3, v2, v4

    invoke-static {p1, v0, v1, v2}, Landroid/animation/ObjectAnimator;->ofObject(Ljava/lang/Object;Landroid/util/Property;Landroid/animation/TypeEvaluator;[Ljava/lang/Object;)Landroid/animation/ObjectAnimator;

    move-result-object v0

    return-object v0
.end method

.method private static fitXYMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;
    .locals 5
    .param p0, "view"    # Landroid/widget/ImageView;

    .line 202
    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    .line 203
    .local v0, "image":Landroid/graphics/drawable/Drawable;
    new-instance v1, Landroid/graphics/Matrix;

    invoke-direct {v1}, Landroid/graphics/Matrix;-><init>()V

    .line 204
    .local v1, "matrix":Landroid/graphics/Matrix;
    nop

    .line 205
    invoke-virtual {p0}, Landroid/widget/ImageView;->getWidth()I

    move-result v2

    int-to-float v2, v2

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v3

    int-to-float v3, v3

    div-float/2addr v2, v3

    .line 206
    invoke-virtual {p0}, Landroid/widget/ImageView;->getHeight()I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v4

    int-to-float v4, v4

    div-float/2addr v3, v4

    .line 204
    invoke-virtual {v1, v2, v3}, Landroid/graphics/Matrix;->postScale(FF)Z

    .line 207
    return-object v1
.end method


# virtual methods
.method public captureEndValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 109
    invoke-direct {p0, p1}, Landroid/support/transition/ChangeImageTransform;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 110
    return-void
.end method

.method public captureStartValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 104
    invoke-direct {p0, p1}, Landroid/support/transition/ChangeImageTransform;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 105
    return-void
.end method

.method public createAnimator(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 10
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p3, "endValues"    # Landroid/support/transition/TransitionValues;

    .line 130
    const/4 v0, 0x0

    if-eqz p2, :cond_b

    if-nez p3, :cond_0

    goto/16 :goto_4

    .line 133
    :cond_0
    iget-object v1, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v2, "android:changeImageTransform:bounds"

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/Rect;

    .line 134
    .local v1, "startBounds":Landroid/graphics/Rect;
    iget-object v2, p3, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:changeImageTransform:bounds"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Rect;

    .line 135
    .local v2, "endBounds":Landroid/graphics/Rect;
    if-eqz v1, :cond_a

    if-nez v2, :cond_1

    goto :goto_3

    .line 139
    :cond_1
    iget-object v3, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v4, "android:changeImageTransform:matrix"

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/graphics/Matrix;

    .line 140
    .local v3, "startMatrix":Landroid/graphics/Matrix;
    iget-object v4, p3, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v5, "android:changeImageTransform:matrix"

    invoke-interface {v4, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/graphics/Matrix;

    .line 142
    .local v4, "endMatrix":Landroid/graphics/Matrix;
    if-nez v3, :cond_2

    if-eqz v4, :cond_3

    :cond_2
    if-eqz v3, :cond_4

    .line 143
    invoke-virtual {v3, v4}, Landroid/graphics/Matrix;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    :cond_3
    const/4 v5, 0x1

    goto :goto_0

    :cond_4
    const/4 v5, 0x0

    .line 145
    .local v5, "matricesEqual":Z
    :goto_0
    invoke-virtual {v1, v2}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_5

    if-eqz v5, :cond_5

    .line 146
    return-object v0

    .line 149
    :cond_5
    iget-object v0, p3, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    check-cast v0, Landroid/widget/ImageView;

    .line 150
    .local v0, "imageView":Landroid/widget/ImageView;
    invoke-virtual {v0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v6

    .line 151
    .local v6, "drawable":Landroid/graphics/drawable/Drawable;
    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v7

    .line 152
    .local v7, "drawableWidth":I
    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v8

    .line 154
    .local v8, "drawableHeight":I
    invoke-static {v0}, Landroid/support/transition/ImageViewUtils;->startAnimateTransform(Landroid/widget/ImageView;)V

    .line 157
    if-eqz v7, :cond_9

    if-nez v8, :cond_6

    goto :goto_1

    .line 160
    :cond_6
    if-nez v3, :cond_7

    .line 161
    sget-object v3, Landroid/support/transition/MatrixUtils;->IDENTITY_MATRIX:Landroid/graphics/Matrix;

    .line 163
    :cond_7
    if-nez v4, :cond_8

    .line 164
    sget-object v4, Landroid/support/transition/MatrixUtils;->IDENTITY_MATRIX:Landroid/graphics/Matrix;

    .line 166
    :cond_8
    sget-object v9, Landroid/support/transition/ChangeImageTransform;->ANIMATED_TRANSFORM_PROPERTY:Landroid/util/Property;

    invoke-virtual {v9, v0, v3}, Landroid/util/Property;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 167
    invoke-direct {p0, v0, v3, v4}, Landroid/support/transition/ChangeImageTransform;->createMatrixAnimator(Landroid/widget/ImageView;Landroid/graphics/Matrix;Landroid/graphics/Matrix;)Landroid/animation/ObjectAnimator;

    move-result-object v9

    goto :goto_2

    .line 158
    :cond_9
    :goto_1
    invoke-direct {p0, v0}, Landroid/support/transition/ChangeImageTransform;->createNullAnimator(Landroid/widget/ImageView;)Landroid/animation/ObjectAnimator;

    move-result-object v9

    .line 167
    .local v9, "animator":Landroid/animation/ObjectAnimator;
    :goto_2
    nop

    .line 170
    invoke-static {v0, v9}, Landroid/support/transition/ImageViewUtils;->reserveEndAnimateTransform(Landroid/widget/ImageView;Landroid/animation/Animator;)V

    .line 172
    return-object v9

    .line 136
    .end local v0    # "imageView":Landroid/widget/ImageView;
    .end local v3    # "startMatrix":Landroid/graphics/Matrix;
    .end local v4    # "endMatrix":Landroid/graphics/Matrix;
    .end local v5    # "matricesEqual":Z
    .end local v6    # "drawable":Landroid/graphics/drawable/Drawable;
    .end local v7    # "drawableWidth":I
    .end local v8    # "drawableHeight":I
    .end local v9    # "animator":Landroid/animation/ObjectAnimator;
    :cond_a
    :goto_3
    return-object v0

    .line 131
    .end local v1    # "startBounds":Landroid/graphics/Rect;
    .end local v2    # "endBounds":Landroid/graphics/Rect;
    :cond_b
    :goto_4
    return-object v0
.end method

.method public getTransitionProperties()[Ljava/lang/String;
    .locals 1

    .line 114
    sget-object v0, Landroid/support/transition/ChangeImageTransform;->sTransitionProperties:[Ljava/lang/String;

    return-object v0
.end method
