--
-- Author: Your Name
-- Date: 2017-08-01 12:15:16
--
-- ====[[
-- 		排行榜主界面
-- ====]]
local RankLayer=class("RankLayer",function()
    return display.newLayer()
end)

local RankConst = require("app.scenes.rank.RankConst")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

local TAB_MAX_NUM = RankConst.RANK_MAX_NUM  --最大页签数量
local TAB_LEVEL = RankConst.RANK_LEVEL       	-- 等级榜
local TAB_POWER = RankConst.RANK_POWER    	-- 战力榜
local TAB_ARENA = RankConst.RANK_ARENA       	-- 竞技场
local TAB_YANWU = RankConst.RANK_YANWU 			-- 演武场
local TAB_YANWU_GANG = RankConst.RANK_YANWU_GANG 			-- 演武场帮派
local TAB_BOSS = RankConst.RANK_BOSS 			-- 世界boss
local TAB_TOWER = RankConst.RANK_TOWER 		-- 武将试炼
local TAB_MAIN = RankConst.RANK_MAIN 	 		-- 主线副本
local TAB_ELITE = RankConst.RANK_ELITE 		-- 精英副本
local TAB_NIGHTMARE = RankConst.RANK_NIGHTMARE 	-- 噩梦副本
local TAB_BAGN = RankConst.RANK_GUILD 			-- 帮派
local TAB_BAGN_MISSION = RankConst.RANK_GUILD_MISSION 			-- 帮派

--map(KEY-VALUE)
RankLayer.TABMENU = {}
RankLayer.TABMENU[RankConst.RANK_LEVEL] = {tab1 = RankConst.TAB_TYPE_HERO,			tab2 = RankConst.TAB_SEC_LEVEL,fun_id = G_FunctionConst.FUNC_RANK_LEVEL}
RankLayer.TABMENU[RankConst.RANK_POWER] = {tab1 = RankConst.TAB_TYPE_HERO,			tab2 = RankConst.TAB_SEC_POWER,fun_id = G_FunctionConst.FUNC_RANK_POWER}
RankLayer.TABMENU[RankConst.RANK_ARENA] = {tab1 = RankConst.TAB_TYPE_BATTLE,		tab2 = RankConst.TAB_SEC_ARENA,fun_id = G_FunctionConst.FUNC_RANK_ARENA}
RankLayer.TABMENU[RankConst.RANK_YANWU] = {tab1 = RankConst.TAB_TYPE_BATTLE,		tab2 = RankConst.TAB_SEC_YANWU_P,fun_id = G_FunctionConst.FUNC_RANK_YANWU}
RankLayer.TABMENU[RankConst.RANK_YANWU_GANG] = {tab1 = RankConst.TAB_TYPE_BATTLE,	tab2 = RankConst.TAB_SEC_YANWU_G,fun_id = G_FunctionConst.FUNC_RANK_YANWU}
RankLayer.TABMENU[RankConst.RANK_BOSS] = {tab1 = RankConst.TAB_TYPE_ADVENTURE,		tab2 = RankConst.TAB_SEC_WORLD_BOSS,fun_id = G_FunctionConst.FUNC_RANK_BOSS}
RankLayer.TABMENU[RankConst.RANK_TOWER] = {tab1 = RankConst.TAB_TYPE_ADVENTURE,		tab2 = RankConst.TAB_SEC_TOWER,fun_id = G_FunctionConst.FUNC_RANK_TOWER}
RankLayer.TABMENU[RankConst.RANK_MAIN] = {tab1 = RankConst.TAB_TYPE_MISSION,		tab2 = RankConst.TAB_SEC_MISSION_NORMAL,fun_id = G_FunctionConst.FUNC_RANK_MISSION_MAIN}
RankLayer.TABMENU[RankConst.RANK_ELITE] = {tab1 = RankConst.TAB_TYPE_MISSION,		tab2 = RankConst.TAB_SEC_MISSION_ELITE,fun_id = G_FunctionConst.FUNC_RANK_MISSION_ELITE}
RankLayer.TABMENU[RankConst.RANK_NIGHTMARE] = {tab1 = RankConst.TAB_TYPE_MISSION,	tab2 = RankConst.TAB_SEC_MISSION_NIGHTMARE,fun_id = G_FunctionConst.FUNC_RANK_MISSION_NIGHTMARE}
RankLayer.TABMENU[RankConst.RANK_GUILD] = {tab1 = RankConst.TAB_TYPE_GANG,			tab2 = RankConst.TAB_SEC_GANG,fun_id = G_FunctionConst.FUNC_RANK_GUILD}
RankLayer.TABMENU[RankConst.RANK_GUILD_MISSION] = {tab1 = RankConst.TAB_TYPE_GANG,	tab2 = RankConst.TAB_SEC_GANG_MISSION,fun_id = G_FunctionConst.FUNC_RANK_GUILD}

