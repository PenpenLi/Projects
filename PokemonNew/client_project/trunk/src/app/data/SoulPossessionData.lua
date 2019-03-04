--
-- Author: yutou
-- Date: 2019-01-14 21:25:24
--
local SoulPossessionData=class("SoulPossessionData")
local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
local soul_info = require("app.cfg.soul_possession_info")
local soul_possession_random_info = require("app.cfg.soul_possession_random_info")

function SoulPossessionData:ctor()
	self._chpaters = nil
	self._serverDatas = nil
	self._datas = nil
	self._maxCfgStage = 0
	self._max_finish = 0
	self._hasOver = false
	self._formationID = nil
	self._tempSoulFormation = nil
	self._tempBodyFormation = nil
	self._lockList = nil
	self._dataManager = nil
end

function SoulPossessionData:hasFormationData()
	return FormationsDataManager.getInstance():getData() ~= nil
end

function SoulPossessionData:setFormationData( data )
	self._dataManager = FormationsDataManager.getInstance()
	self._dataManager:setData(data)
end

function SoulPossessionData:hasData(  )
	return self._serverDatas ~= nil
end

function SoulPossessionData:init()
	self._chpaters = {}
	self._serverDatas = nil
	self._datas = {}
	self._lockList = {0,0,0,0,0,0}
	self._tempBodyFormation = {}

	local len = soul_info.getLength()
	for i=1,len do
		local cfgData = soul_info.indexOf(i)
		if self._chpaters[cfgData.layer] == nil then
			self._chpaters[cfgData.layer] = {}
		end
		table.insert(self._chpaters[cfgData.layer],cfgData)
		if cfgData.layer > self._maxCfgStage then
			self._maxCfgStage = cfgData.layer
		end
	end
	-- self:update()
end

function SoulPossessionData:getMaxCfgStage( ... )
	return self._maxCfgStage
end

function SoulPossessionData:getDropId( layer )
    local cfgs = self._chpaters[layer]
    assert(cfgs,"SoulPossessionData:getDropId not find layer:"..tostring(layer))
    local dropId = nil
    local hasOver = true
    if layer > self._max_finish then
    	hasOver = false
    end
    if hasOver then
    	dropId = cfgs[6].drop_value_1
    	return dropId,false
    else
    	return {cfgs[6].drop_value_2,cfgs[6].drop_value_1},{true,false}
    end
end

function SoulPossessionData:isPure( list )
	for i=1,#list do
		if list[i] ~= 0 then
			return list[i]
		end
	end
	return 0
end

function SoulPossessionData:stageIsPure(  )
	if self._pos_flag then
		if self:isPure(self._pos_flag) ~= 0 then
			return false
		end
	end
	return true
end

--0 不能打   1 能打   -1 赢了 不能打
function SoulPossessionData:canAttack( pos )
	if self._pos_flag[pos] then
		local top1 = {self._pos_flag[6]}
		local top2 = {self._pos_flag[4],self._pos_flag[5]}
		local top3 = {self._pos_flag[1],self._pos_flag[2],self._pos_flag[3]}
		if pos == 6 then
			if self:isPure(top1) == 0 and self:isPure(top2) == 1 then
				return 1
			else
				if self:isPure(top1) == 1 then
					return -1
				else
					return 0
				end
			end
		elseif pos == 4 or pos == 5 then
			if self:isPure(top2) == 0 and self:isPure(top3) == 1 then
				return 1
			else
				if self:isPure(top2) == 1 then
					return -1
				else
					return 0
				end
			end
		elseif pos == 1 or pos == 2 or pos == 3 then
			if self:isPure(top3) == 0 then
				return 1
			else
				if self:isPure(top3) == 1 then
					return -1
				else
					return 0
				end
			end
		end
	end
	return 0
end

function SoulPossessionData:getEnemyByPos( layer,pos )
	for i=1,#self._chpaters[layer] do
		if self._chpaters[layer][i].position == pos then
			return self._chpaters[layer][i]
		end
	end
	return nil
end

function SoulPossessionData:getEnemyByLayer( layer )
	return self._chpaters[layer]
