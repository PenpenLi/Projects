---@classdef record_vip_level_info
local record_vip_level_info = {}


record_vip_level_info.id = 0--等级id
record_vip_level_info.level = 0--VIP等级
record_vip_level_info.low_value = 0--最低成长值
record_vip_level_info.gift_id = 0--VIP专属礼包

local vip_level_info = {
   _data = {   
    [1] = {1,0,0,13001,},  
    [2] = {2,1,60,13002,},  
    [3] = {3,2,300,13003,},  
    [4] = {4,3,1000,13004,},  
    [5] = {5,4,2000,13005,},  
    [6] = {6,5,5000,13006,},  
    [7] = {7,6,8000,13007,},  
    [8] = {8,7,15000,13008,},  
    [9] = {9,8,25000,13009,},  
    [10] = {10,9,50000,13010,},  
    [11] = {11,10,100000,13011,},  
    [12] = {12,11,150000,13012,},  
    [13] = {13,12,250000,13013,},  
    [14] = {14,13,500000,13014,},  
    [15] = {15,14,1000000,13015,},  
    [16] = {16,15,1500000,13016,},  
    [17] = {17,16,2000000,13017,},
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
    [13] = 14,  
    [14] = 15,  
    [15] = 16,  
    [16] = 17,
}

local __key_map = { 
    id = 1,
    level = 2,
    low_value = 3,
    gift_id = 4,
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


---
--@return @class record_vip_level_info
function vip_level_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = vip_level_info._data[index]}, m)
end



---
--@return @class record_vip_level_info
function vip_level_info.get(level)
    
    return vip_level_info.indexOf(__index_level[ level ])
     
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

return  vip_level_info 