RankLayer.M_TAB = {}
RankLayer.M_TAB[RankConst.TAB_TYPE_HERO] = {RankConst.RANK_LEVEL,RankConst.RANK_POWER}
RankLayer.M_TAB[RankConst.TAB_TYPE_MISSION] = {RankConst.RANK_MAIN,RankConst.RANK_ELITE,RankConst.RANK_NIGHTMARE}
RankLayer.M_TAB[RankConst.TAB_TYPE_ADVENTURE] = {RankConst.RANK_BOSS,RankConst.RANK_TOWER}
RankLayer.M_TAB[RankConst.TAB_TYPE_BATTLE] = {RankConst.RANK_ARENA,RankConst.RANK_YANWU,RankConst.RANK_YANWU_GANG}
RankLayer.M_TAB[RankConst.TAB_TYPE_GANG] = {RankConst.RANK_GUILD,RankConst.RANK_GUILD_MISSION}


function RankLayer:ctor( tabIndex )
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
	self._initIndex = tabIndex or RankConst.RANK_LEVEL
	self._subIndex = nil
	--self._secIndex = 1

	self._selfRank = nil
	self._selfstrengthTxt = nil
	self._selfstrength = nil
    G_Me.rankData.noNeedFresh = false
	
	--------------------
end

---UI界面初始化
function RankLayer:_initUI( ... )
	-- body
	self._csbNode = cc.CSLoader:createNode("csb/rank/RankLayer.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

	local image_bg = self._csbNode:getSubNodeByName("Image_bg_all")
    G_WidgetTools.autoTransformBg(image_bg)

	self._selRank = self._csbNode:getSubNodeByName("Text_self_rank")
	self._selfstrengthTxt = self._csbNode:getSubNodeByName("Text_self_power_title")
	self._selstrength = self._csbNode:getSubNodeByName("Text_self_power")

	local nodeBack = self._csbNode:getSubNodeByName("ProjectNode_back")
	local btnBack = nodeBack:getSubNodeByName("Button_back")
	btnBack:addClickEventListenerEx(function(sender)
		G_ModuleDirector:popModule()
	end)

	self._tabViewList = {}
	self._panelListView = self._csbNode:getSubNodeByName("Panel_list")
	-------------- 创建标签页
	local funcOpen = {}
	local noOpenTip = {}
	-- funcOpen[TAB_LEVEL],noOpenTip[TAB_LEVEL] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_LEVEL)
	-- funcOpen[TAB_POWER],noOpenTip[TAB_POWER] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_POWER)
	-- funcOpen[TAB_ARENA],noOpenTip[TAB_ARENA] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_ARENA)
	-- funcOpen[TAB_YANWU],noOpenTip[TAB_YANWU] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_YANWU)
	-- funcOpen[TAB_YANWU_GANG],noOpenTip[TAB_YANWU_GANG] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_YANWU)
	-- funcOpen[TAB_BOSS],noOpenTip[TAB_BOSS] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_BOSS)
	-- funcOpen[TAB_TOWER],noOpenTip[TAB_TOWER] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_TOWER)
	-- funcOpen[TAB_MAIN],noOpenTip[TAB_MAIN] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_MISSION_MAIN)
	-- funcOpen[TAB_ELITE],noOpenTip[TAB_ELITE] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_MISSION_ELITE)
	-- funcOpen[TAB_NIGHTMARE],noOpenTip[TAB_NIGHTMARE] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_MISSION_NIGHTMARE)
	-- funcOpen[TAB_BAGN],noOpenTip[TAB_BAGN] = G_Responder.funcIsOpened(G_FunctionConst.FUNC_RANK_GUILD)
	local tabs = {}
	for i=1,5 do
		tabs[i] = {text = G_Lang.get("rank_tab_type"..tostring(i)),noOpen = false,noOpenTips = ""}
	end
	
	local nodeTabButtons = self._csbNode:getSubNodeByName("ProjectNode_tab_buttons")
	--nodeTabButtons:setPositionX(10)
	local params = {
		tabs = tabs,
		isBig = true,
		scrollRect = cc.rect(10, 0, 608, 0)
	}
	
	self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(nodeTabButtons,params,handler(self,self._onFirstTabChange))
	--self._tabButtons.setSelected(self._tabIndex)

	self._secTabNode = self._csbNode:getSubNodeByName("lower_tab_buttons")
	

	self:_initTab()
	-- if self._tabIndex == TAB_MAX_NUM then
	-- 	self._tabButtons.setScrollPercent(100)
	-- elseif self._tabIndex > 4 then
	-- 	local percent = self._tabIndex/TAB_MAX_NUM * 100
 -- 		self._tabButtons.setScrollPercent(percent)
	-- end
