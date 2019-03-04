--单个物品购买面板

local CommonBuySinglePanel =  class("CommonBuySinglePanel",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local FixedShopConfigConst = require("app.const.FixedShopConfigConst") 
local ShopUtils = require "app.scenes.shopCommon.ShopUtils"
local ShopFixedInfo = require("app.cfg.shop_score_info")
local VipFunctionInfo = require "app.cfg.vip_function_info"
local TypeConverter = require "app.common.TypeConverter"
local ShopScoreInfo = require("app.cfg.shop_score_info")
local CfgItemInfo = require("app.cfg.item_info") 
local ItemConst = require("app.const.ItemConst")

function CommonBuySinglePanel:ctor(param)
   -- self._buyParam = param or nil

    assert(type(param) == "table", "CommonBuySinglePanel:item data error~~~~")

    self._itemId = param.itemId

    self._fixedShopId = param.fixedShopId
    self._isMission = param.isMission
    self._totalPrice = 0
    --dump(self._fixedShopId)
    self._fixedShopInfo = ShopFixedInfo.get(self._fixedShopId)
    --dump(self._fixedShopInfo)
    self._buyNum = 1

    self:enableNodeEvents()
end

function CommonBuySinglePanel:onEnter()
    self:_initUI()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_BUY_SHOP_RESULT, self._buyOkHandler, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SHOP_INFO_NTF, self._updateUI, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_VIP_STATE_CHANGE, self._updateVip, self)

    G_Me.shopCommonData:requestShopData(FixedShopConfigConst.FIXED_SHOP_ID)
end

function CommonBuySinglePanel:onExit()
    uf_eventManager:removeListenerWithTarget(self)
end

function CommonBuySinglePanel:_initUI()
    local node = cc.CSLoader:createNode(G_Url:getCSB("CommonBuyNode", "common"))
    self:addChild(node)
    self:setPosition(display.cx, display.cy)

    UpdateNodeHelper.updateCommonNormalPop(node, nil, nil, 535)

    local count = ShopScoreInfo.getLength()
    local itemShopInfo = nil     --从商城中获取该道具的数据
    for i = 1, count do
        local info = ShopScoreInfo.indexOf(i)
        if info.type == TypeConverter.TYPE_ITEM and info.value == self._itemId then
            itemShopInfo = info
            break
        end
    end

    --assert(itemShopInfo, "invalide id in shop_score_info " .. tostring(self._itemId))
    if itemShopInfo ~= nil then self._fixedShopInfo = itemShopInfo end

    -- 道具信息获取
    local itemInfo = CfgItemInfo.get(self._fixedShopInfo.value)

    UpdateNodeHelper.updateCommonIconItemNode(node:getSubNodeByName("Node_icon"), 
        {type = self._fixedShopInfo.type, value = self._fixedShopInfo.value, size = 1,nameVisible = false,scale = 0.8})

    self:updateLabel("Text_name", {
            text= self._fixedShopInfo.name,
            textColor=G_Colors.qualityColor2Color(TypeConverter.quality2Color(itemInfo.quality)),
            --outlineColor=G_ColorsScrap.getColorOutline(self._fixedShopInfo.color),
        })
    self:updateLabel("Text_title", G_LangScrap.get("common_title_buy_item"))
    self:updateLabel("Text_desc", self._fixedShopInfo.direction)--itemInfo.description)
    local Text_current_amount_title = self:updateLabel("Text_current_amount_title", G_LangScrap.get("lang_common_buy_item_amount_desc"))
    local Text_current_amount_value = self:updateLabel("Text_current_amount_value", 0)
    self:updateLabel("Text_total_price_desc", G_LangScrap.get("lang_common_buy_item_total_price_desc"))

    -- 位置调整
    Text_current_amount_title:setPositionX(Text_current_amount_value:getPositionX() 
            - Text_current_amount_value:getContentSize().width + 8)

    UpdateButtonHelper.updateBigButton( ---购买按钮
        self:getSubNodeByName("Node_confirm"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("common_btn_buy"),
        callback = function()
            self:_onBuyItem()
        end
    })

    UpdateButtonHelper.updateBigButton( ---使用按钮
        self:getSubNodeByName("Node_cancel"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_Lang.get("common_btn_cancel"),
        callback = function()
            --self:_onUseItem()
            self:removeFromParent(true)
        end
    })

    self:updateButton("Button_close", function ( )
        self:removeFromParent()
    end)

    self:updateButton("Button_sub1", function ()
        self:_onSub1()
    end)
    self:updateButton("Button_sub10", function ()
        self:_onSub10()
    end)
    self:updateButton("Button_add1", function ()
        self:_onAdd1()
    end)
    self:updateButton("Button_add10", function ()
        self:_onAdd10()
    end)
