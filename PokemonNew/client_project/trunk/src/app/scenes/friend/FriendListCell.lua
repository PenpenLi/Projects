

---好友列表item
local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
local FriendListCell = class("FriendListCell", FriendBaseCell)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ParameInfo = require "app.cfg.parameter_info"
local TeamUtils = require("app.scenes.team.TeamUtils")

function FriendListCell:ctor()
	FriendListCell.super.ctor(self)
    self._effectNode = nil
    self._effectNode2 = nil
end

function FriendListCell:_getCSB()
	return G_Url:getCSB("FriendCell", "friend")
end

function FriendListCell:_freshGet()
    local btnGet = self._view:getSubNodeByName("Button_get")
    --btnGet:setEnabled(self._friendUnit:canGetPresent())
    --btnGet:setVisible(self._friendUnit:canGetPresent())
    -- local maxNum = tonumber(ParameInfo.get(262).content)
    -- print("ddd",maxNum,G_Me.userData.vit) 
    -- if G_Me.userData.vit >= maxNum then
    --     print("ddd",maxNum,G_Me.userData.vit)
    --     btnGet:updateLabel("button_title", {
    --     text = G_Lang.get("friend_get_full"),
    --     fontSize = 24 
    --     })
    -- else
    --     btnGet:updateLabel("button_title", {
    --     text = self._friendUnit:canGetPresent() == true and G_Lang.get("friend_can_get") or G_Lang.get("friend_finish_get"),
    --     fontSize = self._friendUnit:canGetPresent() == true and 24 or 22
    --     })
    -- end
    btnGet:updateLabel("button_title", {
        text = self._friendUnit:canGetPresent() == true and G_Lang.get("friend_can_get") or G_Lang.get("friend_finish_get"),
        --fontSize = self._friendUnit:canGetPresent() == true and 24 or 22
        })
    
end

function FriendListCell:_freshSend()
    local btnSend = self._view:getSubNodeByName("Button_send")
    btnSend:setEnabledEx(self._friendUnit:canSendPresent())
    btnSend:updateLabel("button_title", {
        text = self._friendUnit:canSendPresent() == true and G_Lang.get("friend_can_send") or G_Lang.get("friend_finish_send"),
        --fontSize = self._friendUnit:canSendPresent() == true and 24 or 22
        })
end

function FriendListCell:_freshView()
	FriendListCell.super._freshView(self)
    local present = self._friendUnit:canGetPresent()
    local btn_get = self._view:getSubNodeByName("Button_get")
    local btnSend = self._view:getSubNodeByName("Button_send")
    UpdateButtonHelper.reviseButton(btn_get)
    UpdateButtonHelper.reviseButton(btnSend)
    -- 该好友没赠送体力，无体力可领取，领取按钮不显示,赠送按钮居中显示
    if not present then
        btn_get:setVisible(false)
        btnSend:setPositionY(68)
        self:_freshSend()
    else
        btn_get:setPositionY(101)
        btn_get:setVisible(true)
        btnSend:setPositionY(42)
        self:_freshGet()
        self:_freshSend()
    end
    btn_get:addClickEventListenerEx(function ()
            local tips = G_Me.friendData:getPresentTips()
            if tips and not self._friendUnit:isMyLovers() then
                G_Popup.tip(tips)
            else
                G_HandlersManager.friendHandler:sendGetFriendPresent(self._friendUnit:getId())--领取
            end
        end)
    btnSend:addClickEventListenerEx(function ()
            G_HandlersManager.friendHandler:sendFriendPresent(self._friendUnit:getId())--赠送
        end)

    --dump(self._friendUnit:isMyLovers())
    --self:getSubNodeByName("Image_lovers_show"):setVisible(self._friendUnit:isMyLovers())
    self:getSubNodeByName("FileNode_effect_lovers"):setVisible(self._friendUnit:isMyLovers())
    self:getSubNodeByName("Image_lovers_show"):setVisible(false)
    local Image_bg_effect = self:getSubNodeByName("Image_bg_effect")
	-- UpdateButtonHelper.updateNormalButton(
 --        self:getSubNodeByName("Button_get"),{
 --        state = UpdateButtonHelper.STATE_NORMAL,
 --        desc = G_LangScrap.get("friend_button_get_present"),
 --        delay = 100,
 --        callback = function ()
 --            local tips = G_Me.friendData:getPresentTips()
 --            if tips then
 --                G_Popup.tip(tips)
 --            else
 --                G_HandlersManager.friendHandler:sendGetFriendPresent(self._friendUnit:getId())--领取
 --            end
 --        end
 --    })
 --    UpdateButtonHelper.updateNormalButton(
 --        self:getSubNodeByName("Button_send"),{
 --        state = UpdateButtonHelper.STATE_NORMAL,
 --        desc = G_LangScrap.get("friend_button_send_present"),
 --        delay = 100,
 --        callback = function ()
 --            G_HandlersManager.friendHandler:sendFriendPresent(self._friendUnit:getId())--赠送
 --        end
 --    })
   
    self._effectNode = TeamUtils.playEffect("effect_love_zhuan",{x=0,y=0},self._view:getSubNodeByName("Node_effect_1"),"finish")
    if self._friendUnit:isMyLovers() then
        self._effectNode:setVisible(true)
        Image_bg_effect:setVisible(true)
    else
        self._effectNode:setVisible(false)
        Image_bg_effect:setVisible(false)
    end
end

return FriendListCell