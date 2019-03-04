--
-- Author: yutou
-- Date: 2019-01-15 12:12:56
--
local SoulPossessionPage = require("app.scenes.soulPossession.layer.SoulPossessionPage")
local SoulPossessionChalleng = require("app.scenes.soulPossession.layer.SoulPossessionChalleng")
local SoulPossessionBattleScene = require("app.scenes.soulPossession.layer.SoulPossessionBattleScene")
local ConfirmAlert = require("app.common.ConfirmAlert")
local SoulPossessionMainLayer=class("SoulPossessionMainLayer",function()
	return display.newNode()
end)
local LAYER_MAIN = 1
local LAYER_PK = 2
local LAYER_GUAN = 3

function SoulPossessionMainLayer:ctor(data)
	self:enableNodeEvents()

	self._data = data
	self._curStage = nil
	self._curLayer = LAYER_MAIN
	self:_init()
end

function SoulPossessionMainLayer:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("SoulPossessionMainLayer","soulPossession"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	self._btn_back = self._csbNode:getSubNodeByName("Button_back")
	self._btn_help = self._csbNode:getSubNodeByName("Button_help")
	self._btn_formation = self._csbNode:getSubNodeByName("Button_team_attack")
	-- self._btn_ready = self._csbNode:getSubNodeByName("Button_ready")
	-- self._btn_look = self._csbNode:getSubNodeByName("Button_look_enemy")
	self._btn_add = self._csbNode:getSubNodeByName("Button_add")
	self._btn_stage = self._csbNode:getSubNodeByName("Button_select_stage")
	self._btn_left = self._csbNode:getSubNodeByName("Button_lf")
	self._btn_right = self._csbNode:getSubNodeByName("Button_rt")
	self._panel_monster = self._csbNode:getSubNodeByName("Node_monster")
	self._btn_preview = self._csbNode:getSubNodeByName("Button_award")

	self._fileNode_bg = self._csbNode:getSubNodeByName("FileNode_bg")

	self._node_page = self._fileNode_bg:getSubNodeByName("Node_page")

	self._panel_con = self._csbNode:getSubNodeByName("Panel_main_con")
	self._node_enemy = self._csbNode:getSubNodeByName("Node_enemy")
	self._node_count = self._csbNode:getSubNodeByName("Node_count")

	self._node_challeng = self._csbNode:getSubNodeByName("Node_challeng")
	self._text_count_title = self._csbNode:getSubNodeByName("Text_count_title")

	self._csbNode:getSubNodeByName("Text_count"):setVisible(false)
	self._csbNode:getSubNodeByName("Text_count_left"):setVisible(false)

	self._soulPossessionPage = SoulPossessionPage.new(self._node_page)
	self._panel_monster:addChild(self._soulPossessionPage)
	local pageContentSize = self._soulPossessionPage:getContentSize()
	self._soulPossessionPage:setPosition(-pageContentSize.width/2, -pageContentSize.height/2)

	--背景适配
	local bg= self._csbNode:getSubNodeByName("Sprite_bg")
    G_WidgetTools.autoTransformBg(bg)

    -- local adapt_Y = display.height/853 <= 1 and 0 or (display.height/853)^2 * 40
    -- self._btn_ready:setPositionY(self._btn_ready:getPositionY() + adapt_Y)

    -- UpdateButtonHelper.reviseButton(self._btn_ready,{isBig = true})

    --返回
    G_CommonUIHelper.FixBackNode(self._csbNode:getSubNodeByName("Node_back"))
    self._btn_back:addClickEventListenerEx(function( ... )
		if self._curLayer ~= LAYER_MAIN then
			self._curLayer = LAYER_MAIN
			self:_updateUI()
    	else
    		G_ModuleDirector:popModule()
    	end
    end)

    --帮助
    G_CommonUIHelper.FixHelpNode(self._btn_help)
    self._btn_help:addClickEventListenerEx(function( ... )
    	G_Popup.newHelpPopup(G_FunctionConst.FUNC_SOUL_POSSESSION)
    end)

    --布阵
    self._btn_formation:addClickEventListenerEx(function( ... )
		G_Popup.newPopup(function()
			local LineUpPop = require("app.scenes.team.lineup.LineUpPop")
            return LineUpPop.new(LineUpPop.TYPE_TEAM_ATTACK,nil,G_FunctionConst.FUNC_SOUL_POSSESSION)
        end)
    end)

    -- --战斗准备
    -- self._btn_ready:addClickEventListenerEx(function( ... )
    -- 	local count = G_Me.maxChallengeData:getOwnChallengeCount()
    -- 	if count <= 0 then
    -- 		self:_onBuyCount()
    -- 		return
    -- 	end
    -- 	self._readyLayer = require("app.scenes.maxChallenge.MaxChallengeReadyLayer").new(self._stageId)
    -- 	self:addChild(self._readyLayer)
    -- 	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,2252)
    -- end)
    
    -- --查看敌方信息
    -- self._btn_look:addClickEventListenerEx(function( ... )
    -- 	--G_Popup.newPopup(function ()
    --     G_Popup.newPopupWithTouchEnd(function ()
    --         return require("app.scenes.maxChallenge.popup.ScanBuffPopup").new(true)
    --     end,nil,false)
    --     --end)
    -- end)

    --奖励预览
    self._btn_preview:addClickEventListenerEx(function( ... )
    	G_Popup.newPopupWithTouchEnd(function ()
    		local dropIDs,isFirst = G_Me.soulPossessionData:getDropId(self._curStage)
            return require("app.common.AwardPreview").new(dropIDs,isFirst)
        end,nil,false)
    end)

    --购买次数
    self._btn_add:addClickEventListenerEx(function( ... )
    	self:_onBuyCount()
    end)

    --选择关卡
    self._btn_stage:addClickEventListenerEx(function( ... )
    	local stageLayer = require("app.scenes.soulPossession.layer.SoulPossessionSelectLayer").new(self._curStage,function( curStage )
	    	if self._curStage == curStage then
				self._curStage = curStage
				self._curLayer = LAYER_MAIN
				self:_updateUI()
			elseif G_Me.soulPossessionData:stageIsPure() then
				self._curLayer = LAYER_MAIN
				self:gotoStage( curStage )
				self:_updateUI()
			else
	    		self:resetStage( curStage )
	    	end
    	end)
    	self._node_challeng:addChild(stageLayer)
		self._curLayer = LAYER_GUAN
		self:_updateUI()
    end)

    -- 向左
    self._btn_left:addClickEventListenerEx(function( ... )
    	if G_Me.soulPossessionData:stageIsPure() then
	    	-- self._curStage = self._curStage - 1
	    	-- self:render()
	    	self:gotoStage( self._curStage - 1 )
    	else
	    	self:resetStage( self._curStage - 1 )
    	end
    end)

    -- 向右
    self._btn_right:addClickEventListenerEx(function( ... )
    	if G_Me.soulPossessionData:stageIsPure() then
	    	-- self._curStage = self._curStage + 1
	    	-- self:render()
	    	self:gotoStage( self._curStage + 1 )
	    else
	    	self:resetStage( self._curStage + 1 )
    	end
    end)
    
    self:_updateRedPoint()
    self:setUIvisible(false)
	
	-- self._con = self._csbNode:getSubNodeByName("Node_con")
