--
-- Author: Your Name
-- Date: 2017-11-22 15:20:57
-- 阵容的武将信息面板
local FormationWithOrderIcon = class("FormationWithOrderIcon",function()
	return ccui.Layout:create()
end)

function FormationWithOrderIcon:ctor()
	-- body
	self:setAnchorPoint(0.5,0.5)
	self:setContentSize(160,221)
	self._rootNode = display.newNode()
	self:addChild(self._rootNode)
	self._rootNode:setPosition(80,150)
	
	self._imageBg = nil
	self._imageIcon = nil
	self._nameNode = nil
end

function FormationWithOrderIcon:setBgColor(color)
	if color and self._nameNode then
		local bg = self._nameNode:getSubNodeByName("Image_pos")
		bg:setColor(color)
	end
end

function FormationWithOrderIcon:updatePosInfo(pos,id)
	if(id > 0 )then
		local data = G_Me.teamData:getKnightDataByID(id)
		local teamUtils = require("app.scenes.team.TeamUtils")
		if(data ~= nil)then
			local str_name = ""

			if(data.cfgData.type == 1)then
				str_name = require("app.scenes.team.TeamUtils").getMainRoleFullName()
			else
			 	str_name = data.cfgData.name
			end

			local textName = self._nameNode:getSubNodeByName("Text_name")
			textName:setString(str_name)
			textName:setTextColor(G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(data.cfgData.quality)))
			--textName:enableOutline(G_Colors.qualityColor2OutlineColor(G_TypeConverter.quality2Color(data.cfgData.quality)),2)
			
			self._nameNode:updateLabel("Text_level",{
				text = tostring(data.serverData.level),
				outlineColor = G_ColorsScrap.DEFAULT_OUTLINE_COLOR,
				outlineSize = 2,
			})
		end
	else
		if self._nameNode then
			self._nameNode:setVisible(false)
		end
	end
end

function FormationWithOrderIcon:updateIcon(knightData,fashionId)
	-- body
	local function updateIKnightIcon()
		local params = {}
		local TypeConverter = require('app.common.TypeConverter')
		params.cfgParams = TypeConverter.convert({
			type = TypeConverter.TYPE_KNIGHT,
			value = knightData.cfgData and knightData.cfgData.knight_id or knightData,
			fashionId = fashionId,
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
				self._rootNode:addChild(self._imageBg,1)	
			end
			self._imageBg:loadTexture(urlBg)
			self._imageBg:setVisible(true)
		else
			if self._imageBg ~= nil then
				self._imageBg:setVisible(false)
			end
		end

		--icon图
		if urlIcon ~= nil then
			if self._imageIcon == nil then
				self._imageIcon = require("app.scenes.team.icons.ImageLoader").new()
				self._rootNode:addChild(self._imageIcon,2)
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
		end

		--名字
		self._nameNode = cc.CSLoader:createNode("csb/team/lineup/LineUpItem1.csb")
		self._rootNode:addChild(self._nameNode,0)
		self._nameNode:setPosition(-3.5, -6.2)
	end

	local function updateOrderIcon( ... )
		--出手顺序
		local csbNode = cc.CSLoader:createNode("csb/team/lineup/LineUpNum.csb")
		self:addChild(csbNode)
		local orderbg = csbNode:getChildByName("num_bg_1")

		csbNode:setPosition(75, orderbg:getContentSize().height/2-1)
		
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

return FormationWithOrderIcon