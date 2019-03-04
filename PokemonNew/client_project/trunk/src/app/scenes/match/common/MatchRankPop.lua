--
-- Author: yutou
-- Date: 2018-12-10 11:31:21
--
--

local MatchRankPop=class("MatchRankPop",function()
    return display.newLayer()
end)

local MatchRankPopCell = require "app.scenes.match.common.MatchRankPopCell" 
local RankConst = require("app.scenes.rank.RankConst")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local MatchPlayerData = require("app.data.MatchPlayerData")

-- local TAB_MAX_NUM = RankConst.RANK_MAX_NUM
-- local TAB_LEVEL = RankConst.RANK_LEVEL          -- 等级榜
-- local TAB_POWER = RankConst.RANK_POWER      -- 战力榜
-- local TAB_ARENA = RankConst.RANK_ARENA          -- 竞技场
-- local TAB_YANWU = RankConst.RANK_YANWU          -- 演武场
-- local TAB_YANWU_GANG = RankConst.RANK_YANWU_GANG            -- 演武场帮派
-- local TAB_BOSS = RankConst.RANK_BOSS            -- 世界boss
-- local TAB_TOWER = RankConst.RANK_TOWER      -- 武将试炼
-- local TAB_MAIN = RankConst.RANK_MAIN            -- 主线副本
-- local TAB_ELITE = RankConst.RANK_ELITE      -- 精英副本
-- local TAB_NIGHTMARE = RankConst.RANK_NIGHTMARE  -- 噩梦副本
-- local TAB_BAGN = RankConst.RANK_GUILD           -- 帮派
-- local TAB_GUILD_BATTLE = RankConst.RANK_GUILD_BATTLE  -- 帮战

function MatchRankPop:ctor( tabIndex )
    self:enableNodeEvents()
    self._csbNode = nil
    self._tabIndex = tabIndex or 1

    self._selfRank = nil
    -- self._selfstrengthTxt = nil
    -- self._selfstrength = nil
    self._loverIndex = nil
    

    self._size = 0--size
    self._view = nil --列表控件绑定

    self._dataList = {}   --数据列表
end

---UI界面初始化
function MatchRankPop:_initUI( ... )
    -- body
    self._csbNode = cc.CSLoader:createNode("csb/match/pk/MatchServerRankPop.csb")
    self:addChild(self._csbNode)
    --self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx, display.cy)
    
    ccui.Helper:doLayout(self._csbNode)

    local title = ""
    if self._tabIndex == 1 then
        title = G_Lang.get("match_rank_sea")
    elseif self._tabIndex == 2 then
        title = G_Lang.get("match_rank_pk")
    end

    -- 弹框背景设置
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("ProjectNode_common"), title, function() self:removeFromParent() end, 717)

    self._selRank = self._csbNode:getSubNodeByName("Text_rank_value")
    self._Text_rank_self = self._csbNode:getSubNodeByName("Text_rank_self")
    self._selfstrengthTxt = self._csbNode:getSubNodeByName("Text_score_self")
    self._selstrength = self._csbNode:getSubNodeByName("Text_score_value")
    self._button_lover = self._csbNode:getSubNodeByName("Button_lover")
    self._node_lover = self._csbNode:getSubNodeByName("Node_lover")
    self._node_lover:setVisible(false)
    self._selfstrengthTxt:setVisible(false)
    self._selstrength:setVisible(false)

    self._text_lover_rank = self._csbNode:getSubNodeByName("Text_lover_rank")
    self._button_lover:setVisible(false)

    local nodeBack = self._csbNode:getSubNodeByName("ProjectNode_back")
    -- local btnBack = nodeBack:getSubNodeByName("Button_back")
    -- btnBack:addClickEventListenerEx(function(sender)
    --     G_ModuleDirector:popModule()
    -- end)

    self._tabViewList = {}
    self._panelListView = self._csbNode:getSubNodeByName("Panel_con")
    self._size = self._panelListView:getContentSize()
    self._button_lover:addClickEventListenerEx(function()
        if self._loverIndex then
            self._view:setLocation(self._loverIndex,true)
        end
    end)
