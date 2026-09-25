.class final Lokhttp3/internal/ws/WebSocketWriter;
.super Ljava/lang/Object;
.source "WebSocketWriter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lokhttp3/internal/ws/WebSocketWriter$FrameSink;
    }
.end annotation


# instance fields
.field activeWriter:Z

.field final buffer:Lokio/Buffer;

.field final frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

.field final isClient:Z

.field final maskBuffer:[B

.field final maskKey:[B

.field final random:Ljava/util/Random;

.field final sink:Lokio/BufferedSink;

.field writerClosed:Z


# direct methods
.method constructor <init>(ZLokio/BufferedSink;Ljava/util/Random;)V
    .locals 2
    .param p1, "isClient"    # Z
    .param p2, "sink"    # Lokio/BufferedSink;
    .param p3, "random"    # Ljava/util/Random;

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 53
    new-instance v0, Lokio/Buffer;

    invoke-direct {v0}, Lokio/Buffer;-><init>()V

    iput-object v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->buffer:Lokio/Buffer;

    .line 54
    new-instance v0, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    invoke-direct {v0, p0}, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;-><init>(Lokhttp3/internal/ws/WebSocketWriter;)V

    iput-object v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    .line 62
    if-nez p2, :cond_0

    new-instance v0, Ljava/lang/NullPointerException;

    const-string v1, "sink == null"

    invoke-direct {v0, v1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 63
    :cond_0
    if-nez p3, :cond_1

    new-instance v0, Ljava/lang/NullPointerException;

    const-string v1, "random == null"

    invoke-direct {v0, v1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 64
    :cond_1
    iput-boolean p1, p0, Lokhttp3/internal/ws/WebSocketWriter;->isClient:Z

    .line 65
    iput-object p2, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    .line 66
    iput-object p3, p0, Lokhttp3/internal/ws/WebSocketWriter;->random:Ljava/util/Random;

    .line 69
    const/4 v0, 0x0

    if-eqz p1, :cond_2

    const/4 v1, 0x4

    new-array v1, v1, [B

    goto :goto_0

    :cond_2
    move-object v1, v0

    :goto_0
    iput-object v1, p0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    .line 70
    if-eqz p1, :cond_3

    const/16 v0, 0x2000

    new-array v0, v0, [B

    nop

    :cond_3
    iput-object v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->maskBuffer:[B

    .line 71
    return-void
.end method

.method private writeControlFrame(ILokio/ByteString;)V
    .locals 11
    .param p1, "opcode"    # I
    .param p2, "payload"    # Lokio/ByteString;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 112
    iget-boolean v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->writerClosed:Z

    if-eqz v0, :cond_0

    new-instance v0, Ljava/io/IOException;

    const-string v1, "closed"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 114
    :cond_0
    invoke-virtual {p2}, Lokio/ByteString;->size()I

    move-result v0

    .line 115
    .local v0, "length":I
    int-to-long v1, v0

    const-wide/16 v3, 0x7d

    cmp-long v1, v1, v3

    if-lez v1, :cond_1

    .line 116
    new-instance v1, Ljava/lang/IllegalArgumentException;

    const-string v2, "Payload size must be less than or equal to 125"

    invoke-direct {v1, v2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 120
    :cond_1
    or-int/lit16 v1, p1, 0x80

    .line 121
    .local v1, "b0":I
    iget-object v2, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v2, v1}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 123
    move v2, v0

    .line 124
    .local v2, "b1":I
    iget-boolean v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->isClient:Z

    if-eqz v3, :cond_2

    .line 125
    or-int/lit16 v2, v2, 0x80

    .line 126
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v3, v2}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 128
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->random:Ljava/util/Random;

    iget-object v4, p0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    invoke-virtual {v3, v4}, Ljava/util/Random;->nextBytes([B)V

    .line 129
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    iget-object v4, p0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    invoke-interface {v3, v4}, Lokio/BufferedSink;->write([B)Lokio/BufferedSink;

    .line 131
    invoke-virtual {p2}, Lokio/ByteString;->toByteArray()[B

    move-result-object v3

    .line 132
    .local v3, "bytes":[B
    array-length v4, v3

    int-to-long v6, v4

    iget-object v8, p0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    const-wide/16 v9, 0x0

    move-object v5, v3

    invoke-static/range {v5 .. v10}, Lokhttp3/internal/ws/WebSocketProtocol;->toggleMask([BJ[BJ)V

    .line 133
    iget-object v4, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v4, v3}, Lokio/BufferedSink;->write([B)Lokio/BufferedSink;

    .line 134
    .end local v3    # "bytes":[B
    goto :goto_0

    .line 135
    :cond_2
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v3, v2}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 136
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v3, p2}, Lokio/BufferedSink;->write(Lokio/ByteString;)Lokio/BufferedSink;

    .line 139
    :goto_0
    iget-object v3, p0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v3}, Lokio/BufferedSink;->flush()V

    .line 140
    return-void
.end method


# virtual methods
.method newMessageSink(IJ)Lokio/Sink;
    .locals 2
    .param p1, "formatOpcode"    # I
    .param p2, "contentLength"    # J

    .line 147
    iget-boolean v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->activeWriter:Z

    if-eqz v0, :cond_0

    .line 148
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Another message writer is active. Did you call close()?"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 150
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->activeWriter:Z

    .line 153
    iget-object v1, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    iput p1, v1, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;->formatOpcode:I

    .line 154
    iget-object v1, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    iput-wide p2, v1, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;->contentLength:J

    .line 155
    iget-object v1, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    iput-boolean v0, v1, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;->isFirstFrame:Z

    .line 156
    iget-object v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    const/4 v1, 0x0

    iput-boolean v1, v0, Lokhttp3/internal/ws/WebSocketWriter$FrameSink;->closed:Z

    .line 158
    iget-object v0, p0, Lokhttp3/internal/ws/WebSocketWriter;->frameSink:Lokhttp3/internal/ws/WebSocketWriter$FrameSink;

    return-object v0
.end method

.method writeClose(ILokio/ByteString;)V
    .locals 3
    .param p1, "code"    # I
    .param p2, "reason"    # Lokio/ByteString;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 91
    sget-object v0, Lokio/ByteString;->EMPTY:Lokio/ByteString;

    .line 92
    .local v0, "payload":Lokio/ByteString;
    if-nez p1, :cond_0

    if-eqz p2, :cond_3

    .line 93
    :cond_0
    if-eqz p1, :cond_1

    .line 94
    invoke-static {p1}, Lokhttp3/internal/ws/WebSocketProtocol;->validateCloseCode(I)V

    .line 96
    :cond_1
    new-instance v1, Lokio/Buffer;

    invoke-direct {v1}, Lokio/Buffer;-><init>()V

    .line 97
    .local v1, "buffer":Lokio/Buffer;
    invoke-virtual {v1, p1}, Lokio/Buffer;->writeShort(I)Lokio/Buffer;

    .line 98
    if-eqz p2, :cond_2

    .line 99
    invoke-virtual {v1, p2}, Lokio/Buffer;->write(Lokio/ByteString;)Lokio/Buffer;

    .line 101
    :cond_2
    invoke-virtual {v1}, Lokio/Buffer;->readByteString()Lokio/ByteString;

    move-result-object v0

    .line 105
    .end local v1    # "buffer":Lokio/Buffer;
    :cond_3
    const/16 v1, 0x8

    const/4 v2, 0x1

    :try_start_0
    invoke-direct {p0, v1, v0}, Lokhttp3/internal/ws/WebSocketWriter;->writeControlFrame(ILokio/ByteString;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 107
    iput-boolean v2, p0, Lokhttp3/internal/ws/WebSocketWriter;->writerClosed:Z

    .line 108
    nop

    .line 109
    return-void

    .line 107
    :catchall_0
    move-exception v1

    iput-boolean v2, p0, Lokhttp3/internal/ws/WebSocketWriter;->writerClosed:Z

    throw v1
.end method

.method writeMessageFrame(IJZZ)V
    .locals 17
    .param p1, "formatOpcode"    # I
    .param p2, "byteCount"    # J
    .param p4, "isFirstFrame"    # Z
    .param p5, "isFinal"    # Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    move-object/from16 v0, p0

    move-wide/from16 v1, p2

    .line 163
    iget-boolean v3, v0, Lokhttp3/internal/ws/WebSocketWriter;->writerClosed:Z

    if-eqz v3, :cond_0

    new-instance v3, Ljava/io/IOException;

    const-string v4, "closed"

    invoke-direct {v3, v4}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 165
    :cond_0
    const/4 v3, 0x0

    if-eqz p4, :cond_1

    move/from16 v5, p1

    goto :goto_0

    :cond_1
    move v5, v3

    .line 166
    .local v5, "b0":I
    :goto_0
    if-eqz p5, :cond_2

    .line 167
    or-int/lit16 v5, v5, 0x80

    .line 169
    :cond_2
    iget-object v6, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v6, v5}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 171
    const/4 v6, 0x0

    .line 172
    .local v6, "b1":I
    iget-boolean v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->isClient:Z

    if-eqz v7, :cond_3

    .line 173
    or-int/lit16 v6, v6, 0x80

    .line 175
    :cond_3
    const-wide/16 v7, 0x7d

    cmp-long v7, v1, v7

    if-gtz v7, :cond_4

    .line 176
    long-to-int v7, v1

    or-int/2addr v6, v7

    .line 177
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v7, v6}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    goto :goto_1

    .line 178
    :cond_4
    const-wide/32 v7, 0xffff

    cmp-long v7, v1, v7

    if-gtz v7, :cond_5

    .line 179
    or-int/lit8 v6, v6, 0x7e

    .line 180
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v7, v6}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 181
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    long-to-int v8, v1

    invoke-interface {v7, v8}, Lokio/BufferedSink;->writeShort(I)Lokio/BufferedSink;

    goto :goto_1

    .line 183
    :cond_5
    or-int/lit8 v6, v6, 0x7f

    .line 184
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v7, v6}, Lokio/BufferedSink;->writeByte(I)Lokio/BufferedSink;

    .line 185
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v7, v1, v2}, Lokio/BufferedSink;->writeLong(J)Lokio/BufferedSink;

    .line 188
    :goto_1
    iget-boolean v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->isClient:Z

    if-eqz v7, :cond_7

    .line 189
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->random:Ljava/util/Random;

    iget-object v8, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    invoke-virtual {v7, v8}, Ljava/util/Random;->nextBytes([B)V

    .line 190
    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    iget-object v8, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    invoke-interface {v7, v8}, Lokio/BufferedSink;->write([B)Lokio/BufferedSink;

    .line 192
    const-wide/16 v7, 0x0

    .line 192
    .local v7, "written":J
    :goto_2
    cmp-long v9, v7, v1

    if-gez v9, :cond_8

    .line 193
    iget-object v9, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskBuffer:[B

    array-length v9, v9

    int-to-long v9, v9

    invoke-static {v1, v2, v9, v10}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v9

    long-to-int v13, v9

    .line 194
    .local v13, "toRead":I
    iget-object v9, v0, Lokhttp3/internal/ws/WebSocketWriter;->buffer:Lokio/Buffer;

    iget-object v10, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskBuffer:[B

    invoke-virtual {v9, v10, v3, v13}, Lokio/Buffer;->read([BII)I

    move-result v14

    .line 195
    .local v14, "read":I
    const/4 v9, -0x1

    if-ne v14, v9, :cond_6

    new-instance v3, Ljava/lang/AssertionError;

    invoke-direct {v3}, Ljava/lang/AssertionError;-><init>()V

    throw v3

    .line 196
    :cond_6
    iget-object v9, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskBuffer:[B

    int-to-long v10, v14

    iget-object v12, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskKey:[B

    move v15, v13

    move v3, v14

    move-wide v13, v7

    .line 196
    .end local v13    # "toRead":I
    .end local v14    # "read":I
    .local v3, "read":I
    .local v15, "toRead":I
    invoke-static/range {v9 .. v14}, Lokhttp3/internal/ws/WebSocketProtocol;->toggleMask([BJ[BJ)V

    .line 197
    iget-object v9, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    iget-object v10, v0, Lokhttp3/internal/ws/WebSocketWriter;->maskBuffer:[B

    const/4 v11, 0x0

    invoke-interface {v9, v10, v11, v3}, Lokio/BufferedSink;->write([BII)Lokio/BufferedSink;

    .line 198
    int-to-long v9, v3

    add-long/2addr v7, v9

    .line 199
    .end local v3    # "read":I
    .end local v15    # "toRead":I
    nop

    .line 192
    move v3, v11

    goto :goto_2

    .line 201
    .end local v7    # "written":J
    :cond_7
    iget-object v3, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    iget-object v7, v0, Lokhttp3/internal/ws/WebSocketWriter;->buffer:Lokio/Buffer;

    invoke-interface {v3, v7, v1, v2}, Lokio/BufferedSink;->write(Lokio/Buffer;J)V

    .line 204
    :cond_8
    iget-object v3, v0, Lokhttp3/internal/ws/WebSocketWriter;->sink:Lokio/BufferedSink;

    invoke-interface {v3}, Lokio/BufferedSink;->emit()Lokio/BufferedSink;

    .line 205
    return-void
.end method

.method writePing(Lokio/ByteString;)V
    .locals 1
    .param p1, "payload"    # Lokio/ByteString;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 75
    const/16 v0, 0x9

    invoke-direct {p0, v0, p1}, Lokhttp3/internal/ws/WebSocketWriter;->writeControlFrame(ILokio/ByteString;)V

    .line 76
    return-void
.end method

.method writePong(Lokio/ByteString;)V
    .locals 1
    .param p1, "payload"    # Lokio/ByteString;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 80
    const/16 v0, 0xa

    invoke-direct {p0, v0, p1}, Lokhttp3/internal/ws/WebSocketWriter;->writeControlFrame(ILokio/ByteString;)V

    .line 81
    return-void
.end method
