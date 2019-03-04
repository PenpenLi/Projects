--
-- Author: YouName
-- Date: 2015-10-14 17:53:02
--
local ThirtyThreeData=class("ThirtyThreeData")

function ThirtyThreeData:ctor( ... )
	-- body
	self._tempExecuteType = nil
	self._towerData = nil
	self._clientLayers = nil
	self._numTotalLayer = 0
	self._tempStage = 0
	self._executeTower = nil
	self._layerResultParams = nil--通关奖励结算

	self._lastPassedLayer = -1--当前关卡层数
	self._lastCount = 0--剩余次数
	self._lastRequestTime = nil

	self:_initTowerData()
end

-----------0点重置的时候重置次数
function ThirtyThreeData:resetBuyCount()
	local tempCommonCount = self:getCommonCount()
	if tempCommonCount == nil then return end
	-- required uint32 func_id = 1; //功能id
	-- required uint32 left_count = 2;//剩余次数
	-- required uint32 buy_count = 3;//购买次数	
	self._towerData["common_count"] = {
		func_id = tempCommonCount.func_id,
		left_count = 1,
		buy_count = 0,
	}

	self:_updateLastTime()
end

function ThirtyThreeData:setLastCount( value )
	-- body
	self._lastCount = value--剩余次数
end

function ThirtyThreeData:getLastCount( ... )
	-- body
	return self._lastCount
end

function ThirtyThreeData:getLastRecordLayer( ... )
	-- body
	return self._lastPassedLayer
end

function ThirtyThreeData:updateLastRecordLayer( ... )
	-- body
	if self._towerData ~= nil then
		self._lastPassedLayer = self._towerData.layer
	end
end

function ThirtyThreeData:_initTowerData( ... )
	-- body
	self._towerData = {
		layer = 0, --最高层数 默认为1
		now_layer = 0, --当前正在挑战的层数 没有开始挑战为0 主要以这个为判断
		now_stage = 0, --当前层数的第几关
		now_star = 0, --当前获得的星数
		now_left_star = 0, --当前剩余的星数
		-- select_buffs = nil, --玩家可选的buff id 不为空要弹出来 key 为buff id value 为0 和1 0没有为选过 1 被选过
		-- buffs = nil, --当前buff加成
		-- shop_buy = nil, --商店是否购买 0 没有购买 1 已经购买
		-- common_count = nil, --次数
		-- open_count = 0, --当前宝箱的开启次数
		-- layer_stars = nil, --每一层对应的历史最大星数
		stage_box = 0, --当前关卡宝箱是否开启
		max_layer = 0,--//历史通关最高层
		max_stage = 0,	--//历史通过最大关卡
		-- pass_reward = nil, --//每层通关奖励领取情况 0-> 未领取  1-> 已领取
		-- free = false, -- //最高层是否有免费次数  true->有免费次数 false代表没有免费次数
		-- perfect_stage = nil,-- //每一层可扫荡的最大关卡
	}
end

--获取通关奖励结算 
function ThirtyThreeData:getLayerResultParams()
	-- body
	return self._layerResultParams
end

--清空通关奖励结算
function ThirtyThreeData:setClearLayerResultParams()
	-- body
	self._layerResultParams = nil
end

---获取所有层的历史最高累计总星数
function ThirtyThreeData:getLayersHistoryTotalStars()
	-- body
	if(self._towerData == nil or self._towerData.layer_stars == nil)then return 0 end
	local layerStars = self._towerData.layer_stars
	local numTotal = 0
	for i=1,#layerStars do
		numTotal = numTotal + layerStars[i]
	end
	return numTotal
end

--获取指定层数的 章节总星数
function ThirtyThreeData:getLayerHistoryStars( layer )
	-- body
	local star = 0
	local layerStars = rawget(self._towerData, "layer_stars")
	if(layerStars ~= nil and layerStars[layer] ~= nil)then
		star = layer <= #layerStars and tonumber(layerStars[layer]) or 0
	end
	return star
end

function ThirtyThreeData:getTempExecuteType()
	-- body
	return self._tempExecuteType
end

function ThirtyThreeData:setTempExecuteType( typeValue )
	-- body
	self._tempExecuteType = typeValue
