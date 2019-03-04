local UserBibleData = class("UserBibleData")

local UserBibleConfigConst = require("app.const.UserBibleConfigConst")
local UserBiblePageUnit = require("app.data.UserBiblePageUnit")
local UserBibleUnit = require("app.data.UserBibleUnit")
function UserBibleData:ctor()
    self._serverData = {}
    self._mainPageBibles = {
        ---根据顺序排列的UserBiblePageUnit数组
    } --主线碎片数据
    self._extraPageBibles = {
        ---根据顺序排列的UserBiblePageUnit数组
    } --支线碎片数据

    self._currentMainProgress = 0 ---主线当前页面领取进度
    self._currentExtraProgress = 0 ---支线当前页面领取进度

    self._userBibleActiveAttrsList = {}
end

function UserBibleData:setUserBibleData(data)
    self._userBibleActiveAttrsList = {}
    self._serverData = data
    self:_initPageDatas()
    local gotBibels = rawget(data, "got_hero_tokens") or {}
    table.sort(gotBibels, function (a, b)
        return a.id < b.id
    end)

    local function updateState(pageBibles, gotBibleData, bibleType)
        local gotBibleId = gotBibleData.id
        local rewardFlag = gotBibleData.reward_flag
        for j = 1, #pageBibles do
            local pageBible = pageBibles[j]
            local items = pageBible:getItems()
            for k = 1, #items do
                local bible = items[k]
                if bible:getId() == gotBibleId then
                    -------处理说明，现在后端定义的是每个珠宝对应的一个可以领取的奖励
                    ----而且只有最后一个不是默认领取的，所以前面四个珠宝在点亮之后，
                    ----reward_flag属性，都为2（已领取），如果最后一个没有领取的话，
                    ---说明本章的奖励未领取。所以，有收到这个数据，说明已经点亮，
                    ---然后只在最后一个判断奖励。
                    local lastItem = pageBible:getLastItem()
                    if lastItem:getId() == gotBibleId then
                        pageBible:setClear() ---设置为全部点亮
                        if rewardFlag == UserBibleConfigConst.BEEN_GOT then
                            pageBible:setGotReward() ---设置为已经领取了奖励
                            ------当本章奖励领取之后，默认开启下一关
                            local nextPage = pageBibles[pageBible:getIndex() + 1]
                            if nextPage ~= nil then
                                nextPage:setOpen()
                            end
                        end
                    end
                    pageBible:setOpen() ---将当前页设置为开启状态
                    bible:setLighting(true)
                    break
                end
            end
        end
    end
    local count = #gotBibels
    for i = 1, count do
        updateState(self._mainPageBibles, gotBibels[i], UserBibleConfigConst.MIAN_GROWTH)
        updateState(self._extraPageBibles, gotBibels[i], UserBibleConfigConst.EXTRA_GROWTH)

        local id = gotBibels[i].id
        local info = require("app.cfg.hero_token_info").get(id)
        assert(info,"can't find main_growth_info with id = "..tostring(id))
        self._userBibleActiveAttrsList[#self._userBibleActiveAttrsList+1] = {type=info.type,value=info.value}
        --,size = info.type == 101 and info["attr_" .. info.value] or 0}
    end
    ---默认第一个主线是解锁的
    local firstMainPageBible = self._mainPageBibles[1]
    firstMainPageBible:setOpen()

    self:_updateProgress()
end

function UserBibleData:getBibleActiveAttrsList()
    -- body
    return self._userBibleActiveAttrsList
end

function UserBibleData:_updateProgress()
    ------获取当前主线和支线的进度
    self._currentMainProgress = 0
    self._currentExtraProgress = 0
    for i = 1, #self._mainPageBibles do
        local mainPage = self._mainPageBibles[i]
        if mainPage:getOpen() then
            self._currentMainProgress = self._currentMainProgress + 1
        end
    end

    for i = 1, #self._extraPageBibles do
        local extraPage = self._extraPageBibles[i]
        if extraPage:getOpen() then
            self._currentExtraProgress = self._currentExtraProgress + 1
        end
    end
