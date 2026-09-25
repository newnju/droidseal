.class public abstract Lco/ostorlab/insecure_app/BugRule;
.super Ljava/lang/Object;
.source "BugRule.java"


# instance fields
.field private context:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getContext()Landroid/content/Context;
    .locals 1

    .line 10
    iget-object v0, p0, Lco/ostorlab/insecure_app/BugRule;->context:Landroid/content/Context;

    return-object v0
.end method

.method public abstract getDescription()Ljava/lang/String;
.end method

.method public abstract run()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation
.end method

.method public setContext(Landroid/content/Context;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;

    .line 9
    iput-object p1, p0, Lco/ostorlab/insecure_app/BugRule;->context:Landroid/content/Context;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 15
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
