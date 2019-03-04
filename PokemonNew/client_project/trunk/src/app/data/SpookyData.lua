--围剿群妖 data
local SpookyData = class("SpookyData")

function SpookyData:ctor()
    self:_initAll()
end

function SpookyData:_initAll()

    self._tempBossData = nil     --发现群妖临时数据

    self._voicePlayed = false   --音效是否播放过

    self._showTempBoss = false  --用于解决主线音效与boss出现音效冲突

    --基础数据
    self._spookyData = {
        ["myFeatRank"] = 0,--功勋排名
        ["myHarmRank"] = 0,--最大伤害排名
        ["totalFeats"] = 0,--累计功勋
        ["maxHarm"] = 0,--单次最大伤害
    }      


    self._featRankList = {}      --功勋排行
    self._harmRankList = {}      --伤害排行

    self._bossList = {}          --群妖列表

    self._canShareBossId = 0     --分享BOSS ID
    self._attackingBossId = 0    --正在攻打的BOSS ID
    self._lastFeatValue = 0      --攻打boss前的修为值

end


--贡献奖励读取daily_reward_info中，system_type=2 数据
function SpookyData:getAwardList()

    return G_Me.dailyTaskData:getDailyTaskDatas(2)

end


--是否有奖励可领，用于显示红点提示
function SpookyData:checkCanGetAnyAward()
    return G_Me.dailyTaskData:hasAnyRewardCanGet(2) > 0
end


function SpookyData:setBossList(data)

    assert(type(data) == "table" ,"SpookyData:setBossList error~")

    self._bossList = {}

    --应该逐一赋值
    for i=1, #data.devils do
        self._bossList[i] = data.devils[i]
        self._bossList[i].status = 0

        --防止后端给的状态不对
        if self._bossList[i].hp == 0 then
            self._bossList[i].status = 1  --被击杀
        end
    end    


    --如果有可能，将自己发现的boss排在最前面
    local sortFunc = function ( a, b )
        if a.user_id == G_Me.userData.id then
            return true
        else
            return false
        end
    end

    table.sort(self._bossList, sortFunc)
end

--boss列表
function SpookyData:getBossList()
    return self._bossList
end

function SpookyData:getBossById(bossId)

    if type(bossId) == "number" and bossId > 0 then
        for i=1, #self._bossList do
            if self._bossList[i].user_id == bossId then
                return self._bossList[i]
            end
        end
    end

    return nil

end


function SpookyData:setRankListData(data)
   
    self._featRankList = {}
    self._featRankList = rawget(data,"exploit_rank") and data.exploit_rank or {}

    self._harmRankList = {}
    self._harmRankList = rawget(data,"max_harm_rank") and data.max_harm_rank or {}

    --dump(self._featRankList)
    --dump(self._harmRankList)

    self._spookyData.myFeatRank = rawget(data, "my_exploit_rank") and data.my_exploit_rank or 0
    self._spookyData.myHarmRank = rawget(data, "my_max_harm_rank") and data.my_max_harm_rank or 0

end


--更新功勋排行
function SpookyData:_updateFeatRank()
  
    local num = #self._featRankList
    for i=1, num do
        if self._spookyData.totalFeats >= self._featRankList[num+1-i].value then
            self._spookyData.myFeatRank = num+1-i
        else
            break
        end
    end

end

--更新伤害排行
function SpookyData:_updateHarmRank()
    
    local num = #self._harmRankList
    for i=1, num do
        if self._spookyData.maxHarm >= self._harmRankList[num+1-i].value then
            self._spookyData.myHarmRank = num+1-i
        else
            break
        end
    end

end

