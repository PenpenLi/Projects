--
-- Author: wyx
-- Date: 2018-04-29 16:12:18

--RankRewardPopup.lua
--[====================[

    帮派副本排名奖励预览面板
    
]====================]

local RankRewardPopup =  class("RankRewardPopup",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local RankRewardCell = require("app.scenes.match.common.RankRewardCell")

local LIST_NUM = 2  --列表个数

function RankRewardPopup:ctor(rank_type)
    self:enableNodeEvents()

    self._curTabIndex = 1
    self._rank_type = rank_type
    self._csbNode = nil

    self._rankListData = {}
    self._rankListView = {}

    self._rankAwardData = {}   --排行奖励
end

function RankRewardPopup:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("WorldBossRewardPanel","worldBoss"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx,display.cy)
    ccui.Helper:doLayout(self._csbNode)

    local titleName = ""
    if self._rank_type == 1 then
        titleName = G_Lang.get("match_reward_title_1")
    else
        titleName = G_Lang.get("match_reward_title_2")
    end

    UpdateNodeHelper.updateCommonNormalPop(self,titleName,nil,744)

    self._dataList = G_Me.matchData:getRewards(self._rank_type)

    local cellNum = #self._dataList
    -- 列表创建
    local panelCon = self._csbNode:getSubNodeByName("Panel_list")
    local size = panelCon:getContentSize()

    self._scrollList = require("app.ui.WListView").new(size.width,size.height,size.width,150)
    self._scrollList:setCreateCell(function(list,index)
        local cell = RankRewardCell.new()
        return cell
    end)

    self._scrollList:setUpdateCell(function(list,cell,index)
        cell:updateData(self._dataList[index+1])
    end)

    self._scrollList:setCellNums(cellNum, true)
    panelCon:addChild(self._scrollList)
end

function RankRewardPopup:onEnter()
    self:_initUI()
end

function RankRewardPopup:onExit()
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

return RankRewardPopup