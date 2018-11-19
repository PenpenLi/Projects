local record_dress_info = {}

record_dress_info.id = 0 --id
record_dress_info.name = "" --名称
record_dress_info.man_res_id = 0 --男性资源id
record_dress_info.woman_res_id = 0 --女性资源id
record_dress_info.play_group_id = 0 --播放组
record_dress_info.release_knight_id = 0 --关联英雄
record_dress_info.quality = 0 --品质
record_dress_info.potentiality = 0 --潜力
record_dress_info.basic_type_1 = 0 --基本属性类型1
record_dress_info.basic_value_1 = 0 --基本属性类型值1
record_dress_info.basic_type_2 = 0 --基本属性类型2
record_dress_info.basic_value_2 = 0 --基本属性类型值2
record_dress_info.strength_type_1 = 0 --强化属性类型1
record_dress_info.strength_value_1 = 0 --强化属性类型值1
record_dress_info.strength_type_2 = 0 --强化属性类型2
record_dress_info.strength_value_2 = 0 --强化属性类型值2
record_dress_info.strength_type_3 = 0 --强化属性类型3
record_dress_info.strength_value_3 = 0 --强化属性类型值3
record_dress_info.strength_type_4 = 0 --强化属性类型4
record_dress_info.strength_value_4 = 0 --强化属性类型值4
record_dress_info.cost_money = 0 --强化消耗银币元
record_dress_info.cost_item = 0 --强化消耗道具元
record_dress_info.common_skill_id = 0 --自带普攻id
record_dress_info.skill_res_id_1 = "" --普攻图标资源id
record_dress_info.common_clear_level = 0 --普攻解锁等级
record_dress_info.active_skill_id_1 = 0 --自带主动id1
record_dress_info.skill_res_id_2 = "" --自带主动图标id
record_dress_info.active_clear_level_1 = 0 --主动1解锁等级
record_dress_info.active_skill_id_2 = 0 --自带主动id2
record_dress_info.skill_res_id_3 = 0 --自带主动2图标id
record_dress_info.active_clear_level_2 = 0 --主动2解锁等级
record_dress_info.unite_skill_id = 0 --自带合击id
record_dress_info.skill_res_id_4 = 0 --自带合击图标id
record_dress_info.unite_clear_level = 0 --合击解锁等级
record_dress_info.active_skill_id_3 = 0 --自带主动id3
record_dress_info.skill_res_id_5 = 0 --自带主动3图标id
record_dress_info.active_clear_level_3 = 0 --主动3解锁等级
record_dress_info.super_unite_skill_id = 0 --超合击技能id
record_dress_info.sp_unite_des = "" --超合击图标技能描述
record_dress_info.super_unite_clear_level = 0 --超合击解锁等级
record_dress_info.compose_id = 0 --关联组合id
record_dress_info.passive_skill_1 = 0 --时装天赋1
record_dress_info.strength_level_1 = 0 --天赋1强化等级
record_dress_info.passive_skill_2 = 0 --时装天赋2
record_dress_info.strength_level_2 = 0 --天赋2强化等级
record_dress_info.passive_skill_3 = 0 --时装天赋3
record_dress_info.strength_level_3 = 0 --天赋3强化等级
record_dress_info.passive_skill_4 = 0 --时装天赋4
record_dress_info.strength_level_4 = 0 --天赋4强化等级
record_dress_info.passive_skill_5 = 0 --时装天赋5
record_dress_info.strength_level_5 = 0 --天赋5强化等级
record_dress_info.passive_skill_6 = 0 --时装天赋6
record_dress_info.strength_level_6 = 0 --天赋6强化等级
record_dress_info.passive_skill_7 = 0 --时装天赋7
record_dress_info.strength_level_7 = 0 --天赋7强化等级
record_dress_info.directions = "" --描述


