.class public final Lco/ostorlab/insecure_app/bugs/calls/MemoryCorruption;
.super Lco/ostorlab/insecure_app/BugRule;
.source "MemoryCorruption.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RULE"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method

.method private native triggerStackOverflow(Ljava/lang/String;)Ljava/lang/String;
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 21
    const-string v0, "Memory corruption"

    return-object v0
.end method

.method public run()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 26
    const-string v0, ""

    const-string v1, "()"

    const/16 v2, 0xc8

    invoke-static {v2, v1}, Ljava/util/Collections;->nCopies(ILjava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-static {v0, v1}, Ljava/lang/String;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object v0

    .line 27
    .local v0, "input":Ljava/lang/String;
    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/MemoryCorruption;->triggerStackOverflow(Ljava/lang/String;)Ljava/lang/String;

    .line 28
    return-void
.end method
