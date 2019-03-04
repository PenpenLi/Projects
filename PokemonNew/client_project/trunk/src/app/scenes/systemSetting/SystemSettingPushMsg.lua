--
-- Author: Your Name
-- Date: 2017-06-06 14:49:27

local SystemSettingPushMsg=class("SystemSettingPushMsg",function()
    return cc.Layer:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local PushMsg = require("app.cfg.pushmail_info")
local PushMsgCell = require("app.scenes.systemSetting.SystemSettingPushMsgCell")
--
function SystemSettingPushMsg:ctor()
    self:enableNodeEvents()
    self._listViewMsg = nil
    self._msgData = {}
end

function SystemSettingPushMsg:initData()
    self._msgData = {}
    local length = PushMsg.getLength()
    local msg
    for i=1,length do
        msg = PushMsg.indexOf(i)
        self._msgData[#self._msgData + 1] = msg
    end
end

function SystemSettingPushMsg:_initWidget()
    local con = cc.CSLoader:createNode(G_Url:getCSB("SystemSettingPushMsgPopup", "systemSetting"))
    con:setPosition(display.cx,display.cy)
    self:addChild(con)
    
    UpdateNodeHelper.updateCommonNormalPop(self,G_Lang.get("system_setting_push"),function ( ... )
        self:_closePop()
    end,336)

    self:_initMsgListview()
end

function SystemSettingPushMsg:_initMsgListview()
    local panel_con = self:getSubNodeByName("Panel_con")
    local size = panel_con:getContentSize()
	self._view = require("app.ui.WListView").new(size.width,size.height,488,52)
                        :addTo(panel_con)
                        :setPosition(2,0)
    self._view:setFirstCellPaddigTop(0)
    self._view:setCreateCell(function(view,idx)
        return PushMsgCell.new(view)
    end)

    self._view:setUpdateCell(function(view,cell,idx)
        cell:setInfo(self._msgData[idx+1],idx)
    end)

    self._view:setCellNums(#self._msgData, true)
end

--
function SystemSettingPushMsg:_closePop()
    self:removeFromParent(true)
end

--
function SystemSettingPushMsg:onEnter()
    self:initData()
    self:_initWidget()
end

--
function SystemSettingPushMsg:onExit()
end

return SystemSettingPushMsg