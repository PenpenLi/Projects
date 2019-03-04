-- Author: wyx
-- Date: 2018-04-23 19:40:09
--
local StageMonsterItem=class("StageMonsterItem",function()
	return display.newNode()
end)

local MissionChallengePopupLayout = require("app.scenes.guild.mission.pop.MissionChallengePopupLayout")
local ShaderUtils =  require("app.common.ShaderUtils")

StageMonsterItem.NORMAL_SCALE = 0.5
StageMonsterItem.SELECT_SCALE = 0.55

function StageMonsterItem:ctor()
	self:enableNodeEvents()
	self._data = nil
	self._isFresh = false
end

function StageMonsterItem:onEnter()
	self:_initUI()
end

function StageMonsterItem:onExit()
	if self._csbNode ~= nil then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
end

function StageMonsterItem:_initUI()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("StageMonsterNode", "guild/mission"))
	self:addChild(self._csbNode)
	self._hpBar = self._csbNode:getSubNodeByName("LoadingBar_hp")
	self._deadNode = self._csbNode:getSubNodeByName("Node_dead")
	self._deadNode:setVisible(false)
end

function StageMonsterItem:setMonsterScale(scale)
	self:setScale(1.3)
end

function StageMonsterItem:update(data)
	if not data then
		return
	end

	self._data = data
	if not self._isFresh then
		self._isFresh = true
		self:_renderUI()
	else
		self:_freshHp()
	end
end

function StageMonsterItem:_renderUI()
	local cfg = self._data:getCfg()
	local color = G_TypeConverter.quality2Color(cfg.quality)

	--shape
	local knight_root = self._csbNode:getSubNodeByName("Node_knight")
	local knight = require("app.common.KnightImg").new(cfg.knight_id,cfg.star,cfg.exclusive_figure):addTo(knight_root)
			:setScale(0.5)
			:setPositionY(-10)
			:setTouchEnabled(true)
	self._knight = knight
	knight:addTouchEventListenerEx(function (sender, eventType)
		if eventType == ccui.TouchEventType.began then
          sender:setScale(StageMonsterItem.SELECT_SCALE)
      	elseif eventType == ccui.TouchEventType.ended then
          	local moveOffset=math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
          	sender:setScale(StageMonsterItem.NORMAL_SCALE)
          	if moveOffset<= 20 then
          		G_Popup.newPopup(
            	function ()
	            	local popup = MissionChallengePopupLayout.new()
	            	popup:setupInfo(self._data)
            		return popup
        		end)
          	end
      	elseif eventType == ccui.TouchEventType.canceled then
      	  sender:setScale(StageMonsterItem.NORMAL_SCALE)
      	end
	end)

	--name
	self._csbNode:updateLabel("Text_knight_name", {
		text = cfg.stage_name,
		textColor = G_Colors.qualityColor2Color(color,true),
		outlineColor = G_Colors.qualityColor2OutlineColor(color)
		})
	--point word
	-- self._csbNode:updateLabel("Text_point_word", {
	-- 	text = cfg.point_word,
	-- 	textColor = G_Colors.getColor(24),
	-- 	outlineColor = G_Colors.getOutlineColor(26),
	-- 	})

	self:_freshHp()
end


function StageMonsterItem:_freshHp()
	local per = self._data:getHpPercent()
	if per == 0 then
		self:_setDead()
	end
	self._hpBar:setPercent(per)
end

function StageMonsterItem:_setDead()
	ShaderUtils.applyGrayFilter(self._knight)
	self._knight:setTouchEnabled(false)
	self._deadNode:setVisible(true)
	local quality = self._data:getKillerQuality()
	print("StageMonsterItem:_setDead,killer quality:",quality)

	local color = G_TypeConverter.quality2Color(self._data:getKillerQuality())
	self._deadNode:updateLabel("Text_killer", {
		text = self._data:getKiller(),
		textColor = G_Colors.qualityColor2Color(color,true),
		outlineColor = G_Colors.qualityColor2OutlineColor(color)
		})
end

return StageMonsterItem