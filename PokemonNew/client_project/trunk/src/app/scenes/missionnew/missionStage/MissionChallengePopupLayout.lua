
local MissionStageChallengeBaseLayer = require "app.scenes.missionnew.stageLayout.MissionStageChallengeBaseLayer"
local MissionChallengePopupLayout = class("MissionChallengePopupLayout", MissionStageChallengeBaseLayer)

local ChapterConfigConst = require("app.const.ChapterConfigConst")
local WidgetTools=require("app.common.WidgetTools")
local ShaderUtils =  require("app.common.ShaderUtils")
local Url = require "app.setting.Url"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local FunctionConst = require "app.const.FunctionConst"
local CommonBuyCount = require "app.common.CommonBuyCount"
local CommonBubble = require "app.common.CommonBubble"
local EffectNode = require "app.effect.EffectNode"
local MissionChallengeDiffNode = require("app.scenes.missionnew.stageLayout.MissionChallengeDiffNode")
local ParameterInfo = require "app.cfg.parameter_info"
local function_cost_info = require "app.cfg.function_cost_info"
local Responder = require("app.responder.Responder")

local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")

----最多的扫荡次数
MissionChallengePopupLayout.MAXATTACKTIME = 10
MissionChallengePopupLayout.HEROSCALE = 0.8

MissionChallengePopupLayout.HAS_INSTANCE = false ---标记是否已经有一个弹出窗口的实例。

---========================
---关卡挑战弹窗
---========================
--@showGuideHand 是否显示引导的手指
function MissionChallengePopupLayout:ctor(showGuideHand)
    MissionChallengePopupLayout.super.ctor(self)
    self._stageIndex = nil
    self._inforData = nil
    self._stageData = nil
    --self._firstDownFunc = nil
    self._firstDownData = nil
    self._holderSize = 0
    self._hasSendExecute = false
    self._showGuideHand = showGuideHand
    self._formationSelected = 0--默认主阵容

    self._emenyInfo = nil--敌人的信息
    self._cost = 0--ParameterInfo.get(198)

    self._useTempFormation = false--是否使用临时阵容

    self._missionChallengeDiffNodes = nil--不同难度的容器

    self._csb_width = 0
    self._csb_height = 0

    self._nowLevel = 0--当前的难度
    self._maxStar = 0--最大星数

    self._sweepNum = 0--当前可扫荡次数

    self.setPositionY = function(_,yy)
        print("此处拦截  不然会被公用弹框向下偏移。")
    end

end

function MissionChallengePopupLayout:onEnter()
    MissionChallengePopupLayout.HAS_INSTANCE = true
    if self._stageData ~= nil then -- 场景转换，再返回时刷新
        self:_initUI()
    end
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_GET_FIRST_DOWN_DATA, self._onShowFirstDown, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_RESET_STAGE, self._onRestCallBack, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECV_ROLE_INFO, self._onVitChange, self)
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_GET_NEW_FIRST_DOWN, self._onNewFirstDown, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_CLOSE_CHALLENGE_PANEL, self._onRemove, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_FORMATION_SELECTED,self._onFormationSelected,self)--

    if G_Me.allChapterData:isExpired() then
        G_Me.allChapterData:setReset()
    end
end

-- 更新界面
function MissionChallengePopupLayout:_updateEnemyView(  )
    local EmenyFormationInfo = require("app.scenes.team.lineup.data.EmenyFormationInfo")
    local knight_info_ids,orders,powers = G_Me.allChapterData:getEnemyTeamData(self._inforData.id)
    self._emenyInfo = EmenyFormationInfo.new(knight_info_ids,orders,power)

    self._simpleFormationList = SimpleFormationList.new(SimpleFormationList.TYPE_ENEMY,nil,nil,SimpleFormationList.ORDER_ICON_CIRCLE)
    --self._simpleFormationList:setGapOff(-2)
    self._simpleFormationList:setGapOff(18)
    self._simpleFormationList:enableCircleBgIconOffX()
   -- self._simpleFormationList:setGapW(46,17)
    self._simpleFormationList:update(knight_info_ids,orders)
    self._simpleFormationList:setPosition(
            - SimpleFormationList.GAP_W,
            SimpleFormationList.GAP_H/2
        )
    self._simpleFormationList:addTo(self._enemyListCon)
    self._enemyListCon:setScale(0.7)
    
    -- if self._bitmapFontLabel_power then
    --     self._bitmapFontLabel_power:setString(powers[1])
    -- end
    if self._enemy_powerNode then
        self._enemy_powerNode:updateLabel("Text_zhanli", tostring(powers[1]))
    end
