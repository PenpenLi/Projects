--
-- Author: YouName
-- Date: 2015-11-12 14:55:08
--
require("framework.cc.utils.bit")
local TeamData=class("TeamData")

local KNIGHT_KEY = "knight_"--id key 
local POS_KEY = "pos_"--123456站位
local SLOT_KEY = "slot_"-- slot 对应装备 宝石 宝物的 id
local FLAG_KEY = "flag_"-- flag 1=装备, 2=宝物, 3=宝石, 4=星宿

-- local team_target_info = require("app.cfg.team_target_info")--额外属性加成
local EquipCommon = require("app.scenes.equip.EquipCommon")
local bookwar_talent_info = require("app.cfg.bookwar_talent_info")
local CampBuffInfo = require("app.cfg.camp_buff_info")
local hero_token_info = require("app.cfg.hero_token_info")
local exclusive_info = require("app.cfg.exclusive_info")
local exclusive_star_info = require("app.cfg.exclusive_star_info")
local exclusive_skill_info = require("app.cfg.exclusive_skill_info")
local Parameter_info = require("app.cfg.parameter_info")
local knight_star_talent_info = require("app.cfg.knight_star_talent_info")
local jobchange_info = require("app.cfg.jobchange_info")
local skill_talent_info = require("app.cfg.skill_talent_info")
local jobchange_talent_info = require("app.cfg.jobchange_talent_info")
local equipment_star_info = require("app.cfg.equipment_star_info")
local jewel_info = require("app.cfg.jewel_info")
--local TeamUtils = require("app.scenes.team.TeamUtils")

TeamData.TYPE_KNIGHT_LEVEL = 1
TeamData.TYPE_KNIGHT_RANK = 2
TeamData.TYPE_KNIGHT_DESTINY = 3
TeamData.TYPE_KNIGHT_FABAO_LEVEL = 4
TeamData.TYPE_KNIGHT_FABAO_AWAKEN = 5
TeamData.TYPE_KNIGHT_EQUIP_LEVEL = 6
TeamData.TYPE_KNIGHT_EQUIP_RANK = 7
TeamData.TYPE_KNIGHT_EQUIP_AWAKEN = 8
TeamData.TYPE_KNIGHT_TREASURE_LEVEL = 9
TeamData.TYPE_KNIGHT_TREASURE_REFINE = 10

TeamData.UPSTAR_MAX = 5

--创建武将数据单元
function TeamData:_createKnightDataUnit(knightItemData)
	--dump("TeamData:_createKnightDataUnit(knightItemData)!!!!!!!!!!!")
	local serverData = {
			id = knightItemData.id,-- //唯一ID
			knightId = knightItemData.base_id,-- //静态表ID
			level = knightItemData.level,-- //等级
			exp = knightItemData.exp,-- //经验
			association = knightItemData.association,--//羁绊信息
			destinyLevel = knightItemData.destiny_lv,--//天命等级
			starLevel = knightItemData.star,--//星阶等级
			awakenLevel = knightItemData.awaken,--//觉醒等级
			holeData = knightItemData.gems,--//宝石孔信息[0.0.0.0]
			--weaponLevel = knightItemData.weapon_lv,--专属武器等级
			--power = knightItemData.power,--武将战力
			-- hp = knightItemData.hp,
			-- atk = knightItemData.atk,
			-- def = knightItemData.def,

			--instrumentLevel = knightItemData.instrument_lv,-- //法宝等级
			--instrumentRank = knightItemData.instrument_rank, -- 法宝突破等级
			--instrumentExp = knightItemData.instrument_exp,
		}
	--dump("TeamData:_createKnightDataUnit(knightItemData): "..serverData.starLevel)
	local knightId = serverData.knightId
	local strId = tostring(serverData.id)
	
	-- 基础配置表信息
	local cfgInfo = require("app.cfg.knight_info").get(knightId) --武将基础配置
	assert(cfgInfo,"knight_info can't find id = "..tostring(knightId))
	local isMainRole = cfgInfo.type == 1
	local sex = cfgInfo.sex
	local fashionId = G_Me.userData:getFashionId()
	local fashionInfo = nil
	if isMainRole and fashionId ~= 0 then -- 主角且有时装
		fashionInfo = jobchange_info.get(fashionId)
		cfgInfo.common_skill = sex == 1 and fashionInfo.man_common_skill_id or fashionInfo.woman_common_skill_id
		cfgInfo.special_skill = sex == 1 and fashionInfo.man_special_skill_id or fashionInfo.woman_special_skill_id
	end

	-- 升星相关配置表信息
	local cfgRankInfo = nil
	if cfgInfo.job ~= 0 then -- 非经验宝宝
		cfgRankInfo = require("app.cfg.knight_star_info").get(cfgInfo.job,cfgInfo.quality,serverData.starLevel)
		assert(cfgRankInfo,string.format("knight_star_info can't find job = %d,quality = %d,starLevel = %d",cfgInfo.job,cfgInfo.quality,serverData.starLevel))
	
		if isMainRole and fashionId ~= 0 then -- 主角且有时装
			cfgRankInfo = require("app.cfg.knight_star_info").get(fashionInfo.role_type,cfgInfo.quality,serverData.starLevel)
			cfgRankInfo.base_hp = math.floor(cfgRankInfo.base_hp * (fashionInfo.hp_change/1000)) --+ fashionInfo.hp_add
			cfgRankInfo.base_attack = math.floor(cfgRankInfo.base_attack * (fashionInfo.attack_change/1000)) --+ fashionInfo.attack_add
			cfgRankInfo.base_defense = math.floor(cfgRankInfo.base_defense * (fashionInfo.defense_change/1000)) --+ fashionInfo.defense_add
			cfgRankInfo.develop_hp = math.floor(cfgRankInfo.develop_hp * (fashionInfo.hp_change/1000))
			cfgRankInfo.develop_attack = math.floor(cfgRankInfo.develop_attack * (fashionInfo.attack_change/1000))
			cfgRankInfo.develop_defense = math.floor(cfgRankInfo.develop_defense * (fashionInfo.defense_change/1000))
		end
	end
	
	-- 升星技能变化相关
	local cfgStarTalent = knight_star_talent_info.get(knightId)
	local _,starLevel = require("app.scenes.team.TeamUtils").level2starName(serverData.starLevel ,knightId)
	if not isMainRole then -- 非主角(主角在各界面显示的时候替换)
		for i=1,starLevel do
			for j=1,3 do
				if cfgStarTalent["talent" .. i .. "_type" .. j] == 900 then -- 普通技能
					cfgInfo.common_skill = cfgStarTalent["talent" .. i .. "_value" .. j]
				elseif cfgStarTalent["talent" .. i .. "_type" .. j] == 901 then -- 怒气
					cfgInfo.special_skill = cfgStarTalent["talent" .. i .. "_value" .. j]
				elseif cfgStarTalent["talent" .. i .. "_type" .. j] == 911 then -- 被动
					cfgInfo.passivity_skill1_type = cfgStarTalent["talent" .. i .. "_value" .. j]
				elseif cfgStarTalent["talent" .. i .. "_type" .. j] == 912 then -- 被动
					cfgInfo.passivity_skill2_type = cfgStarTalent["talent" .. i .. "_value" .. j]
				elseif cfgStarTalent["talent" .. i .. "_type" .. j] == 913 then -- 被动
					cfgInfo.passivity_skill3_type = cfgStarTalent["talent" .. i .. "_value" .. j]
				elseif cfgStarTalent["talent" .. i .. "_type" .. j] == 914 then -- 被动
					cfgInfo.passivity_skill4_type = cfgStarTalent["talent" .. i .. "_value" .. j]
				end
			end
		end
	end
	

	local t = {
		cfgData= cfgInfo,
		cfgRankData = cfgRankInfo,
		serverData = serverData,
	}
	return t
end

--根据武将配置表id创建武将单元数据
function TeamData:createKnightDataUnitByKnightId( knightId )
	local cfgInfo = nil
	if knightId and knightId ~= 0 then
		--tempcode
		--knightId = 11801
		cfgInfo = require("app.cfg.knight_info").get(knightId) --武将基础配置
		assert(cfgInfo,"knight_info can't find id = "..tostring(knightId))
	else
		return nil
	end

	local t = {
		cfgData= cfgInfo,
		cfgRankData = nil,--统一格式方便处理
		serverData = nil,--统一格式方便处理
	}
	return t
end

--根据武将配置表id创建武将单元数据
function TeamData:createEnemyDataUnitByEnemyId( enemyId )
	local cfgInfo = nil
	if enemyId and enemyId ~= 0 then
		cfgInfo = require("app.cfg.monster_info").get(enemyId) --武将基础配置
		assert(cfgInfo,"enemyId can't find id = "..tostring(enemyId))
	else
		return nil
	end

	local t = {
		cfgData= cfgInfo,
		cfgRankData = nil,--统一格式方便处理
		serverData = nil,--统一格式方便处理
	}
	return t
end

function TeamData:ctor( ... )
	-- body
	-- 全体武将数据
	self._knightDataDic = {
		-- ["key"..tostring(id)] = {cfgInfo= nil,cfgRankInfo = nil,serverData = nil}
		-- ["key"..tostring(id)] = {cfgInfo= nil,cfgRankInfo = nil,serverData = nil}
		-- ["key"..tostring(id)] = {cfgInfo= nil,cfgRankInfo = nil,serverData = nil}
		-- ["key"..tostring(id)] = {cfgInfo= nil,cfgRankInfo = nil,serverData = nil}
	}

	self._myPosKnightData = nil--阵位上武将的原始数据
	-- message Formation {
	--   required uint32 id = 1; //阵型对应id
	--   required uint32 icon = 2; //knight_info_id。
	--   required string name = 3; //阵型名称。
	--   repeated uint32 indexs = 4; //对应队伍位置，神将槽位。 1 - 6
	--   repeated uint32 orders = 5; //出手顺序。 1 - 6
	-- }
	-- //主阵容要进入首页的时候就要发给前端，
	-- //所以主阵容和其他阵容分开获取。
	-- //获取主阵容
	-- message S2C_FightKnight {
	--   repeated uint64 first_team = 1;
	--   required Formation formation = 2; //主阵容
	-- }
	-- 阵位上的武将数据 跟阵位绑定 不是武将
	self._myPosKnightDic = {
		--["pos_1"] = {id = ,flag_1 = {slot_1=0,slot_2=0,...},flag_2 = {slot_1=0,slot_2=0,...},flag_3 = {slot_1=0,slot_2=0,...},flag_4 = {slot_1=0,slot_2=0,...}}
		-- id 武将自增id
		-- flag 1=装备, 2=宝物, 3=宝石, 4=星宿
		-- slot 对应装备 宝石 宝物的 id
	} 
	--布阵武将id
	self._myFormationIDList = {
		--[1] = 100001
		--[2] = 0
		--[3] = 100001
		--[4] = 100001
		--[5] = 100001
		--[6] = 0
	}
	--布阵武将出手顺序
	self._myFormationOrderList = {
		--[1] = 1
		--[2] = 2
		--[3] = 3
		--[4] = 4
		--[5] = 5
		--[6] = 6
	}
	 --援军列表id
	self._reinforcementKnightDic = {
		-- ["pos_1"] = 10001
		-- ["pos_2"] = 10001
		-- ["pos_3"] = 10001
		-- ["pos_4"] = 10001
		-- ["pos_5"] = 0
		-- ["pos_6"] = 0
	}

	self._strengthenInfo = nil--我要变强

	self._initPos = nil -- 阵容界面初始显示阵位
end

--判断武将是否是胚子 
function TeamData:isKnightWhiteCard( id )
	local knightData = self:getKnightDataByID(id)
	local bool = false
	if(knightData ~= nil)then
		local item = knightData.serverData
		-- if(item.exp == 0 and item.level == 1 and item.knightRank == 0 and item.destinyLevel == 0 and item.destinyExp == 0)then
		-- 	bool = true
		-- end
		if(item.exp == 0 and item.level == 1 and item.destinyLevel == 1 and item.awakenLevel == 0
			and item.starLevel == 0)then
			for k,v in pairs(item.holeData) do
				if v ~= 0 then
					return bool
				end
			end
			bool = true
		end
	end

	return bool
end

--根据knight_id获取未上阵的同名武将数量（胚子）
function TeamData:getSameKnightNumByKnightID( knightID )
	-- body
	local num = 0
	for k,v in pairs(self._knightDataDic) do
		if(v ~= nil and v.cfgData.knight_id == knightID and self:isKnightWhiteCard(v.serverData.id) == true)then
			local pos1 = self:getKnightPosByID(v.serverData.id)
			local pos2 = self:getReinKnightPosById(v.serverData.id)
			if(pos1 == 0 and pos2 == 0)then
				num = num + 1
			end
		end
	end

	return num
end

