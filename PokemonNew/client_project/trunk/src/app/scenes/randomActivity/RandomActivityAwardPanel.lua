--RandomActivityAwardPanel.lua

--[====================[

	随机活动奖励面板
	
]====================]

local RandomActivityAwardPanel = class("RandomActivityAwardPanel",function()
    return cc.Node:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")


function RandomActivityAwardPanel:ctor(actType)

	self._actType = actType or 1 

	self._awardListData = {}

	self._awardListView = nil

    self:enableNodeEvents()
end

function RandomActivityAwardPanel:_initWidgets()

	self._mainLayer = cc.CSLoader:createNode(G_Url:getCSB("RandomActivityAwardPanel","randomActivity"))
	self:addChild(self._mainLayer)
	self._mainLayer:setContentSize(display.width,display.height)
	self:setPosition(display.cx,display.cy)
	ccui.Helper:doLayout(self._mainLayer)

	self:_initListView()
end

--初始化默认listview
function RandomActivityAwardPanel:_initListView()

	--listview父节点
	local listViewPanel = self._mainLayer:getSubNodeByName("Panel_listView")

	local viewW = listViewPanel:getContentSize().width
	local viewH = listViewPanel:getContentSize().height
	local cellW = 550   --cell ccb 设定size
	local cellH = 142

	self._awardListView = require("app.ui.WListView").new(
		viewW, viewH, cellW, cellH, true)
	
	self._awardListView:setCreateCell(function(list,index)
    	local cell = require("app.scenes.randomActivity.RandomActivityAwardItem").new(handler(self, self._sendGetAward))
    	return cell
	end)

	self._awardListView:setUpdateCell(function(list,cell,index)
    	if cell and index < #self._awardListData then
    		cell:updateData(self._awardListData[index+1])
    	end
	end)

	if self._awardListView then
		self._awardListView:setCellNums(#self._awardListData, true)
	end

	listViewPanel:addChild(self._awardListView)

end


--刷新全部UI  refreshAni 是否有动画效果
function RandomActivityAwardPanel:_refreshAllView(refreshAni)

	self._awardListData = G_Me.randomActivityData:getAwardList(self._actType) or {}

	-- dump(self._awardListData[1])

	self:_updateView()

	if self._awardListView then
		self._awardListView:setCellNums(#self._awardListData, refreshAni)
	end
end

function RandomActivityAwardPanel:_sendGetAward( awardId )
    G_HandlersManager.randomActivityHandler:sendGetActivityAward(awardId)
end

function RandomActivityAwardPanel:_onGetAward(data)

	if rawget(data,"awards") then
		--弹出获取奖励框
		if #data.awards > 0 then
			G_Popup.awardTips(data.awards)--, G_LangScrap.get("common_get_awards"))
		end
		self:_refreshAllView(false)
	end

end


function RandomActivityAwardPanel:_updateView()

	UpdateNodeHelper.updateCommonFullPop(self,G_LangScrap.get("random_activity_title_award"))

	self._mainLayer:updateLabel("Text_score_title", 
		{	text = G_LangScrap.get("random_activity_txt_my_score"),
			color = G_ColorsScrap.COLOR_POPUP_TITLE_TINY
		})

	self._mainLayer:updateLabel("Text_score", 
		{	text = tostring(G_Me.randomActivityData:getScore()),
			color = G_ColorsScrap.COLOR_POPUP_TITLE_TINY
		})
	

	local getAwardNum = 0

	for i=1, #self._awardListData do
		local awardInfo = self._awardListData[i]
		if awardInfo.getAward then
			getAwardNum = getAwardNum + 1
		end
	end

	local percent = math.ceil(getAwardNum/(#self._awardListData)*100)
	--更新进度条信息
	self._mainLayer:updateLabel("Text_progress_percent", {text=getAwardNum.."/"..(#self._awardListData),
		color=G_ColorsScrap.COLOR_POPUP_PROG_NUM, fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

	self._mainLayer:updateLabel("Text_progress", {text=G_LangScrap.get("spooky_txt_award_progress"),
		color=G_ColorsScrap.COLOR_POPUP_DESC_NORMAL, fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})
	
	-- self._mainLayer:updateLabel("Text_progress_num", {text=percent.."%",
	-- 	color=G_ColorsScrap.COLOR_POPUP_DESC_NOTE, fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

	local progressPanel = self._mainLayer:getSubNodeByName("LoadingBar_progress")
    progressPanel:setPercent(percent)

	-- local confirmButon = self._mainLayer:getSubNodeByName("Button_confirm")
	-- UpdateButtonHelper.updateNormalButton(confirmButon, 
	-- 	{   
	-- 	    desc = G_LangScrap.get("common_btn_close"),
	-- 	    state = UpdateButtonHelper.STATE_NORMAL,
	-- 	    callback = function() self:removeFromParent(true) end
	-- 	})

end


function RandomActivityAwardPanel:onEnter()

	self:_initWidgets()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_GET_AWARD, self._onGetAward, self)

    self:_refreshAllView(true)

end

function RandomActivityAwardPanel:onExit()
    uf_eventManager:removeListenerWithTarget(self)

    if self._mainLayer ~= nil then
		self._mainLayer:removeFromParent(true)
		self._mainLayer = nil
	end

end



return RandomActivityAwardPanel