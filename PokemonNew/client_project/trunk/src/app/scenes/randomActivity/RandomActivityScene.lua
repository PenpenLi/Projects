--[====================[
    定制类活动场景（天宫宝库）
    其实就是随机活动
    kaka
]====================]

local RandomActivityScene=class("RandomActivityScene",function()
	return display.newScene("RandomActivityScene")
end)

function RandomActivityScene:ctor(actType)

	actType = actType or 1
	local layer = require("app.scenes.randomActivity.RandomActivityLayer").new(actType)
	self:addChild(layer)
	self:addChatFloatNode()
	self:addtUserBattleListener()--添加全局的事件侦听
	
end

function RandomActivityScene:onEnter()
	self:regeditWidgets("mainmenu","topbarBase")
end

return RandomActivityScene