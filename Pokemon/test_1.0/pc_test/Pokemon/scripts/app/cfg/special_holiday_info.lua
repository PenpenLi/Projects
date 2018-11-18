local record_special_holiday_info = {}

record_special_holiday_info.id = 0 --任务id
record_special_holiday_info.tags = 0 --任务页签
record_special_holiday_info.directions = "" --任务描述
record_special_holiday_info.limit_time = 0 --任务时间
record_special_holiday_info.arrange = 0 --显示顺序
record_special_holiday_info.start_time = 0 --开始时间
record_special_holiday_info.end_time = 0 --结束时间
record_special_holiday_info.task_type = 0 --任务类型
record_special_holiday_info.task_value1 = 0 --任务类型值1
record_special_holiday_info.task_value2 = 0 --任务类型值2
record_special_holiday_info.task_value3 = 0 --任务类型值3
record_special_holiday_info.type_1 = 0 --奖励类型1
record_special_holiday_info.value_1 = 0 --奖励类型值1
record_special_holiday_info.size_1 = 0 --奖励数量1
record_special_holiday_info.type_2 = 0 --奖励类型2
record_special_holiday_info.value_2 = 0 --奖励类型值2
record_special_holiday_info.size_2 = 0 --奖励数量2
record_special_holiday_info.type_3 = 0 --奖励类型3
record_special_holiday_info.value_3 = 0 --奖励类型值3
record_special_holiday_info.size_3 = 0 --奖励数量3
record_special_holiday_info.type_4 = 0 --奖励类型4
record_special_holiday_info.value_4 = 0 --奖励类型值4
record_special_holiday_info.size_4 = 0 --奖励数量4


special_holiday_info = {
    _data = {
    [1] = {173,1,"单笔充值6元",1,72,1449763200,1449849600,1,6,6,6,3,13,8,3,304,1,0,0,0,0,0,0,},
    [2] = {174,1,"单笔充值30元",1,73,1449763200,1449849600,1,30,6,30,3,18,188,3,304,2,0,0,0,0,0,0,},
    [3] = {175,1,"单笔充值50元",1,74,1449763200,1449849600,1,50,6,50,3,13,68,3,304,3,0,0,0,0,0,0,},
    [4] = {176,1,"单笔充值128元",1,75,1449763200,1449849600,1,128,6,128,3,18,588,3,304,8,0,0,0,0,0,0,},
    [5] = {177,1,"单笔充值288元",1,76,1449763200,1449849600,1,288,6,288,3,13,288,3,304,18,0,0,0,0,0,0,},
    [6] = {178,1,"单笔充值548元",1,77,1449763200,1449849600,1,548,6,548,3,3,30,13,0,3000,3,304,28,0,0,0,},
    [7] = {179,1,"单笔充值648元",1,78,1449763200,1449849600,1,648,6,648,6,10032,75,3,304,36,0,0,0,0,0,0,},
    [8] = {190,2,"活动期间试炼塔重置X次（#num1#/X）",1,89,1449763200,1449849600,24,3,0,0,16,0,2888,3,303,10,0,0,0,0,0,0,},
    [9] = {191,2,"活动期间试炼塔重置X次（#num1#/X）",1,90,1449763200,1449849600,24,5,0,0,16,0,3888,3,303,20,0,0,0,0,0,0,},
    [10] = {192,2,"活动期间试炼塔重置X次（#num1#/X）",1,91,1449763200,1449849600,24,8,0,0,16,0,5888,3,303,30,0,0,0,0,0,0,},
    [11] = {193,2,"活动期间试炼塔重置X次（#num1#/X）",1,92,1449763200,1449849600,24,10,0,0,16,0,8888,3,303,30,0,0,0,0,0,0,},
    [12] = {194,2,"活动期间试炼塔重置X次（#num1#/X）",1,93,1449763200,1449849600,24,12,0,0,16,0,12888,3,303,30,0,0,0,0,0,0,},
    [13] = {195,3,"活动期间夺宝X次（#num1#/X）",1,94,1449763200,1449849600,25,75,0,0,3,18,58,3,303,5,0,0,0,0,0,0,},
    [14] = {196,3,"活动期间夺宝X次（#num1#/X）",1,95,1449763200,1449849600,25,150,0,0,3,18,98,3,303,10,0,0,0,0,0,0,},
    [15] = {197,3,"活动期间夺宝X次（#num1#/X）",1,96,1449763200,1449849600,25,225,0,0,3,18,158,3,303,10,0,0,0,0,0,0,},
    [16] = {198,3,"活动期间夺宝X次（#num1#/X）",1,97,1449763200,1449849600,25,300,0,0,3,4,10,3,303,15,0,0,0,0,0,0,},
    [17] = {199,3,"活动期间夺宝X次（#num1#/X）",1,98,1449763200,1449849600,25,375,0,0,3,18,188,3,303,15,0,0,0,0,0,0,},
    [18] = {200,3,"活动期间夺宝X次（#num1#/X）",1,99,1449763200,1449849600,25,450,0,0,3,4,20,3,303,20,0,0,0,0,0,0,},
    [19] = {201,3,"活动期间夺宝X次（#num1#/X）",1,100,1449763200,1449849600,25,525,0,0,3,18,288,3,303,25,0,0,0,0,0,0,},
    [20] = {202,3,"活动期间夺宝X次（#num1#/X）",1,101,1449763200,1449849600,25,600,0,0,3,18,388,3,303,30,0,0,0,0,0,0,},
    [21] = {203,3,"活动期间夺宝X次（#num1#/X）",1,102,1449763200,1449849600,25,675,0,0,3,18,488,3,303,35,0,0,0,0,0,0,},
    [22] = {204,3,"活动期间夺宝X次（#num1#/X）",1,103,1449763200,1449849600,25,750,0,0,3,18,588,3,303,40,0,0,0,0,0,0,},
    }
}

local __index_id = {
    [173] = 1,
    [174] = 2,
    [175] = 3,
    [176] = 4,
    [177] = 5,
    [178] = 6,
    [179] = 7,
    [190] = 8,
    [191] = 9,
    [192] = 10,
    [193] = 11,
    [194] = 12,
    [195] = 13,
    [196] = 14,
    [197] = 15,
    [198] = 16,
    [199] = 17,
    [200] = 18,
    [201] = 19,
    [202] = 20,
    [203] = 21,
    [204] = 22,
}

local __key_map = {
    id = 1,
    tags = 2,
    directions = 3,
    limit_time = 4,
    arrange = 5,
    start_time = 6,
    end_time = 7,
    task_type = 8,
    task_value1 = 9,
    task_value2 = 10,
    task_value3 = 11,
    type_1 = 12,
    value_1 = 13,
    size_1 = 14,
    type_2 = 15,
    value_2 = 16,
    size_2 = 17,
    type_3 = 18,
    value_3 = 19,
    size_3 = 20,
    type_4 = 21,
    value_4 = 22,
    size_4 = 23,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_special_holiday_info")
        return t._raw[__key_map[k]]
    end
}

function special_holiday_info.getLength()
    return #special_holiday_info._data
end

function special_holiday_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function special_holiday_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = special_holiday_info._data[index]}, m)
end

function special_holiday_info.get(id)
    local k = id
    return special_holiday_info.indexOf(__index_id[k])
end

function special_holiday_info.set(id, key, value)
    local record = special_holiday_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function special_holiday_info.get_index_data()
    return __index_id
end

