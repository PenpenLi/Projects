--
-- Author: YouName
-- Date: 2016-03-24 15:33:28
--
local ReinKnightIcon = class("ReinKnightIcon",require("app.scenes.team.icons.BaseIcon"))

function ReinKnightIcon:ctor(pos,onClick )
	-- body
	ReinKnightIcon.super.ctor(self)
	self._pos = pos or 0
	self._status = 0
	self._onClick = onClick
	self._imageLock = nil
	self._textLock = nil
	self._imagePlus = nil
	self._textName = nil
	self:setSwallow(true)
end

function ReinKnightIcon:_onClickHandler()
	-- body
	if self._onClick ~= nil then
		self._onClick(self._pos,self._status)
	end
end

function ReinKnightIcon:updateIcon( pos )
	self._pos = pos
	local teamUtils = require("app.scenes.team.TeamUtils")
	local status = 0
	local userLevel = G_Me.userData.level
	local functionInfo = teamUtils.getReinSlotOpenInfo(self._pos) 
	local knightData = G_Me.teamData:getReinKnightDataByPos(self._pos)
	local TypeConverter = require("app.common.TypeConverter")
	local iconParams = {}

	if self._imagePlus ~= nil then
		self._imagePlus:setVisible(false)
	end

	if self._imageLock ~= nil then
		self._imageLock:setVisible(false)
	end

	if self._textLock ~= nil then
		self._textLock:setVisible(false)
	end

	if self._textName ~= nil then
		self._textName:setVisible(false)
	end

	if(knightData ~= nil)then
		status = 99
		iconParams.cfgParams = TypeConverter.convert({
			type = TypeConverter.TYPE_KNIGHT,
			value = knightData.cfgData.knight_id,
			rank = knightData.serverData.knightRank,
		})

		if self._textName == nil then
			self._textName = cc.Label:createWithTTF("",G_Path:getNormalFont(),22)
			self._textName:setWidth(126)
			self._textName:setLineBreakWithoutSpace(true)
			self._textName:setAnchorPoint(0.5,1)
			self._textName:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			self._textName:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			
			self._textName:setPositionY(-57)
			self:addChild(self._textName)
		end
		local strName = knightData.cfgRankData.name
		if knightData.serverData.knightRank > 0 then
			strName = strName.."+"..tostring(knightData.serverData.knightRank)
		end
		self._textName:setString(strName)
		self._textName:setColor(G_ColorsScrap.getColor(G_TypeConverter.quality2Color(knightData.cfgData.quality)))
		self._textName:enableOutline(G_ColorsScrap.getColorOutline(G_TypeConverter.quality2Color(knightData.cfgData.quality)), 2)
		self._textName:setVisible(true)
	else

		if(userLevel < functionInfo.level)then
			status = 0

			local num = teamUtils.getReinKnightSlotOpenNum() + 1
			if(pos > num)then
				if self._imageLock == nil then
					self._imageLock = display.newSprite(G_Url:getUI_common("img_com_lock01"))
					self:addChild(self._imageLock)
				end
				self._imageLock:setVisible(true)
			else
				local strNoOpen = G_LangScrap.get("common_text_open_function",{level=functionInfo.level})
				if self._textLock == nil then
					self._textLock = cc.Label:createWithTTF("",G_Path:getNormalFont(),24)
					self._textLock:setWidth(60)
					self._textLock:setLineBreakWithoutSpace(true)
					self._textLock:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
					self._textLock:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
					self._textLock:setAnchorPoint(0.5,0.5)
					
					self:addChild(self._textLock)
				end
				self._textLock:setString(strNoOpen)
				self._textLock:setVisible(true)
			end
		else
			status = 1

			local hasOtherKnights = teamUtils.hasOtherKnights(pos,2)
			iconParams.isRed = hasOtherKnights
			if self._imagePlus == nil then
				self._imagePlus = display.newSprite(G_Url:getUI_common("img_com_btn_add06"))
				--self._imagePlus:setScale(1.2)
				self:addChild(self._imagePlus,10)
			end
			self._imagePlus:setVisible(true)

		end
	end

	self._status = status

	ReinKnightIcon.super.updateIcon(self,iconParams)
end

return ReinKnightIcon