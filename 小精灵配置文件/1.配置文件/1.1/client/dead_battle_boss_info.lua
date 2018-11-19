local record_dead_battle_boss_info = {}

record_dead_battle_boss_info.id = 0 --编号
record_dead_battle_boss_info.level_number = 0 --关数
record_dead_battle_boss_info.front_floor = 0 --前置三国无双关卡
record_dead_battle_boss_info.monster_name = "" --怪物名称
record_dead_battle_boss_info.monster_image = 0 --怪物形象
record_dead_battle_boss_info.monster_icon = 0 --怪物头像
record_dead_battle_boss_info.monster_group_id = 0 --引用怪物组id
record_dead_battle_boss_info.first_type = 0 --首胜奖励类型
record_dead_battle_boss_info.first_value = 0 --首胜奖励类型值
record_dead_battle_boss_info.first_size = 0 --首胜奖励数量
record_dead_battle_boss_info.type_1 = 0 --掉落道具类型1
record_dead_battle_boss_info.value_1 = 0 --掉落道具类型值1
record_dead_battle_boss_info.min_size_1 = 0 --掉落道具数量最小1
record_dead_battle_boss_info.max_size_1 = 0 --掉落道具数量最大1
record_dead_battle_boss_info.type_2 = 0 --掉落道具类型2
record_dead_battle_boss_info.value_2 = 0 --掉落道具类型值2
record_dead_battle_boss_info.min_size_2 = 0 --掉落道具数量最小2
record_dead_battle_boss_info.max_size_2 = 0 --掉落道具数量最大2
record_dead_battle_boss_info.type_3 = 0 --掉落道具类型3
record_dead_battle_boss_info.value_3 = 0 --掉落道具类型值3
record_dead_battle_boss_info.min_size_3 = 0 --掉落道具数量最小3
record_dead_battle_boss_info.max_size_3 = 0 --掉落道具数量最大3


dead_battle_boss_info = {
    _data = {
    [1] = {1,1,3,"海底人",11034,11034,3500,16,0,2000,1,0,40000,40000,0,0,0,0,0,0,0,0,},
    [2] = {2,2,6,"童帝",11014,11014,3501,16,0,2000,3,13,2,2,0,0,0,0,0,0,0,0,},
    [3] = {3,3,9,"冲天好小子",13017,13017,3502,16,0,2000,3,18,8,8,0,0,0,0,0,0,0,0,},
    [4] = {4,4,12,"钉锤头",12007,12007,3503,16,0,3000,1,0,60000,60000,0,0,0,0,0,0,0,0,},
    [5] = {5,5,15,"背心尊者",11005,11005,3504,16,0,3000,3,13,3,3,0,0,0,0,0,0,0,0,},
    [6] = {6,6,18,"丧服吊带",13012,13012,3505,16,0,3000,3,18,12,12,0,0,0,0,0,0,0,0,},
    [7] = {7,7,21,"匹克",12015,12015,3506,16,0,4000,3,13,4,4,0,0,0,0,0,0,0,0,},
    [8] = {8,8,24,"阿修罗盔甲",14015,14015,3507,16,0,4000,3,18,16,16,0,0,0,0,0,0,0,0,},
    [9] = {9,9,27,"钻头武士",13004,13004,3508,16,0,4000,3,81,1,1,0,0,0,0,0,0,0,0,},
    [10] = {10,10,30,"甜心假面",11001,11001,3509,16,0,5000,1,0,100000,100000,0,0,0,0,0,0,0,0,},
    [11] = {11,11,33,"性感囚犯",14016,14016,3510,16,0,5000,3,45,20,20,0,0,0,0,0,0,0,0,},
    [12] = {12,12,36,"银色獠牙",12003,12003,3511,16,0,5000,3,81,1,1,0,0,0,0,0,0,0,0,},
    [13] = {13,13,39,"琦玉",11002,11002,3512,16,0,6000,3,13,6,6,0,0,0,0,0,0,0,0,},
    [14] = {14,14,42,"小龙卷",12009,12009,3513,16,0,6000,3,18,24,24,0,0,0,0,0,0,0,0,},
    [15] = {15,15,45,"波罗斯",13007,13007,3514,16,0,6000,1,0,120000,120000,0,0,0,0,0,0,0,0,},
    [16] = {16,16,48,"深海之王",14005,14005,3515,16,0,8000,3,45,32,32,0,0,0,0,0,0,0,0,},
    [17] = {17,17,51,"僵尸男",11006,11006,3516,16,0,8000,3,81,1,1,0,0,0,0,0,0,0,0,},
    [18] = {18,18,54,"杰诺斯",12001,12001,3517,16,0,8000,3,13,8,8,0,0,0,0,0,0,0,0,},
    [19] = {19,19,57,"蜈蚣长老",13008,13008,3518,16,0,10000,3,18,40,40,0,0,0,0,0,0,0,0,},
    [20] = {20,20,60,"格鲁甘修鲁",14019,14019,3519,16,0,10000,1,0,200000,200000,0,0,0,0,0,0,0,0,},
    [21] = {21,21,63,"音速索尼克",11007,11007,3520,16,0,10000,3,45,40,40,0,0,0,0,0,0,0,0,},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    [11] = 11,
    [12] = 12,
    [13] = 13,
    [14] = 14,
    [15] = 15,
    [16] = 16,
    [17] = 17,
    [18] = 18,
    [19] = 19,
    [20] = 20,
    [21] = 21,
}

local __key_map = {
    id = 1,
    level_number = 2,
    front_floor = 3,
    monster_name = 4,
    monster_image = 5,
    monster_icon = 6,
    monster_group_id = 7,
    first_type = 8,
    first_value = 9,
    first_size = 10,
    type_1 = 11,
    value_1 = 12,
    min_size_1 = 13,
    max_size_1 = 14,
    type_2 = 15,
    value_2 = 16,
    min_size_2 = 17,
    max_size_2 = 18,
    type_3 = 19,
    value_3 = 20,
    min_size_3 = 21,
    max_size_3 = 22,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_dead_battle_boss_info")
        return t._raw[__key_map[k]]
    end
}

function dead_battle_boss_info.getLength()
    return #dead_battle_boss_info._data
end

function dead_battle_boss_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function dead_battle_boss_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = dead_battle_boss_info._data[index]}, m)
end

function dead_battle_boss_info.get(id)
    local k = id
    return dead_battle_boss_info.indexOf(__index_id[k])
end

function dead_battle_boss_info.set(id, key, value)
    local record = dead_battle_boss_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function dead_battle_boss_info.get_index_data()
    return __index_id
end

