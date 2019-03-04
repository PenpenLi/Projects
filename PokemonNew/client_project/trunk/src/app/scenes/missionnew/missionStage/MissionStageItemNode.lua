
local MissionStageBaseItemNode = require "app.scenes.missionnew.stageLayout.MissionStageBaseItemNode"
local MissionStageItemNode = class("MissionStageItemNode", MissionStageBaseItemNode)

local ChapterConfigConst = require("app.const.ChapterConfigConst")
local MissionBoxAwardPopupLayout = require("app.scenes.missionnew.common.MissionBoxAwardPopupLayout")
local MissionBubblePopNode = require "app.scenes.missionnew.missionStage.MissionBubblePopNode"
local MissionStageHeroLayout = require "app.scenes.missionnew.stageLayout.MissionStageHeroLayout"
local EffectMovingNode = require "app.effect.EffectMovingNode"
local ParameterInfo = require "app.cfg.parameter_info"
local EffectNode = require "app.effect.EffectNode"
local CommonStar = require("app.common.CommonStar")

MissionStageItemNode.HEROINDEX = 1 ---所有添加对象的显示层级
MissionStageItemNode.NAMEINDEX = 2
MissionStageItemNode.STARINDEX = 3
MissionStageItemNode.BATTLE_EFFECT_INDEX = 4
---宝箱容器的尺寸
MissionStageItemNode.BOXWIDTH = 80
MissionStageItemNode.BOXHEIGHT = 70

MissionStageItemNode.HEROSCALE = 0.65 -- 英雄在显示的时候缩放比例
MissionStageItemNode.HEROTOUCHSCALE = 0.7 --英雄点击之后的缩放比例

MissionStageItemNode.HERO_UI_X_OFFSET = -8 --英雄顶部的显示UI，需要向左边调整。
MissionStageItemNode.EMOTIONS_STAY_TIEM = 1 --小怪死亡之后表情停留的时间

MissionStageItemNode.BUBBLE_TYPE = 900 ---气泡类型
MissionStageItemNode.LAST_ONE_Y_OFFSET = 100 

MissionStageItemNode.MIN_GUID_LV_PARAM_ID = 119
MissionStageItemNode.MAX_GUID_LV_PARAM_ID = 118

---=========
---关卡每层的显示
---@index 当前关卡在章节数组中的位置
---@mapData 显示配置
---@onHeroSelected 选中之后回调
---@isLastOne 是否为最后一个怪物所在的关卡
---=========
function MissionStageItemNode:ctor(index, mapData, onHeroSelected, isLastOne)
    self._delay = 0
    self._endX = 0
    self._endY = 0
    self._stars = nil
    self._hero = nil
    self._heroName = nil
    self._boxCon = nil
    self._dieAnim = nil
    self._stageData = nil
    self._emotionImg = nil
    self._sceneImageInit = false
    -- self._hasPlayedVoice = false --是否已经播放了喊话。
    self._bubble = nil
    self._isLocked = false
    self._effectNode = nil
    self._boxEffect = nil
    self._guideHand = nil --引导玩家点击的手指
    self._isLastOne = isLastOne
    self._heroYOffset = self._isLastOne and MissionStageItemNode.LAST_ONE_Y_OFFSET or 0
    self._heroScale = MissionStageItemNode.HEROSCALE * (self._isLastOne and 1.2 or 1)
    self._heroTouchScale = MissionStageItemNode.HEROTOUCHSCALE * (self._isLastOne and 1.2 or 1)
    self._heroUIOffset = self._heroYOffset + (self._isLastOne and 30 or 0)
    self._isActive = false --是否为正在攻打状态

    MissionStageItemNode.super.ctor(self, index, mapData, onHeroSelected)

    ---在最后一个BOSS的情况下，还需要缩放点击的容器
    if self._isLastOne then
        local heroHolderSize = self._heroHolder:getContentSize()
        self._heroHolder:setContentSize(heroHolderSize.width * 1.2, heroHolderSize.height * 1.4)
    end
end

function MissionStageItemNode:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTERLIST_GET, self._onFreshData, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_HIDE_HERO, self._hideHero, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_CLEAR_BUBBLE, self._clearBubble, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_SHOW_CHALLENGE_PANEL, self.onShowChallengePanel, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_STAGE_INDEX_CHANGE, self._onSelectedIndexChange, self)

    self._heroHolder:setVisible(true)
    self._boxCon:setVisible(true)
    self._stars:setVisible(true)
end

function MissionStageItemNode:onExit() 
    MissionStageItemNode.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)
end

