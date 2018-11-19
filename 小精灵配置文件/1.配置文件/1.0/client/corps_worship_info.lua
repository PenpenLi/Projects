local record_corps_worship_info = {}

record_corps_worship_info.id = 0 --id
record_corps_worship_info.name = "" --名称
record_corps_worship_info.vip = 0 --VIP等级限制
record_corps_worship_info.price_type = 0 --购买货币类型
record_corps_worship_info.price = 0 --购买价格
record_corps_worship_info.worship_value = 0 --祈祷进度
record_corps_worship_info.corps_integral = 0 --公会贡献
record_corps_worship_info.corps_exp = 0 --公会经验
record_corps_worship_info.crit_chance = 0 --暴击概率
record_corps_worship_info.crit_multiplier  = 0 --暴击倍数


corps_worship_info = {
    _data = {
    [1] = {1,"鬼级预言",0,1,10000,1,100,10,200,500,},
    [2] = {2,"龙级预言",0,2,30,3,500,50,200,500,},
    [3] = {3,"神级预言",1,2,298,5,3000,300,200,500,},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
}

local __key_map = {
    id = 1,
    name = 2,
    vip = 3,
    price_type = 4,
    price = 5,
    worship_value = 6,
    corps_integral = 7,
    corps_exp = 8,
    crit_chance = 9,
    crit_multiplier  = 10,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_corps_worship_info")
        return t._raw[__key_map[k]]
    end
}

function corps_worship_info.getLength()
    return #corps_worship_info._data
end

function corps_worship_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function corps_worship_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = corps_worship_info._data[index]}, m)
end

function corps_worship_info.get(id)
    local k = id
    return corps_worship_info.indexOf(__index_id[k])
end

function corps_worship_info.set(id, key, value)
    local record = corps_worship_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function corps_worship_info.get_index_data()
    return __index_id
end