--根据knight_id获取未上阵的同名武将列表（胚子）
function TeamData:getSameKnightListByKnightID( knightID )
	-- body
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		if(v ~= nil and v.cfgData.knight_id == knightID and self:isKnightWhiteCard(v.serverData.id) == true)then
			local pos1 = self:getKnightPosByID(v.serverData.id)
			local pos2 = self:getReinKnightPosById(v.serverData.id)
			if(pos1 == 0 and pos2 == 0)then
				list[#list + 1] = v
			end
		end
	end

	return list
end

--获取上阵武将ID列表
function TeamData:getMyFormationIDList(  )
	-- body
	return self._myFormationIDList
end

--获取上阵武将的出手顺利列表
function TeamData:getMyFormationOrderList(  )
	-- body
	return self._myFormationOrderList
end

--获取已获得武将的系统ID列表
function TeamData:getKnightSysIDList( )
	-- body
	local list={}
	if(self.teamKnightInfoList_~=nil)then 
		for k,v in pairs(self.teamKnightInfoList_) do
			list[#list+1]=v.cfgData.knight_id
		end
	end
	return list
end

--根据武将系统表ID 查询武将是否已经拥有
function TeamData:isKnightGeted( knightSysID )
	-- body
	for k,v in pairs(self._knightDataDic) do
		if(v ~= nil and v.cfgData.knight_id == knightSysID)then
			return true
		end
	end
	return false
end

--根据武将表的knight_id获取武将ID， 没有返回nil
function TeamData:getKnightIDByTableID( knight_id )
	for k, v in pairs(self._knightDataDic)do
		if(v ~= nil and v.cfgData.knight_id == knight_id)then
			return v.serverData.id
		end
	end	

	return nil
end

--已上阵武将数量
function TeamData:getPosKnightNum()
	-- body
	local num = 0
	for k,v in pairs(self._myPosKnightDic) do
		if(v.id > 0)then
			num = num + 1
		end
	end

	return num
end

--获取上阵援军数量
function TeamData:getReinKnightNum()
	-- body
	local num = 0
	for k,v in pairs(self._reinforcementKnightDic) do
		if(v > 0)then
			num = num + 1
		end
	end
	
	return num
end

--设置玩家所有武将数据 ID_S2C_FightKnight  knightList = repeat Knight
function TeamData:setAll(knightList)
	-- body
	if(knightList == nil or type(knightList) ~= "table")then return end
	self._knightDataDic = {}
	for i=1,#knightList do
		self:_setTeamKnightItem(knightList[i])
	end
end

--设置单个武将的数据 knightItemData message Knight
function TeamData:_setTeamKnightItem( knightItemData )
	-- body
	if(knightItemData == nil or type(knightItemData) ~= "table")then return end
	--以id为key
	local dataUnit = self:_createKnightDataUnit(knightItemData)
	local key = KNIGHT_KEY..tostring(dataUnit.serverData.id)
	self._knightDataDic[key] = dataUnit
end

-- 同步主阵容的时装
function TeamData:setClothes()
	self._myPosKnightData.formation.clothes = G_Me.userData:getFashionId()
end

--设置上阵武将数据 S2C_FightKnight
function TeamData:setFightKnight(buffData)
	if(buffData == nil or type(buffData) ~= "table")then return end
	self._myPosKnightData = buffData
	local firstTeam = buffData.first_team or {}
	local firstFormation = buffData.formation and buffData.formation.indexs or {}
	self._myFormationOrderList = buffData.formation and buffData.formation.orders or {}
	--上阵武将id 列表
	for i=1,6 do
		local key = POS_KEY..tostring(i)
		if(self._myPosKnightDic[key] == nil)then
			self._myPosKnightDic[key] = {}
		end
		if(i <= #firstTeam)then
			self._myPosKnightDic[key].id = firstTeam[i]
		else
			self._myPosKnightDic[key].id = 0
		end
	end
	
	--布阵 武将id列表
	for i=1,#firstFormation do
		local key = POS_KEY..tostring(firstFormation[i])
		local posData = self._myPosKnightDic[key]
		self._myFormationIDList[i] = posData ~= nil and posData.id or 0
	end
end

function TeamData:switchKnightPos(fromIndex,toIndex )
	local data = self._myPosKnightData.formation.indexs
	local from = data[fromIndex]
	data[fromIndex] = data[toIndex]
	data[toIndex] = from
	
	--卡牌显示数据更新
	self._myFormationIDList = {}
	for j=1,#data do
		local knightID = G_Me.teamData:getKnightIDByPos(data[j])
		table.insert(self._myFormationIDList,knightID)
	end

	self._hasFormationChange = true
end

function TeamData:switchOrderPos(fromIndex,toIndex )
	local data = self._myPosKnightData.formation.orders
	local from = data[fromIndex]
	data[fromIndex] = data[toIndex]
	data[toIndex] = from

	self._hasFormationChange = true
end

function TeamData:formationChangeOver( ... )
	self._hasFormationChange = false
end

function TeamData:formationIsChange( ... )
	return self._hasFormationChange
end

function TeamData:getFormation( ... )
	return self._myPosKnightData.formation
end

--设置上阵 宝石 装备 宝物 宝石镶嵌
function TeamData:setFightResource(buffData)
	-- body
	if(buffData == nil or type(buffData) ~= "table")then return end
	local resources = buffData.resources or {}
	-- // flags + team + pos +  slot   flags上阵装备类型(1=装备, 2=宝物, 3=宝石, 4=专属武器 5=宝石镶嵌) team阵容 1,2  pos阵位1-6, slot槽位 
	for i=1,#resources do
		local resData = resources[i]
		local resIndex = resData.index
		local slot = bit.band(bit.brshift(resIndex,0),255)
		local pos = bit.band(bit.brshift(resIndex,8),255)
		local team = bit.band(bit.brshift(resIndex,16),255)
		local flag = bit.band(bit.brshift(resIndex,24),255)
		if(team == 1)then --team2 是援军
			self:updateFightResource(pos,flag,slot,resData.id)
		end
	end
end

---穿戴装备后更新 fightResouce数据
function TeamData:updateFightResource( pos,flag,slot,id,oldId )
	-- body
	if(self._myPosKnightDic == nil)then return end
	local keyPos = POS_KEY..tostring(pos)
	local keyFlag = FLAG_KEY..tostring(flag)
	local keySlot = SLOT_KEY..tostring(slot)
	if(self._myPosKnightDic[keyPos] == nil)then
		self._myPosKnightDic[keyPos] = {}
	end

	if(self._myPosKnightDic[keyPos][keyFlag] == nil)then
		self._myPosKnightDic[keyPos][keyFlag] = {}
	end

	self._myPosKnightDic[keyPos][keyFlag][keySlot] = id or 0
	if flag == 4 then
		print("pos,flag,slot,id,oldId",pos,flag,slot,id,oldId)
		if oldId ~= nil and oldId ~= 0 then
			G_Me.equipData:updateExEquipPos(oldId,0)
		end
		G_Me.equipData:updateExEquipPos(id,pos)
	end

	if flag == 2 then
		print("pos,flag,slot,id,oldId",pos,flag,slot,id,oldId)
		if oldId ~= nil and oldId ~= 0 then
			G_Me.bookWarData:updateBookWarPos(oldId,0)
		end
		G_Me.bookWarData:updateBookWarPos(id,pos)
	end

	if flag == 1 then
		if oldId ~= nil and oldId ~= 0 then
			G_Me.equipData:updateEquipPos(oldId,0)
		end
		G_Me.equipData:updateEquipPos(id,pos)
	end

	if(flag == 5)then
		if oldId ~= nil and oldId ~= 0 then
			G_Me.jewelData:updateJewelPos(oldId, 0)
		end
		if(id)then
			G_Me.jewelData:updateJewelPos(id, pos)
		end
	end
end

--获取指定阵位上的指定装备类型 的数据 return {slot_1 = 10000,slot_2 == 0,slot_3 == 0}
-- pos 阵位 1-6  flag 上阵装备类型(1=装备, 2=宝物, 3=宝石, 4=专属武器 5=宝石镶嵌)
function TeamData:getPosResourcesByFlag( pos , flag )
	-- body
	if(self._myPosKnightDic == nil)then return nil end
	local data = self._myPosKnightDic[POS_KEY..tostring(pos)]
	if(data ~= nil)then
		-- local isActiveEx = false
		-- if flag == 4 then  -- 专属武器
		-- 	local knightData = self:getKnightDataByPos(pos)
		-- 	if knightData.cfgData.exclusive_id == data[FLAG_KEY..tostring(flag)] then --已激活自己的专属
		-- 		--todo
		-- 	end
		-- end
		return data[FLAG_KEY..tostring(flag)]
	end
	return nil
end

-- 获取专属装备穿戴状态 0：未穿戴 
function TeamData:getExEquipStateByKnightId( knightId )
	local flag = 0
	local pos = self:getKnightPosByKnightID(knightId)
	if pos == 0 then -- 武将未上阵
		--dump("not in team!")
		return 0
	end

	local knightData = self:getKnightDataByPos(pos)
	local dataRes = self:getPosResourcesByFlag(pos,4)
	if dataRes == nil or dataRes["slot_1"] == 0 then -- 未装备专属
		--dump("not dress exEquip!")
		return 0
	end

	-- dump(knightData.cfgData.exclusive_id)
	-- dump(dataRes)
	-- dump(dataRes["slot_1"])
	local exEquipData = G_Me.equipData:getExEquipInfoByID(dataRes["slot_1"])
	--dump(exEquipData.serverData.base_id)
	if exEquipData and knightData.cfgData.quality >= 10 and knightData.cfgData.exclusive_id == exEquipData.serverData.base_id then -- --已激活自己的专属
		--dump(exEquipData.serverData.star)
		return G_Me.equipData:getExEquipFigure(exEquipData.serverData.base_id,exEquipData.serverData.star)
	end

	return 0
end

--根据宝物的id 查找对应穿戴该宝物的武将信息
function TeamData:getKnightPosByTreasureID( treasureId )
	-- body
	local pos = 0
	for i=1,6 do
		local resList = self:getPosResourcesByFlag(i,2)
		if(resList ~= nil)then
			for j=1,2 do
				local id = resList["slot_"..tostring(j)]
				if(id == treasureId)then
					pos = i
					break
				end
			end
		end
	end
	return pos
end

--判断指定阵位上的 指定装备是否都已穿戴完毕
--pos 上阵位置 resType 上阵装备类型(1=装备, 2=宝物, 3=宝石, 4=星宿)
function TeamData:isAllResOn( pos,resType )
	-- body
	local  slotNum = 2   

	if resType == 1 then
		slotNum = 4 --4件装备
	end

	local resData = self:getPosResourcesByFlag(pos, resType)
	local numTotal = 0
	if(resData ~= nil)then
		for i=1,4 do
			local id = resData["slot_"..tostring(i)]
			if(id ~= nil and id > 0)then
				numTotal = numTotal + 1
			end
		end
		return numTotal >= slotNum
	end
	return false
end

--判断任意阵位上的四件装备是否都已装备
--kaka
function TeamData:isAllEquipOnInAnyPos()
	-- body
	for pos=1, 6 do
		if self:isAllResOn(pos, 1) then
			return true
		end	
	end
	return false
end

--根据武将id（后端 自增ID）获取指定武将信息
function TeamData:getKnightDataByID( id )
	if(self._knightDataDic == nil)then return nil end
	local key = KNIGHT_KEY..tostring(id)
	return self._knightDataDic[key]
end

--获取指定上阵位置的 武将数据  没有则返回 nil
function TeamData:getKnightDataByPos( pos )
	local posData = self._myPosKnightDic[POS_KEY..tostring(pos)]
	local posKnightId = posData ~= nil and posData.id or 0
	return self:getKnightDataByID(posKnightId)
end

--根据位置获取武将的id
function TeamData:getKnightIDByPos( pos )
	local posData = self._myPosKnightDic[POS_KEY..tostring(pos)]
	local posKnightId = posData ~= nil and posData.id or 0
	return posKnightId
end

--根据武将流水ID获取武将上阵位置  0 表示未上阵  1-6 表示对应的上阵位置
function TeamData:getKnightPosByID( id )
	-- body
	if(self._myPosKnightDic == nil)then return 0 end
	for i=1,6 do
		local posData = self._myPosKnightDic[POS_KEY..tostring(i)]
		local posKnightId = posData ~= nil and posData.id or 0
		if(posKnightId == id and posKnightId > 0)then
			return i
		end
	end
	return 0
end

--根据武将的系统id knight_info中的knight_id 获取武将的上阵位置  0 表示没有上阵
function TeamData:getKnightPosByKnightID( knightId )
	-- body
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil and knightData.cfgData.knight_id == knightId)then
			return i
		end
	end
	return 0
end

--获取相应职业的武将列表数据
function TeamData:getKnightDataListByJob(jobType)
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		if(v["cfgData"].job == jobType)then
			list[#list+1] = v
		end
	end
	return list
end

--获取相应阵营的武将列表数据
function TeamData:getKnightDataListByGroup(group)
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		if(v["cfgData"].group == group)then
			list[#list+1] = v
		end
	end
	return list
end

--获取所有未培养过的神将
function TeamData:getAllUnCultivateKnight(  )
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		local id = v.serverData.id
		if(self:isKnightWhiteCard(id))then
			list[#list+1] = v
		end
	end
	return list
end

--获取所有未上阵的 培养过的武将
function TeamData:getAllUnPosCultivateKnight()
	-- body
	if(self._knightDataDic == nil)then return nil end
	local tempList = self:getAllUnPosKnightExcludeColor() or {}
	local list = {}

	for i=1,#tempList do
		local id = tempList[i].serverData.id
		if(not self:isKnightWhiteCard(id))then
			list[#list+1] = tempList[i]
		end
	end

	return list
end

--获取所有未上阵 未培养过的武将
function TeamData:getAllUnPosUnCultivateKnight( ... )
	-- body
	if(self._knightDataDic == nil)then return nil end
	local tempList = self:getAllUnPosKnightExcludeColor() or {}
	local list = {}

	for i=1,#tempList do
		local id = tempList[i].serverData.id
		if(self:isKnightWhiteCard(id))then
			list[#list+1] = tempList[i]
		end
	end

	return list
end


--获取所有可出售的神将列表
function TeamData:getAllKnightsForSell( ... )
	-- body
	
	if(self._knightDataDic == nil)then return {} end
	local tempList = self:getAllUnPosKnightExcludeColor() or {}
	local list = {}

	local ParameterInfo = require("app.cfg.parameter_info")
    -- local parameter = ParameterInfo.get(116)  --knight_forbidden_sold_color
    -- local forbidColor = parameter and tonumber(parameter.content) or 100  --没有配置的话就用个大值
    local forbidQuality =  13  --资质

	for i=1,#tempList do
		local id = tempList[i].serverData.id
		--蟠桃也不能出售 怪异啊  品质低于forbidColor才可出售
		if(self:isKnightWhiteCard(id) and tempList[i].cfgData.type == 2 and 
			tempList[i].cfgData.is_sold == 1)then
			list[#list+1] = {
				id=tempList[i].cfgData.knight_id, 
				cfgData=tempList[i].cfgData, 
				level=tempList[i].serverData.level, 
				serverData=tempList[i].serverData,
				price = tempList[i].cfgData.price,
				num = 1,
			}
		end
	end

	return list
end



--获取所有未上阵的武将
function TeamData:getAllUnPosKnightExcludeColor( quality )
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		local id = v.serverData.id
		local pos1 = self:getKnightPosByID(id)
		--local pos2 = self:getReinKnightPosById(id)
		if(pos1 < 1 and v.cfgData.quality ~= quality)then
			list[#list+1] = v
		end
	end
	return list
end

--获取所有未上阵且低于参数品质等级的武将
function TeamData:getAllUnPosKnightExcludeColorQuality( quality )
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		local id = v.serverData.id
		local pos1 = self:getKnightPosByID(id)

		--local pos2 = self:getReinKnightPosById(id)
		if(pos1 < 1 and tonumber(v.cfgData.quality) < tonumber(quality) )then
			list[#list+1] = v
		end
	end
	return list
end

--获取全部武将数据
--noSort 是否要排序
function TeamData:getAllKnightDataList( noSort )
	-- body
	if(self._knightDataDic == nil)then return nil end
	local list = {}
	for k,v in pairs(self._knightDataDic) do
		list[#list+1] = v
	end

	--需要默认排序
	if not noSort then

		table.sort(list,function(a,b)
			local pos1 = self:getKnightPosByID(a.serverData.id)
			local pos2 = self:getKnightPosByID(b.serverData.id)
			if(pos1 ~= pos2 and (pos1 == 0 or pos2 == 0))then
				return pos1 > pos2
			end
			if(pos1 ~= pos2 and pos1 > 0 and pos2 > 0)then
				return pos1 < pos2
			end
			local reinPos1 = self:getReinKnightPosById(a.serverData.id)
			local reinPos2 = self:getReinKnightPosById(b.serverData.id)
			if(reinPos1 ~= reinPos2 and (reinPos1 == 0 or reinPos2 == 0))then
				return reinPos1 > reinPos2
			end
			if(reinPos1 ~= reinPos2 and reinPos1 > 0 and reinPos2 > 0)then
				return reinPos1 < reinPos2
			end

			if(a.cfgData.type ~= b.cfgData.type)then
				return a.cfgData.type < b.cfgData.type
			end
			
			if(a.cfgData.quality ~= b.cfgData.quality)then
				return a.cfgData.quality > b.cfgData.quality
			end

			-- if(a.serverData.knightRank ~= b.serverData.knightRank)then
			-- 	return a.serverData.knightRank > b.serverData.knightRank
			-- end
			if(a.serverData.level ~= b.serverData.level)then
				return a.serverData.level > b.serverData.level
			end
			if(a.serverData.destinyLevel ~= b.serverData.destinyLevel)then
				return a.serverData.destinyLevel > b.serverData.destinyLevel
			end
			-- if(a.serverData.instrumentLevel ~= b.serverData.instrumentLevel)then
			-- 	return a.serverData.instrumentLevel > b.serverData.instrumentLevel
			-- end
			-- if(a.serverData.instrumentRank ~= b.serverData.instrumentRank)then
			-- 	return a.serverData.instrumentRank > b.serverData.instrumentRank
			-- end
			-- if(a.cfgData.group ~= b.cfgData.group)then
			-- 	return a.cfgData.group < b.cfgData.group
			-- end
			return a.cfgData.knight_id > b.cfgData.knight_id
		end)
	end

	return list
end

--根据武将的流水ID 判断武将是不是援军
function TeamData:isKnightRein( id )
	-- body
	for k,v in pairs(self._reinforcementKnightDic) do
		if(v == id and id > 0)then
			return true
		end
	end
	return false
end

-- 根据武将的系统id查找武将的援军位置
function TeamData:getReinKnightPosByKnightID( knightId )
	-- body
	for i=1,8 do
		local reinData = self:getReinKnightDataByPos(i)
		if(reinData ~= nil and reinData.cfgData.knight_id == knightId)then
			return i
		end
	end

	return 0
end

--根据武将的流水id 获取武将在援军中的上阵位置  0 表示没有在援军阵容
function TeamData:getReinKnightPosById( id )
	-- body
	for i=1,8 do
		local reinData = self:getReinKnightDataByPos(i)
		if(reinData ~= nil and reinData.serverData.id == id)then
			return i
		end
	end
	return 0
end

--根据援军位置 获取 援军数据
function TeamData:getReinKnightDataByPos( pos )
	-- body
	if(self._reinforcementKnightDic == nil)then return nil end
	local id = self._reinforcementKnightDic[POS_KEY..tostring(pos)]
	local data = self:getKnightDataByID(id)
	return data
end

------------------------------------------------------合击
--根据武将的流水ID获取 对应的合击武将数据（上阵武将）
function TeamData:getKnightInfoHeJiByID( id,exceptPos,team)
	-- -- body
	-- if(team == 2)then return nil end
	-- ---合击将 必须都在战斗阵位上  --缘分的话就没有这个限制
	-- local pos = exceptPos or 0
	-- local targetData = self:getKnightDataByID(id)
	-- if(targetData ~= nil)then
	-- 	for i=1,6 do
	-- 		local knightData = self:getKnightDataByPos(i)
	-- 		if(i ~= pos and knightData ~= nil and targetData.cfgData.unite_knight == knightData.cfgData.knight_id)then
	-- 			return knightData
	-- 		end
	-- 	end
	-- end
	return nil
end

-----传入{knight_id,knight_id} 判断所有武将是否都已上阵
function TeamData:_isAllKnightInPos( targetPos,list,team)
	-- body
	if(targetPos == nil or list == nil)then
		assert(nil,"targetPos,list should not to be nil")
	end

	local bool = false
	if(#list == 0)then return bool end
	
	---援军之间不触发缘分
	if(team == 1)then
		local numTotal = 0
		local len = #list
		for i=1,#list do
			local pos = self:getKnightPosByKnightID(list[i])
			local reinPos = self:getReinKnightPosByKnightID(list[i])
			if(pos > 0)then
				if(pos ~= targetPos)then
					numTotal = numTotal + 1
				end
			elseif(reinPos > 0)then
				numTotal = numTotal + 1
			end
		end

		if(numTotal >= len)then
			bool = true
		end
	end

	return bool
end

--获取上阵神将对其他阵位的武将缘分激活数量
function TeamData:_getOthersAssWillActive( targetPos,team,sysId)
	-- body
	-- 这边要注意一点，即使是援军也有可能引起战斗阵位上的其他武将缘分触发，虽然他不触发援军阵位上的缘分
	-- 神将放置在 战斗位 有可能触发自身缘分  也有可能触发其他战斗阵位上的缘分
	local activeNum = 0
	local function isAllKnightOnPos(idList)
		local num = #idList
		local total = 0 
		for i=1,#idList do
			local pos = self:getKnightPosByKnightID(idList[i])
			local reinPos = self:getReinKnightPosByKnightID(idList[i])
			if(pos ~= 0 or reinPos ~= 0)then
				total = total + 1
			end
		end
		return total >= num and num > 0
	end

	local excludePos = team == 1 and targetPos or 0

	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil and excludePos ~= i)then
			local activeAssList = knightData.serverData.association or {}
			for j=1,16 do
				local aId = knightData.cfgData["association_"..tostring(j)]
				
				if(aId > 0 and table.indexof(activeAssList,aId) == false)then
					local aInfo = require("app.cfg.association_info").get(aId)
					assert(aInfo,"aInfo == nil aId = "..tostring(aId))
					-- 关联组合类型：--缘分类型：1-武将之间；2-武将与装备 废弃；3-武将与宝物；4-装备觉醒一次激活；5；法宝觉醒1次激活  
					if(aInfo.info_type == 1)then
						local needIdList = {}
						local isFinded = false
						for m=1,4 do
							local needId = aInfo["info_value_"..tostring(m)]
							if(needId > 0)then

								if(sysId == needId)then
									isFinded = true
								else
									needIdList[#needIdList+1] = needId
								end
								
							end
						end

						if(isFinded == true and #needIdList > 0 and isAllKnightOnPos(needIdList))then
							activeNum = activeNum + 1
						elseif(isFinded == true and #needIdList == 0)then
							activeNum = activeNum + 1
						end
					end
				end
			end
		end
	end

	return activeNum
end

--武将所需装备是否都已穿戴
function TeamData:_isAllEquipInPos( pos,list,team )
	-- body
	if(pos == nil or list == nil)then
		assert(nil,"pos,list should not to be nil")
	end

	if(team == 2)then return false end

	local resList = self:getPosResourcesByFlag(pos, 1) or {}
	local totalNum = 0
	for i=1,#list do
		local needId = list[i]
		for k,v in pairs(resList) do
			local equipId = v or 0
			local equipData = G_Me.equipData:getEquipInfoByID(equipId)
			if(needId > 0 and equipData ~= nil and equipData.cfgData.id == needId and equipData.serverData.star >= 1)then
				totalNum = totalNum + 1
			end
		end
	end

	return totalNum == #list and #list > 0
end

--武将所需宝物是否都已穿戴
function TeamData:_isAllTreasureInPos( pos,list,team )
	-- body
	if(pos == nil or list == nil)then
		assert(nil,"pos,list should not to be nil")
	end

	if(team == 2)then return false end

	local resList = self:getPosResourcesByFlag(pos, 2)
	if(resList == nil or #resList < 1)then return false end

	local totalNum = 0
	for i=1,#list do
		local needId = list[i]
		for j=1,#resList do
			local treasureId = resList[j]
			if(needId > 0 and treasureId > 0 and needId == treasureId)then
				totalNum = totalNum + 1
			end
		end
	end

	return totalNum == #list and #list > 0
end

--获取武将当前激活缘分个数，武将可激活缘分总个数
function TeamData:getAssociationProgressByID( id )
	-- body
	local knightData = self:getKnightDataByID(id)
	local numOwn = 0
	local numTotal = 0
	local knightInfo = require("app.cfg.knight_info")
	if(knightData ~= nil)then
		local activeList = knightData.serverData.association or {}
		for i=1,16 do
			local aId = knightData.cfgData["association_"..tostring(i)]
			if(aId > 0)then
				numTotal = numTotal + 1
				for j=1,#activeList do
					if(activeList[j] == aId)then
						numOwn = numOwn + 1
						break
					end
				end
			end
		end
	end

	return numOwn,numTotal
end


----sysId 神将系统id 判断未上阵的神将（未获得的神将）是不是阵上神将缘分所需的
function TeamData:isUpPosKnightAssNeeded( sysId,isFromShop )
	-- body
    local isOpen = require("app.responder.Responder").funcIsOpened(G_FunctionConst.FUNC_KNIGHT_SHOP_ASSOCIATION)
    
    if isFromShop == true then
	    local reinPos = self:getReinKnightPosByKnightID(sysId)
	    if reinPos > 0 then
	    	return false
	    end

	    local ownNum = self:getSameKnightNumByKnightID(sysId)
	    if ownNum > 0 then
	    	return false
	    end
	end

    if isOpen then
        for i=2,6 do
            local knightData = self:getKnightDataByPos(i)
            if(knightData ~= nil and sysId ~= knightData.cfgData.knight_id)then

            	for i=1,16 do
            		local assId = knightData.cfgData["association_"..tostring(i)]
            		--- 这里需要判断缘分是否已经激活过(策划说的)
            		local activeList = knightData.serverData.association or {}
            		if assId ~= 0 and table.indexof(activeList,assId) == false then
            			local assInfo = require("app.cfg.association_info").get(assId)
            			assert(assInfo,"association_info can't find id = "..tostring(assId))
            			if assInfo.info_type == 1 then
            				for j=1,5 do
            					local knightSysId = assInfo["info_value_"..tostring(j)]
            					if knightSysId == sysId then
            						return true
            					end
            				end
            			end
            		end
            	end
            end
        end
    end

    return false
end

-- 根据流水ID获取 对应激活的缘分数据
-- id 武将流水id
-- targetPos要装备到的位置
-- 该方法只适合换武将时比较激活缘分
function TeamData:getActiveKnightAssociationNumsByID(sysId,targetPos,team,id)
	-- body
	if(sysId == nil or targetPos == nil)then
		assert(nil,"sysId ,targetPos should not to be nil")
	end

	local knightInfo = require("app.cfg.knight_info").get(sysId)
	assert(knightInfo,"knight_info can't find knight_id = "..tostring(sysId))
	local numTotal = 0
	if(knightInfo ~= nil)then
		for i=1,16 do
			
			local aId = knightInfo["association_"..tostring(i)]
			
			if(aId > 0)then
				local needIdList = {}
				local aInfo = require("app.cfg.association_info").get(aId)
				assert(aInfo,"aInfo == nil aId = "..tostring(aId))
				-- 关联组合类型：--缘分类型：1-武将之间；2-武将与装备；3-武将与宝物；4-装备觉醒一次激活；5；法宝觉醒1次激活  
				for j=1,4 do
					local needId = aInfo["info_value_"..tostring(j)]
					if(needId > 0)then
						needIdList[#needIdList+1] = needId
					end
				end
				local bool = false
				if(#needIdList > 0)then
					if(aInfo.info_type == 1)then
						--其实上援军的话 这里就直接是false  不可能触发自身缘分
						bool = self:_isAllKnightInPos(targetPos,needIdList,team)
					elseif(aInfo.info_type == 4)then
						-- bool = self:_isAllEquipInPos(targetPos,needIdList,team)
					elseif(aInfo.info_type == 3)then
						bool = self:_isAllTreasureInPos(targetPos,needIdList,team)
					elseif(aInfo.info_type == 5)then
						-- if id ~= nil then
						-- 	local targetKnightData = self:getKnightDataByID(id)
						-- 	if targetKnightData ~= nil and targetKnightData.serverData.instrumentRank >= 1 then
						-- 		bool = true
						-- 	end
						-- end
					elseif(aInfo.info_type == 6)then
						--- 装备
						local resData = self:getPosResourcesByFlag(targetPos, 1)
						local totalNum = 0
						if resData ~= nil then
							for i=1,4 do
								local equipId = resData["slot_"..tostring(i)] or 0
								if equipId > 0 then
									local equipData = G_Me.equipData:getEquipInfoByID(equipId)
									if equipData.cfgData.color >= aInfo.info_value_1 then
										totalNum = totalNum + 1
									end
								end
							end
						end

						if totalNum >= 4 then
							bool = true
						end
					end
				end
				if(bool == true)then
					numTotal = numTotal+1
				end
			end
		end
	end

	-- 这边要注意一点，即使是援军也有可能引起战斗阵位上的其他武将缘分触发，虽然他不触发援军阵位上的缘分
	-- 神将放置在 战斗位 有可能触发自身缘分  也有可能触发其他战斗阵位上的缘分
	numTotal = numTotal + self:_getOthersAssWillActive(targetPos,team,sysId)

	return numTotal
end

-- 获取不可激活的缘分对应的武将列表
function TeamData:isUnGetAssKnight(knightID)
	local knightList = {}

	for i=2,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			local activeAssList = knightData.serverData.association or {}
			for k=1,#activeAssList do
				for j=1,#activeAssList[k].ass_flags do
					if activeAssList[k].ass_flags[j] == 0 then
						if knightID and knightID == activeAssList[k].ass_values[j] then
							return true
						end
						--knightList[#knightList + 1] = activeAssList.ass_values[j]
					end
				end
			end
		end
	end
	return false
end

--获取武将的缘分数据列表 返回所有缘分数据 包括激活情况
--noSort 不需要排序
function TeamData:getKnightAssociationInfoListByID( id, noSort)
	local list = {}
	local knightData = self:getKnightDataByID(id)

	if(knightData ~= nil)then
		local activeAssList = knightData.serverData.association or {}
		--dump(activeAssList)
		local sigleAssociation = nil
		for i=1,16 do
			local aId = knightData.cfgData["association_"..tostring(i)]
			if(aId > 0)then
				local itemInfo = require("app.cfg.association_info").get(aId)
				assert(itemInfo,"association_info can't find id == "..tostring(aId))
				
				local isActive = false
				for j=1,#activeAssList do
					if(activeAssList[j].ass_id == aId)then
						-- 判断是否已经激活
						local flag = true
						for _,v in pairs(activeAssList[j].ass_flags) do
							if v ~= 1 then
								flag = false
							end
						end
						if flag then 
							isActive = true
						end

						sigleAssociation = activeAssList[j]
						break
					end
				end

				-- 装备激活状态判断
				if itemInfo.info_type == 2 then
					isActive = true
					for i=1,4 do
						local valueID = tonumber(itemInfo["info_value_"..tostring(i)])
						if valueID > 0 then
							local equipInfo = require("app.cfg.equipment_info").get(valueID)
							assert(equipInfo,string.format("equipment_info can't find id = %d ,rank = %d",valueID,1))
							local pos = G_Me.teamData:getKnightPosByID(knightData.serverData.id)
							local equipRes = G_Me.teamData:getPosResourcesByFlag(pos, 1)
							if equipRes ~= nil then -- 有装备
								local eid = equipRes["slot_"..tostring(equipInfo.type)] or 0
								local equipData = G_Me.equipData:getEquipInfoByID(eid)

								-- 判断现在是否穿着
								if equipData and equipData.cfgData.id ~= valueID then isActive = false end
								if not equipData then
									isActive = false
								end
							else -- 没有装备
								isActive = false
							end
						end
					end
				elseif itemInfo.info_type == 3 then -- 兵书
					isActive = true
					for i=1,2 do
						local valueID = tonumber(itemInfo["info_value_"..tostring(i)])
						if valueID > 0 then
							local equipInfo = require("app.cfg.bookwar_info").get(valueID)
							assert(equipInfo,string.format("equipment_info can't find id = %d ,rank = %d",valueID,1))
							local pos = G_Me.teamData:getKnightPosByID(knightData.serverData.id)
							local equipRes = G_Me.teamData:getPosResourcesByFlag(pos, 2)
							if equipRes ~= nil then
								local eid = equipRes["slot_"..tostring(equipInfo.type)] or 0
								local equipData = G_Me.bookWarData:getbookWarInfoByID(eid)

								-- 判断现在是否穿着
								if equipData and equipData.cfgData.id ~= valueID then isActive = false end
								if not equipData then
									isActive = false
								end
							else
								isActive = false
							end
						end
					end	
				end

				list[#list+1] = {cfgData = itemInfo,serverData = sigleAssociation,isActive = isActive}
			end
		end
	end

	-- if not noSort then
	-- 	table.sort(list,function(a,b)
	-- 		local active1 = a.isActive and 1 or 0
	-- 		local active2 = b.isActive and 1 or 0
	-- 		if(active1 ~= active2)then
	-- 			return active1 > active2
	-- 		end
	-- 		return a.cfgData.id < b.cfgData.id
	-- 	end)
	-- end

	return list
end

--获取该武将的缘分是否有可激活的武将
function TeamData:judgeCanActive(id)
	local list = {}
	local knightData = self:getKnightDataByID(id)

	if(knightData ~= nil)then
		local activeAssList = knightData.serverData.association or {}
		local sigleAssociation = nil
		for i=1,16 do
			local aId = knightData.cfgData["association_"..tostring(i)]
			if(aId > 0)then
				local itemInfo = require("app.cfg.association_info").get(aId)
				assert(itemInfo,"association_info can't find id == "..tostring(aId))
				
				local isActive = false
				for j=1,#activeAssList do
					if(activeAssList[j].ass_id == aId)then
						for _,v in pairs(activeAssList[j].ass_flags) do
							if v == 2 then
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

--获取能激活缘分个数
--id 武将id
--checkId --被检测的武将或装备或宝物
--type 缘分类型 1-武将之间；2-武将与装备；3-武将与宝物 
function TeamData:getActiveAssociationNums( id, checkId, _type )

	assert(type(id)=="number" and type(checkId)=="number" and type(_type)=="number", 
		"TeamData:checkActivateAssociationByID param error")

	-- body
	local list = self:getKnightAssociationInfoListByID(id, true)

	--dump(list)
	
	local numTotal = 0

	for i=1, #list do
		local asData = list[i].cfgData
		if _type == 1 then
			--TODO
		--宝物和装备判断简单 只处理了一件宝物或者装备就能激活一个缘分的情况
		elseif _type == asData.info_type and checkId == asData.info_value_1 then
			numTotal = numTotal + 1
		end
	end

	return numTotal
end

-- 获取可吞食武将列表
function TeamData:getKnights2Eat(excludeId,isAuto,noSort)
	local list = {}
	local knightList = self:getAllKnightDataList(true) or {}
	local expAdd = 0
	--自动选择不显示蓝将 手动选择的话 要显示蓝将
	local colorLimit = isAuto == true and 3 or 4
	for i=1,#knightList do
		local item = knightList[i]
		local pos1 = self:getKnightPosByID(item.serverData.id)
		local pos2 = self:getReinKnightPosById(item.serverData.id)
		--if(pos1 == 0 and pos2 == 0 and item.serverData.id ~= excludeId and item.serverData.destinyLevel < 1 and item.serverData.instrumentLevel <= 1 and item.serverData.instrumentRank < 1 and item.serverData.destinyExp <= 0 and item.serverData.knightRank == item.cfgData.base_rank )then
		if(pos1 == 0 and pos2 == 0 and item.serverData.id ~= excludeId --[[and item.serverData.destinyLevel < 1 and item.serverData.destinyExp <= 0]])then
			if(item.cfgData.type == 3 or G_TypeConverter.quality2Color(item.cfgData.quality) <= colorLimit)then
				list[#list+1] = item
				expAdd = expAdd + item.cfgData.base_exp + item.serverData.exp
			end
		end
	end

	if noSort ~= true then

		if(isAuto == true)then
			table.sort(list,function(a,b)
				if(a.cfgData.type ~= b.cfgData.type)then
					return a.cfgData.type < b.cfgData.type
				elseif(a.cfgData.quality ~= b.cfgData.quality)then
					return a.cfgData.quality < b.cfgData.quality
				elseif(a.serverData.level ~= b.serverData.level)then
					return a.serverData.level < b.serverData.level
				elseif(a.cfgData.base_exp ~= b.cfgData.base_exp)then
					return a.cfgData.base_exp < b.cfgData.base_exp
				else
					return a.serverData.id < b.serverData.id
				end
			end)
		else
			table.sort(list,function(a,b)
				if(a.cfgData.type ~= b.cfgData.type)then
					return a.cfgData.type > b.cfgData.type
				elseif(a.cfgData.quality ~= b.cfgData.quality)then
					return a.cfgData.quality > b.cfgData.quality
				elseif(a.serverData.level ~= b.serverData.level)then
					return a.serverData.level > b.serverData.level
				elseif(a.cfgData.base_exp ~= b.cfgData.base_exp)then
					return a.cfgData.base_exp > b.cfgData.base_exp
				else
					return a.serverData.id < b.serverData.id
				end
			end)
		end

	end

	return list,expAdd
end

--获取可以上阵的武将列表 
--targetpos 上阵位置，team 1 主阵容位置  2 援军位置
function TeamData:getUnPosKnightDataList(targetPos,team,noSort)
	-- body
	local list = {}
	local myPosList = self._myPosKnightDic or {}
	local friendPosList = self._reinforcementKnightDic or {}
	local posData = team == 1 and self:getKnightDataByPos(targetPos) or self:getReinKnightDataByPos(pos)
	local posKnightId = posData ~= nil and posData.cfgData.knight_id or 0
	local ids = {}
	
	for k,v in pairs(myPosList) do
		local info = v
		if(info ~= nil and info["id"] > 0)then
			table.insert(ids,info["id"])
		end
	end
	for k,v in pairs(friendPosList) do
		if(v ~= nil and v > 0)then
			table.insert(ids,v)
		end
	end
	if(self._knightDataDic ~= nil)then
		for k,v in pairs(self._knightDataDic) do
			local isFind = false
			for i=1,#ids do
				local id = ids[i]
				local itemData = self:getKnightDataByID(id)
				if(id == v.serverData.id or (itemData.cfgData.knight_id == v.cfgData.knight_id and posKnightId ~= itemData.cfgData.knight_id))then
					isFind = true
					break
				end
			end

			if(isFind == false and v.cfgData.type ~= 3)then
				table.insert(list,v)
			end
		end
	end

	return list
end

----------------------------------------------------装备相关
--根据装备ID获取装备位置
function TeamData:getPosByEquipID( equipId )
	-- body
	for i=1,6 do
		local data = self:getPosResourcesByFlag(i,1)
		if(data ~= nil)then
			for j=1,4 do
				local id = data[SLOT_KEY..tostring(j)]
				if(id == equipId)then
					return i
				end
			end
		end
	end
	return 0
end

--根据装备ID获取装备位置
function TeamData:getPosByExEquipID( equipId )
	-- body
	for i=1,6 do
		local data = self:getPosResourcesByFlag(i,4)
		if(data ~= nil)then
			for j=1,4 do
				local id = data[SLOT_KEY..tostring(j)]
				if(id == equipId)then
					return i
				end
			end
		end
	end
	return 0
end

function TeamData:getPosByEquipSysID( sysId )
	-- body
	for i=1,6 do
		local data = self:getPosResourcesByFlag(i,1)
		if(data ~= nil)then
			for j=1,4 do
				local id = data[SLOT_KEY..tostring(j)]
				local equipData = G_Me.equipData:getEquipInfoByID(id)
				if(equipData ~= nil and equipData.cfgData.id == sysId)then
					return i
				end
			end
		end
	end
	return 0
end

--获取所有已穿戴的装备ID
function TeamData:getFightEquipIDList()
	-- body
	if(self._myPosKnightDic == nil)then return nil end
	local idList = {}
	for i=1,6 do
		local data = self:getPosResourcesByFlag(i,1)
		if(data ~= nil)then
			for j=1,4 do
				local id = data[SLOT_KEY..tostring(j)]
				if(id > 0)then
					table.insert(idList,id)
				end
			end
		end
	end
	return idList
end
----------------------------------------------------装备相关 --END
-- 根据服务器数据设置每个上阵武将战力
function TeamData:setKnightsPower( data )
	for i = 1,#data do
		local key = KNIGHT_KEY..tostring(data[i].id)
		self._knightDataDic[key].serverData.power = data[i].power
	end
end

--根据流水ID获取武将的战力
function TeamData:getKnigthPowerByID( id )
	-- body
	local total_atk,total_def,total_hp,t = self:getKnightTotalAttrsByID(id)
	local power = self:calcKnightPower(t,id)
	return power
end

--计算战力
function TeamData:calcKnightPower(t,id)
	--if true then return 0 end

	if t == nil then return 0 end
	local knightData = self:getKnightDataByID(id)
	if knightData == nil then return 0 end
	local pos = self:getKnightPosByID(id)
	local atkRate = 1
	local power_value = knightData.cfgData.power_value / 1000
	local skill_level = knightData.serverData.destinyLevel
	local CRIT_POWER_VALUE = knightData.cfgData.crit_power_value / 1000
	local MISS_POWER_VALUE = knightData.cfgData.miss_power_value / 1000
	local PARRY_POWER_VALUE = knightData.cfgData.parry_power_value / 1000
	-- if knightData.serverData.instrumentRank > 0 then
	-- 	local info = require("app.cfg.parameter_info").get(176)
	-- 	assert(info,"parameter_info can't find id = 176")
	-- 	atkRate = tonumber(info.content)
	-- end

	--tempcode
	--local skillValue = knightData.cfgData.skill_value

	local total_atk = math.floor((1 + t.attack_percent)*t.attack)
	local total_def = math.floor((1 + t.defense_percent)*t.defense)
	local total_hp = math.floor((1 + t.hp_percent)*t.hp)
	
	-- ($HP+12.7925*$ATTACK+14.7925*$DEFENSE)*$POWER_VALUE*(1+$HURT_PERCENT+$DEFEND_PERCENT)*(1+(($HIT-1)
	-- 	/($HIT+9)+$MISS/(10+$MISS))*$CRIT*($CRIT_HURT+0.2+$DEFEND_CRIT_HURT)*min($PARRY,1)*min($PARRY_VALUE-0.2,0.9))*(1+($SKILL_LEVEL-1)*0.005)/4
	-- 旧版-- local power = (total_hp+total_atk*12.7925+total_def*12.7925)*((1 + t.hurt_percent + t.defend_percent) * (1 + t.hit + t.miss) * (1 + (t.crit + t.defend_crit) * (t.crit_hurt + t.defend_crit_hurt))* (1+t.parry*0.5))^0.01
	
	-- 旧版2--
	-- local power = (total_hp + 12.7925 * total_atk + 14.7925 * total_def) 
	-- * power_value 
	-- * (1 + t.hurt_percent + t.defend_percent) 
	-- * (
	-- 	1+((t.hit - 1)/(t.hit + 9) + t.miss / (10 + t.miss)) 
	-- 	* t.crit * (t.crit_hurt + 0.2 + t.defend_crit_hurt) 
	-- 	* math.min(t.parry,1) 
	-- 	* math.min(t.parry_value - 0.2,0.9)
	-- 	) 
	-- * (1 + (skill_level - 1) * 0.005) / 4 

	-- ($HP+12.7925*$ATTACK+14.7925*$DEFENSE)
	-- *$POWER_VALUE
	-- *(1+$HURT_PERCENT*0.5+$DEFEND_PERCENT*0.8)
	-- *(1+$CRIT*0.55+0.12*$CRIT_HURT+0.05*$DEFEND_CRIT_HURT)
	-- *(1+($HIT-1)/($HIT+9))
	-- *(1+0.75*$MISS)
	-- *(1+min($PARRY,1)*0.45+0.15*min($PARRY_VALUE,0.9))
	-- *(1+($SKILL_LEVEL-1)*0.005)*0.9/4

	-- local power = (total_hp + 12.7925 * total_atk + 14.7925 * total_def) 
	-- * power_value 
	-- * (1 + t.hurt_percent*0.5 + t.defend_percent*0.8) 
	-- * (1 + t.crit*0.55 + 0.12*t.crit_hurt + 0.05*t.defend_crit_hurt)
	-- * (1+(t.hit - 1)/(t.hit + 9))
	-- * (1 + 0.75*t.miss)
	-- * (1+math.min(t.parry,1)*0.45+0.15* math.min(t.parry_value,0.9))
	-- * (1 + (skill_level - 1) * 0.005)*0.9/ 4

	
	local power = (12.7925*total_atk*(1+t.final_attack_percent)*
					(1+(knightData.cfgData.hurt_power_value/1000)*t.hurt_percent)* 
		   			(1+0.6*t.final_hurt_percent)*(1+0.1*0+0.1*t.defend_parry_value)*
		   			(1+t.crit*(t.crit_hurt-1)*CRIT_POWER_VALUE)
		   			*(1+(t.hit-1)/(t.hit+9))+(total_hp*0.7*(1+t.final_hp_percent)+
		   			12.7925*total_def*(1+t.final_defense_percent))*
		   			(1+(knightData.cfgData.defend_power_value/1000)*
		   			t.defend_percent)*(1+0.4*t.final_defense_percent)*
		   			(1+0.05*t.defend_crit_hurt)*(1+0.75*t.miss*MISS_POWER_VALUE)
		   			*(1+math.min(t.parry,1)*math.min(t.parry_value,0.9)
		   			*PARRY_POWER_VALUE))*power_value*(1+(skill_level-1)*0.005)
		   			*(1+0.15*(t.common_skill_percent)+
		   			0.1*(t.special_skill_percent))/3 * 1.02       

	--local equipAwakePowerAdd = self:getPosEquipAwakenPowerAdd(pos)
	--power = equipAwakePowerAdd + power

	-- dump(knightData.serverData.power)
	-- dump(knightData)
	print("战力统计：==================",total_atk,total_def,total_hp,power)
	-- dump(t)
	return math.floor(power)
end

--获取装备觉醒额外的战力提升
function TeamData:getPosEquipAwakenPowerAdd( pos )
	-- body
	local power = 0
	local resData = self:getPosResourcesByFlag(pos, 1)
	if resData == nil then return power end
	for i=1,4 do
		local eid = resData[SLOT_KEY..tostring(i)]
		if eid ~= nil and eid > 0 then
			local equipData = G_Me.equipData:getEquipInfoByID(eid)
			local baseId = equipData.serverData.base_id
			if equipData ~= nil then
				local star = equipData.serverData.star or 0
				local subPower = 0
				-- for i=1,star do
				-- 	local awakenInfo = require("app.cfg.equipment_awaken_info").get(baseId,i)
				-- 	assert(awakenInfo,string.format("equipment_awaken_info can't find id = %d,star = %d",baseId,i))
				-- 	if awakenInfo.awaken_power > 0 then
				-- 		subPower = awakenInfo.awaken_power
				-- 	end
				-- end
				power = power + subPower
			end
		end
	end
	
	return power
end

--根据阵位id获取武将的战力
--仅计算某些培养类型 0 全部计算  1 不计算装备 2不计算宝物  3不计算强化大师
function TeamData:getKnigthPowerByPosAndDevType( pos, devType, attrTable )
	-- body
	local knightData = self:getKnightDataByPos(pos)
	if knightData == nil then return 0 end

	devType = devType or 0

	local function getKnightAttrsByPos(id, devType, attrTable)
		-- dump(attrTable)
		local tAttr = attrTable or self:_createAttrTable()
		self:getKnightBaseAttrsByID(id,tAttr) -- 武将基础属性 （升级、突破）
		self:getKnightAssociationAttrsByID(id,tAttr) -- 缘分
		--self:getKnightInstrumentAttrsByID(id,tAttr) -- 法宝
		self:getKnightDestinyAttrsByID(id,tAttr) -- 天命
		self:getUserBibleAttrs(id,tAttr)--西游真经
		self:getGuildSkillAttrs(id,tAttr)--帮派技能

		if devType == 1 then --装备
			--self:getKnightEquipsTotalAttrsByID(id,tAttr)
			self:getKnightTreasureAttrsByID(id,tAttr) -- 宝物
		elseif devType == 2 then  --宝物
			self:getKnightEquipsTotalAttrsByID(id,tAttr) -- 装备
			--self:getKnightTreasureAttrsByID(id,tAttr) -- 宝物
		else
			self:getKnightEquipsTotalAttrsByID(id,tAttr) -- 装备（强化、精炼、套装）
			self:getKnightTreasureAttrsByID(id,tAttr) -- 宝物

		end

		return tAttr
	end

	local t =  getKnightAttrsByPos(knightData.serverData.id, devType, attrTable)

	return self:calcKnightPower(t,knightData.serverData.id)
	
end

----------------------------------------------------战力属性计算相关

function TeamData:_createAttrTable()
	local t = {
		hp = 0,--生命
		attack = 0,--攻击
		defense = 0,--防御
		hp_percent = 0,--生命加成
		attack_percent = 0,--攻击加成
		defense_percent = 0,--防御加成
		hurt_percent = 0,--伤害加成
		defend_percent = 0,--伤害减免
		hit = 1,--命中率
		miss = 0,--闪避率
		crit = 0,--暴击率
		defend_crit = 0,--抗暴率
		crit_hurt = tonumber(Parameter_info.get(322).content)/1000,--暴击伤害 
		defend_crit_hurt = 0,--韧性
		parry = 0,--格挡率
		cure = 1,--治疗率
		cured = 0,--被治疗率
		dot_poison = 0,--中毒增伤
		defend_dot_poison = 0,--中毒减伤
		dot_fire = 0,--灼烧增伤
		defend_dot_fire = 0,--灼烧减伤
		self_cure = 0,--自愈
		drain_life = 0,--吸血
		defend_drain_life = 0,--吸血抗性
		hurt_back = 0,--反弹率
		retaliation = 0, --反击率
		holy_attack = 0, --神圣伤害
		cure_percent = 0, --自愈比率
		holy_crit = 0,--神圣暴击率
		hurt_back_hurt_percent = 0,--反弹伤害
		parry_value = tonumber(Parameter_info.get(323).content)/1000,	-- 格挡值
		defend_parry_value = 0,   -- 破格挡值
		pierce = 0, -- 穿刺率
		anger = 0,		-- 初始怒气
		ma = 0,
		md = 0,
		pa = 0,
		pd = 0,
		final_hp_percent = 0,   --最终生命 
		final_defense_percent = 0, --最终防御
		final_attack_percent = 0,--最终攻击
		common_skill_percent = 0,
		special_skill_percent = 0,
		final_hurt_percent = 0,
		final_defend_percent = 0,

	}
	return t
end

--返回table {num_atk=0,per_atk=0,num_def=0,per_def=0,num_hp=0,per_hp=0}
function TeamData:_calcAttrAdd( attrType,attrValue,t )
	-- body
	local tAttr = t or self:_createAttrTable()
	if(attrType > 0 and attrValue > 0)then
		local attrInfo = require("app.cfg.attribute_info").get(attrType)
		assert(attrInfo,"attr_info == nil attrType == "..tostring(attrType))
		local enName = string.trim(attrInfo.en_name)
		local addType = attrInfo.type
		local realValue = (addType == 1 and attrValue) or attrValue/1000
		if(enName == "hp")then
			tAttr.hp = tAttr.hp + realValue
		elseif(enName == "hp_percent")then
			tAttr.hp_percent = tAttr.hp_percent + realValue
		elseif(enName == "attack")then
			tAttr.attack = tAttr.attack + realValue
		elseif(enName == "defend_parry_value")then
			tAttr.defend_parry_value = tAttr.defend_parry_value + realValue
		elseif(enName == "attack_percent")then
			tAttr.attack_percent = tAttr.attack_percent + realValue
		elseif(enName == "defense")then
			tAttr.defense = tAttr.defense + realValue
		elseif(enName == "defense_percent")then
			tAttr.defense_percent = tAttr.defense_percent + realValue
		elseif(enName == "hurt_percent")then
			tAttr.hurt_percent = tAttr.hurt_percent + realValue
		elseif(enName == "defend_percent")then
			tAttr.defend_percent = tAttr.defend_percent + realValue
		elseif(enName == "hit")then
			tAttr.hit = tAttr.hit + realValue
		elseif(enName == "miss")then
			tAttr.miss = tAttr.miss + realValue
		elseif(enName == "crit")then
			tAttr.crit = tAttr.crit + realValue
		elseif(enName == "defend_crit")then
			tAttr.defend_crit = tAttr.defend_crit + realValue
		elseif(enName == "crit_hurt")then
			tAttr.crit_hurt = tAttr.crit_hurt + realValue
		elseif(enName == "defend_crit_hurt")then
			tAttr.defend_crit_hurt = tAttr.defend_crit_hurt + realValue
		elseif(enName == "parry")then
			tAttr.parry = tAttr.parry + realValue
		elseif(enName == "cure")then
			tAttr.parry = tAttr.parry + realValue
		elseif(enName == "cured")then
			tAttr.cured = tAttr.cured + realValue
		elseif(enName == "dot_poison")then
			tAttr.dot_poison = tAttr.dot_poison + realValue
		elseif(enName == "defend_dot_poison")then
			tAttr.defend_dot_poison = tAttr.defend_dot_poison + realValue
		elseif(enName == "dot_fire")then
			tAttr.dot_fire = tAttr.parry + realValue
		elseif(enName == "defend_dot_fire")then
			tAttr.defend_dot_fire = tAttr.defend_dot_fire + realValue
		elseif(enName == "self_cure")then
			tAttr.self_cure = tAttr.self_cure + realValue
		elseif(enName == "drain_life")then
			tAttr.drain_life = tAttr.drain_life + realValue
		elseif(enName == "defend_drain_life")then
			tAttr.defend_drain_life = tAttr.defend_drain_life + realValue
		elseif(enName == "hurt_back")then
			tAttr.hurt_back = tAttr.hurt_back + realValue
		elseif(enName == "holy_attack")then
			tAttr.holy_attack = tAttr.holy_attack + realValue
		elseif(enName == "retaliation")then
			tAttr.retaliation = tAttr.retaliation + realValue
		elseif(enName == "cure_percent")then
			tAttr.cure_percent = tAttr.cure_percent + realValue
		elseif(enName == "holy_crit")then
			tAttr.holy_crit = tAttr.holy_crit + realValue
		elseif(enName == "hurt_back_hurt_percent")then
			tAttr.hurt_back_hurt_percent = tAttr.hurt_back_hurt_percent + realValue
		elseif(enName == "ma")then
			tAttr.ma = tAttr.ma + realValue
		elseif(enName == "md")then
			tAttr.md = tAttr.md + realValue
		elseif(enName == "pa")then
			tAttr.pa = tAttr.pa + realValue
		elseif(enName == "pd")then
			tAttr.pd = tAttr.pd + realValue
		elseif(enName == "parry_value")then
			--dump(realValue)
			tAttr.parry_value = tAttr.parry_value + realValue
		elseif(enName == "pierce")then
			tAttr.pierce = tAttr.pierce + realValue
		elseif(enName == "anger")then
			tAttr.anger = tAttr.anger + realValue
		elseif(enName == "common_skill_percent")then
			tAttr.common_skill_percent = tAttr.common_skill_percent + realValue
		elseif(enName == "special_skill_percent")then
			tAttr.special_skill_percent = tAttr.special_skill_percent + realValue
		elseif(enName == "final_hurt_percent")then
			tAttr.final_hurt_percent = tAttr.final_hurt_percent + realValue
		elseif(enName == "final_defend_percent")then
			tAttr.final_defend_percent = tAttr.final_defend_percent + realValue
		elseif(enName == "final_hp_percent")then
			tAttr.final_hp_percent = tAttr.final_hp_percent + realValue
		elseif(enName == "final_defense_percent")then
			tAttr.final_defense_percent = tAttr.final_defense_percent + realValue
		elseif(enName == "final_attack_percent")then
			tAttr.final_attack_percent = tAttr.final_attack_percent + realValue
		end
	end
	return tAttr
end

--根据流水ID获取武将的基础属性 (只计算 升级、突破)
function TeamData:getKnightBaseAttrsByID( id,t )
	local knightData = self:getKnightDataByID(id)
	local tAttr = t or self:_createAttrTable()

	if(knightData ~= nil and knightData.cfgRankData ~= nil)then
		local rankData = knightData.cfgRankData
		local level = knightData.serverData.level - 1
		tAttr.attack = tAttr.attack + rankData.base_attack
		tAttr.attack = tAttr.attack + rankData.develop_attack*level

		tAttr.defense = tAttr.defense + rankData.base_defense
		tAttr.defense = tAttr.defense + rankData.develop_defense*level

		tAttr.hp = tAttr.hp + rankData.base_hp
		tAttr.hp = tAttr.hp + rankData.develop_hp*level

		local knight_rank_info = require("app.cfg.knight_star_info")
		local star = knightData.serverData.starLevel
		-- if(star > 0)then
		-- 	for i=1,star do
		-- 		local info = knight_rank_info.get(knightData.cfgData.knight_id,i)
		-- 		local talentId1 = info.attr_id_1
		-- 		local talentId2 = info.attr_id_2
				
		-- 		if(talentId1 > 0)then
		-- 			local talentInfo1 = require("app.cfg.knight_talent_info").get(talentId1)
		-- 			if(talentInfo1.talent_type == 10)then
		-- 				self:_calcAttrAdd(talentInfo1.attr_type_1,talentInfo1.attr_value_1,tAttr)
		-- 				self:_calcAttrAdd(talentInfo1.attr_type_2,talentInfo1.attr_value_2,tAttr)
		-- 			end
		-- 		end
		-- 		if(talentId2 > 0)then
		-- 			local talentInfo2 = require("app.cfg.knight_talent_info").get(talentId2)
		-- 			if(talentInfo2.talent_type == 10)then
		-- 				self:_calcAttrAdd(talentInfo2.attr_type_1,talentInfo2.attr_value_1,tAttr)
		-- 				self:_calcAttrAdd(talentInfo2.attr_type_2,talentInfo2.attr_value_2,tAttr)
		-- 			end
		-- 		end
		-- 	end
		-- end		
	end
	return tAttr
end

--获取武将自身加成 跟  装备强化  套装加成  缘分加成 （返回总攻击 总防御 总血量）
function TeamData:getKnightTotalAttrsByID( id)
	local tAttr = self:_createAttrTable()
	self:getKnightBaseAttrsByID(id,tAttr) -- 武将基础属性 （升级、突破）
	self:getKnightEquipsTotalAttrsByID(id,tAttr) -- 装备（强化、精炼、套装）
	self:getKnightAssociationAttrsByID(id,tAttr) -- 缘分
	-- self:getKnightGemAttrsByID(id,tAttr) -- 宝石
	self:getKnightTreasureAttrsByID(id,tAttr) -- 兵书
	--self:getKnightInstrumentAttrsByID(id,tAttr) -- 法宝
	--self:getKnightDestinyAttrsByID(id,tAttr) -- 天命
	self:getUserBibleAttrs(id,tAttr)--西游真经
	--self:getGuildSkillAttrs(id,tAttr)--帮派技能
	self:getKnightAwakenAttrsByID(id,tAttr) -- 觉醒属性
	self:getKnightCampBuffAttrsByID(id,tAttr) -- 武将阵营属性 
	self:getKnightExclusiveEquipsTotalAttrsByID(id,tAttr) -- 专属武器
	self:getKnightTalentAttrs(id,tAttr)--天赋属性
	self:getKnightFateTalentAttrs(id,tAttr)--天命天赋属性
	self:getMainRoleFahionAttrs(id,tAttr)--主角时装相关属性
	self:getJewelAttrsByID(id, tAttr)--宝石镶嵌属性

	--dump(tAttr.attack_percent)
	--dump(tAttr.defense_percent)
	--dump(tAttr.hp_percent)	
	local totalAtk = math.floor((1 + tAttr.attack_percent)*tAttr.attack)
	local totalDef = math.floor((1 + tAttr.defense_percent)*tAttr.defense)
	local totalHp = math.floor((1 + tAttr.hp_percent)*tAttr.hp)
	return totalAtk,totalDef,totalHp,tAttr
end

function TeamData:getMainRoleFahionAttrs(id,t)
	-- if self:getKnightPosByID(id) ~= 1 then -- 非主角
	-- 	return
	-- end
	local tAttr = t or self:_createAttrTable()

	local fashionId = G_Me.userData:getFashionId()
	local fashionData = G_Me.fashionData:getFahionDressData(fashionId)
	if fashionData == nil then
		return tAttr
	end

	dump(fashionData.level_train .. " : " .. fashionId)
	if fashionId == 0 then -- 主角时装，属性特殊化处理
		self:_calcAttrAdd(1,tonumber(Parameter_info.get(548).content) * fashionData.level_train ,tAttr)
		self:_calcAttrAdd(2,tonumber(Parameter_info.get(547).content) * fashionData.level_train ,tAttr)
		self:_calcAttrAdd(3,tonumber(Parameter_info.get(549).content) * fashionData.level_train ,tAttr)
		return tAttr
	end

	-- 强化属性
	dump(fashionData.cfg.hp * fashionData.level_train + fashionData.cfg.hp_add)
	dump(fashionData.cfg.attack * fashionData.level_train + fashionData.cfg.attack_add)
	dump(fashionData.cfg.defense * fashionData.level_train + fashionData.cfg.defense_add)
	self:_calcAttrAdd(1,fashionData.cfg.hp * fashionData.level_train + fashionData.cfg.hp_add,tAttr)
	self:_calcAttrAdd(2,fashionData.cfg.attack * fashionData.level_train + fashionData.cfg.attack_add,tAttr)
	self:_calcAttrAdd(3,fashionData.cfg.defense * fashionData.level_train + fashionData.cfg.defense_add,tAttr)

	--天赋属性
	local talent = jobchange_talent_info.get(fashionData.cfg.talent)
	for i=1,20 do
		local level = talent["talent_lv" .. i]
		if level > fashionData.level_train then -- 未激活
			break
		end
		
		self:_calcAttrAdd(talent["talent_type" .. i],talent["talent_value" .. i],tAttr)
	end
	dump(tAttr)
	return tAttr
end

function TeamData:getKnightCampBuffAttrsByID(id,t, campBuffData)
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	local group = self:hasCampBuff()
	if group ~= nil and knightData then--and knightData.cfgData.group == group then
		-- 获取配置表数据
		local campBuffInfoMap = {}
		local len = CampBuffInfo.getLength()
		for i=1,len do
			local info = CampBuffInfo.indexOf(i)
			campBuffInfoMap[info.group] = info
		end

		local campData = G_Me._campBuffData:getData()
		for i = 1,3 do -- 增加属性
			self:_calcAttrAdd(campBuffInfoMap[group]["type"..i],campBuffInfoMap[group]["value"..i] + campBuffInfoMap[group]["group" .. i]*(campData.strength_level - 1),tAttr)
		end
	end

	return tAttr
end

-- 获取觉醒所加属性
function TeamData:getKnightAwakenAttrsByID(id,t)
	local tAttr = t or self:_createAttrTable()
	local awakenHp,awakenAttack,awakenDefence = require("app.scenes.team.TeamUtils").calculateAwakenAttr(id)

	self:_calcAttrAdd(1,awakenHp,tAttr)
	self:_calcAttrAdd(2,awakenAttack,tAttr)
	self:_calcAttrAdd(3,awakenDefence,tAttr)
	dump({awakenHp,awakenAttack,awakenDefence,id})
	return tAttr
end

function TeamData:getGuildSkillAttrs(id,t)
	local tAttr = t or self:_createAttrTable()
	local myGuildSkillList = G_Me.guildData:getMySkillList() or {}
	for i=1,#myGuildSkillList do
		-- local skillItem = myGuildSkillList[i]
		-- local info = require("app.cfg.guild_skill").get(skillItem.id,skillItem.level)
		-- assert(info,string.format("guild_skill can't find id = %d, level = %d",skillItem.id,skillItem.level))
		-- self:_calcAttrAdd(info.skill_type,info.skill_value,tAttr)
	end
	return tAttr
end

function TeamData:getUserBibleAttrs(id,t)
	local tAttr = t or self:_createAttrTable()
	local list = G_Me.userBibleData:getBibleActiveAttrsList()
	--dump(list)
	local attr = {0,0,0}
	for i=1,#list do
		local cfg = hero_token_info.get(i)
		for j=1,3 do
			attr[j] = attr[j] + cfg["attr_" .. j]
		end
	end

	for i=1,3 do
		self:_calcAttrAdd(i,attr[i],tAttr)
	end

	return tAttr
end

-- 获取天赋属性
function TeamData:getKnightTalentAttrs( id,t )
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)

	if knightData then
		local starLevel = knightData.serverData.starLevel
		local cfgFashion = jobchange_info.get(G_Me.userData:getFashionId())
		local job = (knightData.cfgData.type == 1 and cfgFashion) and cfgFashion.role_type or knightData.cfgData.job
		--local cfgTalent = knight_star_talent_info.get(self._knightData.cfgData.job,self._knightData.cfgData.quality)
		dump(job .. " : " .. knightData.cfgData.type .. " : " .. knightData.cfgData.knight_id)
		local cfgTalent = knight_star_talent_info.get(knightData.cfgData.type == 1 and job or knightData.cfgData.knight_id)
		--local cfgTalent = knight_star_talent_info.get(knightData.cfgData.job,knightData.cfgData.quality)
		if(cfgTalent ~= nil)then
			local _,starLevel = require("app.scenes.team.TeamUtils").level2starName( knightData.serverData.starLevel ,knightData.serverData.base_id) 
			for i=1,10 do
				if starLevel < i then break end

				for j=1,3 do
					if cfgTalent["talent"..i.."_type" .. j] < 900 then
						self:_calcAttrAdd(cfgTalent["talent"..i.."_type" .. j],cfgTalent["talent"..i.."_value" .. j],tAttr)
					end
				end				
			end
		end
	end
	
	return tAttr
end

-- 获取天命天赋属性
function TeamData:getKnightFateTalentAttrs( id,t )
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)

	if knightData then
		for i=1,7 do
			local cfgTalent = skill_talent_info.get(knightData.cfgData.job,knightData.cfgData.quality,i)
			if(cfgTalent ~= nil)then

				-- 等级未到
				if knightData.serverData.destinyLevel < cfgTalent.skill_level then
					break
				end

				--local _,starLevel = require("app.scenes.team.TeamUtils").level2starName( knightData.serverData.starLevel ,knightData.serverData.base_id) 
				for j=1,3 do
					--if starLevel < i then break end
					self:_calcAttrAdd(cfgTalent["talent_type" .. j],cfgTalent["talent_value" .. j],tAttr)
				end
			end
		end
	end
	
	return tAttr
end

-- 获取装备升阶属性
function TeamData:getKnightEquipUpstarTalentByID( id,t )
    local equipment_star_talent_info = require("app.cfg.equipment_star_talent_info")
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local equipData = G_Me.equipData

	if(pos > 0)then
		local tEquips = self:getPosResourcesByFlag(pos,1)
		if(tEquips ~= nil)then
			for i=1,4 do
				local eID = tEquips["slot_"..tostring(i)]
				if(eID and eID>0)then
					local eInfo = equipData:getEquipInfoByID(eID)
					
					-- for i=1,#eInfo.serverData.star do
					-- 	local cfg = equipment_star_info.get(eInfo.cfgData.type,eInfo.cfgData.quality,eInfo.serverData.star)
					-- 	self:_calcAttrAdd(cfg.attribute_type_1,cfg.attribute_value1,tAttr)
					-- 	self:_calcAttrAdd(cfg.attribute_type_2,cfg.attribute_value2,tAttr)
					-- end

					if(eInfo ~= nil)then
						for i=1,5 do
							local cfgTalent = equipment_star_talent_info.get(eInfo.cfgData.id)
							if(cfgTalent ~= nil)then

								-- 等级未到
								if eInfo.serverData.star < cfgTalent["talent" .. i .. "_level"] then
									break
								end

								--local _,starLevel = require("app.scenes.team.TeamUtils").level2starName( knightData.serverData.starLevel ,knightData.serverData.base_id) 
								for j=1,3 do
									--if starLevel < i then break end
									self:_calcAttrAdd(cfgTalent["talent" .. i .. "_type" .. j],cfgTalent["talent" .. i .. "_value" .. j],tAttr)
								end
							end
						end
						-- local cfg = equipment_star_info.get(eInfo.cfgData.type,eInfo.cfgData.quality,eInfo.serverData.star)
						-- self:_calcAttrAdd(cfg.attribute_type_1,cfg.attribute_value1,tAttr)
						-- self:_calcAttrAdd(cfg.attribute_type_2,cfg.attribute_value2,tAttr)
					end
				end
			end
		end
	end
	return tAttr
end

--兵书属性加成计算
function TeamData:getKnightTreasureAttrsByID( id,t )
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	local pos = self:getKnightPosByID(id)
	local resData = self:getPosResourcesByFlag(pos, 2)
	if(resData ~= nil)then
		for i=1,2 do
			local treasureId = resData["slot_"..tostring(i)]
			if(treasureId ~= nil and treasureId > 0)then
				local treasureData = G_Me.bookWarData:getbookWarInfoByID(treasureId)
				local treasureInfo = treasureData.cfgData
				--local treasureInfo = require('app.cfg.treasure_info').get(treasureData.base_id)
				--assert(treasureInfo,"treasure_info can't find id == "..tostring(treasureData.base_id))
				local strengthValue1 = treasureInfo.strength_value_1 + (treasureData.serverData.level - 1)*treasureInfo.strength_growth_1
				self:_calcAttrAdd(treasureInfo.strength_type_1,strengthValue1,tAttr)

				local strengthValue2 = treasureInfo.strength_value_2 + (treasureData.serverData.level - 1)*treasureInfo.strength_growth_2
				self:_calcAttrAdd(treasureInfo.strength_type_2,strengthValue2,tAttr)

				local strengthValue3 = treasureInfo.strength_value_3 + (treasureData.serverData.level - 1)*treasureInfo.strength_growth_3
				self:_calcAttrAdd(treasureInfo.strength_type_3,strengthValue3,tAttr)

				local purifyValue1 = (treasureData.serverData.refine_level)*treasureInfo.advance_growth_1
				self:_calcAttrAdd(treasureInfo.advance_type_1,purifyValue1,tAttr)

				local purifyValue2 = (treasureData.serverData.refine_level)*treasureInfo.advance_growth_2
				self:_calcAttrAdd(treasureInfo.advance_type_2,purifyValue2,tAttr)

				-- 基础属性
				self:_calcAttrAdd(treasureInfo.base_type,treasureInfo.base_value,tAttr)

				--天赋
				local talentID = treasureInfo.talent_1
				if talentID > 0 then
					local talentInfo = bookwar_talent_info.get(talentID)
					for j = 1,10 do
						if talentInfo["talent".. j .. "_open"] <= treasureData.serverData.refine_level then
							self:_calcAttrAdd(talentInfo["talent".. j .. "_type1"],talentInfo["talent".. j .. "_value1"],tAttr)
							self:_calcAttrAdd(talentInfo["talent".. j .. "_type2"],talentInfo["talent".. j .. "_value2"],tAttr)
						end
					end
				end
				
			end
		end
	end
	return tAttr
end

function TeamData:getJewelAttrsByID( id, t )
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	local pos = self:getKnightPosByID(id)
	local resData = self:getPosResourcesByFlag(pos, 5)
	local hasWuXing = G_Me.jewelData:isFiveElementFull(pos) --是否有五行buff
	local jewel_buff_info = require("app.cfg.jewel_buff_info")
	if(resData)then
		for i = 1, 7 do
			if(resData["slot_" .. i] and resData["slot_" .. i] > 0)then
				local jewelData = G_Me.jewelData:getJewelDataById(resData["slot_" .. i])
				if(jewelData)then
					local jewelCfg = jewel_info.get(jewelData.base_id)
					if(jewelCfg)then
						if(hasWuXing and i >= 6)then
							for j = 1, 3 do
								if(jewelCfg["attribute_id_" .. j] > 0)then
									local value = jewelCfg["initial_attribute_" .. j] + tonumber(jewelCfg["level_add_attribute_" .. j]) * (jewelData.strength_level - 1)
									self:_calcAttrAdd(jewelCfg["attribute_id_" .. j], value, tAttr)
								end
							end
						elseif(i < 6)then
							for j = 1, 3 do
								if(jewelCfg["attribute_id_" .. j] > 0)then
									local value = jewelCfg["initial_attribute_" .. j] + tonumber(jewelCfg["level_add_attribute_" .. j]) * (jewelData.strength_level - 1)
									self:_calcAttrAdd(jewelCfg["attribute_id_" .. j], value, tAttr)
								end
							end							
						end
					end
				end
			end
		end
	end		

	if(resData)then
		local min = 99
		local quality2Index = {[5] = 1, [8] = 2, [10] = 3, [15] = 4, [18] = 5}
		local hasWuXing = G_Me.jewelData:isFiveElementFull(pos) --是否有五行buff
		if(hasWuXing)then
			for i = 1, 5 do
				local id = resData["slot_" .. i] 
				local data = G_Me.jewelData:getJewelDataById(id)
				local cfg = jewel_info.get(data.base_id)
				min = math.min(cfg.quality, min)
			end		

			min = quality2Index[min]
			local buffCfg = jewel_buff_info.get(min)
			for i = 1, 3 do
				self:_calcAttrAdd(buffCfg["attribute_type_" .. i], buffCfg["attribute_value_" .. i], tAttr)
			end
		end

		local hasLong = false
		if(resData["slot_" .. 6] and resData["slot_" .. 6] > 0 and resData["slot_" .. 7] and resData["slot_" .. 7] > 0 and hasWuXing)then
			hasLong = true
			min = 99
			for i = 6 , 7 do
				local id = resData["slot_" .. i]
				local data = G_Me.jewelData:getJewelDataById(id)
				local cfg = jewel_info.get(data.base_id)
				min = math.min(cfg.quality, min)
			end

			min = quality2Index[min]
			local buffCfg = jewel_buff_info.get(min + 5)
			for i = 1, 3 do
				self:_calcAttrAdd(buffCfg["attribute_type_" .. i], buffCfg["attribute_value_" .. i], tAttr)
			end
		end
	end

	return tAttr
end

--获取装备加成
function TeamData:getKnightEquipsTotalAttrsByID( id,t )
	local tAttr = t or self:_createAttrTable()
	self:getKnightEquipEnhanceAttrsByID(id,tAttr)
	self:getKnightEquipSuitAttrsByID(id,t)
	self:getKnightEquipRefineAttrsByID(id,t)
	self:getKnightEquipUpstarByID(id,t)
	self:getKnightEquipUpstarTalentByID(id,t)
	--dump(t)
	return tAttr
end

--获取专属装备加成
function TeamData:getKnightExclusiveEquipsTotalAttrsByID( id,t )
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	local pos = self:getKnightPosByID( id )
	local exData = self:getPosResourcesByFlag(pos,4)
	if exData ~= nil then
		--dump(exId)
		local exId = exData.slot_1
		if exId ~= 0 then
			local exData = G_Me.equipData:getExEquipInfoByID(exId)
			local isAct = EquipCommon.isExActivated(exId)
			local exInfo = exclusive_info.get(exData.serverData.base_id)
			local cfgStar = exclusive_star_info.get(exData.serverData.star,exData.cfgData.job,exData.cfgData.quality)
			-- 装备获得属性
			for i=1,3 do
				--基础属性
				if i < 3 and exInfo["basic_type_" .. i] > 0 then
					self:_calcAttrAdd(exInfo["basic_type_" .. i],exInfo["basic_value_" .. i],tAttr)
				end
				-- 强化属性
				if exInfo["strength_type_" .. i] ~= 0 then
					--dump(exInfo["strength_type_" .. i])
					--dump(exInfo["strength_value_" .. i])
					self:_calcAttrAdd(exInfo["strength_type_" .. i],exInfo["strength_value_" .. i],tAttr)
				end

				-- 激活属性
				if isAct and exInfo["attribute_type_" .. i] ~= 0 then
					self:_calcAttrAdd(exInfo["attribute_type_" .. i],exInfo["attribute_value_" .. i],tAttr)
				end

			    -- 星级属性
				self:_calcAttrAdd(exInfo["strength_type_" .. i],cfgStar["base_add_value" .. i],tAttr)
			end

			-- 天赋属性
			if knightData.cfgData.knight_id == exInfo.knight_id or (knightData.cfgData.type == 1 and exInfo.job == 1) then
				local index = 1
				while exclusive_info.hasKey("exclusive_skill_level_"..index) do
					if exData.serverData.star < exInfo["exclusive_skill_level_"..index] then
						break
					end
					local skill = exclusive_skill_info.get(exInfo["exclusive_skill_id_"..index])
					local index2 = 1
					while exclusive_skill_info.hasKey("attribute_type_" .. index2) do
						self:_calcAttrAdd(skill["attribute_type_" .. index2],skill["attribute_value_" .. index2],tAttr)
						index2 = index2 + 1
					end
					index = index + 1
				end
			end
		end
	end

	return tAttr
end

-- 装备升星
function TeamData:getKnightEquipUpstarByID( id,t )
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local equipData = G_Me.equipData

	if(pos > 0)then
		local tEquips = self:getPosResourcesByFlag(pos,1)
		if(tEquips ~= nil)then
			for i=1,4 do
				local eID = tEquips["slot_"..tostring(i)]
				if(eID and eID>0)then
					local eInfo = equipData:getEquipInfoByID(eID)
					
					-- for i=1,#eInfo.serverData.star do
					-- 	local cfg = equipment_star_info.get(eInfo.cfgData.type,eInfo.cfgData.quality,eInfo.serverData.star)
					-- 	self:_calcAttrAdd(cfg.attribute_type_1,cfg.attribute_value1,tAttr)
					-- 	self:_calcAttrAdd(cfg.attribute_type_2,cfg.attribute_value2,tAttr)
					-- end

					if(eInfo ~= nil)then
						local cfg = equipment_star_info.get(eInfo.cfgData.type,eInfo.cfgData.quality,eInfo.serverData.star)
						self:_calcAttrAdd(cfg.attribute_type_1,cfg.attribute_value1,tAttr)
						self:_calcAttrAdd(cfg.attribute_type_2,cfg.attribute_value2,tAttr)
					end
				end
			end
		end
	end
	return tAttr
end

-- 获取装备洗练属性
function TeamData:getKnightEquipRefineAttrsByID( id,t )
	--dump(" TeamData:getKnightEquipRefineAttrsByID( id,t )")
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local equipData = G_Me.equipData
	local equip_random = require("app.cfg.equipment_random_info")
    local attribute_info = require("app.cfg.attribute_info")

	if(pos > 0)then
		local tEquips = self:getPosResourcesByFlag(pos,1)
		if(tEquips ~= nil)then
			for i=1,4 do -- 4个装备位置
				local eID = tEquips["slot_"..tostring(i)]
				if(eID and eID>0)then
					local eInfo = equipData:getEquipInfoByID(eID)

					-- 计算精炼属性
					local svrData = eInfo.serverData
					local cfgData = eInfo.cfgData
					for i = 1, EquipCommon.REFINE_ATTR_NUM do -- 2条精炼属性
			            if cfgData["refining_type_"..i] > 0 then
			                local description = attribute_info.get(cfgData["refining_type_"..i])
			                if description then  
			                    local enhance_value = cfgData["refining_value_"..i]
			                    local enhance_growth = cfgData["refining_growth_"..i]
			                    local enhanceValue = enhance_value+(svrData.refine-1)*enhance_growth   

			                    local enhance_type = description["id"]
								self:_calcAttrAdd(enhance_type,enhanceValue,tAttr)
			                end
			            end
			        end

					for j = 1,EquipCommon.XILIAN_ATTR_NUM do -- 5条洗练属性
						local equipAttr = rawget(eInfo.serverData,"rand_attr_"..tostring(j))
						if equipAttr ~= nil then
							local attrId = equip_random.get(equipAttr.id).attr_id
							--dump(i)
							--dump(attrId)
							--dump(equipAttr.attr_value)

							--因为浮点数转换问题，前端数据会有误差，所以先操作使数据保持和服务器统一
							--dump(equipAttr.attr_value)
			                local attr_value = equipAttr.attr_value
			                attr_value = attr_value * 100
			                if (attr_value/10) % 1 ~= 0 then
			                    attr_value = attr_value - attr_value%1
			                end
			                attr_value = math.round(attr_value/10)/10
							--dump(attr_value)

							-- 计算洗练属性 
                			local growthInfo = equip_random.get(equipAttr.id)
                			assert(growthInfo,"equip_random_info data error id = "..equipAttr.id)
		            		local refine_value = attr_value +(svrData.refine * growthInfo.grow * attr_value)
		            		local refine_growth = tonumber(growthInfo.grow)*attr_value
		            		--dump(refine_value)
		            		local transValue = math.floor(refine_value * 10)
		            		refine_value = transValue/10--math.floor(refine_value)
							self:_calcAttrAdd(attrId,refine_value,tAttr)
						end
					end
				end
			end
		end
	end
end

--获取装备强化加成
function TeamData:getKnightEquipEnhanceAttrsByID( id,t )
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local equipData = G_Me.equipData

	if(pos > 0)then
		local tEquips = self:getPosResourcesByFlag(pos,1)
		if(tEquips ~= nil)then
			for i=1,4 do
				local eID = tEquips["slot_"..tostring(i)]
				if(eID and eID>0)then
					local eInfo = equipData:getEquipInfoByID(eID)
					
					if(eInfo ~= nil)then
						local addValue1 = eInfo.cfgData.enhance_value_1 + (eInfo.serverData.level-1)*eInfo.cfgData.enhance_growth_1
						self:_calcAttrAdd(eInfo.cfgData.enhance_type_1,addValue1,tAttr)

						local addValue2 = eInfo.cfgData.enhance_value_2 + (eInfo.serverData.level-1)*eInfo.cfgData.enhance_growth_2
						self:_calcAttrAdd(eInfo.cfgData.enhance_type_2,addValue2,tAttr)
						
					end

					-- local awakenInfo = eInfo.awakenData
					-- if awakenInfo ~= nil then
					-- 	self:_calcAttrAdd(awakenInfo.awaken_type_1,awakenInfo.awaken_value_1,tAttr)
					-- 	self:_calcAttrAdd(awakenInfo.awaken_type_2,awakenInfo.awaken_value_2,tAttr)
					-- 	self:_calcAttrAdd(awakenInfo.awaken_attribute_type,awakenInfo.awaken_attribute_value,tAttr)
					-- end
				end
			end
		end
	end

	return tAttr
end

--获取战斗阵位上的套装详情
function TeamData:getPosSuitsDetail( pos )
	-- body
	local tEquips = self:getPosResourcesByFlag(pos,1)
	local tSuits = {}
	if(tEquips ~= nil)then
		for i=1,4 do
			local eID = tEquips[SLOT_KEY..tostring(i)]
			if(eID and eID > 0)then
				local eInfo = G_Me.equipData:getEquipInfoByID(eID)
				if(eInfo ~= nil)then
					local suitId = eInfo.cfgData.suit_id
					if(suitId > 0)then
						local key = "t_"..tostring(suitId) -- 不要修改这个key
						if(tSuits[key] == nil)then 
							tSuits[key] = {suitId = suitId,num = 1}
						else
							tSuits[key].num = tSuits[key].num + 1
						end
					end
				end
			end
		end
	end

	return tSuits
end

--获取装备套装加成
function TeamData:getKnightEquipSuitAttrsByID( id,t )
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local tSuits = self:getPosSuitsDetail(pos) or {}
	--dump(tSuits)

	for k,v in pairs(tSuits) do
		local suitInfo = require("app.cfg.equipment_suit_info").get(v.suitId)
		if suitInfo == nil then
			return tAttr
		end
		assert(suitInfo,"equipment_suit_info can't find  suitId = "..tostring(v.suitId))
		if(v.num == 2)then
			self:_calcAttrAdd(suitInfo.two_suit_type_1,suitInfo.two_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.two_suit_type_2,suitInfo.two_suit_value_2,tAttr)
		elseif(v.num == 3)then
			self:_calcAttrAdd(suitInfo.two_suit_type_1,suitInfo.two_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.two_suit_type_2,suitInfo.two_suit_value_2,tAttr)
			self:_calcAttrAdd(suitInfo.three_suit_type_1,suitInfo.three_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.three_suit_type_2,suitInfo.three_suit_value_2,tAttr)
			-- dump(suitInfo.three_suit_type_1)
			-- dump(suitInfo.three_suit_value_1)
			-- dump(suitInfo.three_suit_type_2)
			-- dump(suitInfo.three_suit_value_2)
		elseif(v.num == 4)then
			self:_calcAttrAdd(suitInfo.two_suit_type_1,suitInfo.two_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.two_suit_type_2,suitInfo.two_suit_value_2,tAttr)
			self:_calcAttrAdd(suitInfo.three_suit_type_1,suitInfo.three_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.three_suit_type_2,suitInfo.three_suit_value_2,tAttr)
			self:_calcAttrAdd(suitInfo.four_suit_type_1,suitInfo.four_suit_value_1,tAttr)
			self:_calcAttrAdd(suitInfo.four_suit_type_2,suitInfo.four_suit_value_2,tAttr)
		end
	end

	return tAttr
end

--计算武将缘分属性加成
function TeamData:getKnightAssociationAttrsByID( id,t )
	local list = self:getKnightAssociationInfoListByID(id)

	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	if(knightData ~= nil)then
		--local activeAssList = knightData.serverData.association or {}
		for i=1,#list do
			--local id = activeAssList[i]
			if list[i].isActive then
				--local itemInfo = require("app.cfg.association_info").get(id)
				--assert(itemInfo,"association_info can't find id == "..tostring(id))
				self:_calcAttrAdd(list[i].cfgData.type_1,list[i].cfgData.value_1,tAttr)
				self:_calcAttrAdd(list[i].cfgData.type_2,list[i].cfgData.value_2,tAttr)
				self:_calcAttrAdd(list[i].cfgData.type_3,list[i].cfgData.value_3,tAttr)
			end
		end
	end

	return tAttr
end

--获取宝石属性加成
function TeamData:getKnightGemAttrsByID( id,t )
	-- body
	local tAttr = t or self:_createAttrTable()
	local pos = self:getKnightPosByID(id)
	local gemRes = self:getPosResourcesByFlag(pos,3)
	local equipRes = self:getPosResourcesByFlag(pos,1)
	if(gemRes ~= nil)then
		for i=1,4 do
			local gemID = gemRes["slot_"..tostring(i)]
			if(gemID ~= nil and gemID > 0)then
				local gemData = G_Me.gemData:getGem(gemID)
				local gemCfg = gemData.cfgData
				for j=1,4 do
					local addType = gemCfg["effect_type"..tostring(j)]
					local addValue = gemCfg["effect_num"..tostring(j)]
					self:_calcAttrAdd(addType,addValue,t_attr)
				end
			end
		end
	end

	return tAttr
end

--计算武将的天命属性加成
function TeamData:getKnightDestinyAttrsByID( id,t )
	-- body
	local tAttr = t or self:_createAttrTable()
	local knightData = self:getKnightDataByID(id)
	if(knightData ~= nil)then
		-- local destinyLevel = knightData.serverData.destinyLevel
		-- local haloInfo = require("app.cfg.knight_halo_info").get(destinyLevel)
		-- assert(haloInfo,"knight_halo_info can't find level = "..tostring(destinyLevel))

		-- self:_calcAttrAdd(haloInfo.attr_type_1,haloInfo.attr_value_1,tAttr)
		-- self:_calcAttrAdd(haloInfo.attr_type_2,haloInfo.attr_value_2,tAttr)
		-- self:_calcAttrAdd(haloInfo.attr_type_3,haloInfo.attr_value_3,tAttr)
		-- self:_calcAttrAdd(haloInfo.attr_type_4,haloInfo.attr_value_4,tAttr)

	end

	return tAttr
end

-----------------------
-----------------------
--[[
	上阵神将统计相关
]]

function TeamData:getPosKnightLevelSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + knightData.serverData.level
		end
	end

	return num
end

function TeamData:getPosKnightRankSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + knightData.serverData.knightRank
		end
	end

	return num
end

function TeamData:getPosKnightDestinySum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + knightData.serverData.destinyLevel
		end
	end

	return num
end

function TeamData:getPosKnightColorSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + G_TypeConverter.quality2Color(knightData.cfgData.quality)
		end
	end

	return num
end

function TeamData:getPosKnightFaoBaoLevelSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + knightData.serverData.instrumentLevel
		end
	end

	return num
end

function TeamData:getPosKnightFaoBaoRankSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if(knightData ~= nil)then
			num = num + knightData.serverData.instrumentRank
		end
	end

	return num
end

function TeamData:getPosKnightEquipsLevelSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,1)
		if(resData ~= nil)then
			for j=1,4 do
				local eid = resData["slot_"..tostring(j)]
				if(eid ~= nil and eid > 0)then
					local equipData = G_Me.equipData:getEquipInfoByID(eid)
					num = num + equipData.serverData.level
				end
			end
		end
	end

	return num
end

function TeamData:getEquipsLevelSumByPos( pos )
	local num = 0
	local resData = self:getPosResourcesByFlag(pos,1)
	if(resData ~= nil)then
		for j=1,4 do
			local eid = resData["slot_"..tostring(j)]
			if(eid ~= nil and eid > 0)then
				local equipData = G_Me.equipData:getEquipInfoByID(eid)
				num = num + equipData.serverData.level
			end
		end
	end

	return num
end

function TeamData:getPosKnightEquipsRefineSum( ... )
	-- body
	local num = 0
	-- for i=1,6 do
	-- 	local resData = self:getPosResourcesByFlag(i,1)
	-- 	if(resData ~= nil)then
	-- 		for j=1,4 do
	-- 			local eid = resData["slot_"..tostring(j)]
	-- 			if(eid ~= nil and eid > 0)then
	-- 				local equipData = G_Me.equipData:getEquipInfoByID(eid)
	-- 				num = num + equipData.serverData.refine_level
	-- 			end
	-- 		end
	-- 	end
	-- end

	return num
end

function TeamData:getPosKnightEquipsColorSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,1)
		if(resData ~= nil)then
			for j=1,4 do
				local eid = resData["slot_"..tostring(j)]
				if(eid ~= nil and eid > 0)then
					local equipData = G_Me.equipData:getEquipInfoByID(eid)
					num = num + equipData.cfgData.color
				end
			end
		end
	end

	return num
end

function TeamData:getEquipsRankSumByPos( pos )
	local num = 0
	local resData = self:getPosResourcesByFlag(pos,1)
	if(resData ~= nil)then
		for j=1,4 do
			local eid = resData["slot_"..tostring(j)]
			if(eid ~= nil and eid > 0)then
				local equipData = G_Me.equipData:getEquipInfoByID(eid)
				num = num + equipData.cfgData.rank
			end
		end
	end

	return num
end

function TeamData:getPosKnightTreasuresLevelSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,2)
		if(resData ~= nil)then
			for j=1,2 do
				local tid = resData["slot_"..tostring(j)]
				if(tid ~= nil and tid > 0)then
					local treasureData = G_Me.treasureData:getTreasureByID(tid)
					num = num + treasureData.level
				end
			end
		end
	end

	return num
end

function TeamData:getTreasuresLevelSumByPos( pos )
	local num = 0
	local resData = self:getPosResourcesByFlag(pos,2)
	if(resData ~= nil)then
		for j=1,2 do
			local tid = resData["slot_"..tostring(j)]
			if(tid ~= nil and tid > 0)then
				local treasureData = G_Me.treasureData:getTreasureByID(tid)
				num = num + treasureData.level
			end
		end
	end

	return num
end

function TeamData:getPosKnightTreasuresRefineSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,2)
		if(resData ~= nil)then
			for j=1,2 do
				local tid = resData["slot_"..tostring(j)]
				if(tid ~= nil and tid > 0)then
					local treasureData = G_Me.treasureData:getTreasureByID(tid)
					num = num + treasureData.refine_level
				end
			end
		end
	end

	return num
end

function TeamData:getTreasuresRefineSumByPos( pos )
	local num = 0
	local resData = self:getPosResourcesByFlag(pos,2)
	if(resData ~= nil)then
		for j=1,2 do
			local tid = resData["slot_"..tostring(j)]
			if(tid ~= nil and tid > 0)then
				local treasureData = G_Me.treasureData:getTreasureByID(tid)
				num = num + treasureData.refine_level
			end
		end
	end

	return num
end

function TeamData:getPosKnightTreasuresColorSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,2)
		if(resData ~= nil)then
			for j=1,2 do
				local tid = resData["slot_"..tostring(j)]
				if(tid ~= nil and tid > 0)then
					-- local treasureData = G_Me.treasureData:getTreasureByID(tid)
					-- local baseId = treasureData.base_id
					-- local info = require("app.cfg.treasure_info").get(baseId)
					-- assert(info,"treasure_info can't find id = "..tostring(baseId))
					-- num = num + info.color
				end
			end
		end
	end

	return num
end

function TeamData:getPosKnightEquipAwakeSum( ... )
	-- body
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,1)
		if(resData ~= nil)then
			for j=1,4 do
				local eid = resData["slot_"..tostring(j)]
				if(eid ~= nil and eid > 0)then
					local equipData = G_Me.equipData:getEquipInfoByID(eid)
					num = num + equipData.serverData.star
				end
			end
		end
	end

	return num
end

function TeamData:getEquipAwakeSumByPos( pos )
	local num = 0
	local resData = self:getPosResourcesByFlag(pos,1)
	if(resData ~= nil)then
		for j=1,4 do
			local eid = resData["slot_"..tostring(j)]
			if(eid ~= nil and eid > 0)then
				local equipData = G_Me.equipData:getEquipInfoByID(eid)
				num = num + equipData.serverData.star
			end
		end
	end

	return num
end

function TeamData:getPosKnightTreasuresWearSum( ... )
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,2)
		if(resData ~= nil)then
			for j=1,2 do
				local tid = resData["slot_"..tostring(j)]
				if(tid ~= nil and tid > 0)then
					local treasureData = G_Me.treasureData:getTreasureByID(tid)
					if treasureData then
						num = num + 1
					end
				end
			end
		end
	end

	return num
end

function TeamData:getPosKnightEquipWearSum( ... )
	local num = 0
	for i=1,6 do
		local resData = self:getPosResourcesByFlag(i,1)
		if(resData ~= nil)then
			for j=1,4 do
				local eid = resData["slot_"..tostring(j)]
				if(eid ~= nil and eid > 0)then
					local equipData = G_Me.equipData:getEquipInfoByID(eid)
					if equipData ~= nil then
						num = num + 1
					end
				end
			end
		end
	end

	return num
end
------------------------
----------------------

--新增武将 删除武将 更新武将 操作
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--新增武将数据
function TeamData:insertKnights( value )
	-- body
	if(value == nil or type(value) ~= "table")then return end
	if(self._knightDataDic == nil)then return end
	--dump(value)
	for i=1,#value do
		self:_setTeamKnightItem(value[i])
	end
end

--武将数据更新
function TeamData:updateKnights( value )
	-- body
	if(value == nil or type(value) ~= "table")then return end
	if(self._knightDataDic == nil)then return end
	dump(value)
	for i=1,#value do
		self:_setTeamKnightItem(value[i])
	end
end

--武将数据删除
function TeamData:deleteKnights( value )
	-- body
	if(value == nil or type(value) ~= "table")then return end
	if(self._knightDataDic == nil)then return end
	for i=1,#value do
		local id = tostring(value[i])
		local key = KNIGHT_KEY..tostring(id)
		self._knightDataDic[key] = nil
	end
end

-- 我要变强数据
function TeamData:setLastStrengthenInfo( info )
	self._strengthenInfo = info
end

function TeamData:getLastStrengthenInfo()
	if self._strengthenInfo == nil then
		return {pos = 1, power = nil}
	end

	return self._strengthenInfo
end

--获取指定阵位神将的各个养成点的开启情况及培养进度
--isOpen 功能是否开启
--currValue 养成点的当前值
--targetValue 养成点能培养到的最高值
function TeamData:getCultivateProgressByType(cType,pos)
	local isOpen = false
	local currValue,targetValue = 0,0
	local knightData = self:getKnightDataByPos(pos)
	if knightData == nil then return isOpen,currValue,targetValue end
	local userLevel = G_Me.userData.level

	if cType == TeamData.TYPE_KNIGHT_LEVEL then
		--神将升级
		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_KNIGHT_UPGRADE)
		currValue = knightData.serverData.level
		targetValue = G_Me.userData.level

	-- elseif cType == TeamData.TYPE_KNIGHT_RANK then
	-- 	--神将突破
	-- 	isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_KNIGHT_TUPO)
	-- 	currValue = knightData.serverData.knightRank
	-- 	local maxSysRank = knightData.cfgData.max_rank
	-- 	targetValue = currValue
	-- 	local knightLevel = knightData.serverData.level
	-- 	local knightId = knightData.cfgData.knight_id
	-- 	if maxSysRank > 0 then
	-- 		for i = currValue,maxSysRank do
	-- 			local info = require("app.cfg.knight_rank_info").get(knightId,i)
	-- 			print("knightId,i",knightId,i)
	-- 			assert(info,"knight_rank_info can't find id = %d,rank = %d",knightId,i)
	-- 			if info.level_limit <= knightLevel then
	-- 				targetValue = i
	-- 			end
	-- 		end
	-- 	end

	-- elseif cType == TeamData.TYPE_KNIGHT_DESTINY then
	-- 	--神将天命
	-- 	isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_KNIGHT_TIANMING)
	-- 	currValue = knightData.serverData.destinyLevel
	-- 	local len = require("app.cfg.knight_halo_info").getLength()
	-- 	local info = require("app.cfg.knight_halo_info").indexOf(len)
	-- 	local sysMaxLevel = info.level
	-- 	local maxFosterLevel,needUserLevel,errorTips = G_Me.userData:getUserMaxFosterLevel(1)
	-- 	if maxFosterLevel == 9999 then
	-- 		targetValue = sysMaxLevel
	-- 	else
	-- 		targetValue = maxFosterLevel
	-- 	end

	elseif cType == TeamData.TYPE_KNIGHT_FABAO_LEVEL then
		--法宝升级
		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_FABAO_SHENGJI)
		currValue = knightData.serverData.instrumentLevel
		local insId = knightData.cfgData.instrument
		local insType = knightData.cfgData.instrument_type
		if insType ~= 0 then
			local parameterInfo = require("app.cfg.parameter_info").get(136)
			assert(parameterInfo,"parameter_info can't find id = 136")
			targetValue = userLevel * tonumber(parameterInfo.content)
		else
			targetValue = currValue
		end

	-- elseif cType == TeamData.TYPE_KNIGHT_FABAO_AWAKEN then
	-- 	--法宝觉醒
	-- 	isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_FABAO_TUPO)
	-- 	local insId = knightData.cfgData.instrument
	-- 	local insRank = knightData.serverData.instrumentRank
	-- 	local insType = knightData.cfgData.instrument_type
	-- 	local insLevel = knightData.serverData.instrumentLevel
	-- 	local sysMaxRank = 5
	-- 	currValue = insRank
	-- 	targetValue = currValue
	-- 	if insType ~= 0 then
	-- 		targetValue = currValue
	-- 		for i=insRank,sysMaxRank do
	-- 			local insInfo = require("app.cfg.instrument_info").get(insId,insRank)
	-- 			assert(insInfo,string.format("instrument_info can't find id = %d,rank = %d",insId,insRank))
	-- 			if insInfo.level_limit <= insLevel then
	-- 				targetValue = i
	-- 			end
	-- 		end		
	-- 	end
		
	elseif cType == TeamData.TYPE_KNIGHT_EQUIP_LEVEL then

		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIPMENT_ENHANCE)
		local sumLevel = self:getEquipsLevelSumByPos(pos)
		local sysMaxLevel = 300 --TODO
		local paramInfo = require("app.cfg.parameter_info").get(115)
		assert(paramInfo,"parameter_info can't find id = 115")
		currValue = sumLevel/4
		targetValue = userLevel*tonumber(paramInfo.content)

	elseif cType == TeamData.TYPE_KNIGHT_EQUIP_RANK then

		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIPMENT_UPRANK)
		local sumRank = self:getEquipsRankSumByPos(pos)
		local sysMaxRank = 15 --TODO
		currValue = sumRank/4
		targetValue = math.ceil(currValue)

		local itemInfo = require("app.cfg.equipment_info").indexOf(1)
		for i=1,sysMaxRank do
			local equipInfo = require("app.cfg.equipment_info").get(itemInfo.id,i)
			assert(equipInfo,"equipment_info can't find id = %d,rank = %d",itemInfo.id,i)
			if equipInfo.level_limit <= userLevel then
				targetValue = i
			end
		end

	elseif cType == TeamData.TYPE_KNIGHT_EQUIP_AWAKEN then

		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIPMENT_AWAKEN)
		local maxFosterLevel,needUserLevel,errorTips = G_Me.userData:getUserMaxFosterLevel(6)
		local sumAwake = self:getEquipAwakeSumByPos(pos)
		local sysMaxStar = 15 --TODO
		currValue = sumAwake/4

		if maxFosterLevel == 9999 then
			targetValue = sysMaxStar
		else
			targetValue = maxFosterLevel
		end

	elseif cType == TeamData.TYPE_KNIGHT_TREASURE_LEVEL then

		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_TREASURE_ENHANCE)
		local maxFosterLevel,needUserLevel,errorTips = G_Me.userData:getUserMaxFosterLevel(4)
		local sumLevel = self:getTreasuresLevelSumByPos(pos)
		local maxSysLevel = 100 --TODO
		currValue = sumLevel/2

		if maxFosterLevel == 9999 then
			targetValue = maxSysLevel
		else
			targetValue = maxFosterLevel
		end

	elseif cType == TeamData.TYPE_KNIGHT_TREASURE_REFINE then

		isOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_TREASURE_REFINE)
		local maxFosterLevel,needUserLevel,errorTips = G_Me.userData:getUserMaxFosterLevel(5)
		local sumRefine = self:getTreasuresRefineSumByPos(pos)
		local maxSysRefine = 20 --TODO
		currValue = sumRefine/2

		if maxFosterLevel == 9999 then
			targetValue = maxSysRefine
		else
			targetValue = maxFosterLevel
		end
	end

	return isOpen,math.floor(currValue),targetValue
