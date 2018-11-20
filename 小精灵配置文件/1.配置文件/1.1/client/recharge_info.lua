local record_recharge_info = {}

record_recharge_info.id = 0 --id
record_recharge_info.app_id = "" --版本
record_recharge_info.product_id = "" --商品编号
record_recharge_info.name  = "" --名称
record_recharge_info.res_id = 0 --图标
record_recharge_info.size = 0 --充值金额
record_recharge_info.recharge_gold = 0 --钻石兑换数量
record_recharge_info.gift_gold_first = 0 --首次赠送钻石
record_recharge_info.gift_gold = 0 --非首次赠送钻石
record_recharge_info.gift_type_first = 0 --首次赠送道具类型
record_recharge_info.gift_value_first = 0 --首次赠送道具类型值
record_recharge_info.gift_size_first = 0 --首次赠送道具数量


recharge_info = {
    _data = {
    [1] = {501,"1","gold6","60钻石",8,6,60,60,6,0,0,1,},
    [2] = {502,"1","gold30","300钻石",2,30,300,300,30,0,0,1,},
    [3] = {503,"1","gold50","500钻石",3,50,500,1888,55,0,0,1,},
    [4] = {504,"1","gold128","1280钻石",4,128,1280,1280,145,0,0,1,},
    [5] = {505,"1","gold288","2880钻石",5,288,2880,2880,335,0,0,1,},
    [6] = {506,"1","gold548","5480钻石",9,548,5480,5480,650,0,0,1,},
    [7] = {507,"1","gold648","6480钻石",6,648,6480,6480,780,0,0,1,},
    [8] = {601,"2151","gold1","10钻石",1,1,10,10,0,3,217,1,},
    [9] = {602,"2151","gold6","60钻石",8,6,60,60,0,3,218,1,},
    [10] = {603,"2151","gold30","300钻石",2,30,300,300,30,3,219,1,},
    [11] = {604,"2151","gold50","500钻石",3,50,500,2888,55,3,220,1,},
    [12] = {605,"2151","gold128","1280钻石",4,128,1280,1280,145,3,221,1,},
    [13] = {606,"2151","gold288","2880钻石",5,288,2880,2880,335,3,222,1,},
    [14] = {607,"2151","gold548","5480钻石",9,548,5480,5480,650,3,223,1,},
    [15] = {608,"2151","gold648","6480钻石",6,648,6480,6480,780,3,224,1,},
    [16] = {700,"2033","gold1","10钻石",1,1,10,10,0,3,217,1,},
    [17] = {701,"2033","gold6","60钻石",8,6,60,60,0,3,218,1,},
    [18] = {702,"2033","gold30","300钻石",2,30,300,300,30,3,219,1,},
    [19] = {703,"2033","gold50","500钻石",3,50,500,2888,55,3,220,1,},
    [20] = {704,"2033","gold128","1280钻石",4,128,1280,1280,145,3,221,1,},
    [21] = {705,"2033","gold288","2880钻石",5,288,2880,2880,335,3,222,1,},
    [22] = {706,"2033","gold548","5480钻石",9,548,5480,5480,650,3,223,1,},
    [23] = {707,"2033","gold648","6480钻石",6,648,6480,6480,780,3,224,1,},
    [24] = {708,"2033","gold2048","20480钻石",7,2048,20480,20480,2480,3,225,1,},
    }
}

local __index_id = {
    [501] = 1,
    [502] = 2,
    [503] = 3,
    [504] = 4,
    [505] = 5,
    [506] = 6,
    [507] = 7,
    [601] = 8,
    [602] = 9,
    [603] = 10,
    [604] = 11,
    [605] = 12,
    [606] = 13,
    [607] = 14,
    [608] = 15,
    [700] = 16,
    [701] = 17,
    [702] = 18,
    [703] = 19,
    [704] = 20,
    [705] = 21,
    [706] = 22,
    [707] = 23,
    [708] = 24,
}

local __key_map = {
    id = 1,
    app_id = 2,
    product_id = 3,
    name  = 4,
    res_id = 5,
    size = 6,
    recharge_gold = 7,
    gift_gold_first = 8,
    gift_gold = 9,
    gift_type_first = 10,
    gift_value_first = 11,
    gift_size_first = 12,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_recharge_info")
        return t._raw[__key_map[k]]
    end
}

function recharge_info.getLength()
    return #recharge_info._data
end

function recharge_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function recharge_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = recharge_info._data[index]}, m)
end

function recharge_info.get(id)
    local k = id
    return recharge_info.indexOf(__index_id[k])
end

function recharge_info.set(id, key, value)
    local record = recharge_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function recharge_info.get_index_data()
    return __index_id
end

