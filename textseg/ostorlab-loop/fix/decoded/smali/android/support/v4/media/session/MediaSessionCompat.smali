.class public Landroid/support/v4/media/session/MediaSessionCompat;
.super Ljava/lang/Object;
.source "MediaSessionCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi21;,
        Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi19;,
        Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi18;,
        Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplBase;,
        Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;,
        Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;,
        Landroid/support/v4/media/session/MediaSessionCompat$ResultReceiverWrapper;,
        Landroid/support/v4/media/session/MediaSessionCompat$QueueItem;,
        Landroid/support/v4/media/session/MediaSessionCompat$Token;,
        Landroid/support/v4/media/session/MediaSessionCompat$Callback;,
        Landroid/support/v4/media/session/MediaSessionCompat$SessionFlags;
    }
.end annotation


# static fields
.field static final ACTION_ARGUMENT_CAPTIONING_ENABLED:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_CAPTIONING_ENABLED"

.field static final ACTION_ARGUMENT_EXTRAS:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_EXTRAS"

.field static final ACTION_ARGUMENT_MEDIA_ID:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_MEDIA_ID"

.field static final ACTION_ARGUMENT_QUERY:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_QUERY"

.field static final ACTION_ARGUMENT_RATING:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_RATING"

.field static final ACTION_ARGUMENT_REPEAT_MODE:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_REPEAT_MODE"

.field static final ACTION_ARGUMENT_SHUFFLE_MODE:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_SHUFFLE_MODE"

.field static final ACTION_ARGUMENT_SHUFFLE_MODE_ENABLED:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_SHUFFLE_MODE_ENABLED"

.field static final ACTION_ARGUMENT_URI:Ljava/lang/String; = "android.support.v4.media.session.action.ARGUMENT_URI"

.field public static final ACTION_FLAG_AS_INAPPROPRIATE:Ljava/lang/String; = "android.support.v4.media.session.action.FLAG_AS_INAPPROPRIATE"

.field public static final ACTION_FOLLOW:Ljava/lang/String; = "android.support.v4.media.session.action.FOLLOW"

.field static final ACTION_PLAY_FROM_URI:Ljava/lang/String; = "android.support.v4.media.session.action.PLAY_FROM_URI"

.field static final ACTION_PREPARE:Ljava/lang/String; = "android.support.v4.media.session.action.PREPARE"

.field static final ACTION_PREPARE_FROM_MEDIA_ID:Ljava/lang/String; = "android.support.v4.media.session.action.PREPARE_FROM_MEDIA_ID"

.field static final ACTION_PREPARE_FROM_SEARCH:Ljava/lang/String; = "android.support.v4.media.session.action.PREPARE_FROM_SEARCH"

.field static final ACTION_PREPARE_FROM_URI:Ljava/lang/String; = "android.support.v4.media.session.action.PREPARE_FROM_URI"

.field static final ACTION_SET_CAPTIONING_ENABLED:Ljava/lang/String; = "android.support.v4.media.session.action.SET_CAPTIONING_ENABLED"

.field static final ACTION_SET_RATING:Ljava/lang/String; = "android.support.v4.media.session.action.SET_RATING"

.field static final ACTION_SET_REPEAT_MODE:Ljava/lang/String; = "android.support.v4.media.session.action.SET_REPEAT_MODE"

.field static final ACTION_SET_SHUFFLE_MODE:Ljava/lang/String; = "android.support.v4.media.session.action.SET_SHUFFLE_MODE"

.field static final ACTION_SET_SHUFFLE_MODE_ENABLED:Ljava/lang/String; = "android.support.v4.media.session.action.SET_SHUFFLE_MODE_ENABLED"

.field public static final ACTION_SKIP_AD:Ljava/lang/String; = "android.support.v4.media.session.action.SKIP_AD"

.field public static final ACTION_UNFOLLOW:Ljava/lang/String; = "android.support.v4.media.session.action.UNFOLLOW"

