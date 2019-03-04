--
-- Author: yutou
-- Date: 2019-01-15 15:51:51
--
local KnightImg = require("app.common.KnightImg")
local ShaderUtils = require("app.common.ShaderUtils")
local SchedulerHelper = require "app.common.SchedulerHelper"
local SoulPossessionEnemy=class("SoulPossessionEnemy",function()
	return display.newNode()
end)

function SoulPossessionEnemy:ctor(data)
	self:enableNodeEvents()

	self:_init()
	if data then
		self:update(data)
	end
end

function SoulPossessionEnemy:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("SoulPossessionEnemyNode","soulPossession"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)
	
	self._name = self._csbNode:getSubNodeByName("Text_name")
	self._node_con = self._csbNode:getSubNodeByName("Node_con")
	self._node_info = self._csbNode:getSubNodeByName("Node_info")
	self._sprite_dead = self._csbNode:getSubNodeByName("Button_dead")
	self._base = self._csbNode:getSubNodeByName("base_4")
	self._sprite_dead:addClickEventListenerEx(function()
		G_Popup.tip(G_Lang.get("soul_has_finish"))
	end)
end

function SoulPossessionEnemy:update(data)
	self._data = data
	self:render()
end

function SoulPossessionEnemy:render()
	-- self._name:setString(self._data.monster_name)
	local knight = nil
	if self._knight == nil then
		knight = KnightImg.new(self._data.knight)
		self._knight = knight
		self._node_con:addChild(knight)
	end
	local knight = self._knight
	local state = G_Me.soulPossessionData:getState(self._data.position)
	if state == 0 then
		self._sprite_dead:setVisible(false)
		self._node_info:setVisible(true)
	elseif state == 1 then
		self._sprite_dead:setVisible(true)
		self._node_info:setVisible(false)
	elseif state == 2 then
		self._sprite_dead:setVisible(false)
		self._node_info:setVisible(true)
	end

	local canAttack = G_Me.soulPossessionData:canAttack(self._data.position)
	if canAttack == 1 then
		knight:setTouchEnabled(true)
		ShaderUtils.removeFilter(knight)
		knight:addClickEventListenerEx(function()
			uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_SOUL_ENEMY, nil, false,self._data)
		end)
	else
		local scheduleHandler = SchedulerHelper.newScheduleOnce(function()
			ShaderUtils.applyGrayFilter(knight)
		end, 0)
		knight:addClickEventListenerEx(function()
			G_Popup.tip(G_Lang.get("soul_has_finish2"))
		end)
		if canAttack == -1 then
			knight:setTouchEnabled(true)
		else
			knight:setTouchEnabled(false)
		end
		-- knight:setTouchEnabled(false)
	end
	
	self._csbNode:updateLabel("Text_name", {text = self._data.monster_name,
	textColor = G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(self._data.quality),true),
	outlineColor = G_Colors.qualityColor2OutlineColor(G_TypeConverter.quality2Color(self._data.quality)),outlineSize = 2})

	if self._data.position == 6 then
		self:setScale(0.9)
		self._base:setScale(1)
	else
		self:setScale(0.75)
		self._base:setScale(0.9)
	end
end

function SoulPossessionEnemy:onEnter()

end

function SoulPossessionEnemy:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function SoulPossessionEnemy:onCleanup()
	
end


return SoulPossessionEnemy