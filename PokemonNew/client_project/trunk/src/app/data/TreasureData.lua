
--[===========[
    TreasureData
    宝物模块数据处理 
    用于宝物模块数据的增删改查
    kaka
]===========]

local TreasureData = class("TreasureData")

-- local TreasureInfo = require("app.cfg.treasure_info")
local TreasureFragmentInfo = require("app.cfg.treasure_fragment_info")
local TreasureCommon = require("app.scenes.treasure.TreasureCommon")
-- local TreasureLvupInfo = require("app.cfg.treasure_lvup_info")
local TreasurePurifyInfo = require("app.cfg.treasure_purify_info")
local ItemConst = require("app.const.ItemConst")

TreasureData.KEY_PREV="treasure_"

function TreasureData:ctor( ... )
	-- body
	self._treasureList = {}			--宝物列表
end

--[===========[
    缓存服务器端宝物数据
    参数：
    buffData为服务器端数据
]===========]
function TreasureData:setTreasureListData(buffData)

	if type(buffData) ~= "table" then 
		return 
	end

	self._treasureList = {}			--宝物列表
	
	local data = buffData.treasures or {}

	for i=1, #data do
		self:_setTreasureItemData(data[i])
	end
end

--仅当有宝物上阵或者卸下时才更新
function TreasureData:updateTreasurePos( tid,pos )
	-- body
	local tData = self:getTreasureByID(tid)

	if tData ~= nil then
		tData.pos = pos
	end

end

--更新缓存数据，添加阵位信息
--不用了 以免阵容界面检查红点时每次都执行 影响性能
function TreasureData:updateTreasureListData()

	-- for k,v in pairs(self._treasureList) do
	-- 	local pos = G_Me.teamData:getKnightPosByTreasureID(v.id)
	-- 	v.pos = pos
	-- end
end

--服务器信息打包  --这里没有缓存配置表信息
function TreasureData:_setTreasureItemData( serverValue )

	if type(serverValue)~="table" then 
		return 
	end

	local treasure = {}
	treasure.id = serverValue.id
	treasure.base_id = serverValue.base_id
	treasure.user_id = rawget(serverValue, "user_id") and serverValue.user_id or G_Me.userData.id -- 有什么用
	treasure.level = serverValue.level
	treasure.exp = serverValue.exp
	treasure.refine_level = serverValue.refine_level

	local key = TreasureData.KEY_PREV..tostring(treasure.id)

	--仅当第一次初始化需要设置pos  后面更在这设置，影响性能
	if not self._treasureList[key] then
		treasure.pos = rawget(serverValue, "pos") and serverValue.pos or 0
	else
		treasure.pos = self._treasureList[key].pos
	end

	local cfgData = TreasureInfo.get(treasure.base_id)

	assert(cfgData, string.format("Could not find the treasure_info with baseId: %s", tostring(baseId)))


	local total_exp = cfgData.treasure_exp  --基础经验

	--经验累加 策划这样配表的 服了。。。
	for j=1, treasure.level-1 do
		local treasureLvupInfo = TreasureLvupInfo.get(j, cfgData.color)
		assert(treasureLvupInfo, string.format("treasure_lvup_info data error level: %s, color: %s", 
			tostring(j),tostring(cfgData.color)))

		total_exp = total_exp + treasureLvupInfo.exp
	end

	treasure.total_exp = total_exp + treasure.exp  --算出总经验，用于强化和其他列表排序用

	self._treasureList[key] = treasure

end

--[===========[
    获取宝物信息
    参数：
    	宝物id
    如果有则返回宝物信息，如果没有则返回nil
]===========]
function TreasureData:getTreasureByID( id )

	if table.nums(self._treasureList) == 0 or type(id) ~= "number" then 
		return nil
	end

	return self._treasureList[TreasureData.KEY_PREV..tostring(id)]
end

--[===========[
    获取所有宝物信息
	参数：
		sort 是否需要排序
    如果有则返回宝物数据列表，如果没有则返回{}
]===========]
function TreasureData:getTreasureList( sort )

	-- body
	self:updateTreasureListData()

	local list = {}

	--按数组存放
	for k,v in pairs(self._treasureList) do
		table.insert(list,v)
	end

	--默认按一定规则排序
	if sort then
		table.sort(list,handler(self,  self._defaultSortFunc))
	end

	return list