end

---根据表的数据生成一所有的碎片数据
function UserBibleData:_initPageDatas()
    self._mainPageBibles = {}
    local cfgHeroTokenInfo = require("app.cfg.hero_token_info")
    local count = cfgHeroTokenInfo.getLength()
    local pageUnit = nil
    for i = 1, count do
        local bibleData = cfgHeroTokenInfo.indexOf(i)

        -- 章节页信息
        if pageUnit == nil or pageUnit._info.tabs ~= bibleData.tabs then
            pageUnit = UserBiblePageUnit.new()
            pageUnit:setInfo(bibleData)
            self._mainPageBibles[#self._mainPageBibles + 1] = pageUnit
        end
        
        -- 珠子信息
        local growthItem = UserBibleUnit.new()
        growthItem:setInfo(bibleData)
        growthItem:setPicUrl(pageUnit:getIconUrl())
        pageUnit:addItem(growthItem)
    end

    -- self._mainPageBibles = {}
    -- self._extraPageBibles = {}
    -- local pageTable = require("app.cfg.main_growth_chapter")
    -- local count = pageTable.getLength()
    -- local growthTable = require("app.cfg.main_growth_info") 
    -- local growthCount = growthTable.getLength()
    -- local pageUnit 
    -- for i = 1, count do
    --     local pageData = pageTable.indexOf(i)
    --     pageUnit = UserBiblePageUnit.new()
    --     pageUnit:setInfo(pageData)
    --     if pageData.type == UserBibleConfigConst.MIAN_GROWTH then ---获取或者生成章节数据
    --         self._mainPageBibles[#self._mainPageBibles + 1] = pageUnit
    --     elseif pageData.type == UserBibleConfigConst.EXTRA_GROWTH then
    --         self._extraPageBibles[#self._extraPageBibles + 1] = pageUnit
    --     else
    --         dump(pageData)
    --         assert(false, "Invalide growthType in main_growth_chapter ", tostring(pageData.type))
    --     end

    --     local growthData
    --     for j = 1, growthCount do ------- 将所有属于这个章节的珠子加入
    --         growthData = growthTable.indexOf(j)
    --         if growthData.chapter_id == pageUnit:getId() then
    --             local growthItem = UserBibleUnit.new()
    --             growthItem:setInfo(growthData)
    --             growthItem:setPicUrl(pageUnit:getIconUrl())
    --             pageUnit:addItem(growthItem)
    --         end
    --     end
    --     ------加完所有的item 之后，指定最后一个item
    --     local items = pageUnit:getItems()
    --     items[#items]:set2EndOfChapter()
    --     items[#items]:setChapterTips(pageUnit:getTips())
    -- end

    -- table.sort(self._mainPageBibles, function (a, b)
    --     if a:getNextId() == 0 then -------最后一个的值为0
    --         return false
    --     else
    --         return a:getNextId() < b:getNextId()
    --     end
    -- end) 


    -- table.sort(self._extraPageBibles, function (a, b)
    --     if a:getNextId() == 0 then -------最后一个的值为0
    --         return false
    --     else
    --         return a:getNextId() < b:getNextId()
    --     end
    -- end)

    ------设置页面的index值
    for i = 1, #self._mainPageBibles do
        self._mainPageBibles[i]:setIndex(i)
    end

    for i = 1, #self._extraPageBibles do
        self._extraPageBibles[i]:setIndex(i)
    end
end

---获取当前进度的页数据
----返回当前进度的page对象，以及下标
----
function UserBibleData:getCurrentPageBible(bibleType)
    if bibleType == UserBibleConfigConst.MIAN_GROWTH then
        --print("in the data ~~~~~", #self._mainPageBibles, self._currentMainProgress, self._mainPageBibles[self._currentMainProgress])
        dump(self._currentMainProgress)
        return self._mainPageBibles[self._currentMainProgress], self._currentMainProgress
    elseif bibleType == UserBibleConfigConst.EXTRA_GROWTH then
        return self._extraPageBibles[self._currentExtraProgress], self._currentExtraProgress
    else
        assert(false, "Invalide bibleType" .. tostring(bibleType))
    end
end

function UserBibleData:getCurBibleId()
    local bibleId = 0
    local pageCount = #self._mainPageBibles

    for i = 1, pageCount do
        local userBiblePageUnit = self._mainPageBibles[i]
        local items = userBiblePageUnit:getItems()
        for i = 1, #items do
            local item = items[i]
            if item:getLighting() then
                if item:getId() > bibleId then
                    bibleId = item:getId()
                end
            end
        end
    end
    return bibleId
end

----点亮碎片
----@bibleId 服务器传来的点亮的ID
function UserBibleData:setBibleLighting(bibleId)
    local bibleData = require("app.cfg.hero_token_info").get(bibleId)
    assert(bibleData, "Invalide bible id :" .. tostring(bibleId))

    local pageCount = #self._mainPageBibles

    for i = 1, pageCount do
        local userBiblePageUnit = self._mainPageBibles[i]
        local items = userBiblePageUnit:getItems()
        for i = 1, #items do
            local item = items[i]
            if item:getId() == bibleId and not item:getLighting() then
                -----点亮了单个珠宝
                item:setLighting(true)
                print("now bible lighted `~~~~~~~~~~")
                print(item:getId())
                ---解锁新的章节
                if item:isEndOfChapter() then
                    --print("current chapter is clear", userBiblePageUnit:getId(), userBiblePageUnit:getIndex())
                    userBiblePageUnit:setClear()
                    --print(userBiblePageUnit:getRewardType(), userBiblePageUnit:getIndex(), self._mainPageBibles[userBiblePageUnit:getIndex() + 1])
                    --if userBiblePageUnit:getRewardType() ~= UserBibleConfigConst.REWARD_MULTY then 
                        local nextPage = self._mainPageBibles[userBiblePageUnit:getIndex() + 1]
                        if nextPage ~= nil then
                            nextPage:setOpen()
                            self:_updateProgress()
                            print("new chapter is open", nextPage:getId(), nextPage:getIndex())
                        end
                        userBiblePageUnit:setGotReward()
                    --end
                end

                local addParams = {type = item:getAttributeType(),value = item:getAttributeValue()}
                self._userBibleActiveAttrsList[#self._userBibleActiveAttrsList+1] = addParams
                return
            end
        end
    end
end

-----获取选择奖励后更新章节状态
function UserBibleData:setGotSelectOneReward(itemId)
    local count = #self._mainPageBibles
    for i = 1, count do
        local pageUnit = self._mainPageBibles[i]
        local items = pageUnit:getItems()
        for j = 1, #items do
            local item = items[j]
            if item:getId() == itemId then
                pageUnit:setGotReward()
                print("now get rewards~~~~~~updateddd")
                local nextPage = self._mainPageBibles[self._currentMainProgress + 1]
                if nextPage ~= nil then
                    nextPage:setOpen()
                    print("seled new is open ~~", nextPage:getId())
                    self:_updateProgress()
                end
            end
        end
        
    end
end

-----根据下标获取页签数据
function UserBibleData:getPageBibleDataByIndex(index)
    return self._mainPageBibles[index]
end

function UserBibleData:getPageBibleDataById(id)
    for i = 1,#self._mainPageBibles do
        local pageBible = self._mainPageBibles[i]
        if pageBible:getId() == id then
            return pageBible
        end
    end

    return nil
end

---根据ID获取珠宝数据
function UserBibleData:getBibleDataById(id)
    local tableData = require("app.cfg.hero_token_info").get(id)
    assert(tableData, "can't fint bible data of Id " .. tostring(id))

    local chapterId = tableData.tabs
    local pageBible = self:getPageBibleDataById(chapterId)
    return pageBible:getItemById(id)
end

---获取单页数据
function UserBibleData:getBiblePagesDataByType(type)
    if type == UserBibleConfigConst.MIAN_GROWTH then
        return self._mainPageBibles
    elseif type == UserBibleConfigConst.EXTRA_GROWTH then
        return self._extraPageBibles
    else
        assert(false, "Invalide tyep value " .. tostring(type))
    end
end

----表示属性的类型 propertyId
----返回 属性加成的中文名,所有的加成值之和,属性类型
function UserBibleData:getMainAttributeAdditionValue(attributeId)
    local attributeTable = require("app.cfg.attribute_info")
    local data = attributeTable.get(attributeId)
    assert(data, "can't fint attribute_info of id" .. tostring(attributeId))
    --local growthTable = require("app.cfg.main_growth_info")
    local growthData

    local count = #self._mainPageBibles
    local total = 0
    for i = 1, count do
        local pageUnit = self._mainPageBibles[i]
        local items = pageUnit:getItems()
        local itemCount = #items
        for j = 1, itemCount do
            local item = items[j]
            if item:getAttributeType() == attributeId and item:getLighting() then -- 单个属性
                total = total + item:getAttributeValue()
            end
            if item:getAttributeType() == 99 and item:getLighting() then --全属性
                total = total + item:getAttributeValue()[attributeId]
            end
        end
    end

    return data.cn_name , total, data.type
end

--获取buff加成
function UserBibleData:getAddedBuffs(  )
    -- body
    local list = {}
    local tempList = self._towerData.buffs or {}
    local realBuffs = {}

    for i=1,#tempList do
        local buffId = tempList[i]
        local buffInfo = require("app.cfg.common_buff_info").get(buffId)
        assert(buffInfo,"common_buff_info can't find id = "..tostring(buffId))
        if(realBuffs["key_"..tostring(buffInfo.type)] == nil)then
            realBuffs["key_"..tostring(buffInfo.type)] = {type=buffInfo.type,value=buffInfo.value,id = i}
        else
            realBuffs["key_"..tostring(buffInfo.type)].value = realBuffs["key_"..tostring(buffInfo.type)].value + buffInfo.value
        end
    end

    local num = 0
    for k,v in pairs(realBuffs) do
        local strName,strValue = GlobalFunc.getAttrDesc(v.type,v.value)
        list[#list + 1] = {name = strName,value = strValue,id = v.id}
    end

    table.sort(list,function(a,b)
        return a.id < b.id
    end)

    return list
end

---===========
---根据真经的三选一ID来获取该真经的三选一的奖励
---===========
function UserBibleData:getSelectAwardItemsById(id)
    -- local boxTable = require("app.cfg.box_info")
    self.items = {}
    -- self.data = boxTable.get(id)

    -- for i = 1, 3 do
    --     if self.data["choice_type_" .. i] ~= 0 then
    --         local item = {
    --         type = self.data["choice_type_" .. i],
    --         value = self.data["choice_value_" .. i],
    --         size = self.data["choice_size_" .. i],}
    --         self.items[#self.items + 1] = item
    --     end
    -- end

    return self.items
end

---是否有小红点
function UserBibleData:hasRedPoint()
    local hasReward = self:hasReward2SelectMain()
    local hasenoughtItemsMain = self:_hasEnoughItemsMain()
    return hasReward or hasenoughtItemsMain
end

---是否有没有领取的多选一奖励
function UserBibleData:hasReward2SelectMain()
    local currentBible = self._mainPageBibles[self._currentMainProgress]
    if not currentBible:getGotReward() and currentBible:getClear() and
        currentBible:getRewardType() == UserBibleConfigConst.REWARD_MULTY then
        return true
    else
        return false
    end
end

---是否有足够的碎片领取当前页
function UserBibleData:_hasEnoughItemsMain()
    local currentBible = self._mainPageBibles[self._currentMainProgress]
    local currentBibleUnit = currentBible:getProgressItem()
    if currentBibleUnit ~= nil then
        local name, needNum , currentNum = currentBibleUnit:getCostData()
        return currentNum >= needNum
    else
        return false
    end
end

-- 获取总章节页数量
function UserBibleData:getPagesNum()
    --dump(#self._mainPageBibles)
    return #self._mainPageBibles
end

return UserBibleData
