.class Landroid/support/v4/net/ConnectivityManagerCompat$ConnectivityManagerCompatBaseImpl;
.super Ljava/lang/Object;
.source "ConnectivityManagerCompat.java"

# interfaces
.implements Landroid/support/v4/net/ConnectivityManagerCompat$ConnectivityManagerCompatImpl;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/v4/net/ConnectivityManagerCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ConnectivityManagerCompatBaseImpl"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 88
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getRestrictBackgroundStatus(Landroid/net/ConnectivityManager;)I
    .locals 1
    .param p1, "cm"    # Landroid/net/ConnectivityManager;

    .line 119
    const/4 v0, 0x3

    return v0
.end method

.method public isActiveNetworkMetered(Landroid/net/ConnectivityManager;)Z
    .locals 3
    .param p1, "cm"    # Landroid/net/ConnectivityManager;

    .line 92
    invoke-virtual {p1}, Landroid/net/ConnectivityManager;->getActiveNetworkInfo()Landroid/net/NetworkInfo;

    move-result-object v0

    .line 93
    .local v0, "info":Landroid/net/NetworkInfo;
    const/4 v1, 0x1

    if-nez v0, :cond_0

    .line 95
    return v1

    .line 98
    :cond_0
    invoke-virtual {v0}, Landroid/net/NetworkInfo;->getType()I

    move-result v2

    .line 99
    .local v2, "type":I
    packed-switch v2, :pswitch_data_0

    .line 113
    :pswitch_0
    return v1

    .line 110
    :pswitch_1
    const/4 v1, 0x0

    return v1

    .line 106
    :pswitch_2
    return v1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method
