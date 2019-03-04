
--=====================
---主线选择关卡层
---====================
local MissionStageBaseLayer = require "app.scenes.missionnew.stageLayout.MissionStageBaseLayer"
local MissionChoseStageLayer = class("MissionChoseStageLayer", MissionStageBaseLayer)
local MissionQuickGetRewardLayer = require "app.scenes.missionnew.common.MissionQuickGetRewardLayer" 
local ChapterConfigConst = require "app.const.ChapterConfigConst" 
local ActivityFirstPayPop = require("app.scenes.activity.firstPay.ActivityFirstPayPop")

---===========
---@missionId 章节数据
---@stageId 需要跳转到指定的关卡ID，(可选) 
---@isGuidJump 是否是新手引导的跳转（可选）
---===========
function MissionChoseStageLayer:ctor(missionId, stageId, isGuidJump,index,isGetWayJump,popFight)
   -- dump("MissionChoseStageLayer:ctor(missionId, stageId, isGuidJump,index)!!!!!!!!!!!!!")
    assert(type(missionId) == "number", "invalide missionId  " .. tostring(missionId))
    dump(missionId)
    self._missionId = missionId
    self._missionData = G_Me.allChapterData:getChapterDataById(missionId)
    self._index = index
    self._isGuidJump = isGuidJump
    self._isGetWayJump = isGetWayJump
    self._movingNode = nil
    self._bgMovieLayer = nil
    self._isFistPass = nil -- 是否首次通关
    self._popFight = popFight -- 自动弹出序号

    print("MissionChoseStageLayer self._index",self._index)

    -----获取指定跳转的关卡id下标
    if stageId then
        local stageList, _ = G_Me.allChapterData:getChapterStagesByID(self._missionData:getId())
        for i=1, #stageList do
            local stageData = stageList[i]
            if stageData:getId() == stageId then
                self._initIndex = i
                break
            end
        end
    end
    print2("MissionChoseStageLayer_ctor",self._initIndex,stageId)
    --MissionChoseStageLayer.super.ctor(self,missionId, self._initIndex)
    MissionChoseStageLayer.super.ctor(self,self._initIndex)

    if self._index == nil then
        buglyReportLuaException("MissionChoseStageLayer self._index is nil:"..self._missionId)
    end
end

function MissionChoseStageLayer:onEnter()
    print("MissionChoseStageLayer:onEnter")
    MissionChoseStageLayer.super.onEnter(self)
    
   -- dump(self._missionData:getId())
    self._missionData = G_Me.allChapterData:getChapterDataById(self._missionData:getId()) --刷新本地数据。
    local recordStageData = G_Me.allChapterData:getRecordStageStatus(self._missionData:getId())
    --dump(recordStageData)
    
    self:showScrollItems(recordStageData)

    self._scrollLayer:setVisible(false) -- 先屏蔽点击目标
    self:setScrollIndex(recordStageData)
    self._scrollLayer:setVisible(not self._isFistPass)

    -- if self._missionData:getCfgInfo().bgm ~= 0 then
    --     G_AudioManager:playBGM(self._missionData:getCfgInfo().bgm)
    -- end

    --self._scrollLayer:setVisible(true)
    if self._isGetWayJump then
        self:popSpecifyHero(self._initIndex)
    end

    -- 测试代码
    -- G_Popup.newPopup(function ()
    --         local popLayer = ActivityFirstPayPop.new()
    --         return popLayer
    --     end)
end

function MissionChoseStageLayer:onExit()
    MissionChoseStageLayer.super.onExit(self)
    G_AudioManager:stopBGM(true)
    G_AudioManager:playDefaultBGM()
    self:removeChild(self._scrollLayer)
    self._scrollLayer = nil
    self._initIndex = nil
end

function MissionChoseStageLayer:showScrollItems(recordStageData)
    --滑动场景
    dump(recordStageData)
    dump(tostring(self._missionId).. " : ".. tostring(self._initIndex))
    self._scrollLayer = require("app.scenes.missionnew.missionStage.MissionStageScrollLayer").new(self._missionId,self._initIndex,self._popFight)
    self._popFight = nil
    self:addChild(self._scrollLayer, 2)
    self._scrollLayer:setUserGuideState(self._isGuidJump)
    self._scrollLayer:setOnScrollChange(function (index)
        self:_onScrollChange(index)
    end)
    self._scrollLayer:setMissionData(self._missionData, recordStageData)
end

--弹出特定关卡
function MissionChoseStageLayer:popSpecifyHero(index)
    local heroItem = self:getHeroNodeByIndex(index)
    if heroItem then
        self:performWithDelay(function ( ... )  --small bear need delayed pop
            heroItem:onShowChallengePanel(index)
        end, 0.05)
    end
end

