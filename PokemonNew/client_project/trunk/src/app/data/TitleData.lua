
-----------------------------
--时装数据
local BaseData = require "app.data.BaseData"
local TitleData = class("TitleData", BaseData)

local ParameterInfo = require "app.cfg.parameter_info"
local RoleInfo = require("app.cfg.role_info")
local jobchange_info = require("app.cfg.jobchange_info")
local jobchange_talent_info = require("app.cfg.jobchange_talent_info")
local collect_info = require("app.cfg.collect_info")

function TitleData:ctor()
	TitleData.super.ctor(self)

	self._dressList = {} -- 时装列表
	self._trainDressList = {} -- 强化时装列表
	self._dressedId = 0 -- 已穿的时装id
	self._clickIndex = 0 -- 预览点击序号

	self._cfgData = nil -- 相关配置表信息
	self._serverData = {} -- 相关配置表信息
	self._cacheData = {} -- 预览武将信息

	self:setCfgData() -- 配置表信息
end

-- 演武场配置表信息
function TitleData:setCfgData()
	local cfg = {}

	local length = collect_info.getLength()
	for i=1,length do
		cfg[#cfg + 1] = collect_info.indexOf(i)
		cfg[#cfg].isPrior = false
	end

	--table.sort(cfg)

	self._cfgData = cfg
end

-- 获取配置表
function TitleData:getCfgData(index)
	--dump(self._cfgData)
	local cfg = self:deepcopy(self._cfgData)

	if index then -- 有页签的数据
		local temp = {}
		for i=1,#cfg do
			if cfg[i].is_wear == index then
				temp[#temp+1] = cfg[i]
			end
		end
		cfg = temp
	end

	table.sort(cfg, function(a, b)
		-- if a.isPrior then
		-- 	return true
		-- end

		-- if b.isPrior then
		-- 	return false
		-- end

		if a.isPrior ~= b.isPrior then
			return a.isPrior
		end

		if a.order ~= b.order then
			return a.order < b.order
		end

		return a.id < b.id
	end)

	dump(cfg)
	return cfg
end

-- 红点显示判断
function TitleData:isNeedShowRed(index)
	for i=1,#self._cfgData do
		if index == self._cfgData[i].is_wear then
			if self._cfgData[i].isPrior then
				return true
			end
		end
	end
	return false
end

-- 设置服务器数据
function TitleData:setServerData(data)
	if data == nil then
		return 
	end

	self._serverData = {}
	for i=1,#data do
		local unit = {}
		unit.id = data[i].id
		unit.knight_id = data[i].knight_id
		unit.is_received = data[i].is_received

		self._serverData[unit.id] = unit

		-- 配置表数据插入
		local count = 0
		dump(unit.id)
		for i=1,15 do
			if self._cfgData[unit.id]["knight"..i] ~= 0 then 
				count = count + 1 
			end
		end

		-- 全阵营判断
		if self._cfgData[unit.id]["knight1"] > 0 and self._cfgData[unit.id]["knight1"] < 16 then
			count = 18
		end

		if #unit.knight_id == count and unit.is_received == 0 then -- 集齐，未领奖
			self._cfgData[unit.id].isPrior = true
		end
	end
end

function TitleData:setSingleServerData(id)
	self._serverData[id].is_received = 1
	self._cfgData[id].isPrior = false
end

function TitleData:getServerData()
	return self._serverData
end

--深度拷贝  
function TitleData:deepcopy(object)      
    local lookup_table = {}  
    local function _copy(object)  
        if type(object) ~= "table" then  
            return object  
        elseif lookup_table[object] then  
  
            return lookup_table[object]  
        end  -- if          
        local new_table = {}  
        lookup_table[object] = new_table  
  
  
        for index, value in pairs(object) do  
            new_table[_copy(index)] = _copy(value)  
        end   
        return setmetatable(new_table, getmetatable(object))      
    end       
    return _copy(object)  
end  

return TitleData