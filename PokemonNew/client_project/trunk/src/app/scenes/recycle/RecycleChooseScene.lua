--[====================[

    炼化台选择装备神将碎片材料场景

]====================]
local RecycleChooseScene = class("RecycleChooseScene",function()
    return display.newScene("RecycleChooseScene")
end)

function RecycleChooseScene:ctor(layer)
	--
	self._bgLayer = display.newSprite("newui/background/bg_mission03.jpg")
    self._bgLayer:align(display.BOTTOM_CENTER, display.cx, display.cy)
    local bgSize = self._bgLayer:getContentSize()
    self._bgLayer:setScale(display.width / bgSize.width)
	self:addChild(self._bgLayer)
    G_WidgetTools.autoTransformBg(self._bgLayer,760,1.2)

	--
    self._chooseLayer = layer
    self:addChild(self._chooseLayer)
    self:addChatFloatNode()
    self:addtUserBattleListener()--添加全局的事件侦听

    --
    
end

function RecycleChooseScene:onEnter()
    
end

return RecycleChooseScene