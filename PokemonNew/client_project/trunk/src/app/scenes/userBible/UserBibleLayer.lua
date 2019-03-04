
---月光宝盒显示层
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UserBibleConfigConst = require "app.const.UserBibleConfigConst" 
local UserBiblePageLayout = require "app.scenes.userBible.UserBiblePageLayout"
local UserBibleColorUpLayer = require "app.scenes.userBible.UserBibleColorUpLayer"
local EffectNode = require "app.effect.EffectNode"
local TeamUtils = require "app.scenes.team.TeamUtils"

local UserBibleLayer = class("UserBibleLayer", function ()
    return display.newLayer()
end)

UserBibleLayer.PASSMOVE_TIME = 0.5
UserBibleLayer.PLAY_FADE_TIME = 0.2
UserBibleLayer.MOON_BOX_OPACITY = 160

UserBibleLayer.SCROLL_DIST = 100 --滑动多长的X值可以到下一页

function UserBibleLayer:ctor()
    self:enableNodeEvents()

    self._pageView = nil
    self._progressIndex = nil ---当前的进度
    self._currentPageIndex = nil ---当前页面的下标
    self._currentPageBibleData = nil --当前的页面
    self._needScrollList = true
    self._moonBoxCon = nil
    self._layerColor = nil
    self._hasSendLightMsg = false --是否已经发送点亮请求、
    self._view = nil
    self._lightedId = nil
    self._reciveAwards = nil
    self._pageDataList = G_Me.userBibleData:getBiblePagesDataByType(UserBibleConfigConst.MIAN_GROWTH)
    --dump(self._pageDataList)
    self._currentPageBibleData, self._progressIndex = nil,nil--G_Me.userBibleData:getCurrentPageBible(UserBibleConfigConst.MIAN_GROWTH)
    --dump(self._progressIndex)
    self._currentPageIndex = nil--self._progressIndex      ---默认的一开始显示为当前进度的一页
    self._firstIn = true -- 第一次进这个界面
end

function UserBibleLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_USER_BIBLE_GET_BIBLE, self._onLightBall, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GET_USER_BIBLE_GET_ONE_OF_AWARDS, self._onGetOneOfAwards, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_USER_BIBLE_PLAY_STAR_LINE, self._onPlayStarLine, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_USER_BIBLE_GET_BIBLE_DATA, self._onFreshData, self)

    -- 请求数据
    G_HandlersManager.userBibleHandler:sendUserBibleData()

    self:_initUI()
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1554)

    -- tempCode 测试代码
    -- G_Popup.newPopupWithTouchEnd(function ()
    --     return require("app.scenes.userBible.HeroTokenUpQualityLayer").new()
    -- end,nil,false,nil,40)
end

function UserBibleLayer:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    self:removeAllChildren(true)
end

