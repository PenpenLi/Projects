local MatchPkPlan=class("MatchPkPlan",function()
	return display.newNode()
end)

local MatchPlanData = require("app.data.MatchPlanData")
local HotGuessPop = import("..final.HotGuessPop")

MatchPkPlan.ALL_NUM = 6

function MatchPkPlan:ctor(data)
	self:enableNodeEvents()

	self._data = G_Me.matchData
	self._planData = data
	self:_init()
end

function MatchPkPlan:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("TipLayer","match/common"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	self._node = cc.CSLoader:createNode(G_Url:getCSB("PlanNode","match/common"))
	
	self._con = self._csbNode:getSubNodeByName("Node_con")
	self._con:addChild(self._node)

	self._title = self._csbNode:getSubNodeByName("Text_title")

	self._csbNode:getSubNodeByName("Button_back"):addClickEventListenerEx(function( ... )
    	G_ModuleDirector:popModule()
    end)

	self._weekList = {}
	self._weekDesList = {}
	for i=1,MatchPkPlan.ALL_NUM do
		self._weekList[i] = self._csbNode:getSubNodeByName("Text_day" .. i)
		self._weekDesList[i] = self._csbNode:getSubNodeByName("Text_thing" .. i)
	end

    self._button_hot_guess = self._csbNode:getSubNodeByName("Button_hot_guess")
    self._button_hot_guess:addClickEventListenerEx(function( ... )
    	G_Popup.newPopup(function( ... )
			return HotGuessPop.new(self._data:getFinalPkData())
		end)
    end)
    
    require("app.scenes.match.common.MatchBottom").new(self._csbNode)
end

function MatchPkPlan:render()
	self._title:setString(G_Lang.get("match_plan_num",{num = self._planData:getNum()}))
	for i=1,MatchPkPlan.ALL_NUM do
		local weekPlanData = self._planData:getPlanData(i)
		self._weekList[i]:setString(G_Lang.get("match_week",{week = G_Lang.get("match_week"..weekPlanData.week)}) .. ":")
		local pkType = ""
		if weekPlanData.type == MatchPlanData.TYPE_SEA then
			pkType = G_Lang.get("match_sea")
		elseif weekPlanData.type == MatchPlanData.TYPE_PK then
			pkType = G_Lang.get("match_pk")
		end

		local nowNum = weekPlanData.value2 or ""
		local targetNum = weekPlanData.value
		self._weekDesList[i]:setString(pkType .. nowNum .. "-" ..targetNum)
	end
end

function MatchPkPlan:onEnter()

end

function MatchPkPlan:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchPkPlan:onCleanup( ... )
	
end

return MatchPkPlan