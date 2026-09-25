.class Landroid/support/design/widget/FloatingActionButtonLollipop;
.super Landroid/support/design/widget/FloatingActionButtonImpl;
.source "FloatingActionButtonLollipop.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x15
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/design/widget/FloatingActionButtonLollipop$AlwaysStatefulGradientDrawable;
    }
.end annotation


# instance fields
.field private mInsetDrawable:Landroid/graphics/drawable/InsetDrawable;


# direct methods
.method constructor <init>(Landroid/support/design/widget/VisibilityAwareImageButton;Landroid/support/design/widget/ShadowViewDelegate;)V
    .locals 0
    .param p1, "view"    # Landroid/support/design/widget/VisibilityAwareImageButton;
    .param p2, "shadowViewDelegate"    # Landroid/support/design/widget/ShadowViewDelegate;

    .line 46
    invoke-direct {p0, p1, p2}, Landroid/support/design/widget/FloatingActionButtonImpl;-><init>(Landroid/support/design/widget/VisibilityAwareImageButton;Landroid/support/design/widget/ShadowViewDelegate;)V

    .line 47
    return-void
.end method


# virtual methods
.method public getElevation()F
    .locals 1

    .line 155
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v0}, Landroid/support/design/widget/VisibilityAwareImageButton;->getElevation()F

    move-result v0

    return v0
.end method

.method getPadding(Landroid/graphics/Rect;)V
    .locals 6
    .param p1, "rect"    # Landroid/graphics/Rect;

    .line 201
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    invoke-interface {v0}, Landroid/support/design/widget/ShadowViewDelegate;->isCompatPaddingEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 202
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    invoke-interface {v0}, Landroid/support/design/widget/ShadowViewDelegate;->getRadius()F

    move-result v0

    .line 203
    .local v0, "radius":F
    invoke-virtual {p0}, Landroid/support/design/widget/FloatingActionButtonLollipop;->getElevation()F

    move-result v2

    iget v3, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mPressedTranslationZ:F

    add-float/2addr v2, v3

    .line 204
    .local v2, "maxShadowSize":F
    nop

    .line 205
    invoke-static {v2, v0, v1}, Landroid/support/design/widget/ShadowDrawableWrapper;->calculateHorizontalPadding(FFZ)F

    move-result v3

    float-to-double v3, v3

    .line 204
    invoke-static {v3, v4}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v3

    double-to-int v3, v3

    .line 206
    .local v3, "hPadding":I
    nop

    .line 207
    invoke-static {v2, v0, v1}, Landroid/support/design/widget/ShadowDrawableWrapper;->calculateVerticalPadding(FFZ)F

    move-result v1

    float-to-double v4, v1

    .line 206
    invoke-static {v4, v5}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v4

    double-to-int v1, v4

    .line 208
    .local v1, "vPadding":I
    invoke-virtual {p1, v3, v1, v3, v1}, Landroid/graphics/Rect;->set(IIII)V

    .line 209
    .end local v0    # "radius":F
    .end local v1    # "vPadding":I
    .end local v2    # "maxShadowSize":F
    .end local v3    # "hPadding":I
    goto :goto_0

    .line 210
    :cond_0
    invoke-virtual {p1, v1, v1, v1, v1}, Landroid/graphics/Rect;->set(IIII)V

    .line 212
    :goto_0
    return-void
.end method

.method jumpDrawableToCurrentState()V
    .locals 0

    .line 182
    return-void
.end method

.method newCircularDrawable()Landroid/support/design/widget/CircularBorderDrawable;
    .locals 1

    .line 191
    new-instance v0, Landroid/support/design/widget/CircularBorderDrawableLollipop;

    invoke-direct {v0}, Landroid/support/design/widget/CircularBorderDrawableLollipop;-><init>()V

    return-object v0
.end method

.method newGradientDrawableForShape()Landroid/graphics/drawable/GradientDrawable;
    .locals 1

    .line 196
    new-instance v0, Landroid/support/design/widget/FloatingActionButtonLollipop$AlwaysStatefulGradientDrawable;

    invoke-direct {v0}, Landroid/support/design/widget/FloatingActionButtonLollipop$AlwaysStatefulGradientDrawable;-><init>()V

    return-object v0
