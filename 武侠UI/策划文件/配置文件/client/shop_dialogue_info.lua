local record_shop_dialogue_info = {}

record_shop_dialogue_info.id = 0 --对话id
record_shop_dialogue_info.type = 0 --对话类型
record_shop_dialogue_info.trigger = 0 --对话触发条件
record_shop_dialogue_info.content = "" --对话内容


shop_dialogue_info = {
    _data = {
    [1] = {1,1,1,"英雄，你真有眼光！",},
    [2] = {2,1,1,"这可是我们这里的畅销产品哦~",},
    [3] = {3,1,1,"小本经营，常常来关照哦~",},
    [4] = {4,1,1,"如果在别处绝对买不到这个呢~",},
    [5] = {5,1,2,"英雄好久没来了，可想你了……",},
    [6] = {6,1,2,"讨厌，不要啦……",},
    [7] = {7,1,2,"新款产品马上就到了，别忘了来看看哦",},
    [8] = {8,1,2,"英雄，待这么久，是想等我下班吗……",},
    [9] = {9,4,1,"英雄，你真有眼光！",},
    [10] = {10,4,1,"这可是我们这里的畅销产品哦~",},
    [11] = {11,4,1,"小本经营，常常来关照哦~",},
    [12] = {12,4,1,"如果在别处绝对买不到这个呢~",},
    [13] = {13,4,2,"英雄好久没来了，最近在忙些什么……",},
    [14] = {14,4,2,"讨厌，不要啦……",},
    [15] = {15,4,2,"新款产品马上就到了，别忘了来看看哦",},
    [16] = {16,4,2,"英雄，待这么久，是想等我下班吗……",},
    [17] = {17,5,1,"开箱技术哪家强？",},
    [18] = {18,5,1,"箱中自有黄金屋，箱中自有颜如玉……",},
    [19] = {19,5,1,"我的宝箱，时尚时尚最时尚~",},
    [20] = {20,5,1,"上厕所不洗手果然，提高人品……",},
    [21] = {21,5,2,"你想要金箱子，银箱子，还是木头箱子呢？",},
    [22] = {22,5,2,"砸箱子就好，不要砸人家啦！",},
    [23] = {23,5,2,"摸摸人家，可提升人品哦！",},
    [24] = {24,5,2,"别乱点了，我不是那么随便的人！",},
    [25] = {25,6,1,"您眼光不错，挺会挑选的呀！",},
    [26] = {26,6,1,"小本经营，概不赊欠……",},
    [27] = {27,6,1,"这可是最近很畅销的商品哟！",},
    [28] = {28,6,1,"这可是新研制出来的宝贝哟！",},
    [29] = {29,6,2,"今天忘记进货，应该是没吃药引起的！",},
    [30] = {30,6,2,"无论你点我多少次，我都不会打折的……",},
    [31] = {31,6,2,"新款产品马上就到了，别忘了来看看哦",},
    [32] = {32,6,2,"英雄，待这么久，是想等我下班吗……",},
    [33] = {33,8,1,"想成为决斗之王，买我的东西准没错。",},
    [34] = {34,8,1,"好眼力啊英雄，有了它您一定能百战百胜。",},
    [35] = {35,8,1,"英雄慢走，祝决斗大胜哟。",},
    [36] = {36,8,1,"比武大会要开始啦，英雄赶快去比武吧！",},
    [37] = {37,8,2,"店虽小，但商品齐全，请慢慢挑选。",},
    [38] = {38,8,2,"在这个世界混，没称号出门都没人认识！",},
    [39] = {39,8,2,"红色英雄红色装备，本店独家贩售啦。",},
    [40] = {40,8,2,"老点我又不买东西，再这样我赶你出去哟。",},
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
    type = 2,
    trigger = 3,
    content = 4,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_shop_dialogue_info")
        return t._raw[__key_map[k]]
    end
}

function shop_dialogue_info.getLength()
    return #shop_dialogue_info._data
end

function shop_dialogue_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function shop_dialogue_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = shop_dialogue_info._data[index]}, m)
end

function shop_dialogue_info.get(id)
    local k = id
    return shop_dialogue_info.indexOf(__index_id[k])
end

function shop_dialogue_info.set(id, key, value)
    local record = shop_dialogue_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function shop_dialogue_info.get_index_data()
    return __index_id
end

