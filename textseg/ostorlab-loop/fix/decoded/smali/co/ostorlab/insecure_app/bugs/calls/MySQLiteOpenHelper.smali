.class Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;
.super Landroid/database/sqlite/SQLiteOpenHelper;
.source "SQLiteDatabaseCall.java"


# static fields
.field private static final AMOUNT:Ljava/lang/String; = "amount"

.field private static final CREATE_TABLE:Ljava/lang/String; = "CREATE TABLE accounts (_id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), amount REAL);"

.field private static final DATABASE_NAME:Ljava/lang/String; = "bank"

.field private static final DATABASE_VERSION:I = 0x1

.field private static final DROP_TABLE:Ljava/lang/String; = "DROP TABLE IF EXISTS accounts"

.field private static final NAME:Ljava/lang/String; = "name"

.field private static final TABLE_NAME:Ljava/lang/String; = "accounts"

.field private static final UID:Ljava/lang/String; = "_id"


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .line 60
    const-string v0, "bank"

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-direct {p0, p1, v0, v1, v2}, Landroid/database/sqlite/SQLiteOpenHelper;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase$CursorFactory;I)V

    .line 61
    return-void
.end method


# virtual methods
.method public createTable()V
    .locals 2

    .line 69
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    const-string v1, "CREATE TABLE accounts (_id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), amount REAL);"

    invoke-virtual {v0, v1}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 70
    return-void
.end method

.method public dropTable()V
    .locals 2

    .line 73
    invoke-virtual {p0}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    const-string v1, "DROP TABLE IF EXISTS accounts"

    invoke-virtual {v0, v1}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 74
    return-void
.end method

.method public onCreate(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 1
    .param p1, "db"    # Landroid/database/sqlite/SQLiteDatabase;

    .line 65
    const-string v0, "CREATE TABLE accounts (_id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), amount REAL);"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 66
    return-void
.end method

.method public onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V
    .locals 1
    .param p1, "db"    # Landroid/database/sqlite/SQLiteDatabase;
    .param p2, "oldVersion"    # I
    .param p3, "newVersion"    # I

    .line 78
    const-string v0, "DROP TABLE IF EXISTS accounts"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 79
    invoke-virtual {p0, p1}, Lco/ostorlab/insecure_app/bugs/calls/MySQLiteOpenHelper;->onCreate(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 80
    return-void
.end method
