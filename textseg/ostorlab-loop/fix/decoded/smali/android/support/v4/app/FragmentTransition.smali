.class Landroid/support/v4/app/FragmentTransition;
.super Ljava/lang/Object;
.source "FragmentTransition.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    }
.end annotation


# static fields
.field private static final INVERSE_OPS:[I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 43
    const/16 v0, 0xa

    new-array v0, v0, [I

    fill-array-data v0, :array_0

    sput-object v0, Landroid/support/v4/app/FragmentTransition;->INVERSE_OPS:[I

    return-void

    :array_0
    .array-data 4
        0x0
        0x3
        0x0
        0x1
        0x5
        0x4
        0x7
        0x6
        0x9
        0x8
    .end array-data
.end method

.method constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1145
    return-void
.end method

.method static synthetic access$000(Ljava/util/ArrayList;I)V
    .locals 0
    .param p0, "x0"    # Ljava/util/ArrayList;
    .param p1, "x1"    # I

    .line 38
    invoke-static {p0, p1}, Landroid/support/v4/app/FragmentTransition;->setViewVisibility(Ljava/util/ArrayList;I)V

    return-void
.end method

.method static synthetic access$100(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;
    .locals 1
    .param p0, "x0"    # Ljava/lang/Object;
    .param p1, "x1"    # Landroid/support/v4/app/Fragment;
    .param p2, "x2"    # Ljava/util/ArrayList;
    .param p3, "x3"    # Landroid/view/View;

    .line 38
    invoke-static {p0, p1, p2, p3}, Landroid/support/v4/app/FragmentTransition;->configureEnteringExitingViews(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$200(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Z)V
    .locals 0
    .param p0, "x0"    # Landroid/support/v4/app/Fragment;
    .param p1, "x1"    # Landroid/support/v4/app/Fragment;
    .param p2, "x2"    # Z
    .param p3, "x3"    # Landroid/support/v4/util/ArrayMap;
    .param p4, "x4"    # Z

    .line 38
    invoke-static {p0, p1, p2, p3, p4}, Landroid/support/v4/app/FragmentTransition;->callSharedElementStartEnd(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Z)V

    return-void
.end method

.method static synthetic access$300(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;
    .locals 1
    .param p0, "x0"    # Landroid/support/v4/util/ArrayMap;
    .param p1, "x1"    # Ljava/lang/Object;
    .param p2, "x2"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    .line 38
    invoke-static {p0, p1, p2}, Landroid/support/v4/app/FragmentTransition;->captureInSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$400(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/lang/Object;Z)Landroid/view/View;
    .locals 1
    .param p0, "x0"    # Landroid/support/v4/util/ArrayMap;
    .param p1, "x1"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p2, "x2"    # Ljava/lang/Object;
    .param p3, "x3"    # Z

    .line 38
    invoke-static {p0, p1, p2, p3}, Landroid/support/v4/app/FragmentTransition;->getInEpicenterView(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/lang/Object;Z)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method private static addSharedElementsWithMatchingNames(Ljava/util/ArrayList;Landroid/support/v4/util/ArrayMap;Ljava/util/Collection;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/Collection<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 566
    .local p0, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p1, "sharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .local p2, "nameOverridesSet":Ljava/util/Collection;, "Ljava/util/Collection<Ljava/lang/String;>;"
    invoke-virtual {p1}, Landroid/support/v4/util/ArrayMap;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .line 566
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_1

    .line 567
    invoke-virtual {p1, v0}, Landroid/support/v4/util/ArrayMap;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 568
    .local v1, "view":Landroid/view/View;
    invoke-static {v1}, Landroid/support/v4/view/ViewCompat;->getTransitionName(Landroid/view/View;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {p2, v2}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 569
    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 566
    .end local v1    # "view":Landroid/view/View;
    :cond_0
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 572
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method private static addToFirstInLastOut(Landroid/support/v4/app/BackStackRecord;Landroid/support/v4/app/BackStackRecord$Op;Landroid/util/SparseArray;ZZ)V
    .locals 23
    .param p0, "transaction"    # Landroid/support/v4/app/BackStackRecord;
    .param p1, "op"    # Landroid/support/v4/app/BackStackRecord$Op;
    .param p3, "isPop"    # Z
    .param p4, "isReorderedTransaction"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/BackStackRecord;",
            "Landroid/support/v4/app/BackStackRecord$Op;",
            "Landroid/util/SparseArray<",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ">;ZZ)V"
        }
    .end annotation

    .line 1037
    .local p2, "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move/from16 v3, p3

    .line 1037
    iget-object v10, v1, Landroid/support/v4/app/BackStackRecord$Op;->fragment:Landroid/support/v4/app/Fragment;

    .line 1038
    .local v10, "fragment":Landroid/support/v4/app/Fragment;
    if-nez v10, :cond_0

    .line 1039
    return-void

    .line 1041
    :cond_0
    iget v11, v10, Landroid/support/v4/app/Fragment;->mContainerId:I

    .line 1042
    .local v11, "containerId":I
    if-nez v11, :cond_1

    .line 1043
    return-void

    .line 1045
    :cond_1
    if-eqz v3, :cond_2

    sget-object v4, Landroid/support/v4/app/FragmentTransition;->INVERSE_OPS:[I

    iget v5, v1, Landroid/support/v4/app/BackStackRecord$Op;->cmd:I

    aget v4, v4, v5

    goto :goto_0

    :cond_2
    iget v4, v1, Landroid/support/v4/app/BackStackRecord$Op;->cmd:I

    :goto_0
    move v12, v4

    .line 1046
    .local v12, "command":I
    const/4 v4, 0x0

    .line 1047
    .local v4, "setLastIn":Z
    const/4 v5, 0x0

    .line 1048
    .local v5, "wasRemoved":Z
    const/4 v6, 0x0

    .line 1049
    .local v6, "setFirstOut":Z
    const/4 v7, 0x0

    .line 1050
    .local v7, "wasAdded":Z
    const/4 v8, 0x0

    const/4 v9, 0x1

    if-eq v12, v9, :cond_b

    packed-switch v12, :pswitch_data_0

    .line 1088
    .end local v4    # "setLastIn":Z
    .end local v5    # "wasRemoved":Z
    .end local v6    # "setFirstOut":Z
    .end local v7    # "wasAdded":Z
    .local v13, "setLastIn":Z
    .local v14, "wasAdded":Z
    .local v15, "wasRemoved":Z
    .local v16, "setFirstOut":Z
    :goto_1
    move v13, v4

    move v15, v5

    move/from16 v16, v6

    move v14, v7

    goto/16 :goto_6

    .line 1052
    .end local v13    # "setLastIn":Z
    .end local v14    # "wasAdded":Z
    .end local v15    # "wasRemoved":Z
    .end local v16    # "setFirstOut":Z
    .restart local v4    # "setLastIn":Z
    .restart local v5    # "wasRemoved":Z
    .restart local v6    # "setFirstOut":Z
    .restart local v7    # "wasAdded":Z
    :pswitch_0
    if-eqz p4, :cond_4

    .line 1053
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHiddenChanged:Z

    if-eqz v13, :cond_3

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-nez v13, :cond_3

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-eqz v13, :cond_3

    move v8, v9

    nop

    :cond_3
    move v4, v8

    goto :goto_2

    .line 1055
    :cond_4
    iget-boolean v4, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    .line 1057
    :goto_2
    const/4 v7, 0x1

    .line 1058
    goto :goto_1

    .line 1069
    :pswitch_1
    if-eqz p4, :cond_6

    .line 1070
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHiddenChanged:Z

    if-eqz v13, :cond_5

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-eqz v13, :cond_5

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-eqz v13, :cond_5

    move v8, v9

    nop

    :cond_5
    move v6, v8

    goto :goto_3

    .line 1072
    :cond_6
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-eqz v13, :cond_7

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-nez v13, :cond_7

    move v8, v9

    nop

    :cond_7
    move v6, v8

    .line 1074
    :goto_3
    const/4 v5, 0x1

    .line 1075
    goto :goto_1

    .line 1078
    :pswitch_2
    if-eqz p4, :cond_9

    .line 1079
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-nez v13, :cond_8

    iget-object v13, v10, Landroid/support/v4/app/Fragment;->mView:Landroid/view/View;

    if-eqz v13, :cond_8

    iget-object v13, v10, Landroid/support/v4/app/Fragment;->mView:Landroid/view/View;

    .line 1080
    invoke-virtual {v13}, Landroid/view/View;->getVisibility()I

    move-result v13

    if-nez v13, :cond_8

    iget v13, v10, Landroid/support/v4/app/Fragment;->mPostponedAlpha:F

    const/4 v14, 0x0

    cmpl-float v13, v13, v14

    if-ltz v13, :cond_8

    move v8, v9

    nop

    :cond_8
    move v6, v8

    goto :goto_4

    .line 1083
    :cond_9
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-eqz v13, :cond_a

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-nez v13, :cond_a

    move v8, v9

    nop

    :cond_a
    move v6, v8

    .line 1085
    :goto_4
    const/4 v5, 0x1

    goto :goto_1

    .line 1061
    :cond_b
    :pswitch_3
    if-eqz p4, :cond_c

    .line 1062
    iget-boolean v4, v10, Landroid/support/v4/app/Fragment;->mIsNewlyAdded:Z

    goto :goto_5

    .line 1064
    :cond_c
    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-nez v13, :cond_d

    iget-boolean v13, v10, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-nez v13, :cond_d

    move v8, v9

    nop

    :cond_d
    move v4, v8

    .line 1066
    :goto_5
    const/4 v7, 0x1

    .line 1067
    goto :goto_1

    .line 1088
    .end local v4    # "setLastIn":Z
    .end local v5    # "wasRemoved":Z
    .end local v6    # "setFirstOut":Z
    .end local v7    # "wasAdded":Z
    .restart local v13    # "setLastIn":Z
    .restart local v14    # "wasAdded":Z
    .restart local v15    # "wasRemoved":Z
    .restart local v16    # "setFirstOut":Z
    :goto_6
    invoke-virtual {v2, v11}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    .line 1089
    .local v4, "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    if-eqz v13, :cond_e

    .line 1090
    nop

    .line 1091
    invoke-static {v4, v2, v11}, Landroid/support/v4/app/FragmentTransition;->ensureContainer(Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/util/SparseArray;I)Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    move-result-object v4

    .line 1092
    iput-object v10, v4, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 1093
    iput-boolean v3, v4, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    .line 1094
    iput-object v0, v4, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 1096
    .end local v4    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .local v8, "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :cond_e
    move-object v8, v4

    const/4 v7, 0x0

    if-nez p4, :cond_10

    if-eqz v14, :cond_10

    .line 1097
    if-eqz v8, :cond_f

    iget-object v4, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    if-ne v4, v10, :cond_f

    .line 1098
    iput-object v7, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 1105
    :cond_f
    iget-object v6, v0, Landroid/support/v4/app/BackStackRecord;->mManager:Landroid/support/v4/app/FragmentManagerImpl;

    .line 1106
    .local v6, "manager":Landroid/support/v4/app/FragmentManagerImpl;
    iget v4, v10, Landroid/support/v4/app/Fragment;->mState:I

    if-ge v4, v9, :cond_10

    iget v4, v6, Landroid/support/v4/app/FragmentManagerImpl;->mCurState:I

    if-lt v4, v9, :cond_10

    iget-boolean v4, v0, Landroid/support/v4/app/BackStackRecord;->mReorderingAllowed:Z

    if-nez v4, :cond_10

    .line 1108
    invoke-virtual {v6, v10}, Landroid/support/v4/app/FragmentManagerImpl;->makeActive(Landroid/support/v4/app/Fragment;)V

    .line 1109
    const/4 v9, 0x1

    const/16 v17, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    move-object v4, v6

    move-object v5, v10

    move-object/from16 v20, v6

    move v6, v9

    .line 1109
    .end local v6    # "manager":Landroid/support/v4/app/FragmentManagerImpl;
    .local v20, "manager":Landroid/support/v4/app/FragmentManagerImpl;
    move-object v9, v7

    move/from16 v7, v17

    move-object/from16 v21, v8

    move/from16 v8, v18

    .line 1109
    .end local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .local v21, "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    move-object v1, v9

    move/from16 v9, v19

    invoke-virtual/range {v4 .. v9}, Landroid/support/v4/app/FragmentManagerImpl;->moveToState(Landroid/support/v4/app/Fragment;IIIZ)V

    .line 1109
    .end local v20    # "manager":Landroid/support/v4/app/FragmentManagerImpl;
    goto :goto_7

    .line 1112
    .end local v21    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :cond_10
    move-object v1, v7

    move-object/from16 v21, v8

    .line 1112
    .end local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v21    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :goto_7
    if-eqz v16, :cond_12

    move-object/from16 v4, v21

    if-eqz v4, :cond_11

    .line 1112
    .end local v21    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v4    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    iget-object v5, v4, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    if-nez v5, :cond_13

    .line 1113
    :cond_11
    nop

    .line 1114
    invoke-static {v4, v2, v11}, Landroid/support/v4/app/FragmentTransition;->ensureContainer(Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/util/SparseArray;I)Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    move-result-object v8

    .line 1115
    .end local v4    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    iput-object v10, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 1116
    iput-boolean v3, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    .line 1117
    iput-object v0, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutTransaction:Landroid/support/v4/app/BackStackRecord;

    goto :goto_8

    .line 1120
    .end local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v21    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :cond_12
    move-object/from16 v4, v21

    .line 1120
    .end local v21    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v4    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :cond_13
    move-object v8, v4

    .line 1120
    .end local v4    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .restart local v8    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :goto_8
    if-nez p4, :cond_14

    if-eqz v15, :cond_14

    if-eqz v8, :cond_14

    iget-object v4, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    if-ne v4, v10, :cond_14

    .line 1122
    iput-object v1, v8, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 1124
    :cond_14
    return-void

    :pswitch_data_0
    .packed-switch 0x3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_2
        :pswitch_3
    .end packed-switch
.end method

.method public static calculateFragments(Landroid/support/v4/app/BackStackRecord;Landroid/util/SparseArray;Z)V
    .locals 4
    .param p0, "transaction"    # Landroid/support/v4/app/BackStackRecord;
    .param p2, "isReordered"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/BackStackRecord;",
            "Landroid/util/SparseArray<",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ">;Z)V"
        }
    .end annotation

    .line 993
    .local p1, "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    iget-object v0, p0, Landroid/support/v4/app/BackStackRecord;->mOps:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 994
    .local v0, "numOps":I
    const/4 v1, 0x0

    move v2, v1

    .line 994
    .local v2, "opNum":I
    :goto_0
    if-ge v2, v0, :cond_0

    .line 995
    iget-object v3, p0, Landroid/support/v4/app/BackStackRecord;->mOps:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/support/v4/app/BackStackRecord$Op;

    .line 996
    .local v3, "op":Landroid/support/v4/app/BackStackRecord$Op;
    invoke-static {p0, v3, p1, v1, p2}, Landroid/support/v4/app/FragmentTransition;->addToFirstInLastOut(Landroid/support/v4/app/BackStackRecord;Landroid/support/v4/app/BackStackRecord$Op;Landroid/util/SparseArray;ZZ)V

    .line 994
    .end local v3    # "op":Landroid/support/v4/app/BackStackRecord$Op;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 998
    .end local v2    # "opNum":I
    :cond_0
    return-void
.end method

.method private static calculateNameOverrides(ILjava/util/ArrayList;Ljava/util/ArrayList;II)Landroid/support/v4/util/ArrayMap;
    .locals 11
    .param p0, "containerId"    # I
    .param p3, "startIndex"    # I
    .param p4, "endIndex"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/ArrayList<",
            "Landroid/support/v4/app/BackStackRecord;",
            ">;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Boolean;",
            ">;II)",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 144
    .local p1, "records":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/v4/app/BackStackRecord;>;"
    .local p2, "isRecordPop":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/Boolean;>;"
    new-instance v0, Landroid/support/v4/util/ArrayMap;

    invoke-direct {v0}, Landroid/support/v4/util/ArrayMap;-><init>()V

    .line 145
    .local v0, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    add-int/lit8 v1, p4, -0x1

    .line 145
    .local v1, "recordNum":I
    :goto_0
    if-lt v1, p3, :cond_4

    .line 146
    invoke-virtual {p1, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/app/BackStackRecord;

    .line 147
    .local v2, "record":Landroid/support/v4/app/BackStackRecord;
    invoke-virtual {v2, p0}, Landroid/support/v4/app/BackStackRecord;->interactsWith(I)Z

    move-result v3

    if-nez v3, :cond_0

    .line 148
    goto :goto_4

    .line 150
    :cond_0
    invoke-virtual {p2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Boolean;

    invoke-virtual {v3}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v3

    .line 151
    .local v3, "isPop":Z
    iget-object v4, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    if-eqz v4, :cond_3

    .line 152
    iget-object v4, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    .line 155
    .local v4, "numSharedElements":I
    if-eqz v3, :cond_1

    .line 156
    iget-object v5, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 157
    .local v5, "targets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    iget-object v6, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 157
    .local v6, "sources":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    goto :goto_1

    .line 159
    .end local v5    # "targets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    .end local v6    # "sources":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_1
    iget-object v6, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 160
    .restart local v6    # "sources":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    iget-object v5, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 162
    .restart local v5    # "targets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :goto_1
    const/4 v7, 0x0

    .line 162
    .local v7, "i":I
    :goto_2
    if-ge v7, v4, :cond_3

    .line 163
    invoke-virtual {v6, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    .line 164
    .local v8, "sourceName":Ljava/lang/String;
    invoke-virtual {v5, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/String;

    .line 165
    .local v9, "targetName":Ljava/lang/String;
    invoke-virtual {v0, v9}, Landroid/support/v4/util/ArrayMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/String;

    .line 166
    .local v10, "previousTarget":Ljava/lang/String;
    if-eqz v10, :cond_2

    .line 167
    invoke-virtual {v0, v8, v10}, Landroid/support/v4/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_3

    .line 169
    :cond_2
    invoke-virtual {v0, v8, v9}, Landroid/support/v4/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 162
    .end local v8    # "sourceName":Ljava/lang/String;
    .end local v9    # "targetName":Ljava/lang/String;
    .end local v10    # "previousTarget":Ljava/lang/String;
    :goto_3
    add-int/lit8 v7, v7, 0x1

    goto :goto_2

    .line 145
    .end local v2    # "record":Landroid/support/v4/app/BackStackRecord;
    .end local v3    # "isPop":Z
    .end local v4    # "numSharedElements":I
    .end local v5    # "targets":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    .end local v6    # "sources":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    .end local v7    # "i":I
    :cond_3
    :goto_4
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 174
    .end local v1    # "recordNum":I
    :cond_4
    return-object v0
.end method

.method public static calculatePopFragments(Landroid/support/v4/app/BackStackRecord;Landroid/util/SparseArray;Z)V
    .locals 4
    .param p0, "transaction"    # Landroid/support/v4/app/BackStackRecord;
    .param p2, "isReordered"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/BackStackRecord;",
            "Landroid/util/SparseArray<",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ">;Z)V"
        }
    .end annotation

    .line 1010
    .local p1, "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    iget-object v0, p0, Landroid/support/v4/app/BackStackRecord;->mManager:Landroid/support/v4/app/FragmentManagerImpl;

    iget-object v0, v0, Landroid/support/v4/app/FragmentManagerImpl;->mContainer:Landroid/support/v4/app/FragmentContainer;

    invoke-virtual {v0}, Landroid/support/v4/app/FragmentContainer;->onHasView()Z

    move-result v0

    if-nez v0, :cond_0

    .line 1011
    return-void

    .line 1013
    :cond_0
    iget-object v0, p0, Landroid/support/v4/app/BackStackRecord;->mOps:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 1014
    .local v0, "numOps":I
    add-int/lit8 v1, v0, -0x1

    .line 1014
    .local v1, "opNum":I
    :goto_0
    if-ltz v1, :cond_1

    .line 1015
    iget-object v2, p0, Landroid/support/v4/app/BackStackRecord;->mOps:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/app/BackStackRecord$Op;

    .line 1016
    .local v2, "op":Landroid/support/v4/app/BackStackRecord$Op;
    const/4 v3, 0x1

    invoke-static {p0, v2, p1, v3, p2}, Landroid/support/v4/app/FragmentTransition;->addToFirstInLastOut(Landroid/support/v4/app/BackStackRecord;Landroid/support/v4/app/BackStackRecord$Op;Landroid/util/SparseArray;ZZ)V

    .line 1014
    .end local v2    # "op":Landroid/support/v4/app/BackStackRecord$Op;
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 1018
    .end local v1    # "opNum":I
    :cond_1
    return-void
.end method

.method private static callSharedElementStartEnd(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Z)V
    .locals 6
    .param p0, "inFragment"    # Landroid/support/v4/app/Fragment;
    .param p1, "outFragment"    # Landroid/support/v4/app/Fragment;
    .param p2, "isPop"    # Z
    .param p4, "isStart"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/Fragment;",
            "Landroid/support/v4/app/Fragment;",
            "Z",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;Z)V"
        }
    .end annotation

    .line 897
    .local p3, "sharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    if-eqz p2, :cond_0

    .line 898
    invoke-virtual {p1}, Landroid/support/v4/app/Fragment;->getEnterTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v0

    goto :goto_0

    .line 899
    :cond_0
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getEnterTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v0

    .line 900
    .local v0, "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    :goto_0
    if-eqz v0, :cond_4

    .line 901
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 902
    .local v1, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 903
    .local v2, "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    const/4 v3, 0x0

    if-nez p3, :cond_1

    move v4, v3

    goto :goto_1

    :cond_1
    invoke-virtual {p3}, Landroid/support/v4/util/ArrayMap;->size()I

    move-result v4

    .line 904
    .local v4, "count":I
    :goto_1
    nop

    .line 904
    .local v3, "i":I
    :goto_2
    if-ge v3, v4, :cond_2

    .line 905
    invoke-virtual {p3, v3}, Landroid/support/v4/util/ArrayMap;->keyAt(I)Ljava/lang/Object;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 906
    invoke-virtual {p3, v3}, Landroid/support/v4/util/ArrayMap;->valueAt(I)Ljava/lang/Object;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 904
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 908
    .end local v3    # "i":I
    :cond_2
    const/4 v3, 0x0

    if-eqz p4, :cond_3

    .line 909
    invoke-virtual {v0, v2, v1, v3}, Landroid/support/v4/app/SharedElementCallback;->onSharedElementStart(Ljava/util/List;Ljava/util/List;Ljava/util/List;)V

    goto :goto_3

    .line 911
    :cond_3
    invoke-virtual {v0, v2, v1, v3}, Landroid/support/v4/app/SharedElementCallback;->onSharedElementEnd(Ljava/util/List;Ljava/util/List;Ljava/util/List;)V

    .line 914
    .end local v1    # "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v2    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    .end local v4    # "count":I
    :cond_4
    :goto_3
    return-void
.end method

.method private static captureInSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;
    .locals 11
    .param p1, "sharedElementTransition"    # Ljava/lang/Object;
    .param p2, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/Object;",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ")",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 759
    .local p0, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    iget-object v0, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 760
    .local v0, "inFragment":Landroid/support/v4/app/Fragment;
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getView()Landroid/view/View;

    move-result-object v1

    .line 761
    .local v1, "fragmentView":Landroid/view/View;
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_8

    if-eqz p1, :cond_8

    if-nez v1, :cond_0

    goto :goto_3

    .line 765
    :cond_0
    new-instance v2, Landroid/support/v4/util/ArrayMap;

    invoke-direct {v2}, Landroid/support/v4/util/ArrayMap;-><init>()V

    .line 766
    .local v2, "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-static {v2, v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->findNamedViews(Ljava/util/Map;Landroid/view/View;)V

    .line 770
    iget-object v3, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 771
    .local v3, "inTransaction":Landroid/support/v4/app/BackStackRecord;
    iget-boolean v4, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    if-eqz v4, :cond_1

    .line 772
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getExitTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v4

    .line 773
    .local v4, "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    iget-object v5, v3, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 773
    .local v5, "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    goto :goto_0

    .line 775
    .end local v4    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    .end local v5    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_1
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getEnterTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v4

    .line 776
    .restart local v4    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    iget-object v5, v3, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 779
    .restart local v5    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :goto_0
    if-eqz v5, :cond_2

    .line 780
    invoke-virtual {v2, v5}, Landroid/support/v4/util/ArrayMap;->retainAll(Ljava/util/Collection;)Z

    .line 782
    :cond_2
    if-eqz v4, :cond_6

    .line 783
    invoke-virtual {v4, v5, v2}, Landroid/support/v4/app/SharedElementCallback;->onMapSharedElements(Ljava/util/List;Ljava/util/Map;)V

    .line 784
    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v6

    add-int/lit8 v6, v6, -0x1

    .line 784
    .local v6, "i":I
    :goto_1
    if-ltz v6, :cond_7

    .line 785
    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    .line 786
    .local v7, "name":Ljava/lang/String;
    invoke-virtual {v2, v7}, Landroid/support/v4/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/View;

    .line 787
    .local v8, "view":Landroid/view/View;
    if-nez v8, :cond_4

    .line 788
    invoke-static {p0, v7}, Landroid/support/v4/app/FragmentTransition;->findKeyForValue(Landroid/support/v4/util/ArrayMap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 789
    .local v9, "key":Ljava/lang/String;
    if-eqz v9, :cond_3

    .line 790
    invoke-virtual {p0, v9}, Landroid/support/v4/util/ArrayMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 792
    .end local v9    # "key":Ljava/lang/String;
    :cond_3
    goto :goto_2

    :cond_4
    invoke-static {v8}, Landroid/support/v4/view/ViewCompat;->getTransitionName(Landroid/view/View;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v7, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_5

    .line 793
    invoke-static {p0, v7}, Landroid/support/v4/app/FragmentTransition;->findKeyForValue(Landroid/support/v4/util/ArrayMap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 794
    .restart local v9    # "key":Ljava/lang/String;
    if-eqz v9, :cond_5

    .line 795
    invoke-static {v8}, Landroid/support/v4/view/ViewCompat;->getTransitionName(Landroid/view/View;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {p0, v9, v10}, Landroid/support/v4/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 784
    .end local v7    # "name":Ljava/lang/String;
    .end local v8    # "view":Landroid/view/View;
    .end local v9    # "key":Ljava/lang/String;
    :cond_5
    :goto_2
    add-int/lit8 v6, v6, -0x1

    goto :goto_1

    .line 800
    .end local v6    # "i":I
    :cond_6
    invoke-static {p0, v2}, Landroid/support/v4/app/FragmentTransition;->retainValues(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/util/ArrayMap;)V

    .line 802
    :cond_7
    return-object v2

    .line 762
    .end local v2    # "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .end local v3    # "inTransaction":Landroid/support/v4/app/BackStackRecord;
    .end local v4    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    .end local v5    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_8
    :goto_3
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->clear()V

    .line 763
    const/4 v2, 0x0

    return-object v2
.end method

.method private static captureOutSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;
    .locals 10
    .param p1, "sharedElementTransition"    # Ljava/lang/Object;
    .param p2, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/Object;",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ")",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 703
    .local p0, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6

    if-nez p1, :cond_0

    goto :goto_3

    .line 707
    :cond_0
    iget-object v0, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 708
    .local v0, "outFragment":Landroid/support/v4/app/Fragment;
    new-instance v1, Landroid/support/v4/util/ArrayMap;

    invoke-direct {v1}, Landroid/support/v4/util/ArrayMap;-><init>()V

    .line 709
    .local v1, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getView()Landroid/view/View;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/support/v4/app/FragmentTransitionCompat21;->findNamedViews(Ljava/util/Map;Landroid/view/View;)V

    .line 713
    iget-object v2, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 714
    .local v2, "outTransaction":Landroid/support/v4/app/BackStackRecord;
    iget-boolean v3, p2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    if-eqz v3, :cond_1

    .line 715
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getEnterTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v3

    .line 716
    .local v3, "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    iget-object v4, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 716
    .local v4, "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    goto :goto_0

    .line 718
    .end local v3    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    .end local v4    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_1
    invoke-virtual {v0}, Landroid/support/v4/app/Fragment;->getExitTransitionCallback()Landroid/support/v4/app/SharedElementCallback;

    move-result-object v3

    .line 719
    .restart local v3    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    iget-object v4, v2, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 722
    .restart local v4    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :goto_0
    invoke-virtual {v1, v4}, Landroid/support/v4/util/ArrayMap;->retainAll(Ljava/util/Collection;)Z

    .line 723
    if-eqz v3, :cond_4

    .line 724
    invoke-virtual {v3, v4, v1}, Landroid/support/v4/app/SharedElementCallback;->onMapSharedElements(Ljava/util/List;Ljava/util/Map;)V

    .line 725
    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v5

    add-int/lit8 v5, v5, -0x1

    .line 725
    .local v5, "i":I
    :goto_1
    if-ltz v5, :cond_5

    .line 726
    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 727
    .local v6, "name":Ljava/lang/String;
    invoke-virtual {v1, v6}, Landroid/support/v4/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/view/View;

    .line 728
    .local v7, "view":Landroid/view/View;
    if-nez v7, :cond_2

    .line 729
    invoke-virtual {p0, v6}, Landroid/support/v4/util/ArrayMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_2

    .line 730
    :cond_2
    invoke-static {v7}, Landroid/support/v4/view/ViewCompat;->getTransitionName(Landroid/view/View;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v6, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_3

    .line 731
    invoke-virtual {p0, v6}, Landroid/support/v4/util/ArrayMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    .line 732
    .local v8, "targetValue":Ljava/lang/String;
    invoke-static {v7}, Landroid/support/v4/view/ViewCompat;->getTransitionName(Landroid/view/View;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p0, v9, v8}, Landroid/support/v4/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 725
    .end local v6    # "name":Ljava/lang/String;
    .end local v7    # "view":Landroid/view/View;
    .end local v8    # "targetValue":Ljava/lang/String;
    :cond_3
    :goto_2
    add-int/lit8 v5, v5, -0x1

    goto :goto_1

    .line 736
    .end local v5    # "i":I
    :cond_4
    invoke-virtual {v1}, Landroid/support/v4/util/ArrayMap;->keySet()Ljava/util/Set;

    move-result-object v5

    invoke-virtual {p0, v5}, Landroid/support/v4/util/ArrayMap;->retainAll(Ljava/util/Collection;)Z

    .line 738
    :cond_5
    return-object v1

    .line 704
    .end local v0    # "outFragment":Landroid/support/v4/app/Fragment;
    .end local v1    # "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .end local v2    # "outTransaction":Landroid/support/v4/app/BackStackRecord;
    .end local v3    # "sharedElementCallback":Landroid/support/v4/app/SharedElementCallback;
    .end local v4    # "names":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    :cond_6
    :goto_3
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->clear()V

    .line 705
    const/4 v0, 0x0

    return-object v0
.end method

.method private static configureEnteringExitingViews(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;
    .locals 3
    .param p0, "transition"    # Ljava/lang/Object;
    .param p1, "fragment"    # Landroid/support/v4/app/Fragment;
    .param p3, "nonExistentView"    # Landroid/view/View;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Landroid/support/v4/app/Fragment;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Landroid/view/View;",
            ")",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 919
    .local p2, "sharedElements":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    const/4 v0, 0x0

    .line 920
    .local v0, "viewList":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    if-eqz p0, :cond_2

    .line 921
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object v0, v1

    .line 922
    invoke-virtual {p1}, Landroid/support/v4/app/Fragment;->getView()Landroid/view/View;

    move-result-object v1

    .line 923
    .local v1, "root":Landroid/view/View;
    if-eqz v1, :cond_0

    .line 924
    invoke-static {v0, v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->captureTransitioningViews(Ljava/util/ArrayList;Landroid/view/View;)V

    .line 926
    :cond_0
    if-eqz p2, :cond_1

    .line 927
    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->removeAll(Ljava/util/Collection;)Z

    .line 929
    :cond_1
    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_2

    .line 930
    invoke-virtual {v0, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 931
    invoke-static {p0, v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->addTargets(Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 934
    .end local v1    # "root":Landroid/view/View;
    :cond_2
    return-object v0
.end method

.method private static configureSharedElementsOrdered(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 21
    .param p0, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p1, "nonExistentView"    # Landroid/view/View;
    .param p3, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p6, "enterTransition"    # Ljava/lang/Object;
    .param p7, "exitTransition"    # Ljava/lang/Object;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/ViewGroup;",
            "Landroid/view/View;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 609
    .local p2, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    .local p4, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p5, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v12, p3

    move-object/from16 v13, p4

    move-object/from16 v14, p6

    .line 609
    move-object/from16 v15, p7

    iget-object v10, v12, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 610
    .local v10, "inFragment":Landroid/support/v4/app/Fragment;
    iget-object v9, v12, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 612
    .local v9, "outFragment":Landroid/support/v4/app/Fragment;
    const/4 v0, 0x0

    if-eqz v10, :cond_6

    if-nez v9, :cond_0

    .line 613
    move-object/from16 v1, p0

    move-object/from16 v19, v9

    move-object/from16 v20, v10

    goto/16 :goto_4

    .line 616
    :cond_0
    iget-boolean v8, v12, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    .line 617
    .local v8, "inIsPop":Z
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 618
    move-object v1, v0

    goto :goto_0

    :cond_1
    invoke-static {v10, v9, v8}, Landroid/support/v4/app/FragmentTransition;->getSharedElementTransition(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v1

    .line 620
    .local v1, "sharedElementTransition":Ljava/lang/Object;
    :goto_0
    move-object/from16 v7, p2

    invoke-static {v7, v1, v12}, Landroid/support/v4/app/FragmentTransition;->captureOutSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;

    move-result-object v6

    .line 623
    .local v6, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 624
    const/4 v1, 0x0

    .line 629
    .end local v1    # "sharedElementTransition":Ljava/lang/Object;
    .local v5, "sharedElementTransition":Ljava/lang/Object;
    :goto_1
    move-object v5, v1

    goto :goto_2

    .line 626
    .end local v5    # "sharedElementTransition":Ljava/lang/Object;
    .restart local v1    # "sharedElementTransition":Ljava/lang/Object;
    :cond_2
    invoke-virtual {v6}, Landroid/support/v4/util/ArrayMap;->values()Ljava/util/Collection;

    move-result-object v2

    invoke-virtual {v13, v2}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    goto :goto_1

    .line 629
    .end local v1    # "sharedElementTransition":Ljava/lang/Object;
    .restart local v5    # "sharedElementTransition":Ljava/lang/Object;
    :goto_2
    if-nez v14, :cond_3

    if-nez v15, :cond_3

    if-nez v5, :cond_3

    .line 631
    return-object v0

    .line 634
    :cond_3
    const/4 v1, 0x1

    invoke-static {v10, v9, v8, v6, v1}, Landroid/support/v4/app/FragmentTransition;->callSharedElementStartEnd(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Z)V

    .line 637
    if-eqz v5, :cond_5

    .line 638
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    .line 639
    .local v0, "inEpicenter":Landroid/graphics/Rect;
    move-object/from16 v4, p1

    invoke-static {v5, v4, v13}, Landroid/support/v4/app/FragmentTransitionCompat21;->setSharedElementTargets(Ljava/lang/Object;Landroid/view/View;Ljava/util/ArrayList;)V

    .line 641
    iget-boolean v1, v12, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    .line 642
    .local v1, "outIsPop":Z
    iget-object v2, v12, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 643
    .local v2, "outTransaction":Landroid/support/v4/app/BackStackRecord;
    invoke-static {v5, v15, v6, v1, v2}, Landroid/support/v4/app/FragmentTransition;->setOutEpicenter(Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/util/ArrayMap;ZLandroid/support/v4/app/BackStackRecord;)V

    .line 645
    if-eqz v14, :cond_4

    .line 646
    invoke-static {v14, v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->setEpicenter(Ljava/lang/Object;Landroid/graphics/Rect;)V

    .line 648
    .end local v1    # "outIsPop":Z
    .end local v2    # "outTransaction":Landroid/support/v4/app/BackStackRecord;
    :cond_4
    goto :goto_3

    .line 649
    .end local v0    # "inEpicenter":Landroid/graphics/Rect;
    :cond_5
    move-object/from16 v4, p1

    .line 649
    .local v11, "inEpicenter":Landroid/graphics/Rect;
    :goto_3
    move-object v11, v0

    .line 653
    move-object v2, v5

    .line 654
    .local v2, "finalSharedElementTransition":Ljava/lang/Object;
    new-instance v3, Landroid/support/v4/app/FragmentTransition$4;

    move-object v0, v3

    move-object v1, v7

    move-object v15, v3

    move-object v3, v12

    move-object/from16 v4, p5

    move-object/from16 v16, v5

    move-object/from16 v5, p1

    .line 654
    .end local v5    # "sharedElementTransition":Ljava/lang/Object;
    .local v16, "sharedElementTransition":Ljava/lang/Object;
    move-object/from16 v17, v6

    move-object v6, v10

    .line 654
    .end local v6    # "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .local v17, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    move-object v7, v9

    move/from16 v18, v8

    .line 654
    .end local v8    # "inIsPop":Z
    .local v18, "inIsPop":Z
    move-object/from16 v19, v9

    move-object v9, v13

    .line 654
    .end local v9    # "outFragment":Landroid/support/v4/app/Fragment;
    .local v19, "outFragment":Landroid/support/v4/app/Fragment;
    move-object/from16 v20, v10

    move-object v10, v14

    .line 654
    .end local v10    # "inFragment":Landroid/support/v4/app/Fragment;
    .local v20, "inFragment":Landroid/support/v4/app/Fragment;
    invoke-direct/range {v0 .. v11}, Landroid/support/v4/app/FragmentTransition$4;-><init>(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/util/ArrayList;Landroid/view/View;Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLjava/util/ArrayList;Ljava/lang/Object;Landroid/graphics/Rect;)V

    move-object/from16 v1, p0

    invoke-static {v1, v15}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 682
    return-object v16

    .line 613
    .end local v2    # "finalSharedElementTransition":Ljava/lang/Object;
    .end local v11    # "inEpicenter":Landroid/graphics/Rect;
    .end local v16    # "sharedElementTransition":Ljava/lang/Object;
    .end local v17    # "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .end local v18    # "inIsPop":Z
    .end local v19    # "outFragment":Landroid/support/v4/app/Fragment;
    .end local v20    # "inFragment":Landroid/support/v4/app/Fragment;
    .restart local v9    # "outFragment":Landroid/support/v4/app/Fragment;
    .restart local v10    # "inFragment":Landroid/support/v4/app/Fragment;
    :cond_6
    move-object/from16 v1, p0

    move-object/from16 v19, v9

    move-object/from16 v20, v10

    .line 613
    .end local v9    # "outFragment":Landroid/support/v4/app/Fragment;
    .end local v10    # "inFragment":Landroid/support/v4/app/Fragment;
    .restart local v19    # "outFragment":Landroid/support/v4/app/Fragment;
    .restart local v20    # "inFragment":Landroid/support/v4/app/Fragment;
    :goto_4
    return-object v0
.end method

.method private static configureSharedElementsReordered(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 22
    .param p0, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p1, "nonExistentView"    # Landroid/view/View;
    .param p3, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p6, "enterTransition"    # Ljava/lang/Object;
    .param p7, "exitTransition"    # Ljava/lang/Object;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/ViewGroup;",
            "Landroid/view/View;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 480
    .local p2, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    .local p4, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p5, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v0, p1

    move-object/from16 v1, p2

    move-object/from16 v2, p3

    move-object/from16 v3, p4

    move-object/from16 v4, p5

    move-object/from16 v5, p6

    .line 480
    move-object/from16 v6, p7

    iget-object v14, v2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 481
    .local v14, "inFragment":Landroid/support/v4/app/Fragment;
    iget-object v15, v2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 482
    .local v15, "outFragment":Landroid/support/v4/app/Fragment;
    if-eqz v14, :cond_0

    .line 483
    invoke-virtual {v14}, Landroid/support/v4/app/Fragment;->getView()Landroid/view/View;

    move-result-object v7

    const/4 v8, 0x0

    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V

    .line 485
    :cond_0
    const/4 v7, 0x0

    if-eqz v14, :cond_9

    if-nez v15, :cond_1

    goto/16 :goto_3

    .line 489
    :cond_1
    iget-boolean v13, v2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    .line 490
    .local v13, "inIsPop":Z
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_2

    .line 491
    move-object v8, v7

    goto :goto_0

    :cond_2
    invoke-static {v14, v15, v13}, Landroid/support/v4/app/FragmentTransition;->getSharedElementTransition(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v8

    .line 493
    .local v8, "sharedElementTransition":Ljava/lang/Object;
    :goto_0
    invoke-static {v1, v8, v2}, Landroid/support/v4/app/FragmentTransition;->captureOutSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;

    move-result-object v11

    .line 496
    .local v11, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-static {v1, v8, v2}, Landroid/support/v4/app/FragmentTransition;->captureInSharedElements(Landroid/support/v4/util/ArrayMap;Ljava/lang/Object;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;)Landroid/support/v4/util/ArrayMap;

    move-result-object v10

    .line 499
    .local v10, "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->isEmpty()Z

    move-result v9

    if-eqz v9, :cond_4

    .line 500
    const/4 v8, 0x0

    .line 501
    if-eqz v11, :cond_3

    .line 502
    invoke-virtual {v11}, Landroid/support/v4/util/ArrayMap;->clear()V

    .line 504
    :cond_3
    if-eqz v10, :cond_5

    .line 505
    invoke-virtual {v10}, Landroid/support/v4/util/ArrayMap;->clear()V

    goto :goto_1

    .line 508
    :cond_4
    nop

    .line 509
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->keySet()Ljava/util/Set;

    move-result-object v9

    .line 508
    invoke-static {v3, v11, v9}, Landroid/support/v4/app/FragmentTransition;->addSharedElementsWithMatchingNames(Ljava/util/ArrayList;Landroid/support/v4/util/ArrayMap;Ljava/util/Collection;)V

    .line 510
    nop

    .line 511
    invoke-virtual/range {p2 .. p2}, Landroid/support/v4/util/ArrayMap;->values()Ljava/util/Collection;

    move-result-object v9

    .line 510
    invoke-static {v4, v10, v9}, Landroid/support/v4/app/FragmentTransition;->addSharedElementsWithMatchingNames(Ljava/util/ArrayList;Landroid/support/v4/util/ArrayMap;Ljava/util/Collection;)V

    .line 514
    .end local v8    # "sharedElementTransition":Ljava/lang/Object;
    .local v9, "sharedElementTransition":Ljava/lang/Object;
    :cond_5
    :goto_1
    move-object v9, v8

    if-nez v5, :cond_6

    if-nez v6, :cond_6

    if-nez v9, :cond_6

    .line 516
    return-object v7

    .line 519
    :cond_6
    const/4 v8, 0x1

    invoke-static {v14, v15, v13, v11, v8}, Landroid/support/v4/app/FragmentTransition;->callSharedElementStartEnd(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Z)V

    .line 523
    if-eqz v9, :cond_8

    .line 524
    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 525
    invoke-static {v9, v0, v3}, Landroid/support/v4/app/FragmentTransitionCompat21;->setSharedElementTargets(Ljava/lang/Object;Landroid/view/View;Ljava/util/ArrayList;)V

    .line 527
    iget-boolean v7, v2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    .line 528
    .local v7, "outIsPop":Z
    iget-object v8, v2, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 529
    .local v8, "outTransaction":Landroid/support/v4/app/BackStackRecord;
    invoke-static {v9, v6, v11, v7, v8}, Landroid/support/v4/app/FragmentTransition;->setOutEpicenter(Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/util/ArrayMap;ZLandroid/support/v4/app/BackStackRecord;)V

    .line 531
    new-instance v12, Landroid/graphics/Rect;

    invoke-direct {v12}, Landroid/graphics/Rect;-><init>()V

    .line 532
    .local v12, "epicenter":Landroid/graphics/Rect;
    invoke-static {v10, v2, v5, v13}, Landroid/support/v4/app/FragmentTransition;->getInEpicenterView(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/lang/Object;Z)Landroid/view/View;

    move-result-object v16

    .line 534
    .local v16, "epicenterView":Landroid/view/View;
    if-eqz v16, :cond_7

    .line 535
    invoke-static {v5, v12}, Landroid/support/v4/app/FragmentTransitionCompat21;->setEpicenter(Ljava/lang/Object;Landroid/graphics/Rect;)V

    .line 537
    .end local v7    # "outIsPop":Z
    .end local v8    # "outTransaction":Landroid/support/v4/app/BackStackRecord;
    :cond_7
    nop

    .line 539
    move-object/from16 v21, v16

    move-object/from16 v16, v12

    move-object/from16 v12, v21

    goto :goto_2

    .line 538
    .end local v12    # "epicenter":Landroid/graphics/Rect;
    .end local v16    # "epicenterView":Landroid/view/View;
    :cond_8
    const/4 v8, 0x0

    .line 539
    .local v8, "epicenter":Landroid/graphics/Rect;
    move-object v12, v7

    move-object/from16 v16, v8

    .line 542
    .end local v8    # "epicenter":Landroid/graphics/Rect;
    .local v12, "epicenterView":Landroid/view/View;
    .local v16, "epicenter":Landroid/graphics/Rect;
    :goto_2
    new-instance v8, Landroid/support/v4/app/FragmentTransition$3;

    move-object v7, v8

    move-object v0, v8

    move-object v8, v14

    move-object/from16 v17, v9

    move-object v9, v15

    .line 542
    .end local v9    # "sharedElementTransition":Ljava/lang/Object;
    .local v17, "sharedElementTransition":Ljava/lang/Object;
    move-object/from16 v18, v10

    move v10, v13

    .line 542
    .end local v10    # "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .local v18, "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    move-object/from16 v19, v11

    move-object/from16 v11, v18

    .line 542
    .end local v11    # "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .local v19, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    move/from16 v20, v13

    move-object/from16 v13, v16

    .line 542
    .end local v13    # "inIsPop":Z
    .local v20, "inIsPop":Z
    invoke-direct/range {v7 .. v13}, Landroid/support/v4/app/FragmentTransition$3;-><init>(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;ZLandroid/support/v4/util/ArrayMap;Landroid/view/View;Landroid/graphics/Rect;)V

    move-object/from16 v8, p0

    invoke-static {v8, v0}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 552
    return-object v17

    .line 486
    .end local v12    # "epicenterView":Landroid/view/View;
    .end local v16    # "epicenter":Landroid/graphics/Rect;
    .end local v17    # "sharedElementTransition":Ljava/lang/Object;
    .end local v18    # "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .end local v19    # "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    .end local v20    # "inIsPop":Z
    :cond_9
    :goto_3
    move-object/from16 v8, p0

    return-object v7
.end method

.method private static configureTransitionsOrdered(Landroid/support/v4/app/FragmentManagerImpl;ILandroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/view/View;Landroid/support/v4/util/ArrayMap;)V
    .locals 30
    .param p0, "fragmentManager"    # Landroid/support/v4/app/FragmentManagerImpl;
    .param p1, "containerId"    # I
    .param p2, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p3, "nonExistentView"    # Landroid/view/View;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/FragmentManagerImpl;",
            "I",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Landroid/view/View;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 291
    .local p4, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    move-object/from16 v0, p0

    move-object/from16 v9, p2

    move-object/from16 v10, p3

    .line 291
    move-object/from16 v11, p4

    const/4 v1, 0x0

    .line 292
    .local v1, "sceneRoot":Landroid/view/ViewGroup;
    iget-object v2, v0, Landroid/support/v4/app/FragmentManagerImpl;->mContainer:Landroid/support/v4/app/FragmentContainer;

    invoke-virtual {v2}, Landroid/support/v4/app/FragmentContainer;->onHasView()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 293
    iget-object v2, v0, Landroid/support/v4/app/FragmentManagerImpl;->mContainer:Landroid/support/v4/app/FragmentContainer;

    move/from16 v12, p1

    invoke-virtual {v2, v12}, Landroid/support/v4/app/FragmentContainer;->onFindViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v1, v2

    check-cast v1, Landroid/view/ViewGroup;

    goto :goto_0

    .line 295
    :cond_0
    move/from16 v12, p1

    .line 295
    .end local v1    # "sceneRoot":Landroid/view/ViewGroup;
    .local v13, "sceneRoot":Landroid/view/ViewGroup;
    :goto_0
    move-object v13, v1

    if-nez v13, :cond_1

    .line 296
    return-void

    .line 298
    :cond_1
    iget-object v14, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 299
    .local v14, "inFragment":Landroid/support/v4/app/Fragment;
    iget-object v15, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 300
    .local v15, "outFragment":Landroid/support/v4/app/Fragment;
    iget-boolean v8, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    .line 301
    .local v8, "inIsPop":Z
    iget-boolean v7, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    .line 303
    .local v7, "outIsPop":Z
    invoke-static {v14, v8}, Landroid/support/v4/app/FragmentTransition;->getEnterTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v6

    .line 304
    .local v6, "enterTransition":Ljava/lang/Object;
    invoke-static {v15, v7}, Landroid/support/v4/app/FragmentTransition;->getExitTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v5

    .line 306
    .local v5, "exitTransition":Ljava/lang/Object;
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object v4, v1

    .line 307
    .local v4, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object v3, v1

    .line 309
    .local v3, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v1, v13

    move-object v2, v10

    move-object/from16 v23, v3

    move-object v3, v11

    .line 309
    .end local v3    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v23, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v24, v4

    move-object v4, v9

    .line 309
    .end local v4    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v24, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v25, v5

    move-object/from16 v5, v24

    .line 309
    .end local v5    # "exitTransition":Ljava/lang/Object;
    .local v25, "exitTransition":Ljava/lang/Object;
    move-object/from16 v26, v6

    move-object/from16 v6, v23

    .line 309
    .end local v6    # "enterTransition":Ljava/lang/Object;
    .local v26, "enterTransition":Ljava/lang/Object;
    move/from16 v27, v7

    move-object/from16 v7, v26

    .line 309
    .end local v7    # "outIsPop":Z
    .local v27, "outIsPop":Z
    move/from16 v28, v8

    move-object/from16 v8, v25

    .line 309
    .end local v8    # "inIsPop":Z
    .local v28, "inIsPop":Z
    invoke-static/range {v1 .. v8}, Landroid/support/v4/app/FragmentTransition;->configureSharedElementsOrdered(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    .line 313
    .local v8, "sharedElementTransition":Ljava/lang/Object;
    if-nez v7, :cond_2

    .line 313
    .end local v26    # "enterTransition":Ljava/lang/Object;
    .local v7, "enterTransition":Ljava/lang/Object;
    if-nez v8, :cond_2

    move-object/from16 v1, v25

    if-nez v1, :cond_3

    .line 315
    .end local v25    # "exitTransition":Ljava/lang/Object;
    .local v1, "exitTransition":Ljava/lang/Object;
    return-void

    .line 318
    .end local v1    # "exitTransition":Ljava/lang/Object;
    .restart local v25    # "exitTransition":Ljava/lang/Object;
    :cond_2
    move-object/from16 v1, v25

    .line 318
    .end local v25    # "exitTransition":Ljava/lang/Object;
    .restart local v1    # "exitTransition":Ljava/lang/Object;
    :cond_3
    move-object/from16 v6, v24

    invoke-static {v1, v15, v6, v10}, Landroid/support/v4/app/FragmentTransition;->configureEnteringExitingViews(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;

    move-result-object v5

    .line 321
    .end local v24    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v5, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v6, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    if-eqz v5, :cond_5

    invoke-virtual {v5}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_4

    goto :goto_2

    .line 327
    .end local v1    # "exitTransition":Ljava/lang/Object;
    .local v4, "exitTransition":Ljava/lang/Object;
    :cond_4
    :goto_1
    move-object v4, v1

    goto :goto_3

    .line 322
    .end local v4    # "exitTransition":Ljava/lang/Object;
    .restart local v1    # "exitTransition":Ljava/lang/Object;
    :cond_5
    :goto_2
    const/4 v1, 0x0

    goto :goto_1

    .line 327
    .end local v1    # "exitTransition":Ljava/lang/Object;
    .restart local v4    # "exitTransition":Ljava/lang/Object;
    :goto_3
    invoke-static {v7, v10}, Landroid/support/v4/app/FragmentTransitionCompat21;->addTarget(Ljava/lang/Object;Landroid/view/View;)V

    .line 329
    iget-boolean v1, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    invoke-static {v7, v4, v8, v14, v1}, Landroid/support/v4/app/FragmentTransition;->mergeTransitions(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v3

    .line 332
    .local v3, "transition":Ljava/lang/Object;
    if-eqz v3, :cond_6

    .line 333
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object/from16 v18, v1

    .line 334
    .local v18, "enteringViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v16, v3

    move-object/from16 v17, v7

    move-object/from16 v19, v4

    move-object/from16 v20, v5

    move-object/from16 v21, v8

    move-object/from16 v22, v23

    invoke-static/range {v16 .. v22}, Landroid/support/v4/app/FragmentTransitionCompat21;->scheduleRemoveTargets(Ljava/lang/Object;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 337
    move-object v1, v13

    move-object v2, v14

    move-object v0, v3

    move-object v3, v10

    .line 337
    .end local v3    # "transition":Ljava/lang/Object;
    .local v0, "transition":Ljava/lang/Object;
    move-object/from16 v16, v4

    move-object/from16 v4, v23

    .line 337
    .end local v4    # "exitTransition":Ljava/lang/Object;
    .local v16, "exitTransition":Ljava/lang/Object;
    move-object/from16 v17, v5

    move-object v5, v7

    .line 337
    .end local v5    # "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v17, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v19, v6

    move-object/from16 v6, v18

    .line 337
    .end local v6    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v19, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object/from16 v20, v7

    move-object/from16 v7, v16

    .line 337
    .end local v7    # "enterTransition":Ljava/lang/Object;
    .local v20, "enterTransition":Ljava/lang/Object;
    move-object/from16 v8, v17

    .line 337
    .end local v8    # "sharedElementTransition":Ljava/lang/Object;
    .local v21, "sharedElementTransition":Ljava/lang/Object;
    invoke-static/range {v1 .. v8}, Landroid/support/v4/app/FragmentTransition;->scheduleTargetChange(Landroid/view/ViewGroup;Landroid/support/v4/app/Fragment;Landroid/view/View;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 339
    move-object/from16 v1, v23

    invoke-static {v13, v1, v11}, Landroid/support/v4/app/FragmentTransitionCompat21;->setNameOverridesOrdered(Landroid/view/View;Ljava/util/ArrayList;Ljava/util/Map;)V

    .line 342
    .end local v23    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v1, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    invoke-static {v13, v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->beginDelayedTransition(Landroid/view/ViewGroup;Ljava/lang/Object;)V

    .line 343
    invoke-static {v13, v1, v11}, Landroid/support/v4/app/FragmentTransitionCompat21;->scheduleNameReset(Landroid/view/ViewGroup;Ljava/util/ArrayList;Ljava/util/Map;)V

    .line 343
    .end local v18    # "enteringViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    goto :goto_4

    .line 346
    .end local v0    # "transition":Ljava/lang/Object;
    .end local v1    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v16    # "exitTransition":Ljava/lang/Object;
    .end local v17    # "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v19    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v20    # "enterTransition":Ljava/lang/Object;
    .end local v21    # "sharedElementTransition":Ljava/lang/Object;
    .restart local v3    # "transition":Ljava/lang/Object;
    .restart local v4    # "exitTransition":Ljava/lang/Object;
    .restart local v5    # "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v6    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v7    # "enterTransition":Ljava/lang/Object;
    .restart local v8    # "sharedElementTransition":Ljava/lang/Object;
    .restart local v23    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    :cond_6
    move-object v0, v3

    move-object/from16 v16, v4

    move-object/from16 v17, v5

    move-object/from16 v19, v6

    move-object/from16 v20, v7

    move-object/from16 v21, v8

    move-object/from16 v1, v23

    .line 346
    .end local v3    # "transition":Ljava/lang/Object;
    .end local v4    # "exitTransition":Ljava/lang/Object;
    .end local v5    # "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v6    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .end local v7    # "enterTransition":Ljava/lang/Object;
    .end local v8    # "sharedElementTransition":Ljava/lang/Object;
    .end local v23    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v0    # "transition":Ljava/lang/Object;
    .restart local v1    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v16    # "exitTransition":Ljava/lang/Object;
    .restart local v17    # "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v19    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .restart local v20    # "enterTransition":Ljava/lang/Object;
    .restart local v21    # "sharedElementTransition":Ljava/lang/Object;
    :goto_4
    return-void
.end method

.method private static configureTransitionsReordered(Landroid/support/v4/app/FragmentManagerImpl;ILandroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/view/View;Landroid/support/v4/util/ArrayMap;)V
    .locals 27
    .param p0, "fragmentManager"    # Landroid/support/v4/app/FragmentManagerImpl;
    .param p1, "containerId"    # I
    .param p2, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p3, "nonExistentView"    # Landroid/view/View;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/FragmentManagerImpl;",
            "I",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Landroid/view/View;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 196
    .local p4, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    move-object/from16 v0, p0

    move-object/from16 v9, p2

    move-object/from16 v10, p3

    .line 196
    const/4 v1, 0x0

    .line 197
    .local v1, "sceneRoot":Landroid/view/ViewGroup;
    iget-object v2, v0, Landroid/support/v4/app/FragmentManagerImpl;->mContainer:Landroid/support/v4/app/FragmentContainer;

    invoke-virtual {v2}, Landroid/support/v4/app/FragmentContainer;->onHasView()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 198
    iget-object v2, v0, Landroid/support/v4/app/FragmentManagerImpl;->mContainer:Landroid/support/v4/app/FragmentContainer;

    move/from16 v11, p1

    invoke-virtual {v2, v11}, Landroid/support/v4/app/FragmentContainer;->onFindViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v1, v2

    check-cast v1, Landroid/view/ViewGroup;

    goto :goto_0

    .line 200
    :cond_0
    move/from16 v11, p1

    .line 200
    .end local v1    # "sceneRoot":Landroid/view/ViewGroup;
    .local v12, "sceneRoot":Landroid/view/ViewGroup;
    :goto_0
    move-object v12, v1

    if-nez v12, :cond_1

    .line 201
    return-void

    .line 203
    :cond_1
    iget-object v13, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastIn:Landroid/support/v4/app/Fragment;

    .line 204
    .local v13, "inFragment":Landroid/support/v4/app/Fragment;
    iget-object v14, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOut:Landroid/support/v4/app/Fragment;

    .line 205
    .local v14, "outFragment":Landroid/support/v4/app/Fragment;
    iget-boolean v15, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInIsPop:Z

    .line 206
    .local v15, "inIsPop":Z
    iget-boolean v8, v9, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->firstOutIsPop:Z

    .line 208
    .local v8, "outIsPop":Z
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object v7, v1

    .line 209
    .local v7, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    move-object v6, v1

    .line 210
    .local v6, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    invoke-static {v13, v15}, Landroid/support/v4/app/FragmentTransition;->getEnterTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v5

    .line 211
    .local v5, "enterTransition":Ljava/lang/Object;
    invoke-static {v14, v8}, Landroid/support/v4/app/FragmentTransition;->getExitTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v4

    .line 213
    .local v4, "exitTransition":Ljava/lang/Object;
    move-object v1, v12

    move-object v2, v10

    move-object/from16 v3, p4

    move-object/from16 v23, v4

    move-object v4, v9

    .line 213
    .end local v4    # "exitTransition":Ljava/lang/Object;
    .local v23, "exitTransition":Ljava/lang/Object;
    move-object/from16 v24, v5

    move-object v5, v6

    .line 213
    .end local v5    # "enterTransition":Ljava/lang/Object;
    .local v24, "enterTransition":Ljava/lang/Object;
    move-object v0, v6

    move-object v6, v7

    .line 213
    .end local v6    # "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v0, "sharedElementsOut":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move-object v9, v7

    move-object/from16 v7, v24

    .line 213
    .end local v7    # "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local v9, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    move/from16 v25, v8

    move-object/from16 v8, v23

    .line 213
    .end local v8    # "outIsPop":Z
    .local v25, "outIsPop":Z
    invoke-static/range {v1 .. v8}, Landroid/support/v4/app/FragmentTransition;->configureSharedElementsReordered(Landroid/view/ViewGroup;Landroid/view/View;Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 217
    .local v1, "sharedElementTransition":Ljava/lang/Object;
    move-object/from16 v2, v24

    if-nez v2, :cond_2

    .line 217
    .end local v24    # "enterTransition":Ljava/lang/Object;
    .local v2, "enterTransition":Ljava/lang/Object;
    if-nez v1, :cond_2

    move-object/from16 v3, v23

    if-nez v3, :cond_3

    .line 219
    .end local v23    # "exitTransition":Ljava/lang/Object;
    .local v3, "exitTransition":Ljava/lang/Object;
    return-void

    .line 222
    .end local v3    # "exitTransition":Ljava/lang/Object;
    .restart local v23    # "exitTransition":Ljava/lang/Object;
    :cond_2
    move-object/from16 v3, v23

    .line 222
    .end local v23    # "exitTransition":Ljava/lang/Object;
    .restart local v3    # "exitTransition":Ljava/lang/Object;
    :cond_3
    invoke-static {v3, v14, v0, v10}, Landroid/support/v4/app/FragmentTransition;->configureEnteringExitingViews(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;

    move-result-object v4

    .line 225
    .local v4, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    invoke-static {v2, v13, v9, v10}, Landroid/support/v4/app/FragmentTransition;->configureEnteringExitingViews(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Landroid/view/View;)Ljava/util/ArrayList;

    move-result-object v5

    .line 228
    .local v5, "enteringViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    const/4 v6, 0x4

    invoke-static {v5, v6}, Landroid/support/v4/app/FragmentTransition;->setViewVisibility(Ljava/util/ArrayList;I)V

    .line 230
    invoke-static {v2, v3, v1, v13, v15}, Landroid/support/v4/app/FragmentTransition;->mergeTransitions(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;

    move-result-object v6

    .line 233
    .local v6, "transition":Ljava/lang/Object;
    if-eqz v6, :cond_4

    .line 234
    invoke-static {v3, v14, v4}, Landroid/support/v4/app/FragmentTransition;->replaceHide(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;)V

    .line 235
    nop

    .line 236
    invoke-static {v9}, Landroid/support/v4/app/FragmentTransitionCompat21;->prepareSetNameOverridesReordered(Ljava/util/ArrayList;)Ljava/util/ArrayList;

    move-result-object v7

    .line 237
    .local v7, "inNames":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    move-object/from16 v16, v6

    move-object/from16 v17, v2

    move-object/from16 v18, v5

    move-object/from16 v19, v3

    move-object/from16 v20, v4

    move-object/from16 v21, v1

    move-object/from16 v22, v9

    invoke-static/range {v16 .. v22}, Landroid/support/v4/app/FragmentTransitionCompat21;->scheduleRemoveTargets(Ljava/lang/Object;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V

    .line 240
    invoke-static {v12, v6}, Landroid/support/v4/app/FragmentTransitionCompat21;->beginDelayedTransition(Landroid/view/ViewGroup;Ljava/lang/Object;)V

    .line 241
    move-object/from16 v8, p4

    invoke-static {v12, v0, v9, v7, v8}, Landroid/support/v4/app/FragmentTransitionCompat21;->setNameOverridesReordered(Landroid/view/View;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/Map;)V

    .line 243
    move-object/from16 v26, v2

    const/4 v2, 0x0

    .line 243
    .end local v2    # "enterTransition":Ljava/lang/Object;
    .local v26, "enterTransition":Ljava/lang/Object;
    invoke-static {v5, v2}, Landroid/support/v4/app/FragmentTransition;->setViewVisibility(Ljava/util/ArrayList;I)V

    .line 244
    invoke-static {v1, v0, v9}, Landroid/support/v4/app/FragmentTransitionCompat21;->swapSharedElementTargets(Ljava/lang/Object;Ljava/util/ArrayList;Ljava/util/ArrayList;)V

    .line 244
    .end local v7    # "inNames":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    goto :goto_1

    .line 247
    .end local v26    # "enterTransition":Ljava/lang/Object;
    .restart local v2    # "enterTransition":Ljava/lang/Object;
    :cond_4
    move-object/from16 v8, p4

    move-object/from16 v26, v2

    .line 247
    .end local v2    # "enterTransition":Ljava/lang/Object;
    .restart local v26    # "enterTransition":Ljava/lang/Object;
    :goto_1
    return-void
.end method

.method private static ensureContainer(Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/util/SparseArray;I)Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .locals 1
    .param p0, "containerTransition"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p2, "containerId"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Landroid/util/SparseArray<",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            ">;I)",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;"
        }
    .end annotation

    .line 1134
    .local p1, "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    if-nez p0, :cond_0

    .line 1135
    new-instance v0, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    invoke-direct {v0}, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;-><init>()V

    move-object p0, v0

    .line 1136
    invoke-virtual {p1, p2, p0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1138
    :cond_0
    return-object p0
.end method

.method private static findKeyForValue(Landroid/support/v4/util/ArrayMap;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p1, "value"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 809
    .local p0, "map":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->size()I

    move-result v0

    .line 810
    .local v0, "numElements":I
    const/4 v1, 0x0

    .line 810
    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_1

    .line 811
    invoke-virtual {p0, v1}, Landroid/support/v4/util/ArrayMap;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 812
    invoke-virtual {p0, v1}, Landroid/support/v4/util/ArrayMap;->keyAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    return-object v2

    .line 810
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 815
    .end local v1    # "i":I
    :cond_1
    const/4 v1, 0x0

    return-object v1
.end method

.method private static getEnterTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;
    .locals 1
    .param p0, "inFragment"    # Landroid/support/v4/app/Fragment;
    .param p1, "isPop"    # Z
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .line 425
    if-nez p0, :cond_0

    .line 426
    const/4 v0, 0x0

    return-object v0

    .line 428
    :cond_0
    if-eqz p1, :cond_1

    .line 429
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getReenterTransition()Ljava/lang/Object;

    move-result-object v0

    goto :goto_0

    .line 430
    :cond_1
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getEnterTransition()Ljava/lang/Object;

    move-result-object v0

    .line 428
    :goto_0
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->cloneTransition(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method private static getExitTransition(Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;
    .locals 1
    .param p0, "outFragment"    # Landroid/support/v4/app/Fragment;
    .param p1, "isPop"    # Z
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .line 438
    if-nez p0, :cond_0

    .line 439
    const/4 v0, 0x0

    return-object v0

    .line 441
    :cond_0
    if-eqz p1, :cond_1

    .line 442
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getReturnTransition()Ljava/lang/Object;

    move-result-object v0

    goto :goto_0

    .line 443
    :cond_1
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getExitTransition()Ljava/lang/Object;

    move-result-object v0

    .line 441
    :goto_0
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->cloneTransition(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method private static getInEpicenterView(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Ljava/lang/Object;Z)Landroid/view/View;
    .locals 3
    .param p1, "fragments"    # Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    .param p2, "enterTransition"    # Ljava/lang/Object;
    .param p3, "inIsPop"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;",
            "Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;",
            "Ljava/lang/Object;",
            "Z)",
            "Landroid/view/View;"
        }
    .end annotation

    .line 830
    .local p0, "inSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    iget-object v0, p1, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;->lastInTransaction:Landroid/support/v4/app/BackStackRecord;

    .line 831
    .local v0, "inTransaction":Landroid/support/v4/app/BackStackRecord;
    if-eqz p2, :cond_1

    if-eqz p0, :cond_1

    iget-object v1, v0, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    if-eqz v1, :cond_1

    iget-object v1, v0, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 833
    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1

    .line 834
    const/4 v1, 0x0

    if-eqz p3, :cond_0

    iget-object v2, v0, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 835
    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    goto :goto_0

    :cond_0
    iget-object v2, v0, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 836
    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 837
    .local v1, "targetName":Ljava/lang/String;
    :goto_0
    invoke-virtual {p0, v1}, Landroid/support/v4/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    return-object v2

    .line 839
    .end local v1    # "targetName":Ljava/lang/String;
    :cond_1
    const/4 v1, 0x0

    return-object v1
.end method

.method private static getSharedElementTransition(Landroid/support/v4/app/Fragment;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;
    .locals 2
    .param p0, "inFragment"    # Landroid/support/v4/app/Fragment;
    .param p1, "outFragment"    # Landroid/support/v4/app/Fragment;
    .param p2, "isPop"    # Z
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .line 411
    if-eqz p0, :cond_2

    if-nez p1, :cond_0

    goto :goto_1

    .line 414
    :cond_0
    if-eqz p2, :cond_1

    .line 415
    invoke-virtual {p1}, Landroid/support/v4/app/Fragment;->getSharedElementReturnTransition()Ljava/lang/Object;

    move-result-object v0

    goto :goto_0

    .line 416
    :cond_1
    invoke-virtual {p0}, Landroid/support/v4/app/Fragment;->getSharedElementEnterTransition()Ljava/lang/Object;

    move-result-object v0

    .line 414
    :goto_0
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->cloneTransition(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 417
    .local v0, "transition":Ljava/lang/Object;
    invoke-static {v0}, Landroid/support/v4/app/FragmentTransitionCompat21;->wrapTransitionInSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    return-object v1

    .line 412
    .end local v0    # "transition":Ljava/lang/Object;
    :cond_2
    :goto_1
    const/4 v0, 0x0

    return-object v0
.end method

.method private static mergeTransitions(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/app/Fragment;Z)Ljava/lang/Object;
    .locals 2
    .param p0, "enterTransition"    # Ljava/lang/Object;
    .param p1, "exitTransition"    # Ljava/lang/Object;
    .param p2, "sharedElementTransition"    # Ljava/lang/Object;
    .param p3, "inFragment"    # Landroid/support/v4/app/Fragment;
    .param p4, "isPop"    # Z
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .line 958
    const/4 v0, 0x1

    .line 959
    .local v0, "overlap":Z
    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    if-eqz p3, :cond_1

    .line 960
    if-eqz p4, :cond_0

    invoke-virtual {p3}, Landroid/support/v4/app/Fragment;->getAllowReturnTransitionOverlap()Z

    move-result v1

    goto :goto_0

    .line 961
    :cond_0
    invoke-virtual {p3}, Landroid/support/v4/app/Fragment;->getAllowEnterTransitionOverlap()Z

    move-result v1

    :goto_0
    move v0, v1

    .line 969
    :cond_1
    if-eqz v0, :cond_2

    .line 971
    invoke-static {p1, p0, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->mergeTransitionsTogether(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 971
    .local v1, "transition":Ljava/lang/Object;
    goto :goto_1

    .line 976
    .end local v1    # "transition":Ljava/lang/Object;
    :cond_2
    invoke-static {p1, p0, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->mergeTransitionsInSequence(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 979
    .restart local v1    # "transition":Ljava/lang/Object;
    :goto_1
    return-object v1
.end method

.method private static replaceHide(Ljava/lang/Object;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;)V
    .locals 2
    .param p0, "exitTransition"    # Ljava/lang/Object;
    .param p1, "exitingFragment"    # Landroid/support/v4/app/Fragment;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Landroid/support/v4/app/Fragment;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 257
    .local p2, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    if-eqz p1, :cond_0

    if-eqz p0, :cond_0

    iget-boolean v0, p1, Landroid/support/v4/app/Fragment;->mAdded:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p1, Landroid/support/v4/app/Fragment;->mHidden:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p1, Landroid/support/v4/app/Fragment;->mHiddenChanged:Z

    if-eqz v0, :cond_0

    .line 259
    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/support/v4/app/Fragment;->setHideReplaced(Z)V

    .line 260
    nop

    .line 261
    invoke-virtual {p1}, Landroid/support/v4/app/Fragment;->getView()Landroid/view/View;

    move-result-object v0

    .line 260
    invoke-static {p0, v0, p2}, Landroid/support/v4/app/FragmentTransitionCompat21;->scheduleHideFragmentView(Ljava/lang/Object;Landroid/view/View;Ljava/util/ArrayList;)V

    .line 262
    iget-object v0, p1, Landroid/support/v4/app/Fragment;->mContainer:Landroid/view/ViewGroup;

    .line 263
    .local v0, "container":Landroid/view/ViewGroup;
    new-instance v1, Landroid/support/v4/app/FragmentTransition$1;

    invoke-direct {v1, p2}, Landroid/support/v4/app/FragmentTransition$1;-><init>(Ljava/util/ArrayList;)V

    invoke-static {v0, v1}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 270
    .end local v0    # "container":Landroid/view/ViewGroup;
    :cond_0
    return-void
.end method

.method private static retainValues(Landroid/support/v4/util/ArrayMap;Landroid/support/v4/util/ArrayMap;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 876
    .local p0, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    .local p1, "namedViews":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    invoke-virtual {p0}, Landroid/support/v4/util/ArrayMap;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .line 876
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_1

    .line 877
    invoke-virtual {p0, v0}, Landroid/support/v4/util/ArrayMap;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 878
    .local v1, "targetName":Ljava/lang/String;
    invoke-virtual {p1, v1}, Landroid/support/v4/util/ArrayMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 879
    invoke-virtual {p0, v0}, Landroid/support/v4/util/ArrayMap;->removeAt(I)Ljava/lang/Object;

    .line 876
    .end local v1    # "targetName":Ljava/lang/String;
    :cond_0
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 882
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method private static scheduleTargetChange(Landroid/view/ViewGroup;Landroid/support/v4/app/Fragment;Landroid/view/View;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;Ljava/lang/Object;Ljava/util/ArrayList;)V
    .locals 9
    .param p0, "sceneRoot"    # Landroid/view/ViewGroup;
    .param p1, "inFragment"    # Landroid/support/v4/app/Fragment;
    .param p2, "nonExistentView"    # Landroid/view/View;
    .param p4, "enterTransition"    # Ljava/lang/Object;
    .param p6, "exitTransition"    # Ljava/lang/Object;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/ViewGroup;",
            "Landroid/support/v4/app/Fragment;",
            "Landroid/view/View;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;",
            "Ljava/lang/Object;",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 371
    .local p3, "sharedElementsIn":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p5, "enteringViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    .local p7, "exitingViews":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    new-instance v8, Landroid/support/v4/app/FragmentTransition$2;

    move-object v0, v8

    move-object v1, p4

    move-object v2, p2

    move-object v3, p1

    move-object v4, p3

    move-object v5, p5

    move-object/from16 v6, p7

    move-object v7, p6

    invoke-direct/range {v0 .. v7}, Landroid/support/v4/app/FragmentTransition$2;-><init>(Ljava/lang/Object;Landroid/view/View;Landroid/support/v4/app/Fragment;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Object;)V

    move-object v0, p0

    invoke-static {v0, v8}, Landroid/support/v4/app/OneShotPreDrawListener;->add(Landroid/view/View;Ljava/lang/Runnable;)Landroid/support/v4/app/OneShotPreDrawListener;

    .line 394
    return-void
.end method

.method private static setOutEpicenter(Ljava/lang/Object;Ljava/lang/Object;Landroid/support/v4/util/ArrayMap;ZLandroid/support/v4/app/BackStackRecord;)V
    .locals 2
    .param p0, "sharedElementTransition"    # Ljava/lang/Object;
    .param p1, "exitTransition"    # Ljava/lang/Object;
    .param p3, "outIsPop"    # Z
    .param p4, "outTransaction"    # Landroid/support/v4/app/BackStackRecord;
    .annotation build Landroid/support/annotation/RequiresApi;
        value = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            "Landroid/support/v4/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;Z",
            "Landroid/support/v4/app/BackStackRecord;",
            ")V"
        }
    .end annotation

    .line 855
    .local p2, "outSharedElements":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Landroid/view/View;>;"
    iget-object v0, p4, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    if-eqz v0, :cond_1

    iget-object v0, p4, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 856
    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 857
    const/4 v0, 0x0

    if-eqz p3, :cond_0

    iget-object v1, p4, Landroid/support/v4/app/BackStackRecord;->mSharedElementTargetNames:Ljava/util/ArrayList;

    .line 858
    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    goto :goto_0

    :cond_0
    iget-object v1, p4, Landroid/support/v4/app/BackStackRecord;->mSharedElementSourceNames:Ljava/util/ArrayList;

    .line 859
    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 860
    .local v0, "sourceName":Ljava/lang/String;
    :goto_0
    invoke-virtual {p2, v0}, Landroid/support/v4/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 861
    .local v1, "outEpicenterView":Landroid/view/View;
    invoke-static {p0, v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->setEpicenter(Ljava/lang/Object;Landroid/view/View;)V

    .line 863
    if-eqz p1, :cond_1

    .line 864
    invoke-static {p1, v1}, Landroid/support/v4/app/FragmentTransitionCompat21;->setEpicenter(Ljava/lang/Object;Landroid/view/View;)V

    .line 867
    .end local v0    # "sourceName":Ljava/lang/String;
    .end local v1    # "outEpicenterView":Landroid/view/View;
    :cond_1
    return-void
.end method

.method private static setViewVisibility(Ljava/util/ArrayList;I)V
    .locals 2
    .param p1, "visibility"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;I)V"
        }
    .end annotation

    .line 941
    .local p0, "views":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/view/View;>;"
    if-nez p0, :cond_0

    .line 942
    return-void

    .line 944
    :cond_0
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .line 944
    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_1

    .line 945
    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 946
    .local v1, "view":Landroid/view/View;
    invoke-virtual {v1, p1}, Landroid/view/View;->setVisibility(I)V

    .line 944
    .end local v1    # "view":Landroid/view/View;
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 948
    .end local v0    # "i":I
    :cond_1
    return-void
.end method

.method static startTransitions(Landroid/support/v4/app/FragmentManagerImpl;Ljava/util/ArrayList;Ljava/util/ArrayList;IIZ)V
    .locals 7
    .param p0, "fragmentManager"    # Landroid/support/v4/app/FragmentManagerImpl;
    .param p3, "startIndex"    # I
    .param p4, "endIndex"    # I
    .param p5, "isReordered"    # Z
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/support/v4/app/FragmentManagerImpl;",
            "Ljava/util/ArrayList<",
            "Landroid/support/v4/app/BackStackRecord;",
            ">;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Boolean;",
            ">;IIZ)V"
        }
    .end annotation

    .line 86
    .local p1, "records":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/support/v4/app/BackStackRecord;>;"
    .local p2, "isRecordPop":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/Boolean;>;"
    iget v0, p0, Landroid/support/v4/app/FragmentManagerImpl;->mCurState:I

    const/4 v1, 0x1

    if-ge v0, v1, :cond_0

    .line 87
    return-void

    .line 90
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_4

    .line 91
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    .line 93
    .local v0, "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    move v1, p3

    .line 93
    .local v1, "i":I
    :goto_0
    if-ge v1, p4, :cond_2

    .line 94
    invoke-virtual {p1, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/support/v4/app/BackStackRecord;

    .line 95
    .local v2, "record":Landroid/support/v4/app/BackStackRecord;
    invoke-virtual {p2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Boolean;

    invoke-virtual {v3}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v3

    .line 96
    .local v3, "isPop":Z
    if-eqz v3, :cond_1

    .line 97
    invoke-static {v2, v0, p5}, Landroid/support/v4/app/FragmentTransition;->calculatePopFragments(Landroid/support/v4/app/BackStackRecord;Landroid/util/SparseArray;Z)V

    goto :goto_1

    .line 99
    :cond_1
    invoke-static {v2, v0, p5}, Landroid/support/v4/app/FragmentTransition;->calculateFragments(Landroid/support/v4/app/BackStackRecord;Landroid/util/SparseArray;Z)V

    .line 93
    .end local v2    # "record":Landroid/support/v4/app/BackStackRecord;
    .end local v3    # "isPop":Z
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 103
    .end local v1    # "i":I
    :cond_2
    invoke-virtual {v0}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-eqz v1, :cond_4

    .line 104
    new-instance v1, Landroid/view/View;

    iget-object v2, p0, Landroid/support/v4/app/FragmentManagerImpl;->mHost:Landroid/support/v4/app/FragmentHostCallback;

    invoke-virtual {v2}, Landroid/support/v4/app/FragmentHostCallback;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 105
    .local v1, "nonExistentView":Landroid/view/View;
    invoke-virtual {v0}, Landroid/util/SparseArray;->size()I

    move-result v2

    .line 106
    .local v2, "numContainers":I
    const/4 v3, 0x0

    .line 106
    .local v3, "i":I
    :goto_2
    if-ge v3, v2, :cond_4

    .line 107
    invoke-virtual {v0, v3}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v4

    .line 108
    .local v4, "containerId":I
    invoke-static {v4, p1, p2, p3, p4}, Landroid/support/v4/app/FragmentTransition;->calculateNameOverrides(ILjava/util/ArrayList;Ljava/util/ArrayList;II)Landroid/support/v4/util/ArrayMap;

    move-result-object v5

    .line 111
    .local v5, "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    nop

    .line 112
    invoke-virtual {v0, v3}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;

    .line 114
    .local v6, "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    if-eqz p5, :cond_3

    .line 115
    invoke-static {p0, v4, v6, v1, v5}, Landroid/support/v4/app/FragmentTransition;->configureTransitionsReordered(Landroid/support/v4/app/FragmentManagerImpl;ILandroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/view/View;Landroid/support/v4/util/ArrayMap;)V

    goto :goto_3

    .line 118
    :cond_3
    invoke-static {p0, v4, v6, v1, v5}, Landroid/support/v4/app/FragmentTransition;->configureTransitionsOrdered(Landroid/support/v4/app/FragmentManagerImpl;ILandroid/support/v4/app/FragmentTransition$FragmentContainerTransition;Landroid/view/View;Landroid/support/v4/util/ArrayMap;)V

    .line 106
    .end local v4    # "containerId":I
    .end local v5    # "nameOverrides":Landroid/support/v4/util/ArrayMap;, "Landroid/support/v4/util/ArrayMap<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v6    # "containerTransition":Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;
    :goto_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 124
    .end local v0    # "transitioningFragments":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/support/v4/app/FragmentTransition$FragmentContainerTransition;>;"
    .end local v1    # "nonExistentView":Landroid/view/View;
    .end local v2    # "numContainers":I
    .end local v3    # "i":I
    :cond_4
    return-void
.end method
