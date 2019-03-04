--
-- Author: yutou
-- Date: 2018-09-18 12:01:58
--
local MinePlayerData=class("MinePlayerData")
local Parameter_info = require("app.cfg.parameter_info")
local mine_drop_info = require("app.cfg.mine_drop_info")

MinePlayerData.JOB_OWNER = 1--矿主
MinePlayerData.JOB_WORKER = 2--工人
MinePlayerData.JOB_LOVER = 3--情侣


function MinePlayerData:ctor(job)
	self._job = job
	
	self._id = nil
	self._cityData = nil
	self._baseID = nil
	self._name = nil
	self._guild = nil--帮会
	self._power = nil
	self._extTime = nil
	self._geted = 0
end

function MinePlayerData:init()
	self._id = nil
	self._baseID = nil
	self._name = nil
	self._guild = nil--帮会
	self._startTime = nil
	self._power = nil
	self._extTime = nil
	self._geted = 0

end

  -- optional uint64 id = 2; //矿主user_id
  -- optional string name = 3; //矿主昵称
  -- optional uint64 power = 4; //战力
  -- optional uint32 quality = 5; //主角品质
  -- optional uint32 frame = 6; //头像框
  -- optional string guild = 7; //矿主所在帮派
  -- optional uint32 st = 8; //占矿起始时间
function MinePlayerData:setData(data,cityData)
	self:init()
	self._cityData = cityData

	if data and data.id ~= 0 then
		self._id = data.id
		self._baseID = data.avater
		self._name = data.name
		self._guild = data.guild
		self._startTime = data.st
		if self._startTime > G_ServerTime:getTime() then
			self._startTime = G_ServerTime:getTime()
		end
		self._power = data.power
		self._quality = data.quality
		self._extTime = 0
		self._geted = 0
		
		local timeList = string.split(Parameter_info.get(574).content,"|")
		self._timeList = timeList
		self._extTime = self._extTime > #timeList - 1 and #timeList - 1 or self._extTime
		self._allTime = tonumber(timeList[self._extTime + 1]) * 3600
	end

    self._littleTimeList = {}
	local littleTimeStr = Parameter_info.get(575).content
	local littleTimeStrList = string.split(littleTimeStr,"|")
	for i=1,#littleTimeStrList do
		local oneLittleTimeList = string.split(littleTimeStrList[i],"-")
		table.insert(self._littleTimeList,{tonumber(oneLittleTimeList[1]),tonumber(oneLittleTimeList[2])})
	end

	table.sort(self._littleTimeList,function( a,b )
		return a[1] < b[1]
	end)

	self:refreshGeted()
end

function MinePlayerData:getQuality()
	return self._quality
end

function MinePlayerData:setExtTime( value )
	self._extTime = value
	if self._timeList then
		self._allTime = tonumber(self._timeList[self._extTime + 1]) * 3600
	end
end

function MinePlayerData:getGeted()
	self:refreshGeted()
	return self._geted
end

function MinePlayerData:refreshGeted()
	if self._cityData == nil or self._startTime == nil then
		self._geted =  0
		return
	end
	
	local time = math.floor((G_ServerTime:getTime() - self._startTime)/30)
	if time == self._lastTime then
		return
	end
	self._lastTime = time

	local award = 0
	local perAward = self:getAward()
	local normalTime,lowTime = self:getNormalAndLittleTime( self._startTime,G_ServerTime:getTime())
	print("dgdddddddddd",self._startTime,G_ServerTime:getTime())
	dump(normalTime)
	dump(lowTime)
	local allNormalTime = 0
	local lowTimeTime = 0
	for i=1,#normalTime do
		allNormalTime = allNormalTime + normalTime[i]
	end
	for i=1,#lowTime do
		lowTimeTime = lowTimeTime + lowTime[i]
	end
	print("aaaaaaaaaaaadgadgadg",allNormalTime,lowTimeTime)
	award = award + math.floor(allNormalTime/30) * perAward/8/3600*30
	award = award + math.floor(lowTimeTime/30) *perAward/8/3600*30 * 0.2
	self._geted = math.floor(award)
end

function MinePlayerData:getAward()
	local drop_info = mine_drop_info.get(self._cityData:getDropID())
	print("getAwardgetAward",self._cityData)
	if self._job == 1 then
		return drop_info.high_award_size
	elseif self._job == 2 then
		return drop_info.better_award_size
	elseif self._job == 3 then
		return drop_info.low_award_size
	end
	return 0
end

