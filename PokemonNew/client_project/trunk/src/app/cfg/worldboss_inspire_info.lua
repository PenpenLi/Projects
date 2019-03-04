---@classdef record_worldboss_inspire_info
local record_worldboss_inspire_info = {}


record_worldboss_inspire_info.inspire_number = 0--鼓舞次数
record_worldboss_inspire_info.attack_precent = 0--攻击力加成
record_worldboss_inspire_info.gold_number = 0--需要元宝

local worldboss_inspire_info = {
   _data = {   
    [1] = {0,0,10,},  
    [2] = {1,50,20,},  
    [3] = {2,100,30,},  
    [4] = {3,150,40,},  
    [5] = {4,200,50,},  
    [6] = {5,250,60,},  
    [7] = {6,300,70,},  
    [8] = {7,350,80,},  
    [9] = {8,400,90,},  
    [10] = {9,450,100,},  
    [11] = {10,500,110,},  
    [12] = {11,550,120,},  
    [13] = {12,600,130,},  
    [14] = {13,650,140,},  
    [15] = {14,700,150,},  
    [16] = {15,750,160,},  
    [17] = {16,800,170,},  
    [18] = {17,850,180,},  
    [19] = {18,900,190,},  
    [20] = {19,950,200,},  
    [21] = {20,1000,0,},
    }
}

local __index_inspire_number = {   
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
    [13] = 14,  
    [14] = 15,  
    [15] = 16,  
    [16] = 17,  
    [17] = 18,  
    [18] = 19,  
    [19] = 20,  
    [20] = 21,
}

local __key_map = { 
    inspire_number = 1,
    attack_precent = 2,
    gold_number = 3,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_worldboss_inspire_info")

        return t._raw[__key_map[k]]
    end
}


function worldboss_inspire_info.getLength()
    return #worldboss_inspire_info._data
end



function worldboss_inspire_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_worldboss_inspire_info
function worldboss_inspire_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = worldboss_inspire_info._data[index]}, m)
end



---
--@return @class record_worldboss_inspire_info
function worldboss_inspire_info.get(inspire_number)
    
    return worldboss_inspire_info.indexOf(__index_inspire_number[ inspire_number ])
     
end



function worldboss_inspire_info.set(inspire_number, key, value)
    local record = worldboss_inspire_info.get(inspire_number)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function worldboss_inspire_info.get_index_data()
    return __index_inspire_number 
end

return  worldboss_inspire_info 