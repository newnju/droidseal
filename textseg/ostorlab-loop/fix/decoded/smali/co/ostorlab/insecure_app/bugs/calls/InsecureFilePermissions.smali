.class public final Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;
.super Lco/ostorlab/insecure_app/BugRule;
.source "InsecureFilePermissions.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RULE"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method

.method private openFileOutputWorldReadable(Ljava/lang/String;)V
    .locals 2
    .param p1, "filename"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 27
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, p1, v1}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    .line 28
    return-void
.end method

.method private openFileOutputWorldWritable(Ljava/lang/String;)V
    .locals 2
    .param p1, "filename"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 31
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x2

    invoke-virtual {v0, p1, v1}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    .line 32
    return-void
.end method

.method private setReadableAll(Ljava/lang/String;)V
    .locals 4
    .param p1, "filename"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 36
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    .line 37
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 38
    .local v0, "path":Ljava/lang/String;
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 39
    .local v2, "f":Ljava/io/File;
    const/4 v3, 0x1

    invoke-virtual {v2, v3, v1}, Ljava/io/File;->setReadable(ZZ)Z

    .line 40
    return-void
.end method

.method private setWritableAll(Ljava/lang/String;)V
    .locals 4
    .param p1, "filename"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 43
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    .line 44
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 45
    .local v0, "path":Ljava/lang/String;
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 46
    .local v2, "f":Ljava/io/File;
    const/4 v3, 0x1

    invoke-virtual {v2, v3, v1}, Ljava/io/File;->setWritable(ZZ)Z

    .line 47
    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 14
    const-string v0, "Use of insecure file permissions"

    return-object v0
.end method

.method public run()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    const-string v0, "test_filename"

    .line 20
    .local v0, "filename":Ljava/lang/String;
    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->openFileOutputWorldReadable(Ljava/lang/String;)V

    .line 21
    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->openFileOutputWorldWritable(Ljava/lang/String;)V

    .line 22
    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->setReadableAll(Ljava/lang/String;)V

    .line 23
    invoke-direct {p0, v0}, Lco/ostorlab/insecure_app/bugs/calls/InsecureFilePermissions;->setWritableAll(Ljava/lang/String;)V

    .line 24
    return-void
.end method
