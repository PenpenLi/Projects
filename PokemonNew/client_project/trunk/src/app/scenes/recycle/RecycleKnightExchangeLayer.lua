--
-- Author:           ...
-- Desc:             武将置换界面
--

local RecycleTabBaseRebornLayer = require "app.scenes.recycle.RecycleTabBaseRebornLayer" 
local RecycleKnightExchangeLayer = class("RecycleKnightExchangeLayer", RecycleTabBaseRebornLayer)
local FunctionConst = require "app.const.FunctionConst"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local RecycleReturnEquipRebornLayer = require "app.scenes.recycle.RecycleReturnBookWarRebornLayer"
local RecycleChooseScene = require "app.scenes.recycle.RecycleChooseScene"
local parameter_info = require "app.cfg.parameter_info"
local knight_info = require("app.cfg.knight_info")
local TeamUtils = require("app.scenes.team.TeamUtils")
local resourceManage = require("app.cfg.resource_manage")
local KnightImg = require "app.common.KnightImg" 
local RecycleKnightExchangeLayer = class("RecycleKnightExchangeLayer", function()
	return display.newLayer()
end)

function RecycleKnightExchangeLayer:ctor()
	self:enableNodeEvents()
	self._selectedItem = nil
	self:createUI()
	self._knightInfo = nil
	self.knightData_1, self.knightData_2,self.knightData_3,self.knightData_4= G_Me.recycleData:getKnightHadRecycle(false)
end

function RecycleKnightExchangeLayer:onEnter()
end

function RecycleKnightExchangeLayer:createUI()
	self._layer = cc.CSLoader:createNode(G_Url:getCSB("RecycleTabKnightExchangeLayer", "recycle"))
    self._layer:setContentSize(display.width, display.height)
    self:addChild(self._layer)
    ccui.Helper:doLayout(self._layer)
    self._touchLayer = self._layer:getSubNodeByName("Panel_touch_swallow")
    self._touchLayer:setVisible(false)
    self._touchLayer:setTouchEnabled(false)
    self._layer:updateLabel("Text_cost_desc", "置换后，用于武将置换的消耗")
    local btn_help = self._layer:getSubNodeByName("Button_help")
    btn_help:addClickEventListenerEx(handler(self, self._onClickHelp))

	self._addButton_front = self._layer:getSubNodeByName("Button_add_front")
	self._addButton_back = self._layer:getSubNodeByName("Button_add_back")
	self._iconNode1 = self._layer:getSubNodeByName("Node_icon1")
	self._iconNode2 = self._layer:getSubNodeByName("Node_icon2")
	self._costNode = self._layer:getSubNodeByName("Image_hunshi")
	self._costNodeNum = self._layer:getSubNodeByName("Text_hunshi")

	self._addButton_front:addClickEventListenerEx(handler(self, self._onClickAddFront))
	self._addButton_back:addClickEventListenerEx(handler(self, self._onClickAddBack))


	-- UpdateButtonHelper.updateNormalButton(
 --        self._layer:getSubNodeByName("Button_knight_exchg"),{
 --        state = UpdateButtonHelper.STATE_ATTENTION,
 --        desc = G_LangScrap.get("recycle_rebron"),
 --        callback = function ()
 --            self:_reborn()
 --        end
 --    })

    local fadeout = cc.FadeTo:create(1, 80)
    local fadein= cc.FadeTo:create(1, 255)
    local seq=cc.Sequence:create(fadeout, fadein)
    local repeatAction=cc.RepeatForever:create(seq)
    self._addButton_front:runAction(repeatAction)
    self._addButton_back:runAction(repeatAction)	

    self:_updateUI()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_KNIGHT_EXCHANGE, self._onKnightExchange, self)
	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECYCLE_GET_DECOMPOSE_RES, self._onJewelRebornReply, self)    
end

function RecycleKnightExchangeLayer:_updateUI()
	self._iconNode1:setVisible(self._knightInfo ~= nil)
	self._iconNode2:setVisible(self._knightInfo ~= nil)
	self._addButton_front:setVisible(self._knightInfo == nil)
	self._addButton_back:setVisible(self._knightInfo == nil)
	self._costNode:setVisible(self._knightInfo ~= nil)
	self._costNodeNum:setVisible(self._knightInfo ~= nil)
	-- self._layer:getSubNodeByName("Node_toselect"):setVisible(self._knightInfo == nil)
	-- self._layer:getSubNodeByName("Node_selected"):setVisible(self._selectedItem ~= nil)

	-- if self._knightInfo then
	-- 	-- 更新置换神将所需的货币数据
	-- 	local rm = resourceManage.get(37)
	-- 	self._layer:updateLabel("Text_hunshi_num", cfg.content)
		self:_updateIconNode()
	--     self._layer:updateLabel("Text_attr_value1", self._selectedItem.strength_level)
	-- end	
end

