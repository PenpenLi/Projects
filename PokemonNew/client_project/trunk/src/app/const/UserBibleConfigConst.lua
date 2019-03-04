local UserBibleConfigConst = class("UserBibleConfigConst")

----
--月光宝盒静态数据
----

---主线碎片
UserBibleConfigConst.MIAN_GROWTH = 0
--支线碎片
UserBibleConfigConst.EXTRA_GROWTH = 1

---------------
----珠宝icon值对应的特效配置
---------------
UserBibleConfigConst.BALL_EFFECTS = {}
UserBibleConfigConst.BALL_EFFECTS[1] = "effect_moonbox_redball"
UserBibleConfigConst.BALL_EFFECTS[2] = "effect_moonbox_greenball"
UserBibleConfigConst.BALL_EFFECTS[3] = "effect_moonbox_purpleball"
UserBibleConfigConst.BALL_EFFECTS[4] = "effect_moonbox_yellowball"
UserBibleConfigConst.BALL_EFFECTS[5] = "effect_moonbox_blueball"

-----------奖励种类
UserBibleConfigConst.REWARD_NOTHING = 0
UserBibleConfigConst.REWARD_DROP = 9
UserBibleConfigConst.REWARD_KNIGHT = 7
UserBibleConfigConst.REWARD_MULTY = 101
UserBibleConfigConst.REWARD_HERO_UPGREATE = 102

-------------领取限制类型
UserBibleConfigConst.LIMIT_NOTHING = 0
UserBibleConfigConst.LIMIT_LEVEL = 1

-------------领取状态
UserBibleConfigConst.NOT_GOT = 1
UserBibleConfigConst.BEEN_GOT = 2

return UserBibleConfigConst