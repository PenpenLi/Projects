--
-- Author: Yutou
-- Date: 2017-02-13 18:32:42
--
local BattleAttackOrderIcon = class("BattleAttackOrderIcon",function()
	return ccui.Layout:create()
end)

BattleAttackOrderIcon.TYPE_NORMAL = 1--
BattleAttackOrderIcon.TYPE_SMALL_ENEMY = 2--缩略图敌人
BattleAttackOrderIcon.TYPE_SMALL_MY = 3--缩略图自己的阵容

function BattleAttackOrderIcon:ctor(type)
	-- body
	self._type = type == nil and BattleAttackOrderIcon.TYPE_NORMAL or type

	local csbNode = cc.CSLoader:createNode("csb/team/lineup/FormationOrder.csb")
	self._csbNode = csbNode
	self._csbNode:addTo(self)

	self._bg = self._csbNode:getChildByName("num_bg_1")
	
	self._csbNode:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2)

	self:setContentSize(self._bg:getContentSize())
	self:setAnchorPoint(0.5,0.5)
end

return BattleAttackOrderIcon