end

--获取关卡宝箱数据
function ThirtyThreeData:getStageBox( ... )
	-- body
	return self._towerData.stage_box
end

--清除关卡宝箱缓存
function ThirtyThreeData:setClearStageBox( ... )
	-- body
	self._towerData.stage_box = 0
end

--更新剩余开启次数
function ThirtyThreeData:setOpenCount( value )
	-- body
	self._towerData.open_count = value
end

--获取关卡宝箱开启次数
function ThirtyThreeData:getOpenCount( ... )
	-- body
	return self._towerData.open_count
end

-----------------------------------------------------------------------------------------------折扣商人相关数据接口
--------获取折扣商人商品数据
function ThirtyThreeData:getShopBuy( ... )
	-- body
	return self._towerData.shop_buy or {}
end

--判断折扣商人是否已经购买过
function ThirtyThreeData:hasShopBuyed( ... )
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
function ThirtyThreeData:setShopBuyed( id )
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
function ThirtyThreeData:isShopBuyOpen( ... )
	-- body
	return self._towerData.shop_buy ~= nil and #self._towerData.shop_buy > 0
end

------判断折扣商人中的商品是否已全部购买
function ThirtyThreeData:isShopGoodsAllBuyed( ... )
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
function ThirtyThreeData:setShopBuy( lists )
	-- body
	self._towerData.shop_buy = lists
end