end

--[===========[
    获取同名宝物数量
    base_id:宝物配置id
]===========]
function TreasureData:getSameTreasureNumBySysId( base_id )

	if type(base_id) ~= "number" then return 0 end
	
	local num = 0

	for k,v in pairs(self._treasureList) do
		if v.base_id == base_id then
			num = num + 1
		end
	end

	return num
end


--判断是否拥有某宝物  treasureSysId 为 base_id
function TreasureData:isTreasureGeted(treasureSysId)

	for k,v in pairs(self._treasureList) do 
		if treasureSysId == v.base_id then
			return true
		end
	end

	return false

end

--是否有奖励可以领取
function TreasureData:checkCanGetAward()
	
	return G_Me.achievementData:hasAnyAwardCanGet(2) > 0

end

--[===========[
    获取强化可自动吞噬的宝物列表
    参数：
    	exceptTreasureId -- 需要排除的宝物id
    	auto 是否为自动添加
    	noSort 是否自动排序
    返回值：
    	宝物列表和对应总经验
]===========]
function TreasureData:getTreasureListForEnhanceFood(exceptTreasureId, auto, noSort)
	-- body
	local list = {}

	if type(exceptTreasureId) ~= "number" then return list end

	local autoAdd = auto or false 

	local treasureList = self:getTreasureList()
	
	local totalExp = 0

	for i=1, #treasureList do
		local item = treasureList[i]
		local cfgData = TreasureInfo.get(item.base_id) 
		
		local pos = G_Me.teamData:getKnightPosByTreasureID(item.id)   --获取宝物装备位

		--未装备 且排除
		if pos == 0 and item.id ~= exceptTreasureId then

			--经验类或精炼等级为0
			if cfgData.treasure_type == TreasureCommon.TREASURE_TYPE_EXP or 
				( (not autoAdd and item.refine_level == 0) 
					--自动添加排除紫色以上品质
					or (autoAdd==true and  item.refine_level == 0 and cfgData.color < 4))  then
				list[#list+1] = item

        		totalExp = totalExp + item.total_exp

			end
		end
	end

	if not noSort then
		table.sort(list,function(a,b)
			local cfgDataA = TreasureInfo.get(a.base_id)
			local cfgDataB = TreasureInfo.get(b.base_id)

			--经验由低到高
			if a.total_exp ~= b.total_exp then
				return a.total_exp < b.total_exp
			elseif cfgDataA.treasure_type ~= cfgDataB.treasure_type then
				--经验类的在上
				if cfgDataA.treasure_type == TreasureCommon.TREASURE_TYPE_EXP then
					return true
				elseif cfgDataB.treasure_type == TreasureCommon.TREASURE_TYPE_EXP then
					return false
				else
					--攻击类型在上
					return cfgDataA.treasure_type < cfgDataB.treasure_type
				end
			else
				--低品质在上
				return cfgDataA.color > cfgDataB.color
			end
		end)
	end

	return list, totalExp
end

--[===========[
    获取可用作精炼素材的宝物列表
    参数：
    	treasure 同名素材
]===========]
function TreasureData:getTreasureListForRefineFood(treasure)
	
	local list = {}

	if type(treasure) ~= "table" then return list end

	-- body

	local treasureList = self:getTreasureList()

	for i=1, #treasureList do
		local item = treasureList[i]
		local pos = G_Me.teamData:getKnightPosByTreasureID(item.id)   --获取宝物装备位
		
		--排除自身
		if item.id ~= treasure.id then
			--精炼等级=0 强化等级<=5的同名宝物
			if item.base_id == treasure.base_id and pos == 0 
				and item.level <= 5 and item.refine_level == 0 then
				list[#list+1] = item
			end
		end
	end

	--不用排序
	-- table.sort(list,function(a,b)
	
	-- 	--根据强化等级 由低到高
	-- 	if a.level ~= b.level then
	-- 		return a.level < b.level
	-- 	else
	-- 		return a.id < b.id
	-- 	end
	-- end)

	return list
end


--[===========[
    根据宝物类型获取相应的宝物列表
    参数：
    	treasure_type为宝物类型 1 进攻 2 防御 
    	sort 是否排序，ture则默认排序
   	有则返回宝物信息，如果没有则返回nil
]===========]
function TreasureData:getTreasureListByType(treasure_type) --, sort)
	self:updateTreasureListData()

	local list = {}

	for k,v in pairs(self._treasureList) do
		local cfgInfo = TreasureInfo.get(v.base_id)

		if cfgInfo and cfgInfo.treasure_type == treasure_type then
			table.insert(list,v)
		end
	end

	-- if sort then
	-- 	table.sort(list,handler(self,  self._defaultSortFunc))
	-- end
	
	return list

end

--默认排序方法
function TreasureData:_defaultSortFunc(a, b)

	local treasureA = TreasureInfo.get(a.base_id)
	local treasureB = TreasureInfo.get(b.base_id)
	local posA = a.pos -- 宝物A的装备位置
	local posB = b.pos -- 宝物A的装备位置
	local typeA = treasureA.treasure_type
	local typeB = treasureB.treasure_type


	--先比较装备位 先上阵的在前
	if posA ~= posB and posA > 0 and posB > 0 then
		return posA < posB
	--装备了的在前
	elseif posA ~= posB then
		return posA > posB
	--统一装备位攻击在前
	elseif posA == posB and posA > 0 then
		return typeA < typeB
	--攻击武器在前
	elseif typeA ~= typeB and typeA ~= TreasureCommon.TREASURE_TYPE_EXP and 
		typeB ~= TreasureCommon.TREASURE_TYPE_EXP then

			if treasureA.color ~= treasureB.color then
				--print(treasureA.name.."  "..treasureB.name)
				return treasureA.color > treasureB.color
			end
	elseif typeA ~= typeB then
		return typeA < typeB
	end

	--品质高前面
	if treasureA.color ~= treasureB.color then
		return treasureA.color > treasureB.color
	--强化等级高在前
	elseif a.level ~= b.level then
		return a.level > b.level
	--精炼等级高在前
	elseif a.refine_level ~= b.refine_level then
		return a.refine_level > b.refine_level
	else
		return a.base_id > b.base_id
	end
end

--[===========[
    根据宝物位置 获取宝物状态
    参数：
    	slot为槽位编号
		slot  1 进攻 2 防御 
	返回：
		0 没有指定类型的宝物  
		1 有指定类型宝物但是不可穿戴（已穿戴在其他武将）  
		2 有可穿戴宝物
]===========]
function TreasureData:getTreasureStatusBySlot( slot )

	local info = require("app.cfg.wear_require_info").get(2,slot)

	assert(info,"Could not find the wear_require_info with type: 2 (wear treasure) and slot"..tostring(slot))
	
	local data = self:getTreasureListByType(info.sub_type)

	if #data < 1 then
		return 0
	end

	data = self:getTreasureListByTypeUnWear(info.sub_type)

	if #data < 1 then
		return 1
	end

	return 2
end

--[===========[
    获取未穿戴宝物列表
    参数：
    	sortFunc为排序算法，没有则默认排序
]===========]
function TreasureData:getTreasureListUnWear()--sortFunc)
	-- body
	self:updateTreasureListData()

	local list = {}

	for k,v in pairs(self._treasureList) do
		if v.pos < 1 then
			table.insert(list,v)
		end
	end
	--table.sort(list,type(sortFunc) == "function" and sortFunc or handler(self,  self._defaultSortFunc))
	return list

