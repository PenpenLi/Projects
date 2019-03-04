--
-- Author: YouName
-- Date: 2015-10-28 21:48:29
--
--[[
	随机商店数据
]]
local ShopCommonRandomData=class("ShopCommonRandomData")

function ShopCommonRandomData:ctor( ... )
	-- body
	-- dump("ShopCommonRandomData:ctor!!!!!!!!!!!!!!")
	self._shopDataList = {
		-- ["key_"..tostring(shopId)] = {
		-- ShopUnit,
		-- },
		-- ["key_"..tostring(shopId)] = {
		-- ShopUnit
		-- }
	}
end

--创建商店物品数据单元
function ShopCommonRandomData:_createGoodsUnit()
	return {randomCfg = nil,goodsId = 0,buyCount = 0}
end

--创建商店数据单元
function ShopCommonRandomData:_createShopUnit( ... )
	-- body
	return {bornTime = 0,todayManualCount = 0,forever = true,goods = nil,createdStamp = 0}
end
-- //随机商品购买信息
-- message RandomGoodsBuyInfo {
-- 	required uint32 goods_id = 1; //商店商品id
-- 	required uint32 buy_count = 2; //已购买数量
-- }

-- //随机商店信息
-- message RandomShopInfo {
-- 	required uint32 born_time = 1;  //生成时间
-- 	required uint32 today_manual_count = 2; //今天手动刷新累积次数
-- 	required bool forever = 3; //是否永久存在
-- 	repeated RandomGoodsBuyInfo goods = 4; //刷新出的商品
-- }

--组织指定shop_id的商店数据
function ShopCommonRandomData:setShopData( shopId,randomShopInfo )
	--dump(randomShopInfo)
	self._shopDataList["key_"..tostring(shopId)] = {}
	local goods = randomShopInfo.goods or {}
	local goodsList = {}
	for i=1,#goods do
		local goodsData = self:_createGoodsUnit()
		local goodsId = goods[i].goods_id
		local buyCount = goods[i].buy_count
		local cfg = require("app.cfg.shop_score_info").get(goodsId)
		if cfg == nil then
			return
		end
		--assert(cfg,"shop_score_info can't find id = "..tostring(goodsId))

		goodsData["fixedCfg"] = cfg
		goodsData["goodsId"] = goodsId
		goodsData["buyCount"] = buyCount
		goodsData["serverIndex"] = i
		goodsList["key_"..tostring(goodsId)] = goodsData
	end

	local shopData = self:_createShopUnit()
	shopData["createdStamp"] = G_ServerTime:getTime()
	shopData["bornTime"] = randomShopInfo.born_time
	shopData["todayManualCount"] = randomShopInfo.today_manual_count
	shopData["forever"] = randomShopInfo.forever
	shopData["freeRefreshNum"] = randomShopInfo.free_refresh_num
	shopData["refreshTime"] = randomShopInfo.refresh_time
	shopData["goods"] = goodsList

	if randomShopInfo.free_refresh_num == 0 and G_Me.shopCommonData.redMap[shopId] then -- 红点置空
		dump("randomShopInfo.free_refresh_num == 0 and G_Me.shopCommonData.redMap[shopId] then -- 红点置空!!!!!!!!!!!!!!!!!!!")
		G_Me.redPointData:setShopShowRed(G_Me.shopCommonData.redMap[shopId],false)
	end

	--dump(shopData)
	self._shopDataList["key_"..tostring(shopId)] = shopData
	dump(shopData["refreshTime"])
	dump(shopId)
	--dump(self._shopDataList)
end

--获取上一次请求商店数据的时间戳
function ShopCommonRandomData:isShopDataDirty( shopId )
	-- body
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if(shopData ~= nil)then
		local lastStamp = shopData["createdStamp"]
		local nowStamp = G_ServerTime:getTime()
	end
	return true
end

--商店数据是否已经创建
function ShopCommonRandomData:isShopCreated( shopId )
	-- body
	return self._shopDataList["key_"..tostring(shopId)] ~= nil
end

