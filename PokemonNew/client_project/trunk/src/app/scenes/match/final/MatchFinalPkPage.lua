--
-- Author: yutou
-- Date: 2018-04-26 16:31:43
--
local MatchFinalPkPage = class("MatchFinalPkPage",function ()
    return ccui.Layout:create()
end)

local MatchFinalPkData = require("app.data.MatchFinalPkData")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local ShaderUtils = require("app.common.ShaderUtils")
local MyGuessPop = import(".MyGuessPop")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local MatchGuessList = import(".MatchGuessList")
local SchedulerHelper = require "app.common.SchedulerHelper"

local LINE_MAP = {
	[2] = {{1},{2}},
	[4] = {{1},{2},{3},{4},{1,2},{3,4}},
	[8] = {
		{1},{2},{3},{4},{5},{6},{7},{8},
		{1,2},{3,4},{5,6},{7,8},
		{1,2,3,4},{5,6,7,8},
		},
}

local BIGGROUP_NAME_MAP = {
	[1] = "A",
	[2] = "B",
	[3] = "C",
	[4] = "D",
}

MatchFinalPkPage.LAYER_TREE = 1
MatchFinalPkPage.LAYER_LIST = 2

function MatchFinalPkPage:ctor(data,progress)
	self._data = data
	self._progress = progress
    self._inited = false
end

function MatchFinalPkPage:init()
	if self._inited then
		return
	end
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PKPopPage","match/pk"))
	-- self._csbNode:setContentSize(display.width,display.height)
	-- self._csbNode:setPosition(display.cx,display.cy)
	-- ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

    self._node_con = self._csbNode:getSubNodeByName("Node_con")

    self._showNum = #self._showDataList

    self._csbLine = nil
    self._csbLine = cc.CSLoader:createNode(G_Url:getCSB("PK" .. self._showNum,"match/pk"))
    self._csbLine:addTo(self._node_con)

    self._text_win_title = self._csbNode:getSubNodeByName("Text_title_winer")

    self._node_pklist = self._csbNode:getSubNodeByName("Node_pklist")
    self._node_pktree = self._csbNode:getSubNodeByName("Node_pktree")

    self._panel_con = self._csbNode:getSubNodeByName("Panel_con")
	self:render()
    self._inited = true
end

function MatchFinalPkPage:updatePage(bigGroup,smallGroup,curLayer)
	if self._delayHandle then
		SchedulerHelper.cancelSchedule(self._delayHandle)
		self._delayHandle = nil
	end
	self._showData = self._data:getShowData(self._progress,bigGroup,smallGroup)
	self._showDataList = self._data:getDataList(self._showData)
	self._bigGroup = bigGroup
	self._smallGroup = smallGroup
	self._iconList = {}
	self._curLayer = curLayer
	self:init()
	self:_renderLayer()
end

function MatchFinalPkPage:updatePageDelay(bigGroup,smallGroup,curLayer)
	self._delayHandle = SchedulerHelper.newScheduleOnce(function()
		self._delayHandle = nil
		self:updatePage(bigGroup,smallGroup,curLayer)
	end, 1)
end

function MatchFinalPkPage:render()
    for i=1,#LINE_MAP[self._showNum] do
    	local isFaile = false
    	local checkList = LINE_MAP[self._showNum][i]
    	isFaile = self._data:checkFaile(self._showData,checkList)

    	local lineName = "Sprite_line"
    	for i=1,#checkList do
    		lineName = lineName .. "_" .. checkList[i]
    	end

    	if isFaile then
    		ShaderUtils.applyGrayFilter(self._csbNode:getSubNodeByName(lineName))
    	else
    		ShaderUtils.removeFilter(self._csbNode:getSubNodeByName(lineName))
    	end
    end

    for i=1,#self._showDataList do
    	local data = self._showDataList[i]
    	local iconCon = self._csbNode:getSubNodeByName("Node_"..i)
    	if self._iconList[i] == nil then
	    	local item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
    		self._iconList[i] = item
			item:addTo(iconCon)
    	end
		local param = {}
		param.nameVisible = true
		param.type = G_TypeConverter.TYPE_KNIGHT
		param.value = data.knight
		param.sizeVisible = false
		param.scale = UpdateNodeHelper.NODE_SCALE_70
		param.name = data.name
		UpdateNodeHelper.updateCommonIconItemNode(self._iconList[i], param)
    end


	local name = ""
	if self._smallGroup == nil then
		name = BIGGROUP_NAME_MAP[self._bigGroup]
	else
		name = BIGGROUP_NAME_MAP[self._bigGroup] .. self._smallGroup
	end
	
	local winName = ""
	if self._progress ~= 3 then
		winName = G_Lang.get("match_pk_win",{group = name})
	else
		winName = G_Lang.get("match_pk_final_win")
	end
    self._text_win_title:setString(winName)

    ---------------------------------------------------------
    local myGuessData = self._data:getPkGuess()
    self._matchGuessList = MatchGuessList.new(myGuessData,self._panel_con)
    self._matchGuessList:render()

    self:_renderLayer()
end

function MatchFinalPkPage:updateLayer( curLayer )
	if self._curLayer ~= curLayer then
		self._curLayer = curLayer
	    self:_renderLayer()
	end
end

function MatchFinalPkPage:_renderLayer()
	if self._curLayer == MatchFinalPkPage.LAYER_TREE then
		if self._node_pklist then
	    	self._node_pklist:setVisible(false)
		end
		if self._node_pktree then
	    	self._node_pktree:setVisible(true)
		end
	elseif self._curLayer == MatchFinalPkPage.LAYER_LIST then
		if self._node_pklist then
	    	self._node_pklist:setVisible(true)
		end
		if self._node_pktree then
	    	self._node_pktree:setVisible(false)
		end
	end
end

function MatchFinalPkPage:clearPage()
	self:removeAllChildren()
    self._inited = false
end

function MatchFinalPkPage:onEnter()

end

function MatchFinalPkPage:onExit()
	uf_eventManager:removeListenerWithTarget(self)
	if self._delayHandle then
		SchedulerHelper.cancelSchedule(self._delayHandle)
		self._delayHandle = nil
	end
end

function MatchFinalPkPage:onCleanup( ... )
	
end

return MatchFinalPkPage