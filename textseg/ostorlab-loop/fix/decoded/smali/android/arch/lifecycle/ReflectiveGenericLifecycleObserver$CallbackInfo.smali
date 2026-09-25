.class Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
.super Ljava/lang/Object;
.source "ReflectiveGenericLifecycleObserver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "CallbackInfo"
.end annotation


# instance fields
.field final mEventToHandlers:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            "Ljava/util/List<",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            ">;>;"
        }
    .end annotation
.end field

.field final mHandlerToEvent:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Ljava/util/Map;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            ">;)V"
        }
    .end annotation

    .line 171
    .local p1, "handlerToEvent":Ljava/util/Map;, "Ljava/util/Map<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 172
    iput-object p1, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mHandlerToEvent:Ljava/util/Map;

    .line 173
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mEventToHandlers:Ljava/util/Map;

    .line 174
    invoke-interface {p1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 175
    .local v1, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/arch/lifecycle/Lifecycle$Event;

    .line 176
    .local v2, "event":Landroid/arch/lifecycle/Lifecycle$Event;
    iget-object v3, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mEventToHandlers:Ljava/util/Map;

    invoke-interface {v3, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/List;

    .line 177
    .local v3, "methodReferences":Ljava/util/List;, "Ljava/util/List<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;>;"
    if-nez v3, :cond_0

    .line 178
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    move-object v3, v4

    .line 179
    iget-object v4, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mEventToHandlers:Ljava/util/Map;

    invoke-interface {v4, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 181
    :cond_0
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 182
    .end local v1    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    .end local v2    # "event":Landroid/arch/lifecycle/Lifecycle$Event;
    .end local v3    # "methodReferences":Ljava/util/List;, "Ljava/util/List<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;>;"
    goto :goto_0

    .line 183
    :cond_1
    return-void
.end method