end



--  optional uint32 max_finish = 1; //当前完成过的最高层。
--  optional uint32 current = 2; //当前所在的层。
--  optional uint32 pos_flag = 3; //几个怪的状态，如果没进入章节则为空
--  optional uint32 knights = 4; //随机出来的武将，如果没进入章节则为空
-- optional CommonCount count = 5; //剩余次数
-- optional CommonCount refresh_count = 6; //剩余刷新次数
--  1 win 2 faile
function SoulPossessionData:update( serverDatas )
	-- serverDatas = {
	-- 	pos_flag = {0,1,0,0,0,0},
	-- 	knights = {11802,11801,11803,11804},
	-- 	count = {left_count = 1,buy_count = 1},
	-- 	refresh_count = {left_count = 1,buy_count = 1},
	-- 	current = 2,
	-- 	max_finish = 4,
	-- }
	self._serverDatas = serverDatas
	-- self._serverDatas.pos_flag = {
	-- 	{0,1,0,0,1,0},
	-- 	{0,0,0,0,0,0},
	-- 	{0,0,0,0,0,0},
	-- 	{0,0,0,0,0,0},
	-- }
	self._max_finish = serverDatas.max_finish
	self._current = serverDatas.current
	if serverDatas.pos_flag then
		self._pos_flag = serverDatas.pos_flag
	else
		self._pos_flag = {0,0,0,0,0,0}
	end
	self:setKnights( serverDatas.knights )
	self._count = serverDatas.count
	self._refresh_count = serverDatas.refresh_count
end

function SoulPossessionData:resetPosFlag( )
	self._pos_flag = {0,0,0,0,0,0}
end

function SoulPossessionData:setPosFlag( data )
	self._pos_flag = data
end

-- left_count = 1,buy_count = 1
function SoulPossessionData:setKnights( data )
	self._knight_ids = data
	self._knights = {}
	for i=1,#self._knight_ids do
		if soul_possession_random_info.get(self._knight_ids[i]) then
			self._knights[i] = soul_possession_random_info.get(self._knight_ids[i]).knight_id
		else
			self._knights[i] = 0
		end
	end
	self._tempBodyFormation.knights = nil
	self._tempBodyFormation.knight_ids = nil
end

function SoulPossessionData:getBodyKnightIDs( )
	return self._tempBodyFormation.knight_ids
end

function SoulPossessionData:getBodyKnightOrders( )
	return self._tempBodyFormation.orders
end

function SoulPossessionData:setCount(data)
	self._count = data
end

function SoulPossessionData:setRefreshCount(data)
	self._refresh_count = data
end

function SoulPossessionData:getBodyOrders()
	
end

function SoulPossessionData:getCurStage()
	return self._current
end

function SoulPossessionData:setCurStage(data)
	if data > self._max_finish + 1 then
		self._max_finish = data -1
	end
	self._current = data
end

  -- required uint32 func_id = 1; //功能id
  -- required uint32 left_count = 2;//剩余次数
  -- required uint32 buy_count = 3;//购买次数
-----------------------------------------------
function SoulPossessionData:getLeftCount()
	return self._count.left_count
end

function SoulPossessionData:getBuyCount()
	return self._count.buy_count
end

function SoulPossessionData:getRefreshLeftCount()
	return self._refresh_count.left_count
end

function SoulPossessionData:getRefreshBuyCount()
	return self._refresh_count.buy_count
end


function SoulPossessionData:getMaxStage()
	local maxStage = 0
	if self._max_finish + 1 > self._maxCfgStage then
		maxStage = self._maxCfgStage
	else
		maxStage = self._max_finish + 1
	end
	return maxStage
end

function SoulPossessionData:getFormationID()
	self._dataManager = FormationsDataManager.getInstance()
	local id = self._dataManager:getFormationIdByFunid(G_FunctionConst.FUNC_SOUL_POSSESSION)
	return id
end

