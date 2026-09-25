.class public Landroid/support/v7/util/DiffUtil$DiffResult;
.super Ljava/lang/Object;
.source "DiffUtil.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v7/util/DiffUtil;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DiffResult"
.end annotation


# static fields
.field private static final FLAG_CHANGED:I = 0x2

.field private static final FLAG_IGNORE:I = 0x10

.field private static final FLAG_MASK:I = 0x1f

.field private static final FLAG_MOVED_CHANGED:I = 0x4

.field private static final FLAG_MOVED_NOT_CHANGED:I = 0x8

.field private static final FLAG_NOT_CHANGED:I = 0x1

.field private static final FLAG_OFFSET:I = 0x5


# instance fields
.field private final mCallback:Landroid/support/v7/util/DiffUtil$Callback;

.field private final mDetectMoves:Z

.field private final mNewItemStatuses:[I

.field private final mNewListSize:I

.field private final mOldItemStatuses:[I

.field private final mOldListSize:I

.field private final mSnakes:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$Snake;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Landroid/support/v7/util/DiffUtil$Callback;Ljava/util/List;[I[IZ)V
    .locals 2
    .param p1, "callback"    # Landroid/support/v7/util/DiffUtil$Callback;
    .param p3, "oldItemStatuses"    # [I
    .param p4, "newItemStatuses"    # [I
    .param p5, "detectMoves"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v7/util/DiffUtil$Callback;",
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$Snake;",
            ">;[I[IZ)V"
        }
    .end annotation

    .line 473
    .local p2, "snakes":Ljava/util/List;, "Ljava/util/List<Landroid/support/v7/util/DiffUtil$Snake;>;"
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 474
    iput-object p2, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    .line 475
    iput-object p3, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    .line 476
    iput-object p4, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    .line 477
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    const/4 v1, 0x0

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 478
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 479
    iput-object p1, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    .line 480
    invoke-virtual {p1}, Landroid/support/v7/util/DiffUtil$Callback;->getOldListSize()I

    move-result v0

    iput v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldListSize:I

    .line 481
    invoke-virtual {p1}, Landroid/support/v7/util/DiffUtil$Callback;->getNewListSize()I

    move-result v0

    iput v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewListSize:I

    .line 482
    iput-boolean p5, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mDetectMoves:Z

    .line 483
    invoke-direct {p0}, Landroid/support/v7/util/DiffUtil$DiffResult;->addRootSnake()V

    .line 484
    invoke-direct {p0}, Landroid/support/v7/util/DiffUtil$DiffResult;->findMatchingItems()V

    .line 485
    return-void
.end method

.method private addRootSnake()V
    .locals 4

    .line 492
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/v7/util/DiffUtil$Snake;

    .line 493
    .local v0, "firstSnake":Landroid/support/v7/util/DiffUtil$Snake;
    :goto_0
    if-eqz v0, :cond_1

    iget v2, v0, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    if-nez v2, :cond_1

    iget v2, v0, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    if-eqz v2, :cond_2

    .line 494
    :cond_1
    new-instance v2, Landroid/support/v7/util/DiffUtil$Snake;

    invoke-direct {v2}, Landroid/support/v7/util/DiffUtil$Snake;-><init>()V

    .line 495
    .local v2, "root":Landroid/support/v7/util/DiffUtil$Snake;
    iput v1, v2, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    .line 496
    iput v1, v2, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    .line 497
    iput-boolean v1, v2, Landroid/support/v7/util/DiffUtil$Snake;->removal:Z

    .line 498
    iput v1, v2, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    .line 499
    iput-boolean v1, v2, Landroid/support/v7/util/DiffUtil$Snake;->reverse:Z

    .line 500
    iget-object v3, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v3, v1, v2}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 502
    .end local v2    # "root":Landroid/support/v7/util/DiffUtil$Snake;
    :cond_2
    return-void
.end method

.method private dispatchAdditions(Ljava/util/List;Landroid/support/v7/util/ListUpdateCallback;III)V
    .locals 7
    .param p2, "updateCallback"    # Landroid/support/v7/util/ListUpdateCallback;
    .param p3, "start"    # I
    .param p4, "count"    # I
    .param p5, "globalIndex"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$PostponedUpdate;",
            ">;",
            "Landroid/support/v7/util/ListUpdateCallback;",
            "III)V"
        }
    .end annotation

    .line 750
    .local p1, "postponedUpdates":Ljava/util/List;, "Ljava/util/List<Landroid/support/v7/util/DiffUtil$PostponedUpdate;>;"
    iget-boolean v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mDetectMoves:Z

    if-nez v0, :cond_0

    .line 751
    invoke-interface {p2, p3, p4}, Landroid/support/v7/util/ListUpdateCallback;->onInserted(II)V

    .line 752
    return-void

    .line 754
    :cond_0
    add-int/lit8 v0, p4, -0x1

    .line 754
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_6

    .line 755
    iget-object v1, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    add-int v2, p5, v0

    aget v1, v1, v2

    and-int/lit8 v1, v1, 0x1f

    .line 756
    .local v1, "status":I
    const/4 v2, 0x1

    if-eqz v1, :cond_3

    const/4 v3, 0x4

    if-eq v1, v3, :cond_2

    const/16 v4, 0x8

    if-eq v1, v4, :cond_2

    const/16 v2, 0x10

    if-eq v1, v2, :cond_1

    .line 781
    new-instance v2, Ljava/lang/IllegalStateException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "unknown flag for pos "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int v4, p5, v0

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    int-to-long v4, v1

    .line 783
    invoke-static {v4, v5}, Ljava/lang/Long;->toBinaryString(J)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 778
    :cond_1
    new-instance v2, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    add-int v3, p5, v0

    const/4 v4, 0x0

    invoke-direct {v2, v3, p3, v4}, Landroid/support/v7/util/DiffUtil$PostponedUpdate;-><init>(IIZ)V

    invoke-interface {p1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 779
    goto :goto_2

    .line 765
    :cond_2
    iget-object v4, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    add-int v5, p5, v0

    aget v4, v4, v5

    shr-int/lit8 v4, v4, 0x5

    .line 766
    .local v4, "pos":I
    invoke-static {p1, v4, v2}, Landroid/support/v7/util/DiffUtil$DiffResult;->removePostponedUpdate(Ljava/util/List;IZ)Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    move-result-object v5

    .line 770
    .local v5, "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    iget v6, v5, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    invoke-interface {p2, v6, p3}, Landroid/support/v7/util/ListUpdateCallback;->onMoved(II)V

    .line 771
    if-ne v1, v3, :cond_5

    .line 773
    iget-object v3, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    add-int v6, p5, v0

    .line 774
    invoke-virtual {v3, v4, v6}, Landroid/support/v7/util/DiffUtil$Callback;->getChangePayload(II)Ljava/lang/Object;

    move-result-object v3

    .line 773
    invoke-interface {p2, p3, v2, v3}, Landroid/support/v7/util/ListUpdateCallback;->onChanged(IILjava/lang/Object;)V

    goto :goto_2

    .line 758
    .end local v4    # "pos":I
    .end local v5    # "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    :cond_3
    invoke-interface {p2, p3, v2}, Landroid/support/v7/util/ListUpdateCallback;->onInserted(II)V

    .line 759
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    .line 760
    .local v4, "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    iget v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    add-int/2addr v5, v2

    iput v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    .line 761
    .end local v4    # "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    goto :goto_1

    .line 762
    :cond_4
    nop

    .line 754
    .end local v1    # "status":I
    :cond_5
    :goto_2
    add-int/lit8 v0, v0, -0x1

    goto/16 :goto_0

    .line 786
    .end local v0    # "i":I
    :cond_6
    return-void
.end method

.method private dispatchRemovals(Ljava/util/List;Landroid/support/v7/util/ListUpdateCallback;III)V
    .locals 8
    .param p2, "updateCallback"    # Landroid/support/v7/util/ListUpdateCallback;
    .param p3, "start"    # I
    .param p4, "count"    # I
    .param p5, "globalIndex"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$PostponedUpdate;",
            ">;",
            "Landroid/support/v7/util/ListUpdateCallback;",
            "III)V"
        }
    .end annotation

    .line 790
    .local p1, "postponedUpdates":Ljava/util/List;, "Ljava/util/List<Landroid/support/v7/util/DiffUtil$PostponedUpdate;>;"
    iget-boolean v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mDetectMoves:Z

    if-nez v0, :cond_0

    .line 791
    invoke-interface {p2, p3, p4}, Landroid/support/v7/util/ListUpdateCallback;->onRemoved(II)V

    .line 792
    return-void

    .line 794
    :cond_0
    add-int/lit8 v0, p4, -0x1

    .line 794
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_6

    .line 795
    iget-object v1, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    add-int v2, p5, v0

    aget v1, v1, v2

    and-int/lit8 v1, v1, 0x1f

    .line 796
    .local v1, "status":I
    const/4 v2, 0x1

    if-eqz v1, :cond_3

    const/4 v3, 0x4

    if-eq v1, v3, :cond_2

    const/16 v4, 0x8

    if-eq v1, v4, :cond_2

    const/16 v3, 0x10

    if-eq v1, v3, :cond_1

    .line 822
    new-instance v2, Ljava/lang/IllegalStateException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "unknown flag for pos "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int v4, p5, v0

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    int-to-long v4, v1

    .line 824
    invoke-static {v4, v5}, Ljava/lang/Long;->toBinaryString(J)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 819
    :cond_1
    new-instance v3, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    add-int v4, p5, v0

    add-int v5, p3, v0

    invoke-direct {v3, v4, v5, v2}, Landroid/support/v7/util/DiffUtil$PostponedUpdate;-><init>(IIZ)V

    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 820
    goto :goto_2

    .line 805
    :cond_2
    iget-object v4, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    add-int v5, p5, v0

    aget v4, v4, v5

    shr-int/lit8 v4, v4, 0x5

    .line 806
    .local v4, "pos":I
    const/4 v5, 0x0

    invoke-static {p1, v4, v5}, Landroid/support/v7/util/DiffUtil$DiffResult;->removePostponedUpdate(Ljava/util/List;IZ)Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    move-result-object v5

    .line 811
    .local v5, "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    add-int v6, p3, v0

    iget v7, v5, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    sub-int/2addr v7, v2

    invoke-interface {p2, v6, v7}, Landroid/support/v7/util/ListUpdateCallback;->onMoved(II)V

    .line 812
    if-ne v1, v3, :cond_5

    .line 814
    iget v3, v5, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    sub-int/2addr v3, v2

    iget-object v6, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    add-int v7, p5, v0

    .line 815
    invoke-virtual {v6, v7, v4}, Landroid/support/v7/util/DiffUtil$Callback;->getChangePayload(II)Ljava/lang/Object;

    move-result-object v6

    .line 814
    invoke-interface {p2, v3, v2, v6}, Landroid/support/v7/util/ListUpdateCallback;->onChanged(IILjava/lang/Object;)V

    goto :goto_2

    .line 798
    .end local v4    # "pos":I
    .end local v5    # "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    :cond_3
    add-int v3, p3, v0

    invoke-interface {p2, v3, v2}, Landroid/support/v7/util/ListUpdateCallback;->onRemoved(II)V

    .line 799
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    .line 800
    .local v4, "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    iget v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    sub-int/2addr v5, v2

    iput v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    .line 801
    .end local v4    # "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    goto :goto_1

    .line 802
    :cond_4
    nop

    .line 794
    .end local v1    # "status":I
    :cond_5
    :goto_2
    add-int/lit8 v0, v0, -0x1

    goto/16 :goto_0

    .line 827
    .end local v0    # "i":I
    :cond_6
    return-void