end

function SoulPossessionMainLayer:resetStage( readyStage )
	ConfirmAlert.createConfirmText(nil, G_Lang.get("soul_change_stage_tip"),
    	function()
			self:gotoStage( readyStage )
			self._curLayer = LAYER_MAIN
       	end
    )
end

function SoulPossessionMainLayer:gotoStage( readyStage )
	G_HandlersManager.soulPossessionHandler:enter(readyStage)
end

	-- local ownNum = G_Me.maxChallengeData:getOwnChallengeCount()
	-- local boughtNum = G_Me.maxChallengeData:getBoughtChallengedCount()
	-- local maxBought = G_Me.maxChallengeData:getVipMaxChallengeCount()

	-- local hasReach = G_Responder.vipTimeOutCheck(
	-- 	G_VipConst.FUNC_TYPE_MAX_CHALLENGE,
	-- 	{usedTimes = boughtNum,tips = ""}
	-- )

	-- if hasReach then
	-- 	return
	-- end

	-- G_Popup.newBuyChallengesPopup(G_VipConst.FUNC_TYPE_MAX_CHALLENGE,ownNum,boughtNum,function(buyNum)
	-- 	G_HandlersManager.maxChallengeHandler:sendBuyCount(buyNum)
	-- end)
function SoulPossessionMainLayer:_onBuyCount()
	local fun_id = G_VipConst.FUNC_TYPE_SOUL_OVER
    local function_cost_info = require("app.cfg.function_cost_info")
    local allBuyCount = G_Me.vipData:getVipTimesByFuncId(fun_id)--function_cost_info.get(fun_id).buy_add_count
    local leftBuyCount = allBuyCount - G_Me.soulPossessionData:getBuyCount()
    print("_onBuyCount_onBuyCount_onBuyCount",allBuyCount , G_Me.soulPossessionData:getBuyCount(),leftBuyCount)
    if leftBuyCount > 0 then
        G_Popup.newBuyChallengesPopup(fun_id,G_Me.soulPossessionData:getLeftCount(),G_Me.soulPossessionData:getBuyCount(),function(buyNum)
            if buyNum > 0 then
                G_HandlersManager.commonHandler:sendBuyCommonCount(fun_id,buyNum)
            end
        end)
    else
        G_Popup.tip(G_Lang.get("soul_refresh_text_tip"))
    end