---设置显示
---@stageData 关卡数据
---@missionType 关卡类型
---@progress 当前的进度。
---@是否要显示星数变化
function MissionStageItemNode:setStageData(stageData, missionType, progress, isNeedShowStarChange)
    assert(type(stageData) == "table", "invalide stageData " .. tostring(stageData))
    assert(type(missionType) == "number", "invalide missionType " .. tostring(missionType))

    self._stageData = stageData--ChapterStageUnit
    self._missionType = missionType
    ---设置宝箱的显示
    if self._stageData:getCfgInfo().box_id ~= 0 then
        self:_addBox()
    end
    self:_iniView(progress)

    if isNeedShowStarChange then
         self:_updateStarShow(stageData:getStar())
    end
    --701
end

function MissionStageItemNode:_initUI()
    MissionStageItemNode.super._initUI(self)

    ---添加宝箱位置
    local boxPos = {x = 90, y = -20}
    for i = 1, #self._mapData do
        local mapItem = self._mapData[i]
        if mapItem.isBox == "1" then
            boxPos.x = mapItem.x + 90
            boxPos.y = mapItem.y - 20
        end
    end

    --
    self._stars = display.newNode()
    self._heroHolder:addChild(self._stars, MissionStageItemNode.STARINDEX)
    self._stars:setPosition(MissionStageHeroLayout.HEROWIDTH / 2 + MissionStageItemNode.HERO_UI_X_OFFSET, MissionStageHeroLayout.HEROHEIGHT + self._heroUIOffset)


    --
    self._boxCon = ccui.Layout:create()
    self:addChild(self._boxCon)
    self._boxCon:setAnchorPoint(0.5, 0)
    self._boxCon:setPosition(boxPos.x, boxPos.y)
    self._boxCon:enableNodeEvents()
    self._boxCon:setTouchEnabled(false)
    self._boxCon:setSwallowTouches(false)
    self._boxCon:setContentSize(cc.size(MissionStageItemNode.BOXWIDTH,MissionStageItemNode.BOXHEIGHT))

    ---点击开始时候的回调
    self._heroHolder:setOnTouchBeginCallBack(function ()
        if not self._heroHolder:getLocked() then
            self._hero:setScale(self._heroTouchScale)
        end
    end)

    ---点击结束的时候回调
    self._heroHolder:setOnTouchEndCallBack(function ()
        if not self._heroHolder:getLocked() then
            self._hero:setScale(self._heroScale)
        end
    end)

    ---设置在可以战斗的状态下调用
    self._heroHolder:setOnHeroSelectCallBack(function ()
        self:onShowChallengePanel(self._index)
    end)

    ---设置锁定状态下的点击调用
    self._heroHolder:setLockedSelectCallBack(function ()
        self:_showBubble()
    end)
end

---显示挑战面板
function MissionStageItemNode:onShowChallengePanel(toIndex)  
    print2("_onShowChallengePanel : "..tostring(toIndex),debug.traceback("", 2)) 
    if self._index ~= toIndex then return end

    --噩梦副本的条件判断
    if self._stageData:getCfgInfo().type == ChapterConfigConst.NIGHTMARE_CHAPTER then
        ---获取噩梦章节数据
        local nightmareChapterData = G_Me.allChapterData:getNightmareChapterData()
        if nightmareChapterData:getCdTime() > 0 then
            G_Popup.tip("请等待冷却时间结束！")
            return
        end
    end

    local MissionChallengePopupLayout = require("app.scenes.missionnew.missionStage.MissionChallengePopupLayout")
    if not MissionChallengePopupLayout.HAS_INSTANCE then
        --G_Popup.newPopupWithTouchEnd(
        G_Popup.newPopup(
            function ()
            local popup = MissionChallengePopupLayout.new(self._guideHand ~= nil)
            popup:setupInfo(self._stageData, self._index)
            return popup, 
            function(event)
                if event == G_Popup.EVENT_POPUP_FINISH then
                    if self._stageData == nil then return end
                     -- 新关卡才发送新手引导
                    if self._stageData:getStar() == 0 then
                        --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
                    end
                end
            end
        end)
    end

    print2("_onShowChallengePanel")
    -- 新手引导 下一步
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,101)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1401)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,403)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,603)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1003)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1303)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1754)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1776)
    --local GuideStepHelper = import("app.scenes.guide.GuideStepHelper")
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,GuideStepHelper.STEP_PAUSE)
end

function MissionStageItemNode:_hideHero()
    self._heroHolder:setVisible(false)
    self._boxCon:setVisible(false)
    self._stars:setVisible(false)