.field public static final ARGUMENT_MEDIA_ATTRIBUTE:Ljava/lang/String; = "android.support.v4.media.session.ARGUMENT_MEDIA_ATTRIBUTE"

.field public static final ARGUMENT_MEDIA_ATTRIBUTE_VALUE:Ljava/lang/String; = "android.support.v4.media.session.ARGUMENT_MEDIA_ATTRIBUTE_VALUE"

.field static final EXTRA_BINDER:Ljava/lang/String; = "android.support.v4.media.session.EXTRA_BINDER"

.field public static final FLAG_HANDLES_MEDIA_BUTTONS:I = 0x1

.field public static final FLAG_HANDLES_QUEUE_COMMANDS:I = 0x4

.field public static final FLAG_HANDLES_TRANSPORT_CONTROLS:I = 0x2

.field private static final MAX_BITMAP_SIZE_IN_DP:I = 0x140

.field public static final MEDIA_ATTRIBUTE_ALBUM:I = 0x1

.field public static final MEDIA_ATTRIBUTE_ARTIST:I = 0x0

.field public static final MEDIA_ATTRIBUTE_PLAYLIST:I = 0x2

.field static final TAG:Ljava/lang/String; = "MediaSessionCompat"

.field static sMaxBitmapSize:I


# instance fields
.field private final mActiveListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;",
            ">;"
        }
    .end annotation
.end field

.field private final mController:Landroid/support/v4/media/session/MediaControllerCompat;

.field private final mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;


