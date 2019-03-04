

---好友列表item
local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
local FriendRecommandCell = class("FriendRecommandCell", FriendBaseCell)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function FriendRecommandCell:ctor()
	FriendRecommandCell.super.ctor(self)
end

function FriendRecommandCell:_getCSB()
	return G_Url:getCSB("FriendRecommandCell", "friend")
end

function FriendRecommandCell:_freshView()
	FriendRecommandCell.super._freshView(self)

    local btnCall = self._view:getSubNodeByName("Button_add")
    UpdateButtonHelper.reviseButton(btnCall)
    btnCall:setEnabledEx(true)
    btnCall:addClickEventListenerEx(function ()
            G_HandlersManager.friendHandler:sendAddFriend(self._friendUnit:getName(), G_Me.friendData.TYPE_FRIEND)--加好友
        end)

	-- UpdateButtonHelper.updateNormalButton(
 --        self:getSubNodeByName("Button_call"),{
 --        state = UpdateButtonHelper.STATE_NORMAL,
 --        desc = G_LangScrap.get("friend_button_add_friend"),
 --        delay = 100,
 --        callback = function ()
 --            G_HandlersManager.friendHandler:sendAddFriend(self._friendUnit:getName(), G_Me.friendData.TYPE_FRIEND)--加好友
 --        end
 --    })
end

return FriendRecommandCell