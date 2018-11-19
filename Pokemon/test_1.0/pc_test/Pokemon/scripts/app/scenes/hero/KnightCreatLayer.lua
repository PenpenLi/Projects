require("app.cfg.knight_info")

local KnightPic = require "app.scenes.common.KnightPic"

local KnightCreatLayer = class ("KnightCreatLayer", function() return display.newNode() end)

function KnightCreatLayer:ctor( knightInfoId, endCallback, dressResId)
    self._knightInfoId = knightInfoId
    self._endCallback =  endCallback
    self:setNodeEventEnabled(true)

    self._dressResId = dressResId or 0
    local info = knight_info.get(knightInfoId)
    self._knightInfo = info
end

function KnightCreatLayer:show(   )
    self:_createKnightNode(self._knightInfo, false)
    
    self._endCallback()
end

function KnightCreatLayer:_createKnightNode( info,shadow )

    local pic = KnightPic.createKnightNode(self._dressResId > 0 and self._dressResId or info.res_id, "knight", shadow)    
    pic:setCascadeOpacityEnabled(true)

    return pic
    
end


function KnightCreatLayer:onExit()
    self:setNodeEventEnabled(false)
    if self._node then
        self._node:stop()
    end
    if self._effect then
        self._effect:stop()
    end
end

return KnightCreatLayer


