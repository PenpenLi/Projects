--ActivityDay7TopAwardCell.lua

--[====================[

	七日战力榜排名奖励Cell
]====================]

local ActivityCommonListCell = require("app.scenes.activity.ActivityCommonListCell")

local ActivityDay7TopAwardCell = class("ActivityDay7TopAwardCell", ActivityCommonListCell)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
--local TypeConverter = require ("app.common.TypeConverter")


function ActivityDay7TopAwardCell:ctor()

	ActivityDay7TopAwardCell.super.ctor(self)
	
	self._progressLabel:setVisible(false)
	self._progressTagLabel:setVisible(false)

end


function ActivityDay7TopAwardCell:updateData( awardInfo, index )

	ActivityDay7TopAwardCell.super.updateData(self)

	local awardInfo = awardInfo or nil

	if not awardInfo then
		return 
	end

	if awardInfo.top_min == awardInfo.top_max then
		self._conditionLabel:setString(G_LangScrap.get("days7_top_rank_award1",
			{rank=awardInfo.top_max}))
	else
		self._conditionLabel:setString(G_LangScrap.get("days7_top_rank_award2",
			{rank1=awardInfo.top_min,rank2=awardInfo.top_max}))
	end

	--物品列表
	local goodList = {}

	for i=1,4 do
		local _type = awardInfo["type_" .. i]
		if _type > 0 then
			local value = awardInfo["value_" .. i]
			local size = awardInfo["size_" .. i]
			local good = {type=_type,value=value,size=size}
			--if good then
				table.insert(goodList,good)
			--end
		end
	end

	self:initScrollView(goodList)
end



return ActivityDay7TopAwardCell