--
-- Author: YouName
-- Date: 2016-03-04 14:32:21
--
local TeamCacheData=class("TeamCacheData")

function TeamCacheData:ctor( ... )
	-- body
	self._oldPosKnightData = nil
	self._oldPosBaseAttrs = nil

	--用于记录属性缘分变化
	self._knightLastAssociationRecord = {}
	--记录属性飘字变化
	self._knightLastAttrsRecord = {}
	--养成
	self._knightLastCultivate = {}
	---记录阵上武将id变化
	self._posLastKnightRecord = {}
	--记录套装变化
	self._posEquipSuitsRecord = {}

	self._nowTeamPos = 0

	self._lastPower = 0

	self._strengthenRecord = 1--上次武将养成页签记录

	self._difAttr = {difAtk = 0,difHp = 0,difDef = 0} -- 记录属性变化值
	self._lastAttr = {lastAtk = 0,lastHp = 0,lastDef = 0} -- 记录上次属性值
	--self._strengthenPos = 1--武将养成记录

	self._lastCamp = false -- 上次阵营Buff状态
end

-- 设置上次属性
function TeamCacheData:setLastAttr(values,power)
	self._lastAttr = values
	self._lastPower = power or self._lastPower
end

-- 计算偏差值
function TeamCacheData:calculateDifAttr(values,power)
	return values.atk - self._lastAttr.lastAtk,values.hp - self._lastAttr.lastHp,values.def - self._lastAttr.lastDef,power - self._lastPower
end

function TeamCacheData:setDifAttr(values)
	self._difAttr = values
end

function TeamCacheData:getDifAttr()
	return self._difAttr
end

function TeamCacheData:setLastPower(value)
	--dump(debug.traceback("描述:", 2))
	self._lastPower = value
end

function TeamCacheData:getLastPower()
	return self._lastPower
end

function TeamCacheData:getNowTeamPos( ... )
	-- body
	return self._nowTeamPos
end

function TeamCacheData:setNowTeamPos( pos )
	-- body
	self._nowTeamPos = pos
end


function TeamCacheData:setOldPosBaseAttrs( data )
	-- body
	self._oldPosBaseAttrs = clone(data)
end

function TeamCacheData:getOldPosBaseAttrs( ... )
	-- body
	return self._oldPosBaseAttrs
end

function TeamCacheData:setOldPosKnightData( pos )
	-- body
	local obj = G_Me.teamData:getKnightDataByPos(pos)
	if(obj ~= nil)then
		self._oldPosKnightData = clone(obj)
	end
end

function TeamCacheData:getOldPosKnightData( ... )
	-- body
	return self._oldPosKnightData
end


--记录变化前的属性 缘分
function TeamCacheData:recordAll(pos,isChangeKnight)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return end
	local knightId = knightData.serverData.id
	local numAtk,numDef,numHp,baseAttrRate = G_Me.teamData:getKnightTotalAttrsByID(knightId)
	local numCritical,numAccurate,numResist,numDodge = baseAttrRate.crit,baseAttrRate.hit,baseAttrRate.defend_crit,baseAttrRate.miss

	--记录攻防血
	self:_recordLastAttrs(pos,numAtk,numDef,numHp,numCritical,numAccurate,numResist,numDodge)
	--记录养成
	self:_recordLastCultivate(pos)
	--记录套装
	self:_recordPosEquipSuits(pos)
	--记录阵位上的武将id
	self:_recordPosKnightID(pos,knightData.serverData.id)
	--记录战力
	if not isChangeKnight then self:setLastPower(G_Me.userData.power) end
	---记录缘分
	for i=1,6 do
		self:_recordLastAssociation(i)
	end
	-- 记录阵营Buff激活状态
	--self:_recordLastCamp(pos)
end

--记录变化前的装备属性
function TeamCacheData:_recordPosEquipSuits( pos )
	-- body
	-- local tSuits = G_Me.teamData:getPosSuitsDetail(pos) or {}
	-- self._posEquipSuitsRecord["key_"..tostring(pos)] = tSuits
end

