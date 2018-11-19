local record_knight_halo_info = {}

record_knight_halo_info.id = 0 --编号
record_knight_halo_info.level = 0 --等级
record_knight_halo_info.name = "" --名称
record_knight_halo_info.attack_add = 0 --攻击加成
record_knight_halo_info.health_add = 0 --生命加成
record_knight_halo_info.phy_defence_add = 0 --物防加成
record_knight_halo_info.magic_defence_add = 0 --法防加成
record_knight_halo_info.levelup_value = 0 --升级所需成长值
record_knight_halo_info.single_cost = 0 --单次消耗
record_knight_halo_info.single_growth = 0 --单次成长值
record_knight_halo_info.expected_value = 0 --期望升级消耗材料
record_knight_halo_info.low_exp = 0 --低概率经验
record_knight_halo_info.lower_exp = 0 --较低概率经验
record_knight_halo_info.common_exp = 0 --较高概率经验
record_knight_halo_info.higher_exp = 0 --很高概率经验
record_knight_halo_info.high_exp = 0 --极高概率经验


knight_halo_info = {
    _data = {
    [1] = {1,1,"潜力1级",0,0,0,0,120,2,2,72,48,67,86,105,99999,},
    [2] = {2,2,"潜力2级",60,60,60,60,240,5,5,144,96,134,172,211,99999,},
    [3] = {3,3,"潜力3级",120,120,120,120,480,8,8,288,192,268,345,422,99999,},
    [4] = {4,4,"潜力4级",180,180,180,180,960,12,12,576,384,537,691,844,99999,},
    [5] = {5,5,"潜力5级",240,240,240,240,1440,12,12,864,576,806,1036,1267,99999,},
    [6] = {6,6,"潜力6级",300,300,300,300,2400,16,16,1440,960,1344,1728,2112,99999,},
    [7] = {7,7,"潜力7级",360,360,360,360,3600,16,16,2160,1440,2016,2592,3168,99999,},
    [8] = {8,8,"潜力8级",420,420,420,420,4800,20,20,2880,1920,2688,3456,4224,99999,},
    [9] = {9,9,"潜力9级",480,480,480,480,7200,20,20,4320,2880,4032,5184,6336,99999,},
    [10] = {10,10,"潜力10级",540,540,540,540,10800,20,20,6480,4320,6048,7776,9504,99999,},
    [11] = {11,11,"潜力11级",600,600,600,600,14400,20,20,8640,5760,8063,10368,12672,99999,},
    [12] = {12,12,"潜力12级",660,660,660,660,19600,20,20,11760,7840,10976,14112,17248,99999,},
    [13] = {13,13,"潜力13级",720,720,720,720,24000,20,20,14400,9600,13440,17280,21120,99999,},
    [14] = {14,14,"潜力14级",780,780,780,780,32600,20,20,19560,13040,18256,23472,28688,99999,},
    [15] = {15,15,"潜力15级",840,840,840,840,0,0,0,0,99999,99999,99999,99999,99999,},
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
}

local __key_map = {
    id = 1,
    level = 2,
    name = 3,
    attack_add = 4,
    health_add = 5,
    phy_defence_add = 6,
    magic_defence_add = 7,
    levelup_value = 8,
    single_cost = 9,
    single_growth = 10,
    expected_value = 11,
    low_exp = 12,
    lower_exp = 13,
    common_exp = 14,
    higher_exp = 15,
    high_exp = 16,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_knight_halo_info")
        return t._raw[__key_map[k]]
    end
}

function knight_halo_info.getLength()
    return #knight_halo_info._data
end

function knight_halo_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function knight_halo_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = knight_halo_info._data[index]}, m)
end

function knight_halo_info.get(id)
    local k = id
    return knight_halo_info.indexOf(__index_id[k])
end

function knight_halo_info.set(id, key, value)
    local record = knight_halo_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function knight_halo_info.get_index_data()
    return __index_id
end

