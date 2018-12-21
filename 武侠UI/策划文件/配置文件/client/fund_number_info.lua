local record_fund_number_info = {}

record_fund_number_info.id = 0 --id
record_fund_number_info.buy_number = 0 --购买人数
record_fund_number_info.name = "" --奖励
record_fund_number_info.type = 0 --货物类型
record_fund_number_info.value = 0 --货物类型值
record_fund_number_info.size = 0 --货物数量


fund_number_info = {
    _data = {
    [1] = {1,10,"金经验雕像",4,2003,1,},
    [2] = {2,30,"10万金币",1,0,100000,},
    [3] = {3,50,"20万金币",1,0,200000,},
    [4] = {4,70,"精力可乐*10",3,4,10,},
    [5] = {5,100,"中级精炼石*100",3,11,100,},
    [6] = {6,150,"徽章精炼石*100",3,18,100,},
    [7] = {7,200,"潜力胶囊*100",3,14,100,},
    [8] = {8,500,"黑寡妇眼罩",5,4023,1,},
    [9] = {9,1000,"钻石*1500",2,0,1500,},
    [10] = {10,1500,"钻石*2000",2,0,2000,},
    [11] = {11,2000,"钻石*3000",2,0,3000,},
    [12] = {12,3000,"钻石*5000",2,0,5000,},
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
}

local __key_map = {
    id = 1,
    buy_number = 2,
    name = 3,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_fund_number_info")
        return t._raw[__key_map[k]]
    end
}

function fund_number_info.getLength()
    return #fund_number_info._data
end

function fund_number_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function fund_number_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = fund_number_info._data[index]}, m)
end

function fund_number_info.get(id)
    local k = id
    return fund_number_info.indexOf(__index_id[k])
end

function fund_number_info.set(id, key, value)
    local record = fund_number_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function fund_number_info.get_index_data()
    return __index_id
end

