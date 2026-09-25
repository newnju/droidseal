.class public Landroid/support/v4/graphics/PathParser$PathDataNode;
.super Ljava/lang/Object;
.source "PathParser.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/graphics/PathParser;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "PathDataNode"
.end annotation


# instance fields
.field public mParams:[F
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation
.end field

.field public mType:C
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(C[F)V
    .locals 0
    .param p1, "type"    # C
    .param p2, "params"    # [F

    .line 319
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 320
    iput-char p1, p0, Landroid/support/v4/graphics/PathParser$PathDataNode;->mType:C

    .line 321
    iput-object p2, p0, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    .line 322
    return-void
.end method

.method constructor <init>(Landroid/support/v4/graphics/PathParser$PathDataNode;)V
    .locals 3
    .param p1, "n"    # Landroid/support/v4/graphics/PathParser$PathDataNode;

    .line 324
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 325
    iget-char v0, p1, Landroid/support/v4/graphics/PathParser$PathDataNode;->mType:C

    iput-char v0, p0, Landroid/support/v4/graphics/PathParser$PathDataNode;->mType:C

    .line 326
    iget-object v0, p1, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    iget-object v1, p1, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    array-length v1, v1

    const/4 v2, 0x0

    invoke-static {v0, v2, v1}, Landroid/support/v4/graphics/PathParser;->copyOfRange([FII)[F

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    .line 327
    return-void
.end method

.method private static addCommand(Landroid/graphics/Path;[FCC[F)V
    .locals 29
    .param p0, "path"    # Landroid/graphics/Path;
    .param p1, "current"    # [F
    .param p2, "previousCmd"    # C
    .param p3, "cmd"    # C
    .param p4, "val"    # [F

    move-object/from16 v10, p0

    .line 364
    move-object/from16 v13, p4

    const/4 v0, 0x2

    .line 365
    .local v0, "incr":I
    const/4 v14, 0x0

    aget v1, p1, v14

    .line 366
    .local v1, "currentX":F
    const/4 v15, 0x1

    aget v2, p1, v15

    .line 367
    .local v2, "currentY":F
    const/16 v16, 0x2

    aget v3, p1, v16

    .line 368
    .local v3, "ctrlPointX":F
    const/16 v17, 0x3

    aget v4, p1, v17

    .line 369
    .local v4, "ctrlPointY":F
    const/16 v18, 0x4

    aget v5, p1, v18

    .line 370
    .local v5, "currentSegmentStartX":F
    const/16 v19, 0x5

    aget v6, p1, v19

    .line 374
    .local v6, "currentSegmentStartY":F
    sparse-switch p3, :sswitch_data_0

    .line 417
    .end local v0    # "incr":I
    .local v20, "incr":I
    :goto_0
    move/from16 v20, v0

    goto :goto_1

    .line 377
    .end local v20    # "incr":I
    .restart local v0    # "incr":I
    :sswitch_0
    invoke-virtual/range {p0 .. p0}, Landroid/graphics/Path;->close()V

    .line 381
    move v1, v5

    .line 382
    move v2, v6

    .line 383
    move v3, v5

    .line 384
    move v4, v6

    .line 385
    invoke-virtual {v10, v1, v2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 386
    goto :goto_0

    .line 409
    :sswitch_1
    const/4 v0, 0x4

    .line 410
    goto :goto_0

    .line 393
    :sswitch_2
    const/4 v0, 0x2

    .line 394
    goto :goto_0

    .line 399
    :sswitch_3
    const/4 v0, 0x1

    .line 400
    goto :goto_0

    .line 403
    :sswitch_4
    const/4 v0, 0x6

    .line 404
    goto :goto_0

    .line 413
    :sswitch_5
    const/4 v0, 0x7

    goto :goto_0

    .line 417
    .end local v0    # "incr":I
    .restart local v20    # "incr":I
    :goto_1
    move/from16 v7, p2

    move v9, v1

    move v8, v2

    move/from16 v21, v3

    move/from16 v22, v4

    move/from16 v23, v5

    move/from16 v24, v6

    move v0, v14

    .line 417
    .end local v1    # "currentX":F
    .end local v2    # "currentY":F
    .end local v3    # "ctrlPointX":F
    .end local v4    # "ctrlPointY":F
    .end local v5    # "currentSegmentStartX":F
    .end local v6    # "currentSegmentStartY":F
    .end local p2    # "previousCmd":C
    .local v0, "k":I
    .local v7, "previousCmd":C
    .local v8, "currentY":F
    .local v9, "currentX":F
    .local v21, "ctrlPointX":F
    .local v22, "ctrlPointY":F
    .local v23, "currentSegmentStartX":F
    .local v24, "currentSegmentStartY":F
    :goto_2
    move v6, v0

    .line 417
    .end local v0    # "k":I
    .local v6, "k":I
    array-length v0, v13

    if-ge v6, v0, :cond_e

    .line 418
    const/16 v0, 0x73

    const/16 v1, 0x63

    const/16 v2, 0x54

    const/16 v3, 0x51

    const/16 v4, 0x74

    const/16 v5, 0x71

    const/high16 v25, 0x40000000    # 2.0f

    const/4 v15, 0x0

    sparse-switch p3, :sswitch_data_1

    .line 601
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 601
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .local v11, "currentY":F
    .local v12, "currentX":F
    .local v14, "previousCmd":C
    .local v27, "k":I
    goto/16 :goto_f

    .line 466
    .end local v11    # "currentY":F
    .end local v12    # "currentX":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v8    # "currentY":F
    .restart local v9    # "currentX":F
    :sswitch_6
    add-int/lit8 v0, v6, 0x0

    aget v0, v13, v0

    invoke-virtual {v10, v15, v0}, Landroid/graphics/Path;->rLineTo(FF)V

    .line 467
    add-int/lit8 v0, v6, 0x0

    aget v0, v13, v0

    add-float/2addr v8, v0

    .line 468
    nop

    .line 601
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    :goto_3
    move/from16 v27, v6

    goto/16 :goto_7

    .line 538
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    :sswitch_7
    const/4 v0, 0x0

    .line 539
    .local v0, "reflectiveCtrlPointX":F
    const/4 v1, 0x0

    .line 540
    .local v1, "reflectiveCtrlPointY":F
    if-eq v7, v5, :cond_0

    if-eq v7, v4, :cond_0

    if-eq v7, v3, :cond_0

    if-ne v7, v2, :cond_1

    .line 542
    :cond_0
    sub-float v0, v9, v21

    .line 543
    sub-float v1, v8, v22

    .line 545
    :cond_1
    add-int/lit8 v2, v6, 0x0

    aget v2, v13, v2

    add-int/lit8 v3, v6, 0x1

    aget v3, v13, v3

    invoke-virtual {v10, v0, v1, v2, v3}, Landroid/graphics/Path;->rQuadTo(FFFF)V

    .line 547
    add-float v2, v9, v0

    .line 548
    .end local v21    # "ctrlPointX":F
    .local v2, "ctrlPointX":F
    add-float v3, v8, v1

    .line 549
    .end local v22    # "ctrlPointY":F
    .local v3, "ctrlPointY":F
    add-int/lit8 v4, v6, 0x0

    aget v4, v13, v4

    add-float/2addr v9, v4

    .line 550
    add-int/lit8 v4, v6, 0x1

    aget v4, v13, v4

    add-float/2addr v8, v4

    .line 551
    nop

    .line 601
    move/from16 v21, v2

    move/from16 v22, v3

    goto :goto_3

    .line 492
    .end local v0    # "reflectiveCtrlPointX":F
    .end local v1    # "reflectiveCtrlPointY":F
    .end local v2    # "ctrlPointX":F
    .end local v3    # "ctrlPointY":F
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_8
    const/4 v2, 0x0

    .line 493
    .local v2, "reflectiveCtrlPointX":F
    const/4 v3, 0x0

    .line 494
    .local v3, "reflectiveCtrlPointY":F
    if-eq v7, v1, :cond_3

    if-eq v7, v0, :cond_3

    const/16 v0, 0x43

    if-eq v7, v0, :cond_3

    const/16 v0, 0x53

    if-ne v7, v0, :cond_2

    goto :goto_4

    .line 499
    :cond_2
    move v15, v2

    move/from16 v25, v3

    goto :goto_5

    .line 496
    :cond_3
    :goto_4
    sub-float v0, v9, v21

    .line 497
    .end local v2    # "reflectiveCtrlPointX":F
    .restart local v0    # "reflectiveCtrlPointX":F
    sub-float v1, v8, v22

    .line 499
    .end local v3    # "reflectiveCtrlPointY":F
    .restart local v1    # "reflectiveCtrlPointY":F
    move v15, v0

    move/from16 v25, v1

    .line 499
    .end local v0    # "reflectiveCtrlPointX":F
    .end local v1    # "reflectiveCtrlPointY":F
    .local v15, "reflectiveCtrlPointX":F
    .local v25, "reflectiveCtrlPointY":F
    :goto_5
    add-int/lit8 v0, v6, 0x0

    aget v3, v13, v0

    add-int/lit8 v0, v6, 0x1

    aget v4, v13, v0

    add-int/lit8 v0, v6, 0x2

    aget v5, v13, v0

    add-int/lit8 v0, v6, 0x3

    aget v26, v13, v0

    move-object v0, v10

    move v1, v15

    move/from16 v2, v25

    move/from16 v27, v6

    move/from16 v6, v26

    .line 499
    .end local v6    # "k":I
    .restart local v27    # "k":I
    invoke-virtual/range {v0 .. v6}, Landroid/graphics/Path;->rCubicTo(FFFFFF)V

    .line 503
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-float/2addr v0, v9

    .line 504
    .end local v21    # "ctrlPointX":F
    .local v0, "ctrlPointX":F
    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    add-float/2addr v1, v8

    .line 505
    .end local v22    # "ctrlPointY":F
    .local v1, "ctrlPointY":F
    add-int/lit8 v6, v27, 0x2

    aget v2, v13, v6

    add-float/2addr v9, v2

    .line 506
    add-int/lit8 v6, v27, 0x3

    aget v2, v13, v6

    add-float/2addr v8, v2

    .line 507
    goto/16 :goto_6

    .line 524
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v15    # "reflectiveCtrlPointX":F
    .end local v25    # "reflectiveCtrlPointY":F
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_9
    move/from16 v27, v6

    .line 524
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    add-int/lit8 v6, v27, 0x2

    aget v2, v13, v6

    add-int/lit8 v6, v27, 0x3

    aget v3, v13, v6

    invoke-virtual {v10, v0, v1, v2, v3}, Landroid/graphics/Path;->rQuadTo(FFFF)V

    .line 525
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-float/2addr v0, v9

    .line 526
    .end local v21    # "ctrlPointX":F
    .restart local v0    # "ctrlPointX":F
    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    add-float/2addr v1, v8

    .line 527
    .end local v22    # "ctrlPointY":F
    .restart local v1    # "ctrlPointY":F
    add-int/lit8 v6, v27, 0x2

    aget v2, v13, v6

    add-float/2addr v9, v2

    .line 528
    add-int/lit8 v6, v27, 0x3

    aget v2, v13, v6

    add-float/2addr v8, v2

    .line 529
    goto/16 :goto_6

    .line 420
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_a
    move/from16 v27, v6

    .line 420
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-float/2addr v9, v0

    .line 421
    add-int/lit8 v6, v27, 0x1

    aget v0, v13, v6

    add-float/2addr v8, v0

    .line 422
    if-lez v27, :cond_4

    .line 426
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->rLineTo(FF)V

    goto/16 :goto_7

    .line 428
    :cond_4
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->rMoveTo(FF)V

    .line 429
    move v0, v9

    .line 430
    .end local v23    # "currentSegmentStartX":F
    .local v0, "currentSegmentStartX":F
    move v1, v8

    .line 432
    .end local v24    # "currentSegmentStartY":F
    .local v1, "currentSegmentStartY":F
    nop

    .line 601
    move/from16 v23, v0

    move/from16 v24, v1

    goto :goto_7

    .line 448
    .end local v0    # "currentSegmentStartX":F
    .end local v1    # "currentSegmentStartY":F
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v23    # "currentSegmentStartX":F
    .restart local v24    # "currentSegmentStartY":F
    :sswitch_b
    move/from16 v27, v6

    .line 448
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->rLineTo(FF)V

    .line 449
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-float/2addr v9, v0

    .line 450
    add-int/lit8 v6, v27, 0x1

    aget v0, v13, v6

    add-float/2addr v8, v0

    .line 451
    goto :goto_7

    .line 458
    .end local v27    # "k":I
    .restart local v6    # "k":I
    :sswitch_c
    move/from16 v27, v6

    .line 458
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    invoke-virtual {v10, v0, v15}, Landroid/graphics/Path;->rLineTo(FF)V

    .line 459
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-float/2addr v9, v0

    .line 460
    goto :goto_7

    .line 474
    .end local v27    # "k":I
    .restart local v6    # "k":I
    :sswitch_d
    move/from16 v27, v6

    .line 474
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v1, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v2, v13, v6

    add-int/lit8 v6, v27, 0x2

    aget v3, v13, v6

    add-int/lit8 v6, v27, 0x3

    aget v4, v13, v6

    add-int/lit8 v6, v27, 0x4

    aget v5, v13, v6

    add-int/lit8 v6, v27, 0x5

    aget v6, v13, v6

    move-object v0, v10

    invoke-virtual/range {v0 .. v6}, Landroid/graphics/Path;->rCubicTo(FFFFFF)V

    .line 477
    add-int/lit8 v6, v27, 0x2

    aget v0, v13, v6

    add-float/2addr v0, v9

    .line 478
    .end local v21    # "ctrlPointX":F
    .local v0, "ctrlPointX":F
    add-int/lit8 v6, v27, 0x3

    aget v1, v13, v6

    add-float/2addr v1, v8

    .line 479
    .end local v22    # "ctrlPointY":F
    .local v1, "ctrlPointY":F
    add-int/lit8 v6, v27, 0x4

    aget v2, v13, v6

    add-float/2addr v9, v2

    .line 480
    add-int/lit8 v6, v27, 0x5

    aget v2, v13, v6

    add-float/2addr v8, v2

    .line 482
    nop

    .line 601
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v7    # "previousCmd":C
    .restart local v14    # "previousCmd":C
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :goto_6
    move/from16 v21, v0

    move/from16 v22, v1

    :goto_7
    move v14, v7

    goto/16 :goto_f

    .line 569
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    :sswitch_e
    move/from16 v27, v6

    .line 569
    .end local v6    # "k":I
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x5

    aget v0, v13, v6

    add-float v3, v0, v9

    add-int/lit8 v6, v27, 0x6

    aget v0, v13, v6

    add-float v4, v0, v8

    add-int/lit8 v6, v27, 0x0

    aget v5, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v6, v13, v6

    add-int/lit8 v0, v27, 0x2

    aget v25, v13, v0

    add-int/lit8 v0, v27, 0x3

    aget v0, v13, v0

    cmpl-float v0, v0, v15

    if-eqz v0, :cond_5

    const/16 v26, 0x1

    goto :goto_8

    :cond_5
    move/from16 v26, v14

    :goto_8
    add-int/lit8 v0, v27, 0x4

    aget v0, v13, v0

    cmpl-float v0, v0, v15

    if-eqz v0, :cond_6

    const/4 v15, 0x1

    goto :goto_9

    :cond_6
    move v15, v14

    :goto_9
    move-object v0, v10

    move v1, v9

    move v2, v8

    move v14, v7

    move/from16 v7, v25

    .line 569
    .end local v7    # "previousCmd":C
    .restart local v14    # "previousCmd":C
    move v11, v8

    move/from16 v8, v26

    .line 569
    .end local v8    # "currentY":F
    .restart local v11    # "currentY":F
    move v12, v9

    move v9, v15

    .line 569
    .end local v9    # "currentX":F
    .restart local v12    # "currentX":F
    invoke-static/range {v0 .. v9}, Landroid/support/v4/graphics/PathParser$PathDataNode;->drawArc(Landroid/graphics/Path;FFFFFFFZZ)V

    .line 579
    add-int/lit8 v6, v27, 0x5

    aget v0, v13, v6

    add-float v9, v12, v0

    .line 580
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x6

    aget v0, v13, v6

    add-float v8, v11, v0

    .line 581
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    move v0, v9

    .line 582
    .end local v21    # "ctrlPointX":F
    .restart local v0    # "ctrlPointX":F
    move v1, v8

    .line 583
    .end local v22    # "ctrlPointY":F
    .restart local v1    # "ctrlPointY":F
    goto/16 :goto_c

    .line 470
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_f
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 470
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    invoke-virtual {v10, v12, v0}, Landroid/graphics/Path;->lineTo(FF)V

    .line 471
    add-int/lit8 v6, v27, 0x0

    aget v8, v13, v6

    .line 472
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    goto/16 :goto_f

    .line 553
    .end local v12    # "currentX":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v9    # "currentX":F
    :sswitch_10
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 553
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    move v0, v12

    .line 554
    .local v0, "reflectiveCtrlPointX":F
    move v1, v11

    .line 555
    .local v1, "reflectiveCtrlPointY":F
    if-eq v14, v5, :cond_7

    if-eq v14, v4, :cond_7

    if-eq v14, v3, :cond_7

    if-ne v14, v2, :cond_8

    .line 557
    :cond_7
    mul-float v9, v12, v25

    sub-float v0, v9, v21

    .line 558
    mul-float v8, v11, v25

    sub-float v1, v8, v22

    .line 560
    :cond_8
    add-int/lit8 v6, v27, 0x0

    aget v2, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v3, v13, v6

    invoke-virtual {v10, v0, v1, v2, v3}, Landroid/graphics/Path;->quadTo(FFFF)V

    .line 562
    move v2, v0

    .line 563
    .end local v21    # "ctrlPointX":F
    .local v2, "ctrlPointX":F
    move v3, v1

    .line 564
    .end local v22    # "ctrlPointY":F
    .local v3, "ctrlPointY":F
    add-int/lit8 v6, v27, 0x0

    aget v9, v13, v6

    .line 565
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x1

    aget v8, v13, v6

    .line 566
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    nop

    .line 601
    move/from16 v21, v2

    move/from16 v22, v3

    goto/16 :goto_f

    .line 509
    .end local v0    # "reflectiveCtrlPointX":F
    .end local v1    # "reflectiveCtrlPointY":F
    .end local v2    # "ctrlPointX":F
    .end local v3    # "ctrlPointY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_11
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 509
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    move v2, v12

    .line 510
    .local v2, "reflectiveCtrlPointX":F
    move v3, v11

    .line 511
    .local v3, "reflectiveCtrlPointY":F
    if-eq v14, v1, :cond_a

    if-eq v14, v0, :cond_a

    const/16 v0, 0x43

    if-eq v14, v0, :cond_a

    const/16 v0, 0x53

    if-ne v14, v0, :cond_9

    goto :goto_a

    .line 516
    :cond_9
    move v9, v2

    move v8, v3

    goto :goto_b

    .line 513
    :cond_a
    :goto_a
    mul-float v9, v12, v25

    sub-float v9, v9, v21

    .line 514
    .end local v2    # "reflectiveCtrlPointX":F
    .local v9, "reflectiveCtrlPointX":F
    mul-float v8, v11, v25

    sub-float v8, v8, v22

    .line 516
    .end local v3    # "reflectiveCtrlPointY":F
    .local v8, "reflectiveCtrlPointY":F
    :goto_b
    add-int/lit8 v6, v27, 0x0

    aget v3, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v4, v13, v6

    add-int/lit8 v6, v27, 0x2

    aget v5, v13, v6

    add-int/lit8 v6, v27, 0x3

    aget v6, v13, v6

    move-object v0, v10

    move v1, v9

    move v2, v8

    invoke-virtual/range {v0 .. v6}, Landroid/graphics/Path;->cubicTo(FFFFFF)V

    .line 518
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    .line 519
    .end local v21    # "ctrlPointX":F
    .local v0, "ctrlPointX":F
    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    .line 520
    .end local v22    # "ctrlPointY":F
    .local v1, "ctrlPointY":F
    add-int/lit8 v6, v27, 0x2

    aget v2, v13, v6

    .line 521
    .end local v12    # "currentX":F
    .local v2, "currentX":F
    add-int/lit8 v6, v27, 0x3

    aget v3, v13, v6

    .line 522
    .end local v11    # "currentY":F
    .local v3, "currentY":F
    nop

    .line 601
    move/from16 v21, v0

    move/from16 v22, v1

    move v9, v2

    move v8, v3

    goto/16 :goto_f

    .line 531
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v2    # "currentX":F
    .end local v3    # "currentY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .local v8, "currentY":F
    .local v9, "currentX":F
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_12
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 531
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    add-int/lit8 v6, v27, 0x2

    aget v2, v13, v6

    add-int/lit8 v6, v27, 0x3

    aget v3, v13, v6

    invoke-virtual {v10, v0, v1, v2, v3}, Landroid/graphics/Path;->quadTo(FFFF)V

    .line 532
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    .line 533
    .end local v21    # "ctrlPointX":F
    .restart local v0    # "ctrlPointX":F
    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    .line 534
    .end local v22    # "ctrlPointY":F
    .restart local v1    # "ctrlPointY":F
    add-int/lit8 v6, v27, 0x2

    aget v9, v13, v6

    .line 535
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x3

    aget v8, v13, v6

    .line 536
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    goto/16 :goto_c

    .line 434
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :sswitch_13
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 434
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v9, v13, v6

    .line 435
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x1

    aget v8, v13, v6

    .line 436
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    if-lez v27, :cond_b

    .line 440
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->lineTo(FF)V

    goto/16 :goto_f

    .line 442
    :cond_b
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->moveTo(FF)V

    .line 443
    move v0, v9

    .line 444
    .end local v23    # "currentSegmentStartX":F
    .local v0, "currentSegmentStartX":F
    move v1, v8

    .line 446
    .end local v24    # "currentSegmentStartY":F
    .local v1, "currentSegmentStartY":F
    nop

    .line 601
    move/from16 v23, v0

    move/from16 v24, v1

    goto/16 :goto_f

    .line 453
    .end local v0    # "currentSegmentStartX":F
    .end local v1    # "currentSegmentStartY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v23    # "currentSegmentStartX":F
    .restart local v24    # "currentSegmentStartY":F
    :sswitch_14
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 453
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v1, v13, v6

    invoke-virtual {v10, v0, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 454
    add-int/lit8 v6, v27, 0x0

    aget v9, v13, v6

    .line 455
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x1

    aget v8, v13, v6

    .line 456
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    goto/16 :goto_f

    .line 462
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    :sswitch_15
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 462
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v0, v13, v6

    invoke-virtual {v10, v0, v11}, Landroid/graphics/Path;->lineTo(FF)V

    .line 463
    add-int/lit8 v6, v27, 0x0

    aget v9, v13, v6

    .line 464
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    goto/16 :goto_f

    .line 484
    .end local v11    # "currentY":F
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    .restart local v8    # "currentY":F
    :sswitch_16
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 484
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x0

    aget v1, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v2, v13, v6

    add-int/lit8 v6, v27, 0x2

    aget v3, v13, v6

    add-int/lit8 v6, v27, 0x3

    aget v4, v13, v6

    add-int/lit8 v6, v27, 0x4

    aget v5, v13, v6

    add-int/lit8 v6, v27, 0x5

    aget v6, v13, v6

    move-object v0, v10

    invoke-virtual/range {v0 .. v6}, Landroid/graphics/Path;->cubicTo(FFFFFF)V

    .line 486
    add-int/lit8 v6, v27, 0x4

    aget v9, v13, v6

    .line 487
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x5

    aget v8, v13, v6

    .line 488
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    add-int/lit8 v6, v27, 0x2

    aget v0, v13, v6

    .line 489
    .end local v21    # "ctrlPointX":F
    .local v0, "ctrlPointX":F
    add-int/lit8 v6, v27, 0x3

    aget v1, v13, v6

    .line 490
    .end local v22    # "ctrlPointY":F
    .local v1, "ctrlPointY":F
    nop

    .line 601
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :goto_c
    move/from16 v21, v0

    move/from16 v22, v1

    goto :goto_f

    .line 585
    .end local v14    # "previousCmd":C
    .end local v27    # "k":I
    .restart local v6    # "k":I
    .restart local v7    # "previousCmd":C
    :sswitch_17
    move/from16 v27, v6

    move v14, v7

    move v11, v8

    move v12, v9

    .line 585
    .end local v6    # "k":I
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .end local v9    # "currentX":F
    .restart local v11    # "currentY":F
    .restart local v12    # "currentX":F
    .restart local v14    # "previousCmd":C
    .restart local v27    # "k":I
    add-int/lit8 v6, v27, 0x5

    aget v3, v13, v6

    add-int/lit8 v6, v27, 0x6

    aget v4, v13, v6

    add-int/lit8 v6, v27, 0x0

    aget v5, v13, v6

    add-int/lit8 v6, v27, 0x1

    aget v6, v13, v6

    add-int/lit8 v0, v27, 0x2

    aget v7, v13, v0

    add-int/lit8 v0, v27, 0x3

    aget v0, v13, v0

    cmpl-float v0, v0, v15

    if-eqz v0, :cond_c

    const/4 v8, 0x1

    goto :goto_d

    :cond_c
    const/4 v8, 0x0

    :goto_d
    add-int/lit8 v0, v27, 0x4

    aget v0, v13, v0

    cmpl-float v0, v0, v15

    if-eqz v0, :cond_d

    const/4 v9, 0x1

    goto :goto_e

    :cond_d
    const/4 v9, 0x0

    :goto_e
    move-object v0, v10

    move v1, v12

    move v2, v11

    invoke-static/range {v0 .. v9}, Landroid/support/v4/graphics/PathParser$PathDataNode;->drawArc(Landroid/graphics/Path;FFFFFFFZZ)V

    .line 595
    add-int/lit8 v6, v27, 0x5

    aget v9, v13, v6

    .line 596
    .end local v12    # "currentX":F
    .restart local v9    # "currentX":F
    add-int/lit8 v6, v27, 0x6

    aget v8, v13, v6

    .line 597
    .end local v11    # "currentY":F
    .restart local v8    # "currentY":F
    move v0, v9

    .line 598
    .end local v21    # "ctrlPointX":F
    .restart local v0    # "ctrlPointX":F
    move v1, v8

    .line 598
    .end local v22    # "ctrlPointY":F
    .restart local v1    # "ctrlPointY":F
    goto :goto_c

    .line 601
    .end local v0    # "ctrlPointX":F
    .end local v1    # "ctrlPointY":F
    .restart local v21    # "ctrlPointX":F
    .restart local v22    # "ctrlPointY":F
    :goto_f
    move/from16 v7, p3

    .line 417
    .end local v14    # "previousCmd":C
    .restart local v7    # "previousCmd":C
    add-int v0, v27, v20

    .line 417
    .end local v27    # "k":I
    .local v0, "k":I
    const/4 v14, 0x0

    const/4 v15, 0x1

    goto/16 :goto_2

    .line 603
    .end local v0    # "k":I
    :cond_e
    move v14, v7

    move v11, v8

    .line 603
    .end local v7    # "previousCmd":C
    .end local v8    # "currentY":F
    .restart local v11    # "currentY":F
    .restart local v14    # "previousCmd":C
    move v2, v11

    const/4 v1, 0x0

    aput v9, p1, v1

    .line 604
    .end local v11    # "currentY":F
    .local v2, "currentY":F
    const/4 v1, 0x1

    aput v2, p1, v1

    .line 605
    aput v21, p1, v16

    .line 606
    aput v22, p1, v17

    .line 607
    aput v23, p1, v18

    .line 608
    aput v24, p1, v19

    .line 609
    return-void

    nop

    :sswitch_data_0
    .sparse-switch
        0x41 -> :sswitch_5
        0x43 -> :sswitch_4
        0x48 -> :sswitch_3
        0x4c -> :sswitch_2
        0x4d -> :sswitch_2
        0x51 -> :sswitch_1
        0x53 -> :sswitch_1
        0x54 -> :sswitch_2
        0x56 -> :sswitch_3
        0x5a -> :sswitch_0
        0x61 -> :sswitch_5
        0x63 -> :sswitch_4
        0x68 -> :sswitch_3
        0x6c -> :sswitch_2
        0x6d -> :sswitch_2
        0x71 -> :sswitch_1
        0x73 -> :sswitch_1
        0x74 -> :sswitch_2
        0x76 -> :sswitch_3
        0x7a -> :sswitch_0
    .end sparse-switch

    :sswitch_data_1
    .sparse-switch
        0x41 -> :sswitch_17
        0x43 -> :sswitch_16
        0x48 -> :sswitch_15
        0x4c -> :sswitch_14
        0x4d -> :sswitch_13
        0x51 -> :sswitch_12
        0x53 -> :sswitch_11
        0x54 -> :sswitch_10
        0x56 -> :sswitch_f
        0x61 -> :sswitch_e
        0x63 -> :sswitch_d
        0x68 -> :sswitch_c
        0x6c -> :sswitch_b
        0x6d -> :sswitch_a
        0x71 -> :sswitch_9
        0x73 -> :sswitch_8
        0x74 -> :sswitch_7
        0x76 -> :sswitch_6
    .end sparse-switch
.end method

.method private static arcToBezier(Landroid/graphics/Path;DDDDDDDDD)V
    .locals 76
    .param p0, "p"    # Landroid/graphics/Path;
    .param p1, "cx"    # D
    .param p3, "cy"    # D
    .param p5, "a"    # D
    .param p7, "b"    # D
    .param p9, "e1x"    # D
    .param p11, "e1y"    # D
    .param p13, "theta"    # D
    .param p15, "start"    # D
    .param p17, "sweep"    # D

    move-wide/from16 v0, p5

    .line 716
    const-wide/high16 v6, 0x4010000000000000L    # 4.0

    mul-double v8, p17, v6

    const-wide v10, 0x400921fb54442d18L    # Math.PI

    div-double/2addr v8, v10

    invoke-static {v8, v9}, Ljava/lang/Math;->abs(D)D

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v8

    double-to-int v8, v8

    .line 718
    .local v8, "numSegments":I
    move-wide/from16 v9, p15

    .line 719
    .local v9, "eta1":D
    invoke-static/range {p13 .. p14}, Ljava/lang/Math;->cos(D)D

    move-result-wide v11

    .line 720
    .local v11, "cosTheta":D
    invoke-static/range {p13 .. p14}, Ljava/lang/Math;->sin(D)D

    move-result-wide v13

    .line 721
    .local v13, "sinTheta":D
    invoke-static {v9, v10}, Ljava/lang/Math;->cos(D)D

    move-result-wide v15

    .line 722
    .local v15, "cosEta1":D
    invoke-static {v9, v10}, Ljava/lang/Math;->sin(D)D

    move-result-wide v17

    .line 723
    .local v17, "sinEta1":D
    neg-double v6, v0

    mul-double/2addr v6, v11

    mul-double v6, v6, v17

    mul-double v21, p7, v13

    mul-double v21, v21, v15

    sub-double v6, v6, v21

    .line 724
    .local v6, "ep1x":D
    move-wide/from16 v23, v6

    neg-double v6, v0

    .line 724
    .end local v6    # "ep1x":D
    .local v23, "ep1x":D
    mul-double/2addr v6, v13

    mul-double v6, v6, v17

    mul-double v21, p7, v11

    mul-double v21, v21, v15

    add-double v6, v6, v21

    .line 726
    .local v6, "ep1y":D
    move-wide/from16 v25, v6

    int-to-double v6, v8

    .line 726
    .end local v6    # "ep1y":D
    .local v25, "ep1y":D
    div-double v6, p17, v6

    .line 727
    .local v6, "anglePerSegment":D
    const/16 v21, 0x0

    move-wide/from16 v28, v25

    move-wide/from16 v26, p11

    move-wide/from16 v24, v23

    move-wide/from16 v22, p9

    .line 727
    .end local v23    # "ep1x":D
    .end local v25    # "ep1y":D
    .end local p9    # "e1x":D
    .end local p11    # "e1y":D
    .local v21, "i":I
    .local v22, "e1x":D
    .local v24, "ep1x":D
    .local v26, "e1y":D
    .local v28, "ep1y":D
    :goto_0
    move/from16 v30, v21

    .line 727
    .end local v21    # "i":I
    .local v30, "i":I
    move/from16 v4, v30

    if-ge v4, v8, :cond_0

    .line 728
    .end local v30    # "i":I
    .local v4, "i":I
    move/from16 v31, v4

    add-double v4, v9, v6

    .line 729
    .local v4, "eta2":D
    .local v31, "i":I
    invoke-static {v4, v5}, Ljava/lang/Math;->sin(D)D

    move-result-wide v32

    .line 730
    .local v32, "sinEta2":D
    invoke-static {v4, v5}, Ljava/lang/Math;->cos(D)D

    move-result-wide v34

    .line 731
    .local v34, "cosEta2":D
    mul-double v36, v0, v11

    mul-double v36, v36, v34

    add-double v36, p1, v36

    mul-double v38, p7, v13

    mul-double v38, v38, v32

    move-wide/from16 v40, v6

    sub-double v6, v36, v38

    .line 732
    .local v6, "e2x":D
    .local v40, "anglePerSegment":D
    mul-double v36, v0, v13

    mul-double v36, v36, v34

    add-double v36, p3, v36

    mul-double v42, p7, v11

    mul-double v42, v42, v32

    move-wide/from16 v44, v6

    add-double v6, v36, v42

    .line 733
    .local v6, "e2y":D
    .local v44, "e2x":D
    move-wide/from16 v46, v6

    neg-double v6, v0

    .line 733
    .end local v6    # "e2y":D
    .local v46, "e2y":D
    mul-double/2addr v6, v11

    mul-double v6, v6, v32

    mul-double v36, p7, v13

    mul-double v36, v36, v34

    sub-double v6, v6, v36

    .line 734
    .local v6, "ep2x":D
    move-wide/from16 v48, v6

    neg-double v6, v0

    .line 734
    .end local v6    # "ep2x":D
    .local v48, "ep2x":D
    mul-double/2addr v6, v13

    mul-double v6, v6, v32

    mul-double v36, p7, v11

    mul-double v36, v36, v34

    add-double v6, v6, v36

    .line 735
    .local v6, "ep2y":D
    sub-double v36, v4, v9

    const-wide/high16 v42, 0x4000000000000000L    # 2.0

    div-double v0, v36, v42

    invoke-static {v0, v1}, Ljava/lang/Math;->tan(D)D

    move-result-wide v0

    .line 736
    .local v0, "tanDiff2":D
    sub-double v2, v4, v9

    .line 737
    invoke-static {v2, v3}, Ljava/lang/Math;->sin(D)D

    move-result-wide v2

    const-wide/high16 v36, 0x4008000000000000L    # 3.0

    mul-double v42, v0, v36

    mul-double v42, v42, v0

    move-wide/from16 v50, v0

    const-wide/high16 v19, 0x4010000000000000L    # 4.0

    add-double v0, v42, v19

    .line 737
    .end local v0    # "tanDiff2":D
    .local v50, "tanDiff2":D
    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    const-wide/high16 v42, 0x3ff0000000000000L    # 1.0

    sub-double v0, v0, v42

    mul-double/2addr v2, v0

    div-double v2, v2, v36

    .line 738
    .local v2, "alpha":D
    mul-double v0, v2, v24

    add-double v0, v22, v0

    .line 739
    .local v0, "q1x":D
    mul-double v36, v2, v28

    move/from16 v52, v8

    move-wide/from16 v53, v9

    add-double v8, v26, v36

    .line 740
    .end local v9    # "eta1":D
    .local v8, "q1y":D
    .local v52, "numSegments":I
    .local v53, "eta1":D
    mul-double v36, v2, v48

    move-wide/from16 v55, v11

    sub-double v10, v44, v36

    .line 741
    .end local v11    # "cosTheta":D
    .local v10, "q2x":D
    .local v55, "cosTheta":D
    mul-double v36, v2, v6

    move-wide/from16 v57, v2

    sub-double v2, v46, v36

    .line 744
    .local v2, "q2y":D
    .local v57, "alpha":D
    const/4 v12, 0x0

    move-wide/from16 v66, v13

    move-object/from16 v13, p0

    invoke-virtual {v13, v12, v12}, Landroid/graphics/Path;->rLineTo(FF)V

    .line 746
    .end local v13    # "sinTheta":D
    .local v66, "sinTheta":D
    double-to-float v12, v0

    double-to-float v14, v8

    move-wide/from16 v68, v0

    double-to-float v0, v10

    .line 746
    .end local v0    # "q1x":D
    .local v68, "q1x":D
    double-to-float v1, v2

    move-wide/from16 v70, v2

    move-wide/from16 v72, v8

    move-wide/from16 v2, v44

    double-to-float v8, v2

    .line 746
    .end local v8    # "q1y":D
    .end local v44    # "e2x":D
    .local v2, "e2x":D
    .local v70, "q2y":D
    .local v72, "q1y":D
    move-wide/from16 v74, v10

    move-wide/from16 v9, v46

    double-to-float v11, v9

    .line 746
    .end local v10    # "q2x":D
    .end local v46    # "e2y":D
    .local v9, "e2y":D
    .local v74, "q2x":D
    move-object/from16 v59, v13

    move/from16 v60, v12

    move/from16 v61, v14

    move/from16 v62, v0

    move/from16 v63, v1

    move/from16 v64, v8

    move/from16 v65, v11

    invoke-virtual/range {v59 .. v65}, Landroid/graphics/Path;->cubicTo(FFFFFF)V

    .line 752
    move-wide v0, v4

    .line 753
    .end local v53    # "eta1":D
    .local v0, "eta1":D
    move-wide/from16 v22, v2

    .line 754
    move-wide/from16 v26, v9

    .line 755
    move-wide/from16 v24, v48

    .line 756
    move-wide/from16 v28, v6

    .line 727
    .end local v2    # "e2x":D
    .end local v4    # "eta2":D
    .end local v6    # "ep2y":D
    .end local v9    # "e2y":D
    .end local v32    # "sinEta2":D
    .end local v34    # "cosEta2":D
    .end local v48    # "ep2x":D
    .end local v50    # "tanDiff2":D
    .end local v57    # "alpha":D
    .end local v68    # "q1x":D
    .end local v70    # "q2y":D
    .end local v72    # "q1y":D
    .end local v74    # "q2x":D
    add-int/lit8 v21, v31, 0x1

    .line 727
    .end local v31    # "i":I
    .restart local v21    # "i":I
    move-wide v9, v0

    move-wide/from16 v6, v40

    move/from16 v8, v52

    move-wide/from16 v11, v55

    move-wide/from16 v13, v66

    move-wide/from16 v0, p5

    goto/16 :goto_0

    .line 758
    .end local v0    # "eta1":D
    .end local v21    # "i":I
    .end local v40    # "anglePerSegment":D
    .end local v52    # "numSegments":I
    .end local v55    # "cosTheta":D
    .end local v66    # "sinTheta":D
    .local v6, "anglePerSegment":D
    .local v8, "numSegments":I
    .local v9, "eta1":D
    .restart local v11    # "cosTheta":D
    .restart local v13    # "sinTheta":D
    :cond_0
    move-wide/from16 v40, v6

    move/from16 v52, v8

    move-wide/from16 v53, v9

    move-wide/from16 v55, v11

    move-wide/from16 v66, v13

    move-object/from16 v13, p0

    .line 758
    .end local v6    # "anglePerSegment":D
    .end local v8    # "numSegments":I
    .end local v9    # "eta1":D
    .end local v11    # "cosTheta":D
    .end local v13    # "sinTheta":D
    .restart local v40    # "anglePerSegment":D
    .restart local v52    # "numSegments":I
    .restart local v53    # "eta1":D
    .restart local v55    # "cosTheta":D
    .restart local v66    # "sinTheta":D
    return-void
.end method

.method private static drawArc(Landroid/graphics/Path;FFFFFFFZZ)V
    .locals 74
    .param p0, "p"    # Landroid/graphics/Path;
    .param p1, "x0"    # F
    .param p2, "y0"    # F
    .param p3, "x1"    # F
    .param p4, "y1"    # F
    .param p5, "a"    # F
    .param p6, "b"    # F
    .param p7, "theta"    # F
    .param p8, "isMoreThanHalf"    # Z
    .param p9, "isPositiveArc"    # Z

    move/from16 v10, p1

    move/from16 v11, p2

    move/from16 v12, p3

    move/from16 v13, p4

    move/from16 v14, p5

    move/from16 v15, p6

    .line 623
    move/from16 v9, p9

    move/from16 v8, p7

    float-to-double v0, v8

    invoke-static {v0, v1}, Ljava/lang/Math;->toRadians(D)D

    move-result-wide v6

    .line 625
    .local v6, "thetaD":D
    invoke-static {v6, v7}, Ljava/lang/Math;->cos(D)D

    move-result-wide v35

    .line 626
    .local v35, "cosTheta":D
    invoke-static {v6, v7}, Ljava/lang/Math;->sin(D)D

    move-result-wide v37

    .line 629
    .local v37, "sinTheta":D
    float-to-double v0, v10

    mul-double v0, v0, v35

    float-to-double v2, v11

    mul-double v2, v2, v37

    add-double/2addr v0, v2

    float-to-double v2, v14

    div-double v39, v0, v2

    .line 630
    .local v39, "x0p":D
    neg-float v0, v10

    float-to-double v0, v0

    mul-double v0, v0, v37

    float-to-double v2, v11

    mul-double v2, v2, v35

    add-double/2addr v0, v2

    float-to-double v2, v15

    div-double v41, v0, v2

    .line 631
    .local v41, "y0p":D
    float-to-double v0, v12

    mul-double v0, v0, v35

    float-to-double v2, v13

    mul-double v2, v2, v37

    add-double/2addr v0, v2

    float-to-double v2, v14

    div-double v43, v0, v2

    .line 632
    .local v43, "x1p":D
    neg-float v0, v12

    float-to-double v0, v0

    mul-double v0, v0, v37

    float-to-double v2, v13

    mul-double v2, v2, v35

    add-double/2addr v0, v2

    float-to-double v2, v15

    div-double v45, v0, v2

    .line 635
    .local v45, "y1p":D
    sub-double v47, v39, v43

    .line 636
    .local v47, "dx":D
    sub-double v49, v41, v45

    .line 637
    .local v49, "dy":D
    add-double v0, v39, v43

    const-wide/high16 v2, 0x4000000000000000L    # 2.0

    div-double v51, v0, v2

    .line 638
    .local v51, "xm":D
    add-double v0, v41, v45

    div-double v53, v0, v2

    .line 640
    .local v53, "ym":D
    mul-double v0, v47, v47

    mul-double v2, v49, v49

    add-double v4, v0, v2

    .line 641
    .local v4, "dsq":D
    const-wide/16 v0, 0x0

    cmpl-double v2, v4, v0

    if-nez v2, :cond_0

    .line 642
    const-string v0, "PathParser"

    const-string v1, " Points are coincident"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 643
    return-void

    .line 645
    :cond_0
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    div-double/2addr v2, v4

    const-wide/high16 v16, 0x3fd0000000000000L    # 0.25

    sub-double v2, v2, v16

    .line 646
    .local v2, "disc":D
    cmpg-double v16, v2, v0

    if-gez v16, :cond_1

    .line 647
    const-string v0, "PathParser"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    move-wide/from16 v55, v2

    const-string v2, "Points are too far apart "

    .line 647
    .end local v2    # "disc":D
    .local v55, "disc":D
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v4, v5}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 648
    invoke-static {v4, v5}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    const-wide v2, 0x3ffffff583a53b8eL    # 1.99999

    div-double/2addr v0, v2

    double-to-float v3, v0

    .line 649
    .local v3, "adjust":F
    mul-float v16, v14, v3

    mul-float v17, v15, v3

    move-object/from16 v0, p0

    move v1, v10

    move-wide/from16 v14, v55

    move v2, v11

    .line 649
    .end local v55    # "disc":D
    .local v14, "disc":D
    move/from16 v18, v3

    move v3, v12

    .line 649
    .end local v3    # "adjust":F
    .local v18, "adjust":F
    move-wide/from16 v55, v4

    move v4, v13

    .line 649
    .end local v4    # "dsq":D
    .local v55, "dsq":D
    move/from16 v5, v16

    move-wide/from16 v59, v6

    move/from16 v6, v17

    .line 649
    .end local v6    # "thetaD":D
    .local v59, "thetaD":D
    move v7, v8

    move/from16 v8, p8

    move/from16 v9, p9

    invoke-static/range {v0 .. v9}, Landroid/support/v4/graphics/PathParser$PathDataNode;->drawArc(Landroid/graphics/Path;FFFFFFFZZ)V

    .line 651
    return-void

    .line 653
    .end local v14    # "disc":D
    .end local v18    # "adjust":F
    .end local v55    # "dsq":D
    .end local v59    # "thetaD":D
    .restart local v2    # "disc":D
    .restart local v4    # "dsq":D
    .restart local v6    # "thetaD":D
    :cond_1
    move-wide v14, v2

    move-wide/from16 v55, v4

    move-wide/from16 v59, v6

    .line 653
    .end local v2    # "disc":D
    .end local v4    # "dsq":D
    .end local v6    # "thetaD":D
    .restart local v14    # "disc":D
    .restart local v55    # "dsq":D
    .restart local v59    # "thetaD":D
    invoke-static {v14, v15}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v2

    .line 654
    .local v2, "s":D
    mul-double v4, v2, v47

    .line 655
    .local v4, "sdx":D
    mul-double v6, v2, v49

    .line 658
    .local v6, "sdy":D
    move/from16 v8, p8

    move/from16 v9, p9

    if-ne v8, v9, :cond_2

    .line 659
    sub-double v16, v51, v6

    .line 660
    .local v16, "cx":D
    add-double v18, v53, v4

    .line 660
    .local v18, "cy":D
    goto :goto_0

    .line 662
    .end local v16    # "cx":D
    .end local v18    # "cy":D
    :cond_2
    add-double v16, v51, v6

    .line 663
    .restart local v16    # "cx":D
    sub-double v18, v53, v4

    .line 666
    .restart local v18    # "cy":D
    :goto_0
    sub-double v0, v41, v18

    move-wide/from16 v63, v2

    sub-double v2, v39, v16

    .line 666
    .end local v2    # "s":D
    .local v63, "s":D
    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->atan2(DD)D

    move-result-wide v0

    .line 668
    .local v0, "eta0":D
    sub-double v2, v45, v18

    move-wide/from16 v65, v4

    sub-double v4, v43, v16

    .line 668
    .end local v4    # "sdx":D
    .local v65, "sdx":D
    invoke-static {v2, v3, v4, v5}, Ljava/lang/Math;->atan2(DD)D

    move-result-wide v2

    .line 670
    .local v2, "eta1":D
    sub-double v4, v2, v0

    .line 671
    .local v4, "sweep":D
    const-wide/16 v20, 0x0

    cmpl-double v22, v4, v20

    if-ltz v22, :cond_3

    const/16 v22, 0x1

    .line 671
    .end local v2    # "eta1":D
    .local v67, "eta1":D
    :goto_1
    move-wide/from16 v67, v2

    move/from16 v2, v22

    goto :goto_2

    .line 671
    .end local v67    # "eta1":D
    .restart local v2    # "eta1":D
    :cond_3
    const/16 v22, 0x0

    goto :goto_1

    .line 671
    .end local v2    # "eta1":D
    .restart local v67    # "eta1":D
    :goto_2
    if-eq v9, v2, :cond_5

    .line 672
    cmpl-double v2, v4, v20

    const-wide v20, 0x401921fb54442d18L    # 6.283185307179586

    if-lez v2, :cond_4

    .line 673
    sub-double v4, v4, v20

    goto :goto_3

    .line 675
    :cond_4
    add-double v4, v4, v20

    .line 679
    :cond_5
    :goto_3
    move-wide/from16 v69, v6

    move/from16 v2, p5

    float-to-double v6, v2

    .line 679
    .end local v6    # "sdy":D
    .local v69, "sdy":D
    mul-double v16, v16, v6

    .line 680
    move/from16 v3, p6

    float-to-double v6, v3

    mul-double v18, v18, v6

    .line 681
    move-wide/from16 v6, v16

    .line 682
    .local v6, "tcx":D
    mul-double v20, v16, v35

    mul-double v22, v18, v37

    sub-double v57, v20, v22

    .line 683
    .end local v16    # "cx":D
    .local v57, "cx":D
    mul-double v16, v6, v37

    mul-double v20, v18, v35

    add-double v61, v16, v20

    .line 685
    .end local v18    # "cy":D
    .local v61, "cy":D
    move-wide/from16 v71, v6

    float-to-double v6, v2

    .line 685
    .end local v6    # "tcx":D
    .local v71, "tcx":D
    float-to-double v8, v3

    float-to-double v2, v10

    float-to-double v12, v11

    move-object/from16 v16, p0

    move-wide/from16 v17, v57

    move-wide/from16 v19, v61

    move-wide/from16 v21, v6

    move-wide/from16 v23, v8

    move-wide/from16 v25, v2

    move-wide/from16 v27, v12

    move-wide/from16 v29, v59

    move-wide/from16 v31, v0

    move-wide/from16 v33, v4

    invoke-static/range {v16 .. v34}, Landroid/support/v4/graphics/PathParser$PathDataNode;->arcToBezier(Landroid/graphics/Path;DDDDDDDDD)V

    .line 686
    return-void
.end method

.method public static nodesToPath([Landroid/support/v4/graphics/PathParser$PathDataNode;Landroid/graphics/Path;)V
    .locals 5
    .param p0, "node"    # [Landroid/support/v4/graphics/PathParser$PathDataNode;
    .param p1, "path"    # Landroid/graphics/Path;

    .line 336
    const/4 v0, 0x6

    new-array v0, v0, [F

    .line 337
    .local v0, "current":[F
    const/16 v1, 0x6d

    .line 338
    .local v1, "previousCommand":C
    const/4 v2, 0x0

    .line 338
    .local v2, "i":I
    :goto_0
    array-length v3, p0

    if-ge v2, v3, :cond_0

    .line 339
    aget-object v3, p0, v2

    iget-char v3, v3, Landroid/support/v4/graphics/PathParser$PathDataNode;->mType:C

    aget-object v4, p0, v2

    iget-object v4, v4, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    invoke-static {p1, v0, v1, v3, v4}, Landroid/support/v4/graphics/PathParser$PathDataNode;->addCommand(Landroid/graphics/Path;[FCC[F)V

    .line 340
    aget-object v3, p0, v2

    iget-char v1, v3, Landroid/support/v4/graphics/PathParser$PathDataNode;->mType:C

    .line 338
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 342
    .end local v2    # "i":I
    :cond_0
    return-void
.end method


# virtual methods
.method public interpolatePathDataNode(Landroid/support/v4/graphics/PathParser$PathDataNode;Landroid/support/v4/graphics/PathParser$PathDataNode;F)V
    .locals 4
    .param p1, "nodeFrom"    # Landroid/support/v4/graphics/PathParser$PathDataNode;
    .param p2, "nodeTo"    # Landroid/support/v4/graphics/PathParser$PathDataNode;
    .param p3, "fraction"    # F

    .line 355
    const/4 v0, 0x0

    .line 355
    .local v0, "i":I
    :goto_0
    iget-object v1, p1, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    array-length v1, v1

    if-ge v0, v1, :cond_0

    .line 356
    iget-object v1, p0, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    iget-object v2, p1, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    aget v2, v2, v0

    const/high16 v3, 0x3f800000    # 1.0f

    sub-float/2addr v3, p3

    mul-float/2addr v2, v3

    iget-object v3, p2, Landroid/support/v4/graphics/PathParser$PathDataNode;->mParams:[F

    aget v3, v3, v0

    mul-float/2addr v3, p3

    add-float/2addr v2, v3

    aput v2, v1, v0

    .line 355
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 359
    .end local v0    # "i":I
    :cond_0
    return-void
.end method
