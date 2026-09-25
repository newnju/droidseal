.class public final Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;
.super Lco/ostorlab/insecure_app/BugRule;
.source "WebviewInsecureSettings.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 9
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 13
    const-string v0, "Insecure WebviewInsecureSettings settings"

    return-object v0
.end method

.method public run()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 18
    new-instance v0, Landroid/webkit/WebView;

    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    .line 19
    .local v0, "webView":Landroid/webkit/WebView;
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 20
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V

    .line 21
    const-string v1, "http://www.ostorlab.co"

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 22
    return-void
.end method
