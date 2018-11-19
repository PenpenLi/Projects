local record_treasure_robot_info = {}

record_treasure_robot_info.id = 0 --编号
record_treasure_robot_info.name = "" --角色名称


treasure_robot_info = {
    _data = {
    [1] = {1,"聪明的一休",},
    [2] = {2,"美丽的公主",},
    [3] = {3,"天边的乌云",},
    [4] = {4,"鲜艳的玫瑰",},
    [5] = {5,"有领导力的王者",},
    [6] = {6,"家庭化的小可爱",},
    [7] = {7,"勇于冒险的天使",},
    [8] = {8,"可爱的雯雯",},
    [9] = {9,"守纪律的豆包",},
    [10] = {10,"单身的小妞",},
    [11] = {11,"友好的豆浆",},
    [12] = {12,"绚丽的彩虹",},
    [13] = {13,"高档的迪克",},
    [14] = {14,"机灵的仙儿",},
    [15] = {15,"有激情的冷风",},
    [16] = {16,"诚信的倩倩",},
    [17] = {17,"有魄力的天宇",},
    [18] = {18,"有精神的仙儿",},
    [19] = {19,"令人自豪的卡卡",},
    [20] = {20,"勤奋的羊羊",},
    [21] = {21,"善于分析的阿萨",},
    [22] = {22,"真诚的momo",},
    [23] = {23,"拼搏的盖尔",},
    [24] = {24,"有动感的小兔",},
    [25] = {25,"严格的汉纳",},
    [26] = {26,"有内涵小妖",},
    [27] = {27,"开放的小神",},
    [28] = {28,"幽默的落落",},
    [29] = {29,"活跃的赫达",},
    [30] = {30,"灵巧的香香",},
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
    [22] = 22,
    [23] = 23,
    [24] = 24,
    [25] = 25,
    [26] = 26,
    [27] = 27,
    [28] = 28,
    [29] = 29,
    [30] = 30,
}

local __key_map = {
    id = 1,
    name = 2,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_treasure_robot_info")
        return t._raw[__key_map[k]]
    end
}

function treasure_robot_info.getLength()
    return #treasure_robot_info._data
end

function treasure_robot_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function treasure_robot_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = treasure_robot_info._data[index]}, m)
end

function treasure_robot_info.get(id)
    local k = id
    return treasure_robot_info.indexOf(__index_id[k])
end

function treasure_robot_info.set(id, key, value)
    local record = treasure_robot_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function treasure_robot_info.get_index_data()
    return __index_id
end

