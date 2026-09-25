.class Lco/ostorlab/insecure_app/BugRuleCaller$1;
.super Ljava/lang/Object;
.source "BugRuleCaller.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lco/ostorlab/insecure_app/BugRuleCaller;->runInThread(Lco/ostorlab/insecure_app/BugRule;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lco/ostorlab/insecure_app/BugRuleCaller;

.field final synthetic val$rule:Lco/ostorlab/insecure_app/BugRule;


# direct methods
.method constructor <init>(Lco/ostorlab/insecure_app/BugRuleCaller;Lco/ostorlab/insecure_app/BugRule;)V
    .locals 0
    .param p1, "this$0"    # Lco/ostorlab/insecure_app/BugRuleCaller;

    .line 54
    iput-object p1, p0, Lco/ostorlab/insecure_app/BugRuleCaller$1;->this$0:Lco/ostorlab/insecure_app/BugRuleCaller;

    iput-object p2, p0, Lco/ostorlab/insecure_app/BugRuleCaller$1;->val$rule:Lco/ostorlab/insecure_app/BugRule;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 57
    :try_start_0
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRuleCaller$1;->val$rule:Lco/ostorlab/insecure_app/BugRule;

    invoke-virtual {v0}, Lco/ostorlab/insecure_app/BugRule;->run()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 61
    goto :goto_0

    .line 59
    :catch_0
    move-exception v0

    .line 60
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 62
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method
