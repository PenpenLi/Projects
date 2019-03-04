--[====================[
    成就data
    kaka
]====================]

local AchievementData = class("AchievementData")

--local AchievementInfo = require("app.cfg.achievement_info")
local AchievementInfo = require("app.cfg.target_info")
--local RequirementInfo = require("app.cfg.requirement_info")
local ChapterConfigConst = require("app.const.ChapterConfigConst")

local ACHI_SERVER_PREV = "achi_server_"
local ACHI_CONFIG_PREV = "achi_config_"
local ACHI_TYPE_PREV = "achi_type_"

--成就显示系统 与成就表中的show_area对应

AchievementData.NORMAL_AREA = 1                 --正常成就
AchievementData.ROB_TREASURE_AREA = 2           --夺宝系统成就
--AchievementData.XIANJIE_AREA = 3                --仙界副本成就
AchievementData.MAX_TYPE = 1                    --成就类型
AchievementData.TARGET_TYPE_MAX = 100               --最大成就类型值

function AchievementData:ctor()

    self:_initData()

end

--初始化数据
function AchievementData:_initData()

    self._achiServerData = {}         --成就服务器数据缓存

    self._achiListData = {
        --[[
            1 = --当前成就列表数据缓存 避免主页成就按钮红点显示卡顿的问题
            2 = --夺宝奖励
        ]]
        } 

    self._achiCfgData = {
        --[[
            1 = --当前成就配置数据缓存 避免成就列表更新时重新遍历表
            2 = --夺宝奖励
        ]]
    }

    --ADD
    self._achiTypeCfgData = {
    --[[
        type = {achiInfo1,achiInfo2}
        type = {achiInfo1,achiInfo2}
    ]]
    }

    self._dataIsDirty = false

end


--[===========[
    缓存服务器端成就数据
    data为服务器端数据
]===========]
function AchievementData:setAchievementData(datas)

    if type(datas)~="table" then 
        return 
    end

    self:_initData()

    -- print("aaadddddddddddddddddddddddddddddddddddddddddd")

    local achs = datas.achs or {}

    for i=1,#achs do
        self:_setOneAchievementData(achs[i])
    end

    -- --dump(self._achiServerData)

    -- --拉取服务器数据或者有成就更新时，更新成就列表数据
     self:_setAchievementListData()

end


function AchievementData:_setOneAchievementData( data )
    -- body
    if type(data)~="table" then 
        return 
    end
    --dump(data)
    local achi = {}

    achi.type = data.type   --服务器中的成就类型

    if rawget(data, "values") then
        achi.values = data.values
    else
        achi.values = {}
    end

    if rawget(data, "reward_ids") then
        achi.reward_ids = data.reward_ids
    else
        achi.reward_ids = {}
    end

    self._achiServerData[ACHI_SERVER_PREV..data.type] = achi

    --dump(data)

end


--只更新成就服务器数据 
function AchievementData:updateAchievementData(datas)

    if type(datas)~="table" then 
        return 
    end

    local achs = datas.achs or {}

    --更新缓存成就数据
    for i=1, #achs do
        local achiData = achs[i]
        --dump(achiData)
        -- self:_isReachAchiByType(achiData) -- 先判断是否达成成就
        self:_setOneAchievementData(achiData)

        local achiType = achiData.type

        --判断属于哪一类型的成就 更新
        for j=1, AchievementData.MAX_TYPE do
            if self._achiListData[1] and self._achiListData[1][ACHI_TYPE_PREV..achiType] then
                --print("------------------------------------------normal update")
                --只取第一个值
                local hasGetReward = self:_hasGetAward(achiType,self._achiListData[1][ACHI_TYPE_PREV..achiType].cfgData.id)
                --self._achiListData[1][ACHI_TYPE_PREV..achiType].serverData.now_value = achiData.values[1]
                self._achiListData[1][ACHI_TYPE_PREV..achiType].serverData.getAward = hasGetReward

                --dump(self._achiListData[1][ACHI_TYPE_PREV..achiType].serverData)
                break
            elseif self._achiListData[2] and self._achiListData[2][ACHI_TYPE_PREV..achiType] then
                local hasGetReward = self:_hasGetAward(achiType,self._achiListData[2][ACHI_TYPE_PREV..achiType].cfgData.id)
                --self._achiListData[2][ACHI_TYPE_PREV..achiType].serverData.now_value = achiData.values[1]
                self._achiListData[2][ACHI_TYPE_PREV..achiType].serverData.getAward = hasGetReward

                --dump(self._achiListData[2][ACHI_TYPE_PREV..achiType].serverData)
                break
            end
        end

    end
    self:_setAchievementListData()