end

--[===========[
    获取可用于重生的宝物列表
]===========]
function TreasureData:getTreasureListForReborn()
	-- body
	self:updateTreasureListData()

	local list = {}

	for k,v in pairs(self._treasureList) do

		--未装备且有养成过
		if v.pos < 1 and (v.refine_level > 0 or v.level > 1) then
			table.insert(list,v)
		end
	end
	
	return list

end

--[===========[
    获取未穿戴宝物，并且比当前装备宝物更厉害的宝物列表，具体红点出现规则：
    	1.该宝物激活当前神将缘分时，背包中有更高品质并且激活该神将缘分的宝物
		2.该宝物不激活当前神将缘分时，背包中有更高品质的宝物或者有激活缘分的宝物
    参数:
		treaureId：当前宝物id，用作比较
		knightId：神将id，用于判断宝物是否激活缘分
    	sortFunc为排序算法，没有则默认排序 可选
]===========]
function TreasureData:getBetterTreasureListUnWear(treasureId, knightId) --, sortFunc)

	if type(treasureId) ~= "number" then return {} end

	--目标宝物数据
	local tTreasure = self:getTreasureByID(treasureId)
	assert(type(tTreasure) == "table", "TreasureData:tTreasure data error id = "..treasureId)

	--目标宝物配置数据
	local tCfgData = TreasureInfo.get(tTreasure.base_id)
	assert(type(tCfgData) == "table", "TreasureData:tCfgData data error base id = "..tTreasure.base_id)

	knightId = knightId or 0

	--宝物与神将缘分
	local tAssNum = G_Me.teamData:getActiveAssociationNums(knightId, tCfgData.id, 3)

	-- body
	self:updateTreasureListData()

	--目标宝物类型
	local targetType = tCfgData.treasure_type

	local list = {}

	--TODO 
	for k,v in pairs(self._treasureList) do
		local cfgInfo = TreasureInfo.get(v.base_id)
		local need = false
		--类型相同且未装备
		if v.pos < 1 and cfgInfo.treasure_type == targetType then
			local assNum = G_Me.teamData:getActiveAssociationNums(knightId, cfgInfo.id, 3)

			--print("aaaaaaaaaaa tAssNum = "..tAssNum.."  num="..assNum.."   name="..cfgInfo.name)
			--理论上只会激活一条缘分
			if tAssNum > 0 and assNum >0 then
				--品质高的
				if cfgInfo.color > tCfgData.color then
					need = true
				--TODO 是否要比较高品质的宝物可能精炼到的最高等级与当前比较
				--品质相等情况下
				elseif cfgInfo.color == tCfgData.color then
					if tTreasure.level < v.level then 
						need = true
					--精炼等级更高即可
					elseif tTreasure.refine_level < v.refine_level then
						need = true
					end
				--品质低一级的橙宝
				-- elseif cfgInfo.color >= 5 and (cfgInfo.color+1 == tCfgData.color) then
				-- 	--TODO 是否要比较高品质的宝物可能精炼到的最高等级与当前比较
				end
			elseif tAssNum == 0 then
				if (assNum == 0 and cfgInfo.color > tCfgData.color) or assNum > 0 then
					need = true 
				end
			end

			if need then 
				table.insert(list,v)
			end

		end
	end

	--没必要排序
	--table.sort(list,type(sortFunc) == "function" and sortFunc or handler(self,  self._defaultSortFunc))
	
	return list

