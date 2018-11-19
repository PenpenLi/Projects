local record_share_info = {}

record_share_info.id = 0 --id
record_share_info.title = "" --标题
record_share_info.directions = "" --说明
record_share_info.share_content = "" --微博内容
record_share_info.pic = "" --图片
record_share_info.type = 0 --奖励类型
record_share_info.value = 0 --奖励类型值
record_share_info.size = 0 --奖励数量
record_share_info.condition_type = 0 --分享条件类型
record_share_info.condition_value = 0 --分享条件类型值
record_share_info.use_type = 0 --使用类型


share_info = {
    _data = {
    [1] = {1,"竞技场到达1000名","恭喜您竞技场到达1000名，分享给好友拿钻石啦！","维护世界和平看我的了，我在《一拳超人》等你哟！","1",2,0,200,1,1000,1,},
    [2] = {2,"竞技场到达第1名","恭喜您竞技场到达第一名，分享给好友拿钻石啦！","我太强了，不服？我在《一拳超人》，如若不服，等你来战！","2",2,0,300,1,1,1,},
    [3] = {3,"通关主线副本第八章","恭喜您主线副本到达第八章，分享给好友拿钻石啦！","平灾害，打怪人！我在《一拳超人》，你呢？","3",2,0,100,2,8,1,},
    [4] = {4,"到达30级","恭喜您到达30级，分享给好友拿钻石啦！","又是一拳解决战斗，我变的太强了！《一拳超人》，让你爱不释手。","4",2,0,100,3,30,1,},
    [5] = {5,"到达50级","恭喜您到达50级，分享给好友拿钻石啦！","这游戏升级太快了，蹭蹭的往上涨。详情关注《一拳超人》。","5",2,0,300,3,50,1,},
    [6] = {6,"攻下A市","恭喜您攻下A市，分享给好友拿钻石啦！","我已占领整个城市，妈妈再也不用担心我买不起房了！快来《一拳超人》。","6",2,0,200,4,1,1,},
    [7] = {7,"首次获得橙色英雄","恭喜您获得了橙色英雄，分享给好友拿钻石啦！","RP好没办法，和吹雪亲亲我我，和杰诺斯切磋交流，一切尽在《一拳超人》。","7",2,0,100,5,0,1,},
    [8] = {8,"0","0","0","0",3,1,1,3,1,2,},
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
    title = 2,
    directions = 3,
    share_content = 4,
    pic = 5,
    type = 6,
    value = 7,
    size = 8,
    condition_type = 9,
    condition_value = 10,
    use_type = 11,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_share_info")
        return t._raw[__key_map[k]]
    end
}

function share_info.getLength()
    return #share_info._data
end

function share_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function share_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = share_info._data[index]}, m)
end

function share_info.get(id)
    local k = id
    return share_info.indexOf(__index_id[k])
end

function share_info.set(id, key, value)
    local record = share_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function share_info.get_index_data()
    return __index_id
end

