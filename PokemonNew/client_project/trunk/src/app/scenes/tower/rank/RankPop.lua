--
-- Author: YouName
-- Date: 2015-10-14 15:51:20
--[[
	排行榜
]]
local RankPop=class("RankPop",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

function RankPop:ctor( ... )
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
end

function RankPop:_initUI( ... )
	-- body
	self:setPosition(display.cx, display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/tower/RankPop.csb")
	self:addChild(self._csbNode)

	--local nodeCommonPop = self._csbNode:getSubNodeByName("ProjectNode_common_pop")
	UpdateNodeHelper.updateCommonFullPop(self,G_LangScrap.get("lang_tower_rank_title"),function()
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_TOWER_RANK_POP,nil,false,false)
		self:removeFromParent(true)
	end)
end

function RankPop:_onGetRank( buffValue )
	-- body
	if(buffValue == nil or type(buffValue) ~= "table")then return end
	local panelList = self._csbNode:getSubNodeByName("Panel_list")
	local Text_my_rank = self._csbNode:getSubNodeByName("Text_my_rank")
	local dataList = buffValue.tower_daily_rank or {}
	local dataListShow = {}
	table.sort(dataList,function(a,b)
		return a.rank < b.rank
	end)
	for i=1,50 do
		local itemData = i<=#dataList and dataList[i] or nil
		dataListShow[i] = {itemData}
	end

	dump(dataList)

	-- required uint32 in_rank = 3; //玩家排名 未上榜为0
	-- required uint32 layer = 4;
	-- required uint32 stage = 5;
	local rank = buffValue.in_rank
	local star = buffValue.star

	local strRank = rank > 0 and G_LangScrap.get("lang_tower_text_rank",{rank = rank}) or G_LangScrap.get("lang_tower_no_in_rank")
	local mainKnightData = G_Me.teamData:getKnightDataByPos(1)
	local roleColor = G_TypeConverter.quality2Color(mainKnightData.cfgData.quality)
	self._csbNode:updateLabel("Text_my_rank", {text=strRank,outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})
	self._csbNode:updateLabel("Text_star", {text=star})
	self._csbNode:updateLabel("Text_my_name", {
		text=G_Me.userData.name,
		color = G_ColorsScrap.getDarkColor(roleColor),
		-- outlineColor = G_ColorsScrap.getColorOutline(roleColor),
		-- outlineSize = 2,
	})

	local panelListSize = panelList:getContentSize()
	local listview = require("app.ui.WListView").new(panelListSize.width+5,panelListSize.height,panelListSize.width,104)
	listview:setCreateCell(function(view,idx)
		return require("app.scenes.tower.rank.RankCell").new(handler(self,self._onViewHandler),handler(self,self._onIconClick))
	end)
	listview:setUpdateCell(function(view,cell,idx)
		cell:updateCell(dataListShow[idx+1], idx)
	end)
	listview:setCellNums(#dataListShow, true, 0)
	panelList:addChild(listview)
end

function RankPop:_onViewHandler( cellValue )
	-- body
	if(cellValue == nil or #cellValue < 1)then return end
	local uid = cellValue[1].user_id
	G_HandlersManager.commonHandler:sendGetCommonBattleUser(uid,2)
end

function RankPop:_onIconClick( cellValue )
	-- body
	print("Icon ========================")
	if(cellValue == nil or #cellValue < 1)then return end
	local uid = cellValue[1].user_id
	G_HandlersManager.commonHandler:sendGetCommonBattleUser(uid,1)
end

function RankPop:_onTeamViewerPop( isPop )
	-- body
    local bool = not checkbool(isPop)
    self:setVisible(bool)
end

function RankPop:onEnter( ... )
	-- body
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_TOWER_RANK_POP,nil,false,true)
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAMVIEWER_POP,self._onTeamViewerPop,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MT_GET_TOWER_RANK, self._onGetRank, self)
	self:performWithDelay(function()
		G_HandlersManager.thirtyThreeHandler:sendGetTowerDailyRank()
	end, 0.1)
end

function RankPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	uf_eventManager:removeListenerWithTarget(self)
end

return RankPop