

----==========
----炼化台的静态常量
----==========
local GuildBattleConst = {}

-- CITY_BEFORE_START_SECTION           uint32 = 1 //城池关闭阶段(战斗前)
	-- CITY_REGISTER_TEAM_SECTION          uint32 = 2 //帮派注册
	-- CITY_GUILD_MEMBER_JOIN_TEAM_SECTION uint32 = 3 //成员参战
	-- CITY_FIGHT_ONE_ROUND_SECTION        uint32 = 4 //第一回合战斗
	-- CITY_FIGHT_TWO_ROUND_SECTION        uint32 = 5 //第二回合战斗
	-- CITY_FIGHT_TWO_ROUND_SECTION        uint32 = 6 //第二回合战斗
	-- CITY_AFTER_START_SECTION            uint32 = 7 //城池关闭阶段(战斗后)
	-- CITY_FIGHT_ABNORMAL_SECTION         uint32 = 8 //系统异常状态
	-- CITY_FIGHT_PREPARE_FIGHT_SECTION    uint32 = 9 //战斗准备状态

GuildBattleConst.BEFORE_START = 1
GuildBattleConst.REGISTER_TEAM = 2
GuildBattleConst.MEMBER_JOIN_TEAM = 3
GuildBattleConst.FIGHT_ROUND_1 = 4
GuildBattleConst.FIGHT_ROUND_2 = 5
GuildBattleConst.FIGHT_ROUND_3 = 6
GuildBattleConst.AFTER_START = 7
GuildBattleConst.ABNORMAL = 8
GuildBattleConst.PREPARE_FIGHT = 9

return GuildBattleConst