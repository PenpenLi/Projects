--
-- Author: Yutou
-- Date: 2017-02-20 18:39:46
--
-- 主线岛屿选择的基类
--===============
local MissionIslandBaseScroller = class("MissionIslandBaseScroller", function ()            
    return ccui.Layout:create()
end)

local scheduler = require("framework.scheduler")
local EffectNode = require("app.effect.EffectNode")

MissionIslandBaseScroller.CACHENUM = 2       --前后缓存两座岛屿
MissionIslandBaseScroller.MAXINSLANDNUM = 5    ---最大的岛屿数量
MissionIslandBaseScroller.PRE_Y = 65           --预留的距离
MissionIslandBaseScroller.GAP = 380            --岛屿间的间隔
MissionIslandBaseScroller.NORMAL_MOVE_RATE = 1
MissionIslandBaseScroller.MIN_ISLANDNUM = 3     --至少显示的岛屿数量

MissionIslandBaseScroller.TOP_ORDER = 100

function MissionIslandBaseScroller:ctor()
    self:enableNodeEvents()
    self._islands = {}
    self._listData = nil
    self._initIndex = nil
    self._startY = 0
    self._touching = false
    self._schedulerKey= nil
    self._valideListDatas = nil
    self._enableTouchMove = true
    self:setTouchEnabled(true)
    self._currentIndex = 0

    self._scrollView = ccui.ScrollView:create()
    self._scrollView:setTouchEnabled(true)
    self._scrollView:setContentSize(cc.size(display.width, display.height))
    self._scrollView:setPosition(0,0)
    self._scrollView:setScrollBarEnabled(false)
    self._scrollView:setName("IslandScrollView")
    --self._scrollView:setScrollBarWidth(4)
    self:addChild(self._scrollView)
    self._scrollView:scrollToTop(0,false)--移动到最底层
    self._rate = MissionIslandBaseScroller.NORMAL_MOVE_RATE
    self._scrollView:addEventListener(handler(self, self.renderPage))

    self._topNode = display.newNode()
    self._scrollView:addChild(self._topNode, MissionIslandBaseScroller.TOP_ORDER)

      ---5个可以被看到的岛屿的位置
    self._placePostions = {
    {x = display.cx,y = -100,scale = 0.0,},
    {x = display.cx,y = 100,scale = 0.8,},
    {x = display.cx,y = 450,scale = 1.2,},
    {x = display.cx,y = 700,scale = 0.5,},
    {x = display.cx,y = 650,scale = 0.0,},}
    
end

-- function MissionIslandBaseScroller.getRiver(  )
--     if MissionIslandBaseScroller._rivers == nil then
--         MissionIslandBaseScroller._rivers = {}
--     end
--     if #MissionIslandBaseScroller._rivers > 0 then
--         local riverEffect = table.remove(MissionIslandBaseScroller._rivers,1)
--         riverEffect:start()
--         return riverEffect
--     else
--         local riverEffect = EffectNode.createEffect( "effect_river_map4" .. mapIndex,cc.p(conSize.width/2,conSize.height-60))
--         riverEffect:retain()
--         return riverEffect
--     end
-- end

-- function MissionIslandBaseScroller.putRiver( value )
--     if MissionIslandBaseScroller._rivers == nil then
--         MissionIslandBaseScroller._rivers = {}
--     end
--     value:stop()
--     table.insert(MissionIslandBaseScroller._rivers,value)
-- end

function MissionIslandBaseScroller:renderPage()
    for i=1,#self._islands do
        local isLand = self._islands[i].island
        local xworldPos = isLand:convertToWorldSpace(cc.p(0,0))
        local xSize = isLand:getContentSize()
        if xworldPos.y + xSize.height < 0 then
            isLand:show(false)
        elseif xworldPos.y > display.height then
            isLand:show(false)
        else
            local isLandNodeTop = isLand:getSubNodeByName("Node_top")
            if isLandNodeTop and tolua.isnull(isLandNodeTop) ~= true then
                isLandNodeTop:retain()
                isLandNodeTop:removeFromParent()
                self._topNode:addChild(isLandNodeTop)
                isLandNodeTop:release()
                isLandNodeTop:setPositionY(isLand:getPositionY())
            end
            isLand:show(true)
        end
    end
end

function MissionIslandBaseScroller:setHeight( height )
    local innerHeight = self._scrollView:getInnerContainerSize().height
    if innerHeight ~= height then
        self._scrollView:setInnerContainerSize(cc.size(display.width, height))
        if #self._listData < 4 then
            self._scrollView:jumpToBottom()--
        else
            self._scrollView:jumpToTop()--
        end
    end
