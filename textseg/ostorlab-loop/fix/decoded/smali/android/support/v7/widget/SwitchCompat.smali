.class public Landroid/support/v7/widget/SwitchCompat;
.super Landroid/widget/CompoundButton;
.source "SwitchCompat.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0xe
.end annotation


# static fields
.field private static final ACCESSIBILITY_EVENT_CLASS_NAME:Ljava/lang/String; = "android.widget.Switch"

.field private static final CHECKED_STATE_SET:[I

.field private static final MONOSPACE:I = 0x3

.field private static final SANS:I = 0x1

.field private static final SERIF:I = 0x2

.field private static final THUMB_ANIMATION_DURATION:I = 0xfa

.field private static final THUMB_POS:Landroid/util/Property;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Property<",
            "Landroid/support/v7/widget/SwitchCompat;",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private static final TOUCH_MODE_DOWN:I = 0x1

.field private static final TOUCH_MODE_DRAGGING:I = 0x2

.field private static final TOUCH_MODE_IDLE:I


# instance fields
.field private mHasThumbTint:Z

.field private mHasThumbTintMode:Z

.field private mHasTrackTint:Z

.field private mHasTrackTintMode:Z

.field private mMinFlingVelocity:I

.field private mOffLayout:Landroid/text/Layout;

.field private mOnLayout:Landroid/text/Layout;

.field mPositionAnimator:Landroid/animation/ObjectAnimator;

.field private mShowText:Z

.field private mSplitTrack:Z

.field private mSwitchBottom:I

.field private mSwitchHeight:I

.field private mSwitchLeft:I

.field private mSwitchMinWidth:I

.field private mSwitchPadding:I

.field private mSwitchRight:I

.field private mSwitchTop:I

.field private mSwitchTransformationMethod:Landroid/text/method/TransformationMethod;

.field private mSwitchWidth:I

.field private final mTempRect:Landroid/graphics/Rect;

.field private mTextColors:Landroid/content/res/ColorStateList;

.field private mTextOff:Ljava/lang/CharSequence;

.field private mTextOn:Ljava/lang/CharSequence;

.field private final mTextPaint:Landroid/text/TextPaint;

.field private mThumbDrawable:Landroid/graphics/drawable/Drawable;

.field private mThumbPosition:F

.field private mThumbTextPadding:I

.field private mThumbTintList:Landroid/content/res/ColorStateList;

.field private mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

.field private mThumbWidth:I

.field private mTouchMode:I

.field private mTouchSlop:I

.field private mTouchX:F

.field private mTouchY:F

.field private mTrackDrawable:Landroid/graphics/drawable/Drawable;

.field private mTrackTintList:Landroid/content/res/ColorStateList;

.field private mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

.field private mVelocityTracker:Landroid/view/VelocityTracker;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 99
    new-instance v0, Landroid/support/v7/widget/SwitchCompat$1;

    const-class v1, Ljava/lang/Float;

    const-string v2, "thumbPos"

    invoke-direct {v0, v1, v2}, Landroid/support/v7/widget/SwitchCompat$1;-><init>(Ljava/lang/Class;Ljava/lang/String;)V

    sput-object v0, Landroid/support/v7/widget/SwitchCompat;->THUMB_POS:Landroid/util/Property;

    .line 181
    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    const v2, 0x10100a0

    aput v2, v0, v1

    sput-object v0, Landroid/support/v7/widget/SwitchCompat;->CHECKED_STATE_SET:[I

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 191
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Landroid/support/v7/widget/SwitchCompat;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 192
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 202
    sget v0, Landroid/support/v7/appcompat/R$attr;->switchStyle:I

    invoke-direct {p0, p1, p2, v0}, Landroid/support/v7/widget/SwitchCompat;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 203
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 10
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .line 216
    invoke-direct {p0, p1, p2, p3}, Landroid/widget/CompoundButton;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 113
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintList:Landroid/content/res/ColorStateList;

    .line 114
    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 115
    const/4 v1, 0x0

    iput-boolean v1, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    .line 116
    iput-boolean v1, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    .line 119
    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintList:Landroid/content/res/ColorStateList;

    .line 120
    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 121
    iput-boolean v1, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    .line 122
    iput-boolean v1, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    .line 136
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v2

    iput-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 178
    new-instance v2, Landroid/graphics/Rect;

    invoke-direct {v2}, Landroid/graphics/Rect;-><init>()V

    iput-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 218
    new-instance v2, Landroid/text/TextPaint;

    const/4 v3, 0x1

    invoke-direct {v2, v3}, Landroid/text/TextPaint;-><init>(I)V

    iput-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    .line 220
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    .line 221
    .local v2, "res":Landroid/content/res/Resources;
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v5

    iget v5, v5, Landroid/util/DisplayMetrics;->density:F

    iput v5, v4, Landroid/text/TextPaint;->density:F

    .line 223
    sget-object v4, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat:[I

    invoke-static {p1, p2, v4, p3, v1}, Landroid/support/v7/widget/TintTypedArray;->obtainStyledAttributes(Landroid/content/Context;Landroid/util/AttributeSet;[III)Landroid/support/v7/widget/TintTypedArray;

    move-result-object v4

    .line 225
    .local v4, "a":Landroid/support/v7/widget/TintTypedArray;
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_android_thumb:I

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v5

    iput-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    .line 226
    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v5, :cond_0

    .line 227
    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v5, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 229
    :cond_0
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_track:I

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v5

    iput-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    .line 230
    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v5, :cond_1

    .line 231
    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v5, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 233
    :cond_1
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_android_textOn:I

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getText(I)Ljava/lang/CharSequence;

    move-result-object v5

    iput-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    .line 234
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_android_textOff:I

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getText(I)Ljava/lang/CharSequence;

    move-result-object v5

    iput-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    .line 235
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_showText:I

    invoke-virtual {v4, v5, v3}, Landroid/support/v7/widget/TintTypedArray;->getBoolean(IZ)Z

    move-result v5

    iput-boolean v5, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    .line 236
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_thumbTextPadding:I

    invoke-virtual {v4, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getDimensionPixelSize(II)I

    move-result v5

    iput v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTextPadding:I

    .line 238
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_switchMinWidth:I

    invoke-virtual {v4, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getDimensionPixelSize(II)I

    move-result v5

    iput v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchMinWidth:I

    .line 240
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_switchPadding:I

    invoke-virtual {v4, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getDimensionPixelSize(II)I

    move-result v5

    iput v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchPadding:I

    .line 242
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_splitTrack:I

    invoke-virtual {v4, v5, v1}, Landroid/support/v7/widget/TintTypedArray;->getBoolean(IZ)Z

    move-result v5

    iput-boolean v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSplitTrack:Z

    .line 244
    sget v5, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_thumbTint:I

    invoke-virtual {v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getColorStateList(I)Landroid/content/res/ColorStateList;

    move-result-object v5

    .line 245
    .local v5, "thumbTintList":Landroid/content/res/ColorStateList;
    if-eqz v5, :cond_2

    .line 246
    iput-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintList:Landroid/content/res/ColorStateList;

    .line 247
    iput-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    .line 249
    :cond_2
    sget v6, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_thumbTintMode:I

    .line 250
    const/4 v7, -0x1

    invoke-virtual {v4, v6, v7}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v6

    .line 249
    invoke-static {v6, v0}, Landroid/support/v7/widget/DrawableUtils;->parseTintMode(ILandroid/graphics/PorterDuff$Mode;)Landroid/graphics/PorterDuff$Mode;

    move-result-object v6

    .line 251
    .local v6, "thumbTintMode":Landroid/graphics/PorterDuff$Mode;
    iget-object v8, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    if-eq v8, v6, :cond_3

    .line 252
    iput-object v6, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 253
    iput-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    .line 255
    :cond_3
    iget-boolean v8, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    if-nez v8, :cond_4

    iget-boolean v8, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    if-eqz v8, :cond_5

    .line 256
    :cond_4
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyThumbTint()V

    .line 259
    :cond_5
    sget v8, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_trackTint:I

    invoke-virtual {v4, v8}, Landroid/support/v7/widget/TintTypedArray;->getColorStateList(I)Landroid/content/res/ColorStateList;

    move-result-object v8

    .line 260
    .local v8, "trackTintList":Landroid/content/res/ColorStateList;
    if-eqz v8, :cond_6

    .line 261
    iput-object v8, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintList:Landroid/content/res/ColorStateList;

    .line 262
    iput-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    .line 264
    :cond_6
    sget v9, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_trackTintMode:I

    .line 265
    invoke-virtual {v4, v9, v7}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v7

    .line 264
    invoke-static {v7, v0}, Landroid/support/v7/widget/DrawableUtils;->parseTintMode(ILandroid/graphics/PorterDuff$Mode;)Landroid/graphics/PorterDuff$Mode;

    move-result-object v0

    .line 266
    .local v0, "trackTintMode":Landroid/graphics/PorterDuff$Mode;
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    if-eq v7, v0, :cond_7

    .line 267
    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 268
    iput-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    .line 270
    :cond_7
    iget-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    if-nez v3, :cond_8

    iget-boolean v3, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    if-eqz v3, :cond_9

    .line 271
    :cond_8
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyTrackTint()V

    .line 274
    :cond_9
    sget v3, Landroid/support/v7/appcompat/R$styleable;->SwitchCompat_switchTextAppearance:I

    invoke-virtual {v4, v3, v1}, Landroid/support/v7/widget/TintTypedArray;->getResourceId(II)I

    move-result v1

    .line 276
    .local v1, "appearance":I
    if-eqz v1, :cond_a

    .line 277
    invoke-virtual {p0, p1, v1}, Landroid/support/v7/widget/SwitchCompat;->setSwitchTextAppearance(Landroid/content/Context;I)V

    .line 280
    :cond_a
    invoke-virtual {v4}, Landroid/support/v7/widget/TintTypedArray;->recycle()V

    .line 282
    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v3

    .line 283
    .local v3, "config":Landroid/view/ViewConfiguration;
    invoke-virtual {v3}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v7

    iput v7, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    .line 284
    invoke-virtual {v3}, Landroid/view/ViewConfiguration;->getScaledMinimumFlingVelocity()I

    move-result v7

    iput v7, p0, Landroid/support/v7/widget/SwitchCompat;->mMinFlingVelocity:I

    .line 287
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->refreshDrawableState()V

    .line 288
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v7

    invoke-virtual {p0, v7}, Landroid/support/v7/widget/SwitchCompat;->setChecked(Z)V

    .line 289
    return-void
.end method

.method static synthetic access$000(Landroid/support/v7/widget/SwitchCompat;)F
    .locals 1
    .param p0, "x0"    # Landroid/support/v7/widget/SwitchCompat;

    .line 83
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    return v0
.end method

.method private animateThumbToCheckedState(Z)V
    .locals 5
    .param p1, "newCheckedState"    # Z

    .line 1022
    if-eqz p1, :cond_0

    const/high16 v0, 0x3f800000    # 1.0f

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 1023
    .local v0, "targetPosition":F
    :goto_0
    sget-object v1, Landroid/support/v7/widget/SwitchCompat;->THUMB_POS:Landroid/util/Property;

    const/4 v2, 0x1

    new-array v3, v2, [F

    const/4 v4, 0x0

    aput v0, v3, v4

    invoke-static {p0, v1, v3}, Landroid/animation/ObjectAnimator;->ofFloat(Ljava/lang/Object;Landroid/util/Property;[F)Landroid/animation/ObjectAnimator;

    move-result-object v1

    iput-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    .line 1024
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    const-wide/16 v3, 0xfa

    invoke-virtual {v1, v3, v4}, Landroid/animation/ObjectAnimator;->setDuration(J)Landroid/animation/ObjectAnimator;

    .line 1025
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x12

    if-lt v1, v3, :cond_1

    .line 1026
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    invoke-virtual {v1, v2}, Landroid/animation/ObjectAnimator;->setAutoCancel(Z)V

    .line 1028
    :cond_1
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    invoke-virtual {v1}, Landroid/animation/ObjectAnimator;->start()V

    .line 1029
    return-void
.end method

.method private applyThumbTint()V
    .locals 2

    .line 692
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_3

    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    if-eqz v0, :cond_3

    .line 693
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    .line 695
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    if-eqz v0, :cond_1

    .line 696
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintList:Landroid/content/res/ColorStateList;

    invoke-static {v0, v1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintList(Landroid/graphics/drawable/Drawable;Landroid/content/res/ColorStateList;)V

    .line 699
    :cond_1
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    if-eqz v0, :cond_2

    .line 700
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    invoke-static {v0, v1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintMode(Landroid/graphics/drawable/Drawable;Landroid/graphics/PorterDuff$Mode;)V

    .line 705
    :cond_2
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 706
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getDrawableState()[I

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    .line 709
    :cond_3
    return-void
.end method

.method private applyTrackTint()V
    .locals 2

    .line 569
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_3

    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    if-eqz v0, :cond_3

    .line 570
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    .line 572
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    if-eqz v0, :cond_1

    .line 573
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintList:Landroid/content/res/ColorStateList;

    invoke-static {v0, v1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintList(Landroid/graphics/drawable/Drawable;Landroid/content/res/ColorStateList;)V

    .line 576
    :cond_1
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    if-eqz v0, :cond_2

    .line 577
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    invoke-static {v0, v1}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setTintMode(Landroid/graphics/drawable/Drawable;Landroid/graphics/PorterDuff$Mode;)V

    .line 582
    :cond_2
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 583
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getDrawableState()[I

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    .line 586
    :cond_3
    return-void
.end method

.method private cancelPositionAnimator()V
    .locals 1

    .line 1032
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    if-eqz v0, :cond_0

    .line 1033
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    invoke-virtual {v0}, Landroid/animation/ObjectAnimator;->cancel()V

    .line 1035
    :cond_0
    return-void
.end method

.method private cancelSuperTouch(Landroid/view/MotionEvent;)V
    .locals 2
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 982
    invoke-static {p1}, Landroid/view/MotionEvent;->obtain(Landroid/view/MotionEvent;)Landroid/view/MotionEvent;

    move-result-object v0

    .line 983
    .local v0, "cancel":Landroid/view/MotionEvent;
    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Landroid/view/MotionEvent;->setAction(I)V

    .line 984
    invoke-super {p0, v0}, Landroid/widget/CompoundButton;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 985
    invoke-virtual {v0}, Landroid/view/MotionEvent;->recycle()V

    .line 986
    return-void
.end method

.method private static constrain(FFF)F
    .locals 1
    .param p0, "amount"    # F
    .param p1, "low"    # F
    .param p2, "high"    # F

    .line 1418
    cmpg-float v0, p0, p1

    if-gez v0, :cond_0

    move v0, p1

    goto :goto_0

    :cond_0
    cmpl-float v0, p0, p2

    if-lez v0, :cond_1

    move v0, p2

    goto :goto_0

    :cond_1
    move v0, p0

    :goto_0
    return v0
.end method

.method private getTargetCheckedState()Z
    .locals 2

    .line 1038
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    const/high16 v1, 0x3f000000    # 0.5f

    cmpl-float v0, v0, v1

    if-lez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private getThumbOffset()I
    .locals 3

    .line 1291
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1292
    const/high16 v0, 0x3f800000    # 1.0f

    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    sub-float/2addr v0, v1

    .line 1292
    .local v0, "thumbPosition":F
    goto :goto_0

    .line 1294
    .end local v0    # "thumbPosition":F
    :cond_0
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    .line 1296
    .restart local v0    # "thumbPosition":F
    :goto_0
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->getThumbScrollRange()I

    move-result v1

    int-to-float v1, v1

    mul-float/2addr v1, v0

    const/high16 v2, 0x3f000000    # 0.5f

    add-float/2addr v1, v2

    float-to-int v1, v1

    return v1
.end method

.method private getThumbScrollRange()I
    .locals 4

    .line 1300
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_1

    .line 1301
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 1302
    .local v0, "padding":Landroid/graphics/Rect;
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1, v0}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 1305
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v1, :cond_0

    .line 1306
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v1}, Landroid/support/v7/widget/DrawableUtils;->getOpticalBounds(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Rect;

    move-result-object v1

    .line 1306
    .local v1, "insets":Landroid/graphics/Rect;
    goto :goto_0

    .line 1308
    .end local v1    # "insets":Landroid/graphics/Rect;
    :cond_0
    sget-object v1, Landroid/support/v7/widget/DrawableUtils;->INSETS_NONE:Landroid/graphics/Rect;

    .line 1311
    .restart local v1    # "insets":Landroid/graphics/Rect;
    :goto_0
    iget v2, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbWidth:I

    sub-int/2addr v2, v3

    iget v3, v0, Landroid/graphics/Rect;->left:I

    sub-int/2addr v2, v3

    iget v3, v0, Landroid/graphics/Rect;->right:I

    sub-int/2addr v2, v3

    iget v3, v1, Landroid/graphics/Rect;->left:I

    sub-int/2addr v2, v3

    iget v3, v1, Landroid/graphics/Rect;->right:I

    sub-int/2addr v2, v3

    return v2

    .line 1314
    .end local v0    # "padding":Landroid/graphics/Rect;
    .end local v1    # "insets":Landroid/graphics/Rect;
    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method private hitThumb(FF)Z
    .locals 7
    .param p1, "x"    # F
    .param p2, "y"    # F

    .line 886
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 887
    return v1

    .line 891
    :cond_0
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->getThumbOffset()I

    move-result v0

    .line 893
    .local v0, "thumbOffset":I
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 894
    iget v2, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTop:I

    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    sub-int/2addr v2, v3

    .line 895
    .local v2, "thumbTop":I
    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchLeft:I

    add-int/2addr v3, v0

    iget v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    sub-int/2addr v3, v4

    .line 896
    .local v3, "thumbLeft":I
    iget v4, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbWidth:I

    add-int/2addr v4, v3

    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->left:I

    add-int/2addr v4, v5

    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->right:I

    add-int/2addr v4, v5

    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    add-int/2addr v4, v5

    .line 898
    .local v4, "thumbRight":I
    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchBottom:I

    iget v6, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    add-int/2addr v5, v6

    .line 899
    .local v5, "thumbBottom":I
    int-to-float v6, v3

    cmpl-float v6, p1, v6

    if-lez v6, :cond_1

    int-to-float v6, v4

    cmpg-float v6, p1, v6

    if-gez v6, :cond_1

    int-to-float v6, v2

    cmpl-float v6, p2, v6

    if-lez v6, :cond_1

    int-to-float v6, v5

    cmpg-float v6, p2, v6

    if-gez v6, :cond_1

    const/4 v1, 0x1

    nop

    :cond_1
    return v1
.end method

.method private makeLayout(Ljava/lang/CharSequence;)Landroid/text/Layout;
    .locals 10
    .param p1, "text"    # Ljava/lang/CharSequence;

    .line 872
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTransformationMethod:Landroid/text/method/TransformationMethod;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTransformationMethod:Landroid/text/method/TransformationMethod;

    .line 873
    invoke-interface {v0, p1, p0}, Landroid/text/method/TransformationMethod;->getTransformation(Ljava/lang/CharSequence;Landroid/view/View;)Ljava/lang/CharSequence;

    move-result-object v0

    goto :goto_0

    :cond_0
    move-object v0, p1

    .line 876
    .local v0, "transformed":Ljava/lang/CharSequence;
    :goto_0
    new-instance v9, Landroid/text/StaticLayout;

    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    if-eqz v0, :cond_1

    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    .line 878
    invoke-static {v0, v1}, Landroid/text/Layout;->getDesiredWidth(Ljava/lang/CharSequence;Landroid/text/TextPaint;)F

    move-result v1

    float-to-double v1, v1

    invoke-static {v1, v2}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v1

    double-to-int v1, v1

    :goto_1
    move v4, v1

    goto :goto_2

    :cond_1
    const/4 v1, 0x0

    goto :goto_1

    :goto_2
    sget-object v5, Landroid/text/Layout$Alignment;->ALIGN_NORMAL:Landroid/text/Layout$Alignment;

    const/high16 v6, 0x3f800000    # 1.0f

    const/4 v7, 0x0

    const/4 v8, 0x1

    move-object v1, v9

    move-object v2, v0

    invoke-direct/range {v1 .. v8}, Landroid/text/StaticLayout;-><init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FFZ)V

    return-object v9
.end method

.method private setSwitchTypefaceByIndex(II)V
    .locals 1
    .param p1, "typefaceIndex"    # I
    .param p2, "styleIndex"    # I

    .line 337
    const/4 v0, 0x0

    .line 338
    .local v0, "tf":Landroid/graphics/Typeface;
    packed-switch p1, :pswitch_data_0

    goto :goto_0

    .line 348
    :pswitch_0
    sget-object v0, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    goto :goto_0

    .line 344
    :pswitch_1
    sget-object v0, Landroid/graphics/Typeface;->SERIF:Landroid/graphics/Typeface;

    .line 345
    goto :goto_0

    .line 340
    :pswitch_2
    sget-object v0, Landroid/graphics/Typeface;->SANS_SERIF:Landroid/graphics/Typeface;

    .line 341
    nop

    .line 352
    :goto_0
    invoke-virtual {p0, v0, p2}, Landroid/support/v7/widget/SwitchCompat;->setSwitchTypeface(Landroid/graphics/Typeface;I)V

    .line 353
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private stopDrag(Landroid/view/MotionEvent;)V
    .locals 7
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 994
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    .line 998
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_0

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isEnabled()Z

    move-result v1

    if-eqz v1, :cond_0

    move v1, v2

    goto :goto_0

    :cond_0
    move v1, v0

    .line 999
    .local v1, "commitChange":Z
    :goto_0
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v3

    .line 1001
    .local v3, "oldState":Z
    if-eqz v1, :cond_4

    .line 1002
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mVelocityTracker:Landroid/view/VelocityTracker;

    const/16 v5, 0x3e8

    invoke-virtual {v4, v5}, Landroid/view/VelocityTracker;->computeCurrentVelocity(I)V

    .line 1003
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v4}, Landroid/view/VelocityTracker;->getXVelocity()F

    move-result v4

    .line 1004
    .local v4, "xvel":F
    invoke-static {v4}, Ljava/lang/Math;->abs(F)F

    move-result v5

    iget v6, p0, Landroid/support/v7/widget/SwitchCompat;->mMinFlingVelocity:I

    int-to-float v6, v6

    cmpl-float v5, v5, v6

    if-lez v5, :cond_3

    .line 1005
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v5

    const/4 v6, 0x0

    if-eqz v5, :cond_2

    cmpg-float v5, v4, v6

    if-gez v5, :cond_1

    :goto_1
    goto :goto_2

    :cond_1
    move v2, v0

    goto :goto_2

    :cond_2
    cmpl-float v5, v4, v6

    if-lez v5, :cond_1

    goto :goto_1

    .line 1005
    .local v2, "newState":Z
    :goto_2
    goto :goto_3

    .line 1007
    .end local v2    # "newState":Z
    :cond_3
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->getTargetCheckedState()Z

    move-result v2

    .line 1009
    .end local v4    # "xvel":F
    .restart local v2    # "newState":Z
    :goto_3
    goto :goto_4

    .line 1010
    .end local v2    # "newState":Z
    :cond_4
    move v2, v3

    .line 1013
    .restart local v2    # "newState":Z
    :goto_4
    if-eq v2, v3, :cond_5

    .line 1014
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->playSoundEffect(I)V

    .line 1017
    :cond_5
    invoke-virtual {p0, v2}, Landroid/support/v7/widget/SwitchCompat;->setChecked(Z)V

    .line 1018
    invoke-direct {p0, p1}, Landroid/support/v7/widget/SwitchCompat;->cancelSuperTouch(Landroid/view/MotionEvent;)V

    .line 1019
    return-void
.end method


# virtual methods
.method public draw(Landroid/graphics/Canvas;)V
    .locals 13
    .param p1, "c"    # Landroid/graphics/Canvas;

    .line 1131
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 1132
    .local v0, "padding":Landroid/graphics/Rect;
    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchLeft:I

    .line 1133
    .local v1, "switchLeft":I
    iget v2, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTop:I

    .line 1134
    .local v2, "switchTop":I
    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchRight:I

    .line 1135
    .local v3, "switchRight":I
    iget v4, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchBottom:I

    .line 1137
    .local v4, "switchBottom":I
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->getThumbOffset()I

    move-result v5

    add-int/2addr v5, v1

    .line 1140
    .local v5, "thumbInitialLeft":I
    iget-object v6, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v6, :cond_0

    .line 1141
    iget-object v6, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v6}, Landroid/support/v7/widget/DrawableUtils;->getOpticalBounds(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Rect;

    move-result-object v6

    .line 1141
    .local v6, "thumbInsets":Landroid/graphics/Rect;
    goto :goto_0

    .line 1143
    .end local v6    # "thumbInsets":Landroid/graphics/Rect;
    :cond_0
    sget-object v6, Landroid/support/v7/widget/DrawableUtils;->INSETS_NONE:Landroid/graphics/Rect;

    .line 1147
    .restart local v6    # "thumbInsets":Landroid/graphics/Rect;
    :goto_0
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v7, :cond_5

    .line 1148
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v7, v0}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 1151
    iget v7, v0, Landroid/graphics/Rect;->left:I

    add-int/2addr v5, v7

    .line 1154
    move v7, v1

    .line 1155
    .local v7, "trackLeft":I
    move v8, v2

    .line 1156
    .local v8, "trackTop":I
    move v9, v3

    .line 1157
    .local v9, "trackRight":I
    move v10, v4

    .line 1158
    .local v10, "trackBottom":I
    if-eqz v6, :cond_4

    .line 1159
    iget v11, v6, Landroid/graphics/Rect;->left:I

    iget v12, v0, Landroid/graphics/Rect;->left:I

    if-le v11, v12, :cond_1

    .line 1160
    iget v11, v6, Landroid/graphics/Rect;->left:I

    iget v12, v0, Landroid/graphics/Rect;->left:I

    sub-int/2addr v11, v12

    add-int/2addr v7, v11

    .line 1162
    :cond_1
    iget v11, v6, Landroid/graphics/Rect;->top:I

    iget v12, v0, Landroid/graphics/Rect;->top:I

    if-le v11, v12, :cond_2

    .line 1163
    iget v11, v6, Landroid/graphics/Rect;->top:I

    iget v12, v0, Landroid/graphics/Rect;->top:I

    sub-int/2addr v11, v12

    add-int/2addr v8, v11

    .line 1165
    :cond_2
    iget v11, v6, Landroid/graphics/Rect;->right:I

    iget v12, v0, Landroid/graphics/Rect;->right:I

    if-le v11, v12, :cond_3

    .line 1166
    iget v11, v6, Landroid/graphics/Rect;->right:I

    iget v12, v0, Landroid/graphics/Rect;->right:I

    sub-int/2addr v11, v12

    sub-int/2addr v9, v11

    .line 1168
    :cond_3
    iget v11, v6, Landroid/graphics/Rect;->bottom:I

    iget v12, v0, Landroid/graphics/Rect;->bottom:I

    if-le v11, v12, :cond_4

    .line 1169
    iget v11, v6, Landroid/graphics/Rect;->bottom:I

    iget v12, v0, Landroid/graphics/Rect;->bottom:I

    sub-int/2addr v11, v12

    sub-int/2addr v10, v11

    .line 1172
    :cond_4
    iget-object v11, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v11, v7, v8, v9, v10}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 1176
    .end local v7    # "trackLeft":I
    .end local v8    # "trackTop":I
    .end local v9    # "trackRight":I
    .end local v10    # "trackBottom":I
    :cond_5
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v7, :cond_6

    .line 1177
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v7, v0}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 1179
    iget v7, v0, Landroid/graphics/Rect;->left:I

    sub-int v7, v5, v7

    .line 1180
    .local v7, "thumbLeft":I
    iget v8, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbWidth:I

    add-int/2addr v8, v5

    iget v9, v0, Landroid/graphics/Rect;->right:I

    add-int/2addr v8, v9

    .line 1181
    .local v8, "thumbRight":I
    iget-object v9, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v9, v7, v2, v8, v4}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 1183
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v9

    .line 1184
    .local v9, "background":Landroid/graphics/drawable/Drawable;
    if-eqz v9, :cond_6

    .line 1185
    invoke-static {v9, v7, v2, v8, v4}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setHotspotBounds(Landroid/graphics/drawable/Drawable;IIII)V

    .line 1191
    .end local v7    # "thumbLeft":I
    .end local v8    # "thumbRight":I
    .end local v9    # "background":Landroid/graphics/drawable/Drawable;
    :cond_6
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->draw(Landroid/graphics/Canvas;)V

    .line 1192
    return-void
.end method

.method public drawableHotspotChanged(FF)V
    .locals 2
    .param p1, "x"    # F
    .param p2, "y"    # F

    .line 1351
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_0

    .line 1352
    invoke-super {p0, p1, p2}, Landroid/widget/CompoundButton;->drawableHotspotChanged(FF)V

    .line 1355
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_1

    .line 1356
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v0, p1, p2}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setHotspot(Landroid/graphics/drawable/Drawable;FF)V

    .line 1359
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_2

    .line 1360
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v0, p1, p2}, Landroid/support/v4/graphics/drawable/DrawableCompat;->setHotspot(Landroid/graphics/drawable/Drawable;FF)V

    .line 1362
    :cond_2
    return-void
.end method

.method protected drawableStateChanged()V
    .locals 5

    .line 1329
    invoke-super {p0}, Landroid/widget/CompoundButton;->drawableStateChanged()V

    .line 1331
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getDrawableState()[I

    move-result-object v0

    .line 1332
    .local v0, "state":[I
    const/4 v1, 0x0

    .line 1334
    .local v1, "changed":Z
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    .line 1335
    .local v2, "thumbDrawable":Landroid/graphics/drawable/Drawable;
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 1336
    invoke-virtual {v2, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    move-result v3

    or-int/2addr v1, v3

    .line 1339
    :cond_0
    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    .line 1340
    .local v3, "trackDrawable":Landroid/graphics/drawable/Drawable;
    if-eqz v3, :cond_1

    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable;->isStateful()Z

    move-result v4

    if-eqz v4, :cond_1

    .line 1341
    invoke-virtual {v3, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    move-result v4

    or-int/2addr v1, v4

    .line 1344
    :cond_1
    if-eqz v1, :cond_2

    .line 1345
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->invalidate()V

    .line 1347
    :cond_2
    return-void
.end method

.method public getCompoundPaddingLeft()I
    .locals 2

    .line 1261
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1262
    invoke-super {p0}, Landroid/widget/CompoundButton;->getCompoundPaddingLeft()I

    move-result v0

    return v0

    .line 1264
    :cond_0
    invoke-super {p0}, Landroid/widget/CompoundButton;->getCompoundPaddingLeft()I

    move-result v0

    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    add-int/2addr v0, v1

    .line 1265
    .local v0, "padding":I
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 1266
    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchPadding:I

    add-int/2addr v0, v1

    .line 1268
    :cond_1
    return v0
.end method

.method public getCompoundPaddingRight()I
    .locals 2

    .line 1273
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1274
    invoke-super {p0}, Landroid/widget/CompoundButton;->getCompoundPaddingRight()I

    move-result v0

    return v0

    .line 1276
    :cond_0
    invoke-super {p0}, Landroid/widget/CompoundButton;->getCompoundPaddingRight()I

    move-result v0

    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    add-int/2addr v0, v1

    .line 1277
    .local v0, "padding":I
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 1278
    iget v1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchPadding:I

    add-int/2addr v0, v1

    .line 1280
    :cond_1
    return v0
.end method

.method public getShowText()Z
    .locals 1

    .line 790
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    return v0
.end method

.method public getSplitTrack()Z
    .locals 1

    .line 731
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mSplitTrack:Z

    return v0
.end method

.method public getSwitchMinWidth()I
    .locals 1

    .line 444
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchMinWidth:I

    return v0
.end method

.method public getSwitchPadding()I
    .locals 1

    .line 419
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchPadding:I

    return v0
.end method

.method public getTextOff()Ljava/lang/CharSequence;
    .locals 1

    .line 759
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    return-object v0
.end method

.method public getTextOn()Ljava/lang/CharSequence;
    .locals 1

    .line 740
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    return-object v0
.end method

.method public getThumbDrawable()Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 628
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    return-object v0
.end method

.method public getThumbTextPadding()I
    .locals 1

    .line 467
    iget v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTextPadding:I

    return v0
.end method

.method public getThumbTintList()Landroid/content/res/ColorStateList;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 659
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintList:Landroid/content/res/ColorStateList;

    return-object v0
.end method

.method public getThumbTintMode()Landroid/graphics/PorterDuff$Mode;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 688
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    return-object v0
.end method

.method public getTrackDrawable()Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 507
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    return-object v0
.end method

.method public getTrackTintList()Landroid/content/res/ColorStateList;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 537
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintList:Landroid/content/res/ColorStateList;

    return-object v0
.end method

.method public getTrackTintMode()Landroid/graphics/PorterDuff$Mode;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 565
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    return-object v0
.end method

.method public jumpDrawablesToCurrentState()V
    .locals 2

    .line 1371
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_2

    .line 1372
    invoke-super {p0}, Landroid/widget/CompoundButton;->jumpDrawablesToCurrentState()V

    .line 1374
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    .line 1375
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->jumpToCurrentState()V

    .line 1378
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_1

    .line 1379
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->jumpToCurrentState()V

    .line 1382
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    if-eqz v0, :cond_2

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    invoke-virtual {v0}, Landroid/animation/ObjectAnimator;->isStarted()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1383
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    invoke-virtual {v0}, Landroid/animation/ObjectAnimator;->end()V

    .line 1384
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mPositionAnimator:Landroid/animation/ObjectAnimator;

    .line 1387
    :cond_2
    return-void
.end method

.method protected onCreateDrawableState(I)[I
    .locals 2
    .param p1, "extraSpace"    # I

    .line 1320
    add-int/lit8 v0, p1, 0x1

    invoke-super {p0, v0}, Landroid/widget/CompoundButton;->onCreateDrawableState(I)[I

    move-result-object v0

    .line 1321
    .local v0, "drawableState":[I
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1322
    sget-object v1, Landroid/support/v7/widget/SwitchCompat;->CHECKED_STATE_SET:[I

    invoke-static {v0, v1}, Landroid/support/v7/widget/SwitchCompat;->mergeDrawableStates([I[I)[I

    .line 1324
    :cond_0
    return-object v0
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 17
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    .line 1196
    move-object/from16 v1, p1

    invoke-super/range {p0 .. p1}, Landroid/widget/CompoundButton;->onDraw(Landroid/graphics/Canvas;)V

    .line 1198
    iget-object v2, v0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 1199
    .local v2, "padding":Landroid/graphics/Rect;
    iget-object v3, v0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    .line 1200
    .local v3, "trackDrawable":Landroid/graphics/drawable/Drawable;
    if-eqz v3, :cond_0

    .line 1201
    invoke-virtual {v3, v2}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    goto :goto_0

    .line 1203
    :cond_0
    invoke-virtual {v2}, Landroid/graphics/Rect;->setEmpty()V

    .line 1206
    :goto_0
    iget v4, v0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTop:I

    .line 1207
    .local v4, "switchTop":I
    iget v5, v0, Landroid/support/v7/widget/SwitchCompat;->mSwitchBottom:I

    .line 1208
    .local v5, "switchBottom":I
    iget v6, v2, Landroid/graphics/Rect;->top:I

    add-int/2addr v6, v4

    .line 1209
    .local v6, "switchInnerTop":I
    iget v7, v2, Landroid/graphics/Rect;->bottom:I

    sub-int v7, v5, v7

    .line 1211
    .local v7, "switchInnerBottom":I
    iget-object v8, v0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    .line 1212
    .local v8, "thumbDrawable":Landroid/graphics/drawable/Drawable;
    if-eqz v3, :cond_2

    .line 1213
    iget-boolean v9, v0, Landroid/support/v7/widget/SwitchCompat;->mSplitTrack:Z

    if-eqz v9, :cond_1

    if-eqz v8, :cond_1

    .line 1214
    invoke-static {v8}, Landroid/support/v7/widget/DrawableUtils;->getOpticalBounds(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Rect;

    move-result-object v9

    .line 1215
    .local v9, "insets":Landroid/graphics/Rect;
    invoke-virtual {v8, v2}, Landroid/graphics/drawable/Drawable;->copyBounds(Landroid/graphics/Rect;)V

    .line 1216
    iget v10, v2, Landroid/graphics/Rect;->left:I

    iget v11, v9, Landroid/graphics/Rect;->left:I

    add-int/2addr v10, v11

    iput v10, v2, Landroid/graphics/Rect;->left:I

    .line 1217
    iget v10, v2, Landroid/graphics/Rect;->right:I

    iget v11, v9, Landroid/graphics/Rect;->right:I

    sub-int/2addr v10, v11

    iput v10, v2, Landroid/graphics/Rect;->right:I

    .line 1219
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Canvas;->save()I

    move-result v10

    .line 1220
    .local v10, "saveCount":I
    sget-object v11, Landroid/graphics/Region$Op;->DIFFERENCE:Landroid/graphics/Region$Op;

    invoke-virtual {v1, v2, v11}, Landroid/graphics/Canvas;->clipRect(Landroid/graphics/Rect;Landroid/graphics/Region$Op;)Z

    .line 1221
    invoke-virtual {v3, v1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 1222
    invoke-virtual {v1, v10}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 1223
    .end local v9    # "insets":Landroid/graphics/Rect;
    .end local v10    # "saveCount":I
    goto :goto_1

    .line 1224
    :cond_1
    invoke-virtual {v3, v1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 1228
    :cond_2
    :goto_1
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Canvas;->save()I

    move-result v9

    .line 1230
    .local v9, "saveCount":I
    if-eqz v8, :cond_3

    .line 1231
    invoke-virtual {v8, v1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 1234
    :cond_3
    invoke-direct/range {p0 .. p0}, Landroid/support/v7/widget/SwitchCompat;->getTargetCheckedState()Z

    move-result v10

    if-eqz v10, :cond_4

    iget-object v10, v0, Landroid/support/v7/widget/SwitchCompat;->mOnLayout:Landroid/text/Layout;

    goto :goto_2

    :cond_4
    iget-object v10, v0, Landroid/support/v7/widget/SwitchCompat;->mOffLayout:Landroid/text/Layout;

    .line 1235
    .local v10, "switchText":Landroid/text/Layout;
    :goto_2
    if-eqz v10, :cond_7

    .line 1236
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/SwitchCompat;->getDrawableState()[I

    move-result-object v11

    .line 1237
    .local v11, "drawableState":[I
    iget-object v12, v0, Landroid/support/v7/widget/SwitchCompat;->mTextColors:Landroid/content/res/ColorStateList;

    if-eqz v12, :cond_5

    .line 1238
    iget-object v12, v0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    iget-object v13, v0, Landroid/support/v7/widget/SwitchCompat;->mTextColors:Landroid/content/res/ColorStateList;

    const/4 v14, 0x0

    invoke-virtual {v13, v11, v14}, Landroid/content/res/ColorStateList;->getColorForState([II)I

    move-result v13

    invoke-virtual {v12, v13}, Landroid/text/TextPaint;->setColor(I)V

    .line 1240
    :cond_5
    iget-object v12, v0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    iput-object v11, v12, Landroid/text/TextPaint;->drawableState:[I

    .line 1243
    if-eqz v8, :cond_6

    .line 1244
    invoke-virtual {v8}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v12

    .line 1245
    .local v12, "bounds":Landroid/graphics/Rect;
    iget v13, v12, Landroid/graphics/Rect;->left:I

    iget v14, v12, Landroid/graphics/Rect;->right:I

    add-int/2addr v13, v14

    .line 1246
    .end local v12    # "bounds":Landroid/graphics/Rect;
    .local v13, "cX":I
    goto :goto_3

    .line 1247
    .end local v13    # "cX":I
    :cond_6
    invoke-virtual/range {p0 .. p0}, Landroid/support/v7/widget/SwitchCompat;->getWidth()I

    move-result v13

    .line 1247
    .restart local v13    # "cX":I
    :goto_3
    move v12, v13

    .line 1250
    .end local v13    # "cX":I
    .local v12, "cX":I
    div-int/lit8 v13, v12, 0x2

    invoke-virtual {v10}, Landroid/text/Layout;->getWidth()I

    move-result v14

    div-int/lit8 v14, v14, 0x2

    sub-int/2addr v13, v14

    .line 1251
    .local v13, "left":I
    add-int v14, v6, v7

    div-int/lit8 v14, v14, 0x2

    invoke-virtual {v10}, Landroid/text/Layout;->getHeight()I

    move-result v15

    div-int/lit8 v15, v15, 0x2

    sub-int/2addr v14, v15

    .line 1252
    .local v14, "top":I
    int-to-float v15, v13

    int-to-float v0, v14

    invoke-virtual {v1, v15, v0}, Landroid/graphics/Canvas;->translate(FF)V

    .line 1253
    invoke-virtual {v10, v1}, Landroid/text/Layout;->draw(Landroid/graphics/Canvas;)V

    .line 1256
    .end local v11    # "drawableState":[I
    .end local v12    # "cX":I
    .end local v13    # "left":I
    .end local v14    # "top":I
    :cond_7
    invoke-virtual {v1, v9}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 1257
    return-void
.end method

.method public onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 1
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 1391
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->onInitializeAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V

    .line 1392
    const-string v0, "android.widget.Switch"

    invoke-virtual {p1, v0}, Landroid/view/accessibility/AccessibilityEvent;->setClassName(Ljava/lang/CharSequence;)V

    .line 1393
    return-void
.end method

.method public onInitializeAccessibilityNodeInfo(Landroid/view/accessibility/AccessibilityNodeInfo;)V
    .locals 4
    .param p1, "info"    # Landroid/view/accessibility/AccessibilityNodeInfo;

    .line 1397
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_2

    .line 1398
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->onInitializeAccessibilityNodeInfo(Landroid/view/accessibility/AccessibilityNodeInfo;)V

    .line 1399
    const-string v0, "android.widget.Switch"

    invoke-virtual {p1, v0}, Landroid/view/accessibility/AccessibilityNodeInfo;->setClassName(Ljava/lang/CharSequence;)V

    .line 1400
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    goto :goto_0

    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    .line 1401
    .local v0, "switchText":Ljava/lang/CharSequence;
    :goto_0
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 1402
    invoke-virtual {p1}, Landroid/view/accessibility/AccessibilityNodeInfo;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    .line 1403
    .local v1, "oldText":Ljava/lang/CharSequence;
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1404
    invoke-virtual {p1, v0}, Landroid/view/accessibility/AccessibilityNodeInfo;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 1406
    :cond_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 1407
    .local v2, "newText":Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;

    const/16 v3, 0x20

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;

    .line 1408
    invoke-virtual {p1, v2}, Landroid/view/accessibility/AccessibilityNodeInfo;->setText(Ljava/lang/CharSequence;)V

    .line 1412
    .end local v0    # "switchText":Ljava/lang/CharSequence;
    .end local v1    # "oldText":Ljava/lang/CharSequence;
    .end local v2    # "newText":Ljava/lang/StringBuilder;
    :cond_2
    :goto_1
    return-void
.end method

.method protected onLayout(ZIIII)V
    .locals 7
    .param p1, "changed"    # Z
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "right"    # I
    .param p5, "bottom"    # I

    .line 1075
    invoke-super/range {p0 .. p5}, Landroid/widget/CompoundButton;->onLayout(ZIIII)V

    .line 1077
    const/4 v0, 0x0

    .line 1078
    .local v0, "opticalInsetLeft":I
    const/4 v1, 0x0

    .line 1079
    .local v1, "opticalInsetRight":I
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v2, :cond_1

    .line 1080
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 1081
    .local v2, "trackPadding":Landroid/graphics/Rect;
    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v3, :cond_0

    .line 1082
    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v3, v2}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    goto :goto_0

    .line 1084
    :cond_0
    invoke-virtual {v2}, Landroid/graphics/Rect;->setEmpty()V

    .line 1087
    :goto_0
    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v3}, Landroid/support/v7/widget/DrawableUtils;->getOpticalBounds(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Rect;

    move-result-object v3

    .line 1088
    .local v3, "insets":Landroid/graphics/Rect;
    iget v4, v3, Landroid/graphics/Rect;->left:I

    iget v5, v2, Landroid/graphics/Rect;->left:I

    sub-int/2addr v4, v5

    const/4 v5, 0x0

    invoke-static {v5, v4}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 1089
    iget v4, v3, Landroid/graphics/Rect;->right:I

    iget v6, v2, Landroid/graphics/Rect;->right:I

    sub-int/2addr v4, v6

    invoke-static {v5, v4}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 1094
    .end local v2    # "trackPadding":Landroid/graphics/Rect;
    .end local v3    # "insets":Landroid/graphics/Rect;
    :cond_1
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 1095
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingLeft()I

    move-result v2

    add-int/2addr v2, v0

    .line 1096
    .local v2, "switchLeft":I
    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    add-int/2addr v3, v2

    sub-int/2addr v3, v0

    sub-int/2addr v3, v1

    .line 1096
    .local v3, "switchRight":I
    goto :goto_1

    .line 1098
    .end local v2    # "switchLeft":I
    .end local v3    # "switchRight":I
    :cond_2
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getWidth()I

    move-result v2

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingRight()I

    move-result v3

    sub-int/2addr v2, v3

    sub-int v3, v2, v1

    .line 1099
    .restart local v3    # "switchRight":I
    iget v2, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    sub-int v2, v3, v2

    add-int/2addr v2, v0

    add-int/2addr v2, v1

    .line 1104
    .restart local v2    # "switchLeft":I
    :goto_1
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getGravity()I

    move-result v4

    and-int/lit8 v4, v4, 0x70

    const/16 v5, 0x10

    if-eq v4, v5, :cond_4

    const/16 v5, 0x50

    if-eq v4, v5, :cond_3

    .line 1107
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingTop()I

    move-result v4

    .line 1108
    .local v4, "switchTop":I
    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchHeight:I

    add-int/2addr v5, v4

    .line 1109
    .local v5, "switchBottom":I
    goto :goto_2

    .line 1118
    .end local v4    # "switchTop":I
    .end local v5    # "switchBottom":I
    :cond_3
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getHeight()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingBottom()I

    move-result v5

    sub-int v5, v4, v5

    .line 1119
    .restart local v5    # "switchBottom":I
    iget v4, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchHeight:I

    sub-int v4, v5, v4

    .line 1119
    .restart local v4    # "switchTop":I
    goto :goto_2

    .line 1112
    .end local v4    # "switchTop":I
    .end local v5    # "switchBottom":I
    :cond_4
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingTop()I

    move-result v4

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getHeight()I

    move-result v5

    add-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getPaddingBottom()I

    move-result v5

    sub-int/2addr v4, v5

    div-int/lit8 v4, v4, 0x2

    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchHeight:I

    div-int/lit8 v5, v5, 0x2

    sub-int/2addr v4, v5

    .line 1114
    .restart local v4    # "switchTop":I
    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchHeight:I

    add-int/2addr v5, v4

    .line 1115
    .restart local v5    # "switchBottom":I
    nop

    .line 1123
    :goto_2
    iput v2, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchLeft:I

    .line 1124
    iput v4, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTop:I

    .line 1125
    iput v5, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchBottom:I

    .line 1126
    iput v3, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchRight:I

    .line 1127
    return-void
.end method

.method public onMeasure(II)V
    .locals 11
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 795
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    if-eqz v0, :cond_1

    .line 796
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mOnLayout:Landroid/text/Layout;

    if-nez v0, :cond_0

    .line 797
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    invoke-direct {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->makeLayout(Ljava/lang/CharSequence;)Landroid/text/Layout;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mOnLayout:Landroid/text/Layout;

    .line 800
    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mOffLayout:Landroid/text/Layout;

    if-nez v0, :cond_1

    .line 801
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    invoke-direct {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->makeLayout(Ljava/lang/CharSequence;)Landroid/text/Layout;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mOffLayout:Landroid/text/Layout;

    .line 805
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTempRect:Landroid/graphics/Rect;

    .line 808
    .local v0, "padding":Landroid/graphics/Rect;
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    const/4 v2, 0x0

    if-eqz v1, :cond_2

    .line 810
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1, v0}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 811
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v1

    iget v3, v0, Landroid/graphics/Rect;->left:I

    sub-int/2addr v1, v3

    iget v3, v0, Landroid/graphics/Rect;->right:I

    sub-int/2addr v1, v3

    .line 812
    .local v1, "thumbWidth":I
    iget-object v3, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v3

    .line 812
    .local v3, "thumbHeight":I
    goto :goto_0

    .line 814
    .end local v1    # "thumbWidth":I
    .end local v3    # "thumbHeight":I
    :cond_2
    const/4 v1, 0x0

    .line 815
    .restart local v1    # "thumbWidth":I
    move v3, v2

    .line 819
    .restart local v3    # "thumbHeight":I
    :goto_0
    iget-boolean v4, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    if-eqz v4, :cond_3

    .line 820
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mOnLayout:Landroid/text/Layout;

    invoke-virtual {v4}, Landroid/text/Layout;->getWidth()I

    move-result v4

    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mOffLayout:Landroid/text/Layout;

    invoke-virtual {v5}, Landroid/text/Layout;->getWidth()I

    move-result v5

    invoke-static {v4, v5}, Ljava/lang/Math;->max(II)I

    move-result v4

    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTextPadding:I

    mul-int/lit8 v5, v5, 0x2

    add-int/2addr v4, v5

    .line 820
    .local v4, "maxTextWidth":I
    goto :goto_1

    .line 823
    .end local v4    # "maxTextWidth":I
    :cond_3
    move v4, v2

    .line 826
    .restart local v4    # "maxTextWidth":I
    :goto_1
    invoke-static {v4, v1}, Ljava/lang/Math;->max(II)I

    move-result v5

    iput v5, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbWidth:I

    .line 829
    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v5, :cond_4

    .line 830
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v2, v0}, Landroid/graphics/drawable/Drawable;->getPadding(Landroid/graphics/Rect;)Z

    .line 831
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v2

    .line 831
    .local v2, "trackHeight":I
    goto :goto_2

    .line 833
    .end local v2    # "trackHeight":I
    :cond_4
    invoke-virtual {v0}, Landroid/graphics/Rect;->setEmpty()V

    .line 834
    nop

    .line 839
    .restart local v2    # "trackHeight":I
    :goto_2
    iget v5, v0, Landroid/graphics/Rect;->left:I

    .line 840
    .local v5, "paddingLeft":I
    iget v6, v0, Landroid/graphics/Rect;->right:I

    .line 841
    .local v6, "paddingRight":I
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v7, :cond_5

    .line 842
    iget-object v7, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    invoke-static {v7}, Landroid/support/v7/widget/DrawableUtils;->getOpticalBounds(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Rect;

    move-result-object v7

    .line 843
    .local v7, "inset":Landroid/graphics/Rect;
    iget v8, v7, Landroid/graphics/Rect;->left:I

    invoke-static {v5, v8}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 844
    iget v8, v7, Landroid/graphics/Rect;->right:I

    invoke-static {v6, v8}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 847
    .end local v7    # "inset":Landroid/graphics/Rect;
    :cond_5
    iget v7, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchMinWidth:I

    iget v8, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbWidth:I

    mul-int/lit8 v8, v8, 0x2

    add-int/2addr v8, v5

    add-int/2addr v8, v6

    invoke-static {v7, v8}, Ljava/lang/Math;->max(II)I

    move-result v7

    .line 849
    .local v7, "switchWidth":I
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v8

    .line 850
    .local v8, "switchHeight":I
    iput v7, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchWidth:I

    .line 851
    iput v8, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchHeight:I

    .line 853
    invoke-super {p0, p1, p2}, Landroid/widget/CompoundButton;->onMeasure(II)V

    .line 855
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getMeasuredHeight()I

    move-result v9

    .line 856
    .local v9, "measuredHeight":I
    if-ge v9, v8, :cond_6

    .line 857
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getMeasuredWidthAndState()I

    move-result v10

    invoke-virtual {p0, v10, v8}, Landroid/support/v7/widget/SwitchCompat;->setMeasuredDimension(II)V

    .line 859
    :cond_6
    return-void
.end method

.method public onPopulateAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 2
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 863
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->onPopulateAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V

    .line 865
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    goto :goto_0

    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    .line 866
    .local v0, "text":Ljava/lang/CharSequence;
    :goto_0
    if-eqz v0, :cond_1

    .line 867
    invoke-virtual {p1}, Landroid/view/accessibility/AccessibilityEvent;->getText()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 869
    :cond_1
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 9
    .param p1, "ev"    # Landroid/view/MotionEvent;

    .line 904
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 905
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 906
    .local v0, "action":I
    const/4 v1, 0x2

    const/4 v2, 0x1

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_2

    .line 919
    :pswitch_0
    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    packed-switch v3, :pswitch_data_1

    goto :goto_1

    .line 939
    :pswitch_1
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    .line 940
    .local v1, "x":F
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->getThumbScrollRange()I

    move-result v3

    .line 941
    .local v3, "thumbScrollRange":I
    iget v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchX:F

    sub-float v4, v1, v4

    .line 943
    .local v4, "thumbScrollOffset":F
    const/high16 v5, 0x3f800000    # 1.0f

    const/4 v6, 0x0

    if-eqz v3, :cond_0

    .line 944
    int-to-float v7, v3

    div-float v7, v4, v7

    .line 944
    .local v7, "dPos":F
    goto :goto_0

    .line 948
    .end local v7    # "dPos":F
    :cond_0
    cmpl-float v7, v4, v6

    if-lez v7, :cond_1

    move v7, v5

    goto :goto_0

    :cond_1
    const/high16 v7, -0x40800000    # -1.0f

    .line 950
    .restart local v7    # "dPos":F
    :goto_0
    invoke-static {p0}, Landroid/support/v7/widget/ViewUtils;->isLayoutRtl(Landroid/view/View;)Z

    move-result v8

    if-eqz v8, :cond_2

    .line 951
    neg-float v7, v7

    .line 953
    :cond_2
    iget v8, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    add-float/2addr v8, v7

    invoke-static {v8, v6, v5}, Landroid/support/v7/widget/SwitchCompat;->constrain(FFF)F

    move-result v5

    .line 954
    .local v5, "newPos":F
    iget v6, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    cmpl-float v6, v5, v6

    if-eqz v6, :cond_3

    .line 955
    iput v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchX:F

    .line 956
    invoke-virtual {p0, v5}, Landroid/support/v7/widget/SwitchCompat;->setThumbPosition(F)V

    .line 958
    :cond_3
    return v2

    .line 925
    .end local v1    # "x":F
    .end local v3    # "thumbScrollRange":I
    .end local v4    # "thumbScrollOffset":F
    .end local v5    # "newPos":F
    .end local v7    # "dPos":F
    :pswitch_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v3

    .line 926
    .local v3, "x":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v4

    .line 927
    .local v4, "y":F
    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchX:F

    sub-float v5, v3, v5

    invoke-static {v5}, Ljava/lang/Math;->abs(F)F

    move-result v5

    iget v6, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    int-to-float v6, v6

    cmpl-float v5, v5, v6

    if-gtz v5, :cond_4

    iget v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchY:F

    sub-float v5, v4, v5

    .line 928
    invoke-static {v5}, Ljava/lang/Math;->abs(F)F

    move-result v5

    iget v6, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchSlop:I

    int-to-float v6, v6

    cmpl-float v5, v5, v6

    if-lez v5, :cond_5

    .line 929
    :cond_4
    iput v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    .line 930
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    invoke-interface {v1, v2}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 931
    iput v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchX:F

    .line 932
    iput v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchY:F

    .line 933
    return v2

    .line 922
    .end local v3    # "x":F
    .end local v4    # "y":F
    :pswitch_3
    nop

    .line 961
    :cond_5
    :goto_1
    goto :goto_2

    .line 966
    :pswitch_4
    iget v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    if-ne v3, v1, :cond_6

    .line 967
    invoke-direct {p0, p1}, Landroid/support/v7/widget/SwitchCompat;->stopDrag(Landroid/view/MotionEvent;)V

    .line 969
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 970
    return v2

    .line 972
    :cond_6
    const/4 v1, 0x0

    iput v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    .line 973
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v1}, Landroid/view/VelocityTracker;->clear()V

    goto :goto_2

    .line 908
    :pswitch_5
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    .line 909
    .restart local v1    # "x":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v3

    .line 910
    .local v3, "y":F
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isEnabled()Z

    move-result v4

    if-eqz v4, :cond_7

    invoke-direct {p0, v1, v3}, Landroid/support/v7/widget/SwitchCompat;->hitThumb(FF)Z

    move-result v4

    if-eqz v4, :cond_7

    .line 911
    iput v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchMode:I

    .line 912
    iput v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchX:F

    .line 913
    iput v3, p0, Landroid/support/v7/widget/SwitchCompat;->mTouchY:F

    .line 978
    .end local v1    # "x":F
    .end local v3    # "y":F
    :cond_7
    :goto_2
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v1

    return v1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_5
        :pswitch_4
        :pswitch_0
        :pswitch_4
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public setChecked(Z)V
    .locals 1
    .param p1, "checked"    # Z

    .line 1058
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->setChecked(Z)V

    .line 1062
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result p1

    .line 1064
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getWindowToken()Landroid/os/IBinder;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {p0}, Landroid/support/v4/view/ViewCompat;->isLaidOut(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1065
    invoke-direct {p0, p1}, Landroid/support/v7/widget/SwitchCompat;->animateThumbToCheckedState(Z)V

    goto :goto_1

    .line 1068
    :cond_0
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->cancelPositionAnimator()V

    .line 1069
    if-eqz p1, :cond_1

    const/high16 v0, 0x3f800000    # 1.0f

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->setThumbPosition(F)V

    .line 1071
    :goto_1
    return-void
.end method

.method public setShowText(Z)V
    .locals 1
    .param p1, "showText"    # Z

    .line 779
    iget-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    if-eq v0, p1, :cond_0

    .line 780
    iput-boolean p1, p0, Landroid/support/v7/widget/SwitchCompat;->mShowText:Z

    .line 781
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 783
    :cond_0
    return-void
.end method

.method public setSplitTrack(Z)V
    .locals 0
    .param p1, "splitTrack"    # Z

    .line 721
    iput-boolean p1, p0, Landroid/support/v7/widget/SwitchCompat;->mSplitTrack:Z

    .line 722
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->invalidate()V

    .line 723
    return-void
.end method

.method public setSwitchMinWidth(I)V
    .locals 0
    .param p1, "pixels"    # I

    .line 431
    iput p1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchMinWidth:I

    .line 432
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 433
    return-void
.end method

.method public setSwitchPadding(I)V
    .locals 0
    .param p1, "pixels"    # I

    .line 407
    iput p1, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchPadding:I

    .line 408
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 409
    return-void
.end method

.method public setSwitchTextAppearance(Landroid/content/Context;I)V
    .locals 8
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "resid"    # I

    .line 298
    sget-object v0, Landroid/support/v7/appcompat/R$styleable;->TextAppearance:[I

    invoke-static {p1, p2, v0}, Landroid/support/v7/widget/TintTypedArray;->obtainStyledAttributes(Landroid/content/Context;I[I)Landroid/support/v7/widget/TintTypedArray;

    move-result-object v0

    .line 304
    .local v0, "appearance":Landroid/support/v7/widget/TintTypedArray;
    sget v1, Landroid/support/v7/appcompat/R$styleable;->TextAppearance_android_textColor:I

    invoke-virtual {v0, v1}, Landroid/support/v7/widget/TintTypedArray;->getColorStateList(I)Landroid/content/res/ColorStateList;

    move-result-object v1

    .line 305
    .local v1, "colors":Landroid/content/res/ColorStateList;
    if-eqz v1, :cond_0

    .line 306
    iput-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextColors:Landroid/content/res/ColorStateList;

    goto :goto_0

    .line 309
    :cond_0
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v2

    iput-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTextColors:Landroid/content/res/ColorStateList;

    .line 312
    :goto_0
    sget v2, Landroid/support/v7/appcompat/R$styleable;->TextAppearance_android_textSize:I

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Landroid/support/v7/widget/TintTypedArray;->getDimensionPixelSize(II)I

    move-result v2

    .line 313
    .local v2, "ts":I
    if-eqz v2, :cond_1

    .line 314
    int-to-float v4, v2

    iget-object v5, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v5}, Landroid/text/TextPaint;->getTextSize()F

    move-result v5

    cmpl-float v4, v4, v5

    if-eqz v4, :cond_1

    .line 315
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    int-to-float v5, v2

    invoke-virtual {v4, v5}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 316
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 321
    :cond_1
    sget v4, Landroid/support/v7/appcompat/R$styleable;->TextAppearance_android_typeface:I

    const/4 v5, -0x1

    invoke-virtual {v0, v4, v5}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v4

    .line 322
    .local v4, "typefaceIndex":I
    sget v6, Landroid/support/v7/appcompat/R$styleable;->TextAppearance_android_textStyle:I

    invoke-virtual {v0, v6, v5}, Landroid/support/v7/widget/TintTypedArray;->getInt(II)I

    move-result v5

    .line 324
    .local v5, "styleIndex":I
    invoke-direct {p0, v4, v5}, Landroid/support/v7/widget/SwitchCompat;->setSwitchTypefaceByIndex(II)V

    .line 326
    sget v6, Landroid/support/v7/appcompat/R$styleable;->TextAppearance_textAllCaps:I

    invoke-virtual {v0, v6, v3}, Landroid/support/v7/widget/TintTypedArray;->getBoolean(IZ)Z

    move-result v3

    .line 327
    .local v3, "allCaps":Z
    if-eqz v3, :cond_2

    .line 328
    new-instance v6, Landroid/support/v7/text/AllCapsTransformationMethod;

    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-direct {v6, v7}, Landroid/support/v7/text/AllCapsTransformationMethod;-><init>(Landroid/content/Context;)V

    iput-object v6, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTransformationMethod:Landroid/text/method/TransformationMethod;

    goto :goto_1

    .line 330
    :cond_2
    const/4 v6, 0x0

    iput-object v6, p0, Landroid/support/v7/widget/SwitchCompat;->mSwitchTransformationMethod:Landroid/text/method/TransformationMethod;

    .line 333
    :goto_1
    invoke-virtual {v0}, Landroid/support/v7/widget/TintTypedArray;->recycle()V

    .line 334
    return-void
.end method

.method public setSwitchTypeface(Landroid/graphics/Typeface;)V
    .locals 1
    .param p1, "typeface"    # Landroid/graphics/Typeface;

    .line 390
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v0}, Landroid/text/TextPaint;->getTypeface()Landroid/graphics/Typeface;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v0}, Landroid/text/TextPaint;->getTypeface()Landroid/graphics/Typeface;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/graphics/Typeface;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    .line 391
    invoke-virtual {v0}, Landroid/text/TextPaint;->getTypeface()Landroid/graphics/Typeface;

    move-result-object v0

    if-nez v0, :cond_2

    if-eqz p1, :cond_2

    .line 392
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v0, p1}, Landroid/text/TextPaint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 394
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 395
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->invalidate()V

    .line 397
    :cond_2
    return-void
.end method

.method public setSwitchTypeface(Landroid/graphics/Typeface;I)V
    .locals 6
    .param p1, "tf"    # Landroid/graphics/Typeface;
    .param p2, "style"    # I

    .line 362
    const/4 v0, 0x0

    const/4 v1, 0x0

    if-lez p2, :cond_4

    .line 363
    if-nez p1, :cond_0

    .line 364
    invoke-static {p2}, Landroid/graphics/Typeface;->defaultFromStyle(I)Landroid/graphics/Typeface;

    move-result-object p1

    goto :goto_0

    .line 366
    :cond_0
    invoke-static {p1, p2}, Landroid/graphics/Typeface;->create(Landroid/graphics/Typeface;I)Landroid/graphics/Typeface;

    move-result-object p1

    .line 369
    :goto_0
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/SwitchCompat;->setSwitchTypeface(Landroid/graphics/Typeface;)V

    .line 371
    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/graphics/Typeface;->getStyle()I

    move-result v2

    goto :goto_1

    :cond_1
    move v2, v1

    .line 372
    .local v2, "typefaceStyle":I
    :goto_1
    not-int v3, v2

    and-int/2addr v3, p2

    .line 373
    .local v3, "need":I
    iget-object v4, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    and-int/lit8 v5, v3, 0x1

    if-eqz v5, :cond_2

    const/4 v1, 0x1

    nop

    :cond_2
    invoke-virtual {v4, v1}, Landroid/text/TextPaint;->setFakeBoldText(Z)V

    .line 374
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    and-int/lit8 v4, v3, 0x2

    if-eqz v4, :cond_3

    const/high16 v0, -0x41800000    # -0.25f

    nop

    :cond_3
    invoke-virtual {v1, v0}, Landroid/text/TextPaint;->setTextSkewX(F)V

    .line 375
    .end local v2    # "typefaceStyle":I
    .end local v3    # "need":I
    goto :goto_2

    .line 376
    :cond_4
    iget-object v2, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v2, v1}, Landroid/text/TextPaint;->setFakeBoldText(Z)V

    .line 377
    iget-object v1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v1, v0}, Landroid/text/TextPaint;->setTextSkewX(F)V

    .line 378
    invoke-virtual {p0, p1}, Landroid/support/v7/widget/SwitchCompat;->setSwitchTypeface(Landroid/graphics/Typeface;)V

    .line 380
    :goto_2
    return-void
.end method

.method public setTextOff(Ljava/lang/CharSequence;)V
    .locals 0
    .param p1, "textOff"    # Ljava/lang/CharSequence;

    .line 768
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOff:Ljava/lang/CharSequence;

    .line 769
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 770
    return-void
.end method

.method public setTextOn(Ljava/lang/CharSequence;)V
    .locals 0
    .param p1, "textOn"    # Ljava/lang/CharSequence;

    .line 749
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mTextOn:Ljava/lang/CharSequence;

    .line 750
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 751
    return-void
.end method

.method public setThumbDrawable(Landroid/graphics/drawable/Drawable;)V
    .locals 2
    .param p1, "thumb"    # Landroid/graphics/drawable/Drawable;

    .line 597
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    .line 598
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 600
    :cond_0
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    .line 601
    if-eqz p1, :cond_1

    .line 602
    invoke-virtual {p1, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 604
    :cond_1
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 605
    return-void
.end method

.method setThumbPosition(F)V
    .locals 0
    .param p1, "position"    # F

    .line 1047
    iput p1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbPosition:F

    .line 1048
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->invalidate()V

    .line 1049
    return-void
.end method

.method public setThumbResource(I)V
    .locals 1
    .param p1, "resId"    # I

    .line 616
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Landroid/support/v7/content/res/AppCompatResources;->getDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->setThumbDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 617
    return-void
.end method

.method public setThumbTextPadding(I)V
    .locals 0
    .param p1, "pixels"    # I

    .line 455
    iput p1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTextPadding:I

    .line 456
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 457
    return-void
.end method

.method public setThumbTintList(Landroid/content/res/ColorStateList;)V
    .locals 1
    .param p1, "tint"    # Landroid/content/res/ColorStateList;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 646
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintList:Landroid/content/res/ColorStateList;

    .line 647
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTint:Z

    .line 649
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyThumbTint()V

    .line 650
    return-void
.end method

.method public setThumbTintMode(Landroid/graphics/PorterDuff$Mode;)V
    .locals 1
    .param p1, "tintMode"    # Landroid/graphics/PorterDuff$Mode;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 674
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 675
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasThumbTintMode:Z

    .line 677
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyThumbTint()V

    .line 678
    return-void
.end method

.method public setTrackDrawable(Landroid/graphics/drawable/Drawable;)V
    .locals 2
    .param p1, "track"    # Landroid/graphics/drawable/Drawable;

    .line 478
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    .line 479
    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 481
    :cond_0
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

    .line 482
    if-eqz p1, :cond_1

    .line 483
    invoke-virtual {p1, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V

    .line 485
    :cond_1
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->requestLayout()V

    .line 486
    return-void
.end method

.method public setTrackResource(I)V
    .locals 1
    .param p1, "resId"    # I

    .line 496
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Landroid/support/v7/content/res/AppCompatResources;->getDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->setTrackDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 497
    return-void
.end method

.method public setTrackTintList(Landroid/content/res/ColorStateList;)V
    .locals 1
    .param p1, "tint"    # Landroid/content/res/ColorStateList;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 524
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintList:Landroid/content/res/ColorStateList;

    .line 525
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTint:Z

    .line 527
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyTrackTint()V

    .line 528
    return-void
.end method

.method public setTrackTintMode(Landroid/graphics/PorterDuff$Mode;)V
    .locals 1
    .param p1, "tintMode"    # Landroid/graphics/PorterDuff$Mode;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param

    .line 551
    iput-object p1, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackTintMode:Landroid/graphics/PorterDuff$Mode;

    .line 552
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/SwitchCompat;->mHasTrackTintMode:Z

    .line 554
    invoke-direct {p0}, Landroid/support/v7/widget/SwitchCompat;->applyTrackTint()V

    .line 555
    return-void
.end method

.method public toggle()V
    .locals 1

    .line 1053
    invoke-virtual {p0}, Landroid/support/v7/widget/SwitchCompat;->isChecked()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Landroid/support/v7/widget/SwitchCompat;->setChecked(Z)V

    .line 1054
    return-void
.end method

.method protected verifyDrawable(Landroid/graphics/drawable/Drawable;)Z
    .locals 1
    .param p1, "who"    # Landroid/graphics/drawable/Drawable;

    .line 1366
    invoke-super {p0, p1}, Landroid/widget/CompoundButton;->verifyDrawable(Landroid/graphics/drawable/Drawable;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mThumbDrawable:Landroid/graphics/drawable/Drawable;

    if-eq p1, v0, :cond_1

    iget-object v0, p0, Landroid/support/v7/widget/SwitchCompat;->mTrackDrawable:Landroid/graphics/drawable/Drawable;

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
