.class public final Lco/ostorlab/insecure_app/bugs/calls/DexClassLoaderCall;
.super Lco/ostorlab/insecure_app/BugRule;
.source "DexClassLoaderCall.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RULE"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 15
    const-string v0, "Use of dex class load"

    return-object v0
.end method

.method public run()V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 20
    new-instance v0, Ldalvik/system/DexClassLoader;

    const-string v1, "/sdcard/test.apk"

    const-string v2, "/sdcard/test.apk"

    const-string v3, "/sdcard/test.apk"

    .line 24
    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    invoke-direct {v0, v1, v2, v3, v4}, Ldalvik/system/DexClassLoader;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V

    .line 25
    .local v0, "classLoader":Ldalvik/system/DexClassLoader;
    const-string v1, "a.b.c"

    invoke-virtual {v0, v1}, Ldalvik/system/DexClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    .line 26
    return-void
.end method
