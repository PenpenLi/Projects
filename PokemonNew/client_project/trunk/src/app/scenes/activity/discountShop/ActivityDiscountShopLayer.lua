---==============
--- 折扣商店
---==============
local ActivityDiscountShopLayer = class("ActivityDiscountShopLayer", function ()
	return display.newLayer()
end)

local ActivityDiscountShopCell = require "app.scenes.activity.discountShop.ActivityDiscountShopCell"

function ActivityDiscountShopLayer:ctor()
	self:enableNodeEvents()
	self._view = nil
	self._viewList = nil
	self._panelDay = nil -- 每日礼包层
	self._panelWeek = nil -- 每周礼包层
    self._tabButtons = nil
end

function ActivityDiscountShopLayer:onEnter()
	self._dataList = G_Me.activityData.discountShopData:getShowItems()
	--dump(self._dataList)
	self:_initView()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_ACTIVITY_VIP_REWARD_GET, self._onGetVipAwards, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_VIP_STATE_CHANGE, self._onUpdateVipLv, self)
end

function ActivityDiscountShopLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function ActivityDiscountShopLayer:_initView()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("ActivityDiscountShopLayer", "activity"))
	self:addChild(self._view)
	local projectNodeCon = self._view:getSubNodeByName("ProjectNode_con")
	self._view:setContentSize(display.width, display.height)
	ccui.Helper:doLayout(self._view)
	projectNodeCon:setContentSize(display.width, display.height)
	ccui.Helper:doLayout(projectNodeCon)

    -- 活动时间范围
	local end_time = G_Me.activityData.discountShopData:getEndTime()
    self._csbNode:updateLabel("Text_act_endtime", {
        text=G_ServerTime:getDateYMDHFormat(end_time)})

	local listCon = self._view:getSubNodeByName("Panel_list")
	local listSize = listCon:getContentSize()

	self._viewList = require("app.ui.WListView").new(listSize.width, listSize.height, listSize.width, 158, true)
    self._viewList:setCreateCell(function(view, idx)
        local cell = ActivityDiscountShopCell.new()
        return cell
    end)
    
    self._viewList:setFirstCellPaddigTop(8)

    self._viewList:setUpdateCell(function(view, cell, idx)
        cell:updateCell(self._dataList[idx + 1], idx) --数据下标从0开始
    end)
    self._viewList:setCellNums(#self._dataList, true, 0)
    listCon:addChild(self._viewList)
end

function ActivityDiscountShopLayer:_onGetVipAwards(awards)
	G_Popup.awardTips(awards)

	--更新列表显示
	self:_onUpdateVipLv()
end

function ActivityDiscountShopLayer:_onUpdateVipLv()
	local newList = G_Me.activityData.discountShopData:getShowItems()

	if #newList > #self._dataList then
		self._dataList = newList
		self._viewList:setCellNums(#self._dataList)
	else
		self._dataList = newList
		self._viewList:updateCellNums(#self._dataList)
	end
	
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false, nil)
end

return ActivityDiscountShopLayer