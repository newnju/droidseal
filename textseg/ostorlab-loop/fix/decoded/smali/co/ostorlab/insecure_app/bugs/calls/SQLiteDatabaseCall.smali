.class public Lco/ostorlab/insecure_app/bugs/calls/SQLiteDatabaseCall;
.super Lco/ostorlab/insecure_app/BugRule;
.source "SQLiteDatabaseCall.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Lco/ostorlab/insecure_app/BugRule;-><init>()V

    return-void
.end method


# virtual methods
.method public getDescription()Ljava/lang/String;
    .locals 1

    .line 26
    const-string v0, "The application uses SQLiteOpenHelper"

    return-object v0
.end method

.method public run()V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 14
    new-instance v0, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;

    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/SQLiteDatabaseCall;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;-><init>(Landroid/content/Context;)V

    .line 15
    .local v0, "mySQLiteOpenHelper":Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;
    invoke-virtual {v0}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    .line 16
    .local v1, "db":Landroid/database/sqlite/SQLiteDatabase;
    invoke-virtual {v0}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->createTable()V

    .line 17
    const-string v2, "INSERT INTO accounts(name, amount) VALUES(?, ?)"

    .line 18
    .local v2, "insert_query":Ljava/lang/String;
    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const-string v4, "Jack"

    const/4 v5, 0x0

    aput-object v4, v3, v5

    const/16 v4, 0xbb8

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x1

    aput-object v4, v3, v5

    invoke-virtual {v1, v2, v3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 19
    invoke-virtual {v0}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->dropTable()V

    .line 20
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->close()V

    .line 22
    return-void
.end method
