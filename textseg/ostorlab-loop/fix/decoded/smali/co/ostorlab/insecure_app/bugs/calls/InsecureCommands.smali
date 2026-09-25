.class public Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;
.super Lco/ostorlab/insecure_app/BugRule;
.source "InsecureCommands.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 8
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method

.method private executeCommand(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3
    .param p1, "command"    # Ljava/lang/String;
    .param p2, "pathName"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 17
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 18
    .local v0, "file":Ljava/io/File;
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, p1, v2, v0}, Ljava/lang/Runtime;->exec(Ljava/lang/String;[Ljava/lang/String;Ljava/io/File;)Ljava/lang/Process;

    .line 19
    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 23
    const-string v0, "The application executes commands from an external storage"

    return-object v0
.end method

.method public run()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 12
    const-string v0, "chmod 755 test_file"

    const-string v1, "/data/data/"

    invoke-direct {p0, v0, v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;->executeCommand(Ljava/lang/String;Ljava/lang/String;)V

    .line 13
    const-string v0, "ping -c 3 www.ostorlab.co"

    const-string v1, "/sdcard/ostorlab"

    invoke-direct {p0, v0, v1}, Lco/ostorlab/insecure_app/bugs/calls/InsecureCommands;->executeCommand(Ljava/lang/String;Ljava/lang/String;)V

    .line 14
    return-void
.end method
