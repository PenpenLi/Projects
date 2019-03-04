local SystemSettingLayer = class("SystemSettingLayer", function ()
	return display.newLayer()
end)

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local KnightTable = require "app.cfg.knight_info"
-- local knightRankInfoTable = require "app.cfg.knight_rank_info" 
local storage = require("app.storage.storage")
local SYSTEM_SET_FIFLE = "systemSet.data"

SystemSettingLayer.OPEN_KEY = "open"
SystemSettingLayer.CLOSE_KEY = "close"

SystemSettingLayer.SHOW_KNIGHT_RES_ID = 11

---系统弹窗界面
function SystemSettingLayer:ctor()
	self:enableNodeEvents()
	self:setPosition(display.cx, display.cy)
end

function SystemSettingLayer:onEnter()
	self._content = cc.CSLoader:createNode(G_Url:getCSB("SystemSettingNode", "systemSetting"))
    self:addChild(self._content)

    --通用弹框
    local common_node = self._content:getSubNodeByName("Project_common_node")
    UpdateNodeHelper.updateCommonNormalPop(common_node, G_Lang.get("system_setting_title"),function()
        self:removeFromParent(true)
    end)

    local objServer=G_PlatformProxy:getLoginServer()
    local uid = G_Me.userData.id
    local uidStr = tostring(uid)
    if #uidStr > 6 then
        local shotUid = string.sub(uidStr, #uidStr - 5)
        uid = tonumber(shotUid)
    end
    self:updateLabel("Text_server", G_LangScrap.get("system_setting_service", {name = objServer.name}))
    self:updateLabel("Text_ID", G_LangScrap.get("system_setting_ID", {value = tostring(uid)}))

    local heroCon = self:getSubNodeByName("Panel_hero_con")
    self._hero = require("app.common.KnightImg").new(SystemSettingLayer.SHOW_KNIGHT_RES_ID,0,0)
    self._hero:setScale(1.25)
    self._hero:setAniTimeScale(0)
    heroCon:addChild(self._hero)

    --切换帐号
    local btn_fun
    btn_fun = self:getSubNodeByName("Button_change_account")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:addClickEventListenerEx(function()
        G_PlatformProxy:logoutPlatform()
    end)
    dump2(SDK_TYPE,SDK_TYPES.ZHISHANG)
    if SDK_TYPE == SDK_TYPES.ZHISHANG then
        btn_fun:setEnabledEx(false)
    end

    --游戏公告
    --local popupUrl = G_Setting.get("popupUrl")
    local popupUrl = G_Setting.getConfig("notice")    
    dump(popupUrl)
    local announcementVisible = false
    --if ccexp.WebView and popupUrl ~= nil and popupUrl ~= "" then
    if  popupUrl ~= nil and popupUrl ~= "" then
        announcementVisible = true
    end

    btn_fun = self:getSubNodeByName("Button_announcement")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:addClickEventListenerEx(function()
        if announcementVisible then
            G_Popup.newPopup(function()
                return require("app.scenes.login.LoginNotice").new(popupUrl, nil)
            end, true)
        else
            G_Popup.tip(G_Lang.get("暂无游戏公告"))
        end
    end)

    -- VIP设置
    btn_fun = self:getSubNodeByName("Button_vip")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:setEnabledEx(false)
    btn_fun:addClickEventListenerEx(function()
        G_Popup.newPopup(function()
                    return require("app.scenes.systemSetting.SystemSettingVip").new()
                end,true)
    end)

    -- 推送设置
    btn_fun = self:getSubNodeByName("Button_pushMsg")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:setEnabledEx(false)
    btn_fun:addClickEventListenerEx(function()
        G_Popup.newPopup(function()
                    return require("app.scenes.systemSetting.SystemSettingPushMsg").new()
                end)
    end)

    -- 客服中心
    btn_fun = self:getSubNodeByName("Button_GM")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:addClickEventListenerEx(function()
        G_Popup.newPopupWithTouchEnd(function ()
        --G_Popup.newPopup(function()
                    return require("app.scenes.systemSetting.SystemSettingGMCenterLayer").new()
                end,false,false)
    end)

    -- 实名认证
    btn_fun = self:getSubNodeByName("Button_certification")
    UpdateButtonHelper.reviseButton(btn_fun)
    btn_fun:setEnabledEx(false)
    btn_fun:addClickEventListenerEx(function()
        
    end)

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_GM"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     --visible = G_PlatformProxy:hasCustomerService() or false,
    --     visible = true,
    --     desc = G_LangScrap.get("system_setting_gm_button"),
    --     callback = function ()
    --         G_Popup.newPopup(function()
    --                 return require("app.scenes.systemSetting.SystemSettingGMCenterLayer").new()
    --             end)
    --         --G_PlatformProxy:openCustomerService()
    --     end
    -- })

    -- local popupUrl = G_Setting.get("popupUrl")
    -- local announcementVisible = false
    -- if ccexp.WebView and popupUrl ~= nil and popupUrl ~= "" then
    --     announcementVisible = true
    -- end
    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_announcement"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("system_setting_game_announce"),
    --     -- visible = announcementVisible,
    --     visible = true,
    --     callback = function ()
    --         if announcementVisible then
    --             G_Popup.newPopup(function()
    --                 return require("app.scenes.login.LoginNotice").new(popupUrl, nil)
    --             end, true)
    --         else
    --             G_Popup.tip(G_LangScrap.get("mission_function_not_open"))
    --         end
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_vip"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     visible = true,
    --     desc = G_LangScrap.get("system_setting_vip"),
    --     callback = function ()
    --         G_Popup.newPopup(function()
    --                 return require("app.scenes.systemSetting.SystemSettingVip").new()
    --             end,true)
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_pushMsg"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     visible = true,
    --     desc = G_LangScrap.get("system_setting_push"),
    --     callback = function ()
    --         G_Popup.newPopup(function()
    --                 return require("app.scenes.systemSetting.SystemSettingPushMsg").new()
    --             end)
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_certification"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("system_setting_certification")
    --     -- callback = function ()
    --     --     G_Popup.newPopup(function()
    --     --             return require("app.scenes.systemSetting.SystemSettingPushMsg").new()
    --     --         end)
    --     -- end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_share"),{
    --     state = UpdateButtonHelper.STATE_ATTENTION,
    --     desc = G_LangScrap.get("system_setting_share"),
    --     visible = false,
    --     callback = function ()
    --         G_Popup.tip(G_LangScrap.get("mission_function_not_open"))
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_forum"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     visible = G_PlatformProxy:hasForum() or false,
    --     desc = G_LangScrap.get("system_forum"),
    --     callback = function ()
    --         G_PlatformProxy:openForum()
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self:getSubNodeByName("Button_user_center"),{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     visible = G_PlatformProxy:hasPersonalCenter() or false,
    --     desc = G_LangScrap.get("system_user_center"),
    --     callback = function ()
    --         G_PlatformProxy:openPersonalCenter()
    --     end
    -- })

    local bgMusicEnable = G_GameSetting:isBackgroundMusicEnabled()
    self:_updateSelection("Node_music_", bgMusicEnable)

    local soundEffectEnable = G_GameSetting:isSoundEnabled()
    self:_updateSelection("Node_sound_effect_", soundEffectEnable)

	local panelEffectEnable = G_GameSetting:isEffectEnabled()
    self:_updateSelection("Node_panel_effect_", panelEffectEnable)

    local function addListener2CheckBox(node, callback)
    	local chekcBox = node:getSubNodeByName("CheckBox")
    	chekcBox:addEventListener(callback)
    end

    ----背景音乐
    local bgMusicOpenCheck = self:getSubNodeByName("Node_music_open")
    addListener2CheckBox(bgMusicOpenCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setBackgroundMusicEnabled(true)
            self:_updateSelection("Node_music_", true)
            G_AudioManager:setBGMusicEnabled(true)
		elseif eventType == ccui.CheckBoxEventType.unselected then
			G_GameSetting:setBackgroundMusicEnabled(false)	
    		self:_updateSelection("Node_music_", false)
            G_AudioManager:setBGMusicEnabled(false)
	    end
    end)
    bgMusicOpenCheck:updateLabel("Text_disc", G_Lang.get("system_setting_open"))

    local bgMusicCloseCheck = self:getSubNodeByName("Node_music_close")
    addListener2CheckBox(bgMusicCloseCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setBackgroundMusicEnabled(false)
    		self:_updateSelection("Node_music_", false)
            G_AudioManager:setBGMusicEnabled(false)
		elseif eventType == ccui.CheckBoxEventType.unselected then	
			G_GameSetting:setBackgroundMusicEnabled(true)
    		self:_updateSelection("Node_music_", true)
            G_AudioManager:setBGMusicEnabled(true)
	    end
    end)
    bgMusicCloseCheck:updateLabel("Text_disc", G_Lang.get("system_setting_close"))


    ---游戏音效
    local bgSoundeOpenCheck = self:getSubNodeByName("Node_sound_effect_open")
    addListener2CheckBox(bgSoundeOpenCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setSoundEnabled(true)
    		self:_updateSelection("Node_sound_effect_", true)
            G_AudioManager:setSoundEnabled(true)
		elseif eventType == ccui.CheckBoxEventType.unselected then
			G_GameSetting:setSoundEnabled(false)	
    		self:_updateSelection("Node_sound_effect_", false)
            G_AudioManager:setSoundEnabled(false)
	    end
    end)
    bgSoundeOpenCheck:updateLabel("Text_disc", G_Lang.get("system_setting_open"))

    local bgSoundeCloseCheck = self:getSubNodeByName("Node_sound_effect_close")
    addListener2CheckBox(bgSoundeCloseCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setSoundEnabled(false)
            self:_updateSelection("Node_sound_effect_", false)
            G_AudioManager:setSoundEnabled(false)
		elseif eventType == ccui.CheckBoxEventType.unselected then	
			G_GameSetting:setSoundEnabled(true)
            self:_updateSelection("Node_sound_effect_", true)
            G_AudioManager:setSoundEnabled(true)
	    end
    end)
    bgSoundeCloseCheck:updateLabel("Text_disc", G_Lang.get("system_setting_close"))

    ----界面特效
    local panelEffectOpenCheck = self:getSubNodeByName("Node_panel_effect_open")
    addListener2CheckBox(panelEffectOpenCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setEffectEnabled(true)
            self:_updateSelection("Node_panel_effect_", true)
		elseif eventType == ccui.CheckBoxEventType.unselected then
			G_GameSetting:setEffectEnabled(false)
            self:_updateSelection("Node_panel_effect_", false)	
	    end
    end)
    panelEffectOpenCheck:updateLabel("Text_disc", G_Lang.get("system_setting_open"))

    local panelEffectCloseCheck = self:getSubNodeByName("Node_panel_effect_close")
    addListener2CheckBox(panelEffectCloseCheck, function (sender, eventType)
    	if eventType == ccui.CheckBoxEventType.selected then 
    		G_GameSetting:setEffectEnabled(false)
            self:_updateSelection("Node_panel_effect_", false)
		elseif eventType == ccui.CheckBoxEventType.unselected then	
			G_GameSetting:setEffectEnabled(true)
    		self:_updateSelection("Node_panel_effect_", true)
	    end
    end)
    panelEffectCloseCheck:updateLabel("Text_disc", G_Lang.get("system_setting_close"))

    --self:_sortButtons()