function UserBibleLayer:_initUI()
    self._view = cc.CSLoader:createNode(G_Url:getCSB("UserBibleScene","userBible"))
    local holder = self._view:getSubNodeByName("Panel_holder")
    holder:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(holder)
    self:addChild(self._view)

    -- 获取属性层
    self._panelAttr = self._view:getSubNodeByName("Panel_light_attr")

    --添加按钮处理
    self:updateButton("Button_back", function ( )
         G_ModuleDirector:popModule()
    end)

    self:updateButton("Button_attr_info", function ()
         G_Popup.newPopupWithTouchEnd(function ()
             local panel = require("app.scenes.userBible.UserBibleSummaryLayout").new()
             return panel
         end,false,false)
    end)

    self:getSubNodeByName("Button_summary"):updateLabel("Text_title", {
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        text = G_LangScrap.get("userbible_summary")
    })

    self:updateButton("Button_left", function ()
        if self._currentPageIndex == nil then return end
        self:_setPageSelected(self._currentPageIndex - 1)
    end)

    self:updateButton("Button_right", function ()
        if self._currentPageIndex == nil then return end
        self:_setPageSelected(self._currentPageIndex + 1)
    end)

    UpdateButtonHelper.updateBigButton(
        self:getSubNodeByName("Button_light_up"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("userbible_light_up"),
        callback = function ()
            --if not self._hasSendLightMsg then
                self:_lightupBible()
            --     self._hasSendLightMsg = true
            -- else
            --     buglyPrint("self._hasSendLightMsg:true ", 3, "UserBibleLayer")
            -- end
        end
    })

    self._moonBoxCon = self:getSubNodeByName("Panel_box_con")

    --添加英雄显示
    local heroCon = self:getSubNodeByName("Panel_hero_con")
    heroCon:removeAllChildren()
    local inforData = G_Me.teamData:getKnightDataByPos(1)
    local heroUrl = inforData.cfgData.sex == 1 and "bg_userbible_cmbox_role02" or "bg_userbible_cmbox_role04"
    -- self._hero = display.newSprite(G_Url:getUI_userBible(heroUrl))
    -- self._hero:setAnchorPoint(0.5, 0.1)
    -- self._hero:setOpacity(140)
    -- self._hero:setScale(1/0.65)
    -- self._hero:setVisible(G_Setting.get("appstore_version") ~= "1")
    -- heroCon:addChild(self._hero)

     --版娘设置
    local starLevel = inforData.serverData.starLevel
    --local _,starLevel = TeamUtils.level2starName( starLevel )
    dump(starLevel)
    local fashionId = G_Me.userData:getFashionId() ~= 0 and G_Me.userData:getFashionId() or nil
    local knightSpine = require("app.common.KnightImg").new(inforData.cfgData.sex == 1 and 5 or 15,starLevel,0,nil,nil,nil,nil,fashionId)
    knightSpine:setScale(1.5)
    knightSpine:setOpacity(100)
    heroCon:addChild(knightSpine)
    self._knightSpine = knightSpine

    local pagesCon = self:getSubNodeByName("Panel_pages_con")
    local pagesConSize = pagesCon:getContentSize()
    self._pageDataListView = require("app.ui.WListView").new(pagesConSize.width,pagesConSize.height,100,128, false)
    self._pageDataListView:setCreateCell(function(view,idx)
        local cell = require("app.scenes.userBible.UserBiblePageCell").new(handler(self,self._onPageListClicked))
        return cell
    end)
    self._pageDataListView:setUpdateCell(function(view,cell,idx)
        cell:updateCell(view, idx, self._pageDataList[idx + 1]) --数据下标从0开始
    end)
    self._pageDataListView:setCellNums(#self._pageDataList, true, 0)
    pagesCon:addChild(self._pageDataListView)

    ---------创建所有的页面
    self._pageView = self:getSubNodeByName("PageView_stars")
    local pageViewSize = self._pageView:getContentSize()
    for i = 1, #self._pageDataList do
        local pageData = self._pageDataList[i]
        local newPage = UserBiblePageLayout.new(pageData, pageViewSize.width, pageViewSize.height)
        self._pageView:addPage(newPage)
    end
    dump(self._currentPageIndex)
    --self._pageView:scrollToPage(self._currentPageIndex - 1)

    local function pageViewEvent(sender, eventType)
        dump("function pageViewEvent(sender, eventType)!!")
        if eventType == ccui.PageViewEventType.turning then
            local newPageIndex = self._pageView:getCurrentPageIndex()
            local newDataIndex = newPageIndex + 1
            self:getSubNodeByName("Node_active"):setVisible(true)
            if not self._needScrollList then
                self._needScrollList = true
            else
                if self._currentPageIndex ~= newDataIndex then
                    --dump(" self._currentPageIndex ~= newDataIndex!!!")
                    --self:_setPageSelected(newDataIndex)
                end
            end
        end
    end 

    --pageView 点击事件。
    local function pageViewTouchEvent(sender, state)
        --dump("function pageViewTouchEvent(sender, eventType)!!")
        self._pageView:setPropagateTouchEvents(true)
        if(state == ccui.TouchEventType.began)then
            return true
        elseif(state == ccui.TouchEventType.moved)then
            local moveDistX = math.abs(sender:getTouchMovePosition().x - sender:getTouchBeganPosition().x)
            if moveDistX >= UserBibleLayer.SCROLL_DIST then
                --self:getSubNodeByName("Node_active"):setVisible(false)
            end
        elseif(state == ccui.TouchEventType.ended or state == ccui.TouchEventType.canceled)then
            local endDistX = math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)

            if endDistX >= UserBibleLayer.SCROLL_DIST then
                self:getSubNodeByName("Node_active"):setVisible(false)
            end

            local newPageIndex = self._pageView:getCurrentPageIndex()
            local newDataIndex = newPageIndex + 1
            if self._currentPageIndex ~= newDataIndex then
                dump(" self._currentPageIndex ~= newDataIndex!!!")
                self:_setPageSelected(newDataIndex)
            end
        end
    end

    self._pageView:addEventListener(pageViewEvent)
    self._pageView:addTouchEventListener(pageViewTouchEvent)
    --self:_setPageSelected(self._currentPageIndex)

    self._view:updateLabel("Text_clear", G_LangScrap.get("userbible_been_lighted"))
    self._view:updateLabel("Text_closed", G_LangScrap.get("userbible_not_open"))

    self:_addOutline2Label("Text_limit_word", "Text_cost_word", "Text_cost_value", "Text_clear", "Text_closed")

    -----检查当前的数据是否有奖励没领
    if G_Me.userBibleData:hasReward2SelectMain() then
        self:_showSelectRewardPanel(self._currentPageBibleData:getRewardValue())
    end

    self:_onUpdateBallScaleAct()
    --self:_updateShow()
    dump(self._pageView:getCurrentPageIndex())
