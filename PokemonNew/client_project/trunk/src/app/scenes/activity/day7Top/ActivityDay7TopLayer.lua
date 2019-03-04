--ActivityDay7TopLayer.lua

--[====================[

    7日战斗榜layer
    
]====================]


local ActivityDay7TopLayer = class("ActivityDay7TopLayer", function()
    return ccui.Layout:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require ("app.common.TypeConverter")
local ActivityConst = require("app.const.ActivityConst")
local ActivityUIHelper = require("app.scenes.activity.ActivityUIHelper")
local TextHelper = require ("app.common.TextHelper")
local ActivityDay7TopCell = require("app.scenes.activity.day7Top.ActivityDay7TopCell")
local ActivityDay7TopAwardCell = require("app.scenes.activity.day7Top.ActivityDay7TopAwardCell")

local LIST_NUM = 2  --列表个数

function ActivityDay7TopLayer:ctor()

    self._csbNode = nil       

    self._curTabIndex = 1

    self._rankListData = {}
    self._rankListView = {}     

    self._npcPanel = nil
    self._listViewPanel = nil

    self._firstEnter = true

    self:enableNodeEvents()

end


function ActivityDay7TopLayer:onEnter()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SEVENDAYS_GET_RANK_LIST, self._getRankList, self)

    self:_initUI()

    --从排行榜跳转到其他模块返回  不重复请求
    if self._firstEnter then
        self._firstEnter = false

        if G_Me.days7TopData:isExpired() then
            --self:performWithDelay(function ( ... )
                G_HandlersManager.days7ActivityHandler:sendGetRankList()
            --end, 0.1)
        else
            self:_getRankList(true)
        end

    end

end

function ActivityDay7TopLayer:onExit()

    for i = 1,LIST_NUM do 
        self._rankListData[i] = nil
    end

    for i=1, LIST_NUM do
        self._rankListView[i] = nil
    end


    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end

end

function ActivityDay7TopLayer:updatePage( )

end



function ActivityDay7TopLayer:_initUI()

    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityDay7TopLayer","activity"))
    self:addChild(self._csbNode)
    self._csbNode:getSubNodeByName("ProjectNode_con"):setContentSize(display.width, display.height)
    self._csbNode:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(self._csbNode)

    self._listViewPanel = self._csbNode:getSubNodeByName("Panel_listView")

    self._npcPanel = self._csbNode:getSubNodeByName("Panel_npc")

    self:_initTabBtns()

    self:_updateInfo()

end

--初始化tab按钮
function ActivityDay7TopLayer:_initTabBtns()

    --tab页签按钮数组
    local tabs = {}

    for i=1, LIST_NUM do
        tabs[i] =  {text = G_LangScrap.get("days7_top_title"..i)}
    end

    local nodeTabButtons = self._csbNode:getSubNodeByName("ProjectNode_tab_common")
    local params = {
        tabs = tabs,
        defaultIndex = self._curTabIndex,
        isBig = false,
        tabsOffsetX = 85
    }
    
    require("app.common.TabButtonsHelper").updateTabButtons(nodeTabButtons,params,handler(self,self._onTabBtnChange))

end

function ActivityDay7TopLayer:_onTabBtnChange(index)
    
    self._curTabIndex = index

    self:_updateView()
end


--排名战力信息
function ActivityDay7TopLayer:_updateRankInfo()


    self:updateLabel("Text_myPower", {
        text = TextHelper.getAmountText(G_Me.days7TopData:getMyPower()),
    })

    local rankValue = G_Me.days7TopData:getMyRank()
    if rankValue == 0 then 
        rankValue = G_LangScrap.get("lang_tower_no_in_rank")
    end

    self:updateLabel("Text_myRank", {
        text = tostring(rankValue),
    })

    local isReward = G_Me.days7TopData:isReward()

    local rankLable = self:getSubNodeByName("Text_myRank")
    local rankTextLable = self:getSubNodeByName("Text_rank")
    local powerLable = self:getSubNodeByName("Text_myPower")
    local powerTextLable = self:getSubNodeByName("Text_power")

    local myPowerString = G_LangScrap.get("days7_top_my_power")
    local myRankString = G_LangScrap.get("days7_top_my_rank")

    if isReward then
        myPowerString = G_LangScrap.get("days7_top_when_end")..myPowerString
        myRankString = G_LangScrap.get("days7_top_when_end")..myRankString     
    end

    powerTextLable:setString(myPowerString)
    rankTextLable:setString(myRankString)

    if isReward and G_Me.days7TopData:getMyRank() == 0 then
        powerTextLable:setVisible(false)
        powerLable:setVisible(false)
    else
        powerTextLable:setVisible(true)
        powerLable:setVisible(true) 
    end

    rankTextLable:setPositionX(rankLable:getPositionX() - rankLable:getContentSize().width )
    powerLable:setPositionX(powerTextLable:getPositionX() + powerTextLable:getContentSize().width )

end


function ActivityDay7TopLayer:_updateView()

    if not self._rankListData[self._curTabIndex] then
        return
    end
    
    --避免重复创建列表
    if not self._rankListView[self._curTabIndex] then
        self:_initListView()
    end


    for i=1, LIST_NUM do
        if self._rankListView[i] then
            self._rankListView[i]:setVisible(false)
            if i == self._curTabIndex then
                self._rankListView[i]:setVisible(true)
            end
        end
    end

end