.end method

.method onCompatShadowChanged()V
    .locals 0

    .line 160
    invoke-virtual {p0}, Landroid/support/design/widget/FloatingActionButtonLollipop;->updatePadding()V

    .line 161
    return-void
.end method

.method onDrawableStateChanged([I)V
    .locals 0
    .param p1, "state"    # [I

    .line 177
    return-void
.end method

.method onElevationsChanged(FF)V
    .locals 17
    .param p1, "elevation"    # F
    .param p2, "pressedTranslationZ"    # F

    move-object/from16 v0, p0

    move/from16 v1, p1

    .line 87
    move/from16 v2, p2

    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v4, 0x0

    const/16 v5, 0x15

    if-ne v3, v5, :cond_3

    .line 90
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3}, Landroid/support/design/widget/VisibilityAwareImageButton;->isEnabled()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 91
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3, v1}, Landroid/support/design/widget/VisibilityAwareImageButton;->setElevation(F)V

    .line 92
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3}, Landroid/support/design/widget/VisibilityAwareImageButton;->isFocused()Z

    move-result v3

    if-nez v3, :cond_1

    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3}, Landroid/support/design/widget/VisibilityAwareImageButton;->isPressed()Z

    move-result v3

    if-eqz v3, :cond_0

    goto :goto_0

    .line 95
    :cond_0
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3, v4}, Landroid/support/design/widget/VisibilityAwareImageButton;->setTranslationZ(F)V

    goto/16 :goto_1

    .line 93
    :cond_1
    :goto_0
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3, v2}, Landroid/support/design/widget/VisibilityAwareImageButton;->setTranslationZ(F)V

    goto/16 :goto_1

    .line 98
    :cond_2
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3, v4}, Landroid/support/design/widget/VisibilityAwareImageButton;->setElevation(F)V

    .line 99
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v3, v4}, Landroid/support/design/widget/VisibilityAwareImageButton;->setTranslationZ(F)V

    goto/16 :goto_1

    .line 102
    :cond_3
    new-instance v3, Landroid/animation/StateListAnimator;

    invoke-direct {v3}, Landroid/animation/StateListAnimator;-><init>()V

    .line 105
    .local v3, "stateListAnimator":Landroid/animation/StateListAnimator;
    new-instance v5, Landroid/animation/AnimatorSet;

    invoke-direct {v5}, Landroid/animation/AnimatorSet;-><init>()V

    .line 106
    .local v5, "set":Landroid/animation/AnimatorSet;
    iget-object v6, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    const-string v7, "elevation"

    const/4 v8, 0x1

    new-array v9, v8, [F

    const/4 v10, 0x0

    aput v1, v9, v10

    invoke-static {v6, v7, v9}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Ljava/lang/String;[F)Landroid/animation/ObjectAnimator;

    move-result-object v6

    const-wide/16 v11, 0x0

    invoke-virtual {v6, v11, v12}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v6

    invoke-virtual {v5, v6}, Landroid/animation/AnimatorSet;->play(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    move-result-object v6

    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    sget-object v9, Landroid/view/View;->TRANSLATION_Z:Landroid/util/Property;

    new-array v13, v8, [F

    aput v2, v13, v10

    .line 107
    invoke-static {v7, v9, v13}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 108
    const-wide/16 v13, 0x64

    invoke-virtual {v7, v13, v14}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 107
    invoke-virtual {v6, v7}, Landroid/animation/AnimatorSet$Builder;->with(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    .line 109
    sget-object v6, Landroid/support/design/widget/FloatingActionButtonLollipop;->ANIM_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v5, v6}, Landroid/animation/AnimatorSet;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 110
    sget-object v6, Landroid/support/design/widget/FloatingActionButtonLollipop;->PRESSED_ENABLED_STATE_SET:[I

    invoke-virtual {v3, v6, v5}, Landroid/animation/StateListAnimator;->addState([ILandroid/animation/Animator;)V

    .line 113
    new-instance v6, Landroid/animation/AnimatorSet;

    invoke-direct {v6}, Landroid/animation/AnimatorSet;-><init>()V

    move-object v5, v6

    .line 114
    iget-object v6, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    const-string v7, "elevation"

    new-array v9, v8, [F

    aput v1, v9, v10

    invoke-static {v6, v7, v9}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Ljava/lang/String;[F)Landroid/animation/ObjectAnimator;

    move-result-object v6

    invoke-virtual {v6, v11, v12}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v6

    invoke-virtual {v5, v6}, Landroid/animation/AnimatorSet;->play(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    move-result-object v6

    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    sget-object v9, Landroid/view/View;->TRANSLATION_Z:Landroid/util/Property;

    new-array v15, v8, [F

    aput v2, v15, v10

    .line 115
    invoke-static {v7, v9, v15}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 116
    invoke-virtual {v7, v13, v14}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 115
    invoke-virtual {v6, v7}, Landroid/animation/AnimatorSet$Builder;->with(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    .line 117
    sget-object v6, Landroid/support/design/widget/FloatingActionButtonLollipop;->ANIM_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v5, v6}, Landroid/animation/AnimatorSet;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 118
    sget-object v6, Landroid/support/design/widget/FloatingActionButtonLollipop;->FOCUSED_ENABLED_STATE_SET:[I

    invoke-virtual {v3, v6, v5}, Landroid/animation/StateListAnimator;->addState([ILandroid/animation/Animator;)V

    .line 121
    new-instance v6, Landroid/animation/AnimatorSet;

    invoke-direct {v6}, Landroid/animation/AnimatorSet;-><init>()V

    move-object v5, v6

    .line 122
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6}, Ljava/util/ArrayList;-><init>()V

    .line 123
    .local v6, "animators":Ljava/util/List;, "Ljava/util/List<Landroid/animation/Animator;>;"
    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    const-string v9, "elevation"

    new-array v15, v8, [F

    aput v1, v15, v10

    invoke-static {v7, v9, v15}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Ljava/lang/String;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    invoke-virtual {v7, v11, v12}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 124
    sget v7, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v9, 0x16

    if-lt v7, v9, :cond_4

    sget v7, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v9, 0x18

    if-gt v7, v9, :cond_4

    .line 129
    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    sget-object v9, Landroid/view/View;->TRANSLATION_Z:Landroid/util/Property;

    new-array v15, v8, [F

    iget-object v11, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    .line 130
    invoke-virtual {v11}, Landroid/support/design/widget/VisibilityAwareImageButton;->getTranslationZ()F

    move-result v11

    aput v11, v15, v10

    .line 129
    invoke-static {v7, v9, v15}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 130
    invoke-virtual {v7, v13, v14}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 129
    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 132
    :cond_4
    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    sget-object v9, Landroid/view/View;->TRANSLATION_Z:Landroid/util/Property;

    new-array v11, v8, [F

    aput v4, v11, v10

    invoke-static {v7, v9, v11}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 133
    invoke-virtual {v7, v13, v14}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    .line 132
    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 134
    new-array v7, v10, [Landroid/animation/ObjectAnimator;

    invoke-interface {v6, v7}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v7

    check-cast v7, [Landroid/animation/Animator;

    invoke-virtual {v5, v7}, Landroid/animation/AnimatorSet;->playSequentially([Landroid/animation/Animator;)V

    .line 135
    sget-object v7, Landroid/support/design/widget/FloatingActionButtonLollipop;->ANIM_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v5, v7}, Landroid/animation/AnimatorSet;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 136
    sget-object v7, Landroid/support/design/widget/FloatingActionButtonLollipop;->ENABLED_STATE_SET:[I

    invoke-virtual {v3, v7, v5}, Landroid/animation/StateListAnimator;->addState([ILandroid/animation/Animator;)V

    .line 139
    new-instance v7, Landroid/animation/AnimatorSet;

    invoke-direct {v7}, Landroid/animation/AnimatorSet;-><init>()V

    move-object v5, v7

    .line 140
    iget-object v7, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    const-string v9, "elevation"

    new-array v11, v8, [F

    aput v4, v11, v10

    invoke-static {v7, v9, v11}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Ljava/lang/String;[F)Landroid/animation/ObjectAnimator;

    move-result-object v7

    const-wide/16 v11, 0x0

    invoke-virtual {v7, v11, v12}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v7

    invoke-virtual {v5, v7}, Landroid/animation/AnimatorSet;->play(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    move-result-object v7

    iget-object v9, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    sget-object v13, Landroid/view/View;->TRANSLATION_Z:Landroid/util/Property;

    new-array v8, v8, [F

    aput v4, v8, v10

    .line 141
    invoke-static {v9, v13, v8}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v4

    invoke-virtual {v4, v11, v12}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    move-result-object v4

    invoke-virtual {v7, v4}, Landroid/animation/AnimatorSet$Builder;->with(Landroid/animation/Animator;)Landroid/animation/AnimatorSet$Builder;

    .line 142
    sget-object v4, Landroid/support/design/widget/FloatingActionButtonLollipop;->ANIM_INTERPOLATOR:Landroid/view/animation/Interpolator;

    invoke-virtual {v5, v4}, Landroid/animation/AnimatorSet;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 143
    sget-object v4, Landroid/support/design/widget/FloatingActionButtonLollipop;->EMPTY_STATE_SET:[I

    invoke-virtual {v3, v4, v5}, Landroid/animation/StateListAnimator;->addState([ILandroid/animation/Animator;)V

    .line 145
    iget-object v4, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mView:Landroid/support/design/widget/VisibilityAwareImageButton;

    invoke-virtual {v4, v3}, Landroid/support/design/widget/VisibilityAwareImageButton;->setStateListAnimator(Landroid/animation/StateListAnimator;)V

    .line 148
    .end local v3    # "stateListAnimator":Landroid/animation/StateListAnimator;
    .end local v5    # "set":Landroid/animation/AnimatorSet;
    .end local v6    # "animators":Ljava/util/List;, "Ljava/util/List<Landroid/animation/Animator;>;"
    :goto_1
    iget-object v3, v0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    invoke-interface {v3}, Landroid/support/design/widget/ShadowViewDelegate;->isCompatPaddingEnabled()Z

    move-result v3

    if-eqz v3, :cond_5

    .line 149
    invoke-virtual/range {p0 .. p0}, Landroid/support/design/widget/FloatingActionButtonLollipop;->updatePadding()V

    .line 151
    :cond_5
    return-void
.end method

.method onPaddingUpdated(Landroid/graphics/Rect;)V
    .locals 7
    .param p1, "padding"    # Landroid/graphics/Rect;

    .line 165
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    invoke-interface {v0}, Landroid/support/design/widget/ShadowViewDelegate;->isCompatPaddingEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 166
    new-instance v0, Landroid/graphics/drawable/InsetDrawable;

    iget-object v2, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    iget v3, p1, Landroid/graphics/Rect;->left:I

    iget v4, p1, Landroid/graphics/Rect;->top:I

    iget v5, p1, Landroid/graphics/Rect;->right:I

    iget v6, p1, Landroid/graphics/Rect;->bottom:I

    move-object v1, v0

    invoke-direct/range {v1 .. v6}, Landroid/graphics/drawable/InsetDrawable;-><init>(Landroid/graphics/drawable/Drawable;IIII)V

    iput-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mInsetDrawable:Landroid/graphics/drawable/InsetDrawable;

    .line 168
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    iget-object v1, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mInsetDrawable:Landroid/graphics/drawable/InsetDrawable;

    invoke-interface {v0, v1}, Landroid/support/design/widget/ShadowViewDelegate;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_0

    .line 170
    :cond_0
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    iget-object v1, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    invoke-interface {v0, v1}, Landroid/support/design/widget/ShadowViewDelegate;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 172
    :goto_0
    return-void
.end method

.method requirePreDrawListener()Z
    .locals 1

    .line 186
    const/4 v0, 0x0

    return v0
.end method

.method setBackgroundDrawable(Landroid/content/res/ColorStateList;Landroid/graphics/PorterDuff$Mode;II)V
    .locals 5
    .param p1, "backgroundTint"    # Landroid/content/res/ColorStateList;
    .param p2, "backgroundTintMode"    # Landroid/graphics/PorterDuff$Mode;
    .param p3, "rippleColor"    # I
    .param p4, "borderWidth"    # I

    .line 53
    invoke-virtual {p0}, Landroid/support/design/widget/FloatingActionButtonLollipop;->createShapeDrawable()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    invoke-static {v0}, Landroid/support/v4/graphics/drawable/DrawableCompat;->wrap(Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShapeDrawable:Landroid/graphics/drawable/Drawable;

    .line 54
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShapeDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v0, p1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintList(Landroid/graphics/drawable/Drawable;Landroid/content/res/ColorStateList;)V

    .line 55
    if-eqz p2, :cond_0

    .line 56
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShapeDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v0, p2}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintMode(Landroid/graphics/drawable/Drawable;Landroid/graphics/PorterDuff$Mode;)V

    .line 60
    :cond_0
    const/4 v0, 0x0

    if-lez p4, :cond_1

    .line 61
    invoke-virtual {p0, p4, p1}, Landroid/support/design/widget/FloatingActionButtonLollipop;->createBorderDrawable(ILandroid/content/res/ColorStateList;)Landroid/support/design/widget/CircularBorderDrawable;

    move-result-object v1

    iput-object v1, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mBorderDrawable:Landroid/support/design/widget/CircularBorderDrawable;

    .line 62
    new-instance v1, Landroid/graphics/drawable/LayerDrawable;

    const/4 v2, 0x2

    new-array v2, v2, [Landroid/graphics/drawable/Drawable;

    const/4 v3, 0x0

    iget-object v4, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mBorderDrawable:Landroid/support/design/widget/CircularBorderDrawable;

    aput-object v4, v2, v3

    const/4 v3, 0x1

    iget-object v4, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShapeDrawable:Landroid/graphics/drawable/Drawable;

    aput-object v4, v2, v3

    invoke-direct {v1, v2}, Landroid/graphics/drawable/LayerDrawable;-><init>([Landroid/graphics/drawable/Drawable;)V

    .line 62
    .local v1, "rippleContent":Landroid/graphics/drawable/Drawable;
    goto :goto_0

    .line 64
    .end local v1    # "rippleContent":Landroid/graphics/drawable/Drawable;
    :cond_1
    iput-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mBorderDrawable:Landroid/support/design/widget/CircularBorderDrawable;

    .line 65
    iget-object v1, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShapeDrawable:Landroid/graphics/drawable/Drawable;

    .line 68
    .restart local v1    # "rippleContent":Landroid/graphics/drawable/Drawable;
    :goto_0
    new-instance v2, Landroid/graphics/drawable/RippleDrawable;

    invoke-static {p3}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v3

    invoke-direct {v2, v3, v1, v0}, Landroid/graphics/drawable/RippleDrawable;-><init>(Landroid/content/res/ColorStateList;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V

    iput-object v2, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    .line 71
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    iput-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mContentBackground:Landroid/graphics/drawable/Drawable;

    .line 73
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mShadowViewDelegate:Landroid/support/design/widget/ShadowViewDelegate;

    iget-object v2, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    invoke-interface {v0, v2}, Landroid/support/design/widget/ShadowViewDelegate;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 74
    return-void
.end method

.method setRippleColor(I)V
    .locals 2
    .param p1, "rippleColor"    # I

    .line 78
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    instance-of v0, v0, Landroid/graphics/drawable/RippleDrawable;

    if-eqz v0, :cond_0

    .line 79
    iget-object v0, p0, Landroid/support/design/widget/FloatingActionButtonLollipop;->mRippleDrawable:Landroid/graphics/drawable/Drawable;

    check-cast v0, Landroid/graphics/drawable/RippleDrawable;

    invoke-static {p1}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/RippleDrawable;->setColor(Landroid/content/res/ColorStateList;)V

    goto :goto_0

    .line 81
    :cond_0
    invoke-super {p0, p1}, Landroid/support/design/widget/FloatingActionButtonImpl;->setRippleColor(I)V

    .line 83
    :goto_0
    return-void
.end method
