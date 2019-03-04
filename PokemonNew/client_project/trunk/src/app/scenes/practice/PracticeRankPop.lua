--
-- Author: suNSun
-- Date: 2018-02-09 12:18:58

--[===========[
	PracticeRankPop
    演武场排行榜列表   
]===========]

local PracticeRankPop=class("PracticeRankPop",function()
    return display.newLayer()
end)

local PracticeRankPopCell = require "app.scenes.practice.PracticeRankCell" 
local ModuleEntranceHelper = require "app.common.ModuleEntranceHelper"
local RankConst = require("app.scenes.rank.RankConst")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

local TAB_MAX_NUM = RankConst.RANK_MAX_NUM
local TAB_LEVEL = RankConst.RANK_LEVEL          -- 等级榜
local TAB_POWER = RankConst.RANK_POWER      -- 战力榜
local TAB_ARENA = RankConst.RANK_ARENA          -- 竞技场
local TAB_YANWU = RankConst.RANK_YANWU          -- 演武场
local TAB_YANWU_GANG = RankConst.RANK_YANWU_GANG            -- 演武场帮派
local TAB_BOSS = RankConst.RANK_BOSS            -- 世界boss
local TAB_TOWER = RankConst.RANK_TOWER      -- 武将试炼
local TAB_MAIN = RankConst.RANK_MAIN            -- 主线副本
local TAB_ELITE = RankConst.RANK_ELITE      -- 精英副本
local TAB_NIGHTMARE = RankConst.RANK_NIGHTMARE  -- 噩梦副本
local TAB_BAGN = RankConst.RANK_GUILD           -- 帮派
local TAB_GUILD_BATTLE = RankConst.RANK_GUILD_BATTLE  -- 帮战

function PracticeRankPop:ctor( tabIndex )
    -- body
    self:enableNodeEvents()
    self._csbNode = nil
    self._tabIndex = tabIndex or 1

    self._selfRank = nil
    self._selfstrengthTxt = nil
    self._selfstrength = nil
    

    self._size = 0--size
    self._view = nil --列表控件绑定
    self._emptyBoard = nil
    self._isFirst = true

    self._dataList = {}   --数据列表
    --------------------
end

---UI界面初始化
function PracticeRankPop:_initUI( ... )
    -- body
    self._csbNode = cc.CSLoader:createNode("csb/practice/PracticeRankPop.csb")
    self:addChild(self._csbNode)
    --self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx, display.cy)
    
    ccui.Helper:doLayout(self._csbNode)

    -- 弹框背景设置
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("ProjectNode_common"), "排行榜", function() self:removeFromParent() end, 717)

    self._selRank = self._csbNode:getSubNodeByName("Text_rank_value")
    self._Text_rank_self = self._csbNode:getSubNodeByName("Text_rank_self")
    self._selfstrengthTxt = self._csbNode:getSubNodeByName("Text_score_self")
    self._selstrength = self._csbNode:getSubNodeByName("Text_score_value")

    local nodeBack = self._csbNode:getSubNodeByName("ProjectNode_back")
    -- local btnBack = nodeBack:getSubNodeByName("Button_back")
    -- btnBack:addClickEventListenerEx(function(sender)
    --     G_ModuleDirector:popModule()
    -- end)

    self._tabViewList = {}
    self._panelListView = self._csbNode:getSubNodeByName("Panel_con")
    self._size = self._panelListView:getContentSize()
end

