--
-- Author: Yutou
-- Date: 2017-04-26 20:55:42
--
--[[
准备战斗时的布阵界面  显示对手信息跟我方信息  我方信息可以操作
]]
local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local KnightDropManager = require("app.scenes.team.lineup.KnightDropManager")
local AttackOrderDropManager = require("app.scenes.team.lineup.AttackOrderDropManager")
local LineUpTeamAddPanel = require("app.scenes.team.lineup.LineUpTeamAddPanel")
local LineUpDealTeamPanel = require("app.scenes.team.lineup.LineUpDealTeamPanel")
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require ("app.common.UpdateButtonHelper")
local SchedulerHelper = require "app.common.SchedulerHelper"

local CommonVsFormation = class("CommonVsFormation",function()
	return cc.Layer:create()
end)

CommonVsFormation.BOTTOM_GAP = 200

--[[
func_id  调用的模块id
formationData  敌方的阵容信息
foramtionID  默认选中的阵容
callBack  点击挑战后的回调
]]
function CommonVsFormation:ctor(enemyType, func_id,formationData,foramtionID,callBack,canSwitch )
	assert(formationData and foramtionID,"formationData and foramtionID need!")
	self:enableNodeEvents()
	self._enemyType = enemyType --敌人的类型
	self._func_id = func_id			--敌方信息
	self._formationData = formationData			--敌方信息
	self._curID = foramtionID or 0 	--默认选择的阵容
	self._lastID = nil	--记录上次选中id
	self._callBack = callBack	--挑战后的回调
	self._canSwitch = canSwitch	--

	self._csbNode = nil
	self._btnChallenge = nil 	--挑战按钮
	self._btnClose = nil 		--关闭按钮
	self._btnLock = nil --锁定按钮
	self._btnUnlock = nil --非锁定按钮
	self._btnHelp = nil --帮助按钮
	self._lockState = false     --锁定状态

	self._switchDeal = false -- 默认关闭

	self._enemyFormationList = nil -- 敌方显示列表
	self._myFormationList = nil -- 敌方显示列表
	self._lineUpteamBtnList = nil --下面的阵容列表

	self._needClose = false
	self._needBattle = false
	self:init()
end

function CommonVsFormation:init( ... )
	-- csb界面处理
	if self._csbNode then
		return
	end
	self._csbNode = cc.CSLoader:createNode("csb/team/lineup/CommonVSFormation.csb")
	
	-- self._csbNode:setContentSize(display.width,display.height)
	-- ccui.Helper:doLayout(self._csbNode)
	self._csbNode:setPosition(display.cx, display.cy)
	self:addChild(self._csbNode)

	UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("FileNode_com"),"布阵",function ( ... )
		
	end,767)

	self._btnClose = self._csbNode:getSubNodeByName("Button_close")
	self._dealBtn = self._csbNode:getSubNodeByName("Button_deal")
	self._btnApply = self._csbNode:getSubNodeByName("Button_apply")
	self._btnChallenge = self._csbNode:getSubNodeByName("Button_battle")
	self._btnText = self._csbNode:getSubNodeByName("Text_btn")
	self._btnLock = self._csbNode:getSubNodeByName("Button_lock")
	self._btnUnlock = self._csbNode:getSubNodeByName("Button_unlock")
	self._btnHelp = self._csbNode:getSubNodeByName("Button_help")
	self._node_list = self._csbNode:getSubNodeByName("Node_list")
	UpdateButtonHelper.reviseButton(self._btnChallenge,{isBig = true})
	-- self._btnChallenge:setVisible(self._callBack ~= nil)

	self._nodeEnemy = self._csbNode:getSubNodeByName("Node_enemy")
	self._nodeMe = self._csbNode:getSubNodeByName("Node_me")

	self._panelCon = self._csbNode:getSubNodeByName("Panel_con")
	self._panelCon:setContentSize(cc.size(display.width,display.height))
	self._panelCon:setTouchEnabled(false)
	self._panelCon:addTouchEventListener(handler(self,self._onPanelConTouch))

	--添加操作面板
    local dealNode = self._csbNode:getSubNodeByName("Node_deal")
    self._panel_deal = require("app.scenes.team.lineup.LineUpDealTeamPanel").new(handler(self, self._dealTeam),handler(self, self._switchDealFun))
    dealNode:addChild(self._panel_deal)
    self._panel_deal:setScale(0)

    self:_addEvent()
end

function CommonVsFormation:setBtnText( text )
	self._btnText:setString(text)
end