function MinePlayerData:getNormalAndLittleTime( startTime,endTime )
	local normalTimeList = {}
	local lowTimeList = {}
	local checkTime = startTime
	local addTimeList = {}
	local firstIndex = 1
	for i=1,#self._littleTimeList do
		if i == #self._littleTimeList then
			table.insert(addTimeList,{0,self._littleTimeList[i][1],self._littleTimeList[i][2]})--low
			if self._littleTimeList[i][2] > self._littleTimeList[1][1] + 3600*24 then
				table.insert(addTimeList,{1,self._littleTimeList[i][2],self._littleTimeList[1][1] + 3600*24})--normal
			end
		else
			table.insert(addTimeList,{0,self._littleTimeList[i][1],self._littleTimeList[i][2]})--low
			if self._littleTimeList[i][2] < self._littleTimeList[i + 1][1] then
				table.insert(addTimeList,{1,self._littleTimeList[i][2],self._littleTimeList[i + 1][1]})--normal
			end
		end
	end
	local startTimeToday = G_ServerTime:secondsFromToday(startTime)
	if startTimeToday < 0 then
		startTimeToday = startTimeToday + 3600*24
	end
	if startTimeToday < 0 then
		startTimeToday = startTimeToday + 3600*24
	end
	if startTimeToday > 3600*24 then
		startTimeToday = startTimeToday - 3600*24
	end
	if startTimeToday > 3600*24 then
		startTimeToday = startTimeToday - 3600*24
	end
	for i=1,#addTimeList do
		if startTimeToday >= addTimeList[i][2] and startTimeToday < addTimeList[i][3] then
			firstIndex = i
			break;
		end
	end

	-- if addTimeList[firstIndex][1] == 1 then
	-- 	normalTimeList[1] = {startTime + addTimeList[i][2] - startTimeToday,addTimeList[i][3]}--从第一个在的范围的起始算起
	-- else
	-- 	lowTimeList[1] = {startTime + addTimeList[i][2] - startTimeToday,addTimeList[i][3]}
	-- end

	local nowDay = 0
	for i=firstIndex,10 do--不会超过10回的
		local realIndex = (i-1)%#addTimeList + 1
		if endTime >= startTime - startTimeToday + addTimeList[realIndex][2] + nowDay*24*3600 and endTime < startTime - startTimeToday + addTimeList[realIndex][3] + nowDay*24*3600 then
			if i == firstIndex then
				if addTimeList[realIndex][1] == 1 then
					table.insert(normalTimeList,{startTime,endTime})
				else
					table.insert(lowTimeList,{startTime,endTime})
				end
				break;
			else
				if addTimeList[realIndex][1] == 1 then
					table.insert(normalTimeList,{startTime - startTimeToday + addTimeList[realIndex][2] + nowDay*24*3600,endTime})
				else
					table.insert(lowTimeList,{startTime - startTimeToday + addTimeList[realIndex][2] + nowDay*24*3600,endTime})
				end
				break;
			end
		else
			if i == firstIndex then
				if addTimeList[realIndex][1] == 1 then
					table.insert(normalTimeList,{startTime,startTime - startTimeToday + addTimeList[realIndex][3] + nowDay*24*3600})
				else
					table.insert(lowTimeList,{startTime,startTime - startTimeToday + addTimeList[realIndex][3] + nowDay*24*3600})
				end
			else
				if addTimeList[realIndex][1] == 1 then
					table.insert(normalTimeList,{startTime - startTimeToday + addTimeList[realIndex][2] + nowDay*24*3600,startTime - startTimeToday + addTimeList[realIndex][3] + nowDay*24*3600 })
				else
					table.insert(lowTimeList,{startTime - startTimeToday + addTimeList[realIndex][2] + nowDay*24*3600,startTime - startTimeToday + addTimeList[realIndex][3] + nowDay*24*3600 })
				end
			end
		end

		--下一天
		local realIndex = (i-1 + 1)%#addTimeList + 1
		if addTimeList[realIndex][2] == 0 then
			nowDay = nowDay + 1
		end
	end

	local normalTimeList2 = {}
	local lowTimeList2 = {}
	for i=1,#normalTimeList do
		local time = normalTimeList[i][2] - normalTimeList[i][1]
		if time < 0 then
			time = 0
		end
		table.insert(normalTimeList2,time)
	end
	for i=1,#lowTimeList do
		local time = lowTimeList[i][2] - lowTimeList[i][1]
		if time < 0 then
			time = 0
		end
		table.insert(lowTimeList2,time)
	end
	return normalTimeList2,lowTimeList2
end

function MinePlayerData:nextExtTime()
	return tonumber(self._timeList[self._extTime + 2]) - tonumber(self._timeList[self._extTime + 1])
end

-----------------------------------
function MinePlayerData:hasData()
	return self._id ~= nil
end

function MinePlayerData:getColor()
	return G_TypeConverter.quality2Color(self._quality)
end

function MinePlayerData:getID()
	return self._id
end

function MinePlayerData:getName()
	return self._name
end

function MinePlayerData:getOverTime(  )
	if self._startTime == nil then
		return 0
	end
	return self._startTime + self._allTime
end

function MinePlayerData:getGuild()
	return self._guild
end

function MinePlayerData:getPower()
	return self._power
end

function MinePlayerData:getResource()
	
	return self._resource
end

function MinePlayerData:getBaseID()
	return self._baseID
end

function MinePlayerData:getStartTime()
	return self._startTime
end

function MinePlayerData:getLeftTime()
	return G_ServerTime:getTime() - self._startTime
end

function MinePlayerData:getJob()
	return self._job
end
--------------------------------

return MinePlayerData