end

-- suNSun start
-- 获取武将形象配置 knightID:后端id
function TeamData:getFigureCfg(knightID)
	local knightInfo = self:getKnightDataByID(knightID)
	--local cfgKnightInfo = require("app.cfg.knight_info").get(knightID)
	local exclusiveInfo = require("app.cfg.exclusive_info").get(knightInfo.cfgData.exclusive_id)

	-- tempCode
	local exclusiveFigure = 0
	local isEquip = true
	if isEquip then
		local exclusiveStarLevel = 2
		exclusiveFigure = require("app.cfg.exclusive_star_info").get(exclusiveStarLevel)
	end
	
	local cfgCharacterPerformanceInfo = require("app.cfg.character_performance_info").get(knightInfo.serverData.knightId,knightInfo.serverData.starLevel,exclusiveFigure) --形象配置
	return cfgCharacterPerformanceInfo
end
-- suNSun end
--有阵营buff
function TeamData:hasCampBuff(pos)
	local CampBuffInfo = require("app.cfg.camp_buff_info")
	local campBuffInfoMap = {}
	local len = CampBuffInfo.getLength()
	local num = 0
	local groupReal = nil
	local redNum = 0 -- 红将数量

	for i=1,len do
		local info = CampBuffInfo.indexOf(i)
		campBuffInfoMap[info.group] = info
	end
	local groupNumMap = {}
	for i=1,6 do
		local knightData = self:getKnightDataByPos(i)
		if knightData ~= nil then
			if knightData.cfgData.quality == 18 then redNum = redNum + 1 end
			local group = knightData.cfgData.group
			CampBuffInfo.get(group)
			if groupNumMap["group_"..group] == nil then
				--groupNumMap["group_"..group] = 1
				groupNumMap["group_"..group] = {knightData.cfgData.knight_id}
			else
				--groupNumMap["group_"..group] = groupNumMap["group_"..group] + 1
				table.insert(groupNumMap["group_"..group],knightData.cfgData.knight_id)
				--num = num + 1
				if campBuffInfoMap[group] and #groupNumMap["group_"..group] >= campBuffInfoMap[group].num then
					groupReal = group
					num = campBuffInfoMap[group].num
					--return group,4
				end
			end
		end
	end

	--阵营Buff未开启时
	if pos and groupReal==nil then
		dump(pos)
		local knightData = self:getKnightDataByPos(pos)
		if knightData == nil then -- 未上阵
			return nil
		end
		local group = knightData.cfgData.group
		num = #groupNumMap["group_"..group]
		--groupReal = nil
	end

	-- 红将限制
	-- if redNum >=2 then
	-- 	groupReal = nil
	-- end

	return groupReal,num