# direct methods
.method private constructor <init>(Landroid/content/Context;Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "impl"    # Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 427
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 104
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mActiveListeners:Ljava/util/ArrayList;

    .line 428
    iput-object p2, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 429
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_0

    .line 430
    invoke-interface {p2}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getMediaSession()Ljava/lang/Object;

    move-result-object v0

    invoke-static {v0}, Landroid/support/v4/media/session/MediaSessionCompatApi21;->hasCallback(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 432
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$2;

    invoke-direct {v0, p0}, Landroid/support/v4/media/session/MediaSessionCompat$2;-><init>(Landroid/support/v4/media/session/MediaSessionCompat;)V

    invoke-virtual {p0, v0}, Landroid/support/v4/media/session/MediaSessionCompat;->setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V

    .line 434
    :cond_0
    new-instance v0, Landroid/support/v4/media/session/MediaControllerCompat;

    invoke-direct {v0, p1, p0}, Landroid/support/v4/media/session/MediaControllerCompat;-><init>(Landroid/content/Context;Landroid/support/v4/media/session/MediaSessionCompat;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mController:Landroid/support/v4/media/session/MediaControllerCompat;

    .line 435
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "tag"    # Ljava/lang/String;

    .line 359
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0, v0}, Landroid/support/v4/media/session/MediaSessionCompat;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/content/ComponentName;Landroid/app/PendingIntent;)V

    .line 360
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;Landroid/content/ComponentName;Landroid/app/PendingIntent;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "tag"    # Ljava/lang/String;
    .param p3, "mbrComponent"    # Landroid/content/ComponentName;
    .param p4, "mbrIntent"    # Landroid/app/PendingIntent;

    .line 384
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 104
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mActiveListeners:Ljava/util/ArrayList;

    .line 385
    if-nez p1, :cond_0

    .line 386
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "context must not be null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 388
    :cond_0
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 389
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "tag must not be null or empty"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 392
    :cond_1
    if-nez p3, :cond_2

    .line 393
    invoke-static {p1}, Landroid/support/v4/media/session/MediaButtonReceiver;->getMediaButtonReceiverComponent(Landroid/content/Context;)Landroid/content/ComponentName;

    move-result-object p3

    .line 394
    if-nez p3, :cond_2

    .line 395
    const-string v0, "MediaSessionCompat"

    const-string v1, "Couldn\'t find a unique registered media button receiver in the given context."

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 399
    :cond_2
    if-eqz p3, :cond_3

    if-nez p4, :cond_3

    .line 401
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MEDIA_BUTTON"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 403
    .local v0, "mediaButtonIntent":Landroid/content/Intent;
    invoke-virtual {v0, p3}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 404
    const/4 v1, 0x0

    invoke-static {p1, v1, v0, v1}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p4

    .line 407
    .end local v0    # "mediaButtonIntent":Landroid/content/Intent;
    :cond_3
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_4

    .line 408
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi21;

    invoke-direct {v0, p1, p2}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi21;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 410
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$1;

    invoke-direct {v0, p0}, Landroid/support/v4/media/session/MediaSessionCompat$1;-><init>(Landroid/support/v4/media/session/MediaSessionCompat;)V

    invoke-virtual {p0, v0}, Landroid/support/v4/media/session/MediaSessionCompat;->setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V

    .line 411
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p4}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setMediaButtonReceiver(Landroid/app/PendingIntent;)V

    goto :goto_0

    .line 412
    :cond_4
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x13

    if-lt v0, v1, :cond_5

    .line 413
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi19;

    invoke-direct {v0, p1, p2, p3, p4}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi19;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/content/ComponentName;Landroid/app/PendingIntent;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    goto :goto_0

    .line 414
    :cond_5
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x12

    if-lt v0, v1, :cond_6

    .line 415
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi18;

    invoke-direct {v0, p1, p2, p3, p4}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi18;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/content/ComponentName;Landroid/app/PendingIntent;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    goto :goto_0

    .line 417
    :cond_6
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplBase;

    invoke-direct {v0, p1, p2, p3, p4}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplBase;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/content/ComponentName;Landroid/app/PendingIntent;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 419
    :goto_0
    new-instance v0, Landroid/support/v4/media/session/MediaControllerCompat;

    invoke-direct {v0, p1, p0}, Landroid/support/v4/media/session/MediaControllerCompat;-><init>(Landroid/content/Context;Landroid/support/v4/media/session/MediaSessionCompat;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mController:Landroid/support/v4/media/session/MediaControllerCompat;

    .line 421
    sget v0, Landroid/support/v4/media/session/MediaSessionCompat;->sMaxBitmapSize:I

    if-nez v0, :cond_7

    .line 422
    const/4 v0, 0x1

    const/high16 v1, 0x43a00000    # 320.0f

    .line 423
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    .line 422
    invoke-static {v0, v1, v2}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v0

    float-to-int v0, v0

    sput v0, Landroid/support/v4/media/session/MediaSessionCompat;->sMaxBitmapSize:I

    .line 425
    :cond_7
    return-void
.end method

.method static synthetic access$500(Landroid/support/v4/media/session/PlaybackStateCompat;Landroid/support/v4/media/MediaMetadataCompat;)Landroid/support/v4/media/session/PlaybackStateCompat;
    .locals 1
    .param p0, "x0"    # Landroid/support/v4/media/session/PlaybackStateCompat;
    .param p1, "x1"    # Landroid/support/v4/media/MediaMetadataCompat;

    .line 99
    invoke-static {p0, p1}, Landroid/support/v4/media/session/MediaSessionCompat;->getStateWithUpdatedPosition(Landroid/support/v4/media/session/PlaybackStateCompat;Landroid/support/v4/media/MediaMetadataCompat;)Landroid/support/v4/media/session/PlaybackStateCompat;

    move-result-object v0

    return-object v0
.end method

.method public static fromMediaSession(Landroid/content/Context;Ljava/lang/Object;)Landroid/support/v4/media/session/MediaSessionCompat;
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "mediaSession"    # Ljava/lang/Object;

    .line 823
    if-eqz p0, :cond_0

    if-eqz p1, :cond_0

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_0

    .line 824
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat;

    new-instance v1, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi21;

    invoke-direct {v1, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImplApi21;-><init>(Ljava/lang/Object;)V

    invoke-direct {v0, p0, v1}, Landroid/support/v4/media/session/MediaSessionCompat;-><init>(Landroid/content/Context;Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;)V

    return-object v0

    .line 826
    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method

.method private static getStateWithUpdatedPosition(Landroid/support/v4/media/session/PlaybackStateCompat;Landroid/support/v4/media/MediaMetadataCompat;)Landroid/support/v4/media/session/PlaybackStateCompat;
    .locals 18
    .param p0, "state"    # Landroid/support/v4/media/session/PlaybackStateCompat;
    .param p1, "metadata"    # Landroid/support/v4/media/MediaMetadataCompat;

    move-object/from16 v0, p0

    .line 831
    move-object/from16 v1, p1

    if-eqz v0, :cond_6

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getPosition()J

    move-result-wide v2

    const-wide/16 v4, -0x1

    cmp-long v2, v2, v4

    if-nez v2, :cond_0

    goto/16 :goto_2

    .line 835
    :cond_0
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getState()I

    move-result v2

    const/4 v3, 0x3

    if-eq v2, v3, :cond_1

    .line 836
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getState()I

    move-result v2

    const/4 v3, 0x4

    if-eq v2, v3, :cond_1

    .line 837
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getState()I

    move-result v2

    const/4 v3, 0x5

    if-ne v2, v3, :cond_5

    .line 838
    :cond_1
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getLastPositionUpdateTime()J

    move-result-wide v2

    .line 839
    .local v2, "updateTime":J
    const-wide/16 v4, 0x0

    cmp-long v6, v2, v4

    if-lez v6, :cond_5

    .line 840
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v14

    .line 841
    .local v14, "currentTime":J
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getPlaybackSpeed()F

    move-result v6

    sub-long v7, v14, v2

    long-to-float v7, v7

    mul-float/2addr v6, v7

    float-to-long v6, v6

    .line 842
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getPosition()J

    move-result-wide v8

    add-long/2addr v6, v8

    .line 843
    .local v6, "position":J
    const-wide/16 v8, -0x1

    .line 844
    .local v8, "duration":J
    if-eqz v1, :cond_2

    const-string v10, "android.media.metadata.DURATION"

    invoke-virtual {v1, v10}, Landroid/support/v4/media/MediaMetadataCompat;->containsKey(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_2

    .line 846
    const-string v10, "android.media.metadata.DURATION"

    invoke-virtual {v1, v10}, Landroid/support/v4/media/MediaMetadataCompat;->getLong(Ljava/lang/String;)J

    move-result-wide v8

    .line 849
    .end local v8    # "duration":J
    .local v16, "duration":J
    :cond_2
    move-wide/from16 v16, v8

    cmp-long v8, v16, v4

    if-ltz v8, :cond_3

    cmp-long v8, v6, v16

    if-lez v8, :cond_3

    .line 850
    move-wide/from16 v4, v16

    .line 850
    .end local v6    # "position":J
    .local v4, "position":J
    :goto_0
    goto :goto_1

    .line 851
    .end local v4    # "position":J
    .restart local v6    # "position":J
    :cond_3
    cmp-long v4, v6, v4

    if-gez v4, :cond_4

    .line 852
    const-wide/16 v4, 0x0

    goto :goto_0

    .line 854
    :cond_4
    move-wide v4, v6

    .line 854
    .end local v6    # "position":J
    .restart local v4    # "position":J
    :goto_1
    new-instance v7, Landroid/support/v4/media/session/PlaybackStateCompat$Builder;

    invoke-direct {v7, v0}, Landroid/support/v4/media/session/PlaybackStateCompat$Builder;-><init>(Landroid/support/v4/media/session/PlaybackStateCompat;)V

    .line 855
    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getState()I

    move-result v8

    invoke-virtual/range {p0 .. p0}, Landroid/support/v4/media/session/PlaybackStateCompat;->getPlaybackSpeed()F

    move-result v11

    move-wide v9, v4

    move-wide v12, v14

    invoke-virtual/range {v7 .. v13}, Landroid/support/v4/media/session/PlaybackStateCompat$Builder;->setState(IJFJ)Landroid/support/v4/media/session/PlaybackStateCompat$Builder;

    move-result-object v6

    .line 856
    invoke-virtual {v6}, Landroid/support/v4/media/session/PlaybackStateCompat$Builder;->build()Landroid/support/v4/media/session/PlaybackStateCompat;

    move-result-object v6

    return-object v6

    .line 859
    .end local v2    # "updateTime":J
    .end local v4    # "position":J
    .end local v14    # "currentTime":J
    .end local v16    # "duration":J
    :cond_5
    return-object v0

    .line 832
    :cond_6
    :goto_2
    return-object v0
.end method


# virtual methods
.method public addOnActiveChangeListener(Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;)V
    .locals 2
    .param p1, "listener"    # Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;

    .line 793
    if-nez p1, :cond_0

    .line 794
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Listener may not be null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 796
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mActiveListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 797
    return-void
.end method

.method public getCallingPackage()Ljava/lang/String;
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 782
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getCallingPackage()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public getController()Landroid/support/v4/media/session/MediaControllerCompat;
    .locals 1

    .line 612
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mController:Landroid/support/v4/media/session/MediaControllerCompat;

    return-object v0
.end method

.method public getMediaSession()Ljava/lang/Object;
    .locals 1

    .line 756
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getMediaSession()Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method public getRemoteControlClient()Ljava/lang/Object;
    .locals 1

    .line 770
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getRemoteControlClient()Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method public getSessionToken()Landroid/support/v4/media/session/MediaSessionCompat$Token;
    .locals 1

    .line 602
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getSessionToken()Landroid/support/v4/media/session/MediaSessionCompat$Token;

    move-result-object v0

    return-object v0
.end method

.method public isActive()Z
    .locals 1

    .line 560
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->isActive()Z

    move-result v0

    return v0
.end method

.method public release()V
    .locals 1

    .line 584
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->release()V

    .line 585
    return-void
.end method

.method public removeOnActiveChangeListener(Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;)V
    .locals 2
    .param p1, "listener"    # Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;

    .line 806
    if-nez p1, :cond_0

    .line 807
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Listener may not be null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 809
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mActiveListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 810
    return-void
.end method

.method public sendSessionEvent(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 2
    .param p1, "event"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 572
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 573
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "event cannot be null or empty"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 575
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1, p2}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->sendSessionEvent(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 576
    return-void
.end method

.method public setActive(Z)V
    .locals 2
    .param p1, "active"    # Z

    .line 548
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setActive(Z)V

    .line 549
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mActiveListeners:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;

    .line 550
    .local v1, "listener":Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;
    invoke-interface {v1}, Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;->onActiveChanged()V

    .line 551
    .end local v1    # "listener":Landroid/support/v4/media/session/MediaSessionCompat$OnActiveChangeListener;
    goto :goto_0

    .line 552
    :cond_0
    return-void
.end method

.method public setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V
    .locals 1
    .param p1, "callback"    # Landroid/support/v4/media/session/MediaSessionCompat$Callback;

    .line 445
    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/support/v4/media/session/MediaSessionCompat;->setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;Landroid/os/Handler;)V

    .line 446
    return-void
.end method

.method public setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;Landroid/os/Handler;)V
    .locals 2
    .param p1, "callback"    # Landroid/support/v4/media/session/MediaSessionCompat$Callback;
    .param p2, "handler"    # Landroid/os/Handler;

    .line 457
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    if-eqz p2, :cond_0

    move-object v1, p2

    goto :goto_0

    :cond_0
    new-instance v1, Landroid/os/Handler;

    invoke-direct {v1}, Landroid/os/Handler;-><init>()V

    :goto_0
    invoke-interface {v0, p1, v1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setCallback(Landroid/support/v4/media/session/MediaSessionCompat$Callback;Landroid/os/Handler;)V

    .line 458
    return-void
.end method

.method public setCaptioningEnabled(Z)V
    .locals 1
    .param p1, "enabled"    # Z

    .line 685
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setCaptioningEnabled(Z)V

    .line 686
    return-void
.end method

.method public setExtras(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "extras"    # Landroid/os/Bundle;

    .line 742
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setExtras(Landroid/os/Bundle;)V

    .line 743
    return-void
.end method

.method public setFlags(I)V
    .locals 1
    .param p1, "flags"    # I

    .line 495
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setFlags(I)V

    .line 496
    return-void
.end method

.method public setMediaButtonReceiver(Landroid/app/PendingIntent;)V
    .locals 1
    .param p1, "mbr"    # Landroid/app/PendingIntent;

    .line 486
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setMediaButtonReceiver(Landroid/app/PendingIntent;)V

    .line 487
    return-void
.end method

.method public setMetadata(Landroid/support/v4/media/MediaMetadataCompat;)V
    .locals 1
    .param p1, "metadata"    # Landroid/support/v4/media/MediaMetadataCompat;

    .line 633
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setMetadata(Landroid/support/v4/media/MediaMetadataCompat;)V

    .line 634
    return-void
.end method

.method public setPlaybackState(Landroid/support/v4/media/session/PlaybackStateCompat;)V
    .locals 1
    .param p1, "state"    # Landroid/support/v4/media/session/PlaybackStateCompat;

    .line 621
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setPlaybackState(Landroid/support/v4/media/session/PlaybackStateCompat;)V

    .line 622
    return-void
.end method

.method public setPlaybackToLocal(I)V
    .locals 1
    .param p1, "stream"    # I

    .line 509
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setPlaybackToLocal(I)V

    .line 510
    return-void
.end method

.method public setPlaybackToRemote(Landroid/support/v4/media/VolumeProviderCompat;)V
    .locals 2
    .param p1, "volumeProvider"    # Landroid/support/v4/media/VolumeProviderCompat;

    .line 528
    if-nez p1, :cond_0

    .line 529
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "volumeProvider may not be null!"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 531
    :cond_0
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setPlaybackToRemote(Landroid/support/v4/media/VolumeProviderCompat;)V

    .line 532
    return-void
.end method

.method public setQueue(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/support/v4/media/session/MediaSessionCompat$QueueItem;",
            ">;)V"
        }
    .end annotation

    .line 648
    .local p1, "queue":Ljava/util/List;, "Ljava/util/List<Landroid/support/v4/media/session/MediaSessionCompat$QueueItem;>;"
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setQueue(Ljava/util/List;)V

    .line 649
    return-void
.end method

.method public setQueueTitle(Ljava/lang/CharSequence;)V
    .locals 1
    .param p1, "title"    # Ljava/lang/CharSequence;

    .line 659
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setQueueTitle(Ljava/lang/CharSequence;)V

    .line 660
    return-void
.end method

.method public setRatingType(I)V
    .locals 1
    .param p1, "type"    # I

    .line 676
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setRatingType(I)V

    .line 677
    return-void
.end method

.method public setRepeatMode(I)V
    .locals 1
    .param p1, "repeatMode"    # I

    .line 701
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setRepeatMode(I)V

    .line 702
    return-void
.end method

.method public setSessionActivity(Landroid/app/PendingIntent;)V
    .locals 1
    .param p1, "pi"    # Landroid/app/PendingIntent;

    .line 469
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setSessionActivity(Landroid/app/PendingIntent;)V

    .line 470
    return-void
.end method

.method public setShuffleMode(I)V
    .locals 1
    .param p1, "shuffleMode"    # I

    .line 730
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setShuffleMode(I)V

    .line 731
    return-void
.end method

.method public setShuffleModeEnabled(Z)V
    .locals 1
    .param p1, "enabled"    # Z
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 715
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat;->mImpl:Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    invoke-interface {v0, p1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->setShuffleModeEnabled(Z)V

    .line 716
    return-void
.end method
