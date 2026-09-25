.class public final Landroid/support/v4/app/NavUtils;
.super Ljava/lang/Object;
.source "NavUtils.java"


# static fields
.field public static final PARENT_ACTIVITY:Ljava/lang/String; = "android.support.PARENT_ACTIVITY"

.field private static final TAG:Ljava/lang/String; = "NavUtils"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 253
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 254
    return-void
.end method

.method public static getParentActivityIntent(Landroid/app/Activity;)Landroid/content/Intent;
    .locals 7
    .param p0, "sourceActivity"    # Landroid/app/Activity;

    .line 125
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x10

    if-lt v0, v1, :cond_0

    .line 128
    invoke-virtual {p0}, Landroid/app/Activity;->getParentActivityIntent()Landroid/content/Intent;

    move-result-object v0

    .line 129
    .local v0, "result":Landroid/content/Intent;
    if-eqz v0, :cond_0

    .line 130
    return-object v0

    .line 133
    .end local v0    # "result":Landroid/content/Intent;
    :cond_0
    invoke-static {p0}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/app/Activity;)Ljava/lang/String;

    move-result-object v0

    .line 134
    .local v0, "parentName":Ljava/lang/String;
    const/4 v1, 0x0

    if-nez v0, :cond_1

    return-object v1

    .line 137
    :cond_1
    new-instance v2, Landroid/content/ComponentName;

    invoke-direct {v2, p0, v0}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 139
    .local v2, "target":Landroid/content/ComponentName;
    :try_start_0
    invoke-static {p0, v2}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v3

    .line 140
    .local v3, "grandparent":Ljava/lang/String;
    if-nez v3, :cond_2

    .line 141
    invoke-static {v2}, Landroid/content/Intent;->makeMainActivity(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v4

    goto :goto_0

    :cond_2
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    .line 142
    invoke-virtual {v4, v2}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v4
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-object v4

    .line 143
    .end local v3    # "grandparent":Ljava/lang/String;
    :catch_0
    move-exception v3

    .line 144
    .local v3, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    const-string v4, "NavUtils"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getParentActivityIntent: bad parentActivityName \'"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\' in manifest"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    return-object v1
.end method

.method public static getParentActivityIntent(Landroid/content/Context;Landroid/content/ComponentName;)Landroid/content/Intent;
    .locals 4
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "componentName"    # Landroid/content/ComponentName;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/pm/PackageManager$NameNotFoundException;
        }
    .end annotation

    .line 187
    invoke-static {p0, p1}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v0

    .line 188
    .local v0, "parentActivity":Ljava/lang/String;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    return-object v1

    .line 191
    :cond_0
    new-instance v1, Landroid/content/ComponentName;

    .line 192
    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2, v0}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 193
    .local v1, "target":Landroid/content/ComponentName;
    invoke-static {p0, v1}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v2

    .line 194
    .local v2, "grandparent":Ljava/lang/String;
    if-nez v2, :cond_1

    .line 195
    invoke-static {v1}, Landroid/content/Intent;->makeMainActivity(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v3

    goto :goto_0

    :cond_1
    new-instance v3, Landroid/content/Intent;

    invoke-direct {v3}, Landroid/content/Intent;-><init>()V

    .line 196
    invoke-virtual {v3, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v3

    .line 197
    .local v3, "parentIntent":Landroid/content/Intent;
    :goto_0
    return-object v3
.end method

.method public static getParentActivityIntent(Landroid/content/Context;Ljava/lang/Class;)Landroid/content/Intent;
    .locals 4
    .param p0, "context"    # Landroid/content/Context;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/Class<",
            "*>;)",
            "Landroid/content/Intent;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/pm/PackageManager$NameNotFoundException;
        }
    .end annotation

    .line 162
    .local p1, "sourceActivityClass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    new-instance v0, Landroid/content/ComponentName;

    invoke-direct {v0, p0, p1}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-static {p0, v0}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v0

    .line 164
    .local v0, "parentActivity":Ljava/lang/String;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    return-object v1

    .line 167
    :cond_0
    new-instance v1, Landroid/content/ComponentName;

    invoke-direct {v1, p0, v0}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 168
    .local v1, "target":Landroid/content/ComponentName;
    invoke-static {p0, v1}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v2

    .line 169
    .local v2, "grandparent":Ljava/lang/String;
    if-nez v2, :cond_1

    .line 170
    invoke-static {v1}, Landroid/content/Intent;->makeMainActivity(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v3

    goto :goto_0

    :cond_1
    new-instance v3, Landroid/content/Intent;

    invoke-direct {v3}, Landroid/content/Intent;-><init>()V

    .line 171
    invoke-virtual {v3, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v3

    .line 172
    .local v3, "parentIntent":Landroid/content/Intent;
    :goto_0
    return-object v3
.end method

.method public static getParentActivityName(Landroid/app/Activity;)Ljava/lang/String;
    .locals 2
    .param p0, "sourceActivity"    # Landroid/app/Activity;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 212
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getComponentName()Landroid/content/ComponentName;

    move-result-object v0

    invoke-static {p0, v0}, Landroid/support/v4/app/NavUtils;->getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 213
    :catch_0
    move-exception v0

    .line 215
    .local v0, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method public static getParentActivityName(Landroid/content/Context;Landroid/content/ComponentName;)Ljava/lang/String;
    .locals 5
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "componentName"    # Landroid/content/ComponentName;
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/pm/PackageManager$NameNotFoundException;
        }
    .end annotation

    .line 231
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 232
    .local v0, "pm":Landroid/content/pm/PackageManager;
    const/16 v1, 0x80

    invoke-virtual {v0, p1, v1}, Landroid/content/pm/PackageManager;->getActivityInfo(Landroid/content/ComponentName;I)Landroid/content/pm/ActivityInfo;

    move-result-object v1

    .line 233
    .local v1, "info":Landroid/content/pm/ActivityInfo;
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x10

    if-lt v2, v3, :cond_0

    .line 234
    iget-object v2, v1, Landroid/content/pm/ActivityInfo;->parentActivityName:Ljava/lang/String;

    .line 235
    .local v2, "result":Ljava/lang/String;
    if-eqz v2, :cond_0

    .line 236
    return-object v2

    .line 239
    .end local v2    # "result":Ljava/lang/String;
    :cond_0
    iget-object v2, v1, Landroid/content/pm/ActivityInfo;->metaData:Landroid/os/Bundle;

    const/4 v3, 0x0

    if-nez v2, :cond_1

    .line 240
    return-object v3

    .line 242
    :cond_1
    iget-object v2, v1, Landroid/content/pm/ActivityInfo;->metaData:Landroid/os/Bundle;

    const-string v4, "android.support.PARENT_ACTIVITY"

    invoke-virtual {v2, v4}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 243
    .local v2, "parentActivity":Ljava/lang/String;
    if-nez v2, :cond_2

    .line 244
    return-object v3

    .line 246
    :cond_2
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x2e

    if-ne v3, v4, :cond_3

    .line 247
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 249
    :cond_3
    return-object v2
.end method

.method public static navigateUpFromSameTask(Landroid/app/Activity;)V
    .locals 4
    .param p0, "sourceActivity"    # Landroid/app/Activity;

    .line 78
    invoke-static {p0}, Landroid/support/v4/app/NavUtils;->getParentActivityIntent(Landroid/app/Activity;)Landroid/content/Intent;

    move-result-object v0

    .line 80
    .local v0, "upIntent":Landroid/content/Intent;
    if-nez v0, :cond_0

    .line 81
    new-instance v1, Ljava/lang/IllegalArgumentException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Activity "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 82
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " does not have a parent activity name specified."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " (Did you forget to add the android.support.PARENT_ACTIVITY <meta-data> "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " element in your manifest?)"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 88
    :cond_0
    invoke-static {p0, v0}, Landroid/support/v4/app/NavUtils;->navigateUpTo(Landroid/app/Activity;Landroid/content/Intent;)V

    .line 89
    return-void
.end method

.method public static navigateUpTo(Landroid/app/Activity;Landroid/content/Intent;)V
    .locals 2
    .param p0, "sourceActivity"    # Landroid/app/Activity;
    .param p1, "upIntent"    # Landroid/content/Intent;

    .line 105
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x10

    if-lt v0, v1, :cond_0

    .line 106
    invoke-virtual {p0, p1}, Landroid/app/Activity;->navigateUpTo(Landroid/content/Intent;)Z

    goto :goto_0

    .line 108
    :cond_0
    const/high16 v0, 0x4000000

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 109
    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    .line 110
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 112
    :goto_0
    return-void
.end method

.method public static shouldUpRecreateTask(Landroid/app/Activity;Landroid/content/Intent;)Z
    .locals 2
    .param p0, "sourceActivity"    # Landroid/app/Activity;
    .param p1, "targetIntent"    # Landroid/content/Intent;

    .line 57
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x10

    if-lt v0, v1, :cond_0

    .line 58
    invoke-virtual {p0, p1}, Landroid/app/Activity;->shouldUpRecreateTask(Landroid/content/Intent;)Z

    move-result v0

    return v0

    .line 60
    :cond_0
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    .line 61
    .local v0, "action":Ljava/lang/String;
    if-eqz v0, :cond_1

    const-string v1, "android.intent.action.MAIN"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    return v1
.end method
