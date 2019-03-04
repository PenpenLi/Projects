--
-- Author:           cqh
-- Desc:             宝石重生界面
--

local FunctionConst = require "app.const.FunctionConst"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local RecycleReturnEquipRebornLayer = require "app.scenes.recycle.RecycleReturnBookWarRebornLayer"
local RecycleChooseScene = require "app.scenes.recycle.RecycleChooseScene"
local parameter_info = require "app.cfg.parameter_info"
local jewel_info = require("app.cfg.jewel_info")
local TeamUtils = require("app.scenes.team.TeamUtils")
local RecycleJewelRebornLayer = class("RecycleJewelRebornLayer", function()
	return display.newLayer()
end)

function RecycleJewelRebornLayer:ctor()
	self:enableNodeEvents()
	self._selectedItem = nil
	self:createUI()
end

function RecycleJewelRebornLayer:onEnter()
end

function RecycleJewelRebornLayer:createUI()
	self._layer = cc.CSLoader:createNode(G_Url:getCSB("RecycleJewelRebornLayer", "recycle"))
    self._layer:setContentSize(display.width, display.height)
    self:addChild(self._layer)
    ccui.Helper:doLayout(self._layer)
    self._touchLayer = self._layer:getSubNodeByName("Panel_touch_swallow")
    self._touchLayer:setTouchEnabled(false)
	self._layer:updateLabel("Text_help", G_Lang.get("recycle_rebron_jewel_tips"))
	self._layer:updateLabel("Text_help_all", G_Lang.get("recycle_rebron_jewel_tips_all"))
    self._layer:updateLabel("Text_attr_desc1", G_Lang.get("recycle_strength_sign"))
    local Text_attr_desc2 = self._layer:getSubNodeByName("Text_attr_desc2")
    Text_attr_desc2:setVisible(false)
    local Text_attr_value2 = self._layer:getSubNodeByName("Text_attr_value2")
    Text_attr_value2:setVisible(false)
    local btn_help = self._layer:getSubNodeByName("Button_help")
    btn_help:addClickEventListenerEx(handler(self, self._onClickHelp))

	self._addButton = self._layer:getSubNodeByName("Button_add")
	self._deleteButton = self._layer:getSubNodeByName("Button_del")
	self._iconNode = self._layer:getSubNodeByName("Node_icon")
	self._costNode = self._layer:getSubNodeByName("Node_cost")

	self._addButton:addClickEventListenerEx(handler(self, self._onClickAdd))
	self._deleteButton:addClickEventListenerEx(handler(self, self._onClickDel))

	UpdateButtonHelper.updateNormalButton(
        self._layer:getSubNodeByName("Button_reborn"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("recycle_rebron"),
        callback = function ()
            self:_reborn()
        end
    })

    local fadeout = cc.FadeTo:create(1, 80)
    local fadein= cc.FadeTo:create(1, 255)
    local seq=cc.Sequence:create(fadeout, fadein)
    local repeatAction=cc.RepeatForever:create(seq)
    self._addButton:runAction(repeatAction)	
    self:_updateUI()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_JEWEL_REBORN_SELECT, self._onSelectRebornJewel, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECYCLE_GET_DECOMPOSE_RES, self._onJewelRebornReply, self)    
end

function RecycleJewelRebornLayer:_updateUI()
	self._iconNode:setVisible(self._selectedItem ~= nil)
	self._deleteButton:setVisible(self._selectedItem ~= nil)
	self._addButton:setVisible(self._selectedItem == nil)
	self._costNode:setVisible(self._selectedItem ~= nil)
	self._layer:getSubNodeByName("Node_toselect"):setVisible(self._selectedItem == nil)
	self._layer:getSubNodeByName("Node_selected"):setVisible(self._selectedItem ~= nil)
	if self._selectedItem then
		-- 更新重生神将所需的货币数据
		local cfg = parameter_info.get(614)
		self._layer:updateLabel("Text_value", cfg.content)
		self:_updateIconNode()
	    self._layer:updateLabel("Text_attr_value1", self._selectedItem.strength_level)
	end	
end

function RecycleJewelRebornLayer:_updateIconNode()
	local nodeAvater = self._layer:getSubNodeByName("Node_avatar")
	if self._selectedItem then
		local cfg = jewel_info.get(self._selectedItem.base_id)
        local imgUrl = G_Url:getImage_jewel(cfg.icon) 
        local equipImage
        if(not nodeAvater:getChildByName("equipImage"))then
			equipImage = ccui.ImageView:create(imgUrl)--display.newSprite(imgUrl)
			equipImage:setName("equipImage")		
			equipImage:setScale(0.6)
			nodeAvater:addChild(equipImage)
		else
			equipImage = nodeAvater:getChildByName("equipImage")
		end
		self._spineToEffect = equipImage:clone()
        self._spineToEffect:retain()
		---装备名字
		local txtName = self._layer:updateLabel("Text_name", {
			text = cfg.name,
            textColor = G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(cfg.quality))
		})
        UpdateNodeHelper.updateQualityLabel(txtName, G_TypeConverter.quality2Color(cfg.quality))
	end	
end

function RecycleJewelRebornLayer:_onClickAdd( sender )
	local jewels = G_Me.jewelData:getRebornJewels()
	if(#jewels == 0)then
		G_Popup.tip(G_Lang.get("recycle_reborn_no_jewel"))
		return
	end

    G_ModuleDirector:pushModule(nil,function ()
        local RecycleChooseJewelRebornLayer = require("app.scenes.recycle.RecycleChooseJewelRebornLayer").new(jewels)
        return RecycleChooseScene.new(RecycleChooseJewelRebornLayer)
    end)	
end

function RecycleJewelRebornLayer:_onClickDel( sender )
	self._selectedItem = nil
	self:_updateUI()
end

function RecycleJewelRebornLayer:_onClickHelp( sender )
	G_Popup.newHelpPopup(FunctionConst.FUNC_JEWELCHONGSHENG)	
end

function RecycleJewelRebornLayer:_reborn()
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

function RecycleJewelRebornLayer:_onJewelRebornReply( data )
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

function RecycleJewelRebornLayer:_onSelectRebornJewel(selectedItem)
	self._selectedItem = selectedItem	
	self:_updateUI()
end

function RecycleJewelRebornLayer:onExit()
end

function RecycleJewelRebornLayer:onCleanup()
	uf_eventManager:removeListenerWithTarget(self)
end

return RecycleJewelRebornLayer