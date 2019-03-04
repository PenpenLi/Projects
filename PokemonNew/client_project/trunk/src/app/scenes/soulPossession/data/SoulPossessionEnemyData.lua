--
-- Author: yutou
-- Date: 2019-01-15 19:12:34
--

local SoulPossessionEnemyData=class("SoulPossessionEnemyData")
local soul_info = require("app.cfg.soul_possession_info")

function SoulPossessionEnemyData:ctor(id,serverDatas)
	self.cfg = nil
	self.id = id
	self:init()
	if serverDatas then
		self:update( serverDatas )
	end
end

function SoulPossessionEnemyData:init()

end

function SoulPossessionEnemyData:update( serverDatas )
	self._serverDatas = serverDatas

end

return SoulPossessionEnemyData