--ActivityCompensationLayer.lua

--[====================[

    补偿活动layer
    
]====================]


local ActivityCompensationLayer = class("ActivityCompensationLayer", function()
    return ccui.Layout:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require ("app.common.TypeConverter")
local ActivityConst = require("app.const.ActivityConst")
local ActivityUIHelper = require("app.scenes.activity.ActivityUIHelper")

local ActivityCompensationCell = require("app.scenes.activity.compensation.ActivityCompensationCell")


function ActivityCompensationLayer:ctor()

    self._csbNode = nil       
    
    self._activity = nil

    self._listData = {}         --奖励数据

    self._listView = nil        --奖励列表

    self._npcPanel = nil

    self:enableNodeEvents()

end


function ActivityCompensationLayer:onEnter()

    -- if G_Me.compensationActivityData:isExpired() then
    --     G_Me.compensationActivityData:setReset()
    --     uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false, nil)
    -- end

    self:_initData()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_COMPENSATION_ACTIVITY_GET_AWARD, self._getAward, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_COMPENSATION_ACTIVITY_INFO, self._getInfo, self)

    self:_initUI()

    self:_initListView()

end


function ActivityCompensationLayer:updatePage( )

end


function ActivityCompensationLayer:onExit()

    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end

end

function ActivityCompensationLayer:_initUI()

    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityCompensationLayer","activity"))
    self:addChild(self._csbNode)
    self._csbNode:getSubNodeByName("ProjectNode_con"):setContentSize(display.width, display.height)
    self._csbNode:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(self._csbNode)

    self._npcPanel = self._csbNode:getSubNodeByName("Panel_npc")

    self:_updateInfo()

end

function ActivityCompensationLayer:_updateInfo()

    if not self._activity then return end

    --换NPC形象
    if self._activity.npc_pic_id > 0 then
        local knightImage = require("app.common.KnightImg").new(self._activity.npc_pic_id)
        local panelSize = self._npcPanel:getContentSize()
        knightImage:setAnchorPoint(cc.p(0.5, 0))
        knightImage:setPosition(cc.p(panelSize.width*0.17,10))

        self._npcPanel:removeAllChildren()

        self._npcPanel:addChild(knightImage)
    end

    self._csbNode:updateLabel("Text_start", {visible = false})
    self._csbNode:updateLabel("Text_end", {visible = false})
    self._csbNode:updateLabel("Text_startTime", {visible = false})
    self._csbNode:updateLabel("Text_endTime", {visible = false})

    local activity = { 
        start_time = 0, 
        end_time = 0,
        title = self._activity.name,
        desc = self._activity.info,
    }

    ActivityUIHelper.updateBaseInfo(self, activity)


end


function ActivityCompensationLayer:_initListView()

    if self._listView then
        self._listView:removeFromParent(true)
        self._listView = nil
    end 

    if self._listView == nil  then

        if not self._activity then
            return
        end

        local listviewBg = self:getSubNodeByName("Panel_listView")
        local listViewSize = listviewBg:getContentSize()
        self._listView = require("app.ui.WListView").new(listViewSize.width,listViewSize.height, 584, 138, true)
        self._listView:setCreateCell(function(view,idx)
            local cell = ActivityCompensationCell.new(handler(self, self._onGetButton))
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
function ActivityCompensationLayer:_initData()

    self._activity, self._listData = G_Me.compensationActivityData:getActivityList()

end


--更新列表
function ActivityCompensationLayer:_updateListView()
   if self._listView then 
        self._listView:setCellNums(#self._listData, false)
   end 
end


--领奖
function ActivityCompensationLayer:_onGetButton()

    if not G_Me.compensationActivityData:getHasGetAwardToday() then
        G_HandlersManager.compensationActivityHandler:sendReceiveCompensationAward()
    end

end

--获取基本信息
function ActivityCompensationLayer:_getInfo()

    self:_initData()

    self:_updateInfo()

    self:_updateListView()

end


function ActivityCompensationLayer:_getAward(data)

    if data.ret == 1 and rawget(data, "awards") then
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
        
        self:_getInfo()
        --G_Popup.awardSummary(data.awards)
        G_Popup.awardTips(data.awards)
    end

end


return ActivityCompensationLayer