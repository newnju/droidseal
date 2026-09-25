.class Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;
.super Ljava/lang/Object;
.source "AppCompatTextViewAutoSizeHelper.java"


# static fields
.field private static final DEFAULT_AUTO_SIZE_GRANULARITY_IN_PX:I = 0x1

.field private static final DEFAULT_AUTO_SIZE_MAX_TEXT_SIZE_IN_SP:I = 0x70

.field private static final DEFAULT_AUTO_SIZE_MIN_TEXT_SIZE_IN_SP:I = 0xc

.field private static final TAG:Ljava/lang/String; = "ACTVAutoSizeHelper"

.field private static final TEMP_RECTF:Landroid/graphics/RectF;

.field static final UNSET_AUTO_SIZE_UNIFORM_CONFIGURATION_VALUE:F = -1.0f

.field private static final VERY_WIDE:I = 0x100000

.field private static sTextViewMethodByNameCache:Ljava/util/Hashtable;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Hashtable<",
            "Ljava/lang/String;",
            "Ljava/lang/reflect/Method;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mAutoSizeMaxTextSizeInPx:F

.field private mAutoSizeMinTextSizeInPx:F

.field private mAutoSizeStepGranularityInPx:F

.field private mAutoSizeTextSizesInPx:[I

.field private mAutoSizeTextType:I

.field private final mContext:Landroid/content/Context;

.field private mHasPresetAutoSizeValues:Z

.field private mNeedsAutoSizeText:Z

.field private mTempTextPaint:Landroid/text/TextPaint;

.field private final mTextView:Landroid/widget/TextView;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 59
    new-instance v0, Landroid/graphics/RectF;

    invoke-direct {v0}, Landroid/graphics/RectF;-><init>()V

    sput-object v0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    .line 68
    new-instance v0, Ljava/util/Hashtable;

    invoke-direct {v0}, Ljava/util/Hashtable;-><init>()V

    sput-object v0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->sTextViewMethodByNameCache:Ljava/util/Hashtable;

    return-void
.end method

.method constructor <init>(Landroid/widget/TextView;)V
    .locals 2
    .param p1, "textView"    # Landroid/widget/TextView;

    .line 96
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 75
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 77
    iput-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    .line 79
    const/high16 v1, -0x40800000    # -1.0f

    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    .line 81
    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    .line 83
    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    .line 86
    new-array v1, v0, [I

    iput-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    .line 90
    iput-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    .line 97
    iput-object p1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 98
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    .line 99
    return-void
.end method

.method private cleanupAutoSizePresetSizes([I)[I
    .locals 6
    .param p1, "presetValues"    # [I

    .line 444
    array-length v0, p1

    .line 445
    .local v0, "presetValuesLength":I
    if-nez v0, :cond_0

    .line 446
    return-object p1

    .line 448
    :cond_0
    invoke-static {p1}, Ljava/util/Arrays;->sort([I)V

    .line 450
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 451
    .local v1, "uniqueValidSizes":Ljava/util/List;, "Ljava/util/List<Ljava/lang/Integer;>;"
    const/4 v2, 0x0

    move v3, v2

    .line 451
    .local v3, "i":I
    :goto_0
    if-ge v3, v0, :cond_2

    .line 452
    aget v4, p1, v3

    .line 454
    .local v4, "currentPresetValue":I
    if-lez v4, :cond_1

    .line 455
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-static {v1, v5}, Ljava/util/Collections;->binarySearch(Ljava/util/List;Ljava/lang/Object;)I

    move-result v5

    if-gez v5, :cond_1

    .line 456
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v1, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 451
    .end local v4    # "currentPresetValue":I
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 460
    .end local v3    # "i":I
    :cond_2
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    if-ne v0, v3, :cond_3

    .line 461
    return-object p1

    .line 463
    :cond_3
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    .line 464
    .local v3, "uniqueValidSizesLength":I
    new-array v4, v3, [I

    .line 465
    .local v4, "cleanedUpSizes":[I
    nop

    .line 465
    .local v2, "i":I
    :goto_1
    if-ge v2, v3, :cond_4

    .line 466
    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    aput v5, v4, v2

    .line 465
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 468
    .end local v2    # "i":I
    :cond_4
    return-object v4
.end method

.method private clearAutoSizeConfiguration()V
    .locals 2

    .line 582
    const/4 v0, 0x0

    iput v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 583
    const/high16 v1, -0x40800000    # -1.0f

    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    .line 584
    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    .line 585
    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    .line 586
    new-array v1, v0, [I

    iput-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    .line 587
    iput-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    .line 588
    return-void
.end method

.method private createStaticLayoutForMeasuring(Ljava/lang/CharSequence;Landroid/text/Layout$Alignment;II)Landroid/text/StaticLayout;
    .locals 5
    .param p1, "text"    # Ljava/lang/CharSequence;
    .param p2, "alignment"    # Landroid/text/Layout$Alignment;
    .param p3, "availableWidth"    # I
    .param p4, "maxLines"    # I
    .annotation build Landroid/annotation/TargetApi;
        value = 0x17
    .end annotation

    .line 700
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v1, "getTextDirectionHeuristic"

    sget-object v2, Landroid/text/TextDirectionHeuristics;->FIRSTSTRONG_LTR:Landroid/text/TextDirectionHeuristic;

    invoke-direct {p0, v0, v1, v2}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/text/TextDirectionHeuristic;

    .line 704
    .local v0, "textDirectionHeuristic":Landroid/text/TextDirectionHeuristic;
    nop

    .line 705
    invoke-interface {p1}, Ljava/lang/CharSequence;->length()I

    move-result v1

    iget-object v2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    .line 704
    const/4 v3, 0x0

    invoke-static {p1, v3, v1, v2, p3}, Landroid/text/StaticLayout$Builder;->obtain(Ljava/lang/CharSequence;IILandroid/text/TextPaint;I)Landroid/text/StaticLayout$Builder;

    move-result-object v1

    .line 707
    .local v1, "layoutBuilder":Landroid/text/StaticLayout$Builder;
    invoke-virtual {v1, p2}, Landroid/text/StaticLayout$Builder;->setAlignment(Landroid/text/Layout$Alignment;)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 709
    invoke-virtual {v3}, Landroid/widget/TextView;->getLineSpacingExtra()F

    move-result v3

    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 710
    invoke-virtual {v4}, Landroid/widget/TextView;->getLineSpacingMultiplier()F

    move-result v4

    .line 708
    invoke-virtual {v2, v3, v4}, Landroid/text/StaticLayout$Builder;->setLineSpacing(FF)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 711
    invoke-virtual {v3}, Landroid/widget/TextView;->getIncludeFontPadding()Z

    move-result v3

    invoke-virtual {v2, v3}, Landroid/text/StaticLayout$Builder;->setIncludePad(Z)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 712
    invoke-virtual {v3}, Landroid/widget/TextView;->getBreakStrategy()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/text/StaticLayout$Builder;->setBreakStrategy(I)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 713
    invoke-virtual {v3}, Landroid/widget/TextView;->getHyphenationFrequency()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/text/StaticLayout$Builder;->setHyphenationFrequency(I)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    const/4 v3, -0x1

    if-ne p4, v3, :cond_0

    const v3, 0x7fffffff

    goto :goto_0

    .line 714
    :cond_0
    move v3, p4

    :goto_0
    invoke-virtual {v2, v3}, Landroid/text/StaticLayout$Builder;->setMaxLines(I)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    .line 715
    invoke-virtual {v2, v0}, Landroid/text/StaticLayout$Builder;->setTextDirection(Landroid/text/TextDirectionHeuristic;)Landroid/text/StaticLayout$Builder;

    move-result-object v2

    .line 716
    invoke-virtual {v2}, Landroid/text/StaticLayout$Builder;->build()Landroid/text/StaticLayout;

    move-result-object v2

    return-object v2
.end method

.method private createStaticLayoutForMeasuringPre23(Ljava/lang/CharSequence;Landroid/text/Layout$Alignment;I)Landroid/text/StaticLayout;
    .locals 12
    .param p1, "text"    # Ljava/lang/CharSequence;
    .param p2, "alignment"    # Landroid/text/Layout$Alignment;
    .param p3, "availableWidth"    # I
    .annotation build Landroid/annotation/TargetApi;
        value = 0xe
    .end annotation

    .line 723
    const/high16 v0, 0x3f800000    # 1.0f

    .line 724
    .local v0, "lineSpacingMultiplier":F
    const/4 v1, 0x0

    .line 725
    .local v1, "lineSpacingAdd":F
    const/4 v2, 0x1

    .line 727
    .local v2, "includePad":Z
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v4, 0x10

    if-lt v3, v4, :cond_0

    .line 729
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getLineSpacingMultiplier()F

    move-result v0

    .line 730
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getLineSpacingExtra()F

    move-result v1

    .line 731
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getIncludeFontPadding()Z

    move-result v2

    goto :goto_0

    .line 735
    :cond_0
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v4, "getLineSpacingMultiplier"

    .line 736
    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v5

    .line 735
    invoke-direct {p0, v3, v4, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Float;

    invoke-virtual {v3}, Ljava/lang/Float;->floatValue()F

    move-result v0

    .line 737
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v4, "getLineSpacingExtra"

    .line 738
    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v5

    .line 737
    invoke-direct {p0, v3, v4, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Float;

    invoke-virtual {v3}, Ljava/lang/Float;->floatValue()F

    move-result v1

    .line 739
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v4, "getIncludeFontPadding"

    .line 740
    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    .line 739
    invoke-direct {p0, v3, v4, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Boolean;

    invoke-virtual {v3}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    .line 745
    :goto_0
    new-instance v11, Landroid/text/StaticLayout;

    iget-object v5, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    move-object v3, v11

    move-object v4, p1

    move v6, p3

    move-object v7, p2

    move v8, v0

    move v9, v1

    move v10, v2

    invoke-direct/range {v3 .. v10}, Landroid/text/StaticLayout;-><init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FFZ)V

    return-object v11
.end method

.method private findLargestTextSizeWhichFits(Landroid/graphics/RectF;)I
    .locals 6
    .param p1, "availableSpace"    # Landroid/graphics/RectF;

    .line 639
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    array-length v0, v0

    .line 640
    .local v0, "sizesCount":I
    if-nez v0, :cond_0

    .line 641
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "No available text sizes to choose from."

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 644
    :cond_0
    const/4 v1, 0x0

    .line 645
    .local v1, "bestSizeIndex":I
    add-int/lit8 v2, v1, 0x1

    .line 646
    .local v2, "lowIndex":I
    add-int/lit8 v3, v0, -0x1

    .line 648
    .local v3, "highIndex":I
    :goto_0
    if-gt v2, v3, :cond_2

    .line 649
    add-int v4, v2, v3

    div-int/lit8 v4, v4, 0x2

    .line 650
    .local v4, "sizeToTryIndex":I
    iget-object v5, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    aget v5, v5, v4

    invoke-direct {p0, v5, p1}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->suggestedSizeFitsInSpace(ILandroid/graphics/RectF;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 651
    move v1, v2

    .line 652
    add-int/lit8 v2, v4, 0x1

    goto :goto_0

    .line 654
    :cond_1
    add-int/lit8 v3, v4, -0x1

    .line 655
    move v1, v3

    .line 655
    .end local v4    # "sizeToTryIndex":I
    goto :goto_0

    .line 659
    :cond_2
    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    aget v4, v4, v1

    return v4
.end method

.method private getTextViewMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;
    .locals 4
    .param p1, "methodName"    # Ljava/lang/String;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroid/support/annotation/Nullable;
    .end annotation

    .line 776
    :try_start_0
    sget-object v0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->sTextViewMethodByNameCache:Ljava/util/Hashtable;

    invoke-virtual {v0, p1}, Ljava/util/Hashtable;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/reflect/Method;

    .line 777
    .local v0, "method":Ljava/lang/reflect/Method;
    if-nez v0, :cond_0

    .line 778
    const-class v1, Landroid/widget/TextView;

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Class;

    invoke-virtual {v1, p1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    move-object v0, v1

    .line 779
    if-eqz v0, :cond_0

    .line 780
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 782
    sget-object v1, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->sTextViewMethodByNameCache:Ljava/util/Hashtable;

    invoke-virtual {v1, p1, v0}, Ljava/util/Hashtable;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 786
    :cond_0
    return-object v0

    .line 787
    .end local v0    # "method":Ljava/lang/reflect/Method;
    :catch_0
    move-exception v0

    .line 788
    .local v0, "ex":Ljava/lang/Exception;
    const-string v1, "ACTVAutoSizeHelper"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Failed to retrieve TextView#"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "() method"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 789
    const/4 v1, 0x0

    return-object v1
.end method

.method private invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6
    .param p1, "object"    # Ljava/lang/Object;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "methodName"    # Ljava/lang/String;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p3    # Ljava/lang/Object;
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            "TT;)TT;"
        }
    .end annotation

    .line 754
    .local p3, "defaultValue":Ljava/lang/Object;, "TT;"
    const/4 v0, 0x0

    .line 755
    .local v0, "result":Ljava/lang/Object;, "TT;"
    const/4 v1, 0x0

    move v2, v1

    .line 759
    .local v2, "exceptionThrown":Z
    :try_start_0
    invoke-direct {p0, p2}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->getTextViewMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 760
    .local v3, "method":Ljava/lang/reflect/Method;
    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v3, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-object v0, v1

    .line 765
    .end local v3    # "method":Ljava/lang/reflect/Method;
    if-nez v0, :cond_0

    if-eqz v2, :cond_0

    .line 766
    :goto_0
    move-object v0, p3

    goto :goto_1

    .line 765
    :catchall_0
    move-exception v1

    goto :goto_2

    .line 761
    :catch_0
    move-exception v1

    .line 762
    .local v1, "ex":Ljava/lang/Exception;
    const/4 v2, 0x1

    .line 763
    :try_start_1
    const-string v3, "ACTVAutoSizeHelper"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Failed to invoke TextView#"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "() method"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 765
    .end local v1    # "ex":Ljava/lang/Exception;
    if-nez v0, :cond_0

    if-eqz v2, :cond_0

    goto :goto_0

    .line 770
    :cond_0
    :goto_1
    return-object v0

    .line 765
    :goto_2
    if-nez v0, :cond_1

    if-eqz v2, :cond_1

    .line 766
    move-object v0, p3

    :cond_1
    throw v1
.end method

.method private setRawTextSize(F)V
    .locals 5
    .param p1, "size"    # F

    .line 601
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object v0

    invoke-virtual {v0}, Landroid/text/TextPaint;->getTextSize()F

    move-result v0

    cmpl-float v0, p1, v0

    if-eqz v0, :cond_3

    .line 602
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 604
    const/4 v0, 0x0

    .line 605
    .local v0, "isInLayout":Z
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x12

    if-lt v1, v2, :cond_0

    .line 606
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->isInLayout()Z

    move-result v0

    .line 609
    :cond_0
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getLayout()Landroid/text/Layout;

    move-result-object v1

    if-eqz v1, :cond_3

    .line 611
    const/4 v1, 0x0

    iput-boolean v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    .line 613
    const-string v2, "nullLayouts"

    .line 615
    .local v2, "methodName":Ljava/lang/String;
    :try_start_0
    const-string v3, "nullLayouts"

    invoke-direct {p0, v3}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->getTextViewMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 616
    .local v3, "method":Ljava/lang/reflect/Method;
    if-eqz v3, :cond_1

    .line 617
    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v3, v4, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 621
    .end local v3    # "method":Ljava/lang/reflect/Method;
    :cond_1
    goto :goto_0

    .line 619
    :catch_0
    move-exception v1

    .line 620
    .local v1, "ex":Ljava/lang/Exception;
    const-string v3, "ACTVAutoSizeHelper"

    const-string v4, "Failed to invoke TextView#nullLayouts() method"

    invoke-static {v3, v4, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 623
    .end local v1    # "ex":Ljava/lang/Exception;
    :goto_0
    if-nez v0, :cond_2

    .line 624
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->requestLayout()V

    goto :goto_1

    .line 626
    :cond_2
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->forceLayout()V

    .line 629
    :goto_1
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->invalidate()V

    .line 632
    .end local v0    # "isInLayout":Z
    .end local v2    # "methodName":Ljava/lang/String;
    :cond_3
    return-void
.end method

.method private setupAutoSizeText()Z
    .locals 7

    .line 507
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    const/4 v2, 0x1

    if-ne v0, v2, :cond_4

    .line 511
    iget-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    array-length v0, v0

    if-nez v0, :cond_3

    .line 513
    :cond_0
    const/4 v0, 0x1

    .line 514
    .local v0, "autoSizeValuesLength":I
    iget v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    int-to-float v3, v3

    .line 515
    .local v3, "currentSize":F
    :goto_0
    iget v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    add-float/2addr v4, v3

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    iget v5, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    .line 516
    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v5

    if-gt v4, v5, :cond_1

    .line 517
    add-int/lit8 v0, v0, 0x1

    .line 518
    iget v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    add-float/2addr v3, v4

    goto :goto_0

    .line 520
    :cond_1
    new-array v4, v0, [I

    .line 521
    .local v4, "autoSizeTextSizesInPx":[I
    iget v5, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    .line 522
    .local v5, "sizeToAdd":F
    nop

    .line 522
    .local v1, "i":I
    :goto_1
    if-ge v1, v0, :cond_2

    .line 523
    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v6

    aput v6, v4, v1

    .line 524
    iget v6, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    add-float/2addr v5, v6

    .line 522
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 526
    .end local v1    # "i":I
    :cond_2
    invoke-direct {p0, v4}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->cleanupAutoSizePresetSizes([I)[I

    move-result-object v1

    iput-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    .line 529
    .end local v0    # "autoSizeValuesLength":I
    .end local v3    # "currentSize":F
    .end local v4    # "autoSizeTextSizesInPx":[I
    .end local v5    # "sizeToAdd":F
    :cond_3
    iput-boolean v2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    goto :goto_2

    .line 531
    :cond_4
    iput-boolean v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    .line 534
    :goto_2
    iget-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    return v0
.end method

.method private setupAutoSizeUniformPresetSizes(Landroid/content/res/TypedArray;)V
    .locals 4
    .param p1, "textSizes"    # Landroid/content/res/TypedArray;

    .line 418
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->length()I

    move-result v0

    .line 419
    .local v0, "textSizesLength":I
    new-array v1, v0, [I

    .line 421
    .local v1, "parsedSizes":[I
    if-lez v0, :cond_1

    .line 422
    const/4 v2, 0x0

    .line 422
    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_0

    .line 423
    const/4 v3, -0x1

    invoke-virtual {p1, v2, v3}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v3

    aput v3, v1, v2

    .line 422
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 425
    .end local v2    # "i":I
    :cond_0
    invoke-direct {p0, v1}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->cleanupAutoSizePresetSizes([I)[I

    move-result-object v2

    iput-object v2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    .line 426
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeUniformPresetSizesConfiguration()Z

    .line 428
    :cond_1
    return-void
.end method

.method private setupAutoSizeUniformPresetSizesConfiguration()Z
    .locals 4

    .line 431
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    array-length v0, v0

    .line 432
    .local v0, "sizesLength":I
    const/4 v1, 0x0

    const/4 v2, 0x1

    if-lez v0, :cond_0

    move v3, v2

    goto :goto_0

    :cond_0
    move v3, v1

    :goto_0
    iput-boolean v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    .line 433
    iget-boolean v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    if-eqz v3, :cond_1

    .line 434
    iput v2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 435
    iget-object v2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    aget v1, v2, v1

    int-to-float v1, v1

    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    .line 436
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    add-int/lit8 v2, v0, -0x1

    aget v1, v1, v2

    int-to-float v1, v1

    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    .line 437
    const/high16 v1, -0x40800000    # -1.0f

    iput v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    .line 439
    :cond_1
    iget-boolean v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    return v1
.end method

.method private suggestedSizeFitsInSpace(ILandroid/graphics/RectF;)Z
    .locals 8
    .param p1, "suggestedSizeInPx"    # I
    .param p2, "availableSpace"    # Landroid/graphics/RectF;

    .line 663
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    .line 664
    .local v0, "text":Ljava/lang/CharSequence;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v2, -0x1

    const/16 v3, 0x10

    if-lt v1, v3, :cond_0

    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getMaxLines()I

    move-result v1

    goto :goto_0

    :cond_0
    move v1, v2

    .line 665
    .local v1, "maxLines":I
    :goto_0
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    if-nez v3, :cond_1

    .line 666
    new-instance v3, Landroid/text/TextPaint;

    invoke-direct {v3}, Landroid/text/TextPaint;-><init>()V

    iput-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    goto :goto_1

    .line 668
    :cond_1
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    invoke-virtual {v3}, Landroid/text/TextPaint;->reset()V

    .line 670
    :goto_1
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v4}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/text/TextPaint;->set(Landroid/text/TextPaint;)V

    .line 671
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTempTextPaint:Landroid/text/TextPaint;

    int-to-float v4, p1

    invoke-virtual {v3, v4}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 674
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v4, "getLayoutAlignment"

    sget-object v5, Landroid/text/Layout$Alignment;->ALIGN_NORMAL:Landroid/text/Layout$Alignment;

    invoke-direct {p0, v3, v4, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/text/Layout$Alignment;

    .line 676
    .local v3, "alignment":Landroid/text/Layout$Alignment;
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x17

    if-lt v4, v5, :cond_2

    iget v4, p2, Landroid/graphics/RectF;->right:F

    .line 678
    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 677
    invoke-direct {p0, v0, v3, v4, v1}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->createStaticLayoutForMeasuring(Ljava/lang/CharSequence;Landroid/text/Layout$Alignment;II)Landroid/text/StaticLayout;

    move-result-object v4

    goto :goto_2

    :cond_2
    iget v4, p2, Landroid/graphics/RectF;->right:F

    .line 680
    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 679
    invoke-direct {p0, v0, v3, v4}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->createStaticLayoutForMeasuringPre23(Ljava/lang/CharSequence;Landroid/text/Layout$Alignment;I)Landroid/text/StaticLayout;

    move-result-object v4

    .line 682
    .local v4, "layout":Landroid/text/StaticLayout;
    :goto_2
    const/4 v5, 0x0

    const/4 v6, 0x1

    if-eq v1, v2, :cond_4

    invoke-virtual {v4}, Landroid/text/StaticLayout;->getLineCount()I

    move-result v2

    if-gt v2, v1, :cond_3

    .line 683
    invoke-virtual {v4}, Landroid/text/StaticLayout;->getLineCount()I

    move-result v2

    sub-int/2addr v2, v6

    invoke-virtual {v4, v2}, Landroid/text/StaticLayout;->getLineEnd(I)I

    move-result v2

    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    move-result v7

    if-eq v2, v7, :cond_4

    .line 684
    :cond_3
    return v5

    .line 688
    :cond_4
    invoke-virtual {v4}, Landroid/text/StaticLayout;->getHeight()I

    move-result v2

    int-to-float v2, v2

    iget v7, p2, Landroid/graphics/RectF;->bottom:F

    cmpl-float v2, v2, v7

    if-lez v2, :cond_5

    .line 689
    return v5

    .line 692
    :cond_5
    return v6
.end method

.method private supportsAutoSizeText()Z
    .locals 1

    .line 810
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    instance-of v0, v0, Landroid/support/v7/widget/AppCompatEditText;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private validateAndSetAutoSizeTextTypeUniformConfiguration(FFF)V
    .locals 3
    .param p1, "autoSizeMinTextSizeInPx"    # F
    .param p2, "autoSizeMaxTextSizeInPx"    # F
    .param p3, "autoSizeStepGranularityInPx"    # F
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 482
    const/4 v0, 0x0

    cmpg-float v1, p1, v0

    if-gtz v1, :cond_0

    .line 483
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Minimum auto-size text size ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, "px) is less or equal to (0px)"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 487
    :cond_0
    cmpg-float v1, p2, p1

    if-gtz v1, :cond_1

    .line 488
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Maximum auto-size text size ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, "px) is less or equal to minimum auto-size "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "text size ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, "px)"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 493
    :cond_1
    cmpg-float v0, p3, v0

    if-gtz v0, :cond_2

    .line 494
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "The auto-size step granularity ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, "px) is less or equal to (0px)"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 499
    :cond_2
    const/4 v0, 0x1

    iput v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 500
    iput p1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    .line 501
    iput p2, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    .line 502
    iput p3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    .line 503
    const/4 v0, 0x0

    iput-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    .line 504
    return-void
.end method


# virtual methods
.method autoSizeText()V
    .locals 7
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 544
    invoke-virtual {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->isAutoSizeEnabled()Z

    move-result v0

    if-nez v0, :cond_0

    .line 545
    return-void

    .line 548
    :cond_0
    iget-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    if-eqz v0, :cond_7

    .line 549
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getMeasuredHeight()I

    move-result v0

    if-lez v0, :cond_6

    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getMeasuredWidth()I

    move-result v0

    if-gtz v0, :cond_1

    goto :goto_2

    .line 553
    :cond_1
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    const-string v1, "getHorizontallyScrolling"

    .line 554
    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    .line 553
    invoke-direct {p0, v0, v1, v3}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->invokeAndReturnWithDefault(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    .line 555
    .local v0, "horizontallyScrolling":Z
    if-eqz v0, :cond_2

    const/high16 v1, 0x100000

    goto :goto_0

    :cond_2
    iget-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 557
    invoke-virtual {v1}, Landroid/widget/TextView;->getMeasuredWidth()I

    move-result v1

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getTotalPaddingLeft()I

    move-result v3

    sub-int/2addr v1, v3

    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 558
    invoke-virtual {v3}, Landroid/widget/TextView;->getTotalPaddingRight()I

    move-result v3

    sub-int/2addr v1, v3

    .line 559
    .local v1, "availableWidth":I
    :goto_0
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getHeight()I

    move-result v3

    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v4}, Landroid/widget/TextView;->getCompoundPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    .line 560
    invoke-virtual {v4}, Landroid/widget/TextView;->getCompoundPaddingTop()I

    move-result v4

    sub-int/2addr v3, v4

    .line 562
    .local v3, "availableHeight":I
    if-lez v1, :cond_5

    if-gtz v3, :cond_3

    goto :goto_1

    .line 566
    :cond_3
    sget-object v4, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    monitor-enter v4

    .line 567
    :try_start_0
    sget-object v5, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    invoke-virtual {v5}, Landroid/graphics/RectF;->setEmpty()V

    .line 568
    sget-object v5, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    int-to-float v6, v1

    iput v6, v5, Landroid/graphics/RectF;->right:F

    .line 569
    sget-object v5, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    int-to-float v6, v3

    iput v6, v5, Landroid/graphics/RectF;->bottom:F

    .line 570
    sget-object v5, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->TEMP_RECTF:Landroid/graphics/RectF;

    invoke-direct {p0, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->findLargestTextSizeWhichFits(Landroid/graphics/RectF;)I

    move-result v5

    int-to-float v5, v5

    .line 571
    .local v5, "optimalTextSize":F
    iget-object v6, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mTextView:Landroid/widget/TextView;

    invoke-virtual {v6}, Landroid/widget/TextView;->getTextSize()F

    move-result v6

    cmpl-float v6, v5, v6

    if-eqz v6, :cond_4

    .line 572
    invoke-virtual {p0, v2, v5}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setTextSizeInternal(IF)V

    .line 574
    .end local v5    # "optimalTextSize":F
    :cond_4
    monitor-exit v4

    goto :goto_3

    :catchall_0
    move-exception v2

    monitor-exit v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v2

    .line 563
    :cond_5
    :goto_1
    return-void

    .line 550
    .end local v0    # "horizontallyScrolling":Z
    .end local v1    # "availableWidth":I
    .end local v3    # "availableHeight":I
    :cond_6
    :goto_2
    return-void

    .line 578
    :cond_7
    :goto_3
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mNeedsAutoSizeText:Z

    .line 579
    return-void
.end method

.method getAutoSizeMaxTextSize()I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 401
    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMaxTextSizeInPx:F

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    return v0
.end method

.method getAutoSizeMinTextSize()I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 385
    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeMinTextSizeInPx:F

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    return v0
.end method

.method getAutoSizeStepGranularity()I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 369
    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeStepGranularityInPx:F

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    return v0
.end method

.method getAutoSizeTextAvailableSizes()[I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 414
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    return-object v0
.end method

.method getAutoSizeTextType()I
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 355
    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    return v0
.end method

.method isAutoSizeEnabled()Z
    .locals 1
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 801
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v0

    if-eqz v0, :cond_0

    iget v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method loadFromAttributes(Landroid/util/AttributeSet;I)V
    .locals 8
    .param p1, "attrs"    # Landroid/util/AttributeSet;
    .param p2, "defStyleAttr"    # I

    .line 102
    const/high16 v0, -0x40800000    # -1.0f

    .line 103
    .local v0, "autoSizeMinTextSizeInPx":F
    const/high16 v1, -0x40800000    # -1.0f

    .line 104
    .local v1, "autoSizeMaxTextSizeInPx":F
    const/high16 v2, -0x40800000    # -1.0f

    .line 106
    .local v2, "autoSizeStepGranularityInPx":F
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    sget-object v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView:[I

    const/4 v5, 0x0

    invoke-virtual {v3, p1, v4, p2, v5}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[III)Landroid/content/res/TypedArray;

    move-result-object v3

    .line 108
    .local v3, "a":Landroid/content/res/TypedArray;
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeTextType:I

    invoke-virtual {v3, v4}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 109
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeTextType:I

    invoke-virtual {v3, v4, v5}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result v4

    iput v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 112
    :cond_0
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeStepGranularity:I

    invoke-virtual {v3, v4}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v4

    const/high16 v6, -0x40800000    # -1.0f

    if-eqz v4, :cond_1

    .line 113
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeStepGranularity:I

    invoke-virtual {v3, v4, v6}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result v2

    .line 117
    :cond_1
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeMinTextSize:I

    invoke-virtual {v3, v4}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 118
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeMinTextSize:I

    invoke-virtual {v3, v4, v6}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result v0

    .line 122
    :cond_2
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeMaxTextSize:I

    invoke-virtual {v3, v4}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 123
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizeMaxTextSize:I

    invoke-virtual {v3, v4, v6}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result v1

    .line 127
    :cond_3
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizePresetSizes:I

    invoke-virtual {v3, v4}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 128
    sget v4, Landroid/support/v7/appcompat/R$styleable;->AppCompatTextView_autoSizePresetSizes:I

    invoke-virtual {v3, v4, v5}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v4

    .line 130
    .local v4, "autoSizeStepSizeArrayResId":I
    if-lez v4, :cond_4

    .line 131
    invoke-virtual {v3}, Landroid/content/res/TypedArray;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    .line 132
    invoke-virtual {v7, v4}, Landroid/content/res/Resources;->obtainTypedArray(I)Landroid/content/res/TypedArray;

    move-result-object v7

    .line 133
    .local v7, "autoSizePreDefTextSizes":Landroid/content/res/TypedArray;
    invoke-direct {p0, v7}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeUniformPresetSizes(Landroid/content/res/TypedArray;)V

    .line 134
    invoke-virtual {v7}, Landroid/content/res/TypedArray;->recycle()V

    .line 137
    .end local v4    # "autoSizeStepSizeArrayResId":I
    .end local v7    # "autoSizePreDefTextSizes":Landroid/content/res/TypedArray;
    :cond_4
    invoke-virtual {v3}, Landroid/content/res/TypedArray;->recycle()V

    .line 139
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v4

    if-eqz v4, :cond_9

    .line 140
    iget v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    const/4 v5, 0x1

    if-ne v4, v5, :cond_a

    .line 144
    iget-boolean v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    if-nez v4, :cond_8

    .line 145
    iget-object v4, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    .line 146
    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    .line 148
    .local v4, "displayMetrics":Landroid/util/DisplayMetrics;
    cmpl-float v5, v0, v6

    const/4 v7, 0x2

    if-nez v5, :cond_5

    .line 149
    const/high16 v5, 0x41400000    # 12.0f

    invoke-static {v7, v5, v4}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v0

    .line 155
    :cond_5
    cmpl-float v5, v1, v6

    if-nez v5, :cond_6

    .line 156
    const/high16 v5, 0x42e00000    # 112.0f

    invoke-static {v7, v5, v4}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v1

    .line 162
    :cond_6
    cmpl-float v5, v2, v6

    if-nez v5, :cond_7

    .line 164
    const/high16 v2, 0x3f800000    # 1.0f

    .line 167
    :cond_7
    invoke-direct {p0, v0, v1, v2}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->validateAndSetAutoSizeTextTypeUniformConfiguration(FFF)V

    .line 172
    .end local v4    # "displayMetrics":Landroid/util/DisplayMetrics;
    :cond_8
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeText()Z

    goto :goto_0

    .line 175
    :cond_9
    iput v5, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextType:I

    .line 177
    :cond_a
    :goto_0
    return-void
.end method

.method setAutoSizeTextTypeUniformWithConfiguration(IIII)V
    .locals 5
    .param p1, "autoSizeMinTextSize"    # I
    .param p2, "autoSizeMaxTextSize"    # I
    .param p3, "autoSizeStepGranularity"    # I
    .param p4, "unit"    # I
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 262
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 263
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 264
    .local v0, "displayMetrics":Landroid/util/DisplayMetrics;
    int-to-float v1, p1

    invoke-static {p4, v1, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v1

    .line 266
    .local v1, "autoSizeMinTextSizeInPx":F
    int-to-float v2, p2

    invoke-static {p4, v2, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v2

    .line 268
    .local v2, "autoSizeMaxTextSizeInPx":F
    int-to-float v3, p3

    invoke-static {p4, v3, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v3

    .line 271
    .local v3, "autoSizeStepGranularityInPx":F
    invoke-direct {p0, v1, v2, v3}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->validateAndSetAutoSizeTextTypeUniformConfiguration(FFF)V

    .line 274
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeText()Z

    move-result v4

    if-eqz v4, :cond_0

    .line 275
    invoke-virtual {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->autoSizeText()V

    .line 278
    .end local v0    # "displayMetrics":Landroid/util/DisplayMetrics;
    .end local v1    # "autoSizeMinTextSizeInPx":F
    .end local v2    # "autoSizeMaxTextSizeInPx":F
    .end local v3    # "autoSizeStepGranularityInPx":F
    :cond_0
    return-void
.end method

.method setAutoSizeTextTypeUniformWithPresetSizes([II)V
    .locals 5
    .param p1, "presetSizes"    # [I
        .annotation build Landroid/support/annotation/NonNull;
        .end annotation
    .end param
    .param p2, "unit"    # I
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 305
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 306
    array-length v0, p1

    .line 307
    .local v0, "presetSizesLength":I
    const/4 v1, 0x0

    if-lez v0, :cond_3

    .line 308
    new-array v2, v0, [I

    .line 310
    .local v2, "presetSizesInPx":[I
    if-nez p2, :cond_0

    .line 311
    invoke-static {p1, v0}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v2

    goto :goto_1

    .line 313
    :cond_0
    iget-object v3, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    .line 314
    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    .line 316
    .local v3, "displayMetrics":Landroid/util/DisplayMetrics;
    nop

    .line 316
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 317
    aget v4, p1, v1

    int-to-float v4, v4

    invoke-static {p2, v4, v3}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v4

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    aput v4, v2, v1

    .line 316
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 322
    .end local v1    # "i":I
    .end local v3    # "displayMetrics":Landroid/util/DisplayMetrics;
    :cond_1
    :goto_1
    invoke-direct {p0, v2}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->cleanupAutoSizePresetSizes([I)[I

    move-result-object v1

    iput-object v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mAutoSizeTextSizesInPx:[I

    .line 323
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeUniformPresetSizesConfiguration()Z

    move-result v1

    if-nez v1, :cond_2

    .line 324
    new-instance v1, Ljava/lang/IllegalArgumentException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "None of the preset sizes is valid: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 325
    invoke-static {p1}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v1, v3}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 327
    .end local v2    # "presetSizesInPx":[I
    :cond_2
    goto :goto_2

    .line 328
    :cond_3
    iput-boolean v1, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mHasPresetAutoSizeValues:Z

    .line 331
    :goto_2
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeText()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 332
    invoke-virtual {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->autoSizeText()V

    .line 335
    .end local v0    # "presetSizesLength":I
    :cond_4
    return-void
.end method

.method setAutoSizeTextTypeWithDefaults(I)V
    .locals 4
    .param p1, "autoSizeTextType"    # I
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 195
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->supportsAutoSizeText()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 196
    packed-switch p1, :pswitch_data_0

    .line 221
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unknown auto-size text type: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 201
    :pswitch_0
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    .line 202
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 203
    .local v0, "displayMetrics":Landroid/util/DisplayMetrics;
    const/high16 v1, 0x41400000    # 12.0f

    const/4 v2, 0x2

    invoke-static {v2, v1, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v1

    .line 207
    .local v1, "autoSizeMinTextSizeInPx":F
    const/high16 v3, 0x42e00000    # 112.0f

    invoke-static {v2, v3, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v2

    .line 212
    .local v2, "autoSizeMaxTextSizeInPx":F
    const/high16 v3, 0x3f800000    # 1.0f

    invoke-direct {p0, v1, v2, v3}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->validateAndSetAutoSizeTextTypeUniformConfiguration(FFF)V

    .line 216
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setupAutoSizeText()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 217
    invoke-virtual {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->autoSizeText()V

    goto :goto_0

    .line 198
    .end local v0    # "displayMetrics":Landroid/util/DisplayMetrics;
    .end local v1    # "autoSizeMinTextSizeInPx":F
    .end local v2    # "autoSizeMaxTextSizeInPx":F
    :pswitch_1
    invoke-direct {p0}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->clearAutoSizeConfiguration()V

    .line 199
    nop

    .line 225
    :cond_0
    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method setTextSizeInternal(IF)V
    .locals 2
    .param p1, "unit"    # I
    .param p2, "size"    # F
    .annotation build Landroid/support/annotation/RestrictTo;
        value = {
            .enum Landroid/support/annotation/RestrictTo$Scope;->LIBRARY_GROUP:Landroid/support/annotation/RestrictTo$Scope;
        }
    .end annotation

    .line 593
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    if-nez v0, :cond_0

    .line 594
    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    move-result-object v0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->mContext:Landroid/content/Context;

    .line 595
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 597
    .local v0, "res":Landroid/content/res/Resources;
    :goto_0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    invoke-static {p1, p2, v1}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v1

    invoke-direct {p0, v1}, Landroid/support/v7/widget/AppCompatTextViewAutoSizeHelper;->setRawTextSize(F)V

    .line 598
    return-void
.end method
