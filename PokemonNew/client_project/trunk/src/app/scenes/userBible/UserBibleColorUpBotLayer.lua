

local TeamTMResultBot = require "app.scenes.team.TeamTMResultBot"
local UserBibleColorUpBotLayer = class("UserBibleColorUpBotLayer", TeamTMResultBot)
local KnightInfo = require "app.cfg.knight_info"
-- local KnightRankInfo = require("app.cfg.knight_rank_info")

function UserBibleColorUpBotLayer:ctor(knightId)
	UserBibleColorUpBotLayer.super.ctor(self, knightId)

	local knightData = G_Me.teamData:getKnightDataByPos(1) ---获取玩家的武将信息
	self._preKnightId = knightData.cfgData.knight_id - 1
	self._currentKnightId = knightData.cfgData.knight_id
	self._currentKnightRankLv = knightData.serverData.knightRank ---当前玩家突破等级
end

function UserBibleColorUpBotLayer:_updateLeftAtriLabels(csbNode)
	self:_initProperties(csbNode, self._preKnightId)
end

function UserBibleColorUpBotLayer:_updateRightAtriLabels(csbNode)
	self:_initProperties(csbNode, self._currentKnightId)
end

---更新一个节点英雄属性显示
function UserBibleColorUpBotLayer:_initProperties(node, knightId)
	local knigthInfo = KnightInfo.get(knightId)
	-- local rankInfo = KnightRankInfo.get(knightId, knigthInfo.base_rank)

	-- node:getSubNodeByName("Text_hp"):updateTxtValue(rankInfo.base_hp)
	-- node:getSubNodeByName("Text_atk"):updateTxtValue(rankInfo.base_attack)
	-- node:getSubNodeByName("Text_def"):updateTxtValue(rankInfo.base_defense)
	node:updateLabel("Text_title_hp", G_LangScrap.get("userbible_hp_up"))
	node:updateLabel("Text_title_atk", G_LangScrap.get("userbible_atk_up"))
	node:updateLabel("Text_title_def", G_LangScrap.get("userbible_def_up"))
end

function UserBibleColorUpBotLayer:_updateAddAtriLabels(csbNode)
	self:_initNewColorNode(csbNode)
end

--更新一个节点的新英雄属性显示
function UserBibleColorUpBotLayer:_initNewColorNode(node)
	local knigthPreInfo = KnightInfo.get(self._preKnightId)
	local rankPreInfo = KnightRankInfo.get(self._preKnightId, knigthPreInfo.base_rank)
	local knigthInfo = KnightInfo.get(self._currentKnightId)
	local rankInfo = KnightRankInfo.get(self._currentKnightId, knigthInfo.base_rank)

	local numDevelopHp = rankInfo.base_hp - rankPreInfo.base_hp
	local numDevelopAtk = rankInfo.base_attack - rankPreInfo.base_attack
	local numDevelopDef = rankInfo.base_defense - rankPreInfo.base_defense

	node:getSubNodeByName("Text_hp"):updateTxtValue(numDevelopHp)
	node:getSubNodeByName("Text_atk"):updateTxtValue(numDevelopAtk)
	node:getSubNodeByName("Text_def"):updateTxtValue(numDevelopDef)
end

return UserBibleColorUpBotLayer