end


--[===========[
    根据宝物类型获取相应的未穿戴宝物
    参数：
    	treasure_type为宝物类型 1为攻击 2为防御
    	sortFunc为排序算法，没有则默认排序
]===========]
function TreasureData:getTreasureListByTypeUnWear( treasure_type) -- ,noSort)
	-- body
	self:updateTreasureListData()

	local list = {}

	for k,v in pairs(self._treasureList) do
		local cfgInfo = TreasureInfo.get(v.base_id)

		if cfgInfo and cfgInfo.treasure_type == treasure_type and v.pos < 1 then
			table.insert(list,v)
		end
	end

	-- if noSort ~= true then
	-- 	table.sort(list,handler(self,self._defaultSortFunc))
	-- end

	return list
end

--[===========[
    获取可合成的宝物列表和宝物ID列表
]===========]
function TreasureData:getTreasureComposeList()
    local composeList = {}
    local composeIdList = {}

    --碎片列表
    local list = G_Me.treasureFragmentData:getFragmentList()

    for i,v in ipairs(list) do
        local fragmentInfo = TreasureFragmentInfo.get(v.id)
        assert(fragmentInfo,"treasure_fragment_info can't find id = "..tostring(v.id))
        local treasure = TreasureInfo.get(fragmentInfo.treasure_id)
        assert(treasure,"treasure_info can't find id = "..tostring(fragmentInfo.treasure_id))
        if composeList[treasure.id] == nil then
            composeList[treasure.id] = treasure
            composeIdList[#composeIdList+1] = treasure.id
        end
    end

    --再遍历长期显示的那几个碎片是否已经存在了
    for i=1,TreasureInfo.getLength() do
        local treasure = TreasureInfo.indexOf(i)

        --避免重复记录
        if treasure and treasure.is_always == 1 and composeList[treasure.id] == nil then
            composeList[treasure.id] = treasure
            composeIdList[#composeIdList+1] = treasure.id
        end 
    end
    
    --[[
        第1优先级：经验宝物          
                    
        第2优先级：宝物品质          
              红色>橙色>紫色>蓝色>绿色>白色       
              攻击>防御 
        第3优先级：攻击>防御         

        type:1 攻击型
        type:2 防御型
        type:3 经验
    ]]
    local sortFunc = function(a,b)
        
        local treasureA = TreasureInfo.get(a)
        local treasureB = TreasureInfo.get(b)
        if treasureA.treasure_type ~=  treasureB.treasure_type then
            if treasureA.treasure_type == TreasureCommon.TREASURE_TYPE_EXP 
            	or treasureB.treasure_type == TreasureCommon.TREASURE_TYPE_EXP then
                return treasureA.treasure_type > treasureB.treasure_type
            end
        end
        if treasureA.color ~= treasureB.color then
            return treasureA.color > treasureB.color
        end
        
        --防御型优先级<攻击型
        if treasureA.treasure_type ~= treasureB.treasure_type then
            return treasureA.treasure_type < treasureB.treasure_type
        end

        return treasureA.id < treasureB.id
    end

    table.sort(composeIdList,sortFunc)

    return composeList,composeIdList
end

--判断宝物是否可以精炼
function TreasureData:isRefineAvailabe( treasure )

	--assert(type(treasure) == "table", "TreasureData:isRefineAvailabe data error")

	if type(treasure) ~= "table" then return false end


	if not G_Responder.funcIsOpened(G_FunctionConst.FUNC_TREASURE_REFINE) then
		return false
	end

	--精炼满级
	if self:isRefineLimited(treasure, true) then
		return false
	end

	if self:isRefineBreaked(treasure, true) then
		return false
	end

	local cfgData = TreasureInfo.get(treasure.base_id)

	assert(type(cfgData) == "table", "TreasureData:cfgData data error base id = "..treasure.base_id)


	local purifyCostData = TreasurePurifyInfo.get(treasure.refine_level, cfgData.color)

	if not purifyCostData then return false end


	--先判断精炼石够不够
	local itemNum = G_Me.propsData:getPropItemNum(ItemConst.TREASURE_REFINE_ITEM_ID)
	if itemNum < purifyCostData.cost_size_2 then
		return false
	end

	--同名素材够不够
	if purifyCostData.cost_card > 0 then
		local foodList = self:getTreasureListForRefineFood(treasure)
		if #foodList < purifyCostData.cost_card then
			return false
		end
	end

	local costMoney = purifyCostData.cost_size_1
	--钱够不够
	if G_Me.userData.money < costMoney then
		return false
	end

    return true
   
end

--获取宝物强化吞噬消耗的银币  本来是1:1的关系，策划增加了一个参数~~~~~~~
function TreasureData:getCostForEnhanceFood( totalExp )
	assert(type(totalExp) == "number", "TreasureData:getCostForEnhanceFood totalExp error")

	local parameterInfo = require("app.cfg.parameter_info")
    local enhance_param = parameterInfo.get(173)
    assert(enhance_param, "Could not find data.id : "..tostring(173))
    local rate = enhance_param and tonumber(enhance_param.content) or 1000

    return math.floor(totalExp * rate / 1000)
end


--判断强化是否超过等级上限
function TreasureData:isEnhanceLimited( treasure, noTip )

	if type(treasure) ~= "table" then return true end

	-- assert(type(treasure) == "table", "TreasureData:isEnhanceLimited data error")

	if treasure.level >= self:getMaxEnhanceLevel(treasure) then
		if not noTip then
        	G_Popup.tip(G_LangScrap.get("equip_level_over_limit"))
        end
        return true
    else
    	return false
    end
end

--判断强化是否被等级卡住
function TreasureData:isEnhanceBreaked( treasure, noTip )

	if type(treasure) ~= "table" then return true end

	-- assert(type(treasure) == "table", "TreasureData:isEnhanceBreaked data error")

	local maxFosterLevel, needUserLevel, errorTips = G_Me.userData:getUserMaxFosterLevel(4)

	--print("eeeeeeeeeeeeeeeeeeeeTreasureData level="..treasure.level.."  maxFosterLevel="..maxFosterLevel..
	--	"    needUserLevel="..needUserLevel)

	if treasure.level >= maxFosterLevel and G_Me.userData.level < needUserLevel then
		if not noTip then
        	G_Popup.tip(errorTips) --G_LangScrap.get("common_text_role_open",{level=needUserLevel}))
        end
        return true
    else
    	return false
    end
end

--判断是否超过精炼上限
function TreasureData:isRefineLimited( treasure, noTip )

	if type(treasure) ~= "table" then return true end

	-- assert(type(treasure) == "table", "TreasureData:isRefineLimited data error")

	if treasure.refine_level >= self:getMaxRefineLevel(treasure) then
		if not noTip then
        	G_Popup.tip(G_LangScrap.get("equip_refine_over_limit"))
        end
        return true
    else
    	return false
    end
end

--判断精炼是否被等级卡住
function TreasureData:isRefineBreaked( treasure, noTip )

	if type(treasure) ~= "table" then return true end

	-- assert(type(treasure) == "table", "treasure:isRefineBreaked data error")

	local maxFosterLevel, needUserLevel, errorTips = G_Me.userData:getUserMaxFosterLevel(5)

	--print("eeeeeeeeeeeeeeeeeeTreasureData refine_level="..treasure.refine_level.."  maxFosterLevel="..maxFosterLevel..
	--	"    needUserLevel="..needUserLevel)

	if treasure.refine_level >= maxFosterLevel and G_Me.userData.level < needUserLevel then
		if not noTip then
        	G_Popup.tip(errorTips) --G_LangScrap.get("common_text_role_open",{level=needUserLevel}))
        end
        return true
    else
    	return false
    end
