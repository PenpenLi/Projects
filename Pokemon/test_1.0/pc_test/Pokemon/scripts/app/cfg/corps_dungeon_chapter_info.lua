local record_corps_dungeon_chapter_info = {}

record_corps_dungeon_chapter_info.id = 0 --章节id
record_corps_dungeon_chapter_info.name = "" --章节名称
record_corps_dungeon_chapter_info.award_name = "" --宝藏名称
record_corps_dungeon_chapter_info.base_id = 0 --章节形象
record_corps_dungeon_chapter_info.open_id = 0 --前置章节
record_corps_dungeon_chapter_info.open_level = 0 --开启等级
record_corps_dungeon_chapter_info.dungeon_1 = 0 --关卡1
record_corps_dungeon_chapter_info.dungeon_2 = 0 --关卡2
record_corps_dungeon_chapter_info.dungeon_3 = 0 --关卡3
record_corps_dungeon_chapter_info.dungeon_4 = 0 --关卡4
record_corps_dungeon_chapter_info.award_type1 = 0 --通关奖励类型1
record_corps_dungeon_chapter_info.award_value1 = 0 --通关奖励ID1
record_corps_dungeon_chapter_info.award_size1 = 0 --通关奖励数量1
record_corps_dungeon_chapter_info.award_type2 = 0 --通关奖励类型2
record_corps_dungeon_chapter_info.award_value2 = 0 --通关奖励ID2
record_corps_dungeon_chapter_info.award_size2 = 0 --通关奖励数量2
record_corps_dungeon_chapter_info.award_type3 = 0 --通关奖励类型3
record_corps_dungeon_chapter_info.award_value3 = 0 --通关奖励ID3
record_corps_dungeon_chapter_info.award_size3 = 0 --通关奖励数量3


