.class public Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;
.super Landroid/support/v4/media/app/NotificationCompat$MediaStyle;
.source "NotificationCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/media/app/NotificationCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DecoratedMediaCustomViewStyle"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 378
    invoke-direct {p0}, Landroid/support/v4/media/app/NotificationCompat$MediaStyle;-><init>()V

    .line 379
    return-void
.end method

.method private setBackgroundColor(Landroid/widget/RemoteViews;)V
    .locals 3
    .param p1, "views"    # Landroid/widget/RemoteViews;

    .line 495
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getColor()I

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 496
    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getColor()I

    move-result v0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    iget-object v0, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContext:Landroid/content/Context;

    .line 497
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    sget v1, Landroid/support/mediacompat/R$color;->notification_material_background_media_default_color:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getColor(I)I

    move-result v0

    .line 499
    .local v0, "color":I
    :goto_0
    sget v1, Landroid/support/mediacompat/R$id;->status_bar_latest_event_content:I

    const-string v2, "setBackgroundColor"

    invoke-virtual {p1, v1, v2, v0}, Landroid/widget/RemoteViews;->setInt(ILjava/lang/String;I)V

    .line 500
    return-void
.end method


# virtual methods
.method public apply(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)V
    .locals 2
    .param p1, "builder"    # Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 387
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x18

    if-lt v0, v1, :cond_0

    .line 388
    invoke-interface {p1}, Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;->getBuilder()Landroid/app/Notification$Builder;

    move-result-object v0

    new-instance v1, Landroid/app/Notification$DecoratedMediaCustomViewStyle;

    invoke-direct {v1}, Landroid/app/Notification$DecoratedMediaCustomViewStyle;-><init>()V

    .line 389
    invoke-virtual {p0, v1}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->fillInMediaStyle(Landroid/app/Notification$MediaStyle;)Landroid/app/Notification$MediaStyle;

    move-result-object v1

    .line 388
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setStyle(Landroid/app/Notification$Style;)Landroid/app/Notification$Builder;

    goto :goto_0

    .line 391
    :cond_0
    invoke-super {p0, p1}, Landroid/support/v4/media/app/NotificationCompat$MediaStyle;->apply(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)V

    .line 393
    :goto_0
    return-void
.end method

.method getBigContentViewLayoutResource(I)I
    .locals 1
    .param p1, "actionCount"    # I

    .line 464
    const/4 v0, 0x3

    if-gt p1, v0, :cond_0

    sget v0, Landroid/support/mediacompat/R$layout;->notification_template_big_media_narrow_custom:I

    goto :goto_0

    :cond_0
    sget v0, Landroid/support/mediacompat/R$layout;->notification_template_big_media_custom:I

    :goto_0
    return v0
.end method

.method getContentViewLayoutResource()I
    .locals 1

    .line 432
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    if-eqz v0, :cond_0

    sget v0, Landroid/support/mediacompat/R$layout;->notification_template_media_custom:I

    goto :goto_0

    .line 434
    :cond_0
    invoke-super {p0}, Landroid/support/v4/media/app/NotificationCompat$MediaStyle;->getContentViewLayoutResource()I

    move-result v0

    :goto_0
    return v0
.end method

