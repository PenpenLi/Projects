--
-- Author: wyx
-- Date: 2018-03-07 12:29:50
--
--ActivityConsumptionRebateCell.lua

--[====================[

	超值返利奖励列表Cell
]====================]

local ActivityCommonListCell = require("app.scenes.activity.ActivityCommonListCell")

local ActivityConsumptionRebateCell = class("ActivityConsumptionRebateCell", ActivityCommonListCell)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require("app.common.TypeConverter")


function ActivityConsumptionRebateCell:ctor(btnCallback)

	ActivityConsumptionRebateCell.super.ctor(self, btnCallback)

	self._activity = nil

	--微调下位置
	--self._progressLabel:setPositionX(self._progressLabel:getPositionX() + 15)
	--self._progressTagLabel:setPositionX(self._progressTagLabel:getPositionX() + 15)

	self._progressLabel:setVisible(false)
	self._progressTagLabel:setVisible(false)

	UpdateButtonHelper.updateNormalButton(self._getAwardButton, {
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("common_btn_get_award"),
        callback = function ()
				if type(self._btnCallback) == "function" and self._activity then
			        self._btnCallback(self._activity.cfg.id)
			    end
			end
        })
end


function ActivityConsumptionRebateCell:updateData( activity )

	ActivityConsumptionRebateCell.super.updateData(self)

	self._activity = activity or nil

	if not self._activity then
		return 
	end

	--先设定默认按钮状态
	UpdateButtonHelper.updateNormalButton(self._getAwardButton, {
        state = UpdateButtonHelper.STATE_GRAY
    })

	local reward_title = ""
	if self._activity.cfg.task_type == 1 then
		reward_title = G_Lang.get("activity_consumption_login")
	else
		reward_title = G_Lang.get("activity_consumption_gold",{num = self._activity.cfg.task_value})
	end
	self._conditionLabel:setString(reward_title)

	--按钮状态
	if activity.reward:getHasBeenGot() then
		--已经领取了
		self:updateImageView("Image_gotAward",{visible = true})
		self._getAwardButton:setVisible(false)
	else
		self:updateImageView("Image_gotAward",{visible = false})
		self._getAwardButton:setVisible(true)

		if activity.reward:getCanReceive() then
			UpdateButtonHelper.updateNormalButton(self._getAwardButton, {
		        state = UpdateButtonHelper.STATE_ATTENTION,
		        effect = true
		    })
		end
		
	end

	-- --物品列表
	-- local _type = activity.cfg.type
	-- local _value = activity.cfg.value
	-- local _size = activity.cfg

	-- local goodList = {{type=_type, value=_value, size = _size}}
	dump(activity.reward.awards)
	self:initScrollView(activity.reward.awards)
end


return ActivityConsumptionRebateCell