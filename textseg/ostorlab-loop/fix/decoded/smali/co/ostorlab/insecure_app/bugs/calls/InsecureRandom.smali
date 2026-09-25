.class public final Lco/ostorlab/insecure_app/bugs/calls/InsecureRandom;
.super Lco/ostorlab/insecure_app/BugRule;
.source "InsecureRandom.java"


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

    .line 24
    const-string v0, "The application uses a string value to construct an Intent"

    return-object v0
.end method

.method public run()V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 12
    new-instance v0, Ljava/security/SecureRandom;

    invoke-direct {v0}, Ljava/security/SecureRandom;-><init>()V

    .line 13
    .local v0, "secureRandom":Ljava/security/SecureRandom;
    new-instance v1, Ljava/util/Random;

    invoke-direct {v1}, Ljava/util/Random;-><init>()V

    .line 14
    .local v1, "random":Ljava/util/Random;
    new-instance v2, Ljava/util/Random;

    const-wide/16 v3, 0x3039

    invoke-direct {v2, v3, v4}, Ljava/util/Random;-><init>(J)V

    move-object v1, v2

    .line 15
    new-instance v2, Ljava/security/SecureRandom;

    const-string v5, "12345"

    invoke-virtual {v5}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    invoke-direct {v2, v5}, Ljava/security/SecureRandom;-><init>([B)V

    move-object v0, v2

    .line 16
    invoke-virtual {v0, v3, v4}, Ljava/security/SecureRandom;->setSeed(J)V

    .line 17
    invoke-virtual {v1, v3, v4}, Ljava/util/Random;->setSeed(J)V

    .line 20
    return-void
.end method
