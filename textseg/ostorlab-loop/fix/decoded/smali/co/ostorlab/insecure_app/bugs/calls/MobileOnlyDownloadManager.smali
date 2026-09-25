.class public final Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;
.super Lco/ostorlab/insecure_app/BugRule;
.source "MobileOnlyDownloadManager.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 18
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method

.method private startDownloadManager(I)V
    .locals 7
    .param p1, "networkMobile"    # I

    .line 29
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v1, "hhmmss"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v2

    invoke-direct {v0, v1, v2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    .line 30
    .local v0, "dateformat":Ljava/text/SimpleDateFormat;
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "download"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/DownloadManager;

    .line 31
    .local v1, "manager":Landroid/app/DownloadManager;
    new-instance v2, Landroid/app/DownloadManager$Request;

    const-string v3, "https://ostorlab.co/test.large"

    .line 32
    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/app/DownloadManager$Request;-><init>(Landroid/net/Uri;)V

    .line 33
    .local v2, "down":Landroid/app/DownloadManager$Request;
    invoke-virtual {v2, p1}, Landroid/app/DownloadManager$Request;->setAllowedNetworkTypes(I)Landroid/app/DownloadManager$Request;

    .line 34
    new-instance v3, Ljava/util/Date;

    invoke-direct {v3}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v3

    .line 35
    .local v3, "date":Ljava/lang/String;
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;->getContext()Landroid/content/Context;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "test.large"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const/4 v6, 0x0

    invoke-virtual {v2, v4, v6, v5}, Landroid/app/DownloadManager$Request;->setDestinationInExternalFilesDir(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Landroid/app/DownloadManager$Request;

    .line 36
    invoke-virtual {v1, v2}, Landroid/app/DownloadManager;->enqueue(Landroid/app/DownloadManager$Request;)J

    .line 37
    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 41
    const-string v0, "Mobile Only DownloadManager"

    return-object v0
.end method

.method public run()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 23
    const/4 v0, 0x1

    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;->startDownloadManager(I)V

    .line 25
    const/4 v0, 0x2

    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;->startDownloadManager(I)V

    .line 26
    return-void
.end method
