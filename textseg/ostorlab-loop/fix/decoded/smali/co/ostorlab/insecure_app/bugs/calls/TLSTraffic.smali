.class public final Lco/ostorlab/insecure_app/bugs/calls/TLSTraffic;
.super Lco/ostorlab/insecure_app/BugRule;
.source "TLSTraffic.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 15
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/TLSTraffic;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/TLSTraffic;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 13
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 32
    const-string v0, "TLS/SSL HTTP traffic"

    return-object v0
.end method

.method public run()V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    new-instance v0, Lokhttp3/OkHttpClient$Builder;

    invoke-direct {v0}, Lokhttp3/OkHttpClient$Builder;-><init>()V

    sget-object v1, Lorg/apache/http/conn/ssl/SSLSocketFactory;->ALLOW_ALL_HOSTNAME_VERIFIER:Lorg/apache/http/conn/ssl/X509HostnameVerifier;

    .line 20
    invoke-virtual {v0, v1}, Lokhttp3/OkHttpClient$Builder;->hostnameVerifier(Ljavax/net/ssl/HostnameVerifier;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v0

    .line 21
    invoke-virtual {v0}, Lokhttp3/OkHttpClient$Builder;->build()Lokhttp3/OkHttpClient;

    move-result-object v0

    .line 22
    .local v0, "client":Lokhttp3/OkHttpClient;
    new-instance v1, Lokhttp3/Request$Builder;

    invoke-direct {v1}, Lokhttp3/Request$Builder;-><init>()V

    const-string v2, "https://ostorlab.co/"

    .line 23
    invoke-virtual {v1, v2}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v1

    .line 24
    invoke-virtual {v1}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v1

    .line 25
    .local v1, "request":Lokhttp3/Request;
    invoke-virtual {v0, v1}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v2

    .line 26
    .local v2, "okhttpCall":Lokhttp3/Call;
    invoke-interface {v2}, Lokhttp3/Call;->execute()Lokhttp3/Response;

    move-result-object v3

    .line 27
    .local v3, "response":Lokhttp3/Response;
    const/4 v4, 0x0

    const/4 v5, 0x0

    invoke-static {v4, v5}, Landroid/net/SSLCertificateSocketFactory;->getInsecure(ILandroid/net/SSLSessionCache;)Ljavax/net/ssl/SSLSocketFactory;

    .line 28
    return-void
.end method