end

function CommonBuySinglePanel:_updateVip()
    if not G_Me.shopCommonData:hasReciveFixedShopData() then 
        G_Me.shopCommonData:requestShopData(FixedShopConfigConst.FIXED_SHOP_ID)
    else
        self:_updateUI()
    end
end

function CommonBuySinglePanel:_updateUI()
    local fixedShopData = G_Me.shopCommonData:getFixedShopData()
    local propData = fixedShopData:getGoodsData(FixedShopConfigConst.FIXED_SHOP_ID, self._fixedShopInfo.id)
    dump(self._fixedShopInfo.price_1 .. ":" .. self._buyNum .. ":" .. self._fixedShopInfo.id .. ":" .. propData.buyCount)
    --self._totalPrice = self._fixedShopInfo.price_1 * self._buyNum + ShopUtils.getGoodsTotalAddPrice(self._fixedShopInfo.id, propData.buyCount + 1, self._buyNum)
    self._totalPrice = ShopUtils.getGoodsTotalAddPrice(self._fixedShopInfo.id, propData.buyCount + 1, self._buyNum)
    local _, maxBuyNum = G_Me.shopCommonData:getFixedShopData():getGoodsCount(self._fixedShopInfo.shop_id, self._fixedShopInfo.id)
    local propNum = G_Me.propsData:getPropItemNum(self._fixedShopInfo.value)

    self:updateLabel("Text_amount", self._buyNum)
    self:updateLabel("Text_current_amount_value", propNum)
    self:updateLabel("Text_current_buy_count", maxBuyNum)--G_LangScrap.get("lang_common_buy_item_amount_limit", {amount = maxBuyNum}))
    self:updateLabel("Text_total_price", self._totalPrice)
end

function CommonBuySinglePanel:_onBuyItem()
    local fixedShopData = G_Me.shopCommonData:getFixedShopData()
    local _, maxBuyNum = G_Me.shopCommonData:getFixedShopData():getGoodsCount(self._fixedShopInfo.shop_id, self._fixedShopInfo.id)
    local propData = fixedShopData:getGoodsData(FixedShopConfigConst.FIXED_SHOP_ID, self._fixedShopInfo.id)
    
    if maxBuyNum <= 0 then
        --如果购买已达上限，根据不同的道具来对应不同的VIP特权
        G_Responder.shopItemBuyCheck(self._fixedShopInfo.id)
    else
        G_Responder.enoughGold(self._totalPrice, function  ()
            G_HandlersManager.shopCommonHandler:sendBuyShopGoods(FixedShopConfigConst.FIXED_SHOP_ID, self._fixedShopId, self._buyNum)
        end)
    end
end

---跳转到使用界面。
function CommonBuySinglePanel:_onUseItem()
    local propNum = G_Me.propsData:getPropItemNum(self._fixedShopInfo.value)
    
    if propNum == 0 then
        G_Popup.tip(G_LangScrap.get("lang_common_use_no_items"))
        return
    end

    G_Popup.buySingleConfirm(self._itemId)
    self:removeFromParent()
end

