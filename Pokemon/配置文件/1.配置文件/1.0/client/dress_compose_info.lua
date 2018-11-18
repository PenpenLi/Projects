local record_dress_compose_info = {}

record_dress_compose_info.id = 0 --id
record_dress_compose_info.name = "" --名字
record_dress_compose_info.dress_1 = 0 --时装1
record_dress_compose_info.dress_2 = 0 --时装2
record_dress_compose_info.dress_3 = 0 --时装3
record_dress_compose_info.attribute_type_1 = 0 --属性1类型
record_dress_compose_info.attribute_value_1 = 0 --属性1值
record_dress_compose_info.attribute_type_2 = 0 --属性2类型
record_dress_compose_info.attribute_value_2 = 0 --属性2值
record_dress_compose_info.attribute_type_3 = 0 --属性3类型
record_dress_compose_info.attribute_value_3 = 0 --属性3值
record_dress_compose_info.attribute_type_4 = 0 --属性4类型
record_dress_compose_info.attribute_value_4 = 0 --属性4值


dress_compose_info = {
    _data = {
    [1] = {1,"剑球组合",101,102,0,21,300,0,0,0,0,0,0,},
    [2] = {2,"原子师徒",201,202,0,22,100,23,100,0,0,0,0,},
    [3] = {3,"机械英雄",301,302,0,22,100,23,100,0,0,0,0,},
    [4] = {4,"S级门神",401,402,0,22,100,23,100,0,0,0,0,},
    [5] = {5,"进化之家",501,502,0,22,100,23,100,0,0,0,0,},
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
    dress_1 = 3,
    dress_2 = 4,
    dress_3 = 5,
    attribute_type_1 = 6,
    attribute_value_1 = 7,
    attribute_type_2 = 8,
    attribute_value_2 = 9,
    attribute_type_3 = 10,
    attribute_value_3 = 11,
    attribute_type_4 = 12,
    attribute_value_4 = 13,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_dress_compose_info")
        return t._raw[__key_map[k]]
    end
}

function dress_compose_info.getLength()
    return #dress_compose_info._data
end

function dress_compose_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function dress_compose_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = dress_compose_info._data[index]}, m)
end

function dress_compose_info.get(id)
    local k = id
    return dress_compose_info.indexOf(__index_id[k])
end

function dress_compose_info.set(id, key, value)
    local record = dress_compose_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function dress_compose_info.get_index_data()
    return __index_id
end