.end method

.method private findAddition(III)V
    .locals 2
    .param p1, "x"    # I
    .param p2, "y"    # I
    .param p3, "snakeIndex"    # I

    .line 552
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    add-int/lit8 v1, p1, -0x1

    aget v0, v0, v1

    if-eqz v0, :cond_0

    .line 553
    return-void

    .line 555
    :cond_0
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, p3, v0}, Landroid/support/v7/util/DiffUtil$DiffResult;->findMatchingItem(IIIZ)Z

    .line 556
    return-void
.end method

.method private findMatchingItem(IIIZ)Z
    .locals 15
    .param p1, "x"    # I
    .param p2, "y"    # I
    .param p3, "snakeIndex"    # I
    .param p4, "removal"    # Z

    move-object v0, p0

    .line 581
    if-eqz p4, :cond_0

    .line 582
    add-int/lit8 v1, p2, -0x1

    .line 583
    .local v1, "myItemPos":I
    move/from16 v2, p1

    .line 584
    .local v2, "curX":I
    add-int/lit8 v3, p2, -0x1

    .line 584
    .local v3, "curY":I
    goto :goto_0

    .line 586
    .end local v1    # "myItemPos":I
    .end local v2    # "curX":I
    .end local v3    # "curY":I
    :cond_0
    add-int/lit8 v1, p1, -0x1

    .line 587
    .restart local v1    # "myItemPos":I
    add-int/lit8 v2, p1, -0x1

    .line 588
    .restart local v2    # "curX":I
    move/from16 v3, p2

    .line 590
    .restart local v3    # "curY":I
    :goto_0
    move v4, v3

    move v3, v2

    move/from16 v2, p3

    .line 590
    .local v2, "i":I
    .local v3, "curX":I
    .local v4, "curY":I
    :goto_1
    if-ltz v2, :cond_7

    .line 591
    iget-object v5, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v5, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/support/v7/util/DiffUtil$Snake;

    .line 592
    .local v5, "snake":Landroid/support/v7/util/DiffUtil$Snake;
    iget v6, v5, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    iget v7, v5, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    add-int/2addr v6, v7

    .line 593
    .local v6, "endX":I
    iget v7, v5, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    iget v8, v5, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    add-int/2addr v7, v8

    .line 594
    .local v7, "endY":I
    const/4 v8, 0x4

    const/16 v9, 0x8

    const/4 v10, 0x1

    if-eqz p4, :cond_3

    .line 596
    add-int/lit8 v11, v3, -0x1

    .line 596
    .local v11, "pos":I
    :goto_2
    if-lt v11, v6, :cond_6

    .line 597
    iget-object v12, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    invoke-virtual {v12, v11, v1}, Landroid/support/v7/util/DiffUtil$Callback;->areItemsTheSame(II)Z

    move-result v12

    if-eqz v12, :cond_2

    .line 599
    iget-object v12, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    invoke-virtual {v12, v11, v1}, Landroid/support/v7/util/DiffUtil$Callback;->areContentsTheSame(II)Z

    move-result v12

    .line 600
    .local v12, "theSame":Z
    if-eqz v12, :cond_1

    move v8, v9

    nop

    .line 602
    .local v8, "changeFlag":I
    :cond_1
    iget-object v9, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    shl-int/lit8 v13, v11, 0x5

    or-int/lit8 v13, v13, 0x10

    aput v13, v9, v1

    .line 603
    iget-object v9, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    shl-int/lit8 v13, v1, 0x5

    or-int/2addr v13, v8

    aput v13, v9, v11

    .line 604
    return v10

    .line 596
    .end local v8    # "changeFlag":I
    .end local v12    # "theSame":Z
    :cond_2
    add-int/lit8 v11, v11, -0x1

    goto :goto_2

    .line 609
    .end local v11    # "pos":I
    :cond_3
    add-int/lit8 v11, v4, -0x1

    .line 609
    .restart local v11    # "pos":I
    :goto_3
    if-lt v11, v7, :cond_6

    .line 610
    iget-object v12, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    invoke-virtual {v12, v1, v11}, Landroid/support/v7/util/DiffUtil$Callback;->areItemsTheSame(II)Z

    move-result v12

    if-eqz v12, :cond_5

    .line 612
    iget-object v12, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    invoke-virtual {v12, v1, v11}, Landroid/support/v7/util/DiffUtil$Callback;->areContentsTheSame(II)Z

    move-result v12

    .line 613
    .restart local v12    # "theSame":Z
    if-eqz v12, :cond_4

    move v8, v9

    nop

    .line 615
    .restart local v8    # "changeFlag":I
    :cond_4
    iget-object v9, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    add-int/lit8 v13, p1, -0x1

    shl-int/lit8 v14, v11, 0x5

    or-int/lit8 v14, v14, 0x10

    aput v14, v9, v13

    .line 616
    iget-object v9, v0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    add-int/lit8 v13, p1, -0x1

    shl-int/lit8 v13, v13, 0x5

    or-int/2addr v13, v8

    aput v13, v9, v11

    .line 617
    return v10

    .line 609
    .end local v8    # "changeFlag":I
    .end local v12    # "theSame":Z
    :cond_5
    add-int/lit8 v11, v11, -0x1

    goto :goto_3

    .line 621
    .end local v11    # "pos":I
    :cond_6
    iget v3, v5, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    .line 622
    iget v4, v5, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    .line 590
    .end local v5    # "snake":Landroid/support/v7/util/DiffUtil$Snake;
    .end local v6    # "endX":I
    .end local v7    # "endY":I
    add-int/lit8 v2, v2, -0x1

    goto :goto_1

    .line 624
    .end local v2    # "i":I
    :cond_7
    const/4 v2, 0x0

    return v2
