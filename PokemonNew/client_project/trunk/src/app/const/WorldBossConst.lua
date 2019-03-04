

----==========
----世界boss的静态常量
----==========
local WorldBossConst = {}

WorldBossConst.CANATTACK = 1 -- 开启且可以攻击Boss

WorldBossConst.ALIVEPASS = 2 -- 时间结束但没打过
WorldBossConst.DEADNORMAL = 3 -- 死亡没升级
WorldBossConst.DEADLEVELUP = 4 -- 死亡但是升级
WorldBossConst.FIRSTBOSS = 5 -- 第一次打世界Boss

return WorldBossConst