end

function MissionStageItemNode:_onFreshData()
    if self._stageData ~= nil then
        self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
    end
end

--1 左边 2 右边
function MissionStageItemNode:posIsleft( value )
    self._posIsleft = value
end

function MissionStageItemNode:_showBubble()
    if self._bubble == nil then
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_CLEAR_BUBBLE) ---清除其他界面的bubble
        local heroPosX, heroPosY = self._heroHolder:getPosition()
        local heroOnTheLeft = self._posIsleft == nil and true or self._posIsleft
        --local usingBubbleType = self._isActive and self._stageData:getBubbleID() or MissionStageItemNode.BUBBLE_TYPE
        self._bubble = MissionBubblePopNode.new(self._stageData:getTalk(), heroOnTheLeft, function ()
            if not self._isActive then ---正在攻打的情况下，气泡不消失
                self._heroHolder:removeChild(self._bubble)
                self._bubble = nil
            end
        end)
        self._heroHolder:addChild(self._bubble)
        self._bubble:setPosition(50, 100 + self._heroUIOffset)
    else
        self._bubble:updateWords()
    end
end

function MissionStageItemNode:_clearBubble()
    if self._bubble ~= nil and not self._isActive then
        self._heroHolder:removeChild(self._bubble)
        self._bubble = nil
    end
end

---初始化显示
function MissionStageItemNode:_iniView(progress)
    self:_showHero()
    self:_freshView(progress)
end

----更新关卡的显示
function MissionStageItemNode:_freshView(progress)
    --是否正在攻打状态
    self._isActive = (self._index == 1 and progress == 0) or (self._index ~= 1 and progress + 1 == self._index)
    self:_updateActiveShow()

    if self._isActive or self._index <= progress then --可以挑战的，显示怪物的名字
        self:_showName()
        self:_showStars()
        self:setLocked(false)
        self._isLocked = false
    else
        if self._heroName ~= nil then
            self._heroName:removeFromParent()
            self._heroName = nil
        end

        if not self._isLocked then
            self:_set2LockState()
            self:setLocked(true)
        end

        self._isLocked = true
    end

    self:_freshGuideHandView()
end

---更新激活的状态
function MissionStageItemNode:_updateActiveShow()
    if self._isActive and self._effectNode == nil then
        self._effectNode = EffectNode.new("effect_knife")
        self._heroHolder:addChild(self._effectNode, MissionStageItemNode.BATTLE_EFFECT_INDEX)
        self._effectNode:setPosition(MissionStageHeroLayout.HEROWIDTH / 2 + MissionStageItemNode.HERO_UI_X_OFFSET, 230 + self._heroUIOffset)
        self._effectNode:play()
        self:_showBubble()
    elseif not self._isActive and self._effectNode ~= nil then
        self._heroHolder:removeChild(self._effectNode)
        self._effectNode = nil
        if self._bubble ~= nil then
            self._heroHolder:removeChild(self._bubble)
            self._bubble = nil
        end
    end
end

---更新星数的显示
function MissionStageItemNode:_updateStarShow(newStarNum)
    self._commonStar:showStar(newStarNum)
    -- self._stars:removeAllChildren()
    
    -- local effectKey = "effect_" .. newStarNum .. "star_play"
    -- self._starEffect = EffectNode.new(effectKey, function (event,frameIndex,node)
    --     if event == "finish" then
    --         print("on G_EVENTMSGID.EVENT_CHAPTER_DIE_ANIM_PLAY_OVER")
    --         uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_DIE_ANIM_PLAY_OVER, nil, false ,nil)
    --     end
    -- end)
    -- self._starEffect:addTo(self._stars):setPosition(0,0)
    -- self._starEffect:play()
end

---添加英雄显示
function MissionStageItemNode:_showHero()
    local story_stage_info = self._stageData:getCfgInfo()
    -- local res_id = G_Me.allChapterData:getPerformanceID(story_stage_info.knight_id,story_stage_info.character_id)
    
    self._hero = self:getHeroPerformace(story_stage_info.knight_id,0,0)
    self._heroHolder:addChild(self._hero)
    self._hero:setName("stage" .. self._index)
    self._hero:setPosition(MissionStageHeroLayout.HEROWIDTH / 2 + MissionStageItemNode.HERO_UI_X_OFFSET, self._heroYOffset)

    --display.newSprite("test.png"):addTo(self._heroHolder):setPosition(0,0);

    local stageId = self._stageData:getId()
    local starNum = G_Me.allChapterData:getMaxStarByStageId(stageId)
    self._commonStar = CommonStar.new(starNum,true):addTo(self._stars)