end

--获取阵营buff
function TeamData:getCampBuff()

end

-- 是否可激活主角缘分，如果可以，返回缘分信息
function TeamData:isActivateMainRoleAsso(itemId)
	local knightData = self:getKnightDataByPos(1) -- 获取主角信息
	local assoCfg = require("app.cfg.association_info")
	local isActive = false
	local info = nil
	for i=1,16 do --主角缘分信息
		local assoID = knightData.cfgData["association_"..tostring(i)]
		if assoID > 0 then
			local assoInfo = assoCfg.get(assoID)
			if assoInfo and itemId == assoInfo.info_value_1 then
				isActive = true
				info = assoInfo
				break
			end
		end
	end
	
	return isActive,info
end

-- 判断经验单是否够升级
function TeamData:isCanLevelUp(id)
	local expNeedInfo = TeamUtils.calculateExpLevelUp( knightData.cfgData.knight_id,knightData.serverData.level )
	
end

function TeamData:setTeamLayerInitPos(pos)
	self._initPos = pos
end

function TeamData:getTeamLayerInitPos()
	local initPos = self._initPos
	self._initPos = nil
	return initPos
end

--武将的配置id是否在上阵中出现过
function TeamData:knightCfgIdInMypos( cfgID )
	for i=1,#self._myFormationIDList do
		local id = self._myFormationIDList[i]
		local dataDic = self._knightDataDic[KNIGHT_KEY .. id]
		
		local knight_id = dataDic ~= nil and dataDic.cfgData.knight_id or 0
		if knight_id == cfgID then
			return true
		end
	end
	return false
