---@classdef record_worldboss_rankaward_info
local record_worldboss_rankaward_info = {}


record_worldboss_rankaward_info.id = 0--序号
record_worldboss_rankaward_info.drop_id = 0--掉落id
record_worldboss_rankaward_info.rank_up = 0--伤害排名上限
record_worldboss_rankaward_info.rank_down = 0--伤害排名下限
record_worldboss_rankaward_info.mail_id = 0--邮件

local worldboss_rankaward_info = {
   _data = {   
    [1] = {1,46101,1,1,39,},  
    [2] = {2,46102,2,2,40,},  
    [3] = {3,46103,3,3,41,},  
    [4] = {4,46104,4,4,42,},  
    [5] = {5,46105,5,5,43,},  
    [6] = {6,46106,6,6,44,},  
    [7] = {7,46107,7,7,45,},  
    [8] = {8,46108,8,8,46,},  
    [9] = {9,46109,9,9,47,},  
    [10] = {10,46110,10,10,48,},  
    [11] = {11,46111,11,50,49,},  
    [12] = {12,46112,51,100,50,},  
    [13] = {13,46113,101,200,51,},  
    [14] = {14,46114,201,500,52,},  
    [15] = {15,46115,501,1000,53,},  
    [16] = {16,46116,1001,19999,54,},
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
}

local __key_map = { 
    id = 1,
    drop_id = 2,
    rank_up = 3,
    rank_down = 4,
    mail_id = 5,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_worldboss_rankaward_info")

        return t._raw[__key_map[k]]
    end
}


function worldboss_rankaward_info.getLength()
    return #worldboss_rankaward_info._data
end



function worldboss_rankaward_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_worldboss_rankaward_info
function worldboss_rankaward_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = worldboss_rankaward_info._data[index]}, m)
end



---
--@return @class record_worldboss_rankaward_info
function worldboss_rankaward_info.get(id)
    
    return worldboss_rankaward_info.indexOf(__index_id[ id ])
     
end



function worldboss_rankaward_info.set(id, key, value)
    local record = worldboss_rankaward_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function worldboss_rankaward_info.get_index_data()
    return __index_id 
end

return  worldboss_rankaward_info 