dress_info = {
    _data = {
    [1] = {101,"巴涅西凯",10014,10044,10,10166,4,18,17,50,18,50,6,11,5,140,3,7,4,7,300,20,101771,"1011",0,101772,"1012",0,101772,0,160,101774,1014,160,101772,0,240,0,"0",240,1,6011,40,6012,80,6013,120,6014,160,6015,200,6016,240,6017,300,"主角时装，穿上后可以拥有巴涅西凯的技能，同时拥有巴涅西凯时装，黄金球时装，可以激活额外属性。",},
    [2] = {102,"黄金球",10015,10045,20,10177,4,18,17,20,18,20,6,11,5,140,3,7,4,7,300,20,101661,"1021",0,101662,"1022",0,101662,0,160,101664,1014,160,101662,0,240,0,"0",240,1,6021,40,6022,80,6023,120,6024,160,6025,200,6026,240,6027,300,"主角时装，穿上后可以拥有黄金球的技能，同时拥有黄金球时装，巴涅西凯时装，可以激活额外属性。",},
    [3] = {201,"原子武士",10016,10046,10,30078,5,20,6,500,13,100,6,14,5,180,3,9,4,9,540,30,300671,"2011",0,300672,"2012",0,300672,0,160,300674,2014,160,300672,0,240,0,"0",240,2,6031,40,6032,80,6033,120,6034,160,6035,200,6036,240,6037,300,"主角时装，穿上后可以拥有原子武士的技能，同时拥有居合钢时装，原子武士时装，可以激活额外属性。",},
    [4] = {202,"居合钢",10017,10047,20,30067,5,20,6,1000,13,200,6,14,5,180,3,9,4,9,540,30,300781,"2021",0,300782,"2022",0,300782,0,160,300784,2014,160,300782,0,240,0,"0",240,2,6041,40,6042,80,6043,120,6044,160,6045,200,6046,240,6047,300,"主角时装，穿上后可以拥有居合钢的技能，同时拥有居合钢时装，原子武士时装，可以激活额外属性。",},
    [5] = {301,"驱动骑士",10018,10048,10,40056,5,20,6,500,16,100,6,14,5,180,3,9,4,9,540,30,401881,"3011",0,401882,"3012",0,401882,0,160,401884,3014,160,401882,0,240,0,"0",240,3,6051,40,6052,80,6053,120,6054,160,6055,200,6056,240,6057,300,"主角时装，穿上后可以拥有驱动骑士的技能，同时拥有机神G4时装，驱动骑士时装，可以激活额外属性。",},
    [6] = {302,"机神G4",10019,10049,20,40188,5,20,6,1000,16,200,6,14,5,180,3,9,4,9,540,30,400561,"3021",0,400562,"3022",0,400562,0,160,400564,3014,160,400562,0,240,0,"0",240,3,6061,40,6062,80,6063,120,6064,160,6065,200,6066,240,6067,300,"主角时装，穿上后可以拥有机神G4的技能，同时拥有机神G4时装，驱动骑士时装，可以激活额外属性。",},
    [7] = {401,"甜心假面",10020,10050,10,20045,5,20,6,1000,15,200,6,14,5,180,3,9,4,9,540,30,200231,"4011",0,200232,"4012",0,200232,0,160,200234,4014,160,200232,0,240,0,"0",240,4,6071,40,6072,80,6073,120,6074,160,6075,200,6076,240,6077,300,"主角时装，穿上后可以拥有甜心假面的技能，同时拥有甜心假面时装，背心尊者时装，可以激活额外属性。",},
    [8] = {402,"背心尊者",10021,10051,20,20023,5,20,6,500,15,100,6,14,5,180,3,9,4,9,540,30,200451,"4021",0,200452,"4022",0,200452,0,160,200454,4014,160,200452,0,240,0,"0",240,4,6081,40,6082,80,6083,120,6084,160,6085,200,6086,240,6087,300,"主角时装，穿上后可以拥有背心尊者的技能，同时拥有甜心假面时装，背心尊者时装，可以激活额外属性。",},
    [9] = {501,"狮子兽王",10022,10052,10,10122,5,20,6,1000,16,200,6,14,5,180,3,9,4,9,540,30,100451,"5011",0,100452,"5012",0,100452,0,160,100454,5014,160,100452,0,240,0,"0",240,5,6091,40,6092,80,6093,120,6094,160,6095,200,6096,240,6097,300,"主角时装，穿上后可以拥有狮子兽王的技能，同时拥有狮子兽王时装，武装大猩猩时装，可以激活额外属性。",},
    [10] = {502,"武装大猩猩",10023,10053,20,10045,5,20,6,500,16,100,6,14,5,180,3,9,4,9,540,30,101221,"5021",0,101222,"5022",0,101222,0,160,101224,5014,160,101222,0,240,0,"0",240,5,6101,40,6102,80,6103,120,6104,160,6105,200,6106,240,6107,300,"主角时装，穿上后可以拥有武装大猩猩的技能，同时拥有狮子兽王时装，武装大猩猩时装，可以激活额外属性。",},
    }
}

local __index_id = {
    [101] = 1,
    [102] = 2,
    [201] = 3,
    [202] = 4,
    [301] = 5,
    [302] = 6,
    [401] = 7,
    [402] = 8,
    [501] = 9,
    [502] = 10,
}

local __key_map = {
    id = 1,
    name = 2,
    man_res_id = 3,
    woman_res_id = 4,
    play_group_id = 5,
    release_knight_id = 6,
    quality = 7,
    potentiality = 8,
    basic_type_1 = 9,
    basic_value_1 = 10,
    basic_type_2 = 11,
    basic_value_2 = 12,
    strength_type_1 = 13,
    strength_value_1 = 14,
    strength_type_2 = 15,
    strength_value_2 = 16,
    strength_type_3 = 17,
    strength_value_3 = 18,
    strength_type_4 = 19,
    strength_value_4 = 20,
    cost_money = 21,
    cost_item = 22,
    common_skill_id = 23,
    skill_res_id_1 = 24,
    common_clear_level = 25,
    active_skill_id_1 = 26,
    skill_res_id_2 = 27,
    active_clear_level_1 = 28,
    active_skill_id_2 = 29,
    skill_res_id_3 = 30,
    active_clear_level_2 = 31,
    unite_skill_id = 32,
    skill_res_id_4 = 33,
    unite_clear_level = 34,
    active_skill_id_3 = 35,
    skill_res_id_5 = 36,
    active_clear_level_3 = 37,
    super_unite_skill_id = 38,
    sp_unite_des = 39,
    super_unite_clear_level = 40,
    compose_id = 41,
    passive_skill_1 = 42,
    strength_level_1 = 43,
    passive_skill_2 = 44,
    strength_level_2 = 45,
    passive_skill_3 = 46,
    strength_level_3 = 47,
    passive_skill_4 = 48,
    strength_level_4 = 49,
    passive_skill_5 = 50,
    strength_level_5 = 51,
    passive_skill_6 = 52,
    strength_level_6 = 53,
    passive_skill_7 = 54,
    strength_level_7 = 55,
    directions = 56,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_dress_info")
        return t._raw[__key_map[k]]
    end
}

function dress_info.getLength()
    return #dress_info._data
end

function dress_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function dress_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = dress_info._data[index]}, m)
end

function dress_info.get(id)
    local k = id
    return dress_info.indexOf(__index_id[k])
end

function dress_info.set(id, key, value)
    local record = dress_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function dress_info.get_index_data()
    return __index_id
end

