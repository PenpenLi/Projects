local record_time_dungeon_chapter_info = {}

record_time_dungeon_chapter_info.id = 0 --id
record_time_dungeon_chapter_info.name = "" --副本名称
record_time_dungeon_chapter_info.image = 0 --建筑形象
record_time_dungeon_chapter_info.directions = "" --副本描述
record_time_dungeon_chapter_info.item_type = 0 --奖励类型
record_time_dungeon_chapter_info.item_value = 0 --物品ID


time_dungeon_chapter_info = {
    _data = {
    [1] = {1,"副本一",1,"打败超级大怪兽，有丰厚的奖励噢。",1,0,},
    [2] = {2,"副本二",2,"打败超级大怪兽，有丰厚的奖励噢。",3,14,},
    [3] = {3,"副本三",3,"打败超级大怪兽，有丰厚的奖励噢。",3,18,},
    [4] = {4,"副本四",4,"打败超级大怪兽，有丰厚的奖励噢。",3,12,},
    [5] = {5,"副本五",1,"打败超级大怪兽，有丰厚的奖励噢。",3,45,},
    [6] = {6,"副本六",2,"打败超级大怪兽，有丰厚的奖励噢。",3,60,},
    [7] = {7,"副本七",3,"打败超级大怪兽，有丰厚的奖励噢。",23,0,},
    [8] = {8,"副本八",4,"打败超级大怪兽，有丰厚的奖励噢。",13,0,},
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
}

local __key_map = {
    id = 1,
    name = 2,
    image = 3,
    directions = 4,
    item_type = 5,
    item_value = 6,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_time_dungeon_chapter_info")
        return t._raw[__key_map[k]]
    end
}

function time_dungeon_chapter_info.getLength()
    return #time_dungeon_chapter_info._data
end

function time_dungeon_chapter_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function time_dungeon_chapter_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = time_dungeon_chapter_info._data[index]}, m)
end

function time_dungeon_chapter_info.get(id)
    local k = id
    return time_dungeon_chapter_info.indexOf(__index_id[k])
end

function time_dungeon_chapter_info.set(id, key, value)
    local record = time_dungeon_chapter_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function time_dungeon_chapter_info.get_index_data()
    return __index_id
end

