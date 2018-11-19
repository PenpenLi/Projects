local record_expansion_dungeon_chapter_info = {}

record_expansion_dungeon_chapter_info.id = 0 --编号
record_expansion_dungeon_chapter_info.name = "" --章节名称
record_expansion_dungeon_chapter_info.map_index = 0 --章节地图
record_expansion_dungeon_chapter_info.scene_id = 0 --对应特效
record_expansion_dungeon_chapter_info.talk = "" --气泡里的话
record_expansion_dungeon_chapter_info.pre_id = 0 --前置章节ID
record_expansion_dungeon_chapter_info.dungeon_id = 0 --所属副本ID
record_expansion_dungeon_chapter_info.type_1 = 0 --章节奖励类型1
record_expansion_dungeon_chapter_info.value_1 = 0 --章节奖励类型值1
record_expansion_dungeon_chapter_info.size_1 = 0 --章节奖励数量1
record_expansion_dungeon_chapter_info.type_2 = 0 --章节奖励类型2
record_expansion_dungeon_chapter_info.value_2 = 0 --章节奖励类型值2
record_expansion_dungeon_chapter_info.size_2 = 0 --章节奖励数量2
record_expansion_dungeon_chapter_info.type_3 = 0 --章节奖励类型3
record_expansion_dungeon_chapter_info.value_3 = 0 --章节奖励类型值3
record_expansion_dungeon_chapter_info.size_3 = 0 --章节奖励数量3


expansion_dungeon_chapter_info = {
    _data = {
    [1] = {1,"要塞A",6,3,"勇敢的英雄，恭喜通关本章~",0,2,2,0,500,0,0,0,0,0,0,},
    [2] = {2,"要塞B",10,10,"勇敢的英雄，恭喜通关本章~",1,2,2,0,500,0,0,0,0,0,0,},
    [3] = {3,"要塞C",6,11,"勇敢的英雄，恭喜通关本章~",2,2,2,0,500,0,0,0,0,0,0,},
    [4] = {4,"要塞D",10,12,"勇敢的英雄，恭喜通关本章~",3,2,2,0,500,0,0,0,0,0,0,},
    [5] = {5,"要塞E",6,3,"勇敢的英雄，恭喜通关本章~",4,2,2,0,500,0,0,0,0,0,0,},
    [6] = {6,"要塞F",10,10,"勇敢的英雄，恭喜通关本章~",5,2,2,0,500,0,0,0,0,0,0,},
    [7] = {7,"要塞G",6,11,"勇敢的英雄，恭喜通关本章~",6,2,2,0,500,0,0,0,0,0,0,},
    [8] = {8,"要塞H",10,12,"勇敢的英雄，恭喜通关本章~",7,2,2,0,500,0,0,0,0,0,0,},
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
    map_index = 3,
    scene_id = 4,
    talk = 5,
    pre_id = 6,
    dungeon_id = 7,
    type_1 = 8,
    value_1 = 9,
    size_1 = 10,
    type_2 = 11,
    value_2 = 12,
    size_2 = 13,
    type_3 = 14,
    value_3 = 15,
    size_3 = 16,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_expansion_dungeon_chapter_info")
        return t._raw[__key_map[k]]
    end
}

function expansion_dungeon_chapter_info.getLength()
    return #expansion_dungeon_chapter_info._data
end

function expansion_dungeon_chapter_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function expansion_dungeon_chapter_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = expansion_dungeon_chapter_info._data[index]}, m)
end

function expansion_dungeon_chapter_info.get(id)
    local k = id
    return expansion_dungeon_chapter_info.indexOf(__index_id[k])
end

function expansion_dungeon_chapter_info.set(id, key, value)
    local record = expansion_dungeon_chapter_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function expansion_dungeon_chapter_info.get_index_data()
    return __index_id
end