end

function MissionChallengePopupLayout:onExit()
    MissionChallengePopupLayout.super.onExit(self)
    
    uf_eventManager:removeListenerWithTarget(self)
    self:removeChild(self._content)
    self._content = nil
    --self._firstDownFunc = nil
    MissionChallengePopupLayout.HAS_INSTANCE = false
    self:removeChild(self._hero)
    self._missionChallengeDiffNodes = nil
    self._showGuideHand = nil
    self._hero = nil
end

function MissionChallengePopupLayout:_initUI()

    ---如果因为特殊情况跳转到其他场景，之后切换回来。则需要重新刷新关卡数据
    if self._stageData ~= nil then
        self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
    end

    MissionChallengePopupLayout.HAS_INSTANCE = true

    if self._inforData.type == ChapterConfigConst.NORMAL_CHAPTER then--主线
        self:_initNormalUI()
    elseif self._inforData.type == ChapterConfigConst.ELITE_CHAPTER then--精英
        self:_initEliteUI()
    elseif self._inforData.type == ChapterConfigConst.NIGHTMARE_CHAPTER then--噩梦
        self:_initNightmareUI()
    end

    -- --showGuideHand 是否显示引导的手指
    -- if self._showGuideHand then
    --     local guideHand = EffectNode.new("effect_finger")
    --     local midButton = self:getSubNodeByName("Button_challenge_first_time")
    --     midButton:getParent():addChild(guideHand)
    --     guideHand:setPosition(midButton:getPosition())
    --     guideHand:play()
    -- end

    -- self:_onUpdateFirstDown()
end

function MissionChallengePopupLayout:_initCommonUI( ... )
    self._holder = self._content:getSubNodeByName("Panel_holder")
    self._holder:enableNodeEvents()
    self._holder:setTouchEnabled(true)
    self._holderSize = self._holder:getContentSize()
    self:setTouchSwallowEnabled(false)

    self._csb_width = self._content:getContentSize().width
    self._csb_height = self._content:getContentSize().height

    -- self._holder:setContentSize(self._csb_width,self._csb_height)
    -- ccui.Helper:doLayout(self._holder)
    -- self:setPosition(display.cx-self._csb_width/2,display.cy-self._csb_height/2 - 100)

    self._enemyListCon = self:getSubNodeByName("Node_enemyList")
    --self._bitmapFontLabel_power = self:getSubNodeByName("BitmapFontLabel_power")
    self._self_powerNode = self:getSubNodeByName("Node_zhanli_my")
    self._enemy_powerNode = self:getSubNodeByName("Node_zhanli_enemy")

    if self._self_powerNode then
        self._self_powerNode:updateLabel("Text_zhanli", tostring(G_Me.userData.power))
    end

    self:_setFormation()
    ----设置英雄的表现
    self:_setupHeroData()
    self:_updateStar()
    self:_showDrops()

    self:_updateResAward()

    --self:_updateShowButtons()

    --设置敌人表现
    self:_updateEnemyView()
    --关闭
    self:updateButton("Button_close", function ()
        self:_onRemove()
    end)
end

function MissionChallengePopupLayout:_setFormation( ... )
    --布阵
    self:updateButton("Button_formation", 
        {
        callback = function ()

            G_Popup.newPopup(function()
                local commonVsFormation = require("app.scenes.team.lineup.CommonVsFormation").new(
                    SimpleFormationList.TYPE_ENEMY,
                    G_Me.allChapterData:getCurFunID(),
                    self._emenyInfo,
                    0,
                    function( temp )
                        self.useTempFormation = temp--是否使用临时阵容
                    end
                )
                commonVsFormation:setBtnText("确 定")
                return commonVsFormation
            end)
        end
    })
    --布阵显示设置
    -- self:getSubNodeByName("Button_formation"):updateLabel("Text_title", {
    --     outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
    --     text = G_LangScrap.get("common_icon_formation")
    -- })
