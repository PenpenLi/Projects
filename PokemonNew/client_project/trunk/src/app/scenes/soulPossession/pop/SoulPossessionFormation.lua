--
-- Author: yutou
-- Date: 2019-01-16 17:53:45
--
local CommonVsFormation = require("app.scenes.team.lineup.CommonVsFormation")
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local MonsterTeamDataManager = require("app.scenes.team.lineup.data.MonsterTeamDataManager")
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local SoulPossessionFormation = class("SoulPossessionFormation",CommonVsFormation)


function SoulPossessionFormation:ctor(enemyID)
	self:enableNodeEvents()
    local EmenyFormationInfo = require("app.scenes.team.lineup.data.EmenyFormationInfo")
	local monster_ids,orders = MonsterTeamDataManager.getFormationData(enemyID)
    self._emenyInfo = EmenyFormationInfo.new(monster_ids,orders,power)
	SoulPossessionFormation.super.ctor(self,SimpleFormationList.TYPE_ENEMY,
		G_FunctionConst.FUNC_SOUL_POSSESSION,
		self._emenyInfo,
		0,
		function(  )
			
		end,
		false
	)
    self._needEvent = false

	self._btnChallenge:addClickEventListenerEx(function(sender)
		self:removeFromParent()
	end)
end

function SoulPossessionFormation:init()
	SoulPossessionFormation.super.init(self)
	UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("FileNode_com"),"查看敌方",function ( ... )
		self:removeFromParent(true)
	end,667)

	self._dealBtn:setVisible(false)
	self._dealBtn.setVisible = function()
		-- body
	end
	-- self._btnLock:setVisible(false)
	-- self._btnLock.setVisible = function()
	-- 	-- body
	-- end
	-- self._btnUnlock:setVisible(false)
	-- self._btnUnlock.setVisible = function()
	-- 	-- body
	-- end
	self._btnHelp:setVisible(false)
	self._node_list:setVisible(false)
end

--刷新锁状态
function SoulPossessionFormation:_updateLockUIState()
	self._btnLock:setVisible(self._lockState)
	self._btnUnlock:setVisible(not self._lockState)
end

function SoulPossessionFormation:_addEvent(  )
	--锁
	self._lockState = false
	self:_updateLockUIState()
	self._btnLock:addClickEventListenerEx(function ( ... )
    	local knights,orders,lockList = G_Me.soulPossessionData:getBodyFormation()
		self._lockState = false
    	self._myFormationList:update(knights,orders,self._lockState)
		-- self:update(self._curID)
		self:_updateLockUIState()
	end) 
	self._btnUnlock:addClickEventListenerEx(function ( ... )
    	local knights,orders,lockList = G_Me.soulPossessionData:getBodyFormation()
		self._lockState = true
    	self._myFormationList:update(knights,orders,self._lockState)
		-- self:update(self._curID)
		self:_updateLockUIState()
	end)
	self._btnLock.addClickEventListenerEx = function( ... )
		-- body
	end
	self._btnUnlock.addClickEventListenerEx = function( ... )
		-- body
	end
	SoulPossessionFormation.super._addEvent(self)
end

function SoulPossessionFormation:_renderMyFormation()
    local knights,orders,lockList = G_Me.soulPossessionData:getBodyFormation()
	self._myFormationList = SimpleFormationList.new(SimpleFormationList.TYPE_PLAYER,function( type, fromTab,toTab )
		print("_renderMyFormation_renderMyFormation",_renderMyFormation)
    	self._needEvent = true
		G_Me.soulPossessionData:switchBodyPos(type, fromTab,toTab)
		G_Me.soulPossessionData:switchSoulPos(type, fromTab,toTab)
	end,nil,nil,nil,true,true)
    self._myFormationList:iconSetScale(0.8)
	self._myFormationList:setGapOff(-20,-20)
    self._myFormationList:update(knights,orders,self._lockState)
    self._myFormationList:setPosition(
    		 - self._myFormationList:getGapW(),
    		SimpleFormationList.GAP_H
    	)
    self._myFormationList:addTo(self._nodeMe)
end

function SoulPossessionFormation:onExit()
	SoulPossessionFormation.super.onExit(self)
	if self._needEvent then
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_SOUL_CHANGE_BODY_FORMATION, nil, false)
	end
end

function SoulPossessionFormation:onEnter(  )
	self:init()
	self:render()
end

return SoulPossessionFormation