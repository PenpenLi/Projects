--
-- Author: Yutou
-- Date: 2017-02-13 16:03:49
--

local AttackOrderIcon = require("app.scenes.team.lineup.AttackOrderIcon")

local AttackOrderDropManager = class("AttackOrderDropManager")

AttackOrderDropManager.SPINE_NORAML_SCALE = 1
AttackOrderDropManager.SPINE_PRESSED_SCALE = 1.15

function AttackOrderDropManager:ctor()
	self._id = nil
	self._csbNode = nil
	self._originalOrderData = nil
	self._orderData = {
		
	}
	self._attackOrderPos = {
		-- {x=0,y=0}
	}
	self._attackOrderInfoList = nil
	self._csbNode = nil
	self._touchBeganPos = {x=0,y=0}
	self._selectedAttackOrderPos = {x=0,y=0}

	self._hadChangeFormation = false
end

function AttackOrderDropManager:init(csbNode)
	self._csbNode = csbNode
	self._panelBg = csbNode:getSubNodeByName("Panel_bg")
	self._panelSpine = csbNode:getSubNodeByName("Panel_spine")
	self._btnClose = csbNode:getSubNodeByName("Button_close")
	self._panel_info = csbNode:getSubNodeByName("Panel_info")
end

function AttackOrderDropManager:update(id, orderData )
	self._id = id
	self._originalOrderData = orderData

	--清空之前的显示
	if self._attackOrderInfoList then
		for i=1,#self._attackOrderInfoList do
			self._attackOrderInfoList[i]:removeFromParent()
		end
	end
	self._attackOrderInfoList = {}
	
	for i=1,6 do
		local sub_node = self._panel_info:getSubNodeByName("ProjectNode_pos"..tostring(i))
		
		local attackOrderIcon = AttackOrderIcon.new()
		attackOrderIcon:updateLabel("Text_index",{
				text = orderData[i],
				textColor = G_Colors.getColor(1)
				-- outlineColor = G_ColorsScrap.DEFAULT_OUTLINE_COLOR,
				-- outlineSize = 2,
			})
	    attackOrderIcon:setTouchEnabled(true)
		attackOrderIcon:addTouchEventListenerEx(handler(self,self._onAttackOrderTouch))
		table.insert(self._attackOrderPos,{x=sub_node:getPositionX(),y=sub_node:getPositionY() - 135})
		table.insert(self._attackOrderInfoList,attackOrderIcon)
		attackOrderIcon:setPosition(self._attackOrderPos[i].x, self._attackOrderPos[i].y)
		self._orderData[i] = orderData[i]
		attackOrderIcon:addTo(self._panelSpine)
	end
end

-- 武将拖动操作
function AttackOrderDropManager:_onAttackOrderTouch( sender,state )
	-- body
	local tag = self:_getAttackOrderPos(sender)
	local targetPos = nil
	if(state == ccui.TouchEventType.began)then

		sender:setScale(AttackOrderDropManager.SPINE_PRESSED_SCALE)
		local beganPos = sender:getTouchBeganPosition()
		self._touchBeganPos.x = beganPos.x
		self._touchBeganPos.y = beganPos.y
		self._selectedAttackOrderPos.x = sender:getPositionX()
		self._selectedAttackOrderPos.y = sender:getPositionY()
		sender:setLocalZOrder(10)
		return true

	elseif(state == ccui.TouchEventType.moved)then
		local movePos = sender:getTouchMovePosition()
		local targetPosX = self._selectedAttackOrderPos.x + movePos.x - self._touchBeganPos.x
		local targetPosY = self._selectedAttackOrderPos.y + movePos.y - self._touchBeganPos.y

		sender:setPosition(targetPosX,targetPosY)

	elseif(state == ccui.TouchEventType.ended)then

		local bool_hit,targetTag = self:_hitTest(sender,tag)
		if(bool_hit == true)then
			self:_switchAttackOrderPos(sender,tag,targetTag)
		end
		self:_updateAllView()
		sender:setScale(AttackOrderDropManager.SPINE_NORAML_SCALE)
		self:_checkChange()
	elseif(state ==  ccui.TouchEventType.canceled)then

		self:_updateAllView()
		sender:setScale(AttackOrderDropManager.SPINE_NORAML_SCALE)

	end
end

function AttackOrderDropManager:_updateAllView( data )
	-- 根据更新后的数据 重新排布位置 
	for i=1,#self._orderData do
		local pos = i
		local data = self._orderData[i]
		self._attackOrderInfoList[i]:setPosition(self._attackOrderPos[i].x,self._attackOrderPos[i].y)
		self:_updatePosInfo(pos,data)
	end
end

-- 获取武将的布阵位置
function AttackOrderDropManager:_getAttackOrderPos( sender )
	-- body
	if(sender == nil or self._attackOrderInfoList==nil)then return 0 end
	for i=1,#self._attackOrderInfoList do
		local item = self._attackOrderInfoList[i]
		if(item == sender)then
			return i
		end
	end

	return 0
end

--交换武将布阵位置 及 数据
function AttackOrderDropManager:_switchAttackOrderPos( sender,fromTag,toTag )
	-- 显示数据交换
	local fromInfo = self._orderData[fromTag]
	local toInfo = self._orderData[toTag]
	fromInfo,toInfo = toInfo,fromInfo
	self._orderData[fromTag] = fromInfo
	self._orderData[toTag] = toInfo
	
	--数据交换
	if self._id == 0 then
		G_Me.teamData:switchOrderPos(fromTag,toTag)
	else
		local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
		FormationsDataManager.instance:switchOrderPos(self._id,fromTag,toTag)
	end
end

--手指松开后碰撞检测
function AttackOrderDropManager:_hitTest( sender,tag )
	-- body
	for i=1 ,#self._attackOrderInfoList do
		local item = self._attackOrderInfoList[i]
		-- local AttackOrderRect = sender:getCascadeBoundingBox()
		local itemSize = item:getContentSize()
		local AttackOrderPoint = sender:convertToWorldSpace(cc.p(itemSize.width/2,itemSize.height/2))
		local itemPos = item:convertToWorldSpace(cc.p(0,0))
		local touchExtendY = itemSize.height/2
		local targetRect = cc.rect(itemPos.x,itemPos.y - touchExtendY,itemSize.width,itemSize.height + touchExtendY*2)
		if(cc.rectContainsPoint(targetRect,AttackOrderPoint) and tag ~= i)then
			return true,i
		end
	end
	return false,tag
end

function AttackOrderDropManager:_updatePosInfo( pos,num )
	-- body
	local sub_node = self._attackOrderInfoList[pos];
	sub_node:updateLabel("Text_index",{
		text = tostring(num),
		textColor = G_Colors.getColor(1)
		-- outlineColor = G_ColorsScrap.DEFAULT_OUTLINE_COLOR,
		-- outlineSize = 2,
	})
	sub_node:setLocalZOrder(pos)
end

function AttackOrderDropManager:_checkChange( ... )
	-- body
	self._hadChangeFormation = false

	for i=1,6 do
		if self._originalOrderData[i] ~= self._orderData[i] then
			self._hadChangeFormation = true
			break
		end
	end
end

return AttackOrderDropManager