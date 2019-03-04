
--====================
---好友请求列表
local FriendTabBaseListLayout = require "app.scenes.friend.FriendTabBaseListLayout"
local FriendTabApplyListLayout = class("FriendTabApplyListLayout", FriendTabBaseListLayout)


function FriendTabApplyListLayout:ctor(size, cellHeight,index)
	FriendTabApplyListLayout.super.ctor(self, size, cellHeight,index)
end


---返回列表显示的数据
function FriendTabApplyListLayout:_getListData()
	return G_Me.friendData:getFriendApplyList()
end

---获得显示列表Item的组件
function FriendTabApplyListLayout:_getCellClass()
	return require "app.scenes.friend.FriendApplyCell"
end

---获得无数据提示
function FriendTabApplyListLayout:_getNoItemTips()
	return G_Lang.get("friend_no_apply")
end

return FriendTabApplyListLayout