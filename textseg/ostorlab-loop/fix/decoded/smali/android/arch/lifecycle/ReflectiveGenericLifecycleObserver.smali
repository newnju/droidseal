.class Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;
.super Ljava/lang/Object;
.source "ReflectiveGenericLifecycleObserver.java"

# interfaces
.implements Landroid/arch/lifecycle/GenericLifecycleObserver;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;,
        Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    }
.end annotation


# static fields
.field private static final CALL_TYPE_NO_ARG:I = 0x0

.field private static final CALL_TYPE_PROVIDER:I = 0x1

.field private static final CALL_TYPE_PROVIDER_WITH_EVENT:I = 0x2

.field static final sInfoCache:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Class;",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private final mInfo:Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

.field private final mWrapped:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 36
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->sInfoCache:Ljava/util/Map;

    return-void
.end method

.method constructor <init>(Ljava/lang/Object;)V
    .locals 1
    .param p1, "wrapped"    # Ljava/lang/Object;

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mWrapped:Ljava/lang/Object;

    .line 40
    iget-object v0, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mWrapped:Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-static {v0}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->getInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    move-result-object v0

    iput-object v0, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mInfo:Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    .line 41
    return-void
.end method

.method private static createInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    .locals 14
    .param p0, "klass"    # Ljava/lang/Class;

    .line 110
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v0

    .line 111
    .local v0, "superclass":Ljava/lang/Class;
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 112
    .local v1, "handlerToEvent":Ljava/util/Map;, "Ljava/util/Map<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    if-eqz v0, :cond_0

    .line 113
    invoke-static {v0}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->getInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    move-result-object v2

    .line 114
    .local v2, "superInfo":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    if-eqz v2, :cond_0

    .line 115
    iget-object v3, v2, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mHandlerToEvent:Ljava/util/Map;

    invoke-interface {v1, v3}, Ljava/util/Map;->putAll(Ljava/util/Map;)V

    .line 119
    .end local v2    # "superInfo":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    :cond_0
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    .line 121
    .local v2, "methods":[Ljava/lang/reflect/Method;
    invoke-virtual {p0}, Ljava/lang/Class;->getInterfaces()[Ljava/lang/Class;

    move-result-object v3

    .line 122
    .local v3, "interfaces":[Ljava/lang/Class;
    array-length v4, v3

    const/4 v5, 0x0

    move v6, v5

    :goto_0
    if-ge v6, v4, :cond_2

    aget-object v7, v3, v6

    .line 123
    .local v7, "intrfc":Ljava/lang/Class;
    invoke-static {v7}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->getInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    move-result-object v8

    iget-object v8, v8, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mHandlerToEvent:Ljava/util/Map;

    invoke-interface {v8}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v8

    invoke-interface {v8}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v8

    :goto_1
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-eqz v9, :cond_1

    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/util/Map$Entry;

    .line 124
    .local v9, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    invoke-interface {v9}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;

    invoke-interface {v9}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/arch/lifecycle/Lifecycle$Event;

    invoke-static {v1, v10, v11, p0}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->verifyAndPutHandler(Ljava/util/Map;Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;Ljava/lang/Class;)V

    .line 125
    .end local v9    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    goto :goto_1

    .line 122
    .end local v7    # "intrfc":Ljava/lang/Class;
    :cond_1
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 128
    :cond_2
    array-length v4, v2

    move v6, v5

    :goto_2
    if-ge v6, v4, :cond_8

    aget-object v7, v2, v6

    .line 129
    .local v7, "method":Ljava/lang/reflect/Method;
    const-class v8, Landroid/arch/lifecycle/OnLifecycleEvent;

    invoke-virtual {v7, v8}, Ljava/lang/reflect/Method;->getAnnotation(Ljava/lang/Class;)Ljava/lang/annotation/Annotation;

    move-result-object v8

    check-cast v8, Landroid/arch/lifecycle/OnLifecycleEvent;

    .line 130
    .local v8, "annotation":Landroid/arch/lifecycle/OnLifecycleEvent;
    if-nez v8, :cond_3

    .line 131
    goto :goto_3

    .line 133
    :cond_3
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v9

    .line 134
    .local v9, "params":[Ljava/lang/Class;, "[Ljava/lang/Class<*>;"
    const/4 v10, 0x0

    .line 135
    .local v10, "callType":I
    array-length v11, v9

    if-lez v11, :cond_4

    .line 136
    const/4 v10, 0x1

    .line 137
    aget-object v11, v9, v5

    const-class v12, Landroid/arch/lifecycle/LifecycleOwner;

    invoke-virtual {v11, v12}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v11

    if-nez v11, :cond_4

    .line 138
    new-instance v4, Ljava/lang/IllegalArgumentException;

    const-string v5, "invalid parameter type. Must be one and instanceof LifecycleOwner"

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 142
    :cond_4
    invoke-interface {v8}, Landroid/arch/lifecycle/OnLifecycleEvent;->value()Landroid/arch/lifecycle/Lifecycle$Event;

    move-result-object v11

    .line 144
    .local v11, "event":Landroid/arch/lifecycle/Lifecycle$Event;
    array-length v12, v9

    const/4 v13, 0x1

    if-le v12, v13, :cond_6

    .line 145
    const/4 v10, 0x2

    .line 146
    aget-object v12, v9, v13

    const-class v13, Landroid/arch/lifecycle/Lifecycle$Event;

    invoke-virtual {v12, v13}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v12

    if-nez v12, :cond_5

    .line 147
    new-instance v4, Ljava/lang/IllegalArgumentException;

    const-string v5, "invalid parameter type. second arg must be an event"

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 150
    :cond_5
    sget-object v12, Landroid/arch/lifecycle/Lifecycle$Event;->ON_ANY:Landroid/arch/lifecycle/Lifecycle$Event;

    if-eq v11, v12, :cond_6

    .line 151
    new-instance v4, Ljava/lang/IllegalArgumentException;

    const-string v5, "Second arg is supported only for ON_ANY value"

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 155
    :cond_6
    array-length v12, v9

    const/4 v13, 0x2

    if-le v12, v13, :cond_7

    .line 156
    new-instance v4, Ljava/lang/IllegalArgumentException;

    const-string v5, "cannot have more than 2 params"

    invoke-direct {v4, v5}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v4

    .line 158
    :cond_7
    new-instance v12, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;

    invoke-direct {v12, v10, v7}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;-><init>(ILjava/lang/reflect/Method;)V

    .line 159
    .local v12, "methodReference":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    invoke-static {v1, v12, v11, p0}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->verifyAndPutHandler(Ljava/util/Map;Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;Ljava/lang/Class;)V

    .line 128
    .end local v7    # "method":Ljava/lang/reflect/Method;
    .end local v8    # "annotation":Landroid/arch/lifecycle/OnLifecycleEvent;
    .end local v9    # "params":[Ljava/lang/Class;, "[Ljava/lang/Class<*>;"
    .end local v10    # "callType":I
    .end local v11    # "event":Landroid/arch/lifecycle/Lifecycle$Event;
    .end local v12    # "methodReference":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    :goto_3
    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    .line 161
    :cond_8
    new-instance v4, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    invoke-direct {v4, v1}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;-><init>(Ljava/util/Map;)V

    .line 162
    .local v4, "info":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    sget-object v5, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->sInfoCache:Ljava/util/Map;

    invoke-interface {v5, p0, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 163
    return-object v4
.end method

.method private static getInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    .locals 1
    .param p0, "klass"    # Ljava/lang/Class;

    .line 86
    sget-object v0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->sInfoCache:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    .line 87
    .local v0, "existing":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    if-eqz v0, :cond_0

    .line 88
    return-object v0

    .line 90
    :cond_0
    invoke-static {p0}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->createInfo(Ljava/lang/Class;)Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    move-result-object v0

    .line 91
    return-object v0
.end method

.method private invokeCallback(Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V
    .locals 5
    .param p1, "reference"    # Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    .param p2, "source"    # Landroid/arch/lifecycle/LifecycleOwner;
    .param p3, "event"    # Landroid/arch/lifecycle/Lifecycle$Event;

    .line 67
    :try_start_0
    iget v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;->mCallType:I

    const/4 v1, 0x1

    const/4 v2, 0x0

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 75
    :pswitch_0
    iget-object v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;->mMethod:Ljava/lang/reflect/Method;

    iget-object v3, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mWrapped:Ljava/lang/Object;

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    aput-object p2, v4, v2

    aput-object p3, v4, v1

    invoke-virtual {v0, v3, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 72
    :pswitch_1
    iget-object v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;->mMethod:Ljava/lang/reflect/Method;

    iget-object v3, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mWrapped:Ljava/lang/Object;

    new-array v1, v1, [Ljava/lang/Object;

    aput-object p2, v1, v2

    invoke-virtual {v0, v3, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 73
    goto :goto_0

    .line 69
    :pswitch_2
    iget-object v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;->mMethod:Ljava/lang/reflect/Method;

    iget-object v1, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mWrapped:Ljava/lang/Object;

    new-array v2, v2, [Ljava/lang/Object;

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0

    .line 70
    nop

    .line 82
    :goto_0
    nop

    .line 83
    return-void

    .line 80
    :catch_0
    move-exception v0

    .line 81
    .local v0, "e":Ljava/lang/IllegalAccessException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 78
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :catch_1
    move-exception v0

    .line 79
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v1, Ljava/lang/RuntimeException;

    const-string v2, "Failed to call observer method"

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getCause()Ljava/lang/Throwable;

    move-result-object v3

    invoke-direct {v1, v2, v3}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private invokeCallbacks(Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V
    .locals 2
    .param p1, "info"    # Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;
    .param p2, "source"    # Landroid/arch/lifecycle/LifecycleOwner;
    .param p3, "event"    # Landroid/arch/lifecycle/Lifecycle$Event;

    .line 60
    iget-object v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mEventToHandlers:Ljava/util/Map;

    invoke-interface {v0, p3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    invoke-direct {p0, v0, p2, p3}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->invokeMethodsForEvent(Ljava/util/List;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V

    .line 61
    iget-object v0, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;->mEventToHandlers:Ljava/util/Map;

    sget-object v1, Landroid/arch/lifecycle/Lifecycle$Event;->ON_ANY:Landroid/arch/lifecycle/Lifecycle$Event;

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    invoke-direct {p0, v0, p2, p3}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->invokeMethodsForEvent(Ljava/util/List;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V

    .line 62
    return-void
.end method

.method private invokeMethodsForEvent(Ljava/util/List;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V
    .locals 2
    .param p2, "source"    # Landroid/arch/lifecycle/LifecycleOwner;
    .param p3, "event"    # Landroid/arch/lifecycle/Lifecycle$Event;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            ">;",
            "Landroid/arch/lifecycle/LifecycleOwner;",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            ")V"
        }
    .end annotation

    .line 50
    .local p1, "handlers":Ljava/util/List;, "Ljava/util/List<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;>;"
    if-eqz p1, :cond_0

    .line 51
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .line 51
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_0

    .line 52
    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;

    .line 53
    .local v1, "reference":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    invoke-direct {p0, v1, p2, p3}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->invokeCallback(Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V

    .line 51
    .end local v1    # "reference":Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 56
    .end local v0    # "i":I
    :cond_0
    return-void
.end method

.method private static verifyAndPutHandler(Ljava/util/Map;Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;Ljava/lang/Class;)V
    .locals 5
    .param p1, "newHandler"    # Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;
    .param p2, "newEvent"    # Landroid/arch/lifecycle/Lifecycle$Event;
    .param p3, "klass"    # Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            ">;",
            "Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;",
            "Landroid/arch/lifecycle/Lifecycle$Event;",
            "Ljava/lang/Class;",
            ")V"
        }
    .end annotation

    .line 96
    .local p0, "handlers":Ljava/util/Map;, "Ljava/util/Map<Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;Landroid/arch/lifecycle/Lifecycle$Event;>;"
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/arch/lifecycle/Lifecycle$Event;

    .line 97
    .local v0, "event":Landroid/arch/lifecycle/Lifecycle$Event;
    if-eqz v0, :cond_0

    if-eq p2, v0, :cond_0

    .line 98
    iget-object v1, p1, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$MethodReference;->mMethod:Ljava/lang/reflect/Method;

    .line 99
    .local v1, "method":Ljava/lang/reflect/Method;
    new-instance v2, Ljava/lang/IllegalArgumentException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Method "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 100
    invoke-virtual {v1}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " in "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " already declared with different @OnLifecycleEvent value: previous"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " value "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", new value "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v2

    .line 104
    .end local v1    # "method":Ljava/lang/reflect/Method;
    :cond_0
    if-nez v0, :cond_1

    .line 105
    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 107
    :cond_1
    return-void
.end method


# virtual methods
.method public onStateChanged(Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V
    .locals 1
    .param p1, "source"    # Landroid/arch/lifecycle/LifecycleOwner;
    .param p2, "event"    # Landroid/arch/lifecycle/Lifecycle$Event;

    .line 45
    iget-object v0, p0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->mInfo:Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;

    invoke-direct {p0, v0, p1, p2}, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;->invokeCallbacks(Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver$CallbackInfo;Landroid/arch/lifecycle/LifecycleOwner;Landroid/arch/lifecycle/Lifecycle$Event;)V

    .line 46
    return-void
.end method
