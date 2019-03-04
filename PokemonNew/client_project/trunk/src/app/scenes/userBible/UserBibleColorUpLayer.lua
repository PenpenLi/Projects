
---主角升品动画界面

local TeamTMLevelUPResultLayer = require "app.scenes.team.TeamTMLevelUPResultLayer"
local UserBibleColorUpLayer = class("UserBibleColorUpLayer", TeamTMLevelUPResultLayer)
local KnightInfo = require "app.cfg.knight_info"
-- local KnightRankInfo = require("app.cfg.knight_rank_info")

function UserBibleColorUpLayer:ctor(onClose)
	local knightData = G_Me.teamData:getKnightDataByPos(1) ---获取玩家的武将信息
	local id = knightData.serverData.id
	UserBibleColorUpLayer.super.ctor(self, id, onClose)
	self._preKnightId = knightData.cfgData.knight_id - 1
	self._currentKnightId = knightData.cfgData.knight_id
	self._currentKnightRankLv = knightData.serverData.knightRank ---当前玩家突破等级
end

function UserBibleColorUpLayer:_getTitleImageUrl()
	return G_Url:getText_system("txt_com_settl_core03")
end

function UserBibleColorUpLayer:_getBgImageUrl()
	return G_Url:getUI_background("bg_practice")
end

function UserBibleColorUpLayer:_getBotNode()
	return require("app.scenes.userBible.UserBibleColorUpBotLayer").new(self._id)
end


function UserBibleColorUpLayer:_updateCurTitle(label)
	self:_updateTitle(label, self._preKnightId)
end

function UserBibleColorUpLayer:_updateNextTitle(label)
	self:_updateTitle(label, self._currentKnightId)
end

function UserBibleColorUpLayer:_updateTitle(label, knightId)
	local knigthInfo = KnightInfo.get(knightId)
	-- local rankInfo = KnightRankInfo.get(knightId, knigthInfo.base_rank)

	local rankStr = self._currentKnightRankLv == 0 and "" or " +" .. tostring(self._currentKnightRankLv)
	label:setString(G_Me.userData.name .. rankStr)
	label:setColor(G_ColorsScrap.getColor(knigthInfo.color))
	label:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
end

return UserBibleColorUpLayer