.end method

.method private findMatchingItems()V
    .locals 14

    .line 516
    iget v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldListSize:I

    .line 517
    .local v0, "posOld":I
    iget v1, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewListSize:I

    .line 519
    .local v1, "posNew":I
    iget-object v2, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    const/4 v3, 0x1

    sub-int/2addr v2, v3

    .line 519
    .local v2, "i":I
    :goto_0
    if-ltz v2, :cond_4

    .line 520
    iget-object v4, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v4, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v7/util/DiffUtil$Snake;

    .line 521
    .local v4, "snake":Landroid/support/v7/util/DiffUtil$Snake;
    iget v5, v4, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    iget v6, v4, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    add-int/2addr v5, v6

    .line 522
    .local v5, "endX":I
    iget v6, v4, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    iget v7, v4, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    add-int/2addr v6, v7

    .line 523
    .local v6, "endY":I
    iget-boolean v7, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mDetectMoves:Z

    if-eqz v7, :cond_1

    .line 524
    :goto_1
    if-le v0, v5, :cond_0

    .line 526
    invoke-direct {p0, v0, v1, v2}, Landroid/support/v7/util/DiffUtil$DiffResult;->findAddition(III)V

    .line 527
    add-int/lit8 v0, v0, -0x1

    goto :goto_1

    .line 529
    :cond_0
    :goto_2
    if-le v1, v6, :cond_1

    .line 532
    invoke-direct {p0, v0, v1, v2}, Landroid/support/v7/util/DiffUtil$DiffResult;->findRemoval(III)V

    .line 533
    add-int/lit8 v1, v1, -0x1

    goto :goto_2

    .line 536
    :cond_1
    const/4 v7, 0x0

    .line 536
    .local v7, "j":I
    :goto_3
    iget v8, v4, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    if-ge v7, v8, :cond_3

    .line 538
    iget v8, v4, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    add-int/2addr v8, v7

    .line 539
    .local v8, "oldItemPos":I
    iget v9, v4, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    add-int/2addr v9, v7

    .line 540
    .local v9, "newItemPos":I
    iget-object v10, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    .line 541
    invoke-virtual {v10, v8, v9}, Landroid/support/v7/util/DiffUtil$Callback;->areContentsTheSame(II)Z

    move-result v10

    .line 542
    .local v10, "theSame":Z
    if-eqz v10, :cond_2

    move v11, v3

    goto :goto_4

    :cond_2
    const/4 v11, 0x2

    .line 543
    .local v11, "changeFlag":I
    :goto_4
    iget-object v12, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    shl-int/lit8 v13, v9, 0x5

    or-int/2addr v13, v11

    aput v13, v12, v8

    .line 544
    iget-object v12, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    shl-int/lit8 v13, v8, 0x5

    or-int/2addr v13, v11

    aput v13, v12, v9

    .line 536
    .end local v8    # "oldItemPos":I
    .end local v9    # "newItemPos":I
    .end local v10    # "theSame":Z
    .end local v11    # "changeFlag":I
    add-int/lit8 v7, v7, 0x1

    goto :goto_3

    .line 546
    .end local v7    # "j":I
    :cond_3
    iget v0, v4, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    .line 547
    iget v1, v4, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    .line 519
    .end local v4    # "snake":Landroid/support/v7/util/DiffUtil$Snake;
    .end local v5    # "endX":I
    .end local v6    # "endY":I
    add-int/lit8 v2, v2, -0x1

    goto :goto_0

    .line 549
    .end local v2    # "i":I
    :cond_4
    return-void