end

function MissionStageItemNode:_onSelectedIndexChange(selectedIndex)
    if self._index == selectedIndex and self._isActive then
        self:_checkActiveHanldGuide()
        -- self:_checkPlayVoice()
    elseif self._guideHand ~= nil then
        self._heroHolder:removeChild(self._guideHand)
        self._guideHand = nil
    end
end

---是否要显示手指点击的引导
function MissionStageItemNode:_checkActiveHanldGuide()
    local maxLv = tonumber(ParameterInfo.get(MissionStageItemNode.MAX_GUID_LV_PARAM_ID).content)
    local minLv = tonumber(ParameterInfo.get(MissionStageItemNode.MIN_GUID_LV_PARAM_ID).content)

    local myLv = G_Me.userData.level

    if minLv <= myLv and myLv <= maxLv and self._guideHand == nil then
        self._guideHand = EffectNode.new("effect_finger")
        self._heroHolder:addChild(self._guideHand)
        self._guideHand:play()
        self._guideHand:setPosition(50, 90 + self._heroYOffset)
    elseif self._guideHand ~= nil then
        self._heroHolder:removeChild(self._guideHand)
        self._guideHand = nil
    end
end

-- function MissionStageItemNode:_checkPlayVoice()
--     if not self._hasPlayedVoice then
--         if not G_Me.spookyData:checkShowTempBoss() then self._hero:playVoice() end
--         self._hasPlayedVoice = true
--     end
-- end

function MissionStageItemNode:_freshGuideHandView()
    if self._guideHand ~= nil and not self._isActive then
        self._heroHolder:removeChild(self._guideHand)
        self._guideHand = nil
    end
end

---显示星星
function MissionStageItemNode:_showStars()
    -- self:performWithDelay(function ()
    --     self._starEffect = EffectNode.new("effect_" .. num .. "star")
    --     self._starEffect:addTo(self._stars):setPosition(0,0)  
    -- end, 0.1)
    local num = self._stageData:getStar()
    self._commonStar:showStar(num)
end

---显示名字
function MissionStageItemNode:_showName()
    -- body
    self:performWithDelay(function ()
        local color = G_TypeConverter.quality2Color(self._stageData:getCfgInfo().quality)
        self._heroName = display.newTTFLabel({size=26,font=G_Path.getNormalFont(),text=self._stageData:getCfgInfo().name})
        self._heroHolder:addChild(self._heroName, MissionStageItemNode.NAMEINDEX)
        self._heroName:setTextColor(G_Colors.qualityColor2Color(color,true))
        self._heroName:enableOutline(G_Colors.qualityColor2OutlineColor(color), 2)
        self._heroName:setPosition(MissionStageHeroLayout.HEROWIDTH/2 + MissionStageItemNode.HERO_UI_X_OFFSET, 160 + self._heroUIOffset)
        -- self._heroName:setColor(
        --     G_ColorsScrap.getKnightNameColorOfStage(
        --         G_TypeConverter.quality2Color(self._stageData:getCfgInfo().quality)
        --         )
        --     )
    end, 0.1)
end

----显示正在攻打
function MissionStageItemNode:_showActive()
    self._effectNode=EffectNode.new("effect_knife")
    self._heroHolder:addChild(self._effectNode, MissionStageItemNode.BATTLE_EFFECT_INDEX)
    self._effectNode:setPosition(MissionStageHeroLayout.HEROWIDTH / 2 + MissionStageItemNode.HERO_UI_X_OFFSET, 230 + self._heroUIOffset)
    self._effectNode:play()
end

----设置成锁定状态
function MissionStageItemNode:_set2LockState()
    local shader =  require("app.common.ShaderUtils")
    shader.applyGrayFilter(self._heroHolder)
    self._hero:setAniTimeScale(0)
end

---设置成什么都不显示的状态
function MissionStageItemNode:set2NothingState()
    self._heroHolder:setVisible(false)
end

function MissionStageItemNode:setLocked(value)
    MissionStageItemNode.super.setLocked(self,value)
    self._stars:setVisible(not value)
end

---获取英雄显示
function MissionStageItemNode:getHeroPerformace(knight_id,star,exclusive)
    local hero =require("app.common.KnightImg").new(knight_id,star,exclusive):setScale(self._heroScale)
    hero:setCascadeColorEnabled(true)
    hero:setCascadeOpacityEnabled(true)
    return hero 
end