end

function SoulPossessionMainLayer:_recvBuyCount()
	G_Popup.tip(G_Lang.get("common_btn_buy_success"))
	self:_updateUI()
end

--没有拉到数据前先不显示ui
function SoulPossessionMainLayer:setUIvisible( value )
	self._btn_back:setVisible(value)
	self._btn_formation:setVisible(value)
end

function SoulPossessionMainLayer:update(data)
	self._data = data
	self:render()
end

function SoulPossessionMainLayer:render()
	self._curStage = G_Me.soulPossessionData:getCurStage()
	print("sessionMainLayer:render",self._curStage,G_Me.soulPossessionData:getEnemyByLayer(self._curStage))
	self._soulPossessionPage:update(self._curStage,G_Me.soulPossessionData:getEnemyByLayer(self._curStage))
	self:_updateUI()
end

function SoulPossessionMainLayer:_clickEnemy(data )
	if G_Me.soulPossessionData:getLeftCount() == 0 then
		local fun_id = G_VipConst.FUNC_TYPE_SOUL_OVER
		local hasOver = G_Responder.vipTimeOutCheck(fun_id, {
	        usedTimes = G_Me.soulPossessionData:getBuyCount()
	        -- tips = G_LangScrap.get("lang_gold_hand_no_more_times") 
	    })
	    if hasOver == false then
	    	self:_onBuyCount()
	    end
	else
		self._tempEnemyData = data
		if G_Me.soulPossessionData:hasFormationData() then
			self:gotoChalleng()
		else
			G_HandlersManager.teamHandler:sendGetFormation()
		end
	end
end

function SoulPossessionMainLayer:gotoChalleng()
	local soulPossessionChalleng = SoulPossessionChalleng.new(self._tempEnemyData)
	self._tempEnemyData = nil
	self._node_challeng:addChild(soulPossessionChalleng)
	self._curLayer = LAYER_PK
	self:_updateUI()
end

function SoulPossessionMainLayer:_getFormation(data)
	G_Me.soulPossessionData:setFormationData(data)
	if self._tempEnemyData then
		self:gotoChalleng()
	end
end

function SoulPossessionMainLayer:_buyCommonCount( data )
	if data.func_id == G_VipConst.FUNC_TYPE_SOUL_OVER then
		G_Me.soulPossessionData:setCount(data.count)
	end
	self:_updateUI()
end

function SoulPossessionMainLayer:onEnter()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_REFRESH,self.render,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_ENEMY,self._clickEnemy,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_BUY_COMMON_COUNT,self._buyCommonCount,self)--
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_GETFORMATION,self._getFormation,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_GET_SERVER_DATA,self._getedChapterList,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_BATTLE,self._getBattle,self)--
	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_FINISH_BATTLE,self._finishBattle,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_ENTER,self._enterOver,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_RENDER,self.render,self)--

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_DAY_CHANGE,self._refreshTimes,self)--
	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MAX_CHALLENGE_ENTER_STAGE,self._enterStage,self)
	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SHOP_RED_POINT_UPDATE,self._updateRedPoint,self)
	if G_Me.soulPossessionData:hasData() == false then
		G_Me.soulPossessionData:init()
		print("SoulPossessionMainLayer:onEnterSoulPossessionMainLayer:onEnter")
		G_HandlersManager.soulPossessionHandler:sendGetData()
	else
		self:render()
	end
	self:_updateRedPoint()
