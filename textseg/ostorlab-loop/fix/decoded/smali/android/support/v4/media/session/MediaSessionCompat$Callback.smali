.class public abstract Landroid/support/v4/media/session/MediaSessionCompat$Callback;
.super Ljava/lang/Object;
.source "MediaSessionCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/media/session/MediaSessionCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Callback"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi24;,
        Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi23;,
        Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi21;,
        Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;
    }
.end annotation


# instance fields
.field private mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

.field final mCallbackObj:Ljava/lang/Object;

.field private mMediaPlayPauseKeyPending:Z

.field private mSessionImpl:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 872
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 869
    const/4 v0, 0x0

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    .line 873
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x18

    if-lt v1, v2, :cond_0

    .line 874
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi24;

    invoke-direct {v0, p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi24;-><init>(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V

    invoke-static {v0}, Landroid/support/v4/media/session/MediaSessionCompatApi24;->createCallback(Landroid/support/v4/media/session/MediaSessionCompatApi24$Callback;)Ljava/lang/Object;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackObj:Ljava/lang/Object;

    goto :goto_0

    .line 875
    :cond_0
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x17

    if-lt v1, v2, :cond_1

    .line 876
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi23;

    invoke-direct {v0, p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi23;-><init>(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V

    invoke-static {v0}, Landroid/support/v4/media/session/MediaSessionCompatApi23;->createCallback(Landroid/support/v4/media/session/MediaSessionCompatApi23$Callback;)Ljava/lang/Object;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackObj:Ljava/lang/Object;

    goto :goto_0

    .line 877
    :cond_1
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v1, v2, :cond_2

    .line 878
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi21;

    invoke-direct {v0, p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$StubApi21;-><init>(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V

    invoke-static {v0}, Landroid/support/v4/media/session/MediaSessionCompatApi21;->createCallback(Landroid/support/v4/media/session/MediaSessionCompatApi21$Callback;)Ljava/lang/Object;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackObj:Ljava/lang/Object;

    goto :goto_0

    .line 880
    :cond_2
    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackObj:Ljava/lang/Object;

    .line 882
    :goto_0
    return-void
.end method

.method static synthetic access$000(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)V
    .locals 0
    .param p0, "x0"    # Landroid/support/v4/media/session/MediaSessionCompat$Callback;

    .line 866
    invoke-direct {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->handleMediaPlayPauseKeySingleTapIfPending()V

    return-void
.end method

.method static synthetic access$100(Landroid/support/v4/media/session/MediaSessionCompat$Callback;)Ljava/lang/ref/WeakReference;
    .locals 1
    .param p0, "x0"    # Landroid/support/v4/media/session/MediaSessionCompat$Callback;

    .line 866
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mSessionImpl:Ljava/lang/ref/WeakReference;

    return-object v0
.end method

.method static synthetic access$300(Landroid/support/v4/media/session/MediaSessionCompat$Callback;Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;Landroid/os/Handler;)V
    .locals 0
    .param p0, "x0"    # Landroid/support/v4/media/session/MediaSessionCompat$Callback;
    .param p1, "x1"    # Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;
    .param p2, "x2"    # Landroid/os/Handler;

    .line 866
    invoke-direct {p0, p1, p2}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->setSessionImpl(Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;Landroid/os/Handler;)V

    return-void
.end method

.method private handleMediaPlayPauseKeySingleTapIfPending()V
    .locals 12

    .line 956
    iget-boolean v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mMediaPlayPauseKeyPending:Z

    if-nez v0, :cond_0

    .line 957
    return-void

    .line 959
    :cond_0
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mMediaPlayPauseKeyPending:Z

    .line 960
    iget-object v1, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;->removeMessages(I)V

    .line 962
    iget-object v1, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mSessionImpl:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 963
    .local v1, "impl":Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;
    if-nez v1, :cond_1

    .line 964
    return-void

    .line 966
    :cond_1
    invoke-interface {v1}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getPlaybackState()Landroid/support/v4/media/session/PlaybackStateCompat;

    move-result-object v3

    .line 967
    .local v3, "state":Landroid/support/v4/media/session/PlaybackStateCompat;
    const-wide/16 v4, 0x0

    if-nez v3, :cond_2

    move-wide v6, v4

    goto :goto_0

    :cond_2
    invoke-virtual {v3}, Landroid/support/v4/media/session/PlaybackStateCompat;->getActions()J

    move-result-wide v6

    .line 968
    .local v6, "validActions":J
    :goto_0
    if-eqz v3, :cond_3

    .line 969
    invoke-virtual {v3}, Landroid/support/v4/media/session/PlaybackStateCompat;->getState()I

    move-result v8

    const/4 v9, 0x3

    if-ne v8, v9, :cond_3

    move v8, v2

    goto :goto_1

    :cond_3
    move v8, v0

    .line 970
    .local v8, "isPlaying":Z
    :goto_1
    const-wide/16 v9, 0x204

    and-long/2addr v9, v6

    cmp-long v9, v9, v4

    if-eqz v9, :cond_4

    move v9, v2

    goto :goto_2

    :cond_4
    move v9, v0

    .line 972
    .local v9, "canPlay":Z
    :goto_2
    const-wide/16 v10, 0x202

    and-long/2addr v10, v6

    cmp-long v4, v10, v4

    if-eqz v4, :cond_5

    move v0, v2

    nop

    .line 974
    .local v0, "canPause":Z
    :cond_5
    if-eqz v8, :cond_6

    if-eqz v0, :cond_6

    .line 975
    invoke-virtual {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->onPause()V

    goto :goto_3

    .line 976
    :cond_6
    if-nez v8, :cond_7

    if-eqz v9, :cond_7

    .line 977
    invoke-virtual {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->onPlay()V

    .line 979
    :cond_7
    :goto_3
    return-void
.end method

.method private setSessionImpl(Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;Landroid/os/Handler;)V
    .locals 2
    .param p1, "impl"    # Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;
    .param p2, "handler"    # Landroid/os/Handler;

    .line 885
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mSessionImpl:Ljava/lang/ref/WeakReference;

    .line 886
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    if-eqz v0, :cond_0

    .line 887
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 889
    :cond_0
    new-instance v0, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    invoke-virtual {p2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;-><init>(Landroid/support/v4/media/session/MediaSessionCompat$Callback;Landroid/os/Looper;)V

    iput-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    .line 890
    return-void
.end method


# virtual methods
.method public onAddQueueItem(Landroid/support/v4/media/MediaDescriptionCompat;)V
    .locals 0
    .param p1, "description"    # Landroid/support/v4/media/MediaDescriptionCompat;

    .line 1187
    return-void
.end method

.method public onAddQueueItem(Landroid/support/v4/media/MediaDescriptionCompat;I)V
    .locals 0
    .param p1, "description"    # Landroid/support/v4/media/MediaDescriptionCompat;
    .param p2, "index"    # I

    .line 1199
    return-void
.end method

.method public onCommand(Ljava/lang/String;Landroid/os/Bundle;Landroid/os/ResultReceiver;)V
    .locals 0
    .param p1, "command"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;
    .param p3, "cb"    # Landroid/os/ResultReceiver;

    .line 902
    return-void
.end method

.method public onCustomAction(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "action"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1177
    return-void
.end method

.method public onFastForward()V
    .locals 0

    .line 1071
    return-void
.end method

.method public onMediaButtonEvent(Landroid/content/Intent;)Z
    .locals 12
    .param p1, "mediaButtonEvent"    # Landroid/content/Intent;

    .line 914
    iget-object v0, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mSessionImpl:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;

    .line 915
    .local v0, "impl":Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;
    const/4 v1, 0x0

    if-eqz v0, :cond_8

    iget-object v2, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    if-nez v2, :cond_0

    goto :goto_3

    .line 918
    :cond_0
    const-string v2, "android.intent.extra.KEY_EVENT"

    invoke-virtual {p1, v2}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v2

    check-cast v2, Landroid/view/KeyEvent;

    .line 919
    .local v2, "keyEvent":Landroid/view/KeyEvent;
    if-eqz v2, :cond_7

    invoke-virtual {v2}, Landroid/view/KeyEvent;->getAction()I

    move-result v3

    if-eqz v3, :cond_1

    goto :goto_2

    .line 922
    :cond_1
    invoke-virtual {v2}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v3

    .line 923
    .local v3, "keyCode":I
    const/16 v4, 0x4f

    if-eq v3, v4, :cond_2

    const/16 v4, 0x55

    if-eq v3, v4, :cond_2

    .line 949
    invoke-direct {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->handleMediaPlayPauseKeySingleTapIfPending()V

    .line 952
    return v1

    .line 926
    :cond_2
    invoke-virtual {v2}, Landroid/view/KeyEvent;->getRepeatCount()I

    move-result v4

    const/4 v5, 0x1

    if-lez v4, :cond_3

    .line 928
    invoke-direct {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->handleMediaPlayPauseKeySingleTapIfPending()V

    goto :goto_1

    .line 929
    :cond_3
    iget-boolean v4, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mMediaPlayPauseKeyPending:Z

    if-eqz v4, :cond_6

    .line 930
    iget-object v4, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    invoke-virtual {v4, v5}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;->removeMessages(I)V

    .line 932
    iput-boolean v1, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mMediaPlayPauseKeyPending:Z

    .line 933
    invoke-interface {v0}, Landroid/support/v4/media/session/MediaSessionCompat$MediaSessionImpl;->getPlaybackState()Landroid/support/v4/media/session/PlaybackStateCompat;

    move-result-object v1

    .line 934
    .local v1, "state":Landroid/support/v4/media/session/PlaybackStateCompat;
    const-wide/16 v6, 0x0

    if-nez v1, :cond_4

    move-wide v8, v6

    goto :goto_0

    :cond_4
    invoke-virtual {v1}, Landroid/support/v4/media/session/PlaybackStateCompat;->getActions()J

    move-result-wide v8

    .line 936
    .local v8, "validActions":J
    :goto_0
    const-wide/16 v10, 0x20

    and-long/2addr v10, v8

    cmp-long v4, v10, v6

    if-eqz v4, :cond_5

    .line 937
    invoke-virtual {p0}, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->onSkipToNext()V

    .line 939
    .end local v1    # "state":Landroid/support/v4/media/session/PlaybackStateCompat;
    .end local v8    # "validActions":J
    :cond_5
    goto :goto_1

    .line 940
    :cond_6
    iput-boolean v5, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mMediaPlayPauseKeyPending:Z

    .line 941
    iget-object v1, p0, Landroid/support/v4/media/session/MediaSessionCompat$Callback;->mCallbackHandler:Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;

    .line 943
    invoke-static {}, Landroid/view/ViewConfiguration;->getDoubleTapTimeout()I

    move-result v4

    int-to-long v6, v4

    .line 941
    invoke-virtual {v1, v5, v6, v7}, Landroid/support/v4/media/session/MediaSessionCompat$Callback$CallbackHandler;->sendEmptyMessageDelayed(IJ)Z

    .line 945
    :goto_1
    return v5

    .line 920
    .end local v3    # "keyCode":I
    :cond_7
    :goto_2
    return v1

    .line 916
    .end local v2    # "keyEvent":Landroid/view/KeyEvent;
    :cond_8
    :goto_3
    return v1
.end method

.method public onPause()V
    .locals 0

    .line 1053
    return-void
.end method

.method public onPlay()V
    .locals 0

    .line 1018
    return-void
.end method

.method public onPlayFromMediaId(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "mediaId"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1025
    return-void
.end method

.method public onPlayFromSearch(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "query"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1034
    return-void
.end method

.method public onPlayFromUri(Landroid/net/Uri;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1040
    return-void
.end method

.method public onPrepare()V
    .locals 0

    .line 986
    return-void
.end method

.method public onPrepareFromMediaId(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "mediaId"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 994
    return-void
.end method

.method public onPrepareFromSearch(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "query"    # Ljava/lang/String;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1004
    return-void
.end method

.method public onPrepareFromUri(Landroid/net/Uri;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1012
    return-void
.end method

.method public onRemoveQueueItem(Landroid/support/v4/media/MediaDescriptionCompat;)V
    .locals 0
    .param p1, "description"    # Landroid/support/v4/media/MediaDescriptionCompat;

    .line 1210
    return-void
.end method

.method public onRemoveQueueItemAt(I)V
    .locals 0
    .param p1, "index"    # I
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 1221
    return-void
.end method

.method public onRewind()V
    .locals 0

    .line 1077
    return-void
.end method

.method public onSeekTo(J)V
    .locals 0
    .param p1, "pos"    # J

    .line 1091
    return-void
.end method

.method public onSetCaptioningEnabled(Z)V
    .locals 0
    .param p1, "enabled"    # Z

    .line 1116
    return-void
.end method

.method public onSetRating(Landroid/support/v4/media/RatingCompat;)V
    .locals 0
    .param p1, "rating"    # Landroid/support/v4/media/RatingCompat;

    .line 1099
    return-void
.end method

.method public onSetRating(Landroid/support/v4/media/RatingCompat;Landroid/os/Bundle;)V
    .locals 0
    .param p1, "rating"    # Landroid/support/v4/media/RatingCompat;
    .param p2, "extras"    # Landroid/os/Bundle;

    .line 1108
    return-void
.end method

.method public onSetRepeatMode(I)V
    .locals 0
    .param p1, "repeatMode"    # I

    .line 1132
    return-void
.end method

.method public onSetShuffleMode(I)V
    .locals 0
    .param p1, "shuffleMode"    # I

    .line 1161
    return-void
.end method

.method public onSetShuffleModeEnabled(Z)V
    .locals 0
    .param p1, "enabled"    # Z
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 1146
    return-void
.end method

.method public onSkipToNext()V
    .locals 0

    .line 1059
    return-void
.end method

.method public onSkipToPrevious()V
    .locals 0

    .line 1065
    return-void
.end method

.method public onSkipToQueueItem(J)V
    .locals 0
    .param p1, "id"    # J

    .line 1047
    return-void
.end method

.method public onStop()V
    .locals 0

    .line 1083
    return-void
.end method