end

---更新显示
function UserBibleLayer:_updateShow()
    -----这些提示仅在开启而且未点亮的状态下显示
    self:getSubNodeByName("Panel_bottom_con"):setVisible(
        self._currentPageBibleData:getOpen() and not self._currentPageBibleData:getClear())

    self:getSubNodeByName("Text_clear"):setVisible(self._currentPageBibleData:getOpen() and 
        self._currentPageBibleData:getClear())

    self:getSubNodeByName("Text_closed"):setVisible(not self._currentPageBibleData:getOpen())

    local currentBibleUnit = self._currentPageBibleData:getProgressItem()
    --dump(currentBibleUnit)
    if currentBibleUnit ~= nil then
        local name, num , total = currentBibleUnit:getCostData()
        self:updateLabel("Text_cost_word", G_LangScrap.get("userbible_cost_word", {item = name}))
        self:updateLabel("Text_cost_value", G_LangScrap.get("userbible_cost_value", {total = total, cost = num}))
        self:updateLabel("Text_light_attr", currentBibleUnit._info.directions)

        --dump(string.len(currentBibleUnit._info.directions))
        self._panelAttr:setPositionX(string.len(currentBibleUnit._info.directions) > 30 and -100 or 0)
    end

    local isLimit = self:_getLimitLv()

    if isLimit then
        self:getSubNodeByName("Panel_limit_con"):setVisible(true)
        self:getSubNodeByName("Panel_cost_con"):setVisible(false)
    else 
        self:getSubNodeByName("Panel_limit_con"):setVisible(false)
        self:getSubNodeByName("Panel_cost_con"):setVisible(true)
        self:_updateDiscPositions(self:getSubNodeByName("Panel_cost_con"), 
                            self:getSubNodeByName("Text_cost_word"),self:getSubNodeByName("Text_cost_value"))
    end
    
    ---更新按钮
    UpdateButtonHelper.updateBigButton(
        self:getSubNodeByName("Button_light_up"),{
        state = UpdateButtonHelper.STATE_ATTENTION
    })

    -- 左右箭头显示隐藏
    self:updateButton("Button_left", {visible = self._currentPageIndex ~= 1 and true or false})
    self:updateButton("Button_right", {visible = self._currentPageIndex ~= G_Me.userBibleData:getPagesNum() and true or false})
end

---顶部页签选择后调用
function UserBibleLayer:_onPageListClicked(index,noAni,needScrollList)
    dump("_onPageListClicked!!!")
    self._needScrollList = true
   -- self._needScrollList = needScrollList and needScrollList or false
    self:_setPageSelected(index + 1,noAni)
end

---设置当前显示的页签
function UserBibleLayer:_setPageSelected(index,noAni)
    if index < 1 or index > #self._pageDataList then return end
    if self._needScrollList then
        dump(index)
        self._pageDataListView:setLocation(index - 1)
    end
    local items = self._pageDataListView:getCreatedCells()
    for i = 1 , #items do
        local item = items[i]
        item:setEffectIndex(index)
    end

    --dump(index)
    --dump(self._currentPageIndex)
    if index ~= self._currentPageIndex then
        self._currentPageBibleData = self._pageDataList[index]
        self._currentPageIndex = index
       -- dump(self._currentPageIndex)
        local msg = debug.traceback("error:", 2)
        --dump(msg)
        if noAni then
            self._pageView:setCurrentPageIndex(self._currentPageIndex - 1)
        else
            self._pageView:scrollToPage(self._currentPageIndex - 1)
        end
        self:_updateShow()
        self:_onUpdateBallScaleAct()
    end
end