end


--临时缓存成就列表需要显示的数据 用于显示红点
function AchievementData:_setAchievementListData( ... )
    -- body
    self._achiListData = {}

    self._achiListData[1] = self:_getAchievementData(1)
    --self._achiListData[2] = self:_getAchievementData(2)

end

--是否需要更新成就列表
function AchievementData:setDataIsDirty( isDirty )
    -- body
    self._dataIsDirty = isDirty or false
end

--获取成就列表需要显示的数据
function AchievementData:getAchievementListData( showArea )

    if type(showArea) ~= "number" and showArea > AchievementData.MAX_TYPE then 
        return {} 
    end

    --得更新缓存的
    --local list = self._achiListData[showArea] or {}

    --需要重置下
    if self._dataIsDirty then
        self._achiListData[showArea] = self:_getAchievementData(showArea)
        --print("---------------------------------------------refresh AchievementData")
        self._dataIsDirty = false
    end

    local list = {}

    for k, v in pairs(self._achiListData[showArea]) do
        table.insert(list,v)
    end

    self:_sortAchievements(list)

    -- body
    return list
end

--是否有奖励可以领取 用于显示小红点
function AchievementData:getNewAward()
   
    return self:hasAnyAwardCanGet(1) > 0

end


--根据是否有奖励可以领取
function AchievementData:hasAnyAwardCanGet(showArea)
   
    if type(showArea) ~= "number" then return 0 end

    local canGetAwardNum = 0

    --print("---------------------------------------------hasAnyAwardCanGet")

    if not self._achiListData[showArea] then return canGetAwardNum end

    for k, v in pairs(self._achiListData[showArea]) do

        local nowValue = tonumber(v.serverData["now_value"])
        local maxValue = tonumber(v.serverData["max_value"])

        --达成条件并未领奖
        if not v.serverData.getAward and nowValue >= maxValue then
            --return true
            canGetAwardNum = canGetAwardNum + 1
            break  --不需要统计所有个数的话就break
        end
    end

    --return false
    return canGetAwardNum

end


-- --根据类型遍历RequirementInfo 表
-- function AchievementData:_getRequirementDataByType(requireType)
    
--     local datas = {}

--     local recordNum = RequirementInfo.getLength()

--     for i = 1, recordNum, 1 do
--         local record = RequirementInfo.indexOf(i)
--         if record.type == requireType then
--             table.insert(datas,record)  --有必要存这么多数据吗 FIXME
--         end
--     end

--     return datas
-- end


--根据requireId获得requirement数据
--@requireId 条件ID
-- function AchievementData:_getRequirementDataById(requireId)

--     local requirementInfo = RequirementInfo.get(requireId)
--     assert(requirementInfo, "Could not find the RequirementInfo id=" .. requireId)

--     --local achiData = self._achiServerData[ACHI_SERVER_PREV..requirementInfo.type]

--     local cfgDatas = {}

--     --是否是聚合还是离散  有必要  0-聚合 1-离散  
--     if requirementInfo.is_discrete > 0 then
--         --dump(requirementInfo)
--         cfgDatas = self:_getRequirementDataByType(requirementInfo.type)
--         --dump(cfgData)
--     else
--         cfgDatas = {requirementInfo}
--     end

--     return cfgDatas --{severData = achiData , cfgData = cfgData}
-- end

--获得成就当前进度和需要达成的目标
function AchievementData:_getAchievementProgress(achieveInfo)

    assert(type(achieveInfo) == "table", "_getAchievementProgress achieveInfo error")

    local nowValue = 0     --当前value
    local maxValue = 0     --需要达到的value

    --local requireData = self:_getRequirementDataById(achieveInfo.requirement_id)
    -- local requirementInfo = RequirementInfo.get(achieveInfo.requirement_id)
    -- assert(requirementInfo, "Could not find the RequirementInfo id=" .. achieveInfo.requirement_id)

    maxValue = achieveInfo.target_size

    local achiData = self._achiServerData[ACHI_SERVER_PREV..achieveInfo.target_type]
    
    --正常情况是只有一个值  离散情况可能会有多个值  目前不考虑离散的情况
    if achiData and achiData.values and #(achiData.values) > 0 then
        nowValue = achiData.values[1]
    end
    
    -- --计算实际值
    -- if achieveInfo.is_history == 0 then
    --     nowValue = self:_getRealProgressByType(requirementInfo.type, maxValue)
    -- end
    nowValue = self:_getRealProgressByType(achieveInfo.target_type, maxValue)


    return  nowValue,  maxValue
