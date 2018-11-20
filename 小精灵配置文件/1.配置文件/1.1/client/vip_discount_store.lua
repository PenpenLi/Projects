local record_vip_discount_store = {}

record_vip_discount_store.id = 0 --礼包ID
record_vip_discount_store.vip_level = 0 --可购买VIP等级
record_vip_discount_store.res_id = 0 --销售NPC
record_vip_discount_store.original_cost = 0 --原价
record_vip_discount_store.current_cost = 0 --现价
record_vip_discount_store.item_1_type = 0 --礼包物品1类型
record_vip_discount_store.item_1_value = 0 --礼包物品1类型值
record_vip_discount_store.item_1_size = 0 --礼包物品1数量
record_vip_discount_store.item_2_type = 0 --礼包物品2类型
record_vip_discount_store.item_2_value = 0 --礼包物品2类型值
record_vip_discount_store.item_2_size = 0 --礼包物品2数量
record_vip_discount_store.item_3_type = 0 --礼包物品3类型
record_vip_discount_store.item_3_value = 0 --礼包物品3类型值
record_vip_discount_store.item_3_size = 0 --礼包物品3数量
record_vip_discount_store.item_4_type = 0 --礼包物品4类型
record_vip_discount_store.item_4_value = 0 --礼包物品4类型值
record_vip_discount_store.item_4_size = 0 --礼包物品4数量
record_vip_discount_store.talk_1 = "" --NPC对话
record_vip_discount_store.talk_2 = "" --NPC对话
record_vip_discount_store.talk_3 = "" --NPC对话


vip_discount_store = {
    _data = {
    [1] = {1,0,12008,500,250,1,0,500000,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [2] = {2,1,11013,250,125,3,5,10,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [3] = {3,2,11043,250,125,3,4,10,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [4] = {4,3,11001,600,300,3,22,5,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [5] = {5,4,11015,600,300,3,21,5,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [6] = {6,5,11008,1000,500,13,0,1000,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [7] = {7,6,11018,1000,500,3,15,50,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [8] = {8,7,12003,1000,500,3,12,100,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [9] = {9,8,12001,2500,1250,3,18,500,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [10] = {10,9,12009,3000,1500,3,60,1000,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [11] = {11,10,13005,2000,1000,3,13,100,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [12] = {12,11,12019,5000,2500,3,18,1000,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
    [13] = {13,12,14018,7500,3750,3,60,2500,0,0,0,0,0,0,0,0,0,"钱不是万能的，没有钱是万万不能的~","在家靠父母，在外靠朋友，给你打个折~","给你点个赞！",},
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
}

local __key_map = {
    id = 1,
    vip_level = 2,
    res_id = 3,
    original_cost = 4,
    current_cost = 5,
    item_1_type = 6,
    item_1_value = 7,
    item_1_size = 8,
    item_2_type = 9,
    item_2_value = 10,
    item_2_size = 11,
    item_3_type = 12,
    item_3_value = 13,
    item_3_size = 14,
    item_4_type = 15,
    item_4_value = 16,
    item_4_size = 17,
    talk_1 = 18,
    talk_2 = 19,
    talk_3 = 20,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_vip_discount_store")
        return t._raw[__key_map[k]]
    end
}

function vip_discount_store.getLength()
    return #vip_discount_store._data
end

function vip_discount_store.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function vip_discount_store.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = vip_discount_store._data[index]}, m)
end

function vip_discount_store.get(id)
    local k = id
    return vip_discount_store.indexOf(__index_id[k])
end

function vip_discount_store.set(id, key, value)
    local record = vip_discount_store.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function vip_discount_store.get_index_data()
    return __index_id
end

