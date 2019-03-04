--
-- Author: yutou
-- Date: 2018-09-20 14:26:30
--

local MineBattleReportCell = class("MineBattleReportCell", function ()
	return cc.TableViewCell:new()
end)

local TypeConverter = require "app.common.TypeConverter"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local MineReportData = require("app.scenes.mine.data.MineReportData")
local MineLayer = require("app.scenes.mine.MineLayer")
local storage = require "app.storage.storage"

function MineBattleReportCell:ctor(mineBattleReportPopup)
	self._data = nil
    self._mineData = G_Me.mineData
    self._mineBattleReportPopup = mineBattleReportPopup

	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MineBattleReportCell","mine"))
	self:addChild(self._csbNode)

    self._text_name = self:getSubNodeByName("Text_name")
    self._text_city_name = self:getSubNodeByName("Text_city_name")

    self._node_power = self:getSubNodeByName("Node_power")
    self._text_power = self:getSubNodeByName("Text_power")
    self._text_time = self:getSubNodeByName("Text_time")
    self._sprite_result = self:getSubNodeByName("Sprite_result")
    self._image_defence = self:getSubNodeByName("Image_defence")
    -- self._panel_look = self:getSubNodeByName("Panel_look")
    self._button_attack = self:getSubNodeByName("Button_attack")
    self._node_icon = self:getSubNodeByName("Node_icon")
    self._text_des = self:getSubNodeByName("Text_des")
    self._node_city_icon = self:getSubNodeByName("Node_city_icon")
    self._node_city_icon:setScale(0.75)
    self._image_new = self:getSubNodeByName("Image_new")
    self._image_new:setVisible(false)
end

function MineBattleReportCell:updateData(data,index)
	self._data = data
	self:render()
end

