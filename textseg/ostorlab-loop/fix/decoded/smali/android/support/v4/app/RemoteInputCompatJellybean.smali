.class Landroid/support/v4/app/RemoteInputCompatJellybean;
.super Ljava/lang/Object;
.source "RemoteInputCompatJellybean.java"


# annotations
.annotation build Landroid/support/annotation/RequiresApi;
    value = 0x10
.end annotation


# static fields
.field private static final EXTRA_DATA_TYPE_RESULTS_DATA:Ljava/lang/String; = "android.remoteinput.dataTypeResultsData"

.field private static final KEY_ALLOWED_DATA_TYPES:Ljava/lang/String; = "allowedDataTypes"

.field private static final KEY_ALLOW_FREE_FORM_INPUT:Ljava/lang/String; = "allowFreeFormInput"

.field private static final KEY_CHOICES:Ljava/lang/String; = "choices"

.field private static final KEY_EXTRAS:Ljava/lang/String; = "extras"

.field private static final KEY_LABEL:Ljava/lang/String; = "label"

.field private static final KEY_RESULT_KEY:Ljava/lang/String; = "resultKey"


# direct methods
.method constructor <init>()V
    .locals 0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addDataResultToIntent(Landroid/support/v4/app/RemoteInput;Landroid/content/Intent;Ljava/util/Map;)V
    .locals 8
    .param p0, "remoteInput"    # Landroid/support/v4/app/RemoteInput;
    .param p1, "intent"    # Landroid/content/Intent;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/RemoteInput;",
            "Landroid/content/Intent;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Landroid/net/Uri;",
            ">;)V"
        }
    .end annotation

    .line 165
    .local p2, "results":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Landroid/net/Uri;>;"
    invoke-static {p1}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getClipDataIntentFromIntent(Landroid/content/Intent;)Landroid/content/Intent;

    move-result-object v0

    .line 166
    .local v0, "clipDataIntent":Landroid/content/Intent;
    if-nez v0, :cond_0

    .line 167
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    move-object v0, v1

    .line 169
    :cond_0
    invoke-interface {p2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map$Entry;

    .line 170
    .local v2, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Landroid/net/Uri;>;"
    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 171
    .local v3, "mimeType":Ljava/lang/String;
    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/net/Uri;

    .line 172
    .local v4, "uri":Landroid/net/Uri;
    if-nez v3, :cond_1

    .line 173
    goto :goto_0

    .line 175
    :cond_1
    nop

    .line 176
    invoke-static {v3}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getExtraResultsKeyForData(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Landroid/content/Intent;->getBundleExtra(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v5

    .line 177
    .local v5, "resultsBundle":Landroid/os/Bundle;
    if-nez v5, :cond_2

    .line 178
    new-instance v6, Landroid/os/Bundle;

    invoke-direct {v6}, Landroid/os/Bundle;-><init>()V

    move-object v5, v6

    .line 180
    :cond_2
    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInput;->getResultKey()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v5, v6, v7}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 181
    invoke-static {v3}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getExtraResultsKeyForData(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Bundle;)Landroid/content/Intent;

    .line 182
    .end local v2    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Landroid/net/Uri;>;"
    .end local v3    # "mimeType":Ljava/lang/String;
    .end local v4    # "uri":Landroid/net/Uri;
    .end local v5    # "resultsBundle":Landroid/os/Bundle;
    goto :goto_0

    .line 183
    :cond_3
    const-string v1, "android.remoteinput.results"

    invoke-static {v1, v0}, Landroid/content/ClipData;->newIntent(Ljava/lang/CharSequence;Landroid/content/Intent;)Landroid/content/ClipData;

    move-result-object v1

    invoke-virtual {p1, v1}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    .line 184
    return-void
.end method

.method static addResultsToIntent([Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;Landroid/content/Intent;Landroid/os/Bundle;)V
    .locals 8
    .param p0, "remoteInputs"    # [Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    .param p1, "intent"    # Landroid/content/Intent;
    .param p2, "results"    # Landroid/os/Bundle;

    .line 138
    invoke-static {p1}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getClipDataIntentFromIntent(Landroid/content/Intent;)Landroid/content/Intent;

    move-result-object v0

    .line 139
    .local v0, "clipDataIntent":Landroid/content/Intent;
    if-nez v0, :cond_0

    .line 140
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    move-object v0, v1

    .line 142
    :cond_0
    const-string v1, "android.remoteinput.resultsData"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getBundleExtra(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v1

    .line 143
    .local v1, "resultsBundle":Landroid/os/Bundle;
    if-nez v1, :cond_1

    .line 144
    new-instance v2, Landroid/os/Bundle;

    invoke-direct {v2}, Landroid/os/Bundle;-><init>()V

    move-object v1, v2

    .line 146
    :cond_1
    array-length v2, p0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_3

    aget-object v4, p0, v3

    .line 147
    .local v4, "remoteInput":Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    invoke-virtual {v4}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getResultKey()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p2, v5}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    .line 148
    .local v5, "result":Ljava/lang/Object;
    instance-of v6, v5, Ljava/lang/CharSequence;

    if-eqz v6, :cond_2

    .line 149
    invoke-virtual {v4}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getResultKey()Ljava/lang/String;

    move-result-object v6

    move-object v7, v5

    check-cast v7, Ljava/lang/CharSequence;

    invoke-virtual {v1, v6, v7}, Landroid/os/Bundle;->putCharSequence(Ljava/lang/String;Ljava/lang/CharSequence;)V

    .line 146
    .end local v4    # "remoteInput":Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    .end local v5    # "result":Ljava/lang/Object;
    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 152
    :cond_3
    const-string v2, "android.remoteinput.resultsData"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Bundle;)Landroid/content/Intent;

    .line 153
    const-string v2, "android.remoteinput.results"

    invoke-static {v2, v0}, Landroid/content/ClipData;->newIntent(Ljava/lang/CharSequence;Landroid/content/Intent;)Landroid/content/ClipData;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    .line 154
    return-void
.end method

.method static fromBundle(Landroid/os/Bundle;Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;)Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    .locals 9
    .param p0, "data"    # Landroid/os/Bundle;
    .param p1, "factory"    # Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;

    .line 47
    const-string v0, "allowedDataTypes"

    invoke-virtual {p0, v0}, Landroid/os/Bundle;->getStringArrayList(Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v0

    .line 48
    .local v0, "allowedDataTypesAsList":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    .line 49
    .local v1, "allowedDataTypes":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    if-eqz v0, :cond_0

    .line 50
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 51
    .local v3, "type":Ljava/lang/String;
    invoke-interface {v1, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 52
    .end local v3    # "type":Ljava/lang/String;
    goto :goto_0

    .line 54
    :cond_0
    const-string v2, "resultKey"

    invoke-virtual {p0, v2}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v2, "label"

    .line 55
    invoke-virtual {p0, v2}, Landroid/os/Bundle;->getCharSequence(Ljava/lang/String;)Ljava/lang/CharSequence;

    move-result-object v4

    const-string v2, "choices"

    .line 56
    invoke-virtual {p0, v2}, Landroid/os/Bundle;->getCharSequenceArray(Ljava/lang/String;)[Ljava/lang/CharSequence;

    move-result-object v5

    const-string v2, "allowFreeFormInput"

    .line 57
    invoke-virtual {p0, v2}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v6

    const-string v2, "extras"

    .line 58
    invoke-virtual {p0, v2}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v7

    .line 54
    move-object v2, p1

    move-object v8, v1

    invoke-interface/range {v2 .. v8}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;->build(Ljava/lang/String;Ljava/lang/CharSequence;[Ljava/lang/CharSequence;ZLandroid/os/Bundle;Ljava/util/Set;)Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;

    move-result-object v2

    return-object v2
.end method

.method static fromBundleArray([Landroid/os/Bundle;Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;)[Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    .locals 3
    .param p0, "bundles"    # [Landroid/os/Bundle;
    .param p1, "factory"    # Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;

    .line 83
    if-nez p0, :cond_0

    .line 84
    const/4 v0, 0x0

    return-object v0

    .line 86
    :cond_0
    array-length v0, p0

    invoke-interface {p1, v0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;->newArray(I)[Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;

    move-result-object v0

    .line 87
    .local v0, "remoteInputs":[Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;
    const/4 v1, 0x0

    .line 87
    .local v1, "i":I
    :goto_0
    array-length v2, p0

    if-ge v1, v2, :cond_1

    .line 88
    aget-object v2, p0, v1

    invoke-static {v2, p1}, Landroid/support/v4/app/RemoteInputCompatJellybean;->fromBundle(Landroid/os/Bundle;Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput$Factory;)Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;

    move-result-object v2

    aput-object v2, v0, v1

    .line 87
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 90
    .end local v1    # "i":I
    :cond_1
    return-object v0
.end method

.method private static getClipDataIntentFromIntent(Landroid/content/Intent;)Landroid/content/Intent;
    .locals 5
    .param p0, "intent"    # Landroid/content/Intent;

    .line 191
    invoke-virtual {p0}, Landroid/content/Intent;->getClipData()Landroid/content/ClipData;

    move-result-object v0

    .line 192
    .local v0, "clipData":Landroid/content/ClipData;
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 193
    return-object v1

    .line 195
    :cond_0
    invoke-virtual {v0}, Landroid/content/ClipData;->getDescription()Landroid/content/ClipDescription;

    move-result-object v2

    .line 196
    .local v2, "clipDescription":Landroid/content/ClipDescription;
    const-string v3, "text/vnd.android.intent"

    invoke-virtual {v2, v3}, Landroid/content/ClipDescription;->hasMimeType(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_1

    .line 197
    return-object v1

    .line 199
    :cond_1
    invoke-virtual {v2}, Landroid/content/ClipDescription;->getLabel()Ljava/lang/CharSequence;

    move-result-object v3

    const-string v4, "android.remoteinput.results"

    invoke-virtual {v3, v4}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 200
    return-object v1

    .line 202
    :cond_2
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/content/ClipData;->getItemAt(I)Landroid/content/ClipData$Item;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/ClipData$Item;->getIntent()Landroid/content/Intent;

    move-result-object v1

    return-object v1
.end method

.method static getDataResultsFromIntent(Landroid/content/Intent;Ljava/lang/String;)Ljava/util/Map;
    .locals 10
    .param p0, "intent"    # Landroid/content/Intent;
    .param p1, "remoteInputResultKey"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Intent;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Landroid/net/Uri;",
            ">;"
        }
    .end annotation

    .line 113
    invoke-static {p0}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getClipDataIntentFromIntent(Landroid/content/Intent;)Landroid/content/Intent;

    move-result-object v0

    .line 114
    .local v0, "clipDataIntent":Landroid/content/Intent;
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 115
    return-object v1

    .line 117
    :cond_0
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    .line 118
    .local v2, "results":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Landroid/net/Uri;>;"
    invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v3

    .line 119
    .local v3, "extras":Landroid/os/Bundle;
    invoke-virtual {v3}, Landroid/os/Bundle;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_1
    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_5

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    .line 120
    .local v5, "key":Ljava/lang/String;
    const-string v6, "android.remoteinput.dataTypeResultsData"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_4

    .line 121
    const-string v6, "android.remoteinput.dataTypeResultsData"

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 122
    .local v6, "mimeType":Ljava/lang/String;
    if-eqz v6, :cond_1

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_2

    .line 123
    goto :goto_0

    .line 125
    :cond_2
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getBundleExtra(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v7

    .line 126
    .local v7, "bundle":Landroid/os/Bundle;
    invoke-virtual {v7, p1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 127
    .local v8, "uriStr":Ljava/lang/String;
    if-eqz v8, :cond_1

    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v9

    if-eqz v9, :cond_3

    .line 128
    goto :goto_0

    .line 130
    :cond_3
    invoke-static {v8}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v9

    invoke-interface {v2, v6, v9}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 132
    .end local v5    # "key":Ljava/lang/String;
    .end local v6    # "mimeType":Ljava/lang/String;
    .end local v7    # "bundle":Landroid/os/Bundle;
    .end local v8    # "uriStr":Ljava/lang/String;
    :cond_4
    goto :goto_0

    .line 133
    :cond_5
    invoke-interface {v2}, Ljava/util/Map;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_6

    goto :goto_1

    :cond_6
    move-object v1, v2

    :goto_1
    return-object v1
.end method

.method private static getExtraResultsKeyForData(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .param p0, "mimeType"    # Ljava/lang/String;

    .line 187
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "android.remoteinput.dataTypeResultsData"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static getResultsFromIntent(Landroid/content/Intent;)Landroid/os/Bundle;
    .locals 3
    .param p0, "intent"    # Landroid/content/Intent;

    .line 105
    invoke-static {p0}, Landroid/support/v4/app/RemoteInputCompatJellybean;->getClipDataIntentFromIntent(Landroid/content/Intent;)Landroid/content/Intent;

    move-result-object v0

    .line 106
    .local v0, "clipDataIntent":Landroid/content/Intent;
    if-nez v0, :cond_0

    .line 107
    const/4 v1, 0x0

    return-object v1

    .line 109
    :cond_0
    invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "android.remoteinput.resultsData"

    invoke-virtual {v1, v2}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/os/Bundle;

    return-object v1
.end method

.method static toBundle(Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;)Landroid/os/Bundle;
    .locals 5
    .param p0, "remoteInput"    # Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;

    .line 63
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 64
    .local v0, "data":Landroid/os/Bundle;
    const-string v1, "resultKey"

    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getResultKey()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 65
    const-string v1, "label"

    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getLabel()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putCharSequence(Ljava/lang/String;Ljava/lang/CharSequence;)V

    .line 66
    const-string v1, "choices"

    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getChoices()[Ljava/lang/CharSequence;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putCharSequenceArray(Ljava/lang/String;[Ljava/lang/CharSequence;)V

    .line 67
    const-string v1, "allowFreeFormInput"

    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getAllowFreeFormInput()Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 68
    const-string v1, "extras"

    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getExtras()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 70
    invoke-virtual {p0}, Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;->getAllowedDataTypes()Ljava/util/Set;

    move-result-object v1

    .line 71
    .local v1, "allowedDataTypes":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    if-eqz v1, :cond_1

    invoke-interface {v1}, Ljava/util/Set;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    .line 72
    new-instance v2, Ljava/util/ArrayList;

    invoke-interface {v1}, Ljava/util/Set;->size()I

    move-result v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(I)V

    .line 73
    .local v2, "allowedDataTypesAsList":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 74
    .local v4, "type":Ljava/lang/String;
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 75
    .end local v4    # "type":Ljava/lang/String;
    goto :goto_0

    .line 76
    :cond_0
    const-string v3, "allowedDataTypes"

    invoke-virtual {v0, v3, v2}, Landroid/os/Bundle;->putStringArrayList(Ljava/lang/String;Ljava/util/ArrayList;)V

    .line 78
    .end local v2    # "allowedDataTypesAsList":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_1
    return-object v0
.end method

.method static toBundleArray([Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;)[Landroid/os/Bundle;
    .locals 3
    .param p0, "remoteInputs"    # [Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;

    .line 94
    if-nez p0, :cond_0

    .line 95
    const/4 v0, 0x0

    return-object v0

    .line 97
    :cond_0
    array-length v0, p0

    new-array v0, v0, [Landroid/os/Bundle;

    .line 98
    .local v0, "bundles":[Landroid/os/Bundle;
    const/4 v1, 0x0

    .line 98
    .local v1, "i":I
    :goto_0
    array-length v2, p0

    if-ge v1, v2, :cond_1

    .line 99
    aget-object v2, p0, v1

    invoke-static {v2}, Landroid/support/v4/app/RemoteInputCompatJellybean;->toBundle(Landroid/support/v4/app/RemoteInputCompatBase$RemoteInput;)Landroid/os/Bundle;

    move-result-object v2

    aput-object v2, v0, v1

    .line 98
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 101
    .end local v1    # "i":I
    :cond_1
    return-object v0
.end method
