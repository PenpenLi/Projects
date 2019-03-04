--
-- Author: WYX
-- Date: 2018-04-26 19:49:19
--
local MissionStageChallengeBaseLayer = require "app.scenes.missionnew.stageLayout.MissionStageChallengeBaseLayer"
local MissionChallengePopupLayout = class("MissionChallengePopupLayout", MissionStageChallengeBaseLayer)

local ChapterConfigConst = require("app.const.ChapterConfigConst")
local ShaderUtils =  require("app.common.ShaderUtils")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local FunctionConst = require "app.const.FunctionConst"
local CommonBuyCount = require "app.common.CommonBuyCount"
local CommonBubble = require "app.common.CommonBubble"
local EffectNode = require "app.effect.EffectNode"
local MissionChallengeDiffNode = require("app.scenes.missionnew.stageLayout.MissionChallengeDiffNode")
local ParameterInfo = require "app.cfg.parameter_info"
local function_cost_info = require "app.cfg.function_cost_info"
local Responder = require("app.responder.Responder")

local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local FormationEnemyList = require("app.scenes.guild.mission.pop.FormationEnemyList")

MissionChallengePopupLayout.HEROSCALE = 0.8

MissionChallengePopupLayout.HAS_INSTANCE = false ---标记是否已经有一个弹出窗口的实例。

---========================
---关卡挑战弹窗
---========================
--@showGuideHand 是否显示引导的手指
function MissionChallengePopupLayout:ctor(showGuideHand)
    MissionChallengePopupLayout.super.ctor(self)
    self._stageIndex = nil
    self._cfgData = nil
    self._stageData = nil
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
end

function MissionChallengePopupLayout:onEnter()
    MissionChallengePopupLayout.HAS_INSTANCE = true
    if self._stageData ~= nil then -- 场景转换，再返回时刷新
        self:_initUI()
    end
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_FORMATION_SELECTED,self._onFormationSelected,self)--
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_MISSION_CLOSE_POP_LAY,self._onRemove,self)--
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_BUG_COUNT, self._updateExcuteCount, self)
end

-- 更新界面
function MissionChallengePopupLayout:_updateEnemyView(  )
    local EmenyFormationInfo = require("app.scenes.team.lineup.data.EmenyFormationInfo")
    local knight_info_ids,orders,powers = self._stageData:getEnemyTeamData()
    self._emenyInfo = EmenyFormationInfo.new(knight_info_ids,orders,power)

    local enemyList = FormationEnemyList.new()
    self._enemyListCon:addChild(enemyList)
    enemyList:update(self._stageData:getMonsters())
    enemyList:setPosition(125, 2)
    self._formationEnemyList = enemyList

    if self._enemy_powerNode then
        self._enemy_powerNode:updateLabel("Text_zhanli", tostring(powers))
    end
end

function MissionChallengePopupLayout:onExit()
    -- if true then
    --     return
    -- end
    MissionChallengePopupLayout.super.onExit(self)
    
    uf_eventManager:removeListenerWithTarget(self)
    self:removeChild(self._content)
    self._content = nil
    MissionChallengePopupLayout.HAS_INSTANCE = false
    self:removeChild(self._hero)
    self._missionChallengeDiffNodes = nil
    self._showGuideHand = nil
    self._hero = nil
    self._hasSendExecute = false
end

function MissionChallengePopupLayout:_initUI()
    MissionChallengePopupLayout.HAS_INSTANCE = true
    self:_initUI()
end

function MissionChallengePopupLayout:_initUI( ... )
	if self._content == nil then
        self._content = cc.CSLoader:createNode(G_Url:getCSB("ChallengePopup", "guild/mission/pop"))
        self:addChild(self._content)
    end
    self._holder = self._content:getSubNodeByName("Panel_holder")
    self._holder:enableNodeEvents()
    self._holder:setTouchEnabled(true)
    self._holderSize = self._holder:getContentSize()
    self:setTouchSwallowEnabled(false)

    self._csb_width = self._holderSize.width
    self._csb_height = self._holderSize.height

    ccui.Helper:doLayout(self._holder)
    self:setPosition(display.cx-self._csb_width/2,display.cy-self._csb_height/2 - 85)

    self._enemyListCon = self:getSubNodeByName("Node_enemyList")
    self._self_powerNode = self:getSubNodeByName("Node_zhanli_my")
    self._enemy_powerNode = self:getSubNodeByName("Node_zhanli_enemy")

    if self._self_powerNode then
        self._self_powerNode:updateLabel("Text_zhanli", tostring(G_Me.userData.power))
    end

    self:_setFormation()
    ----设置英雄的表现
    self:_setupHeroData()
    self:_showDrops()

    self:_updateResAward()

    -- --设置敌人表现
    self:_updateEnemyView()
    self:_updateExcuteCount()

    --关闭
    self:updateButton("Button_close", function ()
        self:_onRemove()
    end)

    local btn_challenge = self:updateButton("Button_challenge", function ()
       self:_onClickChallenge()
    end)
    UpdateButtonHelper.reviseButton(btn_challenge,{isBig = true,noChange = true})
