--ActivityCompensationData.lua

--[====================[

    补偿活动数据类
    
]====================]

local ActivityBaseData = require("app.data.ActivityBaseData")

local ActivityCompensationData = class("ActivityCompensationData", ActivityBaseData)

-- local CloseCompensationInfo = require("app.cfg.close_compensation_info")


function ActivityCompensationData:ctor( ... )

    ActivityCompensationData.super.ctor(self)

    -- self._getAwardMax = CloseCompensationInfo.getLength()

end

function ActivityCompensationData:initData( ... )

    self._todayGetAward = false  --当天是否领取
    self._getAwardIndex = 0  --当前领了第几天的奖励

end

--手动重置数据
function ActivityCompensationData:setReset()
	--self:reset()  --会调用initData

	ActivityBaseData.super.reset(self)

	self._todayGetAward = false

end

function ActivityCompensationData:setActivityData(data)
    
    if type(data) ~= "table" then return end

    local activity = rawget(data,"activity_info") and data.activity_info or nil

    if type(activity) ~= "table" then return end

    self:reset()  --重置数据

    self._isActive = rawget(activity,"is_trigger") and activity.is_trigger or false
    self._todayGetAward = rawget(activity,"today_receive") and activity.today_receive or false
    self._getAwardIndex = rawget(activity,"receive_count") and activity.receive_count or 0

    -- self._isActive = true   --TEST
    -- self._getAwardIndex = 6  --TEST
    -- self._todayGetAward = false  --当天是否领取

end

--活动是否显示
function ActivityCompensationData:isShow()

    return self._isActive and self._getAwardIndex <= self._getAwardMax

end


function ActivityCompensationData:getActivityList()

    local maxLength = self._getAwardMax

    -- local curActivity = CloseCompensationInfo.indexOf(maxLength)  --默认最后一个

    local list = {}

    -- for index=1, maxLength do
    --     list[index] = CloseCompensationInfo.indexOf(index)
    --     list[index].getAward = (index < self._getAwardIndex + 1) or 
    --         (self._todayGetAward and index == self._getAwardIndex )
    --     list[index].canGet = (index == self._getAwardIndex+1 and not self._todayGetAward)

    --     if self._todayGetAward and index == self._getAwardIndex then
    --         curActivity = list[index]
    --     elseif not self._todayGetAward and index == self._getAwardIndex + 1 then
    --         curActivity = list[index]
    --     end
    -- end

    table.sort(list, function(item1, item2)

        --领过奖排后面
        if item1.getAward ~= item2.getAward then
            return not item1.getAward
        end

        local canGet1 = item1.canGet
        local canGet2 = item2.canGet

        if item1.getAward then
            return item1.id > item2.id
        elseif canGet1 ~= canGet2 then
            return canGet1
        else
            return item1.id < item2.id
        end
    end)

    -- return curActivity, list

end


function ActivityCompensationData:setHasGetAwardToday(getAward)
    self._todayGetAward = checkbool(getAward)
    self._getAwardIndex = self._getAwardIndex + 1
end

function ActivityCompensationData:getHasGetAwardToday()
    return self._todayGetAward
end

--获取当前可领第几天
function ActivityCompensationData:getAwardIndex()
    local awardIndex = self._todayGetAward and self._getAwardIndex or (self._getAwardIndex+1)
    return math.min(awardIndex, self._getAwardMax)
end

--是否显示红点
function ActivityCompensationData:needShowTip()
    
    return self._isActive and not self._todayGetAward and self._getAwardIndex < self._getAwardMax

end

return ActivityCompensationData