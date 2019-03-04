---@classdef record_tower_discount_info
local record_tower_discount_info = {}


record_tower_discount_info.id = 0--id
record_tower_discount_info.layer_min = 0--折扣道具出现小章节
record_tower_discount_info.layer_max = 0--折扣道具出现大章节
record_tower_discount_info.award_type = 0--奖励道具类型
record_tower_discount_info.award_value = 0--奖励道具类型值
record_tower_discount_info.award_size = 0--奖励道具数量
record_tower_discount_info.cost1 = 0--原价
record_tower_discount_info.discount = 0--奖励折扣
record_tower_discount_info.cost = 0--道具价格（购买实际元宝）

local tower_discount_info = {
   _data = {   
    [1] = {1,1,40,9,504,10,120,800,96,},  
    [2] = {2,1,40,9,401,300,240,700,168,},  
    [3] = {3,1,40,9,301,200,160,900,144,},  
    [4] = {4,1,40,9,503,20,120,850,102,},  
    [5] = {5,1,3,8,3011,1,200,600,120,},  
    [6] = {6,1,3,8,3012,1,200,600,120,},  
    [7] = {7,1,3,8,3013,1,200,600,120,},  
    [8] = {8,1,3,8,3014,1,200,600,120,},  
    [9] = {9,4,40,9,203,50,120,800,96,},  
    [10] = {10,4,40,9,401,400,320,800,256,},  
    [11] = {11,4,40,9,503,40,240,700,168,},  
    [12] = {12,4,40,9,503,60,360,900,324,},  
    [13] = {13,4,40,9,401,500,400,850,340,},  
    [14] = {14,4,40,9,301,400,320,900,288,},  
    [15] = {15,4,40,9,401,600,480,800,384,},  
    [16] = {16,4,40,9,401,700,560,800,448,},  
    [17] = {17,4,40,9,401,800,640,800,512,},  
    [18] = {18,4,40,9,401,900,720,800,576,},  
    [19] = {19,4,40,9,301,300,240,900,216,},  
    [20] = {20,4,40,9,301,400,320,900,288,},  
    [21] = {21,4,40,9,301,500,400,900,360,},  
    [22] = {22,4,40,9,301,600,480,900,432,},  
    [23] = {23,4,8,8,4021,1,1000,900,900,},  
    [24] = {24,4,8,8,4022,1,1000,900,900,},  
    [25] = {25,4,8,8,4023,1,1000,900,900,},  
    [26] = {26,4,8,8,4024,1,1000,900,900,},  
    [27] = {27,7,40,9,301,700,560,800,448,},  
    [28] = {28,7,40,9,401,1000,800,700,560,},  
    [29] = {29,7,40,9,503,70,420,900,378,},  
    [30] = {30,7,40,9,504,40,480,850,408,},  
    [31] = {31,7,40,9,503,80,480,900,432,},  
    [32] = {32,7,40,9,504,60,720,900,648,},  
    [33] = {33,7,40,9,401,1100,880,800,704,},  
    [34] = {34,7,40,9,401,1200,960,800,768,},
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
    [18] = 18,  
    [19] = 19,  
    [20] = 20,  
    [21] = 21,  
    [22] = 22,  
    [23] = 23,  
    [24] = 24,  
    [25] = 25,  
    [26] = 26,  
    [27] = 27,  
    [28] = 28,  
    [29] = 29,  
    [30] = 30,  
    [31] = 31,  
    [32] = 32,  
    [33] = 33,  
    [34] = 34,
}

local __key_map = { 
    id = 1,
    layer_min = 2,
    layer_max = 3,
    award_type = 4,
    award_value = 5,
    award_size = 6,
    cost1 = 7,
    discount = 8,
    cost = 9,
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
        
        assert(__key_map[k], "cannot find " .. k .. " in record_tower_discount_info")

        return t._raw[__key_map[k]]
    end
}


function tower_discount_info.getLength()
    return #tower_discount_info._data
end



function tower_discount_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_tower_discount_info
function tower_discount_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = tower_discount_info._data[index]}, m)
end



---
--@return @class record_tower_discount_info
function tower_discount_info.get(id)
    
    return tower_discount_info.indexOf(__index_id[ id ])
     
end



function tower_discount_info.set(id, key, value)
    local record = tower_discount_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function tower_discount_info.get_index_data()
    return __index_id 
end

return  tower_discount_info 