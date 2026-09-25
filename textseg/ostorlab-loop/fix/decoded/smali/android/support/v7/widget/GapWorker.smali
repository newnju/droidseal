.class final Landroid/support/v7/widget/GapWorker;
.super Ljava/lang/Object;
.source "GapWorker.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;,
        Landroid/support/v7/widget/GapWorker$Task;
    }
.end annotation


# static fields
.field static final sGapWorker:Ljava/lang/ThreadLocal;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ThreadLocal<",
            "Landroid/support/v7/widget/GapWorker;",
            ">;"
        }
    .end annotation
.end field

.field static sTaskComparator:Ljava/util/Comparator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Comparator<",
            "Landroid/support/v7/widget/GapWorker$Task;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field mFrameIntervalNs:J

.field mPostTimeNs:J

.field mRecyclerViews:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/v7/widget/RecyclerView;",
            ">;"
        }
    .end annotation
.end field

.field private mTasks:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/v7/widget/GapWorker$Task;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 30
    new-instance v0, Ljava/lang/ThreadLocal;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    sput-object v0, Landroid/support/v7/widget/GapWorker;->sGapWorker:Ljava/lang/ThreadLocal;

    .line 187
    new-instance v0, Landroid/support/v7/widget/GapWorker$1;

    invoke-direct {v0}, Landroid/support/v7/widget/GapWorker$1;-><init>()V

    sput-object v0, Landroid/support/v7/widget/GapWorker;->sTaskComparator:Ljava/util/Comparator;

    return-void
.end method

.method constructor <init>()V
    .locals 1

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 32
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    .line 57
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    .line 62
    return-void
.end method