end

function MissionChallengePopupLayout:_initNormalUI( ... )
    if self._content == nil then
        self._content = cc.CSLoader:createNode(Url:getCSB("challengePopup/ChallengeNormalPopup", "missionnew"))
        self:addChild(self._content)
        self:_initCommonUI()
    end

    --扫荡
    self._btn_saodang_or_re = self:getSubNodeByName("Button_saodang_or_re")
    self._btn_title = self._btn_saodang_or_re:getChildByName("button_title")
    self._diff_con = self._holder:getChildByName("Node_diff_con")
    UpdateButtonHelper.reviseButton(self._btn_saodang_or_re,{isBig = true,color = UpdateButtonHelper.COLOR_BLUE})


    local knight_info_ids,orders,powers = G_Me.allChapterData:getEnemyTeamData(self._inforData.id)
    --不同难度的初始化
    if self._missionChallengeDiffNodes == nil then
        self._missionChallengeDiffNodes = {}
        for i=1,self._nowLevel do
            local missionChallengeDiffNode = MissionChallengeDiffNode.new(self._stageData)
            missionChallengeDiffNode:setName("MissionChallengeDiffNode"..i)
            table.insert(self._missionChallengeDiffNodes,missionChallengeDiffNode)
            missionChallengeDiffNode:setLevel(i)
            missionChallengeDiffNode:setPower(powers[i])
            -- missionChallengeDiffNode:setMoney(G_Me.userData:getPveMoney())

            -- local vitCost = G_Me.allChapterData:getVitcostByChapterType(self._inforData.type)
            -- missionChallengeDiffNode:setExp(G_Me.userData:getPveExp(vitCost))

            missionChallengeDiffNode:setOneTimeCallBack(handler(self, self._onClickChallenge))
            
            self._diff_con:addChild(missionChallengeDiffNode)
            --missionChallengeDiffNode:setPosition(0, -90*(i-1))
            missionChallengeDiffNode:setPosition(0, -9 -63*(i-1))
        end
    end
    for i=1,#self._missionChallengeDiffNodes do
        self._missionChallengeDiffNodes[i]:render()
    end

    self:_updateExcuteCount()

    self:updateLabel("Label_need_power", tostring(self._cost))
    self:updateLabel("Label_cost_vit", G_Lang.get("mission_stamina_value"))

    --扫荡重置
    local starCount = self._stageData:getStar()
    local totalTime = self:_getBattleTime(ChapterConfigConst.NORMAL_CHAPTER)
    if totalTime == 0 then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString("重 置")
        self._btn_saodang_or_re:addClickEventListener(function( ... )
            self:_onReset(ChapterConfigConst.NORMAL_CHAPTER)
        end)
    elseif starCount == self._maxStar then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString(G_LangScrap.get("mission_challenge_some_time", {num = totalTime}))
        self._btn_saodang_or_re:addClickEventListener(handler(self, self._onSomeTimeNormal))
    elseif starCount > 0 and starCount < self._maxStar then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString(G_LangScrap.get("mission_challenge_some_time", {num = totalTime}))
        self._btn_saodang_or_re:addClickEventListener(function( ... )
            G_Responder.funcIsOpened(4011,function( ... )
                self:_onSomeTimeNormal()
            end)
        end)
    else
        self._btn_saodang_or_re:setVisible(false)
    end

    --刷新重置或者扫荡按钮
    local bottomHeightAdd = 40 --self._btn_saodang_or_re:isVisible() and 40 or 0--如果底部需要显示按钮则需要增加高度
    local holder_h = self._csb_height + 90*self._nowLevel + bottomHeightAdd + 18
    self._holder:setContentSize(
        self._csb_width,
        holder_h
    )
    ccui.Helper:doLayout(self._holder)
    self:setPosition(display.cx-self._csb_width/2,display.cy-holder_h/2)

    --ui适配调整
    local img_bg1 = self._content:getSubNodeByName("Image_bg01")
    local img_bg2 = self._content:getSubNodeByName("Image_bg02")
    local size1 = img_bg1:getContentSize()
    local size2 = img_bg2:getContentSize()
    if self._btn_saodang_or_re:isVisible() then
        img_bg1:setContentSize(size1.width,613)
        img_bg2:setContentSize(size2.width,321)
    else
        img_bg1:setContentSize(size1.width,593)
        img_bg2:setContentSize(size2.width,364)
    end

