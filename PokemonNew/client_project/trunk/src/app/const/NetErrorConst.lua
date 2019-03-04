

--[[
所有的报错信息id 都往后加 不要再中间添加了 方便策划核对新加了哪几个报错
]]
local NetErrorConst = {
	RET_ERROR                     = 0  ,--悟空 你又调皮了
	RET_OK                        = 1  ,--1 正确返回 非1 错误返回
	RET_SERVER_MAINTAIN           = 2  ,--服务器维护
	RET_NO_FIND_USER              = 3  ,--玩家不存在
	RET_LOGIN_REPEAT              = 4  ,--重复登陆
	RET_USER_NAME_REPEAT          = 5  ,--创建角色时,玩家名字重复
	RET_CHAT_OUT_OF_LENGTH        = 6  ,-- 聊天 - 话太多
	RET_CHAT_CHAN_INEXISTENCE     = 7  ,-- 聊天 - 频道不存在
	RET_SERVER_USER_OVER_CEILING  = 8  ,--超过服务器上限
	RET_LOGIN_BAN_USER            = 9  ,--被封用户
	RET_SERVER_NO_OPEN            = 10 ,--服务器未开服
	RET_VERSION_ERR               = 11 ,--版本不一致
	RET_LOGIN_TOKEN_TIME_OUT      = 12 ,--登录超时
	RET_SERVER_BUSY               = 13 ,--服务器繁忙
	RET_LOCK_FAIL                 = 14 ,--不能重复请求
	RET_USER_OFFLINE              = 15 ,--玩家不在线
	RET_NO_FIND_USER_OR_OFFLINE   = 16 ,--玩家不存在或不在线
	RET_REPEATED_ORDER_ID         = 17 ,--重复订单
	RET_UUID_NOT_ACTIVATE         = 18 ,--账号未激活
	RET_STOP_REGISTER 			  = 19 ,--关闭注册

	RET_EQUIP_NOT_EXIST          = 1001 ,--装备信息不存在
	RET_FRAG_NOT_EXIST           = 1002 ,--碎片信息不存在
	RET_TREASURE_NOT_EXIST       = 1003 ,--宝物信息不存在
	RET_ITEM_NOT_EXIST           = 1004 ,--道具不存在
	RET_GEM_NOT_EXIST            = 1005 ,--宝石不存在
	RET_KNIGHT_NOT_EXIST         = 1006 ,--武将信息不存在
	RET_USER_CORP_NOT_EXIST      = 1007 ,--玩家没有军团
	RET_USER_BIBLE_NOT_EXIST     = 1008 ,--真经不存在
	RET_USER_SOURCE_NOT_EXIST    = 1009 ,--法器不存在
	RET_MONTHLY_CARD_NOT_EXIST   = 1010 ,--月卡信息不存在
	RET_FOOD_NOT_EXIST           = 1011 ,--神将升星材料不存在
	RET_FOOD_FRAGMENT_NOT_EXIST  = 1012 ,--神将升星材料碎片不存在
	RET_INSTRUMNET_NOT_EXIST     = 1013 ,--法宝不存在

	RET_CHAT_CONTENT_OUT_OF_LEN  = 1100 ,--聊天内容超出长度
	RET_CHAT_FORBID              = 1101 ,--禁止在该频道聊天
	RET_CHAT_HIGH_FREQUENCY      = 1102 ,--聊天太频繁

	RET_IS_NOT_UP_TO_LEVEL              = 2001 ,--主角等级不足
	RET_NOT_ENOUGH_MONEY                = 2002 ,--玩家銀兩不足
	RET_NOT_ENOUGH_GOLD                 = 2003 ,--黄金不足
	RET_NOT_ENOUGH_VIT                  = 2004 ,--体力不足
	RET_NOT_ENOUGH_SPIRIT               = 2005 ,--主角精力不足
	RET_NOT_ENOUGH_FRAG                 = 2006 ,--碎片不足
	RET_NOT_ENOUGH_ITEM                 = 2007 ,--道具数量不足
	RET_NOT_ENOUGH_GEM                  = 2008 ,--宝石数量不足
	RET_NOT_ENOUGH_VIP                  = 2009 ,--vip等级不足
	RET_NOT_ENOUGH_MANA                 = 2010 ,--法力不足
	RET_VIT_IS_FULL                     = 2011 ,--体力已满
	RET_SPIRIT_IS_FULL                  = 2012 ,--精力已满
	RET_NOT_ENOUGH_PRESTIGE             = 2013 ,--声望不足
	RET_NOT_ENOUGH_TOWER_RESOURCE       = 2014 ,--锁妖塔资源不足
	RET_NOT_ENOUGH_VIAGRA               = 2015 ,--围剿群妖丹药不足
	RET_NOT_ENOUGH_FRA_1                = 2016 ,--夺宝资源1不足
	RET_NOT_ENOUGH_FRA_2                = 2017 ,--夺宝资源2不足
	RET_NOT_ENOUGH_FRA_3                = 2018 ,--夺宝资源3不足
	RET_NOT_ENOUGH_MEDAL                = 2019 ,--修为不足
	RET_NOT_ENOUGH_TREASURE_REFINE_NUM  = 2020 ,--宝物进阶材料不足
	RET_NOT_ENOUGH_YUANQI               = 2021 ,--元气不足
	RET_NOT_ENOUGH_ARENA_HONOR          = 2022 ,--跨服竞技荣誉不足
	RET_NOT_ENOUGH_LOCK_STONE           = 2023 ,--锁星石不足
	RET_NOT_ENOUGH_SOUL                 = 2024 ,--将魂不足
	RET_NOT_ENOUGH_FOOD                 = 2025 ,--升星材料不足
	RET_NOT_ENOUGH_KNIGHT               = 2026 ,--武将数量不足
	RET_NOT_ENOUGH_EQUIP                = 2027 ,--装备数量不足
	RET_NOT_ENOUGH_INSTRUMENT           = 2028 ,--法宝数量不足
	RET_NOT_ENOUGH_JADE                 = 2029 ,--魂玉不足
	RET_NOT_ENOUGH_CARD                 = 2030 ,--同名卡不足

	RET_KNIGHT_BAG_FULL      = 3001 ,--卡牌背包满
	RET_EQUIP_BAG_FULL       = 3002 ,--装备背包满
	RET_ITEM_BAG_FULL        = 3003 ,--道具背包满
	RET_FRIEND_FULL_1        = 3004 ,-- 自己好友已满
	RET_FRIEND_FULL_2        = 3005 ,-- 对方好友已满
	RET_IS_NOT_FRIEND        = 3006 ,--非好友
	RET_HAS_BEEN_FRIEND      = 3007 ,-- 已经是好友
	RET_DAILY_GIFT_NUM_FULL  = 3008 ,--玩家今日领取体力次数已满
	RET_BLACKLIST_FULL       = 3009 ,--黑名单满
	RET_TREASURE_BAG_FULL    = 3010 ,--宝物背包满
	RET_IN_BLACKLIST         = 3011 ,--该玩家在你黑名单中

	RET_CHAPTERBOX_REWARDED           = 4001 ,--章节宝箱奖励已经领取
	RET_NOT_ENOUGH_CHAPTERBOX_STAR    = 4002 ,--章节宝箱星星数不够
	RET_CHAPTER_STAGE_WRONG_STAR      = 4003 ,--挑战错误的星数
	RET_CHAPTER_STAGE_NO_EXISTS_STAR  = 4004 ,--不存在的星数

	RET_EQUIP_REFINE_LEVEL_IS_MAX                          = 5000 ,--装备精炼等级已达上限
	RET_EQUIP_UNABLE_TO_UPGRADE                            = 5001 ,--装备无法升级
	RET_EQUIP_LEVEL_EXCEED_LIMIT                           = 5002 ,--装备强化等级超过限制
	RET_FRAG_SYNTHETIC_EQUIP_NOT_EXIST                     = 5003 ,--碎片合成的装备信息不存在
	RET_TREASURE_CANNOT_STRENGTH                           = 5004 ,--该宝物无法被强化
	RET_TREASURE_LEVEL_EXCEED_LIMIT                        = 5005 ,--宝物强化等级超过限制
	RET_TREASURE_UPGREADED                                 = 5006 ,--该宝物已被强化
	RET_TREASURE_IN_POSITION                               = 5007 ,--已装备宝物不可以被强化
	RET_ITEM_TYPE_INCORRECT                                = 5008 ,--道具类型错误
	RET_KNIGHT_CANNOT_UPGRADE_LEAD                         = 5009 ,--主将无法强化
	RET_KNIGHT_LEVEL_EXCEED_LEAD                           = 5010 ,--请提升主角等级
	RET_KNIGHT_LEAD_CANNOT_BE_UPGRADE                      = 5011 ,--主将不可用来强化
	RET_KNIGHT_BE_UPGRADE_REPEAT                           = 5012 ,--该武将已被强化
	RET_KNIGHT_FIGHT_CANNOT_BE_UPGRADE                     = 5013 ,--出阵武将不可被强化
	RET_KNIGHT_CANNOT_BE_ADVANCED                          = 5014 ,--武将不可升阶
	RET_KNIGHT_ADVANCED_LEVEL_EXCEED_LIMIT                 = 5015 ,--武将阶级已经达到最高等级
	RET_KNIGHT_LEVEL_NOT_REACH                             = 5016 ,--进阶武将等级需求不足
	RET_KNIGHT_ADVANCED_NOT_ENOUGH_NUM                     = 5017 ,--进阶消耗卡牌数量不对
	RET_KNIGHT_FIGHT_CANNOT_BE_QUALITY_UP                  = 5018 ,--出阵武将不可当作突破材料
	RET_KNIGHT_TRAINING_VALUE_EXCEED_LIMIT                 = 5019 ,--提升属性值均超过限制
	RET_KNIGHT_DESTINY_LEVEL_EXCEED_LIMIT                  = 5020 ,--不能超过最大天命等级
	RET_KNIGHT_ONETEAM                                     = 5021 ,--武将在阵位上
	RET_KNIGHT_INCORRECT_TEAM                              = 5022 ,--阵营类型错误
	RET_KNIGHT_INCORRECT_POS                               = 5023 ,--位置错误
	RET_KNIGHT_NOT_USE_LEAD_POS                            = 5024 ,--一号位只能放主角
	RET_TREASURE_REFINE_LEVEL_EXCEED_LIMIT                 = 5025 ,--宝物进阶等级超过限制
	RET_KNIGHT_STAR_MAX                                    = 5026 ,--武将星级已达上限
	RET_KNIGHT_STAR_UP_ITEM_NOT_ENOUGH                     = 5027 ,--武将升星道具不足
	RET_KNIGHT_XP_IS_FULL                                  = 5028 ,--武将经验已达上限
	RET_KNIGHT_QUALITY_IS_FULL                             = 5029 ,--品质已达最高
	RET_KNIGHT_LEVEL_NOT_ENOUGH                            = 5030 ,--武将等级不足
	RET_KNIGHT_IS_UNIQUE                                   = 5031 ,--武将不可以重复
	RET_INSTRUMENT_LEVEL_IS_MAX                            = 5032 ,--法宝等级不能大于主角等级
	RET_PK_CD                                              = 5033 ,--切磋CD中
	RET_BIBLE_RECEIVE_NOT_AWARD                            = 5034 ,--月光宝盒宝珠奖励未领取
	RET_MUST_GO_INTO_BATTLE                                = 5035 ,--必须是上阵武将
	RET_WRONG_TARGET                                       = 5036 ,--错误的目标
	RET_MATERIALS_QUALITY_ERROR                            = 5037 ,--材料品质不匹配
	RET_MATERIALS_HAVE_BEEN_UPGRADED                       = 5038 ,--该材料被强化过
	RET_INSTRUMENT_RANK_MAX                                = 5039 ,--法宝突破等级已达上限
	RET_INSTRUMENT_LEVEL_CAN_NOT_BIGGER_THAN_KNIGHT_LEVEL  = 5040 ,--法宝等级不能超过神将等级
	RET_INSTRUMNET_LEVEL_MAX                               = 5041 ,--法宝等级已达上限
	RET_GUIDE_ID_LESS_OLD                                  = 5042 ,--新手引导id不可回退
	RET_REFRESH_CD                                         = 5043 ,--刷新cd中

	RET_GEM_LEVEL_IS_TOP  = 6001 ,--寶石等級已封頂

	RET_WORLD_BOSS_NO_FIGHT_COUNT  = 7001 ,--没有挑战次数
	RET_WORLD_BOSS_IS_DEAD         = 7002 ,--魔界BOSS死了
	RET_CHAPTER_STAGE_NO_COUNT     = 7003 ,--没有挑战次数
	RET_WORLD_BOSS_ATTACK_COOL     = 7004 ,--CD冷却中

	RET_SHOP_BUY_COUNT_EXCEED_LIMIT  = 8001 ,--商店购买数量超过限制
	RET_SHOP_GOODS_ALREADY_BUYED     = 8002 ,--商店物品已经购买过了
	RET_SHOP_MAGIC_SHOP_EXPIRED      = 8003 ,--神秘商店已经过期失效了
	RET_SHOP_EXCEED_REFRESH_LIMIT    = 8004 ,--超过了商店手动刷新次数上限

	RET_SUBTITLE_SEND_TOO_FAST  = 8010 ,--发送弹幕过快
	RET_SUBTITLE_FORBID_SEND    = 8011 ,--弹幕禁言

	RET_BIAOCHE_EXCEED_SHIP_NUM    = 8020 ,--超过每日运镖次数
	RET_BIAOCHE_UPGRADE_FAILED     = 8021 ,--提升镖车品质失败
	RET_BIAOCHE_EXCEED_HELPED_NUM  = 8022 ,--超过每日邀请好友运镖次数
	RET_BIAOCHE_EXCEED_HELP_NUM    = 8023 ,--超过每日帮助好友护镖次数
	RET_BIAOCHE_NO_NEED_ROB_COOL   = 8024 ,--不用移除劫镖冷却
	RET_BIAOCHE_REFRESH_RUNOUT     = 8025 ,--刷新镖车次数用尽
	RET_BIAOCHE_REFRESH_INCOOL     = 8026 ,--刷新镖车冷却中
	RET_BIAOCHE_REFRESH_TIMEDOUT   = 8027 ,--刷新镖车超时请重试
	RET_BIAOCHE_EXCEED_ROB_NUM     = 8028 ,--超过劫镖次数上限
	RET_BIAOCHE_CANNOT_ROB_FRIEND  = 8029 ,--不能打劫好友
	RET_BIAOCHE_ROB_INCOOL         = 8030 ,--处于打劫冷却中
	RET_BIAOCHE_ALREADY_ROBED      = 8031 ,--打劫同一辆镖车次数过多
	RET_BIAOCHE_BIAOCHE_FINISHED   = 8032 ,--镖车已运完
	RET_BIAOCHE_EXCEED_ROBED_NUM   = 8033 ,--镖车被劫次数达到上限
	RET_BIAOCHE_IN_ROB_PROTECT     = 8034 ,--镖车正处于打劫保护期
	RET_BIAOCHE_SERVER_BUSY        = 8035 ,--服务器繁忙
	RET_BIAOCHE_ROB_FAILED         = 8036 ,--打劫中战斗失败

	RET_ARENA_RANK_NOT_REACH_20     = 9001 ,--该对手不可挑战
	RET_ARENA_RANK_LOCK             = 9002 ,--该对手正在被挑战
	RET_IS_NOT_UP_TO_RANK           = 9003 ,--历史最高排名未达到条件
	RET_ARENA_COOLING_TIME          = 9004 ,--挑战冷却时间中
	RET_ARENA_FIGHT_NUM_NOT_ENOUGH  = 9005 ,--挑战次数不足

	RET_DEVIL_NOTVAILD                  = 10000 ,--BOSS未激活
	RET_DEVIL_NOT_PUBLIC                = 10001 ,--BOSS未共享
	RET_DEVIL_NOT_FRIEND                = 10002 ,--不是好友
	RET_DEVIL_NOT_FOUND_EXPLOIT_REWARD  = 10003 ,--未找到功勋奖励

	RET_DAILY_DUNGEON_AWARD_ERROR        = 10004 ,--发奖出错
	RET_DAILY_DUNGEON_CLIENT_ERROR       = 10005 ,--客户端数据错误
	RET_DAILY_DUNGEON_IS_NOT_OPEN_LEVEL  = 10006 ,--未达到开放等级
	RET_DAILY_DUNGEON_IS_NOT_OPEN_TIME   = 10007 ,--不在活动开放时间段
	RET_DAILY_DUNGEON_NOT_ENOUGH_COUNT   = 10008 ,--挑战次数不足
	RET_DAILY_DUNGEON_BATTLE_DATA_ERROR  = 10009 ,--战斗数据出错

	RET_MAZE_EXPLORE_COUNT_UNENONGH    = 10010 ,--迷宫探索次数不足
	RET_MAZE_CHALLENGE_COUNT_UNENOUGH  = 10011 ,--迷宫挑战次数不足
	RET_MAZE_MOVE_COUNT_UNENOUGH       = 10012 ,--迷宫移动次数不足
	RET_MAZE_POS_VALUE_LEGAL           = 10013 ,--玩家位置非法
	RET_MAZE_REACH_MAX_PUR_EXPLORE     = 10014 ,--达到迷宫的最大购买探索次数

	RET_SERVER_ARENA_NO_OPEN  = 10015 ,--本服暂未开启跨服竞技
	RET_SERVER_ARENA_WEEKEND  = 10016 ,--当前正在结算中

	RET_STAR_COLOR_MAX  = 10017 ,--星宿已达最高品质

	RET_RICH_COUNT_UNENOUGH         = 10018 ,--大闹天宫次数不足
	RET_RICH_PLAY_END               = 10019 ,--大闹天宫玩法结束
	RET_RICH_POSITION_ERROR         = 10020 ,--大闹天宫当前位置错误
	RET_RICH_LEVEL_UNENOUGH         = 10021 ,--大闹天宫玩法等级不够
	RET_RICH_RUYI_DICE_ERROR        = 10022 ,--如意点数错误
	RET_RICH_RUYI_UNENOUGH          = 10023 ,--如意色子数不足
	RET_RICH_BATTLE_COUNT_UNENOUGH  = 10024 ,--大闹天宫生命次数不足
	RET_RICH_RAND_EVENT_NOT_END     = 10025 ,--大闹天宫的随机事件玩法未选择

	RET_SERVER_ARENA_REFRESH_NOT_ENOUGH  = 10026 ,--跨服竞技刷新次数已达上限

	RET_DAILY_TASK_AWARD_NOT_CONDITION  = 10027 ,--日常任务未达到奖励条件
	RET_DAILY_TASK_AWARD_NOT_REPEAT     = 10028 ,--日常任务不能重复奖励

	RET_PRE_FAIRYLAND_STAGE_NO_FINISHED  = 10031 ,--前一关卡没有通过
	RET_FAIRYLAND_STAGE_NO_COUNT         = 10032 ,--仙界副本没有挑战次数了
	RET_CHAPTER_NO_FINISHED              = 10033 ,--对应关卡没有通过

	RET_NO_ENOUGH_VIP_LEVEL          = 10034 ,--VIP等级不足
	RET_NOT_ENOUGH_VALUE_TO_RECEIVE  = 10035 ,--未达到领取条件
	RET_ALREADY_BUY_FUND_COIN        = 10036 ,--已购买过开服基金
	RET_BUY_FUND_COIN_TIME_ERR       = 10037 ,--购买时间错误
	RET_RECEIVE_TIME_ERR             = 10038 ,--领取时间已过
	RET_NOT_BUY_FUND_COIN            = 10039 ,--没有购买开服基金
	RET_ALREADY_RECEIVED             = 10040 ,--已领取

	RET_CITY_NOT_UP_LEVEL          = 10041 ,--巡逻城池的开放等级不够
	RET_CITY_PATROL_NOT_END        = 10042 ,--巡逻未结束
	RET_CITY_NOT_REPEAT_KNIGHT     = 10043 ,--巡逻不能派遣重复武将
	RET_CITY_NOT_FIND_CITY         = 10044 ,--无法找到城池
	RET_CITY_SPEEND_UNENOUGH       = 10045 ,--巡逻完成次数不足
	RET_CITY_IS_OCCUPY             = 10046 ,--城池已经攻克
	RET_CITY_NOT_SPEED_NOT_PATROL  = 10047 ,--不能加速未在巡逻中的城池
	RET_CITY_NOT_AWARD             = 10048 ,--巡逻未达到奖励条件
	RET_CITY_NOT_REPEATED_AWARD    = 10049 ,--巡逻奖励不能重复领取
	RET_CITY_NOT_FIND_REBEL        = 10050 ,--未找到暴动城池,或暴动已被镇压
	RET_CITY_MAX_LEVEL_NOT_UP      = 10051 ,--城池达到最高等级，无法升级
	RET_CITY_NOT_EXP_UNENOUGH      = 10052 ,--经验不足，无法升级

	RET_FOOD_EATED                       = 10053 ,--升星装备已穿上
	RET_ACHIEVEMENT_AWARD_NOT_CONDITION  = 10054 ,--成就未达到奖励条件
	RET_ACHIEVEMENT_AWARD_NOT_REPEAT     = 10055 ,--成就不能重复奖励

	RET_CA_AWARD_TIMENOT_REACH              = 10056 ,--可配置任务奖励领取时间未到
	RET_CA_AWARD_TIMES_EXCEED_LIMIT         = 10057 ,--可配置活动奖励次数超过限制
	RET_CA_AWARD_TIMES_EXCEED_SERVER_LIMIT  = 10058 ,--可配置活动全服奖励次数超过限制
	RET_CA_AWARD_ID_ERROR                   = 10059 ,--可配置活动奖励ID错误
	RET_CA_QUEST_IS_NOT_COMPLETE            = 10060 ,--可配置活动奖励不可领取
	RET_ITEM_TYPE_ERROR                     = 10061 ,--道具类型不对
	RET_NO_FIND_REPORT                      = 10062 ,--战报不存在
	RET_MAZE_REACH_MAX_PUR_ACTION_COUNT     = 10063 ,--挖宝购买行动力次数达到上限
	RET_SEND_MAIL_CD                        = 10064 ,--发送邮件太快

	RET_ACT_EXCHANGE_NUM_ERROR          = 10065 ,--兑换次数不能为0
	RET_USER_IN_FORBID_BATTLE_TIME      = 10066 ,--免战中
	RET_TREASURE_FRAGMENT_EXIST         = 10067 ,--已经有该碎片
	RET_TREASURE_NO_FRAGMENT            = 10068 ,--宝物至少有一个碎片才能抢夺
	RET_TREASURE_FRAGMENT_NOT_ENOUGH    = 10069 ,--对方碎片不多啦 给他留点吧
	RET_TREASURE_FRAGMENT_USER_IN_ROB   = 10070 ,--对方正在被其他玩家抢夺
	RET_TREASURE_FRAGMENT_USER_IN_BUSY  = 10071 ,--对方正忙呢
	RET_BATTLE_ERROR                    = 10072 ,--战斗出错
	RET_IS_NOT_UP_TO_LEVEL_OR_VIP       = 10073 ,--角色等级不足或者VIP等级不足

	RET_DAILY_DUNGEON_PRE_NOT_PASS  = 10074 ,--日常副本前置关卡未通关
	RET_DAILY_DUNGEON_CD_TIME       = 10075 ,--日常副本CD时间未到
	RET_DAILY_DUNGEON_NOT_OPEN      = 10076 ,--日常副本关卡未开启

	RET_GIFT_CODE_VERFITY_ERROR       = 10078 ,--礼包码校验码错误
	RET_GIFT_CODE_TIME_OVER           = 10079 ,--礼包码时间过期
	RET_GIFT_CODE_MISS_PARAM          = 10080 ,--礼包码缺少参数
	RET_GIFT_CODE_PARAM_ERROR         = 10081 ,--礼包码参数错误
	RET_GIFT_CODE_VILIAD_1            = 10082 ,--活动批次的礼包码失效
	RET_GIFT_CODE_VILIAD_2            = 10083 ,--礼包码已经失效
	RET_GIFT_CODE_NOT_EXIST           = 10084 ,--礼包码不存在
	RET_GIFT_CODE_ACTIVITY_TIME_OVER  = 10085 ,--礼包码活动过期
	RET_GIFT_CODE_OVER_USE_COUNT      = 10086 ,--礼包码超过使用次数
	RET_GIFT_CODE_CODE_ERROR          = 10087 ,--礼包码错误
	RET_GIFT_CODE_NOT_BAN_CODE        = 10088 ,--用户名非该码绑定用户
	RET_GIFT_CODE_FREQUENCY           = 10089 ,--用户礼包码兑换操作频繁
	RET_GIFT_CODE_NULL                = 10090 ,--礼包码参数为空
	RET_GIFT_CODE_AWARDED             = 10091 ,--礼包码已经领取过
	RET_GIFT_CODE_NET_OVERTIME        = 10092 ,--礼包码平台网络超时

	RET_BIBLE_HAS_READ  = 10093 ,--月光宝盒已经点亮

	RET_TOWER_BUFF_HAS_SELECTED  = 10094 ,--九重天buff已经选择过

	RET_SIGN_IN_ALREADY              = 10095 ,--不能重复签到
	RET_SIGN_IN_RECHARGE_NOT_ENOUGH  = 10096 ,--充值不足

	RET_SEVEN_DAYS_ACTIVITY_NOT_OPEN             = 10097 ,--不在活动时间内 无法领取奖励
	RET_SEVEN_DAYS_ACTIVITY_NOT_REACH_CONDITION  = 10098 ,--没有达到领奖条件
	RET_SEVEN_DAYS_ACTIVITY_NOT_REPEATED_AWARD   = 10099 ,--不能重复奖励
	RET_SEVEN_DAYS_ACTIVITY_GOD_UNENOUGH         = 10100 ,--物品数量不足
	RET_NOT_ENOUGH_RECRUIT_ZY_POINT              = 10101 ,--抽将阵营积分不够
	RET_USER_BEFORE_BIBLE_NOT_EXIST              = 10102 ,--前面的月光宝盒还未点亮

	RET_COMPENSATION_ALREADY_RECEIVE  = 10103 ,--今日补偿奖励已领取
	RET_COMPENSATION_CAN_NOT_RECEIVE  = 10104 ,--不能领取补偿奖励

	RET_CITY_PATROL_KNIGHT_UNENOUGH_CONDITION  = 10105 ,--巡逻将不满足巡逻条件
	RET_CITY_BEFORE_CITY_NOT_OCCUPY            = 10106 ,--前一个山脉没有占领
	RET_CITY_FRIEND_BUSY                       = 10107 ,--好友正忙
	RET_CITY_NOT_REPEATED_REPRESS              = 10108 ,--不能重复镇压好友的暴动
	RET_RESIGN_IN_ALREADY                      = 10109 ,--不可补签
	RET_CITY_RIOT_IS_REPRESS                   = 10110 ,--好友的暴动已经被镇压

	RET_GUILD_ALREADY_IN             = 10200 ,--玩家已经加入公会
	RET_GUILD_NAME_INVALID           = 10201 ,--公会名字非法
	RET_GUILD_NAME_REPEATED          = 10203 ,--公会名字已存在
	RET_GUILD_NOT_EXIST              = 10204 ,--公会不存在
	RET_GUILD_NOT_FOUND_APPLICATION  = 10205 ,--公会申请不存在
	RET_GUILD_NOT_ALLOWED_APPLY      = 10206 ,--不可申请入会
	RET_GUILD_MEMBER_NOT_EXIST       = 10207 ,--公会成员不存在
	RET_GUILD_NO_PERMISSIONS         = 10208 ,--公会成员权限不足
	RET_GUILD_NOT_DISMISS            = 10209 ,--无法解散公会
	RET_GUILD_ALREADY_IMPEACH        = 10210 ,--已有玩家发起弹劾
	RET_GUILD_SHOP_COUNT_NOT_ENOUGH  = 10211 ,--剩余数量不足

	RET_GUILD_NOT_IN_GUILD                   = 10300 ,--尚未加入公会
	RET_GUILD_SACRIFICE_RESOURCE_NOT_ENOUGH  = 10301 ,--祭祀所需资源不足
	RET_GUILD_GUILD_CONTRIBUTION_NOT_ENOUGH  = 10302 ,--公会贡献不足
	RET_GUILD_GUILD_SACRIFICE_NOT_ENOUGH     = 10303 ,--公会祭祀不足
	RET_GUILD_GUILD_SACRIFICE_AWARD_ALREADY  = 10304 ,--公会祭祀奖励已领取
	RET_GUILD_GUILD_LEVEL_NOT_ENOUGH         = 10305 ,--公会等级不足
	RET_GUILD_GUILD_SKILL_LEVEL_ENOUGH       = 10306 ,--公会技能等级达到上限
	RET_GUILD_GUILD_SACRIFICE_ALREADY        = 10307 ,--今日已经祭祀

	RET_REBATE_NOT_OPEN_TIME       = 10400 ,--不在充值返利活动期间
	RET_REBATE_NOT_REPEATED_AWARD  = 10401 ,--不在重复领奖
	RET_REBATE_NOT_FIND_USER       = 10402 ,--找不到玩家信息

	RET_RANDOM_ACTIVITY_BUY_COUNT_NOT_ENOUGH      = 10500 ,--购买次数不足
	RET_RANDOM_ACTIVITY_HAS_RECEIVE_SCORE_REWARD  = 10501 ,--已经领取奖励
	RET_RANDOM_ACTIVITY_GOOD_HAS_BUY              = 10502 ,--已经购买该商品
	RET_RECHARGE_HAS_RECEIVE_FIRST_CHARGE         = 10503 ,--已经领取过首冲奖励

	RET_ACTIVITY_OPEN_LOGIN_HAS_RECEIVE  = 10600 ,--已经领取奖励
}
return NetErrorConst
