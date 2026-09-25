.class public final Lco/ostorlab/insecure_app/bugs/calls/ECBModeCipher;
.super Lco/ostorlab/insecure_app/BugRule;
.source "ECBModeCipher.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RULE"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 18
    const-string v0, "Use of insecure ECB Mode"

    return-object v0
.end method

.method public run()V
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 23
    const-string v0, "Jan van Eyck was here 1434"

    .line 24
    .local v0, "clearText":Ljava/lang/String;
    const-string v1, "ThisIs128bitSize"

    .line 25
    .local v1, "key":Ljava/lang/String;
    new-instance v2, Ljavax/crypto/spec/SecretKeySpec;

    invoke-virtual {v1}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    const-string v4, "AES"

    invoke-direct {v2, v3, v4}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V

    .line 26
    .local v2, "skeySpec":Ljavax/crypto/spec/SecretKeySpec;
    const-string v3, "AES/ECB/PKCS5PADDING"

    invoke-static {v3}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v3

    .line 27
    .local v3, "cipher":Ljavax/crypto/Cipher;
    const/4 v4, 0x1

    invoke-virtual {v3, v4, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    .line 28
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    invoke-virtual {v3, v5}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object v5

    .line 29
    .local v5, "encryptedMessage":[B
    const-string v6, "RULE"

    const-string v7, "Message: %s"

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v8, 0x0

    invoke-static {v5, v8}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v9

    aput-object v9, v4, v8

    invoke-static {v7, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v6, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    return-void
.end method
