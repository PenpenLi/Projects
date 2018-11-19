local record_rebel_boss_reward_info = {}

record_rebel_boss_reward_info.id = 0 --ID
record_rebel_boss_reward_info.name = "" --名字
record_rebel_boss_reward_info.boss_level = 0 --BOSS等级
record_rebel_boss_reward_info.type = 0 --奖励类型
record_rebel_boss_reward_info.value = 0 --奖励类型值
record_rebel_boss_reward_info.size = 0 --奖励数量


rebel_boss_reward_info = {
    _data = {
    [1] = {1,"全服玩家击败5级BOSS",5,3,14,5,},
    [2] = {2,"全服玩家击败10级BOSS",10,3,14,5,},
    [3] = {3,"全服玩家击败15级BOSS",15,3,14,5,},
    [4] = {4,"全服玩家击败20级BOSS",20,3,14,5,},
    [5] = {5,"全服玩家击败25级BOSS",25,3,14,5,},
    [6] = {6,"全服玩家击败30级BOSS",30,3,14,10,},
    [7] = {7,"全服玩家击败35级BOSS",35,3,14,10,},
    [8] = {8,"全服玩家击败40级BOSS",40,3,14,10,},
    [9] = {9,"全服玩家击败45级BOSS",45,3,14,10,},
    [10] = {10,"全服玩家击败50级BOSS",50,3,14,10,},
    [11] = {11,"全服玩家击败55级BOSS",55,3,14,20,},
    [12] = {12,"全服玩家击败60级BOSS",60,3,14,20,},
    [13] = {13,"全服玩家击败65级BOSS",65,3,14,20,},
    [14] = {14,"全服玩家击败70级BOSS",70,3,14,20,},
    [15] = {15,"全服玩家击败75级BOSS",75,3,14,20,},
    [16] = {16,"全服玩家击败80级BOSS",80,3,14,30,},
    [17] = {17,"全服玩家击败85级BOSS",85,3,14,30,},
    [18] = {18,"全服玩家击败90级BOSS",90,3,14,30,},
    [19] = {19,"全服玩家击败95级BOSS",95,3,14,30,},
    [20] = {20,"全服玩家击败100级BOSS",100,3,14,30,},
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
}

local __key_map = {
    id = 1,
    name = 2,
    boss_level = 3,
    type = 4,
    value = 5,
    size = 6,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_rebel_boss_reward_info")
        return t._raw[__key_map[k]]
    end
}

function rebel_boss_reward_info.getLength()
    return #rebel_boss_reward_info._data
end

function rebel_boss_reward_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function rebel_boss_reward_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = rebel_boss_reward_info._data[index]}, m)
end

function rebel_boss_reward_info.get(id)
    local k = id
    return rebel_boss_reward_info.indexOf(__index_id[k])
end

function rebel_boss_reward_info.set(id, key, value)
    local record = rebel_boss_reward_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function rebel_boss_reward_info.get_index_data()
    return __index_id
end