end

--获取主角性别 1.男2.女
function TeamData:getMasterSex()
	local knightData = self:getKnightDataByPos(1)

	return knightData.cfgData.sex
end

-- 武将升级的最高等级
function TeamData:getMaxLevel()
	local userLevel = G_Me.userData.level
	--local maxLevel = tonumber(require("app.cfg.parameter_info").get(194).content) 

	return userLevel
end

-- 当前材料可使武将升到的最高等级
function TeamData:getEndLvlByUseItem( equipId)
	local eq_data = self:getKnightDataByID(equipId)
	assert(eq_data,"equip data error")

	local curlv = eq_data.serverData.level

	local propData = G_Me.propsData:getItemsForKnightLevelUp()
	--dump(propData)
	if not propData then
		return curlv
	end

	local prop_totalExp = 0
	for k,v in pairs(propData) do
		prop_totalExp = prop_totalExp + v.num*v.info.item_value
	end
	local lvlExp = require("app.scenes.team.TeamUtils").getExpNeed(eq_data.cfgData.knight_id,curlv)
	local needExp = lvlExp - eq_data.serverData.exp
	local limitLvl = self:getMaxLevel()
	-- dump(needExp)
	-- dump(limitLvl)
	while prop_totalExp >= needExp do
		--假升级
		if curlv < limitLvl then
			prop_totalExp = prop_totalExp - needExp

			curlv = curlv + 1
			needExp = require("app.scenes.team.TeamUtils").getExpNeed(eq_data.cfgData.knight_id,curlv)
			-- dump(prop_totalExp)
			-- dump(needExp)
			-- dump(curlv)

		else -- 已到最大等级，手动跳出循环
			prop_totalExp = 0
			needExp = 1
		end
	end

	return curlv
