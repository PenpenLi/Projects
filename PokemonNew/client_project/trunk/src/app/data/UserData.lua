
--[=======================[

    用户基础信息

]=======================]

local RoleInfo = require("app.cfg.role_info")

local UserData = class("UserData")

function UserData:ctor()
    self._mainCityLastPower = 0

    self._hasBaseData = false

    self.id = 0 --角色ID
    self.name = "" --角色名
    self.level = 0 -- 等级
    self.vit = 0 --体力
    self.spirit = 0 --精力
    self.refresh_vit_time = 0
    self.refresh_spirit_time = 0
    self.refresh_shovel_time = 0
    self.exp = 0 --主角经验
    self.money = 0 --银两
    self.gold =  0 --元宝
    self.power= 0 --战力
    -- self.mana = 12 --法力
    self.prestige = 13 --聲望(竞技场)
    self.tower_resource = 14 --将心
    --self.fra1 = 0 --宝物资源1
    --self.fra2 = 0 --宝物资源2
    --self.fra3 = 0 --宝物资源3
    -- self.viagra = 0 -- 降妖令数量
    -- self.refresh_viagra_time = 19
    --self.arena_honor = 20 --跨服竞技荣誉
    self.soul = 0 --将魂(武将分解)
    -- self.medal = 0 --修为
    self.forbid_battle_time = 0 --免战时间戳
    self.world_boss_fight_time = 0 --全服boss下一次可攻打时间
    self.recruiting_zy_point = 0 --阵容招募积分。
    self.last_drink_time = 0 -- 上次吃体力时间

    -- 记录上一次角色信息
    self.lastData = nil
    self._date = nil
    -- 灵珠
    -- self.jade = nil

    -- 是否升过级
    self._isLevelUp = false

    -- 新手引导记录
    self.guideId = nil

    --是否触发过全服boss
    self.first_boss = false

    self.sacrifice_time = 0 --上次祭祀事件
    self.guild_contribution = 0 -- //公会贡献
    self.guild_leave_time = 0 -- // 退会时间
    self.guild_id = 0 -- //公会id
    --创角时间
    self.create_time = 0
    --主角等级卡点相关
    self._fosterList = {}
    --上一次改变前的战力
    self._oldPower = 0
    self.title_pic = nil    --玩家头像
    self.pic_frame = nil    --玩家头像框
    self.wushuang = 0 --无双货币
    self.spade = 0
    self.copper = 0 -- 铜钱
    self.renown = 0 -- 威名
   -- self.jianghun = 0 -- 将魂
    self.qihun = 0 -- 器魂
    self.lingyu = 0 -- 灵玉
    self.weiwang = 0 -- 威望

    self._randomUid = 0
    self.score_practice = 0 -- 演武场积分
    self._fashion_id = 0 -- 时装id
    self.clothes_level = 0 -- 时装等级
    self.polish_luck = 0 -- 洗炼幸运值
    self.pet_soul = 0 -- 兽魂
    self.hunshi = 0 --将魂(武将分解)
end

function UserData:hasBaseData()
    return self._hasBaseData
end

--生成一个随机的id
function UserData:setRandomUuid( value )
    self._randomUid = value
end

--生成一个随机的id
function UserData:getRandomUuid()
    return self._randomUid
end

function UserData:getOldPower()
    return self._oldPower
end

function UserData:setLastMainCityPower( value )
    -- body
    self._mainCityLastPower = value
end

function UserData:getLastMainCityPower( ... )
    -- body
    return self._mainCityLastPower
end

function UserData:getLastData(valueName)
    if self.lastData == nil then
       self.lastData = {}
    end

    if self.lastData[valueName] == nil then
        self.lastData[valueName] = self[valueName]
    end

    local value = self.lastData[valueName]
    self.lastData[valueName] = self[valueName]
    return value
end

