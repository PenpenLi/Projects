local MatchFinalPkLayer=class("MatchFinalPkLayer",function()
	return display.newNode()
end)

local MatchFinalPkData = require("app.data.MatchFinalPkData")
local MatchFinalPkPop = import(".MatchFinalPkPop")
local MatchGroupManager = import(".MatchGroupManager")
local HotGuessPop = import(".HotGuessPop")
-- local KnightImg = require("app.common.KnightImg")
local MatchTopKnightNode = require("app.scenes.match.common.MatchTopKnightNode")
local MatchFormationNode = require("app.scenes.match.common.MatchFormationNode")

-- local WEEK_PROGRESS_MAP = {
-- 	[3] = MatchFinalPkData.PROGRESS_1,
-- 	[4] = MatchFinalPkData.PROGRESS_1,
-- 	[5] = MatchFinalPkData.PROGRESS_1,
-- 	[6] = MatchFinalPkData.PROGRESS_2,
-- 	[7] = MatchFinalPkData.PROGRESS_3,
-- }

-- local WEEK_PK_NUM_MAP = {
-- 	[3] = {128,64},
-- 	[4] = {64,32},
-- 	[5] = {32,16},
-- 	[6] = {16,4},
-- 	[7] = {4,1},
-- }

function MatchFinalPkLayer:ctor(data,matchBg)
	self:enableNodeEvents()
	self._finalPkData = data
    self._matchBg = matchBg
	self._matchData = G_Me.matchData
	-- self._progress = WEEK_PROGRESS_MAP[week]
	-- self._curBigIndex = 1
	self:_init()
    self:onUpdate(handler(self, self._onUpdate))
    self._needCheckUpdate = true
end

function MatchFinalPkLayer:_onUpdate()
    local MatchData = require("app.data.MatchData")
    -- --决战出第一名了再请求
    -- if self._finalPkData:getNodeListNum(nil,0) == 1 and self._matchData:getNowType() == MatchData.TYPE_PK and G_ServerTime:getTime() > self._finalPkData:getStopTime() + 2 and self._needCheckUpdate then
    --     G_HandlersManager.matchHandler:sendGetData()
    --     self._needCheckUpdate = false
    -- end
end