.end method

.method private findRemoval(III)V
    .locals 2
    .param p1, "x"    # I
    .param p2, "y"    # I
    .param p3, "snakeIndex"    # I

    .line 559
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewItemStatuses:[I

    add-int/lit8 v1, p2, -0x1

    aget v0, v0, v1

    if-eqz v0, :cond_0

    .line 560
    return-void

    .line 562
    :cond_0
    const/4 v0, 0x1

    invoke-direct {p0, p1, p2, p3, v0}, Landroid/support/v7/util/DiffUtil$DiffResult;->findMatchingItem(IIIZ)Z

    .line 563
    return-void
.end method

.method private static removePostponedUpdate(Ljava/util/List;IZ)Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    .locals 7
    .param p1, "pos"    # I
    .param p2, "removal"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$PostponedUpdate;",
            ">;IZ)",
            "Landroid/support/v7/util/DiffUtil$PostponedUpdate;"
        }
    .end annotation

    .line 734
    .local p0, "updates":Ljava/util/List;, "Ljava/util/List<Landroid/support/v7/util/DiffUtil$PostponedUpdate;>;"
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    .line 734
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_3

    .line 735
    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    .line 736
    .local v2, "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    iget v3, v2, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->posInOwnerList:I

    if-ne v3, p1, :cond_2

    iget-boolean v3, v2, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->removal:Z

    if-ne v3, p2, :cond_2

    .line 737
    invoke-interface {p0, v0}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 738
    move v3, v0

    .line 738
    .local v3, "j":I
    :goto_1
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v4

    if-ge v3, v4, :cond_1

    .line 740
    invoke-interface {p0, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;

    iget v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    if-eqz p2, :cond_0

    move v6, v1

    goto :goto_2

    :cond_0
    const/4 v6, -0x1

    :goto_2
    add-int/2addr v5, v6

    iput v5, v4, Landroid/support/v7/util/DiffUtil$PostponedUpdate;->currentPos:I

    .line 738
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 742
    .end local v3    # "j":I
    :cond_1
    return-object v2

    .line 734
    .end local v2    # "update":Landroid/support/v7/util/DiffUtil$PostponedUpdate;
    :cond_2
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 745
    .end local v0    # "i":I
    :cond_3
    const/4 v0, 0x0

    return-object v0
.end method


# virtual methods
.method public dispatchUpdatesTo(Landroid/support/v7/util/ListUpdateCallback;)V
    .locals 17
    .param p1, "updateCallback"    # Landroid/support/v7/util/ListUpdateCallback;

    move-object/from16 v8, p0

    .line 693
    move-object/from16 v0, p1

    instance-of v1, v0, Landroid/support/v7/util/BatchingListUpdateCallback;

    if-eqz v1, :cond_0

    .line 694
    move-object v1, v0

    check-cast v1, Landroid/support/v7/util/BatchingListUpdateCallback;

    .line 704
    .end local p1    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .local v9, "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .local v10, "batchingCallback":Landroid/support/v7/util/BatchingListUpdateCallback;
    :goto_0
    move-object v9, v0

    move-object v10, v1

    goto :goto_1

    .line 696
    .end local v9    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .end local v10    # "batchingCallback":Landroid/support/v7/util/BatchingListUpdateCallback;
    .restart local p1    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    :cond_0
    new-instance v1, Landroid/support/v7/util/BatchingListUpdateCallback;

    invoke-direct {v1, v0}, Landroid/support/v7/util/BatchingListUpdateCallback;-><init>(Landroid/support/v7/util/ListUpdateCallback;)V

    .line 700
    .local v1, "batchingCallback":Landroid/support/v7/util/BatchingListUpdateCallback;
    move-object v0, v1

    .line 700
    .end local p1    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .local v0, "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    goto :goto_0

    .line 704
    .end local v0    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .end local v1    # "batchingCallback":Landroid/support/v7/util/BatchingListUpdateCallback;
    .restart local v9    # "updateCallback":Landroid/support/v7/util/ListUpdateCallback;
    .restart local v10    # "batchingCallback":Landroid/support/v7/util/BatchingListUpdateCallback;
    :goto_1
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 705
    .local v1, "postponedUpdates":Ljava/util/List;, "Ljava/util/List<Landroid/support/v7/util/DiffUtil$PostponedUpdate;>;"
    iget v0, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldListSize:I

    .line 706
    .local v0, "posOld":I
    iget v2, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mNewListSize:I

    .line 707
    .local v2, "posNew":I
    iget-object v3, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    const/4 v11, 0x1

    sub-int/2addr v3, v11

    move v12, v0

    move v13, v2

    .line 707
    .end local v0    # "posOld":I
    .end local v2    # "posNew":I
    .local v3, "snakeIndex":I
    .local v12, "posOld":I
    .local v13, "posNew":I
    :goto_2
    move v14, v3

    .line 707
    .end local v3    # "snakeIndex":I
    .local v14, "snakeIndex":I
    if-ltz v14, :cond_5

    .line 708
    iget-object v0, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    invoke-interface {v0, v14}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object v15, v0

    check-cast v15, Landroid/support/v7/util/DiffUtil$Snake;

    .line 709
    .local v15, "snake":Landroid/support/v7/util/DiffUtil$Snake;
    iget v7, v15, Landroid/support/v7/util/DiffUtil$Snake;->size:I

    .line 710
    .local v7, "snakeSize":I
    iget v0, v15, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    add-int v6, v0, v7

    .line 711
    .local v6, "endX":I
    iget v0, v15, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    add-int v5, v0, v7

    .line 712
    .local v5, "endY":I
    if-ge v6, v12, :cond_1

    .line 713
    sub-int v4, v12, v6

    move-object v0, v8

    move-object v2, v10

    move v3, v6

    move v11, v5

    move v5, v6

    .line 713
    .end local v5    # "endY":I
    .local v11, "endY":I
    invoke-direct/range {v0 .. v5}, Landroid/support/v7/util/DiffUtil$DiffResult;->dispatchRemovals(Ljava/util/List;Landroid/support/v7/util/ListUpdateCallback;III)V

    goto :goto_3

    .line 716
    .end local v11    # "endY":I
    .restart local v5    # "endY":I
    :cond_1
    move v11, v5

    .line 716
    .end local v5    # "endY":I
    .restart local v11    # "endY":I
    :goto_3
    if-ge v11, v13, :cond_2

    .line 717
    sub-int v0, v13, v11

    move-object v2, v8

    move-object v3, v1

    move-object v4, v10

    move v5, v6

    move/from16 v16, v6

    move v6, v0

    .line 717
    .end local v6    # "endX":I
    .local v16, "endX":I
    move v0, v7

    move v7, v11

    .line 717
    .end local v7    # "snakeSize":I
    .local v0, "snakeSize":I
    invoke-direct/range {v2 .. v7}, Landroid/support/v7/util/DiffUtil$DiffResult;->dispatchAdditions(Ljava/util/List;Landroid/support/v7/util/ListUpdateCallback;III)V

    goto :goto_4

    .line 720
    .end local v0    # "snakeSize":I
    .end local v16    # "endX":I
    .restart local v6    # "endX":I
    .restart local v7    # "snakeSize":I
    :cond_2
    move/from16 v16, v6

    move v0, v7

    .line 720
    .end local v6    # "endX":I
    .end local v7    # "snakeSize":I
    .restart local v0    # "snakeSize":I
    .restart local v16    # "endX":I
    :goto_4
    add-int/lit8 v7, v0, -0x1

    .line 720
    .local v7, "i":I
    :goto_5
    move v2, v7

    .line 720
    .end local v7    # "i":I
    .local v2, "i":I
    if-ltz v2, :cond_4

    .line 721
    iget-object v3, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mOldItemStatuses:[I

    iget v4, v15, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    add-int/2addr v4, v2

    aget v3, v3, v4

    and-int/lit8 v3, v3, 0x1f

    const/4 v4, 0x2

    if-ne v3, v4, :cond_3

    .line 722
    iget v3, v15, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    add-int/2addr v3, v2

    iget-object v4, v8, Landroid/support/v7/util/DiffUtil$DiffResult;->mCallback:Landroid/support/v7/util/DiffUtil$Callback;

    iget v5, v15, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    add-int/2addr v5, v2

    iget v6, v15, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    add-int/2addr v6, v2

    .line 723
    invoke-virtual {v4, v5, v6}, Landroid/support/v7/util/DiffUtil$Callback;->getChangePayload(II)Ljava/lang/Object;

    move-result-object v4

    .line 722
    const/4 v5, 0x1

    invoke-virtual {v10, v3, v5, v4}, Landroid/support/v7/util/BatchingListUpdateCallback;->onChanged(IILjava/lang/Object;)V

    goto :goto_6

    .line 720
    :cond_3
    const/4 v5, 0x1

    :goto_6
    add-int/lit8 v7, v2, -0x1

    .line 720
    .end local v2    # "i":I
    .restart local v7    # "i":I
    goto :goto_5

    .line 726
    .end local v7    # "i":I
    :cond_4
    const/4 v5, 0x1

    iget v12, v15, Landroid/support/v7/util/DiffUtil$Snake;->x:I

    .line 727
    iget v13, v15, Landroid/support/v7/util/DiffUtil$Snake;->y:I

    .line 707
    .end local v0    # "snakeSize":I
    .end local v11    # "endY":I
    .end local v15    # "snake":Landroid/support/v7/util/DiffUtil$Snake;
    .end local v16    # "endX":I
    add-int/lit8 v3, v14, -0x1

    .line 707
    .end local v14    # "snakeIndex":I
    .restart local v3    # "snakeIndex":I
    move v11, v5

    goto :goto_2

    .line 729
    .end local v3    # "snakeIndex":I
    :cond_5
    invoke-virtual {v10}, Landroid/support/v7/util/BatchingListUpdateCallback;->dispatchLastEvent()V

    .line 730
    return-void
.end method

.method public dispatchUpdatesTo(Landroid/support/v7/widget/RecyclerView$Adapter;)V
    .locals 1
    .param p1, "adapter"    # Landroid/support/v7/widget/RecyclerView$Adapter;

    .line 659
    new-instance v0, Landroid/support/v7/util/DiffUtil$DiffResult$1;

    invoke-direct {v0, p0, p1}, Landroid/support/v7/util/DiffUtil$DiffResult$1;-><init>(Landroid/support/v7/util/DiffUtil$DiffResult;Landroid/support/v7/widget/RecyclerView$Adapter;)V

    invoke-virtual {p0, v0}, Landroid/support/v7/util/DiffUtil$DiffResult;->dispatchUpdatesTo(Landroid/support/v7/util/ListUpdateCallback;)V

    .line 680
    return-void
.end method

.method getSnakes()Ljava/util/List;
    .locals 1
    .annotation build Landroid/support/annotation/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/support/v7/util/DiffUtil$Snake;",
            ">;"
        }
    .end annotation

    .line 831
    iget-object v0, p0, Landroid/support/v7/util/DiffUtil$DiffResult;->mSnakes:Ljava/util/List;

    return-object v0
.end method
