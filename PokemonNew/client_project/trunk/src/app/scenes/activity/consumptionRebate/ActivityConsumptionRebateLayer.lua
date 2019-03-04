--
-- Author: Your Name
-- Date: 2018-03-07 12:29:04
--
--ActivityConsumptionRebateLayer.lua

--[====================[

    日常 累计消费返利活动layer
    
]====================]


local ActivityConsumptionRebateLayer = class("ActivityConsumptionRebateLayer", function()
    return ccui.Layout:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require ("app.common.TypeConverter")
local ActivityConst = require("app.const.ActivityConst")
local ActivityUIHelper = require("app.scenes.activity.ActivityUIHelper")

local ActivityConsumptionRebateCell = require("app.scenes.activity.consumptionRebate.ActivityConsumptionRebateCell")


function ActivityConsumptionRebateLayer:ctor()

    self._csbNode = nil       
    
    self._listData = {}         --奖励数据

    self._listView = nil        --奖励列表

    self._npcPanel = nil

    self:enableNodeEvents()

end


function ActivityConsumptionRebateLayer:onEnter()

    self:_initData()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CONSUMPTION_REBATE_GET_AWARD, self._getAward, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CONSUMPTION_REBATE_GET_INFO, self._getInfo, self)

    self:_initUI()

    self:_initListView()

end


function ActivityConsumptionRebateLayer:updatePage( )

end

function ActivityConsumptionRebateLayer:onExit()

    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end

end

function ActivityConsumptionRebateLayer:_initUI()

    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityConsumptionRebateLayer","activity"))
    self:addChild(self._csbNode)
    --self._csbNode:getSubNodeByName("ProjectNode_con"):setContentSize(display.width, display.height)
    self._csbNode:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(self._csbNode)

    --self._npcPanel = self._csbNode:getSubNodeByName("Panel_npc")

    self:_updateInfo()

end

function ActivityConsumptionRebateLayer:_updateInfo()

    --if not self._activity then return end
    local nodeSpine = self._csbNode:getSubNodeByName("Node_knight_spine")
    local knightSpine = require("app.common.KnightImg").new(31302,0,0)
    knightSpine:setScale(1.05)
    nodeSpine:addChild(knightSpine)


    --tab设置
    local tabs = {}
    local btnTexts = {}
    tabs[1] =  {text = G_Lang.get("activity_consumption_title"), tipScale = 1}

    local params = {
        tabs = tabs,
        bgWidth = 640,
        --tabsOffsetX = 72,
        --bgPosX = -115.11
    }

    self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(
        self._csbNode:getSubNodeByName("ProjectNode_tab"),params,function( ... )
            -- body
        end)
    self._tabButtons.setSelected(1)
end

function ActivityConsumptionRebateLayer:_initListView()

    if self._listView then
        self._listView:removeFromParent(true)
        self._listView = nil
    end 

    if self._listView == nil  then

        local listviewBg = self:getSubNodeByName("Panel_list")
        local listViewSize = listviewBg:getContentSize()
        self._listView = require("app.ui.WListView").new(listViewSize.width,listViewSize.height, listViewSize.width, 158, true)
        self._listView:setCreateCell(function(view,idx)
            local cell = ActivityConsumptionRebateCell.new(handler(self, self._onGetButton))
            return cell
        end)
        self._listView:setUpdateCell(function(view,cell,idx)
            if cell and idx < #self._listData then
                cell:updateData(self._listData[idx + 1])
            end
        end)

        self._listView:setFirstCellPaddigTop(8)

        self._listView:setCellNums(#self._listData, false)

        listviewBg:addChild(self._listView)

    end

end

--初始化数据
function ActivityConsumptionRebateLayer:_initData()

    self._listData = G_Me.activityData.activityConsumptionRebateData:getDataList()

end


--更新列表
function ActivityConsumptionRebateLayer:_updateListView()
   if self._listView then 
        self._listView:setCellNums(#self._listData, false)
   end 
end


--领奖
function ActivityConsumptionRebateLayer:_onGetButton(id)

   --G_HandlersManager.activityHandler:sendConsumptionGetAward(id)

end

--获取基本信息
function ActivityConsumptionRebateLayer:_getInfo()

    self:_initData()

    self:_updateInfo()

    self:_updateListView()

end


function ActivityConsumptionRebateLayer:_getAward(data)

    if data.ret == 1 and rawget(data, "award") then
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
        
        self:_getInfo()
        --G_Popup.awardSummary(data.award)
        G_Popup.awardTips(data.award)
    end

end


return ActivityConsumptionRebateLayer