--初始化空排行榜
function SpookyData:_initEmptyRankList( rankList )
	-- 插入10条空数据
	local emptyNum = 10-(#rankList)
	for i=1, emptyNum do
		local rankData = {
			uid = 1,
			value = 0,
			name = nil,
			power = 0,
			avater = 0,
			level = 0,
			rank_lv = 0,
		}
		table.insert(rankList, #rankList+1, rankData)
	end
end

--获取排行榜
function SpookyData:getRankListData(index)
    assert(type(index) == "number" ,"SpookyData:getRankListData error~")

    if index == 1 then
    	self:_initEmptyRankList(self._featRankList)
        return self._featRankList
    elseif index == 2 then
    	self:_initEmptyRankList(self._harmRankList)
        return self._harmRankList
    else 
        return {}
    end
end


--获取我的排行
function SpookyData:getMyRank(index)
    assert(type(index) == "number" ,"SpookyData:getMyRank error~")

    if index == 1 then
        return self._spookyData.myFeatRank
    elseif index == 2 then
        return self._spookyData.myHarmRank
    else 
        return 0
    end

end


function SpookyData:setSpookyData(data)

    assert(type(data) == "table" ,"SpookyData:setSpookyData error~")

    self._spookyData.myFeatRank = rawget(data,"exploit_rank") and data.exploit_rank or 0  --功勋排名
    self._spookyData.myHarmRank = rawget(data,"max_harm_rank") and data.max_harm_rank or 0  --最大伤害排名
    self._spookyData.totalFeats = rawget(data,"exploit") and data.exploit or 0  --累计功勋
    self._spookyData.maxHarm = rawget(data,"max_harm") and data.max_harm or 0  --单次最大伤害
end

--群妖信息
function SpookyData:getSpookyData()
    return self._spookyData
end

function SpookyData:setAttack(data)
   
    --更新累计功勋
    if rawget(data,"exploit") then
        self._spookyData.totalFeats = self._spookyData.totalFeats + data.exploit
        self:_updateFeatRank()
    end

    --更新最大伤害
    local harm = rawget(data,"harm") and data.harm or 0

    if rawget(data,"new_record") and data.new_record == true then
        if harm > 0 then
            self._spookyData.maxHarm = harm
            self:_updateHarmRank()
        end
    end

    local bossStatus = rawget(data,"status") and data.status or 0

    local bossId = rawget(data,"uid") and data.uid or 0
    if bossId > 0 then
        self:updateBossData(bossId, {status = bossStatus, minusHp = harm})
    end

end


function SpookyData:updateBossData(bossId, bossInfo)

    assert(type(bossId) == "number" and type(bossInfo) == "table" ,"SpookyData:setBossState error~")

    for i=1, #self._bossList do
        if self._bossList[i].user_id == bossId then
            if type(bossInfo.status) == "number" then
                self._bossList[i].status = bossInfo.status
            end

            if type(bossInfo.minusHp) == "number" then
                self._bossList[i].hp = math.max(self._bossList[i].hp-bossInfo.minusHp, 0)
                if self._bossList[i].hp == 0 then
                    self._bossList[i].status = 1  --被击杀
                    --print("------------------fff---- jisha")
                end
            end

            return
        end
    end

end

--缓存发现群妖临时数据
function SpookyData:setTempBossData(data)
	
	--等级未到
	if not G_Responder.funcIsOpened(G_FunctionConst.FUNC_SPOOKY) then
		return
	end
    
    self._voicePlayed = false

    self._tempBossData = data.devil or nil
end

--记录是否需要分享BOSS的ID
function SpookyData:setCanShareBoss(bossId)
    self._canShareBossId = bossId
end

function SpookyData:getCanShareBoss()
    return self._canShareBossId
end

--记录是否需要分享BOSS的ID
function SpookyData:setAttackingBoss(bossId)
    self._attackingBossId = bossId
end

function SpookyData:getAttackingBoss()
    return self._attackingBossId
end

function SpookyData:setLastFeatValue(value)
    self._lastFeatValue = value or 0
end

function SpookyData:getLastFeatValue()
    return self._lastFeatValue
end

--记录是否需要播放语音  避免点击前往重复播放
function SpookyData:setVoicePlayed(played)
    self._voicePlayed = checkbool(played)
end

function SpookyData:getVoicePlayed()
    return self._voicePlayed
end

--判断boss是否已出现
function SpookyData:checkShowTempBoss()

    if self._showTempBoss then
        self._showTempBoss = false
        return true
    else
        return false
    end
    
end

--发现群妖
function SpookyData:checkBossAppeared(...)

    --测试数据 REMOVE ME 
    --self._tempBossData = {}
    --self._tempBossData.id = 11
    --self._tempBossData.base_id = 100001
    --优先判断是否发现群妖
    if self._tempBossData then
        self._showTempBoss = true

        G_Popup.newPopup(function() 
            return require("app.scenes.spooky.SpookyAppearPanel").new(self._tempBossData)
        end)

        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_SPOOKY_FIND_BOSS, nil, false)
        self._tempBossData = nil
    --是否触发全服BOSS
    else
        G_Me.worldBossData:checkBossAppeared()
    end
end


return SpookyData