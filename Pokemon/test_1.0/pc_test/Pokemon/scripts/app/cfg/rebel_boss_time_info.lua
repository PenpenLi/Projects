local record_rebel_boss_time_info={}


rebel_boss_time_info={
    _data = {
    [1]={},
    [2]={},
    }
}
local __index_id ={
[1]=1,
[2]=2,
}

local __key_map = {
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

        assert(__key_map[k], "cannot find " .. k .. " in record_rebel_boss_time_info")
        return t._raw[__key_map[k]]
    end
}

function rebel_boss_time_info.getLength()
    return #rebel_boss_time_info._data
end

function rebel_boss_time_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function rebel_boss_time_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = rebel_boss_time_info._data[index]}, m)
end
function rebel_boss_time_info.get(id)
    local k = id
    return rebel_boss_time_info.indexOf(__index_id[k])
end

function rebel_boss_time_info.set(id, key, value)
    local record = rebel_boss_time_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function rebel_boss_time_info.get_index_data()
    return __index_id
end
