local record_city_info = {}

record_city_info.id = 0 --城池编号
record_city_info.name = "" --城池名称
record_city_info.pre_id = 0 --前置城池
record_city_info.monster_team_id = 0 --守关怪物组
record_city_info.riot_prob = 0 --暴动几率
record_city_info.riot_event_team = 0 --暴动事件组
record_city_info.interaction_type = 0 --互动好友资源类型
record_city_info.interaction_value = 0 --互动好友资源类型值
record_city_info.interaction_size = 0 --互动好友资源数量
record_city_info.interaction_event_team = 0 --互动己方事件组
record_city_info.resource_event_team = 0 --资源事件组
record_city_info.patrol_cost_type_1 = 0 --巡逻效率1消耗类型
record_city_info.patrol_cost_value_1 = 0 --巡逻效率1消耗值
record_city_info.patrol_event_interval_1 = 0 --巡逻效率1事件间隔
record_city_info.patrol_cost_type_2 = 0 --巡逻效率2消耗类型
record_city_info.patrol_cost_value_2 = 0 --巡逻效率2消耗值
record_city_info.patrol_event_interval_2 = 0 --巡逻效率2事件间隔
record_city_info.patrol_cost_type_3 = 0 --巡逻效率3消耗类型
record_city_info.patrol_cost_value_3 = 0 --巡逻效率3消耗值
record_city_info.patrol_event_interval_3 = 0 --巡逻效率3事件间隔
record_city_info.type_1 = 0 --掉落1类型
record_city_info.value_1 = 0 --掉落1类型值
record_city_info.size_1 = 0 --掉落1数量
record_city_info.type_2 = 0 --掉落2类型
record_city_info.value_2 = 0 --掉落2类型值
record_city_info.size_2 = 0 --掉落2数量
record_city_info.type_3 = 0 --掉落3类型
record_city_info.value_3 = 0 --掉落3类型值
record_city_info.size_3 = 0 --掉落3数量
record_city_info.down_type_1 = 0 --攻占掉落1类型
record_city_info.down_value_1 = 0 --攻占掉落1类型值
record_city_info.down_size_1 = 0 --攻占掉落1数量
record_city_info.down_type_2 = 0 --攻占掉落2类型
record_city_info.down_value_2 = 0 --攻占掉落2类型值
record_city_info.down_size_2 = 0 --攻占掉落2数量
record_city_info.down_type_3 = 0 --攻占掉落3类型
record_city_info.down_value_3 = 0 --攻占掉落3类型值
record_city_info.down_size_3 = 0 --攻占掉落3数量
record_city_info.spark_type_1 = 0 --惊喜掉落1类型
record_city_info.spark_value_1 = 0 --惊喜掉落1类型值
record_city_info.spark_size_1 = 0 --惊喜掉落1数量
record_city_info.spark_type_2 = 0 --惊喜掉落2类型
record_city_info.spark_value_2 = 0 --惊喜掉落2类型值
record_city_info.spark_size_2 = 0 --惊喜掉落2数量
record_city_info.spark_type_3 = 0 --惊喜掉落3类型
record_city_info.spark_value_3 = 0 --惊喜掉落3类型值
record_city_info.spark_size_3 = 0 --惊喜掉落3数量
record_city_info.spark_type_4 = 0 --惊喜掉落4类型
record_city_info.spark_value_4 = 0 --惊喜掉落4类型值
record_city_info.spark_size_4 = 0 --惊喜掉落4数量
record_city_info.spark_type_5 = 0 --惊喜掉落5类型
record_city_info.spark_value_5 = 0 --惊喜掉落5类型值
record_city_info.spark_size_5 = 0 --惊喜掉落5数量
record_city_info.spark_type_6 = 0 --惊喜掉落6类型
record_city_info.spark_value_6 = 0 --惊喜掉落6类型值
record_city_info.spark_size_6 = 0 --惊喜掉落6数量
record_city_info.drop_knight_1 = 0 --名将掉落1
record_city_info.drop_knight_2 = 0 --名将掉落2
record_city_info.drop_knight_3 = 0 --名将掉落3
record_city_info.drop_knight_4 = 0 --名将掉落4
record_city_info.fight_value = 0 --怪物战力
record_city_info.monster_id = 0 --怪物资源
record_city_info.monster_name = "" --怪物名字
record_city_info.monster_quality = 0 --怪物颜色
record_city_info.monster_word = "" --怪物对话
record_city_info.directions = "" --城池描述
record_city_info.pic = "" --城池缩略图
record_city_info.pic2 = "" --城市背景图
record_city_info.patrol_directions = "" --巡逻描述