end

function MissionChallengePopupLayout:_setFormation( ... )
    --布阵
    self:updateButton("Button_formation", 
        {
        callback = function ()
            G_Popup.newPopup(function()
                local commonVsFormation = require("app.scenes.team.lineup.CommonVsFormation").new(
                    SimpleFormationList.TYPE_ENEMY,
                    G_FunctionConst.FUNC_UNION_FUBEN,
                    self._emenyInfo,
                    0 --默认阵容
                    -- function( temp )
                    --     self.useTempFormation = temp--是否使用临时阵容
                    -- end
                )
                commonVsFormation:setBtnText("确 定")
                return commonVsFormation
            end)
        end
    })
end

---设置关卡挑战数据
---@stageData 关卡信息
---@stageIndex 关卡下标
function MissionChallengePopupLayout:setupInfo(stageData, stageIndex)
    self._stageIndex = stageIndex
    self._stageData = stageData
    self._cfgData = self._stageData:getCfg()
    self:_initUI()
    self:_updateExcuteCount()
end

----设置英雄的表现
function MissionChallengePopupLayout:_setupHeroData()
    self:updateLabel("Label_boss_name", {
    	text = self._cfgData.stage_name,
    	textColor = G_Colors.getColor(3),
    	})

    self:_showHero(
        self._cfgData.knight_id,
        self._cfgData.star,
        self._cfgData.exclusive_figure,
        self:getSubNodeByName("Panel_hero_avatar"),
        MissionChallengePopupLayout.HEROSCALE,
        true
    )
end

--重置回调
function MissionChallengePopupLayout:_onRestCallBack()
    G_Popup.tip(G_LangScrap.get("mission_reset_success"))
    --self._stageData = G_Me.allChapterData:getStageDataById(self._stageData:getId())
    self:_initUI()--刷新 主要是刷新按钮的
end

--体力值变化回调
function MissionChallengePopupLayout:_onVitChange()
    self:_initUI()--刷新 主要是刷新按钮的
end

--设置选择的队伍id
function MissionChallengePopupLayout:_onFormationSelected( value )
    self._formationSelected = value.id
end

--展示掉落奖励
function MissionChallengePopupLayout:_showDrops()
    --挑战奖励
    local award_node = self:getSubNodeByName("Node_award")
    local icon_node = award_node:getChildByName("FileNode_reward")
    
    UpdateNodeHelper.updateCommonIconItemNode(icon_node,{
    	type = self._cfgData.challenge_award_type,
    	value = self._cfgData.challenge_award_value,
    	nameVisible = false,
    	sizeVisible = false,
    	levelVisible = false,
    	scale = 0.8
    	})

    -- name
    local params = G_TypeConverter.convert({type = self._cfgData.challenge_award_type,
    	value = self._cfgData.challenge_award_value
    	})
    award_node:updateLabel("Text_reward_name", {
    	text = params.cfg.name,
    	textColor = params.icon_color,
    	})

    --num
    local minNum = self._stageData:getMinReward()
    local maxNum = self._stageData:getMaxReward()
    award_node:updateLabel("Text_reward_num", {
    	text = tostring(minNum).."-"..tostring(math.floor(maxNum)),
    	textColor = G_Colors.getColor(3),
    	})
    award_node:updateLabel("Text_reward_num_title", {
    	text = "数量：",
    	textColor = G_Colors.getColor(3),
    	})

    --击杀提示
    local awardParam = G_TypeConverter.convert({type = self._cfgData.kill_award_type,
    	value = self._cfgData.kill_award_value
    	})
    award_node:updateLabel("Text_reward_tip1", {
    	text = G_Lang.get("mission_guild_reward_tip1"),
    	textColor = G_Colors.getColor(2),
    	})
    award_node:updateImageView("Image_kill_reward", {
    	texture = awardParam.icon_mini
    	})
    award_node:updateLabel("Text_dead_reward_num", {
    	text = G_Lang.get("mission_guild_reward_tip2",{num = self._cfgData.kill_award_size}),
    	textColor = G_Colors.getColor(2),
    	})
end

