--
-- Author: YouName
-- Date: 2015-11-26 14:23:06
--
local BackButtonWidget=class("BackButtonWidget",function()
	return display.newNode()
end)

function BackButtonWidget:ctor(  )
	-- body
	local sizeW = 73
	local sizeH = 73
	local backButton = ccui.Button:create("ui/common/anniu_fanhui.png")
	backButton:setPosition(40,40)
	self:addChild(backButton)
	backButton:addClickEventListenerEx(function(sender)
		G_ModuleDirector:popModule()
	end)
end

return BackButtonWidget