function CommonBuySinglePanel:_onSub1()
    local newNum = self._buyNum - 1 
    newNum = newNum <= 0 and 1 or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end
end

function CommonBuySinglePanel:_onSub10()
    local newNum = self._buyNum - 10 
    newNum = newNum <= 0 and 1 or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end
end

function CommonBuySinglePanel:_onAdd1()
    local _, maxBuyNum = G_Me.shopCommonData:getFixedShopData():getGoodsCount(self._fixedShopInfo.shop_id, self._fixedShopInfo.id)
    local newNum = self._buyNum + 1 
    newNum = newNum > maxBuyNum and maxBuyNum or newNum
    newNum = newNum <= 0 and 1 or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end

    --self:_onBuyNumCheck(maxBuyNum)
end

function CommonBuySinglePanel:_onAdd10()
    local _, maxBuyNum = G_Me.shopCommonData:getFixedShopData():getGoodsCount(self._fixedShopInfo.shop_id, self._fixedShopInfo.id)
    local newNum = self._buyNum + 10 
    newNum = newNum > maxBuyNum and maxBuyNum or newNum
    newNum = newNum <= 0 and 1 or newNum
    if self._buyNum ~= newNum then
        self._buyNum = newNum
        self:_updateUI()
    end

    --self:_onBuyNumCheck(maxBuyNum)
end

function CommonBuySinglePanel:_onBuyNumCheck(maxBuyNum)
    if maxBuyNum ~= 0 then return end
    local currentVipLv = G_Me.vipData:getVipLevel()
    local maxVipValue = G_Me.vipData:getMaxLevel()
    local maxTimes = self._fixedShopInfo["vip" .. maxVipValue .. "_num"]
    local currentTimes = self._fixedShopInfo["vip" .. currentVipLv .. "_num"]

    if maxTimes ~= currentTimes then
        G_Popup.tip(G_LangScrap.get("lang_vip_need_improve"))
    end
end

function CommonBuySinglePanel:_buyOkHandler()
    G_Popup.tip(G_LangScrap.get("shop_buy_success"))
    --如果是副本体力不足购买，则购买完成后直接使用
    if self._isMission and (self._itemId == ItemConst.TI_LI_DAN_ID or self._itemId == ItemConst.JING_LI_DAN_ID) then
        self:_goToUse(self._itemId)
        return
    end
    self._buyNum = 1
    self:_updateUI()
end

function CommonBuySinglePanel:_goToUse(itemId)
    local item_info = require "app.cfg.item_info"
    local itemInfo = item_info.get(itemId)
    local currItemNum = 0
    if itemId == ItemConst.TI_LI_DAN_ID then
        currItemNum = G_Me.userData.vit
    elseif itemId == ItemConst.JING_LI_DAN_ID then
        currItemNum = G_Me.userData.spirit
    end
    local ownNum = G_Me.propsData:getPropItemNum(itemId)
    --优先弹出批量使用
    if ownNum >0 then
        local parameter_info = require "app.cfg.parameter_info"
        local figureDic = {}
        figureDic[ItemConst.TI_LI_DAN_ID] = 263
        figureDic[ItemConst.JING_LI_DAN_ID] = 428

        local max_limit = 99999999      
        if figureDic[itemId] then
            max_limit = tonumber(parameter_info.get(figureDic[itemId]).content)
        end

        --是否超过了允许的上限
        if currItemNum + itemInfo.item_value > max_limit then
            G_Popup.tip(G_Lang.get("common_item_use_exceed") .. currItemNum .. itemInfo.item_value .. max_limit .. itemId)
            return
        end         
        
        G_Popup.newPopup(function()
            return require("app.scenes.common.CommonBatchUsePanel").new({ownNum=ownNum, itemInfo=itemInfo, 
            curResultNum = currItemNum, maxLimit = max_limit})
        end)
    end
    self:removeFromParent()
end

return CommonBuySinglePanel