end

-- 判断数据更新时是否达成成就
function AchievementData:_isReachAchiByType(achiData)
    local cfgInfos = self:_getAchievementConfigData(1)
    local achiInfos = self._achiTypeCfgData[ACHI_CONFIG_PREV..achiData.type] -- 某种类型成就
    --dump(achiData)
    --dump(achiInfos)
    local preValue 
    if not self._achiServerData[ACHI_SERVER_PREV..achiData.type] then
        for k,v in pairs(achiInfos) do
            if achiData.values[1] >= v.target_size then
                require("app.scenes.Achievement.AchievementReachPop").reachAchievementTips(v)
            end
        end
        return
    end
    if not self._achiServerData[ACHI_SERVER_PREV..achiData.type].values[1] then
        return
    end
    preValue = self._achiServerData[ACHI_SERVER_PREV..achiData.type].values[1]
    print("99999999999")
    local list = {}
    for k,v in pairs(achiInfos) do
        list[#list + 1] = v
    end
    --achiInfos --self._achiTypeCfgData[ACHI_CONFIG_PREV..achiData.type]

    table.sort(list,function (a,b)
        return a.id < b.id
    end)
    local needToAchi = nil -- 下条需要完成的成就
    local length = #list
    for i=1,length do
        if i ~= length then
            if preValue >= list[i].target_size and preValue < list[i+1].target_size then
                needToAchi = list[i+1]
                break
            end
        else
            print("说明已经完成了最后一条成就")
        end
    end
    if not needToAchi then
        return
    end
    -- 判断更新的值是否达到了 下条需要完成的成就 的条件
    if achiData.values[1] == preValue then
        return
    elseif achiData.values[1] >= needToAchi.target_size then
        require("app.scenes.Achievement.AchievementReachPop").reachAchievementTips(needToAchi)
    end
end


--根据限制等级遍历AchievementInfo(现在变成了target_info)表 缓存起来 提高性能
--理论上不会出现游戏中等级串升跨域多个等级对应成就
--@showArea 对应成就表中的show_area
function AchievementData:_getAchievementConfigData(showArea)

    if type(self._achiCfgData[showArea]) == "table" and 
        table.nums(self._achiCfgData[showArea]) > 0 then
        return self._achiCfgData[showArea]
    end

    self._achiCfgData[showArea] = {}

    local recordNum = AchievementInfo.getLength()
    --获取对应模块并满足等级条件的成就记录
    --local FunctionLevelInfo = require("app.cfg.function_level_info")

    for loopi = 1, recordNum, 1 do 
        local record = AchievementInfo.indexOf(loopi)
        if record.effective_type == 1 then
            self._achiCfgData[showArea][ACHI_CONFIG_PREV..record.id] = record
            if not self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type] then
                self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type] = {}
                self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type][#self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type] + 1] = record
            else
                self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type][#self._achiTypeCfgData[ACHI_CONFIG_PREV..record.target_type] + 1] = record
            end
        end
        --local funcInfo = FunctionLevelInfo.get(record.level)
        -- if record.show_area == showArea and (funcInfo and funcInfo.level <= G_Me.userData.level or 
        --     record.show_area == AchievementData.ROB_TREASURE_AREA ) then
        --     self._achiCfgData[showArea][ACHI_CONFIG_PREV..record.id] = record
        -- end
    end

    --dump(self._achiCfgData[showArea])

    return self._achiCfgData[showArea]

end


--根据模块ID获取成就奖励列表  
--@showArea 对应成就表中的show_area
function AchievementData:_getAchievementData(showArea)
    
    --是否是该类型中最后一个
    -- local function isLastOneInThisType(aType, id )

    --     --local achievement = AchievementInfo.get(id+1)
    --     local achievement = AchievementInfo.get(id)
    --     assert(achievement ~= nil,"can not find the target :id = "..id)
    --     if achievement.if_end == 1 then
    --         return true
    --     end 

    --     -- --与配表id编号有关 
    --     -- if not achievement then
    --     --     return true
    --     -- else
    --     --     local require_id = achievement.requirement_id
    --     --     local require_info = RequirementInfo.get(require_id)
    --     --     if require_info then
    --     --         return require_info.type ~= aType 
    --     --     end
    --     -- end

    --     return false
    -- end

    --读取配表数据
    local configDatas = self:_getAchievementConfigData(showArea)

    local achiList = {}  --需要返回的成就列表

    for k, cfgData in pairs (configDatas) do

        local info = cfgData
        --dump(info)

        --local requirementInfo = nil
        local needShow = false      --是否需要加入到成就列表 

        local curGetAward = false   --当前成就是否领过奖
        curGetAward = self:_hasGetAward(info.target_type,info.id)


        -- local curAchi = self:_getWorkingAchiByType(info.target_type) -- 当前正在进行的成就

        -- if info.id == curAchi or info.if_end == 1 then  -- 正在进行的成就或最后一个成就，需显示
        --     needShow = true
        -- elseif info.id < curAchi and not curGetAward then   -- 已完成，未领奖，需显示
        --     needShow = true
        -- end


        --某类型第一个
        if info.pre_id == 0 then
            --requirementInfo = RequirementInfo.get(info.requirement_id)

            curGetAward = self:_hasGetAward(info.target_type,info.id)
            --没有领过或者是最后一个
            if not curGetAward or info.if_end == 1 then
                needShow = true
            end

        else
            --检查前置id 是否领奖
            local perAchievement = AchievementInfo.get(info.pre_id)
            assert(perAchievement,"target_info not find id :"..info.pre_id)
            --requirementInfo = RequirementInfo.get(perAchievement.requirement_id)

            --前置成就是否领奖
            local preGetAward = self:_hasGetAward(perAchievement.target_type,info.pre_id)
            
            --当前成就require
            --requirementInfo = RequirementInfo.get(info.requirement_id)

            --当前成就是否领奖 
            curGetAward = self:_hasGetAward(info.target_type,info.id)

            --前置领过奖 并且（当前没领或者已是最后一个成就）
            if preGetAward and (not curGetAward or info.if_end == 1) then
                needShow = true
                --print("iiiiiiiiiiiiiiiiiiiiiinfo.id="..info.id)
            end
        end

        if needShow then

            local nowValue, maxValue = self:_getAchievementProgress(info)
            --local nowValue = self:_getRealProgressByType(info.target_type,info.target_size)


            -- --名字拼接
            -- local achieveName = info["name"]
            -- info["name"] = string.format(achieveName, requirementInfo["value"])

            achiList[ACHI_TYPE_PREV..info.target_type] = {cfgData = info,
                serverData = {max_value = info.target_size,now_value = nowValue, 
                --canGetAward = nowValue>=maxValue,  --是否满足领奖条件
                getAward = curGetAward ,   --是否已领取
                type = info.target_type}}

            --每种类型有且紧显示一个类型的
            -- table.insert(achiList , {cfgData = info,
            --     serverData = {max_value = maxValue,now_value = nowValue, 
            --     --canGetAward = nowValue>=maxValue,  --是否满足领奖条件
            --     getAward = curGetAward ,   --是否已领取
            --     type = requirementInfo.type} })
        end
    end

    --dump(achiList)

    return achiList

end

--检查Id是否领过奖
function AchievementData:_hasGetAward(aType,id)
    local achiData = self._achiServerData[ACHI_SERVER_PREV..aType]

    if achiData and rawget(achiData,"reward_ids") then
        for i = 1 , #(achiData.reward_ids) do
            if achiData.reward_ids[i] == id then
                return true
            end
        end
    end

    return false
end


--成就排序
function AchievementData:_sortAchievements(achiList)

	if type(achiList) ~= "table" then
		return
	end
    --dump(achiList)
	table.sort(achiList,function (a,b)

        local canGetAward_a = a.serverData.now_value >= a.serverData.max_value and not a.serverData.getAward
        local canGetAward_b = b.serverData.now_value >= b.serverData.max_value and not b.serverData.getAward

        if a.serverData.getAward ~= b.serverData.getAward then
            return not a.serverData.getAward
        elseif canGetAward_a ~= canGetAward_b then
            return canGetAward_a
        -- elseif a.cfgData.order ~= b.cfgData.order then
        --     return a.cfgData.order < b.cfgData.order
        else
            return a.cfgData.id < b.cfgData.id
        end

    end)

end

--定位当前正在进行的成就
-- function AchievementData:_getWorkingAchiByType(chi_type)
--     local achi = nil

--     local function locateAchi(chi_type,nowValue)
--         local list = self._achiTypeCfgData[ACHI_CONFIG_PREV..chi_type]
--         local curAchi = nil
--         for i=1,#list do
--             if i < #list then -- 不是最后一个成就
--                 if nowValue == list[i].target_size then
--                     curAchi = list[i+1].id
--                     break
--                 elseif i == 1 and nowValue < list[i].target_size then
--                     curAchi = list[i].id
--                     break
--                 elseif nowValue > list[i - 1].target_size and nowValue < list[i].target_size  then
--                     curAchi = list[i].id
--                     break
--                 elseif nowValue > list[i].target_size and nowValue < list[i + 1].target_size then
--                     curAchi = list[i+1].id
--                     break
--                 end
--             elseif nowValue >= list[i].target_size then
--                 curAchi = list[i].id
--             end
--         end
--         assert(curAchi,"无此成就")
--         return curAchi
--     end

--     local nowValue = self:_getRealProgressByType(chi_type)
--     achi = locateAchi(chi_type,nowValue)

--     return achi
-- end

--根据type从前端判断当前实时成就进度
function AchievementData:_getRealProgressByType(type, maxValue)

    local value = 0
    if type == 1 then -- 等级达到n级
        value = G_Me.userData.level
    elseif type == 2 then -- 主线副本星数达到n星
        value = G_Me.allChapterData:getTotalStarByChapterType(ChapterConfigConst.NORMAL_CHAPTER)
    elseif type == 3 then -- 战斗力达到n
        value = G_Me.userData.power
    elseif type == 4 then -- 强化阵上六名武将到N级
        local minLevel = maxValue

        for i = 1 , 6 do
            local knightData = G_Me.teamData:getKnightDataByPos(i)
            --未上阵
            if not knightData then
                minLevel = 0
                break
            elseif knightData.serverData.level < minLevel then --取最小值
                minLevel = knightData.serverData.level
            end
        end
        value = minLevel
    elseif type == 5 then -- 六名上阵武将天命到N级
        local minLevel = maxValue

        for i = 1 , 6 do
            local knightData = G_Me.teamData:getKnightDataByPos(i)
            --未上齐N名武将
            if not knightData then
                minLevel = 0
                break
            elseif knightData.serverData.destinyLevel < minLevel then
                minLevel = knightData.serverData.destinyLevel
            end
        end

        value = minLevel
    elseif type == 6 then -- 武将试炼达到N星
        --value = G_Me.thirtyThreeData:getNowStar() --当前星数
        value = G_Me.thirtyThreeData:getLayersHistoryTotalStars() -- 历史最高
    elseif type == 7 then -- 
    elseif type == 8 then -- vip等级达到n级
        value = G_Me.vipData:getVipLevel()
    elseif type == 9 then -- 上阵n个武将穿齐4件装备
        local knightNum = 0
        for i = 1 , 6 do 
            --装备齐全
            if G_Me.teamData:isAllResOn(i,1) then
                knightNum = knightNum + 1
            end
        end

        value = knightNum
    end

    return value
    -- ===============old
    -- if type == 103 then -- 强化阵上六名武将到N级
        
    --     local minLevel = maxValue

    --     for i = 1 , 6 do
    --         local knightData = G_Me.teamData:getKnightDataByPos(i)
    --         --未上阵
    --         if not knightData then
    --             minLevel = 0
    --             break
    --         --取最小值
    --         elseif knightData.serverData.level < minLevel then
    --             minLevel = knightData.serverData.level
    --         end
    --     end

    --     value = minLevel    

    -- if type == 108 then    --上阵N名神将

    --     local knightNum = 0

    --     for i = 1 , 6 do
    --         local knightData = G_Me.teamData:getKnightDataByPos(i)
    --         if knightData then
    --             knightNum = knightNum + 1
    --         end
    --     end
    --     value = knightNum

    --     --print("上阵N名神将="..value)

    -- elseif type == 109 then --战力达到n万
    --     value = G_Me.userData.power
    --     --print("战力达到n万="..value)
    
    -- elseif type == 113 then   --上阵神将全体等级达到N级

    --     local minLevel = maxValue

    --     for i = 1 , 6 do
    --         local knightData = G_Me.teamData:getKnightDataByPos(i)
    --         --未上齐N名武将
    --         if not knightData then
    --             minLevel = 0
    --             break
    --         elseif knightData.serverData.level < minLevel then
    --             minLevel = knightData.serverData.level
    --         end
    --     end

    --     value = minLevel

    --     --print("上阵神将全体等级达到N级="..value)


    -- elseif type == 114 then   --上阵神将全体突破等级达到N级

    --     local minLevel = maxValue

    --     for i = 1 , 6 do
    --         local knightData = G_Me.teamData:getKnightDataByPos(i)
    --         --未上齐N名武将
    --         if not knightData then
    --             minLevel = 0
    --             break
    --         elseif knightData.serverData.knightRank < minLevel then
    --             minLevel = knightData.serverData.knightRank
    --         end
    --     end

    --     value = minLevel

    --     --print("上阵神将全体突破等级达到N级="..value)


    -- elseif type == 115 then   --上阵神将全体天命等级达到N级

    --     local minLevel = maxValue

    --     for i = 1 , 6 do
    --         local knightData = G_Me.teamData:getKnightDataByPos(i)
    --         --未上齐N名武将
    --         if not knightData then
    --             minLevel = 0
    --             break
    --         elseif knightData.serverData.destinyLevel < minLevel then
    --             minLevel = knightData.serverData.destinyLevel
    --         end
    --     end

    --     value = minLevel 

    --     --print("上阵神将全体天命等级达到N级="..value)


    -- elseif type == 116 then --阵上n名神将装备齐全

    --     local knightNum = 0

    --     for i = 1 , 6 do 
    --         --装备齐全
    --         if G_Me.teamData:isAllResOn(i,1) then
    --             knightNum = knightNum + 1
    --         end
    --     end

    --     value = knightNum

    --     --print("阵上n名神将装备齐全="..value)


    -- elseif type == 117 then --阵上n名神将宝物齐全

    --     local knightNum = 0

    --     for i = 1 , 6 do 
    --         --装备齐全
    --         if G_Me.teamData:isAllResOn(i,2) then
    --             knightNum = knightNum + 1
    --         end
    --     end

    --     value = knightNum

    --     --print("阵上n名神将宝物齐全="..value)

    -- elseif type == 118 then --任意装备强化到N级

    --     local maxLevel = 1 --初始等级

    --     local equipArr = G_Me.equipData:getEquipInfoList()
    --     for i = 1 , #equipArr do
    --         --求出最大等级
    --         local equip = equipArr[i]

    --         --如果达到最大要求，立即结束循环
    --         if equip.serverData.level >= maxValue then
    --             maxLevel = maxValue
    --             break
    --         elseif equip.serverData.level >= maxLevel then
    --             maxLevel = equip.serverData.level
    --         end
    --     end

    --     value = maxLevel
        --print("任意装备强化到N级="..value)  

    -- elseif type == 119 then --任意装备精炼到N级

    --     local maxLevel = 0   --初始等级

    --     local equipArr = G_Me.equipData:getEquipInfoList()
    --     for i = 1 , #equipArr do
    --         --求出最大等级
    --         local equip = equipArr[i]

    --         --如果达到最大要求，立即结束循环
    --         if equip.serverData.refine_level >= maxValue then
    --             maxLevel = maxValue
    --             break
    --         elseif equip.serverData.refine_level >= maxLevel then
    --             maxLevel = equip.serverData.refine_level
    --         end
    --     end

    --     value = maxLevel
    --     --print("任意装备精炼到N级="..value)

    -- elseif type == 120 then --任意宝物强化到N级

    --     local maxLevel = 1  --初始等级

    --     local treasureArr = G_Me.treasureData:getTreasureList()
    --     for i = 1 , #treasureArr do
    --         --求出最大等级
    --         local treasure = treasureArr[i]

    --         --如果达到最大要求，立即结束循环
    --         if treasure.level >= maxValue then
    --             maxLevel = maxValue
    --             break
    --         elseif treasure.level >= maxLevel then
    --             maxLevel = treasure.level
    --         end
    --     end

    --     value = maxLevel
    --     --print("任意宝物强化到N级="..value)

    -- elseif type == 121 then --任意宝物精炼到N级

    --     local maxLevel = 0  --初始等级

    --     local treasureArr = G_Me.treasureData:getTreasureList()
    --     for i = 1 , #treasureArr do
    --         --求出最大等级
    --         local treasure = treasureArr[i]

    --         --如果达到最大要求，立即结束循环
    --         if treasure.refine_level >= maxValue then
    --             maxLevel = maxValue
    --             break
    --         elseif treasure.refine_level >= maxLevel then
    --             maxLevel = treasure.refine_level
    --         end
    --     end

    --     value = maxLevel
        --print("任意宝物精炼到N级="..value)

    --去除法宝
    -- elseif type == 122 then   --任意法宝最高强化达到N级

    --     local maxLevel = 1  --初始等级

    --     local knightList = G_Me.teamData:getAllKnightDataList() 

    --     for i = 1 , #knightList do
    --         local knightData = knightList[i]
  
    --         if knightData.cfgData.instrument_type > 0 then            
    --             if knightData.serverData.instrumentLevel >= maxValue then
    --                 maxLevel = maxValue
    --                 break
    --             elseif knightData.serverData.instrumentLevel >= maxLevel then
    --                 maxLevel = knightData.serverData.instrumentLevel
    --             end
    --         end
    --     end

    --     value = maxLevel 

    --     --print("任意法宝最高强化达到N级="..value)

    -- elseif type == 123 then   --任意法宝最高觉醒达到N级

    --     local maxLevel = 0  --初始等级

    --     local knightList = G_Me.teamData:getAllKnightDataList() 

    --     for i = 1 , #knightList do
    --         local knightData = knightList[i]
  
    --         if knightData.cfgData.instrument_type > 0 then            
    --             if knightData.serverData.instrumentRank >= maxValue then
    --                 maxLevel = maxValue
    --                 break
    --             elseif knightData.serverData.instrumentRank >= maxLevel then
    --                 maxLevel = knightData.serverData.instrumentRank
    --             end
    --         end
    --     end

    --     value = maxLevel 

        --print("任意法宝最高强化达到N级="..value)

    -- elseif type == 107 then --六个阵位装备品质到某色
        
    --     local minColor = maxValue
  
    --     for i = 1 , 6 do
    --         local equipData = G_Me.teamData:getPosResourcesByFlag(i,1)
    --         if equipData then
    --             for j = 1, 4 do
    --                 local id = equipData["slot_"..j]
    --                 if id then
    --                     local data = G_Me.equipData:getEquipInfoByID(id)
    --                     if data.cfgData.color < minColor then
    --                         minColor = data.cfgData.color
    --                     end
    --                 end
    --             end
    --         else
    --             minLevel = 0
    --             break
    --         end
    --     end

    --     value = minLevel  

    -- end

    -- return value
end

--商店购买成就条件是否达成
function AchievementData:isShopRequiredReach( requireId )
    -- body
    local bool = false
    local currValue,requireValue = 0,0
    if not requireId or requireId == 0 then return true,currValue,requireValue end 

    --print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrequire id =".. requireId)

    --local requireData = self:_getRequirementDataById(requireId)

    local requrieInfo = RequirementInfo.get(requireId)
    assert(requrieInfo, "requirement_info can't find requireId =" .. requireId)

    local achiData = self._achiServerData[ACHI_SERVER_PREV..requrieInfo.type]
    --dump(achiData)

    local serverValue = 0
    if achiData then
        --是否离散 0-聚合 1-离散  
        if requrieInfo.is_discrete == 0 then
            serverValue = achiData.values[1]
            -- 计算类型 0-"=填写值满足要求" 1-"≥填写值满足要求" 2-"≤填写值满足要求"  
            if requrieInfo.count_type == 0 then
                bool = serverValue == requrieInfo.value
            elseif requrieInfo.count_type == 1 then
                bool = serverValue >= requrieInfo.value
            else
                bool = serverValue <= requrieInfo.value
            end
        else
            serverValue = achiData.values
            for i=1,#serverValue do
                local subServerValue = serverValue[i]
                if subServerValue == requrieInfo.value then
                    bool = true
                    break
                end
            end
        end
    end

    currValue = serverValue
    requireValue = requrieInfo.value

    return bool,currValue,requireValue

end

return AchievementData