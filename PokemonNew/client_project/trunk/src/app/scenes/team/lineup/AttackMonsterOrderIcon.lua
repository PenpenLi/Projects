--
-- Author: Your Name
-- Date: 2017-11-25 16:02:33
--
--
local AttackMonsterOrderIcon = class("AttackMonsterOrderIcon",function()
	return ccui.Layout:create()
end)


function AttackMonsterOrderIcon:ctor(type)
	-- body
	local csbNode = cc.CSLoader:createNode("csb/team/lineup/LineUpNum1.csb")
	self._csbNode = csbNode
	self._csbNode:addTo(self)

	self._bg = self._csbNode:getChildByName("num_bg_1")
	self:setContentSize(self._bg:getContentSize())
	self:setAnchorPoint(0.5,0.5)
	self._csbNode:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2)
	
end

return AttackMonsterOrderIcon