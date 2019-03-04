--ActivityCompensationCell.lua

--[====================[

	补偿活动奖励列表Cell
]====================]

local ActivityCommonListCell = require("app.scenes.activity.ActivityCommonListCell")

local ActivityCompensationCell = class("ActivityCompensationCell", ActivityCommonListCell)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")


function ActivityCompensationCell:ctor(btnCallback)

	ActivityCompensationCell.super.ctor(self, btnCallback)

	--微调下位置
	self._progressLabel:setPositionX(self._progressLabel:getPositionX() + 15)
	self._progressTagLabel:setPositionX(self._progressTagLabel:getPositionX() + 15)

end


function ActivityCompensationCell:updateData( activity )

	ActivityCompensationCell.super.updateData(self)

	local activity = activity or nil

	if not activity then
		return 
	end

	--先设定默认按钮状态
	UpdateButtonHelper.updateNormalButton(self._getAwardButton, {
        state = UpdateButtonHelper.STATE_GRAY
    })

	self._conditionLabel:setString(activity.title)

	local value02 = activity.id
	local value01 = G_Me.compensationActivityData:getAwardIndex()

	local progress = string.format("%s/%s",value01,value02)
	self._progressLabel:setString(progress)
	self._progressTagLabel:setString(G_LangScrap.get("activity_text_progress"))

	--按钮状态
	if activity.getAward then
		--已经领取了
		self:updateImageView("Image_gotAward",{visible = true})
		self._getAwardButton:setVisible(false)
	else
		self:updateImageView("Image_gotAward",{visible = false})
		self._getAwardButton:setVisible(true)

		if activity.canGet then   
			UpdateButtonHelper.updateNormalButton(self._getAwardButton,{
				state = UpdateButtonHelper.STATE_ATTENTION})
		end

	end

	--物品列表
	local goodList = {}

	for i=1,3 do
		local _type = activity["type_" .. i]
		if _type > 0 then
			local value = activity["value_" .. i]
			local size = activity["num_" .. i]
			local good = {type=_type,value=value,size=size}
			table.insert(goodList,good)
		end
	end

	self:initScrollView(goodList)
end


return ActivityCompensationCell