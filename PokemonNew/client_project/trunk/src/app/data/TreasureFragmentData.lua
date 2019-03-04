
--[===========[
    TreasureFragmentData
    宝物碎片模块数据处理 
    用于宝物碎片模块数据的增删改查
    kaka
]===========]

local TreasureFragmentData=class("TreasureFragmentData")

local TreasureFragmentInfo = require("app.cfg.treasure_fragment_info")
-- local TreasureInfo = require("app.cfg.treasure_info")

TreasureFragmentData.KEY_PREV="fragment_"

function TreasureFragmentData:ctor( ... )
	-- body
	self._fragmentList = {}

end

--[===========[
    缓存服务器端宝物碎片数据
    data为服务器端数据
]===========]
function TreasureFragmentData:setFragmentListData(buffData)

	if type(buffData) ~= "table" then 
		return 
	end

    self._fragmentList = {}
    
	local data = buffData.treasure_fragments or {}

	for i=1, #data do
		self:_setFragmentData(data[i])
	end

end


--配置表信息和服务器信息打包
function TreasureFragmentData:_setFragmentData( serverValue )

	if type(serverValue)~="table" then 
		return 
	end

	local fragment = {}
	fragment.id = serverValue.id
	fragment.num = rawget(serverValue, "num") and serverValue.num or 0

    --num大于0才加入
    if fragment.num > 0 then
    	local key = TreasureFragmentData.KEY_PREV..tostring(fragment.id)

    	self._fragmentList[key] = fragment
    end

end

--[===========[
    获取宝物碎片信息
    参数为宝物碎片id
    如果有则返回宝物碎片信息，如果没有则返回nil
]===========]
function TreasureFragmentData:getFragmentByID( id )

	if table.nums(self._fragmentList) == 0 or type(id) ~= "number" then 
		return nil
	end

	--dump(self._fragmentList)

	return self._fragmentList[TreasureFragmentData.KEY_PREV..tostring(id)]
end


--[===========[
    获取所有宝物碎片信息
    如果有则返回宝物碎片信息列表，如果没有则返回nil
]===========]
function TreasureFragmentData:getFragmentList(  )

	local list = {}

	for k,v in pairs(self._fragmentList) do
		table.insert(list,v)
	end

	--按照一定规则排序
	table.sort(list,function(a,b)
		
	end)

	return list
end


--检查是否有宝物碎片可以合成
--返回可合成的宝物唯一id
function TreasureFragmentData:checkTreasureComposedId()

    local composeList = {}

    --遍历碎片列表
    for i,v in pairs(self._fragmentList) do

        local fragmentInfo = TreasureFragmentInfo.get(v.id)
        assert(fragmentInfo, "checkTreasureComposeEnabled: fragmentInfo config error~~~")
        if not fragmentInfo then
            return 0
        end

        local treasure = TreasureInfo.get(fragmentInfo.treasure_id)
        assert(treasure, "checkTreasureComposeEnabled: treasureInfo config error~~~")

        if not treasure then
            return 0
        end

        --避免重复判断
        if composeList[fragmentInfo.treasure_id] == nil then
            composeList[fragmentInfo.treasure_id] = treasure
            
            --记录宝物所需所有碎片
            local fragmentIdList = {}
            for i=1, 6 do 
                local key = string.format("treasure_fragment0%d_id",i)
                local fragmentId = treasure[key]
                if fragmentId > 0  then
                   fragmentIdList[#fragmentIdList+1] = fragmentId
                end
            end

            if self:checkFragmentEnough(fragmentIdList) then
                return fragmentInfo.treasure_id
            end
        end
    end
    
    return 0

end


--[[
    检查是_treasureId是否可合成
]]

function TreasureFragmentData:checkTreasureComposeByComposeId(_treasureId)

    local treasure = TreasureInfo.get(_treasureId)
    local idList = {}
    for i=1, 6 do 
        local key = string.format("treasure_fragment0%d_id",i)
        local fragment_id = treasure[key]
        if fragment_id > 0 then
            table.insert(idList,fragment_id)
        end
    end
    return self:checkFragmentEnough(idList)
end


--检查碎片是否足够合成宝物
function TreasureFragmentData:checkFragmentEnough(_fragmentIdList)
   if _fragmentIdList == nil or #_fragmentIdList == 0 then
        return false
   end
   for i,v in ipairs(_fragmentIdList) do
        local fragment = self:getFragmentByID(v)
        if fragment == nil or fragment["num"]==0 then
            return false
        end 
   end

   return true
end


--[[
    检查某一类型的宝物是否有碎片，用于夺宝
]]
function TreasureFragmentData:checkTreasureFragmentExist(_treasureId)

	if type(_treasureId) ~= "number" then return false end

    local treasure = TreasureInfo.get(_treasureId)
    
    for i=1, 6 do 
        local key = string.format("treasure_fragment0%d_id",i)
        local fragment_id = treasure[key]
        if self:getFragmentByID(fragment_id) ~= nil then
            return true
        end
    end

    return false
end


--判断某个碎片是否是新的宝物碎片
function TreasureFragmentData:checkIsNewTypeFragment(_fragmentId, fragmentList)

	if type(_fragmentId) ~= "number" then return false end

    --local newFragment = TreasureFragmentInfo.get(_fragmentId)
   
    local list = fragmentList or self:getFragmentList()

    --遍历碎片列表
    for i,v in ipairs(list) do
        -- local fragment = TreasureFragmentInfo.get(v.id)
        -- --是否属于同一种宝物的碎片
        -- if fragment.treasure_id == newFragment.treasure_id then
        --     return false
        -- end
        if v.id == _fragmentId then
            return false
        end
    end

    return true

end
    

----------------------宝物碎片 增 删 改
function TreasureFragmentData:insertFragments( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		self:_setFragmentData(value[i])
	end
end

function TreasureFragmentData:deleteFragments( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		local id = value[i]
		self._fragmentList[TreasureFragmentData.KEY_PREV..tostring(id)] = nil
	end
end

function TreasureFragmentData:updateFragments( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		self:_setFragmentData(value[i])
	end
end



return TreasureFragmentData