---点击点亮按钮
function UserBibleLayer:_lightupBible()
    ----------------先判断是否符合限制条件
    local isLimit, limitLv = self:_getLimitLv()
    --dump(isLimit)
    if isLimit then
        G_Popup.tip(G_LangScrap.get("userbible_need_level", {level = limitLv}))
        return
    end

    -- 安全判断
    if self._currentPageBibleData == nil then
        return
    end

    local currentBibleUnit = self._currentPageBibleData:getProgressItem()
    if currentBibleUnit == nil then return end
    ----------------再判断拥有的数量
    local name, num , total = currentBibleUnit:getCostData()  
    --dump(num)     
    --dump(total)     
    if num <= total then
        G_HandlersManager.userBibleHandler:sendReadBible(currentBibleUnit:getId())     
    else
        G_Popup.tip(G_LangScrap.get("userbible_not_enough_props", {item = name}))
    end
end

----获取限制的等级，
----@return 是否被限制，以及当前限制的等级
function UserBibleLayer:_getLimitLv()
    -- local currentBibleUnit = self._currentPageBibleData:getProgressItem()
    -- if currentBibleUnit ~= nil and currentBibleUnit:getLimitType() == UserBibleConfigConst.LIMIT_LEVEL then
    --     local limitLv = currentBibleUnit:getLimitValue()
    --     if G_Me.userData.level < limitLv then
    --          return true, limitLv
    --     end
    -- end 
    return false, 0
end

function UserBibleLayer:_showSelectRewardPanel(rewardValue)
    G_Popup.newSelectRewardPopup(handler(self, self._onSelectReward), nil, rewardValue, true)
end

---选择奖励界面的回调
function UserBibleLayer:_onSelectReward(index)
    local currentPage = G_Me.userBibleData:getPageBibleDataByIndex(self._progressIndex)
    G_HandlersManager.userBibleHandler:sendGetBibleReward(currentPage:get2ServerSelectRewardId() , index)
end

----============================
----获取服务器数据后的处理
----============================

---获得四选一奖励
function UserBibleLayer:_onGetOneOfAwards(decodeBuffer)
    local rewards = decodeBuffer.awards
    --G_Popup.awardSummary(rewards)
    G_Popup.awardTips(rewards)

    self:_progress2NextPage()
end

function UserBibleLayer:_onFreshData()
    --更新本地数据到最新
    self._pageDataList = G_Me.userBibleData:getBiblePagesDataByType(UserBibleConfigConst.MIAN_GROWTH)
    self._currentPageBibleData, self._progressIndex = G_Me.userBibleData:getCurrentPageBible(UserBibleConfigConst.MIAN_GROWTH)
    dump(self._currentPageBibleData)
    --dump(self._progressIndex)
    self._currentPageIndex = self._progressIndex

    if self._firstIn then -- 第一次进入无需滚动效果
        local items = self._pageDataListView:getCreatedCells()
        for i = 1 , #items do
            local item = items[i]
            item:setEffectIndex(self._currentPageIndex)
        end
        self._pageDataListView:setLocation(self._currentPageIndex - 1)
        self._pageView:setCurrentPageIndex(self._currentPageIndex - 1)
        -- self:_onPageListClicked(self._currentPageIndex - 1,false)
        self._firstIn = false
    else
        self._pageView:scrollToPage(self._currentPageIndex - 1)
    end

    self:_updateShow()

    local pages = self._pageView:getItems()
    for i = 1, #pages do
        local page = pages[i]
        page:freshData()
    end

    local pageCells = self._pageDataListView:getCreatedCells()
    for i = 1, #pageCells do
        local page = pageCells[i]
        page:freshData()
    end

    -- if self._firstIn then -- 第一次进入无需滚动效果
    --     --self._pageView:setCurrentPageIndex(self._currentPageIndex - 1)
    --     self:_onPageListClicked(self._currentPageIndex,false)
    --     self._firstIn = false
    -- end
end

---成功点亮一个球
function UserBibleLayer:_onLightBall(decodeBuffer)
    local AudioConst = require("app.const.AudioConst")
    G_AudioManager:playSoundById(AudioConst.SOUND_LEVEL_UP_SMALL)

    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1555)

    self._lightedId = rawget(decodeBuffer, "id") -----记录刚点亮的id
    print("self._lightedId",self._lightedId)
    self._reciveAwards = decodeBuffer.awards ---记录获取到的掉落奖励

    local lightBibleData = G_Me.userBibleData:getBibleDataById(self._lightedId)
    local isLast = lightBibleData:isEndOfChapter()

    local currentPage = self._pageView:getItem(self._currentPageIndex - 1)
    currentPage:lightBall(self._lightedId, function ()
        self:_updateActiveBalls() ---更新已经点亮的球
    end) ---调用当前页签的点亮流程

    self:_addMaskLayer()
    print("self._lightedId",self._lightedId)
    --self:_onPlayMoonBoxAnim()
    self._hasSendLightMsg = false