end

--返回数组,格式如下 
--{
--  {  talent_name: 天赋名字，attr_name: 属性类型的名字, value: 属性值文本,open_level:开启等级} ,  
--  {  talent_name: 天赋名字，attr_name: 属性类型的名字, value: 属性值文本,open_level:开启等级} , 
--} 
function TeamData:getFateTalentList(knightId)
	--dump(knightId)
    local data = G_Me.teamData:getKnightDataByID(knightId)
    assert(data,"bookwar data error ..." .. knightId)

    local talentList = {}
    local attribute_info = require("app.cfg.attribute_info")
    local talentData = nil
    local length = skill_talent_info.getLength()
    local currLevel = data.serverData.destinyLevel
    local nextTalentData = nil -- 下一级天赋数据
    local currTalentData = nil -- 这一级天赋数据

    for i=1,7 do
		talentData = skill_talent_info.get(data.cfgData.job,data.cfgData.quality,i)
        local talent_name = talentData["talent_name"]
        local open_level = talentData["skill_level"]
        local description = attribute_info.get(talentData["talent_type1"])

        if description then
            local talent_value = talentData["talent_value1"]
            local num_value = talent_value
            local attr_type = description["type"]

            -- 数值类型：1.绝对值  2.百分比  3.免疫属性 
                
            --免疫属性
            if attr_type == 3 then
                talent_value = ""
            --百分比形式
            elseif attr_type == 2 then
              talent_value = tostring(talent_value/10).."%"
            else
              talent_value = tostring(talent_value)
            end 

            local tbl = {
            	talent_name = talent_name,
                attr_type = attr_type,
                attr_name = description.cn_name,
                value = talent_value,
                num_value = num_value,
                open_level = open_level,
                cur_Level = currLevel,
                index = i,
                attr_desc = talentData.talent_describe
        	}
            table.insert(talentList,tbl)

          	if nextTalentData == nil and open_level > currLevel then
        		nextTalentData = tbl
        	end

        	if currTalentData == nil and open_level == currLevel then
        		currTalentData = tbl
        	end
        end
    end

    return talentList,nextTalentData,currTalentData