-----------获取折扣商人中的随机商品ID
function ThirtyThreeData:getShopGoodsID( )
	-- body
	if(self._towerData.shop_buy ~= nil and #self._towerData.shop_buy > 0)then
		return self._towerData.shop_buy[1].Key
	end

	return 0
end

-----------------------------------------------------------------------------------------------折扣商人相关数据接口

function ThirtyThreeData:isShowRedPoint( ... )
	-- body
	local bool = false
	if self._towerData ~= nil and self._towerData.common_count ~= nil then
		bool = self._towerData.common_count.left_count > 0
	end
	return bool
end

--获取挑战次数相关信息
function ThirtyThreeData:getCommonCount( ... )
	-- body
	return self._towerData.common_count
end

--设置挑战次数相关信息
function ThirtyThreeData:setCommonCount( buffData )
	-- body
	self._towerData.common_count = buffData
end

--设置手动刷新剩余星数
function ThirtyThreeData:setLeaveStar(value)
	if(value == nil or type(value) ~= "number")then return end
	self._towerData.now_left_star = value
end

--获取剩余星数
function ThirtyThreeData:getLeaveStar( ... )
	-- body
	return self._towerData.now_left_star
end

--获取当前星数
function ThirtyThreeData:getNowStar( ... )
	-- body
	return self._towerData.now_star
end

--获取当前挑战的章节层数
function ThirtyThreeData:getNowLayer( )
	-- body
	return self._towerData.now_layer
end

--获取已通关的章节层数
function ThirtyThreeData:getPassedLayer( ... )
	-- body
	return self._towerData.layer
end

--获取当前关卡
function ThirtyThreeData:getNowStage( )
	-- body
	return self._towerData.now_stage
end

function ThirtyThreeData:getTowerData( ... )
	-- body
	return self._towerData
end

--获取选中的的buffs
function ThirtyThreeData:getSelectBuffs(  )
	-- body
	return self._towerData.select_buffs
end

--清除选中的buffs
function ThirtyThreeData:clearSelectBuffs( ... )
	-- body
	self._towerData.select_buffs = nil
end

--获取历史最高章节层数
function ThirtyThreeData:getMaxLayer( ... )
	-- body
	return self._towerData.max_layer
end

--获取历史最高关卡
function ThirtyThreeData:getMaxStage( ... )
	-- body
	return self._towerData.max_stage
end

--历史最高层免费次数是否用完
function ThirtyThreeData:isMaxLayerFree( ... )
	-- body
	return self._towerData.free
end

--设置选中的BUFFID 累加到buff加成列表中
function ThirtyThreeData:setAfterChoseBuff( buffId )
	-- body
	if(buffId == nil or type(buffId) ~= "number")then return end
	if(self._towerData.buffs == nil)then
		self._towerData.buffs = {}
	end
	table.insert(self._towerData.buffs,buffId)

	if(self._towerData.select_buffs ~= nil)then
		for i=1,#self._towerData.select_buffs do
			if(self._towerData.select_buffs[i].Key == buffId)then
				self._towerData.select_buffs[i].Value = 1
			end
		end
	end
end
--获取buff加成
function ThirtyThreeData:getAddedBuffs(  )
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
function ThirtyThreeData:resetTowerData( buffData )
	-- body
	if self._lastPassedLayer == -1 then
		self._lastPassedLayer = buffData.layer
	else
		if self._towerData ~= nil then
			self._lastPassedLayer = self._towerData.layer
		end
	end

	self:_initTowerData()

	if(buffData == nil)then return end

	self._towerData.layer = buffData.layer
	self._towerData.now_layer = buffData.now_layer
	self._towerData.now_stage = buffData.now_stage
	self._towerData.now_star = buffData.now_star
	self._towerData.now_left_star = buffData.now_left_star
	--self._towerData.select_buffs = rawget(buffData,"select_buffs") or nil
	--self._towerData.buffs = rawget(buffData,"buffs") or nil
	--self._towerData.shop_buy = buffData.shop_buy
	--self._towerData.common_count = buffData.common_count
	--self._towerData.open_count = buffData.open_count
	self._towerData.layer_stars = buffData.layer_stars
	self._towerData.stage_box = buffData.stage_box
	self._towerData.max_layer = buffData.max_layer --//历史通关最高层
	self._towerData.max_stage = buffData.max_stage 	--//历史通过最大关卡
	-- self._towerData.free = false
	-- self._towerData.perfect_stage = buffData.perfect_stage
	
	local list = buffData.pass_reward or {}
	self._towerData.pass_reward= list  --//每层通关奖励领取情况 0-> 未领取  1-> 已领取

	
end

--
function ThirtyThreeData:getPerfectStage( layer )
	-- body
	if(self._towerData == nil or self._towerData.perfect_stage == nil)then return 0 end
	local list = self._towerData.perfect_stage or {}
	if(layer <= #list)then
		return list[layer]
	end
	return 0
end

function ThirtyThreeData:getLastTime()
	return self._lastRequestTime
end

function ThirtyThreeData:_updateLastTime()
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
  --repeated IntMap select_buffs = 9;//玩家可选的buff id 不为空要弹出来 key 为buff id value 为0 和1 0没有为选过 1 被选过
  --required uint32 stage_box = 10;//当前关卡宝箱是否开启
  --required uint32 open_count = 11;//当前隐藏宝箱的开启次数

  --repeated uint32 layer_stars = 12; //每一层对应的历史最大星数
  --repeated uint32 perfect_stage = 13; //每一层可扫荡的最大关卡
  --repeated uint32 pass_reward = 14; //每层通关奖励领取情况 0-> 未领取  1-> 已领取
  //optional bool   free = 15; //最高层是否有免费次数  true->有免费次数 false代表没有免费次数
  required CommonCount common_count = 16;//次数
  --repeated IntMap shop_buy = 17;//商店是否购买 0 没有购买 1 已经购买
}
]]
function ThirtyThreeData:setAllData( buffData )
	self:_updateLastTime()
	-- body
	----这里要把结算数据重置掉，不然会出现问题
	----- 例如：打最后一个怪进入战斗场景，这时断线了弹了重连框，now_layer被重置为0了，
	-----但是结算没重置，这时进入闯关界面会找不到当前layer的数据 因为now_layer == 0
	self._layerResultParams = nil

	self:_initLayers()
	self:resetTowerData(buffData)

	if buffData ~= nil and buffData.common_count ~= nil then
		local leftCount = buffData.common_count.left_count or 0
		self:setLastCount(leftCount)
	end
end

