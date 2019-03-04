--
-- Author: Your Name
-- Date: 2015-08-28 16:23:27
--
local WaitingWidget=class("WaitingWidget",function()
    --return cc.LayerColor:create(cc.c4b(0xff,0,0,100))
    return cc.Layer:create()
end)

function WaitingWidget:ctor( ... )
    --
    self:setTouchEnabled(true)
    -- print("WaitingWidget!!")
    -- self:registerScriptTouchHandler(function(event,x,y)
    --     if(event=="began")then
    --         print("WaitingWidget touch!!")
    --         return self._show--true
    --     end
    -- end)

    -- 屏蔽事件击穿
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:retain()

    self._touchListener = listener
    
    --
    self._loadingNode = cc.Node:create()
    self:addChild(self._loadingNode)
    self._loadingNode:setPosition(display.width/2, display.height/2)
    self._loadingNode:setVisible(false)

    -- local colorLayer = cc.LayerColor:create(cc.c4b(0,0,0,255*0.7))
    -- colorLayer:setPosition(-display.width/2, -display.height/2)
    -- self._loadingNode:addChild(colorLayer)

    --
    --self._loadingSprite = cc.Sprite:create(G_Url:getUI_common("img_com_loading01"))
    --self._loadingNode:addChild(self._loadingSprite)

    --
    self._loadingSprite = require("app.effect.EffectNode").new("effect_loading_all")
    self._loadingNode:addChild(self._loadingSprite)
    -- self._loadingNode:setScale(0.8)
    uf_notifyLayer:addChild(self, cc.Scene.NOTIFY_LEVEL_WAITING)
    --cc.Director:getInstance():getNotificationNode():addChild(self, cc.Scene.NOTIFY_LEVEL_WAITING)
    --
    self._show = false
end

function WaitingWidget:showWaiting(show, t)
    if self._show ~= show then
        self._show = show
        self._loadingNode:stopAllActions()
        self._loadingNode:setVisible(false)
        self._loadingSprite:stopAllActions()
        self._loadingSprite:setVisible(false)
        self._loadingSprite:stop()
        if show then
            t = t or 0.3
            self._loadingNode:setVisible(true)
            --self._loadingNode:runAction(cc.RepeatForever:create(cc.RotateBy:create(2, 360)))
            self._loadingSprite:runAction(cc.Sequence:create(cc.DelayTime:create(t), cc.Show:create(), cc.CallFunc:create(function ()
                self._loadingSprite:play()
            end)))
            cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self._touchListener, -9999)
        else
            cc.Director:getInstance():getEventDispatcher():removeEventListener(self._touchListener)
        end
    end
end

function WaitingWidget:onEnter()
    
end

function WaitingWidget:onExit()
    
end

function WaitingWidget:clear()
    self:showWaiting(false)
    self:unregisterScriptTouchHandler()
    uf_notifyLayer:removeChild(self)
end

return WaitingWidget