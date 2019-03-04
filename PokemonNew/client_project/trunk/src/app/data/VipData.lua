
--=====================
--存储VIP的数据
--=====================
local VipData = class("VipData")
local VipLevelInfo = require "app.cfg.vip_level_info"
local VipUnit = require "app.data.VipUnit"
local vipFunctionInfo = require "app.cfg.vip_function_info"
local FunctionCostInfo = require "app.cfg.function_cost_info" 
local DropInfo = require "app.cfg.drop_info"
local ParameterInfo = require "app.cfg.parameter_info"

VipData.PARAM_LIME_SHOW_KEY = 168

function VipData:ctor()
	self._level = 0
	self._exp = 0
	self._dataList = nil ---包含VipUnit数据的列表
	self:_initData()
end

--=======
--设置VIP数据
--=======
function VipData:setVipData(data)
	if data == nil or type(data) ~= "table" then return end
	self._level = data.level
	self._exp = data.exp
end

---=====
---获取当前VIP等级
function VipData:getVipLevel()
	return self._level
end

--======
---获取当前VIP经验值
function VipData:getVipExp()
	return self._exp
end

function VipData:getVipList()
	return self._dataList
end

--获取到下级vip所需元宝
function VipData:getRechargeNumToNextLv()
	local maxViplv = self:getShowMaxLevel()
	local currentVipLv = self:getVipLevel()
	local currentVipExp = self:getVipExp()
	local nextVipLv = currentVipLv == maxVipLv and maxVipLv or currentVipLv + 1
	local nextVipLvInfo = VipLevelInfo.get(nextVipLv)

	return nextVipLvInfo.low_value - currentVipExp
end

--============
--充值条目是否已经购买过。
function VipData:isRechargeItemBought(price)
	for i = 1, #self._firstRechargeList do
		local rechargeItem = self._firstRechargeList[i]
		if rechargeItem == price then
			return true
		end
	end
	return false
end

--===========
--根据VIP管理的function id来获取当前的VIP等级的特权条目，见vip_function_info
--@functionType
--@isNextLevel 是否取是下一级
--============
function VipData:getVipFunctionDataByType(functionType, isNextLevel)
    local count = vipFunctionInfo.getLength()
    local vipLevel = self:getVipLevel()
    
    if isNextLevel then
        vipLevel = vipLevel + 1   --可能超过最大VIP等级 则会返回nil
    end

    for i = 1, count do
        local item = vipFunctionInfo.indexOf(i)
        if item.type == functionType and item.level == vipLevel then
            return item
        end
    end

    return nil
end

--获取最大vip等级
function VipData:getMaxLevel()
    return self._dataList[#self._dataList]:getInfo().level
end

--获取显示最大的VIP等级
function VipData:getShowMaxLevel()
	local limitShowLv = tonumber(ParameterInfo.get(VipData.PARAM_LIME_SHOW_KEY).content)
	if self._level < limitShowLv then
		return 12
	else
		return self:getMaxLevel()
	end	
end

---获取当前VIP等级，可以使用的功能次数
---@funcId
---@return currentValue 当前VIP等级可以使用的次数，maxValue最高VIP等级可以使用的次数
function VipData:getVipTimesByFuncId(funcId)
	local count = vipFunctionInfo.getLength()
	local currentValue = 0
	local vipLevelData = nil
	local maxValue = 0
	local currentVipLv = G_Me.vipData:getVipLevel()
	for i = 1, count do
		local vipFuncInfo = vipFunctionInfo.indexOf(i)
		local nextVipFuncInfo = nil
		if i + 1 <= count then
			nextVipFuncInfo = vipFunctionInfo.indexOf(i + 1)
		end
		if vipFuncInfo.type == funcId then
			local infoValue = vipFuncInfo.value
			if vipFuncInfo.level == currentVipLv then
				currentValue = infoValue
				vipLevelData = vipFuncInfo
			elseif nextVipFuncInfo then
				if currentVipLv >= vipFuncInfo.level and currentVipLv < nextVipFuncInfo.level then
					currentValue = infoValue
					vipLevelData = vipFuncInfo
				end
			end
			if maxValue < infoValue then
				maxValue = infoValue
			end
		end
	end

	return currentValue, maxValue,vipLevelData
end

---获取购买一次功能次数的元宝
--@funcType
--@usedTimes 已经使用的次数
--@return costGold 本次购买所需元宝
function VipData:getVipBuyTimeCost(funcType, usedTimes)
	local costInfo = FunctionCostInfo.get(funcType)
	local costGold
	local freeTime = costInfo.init_count
	if usedTimes >= freeTime then
		costGold = costInfo["cost" .. (usedTimes - freeTime + 1)] --要买的为下一次的
		--costGold = costInfo["cost" .. (usedTimes + 1)] --要买的为下一次的
	else
		costGold = 0
	end

	return costGold
end

---获取购买一次功能次数的元宝
--@funcType
--@boughtTimes 已经购买的次数
--@return costGold 本次购买所需元宝
function VipData:getVipBuyCountCost(funcType, boughtTimes)
	local costInfo = FunctionCostInfo.get(funcType)
	local costGold = costInfo["cost" ..tostring(boughtTimes + 1)]
	return costGold
end

---根据vip的掉落ID来获取VIP礼包的道具列表
function VipData:getVipGiftItemsByDropId(dropId)
	local dropInfo = DropInfo.get(dropId)
	local retList = {}

	for i = 1, 10 do
        if dropInfo["type_"..i] ~= 0 then -- 如果这个掉落有值
            retList[#retList + 1] = {
                type = dropInfo["type_" .. i],
                value = dropInfo["value_" .. i],
                size = dropInfo["max_num_" .. i],
            }
        end
    end
    print("getVipGiftItemsByDropId",dropId)
    dump(dropInfo)
    return retList
end

function VipData:_initData()
	self._dataList = {}

	local count = VipLevelInfo.getLength()
	for i = 1, count do
		local vipLevelInfo = VipLevelInfo.indexOf(i)
		local vipUnit = VipUnit.new()
		vipUnit:setInfo(vipLevelInfo)
		self._dataList[#self._dataList + 1] = vipUnit
	end
end

return VipData