function MatchFinalPkLayer:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PkLayer","match/pk"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	-- self._con = self._csbNode:getSubNodeByName("Node_con")
	-- self._con:addChild(self._node)

    -- self._panel_con:setSwallowTouches(false)
    -- self._panel_con:addTouchEventListener(handler(self, self._clickPanel))
    
	local datas = self._finalPkData:getTreeByProgress(MatchFinalPkData.PROGRESS_3)
	
	local list = {}
    local nodes4 = self._finalPkData:getNodeList(datas,2)
    local nodes2 = self._finalPkData:getNodeList(datas,1)
    local nodes1 = self._finalPkData:getNodeList(datas,0)

 --    local bestRank = self._finalPkData:findBestRank(datas)
	-- local list = {}
	-- for i=1,#datas do
	-- 	if #datas[i] == 2 then
	-- 		for j=1,#datas[i] do
	-- 			if #datas[i][j] == 2 then
 --    				local treeBestRank = self._finalPkData:findBestRank(datas[i][j])
 --        			if treeBestRank <= bestRank then
	-- 					table.insert(list,datas[i][j])--人数大于8
 --        			end
	-- 			else
	-- 				list = {datas[i][1],datas[i][2]}--只有两个人
	-- 			end
	-- 		end
	-- 	else
	-- 		list = {datas[1],datas[2]}--只有两个人
	-- 	end
	-- end

    self._openTimeDes = self._csbNode:getSubNodeByName("Text_open_time0")
    self._openTime = self._csbNode:getSubNodeByName("Text_open_time")
    self._button_add_guess = self._csbNode:getSubNodeByName("Button_add_guess")
    self._text_times_guess = self._csbNode:getSubNodeByName("Text_times_guess")
    self._text_guess_tips = self._csbNode:getSubNodeByName("Text_guess_tips")

    local timeStr = GlobalFunc:getTimeGapStr(self._finalPkData:getStartTime(),self._finalPkData:getEndTime())
    self._openTime:setString(timeStr)
    local progress = self._finalPkData:getNowProgress()
    if progress == 3 then
        self._openTime:setVisible(true)
        self._openTimeDes:setVisible(true)
    else
        self._openTime:setVisible(false)
        self._openTimeDes:setVisible(false)
    end

    local text_title = self._csbNode:getSubNodeByName("Text_title")
    local node_guess = self._csbNode:getSubNodeByName("Node_elite")
    local num1 = #self._finalPkData:getWinList()
    local num2 = num1 == 1 and 1 or num1/2
    text_title:setVisible(true)
    node_guess:setVisible(true)
    if num1 == 1 then
        text_title:setVisible(false)
        node_guess:setVisible(false)
    elseif num1 == 2 then
        text_title:setString(G_Lang.get("match_pk_text_tip2"))
    elseif num1 == 4 then
        text_title:setString(G_Lang.get("match_pk_text_tip1"))
    else
        text_title:setString(G_Lang.get("match_pk_text_tip",{num1 = num1,num2 = num2}))
    end

 --    self._openTime = self._csbNode:getSubNodeByName("Text_open_time")
    
 --    self._text_pk_num = self._csbNode:getSubNodeByName("Text_pk_num")

 --    self._bigGroups = {}
 --    for i=1,4 do
 --    	local bigGroupCsb = self._csbNode:getSubNodeByName("FileNode_group"..i)
 --    	self._bigGroups[i] = MatchGroupManager.new(i,bigGroupCsb,self._finalPkData,self._progress,handler(self, self._clickGroup))
 --    end

 --  --   self._button_hot_guess = self._csbNode:getSubNodeByName("Button_hot_guess")
 --  --   self._button_hot_guess:addClickEventListenerEx(function( ... )
 --  --   	G_Popup.newPopup(function( ... )
	-- 	-- 	return HotGuessPop.new(self._finalPkData)
	-- 	-- end)
 --  --   end)

 --    self._csbNode:getSubNodeByName("Button_back"):addClickEventListenerEx(function( ... )
 --        G_ModuleDirector:popModule()
 --    end)
    
 --    self:updateButton("Button_help", {
 --    callback = function ( ... )
 --        G_Popup.newHelpPopup(G_FunctionConst.NAME_MATCH)
 --    end})

 --    local startTimeObj = self._finalPkData:getStartTime()
 --    local endTimeObj = self._finalPkData:getEndTime()
 --    self._openTime:setString(
 --    	G_Lang.get("match_open_time",{
	--     	startTime = startTimeObj.hour.. ":".. startTimeObj.min,
	--     	endTime = endTimeObj.hour.. ":".. endTimeObj.min
 --    	})
 --    )

	self._matchBg:getSubNodeByName("Sprite_bg"):setVisible(true)
	self._matchBg:getSubNodeByName("Sprite_fg"):setVisible(false)

    local vs1 = self._matchBg:getSubNodeByName("FileNode_vs1")
    local vs2 = self._matchBg:getSubNodeByName("FileNode_vs2")
    vs1:setVisible(true)
    vs2:setVisible(true)

    if vs1.hasAction ~= true then
        local action = cc.CSLoader:createTimeline(G_Url:getCSB("vs","card/ani"))
        vs1:runAction(action)
        action:gotoFrameAndPlay(0)
        vs1.hasAction = true
    end
    if vs2.hasAction ~= true then
        local action = cc.CSLoader:createTimeline(G_Url:getCSB("vs","card/ani"))
        vs2:runAction(action)
        action:gotoFrameAndPlay(0)
        vs2.hasAction = true
    end

  	local nodes = nil
  	if self._finalPkData:nodesPlayerNum(nodes1) == 1 then
		self._matchBg:getSubNodeByName("Sprite_fg"):setVisible(true)
		self._matchBg:getSubNodeByName("Sprite_bg"):setVisible(false)
  		nodes = nodes1

	  	self._players = {
	  		self._matchBg:getSubNodeByName("Node_player_1"),
	  		self._matchBg:getSubNodeByName("Node_player_4"),
	  		self._matchBg:getSubNodeByName("Node_player_5")
	  	}
        vs1:setVisible(false)
        vs2:setVisible(false)
  	elseif self._finalPkData:nodesPlayerNum(nodes2) == 2 then
		self._matchBg:getSubNodeByName("Sprite_bg"):setVisible(false)
		self._matchBg:getSubNodeByName("Sprite_fg"):setVisible(false)
  		nodes = nodes2
  		
	  	self._players = {
	  		self._matchBg:getSubNodeByName("Node_player_4"),
	  		self._matchBg:getSubNodeByName("Node_player_5"),
	  		self._matchBg:getSubNodeByName("Node_player_2"),
	  		self._matchBg:getSubNodeByName("Node_player_3")
	  	}
        vs1:setVisible(true)
        vs2:setVisible(false)
  	elseif self._finalPkData:nodesPlayerNum(nodes4) == 4 then
		self._matchBg:getSubNodeByName("Sprite_bg"):setVisible(true)
		self._matchBg:getSubNodeByName("Sprite_fg"):setVisible(false)
  		nodes = nodes4
  		
	  	self._players = {
	  		self._matchBg:getSubNodeByName("Node_player_4"),
	  		self._matchBg:getSubNodeByName("Node_player_5"),
	  		self._matchBg:getSubNodeByName("Node_player_2"),
	  		self._matchBg:getSubNodeByName("Node_player_3")
	  	}
        vs1:setVisible(true)
        vs2:setVisible(true)
    else
        vs1:setVisible(false)
        vs2:setVisible(false)
  	end

  	for i=1,#self._players do
  		self._players[i]:removeAllChildren()
  	end

  	for i=1,#nodes do
        local data = self._finalPkData:getPlayerData(nodes[i].data)
  		local matchTopKnightNode = MatchTopKnightNode.new(data,nil,function(  )
			G_Popup.newPopup(function()
	            local matchFormationNode = MatchFormationNode.new(data.uid,data.sid,data.srank)

	            matchFormationNode:updateEnemyInfo({
	                knight_id = data.avater,
	                name = data.name,
	                quality = data.leader_quality,
	                })
	            
	            return matchFormationNode
	        end)
  		end)
		-- local knightImg = KnightImg.new(data.avater)
		self._players[i]:addChild(matchTopKnightNode)
		if i == 2 or i == 4 then
			matchTopKnightNode:setImgScaleX(-1)
		end
  	end

    self._matchBottom = require("app.scenes.match.common.MatchBottom").new(self._csbNode)

    self:_renderGuess()
