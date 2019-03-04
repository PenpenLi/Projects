
---==========================
---好友场景
---
---==========================
local FriendScene = class("FriendScene", function ()
	return display.newScene("FriendScene")
end)

--初始化的好友页签
function FriendScene:ctor(initIndex)
	self._friendLayer = nil
	self._initIndex = initIndex
	self:enableNodeEvents()
	self:addtUserBattleListener()
	self:addChatFloatNode()
end

function FriendScene:onEnter()
	self:regeditWidgets("mainmenu","topbarLevel2")
	--self:regeditWidgets("mainmenu","topbarPower")
	self._friendLayer = require("app.scenes.friend.FriendLayer").new(self._initIndex)
	self:addChild(self._friendLayer)
end


function FriendScene:onExit()
	self:removeChild(self._friendLayer)
	self._initIndex = nil
end

return FriendScene