--获取到其他阵容数据  开始更新数据了
function CommonVsFormation:_getFormation( data )
	print("CommonVsFormation:_getFormation",self._curID)
	if not self._lineUpteamBtnList then
		--开始添加下面的自定义阵容列表
	    self._lineUpteamBtnList = require("app.scenes.team.lineup.LineUpteamBtnList").new(handler(self, self._tabChange))
	    self._lineUpteamBtnList:addTo(self._node_list)
	    self._lineUpteamBtnList:setPosition(0,0)
	end
    
	self._dataManager = FormationsDataManager.getInstance()
	self._dataManager:setData(data)
	print("self._dataManager",self._dataManager,self._curID)
	self._lockState = self._dataManager:getSimpleLockState()
    self._lineUpteamBtnList:update(self._dataManager)
    
	self:render()
	SchedulerHelper.newScheduleOnce(function()
		self:update(self._curID)
		self:_updateLockUIState()

	    local id = self._dataManager:getFormationIdByFunid(self._func_id,0)
	    print("_getFormation",id)
	    if self._lastID then
	    	id = self._lastID
	    end
	    self:_tabChange(id)
		self._originalID = self._curID
	end, 0)
end

function CommonVsFormation:render( ... )
	if self._lineUpteamBtnList then
		self._lineUpteamBtnList:selecteIndex(self._curID)
	end

	--SchedulerHelper.newScheduleOnce(function()
		self:_renderEnemyFormation()
	--end, 0)
	--SchedulerHelper.newScheduleOnce(function()
		self:_renderMyFormation()
	--end, 0.2)
end

--刷新锁状态
function CommonVsFormation:_updateLockUIState()
	self._btnLock:setVisible(self._lockState)
	self._btnUnlock:setVisible(not self._lockState)

	self._dataManager:setSimpleLockState(self._lockState)
end

function CommonVsFormation:_renderEnemyFormation( ... )
	self._enemyFormationList = SimpleFormationList.new(self._enemyType)
	self._enemyFormationList:setGapOff(-20,-20)
    self._enemyFormationList:update(self._formationData.knight_info_ids,self._formationData.orders)
    self._enemyFormationList:setPosition(
    		 - self._enemyFormationList:getGapW(),
    		SimpleFormationList.GAP_H
    	)
    self._enemyFormationList:iconSetScale(0.8)
    self._enemyFormationList:addTo(self._nodeEnemy)
end

function CommonVsFormation:_renderMyFormation( ... )
	local knights = {}
	local orders = nil
	if self._curID == 0 then
    	knights = G_Me.teamData:getMyFormationIDList()
	    orders = G_Me.teamData:getMyFormationOrderList()
    else
    	for i=1,6 do
    		knights[i] =  self._dataManager:getKnightIDByPos(self._curID,i)
    	end
    	orders = self._dataManager:getOrder(self._curID)
	end

	self._myFormationList = SimpleFormationList.new(SimpleFormationList.TYPE_MY,handler(self, self._switchCallBack),nil,nil,nil,self._canSwitch)
	self._myFormationList:setGapOff(-20,-20)
    self._myFormationList:update(knights,orders)
    self._myFormationList:setPosition(
    		 - self._myFormationList:getGapW(),
    		SimpleFormationList.GAP_H
    	)
    self._myFormationList:iconSetScale(0.8)
    self._myFormationList:addTo(self._nodeMe)
end

function CommonVsFormation:_switchCallBack(type, fromTab,toTab )
	if SimpleFormationList.TYPE_SWITCH_ORDER == type then
		--数据交换
		if self._curID == 0 then
			G_Me.teamData:switchOrderPos(fromTab,toTab)
		else
			local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
			self._dataManager:switchOrderPos(self._curID,fromTab,toTab)
		end
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT == type then
		--数据交换
		if self._curID == 0 then
			G_Me.teamData:switchKnightPos(fromTab,toTab)
		else
			local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
			self._dataManager:switchKnightPos(self._curID,fromTab,toTab)
		end
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT_ORDER == type then
		--数据交换
		if self._curID == 0 then
			G_Me.teamData:switchKnightPos(fromTab,toTab)
			G_Me.teamData:switchOrderPos(fromTab,toTab)
		else
			local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
			self._dataManager:switchKnightPos(self._curID,fromTab,toTab)
			self._dataManager:switchOrderPos(self._curID,fromTab,toTab)
		end
	end	
end

function CommonVsFormation:_showAddPanel( ... )
	G_Popup.newPopup(function()
		return LineUpTeamAddPanel.new(LineUpTeamAddPanel.TYPE_CHANGE,self._dataManager,self._curID)
	end)
end

function CommonVsFormation:_getedOwnIcon( data )
	uf_eventManager:removeListenerWithEvent(self,G_EVENTMSGID.EVENT_RECRUITING_GET_HANDBOOK)
	self._dataManager:setOwnIDs(data.knight_base_id)
	self:_showAddPanel()
