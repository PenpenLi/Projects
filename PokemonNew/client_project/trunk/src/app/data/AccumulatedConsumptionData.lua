
---=================
---累计消费数据
---=================
local BaseData = require "app.data.BaseData"
local AccumulatedConsumptionData = class("AccumulatedConsumptionData", BaseData)

local drop_info = require "app.cfg.drop_info"
local target_info = require "app.cfg.target_info"
--local accumulated_consumption_info = require "app.cfg.accumulated_consumption_info"

function AccumulatedConsumptionData:ctor()
	AccumulatedConsumptionData.super.ctor(self)
	self._currentRewardHasBeenGot = false --当前VIP的奖励是否已经领取
	self._lastGotRewardVipLv = -1 --上次领取了奖励的VIP等级
	self._replacementReward = {} --补领奖励数据
	self._boughtGift = {} --已购买的礼包
	self._isShow = true --是否开启
	self._showIndex = 0 -- 跳转cell序号
end

function AccumulatedConsumptionData:setServerData(decodeBuffer)
	--dump(decodeBuffer)
	--self._currentRewardHasBeenGot = decodeBuffer.is_receive
	--self._isShow = decodeBuffer.is_avaliable
	for i = 1, #decodeBuffer.rewarded_ids do
		local reward = decodeBuffer.rewarded_ids[i]
		self._replacementReward[reward] = true --已领取
	end

	-- 设置购买礼包
	for i =1,#decodeBuffer.bought_ids do
		self._boughtGift[decodeBuffer.bought_ids[i].Key] = decodeBuffer.bought_ids[i].Value
	end

	--self:_setLastGotVipLv(decodeBuffer.rewarded_ids)
	self:reset()
end

function AccumulatedConsumptionData:onGetVipReward(type,id)
	if type == 2 then
		if self._boughtGift[id] == nil then self._boughtGift[id] = 0 end
		self._boughtGift[id] = self._boughtGift[id] + 1
		return
	end

	--self:_setLastGotVipLv({id})
	self._replacementReward[id] = true
	self._currentRewardHasBeenGot = true
end

function AccumulatedConsumptionData:isShow()
	return self._isShow
end

function AccumulatedConsumptionData:_setLastGotVipLv(ids)
	for i = 1, #ids do
		local id = ids[i]
		local vipLv = ActivityVipReward.get(id).level
		if G_Me.vipData:getVipLevel() == vipLv then
			self._lastGotRewardVipLv = G_Me.vipData:getVipLevel()
			self._replacementReward[id] = true
		end
	end
end

---获得购买礼包
function AccumulatedConsumptionData:getBuyShowItems()
	--local currentVip = G_Me.vipData:getVipLevel()

	local showItems = {}
	local count = level_buy_info.getLength()
	for i = 1, count do
		local config = level_buy_info.indexOf(i)
		if G_Me.userData.level >= config.required_level - 5 then
			local showItem = {}
			showItem.id = config.id
			showItem.level = config.required_level
			showItem.discount = config.discount
			showItem.current_price = config.price
			showItem.limit_buy = config.num
			showItem.buyCount = self._boughtGift[showItem.id] or 0

			showItem.awards = {}
			--local cfgDrop = drop_info.get(config.drop_id)
			for i = 1, 4 do
				if config["reward_type" .. tostring(i)] ~= 0 then
					showItem.awards[#showItem.awards + 1] = {
					type = config["reward_type" .. tostring(i)],
					value = config["reward_value" .. tostring(i)], 
					size = config["reward_size" .. tostring(i)]	
				}
				end
			end

			showItems[#showItems + 1] = showItem
		end
	end
	return showItems
end

function AccumulatedConsumptionData:getShowIndex()
	return self._showIndex
end

---获得当前界面上需要显示的level奖励列表
function AccumulatedConsumptionData:getShowItems()
	local showIndex = 0
	local currentVip = G_Me.userData.level

	local showItems = {}
	local count = target_info.getLength()
	for i = 1, count do
		local vipRewardInfo = target_info.indexOf(i)
		if vipRewardInfo.effective_type == 6 and G_Me.userData.level >= vipRewardInfo.target_size - 5 then -- 等级礼包类型
			local showItem = {}
			showItem.id = vipRewardInfo.id
			showItem.level = vipRewardInfo.target_size
			--dump(showItem.level)
			showItem.hasBeenGot = self._replacementReward[showItem.id] or false
			if not showItem.hasBeenGot and showIndex == 0 then showIndex = showItem.id - 90000 end

			showItem.awards = {}
			for i = 1, 3 do
				if vipRewardInfo["reward_type" .. tostring(i)] ~= 0 then
					showItem.awards[#showItem.awards + 1] = {
					type = vipRewardInfo["reward_type" .. tostring(i)],
					value = vipRewardInfo["reward_value" .. tostring(i)], 
					size = vipRewardInfo["reward_size" .. tostring(i)]	
				}
				end
			end

			-- if vipRewardInfo.level == currentVip then
			-- 	showItem.hasBeenGot = self._currentRewardHasBeenGot and self._lastGotRewardVipLv == G_Me.vipData:getVipLevel()
			-- elseif vipRewardInfo.level == currentVip + 1 then
			-- 	showItem.hasBeenGot = false
			-- else
			-- 	if self._replacementReward[vipRewardInfo.id] ~= nil then
			-- 		showItem.hasBeenGot = self._replacementReward[vipRewardInfo.id]
			-- 	else
			-- 		showItem.hasBeenGot = false
			-- 	end				
			-- end

			-- if showItem.hasBeenGot and vipRewardInfo.level ~= currentVip then
			-- 	showItem = nil
			-- end

			showItems[#showItems + 1] = showItem
		end
	end

	return showItems,showIndex
end

function AccumulatedConsumptionData:setReset()
	self._currentRewardHasBeenGot = false

	self:reset()
end

--是否有红点，当前VIP奖励是否已经领取
function AccumulatedConsumptionData:hasRedPoint()
	if not self._isShow then
		return false
	end

	local hasOldNotGot = false
	local currentVip = G_Me.userData.level
	local awardItems = self:getShowItems()
	for i = 1, #awardItems do
		local showItem = awardItems[i]
		if not showItem.hasBeenGot and showItem.level <= currentVip then
			hasOldNotGot = true
			break
		end
	end

	return hasOldNotGot
end


return AccumulatedConsumptionData