city_info = {
    _data = {
    [1] = {1,"A市",0,8000,1000,1,2,0,5,6,50,8,2,1,2,30,2,2,60,3,3,4,1,3,5,1,1,0,1,2,0,500,3,5,2,3,4,2,2,0,1518,1,0,588888,4,20067,1,4,20012,1,0,0,0,0,0,0,20067,20012,0,0,53165,12003,"银色獠牙",6,"年轻人，光靠蛮力是不行的……","英雄与怪人活跃的城市。盛产体力可乐，精力可乐，金币，更有机会找到上方显示的英雄和怪人。","1","1","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.此地巡逻主要产出体力可乐，精力可乐，金币；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    [2] = {2,"B市",1,8001,800,2,2,0,5,7,51,8,2,1,2,30,2,2,60,3,3,21,1,3,39,1,3,13,1,2,0,500,3,21,2,3,12,10,2,0,1666,1,0,688888,4,10111,1,4,10067,1,4,10089,1,0,0,0,10111,10067,10089,0,247858,11002,"琦玉",6,"我都认真不起来，真无聊","传说中闹鬼的城市，居民都搬走了，名副其实的鬼城。此地盛产各种装备碎片与精炼石，更有机会找到上方显示的英雄和怪人。","2","2","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.此地主要产出各等级装备碎片与装备精炼石；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    [3] = {3,"C市",2,8002,500,3,2,0,5,8,52,8,2,1,2,30,2,2,60,3,3,22,1,3,18,1,1,0,1,2,0,500,3,22,2,3,18,50,2,0,1768,1,0,788888,4,40144,1,4,40155,1,4,40133,1,4,40166,1,40144,40155,40133,40166,581481,14003,"金属骑士",6,"尝尝的我最大出力的火箭炮吧！","全自动化的机械城市，此地盛产橙色徽章箱子和徽章精炼石，更有机会找到上方显示的英雄和怪人。","3","3","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.在城都联盟主要产出徽章碎片与徽章精炼石；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    [4] = {4,"D市",3,8003,300,4,2,0,5,9,53,8,2,1,2,30,2,2,60,3,3,14,1,3,9,1,3,6,1,2,0,500,3,14,50,3,9,150,2,0,1888,1,0,888888,4,30067,1,4,30078,1,4,30056,1,4,30023,1,30067,30078,30056,30023,1790716,13007,"波罗斯",6,"将你连同星球一起毁灭吧！","被外星人占领的城市，在此地有机会找到上方显示的英雄和怪人。","4","4","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.此地巡逻主要产出进化石，潜力胶囊，培养胶囊等英雄养成资源；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    [5] = {5,"E市",4,8004,200,5,2,0,5,10,54,8,2,1,2,30,2,2,60,3,13,0,1,1,0,1,2,0,1,2,0,500,13,0,500,1,0,1000000,2,0,1918,1,0,988888,4,20111,1,4,20089,1,4,20155,1,4,20034,1,20111,20089,20155,20034,3297672,12009,"小龙卷",6,"垃圾，滚开！","超能力者的城市，充满着神秘色彩，在这里随时进行着各种超能者间的战斗。更有机会找到上方显示的英雄和怪人。","5","5","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.在此地主要产出各种资源；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    [6] = {6,"F市",5,8005,200,12,2,0,5,11,55,8,2,1,2,30,2,2,60,3,23,0,1,3,60,1,1,0,1,2,0,500,23,0,500,3,60,1000,2,0,2218,1,0,1288888,4,10111,1,4,20089,1,4,30067,1,4,40133,1,10111,20089,30067,40133,6807544,13007,"波罗斯",6,"将你连同星球一起毁灭吧！","由神奥大陆、东北岛的对战特区和分布于地区两侧的数个较小的岛组成。更有机会找到上方显示的英雄和怪人。","6","6","1.每次巡逻获得巡逻英雄的碎片，巡逻时间越长，获得碎片数量越多；\n2.此地巡逻主要产出星屑；\n3.另外还有些英雄和怪人在此地逗留，运气好可以直接获得他们！",},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
}

local __key_map = {
    id = 1,
    name = 2,
    pre_id = 3,
    monster_team_id = 4,
    riot_prob = 5,
    riot_event_team = 6,
    interaction_type = 7,
    interaction_value = 8,
    interaction_size = 9,
    interaction_event_team = 10,
    resource_event_team = 11,
    patrol_cost_type_1 = 12,
    patrol_cost_value_1 = 13,
    patrol_event_interval_1 = 14,
    patrol_cost_type_2 = 15,
    patrol_cost_value_2 = 16,
    patrol_event_interval_2 = 17,
    patrol_cost_type_3 = 18,
    patrol_cost_value_3 = 19,
    patrol_event_interval_3 = 20,
    type_1 = 21,
    value_1 = 22,
    size_1 = 23,
    type_2 = 24,
    value_2 = 25,
    size_2 = 26,
    type_3 = 27,
    value_3 = 28,
    size_3 = 29,
    down_type_1 = 30,
    down_value_1 = 31,
    down_size_1 = 32,
    down_type_2 = 33,
    down_value_2 = 34,
    down_size_2 = 35,
    down_type_3 = 36,
    down_value_3 = 37,
    down_size_3 = 38,
    spark_type_1 = 39,
    spark_value_1 = 40,
    spark_size_1 = 41,
    spark_type_2 = 42,
    spark_value_2 = 43,
    spark_size_2 = 44,
    spark_type_3 = 45,
    spark_value_3 = 46,
    spark_size_3 = 47,
    spark_type_4 = 48,
    spark_value_4 = 49,
    spark_size_4 = 50,
    spark_type_5 = 51,
    spark_value_5 = 52,
    spark_size_5 = 53,
    spark_type_6 = 54,
    spark_value_6 = 55,
    spark_size_6 = 56,
    drop_knight_1 = 57,
    drop_knight_2 = 58,
    drop_knight_3 = 59,
    drop_knight_4 = 60,
    fight_value = 61,
    monster_id = 62,
    monster_name = 63,
    monster_quality = 64,
    monster_word = 65,
    directions = 66,
    pic = 67,
    pic2 = 68,
    patrol_directions = 69,
}

local m = {
    __index = function(t,k)
        if k == "toObject"then
            return function()
                local o = {}
                for key, v in pairs (__key_map) do
                    o[key] = t._raw[v]
                end
                return o
            end
        end

        assert(__key_map[k], "cannot find " .. k .. " in record_city_info")
        return t._raw[__key_map[k]]
    end
}

function city_info.getLength()
    return #city_info._data
end

function city_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function city_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = city_info._data[index]}, m)
end

function city_info.get(id)
    local k = id
    return city_info.indexOf(__index_id[k])
end

function city_info.set(id, key, value)
    local record = city_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function city_info.get_index_data()
    return __index_id
end