function UserData:setBaseData(user)
    self._date = G_ServerTime:getDate()
    if self.lastData == nil then
        self.lastData = {}
        self.lastData.money = user.money
        self.lastData.gold = user.gold
        self.lastData.charge_coin = user.charge_coin
        self.lastData.vit = user.vit
        self.lastData.spirit = user.spirit
        self.lastData.lingyu = user.lingyu
        self.lastData.hunshi = user.hunshi
        self.lastData.weiwang = user.weiwang
        self.lastData.copper = user.copper
        self.lastData.power=user.power
        self.lastData.exp=user.exp
        self.lastData.soul = user.jianghun -- //将魂
        self.lastData.prestige = user.prestige --//聲望
        self.lastData.wushuang = user.wushuang --//无双货币
        self.lastData.pet_soul = user.mahun --//马魂
        self.lastData.score_practice = user.wuhun --//武魂
        self.lastData.tower_resource = user.tower_resource --// 将心

        -- self.lastData.refresh_viagra_time=user.refresh_viagra_time
        --self.lastData.arena_honor=user.arena_honor--跨服竞技荣誉
        
        self.lastData.level = user.level

        self.lastData.guild_contribution = user.guild_contribution -- //公会贡献
        self.lastData.guild_id = user.guild_id
        self._oldPower = user.power
    else
        self.lastData.money = self.money
        self.lastData.gold = self.gold
        self.lastData.charge_coin = self.charge_coin
        self.lastData.vit = self.vit
        self.lastData.spirit = self.spirit
        self.lastData.lingyu = self.lingyu
        self.lastData.hunshi = self.hunshi
        self.lastData.weiwang = self.weiwang
        self.lastData.copper = self.copper
        self.lastData.power = self.power
        self.lastData.exp = self.exp
        self.lastData.soul = self.jianghun -- //将魂
        self.lastData.prestige = self.prestige --//聲望
        self.lastData.wushuang = self.wushuang --//无双货币
        self.lastData.pet_soul = self.mahun --//马魂
        self.lastData.score_practice = self.wuhun --//武魂
        self.lastData.tower_resource = self.tower_resource --//将心

        -- self.lastData.refresh_viagra_time = self.refresh_viagra_time
        --self.lastData.arena_honor=self.arena_honor--跨服竞技荣誉

        self.lastData.level = self.level

        self.lastData.guild_contribution = self.guild_contribution -- //公会贡献
        self.lastData.guild_id = self.guild_id
        if self.power ~= user.power then
            self._oldPower = self.power
        end
    end

    self.sacrifice_time = user.sacrifice_time
    self.guild_contribution = user.guild_contribution
    self.guild_leave_time = user.guild_leave_time -- // 退会时间
    self.id = user.id
    print("用户id:",user.id)
    self.name = user.name
    self.level = user.level
    --dump(user)

    -- 标记一下是否升过级
    if self.level > self.lastData.level then
        self._isLevelUp = true
        -- 推送升级消息
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_USER_LEVELUP, nil, false)
    end

    self.vit = user.vit
    self.spirit = user.spirit
    self.refresh_vit_time = user.refresh_vit_time
    self.refresh_shovel_time = user.refresh_spade_time
    --dump(self.refresh_vit_time)
    --dump(self.refresh_shovel_time)
    --dump(G_ServerTime:getTime())
    self.refresh_spirit_time = user.refresh_spirit_time
    self.exp = user.exp
    self.money =  user.money
    self.gold =  user.gold
    self.power=user.power
    -- self.mana = user.mana
    self.prestige = user.prestige
    self.tower_resource = user.tower_resource
    -- self.viagra = user.viagra
    --self.fra1 = user.fra1
    --self.fra2 = user.fra2
    --self.fra3 = user.fra3
    -- self.refresh_viagra_time=user.refresh_viagra_time
    --self.arena_honor = user.arena_honor
    self.soul = user.jianghun
    -- self.medal = user.medal
    self.recruiting_zy_point = user.recruiting_zy_point
    self.forbid_battle_time = user.forbid_battle_time or 0
    self.world_boss_fight_time = rawget(user, "world_boss_fight_time") and user.world_boss_fight_time or 0
    
    --喝酒时间更新
    if rawget(user, "last_drink_time") and user.last_drink_time then
        self.last_drink_time = rawget(user, "last_drink_time") and user.last_drink_time or 0
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
    end

    -- self.jade = user.jade

    if CONFIG_GAME_DEBUG then
        -- self.guideId = 1401
        self.guideId = user.guide_id
    else
        self.guideId = user.guide_id
    end

    if self.guideId == nil then
        if buglyReportLuaException ~= nil then
            buglyReportLuaException("guideId is nil: " .. tostring(user.guide_id))
        end
    end

    local guide_info = require("app.cfg.guide_info")
    local maxID = guide_info.indexOf(guide_info.getLength()).id
    if self.guideId > maxID then
        self.guideId = maxID
    end
    print2("guideIdguideId",user.guide_id,user.lingyu)

    self.first_boss = user.first_boss
    
    self.guild_id = user.guild_id
    
    self.create_time = user.create_time

    self.title_pic = user.title_pic
    self.pic_frame = user.pic_frame
    self.wushuang = user.wushuang
    self.spade = user.spade
    self.copper = user.copper
    self.renown = user.renown
    self.qihun = user.qihun
    self.lingyu = user.lingyu
    self.hunshi = user.hunshi
    self.weiwang = user.weiwang
    self.score_practice = user.wuhun
    self.polish_luck = user.polish_luck
    self.pet_soul = user.mahun
    self._fashion_id = user.clothes
    self.clothes_level = user.clothes_level --temp
    self.charge_coin = user.charge_coin
    --self.jianghun

    self.charge_return_code = user.charge_return_code
    
    if self._hasBaseData == false then
        self._hasBaseData = true
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_USERDATA_INTET, nil, false)
    end
end

--设置免战时间  后台使用免战新增了个推送协议 orz
function UserData:setForbidTime( time )
	-- body
	if type(time) ~= "number" then return end

	self.forbid_battle_time = time
end

function UserData:setVip(vip)
    self.vip = vip
end

function UserData:setTowerScore(score)
    self.tower_score = score
end

