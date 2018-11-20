local record_login_reward_info_2 = {}

record_login_reward_info_2.day = 0 --类型
record_login_reward_info_2.type = 0 --天数
record_login_reward_info_2.value = 0 --物品类型1
record_login_reward_info_2.reward = "" --类型值1
record_login_reward_info_2.size = 0 --数量1
record_login_reward_info_2.vip_level = 0 --物品类型2
record_login_reward_info_2.version = 0 --类型值2


login_reward_info_2 = {
    _data = {
    [1] = {1,1,0,"金币",50000,0,1,},
    [2] = {2,6,3001,"警察电棒碎片",16,0,1,},
    [3] = {3,6,3001,"警察电棒碎片",16,0,1,},
    [4] = {4,3,5,"体力可乐",4,0,1,},
    [5] = {5,3,6,"进化石",100,1,1,},
    [6] = {6,2,0,"钻石",100,0,1,},
    [7] = {7,6,3002,"警察手套碎片",16,0,1,},
    [8] = {8,6,3002,"警察手套碎片",16,0,1,},
    [9] = {9,3,4,"精力可乐",4,2,1,},
    [10] = {10,3,9,"培养胶囊",60,0,1,},
    [11] = {11,2,0,"钻石",200,0,1,},
    [12] = {12,3,15,"刷新石",15,0,1,},
    [13] = {13,3,10,"初级精炼石",150,3,1,},
    [14] = {14,2,0,"钻石",300,0,1,},
    [15] = {15,6,3003,"警察帽子碎片",16,0,1,},
    [16] = {16,6,3003,"警察帽子碎片",16,0,1,},
    [17] = {17,4,2003,"金经验宝宝",5,4,1,},
    [18] = {18,3,5,"体力可乐",10,0,1,},
    [19] = {19,3,4,"精力可乐",10,0,1,},
    [20] = {20,3,6,"进化石",200,0,1,},
    [21] = {21,3,18,"徽章精炼石",80,5,1,},
    [22] = {22,2,0,"钻石",400,0,1,},
    [23] = {23,7,2,"金经验徽章",2,0,1,},
    [24] = {24,3,5,"体力可乐",15,0,1,},
    [25] = {25,3,4,"精力可乐",15,0,1,},
    [26] = {26,3,6,"进化石",300,0,1,},
    [27] = {27,3,14,"潜力胶囊",30,6,1,},
    [28] = {28,2,0,"钻石",500,0,1,},
    [29] = {29,6,3004,"警察装碎片",16,0,1,},
    [30] = {30,6,3004,"警察装碎片",16,0,1,},
    [31] = {31,1,0,"金币",100000,0,1,},
    }
}

local __index_day = {
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
    [22] = 22,
    [23] = 23,
    [24] = 24,
    [25] = 25,
    [26] = 26,
    [27] = 27,
    [28] = 28,
    [29] = 29,
    [30] = 30,
    [31] = 31,
}

local __key_map = {
    day = 1,
    type = 2,
    value = 3,
    reward = 4,
    size = 5,
    vip_level = 6,
    version = 7,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_login_reward_info_2")
        return t._raw[__key_map[k]]
    end
}

function login_reward_info_2.getLength()
    return #login_reward_info_2._data
end

function login_reward_info_2.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function login_reward_info_2.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = login_reward_info_2._data[index]}, m)
end

function login_reward_info_2.get(day)
    local k = day
    return login_reward_info_2.indexOf(__index_day[k])
end

function login_reward_info_2.set(day, key, value)
    local record = login_reward_info_2.get(day)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function login_reward_info_2.get_index_data()
    return __index_day
end

