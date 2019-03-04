--
-- Author: YouName
-- Date: 2015-12-28 13:39:38
--
local AudioConst = require "app.const.AudioConst"
local CampaignScene = class("CampaignScene",function()
	return display.newScene("CampaignScene")
end)

local AudioConst = require "app.const.AudioConst"

function CampaignScene:ctor( ... )
	dump("StartCampaign&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&!")
	-- body
	local layer = require("app.scenes.campaign.CampaignLayer").new()
	self:addChild(layer)
	self:addChatFloatNode()
end

function CampaignScene:onEnter( ... )
	-- body
	G_AudioManager:playBGM(AudioConst.BGM_CHUCHENG)
	self:regeditWidgets("mainmenu","topbarLevel3Block")
end

function CampaignScene:onExit( ... )
	-- body
end

return CampaignScene