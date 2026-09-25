.class public final Lco/ostorlab/insecure_app/bugs/calls/PathClassLoaderCall;
.super Lco/ostorlab/insecure_app/BugRule;
.source "PathClassLoaderCall.java"


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
    const-string v0, "Use of insecure ECB Mode"

    return-object v0
.end method

.method public run()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    new-instance v0, Ldalvik/system/PathClassLoader;

    const-string v1, "/sdcard/test.apk"

    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    invoke-direct {v0, v1, v2}, Ldalvik/system/PathClassLoader;-><init>(Ljava/lang/String;Ljava/lang/ClassLoader;)V

    .line 20
    .local v0, "classLoader":Ldalvik/system/PathClassLoader;
    const-string v1, "a.b.c"

    invoke-virtual {v0, v1}, Ldalvik/system/PathClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    .line 21
    return-void
.end method