end

function MissionChallengePopupLayout:_initEliteUI( ... )
    if self._content == nil then
        self._content = cc.CSLoader:createNode(Url:getCSB("challengePopup/ChallengeElitePopup", "missionnew"))
        self:addChild(self._content)
        self:_initCommonUI()
    end

    --扫荡
    self._btn_saodang_or_re = self:getSubNodeByName("Button_saodang_or_re")
    self._btn_title = self._btn_saodang_or_re:getChildByName("button_title")
    UpdateButtonHelper.reviseButton(self._btn_saodang_or_re,{
        isBig = true,
        color = UpdateButtonHelper.COLOR_BLUE,
        noChange = true})
    
    --扫荡重置
    local starCount = self._stageData:getStar()
    local totalTime = self:_getBattleTime(ChapterConfigConst.ELITE_CHAPTER)
    if totalTime == 0 then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString("重 置")
        self._btn_saodang_or_re:addClickEventListener(function( ... )
            self:_onReset(ChapterConfigConst.ELITE_CHAPTER)
        end)
    elseif starCount == self._maxStar then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString(G_LangScrap.get("mission_challenge_some_time", {num = totalTime}))
        self._btn_saodang_or_re:addClickEventListener(handler(self, self._onSomeTimeElite))
    elseif starCount > 0 and starCount < self._maxStar then
        self._btn_saodang_or_re:setVisible(true)
        self._btn_title:setString(G_LangScrap.get("mission_challenge_some_time", {num = totalTime}))
        self._btn_saodang_or_re:addClickEventListener(function( ... )
            G_Responder.funcIsOpened(4011,function( ... )
                self:_onSomeTimeElite()
            end)
        end)
    else
        self._btn_saodang_or_re:setVisible(false)
    end

    self:updateLabel("Label_need_power", tostring(self._cost))
    self:updateLabel("Label_cost_vit", G_Lang.get("mission_vigor_value"))

    --挑战
    self._btn_challenge_once = self:getSubNodeByName("Button_challenge_once")
    self._btn_challenge_once2 = self:getSubNodeByName("Button_challenge_once2")
    UpdateButtonHelper.reviseButton(self._btn_challenge_once,{
        isBig = true,
        noChange = true})
    UpdateButtonHelper.reviseButton(self._btn_challenge_once2,{
        isBig = true,
        noChange = true})

    self._btn_challenge_once:setVisible(self._btn_saodang_or_re:isVisible())
    self._btn_challenge_once2:setVisible(not self._btn_saodang_or_re:isVisible())

    self._btn_challenge_once:addClickEventListener(handler(self, self._onClickChallenge))
    self._btn_challenge_once2:addClickEventListener(handler(self, self._onClickChallenge))
    
    self:_updateExcuteCount()
    self:_updateResAward()
    local holderH = 800
    self._holder:setContentSize(
        self._csb_width,
        holderH
    )
    ccui.Helper:doLayout(self._holder)
    self:setPosition(display.cx-self._csb_width/2,display.cy-holderH/2)

    local img_bg1 = self._content:getSubNodeByName("Image_bg01")
    local img_bg2 = self._content:getSubNodeByName("Image_bg02")
    img_bg1:setContentSize(img_bg1:getContentSize().width,613)
    img_bg2:setContentSize(img_bg2:getContentSize().width,264)
end

function MissionChallengePopupLayout:_initNightmareUI( ... )
    if self._content == nil then
        self._content = cc.CSLoader:createNode(Url:getCSB("challengePopup/ChallengeNightmarePopup", "missionnew"))
        self:addChild(self._content)
        self:_initCommonUI()
    end

    --挑战
    self._btn_challenge_once = self:getSubNodeByName("Button_challenge_once")
    self._btn_challenge_once:addClickEventListener(handler(self, self._onClickChallenge))
    UpdateButtonHelper.reviseButton(self._btn_challenge_once,{
        isBig = true,
        noChange = true})

    -- self:_updateResAward()
    local holderH = 800
    self._holder:setContentSize(
        self._csb_width,
        holderH
    )
    ccui.Helper:doLayout(self._holder)
    self:setPosition(display.cx-self._csb_width/2,display.cy-holderH/2)

    local img_bg1 = self._content:getSubNodeByName("Image_bg01")
    local img_bg2 = self._content:getSubNodeByName("Image_bg02")
    img_bg1:setContentSize(img_bg1:getContentSize().width,613)
    img_bg2:setContentSize(img_bg2:getContentSize().width,264)
