.class public Landroid/support/v4/media/MediaBrowserCompatUtils;
.super Ljava/lang/Object;
.source "MediaBrowserCompatUtils.java"


# annotations
.annotation build Landroid/support/annotation/RestrictTo;
    value = {
        .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static areSameOptions(Landroid/os/Bundle;Landroid/os/Bundle;)Z
    .locals 5
    .param p0, "options1"    # Landroid/os/Bundle;
    .param p1, "options2"    # Landroid/os/Bundle;

    .line 30
    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    .line 31
    return v0

    .line 32
    :cond_0
    const/4 v1, 0x0

    const/4 v2, -0x1

    if-nez p0, :cond_2

    .line 33
    const-string v3, "android.media.browse.extra.PAGE"

    invoke-virtual {p1, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-ne v3, v2, :cond_1

    const-string v3, "android.media.browse.extra.PAGE_SIZE"

    .line 34
    invoke-virtual {p1, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-ne v3, v2, :cond_1

    goto :goto_0

    :cond_1
    move v0, v1

    :goto_0
    return v0

    .line 35
    :cond_2
    if-nez p1, :cond_4

    .line 36
    const-string v3, "android.media.browse.extra.PAGE"

    invoke-virtual {p0, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-ne v3, v2, :cond_3

    const-string v3, "android.media.browse.extra.PAGE_SIZE"

    .line 37
    invoke-virtual {p0, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-ne v3, v2, :cond_3

    goto :goto_1

    :cond_3
    move v0, v1

    :goto_1
    return v0

    .line 39
    :cond_4
    const-string v3, "android.media.browse.extra.PAGE"

    invoke-virtual {p0, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    const-string v4, "android.media.browse.extra.PAGE"

    .line 40
    invoke-virtual {p1, v4, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v4

    if-ne v3, v4, :cond_5

    const-string v3, "android.media.browse.extra.PAGE_SIZE"

    .line 41
    invoke-virtual {p0, v3, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    const-string v4, "android.media.browse.extra.PAGE_SIZE"

    .line 42
    invoke-virtual {p1, v4, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v2

    if-ne v3, v2, :cond_5

    goto :goto_2

    :cond_5
    move v0, v1

    :goto_2
    return v0
.end method

.method public static hasDuplicatedItems(Landroid/os/Bundle;Landroid/os/Bundle;)Z
    .locals 9
    .param p0, "options1"    # Landroid/os/Bundle;
    .param p1, "options2"    # Landroid/os/Bundle;

    .line 47
    const/4 v0, -0x1

    if-nez p0, :cond_0

    move v1, v0

    goto :goto_0

    :cond_0
    const-string v1, "android.media.browse.extra.PAGE"

    invoke-virtual {p0, v1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 48
    .local v1, "page1":I
    :goto_0
    if-nez p1, :cond_1

    move v2, v0

    goto :goto_1

    :cond_1
    const-string v2, "android.media.browse.extra.PAGE"

    invoke-virtual {p1, v2, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v2

    .line 49
    .local v2, "page2":I
    :goto_1
    if-nez p0, :cond_2

    .line 50
    move v3, v0

    goto :goto_2

    .line 49
    :cond_2
    const-string v3, "android.media.browse.extra.PAGE_SIZE"

    .line 50
    invoke-virtual {p0, v3, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v3

    .line 51
    .local v3, "pageSize1":I
    :goto_2
    if-nez p1, :cond_3

    .line 52
    move v4, v0

    goto :goto_3

    .line 51
    :cond_3
    const-string v4, "android.media.browse.extra.PAGE_SIZE"

    .line 52
    invoke-virtual {p1, v4, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v4

    .line 55
    .local v4, "pageSize2":I
    :goto_3
    const/4 v5, 0x1

    if-eq v1, v0, :cond_5

    if-ne v3, v0, :cond_4

    goto :goto_4

    .line 59
    :cond_4
    mul-int v6, v3, v1

    .line 60
    .local v6, "startIndex1":I
    add-int v7, v6, v3

    sub-int/2addr v7, v5

    goto :goto_5

    .line 56
    .end local v6    # "startIndex1":I
    :cond_5
    :goto_4
    const/4 v6, 0x0

    .line 57
    .restart local v6    # "startIndex1":I
    const v7, 0x7fffffff

    .line 60
    .local v7, "endIndex1":I
    :goto_5
    nop

    .line 63
    if-eq v2, v0, :cond_7

    if-ne v4, v0, :cond_6

    goto :goto_6

    .line 67
    :cond_6
    mul-int v0, v4, v2

    .line 68
    .local v0, "startIndex2":I
    add-int v8, v0, v4

    sub-int/2addr v8, v5

    goto :goto_7

    .line 64
    .end local v0    # "startIndex2":I
    :cond_7
    :goto_6
    const/4 v0, 0x0

    .line 65
    .restart local v0    # "startIndex2":I
    const v8, 0x7fffffff

    .line 68
    .local v8, "endIndex2":I
    :goto_7
    nop

    .line 71
    if-gt v6, v0, :cond_8

    if-gt v0, v7, :cond_8

    .line 72
    return v5

    .line 73
    :cond_8
    if-gt v6, v8, :cond_9

    if-gt v8, v7, :cond_9

    .line 74
    return v5

    .line 76
    :cond_9
    const/4 v5, 0x0

    return v5
.end method
