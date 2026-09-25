.class Landroid/arch/lifecycle/Lifecycling;
.super Ljava/lang/Object;
.source "Lifecycling.java"


# annotations
.annotation build Landroid/support/annotation/RestrictTo;
    value = {
        .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
    }
.end annotation


# static fields
.field private static sCallbackCache:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Class;",
            "Ljava/lang/reflect/Constructor<",
            "+",
            "Landroid/arch/lifecycle/GenericLifecycleObserver;",
            ">;>;"
        }
    .end annotation
.end field

.field private static sREFLECTIVE:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "+",
            "Landroid/arch/lifecycle/GenericLifecycleObserver;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 38
    :try_start_0
    const-class v0, Landroid/arch/lifecycle/ReflectiveGenericLifecycleObserver;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    const-class v3, Ljava/lang/Object;

    aput-object v3, v1, v2

    .line 39
    invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    sput-object v0, Landroid/arch/lifecycle/Lifecycling;->sREFLECTIVE:Ljava/lang/reflect/Constructor;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 42
    goto :goto_0

    .line 40
    :catch_0
    move-exception v0

    .line 45
    :goto_0
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Landroid/arch/lifecycle/Lifecycling;->sCallbackCache:Ljava/util/Map;

    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static getAdapterName(Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p0, "className"    # Ljava/lang/String;

    .line 112
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "."

    const-string v2, "_"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "_LifecycleAdapter"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static getCallback(Ljava/lang/Object;)Landroid/arch/lifecycle/GenericLifecycleObserver;
    .locals 5
    .param p0, "object"    # Ljava/lang/Object;
    .annotation build Landroid/support/annotation/NonNull;
    .end annotation

    .line 50
    instance-of v0, p0, Landroid/arch/lifecycle/GenericLifecycleObserver;

    if-eqz v0, :cond_0

    .line 51
    move-object v0, p0

    check-cast v0, Landroid/arch/lifecycle/GenericLifecycleObserver;

    return-object v0

    .line 55
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    .line 56
    .local v0, "klass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    sget-object v1, Landroid/arch/lifecycle/Lifecycling;->sCallbackCache:Ljava/util/Map;

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/reflect/Constructor;

    .line 58
    .local v1, "cachedConstructor":Ljava/lang/reflect/Constructor;, "Ljava/lang/reflect/Constructor<+Landroid/arch/lifecycle/GenericLifecycleObserver;>;"
    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v1, :cond_1

    .line 59
    new-array v3, v3, [Ljava/lang/Object;

    aput-object p0, v3, v2

    invoke-virtual {v1, v3}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/arch/lifecycle/GenericLifecycleObserver;

    return-object v2

    .line 61
    :cond_1
    invoke-static {v0}, Landroid/arch/lifecycle/Lifecycling;->getGeneratedAdapterConstructor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v4

    move-object v1, v4

    .line 62
    if-eqz v1, :cond_2

    .line 63
    invoke-virtual {v1}, Ljava/lang/reflect/Constructor;->isAccessible()Z

    move-result v4

    if-nez v4, :cond_3

    .line 64
    invoke-virtual {v1, v3}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    goto :goto_0

    .line 67
    :cond_2
    sget-object v4, Landroid/arch/lifecycle/Lifecycling;->sREFLECTIVE:Ljava/lang/reflect/Constructor;

    move-object v1, v4

    .line 69
    :cond_3
    :goto_0
    sget-object v4, Landroid/arch/lifecycle/Lifecycling;->sCallbackCache:Ljava/util/Map;

    invoke-interface {v4, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 70
    new-array v3, v3, [Ljava/lang/Object;

    aput-object p0, v3, v2

    invoke-virtual {v1, v3}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/arch/lifecycle/GenericLifecycleObserver;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/InstantiationException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v2

    .line 75
    .end local v0    # "klass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    .end local v1    # "cachedConstructor":Ljava/lang/reflect/Constructor;, "Ljava/lang/reflect/Constructor<+Landroid/arch/lifecycle/GenericLifecycleObserver;>;"
    :catch_0
    move-exception v0

    .line 76
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 73
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 74
    .local v0, "e":Ljava/lang/InstantiationException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1

    .line 71
    .end local v0    # "e":Ljava/lang/InstantiationException;
    :catch_2
    move-exception v0

    .line 72
    .local v0, "e":Ljava/lang/IllegalAccessException;
    new-instance v1, Ljava/lang/RuntimeException;

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static getGeneratedAdapterConstructor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;
    .locals 8
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Constructor<",
            "+",
            "Landroid/arch/lifecycle/GenericLifecycleObserver;",
            ">;"
        }
    .end annotation

    .line 83
    .local p0, "klass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    invoke-virtual {p0}, Ljava/lang/Class;->getPackage()Ljava/lang/Package;

    move-result-object v0

    .line 84
    .local v0, "aPackage":Ljava/lang/Package;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Package;->getName()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, ""

    .line 86
    .local v1, "fullPackage":Ljava/lang/String;
    :goto_0
    invoke-virtual {p0}, Ljava/lang/Class;->getCanonicalName()Ljava/lang/String;

    move-result-object v2

    .line 88
    .local v2, "name":Ljava/lang/String;
    const/4 v3, 0x0

    if-nez v2, :cond_1

    .line 89
    return-object v3

    .line 91
    :cond_1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    const/4 v5, 0x1

    if-eqz v4, :cond_2

    move-object v4, v2

    goto :goto_1

    .line 92
    :cond_2
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v4

    add-int/2addr v4, v5

    invoke-virtual {v2, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    .line 91
    :goto_1
    invoke-static {v4}, Landroid/arch/lifecycle/Lifecycling;->getAdapterName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 95
    .local v4, "adapterName":Ljava/lang/String;
    nop

    .line 97
    :try_start_0
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_3

    .line 96
    move-object v6, v4

    goto :goto_2

    .line 97
    :cond_3
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "."

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 96
    :goto_2
    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    .line 98
    .local v6, "aClass":Ljava/lang/Class;, "Ljava/lang/Class<+Landroid/arch/lifecycle/GenericLifecycleObserver;>;"
    new-array v5, v5, [Ljava/lang/Class;

    const/4 v7, 0x0

    aput-object p0, v5, v7

    invoke-virtual {v6, v5}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v5
    :try_end_0
    .catch Ljava/lang/ClassNotFoundException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v5

    .line 104
    .end local v6    # "aClass":Ljava/lang/Class;, "Ljava/lang/Class<+Landroid/arch/lifecycle/GenericLifecycleObserver;>;"
    :catch_0
    move-exception v3

    .line 106
    .local v3, "e":Ljava/lang/NoSuchMethodException;
    new-instance v5, Ljava/lang/RuntimeException;

    invoke-direct {v5, v3}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v5

    .line 99
    .end local v3    # "e":Ljava/lang/NoSuchMethodException;
    :catch_1
    move-exception v5

    .line 100
    .local v5, "e":Ljava/lang/ClassNotFoundException;
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v6

    .line 101
    .local v6, "superclass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    if-eqz v6, :cond_4

    .line 102
    invoke-static {v6}, Landroid/arch/lifecycle/Lifecycling;->getGeneratedAdapterConstructor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    return-object v3

    .line 107
    .end local v5    # "e":Ljava/lang/ClassNotFoundException;
    .end local v6    # "superclass":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    :cond_4
    nop

    .line 108
    return-object v3
.end method
