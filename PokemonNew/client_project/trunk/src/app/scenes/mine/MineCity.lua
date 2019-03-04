--
-- Author: yutou
-- Date: 2018-09-18 20:36:25
--
--

local MineCity=class("MineCity",function()
	return cc.Layer:create()
end)
local MineCityInfoPopup = require("app.scenes.mine.MineCityInfoPopup")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local MineCityData = require("app.scenes.mine.data.MineCityData")
local EffectNode = require("app.effect.EffectNode")

function MineCity:ctor(data)
	self._data = data
	self._mineData = G_Me.mineData
	self:enableNodeEvents()
	self:init()
end

function MineCity:init()
    self._effectNodeBg = display.newNode()
    self:addChild(self._effectNodeBg)

	self._csbNode = cc.CSLoader:createNode("csb/mine/MineCity.csb")
	self:addChild(self._csbNode)

    -- self._text_city_name = self:getSubNodeByName("Text_city_name")
    self._sprite_arrow = self:getSubNodeByName("Sprite_arrow")
    self._img_name_bg = self:getSubNodeByName("img_name_bg")

    self._sprite_arrow:setVisible(false)
    self._button_city = self:getSubNodeByName("Button_city")
    self._button_city:addClickEventListenerEx(function( ... )
    	G_Popup.newPopup(function()
            return MineCityInfoPopup.new(self._data:getID())
        end)
    end)
    self._effectNode = display.newNode()
    self._effectNode:setPosition(self._button_city:getPosition())
    self:addChild(self._effectNode)

    self._effectNodeBg:setPosition(self._button_city:getPosition())

    self._text_name = self:getSubNodeByName("Text_name")
    self._text_guide_name = self:getSubNodeByName("Text_guide_name")

    self:render()
end

function MineCity:render()
    if self._mineData:getShowArrowID() == self._data:getID() then
        G_Popup.newPopup(function()
            local MineCityInfoPopup = require("app.scenes.mine.MineCityInfoPopup")
            return MineCityInfoPopup.new(self._data:getID())
        end)
        self._mineData:setShowArrowID(nil)
    end
    --     self._sprite_arrow:setVisible(self._data:getID() == self._mineData:getMyCityData():getID())
    
    -- self._text_city_name:setString(self._data:getCityName())
    self._button_city:loadTextureNormal(G_Url:getUIUrl("mine/citys", self._data:getQuality()))

    local effectCfgs = {
        [MineCityData.QUALITY_TIE] = {name = "effect_mine_jin",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_TONG] = {name = "effect_mine_jin",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_YIN] = {name = "effect_mine_jin",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_HUANGJIN] = {name = "effect_mine_jin",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_SHUIJING] = {name = "effect_mine_shuijing",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_ZUANSHI] = {name = "effect_mine_zhuanshi",x =0,y =0,scale = 1},
        [MineCityData.QUALITY_WUCAI] = {name = "effect_mine_wucai",x =0,y =0,scale = 1},
    }
    self._effectNode:removeAllChildren()
    local effectCfg = effectCfgs[self._data:getQuality()]
    local effect = EffectNode.createEffect( effectCfg.name,{x = effectCfg.x,y = effectCfg.y},self._effectNode)
    effect:setScale(effectCfg.scale)

    self._effectNodeBg:removeAllChildren()
    -- local effectCfg = effectCfgs[self._data:getQuality()]
    if self._data:hasData() and self._data:getID() == self._mineData:getMyCityData():getID() then
        local effect = EffectNode.createEffect("effect_base_065",{x = 17,y = 11},self._effectNodeBg)
    end
    -- effect:setScale(effectCfg.scale)

    if self._data:getOwner():hasData() then
        -- self._text_name:setString(self._data:getOwner():getName())
        local guideName = self._data:getOwner():getGuild()
        if guideName and guideName ~= "" then
            self._text_guide_name:setString("【"..guideName.."】")
        else
            self._text_guide_name:setString("")
        end
        -- self._text_name:setVisible(true)
        self._text_guide_name:setVisible(true)
        self._img_name_bg:setVisible(true)
        if self._data:getOwner():getGuild() == "" then
            self._img_name_bg:setScaleY(0.8)
        else
            self._img_name_bg:setScaleY(1.6)
        end

        UpdateNodeHelper.updateQualityLabel(self._text_name,self._data:getOwner():getColor(),self._data:getOwner():getName())
    else
        self._text_name:setVisible(false)
        self._text_guide_name:setVisible(false)
        self._img_name_bg:setVisible(false)
    end
end

function MineCity:setArrowVisible(value)
    self._sprite_arrow:setVisible(value)
end

function MineCity:onEnter()
end

function MineCity:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MineCity:onCleanup()
	self:removeAllChildren()
end

return MineCity