end

function TeamData:setEquipTipSwitch(switch)
	self._EquipTipSwitch = switch
end

function TeamData:getEquipTipSwitch()
	return self._EquipTipSwitch or true
end

function TeamData:EnhanceAllEquipment(pos)
	local dataLog = {} -- use to test
	local errTag = nil -- 0. 可以强化 1. 装备未全部穿戴 2. 银两不足 3.已到当前最高等级.4.未穿戴装备
	local costMoney = 0 
	local resourceData =  G_Me.teamData:getPosResourcesByFlag(pos, 1)
	if not resourceData then
		return 4
	end
	local equipNum = 0
	local minLv = 999 --最低等级
	local maxLv = G_Me.equipData:getMaxEnhanceLevel() --最高等级
	local equipList = {}
	for i=1,4 do
		local equipId = resourceData["slot_"..i] or 0
		if equipId and equipId > 0 then
			equipNum = equipNum + 1
			local equip = G_Me.equipData:getEquipInfoByID(equipId)
			if equip.virLv then
				equip.virLv = nil
			end
			equipList[#equipList + 1] = equip
			dump(equip.serverData.level)
			if equip.serverData.level < minLv then
				minLv = equip.serverData.level
			end
		end
	end

	if minLv == maxLv then
		errTag = 3
	elseif equipNum < 4 then
		errTag = 1
	end

	if errTag ~= nil then
		return errTag
	end
	dataLog.minLv = minLv
	dataLog.maxLv = maxLv

	--
	table.sort(equipList,function (a,b)
		if a.serverData.level ~= b.serverData.level then
			return a.serverData.level < b.serverData.level
		else
			return a.cfgData.type < b.cfgData.type
		end
	end )
	
	--银两足够，且有强化空间
	local pointLv = minLv
	dump(pointLv)
	local isUp = true
	local effectShow = {false,false,false,false}
	while costMoney < G_Me.userData.money and pointLv < maxLv and isUp == true do
		dataLog[pointLv] = {equip = {}}
		isUp = false
		for i=1,4 do
			local equip = equipList[i]
			if not equip.virLv then
				equip.virLv = equip.serverData.level
			end
			local cost = G_Me.equipData:getEnhanceCostAtLv1(equip.cfgData.money,pointLv)
			if equip.virLv == pointLv and cost <= G_Me.userData.money - costMoney and costMoney < G_Me.userData.money then
				effectShow[equip.cfgData.type] = true
				errTag = 0
				isUp = true
				costMoney = costMoney + cost
				equip.virLv = pointLv + 1
			end
			dataLog[pointLv].equip[i] = {id = equip.cfgData.id,
			name = equip.cfgData.name,
			virlv = equip.virLv,
			cost = cost,
			pointLv = pointLv,
			errorTag = errTag,
			}
		end

		if isUp == false then
			break
		end

		--升级之后重新排序
		table.sort(equipList,function (a,b)
			if a.virLv ~= b.virLv then
				return a.virLv < b.virLv
			else
				return a.cfgData.type < b.cfgData.type
			end
		end )
		dataLog[pointLv].totalMoney = costMoney
		dataLog[pointLv].userMoney = G_Me.userData.money
		pointLv = pointLv + 1
	end

	if errTag ~= 0 then
		errTag = 2
	end
	for k,v in pairs(dataLog) do
		dump(v)
	end
	return errTag,costMoney,effectShow
end
-----------------------------武将置换-----------------------------
function TeamData:createKnightList(curIndex,isPre,group,quality,  knightGotBaseIds, knightData, isAllowReplaceAny, fixedKnightBaseID, exclusiveData,  oppositeData,oppositeEquipData)
	local _isPre = isPre
	local _group = group or 0 --主角 攻击性 防御型
	local _quality = quality or 0
	local _knightGotBaseIds = knightGotBaseIds
	local _knightData = knightData
	local _curIndex = curIndex
	local _knightList = {}
	local _allKnightList = {}
	local _isAllowReplaceAny = isAllowReplaceAny
	local _fixedKnightBaseID = fixedKnightBaseID
	local _oppositeData = oppositeData
	local _exclusiveData = exclusiveData --对面武将的专属 限制当前武将的类型（攻击型 防御性）可能为空 选择专属列表同理
	local _oppositeEquipData = oppositeEquipData

	local parameter_info = require("app.cfg.parameter_info")
	local cfg = parameter_info.get(650)
	local _qualityNotOver = tonumber(cfg.content) --武将不能超过的品质
	cfg = parameter_info.get(647)
	local _isShouldAddGotKnight = tonumber(cfg.content) == 1 and true or false
	cfg = parameter_info.get(648)
	local _isShouldAddSameGroup = tonumber(cfg.content) == 1 and true or false
	cfg = parameter_info.get(649)
	local _isShouldAddSameQuality = tonumber(cfg.content) == 1 and true or false

	local addKnight = function( data )
		if _knightList == nil then
			_knightList = {}
		end
		print("addKnightaddKnightaddKnight",_oppositeEquipData)
		if _oppositeEquipData and _oppositeEquipData.cfgData.knight_id ~= data.cfgData.knight_id then
			table.insert(_knightList, data)
		elseif not _oppositeEquipData then
			table.insert(_knightList, data)
		end
	end

	--判断置换时是否是自己置换自己
	local checkKnightInfo = function(knightData)
		if(_knightData)then
			if(knightData.cfgData.knight_id ~= _knightData.cfgData.knight_id)then
				if(_oppositeData)then --帅选对应类型 品质等
					if(_oppositeData.cfgData.quality == knightData.cfgData.quality and _oppositeData.cfgData.job == knightData.cfgData.job)then
						addKnight( knightData )
					end
				else
					addKnight( knightData )
				end
			end
		else
			if(_oppositeData)then --帅选对应类型 品质等
				if(_oppositeData.cfgData.quality == knightData.cfgData.quality and _oppositeData.cfgData.job == knightData.cfgData.job)then
					addKnight( knightData )
				end
			else
				addKnight( knightData )
			end		
		end
	end

	--_oppositeData ~= nil
	local isSameJobAndQuality = function( knightData )
		if(_oppositeData.cfgData.quality == knightData.cfgData.quality and _oppositeData.cfgData.job == knightData.cfgData.job)then
			return true
		end
		return false		
	end

	local _createKnight = function(knightData)
		knightData.serverData = {}
		if(_group ~= 0 and _quality ~= 0)then --左边已经添加武将
			if(_isShouldAddSameGroup)then --同种类型 攻击型 防御性
				 if(_group == knightData.cfgData.job)then
				 	if(_isShouldAddSameQuality and _quality == knightData.cfgData.quality)then
				 		knightData.serverData.level = _knightData.serverData.level
				 		knightData.serverData.destinyLevel = _knightData.serverData.destinyLevel
				 		knightData.serverData.awakenLevel = _knightData.serverData.awakenLevel
				 		knightData.serverData.starLevel = _knightData.serverData.starLevel

						addKnight( knightData )
			 		elseif(not _isShouldAddSameQuality)then

				 	end
				 end
			else
				if(_isShouldAddSameQuality)then
					if(_group == knightData.cfgData.job)then --类型相同 等级 天命 觉醒 星级相同
						knightData.serverData.level = _knightData.serverData.level
						knightData.serverData.destinyLevel = _knightData.serverData.destinyLevel
						knightData.serverData.awakenLevel = _knightData.serverData.awakenLevel
						knightData.serverData.starLevel = _knightData.serverData.starLevel
						addKnight( knightData )
					else --类型不相同 等级 天命 星级相同 觉醒为0
						knightData.serverData.level = _knightData.serverData.level
						knightData.serverData.destinyLevel = _knightData.serverData.destinyLevel
						knightData.serverData.awakenLevel = 0
						knightData.serverData.starLevel = _knightData.serverData.starLevel
						addKnight( knightData )								
					end							
				end
			end
		else --未添加武将 展示武将胚子
			knightData.serverData.level = 1
			knightData.serverData.destinyLevel = 1
			knightData.serverData.awakenLevel = 0
			knightData.serverData.starLevel = 0
			addKnight( knightData )
		end	
	end

	-- _knightList = {}
	if(_isPre)then
		_allKnightList = G_Me.teamData:getAllUnPosKnightExcludeColor()
		for _, v in ipairs(_allKnightList)do
			if(v.cfgData.quality < _qualityNotOver and (v.cfgData.group == _curIndex) or _curIndex == 0)then
				if(not _isAllowReplaceAny)then --置换过一次后只能选择特定武将
					if(_fixedKnightBaseID == v.cfgData.knight_id)then
						addKnight( v )
					end
				else
					if(not _exclusiveData)then
						if(_group ~= 0 and _quality ~= 0)then
							if(_isShouldAddSameGroup and v.cfgData.job == _group)then
								if(_isShouldAddSameQuality and v.cfgData.quality == _quality)then
									checkKnightInfo(v)
								elseif(not _isShouldAddSameQuality)then
									checkKnightInfo(v)
								end	
							end
						else
							checkKnightInfo(v)
						end				
					else
						--只显示专属对应的武将
						if(_exclusiveData.cfgData.knight_id == v.cfgData.knight_id)then
							addKnight( v )
						end
					end
				end
			end
		end
	else
		if(_isShouldAddGotKnight)then
			for _, v in ipairs(_knightGotBaseIds)do
				local knightData = G_Me.teamData:createKnightDataUnitByKnightId(v)
				if(knightData.cfgData.quality < _qualityNotOver and (_curIndex == knightData.cfgData.group) or _curIndex == 0)then --品质限制 阵营限制
					if(not _isAllowReplaceAny and _fixedKnightBaseID == knightData.cfgData.knight_id)then
						_createKnight(knightData)
					elseif(_isAllowReplaceAny)then
						if(not _exclusiveData)then
							if(_knightData)then							
								if(_knightData.cfgData.knight_id ~= v)then
									if(not _oppositeData)then
										_createKnight(knightData)
									else
										if(isSameJobAndQuality(knightData))then
											_createKnight(knightData)
										end
									end
								end
							else
								if(not _oppositeData)then
									_createKnight(knightData)
								else
									if(isSameJobAndQuality(knightData))then
										_createKnight(knightData)
									end
								end
							end
						else
							--只显示专属对应的武将
							if(_exclusiveData.cfgData.knight_id == v)then
								_createKnight(knightData)
							end							
						end
					end
				end
			end
		else --所有武将
			local len = knight_info.getLength()
			for i = 1, len do
				local info = knight_info.indexOf(i)
				if(info.type == 2 and info.quality < _qualityNotOver and (_curIndex == info.group) or _curIndex == 0)then --筛选出武将, 以及增加品级限制 阵营限制
					local knightData = G_Me.teamData:createKnightDataUnitByKnightId(info.knight_id)					
					if(_isAllowReplaceAny)then
						if(not _exclusiveData)then
							if(_knightData)then
								if(_knightData.cfgData.knight_id ~= info.knight_id)then
									if(not _oppositeData)then
										_createKnight(knightData)
									else
										if(isSameJobAndQuality(knightData))then
											_createKnight(knightData)
										end
									end
								end
							else
								if(not _oppositeData)then
									_createKnight(knightData)
								else
									if(isSameJobAndQuality(knightData))then
										_createKnight(knightData)
									end
								end
							end
						else
							--只显示专属对应的武将
							if(_exclusiveData.cfgData.knight_id == info.knight_id)then
								_createKnight(knightData)
							end
						end
					else
						if(info.knight_id == _fixedKnightBaseID)then
							_createKnight(knightData)
						end
					end
				end
			end
		end
	end

	table.sort(_knightList, function(a, b)
		if(a.cfgData.quality == b.cfgData.quality)then
			if(a.cfgData.knight_id ~= b.cfgData.knight_id)then
				return a.cfgData.knight_id < b.cfgData.knight_id
			else
				if(a.serverData.starLevel ~= b.serverData.starLevel)then
					return a.serverData.starLevel > b.serverData.starLevel
				else
					if(a.serverData.level ~= b.serverData.level)then
						return a.serverData.level > b.serverData.level
					else
						if(a.serverData.awakenLevel ~= b.serverData.awakenLevel)then
							return a.serverData.awakenLevel > b.serverData.awakenLevel
						else
							return a.serverData.destinyLevel > b.serverData.destinyLevel
						end
					end
				end
			end
		else
			return a.cfgData.quality > b.cfgData.quality
		end
	end)	
	return _knightList
end
-----------------------------------武将置换

return TeamData