end

--切换阵容
function CommonVsFormation:_tabChange( id )
	print("CommonVsFormation:_tabChange",id)
	if id ~= 0 then
		self._dataManager:getKnightIDs(id)
	end
	if id == self._curID then
		return
	end
	self._lineUpteamBtnList:selecteIndex(id)
	if
		(self._curID == 0 and G_Me.teamData:formationIsChange()) or
		(self._curID ~= 0 and self._curID ~= -1 and self._dataManager:hasChange(self._curID))
	 	then--发生改变了发送布阵请求
		self:_sendChangeFormation()
	end

	self._curID = id
	self._lastID = id
	self:update(id)
	self:_updateLockUIState()
end

--刷新界面
function CommonVsFormation:update( id )
	print("CommonVsFormation:update",id)
	if id == 0 then--主阵容
		self._dealBtn:setVisible(true)
		self._myFormationList:update(
			G_Me.teamData:getMyFormationIDList() or {},
			G_Me.teamData:getMyFormationOrderList() or {},
			self._lockState
		)
	elseif id == -1 then--临时主阵容
		self._dealBtn:setVisible(false)
		self._myFormationList:update(
			self._dataManager:getTempKnightData().indexs,
			self._dataManager:getTempKnightData().orders,
			self._lockState
		)
	else--非主阵容
		self._dealBtn:setVisible(true)
		self._myFormationList:update(
			self._dataManager:getKnightIDs(id) or {},
			self._dataManager:getOrder(id) or {},
			self._lockState
		)
	end

	self._panel_deal:updateDeal(id)
end

--发送布阵请求
function CommonVsFormation:_sendChangeFormation()
	local formation = nil
	if self._curID == 0 then
		formation = G_Me.teamData:getFormation()
	elseif self._curID == -1 then--临时阵容
		formation = self._dataManager:get(self._curID)
	else
		formation = self._dataManager:get(self._curID)
	end
    G_HandlersManager.teamHandler:sendChangeFormation(formation)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHANGE_FORMATION_OK,self._onKnightPosChange,self)
end

--布阵成功通知
function CommonVsFormation:_onKnightPosChange( data )
	local id = data.id
    uf_eventManager:removeListenerWithEvent(self,G_EVENTMSGID.EVENT_CHANGE_FORMATION_OK)
	G_Popup.summary({{content=G_LangScrap.get("team_knight_line_up")}})
	
	--清空改变标识
	if id == 0 then
		G_Me.teamData:formationChangeOver()
	else
		self._dataManager:recoverChange(id)
	end

	if self._needBattle then
		self:selectBattleFormation()
	elseif self._needClose then
		self:removeFromParent(true)
	end
end

function CommonVsFormation:onEnter( ... )
	self:init()

    G_HandlersManager.teamHandler:sendGetFormation()
end

--选择当前阵容作为攻击阵容
function CommonVsFormation:selectBattleFormation( )
	if self._curID ~= -1 then
		-- func_id,formation_id,atk_or_def
		if self._originalID ~= self._curID then
			G_HandlersManager.teamHandler:sendSetFunctionFormation(self._func_id,self._curID,0)--0-设置攻击阵，1-设置防守阵。
		end
	else--临时阵容
		if self._originalID ~= self._curID then
			G_HandlersManager.teamHandler:sendSetFunctionFormation(self._func_id,FormationsDataManager.TEMP_TEAM_SERVER_ID,0)--0-设置攻击阵，1-设置防守阵。
		end
		if self._callBack then
			self._callBack(true)
		end
	end
	self:removeFromParent(true)
end

--收到服务器 更新攻击阵容的信息
function CommonVsFormation:_selectBattleFormationOver()
	if self._callBack then
		self._callBack()
	end
	self:removeFromParent(true)
end