end

function MissionIslandBaseScroller:onEnter()
    self._scrollView:setTouchEnabled(true)--新手引导在点击章节的时候会锁住  回来要解锁

    self._valideListDatas = {}       ---保存已经被初始化的岛屿数组

    self._listData = self:_getDataList()
    self._initIndex = self:_getInitIndex()
    dump(self._initIndex)

    assert(self._initIndex <= #self._listData, "init index is too big " .. " " .. self._initIndex .. "  " .. #self._listData)
    dump(self._listData)
   -- dump(#self._listData)
    local per = 0
    if #self._listData > 2 then
        per = (self._initIndex -1) / (#self._listData - 2)
    end
    -- self._scrollView:scrollToPercentVertical(1110,1,true)
    -- self._scrollView:scrollToBottom(0,false)--

    -- 特殊情况，当岛屿少于4个时候
    if self._initIndex == 2 and #self._listData == 3 then
        per = 0.25
    end

    if #self._listData < 3 then
        self._scrollView:setTouchEnabled(false)
    end

    print2("IslandBaseScroller:onEnt",self._initIndex,#self._listData,(1-per)*100)

    local island
    local placeInfo
    local islandData
    local dataIndex

    print2("MissionIslandBaseScroller")
   -- dump(self._listData)
    --直接初始化所有岛屿 后期渲染不行再改
    local showNum = #self._listData >=MissionIslandBaseScroller.MIN_ISLANDNUM and #self._listData or MissionIslandBaseScroller.MIN_ISLANDNUM
    for i = 1, showNum do
        -- islandData = self._listData[i]
        -- if islandData ~= nil then
            self:_addIslandByDataIndex(i, false)
        -- end
    end
    self:setHeight(showNum*MissionIslandBaseScroller.GAP + MissionIslandBaseScroller.PRE_Y)

   -- dump(self._initIndex)
    --dump(per)
    local percent = 0
    if (1 - per) < 0 then
        percent = 0
    elseif (1 - per) > 1 then
        percent = 1
    else
        percent = (1 - per)
    end
   -- self._scrollView:jumpToPercentVertical((1 - per) * 100)
    self._scrollView:jumpToPercentVertical(percent * 100)
    --self:_setSelectedIndex(self._initIndex, true)


    ---在固定时间让玩家可以滑动，并且检查当前的岛屿是否都已经移动完毕
    -- self._schedulerKey = scheduler.scheduleGlobal(function ()
    --     self._allowChangeIndex = true
    --     local isScorllOver = true
    --     for i = 1, #self._islands do
    --         local island = self._islands[i].island
    --         isScorllOver = isScorllOver and island:isMoveOver()
    --     end

    --     if isScorllOver and not self._allIslandsMoveOver then
    --         self._allIslandsMoveOver = true
    --         uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_ISLAND_SCORLL_OVER)
    --     end

    -- end, MissionIslandBaseScroller.CHANGEINDEXBLANK)

    self:renderPage()
end

function MissionIslandBaseScroller:onExit()
    -- if MissionIslandBaseScroller._rivers then
    --     for i=1,#MissionIslandBaseScroller._rivers do
    --         MissionIslandBaseScroller._rivers[i]:release();
    --     end
    -- end
    self:removeAllChildren()
    self._enableTouchMove = true
end

---获取所有的浮岛总数
function MissionIslandBaseScroller:getIslandsCount()
   
end

function MissionIslandBaseScroller:_getDataList()
    return nil
end

function MissionIslandBaseScroller:_getInitIndex()
    return nil
end

function MissionIslandBaseScroller:_getGapByIndex( index )
    -- body
end

----添加一个岛屿
function MissionIslandBaseScroller:_addIslandByDataIndex(dataIndex, atFront)
    local islandData = self._listData[dataIndex]
    local island = self:_getNewIsland()
    island:setData(islandData, dataIndex)
    if islandData then
        island:setOnSelectCall(function (index)
           self:_onToStageScene(index)
        end)
    end

    --island:setStart(self._placePostions[(atFront and 1 or #self._placePostions)])               ---初始化到开始的位置

    island:setPosition(display.cx,(dataIndex-1)*MissionIslandBaseScroller.GAP + MissionIslandBaseScroller.PRE_Y)
    island:setName("island" .. dataIndex)
    self._valideListDatas[dataIndex] = true

    self._scrollView:addChild(island)

    if #self._islands == 0 then 
        self._islands[1] = {island = island, dataIndex = dataIndex}
        return
    end
    local newDatas = {}

     ---如果是在当前岛屿的最前面
    if dataIndex < self._islands[1].dataIndex then  
        newDatas[1] = {island = island, dataIndex = dataIndex}
        for i = 1,#self._islands do
            newDatas[#newDatas + 1] = self._islands[i]
        end
        self._islands = newDatas
        return
    end

    --如果是在当前岛屿最后面
    self._islands[#self._islands + 1] = {island = island, dataIndex = dataIndex}
end

function MissionIslandBaseScroller:_getNewIsland()
    
end

---移除一个岛屿
function MissionIslandBaseScroller:_removeIslandByDataIndex(dataIndex)
    if self._islands[1].dataIndex == dataIndex then -- 如果移除第一个岛屿
        local firstIsland = self._islands[1]
        self:removeChild(firstIsland.island) 
        local newDatas = {}
        for i = 2, #self._islands do
            newDatas[#newDatas + 1] = self._islands[i]
        end
        self._islands = newDatas
    else        --移除最后一个岛屿
        local lastIsland = self._islands[#self._islands]
        self:removeChild(lastIsland.island)
        self._islands[#self._islands] = nil
    end
    self._valideListDatas[dataIndex] = nil
end

----跳转到关卡场景层
function MissionIslandBaseScroller:_onToStageScene(index)
    
end

--是否允许滑动
function MissionIslandBaseScroller:setEnableMoveTouch(value)
    self._enableTouchMove = value
end

---设置当前选择的岛屿
function MissionIslandBaseScroller:_setSelectedIndex(value, isFirstTime)
    dump(value)
   -- if not self._allowChangeIndex then return end
    ----边界检查
    if self._currentIndex == value or value < 1 or value > #self._listData then
        return
    else
        --玩家目前能够选择的岛屿肯定是能够见到的，这时检查，目标是否是锁定的。
        for i = 1, #self._islands do
            if self._islands[i].dataIndex == value and self._islands[i].island:isLocked() then
                print("target index was locked so won't jump", value)
                return      --如果目标锁定，则不进行跳转
            end
        end
    end
    
    ----判断当前是否是往更大的下标移动
    local isGoBack = self._currentIndex > value


    self._currentIndex = value
    if self._indexChangeCall ~= nil then
        self._indexChangeCall(self._currentIndex)
    end

    ---重新排列岛屿，为了滑动的时候，当前的岛屿都在最上层
    for i = 1, #self._islands do
        self:reorderChild(self._islands[i].island, MissionIslandBaseScroller.MAXINSLANDNUM - math.abs(self._currentIndex - self._islands[i].dataIndex))
    end

    -- self:_checkOutIslands()

    local island
    -- ---检查是否有需要加入新岛屿
    -- for i = value - MissionIslandBaseScroller.CACHENUM, value + MissionIslandBaseScroller.CACHENUM do
    --     if self._listData[i] ~= nil and self._valideListDatas[i] == nil then
    --         ---如果有岛屿数据，但是目前没有被初始化
    --         self:_addIslandByDataIndex(i, i < value)
    --     end
    -- end

    local rate = 3
    local slowRate = self._rate
    for i = 1, #self._islands do
        island = self._islands[i]
        if island.dataIndex == value then
            rate = slowRate * rate * (isFirstTime and 1.5 or 1)
            island.island:setMoveData(self._placePostions[MissionIslandBaseScroller.SHOWINGISLANDINDEX])
        elseif island.dataIndex == value - 1 then
            rate = slowRate * 6 * (isFirstTime and 1.5 or 1)
            island.island:setMoveData(self._placePostions[MissionIslandBaseScroller.SHOWINGISLANDINDEX - 1])
        elseif island.dataIndex == value + 1 then
            rate = slowRate * 6 * (isFirstTime and 1.5 or 1)
            island.island:setMoveData(self._placePostions[MissionIslandBaseScroller.SHOWINGISLANDINDEX + 1])
        elseif island.dataIndex < value - 1 then
            rate = slowRate * 2.4 * (isFirstTime and 3 or 1)
            island.island:setMoveData(self._placePostions[1])
        elseif island.dataIndex > value + 1 then
            rate = slowRate * 2.4 * (isFirstTime and 3 or 1)
            island.island:setMoveData(self._placePostions[#self._placePostions])
        end
        island.island:setRate(rate)
    end

    self._allowChangeIndex = false

    ----移动设置为没有到达指定 
    self._allIslandsMoveOver = false
end

return MissionIslandBaseScroller