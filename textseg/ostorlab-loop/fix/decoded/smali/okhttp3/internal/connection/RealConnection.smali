.class public final Lokhttp3/internal/connection/RealConnection;
.super Lokhttp3/internal/http2/Http2Connection$Listener;
.source "RealConnection.java"

# interfaces
.implements Lokhttp3/Connection;


# static fields
.field private static final MAX_TUNNEL_ATTEMPTS:I = 0x15

.field private static final NPE_THROW_WITH_NULL:Ljava/lang/String; = "throw with null exception"


# instance fields
.field public allocationLimit:I

.field public final allocations:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/ref/Reference<",
            "Lokhttp3/internal/connection/StreamAllocation;",
            ">;>;"
        }
    .end annotation
.end field

.field private final connectionPool:Lokhttp3/ConnectionPool;

.field private handshake:Lokhttp3/Handshake;

.field private http2Connection:Lokhttp3/internal/http2/Http2Connection;

.field public idleAtNanos:J

.field public noNewStreams:Z

.field private protocol:Lokhttp3/Protocol;

.field private rawSocket:Ljava/net/Socket;

.field private final route:Lokhttp3/Route;

.field private sink:Lokio/BufferedSink;

.field private socket:Ljava/net/Socket;

.field private source:Lokio/BufferedSource;

.field public successCount:I


# direct methods
.method public constructor <init>(Lokhttp3/ConnectionPool;Lokhttp3/Route;)V
    .locals 2
    .param p1, "connectionPool"    # Lokhttp3/ConnectionPool;
    .param p2, "route"    # Lokhttp3/Route;

    .line 116
    invoke-direct {p0}, Lokhttp3/internal/http2/Http2Connection$Listener;-><init>()V

    .line 108
    const/4 v0, 0x1

    iput v0, p0, Lokhttp3/internal/connection/RealConnection;->allocationLimit:I

    .line 111
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lokhttp3/internal/connection/RealConnection;->allocations:Ljava/util/List;

    .line 114
    const-wide v0, 0x7fffffffffffffffL

    iput-wide v0, p0, Lokhttp3/internal/connection/RealConnection;->idleAtNanos:J

    .line 117
    iput-object p1, p0, Lokhttp3/internal/connection/RealConnection;->connectionPool:Lokhttp3/ConnectionPool;

    .line 118
    iput-object p2, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 119
    return-void
.end method

.method private connectSocket(IILokhttp3/Call;Lokhttp3/EventListener;)V
    .locals 6
    .param p1, "connectTimeout"    # I
    .param p2, "readTimeout"    # I
    .param p3, "call"    # Lokhttp3/Call;
    .param p4, "eventListener"    # Lokhttp3/EventListener;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 228
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v0}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v0

    .line 229
    .local v0, "proxy":Ljava/net/Proxy;
    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    .line 231
    .local v1, "address":Lokhttp3/Address;
    invoke-virtual {v0}, Ljava/net/Proxy;->type()Ljava/net/Proxy$Type;

    move-result-object v2

    sget-object v3, Ljava/net/Proxy$Type;->DIRECT:Ljava/net/Proxy$Type;

    if-eq v2, v3, :cond_1

    invoke-virtual {v0}, Ljava/net/Proxy;->type()Ljava/net/Proxy$Type;

    move-result-object v2

    sget-object v3, Ljava/net/Proxy$Type;->HTTP:Ljava/net/Proxy$Type;

    if-ne v2, v3, :cond_0

    goto :goto_0

    .line 233
    :cond_0
    new-instance v2, Ljava/net/Socket;

    invoke-direct {v2, v0}, Ljava/net/Socket;-><init>(Ljava/net/Proxy;)V

    goto :goto_1

    .line 232
    :cond_1
    :goto_0
    invoke-virtual {v1}, Lokhttp3/Address;->socketFactory()Ljavax/net/SocketFactory;

    move-result-object v2

    invoke-virtual {v2}, Ljavax/net/SocketFactory;->createSocket()Ljava/net/Socket;

    move-result-object v2

    .line 233
    :goto_1
    iput-object v2, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    .line 235
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v2}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v2

    invoke-virtual {p4, p3, v2, v0}, Lokhttp3/EventListener;->connectStart(Lokhttp3/Call;Ljava/net/InetSocketAddress;Ljava/net/Proxy;)V

    .line 236
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-virtual {v2, p2}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 238
    :try_start_0
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v2

    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v4}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v4

    invoke-virtual {v2, v3, v4, p1}, Lokhttp3/internal/platform/Platform;->connectSocket(Ljava/net/Socket;Ljava/net/InetSocketAddress;I)V
    :try_end_0
    .catch Ljava/net/ConnectException; {:try_start_0 .. :try_end_0} :catch_1

    .line 243
    nop

    .line 250
    :try_start_1
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-static {v2}, Lokio/Okio;->source(Ljava/net/Socket;)Lokio/Source;

    move-result-object v2

    invoke-static {v2}, Lokio/Okio;->buffer(Lokio/Source;)Lokio/BufferedSource;

    move-result-object v2

    iput-object v2, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    .line 251
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-static {v2}, Lokio/Okio;->sink(Ljava/net/Socket;)Lokio/Sink;

    move-result-object v2

    invoke-static {v2}, Lokio/Okio;->buffer(Lokio/Sink;)Lokio/BufferedSink;

    move-result-object v2

    iput-object v2, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;
    :try_end_1
    .catch Ljava/lang/NullPointerException; {:try_start_1 .. :try_end_1} :catch_0

    .line 256
    goto :goto_2

    .line 252
    :catch_0
    move-exception v2

    .line 253
    .local v2, "npe":Ljava/lang/NullPointerException;
    const-string v3, "throw with null exception"

    invoke-virtual {v2}, Ljava/lang/NullPointerException;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 254
    new-instance v3, Ljava/io/IOException;

    invoke-direct {v3, v2}, Ljava/io/IOException;-><init>(Ljava/lang/Throwable;)V

    throw v3

    .line 257
    .end local v2    # "npe":Ljava/lang/NullPointerException;
    :cond_2
    :goto_2
    return-void

    .line 239
    :catch_1
    move-exception v2

    .line 240
    .local v2, "e":Ljava/net/ConnectException;
    new-instance v3, Ljava/net/ConnectException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Failed to connect to "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v5}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/net/ConnectException;-><init>(Ljava/lang/String;)V

    .line 241
    .local v3, "ce":Ljava/net/ConnectException;
    invoke-virtual {v3, v2}, Ljava/net/ConnectException;->initCause(Ljava/lang/Throwable;)Ljava/lang/Throwable;

    .line 242
    throw v3
