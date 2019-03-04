--
-- Author: yutou
-- Date: 2018-09-15 17:45:03
--

local MineLayer=class("MineLayer",function()
	return cc.Layer:create()
end)

local MineCitys = require("app.scenes.mine.MineCitys")
local MineLayerui = require("app.scenes.mine.MineLayerui")
local Parameter_info = require("app.cfg.parameter_info")
local MineBattleScene = require("app.scenes.mine.MineBattleScene")
local SchedulerHelper = require "app.common.SchedulerHelper"

function MineLayer:ctor()
	MineLayer.instance = self
	self:enableNodeEvents()
	self._data = G_Me.mineData
	self._pageNum = nil
	self._pageList = {}
	self._pageIndex = nil
	self:init()
end

function MineLayer:init()
	self._pageNum = tonumber(Parameter_info.get(584).content)


	if self._data:hasData() == false then
		uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_GETED_INFO,self._getedData,self)
		G_HandlersManager.mineHandler:sendGetInfoList({self._data:getNowIndex()})
	else
		self:initUI()
	end
end

function MineLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK,self.battleReport,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_SEARCH_JOB,self.searchOver,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_APPLY_JOB,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_REFRESH_ONE,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_QUIT,self.render,self)
end

function MineLayer:battleReport( data )
	if data then
		print("MineLayer:battleReport1")
		G_ModuleDirector:pushModuleWithAni(nil, function()
			return MineBattleScene.new(data,nil,nil,function()
				SchedulerHelper.newScheduleOnce(function()
		        	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MINE_ATTACK_OVER, nil, false)
				end, 0.2)
			end)
		end)
	else
		print("MineLayer:battleReport2")
	end
end

function MineLayer:_getedData()
	self:initUI()
end

function MineLayer:initUI()

    ---------------------------------------------
	-- 排版
	self._csbNode = cc.CSLoader:createNode("csb/mine/MineLayer.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)


    ---------------------------------------------

    self._pageView = self:getSubNodeByName("PageView_citys")
    --self._pageView:addEventListener(handler(self, self._pageViewTruingEvent))
    self._pageView:addTouchEventListener(handler(self,self._onPageTouch))

    self._pageView:removeAllPages()

	local MineCitys = require("app.scenes.mine.MineCitys")
    for i=1,self._pageNum do
		local onePage = MineCitys.new(i)
	    self._pageView:addPage(onePage)
		self._pageList[i] = onePage
    end


	self._ui = MineLayerui.new(self)
	self:addChild(self._ui)

	self:render()
end

---点击翻页
function MineLayer:_onPageTouch( sender,state )
    self._pageView:setPropagateTouchEvents(false)
    if(state == ccui.TouchEventType.began)then
        return true
    elseif(state == ccui.TouchEventType.moved)then
    	
    elseif(state == ccui.TouchEventType.ended or state == ccui.TouchEventType.canceled)then
        local targetPos = self._pageView:getCurrentPageIndex() + 1
        if targetPos ~= self._data:getNowIndex() then
			self._data:setNowIndex(targetPos)
            self:render()
        end
    end
end

function MineLayer:render()
	local nowIndex = self._data:getNowIndex()
	if self._pageIndex ~= nowIndex then
		self._pageIndex = nowIndex
		-- self._data:setNowIndex(self._ui._tabIndex)
		self._ui:renderBtnList()
	end
	
    for i=1,self._pageNum do
		if math.abs(nowIndex - i) <= 1 then
			self._pageList[i]:render()
			if nowIndex == i then
				self._pageList[i]:focusOnPage()
			else
				self._pageList[i]:focusOutPage()
			end
		else
			self._pageList[i]:focusOutPage()
			self._pageList[i]:clear()
		end
	end
end

function MineLayer:searchOver(id)
	if id ~= 0 then
		self:jumpToPage(self._data:getIndexByID(id))
		G_Popup.newPopup(function()
            local MineCityInfoPopup = require("app.scenes.mine.MineCityInfoPopup")
            -- local cityData = self._data:getCityDataByID(id)
            return MineCityInfoPopup.new(id)
        end)
	else
		G_Popup.tips("暂无空矿")
	end
end

function MineLayer:jumpToPage( index )
	self._ui:jumpToPage(index)
end

function MineLayer:getPageView()
	return self._pageView
end

function MineLayer:getUI(  )
	return self._ui
end

function MineLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MineLayer:onCleanup()
	self:removeAllChildren()
	self._data:release()
end

return MineLayer