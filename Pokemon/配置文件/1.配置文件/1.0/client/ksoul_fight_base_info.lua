local record_ksoul_fight_base_info = {}

record_ksoul_fight_base_info.id = 0 --底座id
record_ksoul_fight_base_info.name = "" --底座名称
record_ksoul_fight_base_info.quality = 0 --底座品质
record_ksoul_fight_base_info.own_image = 0 --底座资源（自身）
record_ksoul_fight_base_info.enemy_image = 0 --底座资源（敌人）
record_ksoul_fight_base_info.chapter_id = 0 --开启条件（章节id）
record_ksoul_fight_base_info.group_num = 0 --需要组合数量
record_ksoul_fight_base_info.directions = "" --底座描述


ksoul_fight_base_info = {
    _data = {
    [1] = {1,"默认",1,1,2,0,0,"让英雄在战斗时更有力量。",},
    [2] = {2,"威严",4,3,4,1,46,"让英雄在战斗中发挥智慧。",},
    [3] = {3,"悍勇",5,5,6,2,57,"让英雄在战斗时身形灵巧。",},
    [4] = {4,"铁血",6,7,8,3,52,"让英雄在战斗中更能迷惑敌人。",},
    [5] = {5,"无畏",7,9,10,4,25,"让英雄在战斗中发挥法术真正的力量。",},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
}

local __key_map = {
    id = 1,
    name = 2,
    quality = 3,
    own_image = 4,
    enemy_image = 5,
    chapter_id = 6,
    group_num = 7,
    directions = 8,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_ksoul_fight_base_info")
        return t._raw[__key_map[k]]
    end
}

function ksoul_fight_base_info.getLength()
    return #ksoul_fight_base_info._data
end

function ksoul_fight_base_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function ksoul_fight_base_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = ksoul_fight_base_info._data[index]}, m)
end

function ksoul_fight_base_info.get(id)
    local k = id
    return ksoul_fight_base_info.indexOf(__index_id[k])
end

function ksoul_fight_base_info.set(id, key, value)
    local record = ksoul_fight_base_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function ksoul_fight_base_info.get_index_data()
    return __index_id
end