.end method

.method private connectTls(Lokhttp3/internal/connection/ConnectionSpecSelector;)V
    .locals 10
    .param p1, "connectionSpecSelector"    # Lokhttp3/internal/connection/ConnectionSpecSelector;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 282
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v0}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v0

    .line 283
    .local v0, "address":Lokhttp3/Address;
    invoke-virtual {v0}, Lokhttp3/Address;->sslSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v1

    .line 284
    .local v1, "sslSocketFactory":Ljavax/net/ssl/SSLSocketFactory;
    const/4 v2, 0x0

    .line 285
    .local v2, "success":Z
    const/4 v3, 0x0

    move-object v4, v3

    .line 288
    .local v4, "sslSocket":Ljavax/net/ssl/SSLSocket;
    :try_start_0
    iget-object v5, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    .line 289
    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v6

    invoke-virtual {v6}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v7

    invoke-virtual {v7}, Lokhttp3/HttpUrl;->port()I

    move-result v7

    const/4 v8, 0x1

    .line 288
    invoke-virtual {v1, v5, v6, v7, v8}, Ljavax/net/ssl/SSLSocketFactory;->createSocket(Ljava/net/Socket;Ljava/lang/String;IZ)Ljava/net/Socket;

    move-result-object v5

    check-cast v5, Ljavax/net/ssl/SSLSocket;

    move-object v4, v5

    .line 292
    invoke-virtual {p1, v4}, Lokhttp3/internal/connection/ConnectionSpecSelector;->configureSecureSocket(Ljavax/net/ssl/SSLSocket;)Lokhttp3/ConnectionSpec;

    move-result-object v5

    .line 293
    .local v5, "connectionSpec":Lokhttp3/ConnectionSpec;
    invoke-virtual {v5}, Lokhttp3/ConnectionSpec;->supportsTlsExtensions()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 294
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v6

    .line 295
    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v7

    invoke-virtual {v7}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0}, Lokhttp3/Address;->protocols()Ljava/util/List;

    move-result-object v8

    .line 294
    invoke-virtual {v6, v4, v7, v8}, Lokhttp3/internal/platform/Platform;->configureTlsExtensions(Ljavax/net/ssl/SSLSocket;Ljava/lang/String;Ljava/util/List;)V

    .line 299
    :cond_0
    invoke-virtual {v4}, Ljavax/net/ssl/SSLSocket;->startHandshake()V

    .line 300
    invoke-virtual {v4}, Ljavax/net/ssl/SSLSocket;->getSession()Ljavax/net/ssl/SSLSession;

    move-result-object v6

    invoke-static {v6}, Lokhttp3/Handshake;->get(Ljavax/net/ssl/SSLSession;)Lokhttp3/Handshake;

    move-result-object v6

    .line 303
    .local v6, "unverifiedHandshake":Lokhttp3/Handshake;
    invoke-virtual {v0}, Lokhttp3/Address;->hostnameVerifier()Ljavax/net/ssl/HostnameVerifier;

    move-result-object v7

    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v8

    invoke-virtual {v8}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v4}, Ljavax/net/ssl/SSLSocket;->getSession()Ljavax/net/ssl/SSLSession;

    move-result-object v9

    invoke-interface {v7, v8, v9}, Ljavax/net/ssl/HostnameVerifier;->verify(Ljava/lang/String;Ljavax/net/ssl/SSLSession;)Z

    move-result v7

    if-nez v7, :cond_1

    .line 304
    invoke-virtual {v6}, Lokhttp3/Handshake;->peerCertificates()Ljava/util/List;

    move-result-object v3

    const/4 v7, 0x0

    invoke-interface {v3, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/security/cert/X509Certificate;

    .line 305
    .local v3, "cert":Ljava/security/cert/X509Certificate;
    new-instance v7, Ljavax/net/ssl/SSLPeerUnverifiedException;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "Hostname "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v9

    invoke-virtual {v9}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, " not verified:\n    certificate: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 306
    invoke-static {v3}, Lokhttp3/CertificatePinner;->pin(Ljava/security/cert/Certificate;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "\n    DN: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 307
    invoke-virtual {v3}, Ljava/security/cert/X509Certificate;->getSubjectDN()Ljava/security/Principal;

    move-result-object v9

    invoke-interface {v9}, Ljava/security/Principal;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "\n    subjectAltNames: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 308
    invoke-static {v3}, Lokhttp3/internal/tls/OkHostnameVerifier;->allSubjectAltNames(Ljava/security/cert/X509Certificate;)Ljava/util/List;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-direct {v7, v8}, Ljavax/net/ssl/SSLPeerUnverifiedException;-><init>(Ljava/lang/String;)V

    throw v7

    .line 312
    .end local v3    # "cert":Ljava/security/cert/X509Certificate;
    :cond_1
    invoke-virtual {v0}, Lokhttp3/Address;->certificatePinner()Lokhttp3/CertificatePinner;

    move-result-object v7

    invoke-virtual {v0}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v8

    invoke-virtual {v8}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v8

    .line 313
    invoke-virtual {v6}, Lokhttp3/Handshake;->peerCertificates()Ljava/util/List;

    move-result-object v9

    .line 312
    invoke-virtual {v7, v8, v9}, Lokhttp3/CertificatePinner;->check(Ljava/lang/String;Ljava/util/List;)V

    .line 316
    invoke-virtual {v5}, Lokhttp3/ConnectionSpec;->supportsTlsExtensions()Z

    move-result v7

    if-eqz v7, :cond_2

    .line 317
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v3

    invoke-virtual {v3, v4}, Lokhttp3/internal/platform/Platform;->getSelectedProtocol(Ljavax/net/ssl/SSLSocket;)Ljava/lang/String;

    move-result-object v3

    goto :goto_0

    .line 318
    :cond_2
    nop

    .line 319
    .local v3, "maybeProtocol":Ljava/lang/String;
    :goto_0
    iput-object v4, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    .line 320
    iget-object v7, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-static {v7}, Lokio/Okio;->source(Ljava/net/Socket;)Lokio/Source;

    move-result-object v7

    invoke-static {v7}, Lokio/Okio;->buffer(Lokio/Source;)Lokio/BufferedSource;

    move-result-object v7

    iput-object v7, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    .line 321
    iget-object v7, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-static {v7}, Lokio/Okio;->sink(Ljava/net/Socket;)Lokio/Sink;

    move-result-object v7

    invoke-static {v7}, Lokio/Okio;->buffer(Lokio/Sink;)Lokio/BufferedSink;

    move-result-object v7

    iput-object v7, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    .line 322
    iput-object v6, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    .line 323
    if-eqz v3, :cond_3

    .line 324
    invoke-static {v3}, Lokhttp3/Protocol;->get(Ljava/lang/String;)Lokhttp3/Protocol;

    move-result-object v7

    goto :goto_1

    .line 325
    :cond_3
    sget-object v7, Lokhttp3/Protocol;->HTTP_1_1:Lokhttp3/Protocol;

    :goto_1
    iput-object v7, p0, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;
    :try_end_0
    .catch Ljava/lang/AssertionError; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 326
    const/4 v2, 0x1

    .line 331
    .end local v3    # "maybeProtocol":Ljava/lang/String;
    .end local v5    # "connectionSpec":Lokhttp3/ConnectionSpec;
    .end local v6    # "unverifiedHandshake":Lokhttp3/Handshake;
    if-eqz v4, :cond_4

    .line 332
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v3

    invoke-virtual {v3, v4}, Lokhttp3/internal/platform/Platform;->afterHandshake(Ljavax/net/ssl/SSLSocket;)V

    .line 334
    :cond_4
    if-nez v2, :cond_5

    .line 335
    invoke-static {v4}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    .line 338
    :cond_5
    return-void

    .line 331
    :catchall_0
    move-exception v3

    goto :goto_2

    .line 327
    :catch_0
    move-exception v3

    .line 328
    .local v3, "e":Ljava/lang/AssertionError;
    :try_start_1
    invoke-static {v3}, Lokhttp3/internal/Util;->isAndroidGetsocknameError(Ljava/lang/AssertionError;)Z

    move-result v5

    if-eqz v5, :cond_6

    new-instance v5, Ljava/io/IOException;

    invoke-direct {v5, v3}, Ljava/io/IOException;-><init>(Ljava/lang/Throwable;)V

    throw v5

    .line 329
    :cond_6
    throw v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 331
    .end local v3    # "e":Ljava/lang/AssertionError;
    :goto_2
    if-eqz v4, :cond_7

    .line 332
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v5

    invoke-virtual {v5, v4}, Lokhttp3/internal/platform/Platform;->afterHandshake(Ljavax/net/ssl/SSLSocket;)V

    .line 334
    :cond_7
    if-nez v2, :cond_8

    .line 335
    invoke-static {v4}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    :cond_8
    throw v3
.end method

.method private connectTunnel(IIILokhttp3/Call;Lokhttp3/EventListener;)V
    .locals 6
    .param p1, "connectTimeout"    # I
    .param p2, "readTimeout"    # I
    .param p3, "writeTimeout"    # I
    .param p4, "call"    # Lokhttp3/Call;
    .param p5, "eventListener"    # Lokhttp3/EventListener;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 207
    invoke-direct {p0}, Lokhttp3/internal/connection/RealConnection;->createTunnelRequest()Lokhttp3/Request;

    move-result-object v0

    .line 208
    .local v0, "tunnelRequest":Lokhttp3/Request;
    invoke-virtual {v0}, Lokhttp3/Request;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    .line 209
    .local v1, "url":Lokhttp3/HttpUrl;
    const/4 v2, 0x0

    .line 209
    .local v2, "i":I
    :goto_0
    const/16 v3, 0x15

    if-ge v2, v3, :cond_1

    .line 210
    invoke-direct {p0, p1, p2, p4, p5}, Lokhttp3/internal/connection/RealConnection;->connectSocket(IILokhttp3/Call;Lokhttp3/EventListener;)V

    .line 211
    invoke-direct {p0, p2, p3, v0, v1}, Lokhttp3/internal/connection/RealConnection;->createTunnel(IILokhttp3/Request;Lokhttp3/HttpUrl;)Lokhttp3/Request;

    move-result-object v0

    .line 213
    if-nez v0, :cond_0

    .line 213
    .end local v2    # "i":I
    goto :goto_1

    .line 217
    .restart local v2    # "i":I
    :cond_0
    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-static {v3}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    .line 218
    const/4 v3, 0x0

    iput-object v3, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    .line 219
    iput-object v3, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    .line 220
    iput-object v3, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    .line 221
    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v4}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v4

    iget-object v5, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v5}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v5

    invoke-virtual {p5, p4, v4, v5, v3}, Lokhttp3/EventListener;->connectEnd(Lokhttp3/Call;Ljava/net/InetSocketAddress;Ljava/net/Proxy;Lokhttp3/Protocol;)V

    .line 209
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 223
    .end local v2    # "i":I
    :cond_1
    :goto_1
    return-void
