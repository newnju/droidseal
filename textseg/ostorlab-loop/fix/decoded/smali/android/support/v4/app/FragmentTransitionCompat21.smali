.class Landroid/support/v4/app/FragmentTransitionCompat21;
.super Ljava/lang/Object;
.source "FragmentTransitionCompat21.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x15
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Ljava/util/Map;
    .param p1, "x1"    # Ljava/lang/String;

    .line 32
    invoke-static {p0, p1}, Landroid/support/v4/app/FragmentTransitionCompat21;->findKeyForValue(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static addTarget(Ljava/lang/Object;Landroid/view/View;)V
    .locals 1
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .param p1, "view"    # Landroid/view/View;

    .line 523
    if-eqz p0, :cond_0

    .line 524
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 525
    .local v0, "transition":Landroid/transition/Transition;
    invoke-virtual {v0, p1}, Landroid/transition/Transition;->addTarget(Landroid/view/View;)Landroid/transition/Transition;

    .line 527
    .end local v0    # "transition":Landroid/transition/Transition;
    :cond_0
    return-void
.end method

.method public static addTargets(Ljava/lang/Object;Ljava/util/ArrayList;)V
    .locals 5
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 154
    .local p1, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 155
    .local v0, "transition":Landroid/transition/Transition;
    if-nez v0, :cond_0

    .line 156
    return-void

    .line 158
    :cond_0
    instance-of v1, v0, Landroid/transition/TransitionSet;

    const/4 v2, 0x0

    if-eqz v1, :cond_2

    .line 159
    move-object v1, v0

    check-cast v1, Landroid/transition/TransitionSet;

    .line 160
    .local v1, "set":Landroid/transition/TransitionSet;
    invoke-virtual {v1}, Landroid/transition/TransitionSet;->getTransitionCount()I

    move-result v3

    .line 161
    .local v3, "numTransitions":I
    nop

    .line 161
    .local v2, "i":I
    :goto_0
    if-ge v2, v3, :cond_1

    .line 162
    invoke-virtual {v1, v2}, Landroid/transition/TransitionSet;->getTransitionAt(I)Landroid/transition/Transition;

    move-result-object v4

    .line 163
    .local v4, "child":Landroid/transition/Transition;
    invoke-static {v4, p1}, Landroid/support/v4/app/FragmentTransitionCompat21;->addTargets(Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 161
    .end local v4    # "child":Landroid/transition/Transition;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 165
    .end local v1    # "set":Landroid/transition/TransitionSet;
    .end local v2    # "i":I
    .end local v3    # "numTransitions":I
    :cond_1
    goto :goto_2

    :cond_2
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->hasSimpleTarget(Landroid/transition/Transition;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 166
    invoke-virtual {v0}, Landroid/transition/Transition;->getTargets()Ljava/util/List;

    move-result-object v1

    .line 167
    .local v1, "targets":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    invoke-static {v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->isNullOrEmpty(Ljava/util/List;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 169
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 170
    .local v3, "numViews":I
    nop

    .line 170
    .restart local v2    # "i":I
    :goto_1
    if-ge v2, v3, :cond_3

    .line 171
    invoke-virtual {p1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/View;

    invoke-virtual {v0, v4}, Landroid/transition/Transition;->addTarget(Landroid/view/View;)Landroid/transition/Transition;

    .line 170
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 175
    .end local v1    # "targets":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    .end local v2    # "i":I
    .end local v3    # "numViews":I
    :cond_3
    :goto_2
    return-void
.end method

.method public static beginDelayedTransition(Landroid/view/ViewGroup;Ljava/lang/Object;)V
    .locals 1
    .param p0, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p1, "transition"    # Ljava/lang/Object;

    .line 292
    move-object v0, p1

    check-cast v0, Landroid/transition/Transition;

    invoke-static {p0, v0}, Landroid/transition/TransitionManager;->beginDelayedTransition(Landroid/view/ViewGroup;Landroid/transition/Transition;)V

    .line 293
    return-void
.end method

.method private static bfsAddViewChildren(Ljava/util/List;Landroid/view/View;)V
    .locals 8
    .param p1, "startView"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;",
            "Landroid/view/View;",
            ")V"
        }
    .end annotation

    .line 84
    .local p0, "views":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    .line 85
    .local v0, "startIndex":I
    invoke-static {p0, p1, v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->containedBeforeIndex(Ljava/util/List;Landroid/view/View;I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 86
    return-void

    .line 88
    :cond_0
    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 89
    move v1, v0

    .line 89
    .local v1, "index":I
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_3

    .line 90
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 91
    .local v2, "view":Landroid/view/View;
    instance-of v3, v2, Landroid/view/ViewGroup;

    if-eqz v3, :cond_2

    .line 92
    move-object v3, v2

    check-cast v3, Landroid/view/ViewGroup;

    .line 93
    .local v3, "viewGroup":Landroid/view/ViewGroup;
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v4

    .line 94
    .local v4, "childCount":I
    const/4 v5, 0x0

    .line 94
    .local v5, "childIndex":I
    :goto_1
    if-ge v5, v4, :cond_2

    .line 95
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v6

    .line 96
    .local v6, "child":Landroid/view/View;
    invoke-static {p0, v6, v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->containedBeforeIndex(Ljava/util/List;Landroid/view/View;I)Z

    move-result v7

    if-nez v7, :cond_1

    .line 97
    invoke-interface {p0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 94
    .end local v6    # "child":Landroid/view/View;
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 89
    .end local v2    # "view":Landroid/view/View;
    .end local v3    # "viewGroup":Landroid/view/ViewGroup;
    .end local v4    # "childCount":I
    .end local v5    # "childIndex":I
    :cond_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 102
    .end local v1    # "index":I
    :cond_3
    return-void
.end method

.method public static captureTransitioningViews(Ljava/util/ArrayList;Landroid/view/View;)V
    .locals 4
    .param p1, "view"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Landroid/view/View;",
            ")V"
        }
    .end annotation

    .line 362
    .local p0, "transitioningViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_3

    .line 363
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 364
    move-object v0, p1

    check-cast v0, Landroid/view/ViewGroup;

    .line 365
    .local v0, "viewGroup":Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->isTransitionGroup()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 366
    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 368
    :cond_0
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    .line 369
    .local v1, "count":I
    const/4 v2, 0x0

    .line 369
    .local v2, "i":I
    :goto_0
    if-ge v2, v1, :cond_1

    .line 370
    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 371
    .local v3, "child":Landroid/view/View;
    invoke-static {p0, v3}, Landroid/support/v4/app/FragmentTransitionCompat21;->captureTransitioningViews(Ljava/util/ArrayList;Landroid/view/View;)V

    .line 369
    .end local v3    # "child":Landroid/view/View;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 374
    .end local v0    # "viewGroup":Landroid/view/ViewGroup;
    .end local v1    # "count":I
    .end local v2    # "i":I
    :cond_1
    :goto_1
    goto :goto_2

    .line 375
    :cond_2
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 378
    :cond_3
    :goto_2
    return-void
.end method

.method public static cloneTransition(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2
    .param p0, "transition"    # Ljava/lang/Object;

    .line 38
    const/4 v0, 0x0

    .line 39
    .local v0, "copy":Landroid/transition/Transition;
    if-eqz p0, :cond_0

    .line 40
    move-object v1, p0

    check-cast v1, Landroid/transition/Transition;

    invoke-virtual {v1}, Landroid/transition/Transition;->clone()Landroid/transition/Transition;

    move-result-object v0

    .line 42
    :cond_0
    return-object v0
.end method

.method private static containedBeforeIndex(Ljava/util/List;Landroid/view/View;I)Z
    .locals 3
    .param p1, "view"    # Landroid/view/View;
    .param p2, "maxIndex"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;",
            "Landroid/view/View;",
            "I)Z"
        }
    .end annotation

    .line 109
    .local p0, "views":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    const/4 v0, 0x0

    move v1, v0

    .line 109
    .local v1, "i":I
    :goto_0
    if-ge v1, p2, :cond_1

    .line 110
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    if-ne v2, p1, :cond_0

    .line 111
    const/4 v0, 0x1

    return v0

    .line 109
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 114
    .end local v1    # "i":I
    :cond_1
    return v0
.end method

.method private static findKeyForValue(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p1, "value"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 423
    .local p0, "map":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-interface {p0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 424
    .local v1, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 425
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    return-object v0

    .line 427
    .end local v1    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    :cond_0
    goto :goto_0

    .line 428
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method public static findNamedViews(Ljava/util/Map;Landroid/view/View;)V
    .locals 5
    .param p1, "view"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;",
            "Landroid/view/View;",
            ")V"
        }
    .end annotation

    .line 385
    .local p0, "namedViews":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Landroid/view/View;>;"
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_1

    .line 386
    invoke-virtual {p1}, Landroid/view/View;->getTransitionName()Ljava/lang/String;

    move-result-object v0

    .line 387
    .local v0, "transitionName":Ljava/lang/String;
    if-eqz v0, :cond_0

    .line 388
    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 390
    :cond_0
    instance-of v1, p1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_1

    .line 391
    move-object v1, p1

    check-cast v1, Landroid/view/ViewGroup;

    .line 392
    .local v1, "viewGroup":Landroid/view/ViewGroup;
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    .line 393
    .local v2, "count":I
    const/4 v3, 0x0

    .line 393
    .local v3, "i":I
    :goto_0
    if-ge v3, v2, :cond_1

    .line 394
    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    .line 395
    .local v4, "child":Landroid/view/View;
    invoke-static {p0, v4}, Landroid/support/v4/app/FragmentTransitionCompat21;->findNamedViews(Ljava/util/Map;Landroid/view/View;)V

    .line 393
    .end local v4    # "child":Landroid/view/View;
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 399
    .end local v0    # "transitionName":Ljava/lang/String;
    .end local v1    # "viewGroup":Landroid/view/ViewGroup;
    .end local v2    # "count":I
    .end local v3    # "i":I
    :cond_1
    return-void
.end method

.method public static getBoundsOnScreen(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 6
    .param p0, "view"    # Landroid/view/View;
    .param p1, "epicenter"    # Landroid/graphics/Rect;

    .line 140
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 141
    .local v0, "loc":[I
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 142
    const/4 v1, 0x0

    aget v2, v0, v1

    const/4 v3, 0x1

    aget v4, v0, v3

    aget v1, v0, v1

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v5

    add-int/2addr v1, v5

    aget v3, v0, v3

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v5

    add-int/2addr v3, v5

    invoke-virtual {p1, v2, v4, v1, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 143
    return-void
.end method

.method private static hasSimpleTarget(Landroid/transition/Transition;)Z
    .locals 1
    .param p0, "transition"    # Landroid/transition/Transition;

    .line 181
    invoke-virtual {p0}, Landroid/transition/Transition;->getTargetIds()Ljava/util/List;

    move-result-object v0

    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->isNullOrEmpty(Ljava/util/List;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 182
    invoke-virtual {p0}, Landroid/transition/Transition;->getTargetNames()Ljava/util/List;

    move-result-object v0

    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->isNullOrEmpty(Ljava/util/List;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 183
    invoke-virtual {p0}, Landroid/transition/Transition;->getTargetTypes()Ljava/util/List;

    move-result-object v0

    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->isNullOrEmpty(Ljava/util/List;)Z

    move-result v0

    if-nez v0, :cond_0

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

.method private static isNullOrEmpty(Ljava/util/List;)Z
    .locals 1
    .param p0, "list"    # Ljava/util/List;

    .line 190
    if-eqz p0, :cond_1

    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

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

.method public static mergeTransitionsInSequence(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6
    .param p0, "exitTransitionObj"    # Ljava/lang/Object;
    .param p1, "enterTransitionObj"    # Ljava/lang/Object;
    .param p2, "sharedElementTransitionObj"    # Ljava/lang/Object;

    .line 262
    const/4 v0, 0x0

    .line 263
    .local v0, "staggered":Landroid/transition/Transition;
    move-object v1, p0

    check-cast v1, Landroid/transition/Transition;

    .line 264
    .local v1, "exitTransition":Landroid/transition/Transition;
    move-object v2, p1

    check-cast v2, Landroid/transition/Transition;

    .line 265
    .local v2, "enterTransition":Landroid/transition/Transition;
    move-object v3, p2

    check-cast v3, Landroid/transition/Transition;

    .line 266
    .local v3, "sharedElementTransition":Landroid/transition/Transition;
    if-eqz v1, :cond_0

    if-eqz v2, :cond_0

    .line 267
    new-instance v4, Landroid/transition/TransitionSet;

    invoke-direct {v4}, Landroid/transition/TransitionSet;-><init>()V

    .line 268
    invoke-virtual {v4, v1}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    move-result-object v4

    .line 269
    invoke-virtual {v4, v2}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    move-result-object v4

    const/4 v5, 0x1

    .line 270
    invoke-virtual {v4, v5}, Landroid/transition/TransitionSet;->setOrdering(I)Landroid/transition/TransitionSet;

    move-result-object v0

    goto :goto_0

    .line 271
    :cond_0
    if-eqz v1, :cond_1

    .line 272
    move-object v0, v1

    goto :goto_0

    .line 273
    :cond_1
    if-eqz v2, :cond_2

    .line 274
    move-object v0, v2

    .line 276
    :cond_2
    :goto_0
    if-eqz v3, :cond_4

    .line 277
    new-instance v4, Landroid/transition/TransitionSet;

    invoke-direct {v4}, Landroid/transition/TransitionSet;-><init>()V

    .line 278
    .local v4, "together":Landroid/transition/TransitionSet;
    if-eqz v0, :cond_3

    .line 279
    invoke-virtual {v4, v0}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 281
    :cond_3
    invoke-virtual {v4, v3}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 282
    return-object v4

    .line 284
    .end local v4    # "together":Landroid/transition/TransitionSet;
    :cond_4
    return-object v0
.end method

.method public static mergeTransitionsTogether(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2
    .param p0, "transition1"    # Ljava/lang/Object;
    .param p1, "transition2"    # Ljava/lang/Object;
    .param p2, "transition3"    # Ljava/lang/Object;

    .line 200
    new-instance v0, Landroid/transition/TransitionSet;

    invoke-direct {v0}, Landroid/transition/TransitionSet;-><init>()V

    .line 201
    .local v0, "transitionSet":Landroid/transition/TransitionSet;
    if-eqz p0, :cond_0

    .line 202
    move-object v1, p0

    check-cast v1, Landroid/transition/Transition;

    invoke-virtual {v0, v1}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 204
    :cond_0
    if-eqz p1, :cond_1

    .line 205
    move-object v1, p1

    check-cast v1, Landroid/transition/Transition;

    invoke-virtual {v0, v1}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 207
    :cond_1
    if-eqz p2, :cond_2

    .line 208
    move-object v1, p2

    check-cast v1, Landroid/transition/Transition;

    invoke-virtual {v0, v1}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 210
    :cond_2
    return-object v0
.end method

.method public static prepareSetNameOverridesReordered(Ljava/util/ArrayList;)Ljava/util/ArrayList;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 304
    .local p0, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 305
    .local v0, "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v1

    .line 306
    .local v1, "numSharedElements":I
    const/4 v2, 0x0

    .line 306
    .local v2, "i":I
    :goto_0
    if-ge v2, v1, :cond_0

    .line 307
    invoke-virtual {p0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    .line 308
    .local v3, "view":Landroid/view/View;
    invoke-virtual {v3}, Landroid/view/View;->getTransitionName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 309
    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/View;->setTransitionName(Ljava/lang/String;)V

    .line 306
    .end local v3    # "view":Landroid/view/View;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 311
    .end local v2    # "i":I
    :cond_0
    return-object v0
.end method

.method public static removeTarget(Ljava/lang/Object;Landroid/view/View;)V
    .locals 1
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .param p1, "view"    # Landroid/view/View;

    .line 533
    if-eqz p0, :cond_0

    .line 534
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 535
    .local v0, "transition":Landroid/transition/Transition;
    invoke-virtual {v0, p1}, Landroid/transition/Transition;->removeTarget(Landroid/view/View;)Landroid/transition/Transition;

    .line 537
    .end local v0    # "transition":Landroid/transition/Transition;
    :cond_0
    return-void
.end method

.method public static replaceTargets(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/util/ArrayList;)V
    .locals 5
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 495
    .local p1, "oldTargets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p2, "newTargets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 496
    .local v0, "transition":Landroid/transition/Transition;
    instance-of v1, v0, Landroid/transition/TransitionSet;

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    .line 497
    move-object v1, v0

    check-cast v1, Landroid/transition/TransitionSet;

    .line 498
    .local v1, "set":Landroid/transition/TransitionSet;
    invoke-virtual {v1}, Landroid/transition/TransitionSet;->getTransitionCount()I

    move-result v3

    .line 499
    .local v3, "numTransitions":I
    nop

    .line 499
    .local v2, "i":I
    :goto_0
    if-ge v2, v3, :cond_0

    .line 500
    invoke-virtual {v1, v2}, Landroid/transition/TransitionSet;->getTransitionAt(I)Landroid/transition/Transition;

    move-result-object v4

    .line 501
    .local v4, "child":Landroid/transition/Transition;
    invoke-static {v4, p1, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->replaceTargets(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/util/ArrayList;)V

    .line 499
    .end local v4    # "child":Landroid/transition/Transition;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 503
    .end local v1    # "set":Landroid/transition/TransitionSet;
    .end local v2    # "i":I
    .end local v3    # "numTransitions":I
    :cond_0
    goto :goto_4

    :cond_1
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->hasSimpleTarget(Landroid/transition/Transition;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 504
    invoke-virtual {v0}, Landroid/transition/Transition;->getTargets()Ljava/util/List;

    move-result-object v1

    .line 505
    .local v1, "targets":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    if-eqz v1, :cond_4

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ne v3, v4, :cond_4

    .line 506
    invoke-interface {v1, p1}, Ljava/util/List;->containsAll(Ljava/util/Collection;)Z

    move-result v3

    if-eqz v3, :cond_4

    .line 508
    if-nez p2, :cond_2

    move v3, v2

    goto :goto_1

    :cond_2
    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 509
    .local v3, "targetCount":I
    :goto_1
    nop

    .line 509
    .restart local v2    # "i":I
    :goto_2
    if-ge v2, v3, :cond_3

    .line 510
    invoke-virtual {p2, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/View;

    invoke-virtual {v0, v4}, Landroid/transition/Transition;->addTarget(Landroid/view/View;)Landroid/transition/Transition;

    .line 509
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 512
    .end local v2    # "i":I
    :cond_3
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v2

    add-int/lit8 v2, v2, -0x1

    .line 512
    .restart local v2    # "i":I
    :goto_3
    if-ltz v2, :cond_4

    .line 513
    invoke-virtual {p1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/View;

    invoke-virtual {v0, v4}, Landroid/transition/Transition;->removeTarget(Landroid/view/View;)Landroid/transition/Transition;

    .line 512
    add-int/lit8 v2, v2, -0x1

    goto :goto_3

    .line 517
    .end local v1    # "targets":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    .end local v2    # "i":I
    .end local v3    # "targetCount":I
    :cond_4
    :goto_4
    return-void
.end method

.method public static scheduleHideFragmentView(Ljava/lang/Object;Landroid/view/View;Ljava/util/ArrayList;)V
    .locals 2
    .param p0, "exitTransitionObj"    # Ljava/lang/Object;
    .param p1, "fragmentView"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Landroid/view/View;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 219
    .local p2, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 220
    .local v0, "exitTransition":Landroid/transition/Transition;
    new-instance v1, Landroid/support/v4/app/FragmentTransitionCompat21$2;

    invoke-direct {v1, p1, p2}, Landroid/support/v4/app/FragmentTransitionCompat21$2;-><init>(Landroid/view/View;Ljava/util/ArrayList;)V

    invoke-virtual {v0, v1}, Landroid/transition/Transition;->addListener(Landroid/transition/Transition$TransitionListener;)Landroid/transition/Transition;

    .line 247
    return-void
.end method

.method public static scheduleNameReset(Landroid/view/ViewGroup;Ljava/util/ArrayList;Ljava/util/Map;)V
    .locals 1
    .param p0, "sceneRoot"    # Landroid/view/ViewGroup;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/ViewGroup;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 560
    .local p1, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p2, "nameOverrides":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    new-instance v0, Landroid/support/v4/app/FragmentTransitionCompat21$7;

    invoke-direct {v0, p1, p2}, Landroid/support/v4/app/FragmentTransitionCompat21$7;-><init>(Ljava/util/ArrayList;Ljava/util/Map;)V

    invoke-static {p0, v0}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 572
    return-void
.end method

.method public static scheduleRemoveTargets(Ljava/lang/Object;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V
    .locals 9
    .param p0, "overallTransitionObj"    # Ljava/lang/Object;
    .param p1, "enterTransition"    # Ljava/lang/Object;
    .param p3, "exitTransition"    # Ljava/lang/Object;
    .param p5, "sharedElementTransition"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 439
    .local p2, "enteringViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p4, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p6, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 440
    .local v0, "overallTransition":Landroid/transition/Transition;
    new-instance v8, Landroid/support/v4/app/FragmentTransitionCompat21$5;

    move-object v1, v8

    move-object v2, p1

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    move-object v6, p5

    move-object v7, p6

    invoke-direct/range {v1 .. v7}, Landroid/support/v4/app/FragmentTransitionCompat21$5;-><init>(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V

    invoke-virtual {v0, v8}, Landroid/transition/Transition;->addListener(Landroid/transition/Transition$TransitionListener;)Landroid/transition/Transition;

    .line 470
    return-void
.end method

.method public static setEpicenter(Ljava/lang/Object;Landroid/graphics/Rect;)V
    .locals 2
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .param p1, "epicenter"    # Landroid/graphics/Rect;

    .line 544
    if-eqz p0, :cond_0

    .line 545
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 546
    .local v0, "transition":Landroid/transition/Transition;
    new-instance v1, Landroid/support/v4/app/FragmentTransitionCompat21$6;

    invoke-direct {v1, p1}, Landroid/support/v4/app/FragmentTransitionCompat21$6;-><init>(Landroid/graphics/Rect;)V

    invoke-virtual {v0, v1}, Landroid/transition/Transition;->setEpicenterCallback(Landroid/transition/Transition$EpicenterCallback;)V

    .line 556
    .end local v0    # "transition":Landroid/transition/Transition;
    :cond_0
    return-void
.end method

.method public static setEpicenter(Ljava/lang/Object;Landroid/view/View;)V
    .locals 3
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .param p1, "view"    # Landroid/view/View;

    .line 121
    if-eqz p1, :cond_0

    .line 122
    move-object v0, p0

    check-cast v0, Landroid/transition/Transition;

    .line 123
    .local v0, "transition":Landroid/transition/Transition;
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    .line 124
    .local v1, "epicenter":Landroid/graphics/Rect;
    invoke-static {p1, v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->getBoundsOnScreen(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 126
    new-instance v2, Landroid/support/v4/app/FragmentTransitionCompat21$1;

    invoke-direct {v2, v1}, Landroid/support/v4/app/FragmentTransitionCompat21$1;-><init>(Landroid/graphics/Rect;)V

    invoke-virtual {v0, v2}, Landroid/transition/Transition;->setEpicenterCallback(Landroid/transition/Transition$EpicenterCallback;)V

    .line 133
    .end local v0    # "transition":Landroid/transition/Transition;
    .end local v1    # "epicenter":Landroid/graphics/Rect;
    :cond_0
    return-void
.end method

.method public static setNameOverridesOrdered(Landroid/view/View;Ljava/util/ArrayList;Ljava/util/Map;)V
    .locals 1
    .param p0, "sceneRoot"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 403
    .local p1, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p2, "nameOverrides":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    new-instance v0, Landroid/support/v4/app/FragmentTransitionCompat21$4;

    invoke-direct {v0, p1, p2}, Landroid/support/v4/app/FragmentTransitionCompat21$4;-><init>(Ljava/util/ArrayList;Ljava/util/Map;)V

    invoke-static {p0, v0}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 417
    return-void
.end method

.method public static setNameOverridesReordered(Landroid/view/View;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/Map;)V
    .locals 9
    .param p0, "sceneRoot"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 323
    .local p1, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p2, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p3, "inNames":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    .local p4, "nameOverrides":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v6

    .line 324
    .local v6, "numSharedElements":I
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    move-object v7, v0

    .line 326
    .local v7, "outNames":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    const/4 v0, 0x0

    move v1, v0

    .line 326
    .local v1, "i":I
    :goto_0
    if-ge v1, v6, :cond_3

    .line 327
    invoke-virtual {p1, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 328
    .local v2, "view":Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getTransitionName()Ljava/lang/String;

    move-result-object v3

    .line 329
    .local v3, "name":Ljava/lang/String;
    invoke-virtual {v7, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 330
    if-nez v3, :cond_0

    .line 331
    goto :goto_2

    .line 333
    :cond_0
    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/view/View;->setTransitionName(Ljava/lang/String;)V

    .line 334
    invoke-interface {p4, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 335
    .local v4, "inName":Ljava/lang/String;
    move v5, v0

    .line 335
    .local v5, "j":I
    :goto_1
    if-ge v5, v6, :cond_2

    .line 336
    invoke-virtual {p3, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    invoke-virtual {v4, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_1

    .line 337
    invoke-virtual {p2, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/View;

    invoke-virtual {v8, v3}, Landroid/view/View;->setTransitionName(Ljava/lang/String;)V

    .line 338
    goto :goto_2

    .line 335
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 326
    .end local v2    # "view":Landroid/view/View;
    .end local v3    # "name":Ljava/lang/String;
    .end local v4    # "inName":Ljava/lang/String;
    .end local v5    # "j":I
    :cond_2
    :goto_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 343
    .end local v1    # "i":I
    :cond_3
    new-instance v8, Landroid/support/v4/app/FragmentTransitionCompat21$3;

    move-object v0, v8

    move v1, v6

    move-object v2, p2

    move-object v3, p3

    move-object v4, p1

    move-object v5, v7

    invoke-direct/range {v0 .. v5}, Landroid/support/v4/app/FragmentTransitionCompat21$3;-><init>(ILjava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;)V

    invoke-static {p0, v8}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 352
    return-void
.end method

.method public static setSharedElementTargets(Ljava/lang/Object;Landroid/view/View;Ljava/util/ArrayList;)V
    .locals 5
    .param p0, "transitionObj"    # Ljava/lang/Object;
    .param p1, "nonExistentView"    # Landroid/view/View;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Landroid/view/View;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 66
    .local p2, "sharedViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/TransitionSet;

    .line 67
    .local v0, "transition":Landroid/transition/TransitionSet;
    invoke-virtual {v0}, Landroid/transition/TransitionSet;->getTargets()Ljava/util/List;

    move-result-object v1

    .line 68
    .local v1, "views":Ljava/util/List;, "Ljava/util/List<Landroid/view/View;>;"
    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 69
    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 70
    .local v2, "count":I
    const/4 v3, 0x0

    .line 70
    .local v3, "i":I
    :goto_0
    if-ge v3, v2, :cond_0

    .line 71
    invoke-virtual {p2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/View;

    .line 72
    .local v4, "view":Landroid/view/View;
    invoke-static {v1, v4}, Landroid/support/v4/app/FragmentTransitionCompat21;->bfsAddViewChildren(Ljava/util/List;Landroid/view/View;)V

    .line 70
    .end local v4    # "view":Landroid/view/View;
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 74
    .end local v3    # "i":I
    :cond_0
    invoke-interface {v1, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 75
    invoke-virtual {p2, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 76
    invoke-static {v0, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->addTargets(Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 77
    return-void
.end method

.method public static swapSharedElementTargets(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/util/ArrayList;)V
    .locals 2
    .param p0, "sharedElementTransitionObj"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 478
    .local p1, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p2, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v0, p0

    check-cast v0, Landroid/transition/TransitionSet;

    .line 479
    .local v0, "sharedElementTransition":Landroid/transition/TransitionSet;
    if-eqz v0, :cond_0

    .line 480
    invoke-virtual {v0}, Landroid/transition/TransitionSet;->getTargets()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 481
    invoke-virtual {v0}, Landroid/transition/TransitionSet;->getTargets()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, p2}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 482
    invoke-static {v0, p1, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->replaceTargets(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/util/ArrayList;)V

    .line 484
    :cond_0
    return-void
.end method

.method public static wrapTransitionInSet(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2
    .param p0, "transition"    # Ljava/lang/Object;

    .line 50
    if-nez p0, :cond_0

    .line 51
    const/4 v0, 0x0

    return-object v0

    .line 53
    :cond_0
    new-instance v0, Landroid/transition/TransitionSet;

    invoke-direct {v0}, Landroid/transition/TransitionSet;-><init>()V

    .line 54
    .local v0, "transitionSet":Landroid/transition/TransitionSet;
    move-object v1, p0

    check-cast v1, Landroid/transition/Transition;

    invoke-virtual {v0, v1}, Landroid/transition/TransitionSet;->addTransition(Landroid/transition/Transition;)Landroid/transition/TransitionSet;

    .line 55
    return-object v0
.end method
