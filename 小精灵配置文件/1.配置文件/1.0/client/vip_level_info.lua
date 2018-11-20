local record_vip_level_info = {}

record_vip_level_info.id = 0 --等级id
record_vip_level_info.level = 0 --VIP等级
record_vip_level_info.low_value = 0 --最低成长值
record_vip_level_info.function_id_1 = 0 --系统特权id1
record_vip_level_info.function_type_1 = 0 --系统特权类型id1
record_vip_level_info.function_id_2 = 0 --系统特权id2
record_vip_level_info.function_type_2 = 0 --系统特权类型id2
record_vip_level_info.function_id_3 = 0 --系统特权id3
record_vip_level_info.function_type_3 = 0 --系统特权类型id3
record_vip_level_info.function_id_4 = 0 --系统特权id4
record_vip_level_info.function_type_4 = 0 --系统特权类型id4
record_vip_level_info.function_id_5 = 0 --系统特权id5
record_vip_level_info.function_type_5 = 0 --系统特权类型id5
record_vip_level_info.function_id_6 = 0 --系统特权id6
record_vip_level_info.function_type_6 = 0 --系统特权类型id6
record_vip_level_info.function_id_7 = 0 --系统特权id7
record_vip_level_info.function_type_7 = 0 --系统特权类型id7
record_vip_level_info.function_id_8 = 0 --系统特权id8
record_vip_level_info.function_type_8 = 0 --系统特权类型id8
record_vip_level_info.function_id_9 = 0 --系统特权id9
record_vip_level_info.function_type_9 = 0 --系统特权类型id9
record_vip_level_info.function_id_10 = 0 --系统特权id10
record_vip_level_info.function_type_10 = 0 --系统特权类型id10
record_vip_level_info.function_id_11 = 0 --系统特权id11
record_vip_level_info.function_type_11 = 0 --系统特权类型id11
record_vip_level_info.function_id_12 = 0 --系统特权id12
record_vip_level_info.function_type_12 = 0 --系统特权类型id12
record_vip_level_info.function_id_13 = 0 --系统特权id13
record_vip_level_info.function_type_13 = 0 --系统特权类型id13
record_vip_level_info.function_id_14 = 0 --系统特权id14
record_vip_level_info.function_type_14 = 0 --系统特权类型id14
record_vip_level_info.function_id_15 = 0 --系统特权id15
record_vip_level_info.function_type_15 = 0 --系统特权类型id15
record_vip_level_info.function_id_16 = 0 --系统特权id16
record_vip_level_info.function_type_16 = 0 --系统特权类型id16
record_vip_level_info.function_id_17 = 0 --系统特权id17
record_vip_level_info.function_type_17 = 0 --系统特权类型id17
record_vip_level_info.function_id_18 = 0 --系统特权id18
record_vip_level_info.function_type_18 = 0 --系统特权类型id18
record_vip_level_info.function_id_19 = 0 --系统特权id19
record_vip_level_info.function_type_19 = 0 --系统特权类型id19
record_vip_level_info.function_id_20 = 0 --系统特权id20
record_vip_level_info.function_type_20 = 0 --系统特权类型id20
record_vip_level_info.function_id_21 = 0 --系统特权id21
record_vip_level_info.function_type_21 = 0 --系统特权类型id21
record_vip_level_info.function_id_22 = 0 --系统特权id22
record_vip_level_info.function_type_22 = 0 --系统特权类型id22
record_vip_level_info.function_id_23 = 0 --系统特权id23
record_vip_level_info.function_type_23 = 0 --系统特权类型id23
record_vip_level_info.function_id_24 = 0 --系统特权id24
record_vip_level_info.function_type_24 = 0 --系统特权类型id24
record_vip_level_info.function_id_25 = 0 --系统特权id25
record_vip_level_info.function_type_25 = 0 --系统特权类型id25
record_vip_level_info.vip_dungeon_1 = 0 --定制副本id1
record_vip_level_info.vip_dungeon_2 = 0 --定制副本id2
record_vip_level_info.vip_dungeon_3 = 0 --定制副本id3
record_vip_level_info.vip_dungeon_4 = 0 --定制副本id4
record_vip_level_info.vip_dungeon_5 = 0 --定制副本id5
record_vip_level_info.vip_dungeon_6 = 0 --定制副本id6
record_vip_level_info.vip_dungeon_7 = 0 --定制副本id7
record_vip_level_info.vip_dungeon_8 = 0 --定制副本id8
record_vip_level_info.vip_dungeon_9 = 0 --定制副本id9
record_vip_level_info.vip_dungeon_10 = 0 --定制副本id10
record_vip_level_info.function_direction = "" --特权描述
record_vip_level_info.up_direction = "" --升级面板描述
record_vip_level_info.new_open = 0 --新增日常副本


