.class Landroid/support/v4/app/NotificationCompat$NotificationCompatApi26Impl;
.super Landroid/support/v4/app/NotificationCompat$NotificationCompatApi24Impl;
.source "NotificationCompat.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x1a
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/app/NotificationCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "NotificationCompatApi26Impl"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 919
    invoke-direct {p0}, Landroid/support/v4/app/NotificationCompat$NotificationCompatApi24Impl;-><init>()V

    return-void
.end method


# virtual methods
.method public build(Landroid/support/v4/app/NotificationCompat$Builder;Landroid/support/v4/app/NotificationCompat$BuilderExtender;)Landroid/app/Notification;
    .locals 65
    .param p1, "b"    # Landroid/support/v4/app/NotificationCompat$Builder;
    .param p2, "extender"    # Landroid/support/v4/app/NotificationCompat$BuilderExtender;

    move-object/from16 v0, p1

    .line 923
    new-instance v41, Landroid/support/v4/app/NotificationCompatApi26$Builder;

    iget-object v2, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContext:Landroid/content/Context;

    iget-object v3, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mNotification:Landroid/app/Notification;

    iget-object v4, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContentTitle:Ljava/lang/CharSequence;

    iget-object v5, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContentText:Ljava/lang/CharSequence;

    iget-object v6, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContentInfo:Ljava/lang/CharSequence;

    iget-object v7, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mTickerView:Landroid/widget/RemoteViews;

    iget v8, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mNumber:I

    iget-object v9, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContentIntent:Landroid/app/PendingIntent;

    iget-object v10, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mFullScreenIntent:Landroid/app/PendingIntent;

    iget-object v11, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mLargeIcon:Landroid/graphics/Bitmap;

    iget v12, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mProgressMax:I

    iget v13, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mProgress:I

    iget-boolean v14, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mProgressIndeterminate:Z

    iget-boolean v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mShowWhen:Z

    iget-boolean v1, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mUseChronometer:Z

    move/from16 v42, v15

    iget v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mPriority:I

    move/from16 v43, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mSubText:Ljava/lang/CharSequence;

    move-object/from16 v44, v15

    iget-boolean v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mLocalOnly:Z

    move/from16 v45, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mCategory:Ljava/lang/String;

    move-object/from16 v46, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mPeople:Ljava/util/ArrayList;

    move-object/from16 v47, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mExtras:Landroid/os/Bundle;

    move-object/from16 v48, v15

    iget v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mColor:I

    move/from16 v49, v15

    iget v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mVisibility:I

    move/from16 v50, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mPublicVersion:Landroid/app/Notification;

    move-object/from16 v51, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mGroupKey:Ljava/lang/String;

    move-object/from16 v52, v15

    iget-boolean v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mGroupSummary:Z

    move/from16 v53, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mSortKey:Ljava/lang/String;

    move-object/from16 v54, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mRemoteInputHistory:[Ljava/lang/CharSequence;

    move-object/from16 v55, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mContentView:Landroid/widget/RemoteViews;

    move-object/from16 v56, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mBigContentView:Landroid/widget/RemoteViews;

    move-object/from16 v57, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mHeadsUpContentView:Landroid/widget/RemoteViews;

    move-object/from16 v58, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mChannelId:Ljava/lang/String;

    move-object/from16 v59, v15

    iget v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mBadgeIcon:I

    move/from16 v60, v15

    iget-object v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mShortcutId:Ljava/lang/String;

    move/from16 v61, v14

    move-object/from16 v62, v15

    iget-wide v14, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mTimeout:J

    move-wide/from16 v63, v14

    iget-boolean v15, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mColorized:Z

    iget-boolean v14, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mColorizedSet:Z

    .line 932
    invoke-static/range {p1 .. p1}, Landroid/support/v4/app/NotificationCompat$Builder;->access$000(Landroid/support/v4/app/NotificationCompat$Builder;)I

    move-result v40

    move/from16 v16, v1

    move-object/from16 v1, v41

    move/from16 v39, v14

    move-wide/from16 v36, v63

    move/from16 v14, v61

    move/from16 v38, v15

    move/from16 v17, v43

    move-object/from16 v18, v44

    move/from16 v19, v45

    move-object/from16 v20, v46

    move-object/from16 v21, v47

    move-object/from16 v22, v48

    move/from16 v23, v49

    move/from16 v24, v50

    move-object/from16 v25, v51

    move-object/from16 v26, v52

    move/from16 v27, v53

    move-object/from16 v28, v54

    move-object/from16 v29, v55

    move-object/from16 v30, v56

    move-object/from16 v31, v57

    move-object/from16 v32, v58

    move-object/from16 v33, v59

    move/from16 v34, v60

    move-object/from16 v35, v62

    move/from16 v15, v42

    invoke-direct/range {v1 .. v40}, Landroid/support/v4/app/NotificationCompatApi26$Builder;-><init>(Landroid/content/Context;Landroid/app/Notification;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Landroid/widget/RemoteViews;ILandroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/graphics/Bitmap;IIZZZILjava/lang/CharSequence;ZLjava/lang/String;Ljava/util/ArrayList;Landroid/os/Bundle;IILandroid/app/Notification;Ljava/lang/String;ZLjava/lang/String;[Ljava/lang/CharSequence;Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;Landroid/widget/RemoteViews;Ljava/lang/String;ILjava/lang/String;JZZI)V

    .line 933
    .local v1, "builder":Landroid/support/v4/app/NotificationCompatApi26$Builder;
    iget-object v2, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mActions:Ljava/util/ArrayList;

    invoke-static {v1, v2}, Landroid/support/v4/app/NotificationCompat;->addActionsToBuilder(Landroid/support/v4/app/NotificationBuilderWithActions;Ljava/util/ArrayList;)V

    .line 934
    iget-object v2, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mStyle:Landroid/support/v4/app/NotificationCompat$Style;

    if-eqz v2, :cond_0

    .line 935
    iget-object v2, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mStyle:Landroid/support/v4/app/NotificationCompat$Style;

    invoke-virtual {v2, v1}, Landroid/support/v4/app/NotificationCompat$Style;->apply(Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)V

    .line 937
    :cond_0
    move-object/from16 v2, p2

    invoke-virtual {v2, v0, v1}, Landroid/support/v4/app/NotificationCompat$BuilderExtender;->build(Landroid/support/v4/app/NotificationCompat$Builder;Landroid/support/v4/app/NotificationBuilderWithBuilderAccessor;)Landroid/app/Notification;

    move-result-object v3

    .line 938
    .local v3, "notification":Landroid/app/Notification;
    iget-object v4, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mStyle:Landroid/support/v4/app/NotificationCompat$Style;

    if-eqz v4, :cond_1

    .line 939
    iget-object v4, v0, Landroid/support/v4/app/NotificationCompat$Builder;->mStyle:Landroid/support/v4/app/NotificationCompat$Style;

    invoke-static {v3}, Landroid/support/v4/app/NotificationCompat;->getExtras(Landroid/app/Notification;)Landroid/os/Bundle;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/support/v4/app/NotificationCompat$Style;->addCompatExtras(Landroid/os/Bundle;)V

    .line 941
    :cond_1
    return-object v3
.end method
