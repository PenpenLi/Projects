---@classdef record_tombexploremain_info
local record_tombexploremain_info = {}


record_tombexploremain_info.chapter_id = 0--章节id
record_tombexploremain_info.nextchapter_id = 0--下一章节id
record_tombexploremain_info.stage1 = 0--关卡1
record_tombexploremain_info.stage2 = 0--关卡2
record_tombexploremain_info.stage3 = 0--关卡3
record_tombexploremain_info.stage4 = 0--关卡4
record_tombexploremain_info.stage5 = 0--关卡5
record_tombexploremain_info.stage6 = 0--关卡6
record_tombexploremain_info.stage7 = 0--关卡7
record_tombexploremain_info.stage8 = 0--关卡8
record_tombexploremain_info.stage9 = 0--关卡9
record_tombexploremain_info.stage10 = 0--关卡10
record_tombexploremain_info.tomb_name =  ""--皇章节名称
record_tombexploremain_info.recommend_power = 0--推荐战力

local tombexploremain_info = {
   _data = {   
    [1] = {501,502,501101,501102,501103,501104,501105,501106,501107,501108,501109,501110,"chapter_1",200000,},  
    [2] = {502,503,502101,502102,502103,502104,502105,502106,502107,502108,502109,502110,"chapter_2",480000,},  
    [3] = {503,504,503101,503102,503103,503104,503105,503106,503107,503108,503109,503110,"chapter_3",1100000,},  
    [4] = {504,505,504101,504102,504103,504104,504105,504106,504107,504108,504109,504110,"chapter_4",2000000,},  
    [5] = {505,506,505101,505102,505103,505104,505105,505106,505107,505108,505109,505110,"chapter_5",3000000,},  
    [6] = {506,507,506101,506102,506103,506104,506105,506106,506107,506108,506109,506110,"chapter_6",4500000,},  
    [7] = {507,508,507101,507102,507103,507104,507105,507106,507107,507108,507109,507110,"chapter_7",6200000,},  
    [8] = {508,509,508101,508102,508103,508104,508105,508106,508107,508108,508109,508110,"chapter_8",8000000,},  
    [9] = {509,510,509101,509102,509103,509104,509105,509106,509107,509108,509109,509110,"chapter_9",10000000,},  
    [10] = {510,511,510101,510102,510103,510104,510105,510106,510107,510108,510109,510110,"chapter_10",12000000,},  
    [11] = {511,512,511101,511102,511103,511104,511105,511106,511107,511108,511109,511110,"chapter_11",15500000,},  
    [12] = {512,513,512101,512102,512103,512104,512105,512106,512107,512108,512109,512110,"chapter_12",20000000,},  
    [13] = {513,514,513101,513102,513103,513104,513105,513106,513107,513108,513109,513110,"chapter_13",25000000,},  
    [14] = {514,515,514101,514102,514103,514104,514105,514106,514107,514108,514109,514110,"chapter_14",30000000,},  
    [15] = {515,516,515101,515102,515103,515104,515105,515106,515107,515108,515109,515110,"chapter_15",36000000,},  
    [16] = {516,517,516101,516102,516103,516104,516105,516106,516107,516108,516109,516110,"chapter_16",53000000,},  
    [17] = {517,518,517101,517102,517103,517104,517105,517106,517107,517108,517109,517110,"chapter_17",60000000,},  
    [18] = {518,519,518101,518102,518103,518104,518105,518106,518107,518108,518109,518110,"chapter_18",67000000,},  
    [19] = {519,520,519101,519102,519103,519104,519105,519106,519107,519108,519109,519110,"chapter_19",75000000,},  
    [20] = {520,521,520101,520102,520103,520104,520105,520106,520107,520108,520109,520110,"chapter_20",82000000,},  
    [21] = {521,522,521101,521102,521103,521104,521105,521106,521107,521108,521109,521110,"chapter_21",100000000,},  
    [22] = {522,523,522101,522102,522103,522104,522105,522106,522107,522108,522109,522110,"chapter_22",125000000,},  
    [23] = {523,524,523101,523102,523103,523104,523105,523106,523107,523108,523109,523110,"chapter_23",150000000,},  
    [24] = {524,525,524101,524102,524103,524104,524105,524106,524107,524108,524109,524110,"chapter_24",180000000,},  
    [25] = {525,526,525101,525102,525103,525104,525105,525106,525107,525108,525109,525110,"chapter_25",220000000,},  
    [26] = {526,527,526101,526102,526103,526104,526105,526106,526107,526108,526109,526110,"chapter_26",270000000,},  
    [27] = {527,528,527101,527102,527103,527104,527105,527106,527107,527108,527109,527110,"chapter_27",320000000,},  
    [28] = {528,529,528101,528102,528103,528104,528105,528106,528107,528108,528109,528110,"chapter_28",370000000,},  
    [29] = {529,530,529101,529102,529103,529104,529105,529106,529107,529108,529109,529110,"chapter_29",420000000,},  
    [30] = {530,0,530101,530102,530103,530104,530105,530106,530107,530108,530109,530110,"chapter_30",500000000,},
    }
}

local __index_chapter_id = {   
    [501] = 1,  
    [502] = 2,  
    [503] = 3,  
    [504] = 4,  
    [505] = 5,  
    [506] = 6,  
    [507] = 7,  
    [508] = 8,  
    [509] = 9,  
    [510] = 10,  
    [511] = 11,  
    [512] = 12,  
    [513] = 13,  
    [514] = 14,  
    [515] = 15,  
    [516] = 16,  
    [517] = 17,  
    [518] = 18,  
    [519] = 19,  
    [520] = 20,  
    [521] = 21,  
    [522] = 22,  
    [523] = 23,  
    [524] = 24,  
    [525] = 25,  
    [526] = 26,  
    [527] = 27,  
    [528] = 28,  
    [529] = 29,  
    [530] = 30,
}

local __key_map = { 
    chapter_id = 1,
    nextchapter_id = 2,
    stage1 = 3,
    stage2 = 4,
    stage3 = 5,
    stage4 = 6,
    stage5 = 7,
    stage6 = 8,
    stage7 = 9,
    stage8 = 10,
    stage9 = 11,
    stage10 = 12,
    tomb_name = 13,
    recommend_power = 14,
}

local m = { 
    __index = function(t, k) 
        if k == "toObject" then
            return function()  
                local o = {}
                for key, v in pairs (__key_map) do 
                    o[key] = t._raw[v]
                end
                return o
            end 
        end
        
        assert(__key_map[k], "cannot find " .. k .. " in record_tombexploremain_info")

        return t._raw[__key_map[k]]
    end
}


function tombexploremain_info.getLength()
    return #tombexploremain_info._data
end



function tombexploremain_info.hasKey(k)
  if __key_map[k] == nil then
    return false
  else
    return true
  end
end


---
--@return @class record_tombexploremain_info
function tombexploremain_info.indexOf(index)
    if index == nil then
        return nil
    end
    return setmetatable({_raw = tombexploremain_info._data[index]}, m)
end



---
--@return @class record_tombexploremain_info
function tombexploremain_info.get(chapter_id)
    
    return tombexploremain_info.indexOf(__index_chapter_id[ chapter_id ])
     
end



function tombexploremain_info.set(chapter_id, key, value)
    local record = tombexploremain_info.get(chapter_id)
    if record then
        local keyIndex = __key_map[key]
        if keyIndex then
            record._raw[keyIndex] = value
        end
    end
end




function tombexploremain_info.get_index_data()
    return __index_chapter_id 
end

return  tombexploremain_info 