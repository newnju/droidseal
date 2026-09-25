.class public final Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;
.super Lco/ostorlab/insecure_app/BugRule;
.source "InsecureSharedPreferences.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RULE"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 14
    const-string v0, "Call to shared preference method using insecure permission"

    return-object v0
.end method

.method public run()V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    const-string v0, "myPreference"

    .line 20
    .local v0, "myPreference":Ljava/lang/String;
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "PrivateOnly"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 21
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "WorldReadableOnly"

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 22
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "WorldReadableAndWritable"

    const/4 v3, 0x3

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 23
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "WorldReadableAndAppend"

    const/4 v3, 0x5

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 24
    return-void
.end method