--设置触发过全服BOSS
function UserData:setFirstWorldBoss(firstBoss)
    if type(firstBoss) ~= "number" then return end
    
    self.first_boss = firstBoss
end

-- -- 设置当前个消耗品点数
function UserData:setCurrCostValue(_vit,_spirit,_battle_token)
    self.vit = _vit
    self.spirit = _spirit
    self.battle_token = _battle_token
end

function UserData:getMaxTeamSlot(  )
    local roleInfo = RoleInfo.get(self.level)
    if roleInfo then
        return roleInfo.team_num
    end
    
    return 1
end

function UserData:getMaxBagNum() --获取最大背包数量
    -- body
    local roleInfo = RoleInfo.get(self.level)
    if roleInfo then
        return roleInfo.equipment_bag_num_client
    end
    return 1
end


function UserData:getMaxPartnerSlot( ... )

    local roleInfo = RoleInfo.get(self.level)
    if roleInfo then
        return roleInfo.battle_friends_num
    end
    
    return 0
end

function UserData:getTeamSlotOpenLevel( ... )
    local levelArr = {}
    local teamNum = 1

    for loopi = 1, RoleInfo.getLength() do 
        local roleInfo = RoleInfo.get(loopi)
        if roleInfo and roleInfo.team_num == teamNum then 
            table.insert(levelArr, #levelArr + 1, roleInfo.level)
            teamNum = teamNum + 1
        end

        if teamNum >= 12 then
            return levelArr
        end
    end

    return levelArr
end

function UserData:getPveExp(vit)
    local parameterInfo = require("app.cfg.parameter_info")
    local pve_exp = vit * tonumber(parameterInfo.get(245).content)
    --assert(roleInfo, "can't find role info of lv " .. tostring(self.level))
    return pve_exp
end

function UserData:getPveMoney()
    local roleInfo = RoleInfo.get(self.level)
    assert(roleInfo, "can't find role info of lv " .. tostring(self.level))
    return roleInfo.pve_money
end

-- @desc 是否重新需要拉数据
function UserData:isNeedRequestNewData()
    local dateTime = G_ServerTime:getDate()
    if dateTime ~= self._date  then
        return true
    else
        return false
    end
end

-- 是否升过级
function UserData:isLevelUp()
    return self._isLevelUp
end

-- 清除升级后的标记
function UserData:clearLevelUpFlag()
    self._isLevelUp = false
end

-- 设置体力值
function UserData:setVitData(vit)
    assert(type(vit) == "number" and vit > 0, "Invalid vit: "..tostring(vit))
    self.vit = vit
end

-- 设置精力值
function UserData:setSpiritData(spirit)
    assert(type(spirit) == "number" and spirit > 0, "Invalid spirit: "..tostring(spirit))
    self.spirit = spirit
end

-- -- 设置降妖令值
-- function UserData:setViagraData(viagra)
--     assert(type(viagra) == "number" and viagra > 0, "Invalid viagra: "..tostring(viagra))
--     self.viagra = viagra
-- end

-- 设置洛阳铲值
function UserData:setShovelData(spade)
    assert(type(spade) == "number" and spade > 0, "Invalid vit: "..tostring(spade))
    self.spade = spade
end


--获取玩家当前功能模块最高能升到的等级,以及要突破这个最高等级需要主角至少达到多少级
--fosterType 对应foster_level 表的 foster_type字段
---maxFosterLevel = 高能升到的等级
---needUserLevel = 要达到maxFosterLevel+1 需要的主角等级
---此功能只适用于主角等级卡点
function UserData:getUserMaxFosterLevel( fosterType )
    -- body
    local maxFosterLevel = 9999 --默认不限制 如果找不到对应的type 或者 is_use = 0
    local userLevel = G_Me.userData.level
    local needUserLevel = 0
    local list = self._fosterList["key_"..tostring(fosterType)] or nil
    local errorTips = ""
    if list == nil then
        list = {}
        -- local fosterInfo = require("app.cfg.foster_level")
        -- local len = fosterInfo.getLength()
        -- for i=1,len do
        --     local itemInfo = fosterInfo.indexOf(i)
        --     if itemInfo.foster_type == fosterType and itemInfo.is_use > 0 then
        --         list[#list + 1] = itemInfo
        --     end
        -- end
        table.sort(list,function(a,b)
            if a.limit_level ~= b.limit_level then
                return a.limit_level < b.limit_level
            end
        end)
        self._fosterList["key_"..tostring(fosterType)] = list
    end

    for i=1,#list do
        local itemInfo = list[i]
        if userLevel < itemInfo.limit_level then
            maxFosterLevel = itemInfo.foster_level - 1
            needUserLevel = itemInfo.limit_level
            errorTips = itemInfo.words
            break
        end
    end
    
    return maxFosterLevel,needUserLevel,errorTips
end

function UserData:getFashionId()
    return self._fashion_id
end

--生成一个随机的id
function UserData:setFashionId( id )
    self._fashion_id = id
end

function UserData:setSigSer( data )
    self.sigData = data
end

function UserData:getSigSer(  )
    return self.sigData
end

return UserData
