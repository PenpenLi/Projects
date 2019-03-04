--
-- Author: yutou
-- Date: 2018-09-15 17:44:52
--
--
local MineScene=class("MineScene",function()
	return display.newScene("MineScene")
end)

function MineScene:ctor()
	self:enableNodeEvents()
	-- body
	local layer = require("app.scenes.mine.MineLayer").new()
	self._layer = layer
	self:addChild(layer)
	self:addChatFloatNode()
end

function MineScene:onEnter()
	self:regeditWidgets("mainmenu",{name = "topbarResMine",res_type = G_TypeConverter.TYPE_LING_YU})
	-- self:regeditWidgets("mainmenu","topbarLevel3Block")

	local AudioConst = require "app.const.AudioConst"
    -- 背景音乐
    G_AudioManager:playBGM(AudioConst.BGM_MINE)
    self:addtUserBattleListener()
end

function MineScene:onExit()
	-- if(self._layer ~= nil)then
	-- 	self._layer:removeFromParent(true)
	-- 	self._layer = nil
	-- end
	uf_eventManager:removeListenerWithTarget(self)
end

return MineScene