.end method

.method private createTunnel(IILokhttp3/Request;Lokhttp3/HttpUrl;)Lokhttp3/Request;
    .locals 9
    .param p1, "readTimeout"    # I
    .param p2, "writeTimeout"    # I
    .param p3, "tunnelRequest"    # Lokhttp3/Request;
    .param p4, "url"    # Lokhttp3/HttpUrl;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 347
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CONNECT "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x1

    invoke-static {p4, v1}, Lokhttp3/internal/Util;->hostHeader(Lokhttp3/HttpUrl;Z)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " HTTP/1.1"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 349
    .local v0, "requestLine":Ljava/lang/String;
    :goto_0
    new-instance v1, Lokhttp3/internal/http1/Http1Codec;

    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    const/4 v4, 0x0

    invoke-direct {v1, v4, v4, v2, v3}, Lokhttp3/internal/http1/Http1Codec;-><init>(Lokhttp3/OkHttpClient;Lokhttp3/internal/connection/StreamAllocation;Lokio/BufferedSource;Lokio/BufferedSink;)V

    .line 350
    .local v1, "tunnelConnection":Lokhttp3/internal/http1/Http1Codec;
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    invoke-interface {v2}, Lokio/BufferedSource;->timeout()Lokio/Timeout;

    move-result-object v2

    int-to-long v5, p1

    sget-object v3, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v2, v5, v6, v3}, Lokio/Timeout;->timeout(JLjava/util/concurrent/TimeUnit;)Lokio/Timeout;

    .line 351
    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-interface {v2}, Lokio/BufferedSink;->timeout()Lokio/Timeout;

    move-result-object v2

    int-to-long v5, p2

    sget-object v3, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v2, v5, v6, v3}, Lokio/Timeout;->timeout(JLjava/util/concurrent/TimeUnit;)Lokio/Timeout;

    .line 352
    invoke-virtual {p3}, Lokhttp3/Request;->headers()Lokhttp3/Headers;

    move-result-object v2

    invoke-virtual {v1, v2, v0}, Lokhttp3/internal/http1/Http1Codec;->writeRequest(Lokhttp3/Headers;Ljava/lang/String;)V

    .line 353
    invoke-virtual {v1}, Lokhttp3/internal/http1/Http1Codec;->finishRequest()V

    .line 354
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lokhttp3/internal/http1/Http1Codec;->readResponseHeaders(Z)Lokhttp3/Response$Builder;

    move-result-object v2

    .line 355
    invoke-virtual {v2, p3}, Lokhttp3/Response$Builder;->request(Lokhttp3/Request;)Lokhttp3/Response$Builder;

    move-result-object v2

    .line 356
    invoke-virtual {v2}, Lokhttp3/Response$Builder;->build()Lokhttp3/Response;

    move-result-object v2

    .line 359
    .local v2, "response":Lokhttp3/Response;
    invoke-static {v2}, Lokhttp3/internal/http/HttpHeaders;->contentLength(Lokhttp3/Response;)J

    move-result-wide v5

    .line 360
    .local v5, "contentLength":J
    const-wide/16 v7, -0x1

    cmp-long v3, v5, v7

    if-nez v3, :cond_0

    .line 361
    const-wide/16 v5, 0x0

    .line 363
    :cond_0
    invoke-virtual {v1, v5, v6}, Lokhttp3/internal/http1/Http1Codec;->newFixedLengthSource(J)Lokio/Source;

    move-result-object v3

    .line 364
    .local v3, "body":Lokio/Source;
    const v7, 0x7fffffff

    sget-object v8, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-static {v3, v7, v8}, Lokhttp3/internal/Util;->skipAll(Lokio/Source;ILjava/util/concurrent/TimeUnit;)Z

    .line 365
    invoke-interface {v3}, Lokio/Source;->close()V

    .line 367
    invoke-virtual {v2}, Lokhttp3/Response;->code()I

    move-result v7

    const/16 v8, 0xc8

    if-eq v7, v8, :cond_4

    const/16 v4, 0x197

    if-eq v7, v4, :cond_1

    .line 388
    new-instance v4, Ljava/io/IOException;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Unexpected response code for CONNECT: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 389
    invoke-virtual {v2}, Lokhttp3/Response;->code()I

    move-result v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-direct {v4, v7}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 379
    :cond_1
    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v4}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v4

    invoke-virtual {v4}, Lokhttp3/Address;->proxyAuthenticator()Lokhttp3/Authenticator;

    move-result-object v4

    iget-object v7, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-interface {v4, v7, v2}, Lokhttp3/Authenticator;->authenticate(Lokhttp3/Route;Lokhttp3/Response;)Lokhttp3/Request;

    move-result-object p3

    .line 380
    if-nez p3, :cond_2

    new-instance v4, Ljava/io/IOException;

    const-string v7, "Failed to authenticate with proxy"

    invoke-direct {v4, v7}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 382
    :cond_2
    const-string v4, "close"

    const-string v7, "Connection"

    invoke-virtual {v2, v7}, Lokhttp3/Response;->header(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v4, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 383
    return-object p3

    .line 391
    .end local v1    # "tunnelConnection":Lokhttp3/internal/http1/Http1Codec;
    .end local v2    # "response":Lokhttp3/Response;
    .end local v3    # "body":Lokio/Source;
    .end local v5    # "contentLength":J
    :cond_3
    goto/16 :goto_0

    .line 373
    .restart local v1    # "tunnelConnection":Lokhttp3/internal/http1/Http1Codec;
    .restart local v2    # "response":Lokhttp3/Response;
    .restart local v3    # "body":Lokio/Source;
    .restart local v5    # "contentLength":J
    :cond_4
    iget-object v7, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    invoke-interface {v7}, Lokio/BufferedSource;->buffer()Lokio/Buffer;

    move-result-object v7

    invoke-virtual {v7}, Lokio/Buffer;->exhausted()Z

    move-result v7

    if-eqz v7, :cond_6

    iget-object v7, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-interface {v7}, Lokio/BufferedSink;->buffer()Lokio/Buffer;

    move-result-object v7

    invoke-virtual {v7}, Lokio/Buffer;->exhausted()Z

    move-result v7

    if-nez v7, :cond_5

    goto :goto_1

    .line 376
    :cond_5
    return-object v4

    .line 374
    :cond_6
    :goto_1
    new-instance v4, Ljava/io/IOException;

    const-string v7, "TLS tunnel buffered too many bytes!"

    invoke-direct {v4, v7}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v4
.end method

.method private createTunnelRequest()Lokhttp3/Request;
    .locals 4

    .line 400
    new-instance v0, Lokhttp3/Request$Builder;

    invoke-direct {v0}, Lokhttp3/Request$Builder;-><init>()V

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 401
    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v0, v1}, Lokhttp3/Request$Builder;->url(Lokhttp3/HttpUrl;)Lokhttp3/Request$Builder;

    move-result-object v0

    const-string v1, "Host"

    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 402
    invoke-virtual {v2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v2

    const/4 v3, 0x1

    invoke-static {v2, v3}, Lokhttp3/internal/Util;->hostHeader(Lokhttp3/HttpUrl;Z)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lokhttp3/Request$Builder;->header(Ljava/lang/String;Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v0

    const-string v1, "Proxy-Connection"

    const-string v2, "Keep-Alive"

    .line 403
    invoke-virtual {v0, v1, v2}, Lokhttp3/Request$Builder;->header(Ljava/lang/String;Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v0

    const-string v1, "User-Agent"

    .line 404
    invoke-static {}, Lokhttp3/internal/Version;->userAgent()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lokhttp3/Request$Builder;->header(Ljava/lang/String;Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v0

    .line 405
    invoke-virtual {v0}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v0

    .line 400
    return-object v0
.end method

.method private establishProtocol(Lokhttp3/internal/connection/ConnectionSpecSelector;Lokhttp3/Call;Lokhttp3/EventListener;)V
    .locals 5
    .param p1, "connectionSpecSelector"    # Lokhttp3/internal/connection/ConnectionSpecSelector;
    .param p2, "call"    # Lokhttp3/Call;
    .param p3, "eventListener"    # Lokhttp3/EventListener;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 261
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v0}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v0

    invoke-virtual {v0}, Lokhttp3/Address;->sslSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v0

    if-nez v0, :cond_0

    .line 262
    sget-object v0, Lokhttp3/Protocol;->HTTP_1_1:Lokhttp3/Protocol;

    iput-object v0, p0, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    .line 263
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    iput-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    .line 264
    return-void

    .line 267
    :cond_0
    invoke-virtual {p3, p2}, Lokhttp3/EventListener;->secureConnectStart(Lokhttp3/Call;)V

    .line 268
    invoke-direct {p0, p1}, Lokhttp3/internal/connection/RealConnection;->connectTls(Lokhttp3/internal/connection/ConnectionSpecSelector;)V

    .line 269
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    invoke-virtual {p3, p2, v0}, Lokhttp3/EventListener;->secureConnectEnd(Lokhttp3/Call;Lokhttp3/Handshake;)V

    .line 271
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    sget-object v1, Lokhttp3/Protocol;->HTTP_2:Lokhttp3/Protocol;

    if-ne v0, v1, :cond_1

    .line 272
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 273
    new-instance v0, Lokhttp3/internal/http2/Http2Connection$Builder;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Lokhttp3/internal/http2/Http2Connection$Builder;-><init>(Z)V

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 274
    invoke-virtual {v2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-virtual {v0, v1, v2, v3, v4}, Lokhttp3/internal/http2/Http2Connection$Builder;->socket(Ljava/net/Socket;Ljava/lang/String;Lokio/BufferedSource;Lokio/BufferedSink;)Lokhttp3/internal/http2/Http2Connection$Builder;

    move-result-object v0

    .line 275
    invoke-virtual {v0, p0}, Lokhttp3/internal/http2/Http2Connection$Builder;->listener(Lokhttp3/internal/http2/Http2Connection$Listener;)Lokhttp3/internal/http2/Http2Connection$Builder;

    move-result-object v0

    .line 276
    invoke-virtual {v0}, Lokhttp3/internal/http2/Http2Connection$Builder;->build()Lokhttp3/internal/http2/Http2Connection;

    move-result-object v0

    iput-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    .line 277
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    invoke-virtual {v0}, Lokhttp3/internal/http2/Http2Connection;->start()V

    .line 279
    :cond_1
    return-void
.end method

.method public static testConnection(Lokhttp3/ConnectionPool;Lokhttp3/Route;Ljava/net/Socket;J)Lokhttp3/internal/connection/RealConnection;
    .locals 1
    .param p0, "connectionPool"    # Lokhttp3/ConnectionPool;
    .param p1, "route"    # Lokhttp3/Route;
    .param p2, "socket"    # Ljava/net/Socket;
    .param p3, "idleAtNanos"    # J

    .line 123
    new-instance v0, Lokhttp3/internal/connection/RealConnection;

    invoke-direct {v0, p0, p1}, Lokhttp3/internal/connection/RealConnection;-><init>(Lokhttp3/ConnectionPool;Lokhttp3/Route;)V

    .line 124
    .local v0, "result":Lokhttp3/internal/connection/RealConnection;
    iput-object p2, v0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    .line 125
    iput-wide p3, v0, Lokhttp3/internal/connection/RealConnection;->idleAtNanos:J

    .line 126
    return-object v0
.end method


# virtual methods
.method public cancel()V
    .locals 1

    .line 494
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-static {v0}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    .line 495
    return-void
.end method

.method public connect(IIIZLokhttp3/Call;Lokhttp3/EventListener;)V
    .locals 16
    .param p1, "connectTimeout"    # I
    .param p2, "readTimeout"    # I
    .param p3, "writeTimeout"    # I
    .param p4, "connectionRetryEnabled"    # Z
    .param p5, "call"    # Lokhttp3/Call;
    .param p6, "eventListener"    # Lokhttp3/EventListener;

    move-object/from16 v7, p0

    move-object/from16 v8, p5

    .line 131
    move-object/from16 v9, p6

    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    if-eqz v1, :cond_0

    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "already connected"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 133
    :cond_0
    const/4 v1, 0x0

    .line 134
    .local v1, "routeException":Lokhttp3/internal/connection/RouteException;
    iget-object v2, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/Address;->connectionSpecs()Ljava/util/List;

    move-result-object v10

    .line 135
    .local v10, "connectionSpecs":Ljava/util/List;, "Ljava/util/List<Lokhttp3/ConnectionSpec;>;"
    new-instance v2, Lokhttp3/internal/connection/ConnectionSpecSelector;

    invoke-direct {v2, v10}, Lokhttp3/internal/connection/ConnectionSpecSelector;-><init>(Ljava/util/List;)V

    move-object v11, v2

    .line 137
    .local v11, "connectionSpecSelector":Lokhttp3/internal/connection/ConnectionSpecSelector;
    iget-object v2, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/Address;->sslSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v2

    if-nez v2, :cond_2

    .line 138
    sget-object v2, Lokhttp3/ConnectionSpec;->CLEARTEXT:Lokhttp3/ConnectionSpec;

    invoke-interface {v10, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 139
    new-instance v2, Lokhttp3/internal/connection/RouteException;

    new-instance v3, Ljava/net/UnknownServiceException;

    const-string v4, "CLEARTEXT communication not enabled for client"

    invoke-direct {v3, v4}, Ljava/net/UnknownServiceException;-><init>(Ljava/lang/String;)V

    invoke-direct {v2, v3}, Lokhttp3/internal/connection/RouteException;-><init>(Ljava/io/IOException;)V

    throw v2

    .line 142
    :cond_1
    iget-object v2, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v2

    invoke-virtual {v2}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v2

    .line 143
    .local v2, "host":Ljava/lang/String;
    invoke-static {}, Lokhttp3/internal/platform/Platform;->get()Lokhttp3/internal/platform/Platform;

    move-result-object v3

    invoke-virtual {v3, v2}, Lokhttp3/internal/platform/Platform;->isCleartextTrafficPermitted(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 144
    new-instance v3, Lokhttp3/internal/connection/RouteException;

    new-instance v4, Ljava/net/UnknownServiceException;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CLEARTEXT communication to "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " not permitted by network security policy"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/net/UnknownServiceException;-><init>(Ljava/lang/String;)V

    invoke-direct {v3, v4}, Lokhttp3/internal/connection/RouteException;-><init>(Ljava/io/IOException;)V

    throw v3

    .line 151
    .end local v2    # "host":Ljava/lang/String;
    :cond_2
    move-object v12, v1

    .line 151
    .end local v1    # "routeException":Lokhttp3/internal/connection/RouteException;
    .local v12, "routeException":Lokhttp3/internal/connection/RouteException;
    :goto_0
    :try_start_0
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->requiresTunnel()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 152
    move-object v1, v7

    move/from16 v2, p1

    move/from16 v3, p2

    move/from16 v4, p3

    move-object v5, v8

    move-object v6, v9

    invoke-direct/range {v1 .. v6}, Lokhttp3/internal/connection/RealConnection;->connectTunnel(IIILokhttp3/Call;Lokhttp3/EventListener;)V

    .line 153
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    if-nez v1, :cond_3

    .line 155
    nop

    .line 188
    move/from16 v13, p1

    move/from16 v14, p2

    goto :goto_2

    .line 160
    :cond_3
    move/from16 v13, p1

    move/from16 v14, p2

    goto :goto_1

    .line 158
    :cond_4
    move/from16 v13, p1

    move/from16 v14, p2

    :try_start_1
    invoke-direct {v7, v13, v14, v8, v9}, Lokhttp3/internal/connection/RealConnection;->connectSocket(IILokhttp3/Call;Lokhttp3/EventListener;)V

    .line 160
    :goto_1
    invoke-direct {v7, v11, v8, v9}, Lokhttp3/internal/connection/RealConnection;->establishProtocol(Lokhttp3/internal/connection/ConnectionSpecSelector;Lokhttp3/Call;Lokhttp3/EventListener;)V

    .line 161
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v1

    iget-object v2, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v2}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v2

    iget-object v3, v7, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    invoke-virtual {v9, v8, v1, v2, v3}, Lokhttp3/EventListener;->connectEnd(Lokhttp3/Call;Ljava/net/InetSocketAddress;Ljava/net/Proxy;Lokhttp3/Protocol;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 162
    nop

    .line 188
    :goto_2
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->requiresTunnel()Z

    move-result v1

    if-eqz v1, :cond_5

    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    if-nez v1, :cond_5

    .line 189
    new-instance v1, Ljava/net/ProtocolException;

    const-string v2, "Too many tunnel connections attempted: 21"

    invoke-direct {v1, v2}, Ljava/net/ProtocolException;-><init>(Ljava/lang/String;)V

    .line 191
    .local v1, "exception":Ljava/net/ProtocolException;
    new-instance v2, Lokhttp3/internal/connection/RouteException;

    invoke-direct {v2, v1}, Lokhttp3/internal/connection/RouteException;-><init>(Ljava/io/IOException;)V

    throw v2

    .line 194
    .end local v1    # "exception":Ljava/net/ProtocolException;
    :cond_5
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    if-eqz v1, :cond_6

    .line 195
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->connectionPool:Lokhttp3/ConnectionPool;

    monitor-enter v1

    .line 196
    :try_start_2
    iget-object v2, v7, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    invoke-virtual {v2}, Lokhttp3/internal/http2/Http2Connection;->maxConcurrentStreams()I

    move-result v2

    iput v2, v7, Lokhttp3/internal/connection/RealConnection;->allocationLimit:I

    .line 197
    monitor-exit v1

    goto :goto_3

    :catchall_0
    move-exception v0

    move-object v2, v0

    monitor-exit v1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v2

    .line 199
    :cond_6
    :goto_3
    return-void

    .line 163
    :catch_0
    move-exception v0

    goto :goto_4

    :catch_1
    move-exception v0

    move/from16 v13, p1

    move/from16 v14, p2

    :goto_4
    move-object v1, v0

    move-object v15, v1

    .line 164
    .local v15, "e":Ljava/io/IOException;
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-static {v1}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    .line 165
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    invoke-static {v1}, Lokhttp3/internal/Util;->closeQuietly(Ljava/net/Socket;)V

    .line 166
    const/4 v1, 0x0

    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    .line 167
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->rawSocket:Ljava/net/Socket;

    .line 168
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    .line 169
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    .line 170
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    .line 171
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    .line 172
    iput-object v1, v7, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    .line 174
    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v3

    iget-object v1, v7, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v4

    const/4 v5, 0x0

    move-object v1, v9

    move-object v2, v8

    move-object v6, v15

    invoke-virtual/range {v1 .. v6}, Lokhttp3/EventListener;->connectFailed(Lokhttp3/Call;Ljava/net/InetSocketAddress;Ljava/net/Proxy;Lokhttp3/Protocol;Ljava/io/IOException;)V

    .line 176
    if-nez v12, :cond_7

    .line 177
    new-instance v1, Lokhttp3/internal/connection/RouteException;

    invoke-direct {v1, v15}, Lokhttp3/internal/connection/RouteException;-><init>(Ljava/io/IOException;)V

    .line 182
    .end local v12    # "routeException":Lokhttp3/internal/connection/RouteException;
    .local v1, "routeException":Lokhttp3/internal/connection/RouteException;
    move-object v12, v1

    goto :goto_5

    .line 179
    .end local v1    # "routeException":Lokhttp3/internal/connection/RouteException;
    .restart local v12    # "routeException":Lokhttp3/internal/connection/RouteException;
    :cond_7
    invoke-virtual {v12, v15}, Lokhttp3/internal/connection/RouteException;->addConnectException(Ljava/io/IOException;)V

    .line 182
    :goto_5
    if-eqz p4, :cond_9

    invoke-virtual {v11, v15}, Lokhttp3/internal/connection/ConnectionSpecSelector;->connectionFailed(Ljava/io/IOException;)Z

    move-result v2

    if-nez v2, :cond_8

    goto :goto_6

    .line 185
    .end local v15    # "e":Ljava/io/IOException;
    :cond_8
    goto/16 :goto_0

    .line 183
    .restart local v15    # "e":Ljava/io/IOException;
    :cond_9
    :goto_6
    throw v12
.end method

.method public handshake()Lokhttp3/Handshake;
    .locals 1

    .line 546
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    return-object v0
.end method

.method public isEligible(Lokhttp3/Address;Lokhttp3/Route;)Z
    .locals 5
    .param p1, "address"    # Lokhttp3/Address;
    .param p2, "route"    # Lokhttp3/Route;
        .annotation runtime Ljavax/annotation/Nullable;
        .end annotation
    .end param

    .line 414
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->allocations:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    iget v1, p0, Lokhttp3/internal/connection/RealConnection;->allocationLimit:I

    const/4 v2, 0x0

    if-ge v0, v1, :cond_a

    iget-boolean v0, p0, Lokhttp3/internal/connection/RealConnection;->noNewStreams:Z

    if-eqz v0, :cond_0

    goto/16 :goto_0

    .line 417
    :cond_0
    sget-object v0, Lokhttp3/internal/Internal;->instance:Lokhttp3/internal/Internal;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Lokhttp3/internal/Internal;->equalsNonHost(Lokhttp3/Address;Lokhttp3/Address;)Z

    move-result v0

    if-nez v0, :cond_1

    return v2

    .line 420
    :cond_1
    invoke-virtual {p1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v0

    invoke-virtual {v0}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0}, Lokhttp3/internal/connection/RealConnection;->route()Lokhttp3/Route;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    .line 421
    return v1

    .line 430
    :cond_2
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    if-nez v0, :cond_3

    return v2

    .line 435
    :cond_3
    if-nez p2, :cond_4

    return v2

    .line 436
    :cond_4
    invoke-virtual {p2}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v0

    invoke-virtual {v0}, Ljava/net/Proxy;->type()Ljava/net/Proxy$Type;

    move-result-object v0

    sget-object v3, Ljava/net/Proxy$Type;->DIRECT:Ljava/net/Proxy$Type;

    if-eq v0, v3, :cond_5

    return v2

    .line 437
    :cond_5
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v0}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v0

    invoke-virtual {v0}, Ljava/net/Proxy;->type()Ljava/net/Proxy$Type;

    move-result-object v0

    sget-object v3, Ljava/net/Proxy$Type;->DIRECT:Ljava/net/Proxy$Type;

    if-eq v0, v3, :cond_6

    return v2

    .line 438
    :cond_6
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v0}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v0

    invoke-virtual {p2}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/net/InetSocketAddress;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_7

    return v2

    .line 441
    :cond_7
    invoke-virtual {p2}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v0

    invoke-virtual {v0}, Lokhttp3/Address;->hostnameVerifier()Ljavax/net/ssl/HostnameVerifier;

    move-result-object v0

    sget-object v3, Lokhttp3/internal/tls/OkHostnameVerifier;->INSTANCE:Lokhttp3/internal/tls/OkHostnameVerifier;

    if-eq v0, v3, :cond_8

    return v2

    .line 442
    :cond_8
    invoke-virtual {p1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v0

    invoke-virtual {p0, v0}, Lokhttp3/internal/connection/RealConnection;->supportsUrl(Lokhttp3/HttpUrl;)Z

    move-result v0

    if-nez v0, :cond_9

    return v2

    .line 446
    :cond_9
    :try_start_0
    invoke-virtual {p1}, Lokhttp3/Address;->certificatePinner()Lokhttp3/CertificatePinner;

    move-result-object v0

    invoke-virtual {p1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v3

    invoke-virtual {v3}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0}, Lokhttp3/internal/connection/RealConnection;->handshake()Lokhttp3/Handshake;

    move-result-object v4

    invoke-virtual {v4}, Lokhttp3/Handshake;->peerCertificates()Ljava/util/List;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Lokhttp3/CertificatePinner;->check(Ljava/lang/String;Ljava/util/List;)V
    :try_end_0
    .catch Ljavax/net/ssl/SSLPeerUnverifiedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 449
    nop

    .line 451
    return v1

    .line 447
    :catch_0
    move-exception v0

    .line 448
    .local v0, "e":Ljavax/net/ssl/SSLPeerUnverifiedException;
    return v2

    .line 414
    .end local v0    # "e":Ljavax/net/ssl/SSLPeerUnverifiedException;
    :cond_a
    :goto_0
    return v2
.end method

.method public isHealthy(Z)Z
    .locals 5
    .param p1, "doExtensiveChecks"    # Z

    .line 503
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v0}, Ljava/net/Socket;->isClosed()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_4

    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v0}, Ljava/net/Socket;->isInputShutdown()Z

    move-result v0

    if-nez v0, :cond_4

    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v0}, Ljava/net/Socket;->isOutputShutdown()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 507
    :cond_0
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    .line 508
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    invoke-virtual {v0}, Lokhttp3/internal/http2/Http2Connection;->isShutdown()Z

    move-result v0

    xor-int/2addr v0, v2

    return v0

    .line 511
    :cond_1
    if-eqz p1, :cond_3

    .line 513
    :try_start_0
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v0}, Ljava/net/Socket;->getSoTimeout()I

    move-result v0
    :try_end_0
    .catch Ljava/net/SocketTimeoutException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 515
    .local v0, "readTimeout":I
    :try_start_1
    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v3, v2}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 516
    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    invoke-interface {v3}, Lokio/BufferedSource;->exhausted()Z

    move-result v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v3, :cond_2

    .line 517
    nop

    .line 521
    :try_start_2
    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v3, v0}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 517
    return v1

    .line 519
    :cond_2
    nop

    .line 521
    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v3, v0}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 519
    return v2

    .line 521
    :catchall_0
    move-exception v3

    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v4, v0}, Ljava/net/Socket;->setSoTimeout(I)V

    throw v3
    :try_end_2
    .catch Ljava/net/SocketTimeoutException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    .line 525
    .end local v0    # "readTimeout":I
    :catch_0
    move-exception v0

    .line 526
    .local v0, "e":Ljava/io/IOException;
    return v1

    .line 523
    .end local v0    # "e":Ljava/io/IOException;
    :catch_1
    move-exception v0

    .line 527
    nop

    .line 530
    :cond_3
    return v2

    .line 504
    :cond_4
    :goto_0
    return v1