end

function MatchRankPop:onEnter( ... )
    -- body
    self:_initUI()
    self:_createTableView()
    -- 请求对应数据

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MATCH_GET_RANK_INFO, self._updateRankView,self) --使用成功的事件监听

    self:_requestData()
end

function MatchRankPop:onExit( ... )
    uf_eventManager:removeListenerWithTarget(self)
end

function MatchRankPop:_requestData()
	G_HandlersManager.matchHandler:sendGetRank(self._tabIndex)
end

function MatchRankPop:_updateRankView(data)
    if self._tabIndex == 1 then
        for i=1,#data.sranks do
            self._dataList[i] = MatchPlayerData.new(data.sranks[i])
        end
    elseif self._tabIndex == 2 then
        for i=1,#data.pranks do
            self._dataList[i] = MatchPlayerData.new(data.pranks[i])
        end
    end

    self._view:setCellNums(#self._dataList, true)

    --rank Text_self_rank
    local self_rank = nil--data.my_rank
    local self_score = 0
    for i=1,#self._dataList do
        if self._dataList[i].uid == G_Me.userData.id then
            self_rank = i;
            self_score = self._dataList[i].score
            break;
        end
    end

    -- if not self_rank then
    --     self._selRank:setString("")
    -- else
    if self._tabIndex == 1 then
        if self_rank and self_rank > 0 then
            self._selRank:setString(tostring(self_rank))
            self._selfstrengthTxt:setVisible(true)
            self._selstrength:setVisible(true)
            if self_score then
                self._selstrength:setString(tostring(self_score))
            end
        else
            self._selRank:setString("未上榜")
            self._selfstrengthTxt:setVisible(false)
            self._selstrength:setVisible(false)
        end
        self._selRank:setVisible(true)
        self._Text_rank_self:setVisible(true)
        -- self._button_lover:setVisible(false)
        self._node_lover:setVisible(false)
    else
        if self_rank and self_rank > 0 then
            self._selRank:setString(tostring(self_rank))
        else
            self._selRank:setString("未上榜")
        end
        self._Text_rank_self:setVisible(true)
        self._selRank:setVisible(true)
        self._selfstrengthTxt:setVisible(false)
        self._selstrength:setVisible(false)
        local loversInfo = G_Me.loversData:getLoversInfo()
        -- self._button_lover:setVisible(true)
        self._node_lover:setVisible(true)
        if loversInfo and loversInfo:getId() then
            for i=1,#self._dataList do
                if self._dataList[i].uid == loversInfo:getId() then
                    self._text_lover_rank:setString(i)
                    self._button_lover:setVisible(true)
                    self._loverIndex = i
                    break
                end
            end
        end
        if self._loverIndex == nil then
            self._text_lover_rank:setString("未上榜")
        end
    end
    



    -- -- 伤害星数等：标题/内容
    -- local txt_self_strength = ""
    -- self._selfstrengthTxt:setString(txt_self_strength)
    -- self._selfstrengthTxt:setVisible(false)

    -- local self_data = ""--G_Me.rankData:getSelfDataByType(index) -- 伤害，星数等数据
    -- self._selstrength:setString(self_data)
    -- self._selstrength:setVisible(false)
end

--创建列表控件
function MatchRankPop:_createTableView()
    local size = self._size
    self._view = require("app.ui.WListView").new(size.width,size.height,size.width,130)
                        :addTo(self._panelListView)
	                    :setPosition(3,0)
	self._view:setFirstCellPaddigTop(8)
    self._view:setCreateCell(function(view,idx)
        return MatchRankPopCell.new(self._tabIndex)
   	end)

    self._view:setUpdateCell(function(view,cell,idx)
	    cell:updateInfo(self._dataList[idx+1],idx)
	end)

	return true
end

return MatchRankPop
