--[====================[

    随机活动购买 购买次数面板
    卡卡

]====================]

local RandomActivityBuyCountPanel =  class("RandomActivityBuyCountPanel",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require("app.common.TypeConverter")
local CommonBuyCount = require("app.common.CommonBuyCount")

function RandomActivityBuyCountPanel:ctor(actType)
 
    self._actType = actType or 1

    self._totalPrice = 0
    self._buyNum = 1
    self._maxCount = 0

    self._commonCount = G_Me.randomActivityData:getBuyCommonCount()

    if self._commonCount then
        --local functionType = self._commonCount["func_id"]
        self._maxCount = G_Me.randomActivityData:getMaxCanBuyCount() - self._commonCount.buy_count
    end

    self:enableNodeEvents()
end

function RandomActivityBuyCountPanel:onEnter()
    self:_initUI()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_BUY_COUNT, self._buyOkHandler, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECV_ROLE_INFO, self._onRoleDataUpdate, self)

end

function RandomActivityBuyCountPanel:onExit()
    uf_eventManager:removeListenerWithTarget(self)
end


function RandomActivityBuyCountPanel:_initUI()
    local node = cc.CSLoader:createNode(G_Url:getCSB("RandomActivityBuyNodel", "randomActivity"))
    self:addChild(node)
    self:setPosition(display.cx, display.cy)

    self:updateLabel("Text_title", G_LangScrap.get("random_activity_title_buy_count"))
    self:updateLabel("Text_total_price_desc", G_LangScrap.get("lang_common_buy_item_total_price_desc"))

    UpdateButtonHelper.updateNormalButton( ---购买按钮
        self:getSubNodeByName("Node_confirm"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("common_btn_buy"),
        callback = function()
            self:_onBuyItem()
        end
    })

    UpdateButtonHelper.updateNormalButton( ---取消按钮
        self:getSubNodeByName("Node_cancel"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("common_btn_cancel"),
        callback = function()
            self:_onBuyCancel()
        end
    })

    self:updateButton("Button_close", function ( )
        self:_onBuyCancel()
    end)

    self:updateButton("Button_sub1", function ()
        self:_onSub(1)
    end)
    self:updateButton("Button_sub10", function ()
        self:_onSub(10)
    end)
    self:updateButton("Button_add1", function ()
        self:_onAdd(1)
    end)
    self:updateButton("Button_add10", function ()
        self:_onAdd(10)
    end)

    self:_updateUI()

end


--收到用户数据刷新通知
function RandomActivityBuyCountPanel:_onRoleDataUpdate( ... )
    self:_updateUI()
end


function RandomActivityBuyCountPanel:_updateUI()

    self._totalPrice = self._commonCount and CommonBuyCount.getTotalBuyCost(self._commonCount, self._buyNum) or 0

    local maxBuyNum = self._maxCount

    self:updateLabel("Text_amount", self._buyNum)

    self:updateLabel("Text_current_buy_count", 
        G_LangScrap.get("lang_common_buy_item_amount_limit", {amount = maxBuyNum})..
        G_LangScrap.get("common_text_reset_time"))

    local isCostEnough = G_Me.userData.gold >= self._totalPrice 

    local costColor = isCostEnough and G_ColorsScrap.COLOR_POPUP_DESC_NOTE or 
        G_ColorsScrap.COLOR_POPUP_NOTE

    self:updateLabel("Text_total_price", {
        text = tostring(self._totalPrice),
        color = costColor
    })

end

function RandomActivityBuyCountPanel:_onBuyItem()
    
    G_Responder.enoughGold(self._totalPrice, function()
        G_HandlersManager.randomActivityHandler:sendBuyCount(self._buyNum)
    end)

end


function RandomActivityBuyCountPanel:_onBuyCancel()
    self:removeFromParent()
end

function RandomActivityBuyCountPanel:_onSub(num)
    local newNum = self._buyNum - num 
    newNum = newNum <= 0 and 1 or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end
end


function RandomActivityBuyCountPanel:_onAdd(num)

    local newNum = self._buyNum + num
    newNum = newNum >= self._maxCount and self._maxCount or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end

end

function RandomActivityBuyCountPanel:_buyOkHandler()
    G_Popup.tip(G_LangScrap.get("shop_buy_success"))
    -- self._buyNum = 1
    -- self:_updateUI()
    self:_onBuyCancel()
end

return RandomActivityBuyCountPanel

