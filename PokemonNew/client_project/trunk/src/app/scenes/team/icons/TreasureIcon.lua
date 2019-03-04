--
-- Author: YouName
-- Date: 2016-03-18 15:27:11
--
local TreasureIcon = class("TreasureIcon",require("app.scenes.team.icons.BaseIcon"))

local FunctionConst = require("app.const.FunctionConst")

function TreasureIcon:ctor( onClick )
	-- body
	TreasureIcon.super.ctor(self)
	self._slot = 0
	self._pos = 0
	self._textLock = nil
	self._status = 0
	self._onClick = onClick
	self._treasureId = 0
	self._imageTreasureType = nil
	self._imageTreasureBg = nil
	self._imagePlus = nil
	self._textName = nil
	self._textLevel = nil
	self._textType = nil
	self._imageYuanfen = nil
	self._imgLock = nil
end

function TreasureIcon:getSlot( ... )
	-- body
	return self._slot
end

function TreasureIcon:getPos( ... )
	-- body
	return self._pos
end


function TreasureIcon:_onClickHandler()
	-- body
	if self._onClick ~= nil then
		self._onClick(self._slot,self._status,self._treasureId)
		print(self._slot,self._status,self._treasureId)
	end
end

function TreasureIcon:updateIcon( pos,slot )
	-- body
	self._pos = pos
	self._slot = slot
	local iconParams = {}
	local slotPos = self._slot
	local status = 0
	-- 0 没有指定类型的装备  1 有指定类型装备但是不可穿戴（已穿戴在其他武将）  2 有可穿戴装备 99 已经有穿戴装备
	local typeConverter = require("app.common.TypeConverter")
	local knightData = G_Me.teamData:getKnightDataByPos(self._pos)
	local treasureId = 0
	local hasHighColor = false
	local canRefine = false
	--local canHigher = false
	local treasureData = nil

	--dump(slotPos)
	-- local wearInfo = require("app.cfg.wear_require_info").get(2,slotPos)
	-- assert(wearInfo,string.format("wear_require_info can't find position == %d and slot = %d",2,slotPos))
	--local isOpen = require("app.responder.Responder").funcIsOpened(wearInfo.function_id)
	local isOpen = require("app.responder.Responder").funcIsOpened(slotPos == 1 and FunctionConst.FUNC_BOOKWAR_OPEN or FunctionConst.FUNC_HORSE_OPEN)
	--dump(isOpen)
	-- if self._imageTreasureBg == nil then
	-- 	self._imageTreasureBg = require("app.scenes.team.icons.ImageLoader").new()
	-- 	if snyx then
	-- 		self._imageTreasureBg:loadTexture(G_Url:getUI_common("frame/img_frame_treasure"))
	-- 	else
	-- 		self._imageTreasureBg:loadTexture(G_Url:getUI_common("img_frame_empty03a"))
	-- 	end
	-- 	self._botNode:addChild(self._imageTreasureBg)
	-- end

	--底纹设置
	if self._imageTreasureType == nil then
		self._imageTreasureType = require("app.scenes.team.icons.ImageLoader").new()
		self._imageTreasureType:setScale(0.9)
		self:addChild(self._imageTreasureType)
	end
	self._imageTreasureType:setVisible(true)
	if(slotPos == 1)then
		--self._imageTreasureType:loadTexture("newui/team/img_treasure_defence.png")
		self._imageTreasureType:loadTexture("newui/team/img_treasure_attack.png")
	elseif(slotPos == 2)then
		self._imageTreasureType:loadTexture("newui/team/img_treasure_defence.png")
	 	--self._imageTreasureType:loadTexture("newui/team/img_treasure_attack.png")
	end


	if self._textType ~= nil then
		self._textType:setVisible(false)
	end

	-------------------------------------------------------
	if self._textLevel ~= nil then
		self._textLevel:setVisible(false)
	end

	if self._textLock ~= nil then
		self._textLock:setVisible(false)
	end

	if self._imageTreasureType ~= nil then
		--self._imageTreasureType:setVisible(false)
	end

	if self._textName ~= nil then
		self._textName:setVisible(false)
	end

	if self._imagePlus ~= nil then
		self._imagePlus:setVisible(false)
	end

	if self._imageYuanfen ~= nil then
		self._imageYuanfen:setVisible(false)
	end

	----------------------------------------------------------------
	local showPlus = false
	local showTypeImage = false
	local showLockText = false

	if(not isOpen)then -- 未开放兵书
		local imgLock = display.newSprite("newui/common/lock/img_com_lock02.png")
		if self._imgLock == nil then
			imgLock:setPosition(0, 0)
			self:addChild(imgLock)
			self._imgLock = imgLock
		end
		--imgLock:setPosition(-25, 35)
		--self:getParent():getParent():getChildByName("Text_bg_pos"):setLocalZOrder(20)
		--showTypeImage = true
		--showLockText = true
		--self:setEnableClick(false)
	else
		self:setEnableClick(true)

		if knightData == nil then
			showTypeImage = true
		else
			local resData = G_Me.teamData:getPosResourcesByFlag(self._pos, 2)
			status = G_Me.bookWarData:getTreasureStatusBySlot(slotPos)
			treasureId = resData ~= nil and resData["slot_"..tostring(slotPos)] or 0
			if(treasureId ~= nil and treasureId > 0)then
				if self._imageTreasureType ~= nil then
					self._imageTreasureType:setVisible(false)
				end

				self._treasureId = treasureId
				status = 99
				
				-- local betterList = G_Me.treasureData:getBetterTreasureListUnWear(treasureId, knightData.serverData.id) or {}
				-- hasHighColor = #betterList > 0
				--dump(treasureId)
				treasureData = G_Me.bookWarData:getbookWarInfoByID(treasureId)
				--dump( G_Me.bookWarData:isShowEnhanceRed(treasureId))
				--dump( G_Me.bookWarData:isShowRefineRed(treasureId))
				canRefine = G_Me.bookWarData:isShowRefineRed(treasureId) or  G_Me.bookWarData:isShowEnhanceRed(treasureId)
				hasHighColor = G_Me.bookWarData:isHaveHigherQuality(treasureId)

				iconParams.cfgParams = typeConverter.convert({
					type = typeConverter.TYPE_BOOK_WAR,
					value = treasureData.serverData.base_id,
					level = treasureData.serverData.level,
				})

				local strAfter = ""
				local textColor = iconParams.cfgParams.cfg.color

				if(treasureData.serverData.refine_level > 0)then
					strAfter = "+"..tostring(treasureData.serverData.refine_level)
				end

				if self._textName == nil then
					self._textName = cc.Label:createWithTTF("",G_Path:getNormalFont(),19)
					self:addChild(self._textName)
					self._textName:setPositionY(-80)
				end
				
				self._textName:setColor(G_Colors.qualityColor2Color(textColor,true))
				self._textName:enableOutline(G_ColorsScrap.getColorOutline(textColor), 2)
				self._textName:setVisible(true)
				local strName = iconParams.cfgParams.cfg.name--..strAfter
				self._textName:setString(strName)
				---------------------------------------------------------------------

				if self._textLevel == nil and treasureData.serverData.level > 0 then
					self._textLevel = cc.Label:createWithTTF("",G_Path:getNormalFont(),19)
					self._textLevel:setAnchorPoint(1,0.5)
					self._textLevel:setColor(G_Colors.title[12])
					self._textLevel:enableOutline(G_Colors.outline[12], 1)
					self:addChild(self._textLevel)
					self._textLevel:setPosition(42,35)
				end

				if self._textLevel ~= nil then
					self._textLevel:setString("LV:"..tostring(treasureData.serverData.level))
					self._textLevel:setVisible(treasureData.serverData.level > 0)
				end

				local yuanfenFlag = 0
				local assList = G_Me.teamData:getKnightAssociationInfoListByID(knightData.serverData.id,true) or {}
				for i=1,#assList do
					local item = assList[i]
					if item.isActive then
						local info = item.cfgData
						if info.info_type == 3 then
							for i=1,4 do
								local id = info["info_value_"..tostring(i)]
								if id == treasureData.serverData.base_id then
									yuanfenFlag = 1
								end
							end
						end
					end
				end

				-- if yuanfenFlag == 1 and self._imageYuanfen == nil then
				-- 	self._imageYuanfen = display.newSprite(G_Url:getText_signet("w_img1_signet19"))
				-- 	self._imageYuanfen:setPosition(-25, 35)
				-- 	self:addChild(self._imageYuanfen)
				-- end

				if self._imageYuanfen ~= nil and yuanfenFlag == 1 then
					self._imageYuanfen:setVisible(true)
				end

			else
				showTypeImage = true
				showPlus = true
			end
		end
		
	end

	if(status == 99)then
		iconParams.isRed = hasHighColor or canRefine
		local TeamUtils = require("app.scenes.team.TeamUtils")
		--iconParams.isGreen = TeamUtils.isPosTreasureShowGreen(self._pos,self._slot)
		iconParams.isGreen = false
	else
		if(status == 2)then
			iconParams.isRed = true
			iconParams.isShowAdd = true
		else
			iconParams.isRed = false
		end
	end

	self._status = status
	iconParams.scale = 0.88
	TreasureIcon.super.updateIcon(self,iconParams,2)

	-- if self._imageBg ~= nil then
	-- 	self._imageBg:setVisible(true)
	-- end
	
	-- if showTypeImage then
		-- 底纹显示
		-- if self._imageTreasureType == nil then
		-- 	self._imageTreasureType = require("app.scenes.team.icons.ImageLoader").new()
		-- 	self:addChild(self._imageTreasureType)
		-- end
		-- self._imageTreasureType:setVisible(true)
		-- if(slotPos == 1)then
		-- 	self._imageTreasureType:loadTexture("newui/team/img_treasure_attack.png")
		-- elseif(slotPos == 2)then
		--  	self._imageTreasureType:loadTexture("newui/team/img_treasure_defence.png")
		-- end

	-- 	if self._imageBg ~= nil then
	-- 		self._imageBg:setVisible(false)
	-- 	end

	-- 	if self._textType == nil then
	-- 		local strType = G_LangScrap.get("maincity_button_text_treasure")
	-- 		self._textType = cc.Label:createWithTTF(strType,G_Path:getNormalFont(),26)
	-- 		self._textType:setAnchorPoint(0.5,0.5)
	-- 		self._textType:setColor(cc.c3b(0xe1,0xcc,0x99))
	-- 		self._textType:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
	-- 		self:addChild(self._textType)
	-- 		self._textType:setPosition(0,-30)
	-- 		self._textType:setOpacity(255*0.35)
	-- 	end

	-- 	if self._textType ~= nil then
	-- 		self._textType:setVisible(true)
	-- 	end
	-- end

	-- if showPlus then
	-- 	if self._imagePlus == nil then
	-- 		self._imagePlus = require("app.scenes.team.icons.ImageLoader").new()
	-- 		self:addChild(self._imagePlus)
	-- 		self._imagePlus:loadTexture(G_Url:getUI_common("img_com_btn_add06"))
	-- 	end
	-- 	self._imagePlus:setVisible(true)
	-- end

	-- if showLockText then
	-- 	if self._textLock == nil then
	-- 		self._textLock = cc.Label:createWithTTF("",G_Path:getNormalFont(),22)
	-- 		self._textLock:setWidth(60)
	-- 		self._textLock:setLineBreakWithoutSpace(true)
	-- 		self._textLock:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	-- 		self._textLock:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
	-- 		self._textLock:setAnchorPoint(0.5,0.5)
	-- 		self._textLock:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 1)
	-- 		self._textLock:setPositionY(5)
	-- 		self:addChild(self._textLock)
	-- 	end
	-- 	local strLock = require("app.common.FunctionLevelHelper").getFunctionDesc(wearInfo.function_id)
	-- 	self._textLock:setString(strLock)
	-- 	self._textLock:setVisible(true)
	-- end

end

return TreasureIcon