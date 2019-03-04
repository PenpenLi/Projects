--
-- Author: YouName
-- Date: 2016-03-18 15:27:18
--
local KnightIcon = class("KnightIcon",require("app.scenes.team.icons.BaseIcon"))
local EffectNode = require("app.effect.EffectNode")

function KnightIcon:ctor( pos,onClick )
	-- body
	KnightIcon.super.ctor(self)
	self._pos = pos
	self._status = 0
	self._onClick = onClick
	self._imageSlected = nil
	self._imageLock = nil
	self._textLock = nil
	self._imagePlus = nil
	self:setSwallow(false)

	-- 选中特效
 	-- local effectNode = cc.CSLoader:createNode(G_Url:getCSB("xuanzhong","card/ani"))
 	-- self._effectNode = effectNode
 	-- self._effectNode:setScale(1.2)
 	-- self._effectNode:setVisible(false)
  --   effectNode:setName("xuanzhong")
  --   self:addChild(effectNode)

  	-- 选中特效2
  	self._effectNode = EffectNode.new("effect_ui_kuang_red")
	self._effectNode:setPosition(cc.p(1.5,4))
	self._effectNode:setScale(1.03)
	self._effectNode:play()
    self:addChild(self._effectNode)
end

function KnightIcon:getPos( ... )
	-- body
	return self._pos
end

function KnightIcon:getStatus( ... )
	-- body
	return self._status
end

function KnightIcon:setSelected( bool )
	-- body
	if bool == true then
		-- if self._imageSlected == nil then
		-- 	self._imageSlected = display.newSprite(G_Url:getUI_common("img_frame_empty04"))
		-- 	self._imageSlected:setScale(1.12)
		-- 	self._botNode:addChild(self._imageSlected)
		-- end
		-- self._imageSlected:setVisible(true)
		self._effectNode:setVisible(true)
	else
		-- if self._imageSlected ~= nil then
		-- 	self._imageSlected:setVisible(false)
		-- end
		self._effectNode:setVisible(false)
	end
end

function KnightIcon:_onClickHandler()
	if self._onClick ~= nil then
		self._onClick(self._pos,self._status)
	end
end

function KnightIcon:updateIcon(pos,isCheckStatus)
	self._pos = pos
	local teamUtils = require("app.scenes.team.TeamUtils")
	local status = 0
	local userLevel = G_Me.userData.level
	local functionInfo = teamUtils.getKnightSlotOpenInfo(self._pos)
	local knightData = G_Me.teamData:getKnightDataByPos(self._pos)
	local TypeConverter = require("app.common.TypeConverter")
	local iconParams = {}
	self:setScale(0.8)

	if self._imagePlus ~= nil then
		self._imagePlus:setVisible(false)
	end

	if self._imageLock ~= nil then
		self._imageLock:setVisible(false)
	end

	if self._textLock ~= nil then
		self._textLock:setVisible(false)
	end

	--dump(knightData)
	if(knightData ~= nil)then -- 上阵武将
		status = 99

		iconParams.cfgParams = TypeConverter.convert({
			type = TypeConverter.TYPE_KNIGHT,
			value = knightData.cfgData.knight_id,
			rank = knightData.serverData.knightRank,
		})
	else -- 武将未上阵
		--dump(functionInfo.level)
		if(userLevel < functionInfo.level)then -- 主角等级未达到该阵位开启所需等级
			status = 0

			local num = teamUtils.getKnightSlotOpenNum() + 1
			--dump(num)
			--if(pos > num)then
				if self._imageLock == nil then
					self._imageLock = display.newSprite(G_Url:getUI_lock("img_com_lock01"))
					self._imageLock:setScale(1.2)
					local textOpen = cc.Label:createWithTTF("",G_Path:getNormalFont(),17)
					textOpen:setColor(G_Colors.title[24])
        			textOpen:enableOutline(G_Colors.outline[23], 2)
					textOpen:setString(G_Lang.get("common_level_function_open",{level = functionInfo.level}))
					textOpen:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
					textOpen:setPosition(45, 20)
					self._imageLock:addChild(textOpen)
					self:addChild(self._imageLock)
				end
				self._imageLock:setVisible(true)
				--self:setScale(1)

			-- else
			-- 	if self._imageLock == nil then
			-- 		self._imageLock = display.newSprite(G_Url:getUI_common("img_com_lock01"))
			-- 		self:addChild(self._imageLock)
			-- 	end
			-- 	self._imageLock:setVisible(true)
				
			-- 	local strNoOpen = G_LangScrap.get("common_text_open_function",{level=functionInfo.level})
			-- 	if self._textLock == nil then
			-- 		self._textLock = cc.Label:createWithTTF("",G_Path:getNormalFont(),24)
			-- 		self._textLock:setWidth(60)
			-- 		self._textLock:setLineBreakWithoutSpace(true)
			-- 		self._textLock:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			-- 		self._textLock:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
			-- 		self._textLock:setAnchorPoint(0.5,0.5)
					
			-- 		self:addChild(self._textLock)
			-- 	end
			-- 	self._textLock:setString(strNoOpen)
			-- 	self._textLock:setVisible(true)
			-- end
		else-- 阵位开启，武将未上阵
			status = 1

			local numOpen = teamUtils.getKnightSlotOpenNum()
			local numPos = G_Me.teamData:getPosKnightNum()
			--if(numOpen > numPos and pos == (numPos + 1))then 
			if(numOpen > numPos)then 
				if self._imagePlus == nil then
					self._imagePlus = display.newSprite(G_Url:getUI_add("img_com_add01"))
					self._imagePlus:setScale(1.2)
					self:addChild(self._imagePlus,10)
				end
				self._imagePlus:setVisible(true)
				--self:setScale(1)
			else
				status = 2
			end
		end
	end

	self._status = status

	if isCheckStatus then -- 检测红点状态
		--local isFabaoLevelUp = false
		local canEnhance = false
		local isRed = false
		if(knightData == nil)then -- 阵位未有武将
			local functionInfo = teamUtils.getKnightSlotOpenInfo(pos)
			if userLevel >= functionInfo.level then
				local numOpen = teamUtils.getKnightSlotOpenNum()
				local numPos = G_Me.teamData:getPosKnightNum()
				if(numOpen > numPos and pos == (numPos + 1))then
					isRed = teamUtils.hasOtherKnights(pos,1)
				end

			end
			--isFabaoLevelUp = false
		else
			isRed = teamUtils.isPosKnightShowRed(pos)
			--dump(pos .. ":" .. tostring(isRed))
			--isFabaoLevelUp = teamUtils.isFabaoLevelUpShowRed(knightData.serverData.id)
		end

		local resData = G_Me.teamData:getPosResourcesByFlag(pos,1)
		if(resData ~= nil)then
			for i=1,4 do
				local id = resData["slot_"..tostring(i)]
				if(id ~= nil and id > 0)then
					canEnhance = G_Me.equipData:isEnhanceAvailable(id)
					if canEnhance then
						break
					end
				end
			end
		end
		iconParams.isGreen = canEnhance-- or isFabaoLevelUp
		iconParams.isRed = isRed
	end
	
	-----------------------------------------------------------
	KnightIcon.super.updateIcon(self,iconParams)
end


function KnightIcon:checkStatus( pos )
	-- body


	self:updateIcon(iconParams)
end

-- 移除镶嵌效果
function KnightIcon:_removeSelectEffect( ... )
	if self._effectNode then
		self._effectNode:removeFromParent(true)
		self._insetEffect[i] = nil
	end
end

return KnightIcon