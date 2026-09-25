.class public Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;
.super Lco/ostorlab/insecure_app/BugRule;
.source "ArrayCall.java"


# static fields
.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 13
    const-class v0, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;

    invoke-virtual {v0}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method

.method private add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;
    .locals 0
    .param p1, "array"    # Ljava/util/ArrayList;
    .param p2, "element"    # Ljava/lang/Object;

    .line 36
    invoke-virtual {p1, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 37
    return-object p1
.end method

.method private handle_array([III)[I
    .locals 0
    .param p1, "array"    # [I
    .param p2, "element"    # I
    .param p3, "position"    # I

    .line 42
    aput p2, p1, p3

    .line 43
    return-object p1
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 48
    const-string v0, "The application uses an ArrayList"

    return-object v0
.end method

.method public run()V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 18
    const/4 v0, 0x5

    new-array v1, v0, [I

    .line 19
    .local v1, "ages":[I
    const/4 v2, 0x0

    invoke-direct {p0, v1, v0, v2}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->handle_array([III)[I

    .line 20
    const/4 v0, 0x1

    const/4 v3, 0x6

    invoke-direct {p0, v1, v3, v0}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->handle_array([III)[I

    .line 21
    const/4 v3, 0x2

    const/4 v4, 0x7

    invoke-direct {p0, v1, v4, v3}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->handle_array([III)[I

    .line 23
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 24
    .local v4, "al":Ljava/util/ArrayList;
    const/16 v5, 0x383

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 25
    const/16 v5, 0xc

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 26
    const/16 v5, 0x13

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 27
    const/16 v5, 0x3e7

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 28
    const-string v5, "Une cha\u00eene de caract\u00e8res !"

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 29
    const v5, 0x41433333    # 12.2f

    invoke-static {v5}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v5

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 30
    const/16 v5, 0x64

    invoke-static {v5}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object v5

    invoke-direct {p0, v4, v5}, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->add_element(Ljava/util/ArrayList;Ljava/lang/Object;)Ljava/util/ArrayList;

    .line 31
    sget-object v5, Lco/ostorlab/insecure_app/bugs/calls/ArrayCall;->TAG:Ljava/lang/String;

    const-string v6, "Message: %s"

    new-array v0, v0, [Ljava/lang/Object;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    aput-object v3, v0, v2

    invoke-static {v6, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 32
    return-void
.end method
