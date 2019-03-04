--
-- Author: YouName
-- Date: 2015-10-14 17:53:02
--
local TowerData=class("TowerData")
local DropUtils = require("app.common.DropUtils")

function TowerData:ctor( ... )
	-- body
	self._towerData = nil--后端数据缓存
	self._clientLayers = nil
	self._numTotalLayer = 0
	-- self._tempStage = 0
	self._executeTower = nil

	self._lastCount = 0--剩余次数
	self._lastRequestTime = nil

	self._battleLayer = 0--缓存战斗的关卡
	self._battleStage = 0--缓存战斗的关卡
	self._go_next_reward = nil
	self._isShouTong = nil
	self._lastStars = nil
	self._canPopNext = false -- 可否弹出进入下关效果
	self.canPopReward = true -- 是否可以弹出奖励弹框

	self:_initTowerData()
end

-----------0点重置的时候重置次数
function TowerData:resetBuyCount()
	local tempCommonCount = self:getCommonCount()
	if tempCommonCount == nil then return end
	-- required uint32 func_id = 1; //功能id
	-- required uint32 left_count = 2;//剩余次数
	-- required uint32 buy_count = 3;//购买次数	
	-- self._towerData["common_count"] = {
	-- 	func_id = tempCommonCount.func_id,
	-- 	left_count = 1,
	-- 	buy_count = 0,
	-- }
	self._towerData["left_reset_count"] = 1

	self:_updateLastTime()
end

function TowerData:setLastCount( value )
	-- body
	self._lastCount = value--剩余次数
end

function TowerData:getLastCount( ... )
	-- body
	return self._lastCount
end

--初始化数据
function TowerData:_initTowerData( ... )
	-- body
	self._towerData = {
		layer = 0, --最高层数 默认为1
		now_layer = 0, --当前正在挑战的层数 没有开始挑战为0 主要以这个为判断
		now_stage = 0, --当前层数的第几关
		now_star = 0, --当前获得的星数
		now_left_star = 0, --当前剩余的星数
		select_buffs = nil, --玩家可选的buff id 不为空要弹出来 key 为buff id value 为0 和1 0没有为选过 1 被选过
		buffs = nil, --当前buff加成
		shop_buy = nil, --商店是否购买 0 没有购买 1 已经购买
		--common_count = nil, --次数
		open_count = 0, --当前宝箱的开启次数
		--stage_box = 0, --当前关卡宝箱是否开启
		max_layer = 0,--//历史通关最高层
		max_stage = 0,	--//历史通过最大关卡
		pass_reward = nil, --//每层通关奖励领取情况 0-> 未领取  1-> 已领取
		free = false, -- //最高层是否有免费次数  true->有免费次数 false代表没有免费次数
		--perfect_stage = nil,-- //每一层可扫荡的最大关卡
		can_fast = false,--能否扫荡
		award_preview = nil,--本层奖励
		status = 0--0-正在闯关，1-闯关失败，2-通关
	}
	--self._go_next_reward = nil
end

--更新重置次数
function TowerData:setLeftCount( value )
	-- body
	self._towerData.left_count = value
end

--获取重置次数
function TowerData:getLeftCount( ... )
	-- body
	return self._towerData.left_count
end

--更新随机宝箱需要的消耗
function TowerData:setOpenCost( value )
	-- body
	self._towerData.open_cost = value
end

--获取随机宝箱需要的消耗
function TowerData:getOpenCost( ... )
	-- body
	return self._towerData.open_cost
end

-----------------------------------------------------------------------------------------------折扣商人相关数据接口
--------获取折扣商人商品数据
function TowerData:getShopBuy( ... )
	-- body
	return self._towerData.shop_buy or {}
end