vip_level_info = {
    _data = {
    [1] = {1,0,0,2,4,3,7,4,8,5,12,73,3,74,17,75,18,78,19,93,22,106,23,142,26,152,27,119,24,162,25,175,28,190,31,227,30,228,34,232,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.装备强化20%概率额外提升一级\n2.城市守护中每日可以帮助好友处理暴动事件10次\n3.主线副本每日可以重置1次\n4.试炼塔每日可以重置3次\n5.英雄商店每日可以刷新20次\n6.升星商店每日可以刷新20次\n7.每日可以购买出击令10个\n8.每天可以购买5次体力可乐\n9.每天可以购买5次精力可乐\n10.每天可以购买5次金经验雕像\n11.每天可以购买15次金币\n12.每天可以购买5次橙色装备箱子\n13.每天可以购买5次橙色徽章箱子。\n14.公会副本，每日可购买2次挑战次数。\n15.银行取款，每日可以取款3次。","unknown",0,},
    [2] = {2,1,60,10,1,11,7,79,19,83,12,88,20,94,22,107,23,143,26,153,27,120,24,163,25,176,28,203,32,215,33,191,31,233,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.开启战斗三倍速\n2.主线副本每日可以重置2次\n3.英雄背包额外增加5\n4.徽章背包额外增加5\n5.城市守护中每日可以帮助好友处理暴动事件15次\n6.英雄商店每日可以刷新25次\n7.升星商店每日可以刷新25次\n8.每天可以购买8次体力可乐\n9.每天可以购买8次精力可乐\n10.每天可以购买7次金经验雕像\n11.每天可以购买25次金币\n12.每天可以购买8次橙色装备箱子\n13.每天可以购买7次橙色徽章箱子\n14.公会副本，每日可购买4次挑战次数\n15.银行取款，每日可以取款5次。","unknown",0,},
    [3] = {3,2,300,84,12,95,22,108,23,143,26,153,27,121,24,122,24,164,25,177,28,177,28,204,32,216,33,192,31,234,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.公会预言中，开启神级预言。\n2.英雄商店每日可以刷新30次\n3.升星商店每日可以刷新30次\n4.每天可以购买11次体力可乐\n5.每天可以购买11次精力可乐\n6.每天可以购买9次金经验雕像\n7.每天可以购买35次金币\n8.每天可以购买11次橙色装备箱子\n9.每天可以购买9次橙色徽章箱子\n10.公会副本，每日可购买8次挑战次数\n11.银行取款，每日可取款7次。","unknown",0,},
    [4] = {4,3,1000,18,4,19,7,21,12,80,19,96,22,109,23,144,26,154,27,123,24,165,25,205,32,217,33,193,31,235,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.装备强化有30%几率额外提升一级\n2.英雄背包额外增加10\n3.徽章背包额外增加10\n4.开启夺宝5次（VIP3并且到达16级开启）\n5.主线副本每日可以重置3次\n6.每日可以购买出击令20个\n7.英雄商店每日可以刷新40次\n8.升星商店每日可以刷新40次\n9.每天可以购买14次体力可乐\n10.每天可以购买14次精力可乐\n11.每天可以购买11次金经验雕像\n12.每天可以购买45次金币\n13.每天可以购买14次橙色装备箱子\n14.每天可以购买11次橙色徽章箱子\n15.银行取款，每日可取款9次。","unknown",0,},
    [5] = {5,4,2000,25,3,76,18,85,12,97,22,110,23,144,26,154,27,166,25,178,28,206,32,218,33,194,31,229,34,236,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.开启培养5次。\n2.试炼塔开启一键3星，可以快速扫荡试炼塔了。\n3.英雄背包额外增加20。\n4.徽章背包额外增加20。\n5.城市守护开启每20分钟收益。\n6.英雄商店每日可以刷新50次。\n7.升星商店每日可以刷新50次。\n8.城市守护中每日可以帮助好友处理暴动事件20次。\n9.每天可以购买17次体力可乐。\n10.每天可以购买17次精力可乐。\n11.每天可以购买13次金经验雕像。\n12.每天可以购买55次金币。\n13.每天可以购买17次橙色装备箱子。\n14.每天可以购买13次橙色徽章箱子。\n15.公会副本，每日可购买12次挑战次数。\n16.银行取款，每日可取款11次。","unknown",0,},
    [6] = {6,5,5000,33,3,34,7,36,12,98,22,111,23,145,26,155,27,124,24,167,25,207,32,219,33,195,31,237,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.开启培养10次\n2.竞技场开启连战5次\n3.平息灾害开启跳过功能\n4.主线副本每日可以重置4次\n5.英雄背包额外增加30\n6.徽章背包额外增加30\n7.每日可以购买出击令30个\n8.英雄商店每日可以刷新60次\n8.升星商店每日可以刷新60次\n9.每天可以购买20次体力可乐\n10.每天可以购买20次精力可乐\n11.每天可以购买15次金经验雕像\n12.每天可以购买65次金币\n13.每天可以购买20次橙色装备箱子\n14.每天可以购买15次橙色徽章箱子\n15.银行取款，每日可取款13次。","unknown",0,},
    [7] = {7,6,10000,40,5,81,19,86,12,99,22,112,23,145,26,155,27,125,24,168,25,179,28,208,32,220,33,196,31,238,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.装备强化有10%几率额外提升两级\n2.开启一键夺宝\n3.英雄背包额外增加40\n4.徽章背包额外增加40\n5.城市守护中每日可以帮助好友处理暴动事件25次\n6.英雄商店每日可以刷新70次\n7.升星商店每日可以刷新70次\n8.每天可以购买23次体力可乐\n9.每天可以购买23次精力可乐\n10.每天可以购买18次金经验雕像\n11.每天可以购买75次金币\n12.每天可以购买23次橙色装备箱子\n13.每天可以购买17次橙色徽章箱子\n14.公会副本，每日可购买16次挑战次数.\n15.银行取款，每日可取款15次。","unknown",0,},
    [8] = {8,7,20000,48,12,82,19,100,22,113,23,146,26,156,27,126,24,169,25,180,28,209,32,221,33,197,31,239,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.英雄背包额外增加50\n2.徽章背包额外增加50\n3.每天可以购买26次体力可乐\n4.每天可以购买26次精力可乐\n5.每日可以购买出击令40个\n6.每天可以购买21次金经验雕像\n7.每天可以购买85次金币\n8.每天可以购买26次橙色装备箱子\n9.每天可以购买19次橙色徽章箱子\n10.城市守护中每日可以帮助好友处理暴动事件30次\n11.英雄商店每日可以刷新80次\n12.升星商店每日可以刷新80次\n13.公会副本，每日可购买22次挑战次数\n14.银行取款，每日可取款17次。","unknown",0,},
    [9] = {9,8,50000,55,13,77,18,87,12,101,22,114,23,147,26,157,27,127,24,170,25,181,28,188,29,210,32,222,33,189,30,198,31,230,34,240,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.城市守护开启每10分钟收益\n2.每日可以重置4次试炼塔\n3.英雄背包额外增加60\n4.徽章背包额外增加60\n5.英雄商店每日可以刷新90次\n6.升星商店每日可以刷新90次\n7.每天可以购买29次体力可乐\n8.每天可以购买29次精力可乐\n9.每天可以购买24次金经验雕像\n10.每天可以购买95次金币\n11.每天可以购买29次橙色装备箱子\n12.每天可以购买21次橙色徽章箱子。\n13.公会副本，每日可购买30次挑战次数.\n14.银行取款，每日可取款19次。","unknown",0,},
    [10] = {10,9,100000,58,12,102,22,115,23,148,26,158,27,128,24,171,25,211,32,223,33,199,31,241,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.英雄背包额外增加70\n2.徽章背包额外增加70\n3.英雄商店每日可以刷新100次\n4.升星商店每日可以刷新100次\n5.每日可以购买出击令50个\n6.每天可以购买32次体力可乐\n7.每天可以购买32次精力可乐\n8.每天可以购买27次金经验雕像\n9.每天可以购买105次金币\n10.每天可以购买32次橙色装备箱子\n11.每天可以购买23次橙色徽章箱子.\n12.银行取款，每日可取款22次。","unknown",0,},
    [11] = {11,10,200000,66,12,103,22,116,23,149,26,159,27,129,24,172,25,212,32,224,33,200,31,231,34,242,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.英雄背包额外增加80\n2.徽章背包额外增加80\n3.英雄商店每日可以刷新150次\n4.升星商店每日可以刷新150次\n5.每天可以购买35次体力可乐\n6.每天可以购买35次精力可乐\n7.每天可以购买30次金经验雕像\n8.每天可以购买120次金币\n9.每天可以购买35次橙色装备箱子\n10.每天可以购买25次橙色徽章箱子\n11.银行取款，每日可取款25次。","unknown",0,},
    [12] = {12,11,500000,69,12,104,22,117,23,150,26,160,27,130,24,173,25,213,32,225,33,201,31,243,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.英雄背包额外增加90\n2.徽章背包额外增加90\n3.英雄商店每日可以刷新200次\n4.升星商店每日可以刷新200次\n5.每天可以购买38次体力可乐\n6.每天可以购买38次精力可乐\n7.每天可以购买33次金经验雕像\n8.每天可以购买130次金币\n9.每天可以购买38次橙色装备箱子\n10.每天可以购买27次橙色徽章箱子.\n11.银行取款，每日可取款28次。","unknown",0,},
    [13] = {13,12,1000000,71,12,105,22,118,23,151,26,161,27,131,24,174,25,214,32,226,33,202,31,244,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"1.英雄背包额外增加100\n2.徽章背包额外增加100\n3.英雄商店每日可以刷新300次\n4.升星商店每日可以刷新300次.\n5.每天可以购买40次体力可乐\n6.每天可以购买40次精力可乐\n7.每天可以购买35次金经验雕像\n8.每天可以购买150次金币\n9.每天可以购买40次橙色装备箱子\n10.每天可以购买30次橙色徽章箱子.\n11.银行取款，每日可取款30次。","unknown",0,},
    }
}

local __index_level = {
    [0] = 1,
    [1] = 2,
    [2] = 3,
    [3] = 4,
    [4] = 5,
    [5] = 6,
    [6] = 7,
    [7] = 8,
    [8] = 9,
    [9] = 10,
    [10] = 11,
    [11] = 12,
    [12] = 13,
}

local __key_map = {
    id = 1,
    level = 2,
    low_value = 3,
    function_id_1 = 4,
    function_type_1 = 5,
    function_id_2 = 6,
    function_type_2 = 7,
    function_id_3 = 8,
    function_type_3 = 9,
    function_id_4 = 10,
    function_type_4 = 11,
    function_id_5 = 12,
    function_type_5 = 13,
    function_id_6 = 14,
    function_type_6 = 15,
    function_id_7 = 16,
    function_type_7 = 17,
    function_id_8 = 18,
    function_type_8 = 19,
    function_id_9 = 20,
    function_type_9 = 21,
    function_id_10 = 22,
    function_type_10 = 23,
    function_id_11 = 24,
    function_type_11 = 25,
    function_id_12 = 26,
    function_type_12 = 27,
    function_id_13 = 28,
    function_type_13 = 29,
    function_id_14 = 30,
    function_type_14 = 31,
    function_id_15 = 32,
    function_type_15 = 33,
    function_id_16 = 34,
    function_type_16 = 35,
    function_id_17 = 36,
    function_type_17 = 37,
    function_id_18 = 38,
    function_type_18 = 39,
    function_id_19 = 40,
    function_type_19 = 41,
    function_id_20 = 42,
    function_type_20 = 43,
    function_id_21 = 44,
    function_type_21 = 45,
    function_id_22 = 46,
    function_type_22 = 47,
    function_id_23 = 48,
    function_type_23 = 49,
    function_id_24 = 50,
    function_type_24 = 51,
    function_id_25 = 52,
    function_type_25 = 53,
    vip_dungeon_1 = 54,
    vip_dungeon_2 = 55,
    vip_dungeon_3 = 56,
    vip_dungeon_4 = 57,
    vip_dungeon_5 = 58,
    vip_dungeon_6 = 59,
    vip_dungeon_7 = 60,
    vip_dungeon_8 = 61,
    vip_dungeon_9 = 62,
    vip_dungeon_10 = 63,
    function_direction = 64,
    up_direction = 65,
    new_open = 66,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_vip_level_info")
        return t._raw[__key_map[k]]
    end
}

function vip_level_info.getLength()
    return #vip_level_info._data
end

function vip_level_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function vip_level_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = vip_level_info._data[index]}, m)
end

function vip_level_info.get(level)
    local k = level
    return vip_level_info.indexOf(__index_level[k])
end

function vip_level_info.set(level, key, value)
    local record = vip_level_info.get(level)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function vip_level_info.get_index_data()
    return __index_level
end

