---@classdef record_vip_gift_info
local record_vip_gift_info = {}


record_vip_gift_info.id = 0--序号
record_vip_gift_info.level = 0--vip等级
record_vip_gift_info.type_1 = 0--奖励类型1
record_vip_gift_info.value_1 = 0--奖励类型值1
record_vip_gift_info.size_1 = 0--奖励数量1
record_vip_gift_info.type_2 = 0--奖励类型2
record_vip_gift_info.value_2 = 0--奖励类型值2
record_vip_gift_info.size_2 = 0--奖励数量2
record_vip_gift_info.type_3 = 0--奖励类型3
record_vip_gift_info.value_3 = 0--奖励类型值3
record_vip_gift_info.size_3 = 0--奖励数量3
record_vip_gift_info.type_4 = 0--奖励类型4
record_vip_gift_info.value_4 = 0--奖励类型值4
record_vip_gift_info.size_4 = 0--奖励数量4

local vip_gift_info = {
   _data = {   
    [1] = {1,0,9,302,50,9,401,100,9,301,100,9,503,20,},  
    [2] = {2,1,9,302,100,9,401,200,9,301,200,9,503,30,},  
    [3] = {3,2,9,302,200,9,401,400,9,301,400,9,503,40,},  
    [4] = {4,3,9,302,300,9,401,600,9,301,600,9,503,50,},  
    [5] = {5,4,9,302,400,9,401,800,9,301,800,9,503,60,},  
    [6] = {6,5,9,302,500,9,401,1000,9,301,1000,9,503,70,},  
    [7] = {7,6,9,302,500,9,401,1000,9,301,1000,9,503,80,},  
    [8] = {8,7,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [9] = {9,8,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [10] = {10,9,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [11] = {11,10,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [12] = {12,11,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [13] = {13,12,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [14] = {14,13,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [15] = {15,14,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [16] = {16,15,9,302,500,9,401,1000,9,301,1000,9,503,100,},  
    [17] = {17,16,9,302,500,9,401,1000,9,301,1000,9,503,100,},
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
    [14] = 14,  
    [15] = 15,  
    [16] = 16,  
    [17] = 17,
}

local __key_map = { 
    id = 1,
    level = 2,
    type_1 = 3,
    value_1 = 4,
    size_1 = 5,
    type_2 = 6,
    value_2 = 7,
    size_2 = 8,
    type_3 = 9,
    value_3 = 10,
    size_3 = 11,
    type_4 = 12,
    value_4 = 13,
    size_4 = 14,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_vip_gift_info")

        return t._raw[__key_map[k]]
    end
}


function vip_gift_info.getLength()
    return #vip_gift_info._data
end



function vip_gift_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_vip_gift_info
function vip_gift_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = vip_gift_info._data[index]}, m)
end



---
--@return @class record_vip_gift_info
function vip_gift_info.get(id)
    
    return vip_gift_info.indexOf(__index_id[ id ])
     
end



function vip_gift_info.set(id, key, value)
    local record = vip_gift_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function vip_gift_info.get_index_data()
    return __index_id 
end

return  vip_gift_info 