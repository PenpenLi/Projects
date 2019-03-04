--
-- Author: yutou
-- Date: 2019-01-16 22:31:57
--
local SoulPossessionFormationLock = class("SoulPossessionFormationLock",function(  )
	return display.newNode()
end)

function SoulPossessionFormationLock:ctor(index,datas)
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("FormationLock","soulPossession"))
	self._csbNode:addTo(self)

	self._button_lock = self._csbNode:getChildByName("Button_lock")
	self._button_unlock = self._csbNode:getChildByName("Button_unlock")
	
	-- self._csbNode:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2)

	-- self:setContentSize(self._bg:getContentSize())
	-- self:setAnchorPoint(0.5,0.5)
	self._button_lock:addClickEventListenerEx(function(  )
		self._datas[self._index] = 0
		self:render()
	end)
	self._button_unlock:addClickEventListenerEx(function(  )
		self._datas[self._index] = 1
		self:render()
	end)

	self._index = index
	if datas then
		self:update(datas)
	end
end

function SoulPossessionFormationLock:update( datas )
	self._datas = datas
	self:render()
end

function SoulPossessionFormationLock:render(  )
	if self._datas[self._index] == 1 then
		self._button_lock:setVisible(true)
		self._button_unlock:setVisible(false)
	else
		self._button_lock:setVisible(false)
		self._button_unlock:setVisible(true)
	end
end

local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local SoulPossessionFormationList=class("SoulPossessionFormationList",SimpleFormationList)

SoulPossessionFormationList.ORDER_LOCK = 15;--
function SoulPossessionFormationList:ctor(type,switchCallBack,showOrder,orderIconType,isIconCall,canSwitch,normalPos)
	SoulPossessionFormationList.super.ctor(self,type,switchCallBack,showOrder,orderIconType,isIconCall,canSwitch,normalPos)
	self:setOrderOff(70)
	self:setGapW(160,160)
	self:setGapOff(0,40)

	self.lockList = {}
end

function SoulPossessionFormationList:update( knightData,orderData,lockState,lockList)
	SoulPossessionFormationList.super.update(self,knightData,orderData,lockState,lockList)
	self:_updateLockList(lockList)
end

function SoulPossessionFormationList:render()
	SoulPossessionFormationList.super.render(self)
	for i=1,#self.lockList do
		if self._knightData[i] and self._knightData[i] ~= 0 then
			self.lockList[i]:setVisible(true)
			self.lockList[i]:render()
		else
			self.lockList[i]:setVisible(false)
		end
	end
end

function SoulPossessionFormationList:_updateLockList(lockList )
	for i=1,6 do
		local soulPossessionFormationLock = nil
		if self.lockList[i] == nil then
			soulPossessionFormationLock = SoulPossessionFormationLock.new(i,lockList)
			self.lockList[i] = soulPossessionFormationLock
	   		self:addChild(soulPossessionFormationLock,SoulPossessionFormationList.ORDER_LOCK)
		else
			soulPossessionFormationLock = self.lockList[i]
		end
		if self._attackOrderPos[i] then
			soulPossessionFormationLock:setPosition(self._attackOrderPos[i].x + 40, self._attackOrderPos[i].y + 33)
		end
	end
	self:render()
end

return SoulPossessionFormationList