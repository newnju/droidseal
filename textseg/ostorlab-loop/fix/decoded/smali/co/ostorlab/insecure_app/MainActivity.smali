.class public Lco/ostorlab/insecure_app/MainActivity;
.super Landroid/support/v7/app/AppCompatActivity;
.source "MainActivity.java"


# instance fields
.field private outputView:Landroid/widget/TextView;

.field private runAllButton:Landroid/widget/Button;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 28
    invoke-direct {p0}, Landroid/support/v7/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lco/ostorlab/insecure_app/MainActivity;)Landroid/widget/TextView;
    .locals 1
    .param p0, "x0"    # Lco/ostorlab/insecure_app/MainActivity;

    .line 28
    iget-object v0, p0, Lco/ostorlab/insecure_app/MainActivity;->outputView:Landroid/widget/TextView;

    return-object v0
.end method

.method static synthetic access$100(Lco/ostorlab/insecure_app/MainActivity;)V
    .locals 0
    .param p0, "x0"    # Lco/ostorlab/insecure_app/MainActivity;

    .line 28
    invoke-direct {p0}, Lco/ostorlab/insecure_app/MainActivity;->executeAllRules()V

    return-void
.end method

.method private executeAllRules()V
    .locals 3

    .line 52
    new-instance v0, Lco/ostorlab/insecure_app/BugRuleCaller;

    invoke-virtual {p0}, Lco/ostorlab/insecure_app/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;-><init>(Landroid/content/Context;)V

    .line 53
    .local v0, "caller":Lco/ostorlab/insecure_app/BugRuleCaller;
    iget-object v1, p0, Lco/ostorlab/insecure_app/MainActivity;->outputView:Landroid/widget/TextView;

    const-string v2, "Adding rules ...\n"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->append(Ljava/lang/CharSequence;)V

    .line 54
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/ECBModeCipher;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/ECBModeCipher;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 55
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/ClearTextTraffic;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/ClearTextTraffic;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 56
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/TLSTraffic;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/TLSTraffic;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 57
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/AESCipher;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/AESCipher;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 58
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/StaticIV;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/StaticIV;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 59
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/PathClassLoaderCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/PathClassLoaderCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 60
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/DexClassLoaderCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/DexClassLoaderCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 61
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 62
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureSharedPreferences;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 63
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 64
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/CommandExec;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/CommandExec;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 65
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/IntentCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 66
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/HashCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/HashCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 67
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/WebviewInsecureSettings;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 68
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/MobileOnlyDownloadManager;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 69
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/InsecureRandom;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureRandom;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 70
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 71
    new-instance v1, Lco/ostorlab/insecure_app/bugs/calls/SQLiteDatabaseCall;

    invoke-direct {v1}, Lco/ostorlab/insecure_app/bugs/calls/SQLiteDatabaseCall;-><init>()V

    invoke-virtual {v0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->addRule(Lco/ostorlab/insecure_app/BugRule;)V

    .line 75
    :try_start_0
    invoke-virtual {v0}, Lco/ostorlab/insecure_app/BugRuleCaller;->callRules()V

    .line 76
    iget-object v1, p0, Lco/ostorlab/insecure_app/MainActivity;->outputView:Landroid/widget/TextView;

    invoke-virtual {v0}, Lco/ostorlab/insecure_app/BugRuleCaller;->listBugRules()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->append(Ljava/lang/CharSequence;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 80
    goto :goto_0

    .line 78
    :catch_0
    move-exception v1

    .line 79
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 81
    .end local v1    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 34
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 35
    const v0, 0x7f0a001b

    invoke-virtual {p0, v0}, Lco/ostorlab/insecure_app/MainActivity;->setContentView(I)V

    .line 36
    const-string v0, "native-lib"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 37
    const v0, 0x7f080074

    invoke-virtual {p0, v0}, Lco/ostorlab/insecure_app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lco/ostorlab/insecure_app/MainActivity;->outputView:Landroid/widget/TextView;

    .line 38
    const v0, 0x7f080073

    invoke-virtual {p0, v0}, Lco/ostorlab/insecure_app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    iput-object v1, p0, Lco/ostorlab/insecure_app/MainActivity;->runAllButton:Landroid/widget/Button;

    .line 41
    invoke-virtual {p0, v0}, Lco/ostorlab/insecure_app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 42
    .local v0, "runAllButton":Landroid/widget/Button;
    new-instance v1, Lco/ostorlab/insecure_app/MainActivity$1;

    invoke-direct {v1, p0}, Lco/ostorlab/insecure_app/MainActivity$1;-><init>(Lco/ostorlab/insecure_app/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 49
    return-void
.end method
