--
-- Author: Your Name
-- Date: 2017-11-21 16:33:26
--
--聊天悬浮窗

local ChatFloatingWindow =  class("ChatFloatingWindow",function()
   return display.newNode()
end)

function ChatFloatingWindow:ctor()
    self:enableNodeEvents()
    
    self._imgRedPoint = nil
    self._csbNode = nil

    self._touchBeganPos = {x=0,y=0}
    self._iconPos = {x=0,y=0}


    --self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    --self:registerScriptTouchHandler(handler(self, self._onTouchEvent))

    --cc.Director:getInstance():getNotificationNode():addChild(self, cc.Scene.NOTIFY_LEVEL_EXITGAME)
end

function ChatFloatingWindow:onEnter()
    self:_init()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE_CHART, self._onUpdateRedPoint, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_FLOAT_UPDATE_RED, self._onUpdateRedPoint, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE, self._onUpdateRedPoint, self)
end

function ChatFloatingWindow:onExit()
    -- if self._csbNode ~= nil then
    --     self._csbNode:removeFromParent()
    --     self._csbNode = nil
    -- end
end

function ChatFloatingWindow:_init()
    if not self._csbNode then
        self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ChatFloatingNode","chat"))
        self:addChild(self._csbNode)
    end
    local chat_btn = self._csbNode:getSubNodeByName("Button_chat")
    self:setContentSize(chat_btn:getContentSize())
    ccui.Helper:doLayout(self)

    self._imgRedPoint = self._csbNode:getSubNodeByName("Image_red_point")
    self._imgRedPoint:setLocalZOrder(99)

    self._halfWidth = chat_btn:getContentSize().width/2
    self:setAnchorPoint(0.5,0.5)
    chat_btn:addTouchEventListener(function (sender,eventType)
        if eventType == ccui.TouchEventType.began then
            local beganPos = sender:getTouchBeganPosition()
            self._touchBeganPos.x = beganPos.x
            self._touchBeganPos.y = beganPos.y
            self._iconPos.x = self:getPositionX()
            self._iconPos.y = self:getPositionY()
			return true
        elseif eventType == ccui.TouchEventType.moved then
        	local curPos = sender:getTouchMovePosition()
            local targetPosX = self._iconPos.x + curPos.x - self._touchBeganPos.x
            local targetPosY = self._iconPos.y + curPos.y - self._touchBeganPos.y

            --=====防止超出边界start
            --←
            if targetPosX < self._halfWidth then
                targetPosX = self._halfWidth
            end

            --→
            if targetPosX > display.width - self._halfWidth then
                targetPosX = display.width - self._halfWidth
            end
        	--↓
	    	if targetPosY < self._halfWidth then
                targetPosY = self._halfWidth
	    	end
            --↑
            if targetPosY > display.height - self._halfWidth then
                targetPosY = display.height - self._halfWidth
            end
            --================end

            self:setPosition(targetPosX,targetPosY)
        	G_GameSetting:setChatNodePos(targetPosX,targetPosY)
        elseif eventType == ccui.TouchEventType.ended then
        	local moveOffsetX = math.abs(sender:getTouchEndPosition().x-sender:getTouchBeganPosition().x)
            local moveOffsetY = math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
            if moveOffsetX < 5 and moveOffsetY < 5 then
                local chatState = G_Me.chatData:getChatLayerState()
                if chatState.state and chatState.layer then
                    chatState.layer:removeFromParent()
                    G_Me.chatData:setChatLayerState(false,nil)
                else
                    G_Popup.newPopup(function()
                        return require("app.scenes.chat.ChatLayer").new()
                    end)
                end
            end
        elseif eventType == ccui.TouchEventType.canceled then
        	
        end
    end)
    
    self:_onUpdateRedPoint()
end

function ChatFloatingWindow:_onUpdateRedPoint()
    -- local redWorld = G_Me.chatData:hasRedPointWorld()
    -- local redPri = G_Me.chatData:hasRedPointPrivate()

    local redVisible = G_Me.chatData:hasRedPoint()
    if self._imgRedPoint then
        self._imgRedPoint:setVisible(redVisible)
    end
end

function ChatFloatingWindow:_onTouchEvent(eventType,x,y)
-- 	if eventType == "began" then
-- --      	local beganPos = sender:getTouchBeganPosition()
-- 		return true
--     elseif eventType == "moved" then
--     	--local curPos = self:getTouchMovePosition()
--     	if x > self._halfWidth and x <= display.width - self._halfWidth then
--     		self:setPositionX(x)
--     	end
--     	if y > self._halfWidth and y <= display.height - self._halfWidth then
--     		self:setPositionY(y)
--     	end
--     elseif eventType == "ended" then
        
--     elseif eventType == "canceled" then
--     end
end



return ChatFloatingWindow