-- self rank shows num within 200, and show "未上榜" if it's out of 200
function PracticeRankPop:updateSelfRank(idx)
    local index = idx or self._tabIndex
    print("index,idx",index,self._tabIndex)
    local txt_self_strength = ""
    if index == TAB_TOWER or (index >= TAB_MAIN and index <= TAB_NIGHTMARE) then
        txt_self_strength = G_Lang.get("rank_self_star")
    elseif index == TAB_LEVEL then
        txt_self_strength = G_Lang.get("rank_self_level")
    elseif index == TAB_POWER or index == TAB_ARENA then
        txt_self_strength = G_Lang.get("rank_self_power")
    elseif index == TAB_YANWU then
        txt_self_strength = G_Lang.get("rank_self_personal_point")
    elseif index == TAB_YANWU_GANG then
        txt_self_strength = G_Lang.get("rank_self_gang_point")
    elseif index == TAB_BOSS then
        txt_self_strength = G_Lang.get("rank_self_hurt")
    elseif index == TAB_BAGN then
        txt_self_strength = G_Lang.get("rank_self_gang_level")
    elseif index == TAB_GUILD_BATTLE then
        txt_self_strength = G_Lang.get("rank_self_gang_power")
    end

    --rank Text_self_rank
    local self_rank = G_Me.rankData:getSelfRankByType(index)
    local self_data = G_Me.rankData:getSelfDataByType(index) -- 伤害，星数等数据
    if not self_rank then
        self._selRank:setString("")
    elseif self_rank > 0 then
        self._selRank:setString(tostring(self_rank))
    else
        self._selRank:setString("未上榜")
    end
    
    -- 伤害星数等：标题/内容
    self._selfstrengthTxt:setString(txt_self_strength)
    self._selstrength:setString(self_data)

    self._selRank:setVisible(true)
    self._Text_rank_self:setVisible(true)
    self._selfstrengthTxt:setVisible(true)
    self._selstrength:setVisible(true)
end

function PracticeRankPop:onEnter( ... )
    -- body
    self:_initUI()
    self:_createTableView()
    -- 请求对应数据
    self:_requestData()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_UPDATE_SELF_RANK_DATA, self.updateSelfRank, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_YANWU_GET_RANK_INFO, self._updateRankView,self) --使用成功的事件监听
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_YANWU_GANG_GET_RANK_INFO, self._updateRankView,self) --使用成功的事件监听
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_WORLDBOSS_GET_RANK_LIST, self._updateRankView,self) --使用成功的事件监听
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RANK_DATA, self._updateRankView,self) --使用成功的事件监听
end

function PracticeRankPop:onExit( ... )
    uf_eventManager:removeListenerWithTarget(self)
end

function PracticeRankPop:_requestData()
    local index = self._tabIndex
    if index == TAB_TOWER or (index >= TAB_MAIN and index <= TAB_NIGHTMARE) then
    elseif index == TAB_LEVEL then
    elseif index == TAB_POWER or index == TAB_ARENA then
    elseif index == TAB_YANWU then
        G_HandlersManager.rankHandler:sendYanwuRank()
    elseif index == TAB_YANWU_GANG then
        G_HandlersManager.rankHandler:sendYanwuGangRank()
    elseif index == TAB_BOSS then
        G_HandlersManager.rankHandler:sendGetWorldBossRank()
    elseif index == TAB_BAGN then
    elseif index == TAB_GUILD_BATTLE then
        G_HandlersManager.guildBattleHandler:sendGetCityGuildPowerRank()
    end
end

function PracticeRankPop:_initDatas()
	self._dataList = G_Me.rankData:getRankListByType(self._tabIndex) or {}
    dump(self._dataList)
end

function PracticeRankPop:_updateRankView()
    if not self._isFirst then
        return
    end

    self._isFirst = false
    self:_initDatas()
    self._view:setCellNums(#self._dataList, true)
end

--创建列表控件
function PracticeRankPop:_createTableView()
    local size = self._size
    self._view = require("app.ui.WListView").new(size.width,size.height,size.width,130)
                        :addTo(self._panelListView)
	                    :setPosition(3,0)
	self._view:setFirstCellPaddigTop(8)
    self._view:setCreateCell(function(view,idx)
        return PracticeRankPopCell.new()
   	end)

    self._view:setUpdateCell(function(view,cell,idx)
	    cell:updateInfo(self._dataList[idx+1],idx)
	end)

	return true
end



return PracticeRankPop
