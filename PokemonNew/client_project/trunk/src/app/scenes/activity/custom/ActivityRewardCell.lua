--ActivityRewardCell.lua

--[====================[

	可配置活动奖励列表Cell
]====================]

local ActivityCommonListCell = require("app.scenes.activity.ActivityCommonListCell")

local ActivityRewardCell = class("ActivityRewardCell", ActivityCommonListCell)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require ("app.common.TypeConverter")
local ActivityConst = require("app.const.ActivityConst")


function ActivityRewardCell:ctor(btnCallback)

	ActivityRewardCell.super.ctor(self, btnCallback)

end


function ActivityRewardCell:updateData(quest)
	ActivityRewardCell.super.updateData(self)

	local quest = quest or nil

	local curQuest = G_Me.activityData.custom:getCurQuestByQuest(quest)

	if not quest or not curQuest then
		return
	end

	--先设定默认按钮状态
	UpdateButtonHelper.updateNormalButton(self._getAwardButton, {
        state = UpdateButtonHelper.STATE_ATTENTION,
        effect = true,
        desc = G_LangScrap.get("common_btn_get_award"),
        callback = function ()
				if type(self._btnCallback) == "function" then
			        self._btnCallback(quest, curQuest)
			    end
			end
        })

	local act = G_Me.activityData.custom:getActivityByActId(quest.act_id)
	local value02 = tonumber(quest.param1) or 0   --完成所需次数
	local value01 = tonumber(curQuest.progress) or 0   --当前进度
	local condition = ""

	local awardTimes = tonumber(curQuest.award_times) or 0  --已领取次数
	local awardLimit = tonumber(quest.award_limit) or 0  --可领取次数限制

	--活动期间获取#name##num#个
	if quest.quest_type == ActivityConst.QUEST_TYPE_PUSH_ITEM then
		local good = TypeConverter.convert({type=quest.param1, value=quest.param2, size=quest.param3})
		--此时第三个参数为所需次数
		value02 = tonumber(quest.param3) or 0   --完成所需次数
		if good then
			--dump(good)
			condition = GlobalFunc.decodeKvPairs(quest.quest_des,
				{	{key="name", value=good.cfg.name},
				 	{key="num", value=good.size}
				})
			self._conditionLabel:setString(condition or "")
		else
			self._conditionLabel:setString("")
		end

	--连续#num1#日充值#num2#元
	elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_SOME_TODAY_REACH then 
		--quest.quest_des = "连续#num1#日充值#num2#元"   --TEST
		condition = GlobalFunc.decodeKvPairs(quest.quest_des,
			{
				{key="num1", value=quest.param1},
				{key="num2", value=quest.param2}
			})

		self._conditionLabel:setString(condition)
	--单笔充值达到#num1#~#num2#元  
	-- elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_BETWEEN then  
	-- 	condition = GlobalFunc.decodeKvPairs(quest.quest_des,
	-- 		{
	-- 			{key="num1", value=quest.param1},
	-- 			{key="num2", value=quest.param2}
	-- 		})
	-- 	if tonumber(quest.param2) <= tonumber(quest.param1) then
	-- 		--配置错了
	-- 		condition = ""
	-- 	end
	-- 	self._conditionLabel:setString(condition)
	else
		condition = tonumber(quest.param1) > 0 and 
			GlobalFunc.decodeKvPair(quest.quest_des,{key="num", value=value02}) or ""
		self._conditionLabel:setString(condition)
	end

	--单笔充值达到#num
	if quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_REACH 
		or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_EVERYDAY_REACH
		or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_REACH_MUCH
		or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_EVERYDAY_REACH_MUCH
		 then
		--当领取次数比进度小时，显示领取
		--dump(quest)
		--dump(awardTimes)
		--dump(curQuest)
		value02 = tonumber(quest.award_limit) --最多可领的次数
		value01 = awardTimes  --当前领了几次

		awardLimit = value02

		local leftimes = value02 > value01 and (value02-value01) or 0
		local leftTime = string.format("%s/%s",leftimes,value02)
		self._progressLabel:setString(leftTime)

		--显示领奖次数
		self._progressTagLabel:setString(G_LangScrap.get("activity_text_left"))--G_LangScrap.get("activity_text_left_times"))
		-- self._progressTagLabel:setPositionX(self._progressTagPosX + 25)
		-- self._progressLabel:setPositionX(self._progressPosX + 25)

	--elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_BETWEEN then
	else
		value01 =  value01 > value02 and value02 or value01
		local progress = string.format("%s/%s",value01,value02)
		self._progressLabel:setString(progress)
		--显示进度
		self._progressTagLabel:setString(G_LangScrap.get("activity_text_progress"))

		-- local offSetX = self._progressLabel:getContentSize().width - 40
		-- self._progressTagLabel:setPositionX(self._progressTagPosX - offSetX/2)
		-- -- self._progressLabel:getContentSize().width * 0.5 - 70)
		-- self._progressLabel:setPositionX(self._progressPosX - offSetX/2)
	end

	--进度居中
    local panel_pro = self:getSubNodeByName("Panel_pro")
    local pro_node = self:getSubNodeByName("Node_pro")
    self._progressTagLabel:setPosition(0,0)
    self._progressLabel:setPositionX(self._progressTagLabel:getPositionX() + self._progressTagLabel:getContentSize().width)
    local proW = self._progressLabel:getPositionX() + self._progressLabel:getContentSize().width
    local totalW = panel_pro:getContentSize().width
    pro_node:setPositionX(totalW/2 - proW/2)

	--~~~~~~~~~~~~~~刷新按钮状态~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if awardLimit ~= 0 and awardTimes >= awardLimit then
		--已经领取了
		self._gotImage:setVisible(false)
		self._getAwardButton:setVisible(true)
		self._progressTagLabel:setVisible(false)
		self._progressLabel:setVisible(false)
	else
		self._gotImage:setVisible(false)
		self._getAwardButton:setVisible(true)
		self._progressTagLabel:setVisible(true)
		self._progressLabel:setVisible(true)

		if quest and quest.act_type == ActivityConst.CUSTOM_TYPE_PUSH then   -- 条件推进类
			--显示前往
			if value01 >= value02 then 
				--领取
				UpdateButtonHelper.updateNormalButton(self._getAwardButton,{effect = true,
					desc = G_LangScrap.get("common_btn_get_award")})
			else
				--领取类型
				if  quest.quest_type == ActivityConst.QUEST_TYPE_PUSH_LOGIN 
					or quest.quest_type == ActivityConst.QUEST_TYPE_PUSH_ITEM
					or quest.quest_type == ActivityConst.QUEST_TYPE_PUSH_DAY_LOGIN then -- 无法现在前往完成的类型
					UpdateButtonHelper.updateNormalButton(self._getAwardButton,{
						desc = G_LangScrap.get("common_btn_get_award"),
        				effect = false,
						state = UpdateButtonHelper.STATE_GRAY  --tempcode
						--state = UpdateButtonHelper.STATE_ATTENTION
						})
				else
					UpdateButtonHelper.updateNormalButton(self._getAwardButton,{
						desc = G_LangScrap.get("common_btn_go_to"),
						state = UpdateButtonHelper.STATE_NORMAL})
				end

			end

		--充值类型
		else   
			--今日消耗num元宝
			if quest.quest_type == ActivityConst.QUEST_TYPE_COST_TODAY_REACH then
				if value01 < value02 then 
					--不能领取
					UpdateButtonHelper.updateNormalButton(self._getAwardButton,{
        				effect = false,
						state = UpdateButtonHelper.STATE_GRAY --tempcode
						--state = UpdateButtonHelper.STATE_ATTENTION
						})
				end

			--单笔充值达到#num1
			elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_REACH
				or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_EVERYDAY_REACH 
				or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_REACH_MUCH
				or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_EVERYDAY_REACH_MUCH
					then 
				
				local desc = G_LangScrap.get("common_btn_to_recharge")
				local state = UpdateButtonHelper.STATE_NORMAL
				local effect = false

				--已领取次数小于可领奖次数
				if tonumber(curQuest.progress) > tonumber(curQuest.award_times) then
					desc = G_LangScrap.get("common_btn_get_award")
					effect = true
					state = UpdateButtonHelper.STATE_ATTENTION
				end

				UpdateButtonHelper.updateNormalButton(self._getAwardButton,{effect = effect,
					desc = desc, state = state})
			else

				local canGetAward = value01 >= value02
				--canGetAward = true--tempcode
				UpdateButtonHelper.updateNormalButton(self._getAwardButton,{
					effect = canGetAward and true or false,
					desc = canGetAward and G_LangScrap.get("common_btn_get_award")
						or G_LangScrap.get("common_btn_to_recharge"),
					state = canGetAward and UpdateButtonHelper.STATE_ATTENTION 
						or UpdateButtonHelper.STATE_NORMAL})

				--连续充值的 如果不能领奖才显示已充金额数
				if quest.quest_type == ActivityConst.QUEST_TYPE_PAY_SOME_TODAY_REACH then
					if not canGetAward then
						if SPECIFIC_GAME_OP_ID ~= SPECIFIC_GAME_OP_IDS.ANDROID_SHENHUA then
							condition = condition--..G_LangScrap.get("activity_text_now_recharge",{num=curQuest.progress_second})
							self._conditionLabel:setString(condition)
						end
					end
				end
			end
		end	
	end

	--物品列表
	local goodList = {}

	for i=1,4 do
		local _type = quest["award_type" .. i]
		if _type > 0 then
			local value = quest["award_value" .. i]
			local size = quest["award_size" .. i]
			local good = {type=_type,value=value,size=size}
			--if good then
				table.insert(goodList,good)
			--end
		end
	end

	self:initScrollView(goodList)
end

return ActivityRewardCell