local record_arena_chat_info = {}

record_arena_chat_info.id = 0 --ID
record_arena_chat_info.chat = "" --气泡文字
record_arena_chat_info.type = 0 --文字类型值


arena_chat_info = {
    _data = {
    [1] = {1,"我可是S级英雄，你敢挑战我一下试试？",1,},
    [2] = {2,"以你现在的实力，是永远无法战胜我的。",1,},
    [3] = {3,"我独自一人就平息了神级灾害！",1,},
    [4] = {4,"我可不会手下留情……",1,},
    [5] = {5,"你再看？再看！再看，信不信我就把你喝掉。",1,},
    [6] = {6,"请称呼我为史上最强的英雄！",1,},
    [7] = {7,"听说性感囚犯对你很有兴趣哦！",1,},
    [8] = {8,"唉呀~~高处不胜寒~冷的我牙都掉了~~",1,},
    [9] = {9,"我是低调高富帅，低调又深沉。~",1,},
    [10] = {10,"这是靠脸的世界，而我已经站在了顶端~",1,},
    [11] = {11,"想动我？你懂不懂规矩？",1,},
    [12] = {12,"这个世界有一种专门消灭新人的英雄……",1,},
    [13] = {13,"装备算什么，我裸奔都能灭了你！",1,},
    [14] = {14,"每天都拿全服前几，都没什么人能赢我~",1,},
    [15] = {15,"努力成为像我这样了不起的英雄吧！",1,},
    [16] = {16,"要打快打，我要回家吃饭了……",1,},
    [17] = {17,"英雄协会发的薪水太少了……",1,},
    [18] = {18,"我会成为最了不起的英雄！",1,},
    [19] = {19,"听说吹雪组的老大很漂亮哦。",1,},
    [20] = {20,"好不容易打上来了，你又要把我弄下去吗？",1,},
    [21] = {21,"对付你我只要一拳！",1,},
    [22] = {22,"快点快点啊，打完去吃乌冬面吧。",1,},
    [23] = {23,"我早就准备好了，快来吧！",1,},
    [24] = {24,"有本事你来挑战我啊！~",1,},
    [25] = {25,"无敌的寂寞，实在太无聊了！",1,},
    [26] = {26,"我要打十个！",1,},
    [27] = {27,"曾经有人想挑战我，结果他再也没爬起来~",1,},
    [28] = {28,"我比金属球棒还要热血！",1,},
    [29] = {29,"来啊！战个痛快！",1,},
    [30] = {30,"等我再练练，赢你妥妥的。",2,},
    [31] = {31,"你以为你赢了几场就强了？",2,},
    [32] = {32,"大哥！求罩，别打我……",2,},
    [33] = {33,"我变强了，可是也秃了……",2,},
    [34] = {34,"这位英雄，借个位可以不！",2,},
    [35] = {35,"你怎么练的？这么强……",2,},
    [36] = {36,"求教变强大的秘诀……",2,},
    [37] = {37,"这位英雄，你比我早练这么久，能赢也正常，别打我啊",2,},
    [38] = {38,"我每天都做100个俯卧撑，跑10公里！",2,},
    [39] = {39,"就你也想排我前面？！",2,},
    [40] = {40,"嘿嘿，柿子就要捡软的捏！",2,},
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
    [35] = 35,
    [36] = 36,
    [37] = 37,
    [38] = 38,
    [39] = 39,
    [40] = 40,
}

local __key_map = {
    id = 1,
    chat = 2,
    type = 3,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_arena_chat_info")
        return t._raw[__key_map[k]]
    end
}

function arena_chat_info.getLength()
    return #arena_chat_info._data
end

function arena_chat_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function arena_chat_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = arena_chat_info._data[index]}, m)
end

function arena_chat_info.get(id)
    local k = id
    return arena_chat_info.indexOf(__index_id[k])
end

function arena_chat_info.set(id, key, value)
    local record = arena_chat_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function arena_chat_info.get_index_data()
    return __index_id
end

