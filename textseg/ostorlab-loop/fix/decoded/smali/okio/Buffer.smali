.class public final Lokio/Buffer;
.super Ljava/lang/Object;
.source "Buffer.java"

# interfaces
.implements Lokio/BufferedSource;
.implements Lokio/BufferedSink;
.implements Ljava/lang/Cloneable;


# static fields
.field private static final DIGITS:[B

.field static final REPLACEMENT_CHARACTER:I = 0xfffd


# instance fields
.field head:Lokio/Segment;
    .annotation runtime Ljavax/annotation/Nullable;
    .end annotation
.end field

.field size:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 52
    const/16 v0, 0x10

    new-array v0, v0, [B

    fill-array-data v0, :array_0

    sput-object v0, Lokio/Buffer;->DIGITS:[B

    return-void

    :array_0
    .array-data 1
        0x30t
        0x31t
        0x32t
        0x33t
        0x34t
        0x35t
        0x36t
        0x37t
        0x38t
        0x39t
        0x61t
        0x62t
        0x63t
        0x64t
        0x65t
        0x66t
    .end array-data
.end method

.method public constructor <init>()V
    .locals 0

    .line 59
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 60
    return-void
.end method

.method private digest(Ljava/lang/String;)Lokio/ByteString;
    .locals 6
    .param p1, "algorithm"    # Ljava/lang/String;

    .line 1570
    :try_start_0
    invoke-static {p1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 1571
    .local v0, "messageDigest":Ljava/security/MessageDigest;
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eqz v1, :cond_0

    .line 1572
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, v1, Lokio/Segment;->data:[B

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v2, v2, Lokio/Segment;->pos:I

    iget-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v3, v3, Lokio/Segment;->limit:I

    iget-object v4, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v4, v4, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    invoke-virtual {v0, v1, v2, v3}, Ljava/security/MessageDigest;->update([BII)V

    .line 1573
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, v1, Lokio/Segment;->next:Lokio/Segment;

    .line 1573
    .local v1, "s":Lokio/Segment;
    :goto_0
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eq v1, v2, :cond_0

    .line 1574
    iget-object v2, v1, Lokio/Segment;->data:[B

    iget v3, v1, Lokio/Segment;->pos:I

    iget v4, v1, Lokio/Segment;->limit:I

    iget v5, v1, Lokio/Segment;->pos:I

    sub-int/2addr v4, v5

    invoke-virtual {v0, v2, v3, v4}, Ljava/security/MessageDigest;->update([BII)V

    .line 1573
    iget-object v2, v1, Lokio/Segment;->next:Lokio/Segment;

    move-object v1, v2

    goto :goto_0

    .line 1577
    .end local v1    # "s":Lokio/Segment;
    :cond_0
    invoke-virtual {v0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v1

    invoke-static {v1}, Lokio/ByteString;->of([B)Lokio/ByteString;

    move-result-object v1
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    .line 1578
    .end local v0    # "messageDigest":Ljava/security/MessageDigest;
    :catch_0
    move-exception v0

    .line 1579
    .local v0, "e":Ljava/security/NoSuchAlgorithmException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1
.end method

.method private hmac(Ljava/lang/String;Lokio/ByteString;)Lokio/ByteString;
    .locals 6
    .param p1, "algorithm"    # Ljava/lang/String;
    .param p2, "key"    # Lokio/ByteString;

    .line 1600
    :try_start_0
    invoke-static {p1}, Ljavax/crypto/Mac;->getInstance(Ljava/lang/String;)Ljavax/crypto/Mac;

    move-result-object v0

    .line 1601
    .local v0, "mac":Ljavax/crypto/Mac;
    new-instance v1, Ljavax/crypto/spec/SecretKeySpec;

    invoke-virtual {p2}, Lokio/ByteString;->toByteArray()[B

    move-result-object v2

    invoke-direct {v1, v2, p1}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V

    invoke-virtual {v0, v1}, Ljavax/crypto/Mac;->init(Ljava/security/Key;)V

    .line 1602
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eqz v1, :cond_0

    .line 1603
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, v1, Lokio/Segment;->data:[B

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v2, v2, Lokio/Segment;->pos:I

    iget-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v3, v3, Lokio/Segment;->limit:I

    iget-object v4, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v4, v4, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    invoke-virtual {v0, v1, v2, v3}, Ljavax/crypto/Mac;->update([BII)V

    .line 1604
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, v1, Lokio/Segment;->next:Lokio/Segment;

    .line 1604
    .local v1, "s":Lokio/Segment;
    :goto_0
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eq v1, v2, :cond_0

    .line 1605
    iget-object v2, v1, Lokio/Segment;->data:[B

    iget v3, v1, Lokio/Segment;->pos:I

    iget v4, v1, Lokio/Segment;->limit:I

    iget v5, v1, Lokio/Segment;->pos:I

    sub-int/2addr v4, v5

    invoke-virtual {v0, v2, v3, v4}, Ljavax/crypto/Mac;->update([BII)V

    .line 1604
    iget-object v2, v1, Lokio/Segment;->next:Lokio/Segment;

    move-object v1, v2

    goto :goto_0

    .line 1608
    .end local v1    # "s":Lokio/Segment;
    :cond_0
    invoke-virtual {v0}, Ljavax/crypto/Mac;->doFinal()[B

    move-result-object v1

    invoke-static {v1}, Lokio/ByteString;->of([B)Lokio/ByteString;

    move-result-object v1
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/security/InvalidKeyException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    .line 1611
    .end local v0    # "mac":Ljavax/crypto/Mac;
    :catch_0
    move-exception v0

    .line 1612
    .local v0, "e":Ljava/security/InvalidKeyException;
    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 1609
    .end local v0    # "e":Ljava/security/InvalidKeyException;
    :catch_1
    move-exception v0

    .line 1610
    .local v0, "e":Ljava/security/NoSuchAlgorithmException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1
.end method

.method private rangeEquals(Lokio/Segment;ILokio/ByteString;II)Z
    .locals 5
    .param p1, "segment"    # Lokio/Segment;
    .param p2, "segmentPos"    # I
    .param p3, "bytes"    # Lokio/ByteString;
    .param p4, "bytesOffset"    # I
    .param p5, "bytesLimit"    # I

    .line 1505
    iget v0, p1, Lokio/Segment;->limit:I

    .line 1506
    .local v0, "segmentLimit":I
    iget-object v1, p1, Lokio/Segment;->data:[B

    .line 1508
    .local v1, "data":[B
    move-object v2, v1

    move-object v1, p1

    move p1, p4

    .line 1508
    .local v1, "segment":Lokio/Segment;
    .local v2, "data":[B
    .local p1, "i":I
    :goto_0
    if-ge p1, p5, :cond_2

    .line 1509
    if-ne p2, v0, :cond_0

    .line 1510
    iget-object v1, v1, Lokio/Segment;->next:Lokio/Segment;

    .line 1511
    iget-object v2, v1, Lokio/Segment;->data:[B

    .line 1512
    iget p2, v1, Lokio/Segment;->pos:I

    .line 1513
    iget v0, v1, Lokio/Segment;->limit:I

    .line 1516
    :cond_0
    aget-byte v3, v2, p2

    invoke-virtual {p3, p1}, Lokio/ByteString;->getByte(I)B

    move-result v4

    if-eq v3, v4, :cond_1

    .line 1517
    const/4 v3, 0x0

    return v3

    .line 1520
    :cond_1
    add-int/lit8 p2, p2, 0x1

    .line 1521
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 1524
    .end local p1    # "i":I
    :cond_2
    const/4 p1, 0x1

    return p1
.end method

.method private readFrom(Ljava/io/InputStream;JZ)V
    .locals 7
    .param p1, "in"    # Ljava/io/InputStream;
    .param p2, "byteCount"    # J
    .param p4, "forever"    # Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 243
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "in == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 244
    :cond_0
    :goto_0
    const-wide/16 v0, 0x0

    cmp-long v0, p2, v0

    if-gtz v0, :cond_2

    if-eqz p4, :cond_1

    goto :goto_1

    .line 256
    :cond_1
    return-void

    .line 245
    :cond_2
    :goto_1
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v0

    .line 246
    .local v0, "tail":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->limit:I

    rsub-int v1, v1, 0x2000

    int-to-long v1, v1

    invoke-static {p2, p3, v1, v2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    long-to-int v1, v1

    .line 247
    .local v1, "maxToCopy":I
    iget-object v2, v0, Lokio/Segment;->data:[B

    iget v3, v0, Lokio/Segment;->limit:I

    invoke-virtual {p1, v2, v3, v1}, Ljava/io/InputStream;->read([BII)I

    move-result v2

    .line 248
    .local v2, "bytesRead":I
    const/4 v3, -0x1

    if-ne v2, v3, :cond_4

    .line 249
    if-eqz p4, :cond_3

    return-void

    .line 250
    :cond_3
    new-instance v3, Ljava/io/EOFException;

    invoke-direct {v3}, Ljava/io/EOFException;-><init>()V

    throw v3

    .line 252
    :cond_4
    iget v3, v0, Lokio/Segment;->limit:I

    add-int/2addr v3, v2

    iput v3, v0, Lokio/Segment;->limit:I

    .line 253
    iget-wide v3, p0, Lokio/Buffer;->size:J

    int-to-long v5, v2

    add-long/2addr v3, v5

    iput-wide v3, p0, Lokio/Buffer;->size:J

    .line 254
    int-to-long v3, v2

    sub-long/2addr p2, v3

    .line 255
    .end local v0    # "tail":Lokio/Segment;
    .end local v1    # "maxToCopy":I
    .end local v2    # "bytesRead":I
    goto :goto_0
.end method


# virtual methods
.method public buffer()Lokio/Buffer;
    .locals 0

    .line 68
    return-object p0
.end method

.method public clear()V
    .locals 2

    .line 811
    :try_start_0
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->skip(J)V
    :try_end_0
    .catch Ljava/io/EOFException; {:try_start_0 .. :try_end_0} :catch_0

    .line 814
    nop

    .line 815
    return-void

    .line 812
    :catch_0
    move-exception v0

    .line 813
    .local v0, "e":Ljava/io/EOFException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1, v0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v1
.end method

.method public bridge synthetic clone()Ljava/lang/Object;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/CloneNotSupportedException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0}, Lokio/Buffer;->clone()Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public clone()Lokio/Buffer;
    .locals 5

    .line 1672
    new-instance v0, Lokio/Buffer;

    invoke-direct {v0}, Lokio/Buffer;-><init>()V

    .line 1673
    .local v0, "result":Lokio/Buffer;
    iget-wide v1, p0, Lokio/Buffer;->size:J

    const-wide/16 v3, 0x0

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    return-object v0

    .line 1675
    :cond_0
    new-instance v1, Lokio/Segment;

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    invoke-direct {v1, v2}, Lokio/Segment;-><init>(Lokio/Segment;)V

    iput-object v1, v0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1676
    iget-object v1, v0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v2, v0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v3, v0, Lokio/Buffer;->head:Lokio/Segment;

    iput-object v3, v2, Lokio/Segment;->prev:Lokio/Segment;

    iput-object v3, v1, Lokio/Segment;->next:Lokio/Segment;

    .line 1677
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1677
    .local v1, "s":Lokio/Segment;
    :goto_0
    iget-object v1, v1, Lokio/Segment;->next:Lokio/Segment;

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eq v1, v2, :cond_1

    .line 1678
    iget-object v2, v0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v2, v2, Lokio/Segment;->prev:Lokio/Segment;

    new-instance v3, Lokio/Segment;

    invoke-direct {v3, v1}, Lokio/Segment;-><init>(Lokio/Segment;)V

    invoke-virtual {v2, v3}, Lokio/Segment;->push(Lokio/Segment;)Lokio/Segment;

    .line 1677
    goto :goto_0

    .line 1680
    .end local v1    # "s":Lokio/Segment;
    :cond_1
    iget-wide v1, p0, Lokio/Buffer;->size:J

    iput-wide v1, v0, Lokio/Buffer;->size:J

    .line 1681
    return-object v0
.end method

.method public close()V
    .locals 0

    .line 1531
    return-void
.end method

.method public completeSegmentByteCount()J
    .locals 5

    .line 264
    iget-wide v0, p0, Lokio/Buffer;->size:J

    .line 265
    .local v0, "result":J
    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-nez v4, :cond_0

    return-wide v2

    .line 268
    :cond_0
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v2, v2, Lokio/Segment;->prev:Lokio/Segment;

    .line 269
    .local v2, "tail":Lokio/Segment;
    iget v3, v2, Lokio/Segment;->limit:I

    const/16 v4, 0x2000

    if-ge v3, v4, :cond_1

    iget-boolean v3, v2, Lokio/Segment;->owner:Z

    if-eqz v3, :cond_1

    .line 270
    iget v3, v2, Lokio/Segment;->limit:I

    iget v4, v2, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    int-to-long v3, v3

    sub-long/2addr v0, v3

    .line 273
    :cond_1
    return-wide v0
.end method

.method public copyTo(Ljava/io/OutputStream;)Lokio/Buffer;
    .locals 6
    .param p1, "out"    # Ljava/io/OutputStream;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 139
    iget-wide v4, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    move-object v0, p0

    move-object v1, p1

    invoke-virtual/range {v0 .. v5}, Lokio/Buffer;->copyTo(Ljava/io/OutputStream;JJ)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public copyTo(Ljava/io/OutputStream;JJ)Lokio/Buffer;
    .locals 8
    .param p1, "out"    # Ljava/io/OutputStream;
    .param p2, "offset"    # J
    .param p4, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 147
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "out == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 148
    :cond_0
    iget-wide v2, p0, Lokio/Buffer;->size:J

    move-wide v4, p2

    move-wide v6, p4

    invoke-static/range {v2 .. v7}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 149
    const-wide/16 v0, 0x0

    cmp-long v2, p4, v0

    if-nez v2, :cond_1

    return-object p0

    .line 152
    :cond_1
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 153
    .local v2, "s":Lokio/Segment;
    :goto_0
    iget v3, v2, Lokio/Segment;->limit:I

    iget v4, v2, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    int-to-long v3, v3

    cmp-long v3, p2, v3

    if-ltz v3, :cond_2

    .line 154
    iget v3, v2, Lokio/Segment;->limit:I

    iget v4, v2, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    int-to-long v3, v3

    sub-long/2addr p2, v3

    .line 153
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_0

    .line 158
    :cond_2
    :goto_1
    cmp-long v3, p4, v0

    if-lez v3, :cond_3

    .line 159
    iget v3, v2, Lokio/Segment;->pos:I

    int-to-long v3, v3

    add-long/2addr v3, p2

    long-to-int v3, v3

    .line 160
    .local v3, "pos":I
    iget v4, v2, Lokio/Segment;->limit:I

    sub-int/2addr v4, v3

    int-to-long v4, v4

    invoke-static {v4, v5, p4, p5}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v4

    long-to-int v4, v4

    .line 161
    .local v4, "toCopy":I
    iget-object v5, v2, Lokio/Segment;->data:[B

    invoke-virtual {p1, v5, v3, v4}, Ljava/io/OutputStream;->write([BII)V

    .line 162
    int-to-long v5, v4

    sub-long/2addr p4, v5

    .line 163
    const-wide/16 p2, 0x0

    .line 158
    .end local v3    # "pos":I
    .end local v4    # "toCopy":I
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_1

    .line 166
    :cond_3
    return-object p0
.end method

.method public copyTo(Lokio/Buffer;JJ)Lokio/Buffer;
    .locals 8
    .param p1, "out"    # Lokio/Buffer;
    .param p2, "offset"    # J
    .param p4, "byteCount"    # J

    .line 171
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "out == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 172
    :cond_0
    iget-wide v2, p0, Lokio/Buffer;->size:J

    move-wide v4, p2

    move-wide v6, p4

    invoke-static/range {v2 .. v7}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 173
    const-wide/16 v0, 0x0

    cmp-long v2, p4, v0

    if-nez v2, :cond_1

    return-object p0

    .line 175
    :cond_1
    iget-wide v2, p1, Lokio/Buffer;->size:J

    add-long/2addr v2, p4

    iput-wide v2, p1, Lokio/Buffer;->size:J

    .line 178
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 179
    .local v2, "s":Lokio/Segment;
    :goto_0
    iget v3, v2, Lokio/Segment;->limit:I

    iget v4, v2, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    int-to-long v3, v3

    cmp-long v3, p2, v3

    if-ltz v3, :cond_2

    .line 180
    iget v3, v2, Lokio/Segment;->limit:I

    iget v4, v2, Lokio/Segment;->pos:I

    sub-int/2addr v3, v4

    int-to-long v3, v3

    sub-long/2addr p2, v3

    .line 179
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_0

    .line 184
    :cond_2
    :goto_1
    cmp-long v3, p4, v0

    if-lez v3, :cond_4

    .line 185
    new-instance v3, Lokio/Segment;

    invoke-direct {v3, v2}, Lokio/Segment;-><init>(Lokio/Segment;)V

    .line 186
    .local v3, "copy":Lokio/Segment;
    iget v4, v3, Lokio/Segment;->pos:I

    int-to-long v4, v4

    add-long/2addr v4, p2

    long-to-int v4, v4

    iput v4, v3, Lokio/Segment;->pos:I

    .line 187
    iget v4, v3, Lokio/Segment;->pos:I

    long-to-int v5, p4

    add-int/2addr v4, v5

    iget v5, v3, Lokio/Segment;->limit:I

    invoke-static {v4, v5}, Ljava/lang/Math;->min(II)I

    move-result v4

    iput v4, v3, Lokio/Segment;->limit:I

    .line 188
    iget-object v4, p1, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v4, :cond_3

    .line 189
    iput-object v3, v3, Lokio/Segment;->prev:Lokio/Segment;

    iput-object v3, v3, Lokio/Segment;->next:Lokio/Segment;

    iput-object v3, p1, Lokio/Buffer;->head:Lokio/Segment;

    goto :goto_2

    .line 191
    :cond_3
    iget-object v4, p1, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v4, v4, Lokio/Segment;->prev:Lokio/Segment;

    invoke-virtual {v4, v3}, Lokio/Segment;->push(Lokio/Segment;)Lokio/Segment;

    .line 193
    :goto_2
    iget v4, v3, Lokio/Segment;->limit:I

    iget v5, v3, Lokio/Segment;->pos:I

    sub-int/2addr v4, v5

    int-to-long v4, v4

    sub-long/2addr p4, v4

    .line 194
    const-wide/16 p2, 0x0

    .line 184
    .end local v3    # "copy":Lokio/Segment;
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_1

    .line 197
    :cond_4
    return-object p0
.end method

.method public emit()Lokio/BufferedSink;
    .locals 0

    .line 98
    return-object p0
.end method

.method public emitCompleteSegments()Lokio/Buffer;
    .locals 0

    .line 94
    return-object p0
.end method

.method public bridge synthetic emitCompleteSegments()Lokio/BufferedSink;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0}, Lokio/Buffer;->emitCompleteSegments()Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 17
    .param p1, "o"    # Ljava/lang/Object;

    move-object/from16 v0, p0

    .line 1617
    move-object/from16 v1, p1

    const/4 v2, 0x1

    if-ne v0, v1, :cond_0

    return v2

    .line 1618
    :cond_0
    instance-of v3, v1, Lokio/Buffer;

    const/4 v4, 0x0

    if-nez v3, :cond_1

    return v4

    .line 1619
    :cond_1
    move-object v3, v1

    check-cast v3, Lokio/Buffer;

    .line 1620
    .local v3, "that":Lokio/Buffer;
    iget-wide v5, v0, Lokio/Buffer;->size:J

    iget-wide v7, v3, Lokio/Buffer;->size:J

    cmp-long v5, v5, v7

    if-eqz v5, :cond_2

    return v4

    .line 1621
    :cond_2
    iget-wide v5, v0, Lokio/Buffer;->size:J

    const-wide/16 v7, 0x0

    cmp-long v5, v5, v7

    if-nez v5, :cond_3

    return v2

    .line 1623
    :cond_3
    iget-object v5, v0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1624
    .local v5, "sa":Lokio/Segment;
    iget-object v6, v3, Lokio/Buffer;->head:Lokio/Segment;

    .line 1625
    .local v6, "sb":Lokio/Segment;
    iget v9, v5, Lokio/Segment;->pos:I

    .line 1626
    .local v9, "posA":I
    iget v10, v6, Lokio/Segment;->pos:I

    .line 1628
    .local v10, "posB":I
    nop

    .line 1628
    .local v7, "pos":J
    :goto_0
    iget-wide v11, v0, Lokio/Buffer;->size:J

    cmp-long v11, v7, v11

    if-gez v11, :cond_8

    .line 1629
    iget v11, v5, Lokio/Segment;->limit:I

    sub-int/2addr v11, v9

    iget v12, v6, Lokio/Segment;->limit:I

    sub-int/2addr v12, v10

    invoke-static {v11, v12}, Ljava/lang/Math;->min(II)I

    move-result v11

    int-to-long v11, v11

    .line 1631
    .local v11, "count":J
    move v13, v10

    move v10, v9

    move v9, v4

    .line 1631
    .local v9, "i":I
    .local v10, "posA":I
    .local v13, "posB":I
    :goto_1
    int-to-long v14, v9

    cmp-long v14, v14, v11

    if-gez v14, :cond_5

    .line 1632
    iget-object v14, v5, Lokio/Segment;->data:[B

    add-int/lit8 v15, v10, 0x1

    .line 1632
    .local v15, "posA":I
    aget-byte v10, v14, v10

    .line 1632
    .end local v10    # "posA":I
    iget-object v14, v6, Lokio/Segment;->data:[B

    add-int/lit8 v16, v13, 0x1

    .line 1632
    .local v16, "posB":I
    aget-byte v13, v14, v13

    .line 1632
    .end local v13    # "posB":I
    if-eq v10, v13, :cond_4

    return v4

    .line 1631
    :cond_4
    add-int/lit8 v9, v9, 0x1

    move v10, v15

    move/from16 v13, v16

    goto :goto_1

    .line 1635
    .end local v9    # "i":I
    .end local v15    # "posA":I
    .end local v16    # "posB":I
    .restart local v10    # "posA":I
    .restart local v13    # "posB":I
    :cond_5
    iget v9, v5, Lokio/Segment;->limit:I

    if-ne v10, v9, :cond_6

    .line 1636
    iget-object v5, v5, Lokio/Segment;->next:Lokio/Segment;

    .line 1637
    iget v9, v5, Lokio/Segment;->pos:I

    .line 1637
    .end local v10    # "posA":I
    .local v9, "posA":I
    goto :goto_2

    .line 1640
    .end local v9    # "posA":I
    .restart local v10    # "posA":I
    :cond_6
    move v9, v10

    .line 1640
    .end local v10    # "posA":I
    .restart local v9    # "posA":I
    :goto_2
    iget v10, v6, Lokio/Segment;->limit:I

    if-ne v13, v10, :cond_7

    .line 1641
    iget-object v6, v6, Lokio/Segment;->next:Lokio/Segment;

    .line 1642
    iget v10, v6, Lokio/Segment;->pos:I

    .line 1642
    .end local v13    # "posB":I
    .local v10, "posB":I
    goto :goto_3

    .line 1628
    .end local v10    # "posB":I
    .restart local v13    # "posB":I
    :cond_7
    move v10, v13

    .line 1628
    .end local v13    # "posB":I
    .restart local v10    # "posB":I
    :goto_3
    add-long/2addr v7, v11

    goto :goto_0

    .line 1646
    .end local v7    # "pos":J
    .end local v11    # "count":J
    :cond_8
    return v2
.end method

.method public exhausted()Z
    .locals 4

    .line 102
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public flush()V
    .locals 0

    .line 1528
    return-void
.end method

.method public getByte(J)B
    .locals 6
    .param p1, "pos"    # J

    .line 299
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v4, 0x1

    move-wide v2, p1

    invoke-static/range {v0 .. v5}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 300
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 301
    .local v0, "s":Lokio/Segment;
    :goto_0
    iget v1, v0, Lokio/Segment;->limit:I

    iget v2, v0, Lokio/Segment;->pos:I

    sub-int/2addr v1, v2

    .line 302
    .local v1, "segmentByteCount":I
    int-to-long v2, v1

    cmp-long v2, p1, v2

    if-gez v2, :cond_0

    iget-object v2, v0, Lokio/Segment;->data:[B

    iget v3, v0, Lokio/Segment;->pos:I

    long-to-int v4, p1

    add-int/2addr v3, v4

    aget-byte v2, v2, v3

    return v2

    .line 303
    :cond_0
    int-to-long v2, v1

    sub-long/2addr p1, v2

    .line 300
    .end local v1    # "segmentByteCount":I
    iget-object v0, v0, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_0
.end method

.method public hashCode()I
    .locals 6

    .line 1650
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1651
    .local v0, "s":Lokio/Segment;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    return v1

    .line 1652
    :cond_0
    const/4 v1, 0x1

    .line 1654
    .local v1, "result":I
    :cond_1
    iget v2, v0, Lokio/Segment;->pos:I

    .line 1654
    .local v2, "pos":I
    iget v3, v0, Lokio/Segment;->limit:I

    .line 1654
    .local v3, "limit":I
    :goto_0
    if-ge v2, v3, :cond_2

    .line 1655
    mul-int/lit8 v4, v1, 0x1f

    iget-object v5, v0, Lokio/Segment;->data:[B

    aget-byte v5, v5, v2

    add-int v1, v4, v5

    .line 1654
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1657
    .end local v2    # "pos":I
    .end local v3    # "limit":I
    :cond_2
    iget-object v0, v0, Lokio/Segment;->next:Lokio/Segment;

    .line 1658
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-ne v0, v2, :cond_1

    .line 1659
    return v1
.end method

.method public hmacSha1(Lokio/ByteString;)Lokio/ByteString;
    .locals 1
    .param p1, "key"    # Lokio/ByteString;

    .line 1585
    const-string v0, "HmacSHA1"

    invoke-direct {p0, v0, p1}, Lokio/Buffer;->hmac(Ljava/lang/String;Lokio/ByteString;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public hmacSha256(Lokio/ByteString;)Lokio/ByteString;
    .locals 1
    .param p1, "key"    # Lokio/ByteString;

    .line 1590
    const-string v0, "HmacSHA256"

    invoke-direct {p0, v0, p1}, Lokio/Buffer;->hmac(Ljava/lang/String;Lokio/ByteString;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public hmacSha512(Lokio/ByteString;)Lokio/ByteString;
    .locals 1
    .param p1, "key"    # Lokio/ByteString;

    .line 1595
    const-string v0, "HmacSHA512"

    invoke-direct {p0, v0, p1}, Lokio/Buffer;->hmac(Ljava/lang/String;Lokio/ByteString;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public indexOf(B)J
    .locals 6
    .param p1, "b"    # B

    .line 1275
    const-wide/16 v2, 0x0

    const-wide v4, 0x7fffffffffffffffL

    move-object v0, p0

    move v1, p1

    invoke-virtual/range {v0 .. v5}, Lokio/Buffer;->indexOf(BJJ)J

    move-result-wide v0

    return-wide v0
.end method

.method public indexOf(BJ)J
    .locals 6
    .param p1, "b"    # B
    .param p2, "fromIndex"    # J

    .line 1283
    const-wide v4, 0x7fffffffffffffffL

    move-object v0, p0

    move v1, p1

    move-wide v2, p2

    invoke-virtual/range {v0 .. v5}, Lokio/Buffer;->indexOf(BJJ)J

    move-result-wide v0

    return-wide v0
.end method

.method public indexOf(BJJ)J
    .locals 10
    .param p1, "b"    # B
    .param p2, "fromIndex"    # J
    .param p4, "toIndex"    # J

    .line 1287
    const-wide/16 v0, 0x0

    cmp-long v2, p2, v0

    if-ltz v2, :cond_9

    cmp-long v2, p4, p2

    if-gez v2, :cond_0

    goto/16 :goto_4

    .line 1292
    :cond_0
    iget-wide v2, p0, Lokio/Buffer;->size:J

    cmp-long v2, p4, v2

    if-lez v2, :cond_1

    iget-wide p4, p0, Lokio/Buffer;->size:J

    .line 1293
    :cond_1
    cmp-long v2, p2, p4

    const-wide/16 v3, -0x1

    if-nez v2, :cond_2

    return-wide v3

    .line 1301
    :cond_2
    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1302
    .local v2, "s":Lokio/Segment;
    if-nez v2, :cond_3

    .line 1304
    return-wide v3

    .line 1305
    :cond_3
    iget-wide v5, p0, Lokio/Buffer;->size:J

    sub-long/2addr v5, p2

    cmp-long v5, v5, p2

    if-gez v5, :cond_4

    .line 1307
    iget-wide v0, p0, Lokio/Buffer;->size:J

    .line 1308
    .local v0, "offset":J
    :goto_0
    cmp-long v5, v0, p2

    if-lez v5, :cond_5

    .line 1309
    iget-object v2, v2, Lokio/Segment;->prev:Lokio/Segment;

    .line 1310
    iget v5, v2, Lokio/Segment;->limit:I

    iget v6, v2, Lokio/Segment;->pos:I

    sub-int/2addr v5, v6

    int-to-long v5, v5

    sub-long/2addr v0, v5

    goto :goto_0

    .line 1314
    .end local v0    # "offset":J
    :cond_4
    nop

    .line 1315
    .restart local v0    # "offset":J
    :goto_1
    iget v5, v2, Lokio/Segment;->limit:I

    iget v6, v2, Lokio/Segment;->pos:I

    sub-int/2addr v5, v6

    int-to-long v5, v5

    add-long/2addr v5, v0

    move-wide v7, v5

    .line 1315
    .local v7, "nextOffset":J
    cmp-long v5, v5, p2

    if-gez v5, :cond_5

    .line 1316
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    .line 1317
    move-wide v0, v7

    goto :goto_1

    .line 1323
    .end local v7    # "nextOffset":J
    :cond_5
    :goto_2
    cmp-long v5, v0, p4

    if-gez v5, :cond_8

    .line 1324
    iget-object v5, v2, Lokio/Segment;->data:[B

    .line 1325
    .local v5, "data":[B
    iget v6, v2, Lokio/Segment;->limit:I

    int-to-long v6, v6

    iget v8, v2, Lokio/Segment;->pos:I

    int-to-long v8, v8

    add-long/2addr v8, p4

    sub-long/2addr v8, v0

    invoke-static {v6, v7, v8, v9}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v6

    long-to-int v6, v6

    .line 1326
    .local v6, "limit":I
    iget v7, v2, Lokio/Segment;->pos:I

    int-to-long v7, v7

    add-long/2addr v7, p2

    sub-long/2addr v7, v0

    long-to-int v7, v7

    .line 1327
    .local v7, "pos":I
    :goto_3
    if-ge v7, v6, :cond_7

    .line 1328
    aget-byte v8, v5, v7

    if-ne v8, p1, :cond_6

    .line 1329
    iget v3, v2, Lokio/Segment;->pos:I

    sub-int v3, v7, v3

    int-to-long v3, v3

    add-long/2addr v3, v0

    return-wide v3

    .line 1327
    :cond_6
    add-int/lit8 v7, v7, 0x1

    goto :goto_3

    .line 1334
    :cond_7
    iget v8, v2, Lokio/Segment;->limit:I

    iget v9, v2, Lokio/Segment;->pos:I

    sub-int/2addr v8, v9

    int-to-long v8, v8

    add-long/2addr v0, v8

    .line 1335
    move-wide p2, v0

    .line 1336
    iget-object v2, v2, Lokio/Segment;->next:Lokio/Segment;

    .line 1337
    .end local v5    # "data":[B
    .end local v6    # "limit":I
    .end local v7    # "pos":I
    goto :goto_2

    .line 1339
    :cond_8
    return-wide v3

    .line 1288
    .end local v0    # "offset":J
    .end local v2    # "s":Lokio/Segment;
    :cond_9
    :goto_4
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "size=%s fromIndex=%s toIndex=%s"

    const/4 v2, 0x3

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    iget-wide v4, p0, Lokio/Buffer;->size:J

    .line 1289
    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    const/4 v4, 0x1

    aput-object v3, v2, v4

    const/4 v3, 0x2

    invoke-static {p4, p5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public indexOf(Lokio/ByteString;)J
    .locals 2
    .param p1, "bytes"    # Lokio/ByteString;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1343
    const-wide/16 v0, 0x0

    invoke-virtual {p0, p1, v0, v1}, Lokio/Buffer;->indexOf(Lokio/ByteString;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public indexOf(Lokio/ByteString;J)J
    .locals 23
    .param p1, "bytes"    # Lokio/ByteString;
    .param p2, "fromIndex"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    move-object/from16 v6, p0

    .line 1347
    invoke-virtual/range {p1 .. p1}, Lokio/ByteString;->size()I

    move-result v2

    if-nez v2, :cond_0

    new-instance v2, Ljava/lang/IllegalArgumentException;

    const-string v3, "bytes is empty"

    invoke-direct {v2, v3}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 1348
    :cond_0
    const-wide/16 v2, 0x0

    cmp-long v4, p2, v2

    if-gez v4, :cond_1

    new-instance v2, Ljava/lang/IllegalArgumentException;

    const-string v3, "fromIndex < 0"

    invoke-direct {v2, v3}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 1356
    :cond_1
    iget-object v4, v6, Lokio/Buffer;->head:Lokio/Segment;

    .line 1357
    .local v4, "s":Lokio/Segment;
    const-wide/16 v7, -0x1

    if-nez v4, :cond_2

    .line 1359
    return-wide v7

    .line 1360
    :cond_2
    iget-wide v9, v6, Lokio/Buffer;->size:J

    sub-long v9, v9, p2

    cmp-long v5, v9, p2

    if-gez v5, :cond_3

    .line 1362
    iget-wide v2, v6, Lokio/Buffer;->size:J

    .line 1363
    .local v2, "offset":J
    :goto_0
    cmp-long v5, v2, p2

    if-lez v5, :cond_4

    .line 1364
    iget-object v4, v4, Lokio/Segment;->prev:Lokio/Segment;

    .line 1365
    iget v5, v4, Lokio/Segment;->limit:I

    iget v9, v4, Lokio/Segment;->pos:I

    sub-int/2addr v5, v9

    int-to-long v9, v5

    sub-long/2addr v2, v9

    goto :goto_0

    .line 1369
    .end local v2    # "offset":J
    :cond_3
    nop

    .line 1370
    .restart local v2    # "offset":J
    :goto_1
    iget v5, v4, Lokio/Segment;->limit:I

    iget v9, v4, Lokio/Segment;->pos:I

    sub-int/2addr v5, v9

    int-to-long v9, v5

    add-long/2addr v9, v2

    move-wide v11, v9

    .line 1370
    .local v11, "nextOffset":J
    cmp-long v5, v9, p2

    if-gez v5, :cond_4

    .line 1371
    iget-object v4, v4, Lokio/Segment;->next:Lokio/Segment;

    .line 1372
    move-wide v2, v11

    goto :goto_1

    .line 1379
    .end local v11    # "nextOffset":J
    :cond_4
    const/4 v5, 0x0

    move-object/from16 v9, p1

    invoke-virtual {v9, v5}, Lokio/ByteString;->getByte(I)B

    move-result v10

    .line 1380
    .local v10, "b0":B
    invoke-virtual/range {p1 .. p1}, Lokio/ByteString;->size()I

    move-result v11

    .line 1381
    .local v11, "bytesSize":I
    iget-wide v12, v6, Lokio/Buffer;->size:J

    int-to-long v14, v11

    sub-long/2addr v12, v14

    const-wide/16 v14, 0x1

    add-long/2addr v12, v14

    move-wide/from16 v16, p2

    move-wide v14, v2

    move-object v5, v4

    .line 1382
    .end local v2    # "offset":J
    .end local v4    # "s":Lokio/Segment;
    .end local p2    # "fromIndex":J
    .local v5, "s":Lokio/Segment;
    .local v12, "resultLimit":J
    .local v14, "offset":J
    .local v16, "fromIndex":J
    :goto_2
    cmp-long v0, v14, v12

    if-gez v0, :cond_8

    .line 1384
    iget-object v4, v5, Lokio/Segment;->data:[B

    .line 1385
    .local v4, "data":[B
    iget v0, v5, Lokio/Segment;->limit:I

    int-to-long v0, v0

    iget v2, v5, Lokio/Segment;->pos:I

    int-to-long v2, v2

    add-long/2addr v2, v12

    sub-long/2addr v2, v14

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int v3, v0

    .line 1386
    .local v3, "segmentLimit":I
    iget v0, v5, Lokio/Segment;->pos:I

    int-to-long v0, v0

    add-long v0, v0, v16

    sub-long/2addr v0, v14

    long-to-int v0, v0

    .line 1386
    .local v0, "pos":I
    :goto_3
    move v2, v0

    .line 1386
    .end local v0    # "pos":I
    .local v2, "pos":I
    if-ge v2, v3, :cond_7

    .line 1387
    aget-byte v0, v4, v2

    if-ne v0, v10, :cond_5

    add-int/lit8 v18, v2, 0x1

    const/16 v19, 0x1

    move-object v0, v6

    move-object v1, v5

    move/from16 v20, v2

    move/from16 v2, v18

    .line 1387
    .end local v2    # "pos":I
    .local v20, "pos":I
    move/from16 v18, v3

    move-object v3, v9

    .line 1387
    .end local v3    # "segmentLimit":I
    .local v18, "segmentLimit":I
    move-object/from16 v21, v4

    move/from16 v4, v19

    .line 1387
    .end local v4    # "data":[B
    .local v21, "data":[B
    move-object v7, v5

    move v5, v11

    .line 1387
    .end local v5    # "s":Lokio/Segment;
    .local v7, "s":Lokio/Segment;
    invoke-direct/range {v0 .. v5}, Lokio/Buffer;->rangeEquals(Lokio/Segment;ILokio/ByteString;II)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 1388
    iget v0, v7, Lokio/Segment;->pos:I

    sub-int v2, v20, v0

    int-to-long v0, v2

    add-long/2addr v0, v14

    return-wide v0

    .line 1386
    .end local v7    # "s":Lokio/Segment;
    .end local v18    # "segmentLimit":I
    .end local v20    # "pos":I
    .end local v21    # "data":[B
    .restart local v2    # "pos":I
    .restart local v3    # "segmentLimit":I
    .restart local v4    # "data":[B
    .restart local v5    # "s":Lokio/Segment;
    :cond_5
    move/from16 v20, v2

    move/from16 v18, v3

    move-object/from16 v21, v4

    move-object v7, v5

    .line 1386
    .end local v2    # "pos":I
    .end local v3    # "segmentLimit":I
    .end local v4    # "data":[B
    .end local v5    # "s":Lokio/Segment;
    .restart local v7    # "s":Lokio/Segment;
    .restart local v18    # "segmentLimit":I
    .restart local v20    # "pos":I
    .restart local v21    # "data":[B
    :cond_6
    add-int/lit8 v0, v20, 0x1

    .line 1386
    .end local v20    # "pos":I
    .restart local v0    # "pos":I
    move-object v5, v7

    move/from16 v3, v18

    move-object/from16 v4, v21

    const-wide/16 v7, -0x1

    goto :goto_3

    .line 1393
    .end local v0    # "pos":I
    .end local v7    # "s":Lokio/Segment;
    .end local v18    # "segmentLimit":I
    .end local v21    # "data":[B
    .restart local v3    # "segmentLimit":I
    .restart local v4    # "data":[B
    .restart local v5    # "s":Lokio/Segment;
    :cond_7
    move/from16 v18, v3

    move-object/from16 v21, v4

    move-object v7, v5

    .line 1393
    .end local v3    # "segmentLimit":I
    .end local v4    # "data":[B
    .end local v5    # "s":Lokio/Segment;
    .restart local v7    # "s":Lokio/Segment;
    .restart local v18    # "segmentLimit":I
    .restart local v21    # "data":[B
    iget v0, v7, Lokio/Segment;->limit:I

    iget v1, v7, Lokio/Segment;->pos:I

    sub-int/2addr v0, v1

    int-to-long v0, v0

    add-long/2addr v14, v0

    .line 1394
    move-wide/from16 v16, v14

    .line 1395
    iget-object v5, v7, Lokio/Segment;->next:Lokio/Segment;

    .line 1396
    .end local v7    # "s":Lokio/Segment;
    .end local v18    # "segmentLimit":I
    .end local v21    # "data":[B
    .restart local v5    # "s":Lokio/Segment;
    nop

    .line 1381
    const-wide/16 v7, -0x1

    goto :goto_2

    .line 1398
    :cond_8
    move-object v7, v5

    .line 1398
    .end local v5    # "s":Lokio/Segment;
    .restart local v7    # "s":Lokio/Segment;
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method public indexOfElement(Lokio/ByteString;)J
    .locals 2
    .param p1, "targetBytes"    # Lokio/ByteString;

    .line 1402
    const-wide/16 v0, 0x0

    invoke-virtual {p0, p1, v0, v1}, Lokio/Buffer;->indexOfElement(Lokio/ByteString;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public indexOfElement(Lokio/ByteString;J)J
    .locals 17
    .param p1, "targetBytes"    # Lokio/ByteString;
    .param p2, "fromIndex"    # J

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 1406
    const-wide/16 v4, 0x0

    cmp-long v6, p2, v4

    if-gez v6, :cond_0

    new-instance v4, Ljava/lang/IllegalArgumentException;

    const-string v5, "fromIndex < 0"

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 1414
    :cond_0
    iget-object v6, v0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1415
    .local v6, "s":Lokio/Segment;
    const-wide/16 v7, -0x1

    if-nez v6, :cond_1

    .line 1417
    return-wide v7

    .line 1418
    :cond_1
    iget-wide v9, v0, Lokio/Buffer;->size:J

    sub-long v9, v9, p2

    cmp-long v9, v9, p2

    if-gez v9, :cond_2

    .line 1420
    iget-wide v4, v0, Lokio/Buffer;->size:J

    .line 1421
    .local v4, "offset":J
    :goto_0
    cmp-long v9, v4, p2

    if-lez v9, :cond_3

    .line 1422
    iget-object v6, v6, Lokio/Segment;->prev:Lokio/Segment;

    .line 1423
    iget v9, v6, Lokio/Segment;->limit:I

    iget v10, v6, Lokio/Segment;->pos:I

    sub-int/2addr v9, v10

    int-to-long v9, v9

    sub-long/2addr v4, v9

    goto :goto_0

    .line 1427
    .end local v4    # "offset":J
    :cond_2
    nop

    .line 1428
    .restart local v4    # "offset":J
    :goto_1
    iget v9, v6, Lokio/Segment;->limit:I

    iget v10, v6, Lokio/Segment;->pos:I

    sub-int/2addr v9, v10

    int-to-long v9, v9

    add-long/2addr v9, v4

    move-wide v11, v9

    .line 1428
    .local v11, "nextOffset":J
    cmp-long v9, v9, p2

    if-gez v9, :cond_3

    .line 1429
    iget-object v6, v6, Lokio/Segment;->next:Lokio/Segment;

    .line 1430
    move-wide v4, v11

    goto :goto_1

    .line 1438
    .end local v11    # "nextOffset":J
    :cond_3
    invoke-virtual/range {p1 .. p1}, Lokio/ByteString;->size()I

    move-result v9

    const/4 v10, 0x2

    const/4 v11, 0x0

    if-ne v9, v10, :cond_8

    .line 1440
    invoke-virtual {v1, v11}, Lokio/ByteString;->getByte(I)B

    move-result v9

    .line 1441
    .local v9, "b0":B
    const/4 v10, 0x1

    invoke-virtual {v1, v10}, Lokio/ByteString;->getByte(I)B

    move-result v10

    move-wide/from16 v2, p2

    .line 1442
    .end local p2    # "fromIndex":J
    .local v2, "fromIndex":J
    .local v10, "b1":B
    :goto_2
    iget-wide v11, v0, Lokio/Buffer;->size:J

    cmp-long v11, v4, v11

    if-gez v11, :cond_7

    .line 1443
    iget-object v11, v6, Lokio/Segment;->data:[B

    .line 1444
    .local v11, "data":[B
    iget v12, v6, Lokio/Segment;->pos:I

    int-to-long v12, v12

    add-long/2addr v12, v2

    sub-long/2addr v12, v4

    long-to-int v12, v12

    .line 1444
    .local v12, "pos":I
    iget v13, v6, Lokio/Segment;->limit:I

    .line 1444
    .local v13, "limit":I
    :goto_3
    if-ge v12, v13, :cond_6

    .line 1445
    aget-byte v14, v11, v12

    .line 1446
    .local v14, "b":I
    if-eq v14, v9, :cond_5

    if-ne v14, v10, :cond_4

    goto :goto_4

    .line 1444
    .end local v14    # "b":I
    :cond_4
    add-int/lit8 v12, v12, 0x1

    goto :goto_3

    .line 1447
    .restart local v14    # "b":I
    :cond_5
    :goto_4
    iget v7, v6, Lokio/Segment;->pos:I

    sub-int v7, v12, v7

    int-to-long v7, v7

    add-long/2addr v7, v4

    return-wide v7

    .line 1452
    .end local v12    # "pos":I
    .end local v13    # "limit":I
    .end local v14    # "b":I
    :cond_6
    iget v12, v6, Lokio/Segment;->limit:I

    iget v13, v6, Lokio/Segment;->pos:I

    sub-int/2addr v12, v13

    int-to-long v12, v12

    add-long/2addr v4, v12

    .line 1453
    move-wide v2, v4

    .line 1454
    iget-object v6, v6, Lokio/Segment;->next:Lokio/Segment;

    .line 1455
    .end local v11    # "data":[B
    goto :goto_2

    .line 1456
    .end local v9    # "b0":B
    .end local v10    # "b1":B
    :cond_7
    goto :goto_8

    .line 1458
    .end local v2    # "fromIndex":J
    .restart local p2    # "fromIndex":J
    :cond_8
    invoke-virtual/range {p1 .. p1}, Lokio/ByteString;->internalArray()[B

    move-result-object v9

    move-wide/from16 v2, p2

    .line 1459
    .end local p2    # "fromIndex":J
    .restart local v2    # "fromIndex":J
    .local v9, "targetByteArray":[B
    :goto_5
    iget-wide v12, v0, Lokio/Buffer;->size:J

    cmp-long v10, v4, v12

    if-gez v10, :cond_c

    .line 1460
    iget-object v10, v6, Lokio/Segment;->data:[B

    .line 1461
    .local v10, "data":[B
    iget v12, v6, Lokio/Segment;->pos:I

    int-to-long v12, v12

    add-long/2addr v12, v2

    sub-long/2addr v12, v4

    long-to-int v12, v12

    .line 1461
    .restart local v12    # "pos":I
    iget v13, v6, Lokio/Segment;->limit:I

    .line 1461
    .restart local v13    # "limit":I
    :goto_6
    if-ge v12, v13, :cond_b

    .line 1462
    aget-byte v14, v10, v12

    .line 1463
    .restart local v14    # "b":I
    array-length v15, v9

    :goto_7
    if-ge v11, v15, :cond_a

    aget-byte v7, v9, v11

    .line 1464
    .local v7, "t":B
    if-ne v14, v7, :cond_9

    iget v8, v6, Lokio/Segment;->pos:I

    sub-int v8, v12, v8

    int-to-long v0, v8

    add-long/2addr v0, v4

    return-wide v0

    .line 1463
    .end local v7    # "t":B
    :cond_9
    add-int/lit8 v11, v11, 0x1

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const-wide/16 v7, -0x1

    goto :goto_7

    .line 1461
    .end local v14    # "b":I
    :cond_a
    add-int/lit8 v12, v12, 0x1

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const-wide/16 v7, -0x1

    const/4 v11, 0x0

    goto :goto_6

    .line 1469
    .end local v12    # "pos":I
    .end local v13    # "limit":I
    :cond_b
    iget v0, v6, Lokio/Segment;->limit:I

    iget v1, v6, Lokio/Segment;->pos:I

    sub-int/2addr v0, v1

    int-to-long v0, v0

    add-long/2addr v4, v0

    .line 1470
    move-wide v2, v4

    .line 1471
    iget-object v6, v6, Lokio/Segment;->next:Lokio/Segment;

    .line 1472
    .end local v10    # "data":[B
    nop

    .line 1458
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const-wide/16 v7, -0x1

    const/4 v11, 0x0

    goto :goto_5

    .line 1475
    .end local v9    # "targetByteArray":[B
    :cond_c
    :goto_8
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method public inputStream()Ljava/io/InputStream;
    .locals 1

    .line 114
    new-instance v0, Lokio/Buffer$2;

    invoke-direct {v0, p0}, Lokio/Buffer$2;-><init>(Lokio/Buffer;)V

    return-object v0
.end method

.method public md5()Lokio/ByteString;
    .locals 1

    .line 1550
    const-string v0, "MD5"

    invoke-direct {p0, v0}, Lokio/Buffer;->digest(Ljava/lang/String;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public outputStream()Ljava/io/OutputStream;
    .locals 1

    .line 72
    new-instance v0, Lokio/Buffer$1;

    invoke-direct {v0, p0}, Lokio/Buffer$1;-><init>(Lokio/Buffer;)V

    return-object v0
.end method

.method public rangeEquals(JLokio/ByteString;)Z
    .locals 6
    .param p1, "offset"    # J
    .param p3, "bytes"    # Lokio/ByteString;

    .line 1479
    invoke-virtual {p3}, Lokio/ByteString;->size()I

    move-result v5

    const/4 v4, 0x0

    move-object v0, p0

    move-wide v1, p1

    move-object v3, p3

    invoke-virtual/range {v0 .. v5}, Lokio/Buffer;->rangeEquals(JLokio/ByteString;II)Z

    move-result v0

    return v0
.end method

.method public rangeEquals(JLokio/ByteString;II)Z
    .locals 6
    .param p1, "offset"    # J
    .param p3, "bytes"    # Lokio/ByteString;
    .param p4, "bytesOffset"    # I
    .param p5, "byteCount"    # I

    .line 1484
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    const/4 v1, 0x0

    if-ltz v0, :cond_3

    if-ltz p4, :cond_3

    if-ltz p5, :cond_3

    iget-wide v2, p0, Lokio/Buffer;->size:J

    sub-long/2addr v2, p1

    int-to-long v4, p5

    cmp-long v0, v2, v4

    if-ltz v0, :cond_3

    .line 1488
    invoke-virtual {p3}, Lokio/ByteString;->size()I

    move-result v0

    sub-int/2addr v0, p4

    if-ge v0, p5, :cond_0

    goto :goto_1

    .line 1491
    :cond_0
    move v0, v1

    .line 1491
    .local v0, "i":I
    :goto_0
    if-ge v0, p5, :cond_2

    .line 1492
    int-to-long v2, v0

    add-long/2addr v2, p1

    invoke-virtual {p0, v2, v3}, Lokio/Buffer;->getByte(J)B

    move-result v2

    add-int v3, p4, v0

    invoke-virtual {p3, v3}, Lokio/ByteString;->getByte(I)B

    move-result v3

    if-eq v2, v3, :cond_1

    .line 1493
    return v1

    .line 1491
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1496
    .end local v0    # "i":I
    :cond_2
    const/4 v0, 0x1

    return v0

    .line 1489
    :cond_3
    :goto_1
    return v1
.end method

.method public read([B)I
    .locals 2
    .param p1, "sink"    # [B

    .line 774
    array-length v0, p1

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v0}, Lokio/Buffer;->read([BII)I

    move-result v0

    return v0
.end method

.method public read([BII)I
    .locals 7
    .param p1, "sink"    # [B
    .param p2, "offset"    # I
    .param p3, "byteCount"    # I

    .line 787
    array-length v0, p1

    int-to-long v1, v0

    int-to-long v3, p2

    int-to-long v5, p3

    invoke-static/range {v1 .. v6}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 789
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 790
    .local v0, "s":Lokio/Segment;
    if-nez v0, :cond_0

    const/4 v1, -0x1

    return v1

    .line 791
    :cond_0
    iget v1, v0, Lokio/Segment;->limit:I

    iget v2, v0, Lokio/Segment;->pos:I

    sub-int/2addr v1, v2

    invoke-static {p3, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 792
    .local v1, "toCopy":I
    iget-object v2, v0, Lokio/Segment;->data:[B

    iget v3, v0, Lokio/Segment;->pos:I

    invoke-static {v2, v3, p1, p2, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 794
    iget v2, v0, Lokio/Segment;->pos:I

    add-int/2addr v2, v1

    iput v2, v0, Lokio/Segment;->pos:I

    .line 795
    iget-wide v2, p0, Lokio/Buffer;->size:J

    int-to-long v4, v1

    sub-long/2addr v2, v4

    iput-wide v2, p0, Lokio/Buffer;->size:J

    .line 797
    iget v2, v0, Lokio/Segment;->pos:I

    iget v3, v0, Lokio/Segment;->limit:I

    if-ne v2, v3, :cond_1

    .line 798
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 799
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    .line 802
    :cond_1
    return v1
.end method

.method public read(Lokio/Buffer;J)J
    .locals 4
    .param p1, "sink"    # Lokio/Buffer;
    .param p2, "byteCount"    # J

    .line 1266
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "sink == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1267
    :cond_0
    const-wide/16 v0, 0x0

    cmp-long v2, p2, v0

    if-gez v2, :cond_1

    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "byteCount < 0: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1268
    :cond_1
    iget-wide v2, p0, Lokio/Buffer;->size:J

    cmp-long v0, v2, v0

    if-nez v0, :cond_2

    const-wide/16 v0, -0x1

    return-wide v0

    .line 1269
    :cond_2
    iget-wide v0, p0, Lokio/Buffer;->size:J

    cmp-long v0, p2, v0

    if-lez v0, :cond_3

    iget-wide p2, p0, Lokio/Buffer;->size:J

    .line 1270
    :cond_3
    invoke-virtual {p1, p0, p2, p3}, Lokio/Buffer;->write(Lokio/Buffer;J)V

    .line 1271
    return-wide p2
.end method

.method public readAll(Lokio/Sink;)J
    .locals 4
    .param p1, "sink"    # Lokio/Sink;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 582
    iget-wide v0, p0, Lokio/Buffer;->size:J

    .line 583
    .local v0, "byteCount":J
    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-lez v2, :cond_0

    .line 584
    invoke-interface {p1, p0, v0, v1}, Lokio/Sink;->write(Lokio/Buffer;J)V

    .line 586
    :cond_0
    return-wide v0
.end method

.method public readByte()B
    .locals 9

    .line 277
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "size == 0"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 279
    :cond_0
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 280
    .local v0, "segment":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->pos:I

    .line 281
    .local v1, "pos":I
    iget v2, v0, Lokio/Segment;->limit:I

    .line 283
    .local v2, "limit":I
    iget-object v3, v0, Lokio/Segment;->data:[B

    .line 284
    .local v3, "data":[B
    add-int/lit8 v4, v1, 0x1

    .line 284
    .local v4, "pos":I
    aget-byte v1, v3, v1

    .line 285
    .local v1, "b":B
    iget-wide v5, p0, Lokio/Buffer;->size:J

    const-wide/16 v7, 0x1

    sub-long/2addr v5, v7

    iput-wide v5, p0, Lokio/Buffer;->size:J

    .line 287
    if-ne v4, v2, :cond_1

    .line 288
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v5

    iput-object v5, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 289
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_0

    .line 291
    :cond_1
    iput v4, v0, Lokio/Segment;->pos:I

    .line 294
    :goto_0
    return v1
.end method

.method public readByteArray()[B
    .locals 2

    .line 756
    :try_start_0
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->readByteArray(J)[B

    move-result-object v0
    :try_end_0
    .catch Ljava/io/EOFException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 757
    :catch_0
    move-exception v0

    .line 758
    .local v0, "e":Ljava/io/EOFException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1, v0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v1
.end method

.method public readByteArray(J)[B
    .locals 6
    .param p1, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 763
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    move-wide v4, p1

    invoke-static/range {v0 .. v5}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 764
    const-wide/32 v0, 0x7fffffff

    cmp-long v0, p1, v0

    if-lez v0, :cond_0

    .line 765
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "byteCount > Integer.MAX_VALUE: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 768
    :cond_0
    long-to-int v0, p1

    new-array v0, v0, [B

    .line 769
    .local v0, "result":[B
    invoke-virtual {p0, v0}, Lokio/Buffer;->readFully([B)V

    .line 770
    return-object v0
.end method

.method public readByteString()Lokio/ByteString;
    .locals 2

    .line 529
    new-instance v0, Lokio/ByteString;

    invoke-virtual {p0}, Lokio/Buffer;->readByteArray()[B

    move-result-object v1

    invoke-direct {v0, v1}, Lokio/ByteString;-><init>([B)V

    return-object v0
.end method

.method public readByteString(J)Lokio/ByteString;
    .locals 2
    .param p1, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 533
    new-instance v0, Lokio/ByteString;

    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->readByteArray(J)[B

    move-result-object v1

    invoke-direct {v0, v1}, Lokio/ByteString;-><init>([B)V

    return-object v0
.end method

.method public readDecimalLong()J
    .locals 21

    .line 415
    move-object/from16 v0, p0

    iget-wide v1, v0, Lokio/Buffer;->size:J

    const-wide/16 v3, 0x0

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "size == 0"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 418
    :cond_0
    const-wide/16 v1, 0x0

    .line 419
    .local v1, "value":J
    const/4 v3, 0x0

    .line 420
    .local v3, "seen":I
    const/4 v4, 0x0

    .line 421
    .local v4, "negative":Z
    const/4 v5, 0x0

    .line 423
    .local v5, "done":Z
    const-wide v6, -0xcccccccccccccccL

    .line 424
    .local v6, "overflowZone":J
    const-wide/16 v8, -0x7

    .line 427
    .local v8, "overflowDigit":J
    :goto_0
    iget-object v10, v0, Lokio/Buffer;->head:Lokio/Segment;

    .line 429
    .local v10, "segment":Lokio/Segment;
    iget-object v11, v10, Lokio/Segment;->data:[B

    .line 430
    .local v11, "data":[B
    iget v12, v10, Lokio/Segment;->pos:I

    .line 431
    .local v12, "pos":I
    iget v13, v10, Lokio/Segment;->limit:I

    .line 433
    .local v13, "limit":I
    :goto_1
    if-ge v12, v13, :cond_8

    .line 434
    aget-byte v14, v11, v12

    .line 435
    .local v14, "b":B
    const/16 v15, 0x30

    if-lt v14, v15, :cond_5

    const/16 v15, 0x39

    if-gt v14, v15, :cond_5

    .line 436
    const/16 v15, 0x30

    sub-int/2addr v15, v14

    .line 439
    .local v15, "digit":I
    cmp-long v16, v1, v6

    if-ltz v16, :cond_3

    cmp-long v16, v1, v6

    if-nez v16, :cond_1

    move/from16 v19, v5

    move-wide/from16 v17, v6

    int-to-long v5, v15

    .line 439
    .end local v5    # "done":Z
    .end local v6    # "overflowZone":J
    .local v17, "overflowZone":J
    .local v19, "done":Z
    cmp-long v5, v5, v8

    if-gez v5, :cond_2

    goto :goto_2

    .line 444
    .end local v17    # "overflowZone":J
    .end local v19    # "done":Z
    .restart local v5    # "done":Z
    .restart local v6    # "overflowZone":J
    :cond_1
    move/from16 v19, v5

    move-wide/from16 v17, v6

    .line 444
    .end local v5    # "done":Z
    .end local v6    # "overflowZone":J
    .restart local v17    # "overflowZone":J
    .restart local v19    # "done":Z
    :cond_2
    const-wide/16 v5, 0xa

    mul-long/2addr v1, v5

    .line 445
    int-to-long v5, v15

    add-long/2addr v1, v5

    .line 446
    .end local v15    # "digit":I
    nop

    .line 433
    move-object/from16 v20, v11

    goto :goto_3

    .line 440
    .end local v17    # "overflowZone":J
    .end local v19    # "done":Z
    .restart local v5    # "done":Z
    .restart local v6    # "overflowZone":J
    .restart local v15    # "digit":I
    :cond_3
    move/from16 v19, v5

    move-wide/from16 v17, v6

    .line 440
    .end local v5    # "done":Z
    .end local v6    # "overflowZone":J
    .restart local v17    # "overflowZone":J
    .restart local v19    # "done":Z
    :goto_2
    new-instance v5, Lokio/Buffer;

    invoke-direct {v5}, Lokio/Buffer;-><init>()V

    invoke-virtual {v5, v1, v2}, Lokio/Buffer;->writeDecimalLong(J)Lokio/Buffer;

    move-result-object v5

    invoke-virtual {v5, v14}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    move-result-object v5

    .line 441
    .local v5, "buffer":Lokio/Buffer;
    if-nez v4, :cond_4

    invoke-virtual {v5}, Lokio/Buffer;->readByte()B

    .line 442
    :cond_4
    new-instance v6, Ljava/lang/NumberFormatException;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v20, v11

    const-string v11, "Number too large: "

    .line 442
    .end local v11    # "data":[B
    .local v20, "data":[B
    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Lokio/Buffer;->readUtf8()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-direct {v6, v7}, Ljava/lang/NumberFormatException;-><init>(Ljava/lang/String;)V

    throw v6

    .line 446
    .end local v15    # "digit":I
    .end local v17    # "overflowZone":J
    .end local v19    # "done":Z
    .end local v20    # "data":[B
    .local v5, "done":Z
    .restart local v6    # "overflowZone":J
    .restart local v11    # "data":[B
    :cond_5
    move/from16 v19, v5

    move-wide/from16 v17, v6

    move-object/from16 v20, v11

    .line 446
    .end local v5    # "done":Z
    .end local v6    # "overflowZone":J
    .end local v11    # "data":[B
    .restart local v17    # "overflowZone":J
    .restart local v19    # "done":Z
    .restart local v20    # "data":[B
    const/16 v5, 0x2d

    if-ne v14, v5, :cond_6

    if-nez v3, :cond_6

    .line 447
    const/4 v4, 0x1

    .line 448
    const-wide/16 v5, 0x1

    sub-long/2addr v8, v5

    .line 433
    .end local v14    # "b":B
    :goto_3
    add-int/lit8 v12, v12, 0x1

    add-int/lit8 v3, v3, 0x1

    .line 431
    move-wide/from16 v6, v17

    move/from16 v5, v19

    move-object/from16 v11, v20

    goto :goto_1

    .line 450
    .restart local v14    # "b":B
    :cond_6
    if-nez v3, :cond_7

    .line 451
    new-instance v5, Ljava/lang/NumberFormatException;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Expected leading [0-9] or \'-\' character but was 0x"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 452
    invoke-static {v14}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/NumberFormatException;-><init>(Ljava/lang/String;)V

    throw v5

    .line 455
    :cond_7
    const/4 v5, 0x1

    .line 456
    .end local v19    # "done":Z
    .restart local v5    # "done":Z
    goto :goto_4

    .line 460
    .end local v14    # "b":B
    .end local v17    # "overflowZone":J
    .end local v20    # "data":[B
    .restart local v6    # "overflowZone":J
    .restart local v11    # "data":[B
    :cond_8
    move/from16 v19, v5

    move-wide/from16 v17, v6

    move-object/from16 v20, v11

    .line 460
    .end local v6    # "overflowZone":J
    .end local v11    # "data":[B
    .restart local v17    # "overflowZone":J
    .restart local v20    # "data":[B
    :goto_4
    if-ne v12, v13, :cond_9

    .line 461
    invoke-virtual {v10}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v6

    iput-object v6, v0, Lokio/Buffer;->head:Lokio/Segment;

    .line 462
    invoke-static {v10}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_5

    .line 464
    :cond_9
    iput v12, v10, Lokio/Segment;->pos:I

    .line 466
    .end local v10    # "segment":Lokio/Segment;
    .end local v12    # "pos":I
    .end local v13    # "limit":I
    .end local v20    # "data":[B
    :goto_5
    if-nez v5, :cond_b

    iget-object v6, v0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v6, :cond_a

    goto :goto_6

    .line 424
    :cond_a
    move-wide/from16 v6, v17

    goto/16 :goto_0

    .line 468
    :cond_b
    :goto_6
    iget-wide v6, v0, Lokio/Buffer;->size:J

    int-to-long v10, v3

    sub-long/2addr v6, v10

    iput-wide v6, v0, Lokio/Buffer;->size:J

    .line 469
    if-eqz v4, :cond_c

    move-wide v6, v1

    goto :goto_7

    :cond_c
    neg-long v6, v1

    :goto_7
    return-wide v6
.end method

.method public readFrom(Ljava/io/InputStream;)Lokio/Buffer;
    .locals 3
    .param p1, "in"    # Ljava/io/InputStream;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 231
    const-wide v0, 0x7fffffffffffffffL

    const/4 v2, 0x1

    invoke-direct {p0, p1, v0, v1, v2}, Lokio/Buffer;->readFrom(Ljava/io/InputStream;JZ)V

    .line 232
    return-object p0
.end method

.method public readFrom(Ljava/io/InputStream;J)Lokio/Buffer;
    .locals 3
    .param p1, "in"    # Ljava/io/InputStream;
    .param p2, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 237
    const-wide/16 v0, 0x0

    cmp-long v0, p2, v0

    if-gez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "byteCount < 0: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 238
    :cond_0
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, p3, v0}, Lokio/Buffer;->readFrom(Ljava/io/InputStream;JZ)V

    .line 239
    return-object p0
.end method

.method public readFully(Lokio/Buffer;J)V
    .locals 2
    .param p1, "sink"    # Lokio/Buffer;
    .param p2, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 574
    iget-wide v0, p0, Lokio/Buffer;->size:J

    cmp-long v0, v0, p2

    if-gez v0, :cond_0

    .line 575
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {p1, p0, v0, v1}, Lokio/Buffer;->write(Lokio/Buffer;J)V

    .line 576
    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    .line 578
    :cond_0
    invoke-virtual {p1, p0, p2, p3}, Lokio/Buffer;->write(Lokio/Buffer;J)V

    .line 579
    return-void
.end method

.method public readFully([B)V
    .locals 3
    .param p1, "sink"    # [B
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 778
    const/4 v0, 0x0

    .line 779
    .local v0, "offset":I
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_1

    .line 780
    array-length v1, p1

    sub-int/2addr v1, v0

    invoke-virtual {p0, p1, v0, v1}, Lokio/Buffer;->read([BII)I

    move-result v1

    .line 781
    .local v1, "read":I
    const/4 v2, -0x1

    if-ne v1, v2, :cond_0

    new-instance v2, Ljava/io/EOFException;

    invoke-direct {v2}, Ljava/io/EOFException;-><init>()V

    throw v2

    .line 782
    :cond_0
    add-int/2addr v0, v1

    .line 783
    .end local v1    # "read":I
    goto :goto_0

    .line 784
    :cond_1
    return-void
.end method

.method public readHexadecimalUnsignedLong()J
    .locals 14

    .line 473
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "size == 0"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 475
    :cond_0
    const-wide/16 v0, 0x0

    .line 476
    .local v0, "value":J
    const/4 v4, 0x0

    .line 477
    .local v4, "seen":I
    const/4 v5, 0x0

    .line 480
    .local v5, "done":Z
    :cond_1
    iget-object v6, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 482
    .local v6, "segment":Lokio/Segment;
    iget-object v7, v6, Lokio/Segment;->data:[B

    .line 483
    .local v7, "data":[B
    iget v8, v6, Lokio/Segment;->pos:I

    .line 484
    .local v8, "pos":I
    iget v9, v6, Lokio/Segment;->limit:I

    .line 486
    .local v9, "limit":I
    :goto_0
    if-ge v8, v9, :cond_7

    .line 489
    aget-byte v10, v7, v8

    .line 490
    .local v10, "b":B
    const/16 v11, 0x30

    if-lt v10, v11, :cond_2

    const/16 v11, 0x39

    if-gt v10, v11, :cond_2

    .line 491
    add-int/lit8 v11, v10, -0x30

    .line 491
    .local v11, "digit":I
    :goto_1
    goto :goto_2

    .line 492
    .end local v11    # "digit":I
    :cond_2
    const/16 v11, 0x61

    if-lt v10, v11, :cond_3

    const/16 v11, 0x66

    if-gt v10, v11, :cond_3

    .line 493
    add-int/lit8 v11, v10, -0x61

    add-int/lit8 v11, v11, 0xa

    goto :goto_1

    .line 494
    :cond_3
    const/16 v11, 0x41

    if-lt v10, v11, :cond_5

    const/16 v11, 0x46

    if-gt v10, v11, :cond_5

    .line 495
    add-int/lit8 v11, v10, -0x41

    add-int/lit8 v11, v11, 0xa

    goto :goto_1

    .line 503
    .restart local v11    # "digit":I
    :goto_2
    nop

    .line 507
    const-wide/high16 v12, -0x1000000000000000L    # -3.105036184601418E231

    and-long/2addr v12, v0

    cmp-long v12, v12, v2

    if-eqz v12, :cond_4

    .line 508
    new-instance v2, Lokio/Buffer;

    invoke-direct {v2}, Lokio/Buffer;-><init>()V

    invoke-virtual {v2, v0, v1}, Lokio/Buffer;->writeHexadecimalUnsignedLong(J)Lokio/Buffer;

    move-result-object v2

    invoke-virtual {v2, v10}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    move-result-object v2

    .line 509
    .local v2, "buffer":Lokio/Buffer;
    new-instance v3, Ljava/lang/NumberFormatException;

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "Number too large: "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Lokio/Buffer;->readUtf8()Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-direct {v3, v12}, Ljava/lang/NumberFormatException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 512
    .end local v2    # "buffer":Lokio/Buffer;
    :cond_4
    const/4 v12, 0x4

    shl-long/2addr v0, v12

    .line 513
    int-to-long v12, v11

    or-long/2addr v0, v12

    .line 486
    .end local v10    # "b":B
    .end local v11    # "digit":I
    add-int/lit8 v8, v8, 0x1

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 497
    .restart local v10    # "b":B
    :cond_5
    if-nez v4, :cond_6

    .line 498
    new-instance v2, Ljava/lang/NumberFormatException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "Expected leading [0-9a-fA-F] character but was 0x"

    invoke-virtual {v3, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 499
    invoke-static {v10}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v3, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/NumberFormatException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 502
    :cond_6
    const/4 v5, 0x1

    .line 503
    nop

    .line 516
    .end local v10    # "b":B
    :cond_7
    if-ne v8, v9, :cond_8

    .line 517
    invoke-virtual {v6}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v10

    iput-object v10, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 518
    invoke-static {v6}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_3

    .line 520
    :cond_8
    iput v8, v6, Lokio/Segment;->pos:I

    .line 522
    .end local v6    # "segment":Lokio/Segment;
    .end local v7    # "data":[B
    .end local v8    # "pos":I
    .end local v9    # "limit":I
    :goto_3
    if-nez v5, :cond_9

    iget-object v6, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v6, :cond_1

    .line 524
    :cond_9
    iget-wide v2, p0, Lokio/Buffer;->size:J

    int-to-long v6, v4

    sub-long/2addr v2, v6

    iput-wide v2, p0, Lokio/Buffer;->size:J

    .line 525
    return-wide v0
.end method

.method public readInt()I
    .locals 10

    .line 337
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x4

    cmp-long v0, v0, v2

    if-gez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "size < 4: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lokio/Buffer;->size:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 339
    :cond_0
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 340
    .local v0, "segment":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->pos:I

    .line 341
    .local v1, "pos":I
    iget v4, v0, Lokio/Segment;->limit:I

    .line 344
    .local v4, "limit":I
    sub-int v5, v4, v1

    const/4 v6, 0x4

    if-ge v5, v6, :cond_1

    .line 345
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v2

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x18

    .line 346
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x10

    or-int/2addr v2, v3

    .line 347
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v2, v3

    .line 348
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v3

    and-int/lit16 v3, v3, 0xff

    or-int/2addr v2, v3

    .line 345
    return v2

    .line 351
    :cond_1
    iget-object v5, v0, Lokio/Segment;->data:[B

    .line 352
    .local v5, "data":[B
    add-int/lit8 v6, v1, 0x1

    .line 352
    .local v6, "pos":I
    aget-byte v1, v5, v1

    .line 352
    .end local v1    # "pos":I
    and-int/lit16 v1, v1, 0xff

    shl-int/lit8 v1, v1, 0x18

    add-int/lit8 v7, v6, 0x1

    .line 352
    .local v7, "pos":I
    aget-byte v6, v5, v6

    .line 352
    .end local v6    # "pos":I
    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x10

    or-int/2addr v1, v6

    add-int/lit8 v6, v7, 0x1

    .line 352
    .restart local v6    # "pos":I
    aget-byte v7, v5, v7

    .line 352
    .end local v7    # "pos":I
    and-int/lit16 v7, v7, 0xff

    shl-int/lit8 v7, v7, 0x8

    or-int/2addr v1, v7

    add-int/lit8 v7, v6, 0x1

    .line 352
    .restart local v7    # "pos":I
    aget-byte v6, v5, v6

    .line 352
    .end local v6    # "pos":I
    and-int/lit16 v6, v6, 0xff

    or-int/2addr v1, v6

    .line 356
    .local v1, "i":I
    iget-wide v8, p0, Lokio/Buffer;->size:J

    sub-long/2addr v8, v2

    iput-wide v8, p0, Lokio/Buffer;->size:J

    .line 358
    if-ne v7, v4, :cond_2

    .line 359
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 360
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_0

    .line 362
    :cond_2
    iput v7, v0, Lokio/Segment;->pos:I

    .line 365
    :goto_0
    return v1
.end method

.method public readIntLe()I
    .locals 1

    .line 407
    invoke-virtual {p0}, Lokio/Buffer;->readInt()I

    move-result v0

    invoke-static {v0}, Lokio/Util;->reverseBytesInt(I)I

    move-result v0

    return v0
.end method

.method public readLong()J
    .locals 15

    .line 369
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x8

    cmp-long v0, v0, v2

    if-gez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "size < 8: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lokio/Buffer;->size:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 371
    :cond_0
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 372
    .local v0, "segment":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->pos:I

    .line 373
    .local v1, "pos":I
    iget v4, v0, Lokio/Segment;->limit:I

    .line 376
    .local v4, "limit":I
    sub-int v5, v4, v1

    const/16 v6, 0x20

    const/16 v7, 0x8

    if-ge v5, v7, :cond_1

    .line 377
    invoke-virtual {p0}, Lokio/Buffer;->readInt()I

    move-result v2

    int-to-long v2, v2

    const-wide v7, 0xffffffffL

    and-long/2addr v2, v7

    shl-long/2addr v2, v6

    .line 378
    invoke-virtual {p0}, Lokio/Buffer;->readInt()I

    move-result v5

    int-to-long v5, v5

    and-long/2addr v5, v7

    or-long/2addr v2, v5

    .line 377
    return-wide v2

    .line 381
    :cond_1
    iget-object v5, v0, Lokio/Segment;->data:[B

    .line 382
    .local v5, "data":[B
    add-int/lit8 v8, v1, 0x1

    .line 382
    .local v8, "pos":I
    aget-byte v1, v5, v1

    .line 382
    .end local v1    # "pos":I
    int-to-long v9, v1

    const-wide/16 v11, 0xff

    and-long/2addr v9, v11

    const/16 v1, 0x38

    shl-long/2addr v9, v1

    add-int/lit8 v1, v8, 0x1

    .line 382
    .restart local v1    # "pos":I
    aget-byte v8, v5, v8

    .line 382
    .end local v8    # "pos":I
    int-to-long v13, v8

    and-long/2addr v13, v11

    const/16 v8, 0x30

    shl-long/2addr v13, v8

    or-long v8, v9, v13

    add-int/lit8 v10, v1, 0x1

    .line 382
    .local v10, "pos":I
    aget-byte v1, v5, v1

    .line 382
    .end local v1    # "pos":I
    int-to-long v13, v1

    and-long/2addr v13, v11

    const/16 v1, 0x28

    shl-long/2addr v13, v1

    or-long/2addr v8, v13

    add-int/lit8 v1, v10, 0x1

    .line 382
    .restart local v1    # "pos":I
    aget-byte v10, v5, v10

    .line 382
    .end local v10    # "pos":I
    int-to-long v13, v10

    and-long/2addr v13, v11

    shl-long/2addr v13, v6

    or-long/2addr v8, v13

    add-int/lit8 v6, v1, 0x1

    .line 382
    .local v6, "pos":I
    aget-byte v1, v5, v1

    .line 382
    .end local v1    # "pos":I
    int-to-long v13, v1

    and-long/2addr v13, v11

    const/16 v1, 0x18

    shl-long/2addr v13, v1

    or-long/2addr v8, v13

    add-int/lit8 v1, v6, 0x1

    .line 382
    .restart local v1    # "pos":I
    aget-byte v6, v5, v6

    .line 382
    .end local v6    # "pos":I
    int-to-long v13, v6

    and-long/2addr v13, v11

    const/16 v6, 0x10

    shl-long/2addr v13, v6

    or-long/2addr v8, v13

    add-int/lit8 v6, v1, 0x1

    .line 382
    .restart local v6    # "pos":I
    aget-byte v1, v5, v1

    .line 382
    .end local v1    # "pos":I
    int-to-long v13, v1

    and-long/2addr v13, v11

    shl-long/2addr v13, v7

    or-long v7, v8, v13

    add-int/lit8 v1, v6, 0x1

    .line 382
    .restart local v1    # "pos":I
    aget-byte v6, v5, v6

    .line 382
    .end local v6    # "pos":I
    int-to-long v9, v6

    and-long/2addr v9, v11

    or-long v6, v7, v9

    .line 390
    .local v6, "v":J
    iget-wide v8, p0, Lokio/Buffer;->size:J

    sub-long/2addr v8, v2

    iput-wide v8, p0, Lokio/Buffer;->size:J

    .line 392
    if-ne v1, v4, :cond_2

    .line 393
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 394
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_0

    .line 396
    :cond_2
    iput v1, v0, Lokio/Segment;->pos:I

    .line 399
    :goto_0
    return-wide v6
.end method

.method public readLongLe()J
    .locals 2

    .line 411
    invoke-virtual {p0}, Lokio/Buffer;->readLong()J

    move-result-wide v0

    invoke-static {v0, v1}, Lokio/Util;->reverseBytesLong(J)J

    move-result-wide v0

    return-wide v0
.end method

.method public readShort()S
    .locals 10

    .line 308
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x2

    cmp-long v0, v0, v2

    if-gez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "size < 2: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lokio/Buffer;->size:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 310
    :cond_0
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 311
    .local v0, "segment":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->pos:I

    .line 312
    .local v1, "pos":I
    iget v4, v0, Lokio/Segment;->limit:I

    .line 315
    .local v4, "limit":I
    sub-int v5, v4, v1

    const/4 v6, 0x2

    if-ge v5, v6, :cond_1

    .line 316
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v2

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x8

    .line 317
    invoke-virtual {p0}, Lokio/Buffer;->readByte()B

    move-result v3

    and-int/lit16 v3, v3, 0xff

    or-int/2addr v2, v3

    .line 318
    .local v2, "s":I
    int-to-short v3, v2

    return v3

    .line 321
    .end local v2    # "s":I
    :cond_1
    iget-object v5, v0, Lokio/Segment;->data:[B

    .line 322
    .local v5, "data":[B
    add-int/lit8 v6, v1, 0x1

    .line 322
    .local v6, "pos":I
    aget-byte v1, v5, v1

    .line 322
    .end local v1    # "pos":I
    and-int/lit16 v1, v1, 0xff

    shl-int/lit8 v1, v1, 0x8

    add-int/lit8 v7, v6, 0x1

    .line 322
    .local v7, "pos":I
    aget-byte v6, v5, v6

    .line 322
    .end local v6    # "pos":I
    and-int/lit16 v6, v6, 0xff

    or-int/2addr v1, v6

    .line 324
    .local v1, "s":I
    iget-wide v8, p0, Lokio/Buffer;->size:J

    sub-long/2addr v8, v2

    iput-wide v8, p0, Lokio/Buffer;->size:J

    .line 326
    if-ne v7, v4, :cond_2

    .line 327
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 328
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    goto :goto_0

    .line 330
    :cond_2
    iput v7, v0, Lokio/Segment;->pos:I

    .line 333
    :goto_0
    int-to-short v2, v1

    return v2
.end method

.method public readShortLe()S
    .locals 1

    .line 403
    invoke-virtual {p0}, Lokio/Buffer;->readShort()S

    move-result v0

    invoke-static {v0}, Lokio/Util;->reverseBytesShort(S)S

    move-result v0

    return v0
.end method

.method public readString(JLjava/nio/charset/Charset;)Ljava/lang/String;
    .locals 6
    .param p1, "byteCount"    # J
    .param p3, "charset"    # Ljava/nio/charset/Charset;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 610
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    move-wide v4, p1

    invoke-static/range {v0 .. v5}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 611
    if-nez p3, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "charset == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 612
    :cond_0
    const-wide/32 v0, 0x7fffffff

    cmp-long v0, p1, v0

    if-lez v0, :cond_1

    .line 613
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "byteCount > Integer.MAX_VALUE: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 615
    :cond_1
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-nez v0, :cond_2

    const-string v0, ""

    return-object v0

    .line 617
    :cond_2
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 618
    .local v0, "s":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->pos:I

    int-to-long v1, v1

    add-long/2addr v1, p1

    iget v3, v0, Lokio/Segment;->limit:I

    int-to-long v3, v3

    cmp-long v1, v1, v3

    if-lez v1, :cond_3

    .line 620
    new-instance v1, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->readByteArray(J)[B

    move-result-object v2

    invoke-direct {v1, v2, p3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    return-object v1

    .line 623
    :cond_3
    new-instance v1, Ljava/lang/String;

    iget-object v2, v0, Lokio/Segment;->data:[B

    iget v3, v0, Lokio/Segment;->pos:I

    long-to-int v4, p1

    invoke-direct {v1, v2, v3, v4, p3}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    .line 624
    .local v1, "result":Ljava/lang/String;
    iget v2, v0, Lokio/Segment;->pos:I

    int-to-long v2, v2

    add-long/2addr v2, p1

    long-to-int v2, v2

    iput v2, v0, Lokio/Segment;->pos:I

    .line 625
    iget-wide v2, p0, Lokio/Buffer;->size:J

    sub-long/2addr v2, p1

    iput-wide v2, p0, Lokio/Buffer;->size:J

    .line 627
    iget v2, v0, Lokio/Segment;->pos:I

    iget v3, v0, Lokio/Segment;->limit:I

    if-ne v2, v3, :cond_4

    .line 628
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 629
    invoke-static {v0}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    .line 632
    :cond_4
    return-object v1
.end method

.method public readString(Ljava/nio/charset/Charset;)Ljava/lang/String;
    .locals 2
    .param p1, "charset"    # Ljava/nio/charset/Charset;

    .line 603
    :try_start_0
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {p0, v0, v1, p1}, Lokio/Buffer;->readString(JLjava/nio/charset/Charset;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/EOFException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 604
    :catch_0
    move-exception v0

    .line 605
    .local v0, "e":Ljava/io/EOFException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1, v0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v1
.end method

.method public readUtf8()Ljava/lang/String;
    .locals 3

    .line 591
    :try_start_0
    iget-wide v0, p0, Lokio/Buffer;->size:J

    sget-object v2, Lokio/Util;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p0, v0, v1, v2}, Lokio/Buffer;->readString(JLjava/nio/charset/Charset;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/EOFException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 592
    :catch_0
    move-exception v0

    .line 593
    .local v0, "e":Ljava/io/EOFException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1, v0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v1
.end method

.method public readUtf8(J)Ljava/lang/String;
    .locals 1
    .param p1, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 598
    sget-object v0, Lokio/Util;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p0, p1, p2, v0}, Lokio/Buffer;->readString(JLjava/nio/charset/Charset;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public readUtf8CodePoint()I
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 680
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    .line 682
    :cond_0
    invoke-virtual {p0, v2, v3}, Lokio/Buffer;->getByte(J)B

    move-result v0

    .line 687
    .local v0, "b0":B
    and-int/lit16 v1, v0, 0x80

    const v2, 0xfffd

    if-nez v1, :cond_1

    .line 689
    and-int/lit8 v1, v0, 0x7f

    .line 690
    .local v1, "codePoint":I
    const/4 v3, 0x1

    .line 691
    .local v3, "byteCount":I
    const/4 v4, 0x0

    .line 691
    .local v4, "min":I
    :goto_0
    goto :goto_1

    .line 693
    .end local v1    # "codePoint":I
    .end local v3    # "byteCount":I
    .end local v4    # "min":I
    :cond_1
    and-int/lit16 v1, v0, 0xe0

    const/16 v3, 0xc0

    if-ne v1, v3, :cond_2

    .line 695
    and-int/lit8 v1, v0, 0x1f

    .line 696
    .restart local v1    # "codePoint":I
    const/4 v3, 0x2

    .line 697
    .restart local v3    # "byteCount":I
    const/16 v4, 0x80

    goto :goto_0

    .line 699
    .end local v1    # "codePoint":I
    .end local v3    # "byteCount":I
    :cond_2
    and-int/lit16 v1, v0, 0xf0

    const/16 v3, 0xe0

    if-ne v1, v3, :cond_3

    .line 701
    and-int/lit8 v1, v0, 0xf

    .line 702
    .restart local v1    # "codePoint":I
    const/4 v3, 0x3

    .line 703
    .restart local v3    # "byteCount":I
    const/16 v4, 0x800

    goto :goto_0

    .line 705
    .end local v1    # "codePoint":I
    .end local v3    # "byteCount":I
    :cond_3
    and-int/lit16 v1, v0, 0xf8

    const/16 v3, 0xf0

    if-ne v1, v3, :cond_a

    .line 707
    and-int/lit8 v1, v0, 0x7

    .line 708
    .restart local v1    # "codePoint":I
    const/4 v3, 0x4

    .line 709
    .restart local v3    # "byteCount":I
    const/high16 v4, 0x10000

    goto :goto_0

    .line 714
    .restart local v4    # "min":I
    :goto_1
    nop

    .line 717
    iget-wide v5, p0, Lokio/Buffer;->size:J

    int-to-long v7, v3

    cmp-long v5, v5, v7

    if-gez v5, :cond_4

    .line 718
    new-instance v2, Ljava/io/EOFException;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "size < "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, ": "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v6, p0, Lokio/Buffer;->size:J

    invoke-virtual {v5, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v6, " (to read code point prefixed 0x"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 719
    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ")"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v2, v5}, Ljava/io/EOFException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 725
    :cond_4
    const/4 v5, 0x1

    .line 725
    .local v5, "i":I
    :goto_2
    if-ge v5, v3, :cond_6

    .line 726
    int-to-long v6, v5

    invoke-virtual {p0, v6, v7}, Lokio/Buffer;->getByte(J)B

    move-result v6

    .line 727
    .local v6, "b":B
    and-int/lit16 v7, v6, 0xc0

    const/16 v8, 0x80

    if-ne v7, v8, :cond_5

    .line 729
    shl-int/lit8 v1, v1, 0x6

    .line 730
    and-int/lit8 v7, v6, 0x3f

    or-int/2addr v1, v7

    .line 725
    .end local v6    # "b":B
    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 732
    .restart local v6    # "b":B
    :cond_5
    int-to-long v7, v5

    invoke-virtual {p0, v7, v8}, Lokio/Buffer;->skip(J)V

    .line 733
    return v2

    .line 737
    .end local v5    # "i":I
    .end local v6    # "b":B
    :cond_6
    int-to-long v5, v3

    invoke-virtual {p0, v5, v6}, Lokio/Buffer;->skip(J)V

    .line 739
    const v5, 0x10ffff

    if-le v1, v5, :cond_7

    .line 740
    return v2

    .line 743
    :cond_7
    const v5, 0xd800

    if-lt v1, v5, :cond_8

    const v5, 0xdfff

    if-gt v1, v5, :cond_8

    .line 744
    return v2

    .line 747
    :cond_8
    if-ge v1, v4, :cond_9

    .line 748
    return v2

    .line 751
    :cond_9
    return v1

    .line 713
    .end local v1    # "codePoint":I
    .end local v3    # "byteCount":I
    .end local v4    # "min":I
    :cond_a
    const-wide/16 v3, 0x1

    invoke-virtual {p0, v3, v4}, Lokio/Buffer;->skip(J)V

    .line 714
    return v2
.end method

.method public readUtf8Line()Ljava/lang/String;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .annotation runtime Ljavax/annotation/Nullable;
    .end annotation

    .line 636
    const/16 v0, 0xa

    invoke-virtual {p0, v0}, Lokio/Buffer;->indexOf(B)J

    move-result-wide v0

    .line 638
    .local v0, "newline":J
    const-wide/16 v2, -0x1

    cmp-long v2, v0, v2

    if-nez v2, :cond_1

    .line 639
    iget-wide v2, p0, Lokio/Buffer;->size:J

    const-wide/16 v4, 0x0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_0

    iget-wide v2, p0, Lokio/Buffer;->size:J

    invoke-virtual {p0, v2, v3}, Lokio/Buffer;->readUtf8(J)Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    :goto_0
    return-object v2

    .line 642
    :cond_1
    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->readUtf8Line(J)Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method readUtf8Line(J)Ljava/lang/String;
    .locals 5
    .param p1, "newline"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 665
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    const-wide/16 v1, 0x1

    if-lez v0, :cond_0

    sub-long v3, p1, v1

    invoke-virtual {p0, v3, v4}, Lokio/Buffer;->getByte(J)B

    move-result v0

    const/16 v3, 0xd

    if-ne v0, v3, :cond_0

    .line 667
    sub-long v0, p1, v1

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->readUtf8(J)Ljava/lang/String;

    move-result-object v0

    .line 668
    .local v0, "result":Ljava/lang/String;
    const-wide/16 v1, 0x2

    invoke-virtual {p0, v1, v2}, Lokio/Buffer;->skip(J)V

    .line 669
    return-object v0

    .line 673
    .end local v0    # "result":Ljava/lang/String;
    :cond_0
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->readUtf8(J)Ljava/lang/String;

    move-result-object v0

    .line 674
    .restart local v0    # "result":Ljava/lang/String;
    invoke-virtual {p0, v1, v2}, Lokio/Buffer;->skip(J)V

    .line 675
    return-object v0
.end method

.method public readUtf8LineStrict()Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 646
    const-wide v0, 0x7fffffffffffffffL

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->readUtf8LineStrict(J)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public readUtf8LineStrict(J)Ljava/lang/String;
    .locals 13
    .param p1, "limit"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 650
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-gez v0, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "limit < 0: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 651
    :cond_0
    const-wide v0, 0x7fffffffffffffffL

    cmp-long v2, p1, v0

    const-wide/16 v3, 0x1

    if-nez v2, :cond_1

    goto :goto_0

    :cond_1
    add-long v0, p1, v3

    .line 652
    .local v0, "scanLength":J
    :goto_0
    const/16 v6, 0xa

    const-wide/16 v7, 0x0

    move-object v5, p0

    move-wide v9, v0

    invoke-virtual/range {v5 .. v10}, Lokio/Buffer;->indexOf(BJJ)J

    move-result-wide v5

    .line 653
    .local v5, "newline":J
    const-wide/16 v7, -0x1

    cmp-long v2, v5, v7

    if-eqz v2, :cond_2

    invoke-virtual {p0, v5, v6}, Lokio/Buffer;->readUtf8Line(J)Ljava/lang/String;

    move-result-object v2

    return-object v2

    .line 654
    :cond_2
    invoke-virtual {p0}, Lokio/Buffer;->size()J

    move-result-wide v7

    cmp-long v2, v0, v7

    if-gez v2, :cond_3

    sub-long v2, v0, v3

    .line 655
    invoke-virtual {p0, v2, v3}, Lokio/Buffer;->getByte(J)B

    move-result v2

    const/16 v3, 0xd

    if-ne v2, v3, :cond_3

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->getByte(J)B

    move-result v2

    const/16 v3, 0xa

    if-ne v2, v3, :cond_3

    .line 656
    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->readUtf8Line(J)Ljava/lang/String;

    move-result-object v2

    return-object v2

    .line 658
    :cond_3
    new-instance v2, Lokio/Buffer;

    invoke-direct {v2}, Lokio/Buffer;-><init>()V

    .line 659
    .local v2, "data":Lokio/Buffer;
    const-wide/16 v9, 0x0

    const-wide/16 v3, 0x20

    invoke-virtual {p0}, Lokio/Buffer;->size()J

    move-result-wide v7

    invoke-static {v3, v4, v7, v8}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v11

    move-object v7, p0

    move-object v8, v2

    invoke-virtual/range {v7 .. v12}, Lokio/Buffer;->copyTo(Lokio/Buffer;JJ)Lokio/Buffer;

    .line 660
    new-instance v3, Ljava/io/EOFException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "\\n not found: limit="

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lokio/Buffer;->size()J

    move-result-wide v7

    invoke-static {v7, v8, p1, p2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    invoke-virtual {v4, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v7, " content="

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 661
    invoke-virtual {v2}, Lokio/Buffer;->readByteString()Lokio/ByteString;

    move-result-object v7

    invoke-virtual {v7}, Lokio/ByteString;->hex()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v7, 0x2026

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/io/EOFException;-><init>(Ljava/lang/String;)V

    throw v3
.end method

.method public request(J)Z
    .locals 2
    .param p1, "byteCount"    # J

    .line 110
    iget-wide v0, p0, Lokio/Buffer;->size:J

    cmp-long v0, v0, p1

    if-ltz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public require(J)V
    .locals 2
    .param p1, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 106
    iget-wide v0, p0, Lokio/Buffer;->size:J

    cmp-long v0, v0, p1

    if-gez v0, :cond_0

    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    .line 107
    :cond_0
    return-void
.end method

.method segmentSizes()Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 1539
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 1540
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1541
    .local v0, "result":Ljava/util/List;, "Ljava/util/List<Ljava/lang/Integer;>;"
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v1, v1, Lokio/Segment;->limit:I

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v2, v2, Lokio/Segment;->pos:I

    sub-int/2addr v1, v2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1542
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1542
    .local v1, "s":Lokio/Segment;
    :goto_0
    iget-object v1, v1, Lokio/Segment;->next:Lokio/Segment;

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eq v1, v2, :cond_1

    .line 1543
    iget v2, v1, Lokio/Segment;->limit:I

    iget v3, v1, Lokio/Segment;->pos:I

    sub-int/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1542
    goto :goto_0

    .line 1545
    .end local v1    # "s":Lokio/Segment;
    :cond_1
    return-object v0
.end method

.method public select(Lokio/Options;)I
    .locals 11
    .param p1, "options"    # Lokio/Options;

    .line 537
    iget-object v6, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 538
    .local v6, "s":Lokio/Segment;
    if-nez v6, :cond_0

    sget-object v0, Lokio/ByteString;->EMPTY:Lokio/ByteString;

    invoke-virtual {p1, v0}, Lokio/Options;->indexOf(Ljava/lang/Object;)I

    move-result v0

    return v0

    .line 540
    :cond_0
    iget-object v7, p1, Lokio/Options;->byteStrings:[Lokio/ByteString;

    .line 541
    .local v7, "byteStrings":[Lokio/ByteString;
    const/4 v0, 0x0

    .line 541
    .local v0, "i":I
    array-length v1, v7

    move v8, v0

    .line 541
    .end local v0    # "i":I
    .local v1, "listSize":I
    .local v8, "i":I
    :goto_0
    move v9, v1

    .line 541
    .end local v1    # "listSize":I
    .local v9, "listSize":I
    if-ge v8, v9, :cond_2

    .line 542
    aget-object v10, v7, v8

    .line 543
    .local v10, "b":Lokio/ByteString;
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {v10}, Lokio/ByteString;->size()I

    move-result v2

    int-to-long v2, v2

    cmp-long v0, v0, v2

    if-ltz v0, :cond_1

    iget v2, v6, Lokio/Segment;->pos:I

    const/4 v4, 0x0

    invoke-virtual {v10}, Lokio/ByteString;->size()I

    move-result v5

    move-object v0, p0

    move-object v1, v6

    move-object v3, v10

    invoke-direct/range {v0 .. v5}, Lokio/Buffer;->rangeEquals(Lokio/Segment;ILokio/ByteString;II)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 545
    :try_start_0
    invoke-virtual {v10}, Lokio/ByteString;->size()I

    move-result v0

    int-to-long v0, v0

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->skip(J)V
    :try_end_0
    .catch Ljava/io/EOFException; {:try_start_0 .. :try_end_0} :catch_0

    .line 546
    return v8

    .line 547
    :catch_0
    move-exception v0

    .line 548
    .local v0, "e":Ljava/io/EOFException;
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1, v0}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v1

    .line 541
    .end local v0    # "e":Ljava/io/EOFException;
    .end local v10    # "b":Lokio/ByteString;
    :cond_1
    add-int/lit8 v8, v8, 0x1

    move v1, v9

    goto :goto_0

    .line 552
    .end local v8    # "i":I
    .end local v9    # "listSize":I
    :cond_2
    const/4 v0, -0x1

    return v0
.end method

.method selectPrefix(Lokio/Options;)I
    .locals 12
    .param p1, "options"    # Lokio/Options;

    .line 561
    iget-object v6, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 562
    .local v6, "s":Lokio/Segment;
    iget-object v7, p1, Lokio/Options;->byteStrings:[Lokio/ByteString;

    .line 563
    .local v7, "byteStrings":[Lokio/ByteString;
    const/4 v0, 0x0

    .line 563
    .local v0, "i":I
    array-length v1, v7

    move v8, v0

    .line 563
    .end local v0    # "i":I
    .local v1, "listSize":I
    .local v8, "i":I
    :goto_0
    move v9, v1

    .line 563
    .end local v1    # "listSize":I
    .local v9, "listSize":I
    if-ge v8, v9, :cond_2

    .line 564
    aget-object v10, v7, v8

    .line 565
    .local v10, "b":Lokio/ByteString;
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {v10}, Lokio/ByteString;->size()I

    move-result v2

    int-to-long v2, v2

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int v11, v0

    .line 566
    .local v11, "bytesLimit":I
    if-eqz v11, :cond_1

    iget v2, v6, Lokio/Segment;->pos:I

    const/4 v4, 0x0

    move-object v0, p0

    move-object v1, v6

    move-object v3, v10

    move v5, v11

    invoke-direct/range {v0 .. v5}, Lokio/Buffer;->rangeEquals(Lokio/Segment;ILokio/ByteString;II)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_1

    .line 563
    .end local v10    # "b":Lokio/ByteString;
    .end local v11    # "bytesLimit":I
    :cond_0
    add-int/lit8 v8, v8, 0x1

    move v1, v9

    goto :goto_0

    .line 567
    .restart local v10    # "b":Lokio/ByteString;
    .restart local v11    # "bytesLimit":I
    :cond_1
    :goto_1
    return v8

    .line 570
    .end local v8    # "i":I
    .end local v9    # "listSize":I
    .end local v10    # "b":Lokio/ByteString;
    .end local v11    # "bytesLimit":I
    :cond_2
    const/4 v0, -0x1

    return v0
.end method

.method public sha1()Lokio/ByteString;
    .locals 1

    .line 1555
    const-string v0, "SHA-1"

    invoke-direct {p0, v0}, Lokio/Buffer;->digest(Ljava/lang/String;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public sha256()Lokio/ByteString;
    .locals 1

    .line 1560
    const-string v0, "SHA-256"

    invoke-direct {p0, v0}, Lokio/Buffer;->digest(Ljava/lang/String;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public sha512()Lokio/ByteString;
    .locals 1

    .line 1565
    const-string v0, "SHA-512"

    invoke-direct {p0, v0}, Lokio/Buffer;->digest(Ljava/lang/String;)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public size()J
    .locals 2

    .line 64
    iget-wide v0, p0, Lokio/Buffer;->size:J

    return-wide v0
.end method

.method public skip(J)V
    .locals 5
    .param p1, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/EOFException;
        }
    .end annotation

    .line 819
    :goto_0
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-lez v0, :cond_2

    .line 820
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v0, :cond_0

    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    .line 822
    :cond_0
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v0, v0, Lokio/Segment;->limit:I

    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v1, v1, Lokio/Segment;->pos:I

    sub-int/2addr v0, v1

    int-to-long v0, v0

    invoke-static {p1, p2, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int v0, v0

    .line 823
    .local v0, "toSkip":I
    iget-wide v1, p0, Lokio/Buffer;->size:J

    int-to-long v3, v0

    sub-long/2addr v1, v3

    iput-wide v1, p0, Lokio/Buffer;->size:J

    .line 824
    int-to-long v1, v0

    sub-long/2addr p1, v1

    .line 825
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v2, v1, Lokio/Segment;->pos:I

    add-int/2addr v2, v0

    iput v2, v1, Lokio/Segment;->pos:I

    .line 827
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v1, v1, Lokio/Segment;->pos:I

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget v2, v2, Lokio/Segment;->limit:I

    if-ne v1, v2, :cond_1

    .line 828
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 829
    .local v1, "toRecycle":Lokio/Segment;
    invoke-virtual {v1}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v2

    iput-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 830
    invoke-static {v1}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    .line 832
    .end local v0    # "toSkip":I
    .end local v1    # "toRecycle":Lokio/Segment;
    :cond_1
    goto :goto_0

    .line 833
    :cond_2
    return-void
.end method

.method public snapshot()Lokio/ByteString;
    .locals 4

    .line 1686
    iget-wide v0, p0, Lokio/Buffer;->size:J

    const-wide/32 v2, 0x7fffffff

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    .line 1687
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "size > Integer.MAX_VALUE: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lokio/Buffer;->size:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1689
    :cond_0
    iget-wide v0, p0, Lokio/Buffer;->size:J

    long-to-int v0, v0

    invoke-virtual {p0, v0}, Lokio/Buffer;->snapshot(I)Lokio/ByteString;

    move-result-object v0

    return-object v0
.end method

.method public snapshot(I)Lokio/ByteString;
    .locals 1
    .param p1, "byteCount"    # I

    .line 1696
    if-nez p1, :cond_0

    sget-object v0, Lokio/ByteString;->EMPTY:Lokio/ByteString;

    return-object v0

    .line 1697
    :cond_0
    new-instance v0, Lokio/SegmentedByteString;

    invoke-direct {v0, p0, p1}, Lokio/SegmentedByteString;-><init>(Lokio/Buffer;I)V

    return-object v0
.end method

.method public timeout()Lokio/Timeout;
    .locals 1

    .line 1534
    sget-object v0, Lokio/Timeout;->NONE:Lokio/Timeout;

    return-object v0
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 1667
    invoke-virtual {p0}, Lokio/Buffer;->snapshot()Lokio/ByteString;

    move-result-object v0

    invoke-virtual {v0}, Lokio/ByteString;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method writableSegment(I)Lokio/Segment;
    .locals 3
    .param p1, "minimumCapacity"    # I

    .line 1160
    const/4 v0, 0x1

    if-lt p1, v0, :cond_4

    const/16 v0, 0x2000

    if-le p1, v0, :cond_0

    goto :goto_0

    .line 1162
    :cond_0
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v1, :cond_1

    .line 1163
    invoke-static {}, Lokio/SegmentPool;->take()Lokio/Segment;

    move-result-object v0

    iput-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1164
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v2, p0, Lokio/Buffer;->head:Lokio/Segment;

    iput-object v2, v1, Lokio/Segment;->prev:Lokio/Segment;

    iput-object v2, v0, Lokio/Segment;->next:Lokio/Segment;

    return-object v2

    .line 1167
    :cond_1
    iget-object v1, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v1, v1, Lokio/Segment;->prev:Lokio/Segment;

    .line 1168
    .local v1, "tail":Lokio/Segment;
    iget v2, v1, Lokio/Segment;->limit:I

    add-int/2addr v2, p1

    if-gt v2, v0, :cond_2

    iget-boolean v0, v1, Lokio/Segment;->owner:Z

    if-nez v0, :cond_3

    .line 1169
    :cond_2
    invoke-static {}, Lokio/SegmentPool;->take()Lokio/Segment;

    move-result-object v0

    invoke-virtual {v1, v0}, Lokio/Segment;->push(Lokio/Segment;)Lokio/Segment;

    move-result-object v1

    .line 1171
    :cond_3
    return-object v1

    .line 1160
    .end local v1    # "tail":Lokio/Segment;
    :cond_4
    :goto_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    invoke-direct {v0}, Ljava/lang/IllegalArgumentException;-><init>()V

    throw v0
.end method

.method public write(Lokio/ByteString;)Lokio/Buffer;
    .locals 2
    .param p1, "byteString"    # Lokio/ByteString;

    .line 836
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "byteString == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 837
    :cond_0
    invoke-virtual {p1, p0}, Lokio/ByteString;->write(Lokio/Buffer;)V

    .line 838
    return-object p0
.end method

.method public write([B)Lokio/Buffer;
    .locals 2
    .param p1, "source"    # [B

    .line 979
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "source == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 980
    :cond_0
    const/4 v0, 0x0

    array-length v1, p1

    invoke-virtual {p0, p1, v0, v1}, Lokio/Buffer;->write([BII)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public write([BII)Lokio/Buffer;
    .locals 7
    .param p1, "source"    # [B
    .param p2, "offset"    # I
    .param p3, "byteCount"    # I

    .line 984
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "source == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 985
    :cond_0
    array-length v0, p1

    int-to-long v1, v0

    int-to-long v3, p2

    int-to-long v5, p3

    invoke-static/range {v1 .. v6}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 987
    add-int v0, p2, p3

    .line 988
    .local v0, "limit":I
    :goto_0
    if-ge p2, v0, :cond_1

    .line 989
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v1

    .line 991
    .local v1, "tail":Lokio/Segment;
    sub-int v2, v0, p2

    iget v3, v1, Lokio/Segment;->limit:I

    rsub-int v3, v3, 0x2000

    invoke-static {v2, v3}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 992
    .local v2, "toCopy":I
    iget-object v3, v1, Lokio/Segment;->data:[B

    iget v4, v1, Lokio/Segment;->limit:I

    invoke-static {p1, p2, v3, v4, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 994
    add-int/2addr p2, v2

    .line 995
    iget v3, v1, Lokio/Segment;->limit:I

    add-int/2addr v3, v2

    iput v3, v1, Lokio/Segment;->limit:I

    .line 996
    .end local v1    # "tail":Lokio/Segment;
    .end local v2    # "toCopy":I
    goto :goto_0

    .line 998
    :cond_1
    iget-wide v1, p0, Lokio/Buffer;->size:J

    int-to-long v3, p3

    add-long/2addr v1, v3

    iput-wide v1, p0, Lokio/Buffer;->size:J

    .line 999
    return-object p0
.end method

.method public bridge synthetic write(Lokio/ByteString;)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->write(Lokio/ByteString;)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public write(Lokio/Source;J)Lokio/BufferedSink;
    .locals 4
    .param p1, "source"    # Lokio/Source;
    .param p2, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1012
    :goto_0
    const-wide/16 v0, 0x0

    cmp-long v0, p2, v0

    if-lez v0, :cond_1

    .line 1013
    invoke-interface {p1, p0, p2, p3}, Lokio/Source;->read(Lokio/Buffer;J)J

    move-result-wide v0

    .line 1014
    .local v0, "read":J
    const-wide/16 v2, -0x1

    cmp-long v2, v0, v2

    if-nez v2, :cond_0

    new-instance v2, Ljava/io/EOFException;

    invoke-direct {v2}, Ljava/io/EOFException;-><init>()V

    throw v2

    .line 1015
    :cond_0
    sub-long/2addr p2, v0

    .line 1016
    .end local v0    # "read":J
    goto :goto_0

    .line 1017
    :cond_1
    return-object p0
.end method

.method public bridge synthetic write([B)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->write([B)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public bridge synthetic write([BII)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2, p3}, Lokio/Buffer;->write([BII)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public write(Lokio/Buffer;J)V
    .locals 8
    .param p1, "source"    # Lokio/Buffer;
    .param p2, "byteCount"    # J

    .line 1225
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "source == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1226
    :cond_0
    if-ne p1, p0, :cond_1

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "source == this"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1227
    :cond_1
    iget-wide v2, p1, Lokio/Buffer;->size:J

    const-wide/16 v4, 0x0

    move-wide v6, p2

    invoke-static/range {v2 .. v7}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 1229
    :goto_0
    const-wide/16 v0, 0x0

    cmp-long v0, p2, v0

    if-lez v0, :cond_7

    .line 1231
    iget-object v0, p1, Lokio/Buffer;->head:Lokio/Segment;

    iget v0, v0, Lokio/Segment;->limit:I

    iget-object v1, p1, Lokio/Buffer;->head:Lokio/Segment;

    iget v1, v1, Lokio/Segment;->pos:I

    sub-int/2addr v0, v1

    int-to-long v0, v0

    cmp-long v0, p2, v0

    if-gez v0, :cond_5

    .line 1232
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v0, v0, Lokio/Segment;->prev:Lokio/Segment;

    goto :goto_1

    :cond_2
    const/4 v0, 0x0

    .line 1233
    .local v0, "tail":Lokio/Segment;
    :goto_1
    if-eqz v0, :cond_4

    iget-boolean v1, v0, Lokio/Segment;->owner:Z

    if-eqz v1, :cond_4

    iget v1, v0, Lokio/Segment;->limit:I

    int-to-long v1, v1

    add-long/2addr v1, p2

    iget-boolean v3, v0, Lokio/Segment;->shared:Z

    if-eqz v3, :cond_3

    .line 1234
    const/4 v3, 0x0

    goto :goto_2

    :cond_3
    iget v3, v0, Lokio/Segment;->pos:I

    :goto_2
    int-to-long v3, v3

    sub-long/2addr v1, v3

    const-wide/16 v3, 0x2000

    cmp-long v1, v1, v3

    if-gtz v1, :cond_4

    .line 1236
    iget-object v1, p1, Lokio/Buffer;->head:Lokio/Segment;

    long-to-int v2, p2

    invoke-virtual {v1, v0, v2}, Lokio/Segment;->writeTo(Lokio/Segment;I)V

    .line 1237
    iget-wide v1, p1, Lokio/Buffer;->size:J

    sub-long/2addr v1, p2

    iput-wide v1, p1, Lokio/Buffer;->size:J

    .line 1238
    iget-wide v1, p0, Lokio/Buffer;->size:J

    add-long/2addr v1, p2

    iput-wide v1, p0, Lokio/Buffer;->size:J

    .line 1239
    return-void

    .line 1243
    :cond_4
    iget-object v1, p1, Lokio/Buffer;->head:Lokio/Segment;

    long-to-int v2, p2

    invoke-virtual {v1, v2}, Lokio/Segment;->split(I)Lokio/Segment;

    move-result-object v1

    iput-object v1, p1, Lokio/Buffer;->head:Lokio/Segment;

    .line 1248
    .end local v0    # "tail":Lokio/Segment;
    :cond_5
    iget-object v0, p1, Lokio/Buffer;->head:Lokio/Segment;

    .line 1249
    .local v0, "segmentToMove":Lokio/Segment;
    iget v1, v0, Lokio/Segment;->limit:I

    iget v2, v0, Lokio/Segment;->pos:I

    sub-int/2addr v1, v2

    int-to-long v1, v1

    .line 1250
    .local v1, "movedByteCount":J
    invoke-virtual {v0}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v3

    iput-object v3, p1, Lokio/Buffer;->head:Lokio/Segment;

    .line 1251
    iget-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    if-nez v3, :cond_6

    .line 1252
    iput-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 1253
    iget-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v4, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v5, p0, Lokio/Buffer;->head:Lokio/Segment;

    iput-object v5, v4, Lokio/Segment;->prev:Lokio/Segment;

    iput-object v5, v3, Lokio/Segment;->next:Lokio/Segment;

    goto :goto_3

    .line 1255
    :cond_6
    iget-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    iget-object v3, v3, Lokio/Segment;->prev:Lokio/Segment;

    .line 1256
    .local v3, "tail":Lokio/Segment;
    invoke-virtual {v3, v0}, Lokio/Segment;->push(Lokio/Segment;)Lokio/Segment;

    move-result-object v3

    .line 1257
    invoke-virtual {v3}, Lokio/Segment;->compact()V

    .line 1259
    .end local v3    # "tail":Lokio/Segment;
    :goto_3
    iget-wide v3, p1, Lokio/Buffer;->size:J

    sub-long/2addr v3, v1

    iput-wide v3, p1, Lokio/Buffer;->size:J

    .line 1260
    iget-wide v3, p0, Lokio/Buffer;->size:J

    add-long/2addr v3, v1

    iput-wide v3, p0, Lokio/Buffer;->size:J

    .line 1261
    sub-long/2addr p2, v1

    .line 1262
    .end local v0    # "segmentToMove":Lokio/Segment;
    .end local v1    # "movedByteCount":J
    goto/16 :goto_0

    .line 1263
    :cond_7
    return-void
.end method

.method public writeAll(Lokio/Source;)J
    .locals 8
    .param p1, "source"    # Lokio/Source;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1003
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "source == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1004
    :cond_0
    const-wide/16 v0, 0x0

    .line 1005
    .local v0, "totalBytesRead":J
    :goto_0
    const-wide/16 v2, 0x2000

    invoke-interface {p1, p0, v2, v3}, Lokio/Source;->read(Lokio/Buffer;J)J

    move-result-wide v2

    move-wide v4, v2

    .line 1005
    .local v4, "readCount":J
    const-wide/16 v6, -0x1

    cmp-long v2, v2, v6

    if-eqz v2, :cond_1

    .line 1006
    add-long/2addr v0, v4

    goto :goto_0

    .line 1008
    .end local v4    # "readCount":J
    :cond_1
    return-wide v0
.end method

.method public writeByte(I)Lokio/Buffer;
    .locals 5
    .param p1, "b"    # I

    .line 1021
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v0

    .line 1022
    .local v0, "tail":Lokio/Segment;
    iget-object v1, v0, Lokio/Segment;->data:[B

    iget v2, v0, Lokio/Segment;->limit:I

    add-int/lit8 v3, v2, 0x1

    iput v3, v0, Lokio/Segment;->limit:I

    int-to-byte v3, p1

    aput-byte v3, v1, v2

    .line 1023
    iget-wide v1, p0, Lokio/Buffer;->size:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lokio/Buffer;->size:J

    .line 1024
    return-object p0
.end method

.method public bridge synthetic writeByte(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeDecimalLong(J)Lokio/Buffer;
    .locals 11
    .param p1, "v"    # J

    .line 1081
    const-wide/16 v0, 0x0

    cmp-long v2, p1, v0

    if-nez v2, :cond_0

    .line 1083
    const/16 v0, 0x30

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    move-result-object v0

    return-object v0

    .line 1086
    :cond_0
    const/4 v2, 0x0

    .line 1087
    .local v2, "negative":Z
    cmp-long v3, p1, v0

    if-gez v3, :cond_2

    .line 1088
    neg-long p1, p1

    .line 1089
    cmp-long v3, p1, v0

    if-gez v3, :cond_1

    .line 1090
    const-string v0, "-9223372036854775808"

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeUtf8(Ljava/lang/String;)Lokio/Buffer;

    move-result-object v0

    return-object v0

    .line 1092
    :cond_1
    const/4 v2, 0x1

    .line 1096
    :cond_2
    const-wide/32 v3, 0x5f5e100

    cmp-long v3, p1, v3

    const-wide/16 v4, 0xa

    if-gez v3, :cond_a

    .line 1099
    const-wide/16 v6, 0x2710

    cmp-long v3, p1, v6

    if-gez v3, :cond_6

    .line 1100
    const-wide/16 v6, 0x64

    cmp-long v3, p1, v6

    if-gez v3, :cond_4

    cmp-long v3, p1, v4

    if-gez v3, :cond_3

    .line 1114
    const/4 v3, 0x1

    goto/16 :goto_0

    .line 1100
    :cond_3
    const/4 v3, 0x2

    goto/16 :goto_0

    .line 1101
    :cond_4
    const-wide/16 v6, 0x3e8

    cmp-long v3, p1, v6

    if-gez v3, :cond_5

    const/4 v3, 0x3

    goto/16 :goto_0

    :cond_5
    const/4 v3, 0x4

    goto/16 :goto_0

    .line 1103
    :cond_6
    const-wide/32 v6, 0xf4240

    cmp-long v3, p1, v6

    if-gez v3, :cond_8

    const-wide/32 v6, 0x186a0

    cmp-long v3, p1, v6

    if-gez v3, :cond_7

    const/4 v3, 0x5

    goto/16 :goto_0

    :cond_7
    const/4 v3, 0x6

    goto/16 :goto_0

    .line 1104
    :cond_8
    const-wide/32 v6, 0x989680

    cmp-long v3, p1, v6

    if-gez v3, :cond_9

    const/4 v3, 0x7

    goto/16 :goto_0

    :cond_9
    const/16 v3, 0x8

    goto/16 :goto_0

    .line 1106
    :cond_a
    const-wide v6, 0xe8d4a51000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_e

    .line 1107
    const-wide v6, 0x2540be400L

    cmp-long v3, p1, v6

    if-gez v3, :cond_c

    const-wide/32 v6, 0x3b9aca00

    cmp-long v3, p1, v6

    if-gez v3, :cond_b

    const/16 v3, 0x9

    goto :goto_0

    :cond_b
    const/16 v3, 0xa

    goto :goto_0

    .line 1108
    :cond_c
    const-wide v6, 0x174876e800L

    cmp-long v3, p1, v6

    if-gez v3, :cond_d

    const/16 v3, 0xb

    goto :goto_0

    :cond_d
    const/16 v3, 0xc

    goto :goto_0

    .line 1110
    :cond_e
    const-wide v6, 0x38d7ea4c68000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_11

    const-wide v6, 0x9184e72a000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_f

    const/16 v3, 0xd

    goto :goto_0

    .line 1111
    :cond_f
    const-wide v6, 0x5af3107a4000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_10

    const/16 v3, 0xe

    goto :goto_0

    :cond_10
    const/16 v3, 0xf

    goto :goto_0

    .line 1113
    :cond_11
    const-wide v6, 0x16345785d8a0000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_13

    const-wide v6, 0x2386f26fc10000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_12

    const/16 v3, 0x10

    goto :goto_0

    :cond_12
    const/16 v3, 0x11

    goto :goto_0

    .line 1114
    :cond_13
    const-wide v6, 0xde0b6b3a7640000L

    cmp-long v3, p1, v6

    if-gez v3, :cond_14

    const/16 v3, 0x12

    goto :goto_0

    :cond_14
    const/16 v3, 0x13

    .line 1115
    .local v3, "width":I
    :goto_0
    if-eqz v2, :cond_15

    .line 1116
    add-int/lit8 v3, v3, 0x1

    .line 1119
    :cond_15
    invoke-virtual {p0, v3}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v6

    .line 1120
    .local v6, "tail":Lokio/Segment;
    iget-object v7, v6, Lokio/Segment;->data:[B

    .line 1121
    .local v7, "data":[B
    iget v8, v6, Lokio/Segment;->limit:I

    add-int/2addr v8, v3

    .line 1122
    .local v8, "pos":I
    :goto_1
    cmp-long v9, p1, v0

    if-eqz v9, :cond_16

    .line 1123
    rem-long v9, p1, v4

    long-to-int v9, v9

    .line 1124
    .local v9, "digit":I
    add-int/lit8 v8, v8, -0x1

    sget-object v10, Lokio/Buffer;->DIGITS:[B

    aget-byte v10, v10, v9

    aput-byte v10, v7, v8

    .line 1125
    div-long/2addr p1, v4

    .line 1126
    .end local v9    # "digit":I
    goto :goto_1

    .line 1127
    :cond_16
    if-eqz v2, :cond_17

    .line 1128
    add-int/lit8 v8, v8, -0x1

    const/16 v0, 0x2d

    aput-byte v0, v7, v8

    .line 1131
    :cond_17
    iget v0, v6, Lokio/Segment;->limit:I

    add-int/2addr v0, v3

    iput v0, v6, Lokio/Segment;->limit:I

    .line 1132
    iget-wide v0, p0, Lokio/Buffer;->size:J

    int-to-long v4, v3

    add-long/2addr v0, v4

    iput-wide v0, p0, Lokio/Buffer;->size:J

    .line 1133
    return-object p0
.end method

.method public bridge synthetic writeDecimalLong(J)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->writeDecimalLong(J)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeHexadecimalUnsignedLong(J)Lokio/Buffer;
    .locals 9
    .param p1, "v"    # J

    .line 1137
    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-nez v0, :cond_0

    .line 1139
    const/16 v0, 0x30

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    move-result-object v0

    return-object v0

    .line 1142
    :cond_0
    invoke-static {p1, p2}, Ljava/lang/Long;->highestOneBit(J)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->numberOfTrailingZeros(J)I

    move-result v0

    const/4 v1, 0x4

    div-int/2addr v0, v1

    add-int/lit8 v0, v0, 0x1

    .line 1144
    .local v0, "width":I
    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v2

    .line 1145
    .local v2, "tail":Lokio/Segment;
    iget-object v3, v2, Lokio/Segment;->data:[B

    .line 1146
    .local v3, "data":[B
    iget v4, v2, Lokio/Segment;->limit:I

    add-int/2addr v4, v0

    add-int/lit8 v4, v4, -0x1

    .line 1146
    .local v4, "pos":I
    iget v5, v2, Lokio/Segment;->limit:I

    .line 1146
    .local v5, "start":I
    :goto_0
    if-lt v4, v5, :cond_1

    .line 1147
    sget-object v6, Lokio/Buffer;->DIGITS:[B

    const-wide/16 v7, 0xf

    and-long/2addr v7, p1

    long-to-int v7, v7

    aget-byte v6, v6, v7

    aput-byte v6, v3, v4

    .line 1148
    ushr-long/2addr p1, v1

    .line 1146
    add-int/lit8 v4, v4, -0x1

    goto :goto_0

    .line 1150
    .end local v4    # "pos":I
    .end local v5    # "start":I
    :cond_1
    iget v1, v2, Lokio/Segment;->limit:I

    add-int/2addr v1, v0

    iput v1, v2, Lokio/Segment;->limit:I

    .line 1151
    iget-wide v4, p0, Lokio/Buffer;->size:J

    int-to-long v6, v0

    add-long/2addr v4, v6

    iput-wide v4, p0, Lokio/Buffer;->size:J

    .line 1152
    return-object p0
.end method

.method public bridge synthetic writeHexadecimalUnsignedLong(J)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->writeHexadecimalUnsignedLong(J)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeInt(I)Lokio/Buffer;
    .locals 7
    .param p1, "i"    # I

    .line 1043
    const/4 v0, 0x4

    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v0

    .line 1044
    .local v0, "tail":Lokio/Segment;
    iget-object v1, v0, Lokio/Segment;->data:[B

    .line 1045
    .local v1, "data":[B
    iget v2, v0, Lokio/Segment;->limit:I

    .line 1046
    .local v2, "limit":I
    add-int/lit8 v3, v2, 0x1

    .line 1046
    .local v3, "limit":I
    ushr-int/lit8 v4, p1, 0x18

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v2

    .line 1047
    .end local v2    # "limit":I
    add-int/lit8 v2, v3, 0x1

    .line 1047
    .restart local v2    # "limit":I
    ushr-int/lit8 v4, p1, 0x10

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v3

    .line 1048
    .end local v3    # "limit":I
    add-int/lit8 v3, v2, 0x1

    .line 1048
    .restart local v3    # "limit":I
    ushr-int/lit8 v4, p1, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v2

    .line 1049
    .end local v2    # "limit":I
    add-int/lit8 v2, v3, 0x1

    .line 1049
    .restart local v2    # "limit":I
    and-int/lit16 v4, p1, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v3

    .line 1050
    .end local v3    # "limit":I
    iput v2, v0, Lokio/Segment;->limit:I

    .line 1051
    iget-wide v3, p0, Lokio/Buffer;->size:J

    const-wide/16 v5, 0x4

    add-long/2addr v3, v5

    iput-wide v3, p0, Lokio/Buffer;->size:J

    .line 1052
    return-object p0
.end method

.method public bridge synthetic writeInt(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeInt(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeIntLe(I)Lokio/Buffer;
    .locals 1
    .param p1, "i"    # I

    .line 1056
    invoke-static {p1}, Lokio/Util;->reverseBytesInt(I)I

    move-result v0

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeInt(I)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public bridge synthetic writeIntLe(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeIntLe(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeLong(J)Lokio/Buffer;
    .locals 9
    .param p1, "v"    # J

    .line 1060
    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v1

    .line 1061
    .local v1, "tail":Lokio/Segment;
    iget-object v2, v1, Lokio/Segment;->data:[B

    .line 1062
    .local v2, "data":[B
    iget v3, v1, Lokio/Segment;->limit:I

    .line 1063
    .local v3, "limit":I
    add-int/lit8 v4, v3, 0x1

    .line 1063
    .local v4, "limit":I
    const/16 v5, 0x38

    ushr-long v5, p1, v5

    const-wide/16 v7, 0xff

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v3

    .line 1064
    .end local v3    # "limit":I
    add-int/lit8 v3, v4, 0x1

    .line 1064
    .restart local v3    # "limit":I
    const/16 v5, 0x30

    ushr-long v5, p1, v5

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v4

    .line 1065
    .end local v4    # "limit":I
    add-int/lit8 v4, v3, 0x1

    .line 1065
    .restart local v4    # "limit":I
    const/16 v5, 0x28

    ushr-long v5, p1, v5

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v3

    .line 1066
    .end local v3    # "limit":I
    add-int/lit8 v3, v4, 0x1

    .line 1066
    .restart local v3    # "limit":I
    const/16 v5, 0x20

    ushr-long v5, p1, v5

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v4

    .line 1067
    .end local v4    # "limit":I
    add-int/lit8 v4, v3, 0x1

    .line 1067
    .restart local v4    # "limit":I
    const/16 v5, 0x18

    ushr-long v5, p1, v5

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v3

    .line 1068
    .end local v3    # "limit":I
    add-int/lit8 v3, v4, 0x1

    .line 1068
    .restart local v3    # "limit":I
    const/16 v5, 0x10

    ushr-long v5, p1, v5

    and-long/2addr v5, v7

    long-to-int v5, v5

    int-to-byte v5, v5

    aput-byte v5, v2, v4

    .line 1069
    .end local v4    # "limit":I
    add-int/lit8 v4, v3, 0x1

    .line 1069
    .restart local v4    # "limit":I
    ushr-long v5, p1, v0

    and-long/2addr v5, v7

    long-to-int v0, v5

    int-to-byte v0, v0

    aput-byte v0, v2, v3

    .line 1070
    .end local v3    # "limit":I
    add-int/lit8 v0, v4, 0x1

    .line 1070
    .local v0, "limit":I
    and-long v5, p1, v7

    long-to-int v3, v5

    int-to-byte v3, v3

    aput-byte v3, v2, v4

    .line 1071
    .end local v4    # "limit":I
    iput v0, v1, Lokio/Segment;->limit:I

    .line 1072
    iget-wide v3, p0, Lokio/Buffer;->size:J

    const-wide/16 v5, 0x8

    add-long/2addr v3, v5

    iput-wide v3, p0, Lokio/Buffer;->size:J

    .line 1073
    return-object p0
.end method

.method public bridge synthetic writeLong(J)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->writeLong(J)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeLongLe(J)Lokio/Buffer;
    .locals 2
    .param p1, "v"    # J

    .line 1077
    invoke-static {p1, p2}, Lokio/Util;->reverseBytesLong(J)J

    move-result-wide v0

    invoke-virtual {p0, v0, v1}, Lokio/Buffer;->writeLong(J)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public bridge synthetic writeLongLe(J)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->writeLongLe(J)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeShort(I)Lokio/Buffer;
    .locals 7
    .param p1, "s"    # I

    .line 1028
    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v0

    .line 1029
    .local v0, "tail":Lokio/Segment;
    iget-object v1, v0, Lokio/Segment;->data:[B

    .line 1030
    .local v1, "data":[B
    iget v2, v0, Lokio/Segment;->limit:I

    .line 1031
    .local v2, "limit":I
    add-int/lit8 v3, v2, 0x1

    .line 1031
    .local v3, "limit":I
    ushr-int/lit8 v4, p1, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v2

    .line 1032
    .end local v2    # "limit":I
    add-int/lit8 v2, v3, 0x1

    .line 1032
    .restart local v2    # "limit":I
    and-int/lit16 v4, p1, 0xff

    int-to-byte v4, v4

    aput-byte v4, v1, v3

    .line 1033
    .end local v3    # "limit":I
    iput v2, v0, Lokio/Segment;->limit:I

    .line 1034
    iget-wide v3, p0, Lokio/Buffer;->size:J

    const-wide/16 v5, 0x2

    add-long/2addr v3, v5

    iput-wide v3, p0, Lokio/Buffer;->size:J

    .line 1035
    return-object p0
.end method

.method public bridge synthetic writeShort(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeShort(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeShortLe(I)Lokio/Buffer;
    .locals 1
    .param p1, "s"    # I

    .line 1039
    int-to-short v0, p1

    invoke-static {v0}, Lokio/Util;->reverseBytesShort(S)S

    move-result v0

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeShort(I)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public bridge synthetic writeShortLe(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeShortLe(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeString(Ljava/lang/String;IILjava/nio/charset/Charset;)Lokio/Buffer;
    .locals 3
    .param p1, "string"    # Ljava/lang/String;
    .param p2, "beginIndex"    # I
    .param p3, "endIndex"    # I
    .param p4, "charset"    # Ljava/nio/charset/Charset;

    .line 963
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "string == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 964
    :cond_0
    if-gez p2, :cond_1

    new-instance v0, Ljava/lang/IllegalAccessError;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "beginIndex < 0: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalAccessError;-><init>(Ljava/lang/String;)V

    throw v0

    .line 965
    :cond_1
    if-ge p3, p2, :cond_2

    .line 966
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "endIndex < beginIndex: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " < "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 968
    :cond_2
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-le p3, v0, :cond_3

    .line 969
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "endIndex > string.length: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " > "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 970
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 972
    :cond_3
    if-nez p4, :cond_4

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "charset == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 973
    :cond_4
    sget-object v0, Lokio/Util;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p4, v0}, Ljava/nio/charset/Charset;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-virtual {p0, p1, p2, p3}, Lokio/Buffer;->writeUtf8(Ljava/lang/String;II)Lokio/Buffer;

    move-result-object v0

    return-object v0

    .line 974
    :cond_5
    invoke-virtual {p1, p2, p3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p4}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    .line 975
    .local v0, "data":[B
    const/4 v1, 0x0

    array-length v2, v0

    invoke-virtual {p0, v0, v1, v2}, Lokio/Buffer;->write([BII)Lokio/Buffer;

    move-result-object v1

    return-object v1
.end method

.method public writeString(Ljava/lang/String;Ljava/nio/charset/Charset;)Lokio/Buffer;
    .locals 2
    .param p1, "string"    # Ljava/lang/String;
    .param p2, "charset"    # Ljava/nio/charset/Charset;

    .line 958
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v0, p2}, Lokio/Buffer;->writeString(Ljava/lang/String;IILjava/nio/charset/Charset;)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public bridge synthetic writeString(Ljava/lang/String;IILjava/nio/charset/Charset;)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2, p3, p4}, Lokio/Buffer;->writeString(Ljava/lang/String;IILjava/nio/charset/Charset;)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public bridge synthetic writeString(Ljava/lang/String;Ljava/nio/charset/Charset;)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2}, Lokio/Buffer;->writeString(Ljava/lang/String;Ljava/nio/charset/Charset;)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeTo(Ljava/io/OutputStream;)Lokio/Buffer;
    .locals 2
    .param p1, "out"    # Ljava/io/OutputStream;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 202
    iget-wide v0, p0, Lokio/Buffer;->size:J

    invoke-virtual {p0, p1, v0, v1}, Lokio/Buffer;->writeTo(Ljava/io/OutputStream;J)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public writeTo(Ljava/io/OutputStream;J)Lokio/Buffer;
    .locals 8
    .param p1, "out"    # Ljava/io/OutputStream;
    .param p2, "byteCount"    # J
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 207
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "out == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 208
    :cond_0
    iget-wide v2, p0, Lokio/Buffer;->size:J

    const-wide/16 v4, 0x0

    move-wide v6, p2

    invoke-static/range {v2 .. v7}, Lokio/Util;->checkOffsetAndCount(JJJ)V

    .line 210
    iget-object v0, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 211
    .local v0, "s":Lokio/Segment;
    :goto_0
    const-wide/16 v1, 0x0

    cmp-long v1, p2, v1

    if-lez v1, :cond_2

    .line 212
    iget v1, v0, Lokio/Segment;->limit:I

    iget v2, v0, Lokio/Segment;->pos:I

    sub-int/2addr v1, v2

    int-to-long v1, v1

    invoke-static {p2, p3, v1, v2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    long-to-int v1, v1

    .line 213
    .local v1, "toCopy":I
    iget-object v2, v0, Lokio/Segment;->data:[B

    iget v3, v0, Lokio/Segment;->pos:I

    invoke-virtual {p1, v2, v3, v1}, Ljava/io/OutputStream;->write([BII)V

    .line 215
    iget v2, v0, Lokio/Segment;->pos:I

    add-int/2addr v2, v1

    iput v2, v0, Lokio/Segment;->pos:I

    .line 216
    iget-wide v2, p0, Lokio/Buffer;->size:J

    int-to-long v4, v1

    sub-long/2addr v2, v4

    iput-wide v2, p0, Lokio/Buffer;->size:J

    .line 217
    int-to-long v2, v1

    sub-long/2addr p2, v2

    .line 219
    iget v2, v0, Lokio/Segment;->pos:I

    iget v3, v0, Lokio/Segment;->limit:I

    if-ne v2, v3, :cond_1

    .line 220
    move-object v2, v0

    .line 221
    .local v2, "toRecycle":Lokio/Segment;
    invoke-virtual {v2}, Lokio/Segment;->pop()Lokio/Segment;

    move-result-object v3

    move-object v0, v3

    iput-object v3, p0, Lokio/Buffer;->head:Lokio/Segment;

    .line 222
    invoke-static {v2}, Lokio/SegmentPool;->recycle(Lokio/Segment;)V

    .line 224
    .end local v1    # "toCopy":I
    .end local v2    # "toRecycle":Lokio/Segment;
    :cond_1
    goto :goto_0

    .line 226
    :cond_2
    return-object p0
.end method

.method public writeUtf8(Ljava/lang/String;)Lokio/Buffer;
    .locals 2
    .param p1, "string"    # Ljava/lang/String;

    .line 842
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v0}, Lokio/Buffer;->writeUtf8(Ljava/lang/String;II)Lokio/Buffer;

    move-result-object v0

    return-object v0
.end method

.method public writeUtf8(Ljava/lang/String;II)Lokio/Buffer;
    .locals 12
    .param p1, "string"    # Ljava/lang/String;
    .param p2, "beginIndex"    # I
    .param p3, "endIndex"    # I

    .line 846
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "string == null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 847
    :cond_0
    if-gez p2, :cond_1

    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "beginIndex < 0: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 848
    :cond_1
    if-ge p3, p2, :cond_2

    .line 849
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "endIndex < beginIndex: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " < "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 851
    :cond_2
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-le p3, v0, :cond_3

    .line 852
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "endIndex > string.length: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " > "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 853
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 857
    :cond_3
    move v0, p2

    .line 857
    .local v0, "i":I
    :goto_0
    if-ge v0, p3, :cond_d

    .line 858
    invoke-virtual {p1, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    .line 860
    .local v1, "c":I
    const/16 v2, 0x80

    if-ge v1, v2, :cond_6

    .line 861
    const/4 v3, 0x1

    invoke-virtual {p0, v3}, Lokio/Buffer;->writableSegment(I)Lokio/Segment;

    move-result-object v3

    .line 862
    .local v3, "tail":Lokio/Segment;
    iget-object v4, v3, Lokio/Segment;->data:[B

    .line 863
    .local v4, "data":[B
    iget v5, v3, Lokio/Segment;->limit:I

    sub-int/2addr v5, v0

    .line 864
    .local v5, "segmentOffset":I
    rsub-int v6, v5, 0x2000

    invoke-static {p3, v6}, Ljava/lang/Math;->min(II)I

    move-result v6

    .line 867
    .local v6, "runLimit":I
    add-int/lit8 v7, v0, 0x1

    .line 867
    .local v7, "i":I
    add-int/2addr v0, v5

    .line 867
    .end local v0    # "i":I
    int-to-byte v8, v1

    aput-byte v8, v4, v0

    .line 871
    :goto_1
    if-ge v7, v6, :cond_5

    .line 872
    invoke-virtual {p1, v7}, Ljava/lang/String;->charAt(I)C

    move-result v1

    .line 873
    if-lt v1, v2, :cond_4

    goto :goto_2

    .line 874
    :cond_4
    add-int/lit8 v0, v7, 0x1

    .line 874
    .restart local v0    # "i":I
    add-int/2addr v7, v5

    .line 874
    .end local v7    # "i":I
    int-to-byte v8, v1

    aput-byte v8, v4, v7

    .line 871
    move v7, v0

    goto :goto_1

    .line 877
    .end local v0    # "i":I
    .restart local v7    # "i":I
    :cond_5
    :goto_2
    add-int v0, v7, v5

    iget v2, v3, Lokio/Segment;->limit:I

    sub-int/2addr v0, v2

    .line 878
    .local v0, "runSize":I
    iget v2, v3, Lokio/Segment;->limit:I

    add-int/2addr v2, v0

    iput v2, v3, Lokio/Segment;->limit:I

    .line 879
    iget-wide v8, p0, Lokio/Buffer;->size:J

    int-to-long v10, v0

    add-long/2addr v8, v10

    iput-wide v8, p0, Lokio/Buffer;->size:J

    .line 881
    .end local v0    # "runSize":I
    .end local v3    # "tail":Lokio/Segment;
    .end local v4    # "data":[B
    .end local v5    # "segmentOffset":I
    .end local v6    # "runLimit":I
    nop

    .line 916
    move v0, v7

    goto/16 :goto_6

    .line 881
    .end local v7    # "i":I
    .local v0, "i":I
    :cond_6
    const/16 v3, 0x800

    if-ge v1, v3, :cond_7

    .line 883
    shr-int/lit8 v3, v1, 0x6

    or-int/lit16 v3, v3, 0xc0

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 884
    and-int/lit8 v3, v1, 0x3f

    or-int/2addr v2, v3

    invoke-virtual {p0, v2}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 885
    add-int/lit8 v0, v0, 0x1

    goto/16 :goto_6

    .line 887
    :cond_7
    const v3, 0xd800

    const/16 v4, 0x3f

    if-lt v1, v3, :cond_c

    const v3, 0xdfff

    if-le v1, v3, :cond_8

    goto :goto_5

    .line 897
    :cond_8
    add-int/lit8 v5, v0, 0x1

    if-ge v5, p3, :cond_9

    add-int/lit8 v5, v0, 0x1

    invoke-virtual {p1, v5}, Ljava/lang/String;->charAt(I)C

    move-result v5

    goto :goto_3

    :cond_9
    const/4 v5, 0x0

    .line 898
    .local v5, "low":I
    :goto_3
    const v6, 0xdbff

    if-gt v1, v6, :cond_b

    const v6, 0xdc00

    if-lt v5, v6, :cond_b

    if-le v5, v3, :cond_a

    goto :goto_4

    .line 907
    :cond_a
    const/high16 v3, 0x10000

    const v6, -0xd801

    and-int/2addr v6, v1

    shl-int/lit8 v6, v6, 0xa

    const v7, -0xdc01

    and-int/2addr v7, v5

    or-int/2addr v6, v7

    add-int/2addr v6, v3

    .line 910
    .local v6, "codePoint":I
    shr-int/lit8 v3, v6, 0x12

    or-int/lit16 v3, v3, 0xf0

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 911
    shr-int/lit8 v3, v6, 0xc

    and-int/2addr v3, v4

    or-int/2addr v3, v2

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 912
    shr-int/lit8 v3, v6, 0x6

    and-int/2addr v3, v4

    or-int/2addr v3, v2

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 913
    and-int/lit8 v3, v6, 0x3f

    or-int/2addr v2, v3

    invoke-virtual {p0, v2}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 914
    add-int/lit8 v0, v0, 0x2

    .line 914
    .end local v1    # "c":I
    .end local v5    # "low":I
    .end local v6    # "codePoint":I
    goto :goto_6

    .line 899
    .restart local v1    # "c":I
    .restart local v5    # "low":I
    :cond_b
    :goto_4
    invoke-virtual {p0, v4}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 900
    add-int/lit8 v0, v0, 0x1

    .line 901
    goto/16 :goto_0

    .line 889
    .end local v5    # "low":I
    :cond_c
    :goto_5
    shr-int/lit8 v3, v1, 0xc

    or-int/lit16 v3, v3, 0xe0

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 890
    shr-int/lit8 v3, v1, 0x6

    and-int/2addr v3, v4

    or-int/2addr v3, v2

    invoke-virtual {p0, v3}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 891
    and-int/lit8 v3, v1, 0x3f

    or-int/2addr v2, v3

    invoke-virtual {p0, v2}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 892
    add-int/lit8 v0, v0, 0x1

    .line 916
    .end local v1    # "c":I
    :goto_6
    goto/16 :goto_0

    .line 918
    .end local v0    # "i":I
    :cond_d
    return-object p0
.end method

.method public bridge synthetic writeUtf8(Ljava/lang/String;)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeUtf8(Ljava/lang/String;)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public bridge synthetic writeUtf8(Ljava/lang/String;II)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1, p2, p3}, Lokio/Buffer;->writeUtf8(Ljava/lang/String;II)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method

.method public writeUtf8CodePoint(I)Lokio/Buffer;
    .locals 3
    .param p1, "codePoint"    # I

    .line 922
    const/16 v0, 0x80

    if-ge p1, v0, :cond_0

    .line 924
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    goto :goto_0

    .line 926
    :cond_0
    const/16 v1, 0x800

    if-ge p1, v1, :cond_1

    .line 928
    shr-int/lit8 v1, p1, 0x6

    or-int/lit16 v1, v1, 0xc0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 929
    and-int/lit8 v1, p1, 0x3f

    or-int/2addr v0, v1

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    goto :goto_0

    .line 931
    :cond_1
    const/high16 v1, 0x10000

    const/16 v2, 0x3f

    if-ge p1, v1, :cond_3

    .line 932
    const v1, 0xd800

    if-lt p1, v1, :cond_2

    const v1, 0xdfff

    if-gt p1, v1, :cond_2

    .line 934
    invoke-virtual {p0, v2}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    goto :goto_0

    .line 937
    :cond_2
    shr-int/lit8 v1, p1, 0xc

    or-int/lit16 v1, v1, 0xe0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 938
    shr-int/lit8 v1, p1, 0x6

    and-int/2addr v1, v2

    or-int/2addr v1, v0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 939
    and-int/lit8 v1, p1, 0x3f

    or-int/2addr v0, v1

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    goto :goto_0

    .line 942
    :cond_3
    const v1, 0x10ffff

    if-gt p1, v1, :cond_4

    .line 944
    shr-int/lit8 v1, p1, 0x12

    or-int/lit16 v1, v1, 0xf0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 945
    shr-int/lit8 v1, p1, 0xc

    and-int/2addr v1, v2

    or-int/2addr v1, v0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 946
    shr-int/lit8 v1, p1, 0x6

    and-int/2addr v1, v2

    or-int/2addr v1, v0

    invoke-virtual {p0, v1}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 947
    and-int/lit8 v1, p1, 0x3f

    or-int/2addr v0, v1

    invoke-virtual {p0, v0}, Lokio/Buffer;->writeByte(I)Lokio/Buffer;

    .line 954
    :goto_0
    return-object p0

    .line 950
    :cond_4
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unexpected code point: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 951
    invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public bridge synthetic writeUtf8CodePoint(I)Lokio/BufferedSink;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 51
    invoke-virtual {p0, p1}, Lokio/Buffer;->writeUtf8CodePoint(I)Lokio/Buffer;

    move-result-object p1

    return-object p1
.end method