end

function SoulPossessionMainLayer:_refreshTimes( )
	G_HandlersManager.soulPossessionHandler:refresh(locks,2)
end

function SoulPossessionMainLayer:_enterOver( )
	print("SoulPossessionMainLayer:_enterOver")
	self:render()
end

function SoulPossessionMainLayer:_getedChapterList()
	self:render()
end

function SoulPossessionMainLayer:_updateRedPoint()
	
end

function SoulPossessionMainLayer:_getBattle( data )
	if self._curLayer ~= LAYER_MAIN then
		self._curLayer = LAYER_MAIN
		-- self:_updateUI()
	end
end

--更新UI,主要是基本数据
function SoulPossessionMainLayer:_updateUI()
	self._curStage = G_Me.soulPossessionData:getCurStage()

	self:setUIvisible(true)
	--关卡
	self._csbNode:updateLabel("Text_stage2", {
		text = G_Lang.get("max_challenge_stage_num",{num = GlobalFunc.numberToChinese(self._curStage)}),
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26),
		})


	--箭头
	local maxStage = G_Me.soulPossessionData:getMaxStage()
	self._btn_left:setVisible(self._curStage > 1)
	self._btn_right:setVisible(self._curStage < maxStage)

	if self._curLayer == LAYER_MAIN then
		self._panel_con:setVisible(true)
		self._node_enemy:setVisible(true)
		self._node_count:setVisible(true)
		self._node_count:setPositionY(-236)
		self._text_count_title:setString(G_Lang.get("soul_left"))
		self._btn_add:setVisible(true)
		self._node_challeng:removeAllChildren()

		--剩余次数
		local count = G_Me.soulPossessionData:getLeftCount()
		self._csbNode:updateLabel("Text_count", {
			text = tostring(count),
			textColor = G_Colors.getColor(11),
			--outlineColor = G_Colors.getOutlineColor(26),
			visible = true
			})
		self._csbNode:getSubNodeByName("Text_count_left"):setVisible(false)
	elseif self._curLayer == LAYER_PK then
		self._panel_con:setVisible(false)
	    self._node_enemy:setVisible(false)
		self._node_count:setVisible(true)
	    self._node_count:setPositionY(-144)
		self._btn_add:setVisible(false)
		self._text_count_title:setString(G_Lang.get("soul_refresh_left"))

		local count = G_Me.soulPossessionData:getRefreshLeftCount()
		self._csbNode:updateLabel("Text_count_left", {
			text = tostring(count),
			textColor = G_Colors.getColor(11),
			--outlineColor = G_Colors.getOutlineColor(26),
			visible = true
			})
		self._csbNode:getSubNodeByName("Text_count"):setVisible(false)
	elseif self._curLayer == LAYER_GUAN then
		self._panel_con:setVisible(false)
	    self._node_enemy:setVisible(false)
		self._node_count:setVisible(false)
	end
end

function SoulPossessionMainLayer:_enterStage()
	-- print("SoulPossessionMainLayer:_enterStage")
	-- self._stageId = G_Me.maxChallengeData:getCurStageId()
	self:_updateUI()
	-- self:_jumpToStageAct()
end

-- function SoulPossessionMainLayer:_finishBattle()
-- 	print("_finishBattle_finishBattle",_finishBattle)
-- 	self:render()
-- 	-- print("SoulPossessionMainLayer:_finishBattle",isWin)
-- 	-- local maxId = G_Me.maxChallengeData:getMaxStageId()
-- 	-- self._stageId = G_Me.maxChallengeData:getCurStageId()
-- 	-- self:_updateUI()
	
-- 	-- if isWin and self._readyLayer then
-- 	-- 	self._readyLayer:removeFromParent(true)
-- 	-- 	self._readyLayer = nil
-- 	-- end
-- 	-- print("_finishBattle",self._stageId,maxId)
-- 	-- --如果是第一次通关胜利，才执行到下关动画(相当于数据 当前关卡已经到了最大关卡)
-- 	-- if isWin and self._stageId == maxId then
-- 	-- 	self:_jumpToStageAct()
-- 	-- end
	
-- end

function SoulPossessionMainLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function SoulPossessionMainLayer:onCleanup()
	
end


return SoulPossessionMainLayer