--初始化默认listview
function ActivityDay7TopLayer:_initListView()

    if self._rankListView[self._curTabIndex] then return end

    local viewW = self._listViewPanel:getContentSize().width
    local viewH = self._listViewPanel:getContentSize().height - 72
    local cellW = 584   --cell ccb 设定size
    local cellH = 138

    if self._curTabIndex == 1 then
        cellH = 110
    end

    self._rankListView[self._curTabIndex] = require("app.ui.WListView").new(
        viewW, viewH, cellW, cellH, true)
    self._rankListView[self._curTabIndex]:setFirstCellPaddigTop(8)
    
    if self._curTabIndex == LIST_NUM then
        self._rankListView[self._curTabIndex]:setCreateCell(function(list,index)
            local cell = ActivityDay7TopAwardCell.new()        
            return cell
        end)

        self._rankListView[self._curTabIndex]:setUpdateCell(function(list,cell,index)
            if cell and index < #self._rankListData[LIST_NUM] then
                cell:updateData(self._rankListData[LIST_NUM][index+1], index+1)
            end 
        end)
      
    else
        self._rankListView[self._curTabIndex]:setCreateCell(function(list,index)
            local cell = ActivityDay7TopCell.new()
            return cell
        end)

        self._rankListView[self._curTabIndex]:setUpdateCell(function(list,cell,index)
            if cell and index < #self._rankListData[1] then
                cell:updateData(self._rankListData[1][index+1], index+1)
            end
        end)
    end

    if self._rankListData[self._curTabIndex] then
        self._rankListView[self._curTabIndex]:setCellNums(#self._rankListData[self._curTabIndex], true)
    end

    self._rankListView[self._curTabIndex]:setPositionY(72)
    self._listViewPanel:addChild(self._rankListView[self._curTabIndex])

end


function ActivityDay7TopLayer:_updateInfo()

    --换NPC形象
    local knightImage = require("app.common.KnightImg").new(1422)
    local panelSize = self._npcPanel:getContentSize()
    knightImage:setAnchorPoint(cc.p(0.5, 0))
    knightImage:setPosition(cc.p(panelSize.width*0.17,10))

    self._npcPanel:removeAllChildren()
    self._npcPanel:addChild(knightImage)


    local _, end_time, reward_time = G_Me.days7TopData:getTimeInfo()

    local activity = { 
        start_time = end_time, 
        end_time = reward_time,
        title = G_LangScrap.get("days7_top_title"),
        desc = "",--G_LangScrap.get("days7_top_desc"),
        start_text = G_LangScrap.get("days7_activity_close_time"),
        end_text = G_LangScrap.get("days7_activity_reward_time"),
    }

    ActivityUIHelper.updateBaseInfo(self, activity)

    --调整时间信息位置
    local startTimeLable = self._csbNode:getSubNodeByName("Text_startTime")
    local endTimeLable = self._csbNode:getSubNodeByName("Text_endTime")
    local startLable = self._csbNode:getSubNodeByName("Text_start")
    local endLable = self._csbNode:getSubNodeByName("Text_end")

    local isReward = G_Me.days7TopData:isReward()

    if not isReward then
    	endTimeLable:setVisible(false)
    	endLable:setVisible(false)
    	startTimeLable:setPositionY((startTimeLable:getPositionY() + endTimeLable:getPositionY())/2)
    	startLable:setPositionY(startTimeLable:getPositionY())
    else
    	startTimeLable:setVisible(false)
    	startLable:setVisible(false)
    	endTimeLable:setPositionY((startTimeLable:getPositionY() + endTimeLable:getPositionY())/2)
    	endLable:setPositionY(endTimeLable:getPositionY())
    end

    
    self:updateLabel("Text_awardTips1", {
        color = G_ColorsScrap.COLOR_POPUP_SPECIAL_NOTE,
        outlineColor =  G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self:updateLabel("Text_awardTips0_0", {
        outlineColor =  G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})
    self:updateLabel("Text_awardTips0_1", {
        outlineColor =  G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})
    self:updateLabel("Text_awardTips0_2", {
        outlineColor =  G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    -- local descLable = self._csbNode:getSubNodeByName("Text_desc")
    -- descLable:setString("")
    -- descLable:removeAllChildren()

    -- local richText = ccui.RichText:createWithContent(G_LangScrap.get("days7_top_desc_rich"))
    -- richText:formatText()
    -- richText:setAnchorPoint(cc.p(0,0.5))
    -- local size = richText:getVirtualRendererSize()
    -- richText:setPosition(cc.p(-90, 50))

    -- richText:ignoreContentAdaptWithSize(true)
    -- richText:setContentSize(cc.size(280,size.height))

    -- descLable:addChild(richText)

    self:updateLabel("Text_power", {
        text = "",
        color = G_ColorsScrap.COLOR_SCENE_TIP,
        fontSize = 22, 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self:updateLabel("Text_rank", {
        text = "",
        color = G_ColorsScrap.COLOR_SCENE_TIP,
        fontSize = 22, 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self:updateLabel("Text_myPower", {
        text = "",
        color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
        fontSize = 22, 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self:updateLabel("Text_myRank", {
        text = "",
        color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
        fontSize = 22, 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

end


function ActivityDay7TopLayer:_initRankAwardData( ... )
    
    if self._rankListData[2] then return end

    -- local ranking_list = require("app.cfg.days7_top_info")

    self._rankListData[2] = {}

    -- for i = 1, ranking_list.getLength() do
    --     local info = ranking_list.get(i)
    --     table.insert(self._rankListData[2],info)
    -- end

end


--获取排行榜数据
function ActivityDay7TopLayer:_getRankList(noAni)

    local tableNoAni = false --noAni or false

    self._rankListData[1] = G_Me.days7TopData:getRankList()

    self:_initRankAwardData()

    self:_updateView()

    self:_updateRankInfo()

    if self._rankListView[self._curTabIndex] then
        self._rankListView[self._curTabIndex]:setCellNums(#self._rankListData[self._curTabIndex], tableNoAni)
    end

end


return ActivityDay7TopLayer