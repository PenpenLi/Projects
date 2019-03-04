local TouchEffectLayer = class("TouchEffectLayer",function()
    return display.newLayer()
end)

--
function TouchEffectLayer:ctor()
    --
    self._show = false

    --
    --self._emitter = cc.ParticleSystemQuad:create("particle/particle_touch.plist")
    --self:addChild(self._emitter)
    --self._emitter:stopSystem()

    --
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self, self._onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self._onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self, self._onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(handler(self, self._onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    uf_notifyLayer:addChild(self, cc.Scene.NOTIFY_LEVEL_TOUCHEFFECT)
end

function TouchEffectLayer:start()
    local always = G_Setting.get("open_show_touch") or "1"
    if always == "0" then
        self._show = false
    else
        self._show = true
    end

    --
    if self._emitter ~= nil then
        self:removeChild(self._emitter)
        self._emitter = nil
    end

    --
    local effect = G_Setting.get("touch_effect")
    if effect ~= nil and effect ~= "" then
        local valueMap = cc.FileUtils:getInstance():getValueMapFromData(effect, string.len(effect))
        self._emitter = cc.ParticleSystemQuad:create(valueMap)
    else
        self._emitter = cc.ParticleSystemQuad:create("particle/particle_touch.plist")
    end
    
    --
    if self._emitter then
        self:addChild(self._emitter)
        self._emitter:stopSystem()
    end
end

--
function TouchEffectLayer:clear()
    uf_notifyLayer:removeChild(self)
end

--
function TouchEffectLayer:_onTouchBegan(touch, event)
    if self._emitter then
        if self._show then
            local locationInNode = self:convertToNodeSpace(touch:getLocation())
            self._emitter:resetSystem()
            self._emitter:setPosition(locationInNode)
            return true
        end

        self._emitter:stopSystem()
    end

    return false
end

--
function TouchEffectLayer:_onTouchMoved(touch, event)
    if self._emitter then
        local locationInNode = self:convertToNodeSpace(touch:getLocation())
        self._emitter:setPosition(locationInNode)
    end
end

--
function TouchEffectLayer:_onTouchEnded(touch, event)
    if self._emitter then
        self._emitter:stopSystem()
    end
end

--
function TouchEffectLayer:_onTouchCancelled(touch, event)
    if self._emitter then
        self._emitter:stopSystem()
    end
end

return TouchEffectLayer