--判断折扣商人是否已经购买过
function TowerData:hasShopBuyed( ... )
	-- body
	local list = self:getShopBuy() or {}
	local bool = false
	if(#list > 0)then
		for i=1,#list do
			if(list[i].Value > 0)then
				bool = true
				break
			end
		end
	end

	return bool
end

--------购买商品后更新商品数据
function TowerData:setShopBuyed( id )
	-- body
	if(self._towerData.shop_buy ~= nil)then
		for i=1,#self._towerData.shop_buy do
			if(self._towerData.shop_buy[i].Key == id)then
				self._towerData.shop_buy[i].Value = 1
				break
			end
		end
	end
end

--------折扣商人是否开启中
function TowerData:isShopBuyOpen( ... )
	-- body
	return self._towerData.shop_buy ~= nil and #self._towerData.shop_buy > 0
end

------判断折扣商人中的商品是否已全部购买
function TowerData:isShopGoodsAllBuyed( ... )
	-- body
	local num = 0
	if(self._towerData.shop_buy ~= nil)then
		for i=1,#self._towerData.shop_buy do
			if(self._towerData.shop_buy[i].Value == 1)then
				num = num + 1
			end
		end
	end

	return num >= 1
end

--------重新刷新折扣商人商品数据
function TowerData:setShopBuy( lists )
	-- body
	self._towerData.shop_buy = lists
end

-----------获取折扣商人中的随机商品ID
function TowerData:getShopGoodsID( )
	-- body
	if(self._towerData.shop_buy ~= nil and #self._towerData.shop_buy > 0)then
		return self._towerData.shop_buy[1].Key
	end

	return 0
end

-----------------------------------------------------------------------------------------------折扣商人相关数据接口

function TowerData:isShowRedPoint( ... )
	-- body
	local bool = false
	-- if self._towerData ~= nil and self._towerData.common_count ~= nil then
	-- 	bool = self._towerData.common_count.left_count > 0
	-- end
	--0 有奖励未领取
	if self:getLayerAwardsFlag(self._towerData.now_layer) == 0 or 
		(self:isShopBuyOpen() and self:isShopGoodsAllBuyed() == false)
	then
		bool = true
	end
	return bool
end

--获取挑战次数相关信息
function TowerData:getCommonCount( ... )
	-- body
	--return self._towerData.common_count
	return self._towerData.left_reset_count
end

--设置挑战次数相关信息
function TowerData:setCommonCount( buffData )
	-- body
	self._towerData.common_count = buffData
end

--设置手动刷新剩余星数
function TowerData:setLeaveStar(value)
	if(value == nil or type(value) ~= "number")then return end
	self._towerData.now_left_star = value
end

--获取剩余星数
function TowerData:getLeaveStar( ... )
	-- body
	return self._towerData.now_left_star
end

--获取当前星数
function TowerData:getNowStar( ... )
	-- body
	return self._towerData.now_star
end

--获取历史最大星数
function TowerData:getLayersHistoryTotalStars( ... )
	-- body
	return self._towerData.max_star
end



--获取当前挑战的章节层数
function TowerData:getNowLayer( )
	-- body
	return self._towerData.now_layer
end

--获取已通关的章节层数
function TowerData:getPassedLayer( ... )
	-- body
	return self._towerData.layer
end

--获取当前关卡
function TowerData:getNowStage( )
	-- body
	print2("self._towerData.now_stage",self._towerData.now_stage)
	return self._towerData.now_stage
end

function TowerData:getTowerData( ... )
	-- body
	return self._towerData
end

--获取选中的的buffs
function TowerData:getSelectBuffs(  )
	-- body
	return self._towerData.select_buffs
end

--清除选中的buffs
function TowerData:clearSelectBuffs( ... )
	-- body
	self._towerData.select_buffs = nil
end

--获取历史最高章节层数
function TowerData:getMaxLayer( ... )
	-- body
	return self._towerData.max_layer
end

--获取历史最高关卡
function TowerData:getMaxStage( ... )
	-- body
	return self._towerData.max_stage
end

--历史最高层免费次数是否用完
function TowerData:isMaxLayerFree( ... )
	-- body
	return self._towerData.free
end

-- 获取重置时间
function TowerData:getResetTime( ... )
	return self._towerData.reset_time
end

--设置选中的BUFFID 累加到buff加成列表中
--buffId 为0的时候是放弃选择
function TowerData:setAfterChoseBuff( buffId )
	-- body
	if(buffId == nil or type(buffId) ~= "number")then return end
	if(self._towerData.buffs == nil)then
		self._towerData.buffs = {}
	end
	if buffId ~= 0 then
		table.insert(self._towerData.buffs,buffId)
	end

	self._towerData.select_buffs = nil
end
--获取buff加成
function TowerData:getAddedBuffs(  )
	-- body
	local list = {}
	local tempList = self._towerData.buffs or {}
	local realBuffs = {}

	for i=1,#tempList do
		local buffId = tempList[i]
		local buffInfo = require("app.cfg.common_buff_info").get(buffId)
		assert(buffInfo,"common_buff_info can't find id = "..tostring(buffId))
		if(realBuffs["key_"..tostring(buffInfo.type)] == nil)then
			realBuffs["key_"..tostring(buffInfo.type)] = {type=buffInfo.type,value=buffInfo.value,id = i}
		else
			realBuffs["key_"..tostring(buffInfo.type)].value = realBuffs["key_"..tostring(buffInfo.type)].value + buffInfo.value
		end
	end

	local num = 0
	for k,v in pairs(realBuffs) do
		local strName,strValue = GlobalFunc.getAttrDesc(v.type,v.value)
		list[#list + 1] = {name = strName,value = strValue,id = v.id}
	end

	table.sort(list,function(a,b)
		return a.id < b.id
	end)

	return list
end

--重置33重天数据
function TowerData:resetTowerData( buffData )
	self:_initTowerData()

	if(buffData == nil)then return end
	dump(buffData)
	print("now_layer",buffData.now_layer)
	self._towerData.stage_count = buffData.stage_count -- 没个怪的挑战次数
	self._towerData.now_layer = buffData.now_layer
	self._towerData.now_stage = buffData.now_stage
	self._towerData.now_star = buffData.now_star
	self._towerData.max_star = buffData.max_star
	self._towerData.now_left_star = buffData.now_left_star
	self._towerData.select_buffs = rawget(buffData,"select_buffs") or nil
	self._towerData.buffs = rawget(buffData,"buffs") or nil
	self._towerData.shop_buy = buffData.shop_buy
	--self._towerData.common_count = buffData.common_count
	self._towerData.left_count = buffData.left_count--开启的剩余次数
	self._towerData.open_cost = buffData.open_cost--开启需要的花费
	--self._towerData.stage_box = buffData.stage_box
	self._towerData.max_layer = buffData.max_layer --//历史通关最高层
	self._towerData.max_stage = buffData.max_stage 	--//历史通过最大关卡
	self._towerData.can_fast = buffData.can_fast--是否可以三星扫荡
	self._towerData.stage_stars = rawget(buffData,"stage_stars") or {}--每一层的星星数量
	self._towerData.free = false
	self._towerData.award_preview = buffData.award_preview
	self._towerData.status = buffData.status
	self._towerData.left_reset_count = buffData.left_reset_count -- 剩余重置次数
	self._towerData.reset_time = buffData.reset_time -- 重置时间戳
	self._towerData.super_exe_layer = buffData.super_exe_layer -- 一键三星

	--self._towerData.perfect_stage = buffData.perfect_stage
	print("gadgaagdaha",buffData.status)
	local list = buffData.pass_reward or {}
	self._towerData.pass_reward= list  
end

function TowerData:getStageStar( stageID )
	for i=1,#self._towerData.stage_stars do
		if stageID == self._towerData.stage_stars[i]["Key"] then
			return self._towerData.stage_stars[i]["Value"]
		end
	end
	return 0
end

function TowerData:setStageStar( stageID,star )
	local stageStarData = 
	{
		["Key"] = stageID,
		["Value"] = star,
	}
	table.insert(self._towerData.stage_stars,stageStarData)
end

-- 获取关卡剩余挑战次数
function TowerData:getStageCount( stageID )
	return self._towerData.stage_count[((stageID - 1) % 3) + 1]
end

--是否可以三星扫荡
function TowerData:canFast( ... )
	return self._towerData.can_fast
end

--获取奖励
--获取显示后直接去除
function TowerData:getPassAward( getAndClear )
	local passAward = self._towerData.pass_reward
	if getAndClear then
		self._towerData.pass_reward = nil
	end
	return passAward
end

--获取可以选择的buff
function TowerData:getSelectBuffs( ... )
	return self._towerData.select_buffs
end

--选择完之后 清空可以选择的buff
function TowerData:clearSelectBuff( ... )
	self._towerData.select_buffs = nil
end

-- --
-- function TowerData:getPerfectStage( layer )
-- 	-- body
-- 	if(self._towerData == nil or self._towerData.perfect_stage == nil)then return 0 end
-- 	local list = self._towerData.perfect_stage or {}
-- 	if(layer <= #list)then
-- 		return list[layer]
-- 	end
-- 	return 0
-- end

function TowerData:getLastTime()
	return self._lastRequestTime
end

function TowerData:_updateLastTime()
	self._lastRequestTime = G_ServerTime:getTime()
end

--初始化全部数据
--[[
message Tower {
  required uint32 layer = 1;//通关的层数
  optional uint32 max_layer = 2; //历史通过的最高层
  optional uint32 max_stage = 3; //历史通过最大关卡
  required uint32 now_layer = 4;//当前正在挑战的层数 没有开始挑战为0 主要以这个为判断
  required uint32 now_stage = 5;//当前层数的第几关
  required uint32 now_star = 6;//当前获得的星数
  required uint32 now_left_star = 7;//当前剩余的星数
  repeated uint32 buffs = 8;//当前buff加成
  repeated IntMap select_buffs = 9;//玩家可选的buff id 不为空要弹出来 key 为buff id value 为0 和1 0没有为选过 1 被选过
  required uint32 stage_box = 10;//当前关卡宝箱是否开启
  required uint32 open_count = 11;//当前隐藏宝箱的开启次数

  //repeated uint32 layer_stars = 12; //每一层对应的历史最大星数
  repeated uint32 perfect_stage = 13; //每一层可扫荡的最大关卡
  repeated uint32 pass_reward = 14; //每层通关奖励领取情况 0-> 未领取  1-> 已领取
  //optional bool   free = 15; //最高层是否有免费次数  true->有免费次数 false代表没有免费次数
  required CommonCount common_count = 16;//次数
  repeated IntMap shop_buy = 17;//商店是否购买 0 没有购买 1 已经购买
}
]]
function TowerData:setAllData( buffData )
	self:_updateLastTime()
	-- body
	----这里要把结算数据重置掉，不然会出现问题
	----- 例如：打最后一个怪进入战斗场景，这时断线了弹了重连框，now_layer被重置为0了，
	-----但是结算没重置，这时进入闯关界面会找不到当前layer的数据 因为now_layer == 0

	self:_initLayers()
	self:resetTowerData(buffData)

	if buffData ~= nil and buffData.left_reset_count ~= nil then
		local leftCount = buffData.left_reset_count or 0
		self:setLastCount(leftCount)
	end
end

--初始化所有关卡本地数据
function TowerData:_initLayers( ... )
	-- body
	local layerList = {}
	local towerInfo = require("app.cfg.tower_info")
	--local chapterInfo = require("app.cfg.tower_chapter_info")
	--local len = chapterInfo.getLength()
	local len = towerInfo.getLength()
	for i=1,len do
		local towerData = towerInfo.indexOf(i)
		local numLayer = towerData.layer
		local tLayers = layerList["layer_"..tostring(numLayer)]
		if(tLayers == nil)then
			tLayers = {stages = {},totalStar = 0,layer = numLayer}
		end
		
		tLayers.totalStar = tLayers.totalStar + 3
		tLayers.stages["stage_"..tostring(towerData.stage)] = towerData

		layerList["layer_"..tostring(numLayer)] = tLayers
	end

	self._clientLayers = layerList
	self._numTotalLayer = len
end

function TowerData:getNowLevel( )
	local nowLayer = tostring(self._towerData.now_layer)
	local nowStage = tostring(self._towerData.now_stage)
	return self._clientLayers["layer_"..nowLayer].stages["stage_"..nowStage].level
end

--获取总层数
function TowerData:getNumTotalLayer( ... )
	-- body
	return self._numTotalLayer
end

--获取全部层数据
function TowerData:getTotalLayers( ... )
	if(self._clientLayers == nil)then return nil end
	local list = {}
	for k,v in pairs(self._clientLayers) do
		list[#list+1] = v
	end
	table.sort(list,function(a,b)
		return a.layer < b.layer
	end)
	return list
end

--获取指定层数的章节数据
function TowerData:getLayerData( layer )
	-- body
	if(self._clientLayers == nil)then return nil end
	return self._clientLayers["layer_"..tostring(layer)]
end

--获取指定层的全部关卡列表
function TowerData:getStagesByLayer( layer )
	-- body
	local list = {}
	if(self._clientLayers == nil)then return list end
	local layerData = self._clientLayers["layer_"..tostring(layer)]
	if(layerData == nil)then return list end
	local stages = layerData.stages
	for k,v in pairs(stages) do
		list[#list+1] = v
	end
	table.sort(list,function(a,b)
		return a.stage < b.stage
	end)
	return list
end

--获取指定层数的关卡list
function TowerData:getLevelsByLayer( layer )
	local list = {}
	local stages = self:getStagesByLayer(layer)
	for i=1,#stages do
		table.insert(list,stages[i].id)
	end
	return list
end

--判断指定层的章节是否通关
function TowerData:isLayerClear( layer )
	-- body
	local maxPassedLayer = self:getPassedLayer()
	return layer <= maxPassedLayer
end

--获取当前挑战章节的 挑战进度
function TowerData:getNowLayerProgress()
	-- body
	local nowLayer = self:getNowLayer()
	local nowStage = self:getNowStage()
	if(nowLayer == 0)then return 0,0 end
	local stagesList = self:getStagesByLayer(nowLayer) or {}
	return nowStage,#stagesList
end

--获取指定的关卡数据
function TowerData:getStageData( layer,stage )
	-- body
	local layerData = self:getLayerData(layer)
	if(layerData == nil or layerData.stages == nil)then return nil end
	return layerData.stages["stage_"..tostring(stage)]
end

--缓存战斗的关卡  回调的时候用
function TowerData:setBattleLayerStage( layer,stage )
	if layer and stage then
		self._battleLayer,self._battleStage = layer,stage
	else
		self._battleLayer,self._battleStage = self._towerData.now_layer,self._towerData.now_stage
	end
end

--缓存战斗的关卡  回调的时候用
function TowerData:getBattleLayerStage( )
	return self._battleLayer,self._battleStage
end

function TowerData:getAwardPreview( )
	local awards = self._towerData.award_preview
	local activityDrops = {}
	local ActivityDrops = require("app.data.ActivityDrops")
	activityDrops = G_Me.activityDrops:get(ActivityDrops.MISSION_TOWER)
	for i=1,#activityDrops do
		local drop = {}
		for k,v in pairs(activityDrops[i]) do
			drop[k] = v
		end
		table.insert(awards,drop)
	end
	awards = DropUtils.unRepeat(awards)
	return awards
end

--挑战关卡后更新
function TowerData:setAfterExecuteTower( buffData )
	dump(buffData)
	-- self._towerData.select_buffs = nil
	-- self._executeTower = rawget(buffData, "tower")
	-- if self._executeTower ~= nil then
	-- 	self._towerData.pass_reward = self._executeTower.pass_reward
	-- 	self._towerData.left_count = self._executeTower.left_count
	-- 	self._towerData.open_cost = self._executeTower.open_cost
	-- 	self._towerData.award_preview = self._executeTower.award_preview
	-- 	self._towerData.can_fast = self._executeTower.can_fast
	-- 	self._towerData.status = self._executeTower.status
	-- 	print("gadgaagdaha",self._towerData.status)
	-- end
	-- ---------------
	-- local addStar = buffData.star or 0

	-- local stageData = self:getStageData(self._towerData.now_layer,self._towerData.now_stage)
	-- self:setStageStar(stageData.id,addStar)
	-- print2("setAfterExecuteTower")

	-- self._towerData.now_layer = buffData.now_layer
	-- self._towerData.now_stage = buffData.now_stage

	-- -- self._tempStage = buffData.stage
	-- self._towerData.now_star = self._towerData.now_star + addStar
	-- self._towerData.now_left_star = self._towerData.now_left_star + addStar
	-- self._towerData.max_star = self._towerData.now_star > self._towerData.max_star and self._towerData.now_star or self._towerData.max_star

	-- if self._executeTower then
	-- 	local buffs = rawget(self._executeTower,"select_buffs")
	-- 	if(buffs ~= nil)then
	-- 		self._towerData.select_buffs = {}
	-- 		for i=1,#buffs do
	-- 			self._towerData.select_buffs[#self._towerData.select_buffs + 1] = buffs[i]
	-- 		end
	-- 	end
	-- end

	self:resetTowerData( rawget(buffData, "tower") )
	self._go_next_reward = rawget(buffData, "go_next_reward")
end

function TowerData:setGoNextReward( buffData )
	self._go_next_reward = buffData
end

function TowerData:getGoNextReward( getAndClear )
	local passAward =  self._go_next_reward
	if getAndClear then
		self._go_next_reward = nil
	end
	return passAward
end

function TowerData:setAfterFastExecuteTower( buffData )
	dump(buffData)
	--self._towerData.stage_box = 0 
	self._towerData.select_buffs = nil
	self._executeTower = rawget(buffData, "tower")
	if self._executeTower ~= nil then
		self._towerData.pass_reward = self._executeTower.pass_reward
		self._towerData.left_count = self._executeTower.left_count
		self._towerData.open_cost = self._executeTower.open_cost
		self._towerData.award_preview = self._executeTower.award_preview
		self._towerData.can_fast = self._executeTower.can_fast
		self._towerData.status = self._executeTower.status
		self._towerData.stage_stars = self._executeTower.stage_stars
		print("gadgaagdaha2",self._towerData.status)
	end
	---------------
	local addStar = rawget(buffData, "star") or 0
	dump(self._towerData.pass_reward)
	self._towerData.now_layer = buffData.now_layer
	self._towerData.now_stage = buffData.now_stage

	-- self._tempStage = buffData.stage
	self._towerData.now_star = self._towerData.now_star + addStar
	self._towerData.now_left_star = self._towerData.now_left_star + addStar
	self._towerData.max_star = self._towerData.max_star
	self._go_next_reward = rawget(buffData, "go_next_reward")

	if self._executeTower then
		local buffs = rawget(self._executeTower,"select_buffs")
		if(buffs ~= nil)then
			self._towerData.select_buffs = {}
			for i=1,#buffs do
				self._towerData.select_buffs[#self._towerData.select_buffs + 1] = buffs[i]
			end
		end
	end
end

function TowerData:resetTowerAfterExecute( ... )
	-- body
	print2("resetTowerAfterExecute1")
	if(self._executeTower ~= nil)then
		print2("resetTowerAfterExecute2")
		self:resetTowerData(self._executeTower)
		self._executeTower = nil
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MT_RESET_TOWER_AFTER_EXECUTE,nil,false)
	end
end

--判断通关宝箱是否已领取
function TowerData:getLayerAwardsFlag( layer )
	-- body
	--- -1 未通关 0 已通关未领取 1 已通关已领取
	local flag = -1
	if(self._towerData ~= nil and self._towerData.pass_reward ~= nil)then
		--pass_reward  后端按顺序 存放数据
		local list = self._towerData.pass_reward or {}
		for i=1,#list do
			if i == layer then
				flag = list[i]
				break
			end
		end
	end
	return flag
end

function TowerData:getCanFast( ... )
	return self._towerData.can_fast
end

function TowerData:isOver( ... )
	return self._towerData.status == 1 or self._towerData.status == 2
end

function TowerData:getStatus( ... )
	return self._towerData.status
end

--关卡推进动画需要
function TowerData:setToTempStage( ... )
	-- body
	-- if(self._tempStage ~= 0)then
	-- 	self._tempStage = 0
	-- 	self:clearSelectBuffs()
	-- 	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MT_SETTO_TMEP_STAGE,nil,false)
	-- end
end

----------判断指定层的指定关卡是否已经首通
function TowerData:hadShoutong2( layer,stage )
	local maxLayer = self:getMaxLayer()
	local maxStage = self:getMaxStage()
	-- dump(maxLayer)
	-- dump(maxStage)
	-- dump(layer)
	-- dump(stage)

	local hadShoutong = false
	if layer < maxLayer then
		hadShoutong = true
	elseif layer == maxLayer then
		if stage < maxStage then
			hadShoutong = true
		else
			hadShoutong = false
		end
	else
		hadShoutong = false
	end

	return hadShoutong
end

function TowerData:hadShoutong( layer,stage )
	local hadShoutong = false
	local data = self:getStageData(layer,stage)
	local stars = self:getStageStar(data.id)
	if stars > 0 then
		return true
	end
	--dump(stars)

	-- 重置以后判断
	local maxLayer = self:getMaxLayer()
	local maxStage = self:getMaxStage()
	if layer < maxLayer then
		hadShoutong = true
	elseif layer == maxLayer then
		if stage <= maxStage then
			hadShoutong = true
		else
			hadShoutong = false
		end
	else
		hadShoutong = false
	end

	return hadShoutong
end

function TowerData:setPreFightData()
	local layer,stage = self:getBattleLayerStage()
	local isShoutong = self:hadShoutong(layer,stage)
	self._isShouTong = isShoutong
end

function TowerData:getPreFightData()
	return self._isShouTong
end

function TowerData:getEnemyTeamData( layer,level )
	local MonsterTeamDataManager = require("app.scenes.team.lineup.data.MonsterTeamDataManager")

	local data = self._clientLayers["layer_"..layer].stages["stage_"..level]
	local monster_team_id = data.monster_value
	local monster_ids,orders,power = MonsterTeamDataManager.getFormationData(monster_team_id)
	return monster_ids,orders,power
end

--获取隐藏宝箱的历史开启次数
function TowerData:getOpenedCount( ... )
	local nowLayer = self:getNowLayer()
	local nowStage = self:getNowStage()
	dump(nowLayer)
	local cfgData = self:getStageData(nowLayer-1,3)
	local max_count = 0
	for i=1,9 do
		if cfgData["hidechest"..tostring(i).."_drop"] > 0 then
			max_count = max_count + 1
		end
	end

	local left_count = self:getLeftCount()
	dump(max_count)
	dump(left_count)
	local openedCount = max_count - left_count

	return openedCount,cfgData
end

-- 记录挑战前星数
function TowerData:setLastStar(stars)
	--self._lastStars = self._towerData.stage_stars--stars
	self._lastStars = self:deepcopy(self._towerData.stage_stars)
end

function TowerData:getLastStar()
	return self._lastStars
end

function TowerData:getLastStageStar(stageID)
	if self._lastStars == nil then
		return nil
	end

	for i=1,#self._lastStars do
		if stageID == self._lastStars[i]["Key"] then
			return self._lastStars[i]["Value"]
		end
	end
	return 0
end

--深度拷贝  
function TowerData:deepcopy(object)      
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

function TowerData:setCanPopNext(bool)     
	self._canPopNext = bool
end 

function TowerData:getCanPopNext()     
	return self._canPopNext
end

function TowerData:getSuperExeLayer( ... )
	return self._towerData.super_exe_layer
end

return TowerData