function SoulPossessionData:getSoulFormation()
	self._dataManager = FormationsDataManager.getInstance()
	local curID = self:getFormationID()
	if self._tempSoulFormation == nil or self._formationID ~= curID then
		self._tempSoulFormation = {}
	    local knights = nil
	    local orders = nil
		if curID == 0 then
	    	knights = G_Me.teamData:getMyFormationIDList()
		    orders = G_Me.teamData:getMyFormationOrderList()
	    else
	    	knights = {}
	    	for i=1,6 do
	    		knights[i] =  self._dataManager:getKnightIDByPos(curID,i)
	    	end
	    	orders = self._dataManager:getOrder(curID)
		end
		self._tempSoulFormation = {knights = clone(knights),orders = clone(orders)}
		self._formationID = curID
		self._tempBodyFormation.orders = nil
		self._tempBodyFormation.knights = nil
		self._tempBodyFormation.knight_ids = nil
	end
	return self._tempSoulFormation.knights,self._tempSoulFormation.orders
end

function SoulPossessionData:getKnightPoss( )
	local poss = {}
	for i=1,#self._tempSoulFormation.knights do
		local pos = G_Me.teamData:getKnightPosByID(self._tempSoulFormation.knights[i])
		print("getKnightPossgetKnightPoss",self._tempSoulFormation.knights[i],pos)
		poss[i] = pos
	end
	return poss
end

function SoulPossessionData:getBodyFormation()
	if self._tempBodyFormation.knights == nil then
		self._tempBodyFormation.knights = clone(self._knights)
		self._tempBodyFormation.knight_ids = clone(self._knight_ids)
		self._tempBodyFormation.knight_poss = {1,2,3,4,5,6}
	end

	if self._tempBodyFormation.orders == nil then
	    local curID = self:getFormationID()
	    local knights = nil
	    local orders = nil
		if curID == 0 then
	    	knights = G_Me.teamData:getMyFormationIDList()
		    orders = G_Me.teamData:getMyFormationOrderList()
	    else
	    	knights = {}
	    	for i=1,6 do
	    		knights[i] =  self._dataManager:getKnightIDByPos(curID,i)
	    	end
	    	orders = self._dataManager:getOrder(curID)
		end
		self._tempBodyFormation.orders = clone(orders)
	end
	dump(self._tempBodyFormation.orders)
	dump(self._lockList)
	return self._tempBodyFormation.knights,self._tempBodyFormation.orders,self._lockList
end

function SoulPossessionData:refreshKnights( knights )
	self._knight_ids = knights
	for i=1,#knights do
		if knights[i] ~= 0 then
			self._knights[i] = soul_possession_random_info.get(knights[i]).knight_id
		else
			self._knights[i] = 0
		end
	end

	if self._tempBodyFormation and self._tempBodyFormation.knight_poss then
		for i=1,#self._tempBodyFormation.knight_poss do
			local pos = self._tempBodyFormation.knight_poss[i]
			if knights[pos] ~= 0 then
				self._tempBodyFormation.knight_ids[i] = knights[pos]

				if soul_possession_random_info.get(self._tempBodyFormation.knight_ids[i]) then
					self._tempBodyFormation.knights[i] = soul_possession_random_info.get(self._tempBodyFormation.knight_ids[i]).knight_id
				else
					self._tempBodyFormation.knights[i] = 0
				end
			end
		end
	end

	-- self:removeLockIDs(knights)
	-- for i=1,#self._tempBodyFormation.knight_ids do
	-- 	if self._tempBodyFormation.knight_ids[i] ~= 0 and self._lockList[i] ~= 1 then
	-- 		self._tempBodyFormation.knight_ids[i] = table.remove(knights,1)

	-- 		if soul_possession_random_info.get(self._tempBodyFormation.knight_ids[i]) then
	-- 			self._tempBodyFormation.knights[i] = soul_possession_random_info.get(self._tempBodyFormation.knight_ids[i]).knight_id
	-- 		else
	-- 			self._tempBodyFormation.knights[i] = 0
	-- 		end
	-- 	end
	-- end
end

