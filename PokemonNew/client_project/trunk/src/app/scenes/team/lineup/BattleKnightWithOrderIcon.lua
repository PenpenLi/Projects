-- Author: Yutou
-- Date: 2017-02-13 18:32:42
--
local BattleKnightWithOrderIcon = class("BattleKnightWithOrderIcon",function()
	return ccui.Layout:create()
end)

function BattleKnightWithOrderIcon:ctor()
	-- body
	self:setAnchorPoint(0.5,0.5)
	self:setContentSize(110,115)
	self._rootNode = display.newNode()
	self:addChild(self._rootNode)
	self._rootNode:setPosition(110/2,115/2)
	
	self._imageBg = nil
	self._imageIcon = nil
end

function BattleKnightWithOrderIcon:updateIcon(knightData,scale)
	-- body
	local function updateIKnightIcon()
		local params = {}
		local TypeConverter = require('app.common.TypeConverter')
		params.cfgParams = TypeConverter.convert({
			type = TypeConverter.TYPE_KNIGHT,
			value = knightData.cfgData and knightData.cfgData.knight_id or knightData,
			starLevel = knightData.starLevel or 0,
			weaponLevel = knightData.weaponLevel or 0
		})
		
		local cfgParams = params.cfgParams
		local urlBg = G_Url:getUI_common("frame/img_frame_01")
		local urlIcon = nil
		local iconPos = cc.p(0,0)
		if cfgParams ~= nil then
			if knightData.cfgData then
				urlBg = G_Url:getUI_frame("img_frame_0"..TypeConverter.quality2Color(knightData.cfgData.quality))
			else
				urlBg = cfgParams.icon_bg
			end
			urlIcon = cfgParams.icon
		    if cfgParams.type == TypeConverter.TYPE_KNIGHT then
		        --or (cfgParams.type == TypeConverter.TYPE_FRAGMENT and cfgParams.cfg.fragment_type == 1) then
		        -- 查找头像的配置文件
		        -- local iconJson = decodeJsonFile(G_Path.getKnightIconConfig(cfgParams.icon_character_id))
		        -- iconPos = iconJson and cc.p(iconJson.x, iconJson.y) or cc.p(0, 0)
		    end
		end
		
		--icon背景图
		if urlBg ~= nil then
			if self._imageBg == nil then
				self._imageBg = require("app.scenes.team.icons.ImageLoader").new()
				self._rootNode:addChild(self._imageBg,0)	
			end
			self._imageBg:loadTexture(urlBg)
			self._imageBg:setVisible(true)
			self._imageBg:setScale(scale)
		else
			if self._imageBg ~= nil then
				self._imageBg:setVisible(false)
				self._imageBg:setScale(scale)
			end
		end

		--icon图
		if urlIcon ~= nil then
			if self._imageIcon == nil then
				self._imageIcon = require("app.scenes.team.icons.ImageLoader").new()
				self._rootNode:addChild(self._imageIcon,1)
		    end
		    self._imageIcon:loadTexture(urlIcon)
		    self._imageIcon:setVisible(true)
		else
			if self._imageIcon ~= nil then
				self._imageIcon:setVisible(false)
			end
		end

		if self._imageIcon ~= nil then
			self._imageIcon:setPosition(iconPos.x,iconPos.y)
			self._imageIcon:setScale(scale)
		end
	end

	local function updateOrderIcon( ... )
		--出手顺序
		local csbNode = cc.CSLoader:createNode("csb/team/lineup/FormationOrder.csb")
		self:addChild(csbNode)
		local orderbg = csbNode:getChildByName("num_bg_1")

		csbNode:setPosition(55, orderbg:getContentSize().height/2 - 1.5 - 17)
	end

	if knightData == nil or knightData.cfgData.knight_id == 0 then
		-- if self._imageBg == nil then
		-- 	self._imageBg = require("app.scenes.team.icons.ImageLoader").new()
		-- 	self._rootNode:addChild(self._imageBg,0)	
		-- end
		-- self._imageBg:loadTexture("newui/common/formation/empty.png")
		-- self._imageBg:setVisible(true)
		updateOrderIcon()
	else
		updateIKnightIcon()
		updateOrderIcon()
	end
end

return BattleKnightWithOrderIcon