end

---更新当前页面已经点亮的球
function UserBibleLayer:_updateActiveBalls()
    print("on active balss ~~~")
    print(self._currentPageIndex)
    local currentPage = self._pageView:getItem(self._currentPageIndex - 1)
    currentPage:updateLightBalls()
end

----点亮后自动跳转到下一个界面
function UserBibleLayer:_progress2NextPage()
    ---先更新下一页的显示
    dump(self._currentPageIndex)
    local nextPage = self._pageView:getItem(self._currentPageIndex)
    if nextPage then
        nextPage:updateLightBalls()
        nextPage:udpateActiveBalls()
    end
    
    self:_setPageSelected(self._currentPageIndex + 1)
end

------播放星星的轨迹
function UserBibleLayer:_onPlayStarLine(pos)
    dump("UserBibleLayer:_onPlayStarLine!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    self._passAnim = EffectNode.new("effect_yuegh_dian")
    self:addChild(self._passAnim)
    self._passAnim:setAutoRelease(true)
    self._passAnim:setPosition(pos.x, pos.y)
    self._passAnim:play()

    local summaryButton = self:getSubNodeByName("Button_attr_info")
    local moonBoxX, moonBoxY = summaryButton:getPosition()
    local moonBoxSize = summaryButton:getContentSize()
    local moonBoxWorldPos = summaryButton:getParent():convertToWorldSpaceAR(cc.p(moonBoxX, moonBoxY))

    local action = cc.MoveTo:create(UserBibleLayer.PASSMOVE_TIME, cc.p(moonBoxWorldPos.x, 
            moonBoxWorldPos.y))
    local onMoveOver = cc.CallFunc:create(function ()
         self:removeChild(self._passAnim)
         self._passAnim = nil
         self:_onPlayMoonBoxAnim() ---移动完毕之后，播放动画
    end)
    local moveSeq = cc.Sequence:create(action, onMoveOver)
    self._passAnim:runAction(moveSeq)
end

---更新页面球的缓动状态
function UserBibleLayer:_onUpdateBallScaleAct()
    local pages = self._pageView:getItems()
    for i = 1, #pages do
        local page = pages[i]
        if i == self._currentPageIndex then
            page:playScaleAct()
        else
            page:stopScaleAct()
        end
    end
end

----播放月光宝盒动画
function UserBibleLayer:_onPlayMoonBoxAnim()
    print("UserBibleLayer:_onPlayMoonBoxAnim!!!!!!!!!!!!!!!!"..self._lightedId)
    local lightBibleData = G_Me.userBibleData:getBibleDataById(self._lightedId)
    local isLast = lightBibleData:isEndOfChapter()
    
    local fadeOver
    dump(isLast)
    if isLast then ---最后一个点亮
        fadeOver = function ()
            self:_updateShow()
            self:_handleEndReward(lightBibleData)
            self:_removeMaskLayer()
        end
    else
        fadeOver = function ()
             self:_updateShow()
             self:_showLightBibleTips(lightBibleData)
             self:_removeMaskLayer()
        end
    end

    fadeOver()
end

---更新当前点亮的显示
function UserBibleLayer:_updateLightingBalls()
    self._currentPageBibleData, self._progressIndex = G_Me.userBibleData:getCurrentPageBible(UserBibleConfigConst.MIAN_GROWTH)
    dump(self._currentPageBibleData)
   -- dump(self._progressIndex)
    local currentPage = self._pageView:getItem(self._progressIndex - 1)
    currentPage:udpateActiveBalls()
end

-----当点亮最后一个珠宝之后
function UserBibleLayer:_handleEndReward(lightBibleData)
    local chapterId = lightBibleData:getChapterId()
    local pageData = G_Me.userBibleData:getPageBibleDataById(chapterId)
    --local pageRewardType = pageData:getRewardType()
    local pageRewardType = lightBibleData:getRewardType()

    if pageRewardType == UserBibleConfigConst.REWARD_MULTY then
       --self:_showSelectRewardPanel(pageData:getRewardValue())
       self:_progress2NextPage()
    elseif pageRewardType == UserBibleConfigConst.REWARD_NOTHING then
            self:_progress2NextPage()
    elseif pageRewardType == UserBibleConfigConst.REWARD_DROP or pageRewardType == UserBibleConfigConst.REWARD_KNIGHT then
        if self._reciveAwards ~= nil then
            --G_Popup.awardSummary(self._reciveAwards)
            G_Popup.awardTips(self._reciveAwards)

            self._reciveAwards = nil
        end
        self:_progress2NextPage()
    elseif pageRewardType == UserBibleConfigConst.REWARD_HERO_UPGREATE then
        -----------调用升品
        G_Popup.newPopupWithTouchEnd(function ()
            return require("app.scenes.userBible.HeroTokenUpQualityLayer").new()
        end,nil,false,nil,40)
        self:_progress2NextPage()

        if self._knightSpine then
            self._knightSpine:playVoice()
        end

        -- G_Popup.newPopup(function ()
        --     local knightTupoLayer = UserBibleColorUpLayer.new(function () 
        --         self:_progress2NextPage()
        --         self._view:setVisible(true)
        --     end)
        --     return knightTupoLayer
        -- end, true)
        --self._view:setVisible(false)
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_USER_BIBLE_PLAYER_COLOR_UPGRADE)
    end
