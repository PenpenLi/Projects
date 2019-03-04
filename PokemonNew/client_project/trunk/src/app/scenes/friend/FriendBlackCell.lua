

---黑名单列表item
local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
local FriendBlackCell = class("FriendBlackCell", FriendBaseCell)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ConfirmAlert = require("app.common.ConfirmAlert")

function FriendBlackCell:ctor()
	FriendBlackCell.super.ctor(self)
end

function FriendBlackCell:_getCSB()
	return G_Url:getCSB("FriendCell", "friend")
end

function FriendBlackCell:_freshView()
	FriendBlackCell.super._freshView(self)
    
    self:getSubNodeByName("Button_send"):setVisible(false)
    self:getSubNodeByName("Button_get"):setPositionY(68)

    local btnUndo = self._view:getSubNodeByName("Button_get")
    btnUndo:updateLabel("button_title", {
        text = "解除",
        })
    btnUndo:addClickEventListenerEx(function ()
            ConfirmAlert.createConfirmText(
                G_Lang.get("friend_black_confirm_title"),
                G_Lang.get("friend_black_remove_tips",{name = self._friendUnit:getName()}),
                function()
                    G_HandlersManager.friendHandler:sendDelFriend(self._friendUnit:getId(), G_Me.friendData.TYPE_BLACK)
                    self:removeFromParent(true)
                end
            )
        end)
    UpdateButtonHelper.reviseButton(btnUndo)

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

return FriendBlackCell