--初始化所有关卡本地数据
function ThirtyThreeData:_initLayers( ... )
	-- body
	local layerList = {}
	local towerInfo = require("app.cfg.tower_info")
	-- local chapterInfo = require("app.cfg.tower_chapter_info")
	-- local len = chapterInfo.getLength()
	-- local len2 = towerInfo.getLength()
	-- for i=1,len do
	-- 	local layerInfo = chapterInfo.indexOf(i)
	-- 	local numLayer = layerInfo.id
	-- 	local tLayers = layerList["layer_"..tostring(numLayer)]
	-- 	if(tLayers == nil)then
	-- 		tLayers = {stages = {},totalStar = 0,layer = numLayer,icon = layerInfo.layer_icon,layerName = layerInfo.chongtian,layerCfg = layerInfo}
	-- 	end

	-- 	local totalStar = 0
	-- 	for j=1,len2 do
	-- 		local towerData = towerInfo.indexOf(j)
	-- 		if(towerData.layer == numLayer)then
	-- 			if(towerData.type == 1)then--有一个怪加三颗星星
	-- 				totalStar = totalStar + 3
	-- 			end
	-- 			tLayers.stages["stage_"..tostring(towerData.stage)] = towerData
	-- 		end
	-- 	end

	-- 	tLayers.totalStar = totalStar
	-- 	layerList["layer_"..tostring(numLayer)] = tLayers
	-- end

	-- self._clientLayers = layerList
	-- self._numTotalLayer = len
end

--获取总层数
function ThirtyThreeData:getNumTotalLayer( ... )
	-- body
	return self._numTotalLayer
end

--获取全部层数据
function ThirtyThreeData:getTotalLayers( ... )
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
function ThirtyThreeData:getLayerData( layer )
	-- body
	if(self._clientLayers == nil)then return nil end
	return self._clientLayers["layer_"..tostring(layer)]
end

--获取指定层的全部关卡列表
function ThirtyThreeData:getStagesByLayer( layer )
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

--判断指定层的章节是否通关
function ThirtyThreeData:isLayerClear( layer )
	-- body
	local maxPassedLayer = self:getPassedLayer()
	return layer <= maxPassedLayer
end

--获取当前挑战章节的 挑战进度
function ThirtyThreeData:getNowLayerProgress()
	-- body
	local nowLayer = self:getNowLayer()
	local nowStage = self:getNowStage()
	if(nowLayer == 0)then return 0,0 end
	local stagesList = self:getStagesByLayer(nowLayer) or {}
	return nowStage,#stagesList
end

--获取指定的关卡数据
function ThirtyThreeData:getStageData( layer,stage )
	-- body
	local layerData = self:getLayerData(layer)
	if(layerData == nil or layerData.stages == nil)then return nil end
	return layerData.stages["stage_"..tostring(stage)]
end