--添加过关宝箱
function MissionStageItemNode:_addBox()
    local stageId = self._stageData:getId()
    local dropList = G_Me.allChapterData:getBoxAwardsByStageId(stageId)
    
    self._boxCon:setTouchEnabled(true)
    self._boxCon:setSwallowTouches(false)

    --方法提取出来方便 外部调用（新手引导需要）
    self._boxCon._clickEventFun = function( ... )
        G_GuideManager:clearTipAndFinger()
        
        local popupWindow = MissionBoxAwardPopupLayout.new(function()
           G_HandlersManager.chapterHandler:sendRequestStageAward(stageId)
           --G_HandlersManager.chapterHandler:_recvStageBox2()--新手引导测试701
         end)
        local titleStr
        local boxState = self:_getBoxState() 
        popupWindow:setupData(G_LangScrap.get("mission_box_mission"), dropList, boxState, self.id)
        if boxState == ChapterConfigConst.UI_STAR_BOX_EMPTY then
            titleStr = G_LangScrap.get("mission_congratulations_2_get_reward")
        else
            titleStr = G_LangScrap.get("mission_defeat_boss_2_get", {
                boss = self._stageData:getCfgInfo().name,
                stage_index = self._index,
                chapter_index = G_Me.allChapterData:getChapterOrderById(self._stageData:getCfgInfo().chapter_id)})
        end
        popupWindow:setTips(titleStr, false, self._missionType)
        
        local popup = require("app.popup.Popup")
        popup.newPopupFromTarget(function() 
            return popupWindow, function(event)
                if event == G_Popup.EVENT_POPUP_FINISH then
                    -- uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,701)
                    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1101)
                end
            end
        end, self._boxCon, true,false)

        --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,701)
    end

    self._boxCon:addClickEventListenerEx(function ()
        self._boxCon._clickEventFun()
    end,nil,nil,nil,20)
   
   self:freshBox(self._stageData:getId())
   self._boxCon:setName("box" .. self._index)
   print2("self._boxCon:setName","box" .. self._index)
end

--刷新宝箱
function MissionStageItemNode:freshBox(stageId)
    if (self._stageData == nil or self._stageData:getCfgInfo().box_id == 0) or
       self._stageData:getId() ~= stageId  then return end

    --断线重连情况下刷新。
    self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
    local boxState = self:_getBoxState()
    self._boxCon:removeAllChildren(true)
    self._boxEffect = nil
    local boxConSize = self._boxCon:getContentSize()
    
    
    if boxState == ChapterConfigConst.UI_STAR_BOX_OPEN then
         --特效播放方法
        local function createEffectNode(effectName, eventHandler, autoRelease)
            local effectNode = EffectNode.new(effectName, eventHandler)
            effectNode:setAutoRelease(autoRelease)
            effectNode:play()
            return effectNode
        end

        self._boxEffect = EffectMovingNode.new("moving_bxtd",
            function(effect)
                if effect == "effect_bxtd_1_1" or effect == "effect_bxtd_1_2" then
                    return createEffectNode("effect_bxtd_1")
                elseif effect == "effect_bxtd_2_1" or effect == "effect_bxtd_2_2" or effect == "effect_bxtd_2_3" or effect == "effect_bxtd_2_4" or effect == "effect_bxtd_2_5" then
                    return createEffectNode("effect_bxtd_2")
                elseif effect == "card" then
                    local boxImg = display.newSprite(G_Url:getUI_icon("mission_box_".. (boxState == ChapterConfigConst.UI_STAR_BOX_EMPTY and "o" or "c")))
                    boxImg:setAnchorPoint(0.5, 0.5)
                    return boxImg
                end
            end
        )
        self._boxEffect:play()
        self._boxCon:addChild(self._boxEffect)
        self._boxEffect:setPosition(boxConSize.width/2 , boxConSize.height)
    else
        local boxImg = display.newSprite(G_Url:getUI_icon("mission_box_".. (boxState == ChapterConfigConst.UI_STAR_BOX_EMPTY and "o" or "c")))
        self._boxCon:addChild(boxImg)
        boxImg:setPosition(boxConSize.width/2 , boxConSize.height/2)
    end
end

---获取宝箱状态
function MissionStageItemNode:_getBoxState()
    local state

    if not self._stageData:isFinished() then
        state =  ChapterConfigConst.UI_STAR_BOX_CLOSE
    else
        -- if self._stageData:getReceiveBox() and false then
        if self._stageData:getReceiveBox() then
            state =  ChapterConfigConst.UI_STAR_BOX_EMPTY
        else
            state = ChapterConfigConst.UI_STAR_BOX_OPEN
        end
    end
    return state
end

return MissionStageItemNode