function MineBattleReportCell:render()
	local data = self._data
	-- if self._data:getType() == MineReportData.TYPE_GET_CITY then
	-- 	self._node_city_icon:setVisible(true)
	-- 	self._node_icon:setVisible(false)
	-- 	self._node_power:setVisible(false)
	-- 	self._text_name:setString(data:getMyCityName())
	-- 	self._image_defence:setVisible(false)
	-- 	-- self._panel_look:setVisible(false)
	-- 	self._button_attack:setVisible(false)

	-- 	local cityQuality = self._data:getCityQuality()
	-- 	if cityQuality and cityQuality ~= 0 then
	-- 	    local citySp = display.newSprite(G_Url:getUIUrl("mine/citys", cityQuality))
	-- 	    self._node_city_icon:addChild(citySp)
	-- 	end
	-- elseif self._data:getType() == MineReportData.TYPE_CITY_TIME_OUT then
	-- 	self._node_city_icon:setVisible(true)
	-- 	self._node_icon:setVisible(false)
	-- 	self._node_power:setVisible(false)
	-- 	self._text_name:setString(data:getMyCityName())
	-- 	self._image_defence:setVisible(false)
	-- 	-- self._panel_look:setVisible(false)
	-- 	self._button_attack:setVisible(false)

	-- 	local cityQuality = self._data:getCityQuality()
	-- 	if cityQuality and cityQuality ~= 0 then
	-- 	    local citySp = display.newSprite(G_Url:getUIUrl("mine/citys", cityQuality))
	-- 	    self._node_city_icon:addChild(citySp)
	-- 	end
	-- elseif self._data:getType() == MineReportData.TYPE_DEFEND_SUCCESS then
	-- 	self._node_city_icon:setVisible(false)
	-- 	self._node_icon:setVisible(true)
	-- 	self._node_power:setVisible(true)
	-- 	self._text_power:setString(GlobalFunc.ConvertNumToCharacter(data:getPower(),0))
	-- 	self._sprite_result:setTexture("newui/common/text_bg/qilv.png")
	-- 	self._image_defence:setVisible(true)
	-- 	self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_def.png")
	-- 	-- self._panel_look:setVisible(true)
	-- 	self._button_attack:setVisible(true)
	-- 	self._text_name:setString(data:getName())

	-- 	UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
	-- 	{
	-- 		type = TypeConverter.TYPE_KNIGHT,
	-- 		value = self._data:getEnemyBaseID(),
	-- 		-- level = cellData.level,
	-- 		scale = 0.8,
	-- 		nameVisible = false
	-- 	},
	-- 	handler(self,self._onUserIconClick))
	-- elseif self._data:getType() == MineReportData.TYPE_DEFEND_FAIL then
	-- 	self._node_city_icon:setVisible(false)
	-- 	self._node_icon:setVisible(true)
	-- 	self._node_power:setVisible(true)
	-- 	self._text_power:setString(GlobalFunc.ConvertNumToCharacter(data:getPower(),0))
	-- 	self._sprite_result:setTexture("newui/common/text_bg/qihui.png")
	-- 	self._image_defence:setVisible(true)
	-- 	self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_def.png")
	-- 	-- self._panel_look:setVisible(true)
	-- 	self._button_attack:setVisible(true)
	-- 	self._text_name:setString(data:getName())

	-- 	UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
	-- 	{
	-- 		type = TypeConverter.TYPE_KNIGHT,
	-- 		value = self._data:getEnemyBaseID(),
	-- 		-- level = cellData.level,
	-- 		scale = 0.8,
	-- 		nameVisible = false
	-- 	},
	-- 	handler(self,self._onUserIconClick))
	-- elseif self._data:getType() == MineReportData.TYPE_ATTACK_SUCCESS then
	-- 	self._node_city_icon:setVisible(false)
	-- 	self._node_icon:setVisible(true)
	-- 	self._node_power:setVisible(true)
	-- 	self._text_power:setString(GlobalFunc.ConvertNumToCharacter(data:getPower(),0))
	-- 	self._sprite_result:setTexture("newui/common/text_bg/qilv.png")
	-- 	self._image_defence:setVisible(true)
	-- 	self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_att.png")
	-- 	-- self._panel_look:setVisible(true)
	-- 	self._button_attack:setVisible(false)
	-- 	self._text_name:setString(data:getName())

	-- 	UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
	-- 	{
	-- 		type = TypeConverter.TYPE_KNIGHT,
	-- 		value = self._data:getEnemyBaseID(),
	-- 		-- level = cellData.level,
	-- 		scale = 0.8,
	-- 		nameVisible = false
	-- 	},
	-- 	handler(self,self._onUserIconClick))
	-- elseif self._data:getType() == MineReportData.TYPE_ATTACK_FAIL then
	-- 	self._node_city_icon:setVisible(false)
	-- 	self._node_icon:setVisible(true)
	-- 	self._node_power:setVisible(true)
	-- 	self._text_power:setString(GlobalFunc.ConvertNumToCharacter(data:getPower(),0))
	-- 	self._sprite_result:setTexture("newui/common/text_bg/qihui.png")
	-- 	self._image_defence:setVisible(true)
	-- 	self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_att.png")
	-- 	-- self._panel_look:setVisible(true)
	-- 	self._button_attack:setVisible(false)
	-- 	self._text_name:setString(data:getName())

	-- 	UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
	-- 	{
	-- 		type = TypeConverter.TYPE_KNIGHT,
	-- 		value = self._data:getEnemyBaseID(),
	-- 		-- level = cellData.level,
	-- 		scale = 0.8,
	-- 		nameVisible = false
	-- 	},
	-- 	handler(self,self._onUserIconClick))
	-- end

	if data:showEnemy() then
		self._node_city_icon:setVisible(false)
		self._node_icon:setVisible(true)
		self._node_power:setVisible(true)
		self._text_power:setString(GlobalFunc.ConvertNumToCharacter(data:getPower(),0))
		self._sprite_result:setTexture("newui/common/text_bg/qihui.png")
		self._image_defence:setVisible(true)
		if data:isFang() then
			self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_def.png")
			self._image_defence:setVisible(data:showFanji())
		else
			self._image_defence:loadTexture("newui/uiicon/icon/icon_formation_att.png")
		end
		-- self._panel_look:setVisible(true)
		self._button_attack:setVisible(data:showFanji())
		self._text_name:setVisible(false)
		-- self._text_name:setString(data:getName())
		self._text_city_name:setVisible(false)

		UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
		{
			type = TypeConverter.TYPE_KNIGHT,
			value = self._data:getEnemyBaseID(),
			quality = self._data:getQuality(),
			textName = data:getName(),
			-- level = cellData.level,
			scale = 0.8--,
			-- nameVisible = false
		},
		handler(self,self._onUserIconClick))
	else
		self._node_city_icon:setVisible(true)
		self._node_city_icon:removeAllChildren()
		self._node_icon:setVisible(false)
		self._node_power:setVisible(false)
		self._text_city_name:setVisible(true)
		self._text_city_name:setString(data:getShowCityName())
		self._text_name:setVisible(false)
		self._image_defence:setVisible(false)
		-- self._panel_look:setVisible(false)
		self._button_attack:setVisible(false)

		local cityQuality = self._data:getCityQuality()
		if cityQuality and cityQuality ~= 0 then
		    local citySp = display.newSprite(G_Url:getUIUrl("mine/citys", cityQuality))
		    self._node_city_icon:addChild(citySp)
		end
	end

	local tipType = data:getTipType()
	if tipType == 0 then
		self._sprite_result:setVisible(false)
	elseif tipType == 1 then
		self._sprite_result:setTexture("newui/mine/ren.png")
	elseif tipType == 2 then
		self._sprite_result:setTexture("newui/common/text_bg/qilv.png")
	elseif tipType == 3 then
		self._sprite_result:setTexture("newui/common/text_bg/qihui.png")
	elseif tipType == 4 then
		self._sprite_result:setTexture("newui/mine/xie.png")
	end

	self._text_des:setString(data:getDes())


    self._image_defence:addTouchEventListener(handler(self,self._onBtnReviewClick))
    self._button_attack:addClickEventListenerEx(handler(self,self._onBtnAttackClick))

    local params = storage.load(storage.rolePath("MineBattleReportLastTime")) or {}
    if params and params.time then
    	if params.time < data:getTime() then
    		self._image_new:setVisible(true)
    	else
    		self._image_new:setVisible(false)
    	end
    else
    	self._image_new:setVisible(true)
    end
    self._text_time:setString(GlobalFunc.getPassTime(data:getTime()))
end

function MineBattleReportCell:_onBtnReviewClick()
	G_HandlersManager.commonHandler:sendGetBattleReport(self._data:getReportId())
end

function MineBattleReportCell:_onBtnAttackClick()
	if self._data:getAttackerMine() and self._data:getAttackerMine() > 0 then
		local index = self._mineData:getIndexByID(self._data:getAttackerMine())
		if self._mineData:getNowIndex() == index then
			G_Popup.newPopup(function()
	            local MineCityInfoPopup = require("app.scenes.mine.MineCityInfoPopup")
	            return MineCityInfoPopup.new(self._data:getAttackerMine())
	        end)
			self._mineBattleReportPopup:removeFromParent()
		else
			self._mineData:setShowArrowID(self._data:getAttackerMine())
			MineLayer.instance:getUI():jumpToPage(index)
			self._mineBattleReportPopup:removeFromParent()
		end
	else
		G_Popup.tip("敌方现在未占领矿场")
	end
end

function MineBattleReportCell:_onUserIconClick()
	G_HandlersManager.commonHandler:sendGetCommonBattleUser(self._data:getEnemyID(),1)
end

return MineBattleReportCell