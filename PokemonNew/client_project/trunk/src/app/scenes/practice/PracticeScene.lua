--
-- Author: Yutou
-- Date: 2018-01-16 21:28:04
--
--
local PracticeScene=class("PracticeScene",function()
	return display.newScene("PracticeScene")
end)

local AudioConst = require "app.const.AudioConst"

function PracticeScene:ctor()
	self:enableNodeEvents()
	self:addtUserBattleListener()
	-- body
	self._layer = nil--MatchLayer
	self:addtUserBattleListener()
	self:addChatFloatNode()

	-- self._layer = require("app.scenes.practice.PracticeMainLayer").new()
	-- self:addChild(self._layer)

	--G_Me.tombData:init()
end

function PracticeScene:_initUI()
	if(self._layer ~= nil)then
		self._layer:removeFromParent(true)
		self._layer = nil
	end
	
	self._layer = require("app.scenes.practice.PracticeMainLayer").new()
	self:addChild(self._layer)
	
	--G_Popup.buySingleConfirm(ItemConst.TI_LI_DAN_ID)

end

function PracticeScene:onEnter()
	self:_initUI()
	--self:regeditWidgets("mainmenu","topbarLevel2Block")
	self:regeditWidgets("mainmenu",{name = "topbarResBlock",res_type = G_TypeConverter.TYPE_EXCLUSIVE_MONEY})
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,2301)
	
	local AudioConst = require "app.const.AudioConst"
    -- 背景音乐
    G_AudioManager:playBGM(AudioConst.BGM_TOMB)
end

function PracticeScene:onExit()
	-- body
	if(self._layer ~= nil)then
		self._layer:removeFromParent(true)
		self._layer = nil
	end
	uf_eventManager:removeListenerWithTarget(self)
end

function PracticeScene:onCleanup( ... )
	G_Me.tombData:release()
end

return PracticeScene