end

--最大强化等级
function TreasureData:getMaxEnhanceLevel(treasure)
	local basic_info = require("app.cfg.basic_figure_info")
    local enhance_param = basic_info.get(8)
	return enhance_param and tonumber(enhance_param.max_limit) or 80
end


--获取下一个强化等级
function TreasureData:getNextEnhanceLevel(treasure)
	
	local maxEnhanceLevel = self:getMaxEnhanceLevel()

	if type(treasure) ~= "table" then return maxEnhanceLevel end

	-- assert(type(treasure) == "table", "TreasureData:getNextEnhanceLevel data error")
    return math.min( treasure.level + 1 ,  maxEnhanceLevel ) 
end

--获得最大精炼等级
function TreasureData:getMaxRefineLevel(treasure)
	
    local basic_info = require("app.cfg.basic_figure_info")
    local refine_param = basic_info.get(9)
    return refine_param and tonumber(refine_param.max_limit) or 20
end


--获得当前等级段强化需要的经验
function TreasureData:getLeftEnhanceExp(treasure)
	-- assert(type(treasure) == "table", "TreasureData:getLeftEnhanceExp data error")
	if type(treasure) ~= "table" then return 0 end

    local needExp = self:getNeedEnhanceExp(treasure)

    return needExp>treasure.exp and (needExp-treasure.exp) or 0 