--获取商品数据列表
function ShopCommonRandomData:getGoodsDataList( shopId,tab )
	-- body
	local goodsList = self._shopDataList["key_"..tostring(shopId)]
	local list = {}
	if (goodsList ~= nil) and goodsList.goods then
		for k,v in pairs(goodsList.goods) do
			list[#list+1] = v
		end
	end
	table.sort(list,function(a,b)
		if a.fixedCfg.arrange ~= b.fixedCfg.arrange then
			return a.fixedCfg.arrange < b.fixedCfg.arrange
		end

		if a.serverIndex ~= b.serverIndex then
			return a.serverIndex < b.serverIndex
		end
	end)
	return list
end

--获取单个商品的数据信息
function ShopCommonRandomData:getGoodsData( shopId,goodsId )
	-- body
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if(shopData == nil or shopData.goods == nil)then return nil end
	return shopData.goods["key_"..tostring(goodsId)]
end

--更新商店物品数据
function ShopCommonRandomData:updateGoodsData( shopId,goodsId,buyCount )
	-- body
	local goodsData = self:getGoodsData(shopId,goodsId)
	if(goodsData ~= nil)then
		goodsData.buyCount = buyCount
	end
end

--获取指定商店的刷新次数
function ShopCommonRandomData:getRefreshCount(shopId)
	local shopData = nil
	local count = 0

	if(self._shopDataList == nil)then
		shopData = nil
	else
		shopData = self._shopDataList["key_"..tostring(shopId)]
	end	

	if(shopData ~= nil)then
		count = shopData["todayManualCount"] or 0
	else
		count = 0
	end

	return count
end

--获取指定商店的剩余免费刷新次数
function ShopCommonRandomData:getFreeRefreshLeft(shopId)
	--dump(self._shopDataList)
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if shopData == nil or shopData["freeRefreshNum"] == nil then return 0 end -- 安全判断
	return shopData["freeRefreshNum"]
end

function ShopCommonRandomData:setFreeRefreshLeft(shopId,freeRefreshNum)
	--dump(self._shopDataList)
	local shopData = self._shopDataList["key_"..tostring(shopId)]

	local keys = ""
	for k,v in pairs(self._shopDataList) do
		keys = keys .. "_" .. k
	end
	print("setFreeRefreshLeft::",keys)
	if shopData == nil then return end
	assert(shopData,"ShopCommonRandomData cannot find shopId " .. shopId .. ",keys:" .. keys .. 
		",requestShopId:" .. G_Me.shopCommonData._requestShopId)
	shopData["freeRefreshNum"] = freeRefreshNum
end

--获取指定商店的免费刷新cd
function ShopCommonRandomData:getNextFreeRefreshTime(shopId)
	--dump(self._shopDataList)
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if shopData == nil then return 0 end -- 安全判断
	--dump(shopData["refreshTime"])
	return shopData["refreshTime"]
end

function ShopCommonRandomData:setNextFreeRefreshTime(shopId,refreshTime)
	--dump(self._shopDataList)
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if shopData == nil then return end -- 安全判断
	shopData["refreshTime"] = refreshTime
end

--获取指定商店的剩余免费刷新次数
function ShopCommonRandomData:getRefreshCount(shopId)
	--dump(self._shopDataList)
	local shopData = self._shopDataList["key_"..tostring(shopId)]
	if shopData == nil then return 0 end -- 安全判断
	return shopData["todayManualCount"]
end

--根据shopId ,goodsId 获取 物品的可购买总数 ，剩余可购买次数
function ShopCommonRandomData:getGoodsCount( shopId,goodsId )
	-- body
	local goodsData = self:getGoodsData(shopId,goodsId)
	if(goodsData == nil)then
		return 0,0
	end
	local totalCount,leaveCount = 0,0

	-- if(goodsData["fixedCfg"].num_ban_type == 0)then
	-- 	totalCount,leaveCount = 999,999
	-- else
		local userVipLevel = G_Me.vipData:getVipLevel()
		local vipCount = goodsData["fixedCfg"]["vip"..tostring(userVipLevel).."_num"]
		totalCount = vipCount
		leaveCount = vipCount - goodsData["buyCount"]
	--end
	return totalCount,leaveCount
end

return ShopCommonRandomData