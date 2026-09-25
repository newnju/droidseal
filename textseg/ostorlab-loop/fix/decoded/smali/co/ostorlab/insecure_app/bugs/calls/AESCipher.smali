.class public final Lco/ostorlab/insecure_app/bugs/calls/AESCipher;
.super Lco/ostorlab/insecure_app/BugRule;
.source "AESCipher.java"


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
    .locals 14
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
    const-string v3, "AES"

    invoke-static {v3}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v3

    .line 27
    .local v3, "cipher":Ljavax/crypto/Cipher;
    const-string v4, "aes"

    invoke-static {v4}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v4

    .line 28
    .local v4, "cipher0":Ljavax/crypto/Cipher;
    const-string v5, "3DES"

    invoke-static {v5}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v5

    .line 29
    .local v5, "cipher1":Ljavax/crypto/Cipher;
    const-string v6, "tripledes"

    invoke-static {v6}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v6

    .line 30
    .local v6, "cipher2":Ljavax/crypto/Cipher;
    const-string v7, "DESED"

    invoke-static {v7}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v7

    .line 31
    .local v7, "cipher3":Ljavax/crypto/Cipher;
    const/4 v8, 0x1

    invoke-virtual {v3, v8, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    .line 32
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v9

    invoke-virtual {v3, v9}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object v9

    .line 33
    .local v9, "encryptedMessage":[B
    const-string v10, "RULE"

    const-string v11, "Message: %s"

    new-array v8, v8, [Ljava/lang/Object;

    const/4 v12, 0x0

    invoke-static {v9, v12}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v13

    aput-object v13, v8, v12

    invoke-static {v11, v8}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    invoke-static {v10, v8}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 34
    return-void
.end method