.end method

.method public isMultiplexed()Z
    .locals 1

    .line 554
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public newCodec(Lokhttp3/OkHttpClient;Lokhttp3/Interceptor$Chain;Lokhttp3/internal/connection/StreamAllocation;)Lokhttp3/internal/http/HttpCodec;
    .locals 4
    .param p1, "client"    # Lokhttp3/OkHttpClient;
    .param p2, "chain"    # Lokhttp3/Interceptor$Chain;
    .param p3, "streamAllocation"    # Lokhttp3/internal/connection/StreamAllocation;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/net/SocketException;
        }
    .end annotation

    .line 470
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    if-eqz v0, :cond_0

    .line 471
    new-instance v0, Lokhttp3/internal/http2/Http2Codec;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->http2Connection:Lokhttp3/internal/http2/Http2Connection;

    invoke-direct {v0, p1, p2, p3, v1}, Lokhttp3/internal/http2/Http2Codec;-><init>(Lokhttp3/OkHttpClient;Lokhttp3/Interceptor$Chain;Lokhttp3/internal/connection/StreamAllocation;Lokhttp3/internal/http2/Http2Connection;)V

    return-object v0

    .line 473
    :cond_0
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    invoke-interface {p2}, Lokhttp3/Interceptor$Chain;->readTimeoutMillis()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 474
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    invoke-interface {v0}, Lokio/BufferedSource;->timeout()Lokio/Timeout;

    move-result-object v0

    invoke-interface {p2}, Lokhttp3/Interceptor$Chain;->readTimeoutMillis()I

    move-result v1

    int-to-long v1, v1

    sget-object v3, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v0, v1, v2, v3}, Lokio/Timeout;->timeout(JLjava/util/concurrent/TimeUnit;)Lokio/Timeout;

    .line 475
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-interface {v0}, Lokio/BufferedSink;->timeout()Lokio/Timeout;

    move-result-object v0

    invoke-interface {p2}, Lokhttp3/Interceptor$Chain;->writeTimeoutMillis()I

    move-result v1

    int-to-long v1, v1

    sget-object v3, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v0, v1, v2, v3}, Lokio/Timeout;->timeout(JLjava/util/concurrent/TimeUnit;)Lokio/Timeout;

    .line 476
    new-instance v0, Lokhttp3/internal/http1/Http1Codec;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    iget-object v2, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-direct {v0, p1, p3, v1, v2}, Lokhttp3/internal/http1/Http1Codec;-><init>(Lokhttp3/OkHttpClient;Lokhttp3/internal/connection/StreamAllocation;Lokio/BufferedSource;Lokio/BufferedSink;)V

    return-object v0
