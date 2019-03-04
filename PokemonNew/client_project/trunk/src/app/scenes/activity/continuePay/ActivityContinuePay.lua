
local ShaderUtils = require("app.common.ShaderUtils")
local Url = require "app.setting.Url"
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local VipLayer = require "app.scenes.vip.VipLayer"
local ActivityContinuePayCell = require("app.scenes.activity.continuePay.ActivityContinuePayCell")

local ActivityContinuePay = class("ActivityContinuePay",function()
    return ccui.Layout:create()
end)

function ActivityContinuePay:ctor()

    self:enableNodeEvents()

    self._csbNode = nil

    self._data = G_Me.activityData.activityContinuePayData
end

function ActivityContinuePay:onEnter()
    self:_initUI()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_UPDATE_CONTINUE_PAY_REWARD,self.render ,self)
    -- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECHARGE_SUCCESS,self.render ,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MONTHCARD_FRESH_DATA,self.render ,self)
end

function ActivityContinuePay:onExit()
    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
    if self._txtTimer then
        self._txtTimer:stopCountDown()
        self._txtTimer = nil
    end
end

function ActivityContinuePay:_initUI()
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityContinuePay","activity"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(self._csbNode)

    G_WidgetTools.autoTransformBg(self._csbNode:getSubNodeByName("Image_bg"))

    self._text_btn_desc = self._csbNode:getSubNodeByName("Text_btn_desc")
    self._listCon = self._csbNode:getSubNodeByName("List_container")
    self._buttonGet = self._csbNode:getSubNodeByName("Button_get")
    self._needMoneyDes1 = self._csbNode:getSubNodeByName("Text_des_all")
    self._needMoney = self._csbNode:getSubNodeByName("Text_des_all_1")
    self._needMoneyDes2 = self._csbNode:getSubNodeByName("Text_des_all_0")
    self._daysHandle = {}
    local node_days = self._csbNode:getSubNodeByName("Node_days")
    for i=1,#self._data.days do
        local dayData = self._data.days[i]
        local dayCsb = cc.CSLoader:createNode(G_Url:getCSB("ActivityContinuePayDay","activity"))
        node_days:addChild(dayCsb)
        dayCsb:setPositionX(i * 60)
        local img = dayCsb:getSubNodeByName("Sprite_node")
        local img_selected = dayCsb:getSubNodeByName("Sprite_selected")
        self._daysHandle[i] = {
            csb = dayCsb,
            setState = function( state )
                if state == 0 then
                    ShaderUtils.applyGrayFilter(img)
                elseif state == 1 then
                    ShaderUtils.removeFilter(img)
                end
            end,
            isToday = function( today )
                if today == dayData.num then
                    img_selected:setVisible(true)
                else
                    img_selected:setVisible(false)
                end
            end
        }
    end

    -- self._button_big_award = self:getSubNodeByName("Button_big_award")
    -- self._button_big_award:addClickEventListenerEx(function( ... )
    --     G_Popup.newPopup(function ()
    --         local canGet = 1
    --         local pop = require("app.scenes.activity.continuePay.ActivityContinuePayPop").new()
    --         return pop
    --     end)
    -- end)

    -- 版娘设置
    -- local nodeSpine = self:getSubNodeByName("Node_hero")
    -- local knightSpine = require("app.common.KnightImg").new(41005,3,0)
    -- knightSpine:setScale(1.8)
    -- nodeSpine:addChild(knightSpine)

    local listData = self._data:getExAwards()
    local listSize = self._listCon:getContentSize()
    self._viewList = require("app.ui.WListView").new(listSize.width, listSize.height, listSize.width, 158, true)
    self._viewList:setCreateCell(function(view, idx)
        local cell = ActivityContinuePayCell.new()
        return cell
    end)
    
    self._viewList:setFirstCellPaddigTop(8)

    self._viewList:setUpdateCell(function(view, cell, idx)
        cell:updateCell(idx,listData[idx + 1],day) --数据下标从0开始
    end)
    self._viewList:setCellNums(#listData, true, 0)
    if self._data.showIndex then
        self._viewList:setLocation(self._data.showIndex)
    end
    self._listCon:addChild(self._viewList)
	
    self:render()
end

function ActivityContinuePay:render()
    local listData = self._data:getExAwards()
    self._viewList:updateCellNums(#listData)

    for i=1,#self._daysHandle do
        local dayData = self._data.days[i]
        local dayHandle = self._daysHandle[i]
        dayHandle.isToday(self._data.today)
        dayHandle.setState(dayData.state)
    end
    -- local dayData = self._data.days[self._data.today]
    local awards = nil
    awards,self._showAwardsDay = self._data:getMainShowAward()
    print("_showAwardsDay",self._showAwardsDay)
    self:_showDrops(awards)

    local mainBtnState = self._data:getMainBtnState()
    local button_get = self:getSubNodeByName("Button_get")
    local sprite_geted = self:getSubNodeByName("Sprite_geted")
    if mainBtnState == 0 then
        button_get:setVisible(true)
        sprite_geted:setVisible(false)
        self._text_btn_desc:setString(G_Lang.get("activity_text_continue_pay_goto"))
        self._buttonGet:showBtnLight(false)
        self._buttonGet:addClickEventListenerEx(handler(self, self._showVipPanel))
    elseif mainBtnState == 1 then
        button_get:setVisible(true)
        sprite_geted:setVisible(false)
        self._text_btn_desc:setString(G_Lang.get("activity_text_continue_pay_get"))
        self._buttonGet:showBtnLight(true ,{width = 150,height = 70})
        self._buttonGet:addClickEventListenerEx(handler(self, self._getAward))
    elseif mainBtnState == 2 then
        button_get:setVisible(false)
        sprite_geted:setVisible(true)
    end

    -- local text_des_collect = self:getSubNodeByName("Text_des_collect")
    -- local ShaderUtils = require("app.common.ShaderUtils")
    -- if self._data:getExAwards() == nil then
    --     text_des_collect:setString("")
    --     -- self._button_big_award:setTouchEnabled(false)
    --     -- ShaderUtils.applyGrayFilter(self._button_big_award)
    -- else
    --     -- self._button_big_award:setTouchEnabled(true)
    --     ShaderUtils.removeFilter(self._button_big_award)
    --     if self._data.lc >= self._data.next_lc then
    --         text_des_collect:setString(G_Lang.get("activity_text_continue_pay_get2"))
    --     else
    --         text_des_collect:setString(G_Lang.get("activity_text_continue_pay_need_day_title",
    --                 {num = self._data.next_lc,has = self._data.lc,need = self._data.next_lc}
    --             )
    --         )
    --     end
    -- end

    local text_end_time = self:getSubNodeByName("Text_end_time")
    text_end_time:setString(G_ServerTime:getDateYMDHFormat(self._data.stop_time,true))

    if self._txtTimer == nil then
        self._txtTimer = require("app.common.TextTimer").new(text_end_time,handler(self,self.onTextTimerEnd),nil,2)
        self._txtTimer:beginCountDown(self._data.stop_time)
    end

    self._needMoneyDes1:setString(G_Lang.get("activity_text_continue_pay_need_des"))
    self._needMoney:setAnchorPoint(cc.p(0,0.5))
    self._needMoney:setString(G_Lang.get("activity_text_continue_pay_need_price",{num = self._data.config_money}))
    if SPECIFIC_GAME_OP_ID == SPECIFIC_GAME_OP_IDS.ANDROID_SHENHUA then
        self._needMoney:setString("$" .. self._data.config_money)
    end
    self._needMoney:setPositionX(self._needMoneyDes1:getPositionX()  + self._needMoneyDes1:getContentSize().width + 3)
    self._needMoneyDes2:setPositionX(self._needMoney:getPositionX()  + self._needMoney:getContentSize().width + 3)
    
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false, nil)
end

function ActivityContinuePay:onTextTimerEnd()
    
end

function ActivityContinuePay:_showVipPanel()
    G_Popup.newPopup(function ()
        local panel = VipLayer.new(VipLayer.TAB_INDEX_RECHARGE) ---显示充值面板
        return panel
    end)
end

function ActivityContinuePay:_getAward()
    G_HandlersManager.rechargeHandler:sendGetLianchongAwards(1,self._showAwardsDay)
end

--展示商品
function ActivityContinuePay:_showDrops(dropItems)
    local dropList = self:getSubNodeByName("Node_award_list")
    dropList:removeAllChildren()
    local Helper = require("app.common.UpdateNodeHelper")
    local Converter = require("app.common.TypeConverter")
    local item
    local data
    local outframe 
    local size
    local putIndex = 0
    for i = 1,#dropItems do
        item = cc.CSLoader:createNode(Url:getCSB("CommonIconItemNode", "common"))

        data = dropItems[i]
        data.nameVisible = false
        data.sizeVisible = true
        data.levelVisible = false
        data.disableTouch = false
        data.scale = 0.65

        Helper.updateCommonIconItemNode(item, Converter.convert(data))
        -- outframe = item:getSubNodeByName("holder")
        -- item:removeChild(self, false)
        -- outframe:setContentSize(con_size,con_size)
        dropList:addChild(item)
        -- putIndex = putIndex + 1
        item:setPosition((i-1/2-1/2*#dropItems)*(112*0.6 + 20),0)
    end
end

return ActivityContinuePay