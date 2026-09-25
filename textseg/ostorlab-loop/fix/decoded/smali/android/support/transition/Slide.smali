.class public Landroid/support/transition/Slide;
.super Landroid/support/transition/Visibility;
.source "Slide.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/transition/Slide$CalculateSlideVertical;,
        Landroid/support/transition/Slide$CalculateSlideHorizontal;,
        Landroid/support/transition/Slide$CalculateSlide;,
        Landroid/support/transition/Slide$GravityFlag;
    }
.end annotation


# static fields
.field private static final PROPNAME_SCREEN_POSITION:Ljava/lang/String; = "android:slide:screenPosition"

.field private static final sAccelerate:Landroid/animation/TimeInterpolator;

.field private static final sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sCalculateEnd:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sCalculateLeft:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sCalculateRight:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sCalculateStart:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sCalculateTop:Landroid/support/transition/Slide$CalculateSlide;

.field private static final sDecelerate:Landroid/animation/TimeInterpolator;


# instance fields
.field private mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

.field private mSlideEdge:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 53
    new-instance v0, Landroid/view/animation/DecelerateInterpolator;

    invoke-direct {v0}, Landroid/view/animation/DecelerateInterpolator;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sDecelerate:Landroid/animation/TimeInterpolator;

    .line 54
    new-instance v0, Landroid/view/animation/AccelerateInterpolator;

    invoke-direct {v0}, Landroid/view/animation/AccelerateInterpolator;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sAccelerate:Landroid/animation/TimeInterpolator;

    .line 91
    new-instance v0, Landroid/support/transition/Slide$1;

    invoke-direct {v0}, Landroid/support/transition/Slide$1;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateLeft:Landroid/support/transition/Slide$CalculateSlide;

    .line 98
    new-instance v0, Landroid/support/transition/Slide$2;

    invoke-direct {v0}, Landroid/support/transition/Slide$2;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateStart:Landroid/support/transition/Slide$CalculateSlide;

    .line 113
    new-instance v0, Landroid/support/transition/Slide$3;

    invoke-direct {v0}, Landroid/support/transition/Slide$3;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateTop:Landroid/support/transition/Slide$CalculateSlide;

    .line 120
    new-instance v0, Landroid/support/transition/Slide$4;

    invoke-direct {v0}, Landroid/support/transition/Slide$4;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateRight:Landroid/support/transition/Slide$CalculateSlide;

    .line 127
    new-instance v0, Landroid/support/transition/Slide$5;

    invoke-direct {v0}, Landroid/support/transition/Slide$5;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateEnd:Landroid/support/transition/Slide$CalculateSlide;

    .line 142
    new-instance v0, Landroid/support/transition/Slide$6;

    invoke-direct {v0}, Landroid/support/transition/Slide$6;-><init>()V

    sput-object v0, Landroid/support/transition/Slide;->sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 153
    invoke-direct {p0}, Landroid/support/transition/Visibility;-><init>()V

    .line 56
    sget-object v0, Landroid/support/transition/Slide;->sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 57
    const/16 v0, 0x50

    iput v0, p0, Landroid/support/transition/Slide;->mSlideEdge:I

    .line 154
    invoke-virtual {p0, v0}, Landroid/support/transition/Slide;->setSlideEdge(I)V

    .line 155
    return-void
.end method

