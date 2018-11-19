local record_special_holiday_change = {}

record_special_holiday_change.id = 0 --编号
record_special_holiday_change.type = 0 --类型
record_special_holiday_change.type_value = "" --类型值


special_holiday_change = {
    _data = {
    [1] = {1,1,"1",},
    [2] = {2,2,"303",},
    [3] = {3,3,"304",},
    [4] = {4,4,"2",},
    [5] = {5,11,"时段活动",},
    [6] = {6,21,"试炼塔",},
    [7] = {7,22,"试炼塔",},
    [8] = {8,23,"试炼塔",},
    [9] = {9,24,"试炼塔",},
    [10] = {10,31,"夺宝奇兵",},
    [11] = {11,41,"半价贩售",},
    [12] = {12,51,"时段活动",},
    [13] = {13,52,"试炼塔",},
    [14] = {14,53,"夺宝奇兵",},
    [15] = {15,54,"半价贩售",},
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
    type = 2,
    type_value = 3,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_special_holiday_change")
        return t._raw[__key_map[k]]
    end
}

function special_holiday_change.getLength()
    return #special_holiday_change._data
end

function special_holiday_change.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function special_holiday_change.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = special_holiday_change._data[index]}, m)
end

function special_holiday_change.get(id)
    local k = id
    return special_holiday_change.indexOf(__index_id[k])
end

function special_holiday_change.set(id, key, value)
    local record = special_holiday_change.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function special_holiday_change.get_index_data()
    return __index_id
end

