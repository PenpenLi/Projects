--
-- Author: wyx
-- Date: 2018-01-30 11:29:43
--=== 查看buff加成的 buff单元
local BuffItem = class("BuffItem", function ()
    return ccui.Layout:create()
end)

local MaxChallengeConst = require("app.const.MaxChallengeConst")

function BuffItem:ctor()
   	self._csbNode = cc.CSLoader:createNode("csb/maxChallenge/popup/ScanBuffItem.csb")
   	self:addChild(self._csbNode)
   	local panel_buff = self._csbNode:getSubNodeByName("Panel_buff")
   	self:setAnchorPoint(0,0)
   	self:setContentSize(panel_buff:getContentSize())
   	self:setColor(cc.c3b(255*0.6, 255*0.45, 255*0.45))


   	self:addTouchEventListenerEx(function(sender,state)
   		print("touch......buffitem")
   		if(state == ccui.TouchEventType.began)then
			return true
		elseif(state == ccui.TouchEventType.ended)then
			local moveOffsetY = math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
			local moveOffsetX = math.abs(sender:getTouchEndPosition().x-sender:getTouchBeganPosition().x)
			if(moveOffsetX <= 10 and moveOffsetY <= 10)then
				if self._callback then
		   			self._callback(self._data,self)
		   		end
			end
		elseif(state == ccui.TouchEventType.canceled)then

		end
   	end)
end

function BuffItem:setData(isEnemy,data,callback)
	self._callback = callback
	self._data = data
	--dump(data)
	--buff name
	self._csbNode:updateLabel("Text_buff_name", {
		text = data.buff_name.."：",
		textColor = G_Colors.getColor(2),
		})

	--buff value
	self._csbNode:updateLabel("Text_buff_value", {
		text = data.buff_value,
		textColor = G_Colors.getColor(22),
		})

	--如果是野怪,除了怒气值，其它显示向上
	local textValue = self._csbNode:getSubNodeByName("Text_buff_value")
	local imgArrow = self._csbNode:getSubNodeByName("Sprite_arrow")
	if isEnemy then
		self:setTouchEnabled(false)
		self:setSwallowTouches(false)
		textValue:setVisible(MaxChallengeConst.MONSTER_SPECIAL_BUFF_ID == data.attr_id)
		imgArrow:setVisible(MaxChallengeConst.MONSTER_SPECIAL_BUFF_ID ~= data.attr_id)
	else
		print("my team ....")
		self:setTouchEnabled(true)
   		self:setSwallowTouches(true)
		textValue:setVisible(true)
		imgArrow:setVisible(false)
	end

	-- local isenable = self:isTouchEnabled()
	-- dump(isenable)
end

return BuffItem