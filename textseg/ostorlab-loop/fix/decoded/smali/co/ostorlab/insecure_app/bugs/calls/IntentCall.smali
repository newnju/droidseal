.class public Lco/ostorlab/insecure_app/bugs/calls/IntentCall;
.super Lco/ostorlab/insecure_app/BugRule;
.source "IntentCall.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 8
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 22
    const-string v0, "The application uses a string value to construct an Intent"

    return-object v0
.end method

.method public run()V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 12
    new-instance v0, Landroid/content/Intent;

    const-string v1, "co.ostorlab"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 13
    .local v0, "intent1":Landroid/content/Intent;
    new-instance v1, Landroid/content/Intent;

    const-string v2, "com.google.android.view"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 14
    .local v1, "intent2":Landroid/content/Intent;
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.test.VIEW"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 15
    .local v2, "intent3":Landroid/content/Intent;
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 16
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 17
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 18
    return-void
.end method