--挑战关卡后更新
function ThirtyThreeData:setAfterExecuteTower( buffData )
	-- body
	self:setClearLayerResultParams()
	self._towerData.stage_box = 0 
	self._towerData.select_buffs = nil
	self._towerData.open_count = 0
	self._executeTower = rawget(buffData, "tower")
	if self._executeTower ~= nil then
		self._towerData.pass_reward = self._executeTower.pass_reward
	end
	---------------
	local nowLayer = buffData.layer
	local addStar = rawget(buffData, "star") or 0
	local totalAward = rawget(buffData,"total_award")
	local isWin = true
	if(buffData.type == 1)then
		self._towerData.now_stage = buffData.stage
		isWin = buffData.battle_report.is_win
	end

	if(totalAward == nil)then
		if(isWin == false)then
			self._layerResultParams = {awards = {},layer = nowLayer,isWin = isWin}
		end
	else
		self._layerResultParams = {awards = totalAward,layer = nowLayer,isWin = isWin}
	end

	self._tempStage = buffData.stage
	self._towerData.now_star = self._towerData.now_star + addStar
	self._towerData.now_left_star = self._towerData.now_left_star + addStar

	if self._towerData.layer_stars == nil then
		self._towerData.layer_stars = {}
	end

	if nowLayer > 0 then
		local nowLayerStar = self._towerData.layer_stars[nowLayer] or 0
		if nowLayerStar < self._towerData.now_star then
			self._towerData.layer_stars[nowLayer] = self._towerData.now_star
		end
	end
	
	local buffs = rawget(buffData,"buffs")
	if(buffs ~= nil)then
		self._towerData.select_buffs = {}
		for i=1,#buffs do
			self._towerData.select_buffs[#self._towerData.select_buffs + 1] = {Key = buffs[i],Value = 0}
		end
	end

	self:setTempExecuteType(buffData.type)

end


function ThirtyThreeData:setAfterFastExecuteTower( buffData )
	-- body
	self:setClearLayerResultParams()
	self._towerData.stage_box = 0 
	self._towerData.select_buffs = nil
	self._towerData.open_count = 0


	-- required uint32 ret = 1;
	-- required uint32 layer = 2;//扫荡的层数
	-- optional uint32 stage = 3;//扫荡的关卡
	-- optional uint32 money = 4;  //奖励的白银
	-- optional uint32 tower_resource = 5;//奖励的玉石
	-- repeated Award  box_awards = 6;	 //关卡宝箱奖励
	-- optional uint32 buffs = 7; //buff关卡选择的九星buff
	-- repeated Award	total_award = 8; //累积奖励
	-- optional Tower	tower = 9; //通关显示

	local nowLayer = buffData.layer
	local nowStage = buffData.stage
	local totalAward = rawget(buffData,"total_award")
	local money = rawget(buffData,"total_award")
	local towerResource = rawget(buffData,"tower_resource")
	local buffs = rawget(buffData,"buffs")
	local tower = rawget(buffData,"tower")

	self._towerData.now_stage = nowStage
	if(money ~= nil or towerResource ~= nil)then
		self._towerData.now_star = self._towerData.now_star + 3
		self._towerData.now_left_star = self._towerData.now_left_star + 3
	elseif(buffs ~= nil)then
		self._towerData.select_buffs = {}
		for i=1,#buffs do
			self._towerData.select_buffs[#self._towerData.select_buffs + 1] = {Key = buffs[i],Value = 0}
		end
	end

	if self._towerData.layer_stars == nil then
		self._towerData.layer_stars = {}
	end

	if nowLayer > 0 then
		local nowLayerStar = self._towerData.layer_stars[nowLayer] or 0
		if nowLayerStar < self._towerData.now_star then
			self._towerData.layer_stars[nowLayer] = self._towerData.now_star
		end
	end

	if(tower ~= nil)then
		self._layerResultParams = {awards = totalAward,layer = nowLayer,isWin = true}
	end
	self._executeTower = tower

	self._tempStage = buffData.stage
end

function ThirtyThreeData:resetTowerAfterExecute( ... )
	-- body
	if(self._executeTower ~= nil)then
		self:resetTowerData(self._executeTower)
		self._executeTower = nil
		self:setClearLayerResultParams()
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MT_RESET_TOWER_AFTER_EXECUTE,nil,false)
	end
end

--判断通关宝箱是否已领取
function ThirtyThreeData:getLayerAwardsFlag( layer )
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
--
function ThirtyThreeData:_setLayerAwardFlag( layer,flag )
	-- body
	if(self._towerData == nil)then return end
	if(self._towerData.pass_reward == nil)then
		self._towerData.pass_reward = {}
	end
	self._towerData.pass_reward[layer] = flag
end

-- 
function ThirtyThreeData:setLayerAwardGeted( layer )
	-- body
	self:_setLayerAwardFlag(layer,1)

	if self._executeTower ~= nil and self._executeTower.pass_reward ~= nil then
		local list = self._executeTower.pass_reward
		for i=1,#list do
			if layer == i then
				list[i] = 1
			end
		end
	end
end

--关卡推进动画需要
function ThirtyThreeData:setToTempStage( ... )
	-- body
	if(self._tempStage ~= 0)then
		self._tempStage = 0
		self._towerData.now_stage = self._towerData.now_stage + 1
		self:clearSelectBuffs()
		self:setClearStageBox()
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MT_SETTO_TMEP_STAGE,nil,false)
	end
end

----------判断指定层的指定关卡是否已经首通
function ThirtyThreeData:hadShoutong( layer,stage )
	-- body
	local maxLayer = self:getMaxLayer()
	local maxStage = self:getMaxStage()

	local hadShoutong = false
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

return ThirtyThreeData