function MissionChoseStageLayer:setScrollIndex(recordStageData)
    local currentChapterData = G_Me.allChapterData:getChapterDataByType(ChapterConfigConst.NORMAL_CHAPTER)
    if self._missionData:getCfgInfo().type == ChapterConfigConst.NORMAL_CHAPTER and 
        currentChapterData:getJustClearChapterId() == self._missionData:getId() then
        --self._scrollLayer:setFirstClearJump()
        self._isFistPass = true
        self:_popOneKeyGetReward() -- 一键领取
        --self:_playMoonboxAnim() ---播放英雄连获取动画
    else

        print("setScrollIndex",self._initIndex)
        -- if self._initIndex ~= nil then -- 指定跳转
        --     print("setScrollIndex2",self._initIndex)
            self._scrollLayer:setDetermingJump()
            self._isFistPass = false
        -- else
        --     if self._missionData:getHasEnterd() then --如果已经进入过
        --         if recordStageData ~= nil then --在战斗之后的跳转，如果是第一次通关则往后跳转，否则正常跳转。
        --             if recordStageData:isFinished() then --不是第一次通关
        --                 self._scrollLayer:setAfterBattleNotFirstFinishedJump(recordStageData:getId())
        --             else
        --                 self._scrollLayer:setAfterBattleFirstFinishedJump()
        --             end
        --         else
        --             --普通情况下，如果全部关卡三星，而且所有的关卡宝箱都已经领取。直接跳转到最后一关
        --             local stageList, progress = G_Me.allChapterData:getChapterStagesByID(self._missionData:getId())
        --             local isAllClear = true
        --             for i = 1, #stageList do
        --                 local stage = stageList[i]
        --                 if stage:getStar() ~= 3 or stage:hasRedPoint() then
        --                     isAllClear = false
        --                     break
        --                 end
        --             end
        --             if isAllClear then
        --                 self._scrollLayer:setAllClearJump()
        --             else
        --                 self._scrollLayer:setNormalJump()
        --             end
        --         end
        --     else    ---玩家首次进入
        --         local isFirstAnimPlayed = G_Me.allChapterData:getChapterFirstEnterAnimPlayed(self._missionData:getId())
        --         if not isFirstAnimPlayed then
        --             self._scrollLayer:setFirstPlayAnim()
        --             G_Me.allChapterData:setChapterFirstEnterAnimPlayed(self._missionData:getId())
        --         else
        --             self._scrollLayer:setNormalJump()
        --         end
        --     end
        -- end
    end
end

--弹出一键领取奖励界面
function MissionChoseStageLayer:_popOneKeyGetReward()
    dump(self._missionId)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_HIDE_UI, nil, false, nil)
    local isHasReward = G_Me.allChapterData:isHasRewardByCtAndCid(ChapterConfigConst.NORMAL_CHAPTER,self._missionId)
    if isHasReward then -- 如果有宝箱未领取，则弹出一键领取界面
        local oneKeyLayer = MissionQuickGetRewardLayer.new(function ( ... )
            self:_playMoonboxAnim()
            self._scrollLayer:setVisible(true)
            G_widgets:getTopBar():setVisible(true)
        end,self._missionId)
        G_widgets:getTopBar():setVisible(false)
        self:addChild(oneKeyLayer,199)
    else
        self:_playMoonboxAnim()
    end
end

---播放获得月光宝盒碎片的动画
function MissionChoseStageLayer:_playMoonboxAnim()
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_HIDE_UI, nil, false, nil)
    local HeroTokenAppearLayer = require("app.scenes.missionnew.common.HeroTokenAppearLayer")
    local MissionMovieBackground = require("app.scenes.missionnew.common.MissionMovieBackground")

    local heroTokenAppearLayer = HeroTokenAppearLayer.new(function ()
        if self._index == nil and buglyReportLuaException then
            buglyReportLuaException("MissionChoseStageLayer self._index is nil:"..self._missionId)
        end
        -- G_Me.allChapterData:setLastChapterIndex(ChapterConfigConst.NORMAL_CHAPTER, self._index + 1)
        --self:removeChild(heroTokenAppearLayer)
        self._bgMovieLayer:removeFromParent()
        --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_SHOW_UI, nil, false, nil)
        self._scrollLayer:setDetermingJump()
        --local normalChapterData = G_Me.allChapterData:getNormalChapterData()
       -- normalChapterData:setNeedToJump2Next()
       -- G_ModuleDirector:popModule()
    end, G_Lang.get("mission_chapter_title", {num = self._missionData:getOrder(), title = self._missionData:getCfgInfo().name}),  
    self._missionData:getCfgInfo().subtitle,self._missionId)
    self:addChild(heroTokenAppearLayer, 200)
    heroTokenAppearLayer:setPosition(0, 0)

    ---添加屏幕效果
    self._bgMovieLayer = MissionMovieBackground.new()
    self:addChild(self._bgMovieLayer, 300)
end

return MissionChoseStageLayer