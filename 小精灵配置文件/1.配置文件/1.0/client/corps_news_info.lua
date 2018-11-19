local record_corps_news_info = {}

record_corps_news_info.id = 0 --id
record_corps_news_info.news = "" --描述


corps_news_info = {
    _data = {
    [1] = {1,"<prefix><text value='成员' color='16709336'/><text value='#role_name#' color='11661157'/><text value='进行[#name#]仪式，为公会增加了' color='16709336'/><text value='#worship_integral#' color='15890701'/><text value='点经验' color='16709336'/></prefix>",},
    [2] = {2,"<prefix><text value='成员' color='16709336'/><text value='#role_name#' color='11661157'/><text value='退出了公会。' color='16709336'/></prefix>",},
    [3] = {3,"<prefix><text value='成员' color='16709336'/><text value='#role_name#' color='11661157'/><text value='被移出了公会。' color='16709336'/></prefix>",},
    [4] = {4,"<prefix><text value='恭喜玩家' color='16709336'/><text value='#role_name#' color='11661157'/><text value='加入公会，让我们为公会的日益强大而欢呼吧！' color='16709336'/></prefix>",},
    [5] = {5,"<prefix><text value='伟大的公会长下达任命，封' color='16709336'/><text value='#role_name#' color='11661157'/><text value='为副公会长！' color='16709336'/></prefix>",},
    [6] = {6,"<prefix><text value='公会长长期不在线，公会不可一日无主，' color='16709336'/><text value='#role_name#' color='11661157'/><text value='发起弹劾，将成为新任公会长。' color='16709336'/></prefix>",},
    [7] = {7,"<prefix><text value='成员' color='16709336'/><text value='#role_name#' color='11661157'/><text value='霸气侧漏，公会长经过斟酌，将公会长职位转交给' color='16709336'/><text value='#role_name#' color='15890701'/><text value='。' color='16709336'/></prefix>",},
    [8] = {8,"<prefix><text value='成员' color='16709336'/><text value='#role_name#' color='11661157'/><text value='在[#name#]仪式中，因心怀至诚触发暴击，为公会增加' color='16709336'/><text value='#worship_integral#' color='15890701'/><text value='点经验' color='16709336'/></prefix>",},
    [9] = {9,"<prefix><text value='众团员齐心协力，击杀' color='16709336'/><text value='[#dungeon_name#]' color='11661157'/><text value='，为公会增加了' color='16709336'/><text value='#corps_exp#' color='15890701'/><text value='点经验' color='16709336'/></prefix>",},
    [10] = {10,"<prefix><text value='伟大的公会长下达任命，撤销了' color='16709336'/><text value='#role_name#' color='11661157'/><text value='副公会长的职务。' color='16709336'/></prefix>",},
    [11] = {11,"<prefix><text value='我方公会在[公会战]中表现卓越，共抢夺敌方公会' color='16709336'/><text value='#exp_number#' color='11661157'/><text value='点经验' color='16709336'/></prefix>",},
    [12] = {12,"<prefix><text value='我方公会在[公会战]中发挥失常，被敌方公会抢夺' color='16709336'/><text value='#exp_number#' color='11661157'/><text value='点经验' color='16709336'/></prefix>",},
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
    news = 2,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_corps_news_info")
        return t._raw[__key_map[k]]
    end
}

function corps_news_info.getLength()
    return #corps_news_info._data
end

function corps_news_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function corps_news_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = corps_news_info._data[index]}, m)
end

function corps_news_info.get(id)
    local k = id
    return corps_news_info.indexOf(__index_id[k])
end

function corps_news_info.set(id, key, value)
    local record = corps_news_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function corps_news_info.get_index_data()
    return __index_id
end

