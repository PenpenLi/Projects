--ItemConst.lua

--[====================[
	道具ID常量定义
]====================]

local ItemConst = {
    
    --特殊道具ID 常量定义
	ZHAN_JIANG_LING_ID = 1,    	           --战将令
	SHEN_JIANG_LING_ID = 2,    	           --神将令
    JIAO_YAO_LING_ID = 4,                  --降妖令

    SHEN_XIN_SHI_ID = 301,                  --升星石

    ZHAO_XIAN_LING_ID = 701,                  --招贤令
    SS_ZHAO_JIANG_LING_ID = 702,              --史诗级招将令
	CS_ZHAO_JIANG_LING_ID = 703, 		       --传说级招将令
    SHUA_XIN_LING_ID = 704,                  --刷新令
    YING_XIONG_LING_ID = 705,                  --英雄令
    ESSENCE_FASHION = 708,                  --时装精华
    SS_SHEN_QI_LING = 722,                  --史诗神器令
    CS_SHEN_QI_LING = 723,                  --传说神器令

    ITEM_NV_WA_SHI = 11,                   -- 女娲石

    MIANZHAN_SMALL_ID = 7,  	           --免战牌小
    MIANZHAN_BIG_ID = 8,  		           --免战牌大

	JING_LI_DAN_ID = 105,		           --精力丹
    TI_LI_DAN_ID = 101,			           --体力丹
    SILVER_SMALL_ID = 102,                  --小银两包
    SILVER_MIDDLE_ID = 103,                 --中银两包
    SILVER_BIG_ID = 104,                    --大银两包

    TREASURE_REFINE_ITEM_ID =  1101,        --宝物精炼石
    HORSE_REFINE_ITEM_ID =  1102,        --符印精炼石

    TREASURE_TYPE_ATTACK_ID =  103,        --默认获取的攻击宝物
    TREASURE_TYPE_DEFANCE_ID = 101,        --默认获取的防御宝物
    TREASURE_TYPE_LOW_EXP_ID = 1,          --初级经验宝物ID


    --特殊道具item_type类型 常量定义
    ITEM_TYPE_GIFTBAG = 1,            --礼包类型道具  需要显示礼包预览的
    ITEM_TYPE_RANDOM_GIFTBAG = 6,     --随机礼包类型道具 
    ITEM_TYPE_INS_MATERIAL = 17,      --法宝升级材料类型道具

    ITEM_TYPE_PAPER = 20,             --图纸类型道具
    ITEM_TYPE_GEM = 21,               --宝石类型道具
    ITEM_TYPE_SELECT_BOX = 23,        --N选1类型道具
    ITEM_TYPE_INSTRUMENT_FRAGMENT = 24,        --法宝碎片

    -- suNSun start
    FATE_STONE = 401,                        --天命石

    ITEM_SPATE = 1201,                        --洛阳铲
}

return ItemConst