corps_dungeon_chapter_info = {
    _data = {
    [1] = {1,"A市","A市宝藏",1,0,2,1,2,3,4,20,0,2000,1,0,50000,3,14,100,},
    [2] = {2,"B市","B市宝藏",2,1,2,5,6,7,8,20,0,2500,1,0,100000,3,18,200,},
    [3] = {3,"C市","C市宝藏",3,2,3,9,10,11,12,20,0,3000,1,0,150000,3,6,400,},
    [4] = {4,"D市","D市宝藏",4,3,3,13,14,15,16,20,0,3500,1,0,200000,3,13,50,},
    [5] = {5,"E市","E市宝藏",5,4,3,17,18,19,20,20,0,4000,1,0,250000,3,60,200,},
    [6] = {6,"F市","F市宝藏",1,5,4,21,22,23,24,20,0,4500,1,0,300000,3,60,220,},
    [7] = {7,"G市","G市宝藏",2,6,4,25,26,27,28,20,0,5000,1,0,350000,3,60,240,},
    [8] = {8,"H市","H市宝藏",3,7,4,29,30,31,32,20,0,5500,1,0,400000,3,60,260,},
    [9] = {9,"I市","I市宝藏",4,8,4,33,34,35,36,20,0,6000,1,0,450000,3,60,280,},
    [10] = {10,"J市","J市宝藏",5,9,4,37,38,39,40,20,0,6500,1,0,500000,3,60,300,},
    [11] = {11,"K市","K市宝藏",1,10,4,41,42,43,44,20,0,7000,1,0,550000,3,60,320,},
    [12] = {12,"L市","L市宝藏",2,11,5,45,46,47,48,20,0,7500,1,0,600000,3,60,340,},
    [13] = {13,"M市","M市宝藏",3,12,5,49,50,51,52,20,0,8000,1,0,650000,3,60,360,},
    [14] = {14,"N市","N市宝藏",4,13,5,53,54,55,56,20,0,8500,1,0,700000,3,60,380,},
    [15] = {15,"O市","O市宝藏",5,14,5,57,58,59,60,20,0,9000,1,0,750000,3,45,100,},
    [16] = {16,"P市","P市宝藏",1,15,5,61,62,63,64,20,0,9500,1,0,800000,3,45,110,},
    [17] = {17,"Q市","Q市宝藏",2,16,5,65,66,67,68,20,0,10000,1,0,850000,3,45,120,},
    [18] = {18,"R市","R市宝藏",3,17,5,69,70,71,72,20,0,10500,1,0,900000,3,45,130,},
    [19] = {19,"S市","S市宝藏",4,18,5,73,74,75,76,20,0,11000,1,0,950000,3,45,140,},
    [20] = {20,"T市","T市宝藏",5,19,5,77,78,79,80,20,0,11500,1,0,1000000,3,45,150,},
    [21] = {21,"U市","U市宝藏",1,20,5,81,82,83,84,20,0,12000,1,0,1050000,3,45,160,},
    [22] = {22,"V市","V市宝藏",2,21,5,85,86,87,88,20,0,12500,1,0,1100000,3,45,170,},
    [23] = {23,"W市","W市宝藏",3,22,5,89,90,91,92,20,0,13000,1,0,1150000,3,45,180,},
    [24] = {24,"X市","X市宝藏",4,23,5,93,94,95,96,20,0,13500,1,0,1200000,3,45,190,},
    [25] = {25,"Y市","Y市宝藏",5,24,5,97,98,99,100,20,0,14000,1,0,1250000,3,45,200,},
    [26] = {26,"Z市","Z市宝藏",1,25,5,101,102,103,104,20,0,14500,1,0,1300000,3,45,210,},
    [27] = {27,"AA市","AA市宝藏",2,26,5,105,106,107,108,20,0,15000,1,0,1350000,3,45,220,},
    [28] = {28,"AB市","AB市宝藏",3,27,5,109,110,111,112,20,0,15500,1,0,1400000,3,45,230,},
    [29] = {29,"AC市","AC市宝藏",4,28,5,113,114,115,116,20,0,16000,1,0,1450000,3,45,240,},
    [30] = {30,"AD市","AD市宝藏",5,29,5,117,118,119,120,20,0,16500,1,0,1500000,3,45,250,},
    [31] = {31,"AE市","AE市宝藏",1,30,5,121,122,123,124,20,0,17000,1,0,1550000,23,0,1500,},
    [32] = {32,"AF市","AF市宝藏",2,31,5,125,126,127,128,20,0,17500,1,0,1600000,23,0,1600,},
    [33] = {33,"AG市","AG市宝藏",3,32,5,129,130,131,132,20,0,18000,1,0,1650000,23,0,1700,},
    [34] = {34,"AH市","AH市宝藏",4,33,5,133,134,135,136,20,0,18500,1,0,1700000,23,0,1800,},
    [35] = {35,"AI市","AI市宝藏",5,34,5,137,138,139,140,20,0,19000,1,0,1750000,23,0,1900,},
    [36] = {36,"AJ市","AJ市宝藏",1,35,5,141,142,143,144,20,0,19500,1,0,1800000,23,0,2000,},
    [37] = {37,"AK市","AK市宝藏",2,36,5,145,146,147,148,20,0,20000,1,0,1850000,23,0,2100,},
    [38] = {38,"AL市","AL市宝藏",3,37,5,149,150,151,152,20,0,20500,1,0,1900000,23,0,2200,},
    [39] = {39,"AM市","AM市宝藏",4,38,5,153,154,155,156,20,0,21000,1,0,1950000,23,0,2300,},
    [40] = {40,"AN市","AN市宝藏",5,39,5,157,158,159,160,20,0,21500,1,0,2000000,23,0,2400,},
    [41] = {41,"敬请期待","0",0,40,5,0,0,0,0,0,0,0,0,0,0,0,0,0,},
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
    [41] = 41,
}

local __key_map = {
    id = 1,
    name = 2,
    award_name = 3,
    base_id = 4,
    open_id = 5,
    open_level = 6,
    dungeon_1 = 7,
    dungeon_2 = 8,
    dungeon_3 = 9,
    dungeon_4 = 10,
    award_type1 = 11,
    award_value1 = 12,
    award_size1 = 13,
    award_type2 = 14,
    award_value2 = 15,
    award_size2 = 16,
    award_type3 = 17,
    award_value3 = 18,
    award_size3 = 19,
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

        assert(__key_map[k], "cannot find " .. k .. " in record_corps_dungeon_chapter_info")
        return t._raw[__key_map[k]]
    end
}

function corps_dungeon_chapter_info.getLength()
    return #corps_dungeon_chapter_info._data
end

function corps_dungeon_chapter_info.hasKey(k)
    if __key_map[k] == nil then
        return false
    else
        return true
    end
end

function corps_dungeon_chapter_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = corps_dungeon_chapter_info._data[index]}, m)
end

function corps_dungeon_chapter_info.get(id)
    local k = id
    return corps_dungeon_chapter_info.indexOf(__index_id[k])
end

function corps_dungeon_chapter_info.set(id, key, value)
    local record = corps_dungeon_chapter_info.get(id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end

function corps_dungeon_chapter_info.get_index_data()
    return __index_id
end

