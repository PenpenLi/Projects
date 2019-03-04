
--[=======================[

	活动数据基类

]=======================]
local BaseData = require("app.data.BaseData")
local ActivityBaseData = class("ActivityBaseData", BaseData)

-- 重置时间，小时为单位 改成凌晨0点 与其他模块一致
ActivityBaseData.RESET_TIME = 0


function ActivityBaseData:ctor()
	ActivityBaseData.super.ctor(self)

	self:initData()
end

function ActivityBaseData:initData( ... )
	
	self._hasInit = false    --数据是否初始化

    self._isActive = false   --活动是否激活

	self._startTime = 0     --活动开始时间
	self._endTime = 0       --活动结束时间
	self._rewardTime = 0    --活动领奖结束时间

end

--数据是否已经初始化了
function ActivityBaseData:hasInit()
    return self._hasInit
end

--设置活动基础数据
function ActivityBaseData:setBaseInfo(data)

	if type(data) ~= "table" then return end

	self._startTime = data.start_time or 0
	self._endTime = data.end_time or 0
	self._rewardTime = data.reward_time or 0

	self._hasInit = true

end

--返回时间信息
function ActivityBaseData:getTimeInfo( )
	-- body
	return self._startTime, self._endTime, self._rewardTime
end

--活动是否处于开启状态
function ActivityBaseData:isOpen()

	local nowTime = G_ServerTime:getTime()

	--print("ActivityBaseData:isOpen---------nowTime="..nowTime.."  startTime="..self._startTime.."   endTime="..self._endTime)

	if self._startTime > 0 and self._endTime > 0 then
		return nowTime >= self._startTime and nowTime < self._endTime
	end

	return false
end

--活动是否处于领奖状态
function ActivityBaseData:isReward()
	local nowTime = G_ServerTime:getTime()

	--print("ActivityBaseData:isReward ---------nowTime="..nowTime.."  endTime="..self._endTime.."   rewardTime="..self._rewardTime)

	if self._endTime > 0 and self._rewardTime > 0 then
		return nowTime >= self._endTime and nowTime < self._rewardTime
	end

	return false
end

--活动是否显示
function ActivityBaseData:isShow()

	return self:isOpen() or self:isReward()

end

--活动是否激活
function ActivityBaseData:isActivate( ... )
	return self._isActive
end

--[===================[

	数据是否过期，这里指的是是否过了重置时间了
	@resetTime重置的时间(可选，默认是凌晨0点)
	@return 返回是否过期

]===================]

function ActivityBaseData:isExpired(resetTime)

	local resetTime = resetTime or ActivityBaseData.RESET_TIME
	return ActivityBaseData.super.isExpired(self, resetTime)

end

--数据重置
function ActivityBaseData:reset()
	
	ActivityBaseData.super.reset(self)

	self:initData()

end


return ActivityBaseData