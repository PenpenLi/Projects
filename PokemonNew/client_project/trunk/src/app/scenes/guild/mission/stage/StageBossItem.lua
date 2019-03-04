-- Author: wyx
-- Date: 2018-04-23 19:40:09
--
local StageBossItem=class("StageBossItem",function()
	return display.newNode()
end)
local MissionChallengePopupLayout = require("app.scenes.guild.mission.pop.MissionChallengePopupLayout")
local ShaderUtils =  require("app.common.ShaderUtils")

StageBossItem.NORMAL_SCALE = 1
StageBossItem.SELECT_SCALE = 1.1

function StageBossItem:ctor()
	self:enableNodeEvents()
	self._isFresh = false
end

function StageBossItem:onEnter()
	self:_initUI()
end

function StageBossItem:onExit()
	if self._csbNode ~= nil then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
end

function StageBossItem:_initUI()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("StageBossNode", "guild/mission"))
	self:addChild(self._csbNode)
	self._bossNode = self._csbNode:getSubNodeByName("Node_boss")
	self._hpBar = self._csbNode:getSubNodeByName("LoadingBar_hp")
	self._imgDead = self._csbNode:updateImageView("Image_dead", {visible = false})
	self._touchPanel = self._csbNode:getSubNodeByName("Panel_touch")
	self._touchPanel:setTouchEnabled(false)
	self._touchPanel:setSwallowTouches(false)
	self._touchPanel:addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.began then
          self:setScale(StageBossItem.SELECT_SCALE)
      	elseif eventType == ccui.TouchEventType.ended then
          	local moveOffset=math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
          	self:setScale(StageBossItem.NORMAL_SCALE)
          	if moveOffset<= 20 then
          		G_Popup.newPopup(
            	function ()
	            	local popup = MissionChallengePopupLayout.new()
	            	popup:setupInfo(self._data)
            		return popup
        		end)
          	end
      	elseif eventType == ccui.TouchEventType.canceled then
      	  	self:setScale(StageBossItem.NORMAL_SCALE)
      	end
    end)
end

function StageBossItem:update(data)
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

function StageBossItem:_renderUI()
	local boss = require ("app.effect.EffectNode").new("effect_taotie_ready")
	boss:setScale(0.4)
	self._bossEffect = boss
    boss:play()
    self._bossNode:addChild(boss)
    self:_freshHp()
end

function StageBossItem:_freshHp()
	local per = self._data:getHpPercent()
	if per == 0 then
		self:_setDead()
	end
	self._hpBar:setPercent(per)
end

function StageBossItem:_setDead()
	ShaderUtils.applyGrayFilter(self._bossEffect)
	self._touchPanel:setTouchEnabled(false)
	self._imgDead:setVisible(true)
end

return StageBossItem