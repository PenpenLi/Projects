local record_rebel_boss_buff_info = {}

record_rebel_boss_buff_info.id = 0 --id
record_rebel_boss_buff_info.name = "" --名称
record_rebel_boss_buff_info.buff = "" --分组属性
record_rebel_boss_buff_info.tips = "" --描述
record_rebel_boss_buff_info.icon1 = "" --选中的icon(98*98)
record_rebel_boss_buff_info.icon2 = "" --未选中的icon(70*70)
record_rebel_boss_buff_info.skill_id = 0 --技能id


rebel_boss_buff_info = {
    _data = {
    [1] = {1,"超能","超能英雄伤害+300%","所有上阵的超能英雄伤害加成+300%","ui/text/txt/zhenying_wei_xuanzhong.png","ui/text/txt/zhenying_wei.png",4301,},
    [2] = {2,"格斗","格斗英雄伤害+300%","所有上阵的格斗英雄伤害加成+300%","ui/text/txt/zhenying_shu_xuanzhong.png","ui/text/txt/zhenying_shu.png",4302,},
    [3] = {3,"外星","外星英雄伤害+300%","所有上阵的外星英雄伤害加成+300%","ui/text/txt/zhenying_wu_xuanzhong.png","ui/text/txt/zhenying_wu.png",4303,},
    [4] = {4,"怪人","怪人英雄伤害+300%","所有上阵的怪人英雄伤害加成+300%","ui/text/txt/zhenying_qun_xuanzhong.png","ui/text/txt/zhenying_qun.png",4304,},
    }
}

local __index_id = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
}

local __key_map = {
    id = 1,
    name = 2,
    buff = 3,
    tips = 4,
    icon1 = 5,
    icon2 = 6,
    skill_id = 7,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_rebel_boss_buff_info")
        return t._raw[__key_map[k]]
    end
}

function rebel_boss_buff_info.getLength()
    return #rebel_boss_buff_info._data
end

function rebel_boss_buff_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function rebel_boss_buff_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = rebel_boss_buff_info._data[index]}, m)
end

function rebel_boss_buff_info.get(id)
    local k = id
    return rebel_boss_buff_info.indexOf(__index_id[k])
end

function rebel_boss_buff_info.set(id, key, value)
    local record = rebel_boss_buff_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function rebel_boss_buff_info.get_index_data()
    return __index_id
end

