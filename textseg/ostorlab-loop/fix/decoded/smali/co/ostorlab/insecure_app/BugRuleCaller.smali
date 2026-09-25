.class final Lco/ostorlab/insecure_app/BugRuleCaller;
.super Ljava/lang/Object;
.source "BugRuleCaller.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "BugRuleCaller"


# instance fields
.field private context:Landroid/content/Context;

.field private rules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lco/ostorlab/insecure_app/BugRule;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 25
    iput-object p1, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->context:Landroid/content/Context;

    .line 26
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->rules:Ljava/util/List;

    .line 27
    return-void
.end method

.method private runInThread(Lco/ostorlab/insecure_app/BugRule;)V
    .locals 2
    .param p1, "rule"    # Lco/ostorlab/insecure_app/BugRule;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 54
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lco/ostorlab/insecure_app/BugRuleCaller$1;

    invoke-direct {v1, p0, p1}, Lco/ostorlab/insecure_app/BugRuleCaller$1;-><init>(Lco/ostorlab/insecure_app/BugRuleCaller;Lco/ostorlab/insecure_app/BugRule;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 63
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 64
    return-void
.end method


# virtual methods
.method addRule(Lco/ostorlab/insecure_app/BugRule;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Lco/ostorlab/insecure_app/BugRule;",
            ">(TT;)V"
        }
    .end annotation

    .line 34
    .local p1, "rule":Lco/ostorlab/insecure_app/BugRule;, "TT;"
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->context:Landroid/content/Context;

    invoke-virtual {p1, v0}, Lco/ostorlab/insecure_app/BugRule;->setContext(Landroid/content/Context;)V

    .line 35
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->rules:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 36
    return-void
.end method

.method callRules()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 39
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->rules:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lco/ostorlab/insecure_app/BugRule;

    .line 40
    .local v1, "rule":Lco/ostorlab/insecure_app/BugRule;
    invoke-direct {p0, v1}, Lco/ostorlab/insecure_app/BugRuleCaller;->runInThread(Lco/ostorlab/insecure_app/BugRule;)V

    .line 41
    .end local v1    # "rule":Lco/ostorlab/insecure_app/BugRule;
    goto :goto_0

    .line 42
    :cond_0
    return-void
.end method

.method public getRules()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lco/ostorlab/insecure_app/BugRule;",
            ">;"
        }
    .end annotation

    .line 30
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->rules:Ljava/util/List;

    return-object v0
.end method

.method listBugRules()Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 45
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 46
    .local v0, "buffer":Ljava/lang/StringBuilder;
    iget-object v1, p0, Lco/ostorlab/insecure_app/BugRuleCaller;->rules:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lco/ostorlab/insecure_app/BugRule;

    .line 47
    .local v2, "rule":Lco/ostorlab/insecure_app/BugRule;
    invoke-virtual {v2}, Lco/ostorlab/insecure_app/BugRule;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 48
    const-string v3, "\n"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 49
    .end local v2    # "rule":Lco/ostorlab/insecure_app/BugRule;
    goto :goto_0

    .line 50
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method