.method private buildTaskList()V
    .locals 12

    .line 214
    iget-object v0, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 215
    .local v0, "viewCount":I
    const/4 v1, 0x0

    .line 216
    .local v1, "totalTaskCount":I
    const/4 v2, 0x0

    move v3, v1

    move v1, v2

    .line 216
    .local v1, "i":I
    .local v3, "totalTaskCount":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 217
    iget-object v4, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v4, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v7/widget/RecyclerView;

    .line 218
    .local v4, "view":Landroid/support/v7/widget/RecyclerView;
    invoke-virtual {v4}, Landroid/support/v7/widget/RecyclerView;->getWindowVisibility()I

    move-result v5

    if-nez v5, :cond_0

    .line 219
    iget-object v5, v4, Landroid/support/v7/widget/RecyclerView;->mPrefetchRegistry:Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;

    invoke-virtual {v5, v4, v2}, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->collectPrefetchPositionsFromView(Landroid/support/v7/widget/RecyclerView;Z)V

    .line 220
    iget-object v5, v4, Landroid/support/v7/widget/RecyclerView;->mPrefetchRegistry:Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;

    iget v5, v5, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mCount:I

    add-int/2addr v3, v5

    .line 216
    .end local v4    # "view":Landroid/support/v7/widget/RecyclerView;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 225
    .end local v1    # "i":I
    :cond_1
    iget-object v1, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->ensureCapacity(I)V

    .line 226
    const/4 v1, 0x0

    .line 227
    .local v1, "totalTaskIndex":I
    move v4, v1

    move v1, v2

    .line 227
    .local v1, "i":I
    .local v4, "totalTaskIndex":I
    :goto_1
    if-ge v1, v0, :cond_6

    .line 228
    iget-object v5, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/support/v7/widget/RecyclerView;

    .line 229
    .local v5, "view":Landroid/support/v7/widget/RecyclerView;
    invoke-virtual {v5}, Landroid/support/v7/widget/RecyclerView;->getWindowVisibility()I

    move-result v6

    if-eqz v6, :cond_2

    .line 231
    goto :goto_5

    .line 234
    :cond_2
    iget-object v6, v5, Landroid/support/v7/widget/RecyclerView;->mPrefetchRegistry:Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;

    .line 235
    .local v6, "prefetchRegistry":Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;
    iget v7, v6, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mPrefetchDx:I

    invoke-static {v7}, Ljava/lang/Math;->abs(I)I

    move-result v7

    iget v8, v6, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mPrefetchDy:I

    .line 236
    invoke-static {v8}, Ljava/lang/Math;->abs(I)I

    move-result v8

    add-int/2addr v7, v8

    .line 237
    .local v7, "viewVelocity":I
    move v8, v4

    move v4, v2

    .line 237
    .local v4, "j":I
    .local v8, "totalTaskIndex":I
    :goto_2
    iget v9, v6, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mCount:I

    mul-int/lit8 v9, v9, 0x2

    if-ge v4, v9, :cond_5

    .line 239
    iget-object v9, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    if-lt v8, v9, :cond_3

    .line 240
    new-instance v9, Landroid/support/v7/widget/GapWorker$Task;

    invoke-direct {v9}, Landroid/support/v7/widget/GapWorker$Task;-><init>()V

    .line 241
    .local v9, "task":Landroid/support/v7/widget/GapWorker$Task;
    iget-object v10, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v10, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_3

    .line 243
    .end local v9    # "task":Landroid/support/v7/widget/GapWorker$Task;
    :cond_3
    iget-object v9, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v9, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/support/v7/widget/GapWorker$Task;

    .line 245
    .restart local v9    # "task":Landroid/support/v7/widget/GapWorker$Task;
    :goto_3
    iget-object v10, v6, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mPrefetchArray:[I

    add-int/lit8 v11, v4, 0x1

    aget v10, v10, v11

    .line 247
    .local v10, "distanceToItem":I
    if-gt v10, v7, :cond_4

    const/4 v11, 0x1

    goto :goto_4

    :cond_4
    move v11, v2

    :goto_4
    iput-boolean v11, v9, Landroid/support/v7/widget/GapWorker$Task;->immediate:Z

    .line 248
    iput v7, v9, Landroid/support/v7/widget/GapWorker$Task;->viewVelocity:I

    .line 249
    iput v10, v9, Landroid/support/v7/widget/GapWorker$Task;->distanceToItem:I

    .line 250
    iput-object v5, v9, Landroid/support/v7/widget/GapWorker$Task;->view:Landroid/support/v7/widget/RecyclerView;

    .line 251
    iget-object v11, v6, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mPrefetchArray:[I

    aget v11, v11, v4

    iput v11, v9, Landroid/support/v7/widget/GapWorker$Task;->position:I

    .line 253
    add-int/lit8 v8, v8, 0x1

    .line 237
    .end local v9    # "task":Landroid/support/v7/widget/GapWorker$Task;
    .end local v10    # "distanceToItem":I
    add-int/lit8 v4, v4, 0x2

    goto :goto_2

    .line 227
    .end local v4    # "j":I
    .end local v5    # "view":Landroid/support/v7/widget/RecyclerView;
    .end local v6    # "prefetchRegistry":Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;
    .end local v7    # "viewVelocity":I
    :cond_5
    move v4, v8

    .line 227
    .end local v8    # "totalTaskIndex":I
    .local v4, "totalTaskIndex":I
    :goto_5
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 258
    .end local v1    # "i":I
    :cond_6
    iget-object v1, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    sget-object v2, Landroid/support/v7/widget/GapWorker;->sTaskComparator:Ljava/util/Comparator;

    invoke-static {v1, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 259
    return-void
.end method

.method private flushTaskWithDeadline(Landroid/support/v7/widget/GapWorker$Task;J)V
    .locals 4
    .param p1, "task"    # Landroid/support/v7/widget/GapWorker$Task;
    .param p2, "deadlineNs"    # J

    .line 341
    iget-boolean v0, p1, Landroid/support/v7/widget/GapWorker$Task;->immediate:Z

    if-eqz v0, :cond_0

    const-wide v0, 0x7fffffffffffffffL

    goto :goto_0

    :cond_0
    move-wide v0, p2

    .line 342
    .local v0, "taskDeadlineNs":J
    :goto_0
    iget-object v2, p1, Landroid/support/v7/widget/GapWorker$Task;->view:Landroid/support/v7/widget/RecyclerView;

    iget v3, p1, Landroid/support/v7/widget/GapWorker$Task;->position:I

    invoke-direct {p0, v2, v3, v0, v1}, Landroid/support/v7/widget/GapWorker;->prefetchPositionWithDeadline(Landroid/support/v7/widget/RecyclerView;IJ)Landroid/support/v7/widget/RecyclerView$ViewHolder;

    move-result-object v2

    .line 344
    .local v2, "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    if-eqz v2, :cond_1

    iget-object v3, v2, Landroid/support/v7/widget/RecyclerView$ViewHolder;->mNestedRecyclerView:Ljava/lang/ref/WeakReference;

    if-eqz v3, :cond_1

    .line 346
    invoke-virtual {v2}, Landroid/support/v7/widget/RecyclerView$ViewHolder;->isBound()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 347
    invoke-virtual {v2}, Landroid/support/v7/widget/RecyclerView$ViewHolder;->isInvalid()Z

    move-result v3

    if-nez v3, :cond_1

    .line 348
    iget-object v3, v2, Landroid/support/v7/widget/RecyclerView$ViewHolder;->mNestedRecyclerView:Ljava/lang/ref/WeakReference;

    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/v7/widget/RecyclerView;

    invoke-direct {p0, v3, p2, p3}, Landroid/support/v7/widget/GapWorker;->prefetchInnerRecyclerViewWithDeadline(Landroid/support/v7/widget/RecyclerView;J)V

    .line 350
    :cond_1
    return-void
.end method

.method private flushTasksWithDeadline(J)V
    .locals 3
    .param p1, "deadlineNs"    # J

    .line 353
    const/4 v0, 0x0

    .line 353
    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 354
    iget-object v1, p0, Landroid/support/v7/widget/GapWorker;->mTasks:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v7/widget/GapWorker$Task;

    .line 355
    .local v1, "task":Landroid/support/v7/widget/GapWorker$Task;
    iget-object v2, v1, Landroid/support/v7/widget/GapWorker$Task;->view:Landroid/support/v7/widget/RecyclerView;

    if-nez v2, :cond_0

    .line 356
    goto :goto_1

    .line 358
    :cond_0
    invoke-direct {p0, v1, p1, p2}, Landroid/support/v7/widget/GapWorker;->flushTaskWithDeadline(Landroid/support/v7/widget/GapWorker$Task;J)V

    .line 359
    invoke-virtual {v1}, Landroid/support/v7/widget/GapWorker$Task;->clear()V

    .line 353
    .end local v1    # "task":Landroid/support/v7/widget/GapWorker$Task;
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 361
    .end local v0    # "i":I
    :cond_1
    :goto_1
    return-void
.end method

.method static isPrefetchPositionAttached(Landroid/support/v7/widget/RecyclerView;I)Z
    .locals 6
    .param p0, "view"    # Landroid/support/v7/widget/RecyclerView;
    .param p1, "position"    # I

    .line 262
    iget-object v0, p0, Landroid/support/v7/widget/RecyclerView;->mChildHelper:Landroid/support/v7/widget/ChildHelper;

    invoke-virtual {v0}, Landroid/support/v7/widget/ChildHelper;->getUnfilteredChildCount()I

    move-result v0

    .line 263
    .local v0, "childCount":I
    const/4 v1, 0x0

    move v2, v1

    .line 263
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_1

    .line 264
    iget-object v3, p0, Landroid/support/v7/widget/RecyclerView;->mChildHelper:Landroid/support/v7/widget/ChildHelper;

    invoke-virtual {v3, v2}, Landroid/support/v7/widget/ChildHelper;->getUnfilteredChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 265
    .local v3, "attachedView":Landroid/view/View;
    invoke-static {v3}, Landroid/support/v7/widget/RecyclerView;->getChildViewHolderInt(Landroid/view/View;)Landroid/support/v7/widget/RecyclerView$ViewHolder;

    move-result-object v4

    .line 267
    .local v4, "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    iget v5, v4, Landroid/support/v7/widget/RecyclerView$ViewHolder;->mPosition:I

    if-ne v5, p1, :cond_0

    invoke-virtual {v4}, Landroid/support/v7/widget/RecyclerView$ViewHolder;->isInvalid()Z

    move-result v5

    if-nez v5, :cond_0

    .line 268
    const/4 v1, 0x1

    return v1

    .line 263
    .end local v3    # "attachedView":Landroid/view/View;
    .end local v4    # "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 271
    .end local v2    # "i":I
    :cond_1
    return v1
.end method

.method private prefetchInnerRecyclerViewWithDeadline(Landroid/support/v7/widget/RecyclerView;J)V
    .locals 3
    .param p1, "innerView"    # Landroid/support/v7/widget/RecyclerView;
        .annotation build Landroid/support/annotation/Nullable;
        .end annotation
    .end param
    .param p2, "deadlineNs"    # J

    .line 309
    if-nez p1, :cond_0

    .line 310
    return-void

    .line 313
    :cond_0
    iget-boolean v0, p1, Landroid/support/v7/widget/RecyclerView;->mDataSetHasChangedAfterLayout:Z

    if-eqz v0, :cond_1

    iget-object v0, p1, Landroid/support/v7/widget/RecyclerView;->mChildHelper:Landroid/support/v7/widget/ChildHelper;

    .line 314
    invoke-virtual {v0}, Landroid/support/v7/widget/ChildHelper;->getUnfilteredChildCount()I

    move-result v0

    if-eqz v0, :cond_1

    .line 317
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->removeAndRecycleViews()V

    .line 321
    :cond_1
    iget-object v0, p1, Landroid/support/v7/widget/RecyclerView;->mPrefetchRegistry:Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;

    .line 322
    .local v0, "innerPrefetchRegistry":Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;
    const/4 v1, 0x1

    invoke-virtual {v0, p1, v1}, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->collectPrefetchPositionsFromView(Landroid/support/v7/widget/RecyclerView;Z)V

    .line 324
    iget v1, v0, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mCount:I

    if-eqz v1, :cond_3

    .line 326
    :try_start_0
    const-string v1, "RV Nested Prefetch"

    invoke-static {v1}, Landroid/support/v4/os/TraceCompat;->beginSection(Ljava/lang/String;)V

    .line 327
    iget-object v1, p1, Landroid/support/v7/widget/RecyclerView;->mState:Landroid/support/v7/widget/RecyclerView$State;

    iget-object v2, p1, Landroid/support/v7/widget/RecyclerView;->mAdapter:Landroid/support/v7/widget/RecyclerView$Adapter;

    invoke-virtual {v1, v2}, Landroid/support/v7/widget/RecyclerView$State;->prepareForNestedPrefetch(Landroid/support/v7/widget/RecyclerView$Adapter;)V

    .line 328
    const/4 v1, 0x0

    .line 328
    .local v1, "i":I
    :goto_0
    iget v2, v0, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mCount:I

    mul-int/lit8 v2, v2, 0x2

    if-ge v1, v2, :cond_2

    .line 331
    iget-object v2, v0, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->mPrefetchArray:[I

    aget v2, v2, v1

    .line 332
    .local v2, "innerPosition":I
    invoke-direct {p0, p1, v2, p2, p3}, Landroid/support/v7/widget/GapWorker;->prefetchPositionWithDeadline(Landroid/support/v7/widget/RecyclerView;IJ)Landroid/support/v7/widget/RecyclerView$ViewHolder;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 328
    .end local v2    # "innerPosition":I
    add-int/lit8 v1, v1, 0x2

    goto :goto_0

    .line 335
    .end local v1    # "i":I
    :cond_2
    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    .line 336
    goto :goto_1

    .line 335
    :catchall_0
    move-exception v1

    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    throw v1

    .line 338
    :cond_3
    :goto_1
    return-void
.end method

.method private prefetchPositionWithDeadline(Landroid/support/v7/widget/RecyclerView;IJ)Landroid/support/v7/widget/RecyclerView$ViewHolder;
    .locals 4
    .param p1, "view"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "position"    # I
    .param p3, "deadlineNs"    # J

    .line 276
    invoke-static {p1, p2}, Landroid/support/v7/widget/GapWorker;->isPrefetchPositionAttached(Landroid/support/v7/widget/RecyclerView;I)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 278
    return-object v1

    .line 281
    :cond_0
    iget-object v0, p1, Landroid/support/v7/widget/RecyclerView;->mRecycler:Landroid/support/v7/widget/RecyclerView$Recycler;

    .line 284
    .local v0, "recycler":Landroid/support/v7/widget/RecyclerView$Recycler;
    const/4 v2, 0x0

    :try_start_0
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->onEnterLayoutOrScroll()V

    .line 285
    invoke-virtual {v0, p2, v2, p3, p4}, Landroid/support/v7/widget/RecyclerView$Recycler;->tryGetViewHolderForPositionByDeadline(IZJ)Landroid/support/v7/widget/RecyclerView$ViewHolder;

    move-result-object v3

    move-object v1, v3

    .line 288
    .local v1, "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    if-eqz v1, :cond_2

    .line 289
    invoke-virtual {v1}, Landroid/support/v7/widget/RecyclerView$ViewHolder;->isBound()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-virtual {v1}, Landroid/support/v7/widget/RecyclerView$ViewHolder;->isInvalid()Z

    move-result v3

    if-nez v3, :cond_1

    .line 292
    iget-object v3, v1, Landroid/support/v7/widget/RecyclerView$ViewHolder;->itemView:Landroid/view/View;

    invoke-virtual {v0, v3}, Landroid/support/v7/widget/RecyclerView$Recycler;->recycleView(Landroid/view/View;)V

    goto :goto_0

    .line 298
    :cond_1
    invoke-virtual {v0, v1, v2}, Landroid/support/v7/widget/RecyclerView$Recycler;->addViewHolderToRecycledViewPool(Landroid/support/v7/widget/RecyclerView$ViewHolder;Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 302
    :cond_2
    :goto_0
    invoke-virtual {p1, v2}, Landroid/support/v7/widget/RecyclerView;->onExitLayoutOrScroll(Z)V

    .line 303
    nop

    .line 304
    return-object v1

    .line 302
    .end local v1    # "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    :catchall_0
    move-exception v3

    .line 302
    .restart local v1    # "holder":Landroid/support/v7/widget/RecyclerView$ViewHolder;
    invoke-virtual {p1, v2}, Landroid/support/v7/widget/RecyclerView;->onExitLayoutOrScroll(Z)V

    throw v3
.end method


# virtual methods
.method public add(Landroid/support/v7/widget/RecyclerView;)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;

    .line 160
    iget-object v0, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 161
    return-void
.end method

.method postFromTraversal(Landroid/support/v7/widget/RecyclerView;II)V
    .locals 4
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;
    .param p2, "prefetchDx"    # I
    .param p3, "prefetchDy"    # I

    .line 174
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->isAttachedToWindow()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 178
    iget-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    .line 179
    invoke-virtual {p1}, Landroid/support/v7/widget/RecyclerView;->getNanoTime()J

    move-result-wide v0

    iput-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    .line 180
    invoke-virtual {p1, p0}, Landroid/support/v7/widget/RecyclerView;->post(Ljava/lang/Runnable;)Z

    .line 184
    :cond_0
    iget-object v0, p1, Landroid/support/v7/widget/RecyclerView;->mPrefetchRegistry:Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;

    invoke-virtual {v0, p2, p3}, Landroid/support/v7/widget/GapWorker$LayoutPrefetchRegistryImpl;->setPrefetchVector(II)V

    .line 185
    return-void
.end method

.method prefetch(J)V
    .locals 0
    .param p1, "deadlineNs"    # J

    .line 364
    invoke-direct {p0}, Landroid/support/v7/widget/GapWorker;->buildTaskList()V

    .line 365
    invoke-direct {p0, p1, p2}, Landroid/support/v7/widget/GapWorker;->flushTasksWithDeadline(J)V

    .line 366
    return-void
.end method

.method public remove(Landroid/support/v7/widget/RecyclerView;)V
    .locals 1
    .param p1, "recyclerView"    # Landroid/support/v7/widget/RecyclerView;

    .line 164
    iget-object v0, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    move-result v0

    .line 168
    .local v0, "removeSuccess":Z
    return-void
.end method

.method public run()V
    .locals 9

    .line 371
    const-wide/16 v0, 0x0

    :try_start_0
    const-string v2, "RV Prefetch"

    invoke-static {v2}, Landroid/support/v4/os/TraceCompat;->beginSection(Ljava/lang/String;)V

    .line 373
    iget-object v2, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_0

    .line 400
    iput-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    .line 401
    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    .line 375
    return-void

    .line 380
    :cond_0
    :try_start_1
    iget-object v2, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 381
    .local v2, "size":I
    const-wide/16 v3, 0x0

    .line 382
    .local v3, "latestFrameVsyncMs":J
    const/4 v5, 0x0

    .line 382
    .local v5, "i":I
    :goto_0
    if-ge v5, v2, :cond_2

    .line 383
    iget-object v6, p0, Landroid/support/v7/widget/GapWorker;->mRecyclerViews:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/support/v7/widget/RecyclerView;

    .line 384
    .local v6, "view":Landroid/support/v7/widget/RecyclerView;
    invoke-virtual {v6}, Landroid/support/v7/widget/RecyclerView;->getWindowVisibility()I

    move-result v7

    if-nez v7, :cond_1

    .line 385
    invoke-virtual {v6}, Landroid/support/v7/widget/RecyclerView;->getDrawingTime()J

    move-result-wide v7

    invoke-static {v7, v8, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v7
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-wide v3, v7

    .line 382
    .end local v6    # "view":Landroid/support/v7/widget/RecyclerView;
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 389
    .end local v5    # "i":I
    :cond_2
    cmp-long v5, v3, v0

    if-nez v5, :cond_3

    .line 400
    iput-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    .line 401
    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    .line 391
    return-void

    .line 394
    :cond_3
    :try_start_2
    sget-object v5, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v5, v3, v4}, Ljava/util/concurrent/TimeUnit;->toNanos(J)J

    move-result-wide v5

    iget-wide v7, p0, Landroid/support/v7/widget/GapWorker;->mFrameIntervalNs:J

    add-long/2addr v5, v7

    .line 396
    .local v5, "nextFrameNs":J
    invoke-virtual {p0, v5, v6}, Landroid/support/v7/widget/GapWorker;->prefetch(J)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 400
    .end local v2    # "size":I
    .end local v3    # "latestFrameVsyncMs":J
    .end local v5    # "nextFrameNs":J
    iput-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    .line 401
    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    .line 402
    nop

    .line 403
    return-void

    .line 400
    :catchall_0
    move-exception v2

    iput-wide v0, p0, Landroid/support/v7/widget/GapWorker;->mPostTimeNs:J

    .line 401
    invoke-static {}, Landroid/support/v4/os/TraceCompat;->endSection()V

    throw v2
.end method
