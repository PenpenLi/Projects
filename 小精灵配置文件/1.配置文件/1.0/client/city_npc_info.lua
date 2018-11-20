local record_city_npc_info = {}

record_city_npc_info.id = 0 --NPC编号
record_city_npc_info.name = "" --NPC名称
record_city_npc_info.res_id = 0 --引用资源ID
record_city_npc_info.disable_city_id = "" --不出现城池
record_city_npc_info.text_1 = "" --NPC对话1
record_city_npc_info.face_1 = 0 --NPC表情1
record_city_npc_info.text_2 = "" --NPC对话2
record_city_npc_info.face_2 = 0 --NPC表情2
record_city_npc_info.text_3 = "" --NPC对话3
record_city_npc_info.face_3 = 0 --NPC表情3


city_npc_info = {
    _data = {
    [1] = {1,"蝉幼虫",11026,"0","地底下好暗啊……",49,"好不容易爬出来了，别打我……",25,"我再在地底待一万年就会更厉害！",48,},
    [2] = {2,"小猪银行",12022,"0","把零钱给我……",48,"别看我这样，我可是很纯洁的……",45,"给我钱，给我钱……",53,},
    [3] = {3,"冲浪女",11043,"0","看什么看？没见过美女吗？",44,"我喜欢冲浪……",5,"我的身材好吗？",8,},
    [4] = {4,"比基尼美女",11043,"0","还能愉快的玩耍吗？",52,"我喜欢比基尼……",3,"哎！为什么输的老是我~",52,},
    [5] = {5,"土龙",12045,"0","钻在土里最安全。",49,"愿赌就要服输~",19,"饶命啊……",29,},
    [6] = {6,"原始人王八",12041,"0","吼吼吼……",27,"你们真弱。",27,"我要吃肉！",27,},
    [7] = {7,"克隆博士",12027,"0","我死了无所谓，反正有替代品。",31,"真想拿你的身体做研究。",45,"你想做我的试验品吗？",5,},
    [8] = {8,"黄金球",12017,"0","看我射死你！",30,"我弹无虚发。",9,"尝尝我这个！",17,},
    [9] = {9,"茶岚子",11031,"0","不许对师父无理！",8,"我可是大弟子！",5,"跟我一决高下！",9,},
    [10] = {10,"百年蝉幼虫",11026,"1,5","地底下好暗啊……",10,"好不容易爬出来了，别打我……",5,"我再在地底待一万年就会更厉害！",19,},
    [11] = {11,"克隆体",12027,"1,5","你想做我的试验品吗？",52,"我死了无所谓，反正有替代品。",3,"真想拿你的身体做研究。",39,},
    [12] = {12,"银行猪怪",12022,"0","别看我这样，我可是很纯洁的……",19,"给我钱，给我钱……",22,"把零钱给我……",28,},
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
}

local __key_map = {
    id = 1,
    name = 2,
    res_id = 3,
    disable_city_id = 4,
    text_1 = 5,
    face_1 = 6,
    text_2 = 7,
    face_2 = 8,
    text_3 = 9,
    face_3 = 10,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_city_npc_info")
        return t._raw[__key_map[k]]
    end
}

function city_npc_info.getLength()
    return #city_npc_info._data
end

function city_npc_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function city_npc_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = city_npc_info._data[index]}, m)
end

function city_npc_info.get(id)
    local k = id
    return city_npc_info.indexOf(__index_id[k])
end

function city_npc_info.set(id, key, value)
    local record = city_npc_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function city_npc_info.get_index_data()
    return __index_id
end

