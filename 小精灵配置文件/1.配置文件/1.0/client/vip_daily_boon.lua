local record_vip_daily_boon = {}

record_vip_daily_boon.id = 0 --礼包ID
record_vip_daily_boon.vip_level = 0 --可购买VIP等级
record_vip_daily_boon.res_id_1 = 0 --销售NPC
record_vip_daily_boon.talk_1 = "" --NPC对话
record_vip_daily_boon.res_id_2 = 0 --推广NPC
record_vip_daily_boon.talk_2 = "" --NPC对话
record_vip_daily_boon.item_1_type = 0 --礼包物品1类型
record_vip_daily_boon.item_1_value = 0 --礼包物品1类型值
record_vip_daily_boon.item_1_size = 0 --礼包物品1数量
record_vip_daily_boon.item_2_type = 0 --礼包物品2类型
record_vip_daily_boon.item_2_value = 0 --礼包物品2类型值
record_vip_daily_boon.item_2_size = 0 --礼包物品2数量
record_vip_daily_boon.item_3_type = 0 --礼包物品3类型
record_vip_daily_boon.item_3_value = 0 --礼包物品3类型值
record_vip_daily_boon.item_3_size = 0 --礼包物品3数量
record_vip_daily_boon.item_4_type = 0 --礼包物品4类型
record_vip_daily_boon.item_4_value = 0 --礼包物品4类型值
record_vip_daily_boon.item_4_size = 0 --礼包物品4数量
record_vip_daily_boon.item_5_type = 0 --礼包物品5类型
record_vip_daily_boon.item_5_value = 0 --礼包物品5类型值
record_vip_daily_boon.item_5_size = 0 --礼包物品5数量


vip_daily_boon = {
    _data = {
    [1] = {1,0,12008,"不充钱也能玩的开心，每天都要来领VIP福利哦！",12008,"只要一个汉堡的钱，V0福利就可以升级到V1啦！",1,0,30000,0,0,0,0,0,0,0,0,0,0,0,0,},
    [2] = {2,1,11013,"每天都在这里发V1福利，感觉好开心哦！",11013,"帅哥美女，要不要包月呀？~包月就可以升到V2了！",1,0,60000,0,0,0,0,0,0,0,0,0,0,0,0,},
    [3] = {3,2,11043,"每天都可以拿福利，你们开心吗！",11043,"V3福利包括所有V2福利内容，还有更多喔",1,0,90000,0,0,0,0,0,0,0,0,0,0,0,0,},
    [4] = {4,3,11001,"每天都可以拿福利，你们开心吗！",11001,"V4福利包括所有V3福利内容，还有更多喔",1,0,120000,3,14,5,0,0,0,0,0,0,0,0,0,},
    [5] = {5,4,11015,"每天都可以拿福利，你们开心吗！",11015,"V5福利包括所有V4福利内容，还有更多喔",1,0,150000,3,14,10,0,0,0,0,0,0,0,0,0,},
    [6] = {6,5,11008,"每天都可以拿福利，你们开心吗！",11008,"V6福利包括所有V5福利内容，还有更多喔",1,0,180000,3,14,15,3,13,5,0,0,0,0,0,0,},
    [7] = {7,6,11018,"每天都可以拿福利，你们开心吗！",11018,"V7福利包括所有V6福利内容，还有更多喔",1,0,210000,3,14,20,3,13,10,3,18,20,0,0,0,},
    [8] = {8,7,12003,"每天都可以拿福利，你们开心吗！",12003,"V8福利包括所有V7福利内容，还有更多喔",1,0,240000,3,14,25,3,13,15,3,18,30,0,0,0,},
    [9] = {9,8,12001,"每天都可以拿福利，你们开心吗！",12001,"V9福利包括所有V8福利内容，还有更多喔",1,0,270000,3,14,30,3,13,20,3,18,40,3,60,50,},
    [10] = {10,9,12009,"每天都可以拿福利，你们开心吗！",12009,"V10福利包括所有V9福利内容，还有更多喔",1,0,300000,3,14,35,3,13,25,3,18,50,3,60,100,},
    [11] = {11,10,13005,"每天都可以拿福利，你们开心吗！",13005,"V11福利包括所有V10福利内容，还有更多喔",1,0,330000,3,14,40,3,13,30,3,18,60,3,60,150,},
    [12] = {12,11,12019,"每天都可以拿福利，你们开心吗！",12019,"V12福利包括所有V11福利内容，还有更多喔",1,0,360000,3,14,45,3,13,35,3,18,70,3,60,200,},
    [13] = {13,12,14018,"每天都可以拿福利，你们开心吗！",14018,"0",1,0,400000,3,14,50,3,13,40,3,18,80,3,60,300,},
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
    res_id_1 = 3,
    talk_1 = 4,
    res_id_2 = 5,
    talk_2 = 6,
    item_1_type = 7,
    item_1_value = 8,
    item_1_size = 9,
    item_2_type = 10,
    item_2_value = 11,
    item_2_size = 12,
    item_3_type = 13,
    item_3_value = 14,
    item_3_size = 15,
    item_4_type = 16,
    item_4_value = 17,
    item_4_size = 18,
    item_5_type = 19,
    item_5_value = 20,
    item_5_size = 21,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_vip_daily_boon")
        return t._raw[__key_map[k]]
    end
}

function vip_daily_boon.getLength()
    return #vip_daily_boon._data
end

function vip_daily_boon.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function vip_daily_boon.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = vip_daily_boon._data[index]}, m)
end

function vip_daily_boon.get(id)
    local k = id
    return vip_daily_boon.indexOf(__index_id[k])
end

function vip_daily_boon.set(id, key, value)
    local record = vip_daily_boon.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function vip_daily_boon.get_index_data()
    return __index_id
end

