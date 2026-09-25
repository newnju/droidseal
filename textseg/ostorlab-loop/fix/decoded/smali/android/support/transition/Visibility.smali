.class public abstract Landroid/support/transition/Visibility;
.super Landroid/support/transition/Transition;
.source "Visibility.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/transition/Visibility$DisappearListener;,
        Landroid/support/transition/Visibility$VisibilityInfo;,
        Landroid/support/transition/Visibility$Mode;
    }
.end annotation


# static fields
.field public static final MODE_IN:I = 0x1

.field public static final MODE_OUT:I = 0x2

.field private static final PROPNAME_PARENT:Ljava/lang/String; = "android:visibility:parent"

.field private static final PROPNAME_SCREEN_LOCATION:Ljava/lang/String; = "android:visibility:screenLocation"

.field static final PROPNAME_VISIBILITY:Ljava/lang/String; = "android:visibility:visibility"

.field private static final sTransitionProperties:[Ljava/lang/String;


# instance fields
.field private mMode:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 78
    const-string v0, "android:visibility:visibility"

    const-string v1, "android:visibility:parent"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Landroid/support/transition/Visibility;->sTransitionProperties:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 94
    invoke-direct {p0}, Landroid/support/transition/Transition;-><init>()V

    .line 92
    const/4 v0, 0x3

    iput v0, p0, Landroid/support/transition/Visibility;->mMode:I

    .line 95
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 98
    invoke-direct {p0, p1, p2}, Landroid/support/transition/Transition;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 92
    const/4 v0, 0x3

    iput v0, p0, Landroid/support/transition/Visibility;->mMode:I

    .line 99
    sget-object v0, Landroid/support/transition/Styleable;->VISIBILITY_TRANSITION:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object v0

    .line 101
    .local v0, "a":Landroid/content/res/TypedArray;
    move-object v1, p2

    check-cast v1, Landroid/content/res/XmlResourceParser;

    const-string v2, "transitionVisibilityMode"

    const/4 v3, 0x0

    invoke-static {v0, v1, v2, v3, v3}, Landroid/support/v4/content/res/TypedArrayUtils;->getNamedInt(Landroid/content/res/TypedArray;Lorg/xmlpull/v1/XmlPullParser;Ljava/lang/String;II)I

    move-result v1

    .line 104
    .local v1, "mode":I
    invoke-virtual {v0}, Landroid/content/res/TypedArray;->recycle()V

    .line 105
    if-eqz v1, :cond_0

    .line 106
    invoke-virtual {p0, v1}, Landroid/support/transition/Visibility;->setMode(I)V

    .line 108
    :cond_0
    return-void
.end method

.method private captureValues(Landroid/support/transition/TransitionValues;)V
    .locals 4
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;

    .line 142
    iget-object v0, p1, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v0

    .line 143
    .local v0, "visibility":I
    iget-object v1, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v2, "android:visibility:visibility"

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 144
    iget-object v1, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v2, "android:visibility:parent"

    iget-object v3, p1, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 145
    const/4 v1, 0x2

    new-array v1, v1, [I

    .line 146
    .local v1, "loc":[I
    iget-object v2, p1, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    invoke-virtual {v2, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 147
    iget-object v2, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:visibility:screenLocation"

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 148
    return-void
.end method

.method private getVisibilityChangeInfo(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/support/transition/Visibility$VisibilityInfo;
    .locals 6
    .param p1, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p2, "endValues"    # Landroid/support/transition/TransitionValues;

    .line 187
    new-instance v0, Landroid/support/transition/Visibility$VisibilityInfo;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Landroid/support/transition/Visibility$VisibilityInfo;-><init>(Landroid/support/transition/Visibility$1;)V

    .line 188
    .local v0, "visInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    const/4 v2, 0x0

    iput-boolean v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    .line 189
    iput-boolean v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 190
    const/4 v3, -0x1

    if-eqz p1, :cond_0

    iget-object v4, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v5, "android:visibility:visibility"

    invoke-interface {v4, v5}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 191
    iget-object v4, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v5, "android:visibility:visibility"

    invoke-interface {v4, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    iput v4, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    .line 192
    iget-object v4, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v5, "android:visibility:parent"

    invoke-interface {v4, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/ViewGroup;

    iput-object v4, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartParent:Landroid/view/ViewGroup;

    goto :goto_0

    .line 194
    :cond_0
    iput v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    .line 195
    iput-object v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartParent:Landroid/view/ViewGroup;

    .line 197
    :goto_0
    if-eqz p2, :cond_1

    iget-object v4, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v5, "android:visibility:visibility"

    invoke-interface {v4, v5}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 198
    iget-object v1, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:visibility:visibility"

    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    iput v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    .line 199
    iget-object v1, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:visibility:parent"

    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    iput-object v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndParent:Landroid/view/ViewGroup;

    goto :goto_1

    .line 201
    :cond_1
    iput v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    .line 202
    iput-object v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndParent:Landroid/view/ViewGroup;

    .line 204
    :goto_1
    const/4 v1, 0x1

    if-eqz p1, :cond_6

    if-eqz p2, :cond_6

    .line 205
    iget v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    iget v4, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    if-ne v3, v4, :cond_2

    iget-object v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartParent:Landroid/view/ViewGroup;

    iget-object v4, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndParent:Landroid/view/ViewGroup;

    if-ne v3, v4, :cond_2

    .line 207
    return-object v0

    .line 209
    :cond_2
    iget v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    iget v4, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    if-eq v3, v4, :cond_4

    .line 210
    iget v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    if-nez v3, :cond_3

    .line 211
    iput-boolean v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 212
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    goto :goto_2

    .line 213
    :cond_3
    iget v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    if-nez v2, :cond_8

    .line 214
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 215
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    goto :goto_2

    .line 219
    :cond_4
    iget-object v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndParent:Landroid/view/ViewGroup;

    if-nez v3, :cond_5

    .line 220
    iput-boolean v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 221
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    goto :goto_2

    .line 222
    :cond_5
    iget-object v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartParent:Landroid/view/ViewGroup;

    if-nez v2, :cond_8

    .line 223
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 224
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    goto :goto_2

    .line 228
    :cond_6
    if-nez p1, :cond_7

    iget v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    if-nez v3, :cond_7

    .line 229
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 230
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    goto :goto_2

    .line 231
    :cond_7
    if-nez p2, :cond_8

    iget v3, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    if-nez v3, :cond_8

    .line 232
    iput-boolean v2, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    .line 233
    iput-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    .line 235
    :cond_8
    :goto_2
    return-object v0
.end method


# virtual methods
.method public captureEndValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 157
    invoke-direct {p0, p1}, Landroid/support/transition/Visibility;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 158
    return-void
.end method

.method public captureStartValues(Landroid/support/transition/TransitionValues;)V
    .locals 0
    .param p1, "transitionValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param

    .line 152
    invoke-direct {p0, p1}, Landroid/support/transition/Visibility;->captureValues(Landroid/support/transition/TransitionValues;)V

    .line 153
    return-void
.end method

.method public createAnimator(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 8
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "startValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param
    .param p3, "endValues"    # Landroid/support/transition/TransitionValues;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 242
    invoke-direct {p0, p2, p3}, Landroid/support/transition/Visibility;->getVisibilityChangeInfo(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/support/transition/Visibility$VisibilityInfo;

    move-result-object v0

    .line 243
    .local v0, "visInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    iget-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    if-eqz v1, :cond_2

    iget-object v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartParent:Landroid/view/ViewGroup;

    if-nez v1, :cond_0

    iget-object v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndParent:Landroid/view/ViewGroup;

    if-eqz v1, :cond_2

    .line 245
    :cond_0
    iget-boolean v1, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mFadeIn:Z

    if-eqz v1, :cond_1

    .line 246
    iget v5, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    iget v7, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move-object v6, p3

    invoke-virtual/range {v2 .. v7}, Landroid/support/transition/Visibility;->onAppear(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;ILandroid/support/transition/TransitionValues;I)Landroid/animation/Animator;

    move-result-object v1

    return-object v1

    .line 249
    :cond_1
    iget v5, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    iget v7, v0, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move-object v6, p3

    invoke-virtual/range {v2 .. v7}, Landroid/support/transition/Visibility;->onDisappear(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;ILandroid/support/transition/TransitionValues;I)Landroid/animation/Animator;

    move-result-object v1

    return-object v1

    .line 254
    :cond_2
    const/4 v1, 0x0

    return-object v1
.end method

.method public getMode()I
    .locals 1

    .line 132
    iget v0, p0, Landroid/support/transition/Visibility;->mMode:I

    return v0
.end method

.method public getTransitionProperties()[Ljava/lang/String;
    .locals 1
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 138
    sget-object v0, Landroid/support/transition/Visibility;->sTransitionProperties:[Ljava/lang/String;

    return-object v0
.end method

.method public isTransitionRequired(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Z
    .locals 4
    .param p1, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p2, "newValues"    # Landroid/support/transition/TransitionValues;

    .line 455
    const/4 v0, 0x0

    if-nez p1, :cond_0

    if-nez p2, :cond_0

    .line 456
    return v0

    .line 458
    :cond_0
    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    iget-object v1, p2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v2, "android:visibility:visibility"

    .line 459
    invoke-interface {v1, v2}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    iget-object v2, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:visibility:visibility"

    .line 460
    invoke-interface {v2, v3}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eq v1, v2, :cond_1

    .line 463
    return v0

    .line 465
    :cond_1
    invoke-direct {p0, p1, p2}, Landroid/support/transition/Visibility;->getVisibilityChangeInfo(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/support/transition/Visibility$VisibilityInfo;

    move-result-object v1

    .line 466
    .local v1, "changeInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    iget-boolean v2, v1, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    if-eqz v2, :cond_3

    iget v2, v1, Landroid/support/transition/Visibility$VisibilityInfo;->mStartVisibility:I

    if-eqz v2, :cond_2

    iget v2, v1, Landroid/support/transition/Visibility$VisibilityInfo;->mEndVisibility:I

    if-nez v2, :cond_3

    :cond_2
    const/4 v0, 0x1

    nop

    :cond_3
    return v0
.end method

.method public isVisible(Landroid/support/transition/TransitionValues;)Z
    .locals 4
    .param p1, "values"    # Landroid/support/transition/TransitionValues;

    .line 176
    const/4 v0, 0x0

    if-nez p1, :cond_0

    .line 177
    return v0

    .line 179
    :cond_0
    iget-object v1, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v2, "android:visibility:visibility"

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 180
    .local v1, "visibility":I
    iget-object v2, p1, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v3, "android:visibility:parent"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 182
    .local v2, "parent":Landroid/view/View;
    if-nez v1, :cond_1

    if-eqz v2, :cond_1

    const/4 v0, 0x1

    nop

    :cond_1
    return v0
.end method

.method public onAppear(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;ILandroid/support/transition/TransitionValues;I)Landroid/animation/Animator;
    .locals 6
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p3, "startVisibility"    # I
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;
    .param p5, "endVisibility"    # I

    .line 275
    iget v0, p0, Landroid/support/transition/Visibility;->mMode:I

    const/4 v1, 0x1

    and-int/2addr v0, v1

    const/4 v2, 0x0

    if-ne v0, v1, :cond_2

    if-nez p4, :cond_0

    goto :goto_0

    .line 278
    :cond_0
    if-nez p2, :cond_1

    .line 279
    iget-object v0, p4, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 280
    .local v0, "endParent":Landroid/view/View;
    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/support/transition/Visibility;->getMatchedTransitionValues(Landroid/view/View;Z)Landroid/support/transition/TransitionValues;

    move-result-object v3

    .line 282
    .local v3, "startParentValues":Landroid/support/transition/TransitionValues;
    invoke-virtual {p0, v0, v1}, Landroid/support/transition/Visibility;->getTransitionValues(Landroid/view/View;Z)Landroid/support/transition/TransitionValues;

    move-result-object v1

    .line 283
    .local v1, "endParentValues":Landroid/support/transition/TransitionValues;
    nop

    .line 284
    invoke-direct {p0, v3, v1}, Landroid/support/transition/Visibility;->getVisibilityChangeInfo(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/support/transition/Visibility$VisibilityInfo;

    move-result-object v4

    .line 285
    .local v4, "parentVisibilityInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    iget-boolean v5, v4, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    if-eqz v5, :cond_1

    .line 286
    return-object v2

    .line 289
    .end local v0    # "endParent":Landroid/view/View;
    .end local v1    # "endParentValues":Landroid/support/transition/TransitionValues;
    .end local v3    # "startParentValues":Landroid/support/transition/TransitionValues;
    .end local v4    # "parentVisibilityInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    :cond_1
    iget-object v0, p4, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    invoke-virtual {p0, p1, v0, p2, p4}, Landroid/support/transition/Visibility;->onAppear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;

    move-result-object v0

    return-object v0

    .line 276
    :cond_2
    :goto_0
    return-object v2
.end method

.method public onAppear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 1
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "view"    # Landroid/view/View;
    .param p3, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;

    .line 311
    const/4 v0, 0x0

    return-object v0
.end method

.method public onDisappear(Landroid/view/ViewGroup;Landroid/support/transition/TransitionValues;ILandroid/support/transition/TransitionValues;I)Landroid/animation/Animator;
    .locals 20
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p3, "startVisibility"    # I
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;
    .param p5, "endVisibility"    # I

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v3, p4

    .line 332
    iget v4, v0, Landroid/support/transition/Visibility;->mMode:I

    const/4 v5, 0x2

    and-int/2addr v4, v5

    const/4 v6, 0x0

    if-eq v4, v5, :cond_0

    .line 333
    return-object v6

    .line 336
    :cond_0
    if-eqz v2, :cond_1

    iget-object v4, v2, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    goto :goto_0

    :cond_1
    move-object v4, v6

    .line 337
    .local v4, "startView":Landroid/view/View;
    :goto_0
    if-eqz v3, :cond_2

    iget-object v7, v3, Landroid/support/transition/TransitionValues;->view:Landroid/view/View;

    goto :goto_1

    :cond_2
    move-object v7, v6

    .line 338
    .local v7, "endView":Landroid/view/View;
    :goto_1
    const/4 v8, 0x0

    .line 339
    .local v8, "overlayView":Landroid/view/View;
    const/4 v9, 0x0

    .line 340
    .local v9, "viewToKeep":Landroid/view/View;
    const/4 v10, 0x1

    if-eqz v7, :cond_6

    invoke-virtual {v7}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v11

    if-nez v11, :cond_3

    goto :goto_2

    .line 375
    :cond_3
    const/4 v11, 0x4

    move/from16 v12, p5

    if-ne v12, v11, :cond_4

    .line 376
    move-object v9, v7

    goto :goto_3

    .line 379
    :cond_4
    if-ne v4, v7, :cond_5

    .line 380
    move-object v9, v7

    goto :goto_3

    .line 382
    :cond_5
    move-object v8, v4

    goto :goto_3

    .line 341
    :cond_6
    :goto_2
    move/from16 v12, p5

    if-eqz v7, :cond_7

    .line 343
    move-object v8, v7

    goto :goto_3

    .line 344
    :cond_7
    if-eqz v4, :cond_a

    .line 348
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v11

    if-nez v11, :cond_8

    .line 350
    move-object v8, v4

    goto :goto_3

    .line 351
    :cond_8
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v11

    instance-of v11, v11, Landroid/view/View;

    if-eqz v11, :cond_a

    .line 352
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v11

    check-cast v11, Landroid/view/View;

    .line 353
    .local v11, "startParent":Landroid/view/View;
    invoke-virtual {v0, v11, v10}, Landroid/support/transition/Visibility;->getTransitionValues(Landroid/view/View;Z)Landroid/support/transition/TransitionValues;

    move-result-object v13

    .line 354
    .local v13, "startParentValues":Landroid/support/transition/TransitionValues;
    invoke-virtual {v0, v11, v10}, Landroid/support/transition/Visibility;->getMatchedTransitionValues(Landroid/view/View;Z)Landroid/support/transition/TransitionValues;

    move-result-object v14

    .line 356
    .local v14, "endParentValues":Landroid/support/transition/TransitionValues;
    nop

    .line 357
    invoke-direct {v0, v13, v14}, Landroid/support/transition/Visibility;->getVisibilityChangeInfo(Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/support/transition/Visibility$VisibilityInfo;

    move-result-object v15

    .line 358
    .local v15, "parentVisibilityInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    iget-boolean v6, v15, Landroid/support/transition/Visibility$VisibilityInfo;->mVisibilityChange:Z

    if-nez v6, :cond_9

    .line 359
    invoke-static {v1, v4, v11}, Landroid/support/transition/TransitionUtils;->copyViewImage(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/View;)Landroid/view/View;

    move-result-object v6

    .line 371
    .end local v8    # "overlayView":Landroid/view/View;
    .local v6, "overlayView":Landroid/view/View;
    move-object v8, v6

    goto :goto_3

    .line 361
    .end local v6    # "overlayView":Landroid/view/View;
    .restart local v8    # "overlayView":Landroid/view/View;
    :cond_9
    invoke-virtual {v11}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v6

    if-nez v6, :cond_a

    .line 362
    invoke-virtual {v11}, Landroid/view/View;->getId()I

    move-result v6

    .line 363
    .local v6, "id":I
    const/4 v5, -0x1

    if-eq v6, v5, :cond_a

    invoke-virtual {v1, v6}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v5

    if-eqz v5, :cond_a

    iget-boolean v5, v0, Landroid/support/transition/Visibility;->mCanRemoveViews:Z

    if-eqz v5, :cond_a

    .line 368
    move-object v5, v4

    .line 371
    .end local v6    # "id":I
    .end local v8    # "overlayView":Landroid/view/View;
    .end local v11    # "startParent":Landroid/view/View;
    .end local v13    # "startParentValues":Landroid/support/transition/TransitionValues;
    .end local v14    # "endParentValues":Landroid/support/transition/TransitionValues;
    .end local v15    # "parentVisibilityInfo":Landroid/support/transition/Visibility$VisibilityInfo;
    .local v5, "overlayView":Landroid/view/View;
    move-object v8, v5

    .line 386
    .end local v5    # "overlayView":Landroid/view/View;
    .restart local v8    # "overlayView":Landroid/view/View;
    :cond_a
    :goto_3
    move v5, v12

    .line 388
    .local v5, "finalVisibility":I
    const/4 v6, 0x0

    if-eqz v8, :cond_c

    if-eqz v2, :cond_c

    .line 390
    iget-object v11, v2, Landroid/support/transition/TransitionValues;->values:Ljava/util/Map;

    const-string v13, "android:visibility:screenLocation"

    invoke-interface {v11, v13}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, [I

    .line 391
    .local v11, "screenLoc":[I
    aget v13, v11, v6

    .line 392
    .local v13, "screenX":I
    aget v14, v11, v10

    .line 393
    .local v14, "screenY":I
    const/4 v15, 0x2

    new-array v15, v15, [I

    .line 394
    .local v15, "loc":[I
    invoke-virtual {v1, v15}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 395
    aget v6, v15, v6

    sub-int v6, v13, v6

    invoke-virtual {v8}, Landroid/view/View;->getLeft()I

    move-result v16

    sub-int v6, v6, v16

    invoke-virtual {v8, v6}, Landroid/view/View;->offsetLeftAndRight(I)V

    .line 396
    aget v6, v15, v10

    sub-int v6, v14, v6

    invoke-virtual {v8}, Landroid/view/View;->getTop()I

    move-result v10

    sub-int/2addr v6, v10

    invoke-virtual {v8, v6}, Landroid/view/View;->offsetTopAndBottom(I)V

    .line 397
    invoke-static/range {p1 .. p1}, Landroid/support/transition/ViewGroupUtils;->getOverlay(Landroid/view/ViewGroup;)Landroid/support/transition/ViewGroupOverlayImpl;

    move-result-object v6

    .line 398
    .local v6, "overlay":Landroid/support/transition/ViewGroupOverlayImpl;
    invoke-interface {v6, v8}, Landroid/support/transition/ViewGroupOverlayImpl;->add(Landroid/view/View;)V

    .line 399
    invoke-virtual {v0, v1, v8, v2, v3}, Landroid/support/transition/Visibility;->onDisappear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;

    move-result-object v10

    .line 400
    .local v10, "animator":Landroid/animation/Animator;
    if-nez v10, :cond_b

    .line 401
    invoke-interface {v6, v8}, Landroid/support/transition/ViewGroupOverlayImpl;->remove(Landroid/view/View;)V

    .line 411
    move-object/from16 v18, v4

    move-object/from16 v19, v7

    goto :goto_4

    .line 403
    :cond_b
    move-object/from16 v17, v8

    .line 404
    .local v17, "finalOverlayView":Landroid/view/View;
    move-object/from16 v18, v4

    new-instance v4, Landroid/support/transition/Visibility$1;

    .line 404
    .end local v4    # "startView":Landroid/view/View;
    .local v18, "startView":Landroid/view/View;
    move-object/from16 v19, v7

    move-object/from16 v7, v17

    invoke-direct {v4, v0, v6, v7}, Landroid/support/transition/Visibility$1;-><init>(Landroid/support/transition/Visibility;Landroid/support/transition/ViewGroupOverlayImpl;Landroid/view/View;)V

    .line 404
    .end local v17    # "finalOverlayView":Landroid/view/View;
    .local v7, "finalOverlayView":Landroid/view/View;
    .local v19, "endView":Landroid/view/View;
    invoke-virtual {v10, v4}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 411
    .end local v7    # "finalOverlayView":Landroid/view/View;
    :goto_4
    return-object v10

    .line 414
    .end local v6    # "overlay":Landroid/support/transition/ViewGroupOverlayImpl;
    .end local v10    # "animator":Landroid/animation/Animator;
    .end local v11    # "screenLoc":[I
    .end local v13    # "screenX":I
    .end local v14    # "screenY":I
    .end local v15    # "loc":[I
    .end local v18    # "startView":Landroid/view/View;
    .end local v19    # "endView":Landroid/view/View;
    .restart local v4    # "startView":Landroid/view/View;
    .local v7, "endView":Landroid/view/View;
    :cond_c
    move-object/from16 v18, v4

    move-object/from16 v19, v7

    .line 414
    .end local v4    # "startView":Landroid/view/View;
    .end local v7    # "endView":Landroid/view/View;
    .restart local v18    # "startView":Landroid/view/View;
    .restart local v19    # "endView":Landroid/view/View;
    if-eqz v9, :cond_e

    .line 415
    invoke-virtual {v9}, Landroid/view/View;->getVisibility()I

    move-result v4

    .line 416
    .local v4, "originalVisibility":I
    invoke-static {v9, v6}, Landroid/support/transition/ViewUtils;->setTransitionVisibility(Landroid/view/View;I)V

    .line 417
    invoke-virtual {v0, v1, v9, v2, v3}, Landroid/support/transition/Visibility;->onDisappear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;

    move-result-object v6

    .line 418
    .local v6, "animator":Landroid/animation/Animator;
    if-eqz v6, :cond_d

    .line 419
    new-instance v7, Landroid/support/transition/Visibility$DisappearListener;

    invoke-direct {v7, v9, v5, v10}, Landroid/support/transition/Visibility$DisappearListener;-><init>(Landroid/view/View;IZ)V

    .line 421
    .local v7, "disappearListener":Landroid/support/transition/Visibility$DisappearListener;
    invoke-virtual {v6, v7}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 422
    invoke-static {v6, v7}, Landroid/support/transition/AnimatorUtils;->addPauseListener(Landroid/animation/Animator;Landroid/animation/AnimatorListenerAdapter;)V

    .line 423
    invoke-virtual {v0, v7}, Landroid/support/transition/Visibility;->addListener(Landroid/support/transition/Transition$TransitionListener;)Landroid/support/transition/Transition;

    .line 424
    .end local v7    # "disappearListener":Landroid/support/transition/Visibility$DisappearListener;
    goto :goto_5

    .line 425
    :cond_d
    invoke-static {v9, v4}, Landroid/support/transition/ViewUtils;->setTransitionVisibility(Landroid/view/View;I)V

    .line 427
    :goto_5
    return-object v6

    .line 429
    .end local v4    # "originalVisibility":I
    .end local v6    # "animator":Landroid/animation/Animator;
    :cond_e
    const/4 v4, 0x0

    return-object v4
.end method

.method public onDisappear(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/transition/TransitionValues;Landroid/support/transition/TransitionValues;)Landroid/animation/Animator;
    .locals 1
    .param p1, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p2, "view"    # Landroid/view/View;
    .param p3, "startValues"    # Landroid/support/transition/TransitionValues;
    .param p4, "endValues"    # Landroid/support/transition/TransitionValues;

    .line 450
    const/4 v0, 0x0

    return-object v0
.end method

.method public setMode(I)V
    .locals 2
    .param p1, "mode"    # I

    .line 118
    and-int/lit8 v0, p1, -0x4

    if-eqz v0, :cond_0

    .line 119
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Only MODE_IN and MODE_OUT flags are allowed"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 121
    :cond_0
    iput p1, p0, Landroid/support/transition/Visibility;->mMode:I

    .line 122
    return-void
.end method
