local SystemSettingGMCenterLayer = class("SystemSettingGMCenterLayer", function ()
	return display.newLayer()
end)

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local KnightTable = require "app.cfg.knight_info"
-- local knightRankInfoTable = require "app.cfg.knight_rank_info" 

SystemSettingGMCenterLayer.SHOW_KNIGHT_RES_ID = 2321

function SystemSettingGMCenterLayer:ctor()
	self:enableNodeEvents()
	self:setPosition(display.cx, display.cy)
end

function SystemSettingGMCenterLayer:onEnter()
	self._content = cc.CSLoader:createNode(G_Url:getCSB("GameMasterPanel", "systemSetting"))
    self:addChild(self._content)

    --通用弹框
    local common_node = self._content:getSubNodeByName("project_common_node")
    UpdateNodeHelper.updateCommonNormalPop(common_node, G_Lang.get("system_service_title"),function()
        --self:_showSettingPanel()
        self:removeFromParent(true)
    end,349)
    -- self:updateButton("Button_close", function ()
    -- 	self:_showSettingPanel()
    -- 	self:removeFromParent()
    -- end)

    -- local heroCon = self:getSubNodeByName("Panel_hero_con")
    -- self._hero = require("app.common.KnightImg").new(SystemSettingGMCenterLayer.SHOW_KNIGHT_RES_ID,0,0)
    -- self._hero:setScale(1.25)
    -- self._hero:setAniTimeScale(0)
    -- heroCon:addChild(self._hero)

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Node_confirm"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("system_setting_confirm"),
    --     callback = function ()
    --         self:_showSettingPanel()
    -- 		self:removeFromParent()
    --     end
    -- })
    local label = self:getSubNodeByName("Text_tips")
    label:getVirtualRenderer():setLineHeight(30)
    -- self:updateLabel("Text_title", G_LangScrap.get("system_setting_gm_center"))
    -- self:updateLabel("Text_tips", G_LangScrap.get("system_setting_gm_tips"))
    -- self:updateLabel("Text_tel_word", G_LangScrap.get("system_setting_tel_number"))
    -- self:updateLabel("Text_tel_num", G_LangScrap.get("system_setting_tel_value"))
     self:updateLabel("Text_service_qq", G_Lang.get("system_setting_qq_number"))
     self:updateLabel("Text_qq_num", G_Lang.get("system_setting_tel_number"))
end

function SystemSettingGMCenterLayer:_showSettingPanel()
	G_Popup.newPopup(function ()
		local settingPanel = require("app.scenes.systemSetting.SystemSettingLayer").new()
		return settingPanel
	end, true)
end

function SystemSettingGMCenterLayer:onExit()
	self:removeChild(self._content)
end

return SystemSettingGMCenterLayer