.class public final Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;
.super Ljava/lang/Object;
.source "PublicSuffixDatabase.java"


# static fields
.field private static final EMPTY_RULE:[Ljava/lang/String;

.field private static final EXCEPTION_MARKER:B = 0x21t

.field private static final PREVAILING_RULE:[Ljava/lang/String;

.field public static final PUBLIC_SUFFIX_RESOURCE:Ljava/lang/String; = "publicsuffixes.gz"

.field private static final WILDCARD_LABEL:[B

.field private static final instance:Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;


# instance fields
.field private final listRead:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private publicSuffixExceptionListBytes:[B

.field private publicSuffixListBytes:[B

.field private final readCompleteLatch:Ljava/util/concurrent/CountDownLatch;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 39
    const/4 v0, 0x1

    new-array v0, v0, [B

    const/4 v1, 0x0

    const/16 v2, 0x2a

    aput-byte v2, v0, v1

    sput-object v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->WILDCARD_LABEL:[B

    .line 40
    new-array v0, v1, [Ljava/lang/String;

    sput-object v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->EMPTY_RULE:[Ljava/lang/String;

    .line 41
    const-string v0, "*"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->PREVAILING_RULE:[Ljava/lang/String;

    .line 45
    new-instance v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;

    invoke-direct {v0}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;-><init>()V

    sput-object v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->instance:Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 48
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->listRead:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 51
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    iput-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readCompleteLatch:Ljava/util/concurrent/CountDownLatch;

    return-void
.end method

.method private static binarySearchBytes([B[[BI)Ljava/lang/String;
    .locals 18
    .param p0, "bytesToSearch"    # [B
    .param p1, "labels"    # [[B
    .param p2, "labelIndex"    # I

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 195
    const/4 v2, 0x0

    .line 196
    .local v2, "low":I
    array-length v3, v0

    .line 197
    .local v3, "high":I
    const/4 v4, 0x0

    .line 198
    .local v4, "match":Ljava/lang/String;
    :goto_0
    if-ge v2, v3, :cond_c

    .line 199
    add-int v5, v2, v3

    div-int/lit8 v5, v5, 0x2

    .line 202
    .local v5, "mid":I
    :goto_1
    const/16 v6, 0xa

    const/4 v7, -0x1

    if-le v5, v7, :cond_0

    aget-byte v7, v0, v5

    if-eq v7, v6, :cond_0

    .line 203
    add-int/lit8 v5, v5, -0x1

    goto :goto_1

    .line 205
    :cond_0
    add-int/lit8 v5, v5, 0x1

    .line 208
    const/4 v8, 0x1

    .line 209
    .local v8, "end":I
    :goto_2
    add-int v9, v5, v8

    aget-byte v9, v0, v9

    if-eq v9, v6, :cond_1

    .line 210
    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 212
    :cond_1
    add-int v6, v5, v8

    sub-int/2addr v6, v5

    .line 217
    .local v6, "publicSuffixLength":I
    move/from16 v9, p2

    .line 218
    .local v9, "currentLabelIndex":I
    const/4 v10, 0x0

    .line 219
    .local v10, "currentLabelByteIndex":I
    const/4 v11, 0x0

    .line 221
    .local v11, "publicSuffixByteIndex":I
    const/4 v12, 0x0

    .line 224
    .local v12, "expectDot":Z
    :goto_3
    if-eqz v12, :cond_2

    .line 225
    const/16 v13, 0x2e

    .line 226
    .local v13, "byte0":I
    const/4 v12, 0x0

    goto :goto_4

    .line 228
    .end local v13    # "byte0":I
    :cond_2
    aget-object v13, v1, v9

    aget-byte v13, v13, v10

    and-int/lit16 v13, v13, 0xff

    .line 231
    .restart local v13    # "byte0":I
    :goto_4
    add-int v14, v5, v11

    aget-byte v14, v0, v14

    and-int/lit16 v14, v14, 0xff

    .line 233
    .local v14, "byte1":I
    sub-int v15, v13, v14

    .line 234
    .local v15, "compareResult":I
    if-eqz v15, :cond_3

    .line 234
    .end local v13    # "byte0":I
    .end local v14    # "byte1":I
    goto :goto_5

    .line 236
    .restart local v13    # "byte0":I
    .restart local v14    # "byte1":I
    :cond_3
    add-int/lit8 v11, v11, 0x1

    .line 237
    add-int/lit8 v10, v10, 0x1

    .line 238
    if-ne v11, v6, :cond_4

    .line 238
    .end local v13    # "byte0":I
    .end local v14    # "byte1":I
    goto :goto_5

    .line 240
    .restart local v13    # "byte0":I
    .restart local v14    # "byte1":I
    :cond_4
    aget-object v7, v1, v9

    array-length v7, v7

    if-ne v7, v10, :cond_b

    .line 243
    array-length v7, v1

    const/16 v16, 0x1

    add-int/lit8 v7, v7, -0x1

    if-ne v9, v7, :cond_a

    .line 244
    nop

    .line 253
    .end local v13    # "byte0":I
    .end local v14    # "byte1":I
    :goto_5
    if-gez v15, :cond_5

    .line 254
    add-int/lit8 v3, v5, -0x1

    goto :goto_7

    .line 255
    :cond_5
    if-lez v15, :cond_6

    .line 256
    add-int v7, v5, v8

    const/4 v13, 0x1

    add-int/2addr v7, v13

    .line 275
    .end local v2    # "low":I
    .local v7, "low":I
    move v2, v7

    goto :goto_7

    .line 259
    .end local v7    # "low":I
    .restart local v2    # "low":I
    :cond_6
    sub-int v7, v6, v11

    .line 260
    .local v7, "publicSuffixBytesLeft":I
    aget-object v13, v1, v9

    array-length v13, v13

    sub-int/2addr v13, v10

    .line 261
    .local v13, "labelBytesLeft":I
    add-int/lit8 v14, v9, 0x1

    .line 261
    .local v14, "i":I
    :goto_6
    move/from16 v17, v2

    array-length v2, v1

    .line 261
    .end local v2    # "low":I
    .local v17, "low":I
    if-ge v14, v2, :cond_7

    .line 262
    aget-object v2, v1, v14

    array-length v2, v2

    add-int/2addr v13, v2

    .line 261
    add-int/lit8 v14, v14, 0x1

    move/from16 v2, v17

    goto :goto_6

    .line 265
    .end local v14    # "i":I
    :cond_7
    if-ge v13, v7, :cond_8

    .line 266
    add-int/lit8 v2, v5, -0x1

    .line 275
    .end local v3    # "high":I
    .local v2, "high":I
    move v3, v2

    move/from16 v2, v17

    goto :goto_7

    .line 267
    .end local v2    # "high":I
    .restart local v3    # "high":I
    :cond_8
    if-le v13, v7, :cond_9

    .line 268
    add-int v2, v5, v8

    const/16 v16, 0x1

    add-int/lit8 v2, v2, 0x1

    .line 275
    .end local v5    # "mid":I
    .end local v6    # "publicSuffixLength":I
    .end local v7    # "publicSuffixBytesLeft":I
    .end local v8    # "end":I
    .end local v9    # "currentLabelIndex":I
    .end local v10    # "currentLabelByteIndex":I
    .end local v11    # "publicSuffixByteIndex":I
    .end local v12    # "expectDot":Z
    .end local v13    # "labelBytesLeft":I
    .end local v15    # "compareResult":I
    .end local v17    # "low":I
    .local v2, "low":I
    :goto_7
    goto/16 :goto_0

    .line 271
    .end local v2    # "low":I
    .restart local v5    # "mid":I
    .restart local v6    # "publicSuffixLength":I
    .restart local v7    # "publicSuffixBytesLeft":I
    .restart local v8    # "end":I
    .restart local v9    # "currentLabelIndex":I
    .restart local v10    # "currentLabelByteIndex":I
    .restart local v11    # "publicSuffixByteIndex":I
    .restart local v12    # "expectDot":Z
    .restart local v13    # "labelBytesLeft":I
    .restart local v15    # "compareResult":I
    .restart local v17    # "low":I
    :cond_9
    new-instance v2, Ljava/lang/String;

    sget-object v14, Lokhttp3/internal/Util;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v2, v0, v5, v6, v14}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    move-object v4, v2

    .line 272
    goto :goto_9

    .line 246
    .end local v7    # "publicSuffixBytesLeft":I
    .end local v17    # "low":I
    .restart local v2    # "low":I
    .local v13, "byte0":I
    .local v14, "byte1":I
    :cond_a
    move/from16 v17, v2

    const/16 v16, 0x1

    .line 246
    .end local v2    # "low":I
    .restart local v17    # "low":I
    add-int/lit8 v9, v9, 0x1

    .line 247
    const/4 v2, -0x1

    .line 248
    .end local v10    # "currentLabelByteIndex":I
    .local v2, "currentLabelByteIndex":I
    const/4 v7, 0x1

    .line 251
    .end local v12    # "expectDot":Z
    .end local v13    # "byte0":I
    .end local v14    # "byte1":I
    .local v7, "expectDot":Z
    move v10, v2

    move v12, v7

    goto :goto_8

    .line 251
    .end local v7    # "expectDot":Z
    .end local v17    # "low":I
    .local v2, "low":I
    .restart local v10    # "currentLabelByteIndex":I
    .restart local v12    # "expectDot":Z
    :cond_b
    move/from16 v17, v2

    const/16 v16, 0x1

    .line 221
    .end local v2    # "low":I
    .restart local v17    # "low":I
    :goto_8
    move/from16 v2, v17

    goto :goto_3

    .line 276
    .end local v5    # "mid":I
    .end local v6    # "publicSuffixLength":I
    .end local v8    # "end":I
    .end local v9    # "currentLabelIndex":I
    .end local v10    # "currentLabelByteIndex":I
    .end local v11    # "publicSuffixByteIndex":I
    .end local v12    # "expectDot":Z
    .end local v15    # "compareResult":I
    .end local v17    # "low":I
    .restart local v2    # "low":I
    :cond_c
    move/from16 v17, v2

    .line 276
    .end local v2    # "low":I
    .restart local v17    # "low":I
    :goto_9
    return-object v4
.end method

.method private findMatchingRule([Ljava/lang/String;)[Ljava/lang/String;
    .locals 8
    .param p1, "domainLabels"    # [Ljava/lang/String;

    .line 109
    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->listRead:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->listRead:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 110
    invoke-direct {p0}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readTheListUninterruptibly()V

    goto :goto_0

    .line 113
    :cond_0
    :try_start_0
    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readCompleteLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {v0}, Ljava/util/concurrent/CountDownLatch;->await()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 115
    goto :goto_0

    .line 114
    :catch_0
    move-exception v0

    .line 118
    :goto_0
    monitor-enter p0

    .line 119
    :try_start_1
    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixListBytes:[B

    if-nez v0, :cond_1

    .line 120
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Unable to load publicsuffixes.gz resource from the classpath."

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 123
    :cond_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 126
    array-length v0, p1

    new-array v0, v0, [[B

    .line 127
    .local v0, "domainLabelsUtf8Bytes":[[B
    move v3, v1

    .line 127
    .local v3, "i":I
    :goto_1
    array-length v4, p1

    if-ge v3, v4, :cond_2

    .line 128
    aget-object v4, p1, v3

    sget-object v5, Lokhttp3/internal/Util;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v4, v5}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v4

    aput-object v4, v0, v3

    .line 127
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 133
    .end local v3    # "i":I
    :cond_2
    const/4 v3, 0x0

    .line 134
    .local v3, "exactMatch":Ljava/lang/String;
    move v4, v1

    .line 134
    .local v4, "i":I
    :goto_2
    array-length v5, v0

    if-ge v4, v5, :cond_4

    .line 135
    iget-object v5, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixListBytes:[B

    invoke-static {v5, v0, v4}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->binarySearchBytes([B[[BI)Ljava/lang/String;

    move-result-object v5

    .line 136
    .local v5, "rule":Ljava/lang/String;
    if-eqz v5, :cond_3

    .line 137
    move-object v3, v5

    .line 138
    goto :goto_3

    .line 134
    .end local v5    # "rule":Ljava/lang/String;
    :cond_3
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 147
    .end local v4    # "i":I
    :cond_4
    :goto_3
    const/4 v4, 0x0

    .line 148
    .local v4, "wildcardMatch":Ljava/lang/String;
    array-length v5, v0

    if-le v5, v2, :cond_6

    .line 149
    invoke-virtual {v0}, [[B->clone()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [[B

    .line 150
    .local v5, "labelsWithWildcard":[[B
    move v6, v1

    .line 150
    .local v6, "labelIndex":I
    :goto_4
    array-length v7, v5

    sub-int/2addr v7, v2

    if-ge v6, v7, :cond_6

    .line 151
    sget-object v7, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->WILDCARD_LABEL:[B

    aput-object v7, v5, v6

    .line 152
    iget-object v7, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixListBytes:[B

    invoke-static {v7, v5, v6}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->binarySearchBytes([B[[BI)Ljava/lang/String;

    move-result-object v7

    .line 153
    .local v7, "rule":Ljava/lang/String;
    if-eqz v7, :cond_5

    .line 154
    move-object v4, v7

    .line 155
    goto :goto_5

    .line 150
    .end local v7    # "rule":Ljava/lang/String;
    :cond_5
    add-int/lit8 v6, v6, 0x1

    goto :goto_4

    .line 161
    .end local v5    # "labelsWithWildcard":[[B
    .end local v6    # "labelIndex":I
    :cond_6
    :goto_5
    const/4 v5, 0x0

    .line 162
    .local v5, "exception":Ljava/lang/String;
    if-eqz v4, :cond_8

    .line 163
    nop

    .line 163
    .local v1, "labelIndex":I
    :goto_6
    array-length v6, v0

    sub-int/2addr v6, v2

    if-ge v1, v6, :cond_8

    .line 164
    iget-object v6, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixExceptionListBytes:[B

    invoke-static {v6, v0, v1}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->binarySearchBytes([B[[BI)Ljava/lang/String;

    move-result-object v6

    .line 166
    .local v6, "rule":Ljava/lang/String;
    if-eqz v6, :cond_7

    .line 167
    move-object v5, v6

    .line 168
    goto :goto_7

    .line 163
    .end local v6    # "rule":Ljava/lang/String;
    :cond_7
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 173
    .end local v1    # "labelIndex":I
    :cond_8
    :goto_7
    if-eqz v5, :cond_9

    .line 175
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "!"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 176
    .end local v5    # "exception":Ljava/lang/String;
    .local v1, "exception":Ljava/lang/String;
    const-string v2, "\\."

    invoke-virtual {v1, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    return-object v2

    .line 177
    .end local v1    # "exception":Ljava/lang/String;
    .restart local v5    # "exception":Ljava/lang/String;
    :cond_9
    if-nez v3, :cond_a

    if-nez v4, :cond_a

    .line 178
    sget-object v1, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->PREVAILING_RULE:[Ljava/lang/String;

    return-object v1

    .line 181
    :cond_a
    if-eqz v3, :cond_b

    .line 182
    const-string v1, "\\."

    invoke-virtual {v3, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    goto :goto_8

    .line 183
    :cond_b
    sget-object v1, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->EMPTY_RULE:[Ljava/lang/String;

    .line 185
    .local v1, "exactRuleLabels":[Ljava/lang/String;
    :goto_8
    if-eqz v4, :cond_c

    .line 186
    const-string v2, "\\."

    invoke-virtual {v4, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    goto :goto_9

    .line 187
    :cond_c
    sget-object v2, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->EMPTY_RULE:[Ljava/lang/String;

    .line 189
    .local v2, "wildcardRuleLabels":[Ljava/lang/String;
    :goto_9
    array-length v6, v1

    array-length v7, v2

    if-le v6, v7, :cond_d

    .line 190
    nop

    .line 189
    move-object v6, v1

    goto :goto_a

    .line 191
    :cond_d
    nop

    .line 189
    move-object v6, v2

    :goto_a
    return-object v6

    .line 123
    .end local v0    # "domainLabelsUtf8Bytes":[[B
    .end local v1    # "exactRuleLabels":[Ljava/lang/String;
    .end local v2    # "wildcardRuleLabels":[Ljava/lang/String;
    .end local v3    # "exactMatch":Ljava/lang/String;
    .end local v4    # "wildcardMatch":Ljava/lang/String;
    .end local v5    # "exception":Ljava/lang/String;
    :catchall_0
    move-exception v0

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v0
.end method

.method public static get()Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;
    .locals 1

    .line 61
    sget-object v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->instance:Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;

    return-object v0
.end method

.method private readTheList()V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 309
    const-class v0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;

    const-string v1, "publicsuffixes.gz"

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getResourceAsStream(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v0

    .line 310
    .local v0, "resource":Ljava/io/InputStream;
    if-nez v0, :cond_0

    return-void

    .line 312
    :cond_0
    new-instance v1, Lokio/GzipSource;

    invoke-static {v0}, Lokio/Okio;->source(Ljava/io/InputStream;)Lokio/Source;

    move-result-object v2

    invoke-direct {v1, v2}, Lokio/GzipSource;-><init>(Lokio/Source;)V

    invoke-static {v1}, Lokio/Okio;->buffer(Lokio/Source;)Lokio/BufferedSource;

    move-result-object v1

    .line 314
    .local v1, "bufferedSource":Lokio/BufferedSource;
    :try_start_0
    invoke-interface {v1}, Lokio/BufferedSource;->readInt()I

    move-result v2

    .line 315
    .local v2, "totalBytes":I
    new-array v3, v2, [B

    .line 316
    .local v3, "publicSuffixListBytes":[B
    invoke-interface {v1, v3}, Lokio/BufferedSource;->readFully([B)V

    .line 318
    invoke-interface {v1}, Lokio/BufferedSource;->readInt()I

    move-result v4

    .line 319
    .local v4, "totalExceptionBytes":I
    new-array v5, v4, [B

    .line 320
    .local v5, "publicSuffixExceptionListBytes":[B
    invoke-interface {v1, v5}, Lokio/BufferedSource;->readFully([B)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 322
    .end local v2    # "totalBytes":I
    .end local v4    # "totalExceptionBytes":I
    invoke-static {v1}, Lokhttp3/internal/Util;->closeQuietly(Ljava/io/Closeable;)V

    .line 323
    nop

    .line 322
    nop

    .line 325
    monitor-enter p0

    .line 326
    :try_start_1
    iput-object v3, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixListBytes:[B

    .line 327
    iput-object v5, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixExceptionListBytes:[B

    .line 328
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 330
    iget-object v2, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readCompleteLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {v2}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 331
    return-void

    .line 328
    :catchall_0
    move-exception v2

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v2

    .line 322
    .end local v3    # "publicSuffixListBytes":[B
    .end local v5    # "publicSuffixExceptionListBytes":[B
    :catchall_1
    move-exception v2

    invoke-static {v1}, Lokhttp3/internal/Util;->closeQuietly(Ljava/io/Closeable;)V

    throw v2
.end method

.method private readTheListUninterruptibly()V
    .locals 5

    .line 285
    const/4 v0, 0x0

    .line 289
    .local v0, "interrupted":Z
    :goto_0
    :try_start_0
    invoke-direct {p0}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readTheList()V
    :try_end_0
    .catch Ljava/io/InterruptedIOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 299
    if-eqz v0, :cond_0

    .line 300
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Thread;->interrupt()V

    .line 290
    :cond_0
    return-void

    .line 299
    :catchall_0
    move-exception v1

    goto :goto_1

    .line 293
    :catch_0
    move-exception v1

    .line 294
    .local v1, "e":Ljava/io/IOException;
    :try_start_1
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v2

    const/4 v3, 0x5

    const-string v4, "Failed to read public suffix list"

    invoke-virtual {v2, v3, v4, v1}, Lokhttp3/internal/platform/Platform;->log(ILjava/lang/String;Ljava/lang/Throwable;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 299
    if-eqz v0, :cond_1

    .line 300
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Thread;->interrupt()V

    .line 295
    :cond_1
    return-void

    .line 299
    .end local v1    # "e":Ljava/io/IOException;
    :goto_1
    if-eqz v0, :cond_2

    .line 300
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Thread;->interrupt()V

    :cond_2
    throw v1

    .line 291
    :catch_1
    move-exception v1

    .line 292
    .local v1, "e":Ljava/io/InterruptedIOException;
    const/4 v0, 0x1

    .line 296
    .end local v1    # "e":Ljava/io/InterruptedIOException;
    goto :goto_0
.end method


# virtual methods
.method public getEffectiveTldPlusOne(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    .param p1, "domain"    # Ljava/lang/String;

    .line 78
    if-nez p1, :cond_0

    new-instance v0, Ljava/lang/NullPointerException;

    const-string v1, "domain == null"

    invoke-direct {v0, v1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 81
    :cond_0
    invoke-static {p1}, Ljava/net/IDN;->toUnicode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 82
    .local v0, "unicodeDomain":Ljava/lang/String;
    const-string v1, "\\."

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 83
    .local v1, "domainLabels":[Ljava/lang/String;
    invoke-direct {p0, v1}, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->findMatchingRule([Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    .line 84
    .local v2, "rule":[Ljava/lang/String;
    array-length v3, v1

    array-length v4, v2

    const/16 v5, 0x21

    const/4 v6, 0x0

    if-ne v3, v4, :cond_1

    aget-object v3, v2, v6

    invoke-virtual {v3, v6}, Ljava/lang/String;->charAt(I)C

    move-result v3

    if-eq v3, v5, :cond_1

    .line 86
    const/4 v3, 0x0

    return-object v3

    .line 90
    :cond_1
    aget-object v3, v2, v6

    invoke-virtual {v3, v6}, Ljava/lang/String;->charAt(I)C

    move-result v3

    if-ne v3, v5, :cond_2

    .line 92
    array-length v3, v1

    array-length v4, v2

    sub-int/2addr v3, v4

    .line 92
    .local v3, "firstLabelOffset":I
    goto :goto_0

    .line 95
    .end local v3    # "firstLabelOffset":I
    :cond_2
    array-length v3, v1

    array-length v4, v2

    add-int/lit8 v4, v4, 0x1

    sub-int/2addr v3, v4

    .line 98
    .restart local v3    # "firstLabelOffset":I
    :goto_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 99
    .local v4, "effectiveTldPlusOne":Ljava/lang/StringBuilder;
    const-string v5, "\\."

    invoke-virtual {p1, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 100
    .local v5, "punycodeLabels":[Ljava/lang/String;
    move v6, v3

    .line 100
    .local v6, "i":I
    :goto_1
    array-length v7, v5

    if-ge v6, v7, :cond_3

    .line 101
    aget-object v7, v5, v6

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v7, 0x2e

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 100
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 103
    .end local v6    # "i":I
    :cond_3
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->length()I

    move-result v6

    add-int/lit8 v6, v6, -0x1

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->deleteCharAt(I)Ljava/lang/StringBuilder;

    .line 105
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    return-object v6
.end method

.method setListBytes([B[B)V
    .locals 2
    .param p1, "publicSuffixListBytes"    # [B
    .param p2, "publicSuffixExceptionListBytes"    # [B

    .line 335
    iput-object p1, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixListBytes:[B

    .line 336
    iput-object p2, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->publicSuffixExceptionListBytes:[B

    .line 337
    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->listRead:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 338
    iget-object v0, p0, Lokhttp3/internal/publicsuffix/PublicSuffixDatabase;->readCompleteLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {v0}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 339
    return-void
.end method