.method public makeBigContentView(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)Landroid/widget/RemoteViews;
    .locals 4
    .param p1, "builder"    # Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 443
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x18

    if-lt v0, v2, :cond_0

    .line 445
    return-object v1

    .line 447
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getBigContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 448
    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getBigContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    goto :goto_0

    :cond_1
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 449
    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    .line 450
    .local v0, "innerView":Landroid/widget/RemoteViews;
    :goto_0
    if-nez v0, :cond_2

    .line 452
    return-object v1

    .line 454
    :cond_2
    invoke-virtual {p0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->generateBigContentView()Landroid/widget/RemoteViews;

    move-result-object v1

    .line 455
    .local v1, "bigContentView":Landroid/widget/RemoteViews;
    invoke-virtual {p0, v1, v0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->buildIntoRemoteViews(Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;)V

    .line 456
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_3

    .line 457
    invoke-direct {p0, v1}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->setBackgroundColor(Landroid/widget/RemoteViews;)V

    .line 459
    :cond_3
    return-object v1
.end method

.method public makeContentView(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)Landroid/widget/RemoteViews;
    .locals 6
    .param p1, "builder"    # Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 401
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x18

    if-lt v0, v2, :cond_0

    .line 403
    return-object v1

    .line 405
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v0, :cond_1

    move v0, v3

    goto :goto_0

    :cond_1
    move v0, v2

    .line 406
    .local v0, "hasContentView":Z
    :goto_0
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x15

    if-lt v4, v5, :cond_6

    .line 410
    if-nez v0, :cond_3

    iget-object v4, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 411
    invoke-virtual {v4}, Landroid/support/v4/app/NotificationCompat$Builder;->getBigContentView()Landroid/widget/RemoteViews;

    move-result-object v4

    if-eqz v4, :cond_2

    goto :goto_1

    :cond_2
    goto :goto_2

    :cond_3
    :goto_1
    move v2, v3

    .line 412
    .local v2, "createCustomContent":Z
    :goto_2
    if-eqz v2, :cond_5

    .line 413
    invoke-virtual {p0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->generateContentView()Landroid/widget/RemoteViews;

    move-result-object v1

    .line 414
    .local v1, "contentView":Landroid/widget/RemoteViews;
    if-eqz v0, :cond_4

    .line 415
    iget-object v3, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v3}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v3

    invoke-virtual {p0, v1, v3}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->buildIntoRemoteViews(Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;)V

    .line 417
    :cond_4
    invoke-direct {p0, v1}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->setBackgroundColor(Landroid/widget/RemoteViews;)V

    .line 418
    return-object v1

    .line 420
    .end local v1    # "contentView":Landroid/widget/RemoteViews;
    .end local v2    # "createCustomContent":Z
    :cond_5
    goto :goto_3

    .line 421
    :cond_6
    invoke-virtual {p0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->generateContentView()Landroid/widget/RemoteViews;

    move-result-object v2

    .line 422
    .local v2, "contentView":Landroid/widget/RemoteViews;
    if-eqz v0, :cond_7

    .line 423
    iget-object v1, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v1}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v1

    invoke-virtual {p0, v2, v1}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->buildIntoRemoteViews(Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;)V

    .line 424
    return-object v2

    .line 427
    .end local v2    # "contentView":Landroid/widget/RemoteViews;
    :cond_7
    :goto_3
    return-object v1
.end method

.method public makeHeadsUpContentView(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)Landroid/widget/RemoteViews;
    .locals 4
    .param p1, "builder"    # Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 475
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x18

    if-lt v0, v2, :cond_0

    .line 477
    return-object v1

    .line 479
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getHeadsUpContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 480
    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getHeadsUpContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    goto :goto_0

    :cond_1
    iget-object v0, p0, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->mBuilder:Landroid/support/v4/app/NotificationCompat$Builder;

    .line 481
    invoke-virtual {v0}, Landroid/support/v4/app/NotificationCompat$Builder;->getContentView()Landroid/widget/RemoteViews;

    move-result-object v0

    .line 482
    .local v0, "innerView":Landroid/widget/RemoteViews;
    :goto_0
    if-nez v0, :cond_2

    .line 484
    return-object v1

    .line 486
    :cond_2
    invoke-virtual {p0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->generateBigContentView()Landroid/widget/RemoteViews;

    move-result-object v1

    .line 487
    .local v1, "headsUpContentView":Landroid/widget/RemoteViews;
    invoke-virtual {p0, v1, v0}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->buildIntoRemoteViews(Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;)V

    .line 488
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_3

    .line 489
    invoke-direct {p0, v1}, Landroid/support/v4/media/app/NotificationCompat$DecoratedMediaCustomViewStyle;->setBackgroundColor(Landroid/widget/RemoteViews;)V

    .line 491
    :cond_3
    return-object v1
.end method
