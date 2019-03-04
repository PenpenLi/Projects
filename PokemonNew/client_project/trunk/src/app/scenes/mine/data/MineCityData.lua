--
-- Author: yutou
-- Date: 2018-09-18 10:54:51
--
local MineCityData=class("MineCityData")
local MinePlayerData = require("app.scenes.mine.data.MinePlayerData")
local mine_position_info = require("app.cfg.mine_position_info")
local mine_drop_info = require("app.cfg.mine_drop_info")
local Parameter_info = require("app.cfg.parameter_info")

MineCityData.QUALITY_TIE = 5
MineCityData.QUALITY_TONG = 8
MineCityData.QUALITY_YIN = 10 
MineCityData.QUALITY_HUANGJIN = 13
MineCityData.QUALITY_SHUIJING = 15
MineCityData.QUALITY_ZUANSHI = 18
MineCityData.QUALITY_WUCAI = 21

function MineCityData:ctor()
	self._id = nil
	self._cfg = nil

	self._owner = nil
	self._worker = nil
	self._lover = nil
	self._renewCount = nil
	self._my_pos = 0
end

function MineCityData:init()
	self._id = nil
	self._cfg = nil

	self._owner = nil
	self._worker = nil
	self._lover = nil
	self._renewCount = 0
	-- self._my_pos = 0

	self._owner = MinePlayerData.new(1)
	self._worker = MinePlayerData.new(2)
	self._lover = MinePlayerData.new(3)
end

function MineCityData:clear()
	self._id = nil
	self._cfg = nil

	self._owner = nil
	self._worker = nil
	self._lover = nil
	self._renewCount = 0
	self._my_pos = 0

	self._owner = MinePlayerData.new(1)
	self._worker = MinePlayerData.new(2)
	self._lover = MinePlayerData.new(3)
end

  -- optional uint32 base_id = 1;
  -- optional MineSimpleUser owner = 2;
  -- optional MineSimpleUser coowner = 3;
  -- optional MineSimpleUser couple = 4;
function MineCityData:setData(data)
	-- print("MineCityData:setData(data)")
	-- dump(data)
        print("4ddddddddddddddddddd111")
	self:init()
	if rawget(data, "base_id") then
		self._id = data.base_id
		self._cfg = mine_position_info.get(self._id)

		self._owner:setData(data.owner,self)
		self._worker:setData(data.coowner,self)
		self._lover:setData(data.couple,self)

		if rawget(data, "renew_count") then
			self._renewCount = data.renew_count

			self._owner:setExtTime(self._renewCount)
			self._worker:setExtTime(self._renewCount)
			self._lover:setExtTime(self._renewCount)
		end

        print("4ddddddddddddddddddd1111")
		print("my_posmy_posmy_posmy_pos111",rawget(data, "my_pos") , rawget(data, "my_pos"))
		dump(data)
		if rawget(data, "my_pos") then
        print("4ddddddddddddddddddd11111")
			self._my_pos = data.my_pos
			print("my_posmy_posmy_posmy_pos",self._id,self._my_pos)
			dump(debug.traceback(""))
		end
	end
end

function MineCityData:isInCity()
	if self._my_pos == 1 then
		if self._owner:hasData() and self._owner:getName() == G_Me.userData.name then
			print("isInCityisInCity1")
			return true
		else
			self:init()
			print("isInCityisInCity2")
			return false
		end
	elseif self._my_pos == 2 then
		if self._worker:hasData() and self._worker:getName() == G_Me.userData.name then
			print("isInCityisInCity3")
			return true
		else
			self:init()
			print("isInCityisInCity4")
			return false
		end
	elseif self._my_pos == 3 then
		if self._lover:hasData() and self._lover:getName() == G_Me.userData.name then
			print("isInCityisInCity5")
			return true
		else
			self:init()
			print("isInCityisInCity6")
			return false
		end
	end
	self:init()
			print("isInCityisInCity7")
	return false
end

function MineCityData:refreshGeted()
	self._owner:refreshGeted()
	self._worker:refreshGeted()
	self._lover:refreshGeted()
end

function MineCityData:setRenewCount( value )
	self._renewCount = value
	self._owner:setExtTime(self._renewCount)
	self._worker:setExtTime(self._renewCount)
	self._lover:setExtTime(self._renewCount)
end

function MineCityData:canContinue()
	local littleTimeStr = Parameter_info.get(574).content
	local littleTimeStrList = string.split(littleTimeStr,"|")
	print("canContinuecanContinue",self._renewCount , #littleTimeStrList - 1)
	return self._renewCount < #littleTimeStrList - 1
end

function MineCityData:getContinueCount()
	return self._renewCount
end

-------------------------------------
function MineCityData:hasData()
	return self._id ~= nil
end

function MineCityData:getMyPos()
	return self._my_pos
end

-- record_mine_drop_info.low_award_type = 0--情侣奖励
-- record_mine_drop_info.low_award_value = 0--情侣奖励
-- record_mine_drop_info.low_award_size = 0--情侣奖励
-- record_mine_drop_info.better_award_type = 0--监工奖励
-- record_mine_drop_info.better_award_value = 0--监工奖励
-- record_mine_drop_info.better_award_size = 0--监工奖励
-- record_mine_drop_info.high_award_type = 0--矿主奖励
-- record_mine_drop_info.high_award_value = 0--矿主奖励
-- record_mine_drop_info.high_award_size = 0--矿主奖励
function MineCityData:getAward(type,hours)
	if self._id == nil or self._id == 0 then
		return 0
	end
	local drop_info = mine_drop_info.get(self:getDropID())
	if type == 1 then
		return drop_info.high_award_size * hours / 8
	elseif type == 2 then
		return drop_info.better_award_size * hours / 8
	elseif type == 3 then
		return drop_info.low_award_size * hours / 8
	end
end

function MineCityData:quality2dropID( quality)
	local map = {
		[5] = 7,
		[8] = 6,
		[10] = 5,
		[13] = 4,
		[15] = 3,
		[18] = 2,
		[21] = 1
	}
	return map[quality]
end

function MineCityData:getDropID()
	return self:quality2dropID(self._cfg.quality)
end

function MineCityData:getID()
	return self._id
end

function MineCityData:getIndex()
	return self._cfg.page
end

function MineCityData:getMinePosition()
	return self._cfg.position
end

function MineCityData:getName()
	return self._cfg.name
end

function MineCityData:getOverTime()
	return self._owner:getOverTime()
end

function MineCityData:getQuality()
	return self._cfg.quality
end

function MineCityData:getOwner()
	return self._owner
end

function MineCityData:getWorker(  )
	return self._worker
end

function MineCityData:getLover(  )
	return self._lover
end

function MineCityData:getMyPlayerData()
	if self._my_pos == 1 then
		return self._owner
	elseif self._my_pos == 2 then
		return self._worker
	elseif self._my_pos == 3 then
		return self._lover
	end
end

function MineCityData:getOwnerPower( ... )
	return self._owner:getPower()
end

function MineCityData:getCityName( )
	print("MineCityData:getCityName",self._cfg,self._id)
	return self._cfg.name
end
---------------------------------------

return MineCityData