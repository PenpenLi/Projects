
local ShaderUtils = require("app.common.ShaderUtils")
local Url = require "app.setting.Url"
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

local ActivityContinuePayPop = class("ActivityContinuePayPop",function()
    return display.newNode()
end)

--day
function ActivityContinuePayPop:ctor()
    self:enableNodeEvents()
	self:setPosition(display.cx, display.cy)
    self._data = G_Me.activityData.activityContinuePayData
               
                
end

function ActivityContinuePayPop:onEnter()
    self:_initUI()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_UPDATE_CONTINUE_PAY_REWARD,self.render ,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MONTHCARD_FRESH_DATA,self.render ,self)
end

function ActivityContinuePayPop:onExit()
    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

function ActivityContinuePayPop:_initUI()
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityContinuePayPop","activity"))
    self:addChild(self._csbNode)

    self._button_deal = self._csbNode:getSubNodeByName("Button_deal")
    self._button_Close = self._csbNode:getSubNodeByName("Button_close")
    self._button_Close:addClickEventListenerEx(handler(self, self._onClose))

    self._tips = self._csbNode:getSubNodeByName("Text_tip_1")

    self:render()
end

function ActivityContinuePayPop:render()
    self._awards =  self._data:getExAwards()
    if self._awards == nil then
        self:_onClose()
        return
    end

    self._canget = self._data:canGetExAwards()
    self._day = self._data.next_lc

	self:_showDrops(self._awards)
	if self._canget then
		UpdateButtonHelper.updateBigButton(self._button_deal,
	        {
	            desc = G_Lang.get("activity_text_continue_pay_get"),
	            --state = UpdateButtonHelper.STATE_NORMAL,
	            callback = handler(self, self._getAward)
	        }
	    )
	else
		UpdateButtonHelper.updateBigButton(self._button_deal,
	        {
	            desc = G_Lang.get("activity_text_continue_pay_ok"),
	            --state = UpdateButtonHelper.STATE_NORMAL,
	            callback = handler(self, self._onClose)
	        }
	    )
	end
    self._tips:setString(G_Lang.get("activity_text_continue_pay_need_day",{num = self._day}))
end

function ActivityContinuePayPop:_getAward( ... )
	G_HandlersManager.rechargeHandler:sendGetLianchongAwards(2,self._data.next_lc)
end

function ActivityContinuePayPop:_onClose( ... )
	self:removeFromParent()
end

--展示商品
function ActivityContinuePayPop:_showDrops(dropItems)
    local dropList = self:getSubNodeByName("Node_awards")
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
        data.scale = Helper.NODE_SCALE_80

        Helper.updateCommonIconItemNode(item, Converter.convert(data))
        -- outframe = item:getSubNodeByName("holder")
        -- item:removeChild(self, false)
        -- outframe:setContentSize(con_size,con_size)
        dropList:addChild(item)
        -- putIndex = putIndex + 1
        item:setPosition((i-1/2-1/2*#dropItems)*(112 + 10),0)
    end
end

return ActivityContinuePayPop