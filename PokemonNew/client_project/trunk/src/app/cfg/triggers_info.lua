---@classdef record_triggers_info
local record_triggers_info = {}


record_triggers_info.id = 0--id
record_triggers_info.talent_text =  ""--天赋飘字
record_triggers_info.talent_type = 0--天赋类型
record_triggers_info.attr_type_1 = 0--影响属性1
record_triggers_info.attr_value_1 = 0--影响属性值1
record_triggers_info.attr_type_2 = 0--影响属性2
record_triggers_info.attr_value_2 = 0--影响属性值2

local triggers_info = {
   _data = {   
    [1] = {11802201,"0",2,15,50,0,0,},  
    [2] = {11802301,"0",2,15,60,0,0,},  
    [3] = {11802202,"0",4,0,0,0,0,},  
    [4] = {11802302,"0",4,0,0,0,0,},  
    [5] = {11501201,"0",4,0,0,0,0,},  
    [6] = {11501301,"0",4,0,0,0,0,},  
    [7] = {11502201,"0",8,0,0,0,0,},  
    [8] = {11502301,"0",8,0,0,0,0,},  
    [9] = {11301201,"0",4,0,0,0,0,},  
    [10] = {11301301,"0",4,0,0,0,0,},  
    [11] = {21801201,"0",10,15,100,0,0,},  
    [12] = {21801301,"0",10,15,110,0,0,},  
    [13] = {21801202,"0",10,23,100,0,0,},  
    [14] = {21801302,"0",10,23,110,0,0,},  
    [15] = {21802201,"0",4,0,0,0,0,},  
    [16] = {21802301,"0",4,0,0,0,0,},  
    [17] = {31801201,"0",2,16,50,0,0,},  
    [18] = {31801301,"0",2,16,60,0,0,},  
    [19] = {31801202,"0",10,7,100,0,0,},  
    [20] = {31801302,"0",10,7,105,0,0,},  
    [21] = {31802201,"0",17,0,0,0,0,},  
    [22] = {31802301,"0",17,0,0,0,0,},  
    [23] = {31501201,"",2,15,50,0,0,},  
    [24] = {31501301,"",2,15,50,0,0,},  
    [25] = {31504201,"",4,0,0,0,0,},  
    [26] = {31504301,"",4,0,0,0,0,},  
    [27] = {41081201,"0",4,0,0,0,0,},  
    [28] = {41081301,"0",4,0,0,0,0,},  
    [29] = {41802201,"0",8,0,0,0,0,},  
    [30] = {41802301,"0",8,0,0,0,0,},  
    [31] = {41501201,"0",5,0,0,0,0,},  
    [32] = {41501301,"0",5,0,0,0,0,},  
    [33] = {41503201,"0",4,0,0,0,0,},  
    [34] = {41503301,"0",4,0,0,0,0,},  
    [35] = {41504201,"0",18,0,0,0,0,},  
    [36] = {41504301,"0",18,0,0,0,0,},  
    [37] = {41506201,"0",4,0,0,0,0,},  
    [38] = {41506301,"0",4,0,0,0,0,},  
    [39] = {41301101,"0",2,15,40,0,0,},  
    [40] = {41302101,"",4,0,0,0,0,},  
    [41] = {41007201,"0",2,15,20,0,0,},  
    [42] = {41007301,"0",2,15,30,0,0,},  
    [43] = {0,"",0,0,0,0,0,},
    }
}

local __index_id = {   
    [11301201] = 9,  
    [11301301] = 10,  
    [11501201] = 5,  
    [11501301] = 6,  
    [11502201] = 7,  
    [11502301] = 8,  
    [11802201] = 1,  
    [11802202] = 3,  
    [11802301] = 2,  
    [11802302] = 4,  
    [21801201] = 11,  
    [21801202] = 13,  
    [21801301] = 12,  
    [21801302] = 14,  
    [21802201] = 15,  
    [21802301] = 16,  
    [31501201] = 23,  
    [31501301] = 24,  
    [31504201] = 25,  
    [31504301] = 26,  
    [31801201] = 17,  
    [31801202] = 19,  
    [31801301] = 18,  
    [31801302] = 20,  
    [31802201] = 21,  
    [31802301] = 22,  
    [41007201] = 41,  
    [41007301] = 42,  
    [41081201] = 27,  
    [41081301] = 28,  
    [41301101] = 39,  
    [41302101] = 40,  
    [41501201] = 31,  
    [41501301] = 32,  
    [41503201] = 33,  
    [41503301] = 34,  
    [41504201] = 35,  
    [41504301] = 36,  
    [41506201] = 37,  
    [41506301] = 38,  
    [41802201] = 29,  
    [41802301] = 30, 
}

local __key_map = { 
    id = 1,
    talent_text = 2,
    talent_type = 3,
    attr_type_1 = 4,
    attr_value_1 = 5,
    attr_type_2 = 6,
    attr_value_2 = 7,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_triggers_info")

        return t._raw[__key_map[k]]
    end
}


function triggers_info.getLength()
    return #triggers_info._data
end



function triggers_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_triggers_info
function triggers_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = triggers_info._data[index]}, m)
end



---
--@return @class record_triggers_info
function triggers_info.get(id)
    
    return triggers_info.indexOf(__index_id[ id ])
     
end



function triggers_info.set(id, key, value)
    local record = triggers_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function triggers_info.get_index_data()
    return __index_id 
end

return  triggers_info 