.class public Landroid/support/v4/app/NotificationCompatJellybean$Builder;
.super Ljava/lang/Object;
.source "NotificationCompatJellybean.java"

# interfaces
.implements Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;
.implements Landroid/support/v4/app/NotificationBuilderWithActions;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/app/NotificationCompatJellybean;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation


# instance fields
.field private b:Landroid/app/Notification$Builder;

.field private mActionExtrasList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/os/Bundle;",
            ">;"
        }
    .end annotation
.end field

.field private mBigContentView:Landroid/widget/RemoteViews;

.field private mContentView:Landroid/widget/RemoteViews;

.field private final mExtras:Landroid/os/Bundle;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/app/Notification;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Landroid/widget/RemoteViews;ILandroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/graphics/Bitmap;IIZZILjava/lang/CharSequence;ZLandroid/os/Bundle;Ljava/lang/String;ZLjava/lang/String;Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;)V
    .locals 17
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "n"    # Landroid/app/Notification;
    .param p3, "contentTitle"    # Ljava/lang/CharSequence;
    .param p4, "contentText"    # Ljava/lang/CharSequence;
    .param p5, "contentInfo"    # Ljava/lang/CharSequence;
    .param p6, "tickerView"    # Landroid/widget/RemoteViews;
    .param p7, "number"    # I
    .param p8, "contentIntent"    # Landroid/app/PendingIntent;
    .param p9, "fullScreenIntent"    # Landroid/app/PendingIntent;
    .param p10, "largeIcon"    # Landroid/graphics/Bitmap;
    .param p11, "progressMax"    # I
    .param p12, "progress"    # I
    .param p13, "progressIndeterminate"    # Z
    .param p14, "useChronometer"    # Z
    .param p15, "priority"    # I
    .param p16, "subText"    # Ljava/lang/CharSequence;
    .param p17, "localOnly"    # Z
    .param p18, "extras"    # Landroid/os/Bundle;
    .param p19, "groupKey"    # Ljava/lang/String;
    .param p20, "groupSummary"    # Z
    .param p21, "sortKey"    # Ljava/lang/String;
    .param p22, "contentView"    # Landroid/widget/RemoteViews;
    .param p23, "bigContentView"    # Landroid/widget/RemoteViews;

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    move-object/from16 v2, p18

    move-object/from16 v3, p19

    move-object/from16 v4, p21

    .line 77
    invoke-direct/range {p0 .. p0}, Ljava/lang/Object;-><init>()V

    .line 66
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    iput-object v5, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mActionExtrasList:Ljava/util/List;

    .line 78
    new-instance v5, Landroid/app/Notification$Builder;

    move-object/from16 v6, p1

    invoke-direct {v5, v6}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    iget-wide v7, v1, Landroid/app/Notification;->when:J

    .line 79
    invoke-virtual {v5, v7, v8}, Landroid/app/Notification$Builder;->setWhen(J)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->icon:I

    iget v8, v1, Landroid/app/Notification;->iconLevel:I

    .line 80
    invoke-virtual {v5, v7, v8}, Landroid/app/Notification$Builder;->setSmallIcon(II)Landroid/app/Notification$Builder;

    move-result-object v5

    iget-object v7, v1, Landroid/app/Notification;->contentView:Landroid/widget/RemoteViews;

    .line 81
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setContent(Landroid/widget/RemoteViews;)Landroid/app/Notification$Builder;

    move-result-object v5

    iget-object v7, v1, Landroid/app/Notification;->tickerText:Ljava/lang/CharSequence;

    .line 82
    move-object/from16 v8, p6

    invoke-virtual {v5, v7, v8}, Landroid/app/Notification$Builder;->setTicker(Ljava/lang/CharSequence;Landroid/widget/RemoteViews;)Landroid/app/Notification$Builder;

    move-result-object v5

    iget-object v7, v1, Landroid/app/Notification;->sound:Landroid/net/Uri;

    iget v9, v1, Landroid/app/Notification;->audioStreamType:I

    .line 83
    invoke-virtual {v5, v7, v9}, Landroid/app/Notification$Builder;->setSound(Landroid/net/Uri;I)Landroid/app/Notification$Builder;

    move-result-object v5

    iget-object v7, v1, Landroid/app/Notification;->vibrate:[J

    .line 84
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setVibrate([J)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->ledARGB:I

    iget v9, v1, Landroid/app/Notification;->ledOnMS:I

    iget v10, v1, Landroid/app/Notification;->ledOffMS:I

    .line 85
    invoke-virtual {v5, v7, v9, v10}, Landroid/app/Notification$Builder;->setLights(III)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->flags:I

    and-int/lit8 v7, v7, 0x2

    const/4 v9, 0x0

    if-eqz v7, :cond_0

    .line 86
    const/4 v7, 0x1

    goto :goto_0

    .line 85
    :cond_0
    nop

    .line 86
    move v7, v9

    :goto_0
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->flags:I

    and-int/lit8 v7, v7, 0x8

    if-eqz v7, :cond_1

    .line 87
    const/4 v7, 0x1

    goto :goto_1

    .line 86
    :cond_1
    nop

    .line 87
    move v7, v9

    :goto_1
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setOnlyAlertOnce(Z)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->flags:I

    and-int/lit8 v7, v7, 0x10

    if-eqz v7, :cond_2

    .line 88
    const/4 v7, 0x1

    goto :goto_2

    .line 87
    :cond_2
    nop

    .line 88
    move v7, v9

    :goto_2
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v7, v1, Landroid/app/Notification;->defaults:I

    .line 89
    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setDefaults(I)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 90
    move-object/from16 v7, p3

    invoke-virtual {v5, v7}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 91
    move-object/from16 v11, p4

    invoke-virtual {v5, v11}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 92
    move-object/from16 v12, p16

    invoke-virtual {v5, v12}, Landroid/app/Notification$Builder;->setSubText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 93
    move-object/from16 v13, p5

    invoke-virtual {v5, v13}, Landroid/app/Notification$Builder;->setContentInfo(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 94
    move-object/from16 v14, p8

    invoke-virtual {v5, v14}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v5

    iget-object v15, v1, Landroid/app/Notification;->deleteIntent:Landroid/app/PendingIntent;

    .line 95
    invoke-virtual {v5, v15}, Landroid/app/Notification$Builder;->setDeleteIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v5

    iget v15, v1, Landroid/app/Notification;->flags:I

    and-int/lit16 v15, v15, 0x80

    if-eqz v15, :cond_3

    .line 96
    const/4 v9, 0x1

    goto :goto_3

    .line 95
    :cond_3
    nop

    .line 96
    :goto_3
    move-object/from16 v15, p9

    invoke-virtual {v5, v15, v9}, Landroid/app/Notification$Builder;->setFullScreenIntent(Landroid/app/PendingIntent;Z)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 98
    move-object/from16 v9, p10

    invoke-virtual {v5, v9}, Landroid/app/Notification$Builder;->setLargeIcon(Landroid/graphics/Bitmap;)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 99
    move/from16 v10, p7

    invoke-virtual {v5, v10}, Landroid/app/Notification$Builder;->setNumber(I)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 100
    move/from16 v1, p14

    invoke-virtual {v5, v1}, Landroid/app/Notification$Builder;->setUsesChronometer(Z)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 101
    move/from16 v1, p15

    invoke-virtual {v5, v1}, Landroid/app/Notification$Builder;->setPriority(I)Landroid/app/Notification$Builder;

    move-result-object v5

    .line 102
    move/from16 v1, p11

    move/from16 v6, p12

    move/from16 v7, p13

    invoke-virtual {v5, v1, v6, v7}, Landroid/app/Notification$Builder;->setProgress(IIZ)Landroid/app/Notification$Builder;

    move-result-object v5

    iput-object v5, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->b:Landroid/app/Notification$Builder;

    .line 103
    new-instance v5, Landroid/os/Bundle;

    invoke-direct {v5}, Landroid/os/Bundle;-><init>()V

    iput-object v5, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    .line 104
    if-eqz v2, :cond_4

    .line 105
    iget-object v5, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    invoke-virtual {v5, v2}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V

    .line 107
    :cond_4
    if-eqz p17, :cond_5

    .line 108
    iget-object v1, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    const-string v2, "android.support.localOnly"

    const/4 v5, 0x1

    invoke-virtual {v1, v2, v5}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 110
    :cond_5
    if-eqz v3, :cond_7

    .line 111
    iget-object v1, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    const-string v2, "android.support.groupKey"

    invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 112
    if-eqz p20, :cond_6

    .line 113
    iget-object v2, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    const-string v5, "android.support.isGroupSummary"

    const/4 v1, 0x1

    invoke-virtual {v2, v5, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    goto :goto_4

    .line 115
    :cond_6
    const/4 v1, 0x1

    iget-object v2, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    const-string v5, "android.support.useSideChannel"

    invoke-virtual {v2, v5, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 118
    :cond_7
    :goto_4
    if-eqz v4, :cond_8

    .line 119
    iget-object v1, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    const-string v2, "android.support.sortKey"

    invoke-virtual {v1, v2, v4}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 121
    :cond_8
    move-object/from16 v1, p22

    iput-object v1, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mContentView:Landroid/widget/RemoteViews;

    .line 122
    move-object/from16 v2, p23

    iput-object v2, v0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mBigContentView:Landroid/widget/RemoteViews;

    .line 123
    return-void
.end method


# virtual methods
.method public addAction(Landroid/support/v4/app/NotificationCompatBase$Action;)V
    .locals 2
    .param p1, "action"    # Landroid/support/v4/app/NotificationCompatBase$Action;

    .line 127
    iget-object v0, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mActionExtrasList:Ljava/util/List;

    iget-object v1, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->b:Landroid/app/Notification$Builder;

    invoke-static {v1, p1}, Landroid/support/v4/app/NotificationCompatJellybean;->writeActionAndGetExtras(Landroid/app/Notification$Builder;Landroid/support/v4/app/NotificationCompatBase$Action;)Landroid/os/Bundle;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 128
    return-void
.end method

.method public build()Landroid/app/Notification;
    .locals 6

    .line 137
    iget-object v0, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->b:Landroid/app/Notification$Builder;

    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    .line 140
    .local v0, "notif":Landroid/app/Notification;
    invoke-static {v0}, Landroid/support/v4/app/NotificationCompatJellybean;->getExtras(Landroid/app/Notification;)Landroid/os/Bundle;

    move-result-object v1

    .line 141
    .local v1, "extras":Landroid/os/Bundle;
    new-instance v2, Landroid/os/Bundle;

    iget-object v3, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    invoke-direct {v2, v3}, Landroid/os/Bundle;-><init>(Landroid/os/Bundle;)V

    .line 142
    .local v2, "mergeBundle":Landroid/os/Bundle;
    iget-object v3, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mExtras:Landroid/os/Bundle;

    invoke-virtual {v3}, Landroid/os/Bundle;->keySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 143
    .local v4, "key":Ljava/lang/String;
    invoke-virtual {v1, v4}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 144
    invoke-virtual {v2, v4}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V

    .line 146
    .end local v4    # "key":Ljava/lang/String;
    :cond_0
    goto :goto_0

    .line 147
    :cond_1
    invoke-virtual {v1, v2}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V

    .line 148
    iget-object v3, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mActionExtrasList:Ljava/util/List;

    invoke-static {v3}, Landroid/support/v4/app/NotificationCompatJellybean;->buildActionExtrasMap(Ljava/util/List;)Landroid/util/SparseArray;

    move-result-object v3

    .line 149
    .local v3, "actionExtrasMap":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/os/Bundle;>;"
    if-eqz v3, :cond_2

    .line 151
    invoke-static {v0}, Landroid/support/v4/app/NotificationCompatJellybean;->getExtras(Landroid/app/Notification;)Landroid/os/Bundle;

    move-result-object v4

    const-string v5, "android.support.actionExtras"

    invoke-virtual {v4, v5, v3}, Landroid/os/Bundle;->putSparseParcelableArray(Ljava/lang/String;Landroid/util/SparseArray;)V

    .line 154
    :cond_2
    iget-object v4, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mContentView:Landroid/widget/RemoteViews;

    if-eqz v4, :cond_3

    .line 155
    iget-object v4, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mContentView:Landroid/widget/RemoteViews;

    iput-object v4, v0, Landroid/app/Notification;->contentView:Landroid/widget/RemoteViews;

    .line 157
    :cond_3
    iget-object v4, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mBigContentView:Landroid/widget/RemoteViews;

    if-eqz v4, :cond_4

    .line 158
    iget-object v4, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->mBigContentView:Landroid/widget/RemoteViews;

    iput-object v4, v0, Landroid/app/Notification;->bigContentView:Landroid/widget/RemoteViews;

    .line 160
    :cond_4
    return-object v0
.end method

.method public getBuilder()Landroid/app/Notification$Builder;
    .locals 1

    .line 132
    iget-object v0, p0, Landroid/support/v4/app/NotificationCompatJellybean$Builder;->b:Landroid/app/Notification$Builder;

    return-object v0
.end method
