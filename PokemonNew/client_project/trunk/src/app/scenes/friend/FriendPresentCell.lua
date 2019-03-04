

---好友赠送精力列表item
local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
local FriendPresentCell = class("FriendPresentCell", FriendBaseCell)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function FriendPresentCell:ctor()
	FriendPresentCell.super.ctor(self)
end

function FriendPresentCell:_getCSB()
	return G_Url:getCSB("FriendCell", "friend")
end

function FriendPresentCell:_freshView()
	FriendPresentCell.super._freshView(self)

	self._view:getSubNodeByName("Button_call"):setVisible(self._friendUnit:canGetPresent())
	self._view:getSubNodeByName("Image_pass"):setVisible(not self._friendUnit:canGetPresent())
	self._view:getSubNodeByName("Image_pass"):loadTexture(G_Url:getText_signet("w_img2_signet03"))

	UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("friend_button_get_present"),
        delay = 100,
        callback = function ()
        	local tips = G_Me.friendData:getPresentTips()
        	if tips then
        		G_Popup.tip(tips)
        	else
        		G_HandlersManager.friendHandler:sendGetFriendPresent(self._friendUnit:getId())--领取
        	end
        end
    })
end

return FriendPresentCell