.method public constructor <init>(I)V
    .locals 1
    .param p1, "slideEdge"    # I

    .line 160
    invoke-direct {p0}, Landroid/support/transition/Visibility;-><init>()V

    .line 56
    sget-object v0, Landroid/support/transition/Slide;->sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 57
    const/16 v0, 0x50

    iput v0, p0, Landroid/support/transition/Slide;->mSlideEdge:I

    .line 161
    invoke-virtual {p0, p1}, Landroid/support/transition/Slide;->setSlideEdge(I)V

    .line 162
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 5
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 165
    invoke-direct {p0, p1, p2}, Landroid/support/transition/Visibility;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 56
    sget-object v0, Landroid/support/transition/Slide;->sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 57
    const/16 v0, 0x50

    iput v0, p0, Landroid/support/transition/Slide;->mSlideEdge:I

    .line 166
    sget-object v1, Landroid/support/transition/Styleable;->SLIDE:[I

    invoke-virtual {p1, p2, v1}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object v1

    .line 167
    .local v1, "a":Landroid/content/res/TypedArray;
    move-object v2, p2

    check-cast v2, Lorg/xmlpull/v1/XmlPullParser;

    const-string v3, "slideEdge"

    const/4 v4, 0x0

    invoke-static {v1, v2, v3, v4, v0}, Landroid/support/v4/content/res/TypedArrayUtils;->getNamedInt(Landroid/content/res/TypedArray;Lorg/xmlpull/v1/XmlPullParser;Ljava/lang/String;II)I

    move-result v0

    .line 169
    .local v0, "edge":I
    invoke-virtual {v1}, Landroid/content/res/TypedArray;->recycle()V

    .line 171
    invoke-virtual {p0, v0}, Landroid/support/transition/Slide;->setSlideEdge(I)V

    .line 172
    return-void
.end method

.method private captureValues(Landroid/support/transition/TransitionValues;)V
    .locals 4
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;

    .line 175
    iget-object v0, p1, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    .line 176
    .local v0, "view":Landroid/view/View;
    const/4 v1, 0x2

    new-array v1, v1, [I

    .line 177
    .local v1, "position":[I
    invoke-virtual {v0, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 178
    iget-object v2, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:slide:screenPosition"

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 179
    return-void
.end method


# virtual methods
.method public captureEndValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 189
    invoke-super {p0, p1}, Landroid/support/transition/Visibility;->captureEndValues(Landroid/support/transition/TransitionValues;)V

    .line 190
    invoke-direct {p0, p1}, Landroid/support/transition/Slide;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 191
    return-void
.end method

.method public captureStartValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 183
    invoke-super {p0, p1}, Landroid/support/transition/Visibility;->captureStartValues(Landroid/support/transition/TransitionValues;)V

    .line 184
    invoke-direct {p0, p1}, Landroid/support/transition/Slide;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 185
    return-void
.end method

.method public getSlideEdge()I
    .locals 1

    .line 240
    iget v0, p0, Landroid/support/transition/Slide;->mSlideEdge:I

    return v0
.end method

.method public onAppear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 18
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "view"    # Landroid/view/View;
    .param p3, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v11, p2

    .line 246
    move-object/from16 v12, p4

    if-nez v12, :cond_0

    .line 247
    const/4 v2, 0x0

    return-object v2

    .line 249
    :cond_0
    iget-object v2, v12, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:slide:screenPosition"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    move-object v13, v2

    check-cast v13, [I

    .line 250
    .local v13, "position":[I
    invoke-virtual/range {p2 .. p2}, Landroid/view/View;->getTranslationX()F

    move-result v14

    .line 251
    .local v14, "endX":F
    invoke-virtual/range {p2 .. p2}, Landroid/view/View;->getTranslationY()F

    move-result v15

    .line 252
    .local v15, "endY":F
    iget-object v2, v0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    invoke-interface {v2, v1, v11}, Landroid/support/transition/Slide$CalculateSlide;->getGoneX(Landroid/view/ViewGroup;Landroid/view/View;)F

    move-result v16

    .line 253
    .local v16, "startX":F
    iget-object v2, v0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    invoke-interface {v2, v1, v11}, Landroid/support/transition/Slide$CalculateSlide;->getGoneY(Landroid/view/ViewGroup;Landroid/view/View;)F

    move-result v17

    .line 254
    .local v17, "startY":F
    const/4 v2, 0x0

    aget v4, v13, v2

    const/4 v2, 0x1

    aget v5, v13, v2

    sget-object v10, Landroid/support/transition/Slide;->sDecelerate:Landroid/animation/TimeInterpolator;

    .line 255
    move-object v2, v11

    move-object v3, v12

    move/from16 v6, v16

    move/from16 v7, v17

    move v8, v14

    move v9, v15

    invoke-static/range {v2 .. v10}, Landroid/support/transition/TranslationAnimationCreator;->createAnimation(Landroid/view/View;Landroid/support/transition/TransitionValues;IIFFFFLandroid/animation/TimeInterpolator;)Landroid/animation/Animator;

    move-result-object v2

    return-object v2
.end method

.method public onDisappear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 18
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "view"    # Landroid/view/View;
    .param p3, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v11, p2

    move-object/from16 v12, p3

    .line 262
    if-nez v12, :cond_0

    .line 263
    const/4 v2, 0x0

    return-object v2

    .line 265
    :cond_0
    iget-object v2, v12, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:slide:screenPosition"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    move-object v13, v2

    check-cast v13, [I

    .line 266
    .local v13, "position":[I
    invoke-virtual/range {p2 .. p2}, Landroid/view/View;->getTranslationX()F

    move-result v14

    .line 267
    .local v14, "startX":F
    invoke-virtual/range {p2 .. p2}, Landroid/view/View;->getTranslationY()F

    move-result v15

    .line 268
    .local v15, "startY":F
    iget-object v2, v0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    invoke-interface {v2, v1, v11}, Landroid/support/transition/Slide$CalculateSlide;->getGoneX(Landroid/view/ViewGroup;Landroid/view/View;)F

    move-result v16

    .line 269
    .local v16, "endX":F
    iget-object v2, v0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    invoke-interface {v2, v1, v11}, Landroid/support/transition/Slide$CalculateSlide;->getGoneY(Landroid/view/ViewGroup;Landroid/view/View;)F

    move-result v17

    .line 270
    .local v17, "endY":F
    const/4 v2, 0x0

    aget v4, v13, v2

    const/4 v2, 0x1

    aget v5, v13, v2

    sget-object v10, Landroid/support/transition/Slide;->sAccelerate:Landroid/animation/TimeInterpolator;

    .line 271
    move-object v2, v11

    move-object v3, v12

    move v6, v14

    move v7, v15

    move/from16 v8, v16

    move/from16 v9, v17

    invoke-static/range {v2 .. v10}, Landroid/support/transition/TranslationAnimationCreator;->createAnimation(Landroid/view/View;Landroid/support/transition/TransitionValues;IIFFFFLandroid/animation/TimeInterpolator;)Landroid/animation/Animator;

    move-result-object v2

    return-object v2
.end method

.method public setSlideEdge(I)V
    .locals 2
    .param p1, "slideEdge"    # I

    .line 202
    const/4 v0, 0x3

    if-eq p1, v0, :cond_5

    const/4 v0, 0x5

    if-eq p1, v0, :cond_4

    const/16 v0, 0x30

    if-eq p1, v0, :cond_3

    const/16 v0, 0x50

    if-eq p1, v0, :cond_2

    const v0, 0x800003

    if-eq p1, v0, :cond_1

    const v0, 0x800005

    if-eq p1, v0, :cond_0

    .line 222
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Invalid slide direction"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 219
    :cond_0
    sget-object v0, Landroid/support/transition/Slide;->sCalculateEnd:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 220
    goto :goto_0

    .line 216
    :cond_1
    sget-object v0, Landroid/support/transition/Slide;->sCalculateStart:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 217
    goto :goto_0

    .line 213
    :cond_2
    sget-object v0, Landroid/support/transition/Slide;->sCalculateBottom:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 214
    goto :goto_0

    .line 207
    :cond_3
    sget-object v0, Landroid/support/transition/Slide;->sCalculateTop:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 208
    goto :goto_0

    .line 210
    :cond_4
    sget-object v0, Landroid/support/transition/Slide;->sCalculateRight:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 211
    goto :goto_0

    .line 204
    :cond_5
    sget-object v0, Landroid/support/transition/Slide;->sCalculateLeft:Landroid/support/transition/Slide$CalculateSlide;

    iput-object v0, p0, Landroid/support/transition/Slide;->mSlideCalculator:Landroid/support/transition/Slide$CalculateSlide;

    .line 205
    nop

    .line 224
    :goto_0
    iput p1, p0, Landroid/support/transition/Slide;->mSlideEdge:I

    .line 225
    new-instance v0, Landroid/support/transition/SidePropagation;

    invoke-direct {v0}, Landroid/support/transition/SidePropagation;-><init>()V

    .line 226
    .local v0, "propagation":Landroid/support/transition/SidePropagation;
    invoke-virtual {v0, p1}, Landroid/support/transition/SidePropagation;->setSide(I)V

    .line 227
    invoke-virtual {p0, v0}, Landroid/support/transition/Slide;->setPropagation(Landroid/support/transition/TransitionPropagation;)V

    .line 228
    return-void
.end method
