--
-- Author: yutou
-- Date: 2019-01-14 21:23:43
--

local SoulPossessionScene=class("SoulPossessionScene",function()
	return display.newScene("SoulPossessionScene")
end)

local AudioConst = require "app.const.AudioConst"
local SoulPossessionLayerManager = require("app.scenes.soulPossession.SoulPossessionLayerManager")

function SoulPossessionScene:ctor()
	self:enableNodeEvents()
	-- body
	self._layer = nil--SoulPossessionLayerManager
	self:addtUserBattleListener()
	self:addChatFloatNode()

	G_Me.soulPossessionData:init()
	self:_initUI()
end

function SoulPossessionScene:_initUI()
	-- body
	if(self._layer ~= nil)then
		self._layer:removeFromParent(true)
		self._layer = nil
	end

	self._layer = SoulPossessionLayerManager.new()
	self:addChild(self._layer)


	--G_Popup.buySingleConfirm(ItemConst.TI_LI_DAN_ID)

end

function SoulPossessionScene:onEnter()
	-- self:regeditWidgets("mainmenu","topbarLevel2Block")
	self:regeditWidgets("mainmenu",{name = "topbarResSoul",res_type = G_TypeConverter.TYPE_SOUL_STONE})

	local AudioConst = require "app.const.AudioConst"
    -- 背景音乐
    -- G_AudioManager:playBGM(AudioConst.BGM_TOMB)
end

function SoulPossessionScene:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function SoulPossessionScene:onCleanup()
	-- body
	if(self._layer ~= nil)then
		self._layer:removeFromParent(true)
		self._layer = nil
	end
	G_Me.soulPossessionData:release()
end

return SoulPossessionScene