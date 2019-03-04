

---黑名单列表item
local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
local FriendLoversCell = class("FriendLoversCell", FriendBaseCell)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ConfirmAlert = require("app.common.ConfirmAlert")
local FriendLoversPopup = require("app.scenes.friend.FriendLoversPopup")

function FriendLoversCell:ctor()
	FriendLoversCell.super.ctor(self)
end

function FriendLoversCell:_getCSB()
	return G_Url:getCSB("FriendCell", "friend")
end

function FriendLoversCell:_freshView()
	FriendLoversCell.super._freshView(self)
    
    self:getSubNodeByName("Button_send"):setVisible(false)
    self:getSubNodeByName("Button_get"):setVisible(false)

    local btnUndo = self._view:getSubNodeByName("Button_relieve_lovers")
    btnUndo:setVisible(true)
    btnUndo:updateLabel("button_title", {
        text = "解除情侣",
        })
    UpdateButtonHelper.reviseButton(btnUndo)
    btnUndo:addClickEventListenerEx(function ()
           FriendLoversPopup.newRelieveLoversPopup()
        end)

    self:getSubNodeByName("Image_bg_effect"):setVisible(true)
    self:getSubNodeByName("FileNode_effect_lovers"):setVisible(true)

	-- UpdateButtonHelper.updateNormalButton(
 --        self:getSubNodeByName("Button_get"),{
 --        state = UpdateButtonHelper.STATE_NORMAL,
 --        desc = G_LangScrap.get("friend_black_list_cancel"),
 --        callback = function ()
 --            ConfirmAlert.createConfirmText(
 --                G_LangScrap.get("friend_black_confirm_title"),
 --                G_LangScrap.get("friend_black_remove_tips",{name = self._friendUnit:getName()}),
 --                function()
 --                    G_HandlersManager.friendHandler:sendDelFriend(self._friendUnit:getId(), G_Me.friendData.TYPE_BLACK)
 --                    self:removeFromParent(true)
 --                end
 --            )
 --        end
 --    })
end

return FriendLoversCell