end

--获得当前等级段强化经验
function TreasureData:getNeedEnhanceExp(treasure)

	if type(treasure) ~= "table" then return 0 end

	local cfgData = TreasureInfo.get(treasure.base_id)

	assert(type(cfgData) == "table", "TreasureData:cfgData data error base id = "..treasure.base_id)

	local treasureLvupInfo = TreasureLvupInfo.get(treasure.level, cfgData.color)
	assert(treasureLvupInfo, string.format("treasure_lvup_info data error level: %s, color: %s", 
		tostring(treasure.level),tostring(cfgData.color)))

    return treasureLvupInfo.exp
end

--获取下一个精炼等级
function TreasureData:getNextRefineLevel(treasure)
	-- assert(type(treasure) == "table", "TreasureData:getNextRefineLevel data error")
	local maxRefineLevel = self:getMaxRefineLevel()

	if type(treasure) ~= "table" then return maxRefineLevel end

    return math.min( treasure.refine_level + 1 ,  maxRefineLevel )
end


----------------------宝物 增 删 改
function TreasureData:insertTreasures( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		self:_setTreasureItemData(value[i])
	end
end

function TreasureData:deleteTreasures( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		local id = value[i]
		self._treasureList[TreasureData.KEY_PREV..tostring(id)] = nil
	end
end

function TreasureData:updateTreasures( value )
	-- body
	if type(value)~="table" then return end

	for i=1, #value do
		self:_setTreasureItemData(value[i])
	end
end


return TreasureData