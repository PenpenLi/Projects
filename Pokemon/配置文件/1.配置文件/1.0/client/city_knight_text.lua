local record_city_knight_text = {}

record_city_knight_text.id = 0 --id
record_city_knight_text.city_id = "" --城市
record_city_knight_text.text = "" --巡逻语言


city_knight_text = {
    _data = {
    [1] = {1,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [2] = {2,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [3] = {3,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [4] = {4,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [5] = {5,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [6] = {6,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [7] = {7,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [8] = {8,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [9] = {9,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
    [10] = {10,"0","勇敢的英雄啊，快去挑战副本，平息灾害吧！这里有我！",},
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
}

local __key_map = {
    id = 1,
    city_id = 2,
    text = 3,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_city_knight_text")
        return t._raw[__key_map[k]]
    end
}

function city_knight_text.getLength()
    return #city_knight_text._data
end

function city_knight_text.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function city_knight_text.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = city_knight_text._data[index]}, m)
end

function city_knight_text.get(id)
    local k = id
    return city_knight_text.indexOf(__index_id[k])
end

function city_knight_text.set(id, key, value)
    local record = city_knight_text.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function city_knight_text.get_index_data()
    return __index_id
end