end

function SystemSettingLayer:onExit()
    self:removeChild(self._content)
end

---排列所有的按钮。
---把不显示的空出来
function SystemSettingLayer:_sortButtons()
    local buttons = {
        self:getSubNodeByName("Button_change_account"),
        self:getSubNodeByName("Button_GM"),
        self:getSubNodeByName("Button_announcement"),
        self:getSubNodeByName("Button_share"),
        self:getSubNodeByName("Button_forum"),
        self:getSubNodeByName("Button_user_center")
    }

    local placedNum = 0
    for i = 1, #buttons do
        local button = buttons[i]
        if button:isVisible() then
            button:setPositionX((placedNum % 4) * 140)
            button:setPositionY(math.floor(placedNum/4) * -66)
            placedNum = placedNum + 1
        end
    end
end

function SystemSettingLayer:_updateSelection(key, enable)
	local openNode = self:getSubNodeByName(key .. SystemSettingLayer.OPEN_KEY)
	local closeNode = self:getSubNodeByName(key .. SystemSettingLayer.CLOSE_KEY)

	local function updateState(node, enable)
		local checkBox = node:getSubNodeByName("CheckBox")
		local selected = checkBox:isSelected()
		if enable ~= selected then
			checkBox:setSelected(enable)
		end
	end

	updateState(openNode, enable)
	updateState(closeNode, not enable)
end

return SystemSettingLayer