end

function RankLayer:_initTab()
	local initIndex = self._initIndex or self._tabIndex
	if initIndex then
		--self._tabButtons.setSelected(RankLayer.TABMENU[initIndex]["tab" .. self._secIndex])
		self._tabButtons.setSelected(RankLayer.TABMENU[initIndex]["tab1"])
	end
end

---------切换标签页
function RankLayer:_onFirstTabChange( index )
	-- body
	self._firstIndex = index

	if self._initIndex == nil then --非第一次
		self._secIndex = 1
	else
		self._secIndex = RankLayer.TABMENU[self._initIndex].tab2
		self._initIndex = nil
	end
	
	local tabData = RankLayer.M_TAB[self._firstIndex]
	local tabs = {}
	for i=1,#tabData do
		local key = tabData[i]
		local fun_id = RankLayer.TABMENU[key].fun_id

		local open,errTip = G_Responder.funcIsOpened(fun_id)
		tabs[i] = {text = G_Lang.get("rank_tab_title"..tostring(self._firstIndex).."_"..tostring(i)),noOpen = not open,noOpenTips = errTip}
	end

	local params = {
		tabs = tabs,
		isBig = false,
	}
	self._secTabButtons = require("app.common.TabButtonsHelper").updateTabButtons(self._secTabNode,params,handler(self,self._onSecTabChange))

	if self._subIndex ~= nil then -- 用于切磋返回
		self._secIndex = self._subIndex
		self._subIndex = nil
	end
	self._secTabButtons.setSelected(self._secIndex)

	-- 非第一次的情况下才发送引导步骤
	-- if not self._firstTime then
	-- 	self._firstTime = true
	-- else
	-- 	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
	-- end

end

function RankLayer:_onSecTabChange( index )
	self._secIndex = index

	local key_index = RankLayer.M_TAB[self._firstIndex][self._secIndex]
	self:_updateList(key_index)
end

function RankLayer:_updateList( index )
	self._tabIndex = index
	for k,v in pairs(self._tabViewList) do
		v:setVisible(false)
	end

	local listView = self._tabViewList["key_"..tostring(index)]
	local size = self._panelListView:getContentSize()
	if index >= TAB_MAIN and index <= TAB_NIGHTMARE  then
		if(listView == nil)then
			local ch_type_map = {
				[TAB_MAIN] = 1,
				[TAB_ELITE] = 2,
				[TAB_NIGHTMARE] = 3,
			}
		    listView = require("app.scenes.rank.RankListMission").new(size,ch_type_map[index])
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_LEVEL then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListLevel").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_POWER then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListPower").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_BOSS then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListWorldBoss").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_ARENA then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListArena").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_YANWU then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListYanwu").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_YANWU_GANG then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListYanwuGang").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_TOWER then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListTower").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_BAGN then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListGuild").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	elseif index == TAB_BAGN_MISSION then
		if(listView == nil)then
		    listView = require("app.scenes.rank.RankListGuildMission").new(size)
		    self._panelListView:addChild(listView)
		    self._tabViewList["key_"..tostring(index)] = listView
		end
	end

	if listView ~= nil then
		listView:setVisible(true)
		self:updateSelfRank(index)
	end
end

-- self rank shows num within 200, and show "未上榜" if it's out of 200
function RankLayer:updateSelfRank(idx)
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
	elseif index == TAB_BAGN_MISSION then
		txt_self_strength = G_Lang.get("rank_self_gang_mission_pro")
	end
	print("updateSelfRank",txt_self_strength)
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
end

function RankLayer:onEnter( ... )
	dump(self._subIndex)
	if self._subIndex == nil then
		self:_initUI()
	end
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_UPDATE_SELF_RANK_DATA, self.updateSelfRank, self)
end

function RankLayer:onExit( ... )
	dump("RankLayer:onExit( ... )!!!!!!!!!")
    uf_eventManager:removeListenerWithTarget(self)

    self._subIndex = self._secIndex
    G_Me.rankData.noNeedFresh = true
end

return RankLayer