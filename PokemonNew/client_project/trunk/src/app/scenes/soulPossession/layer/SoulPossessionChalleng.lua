--
-- Author: yutou
-- Date: 2019-01-16 16:13:29
--
local SoulPossessionFormation = require("app.scenes.soulPossession.pop.SoulPossessionFormation")
local SoulPossessionFormationList = require("app.scenes.soulPossession.layer.SoulPossessionFormationList")
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local SoulPossessionChalleng=class("SoulPossessionChalleng",function()
	return display.newNode()
end)

function SoulPossessionChalleng:ctor(data)
	self:enableNodeEvents()

	self._data = data
	self:_init()
end

function SoulPossessionChalleng:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("SoulPossessionChalleng","soulPossession"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)
	
	self._button_look_enemy = self._csbNode:getSubNodeByName("Button_look_enemy")
	self._button_look_enemy:addClickEventListenerEx(function()
		self:_checkEnemy()
	end)

	self._nodeBody = self._csbNode:getSubNodeByName("Node_body")
	self._nodeSoul = self._csbNode:getSubNodeByName("Node_soul")

	self._button_battle = self._csbNode:getSubNodeByName("Button_battle")
	self._button_flash = self._csbNode:getSubNodeByName("Button_flash")

	self._fileNode_effetc_1 = self._csbNode:getSubNodeByName("FileNode_effetc_1")
	self._fileNode_effetc_2 = self._csbNode:getSubNodeByName("FileNode_effetc_2")

    self._button_battle:addClickEventListenerEx(function()
    	-- (pos,index,order,team_idx)
    	local index = G_Me.soulPossessionData:getBodyKnightIDs()
    	local order = G_Me.soulPossessionData:getBodyKnightOrders()
    	local team_idx = G_Me.soulPossessionData:getKnightPoss()
		G_HandlersManager.soulPossessionHandler:battle(self._data.position,index,order,team_idx)
    end)

    self._button_flash:addClickEventListenerEx(function()
    	if G_Me.soulPossessionData:isAllLock() then
    		G_Popup.tip(G_Lang.get("soul_all_lock"))
    	elseif G_Me.soulPossessionData:getRefreshLeftCount() <= 0 then
    		G_Popup.tip(G_Lang.get("soul_no_refresh"))
    	else
	    	local locks = G_Me.soulPossessionData:getLockPoss()
			G_HandlersManager.soulPossessionHandler:refresh(locks,1)
    	end
    end)

	self:_initSoulFormation()
	self:_initBodyFormation()
end

-- function SoulPossessionChalleng:update(data)
-- 	self._data = data
-- 	self:render()
-- end

function SoulPossessionChalleng:render()
    local knights,orders = G_Me.soulPossessionData:getSoulFormation()
    self._enemyFormationList:update(knights,orders)
    local knights,orders = G_Me.soulPossessionData:getBodyFormation()
    print("SoulPossessionChalleng:render")
    dump(orders)
    self._myFormationList:update(knights,orders)
end

	-- self._enemyFormationList = SimpleFormationList.new(SimpleFormationList.TYPE_MY)
	-- self._enemyFormationList:setGapOff(-20,-20)
 --    self._enemyFormationList:update(self._formationData.knight_info_ids,self._formationData.orders)
 --    self._enemyFormationList:setPosition(
 --    		 - self._enemyFormationList:getGapW(),
 --    		SimpleFormationList.GAP_H
 --    	)
 --    self._enemyFormationList:iconSetScale(0.8)
 --    self._enemyFormationList:addTo(self._nodeEnemy)
function SoulPossessionChalleng:_initSoulFormation()
    local knights,orders = G_Me.soulPossessionData:getSoulFormation()

	self._enemyFormationList = SimpleFormationList.new(SimpleFormationList.TYPE_MY,handler(self, self._switchCallBack1),false)
	self._enemyFormationList:setGapOff(-20,-20)
    self._enemyFormationList:update(knights,orders)
    self._enemyFormationList:setPosition(
    		 - self._enemyFormationList:getGapW(),
    		SimpleFormationList.GAP_H
    	)
    self._enemyFormationList:iconSetScale(0.8)
    self._enemyFormationList:addTo(self._nodeSoul)
end

function SoulPossessionChalleng:_initBodyFormation()
    local knights,orders,lockList = G_Me.soulPossessionData:getBodyFormation()

	self._myFormationList = SoulPossessionFormationList.new(SoulPossessionFormationList.TYPE_PLAYER,handler(self, self._switchCallBack2),nil,nil,true,true,true)
	self._myFormationList:setGapOff(-20,-20)
    self._myFormationList:update(knights,orders,nil,lockList)
    self._myFormationList:setPosition(
    		 - self._myFormationList:getGapW(),
    		SoulPossessionFormationList.GAP_H
    	)
    self._myFormationList:iconSetScale(0.8)
    self._myFormationList:addTo(self._nodeBody)
    self._fileNode_effetc_1:removeFromParent()
    self._fileNode_effetc_2:removeFromParent()
    self._myFormationList:addChild(self._fileNode_effetc_1)
    self._myFormationList:addChild(self._fileNode_effetc_2)
end

function SoulPossessionChalleng:_switchCallBack1( type, fromTab,toTab )
	G_Me.soulPossessionData:switchSoulPos(type, fromTab,toTab)

	local poss = self._myFormationList:getKnightPos()
	local action = cc.CSLoader:createTimeline(G_Url:getCSB("flash0","card/ani"))
    self._fileNode_effetc_1:runAction(action)
    action:gotoFrameAndPlay(0,false)
    self._fileNode_effetc_1:setPosition(poss[fromTab].x, poss[fromTab].y)
    self._fileNode_effetc_1:setLocalZOrder(100)

	local action = cc.CSLoader:createTimeline(G_Url:getCSB("flash1","card/ani"))
    self._fileNode_effetc_2:runAction(action)
    self._fileNode_effetc_2:setPosition(poss[toTab].x, poss[toTab].y)
    self._fileNode_effetc_2:setLocalZOrder(100)
    action:gotoFrameAndPlay(0,false)
end

function SoulPossessionChalleng:_switchCallBack2( type, fromTab,toTab )
	G_Me.soulPossessionData:switchBodyPos(type, fromTab,toTab)
	G_Me.soulPossessionData:switchSoulPos(type, fromTab,toTab)
	self:render()
end

function SoulPossessionChalleng:onEnter()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_REFRESH,self.render,self)--
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SOUL_CHANGE_BODY_FORMATION,self.render,self)--
	
	self:render()
end

function SoulPossessionChalleng:_checkEnemy()
    G_Popup.newPopup(function()
		local soulPossessionFormation = SoulPossessionFormation.new(self._data.monster_value)
		return soulPossessionFormation
    end)
end

function SoulPossessionChalleng:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function SoulPossessionChalleng:onCleanup()
	
end


return SoulPossessionChalleng