end

---设置关卡挑战数据
---@stageData 关卡信息
---@stageIndex 关卡下标
function MissionChallengePopupLayout:setupInfo(stageData, stageIndex)
    self._stageIndex = stageIndex
    self._stageData = stageData
    self._inforData = self._stageData:getCfgInfo()
    self._cost = G_Me.allChapterData:getVitcostByChapterType(self._inforData.type)

    self._nowLevel = 0
    print2("self._inforData.type",self._inforData.type)
    if self._inforData.type == ChapterConfigConst.NORMAL_CHAPTER then--主线
        for i=1,3 do
            if self._inforData["monster_team_id_" .. i] ~= 0 then
                self._nowLevel = self._nowLevel + 1
            end
            print2("monster_team_id_"..i..":",self._nowLevel,self._inforData["monster_team_id_" .. i])
        end
        self._maxStar = self._nowLevel
    else
        self._maxStar = 3
    end
    
    self:_initUI()
end

----设置英雄的表现
function MissionChallengePopupLayout:_setupHeroData()
    -- local bossName = self:getSubNodeByName("Label_boss_name")
    -- bossName:setString(self._inforData.name)
    self:updateLabel("Label_boss_name", {
        text = self._inforData.name,
        textColor = G_Colors.getColor(1),
        })
    --self:updateLabel("Label_award_title", G_LangScrap.get("mission_award_drops"))
    self:updateLabel("Label_award_drops_title", G_LangScrap.get("mission_award_drops_items"))
    print2("self._inforData.talk",self._inforData.talk)
    self:_showHero(
        self._inforData.knight_id,
        0,
        0,
        self:getSubNodeByName("Panel_hero_avatar"),
        MissionChallengePopupLayout.HEROSCALE,
        self._inforData.type == ChapterConfigConst.BOSS,
        --CommonBubble.getWordsByType(self._inforData.id)
        self._inforData.talk
    )
end

-- -----收到首杀信息后返回调用
-- function MissionChallengePopupLayout:_onShowFirstDown()
--     if self._firstDownFunc ~= nil then
--         self._firstDownFunc()
--         self._firstDownFunc = nil
--     end
-- end

--重置回调
function MissionChallengePopupLayout:_onRestCallBack()
    G_Popup.tip(G_LangScrap.get("mission_reset_success"))
    --self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
    self:_initUI()--刷新 主要是刷新按钮的
    --self:_updateExcuteCount()
end

--体力值变化回调
function MissionChallengePopupLayout:_onVitChange()
    self:_initUI()--刷新 主要是刷新按钮的
end

--设置选择的队伍id
function MissionChallengePopupLayout:_onFormationSelected( value )
    self._formationSelected = value.id
end

-- --更新可以显示的按钮
-- function MissionChallengePopupLayout:_updateShowButtons()
    
-- end

--展示商品
function MissionChallengePopupLayout:_showDrops()
    local dropList = self:getSubNodeByName("ScrollView_dropList")
    dropList:setScrollBarEnabled(false)
    dropList:setBounceEnabled(true)
    --dropList:setGravity(ccui.ListViewGravity.bottom)
    local Helper = require("app.common.UpdateNodeHelper")
    local Converter = require("app.common.TypeConverter")
    local item
    local data
    local outframe 
    local size
    local putIndex = 0
    local dropItems = G_Me.allChapterData:getDropsOfStage(self._stageData:getId())
    local blank = 16
    for i = 1,#dropItems do
        item = cc.CSLoader:createNode(Url:getCSB("MissionDropsItem", "missionnew"))
        data = dropItems[i]
        data.nameVisible = false
        data.sizeVisible = false
        data.levelVisible = false
        data.disableTouch = false
        data.scale = 0.8
        data.needVisible = G_Me.equipData:isUpRankMaterialNeed(data.type,data.value)
        Helper.updateCommonIconItemNode(item:getSubNodeByName("content"), Converter.convert(data))
        --outframe = item:getSubNodeByName("holder")
        --item:removeChild(outframe, false)
        --outframe:setContentSize(140*0.64,140*0.64)
        --dropList:insertCustomItem(outframe)
        dropList:addChild(item)
        item:setPosition(putIndex*((blank+110*0.8)), 3)
        putIndex = putIndex + 1
    end
    dropList:setInnerContainerSize(cc.size((putIndex)*(110*0.8) + blank*(putIndex),dropList:getContentSize().height))

