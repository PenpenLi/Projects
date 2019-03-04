--ActivityDay7TopCell.lua

--[====================[

	七日战力榜排名Cell
]====================]


local ActivityDay7TopCell = class("ActivityDay7TopCell",function()
	return cc.TableViewCell:new()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require ("app.common.TypeConverter")
local TextHelper = require ("app.common.TextHelper")

function ActivityDay7TopCell:ctor()

	self._container = cc.CSLoader:createNode(G_Url:getCSB("ActivityDay7TopCellNode","activity"))
    self:addChild(self._container)

	self._powerLabel = self:getSubNodeByName("BitmapFontLabel_power")
	self._guildLabel = self:getSubNodeByName("Label_guild_name")

	self._guildLabel:setString("")
	self._powerLabel:setString("")

end


function ActivityDay7TopCell:updateData(rankInfo, index)

	local rankInfo = rankInfo or nil

	self._powerLabel:setString("")
	self._guildLabel:setString("")

	if not rankInfo then
		return 
	end

	local function _onIconCallback()
        --查看玩家信息
        if G_Me.userData.name == rankInfo.name then           
            return
        end
        G_HandlersManager.commonHandler:sendGetCommonBattleUser(rankInfo.uid,1)
    end

    UpdateNodeHelper.updateCommonRankCellNode(self, 
        {
        	rankNum = index,
        	rankName = rankInfo.name, 
        	isSelf = G_Me.userData.name == rankInfo.name
        },
        {	nameVisible = false ,sizeVisible = false,
        	type = TypeConverter.TYPE_KNIGHT,
        	value = rankInfo.knight_id,
        	level = rankInfo.level,
        	rank = rankInfo.rank_lv
        }, 
        _onIconCallback)

	self._powerLabel:setString(TextHelper.getAmountText(rankInfo.power))

	local guildName = rankInfo.guild ~= "" and rankInfo.guild or G_LangScrap.get("common_text_no")
	self._guildLabel:setString(guildName)

end


return ActivityDay7TopCell