end


----处理属性奖励
function UserBibleLayer:_showLightBibleTips(lightBibleData)
    local params = {}
    local summaryButton = self:getSubNodeByName("Button_attr_info")
    local summaryPosX, summaryPosY = summaryButton:getPosition()

    local firstTip = {
        content = G_LangScrap.get("userbible_light_success"),
        group = 1,
        finishCallback = function () ---弹完之后的调用
            local preScale = summaryButton:getScale()
            local scaleAct1 = cc.EaseOut:create(cc.ScaleTo:create(0.15, preScale * 1.15), 0.25)
            local scaleAct2 = cc.EaseOut:create(cc.ScaleTo:create(0.15, preScale), 0.25)
            local easeSeq = cc.Sequence:create(scaleAct1, scaleAct2)
            summaryButton:runAction(easeSeq)
            self:_updateLightingBalls()
        end,
        dstPosition = summaryButton:getParent():convertToWorldSpaceAR(cc.p(summaryPosX, summaryPosY))
    }
    local seconedTip = {
        content = G_LangScrap.get("userbible_light_tip", {tips = lightBibleData:getTips()}),
        group = 1,
        dstPosition = summaryButton:getParent():convertToWorldSpaceAR(cc.p(summaryPosX, summaryPosY))
    }
    params[1] = firstTip
    params[2] = seconedTip

    G_Popup.textSummary(params)
    if self._reciveAwards ~= nil then
        --G_Popup.awardSummary(self._reciveAwards)
        G_Popup.awardTips(self._reciveAwards)
    end
    self._lightedId = nil
    self._reciveAwards = nil
end

----添加背后的透明遮罩，阻止玩家的其他操作
function UserBibleLayer:_addMaskLayer()
    self._layerColor = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))

    self._layerColor:setContentSize(display.width, display.height)
    self._layerColor:setAnchorPoint(0, 0)
    self._layerColor:enableNodeEvents()
    self:addChild(self._layerColor, 200)
    
    self._layerColor:setTouchEnabled(true)
    self._layerColor:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self._layerColor:registerScriptTouchHandler(function(event)
        return true
    end)
end

function UserBibleLayer:_removeMaskLayer()
    if self._layerColor ~= nil then
        self:removeChild(self._layerColor)
        self._layerColor = nil
    end
end

----更新文字的排列。
function UserBibleLayer:_updateDiscPositions(con, label1, label2)
    local conSize = con:getContentSize()
    local label1Size = label1:getContentSize()
    local label2Size = label2:getContentSize()

    local totalWidth = label1Size.width + label2Size.width
    label1:setPosition(conSize.width/2 - totalWidth/2, label1:getPositionY())
    label2:setPosition(conSize.width/2 - totalWidth/2 + label1Size.width + 5, label2:getPositionY())
end

---添加统一的文字描边
function UserBibleLayer:_addOutline2Label(...)
    local labelNames = {...}
    for i = 1, #labelNames do
        local labelName = labelNames[i]
         self:updateLabel(labelName, {
            outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
            outlineSize = 2
        })
    end
end

return UserBibleLayer