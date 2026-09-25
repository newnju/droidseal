.class Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;
.super Landroid/support/v7/widget/RecyclerView$Adapter;
.source "NavigationMenuPresenter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/design/internal/NavigationMenuPresenter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "NavigationMenuAdapter"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/support/v7/widget/RecyclerView$Adapter<",
        "Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;",
        ">;"
    }
.end annotation


# static fields
.field private static final STATE_ACTION_VIEWS:Ljava/lang/String; = "android:menu:action_views"

.field private static final STATE_CHECKED_ITEM:Ljava/lang/String; = "android:menu:checked"

.field private static final VIEW_TYPE_HEADER:I = 0x3

.field private static final VIEW_TYPE_NORMAL:I = 0x0

.field private static final VIEW_TYPE_SEPARATOR:I = 0x2

.field private static final VIEW_TYPE_SUBHEADER:I = 0x1


# instance fields
.field private mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

.field private final mItems:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;",
            ">;"
        }
    .end annotation
.end field

.field private mUpdateSuspended:Z

.field final synthetic this$0:Landroid/support/design/internal/NavigationMenuPresenter;


# direct methods
.method constructor <init>(Landroid/support/design/internal/NavigationMenuPresenter;)V
    .locals 0

    .line 366
    iput-object p1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    invoke-direct {p0}, Landroid/support/v7/widget/RecyclerView$Adapter;-><init>()V

    .line 362
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    .line 367
    invoke-direct {p0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->prepareMenuItems()V

    .line 368
    return-void
.end method

.method private appendTransparentIconIfMissing(II)V
    .locals 3
    .param p1, "startIndex"    # I
    .param p2, "endIndex"    # I

    .line 539
    move v0, p1

    .line 539
    .local v0, "i":I
    :goto_0
    if-ge v0, p2, :cond_0

    .line 540
    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    .line 541
    .local v1, "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    const/4 v2, 0x1

    iput-boolean v2, v1, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->needsEmptyIcon:Z

    .line 539
    .end local v1    # "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 543
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method private prepareMenuItems()V
    .locals 17

    .line 469
    move-object/from16 v0, p0

    iget-boolean v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    if-eqz v1, :cond_0

    .line 470
    return-void

    .line 472
    :cond_0
    const/4 v1, 0x1

    iput-boolean v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    .line 473
    iget-object v2, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->clear()V

    .line 474
    iget-object v2, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    new-instance v3, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuHeaderItem;

    invoke-direct {v3}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuHeaderItem;-><init>()V

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 476
    const/4 v2, -0x1

    .line 477
    .local v2, "currentGroupId":I
    const/4 v3, 0x0

    .line 478
    .local v3, "currentGroupStart":I
    const/4 v4, 0x0

    .line 479
    .local v4, "currentGroupHasIcon":Z
    const/4 v5, 0x0

    .line 479
    .local v5, "i":I
    iget-object v6, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v6, v6, Landroid/support/design/internal/NavigationMenuPresenter;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v6}, Landroid/support/v7/view/menu/MenuBuilder;->getVisibleItems()Ljava/util/ArrayList;

    move-result-object v6

    invoke-virtual {v6}, Ljava/util/ArrayList;->size()I

    move-result v6

    .line 479
    .local v6, "totalSize":I
    :goto_0
    const/4 v7, 0x0

    if-ge v5, v6, :cond_e

    .line 480
    iget-object v8, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v8, v8, Landroid/support/design/internal/NavigationMenuPresenter;->mMenu:Landroid/support/v7/view/menu/MenuBuilder;

    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuBuilder;->getVisibleItems()Ljava/util/ArrayList;

    move-result-object v8

    invoke-virtual {v8, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/support/v7/view/menu/MenuItemImpl;

    .line 481
    .local v8, "item":Landroid/support/v7/view/menu/MenuItemImpl;
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->isChecked()Z

    move-result v9

    if-eqz v9, :cond_1

    .line 482
    invoke-virtual {v0, v8}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->setCheckedItem(Landroid/support/v7/view/menu/MenuItemImpl;)V

    .line 484
    :cond_1
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->isCheckable()Z

    move-result v9

    if-eqz v9, :cond_2

    .line 485
    invoke-virtual {v8, v7}, Landroid/support/v7/view/menu/MenuItemImpl;->setExclusiveCheckable(Z)V

    .line 487
    :cond_2
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->hasSubMenu()Z

    move-result v9

    if-eqz v9, :cond_a

    .line 488
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->getSubMenu()Landroid/view/SubMenu;

    move-result-object v9

    .line 489
    .local v9, "subMenu":Landroid/view/SubMenu;
    invoke-interface {v9}, Landroid/view/SubMenu;->hasVisibleItems()Z

    move-result v10

    if-eqz v10, :cond_9

    .line 490
    if-eqz v5, :cond_3

    .line 491
    iget-object v10, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    new-instance v11, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;

    iget-object v12, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget v12, v12, Landroid/support/design/internal/NavigationMenuPresenter;->mPaddingSeparator:I

    invoke-direct {v11, v12, v7}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;-><init>(II)V

    invoke-virtual {v10, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 493
    :cond_3
    iget-object v10, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    new-instance v11, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-direct {v11, v8}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;-><init>(Landroid/support/v7/view/menu/MenuItemImpl;)V

    invoke-virtual {v10, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 494
    const/4 v10, 0x0

    .line 495
    .local v10, "subMenuHasIcon":Z
    iget-object v11, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v11}, Ljava/util/ArrayList;->size()I

    move-result v11

    .line 496
    .local v11, "subMenuStart":I
    const/4 v12, 0x0

    .line 496
    .local v12, "j":I
    invoke-interface {v9}, Landroid/view/SubMenu;->size()I

    move-result v13

    .line 496
    .local v13, "size":I
    :goto_1
    if-ge v12, v13, :cond_8

    .line 497
    invoke-interface {v9, v12}, Landroid/view/SubMenu;->getItem(I)Landroid/view/MenuItem;

    move-result-object v14

    check-cast v14, Landroid/support/v7/view/menu/MenuItemImpl;

    .line 498
    .local v14, "subMenuItem":Landroid/support/v7/view/menu/MenuItemImpl;
    invoke-virtual {v14}, Landroid/support/v7/view/menu/MenuItemImpl;->isVisible()Z

    move-result v15

    if-eqz v15, :cond_7

    .line 499
    if-nez v10, :cond_4

    invoke-virtual {v14}, Landroid/support/v7/view/menu/MenuItemImpl;->getIcon()Landroid/graphics/drawable/Drawable;

    move-result-object v15

    if-eqz v15, :cond_4

    .line 500
    const/4 v10, 0x1

    .line 502
    :cond_4
    invoke-virtual {v14}, Landroid/support/v7/view/menu/MenuItemImpl;->isCheckable()Z

    move-result v15

    if-eqz v15, :cond_5

    .line 503
    invoke-virtual {v14, v7}, Landroid/support/v7/view/menu/MenuItemImpl;->setExclusiveCheckable(Z)V

    .line 505
    :cond_5
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->isChecked()Z

    move-result v15

    if-eqz v15, :cond_6

    .line 506
    invoke-virtual {v0, v8}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->setCheckedItem(Landroid/support/v7/view/menu/MenuItemImpl;)V

    .line 508
    :cond_6
    iget-object v15, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    new-instance v1, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-direct {v1, v14}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;-><init>(Landroid/support/v7/view/menu/MenuItemImpl;)V

    invoke-virtual {v15, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 496
    .end local v14    # "subMenuItem":Landroid/support/v7/view/menu/MenuItemImpl;
    :cond_7
    add-int/lit8 v12, v12, 0x1

    const/4 v1, 0x1

    goto :goto_1

    .line 511
    .end local v12    # "j":I
    .end local v13    # "size":I
    :cond_8
    if-eqz v10, :cond_9

    .line 512
    iget-object v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-direct {v0, v11, v1}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->appendTransparentIconIfMissing(II)V

    .line 515
    .end local v9    # "subMenu":Landroid/view/SubMenu;
    .end local v10    # "subMenuHasIcon":Z
    .end local v11    # "subMenuStart":I
    :cond_9
    goto :goto_3

    .line 516
    :cond_a
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->getGroupId()I

    move-result v1

    .line 517
    .local v1, "groupId":I
    if-eq v1, v2, :cond_c

    .line 518
    iget-object v9, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 519
    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->getIcon()Landroid/graphics/drawable/Drawable;

    move-result-object v9

    if-eqz v9, :cond_b

    const/4 v7, 0x1

    nop

    :cond_b
    move v4, v7

    .line 520
    if-eqz v5, :cond_d

    .line 521
    add-int/lit8 v3, v3, 0x1

    .line 522
    iget-object v7, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    new-instance v9, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;

    iget-object v10, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget v10, v10, Landroid/support/design/internal/NavigationMenuPresenter;->mPaddingSeparator:I

    iget-object v11, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget v11, v11, Landroid/support/design/internal/NavigationMenuPresenter;->mPaddingSeparator:I

    invoke-direct {v9, v10, v11}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;-><init>(II)V

    invoke-virtual {v7, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 525
    :cond_c
    if-nez v4, :cond_d

    invoke-virtual {v8}, Landroid/support/v7/view/menu/MenuItemImpl;->getIcon()Landroid/graphics/drawable/Drawable;

    move-result-object v7

    if-eqz v7, :cond_d

    .line 526
    const/4 v4, 0x1

    .line 527
    iget-object v7, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    invoke-direct {v0, v3, v7}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->appendTransparentIconIfMissing(II)V

    .line 529
    :cond_d
    :goto_2
    new-instance v7, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-direct {v7, v8}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;-><init>(Landroid/support/v7/view/menu/MenuItemImpl;)V

    .line 530
    .local v7, "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    iput-boolean v4, v7, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->needsEmptyIcon:Z

    .line 531
    iget-object v9, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v9, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 532
    nop

    .line 479
    .end local v2    # "currentGroupId":I
    .end local v7    # "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    .end local v8    # "item":Landroid/support/v7/view/menu/MenuItemImpl;
    .local v1, "currentGroupId":I
    move v2, v1

    .line 479
    .end local v1    # "currentGroupId":I
    .restart local v2    # "currentGroupId":I
    :goto_3
    add-int/lit8 v5, v5, 0x1

    const/4 v1, 0x1

    goto/16 :goto_0

    .line 535
    .end local v5    # "i":I
    .end local v6    # "totalSize":I
    :cond_e
    iput-boolean v7, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    .line 536
    return-void
.end method


# virtual methods
.method public createInstanceState()Landroid/os/Bundle;
    .locals 9

    .line 557
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 558
    .local v0, "state":Landroid/os/Bundle;
    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    if-eqz v1, :cond_0

    .line 559
    const-string v1, "android:menu:checked"

    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    invoke-virtual {v2}, Landroid/support/v7/view/menu/MenuItemImpl;->getItemId()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 562
    :cond_0
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    .line 563
    .local v1, "actionViewStates":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/design/internal/ParcelableSparseArray;>;"
    const/4 v2, 0x0

    .line 563
    .local v2, "i":I
    iget-object v3, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 563
    .local v3, "size":I
    :goto_0
    if-ge v2, v3, :cond_3

    .line 564
    iget-object v4, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;

    .line 565
    .local v4, "navigationMenuItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    instance-of v5, v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    if-eqz v5, :cond_2

    .line 566
    move-object v5, v4

    check-cast v5, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-virtual {v5}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v5

    .line 567
    .local v5, "item":Landroid/support/v7/view/menu/MenuItemImpl;
    if-eqz v5, :cond_1

    invoke-virtual {v5}, Landroid/support/v7/view/menu/MenuItemImpl;->getActionView()Landroid/view/View;

    move-result-object v6

    goto :goto_1

    :cond_1
    const/4 v6, 0x0

    .line 568
    .local v6, "actionView":Landroid/view/View;
    :goto_1
    if-eqz v6, :cond_2

    .line 569
    new-instance v7, Landroid/support/design/internal/ParcelableSparseArray;

    invoke-direct {v7}, Landroid/support/design/internal/ParcelableSparseArray;-><init>()V

    .line 570
    .local v7, "container":Landroid/support/design/internal/ParcelableSparseArray;
    invoke-virtual {v6, v7}, Landroid/view/View;->saveHierarchyState(Landroid/util/SparseArray;)V

    .line 571
    invoke-virtual {v5}, Landroid/support/v7/view/menu/MenuItemImpl;->getItemId()I

    move-result v8

    invoke-virtual {v1, v8, v7}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 563
    .end local v4    # "navigationMenuItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    .end local v5    # "item":Landroid/support/v7/view/menu/MenuItemImpl;
    .end local v6    # "actionView":Landroid/view/View;
    .end local v7    # "container":Landroid/support/design/internal/ParcelableSparseArray;
    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 575
    .end local v2    # "i":I
    .end local v3    # "size":I
    :cond_3
    const-string v2, "android:menu:action_views"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putSparseParcelableArray(Ljava/lang/String;Landroid/util/SparseArray;)V

    .line 576
    return-object v0
.end method

.method public getItemCount()I
    .locals 1

    .line 377
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    return v0
.end method

.method public getItemId(I)J
    .locals 2
    .param p1, "position"    # I

    .line 372
    int-to-long v0, p1

    return-wide v0
.end method

.method public getItemViewType(I)I
    .locals 3
    .param p1, "position"    # I

    .line 382
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;

    .line 383
    .local v0, "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    instance-of v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;

    if-eqz v1, :cond_0

    .line 384
    const/4 v1, 0x2

    return v1

    .line 385
    :cond_0
    instance-of v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuHeaderItem;

    if-eqz v1, :cond_1

    .line 386
    const/4 v1, 0x3

    return v1

    .line 387
    :cond_1
    instance-of v1, v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    if-eqz v1, :cond_3

    .line 388
    move-object v1, v0

    check-cast v1, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    .line 389
    .local v1, "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    invoke-virtual {v1}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v2

    invoke-virtual {v2}, Landroid/support/v7/view/menu/MenuItemImpl;->hasSubMenu()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 390
    const/4 v2, 0x1

    return v2

    .line 392
    :cond_2
    const/4 v2, 0x0

    return v2

    .line 395
    .end local v1    # "textItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    :cond_3
    new-instance v1, Ljava/lang/RuntimeException;

    const-string v2, "Unknown item type."

    invoke-direct {v1, v2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v1
.end method

.method public onBindViewHolder(Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;I)V
    .locals 5
    .param p1, "holder"    # Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;
    .param p2, "position"    # I

    .line 415
    invoke-virtual {p0, p2}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->getItemViewType(I)I

    move-result v0

    const/4 v1, 0x0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_1

    .line 439
    :pswitch_0
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    .line 440
    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;

    .line 441
    .local v0, "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;
    iget-object v2, p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;->itemView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;->getPaddingTop()I

    move-result v3

    .line 442
    invoke-virtual {v0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;->getPaddingBottom()I

    move-result v4

    .line 441
    invoke-virtual {v2, v1, v3, v1, v4}, Landroid/view/View;->setPadding(IIII)V

    .line 443
    goto :goto_1

    .line 433
    .end local v0    # "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuSeparatorItem;
    :pswitch_1
    iget-object v0, p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;->itemView:Landroid/view/View;

    check-cast v0, Landroid/widget/TextView;

    .line 434
    .local v0, "subHeader":Landroid/widget/TextView;
    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v1, p2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    .line 435
    .local v1, "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    invoke-virtual {v1}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v2

    invoke-virtual {v2}, Landroid/support/v7/view/menu/MenuItemImpl;->getTitle()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 436
    goto :goto_1

    .line 417
    .end local v0    # "subHeader":Landroid/widget/TextView;
    .end local v1    # "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    :pswitch_2
    iget-object v0, p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;->itemView:Landroid/view/View;

    check-cast v0, Landroid/support/design/internal/NavigationMenuItemView;

    .line 418
    .local v0, "itemView":Landroid/support/design/internal/NavigationMenuItemView;
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mIconTintList:Landroid/content/res/ColorStateList;

    invoke-virtual {v0, v2}, Landroid/support/design/internal/NavigationMenuItemView;->setIconTintList(Landroid/content/res/ColorStateList;)V

    .line 419
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-boolean v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mTextAppearanceSet:Z

    if-eqz v2, :cond_0

    .line 420
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mTextAppearance:I

    invoke-virtual {v0, v2}, Landroid/support/design/internal/NavigationMenuItemView;->setTextAppearance(I)V

    .line 422
    :cond_0
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mTextColor:Landroid/content/res/ColorStateList;

    if-eqz v2, :cond_1

    .line 423
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mTextColor:Landroid/content/res/ColorStateList;

    invoke-virtual {v0, v2}, Landroid/support/design/internal/NavigationMenuItemView;->setTextColor(Landroid/content/res/ColorStateList;)V

    .line 425
    :cond_1
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mItemBackground:Landroid/graphics/drawable/Drawable;

    if-eqz v2, :cond_2

    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mItemBackground:Landroid/graphics/drawable/Drawable;

    .line 426
    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    goto :goto_0

    :cond_2
    const/4 v2, 0x0

    .line 425
    :goto_0
    invoke-static {v0, v2}, Landroid/support/v4/view/ViewCompat;->setBackground(Landroid/view/View;Landroid/graphics/drawable/Drawable;)V

    .line 427
    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v2, p2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    .line 428
    .local v2, "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    iget-boolean v3, v2, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->needsEmptyIcon:Z

    invoke-virtual {v0, v3}, Landroid/support/design/internal/NavigationMenuItemView;->setNeedsEmptyIcon(Z)V

    .line 429
    invoke-virtual {v2}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v3

    invoke-virtual {v0, v3, v1}, Landroid/support/design/internal/NavigationMenuItemView;->initialize(Landroid/support/v7/view/menu/MenuItemImpl;I)V

    .line 430
    nop

    .line 450
    .end local v0    # "itemView":Landroid/support/design/internal/NavigationMenuItemView;
    .end local v2    # "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;
    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public bridge synthetic onBindViewHolder(Landroid/support/v7/widget/RecyclerView$ViewHolder;I)V
    .locals 0

    .line 352
    check-cast p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;

    invoke-virtual {p0, p1, p2}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->onBindViewHolder(Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;I)V

    return-void
.end method

.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;
    .locals 3
    .param p1, "parent"    # Landroid/view/ViewGroup;
    .param p2, "viewType"    # I

    .line 400
    packed-switch p2, :pswitch_data_0

    .line 410
    const/4 v0, 0x0

    return-object v0

    .line 408
    :pswitch_0
    new-instance v0, Landroid/support/design/internal/NavigationMenuPresenter$HeaderViewHolder;

    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v1, v1, Landroid/support/design/internal/NavigationMenuPresenter;->mHeaderLayout:Landroid/widget/LinearLayout;

    invoke-direct {v0, v1}, Landroid/support/design/internal/NavigationMenuPresenter$HeaderViewHolder;-><init>(Landroid/view/View;)V

    return-object v0

    .line 406
    :pswitch_1
    new-instance v0, Landroid/support/design/internal/NavigationMenuPresenter$SeparatorViewHolder;

    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v1, v1, Landroid/support/design/internal/NavigationMenuPresenter;->mLayoutInflater:Landroid/view/LayoutInflater;

    invoke-direct {v0, v1, p1}, Landroid/support/design/internal/NavigationMenuPresenter$SeparatorViewHolder;-><init>(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;)V

    return-object v0

    .line 404
    :pswitch_2
    new-instance v0, Landroid/support/design/internal/NavigationMenuPresenter$SubheaderViewHolder;

    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v1, v1, Landroid/support/design/internal/NavigationMenuPresenter;->mLayoutInflater:Landroid/view/LayoutInflater;

    invoke-direct {v0, v1, p1}, Landroid/support/design/internal/NavigationMenuPresenter$SubheaderViewHolder;-><init>(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;)V

    return-object v0

    .line 402
    :pswitch_3
    new-instance v0, Landroid/support/design/internal/NavigationMenuPresenter$NormalViewHolder;

    iget-object v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v1, v1, Landroid/support/design/internal/NavigationMenuPresenter;->mLayoutInflater:Landroid/view/LayoutInflater;

    iget-object v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->this$0:Landroid/support/design/internal/NavigationMenuPresenter;

    iget-object v2, v2, Landroid/support/design/internal/NavigationMenuPresenter;->mOnClickListener:Landroid/view/View$OnClickListener;

    invoke-direct {v0, v1, p1, v2}, Landroid/support/design/internal/NavigationMenuPresenter$NormalViewHolder;-><init>(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;Landroid/view/View$OnClickListener;)V

    return-object v0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public bridge synthetic onCreateViewHolder(Landroid/view/ViewGroup;I)Landroid/support/v7/widget/RecyclerView$ViewHolder;
    .locals 0

    .line 352
    invoke-virtual {p0, p1, p2}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->onCreateViewHolder(Landroid/view/ViewGroup;I)Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;

    move-result-object p1

    return-object p1
.end method

.method public onViewRecycled(Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;)V
    .locals 1
    .param p1, "holder"    # Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;

    .line 454
    instance-of v0, p1, Landroid/support/design/internal/NavigationMenuPresenter$NormalViewHolder;

    if-eqz v0, :cond_0

    .line 455
    iget-object v0, p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;->itemView:Landroid/view/View;

    check-cast v0, Landroid/support/design/internal/NavigationMenuItemView;

    invoke-virtual {v0}, Landroid/support/design/internal/NavigationMenuItemView;->recycle()V

    .line 457
    :cond_0
    return-void
.end method

.method public bridge synthetic onViewRecycled(Landroid/support/v7/widget/RecyclerView$ViewHolder;)V
    .locals 0

    .line 352
    check-cast p1, Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;

    invoke-virtual {p0, p1}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->onViewRecycled(Landroid/support/design/internal/NavigationMenuPresenter$ViewHolder;)V

    return-void
.end method

.method public restoreInstanceState(Landroid/os/Bundle;)V
    .locals 8
    .param p1, "state"    # Landroid/os/Bundle;

    .line 580
    const-string v0, "android:menu:checked"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 581
    .local v0, "checkedItem":I
    if-eqz v0, :cond_2

    .line 582
    const/4 v2, 0x1

    iput-boolean v2, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    .line 583
    const/4 v2, 0x0

    .line 583
    .local v2, "i":I
    iget-object v3, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 583
    .local v3, "size":I
    :goto_0
    if-ge v2, v3, :cond_1

    .line 584
    iget-object v4, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;

    .line 585
    .local v4, "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    instance-of v5, v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    if-eqz v5, :cond_0

    .line 586
    move-object v5, v4

    check-cast v5, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-virtual {v5}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v5

    .line 587
    .local v5, "menuItem":Landroid/support/v7/view/menu/MenuItemImpl;
    if-eqz v5, :cond_0

    invoke-virtual {v5}, Landroid/support/v7/view/menu/MenuItemImpl;->getItemId()I

    move-result v6

    if-ne v6, v0, :cond_0

    .line 588
    invoke-virtual {p0, v5}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->setCheckedItem(Landroid/support/v7/view/menu/MenuItemImpl;)V

    .line 589
    goto :goto_1

    .line 583
    .end local v4    # "item":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    .end local v5    # "menuItem":Landroid/support/v7/view/menu/MenuItemImpl;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 593
    .end local v2    # "i":I
    .end local v3    # "size":I
    :cond_1
    :goto_1
    iput-boolean v1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    .line 594
    invoke-direct {p0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->prepareMenuItems()V

    .line 597
    :cond_2
    const-string v1, "android:menu:action_views"

    .line 598
    invoke-virtual {p1, v1}, Landroid/os/Bundle;->getSparseParcelableArray(Ljava/lang/String;)Landroid/util/SparseArray;

    move-result-object v1

    .line 599
    .local v1, "actionViewStates":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/design/internal/ParcelableSparseArray;>;"
    if-eqz v1, :cond_7

    .line 600
    const/4 v2, 0x0

    .line 600
    .restart local v2    # "i":I
    iget-object v3, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    .line 600
    .restart local v3    # "size":I
    :goto_2
    if-ge v2, v3, :cond_7

    .line 601
    iget-object v4, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mItems:Ljava/util/ArrayList;

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;

    .line 602
    .local v4, "navigationMenuItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    instance-of v5, v4, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    if-nez v5, :cond_3

    .line 603
    goto :goto_3

    .line 605
    :cond_3
    move-object v5, v4

    check-cast v5, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;

    invoke-virtual {v5}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuTextItem;->getMenuItem()Landroid/support/v7/view/menu/MenuItemImpl;

    move-result-object v5

    .line 606
    .local v5, "item":Landroid/support/v7/view/menu/MenuItemImpl;
    if-nez v5, :cond_4

    .line 607
    goto :goto_3

    .line 609
    :cond_4
    invoke-virtual {v5}, Landroid/support/v7/view/menu/MenuItemImpl;->getActionView()Landroid/view/View;

    move-result-object v6

    .line 610
    .local v6, "actionView":Landroid/view/View;
    if-nez v6, :cond_5

    .line 611
    goto :goto_3

    .line 613
    :cond_5
    invoke-virtual {v5}, Landroid/support/v7/view/menu/MenuItemImpl;->getItemId()I

    move-result v7

    invoke-virtual {v1, v7}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/support/design/internal/ParcelableSparseArray;

    .line 614
    .local v7, "container":Landroid/support/design/internal/ParcelableSparseArray;
    if-nez v7, :cond_6

    .line 615
    goto :goto_3

    .line 617
    :cond_6
    invoke-virtual {v6, v7}, Landroid/view/View;->restoreHierarchyState(Landroid/util/SparseArray;)V

    .line 600
    .end local v4    # "navigationMenuItem":Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuItem;
    .end local v5    # "item":Landroid/support/v7/view/menu/MenuItemImpl;
    .end local v6    # "actionView":Landroid/view/View;
    .end local v7    # "container":Landroid/support/design/internal/ParcelableSparseArray;
    :goto_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 620
    .end local v2    # "i":I
    .end local v3    # "size":I
    :cond_7
    return-void
.end method

.method public setCheckedItem(Landroid/support/v7/view/menu/MenuItemImpl;)V
    .locals 2
    .param p1, "checkedItem"    # Landroid/support/v7/view/menu/MenuItemImpl;

    .line 546
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    if-eq v0, p1, :cond_2

    invoke-virtual {p1}, Landroid/support/v7/view/menu/MenuItemImpl;->isCheckable()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 549
    :cond_0
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    if-eqz v0, :cond_1

    .line 550
    iget-object v0, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/support/v7/view/menu/MenuItemImpl;->setChecked(Z)Landroid/view/MenuItem;

    .line 552
    :cond_1
    iput-object p1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mCheckedItem:Landroid/support/v7/view/menu/MenuItemImpl;

    .line 553
    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/support/v7/view/menu/MenuItemImpl;->setChecked(Z)Landroid/view/MenuItem;

    .line 554
    return-void

    .line 547
    :cond_2
    :goto_0
    return-void
.end method

.method public setUpdateSuspended(Z)V
    .locals 0
    .param p1, "updateSuspended"    # Z

    .line 623
    iput-boolean p1, p0, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->mUpdateSuspended:Z

    .line 624
    return-void
.end method

.method public update()V
    .locals 0

    .line 460
    invoke-direct {p0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->prepareMenuItems()V

    .line 461
    invoke-virtual {p0}, Landroid/support/design/internal/NavigationMenuPresenter$NavigationMenuAdapter;->notifyDataSetChanged()V

    .line 462
    return-void
.end method
