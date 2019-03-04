---@classdef record_week_fund_info
local record_week_fund_info = {}


record_week_fund_info.id = 0--id
record_week_fund_info.group = 0--组类型
record_week_fund_info.money =  ""--档位
record_week_fund_info.days = 0--天数
record_week_fund_info.reward_type1 = 0--奖励类型1
record_week_fund_info.reward_value1 = 0--奖励类型值1
record_week_fund_info.reward_size1 = 0--奖励数量1
record_week_fund_info.reward_type2 = 0--奖励类型2
record_week_fund_info.reward_value2 = 0--奖励类型值2
record_week_fund_info.reward_size2 = 0--奖励数量2
record_week_fund_info.reward_type3 = 0--奖励类型3
record_week_fund_info.reward_value3 = 0--奖励类型值3
record_week_fund_info.reward_size3 = 0--奖励数量3
record_week_fund_info.reward_type4 = 0--奖励类型4
record_week_fund_info.reward_value4 = 0--奖励类型值4
record_week_fund_info.reward_size4 = 0--奖励数量4

local week_fund_info = {
   _data = {   
    [1] = {101,1,"168",1,9,2001,50,9,301,1000,9,203,50,9,702,1,},  
    [2] = {102,1,"168",2,9,703,1,9,401,1000,9,301,1000,9,702,2,},  
    [3] = {103,1,"168",3,9,3629,1,9,504,50,9,401,1000,9,702,3,},  
    [4] = {104,1,"168",4,19,301,1,19,303,1,9,301,1000,9,504,50,},  
    [5] = {105,1,"168",5,9,3703,1,19,602,5,9,1101,100,1,0,100000,},  
    [6] = {106,1,"168",6,19,403,1,19,702,5,9,1102,100,1,0,100000,},  
    [7] = {107,1,"168",7,8,5031,1,9,504,100,9,401,1000,9,703,1,},  
    [8] = {201,2,"168",1,9,954,1,9,301,800,9,401,800,9,302,400,},  
    [9] = {202,2,"168",2,9,601,800,9,504,100,9,301,800,1,0,200000,},  
    [10] = {203,2,"168",3,9,3703,1,19,601,5,9,1101,100,1,0,200000,},  
    [11] = {204,2,"168",4,9,601,800,9,504,100,9,301,800,1,0,200000,},  
    [12] = {205,2,"168",5,19,403,1,19,701,5,9,1102,100,1,0,200000,},  
    [13] = {206,2,"168",6,9,601,800,9,504,100,9,301,800,1,0,200000,},  
    [14] = {207,2,"168",7,9,3609,1,0,0,0,0,0,0,0,0,0,},  
    [15] = {301,3,"168",1,9,3629,1,9,301,1000,9,401,1000,9,302,500,},  
    [16] = {302,3,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [17] = {303,3,"168",3,9,3703,1,19,601,5,9,1101,100,1,0,200000,},  
    [18] = {304,3,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [19] = {305,3,"168",5,19,403,1,19,701,5,9,1102,100,1,0,200000,},  
    [20] = {306,3,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [21] = {307,3,"168",7,9,711,60,25,0,4000,0,0,0,0,0,0,},  
    [22] = {401,4,"168",1,9,3629,1,9,301,1000,9,401,1000,9,302,500,},  
    [23] = {402,4,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [24] = {403,4,"168",3,9,706,15,19,601,5,9,1101,200,1,0,200000,},  
    [25] = {404,4,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [26] = {405,4,"168",5,9,707,15,19,701,5,9,1102,200,1,0,200000,},  
    [27] = {406,4,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [28] = {407,4,"168",7,9,711,60,25,0,4000,0,0,0,0,0,0,},  
    [29] = {501,5,"168",1,9,953,1,9,301,1000,9,401,1000,9,302,500,},  
    [30] = {502,5,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [31] = {503,5,"168",3,9,3703,1,19,601,5,9,1101,100,1,0,200000,},  
    [32] = {504,5,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [33] = {505,5,"168",5,19,403,1,19,701,5,9,1102,100,1,0,200000,},  
    [34] = {506,5,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [35] = {507,5,"168",7,9,711,60,25,0,4000,0,0,0,0,0,0,},  
    [36] = {601,6,"168",1,9,953,1,9,301,1000,9,401,1000,9,302,500,},  
    [37] = {602,6,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [38] = {603,6,"168",3,9,706,15,19,601,5,9,1101,200,1,0,200000,},  
    [39] = {604,6,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [40] = {605,6,"168",5,9,707,15,19,701,5,9,1102,200,1,0,200000,},  
    [41] = {606,6,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [42] = {607,6,"168",7,9,711,60,25,0,4000,0,0,0,0,0,0,},  
    [43] = {701,7,"168",1,9,953,1,9,301,1000,9,401,1000,9,302,500,},  
    [44] = {702,7,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [45] = {703,7,"168",3,9,3703,1,19,601,5,9,1101,100,1,0,200000,},  
    [46] = {704,7,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [47] = {705,7,"168",5,19,403,1,19,701,5,9,1102,100,1,0,200000,},  
    [48] = {706,7,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [49] = {707,7,"168",7,9,711,60,25,0,4000,0,0,0,0,0,0,},  
    [50] = {901,99,"168",1,9,3629,1,9,301,1000,9,401,1000,9,302,500,},  
    [51] = {902,99,"168",2,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [52] = {903,99,"168",3,9,706,15,19,602,5,9,1101,200,1,0,200000,},  
    [53] = {904,99,"168",4,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [54] = {905,99,"168",5,9,707,15,19,702,5,9,1102,200,1,0,200000,},  
    [55] = {906,99,"168",6,9,601,1000,9,504,100,9,301,1000,1,0,200000,},  
    [56] = {907,99,"168",7,9,711,75,25,0,4800,0,0,0,0,0,0,},
    }
}

local __index_id = {   
    [101] = 1,  
    [102] = 2,  
    [103] = 3,  
    [104] = 4,  
    [105] = 5,  
    [106] = 6,  
    [107] = 7,  
    [201] = 8,  
    [202] = 9,  
    [203] = 10,  
    [204] = 11,  
    [205] = 12,  
    [206] = 13,  
    [207] = 14,  
    [301] = 15,  
    [302] = 16,  
    [303] = 17,  
    [304] = 18,  
    [305] = 19,  
    [306] = 20,  
    [307] = 21,  
    [401] = 22,  
    [402] = 23,  
    [403] = 24,  
    [404] = 25,  
    [405] = 26,  
    [406] = 27,  
    [407] = 28,  
    [501] = 29,  
    [502] = 30,  
    [503] = 31,  
    [504] = 32,  
    [505] = 33,  
    [506] = 34,  
    [507] = 35,  
    [601] = 36,  
    [602] = 37,  
    [603] = 38,  
    [604] = 39,  
    [605] = 40,  
    [606] = 41,  
    [607] = 42,  
    [701] = 43,  
    [702] = 44,  
    [703] = 45,  
    [704] = 46,  
    [705] = 47,  
    [706] = 48,  
    [707] = 49,  
    [901] = 50,  
    [902] = 51,  
    [903] = 52,  
    [904] = 53,  
    [905] = 54,  
    [906] = 55,  
    [907] = 56,
}

local __key_map = { 
    id = 1,
    group = 2,
    money = 3,
    days = 4,
    reward_type1 = 5,
    reward_value1 = 6,
    reward_size1 = 7,
    reward_type2 = 8,
    reward_value2 = 9,
    reward_size2 = 10,
    reward_type3 = 11,
    reward_value3 = 12,
    reward_size3 = 13,
    reward_type4 = 14,
    reward_value4 = 15,
    reward_size4 = 16,
}

local m = { 
    __index = function(t, k) 
        if k == "toObject" then
            return function()  
                local o = {}
                for key, v in pairs (__key_map) do 
                    o[key] = t._raw[v]
                end
                return o
            end 
        end
        
        assert(__key_map[k], "cannot find " .. k .. " in record_week_fund_info")

        return t._raw[__key_map[k]]
    end
}


function week_fund_info.getLength()
    return #week_fund_info._data
end



function week_fund_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_week_fund_info
function week_fund_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = week_fund_info._data[index]}, m)
end



---
--@return @class record_week_fund_info
function week_fund_info.get(id)
    
    return week_fund_info.indexOf(__index_id[ id ])
     
end



function week_fund_info.set(id, key, value)
    local record = week_fund_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function week_fund_info.get_index_data()
    return __index_id 
end

return  week_fund_info 