function RecycleKnightExchangeLayer:_updateIconNode()
	-- RecycleKnightExchangeLayer.super._updateIconNode(self)
	local nodeAvater1 = self._layer:getSubNodeByName("Node_avatar1")
	local nodeAvater2 = self._layer:getSubNodeByName("Node_avatar2")
	local data = self._knightInfo
	if data then
		-- spine
        -- local imgUrl = G_Url:getIcon_equipment(2001)
        -- --local equipImage = display.newSprite(imgUrl)
        -- local equipImage = ccui.ImageView:create(imgUrl)--display.newSprite(imgUrl)
        dump(data.cfgData.knight_id)
		local knight = KnightImg.new(data.cfgData.knight_id,0,0)
        --local rankStr = data.serverData.knightRank == 0 and "" or (" +" .. tostring(data.serverData.knightRank))
		knight:setScale(1.4)
		nodeAvater1:addChild(knight)
        self._spineToEffect = knight--:clone()
        self._spineToEffect:retain()
		-- 神将名字
		self._content:updateLabel("Text_name1",
        {
            text = data.cfgData.type == 1 and G_Me.userData.name or data.cfgData["name"], --.. rankStr,
            textColor = G_Colors.qualityColor2Color(TypeConverter.quality2Color(data.cfgData.quality))
        })
        UpdateNodeHelper.updateQualityLabel(self._content:getSubNodeByName("Text_name"), TypeConverter.quality2Color(data.cfgData.quality))
	end
end

function RecycleKnightExchangeLayer:_onClickAddFront( sender )
	local quality = parameter_info.get(650).content
	local knightData = G_Me.teamData:getAllUnPosKnightExcludeColorQuality(quality)
	if(not knightData or #knightData == 0)then
		G_Popup.tip(G_Lang.get("recycle_exchange_no_knight"))
		return
	end

	G_ModuleDirector:pushModule(nil,function ()
        local RecycleChooseKnightRebornLayer_tab = require("app.scenes.recycle.RecycleChooseKnightRebornLayer_tab").new()
        RecycleChooseKnightRebornLayer_tab:setData(self.knightData_1)
        return RecycleChooseScene.new(RecycleChooseKnightRebornLayer_tab)
    end)

    -- G_ModuleDirector:pushModule(nil,function ()
    --     local RecycleChooseJewelRebornLayer = require("app.scenes.recycle.RecycleChooseJewelRebornLayer").new(knightData)
    --     return RecycleChooseScene.new(RecycleChooseJewelRebornLayer)
    -- end)	
end

function RecycleKnightExchangeLayer:_onClickDelFront( sender )
	self._selectedItem = nil
	self:_updateUI()
end

function RecycleKnightExchangeLayer:_onClickAddBack( sender )
	G_ModuleDirector:pushModule(nil,function ()
        local RecycleChooseKnightRebornLayer_tab = require("app.scenes.recycle.RecycleChooseKnightRebornLayer_tab").new()
        RecycleChooseKnightRebornLayer_tab:setData(self.knightData_1)
        return RecycleChooseScene.new(RecycleChooseKnightRebornLayer_tab)
    end)

end

function RecycleKnightExchangeLayer:_onClickDelBack( sender )
	self._selectedItem = nil
	self:_updateUI()
end

function RecycleKnightExchangeLayer:_onClickHelp( sender )
	G_Popup.newHelpPopup(FunctionConst.FUNC_JEWELCHONGSHENG)	
end

function RecycleKnightExchangeLayer:_reborn()
	if not self._selectedItem then
		G_Popup.tip(G_Lang.get("recycle_add_reborn_jewel_first"))
		return
	end

	local rets = G_Me.jewelData:getRebornRet(self._selectedItem.id)
	local cfg = parameter_info.get(614)
	local cost = tonumber(cfg.content)
    RecycleReturnEquipRebornLayer.popup(rets, cost, function ()
    	G_Responder.enoughGold(cost, function ()
	    	G_HandlersManager.recycleHandler:reborn(self._selectedItem.id, G_TypeConverter.TYPE_JEWEL)
	    	G_widgets:getTopBar():pauseWidget()
    	end)
    end)	
end

function RecycleKnightExchangeLayer:_onJewelRebornReply( data )
	if(data.ret == 1)then
		self._selectedItem = nil
		self._touchLayer:setTouchEnabled(true)
		local awards = data.awards
		TeamUtils.playEffect("effect_chongsheng",{x=0,y=0},self._layer:getSubNodeByName("Node_icons"),"finish",function()
				G_Popup.awardSummary(awards, nil, nil, function()
				G_widgets:getTopBar():resumeWidget()
				self._touchLayer:setTouchEnabled(false)
		    	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
		    end)
		self:_updateUI()
		end, 1.40, {name = "item_5",node = self._spineToEffect, scale = 0.25})				
	end	
end

function RecycleKnightExchangeLayer:_onKnightExchange(knightInfo)
	-- self._selectedItem = knightInfo	
	self._knightInfo = knightInfo	
	dump(knightInfo)
	self:_updateUI()
end

function RecycleKnightExchangeLayer:onExit()
end

function RecycleKnightExchangeLayer:onCleanup()
	uf_eventManager:removeListenerWithTarget(self)
end

return RecycleKnightExchangeLayer