end

---更新星数
function MissionChallengePopupLayout:_updateStar()
    local starCount = self._stageData:getStar()
    local star
    for i = 1, 3 do
        star = self:getSubNodeByName("Sprite_star_n_" .. i)
        star:setCascadeColorEnabled(true)
        if i > starCount then
            star:setTexture(G_Url:getUI_common("other/star2"))
        else
            star:setTexture(G_Url:getUI_common("other/star"))
        end
        star:setVisible(i <= self._maxStar)
    end
end

---挑战次数更新
function MissionChallengePopupLayout:_updateExcuteCount()
     local timeLast = self._inforData.challenge_num - self._stageData:getExcuteCount()
     --self:getSubNodeByName("Button_challenge_some_time"):setVisible(timeLast ~= 0)
     --self:getSubNodeByName("Button_challenge_reset"):setVisible(timeLast == 0)
     self:updateLabel("Label_challenge_title", {
        text = G_LangScrap.get("mission_chanllenge_num")
    })
    self:updateLabel("Label_challenge_num", tostring(timeLast) .. "/" .. tostring(self._inforData.challenge_num))
end

function MissionChallengePopupLayout:_updateResAward( ... )
    self:updateLabel("Label_award_money", {
        text = G_Me.userData:getPveMoney()
    })
    --if self._inforData.type == ChapterConfigConst.NORMAL_CHAPTER then
        local vitCost = G_Me.allChapterData:getVitcostByChapterType(self._inforData.type)
        local exp = G_Me.userData:getPveExp(vitCost)
        
        self:getSubNodeByName("Node_exp"):setVisible(exp > 0)
        self:updateLabel("Label_award_exp", {
            text = exp
        })
    --else
        --self:getSubNodeByName("Node_exp"):setVisible(false)
    --end
    
end

---多次挑战点击之后调用
function MissionChallengePopupLayout:_onSomeTimeNormal()
    --检查扫荡是否开启
    if self._inforData.type == ChapterConfigConst.NORMAL_CHAPTER then
        local isOpen= G_Responder.funcIsOpened(FunctionConst.FUNC_MISSION_STAGE_FAST_EXECUTE,function ()end)
        if not isOpen then
            return
        end
    end

    local totalTime = self:_getBattleTime(ChapterConfigConst.NORMAL_CHAPTER)
    print2("MissionChallengePopupLayout:_onSomeTime")
    local Responder = require("app.responder.Responder")
    Responder.enoughVit(totalTime * self._cost, function () 
        --if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) and not G_Responder.isPackFull(TypeConverter.TYPE_EQUIPMENT) then
            local dataId = self._inforData.id
            uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_POP_FASET_EXCUTE, nil, false, {
                id = dataId,
                times = totalTime,
                index =  self._stageIndex,
                chapterType = ChapterConfigConst.NORMAL_CHAPTER,
                maxStar = self._maxStar
            })
            self:removeFromParent(true)
        --end
    end,true)
end

---多次挑战点击之后调用
function MissionChallengePopupLayout:_onSomeTimeElite()
    local totalTime = self:_getBattleTime(ChapterConfigConst.ELITE_CHAPTER)
    local Responder = require("app.responder.Responder")
    Responder.enoughSpirit(totalTime * self._cost, function () 
        --if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) and not G_Responder.isPackFull(TypeConverter.TYPE_EQUIPMENT) then
            local dataId = self._inforData.id
            uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_POP_FASET_EXCUTE, nil, false, {
                id = dataId,
                times = totalTime,
                index =  self._stageIndex,
                chapterType = ChapterConfigConst.ELITE_CHAPTER,
                maxStar = self._maxStar
            })
            self:removeFromParent(true)
        --end
    end,true)