end

function MatchFinalPkLayer:update( data )
	self._finalPkData = data
	self:render()
end

function MatchFinalPkLayer:_renderGuess(  )
    local parameter_info = require "app.cfg.parameter_info"
    local paramStr = parameter_info.get(480).content
    local timesList = {}
    local paramStrList1 = string.split(paramStr,"|")
    for i=1,#paramStrList1 do
        local paramStrList2 = string.split(paramStrList1[i],":")
        timesList[i] = paramStrList2[2]
    end
    local fun_id = 0
    local maxNum = 0
    local playerList = #self._finalPkData:getWinList()
    if playerList > 64 then
        fun_id = G_VipConst.FUNC_TYPE_MATCH_GUESS_1
        maxNum = timesList[1]
    elseif playerList > 16 then
        fun_id = G_VipConst.FUNC_TYPE_MATCH_GUESS_2
        maxNum = timesList[2]
    elseif playerList > 4 then
        fun_id = G_VipConst.FUNC_TYPE_MATCH_GUESS_3
        maxNum = timesList[3]
    elseif playerList > 1 then
        fun_id = G_VipConst.FUNC_TYPE_MATCH_GUESS_4
        maxNum = timesList[4]
    end
    
    self._text_guess_tips:setString(G_Lang.get("match_guess_text_tip",{num = maxNum}))
    self._button_add_guess:addClickEventListenerEx(function( ... )
        if playerList > 1 then
            local function_cost_info = require("app.cfg.function_cost_info")
            if G_Me.matchData:getLeftBuyCount() > 0 and function_cost_info.get(fun_id).buy_add_count >= G_Me.matchData:getLeftBuyCount() then
                G_Popup.newBuyChallengesPopup(fun_id,G_Me.matchData:getLeftCount(),function_cost_info.get(fun_id).buy_add_count - G_Me.matchData:getLeftBuyCount(),function(buyNum)
                    if buyNum > 0 then
                        G_HandlersManager.matchHandler:sendBetBuy(buyNum)
                    end
                end)
            else
                G_Popup.tip(G_Lang.get("match_guess_text_tip4"))
            end
        else
            G_Popup.tip(G_Lang.get("match_guess_text_tip3"))
        end
    end)
    self._text_times_guess:setString(G_Me.matchData:getLeftCount())
end

function MatchFinalPkLayer:clickPanel( )
    self._matchBottom:openMore(false)
end

function MatchFinalPkLayer:render()
    
end

function MatchFinalPkLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MATCH_BET_BUY_OVER,self._renderGuess,self)--
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MATCH_BET_OVER,self._renderGuess,self)--
end

function MatchFinalPkLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchFinalPkLayer:onCleanup( ... )
	
end

return MatchFinalPkLayer