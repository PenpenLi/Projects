---@classdef record_worldboss_timeclear_info
local record_worldboss_timeclear_info = {}


record_worldboss_timeclear_info.gold_base = 0--元宝基数
record_worldboss_timeclear_info.time_min = 0--最小次数
record_worldboss_timeclear_info.time_max = 0--最大次数

local worldboss_timeclear_info = {
   _data = {   
    [1] = {5,1,5,},  
    [2] = {10,6,10,},  
    [3] = {20,11,20,},  
    [4] = {40,21,30,},  
    [5] = {80,31,50,},  
    [6] = {100,51,9999,},
    }
}

local __index_gold_base = {   
    [5] = 1,  
    [10] = 2,  
    [20] = 3,  
    [40] = 4,  
    [80] = 5,  
    [100] = 6,
}

local __key_map = { 
    gold_base = 1,
    time_min = 2,
    time_max = 3,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_worldboss_timeclear_info")

        return t._raw[__key_map[k]]
    end
}


function worldboss_timeclear_info.getLength()
    return #worldboss_timeclear_info._data
end



function worldboss_timeclear_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_worldboss_timeclear_info
function worldboss_timeclear_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = worldboss_timeclear_info._data[index]}, m)
end



---
--@return @class record_worldboss_timeclear_info
function worldboss_timeclear_info.get(gold_base)
    
    return worldboss_timeclear_info.indexOf(__index_gold_base[ gold_base ])
     
end



function worldboss_timeclear_info.set(gold_base, key, value)
    local record = worldboss_timeclear_info.get(gold_base)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function worldboss_timeclear_info.get_index_data()
    return __index_gold_base 
end

return  worldboss_timeclear_info 