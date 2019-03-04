local RecruitingConfigConst = class("RecruitingConfigConst")

-----------
---招募的静态常量
-----------

---普通招募令ID
RecruitingConfigConst.NORMAL_PROP_ID = 701

---极品招募令ID
RecruitingConfigConst.SS_PROP_ID = 702 --史诗级
RecruitingConfigConst.CS_PROP_ID = 703 --传说级
RecruitingConfigConst.SS_EQUIP_ID = 722 --史诗级
RecruitingConfigConst.CS_EQUIP_ID = 723 --传说级

RecruitingConfigConst.ZY_PROP_ID = 16


---招募时，与服务器通信使用的配置
RecruitingConfigConst.TYPE_FREE = 0

RecruitingConfigConst.TYPE_PROP = 1

RecruitingConfigConst.TYPE_GOLD = 2


---招募消耗，对应参数表里的价格
RecruitingConfigConst.PARAM_KEY_JP = 100 --1

RecruitingConfigConst.PARAM_KEY_JP_TEN = 101 --2

RecruitingConfigConst.PARAM_KEY_JP_TW = 3

RecruitingConfigConst.PARAM_KEY_ZY_ONE = 124

RecruitingConfigConst.PARAM_KEY_ZY_TEN = 125

RecruitingConfigConst.PARAM_KEY_ZY_ONE_PROP = 167

RecruitingConfigConst.PARAM_KEY_ZY_TEN_PROP = 168

---良品招募的每天可以免费的次数
RecruitingConfigConst.NORMAL_FREE_TIMES_PER_DAY = 3

---极品品招募的每天可以免费的次数
RecruitingConfigConst.JP_FREE_TIMES_PER_DAY = 1

---消耗增量ID
RecruitingConfigConst.FUNCTION_COST_ID = 10312

---每天0点重置
RecruitingConfigConst.JP_RESET_TIME = 0

--极品十抽一轮回
RecruitingConfigConst.THE_JP_ROUND_TIME = 10

---单个阵容招募的类型
RecruitingConfigConst.ZY_XIAN_SINGLE_TYPE = 51
RecruitingConfigConst.ZY_REN_SINGLE_TYPE = 52
RecruitingConfigConst.ZY_YAO_SINGLE_TYPE = 53

---多个阵容招募的类型
RecruitingConfigConst.ZY_XIAN_MULTI_TYPE = 61
RecruitingConfigConst.ZY_REN_MULTI_TYPE = 62
RecruitingConfigConst.ZY_YAO_MULTI_TYPE = 63

return RecruitingConfigConst