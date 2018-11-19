local record_dress_change_text = {}

record_dress_change_text.id = 0 --id
record_dress_change_text.name = "" --名称
record_dress_change_text.male_before = "" --男性换装前文字
record_dress_change_text.male_after = "" --男性换装后文字
record_dress_change_text.female_before = "" --女性换装前文字
record_dress_change_text.female_after = "" --女性换装后文字


dress_change_text = {
    _data = {
    [1] = {1,"主角","别走开哦，回来给你看小鲜肉。","原来的我才是最小清新的那一个。","还记得我原来的样子吗？","我喜欢新衣服……",},
    [2] = {101,"巴涅西凯时装","别走开哦，回来给你看小鲜肉。","这身帅不帅！","还记得我原来的样子吗？","我好看吗！",},
    [3] = {102,"黄金球时装","别走开哦，回来给你看小鲜肉。","尝尝我的飞弹吧！","还记得我原来的样子吗？","我不是在玩COSPLAY……",},
    [4] = {201,"原子武士时装","别走开哦，回来给你看小鲜肉。","徒弟们的修行还没到家，哈撒嘿……","还记得我原来的样子吗？","徒弟们的修行还没到家，哈撒嘿……",},
    [5] = {202,"居合钢时装","别走开哦，回来给你看小鲜肉。","我这身盔甲很贵的，哈撒嘿……","还记得我原来的样子吗？","我的刀很锋利，哈撒嘿……",},
    [6] = {301,"驱动骑士时装","别走开哦，回来给你看小鲜肉。","我是半机械人。","还记得我原来的样子吗？","我是半机械人。",},
    [7] = {302,"机神G4时装","别走开哦，回来给你看小鲜肉。","敢跟我比试比试么！？","还记得我原来的样子吗？","敢跟我比试比试么！？",},
    [8] = {401,"甜心假面时装","别走开哦，回来给你看小鲜肉。","我最大的缺点就是太帅了，唉…","还记得我原来的样子吗？","我最大的缺点就是太美了，唉…",},
    [9] = {402,"背心尊者时装","别走开哦，回来给你看小鲜肉。","其实，我真的不想动手。。。","还记得我原来的样子吗？","其实，我真的不想动手。。。",},
    [10] = {501,"狮子兽王时装","别走开哦，回来给你看小鲜肉。","好想吃肉啊，嗷~~","还记得我原来的样子吗？","好想吃肉啊，喵~~",},
    [11] = {502,"武装大猩猩时装","别走开哦，回来给你看小鲜肉。","在进化之家里我的实力名列前三！","还记得我原来的样子吗？","在进化之家里我的实力名列前三！",},
    [12] = {601,"时装11","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    [13] = {602,"时装12","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    [14] = {701,"时装13","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    [15] = {702,"时装14","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    [16] = {703,"时装15","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    [17] = {704,"时装16","别走开哦，回来给你看小鲜肉。","我喜欢新衣服","还记得我原来的样子吗？","我喜欢新衣服……",},
    }
}

local __index_id = {
    [1] = 1,
    [101] = 2,
    [102] = 3,
    [201] = 4,
    [202] = 5,
    [301] = 6,
    [302] = 7,
    [401] = 8,
    [402] = 9,
    [501] = 10,
    [502] = 11,
    [601] = 12,
    [602] = 13,
    [701] = 14,
    [702] = 15,
    [703] = 16,
    [704] = 17,
}

local __key_map = {
    id = 1,
    name = 2,
    male_before = 3,
    male_after = 4,
    female_before = 5,
    female_after = 6,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_dress_change_text")
        return t._raw[__key_map[k]]
    end
}

function dress_change_text.getLength()
    return #dress_change_text._data
end

function dress_change_text.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function dress_change_text.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = dress_change_text._data[index]}, m)
end

function dress_change_text.get(id)
    local k = id
    return dress_change_text.indexOf(__index_id[k])
end

function dress_change_text.set(id, key, value)
    local record = dress_change_text.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function dress_change_text.get_index_data()
    return __index_id
end

