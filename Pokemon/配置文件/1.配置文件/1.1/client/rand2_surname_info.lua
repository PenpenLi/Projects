local record_rand2_surname_info = {}

record_rand2_surname_info.id = 0 --编号
record_rand2_surname_info.surname = "" --姓氏


rand2_surname_info = {
    _data = {
    [1] = {1,"的",},
    [2] = {2,"之",},
    [3] = {3,"得",},
    [4] = {4,"の",},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
}

local __key_map = {
    id = 1,
    surname = 2,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_rand2_surname_info")
        return t._raw[__key_map[k]]
    end
}

function rand2_surname_info.getLength()
    return #rand2_surname_info._data
end

function rand2_surname_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function rand2_surname_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = rand2_surname_info._data[index]}, m)
end

function rand2_surname_info.get(id)
    local k = id
    return rand2_surname_info.indexOf(__index_id[k])
end

function rand2_surname_info.set(id, key, value)
    local record = rand2_surname_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function rand2_surname_info.get_index_data()
    return __index_id
end

