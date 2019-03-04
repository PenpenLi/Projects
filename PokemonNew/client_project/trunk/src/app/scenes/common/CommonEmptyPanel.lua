--列表为空显示的面板

local CommonEmptyPanel =  class("CommonEmptyPanel",function()
    return cc.Node:create()
end)

function CommonEmptyPanel:ctor(size,isLovers)
    self._size = size
    self._isLovers = isLovers or false

    self:_init()
    self:enableNodeEvents()
end

function CommonEmptyPanel:_init()

    --self:setPosition(display.cx, display.cy)
    
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("CommonEmptyPanel","common"))
    --self._csbNode:setTouchEnabled(false)
    self:addChild(self._csbNode)
    if self._size then
        self._csbNode:setContentSize(self._size)
    else
        self._csbNode:setContentSize(display.width,display.height)
    end
    ccui.Helper:doLayout(self._csbNode)

    --npc形象
    local npcPanel = self._csbNode:getSubNodeByName("Panel_npc")
    local panelSize = npcPanel:getContentSize()
    local npc = require("app.common.KnightImg").new(41505,0,0)
    npc:setScale(1.3)
    npc:setAnchorPoint(cc.p(0.5, 0.5))
    npc:setPosition(cc.p(panelSize.width * 0.5,panelSize.height * 0.5))
    npcPanel:addChild(npc, -1)

    if self._isLovers then
        self._csbNode:getSubNodeByName("Node_petal"):setVisible(true)
    else
        self._csbNode:getSubNodeByName("Node_petal"):setVisible(false)
    end
end

---更新提示
---@text 描述
---@gotoFunc 如果需要引导玩家去获取相应的东西，传这个函数。(可选)
function CommonEmptyPanel:updateTips(text, gotoFunc)

    local _text = text or "列表为空"
    self._csbNode:updateLabel("Text_tips", {text=_text,
    	textColor = G_Colors.getColor(1), fontSize = 18})

    self._csbNode:updateButton("Button_goto",
        {
            visible = gotoFunc ~= nil,
            callback = gotoFunc
        }
    )
end


function CommonEmptyPanel:onEnter()    

end

function CommonEmptyPanel:onExit()
end

return CommonEmptyPanel