function CommonVsFormation:_addEvent( ... )
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_GETFORMATION,self._getFormation,self)--
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_FORMATION_TABCHANGE,self._tabChange,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_FORMATION_UPDATE,self.update,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_SET_FUN_FORMATION,self._selectBattleFormationOver,self)

	self._btnClose:addClickEventListenerEx(
		function(sender)
			if 
				(self._curID == 0 and G_Me.teamData:formationIsChange()) or
				(self._curID ~= 0 and self._curID ~= -1 and self._dataManager and self._dataManager:hasChange())
			 	then
				self:_sendChangeFormation()
				self._needClose = true
			else
				self:removeFromParent(true)
			end
		end
	)

	self._btnChallenge:addClickEventListenerEx(function(sender)
		--print(self._curID,G_Me.teamData:formationIsChange(),self._dataManager:hasChange())
		if self._dataManager == nil then
			return
		end
		if 
			(self._curID == 0 and G_Me.teamData:formationIsChange()) or
			(self._curID ~= 0 and self._dataManager:hasChange(self._curID))
		 	then
			self:_sendChangeFormation()
			self._needClose = true
			self._needBattle = true
		else
			self:selectBattleFormation()
		end
	end)

	--选择阵容
	self._dealBtn:addClickEventListenerEx(function(sender)
		-- G_Popup.newPopupAtTop(function()
		-- 	return require("app.scenes.team.lineup.LineUpDealTeamPanel").new(handler(self, self._dealTeam))
		-- end,nil,true)
		self:_switchDealFun()
	end)

	--锁
	self._btnLock:addClickEventListenerEx(function ( ... )
		self._lockState = false
		self:update(self._curID)
		self:_updateLockUIState()
	end) 
	self._btnUnlock:addClickEventListenerEx(function ( ... )
		self._lockState = true
		self:update(self._curID)
		self:_updateLockUIState()
	end)

	--帮助
	self._btnHelp:addClickEventListenerEx(function ( ... )
		--G_Popup.newHelpPopup(nil,G_Lang.get("team_formation_help_desc"),G_Lang.get("team_formation_help_title"))
		G_Popup.newHelpPopup(G_FunctionConst.FUNC_TEAM)
	end)
end

--点击其他区域关闭更多按钮面板
function CommonVsFormation:_onPanelConTouch( sender,state )
	-- body
	if(state == ccui.TouchEventType.began)then
		self:_switchDealFun()
	elseif (state == ccui.TouchEventType.ended) then
		self._panelCon:setTouchEnabled(false)
	end
end

--切换更多按钮箭头状态
function CommonVsFormation:_flipArrow( bool )
	-- body
	local angle = bool == true and 180 or 0
	local action = cc.RotateTo:create(0.2, angle)
	self._dealBtn:runAction(action)
end

--是否打开操作面板
function CommonVsFormation:_switchDealFun()
	-- body
	self._switchDeal = not self._switchDeal

	local switch = self._switchDeal

	self._panel_deal:stopAllActions()
	self:_flipArrow(self._switchDeal)
	if(switch == true)then
		self._panel_deal:setVisible(true)
		local actionOpen = cc.ScaleTo:create(0.3,1)
		local easeOpen = cc.EaseBackOut:create(actionOpen)
		self._panel_deal:runAction(easeOpen)
		self._panelCon:setTouchEnabled(true)
	else
		-- self._panel_deal:setVisible(false)
		local actionClose = cc.ScaleTo:create(0.2,0)
		local easeClose = cc.EaseExponentialOut:create(actionClose)
		local seqClose = cc.Sequence:create(easeClose,cc.CallFunc:create(function(node)
			node:setVisible(false)
		end))
		self._panel_deal:runAction(seqClose)
		self._panelCon:setTouchEnabled(false)
	end
end

function CommonVsFormation:_dealTeam( event )
	if event == LineUpDealTeamPanel.DEL then
		G_HandlersManager.teamHandler:sendDelFormation(self._curID)
	elseif event == LineUpDealTeamPanel.RE then
		G_HandlersManager.teamHandler:sendResetFormation(self._curID)
	elseif event == LineUpDealTeamPanel.CHANGE then
		if self._dataManager:getOwnIDs() == nil then--是否获取到了已经拥有的武将idlist
			uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_GET_HANDBOOK,self._getedOwnIcon,self)
			G_HandlersManager.recruitingHandler:sendGetHandbook()
		else
			self:_showAddPanel()
		end
	elseif event == LineUpDealTeamPanel.FASHION then
		G_ModuleDirector:pushModule(G_FunctionConst.FUNC_FASHION, function()
			local formation = nil
			local cur_fashionId = nil
			self._fashion_id = nil
			if self._curID == 0 then
				formation = G_Me.teamData:getFormation()
			elseif self._curID == -1 then
				formation = self._dataManager:get(self._curID)
			else
				formation = self._dataManager:get(self._curID)
			end

			dump(formation)
			if rawget(formation,"clothes") then
				cur_fashionId = formation.clothes
			else
				cur_fashionId = 0
			end
			return require("app.scenes.fashion.FashionScene").new(
				{
				fashion_id = cur_fashionId,
				formation_id = formation.id,
				})
		end)
	end
end

function CommonVsFormation:onExit( ... )
	uf_eventManager:removeListenerWithTarget(self)
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	-- if self._dataManager then
	-- 	self._dataManager:release()
	-- end
	self._lineUpteamBtnList = nil
end

return CommonVsFormation