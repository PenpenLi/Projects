--
-- Author: Your Name
-- Date: 2015-08-29 15:14:09
--
local OffLinePop=class("OffLinePop",function( ... )
	-- body
	return cc.CSLoader:createNode("csb/common/OffLinePop.csb")
end)

OffLinePop.layerColor = nil

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function OffLinePop:ctor( str_title, returnToLogin )
	-- body
	self:updateLabel("txt_title",{text=tostring(str_title)})
	local btnRelogin = self:getSubNodeByName("btn_relogin")
	local btnReconnect = self:getSubNodeByName("btn_reconnect")

	UpdateButtonHelper.updateBigButton(btnRelogin,{
		state = UpdateButtonHelper.STATE_ATTENTION,
		desc = "重新登录",
		callback = function()
			self:closeFunc()
			G_PlatformProxy:returnToLogin()
		end
	})

	UpdateButtonHelper.updateBigButton(btnReconnect,{
		desc = "重新连接",
		state = UpdateButtonHelper.STATE_NORMAL,
		callback = function()
			G_NetworkManager:reconnect()
			self:closeFunc()
		end
	})

	if returnToLogin then
		btnReconnect:setVisible(false)
		local x = btnRelogin:getPositionX() + (btnReconnect:getPositionX() - btnRelogin:getPositionX()) / 2
		btnRelogin:setPositionX(x)
	end
end

function OffLinePop.create( str_title, returnToLogin )
	-- body
	if(OffLinePop.node ~= nil)then return end
	local layerColor=cc.LayerColor:create(cc.c4b(0,0,0,255*0.3))
	layerColor:setTouchEnabled(true)
    layerColor:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    layerColor:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        elseif event == "ended" then
            
        end
    end)
    OffLinePop.layerColor = layerColor
    display.getRunningScene():addToTopLayer(layerColor)
    --uf_notifyLayer:addChild(layerColor,cc.Scene.NOTIFY_LEVEL_OFFLINE)

	local node=OffLinePop.new(str_title, returnToLogin)
    node:setScale(0.5)
    node:setPosition(display.cx,display.cy)
    node:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.3, 1)))
    OffLinePop.node = node
    layerColor:addChild(node)
 --    G_Popup.newPopup(function()
	--   	return node
	-- end,true)

    if buglyLog then
    	local traceback = string.split(debug.traceback("", 2), "\n")
		buglyLog(3, "PlatformProxy", "G_PlatformProxy.loginGame from: " .. string.trim(traceback[3]))
	end

	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_REMOVE_TOUCH_SWALLOW, nil, false)
end
function OffLinePop.close()
	if(OffLinePop.node~=nil)then
		OffLinePop.node:removeFromParent(true)
		OffLinePop.node=nil
	end
end
function OffLinePop:closeFunc( ... )
	-- body
	if(OffLinePop.node~=nil)then
		OffLinePop.node:removeFromParent(true)
		OffLinePop.node=nil
	end
end

return OffLinePop