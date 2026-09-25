.class Lco/ostorlab/insecure_app/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lco/ostorlab/insecure_app/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lco/ostorlab/insecure_app/MainActivity;


# direct methods
.method constructor <init>(Lco/ostorlab/insecure_app/MainActivity;)V
    .locals 0
    .param p1, "this$0"    # Lco/ostorlab/insecure_app/MainActivity;

    .line 42
    iput-object p1, p0, Lco/ostorlab/insecure_app/MainActivity$1;->this$0:Lco/ostorlab/insecure_app/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 45
    iget-object v0, p0, Lco/ostorlab/insecure_app/MainActivity$1;->this$0:Lco/ostorlab/insecure_app/MainActivity;

    invoke-static {v0}, Lco/ostorlab/insecure_app/MainActivity;->access$000(Lco/ostorlab/insecure_app/MainActivity;)Landroid/widget/TextView;

    move-result-object v0

    const-string v1, "Running \n"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 46
    iget-object v0, p0, Lco/ostorlab/insecure_app/MainActivity$1;->this$0:Lco/ostorlab/insecure_app/MainActivity;

    invoke-static {v0}, Lco/ostorlab/insecure_app/MainActivity;->access$100(Lco/ostorlab/insecure_app/MainActivity;)V

    .line 47
    return-void
.end method
