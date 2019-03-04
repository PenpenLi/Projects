--
-- Author: Your Name
-- Date: 2017-08-01 12:21:44

--[===========[
	RankListArena
    竞技场排行榜列表
]===========]
local RankListBaseLayer = require "app.scenes.rank.RankListBaseLayer" 
local RankListArena=class("RankListArena",RankListBaseLayer)

local RankListArenaCell = require "app.scenes.rank.RankListArenaCell" 
local ModuleEntranceHelper = require "app.common.ModuleEntranceHelper"
local RankConst = require("app.scenes.rank.RankConst")


function RankListArena:ctor(size)
    RankListArena.super.ctor(self,size)
end

function RankListArena:_requestData()
	G_HandlersManager.rankHandler:sendGetArenaRank()
end

function RankListArena:_initDatas()
	self._dataList = G_Me.rankData:getRankListByType(RankConst.RANK_ARENA) or {}
end


function RankListArena:onEnter()
    RankListArena.super.onEnter(self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_ARENA_GET_RANK_LIST, self._updateRankView,self) --使用成功的事件监听
	-- self:_createTableView()
	-- -- 请求对应数据
 --    self:_requestData()
end

function RankListArena:onExit()
    RankListArena.super.onExit(self)
end

function RankListArena:_updateRankView()
    self:_initDatas()
    self:_checkRankNum()
    self._view:setCellNums(#self._dataList, true)
end

function RankListArena:getCell()
    return RankListArenaCell.new()
end

return RankListArena