--获取套装变化
function TeamCacheData:_getPosEquipSuitsChange( pos )
	-- body
	-- local currSuits = G_Me.teamData:getPosSuitsDetail(pos) or {}
	-- local lastSuits = self._posEquipSuitsRecord["key_"..tostring(pos)] or {}
	local list = {}
	-- for k,v in pairs(currSuits) do
	-- 	local suitId = v.suitId
	-- 	local suitNum = v.num
	-- 	if(suitNum > 1)then
	-- 		if(lastSuits["t_"..tostring(suitId)] == nil or (lastSuits["t_"..tostring(suitId)] ~= nil and lastSuits["t_"..tostring(suitId)].num < suitNum))then
	-- 			list[#list + 1] = {id = suitId,num = suitNum}
	-- 		end
	-- 	end
	-- end

	return list
end

--记录变化前的宝物属性
function TeamCacheData:_recordLastCultivate( pos )
	-- body
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return end
	self._knightLastCultivate["key_"..tostring(knightData.serverData.id)] = {
		level = knightData.serverData.level,
		rank = knightData.serverData.knightRank,
		destinyLevel = knightData.serverData.destinyLevel,
		knightData = knightData,
	}
end

--获取养成变化信息
function TeamCacheData:_getChangeCultivate( pos )
	-- body
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return nil end

	local lastCultivate = self._knightLastCultivate["key_"..tostring(knightData.serverData.id)] or nil
	local changeCultivate = nil
	if(lastCultivate ~= nil)then
		local currLevel = knightData.serverData.level
		--local currRank = knightData.serverData.knightRank
		local currDestinyLevel = knightData.serverData.destinyLevel

		local prevLevel = lastCultivate.level
		local prevRank = lastCultivate.rank
		local prevDestinyLevel = lastCultivate.destinyLevel

		changeCultivate = {}
		changeCultivate.level = currLevel - prevLevel
		--changeCultivate.rank = currRank - prevRank
		changeCultivate.destinyLevel = currDestinyLevel - prevDestinyLevel
	end

	return changeCultivate
end

--记录阵位上的武将id
function TeamCacheData:_recordPosKnightID( pos,id )
	-- body
	self._posLastKnightRecord["pos_"..tostring(pos)] = id
end
--获取之前阵位上的武将id
function TeamCacheData:_getLastPosKnightId( pos )
	-- body
	return self._posLastKnightRecord["pos_"..tostring(pos)] or 0
end
--记录神将变化前的 攻 防 血
function TeamCacheData:_recordLastAttrs(pos,atk,def,hp,critical,accurate,resist,dodge)
	-- body
	self._knightLastAttrsRecord["key_"..tostring(pos)] = {atk=atk,def=def,hp=hp,critical=critical,resist=resist,dodge=dodge,accurate=accurate}
end

function TeamCacheData:getCurrAttrs( pos )
	-- body
	return self._knightLastAttrsRecord["key_"..tostring(pos)]
end

--记录神将变化前的缘分
function TeamCacheData:_recordLastAssociation( pos )
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return end
	local ass = {}
	if(knightData ~= nil and knightData.serverData.association ~= nil)then
		ass = knightData.serverData.association

		-- for k,v in pairs( knightData.serverData.association) do
		-- 	if v.ass_flags == 1 then
		-- 		table.insert(ass,v.ass_id)
		-- 	end
		-- end
	end
	local list = G_Me.teamData:getKnightAssociationInfoListByID(knightData.serverData.id)

	self._knightLastAssociationRecord["key_"..tostring(pos)] = list
end
----获取神将攻 防 血 变化的 差值
function TeamCacheData:_getKnightAttrsDifByPos(pos)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return end
	local id = knightData.serverData.id
	local atk,def,hp,t = G_Me.teamData:getKnightTotalAttrsByID(id)
	local lastAtk,lastDef,lastHp = 0,0,0
	local lastInfo = self._knightLastAttrsRecord["key_"..tostring(pos)]
	if(lastInfo ~= nil)then
		lastAtk,lastDef,lastHp = lastInfo.atk,lastInfo.def,lastInfo.hp
	end

	return atk-lastAtk,def-lastDef,hp-lastHp
end

--获取武将缘分变化 显示的缘分id组数
function TeamCacheData:_getKnightAssocaitionDifByPos(pos)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	local showList = {}
	if(knightData == nil)then return showList end
	local id = knightData.serverData.id
	local ass = knightData.serverData.association
	local tempAss = self._knightLastAssociationRecord["key_"..tostring(pos)] or {}
	local list = G_Me.teamData:getKnightAssociationInfoListByID(knightData.serverData.id)

	--dump(tempAss)
	--dump(list)
	for i=1,#list do
		--dump(tempAss[i])
		--dump(list[i])
		if (tempAss[i] and tempAss[i].isActive ~= list[i].isActive) and list[i].isActive == true then
				showList[#showList + 1] = list[i].cfgData.id
		end
	end

	--dump(tempAss)
	--dump(ass)
	-- if(#ass > 0)then
	-- 	for i=1,#ass do
	-- 		local isActive = true
	-- 		local isChange = false
	-- 		for j = 1,#ass[i].ass_flags  do
	-- 			if ass[i].ass_flags[j] ~= 1 then -- 未激活
	-- 				isActive = false
	-- 				break
	-- 			end
	-- 		end

	-- 		if isActive then 
	-- 			for j = 1,#tempAss[i].ass_flags  do
	-- 				if tempAss[i].ass_flags[j] ~= 1 then -- 未激活
	-- 					isChange = true
	-- 					break
	-- 				end
	-- 			end
	-- 		end

	-- 		if isChange then
	-- 			showList[#showList + 1] = tempAss[i].ass_id
	-- 		end
	-- 		-- if(table.indexof(tempAss,id) == false)then
	-- 		-- 	showList[#showList + 1] = id
	-- 		-- end
	-- 	end
	-- end
	--dump(showList)
	return showList
end

--------获取指定阵位上的数据变化
function TeamCacheData:getChangeParams(pos,callback,instrumentCall,worldPosAttr,worldPosYF,worldPosFabao)
	local textTitle = nil

	if tipType == 1 then 
		textTitle = G_LangScrap.get("team_main_knight_up_success")
	elseif tipType == 2 then
		textTitle = G_LangScrap.get("team_main_equip_up_success")
	elseif tipType == 3 then
		textTitle = G_LangScrap.get("team_main_treasure_up_success")
	end

	-- body
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if(knightData == nil)then return end

	--属性变化
	local attrsChange = {0,0,0}
	attrsChange[1],attrsChange[2],attrsChange[3] = self:_getKnightAttrsDifByPos(pos)

	--缘分变化
	local assList = {}
	for i=1,6 do
		local posKnightData = G_Me.teamData:getKnightDataByPos(i)
		local itemList = self:_getKnightAssocaitionDifByPos(i) or {}
		for j=1,#itemList do
			assList[#assList + 1] = {
				id = itemList[j],
				knightData = posKnightData,
				dstPos = pos == i and worldPosYF or nil
			}
		end
	end
	--dump(assList)

	local lastKnightId = self:_getLastPosKnightId(pos)
	-- --合击
	-- local instrument = nil
	-- local instrumentMainKnightID = 0
	-- if(lastKnightId ~= knightData.serverData.id)then
	-- 	local uniteKnight = knightData.cfgData.unite_knight
	-- 	for i=1,6 do
	-- 		local posKnightData = G_Me.teamData:getKnightDataByPos(i)
	-- 		if(posKnightData ~= nil and posKnightData.cfgData.knight_id == uniteKnight)then
	-- 			if knightData.cfgData.unite_type == 1 then
	-- 				instrumentMainKnightID = knightData.serverData.id
	-- 			else
	-- 				instrumentMainKnightID = posKnightData.serverData.id
	-- 			end
	-- 			local mainKnightData = G_Me.teamData:getKnightDataByID(instrumentMainKnightID)
	-- 			instrument = {
	-- 				id = mainKnightData.cfgData.instrument,
	-- 				rank = mainKnightData.serverData.instrumentRank,
	-- 				callback = function()
	-- 					if instrumentCall ~= nil then
	-- 						instrumentCall(instrumentMainKnightID)
	-- 					end
	-- 				end,
	-- 				dstPos = worldPosFabao,
	-- 			}
	-- 			break
	-- 		end
	-- 	end
	-- end
	
	--养成变化 等级 突破等级 天命等级
	local changeCultivate = self:_getChangeCultivate(pos)
	local cultivate = nil
	if(changeCultivate ~= nil)then
		cultivate = {}
		cultivate.level = {value = changeCultivate.level,dstPos = nil}
		cultivate.rank = {value = changeCultivate.rank,dstPos = nil}
		cultivate.destinyLevel = {value = changeCultivate.destinyLevel,dstPos = nil}
		cultivate.knightData = knightData
	end

	--套装变化
	local suitList = self:_getPosEquipSuitsChange(pos)

	-- 阵营Buff
	local campBuff = self:_getPosCampChange(pos)

	--飘字参数配置
	local atkCallback = nil
	local defCallback = nil
	local hpCallback = nil
	if(attrsChange[1] ~= 0)then
		atkCallback = callback
	elseif(attrsChange[2] ~= 0)then
		defCallback = callback
	else
		hpCallback = callback
	end

	local params = {
		assList = assList, -- 缘分
		instrument = instrument, -- 法宝合击
		atk = {value = attrsChange[1],dstPos = worldPosAttr, callback = atkCallback}, --攻击
		def = {value = attrsChange[2],dstPos = worldPosAttr, callback = defCallback}, -- 防御
		hp = {value = attrsChange[3],dstPos = worldPosAttr, callback = hpCallback}, -- 血
		cultivate = cultivate, -- 养成变化
		suitList = suitList, -- 套装变化
		campBuff = campBuff, -- 阵营buff
		campPos = worldPosFabao,
	}

	return params
end

-- suNSun start
-- 养成页签记录
function TeamCacheData:setStrengthenRecord(value)
	self._strengthenRecord = value
end

function TeamCacheData:getStrengthenRecord()
	return self._strengthenRecord
end

function TeamCacheData:_recordLastCamp(pos)
	dump(self._lastCamp)
	self._lastCamp = G_Me.teamData:hasCampBuff(pos) ~= nil
	dump(self._lastCamp)
end

function TeamCacheData:_getPosCampChange(pos)
	local camp = G_Me.teamData:hasCampBuff(pos)
	if camp and self._lastCamp == false then
		dump("camp and self._lastCamp == true!!!")
		return true
	end
	dump(tostring(camp) .. tostring(self._lastCamp) .. " TeamCacheData:_getPosCampChange(pos)  == false")
	return false
end

-- suNSun end

return TeamCacheData