end

----弹出提示
function MissionChallengePopupLayout:_popTips(key)
     local Popup = require("app.popup.Popup")
     Popup.tip(G_LangScrap.get(key))
     return false
end

---单次点击之后调用
function MissionChallengePopupLayout:_onClickChallenge(level)
    local totalTime = 0
    local enoughFun = nil
    if  self._inforData.type ~= ChapterConfigConst.NIGHTMARE_CHAPTER then--噩梦副本不需要次数 then
        --todo
        if self._inforData.type == ChapterConfigConst.ELITE_CHAPTER then
            totalTime = self:_getBattleTime(ChapterConfigConst.ELITE_CHAPTER)
            enoughFun = G_Responder.enoughSpirit
        else
            totalTime = self:_getBattleTime(ChapterConfigConst.NORMAL_CHAPTER)
            enoughFun = G_Responder.enoughVit
        end
        if totalTime == 0 then   --如果副本次数为0 提示重置
            self:_onReset(self._inforData.type)
            return
        end
    else
        enoughFun = function( _,callBack )
            callBack()
        end
    end

    if not self._hasSendExecute then
        ---体力是否足够
        enoughFun(self._cost, function ()
            ---检查背包的武将是否满了  策划说不需要了
            -- if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                 ---挑战BOSS之前保存当前挑战数据
                G_Me.allChapterData:setRecordStageStatus(self._inforData.id)

                -- 顶部条暂停更新
                G_widgets:getTopBar():pauseWidget()

                -- self._inforData == story_stage_info
                -- if G_BossStage[self._inforData.id] then
                --     uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_PLAY_QTE, nil, false, self._inforData)
                -- else
                if self._inforData.type == ChapterConfigConst.NORMAL_CHAPTER then--主线
                    G_HandlersManager.chapterHandler:sendExcuteStage(self._inforData.id,level,self._useTempFormation)
                    self._hasSendExecute = true
                elseif self._inforData.type == ChapterConfigConst.ELITE_CHAPTER then--精英
                    G_HandlersManager.chapterHandler:sendEliteExcuteStage(self._inforData.id,self._useTempFormation)
                    self._hasSendExecute = true
                elseif self._inforData.type == ChapterConfigConst.NIGHTMARE_CHAPTER then--噩梦
                    local nightmareChapterData = G_Me.allChapterData:getNightmareChapterData()
                    if nightmareChapterData:getLeftTiems() <= 0 then
                        --G_Popup.tip("今日剩余次数不足！")
                        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_NIGHTMARE_TIMESOVER, nil, false)
                        return
                    else
                        G_HandlersManager.chapterHandler:sendNightmareExcuteStage(self._inforData.id,self._useTempFormation)
                        self._hasSendExecute = true
                    end
                end
                -- end
            -- else--背包满了
            --     G_Popup.tip(G_Lang.get("mission_knight_over_tips"))
            -- end
        end,true)

    else
        buglyPrint("self._sendExcuteStage:true ", 3, "MissionChallengePopupLayout")
    end
end