-- function SoulPossessionData:removeLockIDs( knights )
-- 	local lockIDs = self:getLockIDs()
-- 	for i=1,#lockIDs do
-- 		for j=1,#knights do
-- 			if knights[j] == lockIDs[i] then
-- 				table.remove(knights,j)
-- 			end
-- 		end
-- 	end
-- end

function SoulPossessionData:isAllLock()
	for i=1,#self._tempBodyFormation.knight_ids do
		if self._tempBodyFormation.knight_ids[i] ~= 0 and self._lockList[i] ~= 1 then
			return false
		end
	end
	return true
end

function SoulPossessionData:getLockPoss()
	local ids = {}
	for i=1,#self._lockList do
		if self._lockList[i] == 1 then
			table.insert(ids,self._tempBodyFormation.knight_poss[i])
		end
	end
	return ids
end

function SoulPossessionData:switchSoulPos( type, fromTab,toTab )
	local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
	local datas = nil
	if SimpleFormationList.TYPE_SWITCH_ORDER == type then
		datas = self._tempSoulFormation.orders

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT == type then
		datas = self._tempSoulFormation.knights

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT_ORDER == type then
		datas = self._tempSoulFormation.knights

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue
		
		datas = self._tempSoulFormation.orders

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue
	end
end

function SoulPossessionData:switchBodyPos( type, fromTab,toTab )
	local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
	local datas = nil
	if SimpleFormationList.TYPE_SWITCH_ORDER == type then
		datas = self._tempBodyFormation.orders

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT == type then
		datas = self._tempBodyFormation.knights

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue

		self:switchLockPos(fromTab,toTab)
		
		local poss = self._tempBodyFormation.knight_poss
		local fromValue = poss[fromTab]
		local toValue = poss[toTab]
		poss[fromTab] = toValue
		poss[toTab] = fromValue

		local data_ids = self._tempBodyFormation.knight_ids
		local fromValue = data_ids[fromTab]
		local toValue = data_ids[toTab]
		data_ids[fromTab] = toValue
		data_ids[toTab] = fromValue
	elseif SimpleFormationList.TYPE_SWITCH_KNIGHT_ORDER == type then
		
		datas = self._tempBodyFormation.orders

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue


		datas = self._tempBodyFormation.knights

		local fromValue = datas[fromTab]
		local toValue = datas[toTab]
		datas[fromTab] = toValue
		datas[toTab] = fromValue

		self:switchLockPos(fromTab,toTab)
		
		local poss = self._tempBodyFormation.knight_poss
		local fromValue = poss[fromTab]
		local toValue = poss[toTab]
		poss[fromTab] = toValue
		poss[toTab] = fromValue

		local data_ids = self._tempBodyFormation.knight_ids
		local fromValue = data_ids[fromTab]
		local toValue = data_ids[toTab]
		data_ids[fromTab] = toValue
		data_ids[toTab] = fromValue
	end
end

function SoulPossessionData:switchLockPos(fromTab,toTab )
	local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
	local datas = self._lockList
	local fromValue = datas[fromTab]
	local toValue = datas[toTab]
	datas[fromTab] = toValue
	datas[toTab] = fromValue
end

function SoulPossessionData:getLockList()
	return self._lockList
end

-- function SoulPossessionData:getCanMaxLayer()
-- 	for layer=1,#self._serverDatas.pos_flag do
-- 		if self:isPure(self._pos_flag) then
-- 			return layer
-- 		end
-- 	end
-- 	return 1
-- end

function SoulPossessionData:getState(pos)
	print("SoulPossessionData:setState",pos,self._pos_flag[pos])
	if self._pos_flag[pos] then
		return self._pos_flag[pos]
	else
		return 0
	end
end

function SoulPossessionData:setState(pos,state)
	print("SoulPossessionData:setState",pos,state)
	self._pos_flag[pos] = state
end

function SoulPossessionData:release()
	self._chpaters = nil
	self._serverDatas = nil
	self._datas = nil
	self._maxCfgStage = 0
	self._hasOver = false
	self._formationID = nil
	self._tempSoulFormation = nil
	self._tempBodyFormation = nil
end

return SoulPossessionData