.end method

.method public newWebSocketStreams(Lokhttp3/internal/connection/StreamAllocation;)Lokhttp3/internal/ws/RealWebSocket$Streams;
    .locals 7
    .param p1, "streamAllocation"    # Lokhttp3/internal/connection/StreamAllocation;

    .line 481
    new-instance v6, Lokhttp3/internal/connection/RealConnection$1;

    iget-object v3, p0, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    const/4 v2, 0x1

    move-object v0, v6

    move-object v1, p0

    move-object v5, p1

    invoke-direct/range {v0 .. v5}, Lokhttp3/internal/connection/RealConnection$1;-><init>(Lokhttp3/internal/connection/RealConnection;ZLokio/BufferedSource;Lokio/BufferedSink;Lokhttp3/internal/connection/StreamAllocation;)V

    return-object v6
.end method

.method public onSettings(Lokhttp3/internal/http2/Http2Connection;)V
    .locals 2
    .param p1, "connection"    # Lokhttp3/internal/http2/Http2Connection;

    .line 540
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->connectionPool:Lokhttp3/ConnectionPool;

    monitor-enter v0

    .line 541
    :try_start_0
    invoke-virtual {p1}, Lokhttp3/internal/http2/Http2Connection;->maxConcurrentStreams()I

    move-result v1

    iput v1, p0, Lokhttp3/internal/connection/RealConnection;->allocationLimit:I

    .line 542
    monitor-exit v0

    .line 543
    return-void

    .line 542
    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public onStream(Lokhttp3/internal/http2/Http2Stream;)V
    .locals 1
    .param p1, "stream"    # Lokhttp3/internal/http2/Http2Stream;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 535
    sget-object v0, Lokhttp3/internal/http2/ErrorCode;->REFUSED_STREAM:Lokhttp3/internal/http2/ErrorCode;

    invoke-virtual {p1, v0}, Lokhttp3/internal/http2/Http2Stream;->close(Lokhttp3/internal/http2/ErrorCode;)V

    .line 536
    return-void