---挑战次数更新
function MissionChallengePopupLayout:_updateExcuteCount()
     -- local isboss = self._stageData:getStageFlag()
     -- local count = isboss == true and G_Me.guildMissionData:getBossCount() or G_Me.guildMissionData:getNormalCount()
     local count = G_Me.guildMissionData:getNormalCount()
     self:updateLabel("Text_challenge_count", {
        text = G_Lang.get("mission_guild_challenge_count",{num = count}),
        textColor = G_Colors.getColor(3),
    })
end

function MissionChallengePopupLayout:_updateResAward( ... )
	--击杀经验
    local node_exp = self:getSubNodeByName("Node_exp")
    local params = G_TypeConverter.convert({type = G_TypeConverter.TYPE_CONTIRBUTION,size = 0,value = 0})
    node_exp:updateImageView("Image_guild_exp", {
        texture = params.icon_mini,
        })
    node_exp:updateLabel("Text_dead_exp_title", {
    	text = "击杀奖励：",
    	textColor = G_Colors.getColor(2)
    	})
    node_exp:updateLabel("Label_award_exp", {
    	text = tostring(self._stageData:getDeadExp()).."（"..params.cfg.name.."）",
    	textColor = G_Colors.getColor(3)
    	})
end

function MissionChallengePopupLayout:_onBuyCount(type)
    local ownNum,boughtNum,funId = 0,0,0
    if type == 1 then
        boughtNum = G_Me.guildMissionData:getNormalBoughtCount()
        ownNum = G_Me.guildMissionData:getNormalCount()
        funId = G_VipConst.FUNC_TYPE_GUILD_MISSION_NORMAL
    else
        boughtNum = G_Me.guildMissionData:getBossBoughtCount()
        ownNum = G_Me.guildMissionData:getBossCount()
        funId = G_VipConst.FUNC_TYPE_GUILD_MISSION_BOSS
    end

    local hasReach = G_Responder.vipTimeOutCheck(
        funId,
        {usedTimes = boughtNum,tips = ""}
    )

    if hasReach then
        return
    end

    G_Popup.newBuyChallengesPopup(funId,ownNum,boughtNum,function(buyNum)
        G_HandlersManager.guildHandler:sendBuyCount(type,buyNum)
    end)
end

-- 挑战
function MissionChallengePopupLayout:_onClickChallenge()
    if not G_Me.guildMissionData:isInOpenPeriod() then -- 优先提示
        G_Popup.tip(G_Lang.get("mission_guild_not_in_period"))
        return
    end

    local counts = G_Me.guildMissionData:getNormalCount()
    if counts <= 0 then
        self:_onBuyCount(1)
        return
    end

    if G_Me.guildMissionData:isInOpenPeriod() and not self._hasSendExecute then
        self._hasSendExecute = true
        G_HandlersManager.guildHandler:sendExecute(self._stageData:getID())
    elseif not G_Me.guildMissionData:isInOpenPeriod() then
        G_Popup.tip(G_Lang.get("mission_guild_not_in_period"))
    else
        G_Popup.tip(G_Lang.get("mission_guild_stage_finish"))
    end
end

---重置副本
function MissionChallengePopupLayout:_onReset()
    local mainFuncId = G_VipConst.FUNC_TYPE_MAIN_LINE
    local usedTimes = self._stageData:getResetCount()
    local isTimeOut = G_Responder.vipTimeOutCheck(mainFuncId, {
        usedTimes = usedTimes,
        tips = G_LangScrap.get("mission_reset_time_out") 
    })

    if not isTimeOut then ---当前还有重置次数
        local currentValue = G_Me.vipData:getVipTimesByFuncId(mainFuncId)
        local timeLast = currentValue - usedTimes
        local costGold = G_Me.vipData:getVipBuyTimeCost(mainFuncId, usedTimes)

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

-----获得可以挑战的次数
function MissionChallengePopupLayout:_getBattleTime(chapterType)
    local allNum = 0
    if chapterType == ChapterConfigConst.NORMAL_CHAPTER then
        allNum = G_Me.userData.vit
    elseif chapterType == ChapterConfigConst.ELITE_CHAPTER then
        allNum = G_Me.userData.spirit
    end
    
    local maxTime = math.floor(allNum / self._cost)
    
    if maxTime == 0 or maxTime > MissionChallengePopupLayout.MAXATTACKTIME then
        maxTime = MissionChallengePopupLayout.MAXATTACKTIME     
    end

    local lastTime = self._inforData.challenge_num - self._stageData:getExcuteCount()
    maxTime =  maxTime >= lastTime and lastTime or maxTime
    
    return maxTime
end

function MissionChallengePopupLayout:_onRemove()
    self:removeFromParent()
end

return MissionChallengePopupLayout