---重置副本
function MissionChallengePopupLayout:_onReset(chapterType)
    local mainFuncId = G_VipConst.FUNC_TYPE_MAIN_LINE
    dump("MissionChallengePopupLayout:_onReset(chapterType) -chapterType: "..chapterType)
    dump(debug.traceback("描述:", 2))
    if chapterType == ChapterConfigConst.NORMAL_CHAPTER then
        mainFuncId = G_VipConst.FUNC_TYPE_MAIN_LINE
    elseif chapterType == ChapterConfigConst.ELITE_CHAPTER then
        mainFuncId = G_VipConst.FUNC_TYPE_ELITE_LINE
    end
    dump("MissionChallengePopupLayout:_onReset(chapterType) -mainFuncId: "..mainFuncId)
    local usedTimes = self._stageData:getResetCount()
    local isTimeOut = G_Responder.vipTimeOutCheck(mainFuncId, {
        usedTimes = usedTimes,
        tips = G_LangScrap.get("mission_reset_time_out") 
    })

    if not isTimeOut then ---当前还有重置次数
        local currentValue = G_Me.vipData:getVipTimesByFuncId(mainFuncId)
        local timeLast = currentValue - usedTimes
        local costGold = G_Me.vipData:getVipBuyTimeCost(mainFuncId, usedTimes)

        -- G_Popup.newPopup(function ()
        --     local resetPanel = require("app.scenes.missionnew.missionStage.MissionResetPopupLayout").new(self._inforData.id)
        --     resetPanel:setData(costGold, timeLast, currentValue)
        --     return resetPanel
        -- end)
       -- local vipInfo = G_Me.vipData:getVipFunctionDataByType(20506)
        --dump(vipInfo)
        --dump(vipInfo.value)
        --dump(G_Me.tombData:getBoughtSpadeCount())
       -- local leftSpade = vipInfo.value - G_Me.tombData:getBoughtSpadeCount()
        local param = {gold = costGold,curr = usedTimes,total = currentValue
            ,num = function_cost_info.get(10101).buy_add_count}
        require("app.common.ConfirmAlert").createCommonResetCount(
            --nil, 
            --G_Lang.get("tomb_add_times",{num = G_Me.tombData:getNextBoughtCost(),left = leftSpade,total = vipInfo.value}),
            function()
                Responder.enoughGold(costGold, function ()
                    G_HandlersManager.chapterHandler:sendResetStage(self._inforData.id)
                end)
                --self:removeFromParent()
            end,
            nil,
            param
        )
    end
end

-- function MissionChallengePopupLayout:_onNewFirstDown(decodeBuffer)
--     if self._inforData.id == decodeBuffer.stage_id then
--         self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
--         self:_onUpdateFirstDown()
--     end
-- end

-- function MissionChallengePopupLayout:_onUpdateFirstDown()
--     local firstClearPlayerName = self._stageData:getFirstDownPlayerName()
--     local firstClearPlayerLabel = self:getSubNodeByName("Label_player_name")
--     local firstDownButton = self:getSubNodeByName("Button_first_down")
    
--     firstClearPlayerLabel:setString(firstClearPlayerName ~= nil and firstClearPlayerName or G_LangScrap.get("mission_first_down_no_body"))
--     firstDownButton:setContentSize(firstClearPlayerLabel:getContentSize())
--     self:getSubNodeByName("Image_down_line"):setVisible(firstClearPlayerName ~= nil)
--     ccui.Helper:doLayout(self:getSubNodeByName("Button_first_down"))
-- end

-----获得可以挑战的次数
function MissionChallengePopupLayout:_getBattleTime(chapterType)
    local allNum = 0
    if chapterType == ChapterConfigConst.NORMAL_CHAPTER then
        allNum = G_Me.userData.vit
    elseif chapterType == ChapterConfigConst.ELITE_CHAPTER then
        allNum = G_Me.userData.spirit
    end
    dump(chapterType .. " : " .. allNum .. " : " .. self._cost)
    
    local maxTime = math.floor(allNum / self._cost)
    
    if maxTime == 0 or maxTime > MissionChallengePopupLayout.MAXATTACKTIME then
        maxTime = MissionChallengePopupLayout.MAXATTACKTIME     
    end

    dump(self._inforData.challenge_num .. " ：" .. self._stageData:getExcuteCount())
    local lastTime = self._inforData.challenge_num - self._stageData:getExcuteCount()
    maxTime =  maxTime >= lastTime and lastTime or maxTime
    
    return maxTime
end

function MissionChallengePopupLayout:_getShineButtons()
    local shineButtons = {}
    -- local timeLast = self._inforData.challenge_num - self._stageData:getExcuteCount()
    -- local starCount = self._stageData:getStar()

    -- if starCount >= 3 and timeLast > 0 then
    --     shineButtons[#shineButtons + 1] = self._content:getSubNodeByName("Button_challenge_some_time")
    -- else
    --     shineButtons[#shineButtons + 1] = self._content:getSubNodeByName("Button_challenge_first_time")
    --     shineButtons[#shineButtons + 1] = self._content:getSubNodeByName("Button_challenge_one_time")
    --     shineButtons[#shineButtons + 1] = self._content:getSubNodeByName("Button_challenge_reset")
    -- end

    return shineButtons
end

function MissionChallengePopupLayout:_onRemove()
    self:removeFromParent()
end

return MissionChallengePopupLayout