.end method

.method public protocol()Lokhttp3/Protocol;
    .locals 1

    .line 558
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    return-object v0
.end method

.method public route()Lokhttp3/Route;
    .locals 1

    .line 489
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    return-object v0
.end method

.method public socket()Ljava/net/Socket;
    .locals 1

    .line 498
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->socket:Ljava/net/Socket;

    return-object v0
.end method

.method public supportsUrl(Lokhttp3/HttpUrl;)Z
    .locals 5
    .param p1, "url"    # Lokhttp3/HttpUrl;

    .line 455
    invoke-virtual {p1}, Lokhttp3/HttpUrl;->port()I

    move-result v0

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/HttpUrl;->port()I

    move-result v1

    const/4 v2, 0x0

    if-eq v0, v1, :cond_0

    .line 456
    return v2

    .line 459
    :cond_0
    invoke-virtual {p1}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x1

    if-nez v0, :cond_2

    .line 461
    iget-object v0, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    if-eqz v0, :cond_1

    sget-object v0, Lokhttp3/internal/tls/OkHostnameVerifier;->INSTANCE:Lokhttp3/internal/tls/OkHostnameVerifier;

    .line 462
    invoke-virtual {p1}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v3

    iget-object v4, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    invoke-virtual {v4}, Lokhttp3/Handshake;->peerCertificates()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/security/cert/X509Certificate;

    .line 461
    invoke-virtual {v0, v3, v4}, Lokhttp3/internal/tls/OkHostnameVerifier;->verify(Ljava/lang/String;Ljava/security/cert/X509Certificate;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    :cond_1
    move v1, v2

    :goto_0
    return v1

    .line 465
    :cond_2
    return v1
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 562
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Connection{"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 563
    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/HttpUrl;->host()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    invoke-virtual {v1}, Lokhttp3/Route;->address()Lokhttp3/Address;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/Address;->url()Lokhttp3/HttpUrl;

    move-result-object v1

    invoke-virtual {v1}, Lokhttp3/HttpUrl;->port()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", proxy="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 565
    invoke-virtual {v1}, Lokhttp3/Route;->proxy()Ljava/net/Proxy;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " hostAddress="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->route:Lokhttp3/Route;

    .line 567
    invoke-virtual {v1}, Lokhttp3/Route;->socketAddress()Ljava/net/InetSocketAddress;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " cipherSuite="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    if-eqz v1, :cond_0

    .line 569
    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->handshake:Lokhttp3/Handshake;

    invoke-virtual {v1}, Lokhttp3/Handshake;->cipherSuite()Lokhttp3/CipherSuite;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, "none"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " protocol="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lokhttp3/internal/connection/RealConnection;->protocol:Lokhttp3/Protocol;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 v1, 0x7d

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 562
    return-object v0
.end method
